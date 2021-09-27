#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\hijack_code;

airplane_init_flags()
{
	// Intro
	flag_init( "introscreen_done" );
	flag_init( "intro_player_animate" );
	flag_init( "open_intro_door" );
	flag_init( "start_amb_guys" );
	flag_init( "start_cart_props" );
	flag_init( "intro_done" );
	flag_init( "follow_pres" );
	flag_init( "take_position" );
	flag_init( "move_pres" );
	flag_init( "agent_in_position" );
	flag_init( "ready_for_rescue" );
	flag_init( "door_breach" );
	flag_init( "tv_video_on");
	flag_init( "map_video_on");
	flag_init( "tv_off" );
	flag_init( "kill_movie" );
	flag_init( "delete_intro_ambient_guys" );
	flag_init( "debate_starting" );
	flag_init( "conf_explosion" );
	flag_init( "kill_hijacker3" );
	
	// Hallway to Zero-G
	flag_init("post_debate_vo");
	flag_init("hallway_rumble_02");
	flag_init("stop_constant_shake");
	flag_init("stop_me");
	flag_init( "hallsun_right" );
	flag_init( "hallsun_left" );
	flag_init( "hallsun_right2" );
	flag_init( "hallsun_left2" );
	flag_init( "cmdr_stumbling" );
	flag_init( "pre_zerog_checkpoint" );
	flag_init( "go_jets3" );
	
	// Zero-G
	flag_init("zero_g_done");
	flag_init( "gun_ready" );
	flag_init("spawn_more_fodder");
	flag_init("plane_roll_right");
	flag_init("plane_roll_left");
	flag_init("plane_third_hit");
	flag_init("plane_levels");
	flag_init( "custom_death");
	flag_init( "scripted_death" );
	//flag_init("zerog_enemies_dead");
	
	// Lower level combat
	flag_init("all_hallway_terrorists_dead");
	flag_init("agent_reached_comm_room");
	flag_init("all_comm_room_terrorists_dead");
	flag_init("cargo_room_commander_move");
	flag_init("cargo_room_wave_a_dead");
	flag_init("all_cargo_room_terrorists_dead");
	flag_init("find_daughter_moment_finished");
	flag_init( "kill_cargo" );
	flag_init( "dining_room_done" );
	flag_init( "exited_dining_room" );
	flag_init( "clean_up_dining_room" );
	flag_init("commander_finished_find_daughter_anim");
	flag_init( "stop_phones" );
	flag_init( "turn_on_crash_sled_lights" );
}

start_airplane()
{
	level.player disableWeapons();
	level.org_vba_base = getdvar( "bg_viewBobAmplitudeBase" );
	level.org_vba_standing = getdvar( "bg_viewBobAmplitudeStanding" );
	
	SetSavedDvar( "bg_viewBobAmplitudeBase", "0.05");
	SetSavedDvar( "bg_viewBobAmplitudeStanding", "0.014 0.014");
	
	maps\_compass::setupMiniMap("compass_map_hijack_airplane", "airplane_upper_minimap_corner");
	setsaveddvar( "compassmaxrange", 1500 ); //default is 3500	
	
	level.commander = spawn_ally("commander");
	level.advisor = spawn_ally("advisor");
	level.president = spawn_ally("president");
	level.hero_agent_01 = spawn_ally("hero_agent_01");
	level.hero_agent_01.animname = "hero_agent";
	level.hero_agent_01.ignoreme = true;
	level.hero_agent_01.ignoreall = true;
	
	level.commander disable_ai_color();
	level.hero_agent_01 disable_ai_color();
	level.president disable_ai_color();
		
	level.intro_origin = getstruct("pres_room_struct" , "targetname");
	
	waittillframeend;
	
	level.commander gun_remove();
	
	aud_send_msg("start_airplane");
	
	thread maps\hijack::setup_turbines();
    thread intro_screen();
	thread intro();
	thread intro_env();
	thread intro_doors();
	thread debate();
	//thread intro_close_door3();
	thread hallway_carnage();
	thread zerog();
	thread upper_level_objectives();
	thread screen_movies();
	thread maps\hijack::setup_cloud_tunnel();
}

start_debate()
{
	thread RockingPlane();
	
	level.debate_trigger trigger_on();
	level.debate_trigger_b trigger_on();
	
	player_start_struct = GetStruct( "player_start_debate", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );
	
	level.org_vba_base = getdvar( "bg_viewBobAmplitudeBase" );
	level.org_vba_standing = getdvar( "bg_viewBobAmplitudeStanding" );
	
	SetSavedDvar( "bg_viewBobAmplitudeBase", "0.05");
	SetSavedDvar( "bg_viewBobAmplitudeStanding", "0.014 0.014");
	
	maps\_compass::setupMiniMap("compass_map_hijack_airplane", "airplane_upper_minimap_corner");
	setsaveddvar( "compassmaxrange", 1500 ); //default is 3500
	
	level.player disableWeapons();
	
	level.player SetMoveSpeedScale(.35);
	//level.player allowcrouch( false );
	//level.player allowprone( false );
	level.player allowsprint( false );
	//level.player allowjump( false );
	
	level.commander = spawn_ally("commander");
	level.advisor = spawn_ally("advisor");
	level.president = spawn_ally("president");
	level.hero_agent_01 = spawn_ally("hero_agent_01");
	level.hero_agent_01.animname = "hero_agent";
	level.hero_agent_01.ignoreme = true;
	level.hero_agent_01.ignoreall = true;
	
	level.secretary = spawn_targetname( "secretary" );
	level.secretary.animname = "secretary";
	level.secretary.ignoreme = true;
	level.secretary.ignoreall = true;
	level.secretary magic_bullet_shield();
	
	level.polit_1 = spawn_targetname( "polit_1" );
	level.polit_1.animname = "polit_1";
	level.polit_1.ignoreme = true;
	level.polit_1.ignoreall = true;
	level.polit_1 magic_bullet_shield();
	
	level.polit_2 = spawn_targetname( "polit_2" );
	level.polit_2.animname = "polit_2";
	level.polit_2.ignoreme = true;
	level.polit_2.ignoreall = true;
	level.polit_2 magic_bullet_shield();
	
	level.intro_agent1 = spawn_targetname( "intro_agent1" );
	level.intro_agent1.animname = "generic";
	level.intro_agent1.ignoreme = true;
	level.intro_agent1.ignoreall = true;
	
	level.intro_agent2 = spawn_targetname( "intro_agent2" );
	level.intro_agent2.animname = "generic";
	level.intro_agent2.ignoreme = true;
	level.intro_agent2.ignoreall = true;
	level.intro_agent2 gun_remove();
	
	level.commander disable_ai_color();
	level.hero_agent_01 disable_ai_color();
	level.president disable_ai_color();
		
	level.intro_origin = getstruct("pres_room_struct" , "targetname");
	
	aud_send_msg("debate");
	
	waittillframeend;
	
	level.commander gun_remove();
	
	//aud_send_msg("start_airplane");
	
	flag_set( "intro_done" );
	
	//thread tv_movies();
	thread maps\hijack::setup_turbines();
	thread debate_chair_destroy();
	thread intro_doors();
	thread debate();
	thread hallway_carnage();
	thread zerog();
	thread upper_level_objectives();
	flag_set( "follow_pres" );
	flag_set( "take_position" );
	flag_set( "in_guard_position" );
	thread maps\hijack::setup_cloud_tunnel();
	
	wait(.2);
	
	thread intro_close_door3();
}

start_pre_zero_g()
{
	player_start_struct = GetStruct( "player_start_pre_zero_g", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );
	
	maps\_compass::setupMiniMap("compass_map_hijack_airplane", "airplane_upper_minimap_corner");
	setsaveddvar( "compassmaxrange", 1500 ); //default is 3500
	
	level.commander = spawn_ally("commander");
	level.president = spawn_ally("president");
	
	level.advisor = spawn_ally("advisor");
	level.intro_origin = getstruct("pres_room_struct" , "targetname");
	level.intro_origin thread anim_loop_solo( level.advisor, "debate_cine_advisor_end_loop", "stop_debate_advisor_loop" );
	
	level.hero_agent_01 = spawn_ally("hero_agent_01");
	level.hero_agent_01.animname = "hero_agent";
	waittillframeend;
	
	level.door3 = getent( "intro_door3" , "targetname");
	level.door3 MoveY( 50, .1);
	
	flag_set( "pre_zerog_checkpoint" );
	flag_set( "player_ahead" );
	
	level.hallway_roller = spawn_anim_model( "upperhall_roller", level.player.origin);
	
	aud_send_msg("start_pre_zero_g");

	level.player SetMoveSpeedScale(.85);
	
	level.commander.goalradius = 16;
	prezero_node = GetNode( "commander_zerog", "targetname" );
	level.commander setgoalnode( prezero_node );
	
	thread maps\hijack::setup_turbines();
	thread hallway_plane_lurch();
	thread pre_zerog_behavior();
	thread hallway_carnage();
	//thread constant_rumble();
	thread zerog();
	thread upper_level_objectives();
	flag_set( "follow_pres" );
	flag_set( "take_position" );
	flag_set( "in_guard_position" );
	flag_set( "move_pres" );
	thread maps\hijack::setup_cloud_tunnel();
}

start_lower_level_combat()
{
	player_start_struct = GetStruct( "player_start_lower_level_combat", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );
	
	maps\_compass::setupMiniMap("compass_map_hijack_airplane", "airplane_upper_minimap_corner");
	setsaveddvar( "compassmaxrange", 1500 ); //default is 3500
	
	level.commander = spawn_ally("commander");
	level.president = spawn_ally("president");
	level.advisor = spawn_ally("advisor");
	level.intro_origin = getstruct("pres_room_struct" , "targetname");
	level.intro_origin thread anim_loop_solo( level.advisor, "debate_cine_advisor_end_loop", "stop_debate_advisor_loop" );
	level.hero_agent_01 = spawn_ally("hero_agent_01");
	level.zerog_agent_01 = spawn_ally("zerog_agent_01");
	level.zerog_agent_02 = spawn_ally("zerog_agent_02");
	
	level.player.ignoreme = false;
	level.commander.ignoreme = true;
	level.commander.ignoreall = true;
	level.hero_agent_01.ignoreme = false;
	level.hero_agent_01.ignoreall = false;

	level.player EnableWeapons();
	
	level.door3 = getent( "intro_door3" , "targetname");
	level.door3 MoveY( 50, .1);
	
	//level.player GiveWeapon("p90_acog");
	//level.player SwitchToWeapon("p90_acog");
	
	level.zerog_agent_01.ignoreme = true;
	level.zerog_agent_01.ignoreall = true;
	//zerog_agent_01_node1 = getnode( "agent1_postzero_node1", "targetname" );
	//level.zerog_agent_01 setgoalnode( zerog_agent_01_node1 );
	
	level.zerog_agent_02.ignoreme = true;
	level.zerog_agent_02.ignoreall = true;
	//zerog_agent_02_node1 = getnode( "agent2_postzero_node1", "targetname" );
	//level.zerog_agent_02 setgoalnode( zerog_agent_02_node1 );
	
	level.zerog_agent_03 = spawn_targetname( "zerog_agent_03" );
	level.zerog_agent_03 thread magic_bullet_shield();
	level.zerog_agent_03 no_grenades();
	level.zerog_agent_03.baseaccuracy = .1;
	level.zerog_agent_03.ignoreSuppression = true;

	waittillframeend;
	
	thread zerog_done_agents();

	aud_send_msg("start_lower_level_combat");
	
	level.player SetMoveSpeedScale(.85);
	
	thread maps\hijack::setup_turbines();
	thread constant_rumble();
	thread moving_to_bottom_level();
	thread maps\hijack::setup_cloud_tunnel();
}

hallway_rumble_low()
{
	aud_send_msg("rumble");
		
	earthquake( .12, 4.5, level.player.origin, 80000 );
	level.player PlayRumbleOnEntity( "hijack_plane_low" );
}

/*hallway_rumble_med()
{
	aud_send_msg("rumble");
	
	earthquake( .22, 4.5, level.player.origin, 80000 );
	level.player PlayRumbleOnEntity( "hijack_plane_medium" );
}*/

upper_level_objectives()
{
	//FOLLOW PRESIDENT
	orig_fade = getdvar( "objectiveFadeTooFar" );
	flag_wait( "follow_pres" );
	Objective_Add( obj("follow_president"), "current", &"HIJACK_FOLLOW_PRES", level.hero_agent_01.origin );
	Objective_OnEntity( obj("follow_president"), level.hero_agent_01, (0, 0, 70));
	SetSavedDvar( "objectiveFadeTooFar", 1 );
	wait(3);
	SetSavedDvar( "objectiveFadeTooFar", orig_fade );
	
	flag_wait( "take_position" );
	
	//TAKE POSITION
	pos_struct = getstruct( "take_pos", "targetname");
	Objective_Complete( obj("follow_president"));
	Objective_Add( obj("take_position"), "current", &"HIJACK_TAKE_POS", pos_struct.origin );
	flag_wait( "in_guard_position" );
	Objective_Complete( obj("take_position") );
	
	//MOVE PRESIDENT TO SAFETY
	flag_wait( "move_pres" );
	pres_struct = getstruct( "obj_pres_move", "targetname");
	Objective_Add( obj("move_president"), "current", &"HIJACK_MOVE_PRES", pres_struct.origin );
	// aud_send_msg("move_president_music_cue");
}

/*---------------------------------------------------
	
	       President's Office, Hallway, Conf Room
	
----------------------------------------------------*/

intro_screen()
{
	duration = 18.5;
	
	level.player FreezeControls( true );
	
	thread maps\_introscreen::introscreen_generic_black_fade_in( duration, 4 );
	
	lines = [];

	lines[ lines.size ] = &"HIJACK_INTROSCREEN_LINE1";
	lines[ lines.size ] = &"HIJACK_INTROSCREEN_LINE2";
	lines[ lines.size ] = &"HIJACK_INTROSCREEN_LINE3";
	lines[ lines.size ] = &"HIJACK_INTROSCREEN_LINE4";
	lines[ lines.size ] = &"HIJACK_INTROSCREEN_LINE5";
	
	//wait(1.5);
	wait(.5);
	thread introscreen_VO();
	//wait(8);
	wait(9);
	maps\_introscreen::introscreen_feed_lines( lines );
	wait(3);
	flag_set( "introscreen_done" );		
}

introscreen_VO()
{
	radio_dialogue( "hijack_plt_moscow" );
	radio_dialogue( "hijack_cmd_reportin" );
	wait(.5);
	radio_dialogue( "hijack_fso1_presidentoffice" );
	wait(.3);
	radio_dialogue( "hijack_fso2_lowerdeckclear" );
	wait(.6);
	radio_dialogue( "hijack_fso3_fowardcabin" );
	wait(1);
	radio_dialogue( "hijack_cmd_landinhamburg" );
	//wait(1.25);
	wait(.75);
	radio_dialogue( "hijack_cmd_remainwithpres" );
}
	
intro()
{
	//thread tv_movies();
	thread RockingPlane();
	thread intro_ambient_people();
	thread intro_door0();
	thread intro_nag1();
	thread intro_nag2();
	
	//--------------test
	intro_door1 = getEnt( "intro_door1", "targetname" );
	intro_door1 MoveY( 50, .05 );
	daughter_block = getEnt( "block_player_from_daughter", "targetname" );
	daughter_block hide();
	daughter_block NotSolid();
	
	level.jet_1a = spawn_vehicle_from_targetname_and_drive( "mig_1a" );
	level.jet_1b = spawn_vehicle_from_targetname_and_drive( "mig_1b" );
	// disable rumble for the migs for the fly in
	level.jet_1a vehicle_kill_rumble_forever();
	level.jet_1b vehicle_kill_rumble_forever();
	
	level.jet_1a thread hide_jet_parts();
	level.jet_1b thread hide_jet_parts();
	
	level.hero_agent_01 gun_remove();
	
	level.intro_agent1 = spawn_targetname( "intro_agent1" );
	level.intro_agent1.animname = "generic";
	level.intro_agent1.ignoreme = true;
	level.intro_agent1.ignoreall = true;
	
	level.intro_agent3 = spawn_targetname( "intro_agent3" );
	level.intro_agent3.animname = "generic";
	level.intro_agent3.ignoreme = true;
	level.intro_agent3.ignoreall = true;
	level.intro_agent3 PushPlayer(true);
	
	level.daughter1 = spawn_targetname( "intro_daughter" );
	level.daughter1.animname = "daughter";
	level.daughter1.ignoreme = true;
	level.daughter1.ignoreall = true;
	level.daughter1 gun_remove();
	level.daughter1 thread intro_delete_when_done();
	level.daughter1 PushPlayer(true);
	
	level.president PushPlayer(true);
	
	assistant = spawn_targetname( "assistant" );
	assistant.animname = "assistant";
	assistant.ignoreme = true;
	assistant.ignoreall = true;
	assistant gun_remove();
	assistant thread intro_delete_when_done();
	
	intro_guys = [];
	intro_guys[ 0 ] = level.president;
	//intro_guys[ 1 ] = level.daughter1;
	intro_guys[ 2 ] = assistant;
	
	thread intro_player();

	flag_wait( "introscreen_done" );
	thread intro_hero_agent();
	flag_set( "intro_player_animate" );
	
	level.hero_agent_01 waittillmatch( "single anim", "start_daughter" );
	level.intro_origin thread anim_single_solo( level.daughter1, "intro_scene" );
	level.intro_origin thread intro_anim_and_loop( level.intro_agent3, "intro_cine_agent3", "intro_cine_agent3_loop", "stop_ambguy_loop" );
	
	level.hero_agent_01 waittillmatch( "single anim", "start_intro" );
	level.intro_origin thread anim_single( intro_guys, "intro_scene" );
	thread intro_VO();
	thread intro_pres_notes();
	
	//wait(6);
	wait(4.5);
	intro_door1 MoveY( -50, 1, .25, .50 );
	aud_send_msg("intro_door1_open");
	flag_set( "start_amb_guys" );
	daughter_trigger = getEnt( "block_player_from_daughter_volume", "targetname" );
	daughter_block2 = getEnt( "block_player_from_daughter_2", "targetname" );
	
	if( !level.player IsTouching( daughter_trigger ))
	{
		daughter_block show();
		daughter_block Solid();
	}
	
	//wait (4.4);
	wait(5.9);
	flag_set( "follow_pres" );
	daughter_block hide();
	daughter_block NotSolid();
	daughter_block2 delete();
	//flag_set( "start_amb_guys" );
	
	level.president waittillmatch( "single anim", "end" );
	flag_set( "intro_done" );
	
	level.debate_trigger trigger_on();
	level.debate_trigger_b trigger_on();
	
	if( !flag( "in_guard_position" ))
	{
		level.intro_origin thread anim_loop_solo( level.president, "intro_cine_president_wait_loop", "stop_intro_loop" );
	}
	
	//level.daughter1 Delete();
	//assistant Delete();
}

hide_jet_parts()
{
	self HidePart( "front_wheel_panel_jnt", "vehicle_mig29" );
	self HidePart( "front_wheel_base_jnt", "vehicle_mig29" );
	self HidePart( "ri_wheel_panel_jnt", "vehicle_mig29" );
	self HidePart( "ri_wheel_base_jnt", "vehicle_mig29" );
	self HidePart( "le_wheel_panel_jnt", "vehicle_mig29" );
	self HidePart( "le_wheel_base_jnt", "vehicle_mig29" );	
}

intro_delete_when_done()
{
	self waittillmatch( "single anim", "end" );
	self Delete();
}

intro_player()
{
	//turn off HUD until you can move.
	SetSavedDvar( "compass", 0 );
    SetSavedDvar( "ammoCounterHide", 1 );
    SetSavedDvar( "hud_showstance", 0 );
    SetSavedDvar( "actionSlotsHide", 1 );
	
    rig = spawn( "script_origin", level.player.origin);// + (0, 0, -2) );
	rig.angles = level.player.angles; //+ (10, 0, 0);
	
	level.player allowsprint( false );

	level.player PlayerLinkToAbsolute( rig );
	flag_wait( "introscreen_done" );
	wait(3);
	
	//level.player Unlink();
	level.player SetMoveSpeedScale(.35);
	level.player FreezeControls( false );	
	level.player Unlink();
	rig Delete();
	//---------level.player PlayerLinkTo( rig, undefined, 1, 60, 60, 40, 40 );
	
	flag_wait( "follow_pres" );
	//aud_send_msg ( "pilot_announcement" );
	thread intro_announcements();
	
	//turn off HUD until you can move.
	SetSavedDvar( "compass", 1 );
    SetSavedDvar( "ammoCounterHide", 0 );
    SetSavedDvar( "hud_showstance", 1 );
    SetSavedDvar( "actionSlotsHide", 0 );
	
	/*level.player SetMoveSpeedScale(.35);
	level.player FreezeControls( false );	
	level.player Unlink();
	rig Delete();*/
	
	flag_wait( "second_migs" );
	level.jet_2a = spawn_vehicle_from_targetname_and_drive( "mig_2a" );
	level.jet_2b = spawn_vehicle_from_targetname_and_drive( "mig_2b" );
	// disable rumble for the migs for the fly in
	level.jet_2a vehicle_kill_rumble_forever();
	level.jet_2b vehicle_kill_rumble_forever();
	level.jet_2a thread hide_jet_parts();
	level.jet_2b thread hide_jet_parts();
}

intro_announcements()
{
	wait( 0.4 );
	loc = Spawn( "script_origin",(-29408, 12720, 7312));
	loc playsound("hijk_pilot_bell");
    wait ( 1.6 );
    background_chatter( "hijack_plt_message1", loc );
    wait( 1.4 );
    background_chatter( "hijack_plt_message2", loc );
    wait( 1.9 );
    background_chatter( "hijack_plt_message3", loc );
    wait (5);
    loc delete();
}

intro_hero_agent()
{
	level.intro_origin anim_single_solo( level.hero_agent_01, "intro_scene" );
	flag_set( "agent_in_position" );
	if( !flag( "in_guard_position" ))
	{
		level.intro_origin thread anim_loop_solo( level.hero_agent_01, "intro_cine_hero_agent_loop", "stop_intro_loop");
	}
}

intro_door0()
{
	intro_door0 = getEnt( "intro_door0", "targetname" );
	intro_door0 MoveY( -52, .05 );
	
	wait(.2);
	
	door_rig0 = spawn_anim_model("door");
	level.intro_origin thread anim_first_frame_solo( door_rig0, "intro_cine_presdoor_open" );
	intro_door0 linkto( door_rig0 , "J_prop_1" );
	
	level.hero_agent_01 waittillmatch( "single anim", "start_intro" );
	level.intro_origin thread anim_single_solo( door_rig0, "intro_cine_presdoor_open" );
	//intro_door0 MoveY( 32, 1, 0, .25 );
	// aud_send_msg("intro_door0_open");
	
	level.daughter1 waittillmatch( "single anim", "close_door" );
	//intro_door0 MoveY( -32, 1, 0, .25 );
	// aud_send_msg("intro_door0_open");
}

intro_ambient_people()
{
	array_spawn_function_targetname( "ambient_workers", maps\hijack::setup_generic_script_guy );
	
	ambientguys = array_spawn_targetname( "ambient_workers" );
	
	amb_guy1 = get_living_ai( "ambient_worker1", "script_noteworthy" );
	amb_guy2 = get_living_ai( "ambient_worker2", "script_noteworthy" );
	amb_guy3 = get_living_ai( "ambient_worker3", "script_noteworthy" );
	amb_guy4 = get_living_ai( "ambient_worker4", "script_noteworthy" );
	
	thread intro_ambient_cart_props();
	
	clipboard = getEnt( "ambient_worker_clipboard1", "targetname" );
	pencil = getEnt( "ambient_worker_pencil", "targetname" );
	clipboard_rig = spawn_anim_model("clipboard");
	level.intro_origin thread anim_first_frame_solo( clipboard_rig, "intro_worker_clipboard" );
	
	cl_origin = clipboard_rig GetTagOrigin( "J_prop_1" );
	cl_angles = clipboard_rig GetTagAngles( "J_prop_1" );
	origin2 = clipboard_rig GetTagOrigin( "J_prop_2" );
	angles2 = clipboard_rig GetTagAngles( "J_prop_2" );
	clipboard.origin = cl_origin;
	clipboard.angles = cl_angles;
	pencil.origin = origin2;
	pencil.angles = angles2;
		
	clipboard linkto( clipboard_rig , "J_prop_1" );
	pencil linkto( clipboard_rig, "J_prop_2" );
		
	cart = getEnt( "ambient_cart", "targetname" );
	cart_rig = spawn_anim_model("food_cart");
	level.intro_origin thread anim_first_frame_solo( cart_rig, "intro_storage_cart" );
	cart linkto( cart_rig , "J_prop_1" );
	
	level.intro_origin thread anim_first_frame_solo( amb_guy1, "intro_worker_checklist" );
	level.intro_origin thread anim_first_frame_solo( amb_guy2, "intro_storage_guy" );
	level.intro_origin thread anim_first_frame_solo( amb_guy3, "intro_kitchenette_guy1" );
	level.intro_origin thread anim_first_frame_solo( amb_guy4, "intro_kitchenette_guy2" );
	
	stir_stick = getEnt( "coffee_stir_stick", "targetname" );
	stick_origin = amb_guy3 GetTagOrigin("tag_weapon_right");
	stick_angles = amb_guy3 GetTagAngles("tag_weapon_right");
	stir_stick.origin = stick_origin;
	stir_stick.angles = stick_angles;
	stir_stick linkto( amb_guy3, "tag_weapon_right" );
	
	flag_wait( "start_amb_guys" );
	thread intro_anim_and_loop( amb_guy1, "intro_worker_checklist", "intro_worker_checklist_loop", "stop_ambguy_loop");
	thread intro_anim_and_loop( clipboard_rig, "intro_worker_clipboard", "intro_worker_clipboard_loop", "stop_ambguy_loop");
	thread intro_anim_and_loop_cartguy( amb_guy2, "intro_storage_guy", "intro_storage_guy_loop", "stop_ambguy_loop");
	level.intro_origin thread anim_single_solo( cart_rig, "intro_storage_cart" );
	aud_send_msg("hijk_cart_moves");
	wait(7.9);
	wait(5.9);//-------adding temp to keep guys timed with pres
	thread intro_anim_and_loop( amb_guy3, "intro_kitchenette_guy1", "intro_kitchenette_guy1_loop", "stop_ambguy_loop");
	thread intro_anim_and_loop( amb_guy4, "intro_kitchenette_guy2", "intro_kitchenette_guy2_loop", "stop_ambguy_loop");
	amb_guy4 PushPlayer( true );
	aud_send_msg("hijk_agent_espresso");
	aud_send_msg("keypad");
	
	flag_wait( "delete_intro_ambient_guys" );
	level.intro_origin notify( "stop_ambguy_loop" );
	waittillframeend;
	if ( isdefined( amb_guy1.magic_bullet_shield ) )
		amb_guy1 stop_magic_bullet_shield();
	if ( isdefined( amb_guy2.magic_bullet_shield ) )
		amb_guy2 stop_magic_bullet_shield();
	if ( isdefined( amb_guy3.magic_bullet_shield ) )
		amb_guy3 stop_magic_bullet_shield();
	if ( isdefined( amb_guy4.magic_bullet_shield ) )
		amb_guy4 stop_magic_bullet_shield();
	
	//waittillframeend;
	amb_guy1 delete();
	amb_guy2 delete();
	amb_guy3 delete();
	amb_guy4 delete();
	clipboard delete();
	clipboard_rig delete();
	cart delete();
	cart_rig delete();
	
	level.intro_agent3 delete();
}

intro_ambient_cart_props()
{
	peanuts = getEnt( "peanuts", "targetname" );
	candy1 = getEnt( "candy1", "targetname" );
	candy2 = getEnt( "candy2", "targetname" );
	
	peanuts_rig = spawn_anim_model("food_cart");
	level.intro_origin thread anim_first_frame_solo( peanuts_rig, "intro_storage_peanuts" );
	candy_rig = spawn_anim_model("food_cart");
	level.intro_origin thread anim_first_frame_solo( candy_rig, "intro_storage_candy" );
	//candy2_rig = spawn_anim_model("food_cart");
	//level.intro_origin thread anim_first_frame_solo( candy2_rig, "intro_storage_candy2" );
	
	waittillframeend;
	
	pe_origin = peanuts_rig GetTagOrigin( "J_prop_1" );
	pe_angles = peanuts_rig GetTagAngles( "J_prop_1" );
	ca1_origin = candy_rig GetTagOrigin( "J_prop_1" );
	ca1_angles = candy_rig GetTagAngles( "J_prop_1" );
	//ca2_origin = candy2_rig GetTagOrigin( "J_prop_1" );
	//ca2_angles = candy2_rig GetTagAngles( "J_prop_1" );
	
	waittillframeend;
	
	peanuts.origin = pe_origin;
	peanuts.angles = pe_angles;
	//peanuts hide();
	candy1.origin = ca1_origin;
	candy1.angles = ca1_angles;
	//candy1 hide();
	//candy2.origin = ca2_origin;
	//candy2_angles = ca2_angles;
	//candy2 hide();
	
	peanuts linkto( peanuts_rig, "J_prop_1" );
	candy1 linkto( candy_rig, "J_prop_1" );
	//candy2 linkto( candy2_rig, "J_prop_1" );
	
	flag_wait( "start_cart_props" );
	//peanuts show();
	//candy1 show();
	//candy2 show();
	level.intro_origin thread anim_loop_solo( peanuts_rig, "intro_storage_peanuts_loop", "stop_ambguy_loop" );
	level.intro_origin thread anim_loop_solo( candy_rig, "intro_storage_candy_loop", "stop_ambguy_loop" );
	//level.intro_origin thread anim_loop_solo( candy2_rig, "intro_storage_candy2_loop", "stop_ambguy_loop" );
	
	flag_wait( "delete_intro_ambient_guys" );
	wait(.05);
	peanuts delete();
	peanuts_rig delete();
	candy1 delete();
	candy2 delete();
	candy_rig delete();
	//candy2_rig delete();
}

intro_anim_and_loop_cartguy( guy, anime, loopanim, loop_stop_notify )
{
	level.intro_origin anim_first_frame_solo( guy, anime );
	candy2 = getEnt( "candy2", "targetname" );
	
	ca2_origin = guy GetTagOrigin( "TAG_WEAPON_CHEST" );
	ca2_angles = guy GetTagAngles( "TAG_WEAPON_CHEST" );
	candy2.origin = ca2_origin;
	candy2.angles = ca2_angles;
	
	candy2 linkto( guy, "TAG_WEAPON_CHEST" );
	
	level.intro_origin anim_single_solo( guy, anime );
	
	flag_set( "start_cart_props" );
	
	if( !flag( "in_guard_position" ))
	{
		level.intro_origin thread anim_loop_solo( guy, loopanim, loop_stop_notify );
		flag_wait( "debate_starting" );
		//guy StopAnimScripted();
	}
	
}

intro_VO()
{
	level.daughter1 waittillmatch( "single anim", "sub_cliff_ru2_suspicious" );
	//flag_set( "take_position" );
}

intro_nag1()
{
	level endon( "second_migs" );
	
	flag_wait( "follow_pres" );
	
	while( !flag( "second_migs" ))
	{
		wait(12);
		radio_dialogue( "hijack_cmd_staywithpres" );
	}
}

intro_nag2()
{
	level endon( "in_guard_position" );
	
	flag_wait( "intro_done" );
	
	while( !flag( "in_guard_position" ))
	{
		wait(12);
		radio_dialogue( "hijack_cmd_takeposition" );
	}
}

intro_pres_notes()
{
	binder = getEnt( "pres_book", "targetname" );
	paper = getEnt( "pres_paper", "targetname" );
	binder_rig = spawn_anim_model("binder");
	level.intro_origin thread anim_first_frame_solo( binder_rig, "intro_cine_pres_binder" );
	origin = binder_rig GetTagOrigin( "J_prop_1" );
	angles = binder_rig GetTagAngles( "J_prop_1" );
	origin2 = binder_rig GetTagOrigin( "J_prop_2" );
	angles2 = binder_rig GetTagAngles( "J_prop_2" );
	binder.origin = origin;
	binder.angles = angles;
	paper.origin = origin2;
	paper.angles = angles2;
	binder linkto( binder_rig , "J_prop_1" );
	paper linkto( binder_rig , "J_prop_2" );
	
	level.intro_origin thread anim_single_solo( binder_rig, "intro_cine_pres_binder" );
	aud_send_msg("pres_drops_paper");
	
	//level.president attach( "com_office_book_black_standing", "tag_weapon_right", true );
	
	level.president waittillmatch( "single anim", "drop_folder" );
	
	//level.president Detach( "com_office_book_black_standing", "tag_weapon_right" );
		
}

intro_asst_door(guy)
{
	aud_send_msg("start_news");
	
	level.intro_origin anim_single_solo( level.door_rig2, "intro_door2_assistant_open" );
}

intro_conf_room(guy)
{
	level.secretary = spawn_targetname( "secretary" );
	level.secretary.animname = "secretary";
	level.secretary.ignoreme = true;
	level.secretary.ignoreall = true;
	level.secretary magic_bullet_shield();
	
	level.polit_1 = spawn_targetname( "polit_1" );
	level.polit_1.animname = "polit_1";
	level.polit_1.ignoreme = true;
	level.polit_1.ignoreall = true;
	level.polit_1 magic_bullet_shield();
	
	level.polit_2 = spawn_targetname( "polit_2" );
	level.polit_2.animname = "polit_2";
	level.polit_2.ignoreme = true;
	level.polit_2.ignoreall = true;
	level.polit_2 magic_bullet_shield();
	
	level.intro_agent2 = spawn_targetname( "intro_agent2" );
	level.intro_agent2.animname = "generic";
	level.intro_agent2.ignoreme = true;
	level.intro_agent2.ignoreall = true;
	level.intro_agent2 gun_remove();
	
	level.conf_phone_1 = GetEnt( "conf_phone", "targetname" );
	level.conf_phone_1.animname = "phone";
	level.conf_phone_1 setanimtree();

	thread intro_tv_off();
	level.intro_origin thread anim_single_solo( level.conf_phone_1, "debate_phone" );
	thread intro_anim_and_loop( level.commander, "intro_cine_commander", "intro_cine_commander_wait_loop", "stop_intro_loop");
	thread intro_anim_and_loop( level.advisor, "intro_cine_advisor", "intro_cine_advisor_wait_loop", "stop_intro_loop");
	thread intro_anim_and_loop( level.secretary, "intro_cine_secretary", "intro_cine_secretary_wait_loop", "stop_intro_loop");
	
	origin = level.secretary GetTagOrigin( "tag_inhand" );
	angles = level.secretary GetTagAngles( "tag_inhand" );
	level.remote = spawn( "script_model", origin );
	level.remote SetModel( "electronics_pda" );
	level.remote.angles = angles;
	level.remote LinkTo( level.secretary, "tag_inhand" );
	
	//level.secretary attach( "electronics_pda", "tag_inhand", true );
	thread intro_anim_and_loop( level.intro_agent1, "intro_cine_agent", "intro_cine_agent_loop", "stop_intro_loop");
	thread intro_anim_and_loop( level.intro_agent2, "intro_cine_agent2", "intro_cine_agent2_loop", "stop_intro_loop");
	thread intro_anim_and_loop( level.polit_1, "intro_cine_politician1", "intro_cine_politician1_loop", "stop_intro_loop");
	thread intro_polit1_prop();
	thread intro_anim_and_loop( level.polit_2, "intro_cine_politician2", "intro_cine_politician2_loop", "stop_intro_loop");
	
	thread debate_chair_destroy();
	level.president thread debate_chair_anim( "chair1", "intro_chair1" );
	level.advisor thread debate_chair_anim( "chair2", "intro_chair2" );
	level.commander thread debate_chair_anim( "chair3", "intro_chair3" );
	level.secretary thread debate_chair_anim( "chair4", "intro_chair4" );
	level.polit_1 thread debate_chair_anim( "chair5", "intro_chair5" );
	level.polit_2 thread debate_chair_anim( "chair6", "intro_chair6" );
	
	chair8 = GetEnt( "chair8", "targetname" );
	chair8.animname = "conf_chair";
	chair8 setanimtree();
	level.intro_origin anim_first_frame_solo( chair8, "debate_chair8" );
}

intro_anim_and_loop( guy, anime, loopanim, loop_stop_notify )
{
	level.intro_origin anim_single_solo( guy, anime );
	
	if( !flag( "in_guard_position" ))
	{
		level.intro_origin thread anim_loop_solo( guy, loopanim, loop_stop_notify );
		flag_wait( "debate_starting" );
		//guy StopAnimScripted();
	}
	
}

intro_env()
{
	flag_wait( "plane_shake1" );
	rand = randomfloatrange( 0.0, 2.0 );
	wait rand;
	thread hallway_rumble_low();
}

intro_doors()
{
	level.door1 = getent( "intro_door1" , "targetname");
	level.door_rig1 = getent( "intro_door1_rig", "targetname");
	level.door_rig1.animname = "door";
	level.door_rig1 setanimtree();
	
	level.door2 = getent( "intro_door2" , "targetname");
	level.door_rig2 = getent( "intro_door2_rig", "targetname");
	level.door_rig2.animname = "door";
	level.door_rig2 setanimtree();
	
	level.door3 = getent( "intro_door3" , "targetname");
	level.door3 MoveY( 50, .1);
	level.door_rig3 = getent( "intro_door3_rig", "targetname");
	level.door_rig3.animname = "door";
	level.door_rig3 setanimtree();
	
	level.door4 = getent( "intro_door4" , "targetname");
	level.door4 MoveY( 52, .1);
	level.door_rig4 = getent( "intro_door4_rig", "targetname");
	level.door_rig4.animname = "door";
	level.door_rig4 setanimtree();
	
	wait(.2);
	
	level.intro_origin thread anim_first_frame_solo( level.door_rig2, "intro_door2_worker_open" );
	level.door2 linkto( level.door_rig2 , "J_prop_1" );
	
	level.intro_origin thread anim_first_frame_solo( level.door_rig3, "intro_door3_agent_open" );
	level.door3 linkto( level.door_rig3 , "J_prop_1" );
	
	level.intro_origin thread anim_first_frame_solo( level.door_rig4, "debate_cine_door4_blown_off" );
	level.door4 linkto( level.door_rig4 , "J_prop_1" );
	
}

intro_polit1_prop()
{
	pitcher = getEnt( "polit1_pitcher", "script_noteworthy" );
	glass = getEnt( "polit1_glass", "script_noteworthy" );
	
	rig = spawn_anim_model("pitcher");
	waittillframeend;
	
	level.intro_origin anim_first_frame_solo( rig, "intro_cine_pitcher" );
	pitcher linkto( rig , "J_prop_1" );
	glass linkto( rig , "J_prop_2" );
	
	level.intro_origin anim_single_solo( rig, "intro_cine_pitcher" );
	if( !flag( "in_guard_position" ))
	{
		level.intro_origin anim_loop_solo( rig, "intro_cine_pitcher_loop", "stop_intro_loop" );
	}
	
	//flag_wait( "stop_intro_loop" );
	
	pitcher unlink();
	glass unlink();
	rig Delete();
}

intro_close_door3()
{
	//flag_clear( "in_guard_position" );
	flag_wait( "in_guard_position" );
		
	/*while( !flag( "intro_done" ))
	{
		wait(.05);
	}*/
	
	level.door3 unlink();
	wait(.2);
	level.door3 MoveY( 46, 1, 0, .25 );
	aud_send_msg("debate_door_close");
	wait(1);
	
	//level.intro_origin anim_single_solo( level.door_rig3, "intro_door3_agent_close" );
	
	//level.intro_origin anim_single_solo( level.intro_agent1, "intro_cine_agent_close_door" );
	
	if ( isdefined( level.intro_agent1.magic_bullet_shield ) )
		level.intro_agent1 stop_magic_bullet_shield();
		
	level.intro_agent1 delete();
	flag_set( "delete_intro_ambient_guys" );
}

debate_chair_anim(chairname, chairanim)
{
	chair = GetEnt( chairname, "targetname" );
	chair.animname = "conf_chair";
	chair setanimtree();
	level.intro_origin anim_first_frame_solo( chair, chairanim );
	self waittillmatch( "single anim", "swivel_chair" );
	level.intro_origin anim_single_solo( chair, chairanim );
}

debate_chair_destroy()
{
	chair_top = getEnt( "chair_destroy_top", "targetname" );
	chair_bottom = getEnt( "chair_destroy_base", "targetname" );
	
	rig = spawn_anim_model("destroy_chair");
	waittillframeend;
	
	level.intro_origin anim_first_frame_solo( rig, "debate_cine_end_chair" );
	chair_top linkto( rig , "J_prop_1" );
	chair_bottom linkto( rig , "J_prop_2" );
	
	flag_wait( "debate_starting" );
	
	level.intro_origin anim_single_solo( rig, "debate_cine_end_chair" );
	
	chair_top unlink();
	chair_bottom unlink();
	rig Delete();
}

debate_open_first_door(guy)
{
	level.intro_origin anim_single_solo( level.door_rig3, "debate_cine_door3_agent_open" );
}

debate_open_first_door_intro(guy)
{
	level.intro_origin anim_single_solo( level.door_rig3, "intro_door3_agent_open" );
}

debate_close_first_door(guy)
{
	level.intro_origin anim_single_solo( level.door_rig3, "intro_door3_agent_close" );
}

debate()
{
	flag_wait_all( "in_guard_position", "intro_done" );
	waittillframeend;
	thread autosave_by_name( "debate" );
	
	debate_guys = [];
	debate_guys[ 0 ] = level.president;
	//debate_guys[ 1 ] = level.commander;
	debate_guys[ 2 ] = level.advisor;
	debate_guys[ 3 ] = level.secretary;
	debate_guys[ 4 ] = level.hero_agent_01;
	debate_guys[ 5 ] = level.intro_agent2;
	debate_guys[ 6 ] = level.polit_1;
	debate_guys[ 7 ] = level.polit_2;

	level.intro_origin notify( "stop_intro_loop" );
	flag_set( "debate_starting" );
	thread debate_prep_player_gun();
	thread debate_prep_comm_gun();
	thread debate_prep_agent2_gun();
	thread debate_prep_hero_agent_gun();
	aud_send_msg("start_typing");
	level.intro_origin thread anim_single( debate_guys, "debate" );
	level.intro_origin thread anim_single_solo( level.commander, "debate", undefined, .04);//.08
	thread hallway_commander();
	level.president thread debate_chair_anim( "chair1", "debate_chair1" );
	level.advisor thread debate_chair_anim( "chair2", "debate_chair2" );
	level.commander thread debate_chair_anim( "chair3", "debate_chair3" );
	level.secretary thread debate_chair_anim( "chair4", "debate_chair4" );
	level.polit_1 thread debate_chair_anim( "chair5", "debate_chair5" );
	level.polit_2 thread debate_chair_anim( "chair6", "debate_chair6" );
	level.polit_1 thread debate_chair_anim( "chair8", "debate_chair8" );
	
	level.commander PushPlayer(true);
	
	level.president waittillmatch( "single anim", "dialogue02" );  //ps_hijack_prs_worldsafe
	level.president thread dialogue_queue( "hijack_prs_worldsafe" );
	
	level.president waittillmatch( "single anim", "notify_gunshots" );
	//AUDIO LOOK HERE
	aud_send_msg("conf_room_shots");
	aud_send_msg("lets_kick_ass");
	thread debate_hallway_screams();
	thread debate_view_roll();
	thread debate_radio_chatter();
	
	wait(.35);
	level.president scalevolume(0, 0.2);
	
	level.president waittillmatch( "single anim", "notify_explosion" );
	//AUDIO LOOK HERE
	aud_send_msg("conf_room_explosion1");
	aud_send_msg("conf_room_plant_c4");
	thread debate_picture();
	thread debate_rumble();
	
	level.president waittillmatch( "single anim", "playergun_up" );
	thread debate_hijacker_vo();
	
	level.president waittillmatch( "single anim", "notify_chargeplant" );
	flag_set( "conf_explosion" );
	level.lower_radio_org.deleteme = true;
	
	level.president waittillmatch( "single anim", "notify_hijack" );
	//thread hallway_to_zerog();
	thread debate_hijack_start();
	thread debate_advisor_end_loop();
	thread debate_agent2_end_loop();
	thread debate_pres_end_loop();
	thread debate_hero_agent_end_loop();
	thread hallway_plane_lurch();
	//thread hallway_commander();
	thread pre_zerog_behavior();
	
	level.president waittillmatch( "single anim", "notify_rescue" );
	//thread autosave_by_name( "conference_room_breached" );
}

debate_hallway_screams()
{
	hijacker_org = getent( "hijack_screams", "targetname" );
	
	wait(.75);
	hijacker_org playsound( "hijack_fem1_scream", "done1" );
	hijacker_org waittill( "done1" );
	wait(.5);
	hijacker_org playsound( "hijack_fso1_gungun", "done2" );
	hijacker_org waittill( "done2" );
	wait (0.1);

	hijacker_org playsound( "hijack_fso1_pain", "done3" );
	hijacker_org waittill( "done3" );
	wait(.5);
	hijacker_org playsound( "hijack_fso2_lookout", "done4" );
	hijacker_org waittill( "done4" );
}

debate_prep_player_gun()
{
	level.commander waittillmatch( "single anim", "sub_cliff_ru1_hostact" );
	SetSavedDvar( "bg_viewBobAmplitudeBase", level.org_vba_base );
	SetSavedDvar( "bg_viewBobAmplitudeStanding", level.org_vba_standing );
	level.player EnableWeapons();
	level.player allowcrouch( true );
	level.hero_agent_01 gun_recall();
}

debate_prep_comm_gun()
{
	level.commander waittillmatch( "single anim", "pistol_pullout" );
	level.commander gun_recall();
	level.commander forceUseWeapon( level.commander.sidearm, "primary" );
}

debate_prep_agent2_gun()
{
	level.intro_agent2 waittillmatch( "single anim", "pistol_pullout" );
	level.intro_agent2 gun_recall();
	level.intro_agent2 forceUseWeapon( level.intro_agent2.sidearm, "primary" );
}

debate_prep_hero_agent_gun()
{
	level.hero_agent_01 waittillmatch( "single anim", "grab_gun" );
	level.hero_agent_01 gun_recall();
	//level.hero_agent_01 forceUseWeapon( level.intro_agent2.sidearm, "primary" );
}

debate_hijacker_vo()
{
	hijacker_org = getEnt( "door_breach", "targetname" );
	
	//This is the door. Place the charge!
	hijacker_org playsound( "hijack_hj1_placecharge", "done1" );
	hijacker_org waittill( "done1" );
	//Come on! Work faster!// - turned off D.Blondin
	//hijacker_org playsound( "hijack_hj1_workfaster", "done2" );
	//hijacker_org waittill( "done2" );
	wait ( 0.2 );
	//Done, stand back.
	hijacker_org playsound( "hijack_hj2_standback", "done3" );
	hijacker_org waittill( "done3" );
	//Detonating in 3 ... 2 ... 1 ...// - turned off D.Blondin
	//hijacker_org playsound( "hijack_hj2_detonating", "done4" );
	//hijacker_org waittill( "done4" );
}

debate_rumble()
{
	aud_send_msg("rumble");
	
	//flag_set("stop_rocking");
	earthquake( .22, 4.5, level.player.origin, 80000 );
	level.player PlayRumbleOnEntity( "hijack_plane_medium" );
	thread debate_rumble_lights();
	aud_send_msg("seatbeltsign");
	aud_send_msg("rumble_foley");
	foreach( obj in level.seatbeltsigns )
	{
		obj show();
	}
	
	thread debate_lurch_props();
	
	//setPhysicsGravityDir( (0, -.5, -.1) );
	physicspush = GetEntArray( "conf_room_physics", "targetname" );
	foreach (object in physicspush)
	{
		PhysicsExplosionSphere( object.origin, 64, 32, .6);
	}
	objects = GetEntArray("conf_room_junk","targetname");
	foreach (object in objects)
	{
		object thread launch_object( RandomIntRange(120,170),( 0 , -1 , .05 ));
	}
	thread debate_paper_chaos();
	
	level.player DisableWeapons();
	distance_player_to_commander = Distance(level.player.origin,level.commander.origin);
	if ( distance_player_to_commander > 50 )
	{
		level.custom_linkto_slide = true;
		angles = ( 7, 270, 0 );
	
		forward = AnglesToForward( angles );
		level.player SetVelocity( forward * 100 );
		level.player hjk_BeginSliding();
	
		wait(0.6);
		level.player hjk_EndSliding();
	}
	else
	{
		wait(0.6);
	}
	setPhysicsGravityDir( (0, 0, -1) );
	
	wait(1.5);
	level.player EnableWeapons();

	wait(1);
	thread hallway_picture_fall(); //setting up picture for next hallway.
}

debate_view_roll()
{
	wait(8.13);
	//flag_set("stop_rocking");
	level notify("stop_rocking");
	array_thread( level.aRollers, ::debate_view_roll_obj);
	view_roller = spawn_anim_model( "conf_roller", level.player.origin);
	view_roller.angles = (0, 0, 0);
	player_ref = spawn( "script_origin", level.player.origin );
	player_ref.angles = (0, 0, 0);
	
	level.player playerSetGroundReferenceEnt( player_ref );
	view_roller anim_first_frame_solo( view_roller, "debate_cine_lurchcam" );
	player_ref linkto( view_roller , "J_prop_1" );
	view_roller anim_single_solo( view_roller, "debate_cine_lurchcam" );
	
	level.player playerSetGroundReferenceEnt( level.org_view_roll );
	thread RockingPlane();
	
	player_ref delete();
	view_roller delete();	
}

debate_lurch_props()
{
	//OPEN LAPTOP
	debate_laptop_on = getEnt( "debate_laptop", "targetname" );
	debate_laptop_on delete();
	level.debate_laptop_off show();
	level.debate_laptop_off.animname = "debate_laptop";
	level.debate_laptop_off setanimtree();
	level.intro_origin thread anim_single_solo( level.debate_laptop_off, "debate_laptop_lurch" );
	
	//PHONES
	level.intro_origin thread anim_single_solo( level.conf_phone_1, "debate_phone1_lurch" ); //defined in intro_conf_room()
	
	phone_2 = getEnt( "conf_phone2", "targetname" );
	phone_2.animname = "phone";
	phone_2 setanimtree();
	level.intro_origin thread anim_single_solo( phone_2, "debate_phone2_lurch" );
	
	//TABLETS AND CLOSED LAPTOP
	tablet1 = getEnt( "conf_room_tablet1", "targetname" );
	tablet2 = getEnt( "conf_room_tablet2", "targetname" );
	laptop2 = getEnt( "conf_room_closed_laptop", "targetname" );
	
	front_rig = spawn_anim_model("debate_prop");
	level.intro_origin thread anim_first_frame_solo( front_rig, "debate_props_frnt_lurch" );
	back_rig = spawn_anim_model("debate_prop");
	level.intro_origin thread anim_first_frame_solo( back_rig, "debate_props_bck_lurch" );

	lap2_origin = front_rig GetTagOrigin( "J_prop_1" );
	lap2_angles = front_rig GetTagAngles( "J_prop_1" );
	tab1_origin = front_rig GetTagOrigin( "J_prop_2" );
	tab1_angles = front_rig GetTagAngles( "J_prop_2" );
	tab2_origin = back_rig GetTagOrigin( "J_prop_1" );
	tab2_angles = back_rig GetTagAngles( "J_prop_1" );
	
	laptop2.origin = lap2_origin;
	laptop2.angles = lap2_angles;

	tablet1.origin = tab1_origin;
	tablet1.angles = tab1_angles;

	tablet2.origin = tab2_origin;
	tablet2.angles = tab2_angles;

	laptop2 linkto( front_rig, "J_prop_1" );
	tablet1 linkto( front_rig, "J_prop_2" );
	tablet2 linkto( back_rig, "J_prop_1" );

	level.intro_origin thread anim_single_solo( front_rig, "debate_props_frnt_lurch" );
	level.intro_origin thread anim_single_solo( back_rig, "debate_props_bck_lurch" );
}
	
debate_radio_chatter()
{
	level endon( "conf_explosion" );

	wait(7.5);
	
	level.lower_radio_org = spawn( "script_origin", level.player.origin );
	level.lower_radio_org linkto( level.player );
	level.lower_radio_org.linked = true;
	
	background_chatter( "hijack_fso1_needbackup", level.lower_radio_org );
	wait (0.7);
	background_chatter( "hijack_fso2_gunshots", level.lower_radio_org );
	wait (1.1);
	background_chatter( "hijack_fso3_weaponsfree", level.lower_radio_org );
	wait (0.1);
	background_chatter( "hijack_fso2_alert", level.lower_radio_org );
}

debate_view_roll_obj()
{
	view_roller = spawn_anim_model( "conf_roller", self.origin);
	view_roller.angles = (0, 0, 0);
	
	view_roller anim_first_frame_solo( view_roller, "debate_cine_lurchcam" );
	self linkto( view_roller , "J_prop_1" );
	view_roller anim_single_solo( view_roller, "debate_cine_lurchcam" );

	self unlink();
	view_roller delete();
	
}

debate_paper_chaos()
{
	papers = GetEntArray("conf_room_paper", "targetname" );
	foreach (paper in papers)
	{
		ent = spawn_tag_origin();
		ent.origin = paper.origin;
		ent.angles = (-5, 270, 0);
		PlayFXOnTag(getfx("paper_flutter"), ent, "tag_origin");
		paper delete();
	}
	paper_piles = GetEntArray("conf_room_paper_pile", "targetname" );
	foreach (pile in paper_piles)
	{
		ent = spawn_tag_origin();
		ent.origin = pile.origin;
		ent.angles = (-5, 270, 0);
		PlayFXOnTag(getfx("paper_pile_flutter"), ent, "tag_origin");
		pile delete();
	}
	flag_wait("door_breach");
	breach_papers = GetEntArray("conf_room_paper_breach", "targetname" );
	foreach (page in breach_papers)
	{
		ent = spawn_tag_origin();
		ent.origin = page.origin;
		ent.angles = (-35, 250, 0);
		PlayFXOnTag(getfx("paper_flutter"), ent, "tag_origin");
		page delete();
	}
}

debate_picture()
{
	picture = GetEnt( "conf_picture", "targetname" );
	picture add_target_pivot();
	picture_pivot = picture.pivot;
	
	rollang = 110;
	ang_dec = .75;
	t = .75;

	for( i=0; i<13; i++ )
	{
		picture_pivot RotateRoll( rollang, t, t*(1/3), t*(2/3));
		wait t;
		rollang = -1 * rollang * ang_dec;
		t = t * .95;
	}
	picture Unlink();
	
	flag_wait("door_breach");
	picture PhysicsLaunchServer( picture.origin , (-1, -.3, .05) );
}

debate_rumble_lights()
{
	light1 = getEnt( "conf_room_spot1", "targetname" ); //intensity 1.2
	light2 = getEnt( "conf_room_spot2", "targetname" ); //intensity 1.2
	fixture1_on = getEnt( "conf_light1_on", "script_noteworthy" );
	fixture1_off = getEnt( "conf_light1_off", "script_noteworthy" );
	
	for( i=0; i<10; i++ )
	{
		light1 SetLightIntensity( 0 );
		light2 SetLightIntensity( 0 );
		fixture1_on hide();
		fixture1_off show();
		wait randomfloatrange( 0.05, 0.1 ); // ~0.075 
		rand_intensity = randomfloatrange( 0.5, 1.2 );
		light1 SetLightIntensity( rand_intensity );
		light2 SetLightIntensity( rand_intensity );
		fixture1_on show();
		fixture1_off hide();
		wait randomfloatrange( 0.1, 0.2 ); // ~0.15
	}
	light1 SetLightIntensity( 1.2 );	
	light2 SetLightIntensity( 1.2 );	
}

#using_animtree( "generic_human" );
debate_hijack_start()
{
	thread debate_player_react();
	flag_set("door_breach");
	kill_tv = GetEnt( "tv_destructor", "targetname" );
	kill_tv2 = GetEnt( "tv_destructor2", "targetname" );
	MagicBullet( "ak74u", kill_tv.origin, kill_tv2.origin);
	Earthquake( 0.3, 5.0, level.player.origin, 6000 );
	breach_org = getent( "door_breach", "targetname" );
	level.player PlayFX( getfx("conference_room_breach"), breach_org.origin, anglestoforward((0,0,0)));
	level.door4 delete();
	
	breach_physics = GetStructArray("breach_physics", "targetname" );
	foreach(obj in breach_physics)
	{
		radius = obj.radius;
		mag = 0.65;
		PhysicsExplosionCylinder(obj.origin, radius, radius, mag);
	}
		
	//AUDIO LOOK HERE
	aud_send_msg("conf_room_explosion2");
	
	hijacker1 =  spawn_targetname( "conf_hijacker1" );
	hijacker1.animname = "generic";
	hijacker1.ignoreme = true;
	hijacker1.ignoreall = true;
	hijacker1.allowdeath = true;
	hijacker1.ragdoll_immediate = true;
	hijacker1 PushPlayer(true);
	hijacker1 magic_bullet_shield();
	
	hijacker2 =  spawn_targetname( "conf_hijacker2" );
	hijacker2.animname = "generic";
	hijacker2.ignoreme = true;
	hijacker2.ignoreall = true;
	hijacker2.allowdeath = true;
	hijacker2.ragdoll_immediate = true;
	hijacker2 PushPlayer(true);
	hijacker2 magic_bullet_shield();
	
	level.secretary thread debate_scripted_die();
	level.polit_1 thread debate_scripted_polit_die("debate_cine_politician1_death_loop");
	level.polit_2 thread debate_scripted_polit_die("debate_cine_politician2_death_loop");
	
	level.intro_origin thread anim_single_solo( hijacker1, "debate_cine_hijacker1_breach" );
	hijacker1 thread debate_hijacker1_fx();
	hijacker1 thread debate_scripted_die();
	hijacker1 thread debate_hijacker1_gun();
	level.intro_origin thread anim_single_solo( hijacker2, "debate_cine_hijacker2_breach" );
	hijacker2 thread debate_scripted_die();
	hijacker2 thread debate_hijacker2_gun();
	
	level.commander thread debate_commander_fx(hijacker1, hijacker2);
	
	level.commander waittillmatch( "single anim", "dropgun" );
	level.commander.dropWeapon = true;
	level.commander animscripts\shared::DropAIWeapon();
	//level.commander DropWeapon( self.weapon, "right", 2.0);
	
	hijacker3 =  spawn_targetname( "conf_hijacker3" );
	hijacker3 set_fixednode_true();
	hijacker3.health = 1;
	hijacker3.deathanim = level.scr_anim[ "generic" ][ "stand_death_shoulder_spin" ];
	
	level.commander waittillmatch( "single anim", "swap_guns" );
	level.commander forceUseWeapon( "ak74u", "primary" );
	level.commander.lastWeapon = level.commander.weapon;	// needed to avoid errors later
	hijacker1 gun_remove();

	hijacker1 waittillmatch( "single anim", "pistol_pullout" );
	hijacker1 forceUseWeapon( "fnfiveseven", "primary" );
	//hijacker1 HidePart( "tag_silencer", "fnfiveseven" );
	hijacker1 maps\_shg_common::update_weapon_tag_visibility( hijacker1.primaryweapon );
	
	flag_wait( "kill_hijacker3" );
	ent = getEnt( "door_breach", "targetname" );
	bullet = getstruct( "bullet_behind", "targetname" );
	if( IsAlive( hijacker3))
		{
		if( player_looking_at( ent.origin ))
		{
			MagicBullet( "ak74u", bullet.origin, hijacker3.origin+(0,0,42));
		}
		else
		{
			MagicBullet( "ak74u", ent.origin, hijacker3.origin+(0,0,42));
		}
	}
}

debate_commander_fx(hijacker1, hijacker2)
{
	body_impact_fx = getfx("flesh_hit_body_fatal_exit");
	
	self waittillmatch("single anim", "fire");	// miss
	self waittillmatch("single anim", "fire");	// hit1 hijacker2
	PlayFXOnTag(body_impact_fx, hijacker2, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// hit2 hijacker2
	PlayFXOnTag(body_impact_fx, hijacker2, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// hit3 hijacker2
	PlayFXOnTag(body_impact_fx, hijacker2, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// hit4 hijacker2
	PlayFXOnTag(body_impact_fx, hijacker2, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// hit5 hijacker2
	PlayFXOnTag(body_impact_fx, hijacker2, "tag_weapon_chest" );	
	
	self waittillmatch("single anim", "fire");	// hit1 hijacker1
	PlayFXOnTag(body_impact_fx, hijacker1, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// hit2 hijacker1
	PlayFXOnTag(body_impact_fx, hijacker1, "tag_weapon_chest" );
}

debate_hijacker1_fx()
{
	body_impact_fx = getfx("flesh_hit_body_fatal_exit");
	
	self waittillmatch("single anim", "fire");	// miss
	self waittillmatch("single anim", "fire");	// hit politician 1 in head
	PlayFXOnTag(body_impact_fx, level.polit_1, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// miss
	self waittillmatch("single anim", "fire");	// hit secretary in head
	PlayFXOnTag(body_impact_fx, level.secretary, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// miss
	self waittillmatch("single anim", "fire");	// hit advisor in shoulder
	PlayFXOnTag(body_impact_fx, level.advisor, "tag_weapon_chest" );
	self waittillmatch("single anim", "fire");	// miss
	self waittillmatch("single anim", "fire");	// hit politician 2 in chest
	PlayFXOnTag(body_impact_fx, level.polit_2, "tag_weapon_chest" );
}

#using_animtree( "generic_human" );
debate_hijacker1_gun()
{
	hijackerAnim = %hijack_debate_cine_hijacker1_breach;
	animlength = GetAnimLength( hijackerAnim );
	notetrack = GetNotetrackTimes( hijackerAnim, "start_ragdoll" )[0];
	time = (animlength * notetrack);

	wait(time - .1);
	self animscripts\shared::DropAIWeapon();
}

#using_animtree( "generic_human" );
debate_hijacker2_gun()
{
	hijackerAnim = %hijack_debate_cine_hijacker2_breach;
	animlength = GetAnimLength( hijackerAnim );
	notetrack = GetNotetrackTimes( hijackerAnim, "start_ragdoll" )[0];
	time = (animlength * notetrack);

	wait(time - .5);
	self animscripts\shared::DropAIWeapon();

	flag_set( "kill_hijacker3" );

}

debate_player_react()
{
	flag_clear( "player_away_from_door" );
	wait(.05);
	move_player = getstruct( "player_slide_location", "targetname" );
	move_player.origin = ( move_player.origin[0], move_player.origin[1], level.player.origin[2]);
		
	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	
	level.player ShellShock( "hijack_door_explosion", 5);
	level.player DisableWeapons();
	level.player FreezeControls( true );	
	
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	player_rig.angles = level.player.angles;
	//level.player PlayerLinkToAbsolute( player_rig, "tag_player");
	level.player PlayerLinkTo( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	player_rig thread anim_single_solo( player_rig, "debate_react_player");
	wait(.05);
	
	if( flag( "player_away_from_door" ))
	{
		temp_ent = spawn_tag_origin();
		temp_ent.origin = player_rig.origin;
		temp_ent.angles = player_rig.angles;
		player_rig linkto( temp_ent );
		temp_ent MoveTo( (-28436, 12728, level.player.origin[2]), .25, 0, .1 ); //move_player.origin
	}
	
	player_rig waittillmatch( "single anim", "end" );
	
	level.player FreezeControls( false );	
	level.player Unlink();
	player_rig Delete();
		
	wait(1.3);
	
	level.player enableWeapons();
	level.player blend_movespeedscale(.85, 5);
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	//level.player AllowJump( true );	
	
	thread hallway_nag1();
}

debate_scripted_die()
{
	self endon("death");
	
	self.noragdoll = 1;
	self.a.nodeath = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self.diequietly = true;
	self waittillmatch( "single anim", "start_ragdoll" );
	if(IsDefined( self.magic_bullet_shield ))
	{	
		self stop_magic_bullet_shield();
	}
	self kill();
}

debate_scripted_polit_die(animloop)
{
	self endon("death");
	
	self.noragdoll = 1;
	self.a.nodeath = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self waittillmatch( "single anim", "end" );
	if(IsDefined( self.magic_bullet_shield ))
	{	
		self stop_magic_bullet_shield();
	}
	level.intro_origin thread anim_loop_solo( self, animloop );
	self InvisibleNotSolid();
}

debate_advisor_end_loop()
{
	level.advisor waittillmatch( "single anim", "end" );
	level.intro_origin thread anim_loop_solo( level.advisor, "debate_cine_advisor_end_loop", "stop_debate_advisor_loop" );
}

debate_pres_end_loop()
{
	level endon("zero_g_trig");
	level.president waittillmatch( "single anim", "end" );
	//if( !flag( "hero_agent_stumble" ))
	//{
		level.intro_origin thread anim_loop_solo( level.president, "debate_cine_president_end_loop", "stop_pres_debate_loop" );
	//}
}

debate_hero_agent_end_loop()
{
	level endon("zero_g_trig");
	level.hero_agent_01 waittillmatch( "single anim", "end" );
	//if( !flag( "hero_agent_stumble" ))
	//{
		level.intro_origin thread anim_loop_solo( level.hero_agent_01, "debate_cine_hero_agent_end_loop", "stop_pres_debate_loop" );
	//}
}

debate_agent2_end_loop()
{
	level endon("zero_g_trig");
	
	level.intro_agent2 waittillmatch( "single anim", "end" );

	if(isAlive( level.intro_agent2 ) && IsDefined( level.intro_agent2 ))
	{	
		level.intro_origin thread anim_loop_solo( level.intro_agent2, "debate_cine_agent2_end_loop", "stop_debate_loop" );
	}
}

debate_status_vo()
{
	//wait(5.3);
	wait(7.25);
	//Status report.
	//level.commander dialogue_queue( "hijack_cmd_statreport" );

	//They have the daughter in the cargo bay.
	//radio_dialogue( "hijack_fso3_theyhave" );

	//...in the cockpit...heavy resistance...
	radio_dialogue( "hijack_fso2_resistance" );
	
	wait(.5);
	aud_send_msg("failing_engine");
	wait(1);
	//...losing control...
	radio_dialogue( "hijack_plt_losingcontrol" );

	//wait(1.5);
	wait(1.1); //jz - reducing to try and fit it during hallway
	//...engines 2 and 3 have stalled!
	radio_dialogue( "hijack_plt_stalled" );
	
}

intro_tv_off()
{
	level.secretary waittillmatch( "single anim", "trigger_tv" );
	flag_set( "tv_off" );
	aud_send_msg("stop_news");
	StopCinematicInGame();
	
	level.secretary waittillmatch( "single anim", "drop_remote" );
	
	level.remote Unlink();
	//level.remote PhysicsLaunchClient( level.secretary.origin, ( 0, 0, -.001 ));
	
	//level.secretary detach( "electronics_pda", "tag_inhand" );
	thread intro_close_door3(); //ensuring President is in room before door will close.
	
}

screen_movies()
{
	//level endon( "tv_off" );
	wait( 1 );
	SetSavedDvar( "cg_cinematicFullScreen", "0" );

	thread map_movies();
	
	while ( 1 )
	{
		flag_clear("tv_video_on");
		flag_wait("tv_video_on"); //need to rewrite this so map goes back on if you cross the tv off trigger
		thread tv_movies();
		
		flag_clear("map_video_on");
		flag_wait("map_video_on");
		thread map_movies();		
	}
}

map_movies()
{
	wait(.05);
	level endon( "tv_video_on" );
	//level endon( "tv_video_off" );
	SetSavedDvar( "cg_cinematicFullScreen", "0" );
	while ( 1 )
	{
		start_movie_loop(0);
	}
}

/*--TV Monitor--*/
tv_movies()
{  
	wait(.05);
	level endon( "tv_off" );
	//level endon( "tv_video_off" );
	level endon( "map_video_on" );
	if( flag( "tv_off" ))
	{
		StopCinematicInGame();
		flag_set( "kill_movie" );
		wait(.05);
		flag_clear( "kill_movie" );
		return;
	}
	SetSavedDvar( "cg_cinematicFullScreen", "0" );
	while ( 1 )
	{
		start_movie_loop(1);
	}
}

start_movie_loop(num)
{
	level endon( "tv_off" );
	level endon( "kill_movie" );
	while ( 1 )
	{
		//num = RandomIntRange( 0, 2 );
		switch(num)	
		{
			case 0:
				CinematicInGame( "hijack_map_black" ); //ny_manhattan_tvanamorphic
				wait(.05);
				while ( IsCinematicPlaying() )
				{
					wait( .05 );
				}
				break;
			case 1:
				CinematicInGame( "ny_manhattan_tvanamorphic" );
				wait(.05);
				while ( IsCinematicPlaying() )
				{
					wait( .05 );
				}
				break;
			default:
				break;
		}
	}	
}

/*---------------------------------------------------
	
	      END - President's Office, Hallway, Conf Room
	
----------------------------------------------------*/
/*---------------------------------------------------
	
	       Hallway to Zero-G
		
----------------------------------------------------*/
#using_animtree( "generic_human" );
hallway_commander()
{
	thread hallway_jet_flyby();
	
	level.commander enable_cqbwalk();
	level.commander.disableexits = true;
	//level.commander.disablearrivals = true;
	
	//---Wait until commander finishes killing hijackers
	//level.commander waittillmatch( "single anim", "end" );
	
	//---Have to wait animtime rather because "single anim" "end" won't fire if you use a blend out.
	commanderAnim = %hijack_debate_cine_commander;
	animlength = GetAnimLength( commanderAnim );
	
	wait(animlength - 5);

	aud_send_msg("pre_turbulence_ready");
	//iprintln("PRE_TURB_READY");
	
	flag_clear( "hero_agent_stumble" );	
	flag_set( "move_pres" );
	battlechatter_on( "axis" );
	level.hero_agent_01 enable_ai_color_dontmove();
	level.president enable_ai_color_dontmove();

	//level.commander.movespeedscale = .75;
	//level.commander set_moveplaybackrate(.75);
	level.commander.turnrate = .1;
	level.commander.dontEverShoot = true;
	level.commander AllowedStances( "stand" );
	level.commander.disableReload = true;
		
	//---If player is somewhere in room, path to hall and wait.  
	//---If player is right at the door, go right into stumble.
		
	if (!flag( "hero_agent_stumble"))
	{
		zerog_origin = getstruct( "all_plane_origin", "targetname" );
		zerog_origin anim_reach_solo( level.commander, "hero_stumble" );
		
		//level.commander anim_loop_solo( level.commander, "cqb_stand_aim5", "stop_cmd_loop" );
		
		//level.commander.goalradius = 8;
		//hallway_node = GetNode( "commander_hallway_node1", "targetname" );
		//level.commander setgoalnode( hallway_node );
	}

	thread autosave_by_name( "conference_room_breached" );
	
	
	//---If player is following, move towards stumble.  
	
	flag_wait( "hero_agent_stumble" );
	thread debate_status_vo();
		
	level.commander.disableexits = false;
	//level.commander.disablearrivals = false;
	//level.commander.movespeedscale = 1;
	level.commander.turnrate = .3;
	//level.commander set_moveplaybackrate(1.0);
	
	level.intro_origin notify( "stop_corner_loop" );
	waittillframeend;

	
	//---If player is behind, do stumble.
	//---If player is ahead, skip stumble.
	
	zerog_origin = getstruct( "all_plane_origin", "targetname" );
	zerog_origin anim_reach_solo( level.commander, "hero_stumble" );
	level.commander.goalradius = 16;
	prezero_node = GetNode( "commander_zerog", "targetname" );
	level.commander setgoalnode( prezero_node );
	level.commander.dontEverShoot = undefined;
	if (!flag( "player_ahead"))
	{
		flag_set( "cmdr_stumbling" );
		zerog_origin thread anim_single_run_solo( level.commander, "hero_stumble" );
		aud_send_msg ("hijk_agent_stumblehit");
	}
	level.commander AllowedStances( "stand", "crouch" );
	level.commander.disableReload = undefined;
}

hallway_nag1()
{
	level endon( "hero_agent_stumble" );
	
	while( !flag( "hero_agent_stumble" ))
	{
		wait(12);
		level.commander dialogue_queue( "hijack_cmd_onme" );
	}
}

hallway_jet_flyby()
{
	flag_wait( "go_jets3" );
	wait(2);
	level.jet_3a = spawn_vehicle_from_targetname_and_drive( "mig_3a" );
	level.jet_3b = spawn_vehicle_from_targetname_and_drive( "mig_3b" );
	// disable rumble for the migs for the fly in
	level.jet_3a vehicle_kill_rumble_forever();
	level.jet_3b vehicle_kill_rumble_forever();
	
	level.jet_3a thread hide_jet_parts();
	level.jet_3b thread hide_jet_parts();
	
	//jets3 = spawn_vehicles_from_targetname_and_drive( "migs_c" );
	// disable rumble for the migs for the fly in
	//foreach (jet3 in jets3)
	//{
	//	jet3 vehicle_kill_rumble_forever();
	//}
}
	
hallway_plane_lurch()
{
	//level endon( "stop_constant_shake" );
	level.hallway_roller = spawn_anim_model( "upperhall_roller", level.player.origin);
	level.hallway_roller.angles = (0, 0, 0);
	
	flag_wait_any( "player_ahead", "cmdr_stumbling" );
	//flag_set("stop_rocking");
	level notify("stop_rocking");
	
	thread hallway_props();
	
	player_ref = spawn( "script_origin", level.player.origin );
	player_ref.angles = (0, 0, 0);
	
	level.player playerSetGroundReferenceEnt( player_ref );
	thread set_grav( player_ref );
	level.hallway_roller anim_first_frame_solo( level.hallway_roller, "hallway_lurchcam" );
	player_ref linkto( level.hallway_roller , "J_prop_1" );
	
	if(!flag("pre_zerog_checkpoint"))
	{
		aud_send_msg("hallway_lurch", true);
		
		level.player PlayRumbleOnEntity( "hijack_plane_medium" );
		level.hallway_roller thread anim_single_solo( level.hallway_roller, "hallway_lurchcam" );
		
		level.hallway_roller waittillmatch( "single anim", "corpse_slump");
		thread hallway_sun();
		thread hallway_player_slide();
		array_thread( level.aRollers, ::hallway_view_roll_obj);
		
		level.hallway_roller waittillmatch( "single anim", "end");
	}
	
	//flag_set("stop_rocking");
	level notify("stop_rocking");
	   
	if(!flag("zero_g_trig"))
	{
		aud_send_msg("rumble");
		level.hallway_roller anim_loop_solo( level.hallway_roller, "hallway_lurchcam_loop", "stop_hallway_shake" );
	}
	
	// shouldn't need this because zero-g sets a new groundRefEnt
	//level.player playerSetGroundReferenceEnt( level.org_view_roll );
	
	player_ref delete();
	level.hallway_roller delete();	
	
	/*wait(1.8);
	level.player PlayRumbleOnEntity( "hijack_plane_medium" );
	aud_send_msg("rumble");
	thread turbulence( 3 );

	wait(3);
	thread constant_rumble();*/
}

hallway_view_roll_obj()
{
	view_roller = spawn_anim_model( "upperhall_roller", self.origin);
	view_roller.angles = (0, 0, 0);
	
	view_roller anim_first_frame_solo( view_roller, "hallway_godraycam" );
	self linkto( view_roller , "J_prop_1" );
	view_roller thread anim_single_solo( view_roller, "hallway_godraycam" );

	view_roller waittillmatch( "single anim", "roll_right");
	flag_set( "hallsun_right" );
	
	view_roller waittillmatch( "single anim", "roll_left");
	flag_set( "hallsun_left" );
	
	view_roller waittillmatch( "single anim", "roll_right2");
	flag_set( "hallsun_right2" );
	
	view_roller waittillmatch( "single anim", "roll_left2");
	flag_set( "hallsun_left2" );
	
	view_roller waittillmatch( "single anim", "end");
	self unlink();
	view_roller delete();
}

hallway_sun()
{
	LerpSunAngles( level.orig_sundirection, (-38.8, 121.9, 16.7) , 1.5, 0, .2);
	
	flag_wait( "hallsun_right" );
	LerpSunAngles( (-38.8, 121.9, 16.7), (-9.9, 113.4, -2.2) , 1.7, .3, .2);
	
	flag_wait( "hallsun_left" );
	LerpSunAngles( (-9.9, 113.4, -2.2), (-17.5, 114.6, 2.0), 0.8, .1, .1);
	
	flag_wait( "hallsun_right2" );
	LerpSunAngles( (-17.5, 114.6, 2.0), (-13.5, 114, -0.5), 0.7, .1, .1);
	
	flag_wait( "hallsun_left2" );
	LerpSunAngles( (-13.5, 114, -0.5), level.orig_sundirection, .25, 0, .1); 
	
	flag_clear( "hallsun_right" );
	flag_clear( "hallsun_left" );
	flag_clear( "hallsun_right2" );
	flag_clear( "hallsun_left2" );
}

hallway_player_slide()
{
	wait(1.25);
	angles = ( 0, 90, 0 );
	forward = AnglesToForward( angles );
	level.player SetVelocity( forward * 100 );
	level.player hjk_BeginSliding();
	wait(1.5);
	level.player hjk_EndSliding();
}

hallway_picture_fall()
{
	script_origin = getstruct( "all_plane_origin", "targetname" );
	picture = getEnt( "hallway_floor_painting", "targetname" );
	
	picture_rig = spawn_anim_model( "upperhall_cabinet" );
	waittillframeend;
	
	script_origin thread anim_first_frame_solo( picture_rig, "hallway_picture_fall" );
	
	org = picture_rig GetTagOrigin( "J_prop_2" );
	angles = picture_rig GetTagAngles( "J_prop_2" );
	temp_x = -1 * angles[0];
	temp_y = 180 + angles[1];
	angles = ( temp_x, temp_y, angles[2]);
	
	picture.origin = org;
	picture.angles = angles; // + (0, 180, 0);
	
	picture linkto( picture_rig, "J_prop_2" );
	
	flag_wait_any( "player_ahead", "cmdr_stumbling" );
	
	if(!flag("pre_zerog_checkpoint"))
	{
		script_origin anim_single_solo( picture_rig, "hallway_picture_fall" );
		script_origin anim_last_frame_solo( picture_rig, "hallway_picture_fall" );
	}
	
	flag_wait( "zero_g_trig" );
	
	picture_rig Delete();
}

hallway_props()
{
	origin = getstruct( "all_plane_origin", "targetname" );
	cabinet = getEnt( "hallway_cabinet_door", "targetname" );
	
	cabinet_rig = spawn_anim_model( "upperhall_cabinet", cabinet.origin);
	cabinet_rig.angles = (0, 0, 0);
	
	waittillframeend;
	origin thread anim_first_frame_solo( cabinet_rig, "hallway_cabinet_open" );
		
	cabinet linkto( cabinet_rig, "J_prop_1" );
		
	/*physics = GetEntArray("upperhall_physics", "targetname" );
	foreach(object in physics)
	{
		radius = object.radius;
		mag = object.script_delay;
		PhysicsExplosionSphere(object.origin, radius , radius * .5, mag);
	}*/
	
	if(!flag("pre_zerog_checkpoint"))
	{
		origin anim_single_solo( cabinet_rig, "hallway_cabinet_open" );
	}
	origin anim_loop_solo( cabinet_rig, "hallway_cabinet_loop", "end_cabinet_loop" );
	
	flag_wait( "zero_g_trig" );
	
	level notify( "end_cabinet_loop" );
	cabinet_rig Delete();

}

constant_rumble()
{
	level endon( "stop_constant_shake" );
	while ( true )
	{
		earthquake( .09, .05, level.player.origin, 200 );
		wait( .05 );
	}
}

hallway_carnage()
{
	flag_wait( "cansee_zerog_room" );
	
	//putting this here because I know the player can't see the agent:
	if(IsDefined(level.intro_agent2))
	{
	level.intro_agent2 forceUseWeapon( "ak74u", "primary" );
	}
	dying_agent1 =  spawn_targetname( "dying_agent1" );
	dying_agent1.animname = "generic";
	dying_agent1 gun_remove();
	dying_agent1.health = 1;
	dying_agent1.ignoreExplosionEvents = true;
	dying_agent1.ignoreme = true;
	dying_agent1.ignoreall = true;
	dying_agent1.IgnoreRandomBulletDamage = true;
	dying_agent1.grenadeawareness = 0;
	dying_agent1.no_pain_sound = true;
	dying_agent1.noragdoll = 1;
	dying_agent1.a.nodeath = true;
	
	add_cleanup_ent( dying_agent1, "pre_zerog_guys" );
	
	dying_agent1 force_crawling_death( dying_agent1.angles[ 1 ], 2, level.scr_anim[ "crawl_death_1" ], 1 );

	dying_agent1 DoDamage( 1, dying_agent1.origin + ( 16, 0, 16 ));
	
	if(IsDefined(level.zerog_agent_01))
	{
		level.zerog_agent_01 thread maps\hijack::player_damage_to_friendlies();
	}
		
	if(IsDefined(level.zerog_agent_02))
	{
		level.zerog_agent_02 thread maps\hijack::player_damage_to_friendlies();
	}
	
	if(IsDefined(level.zerog_agent_03))
	{
		level.zerog_agent_03 thread maps\hijack::player_damage_to_friendlies();
	}
}

hallway_dead_civilians(loop_anim, slump_anim)
{
	eNode = getstruct( "all_plane_origin", "targetname" );

	self.allowdeath = true;
	self.animname = "generic";
	self.health = 1;
	self.noragdoll = 1;
	self.no_pain_sound = true;
	self.diequietly = true;
	self.a.nodeath = true;
	self.delete_on_death = false;
	self.NoFriendlyfire = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self.dontEverShoot = true;
	self gun_remove();
	self no_grenades();
	self InvisibleNotSolid();
	
	eNode thread anim_loop_solo( self, loop_anim, "dead_guys_loop" );

	level.hallway_roller waittillmatch( "single anim", "corpse_slump");
	eNode anim_single_solo( self, slump_anim );
	//wait(.5);
	self kill();
}

/*---------------------------------------------------
	
	       END - Hallway to Zero-G
	
----------------------------------------------------*/

/*---------------------------------------------------
	
	                 Zero_G
	
----------------------------------------------------*/
pre_zerog_behavior()
{

	//Characters present - President, Commander, Hero Agent, Player, 3 agents , 5 terrorists.
	//Zero-G Characters - Player, 2 agents, 5 terrorists.
	dead_assistant = spawn_targetname( "dead_assistant" );
	dead_assistant thread hallway_dead_civilians("hallway_dead_pose_assistant", "hallway_slump_assistant");
	dead_agent = spawn_targetname( "dead_agent" );
	dead_agent thread hallway_dead_civilians("hallway_dead_pose_agent", "hallway_slump_agent");
	dead_terrorist = spawn_targetname( "dead_terrorist" );
	dead_terrorist thread hallway_dead_civilians("hallway_dead_pose_terrorist", "hallway_slump_terrorist");
	
	//level.player.ignoreme = true;
	level.hero_agent_01.ignoreme = true;
	level.hero_agent_01.ignoreall = true;
	//President and Commander already have ignores from spawning.
	
	level.zerog_agent_01 = spawn_ally("zerog_agent_01");
	level.zerog_agent_02 = spawn_ally("zerog_agent_02");
	
	agent1_node = GetNode( "agent1_prezero_cover2", "targetname" );
	level.zerog_agent_01 setgoalnode( agent1_node );
	
	agent2_node = GetNode( "agent2_prezero_cover2", "targetname" );
	level.zerog_agent_02 setgoalnode( agent2_node );
	
	level.zerog_agent_03 = spawn_targetname( "zerog_agent_03" );
	level.zerog_agent_03 thread magic_bullet_shield();
	level.zerog_agent_03 no_grenades();
	level.zerog_agent_03.script_pushable = false;
	level.zerog_agent_03.baseaccuracy = .1;
	level.zerog_agent_03.ignoreSuppression = true;
	agent3_node = GetNode( "agent3_prezero_cover", "targetname" );
	level.zerog_agent_03 setgoalnode( agent3_node );
	
	enemy_trigger = GetEnt( "pre_zerog_spawn", "targetname" );
	enemy_trigger UseBy( level.player );
	
	flag_wait("cansee_zerog_room");
	thread autosave_now_silent();
	level.hero_agent_01 AllowedStances( "crouch", "stand", "prone" );
	level.pre_zerog_guys = get_living_ai_array( "pre_zerog_terrorists" , "script_noteworthy" );
	array_thread( level.pre_zerog_guys, ::stop_pre_zerog_behavior);
	//array_thread( level.pre_zerog_guys, ::player_damage_watcher);
	
	flag_wait("prezerog_extra_guys");
	extra_guy = spawn_targetname( "pre_zerog_terrorist_wave2" );
	level.pre_zerog_guys = get_living_ai_array( "pre_zerog_terrorists" , "script_noteworthy" );	

}

stop_pre_zerog_behavior()
{
	/*if(isAlive( self ) && IsDefined( self ))
	{	
		self stop_magic_bullet_shield();
	}*/
	
	self thread player_damage_watcher("stop_me");
	flag_wait("stop_me");
	wait(.5);
	if( isalive( self ))
	{
		self stop_magic_bullet_shield();	
	}
}

zerog()
{
	level.zerog_origin = getstruct( "all_plane_origin", "targetname" );
	
	flag_wait( "zero_g_trig" );
	rand = RandomFloatRange( 0.25, 0.75 );
	wait rand;
	level.player DisableWeapons();
	wait(0.25);
	//flag_set( "stop_rocking" );
	level notify("stop_rocking");
	flag_set( "stop_constant_shake" );
	level.hallway_roller notify( "stop_hallway_shake" );
	
	/*level.commander disable_ai_color();
	level.hero_agent_01 disable_ai_color();
	level.president disable_ai_color();
	
	level.commander hide();
	
	battlechatter_off( "axis" );*/
	
	aud_send_msg("zero_g_start");
	thread pre_zerog_cleanup();
	thread zerog_player_anim();
	thread zerog_anims();
	thread zerog_props();
	thread zerog_physics();
	
	wait(.5);

	SetSavedDvar( "phys_gravityChangeWakeupRadius", 3200 );
	SetSavedDvar("ragdoll_max_life" , 3600000);
}

#using_animtree( "generic_human" );
zerog_player_anim()
{	
	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player EnableDeathShield( true );
	//level.player EnableInvulnerability();
	
	if ( level.console )
	{
		SetSavedDvar("aim_aimAssistRangeScale", "1" );
		SetSavedDvar("aim_autoAimRangeScale", "0" );
	}
	level.player EnableSlowAim( 0.4, 0.4 );

	weaponlist = level.player GetWeaponsListAll();
	currentweapon = level.player GetCurrentWeapon();
	
	if( currentweapon == "ak74u" )
	{
		ak_ammo_clip = level.player GetWeaponAmmoClip( "ak74u" );
		ak_ammo_stock = level.player GetWeaponAmmoStock( "ak74u" );
		
		level.player TakeWeapon( "ak74u" );
		level.player GiveWeapon( "ak74u_zero_g" );
		level.player SwitchToWeapon( "ak74u_zero_g" );
		
		level.player SetWeaponAmmoClip( "ak74u_zero_g", ak_ammo_clip );
		level.player SetWeaponAmmoStock( "ak74u_zero_g", ak_ammo_stock );
	}
	else if( currentweapon == "fnfiveseven" )
	{
		fiveseven_ammo_clip = level.player GetWeaponAmmoClip( "fnfiveseven" );
		fiveseven_ammo_stock = level.player GetWeaponAmmoStock( "fnfiveseven" );
		
		level.player TakeWeapon( "fnfiveseven" );
		level.player GiveWeapon( "fnfiveseven_zero_g" );
		level.player SwitchToWeapon( "fnfiveseven_zero_g" );
		
		level.player SetWeaponAmmoClip( "fnfiveseven_zero_g", fiveseven_ammo_clip );
		level.player SetWeaponAmmoStock( "fnfiveseven_zero_g", fiveseven_ammo_stock );
	}
	
	waittillframeend;
	weaponlist = level.player GetWeaponsListAll();
	currentweapon = level.player GetCurrentWeapon();
	
	foreach( weapon in weaponlist )
	{
		if( weapon == "ak74u" )
		{
			ammo_clip = level.player GetWeaponAmmoClip( "ak74u" );
			ammo_stock = level.player GetWeaponAmmoStock( "ak74u" );
			
			level.player TakeWeapon( "ak74u" );
			level.player GiveWeapon( "ak74u_zero_g" );
			
			level.player SetWeaponAmmoClip( "ak74u_zero_g", ammo_clip );
			level.player SetWeaponAmmoStock( "ak74u_zero_g", ammo_stock );
		}
		else if( weapon == "fnfiveseven" )
		{
			ammo_clip = level.player GetWeaponAmmoClip( "fnfiveseven" );
			ammo_stock = level.player GetWeaponAmmoStock( "fnfiveseven" );
		
			level.player TakeWeapon( "fnfiveseven" );
			level.player GiveWeapon( "fnfiveseven_zero_g" );
			
			level.player SetWeaponAmmoClip( "fnfiveseven_zero_g", ammo_clip );
			level.player SetWeaponAmmoStock( "fnfiveseven_zero_g", ammo_stock );
		}
	}
	
	level.zerog_player_rig = spawn_anim_model( "test_body", level.zerog_origin.origin );
	level.player playerSetGroundReferenceEnt( level.zerog_player_rig );
	
	level.player PlayerLinkToBlend(level.zerog_player_rig, "tag_origin", .5, 0, 0);
	
	level.zerog_origin thread anim_single_solo(level.zerog_player_rig, "zero_g_player" );
	
	//turn the player slightly before he hits the floor.
	playerAnim = %hijack_zero_g_player;
	animlength = GetAnimLength( playeranim );
	hit_floor_notetrack = GetNotetrackTimes( playerAnim, "player_hit_floor" )[0];
	time = (animlength * hit_floor_notetrack);
	
	wait(0.5);
	//level.player PlayerLinkToDelta(player_rig, "tag_origin", 1, 180, 180, 60, 60);

	wait(1);
	//DELETING PRE-ZEROG GUYS SO THEY DON'T RAGDOLL ALL OVER THE PLACE.
	pre_guys = GetEntArray( "pre_zerog_terrorists", "script_noteworthy");
	foreach(terrorist in pre_guys)
	{
		terrorist delete();
	}
	
	wait(time - 2.5);
	level.player PlayerLinkToBlend(level.zerog_player_rig, "tag_origin", 1, 0, 0);
	
	level.zerog_player_rig waittillmatch( "single anim", "player_hit_floor" );
	
	SetSavedDvar( "phys_gravityChangeWakeupRadius", level.orig_WakeupRadius );
	SetSavedDvar( "ragdoll_max_life" , level.orig_ragdoll_life );
	
	level.player DisableWeapons();
	level.player ShellShock( "hijack_airplane", 3.0);
	level.player playerSetGroundReferenceEnt( level.org_view_roll );
	aud_send_msg("zero_g_bodyslam1");
	level.player thread play_sound_on_entity( "hijk_explosion_lfe" );
	level.player.ignoreme = false;
	Earthquake( 0.5, 2.0, level.player.origin, 6000 );
	if ( level.console )
	{
		SetSavedDvar("aim_aimAssistRangeScale", "1" );
		SetSavedDvar("aim_autoAimRangeScale", "1" );
	}
	level.player DisableSlowAim();
	level.player EnableDeathShield( false );
	level.player DisableInvulnerability();
	
	level.zerog_player_rig waittillmatch( "single anim", "end" );
	
	weaponlist = level.player GetWeaponsListAll();
	currentweapon = level.player GetCurrentWeapon();
	
	if( currentweapon == "ak74u_zero_g" )
	{
		ak_ammo_clip = level.player GetWeaponAmmoClip( "ak74u_zero_g" );
		ak_ammo_stock = level.player GetWeaponAmmoStock( "ak74u_zero_g" );
				
		level.player TakeWeapon( "ak74u_zero_g" );
		level.player GiveWeapon( "ak74u" );
		level.player SwitchToWeapon( "ak74u" );
		
		level.player SetWeaponAmmoClip( "ak74u", ak_ammo_clip );
		level.player SetWeaponAmmoStock( "ak74u", ak_ammo_stock );
	}
	else if( currentweapon == "fnfiveseven_zero_g" )
	{
		fiveseven_ammo_clip = level.player GetWeaponAmmoClip( "fnfiveseven_zero_g" );
		fiveseven_ammo_stock = level.player GetWeaponAmmoStock( "fnfiveseven_zero_g" );
				
		level.player TakeWeapon( "fnfiveseven_zero_g" );
		level.player GiveWeapon( "fnfiveseven" );
		level.player SwitchToWeapon( "fnfiveseven" );
		
		level.player SetWeaponAmmoClip( "fnfiveseven", fiveseven_ammo_clip );
		level.player SetWeaponAmmoStock( "fnfiveseven", fiveseven_ammo_stock );
	}
	
	waittillframeend;
	weaponlist = level.player GetWeaponsListAll();
	currentweapon = level.player GetCurrentWeapon();
	
	foreach( weapon in weaponlist )
	{
		if( weapon == "ak74u_zero_g" )
		{
			ammo_clip = level.player GetWeaponAmmoClip( "ak74u_zero_g" );
			ammo_stock = level.player GetWeaponAmmoStock( "ak74u_zero_g" );
			
			level.player TakeWeapon( "ak74u_zero_g" );
			level.player GiveWeapon( "ak74u" );
			
			level.player SetWeaponAmmoClip( "ak74u", ammo_clip );
			level.player SetWeaponAmmoStock( "ak74u", ammo_stock );
		}
		else if( weapon == "fnfiveseven_zero_g" )
		{
			ammo_clip = level.player GetWeaponAmmoClip( "fnfiveseven_zero_g" );
			ammo_stock = level.player GetWeaponAmmoStock( "fnfiveseven_zero_g" );
		
			level.player TakeWeapon( "fnfiveseven_zero_g" );
			level.player GiveWeapon( "fnfiveseven" );
			
			level.player SetWeaponAmmoClip( "fnfiveseven", ammo_clip );
			level.player SetWeaponAmmoStock( "fnfiveseven", ammo_stock );
		}
		else if( weapon == "pp90m1" )
		{
			level.player TakeWeapon( "ak74u_zero_g" );
		}
	}
	
	allEnts = GetEntArray( "weapon_ak74u_zero_g", "classname" );
	foreach( ent in allEnts )
	{
		ent delete();
	}
	
	thread zerog_swap_destruct_fx();
	thread constant_rumble();
	
	level.player Unlink();
	level.zerog_player_rig Delete();
	level.player EnableWeapons();
	level.player allowsprint( true );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	
	wait(2);
	//thread autosave_by_name( "post_zero_g" );
	autosave_now();

}

#using_animtree( "generic_human" );
pre_zerog_cleanup()
{
	level.pre_zerog_guys = get_living_ai_array( "pre_zerog_terrorists" , "script_noteworthy" );
	foreach(terrorist in level.pre_zerog_guys)
	{
		if ( isdefined( terrorist.magic_bullet_shield ) )
			terrorist stop_magic_bullet_shield();
		terrorist kill( level.zerog_agent_03.origin, level.zerog_agent_03 );
	}
	level.intro_origin notify( "stop_debate_loop" );
	/* Don't delete advisor - he is needed for end scene
	if(isAlive( level.advisor ) && IsDefined( level.advisor ))
	{
		if ( isdefined( level.advisor.magic_bullet_shield ) )
			level.advisor stop_magic_bullet_shield();

		level.advisor delete();
	}
	*/
	
	wait(.5);
	
	if(isAlive( level.secretary ) && IsDefined( level.secretary ))
	{
		if ( isdefined( level.secretary.magic_bullet_shield ) )
			level.secretary stop_magic_bullet_shield();
		
		level.secretary delete();
	}
	
	if(isAlive( level.intro_agent2 ) && IsDefined( level.intro_agent2 ))
	{
		if ( isdefined( level.intro_agent2.magic_bullet_shield ) )
			level.intro_agent2 stop_magic_bullet_shield();
		
		level.intro_agent2 delete();
	}
	
	if(isAlive( level.polit_1 ) && IsDefined( level.polit_1 ))
	{
		if ( isdefined( level.polit_1.magic_bullet_shield ) )
			level.polit_1 stop_magic_bullet_shield();
		
		level.polit_1 delete();
	}
	
	if(isAlive( level.polit_2 ) && IsDefined( level.polit_2 ))
	{
		if ( isdefined( level.polit_2.magic_bullet_shield ) )
			level.polit_2 stop_magic_bullet_shield();
		
		level.polit_2 delete();
	}
	
	level.commander disable_ai_color();
	level.hero_agent_01 disable_ai_color();
	level.president disable_ai_color();
	
	level.commander hide();
	level.zerog_agent_03 hide();
	level.president hide();
	level.hero_agent_01 hide();
	level.intro_origin notify( "stop_pres_debate_loop" );
	
	if( IsDefined(  level.cleanup_ents )&&  IsDefined( level.cleanup_ents[ "pre_zerog_guys" ]  ))
   	{
	   cleanup_ents( "pre_zerog_guys" );
	}
	   
	battlechatter_off( "axis" );
	
}

#using_animtree( "generic_human" );
zerog_anims()
{	
	level.zerog_guys = array_spawn_targetname( "zerog_terrorists" );
	array_thread( level.zerog_guys, ::zerog_terrorist_setup );
	
	terrorist1 = get_living_ai( "zerog_terrorist1", "script_noteworthy");
	terrorist2 = get_living_ai( "zerog_terrorist2", "script_noteworthy");
	terrorist3 = get_living_ai( "zerog_terrorist3", "script_noteworthy");
	terrorist4 = get_living_ai( "zerog_terrorist4", "script_noteworthy");
	terrorist5 = get_living_ai( "zerog_terrorist5", "script_noteworthy");
	
	terrorist1 thread zerog_terrorist_anim( "zerog_terror1_track", "zerog_terrorist_01_align", %hijack_zerog_terrorist_01_alive, %hijack_zerog_terrorist_01_dead );
	terrorist2 thread zerog_terrorist_anim( "zerog_terror2_track", "zerog_terrorist_02_align", %hijack_zerog_terrorist_02_alive, %hijack_zerog_terrorist_02_dead );
	terrorist3 thread zerog_terrorist_anim( "zerog_terror3_track", "zerog_terrorist_03_align", %hijack_zerog_terrorist_03_alive, %hijack_zerog_terrorist_03_dead );
	terrorist4 thread zerog_terrorist_anim( "zerog_terror4_track", "zerog_terrorist_04_align", %hijack_zerog_terrorist_04_alive, %hijack_zerog_terrorist_04_dead );	
	terrorist5 thread zerog_terrorist_anim( "zerog_terror5_track", "zerog_terrorist_05_align", %hijack_zerog_terrorist_05_alive, %hijack_zerog_terrorist_05_dead );	
	
	level.zerog_origin thread anim_single_solo( level.zerog_agent_01, "zerog_moment" );
	level.zerog_origin thread anim_single_solo( level.zerog_agent_02, "zerog_moment" );
	wait(0.1);
	level.zerog_agent_01.baseaccuracy = 100;
	level.zerog_agent_01.ignoreall = true;
	level.zerog_agent_02.baseaccuracy = 100;
	level.zerog_agent_02.ignoreall = true;

	thread zerog_done_agents();
}

zerog_terrorist_setup()
{
	self thread no_grenades();
	self.animname = self.script_noteworthy;
	self.ignoreme = true;
	self disable_pain();
}

zerog_terrorist_anim( rig_animmodel, rig_anim, guy_anim1, guy_anim2 )
{
	self thread achieve_flight_attendant();
	
	self.anim_1 = guy_anim1;
    self.anim_2 = guy_anim2;
	
	rig = spawn_anim_model( rig_animmodel );
	self.rigname = rig;
	self.riganim = rig_anim;
	level.zerog_origin thread anim_first_frame_solo( rig, rig_anim );
	if( (self.animname == "zerog_terrorist4") || (self.animname == "zerog_terrorist5") )
	{
		self ForceTeleport( rig.origin, rig.angles);
	}
	else
	{
		self ForceTeleport( rig.origin, rig.angles + ( 0, -90, 0 ));
	}
	self LinkTo( rig, "J_prop_1" );
	
	level.zerog_origin thread anim_single_solo( rig, rig_anim );
	self AnimCustom( ::hijack_anim_custom ); 
	self.deathFunction = ::hijack_anim_death;
}
 
achieve_flight_attendant()
{
	self waittill( "death", attacker, type, weapon );
	
	if ( !IsDefined(attacker) || attacker != level.player )
		return;
	
	if ( !isdefined( level.player.achieve_flight_attendant ) )
		level.player.achieve_flight_attendant = 1;
	else
		level.player.achieve_flight_attendant++;
	
	if( level.player.achieve_flight_attendant == 5 )
	{
		level.player player_giveachievement_wrapper("FLIGHT_ATTENDANT");
	}		   
}
 
hijack_anim_custom() 
{ 
	anim_string = "single anim";
	
    self ClearAnim( %root, 0.1 ); 
    //self SetAnim( self.anim_1, 1 ); 
	self SetFlaggedAnim( anim_string, self.anim_1, 1 );
	
	self thread maps\_anim::start_notetrack_wait( self, anim_string, self.anim_1, self.animname );
	self thread maps\_anim::animscriptDoNoteTracksThread( self, anim_string, self.anim_1 );
	
	if( self.animname == "zerog_terrorist3" )
	{
		self thread zerog_terrorist3_kill();
	}
	else if( self.animname != "zerog_terrorist4" )
	{
		self thread zerog_kill( self.anim_1 ); //kills guy if player never shoots him in zero-g
	}
		
    self waittill( "death" ); 
} 

#using_animtree( "generic_human" ); 
hijack_anim_death(rig, rig_anim) 
{ 
	self endon( "scripted_death" );
	flag_set( "custom_death");  
	
	anim_string = "single anim";
	
	self animscripts\shared::DropAIWeapon();
	rand = RandomIntRange( 0, 5 );
	
	if (rand == level.last_death_index)
	{
		rand += 1;
		if (rand == 5)
		{
			rand = 0;
		}
	}
	
	level.last_death_index = rand;
	
	switch(rand)	
	{
		case 0:
			self PlaySound( "hijk_zg_death_01" );
			break;
		case 1:
			self PlaySound( "hijk_zg_death_02" );
			break;
		case 2:
			self PlaySound( "hijk_zg_death_03" );
			break;
		case 3:
			self PlaySound( "hijk_zg_death_04" );
			break;
		case 4:
			self PlaySound( "hijk_zg_death_05" );
			break;
		default:
			break;
	}
	
	time = self GetAnimTime( self.anim_1 );
	self ClearAnim( self.anim_1, 0.2 ); 
	//self SetAnim( self.anim_2, 1 );
	self SetFlaggedAnim( anim_string, self.anim_2, 1 );
	
	self thread maps\_anim::start_notetrack_wait( self, anim_string, self.anim_2, self.animname );
	self thread maps\_anim::animscriptDoNoteTracksThread( self, anim_string, self.anim_2 );
	
	self SetAnimTime( self.anim_2, time );
	
	self SetAnimLimited( %zero_g_shot, 0.95, 0 );
	wait(1.0);
	self ClearAnim( %zero_g_shot, .5 );  

	if( self.animname == "zerog_terrorist3" )
	{
		self waittillmatch( "single anim", "unlink" );
		time2 = self GetAnimTime( self.anim_2 );
		//self Unlink();
		rig = [];
		rig[0] = self.rigname;
		level.zerog_origin anim_first_frame_solo( self.rigname, self.riganim );
		level.zerog_origin anim_set_time( rig, self.riganim, time2 );
		
	}
}

/*zerog_behavior()
{
	if(isAlive( self ) && IsDefined( self ))
	{
		self.ignoreme = true;
		self.allowdeath = true;
		
		self.forceRagdollImmediate = true;
		self.ragdoll_directionScale = 600; //default is 3000
	
	}
}*/

#using_animtree( "generic_human" );
zerog_kill( anime )
{
	self endon( "custom_death" );
	
	self waittillmatch( "single anim", "zero_g_die" );
	flag_set( "scripted_death" );
	
	if ( !IsAlive( self ) )
	{
		return;
	}

	self.deathFunction = undefined;
	self.forceRagdollImmediate = false;
	self.a.nodeath = true;
	self animscripts\shared::DropAIWeapon();
	wait(.05);
	self kill();
}

zerog_props()
{
	thread zerog_extra_props();
	
	luggage01 = GetEnt( "luggage01", "script_noteworthy" );
	luggage02 = GetEnt( "luggage02", "script_noteworthy" );
	luggage03 = GetEnt( "luggage03", "script_noteworthy" );
	luggage04 = GetEnt( "luggage04", "script_noteworthy" );
	luggage05 = GetEnt( "luggage05", "script_noteworthy" );
	luggage06 = GetEnt( "luggage06", "script_noteworthy" );
	luggage07 = GetEnt( "luggage07", "script_noteworthy" );
	luggage08 = GetEnt( "luggage08", "script_noteworthy" );
	
	box01 = GetEnt( "zerog_box01", "script_noteworthy" );
	box02 = GetEnt( "zerog_box02", "script_noteworthy" );
	overhead_door_r = GetEnt( "overhead_door_r", "targetname" );
	overhead_door_l_1 = GetEnt( "overhead_door_l_1", "targetname" );
	overhead_door_l_2 = GetEnt( "overhead_door_l_2", "targetname" );
	foodcart = GetEnt( "foodcart", "targetname" );
	laptop = GetEnt( "zerog_laptop", "targetname" );
	airmask_r = GetEnt( "air_mask_module_r", "targetname" );
	airmask_l = GetEnt( "air_mask_module_l", "targetname" );
	
	luggage01 thread zerog_destructible_prop("zerog_suitcase1");
	luggage02 thread zerog_destructible_prop("zerog_suitcase2");
	luggage03 thread zerog_destructible_prop("zerog_suitcase3");
	luggage04 thread zerog_destructible_prop("zerog_suitcase4");
	luggage05 thread zerog_destructible_prop("zerog_suitcase5");
	luggage06 thread zerog_destructible_prop("zerog_suitcase6");
	luggage07 thread zerog_destructible_prop("zerog_suitcase7");
	luggage08 thread zerog_destructible_prop("zerog_suitcase8");
	box01 thread zerog_destructible_prop("zerog_squarebox");
	box02 thread zerog_destructible_prop("zerog_rectanglebox");
	overhead_door_r thread zerog_door_behavior("zerog_overhead_door_r");
	foodcart thread zerog_destructible_prop("zerog_mealcart");
	laptop thread zerog_animated_prop("zerog_laptop", "zerog_laptop");
	airmask_r thread zerog_animated_prop("zerog_o2_module", "zerog_o2_module_r");
	airmask_l thread zerog_animated_prop("zerog_o2_module", "zerog_o2_module_l");
	
	rig = spawn_anim_model("zerog_prop");
	rig SetModel( "generic_prop_raven" );
	rig setanimtree();
	waittillframeend;	
	level.zerog_origin thread anim_first_frame_solo( rig, "zerog_overhead_door_l" );
	overhead_door_l_1 linkto( rig , "J_prop_1" );
	overhead_door_l_2 linkto( rig , "J_prop_2" );
	
	flag_wait("zero_g_trig");
	level.zerog_origin thread anim_single_solo( rig, "zerog_overhead_door_l" );	
	
	flag_wait( "plane_third_hit");
	wait(.5);
	box01 DoDamage( box01.health + 100, box01.origin );
	wait(.2);
	box02 DoDamage( box02.health + 100, box02.origin );
}

#using_animtree("animated_props");
zerog_extra_props()
{
	level.extra_props_left = getstruct( "extra_door_left", "targetname" );
	level.extra_props_right = getstruct( "extra_door_right", "targetname" );
	overhead_door_r_2 = GetEnt( "overhead_door_r_2", "targetname" );
	overhead_door_l_3 = GetEnt( "overhead_door_l_3", "targetname" );
	box03 = GetEnt( "zerog_box03", "script_noteworthy" );
	
	//box03 thread zerog_destructible_prop("zerog_rectanglebox", level.extra_props_left);
	//---
	box03 SetCanDamage( true );
	
	luggage_rig = spawn_anim_model("zerog_prop");
	luggage_rig SetModel( "generic_prop_raven" );
	luggage_rig setanimtree();
	waittillframeend;	

	//---
	
	//overhead_door_r_2 thread zerog_door_behavior("zerog_overhead_door_r");
	
	rig_left = spawn_anim_model("zerog_prop");
	rig_left SetModel( "generic_prop_raven" );
	rig_left setanimtree();
	
	rig_right = spawn_anim_model("zerog_prop");
	rig_right SetModel( "generic_prop_raven" );
	rig_right setanimtree();
	
	waittillframeend;	
	level.extra_props_left thread anim_first_frame_solo( rig_left, "zerog_overhead_door_l" );
	overhead_door_l_3 linkto( rig_left , "J_prop_2" );

	level.extra_props_left thread anim_first_frame_solo( luggage_rig, "zerog_rectanglebox" );
	box03 linkto( luggage_rig , "J_prop_1" );
	
	level.extra_props_right thread anim_first_frame_solo( rig_right, "zerog_overhead_door_r" );
	overhead_door_r_2 linkto( rig_right , "J_prop_1" );
	
	flag_wait("zero_g_trig");
	wait(1.75);
	
	level.extra_props_left thread anim_single_solo( rig_left, "zerog_overhead_door_l" );
	rig_left SetAnimTime( %hijack_zerog_overhead_door_l, .65 );
	
	level.extra_props_left thread anim_single_solo( luggage_rig, "zerog_rectanglebox" );
	luggage_rig SetAnimTime( %hijack_zerog_rectanglebox, .65 );
	
	wait(.2);
	level.extra_props_right thread anim_single_solo( rig_right, "zerog_overhead_door_r" );
	
	wait(.3);
	box03 DoDamage( box03.health + 100, box03.origin );
}
	
zerog_swap_destruct_fx()
{
	index = common_scripts\_destructible_types::getInfoIndex( "toy_luggage_01" );
	if ( index > -1 )
	{
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx_filename" ][ 0 ][ 0 ] = "props/luggage_1_des";	// path of fx file
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx" ][ 0 ][ 0 ] = getfx("luggage_1_des");	// alias of fx as defined in hijack_fx.gsc
	}
	
	index = common_scripts\_destructible_types::getInfoIndex( "toy_luggage_02" );
	if ( index > -1 )
	{
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx_filename" ][ 0 ][ 0 ] = "props/luggage_2_des";	// path of fx file
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx" ][ 0 ][ 0 ] = getfx("luggage_2_des");	// alias of fx as defined in hijack_fx.gsc
	}
	
	index = common_scripts\_destructible_types::getInfoIndex( "toy_luggage_03" );
	if ( index > -1 )
	{
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx_filename" ][ 0 ][ 0 ] = "props/luggage_3_des";	// path of fx file
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx" ][ 0 ][ 0 ] = getfx("luggage_3_des");	// alias of fx as defined in hijack_fx.gsc
	}
	
	index = common_scripts\_destructible_types::getInfoIndex( "toy_luggage_04" );
	if ( index > -1 )
	{
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx_filename" ][ 0 ][ 0 ] = "props/luggage_4_des";	// path of fx file
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "fx" ][ 0 ][ 0 ] = getfx("luggage_4_des");	// alias of fx as defined in hijack_fx.gsc
	}
}

zerog_destructible_prop(prop_anim)
{
	self SetCanDamage( true );
	
	luggage_rig = spawn_anim_model("zerog_prop");
	luggage_rig SetModel( "generic_prop_raven" );
	luggage_rig setanimtree();
	waittillframeend;	
	level.zerog_origin thread anim_first_frame_solo( luggage_rig, prop_anim );
	self linkto( luggage_rig , "J_prop_1" );
	
	flag_wait("zero_g_trig");
	level.zerog_origin anim_single_solo( luggage_rig, prop_anim );
	
	waittillframeend;
	luggage_rig delete();
}

zerog_indestructible_prop(prop_anim)
{
	self.health = 5;
	self SetCanDamage( true );
	
	rig = spawn_anim_model("zerog_prop");
	rig SetModel( "generic_prop_raven" );
	rig setanimtree();
	waittillframeend;	
	level.zerog_origin thread anim_first_frame_solo( rig, prop_anim );
	self linkto( rig , "J_prop_1" );
	
	flag_wait("zero_g_trig");
	level.zerog_origin thread anim_single_solo( rig, prop_anim );

	self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
	rig StopAnimScripted();
	self unlink();
	self PhysicsLaunchClient( point, direction_vec );
	rig Delete();
}

zerog_animated_prop(animname, prop_anim)
{
	self.animname = animname;
	self setanimtree();
	level.zerog_origin thread anim_first_frame_solo( self, prop_anim );
	flag_wait("zero_g_trig");
	level.zerog_origin anim_single_solo( self, prop_anim );
}

zerog_door_behavior(prop_anim)
{
	rig = spawn_anim_model("zerog_prop");
	rig SetModel( "generic_prop_raven" );
	rig setanimtree();
	waittillframeend;	
	level.zerog_origin thread anim_first_frame_solo( rig, prop_anim );
	self linkto( rig , "J_prop_1" );
	
	flag_wait("zero_g_trig");
	level.zerog_origin anim_single_solo( rig, prop_anim );	
}

zerog_physics()
{
	level endon( "zero_g_done" );
	while(true)
	{
		//PhysicsJolt( (-27290, 12784, 7340), 500, 450, (.01, .01, .05));
		PhysicsJitter((-27290, 12784, 7340), 500, 450, .1, .2);
		wait(.05);
	}
}

player_physics_explosion()
{
	level endon( "zero_g_done" );	
	while ( true )
	{
		PhysicsExplosionSphere(level.player.origin, 64, 32, .01);
		wait( .05 );
	}
}

zerog_firsthit(guy)
{
	// PLANE LURCHES
	//-- AFFECT PLAYER --
	level.player PlayRumbleOnEntity( "hijack_plane_large" );
	level.player DisableWeapons();	
	Earthquake( 0.15, 0.6, level.player.origin, 6000 );
	level.player ShellShock( "hijack_minor", 1.5);
	
	//-- AFFECT PROPS & RAGDOLL --
	array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, 12.0), 1, 0, 0 );
	//setPhysicsGravityDir( (0, 0, -1) );
	LerpSunAngles( (-5, 114, 0), (-24, 96, 0) , 1);
		
	wait(0.4);
	physicspush = GetEntArray( "zerog_physics", "targetname" );
	foreach(object in physicspush)
	{
		PhysicsExplosionSphere( object.origin, 64, 32, .45);
	}
	
	wait (0.3);
	setPhysicsGravityDir( (0.00, 0.00, -0.02) );
	aud_send_msg("zero_g_bodyslam2");
	wait(0.7);
	
	// PLANE LEVELS	OFF
	//level.player ShellShock( "hijack_slowview", 5);
	array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, 0), .75, 0, 0 );
	setPhysicsGravityDir( (0, -0.02, -1) );  //moving to right of plane
}

zerog_flyup(guy)
{
	level endon( "plane_roll_right" );
	// THROW PLAYER IN AIR
	//-- AFFECT PLAYER --
	Objective_Delete( obj("move_president"));
	thread player_physics_explosion();
	setPhysicsGravityDir( (0.02, -0.01, 0.08) ); //moving to front and right of plane
	
	//-- AFFECT PROPS & RAGDOLL --
	SetSavedDvar( "phys_gravity", -5 );
	SetSavedDvar( "phys_gravity_ragdoll", -100 );
	//wait(2.5);
	wait(2.0);
	
	//We're in a dive!
	thread radio_dialogue( "hijack_plt_inadive" );
	
	wait(0.5);
	
	level.player PlayerLinkToDelta(level.zerog_player_rig, "tag_origin", 1, 180, 180, 60, 60);
	level.player EnableWeapons();
}

zerog_planedive(guy)
{
	// PLANE STARTS TO DIVE
	//-- AFFECT PROPS & RAGDOLL --
	level.player EnableInvulnerability();
	array_thread( level.aRollers, ::rotate_rollers_to, (-35, 0, 0), 4, 0, 2 );
	LerpSunAngles( (-24, 96, 0), (-11, 60, 0) , 3);
	wait(1.75);
	setPhysicsGravityDir( (0.03, 0.0, 0.05) ); //moving to front of plane
	
	wait(3.6);
	//We're losing altitude!
	thread radio_dialogue( "hijack_plt_losingaltitude" );
}

zerog_secondhit(guy)
{
	// THROW PLAYER IN AIR
	//-- AFFECT PLAYER --
	Earthquake( 0.25, 1.5, level.player.origin, 6000 );
	level.player ShellShock( "hijack_airplane", 2.5);
	aud_send_msg("zero_g_bodyslam3");
	wait(2.5);
	//level.player ShellShock( "hijack_slowview", 30);
}

zerog_planerollright(guy)
{
	// PLANE ROLLS RIGHT
	//-- AFFECT PROPS & RAGDOLL --
	level.player DisableInvulnerability();
	level endon( "plane_roll_left" );
	flag_set( "plane_roll_right");
	array_thread( level.aRollers, ::rotate_rollers_to, (-35, 0, -20), 3, 1, 1 );
	LerpSunAngles( (-11, 60, 0), (2, 95, 0), 5);
	setPhysicsGravityDir( (0.00, -0.01, 0.01) ); //moving to front and right of plane
}

zerog_bigshake(guy)
{
	// TURBULANCE
	//-- AFFECT PLAYER --
	Earthquake( 0.45, 2.0, level.player.origin, 6000 );
	level.player thread play_sound_on_entity( "hijk_zero_g_bigshake" );
}

zerog_planerollleft(guy)
{
	// PLANE ROLLS LEFT, PULLS UP
	//-- AFFECT PROPS & RAGDOLL --
	level endon( "plane_levels" );
	flag_set( "plane_roll_left");
	array_thread( level.aRollers, ::rotate_rollers_to, (15, 0, 15), 2.75, 0, .25 );
	LerpSunAngles( (2, 95, 0), (-23, 65, 0), 3.75);
	setPhysicsGravityDir( (-0.02, 0.03, 0.01) ); //moving to back and left of plane
}

zerog_thirdhit(guy)
{
	// PLANE ROLLS LEFT, PULLS UP
	//-- AFFECT PLAYER --
	level.player EnableInvulnerability();
	flag_set( "plane_third_hit");
	Earthquake( 0.25, 2.0, level.player.origin, 6000 );
	setPhysicsGravityDir( (0.0, 0.0, 0.0) );  // moving to bottom of plane
	level.player ShellShock( "hijack_airplane", 2.5);
	level.player DisableWeapons();
	aud_send_msg("zero_g_bodyslam4");
	wait(2.5);
	//level.player ShellShock( "hijack_slowview", 15);
	level.player EnableWeapons();
}

zerog_planelevelout(guy)
{
	// PLANE LEVELS, ZERO-G DONE
	//-- AFFECT PROPS & RAGDOLL --
	flag_set( "plane_levels");
	array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, 0), 3, 0, 0 );
	LerpSunAngles( (-23, 65, 0), level.orig_sundirection, 5, 0, 1);
	setPhysicsGravityDir( (0, 0, -1) );  // moving to bottom of plane
	SetSavedDvar( "phys_gravity", level.orig_phys_gravity );
	SetSavedDvar( "phys_gravity_ragdoll", level.orig_ragdoll_gravity );
	joltOrigin = (-27290, 12784, 7340);
	PhysicsJitter( joltOrigin, 500, 450, .1, .2, 1 );
	PhysicsJolt( joltOrigin, 500, 450, (.00, .00, -.05));
	zerog_jolt_weapons( joltOrigin, 500, (.00, .00, -.05));
	aud_send_msg("zero_g_debris_crash");
}

zerog_jolt_weapons( joltOrigin, joltRadius, joltVel )
{
	radiusSqr = joltRadius * joltRadius;
	allEnts = GetEntArray();
	foreach( ent in allEnts )
	{
		if ( IsDefined(ent) && IsDefined(ent.classname) )
		{
			delta = joltOrigin - ent.origin;
			
			if ( GetSubStr(ent.classname, 0, 7) == "weapon_" && LengthSquared(delta) <= radiusSqr )
			{
				if( ent.classname != "weapon_mp412" ) // These are placed in the lower level and don't need to jolt
				{
					ent PhysicsLaunchServerItem( ent.origin, joltVel );
				}				
			}
		}
	}
}

zerog_done_agents()
{
	if ( level.start_point != "lower_level_combat" )
	{
		level.zerog_agent_02 waittillmatch( "single anim", "end" );
	}
	
	level.zerog_agent_01.ignoreme = true;
	level.zerog_agent_01.ignoreall = true;
	level.zerog_agent_01.fixednode = true;
	level.zerog_agent_01.goalradius = 16;
	level.zerog_agent_01 enable_cqbwalk();
	level.zerog_agent_01 PushPlayer( true ); 
	
	level.zerog_agent_02.ignoreme = true;
	level.zerog_agent_02.ignoreall = true;
	level.zerog_agent_02.fixednode = true;
	level.zerog_agent_02.goalradius = 16;
	level.zerog_agent_02 enable_cqbwalk();
	level.zerog_agent_02 PushPlayer( true );

	if ( isdefined(level.zerog_agent_03) )
	{
		agent3_node = getnode( "agent3_postzero_node1", "targetname" );
		level.zerog_agent_03.goalradius = 16;
		level.zerog_agent_03 enable_cqbwalk();
		level.zerog_agent_03 setgoalnode( agent3_node );
	}	
	
	zerog_agent_02_node2 = getnode( "zerog_agent2_end_node", "targetname" );
	level.zerog_agent_02 setgoalnode( zerog_agent_02_node2 );	
	
	wait(.2);
	
	zerog_agent_01_node2 = getnode( "zerog_agent1_end_node", "targetname" );
	level.zerog_agent_01 setgoalnode( zerog_agent_01_node2 );
	level.zerog_agent_01 waittill("goal");
	
	if ( isdefined(level.zerog_agent_03) )
	{
		agent3_node = getnode( "agent1_prezero_cover2", "targetname" );
		level.zerog_agent_03 setgoalnode( agent3_node );
	}
	
	anim_origin = getstruct("all_plane_origin","targetname");
	level.fire_extinguisher = GetEnt( "fire_extinguisher", "targetname" );
	rig = spawn_anim_model("zerog_prop");
	rig SetModel( "generic_prop_raven" );
	rig setanimtree();
	waittillframeend;	
	anim_origin thread anim_first_frame_solo( rig, "fire_extinguisher_enter" );
	level.fire_extinguisher linkto( rig , "J_prop_1" );

	anim_origin thread anim_single_solo( rig, "fire_extinguisher_enter" );
	anim_origin anim_single_solo( level.zerog_agent_01, "cockpit_door_bash_enter" );
	if( isDefined( level.zerog_agent_01 ) && isAlive( level.zerog_agent_01))
	{
		anim_origin thread anim_loop_solo( rig, "fire_extinguisher_loop" );
		level.zerog_agent_01 thread check_player_for_prone( "true" );
		anim_origin anim_loop_solo( level.zerog_agent_01, "cockpit_door_bash_loop", "end_cockpit_loop" );
	}
}

#using_animtree( "generic_human" );
zerog_terrorist3_kill()
{
	//wait same time as notetrack instead of waiting for actual notetrack because guy might be dead
	terroristAnim = %hijack_zerog_terrorist_03_alive;
	animlength = GetAnimLength( terroristAnim );
	agent_notetrack = GetNotetrackTimes( terroristAnim, "cue_hero_agent" )[0];
	time = (animlength * agent_notetrack);
	
	self thread zerog_terrorist3_dropweapon(time);
	
	wait(time);
	
	level.commander show();
	level.zerog_agent_03 show();
	level.president show();
	level.hero_agent_01 show();
	
	level.commander teleport_ai(getnode( "teleport_hero_agent", "targetname" ));
	
	//Team 2, retake the cockpit!
	level.commander thread dialogue_queue( "hijack_cmd_retakecockpit" );
	if( isAlive(self) )
	{
		self.forceRagdollImmediate = false;
		self.a.nodeath = true;
		level.zerog_origin anim_single_solo(level.commander, "zerog_hero_agent");
		//time = self GetAnimTime( %hijack_zerog_terrorist_03_alive );
		//wait (time * .85 );
		//self animscripts\shared::DropAIWeapon();
		
	}
	else
	{
		level.zerog_origin anim_single_solo(level.commander, "zerog_commander_alt");
	}
	flag_set( "zero_g_done" );
	thread zerog_done();
}

zerog_terrorist3_dropweapon(time)
{
	self endon( "death" );
	wait(time * .98);
	self animscripts\shared::DropAIWeapon();
}

zerog_done()
{
	flag_wait( "zero_g_done" );

	//thread autosave_by_name( "post_zero_g" );
			
	thread moving_to_bottom_level();
}

/*---------------------------------------------------
	
	                 End of Zero_G
	
----------------------------------------------------*/
	
/*---------------------------------------------------
	
	               Lower Level Combat
	
----------------------------------------------------*/

moving_to_bottom_level()
{
	level.hero_agent_01.goalradius = 16;
	level.hero_agent_01.goalheight = 24;
	level.hero_agent_01 disable_pain();	
	level.hero_agent_01.ignoresuppression = true;
	level.hero_agent_01.ignoreme = true;
	level.hero_agent_01.ignoreall = true;
	level.hero_agent_01.fixednode = true;
	level.hero_agent_01.animname = "generic";
	//top_of_stairs_agent_node = getnode( "agent_top_of_stairs", "targetname" );
	//level.hero_agent_01 SetGoalNode(top_of_stairs_agent_node);
	
	level.commander.goalradius = 16;
	level.commander.goalheight = 24;
	level.commander disable_pain();	
	level.commander.ignoresuppression = true;
	level.commander.ignoreme = false;
	level.commander.ignoreall = false;
	level.commander.fixednode = false;
	level.commander enable_cqbwalk();
	level.commander.baseAccuracy = 0.1;
	
	//top_of_stairs_commander_node = getnode( "agent_top_of_stairs", "targetname" );
	//level.commander SetGoalNode(top_of_stairs_agent_node);
	
	thread start_lower_combat();
	thread lower_vo_handler();
	thread lower_level_props();
		
	//top_of_stairs_commander_node = getnode( "commander_top_of_stairs", "targetname" );
	//level.commander.goalradius = 32;
	//level.commander setgoalnode( top_of_stairs_commander_node );
	top_of_stairs_agent_node = getnode( "commander_top_of_stairs", "targetname" );
	level.hero_agent_01.goalradius = 32;
	level.hero_agent_01 setgoalnode( top_of_stairs_agent_node );
	
	top_of_stairs_president_node = getnode( "president_top_of_stairs", "targetname" );
	level.president.goalradius = 32;
	level.president setgoalnode( top_of_stairs_president_node );
}

lower_vo_handler()
{
	//Trigger order
		//stairs - move_commander_to_first_node
		//stairs - start_runner_1, start_runner_2
		//stairs - player_reached_bottom_of_stairs
		//stair room turn corner- spawn_second_room_first_wave
		//stair room end - move_president_to_first_room
		//dining room beginning - spawn_second_room_second_wave
		//dining room 1/4 - force_bar_rumble
		//dining room 1/2 - move_president_to_second_room_start
		//dining room end - move_president_to_second_room_middle
		//dining room end door - player_in_second_doorway
		//dining room end door - spawn_hallway_terrorists_1
		//hallway beginning - lower_level_rumble_hallway
		//hallway mid - spawn_hallway_terrorists_2
		//hallway 2/3 - spawn_comm_room_terrorists
		//hallway end - move_president_to_hallway
		//comm room mid - move_president_to_comm_room
	
	//They have the daughter in the cargo bay.
	radio_dialogue( "hijack_fso3_theyhave" );
	//Team 3, backup is on the way.
	level.commander dialogue_queue( "hijack_cmd_backuponway" );

	flag_wait("spawn_second_room_first_wave");
	//All teams, there are additional hijackers on the lower deck.
	level.commander dialogue_queue("hijack_cmd_additionalhijack");
	
	flag_wait("move_president_to_first_room");
	//Fedorov, protect the President.
	level.commander dialogue_queue("hijack_cmd_protectpres");
	//This way, sir.
	level.hero_agent_01 dialogue_queue("hijack_fso1_thiswaysir");
	wait(1.75);
	//Preparing to retake the cockpit.
	radio_dialogue( "hijack_fso2_retake" );		

	if( flag ( "dining_room_done" ))
	{
		//Room clear.
		level.commander dialogue_queue("hijack_cmd_roomclear"); //giving 2 chances to say this without overlapping other VO
	}
	
	flag_wait("move_president_to_second_room_start");
	//Mr. President, stay behind cover and keep your head down.
	level.commander dialogue_queue("hijack_cmd_headdown");

	wait(.5);
	
	if( flag ( "dining_room_done" ))
	{
		//Room clear.
		level.commander dialogue_queue("hijack_cmd_roomclear"); //giving 2 chances to say this without overlapping other VO
	}

	flag_wait("spawn_hallway_terrorists_1");
	//The door to the cockpit is been jammed shut.
	radio_dialogue( "hijack_fso2_jammedshut" );	
	
	flag_wait( "lower_level_rumble_hallway" );
	//Mr. President, we have to keep moving.
	level.hero_agent_01 dialogue_queue("hijack_fso1_keepmoving");
	
	flag_wait( "spawn_comm_room_terrorists" );
	//Keep pushing forward, Harkov.
	level.commander dialogue_queue("hijack_cmd_keeppushing");
	
	flag_wait("move_president_to_hallway");
	//We're being driven back from the cockpit.
	radio_dialogue( "hijack_fso2_drivenback" );
	wait(.75);
	//We have to stay with the group, sir.
	level.hero_agent_01 dialogue_queue("hijack_fso1_staywithgroup");

	flag_wait("move_president_to_comm_room");
	//We have to get to the President to the saferoom.
	level.commander dialogue_queue("hijack_cmd_prestosaferoom");
	wait(.4);
	//Keep going, Mr. President.
	level.hero_agent_01 dialogue_queue("hijack_fso1_keepgoing");	
}

lower_level_props()
{
	phones = GetEntArray( "hanging_phone", "targetname" );
	array_thread( phones, ::lower_level_phone );

}

lower_level_phone()
{
	self.animname = "hanging_phone";
	self setanimtree();
	wait(RandomFloatRange( 0.0, 0.8 ));
	self thread anim_loop_solo( self, "phone_swaying", "stop_phones" );
	flag_wait( "stop_phones" );
	self notify( "stop_phones" );
	self StopAnimScripted();
	self delete();
}

start_lower_combat()
{
	flag_clear("player_moving_downstairs");
	
	battlechatter_on( "axis" );

	thread lower_level_objectives();
	thread agent_and_president_movement();
	thread glass_watcher();
	thread lower_level_rumbles();
	thread lower_level_cleanup_cockpit();
	thread lower_level_dead_allies();
	thread commander_initial_moves();
	thread find_daughter_moment();
	thread color_trigger_watcher();
	thread cargo_props_prep();
	
	thread lower_hallway_enemies();
	thread lower_comm_cargo_enemies();
	
	//------------------
	// First Room
	//------------------
	
	thread lower_level_runners("runner_1");
	thread lower_level_runners("runner_2");

	//------------------
	// Dining Room
	//------------------
	
	flag_wait("spawn_second_room_first_wave");
	second_room_terrorists_1 = array_spawn_function_targetname( "second_room_terrorists_1", ::lower_clean_up );
	second_room_terrorists_1 = array_spawn_targetname( "second_room_terrorists_1" );
	
	foreach (runner in level.runners)
	{
		if ( IsAlive(runner) )
		{
			second_room_terrorists_1[second_room_terrorists_1.size] = runner;
		}
	}
	thread ai_array_killcount_flag_set(second_room_terrorists_1,second_room_terrorists_1.size-1,"spawn_second_room_second_wave");
	//level.commander thread dialogue_queue("hijack_cmd_additionalhijack");
	
	thread lower_level_radio_chatter();
	
	flag_wait( "spawn_second_room_second_wave" );
	second_room_terrorists_2 = array_spawn_function_targetname( "second_room_terrorists_2", ::lower_clean_up );
	second_room_terrorists_2 = array_spawn_targetname( "second_room_terrorists_2" );
	thread ai_array_killcount_flag_set(second_room_terrorists_2,second_room_terrorists_2.size,"dining_room_done");	

	flag_wait( "dining_room_done" );
	
	// room 2 clear, move up ally
	level.commander.ignoresuppression = false;
	thread try_move_commander_through_dining_room();
	thread maps\hijack_crash_fx::handle_pre_sled_lights();
}

lower_hallway_enemies()
{
	//------------------
	// Hallway
	//------------------
	
	flag_wait( "spawn_hallway_terrorists_1" );
	
	hallway_terrorists_1 = array_spawn_targetname( "hallway_terrorists_1" );
	thread ai_array_killcount_flag_set(hallway_terrorists_1,hallway_terrorists_1.size,"all_hallway_terrorists_dead");
	
	flag_set( "exited_dining_room" );
	level.lower_radio_org.deleteme = true;
	
	//if( flag( "dining_room_done" )) //to keep VO from overlapping too much
	//{
	//	level.commander thread dialogue_queue("hijack_cmd_keeppushing");
	//}
}

lower_comm_cargo_enemies()
{
	//------------------
	// Comm room
	//------------------

	flag_wait_any("all_hallway_terrorists_dead","spawn_comm_room_terrorists");
	thread comm_room_background_chatter();
	thread cargo_room_daughter_seen();
	
	flag_wait("spawn_comm_room_terrorists");
	comm_room_terrorists = array_spawn_targetname( "comm_room_terrorists" );
	thread ai_array_killcount_flag_set(comm_room_terrorists,comm_room_terrorists.size,"all_comm_room_terrorists_dead");
	//there's only 1 atm
	comm_runner = get_living_ai( "comm_runner", "script_noteworthy" );
	ran = RandomIntRange( 0, 1 );
	if( ran == 0 )
	{
		node = GetNode( "comm_runner_left", "targetname" );
		comm_runner SetGoalNode(node);
	}
	else
	{
		node = GetNode( "comm_runner_right", "targetname" );
		comm_runner SetGoalNode(node);
	}
	
	cargo_room_terrorists_a = array_spawn_targetname("cargo_room_terrorists_a");
	//cargo_room_terrorists_b = array_spawn_targetname("cargo_room_terrorists_b");  //trying spawing them in daughter_seen function.
	thread ai_array_killcount_flag_set(cargo_room_terrorists_a, 1, "cargo_room_commander_move");
	thread ai_array_killcount_flag_set(cargo_room_terrorists_a, 3, "cargo_room_wave_a_dead");
	//thread ai_array_killcount_flag_set(cargo_room_terrorists_b, cargo_room_terrorists_b.size, "all_cargo_room_terrorists_dead");
	
	flag_wait("all_comm_room_terrorists_dead");
	//level.commander thread dialogue_queue("hijack_cmd_prestosaferoom");
	
	// comm room clear, move up ally
	try_activate_trigger_targetname("comm_room_clear_ally_position");

	//------------------
	// Approach to crash room
	//------------------

	flag_wait("find_daughter_moment_finished");
	
	//thread game_over_if_player_waits_too_long();
	
	thread maps\hijack_crash::pre_plane_crash();
	
	flag_wait( "player_is_in_end_room" );
		
	flag_wait_any( "start_plane_crash_aisle_1", "start_plane_crash_aisle_2" );
	maps\_spawner::killspawner( 100 );
	
	thread maps\hijack_crash::start_plane_crash();
}

lower_clean_up()
{
	//Cleans up dining room guys if you sprint to comm room
	flag_wait( "clean_up_dining_room" );
	if( isDefined(self) && isAlive(self))
	{
		self.diequietly = true;
		self kill();
	}
}

color_trigger_watcher()
{
	triggers_1 = GetEntArray("commander_color_trig_1","script_noteworthy");
	
	array_wait_any(triggers_1,"trigger");
	foreach(trigger in triggers_1)
	{
		trigger trigger_off();
	}
	
	triggers_2 = GetEntArray("hallway_clear_ally_position","targetname");
	array_wait_any(triggers_2,"trigger");
	foreach(trigger in triggers_2)
	{
		trigger trigger_off();
	}
}

try_move_commander_through_dining_room()
{
	wait_till_no_enemies_in_dining_room();
	
	//level.commander thread dialogue_queue("hijack_cmd_roomclear");
	
	flag_wait("lower_level_rumble_room_2");
	try_activate_trigger_targetname("room_2_clear_ally_position");
}

wait_till_no_enemies_in_dining_room()
{
	dining_room_covering_trig = GetEnt("dining_room_covering_trig","targetname");
	all_terrorists = GetEntArray("terrorist","script_noteworthy");
	
	num_enemies_in_room = -1;
	while(num_enemies_in_room != 0)
	{
		num_enemies_in_room = 0;
		enemies_in_room = dining_room_covering_trig get_ai_touching_volume();
		foreach(enemy in enemies_in_room)
		{
			if ( IsEnemyTeam(level.player.team,enemy.team) )
		    {
		    	num_enemies_in_room++;
		    }
		}
		wait(0.25);
	}
}
post_zerog_vo()
{
	//They have the daughter in the cargo bay.
	//radio_dialogue( "hijack_fso3_theyhave" );
	//Team 3, backup is on the way.
	//level.commander thread dialogue_queue( "hijack_cmd_backuponway" );
}

commander_initial_moves()
{
	level.commander.ignoreme = true;
	level.commander.ignoreall = true;
	commander_bottom_level = getnode( "commander_to_bottom_level", "targetname" );
	level.commander setgoalnode( commander_bottom_level );
	
	//thread post_zerog_vo();

	level.commander waittill("goal");
	level.commander.ignoreme = false;
	level.commander.ignoreall = false;
	level.commander.ignoresuppression = true;	
	level.commander.allowpain = false;
	
	flag_wait("move_commander_to_first_node");

	if ( isdefined(level.commander) )
	{
		level.commander enable_ai_color_dontmove();
		
		side = RandomFloatRange(0,1);
		if ( side < 0.5 )
		{
			// left side
			left_node_bottom = GetNode("bottom_stairs_left","targetname");
			level.commander SetGoalNode(left_node_bottom);
			
			flag_wait("move_commander_to_second_node");
			left_node_room = GetNode("first_room_left","targetname");
			level.commander SetGoalNode(left_node_room);
			//level.commander.ignoresuppression = false;
			level.commander.allowpain = true;
		}
		else
		{
			//right side
			right_node_bottom = GetNode("bottom_stairs_right","targetname");
			level.commander SetGoalNode(right_node_bottom);
			
			flag_wait("move_commander_to_second_node");
			right_node_room = GetNode("first_room_right","targetname");
			level.commander SetGoalNode(right_node_room);
			//level.commander.ignoresuppression = false;
			level.commander.allowpain = true;
		}		
	}
}

lower_level_dead_allies()
{
	allies = array_spawn_targetname("lower_level_dead_allies");
	
	foreach (ally in allies)
	{
		ally.diequietly = true;
		ally.delete_on_death = false;
		ally kill();
	}
}

lower_level_radio_chatter()
{
	level endon( "exited_dining_room" );
	
	level.lower_radio_org = spawn( "script_origin", level.player.origin );
	level.lower_radio_org linkto( level.player );
	level.lower_radio_org.linked = true;
	
	background_chatter( "hijack_fso1_sitrep", level.lower_radio_org );
	wait(0.3);
	background_chatter( "hijack_fso1_shotsfired", level.lower_radio_org );
	wait(0.75);
	background_chatter( "hijack_fso2_altered", level.lower_radio_org );
	wait(0.1);
}

comm_room_background_chatter()
{
	level.comm_radio_org = spawn( "script_origin", (-28228, 12674, 7172) );
	//level.comm_radio_org linkto( level.player );
	//level.comm_radio_org.linked = true;
	
	background_chatter( "hijack_fc1_descended", level.comm_radio_org );
	background_chatter( "hijack_fc2_kgbandfso", level.comm_radio_org );
	background_chatter( "hijack_fc1_squawking", level.comm_radio_org );
	background_chatter( "hijack_fc2_heading", level.comm_radio_org );
	background_chatter( "hijack_fc1_scrambling", level.comm_radio_org );
	background_chatter( "hijack_fc2_doyoucopy", level.comm_radio_org );
	background_chatter( "hijack_fc1_notresponding", level.comm_radio_org );
	background_chatter( "hijack_fc2_rapidrate", level.comm_radio_org );
	background_chatter( "hijack_fc1_slowdescent", level.comm_radio_org );
	level.comm_radio_org.deleteme = true;
}

lower_level_cleanup_cockpit()
{
	flag_wait("all_hallway_terrorists_dead");
	
	level.zerog_agent_01 stop_magic_bullet_shield();
	level.zerog_agent_01.diequietly = true;
	level.zerog_agent_01.allowdeath = true;
	level.zerog_agent_01.deathfunction = undefined;
	level.zerog_agent_01 kill();

	level.zerog_agent_02 stop_magic_bullet_shield();
	level.zerog_agent_02.diequietly = true;
	level.zerog_agent_02.allowdeath = true;
	level.zerog_agent_02.deathfunction = undefined;
	level.zerog_agent_02 kill();
	
	level.zerog_agent_03 stop_magic_bullet_shield();
	level.zerog_agent_03.diequietly = true;
	level.zerog_agent_03.allowdeath = true;
	level.zerog_agent_03.deathfunction = undefined;
	level.zerog_agent_03 kill();
	
	level.fire_extinguisher delete();
}

lower_level_objectives()
{
	bottom_of_stairs_struct = GetStruct("bottom_of_stairs","targetname");
	objective_add( obj("secure_daughter"), "current", &"HIJACK_OBJ_DAUGHTER", bottom_of_stairs_struct.origin );
	
	flag_wait("player_reached_bottom_of_stairs");
	daughter_position_struct = GetStruct("daughter_lower_level","targetname");
	objective_position(obj("secure_daughter"), daughter_position_struct.origin);

	flag_wait( "agent_reached_comm_room" );
	objective_complete( obj("secure_daughter"));
	
	flag_wait("commander_finished_find_daughter_anim");
	maps\hijack_crash::crash_objectives();
}

game_over_if_player_waits_too_long()
{
	level endon("planecrash_approaching");
	
	wait(300);
	setDvar( "ui_deadquote", &"HIJACK_FAIL_CRASH" );
	level notify( "mission failed" );
	missionFailedWrapper();
}

enemies_stumble(advance_vol)
{
	ai_array = GetAIArray();
	
	crouch_count = 0;
	stand_count = 0;
	
	foreach ( enemy in ai_array )
	{		
		if ( guy_is_defined_and_alive(enemy) && IsEnemyTeam( level.player.team,enemy.team ) && ( !IsDefined( enemy.dont_stumble ) || !enemy.dont_stumble ) )
	    {
			if ( enemy.a.pose == "crouch" )
			{
				if ( crouch_count % 2 == 1 )
				{
					enemy thread enemy_stumble_single("hijack_generic_stumble_crouch2", advance_vol);
				}
				else
				{
					enemy thread enemy_stumble_single("hijack_generic_stumble_crouch1", advance_vol);
				}
				
				crouch_count += 1;
			}
			else if ( enemy.a.pose == "stand" )
			{
				if ( stand_count % 2 == 1 )
				{
					enemy thread enemy_stumble_single("hijack_generic_stumble_stand2", advance_vol);
				}
				else
				{
					enemy thread enemy_stumble_single("hijack_generic_stumble_stand1", advance_vol);
				}
				
				stand_count += 1;
			}
	    }
	}
	
	if ( !is_specialop() )
	{
		level.commander thread anim_generic(level.commander,"hijack_generic_stumble_stand1");
	}
}

enemy_stumble_single(anim_name, advance_vol)
{
	self endon("death");
	
	wait(RandomFloat(0.75));
	
	if ( guy_is_defined_and_alive(self) )
	{
		if ( self.a.pose == "crouch" || self.a.pose == "stand" )
		{
			self.allowdeath = true;
			self.deathFunction = ::only_ragdoll;
			anim_generic(self,anim_name);
			self.deathFunction = undefined;
		}
	} 
}

guy_is_defined_and_alive(guy)
{
	return ( IsDefined(guy) && IsAlive(guy) && !(guy doingLongDeath()) && guy.a.nodeath == false );
}

lower_level_rumbles()
{
	flag_wait("lower_level_rumble_room_2");
	flag_wait_or_timeout("force_bar_rumble",8);
	
	bar_terrorist = spawn_targetname("diningroom_terrorist_bar");
	bar_terrorist thread lower_clean_up();
	bar_terrorist.animname = "generic";
	bar_terrorist.health = 50;
	bar_terrorist.dont_stumble = true;
	level.door_terrorist = spawn_targetname("diningroom_terrorist_door");
	level.door_terrorist thread lower_clean_up();
	level.door_terrorist.animname = "generic";
	level.door_terrorist.health = 50;
	level.door_terrorist.dont_stumble = true;
	level.door_terrorist visibleSolid();
	anim_start = GetStruct("dining_room_anim_start","targetname");
	anim_start.angles = (0,0,0);
	anim_start thread anim_single_solo(bar_terrorist,"hijack_diningroom_bar_terrorist");
	anim_start thread anim_single_solo(level.door_terrorist,"hijack_diningroom_door_terrorist");
	thread allow_stumbling_terrorists_to_die(bar_terrorist,level.door_terrorist);
	
	wait(1);
	flag_set( "stop_constant_shake" );
	aud_send_msg("jet_roll_v01");
	aud_send_msg("turbine_wind_a");
	earthquake( .30, 5.5, level.player.origin, 80000 );
	level.player PlayRumbleOnEntity( "hijack_plane_large" );
	thread dining_room_lurch();
	//array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, 25.0), 0.2, 0, 0 );
	//LerpSunAngles( level.orig_sundirection, (-25, 114, 0) , .2, 0, 0);
	//level.player ViewKick(127,level.player.origin + (0,0,-220));
	
	level.custom_linkto_slide = true;
	angles = ( 7, 90, 0 );
	forward = AnglesToForward( angles );
	level.player SetVelocity( forward * 110 );
	level.player hjk_BeginSliding();
	
	thread enemies_stumble();

	wait(0.2);
	objects_1 = GetEntArray("lower_level_room_1_objects","targetname");
	foreach (object in objects_1)
	{
		object thread launch_object( RandomIntRange(200,240),( 0 , 1 , 0 ));
	}

	phys_explosion_origins = GetEntArray( "bar_room_physics", "targetname" );
	foreach (object in phys_explosion_origins)
	{
		object thread start_phys_explosion_on_delay(64,64,0.65);
	}
	
	wait(1);
	level.player hjk_EndSliding();
	wait(1);
	//array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, -10), 3, 0, 0 );
	//LerpSunAngles( (-25, 114, 0), (-10, 114, 0) , 3, 0, 0);
	wait(3.75);
	array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, 0), 1, 0, 0 );
	//LerpSunAngles( (-10, 114, 0), level.orig_sundirection , 1, 0, 0);
	
	wait(1);
	flag_clear("stop_constant_shake");
	thread constant_rumble();
	
	flag_wait("lower_level_rumble_hallway");
	flag_set( "stop_constant_shake" );
	aud_send_msg("rumble_boom");
	earthquake( .33, 2.0, level.player.origin, 80000 );
	level.player PlayRumbleOnEntity( "hijack_plane_medium" );
	
	wait(2.0);
	flag_clear("stop_constant_shake");
	thread constant_rumble();
	
	level.commander waittillmatch( "single anim", "plane_shifts" );
	flag_set( "stop_constant_shake" );
	aud_send_msg("rumble_boom");
	earthquake( .30, 4.5, level.player.origin, 80000 );
	level.player PlayRumbleOnEntity( "hijack_plane_large" );
	aud_send_msg("jet_roll_v02");
	aud_send_msg("turbine_wind_b");
	//array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, -35.0), 0.5, 0, 0 );
	thread cargo_room_lurch();
	//thread cargo_room_rumbles();
	//flickering lights in crash room
	thread maps\hijack_crash_fx::handle_crash_lights();
	ResetSunDirection();
		
	//level.commander waittillmatch( "single anim", "plane_shifts" );
	//wait(0.2);
	//level.player ViewKick(127,level.player.origin + (0,0,-220));
	thread cargo_move_props();
	
	level.commander waittillmatch( "single anim", "plane_shift_player" );
	level.player DisableWeapons();
	
	if ( !flag("no_player_slide") )
	{
		level.custom_linkto_slide = true;
		angles = ( 7, 90, 0 );
		forward = AnglesToForward( angles );
		level.player SetVelocity( forward * 140 );
		level.player hjk_BeginSliding();
		
		wait(1.0);
		level.player hjk_EndSliding();
	}
	else
	{
		wait(1.0);
	}
	level.player EnableWeapons();
	wait(1.0);
	//array_thread( level.aRollers, ::rotate_rollers_to, (0, 0, 0), 2.5, 0, 0 );
}

allow_stumbling_terrorists_to_die(terrorist1,terrorist2)
{
	terrorist1.deathFunction = ::only_ragdoll;
	terrorist2.deathFunction = ::only_ragdoll;
	
	wait(2.5);
	terrorist1.allowdeath = true;
	if ( terrorist1.health == 1 )
	{
		terrorist1 DoDamage(1,level.player.origin,level.player);
	}
	
	terrorist2.allowdeath = true;
	if ( terrorist2.health == 1 )
	{
		terrorist2 DoDamage(1,level.player.origin,level.player);
	}
	
	wait(1.7);
	terrorist2.deathFunction = undefined;
	
	wait(0.2);
	terrorist1.deathFunction = undefined;
}

only_ragdoll()
{
	self startragdoll();
}


dining_room_lurch()
{
	//flag_set("stop_rocking");
	level notify("stop_rocking");
	aud_send_msg("hallway_lurch", true); 
	
	view_roller = spawn_anim_model( "upperhall_roller", level.player.origin);
	view_roller.angles = (0, 0, 0);

	player_ref = spawn( "script_origin", level.player.origin );
	player_ref.angles = (0, 0, 0);
	
	level.player playerSetGroundReferenceEnt( player_ref );
	view_roller anim_first_frame_solo( view_roller, "hallway_lurchcam" );
	player_ref linkto( view_roller , "J_prop_1" );
	//level.player PlayRumbleOnEntity( "hijack_plane_medium" );
	view_roller thread anim_single_solo( view_roller, "hallway_lurchcam" );
	
	view_roller waittillmatch( "single anim", "corpse_slump");
	thread hallway_sun();
	//thread hallway_player_slide();
	array_thread( level.aRollers, ::hallway_view_roll_obj);
	
	view_roller waittillmatch( "single anim", "end");
	
	level.player playerSetGroundReferenceEnt( level.org_view_roll );
		
	player_ref delete();
	view_roller delete();	
}

cargo_room_lurch()
{
	//flag_set("stop_rocking");
	level notify("stop_rocking");
	//array_thread( level.aRollers, ::debate_view_roll_obj);
	cargo_roller = spawn_anim_model( "upperhall_roller", level.player.origin);
	cargo_roller.angles = (0, 0, 0);
	player_ref = spawn( "script_origin", level.player.origin );
	player_ref.angles = (0, 0, 0);
	
	level.player playerSetGroundReferenceEnt( player_ref );
	cargo_roller anim_first_frame_solo( cargo_roller, "hallway_lurchcam" );
	player_ref linkto( cargo_roller , "J_prop_1" );
	cargo_roller anim_single_solo( cargo_roller, "hallway_lurchcam" );
	
	//level.player playerSetGroundReferenceEnt( level.org_view_roll );
	//thread RockingPlane();
	
	//player_ref delete();
	//cargo_roller delete();

	cargo_roller anim_loop_solo( cargo_roller, "hallway_lurchcam_loop", "stop_hallway_shake" );
	should_rumble = true;
	while (!flag("player_left_cargo_room"))
	{
		aud_send_msg("rumble_boom");
		//earthquake( .22, 2, level.player.origin, 80000 );
		if ( should_rumble )
		{
			level.player PlayRumbleOnEntity( "hijack_plane_medium" );
		}
		should_rumble = !should_rumble;
		//wait(RandomFloatRange(3,5));
	}
	
	level notify( "stop_hallway_shake" );
	//player_ref delete();
	cargo_roller delete();
}

cargo_props_prep()
{
	door_1 = getEnt( "cargo_door01", "targetname" );
	door_1 RotateYaw( 75, .05 );
	door_2 = getEnt( "cargo_door02", "targetname" );
	door_2 RotateYaw( -60, .05 );
	door_3 = getEnt( "cargo_door03", "targetname" );
	door_3 RotateYaw( 60, .05 );
	door_4 = getEnt( "cargo_door04", "targetname" );
	door_4 RotateYaw( 15, .05 );
	door_5 = getEnt( "cargo_door05", "targetname" );
	door_5 RotateYaw( -45, .05 );
	door_6 = getEnt( "cargo_door06", "targetname" );
	door_6 RotateYaw( -52, .05 );
}

cargo_move_props()
{
	level.daughter_struct = GetStruct("cargo_room_anim_struct","targetname");
		
	cargo_strap1 = getEnt( "cargo_strap1", "targetname" );
	cargo_strap2 = getEnt( "cargo_strap2", "targetname" );
	door_1 = getEnt( "cargo_door01", "targetname" );
	door_2 = getEnt( "cargo_door02", "targetname" );
	door_3 = getEnt( "cargo_door03", "targetname" );
	door_4 = getEnt( "cargo_door04", "targetname" );
	door_5 = getEnt( "cargo_door05", "targetname" );
	door_6 = getEnt( "cargo_door06", "targetname" );
	large_box_1 = getEnt( "cargo_lg_box_01", "targetname" );
	large_box_2 = getEnt( "cargo_lg_box_02", "targetname" );
	large_box_3 = getEnt( "cargo_lg_box_03", "targetname" );
	large_box_4 = getEnt( "cargo_lg_box_04", "targetname" );
	large_box_5	= getEnt( "cargo_lg_box_05", "targetname" );
	large_box_6	= getEnt( "cargo_lg_box_06", "targetname" );
	//small_box_1 = getEnt( "cargo_sm_box_01", "targetname" );
	//small_box_2 = getEnt( "cargo_sm_box_02", "targetname" );
	small_box_3 = getEnt( "cargo_sm_box_03", "targetname" );
	ladder	= getEnt( "cargo_ladder", "targetname" );
	//bag	= getEnt( "cargo_bag", "targetname" );
	toolbox	= getEnt( "cargo_toolbox", "targetname" );
	propane_1 = getEnt( "cargo_propane01", "targetname" );
	//propane_2 = getEnt( "cargo_propane02", "targetname" );
	//propane_3 = getEnt( "cargo_propane03", "targetname" );
	propane_4 = getEnt( "cargo_propane04", "targetname" );

	cargo_strap1 delete();
	cargo_strap2 delete();
	door_1 thread cargo_room_prop( "J_prop_2", "prop_ladder_shift", "prop_ladder_loop", level.daughter_struct);
	door_2 thread cargo_room_prop( "J_prop_2", "prop_propane4_shift", "prop_propane4_loop", level.daughter_struct);
	door_3 thread cargo_room_prop( "J_prop_2", "prop_box1_shift", "prop_box1_loop", level.daughter_struct);
	door_4 thread cargo_room_prop( "J_prop_2", "prop_bag_shift", "prop_bag_loop", level.daughter_struct);
	door_5 thread cargo_room_prop( "J_prop_2", "prop_sm_box2_shift", "prop_sm_box2_loop", level.daughter_struct);
	door_6 thread cargo_room_prop( "J_prop_2", "prop_propane1_shift", undefined, level.daughter_struct);
	large_box_1 thread cargo_room_prop( "J_prop_1", "prop_box1_shift", undefined, level.daughter_struct);
	large_box_2 thread cargo_room_prop( "J_prop_1", "prop_box2_3_shift", undefined, level.daughter_struct);
	large_box_3 thread cargo_room_prop( "J_prop_2", "prop_box2_3_shift", undefined, level.daughter_struct);
	large_box_4 thread cargo_room_prop( "J_prop_2", "prop_toolbox_shift", undefined, level.daughter_struct);
	large_box_5 thread cargo_room_prop( "J_prop_2", "prop_sm_box1_shift", undefined, level.daughter_struct);
	large_box_6 thread cargo_room_prop( "J_prop_2", "prop_smbox3_lg6_shift", undefined, level.daughter_struct);
	//small_box_1 thread cargo_room_prop( "J_prop_1", "prop_sm_box1_shift", "prop_sm_box1_loop", level.daughter_struct);
	//small_box_2 thread cargo_room_prop( "J_prop_1", "prop_sm_box2_shift", "prop_sm_box2_loop", level.daughter_struct);
	small_box_3 thread cargo_room_prop( "J_prop_1", "prop_smbox3_lg6_shift", undefined, level.daughter_struct);
	ladder thread cargo_room_prop( "J_prop_1", "prop_ladder_shift", "prop_ladder_loop", level.daughter_struct);
	//bag	thread cargo_room_prop( "J_prop_1", "prop_bag_shift", "prop_bag_loop", level.daughter_struct);
	toolbox	thread cargo_room_prop( "J_prop_1", "prop_toolbox_shift", undefined, level.daughter_struct);
	propane_1 thread cargo_room_prop( "J_prop_1", "prop_propane1_shift", undefined, level.daughter_struct);
	//propane_2 thread cargo_room_prop( "J_prop_1", "prop_propane2_3_shift", "prop_propane2_3_loop", level.daughter_struct);
	//propane_3 thread cargo_room_prop( "J_prop_2", "prop_propane2_3_shift", "prop_propane2_3_loop", level.daughter_struct);
	propane_4 thread cargo_room_prop( "J_prop_1", "prop_propane4_shift", "prop_propane4_loop", level.daughter_struct);
}

cargo_room_prop(joint, prop_anim, prop_anim_loop, anim_ref)
{
	rig = spawn_anim_model("cargo");
	waittillframeend;
	
	anim_ref anim_first_frame_solo( rig, prop_anim );
	self linkto( rig , joint );
	
	anim_ref anim_single_solo( rig, prop_anim );
	if ( IsDefined( prop_anim_loop ))
	{
		anim_ref anim_loop_solo( rig, prop_anim_loop );
	}
	flag_wait_or_timeout( "kill_cargo", 300 );
	
	self unlink();
	rig Delete();
	self Delete();
}

lower_level_runners(runner_name)
{
	runner = spawn_targetname(runner_name);
	runner thread lower_clean_up();
	runner.goalradius = 24;
	runner magic_bullet_shield();
	runner thread player_damage_watcher("start_" + runner_name);
	
	if ( !IsDefined(level.runners) )
	{
		level.runners = [];
	}
	level.runners[level.runners.size] = runner;

	flag_wait("start_" + runner_name);
	//runner.ignoreall = true;
	wait(1);
	if ( isalive(runner) )
	{
		runner stop_magic_bullet_shield();
	
		node = GetNode(runner_name + "_target","targetname");
		runner SetGoalNode(node);
		
		runner waittill("goal");
	}
	
	flag_wait("spawn_second_room_first_wave");
	wait(2.5);
	if ( isalive(runner) )
	{
		node = GetNode(runner_name + "_target_2","targetname");
		runner SetGoalNode(node);
		
		//runner.ignoreall = false;
		//runner set_forcegoal();
		runner GetEnemyInfo(level.player);
		runner GetEnemyInfo(level.commander);
	}
}

// if player damages a runner, start him going
player_damage_watcher(flag_to_set)
{
	self endon("death");
	self endon("stop_damage_watcher");
	
	while(1)
	{
		self waittill("damage",amount,attacker);
		
		if ( attacker == level.player )
		{
			flag_set(flag_to_set);
			self notify("stop_damage_watcher");
		}
	}
}

glass_watcher()
{
	// move_commander_to_comm_room flag is used in this function as a failsafe, if the player goes through the room without looking at the glass
	flag_wait_any("allow_glass_to_break","move_president_to_comm_room");

	clip = GetEnt("glass_blocking_clip","targetname");
	center_of_glass_origin_right = GetStruct("center_of_glass_origin_right","targetname");
	center_of_glass_origin_left = GetStruct("center_of_glass_origin_left","targetname");
	
	player_can_see_glass = false;
	while(!player_can_see_glass && !flag("move_president_to_comm_room"))
	{
		wait(0.5);
		can_see_right = BulletTracePassed(level.player.origin+(0,0,24),center_of_glass_origin_right.origin,false,clip);
		can_see_left = BulletTracePassed(level.player.origin+(0,0,24),center_of_glass_origin_left.origin,false,clip);
		player_can_see_glass = can_see_right || can_see_left;
	}
	wait(0.5);
	clip delete();
}

agent_and_president_movement()
{
	civilians = [];
	civilians[0] = level.hero_agent_01;
	civilians[1] = level.president;
	level.president set_forcegoal();
	level.hero_agent_01 set_forcegoal();
	
	flag_wait("move_president_to_first_room");
	level.hero_agent_01.disablearrivals = true;
	level.hero_agent_01.script_pushable = false;
	agent_node = GetNode("agent_bottom_stairs","targetname");
	level.hero_agent_01 SetGoalNode(agent_node);
	//level.commander thread dialogue_queue("hijack_cmd_protectpres");
	//level.hero_agent_01 thread dialogue_queue("hijack_fso1_thiswaysir");
	wait(1);
	president_node = GetNode("president_first_room","targetname");
	level.president SetGoalNode(president_node);
	
	array_wait(civilians,"goal");
	flag_wait("move_president_to_second_room_start");
	wait_till_no_enemies_in_dining_room();
	level.hero_agent_01.script_pushable = true;
	agent_node = GetNode("agent_second_room_start","targetname");
	level.hero_agent_01 SetGoalNode(agent_node);
	//level.hero_agent_01 thread dialogue_queue("hijack_fso1_keepmoving");
	wait(1);
	president_node = GetNode("president_second_room_start","targetname");
	level.president SetGoalNode(president_node);

	//flag_wait("move_president_to_second_room_middle");
	//level.hero_agent_01.disablearrivals = false;
	//agent_node = GetNode("agent_second_room_middle","targetname");
	//level.hero_agent_01 SetGoalNode(agent_node);
	//wait(1);
	//president_node = GetNode("president_second_room_middle","targetname");
	//level.president SetGoalNode(president_node);
	
	array_wait(civilians,"goal");
	flag_wait("move_president_to_hallway");
	level.hero_agent_01.disablearrivals = false;
	agent_node = GetNode("agent_hallway","targetname");
	level.hero_agent_01 SetGoalNode(agent_node);
	wait(1);
	president_node = GetNode("president_hallway","targetname");
	level.president SetGoalNode(president_node);
	
	array_wait(civilians,"goal");
	//flag_wait_any("move_president_to_comm_room","all_cargo_room_terrorists_dead");
	flag_wait("move_president_to_comm_room");
	agent_node = GetNode("agent_comm_room","targetname");
	level.hero_agent_01 SetGoalNode(agent_node);
	//level.hero_agent_01 thread dialogue_queue("hijack_fso1_keepgoing");
	wait(1);
	president_node = GetNode("president_comm_room","targetname");
	level.president SetGoalNode(president_node);

	array_wait(civilians,"goal");
	wait(1);
	flag_set("agent_reached_comm_room");
}

find_daughter_commander_anims()
{
	anim_struct = GetStruct("cargo_room_anim_struct","targetname");
	level.commander disable_ai_color();

	level.commander forceUseWeapon( "ak74u", "primary" );
	level.commander.lastWeapon = level.commander.weapon;	// needed to avoid errors later
	
	anim_struct anim_single_solo(level.commander,"find_daughter_enter");
	flag_set("commander_finished_find_daughter_anim");
	anim_struct thread anim_loop_solo(level.commander,"find_daughter_commander_loop" ); 

	//flag_wait("player_is_in_crash_room");
	//anim_struct notify( "comm_go_to_sled" );
	
	//commander_node = GetNode("commander_wait_door_node","targetname");	
	//level.commander SetGoalNode(commander_node);
}

find_daughter_agent_anims()
{
	anim_struct = GetStruct("cargo_room_anim_struct","targetname");
	level.hero_agent_01 disable_ai_color();
	
	level.commander waittillmatch( "single anim", "plane_shifts" );	
	level.hero_agent_01 anim_single_solo( level.hero_agent_01, "hijack_generic_stumble_stand1");
	
	anim_struct anim_reach_solo( level.hero_agent_01, "find_daughter_enter" );
	anim_struct thread anim_single_solo( level.hero_agent_01, "find_daughter_enter" );
	thread radio_dialogue("hijack_plt_emergency");
	//wait(.5);
	
	//level.hero_agent_01 waittillmatch( "single anim", "plane_shifts" );
	
	//flickering lights in crash room
	//thread maps\hijack_crash_fx::handle_crash_lights();
	
	//wait(4);
	//have the agent open the door
	maps\hijack_crash::open_cargo_door();
	flag_set( "turn_on_crash_sled_lights" );
	
	hero_agent_node = GetNode("hero_agent_crash_node","targetname");
	level.hero_agent_01 SetGoalNode(hero_agent_node);	
	level.hero_agent_01.disablearrivals = true;	//don't do a lengthy stop here
}

daughter_death()
{
	SetDvar( "ui_deadquote", &"HIJACK_MISSIONFAIL_ALENA" );	// You shot a civilian. Watch your fire!
	thread maps\_utility::missionFailedWrapper();
}

cargo_room_daughter_seen()
{
	flag_wait_any( "daughter_thrown_left", "daughter_thrown_right" );
	
	level.daughter = spawn_targetname( "find_daughter_pre_crash" );
	level.daughter.allowdeath = true;
	if(IsDefined (level.daughter.magic_bullet_shield))
	{
		level.daughter stop_magic_bullet_shield();
	}
	level.daughter.deathfunction = ::daughter_death;
	
	cargo_room_terrorists_b = array_spawn_targetname("cargo_room_terrorists_b");  //trying spawing them in daughter_seen function.
	thread ai_array_killcount_flag_set(cargo_room_terrorists_b, cargo_room_terrorists_b.size, "all_cargo_room_terrorists_dead");
	
	triggers = GetEntArray( "daughter_triggers", "targetname" );
	array_delete( triggers );
			
	hijacker = get_living_ai( "daughter_terrorist", "script_noteworthy" );
	hijacker.animname = "generic";
	hijacker.ignoreme = true;
	hijacker.ignoreall = true;
	
	guys = [];
	guys[0] = level.daughter;
	guys[1] = hijacker;
	
	//level.daughter_struct notify("stop_loop");
	
	if( flag( "daughter_thrown_right" ))
	{
		level.daughter_struct thread anim_single( guys, "pre_find_daughter_short" );
	}
	else
	{
		level.daughter_struct thread anim_single( guys, "pre_find_daughter" );
	}
	hijacker waittillmatch( "single anim", "done_throwing" );
	hijacker.allowdeath = true;
	level.daughter waittillmatch( "single anim", "end" );
	
	if( IsAlive( hijacker ))
	{
		hijacker.ignoreme = false;
		hijacker.ignoreall = false;
	}
	
	level.daughter_struct thread anim_loop_solo( level.daughter, "daughter_cry_loop" );
}

find_daughter_moment()
{
	level.daughter_struct = GetStruct("cargo_room_anim_struct","targetname");
	
	//level.daughter = spawn_targetname( "find_daughter_pre_crash" );
	//level.daughter_struct thread anim_loop_solo(level.daughter,"daughter_cry_loop");
	
	flag_wait("cargo_room_commander_move");
	level.commander.baseAccuracy = 1.0;
	level.daughter_struct anim_reach_solo( level.commander, "find_daughter_enter" );
	
	flag_wait_all("all_cargo_room_terrorists_dead", "cargo_room_wave_a_dead", "agent_reached_comm_room" );
	//level.comm_radio_org.deleteme = true;
	
	aud_send_msg("cargo_room_zone_on");
	
	agent_node = GetNode("agent_pre_daughter_node","targetname");
	level.hero_agent_01 SetGoalNode(agent_node);
	//president_node = GetNode("president_pre_daughter_node","targetname");
	//level.president SetGoalNode(president_node);
	//commander_node = GetNode("commander_pre_daughter_node1","targetname");
	//level.commander SetGoalNode(commander_node);
	
	//pres_and_agent = [];
	//pres_and_agent[0] = level.president;
	//pres_and_agent[1] = level.hero_agent_01;
	//array_wait(pres_and_agent,"goal",10);
	level.daughter_struct anim_reach_solo( level.president, "find_daughter_enter" );
	
	level.daughter_struct notify("stop_loop");
	
	thread find_daughter_commander_anims();
	thread find_daughter_agent_anims();

	pres_and_daughter = [];
	pres_and_daughter[0] = level.president;
	pres_and_daughter[1] = level.daughter;
	
	level.daughter_struct anim_single(pres_and_daughter,"find_daughter_enter");
	level.daughter_struct thread anim_loop(pres_and_daughter,"post_find_loop");
	
	flag_set("find_daughter_moment_finished");
	aud_send_msg("cargo_room_zone_off");
	
	level waittill("crash_impact");
	level.daughter_struct notify("stop_loop");
}

end_commander_with_daughter_loop()
{
	level waittill("planecrash_approaching");
	
	//if we don't stop the loop, then the commander seems to always teleport back into it at the end
	self notify("stop_loop");
}

/*---------------------------------------------------
	
	            End of Lower Level Combat
	
----------------------------------------------------*/
	

stop_combat()
{

	//level.player.ignoreme = true;
	//level.advisor.ignoreme = true;
	level.commander.ignoreme = true;
	level.hero_agent_01.ignoreme = true;
		
	/*level.end_of_plane_spawners = array_removedead_or_dying( level.end_of_plane_spawners );
	foreach(level.end_of_plane_spawners in level.end_of_plane_spawners)
	{
		level.end_of_plane_spawners.ignoreme = true;
	}*/
}

airplane_cleanup()
{
	flag_set( "stop_phones" );
	
	level.player.ignoreme = false;
	//level.advisor.ignoreme = false;
	level.commander.ignoreme = false;
	
	//level.hero_agent_01 stop_magic_bullet_shield();
	//level.hero_agent_01 Delete();
	if(isdefined(level.zerog_agent_01))
	{
		level.zerog_agent_01 stop_magic_bullet_shield();
		level.zerog_agent_01.deathfunction = undefined;
		level.zerog_agent_01 Delete();
	}
	
	if(isdefined(level.daughter))
	{
		if(IsDefined (level.daughter.magic_bullet_shield))
		{
			level.daughter stop_magic_bullet_shield();
		}	
		level.daughter delete();
	}
	
	if(isdefined(level.advisor))
	{
		level.advisor stop_magic_bullet_shield();
		level.advisor delete();
	}
	
	if(isdefined(level.president))
	{
		level.president stop_magic_bullet_shield();
		level.president.deathfunction = undefined;
		level.president delete();
	}
	
	flag_set( "kill_cargo" );
	
	/*foreach(ent in level.volumetric_window_fx)
	{
		StopFXOnTag(getfx("window_volumetric"), ent, "tag_origin");		
	}
	array_remove_array(level.aRollers, level.volumetric_window_fx);
	array_delete(level.volumetric_window_fx_ents);
	array_delete(level.volumetric_window_fx);*/
	
		
	/*level.end_of_plane_spawners = array_removedead_or_dying( level.end_of_plane_spawners );
	
	foreach(level.end_of_plane_spawners in level.end_of_plane_spawners)
	{
		level.end_of_plane_spawners Delete();
	}*/
}
