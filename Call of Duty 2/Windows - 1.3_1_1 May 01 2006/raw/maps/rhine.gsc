#include maps\_utility;
#include maps\_anim;
#using_animtree("generic_human");

main()
{	
	if (getcvar("scr_rhine_fast") == "")
		setcvar("scr_rhine_fast","0");

//	setCullFog(0, 5000, .58, .57, .57, 0);
//	setCullFog (1000, 2500, 0.75, .82, .85, 0);
//	setExpFog(0.00025, .75, .80, .85, 0);

	fog = (getcvar("r_forcetechnology") == "" || getcvar("r_forcetechnology") == "default" || getcvar("r_forcetechnology") == "dx9" || getcvar("r_forcetechnology") == "DX9" || getcvarint("r_forcetechnology") == 1);

	if (fog)
		setExpFog(0.00008, .80, .75, .75, 0);

//	setCullDist (8500);

	precacheModel("xmodel/military_tntbomb");
	precacheModel("xmodel/military_tntbomb_obj");
	precacheShader("inventory_tnt_small");

	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");

	precacheString(&"RHINE_PLATFORM_BUFFALO_EXIT");
	precacheString(&"RHINE_EXPLOSIVIES_PLANTED");
	precacheString(&"RHINE_OBJECTIVE_SECURE");
	precacheString(&"RHINE_OBJECTIVE_ELIMINATE");
	precacheString(&"RHINE_OBJECTIVE_TANKS");
	precacheString(&"RHINE_OBJECTIVE_ASSEMBLE");

	level.campaign = "american";	

	level.axis_accuracy = 1.8;
	mg42_harder();

	maps\_flak88::main("xmodel/german_artillery_flak88_nm");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_tiger::main("xmodel/vehicle_tiger_righttread_d");
	maps\_tiger::main("xmodel/vehicle_tiger_lefttread_d");
	maps\_buffalo::main("xmodel/vehicle_ltv4_buffalo");

	maps\rhine_fx::main();
	maps\_load::main();

	level.scr_sound["water_impact"]			= "mortar_explosion_water";
	level.scr_sound["tree_burst"]			= "explo_tree";

	level thread maps\rhine_amb::main();

	maps\rhine_anim::main();

	/* tmp fix for the one script_exploder in prefabs */
	ents = getentarray("prefab_exploder","script_noteworthy");
	ents[0].script_exploder = 100;
	ents[1].script_exploder = 100;

	level.timersused = 0;

	level.sortie_radius = 400;

	level.player.threatbias = 150 + level.player.threatbias;

	level.maxfriendlies = 4;
	level.friendlyMethod = "friendly chains";
	level.friendlywave_thread = ::friendlyMethod;

	level.player.aionchain = 0;

	level.landed = false;
	level.no_reinforcement = false;

	level.player.tnt = 2;
	level.inv_tnt = maps\_inventory::inventory_create("inventory_tnt_small",true);

	level thread setup_sortie();
	level thread setup_retreat();
	level thread setup_fallback();
	level thread setup_contained();
	level thread setup_ai_smoke();
	level thread setup_vehicle_pause();
	level thread setup_vehicle_fire();
	level thread setup_vehicle_aim();
	level thread setup_vehicle_exploder();
	level thread setup_vehicle_section_system();

	// make mg42's fire through smoke.
	aMg42 = getentarray("automg42","script_noteworthy");
	level array_thread(aMg42,::autofire_mg);

	start = getcvar("start");
	if (start == "")
		setcvar("start","");

	if (isdefined(start) && start == "end")
	{
		level.maxfriendlies = 4;
		level.friendlyMethod = "follow player";
		level.player setorigin((5764, 16876, 500));
//		level.player setorigin((8064, 16544, 493));
		level.player setplayerangles((0,300,0));
		level.player thread player_location();

		character_spawn();
		level thread secure_village_objective();
		level thread regroup();

		// make sure no enemies spawn;
		aSpawner = getspawnerteamarray("axis");
		for (i = 0; i < aSpawner.size; i++)
		{
			if (isdefined(aSpawner[i].targetname) && aSpawner[i].targetname == "clear_guy")
				continue;
			aSpawner[i] delete();
		}

		wait 2;
		level notify("secure");
		return;
	}

	// controll where the characters show up in the map
	level thread character_control();

	// special buffalo actions
	level thread setup_vehicle_blow();
	level thread setup_vehicle_deploy();

	level thread tank_wall_burst();

	allies = getaiarray("allies");
	array_thread(allies,::set_follow_dists);

	level thread start();
	level thread objectives();
	level thread tanks();
	level thread extra_savepoints();
}

start()
{
	if (!getcvarint("scr_rhine_fast"))
		exploder(29);
	else
		exploder(32);

	level thread attach_player();

	aVehicle = maps\_vehicle::scripted_spawn(2);
	
	for (i=0; i < aVehicle.size; i++)
	{
		level thread maps\_vehicle::gopath(aVehicle[i]);
		
		aVehicle[i] thread buffalo_water_fx();
	}

	defenders = getentarray("defenders","targetname");
	flood_spawn(defenders);

	flaks = getentarray("flak88","script_noteworthy");
	level thread array_thread(flaks,::flak88_fire);

	node = getnode("first_chain","targetname");
	level.player setfriendlychain(node);

	node = getnode("center","targetname");

	aAi = getaiarray("allies");
	for (i=0; i < aAi.size; i++)
	{
		// Make the missionfail if the player hurts friendlies.
		aAi[i] thread missionfailedondamage();

		if (isdefined(aAi[i].script_noteworthy) && aAi[i].script_noteworthy == "my_guy")
			aAi[i] thread on_unload();
		else if (isdefined(aAi[i].script_noteworthy) && aAi[i].script_noteworthy == "randall")
		{
			aAi[i] thread setup_randall();
			aAi[i] thread on_unload();
		}
		else if (isdefined(aAi[i].script_noteworthy) && aAi[i].script_noteworthy == "mccloskey")
		{
			aAi[i] thread setup_mccloskey();
			aAi[i] thread on_unload();
		}
		else
			aAi[i] thread on_unload(node);
	}

	wait 15;
	level.randall Dialogue_Thread("rhine_rnd_suppress");

	wait 10;
	level.randall Dialogue_Thread("rhine_rnd_doingood");

	wait 7;
	level.randall Dialogue_Thread("rhine_rnd_mined");

	if (!level.landed)
		level waittill("landed");

	level thread beach_charge();


	level thread controlPlayerStance_inWater();

	if (!getcvarint("scr_rhine_fast"))
		setCullDist (6500);
	else
		setCullDist (5000);

	level thread setup_beach_reinforcement();

	level thread delay_warning();
//	level.randall Dialogue_Thread("rhine_rnd_amtrac");

	// remove the temp ground that the player buffalo drove on.
	buffalo_ground = getent("buffalo_ground","targetname");
	buffalo_ground delete();

	level thread autoSaveByName("landing");

	level waittill("player dismounted");

	wait 3;
	level.randall Dialogue_Thread("rhine_rnd_hardway");
	wait 8;
	level.randall Dialogue_Thread("rhine_rnd_ontheline");
	wait 4;
	level.randall Dialogue_Thread("rhine_rnd_throwsmoke");
}

missionfailedondamage()
{
	self endon("unload");
	level endon("player dismounted");

	while(1)
	{
		self waittill("damage", amount, attacker);
		if(attacker == level.buffalo)
			break;
	}

	setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN");
	maps\_utility::missionFailedWrapper();
}

delay_warning()
{
	level endon("player dismounted");
	wait 4;

	if (level.xenon)
		iprintlnbold(&"RHINE_PLATFORM_BUFFALO_EXIT", getKeyBinding("+usereload")["key1"]);
	else
		iprintlnbold(&"RHINE_PLATFORM_BUFFALO_EXIT", getKeyBinding("+activate")["key1"]);

	level.randall thread Dialogue_Thread("rhine_rnd_amtrac");

}

beach_charge()
{
	trigger = getent("charge","targetname");
	trigger waittill("trigger");

	aAI = getaiarray("allies");
	for (i=0; i < aAi.size; i++)
	{
		if (!isdefined(aAi[i].onchain))
			aAi[i] delete();
	}

	aSpawner = getentarray("charge_guy","targetname");

	for (i=0; i < aSpawner.size; i++)
	{
		ai = aSpawner[i] dospawn();
		if (spawn_failed(ai))
			continue;
		ai thread ignoreme_timed(10);
		ai thread ai_delete("charge");
	}
}

waittill_player_leave_buffalo(maxtime)
{
	level endon("destroy buffalo");
	ent = self getvehicleowner();
	i = 0;
	while (isdefined(ent))
	{
		wait 1;
		i++;
		if (i > maxtime)
			break;
		ent = self getvehicleowner();
	}

	level notify("player dismounted");
}

destroy_buffalo(buffalo)
{
	level waittill("landed");

	buffalo waittill_player_leave_buffalo(5); // will return once the player leaves the buffalo or after 5 seconds.

/*	ent = buffalo getvehicleowner();
	if (isdefined(ent))
		buffalo waittill_player_leave_buffalo(5); // will return once the player leaves the buffalo or after 5 seconds.

*/
	timer = 0;
	while ( distance( level.player getorigin(), buffalo getorigin() ) < 350)
	{
		if (timer > 20)
			break;
		wait .5;
		timer++;
	}

	flak3 = getent("flak4","targetname");
	flak3 clearTurretTarget();
	flak3.script_accuracy = 0;
	flak3 setTurretTargetEnt( buffalo, (0, 0, 35));
	
	flak3 waittill("turret_on_target");
	flak3 notify("turret_fire");

/*	ent = buffalo getvehicleowner();
	if (isdefined(ent))
	{
		buffalo useby (level.player);
		buffalo notify("death");
		wait .25;
		level.player enableHealthShield( false );
		level.player dodamage(level.player.health * 2, (0,0,0));
		level.player enableHealthShield( true );
	}
	else
		buffalo notify("death");
*/

	buffalo notify("death");
	wait 0.05;

	if (distance(level.player.origin, buffalo.origin) < 200)
		killplayer();


}

killplayer()
{
	level.player enableHealthShield( false );
	level.player doDamage (level.player.health * 1.25, level.player.origin); //killplayer
	level.player enableHealthShield( true );
}

attach_player()
{
	level.buffalo = maps\_vehicle::waittill_vehiclespawn("player_lvt");

	level.buffalo clearTurretTarget();
	level.buffalo useby (level.player);
	wait 1;
	level.player setplayerangles(level.buffalo.angles);
	wait 1;
	level.player setplayerangles(level.buffalo.angles);
	level.buffalo waittill("reached_end_node");

	// wait 1.5 seconds so that the ai can a chanse to get out.
	wait 2.5;
	level.buffalo makevehicleusable();

	level thread destroy_buffalo(level.buffalo);

	level.landed = true;
	level notify("landed");
}

on_unload(node)
{
	self endon("death");
	self waittill("unload");

	self thread ignoreme_timed(6);
	self.old_interval = self.interval;
	self.interval = 0;

	if (isdefined(node) && isalive(self))
		self thread follow_path(node);
	else
		self thread friendlyMethod();

	wait 6;
	self.interval = self.old_interval;

}

setup_beach_reinforcement()
{
	level endon("stop beach reinforcement");

	wait 10;

	center_path = getnode("center","targetname");
	right_path = getnode("right","targetname");

	level thread beach_reinforcement(3,center_path);
	wait 3;
	level thread beach_reinforcement(4,center_path);
	wait 3;
	level thread beach_reinforcement(5,right_path);

	while(true)
	{
		level waittill("reinforcement",id,node);
		level thread beach_reinforcement(id,node);
	}
}

allied_count()
{
	aAi = getaiarray("allies");
	return aAi.size;
}

beach_reinforcement(id,node)
{
	assert(isdefined(node));

	mgguy = undefined;

	while (allied_count() > 8 || level.player.angles[1] < 0) { wait 1; }

	if (level.no_reinforcement)
		return;

	aVehicle = maps\_vehicle::scripted_spawn(id);
	assert(aVehicle.size == 1); // should just be one vehicle per reinforcement path.
	
	vehicle = aVehicle[0];
	
	vehicle thread buffalo_water_fx();
	
	vehicle thread beach_reinforcement_destroy(); // cansle any lingering transports

	level thread maps\_vehicle::gopath(vehicle);

	wait 1; // let riders become populated.
	riders = vehicle.riders;

	vehicle waittill("unload");

	level notify("reinforcement",id,node);

	if (isdefined(riders))
	{
		for (i=0; i < riders.size; i++)
		{
			if (!isalive(riders[i]))
				continue;
			if (i == 1)
				mgguy = riders[i];
			if (level.player.aionchain < 6)
			{
				riders[i] thread maps\_spawner::friendlydeath_thread();
				riders[i] thread friendlyMethod();
				riders[i] thread ignoreme_timed(6);
			}
			else
			{
				riders[i] thread follow_path(node);
				riders[i] thread ignoreme_timed(3,true);
			}
		}
	}

	vehicle waittill("reached_end_node");

//	if (isdefined(mgguy))
//		mgguy delete();
	wait 1;
	vehicle notify ("delete");
	wait .1;
	if(isdefined(vehicle))
		vehicle delete();
}

beach_reinforcement_destroy()
{
	self endon("death");
	self endon("delete");

	level waittill("stop beach reinforcement");
	level.no_reinforcement = true;
	// remove the guys not the ai.
	for (i=0; i<self.riders.size;i++)
	{
		if (isdefined(self.riders[i]) && isalive(self.riders[i]))
		{
			self.riders[i] delete();
		}
	}
}


ignoreme_timed(time,chain)
{
	self endon("death");
	level endon("stop beach reinforcement");

	old_maxsightdistsqrd = self.maxsightdistsqrd;
	self.maxsightdistsqrd = (256*256);
	self clearEnemyPassthrough();
	self.ignoreme = true;
	self.old_suppressionwait = self.suppressionwait;
	self.suppressionwait = 0;
	wait 3;
	self.maxsightdistsqrd = old_maxsightdistsqrd;
	self.suppressionwait = self.old_suppressionwait;
	wait time;
	self.ignoreme = false;
}

objectives()
{
	wait 4;
	level thread secure_village_objective();
	level thread flak_objective();
	level thread tank_objective();
	level thread regroup();
}

secure_village_objective()
{
	ent = getent("clear_obj","targetname");

	level waittill("secure");

//	trigger = getent("tank_help","targetname");
//	trigger triggeron();

	objective_add(2,"active",&"RHINE_OBJECTIVE_SECURE", ent.origin);
	objective_current(2);

	// move all ai to node "clear_goal"
	node = getnode("clear_goal","targetname");

	ai = getaiarray("axis");
	for (i=0; i < ai.size; i++)
	{
		ai[i] endon("escape your doom");
		ai[i] setgoalnode(node);
		ai[i].goalradius = node.radius;
	}

	// spawn a bunch of new guys.
	aClear_guy= getentarray("clear_guy","targetname");
	flood_spawn(aClear_guy);

	node = getnode("randal_pre_end_goal","targetname");

	level.randall notify("stop follow");
	level.randall Dialogue_Thread("rhine_rnd_guarddown");
	level.randall setgoalnode(node);
	level.randall.goalradius = node.radius;

	level.randall waittill("goal");

	trigger = getent("pre_end_trigger","targetname");
	trigger waittill("trigger");

	// spaws black and co and teleports randall to the graveyard
	level thread spawn_blake_co();	

	// returns if the player gets to close to the graveyard or when all axis are dead.
	clear_wait();

	level notify("village secure");
}

clear_wait()
{
	level endon("clear end");
	level thread clear_end();
	level thread clear_timeout();

	ai = getaiarray("axis");
	while(ai.size)
	{
		if (ai.size < 4)
			level notify("clear start timeout");
		wait 1;
		ai = getaiarray("axis");
	}

	wait randomfloat(2);
}

clear_end()
{
	trigger = getent("clear_end_trigger","targetname");
	trigger waittill("trigger");
	ai = getaiarray("axis");
	level thread array_thread(ai,::kill_ai);
	level notify("clear end");
}

clear_timeout()
{
	level waittill("clear start timeout");
	wait 10;
	ai = getaiarray("axis");
	level thread array_thread(ai,::kill_ai);
}

kill_ai()
{
	self endon("death");
	wait randomfloat(2);
	self dodamage(self.health * 1.5, level.player.origin);
}

flak_objective()
{
	ent = spawnstruct();
	ent.count = 5;
	ent.id = 0;
	
	objective_add(0,"active");
	objective_string(0,&"RHINE_OBJECTIVE_ELIMINATE",ent.count);
	objective_current(0);

	aTrigger = getentarray("flak_objective","targetname");
	for (i=0; i<aTrigger.size; i++)
			aTrigger[i] thread flak_obj_tracker(ent,i);

	while(true)
	{
		level waittill("flak down",id);
		level thread autoSaveByName("flak_down");
		if (ent.count == 0)
			break;
		objective_string(0,&"RHINE_OBJECTIVE_ELIMINATE",ent.count);

		// put ai on next friendly chain.
		if (id == 0)
		{
			chaintrigger = getent("flak2chain","targetname");
			aNode = getnodearray(chaintrigger.target,"targetname");
			level.player setfriendlychain(aNode[0]);
			flak2_chain_off();
		}
		else if (id == 1)
		{
			chaintrigger = getent("flak3chain","targetname");
			aNode = getnodearray(chaintrigger.target,"targetname");
			level.player setfriendlychain(aNode[0]);
		}

		if (ent.count == 4)
		{
			// less friendlies to make it harder as well as quicker.
			level.maxfriendlies = 4;

			if (!getcvarint("scr_rhine_fast"))
			{
				setCullDist (5000); // a litle frame rate tweek after the first flak is down.
			}
			else
			{
				setCullDist (4000); // a litle frame rate tweek after the first flak is down for minspec.
				level.maxfriendlies = 4;
			}

			if (level.player.aionchain > 3)
				level notify("stop beach reinforcement");
		}
		else if (ent.count == 3)
			level notify("stop beach reinforcement");
		else if (ent.count == 2)
			level.sortie_radius = 720;

	}
	objective_string_nomessage(0,&"RHINE_OBJECTIVE_ELIMINATE",ent.count);
	objective_state(0,"done");
	level notify("tank objective");
}

flak2_chain_off()
{
	trigs = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigs.size;i++)
	if ((isdefined (trigs[i].target)) && (trigs[i].target == "auto365"))
	{
		trigs[i].origin = trigs[i].origin + (0,0,-5000);
	}
}

flak_obj_tracker(ent,id)
{
	objective_additionalposition(0,id,self.origin);
	if (isdefined(self.target))
	{
		level waittill("tank");
		wait 5;
	}
	else
	{
		self waittill("trigger");
		wait randomfloat(5) + 4;
	}
	objective_additionalposition(0,id,(0,0,0));
	ent.count--;
	level notify("flak down",id);
}

tank_friendlies()
{
	wait 5;
	
	level.mccloskey Dialogue_Thread("US_0_threat_vehicle_tiger");
	wait 1;
	level.randall Dialogue_Thread("rhine_rnd_fallbackcover");

	level.maxfriendlies = 4;
	level.friendlyMethod = "follow player";

	ai = getaiarray("allies");
	array_thread(ai,::tank_cover);

	node = getnode("tank_cover","targetname");
	trigger = spawn( "trigger_radius", node.origin, 0, 256, 256);
	trigger thread timed_trigger(30);
	trigger waittill("trigger");
	wait 5;

	level notify("follow_player");
	level.player thread player_location();
}

timed_trigger(time)
{
	wait time;
	self notify("trigger");
	self delete();
}

tank_cover()
{
	self endon("death");
	node = getnode("tank_cover","targetname");
	self setgoalnode(node);
	self.goalradius = node.radius;
	level waittill("follow_player");
	self.follow_delay = 2;
	self thread player_follow();
}

tank_objective()
{
	level.tank_objectives = 2;

	level.sortie_radius = 512;

	level waittill("tank objective");

	objective_add(1,"active");
	objective_string(1,&"RHINE_OBJECTIVE_TANKS", level.tank_objectives);
	objective_current(1);
	level thread tank_objective_wait();
	level notify("show tanks");

	wait 10;

	level.mccloskey Dialogue_Thread("flankem");
	wait 1;
	level.randall Dialogue_Thread("useflaks");
	wait 7;
	if (level.tank_objectives)
	{
		level.randall Dialogue_Thread("rhine_rnd_immobilize");
		wait 15;
	}

	if (level.tank_objectives)
	{
		level.randall Dialogue_Thread("rhine_rnd_tnt");
		wait 7;
	}
	
	if (level.tank_objectives)
		level waittill("all tanks down");

	wait 2;
	level.randall Dialogue_Thread("goodjob");

	objective_state(1,"done");
	level notify("secure");

}

tank_objective_wait()
{
	id = 0;

	while(level.tank_objectives)
	{
		level waittill("tank destroyed",id);
		level.tank_objectives--;

		if (level.tank_objectives > 0)
			objective_string(1,&"RHINE_OBJECTIVE_TANKS", level.tank_objectives);
		else
			objective_string_nomessage(1,&"RHINE_OBJECTIVE_TANKS", level.tank_objectives);

		level thread autoSaveByName("tank_down");
		objective_additionalposition(1, id, (0,0,0));
	}
	level notify("all tanks down");
}

tanks()
{
	tank_trigger = getent("tiger_1","targetname");
	tank_trigger waittill("trigger");

	guys = getentarray("pre_tank_guy","targetname");
	level thread flood_spawn(guys);

	// more pre tank guys that will kick the players ass.
	if (!getcvarint("scr_rhine_fast"))
	{
		guys = getentarray("pre_tank_guy_2","targetname");
		level thread flood_spawn(guys);
	}

	level notify("tank");

	level thread tank_friendlies();

	flak0 = getent("flak0","targetname");
	flak1 = getent("flak1","targetname");
	flak0 thread flak_proximity();
	flak1 thread flak_proximity();

	aVehicle = maps\_vehicle::scripted_spawn(0);
	tiger_1 = aVehicle[0];
	tiger_1.grenadetank_dist = 350;
	tiger_1 thread tank_reinforcement();
	tiger_1 thread tank_location();
	tiger_1 thread tank_explosives();
	tiger_1 thread flak_destroy();

	level thread maps\_vehicle::gopath(tiger_1);

	tiger_1.pos_id = 0;
	tiger_1 thread objective_follow(1,"show tanks");

	wait 1;

	aVehicle = maps\_vehicle::scripted_spawn(1);
	tiger_2 = aVehicle[0];
	tiger_2.grenadetank_dist = 350;
	tiger_2 thread tank_reinforcement();
	tiger_2 thread tank_location();
	tiger_2 thread tank_explosives();
	tiger_2 thread flak_destroy();

	level thread maps\_vehicle::gopath(tiger_2);

	tiger_2.pos_id = 1;
	tiger_2 thread objective_follow(1);

	wait 20;

	trigger = getent("tank_help","targetname");
	trigger delete();
}

flak_destroy()
{
	self endon("death");

	while(true)
	{
		level waittill("destroy flak",flak);

		target = self.curr_target;
		if (!isdefined(target) || !isdefined(target.script_idnumber))
			continue;
		if (int(target.script_idnumber) == int(flak.script_flak88) && flak.proximity)
		{
			self.node_action = true;

			self setturrettargetent(flak,(0,0,48));
			self waittill("turret_on_vistarget");

			// temp fix i hope to a script error. 
			owner = flak getvehicleowner();
			if (isdefined(owner) && owner == level.player)
				flak useby(level.player);
			wait .1;

			self notify("turret_fire");
			flak dodamage(flak.health * 2, (0,0,0));
			flak notify("death");

			self notify("node action done");
		}
	}
}

flak_proximity()
{
	self endon("death");

	if (!isdefined(self.proximity))
		self.proximity = false;
	if (!isdefined(self.proximity_trigger))
		self.proximity_trigger = spawn( "trigger_radius", self.origin, 0, 350, 256);

	while(true)
	{
		self.proximity_trigger waittill("trigger");
		self.proximity = true;
		level notify("destroy flak",self);
		wait 1;
		self.proximity = false;
	}
}


tank_wall_burst()
{
	vnode = getvehiclenode("wall_burst","script_noteworthy");
	vnode  waittill("trigger");

	tree = getent("tree","targetname");
	wait .5;
	exploder(101);
	tree rotateto((10,0,25), .75, .74);
	wait .5;
	exploder(0);
	wait .25;
	tree rotateto((55,0,0), 2, 2);
	wait 2;
	tree rotateto((74,-12,0), .75, .74);
}

regroup()
{
	level waittill("village secure");

	battleChatterOff("allies");

	objective_state(2,"done");
	scene_trigger = getent("final_scene_trigger","targetname");
	objective_add(3,"active",&"RHINE_OBJECTIVE_ASSEMBLE", scene_trigger.origin);
	objective_current(3);

	wait 2;

	exclude = [];
	exclude[0] = level.blake;
	closest_ai = getClosestAIExclude(level.player.origin, "allies", exclude);

	if (isdefined(closest_ai))
	{
		closest_ai.animname = "randall";
		level.randall.animname = "randall";
		level.randall Dialogue_Thread("rhine_rnd_fellas");
	}

	else
	{
		level.randall.animname = "randall";
		level.randall Dialogue_Thread("rhine_rnd_fellas");
	}

	wait 2;
	thread music();

	if (!(level.player istouching(scene_trigger)))
	{
		if (isdefined(closest_ai) && isalive(closest_ai))
			closest_ai Dialogue_Thread("assemble");
		else
			level.randall Dialogue_Thread("assemble");
		wait 2;
	}

	level notify("stop follow");

	battleChatterOff("allies");

	aNode = getnodearray("final_scene_goal","targetname");
	aAllies = getaiarray("allies");

	for (i=0; i<aAllies.size; i++)
	{
		if (aAllies[i] == level.randall || aAllies[i] == level.blake || aAllies[i] == level.aide)
			continue;
		aAllies[i] setgoalnode(aNode[i]);
		aAllies[i].goalradius = 0;
	}		   

	scene_trigger waittill("trigger");

	objective_state(3,"done");

	thread music_end();

/*	level.blake.walk_noncombatanim = %unarmed_walk_slow;
	level.blake.walk_noncombatanim2 = %unarmed_walk_slow;

	level.aide.walk_noncombatanim = %armed_walk_slow;
	level.aide.walk_noncombatanim2 = %armed_walk_slow;

	level.blake.walkdist = 10000;
	level.aide.walkdist = 10000;
*/

	guys[0] = level.blake;
	guys[1] = level.randall;
	guys[2] = level.aide;

	level.blake.walkdist = 512;
	level.blake.walk_noncombatanim = %unarmed_walk_russian;
	level.blake.walk_noncombatanim2 = %unarmed_walk_russian;
	level.blake.interval = 0;
	level.blake	pushPlayer(true);
	level.aide.walkdist = 512;
	level.aide.walk_noncombatanim = %patrolwalk_tired;
	level.aide.walk_noncombatanim2 = %patrolwalk_tired;
	level.aide.interval = 0;
	level.aide pushPlayer(true);

	level maps\_anim::anim_reach(guys, "final_scene");
	level thread maps\_anim::anim_single(guys, "final_scene");

	wait 30;

	level.blake setgoalpos( (7458, 15120, 420) );
	level.aide setgoalpos( (7570, 15103, 420) );
	level.randall setgoalpos(level.randall.origin);

	wait 8.5;

	maps\_endmission::nextmission();
}

spawn_blake_co()
{
	aSpawner = getentarray("final_scene_guy", "targetname");

	blake_node = getnode("blake_dialogue_node","targetname");
	aide_node = getnode("aide_dialogue_node","targetname");
	randall_node = getnode("randall_dialogue_node","targetname");

	level.maxfriendlies = 8;

	for (i=0; i < aSpawner.size; i++)
	{
		ai = aSpawner[i] stalingradspawn();
		if (spawn_failed(ai))
		{
			assertmsg("blake and co didn't spawn");
		}

		ai setBattleChatter(false);
		ai.ignoreme = true;

		if (isdefined(aSpawner[i].script_noteworthy))
		{
			level.blake = ai;
			level.blake.animname = "blake";
			level.blake setgoalnode(blake_node);
			level.blake.goalradius = 0;
			level.blake.anim_node = blake_node;
		}
		else
		{
			level.aide = ai;
			level.aide.animname = "aide";
			level.aide setgoalnode(aide_node);
			level.aide.goalradius = 0;
			level.aide.anim_node = aide_node;
		}
	}

	level.randall teleport(randall_node.origin,randall_node.angles);
	level.randall setBattleChatter(false);
	level.randall setgoalnode(randall_node);
	level.randall.goalradius = 0;
	level.randall.ignoreme = true;
	level.randall.anim_node = randall_node;

	level.blake animscripts\shared::putGunInHand ("none");

	level.blake.anim_node thread maps\_anim::anim_loop_solo(level.blake, "final_scene_idle",undefined,"end idel",level.blake.anim_node);
	level.aide.anim_node thread maps\_anim::anim_loop_solo(level.aide, "final_scene_idle",undefined,"end idel",level.aide.anim_node);
	level.randall.anim_node thread maps\_anim::anim_loop_solo(level.randall, "final_scene_idle",undefined,"end idel",level.randall.anim_node);

}

planes()
{
	plane = sky_makeplane("spitfire2");
	plane thread plane_sound(4.9,"plane_flyby_spitfire3");
	wait 4;
	plane2 = sky_makeplane("spitfire3");
	plane2 thread plane_sound(2.2,"plane_flyby_spitfire1");

/*	plane waittill("reached_end_node");
	plane delete();
	plane2 waittill("reached_end_node");
	plane2 delete();
*/
}

plane_sound(delay,sound)
{
	wait delay;
	self playsound(sound);
}

sky_makeplane(name, speed)
{
	node = getVehicleNode( name, "targetname" );


		plane = spawnVehicle( "xmodel/vehicle_spitfire_flying", "plane", "stuka", (0,0,0), (0,0,0) );
		plane setmodel ("xmodel/vehicle_spitfire_flying");
	
	plane attachPath( node );
	plane startPath();
	if(isdefined(speed))
		plane setspeed(speed, speed);
	
	return plane;
}

setup_randall()
{
	level.randall = self;
	level.randall.animname = "randall";
	level.randall.magicbulletshield = true;
	level.randall thread magic_bullet_shield();
}

setup_mccloskey()
{
	level.mccloskey = self;
	level.mccloskey.animname = "mccloskey";
	level.mccloskey.magicbulletshield = true;
	level.mccloskey thread magic_bullet_shield();
}

mg42_harder()
{
	mg42s = getEntArray( "misc_turret", "classname" );
	
	difficulty = getdifficulty();

	for ( index = 0; index < mg42s.size; index++ )
	{
		switch( difficulty )
		{
			case "easy":
				mg42s[index].script_skilloverride  = "medium";
				break;
			case "medium":
				mg42s[index].script_skilloverride  = "hard";
				break;
			case "hard":
				mg42s[index].script_skilloverride  = "fu";
				break;
			case "fu":
				mg42s[index].script_skilloverride  = "fu";
				break;
			default:
				continue;
		}
	}
}

buffalo_water_fx()
{
	waterZ = 6;
		
	self endon ("death");
	for (;;)
	{
		if (self getSpeed() >= 3)
		{
			//wake
			//----
			fxOrigin = self getTagOrigin("tag_wake");
			fxOrigin = (fxOrigin[0], fxOrigin[1], waterZ);
			
			ang = self getTagAngles("tag_wake");
			ang = (0,ang[1],0);
			
			fxVec = anglestoup(ang);
			
			playfx(level._effect["buffalo"]["wake"], fxOrigin, fxVec);
			playfx(level._effect["buffalo"]["sidesplash"], fxOrigin, fxVec);
			
		}
		wait 0.8;
	}
}

/**** utility ****/

nocover_radiusdamage(org, rad, max, min)
{
	assert(max > min);
	max = max - min;

	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		dist = distance (org, ai[i].origin);
		if (dist > rad)
			continue;
			
		ai[i] DoDamage (max * (1 - (dist/rad)) + min, org);
	}

	dist = distance (org, level.player.origin);
	if (dist > rad)
		return;
		
	level.player DoDamage (max * (1 - (dist/rad)) + min, org);
}

autofire_mg()
{
	self endon("stop autofire");
	aBullseye = getentarray(self.target,"targetname");
	index = 0;
	while(true)
	{
		bullseye = aBullseye[index];

		self settargetentity(bullseye);

		wait randomfloatrange(2,4);
		index++;
		if (index >= aBullseye.size)
			index = 0;
	}
}

extra_savepoints()
{
	aTrigger =getentarray("savepoint","targetname");
	array_thread(aTrigger,::savepoint_wait);

	while (true)
	{
		level waittill("savepoint",id);
		switch(int(id))
		{
			case 1:
				level thread autoSaveByName("crossroad");
				break;
			case 2:
				level thread autoSaveByName("cemetery");
				break;
			case 3:
				level thread autoSaveByName("square");
				break;
			case 4:
				level thread autoSaveByName("crossroad");
				break;
			case 5:
				level thread autoSaveByName("crossroad");
				break;
		}
	}
}

savepoint_wait()
{
	self waittill("trigger");
	level notify("savepoint",self.script_noteworthy);
}

Dialogue_Thread(dialogue,node)
{
	self endon("death");

	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
		self waittill ("my done speaking");

	self.MyIsSpeaking = true;
	self setBattleChatter(false);

	if (isdefined(node))
	{
		self maps\_anim::anim_reach_solo(self, dialogue, undefined, node);
		self maps\_anim::anim_single_solo(self, dialogue, undefined, node);
	}
	else
		self maps\_anim::anim_single_solo(self, dialogue);

	self setBattleChatter(true);
	self.MyIsSpeaking = false;
	self notify ("my done speaking");
}

flak88_fire()
{
	self.autoTarget = false;
	target = getent(self.target, "targetname");
	self setTurretTargetEnt( target, (0, 0, 0));
	self setVehicleTeam( "axis" );

	level waittill("player dismounted");
	wait 12;
	self setVehicleTeam( "allies" );
	self.script_team = "allies";
	self makevehicleusable();
}


friendlyMethod(guy)
{
	if (!isdefined (guy))
		guy = self;
	
	if (level.friendlyMethod == "friendly chains")
	{
		guy.friendlyWaypoint = false;
		guy set_follow_dists();
		guy clearEnemyPassthrough();
		guy setgoalentity(level.player);
		if (!isdefined(guy.onchain))
			guy thread on_chain();
	}
	else if (level.friendlyMethod == "follow player")
	{
		guy.friendlyWaypoint = false;
		guy set_follow_dists();
		guy thread player_follow();
	}
}

follow_path(node)
{
	self endon("death");

	self setgoalnode(node);
	self.goalradius = node.radius;

	while(isdefined(node.target))
	{
		self waittill("goal");
		if (isdefined(node.script_wait))
			wait node.script_wait;
		node = getnode(node.target,"targetname");
		assert(isdefined(node));
		self setgoalnode(node);
		self.goalradius = node.radius;
	}
	if (isdefined(node.script_noteworthy))
	{
		self waittill("goal");
		if (isdefined(node.script_wait))
			wait node.script_wait;
		wait randomfloat(5) + 0.1;
		self dodamage(self.health * 1.5, (0,0,0));
	}
}

on_chain()
{
	self.onchain = true;
	level.player.aionchain++;
	self.on_friendly_chain = true;
	self waittill("death");
	level.player.aionchain--;
}

player_location()
{
	// the longer the player stays in the same place the bigger that place becomes before he get a new location.

	min_distance = 128;

	self endon("death");
	old_origin = (0,0,0);
	i = 0;
	while (true)
	{
		if (i < 8)
			i++;
		current_dist = distance(old_origin,self.origin);
		dist_to_cover = min_distance + (i*24);
		if (current_dist > dist_to_cover)
		{
//			if (i > 4)
//				i = int(i/2);
//			else
				i = 0;
			self notify("new location");
			old_origin = self.origin;
		}
		wait 1;
	}
}

player_follow()
{
	level endon("stop follow");
	self endon("stop follow");
	self endon("death");

	assert(isdefined(self.follow_delay));

	if ( isdefined(self.runupactive) && self.runupactive)
		return;

	while(true)
	{
		wait randomfloat(self.follow_delay) + 0.1;
		goal = level.player.origin;
		self.goalradius = 512;
		self setgoalpos(goal);
		self thread ai_at_goal();
		level.player waittill("new location");
	}
}

ai_at_goal()
{
	level.player endon("new location");
	self waittill("goal");
	self.goalradius = 350;
}

set_follow_dists()
{
	self.pathEnemyLookAhead = 256;
	self.pathEnemyFightDist = 512;

	if (self.classname ==  "actor_ally_ranger_nrmdy_reg_garand" || self.classname == "actor_ally_ranger_nrmdy_reg_BAR")
	{
		self.followmax = -2;
		self.followmin = -4;
		self.follow_delay = 2;
	}
	if (self.classname ==  "actor_ally_ranger_nrmdy_randall" || self.classname ==  "actor_ally_ranger_nrmdy_mccloskey")
	{
		self.followmax = -2;
		self.followmin = -4;
		self.follow_delay = 0;
	}
	else
	{
		self.followmax = 2;
		self.followmin = -1;
		self.follow_delay = 0;
	}
}

setup_fallback()
{
	aSpawner = getentarray("fallback","script_noteworthy");
	level array_thread(aSpawner, ::fallback);

	aTrigger = getentarray("fallback","targetname");
	level array_thread(aTrigger, ::fallback_trigger);

}

fallback_trigger()
{
	self waittill("trigger");
	node = getnode(self.target,"targetname");
	level notify("fallback",node);
}

fallback()
{
	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread fallback_wait();
	}
}

fallback_wait()
{
	self endon("death");
	while(true)
	{
		level waittill("fallback",node);

		assert(isalive(self));
		assert(isdefined(node));
		
		self.pathEnemyLookAhead = 64;
		self.pathEnemyFightDist = 64;
		self.old_maxsightdistsqrd = self.maxsightdistsqrd;
		self.goalradius = node.radius;
		self.maxsightdistsqrd = (256*256);
		self clearEnemyPassthrough();

		wait randomfloat(3) + .1;

		self clearEnemyPassthrough();
		self setgoalnode(node);
		self waittill("goal");
		self.maxsightdistsqrd = self.old_maxsightdistsqrd;
	}
	
}

setup_retreat()
{
	aSpawner = getentarray("retreat","script_noteworthy");
	level array_thread(aSpawner, ::retreat);
}

retreat()
{
	self waittill("spawned",ai);
	if (spawn_failed(ai))
		return;
	ai endon("death");
	wait 1;
	ai.goalradius = 128;
	ai.maxsightdistsqrd = (128*128);
	ai.pathenemyfightdist = 64;
	ai waittill("goal");
	ai delete();
}

character_control()
{
	trigger = getent("character_delete","targetname");
	trigger waittill("trigger");
	level.randall thread ai_delete(trigger.target);
	level.mccloskey thread ai_delete(trigger.target);

	trigger = getent("character_spawn","targetname");
	trigger waittill("trigger");

	character_spawn();
}

character_spawn()
{
	// will keep trying untill character ai spawns.
	aSpawner = getentarray("character","targetname");
	for (i=0; i < aSpawner.size;)
	{
		ai = aSpawner[i] dospawn();
		if (spawn_failed(ai))
		{
			wait .5;
			continue;
		}
		if (aSpawner[i].script_noteworthy == "randall")
			ai thread setup_randall();
		else
			ai thread setup_mccloskey();
		ai thread friendlyMethod();
		i++;
	}
}

ai_delete(name)
{
	self endon("death");
	nodename = name; 
	while(true)
	{
		node = getnode(nodename,"targetname");
		self setgoalnode(node);
		if (!isdefined(node.radius))
			self.goalradius = node.radius;
		else
			self.goalradius = 4;

		self waittill("goal");
		if (isdefined(node.script_noteworthy) && !bullettracepassed(self.origin+(0,0,32), level.player.origin+(0,0,32),false,undefined))
		{
			self delete();
			break;
		}
		if (isdefined(node.target))
			nodename = node.target;
		else
			nodename = name;
		wait 3;
	}
}

setup_contained()
{
	aSpawner = getentarray("contained","script_noteworthy");
	level array_thread(aSpawner, ::contained);

	aTrigger = getentarray("contained_trigger","targetname");
	level array_thread(aTrigger, ::contained_trigger);
}

contained()
{
	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread contained_wait();
	}
}

contained_wait(spawner)
{
	self endon("death");
	level waittill("delete contained");
	self dodamage(self.health * 1.5, (0,0,0));
}

contained_trigger()
{
	self waittill("trigger");
	level notify("delete contained");
}

setup_sortie()
{
	aSpawner = getentarray("sortie","script_noteworthy");
	level array_thread(aSpawner, ::sortie);

	aTrigger = getentarray("sortie_trigger","targetname");
	level array_thread(aTrigger, ::sortie_trigger);
}

sortie()
{
	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread sortie_wait(self.script_wait,self.script_waittill);
	}
}

sortie_wait(waittime, waitstring)
{
	self endon("death");
	self endon("escape your doom");

	if (isdefined(waitstring))
		level waittill(waitstring);
	else
		self waittill("goal");
	if (isdefined(waittime))
		wait randomfloatrange(waittime,waittime+4);

	println("sortie " + self getentitynumber());

	self notify("stop_going_to_node");

	self setgoalentity(level.player);
	self.goalradius = level.sortie_radius;
}

sortie_trigger()
{
	// match the script_noteworthy witht the script_waittill for the sortie guys you want to trigger.
	self waittill("trigger");
	level notify(self.script_noteworthy);
}

objective_follow(obj_id,notify_string)
{
	self endon("stop objective follow");
	self endon("death");

	if (isdefined(notify_string))
		level waittill(notify_string);

	if (isdefined(self.pos_id))
	{
		while (true)
		{
			wait 1;
			objective_additionalposition(obj_id, self.pos_id, self.origin);
		}
	}
	else
	{
		while (true)
		{
			wait 1;
			objective_position(obj_id, self.origin);
		}
	}
}

angleoffset(vAngles, vOffset)
{
	vf = anglestoforward(vAngles);
	vr = anglestoright(vAngles);
	vu = anglestoup(vAngles);
	
	offset_front = vectorscale(vf,vOffset[0]);
	offset_right = vectorscale(vr,(vOffset[1]*-1));
	offset_top = vectorscale(vu,vOffset[2]);

	new_offset = offset_right+offset_front+offset_top;

	return new_offset;	
}

setup_ai_smoke()
{
	ents = getnodearray("ai_smoke","targetname");
	array_thread(ents,::ai_smoke);
}

ai_smoke()
{
	assert(isdefined(self.radius));

	trigger = spawn( "trigger_radius", self.origin, 10, self.radius, 256); // only trigger on friendly ai
	trigger waittill("trigger",ai);

	ai endon("death");
	ai.ignoreme = true;	

	wait randomfloat(4);

	trigger delete();

	goal = getent(self.target,"targetname");

	if (!isdefined(ai.oldanimname))
		ai.oldanimname = ai.animname;

	if (!isdefined(ai.oldGrenadeWeapon))
		ai.oldGrenadeWeapon = ai.grenadeWeapon;

	ai.animname = "generic";
	ai.grenadeWeapon = "smoke_grenade_american";
	ai.grenadeAmmo++;
	self anim_reach_solo (ai, "nade_throw", undefined, self);
	ai animscripts\shared::PutGunInHand("left");
	ai thread maps\_anim::anim_single_solo(ai, "nade_throw", undefined, self);
	wait 1.45;
	ai MagicGrenade (ai.origin + (0,0,50), goal.origin, 1.5);
	wait .9;
	ai animscripts\shared::PutGunInHand("right");
	ai.animname = ai.oldanimname;
	ai.grenadeWeapon = ai.oldGrenadeWeapon;
	ai.ignoreme = false;
	if (isdefined(ai.onchain) && isalive(ai))
		ai thread friendlyMethod();
}

controlPlayerStance_inWater()
{
	depth_allow_prone = 5;
	depth_allow_crouch = 33;
	default_run_speed = 190;
	
	water_level = getent("water_level","targetname");
	waterHeight = water_level.origin[2];
	
	qReset = false;
	waitTime = 1.0;
	
	while(true)
	{
		wait (waitTime);
		playerOrg = level.player getOrigin();
		waitTime = 1.0;

		if (playerOrg[2] < waterHeight)
		{
			depth =  int(waterHeight - playerOrg[2]);
			newspeed = int(default_run_speed - ((depth*(depth/2)) / 6.8));

			if (newspeed < 35)
				newspeed = 35;
			if (newspeed > 190)
				newspeed = 190;

			setsavedcvar("g_speed", newspeed );

			qReset = true;
			waitTime = 0.25;

			if (depth > depth_allow_prone)
				level.player allowProne(false);
			else
			{
				level.player allowProne(true);
				continue;
			}
			
			if (depth > depth_allow_crouch)
				level.player allowCrouch(false);
			else
				level.player allowCrouch(true);
		}
		else if (qReset)
		{
			//restore all defaults
			level.player allowProne(true);
			level.player allowCrouch(true);
			level.player allowStand(true);
			setsavedcvar("g_speed", default_run_speed);
			qReset = false;
		}
	}
}

/********* vehicle control stuff *********/

setup_vehicle_section_system()
{
	aDetour_node = getvehiclenodearray("detour","script_noteworthy");

	for (i=0; i < aDetour_node.size; i++)
	{
		aDetour_node[i].scriptdetour_persist = true;
		aDetour_node[i].detoured = true;
	}

	aVnode = getvehiclenodearray("section_on","script_noteworthy");
	level array_thread (aVnode, ::vehicle_section_on_node, aDetour_node);

	aVnode = getvehiclenodearray("section_off","script_noteworthy");
	level array_thread (aVnode, ::vehicle_section_off_node, aDetour_node);

}

vehicle_section_off_node(aDetour_node)
{
	while(true)
	{
		self waittill("trigger",vehicle);

		for (i=0; i < aDetour_node.size; i++)
		{
			if (aDetour_node[i].script_idnumber == self.script_idnumber)
				aDetour_node[i].detoured = 0;
		}
	}
}

vehicle_section_on_node(aDetour_node)
{
	while(true)
	{
		self waittill("trigger",vehicle);

		for (i=0; i < aDetour_node.size; i++)
		{
			if (aDetour_node[i].script_idnumber == self.script_idnumber)
				aDetour_node[i].detoured = 1; // randomint(2); // random on or off.
		}
	}
}

setup_vehicle_exploder()
{
	aVnode = getvehiclenodearray("exploder","script_noteworthy");
	level array_thread (aVnode, ::vehicle_exploder_node);
}

vehicle_exploder_node()
{
	self waittill("trigger",vehicle);
	if (isdefined(self.script_wait))
		wait self.script_wait;
	exploder(self.script_exploder);
}

tank_reinforcement()
{
	self endon("death");
	self endon("disabled");

	// check to see if I have to spawn additional ai
	counter_ent = spawnstruct();
	counter_ent.count = 0;
	self.previous_infantrygoal = undefined;

	spawner_locations = getentarray("tank_reinforcement","targetname");

	while(true)
	{
		curr_num = getaiarray("axis").size;
		aSpawner = get_spawners(self getorigin(), spawner_locations);
		if (isdefined(aSpawner))
		{
			spawned = 0;
			for (i=0; i < aSpawner.size; i++)
			{
				ai = aSpawner[i] dospawn();
				if (spawn_failed(ai))
					continue;
				spawned++;
				aSpawner[i].count = 10;
				counter_ent.count++;
				ai.front_guy = randomint(2);
				ai thread reinforcement_on_death(counter_ent,self);
				ai thread tank_follow(self);
				ai thread tank_assault(self);
			}
		}
		self waittill("spawn reinforcement");
	}
}

tank_location()
{
	self endon("death");

	self.origin_stack[0] = self.origin;
	while (true)
	{
		notice = "follow tank";
		// attack the player if he's to close to the tank.
		if (distance(level.player.origin,self.origin) < 960)
		{
			notice = "charge player";
		}
		else if (distance(self.origin_stack[(self.origin_stack.size-1)],self.origin) > 400)	// old 550
		{
			self.origin_stack[(self.origin_stack.size)] = self.origin;
		}
		else if (self.origin_stack.size > 1 && distance(self.origin_stack[(self.origin_stack.size-2)],self.origin) < 400) // old 550
		{
			if (self.origin_stack.size > 1)
				self.origin_stack[(self.origin_stack.size-1)] = undefined;
		}
		self notify(notice);
		wait 1;
	}
}

tank_follow(tank)
{
	self endon("death");

	self.old_maxsightdistsqrd = self.maxsightdistsqrd;
	level.player.old_threatbias = level.player.threatbias;

	while(true)
	{
		tank waittill("follow tank");

		if (tank.origin_stack.size == 1)
			index = 0;
		else
			index = tank.origin_stack.size-2;

		goal = tank.origin_stack[index ];

		level.player.threatbias = level.player.old_threatbias;
		self.pathEnemyLookAhead = 720; //350
		self.pathEnemyFightDist = 350; //350
		self.goalradius = 350;	//350
		self clearEnemyPassthrough();
		self setgoalpos(goal);
	}
}

tank_assault(tank)
{
	self endon("death");
	while(true)
	{
		tank waittill("charge player");
		self.pathEnemyLookAhead = 64;
		self.pathEnemyFightDist = 350;
		self.goalradius = 256;
		self setgoalentity(level.player);
		level.player.threatbias = 1000;
		tank waittill("follow tank");
	}
}

reinforcement_on_death(counter_ent,tank)
{
	self waittill("death");
	counter_ent.count--;
	if (counter_ent.count < 4)
		tank notify("spawn reinforcement");
}

get_spawners(origin, locations)
{
	// returns spawners closest to the origin that the player can't see.

	can_see = [];
	location = undefined;

	for (i=0; i < locations.size; i++)
	{
		location = getClosestExclude (origin, locations, can_see);
		if (isdefined(location))
		{
			trace = bullettracepassed(level.player geteye(), location.origin, false, undefined);
			if (!trace)
				break;
		}

		can_see[can_see.size] = location;
		location = undefined;
	}
	
	if (isdefined(location))
		return  getentarray(location.target,"targetname");
	return undefined;
}

setup_vehicle_pause()
{
	aVnode = getvehiclenodearray("pause","script_noteworthy");
	level array_thread (aVnode, ::vehicle_pause_node);
}

vehicle_pause_node()
{
	brush_trigger = undefined;

	if (isdefined(self.target))
	{
		aEnt = getentarray(self.target,"targetname");
		for (i=0; i < aEnt.size; i++)
		{
			if (aEnt[i].classname == "trigger_multiple")
			{
				brush_trigger = aEnt[i];
				if (isdefined(brush_trigger.script_noteworthy))
					brush_trigger thread vehicle_pause_trigger();
			}
		}
	}

	while(true)
	{
		self waittill("trigger",vehicle);

		vehicle endon("death");
		vehicle endon("disabled");

		if (isdefined(vehicle.node_action) && vehicle.node_action)
			vehicle waittill("node action done");

		vehicle.node_action = true;

		vehicle setspeed(0,10);
		pause_trigger = undefined;

		if (isdefined(self.radius))
		{
			trigger = spawn( "trigger_radius", vehicle.origin, 0, self.radius, 256);
			trigger waittill("trigger");
			trigger delete();
		}
		else if (isdefined(brush_trigger))
		{
			brush_trigger waittill("trigger");
		}

		if (isdefined(self.script_wait))
			wait self.script_wait;

		if (isalive(vehicle)  || isdefined(vehicle.vehicle_disabled))
			vehicle resumespeed(35);

		if (isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
		{
			vehicle.node_action = false;
			vehicle notify("node action done");
		}
	}
}

vehicle_pause_trigger()
{
	level waittill(self.script_noteworthy);
	self waittill("trigger");
	waittillframeend;
	self delete();
}

setup_vehicle_fire()
{
	aVnode = getvehiclenodearray("fire","script_noteworthy");
	level array_thread (aVnode, ::vehicle_fire_node);
}

vehicle_fire_node()
{
	self waittill("trigger",vehicle);

	vehicle endon("death");
	vehicle endon("disabled");

	if (isdefined(vehicle.node_action) && vehicle.node_action)
		vehicle waittill("node action done");

	vehicle.node_action = true;
	vehicle.cycle_target = false;
	eTarget = undefined;
	aTarget = [];

	brush_trigger = undefined;

	if (isdefined(self.target))
	{
		aEnt = getentarray(self.target,"targetname");
		for (i=0; i < aEnt.size; i++)
		{
			if (aEnt[i].classname == "script_origin")
				aTarget[aTarget.size] = aEnt[i];
			else if (aEnt[i].classname == "trigger_multiple")
				brush_trigger = aEnt[i];
		}
	}

	stoped = false;
	if (isdefined(self.script_wait) || isdefined(self.radius) || isdefined(brush_trigger))
	{
		stoped = true;
		vehicle setspeed(0,10);
	}
	
	for (i=0; i < aTarget.size; i++)
	{
		eTarget = aTarget[i];

		badplace_cylinder("", 4, eTarget.origin, 256, 256, "allies", "axis");

		vehicle setturrettargetent(eTarget,(0,0,0));
		vehicle waittill("turret_on_target");

		if (isdefined(self.radius))
		{
			trigger = spawn( "trigger_radius", vehicle.origin, 0, self.radius, 256);
			trigger waittill("trigger");
			trigger delete();
		}
		if (isdefined(brush_trigger))
			brush_trigger waittill("trigger");

		vehicle notify("turret_fire");

		// do shellshock if player within 200 units of target.
		// make sure the target is close to where the shell will detonate.
		if (distance(level.player.origin, eTarget.origin) < 200)
			maps\_shellshock::main(8,20,20,20);

		if (isdefined(eTarget.script_exploder))
		{
			waittillframeend;
			level thread exploder(eTarget.script_exploder);
		}
		vehicle clearTurretTarget();

		if (isdefined(self.script_wait) && i < (aTarget.size-1) )
		{
			min_time = self.script_wait/2;
			wait min_time + randomfloat(min_time) + randomfloat(min_time);
		}
	}

	vehicle.cycle_target = true;

	if (isdefined(self.script_wait))
		wait self.script_wait;


	if (stoped && isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
		vehicle resumespeed(35);

	if (isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
	{
		vehicle.node_action = false;
		vehicle notify("node action done");
	}
}

setup_vehicle_blow()
{
	aVnode = getvehiclenodearray("blow","script_noteworthy");
	level array_thread (aVnode, ::vehicle_blow_node);
}

vehicle_blow_node()
{
	self waittill("trigger",vehicle);
	vehicle dodamage(vehicle.health*2,(0,0,0));
	vehicle notify("death");

	// no sinking if there is no script_noteworthy2 on the vehicle node.
	if (!isdefined(self.script_noteworthy2))
		return;

	ent = spawn("script_model", vehicle getorigin() );
	ent setmodel("xmodel/vehicle_ltv4_buffalo_d");
	ent.angles = vehicle.angles;

	vehicle hide();

	if (isdefined(self.script_noteworthy2) && int(self.script_noteworthy2) == 1)
	{
		ent moveto( vehicle getorigin() + (0,0,-40) , 4, 2, 1);
		ent rotateto( vehicle.angles + (-10,0,16) , 3, 1.5, 1);	}
	else
	{
		ent moveto( vehicle getorigin() + (0,0,-24) , 4, 2, 1);
		ent rotateto( vehicle.angles + (-10,0,-16) , 3, 1.5, 1);
	}

	wait 2;
	vehicle notify ("fire extinguish");

}

setup_vehicle_deploy()
{
	aVnode = getvehiclenodearray("deploy","script_noteworthy");
	level array_thread (aVnode, ::vehicle_deploy_node);
}

#using_animtree ("vehicles");
vehicle_deploy_node()
{

	while(true)
	{
		self waittill("trigger",vehicle);
		vehicle setspeed(0,30);
		vehicle notify("unload");
		wait 6;
		if (isdefined(vehicle) && isalive(vehicle))
		{
			vehicle resumespeed(3);
			wait 3;
			vehicle UseAnimTree(#animtree);
			vehicle setanimknobrestart(%american_buffalo_backgateup);
		}
	}
}

#using_animtree("generic_human");
setup_vehicle_aim()
{
	aVnode = getvehiclenodearray("aim","script_noteworthy");
	level array_thread (aVnode, ::vehicle_aim_node);
}

vehicle_aim_node()
{
	while (true)
	{
		self waittill("trigger",vehicle);

		vehicle notify("turret aim");

		vehicle endon("death");
		vehicle endon("disabled");

		if (isdefined(vehicle.node_action) && vehicle.node_action)
			vehicle waittill("node action done");

		vehicle.node_action = true;
		vehicle.cycle_target = false;
		eTarget = undefined;
		brush_trigger = undefined;

		if (isdefined(self.target))
		{
			aEnt = getentarray(self.target,"targetname");
			for (i=0; i < aEnt.size; i++)
			{
				if (aEnt[i].classname == "script_origin")
					eTarget = aEnt[i];
				else if (aEnt[i].classname == "trigger_multiple")
					brush_trigger = aEnt[i];
			}
		}

		assert(isdefined(eTarget));

		vehicle.curr_target = eTarget;
		vehicle setturrettargetent(eTarget,(0,0,0));
		vehicle waittill("turret_on_target");

		if (isdefined(self.script_wait))
			wait self.script_wait;

		vehicle clearTurretTarget();
		vehicle.curr_target = undefined;
		vehicle.cycle_target = true;

		if (isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
		{
			vehicle.node_action = false;
			vehicle notify("node action done");
		}
	}
}

tank_explosives()
{
	self endon ("death");

	self thread tank_ondeath();
	self.bombTriggers = [];
	self.bombs = [];

	tags = [];
	tags[0] = "tag_gastank_left";
	tags[1] = "tag_left_wheel_09";
	tags[2] = "tag_right_wheel_09";
	location_angles = [];
	location_angles[0] = self.angles + (0,0,0);
	location_angles[1] = self.angles + (180,90,0);
	location_angles[2] = self.angles + (0,90,0);

	for (i=0; i < tags.size; i++)
	{
		bomb = spawn("script_model", self gettagorigin(tags[i]));
		bomb setmodel("xmodel/military_tntbomb_obj");
		bomb.angles = location_angles[i];
		bomb linkto(self,tags[i]);

		bomb.trigger = undefined;

		aTrigger = getentarray("sticky_trigger","targetname");
		for (t=0; t < aTrigger.size; t++)
		{
			if (!isdefined(aTrigger[t].inuse))
			{
				bomb.trigger = aTrigger[t];
				break;
			}
		}

		assert(isdefined(bomb.trigger));
		bomb.trigger.inuse = true;
		bomb.tanktag = tags[i];

		bomb.trigger.oldorigin = bomb.trigger.origin;
		bomb.trigger.origin = bomb.origin;
		if (!isdefined(bomb.trigger.linktoenable))
			bomb.trigger enablelinkto();
		bomb.trigger.linktoenable = true;
		bomb.trigger linkto(bomb);

		self.bombs[i] = bomb;
		self thread tank_explosives_wait(bomb.trigger,i);
	}

	self waittill ("explosives planted",id);

	badplacename = ("tank_badplace_" + randomfloat(1000));
	badplace_cylinder(badplacename, -1, self.origin, 250, 300);
	
	iprintlnbold (&"SCRIPT_EXPLOSIVESPLANTED");

	bomb = self.bombs[id];

	remove_stickys(self.bombs,id);

	bomb setmodel ("xmodel/military_tntbomb");
	bomb playsound ("stickybomb_plant");
	bomb playloopsound ("bomb_tick");

	level stopwatch(bomb);

	badplace_delete(badplacename);
	if (id == 0) // placed on the engine
	{
		bomb.trigger.inuse = undefined;
		bomb delete();
		self notify ("death", level.player);
	}
	else // places on either tread wheel
	{
		if(!isdefined(self.rollingdeath))
			self setspeed(0,25,"Dead");
		else
		{
			self setspeed(8,25,"Dead rolling out of path intersection");
			self waittill ("deathrolloff");
			self setspeed(0,25,"Dead, finished path intersection");
		}

//		self stopenginesound();
		self disconnectpaths();
		self.vehicle_disabled = true;

		self playsound ("grenade_explode_default");
		level maps\_fx::OneShotfx("sticky_explosion", bomb.origin, 0.1);
		self thread maps\_fx::loopfx("sticky_explosion_smoke",self gettagorigin("tag_engine_left"), 2,undefined);

		wait .25;
		if (bomb.tanktag == "tag_right_wheel_09")
			self setmodel("xmodel/vehicle_tiger_righttread_d");
		else
			self setmodel("xmodel/vehicle_tiger_lefttread_d");

		explosion_origin = bomb.origin;
	
		bomb.trigger.inuse = undefined;
		bomb delete();

		nocover_radiusDamage(explosion_origin, 200, 300, 50);

		if (isdefined(level.runupactive) && level.runupactive)
		{
			wait 2;
			self notify ("death", level.player);
		}
		else
		{
			self notify("disabled");
			self tank_runup();
		}
	}

}

remove_stickys(bombs, id)
{
	if (!isdefined(id))
		id = 1000; // a value that will never match
	for (i=0;i < bombs.size;i++)
	{
		if (!isdefined(bombs[i]))
			continue;
		if (i != id)
		{
			bombs[i].trigger unlink();
			bombs[i].trigger.inuse = undefined;
			bombs[i].trigger.origin =  bombs[i].trigger.oldorigin;
			bombs[i] delete();
		}
		else
		{
			bombs[i].trigger unlink();
			bombs[i].trigger.origin =  bombs[i].trigger.oldorigin;
		}
	}
}

tank_runup()
{
	self endon("death");


	// wait till no more enemies are close to the tank or 10 seconds.
	timer = 0;
	while (true)
	{
		german = getclosestai(self.origin,"axis");
		if (!isdefined(german))
			break;
		else if (distance(self.origin,german.origin) > self.grenadetank_dist)
			break;

		// 20 = 10 seconds
		if (timer > 20)
			break;
		timer++;

		wait .5;
	}

	runupguy = undefined;
	excluder = [];
	if (isdefined(level.randall))
		excluder[excluder.size] = level.randall;
	if (isdefined(level.mccloskey))
		excluder[excluder.size] = level.mccloskey;
	if (excluder.size == 0)
		excluder = undefined;

	if (isdefined(excluder))
		runupguy = getClosestAIExclude(self.origin, "allies", excluder);
	else
		runupguy = getClosestAI(self.origin, "allies");

	// if no guy can be found, kill the tank after 3 seconds.
	if (!isdefined(runupguy) || isdefined(level.runupactive) && level.runupactive)
	{
		wait 2;
		self notify ("death", level.player);
		return;
	}

	level.runupactive = true;
	runupguy.runupactive = true;

	runupguy notify("stop follow");
	runupguy thread runupguy_animation(self);

	// Will kill the tank if the ai doesn't move towards the tank, or if to much time goes by.
	self thread runup_guy_stuck(runupguy);

	// make the tank reset it's turret to the default position so that the animations will match.
	self notify("stop cycle");
	self clearturrettarget();
	offset = angleoffset(self.angles, (100000,0,0));
	self setturrettargetent(self, offset);
}

runupguy_animation(tank)
{
	tank endon("death");

	self.atgoal = undefined;
	self.animname = "runupguy";
	self.ignoreme = true;
	self.old_maxsightdistsqrd = self.maxsightdistsqrd;
	self.maxsightdistsqrd = (256*256);
	self.old_pathenemyfightdist = self.pathenemyfightdist;
	self.pathenemyfightdist = 64;
	self clearEnemyPassthrough();
	self thread magic_bullet_shield();

	// run to tank
	self anim_reach_solo (self, "grenadetank", "tag_origin", undefined, tank);

	self.atgoal = true;
	self notify("climb anim started");

	// climb tank
	self anim_single_solo(self, "grenadetank", "tag_origin", undefined, tank);

	tank thread hatch();
	self notify("end_loop");

	self anim_single_solo(self, "grenadetank_run","tag_origin",undefined,tank);

	self notify("stop magic bullet shield");
	if (isalive(self))
	{
		self.ignoreme = false;
		self.maxsightdistsqrd = self.old_maxsightdistsqrd;
		self.pathenemyfightdist = self.old_pathenemyfightdist;
		self.runupactive = false;
		self thread friendlyMethod();
	}
	badplace_cylinder("", 4, self.origin, 350, 350, "allies","axis");

	wait 4;
	level.runupactive = false;

	tank notify ("death", level.player);

}

runup_guy_stuck(runupguy)
{
	runupguy endon("climb anim started");

	oldpos = runupguy.origin;
	oks = 0;

	for(i=0;i<5;i++)
	{
		wait 1;
		dif = distance(runupguy.origin, oldpos);
		if (dif > 64)
			oks++;
		oldpos = runupguy.origin;
	}

	// if the ai is moving it will have another 5 seconds to reach it's goal, else tank goes boom.
	if (oks > 1)
		wait 5;	

	level.runupactive = false;

	self notify ("death", level.player);

	if (isalive(runupguy))
	{
		// reset runupguy values
		runupguy notify("stop magic bullet shield");
		runupguy.ignoreme = false;
		runupguy.maxsightdistsqrd = runupguy.old_maxsightdistsqrd;
		runupguy.pathenemyfightdist = runupguy.old_pathenemyfightdist;
		runupguy.runupactive = false;
		runupguy thread friendlyMethod();
	}
}

#using_animtree ("tank");
hatch()
{
	self UseAnimTree(#animtree);
	self setanim(%panzertank2_tankhatchanim_grenadeguy);
}

#using_animtree ("generic_human");
tank_explosives_wait(trigger,id)
{
	self endon ("death");
	self endon ("explosives planted");

	trigger setHintString (&"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES");

	while(true)
	{
		trigger waittill ("trigger");

		level.player.tnt--;
		if (level.player.tnt <= 0)
			level.inv_tnt maps\_inventory::inventory_destroy();

		level notify ("explosives planted");
		self notify ("explosives planted", id);
		return;
	}
}

stopwatch(bomb)
{
	if (isdefined (self.bombstopwatch))
		self.bombstopwatch destroy();
	self.bombstopwatch = maps\_utility::getstopwatch(60);
	level.timersused++;
	wait level.explosiveplanttime;
	bomb stoploopsound ("bomb_tick");
	level.timersused--;
	if (level.timersused < 1)
	{
		if (isdefined (self.bombstopwatch))
			self.bombstopwatch destroy();
	}
}

tank_ondeath()
{
	self waittill("death");
	level thread remove_stickys(self.bombs);
	level notify("tank destroyed",self.pos_id);
}

music()
{
	wait 1;
	musicplay("victory_exhausted_01");	
}

music_end()
{
	musicstop(1);
	wait 1.05;
	musicplay("us_lastwords_01");
}

