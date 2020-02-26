main()
{

	star (4 + randomint(4));
	if (getcvar("start") == "")
		setcvar("start", "start");

	if (getcvar("debug") == "")
		setcvar("debug", "0");

	if (getcvar("chain") == "")
		setcvar("chain", "0");

	if (getcvar("fallback") == "")
		setcvar("fallback", "0");

	if (getcvar("angles") == "")
		setcvar("angles", "0");

	if (getcvar("camera") == "")
		setcvar("camera", "off");

	if (getcvar("nextcamera") == "")
		setcvar("nextcamera", "on");

	if (getcvar("lastcamera") == "")
		setcvar("lastcamera", "on");

	if (getcvar("dollycamera") == "on")
		thread dolly();
	else
		setcvar("dollycamera", "");

	if (!isdefined (level.scr_special_notetrack))
		level.scr_special_notetrack = [];
	if (!isdefined (level.scr_notetrack))
		level.scr_notetrack = [];
	if (!isdefined (level.scr_face))
		level.scr_face = [];
	if (!isdefined (level.scrsound))
		level.scrsound = [];

//	thread camera();
	insure_node_sanctity(); // Insures that any node with a target is not targetting something that doesnt exist.

	level.teleport = 1;
	level.scr_anim[0][0] = 0;

	player = getent("player", "classname" );
	level.player = player;
	level.player.maxhealth = level.player.health;
	level.player.shellshocked = false;

	// testing shellshock when player dies
	level.player thread maps\_utility::shock_ondeath();
//	level.player thread shock_onpain();
	precacheShellshock("default");

	level.script = getcvar ("mapname");
	println  ("level.script: ", level.script);

	maps\_tank::main();

	maps\_loadout::give_loadout();

	thread maps\_quotes::setDeadQuote();
	thread maps\_quotes::setVictoryQuote();

	thread maps\_minefields::minefields();
	thread maps\_window::main();

	maps\_sounds::main();

	thread maps\_autosave::beginingOfLevelSave();
	thread maps\_introscreen::main();

	// For _anim to track what animations have been used
	thread usedAnimations();

	maps\_utility::array_levelthread (getentarray ("infinite panzerfaust","targetname"), ::infinite_panzerfaust);

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
	//   This handles setting up infinite ammo panzerfausts
	//****************************************************************************
	thread infinite_panzerfaust_think();

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
			else
			if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploder"))
			{
				ents[i] hide();
				ents[i] notsolid();
			}
			else
			if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploderchunk"))
			{

				ents[i] hide();
				ents[i] notsolid();
				if(isdefined(ents[i].spawnflags) && (ents[i].spawnflags & 1))
					ents[i] connectpaths();
			}
		}
	}
	ents = undefined;

	// Do various things on triggers
	level._max_script_health = 0;
	for (p=0;p<4;p++)
	{
		switch (p)
		{
			case 0:	triggertype = "trigger_multiple" ; break;
			case 1:	triggertype = "trigger_once" ; break;
			case 2:	triggertype = "trigger_use" ; break;
			case 3:	triggertype = "trigger_damage" ; break;
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

			if (isdefined (triggers[i].script_fallback))
				level thread maps\_spawner::fallback_think(triggers[i]);

			if (isdefined (triggers[i].script_mg42auto))
				level thread maps\_mg42::mg42_auto(triggers[i]);

			if (isdefined (triggers[i].script_killspawner))
				level thread maps\_spawner::kill_spawner(triggers[i]);

			if (isdefined (triggers[i].script_kill_chain))
				level thread maps\_load::kill_chain(triggers[i]);

			if (isdefined (triggers[i].script_hint))
				level thread maps\_load::hint(triggers[i]);

			if (isdefined (triggers[i].script_exploder))
				level thread maps\_load::exploder(triggers[i]);

			if (isdefined (triggers[i].ambient))
				level thread maps\_load::ambient_thread(triggers[i]);

			if (isdefined (triggers[i].script_fxstart))
				level thread maps\_load::fxstart_thread(triggers[i]);

			if (isdefined (triggers[i].script_fxstop))
				level thread maps\_load::fxstop_thread(triggers[i]);

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
				if (spawner.count)
					trigger thread doAutoSpawn(spawner);
				break;
			}
		}
	}

	//****************************************************************************


	maps\_personality::main();
	maps\_spawner::main();

	if (getcvar("chain") == "1")
		thread debugchains();

	thread error_check();
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

	thread maps\_utility::load_friendlies();
}

error_check()
{
	wait (1);
	if ((level.script == "stalingrad") || (level.script == "stalingrad_nolight"))
		return;

	mortars = getentarray ("mortar","targetname");
	if ((mortars.size > 0) && (!isdefined (level.mortar)))
		maps\_utility::error ("Add to map script: maps\_mortar::main();");
}

debugchains()
{
	nodes = getallnodes();
	fnodenum = 0;

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
				if (isdefined (friends[i].node))
					line (friends[i].origin + (0,0,35), friends[i].node.origin, (0.2, 0.5, 0.8), 0.5);
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

ambient_thread(trigger)
{
	level.ambient = trigger.ambient;

//	trigger.wait = 0.05;
	while (1)
	{
		trigger waittill ("trigger");
		if (level.ambient != trigger.ambient)
		{
			level.ambient = trigger.ambient;
			if ((isdefined (level.ambient_track)) && (isdefined (level.ambient_track[trigger.ambient])))
				ambientPlay (level.ambient_track[trigger.ambient], 1);
			println ("changing ambient to ", trigger.ambient);
		}

		while (trigger istouching (level.player))
			wait (0.05);
	}
}

fxstart_thread(trigger)
{
	fxnum = trigger.script_fxstart;

	while (1)
	{
		trigger waittill ("trigger");
		level notify ("start fx" + fxNum);
	}
}

fxstop_thread(trigger)
{
	fxnum = trigger.script_fxstop;

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
	print_keypair ("script_vehiclegroup", self.script_vehiclegroup);
	print_keypair ("script_exploder", self.script_exploder);
	print_keypair ("script_balcony", self.script_balcony);
	print_keypair ("script_personality", self.script_personality);

	print_keypair ("export", self.export);
	println ("}");
}

axis_touching ( trigger )
{
	if (!isdefined (trigger.target))
		maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");

	chatter = getent (trigger.target, "targetname");
	if (isdefined (chatter))
	{
		if (chatter.team != "allies")
			maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");

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
				maps\_utility::keyHintPrint(&"SCRIPT_HINT_SWITCHTOGRENADE", getKeyBinding("weaponslot grenade"));
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
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_ADSKEY", binding);
		wait 3;
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_ADSSTOP", binding);
	}
	else
	{
		binding = getKeyBinding("+speed");
		if(binding["count"])
			maps\_utility::keyHintPrint(&"SCRIPT_HINT_HOLDDOWNADSKEY", binding); 
	}
}

// Plays chat sound once all axis in the volume die
axis_dead ( trigger )
{
	if (!isdefined (trigger.target))
		maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");

	chatter = getent (trigger.target, "targetname");
	if (isdefined (chatter))
	{
		if (chatter.team != "allies")
			maps\_utility::error ("Axis_touching trigger at origin " + trigger getorigin() + " doesn't target a friendly.");

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
	enemies = getspawnerarray ("axis");
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
	maps\_utility::keyHintPrint(&"SCRIPT_HINT_MELEEATTACK", getKeyBinding("+melee"));
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
		character_line = false;

	if (character_line)
	{
		if (!isdefined (chatter))
			maps\_utility::error ("Friendly_chat trigger at origin " + trigger getorigin() + " doesn't target a living friendly.");

		if (chatter.team != "allies")
			maps\_utility::error ("Friendly_chat trigger at origin " + trigger getorigin() + " doesn't target a friendly.");

		if (!isdefined (chatter.kill_friendly_chat_triggers))
		{
			level thread kill_friendly_chat_triggers (chatter);
			chatter.kill_friendly_chat_triggers = true;
		}

		chatter endon ("death");
	}
	else
	{
		if (!isdefined (trigger.script_animname))
			maps\_utility::error ("Friendly_chat trigger at origin " + trigger getorigin() + " with no character target doesn't have a script_animname");
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
	if (isdefined (trigger.script_noteworthy))
	{
		if (trigger.script_noteworthy == "flak")
			maps\_utility::keyHintPrint(&"SCRIPT_HINT_PLANTEXPLOSIVES", getKeyBinding("+activate"));
		else
		if (trigger.script_noteworthy == "base of fire")
		{
			chatter waittill ("base of fire");
			wait (1);
			iprintlnbold (&"SCRIPT_HINT_OBJECTIVEONCOMPASS");
			wait (5);
			maps\_utility::keyHintPrint(&"SCRIPT_HINT_OBJECTIVEKEY", getKeyBinding("+scores"));			
		}
	}
	
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
			case 0:	triggertype = "trigger_multiple" ; break;
			case 1:	triggertype = "trigger_once" ; break;
			case 2:	triggertype = "trigger_use" ; break;
			case 3:	triggertype = "trigger_damage" ; break;
		}

		triggers = getentarray (triggertype,"classname");
		for (i=0;i<triggers.size;i++)
		{
			if ((isdefined (triggers[i].targetname)) && (triggers[i].targetname == "friendly_chat")
			&& (triggers[i].target == name))
			triggers[i] delete();
		}
	}
}

exploder (trigger)
{
	level endon ("killexplodertridgers"+trigger.script_exploder);
	trigger waittill ("trigger");
//	println ("TRIGGERED");
	maps\_utility::exploder (trigger.script_exploder);
//	maps\_spawner::kill_trigger (trigger);
	level notify ("killexplodertridgers"+trigger.script_exploder);
}

add_camera (camera, origin, angles)
{
	newcamera = spawn ("script_origin", (0,1,2));
	newcamera.origin = origin;
	newcamera.angles = angles;

	if (isdefined (camera))
		camera[camera.size] = newcamera;
	else
		camera[0] = newcamera;

	return camera;
}

camera()
{
	maps\_spawner::waitframe();
	thread anglescheck();

	if (!isdefined (level.camera))
		return;

//	wait (1);
	mintime = 0;
	while(getcvar ("camera") == "on")
	{
		for (i=0;i<level.camera.size;i++)
		{
			if (getcvar ("camera") != "on")
				break;

			setcvar("nextcamera", "on");
			setcvar("lastcamera", "on");

			/*
			org = spawn ("script_origin",(0,0,0));
			org.origin = level.camera[i].origin;
			org.angles = level.camera[i].angles;

			level.player setorigin (org.origin);
			level.player linkto (org);
			linker = true;

			nextcam = i++;
			if (i>=level.camera.size)
				i-=0;
			*/

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

	if (isdefined (linker))
		level.player unlink();
}

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

infinite_panzerfaust_think()
{
	weapons = get_infinite_panzerfausts();
	if (weapons.size < 1)
	{
		println("no infinite panzerfausts found");
		return;
	}

	locations = [];
	for (i=0; i<weapons.size; i++)
	{
		println("infinite panzerfaust found");
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
		weapons = get_infinite_panzerfausts();
		if (weapons.size < locations.size)
		{
			level notify ("picked up infinite panzerfaust");
			for (i=0; i<locations.size; i++)
			{
				new_weapon = spawn ("weapon_panzerfaust", locations[i].origin);
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

get_infinite_panzerfausts()
{
	weapons = [];
	temp = getentarray ("weapon_panzerfaust", "classname");
	for (i=0; i<temp.size; i++)
	{
		if ( (isdefined (temp[i].targetname) ) && (temp[i].targetname == "respawn") )
			weapons = maps\_utility::add_to_array ( weapons, temp[i] );
	}
	return weapons;
}

setup_grenade_powerups()
{
	if (self.model == "xmodel/ammo_stielhandgranate1")
	{
		precacheItem("item_ammo_stielhandgranate_open");
		item = spawn("item_ammo_stielhandgranate_open", self.origin + (0, 0, 1), 1); // suspended
	}
	else if (self.model == "xmodel/ammo_stielhandgranate2")
	{
		precacheItem("item_ammo_stielhandgranate_closed");
		item = spawn("item_ammo_stielhandgranate_closed", self.origin + (0, 0, 1), 1); // suspended
	}

	item.angles = self.angles;

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

	for (;;)
	{
		self waittill("trigger");
		if (!spawner.count)
			return;
		if (self.target != spawner.targetname)
			return; // manually disconnected
		spawner doSpawn();
		if (self.Wait > 0)
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
infinite_panzerfaust ( trigger )
{
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
		if (models[i].model == "xmodel/ammo_panzerfaust_box2_objective")
		{
			boxObj = models[i];
			boxObj setmodel ("xmodel/ammo_panzerfaust_box2");
			continue;
		}

		slotSpots[slotSpots.size] = models[i];
	}
	models = undefined;

	if (!isdefined (weaponObj))
		maps\_utility::error ("infinity panzers at ", trigger getorigin(), " has no weapon model");

	if (!isdefined (boxObj))
		maps\_utility::error ("infinity panzers at ", trigger getorigin(), " has no ammo box model");

	if (!slotSpots.size)
		maps\_utility::error ("infinity panzers at ", trigger getorigin(), " has no weapon slots");

	// Create empty spots to put new guns
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
	level thread infinite_panzerfaust_modelswap (trigger, weaponObj, boxObj);
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

		level notify ("picked up infinite panzerfaust");
		trigger notify ("infinite panzerfaust objective off");

		playerWeapon[0] = level.player getweaponslotweapon("primary");
		playerWeapon[1] = level.player getweaponslotweapon("primaryb");
		if (playerWeapon[0] == "panzerfaust")
		{
			level.player switchToWeapon("panzerfaust");
			continue;
		}
		if (playerWeapon[1] == "panzerfaust")
		{
			level.player switchToWeapon("panzerfaust");
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
	
				weaponClassname = getWeaponClassname (weapon);
	
				gun = spawn (weaponClassname, (0,0,0));
				gun.origin = slots[i].origin;
				gun.angles = slots[i].angles;
	
				gun linkto (slots[i]);
				slots[i].groundWeapon = gun;
				break;
			}
		}

		level.player takeWeapon(weapon);
		level.player giveWeapon("panzerfaust");
		level.player switchToWeapon("panzerfaust");
	}
}

infinite_panzerfaust_modelswap (trigger, weaponObj, boxObj)
{
	while (1)
	{
		trigger waittill ("infinite panzerfaust objective on");
		weaponObj setmodel ("xmodel/weapon_panzerfaust_objective");
		boxObj setmodel ("xmodel/ammo_panzerfaust_box2_objective");

		trigger waittill ("infinite panzerfaust objective off");
		weaponObj setmodel ("xmodel/weapon_panzerfaust");
		boxObj setmodel ("xmodel/ammo_panzerfaust_box2");
	}
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
