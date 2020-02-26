#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;
#include maps\_objectives;
#include maps\_anim;

skipto_motel()
{
	skipto_setup();
	
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	start_teleport( "skipto_motel_player", a_hero );	

//	flag_set( "house_meet_mason" );
//	flag_set( "house_follow_mason" );
//	flag_set( "start_shed_obj" );
//	flag_set( "player_opened_shed" );
//	flag_set( "player_frontyard_obj" );
//	flag_set( "trig_player_exit" );
//	flag_set( "house_event_end" );
//	
//	//airfield
//	flag_set( "zodiac_approach_start" );
//	flag_set( "zodiac_approach_end" );
//	flag_set( "player_at_first_blood" );
//	flag_set( "player_contextual_start" );
//	flag_set( "parking_lot_gone_hot" );	
//	flag_set( "skinner_runway_dialogue" );
//	flag_set( "airfield_end" );
//	flag_set( "skinner_motel_dialogue" ); 
	
	//trigger_use( "trig_mason_to_motel" );
	flag_set( "trig_mason_to_motel" );
}

init_motel_flags()
{
	flag_init( "mason_at_motel" );
	flag_init( "motel_room_cleared" );	
	flag_init( "motel_scene_end" );
	flag_init( "start_intro_anims" );
	flag_init( "start_xcool_end" );
	flag_init( "player_breach_ready" );
	flag_init( "trig_mason_to_motel" );
}

main()
{	
	motel_breach_main();
	
	flag_wait( "motel_scene_end" );

	level.noriega magic_bullet_shield();

	load_gump( "panama_gump_3" );
}

motel_breach_main()
{
	level thread motel_fail_condition();
	
	level thread mason_breach();
	
	level thread noriega_breach();
	
	level thread thug_1_breach(); //guy by table w/noriega
	level thread thug_2_breach(); //guy sitting on couch, mason takes this guy out
	level thread thug_3_breach(); //bathroom guy
	level thread thug_4_breach(); //surprise guy, mason takes this guy out
	
	trig_player_motel_door = GetEnt( "trig_player_motel_door", "targetname" );
	trig_player_motel_door trigger_off();
	
	flag_wait( "mason_at_motel" );
	
	trig_player_motel_door trigger_on();	
	trig_player_motel_door SetHintString( &"PANAMA_MOTEL_BREACH" );
	trig_player_motel_door SetCursorHint( "HINT_NOICON" );
	trig_player_motel_door waittill( "trigger" );
	trig_player_motel_door Delete();
	
	m_motel_door_clip = GetEnt( "motel_door_clip", "targetname" );
	m_motel_door_clip Delete();
	
	flag_set( "start_intro_anims" );
	
	delay_thread( 1.5, ::open_motel_door );
	run_scene( "player_breach_intro" );

	flag_set( "player_breach_ready" );

	e_player_breach_spot = Spawn( "script_origin", level.player.origin );
	e_player_breach_spot.angles = level.player GetPlayerAngles();
	e_player_breach_spot SetModel( "tag_origin" );
	level.player PlayerLinkToDelta( e_player_breach_spot, "tag_origin", 1, 40, 40, 40, 40, false );
	
	waittill_ai_group_cleared( "player_motel_targets" );
	
	wait 1;
	
	flag_set( "motel_room_cleared" );
	
	run_scene( "player_breach_xcool" );
	
	level thread run_scene( "player_breach_xcool_loop" );

	flag_wait( "start_xcool_end" );

	delay_thread( 4.5, ::old_man_woods, "mid_flashpoint_2" );
	run_scene( "player_breach_xcool_end" );
	
	clean_up_motel();
	
	flag_set( "motel_scene_end" );
}

clean_up_motel()
{
	//delete all scenes
//	delete_scene( "noriega_intro_xcool_end" );
//	delete_scene( "player_breach_xcool_end" );
//	delete_scene( "mason_breach_xcool_end" );
//
//	delete_scene( "thug_2_death_loop" );
	
	airfield_gump_vehicles = GetEntArray( "airfield_gump_vehicles", "script_noteworthy" );
	foreach( vehicle in airfield_gump_vehicles )
	{
		if ( IsDefined( vehicle ) )
		{
			vehicle Delete();
		}
	}
}

motel_fade_out()
{
	set_screen_fade_timer( 2 );	
	screen_fade_out();	
}

open_motel_door()
{
	m_motel_door = GetEnt( "motel_door", "targetname" );
	m_motel_door RotateYaw( 120, 0.3, 0.3, 0 ); 		
	
	PlayFx( getfx( "door_breach" ), m_motel_door.origin );		
	
	SetTimeScale( 0.25 );
	
	flag_wait( "motel_room_cleared" );	
	
	SetTimeScale( 1.0 );	
}

mason_breach()
{
	//trigger_wait( "trig_mason_to_motel" );
	flag_wait( "trig_mason_to_motel" );

//	run_scene( "mason_door_approach" );
	level.mason.goalradius = 32;
	nd_motel_door = GetNode( "nd_motel_door", "targetname" );
	level.mason SetGoalNode( nd_motel_door );
	level.mason waittill( "goal" );
	
	//TODO: Mason Nag Lines here, end on player using trigger
	level thread run_scene( "mason_door_loop" );
	
	flag_set( "mason_at_motel" );

	flag_wait( "start_intro_anims" );
	
	run_scene( "mason_breach_intro" );
	
	flag_wait( "motel_room_cleared" );

	run_scene( "mason_breach_xcool" );
	
	b_alt_1 = true;
	b_alt_2 = true;
	
	if ( b_alt_1 == true )
	{
		run_scene( "mason_breach_xcool_alt_1" );
	}

	if ( b_alt_2 == true )
	{
		run_scene( "mason_breach_xcool_alt_2" );
	}

	flag_set( "start_xcool_end" );

	run_scene( "mason_breach_xcool_end" );
	
}

motel_fail_condition()
{
	trig_motel_fail = GetEnt( "trig_motel_fail", "targetname" );
	trig_motel_fail trigger_off();	
	
	//trigger_wait( "trig_mason_to_motel" );
	flag_wait( "trig_mason_to_motel" );
	
	trig_motel_fail trigger_on();
	trig_motel_fail waittill( "trigger" );
	
	SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();	
}

noriega_breach()
{
	flag_wait( "start_intro_anims" );
	
	level thread noriega_kill_fail();
	
	run_scene( "noriega_intro" );
	
	level thread run_scene( "noriega_intro_loop" );
	
	flag_wait( "motel_room_cleared" );
	
	run_scene( "noriega_intro_xcool" );
	
	level thread run_scene( "noriega_intro_xcool_loop" );
	
	flag_wait( "start_xcool_end" );
	
	run_scene( "noriega_intro_xcool_end" );
}

thug_1_breach()
{
	flag_wait( "start_intro_anims" );
	
	ai_thug_1 = simple_spawn_single( "thug_1" );
	ai_thug_1.animname = "thug_1";
	
	level thread run_scene( "thug_1_intro" );
}

noriega_kill_fail()
{
	level endon( "motel_room_cleared" );
	
	flag_wait( "player_breach_ready" );
	
	level.noriega = init_hero( "noriega" );
	level.noriega.ignoreme = 1;
	level.noriega stop_magic_bullet_shield();
	level.noriega waittill( "death" );
	
	SetDvar( "ui_deadquote", &"PANAMA_BREACH_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();		
}

thug_2_breach()
{
	flag_wait( "start_intro_anims" );
	
	ai_thug_2 = simple_spawn_single( "thug_2" );
	ai_thug_2.animname = "thug_2";
	ai_thug_2 set_ignoreall( true );
	
	run_scene( "thug_2_intro" );

	run_scene( "thug_2_shot" );

	level thread run_scene( "thug_2_death_loop" );
}

thug_3_breach()
{
	flag_wait( "start_intro_anims" );
	
	ai_thug_3 = simple_spawn_single( "thug_3" );
	ai_thug_3.animname = "thug_3";
	
	run_scene( "thug_3_intro" );
}

thug_4_breach()
{
	flag_wait( "start_intro_anims" );
	
	ai_thug_4 = simple_spawn_single( "thug_4" );
	ai_thug_4.animname = "thug_4";
	
	run_scene( "thug_4_intro" );	
	
	level thread run_scene( "thug_4_shot_loop" );
	
	flag_wait( "start_xcool_end" );

	run_scene( "thug_4_crawl" );	

	level thread run_scene( "thug_4_killed" );
}