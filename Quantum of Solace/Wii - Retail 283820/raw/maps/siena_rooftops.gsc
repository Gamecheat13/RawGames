#include maps\_utility;
#include maps\siena_util;

main()
{
	
	maps\siena_rooftops_fx::main();
	level._effect["muzzle_flash"] = Loadfx("weapons/p99_discharge");

	
	maps\_securitycamera::init();
	
	
	
	
	maps\_vsedan::main("v_sedan_clean_black_radiant_sienna");



	
	PrecacheCutScene("Siena_Mid_Load_Sequence");
	PrecacheCutScene("Siena_SC07_Mitchell_Window_Jump");
	PrecacheCutScene("Siena_Roof_Top_Jump_1");
	PrecacheCutScene("Siena_Roof_Top_Jump_2");
	PrecacheCutScene("Siena_Roof_Top_Jump_3");
	PrecacheCutScene("Siena_SC09_Ledge_Crawl");
	precacheModel("w_t_pipe");
	precacheModel("w_t_p99");
	
	
	level._effect["fxtunnel"] = Loadfx("explosions/grenadeExp_dirt_1");

	
	if( Getdvar( "artist" ) == "1" )
	{
		maps\_load::main();
		return;
	}	

	maps\_load::main();

	
	precacheShader( "compass_map_siena" );
	setminimap( "compass_map_siena", 2304, 1960, -11152, -7136 );
	
	
	thread maps\siena_rooftops_snd::main();
	thread maps\siena_mus::main();
	
	thread setup_vision();
	thread setup_fog();
	thread setup_bond();
	thread setup_objectives();
	thread setup_misc();
	thread setup_skipto();
	thread setup_data_collection();

	init_level_clocks(11, 33, 0);

	thread sway_shutters();
	thread level_achievement();
	thread ground_fail_mission();
}


setup_pip()
{
	wait(.1);
	SetDVar("r_pipSecondaryX", 0.05);
	SetDVar("r_pipSecondaryY", 0.05);						
	SetDVar("r_pipSecondaryAnchor", 0);						
	SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		
	SetDVar("r_pipSecondaryAspect", false);					
	SetDVar("r_pipSecondaryMode", 5);

	level.player setsecuritycameraparams( 55, 3/4 );

	wait(.1);
	level.player SecurityCustomCamera_Push("world", (0, 0, 0), (0, 0, 0), 0.0);
}


setup_vision()
{
	
	VisionSetNaked("siena_rooftop");
	
	level thread apartment_vision_on();
	
}

setup_fog()
{
	
	setExpFog(938, 2500, 0.21, 0.2, 0.2, 0, 0.866);
	
	
}


setup_objectives()
{
	level.strings["objective_1_head"] = &"SIENA_OBJECTIVE_1_HEAD";
	level.strings["objective_1_desc"] = &"SIENA_OBJECTIVE_1_DESC";
	level.strings["objective_2_head"] = &"SIENA_OBJECTIVE_2_HEAD";
	level.strings["objective_2_desc"] = &"SIENA_OBJECTIVE_2_DESC";
	level.strings["objective_3_head"] = &"SIENA_OBJECTIVE_3_HEAD";
	level.strings["objective_3_desc"] = &"SIENA_OBJECTIVE_3_DESC";
	level.strings["objective_4_head"] = &"SIENA_OBJECTIVE_4_HEAD";
	level.strings["objective_4_desc"] = &"SIENA_OBJECTIVE_4_DESC";
	level.strings["objective_5_head"] = &"SIENA_OBJECTIVE_5_HEAD";
	level.strings["objective_5_desc"] = &"SIENA_OBJECTIVE_5_DESC";
	level.strings["objective_6_head"] = &"SIENA_OBJECTIVE_6_HEAD";
	level.strings["objective_6_desc"] = &"SIENA_OBJECTIVE_6_DESC";
	level.strings["objective_7_head"] = &"SIENA_OBJECTIVE_7_HEAD";
	level.strings["objective_7_desc"] = &"SIENA_OBJECTIVE_7_DESC";
	level.strings["objective_8_head"] = &"SIENA_OBJECTIVE_8_HEAD";
	level.strings["objective_8_desc"] = &"SIENA_OBJECTIVE_8_DESC";
	level.strings["objective_9_head"] = &"SIENA_OBJECTIVE_9_HEAD";
	level.strings["objective_9_desc"] = &"SIENA_OBJECTIVE_9_DESC";
	
	Objective_Add( 1, "active", level.strings["objective_4_head"], (-1504, -1692, 366), level.strings["objective_4_desc"]);
	objective_state( 1, "current" );
}


setup_data_collection()
{
	
	
	level.strings["siena_phone_name_0"] = &"SIENA_DATA_TITLE_5";
	level.strings["siena_phone_body_0"] = &"SIENA_DATA_BODY_5";

	
	
	level.strings["siena_phone_name_1"] = &"SIENA_DATA_TITLE_2";

	
	
	level.strings["siena_phone_name_2"] = &"SIENA_DATA_TITLE_3";
	level.strings["siena_phone_body_2"] = &"SIENA_DATA_BODY_3";

	
	
	level.strings["siena_phone_name_3"] = &"SIENA_DATA_TITLE_4";
}


setup_bond()
{
	
	maps\_phone::setup_phone();
}

setup_cameras()
{
	
	level.player thread play_dialogue("TANN_SienG_801A",1);

	
	siena_cameras = GetEntArray( "siena_cam", "targetname" );
	

	for (i=0; i < siena_cameras.size; i++)
	{
		siena_cameras[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
	}

	maps\_securitycamera::camera_tap_start( undefined, siena_cameras);

}


setup_skipto()
{
	switch( getdvar( "skipto") )
	{
	case "cutscene":
	case "Cutscene":
		level.player freezecontrols(true);

		wait(3);
		
		
		
		ludes_gun = spawn("script_model", level.player gettagorigin("TAG_WEAPON_RIGHT") );
	
		ludes_gun linkto( level.player, "TAG_WEAPON_RIGHT" );
		ludes_gun setmodel("w_t_p99");



	
		
		playcutscene("Siena_Mid_Load_Sequence","sequence_end");

		level waittill("sequence_end");
		
		wait( 0.1 );
		ludes_gun unlink();
		wait( 0.1 );
		ludes_gun delete();


		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("streets_start","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		level.player freezecontrols(false);



		level thread event_3_to_4();
		break;

	
	case "rooftops":
	case "Rooftops":
		clear_enemies();
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("rooftops_start","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		
		level thread event_4_to_5();

		wait(.5);
		trigger = GetEnt("after_street_save","targetname");
		trigger notify("trigger");

		break;

	
	case "bus":
	case "Bus":
		clear_enemies();

		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("bus_start","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		level thread event_5_to_6();

		break;

	
	case "gallery":
	case "Gallery":
		clear_enemies();

		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("gallery_start","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		level thread event_6_gallery_battle();
		break;

		
	case "boss":
	case "Boss":
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("boss_start","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		level thread level_end();
		break;

	
	default:
		level thread event_3_to_4();
		break;
	}
}


setup_misc()
{
	
	level.enemy_count = 0;

	
	
}


level_end()
{
	break_2 = GetEnt("gallery_break02","targetname");
	break_3 = GetEnt("gallery_break03","targetname");
	break_3 hide();

	trigger = GetEnt("trigger_level_end","targetname");
	trigger waittill("trigger");

	
	

	Objective_State(9,"done");

	clear_enemies();

	mitchell = spawn_mitchell("event_5_to_6_mitchell");
	
	if(IsDefined(mitchell))
	{
		
		while(isinteracting())
		{
			wait(0.1);
		}

		level notify("fx_mitchell_fight"); 
		level.badguy = mitchell;
		levelend = GetEnt("level_end","targetname");
		level.earthquake = levelend.origin;
		wait(0.1);

		
		while(isinteracting())
		{
			wait(0.1);
		}

		level.player maps\_gameskill::saturateViewThread(false);
		level.player thread handleRooftopVision();
		level.badguy thread maps\_bossfight::boss_transition();
		level.badguy gun_remove();
		level.badguy thread handlePipeAndGun();
		forcephoneactive(false);
		visionsetnaked("siena_rooftop", 0.1);
		Start_Interaction(level.player, mitchell, "BossFight_Mitchell");
		
		
		level notify("playmusicpackage_boss_fight");

		level.player waittillmatch("anim_notetrack","fx_siena_wall_a");
		level notify("tower_boards_start");
		
		level.player waittillmatch("anim_notetrack","fx_siena_glass_bond");
		break_2 hide();
		break_3 show();
		level.player waittillmatch("anim_notetrack", "vision_inside");
		visionsetnaked("siena_gallery", 0.9);
		setExpFog( 0, 1293, 0.5, 0.5, 0.5, 0.25 ); 
		
		level.player waittillmatch("anim_notetrack", "fade_out");
		level.player thread maps\_gameskill::saturateViewThread();
		level.player setorigin(level.earthquake);	
		maps\_endmission::nextmission();
		
	}
	else
	{
		iprintlnbold("Mitchell Not Defined");
	}
}

handleRooftopVision()
{
	self endon("death");
	level.player waittillmatch("anim_notetrack", "vision_rooftop");
	visionsetnaked("siena_rooftop_vision", 0);
	level.player waittillmatch("anim_notetrack", "vision_rooftop_a");
	visionsetnaked("siena_rooftop_boss_a", 1.0);
	
	level.player waittillmatch("anim_notetrack", "vision_rooftop_b");
	visionsetnaked("siena_rooftop_boss_b", 1.0);
	
	level.player waittillmatch("anim_notetrack", "vision_rooftop_c");
	visionsetnaked("siena_rooftop_boss_c", 0);
}

event_3_to_4()
{
	level.player freezecontrols(false);
	wait(.1);
	setSavedDvar("sf_compassmaplevel",  "level3");
	
	clear_enemies();

	level.player playerSetForceCover(true);
	
	
	level notify("playmusicpackage_rooftops");

	init_level_clocks(11, 36, 5);
	level thread setup_cameras();
	level thread voice_tanner_01();
	level thread event_4_street_battle();

	wait(.1);

	level.player playerSetForceCover(false,false);
}

event_4_street_battle()
{
	level thread event_4_to_5();


	
	shudder_r = GetEnt("window_open01","targetname");
	shudder_r rotateyaw(180,.05);

	shudder_l = GetEnt("window_open01a","targetname");
	shudder_l rotateyaw(-180,.05);

	trigger = GetEnt("trigger_4","targetname");
	trigger waittill("trigger");
	trigger delete();

	wave_1_1 = spawn_enemy("initial_1");
	wave_1_1 LockAlertState("alert_red");
	wave_1_1 thread sight_beyond_sight();
	wave_1_1 SetCombatRole("turret");
	
	wait(.1);
	wave_1_2 = spawn_enemy("initial_2");
	wave_1_2 LockAlertState("alert_red");
	wave_1_2 thread sight_beyond_sight();
	wave_1_2 LockAiSpeed("walk");
	wave_1_2 SetCombatRole("rusher");
	wait(.1);
	wave_1_3 = spawn_enemy("initial_3");
	wave_1_3 LockAlertState("alert_red");
	wave_1_3 thread sight_beyond_sight();

	level thread event_4_mitchell_warning();
	level thread voice_thugs_01(wave_1_1, wave_1_2, wave_1_3);
	level thread event_4_watermelon_warning();

	waittill_trigger_or_enemy("trigger_event_4_wave_2",1);

	
	
	
	wave_2_1 = spawn_enemy("streets_window_spawner");
	wave_2_1 LockAlertState("alert_red");
	wave_2_1 thread sight_beyond_sight(10);
	wave_2_1_goal = GetNode("event_4_wave_2_goal_1","targetname");
	wave_2_1 SetGoalNode(wave_2_1_goal);
	wave_2_1 waittill("goal");

	
	shudder_r = GetEnt("window_open01","targetname");
	shudder_r rotateyaw(-160,.3);

	shudder_l = GetEnt("window_open01a","targetname");
	shudder_l rotateyaw(170,.4);

	wait(.1);
	wave_2_2 = spawn_enemy("streets_door_spawner");
	wave_2_2 LockAlertState("alert_red");
	wave_2_2 thread sight_beyond_sight(10);
	wave_2_2 SetCombatRole("flanker");
	wait(.1);
	wave_2_3 = spawn_enemy("streets_raised_spawner");
	wave_2_3 LockAlertState("alert_red");
	wave_2_3 thread sight_beyond_sight(10);
		
}

event_4_watermelon_warning()
{
	watermelon_s = GetEntArray("watermelon_start","targetname");
	watermelon_e = GetEntArray("watermelon_end","targetname");

	for(i = 0; i < 10; i++)
	{
		for(j = 0; j < watermelon_e.size; j++)
		{
			magicbullet("Mantis_Siena",watermelon_s[j].origin,watermelon_e[j].origin);
			wait(.1);
		}
	}
}

event_4_mitchell_warning()
{
	
	
	waittill_trigger_or_enemy("event_4_mitchell_warn",2);

	
	mitchell = spawn_mitchell("event_4_mitchell_2");

	mitchell thread voice_mitchell_01();
	playcutscene("Siena_SC07_Mitchell_Window_Jump","roof_over");

	bullet_orig = GetEnt("mitchell_warn_shot","targetname");

	wait(3);
	for(i = 0; i < 3; i++)
	{	
		wait(.3);
		org = bullet_orig.origin;
		vFwd = AnglesToForward(bullet_orig.angles);
		vUp = anglestoup(bullet_orig.angles);
		endof = level.player.origin;

		Playfx(level._effect["muzzle_flash"],org,vFwd,vUp);
		magicbullet("p99",org,endof);
	}

	level waittill("roof_over");
	wait(.05);
	
	goal = GetNode("event_4_to_5_goal","targetname");
	mitchell SetGoalNode(goal);
	mitchell thread kill_on_goal();
	

	level thread voice_tanner_02();

	Objective_State(1, "done");
	Objective_Add( 2, "active", level.strings["objective_5_head"], (-2592, -2608, 788), level.strings["objective_5_desc"]);
	objective_state( 2, "current" );
}

event_4_to_5()
{
	
	level thread event_4_to_5_door_open();

	trigger = GetEnt("after_street_save","targetname");
	trigger waittill("trigger");

	mitchell = spawn_mitchell("event_4_to_5_mitchell");

	trigger = GetEnt("trigger_4_to_5","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	thread maps\_autosave::autosave_now("siena");

	playcutscene("Siena_Roof_Top_Jump_1","jump_1_over");
	level waittill("jump_1_over");

	level thread event_5_roof_battle();
}

event_4_to_5_door_open()
{
	trigger = GetEnt("trigger_stair_open_door","targetname");

	trigger waittill("trigger");

	door_left = GetEnt("wood_door01","targetname");
	door_right = GetEnt("wood_door02","targetname");
	door_left rotateyaw(-110,.05);
	door_right rotateyaw(115,.05);
	level thread event_4_to_5_door_close();
}

event_4_to_5_door_close()
{
	trigger = GetEnt("trigger_stair_close_door","targetname");

	trigger waittill("trigger");

	door_left = GetEnt("wood_door01","targetname");
	door_right = GetEnt("wood_door02","targetname");
	door_left rotateyaw(110,.05);
	door_right rotateyaw(-115,.05);

	level thread event_4_to_5_door_open();
}

event_4_to_5_civilian()
{
	closet_door = GetEnt("lady_door","targetname");
	closet_door rotateyaw(-95,.05);
	closet_door waittill("rotatedone");
	closet_door connectpaths();

	
	lady_spawner = GetEnt("scared_lady","targetname");
	lady = lady_spawner StalingradSpawn();
	lady.script_pacifist = 0;
	lady gun_remove();
	lady LockAlertState("alert_green");
	lady setenablesense(false);
	
	trigger = GetEnt("trigger_lady","targetname");
	trigger waittill("trigger");
	trigger delete();

	goal = GetNode("lady_goal","targetname");
	lady setscriptspeed("jog");
	lady SetGoalNode(goal);
	lady thread play_dialogue("SIF1_SienG_021A");

	lady waittill("goal");

	closet_door rotateyaw(95,.3);
	
	
	closet_door playsound ("siena_door_generic_close");
	
	closet_door waittill("rotatedone");
	closet_door disconnectpaths();

}

event_5_roof_battle()
{
	level.made_jump = false;

	trigger_hint = GetEnt("balcony_jump_hint","targetname");
	trigger_hint thread jump_trigger();

	trigger = GetEnt("start_mitchell_run","targetname");
	trigger waittill("trigger");
	trigger delete();

	playcutscene("Siena_Roof_Top_Jump_2","jump_2_finished");
	
	mitchell = GetEnt("mitchell","targetname");
	mitchell SetScriptSpeed("Default");
	mitchell_goal = GetNode("event_5_goal","targetname");
	mitchell SetGoalNode(mitchell_goal);
	mitchell thread kill_on_goal();

	trigger = GetEnt("trigger_event_5","targetname");
	trigger jump_trigger();

	level.player freezecontrols(true);

	playcutscene("Siena_Roof_Top_Jump_3","jump_3_finished");
	level.made_jump = true;

	level.player setplayerangles((0, 180, 0));
	level.player freezecontrols(false);

	wait(3.5);
	level.player slow_time(.25, .75, .25);

	EndCutScene("Siena_Roof_Top_Jump_2");

	setSavedDvar("sf_compassmaplevel",  "level4");

	
	level waittill("jump_3_finished");
	
	thread maps\_autosave::autosave_now("siena");

	clear_enemies(1);

	
	t_wait("trigger_right_apartment");

	Objective_State(2, "done");
	Objective_Add( 3, "active", level.strings["objective_6_head"], (-5698, -3126, 548), level.strings["objective_6_desc"]);
	objective_state( 3, "current" );

	
	goal = GetNode("window_2_goal","targetname");
	window_1_enemy = spawn_enemy("left_roof_redirect");
	window_1_enemy thread sight_beyond_sight(-1);
	window_1_enemy LockAlertState("alert_red");
	window_1_enemy SetGoalNode(goal);

	
	window_2_enemy = spawn_enemy("roof_window_1");
	wait(.3);
	window_3_enemy = spawn_enemy("roof_window_2");
	window_4_enemy = spawn_enemy("roof_backup_1");	
	
	
	wait(5);

	
	window_1_enemy SetGoalNode(goal,1);
	
	
	goal = GetNode("backup_turret_goal","targetname");
	window_4_enemy LockAlertState("alert_red");
	window_4_enemy setstaggerpainenable(false);
	window_4_enemy SetGoalNode(goal,1);
	window_4_enemy SetCombatRole("turret");

	
	window_2_enemy LockAlertState("alert_red");
	window_2_enemy thread sight_beyond_sight(-1);
	window_2_goal = GetNode("window_1_goal","targetname");
	window_2_enemy SetGoalNode(window_2_goal);

	window_3_enemy LockAlertState("alert_red");
	window_3_enemy thread sight_beyond_sight(-1);
	window_3_goal = GetNode("window_3_goal","targetname");
	window_3_enemy SetGoalNode(window_3_goal);

	
	window_1_enemy thread event_5_retreat();

	
	level thread event_5_rusher_enemies();
	
	e_wait(0);
	level notify("stop_turrets");

	
	goal = GetNode("redirect_goal_1","targetname");
	redirect_1_enemy = spawn_enemy("roof_redirect");
	redirect_1_enemy LockAlertState("alert_red");
	redirect_1_enemy setstaggerpainenable(false);
	redirect_1_enemy SetCombatRole("turret");
	redirect_1_enemy SetGoalNode(goal);

	
	
	
	wait(1.5);
	goal = GetNode("roof_backup_goal_1","targetname");
	backup_2_enemy = spawn_enemy("roof_backup_2");
	backup_2_enemy LockAlertState("alert_red");
	backup_2_enemy SetGoalNode(goal,1);
	backup_2_enemy thread tether_on_goal(256);
	wait(2);
	goal = GetNode("roof_backup_goal_2","targetname");
	backup_3_enemy = spawn_enemy("roof_backup_2");
	backup_3_enemy LockAlertState("alert_red");
	backup_3_enemy SetGoalNode(goal,1);
	backup_3_enemy thread tether_on_goal(256);
	
	
	thread maps\siena_rooftops_snd::play_door_rattle();
	
	wait(8);

	
	progress_break = spawn_enemy("roof_door_3");
	progress_break LockAlertState("alert_red");
	progress_break thread sight_beyond_sight(-1);
	progress_break setscriptspeed("walk");
	progress_break SetCombatRole("rusher");
	level thread save_on_death(progress_break);

	
	level notify("sn_door_kick_start");
	
	
	thread maps\siena_rooftops_snd::play_door_slam_open();
	
	col = GetEnt("roof_door_collision","targetname");
	col delete();

	
	trigger = GetEnt("trigger_apartment","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	apartment_1_enemy = spawn_enemy("apartment_window");
	apartment_1_enemy LockAlertState("alert_red");
	apartment_1_enemy thread sight_beyond_sight(20);
	apartment_1_goal = GetNode("apartment_window_goal","targetname");
	apartment_1_enemy SetGoalNode(apartment_1_goal);
	wait(.5);
	apartment_2_enemy = spawn_enemy("apartment_roof");
	apartment_2_enemy LockAlertState("alert_red");
	apartment_2_enemy setstaggerpainenable(false);
	apartment_2_enemy SetPainEnable(false);
	apartment_2_goal = GetNode("apartment_roof_goal","targetname");
	apartment_2_enemy SetGoalNode(apartment_2_goal);

	
	waittill_trigger_or_enemy("burst_balcony_doors_trigger",2);

	level thread event_5_zach_fix();

	balcony_guard_1 = spawn_enemy("burst_balcony_1");
	balcony_guard_1.targetname = "b1";
	balcony_guard_2 = spawn_enemy("burst_balcony_2");
	balcony_guard_2.targetname = "b2";
	
	balcony_1_l = GetEnt("apt_door_2_left","targetname");
	balcony_1_r = GetEnt("apt_door_2_right","targetname");
	balcony_1_l rotateyaw(-95,0.5);
	balcony_1_r rotateyaw(97,0.4);
	balcony_1_l waittill("rotatedone");
	balcony_1_l connectpaths();
	balcony_1_r connectpaths();
	balcony_guard_1 LockAlertState("alert_red");
	balcony_guard_1 thread sight_beyond_sight(-1);

	wait(1.5);
	
	balcony_2_l = GetEnt("apt_door_1_left","targetname");
	balcony_2_r = GetEnt("apt_door_1_right","targetname");
	balcony_2_l rotateyaw(-90,0.5);
	balcony_2_r rotateyaw(97,0.4);
	balcony_2_l waittill("rotatedone");
	balcony_2_l connectpaths();
	balcony_2_r connectpaths();
	balcony_guard_2 LockAlertState("alert_red");
	balcony_guard_2 SetCombatRole("flanker");
	balcony_guard_2 thread sight_beyond_sight(-1);
}

event_5_rusher_enemies()
{
	self endon("stop_turrets");

	wait(60);

	turrets = GetAIArray("axis");
	for(i = 0; i < turrets.size; i++)
	{
		turrets[i] setcombatrole("rusher");
	}
}

event_5_zach_fix()
{
	trigger = GetEnt("trigger_event_stairs","targetname");
	trigger waittill("trigger");
	trigger delete();

	level.player shellshock("default",1);

	balcony_guard_1 = GetEnt("b1","targetname");
	balcony_guard_2 = GetEnt("b2","targetname");

	balcony_guard_1_goal = GetNode("retreat_1","targetname");
	if(IsAlive(balcony_guard_1))
	{
		balcony_guard_1 SetGoalNode(balcony_guard_1_goal,1);
	}

	balcony_guard_2_goal = GetNode("retreat_2","targetname");
	if(IsAlive(balcony_guard_2))
	{
		balcony_guard_2 SetGoalNode(balcony_guard_2_goal,1);
	}

	level thread event_5_to_6();
}

event_5_retreat()
{
	self endon("death");

	e_wait(1);

	if(IsAlive(self))
	{
		goal = GetNode("retreat_goal","targetname");
		self setgoalnode(goal);
		self thread kill_on_goal();
	}

}

event_5_fail_jump()
{
	level waittill("jump_2_finished");

	if(level.made_jump == true)
	{
		return;
	}

	MissionFailed();
}

event_5_to_6()
{
	trigger = GetEnt("trigger_stairs","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	mitchell = spawn_mitchell("event_5_to_6_mitchell");
	level thread event_5_to_6_start_bus(mitchell);
	
	
	thread maps\_autosave::autosave_by_name("siena",60);

	level thread voice_tanner_04();

	trigger = GetEnt("trigger_event_5_to_6","targetname");
	trigger waittill("trigger");
	trigger delete();

	level thread event_6_gallery_battle();

	civ_spawners = GetEntArray("gallery_civilian","targetname");
	civ = [];
	for(i = 0; i < civ_spawners.size; i++)
	{
		civ[i] = civ_spawners[i] StalingradSpawn();
		civ[i].script_pacifist = 0;
		civ[i] gun_remove();
		civ[i] LockAlertState("alert_green");
		civ[i] setenablesense(false);
		civ[i] setignorethreat(level.player, true);
		
	}

    
	
	
	

	trigger = GetEnt("trigger_bus","targetname");
	trigger waittill("trigger");

	level thread voice_tanner_03();
	
	
	car_1 = GetEnt("car_1","targetname");
	path = GetVehicleNode("car_1_path","targetname");
	car_1 attachpath( path );
	car_1 startpath();
	car_1 thread unload_vehicle("car_spawner_1","gallery_inside_1");

	wait(.5);

	
	car_2 = GetEnt("car_2","targetname");
	path = GetVehicleNode("car_2_path","targetname");
	car_2 attachpath( path );
	car_2 startpath();
	car_2 thread unload_vehicle("car_spawner_2","gallery_inside_1");

	for(i = 0; i < civ.size; i++)
	{
		if(civ[i].script_noteworthy == "cower")
		{
			civ[i] cmdplayanim("Gen_Civs_CowerBehindCover", false );
		}

		else if(civ[i].script_noteworthy == "shout1")
		{
			civ[i] thread civilian_action_anim("Gen_Civs_ConstructWorkerYellV1");
		}
	
		else if(civ[i].script_noteworthy == "shout2")
		{
			civ[i] thread civilian_action_anim("Gen_Civs_ConstructWorkerYellV2");
		}

		else
		{
			goal = GetNode(civ[i].script_noteworthy,"targetname");
			civ[i] setscriptspeed("jog");
			civ[i] SetGoalNode(goal);
			civ[i] thread kill_on_goal();
		}

	
		wait(.1);
	}

	trigger = GetEnt("crazy_vo","targetname");
	trigger waittill("trigger");


}

event_5_to_6_start_bus(mitchell)
{
	
	
	mitchell SetScriptSpeed("default");
	PlayCutScene("Siena_SC09_Ledge_Crawl","ledge_done");

	level thread event_5_to_6_camera();

	wait(2.3);
	
	level thread event_6_readjust_mitchell(mitchell);

    
	
	

	wait(3);

	burst = GetEnt("collapse_ledge","targetname");
	PhysicsJolt(burst.origin,50,40,(0.5,0.5,-2));
	thread maps\siena_rooftops_snd::play_ledge_fall();
	wait(0.05);
	PhysicsJolt(burst.origin,50,40,(0.5,0.5,-2));
	wait(0.05);
	PhysicsJolt(burst.origin,50,40,(0.5,0.5,-2));
	mitchell thread voice_mitchell_02();


	level waittill("ledge_done");
	wait(.5);
	level notify("stop_readjust");
	
	Objective_State(3, "done");
	Objective_Add( 4, "active", level.strings["objective_7_head"], (-6392, -2760, 709.9), level.strings["objective_7_desc"]);
	objective_state( 4, "current" );
	mitchell_goal = GetNode("event_5_to_6_goal","targetname");
	mitchell SetGoalNode(mitchell_goal);
	mitchell thread kill_on_goal();
	
	car = GetEnt("rabbit","targetname");
	path = GetVehicleNode("rabbit_path","targetname");
	car attachpath( path );
	car startpath();
}

event_5_to_6_camera()
{
	
	
	
	warner = spawn_enemy("gallery_attention_grabber");
	warner LockAlertState("alert_red");
	warner thread sight_beyond_sight(-1);
	warner_goal = GetNode("gallery_attention_grabber_goal","targetname");
	warner SetGoalNode(warner_goal,1);

	
	
	trigger = GetEnt("readjust_mitch_trigger","targetname");
	trigger waittill("trigger");

	if(IsAlive(warner))
	{
		warner stopcmd();
		warner setcombatrole("rusher");
	}


}

event_6_readjust_mitchell(mitchell)
{
	self endon("stop_readjust");

	trigger = GetEnt("readjust_mitch_trigger","targetname");
	trigger waittill("trigger");

	EndCutScene("Siena_SC09_Ledge_Crawl");

	
	if(IsDefined(mitchell))
	{
		rail = spawn("script_origin",mitchell.origin);
		mitchell linkto( rail );
		location = GetEnt("readjust_mitch","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		mitchell unlink();
	}
}

event_6_gallery_battle()
{
	level thread level_end();

	level.bell_complete = false;

	trigger = GetEnt("trigger_gallery_wave_1","targetname");
	trigger waittill("trigger");
	trigger delete();

	level thread bell_sniper();
	level thread voice_tanner_05();

	bell = GetEnt("bell","targetname");

	bell_trigger = GetEnt("trigger_bell_fall","targetname");
	bell_trigger waittill("trigger");

	level notify("bell_tower_top_01_start");
	bell = GetEnt("bell_org","targetname");
	bell playsound("bell_fall_a");
	
	sniper = GetEnt("sniper","targetname");

	if(IsAlive(sniper))
	{
		sniper dodamage(sniper.health, sniper.origin);
		level notify("sniper_killed");
	}

	trigger = GetEnt("sniper_warn_trigger","targetname");
	trigger delete();

	trigger = GetEnt("sniper_kill_trigger","targetname");
	trigger delete();

	Objective_State(5, "done");
	Objective_Add( 6, "active", level.strings["objective_9_head"], (-8068, -3096, 744), level.strings["objective_9_desc"]);
	objective_state( 6, "current" );
	
	wait(1);
	
	thread maps\_autosave::autosave_now("siena");
	
	wave_2_2 = spawn_enemy("spawner_gallery_building_2");
	wave_2_2 LockAlertState("alert_red");
	wave_2_2 thread sight_beyond_sight(-1);
	wave_2_2_goal = GetNode("gallery_wave_2_goal_1","targetname");
	wave_2_2 SetGoalNode(wave_2_2_goal);
	wait(1);
	
	
	wave_2_1 = spawn_enemy("spawner_gallery_building_2");
	wave_2_1 LockAlertState("alert_red");
	wave_2_1 thread sight_beyond_sight(-1);
	wave_2_1 SetCombatRole("elite");
	
	
	t_wait("trigger_gallery_wave_3");
	

	
	wave_1_rusher = spawn_enemy("spawner_gallery_right");
	wave_1_rusher LockAlertState("alert_red");
	wave_1_rusher thread sight_beyond_sight(-1);
	wave_1_rusher SetCombatRole("elite");
	

	
	wait(.5);
	wave_1_1 = spawn_enemy("spawner_gallery_tower");
	wave_1_1 LockAlertState("alert_red");
	wave_1_1_goal = GetNode("tower_goal_1","targetname");
	wave_1_1 SetGoalNode(wave_1_1_goal);
	wait(.5);
	wave_1_2 = spawn_enemy("spawner_gallery_tower");
	wave_1_2 LockAlertState("alert_red");
	wave_1_2_goal = GetNode("tower_goal_2","targetname");
	wave_1_2 SetGoalNode(wave_1_2_goal);
	wave_1_2 thread sight_beyond_sight(20);
	
	waittill_trigger_or_enemy("trigger_gallery_wave_4", 1);

	level thread event_6_second_bell_fall();
	level thread event_6_insure_bell_fall();
	
	
	if(!level.bell_complete)
	{
		wave_2_1 = spawn_enemy("spawner_gallery_left");
		wave_2_1 LockAlertState("alert_red");
		wave_2_1_goal = GetNode("gallery_left_goal_1","targetname");
		wave_2_1 SetCombatRole("turret");
		wave_2_1 thread sight_beyond_sight(20);
		wave_2_1 SetGoalNode(wave_2_1_goal);
	}
	wait(2);
	if(!level.bell_complete)
	{
		wave_2_2 = spawn_enemy("spawner_gallery_left");
		wave_2_2 LockAlertState("alert_red");
		wave_2_2_goal = GetNode("gallery_left_goal_2","targetname");
		wave_2_2 SetGoalNode(wave_2_2_goal,1);
	}
	wait(2);
	if(!level.bell_complete)
	{
		wave_2_3 = spawn_enemy("spawner_gallery_left");
		wave_2_3 LockAlertState("alert_red");
		wave_2_3_goal = GetNode("gallery_left_goal_3","targetname");
		wave_2_3 SetGoalNode(wave_2_3_goal,1);	
		wave_2_2 waittill("goal");
	}

	wait(2);

	level notify("make_bell_fall");
	
	
	level notify("endmusicpackage");
}

event_6_insure_bell_fall()
{
	trigger = GetEnt("make_bell_fall","targetname");
	trigger waittill("trigger");

	level notify("make_bell_fall");
	
	
	level notify("endmusicpackage");
}

event_6_second_bell_fall()
{
	level waittill("make_bell_fall");

	
	level notify("bell_tower_top_02_start");
	level notify("bell_tower_btm_start");

	level.bell_complete = true;
	exp_1 = GetEnt("scaffolding_explosion_1","targetname");
	
	exp_1 playsound("bell_fall_b");
	
	
	wait(1);
	
	RadiusDamage(exp_1.origin, 300,300,300);
	physicsExplosionSphere(exp_1.origin, 300, 300, 1);
	Earthquake(.3,.7,level.player.origin, 2000);
	
	clip = GetEntArray("scaf_floor","targetname");
	for(i = 0; i < clip.size; i++)
	{
		clip[i] delete();
	}
	
	wait(.5);
	exp_2 = GetEnt("scaffolding_explosion_2","targetname");
	RadiusDamage(exp_2.origin, 300,300,300);
	physicsExplosionSphere(exp_2.origin, 300, 300, 1);
	Earthquake(.5,1,level.player.origin, 2000);

	turrets = GetAIArray("axis");
	for(i = 0; i < turrets.size; i++)
	{
		turrets[i] stopcmd();
		turrets[i] setcombatrole("turret");
	}

	
	level notify("stop_cycle");
}

bell_sniper()
{
	level endon("sniper_killed");

	sniper = spawn_enemy("spawner_left_sniper");
	sniper.targetname = "sniper";
	sniper setenablesense(false);
	sniper SetPainEnable(false);
	sniper_goal = GetNode("sniper_left_goal","targetname");
	sniper SetGoalNode(sniper_goal);

	level thread sniper_warning_area();

	sniper waittill("goal");
	sniper cmdshootatentity(level.player, true, -1);
	
	Objective_State(4, "done");
	Objective_Add( 5, "active", level.strings["objective_8_head"], (-7964, -3098, 1084), level.strings["objective_8_desc"]);
	objective_state( 5, "current" );

	while(sniper.health > 50)
	{
		wait(.05);
	}

	if(!IsAlive(sniper))
	{
		bell_trigger = GetEnt("trigger_bell_fall","targetname");
		bell_trigger notify("trigger");
		return;
	}
	sniper thread magic_bullet_shield();
	sniper stopcmd();
	bell = GetEnt("bell_org","targetname");
	sniper cmdshootatentity(bell, true, 1);
	wait(.5);
	sniper stop_magic_bullet_shield();

	bell_trigger = GetEnt("trigger_bell_fall","targetname");
	bell_trigger notify("trigger");
	
}

sniper_warning_area()
{
	bullet_org = GetEnt("magic_start","targetname");
	bullet_pos = GetEntArray("magic_end","targetname");

	trigger = GetEnt("sniper_warn_trigger","targetname");

	while(IsDefined(trigger))
	{
		if(level.player istouching(trigger))
		{
			number = RandomInt(bullet_pos.size);
			magicbullet("A3Raker_Siena_s", bullet_org.origin, bullet_pos[number].origin);
		}
		wait(0.2);
	}

}


level_achievement()
{
	level.dish_count = 7;

	for(i = 7; i > 0; i--)
	{
		level thread monitor_dish(i);
	}

	while(level.dish_count > 0)
	{
		wait(0.5);
	}

	
	GiveAchievement("Challenge_Siena");
}


monitor_dish(index)
{
	trigger = GetEnt("dish_trigger_0"+index,"targetname");

	if(IsDefined(trigger))
	{
		trigger waittill("trigger");

		
		
		dynEnt_StartPhysics("dish0"+index);
		physicsExplosionSphere(trigger.origin, 300, 300, 1);
		level.dish_count--;
	}

}


ground_fail_mission()
{
	trigger = GetEnt("mission_fail","targetname");
	trigger waittill("trigger");

	level.player dodamage(level.player.health + 2000, level.player.origin);
}	


voice_tanner_01()
{
	level.player play_dialogue( "TANN_SienG_701A", 1);
	
}

voice_tanner_02()
{
	level.player play_dialogue("BOND_SienG_535A");
	level.player play_dialogue("TANN_SienG_018A", 1);

}

voice_tanner_03()
{
	level.player play_dialogue("TANN_SienG_025A", 1);
}

voice_tanner_04()
{
	level.player play_dialogue("BOND_SienG_027A");
	level.player play_dialogue("TANN_SienG_028A", 1);
}

voice_tanner_05()
{
	level.player play_dialogue("TANN_SienG_539A", 1);
}

voice_mitchell_01()
{
	self play_dialogue("MITC_SienG_019A");
	level.player play_dialogue("TANN_SienG_020A",1);
}

voice_mitchell_02()
{
	self play_dialogue("MITC_SienG_538A");
}

voice_thugs_01(thug1, thug2,thug3)
{
	thug1 play_dialogue("SMC1_SienG_532A");
	thug2 play_dialogue("SMC2_SienG_533A");
	thug3 play_dialogue("SMC3_SienG_534A");
}

sway_shutters()
{
	left_shutters = GetEntArray("shutter_l","targetname");
	for(i = 0; i < left_shutters.size; i++)
	{
		left_shutters[i] thread sway_left_shutter();
	}
	
	right_shutters = GetEntArray("shutter_r","targetname");
	for(i = 0; i < right_shutters.size; i++)
	{
		right_shutters[i] thread sway_right_shutter();
	}
}

sway_right_shutter()
{
	while(1)
	{
		self rotateyaw(-10,3,1,1);
		self waittill("rotatedone");
		self rotateyaw(10,3,1,1);
		self waittill("rotatedone");
	}
}

sway_left_shutter()
{
	while(1)
	{
		self rotateyaw(10,3,1,1);
		self waittill("rotatedone");
		self rotateyaw(-10,3,1,1);
		self waittill("rotatedone");
	}
}

countPass()
{
	for(;;)
	{
		level.player waittill( "interaction_pass");
		level.numStates++;
		wait(0.5);
	}
}
countFail()
{
	for(;;)
	{
		level.player waittill( "interaction_fail");
		level.numStates++;
		wait(0.5);
	}
}

handlePipeAndGun()
{
	level.numStates = 0;
	self thread countPass();
	self thread countFail();
	
	self attach( "w_t_p99", "TAG_WEAPON_RIGHT" );
	while (level.numStates < 5)
	{
		wait(0.1);
	}
	self detach( "w_t_p99", "TAG_WEAPON_RIGHT" );
	self attach( "w_t_pipe", "TAG_WEAPON_RIGHT" );		
}

temp_fail()
{
	for(;;)
	{
		self waittill("interaction_fail");
		setblur( 15, 0.3);
		earthquake(2.25, 0.25, level.earthquake, 7550);
		VisionSetSecondary(0.7, "boss_fail");
		wait(0.05);
		
		VisionSetSecondary(0.6);
		wait(0.05);
		VisionSetSecondary(0.5);
		wait(0.05);
		VisionSetSecondary(0.4);
		wait(0.05);
		VisionSetSecondary(0.3);
		wait(0.05);
		VisionSetSecondary(0.2);
		wait(0.05);
		VisionSetSecondary(0);
		
		
		setblur( 0, 0.2);
		
	}
}

apartment_vision_on()
{
	trigger = GetEnt("apartment_vision_on","targetname");

	trigger waittill("trigger");

	VisionSetNaked("siena_rooftop_apt",0.2);
	
	level thread apartment_vision_off();
}

apartment_vision_off()
{
	trigger = GetEnt("apartment_vision_off","targetname");

	trigger waittill("trigger");

	VisionSetNaked("siena_rooftop",0.2);

	level thread apartment_vision_on();
}

high_fog_on()
{
	trigger = GetEnt("high_fog","targetname");
	trigger waittill("trigger");

	setExpFog(938, 2500, 0.21, 0.2, 0.2, 0, 0.866);

	level thread low_fog_on();
}

low_fog_on()
{
	trigger = GetEnt("low_fog","targetname");
	trigger waittill("trigger");


	setExpFog(1314, 1500, 0.6109, 0.5493, 0.5062, 1, 1);

	level thread high_fog_on();
}

jump_trigger()
{
	self waittill("trigger");
	hud_wait = 0.1;
	t = 0.0;

	while (true)
	{
		if (level.player IsTouching(self))
		{
			if (t >= hud_wait)
			{
				jump_hud_on();
			}

			if (level.player JumpButtonPressed())
			{
				jump_hud_off();
				return;
			}
		}
		else
		{
			jump_hud_off();
			t = 0.0;
		}

		wait .05;
		t += .05;
	}
}

jump_hud_on()
{
	if (!IsDefined(level.jump_hint_on) || !level.jump_hint_on)
	{
		level.player SetCursorHint("HINT_JUMP");
		level.player SetHintString(&"HINT_JUMP");
		level.jump_hint_on = true;
	}
}

jump_hud_off()
{
	level.player SetCursorHint("");
	level.player SetHintString("");
	level.jump_hint_on = false;
}	
