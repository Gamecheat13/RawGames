#using_animtree("generic_human");

main()
{
	setCvar("cg_draw2d", "1");
	setCvar("cg_drawgun", "1");

	// Set the shaders to use on the dead player screen and mission success screen
	setCvar("cg_deadscreen_backdrop", "levelshots/deadscreen/american.jpg");
	setCvar("cg_deadscreen_levelname", "levelshots/deadscreen/hud@burnville.tga");
	setCvar("cg_victoryscreen_backdrop", "levelshots/missionsucess/american.jpg");
	setCvar("cg_victoryscreen_levelname", "levelshots/deadscreen/hud@burnville.tga");


	maps\burnville_fx::main();
	maps\burnville_anim::main();
	maps\burnville_export::main();
	character\Airborne3d_garand::precache();
	
	level.friendlywave_thread = maps\burnville::reach_goal;

//	level.mortar = loadfx ("fx/surfacehits/mortarImpact.efx");
//	level.mortar = loadfx ("fx/impacts/newimps/blast_gen3.efx");
	level.mortar = loadfx ("fx/impacts/newimps/minefield_dark.efx");
//	level.mortar = loadfx ("fx/impacts/newimps/minefield.efx");

//	getent ("36","export") delete();
	maps\_load::main();
	maps\_wood::main();
	maps\_mortar::main();
	maps\_panzer::main();
//	maps\_mg42::main();
	level.player.threatbias = -2;
//	level.player.threatbias = -20000;

	maps\_utility::precache ("xmodel/fallschirmjager_officer");
	maps\_utility::precache ("xmodel/woodgib_medium");
	maps\_utility::precache ("xmodel/woodgib_big");
	maps\_utility::precache ("xmodel/woodgib_small1");
	maps\_utility::precache ("xmodel/woodgib_small2");
	maps\_utility::precache ("xmodel/c47");
	maps\_utility::precache ("xmodel/parachute_animrig_churchguy");

	level thread pre_drag_node((getnodearray ("drag_guy","targetname"))[0]); // dragged guy idle
	level thread church_guy (getent ("church guy","targetname"));
	maps\_utility::array_levelthread (getentarray ("blocker","targetname"), ::hide_this);	

	//thread temp();
//	thread temp_bullet();	
	ambientPlay("ambient_burnville"); // AMBIENT SOUNDTRACK
	 
//	thread temp_kill_shield();


//	triggers = getentarray ("trigger_multiple", "classname");
//	maps\_utility::array_thread(triggers, ::officer_spawn);
	
	level.flag["not pacifist"] = false;
	level.flag["lets go"] = false;
	level.flag["attacked"] = false;
//	level.flag["player_wait"] = false;
	level.flag["blocker mg42s cleared"] = false;
	level.flag["flanked"] = false;
	level.flag["flak1"] = false;
	level.flag["flak2"] = false;
	level.flag["flak3"] = false;
	level.flag["flak1"+"bomb placed"] = false;
	level.flag["flak2"+"bomb placed"] = false;
	level.flag["flak3"+"bomb placed"] = false;
	level.flag["foley base of fire"] = false;
	level.flag["level complete"] = false;
	

	foley = getent ("foley","targetname");
	foley.animname = "foley";
	foley character\_utility::new();
	foley character\foley::main();
	foley thread maps\_utility::magic_bullet_shield();
	foley thread baseOfFireFlag();
	
// 	wood = getentarray ("wood_splinter","targetname");
//	maps\_utility::array_thread(wood, ::wood_think);
	
	level.flaks_remaining = 3;
	maps\_utility::chain_off ("50");
	maps\_utility::chain_off ("55");
//	maps\_utility::chain_on ("23");
    
//	if (getcvar("start") == "go")
//	{
//		playerstart = getent ("playerstart","targetname");
//		playerstart delete();
//	}
	if (getcvar("start") == "mid")
		level.player setorigin ( (-1490, -18784, 104) );
	if (getcvar("start") == "mg42")
	{
		level.player setorigin ( (-1084, -16629, 60) );
		foley teleport ((-808, -15941, -8));
		foley.health = 12000; // Foley gets lots of health
	}
	if (getcvar("start") == "finale")
	{
		level.player setorigin ( (662, -17197, 58) );
		foley teleport ((534, -17175, 54));
		foley.health = 12000; // Foley gets lots of health
	}

	if (getcvar("start") == "end")
	{
		friends = getaiarray ("allies");
		for (i=0;i<friends.size;i++)
		{
			if (isdefined (friends[i].targetname))
			{
				if (friends[i].targetname != "foley")
					friends[i] delete();
			}
			else
				friends[i] delete();
		}
		
		maps\_utility::chain_on ("50");
		maps\_utility::chain_on ("55");
		level.flaks_remaining = 1;
		foley teleport ((1998, -16447, 44));
		level.player setorigin ( (1936, -16400, 64) );
		foley.health = 12000; // Foley gets lots of health
		level.flag["flak1"] = true;
		level.flag["flak2"] = true;
		level notify ("wood_time");
	}

	thread objectives();

		
	exclude = [];
	dragger = getent ("dragger","targetname");
	if (isalive (dragger))
		exclude[exclude.size] = dragger;

	dragged = getent ("dragged","targetname");
	if (isalive (dragged))
		exclude[exclude.size] = dragged;
		
	friends = getaiarray ("allies");
	maps\_utility::array_levelthread(friends, ::reach_goal, undefined, exclude);

//	getent ("player_wait","targetname") thread player_wait();
	getent ("last_friendly_chain","targetname") thread last_friendly_chain();
	getent ("halftrack_gunner", "targetname") thread halftrack_gunner();
	getent ("halftrack_mg42","targetname") thread halftrack_mg42(getent ("halftrack_gunner", "targetname"));
//	getent ("halftrack_kill","targetname") thread halftrack_kill(getent ("halftrack_gunner", "targetname"));
	level thread dead_enemy_check(getent ("dead_enemy_check","targetname"));
	level thread foley_mg42	(getent ("foley_mg42","targetname"));
	level thread enemy_fired(getent ("enemy_fired","targetname"));
	level thread flak_dialogue();
	level thread friendlyChain55Off(getent("auto679","target"));
	level thread mortarStop(getent ("stop falling mortars","script_noteworthy"));
	
	level thread cantCrouchGuy (getent ("stay standing","script_noteworthy"));
	thread airplane();


	// Handles guys axis left behind after 2nd flak
	thread chase_trigger( getent ("chase player","targetname"));



//	getent ("mg42_endgunner","targetname") thread mg42_endgunner();

//	level thread kill_a_friend(getent ("kill_a_friend", "targetname"));
//	getent ("kill_a_friend_go", "targetname") thread kill_a_friend_go();
//	thread friendly_gets_killed();

	maps\_utility::chain_off ("20");
	maps\_utility::chain_off ("40");
	maps\_utility::chain_off ("60");
	maps\_utility::chain_off ("100");
	
	thread transition_house();
	
	thread cow_safety_master();
	cow_damage_triggers = getentarray ("cow_sound", "targetname");
	for (i=0;i<cow_damage_triggers.size;i++)
		cow_damage_triggers[i] thread cow_damage_triggers();	
	getent ("start_moving","targetname") thread start_moving();
	getent ("trigger_special_mortar", "targetname") thread trigger_special_mortar();
	getent ("trenchguy1", "targetname") thread trench_runner( getnode ("trenchguy1_node", "targetname") );
	thread mg42_lockon_release();

	return;
	wait (6);	
	thread maps\_utility::save_friendlies();	
	missionSuccess ("dawnville", true);
}

hide_this (ent)
{
	ent hide();
}

friendlyChain55Off(trigger)
{
	trigger waittill ("trigger");
	trigger delete();
//	trigger maps\_utility::triggerOff();
}

mortarStop (trigger)
{
	trigger waittill ("trigger");
	level notify ("stop falling mortars");
}

transition_house()
{
	trigger = getent ("transition trigger","script_noteworthy");
	trigger waittill ("trigger");
	maps\_utility::chain_off ("20");
	wait (1);
	transTrigger = getent ("transition house","targetname");
	// Script stops here until all the AI of a given team are dead
	println ("^4 waiting for ai to die");
	maps\_utility::living_ai_wait (transTrigger, "axis");
	println ("^4 ai died");
//	maps\_utility::chain_on ("23");
	chain = maps\_utility::get_friendly_chain_node ("23");
	level.player SetFriendlyChain (chain);
}

church_guy ( Trigger )
{
	trigger waittill ("trigger");
	trigger delete();
	
	guy = spawn ("script_model",(0,0,0));
	guy.animname = "tree_guy";
	guy character\_utility::new();
	guy character\Airborne3d_garand::main();
	guy assignanimtree();

	parachute = spawn ("script_model",(0,0,0));
	parachute.animname = "parachute";
	parachute setmodel ("xmodel/parachute_animrig_churchguy");
	parachute assignanimtree();
	
	node = getnode ("parachute guy","targetname");
	array[0] = guy;
	array[1] = parachute;
	guy.origin = node.origin;
	parachute.origin = node.origin;
	level thread anim_loop ( array, "idle", undefined, undefined, node);
}

/////////////////

// Handles guys axis left behind after 2nd flak
chase_trigger( trigger )
{
	trigger waittill ("trigger");
	volume = getent (trigger.target,"targetname");
	ai = getaiarray ("axis");
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] istouching (volume))
		{
			ai[i] setgoalentity (level.player);
			ai[i].goalradius = 384;
		}
	}
	
	volume delete();
	trigger delete();
}

baseOfFireFlag ()
{
	self waittill ("base of fire");
	flag_set("foley base of fire");
}

cow_damage_triggers ()
{
	while (1)
	{
		self waittill ("trigger");
		self playsound ("bullet_cow");
	}
}


trench_runner (node)
{
	self.intro_no_crouch = true;
	wait 1;
	self setgoalnode (node);
}

start_moving ()
{
	self waittill ("trigger");
	flag_set ("lets go");
}

trigger_special_mortar ()
{
	mortar = getent (self.target, "targetname");
	mortar maps\_mortar::setup_mortar_terrain();
	
	self waittill ("trigger");
	
	mortar maps\_mortar::activate_mortar();
}

cantCrouchGuy ( spawner )
{
	spawner waittill ("spawned",spawn);
	if (maps\_utility::spawn_failed(spawn))
		return;
		
	spawn allowedstances ("stand");
}


///////////////////////////////////////////

cow_safety_master ()
{
	level.release_lockon = false;
	cow_triggers = getentarray ("mg42cover_cow", "targetname");
	for (i=0;i<cow_triggers.size;i++)
		cow_triggers[i] thread cow_safety_triggers();
	
	while (1)
	{
		wait .2;
		if (level.release_lockon == true)
		{
			level.player.ignoreme = true;
			continue;
		}
		
		if (isdefined (level.player_covertrigger) )
		{
			if ( (level.player getstance() == "crouch") || (level.player getstance() == "prone") )
				level.player.ignoreme = true;
			else
			{	
				if (!level.player.shellshocked)
					level.player.ignoreme = false;
			}
			
			continue;
		}
		
		if (!level.player.shellshocked)
		{
			level.player.ignoreme = false;
			continue;
		}
	}
}


cow_safety_triggers()
{
//	println (getbrushmodelcenter(self), " with covertype ", covertype);
	while (1)
	{
		level.player_covertrigger = undefined;
		self waittill ("trigger");
		//level.player_covertype = covertype;
		while (level.player istouching (self))
		{
			level.player_covertrigger = self;
			wait .5;
		}
	}
}

mg42_lockon_release()
{
	i = 0;
	level.release_lockon = false;
	
	while (1)
	{
		timer = gettime() + 1000;
		
		level.player waittill ("damage");
		
		if (timer > gettime())
		{
			i++;
		}
		else
		{
			i = 0;
		}
		
		if (i > 6)
		{
			level.release_lockon = true;
		//	println  ("z:              releasing lock down");
			wait (2 + randomfloat (1) );
		//	println  ("z:              releasing ignoreme");
			level.release_lockon = false;
		}
		else
		{
			level.release_lockon = false;
		}
		wait (.2);
	}
}


/////////////////////////////////////////////


officer_spawn ()
{
	if (!isdefined (self.target))
		return;

	spawners = getentarray (self.target, "targetname");
	for (i=0;i<spawners.size;i++)
	{
		if ((isdefined (spawners[i].model)) && (spawners[i].model == "xmodel/fallschirmjager_soldier"))
		{
			if (!isdefined (ents))
				ents[0] = spawners[i];
			else
				ents[ents.size] = spawners[i];
		}
	}
	
	if (!isdefined (ents))
		return;
		
	if (ents.size < 3)
		return;

	for (i=0;i<ents.size;i++)
		ents[i] thread ents_think();
	self waittill ("trigger");
	wait (0.01);
	for (i=0;i<ents.size;i++)
	{
		if ((isdefined (ents[i])) && (isdefined (ents[i].spawned)) && (isalive (ents[i].spawned)) && (ents[i].spawned.weapon == "mp40"))
		{
			ents[i].spawned setmodel ("xmodel/fallschirmjager_officer");
			return;
		}
	}
		
//	ents[0] setmodel ("xmodel/fallschirmjager_officer");
//	ents[0] thread ents_think();
}

ents_think ()
{
	self waittill ("spawned",other);
	self.spawned = other;
	
//	println ("SPAWNED");
//	other animscripts\shared::putGunInHand ("none");
//	other.weapon = "mp40";
//	other attach("xmodel/weapon_mp40", "tag_weapon_right");	
}

/*
	ents[0].weapon = "mp40";
	
	return;
	
	for (i=0;i<ents.size;i++)
	{
		if ((i == ents.size-1))
		{
			ents[i] setmodel ("xmodel/fallschirmjager_officer");
			ents[i].weapon = "mp40";
			return;
		}
		else
			println ("weapon ", ents[i].weapon);
	}
}
*/

last_friendly_chain()
{
	self waittill ("trigger");
	ent = getent (self.target,"targetname");
	maps\_utility::living_ai_wait (ent,"axis");
	if (!flag ("level complete"))
		maps\_utility::chain_on ("100");
	ent delete();
	self delete();
}

mg42_endgunner()
{
	spawner = getent (self.target,"targetname");
	spawner waittill ("spawned", guy);
	node = getnode (spawner.target,"targetname");

	turret = getent (node.target, "targetname");
	guy setgoalnode(node);
	guy.goalradius = (4);
	guy waittill ("goal");
	guy useturret(turret); // dude should be near the mg42
	turret setmode("auto_ai"); // auto, auto_ai, manual

	turret setmode("manual_ai"); // auto, auto_ai, manual
	guy thread maps\_mg42::mg42_firing(turret);
//	turret settargetentity(level.player);
	turret notify ("startfiring");
	
	trigger = getent (turret.target, "targetname");
	guy endon ("death");
	foley = getent ("foley","targetname");
	
	while (1)
	{
		trigger waittill ("trigger",other);
		if ((isSentient (other)) && (other.team == "allies") && (other != foley))
			turret settargetentity(level.player);
	}

}

temp_bullet()
{
	foley = getent ("foley","targetname");
	
	while (1)
	{
//		ai = getaiarray ("axis");
//		if (isdefined (
		magicbullet ("mp40", level.player getorigin() + (10,10,100),level.player getorigin() + (0,0,20) );
		wait (0.1);
	}
}


temp_kill_shield()
{
	ents = getentarray ("script_model","classname");
	for (i=0;i<ents.size;i++)
	{
		if (ents[i].model == "xmodel/vehicle_halftrack_shield")
			ents[i] delete();
	}
}

foley_stopIdling ( foley )
{
	level waittill ("blocker mg42s cleared");
	foley notify ("stop idle");
}

foley_mg42 (trigger)
{
	trigger waittill ("trigger");
	if (flag("blocker mg42s cleared"))
		return;
		
	level endon ("blocker mg42s cleared");
	
	node = getnode (trigger.target,"targetname");
	trigger delete();

	foley = getent ("foley","targetname");
	level thread foley_stopIdling(foley);
	guy[0] = foley;

	anim_reach (guy, "wave", undefined, node);
	foley animscripts\shared::putguninhand("left");

	while (1)
	{
		foley thread anim_loop ( guy, "idle", undefined, "stop idle", node);
		
		while (distance (level.player getorigin(), foley.origin) > 200)
			wait (0.15);
			
		foley lookat(level.player, 2);
		
		foley notify ("stop idle");		
		anim_single (guy, "wave", undefined, node);
		foley thread anim_loop ( guy, "idle", undefined, "stop idle", node);
		wait (0.35); // 1.5
		
		if (distance (level.player getorigin(), foley.origin) < 210)
		{
			foley notify ("stop idle");		
			foley lookat(level.player, 2);
			anim_single (guy, "flank mg42s", undefined, node);
			foley thread anim_loop ( guy, "idle", undefined, "stop idle", node);
		}

		while (distance (level.player getorigin(), foley.origin) < 210)
		{
			if (randomint (20) == 0)
				foley lookat(level.player, 2);
			
			wait (0.15);
		}
	
		while (distance (level.player getorigin(), foley.origin) > 200)
		{
			if (randomint (20) == 0)
				foley lookat(level.player, 2);
			wait (0.15);
		}

		foley lookat(level.player, 3);
		
		foley notify ("stop idle");		
		anim_single (guy, "check church", undefined, node);
	}
}

dead_enemy_check(trigger)
{	
	thread blocker_mg42s_master();
	
	blocker_mg42_1 = getent ("blocker_mg42_1", "targetname");
	if (isdefined (blocker_mg42_1))
		blocker_mg42_1 thread blocker_mg42s_disconnect();
	
	blocker_mg42_2 = getent ("blocker_mg42_2", "targetname");
	if (isdefined (blocker_mg42_2))
		blocker_mg42_2 thread blocker_mg42s_disconnect();
	
	trigger waittill ("trigger");
	maps\_utility::living_ai_wait (trigger,"axis");
	flag_set("blocker mg42s cleared");
}

blocker_mg42s_disconnect()
{
	self waittill("turretownerchange");

	while (1)
	{	
		user = self getTurretOwner();
		if (isdefined (user))
			self waittill("turretownerchange");
		else
			break;
	}
	
	if (!isdefined (level.remaining_blockers))
		level.remaining_blockers = 1;
	else
		flag_set ("blocker mg42s cleared");
}
	
blocker_mg42s_master()
{	
	flag_wait ("blocker mg42s cleared");
	
//	maps\_utility::chain_on ("40");
	maps\_utility::chain_off ("30");
	
	chain = maps\_utility::get_friendly_chain_node ("40");
	level.player SetFriendlyChain (chain);
	
	foley = getent ("foley","targetname");
	if (isalive (foley))
	{
		level.flag["flanked"] = true;
		foley setgoalentity (level.player);
		foley.goalradius = 32;// 400;
	}
}

friendly_gets_killed()
{
	friendlydeath = getent ("friendlydeath", "targetname");
	friendlydeath thread friendlydeath_gag();
	spawn = getent (friendlydeath.target, "targetname");
	spawn waittill ("spawned", friendlydeath_spawned);
	level.friendlydeath_spawned = friendlydeath_spawned;
	friendlydeath_spawned waittill ("death");
	door = getent (spawn.target, "targetname");
//	wait (1);
	door rotateyaw(-80, 0.3,0,0.3);

}

flak_dialogue ()
{
	foley = getent ("foley","targetname");
	
//	23a. Martin, plant your explosives and take that Flakpanzer out.
	level flak_dialogue_think (getent ("flak 1","targetname"), "flak1", "plant explosives");
	wait (0.5);
//	24. Okay. Move, move!
	foley anim_single_queue(foley, "move move");
	
	if (!flag ("flak2"))
	{
//		25c. Ya did good son, blow 'er up!
		level flak_dialogue_think (getent ("flak 2","targetname"), "flak2", "blow her up", getent ("flak 2 enemies", "targetname"));
		if (!flag ("flak3"))
		{
			//	26. There's one more, get your butt movin'!
			foley anim_single_queue(foley, "1 more");
		}
	}
	
	if (!flag ("flak3"))
	{
//		28. Martin! Explosives, go!
		level flak_dialogue_think (getent ("flak 3","targetname"), "flak3", "explosives go");
	}
}
	
flakAIthink (optionalEnemyTrigger)
{
	println ("waiting for all ai to die..");
	maps\_utility::living_ai_wait (optionalEnemyTrigger, "axis");
	println ("..all ai dead!");
	level notify ("killed the ai");
}
	
flak_dialogue_think ( trigger, obj, msg, optionalEnemyTrigger )
{
	foley = getent ("foley","targetname");
	while (1)
	{
		trigger waittill ("trigger", other);
		if (other == level.player)
			break;
	}
		
	trigger delete();
	
	// This objective is already completed
	if (flag (obj))
		return;

	// Script stops here until all the AI of a given team are dead
	if (isdefined (optionalEnemyTrigger))
	{
		thread flakAIthink(optionalEnemyTrigger);
		waittill_either (level, obj + "bomb placed", "killed the ai");
	}

//	thread flak_idle(obj, msg);
	if (!flag(obj + "bomb placed"))
		foley anim_single_queue(foley, msg);
		
	if ((!flag ("flak1")) && (!flag ("flak2")) && (!flag ("flak3")))
		iprintlnbold (&"SCRIPT_GLOWING_MARKER");
	
	bombPlaced = level.flag[obj + "bomb placed"];
	flag_wait (obj + "bomb placed");
	makeAICrouch (getent ("crouch","targetname"));
//	23b. Stand back! Fire in the hole!
	if (!bombPlaced)
		foley anim_single_queue(foley, "fire in the hole");

	flag_wait (obj);
}

flak_idle (msg, anime)
{
	foley = getent ("foley","targetname");
	level endon (msg);
	level endon (msg + "bomb placed");
//	while (1)
	{
		foley anim_single_queue(foley, anime);
		wait ((4) + randomint(4));
	}
}

makeAICrouch ( trigger )
{
	ai = getaiarray ("allies");
	crouchers = [];
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] istouching (trigger))
			crouchers[crouchers.size] = ai[i];
	}
	
	maps\_utility::array_thread( crouchers, ::croucherThink);
}

croucherThink ()
{
	self endon ("death");

	if (randomint(100) < 50)
	{
		crouch2hide = %grenadehide_crouch2left;
		hideloop =  %grenadehide_left;
		self.anim_grenadeCowerSide = "left";
	}
	else
	{
		crouch2hide = %grenadehide_crouch2right;
		hideloop =  %grenadehide_right;
		self.anim_grenadeCowerSide = "right";
	}
	
	if (self.anim_pose == "crouch")
		self setFlaggedAnimKnoballRestart("hideanim",crouch2hide, %body, 1, .1, 1);
	else
	if (self.anim_pose == "stand")
	{
		self setFlaggedAnimKnoballRestart("hideanim",crouch2hide, %body, 1, .4, 1);
		self.anim_pose = "crouch";
	}
	else
		return;
			
	self.anim_movement = "stop";
	
	animscripts\shared::DoNoteTracks("hideanim");
	self setAnimKnoballRestart(hideloop, %body, 1, .1, 1);
}

objective_wait (str)
{
	level waittill (str);
	flag_set (str);

	level notify ("objective");
	level.flaks_remaining--;

	if (str == "flak1")
	{
		maps\_utility::chain_on ("50");
		if ((!flag("flak2")) && (!flag("flak3")))
		{
			chain = maps\_utility::get_friendly_chain_node ("50");
			level.player SetFriendlyChain (chain);
		}		
		else
		if ((flag("flak2")) && (!flag("flak3")))
		{
			chain = maps\_utility::get_friendly_chain_node ("50");
			level.player SetFriendlyChain (chain);
			maps\_utility::chain_on ("55");
		}		
	}
	if (str == "flak2")
	{
		if (flag("flak1"))
			maps\_utility::chain_on ("55");
	}
	if (str == "flak3")
	{
		waves = getentarray ("friendly_wave","targetname");
		for (i=0;i<waves.size;i++)
			waves[i] delete();
		
		ai = getaiarray ("axis");
		for (i=0;i<ai.size;i++)
			ai[i] DoDamage ( ai[i].health + 50, ai[i].origin );

		spawners = getspawnerarray();
		for (i=0;i<spawners.size;i++)
			spawners[i].count = 0;
	}
}

objective_setflakstring(index)
{
//	objective_string(index, &"SCRIPT_OBJ_DESTROYFLAKPANZERS", " ("+ level.flaks_remaining + " ", &"SCRIPT_OBJ_REMAINING", ")");
	objective_string(index, &"SCRIPT_OBJ_DESTROYFLAKPANZERS", level.flaks_remaining);
}

objectives()
{
	if (getcvar("start") != "finale")
	{
		objective_add(1, "active", "", (459, -15075, -3));
		objective_setflakstring(1);
		objective_current(1);
		thread objective_wait ("flak1");
		thread objective_wait ("flak2");
		thread objective_wait ("flak3");
		
		while (1)
		{
			level waittill ("objective");
			println ("updating text");
			if (!flag("flak1"))
			{
				objective_add(1, "active", "", (459, -15075, -3));
				objective_setflakstring(1);
			}
			else if (!flag("flak2"))
			{
				objective_add(1, "active", "", (2501, -15662, -17));
				objective_setflakstring(1);
			}
			else if (!flag("flak3"))
			{
				objective_add(1, "active", "", (1291, -17422, 16));
				objective_setflakstring(1);
			}
			else
				break;

			objective_current(1);
		}
    }
    else
    {
		maps\_utility::chain_on ("40");
		wait (2);
	}

	objective_add(1, "active", "", (1291, -17422, 16));
	objective_setflakstring(1);
	objective_state(1, "done");
	
	foley = getent ("foley","targetname");
	while (1)
	{
		breaker = true;
		ai = getaiarray ("axis");
//		println ("size ", ai.size);
		for (i=0;i<ai.size;i++)
		{
			if (!isalive (ai[i]))
				continue;
				
			if (distance (level.player getorigin(), ai[i].origin) > 1800)
				continue;
				
			breaker = false;
			break;
		}
		
		if (breaker)
			break;
			
		wait (2);
	}
	
	thread ending_sounds();
	
	node = getnode ("foley_finale","targetname");
	objective_add(2, "active", &"SCRIPT_OBJ_FOLEYDEBRIEF", node.origin + (0,150,0));
	objective_current(2);

	maps\_utility::chain_on ("60");
	maps\_utility::chain_off ("100");
	flag_set ("level complete");

	foley setgoalnode (node);
	foley.goalradius = 32;
	foley waittill ("goal");
	while (distance (level.player getorigin(), foley.origin) > 400)
		wait (1);

/*	
	29. All right fellas, take five, but listen up. We'll hold this place till reinforced, but this is just
	one tiny village in a war and country full of 'em, so our work has just begun. For those of you who've
	seen your first action, welcome to the Big Time. For those of you who've seen it before, trust me, you ain't seen
	nothing yet. We'll redeploy those German machine guns, setting up a perimeter. Keep your guard up and your buddies
	in mind.  Good work.
*/ 	


//	foley thread maps\_scripted::main ("check_ammo", "foley");
//	foley waittill ("check_ammo");
//	wait (1.5);
	foley animscripts\shared::putguninhand("right");
	foley thread foley_looks_around();
	
	guy[0] = foley;
	// Sounds that play in the distance
	anim_reach (guy, "finale", undefined, node);
	level notify ("foley talks");
	musicPlay("burnville_speech");
	foley anim_single_solo (foley, "finale", undefined, node);
	
	wait (1.2);
//	anim_single_solo (foley, "finale 2", undefined, node);
//	anim_single_solo (foley, "finale 3", undefined, node);
//	anim_single_solo (foley, "finale 2", undefined, node);
	
//	foley thread maps\_scripted::main ("foley_finale", "foley", "foley_finale");
//	foley waittill ("foley_finale");
//	foley thread maps\_scripted::main ("foley_finale2", "foley", "foley_finale");
//	foley waittill ("foley_finale2");
//	wait (28);
	iprintlnbold (&"SCRIPT_MISSIONCOMPLETE");
	objective_state(2, "done");
	//changelevel(<mapname>, <persistent> = false);
	//persistent: if you want the player to keep their inventory through the transition.

	//changelevel("burnville", false);
	thread maps\_utility::save_friendlies();	
	missionSuccess ("dawnville", true);
	
//	607 -15101 -73, 2492 -15771 -64, 1291 -17422 16
}

// Sounds that play in the distance
ending_sounds ()
{
	level endon ("foley talks");
	wait (2);
	level maps\_utility::playSoundinSpace ("burnville_end_distantfriendly1", level.player.origin + (500,400, 50));
	wait (0.5);
	level maps\_utility::playSoundinSpace ("burnville_end_distantfriendly2", level.player.origin + (300,400, 50));
	wait (0.25);
	level maps\_utility::playSoundinSpace ("burnville_end_distantfriendly3", level.player.origin + (-500,400, 50));
	wait (1.5);
	level maps\_utility::playSoundinSpace ("burnville_end_distantfriendly4", level.player.origin + (500,-400, 50));
	wait (0.5);
	level maps\_utility::playSoundinSpace ("burnville_end_distantfriendly5", level.player.origin + (-500,-400, 50));
	/*
	wait (4);
	dist = 80;
	for (i=0;i<5;i++)
	{
		if (randomint(100) > 50)
			mult1 = -1;
		else
			mult1 = 1;

		if (randomint(100) > 50)
			mult2 = -1;
		else
			mult2 = 1;
		
		p = randomint (dist);
		org = level.player.origin + (p*mult1, (dist - p)*mult2, 50);
		println ("^3-----------------");
		println ("player org ", level.player.origin);
		println ("combined: ", level.player.origin + (p*mult1, (dist - p)*mult2, 50));
		println ("playing sound in space ", "burnville_end_distantfriendly" + (i + 1), " at origin ", org);
		println ("org is ", org);
		level thread maps\_utility::playSoundinSpace ("burnville_end_distantfriendly" + (i + 1), org);
		wait (3 + randomfloat (5));
	}	
	*/
}

foley_looks_around()
{
	ai = getaiarray ("allies");	
	
//	self lookat(level.player, 1, "casual");
	self lookat(level.player, 1);
	wait 1;
	for (i=0;i<ai.size;i++)
	{
		time = (.6 + randomfloat (.8));
		if (isalive (ai[i]))
		{
			self lookat(ai[i], time);
			wait (time);
		}
	}
	self lookat(level.player, 1);
	wait 1;
}


/*
get_to_point (org)
{
	self thread death_notify();
	self notify ("break_from_tradition");
	self.oldinterval = self.interval;
	self.interval = 0;
	self setgoalpos (org);
	self.goalradius = 32;
	self waittill ("goal");
	self notify ("finished");
}

death_notify ()
{
	self waittill ("death");
	self notify ("finished");
}
*/

pre_drag_node(node)
{
	drag_guys = getentarray (node.target,"targetname");
	println ("drag_Guys size ", drag_guys.size);
	
	org = getStartOrigin (node.origin, node.angles, %wounded_dragged_start);
	dragged = drag_guys[0];
	dragged.targetname = "dragged";
	dragged.ignoreme = true;
	dragged setgoalpos (org);
	dragged.goalradius = 32;
	dragged.health = 50000;
	dragged notify ("break_from_tradition");
	dragged thread drag_idle(node, %wounded_dragged_idle);
	
	org = getStartOrigin (node.origin, node.angles, %wounded_dragger_start);
	dragger = drag_guys[1];
	dragger.targetname = "dragger";
	dragger.ignoreme = true;
	dragger setgoalpos (org);
	dragger.goalradius = 32;
	dragger.health = 50000;
	dragger notify ("break_from_tradition");
	dragger thread drag_idle(node, %wounded_dragger_idle);
}


drag_node(node)
{
	drag_guys = getentarray (node.target,"targetname");

	dragged = getent ("dragged","targetname");
	if (!isAlive(dragged))
		return;
	
	dragger = getent ("dragger","targetname");
	if (!isAlive(dragger))
		return;
	
	org = getStartOrigin (node.origin, node.angles, %wounded_dragger_start);
	dragger allowedStances ("crouch");
	dragger.targetname = "dragger";
	dragged.targetname = "dragged";
	dragged thread drag_death( dragger );
	dragger thread drag_death( dragged );
	dragger thread newgoal();
//	dragged thread newgoal();
	dragger endon ("death");
	dragged endon ("death");
	dragged.health = 100;
	dragged.maxhealth = dragged.health * 20;
	dragger.health = 100;

	offset = (0, 0, 0);

//	dragged thread dragging_sequence_dialog(dragger);

	level notify ("drag_time");
	dragger thread drag_mg42();

	while (dragger.origin[0] < 560)
	{
		dragger animscripted("scriptedanimdone", node.origin + offset, node.angles, %wounded_dragger_cycle);
		dragged animscripted("scriptedanimdone", node.origin + offset, node.angles, %wounded_dragged_cycle);
		dragger.deathanim = %wounded_dragger_death;
		dragged.deathanim = %wounded_dragged_death;
		dragger.allowDeath = 1;
		dragged.allowDeath = 1;
		dragger waittill ("scriptedanimdone");
		offset += getCycleOriginOffset(node.angles, %wounded_dragger_cycle);
	}

	org = node.origin + offset;
	dragger animscripted("scriptedanimdone", org, node.angles, %wounded_dragger_end);
	dragged animscripted("scriptedanimdone", org, node.angles, %wounded_dragged_end);
	dragger.allowDeath = 1;
	dragged.allowDeath = 1;
	dragger waittill ("scriptedanimdone");

	dragged notify ("made_it");
	dragger notify ("made_it");
	dragger.pacifist = false;
	dragged.pacifist = false;
	dragged thread dragged_end_idle(org,node);
}	

dragging_sequence_dialog(dragger)
{
	self endon ("death");
	dragger endon ("death");
	
	while ( (distance (level.player getorigin(), self.origin) ) > 750 )
	{
		wait 1;
	}
	
//	self playsound ("Trained_misc", "sounddone");
	self waittill ("sounddone");
	
	wait .2;
//	dragger playsound ("Friendly_misc1");
	
	
	dragger waittill ("made_it");
//	dragger playsound ("Friendly_misc2");
}


dragged_end_idle(org,node)
{
	self.health = 100;
	self.maxhealth = self.health * 20;
	while (distance (self.origin, level.player.origin) < 1800)
	{
		self animscripted("scriptedanimdone", org, node.angles, %wounded_dragged_endidle);
		self.allowDeath = 1;
		self waittill ("scriptedanimdone");
	}
	self delete();
}

newgoal()
{
	self waittill ("made_it");
	self.deathanim = undefined;
	self setgoalentity (level.player);
	self.goalradius = 32; //400;
	self.health = 400;
}


drag_death(otherguy)
{
	self endon ("made_it");
	otherguy waittill ("death");
//	radiusDamage ( self.origin, 2, 15000, 15000);
	self.health = 1;
	self kill_guy ();
}

kill_guy()
{

	self DoDamage ( self.health + 50, self.origin );
	return;
	
	ai = getaiarray ("axis");
	for (i=0;i<ai.size;i++)
	{
		magicbullet ("mp40", self.origin + (10,10,100), self.origin + (0,0,20) );
		if (!isalive (self))
			return;
	}
}

drag_idle(node, anima)
{
	level endon ("drag_time");
	while (1)
	{
		self animscripted("scriptedanimdone", node.origin, node.angles, anima);
		self waittill ("scriptedanimdone");
	}	
}

get_mg42guys()
{
	ai = getaiarray ("axis");

	for (i=0;i<ai.size;i++)
	if ((isdefined (ai[i].script_sequence)) && (ai[i].script_sequence == "drag_guy"))
	{
		if (isdefined (ai[i].target))
		{
			node = getnode (ai[i].target,"targetname");
			if ((isdefined (node)) && (isdefined (node.target)))
			{
				turret = getent (node.target, "targetname");
				if ((isdefined (turret)) && (turret.classname == "misc_mg42"))
				{
					if (!isdefined (ents))
						ents[0] = turret;
					else
						ents[ents.size] = turret;
				}
				
			}
		}
	}
	
	if (isdefined (ents))
		return ents;
}

dragger_end (dragger, mg42, targ_org)
{
	dragger waittill ("death");
	mg42.script_delay_min = 2;
	mg42.script_delay_max = 3;
	mg42.script_burst_min = 0.5;
	mg42.script_burst_max = 1.2;
	mg42 notify ("stopfiring");
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	
	if (isdefined (targ_org))
		targ_org delete();
}


drag_mg42()
{
	spawner = getent ("drag_spawner","targetname");
	if (!isdefined (spawner))
		return;
		
	spawner endon("death");		
	
	num = 450; // was 500
//	targ_org setmodel ("xmodel/temp");
	
	count = 0;
	oldcount = 0;
	while (self.origin[0] < 320)
		wait (0.25);

//	if (self.origin[0] > 360)
	level notify ("wood_time");

	if (!isdefined (spawner))
		return;
		
	targ_org = spawn ("script_model", (0,0,0));
	while (!isdefined (mg42_gunner))
	{
		mg42_gunner = spawner dospawn();
		wait (0.5);
	}
	
	node = getnode (mg42_gunner.target,"targetname");
	mg42_gunner.goalradius = (32);
	mg42_gunner setgoalnode (node);
	mg42_gunner waittill ("goal");
	mg42 = getent (node.target,"targetname");
	mg42_gunner useturret(mg42); // dude should be near the mg42
	mg42 setmode("manual_ai"); // auto, auto_ai, manual
	mg42 settargetentity(targ_org);
//	mg42 startfiring();
	mg42_gunner thread maps\_mg42::mg42_firing(mg42);
	mg42 notify ("startfiring");
	level thread dragger_end (self, mg42, targ_org);
	
	while ((self.origin[0] < 560) && (isalive (self)))
	{
		org = num - self.origin[0];
		targ_org.origin = self.origin - ((org*3), 0, 0) + (0,0,33);
		if (targ_org.origin[0] > self.origin[0])
			targ_org.origin = self.origin + (0,0,33);
		/*	
		if ((!count) || (count != oldcount))
		{
			ents = get_mg42guys();	
			if (isdefined (ents))
				count = ents.size;
			oldcount = count;
		}
		if (isdefined (ents))
		{
			count = ents.size;
			for (i=0;i<ents.size;i++)
			{
				mg42 = ents[i];
				mg42 settargetentity(targ_org);
				mg42 setmode("manual_ai"); // auto, auto_ai, manual
				mg42 startfiring();
			}
		}		
		*/
		wait (0.25);
	}

	mg42.script_delay_min = 2;
	mg42.script_delay_max = 3;
	mg42.script_burst_min = 0.5;
	mg42.script_burst_max = 1.2;
	mg42 notify ("stopfiring");
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	
	if (isdefined (targ_org))
		targ_org delete();
	
/*	
	ents = get_mg42guys();	
	if (isdefined (ents))
	for (i=0;i<ents.size;i++)
	{
		if (isdefined (ents[i].target_entity))
			ents[i] settargetentity(ents[i].target_entity);
	}	
*/	
}

/*
drag_trigger (ent)
{
	while (1)
	{
		println ("waitin for trigger");
		self waittill ("trigger",other);
		println ("triggered");
		if ((isSentient (ent)) && (other == ent))
			break;
	}
	self notify ("dragged");
	self delete ();
}
*/


halftrack_kill(gunner)
{
	gunner endon ("death");
	shield = getent ("halftrack_shield", "targetname");
	shield.oldorigin = shield.origin;
	
	while (1)
	{
		shield.origin = shield.oldorigin;
		self waittill ("trigger");
		shield.origin = shield.oldorigin + (0,0,-1000);
		while (level.player istouching (self))
			wait 1;
	}
}

delete_halftrack_kill(ai, trigger)
{
	ai.health = 1;
	ai thread halftrack_death_wait();
	
	level waittill ("halftrack_overcome");
	
	
	maps\_utility::chain_off ("10");
//	maps\_utility::chain_on ("20");
	chain = maps\_utility::get_friendly_chain_node ("20");
	level.player SetFriendlyChain (chain);
	
	wait (5);
//	maps\_utility::keyHintPrint(&"SCRIPT_HINT_OBJECTIVEKEY", getKeyBinding("+scores"));
	wait (5);
//	iprintlnbold (&"SCRIPT_HINT_OBJECTIVEONCOMPASS");
	
	trigger delete();
}

halftrack_death_wait()
{
	self waittill ("death");	
	level notify ("halftrack_overcome");
}

halftrack_disconnect_wait(gunner)
{
	wait (1);
/*
	while (isalive (gunner))
	{
		self waittill ("turretownerchange");
		wait (3);
		if (isalive (gunner))
			gunner useturret(self);
	}	
*/

	self waittill ("turretownerchange");
	
//	iprintln ("halftrack gunner disconnected");
	if (isalive (gunner))
		gunner allowedStances ("stand");
	level notify ("halftrack_overcome");
}

halftrack_mg42(gunner)
{
	halftrack_kill = getent ("halftrack_kill", "targetname");
	level thread delete_halftrack_kill(gunner, halftrack_kill);
	gunner endon ("death");
	
	while (1)
	{
		self waittill ("trigger");
		gunner.has_player = true;
		gunner notify ("got_player");
		while (level.player istouching (self))
			wait 1;
		gunner.has_player = false;
	
		level.halftrack_trigged = false;
	}
}

halftrack_gunner_death(gunner)
{
	gunner waittill ("death");
	foley = getent ("foley","targetname");
	badplace_delete("halftrack_bp");

//	15. Good job, son!
	foley anim_single_queue (foley, "good job");
//	16. Squad, move up! Go! Go! Go!
	foley thread anim_single_queue (foley, "go go");
	// go_go
	
	trigger = getent ("player flanks","targetname");
//	trigger waittill ("trigger");
	flag_wait("foley base of fire");
	timer = gettime() + 20000;
	while ((timer > gettime()) && (level.player istouching (trigger)))
		wait (1);
		
	trigger delete();

//	17b. Martin, take their left flank! Clear that building! Move it! Go!
	foley anim_single_queue (foley, "left flank");
}

halftrack_gunner()
{
	level thread halftrack_gunner_death(self);
	self endon ("death");

/*
	self.ignoreme = true;
	mg42 = getent (self.target,"targetname");
	self useturret(mg42);
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
*/
	
//	self.pacifist = true;
	self.has_player = false;
	self.ignoreme = true;
	

	target[0] = spawn ("script_origin", (-553,-19247,47));
	target[1] = spawn ("script_origin", (-336,-19059,27));
	target[2] = spawn ("script_origin", (-366,-19180,47));
	target[3] = spawn ("script_origin", (-651,-19225,36));
//	target[4] = spawn ("script_origin", (323,-19261,5));
//	target[5] = spawn ("script_origin", (-260,-19131,9));
	
	level waittill ("attacked");
	
	mg42 = getent (self.target,"targetname");	

//	badplace_arc(name, duration, origin, radius, height, direction, left angle, right angle, team[, other team...]);
	badplace_arc("halftrack_bp", -1, mg42.origin, 1500, 400, (1.00, 0.00, 0.00), 20, 0, "allies");

		
	script_models = getentarray ("script_model","classname");
	for (i=0;i<script_models.size;i++)
	{
		if (script_models[i].model == "xmodel/vehicle_halftrack_shield")
			mg42 linkto (script_models[i]);
	}
	
	self useturret(mg42);
//	iprintln ("halftrack gunner use turret");
//	mg42 setmode("manual_ai"); // auto, auto_ai, manual
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	mg42 startfiring();
	
	mg42 thread halftrack_disconnect_wait(self);
	
	while (1)
	{
		number = randomint( target.size);
	//	iprintln ("z:                  new target: ", number);
		mg42 settargetentity ( target[number] );
		wait (1 + randomfloat (2.5));
	}
}

player_wait()
{
	self waittill ("trigger");
	level notify ("player_wait");
	wait 1.5;
	trigger = getent ("auto209","targetname");
	if (isdefined (trigger))
		trigger notify ("trigger");
}

enemy_fired(trigger)
{
	while (1)
	{
		trigger waittill ("trigger", other);

		if (isSentient (other))
		if ((isdefined (other)) && (other != level.player) && (isdefined (other.team)) && (other.team == "axis"))
			break;
	}
	
	level.flag["attacked"] = true;
	level notify ("attacked");

	
	level thread drag_node((getnodearray ("drag_guy","targetname"))[0]); // Set drag guy events into action
	
	wait 1;
	foley = getent ("foley","targetname");
	foley thread anim_single_queue (foley, "hit the dirt");
	foley waittill ("hit the dirt");

	if (level.player getstance() == "crouch")
		thread hint_crouch2prone();
	if (level.player getstance() == "stand")
		thread hint_stand2prone();
	
	
	/*
	// prone hint print
	binding = getKeyBinding("toggleprone");
	if(binding["count"])
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_PRONEKEY", binding);
	else 
	{
		binding = getKeyBinding("lowerstance");
		if(binding["count"])
			maps\_utility::keyHintPrint(&"SCRIPT_HINT_DOUBLETAPPRONEKEY", binding);
		else
		{
			binding = getKeyBinding("+prone");
			if(binding["count"])
				maps\_utility::keyHintPrint(&"SCRIPT_HINT_HOLDDOWNPRONEKEY", binding);
		}
	}
		
	*/
		
	wait 0.43;
	foley thread anim_single_queue (foley, "suppress");
	
	/*
	// ads hint print
	binding = getKeyBinding("toggle cl_run");
	if(binding["count"])
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_ADSKEY", binding);
	else 
	{
		binding = getKeyBinding("+speed");
		if(binding["count"])
			maps\_utility::keyHintPrint(&"SCRIPT_HINT_HOLDDOWNADSKEY", binding);
	}
	*/
	
	wait 4;
	flag_set ("not pacifist");
	thread standup_hint();
	trigger delete();
}

hint_crouch2prone()
{
	binding = getKeyBinding("goprone");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_PRONEKEY", binding);  
		return;
	}

	binding = getKeyBinding("+prone");

	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_HOLDDOWNPRONEKEY", binding);
		return;
	}

	binding = getKeyBinding("toggleprone");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_PRONEKEY", binding);
		return;
	}

	binding = getKeyBinding("lowerstance");
	if(binding["count"])
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_PRONEKEY", binding);
}

hint_stand2prone()
{
	binding = getKeyBinding("goprone");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_PRONEKEY", binding);  
		return;
	}

	binding = getKeyBinding("+prone");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_HOLDDOWNPRONEKEY", binding);
		return;
	}
	
	binding = getKeyBinding("toggleprone");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_PRONEKEY", binding);
		return;
	}

	binding = getKeyBinding("lowerstance");
	if(binding["count"])
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_DOUBLETAPPRONEKEY", binding);
}



standup_hint()
{
	binding = getKeyBinding("+gostand");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_STANDKEY", binding);  
		return;
	}

	binding = getKeyBinding("+prone");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_STANDLETGOPRONEKEY", binding);
		return;
	}

	binding = getKeyBinding("toggleprone");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_STANDFROMPRONEKEY", binding);
		return;
	}

	binding = getKeyBinding("raisestance");
	if(binding["count"])
	{
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_DOUBLETAPSTANDKEY", binding);
		return;
	}
	
	binding = getKeyBinding("+moveup");
	if(binding["count"])
		maps\_utility::keyHintPrint(&"SCRIPT_HINT_DOUBLETAPSTANDKEY", binding);
}

goal_line()
{
	while (1)
	{
		if (isdefined (self.gnode))
			line (self.origin + (0,0,35), self.gnode.origin + (0,0,35), (0.2, 0.5, 0.8), 0.5);
			
		maps\_spawner::waitframe();
	}
}

// Self is foley
mortars() 
{
	flag_wait ("not pacifist");		
	level waittill ("mortar");
	self thread anim_single_queue (self, "mortars");
		
	set[0] = true;
	set[1] = false;
	set[2] = false;
	set[3] = false;
			
	next = 0;		
	for (i=0;i<8;i=i)
	{
		level waittill ("mortar");
		next--;
		if (next <= 0)
		{
			i++;
			next = randomint(3) + 2;
			current_set = randomint (set.size);
		
			play_set = undefined;
			while (!isdefined (play_set))
			{
				for (i=0;i<set.size;i++)
				{
					if (!set[current_set])
						play_set = current_set;

					current_set++;
					if (current_set >= set.size)
						current_set = 0;
				}
				
				for (i=0;i<set.size;i++)
					set[i] = false;
					
				current_set = randomint (set.size);
			}

			set[play_set] = true;
			if (play_set == 0)
				self thread anim_single_queue (self, "mortars");
			if (play_set == 1)
				self thread anim_single_queue (self, "stay down");
			if (play_set == 2)
				self thread anim_single_queue (self, "incoming");
			if (play_set == 3)
				self thread anim_single_queue (self, "head down");
			
			wait (2 + randomfloat (2));
		}
	}
}

reach_goal(guy)
{
	guy endon("death");

//	guy thread goal_line();
	guy.suppressionwait = 0.75;
	if ((isdefined (guy.targetname)) && (guy.targetname == "foley"))
	{
		foley = true;
		guy.pronetime = false;
		guy.threatbias = -50;
//		guy.ignoreme = true;
		guy thread mortars();
	}
	else
	{
		foley = false;
		guy.health = 200; // Non-Foleys dont.
	}

	if (getcvar("start") != "start")
	{
		flag_set ("lets go");
		flag_set ("not pacifist");
		guy.pacifist = false;
		guy.pronetime = false;
		guy setgoalentity (level.player);
		guy.goalradius = 32;//300;
		return;
	}
	
	if (foley)
	{
		wait (0.05);
		guy thread anim_single_queue (guy, "intro");
	}

	guy endon ("break_from_tradition");
	if (!level.flag ["not pacifist"])
		guy.pacifist = true;
	guy.bravery = 50000;
//	guy.goalradius = 2;
//	guy maps\_utility::cant_shoot();
	guy.interval = 32; // temp removal of interval

	if (!flag("lets go"))
	{
		guy.walkdist = 16;
		guy setgoalpos (guy.origin);
		if (!isdefined (guy.intro_no_crouch) )
			guy allowedStances ("crouch");

		flag_wait ("lets go");
		if (foley)
			guy anim_single_queue (guy, "lets go");
	}
	
	guy allowedStances ("crouch", "prone", "stand");
	
	wait (.3 + randomFloat (1));
	
	playerstart = getent ("playerstart","targetname");
	if (isdefined (playerstart))
		playerstart delete();

	goals = 0;	
	while (1)
	{
		if (isdefined (target))
		{
			if (isdefined (target.target))
				target = getnode (target.target, "targetname");
			else
				break;
		}
		else
		if (isdefined (guy.target))
			target = getnode (guy.target, "targetname");
			
		if (!isdefined (target))
			break;

		guy setgoalnode (target);
		guy.goalradius = 80; //Z: NOTE was 32
		guy.gnode = target;

		guy waittill ("goal");
	}

	if (foley)
		flag_set ("not pacifist");
		
	guy allowedStances ("prone", "stand", "crouch");
	guy.pacifist = false;
	guy setgoalentity (level.player);
	guy.goalradius = 32;//300;
}

/*
killfriendlies()
{
	self waittill ("trigger");
	friends = getaiarray ("allies");
	for (i=0;i<friends.size;i++)
		friends[i] thread time_to_die();
}

time_to_die()
{
	if ((isdefined (self.targetname)) && (self.targetname == "foley"))
		return;
		
	wait (randomfloat (10));
	if (isalive (self))
		radiusDamage ( self.origin, 2, 15000, 15000);
}

kill_a_friend_go()
{
	self waittill ("trigger");

	level notify ("time_to_die");
	self delete ();
}

kill_a_friend(trig)
{
	trig delete();
	return;
	
	level.kill_a_friend_in_progress = false;
	trig waittill ("trigger");
	trig delete();
	if (level.kill_a_friend_in_progress)
		return;

	while (!isdefined (level.friendlydeath_spawned))
		wait 0.1;

	if (level.kill_a_friend_in_progress)
		return;

	if (isalive (level.friendlydeath_spawned))
	{
		level.kill_a_friend_in_progress = true;
		
		exclude = [];			
		foley = getent ("foley","targetname");
		if (isalive (foley))
			exclude[exclude.size] = foley;
			
		dragger = getent ("dragger","targetname");
		if (isalive (dragger))
			exclude[exclude.size] = dragger;
	
		dragged = getent ("dragged","targetname");
		if (isalive (dragged))
			exclude[exclude.size] = dragged;
		
		ent = maps\_utility::getClosestAI (level.player getorigin(), "allies", exclude);
		
		if (isdefined (ent))
		{	
			ent endon ("death");
			deathspot = getnode ("deathspot", "targetname");
			ent setgoalnode (deathspot);
			oldgoalradius = ent.goalradius;
			ent.goalradius = 32;
			ent waittill ("goal");
			level waittill ("time_to_die");
			ent setgoalnode (getnode (deathspot.target, "targetname"));
			ent.goalradius = 0;
			ent waittill ("goal");
			ent.goalradius = oldgoalradius;
			ent setgoalentity (level.player);
		}
	}
}
*/
friendlydeath_gag()
{
	self waittill ("trigger", other);
	while (!isdefined (level.friendlydeath_spawned))
		wait 0.1;
	if (isalive (level.friendlydeath_spawned))
	{
		if (isalive (other))
		{
			other.health = 1;
//			other magicbullet ("mp40", other.origin, other.origin + (0,0,40));
			other kill_guy ();
//			radiusDamage ( triggerer.origin, 2, 15000, 15000);
//			println ("* BLEW UP A GUY *");
		}	
	}
}

airplane()
{
	wait 5;
	maps\_utility::array_thread(getentarray( "airplane", "targetname" ), ::airplane_think);
}

airplane_think ()
{
	if (!isdefined (self.target))
		return;
	
	self waittill ("trigger");
//	path = getent (self.target, "targetname");

/////////////////
	if (randomint (100) > 50)
		sound = "c47_flyby1";
	else
		sound = "c47_flyby2";
	
	airsounds= getentarray ("airsound","targetname");
	org = spawn ("script_origin", (0,0,0));
	org.origin = airsounds[1].origin;
	org thread do_sound (sound);
//////////////////

	wait (5);

	plane = spawnVehicle( "xmodel/c47", "plane", "C47", (0,0,0), (0,0,0) );
//	plane = spawn ("script_vehicle", (0,0,0));
//	plane setmodel ("xmodel/c47");
	path = getVehicleNode (self.target,"targetname");
	plane attachPath( path );
	plane startPath();


/*
	for (i=0;i<airsounds.size;i++)
	{
		org = spawn ("script_origin", (0,0,0));
		org.origin = airsounds[i].origin;
		org thread do_sound (sound);
	}
*/
	thread planedie (plane);
	wait (14);
	plane notify ("die");
	plane delete();
	self delete();
}

do_sound (sound)
{
//	wait (4);
	self playsound (sound);
	println ("z:         playing aircraft sound");
	wait (14);
	self delete();
}

planedie (plane)
{
	plane endon ("die");
	while (1)
	{
		playfxOnTag ( level._effect["flameout"], plane, "tag_door_left" );
		wait (randomfloat (0.15));
		playfxOnTag ( level._effect["flameout"], plane, "tag_door_left" );
		wait (randomfloat (0.15));
		playfxOnTag ( level._effect["fireheavysmoke"], plane, "tag_door_left" );
		wait (randomfloat (0.15));
	}
}

/*
tag_origin

tag_prop_left      - for spinning prop effect I think

tag_prop_right   

tag_engine_left   - for flaming engine effect

tag_engine_right

tag_door_left      - for guys jumping out

tag_door_right
*/

temp()
{
	while (1)
	{
		println ("sound"); 
		level.player playsound ("c47_flyover");
		
		wait (5);
	}
}

/*
	grenades
	flak
*/


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

anim_reach (guy, anime, tag, node, tag_entity)
{
	maps\_anim::anim_reach (guy, anime, tag, node, tag_entity);
}

flag_wait (msg)
{
	if (!level.flag[msg])
		level waittill (msg);
}

flag (msg)
{
	if (!level.flag[msg])
		return false;
		
	return true;
}

flag_set (msg)
{
	level.flag[msg] = true;
	level notify (msg);
}

lookat (ent, timer)
{
	if (!isdefined (timer))
		timer = 10000;
		
	self animscripts\shared::lookatentity(ent, timer, "alert");
}

assignanimtree()
{
	self UseAnimTree(level.scr_animtree[self.animname]);
}


waittill_either_think (ent, msg)
{
	println (ent, "^1 is waiting for ", msg);
	ent waittill (msg);
	println (ent, "^1 got ", msg);
	self notify ("got notify");
}

waittill_either(waiter, msg1, msg2, msg3 )
{
	ent = spawnstruct();
	if (isdefined (msg1))
		ent thread waittill_either_think(waiter, msg1);
	if (isdefined (msg2))
		ent thread waittill_either_think(waiter, msg2);
	if (isdefined (msg3))
		ent thread waittill_either_think(waiter, msg3);
		
	ent waittill ("got notify");
}

