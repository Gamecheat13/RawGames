#include maps\_utility;
#using_animtree ("generic_human");
main()
{	
//	cullFog = (getcvar("r_forcetechnology") == "" || getcvar("r_forcetechnology") == "default" || getcvar("r_forcetechnology") == "dx9" || getcvar("r_forcetechnology") == "DX9" || getcvarint("r_forcetechnology") == 1);
//	if (cullFog)	
//		setCullFog(400, 4000, .58, .57, .57, 0);
//	else
	setExpFog(0.00015, .58, .57, .57, 0);
	//thread tester();
//	setCullDist (3000);

/*
	volsky_window_node
*/

	precacheString(&"DOWNTOWN_ASSAULT_OBJ_1");
	precacheString(&"DOWNTOWN_ASSAULT_OBJ_2");
	precacheString(&"DOWNTOWN_ASSAULT_OBJ_3");
	precacheString(&"DOWNTOWN_ASSAULT_OBJ_6");
	precacheString(&"DOWNTOWN_ASSAULT_OBJ_7");
	precacheString(&"DOWNTOWN_ASSAULT_OBJ_8");
	precacheShader("inventory_stickybomb");

	level.objText1 = &"DOWNTOWN_ASSAULT_OBJ_1"; // "Recapture the Apartment Buildings (3 remaining)";
	level.objText1b= &"DOWNTOWN_ASSAULT_OBJ_1B"; // "Recapture the Apartment Buildings (&&1 remaining)";
	level.objText2 = &"DOWNTOWN_ASSAULT_OBJ_2"; // "Find an anti-tank weapon.";
	level.objText3 = &"DOWNTOWN_ASSAULT_OBJ_3"; // "Destroy the Panzer II tank the sticky bombs.";
	level.objText6 = &"DOWNTOWN_ASSAULT_OBJ_6"; // "Help comrades destroy the ammo depot.";
	level.objText7 = &"DOWNTOWN_ASSAULT_OBJ_7"; // "Destroy the Panzer II tank the sticky bombs.";
	level.objText8 = &"DOWNTOWN_ASSAULT_OBJ_8"; // "Advance upon City Hall";

	level.active_objective = [];
	level.inactive_objective = [];

	flag_init("show_explosives");
	flag_init("force_tank");
	flag_init("crazyGuy");
	flag_init("defend_begins");
	flag_init("defend_complete");
	flag_init("end_tank_starts");
	flag_init("infiltrated_depot");
	flag_init("delete_explosives");
	flag_init("depot_right_cleared");
	setsavedcvar("cg_hudCompassMaxRange", "1000");

	level.bombModel = "xmodel/weapon_stickybomb";
	level.bombModelObj = "xmodel/weapon_stickybomb_obj";
	precacheModel(level.bombModel);
	precacheModel(level.bombModelobj);
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");

	level.mortar = loadfx ("fx/explosions/large_snow_explode1.efx");
	level.door = getent ("door","targetname");
	level.door disconnectPaths();
	level.door setshadowhint("normal");


	level.earthquake["explosion"]["magnitude"]	= 0.65;
	level.earthquake["explosion"]["duration"]	= 0.5;
	level.earthquake["explosion"]["radius"]		= 548;

	level.earthquake["tank_shot"]["magnitude"]	= 0.45;
	level.earthquake["tank_shot"]["duration"]	= 1.8;
	level.earthquake["tank_shot"]["radius"]		= 548;


	getent ("explosives","targetname") thread hideObjectiveExplosives();
	
	// guys that ride in vehicles shouldnt have goals initially
//	array_thread(getentarray("disable_goal","script_noteworthy"), ::disableGoal);

	// various mortars that are triggered to go off by the player's presense
	array_thread(getentarray("mortar_trigger","targetname"), ::mortarThink);
	
	// Grenades that get thrown in from any AI touching a trigger
	array_thread(getentarray("grenade_gen","targetname"), ::grenadeGen);

	// triggers for the tank's exploders at the end
	array_thread(getentarray("tank_rampage","targetname"), ::tankRampage);

	// chatter from buddies that is plot related but doesnt need volsky to say it
	array_thread(getentarray("generic_chat","targetname"), ::generic_chat);

	// guys in the first objective building that move indoors when the player enters
	array_thread(getentarray("player_enters_attacker","script_noteworthy"), ::player_enters);

	// if you run past the enemies in the 3rd apartment, this triggers them to go after youl
	getent ("defend_friendlies","targetname") thread apartment_three_override();
	
	thread endingTrigger();
	
	level.timersused = 0;
	
	level.campaign = "russian";	
	maps\_jeep::main("xmodel/vehicle_russia_jeep");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii_winter");
	maps\_truck::main("xmodel/vehicle_opel_blitz_snow");
	maps\downtown_assault_fx::main(); 
	maps\_load::main();
	maps\downtown_assault_anim::main(); 
	level thread maps\downtown_assault_amb::main();
	setEnvironment ("cold");

	// "Recapture the Apartment Buildings (3 remaining)"
	objective_add(1, "active", level.objText1, getObjOrigin("east_apartment"));
	objective_state(1, "current");
	objective_string(1, level.objText1b, 3);

	// "Help comrades destroy the ammo depot."
	objective_add(6, "active", level.objText6, getObjOrigin("defend"));
	// "Advance upon City Hall"
	objective_add(8, "active", level.objText8, getnode("end_chain","targetname").origin);

	
	level thread music();
	
	thread intro_tank_trigger(); // the tank that rolls in early on
	getent ("volsky","targetname") thread volsky();
	

	objective = getcvar("start");
	if (objective == "" || objective == "start")
	{
		setcvar("start","start");
		wait (0.05);
	}

	playerChain = getnode("first_chain","targetname");
	level.player setFriendlyChainWrapper(playerChain);
//	intro_tankAttacks();	
	
	if (objective == "mid")
	{
		getent ("intro_tank","targetname") delete();
		level.inv_sticky = maps\_inventory::inventory_create("inventory_stickybomb",true);
		level.player takeWeapon("tt30");
		level.player giveWeapon("springfield");
//		level.player giveWeapon("mosin_nagant");
		thread ally_die(); // the allies in front of the player that die early on
		objective_state(1, "done");
//		objective_state(5, "done");
		start = getent ("midpoint","targetname");
		level.player setorigin (start.origin);
		level.player.angles = (1230,1230,1230);
		thread objective6();

		node = getnode("auto2284","targetname");
		level.volsky teleport (node.origin);
		level.volsky.goalradius = node.radius;
		
		wait (1.05);
		level.volsky setgoalnode (node);
		return;
	}
	if (objective == "tank")
	{
		getent ("intro_tank","targetname") delete();
		level.inv_sticky = maps\_inventory::inventory_create("inventory_stickybomb",true);
		level.player takeWeapon("tt30");
		level.player giveWeapon("enfield");
//		exploder(12);
		thread crazyGuyAndVolskyChatter();
		thread ally_die(); // the allies in front of the player that die early on

		objective_state(1, "done");
//		objective_state(5, "done");
		level.player setorigin ((343, 925, 266));
		thread killFriendlies();	
		chain_node = getnode("defend_chain", "targetname");
		level.player setfriendlychain(chain_node);
		thread endtank();
		thread objective7();

		node = getnode("auto2284","targetname");
		level.volsky teleport (node.origin);
		level.volsky.goalradius = node.radius;
		wait (1.05);
		level.volsky setgoalnode (node);
		return;
	}

	// objective 1
//	Comrades - the fascists have recaptured several apartments along this street. 
//  Our duty is to take back these buildings, one by one, and then destroy their ammunition 
//  depot near city hall. Let's go!
	battleChatterOff( "allies" );
	level.volsky anim_single_solo (level.volsky, "intro"); 
	battleChatterOn( "allies" );


	// triggers volsky to run to the second floor to help show the second floor enemies
	getent("friendly_help_trigger","targetname") thread friendlyAssistTrigger();
	
	// makes this friendly chain effectively a trigger once but its the only friendly chain so it doesnt matter
	getent("south_chain_trigger","targetname") thread south_chain_trigger();

	objEvent = getObjEvent("east_apartment");
	objEvent waittill_objectiveEventNoTrigger();
	wait (0.7);
	
	flood_and_secure_scripted(getentarray("tank_defender","targetname"));
	flood_and_secure_scripted(getentarray("tank_defender_trolly","targetname")); // separate them so they dont wave spawn
	flood_and_secure_scripted(getentarray("tank_defender_crud","targetname")); // separate them so they dont wave spawn
	
	level.volsky setgoalentity (level.player);
//	flag_set ("stopchat" + "town_hall");
	level notify ("stop_friendly_assist_trigger");

	// "Recapture the Apartment Buildings (2 remaining)"
	objective_string(1, level.objText1b, 2);
	
//	objective_state(1, "done");
//	objective_current(4);
	objective_position(1, getObjOrigin("south_building"));
	wait (1);
	autosave(1);
//	objEvent objSetChainAndEnemies();
//	rifleGuysDefendObjective("east_apartment_defend");
//	maps\_utility::autosave(1);


	// objective 2
	if (!flag("force_tank"))
		intro_tankAttacks();
	
	trigger = getent ("explosives","targetname");
	// "Find Anti Tank Weapon."
	objective_add(2, "active", level.objText2, getent ("explosives","script_noteworthy").origin);
	objective_current(2);
	flag_set("show_explosives");
	trigger waittill ("trigger");
	objective_state(2, "done");
	flag_set("delete_explosives");
	level.inv_sticky = maps\_inventory::inventory_create("inventory_stickybomb",true);


	trigger delete();
	autosave(1);
	wait (1);
	// play a cool pickup sound
	// "Hmph. Must be your peasant's luck, Vasili, well done! Now set those explosives on the back of the tank!";
	level.volsky thread anim_single_solo (level.volsky, "lucky");
	level.volsky setgoalnode (getnode("volsky_window_node","targetname"));

	level.intro_tank thread tank_explosives();
	
	objective3();
}

objective3()
{
	
	moveVolskyIn();
	// objective 3
	setObjective_inactive ("tank_attack");
	//"Destroy the Tank with TNT."
	objective_add(3, "active", level.objText3, level.intro_tank.origin);
	objective_current(3);
	
	level.intro_tank waittill ("disabled");

	level.door connectPaths();
	level.door rotateYaw(85,1);
	wait (1.5);
	radiusDamage (level.intro_tank.origin, 2, 10000, 9000);
	radiusDamage (level.intro_tank.origin + (0,0,32), 600, 1400, 100);

	// guys at the beginning of the level that lead you to the end if you approach them
	array_thread (getentarray("friendly_hint","targetname"), ::friendlyHintThink);
	
	// delete the tank escort spawners
	maps\_spawner::kill_spawnerNum(8);
	
	objective_state(3, "done");

	// objective 4
	// counter attack guys that lead player around the level
	
	chain_node = getnode("north_chain", "targetname");
	level.player setfriendlychain(chain_node);
//	flood_and_secure_scripted(getentarray("tank_avenger","targetname"));
	array_thread (getentarray("tank_avenger","targetname"), ::spawnAttackDelete);
	array_thread (getentarray("killed_tank","targetname"), ::spawnAttackDelete);
	objEvent = getObjEvent("south_building");
	objective_current(1);

	// friendlies periodically are killed off so they respawn and run to the front
	thread friendliesHintObjective();

	objEvent waittill_objectiveEventNoTrigger();

	objEvent = getObjEvent("north_building");
//	objective_current(1);
// "Recapture the Apartment Buildings (1 remaining)"
	wait (0.5);
	objective_string(1, level.objText1b, 1);
	objective_position(1, getObjOrigin("north_building"));

	wait (0.5);
	autosave(2);

	wait (2.5);
	
	// "These buildings are back in Soviet hands comrades!! Head for that office building and clear it out!!! Keep moving!!!"
	level.volsky thread anim_single_solo (level.volsky, "got_buildings");
	
	
	objEvent waittill_objectiveEventNoTrigger();
	autosave(1);
	
	objective_string(1, level.objText1);
	objective_state(1, "done");
//	objective_string(1, "Recapture the Apartment Buildings (0 remaining)");
//	objective_state(5, "done");
	objective_current(8);
	objective6();
}

updateObjective5(remaining)
{
	objective_string(6, "Help 10 comrades get across. [" + remaining + " remaining]");
}

delayed_autosave(num)
{
	wait 1;
	autosave(num);
}

wave()
{
	assert (!isdefined(self.animname));
	self endon ("death");
	self thread forcecustomBattleChatter( "move_forward" );
	self.wave = true;
	self.animname = "generic";
	self.run_combatanim = %run_and_wave;
	wait (2);
	self.run_combatanim = undefined;
}

friendlyWaveAnimTrigger()
{
	for (;;)
	{
		self waittill ("trigger", other);
		if (!isalive(other))
			continue;
		other thread wave();
		break;
	}
}

objective6()
{
	array_thread(getentarray("objective_5_axis","script_noteworthy"), ::fallBack);

	array_thread (getentarray("german_preattackers","targetname"), ::spawnNoSuppression);
	array_thread (getentarray("german_attackers_1","targetname"), ::spawnerHasNoSuppression);
	thread objective6friendlies();
	thread objective6axis();
	
	// disable suppression on AI that enter this volume because they hide too much
	getent ("remove_suppression","targetname") thread removeSuppressionTrigger();
	
	// this trigger makes the first friendly to run through wave
	getent ("friendly_wave_anim","targetname") thread friendlyWaveAnimTrigger();

	trigger = getent ("defend_friendlies","targetname");
	trigger waittill ("trigger");
	thread crazyGuyAndVolskyChatter();
	battleChatterOff("allies");
	
	flag_set ("defend_begins");
	thread killFriendlies();	
	wait (1);
	
	// Vasili! We have comrades down there, trying to breach the German ammo depot! Fire on the German positions 
	// so they can move up and get inside! 
	level.volsky anim_single_solo (level.volsky, "help_comrades");
	
	
	
	// "Help comrades destroy the ammo depot."
	objective_current(6);
	delayed_autosave(3);


	// get smg guy back on the friendly chain
	oldbias = level.player.threatbias;
	level.player.threatbias = 987243;
	waittillNortheastCleared_orTimer(17);
	flag_set("depot_right_cleared");
	flood_and_secure_scripted(getentarray("depot_defender","targetname"), true); // instant respawn
	flag_wait("infiltrated_depot");
	thread endtank();
	level.player.threatbias = oldbias;
	wait (4);
	thread failureExplosion();
	flag_set("defend_complete");
	
	objective_state(6, "done");
	battleChatterOn("allies");
		
	delayed_autosave(4);
	objective7();
}


objective6friendlies()
{
	wait (6);
	getent ("destroy_depot","targetname") thread destroyDepot();
//	wait (9);
	spawner = getent("depot_attacker","targetname");
	node = getnode (spawner.target,"targetname");
	for (;;)
	{
		ent = getent(node.target,"targetname");
		ent thread objective6_attackFreeCheck(node.script_noteworthy);
//		ent thread touchingDebug();
//		ent thread objective6_attackFreeCheck(isdefined (self.script_noteworthy) && self.script_noteworthy == "vol2");

		node = getnode(node.target, "targetname");
		if (!isdefined(node.target))
			break;
	}
	
	level.depotAttackerCount = 3;
	for (;;)
	{
		if (!level.depotAttackerCount)
		{
			wait (1);
			continue;
		}
		
		spawner.count = 1;
		spawn = spawner dospawn();
		if (spawn_failed(spawn))
		{
			wait (1);
			continue;
		}
		
		spawn thread objective6_depotAttacker();
		wait (1);
	}
}

objective6_depotAttacker()
{
	level endon("infiltrated_depot");
	self endon ("death");
	thread objective6_getback();
	self thread objective6_depotDeathCounter();
	self.suppressionwait = 0;
	self.pathenemyFightdist = 64;
	self.pathenemyLookahead = 0;
	node = getnode(self.target,"targetname");
	self.goalradius = node.radius;
	self setgoalnode (node);
	volume = getent(node.script_noteworthy,"script_noteworthy");
	self setgoalvolume (volume);
	flag_wait("depot_right_cleared");

	for (;;)
	{
		ent = getnode(node.target, "targetname");
		if (node.script_noteworthy == "vol3")
			wait (10); // give time for the truck to do its thing
//			wait (47);
		flag_wait ("depot_attack" + ent.targetname);
		node = getnode (node.target,"targetname");
		self.goalradius = node.radius;
		self setgoalnode(node);
		if (isdefined (node.script_noteworthy))
		{
			volume = getent(node.script_noteworthy,"script_noteworthy");
			self setgoalvolume (volume);
		}
		self waittill ("goal");
		wait (5);
		if (!isdefined(node.target))
			return;
	}
}	

destroyDepot()
{
	// depot blows up when this gets hit by a friendly
	self waittill ("trigger");
	wait (2);
	flag_set ("infiltrated_depot");
}

objective6_getback()
{
	self endon ("death");
	flag_wait("infiltrated_depot");
	node = getnode ("vol3","script_noteworthy");
	self setgoalnode (node);
}

objective6_depotDeathCounter()
{
	level.depotAttackerCount--;
	self waittill ("death");
	level.depotAttackerCount++;
}

depotRightFlag(flagname)
{
	level waittill ("depot_right_cleared");
	flag_set(flagname);
}

objective6_attackFreeCheck(vol)
{
	// sets a flag if the radius the AI want to run to is free
	flagname = "depot_attack" + self.targetname;
	flag_clear (flagname);
	level endon ("defend_complete");
	if (vol == "vol1")
	{
		level endon ("depot_right_cleared");
		thread depotRightFlag(flagname);
	}
	
	// this trigger makes sure the player is actually at the window
	trigger = getent ("player_moveup_detection","targetname"); 
	for (;;)
	{
		ai = getaiarray("axis");
		newai = [];
		for (i=0;i<ai.size;i++)
		{
			if (vol == "vol3")
			{
				// on the last one, you can just have them suppressed
				if (ai[i] issuppressed())
					continue;
			}
			if (!ai[i] istouching (self))
				continue;
				
			newai[newai.size] = ai[i];
		}
		
		if (newai.size <= 0)
		{
			if (!flag(flagname) && level.player istouching(trigger))
			{
				flag_set(flagname);
				wait (2);
			}
			else
				wait (0.5);
			continue;
		}
		
		if (flag(flagname))
			flag_clear(flagname);
			
		ai = newai;
		
		for (;;)
		{
			attackers = 0;
			for (i=0;i<ai.size;i++)
			{
				if (!isalive (ai[i]))
					continue;
				if (vol == "vol3")
				{
					// last one doesnt require touching ai to die
					if (ai[i] isSuppressed())
						continue;
				}
				if (!ai[i] istouching (self))
					continue;
					
				attackers++;
//				if (attackers > 1)
					break;
			}
			
			if (attackers <= 0)
				break;
				
			wait (0.2);
		}
	}
}

fallBack()
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (!spawn_failed(spawn))
			spawn thread fallBackSpawn();
	}
}

fallBackSpawn()
{
	self endon ("death");
	level waittill ("defend_complete");
	wait (randomfloat(1.5));
	node = getclosest (self.origin, getnodearray("fallback","script_noteworthy"));
	self setgoalnode (node);
	self.goalradius = node.radius;
}
	
alliesCross(num)
{
	allies = getentarray("defender_crosses","targetname");
	allies = array_randomize(allies);
	assert (num <= allies.size);
	for (i=0;i<num;i++)
	{
		allies[i].count = 1;
		spawn = allies[i] dospawn();
		if (!spawn_failed(spawn))
			spawn thread allyCrosses();
	}
}

allyCrosses()
{
	self endon ("death");
	self waittill ("goal");
	level.crossers++;
	level notify ("crosser");	
	self delete();
}

highAccuracy()
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (spawn_failed(spawn))
			continue;
		spawn.baseaccuracy = 10;
	}
}

objective6axis()
{
	flood_and_secure_scripted(getentarray("depot_predefender","targetname"), true); // instant respawn
	flood_and_secure_scripted(getentarray("german_attackers_1","targetname"), true); // instant respawn
	getent ("truck_attack","targetname") waittill ("trigger");
	getent("truck_trigger","targetname") notify ("trigger"); // nate's workaround style triggering
}

failureExplosion()
{
	exploder(1);
	wait (3);
	exploder(2);
	ai = getaiarray();
	trigger = getent ("depot_damage","targetname");
	for (i=0;i<ai.size;i++)
	{	
		if (ai[i] istouching (trigger))
			ai[i] dodamage(ai[i].health + 5, (0,0,0));
	}
}

end_gunners()
{
	for(;;)
	{
		self.count = 1;
		spawn = self dospawn();
		if (spawn_failed(spawn))	
		{
			wait (1);
			continue;
		}
		
		spawn waittill ("death");
	}
}

objective7()
{
	playerChain = getnode("defend_chain","targetname");
	level.player setFriendlyChainWrapper(playerChain);
	maps\_spawner::kill_spawnerNum(10); // the spawners that charge the ammo depot
	
	flood_and_secure_scripted(getentarray("end_tank_assist","targetname"));

	level waittill ("tank_frees_player");
	// allied mg42 guys that help out
	array_thread (getentarray("ally_end_gunner","targetname"), ::end_gunners);

	level.volsky setgoalnode (getnode("volsky_node","targetname"));
	level.volsky.goalradius = 512;
	
	thread hunterKiller();
	level.end_tank waittill ("disabled");
	end_door = getent ("end_door","targetname");
	end_door connectPaths();
	end_door rotateYaw(85,1);

	radiusDamage (level.end_tank.origin, 2, 10000, 9000);
	radiusDamage (level.end_tank.origin + (0,0,32), 600, 1400, 100);
	objective_state(7, "done");
	delayed_autosave(5);
	objective8();
}

objective8()
{
	objective_current(8);
	
	thread killBuddyTrigger();	
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		ai[i].pathEnemyFightDist = 384;
		ai[i].pathEnemyLookAhead = 384;
	}
	playerChain = getnode("end_chain","targetname");
	level.player setFriendlyChainWrapper(playerChain);
	
	level.volsky setgoalnode(getnode("volsky_end_line","targetname"));
	getent ("volsky_chat_trigger","targetname") waittill ("trigger");
	level.volsky thread anim_single_solo (level.volsky, "cityhall");
	level.volsky setgoalentity (level.player);
}

killBuddyTrigger()
{
	trigger = getent("kill_buddy","targetname");
	for (;;)
	{
		trigger waittill ("trigger",other);
		other delete();
	}
}

hunterKiller()
{
	wait (15);
	level.end_tank endon ("disabled");
	flag_wait ("end_tank_starts");	
	spawners = getentarray("hunter_killer","targetname");
	level.hunterKillers = 0;
	base = 15;
	if (level.gameSkill <= 2)
		return;
	
	flag_set("hunter_stop");
	getent ("axis_end","targetname") thread hunterStopTrigger();
	
	for (i=0;i<3;i++) // limit the # of waves
	{
		flag_wait("hunter_stop");		
		wait (base + randomfloat(3));
		array_thread(spawners, ::spawnAttackPlayer);
		waittillframeend; // spawn_failed waits until later, we need to wait even later!
		while (level.hunterKillers > 1)
			level waittill ("hunter_down");
	}
}

hunterStopTrigger()
{
	org = self getorigin()[1];
	for (;;)
	{
		self waittill ("trigger");
		flag_clear ("hunter_stop");
		// while the player is south of this line, dont spawn more of these guys
		for (;;)
		{
			while (level.player.origin[1] < org)
				wait (1);
			wait (5);
			if (level.player.origin[1] >= org)
				break;
		}
		flag_set ("hunter_stop");
	}
}

spawnAttackPlayer()
{
	self.count = 1;
	spawn = self dospawn();
	if (!spawn_failed(spawn))
		spawn thread attackPlayer();
}

attackPlayer()
{
	level.hunterKillers++;
	self setgoalentity (level.player);
	self.goalradius = 600;
	self.favoriteEnemy = level.player;
	self waittill ("death");
	level.hunterKillers--;
	level notify ("hunter_down");
}

volsky()
{
	level.volsky = self;
	level.volsky.looktarget = level.player;
	level.volsky setBattleChatter(false);
	level.volsky.animname = "volsky";
	maps\_spawner::squadThink();
	thread magic_bullet_shield();
}

disableGoal()
{
	self endon ("jumpedout");

	self waittill ("spawned", spawn);
	spawn endon ("death");
	spawn thread arrival();
	for (;;)
	{
		spawn.goalradius = 512;
		spawn setgoalpos (spawn.origin);
		wait (1);
	}
}

arrival()
{
	self endon ("death");
	self waittill ("jumpedout");
	node = getnode (self.target,"targetname");
	self.goalradius = node.radius;
	self setgoalnode (node);
}

killFriendlies()
{
	flag_wait ("crazyGuy");
	array_thread (getaiarray("allies"), ::killSelectFriendlies);
	array_thread (getentarray("crazy_killers", "targetname"), ::crazyAttackers); // guys that the crazy guy attacks
}

crazyAttackers()
{
	level endon ("defend_complete");

	for (;;)
	{
		self.count = 1;
		spawn = self dospawn();
		if (spawn_failed(spawn))
		{
			wait (0.5);
			continue;
		}
		
		spawn.suppressionwait = 0;
		spawn.anim_forced_cover = "show";
		spawn waittill ("death");
	}
}
	
killSelectFriendlies()
{
	if (self == level.crazy)
		return;
	if (self == level.volsky)
		return;
	if (isdefined(self.script_noteworthy) && self.script_noteworthy == "dont_kill_me")
		return;
		
	// dont kill guys that moved up into the transition building
	if (self.origin[0] > -729)
		return;
		
	wait (0.05);
	if (isalive(self))
		self delete();
}

volskySpeaksLine()
{
	if (!flag("depot_right_cleared"))
	{
		if (level.volskyLines == -1)
		{
			//	Keep the pressure on the Germans so our men can move up to the depot!
			level.volsky thread anim_single_solo (level.volsky, "keep_pressure");
			wait (3);
			level.volskyLines = -2;
		}
		else
		if (level.volskyLines == -2)
		{
			//	Don't let up! They must reach the depot!
			level.volsky thread anim_single_solo (level.volsky, "dont_give_up");
			wait (3);
			level.volskyLines = -1;
		}
		return;
	}
	
	if (flag("infiltrated_depot"))
		return;
	if (level.volskyLines < 0)
		level.volskyLines = 0;
		
	if (level.volskyLines == 0)
	{
		//	Vasili! Suppress the Germans in the building on the left side of the road!
		level.volsky thread anim_single_solo (level.volsky, "suppress_germans");
		wait (3);
	}
	if (level.volskyLines == 1)
	{
		//	The building on the left, Vasili!! Shoot through those windows!!!
		level.volsky thread anim_single_solo (level.volsky, "left_building");
		wait (3);
	}
	if (level.volskyLines == 2)
	{
		//	Keep the pressure on the Germans so our men can move up to the depot!
		level.volsky thread anim_single_solo (level.volsky, "keep_pressure");
		wait (4);
	}
	if (level.volskyLines == 3)
	{
		//	Don't let up! They must reach the depot!
		level.volsky thread anim_single_solo (level.volsky, "dont_give_up");
		wait (6);
	}
	level.volskyLines++;
}


crazyGuyAndVolskyChatter()
{
	level.volskyLines = -1;
	
	flag_wait ("defend_begins");
	wait (5.8);
	crazySpawner = getent ("crazy_guy","targetname");
	crazy = undefined;
	for (;;)
	{
		crazySpawner.count = 1;
		crazy = crazySpawner dospawn();
		if (spawn_failed(crazy))
		{
			wait (0.3);
			continue;
		}
		break;
	}

	level.crazy = crazy;
	level.crazy setBattleChatter(false);
	crazy.ignoreme = true;
	crazy.animname = "crazy";
	flag_set ("crazyGuy");
	crazy thread magic_bullet_shield();
	node = getnode (crazy.target,"targetname");
	crazy setgoalnode (node);
	crazy.goalradius = 64;
//	wait (9);
//	if (distance (crazy.origin, node.origin) > 80)
	crazy waittill ("goal");
	crazy.anim_forced_cover = "show";
	crazy.suppressionwait = 0;

	// "Good day comrade!!!! Leave some for me, ok?!!!!"
	thread crazyLine("leave_some");
	wait (6);
	wait_until_player_is_touching_window_trigger();
	volskySpeaksLine();

	// "This one's for my mother!!!!!"
	thread crazyLine("mother");
	wait (3);
	wait_until_player_is_touching_window_trigger();
	volskySpeaksLine();

	// "This one's for Valentina!!!!!"
	thread crazyLine("valentina");
	wait (3);
	wait_until_player_is_touching_window_trigger();
	volskySpeaksLine();
	
	// "That was for my father you fascist son of a bitch!!!!"
	thread crazyLine("father");
	wait (4);
	wait_until_player_is_touching_window_trigger();
	volskySpeaksLine();

	// "That one's for my little sister you butchers!!!!"
	thread crazyLine("sister");
	wait (4);
	wait_until_player_is_touching_window_trigger();
	volskySpeaksLine();

	// """And this one's for my dog!!!! How you like it? ahhhhhhhh 
	thread crazyLine("dog");
	wait (5.3);
	crazy dodamage (crazy.health + 5, (0,0,0));
	thread maps\_utility::playsoundinspace("bullet_impact_headshot",crazy gettagorigin ("TAG_EYE"));
	wait (2);
	
	while (!flag("infiltrated_depot"))
	{
		volskySpeaksLine();
		wait (5 + randomint(5));
	}
	
}

intro_tank_trigger()
{
	trigger = getent ("force_tank","targetname");
	trigger waittill ("trigger");
	level notify ("player_went_indoors");
	if (!flag("force_tank"))
		intro_tankAttacks();
}

player_enters_think()
{
	self endon ("death");
	level waittill ("player_went_indoors");
	node = getnode ("player_enters","script_noteworthy");
	volume = getent ("player_enters","script_noteworthy");
	self setgoalnode (node);
	self setgoalvolume (volume);
}

player_enters()
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (spawn_failed(spawn))
			continue;
		spawn thread player_enters_think();
	}
}

intro_tankAttacks()
{
	flag_set("force_tank");
	level.intro_tank = getent ("intro_tank","targetname");
//	level.intro_tank thread tank_explosives();
   	thread intro_tankMovement();

	tank = level.intro_tank;
	tank setwaitnode (getvehiclenode("panzer_notice","script_noteworthy"));
	tank setTurretTargetVec(getent("intro_tank_shoot","targetname").origin);
	tank waittill ("reached_wait_node");

	maps\_spawner::kill_spawnerNum(12);
	maps\_spawner::kill_spawnerNum(3);
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if (!isdefined(ai[i].script_deathChain))
			continue;
		if (ai[i].script_deathChain != 0)
			continue;
		ai[i] thread dieSoon();
	}
	
	
	battleChatterOff( "allies" );
	// panzer! panzer!
	thread nearestGenericAllyLine ("panzer");
	//tank waittill ("reached_end_node");
	wait (2.85);
	tank FireTurret();
	exploder(15);
	array_thread (getentarray("ally_die","script_noteworthy"), ::dieSoon);
	wait (2);
	// those men are all dead! this is suicide
	setObjective_active ("tank_attack");
	thread nearestGenericAllyLine ("suicide");
	tank thread earlytankTargetEnt();
	tank setTurretTargetEnt(tank.targetEnt, (0,0,24));
	wait (3.7);
	
	//"Keep it together Pavel! Vasili! Our comrades might have an anti-tank weapon with them! Go find out! 
	// We will cover you!!! Move!!!"
	level.volsky anim_single_solo (level.volsky, "find_antitank");
	battleChatterOn( "allies" );
	
//	thread ally_die(); // the allies in front of the player that die early on
}

intro_tankMovement()
{
	tank = level.intro_tank;
	tank endon ("disabled");
	maps\_vehicle::gopath(tank);
	flag_wait("delete_explosives");
	trigger = getent("tank_retreat_trigger","targetname");
	trigger waittill ("trigger");
	path = getvehiclenode("tank_retreat","targetname");
	tank attachPath( path );
	tank startPath();
}

earlytankTargetEnt()
{
	// make the tank shoot where the player was last seen. or target entities
	targets = getentarray("mg_target","targetname");
	self endon ("death");
	ent = spawn ("script_model", (0,0,0));
	self.targetEnt = ent;
	ent.origin = level.player.origin + (0,0,40);
//	ent setmodel ("xmodel/temp");
	for (;;)
	{
		if (sighttracepassed(self.origin + (0,0,64), level.player geteye(), false, self))
		{
			ent.origin = level.player.origin + (0,0,40);
			self.mgTurreT[0] settargetentity (level.player);
		}
		else
		{
			waittillTurretOnTargetOrTimeout();
			self notify ("seek_timeout");
			for (;;)
			{
				if (sighttracepassed(self.origin + (0,0,64), level.player geteye(), false, self))
					break;
				ent.origin = random(targets).origin;
				waittillTurretOnTargetOrTimeout();		
				self notify ("seek_timeout");
				self.mgTurreT[0] settargetentity (random(targets));
				self.mgTurreT[0] notify ("startfiring");
				self.mgTurreT[0] startFiring();
			}
		}
		
		wait (0.05);
	}
}

waittillTurretOnTargetOrTimeout()
{
	self endon ("seek_timeout");
	thread timeoutThread();
	self waittill ("turret_on_target");
	wait (2.5);
}

timeoutThread()
{
	self endon ("seek_timeout");
	wait (5);
	self notify ("seek_timeout");
}

tankTargetEnt()
{
	// make the tank shoot where the player was last seen.
	self endon ("death");
	ent = spawn ("script_model", (0,0,0));
	self.targetEnt = ent;
	ent.origin = level.player.origin + (0,0,40);
//	ent setmodel ("xmodel/temp");
	targets = getentarray("player_tank_target","targetname");
	for (;;)
	{
//		if (self cansee(level.player))
		target = getclosest(level.player.origin, targets);
		if (distance(target.origin, level.player.origin) < 270)
			ent.origin = target.origin;
		else
		if (sighttracepassed(self.origin + (0,0,64), level.player geteye(), false, self))
			ent.origin = level.player.origin + (0,0,40);
		wait (0.05);
	}
}

spawnerHasNoSuppression()
{
	for (;;)
	{
		self waittill("spawned",spawn);
		if (spawn_failed(spawn))
			continue;
		spawn noSuppression();
	}
}

noSuppression()
{
	self.suppressionwait = 0;
	self.anim_forced_cover = "show";
//	self.favoriteEnemy = level.player;
	self.pathenemyfightdist = 0;
	self.pathememylookahead = 0;
	self.script_displaceable = false;
	self.suppressionFlag = true;
}


removeSuppressionTrigger()
{
	for (;;)
	{
		self waittill ("trigger", other);
		if (!isalive(other))
			continue;
		if (isdefined(other.suppressionFlag))
			continue;
		other noSuppression();
	}
}


spawnNoSuppression()
{
	self.count = 1;
	spawn = self dospawn();
	self delete();	
	if (spawn_failed(spawn))
		return;
	spawn noSuppression();
}

spawnAttackDelete()
{
	self.count = 1;
	self dospawn();
	waittillframeend; // so that the ai gets to do his deathspawner thread before the spawner deletes
	self delete();	
}

spawnAttackDeleteDie()
{
	self.count = 1;
	spawn = self dospawn();
	self delete();	
	if (spawn_failed(spawn))
		return;
	spawn endon ("death");
	wait (15);
	spawn dodamage (spawn.health + 5, spawn.origin);
}

spawnAttack()
{
	self.count = 1;
	self dospawn();
}

spawnAttackSelfDelete()
{
	self.count = 1;
	spawn = self dospawn();
	if (!isalive(spawn))
		return;
	spawn thread goalAndDelete();
}

goalAndDelete()
{
	self endon ("death");
	self waittill ("goal");
	self delete();
}

deleteThis()
{
	self delete();
}

ally_die()
{
	trigger = getent ("ally_kill","targetname");
	trigger waittill ("trigger");
	
	array_thread (getentarray("ally_die","script_noteworthy"), ::dieSoon);
	wait (2);
//	flood_and_secure_scripted(getentarray("axis_west","targetname"));
}

dieSoon()
{
	if (!isalive(self))
		return;
		
	self endon ("death");
//	self.health = 1;
	wait (0.5 + randomfloat(1));
	self dodamage(self.health+5,self.origin);
}
	

grenadeGen()
{
	// finds a guy in the targetted volume and then makes that guy spawn 
	// several grenades from origins that target other origins
	
	self waittill ("trigger");
	volume = getent (self.target,"targetname");
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if (!ai[i] istouching (volume))
			continue;
		guy = ai[i];
		array_thread (getentarray(volume.target, "targetname"), ::grenadeGenCreate, guy);
		return;
	}
}

grenadeGenCreate(guy)
{
	guy endon ("death");
	first = false;
	if (!isdefined(level.grenade_gen_first))
	{
		level.grenade_gen_first = true;
		first = true;
	}
	
	wait (randomfloat (0.7));
	start = self.origin;
	end = getent(self.target,"targetname").origin;
	if (first)
		timer = 1.5;
	else
		timer = 3 + randomfloat(5);
		
	guy magicGrenade(start, end, timer);
}

shootUntilPlayerIsFreed()
{	
	level endon ("tank_frees_player");
	self waittill ("shoot_now");
	for (;;)
	{
		self FireTurret();
		wait (2 + randomfloat(1));
	}
}

tankFreedomTrigger()
{
	trigger = getent("tank_trigger","targetname");
	for (;;)
	{
		trigger waittill ("trigger", other);	
		if (other != level.end_tank)
			continue;
	}
	level notify ("tank_frees_player");
}

updateObjective7Origin()
{
	level.end_tank endon ("disabled");
	while (1)
	{
		objective_position(7, level.end_tank.origin);
		wait (0.1);
	}
}
	
	
endtank()
{
	tank = getent("end_tank","targetname");
	level.end_tank = tank;
	tank thread tank_explosives();
	wait (3);

	path = getvehiclenode (tank.target,"targetname");
	tank attachPath( path );
	tank startPath();
	tank waittill ("reached_end_node");

	tank.location = 8;
	shot1Org = getent("tank_target","targetname").origin + (0,60,15);
	tank setTurretTargetVec(shot1org);

	// "Panzer tank!!! Vasili!!! Get away from the window!!! Move!!!"
	level.volsky anim_single_solo(level.volsky, "window");
	wait (0.5);	
//	tank waittill("turret_on_target");
	eq = "tank_shot";
	tank FireTurret();
	earthquake(level.earthquake[eq]["magnitude"],
				level.earthquake[eq]["duration"],
				shot1Org,
				level.earthquake[eq]["radius"]);
	wait (1);
	shot2Org = getent("tank_target","targetname").origin + (0,80,25);
	tank setTurretTargetVec(shot2org);
	wait (2);
	tank FireTurret();
	earthquake(level.earthquake[eq]["magnitude"],
				level.earthquake[eq]["duration"],
				shot2Org,
				level.earthquake[eq]["radius"]);
	wait (2);
	tank setTurretTargetVec(getent("tank_target","targetname").origin);
	wait (1);

	thread tankFreedomTrigger();
	tank thread shootUntilPlayerIsFreed();
	wait (1.3);
	tank notify ("shoot_now");
	
	getent("tank_message_trigger","targetname") thread volskyHelpChatTrigger();
	
//	level waittill ("tank_frees_player");
//	thread disableHealthShield(1);
	exploder(12);
	delayed_autosave(4);
	tank endon ("disabled");
	level notify ("tank_frees_player");
	
	// "Destroy the tank with TNT."
	objective_add(7, "active", level.objText7, tank.origin);
	thread updateObjective7Origin();
	objective_current(7);	
	getent ("tank_start","targetname") waittill ("trigger");
	flag_set ("end_tank_starts");
//	tank setTurretTargetEnt(level.player, (0,0,24));
	tank thread tankTargetEnt();
	tank setTurretTargetEnt(tank.targetEnt, (0,0,0));
	tank takePath(6);
	forwards = true;
	choice[2] = getent ("tankspot_2","targetname");
	choice[4] = getent ("tankspot_4","targetname");
	choice[6] = getent ("tankspot_6","targetname");
	choice[8] = getent ("tankspot_8","targetname");
	
	for (;;)
	{
		nextLocation = tank getTriggeredDestinationOrTimeout();
		if (!isdefined(nextLocation))
		{
			// Timed out waiting for trigger
			// flee to the choice farther from the player.
			choices = [];
			switch(tank.location)
			{
				case 2:	
				case 8:	
				choices[0] = choice[6];
				choices[1] = choice[4];
				break;

				case 4:	
				case 6:	
				choices[0] = choice[2];
				choices[1] = choice[8];
				break;
			}
			
			dist1 = distance(level.player.origin, choices[0].origin);
			dist2 = distance(level.player.origin, choices[1].origin);
			if (dist1 > dist2)
				nextLocation = int(choices[0].script_noteworthy);
			else		
				nextLocation = int(choices[1].script_noteworthy);
/*			
			if (randomint(100) > 80)
				forwards = !(forwards);
			if (forwards)
			{
				switch(tank.location)
				{
					case 2:	nextLocation = 6; break;
					case 4:	nextLocation = 2; break;
					case 6:	nextLocation = 8; break;
					case 8:	nextLocation = 4; break;
				}
			}
			else
			{
				switch(tank.location)
				{
					case 2:	nextLocation = 4; break;
					case 4:	nextLocation = 8; break;
					case 6:	nextLocation = 2; break;
					case 8:	nextLocation = 6; break;
				}
			}
*/			
		}
		tank takePath(nextLocation);
	}
}

takePath(num)
{
	string = "path_";
	if (level.gameSkill >= 3)
		string = "path_hard_";
	path = getvehiclenode (string + self.location + "to" + num,"targetname");
	self attachPath( path );
	self startPath();
	self waittill ("reached_end_node");
	if (!isdefined (level.firsttanktimeout))
		level.firsttanktimeout = 1;
	else
	{
		wait (0.5 + randomfloat (1));
		self FireTurret();
	}
	self.location = num;
}

tankTimeout()
{
	level endon ("tank_timeout");
	if (level.firsttanktimeout != 1)
		wait (2 + randomfloat(2));
	level.firsttanktimeout = 2;
	level notify ("tank_timeout");
}

getTriggeredDestinationOrTimeout()
{
	level endon ("tank_timeout");
	thread tankTimeout();
	level notify ("new_tank_triggers");
	array_thread (getentarray("tank_move_" + self.location, "targetname"), ::tankTriggerThink);
	level waittill ("new_tank_direction", direction);
	return direction;
}

tankTriggerThink()
{
	level endon ("new_tank_triggers");
	self waittill ("trigger");
	level notify ("new_tank_direction", int(self.script_noteworthy));
}

tankRampage()
{
	for (;;)
	{
		self waittill ("trigger", other);
		if (!isdefined(level.end_tank))
			continue;
		if (other != level.end_tank)
			continue;
		exploder(self.script_noteworthy);
		break;
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
	tags[3] = "tag_left_wheel_01";
	tags[4] = "tag_right_wheel_01";
	location_angles = [];
	location_angles[0] = (90,0,0);
	location_angles[1] = (0,270,0);
	location_angles[2] = (0,90,0);
	location_angles[3] = (0,270,0);
	location_angles[4] = (0,90,0);

	for (i=0; i < tags.size; i++)
	{
		bomb = spawn("script_model", self gettagorigin(tags[i]));
		bomb setmodel(level.bombModelObj);
//		bomb.angles = location_angles[i];
		bomb linkto(self,tags[i], (0,0,0), location_angles[i]);
//		self thread drawTag(tags[i]);
		bomb.trigger = undefined;

		aTrigger = getentarray("sticky_trigger","targetname");
		for (t=0; t < aTrigger.size; t++)
		{
			if (isdefined(aTrigger[t].inuse))
				continue;
			bomb.trigger = aTrigger[t];
			break;
		}

		assert(isdefined(bomb.trigger));
		bomb.trigger.inuse = true;

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

	bomb = self.bombs[id];

	level thread remove_stickys(self.bombs,id);

	bomb setmodel (level.bombModel);
	bomb playsound ("stickybomb_plant");
	bomb playloopsound ("bomb_tick");
	if (flag("end_tank_starts"))
		level.inv_sticky maps\_inventory::inventory_destroy();

	self stopwatch(bomb);

	badplace_delete(badplacename);
	self setspeed(0,100);
	self disconnectpaths();
	self.vehicle_disabled = true;

	self playsound ("grenade_explode_default");
	level maps\_fx::OneShotfx("sticky_explosion", bomb.origin, 0.1);
	radiusDamage (bomb.origin + (0,0,0), 600, 1400, 100);

	self thread maps\_fx::loopfx("sticky_explosion_smoke",self gettagorigin("tag_engine_left"), 2,undefined);

	bomb delete();
	self notify("disabled");
}

tank_ondeath()
{
	self waittill("death");
	level thread remove_stickys(self.bombs);
	level notify("tank destroyed",self.pos_id);
}

tank_explosives_wait(trigger,id)
{
	self endon ("death");
	self endon ("explosives planted");
	
	trigger setHintString (&"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES");
	while(true)
	{
		trigger waittill ("trigger");

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

remove_stickys(bombs, id)
{
	if (!isdefined(id))
		id = 1000; // a value that will never match
	for (i=0;i < bombs.size;i++)
	{
		if (!isdefined(bombs[i]))
			continue;
		bombs[i].trigger unlink();
		bombs[i].trigger.inuse = undefined;
		bombs[i].trigger.origin =  bombs[i].trigger.oldorigin;

		if (i != id)
			bombs[i] delete();
	}
}

endingTrigger()
{
	trigger = getent ("ending","targetname");
	trigger waittill ("trigger");
	maps\_endmission::nextmission();
}

disableHealthShield(timer)
{
	level.player enableHealthShield( false );
	wait (timer);
	level.player enableHealthShield( true );
}

waitUntilTriggerOrForceCharge()
{
	// a backup trigger forces the sequence along if the player moves too fast
	getent(self.target,"targetname") endon ("trigger");
	wait (10);
}

rechargeSquad(spawners)
{
	for (i=0;i<spawners.size;i++)
		spawners[i].count = 1;
}

mortarThink()
{
	self waittill ("trigger");
	mortarWave(getent(self.target,"targetname"));	
}

mortarWave(mortar)
{
	for (;;)
	{
		mortar maps\_mortar::activate_mortar(undefined,undefined,undefined,undefined,undefined,undefined, false);
		if (!isdefined(mortar.target))
			break;
		mortar = getent (mortar.target,"targetname");
		wait (0.8 + randomfloat(1));
	}
}



setHealth(guy, num)
{
	if (!isalive(guy))
		return;
	guy.health = num;
}


defenseThink()
{
	self.anim_forced_cover = "show";
	self.grenadeammo = 1;
	self.fightdist = 220;
	self.maxdist = 220;
	self waittill ("goal");
	self.maxdist = 1024;
}

offenseThink()
{
	self endon ("death");
	self.fightdist = 220;
	self.maxdist = 220;
	self.goalradius = 64;
	self waittill ("goal");
	self.fightdist = 1024;
	self.maxdist = 1024;
	self.goalradius = 1024;
	/*
	self.grenadeammo = 0;
	self.fightdist = 220;
	self.maxdist = 220;
	node = random(getnodearray("chargeNode","targetname"));
	self.goalradius = 64;
	self setgoalnode(node);
	self waittill ("goal");
	self setgoalnode (getnode(self.target,"targetname"));
	self.goalradius = 450;
	self waittill ("goal");
	self.fightdist = 1024;
	self.maxdist = 1024;
	self.goalradius = 1024;
	*/
}

friendlyAdvance()
{
	self waittill ("trigger");
	level notify ("friendly_advance", self);
	level.currentFriendlyNode = getnode(self.target,"targetname");
}

friendlyReinforcementTrigger()
{
	spawners = getentarray(self.target,"targetname");
	array_thread(spawners,::spawnerFriendlyThink);
}

spawnerFriendlyThink()
{
	self waittill ("spawned",spawn);
	spawn endon ("death");
	spawn_failed(spawn);
	spawn waittill ("goal");	
	spawn friendlyThink();
}

friendlyThink()
{
	spawn_failed(self);
	self.goalradius = 64;
	self.maxdist = 400;
	wait (10);
	node = getnode("friendly_node","targetname");
	self setgoalnode (node);
	self.goalradius = 256;
	
	self.maxdist = 500;
	self.fightdist = 384;
	self endon ("death");
	advanceNum = 0;
	if (isdefined(level.currentFriendlyNode))
		self setgoalnode(level.currentFriendlyNode);
		
	for (;;)
	{
		level waittill ("friendly_advance", trigger);
		// Only advance if its to an equal or higher number
		newAdvanceNum = int(trigger.script_noteworthy);
		if (newAdvanceNum < advanceNum)
			continue;
		advanceNum = newAdvanceNum;
		
		node = getnode(trigger.target,"targetname");
		self setgoalnode (node);
		self.goalradius = node.radius;
		if (isdefined(node.height))
			self.goalheight = node.height;
	}
}

spawnSquad(spawners, spawnThink)
{
	// Spawn guys from special "deck" script_origins and run "spawnthink" function on them if there is one.
	
	for (i=0;i<spawners.size;i++)
		spawners[i].count = 1;
		
	if (isdefined (spawnThink))
		array_thread(spawners, ::spawnSquadPostspawn, spawnThink);
	
	for (;;)
	{
		if (getaiarray().size > 30)
		{
			wait (0.5);
			continue;
		}

		hasCount = false;
		for (i=0;i<spawners.size;i++)
		{
			spawner = spawners[i];
			if (!spawner.count)
				continue;
				
			hasCount = true;
			spawner.origin = level.deck[level.deckIndex].origin;
			spawn = spawner dospawn();
			if (!spawn_failed(spawn))
				spawn.targetname = spawner.targetname;
				
			wait (0.15);
			level.deckIndex++;
			if (level.deckIndex >= level.deck.size)
				level.deckIndex = 0;
		}
		
		if (!hasCount)
			break;
	}
}

spawnSquadPostspawn (spawnThink)
{
	self notify ("new_squad_think");
	self endon ("new_squad_think");
	
	self waittill ("spawned", spawn);
	if (spawn_failed(spawn))
	{
		assert (0, "Spawn failed somehow");
		return;
	}
	spawn [[spawnThink]]();
}


floodSquad(spawnThink)
{
	// Flood spawn guys from special "deck" script_origins and run "spawnthink" function on them if there is one.
	self endon ("death");		
	if (isdefined (spawnThink))
		self thread spawnSquadPostspawn(spawnThink);
	
	while (self.count)
	{
		if (getaiarray().size > 30)
		{
			wait (0.5);
			continue;
		}
		self.origin = level.deck[level.deckIndex].origin;
		level.deckIndex++;
		if (level.deckIndex >= level.deck.size)
			level.deckIndex = 0;

		spawn = self dospawn();
		if (!spawn_failed(spawn))
		{
			spawn.targetname = self.targetname;
			spawn waittill ("death");
			continue;
		}
		wait (0.15);
	}
}

anim_single_solo (guy, anime, tag, node, tag_entity)
{
	newguy[0] = guy;
	maps\_anim::anim_single (newguy, anime, tag, node, tag_entity);
}


music()
{
	wait 0.1;
	musicplay("soviet_datestamp_ominous01");
}

hideObjectiveExplosives()
{
	triggerOff();
	array_thread (getentarray(self.target,"targetname"), ::hideExplosives);
	flag_wait("show_explosives");
	triggerOn();
	self setHintString (&"SCRIPT_PLATFORM_HINTSTR_PICKUPEXPLOSIVES");
}

hideExplosives()
{
	self hide();
//	flag_wait("show_explosives");
	self show();
	flag_wait("show_explosives");
	bomb = spawn("script_model", (0,0,0));
	bomb setmodel(level.bombModelobj);
	bomb.origin = self.origin;
	bomb.angles = self.angles;
	flag_wait("delete_explosives");
	thread playsoundinspace ("stickybomb_pickup", bomb.origin);
	bomb delete();
	self delete();
}


tester()
{
	for (;;)
	{
		thread playsoundinspace ("stickybomb_plant", level.player.origin);
		wait (randomfloat(2));
	}
}

volskyHelpChatTrigger()
{
	level.end_tank endon ("disabled");
	wait (2);
	level.volsky anim_single_solo (level.volsky, "satchel");
	self waittill ("trigger");
	// "Vasili! Let's go! We can use your satchel charges to take out that Panzer!"
	level.volsky anim_single_solo (level.volsky, "attack_side");
	wait (3);
	level.volsky anim_single_solo (level.volsky, "take_cover");
}

crazyLine(msg)
{
	level.crazy anim_single_solo (level.crazy, msg);
}

friendlyHintThink()
{
	self endon ("death");
	while (distance(level.player.origin, self.origin) > 300)
		wait (0.2);
	
	node = getnode ("hint_destination_node","targetname");
	self setgoalnode (node);
	self.goalradius = 500;
}

friendlyAssistTrigger()
{
	level endon ("stop_friendly_assist_trigger");
	self waittill ("trigger");
	node = getnode (self.target,"targetname");
	level.volsky setgoalnode (node);
	level.volsky.goalradius = node.radius;
}

friendliesHintObjective()
{
	// kill off an AI in the front lines so a new one spawns and runs in and shows the player the way
	level endon ("defend_begins");
	org_max = getent("hint_origin","targetname").origin[1];
	org_min = getent("hint_min_origin","targetname").origin[1];
	
	for (;;)
	{
		wait (1);
		if (level.player.origin[1] > org_max)
			continue;
		if (level.player.origin[1] < org_min)
			continue;
		ai = getentarray("rifleguy","script_noteworthy");
		guy = undefined;
		for (i=0;i<ai.size;i++)
		{
			if (ai[i].origin[1] < org_max + 100)
				continue;
			guy = ai[i];
			break;
		}
		if (!isdefined(guy))
			continue;
		ai[i] delete();
		wait (12 + randomfloat(8));
	}
}

moveVolskyIn()
{
	// volsky follows the player if the player has run past the escort triggers before they were enabled
	if (isdefined(level.smgguy) && level.smgguy == level.volsky)
		return;
			
	level.volsky setgoalentity (level.player);
}

south_chain_trigger()
{
	node = getnode (self.target,"targetname");
	self waittill ("trigger");
	level.player setfriendlychain(node);
}


waittillNortheastCleared_orTimer(timer)
{
	level endon ("event_north_complete");
	level thread eventNotify(timer);
	objEvent = getObjEvent("northeast_defend");
	objEvent waittill_objectiveEvent();
}

eventNotify(timer)
{
	wait (timer);
	level notify ("event_north_complete");
}

wait_until_player_is_touching_window_trigger()
{
	trigger = getent ("player_moveup_detection","targetname"); 
	while (!level.player istouching(trigger))
		wait (randomfloat(1.2)); // random so they dont start talking the very moment you step up
}

touchingDebug()
{
	if (!isdefined(level.debugOffset))
		level.debugOffset = 0;
	offset = level.debugOffset;
	level.debugOffset++;

	note = getnode(self.targetname,"target").script_noteworthy;
	for (;;)
	{
		ai = getaiarray("axis");
		for (i=0;i<ai.size;i++)
		{
			if (ai[i] istouching(self))
				print3d(ai[i].origin + (0,0,50 + offset*10), note, (1,0.3,1),4);
		}
		wait (0.05);
	}
}

apartment_three_override()
{
	self waittill ("trigger");
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if (!isdefined(ai[i].script_deathchain))
			continue;
		if (ai[i].script_deathchain != 1)
			continue;
		ai[i] setgoalentity (level.player);
		ai[i].goalradius = 250;
		ai[i] thread die_eventually();
	}
}

die_eventually()
{
	if (!isalive(self))
		return;
		
	self endon ("death");
	wait (10 + randomfloat(10));
	self dodamage(self.health, self.origin);
}
	
