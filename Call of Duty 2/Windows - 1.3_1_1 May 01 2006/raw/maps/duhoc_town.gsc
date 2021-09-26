#include maps\_utility;
#using_animtree("generic_human");

duhoc_town()
{
 	level.scr_notetrack["generic"][0]["notetrack"]		= "grenade_right";
	level.scr_notetrack["generic"][0]["anime"]			= "grenade_throw_stand";
	level.scr_notetrack["generic"][0]["attach model"]	= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["generic"][0]["selftag"]		= "TAG_WEAPON_RIGHT";
	level.scr_notetrack["generic"][1]["notetrack"]		= "fire";
	level.scr_notetrack["generic"][1]["anime"]			= "grenade_throw_stand";
	level.scr_notetrack["generic"][1]["detach model"]	= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["generic"][1]["selftag"]		= "TAG_WEAPON_RIGHT";

	level.scr_notetrack["generic"][2]["notetrack"]		= "grenade_right";
	level.scr_notetrack["generic"][2]["anime"]			= "grenade_throw_crouch";
	level.scr_notetrack["generic"][2]["attach model"]	= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["generic"][2]["selftag"]		= "TAG_WEAPON_RIGHT";
	level.scr_notetrack["generic"][3]["notetrack"]		= "fire";
	level.scr_notetrack["generic"][3]["anime"]			= "grenade_throw_crouch";
	level.scr_notetrack["generic"][3]["detach model"]	= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["generic"][3]["selftag"]		= "TAG_WEAPON_RIGHT";

	level.scr_notetrack["generic"][4]["notetrack"]		= "grenade_left";
	level.scr_notetrack["generic"][4]["anime"]			= "grenade_throw_corner";
	level.scr_notetrack["generic"][4]["attach model"]	= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["generic"][4]["selftag"]		= "TAG_WEAPON_LEFT";
	level.scr_notetrack["generic"][5]["notetrack"]		= "fire";
	level.scr_notetrack["generic"][5]["anime"]			= "grenade_throw_corner";
	level.scr_notetrack["generic"][5]["detach model"]	= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["generic"][5]["selftag"]		= "TAG_WEAPON_LEFT";

	level.scr_anim["kick_guy"]["kick_door"] = %duhoc_kickdoor; //%chateau_kickdoor1;
	level.scr_anim["generic"]["grenade_throw_stand"] = %stand_grenade_throw;
	level.scr_anim["generic"]["grenade_throw_crouch"] = %crouch_grenade_throw;
	level.scr_anim["generic"]["grenade_throw_corner"] = %corner_left_stand_alertgrenaderight;

	level.scrsound["generic"]["do_it"] = "duhocassault_rnd_millerdoit";
	level.scrsound["generic"]["yes_sir"] = "duhocassault_miller_yessir";
	level.scrsound["generic"]["house_cleared"] = "duhoc_assault_rnd_housecleared";
	level.scrsound["generic"]["get_grenade_in_there"] = "duhoc_assault_bra_grenadeinthere";
	level.scrsound["generic"]["use_your_grenades"] = "duhocassault_rnd_useyourgrenades";
	level.scrsound["generic"]["halftrack"] = "duhocassault_randall_halftrackmove";
	level.scrsound["generic"]["1st_squad"] = "duhocassault_gr4_firstsquad";
	
	level.scr_anim		["randal"]["with_me"]	 		= %duhoc_assault_randall_waves;
	level.scr_notetrack	["randal"][0]["anime"]			= "with_me";
 	level.scr_notetrack	["randal"][0]["notetrack"]		= "dialog";
	level.scr_notetrack	["randal"][0]["sound"]			= "duhocassault_randall_yourewithme"; //"xmodel/weapon_mk2fraggrenade";

	level.scrsound["randal"]["watch_road"] = "duhocassault_randall_watchtheroad";

	level.scr_anim		["randal"]["here_they_are"] 	= %duhoc_assault_randall_points;
	level.scr_notetrack	["randal"][1]["anime"]			= "here_they_are";
 	level.scr_notetrack	["randal"][1]["notetrack"]		= "dialog";
	level.scr_notetrack	["randal"][1]["sound"]			= "duhocassault_randall_heretheyare"; //"xmodel/weapon_mk2fraggrenade";

	level.scrsound["randal"]["thermite"] = "duhocassault_randall_founddamnguns";
	level.scrsound["generic"]["smoke"] = "duhocassault_gr3_throwsmoke";

	level.scrsound["generic"]["coastal_road"] = "duhocassault_gr3_coastalroad";
	level.scrsound["generic"]["road_block"] = "duhocassault_gr6_roadblocksetup";

	level.scrsound["generic"]["move1"] = "duhoc_assault_bra_moveforwardtop";
	level.scrsound["generic"]["move2"] = "duhoc_assault_rnd_keepmoving";
	level.scrsound["generic"]["move3"] = "duhocassault_gr5_keepitmoving";
	level.scrsound["generic"]["move4"] = "duhocassault_gr4_letsgoletsgo";
	level.scrsound["generic"]["move5"] = "duhocassault_gr1_gogogo";
	level.scrsound["generic"]["move6"] = "duhocassault_gr1_movemove";
	level.scrsound["generic"]["move7"] = "duhoc_assault_gr1_timetogo";
	level.scrsound["generic"]["move8"] = "duhocassault_gr6_letsgetmoving";
	level.scrsound["generic"]["move9"] = "duhocassault_gr6_keepmoving";

	level.scrsound["german"]["retreat1"] = "duhocassault_ger3_fallback";
	level.scrsound["german"]["retreat2"] = "duhocassault_ger3_secondpos";
	level.scrsound["german"]["retreat3"] = "duhocassault_ger1_fallback";
	level.scrsound["german"]["retreat4"] = "duhocassault_ger1_runaway";
	
	thread arch_autosave();
	thread cal30trigger();
	thread fieldRunners();
		
	// triggers that make guys yell about moving up
	thread moveUp();

	// door at the first building on the right that friendlies bust down.	
	getent ("town_door","targetname") disconnectPaths();
	flag_clear("town_attack");
	flag_clear("town_moveup");
	flag_clear("door_rush_wait");
	flag_clear("door_kick_wait");
	flag_clear("house_cleared_wait");
	flag_clear("house_entered");
	flag_clear("friendly_chain_activated");
	flag_clear("force_mg42");
	flag_clear("bar_wait"); // bar guy covers the way in the beginning
	flag_clear("randal_talks");
	flag_clear("grenade_ready");
	flag_clear("grenade_throw_1");
	flag_clear("grenade_throw_2");
	flag_clear ("smokeThrown");
	
	houseDefenders = getentarray("house_defenders","script_noteworthy");
	level.houseDefenders = houseDefenders.size;
	array_thread (houseDefenders, ::houseDefenders);
	thread waitUntilSmokeIsThrownInTrigger_Cancel();
	array_thread (getentarray("cal30gunner","script_noteworthy"), ::makeInvul);
	
	// deletes axis that run into it
	getent ("delete_axis","targetname") thread deleteAxis();

	// mg42 guy up in the house, dont want friendlies to kill him
	getent("ignoreme","script_noteworthy") thread ignoreMG42guy();
	// trigger for spawning the mg42 guy if he doesnt autospawn after friendlies do grenades
	getent("force_mg42","targetname") thread forceMG42();
	
	// halftrack trigger
	getent("halftrack_trigger","targetname") thread halfTrack();

	getent("grenade_guys_trigger","targetname") thread grenadeTrigger();

	getent("door_kick_trigger","targetname") thread triggerThenFlag("door_rush_wait");


	trigger = getent("door_rush_trigger","targetname");
	// spawner targetted by the initial trigger
	getent(trigger.target,"targetname").triggerUnlocked = true;
	trigger waittill ("trigger");

	trigger thread grabDuhocAssaultAI();
	
	trigger = getent ("town_attack_trigger","targetname");
	trigger waittill ("trigger");
	
	//stop some drones on the left feild
	trigs = getentarray("looping_drones_leftfield","script_noteworthy");
	for( i = 0 ; i < trigs.size ; i++ )
	{
		trigs[i] notify ("stop_drone_loop");
		trigs[i].script_delay = -1;
	}
	
	//delete friendly chains on left field
	array_thread(getentarray("leftfield_friendlychain","targetname"), ::triggerOff);
	
	thread autoSaveByName("town");
	
	flag_set("town_attack");
	
	nearestGenericAllyLine ("do_it");
	wait (0.2);
	level.barGuy.animName = "generic";
	level.barGuy anim_single_solo(level.barGuy, "yes_sir");
	flag_set("town_moveup");
	
	thread cal30guyDies();
	thread lastHouse();
	getent ("randal_talks","targetname") thread randalTalks();

	// detect smoke grenade throw
	waitUntilSmokeIsThrownOrPlayerProgresses();	
	trigger = getent("coastal_road","targetname");
	trigger waittill ("trigger");
	thread endMusic();
	wait (0.8);
	thread nearestGenericAllyLine ("coastal_road");	
	
	thread delayed_german_deaths();
	
	trigger = getent("randal_trigger","targetname");
	trigger waittill ("trigger");
	
	spawner = getent(trigger.target,"targetname");
	for (;;)
	{
		spawner.count = 1;
		randal = spawner stalingradspawn();
		if (!spawn_failed(randal))
			break;
		wait (0.05);
		continue;
	}
	
	randal thread magic_bullet_shield();
	randal.animname = "randal";
	
	array_thread(getentarray("end_allies","targetname"), ::spawnMove);
	node = getnode (spawner.target,"targetname");
	randal lookat(level.player);
	randal setgoalnode (node);
	randal.goalradius = 32;
	level.randall = randal;
	randal anim_single_solo (randal, "watch_road");
	flag_wait("randal_talks");
	thread cowSound();
	thread bigGuns();
	
	node anim_reach_solo (randal, "with_me");
	if (!flag("player_on_coastal_road"))
		node anim_single_solo (randal, "with_me");

	thread autoSaveByName("coastal_road");

	array_thread(getentarray("randal_forcemove","targetname"), ::randalForcemove);
	wait (3);
	node = getnode (node.target,"targetname");
	randal setgoalnode (node);

	wait (1.3);	
	ai = getentarray("roadblock","script_noteworthy");
	guy = getclosest(level.player.origin, ai);
	if (isalive(guy))
	{
		guy.animName = "generic";
		guy thread anim_single_solo (guy, "road_block");
	}
	
	trigger = getent ("randal_guns","targetname");
	trigger waittill ("trigger");

	randal anim_single_solo (randal, "here_they_are");
//	wait (0.25);
	randal anim_single_solo (randal, "thermite");
	flag_set("do_thermites");
}

delayed_german_deaths()
{
	axis = getaiarray("axis");
	for( i = 0 ; i < axis.size ; i++ )
	{
		wait randomfloat(1);
		if (!isdefined(axis[i]))
			continue;
		if (!isalive(axis[i]))
			continue;
		axis[i] doDamage( axis[i].health + 1, axis[i].origin + (0,0,32) );
	}
}

player_on_coastal_road()
{
	getent("coastal_road_start","targetname") waittill ("trigger");
	flag_set("player_on_coastal_road");
}

town_triggers_disable()
{
	triggers = getentarray("trigger_multiple","classname");
	trigger_friendlychain = getentarray("trigger_friendlychain","classname");
	for (i=0;i<trigger_friendlychain.size;i++)
		triggers[triggers.size] = trigger_friendlychain[i];
	trigger_friendlychain = undefined;
	
	//enable or disable these triggers
	for ( i = 0 ; i < triggers.size ; i++ )
	{
		if (!isdefined(triggers[i].script_noteworthy2))
			continue;
		if (triggers[i].script_noteworthy2 == "town_trigger")
			triggers[i] triggerOff();
	}
}

cowSound()
{
	if (level.script == "duhoc_town")
		return;
	org = getent("cow_sound","targetname");
	for (;;)
	{
		org playsound("emt_fly_loop","sounddone");
		org waittill ("sounddone");
	}
}

spawnMove()
{
	self.count = 1;
	spawn = self stalingradspawn();
	if (spawn_failed(spawn))
		return;
	spawn.script_noteworthy = "roadblock";
	node = getnode(spawn.target,"targetname");
	spawn setgoalnode (node);
	spawn.goalradius = 64;
}

randalForcemove()
{
	self waittill ("trigger");
	level.randall setgoalnode (getnode(self.target,"targetname"));
}

randalTalks()
{
	self waittill ("trigger");
	flag_set("randal_talks");
}

halfTrack()
{
	self waittill ("trigger");
	thread nearestGenericAllyLine ("halftrack");
	thread halfTrackGunner();
	thread halfTrackGunner_death();
	wait (2.2);
	playerChain = getnode("halftrack_chain","targetname");
	level.player setFriendlyChainWrapper(playerChain);
}

halftrackUnload()
{
	self waittill ("reached_end_node");
	trigger = getent ("halftrack_unload_trigger","targetname");
	trigger waittill ("trigger");
	self notify ("unload");
}

halfTrackGunner_death()
{
	gunner = undefined;
	
	axis = getaiarray("axis");
	for( i = 0 ; i < axis.size ; i++ )
	{
		if (!isdefined(axis[i].script_vehicleride))
			continue;
		if (axis[i].script_vehicleride != 10)
			continue;
		if (!isdefined(axis[i].idletag))
			continue;
		if (axis[i].idletag != "tag_MGguy")
			continue;
		gunner = axis[i];
		break;
	}
	if (!isdefined(gunner))
		return;
	gunner waittill ("death");
	level notify ("halftrack_gunner_died");
}

halfTrackGunner()
{
	level endon ("halftrack_gunner_died");
	
	halftrack = getent ("halftrack_vehicle","targetname");
	halftrack thread halftrackUnload();
	mg42 = halftrack.mgturret[0];
	/*
	user = mg42 getturretowner();
	if (!isalive(user))
		return;
	*/

	targets = getentarray("halftrack_mg42_target","targetname");
	for (;;)
	{
		mg42 setmode("manual"); // auto, auto_ai, manual
		mg42 settargetentity (random(targets));
		mg42 startFiring();
		wait (2 + randomfloat(1));
	}
}

waittillTriggerOrForceMG42()
{
	level endon ("force_mg42");
	self waittill ("trigger");
}

forceMG42()
{
	waittillTriggerOrForceMG42();
	flood_and_secure_scripted(getentarray(self.target,"targetname"));
}

deleteAxis()
{
	for (;;)
	{
		self waittill ("trigger", other);
		if (isalive(other))
			other delete();
	}
}

grabDuhocAssaultAI()
{
	level.initial_ai = getaiarray("allies");
	assertEX (level.initial_ai.size >= 6, "Duhoc needs to guarentee there are at least 6 friendlies alive at this point");

	ai = level.initial_ai;
	barGuys = [];
	for (i=0;i<ai.size;i++)
	{
		if (!issubstr(ai[i].classname, "reg_BAR"))
			continue;
		
		barGuys[barGuys.size] = ai[i];
	}

	barGuy = getclosest(level.player.origin, barGuys);
	level.barGuy = barguy;
	assertEX(isdefined(barGuy), "Level needs to provide a BAR guy by now");
	level.initial_ai = array_remove (level.initial_ai, barGuy);

	barGuy.target = getnode("bar_node","targetname").targetname;
	barGuy.barGuy = true;
	barGuy thread grenadeGuysMoveup();

	ai = level.initial_ai;
	tommyGuys = [];
	for (i=0;i<ai.size;i++)
	{
		if (!issubstr(ai[i].classname, "hompson"))
			continue;

		tommyGuys[tommyGuys.size] = ai[i];
		break;
	}

	tommyGuy = getclosest(level.player.origin, tommyGuys);
	assertEX(isdefined(tommyGuy), "Level needs to provide a Thompson guy by now");
	level.initial_ai = array_remove (level.initial_ai, tommyGuy);

	node = getnode("doornode_1","targetname");
	tommyGuy.target = node.targetname;
	tommyGuy thread doorRush();

	thread make3closestAlliesGoLeft();
	thread make3closestAlliesRushDoor();
}

make3closestAlliesGoLeft()
{
//	array_thread (getentarray(trigger.target,"targetname"), ::doorRush);
	nodes = [];
	// cant change node targetnames and I'd already written the script to use the node targetname so we'll
	// manually build the array
	nodes[nodes.size] = getnode("grenade_node_1","targetname");
	nodes[nodes.size] = getnode("grenade_node_2","targetname");
	
	
	for (i=0;i<2;i++)
	{
		rusher = getclosest(level.player.origin, level.initial_ai);
		assertEX(isdefined(rusher), "Level needs to provide another AI guy here");
		rusher.barGuy = false;
		node = nodes[0];
		rusher.target = node.targetname;
		rusher thread grenadeGuysMoveup();

		level.initial_ai = array_remove (level.initial_ai, rusher);
		nodes = array_remove (nodes, node);
	}
}

make3closestAlliesRushDoor()
{
//	array_thread (getentarray(trigger.target,"targetname"), ::doorRush);
	nodes = [];
	// cant change node targetnames and I'd already written the script to use the node targetname so we'll
	// manually build the array
	nodes[nodes.size] = getnode("doornode_2","targetname");
	nodes[nodes.size] = getnode("doornode_3","targetname");
	
	for (i=0;i<2;i++)
	{
		rusher = getclosest(level.player.origin, level.initial_ai);
		assertEX(isdefined(rusher), "Level needs to provide another AI guy here");
		node = nodes[0];
		rusher.target = node.targetname;
		rusher thread doorRush();

		level.initial_ai = array_remove (level.initial_ai, rusher);
		nodes = array_remove (nodes, node);
	}

	flag_wait("town_attack");	
	// this is for the guy inside on the left, so he moves into position after this trigger gets hit
	spawner = getent (self.target,"targetname");
	spawner.count = 1;
	spawn = spawner dospawn();
	if (spawn_failed(spawn))
		return;
		
	spawn endon ("death");
	node = getnode(spawn.target,"targetname");
	spawn setgoalnode (node);
	spawn.goalradius = node.radius;
	assert(node.radius > 0);

	trigger = getent("manualguy_trigger","targetname");
	trigger waittill ("trigger");
	
	node = getnode(node.target,"targetname");
	spawn setgoalnode(node);
	spawn.goalradius = node.radius;
	assert(node.radius > 0);
}

alliesDelete()
{
	level endon ("moving_towards_house_exit");
	trigger = getent ("allies_delete","targetname");
	for (;;)
	{
		trigger waittill ("trigger", other);
		if (isalive(other))
			other delete();
	}
}

spawnFieldRunDelete(delay)
{
	if (isdefined(delay))
		wait (delay);
		
	self.count = 1;
	spawn = self stalingradspawn();
	if (spawn_failed(spawn))
		return;
	spawn endon ("death");
	spawn notify ("stop magic bullet shield");
	spawn.health = 10;
	if (randomint(100) > 50)
	{
		spawn.run_noncombatanim = %combat_run_onehand;
		spawn.run_combatanim = %combat_run_onehand;
		spawn.crouchrun_combatanim = %combat_run_onehand;
	}
	else
	{
		spawn.run_noncombatanim = %combat_run_helmethand;
		spawn.run_combatanim = %combat_run_helmethand;
		spawn.crouchrun_combatanim = %combat_run_helmethand;
	}
	spawn.script_noteworthy = "field_retreat";
	node = getnode(self.target,"targetname");
	for (;;)
	{
		spawn setgoalnode (node);
		spawn.goalradius = node.radius;
		assert(node.radius > 0);
		spawn waittill ("goal");
		if (!isdefined (node.target))
			break;
		node = getnode(node.target,"targetname");
	}
	spawn delete();
}

cal30trigger()
{
	// delete the original 30cal guy
	getent ("kill_first_30cal","targetname") waittill ("trigger");
	level notify ("kill_30_call");	
	
	trigger = getent ("trigger_30cal","targetname");
	thirtyCalSpawner = getent(trigger.target,"targetname");
	thirtyCalSpawner.count = 0;

	trigger waittill ("trigger");
	
	// wait until all the axis in the 30cal trigger are dead
	ai = getaiarray("axis");
	toucher = [];
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] istouching (trigger))
			toucher[toucher.size] = ai[i];
	}
	ai = undefined;
	
	for (i=0;i<toucher.size;i++)
	{
		if (isalive(toucher[i]))
			toucher[i] waittill ("death");
	}

	// wait until the player leaves the trigger
	while (level.player istouching(trigger))
		wait (0.1);
		
	thirtyCalSpawner.count = 1;
	spawn = thirtyCalSpawner dospawn();	
	if (spawn_failed(spawn))
		return;
	spawn thread magic_bullet_shield();
}

fieldRunners_wait()
{
	level endon ("fieldRunners_go");
	self waittill("trigger");	
	flag_set("fieldRunners_go");
}

fieldRunners()
{	
	flag_clear("fieldRunners_go");
	array_thread (getentarray("trigger_field_runners","targetname"), ::fieldRunners_wait);
	flag_wait("fieldRunners_go");
	level notify ("fieldRunners_go");
	
	array_thread (getentarray("field_runners","targetname"), ::spawnFieldRunDelete);	
	array_thread (getentarray("field_runners_extra","targetname"), ::spawnFieldRunDelete);	
	
	num = 1;
	for (i=0;i<15;i++)
	{
		ai = getentarray("field_retreat","script_noteworthy");
		guy = getclosest(level.player.origin, ai);
		if (!isalive(guy))
		{
			wait (2);
			continue;
		}
		
		guy.animname = "german";
		num++;
		if (num >= 5)
			num = 0;
		guy thread anim_single_solo (guy, "retreat" + num);
		wait (4 + randomfloat (3));
	}
	
	if (1) return; // disable extra runners
	spawners = getentarray("field_runners_extra","targetname");
	index = 0;
	total = 20;
	for (;;)
	{
		spawners = array_randomize(spawners);
		for (i=0;i<spawners.size;i++)
		{
			wait (4.4 + randomfloat(2));
			spawners[i].count = 1;
			spawn = spawners[i] dospawn();
			if (spawn_failed(spawn))
				continue;
			
			spawn thread runDelete();
			total--;
			if (!total)
				break;
		}
		if (!total)
			break;
	}

}

lastHouse()
{
	trigger = getent("upstairs","targetname");
	trigger waittill ("trigger");
	
	level notify ("player_progressed");	
	playerChain = getnode("field_chain","targetname");
	level.player setFriendlyChainWrapper(playerChain);
	
	thread alliesDelete();
	trigger = getent ("allies_gate_spawn","targetname");
	trigger waittill ("trigger");
	level notify ("moving_towards_house_exit");
	array_thread (getentarray(trigger.target,"targetname"), ::gateGuysSpawn);

	trigger = getent ("field_trigger","targetname");
	trigger waittill ("trigger");
	array_thread (getentarray(trigger.target,"targetname"), ::spawnJoinFriendlyChain);

	trigger = getent ("gate_guys_moveup","targetname");
	trigger waittill ("trigger");
	level notify ("gate_guys_moveup");	
	
}

spawnJoinFriendlyChain()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		return;
	spawn endon ("death");
	wait (1);
	spawn setgoalentity (level.player);
}

gateGuysSpawn()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		return;
	spawn endon ("death");
	level waittill ("gate_guys_moveup");	
	spawn setgoalentity (level.player);
}

waitUntilSmokeIsThrownOrPlayerProgresses()
{
	level endon ("player_progressed");
	thread waitUntilSmokeIsThrownInTrigger();
	if (!flag ("smokeThrown"))
		flag_wait("smokeThrown");
	wait (8);
	thread nearestGenericAllyLine ("1st_squad");
	
	wait (2);

	// AI defending flee
	ai = getaiarray("axis");
	trigger = getent("smoke_flee_trigger", "targetname");
	node = getnode(trigger.target,"targetname");
	for (i=0;i<ai.size;i++)
	{
		if (!ai[i] istouching (trigger))
			continue;
		ai[i] setgoalnode (node);
		ai[i].goalradius = node.radius;
	}

	flag_set("friendly_chain_activated");
	playerChain = getnode("moveup_chain","targetname");
	level.player setFriendlyChainWrapper(playerChain);
}

waitUntilSmokeIsThrownInTrigger()
{
	trigger = getent("smoke_check_trigger","targetname");
	for (;;)
	{
		grenades = getentarray("grenade","classname");
		for (i=0;i<grenades.size;i++)
		{
			legit = false;
			if (grenades[i].model == "xmodel/weapon_us_smoke_grenade")
				legit = true;
			if (grenades[i].model == "xmodel/weapon_hcsmokegrenade")
				legit = true;

			if (!legit)
				continue;
			if (grenades[i] istouching (trigger))
			{
				flag_set("smokeThrown");
				return;
			}
		}
		wait (0.5);
	}
}

waitUntilSmokeIsThrownInTrigger_Cancel()
{
	getent("cancel_smoke_check_trigger","targetname") waittill ("trigger");
	flag_set("smokeThrown");
}

ignoreMG42guy()
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (!spawn_failed(spawn))
			spawn.ignoreme = true;
	}
}

doorRush()
{
	spawner = getentarray("spawn_coupler","script_noteworthy");
	self.spawner = spawner[0];
	node = getnode(self.target,"targetname");
	self.spawner.currentGoal = node;
	thread doorRushRespawner();
	thread doorRushMoveup();
}

doorRushRespawner()
{
	spawner = self.spawner;
	// so each door rush guy gets his own spawner
	spawner.script_noteworthy = undefined;
	self waittill ("death");
	for (;;)
	{
		spawner.count = 1;
		spawn = spawner dospawn();
		if (spawn_failed(spawn))
		{
			wait (1);
			continue;
		}
		
		spawn.spawner = spawner;
		spawn thread doorRushMoveup();
		spawn waittill ("death");
	}
}

grenadeGuysMoveup()
{
	self endon ("death");
	self.grenadeawareness = 0;
	self.ignoreme = true;
	self.grenadeAmmo = 0;
	self.health = 50000;
	
	// guys that run up to a house on the left and throw grenades in.
	node = getnode(self.target,"targetname");
	self setgoalnode (node);
	self.goalradius = node.radius;
	flag_wait("town_moveup");

	for (;;)
	{
		self setgoalnode(node);
		self.goalradius = node.radius;
		assert(node.radius > 0);
		self waittill ("goal");
		if (isdefined(node.script_noteworthy))
		{
			if (node.script_noteworthy == "bar_wait")
			{
				if (!self.barGuy)
					flag_wait ("bar_wait");
			}
			else
			if (node.script_noteworthy == "bar_spot")
			{
				assert(self.barGuy);
				wait (1.3);
				thread nearestGenericAllyLine ("move5");
				wait (0.25);
				flag_set ("bar_wait");
				wait (7);
			}
			else
			if (node.script_noteworthy == "house_cleared_wait")
				flag_wait("house_cleared_wait");
			else
			if (node.script_noteworthy == "grenade_throw_node")
			{
				flag_wait("grenade_ready");
				if (!flag("grenade_throw_1"))
				{
					flag_set("grenade_throw_1");
					self.animname = "generic";
					self anim_single_solo (self, "get_grenade_in_there");
					wait (0.2);
					self anim_single_solo (self, "use_your_grenades");
					flag_set("grenade_throw_2");
				}
				else
				{
					flag_wait("grenade_throw_2");
					wait (randomfloat(0.6));
				}
											
				// waits before throwing
//				GatherDelay("grenadeGuys", 3);
				if (!issubstr(node.type, "Cover Left"))
				{
					// corner guy doesnt do the angle check
					for (;;)
					{
						yaw = animscripts\utility::AbsYawToAngles(node.angles[1]);
						if (yaw < 25)
							break;
						wait (0.05);
					}
				}

				self.animName = "generic";
				if (self.anim_pose != "wounded")
				{
					if (issubstr(node.type, "Cover Left"))
						thread anim_single_solo (self, "grenade_throw_corner");
					else
					if (issubstr(node.type, "rouch"))
						thread anim_single_solo (self, "grenade_throw_crouch");
					else
						thread anim_single_solo (self, "grenade_throw_stand");
				}
				
				self thread animscripts\shared::donotetracks("single anim");
				self waittillmatch("single anim", "fire");
				start = self gettagorigin("TAG_WEAPON_RIGHT");
				end = getent (node.target,"targetname").origin;
				angles = vectortoangles (end - start);
				forward = anglestoforward(angles);
				forward = vectorScale(forward, 12);
				grenadeTimer = 2.8;
				if (!isdefined(level.grenade_exp_timer))
					level.grenade_exp_timer = gettime() + (grenadeTimer * 1000);
				grenadeTimer = (level.grenade_exp_timer - gettime()) * 0.001;
				if (grenadeTimer > 1)
					self magicgrenade (start, end, grenadeTimer);
				
//				/#thread animscripts\utility::debugLine(start + forward, end, (0,1,0), 20);#/
				// throw grenades here
				if (!isdefined (level.grenadeGuysMoment))
				{
					thread delayedAxisKill(grenadeTimer - 0.05);
					thread delayedExploder(17, grenadeTimer);
					level.grenadeGuysMoment = true;
					timer = 3;
					thread killSpawnerDelayed(205, timer);
					spawners = getentarray("grenade_axis","targetname");
					runTimer = timer - 1.5;
					if (runTimer < 0)
						runTimer = 0;
					runTimer = 0;
					array_thread (spawners, ::stalingradSpawnRunDelete, runTimer); // timer disabled, we want these guys to run out
					getent("zombie","targetname") thread stalingradSpawnRunDelete(timer);
					getent("zombie","targetname") thread zombieGuy();
					thread forceMg42Flag("force_mg42", 3.5);
				}
				
				wait (1);
			}
		}
		
		if (!isdefined(node.target))
			break;
		node = getnode(node.target,"targetname");
	}	
	
	self.ignoreme = false;
	self notify ("stop magic bullet shield");
	self.health = 100;
	flag_wait("friendly_chain_activated");
	self setgoalentity (level.player);
}

delayedAxisKill(timer)
{
	wait (timer);
	// AI defending flee
	ai = getaiarray("axis");
	trigger = getent("grenade_kill_axis", "targetname");
	for (i=0;i<ai.size;i++)
	{
		if (!ai[i] istouching (trigger))
			continue;
		ai[i] dodamage(ai[i].health + 5, ai[i].origin);
	}
}

forceMG42Flag(msg, timer)
{
	wait(timer);
	flag_set(msg);
	wait (1.5);
	nearestGenericAllyLine ("smoke");
}

zombieGuy()
{
	self waittill ("spawned",spawn);
	if (spawn_failed(spawn))
	{
		flag_set("moveup_past_zombie");
		return;
	}
	spawn thread zombieGuy_deathFlag();
	spawn endon ("death");
	spawn notify ("stop magic bullet shield");
	spawn.health = 500;
	spawn.anim_disablePain = true;
	spawn.ignoreme = true;
	spawn.run_combatanim = %duhoc_german_shellshocked_walk;
	spawn.anim_combatrunanim = %duhoc_german_shellshocked_walk;
	spawn setexceptions(animscripts\run::InfiniteMoveStandCombatOverride);
	wait (3);
	spawn.anim_disablePain = false;
	spawn.health = 1;
	wait (7);
	flag_set("moveup_past_zombie");
	spawn.ignoreme = false;
}

zombieGuy_deathFlag()
{
	self waittill("death");
	flag_set("moveup_past_zombie");
}

delayedExploder(num, delay)
{
	wait (delay);
	exploder(num);
}

bigGuns()
{
//	wait (1.1);
	for (;;)
	{
		if (level.script == "duhoc_town")
			iprintlnbold ("kaboom!");
		exploder(18);
		wait (10 + randomfloat(3));
	}
}

doorRushMoveup()
{
	self endon ("death");
	self.grenadeAmmo = 0;
	node = self.spawner.currentGoal;
	self setgoalnode (node);
	self.goalradius = node.radius;
	self.pathenemyfightdist = 150;
	self.pathenemylookahead = 150;
	assert(node.radius > 0);
	flag_wait("town_moveup");
	flag_wait("door_rush_wait");
	
	for (;;)
	{
		self setgoalnode (node);
		self.goalradius = node.radius;
		assert(node.radius > 0);
		self waittill ("goal");
		if (isdefined(node.script_noteworthy))
		{
			if (node.script_noteworthy == "bar_wait")
			{
				flag_wait ("bar_wait");
				wait (3.5);
				wait (randomfloat(0.7));
			}
			else
			if (node.script_noteworthy == "door_kick_node")
			{
				door = getent ("town_door","targetname");
				self.animName = "kick_guy";
				node anim_reach_solo (self, "kick_door");
				self thread bullets();
				node thread anim_single_solo (self, "kick_door");
				self waittillmatch ("single anim", "kick");
				
				door connectpaths();
				door rotateyaw(-85,1,0.1,0.8);
				door playsound ("wood_door_kick");
				thread flag_set_delayed("door_kick_wait", 1.2);
				thread flag_set_delayed("house_entered", 1.2);
			}
			else
			if (node.script_noteworthy == "door_kick_wait")
				flag_wait("door_kick_wait");
			else
			if (node.script_noteworthy == "house_cleared_wait")
			{
				flag_wait("house_cleared_wait");
				self notify ("stop magic bullet shield");
				self.health = 100;
				if (!isdefined(level.houseCleared))
				{
					level.housecleared = true;
					thread nearestGenericAllyLine ("house_cleared");
				}
			}
		}
		
		if (!isdefined(node.target))
			break;
			
		node = getnode(node.target,"targetname");
		self.spawner.currentGoal = node;
	}
	self.pathenemyfightdist = 350;
	self.pathenemylookahead = 350;
	flag_wait("friendly_chain_activated");
	self setgoalentity(level.player);	
}

flag_set_delayed(msg, timer)
{
	wait (timer);
	flag_set (msg);
}


houseDefenders()
{
	// guys on the right when you go in, when they die it signals friendlies to move on
	self waittill ("spawned",spawn);
	spawn thread houseDefendersDie();
	spawn.baseAccuracy = 0;
	spawn waittill ("death");
	level.houseDefenders--;
	if (!level.houseDefenders)
		flag_set("house_cleared_wait");
}

houseDefendersDie()
{
	self endon ("death");
	flag_wait("house_entered");
	wait (2.5 + randomfloat(0.5));
	self dodamage(self.health + 5, (0,0,0));
}

grenadeGuys()
{
	self waittill ("spawned",spawn);
	if (spawn_failed(spawn))
		return;
	spawn thread grenadeGuysMoveup();
}


killSpawnerDelayed(num, timer)
{
	wait (timer);
	maps\_spawner::kill_spawnerNum(num);
}

runDelete()
{
	self endon ("death");
	
//	if (isdefined(self.script_noteworthy) && self.script_noteworthy == "zombie_guy")
//		self.anim_combatrunanim == %zombieWalk;
		
	node = getnode(self.target,"targetname");
	for (;;)
	{
		self setgoalnode (node);
		self.goalradius = node.radius;
		assert(node.radius > 0);
		self waittill ("goal");
		if (!isdefined (node.target))
			break;
		node = getnode(node.target,"targetname");
	}
	self delete();
}

stalingradSpawnRunDelete(delay)
{
	self endon ("death");
	if (isdefined(delay))
		wait (delay);
		
	self.count = 1;
	spawn = self stalingradspawn();
	if (spawn_failed(spawn))
	{
		flag_set("moveup_past_zombie");
		return;
	}
	spawn endon ("death");
	spawn.grenadeawareness = 0;
		
	node = getnode(self.target,"targetname");
	for (;;)
	{
		spawn setgoalnode (node);
		spawn.goalradius = node.radius;
		assert(node.radius > 0);
		spawn waittill ("goal");
		if (!isdefined (node.target))
			break;
		node = getnode(node.target,"targetname");
	}
	spawn dodamage(spawn.health + 1, spawn.origin);
}

spawnRunDelete(delay)
{
	if (isdefined(delay))
		wait (delay);
		
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		return;
	spawn endon ("death");
		
	node = getnode(self.target,"targetname");
	for (;;)
	{
		spawn setgoalnode (node);
		spawn.goalradius = node.radius;
		assert(node.radius > 0);
		spawn waittill ("goal");
		if (!isdefined (node.target))
			break;
		node = getnode(node.target,"targetname");
	}
	spawn delete();
}

anim_single_solo (guy, anime, tag, node, tag_entity)
{
	newguy[0] = guy;
	maps\_anim::anim_single (newguy, anime, tag, node, tag_entity);
}

anim_reach_solo (guy, anime, tag, node, tag_entity)
{
	self endon("death");

	newguy[0] = guy;
	maps\_anim::anim_reach (newguy, anime, tag, node, tag_entity);
}

moveUp()
{
	for (i=0;i<9;i++)
		level.moveString[i] = i;
	level.moveStringNum = 0;
	array_randomize(level.moveString);
	array_thread(getentarray("move_up","targetname"), ::moveUpTrigger);
}

moveUpTrigger()
{
	for (;;)
	{
		self waittill ("trigger", other);
		if (isdefined(other.animName) && other.animName != "generic")
			continue;
		if ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "zombiewait") )
			flag_wait("moveup_past_zombie");
		if (!isdefined(other))
			return;
		other.animName = "generic";
		other anim_single_solo(other, "move" + (level.moveString[level.moveStringNum] + 1));
		level.moveStringNum++;
		if (level.moveStringNum >= level.moveString.size)
			level.moveStringNum = 0;
		return;
	}
}

bullets()
{
	self endon ("death");
	for (;;)
	{
		self waittillmatch("single anim","fire");
		self shoot();
	}
}

cal30guyDies()
{
	trigger = getent ("cal30_dies_trigger", "targetname");
	trigger waittill ("trigger");
	array = getentarray ("cal30_dies","script_noteworthy");
	ai = undefined;
	for (i=0;i<array.size;i++)
	{
		if (!isalive(array[i]))
			continue;
		ai = array[i];
		break;
	}
	if (!isalive(ai))
		return;
	ai endon ("death");
	wait (5);
	ai notify ("stop magic bullet shield");
	ai dodamage(ai.health + 5, ai.origin);
}

grenadeTrigger()
{
	self waittill ("trigger");
	flag_set("grenade_ready");
}

triggerThenFlag(msg)
{
	self waittill ("trigger");
	//wait (3);
	flag_set(msg);
}

makeInvul()
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		waittillframeend; // portable mg42 stuff sets health to 1
		spawn.health = 5000;
		spawn thread magic_bullet_shield();
		spawn.anim_disablePain = true;
		spawn thread cal30diesOnNotify();
	}
}

cal30diesOnNotify()
{
	self endon ("death");
	level waittill ("kill_30_call");
	self delete();
}

endMusic()
{
	//wait (6.0);
	//musicPlay(level.music["coastal_road"]);
	
	getent("music_cow","targetname") waittill ("trigger");
	//fade out current music over 5 seconds
	thread happy_music_start_ok();
	//musicstop(5);
	
	getent("music_horse","targetname") waittill ("trigger");
	flag_wait("happy_music_start_ok");
	//start happy music
	musicPlay(level.music["found_guns"]);
}

happy_music_start_ok()
{
	wait 5.5;
	flag_set("happy_music_start_ok");
}

arch_autosave()
{
	trig = getent("arch_autosave","targetname");
	
	trig waittill ("trigger");
	getent("trigger_30cal","targetname") triggerOff();
	
	thread autoSaveByName("orchard");
	
	flag_wait("do_thermites");
	
	trig waittill ("trigger");
	thread autoSaveByName("leaving_orchard");
}