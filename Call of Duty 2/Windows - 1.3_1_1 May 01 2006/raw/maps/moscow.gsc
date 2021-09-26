#include maps\_utility;
#include maps\_anim;
main()
{
	setExpFog(0.00035, .58, .57, .57, 0);
	if (getcvar("jumpto") == "")
    	setcvar("jumpto", "");
    
	setsavedcvar("cg_hudCompassMaxRange", "900");
	level.setHudElmHintBackground = true;
   
    level.scr_moscow_fx = 0;
    level.scr_moscow_logic = 0;
    level.scr_moscow_drones = 0;
    if(getcvar("scr_moscow_fx") == "1")
    {
    	level.scr_moscow_fx = 1;
    	level.scr_moscow_logic = 1;
    }
    if(getcvar("scr_moscow_drones") == "1")
    	level.scr_moscow_drones = 1;
    	
    level.jumpto_shoot = false;
    level.jumpto_potato = false;
	level.jumpto_melee = false;
	level.jumpto_trench = false;
	level.jumpto_basement = false;
	level.jumpto_smoke = false;
	
	if (!isdefined(getcvar ("jumpto")))
	 	setcvar ("jumpto", "null");
	 	
	else if((getcvar ("jumpto") == "shoot") || (getcvar ("jumpto") == "1"))
		level.jumpto_shoot = true;
	else if((getcvar ("jumpto") == "potato") || (getcvar ("jumpto") == "2"))
	{
		level.jumpto_shoot = true;
		level.jumpto_potato = true;
	}
	else if((getcvar ("jumpto") == "melee") || (getcvar ("jumpto") == "3"))
	{
		level.jumpto_shoot = true;
		level.jumpto_potato = true;
		level.jumpto_melee = true;
    }
    else if((getcvar ("jumpto") == "trench"))
	{
		level.jumpto_shoot = true;
		level.jumpto_potato = true;
		level.jumpto_melee = true;
		level.jumpto_trench = true;
    }
    else if((getcvar ("jumpto") == "basement") || (getcvar ("jumpto") == "4"))
	{
		level.jumpto_shoot = true;
		level.jumpto_potato = true;
		level.jumpto_melee = true;
		level.jumpto_trench = true;
		level.jumpto_basement = true;
    }
     else if((getcvar ("jumpto") == "smoke") || (getcvar ("jumpto") == "5"))
	{
		level.jumpto_shoot = true;
		level.jumpto_potato = true;
		level.jumpto_melee = true;
		level.jumpto_trench = true;
		level.jumpto_basement = true;
		level.jumpto_smoke = true;
    }
    	
    precacheModel("xmodel/vehicle_stuka_flying");
    precacheModel("xmodel/vehicle_halftrack_rockets_shell");
    precacheModel("xmodel/vehicle_halftrack_rockets_shell_d");
    precacheModel("xmodel/moscow_gun_positioin_rig");
    
    precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	precacheShader("objective");
	precacheShader("stance_crouch");
	precacheShader("inventory_tnt_large");
	precacheShader("gfx/icons/hud@steilhandgrenate.tga");
	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		precacheshader("popmenu_bg");
	
	maps\_truck::main("xmodel/vehicle_opel_blitz_snow");	
    maps\_halftrack::main("xmodel/vehicle_halftrack_mg_snow");	
    maps\_halftrack::main("xmodel/vehicle_halftrack_rockets_snow");	
    maps\_panzer2::main("xmodel/vehicle_panzer_ii_winter");
	maps\moscow_fx::main();
	
	drone_trigs = getentarray("drone_allies","targetname");
	for( i = 0 ; i < drone_trigs.size ; i++ )
		drone_trigs[i] minspec_drone_trigger_adjustments();
	spwns = getentarray("min_spec", "script_noteworthy");
	array_thread(spwns,::minspec_spawn_kill);
	
	
	aitype\axis_snow_wehr_reg_mp40::precache();
	aitype\ally_rus_reg_ppsh::precache();
	level.drone_spawnFunction["axis"] = aitype\axis_snow_wehr_reg_mp40::main;
	level.drone_spawnFunction["allies"] = aitype\ally_rus_reg_ppsh::main;
	maps\_drones::init();
	
	maps\_load::main();

	// generates "Get to Cover" x number of times when you first get hurt
    maps\_gameskill::setTakeCoverWarnings();
	
	maps\moscow_anim::main();
	level thread maps\moscow_amb::main();
	setEnvironment ("cold");

	maps\moscow_str::main();
	level.obj_string["walktable"] 	= &"MOSCOW_OBJ_WALK_TABLE"; 
	level.obj_string["grabgun"] 	= &"MOSCOW_OBJ_GRABGUN"; 
	level.obj_string["goback"] 		= &"MOSCOW_OBJ_GOBACK"; 
	level.obj_string["bears"] 		= &"MOSCOW_OBJ_BEARS"; 
	level.obj_string["shoot"] 		= &"MOSCOW_OBJ_SHOOT"; 
	level.obj_string["shootb"] 		= &"MOSCOW_OBJ_SHOOTB"; 
	level.obj_string["test"] 		= &"MOSCOW_OBJ_TEST";
	level.obj_string["melee"] 		= &"MOSCOW_OBJ_MELEE";
	level.obj_string["potato1"]		= &"MOSCOW_OBJ_POTATO1";
	level.obj_string["potato2"] 	= &"MOSCOW_OBJ_POTATO2";
	level.obj_string["follow"] 		= &"MOSCOW_OBJ_FOLLOW";
	level.obj_string["armory"] 		= &"MOSCOW_OBJ_ARMORY";
	level.obj_string["smg"] 		= &"MOSCOW_OBJ_SMG";
	level.obj_string["ladder"] 		= &"MOSCOW_OBJ_LADDER";
	level.obj_string["smoke1"] 		= &"MOSCOW_OBJ_SMOKE1";
	level.obj_string["smoke2"] 		= &"MOSCOW_OBJ_SMOKE2";
	level.obj_string["panzer"] 		= &"MOSCOW_OBJ_PANZER";
	
	precacheString(level.obj_string["walktable"]);
	precacheString(level.obj_string["grabgun"]);
	precacheString(level.obj_string["goback"]);
	precacheString(level.obj_string["bears"]);
	precacheString(level.obj_string["shoot"]);
	precacheString(level.obj_string["shootb"]);
	precacheString(level.obj_string["test"]);
	precacheString(level.obj_string["melee"]);
	precacheString(level.obj_string["potato1"]);
	precacheString(level.obj_string["potato2"]);
	precacheString(level.obj_string["follow"]);
	precacheString(level.obj_string["armory"]);
	precacheString(level.obj_string["smg"]);
	precacheString(level.obj_string["ladder"]);
	precacheString(level.obj_string["smoke1"]);
	precacheString(level.obj_string["smoke2"]);
	precacheString(level.obj_string["panzer"]);
	precacheString(&"MOSCOW_MISSION_FAIL_PRISONER");
	
    level.xenon = false;
    level.invertaxis = false;
    
    if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
	{
		level.xenon = true;
	
		if(isdefined( getcvar("input_invertPitch") ) && getcvar("input_invertPitch") == "1" )
			level.invertaxis = true;	
			
		precacheMenu("invert_axis1i");
		precacheMenu("invert_axis2i");
	}
	
	precacheMenu("invert_axis1");
	precacheMenu("invert_axis2");
	precacheMenu("moscow_difficulty");
	precacheMenu("moscow_skill");
	
	level.flag["broken_bottles"] = false;
	level.flag["broken_bottles2"] = false;
	level.flag["broken_helmets"] = false;
	level.flag["in_interogation"] = false;
	level.flag["letlev_do_prison"] = false;
	level.flag["punishing"] = false;
	level.flag["stop_random_punish"] = false;
	level.flag["melee_button"] = false;
	level.flag["charge_truck_in_place"] = false;
	level.flag["smoke_obj_done"] = false;
	level.flag["smoke_grenade_in_right_place"] = false;
	level.flag["next_hud_elm"] = true;
	level.flag["pickup_nade_dialogue_done"] = false;
	level.flag["letlev_ready_for_comewithme"] = false;
	level.flag["smoke_nade_obj"] = false;
	level.flag["waiting_for_smoke_to_fill"] = false;
	level.flag["player_grabbed_rifle"] = false;
	level.flag["grenade_training_done"] = false;
	
	//global variables
	level.global_mo_assmin 	= 1;
	level.global_mo_assmax 	= 6;
	level.global_mo_covertype = "null";
	level._breakable_utility_maxnum = 100; //increased from interactable objects because of nature of this level
	
	level.hudelm_animtime = .45;
	level.hud_repeat_rate = 7.8;

	level.player giveweapon("mosin_nagant");
//	level.player giveweapon("potato");
	level.player giveWeapon("tt30");
	level.player takeallweapons();
	level.player giveweapon("potato");
	level.player setweaponclipammo("potato", 0);

	
	setup();
	thread objectives();
	thread misc();
	thread misc2();
	thread infinite_grenade();
	thread friendly_main();
	thread informer2_door_setup();
	
	if(!level.jumpto_shoot)
		thread look_training();
	if(!level.jumpto_potato)
	{
		thread shoot_training();
		thread mannequin_training();
	}
	if(!level.jumpto_melee)
		thread grenade_training();
	if(!level.jumpto_trench)
		thread melee_training();
	if(!level.jumpto_basement)
	{
		thread trench_run();
		thread grab_gun_main();
	}
	if(!level.jumpto_smoke)
		thread weapon_switch_training();
	thread smoke_grenade_training();
	
	//NOT TRAINING
	thread smoke_halftrack_setup();
	thread split_main();
	thread street1_main();
	thread house2_main();
	thread dev_jumpto();
	thread end_main();
	
	ai = getspawnerteamarray("allies");
	array_thread(ai,::punish_friendly_fire);
	
	sndents = getentarray("sound_source", "targetname");
	array_thread(sndents,::sound_source);
	thread ambient_sounds_main();
	
	gbags = getentarray("grenadebag","targetname");
	array_thread(gbags, ::grenade_bags);
	
	thread playerignore();
}

grab_gun_main()
{
	thread grab_gun_door();
	if(!level.jumpto_melee)
		level waittill("gotcha");
	
	spwn = getent("prison_gaurd","targetname");
	level.guard = spwn dospawn();
	spawn_failed(level.guard);
	level.guard.animname = "guard";
	level.guard animscripts\shared::PutGunInHand("none");
	
	node = getnode("training_indoors_guardnode","targetname");
	level.guard.intro_newnode = node;
	while(!level.flag["player_grabbed_rifle"])
	{
		node thread anim_loop_solo(level.guard, "block_idle", undefined, "stop_idle");
		level.guard waittill("stop_new_idle");
		node notify("stop_idle");
		level.guard waittill("myisspeaking");
	}
}

grab_gun_door()
{
	door_closed = getent("intro_door", "targetname");
	door_open = getent(door_closed.target, "targetname");
	clip = getent(door_open.target, "targetname");
	door_open hide();
	
	if(!level.jumpto_melee)
		level waittill("gotcha");
	
	door_closed delete();
	door_open show();
	clip notsolid();
	clip connectpaths();
	clip delete();
}

playerignore()
{
	level.player.ignoreme = true;
	level.flag["player_in_basement"] = false;
	
	
	trig = getent("outbasement", "targetname");
	trig thread player_trig_ignore(true);
	trigs = getentarray("inbasement", "targetname");
	array_thread(trigs,::player_trig_ignore, false);
}

player_trig_ignore(state)
{
	while(1)
	{
		self waittill("trigger");
		if(state)
			level.flag["player_in_basement"] = false;
		else
		{
			level.flag["player_in_basement"] = true;
			level notify("player_in_basement");	
		}	
		level.player.ignoreme = state;	
	}	
}

minspec_spawn_kill()
{
	if( level.scr_moscow_logic != 0)
		self.count = 0;	
}

minspec_drone_trigger_adjustments()
{
	if(level.scr_moscow_drones == 0)
		return;
	if(level.scr_moscow_drones == 1)
	{
		if(self.script_noteworthy == "drone_allies_dead")
		{
			self.script_drones_min = 6;
			self.script_drones_max = 7;
		}
		else
		{
			self.script_drones_min = 1;
			self.script_drones_max = 2;
		}
	}
}

grenade_bags()
{	
	nade = maps\_spawner::spawn_grenade_bag(self.origin, self.angles, "axis"); 
	if(isdefined(nade))
	{
		nade.targetname = "infinite_grenade";
		nade.bag = true;
	}
	return nade;
}

ambient_sounds_main()
{
	if(!level.jumpto_trench)
		level waittill("trench_run");
	level thread set_ambient("exteriorbattle");
	
	trig = getentarray("snd_amb_switch","targetname");
	array_thread(trig, ::ambient_sounds_switch);
}

ambient_sounds_switch()
{
	while(1)
	{
		self waittill("trigger");
		if(self.script_noteworthy == "inside")
		{
			if(level.xenon)
				level.player setReverb("snd_enveffectsprio_level", "stonecorridor", 1, .25, .75);
			else
				level.player setReverb("snd_enveffectsprio_level", "stonecorridor", 1, .25, .75);

			if(level.scr_moscow_logic == 0)
				level thread set_ambient("interiorbattle");
			
		}
		else
		{
			level.player deactivateReverb("snd_enveffectsprio_level", .75);
			if(level.scr_moscow_logic != 0)
				level thread set_ambient("exteriorbattle");
		}
	}
}
	
sound_source()
{
	switch(self.script_noteworthy)
	{
		case "bigfire":
			self playloopsound("bigfire");
			break;	
		case "medfire":
			self playloopsound("medfire");
			break;
		case "smallfire":
			self playloopsound("smallfire");
			break;
	}	
}

punish_friendly_fire()
{
	level endon("delete_basement");
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;
	guy thread punish_friendly_fire_internal();
}
punish_friendly_fire_internal()
{
	level endon("delete_basement");
	while(1)
	{
		self waittill("damage", amount, other, direction_vec, point, type);
		if(type == "MOD_GRENADE_SPLASH")
		{
			if(other == level.player && self.health < 1)
				self.health = 1;
			continue;
		}
		if(other == level.player)
		{
			level notify("hud_elem_going_up");
			setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN");
			maps\_utility::missionFailedWrapper();
		}
	}
}
mannequin_setup()
{
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_startbashing");//
	level.letlev waittill("myisspeaking");
		
	if(level.flag["mannequin_done"])
		return;
	
	trig = getent("melee_distance_trig","targetname");
	thread meleehint_checkagain();
	trig thread melee_hint_logic1();
}

melee_hint_logic1()
{
	level endon("mannequin_done");
	
	
	if(!level.player istouching(self))
		add_hudelm_hint(level.strings["melee_approach"], "mannequin_done");
	while(!level.player istouching(self))
		wait .05;
	
	self thread melee_hint_logic2();
}

melee_hint_logic2()
{
	level endon("mannequin_done");

	add_hudelm_hint(level.strings["melee"], "mannequin_done");

	while(level.player istouching(self))
		wait .05;
	self thread melee_hint_logic1();
}

meleehint_checkagain()
{
	level endon("mannequin_done");
	while(1)
	{
		if(level.xenon)
			level.strings["melee"] = maps\moscow_str::hint_melee_check(level.strings["melee"]);
		else
			level.strings["melee"] = maps\moscow_str::hint_Melee(level.strings["melee"]);	
		wait .05;
	}
}

mannequin_training()
{
	standing = getent("melee_dummy","targetname");
	trig = getentarray("melee_trig","targetname");
	clip = getent("melee_clip", "targetname");
	for(i=0;i<trig.size;i++)
	{
		trig_fall = getent(trig[i].target, "targetname");
		trig_fall hide();
	}
	
	glow = getent(standing.target, "targetname");
	glow hide();
	standing setcandamage(true);
	level waittill("give_mannequin_obj");	
	level.flag["mannequin_done"] = false;
	thread mannequin_setup();
	glow show();

	thread melee_button();
	while(1)
	{
		standing waittill("damage", other, damage, direction_vec, point, type);
		standing playsound("moscow_mannequin");  
		//if(level.flag["melee_button"])
		if(type == "MOD_MELEE")
			break;
		else
		{
			wait .25;
			if(!level.letlev.myisspeaking)
				level.letlev thread dialogue("moscow_rs1_hitmannequin");//moscow_rs1_hitmannequin
		}
	}
	level.flag["mannequin_done"] = true;
	glow delete();
	clip notsolid();
	clip delete();
	fell = false;
	for(i=0;i<trig.size;i++)
	{
		if(level.player istouching(trig[i]))
		{
			trig_fall = getent(trig[i].target, "targetname");
			standing rotateto(trig_fall.angles, .4, 0.4,0);
			standing moveto(trig_fall.origin, .4, 0.4,0);
			fell = true;
			break;
		}
	}
	if(!fell)
	{
		nex = getclosestent(level.player.origin, trig);
		trig_fall = getent(nex.target, "targetname");
		standing rotateto(trig_fall.angles, .4, 0.4,0);
		standing moveto(trig_fall.origin, .4, 0.4,0);
	}
	level notify("mannequin_done");
}

intro_shooters_gungrab()
{
	ai = getai("intro_shooters", "script_noteworthy", "allies");
	thread playsoundinspace("moscow_getofftruck", (-2148, -679, 90));
//	truck = getent("intro_truck", "targetname");
//	truck notify("unload");	
	
	node = getent("pick_up_guns","targetname");
	
	node3 = getent("jump_truck_node","targetname");
	node3.origin  += (32,20,-20);
	
	gun1 = getent("tablegun1","targetname");
	gun2 = getent("tablegun2","targetname");
	gun3 = getent("tablegun3","targetname");
	
	node2 = getnode("auto8456", "targetname");
	ai[1] thread intro_shooters_gungrab_anim("grab_gun3", node, node2, gun3);
	wait .25;
	node2 = getnode("auto8487", "targetname");
	ai[2] thread intro_shooters_gungrab_anim("grab_gun1", node, node2, gun1);
	wait .5;
	node2 = getnode("auto8459", "targetname");
	ai[0] thread intro_shooters_gungrab_anim("grab_gun2", node, node2, gun2);
}

#using_animtree("generic_human");
intro_shooters_gungrab_anim(xanim, node, node2,gun)
{
	self endon("death");
	self.old_walk_combatanim2 		= self.walk_combatanim2;
	self.old_walk_combatanim 		= self.walk_combatanim;
	self.old_walk_noncombatanim2 	= self.walk_noncombatanim2;
	self.old_walk_noncombatanim 	= self.walk_noncombatanim;
	self.old_run_combatanim			= self.run_combatanim;
	self.old_anim_combatrunanim		= self.anim_combatrunanim;
	self.old_run_noncombatanim		= self.run_noncombatanim;
	
	self.walk_combatanim2 		= %unarmed_walk_russian;
	self.walk_combatanim 		= %unarmed_walk_russian;
	self.walk_noncombatanim2 	= %unarmed_walk_russian;
	self.walk_noncombatanim 	= %unarmed_walk_russian;
	self.run_combatanim			= %unarmed_run_russian;
	self.anim_combatrunanim		= %unarmed_run_russian;
	self.run_noncombatanim		= %unarmed_run_russian;
	
	self notify("stop_idle");
	truck = getent("intro_truck", "targetname");
	tag = "null";
	truckanim = "null";
	jumpanim = "null";
	self.runningnode = node2;

	// one guy pauses for an instant when he gets off the truck, so the last guy can catch up.
	// this way it doesnt leave an obvious hole for the player to run through.
	jumpPause = false; 
	                   
	                   
	switch(xanim)
	{
		case "grab_gun1":{
			tag 		= "tag_gun1";
			self.tag 	= "tag_guy02";
			truckanim 	= "truck1";
			jumpanim 	= "jump1";
		}break;
		case "grab_gun2":{
			tag 		= "tag_gun2";
			self.tag 	= "tag_guy03";
			truckanim 	= "truck3";
			jumpanim 	= "jump3";
		}break;
		case "grab_gun3":{
			jumpPause	= true;
			tag 		= "tag_gun3";
			self.tag 	= "tag_guy01";
			truckanim 	= "truck2";
			jumpanim 	= "jump2";
		}break;
	}
				
	self.animname = "generic";
	self set_forcegoal();
	anim_single_solo(self, truckanim, self.tag, undefined, truck);
	node3 = getent("jump_truck_node","targetname");
	node3 anim_reach_solo(self, jumpanim);
	node3 anim_single_solo(self, jumpanim);
	
	if (jumpPause)
	{
		self setgoalpos (self.origin);
		wait (1);
		thread player_blocker_moves_and_deletes(); // start moving the block that stops the player
	}

	if (xanim != "grab_gun2")
		node anim_reach_solo (self, xanim);
	else
	{
		// the pathing + presense of the other AI is making the middle guy turn to the left
		// so we force his orientation to be the direction the animation prefers.
		node thread anim_reach_solo (self, xanim);
		self.goalradius = 40;
		self waittill ("goal");
		yaw = getstartangles(node.origin, node.angles, level.scr_anim["generic"][xanim])[1];
		self OrientMode( "face angle", yaw );
		self.goalradius = 4;
		self waittill ("goal");
	}
	
	node thread anim_single_solo(self, xanim);
	self animscripts\shared::PutGunInHand("none");
	wait .5;
	self setgoalnode(node2);
	self animscripts\shared::PutGunInHand("right");
	if(!level.jumpto_melee)
		gun delete();
	self.gungrab = true;
	self notify("gungrab");
	
	self.walk_combatanim2 		= self.old_walk_combatanim2;
	self.walk_combatanim 		= self.old_walk_combatanim;
	self.walk_noncombatanim2 	= self.old_walk_noncombatanim2;
	self.walk_noncombatanim 	= self.old_walk_noncombatanim;
	self.run_combatanim			= self.old_run_combatanim;
	self.anim_combatrunanim		= self.old_anim_combatrunanim;
	self.run_noncombatanim		= self.old_run_noncombatanim;
	self unset_forcegoal();
}

player_blocker_moves_and_deletes()
{
	// stops the player from approaching the weapons before the AI have had a chance to get them
	block = getent ("player_blocker","targetname");
	timer = 1.4;
	moveDist = 115;
	block moveto (block.origin + (movedist, movedist * -0.5, 0), timer, 0.6);
	wait (timer);
	wait (0.6);
	block moveto (block.origin + (movedist, movedist * -0.5, 0), timer, 0.4);
	wait (1);
	block delete();
}
	

smoke_halftrack_guydamage(turret)
{
	turret.fakeowner endon("death");
	level endon("in_basement");
	turret.fakeowner thread magic_bullet_shield();
	
	while(1)
	{
		turret.fakeowner waittill("damage", amount, ent);
		if(ent == level.player)
			break;	
	}
	
	turret.fakeowner.offset = (0,0,-20);
	turret setmode("manual");
	turret notify("death");
	turret.suppresionFire = false;
	turret stopfiring();	
	turret.fakeowner notify("manual_idle");	
	self thread smoke_halftrack_guy(turret.fakeowner);
	self thread smoke_halftrack_guydamage2(turret);
}

smoke_halftrack_guydamage2(turret)
{
	turret.fakeowner endon("death");
	level waittill("in_basement");
	turret thread maps\_mg42::burst_fire_unmanned();
	turret.fakeowner.offset = (0,0,-5);
	turret setmode("auto_nonai");
	turret.suppresionFire = true;
}

suppressionlookgood()
{
	level endon("smoke_grenade_in_right_place");
	self endon ("death");
	while(1)
	{
		self startfiring();
		self.suppresionFire = true;
		wait (2 + randomfloat(2));
		self setmode("manual");
		self stopfiring();
		self.suppresionFire = false;
		wait (.25 + randomfloat(.35));
		self setmode("auto_nonai");
	}
}


smoke_halftrack_setup()
{
	trig = getent("ht_spawn_trig","targetname");
	trig waittill("trigger");
	wait 1;
	ht = getent("smoke_halftrack", "targetname");
	turret = ht.mgturret[0];
	
	turret.fakeowner notify("manual_idle");	
	turret.fakeowner.idleanim = "mg_idle";
	turret.fakeowner.animname = "ht_mg";
	turret.fakeowner.offset = (0,0,-5);
	ht thread smoke_halftrack_guydamage(turret);
	
	ht thread smoke_halftrack_guy(turret.fakeowner);
	turret.leftarc = 30;
	turret.rightarc = 30;
	turret setmode("auto_nonai");
	turret thread maps\_mg42::burst_fire_unmanned();
	
	turret thread suppressionlookgood();
	
	level waittill("trench_run");
	targets = getentarray("smoke_ht_mg_target1","targetname");
	turret thread maps\_mg42::mg42_suppressionFire(targets);
	
	level waittill("smoke_nade_obj");
	turret notify("stop_suppressionFire");
	targets = getentarray("smoke_ht_mg_target","targetname");
	turret thread maps\_mg42::mg42_suppressionFire(targets);
	
	if(!level.flag["smoke_grenade_in_right_place"])
		level waittill("smoke_grenade_in_right_place");
	
	if(isdefined(turret.fakeowner))
	{
		turret.fakeowner notify ("stop magic bullet shield");
		turret.fakeowner notify("manual_idle");
		turret.fakeowner.idleanim = "mg_idle2";
		ht thread smoke_halftrack_guy(turret.fakeowner);
	}
	
	wait 1;
	turret.suppresionFire = false;
	
	ht waittill("unload");
	turret.fakeowner = undefined;
	turret maketurretusable();
	turret setmode("manual");
	turret stopfiring();	
	turret notify("death");
}

smoke_halftrack_guy (guy)
{
	self endon ("unload");
	guy endon ("death");
	guy endon ("manual_idle");
	while (1)
	{
		org = self gettagOrigin (guy.idletag);
		angles = self gettagAngles (guy.idletag);
		guy animscripted("guyanimdone", org + guy.offset, angles, level.scr_anim[guy.animname][guy.idleanim]);
		guy waittillmatch ("guyanimdone","end");	
	}
}

dev_jumpto()
{
	if(level.jumpto_basement)
	{
		trig = getent("ht_spawn_trig","targetname");
		trig notify("trigger");
		trig = getent("drone_allies_alive","script_noteworthy");
		trig notify("trigger");
		wait .1;
		//thread intro_shooters_gungrab();
		
		thread kill_extra_allies();
	
		truck = getent("intro_truck", "targetname");
		truck notify("unload");	
		ai = getai("intro_shooters", "script_noteworthy", "allies");
		for(i=0;i<ai.size; i++)
			ai[i] delete();
		wait .5;
		level.player setorigin ((-81,103,-100));
		level.player giveweapon("mosin_nagant");
		level.player giveWeapon("tt30");
		level.player switchtoweapon("mosin_nagant");
	}
	else if(level.jumpto_trench)
	{
		wait .1;
		thread intro_shooters_gungrab();
		spawner = getent("informer","targetname");
		guy = spawner dospawn();
		spawn_failed(guy);
		spawner = getent("informer2","targetname");
		guy = spawner dospawn();
		spawn_failed(guy);
		door = getent("interogation_door","targetname");
		door notsolid();
		door connectpaths();
		door rotateyaw(-92, 0.6,0.1,0.1);
		door solid();
		
		wait 3;
		ai = getaiarray("allies");
		org = (-1570, -161, 70);
		num = 0;
		for(i=0;i<ai.size; i++)
		{
			if(isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == "intro_potato_guys")
			{
				ai[i] delete();
				continue;	
			}
			ai[i] teleport ((org + (num * 54, 0,0)), (0,0,0));
			num++;
			if(num > 2)
			{
				num = 0;
				org += (0,-54,0);
			}
		}
		
		wait .5;
		level.player setorigin ((-1425, -378, 70));
		level.player giveweapon("mosin_nagant");
		level.player giveWeapon("tt30");
		level.player switchtoweapon("mosin_nagant");
		level notify("trench_run");
	}
	else if(level.jumpto_melee)
	{
		wait .1;
		thread intro_shooters_gungrab();
		wait .5;
		level.player setorigin ((-1909,-1556,90));
		level.player giveweapon("mosin_nagant");
		level.player giveWeapon("tt30");
		level.player switchtoweapon("mosin_nagant");
	}
	else if(level.jumpto_potato)
	{
		wait .1;
		thread intro_shooters_gungrab();
		wait .5;
		level.player setorigin ((-2162,-1203,88));
		level.player giveweapon("mosin_nagant");
		level.player giveWeapon("tt30");
		level.player switchtoweapon("mosin_nagant");
	}
	else if(level.jumpto_shoot)
	{
		wait .1;
		thread intro_shooters_gungrab();	
		wait .5;
		level.player setorigin ((-2162,-1203,88));
		level.player giveweapon("mosin_nagant");
		level.player giveWeapon("tt30");
		level.player switchtoweapon("mosin_nagant");
	}
}

end_main()
{
	level waittill("bomb_planted");
	level.flag["letlev_give_last_speach"] = false;
	ai = getaiarray("axis");
	array_thread(ai,::end_killbadies);
	
	wait .25;
	
	ai = getaiarray("allies");
	rnodes = getnodearray("allies_end_retreat", "script_noteworthy");
	snodes = getnodearray("end_cool_node", "targetname");
	rnum = 0;
	snum = 0;
	for(i=0;i<ai.size;i++)
	{
		rn = undefined;
		sn = undefined;
		if(rnodes.size)
		{
			rn = getClosestNode(ai[i].origin, rnodes);
			rnodes = array_remove(rnodes, rn);

			if(snodes.size)
			{
				sn = getClosestNode(rn.origin, snodes);
				snodes = array_remove(snodes, sn);
			}
		}
		ai[i] thread end_allies(rn, sn);
			
	}
	
	spwn = getent("letlev2", "script_noteworthy");
	spwn thread end_letlev();
	
	level waittill("newbel_obj_done");
	wait 2.5;
	
	ai = getaiarray("allies");
	snd = getFurthestEnt(level.player.origin, ai);
	playsoundinspace("moscow_rs3_thoughttraining", snd.origin);
	level.flag["letlev_give_last_speach"] = true;
	level notify("letlev_give_last_speach");
	musicplay("soviet_victory_light01");
	level waittill("letlev_done_talking");
	//wait 4;	
	//ending dialogue here
	maps\_endmission::nextmission();
}
end_allies(runnode, restnode)
{
	self endon("death");
	self thread magic_bullet_shield();	
	self.ignoreme = true;
	self thread punish_friendly_fire_internal();
	self set_forcegoal();
	self.goalradius = 16;
	
	if(isdefined(runnode))
		self setgoalnode(runnode);
	
	level waittill("newbel_obj_done");
	
	if(!isdefined(restnode))
		return;

	self setgoalnode(restnode);
	self waittill("goal");
	
	self.animname = "restnode";
	tempnode = spawn("script_origin", restnode.origin);
	
	switch(restnode.script_noteworthy)
	{
		case "tired":
		{
			tempnode.angles = restnode.angles;
			if(player_viewpos_check(self.origin, .2))
			{
				tempnode thread anim_loop_solo(self, "listen", undefined, "stop_idle");
				player_viewpos_wait(self.origin, .2);
				tempnode notify("stop_idle");
			}
			restnode thread anim_loop_solo(self, "hurt", undefined, "stop_idle");
		}break;
		case "hurt":
		{
			tempnode.angles = restnode.angles;
			if(player_viewpos_check(self.origin, .2))
			{
				tempnode thread anim_loop_solo(self, "listen", undefined, "stop_idle");
				player_viewpos_wait(self.origin, .2);
				tempnode notify("stop_idle");
			}
			restnode thread anim_loop_solo(self, "tired", undefined, "stop_idle");
		}break;
		case "lean":
		{
			tempnode.angles = restnode.angles + (0,180,0);
			if(player_viewpos_check(self.origin, .2))
			{
				tempnode thread anim_loop_solo(self, "listen", undefined, "stop_idle");
				player_viewpos_wait(self.origin, .2);
				tempnode notify("stop_idle");
			}
			restnode thread anim_loop_solo(self, "lean", undefined, "stop_idle");
		}break;
		case "stand":
		{
			tempnode.angles = restnode.angles;
			if(player_viewpos_check(self.origin, .2))
			{
				tempnode thread anim_loop_solo(self, "listen", undefined, "stop_idle");
				player_viewpos_wait(self.origin, .2);
				tempnode notify("stop_idle");
			}
			restnode thread anim_loop_solo(self, "listen", undefined, "stop_idle");
		}break;
	}
	
}

end_letlev()
{
	level.letlev = self dospawn();
	spawn_failed(level.letlev);
	
	level.letlev.script_bcdialog = 0;
	level.letlev maps\_utility::setBattleChatter( false );

	level.letlev.ignoreme = true;
	level.letlev.animname = "letlev";
	level.letlev.blockanim = false;
	level.letlev pushplayer(true);
	level.letlev thread magic_bullet_shield();
	level.letlev thread punish_friendly_fire_internal();
	
	level waittill("newbel_obj_done");
	thread battleChatterOff();
	
	level.letlev.walk_combatanim2 		= %unarmed_walk_russian;
	level.letlev.walk_combatanim 		= %unarmed_walk_russian;
	level.letlev.walk_noncombatanim2 	= %unarmed_walk_russian;
	level.letlev.walk_noncombatanim 	= %unarmed_walk_russian;
	level.letlev.run_combatanim			= %unarmed_run_russian;
	level.letlev.anim_combatrunanim		= %unarmed_run_russian;
	level.letlev.run_noncombatanim		= %unarmed_run_russian;
	level.letlev.oldstandanim			= level.letlev.standanim;
	level.letlev.standanim				= %downtown_sniper_blocking_door_idle;
	
	level.letlev animscripts\shared::PutGunInHand("none");
	
	level.letlev.goalradius = 4;
	node = getnode("letlev_last_speach", "targetname");
	
	level.letlev set_forcegoal();
	level.letlev setgoalnode(node);
	
	level.letlev waittill("goal");
	
	if(!level.flag["letlev_give_last_speach"])
	{
		thread friendly_letlev_block(node);
		level waittill("letlev_give_last_speach");
		level.letlev notify("stop_idle");
		level.letlev notify("stop_block_anim");
	}
	
	level.letlev dialogue("moscow_rs1_nobetter",node);
	thread friendly_letlev_block(node);
	level notify("letlev_done_talking");
	
}

end_killbadies()
{
	self endon("death");
	self.ignoreme = true;
	wait randomfloat(1.5);
	ai = getaiarray("allies");
	guy = getclosestent(self.origin, ai);
	magicbullet("kar98k", guy.origin, self.origin);
	thread playsoundinspace("weap_ppsh_fire", guy.origin);			
	self DoDamage ( self.health + 50, self.origin );
}

misc()
{
	wait .05;
	triggers = getentarray("intro_triggers","targetname");
	for(i=0;i<triggers.size;i++)
		triggers[i] notify("trigger");
	
	wait .1;
		truck = getent("intro_truck", "targetname");
	if(!level.jumpto_shoot)
	{
		level.player setorigin (truck getTagOrigin ("tag_player"));//tag_guy05
		level.player setplayerangles((0,290,0));
	}
	ai = getaiarray("allies");
	for(i =0; i<ai.size;i++)
	{
		if(isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == "intro_driver")
		{
			ai[i] delete();
			break;
		}
	}
}

crouch_hint_repeat()
{
	level.flag["done_stance_hint"] = false;
	hint = add_hudelm_hint(level.strings["stance_down_1x"]);
	
	while(level.player getstance() == "stand")
	{
		if(level.xenon)
			level.strings["stance_down_1x"]	= maps\moscow_str::hint_stance_check(level.strings["stance_down_1x"], "stance_down_1x");
		else
			level.strings["stance_down_1x"]	= maps\moscow_str::hint_stand2crouch(level.strings["stance_down_1x"]);
		wait .05;
	}
	hint remove_hudelm_hint();
	
	if(level.xenon)
		special_hint("stance_crouch", "stance_hint", 60, -10, -10, 150, 190);
	else
		special_hint("stance_crouch", "stance_hint", 60, -10, -10, 129, 200);
	level.flag["done_stance_hint"] = true;
	level notify("done_stance_hint");	
}



crouch_training()
{
	level endon("level_forget_standing");
	crouch_hint = getent ("crouch_hint", "targetname");
	crouch_hint waittill ("trigger");	
	
	ai = getai("intro_shooters", "script_noteworthy", "allies");	
	snd = getClosestEnt(level.player.origin, ai);
	thread playsoundinspace("moscow_rs3_crouch", snd.origin);
	
	thread crouch_hint_repeat();
	level waittill("done_stance_hint");
	wait .5;
	if(level.player getstance() != "stand")
	{
		add_hudelm_hint(level.strings["stance_up_1x"], "stand_hint_over");	
		thread uphint1_checkagain();
		wait_player_stand();
	}
	level notify("stand_hint_over");
}

kill_extra_polies()
{
	ent = getent("intro_truck", "targetname");
	ent delete();
	ent = getent("hightarget_bear","targetname");
	ent delete();
	ent = getent("lowtarget_bear","targetname");
	ent delete();
	ents = getentarray("wine_bottle","script_noteworthy");	
	for(i=0;i<ents.size;i++)
		ents[i] delete();
	ents = getentarray("helmet_pop","targetname");	
	for(i=0;i<ents.size;i++)
		ents[i] delete();
	
}

kill_extra_allies()
{
	level notify("killing extra allies");
	level.letlev delete();
	if(!level.jumpto_basement)
	{
	//	level.german delete();
		level.guard delete();
	}
	ai = getai("intro_potato_guys", "script_noteworthy", "allies");
	for(i=0;i<ai.size;i++)
		ai[i] delete();
}

prone_hint_repeat()
{
	hint = add_hudelm_hint(level.strings["stance_down_2x"]);
	while(level.player getstance() != "prone")
	{
		if(level.xenon)
			level.strings["stance_down_2x"] = maps\moscow_str::hint_stance_check(level.strings["stance_down_2x"], "stance_down_2x");	
		else
			level.strings["stance_down_2x"] = maps\moscow_str::hint_stand2prone(level.strings["stance_down_2x"]);	
		wait .05;
	}
	hint remove_hudelm_hint();
}

prone_training()
{
 	prone_hint = getent ("prone_hint", "targetname");
	prone_hint waittill ("trigger");
	level notify("stand_hint_over");
	
	level.player takeweapon("potato");
	level notify("level_forget_standing");
	
	thread kill_extra_allies();
	thread kill_extra_polies();
	thread prone_hint_repeat();	
	
	stand_from_prone_hint = getent ("stand_from_prone_hint", "targetname");
	stand_from_prone_hint waittill ("trigger");
	if(level.player getstance() != "stand")
	{
		add_hudelm_hint(level.strings["stance_up_2x"], "stand_hint_over");
		thread uphint2_checkagain();
		wait_player_stand();
	}
	level notify("stand_hint_over");
	
}

wait_player_stand()
{
	level endon("stand_hint_over");
	level endon("level_forget_standing");
	while (level.player getstance() != "stand")
		wait .5;
}

setup()
{
	friendlies = getaiarray ("allies");
	for (i=0;i<friendlies.size;i++)
	{
		if (isdefined (friendlies[i].script_noteworthy) && friendlies[i].script_noteworthy == "letlev")
		{
			level.letlev = friendlies[i];
			break;
		}
	}	
	
	level.letlev.script_bcdialog = 0;
	level.letlev maps\_utility::setBattleChatter( false );
	
	level.letlev.animname = "letlev";
	level.letlev pushplayer(true);
	level.letlev animscripts\shared::PutGunInHand("none");
	level.letlev thread magic_bullet_shield();
	level.letlev thread punish_friendly_fire_internal();
	level.letlev setBattleChatter(false);
	level.letlev.blockanim = false;
	level.letlev.myisspeaking = false;
	
	ai_stance = getentarray("ai_stance_all", "targetname");
	array_thread(ai_stance, ::ai_stance);
	ai_stance = getentarray("ai_stance_crouch", "targetname");
	array_thread(ai_stance, ::ai_stance);
	ai_stance = getentarray("ai_stance_prone", "targetname");
	array_thread(ai_stance, ::ai_stance);
}

look_training_rifle_hint()
{
	level endon("player_grabbed_rifle");
	trig = getent("grab_rifle_trig","targetname");
	trig waittill("trigger");
	level notify("got_rifle_hint");
	if(!level.flag["next_hud_elm"])
		level waittill("next_hud_elm");
	hint = add_hudelm_hint(level.strings["grab_weapon"], "player_grabbed_rifle");
}

look_training_move_hint()
{
	level endon("gotcha");
	level endon("got_rifle_hint");
	
	hint = add_hudelm_hint(level.strings["objectives"], undefined, level.hud_repeat_rate);
	hint thread look_training_move_hint_remove();
	level.flag["next_hud_elm"] = true;
	wait 5;
	thread look_check_stance();
	
	wait level.hud_repeat_rate;
	
	hint remove_hudelm_hint();
	if(!level.flag["next_hud_elm"])
		level waittill("next_hud_elm");
	
	
	if(level.xenon)
		hint = add_hudelm_hint(level.strings["lookmove"], undefined, level.hud_repeat_rate);
	else
		hint = add_hudelm_hint(level.strings["look"], undefined, level.hud_repeat_rate);
	hint thread look_training_move_hint_remove();
	
	if(!level.xenon)
	{
		wait level.hud_repeat_rate;
		wait .5;
		
		hint remove_hudelm_hint();
		if(!level.flag["next_hud_elm"])
			level waittill("next_hud_elm");
			
		hint = add_hudelm_hint(level.strings["move_forward"], undefined, level.hud_repeat_rate);
		wait level.hud_repeat_rate;
		hint = add_hudelm_hint(level.strings["move_backward"], undefined, level.hud_repeat_rate);
		wait level.hud_repeat_rate;
		hint = add_hudelm_hint(level.strings["move_left"], undefined, level.hud_repeat_rate);
		wait level.hud_repeat_rate;
		hint = add_hudelm_hint(level.strings["move_right"], undefined, level.hud_repeat_rate);
		wait level.hud_repeat_rate;
		hint = add_hudelm_hint(level.strings["move"], undefined, level.hud_repeat_rate);
		wait level.hud_repeat_rate;
	
		if(isdefined(hint))
			hint thread look_training_move_hint_remove();
	}
}

look_training_move_hint_remove()
{
	if(!isdefined(self))
		return;
	self endon("destroying");
	level waittill("gotcha");
	self remove_hudelm_hint();
}

look_training_letlevscold()
{
	level endon("player_grabbed_rifle");
	
	level.letlev waittill("myisspeaking");
	x = 0;
	while(1)
	{
		wait 15;
		if(!(level.player istouching(self)))
			self waittill("trigger");
		
		if(x > 2)
			break;
			
		switch(x)
		{
			case 0:
				level.letlev thread dialogue("moscow_rs1_testpatience", undefined, undefined, undefined, undefined, true);
				break;
			case 1:
				level.letlev thread dialogue("moscow_rs1_gunscold", undefined, undefined, undefined, undefined, true);
				break;
			case 2:
				level.letlev thread dialogue("moscow_rs1_lastchance", undefined, undefined, undefined, undefined, true);
				break;
		}
		x++;
	}
	
	thread letlev_traitor_kill();
}
look_training_letlevobj2()
{
	level endon("player_given_grab_gun_obj");
	level waittill("in_weap_room");
	level notify("player_given_grab_gun_obj");
}
look_training_letlevobj(outdoors)
{
	level endon("in_weap_room");
	thread look_training_letlevobj2();
	if(level.letlev.walking)
		level.letlev waittill("walking");
	if(level.letlev.myisspeaking)
    	level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_movefaster");
	level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_lookcompass");
	level notify("player_given_grab_gun_obj");
	level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_storeroom");
	level notify("player_told_to_go");	
	outdoors thread look_training_letlevscold();
}
look_training_gaurdscold()
{
	thread look_training_gaurdscold2();
	level endon("player_grabbed_rifle");
	
	var = true;
	self waittill("trigger");
	level notify("in_weap_room");
	
	while(1)
	{
		if(level.letlev.myisspeaking)
		{
			level.letlev waittill("myisspeaking");
			if(!(level.player istouching(self)))
				self waittill("trigger");
		}	
		level.guard notify("stop_new_idle");
		
		if(var)
			level.guard thread dialogue("moscow_rs3_weaptable");	
		else
			level.guard thread dialogue("moscow_rs3_pickuptable");	
		
		level.guard waittill("myisspeaking");	
		wait 20;
		if(!(level.player istouching(self)))
			self waittill("trigger");
		var = !var;
	}
}
look_training_gaurdscold2()
{
	level waittill("player_grabbed_rifle");
	wait .5;
	
	if(isdefined(level.guard.myisspeaking) && level.guard.myisspeaking == true)
		level.guard waittill("myisspeaking");
	level.guard notify("stop_new_idle");
	level.guard thread dialogue("moscow_rs3_gobackmove");
	level.guard waittill("myisspeaking");
	level.guard.intro_newnode thread anim_loop_solo(level.guard, "block_idle", undefined, "stop_idle");
	level waittill("grenade_training_done");
	level.guard.intro_newnode notify("stop_idle");
}

table_gun_setup()
{
	node = getent("pick_up_guns","targetname");
	model = spawn("script_model", node.origin);
	model.angles = node.angles;
	model setmodel("xmodel/moscow_gun_positioin_rig");
	model.targetname = "grab_gun_rig";
	
	gun1 = spawn("script_model", (model gettagorigin("tag_gun1")) );
	gun1.angles = model gettagangles("tag_gun1");
	gun1 setmodel("xmodel/weapon_mosinnagant");
	gun1.targetname = "tablegun1";
	
	gun2 = spawn("script_model", (model gettagorigin("tag_gun2")) );
	gun2.angles = model gettagangles("tag_gun2");
	gun2 setmodel("xmodel/weapon_mosinnagant");
	gun2.targetname = "tablegun2";
	
	gun3 = spawn("script_model", (model gettagorigin("tag_gun3")) );
	gun3.angles = model gettagangles("tag_gun3");
	gun3 setmodel("xmodel/weapon_mosinnagant");
	gun3.targetname = "tablegun3";
}
	
look_training()
{		
	thread table_gun_setup();
	thread battleChatterOff();
	
	high	= getent("hightarget_bear", "targetname");	
 	low		= getent("lowtarget_bear", "targetname");
 	
 	indoors	= getent("training_indoors_check","targetname");
 	outdoors= getent("training_outdoors_check","targetname");
 	
 	high_glow = getent(high.target, "targetname");
 	low_glow = getent(low.target, "targetname");
 	
 	array = getentarray("xenon_auto_aim","targetname");
 	array = array_merge(array, getentarray("xenon_auto_aim_secondary","targetname"));
	temp = [];
	for(i=0;i<array.size;i++)
	{
		if(isdefined(array[i].script_noteworthy) && array[i].script_noteworthy == "bears")
			temp[temp.size] = array[i];
	}
 	
 	high.aim = getClosestEnt(high.origin, temp);
 	low.aim = getClosestEnt(low.origin, temp);
 	
 	high_glow hide();
 	low_glow hide();
 	
	wait 1;
	level.flag["speach_timer"] = false;
	truck = getent("intro_truck", "targetname");
	ai = getai("intro_shooters", "script_noteworthy", "allies");
	
	ai[0].animname = "truck3";
	ai[0].tag = "tag_guy03";
	ai[1].animname = "truck2";
	ai[1].tag = "tag_guy01";
	ai[2].animname = "truck1";
	ai[2].tag = "tag_guy02";
	
	for(i=0;i<ai.size;i++)	
	{
		ai[i] animscripts\shared::PutGunInHand("none");
		ai[i] thread maps\_anim::anim_loop_solo ( ai[i], "idle", ai[i].tag, "stop_idle", undefined, truck);
	}
	org = getent("welcome_dialogue_node","targetname");
	//wait 1;
	level.flag["player_given_aim_obj"] = false;
	thread look_fire_hint();
	level.letlev thread dialogue("moscow_rs1_pickuprifle", org);//moscow_rs1_pickuprifle
	wait 8;
	thread look_training_move_hint();
	level notify("go grab a gun");
	wait 2;
	thread intro_shooters_gungrab();
	thread look_training_rifle_hint();
	
	gotcha = getent("gotcha_trig","targetname");
	gotcha waittill("trigger");
	level notify("gotcha");
	
	thread look_training_letlevobj(outdoors);
	indoors thread look_training_gaurdscold();

	while(!level.player hasweapon("mosin_nagant"))
 		wait .1;
 	level.flag["player_grabbed_rifle"] = true;
 	level notify("player_grabbed_rifle");
 	
 	thread add_hudelm_hint(level.strings["objectives"], undefined, 5);
 	
 	glow_rifle = getent("glow_rifle","targetname");
 	glow_rifle delete();
 	handgun = getent("handgun", "targetname");
 	glowgun = getent(handgun.target, "targetname");
 	glowgun delete();
 	handgun delete();
 	level.player giveWeapon("tt30");
 	level.player switchToWeapon("tt30");
 	level.player setweaponslotclipammo("primary", 10);
 	level.player setweaponslotammo("primary", 1000);
 	level.player setweaponslotclipammo("primaryb", 10);
 	level.player setweaponslotammo("primaryb", 1000);
 	thread maintain_ammo();
 	
 	goback = getent("goback_trig","targetname");
	goback waittill("trigger");
 	
 	level notify("player_got_back");
	
	level waittill("player_given_aim_obj");
	
	level notify("enable_xenon_autoaim_bears");
	high thread look_waittilldamage(high_glow);
	low thread look_waittilldamage(low_glow);
	
	level waittill("shot_at_teddy_or_man");
	thread look_dialogue2();
		
	level waittill("shot_at_teddy_or_man");
	
	wait .25;
	
//	lock = spawn("script_origin", level.player.origin);
//	level.player linkto(lock);
	
	if(level.invertaxis)
		level.player openMenu("invert_axis1i");
	else
		level.player openMenu("invert_axis1");
	
	level.player freezecontrols(true);
	setblur(5, .1);
	level.player waittill("menuresponse", menu, response);
    setblur(0, .2);
    level.player freezecontrols(false);
 //   level.player unlink();
    
    if(response == "try_invert")
    {
    	if(level.letlev.myisspeaking)
    		level.letlev waittill("myisspeaking");
		level.letlev thread dialogue("moscow_rs1_mannequin");//moscow_rs1_mannequin
		high thread look_waittilldamage(high_glow);
		low thread look_waittilldamage(low_glow);
		
		thread look_dialogue1b();
		level waittill("shot_at_teddy_or_man");
		thread look_dialogue2();
		
		level waittill("shot_at_teddy_or_man");
		
		wait .25;
		
//		lock.origin = level.player.origin;
//		level.player linkto(lock);
		if(level.invertaxis)
			level.player openMenu("invert_axis2i");
		else
			level.player openMenu("invert_axis2");
		
		level.player freezecontrols(true);
		setblur(5, .1);
		level.player waittill("menuresponse", menu, response);
		setblur(0, .2);
		level.player freezecontrols(false);
//		level.player unlink();
	}
	
//	lock delete();
	
	level notify("now_do_shoot_training");
	
	high_glow delete();
	low_glow delete();
	array = getentarray("xenon_auto_aim","targetname");
	array = array_merge(array, getentarray("xenon_auto_aim_secondary","targetname"));
	for(i=0;i<array.size;i++)
	{
		if(isdefined(array[i].script_noteworthy) && array[i].script_noteworthy == "bears")
			array[i] thread delete_autoaim();
	}
	level notify("enable_xenon_autoaim_bottles");
}

look_check_stance()
{
	level endon("level_forget_standing");
	
	while (level.player getstance() == "stand")
		wait .5;
	
	wait .5;
	
	level.flag["next_hud_elm"] = false;
	
	hint = undefined;
	if(level.player getstance() == "crouch")
	{
		hint = add_hudelm_hint(level.strings["stance_up_1x"], "stand_hint_over");
		thread uphint1_checkagain();
	}
	else
	{
		hint = add_hudelm_hint(level.strings["stance_up_2x"], "stand_hint_over");
		thread uphint2_checkagain();
	}
	wait_player_stand();
	level notify("stand_hint_over");
	level.flag["next_hud_elm"] = true;
	level notify("next_hud_elm");		
}

uphint1_checkagain()
{
	level endon("stand_hint_over");
	
	while(1)
	{
		if(level.xenon)
			level.strings["stance_up_1x"] = maps\moscow_str::hint_stance_check(level.strings["stance_up_1x"], "stance_up_1x");
		else
			level.strings["stance_up_1x"] = maps\moscow_str::hint_crouch2stand(level.strings["stance_up_1x"]);
		wait .05;
	}
}
uphint2_checkagain()
{
	level endon("stand_hint_over");

	while(1)
	{
		if(level.xenon)
			level.strings["stance_up_2x"] = maps\moscow_str::hint_stance_check(level.strings["stance_up_2x"], "stance_up_2x");
		else
			level.strings["stance_up_2x"] = maps\moscow_str::hint_prone2stand(level.strings["stance_up_2x"]);
		wait .05;
	}
}

look_fire_hint()
{
	level endon("shot_at_teddy_or_man");

	level waittill("player_got_back");
	
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_goodcompass");
	level.letlev waittill("myisspeaking");
	
	level.flag["player_given_aim_obj"] = true;
	level notify("player_given_aim_obj");
		
	level.letlev thread dialogue("moscow_rs1_howgoodaim");//moscow_rs1_howgoodaim
	level.letlev waittill("myisspeaking");
	thread look_dialogue1();
	
	array_thread(getentarray("axis_lookat","targetname"), ::look_fire_check1);
	
	level waittill("looked_at_teddy_or_man");
	thread look_dialogue1b();
	if(level.flag["next_hud_elm"])
		add_hudelm_hint(level.strings["fire"], "shot_at_teddy_or_man");
}

look_fire_check1()
{
	level.flag["moscow_rs1_goodnowfire"] = false;
	level endon("shot_at_teddy_or_man");
	while(1)
	{
		self waittill("trigger");
		wait .5;
		self thread look_fire_check2();
		wait .1;
		if(self.look_fire_check2)
		{
			level notify("look_fire_check2");
			level notify("looked_at_teddy_or_man");
			break;	
		}
		else
			level notify("look_fire_check2");
	}
	if(level.letlev.myisspeaking)
	{
		level.letlev waittill("myisspeaking");
		wait 1;
	}
	if(!level.flag["moscow_rs1_goodnowfire"])
	{	
		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
		level.letlev thread dialogue("moscow_rs1_goodnowfire", undefined, false, true);//moscow_rs1_goodnowfire
	}
	level.flag["moscow_rs1_goodnowfire"] = true;

}

look_fire_check2()
{
	level endon("look_fire_check2");
	self.look_fire_check2 = false;
	self waittill("trigger");
	self.look_fire_check2 = true;
}

look_waittilldamage(glow)
{
	self.aim enableAimAssist();
	glow show();
	self.wasshotat = false;
 	self setcandamage(true); 
 	
 	self waittill ("damage");
 	self playsound("bullet_large_teddybear");
 	glow hide();
 	self.wasshotat = true;
 	level notify("shot_at_teddy_or_man");
 	self.aim disableAimAssist();
}

speach_timer()
{
	level.flag["speach_timer"] = true;
	wait 1;
	level.flag["speach_timer"] = false;
	level notify("speach_timer");
}

look_dialogue2()
{
	level endon("shot_at_teddy_or_man");
	level notify("started_new_look_speach");
	level endon("started_new_look_speach");
	
	if(level.letlev.walking)
		level.letlev waittill("walking");
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_teddybear");//moscow_rs1_nowmannequin
	level.letlev waittill("myisspeaking");
	
	thread look_dialogue2b();
}

wait_shoot_nag_timer(time)
{
	level endon("reset_wait_shoot_nag_timer");
	self thread wait_shoot_nag_timer_internal(time);
	wait time;
	self notify("wait_shoot_nag_timer_done");
}

wait_shoot_nag_timer_internal(time)
{
	self endon("wait_shoot_nag_timer_done");
	self waittill("reset_wait_shoot_nag_timer");
	self wait_shoot_nag_timer(time);
}

look_dialogue2b()
{
	level endon("shot_at_teddy_or_man");
	level notify("started_new_look_speach");
	level endon("started_new_look_speach");
	
	str = spawnstruct();
	
	while(1)
	{
		str thread wait_shoot_nag_timer(15);
		str waittill("wait_shoot_nag_timer_done");
	
		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
		level.letlev thread dialogue("moscow_rs1_shootbearscold");	//moscow_rs1_mannequinscold
		level.letlev waittill("myisspeaking");
	}
}

look_dialogue1()
{
	level endon("looked_at_teddy_or_man");	
	level endon("shot_at_teddy_or_man");
	
	str = spawnstruct();
	while(1)
	{
		str thread wait_shoot_nag_timer(20);
		str waittill("wait_shoot_nag_timer_done");
		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
		level.letlev thread dialogue("moscow_rs1_mannequinscold");	//moscow_rs1_mannequinscold
		level.letlev waittill("myisspeaking");
	}	
}

look_dialogue1b()
{	
	level endon("shot_at_teddy_or_man");
	
	str = spawnstruct();
	while(1)
	{
		str thread wait_shoot_nag_timer(20);
		str waittill("wait_shoot_nag_timer_done");
		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
		level.letlev thread dialogue("moscow_rs1_shootbearscold");	//moscow_rs1_mannequinscold
		level.letlev waittill("myisspeaking");
	}	
}

shoot_timer(message)
{
	level endon("given_difficulty_test");
	level endon("stop_shoot_training_timer");
	while(1)
	{
		wait 20;
		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
		level.letlev thread dialogue(message, undefined, false, true);
		level.letlev waittill("myisspeaking");
	}
}

shoot_ADShint_checkshot()
{
	level endon("kill_ads_count");
	
	while(1)
	{
		self waittill("trigger", ent);
		if(ent != level.player)
			continue;
		if(level.flag["ADS_BUTTON"])
			continue;
		level notify("startADShint");
		
		if(!level.flag["adstimer"])
			continue;
		if(!level.letlev.myisspeaking)
		{
			if(level.letlev.walking)
				level.letlev thread dialogue("moscow_rs1_ads", undefined, undefined, true);	
			else
				level.letlev thread dialogue("moscow_rs1_ads2");	
			level.letlev waittill("myisspeaking");
			thread adsdialogue_timer();
		}	
	}
}

adsdialogue_timer()
{
	if(!level.flag["adstimer"])
		return;
	level.flag["adstimer"] = false;
	wait 10;
	level.flag["adstimer"] = true;	
}

shoot_ADShint()
{
	level endon("kill_ads_count");
	
	level.flag["adstimer"] = true;
	thread check_adsbutton();
	trig = getent("ADS_hint","targetname");
	level waittill("done_shooting_first_bottles");
	
	level notify("level_forget_standing");
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	if(level.letlev.walking)	
		level.letlev thread dialogue("moscow_rs1_ads", undefined, undefined, true);
	else
		level.letlev thread dialogue("moscow_rs1_ads2");
	thread adsdialogue_timer();
	level.letlev waittill("myisspeaking");
	
	thread adshint_repeat();
	thread adshint_checkagain();
	thread destroy_adshint();
	trig thread shoot_ADShint_checkshot();
	level notify("startADShint");
	
	while(!level.flag["broken_bottles2"])
		level waittill("another_object_brokenbottle2");	
	
	level notify("kill_ads_count");
}

adshint_repeat()
{
	level endon("kill_ads_count");
	while(1)
	{
		level waittill("startADShint");
		add_hudelm_hint(level.strings["aim"], "stopADShint");
		//level waittill("stopADShint");
	}
}
adshint_checkagain()
{
	level endon("kill_ads_count");
	if(level.xenon)
		return;
	while(1)
	{
		level.strings["aim"] = maps\moscow_str::hint_ADS(level.strings["aim"]);
		wait .05;
	}
}

check_adsbutton()
{
	level.flag["ADS_BUTTON"] = false;
	level endon("kill_ads_count");
	while(1)
	{
		if(level.player playerads() < .85)
			level.flag["ADS_BUTTON"] = false;
		else
			level.flag["ADS_BUTTON"] = true;
		wait .05;
	}
}

destroy_adshint()
{
	level endon("kill_ads_count");
	level waittill("end_difficulty_test");
	level notify("kill_ads_count");
}

shoot_helpfullhints()
{
	level endon("end_difficulty_test");
	thread shoot_ADShint();
	
	//thread shoot_timer(level.shooting_message);
 	
 	autoaimoption = true;
	if(isdefined( getcvar("input_autoAim") ) && getcvar("input_autoAim") == "0" )
		autoaimoption = false;
 	
 	if(!(level.xenon && autoaimoption))
 		return;
	
	level waittill("given_difficulty_test");
	level notify("stop_shoot_training_timer");

	level waittill("another_object_broken");

	//auto target
	add_hudelm_hint(level.strings["target"], undefined, level.hud_repeat_rate);
	
	count = 0;
	while(count < 2)
	{
		level waittill("another_object_broken");
		count++;
	}
	//target switch
	add_hudelm_hint(level.strings["target_2x"], undefined, level.hud_repeat_rate);
	
}

weapon_switch_hint_repeat()
{
	level endon("skip_to_shoot_training_part2");
	level endon("end_weapon_switch_hint");
	hint = add_hudelm_hint(level.strings["weapon_switch"], "kill_weapon_switch");
	
	hint thread weapon_switch_hint_remove("skip_to_shoot_training_part2");
	hint thread weapon_switch_hint_remove("end_weapon_switch_hint");
}

weapon_switch_hint_remove(ender)
{
	level endon("kill_weapon_switch");	
	level waittill(ender);
	level notify("kill_weapon_switch");
}

shoot_training()
{
	level endon("skip_to_shoot_training_part2");
	thread shoot_training_part2();
	thread shoot_training_obeycheck("another_object_broken", "now_do_shoot_training");
	if(!level.jumpto_shoot)
		level waittill("now_do_shoot_training");
	thread shoot_training_skipcheck();
	
	wait 1;
	if(level.letlev.walking)
		level.letlev waittill("walking");
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_rangedweapons");
	level.letlev waittill("myisspeaking");
	
	if(!level.flag["next_hud_elm"])
		level waittill("next_hud_elm");
	
	if(!(level.player getcurrentweapon() == "mosin_nagant"))
		thread weapon_switch_hint_repeat();
	
	while(!(level.player getcurrentweapon() == "mosin_nagant"))
		wait .1;
		
	level notify("end_weapon_switch_hint");
	wait .5;
	level.letlev thread dialogue("moscow_rs1_shootingrange");//moscow_rs1_shootingrange
	level.letlev waittill("myisspeaking");
	level notify("shooting_range");
	level.letlev thread dialogue("moscow_rs1_imagine"); //moscow_rs1_imagine
	level.letlev waittill("myisspeaking");
	level.broken_bottles_max = 3;
	level notify ("skip_to_shoot_training_part2");
}

shoot_training_obeycheck(check, ender)
{
	level endon(ender);
	num = 0;
	x = 0;
	while(1)
	{
		level waittill(check);
		level.broken_bottles = 0;
		num++;
		if(num >= 4)
			break;
		
		switch(x)
		{
			case 0:{
				if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
				level.letlev thread dialogue("moscow_rs1_mannequinscold");
				level.letlev waittill("myisspeaking");
				}break;
			case 1:{
				if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
				level.letlev thread dialogue("moscow_rs1_mannequinscold2");
				level.letlev waittill("myisspeaking");
				}break;
			case 2:{
				if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
				level.letlev thread dialogue("moscow_rs1_shootbearscold");
				level.letlev waittill("myisspeaking");
				}break;
		}
		x++;
		level notify("reset_wait_shoot_nag_timer");
	}
	
	thread letlev_traitor_kill();
}

letlev_traitor_kill()
{	
	level.letlev notify("stop_idle");
	level.letlev notify("stop_block_anim");
	level.letlev stopanimscripted();
	level.letlev.standanim	= level.letlev.oldstandanim;
	level.letlev thread dialogue("moscow_traitor");
	level.letlev animscripts\shared::PutGunInHand("right");
	
	org = spawn("script_origin", level.letlev.origin);
	
	for(i = 0; i< 10; i++)
	{
		level.letlev stopanimscripted();
		ang = vectortoangles(level.player.origin - level.letlev.origin);
		org.angles = ang;
		org thread anim_single_solo(level.letlev, "aim_pistol");
		wait .1;
	}
	
	ang = vectortoangles(level.player.origin - level.letlev.origin);
	org.angles = ang;
	org thread anim_single_solo(level.letlev, "fire_pistol");
	level.letlev shoot();
	wait .2;
	
	ang = vectortoangles(level.player.origin - level.letlev.origin);
	org.angles = ang;
	org thread anim_single_solo(level.letlev, "fire_pistol");
	level.letlev shoot();
	//magicbullet("kar98k", level.letlev.origin, level.player.origin);	
	level.player enableHealthShield( false );
	// Kill player...
	level.player dodamage(level.player.health + 100000, level.letlev.origin);
	level.player enableHealthShield( true ); 
	
	wait .2;
	org thread anim_single_solo(level.letlev, "fire_pistol");
	level.letlev shoot();
	wait .2;
	org thread anim_single_solo(level.letlev, "fire_pistol");
	level.letlev shoot();
	wait .2;
	org thread anim_single_solo(level.letlev, "fire_pistol");
	level.letlev shoot();
	org anim_single_solo(level.letlev, "aim_pistol");
	org anim_single_solo(level.letlev, "aim_pistol");
}

shoot_training_skipcheck()
{
	level endon("skip_to_shoot_training_part2");
	level.flag["skip_to_shoot_training_part2"] = false;
	num = 0;
	while(num < 4)
	{
		level waittill("another_object_brokenbottle");
		num++;
	}
	level.broken_bottles_max = 6;
	level.flag["skip_to_shoot_training_part2"] = true;
	level notify("skip_to_shoot_training_part2");
}

shoot_training_part2()	
{
	level waittill("skip_to_shoot_training_part2");
	
	level notify("shooting_range");
//	level notify("enable_xenon_autoaim_bottles");	
	level notify("shoot_bottles");
	
 	level.shooting_message = "moscow_rs1_toomanybottles";//moscow_rs1_toomanybottles
 	thread shoot_timer(level.shooting_message);
 	
 	thread shoot_helpfullhints();
 	
 	while(!level.flag["broken_bottles"])
 	{
 		level notify("stop_shoot_training_timer");
 		thread shoot_timer(level.shooting_message);
 		
 		level waittill("another_object_brokenbottle");	
	}
	level notify("stop_shoot_training_timer");
	level notify("done_shooting_first_bottles");

	while(!level.flag["broken_bottles2"])
 	{
 		level notify("stop_shoot_training_timer");
 		thread shoot_timer(level.shooting_message);
 		
 		level waittill("another_object_brokenbottle2");	
	}
	
	array = getentarray("wine_bottle","script_noteworthy");
	for(i=0;i<array.size;i++)
		array[i].norecreate = 1;
	
	level notify("stop_shoot_training_timer");
	
	array = getentarray("xenon_auto_aim","targetname");
	array = array_merge(array, getentarray("xenon_auto_aim_secondary","targetname"));
	for(i=0;i<array.size;i++)
	{
		if(isdefined(array[i].script_noteworthy) && array[i].script_noteworthy == "bottles")
			array[i] thread delete_autoaim();
	}
	//level notify("enable_xenon_autoaim_helmets");
	level notify("level_forget_standing");
	level notify("enable_xenon_autoaim_helmets");
					
	wait 1;
	if(level.letlev.walking)
		level.letlev waittill("walking");
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev thread dialogue("moscow_rs1_difficultytest1");
	wait 4;
	level notify("given_difficulty_test");
	
	array = getentarray("helmet_pop","targetname");
	for(i=0;i<array.size;i++)
		array[i].norecreate = 1;
	
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev notify("pause_idle");
	level.letlev thread anim_loop_solo(level.letlev, "moscow_rs1_difficultytest_idle", undefined, "go");
	wait 1;
	level.letlev notify("go");
	level.letlev thread dialogue("moscow_rs1_difficultytest2");
	level.letlev waittill("myisspeaking");
	level.letlev notify("resume_idle");
	thread difficulty_test();
	bear	= getent("lowtarget_bear", "targetname");
	bear playLoopSound("bomb_tick");
	
	timer = maps\_utility::getstopwatch(60,15);
	wait ( 15 );
	bear stopLoopSound( "bomb_tick" );
	timer destroy();
	level notify("end_difficulty_test");
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	PUT THIS BACK IN IF DIFFICULTY GETS CUT
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				/*	low_score = 4;
					med_score = 7;
					
					if(level.xenon)
					{
						low_score = 3;
						med_score = 6;
					}
					
					if(level.difficulty_test_num < low_score)
						setcvar ("ui_moscow_rec_skill", "0");
					else if(level.difficulty_test_num < med_score)
						setcvar ("ui_moscow_rec_skill", "1");
					else
						setcvar ("ui_moscow_rec_skill", "2");
					
					level.player openMenu("moscow_skill");
					level.player freezecontrols(true);
					setblur(5, .1);
					level.player waittill("menuresponse", menu, response);
				    if(response == "yes")
   					{
   						level.player openMenu("moscow_difficulty");
   						level.player waittill("menuresponse", menu, response);
					}
				    setblur(0, .2);
				    level.player freezecontrols(false);
				    maps\_gameskill::resetskill();*/

					
	level notify("now_do_potato_training");
	array = getentarray("xenon_auto_aim","targetname");
	array = array_merge(array, getentarray("xenon_auto_aim_secondary","targetname"));
	for(i=0;i<array.size;i++)
	{
		if(isdefined(array[i].script_noteworthy) && array[i].script_noteworthy == "helmets")
			array[i] thread delete_autoaim();
	}
}

difficulty_test()
{
	level.difficulty_test_num = 0;
	
	level endon("end_difficulty_test");
	while(1)
	{
		level waittill("another_object_brokenhelmet");	
 		level.difficulty_test_num++;
 	}
}
delete_autoaim()
{
	if(!isdefined(self))
		return;
	self disableAimAssist();
	wait 5;
	if(!isdefined(self))
		return;
	self notify("xenon_auto_aim_stop_logic");
	self delete();	
}
melee_scene()
{
	chair = getent("prison_chair","targetname");
	german = getent("prison_german","targetname");
	
	if(level.jumpto_melee)
		wait .1;
	thread melee_scene_guard(chair, level.guard);
	german thread melee_scene_german(chair);
	level.letlev thread melee_scene_letlev(chair);
	
	level waittill("in_interogation");
	
	level.guard.message = "double";
	level.german.message = "double";
	level.guard notify("message");
	level.german notify("message");
	
	trig = getent("shoot_prisoner_trig", "targetname");
	trig waittill("trigger");
	
	level.letlev.message = "fire";	
	level.letlev notify("message");	
}

melee_scene_letlev(node)
{
	self endon("death");
	level waittill("letlev_do_prison");
	chair = spawn("script_origin", node.origin);
	chair.angles = node.angles;
	
	chair thread maps\_anim::anim_loop_solo ( self, "idle", undefined, "stop_chair_idle");
	while(1)
	{
		self waittill("message");
		switch(self.message)
		{
		/*	case "again":
				self thread melee_scene_letlev_again(chair);
				break;*/
			case "react":
			{
				chair notify("stop_chair_idle");
				chair maps\_anim::anim_single_solo ( self, "react");
				chair thread maps\_anim::anim_loop_solo ( self, "react_idle", undefined, "stop_chair_idle");		
			}break;
			case "leave":
			{
			
				chair notify("stop_chair_idle");
				if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
				level.letlev thread dialogue("moscow_rs1_armory", chair);
				wait 5.65;
				thread playsoundinspace("moscow_fistfist", level.letlev.origin);
				wait 2.475;
				thread playsoundinspace("moscow_fistfist", level.letlev.origin);
				wait .6;
				thread playsoundinspace("moscow_fistfist", level.letlev.origin);
				wait .6;
				thread playsoundinspace("moscow_fistfist", level.letlev.origin);
				level.letlev waittill("myisspeaking");
				//chair thread maps\_anim::anim_loop_solo ( self, "idle", undefined, "stop_chair_idle");
				level.letlev.neworg = spawn("script_origin", self.origin);
				
				ang = vectortoangles(level.german.origin - self.origin);
				level.letlev.neworg.angles = ang;
				level.letlev.neworg thread anim_loop_solo(self, "aim_pistol_idle", undefined, "stop_chair_idle");
				level.letlev animscripts\shared::PutGunInHand("right");
			}break;
			case "fire":
			{
				level.letlev.standanim	= level.letlev.oldstandanim;

				level.letlev.neworg notify("stop_chair_idle");
				level.letlev stopanimscripted();
						
				//level.letlev animscripts\shared::PutGunInHand("right");
				org = spawn("script_origin", level.letlev.origin);
				
				ang = vectortoangles(level.german.origin - level.letlev.origin);
				org.angles = ang;
				org thread anim_single_solo(level.letlev, "aim_pistol_down");
				wait .1;
				level.letlev stopanimscripted();
				level.letlev shoot();
				level.letlev playsound("moscow_execute");
				org anim_single_solo(level.letlev, "fire_pistol_down");
				
				level.german.message = "fire";
				level.german notify("message");

				level.letlev animscripts\shared::PutGunInHand("none");
				chair thread maps\_anim::anim_loop_solo ( self, "idle", undefined, "stop_chair_idle");
			}
		}
	}
}

melee_scene_guard(node, guy)
{
	if(level.jumpto_melee)
		return;
	guy endon("death");
		
	chair = spawn("script_origin", node.origin);
	chair.angles = node.angles;

	chair thread maps\_anim::anim_loop_solo ( guy, "idle", undefined, "stop_idle");
	while(1)
	{
		guy waittill("message");
		switch(guy.message)
		{
			case "double":
			{
				chair notify("stop_idle");
				//chair melee_scene_guard_sound();
				chair maps\_anim::anim_single_solo ( guy, "double");
				chair thread maps\_anim::anim_loop_solo ( guy, "idle", undefined, "stop_idle");
			}break;
			case "react":
			{
				chair notify("stop_idle");
				chair maps\_anim::anim_single_solo ( guy, "react");
				chair thread maps\_anim::anim_loop_solo ( guy, "react_idle", undefined, "stop_idle");		
			}break;
			case "talk":
			{
				chair notify("stop_idle");
			//	chair maps\_anim::anim_single_solo ( guy, "moscow_rs3_theirforces");
			//	chair maps\_anim::anim_single_solo ( guy, "moscow_rs3_theyhaveus");
				guy dialogue("moscow_rs3_theirforces", chair);
				guy dialogue("moscow_rs3_theyhaveus", chair);
				level notify("guard1_done_talking");
				chair thread maps\_anim::anim_loop_solo ( guy, "react_idle", undefined, "stop_idle");		
			}break;
		}
	}
}

melee_scene_guard_sound(xanim)
{
	while(1)
	{
		self waittill (xanim, notetrack);
		if (notetrack == "react")
			break;
	}	
	self playsound("moscow_punch1");
	while(1)
	{
		self waittill (xanim, notetrack);
		if (notetrack == "react")
			break;
	}
	self playsound("moscow_punch2");
	while(1)
	{
		self waittill (xanim, notetrack);
		if (notetrack == "end")
			break;
	}
}

#using_animtree("generic_human");
melee_scene_german(node)
{
	if(level.jumpto_melee)
		return;
	guy = self dospawn();
	spawn_failed(guy);
	
	guy endon("death");
	guy thread melee_scene_damage();
	
	level.german = guy;
	guy.ignoreme = true;
	guy.team = "neutral";
	guy.health = 100000;
	
	guy.animname = "german";
	chair = spawn("script_origin", node.origin);
	chair.angles = node.angles;
	
	chair thread maps\_anim::anim_loop_solo ( guy, "idle", undefined, "stop_idle");
	
	while(1)
	{
		guy waittill("message");
		level.flag["punishing"] = true;
		switch(guy.message)
		{

			case "double":
			{
				guy melee_scene_german_hit1(chair, "double");//, undefined);
			}break;	
			case "fire":
			{
				guy animscripts\shared::PutGunInHand("none");
				guy.deathanim = %crouchrun_death_crumple;
				guy attach("xmodel/weapon_luger", "tag_weapon_right");
				chair notify("stop_idle");
				guy stopanimscripted();
				guy teleport(guy.origin + (0, -22, 2), guy.angles);
				
				guy dodamage(level.german.health + 1000, level.letlev.origin);
		
			}

		}
		level.flag["punishing"] = false;
		level notify("punishing");
	}
}

#using_animtree("moscow");
flip_chair(node)
{
	self.animname = "chair";
	self UseAnimTree(#animtree);
	
	node thread maps\_anim::anim_single_solo (self, "drop");
}

melee_scene_german_hit(chair, animx, animb)
{
	chair notify("stop_idle");
	chair notify("stop_next_idle");
	chair endon("stop_next_idle");
	chair stopanimscripted();
	chair maps\_anim::anim_single_solo ( self, animx);
	chair maps\_anim::anim_single_solo ( self, animb);
	chair thread maps\_anim::anim_loop_solo ( self, "idle", undefined, "stop_idle");
}

melee_scene_german_hit1(chair, animx)
{
	chair notify("stop_idle");
	chair notify("stop_next_idle");
	chair endon("stop_next_idle");
	chair stopanimscripted();
	
	self animscripted(animx, chair.origin, chair.angles, level.scr_anim[self.animname][animx]);
	self melee_scene_guard_sound(animx);
	//chair maps\_anim::anim_single_solo ( self, );
	chair thread maps\_anim::anim_loop_solo ( self, "idle", undefined, "stop_idle");
	self notify("german_done_pain");
}

melee_scene_damage()
{
	level endon("killing extra allies");
	self endon("death");
	hits = 0;
	while(1)
	{
		self waittill("damage", amount, ent);
		
		if(ent != level.player)
			continue;
		
		level notify("hud_elem_going_up");
		setCvar("ui_deadquote", &"MOSCOW_MISSION_FAIL_PRISONER");
		maps\_utility::missionFailedWrapper();
		continue;
	}
}

melee_done_nag(org)
{
	level endon("go_to_prison");
	var = true;
	while(1)
	{
		if(!level.flag["letlev_ready_for_comewithme"])
			level waittill("letlev_ready_for_comewithme");
		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
		level.letlev notify("stop_idle");
		level.letlev notify("stop_block_anim");
		org notify("stop_idle");
		level.letlev stopanimscripted();
		level.letlev thread dialogue("moscow_rs1_comewithme", org);//moscow_rs1_comewithme
		level.letlev waittill("myisspeaking");
		if(var)
			thread add_hudelm_hint(level.strings["objectives"], undefined, 5);
		thread friendly_letlev_block(org);
		wait 10;	
		var = false;		
	}
}

melee_letlev_walk(chair)
{
	level endon("in_interogation");
	self.goalradius = 1;
	self thread melee_letlev_walk2(chair);
	self thread melee_letlev_walk3(chair);
	node = getnode("levlev_start_prison_path", "targetname");
	
	while(isdefined(node))
	{
		self setgoalnode(node);
		self waittill("goal");
		
		if(distance(self.origin, level.player.origin) > 300 && (distance(self.origin, chair.origin) < distance(level.player.origin, chair.origin)))
		{
			org = spawn("script_origin", node.origin);
			org.angles = node.angles + (0,0,0);
			//thread friendly_letlev_block(org);
			thread melee_done_nag(org);
				
			while(distance(self.origin, level.player.origin) > 300 && (distance(self.origin, chair.origin) < distance(level.player.origin, chair.origin)))
				wait .1;
				
			level notify("go_to_prison");
			if(level.letlev.myisspeaking)
				level.letlev waittill("myisspeaking");
			level.letlev notify("stop_idle");
			level.letlev notify("stop_block_anim");
			org notify("stop_idle");
			level.letlev stopanimscripted();
			org delete();
		}
		if(isdefined(node.target))
			node = getnode(node.target, "targetname");
		else
			node = undefined;
	}	
	
	thread melee_letlev_walk4(chair);
	
	
}

melee_letlev_walk2(chair)
{
	level endon("in_interogation");
	level endon("letlev_now_running_to_prisoner");
	while(1)
	{
		wait .1;
		if(distance(self.origin, level.player.origin) > 200 && (distance(self.origin, chair.origin) < distance(level.player.origin, chair.origin)) )
			self.walkdist = 5000000;
		else
			self.walkdist = self.oldwalkdist;
	}	
}

melee_letlev_walk4(chair)
{
	level notify("letlev_now_running_to_prisoner");
	self.walkdist = self.oldwalkdist;
	chair anim_reach_solo (self, "idle_start");
	level.flag["letlev_do_prison"] = true;
	level notify("letlev_do_prison");
}

melee_letlev_walk3(chair)
{
	level endon("letlev_now_running_to_prisoner");
	level waittill("in_interogation");
	level.letlev notify("stop_idle");
	level.letlev notify("stop_block_anim");	
	level.letlev stopanimscripted();
	self.walkdist = self.oldwalkdist;
	chair anim_reach_solo (self, "idle_start");
	level.flag["letlev_do_prison"] = true;
	level notify("letlev_do_prison");
}

melee_letlev_inplace(node)
{	level endon("go_to_prison");
	level endon("in_interogation");
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev notify("stop_idle");
	level.letlev notify("stop_block_anim");
	level.letlev stopanimscripted();
	level.letlev setgoalnode(node);
	level.letlev.goalradius = 4;
	level.letlev waittill("goal");
	level.flag["letlev_ready_for_comewithme"] = true;
	level notify("letlev_ready_for_comewithme");
	level.letlev.walkdist = level.letlev.oldwalkdist;
	thread friendly_letlev_block(node);
}

#using_animtree("generic_human");
melee_training()
{	
	node = getnode("auto8777", "targetname");
	thread melee_training2(node);
	
	htspawntrig = getent("ht_spawn_trig","targetname");
	htspawntrig triggerOff();
	
	if(!level.jumpto_melee)
		level waittill("grenade_training_done");
	
	htspawntrig triggerOn();
	spawner = getent("informer","targetname");
	guy = spawner dospawn();
	
	spawn_failed(guy);
	level.informer = guy;
	guy pushplayer(true);
		
		guy.walk_combatanim2 		= %moscow_rs4_sc02a_run;
		guy.walk_combatanim 		= %moscow_rs4_sc02a_run;
		guy.walk_noncombatanim2 	= %moscow_rs4_sc02a_run;
		guy.walk_noncombatanim 		= %moscow_rs4_sc02a_run;
		guy.run_combatanim			= %moscow_rs4_sc02a_run;
		guy.anim_combatrunanim		= %moscow_rs4_sc02a_run;
		guy.run_noncombatanim		= %moscow_rs4_sc02a_run;
		guy.standanim				= %moscow_rs4_sc02a_idle;
		
		goalnode = getnode(spawner.target, "targetname");
		ent = spawn("script_origin", goalnode.origin + (-10,70,0));
		ent.angles = goalnode.angles;
		//guy setgoalpos(ent.origin);
		
	thread melee_letlev_inplace(node);
	thread melee_scene();
	trigger = getent("at_interigation_room", "targetname");
	trigger thread melee_training_trig();
	
	wait 2;
	
	guy.animname = "rs4";
	guy thread dialogue("moscow_rs4_comradecommissar");//moscow_rs4_comradecommissar
	level endon("in_interogation");
	ent anim_reach_solo(guy, "moscow_rs4_gotprisoner");
	//guy waittill("goal");
	guy thread dialogue("moscow_rs4_gotprisoner");//moscow_rs4_gotprisoner
	wait .75;
	guy setgoalpos(guy.origin);
	guy waittill("myisspeaking");
	level notify("comewithme");
	
	trigger = getent("go_to_prison","targetname");
	trigger thread melee_training_trig2();
	
	//level waittill("star_hint_done");
	level notify("melee_training2");
}

melee_training_trig2()
{
	level endon("in_interogation");
	while(1)
	{
		self waittill("trigger");
		level notify("go_to_prison");
		//level notify("melee_training2");
	}
}

melee_training_trig()
{
	self waittill("trigger");
	level.flag["in_interogation"] = true;
	level notify("in_interogation");
	level notify("melee_training2");
}

melee_friendliesgostand()
{
	level waittill("letlev_do_prison");
	
	ai = getai("intro_shooters", "script_noteworthy", "allies");
	nodes = getnodearray("interogate_bystanders", "targetname");
	
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].moscow_potato_throw))
			ai[i].moscow_potato_throw notify("stop_idle");
		ai[i] setgoalnode(nodes[i]);
		ai[i].goalradius = 16;
		ai[i] pushplayer(false);
	}
}

melee_training2(node)
{
	level waittill("melee_training2");	
	thread melee_friendliesgostand();
	if(!level.flag["in_interogation"])
	{
		if(!(level.player istouching(getent("go_to_prison","targetname"))))
		{
			
			thread melee_done_nag(node);
			level waittill("go_to_prison");
		}
	}
	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
	level.letlev notify("stop_idle");
	level.letlev notify("stop_block_anim");
	level.letlev stopanimscripted();
	
	model = getent("prison_chair","targetname");
	chair = spawn("script_origin",model.origin);
	chair.angles = model.angles;
		
	if(!level.flag["in_interogation"])
	{
		level.letlev thread melee_letlev_walk(chair);
		level waittill("in_interogation");
	}
	else
		level.letlev thread melee_letlev_walk4(chair);

	thread killinformer();
	
	wait 1;
	
	level.flag["stop_random_punish"] = true;
	if(level.flag["punishing"])
		level waittill("punishing");
	
	level.german dialogue("moscow_gs3_pleasenomore", chair, false);//moscow_gs3_pleasenomore
	
	if(!level.flag["letlev_do_prison"])
		level waittill("letlev_do_prison");
	
	thread german_talk(chair);
	
	wait 1.5;
	level.guard.message = "talk";
	level.guard notify("message");
	level waittill("guard1_done_talking");
	
	thread informer2();
	//door solid();
	
	wait .25;
	
	level.guard.message = "react";
	level.guard notify("message");
	level.letlev.message = "react";
	level.letlev notify("message");
	
	level waittill("informer2_donetalking");
	
	thread battleChatterOn();
//	wait 1;
	level.letlev.message = "leave";
	level.letlev notify("message");
	wait 1.0;
	level notify("attack_of_the_drones");
	wait 10;
	level notify("trench_run");
	player_prison_blocker = getent("player_prison_blocker","targetname");
	player_prison_blocker delete();
}

killinformer()
{
	if(level.informer.myisspeaking)
		level.informer waittill("myisspeaking");
	level.informer delete();
}
informer2_door()
{
	door = getent("interogation_door","targetname");
	//door setshadowhint( "receiver" );
	door notsolid();
	door connectpaths();
	door playsound("moscowdoor_open");
	exploder(1);
	door rotateyaw(-90, 0.4,0.0,0.0);
}

informer2_door_setup()
{
	door = getent("interogation_door","targetname");
	//door setshadowhint( "receiver" );
	door rotateyaw(90, 0.4,0.0,0.0);
	
	wait 1;
	
	door solid();
	door disconnectpaths();
	
}

informer2()
{
	atnode = getent("serious_attack_node","targetname");
	
	spawner = getent("informer2","targetname");
	guy = spawner dospawn();
	spawn_failed(guy);
	
	thread informer2_door();	
	
	guy.animname = "rs4";
	guy dialogue("moscow_rs4_seriousattack", atnode);//moscow_rs4_seriousattack
	level notify("informer2_donetalking");
	atnode = spawn("script_origin", guy.origin);
	atnode.angles = guy.angles;
	atnode thread anim_loop_solo(guy, "listen", undefined, "stop_idle");
	
	level waittill("trench_run");
	
	atnode anim_single_solo(guy, "go");
}

german_talk(chair)
{
	level.german dialogue("moscow_gs3_ourforces", chair, false);//moscow_gs3_ourforces
	wait 1.7;
	level.german dialogue("moscow_gs3_mobilearty", chair, false);//moscow_gs3_mobilearty
}

melee_button()
{
	level endon("grenade_training_done");
	while(1)
	{
		while(!level.player meleebuttonpressed())
			wait .05;
		
		level.flag["melee_button"] = true;
		wait .3;
		level.flag["melee_button"] = false;
	}		
}

charge_group_main()
{
	//wait 2;
	spwners = getentarray("charge_group_1","targetname");
	array_thread(spwners, ::charge_group_guys);	
	spwners = getentarray("charge_truck_guys","targetname");
	array_thread(spwners, ::charge_truck_guys);	
	
	node = getvehiclenode("charge_truck_stop","targetname");
	node waittill("trigger");
	level.flag["charge_truck_in_place"] = true;
	level notify("charge_truck_in_place");
}

charge_truck_guys()
{
	self waittill("spawned", guy);
	if(spawn_failed(guy))
		return;
	
	guy endon("death");
	guy.health *= 2;
	guy.dropweapon = false;
	guy.baseAccuracy = 0;
	guy allowedstances("crouch");//, "prone", "stand");
	guy.ignoreme = true;
	
	level waittill("charge_truck_in_place");
	guy allowedstances("crouch", "prone", "stand");
	wait 1;
	guy.ignoreme = false;
	
	level waittill("smoke_grenade_in_right_place");
	guy dodamage(guy.health + 1000, (0,0,0));
}

charge_group_guys()
{
	level endon("smoke_grenade_in_right_place");
	num = 3;
	while(num)
	{
		guy = self dospawn();
		if(spawn_failed(guy))
		{
			wait randomfloat(.25);
			continue;
		}
		guy thread charge_group_guys_think();
		guy thread charge_group_guys_die();
	
		guy waittill("death");
		self.count++;
		wait randomfloat(.25);
		num--;
	}
}

charge_group_guys_die()
{
	self endon("death");
	level waittill("smoke_grenade_in_right_place");
	wait randomfloat(1);
	self dodamage(self.health + 1000, (0,0,0));	
}


charge_group_guys_think()
{
	self endon("death");
	
	self.health *= 2;
	self.baseAccuracy = 0;
	self.ignoreme = true;
	self.dropweapon = false;
	self.suppressionwait = 0;
	node = getnode(self.target, "targetname");
	while(isdefined(node))
	{
		self setgoalnode(node);
		self.goalradius = node.radius;
		self waittill("goal");
		wait 4;
		if(isdefined(node.script_noteworthy))
		{
			self.ignoreme = false;
			self.suppressionwait = 3;
			if(!level.flag["charge_truck_in_place"])
				level waittill("charge_truck_in_place");
		}
		if(isdefined(node.target))
			node = getnode(node.target, "targetname");
		else
			node = undefined;
	}
}

trench_stopdeaths(trigger)
{
	wait 4;
	trigger notify("stop_drone_loop");
	wait 6;
	org = spawn("script_origin", (-1553, 241, 0));
	org playsound("walla_russian_small");
	org moveto((-543, 279, -150), 12, 1,.5);
	wait 30;
	org delete();
}

trenchrun_plane()
{
	plane = plane_makeone("p1");//, undefined, 220);
	wait 1.5;
	plane2 = plane_makeone("p2");//, undefined, 220);
	plane waittill("reached_end_node");
	plane delete();
	plane2 delete();
}

trench_run()
{
	trig = getent("drone_allies_dead","script_noteworthy");
	trig2 = getent("drone_allies_alive","script_noteworthy");
	trig triggerOff();
	trig2 triggerOff();
	if(level.jumpto_trench)
	{
//DRONE CHARGE GONE					trig notify("trigger");
//DRONE CHARGE GONE					trig2 notify("trigger");
//DRONE CHARGE GONE					thread trench_stopdeaths(trig);
		wait 1;
	}
	else
	{
		level waittill("attack_of_the_drones");
//DRONE CHARGE GONE					trig notify("trigger");
//DRONE CHARGE GONE					trig2 notify("trigger");
//DRONE CHARGE GONE					thread trench_stopdeaths(trig);
		level waittill("trench_run");
	}	
	
	thread crouch_training();
	thread prone_training();
	
	thread charge_group_main();
		
	ai = getai("intro_shooters", "script_noteworthy", "allies");	
	temp = getai("informer2", "script_noteworthy", "allies");	
	ai[ai.size] = temp[0];
	array_thread(ai, ::trench_run_think);
	
	trig = getent("mantle_hint","targetname");
	trig waittill("trigger");
	thread autoSaveByName("mantle");
	ai = getai("intro_shooters", "script_noteworthy", "allies");	
	snd = getClosestEnt(level.player.origin, ai);
	thread playsoundinspace("moscow_rs3_overwall", snd.origin);
	
	add_hudelm_hint(level.strings["mantle"], "mantle_hint_done");
	thread mantlehint_checkagain();
	trig = getent("mantle_hint_done","targetname");
	trig waittill("trigger");
	level notify("mantle_hint_done");
	
	trig = getent("stand_hint","targetname");
	trig waittill("trigger");
	
	//thread trenchrun_plane();
	
	temp = getaiarray("allies");
	ai = [];
	for(i=0;i<temp.size;i++)
	{
		if(isdefined(temp[i].trench_run))
			ai[ai.size] = temp[i];	
	}
	ai[0].animname = "rs4";
	playsoundinspace("moscow_rs4_toonarrow", ai[0].origin);

	trig = getent("gotobasement","targetname");
	trig waittill("trigger");
	wait .5;
	
	temp = getaiarray("allies");
	ai = [];
	for(i=0;i<temp.size;i++)
	{
		if(isdefined(temp[i].trench_run))
		{
			ai[ai.size] = temp[i];	
			temp[i] thread maps\_utility::magic_bullet_shield(); 
		}
	}

	node = getnode("basement_node", "targetname");
	nodes = getnodearray("gotobasement_nodes","targetname");
	num = 0;
	nodenum = 0;
	
	while(num < 3)
	{
		guy = getFurthestEnt(node.origin, ai);
		ai = array_remove(ai, guy);
		guy.basementnode = nodes[nodenum];
		nodenum++;
		guy notify("go_to_basement");
		wait 5;
		num++;
	}
	level waittill("delete_basement");
	while(ai.size)
	{
		guy = getClosestEnt(node.origin, ai);
		ai = array_remove(ai, guy);
		guy delete();
	}
}

mantlehint_checkagain()
{
	level endon("mantle_hint_done");
	
	while(1)
	{
		if(level.xenon)
			level.strings["mantle"] = maps\moscow_str::hint_stance_check(level.strings["mantle"], "mantle");
		else	
			level.strings["mantle"] = maps\moscow_str::hint_mantle(level.strings["mantle"]);	
		wait .05;
	}
}

basementliver()
{
	if(self.script_noteworthy == "basement_leader")
		return;
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;	
	guy endon("death");
	//guy.anim_forced_cover = "show";	
	guy.animname = "generic";
	
	node = getnode(self.target, "targetname");
	if(guy.anim_guninhand == "xmodel/weapon_ppsh")
	{
		ammo=0;
		while(1)
		{	
			node thread anim_loop_solo(guy, "aim", undefined, "stop_aim");
			wait (2 + randomfloat(2));
			node notify("stop_aim");
			n = 2 + randomint(6);
			for(j=0;j<n;j++)
			{
				node thread anim_single_solo(guy, "fire_full");
				for(i=0;i<3;i++)
				{
					wait .1;
					guy shoot();	
				}
				ammo++;
			//	guy waittillmatch ("single anim", "end");
			}
			
			if(ammo >= 10)
			{
				node anim_single_solo(guy, "reload_crouch");
				ammo = 0;	
			}
		}
	}
	else
	{
		ammo=0;
		while(1)
		{	
			node thread anim_loop_solo(guy, "aim", undefined, "stop_aim");
			wait (3 + randomfloat(3));
			node notify("stop_aim");
			node thread anim_single_solo(guy, "fire_semi");
			guy shoot();	
			ammo++;
			node waittill("fire_semi");
			if(ammo >= 4)
			{
				thread playsoundinspace("weap_nagant_reload_npc",guy.origin);
				node anim_single_solo(guy, "reload_crouch");
				ammo = 0;	
			}
			else
			{
				thread playsoundinspace("weap_nagant_rechamber_npc",guy.origin);
				node anim_single_solo(guy, "chamber");
			}
		}
	}
}

trench_run_think()
{
	self endon("death");
	self.trench_run = true;
	self.oldinterval = self.interval;
	self.interval = 15;
	self.suppressionwait = 0;
	
	node = getnode("mantle_pause", "targetname");
	self setgoalnode(node);
	self.goalradius = node.radius;
	self.anim_forced_cover = "hide";
	
	trig = getent("mantle_hint","targetname");
	trig waittill("trigger");
	
	self.anim_forced_cover = "none";
	node = getnode("trenchnode", "targetname");
	self setgoalnode(node);
	self.goalradius = node.radius;
	
	self waittill("goal");
	self.anim_forced_cover = "hide";
	self set_forcegoal();
	self waittill("go_to_basement");
	self pushplayer(true);
	self.anim_forced_cover = "none";
	self.interval = 0;
	self.oldmax = self.maxdist;
	self.oldfight = self.fightdist;
	self.maxdist = 16;
	self.fightdist = 16;
	self.nointervalchange = true;
	self.ignoreme = true;
	self setgoalnode(self.basementnode);
	self.goalradius = self.basementnode.radius;
	self.grenadeawareness = 0;
	self thread trench_run_basement_count();
	
	level waittill("delete_basement");
	if(self.trench_run)
		self delete();
}

trench_run_basement_count()
{
	if(!isdefined(level.trench_run_basement_count))
		level.trench_run_basement_count = 0;
	level.trench_run_basement_count++;
	self endon("death");
	self endon("forget_basement");
	level endon("delete_basement");
	
	self thread trench_run_basement_count2();
	
	self waittill("goal");
	self pushplayer(false);
	self notify("trench_run_basement_count");
	
	level.trench_run_basement_count--;
	if(!level.trench_run_basement_count)
		level notify("last_guy_is_in_basement");
}

trench_run_basement_count2()
{
	self endon("trench_run_basement_count");
	self waittill("death");
	level.trench_run_basement_count--;
	if(!level.trench_run_basement_count)
		level notify("last_guy_is_in_basement");
}

split_main()
{
	spwners = getentarray("meetup_guys","targetname");	
	array_thread(spwners, ::split_meetup_think);
	spwners = getentarray("street_runners1","targetname");
	level.split_street1_death = spwners.size;
	array_thread(spwners, ::split_street1_think);
	
	level waittill("street_runners1");
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
		ai[i].baseAccuracy = .5;
}

split_street1_death()
{
	self waittill("death");
	level.split_street1_death--;
	level notify("split_street1_death");
}

split_street1_think()
{
	self waittill("spawned", guy);
	if (spawn_failed(guy))
	{
		level.split_street1_death--;
		return;	
	}
	guy endon("death");	
	
	level notify("street_runners1");
	
	guy thread split_street1_death();
	
	node = getnode(self.target,"targetname");
	guy setgoalnode(node);
	guy.goalradius = node.radius;
	
	trig = getent("street_runner_retreat", "targetname");
	trig waittill("trigger");
	node = getnode(node.target, "targetname");
	guy set_forcegoal();
	guy setgoalnode(node);
	guy.goalradius = node.radius;
	guy waittill("goal");
	guy unset_forcegoal();
}

split_meetup_think()
{
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;	
	guy endon("death");	
	guy thread friendly_reinforcements_think1();
	level waittill("friendlies_at_split");
	guy setgoalentity(level.player);
}

smoke_grenade_dialogue()
{
	if(!isdefined(level.smoke_guy))
		level waittill("defined_level_smoke_guy");
	if(!isdefined(level.smoke_guy.smoke_node))
		level.smoke_guy waittill("smoke_node");
		
	level.smoke_guy notify("stop_my_idle");
	level.smoke_guy thread dialogue ("moscow_rs4_dontrunout", level.smoke_guy.smoke_node);//moscow_rs4_dontrunout
	level.smoke_guy waittill("myisspeaking");
	if(level.flag["waiting_for_smoke_to_fill"])
		return;
		
	level endon("waiting_for_smoke_to_fill");
	level endon("player_threw_nade");
	wait .5;
	level notify("print_nade_throw_hint");
}

smoke_killplayer()
{
	level endon("smoke_grenade_in_right_place");
	ht = getent("smoke_halftrack", "targetname");
	time = 0;
	while(1)
	{
		self waittill("trigger",other);
		if(other == level.player)
		{
			level.player dodamage(75, ht.origin);
			wait .75;
			time++;
		}	
		if(time > 2)
		{
			level.player enableHealthShield( false );
			level.player dodamage(level.player.health + 100000, ht.origin);
			level.player enableHealthShield( true ); 
		}
			
	}	
}

ladder_climb_wait()
{
	trig = getent("smoke_dialogue","targetname");
	trig waittill("trigger");
	level.flag["smoke_nade_obj"] = true;
	level notify("smoke_nade_obj");
}
nade_hint_repeat_kill(msg)
{
	level endon("player_threw_nade_part2");
	level waittill(msg);
	level notify("player_threw_nade_part2");
}
smoke_grenade_training2()
{
	thread ladder_climb_wait();
	level endon("smoke_grenade_in_right_place");
	thread potato_hint_repeat("player_threw_nade_part2");
	thread nade_hint_repeat_kill("player_threw_nade");
	thread nade_hint_repeat_kill("smoke_grenade_in_right_place");
	
	level waittill("smoke_nade_obj");
	
	trig = getent("kill_player","targetname");
	trig thread smoke_killplayer();

	thread smoke_grenade_dialogue();
	thread smoke_placement_hint();
	thread infinite_grenade_check("smoke_grenade_russian", "smoke_grenade_in_right_place");
}

smoke_placement_hint()
{
	level endon("smoke_grenade_in_right_place");
	level waittill("give_player_another_smoke");
	wait 1;	
	glow = getent("smoke_nade_location_hint","targetname");
	glow show();
	add_hudelm_hint(level.strings["smoke_placement"], "smoke_grenade_in_right_place");
}

smoke_grenade_training_package()
{
	thread smoke_grenade_training2();
	thread smoke_glow();
}

smoke_right_place()
{
	trigger = getent("smoke_touch", "targetname");
	trigger thread smoke_waittill_thrown();
}	
smoke_grenade_training()
{	
	glow = getent("smoke_nade_location_hint","targetname");
	glow hide();
	
	level waittill("in_basement");
	thread battleChatterOff( "allies" );
	
	thread smoke_guy_dialogue();
	thread smoke_right_place();
	thread smoke_grenade_training_package();

	level waittill("smoke_obj_done");

	if(level.flag["fc200"])
		return;
	trig = getent("fc100", "target");
	trig notify("trigger");
}

smoke_glow()
{
	glow = getent("smoke_nade_location_hint","targetname");
	level waittill("smoke_grenade_in_right_place");
	glow hide();
}

smoke_guy_dialogue_timer()
{
	level endon("smoke_nade_obj");
	level.smoke_guy_dialogue_timer = 0;
	while(1)
	{
		level waittill("smoke_grenade_in_right_place");
		thread smoke_guy_dialogue_timer2();
		thread smoke_right_place();
	}
}

smoke_guy_dialogue_timer2()
{
	level notify("smoke_guy_dialogue_timer");
	level endon("smoke_guy_dialogue_timer");
	time = .5;
	level.smoke_guy_dialogue_timer = 0;
	while(1)
	{
		wait time;
		level.smoke_guy_dialogue_timer += time;
		println(level.smoke_guy_dialogue_timer);
	}
}

smoke_guy_dialogue()
{
	thread smoke_guy_dialogue_timer();
	level waittill("smoke_grenade_in_right_place");
	if(!level.flag["smoke_nade_obj"])
	{
		if(!level.flag["grabbed_all_basement_goods"])
			level waittill("grabbed_all_basement_goods");
		level waittill("smoke_nade_obj");
		level notify("smoke_guy_dialogue_timer");
		if(level.smoke_guy_dialogue_timer > 41.0)
		{
			level.smoke_guy_dialogue_timer = 0;
			thread smoke_grenade_training_package();
			level waittill("smoke_grenade_in_right_place");
		}	
	}	
	
	snd = getnode ("ladder_node_guy2","targetname");
	
	if(level.smoke_guy_dialogue_timer < 10)
	{
		if(isdefined(level.smoke_guy.myisspeaking) && level.smoke_guy.myisspeaking == true)
		{
			level.smoke_guy waittill("myisspeaking");
			wait .1;
		}
		if(!isdefined(level.smoke_guy.smoke_node))
			level.smoke_guy waittill("smoke_node");
			
		level.smoke_guy notify("stop_my_idle");	
		level.smoke_guy thread dialogue("moscow_rs4_waitforsmoke", level.smoke_guy.smoke_node);//moscow_rs4_waitforsmoke
		level.smoke_guy waittill("myisspeaking");
		wait 3;
	}	
	if(level.smoke_guy_dialogue_timer < 25)
	{
		if(!isdefined(level.smoke_guy.smoke_node))
			level.smoke_guy waittill("smoke_node");
			
		level.smoke_guy notify("stop_my_idle");	
		level.smoke_guy thread dialogue("moscow_rs4_holdpositions", level.smoke_guy.smoke_node);//moscow_rs4_holdpositions
		level.smoke_guy waittill("myisspeaking");
		wait 3;
	}

	level.flag["smoke_obj_done"] = true;
	level notify("smoke_obj_done");
	
	level.smoke_guy notify("stop_my_idle");
	level.smoke_guy thread dialogue("moscow_rs4_letsgo");	//moscow_rs4_letsgo

	level.smoke_guy endon("death");
	
	level.smoke_guy notify ("stop magic bullet shield");
	level.smoke_guy setgoalentity(level.player);
	
	wait 4;
	level.smoke_guy.ignoreme = false;	
}


smoke_waittill_thrown()
{
	level endon("smoke_grenade_in_right_place");
	level endon("waiting_for_smoke_to_fill");
	level endon("smoke_obj_done");
	
	while(1)
	{
		grenades = getentarray ("grenade", "classname");
		if(grenades.size > 0)
		{
			for (i = 0; i < grenades.size; i++)
			{
				if(grenades[i].model == "xmodel/projectile_us_smoke_grenade")
				{
					grenades[i] thread smoke_waittill_thrown2(self);
					level notify("player_threw_nade");
				}
			}
		}
		wait .1;
	}
}

smoke_waittill_thrown2(volume)
{
	level endon("smoke_grenade_in_right_place");
	level endon("waiting_for_smoke_to_fill");
	level endon("smoke_obj_done");
	
	if(isdefined(self.inthrownthread2))
		return;
	else
		self.inthrownthread2 = true;
	
	self thread smoke_waittill_thrown3();
	
	self endon("deleting");
	while(1)
	{
		if ( self istouching(volume))
		{
			self notify("do_not_delete");
			wait 1;
			//make sure it didn't bounce somewhere else
			if (self istouching(volume))
			{
				level.flag["smoke_grenade_in_right_place"] = true;
				level notify("smoke_grenade_in_right_place");
			}
			//otherwise dont clog the map with smoke nades
			else
			{
				level.smokeposition = "null";
				if(self istouching(getent("smoke_nade_toofar","targetname")))
					level.smokeposition = "too_far";
				else if(self istouching(getent("smoke_nade_tooclose","targetname")))
					level.smokeposition = "too_close";
				else if(self istouching(getent("smoke_nade_tooleft","targetname")))
					level.smokeposition = "too_left";
				else if(self istouching(getent("smoke_nade_tooright","targetname")))
					level.smokeposition = "too_right";
				level notify ("give_player_another_smoke");
				self delete();
			}
			break;
		}
		wait .1;
	}
}

smoke_waittill_thrown3()
{
	level endon("smoke_grenade_in_right_place");
	level endon("waiting_for_smoke_to_fill");
	level endon("smoke_obj_done");
	if(isdefined(level.smokenade_hint))
		level.smokenade_hint= undefined;

	noammo = false;
	self endon("do_not_delete");
	if(! (level.player getammocount("smoke_grenade_american") )  )
		noammo = true;
			
	wait 3.5;
	
	if(noammo)
		level.smokeposition = "get_more";
	else
	{
		level.smokeposition = "null";
		if(self istouching(getent("smoke_nade_toofar","targetname")))
			level.smokeposition = "too_far";
		else if(self istouching(getent("smoke_nade_tooclose","targetname")))
			level.smokeposition = "too_close";
		else if(self istouching(getent("smoke_nade_tooleft","targetname")))
			level.smokeposition = "too_left";
		else if(self istouching(getent("smoke_nade_tooright","targetname")))
			level.smokeposition = "too_right";
	}
	level notify ("give_player_another_smoke");
	self notify("deleting");
	self delete();	
}

smoke_moment_speach(message, node)
{
	level notify("smoke_guy_talking_again");
	level endon("smoke_guy_talking_again");
	if(isdefined(self.myisspeaking) && self.myisspeaking == true)
	{
		if(message != "moscow_rs3_moresmoke")
			return;
		self waittill("myisspeaking");	
		wait .25;
	}
	if(isdefined(node))
	{
		self notify("stop_my_idle");
		self thread dialogue(message, node);
	}
	else
		self thread dialogue(message);
}

infinite_grenade_check(name, message)
{
	level endon(message);
			
	while(1)
	{
		level waittill("give_player_another_smoke");
			
		switch(level.smokeposition)
		{
			case "null":
				level.smoke_guy thread smoke_moment_speach("moscow_rs4_whatyoudoing");
				break;	
			case "get_more":
				level.smoke_guy thread smoke_moment_speach("moscow_rs3_moresmoke", level.smoke_guy.smoke_node);
				break;
			case "too_far":
				level.smoke_guy thread smoke_moment_speach("moscow_rs4_toofar");
				break;
			case "too_close":
				level.smoke_guy thread smoke_moment_speach("moscow_rs4_tooclose");
				break;
			case "too_left":
				level.smoke_guy thread smoke_moment_speach("moscow_rs4_toofarleft");
				break;
			case "too_right":
				level.smoke_guy thread smoke_moment_speach("moscow_rs4_toofarright");
				break;
			
		}
	}
}

weapon_switch_reloadhint()
{
	level.flag["next_hud_elm"] = false;
	while(!level.player hasweapon("ppsh"))
 		wait .1;
 	slot = undefined;
 	if( (level.player getweaponslotweapon("primary")) == "ppsh")
 	{
 		slot = "primary";
 		level.player setweaponslotclipammo("primary", 1);
	 	level.player setweaponslotammo("primary", 504);
 	}
 	else
 	{
 		slot = "primaryb";
	 	level.player setweaponslotclipammo("primaryb", 1);
	 	level.player setweaponslotammo("primaryb", 504);
	}
	
	add_hudelm_hint(level.strings["reload"], "player_reloaded");
	
	ammocount = level.player getweaponslotclipammo(slot);
	thread player_reloaded1();
	thread player_reloaded2(ammocount, slot);
	
 	level waittill("player_reloaded");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* 	
 	if(level.xenon)
		special_hint("gfx/icons/hud@steilhandgrenate.tga", "reload_special", 30, -10, 10, -50, 80, "right");
	else
		special_hint("gfx/icons/hud@steilhandgrenate.tga", "reload_special", 30, -10, 10, -60, 175, "right");
*/	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	level.flag["next_hud_elm"] = true;
	level notify("next_hud_elm");
}

player_reloaded1()
{
	level endon("player_reloaded");
	wait level.hud_repeat_rate;
	level notify("player_reloaded");
}
player_reloaded2(ammocount, slot)
{
	level endon("player_reloaded");
	while(ammocount == level.player getweaponslotclipammo(slot))
		wait .1;
	level notify("player_reloaded");
}
waitforgrabwaepon(weap, index)
{
	while(!level.player hasweapon(weap))
		wait .1;
	level.bsmtweaps[index] = true;
	
	level.bsmtweaps["num"]-=1;
	if(level.bsmtweaps["num"] == 0)
	{
		level.flag["grabbed_all_basement_goods"] = true;
		level notify("grabbed_all_basement_goods");
	}
}

weapon_switch_hint()
{
	self waittill("trigger");
	hint = add_hudelm_hint(level.strings["swap_weapon"]);
	while(!level.player hasweapon("ppsh"))
		wait .1;	
	hint remove_hudelm_hint();
}

basement_blocker()
{
	clip = getent("player_basement_move_blocker","targetname");
	clip notsolid();
	
	level endon("delete_basement");
	clip thread basement_blocker_delete();
	level waittill("last_guy_is_in_basement");
	
	if(!level.flag["player_in_basement"])
		level waittill("player_in_basement");
	
	clip solid();
	
	node = getnode("gotobasement_blocker","targetname");
	temp = getai("intro_shooters", "script_noteworthy", "allies");
	ai = [];
	for(i=0;i<temp.size;i++)
	{
		if(isdefined(temp[i].trench_run) && temp[i].trench_run == true)
			ai[ai.size] = temp[i];
	}
	guy = getClosestEnt(node.origin, ai);
	guy setgoalnode(node);
	guy pushplayer(false);
	
	dist = 150*150;
	while(distancesquared(level.player.origin, guy.origin) < dist)
		wait .1;
	
	guy pushplayer(true);
}
basement_blocker_delete()
{
	level waittill("delete_basement");
	self delete();	
}

weapon_switch_training()
{
	level.bsmtweaps = [];
	level.bsmtweaps["smg"] = false;
	level.bsmtweaps["smoke"] = false;
	level.bsmtweaps["frag"] = false;
	level.bsmtweaps["num"] = 3;
	level.flag["grabbed_all_basement_goods"] = false;
	
	thread basement_blocker();
	
	spwn = getentarray("basementliver", "targetname");
	array_thread(spwn,::basementliver);
	
	spawners = getent("basement_leader", "script_noteworthy");
	spawners thread weapon_switch_think();
	
	weapon_switch_ladder("fall");
//	trig = getent("inbasement","targetname");
//	trig waittill("trigger");
	
	level waittill("player_in_basement");	
	
	animNode = getnode ("ladder_node_guy2","targetname");
	ai = getaiarray("allies");
	if(isdefined(level.smoke_guy))
		guy = level.smoke_guy;
	else
	{
		guy = getClosestEnt(animNode.origin, ai);
		guy thread hacked_FFpunish("smoke_obj_done");
	}
	
	guy.ignoreme = true;
	
	smgtrg = getent("near_smg", "targetname");
	smgtrg thread weapon_switch_hint();
	
	trigger = getent("drone_allies_alive","script_noteworthy");
	trigger notify("stop_drone_loop");
	level notify("in_basement");
	
	thread waitforgrabwaepon("ppsh", "smg");
	thread waitforgrabwaepon("smoke_grenade_american", "smoke");
	thread waitforgrabwaepon("Stielhandgranate", "frag");
	thread weapon_switch_reloadhint();
		
	level waittill("grabbed_all_basement_goods");
 	level.inventory_tnthud = maps\_inventory::inventory_create( "inventory_tnt_large", true );
 	level.player switchToOffhand("Stielhandgranate");
	
	level notify("got_ppsh");
	
	if(isdefined(guy.busy) && guy.busy == true)
		guy waittill("not_busy");
		
	guy.animname = "generic";
	maps\_anim::anim_reach_solo (guy, "setupladder", undefined, animNode);
	guy thread weapon_switch_notetracks();
	maps\_anim::anim_single_solo (guy, "setupladder", undefined, animNode);
	
	level.smoke_guy.grenadeAmmo = 0;
	level.smoke_guy thread smokeguy_idlenode();
	level notify("defined_level_smoke_guy");
	
	thread ladder_hint();
	
	if(!level.flag["smoke_obj_done"])
	{
		trig = getent("fc0","target");
		trig notify("trigger");
	}

	if(!level.jumpto_basement)
	{
		ai = getai("intro_shooters", "script_noteworthy", "allies");
		guy = getClosestEnt(animNode.origin, ai);
		guy.trench_run = false;
		guy pushplayer(false);
		guy notify("trench_run_basement_count");
		guy notify("forget_basement");
		
		level.trench_run_basement_count--;
		if(!level.trench_run_basement_count)
			level notify("last_guy_is_in_basement");
		guy unset_forcegoal();
		guy setgoalentity(level.player);
		guy thread friendly_reinforcements_think1();
	}
}

smokeguy_idlenode()
{
	self.animname = "rs4";
	self pushplayer(true);
	self thread dialogue("moscow_rs4_upladder");//moscow_rs4_upladder
	self thread friendly_reinforcements_think1();
	node = getnode("smoke_halftrack","targetname");
	ent = spawn("script_origin", node.origin);
	ent.angles = node.angles + (0,-90,0);
	ent anim_reach_solo(self, "corner_right");	
	
	self.smoke_node = ent;
	self notify("smoke_node");
	
	while(!level.flag["smoke_obj_done"])
	{
		if(isdefined(self.myisspeaking) && self.myisspeaking == true )
			self waittill("myisspeaking");
		ent thread anim_loop_solo(self, "corner_right_idle", undefined, "stop_idle");		
		self waittill("stop_my_idle");
		ent notify("stop_idle");
	}
	self stopanimscripted();
	self pushplayer(false);
	wait 3;
	thread battleChatterOn( "allies" );
}

hacked_FFpunish(msg)
{
	self thread magic_bullet_shield();	
	self thread hacked_FFpunish2(msg);
	level endon(msg);
	
	while(1)
	{
		self waittill("damage", amount, other, direction_vec, point, type);
		if(type == "MOD_GRENADE_SPLASH")
		{
			if(other == level.player && self.health < 1)
				self.health = 1;
			continue;
		}
		if(other == level.player)
		{
			level notify("hud_elem_going_up");
			setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN");
			maps\_utility::missionFailedWrapper();
		}	
	}
}

hacked_FFpunish2(msg)
{
	level waittill(msg);
	self notify ("stop magic bullet shield");
}
ladder_hint()
{
	level endon("smoke_nade_obj");
	if(!level.flag["next_hud_elm"])
		level waittill("next_hud_elm");
	thread add_hudelm_hint(level.strings["ladder"], "smoke_nade_obj");
}

weapon_switch_think()
{
	self waittill("spawned", guy);
	if(spawn_failed(guy))
		return;

	level.smoke_guy = guy;
	guy thread friendly_reinforcements_think1();
	guy thread hacked_FFpunish("smoke_obj_done");
	guy.animname = "rs4";
	level waittill("in_basement");
	guy.busy = true;
	guy dialogue("moscow_rs4_grabsmg");//moscow_rs4_grabsmg
	guy.busy = false;
	guy notify("not_busy");
	
	if(!level.flag["grabbed_all_basement_goods"])
		guy thread basement_dialogue_repeat();
}

basement_dialogue_repeat()
{
	level endon("grabbed_all_basement_goods");
	while(1)
	{
		wait 5;
	
		array = [];
	 	if(!level.bsmtweaps["smg"])
	 		array[array.size] = "smg";
	 	if(!level.bsmtweaps["smoke"])
	 		array[array.size] = "smoke";
	 	if(!level.bsmtweaps["frag"])
	 		array[array.size] = "frag";

	 	pos = random(array);
	 	
	 	switch(pos)
	 	{
	 		case "smg":
	 			self dialogue("moscow_rs3_pickupsubgun");
	 			break;
	 		case "smoke":
	 			self dialogue("moscow_rs3_pickupsmoke");
	 			break;
	 		case "frag":
	 			self dialogue("moscow_rs3_pickuphand");
	 			break;
		}
		
		wait 6;
	}	
}

weapon_switch_notetracks()
{
	while(1)
	{	
		self waittill ("single anim", notetrack);
		if (notetrack == "lift")
			level thread weapon_switch_ladder("setup");
	}
}

#using_animtree("toujane_ladder");
weapon_switch_ladder(animName)
{
	ladder_clip = getent ("regroup_ladder_clip","targetname");
	ladder_clip notsolid();
	climb = getent("regroup_ladder","targetname");
	climb triggerOff();
	ladder = getent("ladder_model","targetname");
	ladder UseAnimTree(#animtree);
	
	if (animName == "fall")
		ladder setflaggedanim ("ladder", %toujane_ladder_fall);
	else if (animName == "setup")
	{
		ladder setflaggedanimknob ("ladder", %toujane_ladder_setup);
		ladder playsound("moscow_raiseladder");
		ladder waittillmatch ("ladder", "end");
	
		ladder_clip connectpaths();
		area = getent ("ladder_proximity2","targetname");
		while(level.player istouching (area))
			wait .1;
		
		ladder_clip solid();
		
		climb triggerOn();
		level notify("ladder_is_up");		
	}
}

potato_talker_shutdown()
{
	level waittill("grenade_training_done");
	self notify("stop_idle");
}

potato_crate_hint()
{
	level.flag["kill_grab_potato_hint"] = false;
	wait 1;
	thread potato_crate_hintb();
	if( (level.player getfractionmaxammo("potato")) )
	{
		level.flag["kill_grab_potato_hint"] = true;
		level notify("kill_grab_potato_hint");
 		return;
 	}
	add_hudelm_hint(level.strings["grab_potato"], "kill_grab_potato_hint");	
	while( !(level.player getfractionmaxammo("potato")) )
		wait .05;
	level.flag["kill_grab_potato_hint"] = true;
	level notify("kill_grab_potato_hint");
}

potato_crate_hinta()
{
	level endon("grenade_training_done");
	while( !(level.player getfractionmaxammo("potato")) ) //while they dont have potatoes, wait
		wait .05;
	if(level.flag["print_nade_throw_hint"])
		add_hudelm_hint(level.strings["potato_throw"], "grenade_training_done");
	
	level notify("kill_grab_potato_hint");
	thread potato_crate_hintb();
}

potato_crate_hintb()
{
	level endon("grenade_training_done");
	while( (level.player getfractionmaxammo("potato")) ) // while they have potatoes, wait
		wait .05;
	
	wait 1;
	if( (level.player getfractionmaxammo("potato")) )
		thread potato_crate_hintb();
	else
	{
		add_hudelm_hint(level.strings["grab_potato"], "kill_grab_potato_hint");	
		thread potato_crate_hinta();
	}
}

grenade_training()
{
	level.flag["print_nade_throw_hint"] = false;
	level endon("grenade_training_done");
	level waittill("pickup_nade_dialogue_done");
	
	thread potato_crate_hint();
	
	trig = getent("grenade_training", "targetname");
	
	thread potato_hint_repeat("grenade_training_done");
	
	ai = getai("me_talk_grenade", "targetname", "allies");
	guy = ai[0];
 	guy.animname = "rs3";
 	if(guy.running)
 		guy waittill("running");
 	wait .1;
 	guy.running = true;
 	
 	if(isdefined(guy.myisspeaking) && guy.myisspeaking == true)
 		guy waittill("myisspeaking");
 	guy thread dialogue("moscow_rs3_potatoes", guy.moscow_potato_throw);//moscow_rs3_potatoes
 	guy waittill("myisspeaking");
 	guy thread potato_talker_shutdown();
 	guy.moscow_potato_throw thread anim_loop_solo(guy, "potato_idle", undefined, "stop_idle");
 	if(level.letlev.walking)
		level.letlev waittill("walking");
 	if(level.letlev.myisspeaking)
		level.letlev waittill("myisspeaking");
 	level.letlev thread dialogue("moscow_rs1_valuable");//moscow_rs1_valuable
 	level.letlev waittill("myisspeaking");
 	if(guy.myisspeaking)
 		guy waittill("myisspeaking");
 	guy.moscow_potato_throw notify("stop_idle");
 	guy thread dialogue("moscow_rs3_ofcourse", guy.moscow_potato_throw);//moscow_rs3_ofcourse
 	guy waittill("myisspeaking");
 	
 	guy.running = false;
 	guy notify("running");
 	
 	if(!level.flag["one_nade_down"])
 	{
 		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
 		level.letlev thread dialogue("moscow_rs1_throwpotato");	//moscow_rs1_throwpotato
 		level.letlev waittill("myisspeaking");
 	}
 	
 	if(!level.flag["kill_grab_potato_hint"])
 		level waittill("kill_grab_potato_hint");
 	
 	level.flag["print_nade_throw_hint"] = true;
 	level notify("print_nade_throw_hint");
}

potato_hint_repeat(msg)
{
	text = "grenade_throw";
	if((msg == "grenade_training_done"))
	{
		level endon("grenade_training_done");
		text = "potato_throw";
	}
	else
		level endon("player_threw_nade");
	level endon("smoke_grenade_in_right_place");
	level waittill("print_nade_throw_hint");
	add_hudelm_hint(level.strings[text], msg);	
}

maintain_ammo()//guns only
{
	level endon("grenade_training_done");
	while (1)
	{
		currentweapon = level.player getCurrentWeapon();
		currentammo = level.player getFractionMaxAmmo(currentweapon);

		if (currentammo < .2)
			level.player giveMaxAmmo(currentweapon);
		wait 1;
	}
}

infinite_grenade()
{
	wait .5;
	
	weapons = getentarray ("infinite_grenade", "targetname");
	if (weapons.size < 1)
	{
		println("no infinite grenades found");
		return;
	}

	locations = [];
	for (i=0; i<weapons.size; i++)
	{
		println("an infinite grenade found");
		
		locations[i] =  spawn ("script_origin", weapons[i].origin);
		locations[i].angles = weapons[i].angles;
		locations[i].type = weapons[i].classname;
		if(isdefined(weapons[i].bag))
			locations[i].bag = true;
		else
			locations[i].bag = false;
		locations[i].clone = weapons[i];
	}
	while (1)
	{
		wait 8;
		weapons = getentarray ("infinite_grenade", "targetname");
		if (weapons.size == locations.size)
			continue;
		level notify ("picked up infinite grenade");
		for (i=0; i<locations.size; i++)
		{
			if(isdefined(locations[i].clone))
				continue;
			
			new_weapon = undefined;
			
			if(locations[i].bag)
				new_weapon = locations[i] grenade_bags();
			else
			{
				new_weapon = spawn (locations[i].type, locations[i].origin);
				new_weapon.alreadythere = true;
				new_weapon.angles = locations[i].angles;
				new_weapon.targetname = "infinite_grenade";
			}
			
			locations[i].clone = new_weapon;
			
		}
	}
}

objective_breaks(type)
{
	level endon("stop_obj_breaks_function");
	while(1)
	{
		self waittill("damage", amount, ent);
	
		if(ent != level.player)
			return;
		
		switch(type)
		{
			case "bottle":
			{
				level.broken_bottles++;
				if(level.broken_bottles >= level.broken_bottles_max)
					level.flag["broken_bottles"] = true;
			}break;
			case "bottle2":
			{
				if(level.flag["ADS_BUTTON"])
				{
					level notify("stopADShint");
					level.broken_bottles2++;
					if(!level.letlev.myisspeaking)
						level.letlev thread dialogue("moscow_rs1_goodshot", undefined, undefined, true); 
				}
				if(level.broken_bottles2 >= level.broken_bottles2_max)
					level.flag["broken_bottles2"] = true;
			}break;
			case "helmet":
			{
				level.broken_helmets++;
				if(level.broken_helmets >= level.broken_helmets_max)
					level.flag["broken_helmets"] = true;
			}break;	
		}
		
		level notify("another_object_broken");
		level notify("another_object_broken" + type);
	}
}

saveguns()
{
	wait .1;
	thread autoSaveByName("got guns");
}

objective_special_hint()
{
	level endon("got_rifle_hint");
	level waittill("player_told_to_go");
	level.letlev waittill("myisspeaking");
	
	if(level.xenon)
		special_hint("objective", "objective_hint", 20, 0, 10, 70, 137);
	else
		special_hint("objective", "objective_hint", 20, 0, 10, 60, 180);

	wait 1;
	
	add_hudelm_hint(level.strings["objectives"], undefined, level.hud_repeat_rate);
}
objectives()
{
	level.nade_obj_shader = [];
	level.nade_obj_shader["tub"] = getentarray("obj_glow_brush_tub","targetname");
	for(i=0;i<level.nade_obj_shader["tub"].size; i++)
		level.nade_obj_shader["tub"][i] hide();
	level.nade_obj_shader["win"] = getentarray("obj_glow_brush_win","targetname");
	for(i=0;i<level.nade_obj_shader["win"].size; i++)
		level.nade_obj_shader["win"][i] hide();
	level.nade_obj_shader["door"] = getentarray("obj_glow_brush_door","targetname");
	for(i=0;i<level.nade_obj_shader["door"].size; i++)
		level.nade_obj_shader["door"][i] hide();
	
	level.broken_bottles = 0;
	level.broken_bottles2 = 0;
	level.broken_helmets = 0;
	
	level.broken_bottles_max = 8;
	level.broken_bottles2_max = 5;
	level.broken_helmets_max = 5;
	
	level.objnum = 1;
	delobj = 1;
	if(!level.jumpto_shoot)
	{
		wait 4;//wait for intro screen
		objective_add(level.objnum, "active", level.obj_string["walktable"], (-1961, -982, 82));
		objective_current(level.objnum);
		
		level waittill("player_given_grab_gun_obj");
		objective_state(level.objnum,  "done");
		thread autoSaveByName("grab a gun");
		level.objnum++;
		
		objective_add(level.objnum, "active", level.obj_string["grabgun"], (-1573, -134, 100));
		objective_current(level.objnum);
		
		thread objective_special_hint();
		
		level waittill("player_grabbed_rifle");
		objective_state(level.objnum,  "done");
		thread autoSaveByName("got a gun");
		level.objnum++;
		
		objective_add(level.objnum, "active", level.obj_string["goback"], (-1961, -982, 82));
		objective_current(level.objnum);
		
		//aiming training
		level waittill("player_given_aim_obj");
		objective_state(level.objnum,  "done");
		thread saveguns();
		level.objnum++;
		
		objective_add(level.objnum, "active", level.obj_string["bears"], (-2279, -992, 101));
		objective_current(level.objnum);
		
		breaks = getentarray("wine_bottle","script_noteworthy");
		array_thread(breaks, ::objective_breaks, "bottle");
		
		//firing yard
		level waittill("now_do_shoot_training");
		objective_state(level.objnum,  "done");
		thread autoSaveByName("set controls");
		level.objnum++;
	}
	else
		wait .5;
	if(!level.jumpto_potato)
	{		
		objective_add(level.objnum, "active", level.obj_string["shoot"],(-2166, -1030, 82));
		objective_current(level.objnum);
		level waittill("done_shooting_first_bottles");
		objective_state(level.objnum,  "done");
		thread autoSaveByName("shooting training");
		level.objnum++;
		objective_add(level.objnum, "active", level.obj_string["shootb"],(-2166, -1030, 82));
		objective_current(level.objnum);
		
		level notify("stop_obj_breaks_function");
		breaks = getentarray("wine_bottle","script_noteworthy");
		array_thread(breaks, ::objective_breaks, "bottle2");
		
		level waittill("given_difficulty_test");
		objective_state(level.objnum,  "done");
		thread autoSaveByName("shooting training");
		level.objnum++;
		
		level notify("stop_obj_breaks_function");
		breaks = getentarray("helmet_pop","targetname");
		array_thread(breaks, ::objective_breaks, "helmet");
		
		objective_add(level.objnum, "active", level.obj_string["test"],(-2166, -1030, 82));
		objective_current(level.objnum);
		level waittill("now_do_potato_training");			
		objective_state(level.objnum,  "done");
		thread autoSaveByName("difficulty test");
		level.objnum++;
		
		level notify("stop_obj_breaks_function");			
		level notify("give_mannequin_obj");
		objective_add(level.objnum, "active", level.obj_string["melee"], (-2095, -1302, 80) );
		objective_current(level.objnum);
		level waittill("mannequin_done");
		objective_state(level.objnum,  "done");
		thread autoSaveByName("melee done");
		level.objnum++;
	}
	if(!level.jumpto_melee)
	{		
		level notify("all_shooting_objectives_done");
		trigs = getentarray("nade_train_trig", "targetname");
		num = trigs.size;

		objective_add( level.objnum, "active", level.obj_string["potato2"], (-1919, -1561, 80) );
		objective_current(level.objnum);

		level.flag["one_nade_down"] = false;
		array_thread(trigs, ::objective_nades);
		while(num)
		{
			thread nade_help_dialogue();
			objective_string(level.objnum, level.obj_string["potato1"], num);
			level waittill("one_nade_down");
			level.flag["one_nade_down"] = true;
			if(level.flag["print_nade_throw_hint"])
			{
				if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
				level.letlev thread dialogue("moscow_rs1_throwcomp", undefined, undefined, true); 
			}
			num--;
		}
		level.flag["grenade_training_done"] = true;
		level notify("grenade_training_done");
		level notify("kill_grab_potato_hint");
		thread autoSaveByName("potato throw");
		objective_state(level.objnum,  "done");
		objective_string(level.objnum, level.obj_string["potato2"]);
		level.objnum++;
		objective_delete(delobj);
		delobj++;
	}
	else
		wait 1;
	if(!level.jumpto_trench)
	{
		objective_add(level.objnum, "active", level.obj_string["follow"]);
		objective_current(level.objnum);
		thread comewithsafety();
		level waittill("comewithme");
		
		objective_add(level.objnum, "active", level.obj_string["follow"], (-1494, -315, 76));
		objective_current(level.objnum);
		//level notify("star_hint_done");
		level waittill("trench_run");

		objective_state(level.objnum,  "done");
		level.objnum++;
		objective_delete(delobj);
		delobj++;
	}
	if(!level.jumpto_basement)
	{
		objective_add(level.objnum, "active", level.obj_string["armory"], (405, 895, -183) );
		objective_current(level.objnum);
	}
		
	level waittill("in_basement");
	objective_state(level.objnum,  "done");
	thread autoSaveByName("lock and load");
	level.objnum++;
	objective_delete(delobj);
	delobj++;
	objective_add(level.objnum, "active", level.obj_string["smg"], (405, 895, -183) );
	objective_current(level.objnum);
	level waittill("got_ppsh");
	objective_state(level.objnum,  "done");
	thread autoSaveByName("armory");
	level.objnum++;
	objective_delete(delobj);
	delobj++;
	objective_add(level.objnum, "active", level.obj_string["ladder"], (639, 726, -230) );
	objective_current(level.objnum);
	level waittill("smoke_nade_obj");
	objective_state(level.objnum,  "done");
	thread autoSaveByName("ladder climb");
	level.objnum++;
	
	if(!level.flag["smoke_obj_done"])
	{
		if(!level.flag["smoke_grenade_in_right_place"])
		{
			objective_delete(delobj);
			delobj++;
			objective_add(level.objnum, "active", level.obj_string["smoke1"], (405, 895, -183) );
			objective_current(level.objnum);
			level waittill("smoke_grenade_in_right_place");
			objective_string(level.objnum, level.obj_string["smoke2"]);
			level.flag["waiting_for_smoke_to_fill"] = true;
			level notify("waiting_for_smoke_to_fill");
			
			level waittill("smoke_obj_done");
			objective_state(level.objnum,  "done");	
			level.objnum++;
		}
		else
		{
			objective_delete(delobj);
			delobj++;
			objective_add(level.objnum, "active", level.obj_string["smoke2"], (405, 895, -183) );
			objective_current(level.objnum);
			level waittill("smoke_obj_done");
			objective_state(level.objnum,  "done");	
			level.objnum++;
		}
	}
	//NEBELWERFERS		
	trig = getent("nebel_objective", "targetname");
	objective_delete(delobj);
	delobj++;
	objective_add(level.objnum, "active", level.obj_string["panzer"], trig getOrigin());
	objective_current(level.objnum);

	trig thread objective_nebelwerfer(level.objnum);
	
	level waittill("newbel_obj_done");
	objective_state(level.objnum,  "done");
	thread autoSaveByName("the_end");
	level notify("all_objectives_done");
}
//hack to magically make sure we dont miss this notify
comewithsafety()
{
	level endon("comewithme");
	level waittill("in_interogation");
	level notify("comewithme");
}
remove_specialhint(ender)
{
	level waittill(ender);
	if(!isdefined(self))
		return;
	self notify("destroying");
	self notify("destroyed");
	self destroy();
}

special_hint_background(shader, yoffset)
{
	if(!isdefined(self.background))
		return;
	self.background.x = 320;
	
	if(shader == "stance_crouch")
		self.background.y = 206 + yoffset;
	else
		self.background.y = 206;
	
	self.background.alignX = "center";
	self.background.alignY = "middle";
	if(level.xenon)
		self.background setshader("popmenu_bg", 650, 60);
	else
		self.background setshader("popmenu_bg", 650, 50);
	self.background.alpha = .5;
}

special_hint(shader, hint, scale, xoffset, yoffset, xnum, ynum, horzAlign)
{
	if (flag("player_has_red_flashing_overlay"))
		return undefined;
	level notify("hud_elem_going_up");
	level endon("hud_elem_going_up");
	level endon("hud_elem_interupt");
	
	background = undefined;
	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		background = newHudElem();
		
	stancehint = newHudElem();
	stancehint.label = (level.strings[hint].text);
	if(isdefined(level.strings[hint].bind))
		stancehint setText(level.strings[hint].bind);
	
	stancehint.background = background;
	stancehint special_hint_background(shader, yoffset);
	
	stancehint add_hudelm_position();

	stanceicon = newHudElem();
	stanceicon add_hudelm_position(true, (xoffset - 15), (xoffset - 10), yoffset);

	if(level.xenon)
		stanceicon setShader(shader, (scale + 5), (scale + 5));
	else
		stanceicon setShader(shader, scale,  scale);
	
	stanceicon thread add_hudelem_pulse(1, true);
	stancehint thread add_hudelem_pulse(1, true);
	
	stanceicon thread remove_specialhint("hud_elem_going_up");
	stanceicon thread remove_specialhint("hud_elem_interupt");
	stancehint thread remove_hudelm_hint("hud_elem_going_up");
	stancehint thread remove_hudelm_hint("hud_elem_interupt");
	
	wait 5;
	
	stanceicon destroy();
	stanceicon = newHudElem();
	if(level.xenon)
		stanceicon setShader(shader, (scale + 5), (scale + 5));
	else
		stanceicon setShader(shader, scale, scale);
	
	stanceicon add_hudelm_position(true, (xoffset - 15), (xoffset - 10), yoffset);
	stanceicon thread remove_specialhint("hud_elem_going_up");
	stanceicon thread remove_specialhint("hud_elem_interupt");
	stanceicon.alpha = 1;
	
	stanceicon moveovertime(1);
	stanceicon.x = xnum; 
	stanceicon.y = ynum;
	if(isdefined(horzAlign))
		stanceicon.horzAlign = horzAlign;
	else
		stanceicon.horzAlign = "left";
	stanceicon.vertAlign = "middle";
	
	if(level.xenon)
		stanceicon scaleovertime(1, scale, scale);
	else
		stanceicon scaleovertime(1, (scale-5), scale-5);
	wait .85;
	stanceicon fadeovertime(.15);
	stanceicon.alpha = 0;

	wait .5;
	
	stancehint fadeovertime(.5);
	stancehint.alpha = 0;
	if(isdefined(stancehint.background))
	{
		stancehint.background fadeovertime(.5);
		stancehint.background.alpha = 0;
		stancehint.background destroy();
	}
	stancehint destroy();
	stanceicon destroy();
}

objective_nades_glow()
{
	if(!level.flag["print_nade_throw_hint"])
		level waittill("print_nade_throw_hint");
	
	if(!level.potatotargets[self.script_noteworthy])
		return;
	
	for(i=0;i<level.nade_obj_shader[self.script_noteworthy].size; i++)
		level.nade_obj_shader[self.script_noteworthy][i] show();
}

objective_nades()
{
	self endon("give_up_nade");
	level.potatotargets[self.script_noteworthy] = true;
	self thread objective_nades_glow();
	wait .5;
	while(1)
	{
		grenades = getentarray ("grenade", "classname");
		if(grenades.size > 0)
		{
			for (i = 0; i < grenades.size; i++)
			{
				if(!(grenades[i].model == "xmodel/weapon_potato"))
					continue;
				if(isdefined(grenades[i].alreadythere))
					continue;
				if(isdefined(grenades[i].user) && grenades[i].user == "ai_user")
					continue;
				else
					level notify("player_threw_nade");
				if (grenades[i] istouching(self))
				{
					level notify("one_nade_down");	
					level.potatotargets[self.script_noteworthy] = false;
					for(i=0;i<level.nade_obj_shader[self.script_noteworthy].size; i++)
						level.nade_obj_shader[self.script_noteworthy][i] delete();
					self notify("give_up_nade");
						break;
				}
			}
		}
		wait .05;
	}
}

nade_help_dialogue()
{
	level endon("one_nade_down");
	if(!level.flag["print_nade_throw_hint"])
		level waittill("print_nade_throw_hint");
	while(1)
	{
	 	wait 14;
	 	
	 	array = [];
	 	if(level.potatotargets["tub"])
	 		array[array.size] = "tub";
	 	if(level.potatotargets["door"])
	 		array[array.size] = "door";
	 	if(level.potatotargets["win"])
	 		array[array.size] = "win";
	 	
	 	pos = random(array);
	 	
	 	switch(pos)
	 	{
	 		case "tub":{
	 			if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
	 			level.letlev thread dialogue("moscow_rs1_throwtub", undefined, undefined, true);
	 			level.letlev waittill("myisspeaking");	
	 			}break;
	 		case "door":{
	 			if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
	 			level.letlev thread dialogue("moscow_rs1_throwdoor", undefined, undefined, true);
	 			level.letlev waittill("myisspeaking");	
	 			}break;
	 		case "win":{
	 			if(level.letlev.myisspeaking)
					level.letlev waittill("myisspeaking");
	 			level.letlev thread dialogue("moscow_rs1_throwwindow", undefined, undefined, true);
	 			level.letlev waittill("myisspeaking");	
	 			}break;
		}
 	}	
}

objective_nebelwerfer(objnum)
{
	glow = getentarray(self.target, "targetname");
	for(i=0;i<glow.size;i++)
	{
		glow[i].tnt = getent(glow[i].target, "targetname");
		glow[i].tnt hide();
	}
	name = self.script_noteworthy;
	car = getent(name, "targetname");
	
	self setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );
	
	self waittill("trigger");
	level notify("bomb_planted");
	level.inventory_tnthud thread maps\_inventory::inventory_hide();
	spwn = getspawnerteamarray("axis");
	for(i=0;i<spwn.size;i++)
		spwn[i] delete();
	
	//iprintlnbold (&"MOSCOW_EXPLOSIVES_WARN");
	thread add_hudelm_hint(level.strings["explosives_warn"], undefined, level.hud_repeat_rate);
	self delete();
	for(i=0;i<glow.size;i++)
	{
		glow[i] hide();
		glow[i].tnt show();
	}
	
	//badplace_cylinder(name, 12, car.origin, 512, 128, "axis","allies","neutral");
	
	glow[0] playSound( "explo_plant_no_tick" );
	glow[0] playLoopSound( "bomb_tick" );
	
	level.bombstopwatch = maps\_utility::getstopwatch(60);//setClock( level.explosiveplanttime, 60, "hudStopwatch", 64, 64 ); // count down for 10 of 60 seconds, size is 64x64

	wait ( level.explosiveplanttime );
	glow[0] stopLoopSound( "bomb_tick" );
	
	for(i=0;i<glow.size;i++)
	{
		glow[i] hide();
		glow[i].tnt delete();
	}	
	level.bombstopwatch destroy();
	
	radiusdamage(car.origin, 216, 350, 50);
	earthquake( 0.25, 1, car.origin, 1000 );
	
	
	car notify("death");
	level notify("newbel_obj_done");
}

hint_WeaponSwitch()
{
	keybind = spawnstruct();
	keybind.bind = undefined;
	
	binding1 = getKeyBinding("weapnext");
	binding2 = getKeyBinding("weapprev");
	
	if(binding1["count"])
	{
		keybind.bind = "weapnext";
		if(binding2["count"])
			keybind.bind2 = "weapprev";
	}
	else if(binding2["count"])
		keybind.bind = "weapprev";
	else
	{
		keybind.bind = "weaponslot primary";
		keybind.bind2 = "weaponslot primaryb";
	}
	
	return keybind;
}

dialogue(msg, node, nostop, nobody, waittilldonespeaking, nowaitspeak, fake)
{
	if(!isdefined(self))
		return;
	if( isdefined(fake))
	{
		self thread dialogue_internal(msg);
		return;
	}
	else
	{
	//	if(!  (isdefined(nostop) || isdefined(nobody))  )
	//		self stopanimscripted();
		return2block = false;
		if(!isdefined(self.myisspeaking))
			self.myisspeaking = false;
		if(self.myisspeaking && isdefined(waittilldonespeaking))
			self waittill("myisspeaking");
		if(self == level.letlev && (level.letlev.blockanim || level.letlev.myisspeaking) && (!isdefined(nobody)))
		{
			level.letlev notify("pause_idle");
			return2block = true;
		}	
		self endon("death");
		
		facial = undefined;		
		if(!isdefined(nowaitspeak))
			self.myisspeaking = true;
		self notify("started speakin again");	
		self endon("started speakin again");
		
		if(!isdefined(node))
			self anim_single_solo(self, msg);
		else
			self anim_single_solo(self, msg, undefined, node);
			
		self.myisspeaking = false;
		self notify("myisspeaking");
		if(return2block)
			level.letlev notify("resume_idle");
	}
}
dialogue_internal(msg)
{
	self endon("death");
	//iprintln(msg);
	num = 0.0;
	if(!isdefined(self.num3dtext))
	{
		self.text3dcolor = (.5 + randomfloat(.5), .5 + randomfloat(.5),.5 + randomfloat(.5));
		self.num3dtext = 1;
	}
	else
		self.num3dtext++;
	height = self.num3dtext;
	for(;;)
	{
		if(num > 6.0)
			break;
		
		vec = vectornormalize(self.origin - level.player.origin);
		vec2 = vectorscale(vec, 120);
		ang = vectortoangles(vec);
		vec3 = anglestoright(ang);
		vec3 = vectorscale(vec3, -150);
		
		pos = self.origin + vec2 + vec3;
		pos = pos + ( 0,0, 70 + ( height * 16 ) );
		
		print3d( pos , msg, self.text3dcolor, 1, .75);
		
		wait .05;
		num += .05;
	}
	self.num3dtext--;
}

friendly_main()
{
	level.flag["no_reinforcements"] = false;
	thread friendly_ChainMain();
	thread friendly_reinforcements();
	thread friendly_letlev();
	
	if(!level.jumpto_melee)
	{
		spawners = getentarray("intro_shooters","script_noteworthy");
		array_thread(spawners, ::friendly_intro_think);
		spawners = getentarray("intro_potato_guys","script_noteworthy");
		array_thread(spawners, ::friendly_intro_think);
	}
}
#using_animtree("generic_human");
friendly_letlev()
{
	level.letlev.oldwalkdist = level.letlev.walkdist;
	level.letlev.walking = true;
	
	level.letlev.walk_combatanim2 		= %unarmed_walk_russian;
	level.letlev.walk_combatanim 		= %unarmed_walk_russian;
	level.letlev.walk_noncombatanim2 	= %unarmed_walk_russian;
	level.letlev.walk_noncombatanim 	= %unarmed_walk_russian;
	level.letlev.run_combatanim			= %unarmed_run_russian;
	level.letlev.anim_combatrunanim		= %unarmed_run_russian;
	level.letlev.run_noncombatanim		= %unarmed_run_russian;
	level.letlev.oldstandanim			= level.letlev.standanim;
	level.letlev.standanim				= %downtown_sniper_blocking_door_idle;
	
	node = getent("letlev_node", "script_noteworthy");
	if(!level.jumpto_potato)
	{
		thread friendly_letlev_block(node);
		if(!level.jumpto_shoot)
			level waittill("go grab a gun");
		level.letlev notify("stop_idle");
		level.letlev notify("stop_block_anim");
		node = getnode(node.target, "targetname");
		level.letlev set_forcegoal();
		level.letlev.goalradius = 4;
		level.letlev setgoalnode(node);
		level.letlev waittill("goal");
		while(level.letlev.angles != node.angles)
			wait .1;
		level.letlev.walking = false;
		level.letlev notify("walking");
		level.letlev.walkdist = 5000000;
		
		thread friendly_letlev_block(node);
		level waittill("shoot_bottles");
		level.letlev notify("stop_idle");
		level.letlev notify("stop_block_anim");
		
		node = getnode(node.target, "targetname");
		level.letlev setgoalnode(node);
		level.letlev.walking = true;
		level.letlev waittill("goal");
		wait 1.25;
		level.letlev.walking = false;
		level.letlev notify("walking");
		
		thread friendly_letlev_block(node);
		level waittill("all_shooting_objectives_done");
		wait .6;
		level.letlev notify("stop_idle");
		level.letlev notify("stop_block_anim");
	}
	else 
		node = getnode(node.target, "targetname");
	
	level endon("grenade_training_done");
	
	if(!level.jumpto_melee)
	{
		if(level.letlev.myisspeaking)
			level.letlev waittill("myisspeaking");
		level.letlev thread dialogue("moscow_rs1_pickupgrenade");
		level.letlev waittill("myisspeaking");
	}
	level notify("pickup_nade_dialogue_done");
	level.flag["pickup_nade_dialogue_done"] = true;
	node = getnode(node.target, "targetname");
	level.letlev.goalradius = 4;
	level.letlev setgoalnode(node);
	level.letlev.walking = true;
	if(!level.jumpto_melee)
	{
		level.letlev waittill("goal");
		while(level.letlev.angles != node.angles)
			wait .1;
		level.letlev.walking = false;
		level.letlev notify("walking");
		thread friendly_letlev_block(node);
	}
}

friendly_letlev_block(node)
{
	level.letlev endon("stop_block_anim");
	level.letlev.blockanim = true;

	level.letlev thread maps\_anim::anim_loop_solo(level.letlev, "block_idle", undefined, "stop_idle", node);
	level.letlev thread friendly_letlev_block_internal();
	
	level.letlev waittill("pause_idle");
	level.letlev notify("stop_idle");
	level.letlev waittill("resume_idle");
	thread friendly_letlev_block(node);
}

friendly_letlev_block_internal()
{
	self waittill("stop_idle");
	level.letlev.blockanim = false;
}

friendly_intro_think1(guy)
{
	level endon("now_do_potato_training");
	if(!level.jumpto_shoot)
		level waittill("shooting_range");
	if(!level.jumpto_potato)
	{
		if(!isdefined(guy.gungrab))
			guy waittill("gungrab");
		guy setgoalnode(getnode(guy.runningnode.target, "targetname"));
		guy.anim_forced_cover = "show";
		
		if(!level.flag["skip_to_shoot_training_part2"])
			level waittill("shoot_bottles");
		guy thread friendly_intro_shoot("bottle", "shoot_helmets", 1, 1, "now_do_potato_training");
		
		level waittill("shoot_helmets");
		wait .5;
		guy thread friendly_intro_shoot("helmet", "now_do_potato_training", 2, 2);
	}
}

friendly_intro_potatoblock()
{
	self endon("goal");
	trig = getent("grenade_training", "targetname");
	spots = getentarray("potato_spot_trig","targetname");
	spot = getClosestEnt(self.moscow_potato_node.origin, spots);
	
	while(1)
	{
		trig waittill("trigger");
		if(level.player istouching(spot))
		{
			node = getnode("middle_potato_nodes","script_noteworthy");
			self setgoalnode(node);
			self.moscow_potato_throw = node;
		}	
		else
		{
			//node = getnode("middle_potato_nodes","script_noteworthy");
			
			self setgoalnode(self.moscow_potato_node);
			self.moscow_potato_throw = self.moscow_potato_node;
		}
		wait 1;
	}
}

friendly_intro_think2(guy)
{
	node = getnode(self.target, "script_noteworthy");
	guy.oldradius = guy.goalradius;
	guy.goalradius = 16;
	guy.moscow_potato_node = node;
	guy.moscow_potato_throw = node;
	guy thread friendly_intro_potatoblock();
	guy setgoalnode(node);
	guy.running = true;
	guy waittill("goal");
	guy.running = false;
	guy notify("running");
	
	if(!level.flag["pickup_nade_dialogue_done"])
		level waittill("pickup_nade_dialogue_done");
	wait 1;
	
	if(guy.running)
		guy waittill("running");
	if(!level.flag["grenade_training_done"])
	{
		guy thread friendly_intro_potato_loop("stop_throw", guy.moscow_potato_throw, "potato_target", "targetname");
		level waittill("grenade_training_done");   
	}
	guy notify("stop_throw");
	node notify("stop_throw");
}
friendly_intro_think()
{
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;	
	
	guy endon("death");
	guy pushplayer(true);
	if(self.script_noteworthy == "intro_shooters")
		self thread friendly_intro_think1(guy);
	else
		return;
	level waittill("mannequin_done");
	
	if(!isdefined(level.potatothrowers))
	{
		level.potatothrowers = 1;
		self.target = "right_potato_nodes";
		guy.targetname = "me_notalk_grenade";
	}
	else if(level.potatothrowers >= 2)
		return;
	else
	{
		level.potatothrowers++;
		self.target = "left_potato_nodes";
		guy.targetname = "me_talk_grenade";
	}
	self thread friendly_intro_think2(guy);
//	else if(self.script_noteworthy == "intro_potato_guys")
//		self thread friendly_intro_think2(guy);
}

friendly_intro_potato_loop(ender, node, name, type)
{
	self endon(ender);
	self endon("death");
	self.animname = "generic";
	target = getentarray(name, type);
	
	while(1)
	{
		wait (randomfloat(4) + 3);
		node thread anim_single_solo ( self, "nade_throw");//, self.tag, undefined, vehicle);
		
		self waittillmatch ("single anim", "fire");
		nadeStart = self gettagorigin("TAG_WEAPON_RIGHT");
		
		nade = random(target);
		self.grenadeWeapon = "potato";
		self.grenadeAmmo++;
		self MagicGrenade (nadeStart, nade.origin, 20);
		wait .05;
	
		grenades = getentarray ("grenade", "classname");
		ent = getClosestEnt(self.origin, grenades);
		if(isdefined(ent))
			ent.user = "ai_user";
		
		self waittillmatch ("single anim", "end");
		
		x = randomint(100);
		
		if(x>50)
			node thread anim_single_solo ( self, "nade_reset1");
		else
			node thread anim_single_solo ( self, "nade_reset2");
	}
}

friendly_intro_shoot_stopanim(ender, animstop, ender2, guy)
{
	if(isdefined(ender2))
		level endon(ender2);
	level waittill(ender);
	self notify(animstop);	
	guy stopanimscripted();
}

friendly_intro_shoot(type, ender, misses, range, ender2)
{
	self endon("death");
	level endon(ender);
	node = getnode(self.runningnode.target, "targetname");
	if(isdefined(ender2))
	{
		level endon(ender2);
		node thread friendly_intro_shoot_stopanim(ender2, "stop_aim", undefined, self);	
	}
	node thread friendly_intro_shoot_stopanim(ender, "stop_aim", ender2, self);
	
	self.animname = "generic";
	//num = 0;//misses + randomint(range);
	ammo=0;
	node notify("stop_aim");
	self stopanimscripted();
	while(1)
	{
		node thread anim_loop_solo(self, "aim", undefined, "stop_aim");
		wait (randomfloat(2) + 3);
		node notify("stop_aim");
		ents = getentarray(node.targetname, "target");
		final = [];
		for(i=0;i<ents.size;i++)
		{
			switch(type)
			{
				case "bottle":
				{
					if(isdefined(ents[i].script_noteworthy) && ents[i].script_noteworthy == "wine_bottle")
						final[final.size] = ents[i];
				}break;	
				case "helmet":
				{
					if(isdefined(ents[i].targetname) && ents[i].targetname == "helmet_pop")
						final[final.size] = ents[i];
				}break;
			}	
		}
		node thread anim_single_solo(self, "fire_semi");
		self shoot();
		ammo++;
		if(final.size)
		{
			brake = random(final);
			brake dodamage(150,self.origin);
		}
		//self waittillmatch ("single anim", "end");
		node waittill("fire_semi");
		if(ammo >= 4)
		{
			thread playsoundinspace("weap_nagant_reload_npc",self.origin);
			node anim_single_solo(self, "reload_stand");
			ammo = 0;	
		}
		else
		{
			thread playsoundinspace("weap_nagant_rechamber_npc",self.origin);
			node anim_single_solo(self, "chamber");
		}
	}
}

friendly_reinforcements()
{
	level.cur_friendlynum = 0;
	//level.max_friendlynum = 5;
	triggers = getentarray("reinforcement_tracker","targetname");
	array_thread(triggers, ::friendly_reinforcements_setup);
}

friendly_reinforcements_setup()
{
	spwnrs = getentarray(self.target, "targetname");
	self.spawner_size = spwnrs.size;
	array_thread(spwnrs, ::friendly_reinforcements_think, self);
}

friendly_reinforcements_think(trigger)
{
	self.count = 0;
	self.timer = false;
	
	while(1)
	{
		trigger waittill("trigger", other);
		level.reinforcement_trigger = trigger;
		level.max_friendlynum = trigger.spawner_size;
	
		while(!level.flag["no_reinforcements"])
		{
			wait .1;
			if(	level.reinforcement_trigger != trigger)
				break;
			if(self.timer)
				self waittill("timer done");
			while(level.cur_friendlynum >= level.max_friendlynum)
				level waittill ("one_friendly_down");
			self.count = 1;
			guy = self dospawn();
			if(spawn_failed(guy))
				continue;
			
			if(self.targetname == "reinforcements0")
				guy.interval = 20;
			
			guy thread friendly_reinforcements_think1();
			guy thread friendly_reinforcements_think2();
			self thread friendly_reinforcements_think3();
			
			guy thread maps\_utility::magic_bullet_shield();
			guy.ignoreme = true;
			
			wait 2;
			guy notify ("stop magic bullet shield");
			guy.ignoreme = false;		
		}
	}	
}
friendly_reinforcements_think1()
{
	if(!isdefined(self.nointervalchange))
		self.interval = 10;
	self.followmax = level.global_mo_assmax;
	self.followmin = level.global_mo_assmin;
	level.cur_friendlynum++;
	self waittill("death");
	level.cur_friendlynum--;
	level notify ("one_friendly_down");
}

friendly_reinforcements_think3()
{
	self.timer = true;
	wait 3;
	self.timer = false;
	self notify("timer done");
}

friendly_reinforcements_think2()
{
	self endon("death");

	if(!level.flag["friendly_chain"])
		level waittill("friendly_chain");
	self setgoalentity(level.player);
}

friendly_ChainMain()
{
	level.flag["fc500"] = false;
	level.flag["fc200"] = false;
	level.flag["friendly_chain"] = false;
	level.werfertime = 0;
	//take positions at 1st floor
	friendly_ChainTrigger("fc0", "0");
	level.werfertime = 8;
	//take positions at bathroom
	thread friendly_ChainTrigger("fc100", "100");

	//take positions in house - fight with halftrack
	friendly_ChainTrigger("fc200", "200");
	level.flag["fc200"] = true;
	thread autoSaveByName("halftrack");
	level notify("friendlies_at_split");
	level.max_friendlynum = 4;
	//take positions at base of street fight
	friendly_ChainTrigger("fc300", "300");
	level notify("delete_basement");
	ai = getai("basementliver");
	for(i=0;i<ai.size;i++)
		ai[i] delete();
	//further up the street
	friendly_ChainTrigger("fc400", "400");
	thread autoSaveByName("road block");
	//base of house
	friendly_ChainTrigger("fc500", "500");
	level.flag["fc500"] = true;
	level notify("fc500");
	//house1
	thread friendly_ChainTrigger("fc600", "600", true); //base of fire 
	thread friendly_ChainTrigger("fc700", "700", true); //forward and right
	thread friendly_ChainTrigger("fc800", "800", true); //forward and left
	trig = getent("fc600", "target");
	trig waittill("trigger");	//enter the funhouse
	thread autoSaveByName("funhouse");
	level notify("funhouse");
	//attack the house
	friendly_ChainTrigger("fc900", "900", false, "balanced");
	thread autoSaveByName("in first house");
	level notify("in first house");
	trigs = [];
	trigs[trigs.size] = getent("fc600", "target");
	trigs[trigs.size] = getent("fc700", "target");
	trigs[trigs.size] = getent("fc800", "target");
	array_thread(trigs, ::triggerOff);
	//backyard
	friendly_ChainTrigger("fc1000", "1000");
	//second house
	friendly_ChainTrigger("fc1100", "1100");
	//back of second house
	friendly_ChainTrigger("fc1200", "1200");
	level notify("back_of_second_house");
	thread autoSaveByName("in second house");
	//last house
	friendly_ChainTrigger("fc1300", "1300");
	thread blowup_panzer();
	//last positions
	friendly_ChainTrigger("fc1400", "1400");
}

panzer_dialog(origin)
{
	battleChatterOff( "allies" );
	playsoundinspace("moscow_rs4_panzerwerfer", origin);
	battleChatterOn( "allies" );
}

blowup_panzer()
{
	level endon("bomb_planted");
	
	nebel = getent("halftrack_obj2","targetname");
	for(i=1;i<3;i++)
		nebel thread nebelwerfers_makerocket(i, self, undefined, i * .6);
	
	wait .6;	
	earthquake (.4, 2, level.player.origin, 10000);
	
	ai = getaiarray("allies");
	guy = getClosestEnt(level.player.origin, ai);
	thread panzer_dialog(guy.origin);
	level notify("vassili_destroy_that_panzer");
	
	trig = getent("last_guys2","target");
	trig waittill("trigger");
	
	wait .5;
	
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_noteworthy) && (ai[i].script_noteworthy == "last_guys" || ai[i].script_noteworthy == "attack_player") )
			continue;
		else
			ai[i] delete();
	}
	
	ai = getaiarray("axis");
	num = ai.size;
	array_thread(ai,::last_axis_count);	
		
	while(num)
	{
		level waittill("another_last_axis_dead");
		num--;
	}
	
	wait 1;
	add_hudelm_hint(level.strings["explosives"], "bomb_planted");
	
	while(1)
	{
		ai = getaiarray("allies");
		guy = getClosestEnt(level.player.origin, ai);
		guy.ignoreme = true;
		guy thread magic_bullet_shield();
		guy.animname = "rs4";
		playsoundinspace("moscow_rs4_panzerwerfer", guy.origin);
		guy notify ("stop magic bullet shield");
		
		wait 30;
	}
	
}

last_axis_count()
{
	self waittill("death");
	level notify("another_last_axis_dead");	
}

friendly_ChainTrigger(name, number, repeat, itype)
{
	trigger = getent(name, "target");
	type = itype;
	if(isdefined(repeat) && repeat != false)
		_rep = true;
	else
		_rep = false;
	while(1)
	{
		trigger waittill("trigger");
		if(!isdefined(level.fc_trigger) || level.fc_trigger != trigger)
		{
			level.fc_trigger = trigger;
			level notify("new_friendly_chain");
		}
		
		if(!isdefined(type))
			type = "null";
		if(level.global_mo_covertype != type)
		{
			level.global_mo_covertype = type;
			switch(type)
			{
				case "null":
				{
					level.global_mo_assmin 	= 1;
					ai = getaiarray("allies");
					array_thread(ai, ::friendly_reinforcements_think2);
				}break;
				case "balanced":
				{
					level.global_mo_assmin 	= -6;
					ai = getaiarray("allies");
					array_thread(ai, ::friendly_reinforcements_think2);
				}break;	
			}	
		}
		
		chain = get_friendly_chain_node (number);
		level.player SetFriendlyChain (chain);
		level.flag["friendly_chain"] = true;
		level notify("friendly_chain");
		
		if(!_rep)
			break;
	}
	trigger thread triggerOff();
}

ai_stance()
{
	while(1)
	{
		self waittill("trigger", guy);
		if(! (issentient(guy) && !(isplayer(guy)) ))
			continue;
		switch(self.targetname)
		{
			case "ai_stance_all":
				guy allowedstances("crouch", "prone", "stand");
				break;
			case "ai_stance_crouch":
				guy allowedstances("crouch", "prone");
				break;
			case "ai_stance_prone":
				guy allowedstances("prone");
				break;
		}	
	}	
}

getClosestEnt(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0] getorigin(), org);
	ent = array[0];
//	dist = 256;
//	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getClosestNode(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0].origin, org);
	ent = array[0];
//	dist = 256;
//	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getFurthestEnt(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0] getorigin(), org);
	ent = array[0];
//	dist = 256;
//	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist < dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*****************************************************NOT TRAINING**********************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*****************************************************NOT TRAINING**********************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*****************************************************NOT TRAINING**********************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

misc2()
{
	spawners = getspawnerteamarray("axis");
	for(i=0;i<spawners.size;i++)	
		spawners[i].grenadeammo = 0;
	
	trig = getent("start_nebels","targetname");
	trig notify("trigger");
	
	if(!level.jumpto_trench)
		level waittill("attack_of_the_drones");
	else
		wait .1;
	
	wait 7;
	nebel = getent("halftrack_obj2","targetname");
	nebel thread nebelwerfers();
}

fire2(nebel)
{
	level endon("resume_nebel");
	level endon("bomb_planted");
	self waittill("trigger");
	trig = getent("looking_at_nebel", "targetname");
	
	while(1)
	{
		trig waittill("trigger");
		wait .5;
		self thread look_fire2_check();
		wait .1;
		if(level.look_fire2_check)
			break;
	}
}

look_fire2_check()
{
	level endon("resume_nebel");
	level endon("bomb_planted");
	level.look_fire2_check = false;
	self waittill("trigger");
	level.look_fire2_check = true;
}

nebelwerfers()
{
	trigger = undefined;

	trigger = getent("stop_fire2","targetname");
	pause = getent("pause_fire2","targetname");
	resume = getent("resume_fire2", "targetname");
	
	pause thread nebelwerfers_pause(resume, trigger);
	
	trigger endon("trigger");
	self endon("death");
	level endon("bomb_planted");
	
	while(1)
	{
		rockets = 0;
		for(i=1;i<7;i++)
			self thread nebelwerfers_makerocket(i, trigger, (i));
		
		while(rockets < 6 )
		{
			level waittill("fired_rockets");
			rockets++;	
		}
		wait 4 + randomfloat(3);
		while(level.flag["pause_nebel"])
			level waittill("resume_nebel");
	}
}

nebelwerfers_pause(resume, trigger)
{
	level endon("bomb_planted");
	trigger endon("trigger");
	while(1)
	{
		level.flag["pause_nebel"] = false;
		level notify("resume_nebel");
		self waittill("trigger");
		level.flag["pause_nebel"] = true;
		resume waittill("trigger");
	}	
}

deleterocket(nebel)
{
	self endon("deleting");
	nebel waittill("death");
	if(!isdefined(self.firedrockets))
		return;
	self notify("death");
	self delete();	
}

nebelwerfers_makerocket(index, trigger, num, exacttime)
{
	self endon("death");
	level endon("bomb_planted");
	trigger endon("trigger");
	tagname = "tag_rocket_base_0" + index;
	rocket = spawn("script_model", (self gettagorigin(tagname)) );
	
	rocket endon("death");
	rocket thread deleterocket(self);
	
	rocket.tagname = tagname;
	rocket.angles = self gettagangles(tagname);
	rocket setmodel("xmodel/vehicle_halftrack_rockets_shell");
	rocket linkto(self, tagname);
	
	if(isdefined(exacttime))
		wait exacttime;
	else
	{
		wait ((level.werfertime * num * .5) + (num * 6) + (randomfloat(2)));
		while(level.flag["pause_nebel"])
			level waittill("resume_nebel");
	}
	rocket thread nebelwerfers_firerocket();
	playfxOnTag ( level._effect["rocket_launch"], self, tagname );
}

nebelwerfers_firerocket()
{
	self endon("death");
	level notify("fired_rockets");
	
	thread playsoundinspace("nebelwerfer_fire", self.origin);//, self.origin);
	if(player_viewpos_check(self.origin, .2))
	{
		x = 20;
		self unlink();	
		time = .5;
		mov = anglestoforward(self.angles);
		mov = vectornormalize(mov);
		mov = vectorscale(mov, 800);
		mov = mov + (randomfloat(100) - 50, randomfloat(100) - 50, randomfloat(16));
		self thread nebelwerfers_fire_fx();
		wait .1;
		self.firedrockets = true;
		while(x)
		{
			angles = vectortoangles(mov);
			self.angles = angles;
			dir = self.origin + mov;
		
			self moveto(dir, time, 0,0);	
			wait time;
			mov = mov + (0,0,-64);
			x--;
		}
	}
	self notify("deleting");
	self delete();
}

nebelwerfers_fire_fx()
{
	self endon ("death");
	while (1)
	{
		playfxOnTag ( level._effect["rocketfx"], self, "tag_rocket" );
		wait .025;
	}
}

street1_main()
{
	thread sandbags_blow_main();
}

sandbags_blow_main()
{
	spwner = getent("sandbags_blow_guy", "targetname");
	spwner thread sandbags_blow_guy();
	
	level waittill("grenade_catcher_spawned");

	node = getnode("sandbags_blow_node","targetname");
	ai = getaiarray("allies");
	
	throwguy = maps\moscow::getClosestEnt(node.origin, ai);
	throwguy thread sandbags_throw_guy(node);

	ent = getent("sandbags_blow","targetname");
	bags = getentarray(ent.target, "targetname");
	
	for(i=0;i<bags.size;i++)
	{
		bags[i].vec = vectornormalize (bags[i].origin - ent.origin);
		bags[i].vec = vectorScale(bags[i].vec, 100 + randomfloat(50));	
		bags[i] thread sandbags_move();
	}
}

sandbags_move()
{
	level waittill("grenade_catcher_blown");
	org = spawn("script_origin", self.origin);
	self linkto(org);
	
	if (randomint(100) > 50)
		org rotateroll((800 + randomfloat (200)) * -1, 5,0,0);
	else
		org rotateroll(800 + randomfloat (200), 5,0,0);
		
	org moveGravity(self.vec, 5);
	
	wait (.4 + randomfloat(.5));
	org playsound("sandbag_snow");
	
//	trig = getent("sandbags_blow_stop","targetname");	
//	while(!self istouching(trig))
//		wait .05;
	wait 3;
	self unlink();
	org delete();
}

#using_animtree("moscow");
sandbags_blow_guy()
{
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;
	level.playerthreatbias = level.player.threatbias;
	level.player.threatbias = -300;
	guy endon("death");
		
	guy.ignoreme = true;
	guy.grenadeawareness = 0;	
//	node = getnode(self.target, "targetname");
//	turret = getent(node.target, "targetname");

//	guy useturret(turret);
//	turret setmode("auto_ai");
		
	//guy.deathanim = level.scr_anim["generic"]["nade_death"];
	
	level notify("grenade_catcher_spawned");
	
	level waittill("grenade_catcher_fear");
	guy.animname = "generic";
	guy stopuseturret();
	guy.anim_forced_cover = "hide";
	ent2 = getnode("sandbags_death_node","targetname");
	node = spawn("script_origin", ent2.origin + (0,0,20));
	node.angles = ent2.angles;
	guy setgoalnode(ent2);
	guy set_forcegoal();
	guy traverseMode("noclip");
	
	level waittill("grenade_catcher_blown");
	
	guy playsound("moscow_scream");
	node thread anim_single_solo(guy, "nade_death");
	//guy playsound("germansoldier_fall");
	wait .05;
	guy stopanimscripted();
	guy.deathanim = level.scr_anim["generic"]["nade_death"];
	guy dodamage(guy.health + 10000000, (0,0,0));
}

#using_animtree("generic_human");
sandbags_throw_guy(node)
{
	exptime = 1.5;
	thread ready_for_gate();
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.team = "neutral";
	self set_forcegoal();
	self setgoalnode(node);
	self.oldradius = self.goalradius;
	self.goalradius = 4;
	self waittill("goal");
	
	thread playsoundinspace("moscow_rs3_fireinthehole", self.origin);
	
	level notify("grenade_catcher_fear");
	
	self.animname = "generic";
	node thread anim_single_solo ( self, "nade_throw");//, self.tag, undefined, vehicle);
	self waittillmatch ("single anim", "fire");
	nadeStart = self gettagorigin("TAG_WEAPON_RIGHT");
	
	nade = getent("sandbags_blow_nadethrow","targetname");
	self.grenadeWeapon = "Stielhandgranate";
	self.grenadeAmmo++;
	self MagicGrenade (nadeStart, nade.origin, exptime);
	
	//self.ignoreme = false;
	//self.goalradius = self.oldradius;
	self.team = "allies";
	//self unset_forcegoal();
	node = getnode(node.target, "targetname");
	self setgoalnode(node);//setgoalentity(level.player);
	self.goalradius = node.radius;
		
	wait exptime;
	level notify("grenade_catcher_blown");
	ent = getent("house1_mg","script_noteworthy");
	thread playsoundinspace("grenade_explode_brick",ent.origin);
	level.player.threatbias = level.playerthreatbias;
	ent delete();
	ent = getent("sandbags_blow","targetname");
	self thread sandbags_throw_guy2(node);
}

sandbags_throw_guy2(node)
{
	level endon("funhouse");
	level endon("bomb_planted");
	level endon("vassili_destroy_that_panzer");
	
	self.ignoreme = false;
	self unset_forcegoal();
	
	while(level.split_street1_death)
		level waittill("split_street1_death");
	
	self set_forcegoal();
	
		temp = getnode(node.target, "targetname");
		self setgoalnode(temp);
		self.goalradius = 16;
		self waittill("goal");
	
	node = getent("gate_master", "targetname");

	trig = getent("looking_at_nebel", "targetname");
	
	if(!level.flag["ready_for_gate"])
		level waittill("ready_for_gate");
	if(!level.flag["fc500"])
		trig waittill("trigger");
	
	nebel = getent("halftrack_obj2","targetname");
	
	node notify("stop");
	self.oldrun_combatanim = self.run_combatanim;
	self.oldrun_noncombatanim = self.run_noncombatanim;
	self.run_combatanim = %combat_run_fast_3;
	self.run_noncombatanim = %combat_run_fast_3;
	self thread dialogue("moscow_rs3_gate", node);
	wait .4;
	for(i=1;i<3;i++)
		nebel thread nebelwerfers_makerocket(i, self, undefined, i * .6);
	
	wait .6;	
	earthquake (.4, 2, level.player.origin, 10000);
	if(self.myisspeaking)
		self waittill("myisspeaking");
	self.goalradius = self.oldradius;	
	self notify ("stop magic bullet shield");
	
	self setgoalentity(level.player);
	self unset_forcegoal();
	
	trigger = getent("fc500", "target");
	trigger notify("trigger");
	
	wait 2;
	self.run_combatanim = self.oldrun_combatanim;
	self.run_noncombatanim = self.oldrun_noncombatanim;
	
	wait 2;
	forcetrig = getent("house1_assualt", "target");
	forcetrig notify("trigger");
}

ready_for_gate()
{
	level.flag["ready_for_gate"] = false;
	trig = getent("ready_for_gate", "targetname");
	trig waittill("trigger");
	level.flag["ready_for_gate"] = true;
	level notify("ready_for_gate");
}

house2_main()
{
	thread house2_tablekick();	
	spwners = getentarray("house1_runners","targetname");
	array_thread(spwners, ::house2_runners);
	spwners = getent("attack_player","script_noteworthy");
	spwners thread house2_attack_player();
	trig = getent("kill_runner_trig","targetname");
	trig thread house2_killrunner();
	barrels = getentarray("sparky2","script_noteworthy");
	array_thread(barrels, ::house2_sparky2);
	
	level waittill("sparky2_lit");
	nodes = getnodearray("sparky2_retreat","targetname");
	ai = getai("house1_bof", "script_noteworthy", "axis");
	for(i=0;i<ai.size;i++)
		ai[i] thread house2_bof_think(nodes[i]);
}

house2_attack_player()
{
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;	
	guy setgoalentity(level.player);
}

house2_runners()
{
	if(level.scr_moscow_logic !=0)
	{
		self.count = 0;
		return;	
	}
	self thread house2_runners_killspawner();
	self endon("death");
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;	
	guy endon("death");	
	guy thread house2_killrunner2();
	guy set_forcegoal();
	guy.ignoreme = true;	
}

house2_runners_killspawner()
{
	level waittill("in first house");
	self notify("death");
	self.count = 0;
	self delete();
}

house2_killrunner2()
{
	self endon("death");	
	level waittill("back_of_second_house");
	self unset_forcegoal();	
	self.ignoreme = false;
	self setgoalentity(level.player);
	self.goalradius = 256;
}

house2_killrunner()
{
	level endon("back_of_second_house");
	while(1)
	{
		self waittill("trigger", other);
		if(isdefined(other.script_noteworthy) && other.script_noteworthy == "house1_runners")
			other delete();	
	}
}

house2_bof_think(node)
{
	self endon("death");
	self set_forcegoal();
	self setgoalnode(node);
	self.goalradius = node.radius;
	self waittill("goal");
	self unset_forcegoal();	
}

house2_sparky2()
{
	self waittill ("damage", amount ,attacker);
	level notify("sparky2_lit");	
}

house2_tablekick()
{
	tableup			= getent("table_up","targetname");
	tabledown		= getent("table_down", "targetname");
	playclipup		= getent("player_table_clip_up", "targetname");
	playclipdown	= getent("player_table_clip_down", "targetname");
	monclipup		= getent("ai_table_clip_up", "targetname");
	monclipdown		= getent("ai_table_clip_down", "targetname");
	tabledown hide();
	
	playclipdown notsolid();
	monclipdown notsolid();
	playclipup solid();
	monclipup solid();
	
	trig = getent("table_kick", "targetname");
	trig waittill("trigger");
	
	ai = getaiarray("allies");
	node = getnode(trig.target, "targetname");
	
	kicker = maps\moscow::getClosestEnt(node.origin, ai);
	kicker thread magic_bullet_shield();
	kicker.ignoreme = true;
	kicker set_forcegoal();
	kicker.oldradius = kicker.goalradius;
	kicker.goalradius = 4;
	kicker.animname = "generic";
	
	if (randomint (100) > 50)
		animation = "kick_door_1";
	else
		animation = "kick_door_2";
		
	node anim_reach_solo (kicker, animation);
	thread anim_single_solo (kicker, animation, undefined, node);
	kicker waittillmatch ("single anim", "kick");
	
	time = .25;
	tableup playsound ("table_kick_snow");
	tableup rotateto(tabledown.angles, time, 0.1,0);
	tableup moveto(tabledown.origin, time, 0.1,0);
	
	wait time;
	
	tabledown delete();
	playclipdown thread house2_tablekicksolid();
	monclipdown solid();
	
	playclipup delete();
	monclipup connectpaths();
	monclipup delete();

	kicker setgoalnode(getnode(node.target, "targetname"));
	kicker waittill("goal");
	
	kicker endon("death");
	
	kicker notify ("stop magic bullet shield");
	kicker.ignoreme = false;
	kicker unset_forcegoal();
	
	level waittill("new_friendly_chain");
	kicker setgoalentity(level.player);
	kicker.goalradius = kicker.oldradius;
}

house2_tablekicksolid()
{
	while(level.player istouching(self))
		wait .05;
	self solid();
}

plane_makeone(name, type, speed)
{
	node = getVehicleNode( name, "targetname" );
	plane = undefined;
	if(isdefined(type))
	{
		plane = spawnVehicle( type, "plane", "stuka", (0,0,0), (0,0,0) );
		plane setmodel (type);
	}
	else
	{
		plane = spawnVehicle( "xmodel/vehicle_stuka_flying", "plane", "stuka", (0,0,0), (0,0,0) );
		plane setmodel ("xmodel/vehicle_stuka_flying");
	}
	plane attachPath( node );
	plane startPath();
	if(isdefined(speed))
		plane setspeed(speed, speed);
	
	plane thread plane_quake();
	return plane;
}

plane_quake()
{
	self endon("death");
	while (1)
	{
		earthquake(0.25, 0.1, self.origin, 4000); // scale duration source radius
		wait (0.1);
	}
}

getai(name, type, team)
{
	if(!isdefined(type))
		type = "script_noteworthy";
	if(!isdefined(team))
		team = "allies";
	ai = getaiarray(team);
	temp = [];
	for(i=0;i<ai.size;i++)
	{
		switch(type)
		{
			case "script_noteworthy":
			{
				if(isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == name)
					temp[temp.size] = ai[i];
			}break;
			case "targetname":
			{
				if(isdefined(ai[i].targetname) && ai[i].targetname == name)
					temp[temp.size] = ai[i];
			}break;
		}
	}
	return temp;
}

player_viewpos_check(origin, percent)
{
	range = player_viewpos_internal_range(percent);
	return player_viewpos_internal_angles(origin, range);
}

player_viewpos_wait(origin, percent)
{
	range = player_viewpos_internal_range(percent);
	while(player_viewpos_internal_angles(origin, range))
		wait .1;
}

player_viewpos_internal_range(percent)
{
	range = .5;
	if(isdefined(percent))
		range = 1 - percent;
	
	range = 2 * range;
	range -=1;
	return range;
}

player_viewpos_internal_angles(origin, range)
{
	site = vectortoangles(origin - level.player.origin);
	fov = level.player.angles[1];
	if(fov < 0)
		fov = 360 + fov;
	
	LOS = (0,site[1],0);
	POS = (0,fov,0);
	
	object = anglestoforward(LOS);
	playa = anglestoforward(POS);
	
	dot = vectordot(object, playa);
	
	if(dot < range)
		return false;
	else
		return true;
}