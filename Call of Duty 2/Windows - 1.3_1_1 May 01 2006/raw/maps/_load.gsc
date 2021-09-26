#include maps\_utility;
main()
{
/#
	star (4 + randomint(4));
#/
	// Germans pull it out currently
	precacheItem("luger");
	/#
//	precacheModel("xmodel/character_british_rainvillers_paul");
	#/
	
	if (getcvar("start") == "")
		setcvar("start", "start");

	if (getcvar("debug") == "")
		setcvar("debug", "0");

	if (getcvar("chain") == "")
		setcvar("chain", "0");
	
	if (getcvar("introscreen") == "")
		setcvar("introscreen", "1");
	
	if (getcvar("skipmission") == "")
		setcvar("skipmission", "0");

	if (getcvar("fallback") == "")
		setcvar("fallback", "0");

	if (getcvar("angles") == "")
		setcvar("angles", "0");

	if (getcvar("noai") == "")
		setcvar("noai", "off");
		
	if (getcvar("meteors") == "")
		setcvar("meteors", "0");

	level.lastAutoSaveTime = 0;
	level.default_run_speed = 190;
	setsavedcvar("g_speed", level.default_run_speed );
	level.script = tolower(getcvar ("mapname"));
	if (level.script != "credits")
		setsavedcvar("sv_saveOnStartMap", true );
	
	if (getcvar("tweak") == "" || getcvar("tweak") == "0")
		setcvar("tweak", "0");
	else
		thread tweakfog();

	if (!isdefined (level.scr_special_notetrack))
		level.scr_special_notetrack = [];
	if (!isdefined (level.scr_notetrack))
		level.scr_notetrack = [];
	if (!isdefined (level.scr_face))
		level.scr_face = [];
	if (!isdefined (level.scr_look))
		level.scr_look = [];
	if (!isdefined (level.scrsound))
		level.scrsound = [];
	if (!isdefined (level.scr_text))
		level.scr_text = [];
	if (!isdefined (level.missionfailed))
		level.missionfailed = false;
	if (!isdefined (level.ambient_reverb))
		level.ambient_reverb = [];
	if (!isdefined (level.fxfireloopmod))
		level.fxfireloopmod = 1;

	// used to change the meaning of interior/exterior/rain ambience midlevel.
	level.ambient_modifier["interior"] = "";
	level.ambient_modifier["exterior"] = "";
	level.ambient_modifier["rain"] = "";
	anim.useFacialAnims = false;

	/#
	thread lastSightPosWatch();
	thread camera();
	#/
//	insure_node_sanctity(); // Insures that any node with a target is not targetting something that doesnt exist.

	level.teleport = 1;
	level.scr_anim[0][0] = 0;

	player = getent("player", "classname" );
	level.player = player;

	level.isSaving = false;

//	if (!level.xenon)
//		level.player enableHealthShield( false );
	

	level.player.maxhealth = level.player.health;
	level.player.shellshocked = false;
	level.aim_delay_off = false;
	level.player.inWater = false;
	
//	thread debugText();

	// testing shellshock when player dies
	level.player thread maps\_utility::shock_ondeath();
//	level.player thread shock_onpain();

/#
	precachemodel ("xmodel/fx");
	precachemodel ("xmodel/temp");
#/	
	precacheShellshock("victoryscreen");
	precacheShellshock("default");
	precacheRumble("damage_heavy");
	precacheRumble("damage_light");
	
	//debug only - could remove this and scripts where it's used for release if we wanted
	//precacheString(&"DEBUG_DRONES");
	//precacheString(&"DEBUG_ALLIES");
	//precacheString(&"DEBUG_AXIS");
	//precacheString(&"DEBUG_VEHICLES");
	//precacheString(&"DEBUG_TOTAL");
	precachestring(&"GAME_GET_TO_COVER");
	precachestring(&"SCRIPT_GRENADE_DEATH");
	precacheShader("hud_grenadeicon");
	precacheShader("hud_grenadepointer");
	


	// stopwatch timer when you plant explosives
	maps\_gameskill::setSkill();
	

	setupExploders();
	setupPortableMG42s();
	
	level.createFX_enabled = (getcvar("createfx") != "");
	if (level.createFX_enabled)
		maps\_createfx::createfx();
	if (getcvar("g_connectpaths") == "2")
		level waittill ("eternity");

	println  ("level.script: ", level.script);
	// If a level does blood in script it needs to change the blood to dust if the menu cvar changes.
	if ((level.script == "stalingrad") || (level.script == "redsquare"))
		level thread bloodOrDustMenuSetting();

	maps\_art::main();
	maps\_loadout::init_loadout();
	
	setsavedcvar("ui_campaign", level.campaign); // level.campaign is set in maps\_loadout::init_loadout

	maps\_mg42::setDifficulty();
	array_thread(getentarray("misc_turret","classname"), maps\_mg42::mg42_target_drones);
	maps\_vehicle::main();
	
	thread maps\_quotes::setDeadQuote();
	thread maps\_quotes::setVictoryQuote();

	thread maps\_minefields::minefields();
	thread maps\_shutter::main();

	thread maps\_inventory::main();

	maps\_sounds::main();

	thread maps\_autosave::beginingOfLevelSave();
	thread maps\_introscreen::main();
	thread maps\_hardpoint::friendlyReinforcements();
	thread maps\_spawner::roamingReinforcements();

	thread maps\_endmission::main();

	thread meteors();

	maps\_waypoint::squads();
	maps\_groupMove::main();
	

	// For _anim to track what animations have been used. Uncomment this locally if you need it.
//	thread usedAnimations();

	array_levelthread (getentarray ("infinite panzerfaust","targetname"), ::infinite_panzerfaust, "panzerfaust");
	array_levelthread (getentarray ("infinite panzerschreck","targetname"), ::infinite_panzerfaust, "panzerschreck");
	array_levelthread (getentarray ("badplace","targetname"), ::badplace_think);
	array_thread(getnodearray("traverse","targetname"), ::traverseThink);
	array_thread (getentarray ("piano_key","targetname"), ::pianoThink);
	array_thread (getentarray ("piano_damage","targetname"), ::pianoDamageThink);
	
	array_thread (getentarray ("water","targetname"), ::waterThink);
	array_thread (getentarray ("lantern_glowFX_origin","targetname"), ::lampglowfx);
	
	thread maps\_interactable_objects::main();
	
	// No health on hard.
	// No health on any level now!
//	if (getcvar ("g_gameskill") == "3")
	{
		health = getentarray ("item_health","classname");
		for (i=0;i<health.size;i++)
			health[i] delete();
		health = getentarray ("item_health_large","classname");
		for (i=0;i<health.size;i++)
			health[i] delete();
		health = getentarray ("item_health_small","classname");
		for (i=0;i<health.size;i++)
			health[i] delete();

		level.player setnormalhealth (1);
	}
	thread maps\_gameskill::playerHealthRegen();
	thread playerDamageRumble();
	//thread playerDamageShellshock();
	thread player_death_grenade_hint();
	
	//****************************************************************************
	//   This handles printing out FX entities for exporting to _fx.gsc files.
	//****************************************************************************
	models = getentarray ("script_model","classname");
	if (getcvar("debug") == "1")
	{
		for (i=0;i<6;i++)
			println ("");
		println ("------------------- Models to Script -------------------");
		for (i=0;i<models.size;i++)
		{
			if (isdefined (models[i].script_fxid))
				models[i] maps\_fx::script_print_fx();
		}
		println ("------------------ End Models to Script ------------------");
		for (i=0;i<6;i++)
			println ("");

		println ("------------------- Script to Models -------------------");
	}

	for (i=0;i<models.size;i++)
	{

	//****************************************************************************
	//   This handles setting up grenade powerups
	//****************************************************************************
		if (isdefined (models[i].model))
		{
			if (models[i].model == "xmodel/ammo_stielhandgranate1")
				models[i] thread maps\_load::setup_grenade_powerups();
			else if (models[i].model == "xmodel/ammo_stielhandgranate2")
				models[i] thread maps\_load::setup_grenade_powerups();
		}

		if (isdefined (models[i].script_fxid))
			models[i] maps\_fx::setup_fx();
	}


	//****************************************************************************
	//   This handles setting up infinite ammo panzerfausts and panzerschrecks
	//****************************************************************************
	thread infinite_panzerfaust_think("panzerfaust");
	thread infinite_panzerfaust_think("panzerschreck");

	//****************************************************************************
	//   This handles setting up guys dieing from tanks
	//****************************************************************************
	ai = getaiarray();
	for(i=0;i<ai.size;i++)
	{
		ai[i] thread maps\_spawner::tanksquish();
	}


	//****************************************************************************
	//	This handles printing out exportable entity info for putting exports back
	//	into the .map file.
	//****************************************************************************
	if (getcvar("debug") == "1")
	{
		println ("------------------ End Script to Models ------------------");
		print_exportable_ents();
	}

	thread massNodeInitFunctions();
	
	// Catch trigger_friendlychain problems
	triggers = getentarray ("trigger_friendlychain","classname");

	for (i=0;i<triggers.size;i++)
	if (isdefined (triggers[i].target))
	{
		ent = getnodearray (triggers[i].target, "targetname");
		if (ent.size == 0)
		{
			ent = getentarray (triggers[i].target, "targetname");
			if (ent.size == 0)
				println ("!!!!!!!!! Nothing has targetname ", triggers[i].target);
		}
		else
		if (ent.size == 1)
		{
			if (!isdefined (ent[0].target))
			{
				temp_ent = getnodearray (ent[0].targetname, "target");
				if (temp_ent.size == 0)
					println ("!!!!!!!!! Friendlychain ", ent[0].targetname, " is only one node long!!");
			}
			else
			{
				targ = ent[0].target;
				ent = getnodearray (ent[0].target, "targetname");
				if (ent.size == 0)
					println ("!!!!!!!!! Friendlychain ", targ, " is only one node long!");
			}
		}
	}

	// Various newvillers globalized scripts
	flag_clear("spawning_friendlies");
	flag_set ("friendly_wave_spawn_enabled");
	
	level.friendly_spawner["rifleguy"] = getentarray ("rifle_spawner","script_noteworthy");			
	level.friendly_spawner["smgguy"] = getentarray ("smg_spawner","script_noteworthy");
	thread maps\_spawner::goalVolumes();
	thread maps\_spawner::friendlyChains();
	thread maps\_spawner::friendlychain_onDeath();

	array_thread (getentarray("objective_event","targetname"), maps\_utility::objectiveEventThink);
	array_thread (getentarray("ally_spawn", "targetname"), maps\_spawner::squadThink);
	array_thread (getentarray("friendly_spawn","targetname"), maps\_spawner::friendlySpawnWave);
	array_thread (getentarray("flood_and_secure", "targetname"), maps\_spawner::flood_and_secure);
	array_thread (getentarray("escortchain", "targetname"), maps\_spawner::escortChain);
	array_thread (getentarray("escortchain_instant", "targetname"), maps\_spawner::escortChainInstant);
	
	// Do various things on triggers
	
	array_levelthread(getentarray("triggeronce","script_noteworthy"),::triggeronce);
	array_thread(getentarray("ambient_volume","targetname"),::ambientVolume);

	level._max_script_health = 0;
	for (p=0;p<6;p++)
	{
		switch (p)
		{
			case 0:
				triggertype = "trigger_multiple";
				break;

			case 1:
				triggertype = "trigger_once";
				break;

			case 2:
				triggertype = "trigger_use";
				break;
				
			case 3:	
				triggertype = "trigger_radius";
				break;
			
			case 4:	
				triggertype = "trigger_lookat";
				break;

			default:
				assert(p == 5);
				triggertype = "trigger_damage";
				break;
		}

		triggers = getentarray (triggertype,"classname");
		for (i=0;i<triggers.size;i++)
		{
			if (isdefined (triggers[i].script_increment))
				level thread maps\_spawner::increment(triggers[i]);

			if (isdefined (triggers[i].target))
				level thread maps\_spawner::trigger_spawn(triggers[i]);

			if (isdefined (triggers[i].script_autosave))
				level thread maps\_autosave::autosaves_think(triggers[i]);

			if (isdefined (triggers[i].script_autosavename))
				level thread maps\_autosave::autoSaveNameThink(triggers[i]);

			if (isdefined (triggers[i].script_fallback))
				level thread maps\_spawner::fallback_think(triggers[i]);

			if (isdefined (triggers[i].script_mg42auto))
				level thread maps\_mg42::mg42_auto(triggers[i]);

			if (isdefined (triggers[i].script_killspawner))
				level thread maps\_spawner::kill_spawner(triggers[i]);

			if (isdefined (triggers[i].script_emptyspawner))
				level thread maps\_spawner::empty_spawner(triggers[i]);

			if (isdefined (triggers[i].script_kill_chain))
				level thread maps\_load::kill_chain(triggers[i]);

			if (isdefined (triggers[i].script_hint))
				level thread maps\_load::hint(triggers[i]);

			if (isdefined (triggers[i].script_exploder))
				level thread maps\_load::exploder_load(triggers[i]);

			if (isdefined (triggers[i].ambient))
				level thread maps\_load::ambient_thread(triggers[i]);

			if (isdefined (triggers[i].script_fxstart))
				level thread maps\_load::fxstart_thread(triggers[i]);

			if (isdefined (triggers[i].script_fxstop))
				level thread maps\_load::fxstop_thread(triggers[i]);
			
			if (isdefined (triggers[i].script_triggered_playerseek))
				level thread triggered_playerseek(triggers[i]);
				
			if (isdefined (triggers[i].script_bctrigger))
				level thread bctrigger(triggers[i]);
				
			if (isdefined (triggers[i].targetname))
			{
				if (triggers[i].targetname == "flood_spawner")
					level thread maps\_spawner::flood_trigger(triggers[i]);
				else
				if (triggers[i].targetname == "grenade_spawner")
					level thread maps\_spawner::grenade_trigger(triggers[i]);
				else
				if (triggers[i].targetname == "grenade_spawner_once")
					level thread maps\_spawner::grenade_trigger_once(triggers[i]);
				else
				if (triggers[i].targetname == "friendly_wave")
					level thread maps\_spawner::friendly_wave(triggers[i]);
				else
				if (triggers[i].targetname == "friendly_wave_off")
					level thread maps\_spawner::friendly_wave(triggers[i]);
				else
				if (triggers[i].targetname == "friendly_chat")
					level thread maps\_load::friendly_chat(triggers[i]);
				else
				if (triggers[i].targetname == "axis_touching")
					level thread maps\_load::axis_touching(triggers[i]);
				else
				if (triggers[i].targetname == "axis_dead")
					level thread maps\_load::axis_dead(triggers[i]);
				else
				if (triggers[i].targetname == "dead_autosave")
					level thread maps\_autosave::dead_autosave(triggers[i]);
				else
				if (triggers[i].targetname == "friendly_mg42")
					level thread maps\_spawner::friendly_mg42(triggers[i]);
				else
				if (triggers[i].targetname == "hopelesslylost")
					level thread hopelesslylost(triggers[i]);
			}
		}
	}

	//****************************************************************************
	//   connect auto AI spawners
	//****************************************************************************

	spawners = getspawnerarray();
	for (i = 0; i < spawners.size; i++)
	{
		spawner = spawners[i];
		if (!isdefined(spawner.targetname))
			continue;
		triggers = getentarray(spawner.targetname, "target");
		for (j = 0; j < triggers.size; j++)
		{
			trigger = triggers[j];
			switch (trigger.classname)
			{
			case "trigger_multiple":
			case "trigger_once":
			case "trigger_use":
			case "trigger_damage":
			case "trigger_radius":
			case "trigger_lookat":
				if (spawner.count)
					trigger thread doAutoSpawn(spawner);
				break;
			}
		}
	}

	//****************************************************************************


	maps\_spawner::main();

/#

	if (getdebugcvar("debug_corner") == "")
		setcvar("debug_corner", "off");
	else
	if (getdebugcvar("debug_corner") == "on")
		debug_corner();
	
	if (getcvar("chain") == "1")
		thread debugchains();
		
	/*
	if (getdebugcvar("debug_groupmove_createpath") == "")
		setcvar ("debug_groupmove_createpath", "off");
	else
	if (getdebugcvar("debug_groupmove_createpath") == "on")
		thread maps\_groupmove::generatePathFromPlayer();
	*/

	thread error_check();
#/
	thread debugCvars();

	thread maps\_utility::load_friendlies();
//	maps\prototype::prototype();

/#
	if (getcvar("skipmission") == "1")
		thread skipmission();
#/
}

/#
skipmission()
{
	level waittill ("introscreen_complete");
	wait ( 2.0 );
	maps\_endmission::nextmission();
}
#/

/#
error_check()
{
	wait (1);
	if ((level.script == "stalingrad") || (level.script == "stalingrad_nolight"))
		return;
	if (level.script == "duhoc_assault")
		return;
	mortars = getentarray ("mortar","targetname");
	if ((mortars.size > 0) && (!isdefined (level.mortar)))
		maps\_utility::error ("Add to map script: maps\_mortar::main();");
}

debugchains()
{
	nodes = getallnodes();
	fnodenum = 0;

	fnodes = [];
	for (i=0;i<nodes.size;i++)
	{
		if ((!(nodes[i].spawnflags & 2)) &&
		(
		((isdefined (nodes[i].target)) && ((getnodearray (nodes[i].target, "targetname")).size > 0)   ) ||
		((isdefined (nodes[i].targetname)) && ((getnodearray (nodes[i].targetname, "target")).size > 0) )
		)
		)
		{
			fnodes[fnodenum] = nodes[i];
			fnodenum++;
		}
	}

	count = 0;

	while (1)
	{
		if (getcvar("chain") == "1")
		{
			for (i=0;i<fnodes.size;i++)
			{
				if (distance (level.player getorigin(), fnodes[i].origin) < 1500)
				{
					print3d (fnodes[i].origin, "yo", (0.2, 0.8, 0.5), 0.45);
					/*
					count++;
					if (count > 25)
					{
						count = 0;
						maps\_spawner::waitframe();
					}
					*/
				}
			}

			friends = getaiarray ("allies");
			for (i=0;i<friends.size;i++)
			{
				node = friends[i] animscripts\utility::GetClaimedNode();
				if (isdefined (node))
					line (friends[i].origin + (0,0,35), node.origin, (0.2, 0.5, 0.8), 0.5);
			}

		}
		maps\_spawner::waitframe();
	}
}


star (total)
{
		println ("         ");
		println ("         ");
		println ("         ");
		for (i=0;i<total;i++)
		{
			for (z=total-i;z>1;z--)
			print (" ");
			print ("*");
			for (z=0;z<i;z++)
				print ("**");
			println ("");
		}
		for (i=total-2;i>-1;i--)
		{
			for (z=total-i;z>1;z--)
			print (" ");
			print ("*");
			for (z=0;z<i;z++)
				print ("**");
			println ("");
		}

		println ("         ");
		println ("         ");
		println ("         ");
}
#/

// If a level does blood in script it needs to change the blood to dust if the menu cvar changes.
bloodOrDustMenuSetting ()
{
	level._effect["flesh"] = loadfx ("fx/impacts/flesh_hit5g.efx");
	level._effect["flesh small"] = loadfx ("fx/impacts/flesh_hit.efx");
	level._effect["flesh"] = loadfx ("fx/impacts/large_gravel.efx");
	level._effect["flesh small"] = loadfx ("fx/impacts/small_gravel.efx");
	if (getcvar ("cg_blood") == "1")
	{
		level._effect["flesh"] = loadfx ("fx/impacts/large_gravel.efx");
		level._effect["flesh small"] = loadfx ("fx/impacts/small_gravel.efx");
		blood = false;
	}
	else
	{
		level._effect["flesh"] = loadfx ("fx/impacts/flesh_hit5g.efx");
		level._effect["flesh small"] = loadfx ("fx/impacts/flesh_hit.efx");
		blood = true;
	}
		
	while (1)
	{
		wait (2);
		if (blood)
		{
			if (getcvar ("cg_blood") == "1")
				continue;
			
			blood = false;
			level._effect["flesh"] = loadfx ("fx/impacts/large_gravel.efx");
			level._effect["flesh small"] = loadfx ("fx/impacts/small_gravel.efx");
		}
		else
		{
			if (getcvar ("cg_blood") == "0")
				continue;
			
			blood = true;
			level._effect["flesh"] = loadfx ("fx/impacts/flesh_hit5g.efx");
			level._effect["flesh small"] = loadfx ("fx/impacts/flesh_hit.efx");
		}
	}
}


ambient_thread(trigger)
{
	level.ambient = trigger.ambient;

//	trigger.wait = 0.05;
	while (1)
	{
		trigger waittill ("trigger");
		if (level.ambient != trigger.ambient)
			activateAmbient(trigger.ambient);

		while (trigger istouching (level.player))
			wait (0.05);
	}
}

ambientVolume()
{
	for (;;)
	{
		self waittill ("trigger");
		activateAmbient("interior");
		while (level.player istouching (self))
			wait (0.1);		
		activateAmbient("exterior");
	}
}

fxstart_thread(trigger)
{
	fxNum = trigger.script_fxstart;

	while (1)
	{
		trigger waittill ("trigger");
		level notify ("start fx" + fxNum);
	}
}

fxstop_thread(trigger)
{
	fxNum = trigger.script_fxstop;

	while (1)
	{
		trigger waittill ("trigger");
		level notify ("stop fx" + fxNum);
	}
}

get_highest_export (num, ents)
{
	for (i=0;i<ents.size;i++)
	{
		if ((isdefined (ents[i].export)) && (ents[i].export > num))
			num = ents[i].export;
	}

	return num;
}

print_exportable_ents()
{
	spawners = getspawnerarray ();
	ais = getaiarray ();
	mg42s = getentarray ("misc_mg42","classname");
	println ("total exportable ents ", ais.size + mg42s.size + spawners.size);

	level.highest_export = 0;
	level.highest_export = get_highest_export (level.highest_export, spawners);
	level.highest_export = get_highest_export (level.highest_export, ais);
	level.highest_export = get_highest_export (level.highest_export, mg42s);

	for (i=0;i<6;i++)
		println ("");

	println ("--------------- All exportable ents ---------------");
	maps\_utility::array_thread(spawners, ::print_exportable_ents_text);
	maps\_utility::array_thread(ais, ::print_exportable_ents_text);
	maps\_utility::array_thread(mg42s, ::print_exportable_ents_text);
	println ("------------- END All exportable ents -------------");

	for (i=0;i<6;i++)
		println ("");
}

print_keypair (string, var)
{
	if (!isdefined (var))
		return;

	println ("\"" + string + "\" \"" + var + "\"");
}

print_exportable_ents_text() // KEEP UP TO DATE ON SCRIPT KEYPAIRS
{
	if (!isdefined (self.export))
	{
		level.highest_export++;
		self.export = level.highest_export;
	}

	println ("{");
	println ("\"origin\" \"" + self.origin[0] + " " + self.origin[1] + " " + self.origin[2] + "\"");
	println ("\"angles\" \"" + self.angles[0] + " " + self.angles[1] + " " + self.angles[2] + "\"");
	print_keypair ("classname", self.classname);
	print_keypair ("spawnflags", self.spawnflags);
	print_keypair ("weaponinfo", self.weaponinfo);
	print_keypair ("health", self.health);
	print_keypair ("grabarc", self.grabarc);
	print_keypair ("harc", self.harc);
	print_keypair ("varc", self.varc);
	print_keypair ("damage", self.damage);
	if (isSentient (self))
		print_keypair ("accuracy", self.accuracy);

	print_keypair ("model", self.model);
	print_keypair ("script_health", self.script_health);
	print_keypair ("script_health_easy", self.script_health_easy);
	print_keypair ("groupname", self.groupname);
	print_keypair ("script_delete", self.script_delete);
	print_keypair ("script_increment", self.script_increment);
	print_keypair ("script_patroller", self.script_patroller);
	print_keypair ("target", self.target);
	print_keypair ("targetname", self.targetname);
	print_keypair ("script_autosave", self.script_autosave);
	if (isSentient (self))
		print_keypair ("name", self.name);
	print_keypair ("count", self.count);
	print_keypair ("script_delayed_playerseek", self.script_delayed_playerseek);
	print_keypair ("script_playerseek", self.script_playerseek);
	print_keypair ("script_seekgoal", self.script_seekgoal);
	print_keypair ("radius", self.radius);
	print_keypair ("script_start", self.script_start);
	print_keypair ("delay", self.delay);
	print_keypair ("script_radius", self.script_radius);
	print_keypair ("script_objective", self.script_objective);
	print_keypair ("script_followmin", self.script_followmin);
	print_keypair ("script_followmax", self.script_followmax);
	print_keypair ("script_friendname", self.script_friendname);
	print_keypair ("script_startinghealth", self.script_startinghealth);
	print_keypair ("script_accuracy", self.script_accuracy);
	print_keypair ("script_fallback", self.script_fallback);
	print_keypair ("script_grenades", self.script_grenades);
	print_keypair ("script_noteworthy", self.script_noteworthy);
	print_keypair ("script_moveoverride", self.script_moveoverride);
	print_keypair ("script_killspawner", self.script_killspawner);
	print_keypair ("script_mg42auto", self.script_mg42auto);
	print_keypair ("script_delay", self.script_delay);
	print_keypair ("script_delay_min", self.script_delay_min);
	print_keypair ("script_delay_max", self.script_delay_max);
	print_keypair ("script_burst_min", self.script_burst_min);
	print_keypair ("script_burst_max", self.script_burst_max);
	print_keypair ("script_path", self.script_path);
	print_keypair ("script_uniquename", self.script_uniquename);
	print_keypair ("script_turret", self.script_turret);
	print_keypair ("script_additive_delay", self.script_additive_delay);
	print_keypair ("script_chain", self.script_chain);
	print_keypair ("script_triggername", self.script_triggername);
	print_keypair ("script_min_friendlies", self.script_min_friendlies);
	print_keypair ("script_requires_player", self.script_requires_player);
	print_keypair ("script_kill_chain", self.script_kill_chain);
	print_keypair ("script_hint", self.script_hint);
	print_keypair ("script_sightrange", self.script_sightrange);
	print_keypair ("script_fxcommand", self.script_fxcommand);
	print_keypair ("script_fxid", self.script_fxid);
	print_keypair ("script_hidden", self.script_hidden);
	print_keypair ("vehicletype", self.vehicletype);
	print_keypair ("script_fallback_group", self.script_fallback_group);
	print_keypair ("script_exploder", self.script_exploder);
	print_keypair ("script_balcony", self.script_balcony);
	print_keypair ("script_personality", self.script_personality);

	print_keypair ("export", self.export);
	println ("}");
}

axis_touching ( trigger )
{
/#
	if (!isdefined (trigger.target))
		maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");
#/

	chatter = getent (trigger.target, "targetname");
	if (isdefined (chatter))
	{
/#
		if (chatter.team != "allies")
			maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");
#/

		if (!isdefined (chatter.kill_friendly_chat_triggers))
		{
			level thread kill_friendly_chat_triggers (chatter);
			chatter.kill_friendly_chat_triggers = true;
		}

		chatter endon ("death");
	}

	while (1)
	{
		trigger waittill ("trigger", other);
		if (trigger.spawnflags & 8)
		{
			if (isdefined (chatter))
			{
				if (other == chatter)
					break;
			}
			else
			if (other.team == "allies")
			{
				chatter = other;
				break;
			}
		}
		else
		if (other == level.player)
		{
			if (!isdefined (chatter))
			{
				chatter = maps\_utility::getClosestAI (level.player getorigin(), "allies");
				if (!isdefined (chatter))
					return;
			}
			break;
		}
	}

	enemies = getaiarray ("axis");
	for (i=0;i<enemies.size;i++)
	{
		if (trigger istouching (enemies[i]))
		{
			chatter thread anim_single_queue (chatter, trigger.script_noteworthy);
			if (trigger.script_noteworthy == "grenades")
			{
				chatter waittill ("grenades");
				wait (1.2);
				maps\_utility::keyHintPrint(&"SCRIPT_PLATFORM_HINT_SWITCHTOGRENADE", getKeyBinding("weaponslot grenade"));
			}
			else
			if (trigger.script_noteworthy == "get halftrack gunner")
			{
				chatter waittill ("get halftrack gunner");
				wait (1);
				thread hint_ADS();
			}
			break;
		}
	}
	trigger delete();
}

hint_ADS()
{
	binding = getKeyBinding("toggle cl_run");
	if(binding["count"])
	{
		/*
		maps\_utility::keyHintPrint(&"SCRIPT_PLATFORM_HINT_ADSKEY", binding);
		wait 3;
		maps\_utility::keyHintPrint(&"SCRIPT_PLATFORM_HINT_ADSSTOP", binding);
		*/
	}
	else
	{
		/*
		binding = getKeyBinding("+speed");
		if(binding["count"])
			maps\_utility::keyHintPrint(&"SCRIPT_PLATFORM_HINT_HOLDDOWNADSKEY", binding); 
		*/
	}
}

// Plays chat sound once all axis in the volume die
axis_dead ( trigger )
{
/#
	if (!isdefined (trigger.target))
		maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");
#/

	chatter = getent (trigger.target, "targetname");
	if (isdefined (chatter))
	{
/#
		if (chatter.team != "allies")
			maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");
#/

		if (!isdefined (chatter.kill_friendly_chat_triggers))
		{
			level thread kill_friendly_chat_triggers (chatter);
			chatter.kill_friendly_chat_triggers = true;
		}

		chatter endon ("death");
	}

	while (1)
	{
		trigger waittill ("trigger", other);
		if (trigger.spawnflags & 8)
		{
			if (isdefined (chatter))
			{
				if (other == chatter)
					break;
			}
			else
			if (other.team == "allies")
			{
				chatter = other;
				break;
			}
		}
		else
		if (other == level.player)
		{
			if (!isdefined (chatter))
			{
				chatter = maps\_utility::getClosestAI (level.player getorigin(), "allies");
				if (!isdefined (chatter))
					return;
			}
			break;
		}
	}

	enemies = getaiarray ("axis");
	touchers = [];
	for (i=0;i<enemies.size;i++)
	{
		if (enemies[i] istouching (trigger))
			touchers[touchers.size] = enemies[i];
	}

	ent = spawnstruct();
	enemies = getspawnerteamarray  ("axis");
	toucherSpawners = [];
	for (i=0;i<enemies.size;i++)
	{
		if (enemies[i].count <= 0)
			continue;

		if (enemies[i] istouching (trigger))
			toucherSpawners[toucherSpawners.size] = enemies[i];
	}
	ent.touchSpawners = toucherSpawners.size;
//	println ("spawners to die ", ent.touchSpawners);
	maps\_utility::array_thread(toucherSpawners, ::entToucherSpawnerThink, ent);

	while (1)
	{
		if (touchers.size > 0)
		{
//			println (touchers.size, " touchers left");
			touchers[0] waittill ("death");
//			println (touchers.size, " after death, touchers left");
			newtouchers = [];
			for (i=0;i<touchers.size;i++)
			{
				if (isalive (touchers[i]))
					newtouchers[newtouchers.size] = touchers[i];
			}
			touchers = newtouchers;
		}
		else
		if (ent.touchSpawners > 0)
		{
//			println (ent.touchSpawners, " touchspawners left");
			ent waittill ("spawn guy died");
//			println (ent.touchSpawners, " after death, touchspawners left");
		}
		else
			break;
	}

	wait (2); // Plays more natural if there's a pause before response
	animname = chatter.animname;
	chatter anim_single_queue (chatter, trigger.script_noteworthy);
	level notify (animname + " " + trigger.script_noteworthy);
	trigger delete();
}

entToucherSpawnerThink (ent)
{
	self waittill ("spawned", spawn);
	if (maps\_utility::spawn_failed(spawn))
	{
//		println ("spawn guy removed!");
		ent.touchSpawners--;
		ent notify ("spawn guy died");
		return;
	}
	spawn waittill ("death");
//	println ("spawn guy died!");
	ent.touchSpawners--;
	ent notify ("spawn guy died");
}

kill_chain (trigger)
{
	trigger waittill ("trigger");
	maps\_utility::chain_off (trigger.script_kill_chain);
	maps\_spawner::kill_trigger (trigger);
}

hint(trigger)
{
	trigger waittill ("trigger");
//	maps\_utility::keyHintPrint(&"SCRIPT_PLATFORM_HINT_MELEEATTACK", getKeyBinding("+melee"));
	maps\_spawner::kill_trigger (trigger);
}

friendly_chat ( trigger )
{
//	if (!isdefined (trigger.target))
//		maps\_utility::error ("Friendly_chat trigger at origin " + getbrushmodelcenter(trigger) + " doesn't target a friendly.");

	if (isdefined (trigger.target))
	{
		chatter = getent (trigger.target, "targetname");
		character_line = true;
	}
	else
	{
		chatter = undefined;
		character_line = false;
	}

	if (character_line)
	{
/#
		if (!isdefined (chatter))
			maps\_utility::error ("Friendly_chat trigger at origin " + trigger getorigin() + " doesn't target a living friendly.");

		if (chatter.team != "allies")
			maps\_utility::error ("Friendly_chat trigger at origin " + trigger getorigin() + " doesn't target a friendly.");
#/

		if (!isdefined (chatter.kill_friendly_chat_triggers))
		{
			level thread kill_friendly_chat_triggers (chatter);
			chatter.kill_friendly_chat_triggers = true;
		}

		chatter endon ("death");
	}
	else
	{
/#
		if (!isdefined (trigger.script_animname))
			maps\_utility::error ("Friendly_chat trigger at origin " + trigger getorigin() + " with no character target doesn't have a script_animname");
#/
	}

/*
	if (character_line)
		println ("^aChatter is ", chatter.targetname);
	else
		println ("^aChatter is anyone, animname is ", trigger.script_animname);
*/

	if (isdefined (trigger.script_waittill) )
		level waittill (trigger.script_waittill);

	while (1)
	{
		trigger waittill ("trigger", other);
//		println ("triggered by ", other);

		if (trigger.spawnflags & 8)
		{
			if (isdefined (chatter))
			{
				if (other == chatter)
					break;
				else
					continue;
			}

			if (!isdefined (other.animname))
				continue;

			if (other.animname != trigger.script_animname)
				continue;

			chatter = other;
			break;
		}
		else
		if (other == level.player)
		{
			if (isdefined (chatter))
				break;

//				println ("chatter to closest ai");
			possibleChatters = [];
			ai = getaiArray ("allies");
			for (i=0;i<ai.size;i++)
			{
				if (!isdefined (ai[i].animname))
					continue;

				if (ai[i].animname != trigger.script_animname)
					continue;

				possibleChatters[possibleChatters.size] = ai[i];
			}

			if (possibleChatters.size == 0)
				continue;

			ai = undefined;
			chatter = maps\_utility::getClosest (level.player getorigin(), possibleChatters);
			possibleChatters = undefined;
			if (isdefined (chatter))
				break;
		}
	}

	reason = "reason 0";

	if ((isdefined (trigger.script_min_friendlies)) ||  (isdefined (trigger.script_requires_player)) )
	{
		if (!isdefined (trigger.script_timer))
			timer = 0;
		else
			timer = gettime() + trigger.script_timer;

		breaker = false;
		while ((gettime() < timer) || (!timer))
		{
			breaker = true;
			if (isdefined (trigger.script_min_friendlies))
				maps\_utility::living_ai_wait_for_min (trigger, "allies", trigger.script_min_friendlies);

			if ((isdefined (trigger.script_requires_player)) && (!(chatter istouching (trigger))))
			{
				reason = "reason 1";
				breaker = false;
			}

			if ((trigger.spawnflags & 8) && (!(chatter istouching (trigger))))
			{
				reason = "reason 2";
				breaker = false;
			}

			if (breaker)
				break;

			wait (1);
		}

		if (!breaker)
		{
			println (reason);
			println ("Z:        chat wont play");
			trigger delete();
			return;
		}
	}

/*
	if (isalive (chatter))
		println ("chatter lives");
	else
		println ("chatter dies");

	if (character_line)
		println ("^aChatter is ", chatter.targetname);
	else
		println ("^aChatter is anyone");
*/


//	println ("chatter ", chatter, " doing anim ", trigger.script_noteworthy);
	chatter thread anim_single_queue (chatter, trigger.script_noteworthy);
	/*
	if (character_line)
		chatter thread anim_single_queue (chatter, trigger.script_noteworthy);
	else
	{
		if (!isdefined (chatter.animname))
		{
			println ("chatter had no animname");
			return;
		}
		if (chatter.animname != trigger.script_animname)
		{
			println ("chatter with aninname ", chatter.animname, " didn't have animname generic");
			return;
		}

		chatter thread anim_single_queue (chatter, trigger.script_noteworthy);
	}
	*/
/*
	else
	{
		maps\_utility::playSoundinSpace (alias, origin)
		chatter playsound (level.scr_anim[trigger.script_noteworthy]["anyone"]["sound"][0]);
		println ("^bPlayed friendly chat sound " + level.scr_anim[trigger.script_noteworthy]["anyone"]["sound"][0]);
	}
*/

/*
	if (isdefined (trigger.script_noteworthy))
	{
		if (trigger.script_noteworthy == "flak")
			maps\_utility::keyHintPrint(&"SCRIPT_PLATFORM_HINT_PLANTEXPLOSIVES", getKeyBinding("+activate"));
		else
		if (trigger.script_noteworthy == "base of fire")
		{
			chatter waittill ("base of fire");
			wait (1);
			iprintlnbold (&"SCRIPT_HINT_OBJECTIVEONCOMPASS");
			wait (5);
			maps\_utility::keyHintPrint(&"SCRIPT_PLATFORM_HINT_OBJECTIVEKEY", getKeyBinding("+scores"));			
		}
	}
*/	
	trigger delete();
}

kill_friendly_chat_triggers (chatter)
{
	name = chatter.targetname;
	chatter waittill ("death");
	for (p=0;p<4;p++)
	{
		switch (p)
		{
			case 0:
				triggertype = "trigger_multiple";
				break;

			case 1:
				triggertype = "trigger_once";
				break;

			case 2:
				triggertype = "trigger_use";
				break;

			case 3:
				triggertype = "trigger_radius";
				break;

			default:
				assert(p == 3);
				triggertype = "trigger_damage";
				break;
		}

		triggers = getentarray (triggertype,"classname");
		for (i=0;i<triggers.size;i++)
		{
			if (!isdefined (triggers[i].targetname))
				continue;
				
			if (triggers[i].targetname != "friendly_chat")
				continue;
				
			if (!isdefined (triggers[i].target))
				continue;
				
			if (triggers[i].target == name)
				triggers[i] delete();
		}
	}
}

exploder_load (trigger)
{
	level endon ("killexplodertridgers"+trigger.script_exploder);
	trigger waittill ("trigger");
	if(isdefined(trigger.script_chance) && randomfloat(1)>trigger.script_chance)
	{
		if(isdefined(trigger.script_delay))
			wait trigger.script_delay;
		else
			wait 4;
		level thread exploder_load(trigger);
		return;
	}
	maps\_utility::exploder (trigger.script_exploder);
	level notify ("killexplodertridgers"+trigger.script_exploder);
}

camera()
{
	wait (0.05);
	cameras = getentarray ("camera","targetname");
	for (i=0;i<cameras.size;i++)
	{
		ent = getent (cameras[i].target,"targetname");
		cameras[i].origin2 = ent.origin;
		cameras[i].angles = vectortoangles(ent.origin - cameras[i].origin);
	}
	for (;;)
	{
		/#
		if (getdebugcvar ("camera") != "on")
		{
			if (getdebugcvar ("camera") != "off")
				setcvar ("camera", "off");
			wait (1);
			continue;
		}
		#/
		
		ai = getaiarray ("axis");
		if (!ai.size)
		{
			freePlayer();
			wait (0.5);
			continue;
		}
		cameraWithEnemy = [];
		for (i=0;i<cameras.size;i++)
		{
			for (p=0;p<ai.size;p++)
			{
				if (distance(cameras[i].origin, ai[p].origin) > 256)
					continue;
				cameraWithEnemy[cameraWithEnemy.size] = cameras[i];
				break;
			}
		}
		if (!cameraWithEnemy.size)
		{
			freePlayer();
			wait (0.5);
			continue;
		}

		cameraWithPlayer = [];
		for (i=0;i<cameraWithEnemy.size;i++)
		{
			camera = cameraWithEnemy[i];
			
			start = camera.origin2;
			end = camera.origin;
			difference = vectorToAngles((end[0],end[1],end[2]) - (start[0],start[1],start[2]));
			angles = (0, difference[1], 0);
		    forward = anglesToForward(angles);
		
			difference = vectornormalize(end - level.player.origin);
			dot = vectordot(forward, difference);
			if (dot < 0.85)
				continue;
				
			cameraWithPlayer[cameraWithPlayer.size] = camera;
		}
		
		if (!cameraWithPlayer.size)
		{
			freePlayer();
			wait (0.5);
			continue;
		}
		
		dist = distance(level.player.origin, cameraWithPlayer[0].origin);
		newcam = cameraWithPlayer[0];
		for (i=1;i<cameraWithPlayer.size;i++)
		{
			newdist = distance(level.player.origin, cameraWithPlayer[i].origin);
			if (newdist > dist)
				continue;
			
			newcam = cameraWithPlayer[i];
			dist = newdist;
		}
		
		setPlayerToCamera(newcam);
		wait (3);
	}
}
	
freePlayer()
{
	setcvar ("cl_freemove","0");
}

setPlayerToCamera(camera)
{
	setcvar ("cl_freemove","2");
	setdebugangles (camera.angles);
	setdebugorigin (camera.origin + (0,0,-60));
}
/*
	maps\_spawner::waitframe();
	thread anglescheck();

	if (!isdefined (level.camera))
		return;

//	wait (1);
	mintime = 0;
	linker = false;
	while(getcvar ("camera") == "on")
	{
		for (i=0;i<level.camera.size;i++)
		{
			if (getcvar ("camera") != "on")
				break;

			setcvar("nextcamera", "on");
			setcvar("lastcamera", "on");

			level.player setorigin (level.camera[i].origin);
			level.player linkto (level.camera[i]);

			level.player setplayerangles (level.camera[i].angles);

			timer = gettime() + 10000;
			if (timer < mintime)
				timer = mintime;

			oldorigin = level.player getorigin();
			while (gettime() < timer)
			{
				if (gettime() > timer - 8000)
				if ((gettime() > mintime) && (distance (level.player getorigin(), oldorigin) > 128))
				{
					mintime = gettime() + 500000;
					timer = mintime;
				}

				if (getcvar ("camera") != "on")
					break;

				if (getcvar ("nextcamera") == "1")
					break;

				if (getcvar ("lastcamera") == "1")
				{
					i-=2;
					if (i < 0)
						i+=level.camera.size;
					break;
				}

				maps\_spawner::waitframe();
			}

			if ((getcvar ("nextcamera") == "1") || (getcvar ("lastcamera") == "1"))
				mintime = gettime() + 500000;
		}
	}

	if (linker)
		level.player unlink();
}
*/

anglescheck()
{
	while (1)
	{
		if (getcvar ("angles") == "1")
		{
			println ("origin " + level.player getorigin());
			println ("angles " + level.player.angles);
			setcvar("angles", "0");
		}
		wait (1);
	}
}

// Since getspawnerarray was broken, the size test on it was always returning true.
// Plus the getallnodes call was wasting script variables, due to touching all nodes.
/*
insure_node_sanctity()
{
	overall_sanctity = true;
	nodes = getallnodes();
	for (i=0;i<nodes.size;i++)
	{
		if (isdefined (nodes[i].target))
		{
			sanctity = false;
			test = getnodearray (nodes[i].target,"targetname");
			if (test.size)
				sanctity = true;

			test = getentarray (nodes[i].target,"targetname");
			if (test.size)
				sanctity = true;

			test = getspawnerarray (nodes[i].target,"targetname");
			if (test.size)
				sanctity = true;

			test = getvehiclenodearray (nodes[i].target,"targetname");
			if (test.size)
				sanctity = true;

			if (!sanctity)
			{
				println ("Node at origin ", nodes[i].origin, " has a .target but there is nothing with that .targetname");
				overall_sanctity = false;
			}
		}
	}

	if (!overall_sanctity)
		maps\_utility::error ("Error message above, scroll up");
}
*/

infinite_panzerfaust_think(weaponName)
{
	weapons = get_infinite_panzerfausts(weaponName);
	if (weapons.size < 1)
	{
		println("no infinite " + weaponName + " found");
		return;
	}

	locations = [];
	for (i=0; i<weapons.size; i++)
	{
		println("infinite " + weaponName + " found");
		if (isdefined (weapons[i].target))
		{
			locations[i] = getent (weapons[i].target, "targetname");
			locations[i].angles = weapons[i].angles;
		}
		else
		{
			locations[i] =  spawn ("script_origin", weapons[i].origin);
			locations[i].angles = weapons[i].angles;
		}
	}
	while (1)
	{
		wait 3;
		weapons = get_infinite_panzerfausts(weaponName);
		if (weapons.size < locations.size)
		{
			level notify ("picked up infinite " + weaponName);
			for (i=0; i<locations.size; i++)
			{
				new_weapon = spawn ("weapon_" + weaponName, locations[i].origin);
				new_weapon.angles = locations[i].angles;
				new_weapon.targetname = "respawn";
			//	iprintln ("spawning");
			}
			wait .3;
			for (i=0; i<weapons.size; i++)
			{
				weapons[i] delete ();
			//	iprintln ("deleting");
			}
		}
	}
}

get_infinite_panzerfausts(weaponName)
{
	weapons = [];
	temp = getentarray ("weapon_" + weaponName, "classname");
	for (i=0; i<temp.size; i++)
	{
		if ( (isdefined (temp[i].targetname) ) && (temp[i].targetname == "respawn") )
			weapons = maps\_utility::add_to_array ( weapons, temp[i] );
	}
	return weapons;
}

setup_grenade_powerups()
{
/*
	if (self.model == "xmodel/ammo_stielhandgranate1")
	{
		precacheItem("item_ammo_stielhandgranate_open");
		item = spawn("item_ammo_stielhandgranate_open", self.origin + (0, 0, 1), 1); // suspended
	}
	else
	{
		assert(self.model == "xmodel/ammo_stielhandgranate2");
		precacheItem("item_ammo_stielhandgranate_closed");
		item = spawn("item_ammo_stielhandgranate_closed", self.origin + (0, 0, 1), 1); // suspended
	}

	item.angles = self.angles;
*/
	wait 1;

	if(isdefined (self.target))
	{
		trigger = getent(self.target, "targetname");
		if(isdefined(trigger))
			trigger delete();
	}

	self delete();
}

doAutoSpawn(spawner)
{
	spawner endon("death");
	self endon("death");

	for (;;)
	{
		self waittill("trigger");
		if (!spawner.count)
			return;
		if (self.target != spawner.targetname)
			return; // manually disconnected
		if (isdefined(spawner.triggerUnlocked))
			return; // manually disconnected
		guy = spawner doSpawn();
		if (spawn_failed(guy))
			spawner notify ("spawn_failed");
		if (isdefined(self.Wait) && (self.Wait > 0))
			wait(self.Wait);
	}
}

shock_onpain()
{
	precacheShellshock("pain");
	precacheShellshock("default");
	level.player endon ("death");
	if (getcvar("blurpain") == "")
		setcvar("blurpain", "on");

	while (1)
	{
		oldhealth = level.player.health;
		level.player waittill ("damage");
		if (getcvar("blurpain") == "on")
		{
//			println ("health dif was ", oldhealth - level.player.health);
			if (oldhealth - level.player.health < 129)
			{
				//level.player shellshock("pain", 0.4);
			}
			else
			{
				level.player shellshock("default", 5);
			}
		}
	}
}

dolly ()
{
	if (!isdefined (level.dollyTime))
		level.dollyTime = 5;
	setcvar ("dolly", "");
	thread dollyStart();
	thread dollyEnd();
	thread dollyGo();
}

dollyStart()
{
	while (1)
	{
		if (getcvar ("dolly") == "start")
		{
			level.dollystart = level.player.origin;
			setcvar ("dolly", "");
		}
		wait (1);
	}
}

dollyEnd()
{
	while (1)
	{
		if (getcvar ("dolly") == "end")
		{
			level.dollyend = level.player.origin;
			setcvar ("dolly", "");
		}
		wait (1);
	}
}

dollyGo()
{
	while (1)
	{
		wait (1);
		if (getcvar ("dolly") == "go")
		{
			setcvar ("dolly", "");
			if (!isdefined (level.dollystart))
			{
				println ("NO Dolly Start!");
				continue;
			}
			if (!isdefined (level.dollyend))
			{
				println ("NO Dolly End!");
				continue;
			}

			org = spawn ("script_origin",(0,0,0));
			org.origin = level.dollystart;
			level.player setorigin (org.origin);
			level.player linkto (org);

			org moveto (level.dollyend, level.dollyTime);
			wait (level.dollyTime);
			org delete();
		}
	}
}


usedAnimations ()
{
	setcvar ("usedanim", "");
	while (1)
	{
		if (getcvar("usedanim") == "")
		{
			wait(2);
			continue;
		}

		animname = getcvar("usedanim");
		setcvar ("usedanim", "");

		if (!isdefined (level.completedAnims[animname]))
		{
			println ("^d---- No anims for ", animname,"^d -----------");
			continue;
		}

		println ("^d----Used animations for ", animname,"^d: ", level.completedAnims[animname].size, "^d -----------");
		for (i=0;i<level.completedAnims[animname].size;i++)
			println (level.completedAnims[animname][i]);
	}
}

// Infinite panzerfausts!
infinite_panzerfaust ( trigger , weaponName )
{
	weaponObj = undefined;
	boxObj = undefined;
	models = getentarray (trigger.target,"targetname");
	slotSpots = [];
	for (i=0;i<models.size;i++)
	{
		if (models[i].model == "xmodel/weapon_panzerfaust_objective")
		{
			weaponObj = models[i];
			weaponObj setmodel ("xmodel/weapon_panzerfaust");
			continue;
		}
		else
		if (models[i].model == "xmodel/weapon_panzerschreck")
		{
			weaponObj = models[i];
			weaponObj setmodel ("xmodel/weapon_panzerschreck");
			continue;
		}
		else
		if (models[i].model == "xmodel/weapon_panzerfaust")
		{
			weaponObj = models[i];
			weaponObj setmodel ("xmodel/weapon_panzerfaust");
			continue;
		}
		else
		if (models[i].model == "xmodel/ammo_panzerfaust_box2_objective")
		{
			boxObj = models[i];
			boxObj setmodel ("xmodel/ammo_panzerfaust_box2");
			continue;
		}
		else
		if (models[i].model == "xmodel/prop_crate_smallshipping1")
		{
			boxObj = models[i];
			boxObj setmodel ("xmodel/prop_crate_smallshipping1");
			continue;
		}
		else
		if (models[i].model == "xmodel/military_panzerfaust_box_empty")
		{
			boxObj = models[i];
			boxObj setmodel ("xmodel/military_panzerfaust_box_empty");
			continue;
		}
		

		slotSpots[slotSpots.size] = models[i];
	}
	models = undefined;

/#
	if (!isdefined (weaponObj))
		maps\_utility::error ("infinity panzers at " + trigger getorigin() + " has no weapon model");

	if (!isdefined (boxObj))
		maps\_utility::error ("infinity panzers at " + trigger getorigin() + " has no ammo box model");

	if (!slotSpots.size)
		maps\_utility::error ("infinity panzers at " + trigger getorigin() + " has no weapon slots");
#/

	// Create empty spots to put new guns
	slots = [];
	for (i=0;i<slotSpots.size;i++)
	{
		slot = spawn ("script_origin", (0,0,0));
		slot.origin = slotSpots[i].origin;
		slot.angles = slotSpots[i].angles;
		slot.angles += (0, 0, 270);
		slotSpots[i] delete();
		slots[i] = slot;
	}
	slot = undefined;

// getweaponslotweapon, setweaponslotweapon, getweaponslotammo, setweaponslotammo, getweaponslotclipammo, & setweaponslotclipammo.

	trigger setHintString(&"DAWNVILLE_PANZER");
	level thread infinite_panzer_modelswap (trigger, weaponObj, boxObj, weaponName);
	while (1)
	{
		trigger waittill ("trigger");
// getweaponslotweapon, setweaponslotweapon, getweaponslotammo, setweaponslotammo, getweaponslotclipammo, & setweaponslotclipammo.
		

/*
		weapon = genWeaponType (level.player getcurrentweapon());
		primary = genWeaponType (level.player getweaponslotweapon("primary"));
		secondary = genWeaponType (level.player getweaponslotweapon("primaryb"));
		switch (weapon)
		{
			case "kar98k_pavlovsniper":		weapon = "kar98k";				break;
			case "FG42":					weapon = "fg42";				break;
			case "FG42_semi":				weapon = "fg42";				break;
			case "mosin_nagant_sniper":		weapon = "mosinnagantsniper";	break;
			case "mosin_nagant":			weapon = "mosinnagant";			break;
			case "mp44_semi":				weapon = "mp44";				break;
			case "sten_engineer":			weapon = "sten";				break;
			case "thompson_semi":			weapon = "thompson";			break;
			case "BAR_slow":				weapon = "BAR";					break;

			case "MK1britishfrag":			weapon = "grenade";				break;
			case "RGD-33russianfrag":		weapon = "grenade";				break;
			case "Stielhandgranate":		weapon = "grenade";				break;
			case "fraggrenade":				weapon = "grenade";				break;
			case "colt":					weapon = "pistol";				break;
			case "luger":					weapon = "pistol";				break;
		}

		if (weapon == "grenade")
			continue;

		if (weapon == "pistol")
			continue;

		if (weapon == "panzerfaust")
			continue;
*/

		level notify ("picked up infinite " + weaponName);
		trigger notify ("infinite " + weaponName + " objective off");
		
		playerWeapon[0] = level.player getweaponslotweapon("primary");
		playerWeapon[1] = level.player getweaponslotweapon("primaryb");
		
		if (playerWeapon[0] == weaponName)
		{
			level.player takeWeapon(playerWeapon[0]);
			wait (0.1);
			level.player giveWeapon(weaponName);
			level.player switchToWeapon(weaponName);
			continue;
		}
		if (playerWeapon[1] == weaponName)
		{
			level.player takeWeapon(playerWeapon[1]);
			wait (0.1);
			level.player giveWeapon(weaponName);
			level.player switchToWeapon(weaponName);
			continue;
		}

		// Figure out which slot to put the weapon in, empty slot if one is empty, otherwise overwrite the one the player
		// is currently using.		
		if (playerWeapon[0] == "none")
			slotToFill = "primary";
		else
		if (playerWeapon[1] == "none")
			slotToFill = "primaryb";
		else
		if (level.player getcurrentweapon() == playerWeapon[0])
			slotToFill = "primary";
		else
			slotToFill = "primaryb";

		weapon = level.player getweaponslotweapon(slotToFill);
		
		// Toss out the player's weapon if he has one
		if (level.player getweaponslotweapon(slotToFill) != "none")
		{
			for (i=0;i<slots.size;i++)
			{
				if (isdefined (slots[i].groundWeapon))
					continue;
	
				weaponClassname = "weapon_" + weapon;
	
				gun = spawn (weaponClassname, (0,0,0));
				gun.origin = slots[i].origin;
				gun.angles = slots[i].angles;
	
				gun linkto (slots[i]);
				slots[i].groundWeapon = gun;
				break;
			}
		}

		level.player takeWeapon(weapon);
		level.player giveWeapon(weaponName);
		level.player switchToWeapon(weaponName);
		
		if (weaponName == "panzerschreck")
			level.player giveMaxAmmo(weaponName);
	}
}

infinite_panzer_modelswap (trigger, weaponObj, boxObj, weaponName)
{
	while (1)
	{
		if (weaponName == "panzerfaust")
		{
			trigger waittill ("infinite panzerfaust objective on");
			weaponObj setmodel ("xmodel/weapon_panzerfaust_objective");
			boxObj setmodel ("xmodel/ammo_panzerfaust_box2_objective");
	
			trigger waittill ("infinite panzerfaust objective off");
			weaponObj setmodel ("xmodel/weapon_panzerfaust");
			boxObj setmodel ("xmodel/ammo_panzerfaust_box2");
		}
		else
		if (weaponName == "panzerschreck")
		{
			trigger waittill ("infinite panzerschreck objective on");
			weaponObj setmodel ("xmodel/weapon_panzerschreck");
			boxObj setmodel ("xmodel/prop_crate_smallshipping1");
	
			trigger waittill ("infinite panzerschreck objective off");
			weaponObj setmodel ("xmodel/weapon_panzerschreck");
			boxObj setmodel ("xmodel/prop_crate_smallshipping1");
		}
	}
}

auto_mg42Link (nodes)
{
	// Attaches MG42s with targetname auto_mg42 to cover crouch and stand nodes.
	turrets = getentarray ("node_turret","targetname");


	names = [];
	for (i=0;i<nodes.size;i++)
	{
		named = false;
		for (p=0;p<names.size;p++)
		{
			if (nodes[i].type == names[p])
			{
				named = true;
				break;
			}			
		}
		
		if (!named)
			names[names.size] = nodes[i].type;
	}
	
	num = 0;
	for (i=0;i<nodes.size;i++)
	{
		if (nodes[i].type != "Turret")
			continue;
/*
		if ((nodes[i].type != "Cover Crouch Window")
		 && (nodes[i].type != "Cover Crouch")
		 && (nodes[i].type != "Cover Left")
		 && (nodes[i].type != "Cover Right")
		  && (nodes[i].type != "Cover Stand"))
			continue;
*/			
		if (isdefined (nodes[i].target))
			continue;
		
	    nodeforward = anglesToForward((0, nodes[i].angles[1], 0));
		for (p=0;p<turrets.size;p++)
		{
			if (distance(nodes[i].origin, turrets[p].origin) > 70)
				continue;
			
		
		    turretforward = anglesToForward((0, turrets[p].angles[1], 0));
			dot = vectordot(nodeforward, turretforward);
			if (dot < 0.9)
				continue;
	
			if (turrets[p].targetname == "node_turret")
			{			
				turrets[p].dmg = 45;
				turrets[p].targetname = ("mg42_attach" + num);
				nodes[i].auto_mg42_target = ("mg42_attach" + num);
				num++;
			}
			else
				nodes[i].auto_mg42_target = turrets[p].targetname;
		}
		
		if ( isdefined( nodes[i].auto_mg42_target ) )
		{
			thread maps\_mg42::turret_think(nodes[i]);
		}
	}

	turrets = getentarray ("node_turret","targetname");
//	turrets = getentarray ("node_turret","targetname");
	if (turrets.size)
	{
		Println ("See erroneous turrets below");
		for (i=0;i<turrets.size;i++)
			println ("Turret at origin " + turrets[i].origin + " did not link to a node_turret");
		assertEX(false, "Auto_mg42s did not link to node_turrets. See cases above");
	}
	
	nodes = undefined;
}

anim_loop ( guy, anime, tag, ender, node, tag_entity )
{
	maps\_anim::anim_loop ( guy, anime, tag, ender, node, tag_entity );
}

anim_single (guy, anime, tag, node, tag_entity)
{
	maps\_anim::anim_single (guy, anime, tag, node, tag_entity);
}

anim_single_solo (guy, anime, tag, node, tag_entity)
{
	newguy[0] = guy;
	maps\_anim::anim_single (newguy, anime, tag, node, tag_entity);
}

anim_single_queue (guy, anime, tag, node, tag_entity)
{
	maps\_anim::anim_single_queue (guy, anime, tag, node, tag_entity);
}

tweakfog()
{
	// Default values
	setcvar("scr_fog_type", "0");
	setcvar("scr_fog_density", "0.001");
	setcvar("scr_fog_nearplane", "0");
	setcvar("scr_fog_farplane", "5000");
	setcvar("scr_fog_red", "0.5");
	setcvar("scr_fog_green", "0.5");
	setcvar("scr_fog_blue", "0.5");

	for(;;)
	{
		level.fogtype = getcvarint("scr_fog_type");
		level.fogdensity = getcvarfloat("scr_fog_density");
		level.fognearplane = getcvarfloat("scr_fog_nearplane");
		level.fogfarplane = getcvarfloat("scr_fog_farplane");
		level.fogred = getcvarfloat("scr_fog_red");
		level.foggreen = getcvarfloat("scr_fog_green");
		level.fogblue = getcvarfloat("scr_fog_blue");
		
		if(level.fognearplane >= level.fogfarplane)
		{
			level.fogfarplane = level.fognearplane + 1;
			setcvar("scr_fog_farplane", level.fogfarplane);
		}

		if(level.fogtype == 0)
			setExpFog(level.fogdensity, level.fogred, level.foggreen, level.fogblue, 0);
		else
			setCullFog(level.fognearplane, level.fogfarplane, level.fogred, level.foggreen, level.fogblue, 0);

		wait .1;
	}
}

badplace_think(badplace)
{
	if (!isdefined(level.badPlaces))
		level.badPlaces = 0;
		
	level.badPlaces++;		
	badplace_cylinder("badplace" + level.badPlaces, -1, badplace.origin, badplace.radius, 1024);
}

setupPortableMG42s()
{
	// This should be precached on a level by level basis.
	/*
	precacheModel("xmodel/weapon_mg42_carry");
	mg42s = getentarray ("misc_turret", "classname");
	for (i=0;i<mg42s.size;i++)
	{
		if (!isdefined(mg42s[i].script_mg42portable))
			continue;

		mg42s[i].isSetup = false;
		mg42s[i].origin = (mg42s[i].origin[0], mg42s[i].origin[1], mg42s[i].origin[2] - 1024);
		mg42s[i] hide();
	}
	*/
}

setupExploders()
{
	// Hide exploder models.
	ents = getentarray ("script_brushmodel","classname");
	smodels = getentarray ("script_model","classname");
	for(i=0;i<smodels.size;i++)
		ents[ents.size] = smodels[i];

	for (i=0;i<ents.size;i++)
	{
		if (isdefined (ents[i].script_exploder))
		{
			if ((ents[i].model == "xmodel/fx") && ((!isdefined (ents[i].targetname)) || (ents[i].targetname != "exploderchunk")))
				ents[i] hide();
			else if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploder"))
			{
				ents[i] hide();
				ents[i] notsolid();
				if(isdefined(ents[i].script_disconnectpaths))
					ents[i] connectpaths();
			}
			else if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploderchunk"))
			{

				ents[i] hide();
				ents[i] notsolid();
				if(isdefined(ents[i].spawnflags) && (ents[i].spawnflags & 1))
					ents[i] connectpaths();
			}
		}
	}

	if (!isdefined(level._script_exploders))
		level._script_exploders = [];

	potentialExploders = getentarray ("script_brushmodel","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_exploder))
			level._script_exploders[level._script_exploders.size] = potentialExploders[i];
	}

	potentialExploders = getentarray ("script_model","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_exploder))
			level._script_exploders[level._script_exploders.size] = potentialExploders[i];
	}

	potentialExploders = getentarray ("item_health","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_exploder))
			level._script_exploders[level._script_exploders.size] = potentialExploders[i];
	}
}

lastSightPosWatch()
{
	/#
	for (;;)
	{
		wait (0.05);
		num = getcvarint("lastsightpos");
		if (!num)
			continue;
		
		guy = undefined;
		ai = getaiarray();
		for (i=0;i<ai.size;i++)
		{
			if (ai[i] getentnum() != num)
				continue;
				
			guy = ai[i];
			break;
		}
		
		if (!isalive(guy))
			continue;

		if (guy animscripts\utility::hasEnemySightPos())
			org = guy animscripts\utility::getEnemySightPos();
		else
			org = undefined;
		
					
		for (;;)
		{
			newnum = getcvarint("lastsightpos");
			if (num != newnum)
				break;
				
			if ((isalive(guy)) && (guy animscripts\utility::hasEnemySightPos()))
				org = guy animscripts\utility::getEnemySightPos();
			
			if (!isdefined(org))
			{
				wait (0.05);
				continue;
			}
			
			range = 10;
			color = (0.2, 0.9, 0.8);
			line (org + (0,0,range), org + (0,0,range * -1), color, 1.0);
			line (org + (range,0,0), org + (range * -1,0,0), color, 1.0);
			line (org + (0,range,0), org + (0,range * -1, 0), color, 1.0);
			wait (0.05);
		}
	}
	#/
}

nearAIRushesPlayer()
{
	if (isalive(level.enemySeekingPlayer))
		return;
	enemy = getClosestAI (level.player.origin, "axis");
	if (!isdefined (enemy))
		return;
		
	if (distance(enemy.origin, level.player.origin) > 400)
		return;
		
	level.enemySeekingPlayer = enemy;
	enemy setgoalentity (level.player);
	enemy.goalradius = 512;
	
}

		
	/*
			cur
			max			1
	*/
	/*
		// Damage dampening
		oldRatio = oldHealth / maxHealth;
		newRatio = player.health / maxHealth;
		difference = oldRatio - newRatio;
		if (difference < 0.6)
		{
			if (difference > 0.088)
				difference = 0.088;
			ratio = oldRatio - difference;
			if (ratio > 0)
			{
				player setnormalhealth (ratio);
				oldHealth = maxHealth * ratio;
			}
			else
				oldhealth = player.health;
		}
		else
			oldhealth = player.health;
		*/

playerDamageRumble()
{
	while ( true )
	{
		level.player waittill ( "damage", amount );
		level.player playrumble( "damage_heavy" );		
	}
}

playerDamageShellshock()
{
	while ( true )
	{
		level.player waittill ( "damage", damage, attacker, direction_vec, point, cause );

		if( cause == "MOD_EXPLOSIVE" ||
			cause == "MOD_GRENADE" ||
			cause == "MOD_GRENADE_SPLASH" ||
			cause == "MOD_PROJECTILE" ||
			cause == "MOD_PROJECTILE_SPLASH" )
		{
			time = 0;

			multiplier = level.player.maxhealth / 100;
			scaled_damage = damage * multiplier;
			
			if(scaled_damage >= 90)
				time = 4;
			else if(scaled_damage >= 50)
				time = 3;
			else if(scaled_damage >= 25)
				time = 2;
			else if(scaled_damage > 10)
				time = 1;
			
			if(time)
				level.player shellshock("default", time);
		}
	}
}

map_is_early_in_the_game()
{
	if (level.script == "moscow")
		return true;
	return (level.script == "demolition");
}

player_death_grenade_hint()
{
	// set the player's "quote" to the grenade indicator hint
	level.player_died_to_grenades = false;
	thread grenade_death_indicator_hudelement();

	while ( true )
	{
		level.player waittill ( "damage", damage, attacker, direction_vec, point, cause );

		if(	cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" )
			continue;

		if (level.gameskill >= 2)
		{
			// less grenade hinting on hard/fu
			if (!map_is_early_in_the_game() && randomint(100) < 85)
				continue;
		}
	
		thread set_grenade_hint_death_quote();
	}
}

grenade_death_indicator_hudelement()
{
//	if (1) return; // disabling because we may do this part in code
	level.player waittill ("death");
	waittillframeend; // give the died to grenades var a chance to get set
	if (!level.player_died_to_grenades)
		return;
//	wait (1.75);
//	setcvar("ui_grenade_death","1");
	wait (1.5);
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 68;
	overlay setshader ("hud_grenadeicon", 50, 50);
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay fadeOverTime(1);
	overlay.alpha = 1;

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 25;
	overlay setshader ("hud_grenadepointer", 50, 25);
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay fadeOverTime(1);
	overlay.alpha = 1;
}

set_grenade_hint_death_quote()
{
	level.player endon ("damage");
	setCvar("ui_deadquote", "@SCRIPT_GRENADE_DEATH");
	level.player_died_to_grenades = true;
	wait (0.05);
	level.player_died_to_grenades = false;
	// if the player is still alive a frame later, set it back to a normal quote
	if (isalive(level.player))
		thread maps\_quotes::setDeadQuote();
}

debug_enemyPos(num)
{
	ai = getaiarray();
	
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentitynumber() != num)
			continue;
			
		ai[i] thread debug_enemyPosProc();
		break;	
	}
}

debug_stopEnemyPos(num)
{
	ai = getaiarray();
	
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentitynumber() != num)
			continue;
			
		ai[i] notify ("stop_drawing_enemy_pos");
		break;	
	}
}

debug_enemyPosProc()
{
	self endon ("death");
	self endon ("stop_drawing_enemy_pos");
	for (;;)
	{
		wait (0.05);

		if (isalive(self.enemy))
			line (self.origin + (0,0,70), self.enemy.origin + (0,0,70), (0.8, 0.2, 0.0), 0.5);

		if (!self animscripts\utility::hasEnemySightPos())
			continue;
		
		pos = animscripts\utility::getEnemySightPos();
		line (self.origin + (0,0,70), pos, (0.9, 0.5, 0.3), 0.5);
	}
}

debug_enemyPosReplay()
{
	ai = getaiarray();
	guy = undefined;
	
	for (i=0;i<ai.size;i++)
	{
//		if (ai[i] getentitynumber() != num)
//			continue;
			
		guy = ai[i];
		if (!isalive(guy))
			continue;
	

		if (isdefined(guy.lastEnemySightPos))
			line (guy.origin + (0,0,65), guy.lastEnemySightPos, (1, 0, 1), 0.5);
			
		if (guy.goodShootPosValid)
		{
			if (guy.team == "axis")
				color = (1,0,0);
			else
				color = (0,0,1);
			
//			nodeOffset = guy GetEye();
			nodeOffset = guy.origin + (0,0,54);
			if (isdefined(guy.node))
			{
				if (guy.node.type == "Cover Left")
				{
					cornerNode = true;
					nodeOffset = anglestoright(guy.node.angles);
					nodeOffset = maps\_utility::vectorScale(nodeOffset, -32);
					nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
					nodeOffset = guy.node.origin + nodeOffset;
				}
				else
				if (guy.node.type == "Cover Right")
				{
					cornerNode = true;
					nodeOffset = anglestoright(guy.node.angles);
					nodeOffset = maps\_utility::vectorScale(nodeOffset, 32);
					nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
					nodeOffset = guy.node.origin + nodeOffset;
				}
			}			
			drawArrow (nodeOffset, guy.goodShootPos, color);
		}
//		break;	
	}
	if (1) return;

	if (!isalive(guy))
		return;
		
	if (isalive(guy.enemy))
		line (guy.origin + (0,0,70), guy.enemy.origin + (0,0,70), (0.6, 0.2, 0.2), 0.5);

	if (isdefined(guy.lastEnemySightPos))
		line (guy.origin + (0,0,65), guy.lastEnemySightPos, (0, 0, 1), 0.5);

	if (isalive(guy.goodEnemy))
		line (guy.origin + (0,0,50), guy.goodEnemy.origin, (1, 0, 0), 0.5);


	if (!guy animscripts\utility::hasEnemySightPos())
		return;

	pos = guy animscripts\utility::getEnemySightPos();
	line (guy.origin + (0,0,55), pos, (0.2, 0.2, 0.6), 0.5);

	if (guy.goodShootPosValid)
		line (guy.origin + (0,0,45), guy.goodShootPos, (0.2, 0.6, 0.2), 0.5);
}

drawEntTag(num)
{
	/#
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentnum() != num)
			continue;
		ai[i] thread dragTagUntilDeath(getdebugcvar("debug_tag"));
	}
	setcvar("debug_enttag", "");
	#/
}

dragTagUntilDeath(tag)
{
	for (;;)
	{
		if (!isdefined(self.origin))
			break;
		drawTag(tag);
		wait (0.05);
	}
}

viewTag(type,tag)
{
	if(type == "ai")
	{
		ai = getaiarray();
		for (i=0;i<ai.size;i++)
			ai[i] drawTag(tag);
	}
	else
	{
		vehicle = getentarray("script_vehicle","classname");
		for (i=0;i<vehicle.size;i++)
			vehicle[i] drawTag(tag);
	}
}


debug_corner()
{
	level.player.ignoreme = true;
	nodes = getallnodes();
	corners = [];
	for (i=0;i<nodes.size;i++)
	{
		if (nodes[i].type == "Cover Left")
			corners[corners.size] = nodes[i];
		if (nodes[i].type == "Cover Right")
			corners[corners.size] = nodes[i];
	}

	ai = getaiarray();
	for (i=0;i<ai.size;i++)
		ai[i] delete();
		
	level.debugspawners = getspawnerarray();
	level.activeNodes = [];
	level.completedNodes = [];
	for (i=0;i<level.debugspawners.size;i++)
		level.debugspawners[i].targetname = "blah";
		
	covered = 0;	
	for (i=0;i<30;i++)
	{
		if (i >= corners.size)
			break;
			
		corners[i] thread coverTest();
		covered++;
	}
	
	if (corners.size <= 30)
		return;
		
	for (;;)
	{
		level waittill ("debug_next_corner");
		if (covered >= corners.size)
			covered = 0;
		corners[covered] thread coverTest();
		covered++;
	}
}

coverTest()
{
	coverSetupAnim();
}

#using_animtree ("generic_human");
coverSetupAnim()
{
	spawn = undefined;
	spawner = undefined;
	for (;;)
	{
		for (i=0;i<level.debugspawners.size;i++)
		{
			wait (0.05);
			spawner = level.debugspawners[i];
			nearActive = false;
			for (p=0;p<level.activeNodes.size;p++)
			{
				if (distance(level.activeNodes[p].origin, self.origin) > 250)
					continue;
				nearActive = true;
				break;
			}
			if (nearActive)
				continue;
				
			completed = false;
			for (p=0;p<level.completedNodes.size;p++)
			{
				if (level.completedNodes[p] != self)
					continue;
				completed = true;
				break;
			}
			if (completed)
				continue;
				
			level.activeNodes[level.activeNodes.size] = self;
			spawner.origin = self.origin;
			spawner.angles = self.angles;
			spawner.count = 1;
			spawn = spawner stalingradspawn();
			if (spawn_failed(spawn))
			{
				removeActiveSpawner(self);
				continue;
			}
			
			break;
		}
		if (isalive(spawn))
			break;
	}

	wait (1);
	if (isalive (spawn))
	{
		spawn.ignoreme = true;
		spawn.team = "neutral";
		spawn setgoalpos (spawn.origin);
		thread createLine(self.origin);
		spawn thread debugorigin();
		thread createLineConstantly(spawn);
		spawn waittill ("death");
	}
	removeActiveSpawner(self);
	level.completedNodes[level.completedNodes.size] = self;
}

removeActiveSpawner(spawner)
{
	newSpawners = [];	
	for (p=0;p<level.activeNodes.size;p++)
	{
		if (level.activeNodes[p] == spawner)
			continue;
		newSpawners[newSpawners.size] = level.activeNodes[p];
	}
	level.activeNodes = newSpawners;
}


createLine(org)
{
	for (;;)
	{
		line (org + (0,0,35), org, (0.2, 0.5, 0.8), 0.5);
		wait (0.05);
	}
}

createLineConstantly(ent)
{
	org = undefined;
	while (isalive(ent))
	{
		org = ent.origin;
		wait (0.05);		
	}
	
	for(;;)
	{
		line (org + (0,0,35), org, (1.0, 0.2, 0.1), 0.5);
		wait (0.05);
	}
}

debugMisstime()
{
	self notify ("stopdebugmisstime");
	self endon ("stopdebugmisstime");
	self endon ("death");
	for (;;)
	{
		if (self.anim_misstime <= 0)
			print3d(self gettagorigin ("TAG_EYE") + (0,0,15), "hit", (0.3,1,1), 1);
		else
			print3d(self gettagorigin ("TAG_EYE") + (0,0,15), self.anim_misstime/20, (0.3,1,1), 1);
		wait (0.05);
	}
}

debugMisstimeOff()
{
	self notify ("stopdebugmisstime");
}

setEmptyCvar(cvar, setting)
{
	/#
	if (getdebugcvar(cvar) == "")
		setcvar(cvar, setting);
	#/		
}

debugJump(num)
{
	/#
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentnum() != num)
			continue;
			
		line (level.player.origin, ai[i].origin, (0.2,0.3,1.0));
		return;
	}
	#/
}

debugCvars()
{
	/#
	setEmptyCvar("debug_accuracypreview","off");

	if (getdebugcvar("debug_lookangle") == "")
		setcvar("debug_lookangle", "off");

	if (getdebugcvar("debug_grenademiss") == "")
		setcvar("debug_grenademiss", "off");

	if (getdebugcvar("debug_enemypos") == "")
		setcvar("debug_enemypos", "-1");
		
	if (getdebugcvar("debug_dotshow") == "")
		setcvar("debug_dotshow", "-1");
		
	if (getdebugcvar("debug_stopenemypos") == "")
		setcvar("debug_stopenemypos", "-1");

	if (getdebugcvar("debug_replayenemypos") == "")
		setcvar("debug_replayenemypos", "-1");

	if (getcvar("debug_groupmove_paths") == "")
		setcvar("debug_groupmove_paths", "off");

	if (getcvar("debug_groupmove_simplepaths") == "")
		setcvar("debug_groupmove_simplepaths", "off");

	if (getcvar("debug_groupmove_nodes") == "")
		setcvar("debug_groupmove_nodes", "off");

	if (getdebugcvar("debug_tag") == "")
		setcvar("debug_tag", "");

	if (getdebugcvar("debug_chatlook") == "")
		setcvar("debug_chatlook", "");
		
	if (getdebugcvar("debug_vehicletag") == "")
		setcvar("debug_vehicletag", "");

	if (getdebugcvar("debug_animreach") ==  "")
		setcvar("debug_animreach", "off");

	if (getdebugcvar("debug_hatmodel") == "")
		setcvar("debug_hatmodel", "on");

	if (getdebugcvar("debug_trace") == "")
		setcvar("debug_trace", "off");

	if (getdebugcvar ("anim_lastsightpos") == "")
		setcvar("debug_lastsightpos", "off");

	if (getcvar ("debug_nuke") == "")
		setcvar("debug_nuke", "off");

	if (getdebugcvar("debug_deathents") == "on")
		setcvar("debug_deathents", "off");

	if (getcvar ("debug_jump") == "")
		setcvar("debug_jump", "");

	if (getcvar ("debug_hurt") == "")
		setcvar("debug_hurt", "");

	//if(getcvar("debug_character_count") == "")
	//	setcvar("debug_character_count","off");
		
//	thread hatmodel();	
	//thread debug_character_count();

	noAnimscripts = getcvar("debug_noanimscripts") == "on";
	for (;;)
	{
		if (getdebugcvar("debug_jump") != "")
			debugJump(getdebugcvarint("debug_jump"));
		
		
		
		if (getdebugcvar("debug_tag") != "")
		{
			thread viewTag("ai",getdebugcvar("debug_tag"));
			if (getdebugcvarInt("debug_enttag") > 0)
				thread drawEntTag(getDebugCvarInt("debug_enttag"));
		}

		if (getdebugcvar("debug_vehicletag") != "")
			thread viewTag("vehicle",getdebugcvar("debug_vehicletag"));

		if (getdebugcvar("debug_replayenemypos") == "on")
			thread debug_enemyPosReplay();

		if (getcvar("debug_nuke") == "on")
			thread debug_nuke();

		if (getcvar("debug_misstime") == "on")
		{
			setcvar("debug_misstime", "start");
			array_thread(getaiarray(), ::debugMisstime);
		}
		else
		if (getcvar("debug_misstime") == "off")
		{
			setcvar("debug_misstime", "start");
			array_thread(getaiarray(), ::debugMisstimeOff);
		}

		if (getcvar("debug_deathents") == "on")
			thread deathspawnerPreview();	

		if (getcvar("debug_hurt") == "on")
		{
			setcvar("debug_hurt", "off");
			level.player dodamage(50, (324234,3423423,2323));
		}

		if (getdebugcvarint("debug_enemypos") != -1)
		{
			thread debug_enemypos(getdebugcvarint("debug_enemypos"));
			setcvar("debug_enemypos", "-1");
		}
		if (getdebugcvarint("debug_stopenemypos") != -1)
		{
			thread debug_stopenemypos(getdebugcvarint("debug_stopenemypos"));
			setcvar("debug_stopenemypos", "-1");
		}
		
		if (!noAnimscripts && getcvar("debug_noanimscripts") == "on")
		{
			anim.defaultException = animscripts\init::infiniteLoop;
			noAnimscripts = true;
		}
		
		if (noAnimscripts && getcvar("debug_noanimscripts") == "off")
		{
			anim.defaultException = animscripts\init::empty;
			anim notify ("new exceptions");
			noAnimscripts = false;
		}

		if (getdebugcvar("debug_trace") == "on")
		{
			if (!isdefined (level.traceStart))
				thread showDebugTrace();
			level.traceStart = level.player geteye();
			setcvar("debug_trace", "off");
		}
		
		
		wait (0.05);
	}
	#/
}


showDebugTrace()
{
	startOverride = undefined;
	endOverride = undefined;
	startOverride = (15.1859, -12.2822, 4.071);
	endOverride = (947.2, -10918, 64.9514);

	assert (!isdefined (level.traceEnd));
	for (;;)
	{
		wait (0.05);
		start = startOverride;
		end = endOverride;
		if (!isdefined(startOverride))
			start = level.traceStart;
		if (!isdefined(endOverride))
			end = level.player geteye();
			
		trace = bulletTrace(start, end, false, undefined);
		line (start, trace["position"], (0.9, 0.5, 0.8), 0.5);
	}	
}

hatmodel()
{
	/#
	for (;;)
	{
		if (getdebugcvar("debug_hatmodel") == "off")
			return;
		noHat = [];
		ai = getaiarray();
		
		for (i=0;i<ai.size;i++)
		{
			if (isdefined(ai[i].hatmodel))
				continue;
				
			alreadyKnown = false;
			for (p=0;p<noHat.size;p++)
			{
				if (noHat[p] != ai[i].classname)
					continue;
				alreadyKnown = true;
				break;
			}
			if (!alreadyKnown)
				noHat[noHat.size] = ai[i].classname;
		}
		
		if (noHat.size)
		{
			println (" ");
			println ("The following AI have no Hatmodel, so helmets can not pop off on head-shot death:");
			for (i=0;i<noHat.size;i++)
				println ("Classname: ", noHat[i]);
			println ("To disable hatModel spam, type debug_hatmodel off");
		}
		wait (15);
	}
	#/
}

triggered_playerseek(trig)
{
	groupNum = trig.script_triggered_playerseek;
	trig waittill ("trigger");
	
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if (!isAlive(ai[i]))
			continue;
		if ( (isdefined (ai[i].script_triggered_playerseek)) && (ai[i].script_triggered_playerseek == groupNum) )
		{
			ai[i].goalradius = 800;
			ai[i] setgoalentity (level.player);
			level thread maps\_spawner::delayed_player_seek_think(ai[i]);
		}
	}
}

traverseThink()
{
	ent = getent(self.target,"targetname");
	self.traverse_height = ent.origin[2];
	ent delete();
}

debug_character_count ()
{
	//drones
	drones = newHudElem();
	drones.alignX = "left";
	drones.alignY = "middle";
	drones.x = 10;
	drones.y = 100;
	drones.label = &"DEBUG_DRONES";
	drones.alpha = 0;
	
	//allies
	allies = newHudElem();
	allies.alignX = "left";
	allies.alignY = "middle";
	allies.x = 10;
	allies.y = 115;
	allies.label = &"DEBUG_ALLIES";
	allies.alpha = 0;
	
	//allies
	axis = newHudElem();
	axis.alignX = "left";
	axis.alignY = "middle";
	axis.x = 10;
	axis.y = 130;
	axis.label = &"DEBUG_AXIS";
	axis.alpha = 0;
	

	//vehicles
	vehicles = newHudElem();
	vehicles.alignX = "left";
	vehicles.alignY = "middle";
	vehicles.x = 10;
	vehicles.y = 145;
	vehicles.label = &"DEBUG_VEHICLES";
	vehicles.alpha = 0;

	//total
	total = newHudElem();
	total.alignX = "left";
	total.alignY = "middle";
	total.x = 10;
	total.y = 160;
	total.label = &"DEBUG_TOTAL";
	total.alpha = 0;
	
	lastcvar = "off";
	for (;;)
	{
		cvar = getcvar("debug_character_count");
		if(cvar == "off")
		{
			if(cvar != lastcvar)
			{
				drones.alpha = 0;
				allies.alpha = 0;
				axis.alpha = 0;
				vehicles.alpha = 0;
				total.alpha = 0;
				lastcvar = cvar;
			}
			wait .25;
			continue;
		}
		else
		{
			if(cvar != lastcvar)
			{
				drones.alpha = 1;
				allies.alpha = 1;
				axis.alpha = 1;
				vehicles.alpha = 1;
				total.alpha = 1;
				lastcvar = cvar;

			}
		}
		//drones
		count_drones = getentarray("drone","targetname").size;
		drones setValue( count_drones );
		
		//allies
		count_allies = getaiarray("allies").size;
		allies setValue( count_allies );
		
		//axis
		count_axis = getaiarray("axis").size;
		axis setValue( count_axis );
		
		vehicles setValue (getentarray("script_vehicle","classname").size);
		
		//total
		total setValue ( count_drones + count_allies + count_axis );
		
		wait 0.25;
	}
}

hopelesslylost (trigger)
{
	targ = getent(trigger.target,"targetname");
	trigger waittill ("trigger");
	ai = getaiarray();
	for(i=0;i<ai.size;i++)
	{
		if(!ai[i] istouching (targ) && !isdefined(ai[i].not_hopeless))
		{
			ai[i] delete();
			println("hopelessly loss ai guy deleted");
		}
	}
}

triggeronce (trigger)
{
	trigger waittill ("trigger");
	trigger triggeroff();
}


pianoDamageThink()
{
	org = self getorigin();
//	note = "piano_" + self.script_noteworthy;
//	self setHintString (&"SCRIPT_PLATFORM_PIANO");
	note[0] = "large";
	note[1] = "small";
	for (;;)
	{
		self waittill ("trigger");
		thread playsoundinspace("bullet_" + random(note) + "_piano", org);
	}
}

pianoThink()
{
	org = self getorigin();
	note = "piano_" + self.script_noteworthy;
	self setHintString (&"SCRIPT_PLATFORM_PIANO");
	for (;;)
	{
		self waittill ("trigger");
		thread playsoundinspace(note ,org);
	}
}

debug_nuke()
{
	setcvar("debug_nuke", "off");
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
		ai[i] dodamage(300, (0,0,0));
}

debug_missTime()
{
	
}

bcTrigger( trigger )
{
	if ( isDefined( trigger.target ) )
	{
		realTrigger = getEnt( trigger.target, "targetname" );
		realTrigger waittill ( "trigger", other );
	}
	else
	{
		realTrigger = undefined;
		trigger waittill ( "trigger", other );
	}
	
	soldier = undefined;
	
	if ( isDefined( realTrigger ) )
	{
		if ( other.team == "axis" && level.player isTouching( trigger ) )
		{
			soldier = getClosestAI( level.player getOrigin(), "allies" );
			if ( distance( soldier.origin, level.player getOrigin() ) > 512 )
				return;
		}
		else if ( other.team == "allies" )
		{
			soldiers = getAIArray( "axis" );
			
			for ( index = 0; index < soldiers.size; index++ )
			{
				if ( soldiers[index] isTouching( trigger ) )
					soldier = soldiers[index];
			}
		}
	}
	else
		soldier = other;
	
	if ( !isDefined( soldier ) )
		return;

	soldier customBattleChatter( trigger.script_bctrigger );
}

waterThink()
{
	assert(isdefined(self.target));
	targeted = getent(self.target,"targetname");
	assert(isdefined(targeted));
	waterHeight = targeted.origin[2];
	targeted = undefined;
	
	level.depth_allow_prone = 8;
	level.depth_allow_crouch = 33;
	level.depth_allow_stand = 50;
	
	prof_begin("water_stance_controller");
	
	for (;;)
	{
		wait 0.05;
		//restore all defaults
		if (!level.player.inWater)
		{
			level.player allowProne(true);
			level.player allowCrouch(true);
			level.player allowStand(true);
			thread waterThink_rampSpeed(level.default_run_speed);
		}
		
		//wait until in water
		self waittill ("trigger");
		level.player.inWater = true;
		while(level.player isTouching(self))
		{
			level.player.inWater = true;
			playerOrg = level.player getOrigin();
			d = (playerOrg[2] - waterHeight);
			if (d > 0)
				break;
			
			//slow the players movement based on how deep it is
			newSpeed = int(level.default_run_speed - abs(d * 5));
			if (newSpeed < 50)
				newSpeed = 50;
			assert(newSpeed <= 190);
			thread waterThink_rampSpeed(newSpeed);
			
			//controll the allowed stances in this water height
			if (abs(d) > level.depth_allow_crouch)
				level.player allowCrouch(false);
			else
				level.player allowCrouch(true);
			
			if (abs(d) > level.depth_allow_prone)
				level.player allowProne(false);
			else
				level.player allowProne(true);
			
			wait 0.5;
		}
		level.player.inWater = false;
		wait 0.05;
	}
	
	prof_end("water_stance_controller");
}

waterThink_rampSpeed(newSpeed)
{
	level notify ("ramping_water_movement_speed");
	level endon ("ramping_water_movement_speed");
	
	rampTime = 0.5;
	numFrames = int(rampTime * 20);
	
	currentSpeed = getcvarint("g_speed");
	
	qSlower = false;
	if (newSpeed < currentSpeed)
		qSlower = true;
	
	speedDifference = int(abs(currentSpeed - newSpeed));
	speedStepSize = int(speedDifference / numFrames);
	
	for( i = 0 ; i < numFrames ; i++ )
	{
		currentSpeed = getcvarint("g_speed");
		if (qSlower)
			setsavedcvar("g_speed", (currentSpeed - speedStepSize));
		else
			setsavedcvar("g_speed", (currentSpeed + speedStepSize));
		wait 0.05;
	}
	setsavedcvar("g_speed", newSpeed );
}

lampglowfx()
{
	if (!isdefined(level._effect))
		level._effect = [];
	if (!isdefined(level._effect["lantern_light"]))
		level._effect["lantern_light"]	= loadfx("fx/props/glow_latern.efx");
	thread maps\_fx::loopfx("lantern_light", self.origin, 0.3, self.origin + (0,0,1), undefined, "lantern_stop");
}

meteors()
{
	if (getcvarint("meteors") < 1)
		return;
	
	level._effect["meteor_shower"]				= loadfx ("fx/fire/meteor_shower.efx");
	
	for (;;)
	{
		playfx ( level._effect["meteor_shower"], level.player.origin + (0,0,10000));
		wait (0.3);
	}
}

deathspawnerPreview()
{
	waittillframeend;
	for (i=0;i<50;i++)
	{
		if (!isdefined (level.deathspawnerents[i]))
			continue;
		array = level.deathspawnerents[i];
		for (p=0;p<array.size;p++)
		{
			ent = array[p];
			if (isdefined(ent.truecount))
				print3d (ent.origin, i + ": " + ent.truecount, (0,0.8,0.6), 5);
			else
				print3d (ent.origin, i + ": " +  ".", (0,0.8,0.6), 5);
		}
	}
}

massNodeInitFunctions()
{
	nodes = getallnodes();
	thread auto_mg42Link(nodes);
	thread maps\_spawner::initScriptColors(nodes);
}
