#include maps\_utility;
#include maps\_anim;
#using_animtree("generic_human");

main()
{	
//	setCullFog(0, 5000, .58, .57, .57, 0);

	
	fog = (getcvar("r_forcetechnology") == "" || getcvar("r_forcetechnology") == "default" || getcvar("r_forcetechnology") == "dx9" || getcvar("r_forcetechnology") == "DX9" || getcvarint("r_forcetechnology") == 1);
	if (fog)
	{
		setExpFog(0.00045, .58, .57, .57, 0);
		setCullDist (6000);
	}
	else
		setCullFog(0, 6000, .58, .57, .57, 0);

		// Set some cvars
	setsavedcvar("r_specularColorScale", "1.5");

	precacheModel("xmodel/weapon_stickybomb");
	precacheModel("xmodel/weapon_stickybomb_obj");
	precacheShader("inventory_stickybomb");
	precacheShader("inventory_wire_repair");

	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");

	precacheString(&"SCRIPT_EXPLOSIVESPLANTED");
	precacheString(&"TANKHUNT_CABLE_OBJECTIVE");
	precacheString(&"TANKHUNT_FIELD_PHONE_OBJECTIVE");
	precacheString(&"TANKHUNT_GET_STICKY_BOMB_OBJECTIVE");
	precacheString(&"TANKHUNT_TANK_OBJECTIVE");
	precacheString(&"TANKHUNT_PLATFORM_REPAIR_CABLE");
	precacheString(&"TANKHUNT_PLATFORM_PLANT_STICKY_BOMB");
	precacheString(&"TANKHUNT_PLATFORM_PICK_UP_STICKY_BOMBS");
	precacheString(&"TANKHUNT_PLATFORM_USE_FIELD_PHONE");

	level.campaign = "russian";	

	maps\_panzer2::main("xmodel/vehicle_panzer_ii_winter");
	maps\_panzer2::main("xmodel/vehicle_panzer_II_winter_r_tread_d");
	maps\_panzer2::main("xmodel/vehicle_panzer_II_winter_l_tread_d");
//	maps\_tankai::main();
//	maps\_tankai_crusader::main("xmodel/vehicle_crusader2");

	maps\tankhunt_fx::main();
	maps\_load::main();

	maps\tankhunt_anim::main(); 
	
	level thread maps\tankhunt_amb::main();

	// makes ai do cool stuff
	setEnvironment ("cold");

	// disable some spawners based on difficulty
	skill = getdifficulty();
	aSpawner = getentarray("auto53","targetname");

	// difficulty specific settings.
	if (skill == "easy")
	{
		aSpawner[0].count = 0;
		aSpawner[1].count = 0;
	}
	else if (skill == "medium")
		aSpawner[0].count = 0;

	// propaganda soundalias
	level.propaganda = [];
	level.propaganda[0] = "downtownsniper_gplv_propaganda8";
	level.propaganda[1] = "downtownsniper_gplv_propaganda4";
	level.propaganda[2] = "downtownsniper_gplv_propaganda7";
	level.propaganda[3] = "downtownsniper_gplv_propaganda3";


	// propaganda tirggers
	aTrigger = getentarray("propaganda","targetname");
	level thread array_thread(aTrigger, ::propaganda);

	setup_sortie();
	setup_contained();

	thread force_jumpdown();

	level.maxfriendlies = 4;
	level.friendlyMethod = "friendly chains";
	level.friendlywave_thread = ::friendlyMethod;
	level.friendlyradius = undefined;
	level.followmin = -2;
	level.followmax = 2;

	level.timersused = 0;
	level.player.stickybomb = 0;
	level.runups = 0;

	level.boolean = false;

	// autosave triggers
	aTrigger = getentarray("savebyname","targetname");
	array_thread(aTrigger,::savebyname);

	level thread start();
	level thread cable_objective();
	level thread dormitory();
	level thread radio();
	level thread tanks();
	level thread regroup();

	level thread join_forces();
	level thread square();

	level notify("start");

	// lower count on roadblock spawners
	wait 1;
	if (skill == "easy")
		count = 0;
	else if (skill == "medium")
		count = 1;
	else
		count = 2;

	aSpawner = getentarray("roadblock_guy","script_noteworthy");
	for (i=0; i < aSpawner.size; i++)
	{
		aSpawner[i].count = count;
	}
}

/******* game play script *******/

start()
{
	level waittill("start");

	level.inv_repair = maps\_inventory::inventory_create("inventory_wire_repair",true);

	level thread smoke_throw();
	level thread use_grenade();

	ent = getent("mg_badplace_start","targetname");
	// name, duration, origin, radius, height, direction, right arc, left arc, team, ...
	badplace_arc("roadblock_badplace", -1, ent.origin, 2500, 400, anglestoforward((0, 270, 0)), 5, 3, "allies");

	level thread battleChatterOff("allies");

	node = getnode("start_chain","targetname");
	level.player setfriendlychain(node);

	volsky = getent("volsky","script_noteworthy");
	volsky.animname = "volsky";

	wait 0;

	volsky thread Dialogue_Thread("tankhunt_volsky_repairthewire");
	wait 5;

	aAi = getentarray("companion","targetname");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i] setgoalentity(level.player);
	}

	wait 2;

	delete_goal = getnode("delete_goal","targetname");
	aAI = getentarray("1squad","targetname");
	level array_thread(aAI,::movetoanddelete,delete_goal);

	level thread battleChatterOn("allies");

	level notify("cable objective");

	// make sure all ai are on the friendly chain
	wait 30;
	aAi = getentarray("ambient_guy","targetname");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i] notify("stop_going_to_node");
		aAi[i] setgoalentity(level.player);
	}
}

smoke_throw()
{
	level.smoke_throw = true;	
	level thread smoke_throw_cancel();
	level thread smoke_throw_bc();

	level waittill("smoke_throw");

	wait 4; // wait a few second so that the player os given the option to cross without smoke, or throw it him self.

	if (!level.smoke_throw)
		return;

	node = getnode("smoke_throw","targetname");
	goal = getent(node.target,"targetname");

	ai = getclosestai(node.origin, "allies");
	if (!isdefined(ai))
		return;
	ai endon("death");
	ai.ignoreme = true;

	ai.animname = "generic";

	if (!isdefined(ai.oldGrenadeWeapon))
		ai.oldGrenadeWeapon = ai.grenadeWeapon;

	ai anim_reach_solo (ai, "nade_throw", undefined, node);

	// there should not be any ai with animname so I'll just change it
	ai.grenadeWeapon = "smoke_grenade_american";
	ai.grenadeAmmo++;
	ai animscripts\shared::PutGunInHand("left");
	ai thread maps\_anim::anim_single_solo(ai, "nade_throw",undefined, node);
	wait 1.45;
	ai MagicGrenade (ai.origin + (0,0,50), goal.origin, 1.5);
	wait .9;

	level thread cross_street();

	ai animscripts\shared::PutGunInHand("right");
	ai.grenadeWeapon = ai.oldGrenadeWeapon;
	ai.ignoreme = false;
	ai thread friendlyMethod();
}

cross_street()
{
	level endon("smoke_throw_cancel");

	wait 5;
	node = getnode("auto102","targetname");
	level.player setfriendlychain(node);
}

smoke_throw_cancel()
{
	trigger = getent("smoke_throw_cancel","targetname");
	trigger waittill("trigger");
	level.smoke_throw = false;
	level notify("smoke_throw_cancel");
}

smoke_throw_bc()
{
	level endon("smoke_throw_cancel");

	trigger = getent("smoke_throw_bc","targetname");
	trigger waittill("trigger");

	org = getent("smoke_throw_bc_origin","targetname");
	ai = getclosestai(org.origin, "allies");
	if (!isdefined(ai))
		return;
	ai endon("death");
	ai.health = 500;

	ai.animname = "generic";
	ai Dialogue_Thread("mg42_warning");
	wait .25;
	ai thread Dialogue_Thread("mg42_location");
	wait 4;
	ai.health = 100;
	level notify("smoke_throw");
}

cable_objective()
{
	level waittill("cable objective");

	aTrigger = getentarray("basement","script_noteworthy");
	aTrigger[0] triggeroff();
	aTrigger[1] triggeroff();

	aEnt = getentarray("cable","targetname");
	level array_thread(aEnt,::cable);

	order = 100; // a high id so that there always will be a lower one.
	first_cabel = undefined;

	level thread cable_show(aEnt);

	for (i=0; i<aEnt.size; i++)
	{
		if (int(aEnt[i].script_noteworthy) < order)
		{
			first_cabel = aEnt[i];
			order = int(aEnt[i].script_noteworthy);
		}
	}

	objective_add(1,"active");
	objective_string(1,&"TANKHUNT_CABLE_OBJECTIVE", aEnt.size);
	objective_position(1,first_cabel.origin);

	objective_current(1);

	level.cable_breaks = aEnt.size;
	level thread setup_cable_bypassed();

	while (level.cable_breaks > 1)
	{
		level waittill("cable fixed",id);
		level.cable_breaks--;
		objective_string(1,&"TANKHUNT_CABLE_OBJECTIVE", level.cable_breaks);
		level thread autoSaveByName("cable_fixed");
		if (level.cable_breaks == 1)
		{
			aTrigger = getentarray("basement","script_noteworthy");
			aTrigger[0] triggeron();
			aTrigger[1] triggeron();

			door = getent("basement_door","targetname");
			door rotateto((0,-120,0),1);
			door connectpaths();
		}
	}

	level waittill("cable fixed",id);
	objective_string_nomessage(1,&"TANKHUNT_CABLE_OBJECTIVE",0);
	level.cable_breaks--;

	level thread autoSaveByName("cable_fixed");

	level notify("cabel repaired");

	objective_state(1,"done");

	level.inv_repair maps\_inventory::inventory_destroy();
	
	level notify("radio"); 
}

force_jumpdown()
{
	endon_trigger = getent("cancel_force_jumpdown","script_noteworthy");
	endon_trigger endon("trigger");

	trigger = getent("force_jumpdown","targetname");
	trigger waittill("trigger");

	while (getaiarray("axis").size > 3)
		wait 1;
	
	node = getnode("auto2785","targetname");
	level.player setfriendlychain(node);
}


setup_cable_bypassed()
{
	aTrigger = getentarray("cable_bypassed","targetname");
	level array_thread(aTrigger,::cable_bypassed);
}

cable_bypassed()
{
	self waittill("trigger");

	if (level.cable_breaks <= int(self.script_noteworthy))
		return;

/*
	// old reminder dialogue
	ai = getclosestai(level.player getorigin(),"allies");
	if (!isdefined(ai))
		return;
	ai.animname = "generic";
	ai thread Dialogue_Thread("tankhunt_rs3_cablebreaches");
*/

	bypased = (6 - int(self.script_noteworthy));
	level.cable_breaks = int(self.script_noteworthy)+1;

	aTrigger = getentarray("cable","targetname");
	for (i=0; i<aTrigger.size; i++)
	{
		if (int(aTrigger[i].script_noteworthy) <= bypased)
		{
			// fix the cable
			aTrigger[i] notify("remove_cable");
			p1 = getent(aTrigger[i].target,"targetname");
			p2 = getent(p1.target,"targetname");
			p2 show();
			p1 delete();
			aTrigger[i] delete();
		}
	}

	level notify("cable fixed");

}


cable()
{
	self endon("remove_cable");
	
	// set hint string
	self setHintString(&"TANKHUNT_PLATFORM_REPAIR_CABLE");

	p1 = getent(self.target,"targetname");
	p2 = getent(p1.target,"targetname");
	p2 hide();

	self waittill("trigger");

	p2 show();
	p1 delete();

	playsoundinspace("tankhunt_wirerepair",self.origin);
	level notify("cable fixed",int(self.script_noteworthy));
	self delete();
}

cable_show(aCable)
{
	level endon("cabel repaired");

	while (true)
	{
		level waittill("cable fixed");
		order = 100; // a high id so that there always will be a lower one.
		active_cabel = undefined;
		for (i=0; i<aCable.size; i++)
		{
			if (!isdefined(aCable[i]))
				continue;
			if (int(aCable[i].script_noteworthy) < order)
			{
				active_cabel = aCable[i];
				order = int(aCable[i].script_noteworthy);
			}
		}
		if (order == 100)
			return;
		objective_position(1,active_cabel.origin);
	}
}

use_grenade()
{
	trigger = getent("use_grenade","targetname");
	trigger waittill("trigger");

	ai = getclosestai(level.player getorigin(),"allies");
	if (!isdefined(ai))
		return;
	ai.animname = "generic";
	ai thread Dialogue_Thread("tankhunt_rs3_usegrenades");
}

dormitory()
{
	level thread piano_tumble();

	dormitory_start = getent("dormitory_start","targetname");
	dormitory_start waittill("trigger");
	level.maxfriendlies = 2;
	dormitory_end = getent("dormitory_end","targetname");
	dormitory_end waittill("trigger");
	level.maxfriendlies = 6;
	level notify ("friendly_died");
}

piano_tumble()
{
	piano = getent("piano","targetname");
	piano_d = getentarray("piano_d","targetname");
	for (i=0; i<piano_d.size;i++)
	{
		piano_d[i] hide();
	}

	trigger = getent("piano_tumble","targetname");
	trigger waittill("trigger");

	guySpawner = getent("piano_tumble_guy","targetname");
	guy = guySpawner dospawn();
	if (!spawn_failed(guy))
		guy waittill("goal");

//	piano rotatevelocity( (70,0,-200), 1.15, 1, 0);
//	wait .40;
//	piano moveGravity ((-30,0,0), 1);
	piano rotatevelocity( (-70,0,200), 1.15, 1, 0);
	wait .40;
	piano moveGravity ((-30,0,0), 1);

	trigger = spawn( "trigger_radius", (-306, 552, 0) , 0, 64, 256);

	wait .7;
	piano_d[0] playsound("piano_crash");
	wait .05;
	exploder(50);
	wait .1;

	if (level.player istouching(trigger))
		level thread killplayer();

	for (i=0; i<piano_d.size;i++)
	{
		piano_d[i] show();
	}
	earthquake( .25, .25, piano_d[0].origin, 512);
	wait .1;
	piano delete();
	trigger delete();
}

radio()
{
	level thread radio_germans();
	level thread get_sticky_bombs();

	chain_off("cellar_chain");

	radio_trigger = getent("radio_trigger","targetname");
	radio_obj = getent("radio_obj","targetname");
	radio = getent("radio","targetname");

	radio_obj hide();

	radio_trigger triggerOff();
	radio_trigger sethintstring(&"TANKHUNT_PLATFORM_USE_FIELD_PHONE");

	level waittill("radio");

	badplace_delete("roadblock_badplace");

	radio_trigger triggerOn();
	radio_obj show();

	objective_add(2,"active",&"TANKHUNT_FIELD_PHONE_OBJECTIVE",radio.origin);
	objective_current(2);

	radio_trigger waittill("trigger");

	level notify("radio activated");

	battleChatterOff("allies");
	battleChatterOff("axis");

	radio_trigger delete();
	radio_obj delete();

	// actial radio dialogue is ~16 seconds.
	radio playsound("tankhunt_rrv1_loudandclear");
	wait 16;

	objective_state(2,"done");

	if (level.player.stickybomb == 0)
	{
		level thread radio_germans(true);

		sticky_obj = getent("get_sticky_obj","targetname");
		objective_add(3,"active",&"TANKHUNT_GET_STICKY_BOMB_OBJECTIVE",sticky_obj.origin);
		objective_current(3);

		level thread sticky_reminder();
		level waittill("got sticky");

		objective_state(3,"done");

		wait 2;
	}

	level thread autoSaveByName("radio");

	wait 1;

	spawners = getentarray ("door_kicker","targetname");

	for (i=0; i < spawners.size; i++)
	{
		guy = spawners[i] dospawn();
		if (spawn_failed(guy))
			continue;
		guy.goalradius = 0;
		guy setgoalentity(level.player);
	}

	// open the door to the rest of the People's Dormitory
	door = getent("dormitory_door","targetname");
	door notsolid();
	door rotateto((0,-120,0), 0.2);
	door playsound ("wood_door_shoulderhit");
	door connectpaths();

	chain_on("cellar_chain");
	chain_off("cable_chain");

	level notify("tanks");

	wait 2;

	battleChatterOn("allies");
	battleChatterOn("axis");

}

get_sticky_bombs()
{
	sticky = getent("get_sticky_trigger","targetname");
	sticky sethintstring(&"TANKHUNT_PLATFORM_PICK_UP_STICKY_BOMBS");
	sticky waittill("trigger");

	ents = getentarray("sticky_prop","targetname"); // bomb
	for (i=0; i<ents.size; i++)
	{
		ents[i] delete();
	}
	ents = getentarray("sticky_prop_obj","targetname"); // glowy bomb
	for (i=0; i<ents.size; i++)
	{
		ents[i] delete();
	}

	level thread playsoundinspace( "stickybomb_plant", level.player getorigin() );

	sticky delete();

	level.inv_sticky = maps\_inventory::inventory_create("inventory_stickybomb",true);

	level.player.stickybomb = 4;
	level notify("got sticky");

}

sticky_reminder()
{
	level endon("got sticky");

	while (true)
	{
		wait 2;
		ai = getclosestai(level.player getorigin(),"allies");
		if (!isdefined(ai))
			continue;
		ai.animname = "generic";
		ai thread Dialogue_Thread("tankhunt_rs3_pickupbombs");
		wait 8;
	}
}

radio_germans(notrigger)
{
	// play sounds random sounds from second floor.
	level endon("radio activated");
	level endon("tanks");

	emitter_ent = getent("german_sound_emitter","targetname");

	if ( !isdefined(notrigger) )
	{
		germans = getent("germans_trigger","targetname");
		germans triggerOff();

		level waittill("radio");

		germans triggerOn();
		germans waittill("trigger");
	}

	wait randomint(4);
	oldi = 0;

	while (true)
	{
		i = randomint(4);
		if (oldi == i)
			i++;
		oldi = i;
		switch (i)
		{
			case 1:
				emitter_ent playsound("GE_0_taunt");
				wait 2;
				break;
			case 2:
				emitter_ent playsound("wood_door_fisthit");
				wait 2;
				break;
			case 3:
				emitter_ent playsound("GE_0_taunt");
				wait 2;
				break;
			default:
				emitter_ent playsound("wood_door_fisthit");
				wait 2;
				break;
		}
		wait randomint(4)+1;
	}
}

tanks()
{
	chain_off("tanks_chain");

	aSound_trigger = getentarray("sound_trigger","targetname");
	array_thread(aSound_trigger,::play_trigger_sound);

	roadblock_trigger = getent("roadblock","targetname");
	roadblock_trigger triggeroff();
	square_trigger = getent("square_trigger","targetname");
	square_trigger triggeroff();
	panzer_2_gate = getent("panzer_2_gate","targetname");
	panzer_2_gate triggeroff();

	road_block_1d = getentarray("road_block_1d","targetname");
	array_thread(road_block_1d, ::hide_ent);
	road_block_2d = getentarray("road_block_2d","targetname");
	array_thread(road_block_2d, ::hide_ent, true);
	road_block_3d = getentarray("road_block_3d","targetname");
	array_thread(road_block_3d, ::hide_ent, true);

	road_block_nodes = getentarray("road_block_nodes","targetname");
	array_thread(road_block_nodes, ::hide_ent, true);

	level waittill("tanks");

	chain_on("tanks_chain");
	roadblock_trigger triggeron();
	square_trigger triggeron();
	panzer_2_gate triggeron();

	level thread setup_vehicle_pause();
	level thread setup_vehicle_fire();

	level thread tanks_objective();

	// first tank
	aVehicle = maps\_vehicle::scripted_spawn(1);
	panzer_1 = aVehicle[0];
	panzer_1.pos_id = 0;
	panzer_1 thread objective_follow(4);
	panzer_1.grenadetank_dist = 512;
	panzer_1 thread tank_explosives();

	panzer_1 thread cycle_tank_target();
	panzer_1 thread first_tank();

	stronghold = getent("stronghold","targetname");
	stronghold waittill("trigger");

	level thread autoSaveByName("stronghold");

	// start first tank on path
	level thread maps\_vehicle::gopath(panzer_1);
	wait 2;
	panzer_1.mgturret[0] thread autofire_mg("panzer_mgtarget_1",panzer_1);

	stronghold = getent("arch_alley","targetname");
	stronghold waittill("trigger");

	level.maxfriendlies = 3;
	level.second_tank = true;

	// second tank
	aVehicle = maps\_vehicle::scripted_spawn(2);
	panzer_2 = aVehicle[0];
	panzer_2.pos_id = 1;
	panzer_2 thread objective_follow(4);
	panzer_2.grenadetank_dist = 512;
	panzer_2 thread tank_explosives();

	panzer_2 thread roadblock_destroy();
	level thread maps\_vehicle::gopath(panzer_2);

	road_block_1 = getentarray("road_block_1","targetname");
	road_block_2 = getentarray("road_block_2","targetname");
	road_block_3 = getentarray("road_block_3","targetname");

	level thread delete_roadblock_mg42s();

	// activate triggers that play sounds when you pass tghrough
	level notify("tanks active");

	array_thread(road_block_1d, ::show_ent);
	wait 0.05;
	array_thread(road_block_1, ::hide_ent, true);

	array_thread(road_block_2d, ::show_ent, true);
	wait 0.05;
	array_thread(road_block_2, ::hide_ent, true);

	array_thread(road_block_3d, ::show_ent,true);
	wait 0.05;
	array_thread(road_block_3, ::hide_ent, true);

	// should make the ai not use the nodes that are in the open.
	array_thread(road_block_nodes, ::show_ent, true);

	roadblock_trigger waittill("trigger");

	aVehicle = maps\_vehicle::scripted_spawn(3);
	panzer_3 = aVehicle[0];
	panzer_3.pos_id = 2;
	panzer_3 thread objective_follow(4);
	panzer_3.grenadetank_dist = 512;
	panzer_3 thread tank_explosives();

	panzer_3 thread cycle_tank_target();
	level thread maps\_vehicle::gopath(panzer_3);

	//  remove player clip from rubble at the end of dormitory street.
	trigger = getent("rubble_clip_trigger","targetname");
	trigger waittill("trigger");
	clip = getent("rubble_clip","targetname");
	clip delete();
}

play_trigger_sound()
{
	self triggeroff();
	level waittill("tanks active");
	self triggeron();
	self waittill("trigger",ent);
	if (isdefined(self.target))
		ent = getent(self.target,"targetname");
	
	ent playsound(self.script_noteworthy);
}

first_tank()
{
	triggerHint = getent("tank damage hint","targetname");
	triggerHint enableLinkto();
	triggerHint linkto (self,"tag_origin",(0,0,0),(0,0,0));

	self thread triggerHintThink(triggerHint);

	trigger = getent("first_tank_chain_trigger","targetname");
	trigger endon("trigger");
	self waittill("death");
	node = getnode("first_tank_chain","targetname");
	level.player setfriendlychain(node);
}

// Prints hint if you attack tanks with the wrong weapons
triggerHintThink ( trigger )
{
	level endon("explosives planted");

	count = 0;

	trigger enableGrenadeTouchDamage();
	self endon ("death");
	while (1)
	{
		trigger waittill ("trigger", other);
		if (!isdefined (other.classname))
			continue;
		if (other.classname == "worldspawn")
			continue;

		if (other == self)
			continue;
						
		if ((other != level.player) && (other.classname != "grenade"))
			continue;
		wait (0.05);
		println ("^2HIT by ", other.classname, " , ", other);
		//Tanks can not be destroyed by Grenades or Bullets
		iprintlnbold (&"TANKHUNT_TANKGRENADESBULLETS");

		count++;
		wait (20 * count);
	}
}

delete_roadblock_mg42s()
{
	// I can't delete them so I just move them down so you can't see them.
	mgs = getentarray("roadblock_mg42","script_noteworthy");
	for (i=0; i < mgs.size; i++)
	{
		mgs[i].origin = mgs[i].origin + (0,0,-1000);
	}
}

roadblock_destroy()
{
	self endon("death");
	// pause at roadblock_fire node till player hits roadblock_destroy trigger
	// fire at roadblock then move on when player tries to move closer.

	self thread roadblock_destroy_trigger();

	vnode = getvehiclenode("roadblock_fire","script_noteworthy");
	vnode waittill("trigger");
	self setspeed(0,100);

	eTarget = getent("roadblock_fire_target","targetname");
	self setturrettargetent(eTarget,(0,0,0));

	if (!isdefined(self.roadblock_destroy))
	{
		trigger = getent("roadblock_destroy","targetname");
		trigger waittill("trigger");
	}

	wait 0.5;
	self notify("turret_fire");

	self thread cycle_tank_target();

	trigger = spawn( "trigger_radius", self.origin, 0, 620, 512);
	trigger waittill("trigger");
	trigger delete();

	self resumespeed(30);
}

roadblock_destroy_trigger()
{
	trigger = getent("roadblock_destroy","targetname");
	trigger waittill("trigger");
	self.roadblock_destroy = true;
}

tanks_objective()
{
	level.tank_objectives = 3;

	level thread music();

	objective_add(4,"active");
	objective_string(4,&"TANKHUNT_TANK_OBJECTIVE", level.tank_objectives);

	objective_current(4);

	id = 0;

	while(level.tank_objectives)
	{
		level waittill("tank destroyed",id);

		// put new tank_savebyname here
		// tank autosave triggers
		aTrigger = getentarray("tank_savebyname","targetname");
		array_thread(aTrigger,::savebyname);

		level thread square_attack_chain();

		level.tank_objectives--;

		// removes the star
		objective_additionalposition(4,id,(0,0,0));

		if (level.tank_objectives > 0)
		{
			objective_string(4,&"TANKHUNT_TANK_OBJECTIVE", level.tank_objectives);
		}
		else
		{
			objective_string_nomessage(4,&"TANKHUNT_TANK_OBJECTIVE", 0);
		}

		if (level.tank_objectives < 2)
			level notify("one left");

		// add a temp star if second tank isn't spawned yet.
		if (!isdefined(level.second_tank))
		{
			ent = getent("tmp_tank2_pos","targetname");			
			objective_additionalposition(4, 1, ent.origin);
		}
		// remove the star
		objective_additionalposition(4, id, (0,0,0));
		level thread autoSaveByName("tankhunt");
	}

	objective_state(4,"done");
	level notify ("regroup");
}

square_attack_chain()
{
	end_trigger = getent("disable_magic_chain","script_noteworthy");
	end_trigger endon("trigger");

	while (true)
	{
		level waittill("tank destroyed",id);

		// second tank.
		if (id == 1)
			break;
	}

	trigger = getent("square_attack_chain","targetname");
	aNode = getnodearray(trigger.target,"targetname");

	level.player setfriendlychain(aNode[0]);

	// disable chains that doesn't move towards the square.
	chain_off("tanks_chain");
}

music()
{
	level waittill("one left");
	level waittill_any("sticky planted","regroup");
	musicplay("soviet_victory_light02");
}

regroup()
{
	level waittill("regroup");

	aAxis = getaiarray("axis");
	if (aAxis.size > 3)
	{
		waittime = 0;
		axis_retreat_node = getnode("axis_retreat_node","targetname");
		for (i=0; i < aAxis.size; i++)
		{
			if ( distance(aAxis[i].origin, level.player.origin) > 1024)
				aAxis[i] dodamage(aAxis[i].health * 1.25, level.player.origin);
			else
			{
				aAxis[i].pathenemyfightdist = 64;
				aAxis[i] clearEnemyPassthrough();
				aAxis[i] thread set_goalnode(axis_retreat_node,randomfloat(2) + .5);
				waittime++; 
			}
		}
		wait waittime * 2.5;
	}
	else
		wait 6;

	level.volsky thread Dialogue_Thread("tankhunt_volsky_penzenskaiast");
	wait 1.5;
	node = getnode("final_goal","targetname");

	aAi = getaiarray("allies");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i].goalradius = 0;
		if (aAi[i] == level.volsky)
			aAi[i] setgoalnode(node);
		else
			aAi[i] thread set_goalnode(node,randomfloat(3) + .5);
	}

	wait 13;

	maps\_endmission::nextmission();
}

square()
{
	level endon("square_delete");

	level thread square_door();

	aSpawner = getentarray("square_axis","script_noteworthy");
	level array_thread(aSpawner, ::square_axis);
	aSpawner = getentarray("square_allies","script_noteworthy");
	level array_thread(aSpawner, ::square_allies);

	square_trigger = getent("square_battle","script_noteworthy");
	square_trigger waittill("trigger");

	level thread square_delete();

	lookat_trigger = getent("square_lookat","targetname");
	lookat_trigger waittill("trigger");
	wait 12;

	killspawner = getent("square_killspawner","targetname");
	killspawner notify("trigger");

	wait 1;

//	iprintlnbold("Your comrades are  charging the square.");
	level notify("square_charge");

	wait 2;

	level thread playsoundinspace("walla_russian_small", (-1330, -584, 35));
}

square_delete()
{
	square_delete_trigger = getent("square_delete","targetname");
	square_delete_trigger waittill("trigger");

	killspawner = getent("square_killspawner","targetname");
	killspawner notify("trigger");

	wait 1;
	level notify("square_delete");
}

square_door()
{
	// open the door at the square
	door = getent("square_door","targetname");
	door rotateto((0,-120,0), 0.2);
	door connectpaths();

	trigger = getent("close_square_door","targetname");
	trigger waittill("trigger");

	// close the door at the square
	door = getent("square_door","targetname");
	door rotateto((0,0,0), 0.7);
	door disconnectpaths();
}

square_axis()
{
	level endon("square_delete");

	goals = getnodearray("square_delete_goal","targetname");

	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread square_axis_track(goals);
	}
}

square_axis_track(goals)
{
	self endon("death");

	msg = level waittill_any("square_charge","square_delete");
	if (msg == "square_delete")
		self delete();
	else
	{
		wait 3;
		self movetoanddelete(goals[randomint(goals.size)]);
	}
}

square_allies()
{
	level endon("square_delete");

	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread square_allies_track();
	}
}

square_allies_track()
{
	self endon("death");
	self.drawoncompass = false;

	msg = level waittill_any("square_charge","square_delete");
	if (msg == "square_delete")
	{
		wait randomfloat(5) + 0.1;
		self delete();
	}
	else
	{
		self.health = 1000;
		node = getnode("square_charge","targetname");
		self.goalradius = node.radius;
		self setgoalnode(node);

		level waittill("square_delete");
		wait randomfloat(5) + 0.1;
		self delete();
	}
}

join_forces()
{
	level waittill("tanks");

	level thread grab_volsky2();

	trigger = getent("join_forces","targetname");
	trigger waittill("trigger");

	aAi = getaiarray("allies");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i] setgoalentity(level.player);
	}
}

grab_volsky2()
{
	spawner = getent("volsky2","script_noteworthy");
	spawner waittill("spawned",ai);
	if (spawn_failed(ai))
	{
		assertmsg("volsky didn't spawn");
		return;
	}
	level.volsky = ai;
	level.volsky.animname = "volsky";
	level.volsky thread magic_bullet_shield();	
	level.volsky.followmax = 1;
	level.volsky.followmin = -3;
}

/********* vehicle control stuff *********/

setup_vehicle_pause()
{
	aVnode = getvehiclenodearray("pause","script_noteworthy");
	level array_thread (aVnode, ::vehicle_pause_node);
}

vehicle_pause_node()
{
	self waittill("trigger",vehicle);

	if (!isalive(vehicle))
		return;

	vehicle endon("death");
	vehicle endon("disabled");

	if (isdefined(vehicle.node_action) && vehicle.node_action)
		vehicle waittill("node action done");

	vehicle.node_action = true;

	vehicle setspeed(0,10);
	pause_trigger = undefined;

	if (isdefined(self.target))
		pause_trigger = getent(self.target,"targetname");

	if (isdefined(self.radius))
	{
		trigger = spawn( "trigger_radius", vehicle.origin, 0, self.radius, 256);
		trigger waittill("trigger");
		trigger delete();
	}
	else if (isdefined(pause_trigger))
	{
		pause_trigger waittill("trigger");
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

setup_vehicle_fire()
{
	aVnode = getvehiclenodearray("fire","script_noteworthy");
	level array_thread (aVnode, ::vehicle_fire_node);
}

vehicle_fire_node()
{
	self waittill("trigger",vehicle);

	if (!isalive(vehicle))
		return;

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

	stoped = false;
	if (isdefined(self.script_wait) || isdefined(self.radius) || isdefined(brush_trigger))
	{
		stoped = true;
		vehicle setspeed(0,10);
	}
	
	assert(isdefined(eTarget));

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
		level thread exploder(eTarget.script_exploder);

	vehicle clearTurretTarget();
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

tank_explosives()
{
	self endon ("death");

	self thread tank_ondeath();
	self.bombTriggers = [];
	self.bombs = [];

	tags = [];
	tags[0] = "tag_engine_left";
	tags[1] = "tag_left_wheel_07";
	tags[2] = "tag_right_wheel_07";
	location_angles = [];
	location_angles[0] = (0,70,-90);
	location_angles[1] = (0,-90,0);
	location_angles[2] = (0,90,0);

	for (i=0; i < tags.size; i++)
	{
		bomb = spawn("script_model", self gettagorigin(tags[i]));
		bomb setmodel("xmodel/weapon_stickybomb_obj");
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
	level notify("sticky planted");

	bomb = self.bombs[id];

	remove_stickys(self.bombs,id);

	bomb setmodel ("xmodel/weapon_stickybomb");
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

		if (bomb.tanktag == "tag_right_wheel_07")
			self setmodel("xmodel/vehicle_panzer_ii_winter_r_tread_d");
		else
			self setmodel("xmodel/vehicle_panzer_ii_winter_l_tread_d");

//		self stopenginesound();
		self disconnectpaths();
		self.vehicle_disabled = true;

		self playsound ("grenade_explode_default");
		level maps\_fx::OneShotfx("sticky_explosion", bomb.origin, 0.1);
		self thread maps\_fx::loopfx("sticky_explosion_smoke",self gettagorigin("tag_engine_left"), 2,undefined);

		explosion_origin = bomb.origin;

		bomb.trigger.inuse = undefined;
		bomb delete();

		nocover_radiusdamage(explosion_origin, 200, 300, 50);

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

tank_runup_guys(origin)
{
	aAI = getaiarray("allies");
	aGuys = [];
	aGuys[0] = undefined;
	aGuys[1] = undefined;

	for (i=0; i<aAi.size; i++)
	{
		if (isdefined(level.volsky) && aAi[i] == level.volsky)
			continue;
		dist = distance(origin,aAi[i].origin);

		if (!isdefined(aGuys[0]))
			aGuys[0] = aAi[i];
		else if (dist < distance(origin,aGuys[0].origin))
		{
			aGuys[1] = aGuys[0];
			aGuys[0] = aAi[i];
		}
		else if (!isdefined(aGuys[1]))
			aGuys[1] = aAi[i];
		else if (dist < distance(origin,aGuys[1].origin))
		{
			aGuys[1] = aAi[i];
		}
	}

	return aGuys;
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
	
	// Get ai to play the animations
	aAi = tank_runup_guys(self.origin);

	runupguy = aAi[0];
	gunguy = aAi[1];

	// if no guy can be found, kill the tank after 3 seconds.
	if (!isdefined(runupguy) || isdefined(level.runupactive) && level.runupactive)
	{
		wait 2;
		self notify ("death", level.player);
		return;
	}

	level.runupactive = true;
 
	runupguy thread runupguy_animation(self,gunguy);
	if (isdefined(gunguy))
		gunguy thread gunguy_animation(self,runupguy);

	// Will kill the tank if the ai doesn't move towards the tank, or if to much time goes by.
	self thread runup_guy_stuck(runupguy,gunguy);

	// make the tank reset it's turret to the default position so that the animations will match.
	self notify("stop cycle");
	self clearturrettarget();
	offset = angleoffset(self.angles, (100000,0,0));
	self setturrettargetent(self, offset);
}

runupguy_animation(tank,gunguy)
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

	// play dialogue
	switch(level.runups)
	{
		case 1:
			self thread Dialogue_Thread("demolition_rs4_motherrussia");
			break;
		case 2:
			self thread Dialogue_Thread("commissar_charge_attack");
			break;
		default:
			self thread Dialogue_Thread("commissar_charge_killfascists");
			break;
	}

	level.runups++;

	if ( isdefined(gunguy) && !isdefined(gunguy.atgoal) && !isdefined(self.noclimb) )
	{
		// climb tank
		self anim_single_solo(self, "grenadetank", "tag_origin", undefined, tank);
		// anim_loop_solo ( guy, anime, tag, ender, node, tag_entity )
		self thread anim_loop_solo (self, "grenadetank_loop", "tag_origin", "end_loop", undefined, tank);
		if ( isdefined(gunguy) && isalive(gunguy) )
			gunguy on_location();
		self notify("end_loop");
	}
	else
	{
		// climb tank
		self anim_single_solo(self, "grenadetank", "tag_origin", undefined, tank);
	}

	tank thread hatch();
	self notify("end_loop");

	if ( randomint(2) )
		self thread Dialogue_Thread("moscow_rs3_fireinthehole");

	self anim_single_solo(self, "grenadetank_run","tag_origin",undefined,tank);

	self notify("stop magic bullet shield");
	self.ignoreme = false;
	self.maxsightdistsqrd = self.old_maxsightdistsqrd;
	self.pathenemyfightdist = self.old_pathenemyfightdist;
	if (isalive(self))
		self thread friendlyMethod();

	badplace_cylinder("", 4, self.origin, 350, 350, "allies","axis");

	wait 3.5;
	level.runupactive = false;
	tank notify ("death", level.player);
}

gunguy_animation(tank,runupguy)
{
	tank endon("death");

	self endon("gunguy timeout");
	self endon("death");

	self.atgoal = undefined;
	self.animname = "gunguy";
	self.ignoreme = true;

	self.old_maxsightdistsqrd = self.maxsightdistsqrd;
	self.maxsightdistsqrd = (256*256);
	self.old_pathenemyfightdist = self.pathenemyfightdist;
	self.pathenemyfightdist = 64;
	self clearEnemyPassthrough();
	self thread magic_bullet_shield();

	// run to tank
	wait 1;
	self anim_reach_solo (self, "grenadetank", "tag_origin", undefined, tank);

	if (!isdefined(runupguy.atgoal))
	{
		// skip gunguy
		self.noclimb = true;
		self notify("stop magic bullet shield");
		self.ignoreme = false;
		self.maxsightdistsqrd = self.old_maxsightdistsqrd;
		self.pathenemyfightdist = self.old_pathenemyfightdist;
		self thread friendlyMethod();
		return;
	}

	self.atgoal = true;
	self notify("climb anim started");

	// climb tank
	self anim_single_solo(self, "grenadetank","tag_origin", undefined, tank);

	self.animdone = true;
	self notify("climb anim done");

	tank thread hatch();
	self anim_single_solo(self, "grenadetank_run","tag_origin", undefined, tank);

	self notify("stop magic bullet shield");
	self.ignoreme = false;
	self.maxsightdistsqrd = self.old_maxsightdistsqrd;
	self.pathenemyfightdist = self.old_pathenemyfightdist;
	if (isalive(self))
		self thread friendlyMethod();
}

on_location()
{
	self endon("death");
	self endon("gunguy timeout");
	// if gunguy hasn't started his animation start timeout thread
	if (!isdefined(self.atgoal))
		self thread time_out();
	if (!isdefined(self.animdone))
		self waittill("climb anim done");
}

time_out()
{
	self endon("death");
	self endon("climb anim started");
	self endon("climb anim done");
	wait 2;
	self notify("gunguy timeout");

	self notify("stop magic bullet shield");
	self.ignoreme = false;
	self.maxsightdistsqrd = self.old_maxsightdistsqrd;
	self.pathenemyfightdist = self.old_pathenemyfightdist;
	self thread friendlyMethod();
}

runup_guy_stuck(runupguy,gunguy)
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
		runupguy thread friendlyMethod();
	}

	// reset gunguy values
	if (isdefined(gunguy) && isalive(gunguy))
	{
		gunguy notify("stop magic bullet shield");
		gunguy.ignoreme = false;
		gunguy.maxsightdistsqrd = gunguy.old_maxsightdistsqrd;
		gunguy.pathenemyfightdist = gunguy.old_pathenemyfightdist;
		gunguy thread friendlyMethod();
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

	trigger setHintString (&"TANKHUNT_PLATFORM_PLANT_STICKY_BOMB");

	while(true)
	{
		trigger waittill ("trigger");

		level.player.stickybomb--;
		if (level.player.stickybomb <= 0)
			level.inv_sticky maps\_inventory::inventory_destroy();

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

cycle_tank_target()
{
	self endon("death");
	self endon("stop cycle");
	self.cycle_target = true;

	while(true)
	{
		if (self.cycle_target == false)
		{
			wait 1;
			continue;
		}
		ai = getaiarray("allies");

		odds = 2;
		skill = getdifficulty();
		if (skill == "easy")
			odds = 5;
		else if (skill == "medium")
			odds = 4;
		else if (skill == "difficult")
			odds = 3;
		else if (skill == "fu")
			odds = 2;

		target = undefined;

		if (randomint(odds))
		{
			if (isdefined(ai) && ai.size > 0)
				target = ai[randomint(ai.size)];
		}
		else
			target = level.player;

		iRnd = randomint(3)+1;

		for(i=0; i < iRnd; i++)
		{
			if (!isalive(target) || !self.cycle_target)
				break;

			value = randomint(96) + randomint(96) + randomint(96) - 144;
			offset = (value , value , 45);

			if (isdefined(target))
			{
				self setturrettargetent(target, offset);
				self waittill("turret_on_target");
			}
			if (!self.cycle_target)
				break;
			self clearTurretTarget();
			wait (randomfloat(3) + 1) / iRnd;
		}
	}
}

tank_ondeath()
{
	self waittill("death");
	level thread remove_stickys(self.bombs);
	level notify("tank destroyed",self.pos_id);
}

/********* utilities *********/

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

propaganda()
{
	self waittill("trigger");
	wait randomint(3);
	location = getent(self.target,"targetname");
	soundalias = level.propaganda[ int(self.script_noteworthy) ];
	playsoundinspace(soundalias, location.origin);
}

savebyname()
{
	self waittill("trigger");

	switch(int(self.script_noteworthy))
	{
		case 1:
			autosavebyname("long_road");
			break;
		case 2:
			autosavebyname("long_road_2");
			break;
		case 3:
			autosavebyname("third_floor");
			break;
		case 4:
			autosavebyname("dormitory");
			break;
		case 5:
			autosavebyname("crossroad");
			break;
		case 6:
			autosavebyname("dormitory");
			break;
		case 7:
			autosavebyname("tankhunt");
			break;
	}
}

killplayer()
{
	 level.player enableHealthShield( false );
	  level.player doDamage (level.player.health, level.player.origin); //killplayer
	 level.player enableHealthShield( true );
}

movetoanddelete(node)
{
	self endon("death");
	assert(isdefined(node));
	if (isdefined(self.script_wait))
		wait self.script_wait;
	else
		wait randomfloatrange (0.1, 1);
	self.goalradius = 0;
	self.maxsightdistsqrd = (256*256);
	self.pathenemyfightdist = 64;
	self clearEnemyPassthrough();
	self setgoalnode(node);
	self waittill("goal");
	self delete();
}

hide_ent(connect)
{
	self hide();
	self.origin = self.origin + (0,0,-1000);
	if (self.spawnflags & 1)
	{
		if (isdefined(connect) && self.classname == "script_brushmodel")
			self connectpaths();
	}
}

show_ent(disconnect)
{
	self show();
	self.origin = self.origin + (0,0,1000);
	if (self.spawnflags & 1)
	{
		if (isdefined(disconnect) && self.classname == "script_brushmodel")
			self disconnectpaths();
	}
}

autofire_mg(targetname,tank)
{
	if (isdefined(tank))
		tank endon("death");

	if (isdefined(targetname))
		aBullseye = getentarray(targetname,"targetname");
	else
		aBullseye = getentarray(self.target,"targetname");
	while(true)
	{
		bullseye = aBullseye[randomint(aBullseye.size)];
		target = self getturrettarget();
		if (isdefined(target) && target == bullseye)
		{
			self cleartargetentity();
			wait randomfloatrange(2,5);
		}
		else if (!isdefined(target))
		{
			self settargetentity(bullseye);
			wait randomfloatrange(3,8);
		}
		else
			wait 1;
	}
}

follow(ent,min,max)
{
	// used with friendly chains to make the self ai follow the entity, usually the player. 
	// a short random delay will make them start move more naturally.
	
	self endon("death");
	assertEX(isdefined(min),"min must be set");
	assertEX(isdefined(max),"max must be set");

	wait randomfloatrange(0.1,3);
	self setgoalentity(ent);
	self.followmin = min;
	self.followmax = max;
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

setup_contained()
{
	aTrigger = getentarray("kill_contained","targetname");
	level array_thread(aTrigger, ::contained);
}

contained()
{
	while(true)
	{
		self waittill("trigger");
		aAi = getaiarray("axis");
		for (i=0; i<aAi.size; i++)
		{
			if (isdefined(aAi[i].script_noteworthy) && aAi[i].script_noteworthy == "contained")
				aAi[i] delete();
		}
	}
}

setup_sortie()
{
	aSpawner = getentarray("sortie","script_noteworthy");
	level array_thread(aSpawner, ::sortie);
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
	self.goalradius = 720;
}

objective_follow(obj_id)
{
	self endon("stop objective follow");
	self endon("death");

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

set_goalnode(node,delay)
{
	self endon("death");

	wait delay;
	self setgoalnode(node);
}

friendlyMethod(guy)
{
	if (!isdefined (guy))
		guy = self;

	if (level.friendlyMethod == "friendly chains")
	{
		guy.followmin = level.followmin;
		guy.followmax = level.followmax;
		guy setgoalentity (level.player);
		guy.friendlyWaypoint = false;
		if (isdefined(level.friendlyradius))
			guy.goalradius = level.friendlyradius;
		guy setgoalentity (level.player);
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
