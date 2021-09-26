#include maps\_utility;
#include maps\_anim;
#include animscripts\utility;
main()
{
	/*
	*/
//	thread drawvehiclepath(getent("britishtank_spawner2","targetname"));
//	thread drawvehiclepath(getent("britishtank_spawner3","targetname"));
//	thread liner((-748, 507, 106), (-346, 998, -135));
    setCullFog (300, 3500, 25/256, 45/256, 48/256, 0.1);
	precacheModel("xmodel/tag_origin");
	precacheShader("objectiveA");
	precacheShader("objectiveB");
	precacheShader("objectiveC");
	precacheShader("objectiveD");
	precacheShader("objectiveE");
	
	level.smoke_grenade_weapon = "smoke_grenade_american_night";
	maps\_flak88::main("xmodel/german_artillery_flak88");
	maps\_sherman::main("xmodel/vehicle_american_sherman");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_tankai::main();
	maps\_tankai_sherman::main("xmodel/vehicle_american_sherman");
	maps\newvillers_fx::main();
	level thread maps\newvillers_amb::main();
	maps\_load::main();
	maps\newvillers_anim::main();

	level.active_objective = [];
	level.inactive_objective = [];
	
	level.objectiveDelay = 1.8; // used after each objective is completed so it doesnt seem so fast
	flag_init("stopchat" + "first_house");	// first_house
	flag_init("stopchat" + "alley");	// alley
	flag_init("stopchat" + "town_hall");	// town hall
	flag_init("stopchat" + "ne_house");	// north east house
	flag_init("stopchat" + "flak");	// flak
	flag_init("stopchat" + "church");	// Church
	flag_init("stopchat" + "sw_house");	// south west house
	flag_init("tank_done");
	flag_init("tank_fight");
	flag_init("brit2_ready");
	flag_init("brit2_firing");
	flag_init("tank_moveup_1");
	flag_init("tank_moveup_2");
	flag_init("final_tank_battle");
	flag_init("tank2_flee");
	flag_init("final_tank_under_fire");
	flag_init("tiger_destroyed");
	flag_init("tank!");
	flag_init("mission_complete");	
	flag_init("player_passed_first_building");
	flag_init("player_entered_backyard");

	// checks if the player goes right early, forcing the friendlies to switch to the backyard
	getent("player_enters_backyard","targetname") thread backyardTrigger();

	level.price = getent ("price","script_linkname");
//	level.price setBattleChatter(false);
	level.price thread magic_bullet_shield();
	level.price.animname = "price";
	level.price thread priceQueue(); // for prices voice
	level.price.looktarget = level.player;
	thread allyOverrides();	
	//*** Visuals
//      setCullFog (1000, 5500, 0.75, .82, .85, 0);

//	setCullFog (300, 3500, 0.75, 1, 1, 1);
//	setCullFog (0, 4500, 0.75, .82, .85, 0);
//	setCullFog (1750, 2000, 0.75, .82, .85, 0);
	setsavedcvar("r_specularColorScale", "3");
	setsavedcvar("r_cosinePowerMapShift", "-0.9");

	level.maxdist = 256;
	level.fightdist = 256;
	
	// Player starts on a random friendlychain
	playerChain = random(getnodearray("startnode","script_noteworthy"));
	thread friendlyChainChatter();
	level.player setFriendlyChainWrapper(playerChain);
	
	array_thread (getentarray("stopchat","script_noteworthy"), ::stopChatTrigger);
	array_thread (getentarray("grenade","script_noteworthy"), ::grenadeTossGuy);
	//array_thread (getentarray("smoke", "targetname"), ::throwSmoke);
	array_thread (getentarray("atmosphere_spawn","targetname"), ::atmosphere_spawn);
	array_thread (getentarray("atmosphere_kill","targetname"), ::atmosphere_kill);
	array_thread (getentarray("axis_death","targetname"), ::axis_death);
	array_thread (getentarray("save_if_no_axis","targetname"), ::save_if_no_axis);
	
	// guys that spawn and get a big goal radius then attack the player
	array_thread (getentarray("player_attack","script_noteworthy"), ::player_attack); 
	// guys that spawn and get a low interval so they dont run into each other
	array_thread (getentarray("interval","script_noteworthy"), ::intervalSpawner);
	array_thread (getentarray("spawn_and_delete","targetname"), ::spawnAndDelete);
	

	array_thread (getentarray("squad", "targetname"), ::squadThink);
	array_thread (getentarray("tank_moveup","targetname"), ::tank_moveup_trigger);  // makes the 2nd brit tank move up
	array_thread (getentarray("tank_target","targetname"),::exploderPreTrigger); // makes the barricade destroyable by tanks
	array_thread (getentarray("price_line","targetname"),::priceStartLine); // makes price queue a specific line when he enters it
	array_thread (getentarray("hard_only","script_noteworthy"),::hardOnlySpawner); // these guys are only on hard or vet

	getent ("church_bells", "script_noteworthy") thread churchBells();
	
	// sends AI defending the church inside if the player enters the church, so its not empty yet objective is not complete
	// and the sw_house
	getent("player_enters_church", "targetname") thread defendTrigger(7);
	getent("player_enters_sw_house", "targetname") thread defendTrigger(6);
	getent("player_enters_townhall", "targetname") thread defendTrigger(5);
	getent("britishtanks","targetname") thread spawnBritishTanks();
	getent("tank_moves_up_1","targetname") thread tankMoveUpTrigger();
	getent("door_save","targetname") thread doorSave();	


	precacheString(&"NEWVILLERS_OBJ_1");
	precacheString(&"NEWVILLERS_OBJ_2");
	precacheString(&"NEWVILLERS_OBJ_3");
	precacheString(&"NEWVILLERS_OBJ_4");
	precacheString(&"NEWVILLERS_OBJ_5");
	level.objText1 = &"NEWVILLERS_OBJ_1"; //"Secure the Town Hall"
	level.objText2 = &"NEWVILLERS_OBJ_2"; //"Take the Post Office"
	level.objText3 = &"NEWVILLERS_OBJ_3"; //"Kill the Flak Operators"
	level.objText4 = &"NEWVILLERS_OBJ_4"; //"Clear the Church grounds"
	level.objText5 = &"NEWVILLERS_OBJ_5"; //"Capture the German HQ"
	objective_add(1, "active", level.objText1, getObjOrigin("center"));
	objective_add(2, "active", level.objText2, getObjOrigin("ne"));
	objective_add(3, "active", level.objText3, getObjOrigin("flak"));
	objective_add(4, "active", level.objText4, getObjOrigin("church"));
	objective_add(5, "active", level.objText5, getObjOrigin("sw"));

	
	objective = getcvar("start");
	if (objective == "")
		setcvar("start","start");
	setObjective_inactive("obj1");
	setObjective_inactive("obj2");
	setObjective_inactive("obj3");
	setObjective_inactive("obj4");
	setObjective_inactive("obj5");

	if (objective == "obj2")
	{
		thread tiger_tank_part2_jump();
		thread setPlayerToObjectiveFriendlyChain("center_house");
		rifleGuysTeleportObjective("center_obj_defend");
	}
	else
	if (objective == "obj3")
	{
		thread tiger_tank_part2_jump();
		thread setPlayerToObjectiveFriendlyChain("ne_house");
		rifleGuysTeleportObjective("ne_obj_defend");
	}
	else
	if (objective == "obj4")
	{
		thread tiger_tank_part2_jump();
		thread setPlayerToObjectiveFriendlyChain("flak");
	}
	else
	if (objective == "obj5")
	{
		thread setPlayerToObjectiveFriendlyChain("church");
		rifleGuysTeleportObjective("nw_obj_defend");
	}

	objective1();
}

setPlayerToObjectiveFriendlyChain(msg)
{
	objEvent = getObjEvent(msg);
	objEvent objSetChainAndEnemies();
	node = getnode(objEvent.target,"targetname");
	level.player setorigin (node.origin);
	level.player.angles = node.angles;
	waittillframeend;
	ai = getentarray("squad", "targetname");
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] != level.price)
			ai[i] delete();
	}
	level.price teleport (level.player.origin + (45,45,0));
}


Objective1()
{
	if (getcvar("start") == "start")
		thread tankSequence();
	
	// objective 1
	objEvent = getObjEvent("center_house");
	setObjective_active("obj1");
	setObjective_active("obj2");
	setObjective_active("obj3");
	setObjective_active("obj4");
	setObjective_active("obj5");
	setCurrentObjective();
	thread objective2();
	thread objective3();
	thread objective4();
	thread objective5();

	objective_icon(1, "objectiveA");
	objective_icon(2, "objectiveB");
	objective_icon(3, "objectiveC");
	objective_icon(4, "objectiveD");
	objective_icon(5, "objectiveE");
	
	objEvent waittill_objectiveEventNoTrigger();
	flag_set ("stopchat" + "town_hall");
	wait (level.objectiveDelay + randomfloat(0.5));
	objective_state(1, "done");
	maps\_utility::autosave(2);
	wait (0.2);
	//iprintlnBold ("We've secured the town hall. Bradley, Jacobs, hold this position while we move up to the post office.");

	setObjective_inactive("obj1");
	setCurrentObjective();

	if (flag("mission_complete"))
		return;

	if (objectiveIsActive("obj2"))
		thread priceLine ("postoffice");
	else
		thread priceLine ("follow_me");

	objEvent objSetChainAndEnemies();
	rifleGuysDefendObjective("center_obj_defend");
//	maps\_utility::autosave(1);
}

objective2()
{
	// objective 2
	objEvent = getObjEvent("ne_house");
//	objective_additionalcurrent(2,3,4,5);
	objEvent waittill_objectiveEventNoTrigger();
	flag_set ("stopchat" + "ne_house");
	maps\_utility::autosave(3);
	wait (0.2);
	//iprintlnBold ("Good work men. There should be a flak just up the road. Let's pay them a visit!");
	objective_state(2, "done");
	setObjective_inactive("obj2");
	setCurrentObjective();
	
	if (flag("mission_complete"))
		return;
		
	if (objectiveIsActive("obj3"))
		thread priceLine ("flakgun");
	else
		thread priceLine ("follow_me");
	objEvent objSetChainAndEnemies();

	rifleGuysDefendObjective("ne_obj_defend");
}

objective3()
{
	// objective 3 flak
	objEvent = getObjEvent("flak");
	objEvent waittill_objectiveEventNoTrigger();
	objective_state(3, "done");
	setObjective_inactive("obj3");
	setCurrentObjective();
	wait (level.objectiveDelay + randomfloat(0.5));
	maps\_utility::autosave(4);
	wait (0.2);
	//iprintlnBold ("We won't have to worry about that flak again, good work. Now we need to clear the church.");

	if (flag("mission_complete"))
		return;
	if (objectiveIsActive("obj4"))
		thread priceLine ("securechurch");
	else
		thread priceLine ("follow_me");

	objEvent objSetChainAndEnemies();
//	rifleGuysDefendObjective("ne_obj_defend");
}

objective4()
{
	// objective 4 church
	objEvent = getObjEvent("church_inside");
	objEvent waittill_objectiveEventNoTrigger();
	objEvent = getObjEvent("church");
	objEvent waittill_objectiveEventNoTrigger();
//	killAllSpawnersWestOf(-1584);
//	array_thread (getaiarray("axis"), ::delayedDeath); // kill all the straggler axis running around
	flag_set ("stopchat" + "church");
	wait (level.objectiveDelay + randomfloat(0.5));
	objective_state(4, "done");
	wait (0.2);
	maps\_utility::autosave(4);
	//iprintlnBold ("The church looks secure! Nelson and Wetley, hold the church until reinforcements arrive. Everybody else, you're with me. We have to take the German HQ! Let's move out!");

	setObjective_inactive("obj4");
	setCurrentObjective();
	
	if (flag("mission_complete"))
		return;

	if (objectiveIsActive("obj5"))
		thread priceLine ("germanhq");
	else
		thread priceLine ("follow_me");

	objEvent objSetChainAndEnemies();
	rifleGuysDefendObjective("nw_obj_defend");
}

objective5()
{
	// objective 5 hq
	objEvent = getObjEvent("sw_house_upstairs");
	objEvent waittill_objectiveEventNoTrigger();
	objEvent = getObjEvent("sw_house");
	objEvent waittill_objectiveEventNoTrigger();
	flag_set ("stopchat" + "sw_house");
	wait (level.objectiveDelay + randomfloat(0.5));
	objective_state(5, "done");
	setObjective_inactive("obj5");
	setCurrentObjective();
//	objEvent objSetChainAndEnemies();
	rifleGuysDefendObjective("sw_obj_defend");
//	iprintlnbold ("Good work men, the town is secure.");
//	nearestGenericAllyLine ("");
	wait (2.5);
	flag_wait("mission_complete");
	thread priceLine ("squadleaders"); // listen_up
	level waittill ("queue_cleared"); // notify is guarenteed since we start a dialogue line above

	wait (2);
	maps\_endmission::nextmission();

//	maps\_utility::autosave(5);
}

all_objectives_are_complete_except_first()
{
	if (objectiveIsActive("obj2"))
		return false;
	if (objectiveIsActive("obj3"))
		return false;
	if (objectiveIsActive("obj4"))
		return false;
	return (objectiveIsInactive("obj5"));
}

setCurrentObjective()
{
	if (objectiveIsActive("obj1"))
	{
		objective_current(1);
		if (all_objectives_are_complete_except_first())
		{
			playerChain = getnode("shift_center","script_noteworthy");
			level.player setFriendlyChainWrapper(playerChain);
		}
	}
	else
	if (objectiveIsActive("obj2"))
		objective_current(2);
	else
	if (objectiveIsActive("obj3"))
		objective_current(3);
	else
	if (objectiveIsActive("obj4"))
		objective_current(4);
	else
	if (objectiveIsActive("obj5"))
		objective_current(5);
	else
	{
		flag_set("mission_complete");
		array_thread (getaiarray("axis"), ::delayedDeath); // kill all the straggler axis running around
		spawners = getspawnerarray();
		for (i=0;i<spawners.size;i++)
		{
			if (isdefined (spawners[i].script_killspawner))
				spawners[i] delete();
		}
		return;
	}

	if (objectiveIsActive("obj2"))
		objective_additionalcurrent(2);
	if (objectiveIsActive("obj3"))
		objective_additionalcurrent(3);
	if (objectiveIsActive("obj4"))
		objective_additionalcurrent(4);
	if (objectiveIsActive("obj5"))
		objective_additionalcurrent(5);

}

rifleGuysDefendObjective(msg)
{
	// makes AI turn into defenders that hang back at the objective
	if (1) return; 
	objNodes = getnodearray(msg,"script_noteworthy");
	for (i=0;i<objNodes.size;i++)
		objNodes[i] moveRifleGuyToNode(false);
}

rifleGuysTeleportObjective(msg)
{
	objNodes = getnodearray(msg,"script_noteworthy");
	for (i=0;i<objNodes.size;i++)
		objNodes[i] moveRifleGuyToNode(true);
}

moveRifleGuyToNode(teleporter)
{
	rifleGuy = undefined;
	for (;;)
	{
		rifleGuys = [];
		ai = getentarray("rifleguy","script_noteworthy");
		for (i=0;i<ai.size;i++)
		{
			if (ai[i] == level.price)
				continue;
			rifleGuys[rifleGuys.size] = ai[i];
		}
		rifleGuy = getClosestLiving(self.origin, rifleGuys);
		if (!isalive(rifleGuy))
		{
			// couldnt find any
			wait (0.25);
			continue;
		}
		
		rifleguy.script_noteworthy = undefined;
		rifleGuy notify ("leaveSquad");
		rifleGuy waittill ("leftSquad");
		if (!isalive(rifleGuy))
		{
			// he could have died on the same frame we notified him to leave the squad
			continue;
		}
		break;
	}

	if (teleporter)
		rifleguy teleport (self.origin);
	rifleGuy thread magic_bullet_shield();
	rifleGuy setgoalnode (self);
	rifleGuy.goalradius = 32;
}

debugHelp()
{
	num = 0;
	if (!level.debug_corevillers)
		return;
	
	for (;;)
	{
		num+= 12;
		scale = sin(num) * 0.4;
		if (scale < 0)
			scale *= -1;
		scale += 1;
		
		if (isdefined (level.smgGuy))
			print3d(level.smgGuy.origin + (0,0,60), "SMGguy", (0,0.4,1), 1, scale);
		if (isdefined (level.smgNode))
			print3d(level.smgNode.origin + (0,0,10), "SMGnode", (0,0.4,1), 1, scale);
			
		wait (0.05);
	}
}
// target auto1115
//auto1116 targets auto1103 targets auto1114
//auto1114


linedraw()
{
	start = self getorigin();
	end = getent(self.target,"targetname") getorigin();
	for (;;)
	{
		line(start, end, (1,0,0),1);
		wait (0.05);
	}
}


throwSmokeThink(ent)
{
	self endon ("death");
//	maps\_hardpoint::waitUntilSmokeIsThrown(ent);
	org = self.smoke_destination_org;
	if (!isdefined(self.oldGrenadeWeapon))
		self.oldGrenadeWeapon = self.grenadeWeapon;
		
	self.grenadeWeapon = "smoke_grenade_american_night";
	self.grenadeAmmo++;

	msg = (" " + org);
//	self MagicGrenadeManual (self.origin + (0,0,80), ent.origin + randomvec(100), 0);
	self MagicGrenade (self.origin + (0,0,50), ent.origin, 2.5);
	level.smokeThrowSmokeTime[msg] = gettime();
/*	
	if (TrySmokeGrenadePos(org))
		level.smokeThrowSmokeTime[msg] = gettime();
	else
		self.grenadeAmmo--;
*/		
	self.grenadeWeapon = self.oldGrenadeWeapon;
}

throwSmoke()
{
	org = getent(self.target,"targetname").origin;
	ent = getent(self.target,"targetname");
	msg = (" " + org);
	level.smokeThrowSmokeTime[msg] = -500000;
	for (;;)
	{
		self waittill ("trigger", other);

		assert (other != level.player); // player cant be forced to throw smoke!
		if (gettime()< level.smokeThrowSmokeTime[msg] + 60000 )
		{
			wait (1);
			continue;
		}
		other.smoke_destination_org = org;
		other thread throwSmokeThink(ent);
//		other animcustom(animscripts\combat_utility::scriptSmokeGrenade);
	}
}

grenadeTossGuy()
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		org = getent(self.target,"targetname");
		dest = getent(org.target,"targetname").origin + randomvec(4);
		org = org.origin;
		velocity = vectorNormalize (dest - org);
		velocity = maps\_utility::vectorScale (velocity, distance (org, dest)*2);

		spawn magicGrenadeManual(org, velocity, 3.5);
	}
}

atmosphereSpawnerThink()
{
//	self.triggerUnlocked = true;
	self waittill ("spawned", spawn);
	spawn.health = 350;
}

atmosphere_Spawn()
{
	// guys that fight in the background for atmosphere
	spawners = getentarray(self.target,"targetname");
	array_thread(spawners, ::atmosphereSpawnerThink);
//	self waittill ("trigger");
}

atmosphere_Kill()
{
	self waittill ("trigger");
	ai = getentarray(self.script_noteworthy, "script_noteworthy");
	for (i=0; i<ai.size; i++)
	{
		if (!isalive(ai[i]))
			continue;
		if (ai[i].team == "axis")
			ai[i] thread selfDie(4 + randomfloat(3));
		else
			ai[i] thread selfDie(2 + randomfloat(3));
	}
}

selfDie(timer)
{
	self endon ("death");
	wait (timer);
	self dodamage( (self.health *1.5), (0,0,0) );
}
	
axis_death()
{
	self waittill ("trigger");
	trigger = getent(self.target,"targetname");
	while (level.player istouching (trigger))
		wait (0.5);

	axis = getaiarray("axis");
	for (i=0;i<axis.size;i++)
	{
		if (!isalive(axis[i]))
			continue;
			
		if (axis[i] istouching(trigger))
			axis[i] dodamage( (axis[i].health *0.5), (0,0,0) );
	}
}

save_if_no_axis()
{
	self waittill ("trigger");
	trigger = getent(self.target,"targetname");
	for (;;)
	{
		trigger waittill ("trigger");
		axis = getaiarray("axis");
		touching = false;
		for (i=0;i<axis.size;i++)
		{
			if (!isalive(axis[i]))
				continue;
				
			if (axis[i] istouching(trigger))
			{
				touching = true;
				break;
			}
			
			wait (0.05);
		}
		
		if (!touching)
			break;
	}
	
	maps\_utility::autosave(4);
}

squadThink()
{
	self.isSquad = true;
	if (self != level.price)
		thread maps\_spawner::squadRespawnThink();
	
	waittillframeend;
	if (objectiveIsInactive("obj1"))
	{
		self notify ("unload");
		self setgoalentity (level.player);
		return;
	}
	
		
	self endon ("death");
	self endon ("leftSquad");
	escortTankUntilItDies_or_PlayerEntersBackyard();
	self notify ("unload");
	self setgoalentity (level.player);
}

escortTankUntilItDies_or_PlayerEntersBackyard()
{
	level endon ("player_entered_backyard");	
	flag_wait ("tank_fight");
	self notify ("unload");
//	nodes = getnodearray ("tank_support_node","targetname");
	if (!flag("tank!"))
	{
		flag_set("tank!");
		wait (1);
		self.animname = "generic";
		thread nearestGenericAllyLine ("tiger_tank");
	}

	wait (randomfloat(0.5));
	self allowedstances ("crouch");
	wait (randomfloat(1));
	self setgoalpos (self.origin);
	wait (2 + randomfloat(1));
	self allowedstances ("crouch", "prone", "stand");
	node = getent (self.script_linkto, "script_linkname");
	self setgoalpos (node.origin);
	self.goalradius = 32;
	flag_wait ("tank_done");
	wait (2);

	if (!isdefined(level.newvillers_move_line))
	{
		level.newvillers_move_line = true;
		thread nearestAllyBCSLine ("move_flank");
	}
	wait randomfloat(4.5);
//	wait (1);
}

tank_deathmonitor(name)
{
	flag_clear(name + "destroyed");
	self waittill ("death");
	flag_set(name + "destroyed");
}


tiger_tank_sequence()
{	
	level waittill ("tiger_start");
	eTiger = maps\_vehicle::scripted_spawn(0);	//spawns in the Tiger
	eTiger = eTiger[0];							
	etiger thread tiger_tank_Think();
}

tiger_tank_think()
{
	thread tiger_thickarmor();
	thread maps\_vehicle::gopath(self);
    self setSpeed(4, 1);
	
	node = getvehiclenode("townhall_tigersurprise", "script_noteworthy");
	node waittill ("trigger");
	self setSpeed(0, 100);
		
	level.brtank1.health = 1;
	//level.brtank1 thread healthprint();
	wait 5;	//let brtank1 fire a couple of ineffective shots
	tank_firing_sequence(level.brtank1);
//	flag_wait("brtank1destroyed");

	
	//++++try oscillating the turret a little bit to make it look like it's active
	
	//If player closes in enough, Tiger diverts and heads to the street behind the town hall
//	flag_wait("tigerfallback");	
	wait (5);
	self thread recenterTurret();
	self resumeSpeed(3);
	getvehiclenode("stop1","script_noteworthy") waittill ("trigger");
	self setspeed(0,10);
	
	flag_wait("brit2_ready");
	flag_wait("brit2_firing");
	self setTurretTargetEnt (level.brtank2, (0,0,60));
	wait (4.7);
	flag_set ("tank2_flee");
	wait (2);
	tank_firing_sequence(level.brtank2);
	// the bastard destroyed our tank
	thread nearestGenericAllyLine ("destroyed_our_tank");
	wait (1.5);
	self resumeSpeed(2);
	wait (1.2);
	self recenterTurret();

	getvehiclenode("stop2","script_noteworthy") waittill ("trigger");
	self setspeed(0,4); // stop
	tiger_tank_part2();
}		

tiger_tank_part2_jump()
{
	eTiger = maps\_vehicle::scripted_spawn(0);	//spawns in the Tiger
	eTiger = eTiger[0];							
	etiger thread tiger_tank_part2();
	level.tiger = eTiger;
	etiger thread tiger_thickarmor();
	etiger setspeed(6,6);
	getvehiclenode("stop2","script_noteworthy") waittill ("trigger");
	etiger setspeed(0,4); // stop
}

tiger_tank_part2()
{
	flag_wait("final_tank_battle");
	wait (6);
//	wait (14);
	self resumeSpeed(2);
	getvehiclenode("stop4","script_noteworthy") waittill ("trigger");
	self setspeed(0,4); // stop
	flag_wait("final_tank_under_fire");
	thread smokeGen();
	wait (0.3);
	self resumeSpeed(3);
	self setTurretTargetEnt (level.brtank4, (0,0,64));
//	self waittill ("reached_end_node");
	self tank_firing_sequence(level.brtank4);
	wait (5);
	wait (0.45);
	
	wait (4);
	self setTurretTargetEnt (level.brtank3, (0,0,64));
	wait (2);
	self tank_firing_sequence(level.brtank3);
	wait (2);
	path = getvehiclenode("tank_retreat","targetname");
	self attachPath(path);
	self startpath();
}

tiger_thickarmor()
{
	self endon ("death");
	self.health = 1000000;
	
	while(1)
	{
		self waittill("damage");
		self.health = 1000000;
		wait 0.05;
	}	
}


tiger_exit()
{	
	//Now tiger holds main exit position, laying down MG fire until British infantry get too close, then leaves town
	
//	thread tiger_exit_switch(); //activate the main exit path trigger
	
	flag_wait("tigerexit");
	
	//tiger leave town now
	
	self resumeSpeed(3);
	node = getvehiclenode("delete_tiger", "script_noteworthy");
	node waittill ("trigger");
	
	//self delete();
	thread maps\_vehicle::delete_group(self);
}

tank_move(name)
{
		vehicle = getent(name, "targetname");
//		level waittill ("move tanks");
    	thread maps\_vehicle::gopath(vehicle);
    	vehicle setSpeed(4, 1);
}

tankSequence()
{
	level thread tank_move("britishtank1");
	level.brtank1 = getent ("britishtank1","targetname");
	level.brtank1.allowUnloadIfAttacked = false;
	
//	level.brtank1 endon("death");
	level.brtank1 thread tank_deathmonitor("brtank1");

	tank2spawner = getent ("britishtank_spawner","targetname");
	tank2spawner notify ("trigger");
	level.brtank2 = getent ("britishtank_spawner","targetname");
//	level.brtank2 = spawnVehicle( tank2spawner.model, "whateveR", tank2spawner.vehicletype, tank2spawner.origin, tank2spawner.angles);;
	level.brtank2 thread tank2_Think();
	

	thread tiger_tank_sequence();
	
	// germans that run out to help the tiger
	array_thread(getentarray("tank_support_axis","targetname"), ::axisTankSupport);
	/*
	aAllies = getaiarray();
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].ignoreme = true;
	}
	*/
	
	//Tiger is spawned and begins its intercept
	node = getvehiclenode("tiger_activate", "script_noteworthy");
	node waittill("trigger");	
	
	level notify ("tiger_start");

	//All the following tanks halt as the Tiger begins to reveal itself, and stay out of the line of fire
	node = getvehiclenode("allstop", "script_noteworthy");
	node waittill("trigger");	
	
	level notify ("allstop");
	
	//Everyone bails and heads for some kind of cover to the front
	//++++dialogue needed
	//++++temp text, waiting for wav
	
	level notify ("ignoreme off");
	
//	level.brtank1 notify ("unload");
	
	wait 0.05;
	
//	iprintlnbold("GENERIC SOLDIER 1: Tiger tank!!! Take cover!!!!");
	
	flag_set ("tank_fight");
	//The first British tank stops dead in its tracks
	node = getvehiclenode("tank_pausepoint2", "script_noteworthy");
	node waittill("trigger");	
	
//	level Battlechatter_Allies("on");
	
	//The first British tank fires on the Tiger, to no effect, until it is destroyed by the Tiger
	level.tiger = getent("germantank1", "targetname");
	level.brtank1 setSpeed(0, 3);
	level.brtank1 thread tank_firing_sequence(level.tiger);
	level.brtank1 waittill ("death");

	flag_set("tank_done");
}

tank2_Think()
{
	self endon ("death");
   	thread maps\_vehicle::gopath(self);
   	self setSpeed(4, 1);
	
//	path = getvehiclenode(self.target,"targetname");
//	self attachPath(path);
	getvehiclenode("stop_point_1","script_noteworthy") waittill ("trigger");
	self setspeed(0,1);
	self setTurretTargetEnt (level.tiger, (0,0,64));
	self waittill("turret_on_vistarget");
	self clearturrettarget();
	flag_wait("tank_done");	
	
	// wait until no ai or the player are in the area before tank moves
	trigger = getent ("tank_wait_trigger","targetname");
	for (;;)
	{
		wait (0.4);
		if (level.player istouching (trigger))
			continue;
			
		touching = false;
		ai = getaiarray("allies");
		for (i=0;i<ai.size;i++)
		{
			if (!ai[i] istouching (trigger))
				continue;
			touching = true;
			break;
		}
		if (touching)
			continue;
		break;
	}
	
	wait (5);
	self resumespeed(2);
	self thread recenterTurret();
	getvehiclenode("tank_wait","script_noteworthy") waittill ("trigger");
	self setspeed(0,10);
	flag_wait("player_passed_first_building");

	self resumespeed(20);
	self thread recenterTurret();
	getvehiclenode("stop_point_2","script_noteworthy") waittill ("trigger");

	if (!flag("tank_moveup_1"))
	{
		self setspeed(0,2); // stop
		flag_wait ("tank_moveup_1");
		self resumespeed(2); // go
	}
	wait (0.05); // code bug
	getvehiclenode("stop_point_3","script_noteworthy") waittill ("trigger");
	if (!flag("tank_moveup_2"))
	{
		self setspeed(0,2); // stop
		flag_wait ("tank_moveup_2");
		self resumespeed(6); // go
	}
		
	flag_set("brit2_ready");
	thread stopPoint4();
	wait (4.5);
	self setTurretTargetEnt (level.tiger, (0,0,64));
//	self waittill ("reached_end_node");
	self waittill("turret_on_vistarget");
	flag_set("brit2_firing");
	self thread tank_firing_sequence(level.tiger);
	flag_wait ("tank2_flee");
}

exploderPreTrigger()
{
	//fire off these exploders when they get hit by the tank
	self.exploderNum = self.script_exploder;
	self.script_exploder = -1;
}

exploderTrigger()
{
	for (;;)
	{
		self waittill ("trigger",other);
		if (other == level.brTank4)
			break;
	}
	exploder(self.exploderNum);
}

spawnBritishTanks()
{
	self waittill ("trigger");
	tank_targets = getentarray("tank_target","targetname");

	flag_set("final_tank_battle");
	getent ("vehicle_spawner_1","targetname") notify ("trigger");
	getent ("vehicle_spawner_2","targetname") notify ("trigger");
	waittillframeend; // give them a chance to spawn
	level.brTank3 = getent ("britishtank_spawner2","targetname");
	level.brTank4 = getent ("britishtank_spawner3","targetname");

	path = getvehiclenode(level.brTank3.target,"targetname");
	level.brTank3 attachPath(path);

	level.brTank3 recenterTurreT();	
	level.brTank4 recenterTurreT();	
	
	path = getvehiclenode(level.brTank4.target,"targetname");
	level.brTank4 attachPath(path);
	level.brTank4 startpath();
	wait (1);
	level.brTank3 startpath();
	wait (1);
	level.brTank4 setTurretTargetVec(tank_targets[0] getorigin() + (0,0,-35));
	tank_targets[0] thread exploderTrigger();
	level.brTank4 waittill ("turret_on_target");
	level.brTank4 fireTurreT();

	wait (1);
	level.brTank4 setTurretTargetVec(tank_targets[1] getorigin() + (0,0,-35));
	tank_targets[1] thread exploderTrigger();
	level.brTank4 waittill ("turret_on_target");
	level.brTank4 fireTurreT();
	wait (1);
	level.brTank4 recenterTurret();

	level.brTank4 waittill ("reached_end_node");
	wait (2);
	level.brTank4 thread tank_firing_sequence(level.tiger, 5);
	flag_set("final_tank_under_fire");
	
	
	wait (3);
	level.brTank3 thread tank_firing_sequence(level.tiger, 5.5);
//	level.tiger thread tank_firing_sequence(level.brTank3);
	flag_wait ("tiger_destroyed");
	/*
	wait (2);
	level.brTank3 recenterTurret();
	wait (0.45);
	path = getvehiclenode("exit","targetname");
	level.brTank3 attachPath(path);
	level.brTank3 startpath();
	level.brTank3 waittill ("reached_end_node");
	level.brTank3 delete();
	*/
//	level.tiger thread tank_firing_sequence(level.brTank4);
}

tank_firing_sequence(eTarget, delay)
{
	self endon ("death");
	self setTurretTargetEnt (eTarget, (0,0,64));
	self waittill("turret_on_vistarget");
	
	wait 1;
	if (!isdefined(delay))
		delay = 3.5;
	
	while(isalive(eTarget))
	{
		//self maps\_tank::fire();	
		self fireTurreT();
	
		//++++temp until a bug is fixed with the tanks not being able to hit each other, or use this as a failsafe
		if(eTarget.targetname != "germantank1")
			radiusDamage(eTarget.origin, 320, 10050, 10050);
	
		wait delay;	//cycle time on loader
	}
}


DefendTrigger(deathchain)
{
	flag_clear ("player_entered" + deathchain);
	// makes the guys that're outside the objective invade it if the player enters it
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	{
		if (!isdefined(spawners[i].script_deathchain))
			continue;
		if (spawners[i].script_deathchain != deathchain)
			continue;
		spawners[i] thread spawnerInvadeGuy();
	}
	self waittill ("trigger");
	if (isdefined(self.script_delay))
		wait (self.script_delay);
	flag_set ("player_entered" + deathchain);
}

spawnerInvadeGuy()
{
	// invades the objective building when the player enters it
	self endon ("death");
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (spawn_failed(spawn))
			assert(0);
		spawn thread spawnChurchAttack();
	}
}

spawnChurchAttack()
{
	self endon ("death");
	flag_wait("player_entered" + self.script_deathchain);
	wait (randomfloat (1));
	self setgoalentity (level.player);
	self.goalradius = 350;
	self.pathenemyfightdist = 400;
	self.pathenemylookahead = 400;
}

liner ( start, end)
{
	trace = bullettrace(start, end, false, undefined);
	for (;;)
	{
		line (start, trace["position"], (1,0,0));
		line (start + (0,0,1), end + (0,0,1), (0,0,1));
		wait (0.05);
	}
}

churchBells()
{
	self waittill ("trigger");
	wait (randomfloat(5));
	playsoundinspace ("church_bells", (-2091.73, 4135.33, 842));
}

axisTankSupport()
{
	wait (18);
	self dospawn();
}

tank_moveup_trigger()
{
	self waittill ("trigger");
	flag_set("tank_moveup_" + self.script_noteworthy);
}

recenterTurret()
{
	ent = spawn ("script_origin",(0,0,0));
	forward = anglestoforward(self.angles);
	forward = vectorscale(forward, 500);
	ent.origin = self.origin + forward;
	ent linkto (self);
	self setTurretTargetEnt (ent, (0,0,60));
	self waittill("turret_on_vistarget");
	self clearTurretTarget();
	ent delete();
}

stopPoint4()
{
	// tank 2 arrives then tries to flee
	wait (0.05);
//	self setwaitnode(getvehiclenode("stop_point_4","script_noteworthy"));
//	self waittill ("reached_wait_node");
//	self setspeed (0, 3.5);
	flag_wait ("tank2_flee");
	wait (1.2);
	path = getvehiclenode("flee_path","targetname");
	self attachPath(path);
	self startpath();
	
//	self resumespeed (1.8);
}

drawvehiclepath(ent)
{
	if (!isdefined(level.colorer))
		level.colorer = 0;

	colortype[0] = (1,0,1);
	colortype[1] = (1,1,0);
	colortype[2] = (0,1,1);
	colortype[3] = (0.5,0.5,1);
	color = colortype[level.colorer];
	level.colorer++;
	
	node = getvehiclenode(ent.target,"targetname");
	nodes = [];
	
	nodes[0] = node;
	for (;;)
	{
		if (!isdefined (node.target))
			break;
		node = getvehiclenode(node.target,"targetname");
		nodes[nodes.size] = node;
	}
	
	num = 2.5 - randomfloat(5);
	vec = (num,num,num);
	
	for (;;)
	{
		for (i=0;i<nodes.size-1;i++)
			line (nodes[i].origin + vec, nodes[i+1].origin + vec, color, 1);
		wait (0.05);
	}
}

smokeGen()
{
	self.smokeent = spawn ("script_model",(0,0,0));
	self.smokeent setmodel ("xmodel/tag_origin");
	self.smokeent.angles = (0,90,0);
	
	
	livingSmokeGen();
	originalorg = self.origin;
	vec = 40;
	for (i=0;i<50;i++)
	{
		org = originalorg + (vec*0.5 - randomfloat(vec),vec*0.5 - randomfloat(vec),15 + randomfloat(15));
		self.smokeent.origin = org;
		playfxontag (level._effect["tank_smoke"], self.smokeent, "tag_origin");
		wait (0.5 + randomfloat(0.4));
	}
}

livingSmokeGen()
{
	self endon ("death");
	vec = 40;
	for (;;)
	{
		org = self.origin + (vec*0.5 - randomfloat(vec),vec*0.5 - randomfloat(vec),15 + randomfloat(15));
		self.smokeent.origin = org;
//		playfx (level._effect["tank_smoke"], org, org + (100,0,0));
		playfxontag (level._effect["tank_smoke"], self.smokeent, "tag_origin");
		wait (0.4 + randomfloat(0.3));
	}
}

priceLine(msg)
{
	level.pricequeue[level.pricequeue.size] = msg;
	level notify ("price_line");
}

priceQueue()
{
	// gets price voice commands as they come in and play them in the order they arrived
	level.pricequeue = [];
	for (;;)
	{
		level.price setBattleChatter(true);
		level waittill ("price_line");
		level.price setBattleChatter(false);
			
		while (level.priceQueue.size)
		{
			level.price anim_single_solo (level.price, level.pricequeue[0]);
			wait (1);
			newQueue = [];
			for (i=1;i<level.pricequeue.size;i++)
				newQueue[newQueue.size] = level.pricequeue[i];
			level.pricequeue = newQueue;
		}
		level notify ("queue_cleared");
	}
}

delayedDeath()
{
	self endon ("death");
	wait (randomfloat(1));
	self dodamage(self.health, (0,0,0));
}

killAllSpawnersWestOf(org)
{
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	{
		if (spawners[i].origin[0] < org)
			continue;
		if (!isdefined(spawners[i].script_killspawner))
			continue;
//		if (spawners[i].team != "axis")
//			continue;
		spawners[i] delete();
	}
}


friendlyChainChatter()
{
	lastChain = "none";
	for (;;)
	{
		level waittill ("newFriendlyChain", note);
		if (lastChain == note)
			continue;
		thread friendlyChainDialogue(note, lastChain);
		lastChain = note;
	}
}

friendlyChainDialogue( currentPlace, lastPlace )
{
	level notify ("new_chain");
	level endon ("new_chain");
	
	msg = "first_house";	// first_house
	if (lastPlace == "none" && currentPlace == "startnode")
	{
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		flag_wait ("tank_done");
		wait (6);
		//iprintlnBold ("Take up positions at this broken wall!");
		thread priceLine ("brokenwall");
		wait (20);
		//iprintlnBold ("Davis, clear out that house, we'll cover you!");
		thread priceLine ("clearhouse");
		wait (20);
		//iprintlnBold ("Davis get in there while we suppress them!");
		thread priceLine ("getinthere");
	}

	msg = "alley";	// alley
	if (lastPlace == "startnode" && currentPlace == "after_first_house")
	{
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		wait (3);
		maps\_utility::autosave(1);
		////iprintlnBold ("Alright men good work! Let's move up!");
		thread priceLine ("goodworkmen");
		wait (20);
		////iprintlnBold ("Davis, run down this alley while we lay down the fire!");
		thread priceLine ("moveupalley");
		wait (20);
		////iprintlnBold ("Davis we need the second story of that building CLEARED!");
		thread priceLine ("secondstorycleared");
	}

	msg = "town_hall";	// town hall
	if (lastPlace == "after_first_house" && currentPlace == "attack_center")
	{
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		wait (2);
		maps\_utility::autosave(2);
		//iprintlnBold ("The building is clear! Let's take of up offensive positions outside! Go go go!");
		thread priceLine ("letsmoveup");
		wait (14);
		//iprintlnBold ("There's our objective, the town hall! Lay down the fire boys!");
		thread priceLine ("townhall");
		wait (20);
		//iprintlnBold ("Davis, move up and we'll swing around with a base of fire!");
		thread priceLine ("keepjerriesbusy");
		wait (5);
		playerChain = getnode("shift_center","script_noteworthy");
		level.player setFriendlyChainWrapper(playerChain);
		
	}
	if (lastPlace == "attack_center" && currentPlace == "shift_center")
	{
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift right!");
		thread priceLine ("shiftright");
		wait (8);
		//iprintlnBold ("Davis, get some grenades in those windows!");
		thread priceLine ("grenadesinwindows");
		wait (20);
		//iprintlnBold ("Davis, get that building cleared!");
		thread priceLine ("getbuildingclear");
	}

	msg = "ne_house";	// north east house
	if (lastPlace == "defend_center" && currentPlace == "moveon_center")
	{
		//iprintlnBold ("Alright men move out!");
		thread priceLine ("moveout");
	}
	if (lastPlace == "moveon_center" && currentPlace == "ne_moveup")
	{
		if (flag("stopchat" + msg))
			return;
		maps\_utility::autosave(3);
		//iprintlnBold ("Move up move up!");
		thread priceLine ("moveup");
		wait (8);
		//iprintlnBold ("Davis get up there and put some pressure on them!");
		thread priceLine ("getupthere");
	}
	if (lastPlace == "ne_moveup" && currentPlace == "ne_moveup2")
	{
		//iprintlnBold ("Ok go go go!");
		thread priceLine ("okgogo");
	}
	if (currentPlace == "ne_righthouse" && lastPlace == "ne_lefthouse" )
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift right!");
		thread priceLine ("bofright");
	}
	if (currentPlace == "ne_support" && (lastPlace == "ne_lefthouse" || lastPlace == "ne_righthouse" ))
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift right!");
		thread priceLine ("bofright");
	}
	if (currentPlace == "ne_lefthouse" && lastPlace == "ne_righthouse" )
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift left!");
		thread priceLine ("bofleft");
	}
	if (currentPlace == "ne_righthouse" && lastPlace == "ne_support" )
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift left!");
		thread priceLine ("bofleft");
	}
	if (currentPlace == "ne_lefthouse" && (lastPlace == "ne_moveup" || lastPlace == "ne_moveup2" ))
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Let's take up an offensive position in this building!");
		thread priceLine ("takeuppositions");
	}
	if (currentPlace == "ne_righthouse" && (lastPlace == "ne_moveup" || lastPlace == "ne_moveup2" ))
	{
		if (flag("stopchat" + msg))
			return;
		thread priceLine ("takeuppositions");
		//iprintlnBold ("Let's take up an offensive position in this building!");
	}
	

	if (currentPlace == "ne_righthouse" || currentPlace == "ne_lefthouse"  || currentPlace == "ne_support" )
	{
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		wait (20);
		//iprintlnBold ("Davis, move up to the post office! We'll cover you!");
		thread priceLine ("movepostoffice");
		wait (20);
		//iprintlnBold ("Davis, get the lead out! You need to move up!");
		thread priceLine ("getbloodymoveon");
	}

	msg = "church";	// Church
	if (currentPlace == "church_prepare" && lastPlace == "flak_defend")
	{
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Let's get some fire on those windows!");
		thread priceLine ("fireonwindows");
		wait (20);
		//iprintlnBold ("Davis, move up closer! We'll cover you!");
		thread priceLine ("davismoveup");
	}

	if (currentPlace == "church_right_building" && (lastPlace == "church_prepare" || lastPlace == "flak_defend"))
	{
		if (flag("stopchat" + msg))
			return;
		wait (1.5);
		maps\_utility::autosave(4);
		//iprintlnBold ("Let's use this building as a staging ground. Focus on the church!");
		thread priceLine ("baseoffire");
	}

	if (currentPlace == "church_low_wall" && (lastPlace == "church_prepare" || lastPlace == "flak_defend"))
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Squad! Assemble at that low wall! We need to get some pressure on the church!");
		thread priceLine ("lowwall");
	}

	if (currentPlace == "church_building_sw" && lastPlace == "church_building_w")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift right!");
		thread priceLine ("bofright");
	}
	
	if (currentPlace == "church_hill" && lastPlace == "church_building_sw")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift right!");
		thread priceLine ("bofright");
	}

	if (currentPlace == "church_low_wall" && lastPlace == "church_hill")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift right!");
		thread priceLine ("bofright");
	}	

	if (currentPlace == "church_right_building" && lastPlace == "church_low_wall")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift right!");
		thread priceLine ("bofright");
	}

	if (currentPlace == "church_low_wall" && lastPlace == "church_right_building")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift left!");
		thread priceLine ("bofleft");
	}

	if (currentPlace == "church_hill" && lastPlace == "church_low_wall")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift left!");
		thread priceLine ("bofleft");
	}

	if (currentPlace == "church_building_sw" && lastPlace == "church_hill")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift left!");
		thread priceLine ("bofleft");
	}

	if (currentPlace == "church_building_w" && lastPlace == "church_building_sw")
	{
		if (flag("stopchat" + msg))
			return;
		//iprintlnBold ("Base of fire shift left!");
		thread priceLine ("bofleft");
	}

	if (issubstr(currentPlace, "church") && currentPlace != "church_moveout" )
	{
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		wait (15);
		//iprintlnBold ("Squad, suppression fire!");
		thread priceLine ("suppressingfire");
		wait (10 + randomfloat(5));
		//iprintlnBold ("Davis, move up to the church!");
		thread priceLine ("davischurch");
		wait (10 + randomfloat(5));
		//iprintlnBold ("Davis, get a move on! Go go go!");
		thread priceLine ("gogogo");
	}	

	msg = "sw_house";	// south west house
	if (currentPlace == "west_attack" && lastPlace == "church_moveout")
	{
		wait (2);
		maps\_utility::autosave(5);
		wait (13);

		// moved to level
		//iprintlnBold ("Squad! Form a base of fire at this haycart");
		//thread priceLine ("fireathaycart");
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		wait (20);
		//iprintlnBold ("Alright Davis we've got you covered! Move up!");
		thread priceLine ("moveup");
		wait (10);
		//iprintlnBold ("Go go go! Davis go!");
		thread priceLine ("movedavisgo");
	}
	
	if (currentPlace == "west_moveup" && lastPlace == "west_attack")
	{
		//iprintlnBold ("Squad move up! Form a base of fire at that wall! Davis, circle around!");
		thread priceLine ("baseoffirewall");
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		wait (20);
		//iprintlnBold ("Get in that building Davis!");
		thread priceLine ("stormbuilding");
		wait (20);
		//iprintlnBold ("Davis, start clearing those rooms! Hurry!");
		thread priceLine ("clearrooms");
	}
	
	/*
	if (currentPlace == "west_defend")
	{
		//iprintlnBold ("Good work men. Let's take up a defensive perimeter in case the Germans try to counter attack");
		thread priceLine ("xxx");
		wait (10);
		//iprintlnBold ("Here they come! Suppression Fire!");
		thread priceLine ("xxx");
		level endon ("stopchat" + msg);
		if (flag("stopchat" + msg))
			return;
		wait (15);
		//iprintlnBold ("Davis! Flush them out!");
		thread priceLine ("xxx");
		wait (4);
	}
	*/
		
	
//	startnode
}

stopChatTrigger()
{
	for (;;)
	{
		self waittill ("trigger", other);
		if (level.player istouching(self))
			other = level.player;
		if (other != level.player)
			continue;
		
		flag_set ("stopchat" + self.script_noteworthy2);
		wait (20);
	}
}



// guys that spawn and get a big goal radius then attack the player
// such as inside the town hall
player_attack()
{
	self waittill ("spawned",spawn);
	if (spawn_failed(spawn))
	{
		assertEx(0,"AI at origin " + self.origin + " failed to spawn");
		return;
	}
	
	spawn.goalradius = 4080;
	spawn.favoriteEnemy = level.player;
	
}


intervalSpawner()
{
	self waittill ("spawned",spawn);
	if (spawn_failed(spawn))
	{
		assertEx(0,"AI at origin " + self.origin + " failed to spawn");
		return;
	}
	
	spawn endon ("death");
	interval = spawn.interval;
	spawn.interval = 0;
	wait (20);	
	spawn.interval = interval;
}

spawnedGuySetsGoalVolume()
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (spawn_failed(spawn))
			continue;
		if (isdefined(spawn.script_deathChain))
			spawn setgoalvolume(level.goalVolume[spawn.script_deathChain]);
	}
}

spawnAndDelete()
{
	spawners = getentarray(self.target,"targetname");
	array_thread(spawners,::spawnedGuySetsGoalVolume);
	
	for (i=0;i<spawners.size;i++)
		spawners[i].triggerUnlocked = true; // so they dont get autospawned
	self waittill ("trigger");

	// get the spawners again because some may have been deleted from killspawners
	spawners = getentarray(self.target,"targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i] dospawn();
		
	// this gives the spawns time to spawn and increment level.deathspawner
	// otherwise the delete happens before the spawn
	waittillframeend; 
		
	// get the spawners again because some may have been deleted from killspawners
	spawners = getentarray(self.target,"targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i] delete();
}

tankMoveUpTrigger()
{
	self waittill ("trigger");
	flag_set("player_passed_first_building");
}

priceStartLine()
{
	for (;;)
	{
		self waittill ("trigger", other);
		if (!isalive(other))
			continue;
		if (other == level.price)
			break;
	}
	thread priceLine(self.script_noteworthy);
	self delete();
}

nearestAllyBCSLine (msg)
{
	guy = undefined;
	for(;;)
	{
		guy = getClosestAI( level.player.origin, "allies");
		if (isalive(guy))	
		{
			guy forcecustomBattleChatter( msg );	
			return;
		}
		wait (1);
	}
}

backyardTrigger()
{
	self waittill ("trigger");
	flag_set("player_entered_backyard");	
}

allyOverrides()
{
	array_thread (getaiarray("allies"), ::allyOverrideThink);
	array_thread (getspawnerteamarray("allies"), ::allySpawnerOverrideThink);
}

allySpawnerOverrideThink()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("spawned", spawn);
		if (spawn_failed(spawn))
			continue;
		spawn allyOverrideThink();
	}	
}


allyOverrideThink()
{
	if (self == level.price)
		return;
	
	self.pathenemyfightdist = 64;
	self.pathenemylookahead = 64;

	self endon ("death");
	for (;;)
	{
		self setBattleChatter(false);
		wait (5);
		self setBattleChatter(true);
		wait (2);
	}
}

doorSave()
{
	self waittill ("trigger");
	maps\_utility::autosave(2);
}

hardOnlySpawner()
{
	if (level.gameSkill < 2)
		self delete();
}