#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;
#include maps\_vehicle;
#include maps\_objectives;

#define CLIENT_FLAG_MOVER_EXTRA_CAM 1

skipto_house()
{
	skipto_setup();
	start_teleport_players("player_skipto_house");
}

main()
{	
	flag_wait( "panama_gump_1" );
	
	init_player();
	house_event();
	
	flag_wait( "house_event_end" );
	
	load_gump( "panama_gump_2" );
	
}

init_player()
{
	level.player SetMoveSpeedScale( 0.35 );
	level.player AllowSprint( false );

	level.player thread take_and_giveback_weapons( "house_event_end" );

	level.player SetClientDvar( "compass", 0 );
	level.player SetClientDvar( "hud_showstance", "0" );
	
	SetSavedDvar( "cg_drawCrosshair", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showStance", "0" );
}

init_casual_hero()
{
	self endon( "death" );
	
	self make_hero();		
	self gun_remove();
	self.ignoreme = true;
	self.ignoreall = true;
}

house_event()
{
	level thread street_fail_condition();
	
	level thread house_skinner_and_jane();
	level thread house_mason();
	
	trig_front_gate = GetEnt( "trig_front_gate", "script_noteworthy" );
	trig_front_gate trigger_off();

	trig_use_shed_door = GetEnt( "trig_use_shed_door", "targetname" );
	trig_use_shed_door trigger_off();
	
	trig_shed_objective = GetEnt( "trig_shed_objective", "script_noteworthy" );
	trig_shed_objective trigger_off();
	
	//spawn vehicles
	vh_player_humvee = spawn_vehicle_from_targetname( "vh_player_humvee" );
	vh_mason_humvee = spawn_vehicle_from_targetname( "vh_mason_humvee" );                                              
	
	run_scene( "player_exits_hummer" );	

	autosave_now( "front_house" );
	
	flag_set( "house_meet_mason" );

	flag_wait( "start_shed_obj" );
	
	trig_use_shed_door trigger_on();
	trigger_wait( "trig_use_shed_door" );
	trig_use_shed_door Delete();
	
	flag_set( "player_opened_shed" );
	
	delay_thread( 0.2, ::open_shed_doors );
	
	turn_on_reflection_cam();
	
	level thread run_scene( "fake_woods_grabs_bag" );
	run_scene( "player_grabs_bag" );

	turn_off_reflection_cam();
	
	flag_set( "player_frontyard_obj" );
	
	flag_wait( "trig_player_exit" );
	level notify( "player_frontyard_anim" );

	delay_thread( 3.5, ::open_back_gate );	
	level thread run_scene( "player_frontyard_walk" );
	level thread run_scene( "skinner_frontyard_walk" );
	level thread run_scene( "mason_frontyard_walk" );
	
	trig_spawn_panama_uaz = GetEnt( "trig_spawn_panama_uaz", "targetname" );
	trig_spawn_panama_uaz notify( "trigger" );
	
	wait 5;

	flag_set( "show_introscreen_title" );
	
	panamanian_tagger = simple_spawn_single( "panamanian_tagger" );
	panamanian_tagger.goalraidus = 32;
	nd_tagger_node = GetNode( panamanian_tagger.target, "targetname" );
	panamanian_tagger SetGoalNode( nd_tagger_node );
	panamanian_tagger waittill( "goal" );
	panamanian_tagger Delete();
		
	//vh_panamanian_jeep = spawn_vehicle_from_targetname( "vh_panamanian_jeep" );
	//vh_panamanian_jeep SetSpeedImmediate( 0 );
	
	wait( 2 );
	
	trig_move_panama_uaz = GetEnt( "trig_move_panama_uaz", "targetname" );
	getent("vh_panamanian_jeep", "targetname") PlaySound("evt_truck_pull_away");
	trig_move_panama_uaz notify( "trigger" );
	
	//vh_panamanian_jeep ResumeSpeed( 30 );
	
	//nd_panamanian_jeep_start = getvehiclenode( "nd_panamanian_jeep_start", "targetname" );
	//vh_panamanian_jeep getonpath( nd_panamanian_jeep_start );
	
//	level thread maps\_introscreen::introscreen_redact_delay( &"PANAMA_INTROSCREEN_TITLE", &"PANAMA_INTROSCREEN_PLACE", &"PANAMA_INTROSCREEN_TARGET", &"PANAMA_INTROSCREEN_TEAM", &"PANAMA_INTROSCREEN_DATE", 2, 10, 1.5, 1.8, 2 );

	wait( 4 );
	
	//set_screen_fade_timer( 4 );
	//screen_fade_out();

	level thread old_man_woods( "mid_flashpoint_2" );
	
	level.ai_mason_casual Delete();
	level.ai_skinner_casual_2 Delete();
		
	vh_player_humvee = GetEnt( "vh_player_humvee", "targetname" );
	vh_mason_humvee = GetEnt( "vh_mason_humvee", "targetname" );
	
	vh_player_humvee Delete();
	vh_mason_humvee Delete();
		
	a_ai = GetAIArray();
	foreach( ai in a_ai )
	{
		ai Delete();
	}	
		
	flag_set( "house_event_end" );
	level.player notify( "house_event_end" );
	
	level.player SetMoveSpeedScale( 1 );
	level.player AllowSprint( true );
		
	level.player SetClientDvar( "compass", 1 );
	level.player SetClientDvar( "hud_showstance", "1" );
	
	SetSavedDvar( "cg_drawCrosshair", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", "0" );
}

#define REFLECTION_WIDTH 30.5
#define REFLECTION_HEIGHT 22

turn_on_reflection_cam()
{
	SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );
	sm_cam_ent = GetEnt( "reflection_cam", "targetname" );
	
	level.e_tag_origin = Spawn( "script_model", sm_cam_ent.origin );
	level.e_tag_origin SetModel( "tag_origin" );
	level.e_tag_origin.angles = sm_cam_ent.angles;
	
	level.e_tag_origin SetClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
}

turn_off_reflection_cam()
{
	sm_cam_ent = GetEnt("reflection_cam", "targetname");
	
	level.e_tag_origin ClearClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
	level.e_tag_origin delay_thread( 2, ::self_delete );
	
	sm_cam_ent delay_thread( 2, ::self_delete );	
}

open_shed_doors()
{
	m_shed_door_right = GetEnt( "m_shed_door_right", "targetname" );
	m_shed_door_right RotateYaw( 85, 0.3, 0.15, 0 );

	wait 4;
	
	m_shed_door_right RotateYaw( -85, 0.3, 0.15, 0 );
}

open_back_gate()
{
	//open player gate
	m_back_gate = GetEnt( "m_back_gate", "targetname" );
	m_back_gate RotateYaw( 80, 0.5, 0.3, 0 );	
}

house_skinner_and_jane()
{
	level endon( "player_frontyard_anim" );
	
	//Skinner and Jane arguing
	ai_skinner_casual = simple_spawn_single( "ai_skinner_casual", ::init_casual_hero );
	ai_skinner_casual.animname = "skinner";
	
	ai_jane_window = simple_spawn_single( "ai_jane_window", ::init_casual_hero );
	ai_jane_window.animname = "jane";	
	
	level thread run_scene( "skinner_jane_argue_loop" );
	
	trigger_wait( "trig_mason_greet" );

	delay_thread( 8.3, ::open_front_door );
	run_scene( "skinner_waves_us_back" );
	
	flag_wait( "player_at_front_gate" );
	
	level.ai_skinner_casual_2 = simple_spawn_single( "ai_skinner_casual_2" );
	level.ai_skinner_casual_2.animname = "skinner";
	
	ai_jane_dog = simple_spawn_single( "ai_jane_dog" );
	ai_jane_dog.animname = "jane";
	level thread run_scene( "jane_gate" );
	
	run_scene( "skinner_with_beers" );
	level thread run_scene( "skinner_beer_loop" );
	
	flag_wait( "player_opened_shed" );	
	
	run_scene( "skinner_bag_anim" );
	level thread run_scene( "skinner_trashcan_loop" );
	
//	trigger_wait( "trig_player_frontyard_anim" );
	flag_wait( "trig_player_exit" );
	
	run_scene( "skinner_frontyard_walk" );
}

open_front_door()
{
	//open front door
	m_front_door = GetEnt( "m_front_door", "targetname" );
	m_front_door RotateYaw( 60, 0.5, 0.3, 0 ); 
	
	wait( 4 );
	
	m_front_door RotateYaw( -60, 0.5, 0.3, 0 ); 
}

house_mason()
{
	level endon( "player_frontyard_anim" );
	
	trigger_wait( "trig_mason_greet" );
	
	level.ai_mason_casual = simple_spawn_single( "ai_mason_casual", ::init_casual_hero );
	level.ai_mason_casual.animname = "mason";

	flag_set( "house_follow_mason" );
	
	level thread run_scene( "mason_hummer_scene" ); //the hummer
	run_scene( "mason_exits_hummer" );
	level thread run_scene( "mason_opens_gate_loop" );
	
	//Mason walks to gate and waits for player
	trig_front_gate = GetEnt( "trig_front_gate", "script_noteworthy" );
	trig_front_gate trigger_on();
	trig_front_gate waittill( "trigger" );
	flag_wait( "player_at_front_gate" );
	
	ai_skinners_dog = simple_spawn_single( "ai_skinners_dog" );
	ai_skinners_dog.animname = "skinners_dog";

	delay_thread( 0.2, ::open_front_gate );
	
	level thread run_scene( "dog_gate" );
	run_scene( "mason_opens_gate" );
	
	trig_shed_objective = GetEnt( "trig_shed_objective", "script_noteworthy" );
	trig_shed_objective trigger_on();
	
	level thread run_scene( "mason_beer_loop" );
	
	flag_wait( "player_opened_shed" );	
	
	run_scene( "mason_bag_anim" );
	level thread run_scene( "mason_trashcan_loop" );
	
//	trigger_wait( "trig_player_frontyard_anim" );
	flag_wait( "trig_player_exit" );
	
	run_scene( "mason_frontyard_walk" );
}

open_front_gate()
{
	//open gate
	m_front_gate = GetEnt( "m_front_gate", "targetname" );
	m_front_gate RotateYaw( 45, 0.5, 0.3, 0 ); 	
	
	wait( 4 );

	m_player_gate_clip = GetEnt( "m_player_gate_clip", "targetname" );
	m_player_gate_clip Delete();
	
	m_front_gate RotateYaw( 50, 0.5, 0.3, 0 ); 
}

init_house_flags()
{
	flag_init( "house_event_end" );
	flag_init( "house_follow_mason" );	
	flag_init( "house_meet_mason" );
	flag_init( "player_opened_shed" );
	flag_init( "player_frontyard_obj" );
	flag_init( "show_introscreen_title" );
}

street_fail_condition()
{
	level endon( "player_opened_shed" );
	
	trig_warn_player = GetEnt( "trig_warn_player", "targetname" );
	trig_fail_player = GetEnt( "trig_fail_player", "targetname" );

	trigger_wait( "trig_warn_player" );
	level.player display_hint( "street_warning" );
	
	trigger_wait( "trig_fail_player" );
	
	SetDvar( "ui_deadquote", &"PANAMA_STREET_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();	
}