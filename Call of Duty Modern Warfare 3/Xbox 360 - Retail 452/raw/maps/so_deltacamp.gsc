#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

CONST_TRAINER_V1_TIME_REGULAR		= -1;
CONST_TRAINER_V1_TIME_HARDENED		= 40;
CONST_TRAINER_V1_TIME_VETERAN		= 28;

CONST_TRAINER_V2_TIME_REGULAR		= -1;
CONST_TRAINER_V2_TIME_HARDENED		= 45;
CONST_TRAINER_V2_TIME_VETERAN		= 33;

main()
{
	if ( !IsDefined( level.trainer_version ) )
	{
		level.trainer_version = 1;
	}
	
	AssertEx( level.trainer_version >= 1 && level.trainer_version <= 2, "Invalid trainer version of: " + level.trainer_version );
	
	PrecacheString( &"SO_DELTACAMP_OBJ_V1" );
	PrecacheString( &"SO_DELTACAMP_OBJ_V2" );
	PrecacheString( &"SO_DELTACAMP_CIV_COUNT" );
	PrecacheString( &"SO_DELTACAMP_CIVILIAN_HIT" );
	PrecacheString( &"SO_DELTACAMP_AREA_CLEARED" );
	PrecacheString( &"SO_DELTACAMP_SCOREBOARD_FINISH_TIME" );
	PrecacheString( &"SO_DELTACAMP_SCOREBOARD_ENEMIES_HIT" );
	PrecacheString( &"SO_DELTACAMP_SCOREBOARD_CIVS_HIT" );
	PrecacheString( &"SO_DELTACAMP_SCOREBOARD_FINAL_TIME" );
	PrecacheString( &"SO_DELTACAMP_DEAD_QUOTE_ALLY_HURT" );
	
	PreCacheModel( "com_folding_chair" );
	
	maps\_specialops::so_hud_stars_precache();
	
	//PreCacheModel( "Mil_Frame_Charge_Obj" );
	// Start functions
	default_start( ::start_mission );
	add_start( "start_assault",		::start_mission );
	
	maps\createart\so_deltacamp_art::main();
	maps\so_deltacamp_fx::main();
	maps\so_deltacamp_precache::main();
	maps\so_deltacamp_anim::main();
	maps\_load::main();
	
	maps\_compass::setupMiniMap( "compass_map_so_deltacamp" );
	setsaveddvar( "compassmaxrange", "1200" );
	
	thread maps\so_deltacamp_amb::main();
	
	// Turn of deaths door audio because the level is not set
	// up for it
	maps\_audio::aud_disable_deathsdoor_audio();
	
	init_level_flags();
	
	// Set Vision Set so both version 1 and 2 of the
	// trainer have it
	set_vision_set( "so_deltacamp", 0 );
	
	setup_level_hud();
	setup_gameplay();
	
	level.challenge_time_force_on = true;
	thread enable_challenge_timer( level.challenge_flag_start, level.challenge_flag_complete );
	thread fade_challenge_in( undefined, false );
	thread fade_challenge_out( "fade_challenge_out", true );
	
	// Add the player hud after the challenge timer has been set up
	// as new challenge counters rely on level.start_flag being set
	thread setup_all_player_hud();
	
	// Simultaneous finish only for version 2 right now
	if ( level.trainer_version == 2 )
	{
		thread enable_triggered_complete( level.challenge_trig_complete_noteworthy, "all_players_reached_end", "any" );
	}
}

// -.-.-.-.-.-.-.-.-.-.- General Setup -.-.-.-.-.-.-.-.-.-.- //

init_level_flags()
{
	flag_init( "course_start_open_gate" );
	flag_init( "course_targets_finished" );
	flag_init( "all_players_reached_end" );
	flag_init( "fade_challenge_out" );
	
	flag_init( "so_training_deltacamp_start_v1" );
	flag_init( "so_training_deltacamp_complete_v1" );
	flag_init( "trig_level_end_v1" );
	flag_init( "duck_shoot_targets_pop" );
	
	flag_init( "so_training_deltacamp_start_v2" );
	flag_init( "so_training_deltacamp_complete_v2" );
	flag_init( "trig_level_end_v2" );
	flag_init( "breach_second_room_started" );
	
	// Each target group struct sets a flag when the targets
	// pop and when they are cleared. The flags are the struct
	// name with "_popped" or "_cleared" on the end.
	flag_init( "target_group_root_v1_02_popped" );
	flag_init( "target_group_root_v1_02_cleared" );
	flag_init( "target_group_root_v1_03_popped" );
	flag_init( "target_group_root_v1_03_cleared" );
	flag_init( "target_group_root_v1_04_popped" );
	flag_init( "target_group_root_v1_04_cleared" );
	flag_init( "target_group_root_v1_05_popped" );
	flag_init( "target_group_root_v1_05_cleared" );
	flag_init( "target_group_root_v1_06_popped" );
	flag_init( "target_group_root_v1_06_cleared" );
	flag_init( "target_group_root_v1_07_popped" );
	flag_init( "target_group_root_v1_07_cleared" );
	flag_init( "target_group_root_v1_08_popped" );
	flag_init( "target_group_root_v1_08_cleared" );
	flag_init( "target_group_root_v1_09_popped" );
	flag_init( "target_group_root_v1_09_cleared" );
	flag_init( "target_group_root_v2_01_popped" );
	flag_init( "target_group_root_v2_01_cleared" );
	flag_init( "target_group_root_v2_02_popped" );
	flag_init( "target_group_root_v2_02_cleared" );
	flag_init( "target_group_root_v2_03_popped" );
	flag_init( "target_group_root_v2_03_cleared" );
	flag_init( "target_group_root_v2_04_popped" );
	flag_init( "target_group_root_v2_04_cleared" );
	flag_init( "target_group_root_v2_05_popped" );
	flag_init( "target_group_root_v2_05_cleared" );
	flag_init( "target_group_root_v2_06_popped" );
	flag_init( "target_group_root_v2_06_cleared" );
	flag_init( "target_group_root_v2_07_popped" );
	flag_init( "target_group_root_v2_07_cleared" );
	flag_init( "target_group_root_v2_08_popped" );
	flag_init( "target_group_root_v2_08_cleared" );
}

setup_gameplay()
{
	init_stat_vars();
	
	// Array of names for each struct that links to the targets
	// in its group. There is one root struct per group of targets.
	group_struct_names_v1 =
							[
								"target_group_root_v1_02",	// Group 2 root struct for map version 1
								"target_group_root_v1_03",	// Group 3 root struct for map version 1
								"target_group_root_v1_04",	// Group 4 root struct for map version 1
								"target_group_root_v1_05",	// Group 5 root struct for map version 1
								"target_group_root_v1_06",	// Group 6 root struct for map version 1
								"target_group_root_v1_07",	// Group 7 root struct for map version 1
								"target_group_root_v1_08",	// Group 8 root struct for map version 1
								"target_group_root_v1_09"	// Group 9 root struct for map version 1
							 ];
							 
	group_struct_names_v2 = 
							[
								"target_group_root_v2_01",	// Group 1 root struct for map version 2
								"target_group_root_v2_02",	// Group 2 root struct for map version 2
								"target_group_root_v2_03",	// Group 3 root struct for map version 2
								"target_group_root_v2_04",	// Group 4 root struct for map version 2
								"target_group_root_v2_05",	// Group 5 root struct for map version 2
								"target_group_root_v2_06",	// Group 6 root struct for map version 2
								"target_group_root_v2_07",	// Group 7 root struct for map version 2
								"target_group_root_v2_08"	// Group 8 root struct for map version 2
							 ];
	
	if ( level.trainer_version == 1 )
	{
		delete_ents( "v2_only" );
		delete_ents( "v2_coop_only" );
		if ( !is_coop() )
		{
			delete_ents( "v1_coop_only" );
		}
		
		level.challenge_flag_start					= "so_training_deltacamp_start_v1";
		level.challenge_flag_complete				= "so_training_deltacamp_complete_v1";
		
//		level.challenge_trig_complete_noteworthy	= "trig_level_end_v1";
		
//		thread on_flag_set_up_slide( level.challenge_flag_start, "trig_mission_end_slide" );
		thread course_think( group_struct_names_v1, group_struct_names_v2 );
	}
	else if ( level.trainer_version == 2 )
	{
		delete_ents( "v1_only" );
		delete_ents( "v1_coop_only" );
		if ( !is_coop() )
		{
			delete_ents( "v2_coop_only" );
		}
		
		doors_adjust_for_version_2();
		
		setup_breach();
		
		level.challenge_flag_start					= "so_training_deltacamp_start_v2";
		level.challenge_flag_complete				= "so_training_deltacamp_complete_v2";
		level.challenge_trig_complete_noteworthy	= "trig_level_end_v2";
		
		thread course_think( group_struct_names_v2, group_struct_names_v1 );
	}
	
	thread on_mission_success();
	thread setup_fail_triggers();
	thread objective_think();
	thread setup_dialog();
	thread setup_allies();
	thread setup_players();
	thread setup_destructible_vehicles();
	//thread setup_gates();
	
	level.custom_eog_no_defaults			= true;
	level.eog_summary_callback 				= ::custom_eog_summary;
	
	trigger_off( "trig_mission_end_slide", "targetname" );
}

delete_ents( ent_noteworthy )
{
	ents_delete = GetEntArray( ent_noteworthy, "script_noteworthy" );
	array_call( ents_delete, ::Delete );
}

on_flag_set_up_slide( flag_name, trig_name )
{
	flag_wait( flag_name );
	
	trigger_on( trig_name, "targetname" );
}

on_mission_success()
{
	level endon( "special_op_terminated" );
	
	// Version 1 now ends when all targets are down, version 2
	// still ends when players cross finish line
	if ( level.trainer_version == 1 )
	{
		flag_wait( "course_targets_finished" );
		
	}
	else if ( level.trainer_version == 2 )
	{
		flag_wait( "all_players_reached_end" );
	}
	
	flag_set( level.challenge_flag_complete );
	
	// Give the player a second to look at Sandman
	// or to cross the finish line
	wait 1.0;
	
	flag_set( "fade_challenge_out" );	
}

doors_adjust_for_version_2()
{
	// Flip each door's open direction
	doors = GetEntArray( "door_ent", "targetname" );
	foreach ( door in doors )
	{
		if ( IsDefined( door.script_goalyaw ) )
		{
			door.script_goalyaw *= -1;
		}
	}
	
	foreach ( door in doors )
	{
		if ( door has_script_parameter( "door_before", ";" ) )
		{
			door replace_script_parameter( "door_before", "door_after", ";" );
		}
		else if ( door has_script_parameter( "door_after", ";" ) )
		{
			door replace_script_parameter( "door_after", "door_before", ";" );
		}
	}
}

setup_destructible_vehicles()
{
	vehicles = getentarray( "destructible_vehicle", "targetname" );
	array_thread( vehicles, maps\_vehicle::godon );
}

setup_breach()
{
	if ( !is_coop() )
	{
		// Reloading info is needed by the breach in
		// single player but this function is only threaded
		// on the player from dog_init and civ_init() :-/
		level.player thread animscripts\combat_utility::watchReloading();
	}

	level.breach_no_auto_reload = true;
	level.slowmo_viewhands = "viewhands_player_delta";
	maps\_slowmo_breach::slowmo_breach_init();
	level.slomobreachduration = 2.0;	// duration of slomo breach
	
	maps\_slowmo_breach::add_breach_func( ::on_breach );
	level._effect[ "breach_door" ] = LoadFX( "explosions/breach_door_metal" );
	level._effect[ "breach_room" ] = LoadFX( "explosions/breach_room_cheap" );
	
	thread breach_think();
}

on_breach( breach_rig )
{
	if ( !IsDefined( level.so_trainer_breach_count ) )
	{
		level.so_trainer_breach_count = 0;
	}
	
	level.so_trainer_breach_count++;
	
	if ( level.so_trainer_breach_count == 1 )
	{
		flag_set( level.challenge_flag_start );
	}
	else if ( level.so_trainer_breach_count == 2 )
	{
		flag_set( "breach_second_room_started" );
	}
}

breach_think()
{
	// Add breach hint model to first breach
	charge_loc_struct = getstruct( "breach_hint_01", "targetname" );
	level.breach_charge01_highlight = spawn( "script_model", charge_loc_struct.origin );
	level.breach_charge01_highlight setmodel( "mil_frame_charge_obj" );
	level.breach_charge01_highlight.angles = charge_loc_struct.angles;
	
	level.breach_charge01 = spawn( "script_model", charge_loc_struct.origin );
	level.breach_charge01 setmodel( "mil_frame_charge" );
	level.breach_charge01.angles = charge_loc_struct.angles;
	
	// Disable second breach use trigger
	breach_triggers = GetEntArray( "trigger_use_breach", "classname" );
	breach_trigger_second = undefined;
	foreach ( trigger in breach_triggers )
	{
		if ( IsDefined( trigger.script_slowmo_breach ) && trigger.script_slowmo_breach == 2 )
		{
			breach_trigger_second = trigger;
		}
	}
	
	Assert( IsDefined( breach_trigger_second ), "Second breach trigger couldn't be found to get turned off." );
	breach_trigger_second trigger_off();
	
	// First breach
	level waittill( "breaching" );
	
	level.breach_charge01_highlight Delete();
	level.breach_charge01 Delete();
	
	// Wait till the bridge is clear before turning on the second
	// breach's visuals and use trigger
	flag_wait( "target_group_root_v2_03_cleared" );
	
	breach_trigger_second trigger_on();
	
	charge_loc_struct = getstruct( "breach_hint_02", "targetname" );
	level.breach_charge02_highlight = spawn( "script_model", charge_loc_struct.origin );
	level.breach_charge02_highlight setmodel( "mil_frame_charge_obj" );
	level.breach_charge02_highlight.angles = charge_loc_struct.angles;
	
	level.breach_charge02 = spawn( "script_model", charge_loc_struct.origin );
	level.breach_charge02 setmodel( "mil_frame_charge" );
	level.breach_charge02.angles = charge_loc_struct.angles;
	
	// Second breach
	level waittill( "breaching" );
	
	level.breach_charge02_highlight Delete();
	level.breach_charge02 Delete();
}

setup_fail_triggers()
{	
	level endon( "special_op_terminated" );
	level endon( "missionfailed" );
	
	triggers = GetEntArray( "trig_player_left_bridge", "targetname" );
	
	foreach ( trig in triggers )
	{
		trig childthread on_trigger_player_left_bridge();
	}
}

on_trigger_player_left_bridge()
{
	self waittill( "trigger" );
	
	level.challenge_end_time = gettime();
	so_force_deadquote( "@SO_DELTACAMP_DEAD_QUOTE_PLAYER_LEFT_BRIDGE" );
	thread missionFailedWrapper();
}

objective_think()
{
	obj_id = undefined;
	obj_str = undefined;
	obj_pos = undefined;
	
	if ( level.trainer_version == 1 )
	{
		obj_id = obj( "stay_sharp" );
		obj_str = &"SO_DELTACAMP_OBJ_V1";
		obj_pos = getstruct( "obj_start_pos_v1", "targetname" ).origin;
	}
	else if ( level.trainer_version == 2 )
	{
		obj_id = obj( "breach_and_clear" );
		obj_str = &"SO_DELTACAMP_OBJ_V2";
		obj_pos = getstruct( "obj_start_pos_v2", "targetname" ).origin;
	}
	
	Assert( IsDefined( obj_id ), "Objective failed to initialize." );
	
	Objective_Add( obj_id, "active", obj_str );
	Objective_Current( obj_id );
	Objective_Position( obj_id, obj_pos );
	
	flag_wait( level.challenge_flag_start );
	
	Objective_Position( obj_id, (0,0,0) );
	
	flag_wait( level.challenge_flag_complete );
	
	objective_complete( obj_id );
}

setup_dialog()
{
	thread dialog_intro();
	thread dialog_weapons_hidden();
	thread dialog_civilians();
	thread dialog_course();
}

dialog_intro()
{
	level endon( level.challenge_flag_start );
	
	while ( !IsDefined( level.truck ) )
		wait 0.05;
	
	level.truck endon( "death" );
	
	wait( 0.5 );
	
	truck_speaker = getstruct( "truck_speaker", "script_noteworthy" );
	
	if ( level.trainer_version == 1 )
	{
		if ( !is_coop() )
			level.truck dialogue_queue( "so_deltacamp_trk_youreup" );
		else
			level.truck dialogue_queue( "so_deltacamp_trk_startingarea" );
	}
	else if ( level.trainer_version == 2 )
	{
		speaker_play_vo( "so_trainer2_trk_breach", truck_speaker );
	}
	
	wait( RandomFloatRange( 8.0, 11.0 ) );
	
	if ( !is_coop() )
	{
		speaker_play_vo( "so_deltacamp_trk_yourgo", truck_speaker );
	}
	else
	{
		speaker_play_vo( "so_deltacamp_trk_whenever", truck_speaker );
	}
	
}

speaker_play_vo( sound_alias, speaker_ent )
{
	speaker_stop_vo();
	
	if ( !isDefined( speaker_ent ) )
	{
		speaker_ent = getclosest( level.player.origin, level.speakers );
	}
	
	level.speaker_ent_last = speaker_ent;
	speaker_ent PlaySound( sound_alias, "speaker_sound_interrupt", true );
}

speaker_stop_vo()
{
	if ( IsDefined( level.speaker_ent_last ) )
		level.speaker_ent_last notify( "speaker_sound_interrupt" );
}

dialog_weapons_hidden()
{
	level endon( level.challenge_flag_start );
	
	array_thread( level.players, ::on_player_weapon_change );
	
	level waittill( "weapon_hidden_collected" );
	
	speaker_truck = getstruct( "speaker_truck", "script_noteworthy" );
	speaker_stop_vo();
	speaker_play_vo( "so_deltacamp_trk_owntoys", speaker_truck );
}

dialog_civilians()
{
	level endon( level.challenge_flag_complete );
	level endon( "missionfailed" );
	level endon( "special_op_terminated" );
	
	civ_comment = 0;
	
	while ( 1 )
	{
		level waittill( "civilian_killed" );
		
		// Don't talk while in a breach
		if ( flag_exist( "breaching_on" ) && flag( "breaching_on" ) )
		{
			continue;
		}
		
		civ_comment++;
		if ( civ_comment == 1 )
		{
			speaker_play_vo( "so_deltacamp_trk_civilians" );
		}
		else if ( civ_comment == 2 )
		{
			speaker_play_vo( "so_deltacamp_trk_dontshoot" );
			return;
		}
	}
}

on_player_weapon_change()
{
	level endon( level.challenge_flag_start );
	level endon( "weapon_hidden_collected" );
	
	while ( 1 )
	{
		self waittill( "weapon_change", weapon_new );
		
		if	(
				IsDefined( weapon_new )
		 	&&	( weapon_new == "ak74u" || weapon_new == "usp_no_knife" )
		 	)
		{
			level notify( "weapon_hidden_collected" );
			return;
		}
	}
}

dialog_course()
{
	level endon( "missionfailed" );
	
	if ( level.trainer_version == 1 )
	{
		// Intro Tangos
		flag_wait( "target_group_root_v1_02_popped" );
		speaker_play_vo( "so_deltacamp_trk_tangos" );
		
		// Vehicles
		flag_wait( "target_group_root_v1_03_popped" );
		speaker_play_vo( "so_deltacamp_trk_vehicles" );
		flag_wait( "target_group_root_v1_03_cleared" );
		speaker_play_vo( "so_deltacamp_trk_moveup" );
		
		// Building Exterior
		flag_wait( "target_group_root_v1_04_popped" );
		speaker_play_vo( "so_deltacamp_trk_targets" );
		flag_wait( "target_group_root_v1_04_cleared" );
		speaker_play_vo( "so_deltacamp_trk_clear" );
		
		// Melee
		flag_wait( "target_group_root_v1_05_popped" );
		speaker_play_vo( "so_deltacamp_trk_knife" );
		flag_wait( "target_group_root_v1_05_cleared" );
		speaker_play_vo( "so_deltacamp_trk_upthestairs" );
		
		// Room top of the stairs
		flag_wait( "target_group_root_v1_06_cleared" );
		speaker_play_vo( "so_deltacamp_trk_allclear" );
		
		// Dogs on bridge
		flag_wait( "target_group_root_v1_07_popped" );
		speaker_play_vo( "so_deltacamp_trk_dogs" );
		
		// Building top end of bridge
		flag_wait( "target_group_root_v1_08_cleared" );
		speaker_play_vo( "so_deltacamp_trk_bridgeclear" );
		
		// Cleared final room
		flag_wait( "target_group_root_v1_09_cleared" );
		wait 0.5;
		
		if ( !IsDefined( level.sandman ) )
			return;
		
		level.sandman endon( "death" );
		
		speaker_stop_vo();
		level.sandman dialogue_queue( "so_deltacamp_snd_thanks" );
				
		flag_wait( level.challenge_flag_complete );
		star_count = level.player.so_hud_star_count;
		// Outro Dialogue
		wait 1.0;
		
		speaker_stop_vo();
		
		if ( star_count > 1 )
		{
			level.sandman dialogue_queue( "so_deltacamp_snd_nicelydone" );
		}
		else
		{
			level.sandman dialogue_queue( "so_deltacamp_snd_nogood" );
		}
	}
	else if ( level.trainer_version == 2 )
	{
		// First Breach
		flag_wait( "target_group_root_v2_01_cleared" );
		wait( 0.5 ); // Wait for slowmo to end
		thread speaker_play_vo( "so_trainer2_trk_roomclear" );
		
		// Bridge Part 1
		flag_wait( "target_group_root_v2_02_popped" );
		thread speaker_play_vo( "so_deltacamp_trk_dogs" );
		flag_wait( "target_group_root_v2_02_cleared" );
		thread speaker_play_vo( "so_deltacamp_trk_allclear" );
		
		// Bridge Part 2
		flag_wait( "target_group_root_v2_03_popped" );
		thread speaker_play_vo( "so_trainer2_trk_sniper" );
		flag_wait( "target_group_root_v2_03_cleared" );
		thread speaker_play_vo( "so_deltacamp_trk_bridgeclear" );
		
		// Second Breach
		trigger_wait_targetname( "trig_v2_breach_dialog_02" );
		thread speaker_play_vo( "so_trainer2_trk_anothercharge" );
		flag_wait( "target_group_root_v2_04_cleared" );
		wait( 0.5 ); // Wait for slowmo to end
		thread speaker_play_vo( "so_trainer2_trk_downstairs" );
		
		// Melee
		flag_wait( "target_group_root_v2_05_popped" );
		thread speaker_play_vo( "so_deltacamp_trk_knife" );
		
		// Building Exterior
		flag_wait( "target_group_root_v2_06_popped" );
		thread speaker_play_vo( "so_deltacamp_trk_tangos" );
		flag_wait( "target_group_root_v2_06_cleared" );
		thread speaker_play_vo( "so_deltacamp_trk_moveup" );
		
		// Bridge
		flag_wait( "target_group_root_v2_07_popped" );
		thread speaker_play_vo( "so_trainer2_trk_uponbridge" );
		
		// Last Group
		flag_wait( "target_group_root_v2_08_popped" );
		thread speaker_play_vo( "so_trainer2_trk_lastgroup" );
		flag_wait( "target_group_root_v2_08_cleared" );
		thread speaker_play_vo( "so_deltacamp_trk_sprinttofinish" );
		
		flag_wait( level.challenge_flag_complete );
		star_count = level.player.so_hud_star_count;
		// Outro Dialogue
		wait 1.0;
		
//		// Lines for personal best
//		so_deltacamp_trk_personalbest
//		so_deltacamp_trk_teamrecord

		if ( star_count > 1 )
		{
			thread speaker_play_vo( "so_deltacamp_trk_runthecourse" );
		}
		else
		{
			if ( cointoss() )
			{
				thread speaker_play_vo( "so_deltacamp_trk_notgood" );
			}
			else
			{
				thread speaker_play_vo( "so_deltacamp_trk_betterthan" );
			}
		}
	}
}

setup_allies()
{
	battlechatter_off( "allies" );
	
	if ( level.trainer_version == 1 )
	{
		spawner	= GetEnt( "sandman", "targetname" );
		level.sandman = spawner spawn_ai( true );
		level.sandman thread on_damage_ally_fail();
		level.sandman thread look_at_players();
		level.sandman.so_no_mission_over_delete = true;
		level.sandman.allowdeath = true;
		level.sandman.drawoncompass = false;
		level.sandman.health = 1;
		
		level.sandman gun_remove();
		level.sandman.animname = "generic";
		scene_ent = GetEnt( "ent_sandman_scene", "targetname" );
		scene_ent thread anim_loop_solo( level.sandman, "sandman_idle", "end_idle");
	}
	
	spawner	= GetEnt( "truck", "targetname" );
	level.truck = spawner spawn_ai( true );
	level.truck thread on_damage_ally_fail();
	level.truck thread look_at_players();
	level.truck.allowdeath = true;
	level.truck.drawoncompass = false;
	level.truck.health = 1;
	
	level.truck	gun_remove();
	level.truck.animname = "generic";
	
	if ( level.trainer_version == 1 )
	{
		start_loc = getstruct( "loc_truck_look_at_v1_start", "targetname" );
		start_loc thread anim_loop_solo( level.truck, "truck_idle", "end_idle");
		level.truck thread update_truck_loc( start_loc );
	}
	else if ( level.trainer_version == 2 )
	{
		bridge_loc = getstruct( "loc_truck_look_at_bridge", "targetname" );
		bridge_loc thread anim_loop_solo( level.truck, "truck_idle", "end_idle");
	}
	
	spawner	= GetEnt( "grinch", "targetname" );
	level.grinch = spawner spawn_ai( true );
	level.grinch thread on_damage_ally_fail();
	level.grinch thread look_at_players();
	level.grinch.allowdeath = true;
	level.grinch.drawoncompass = false;
	level.grinch.health = 1;
	level.grinch gun_remove();
	
	level.grinch.animname = "generic";
	scene_ent = GetEnt( "ent_grinch_scene", "targetname" );
	scene_ent thread anim_loop_solo( level.grinch, "grinch_idle", "end_idle");
	
	chair = spawn( "script_model", level.grinch.origin );
	chair setmodel( "com_folding_chair" );
	chair.angles = level.grinch.angles + ( 0, 0, 0 );
	level.grinch thread delete_on_death( chair );
}

update_truck_loc( scene_object )
{
	level endon( "special_op_terminated" );
	
	flag_wait( "duck_shoot_targets_pop" );
	
	// Wait until both players can't see Truck
	while ( 1 )
	{
		safe_to_move = true;
		
		foreach ( player in level.players )
		{
			if ( self CanSee( player ) )
			{
				safe_to_move = false;
				break;
			}
		}
		
		if ( safe_to_move == true )
		{
			break;
		}
		wait 0.2;
	}
	
	scene_object notify( "end_idle" );
	
	bridge_loc = getstruct( "loc_truck_look_at_bridge", "targetname" );
	bridge_loc thread anim_loop_solo( self, "truck_idle", "end_idle");
}

look_at_players()
{
	level endon( "special_op_terminated" );
	
	player_in_focus = undefined;
	
	while ( 1 )
	{
		player_closest = get_closest_player( self.origin );
		if ( !IsDefined( player_in_focus ) || player_in_focus != player_closest )
		{
			player_in_focus = player_closest;
			self SetLookAtEntity( player_in_focus );
		}
		
		wait 0.5;
	}
}

on_damage_ally_fail()
{
	level endon( "special_op_terminated" );
	
	while ( 1 )
	{
		self waittill_any( "damage", "death" );
		
		level.challenge_end_time = gettime();
		so_force_deadquote( "@SO_DELTACAMP_DEAD_QUOTE_ALLY_HURT" );
		thread missionFailedWrapper();
		break;
	}
}

setup_players()
{
	foreach ( index, player in level.players )
	{
		player give_max_ammo();
		
		if ( level.trainer_version == 2 )
		{
			struct = getstruct( "struct_start_pos_player" + ( index + 1 ) + "_v2", "targetname" );
			player coop_teleport_player( struct );
		}
	}
}

setup_player_hud()
{
	Assert( IsDefined( self ) && IsPlayer( self ) );
	
	if ( level.trainer_version == 1 )
	{
		self maps\_specialops::so_hud_stars_init(
										level.challenge_flag_start, 
										"course_targets_finished",
										CONST_TRAINER_V1_TIME_REGULAR,
										CONST_TRAINER_V1_TIME_HARDENED,
										CONST_TRAINER_V1_TIME_VETERAN );
	}
	else if ( level.trainer_version == 2 )
	{
		self maps\_specialops::so_hud_stars_init(
										level.challenge_flag_start,
										"all_players_reached_end",
										CONST_TRAINER_V2_TIME_REGULAR,
										CONST_TRAINER_V2_TIME_HARDENED,
										CONST_TRAINER_V2_TIME_VETERAN );
	}
	
	self thread maps\_specialops::enable_challenge_counter( 3, &"SO_DELTACAMP_CIV_COUNT", "ui_civ_count" );
}

catch_civilian_hits()
{
	level endon( "special_op_terminated" );
	
	while ( 1 )
	{
		level waittill( "civilian_killed", attacker );
		
		// Update the civilian counter
		attacker notify( "ui_civ_count", attacker.civs_hit );
		
		if ( level.civs_hit == 1 )
		{
			// Remove the veteran star
			maps\_specialops::so_hud_stars_remove( "veteran" );
		}
		else if ( level.civs_hit == 2 )
		{
			// Remove the veteran star
			maps\_specialops::so_hud_stars_remove( "hardened" );
		}
	}
}

// JC:ToDo - Update teleport_player() for coop()
// teleport_player() in _utility.gsc does not use the
// self variable for the player and instead uses
// level.player, fix next game.
coop_teleport_player( object )
{
	Assert( IsPlayer( self ) );
	Assert( IsDefined( object) && IsDefined( object.origin ) );
	
	self SetOrigin( object.origin );
	if ( IsDefined( object.angles ) )
    	self SetPlayerAngles( object.angles );
}

give_max_ammo()
{
	Assert( IsPlayer( self ) );
	
	playerPrimaryWeapons = self GetWeaponsListPrimaries();
	
	foreach ( weapon in playerPrimaryWeapons )
	{
		self GiveMaxAmmo( weapon );
	}
}

init_stat_vars()
{
	level.civs_hit		= 0;
	
	foreach( player in level.players )
	{
		player.civs_hit		= 0;
	}
}

setup_gates()
{
	level.gate_enter_v1 = make_door_from_prefab( "gate_enter_v1" );
	level.gate_enter_v1.openangles = 80;

	// Gate is needed for both
	if ( level.trainer_version == 1 )
	{
		level.gate_enter_v1 thread door_open( "course_start_open_gate", false );
	}
	else if ( level.trainer_version == 2 )
	{
		level.gate_enter_v1 thread door_open( undefined, true, true );
	}
	
	level.gate_enter_v2 = make_door_from_prefab( "gate_enter_v2" );
	level.gate_enter_v2.openangles = 80;
	
	// In version 1 open at end for the slide
	if ( level.trainer_version == 1 )
	{
		level.gate_enter_v2 thread door_open( "course_targets_finished", true );
	}
}

start_mission()
{
	if ( level.trainer_version == 1 )
	{
		flag_set_delayed( "course_start_open_gate", 1.0 );
	}
	else
	{
		flag_set( "course_start_open_gate" );
	}
}

// -.-.-.-.-.-.-.-.-.-.- Course / Target Logic -.-.-.-.-.-.-.-.-.-.- //

course_think( group_struct_names, group_struct_names_delete )
{
	// Disable level trigger until all targets have been taken out
	if ( IsDefined( level.challenge_trig_complete_noteworthy ) )
		trigger_off( level.challenge_trig_complete_noteworthy, "script_noteworthy" );
	
	course_delete( group_struct_names_delete );
	
	// Gather and organize the information for each
	// group of targets and populate level.group_structs
	course_target_setup( group_struct_names );
	wait 1.0;
	
	// Set by trigger at the beginning of the course (or by breach)
	flag_wait( level.challenge_flag_start );
	
	// Target group update loop
	foreach ( index, struct in level.group_structs )
	{
		if ( IsDefined( struct.trig_required ) )
		{
			struct.trig_required trigger_on();
			struct.trig_required waittill( "trigger" );
		}
		
		if ( IsDefined( struct.script_flag ) )
		{
			flag_wait( struct.script_flag );
		}
		
		if ( IsDefined( struct.script_delay ) )
		{
			wait( struct.script_delay );
		}
		
		flag_set( struct.targetname + "_popped" );
		
		array_notify( struct.doors_before, "open" );
		array_notify( struct.targets, "pop_up" );
		
		// Each target_think checks to see if it was
		// the last target to be taken down and then
		// notifies "all_targets_down" to the parent
		// struct
		struct waittill( "all_targets_down" );
		
		flag_set( struct.targetname + "_cleared" );
		
		array_notify( struct.doors_after, "open" );
		
		thread HUD_area_cleared();
	}
	
	flag_set( "course_targets_finished" );
	
	if ( IsDefined( level.challenge_trig_complete_noteworthy ) )
	{
		// activate level exit trigger
		trigger_on( level.challenge_trig_complete_noteworthy, "script_noteworthy" );
	}
}

course_target_setup( group_struct_names )
{
	level.target_rail_start_points		= getentarray( "target_rail_start_point", "targetname" );
	level.target_rail_path_start_points	= getentarray( "target_rail_path_start_point", "targetname" );
	level.speakers 						= getentarray( "speakers", "targetname" );
	level.group_structs					= [];
	
	// Hide melee clips until they are needed
	level.melee_clips = GetEntArray( "melee_clip", "targetname" );
	array_thread( level.melee_clips, ::hide_entity );
	
	// Build array of target group structs
	foreach ( name in group_struct_names )
	{
		struct = get_target_ent( name );
		level.group_structs[ level.group_structs.size ] = struct;
	}
	
	// Set up the targets under each group struct
	foreach ( struct in level.group_structs )
	{
		struct.doors_before			= [];
		struct.doors_after			= [];
		struct.targets				= [];
		struct.targets_friendly		= [];
		struct.targets_enemy		= [];
		struct.targets_enemy_killed	= 0;
		
		linked_ents = struct get_linked_ents();
		
		foreach ( ent in linked_ents )
		{
			if ( !IsDefined( ent.code_classname ) )
				continue;
			
			if ( ent.code_classname == "script_brushmodel" )
			{
				if ( !is_coop() && ent has_script_parameter( "coop_only", ";" ) )
				{
					ent target_delete();
					continue;
				}
				
				if ( IsDefined( ent.script_noteworthy ) && IsSubStr( ent.script_noteworthy, "target_" ) )
				{
					if ( ent.script_noteworthy == "target_enemy" )
					{
						struct.targets_enemy[ struct.targets_enemy.size ] = ent;
					}
					else if ( ent.script_noteworthy == "target_friendly" )
					{
						struct.targets_friendly[ struct.targets_friendly.size ] = ent;
					}
					else
					{
						AssertMsg( "Target at " + ent.origin + " needs a script_noteworthy with either target_enemy or target_friendly." );
						continue;
					}
					
					ent thread target_think( struct, StrTok( ent.script_noteworthy, "_" )[ 1 ] );
					struct.targets[ struct.targets.size ] = ent;
					
					if ( ent has_script_parameter( "invisible", ";" ) )
					{
						target_hide( ent );
					}
					
					continue;
				}
				
				if ( ent has_script_parameter( "door", ";" ) )
				{
					if ( ent has_script_parameter( "door_before", ";" ) )
					{
						struct.doors_before[ struct.doors_before.size ] = ent;
					}
					else if ( ent has_script_parameter( "door_after", ";" ) )
					{
						struct.doors_after[ struct.doors_after.size ] = ent;
					}
					else
					{
						Assert( "Door at " + ent.origin + " had no door_after or door_before script parameter." );
						continue;
					}
					
					ent thread door_think();
				}
			}
			
			if ( ent.code_classname == "script_model" )
			{
				if ( ent has_script_parameter( "door", ";" ) )
				{
					if ( ent has_script_parameter( "door_before", ";" ) )
					{
						struct.doors_before[ struct.doors_before.size ] = ent;
					}
					else if ( ent has_script_parameter( "door_after", ";" ) )
					{
						struct.doors_after[ struct.doors_after.size ] = ent;
					}
					else
					{
						Assert( "Door at " + ent.origin + " had no door_after or door_before script parameter." );
						continue;
					}
					
					ent thread door_think();
				}
			}
			
			if ( ent.code_classname == "trigger_multiple" && IsDefined( ent.classname ) )
			{
				if (
						ent.classname == "trigger_multiple_flag_set"
					&&	IsDefined( ent.script_flag )
					&&	flag_exist( ent.script_flag )
					)
				{
					AssertEx( !IsDefined( struct.script_flag ), "The struct.script_flag field was already set." );
					struct.script_flag = ent.script_flag;
					continue;
				}
				else if ( ent.classname == "trigger_multiple" )
				{
					struct.trig_required = ent;
					struct.trig_required trigger_off();
					continue;
				}
			}
		}
	}
}

course_delete( group_struct_names )
{
	group_structs = [];
	// Build array of target group structs
	foreach ( name in group_struct_names )
	{
		struct = get_target_ent( name );
		group_structs[ group_structs.size ] = struct;
	}
	
	// Delete targets and other ents
	foreach ( struct in group_structs )
	{
		linked_ents = struct get_linked_ents();
		
		foreach ( ent in linked_ents )
		{
			if ( !IsDefined( ent.code_classname ) )
				continue;
			
			if ( ent.code_classname == "script_brushmodel" )
			{
				// Do not delete doors
				if ( ent has_script_parameter( "door", ";" ) )
				{
					continue;
				}
			}
			
			if ( ent.code_classname == "script_model" )
			{
				// Do not delete doors
				if ( ent has_script_parameter( "door", ";" ) )
				{
					continue;
				}
			}
			
			ent Delete();
		}
	}
}

target_hide( target_brush_model )
{
	target_brush_model hide_entity();
	target_brush_model.target_model hide_entity();
}

target_show( target_brush_model )
{
	target_brush_model show_entity();
	target_brush_model.target_model show_entity();
}

target_delete()
{
	target_parts = [];
	target_parts[ target_parts.size ] = self;
	
	// The brush model (self) targets both the script_origin ent
	// and the script_model visual
	targeted_ents = GetEntArray( self.target, "targetname" );
	foreach ( ent in targeted_ents )
	{
		if ( ent.classname == "script_origin" )
		{
			target_parts [ target_parts.size ] = GetEnt( ent.target, "targetname" );
		}
		
		target_parts [ target_parts.size ] = ent;
	}
	
	array_call( target_parts, ::Delete );
}

target_think( parent_struct, target_type )
{		
	/*-----------------------
	SETUP BRUSHMODEL TARGET AND ALL ENTITIES
	-------------------------*/	
	self.meleeonly = undefined;
	
	brushmodel_targets = GetEntArray( self.target, "targetname" ) ;
	foreach ( target_ent in brushmodel_targets )
	{
		if ( target_ent.classname == "script_origin" )
		{
			self.orgEnt = target_ent;
			continue;
		}
		else if ( target_ent.classname == "script_model" )
		{
			self.target_model = target_ent;
			continue;
		}
		
		AssertMsg( "Invalid ent in training target prefab of classname: " + target_ent.classname );
	}
	
	// Set up origin ent
	Assert( IsDefined( self.orgEnt ) );
	self LinkTo( self.orgEnt );
	aim_assist_target = GetEnt( self.orgEnt.target, "targetname" );
	aim_assist_target Hide();
	aim_assist_target NotSolid();
	aim_assist_target LinkTo( self );
	
	// Set up script_model
	AssertEx( IsDefined( self.target_model ), "The target does not have a script_model targeted by the script_brushmodel" );
	self.target_model LinkTo( self.orgEnt );
	
	
	if ( self has_script_parameter( "reverse", ";" ) )
	{
		self.orgEnt RotatePitch( 90, 0.25 );
	}
	else if ( self has_script_parameter(  "sideways_right", ";" ) )
	{
		self.orgEnt RotateYaw( -180, 0.35 );
	}
	else if ( self has_script_parameter(  "sideways_left", ";" ) )
	{
		self.orgEnt RotateYaw( 180, 0.35 );
	}
	else if ( self has_script_parameter( "vertical", ";" ) )
	{
		self.orgEnt MoveTo( self.orgEnt.origin - (0,0,36), 0.25 );
	}
	else
	{
		self.orgEnt RotatePitch( -90, 0.25 );
	}
	
	/*-----------------------
	SETUP LATERALLY MOVING TARGETS
	-------------------------*/	
	
	if ( self has_script_parameter( "use_rail", ";" ) )
	{
		self.lateralMovementOrgs	= undefined;
		self.lateralStartPosition	= undefined;
		self.lateralEndPosition		= undefined;
		
		self.lateralStartPosition = getclosest( self.orgEnt.origin, level.target_rail_start_points, 10 );
		AssertEx( IsDefined( self.lateralStartPosition ), "Pop up target at " + self.origin + " has its script_parameters set to 'use_rail' but there is no valid rail start org within 10 units " );
		self.lateralEndPosition = GetEnt( self.lateralStartPosition.target, "targetname" );
		AssertEx( IsDefined( self.lateralEndPosition ),  "Pop up target at " + self.origin + " has a rail start position that is not targeting an end rail position" );
		self.lateralMovementOrgs = [];
		self.lateralMovementOrgs[ 0 ] = self.lateralStartPosition;
		self.lateralMovementOrgs[ 1 ] = self.lateralEndPosition;
		
		foreach ( org in self.lateralMovementOrgs )
		{
			AssertEx( org.code_classname == "script_origin", "Pop up targets that move laterally need to be targeting 2 script_origins" );
		}
		self target_lateral_reset_start_pos();
	}
	
	if ( self has_script_parameter( "use_rail_path", ";" ) )
	{
		self.move_orgs = [];
		path_ent = getClosest( self.orgEnt.origin, level.target_rail_path_start_points, 10 );
		while ( IsDefined( path_ent ) )
		{
			self.move_orgs[ self.move_orgs.size ] = path_ent;
			
			if ( IsDefined( path_ent.target ) )
			{
				path_ent = path_ent get_target_ent();
			}
			else
			{
				path_ent = undefined;
			}
		}
	}
	
	while ( true )
	{
		/*-----------------------
		TARGET POPS UP WHEN NOTIFIED
		-------------------------*/	
		self waittill ( "pop_up" );
		
		if ( self has_script_parameter( "breach", ";" ) )
		{
			level.breachEnemies_active++;
		}
	
		if ( IsDefined( self.script_delay ) )
		{
			wait self.script_delay;
		}

		so_player_tooclose_wait();
		
		if ( self has_script_parameter( "invisible", ";" ) )
		{
			target_show( self );
		}
		
		if ( self has_script_parameter( "melee", ";" ) )
		{
			AssertEx( level.melee_clips.size, "Training mission has a melee target but no melee clips" );
			melee_clip_close = getClosest( self.origin, level.melee_clips, 120 );
			AssertEx( IsDefined( melee_clip_close ), "No melee clip could be found for melee target at origin: " + self.origin );
			
			self.meleeonly = true;
			self.melee_clip = melee_clip_close;
			self.melee_clip show_entity();
		}
		
		// Get breach targets up super fast
		pop_time = 0.25;
		if ( !self has_script_parameter( "breach", ";" ) )
		{
			wait RandomFloatRange ( 0, .2 );
		}
		else
		{
			pop_time = 0.05;
		}
		
		self Solid();
		self PlaySound( "target_up_metal" );
		self.target_model SetCanDamage( true );
		
		if ( self has_script_parameter( "dog_bark", ";" ) )
		{
			self thread target_play_dog_bark();
		}
		
		if ( target_type != "friendly" )
		{
			aim_assist_target EnableAimAssist();
		}
		
		if ( self has_script_parameter( "reverse", ";" ) )
		{
			self.orgEnt RotatePitch( -90, pop_time );
		}
		else if ( self has_script_parameter( "sideways_right", ";" ) )
		{
			self.orgEnt RotateYaw( 180, pop_time );
		}
		else if ( self has_script_parameter( "sideways_left", ";" ) )
		{
			self.orgEnt RotateYaw( -180, pop_time );
		}
		else if ( self has_script_parameter( "vertical", ";" ) )
		{
			self.orgEnt MoveTo( self.orgEnt.origin + (0,0,36), pop_time );
		}
		else
		{
			self.orgEnt RotatePitch( 90, pop_time );
		}
		
		wait pop_time;
		
		if ( IsDefined( self.lateralStartPosition ) )
		{
			self thread target_lateral_movement();
		}
		else if ( IsDefined( self.move_orgs ) && self.move_orgs.size )
		{
			self thread target_path_movement();
		}
		
		/*-----------------------
		TARGET IS DAMAGED
		-------------------------*/	
		while ( true )
		{
			self.target_model waittill ( "damage", amount, attacker, direction_vec, point, type, model, tag, part, flags, weapon );
			
			if ( !IsDefined( attacker ) )
				continue;
			if ( !IsDefined( type ) )
				continue;
			if ( type == "MOD_IMPACT" )
				continue;
			
			if ( IsPlayer( attacker ) )
			{
				if ( IsDefined( self.meleeonly ) )
				{
					if ( type != "MOD_MELEE" )
						continue;
				}

				self PlaySound( "target_metal_hit" );
				if ( target_type == "friendly" )
				{
					thread HUD_civilian_hit();
					
					speaker = getclosest( attacker.origin, level.speakers );
					speaker PlaySound( "target_mistake_buzzer" );

					attacker.civs_hit++;
					level.civs_hit++;
					level notify( "civilian_killed", attacker );
				}
				else
				{
					attacker maps\_player_stats::register_kill( self, type, weapon );
					attacker notify( "ui_kill_count", attacker.stats[ "kills" ] );
					
					level notify( "target_killed" );
					
					if ( self has_script_parameter( "breach", ";" ) )
					{
						level.breachEnemies_active--;
					}
					
					parent_struct.targets_enemy_killed++;
					
					if ( parent_struct.targets_enemy_killed >= parent_struct.targets_enemy.size )
					{
						parent_struct notify( "all_targets_down" );
					}
				}
				
				if ( type == "MOD_GRENADE_SPLASH" )
				{
					self notify( "hit_with_grenade" );
				}
				break;
			}
		}
		
		/*-----------------------
		TARGET OUT OF PLAY TILL TOLD TO POP UP AGAIN
		-------------------------*/		
		if ( IsDefined( self.meleeonly ) )
		{
			self.melee_clip hide_entity();
		}
		
		self notify ( "hit" );
		self notify ( "target_going_back_down" );
		self.health = 1000;
		aim_assist_target DisableAimAssist();
		self NotSolid();
		
		// If the target was bouncing as it moved
		// make sure to set it back to the last valid
		// position
		if ( IsDefined( self.orgEnt.drop_origin ) )
		{
			self.orgEnt.origin = self.orgEnt.drop_origin;
		}
		
		if ( self has_script_parameter( "reverse", ";" ) )
		{
			self.orgEnt RotatePitch( 90, 0.25 );
		}
		else if ( self has_script_parameter( "sideways_right", ";" ) )
		{
			self.orgEnt RotateYaw( -180, 0.35 );
		}
		else if ( self has_script_parameter( "sideways_left", ";" ) )
		{
			self.orgEnt RotateYaw( 180, 0.35 );
		}
		else if ( self has_script_parameter( "vertical", ";" ) )
		{
			self.orgEnt MoveTo( self.orgEnt.origin - (0,0,36), 0.25 );
		}
		else
		{
			self.orgEnt RotatePitch( -90, 0.25 );
		}
		
		self.target_model SetCanDamage( false );
		wait 0.25;
	}
}

so_player_tooclose_wait()
{
	origin = self.origin;

	y_check = undefined;
	if ( self has_script_parameter( "melee", ";" ) )
	{
		origin = ( -5723, 2547, -49 ); // Just under the melee target
		y_check = 2520;
	}

	while ( 1 )
	{
		close = false;
		foreach ( player in level.players )
		{
			dist_test = 56 * 56;
			if ( Length( player GetVelocity() ) > 200 )
			{
				dist_test = 128 * 128;
			}

			if ( DistanceSquared( player.origin, origin ) < dist_test )
			{
				close = true;

				if ( IsDefined( y_check ) && player.origin[ 1 ] < y_check )
				{
					close = false;
				}
			}
		}

		if ( !close )
		{
			return;
		}

		wait( 0.05 );
	}
}

target_lateral_movement()
{
	dummy = Spawn( "script_origin", ( 0, 0, 0 ) );
	dummy.angles = self.orgEnt.angles;
	dummy.origin = self.orgEnt.origin;
	self.orgEnt thread target_move_with_dummy( dummy );
	
	dummy endon( "deleted_because_player_was_too_close" );
	dummy endon( "death" );
	foreach ( player in level.players )
	{
		dummy thread delete_when_player_too_close( player );
	}

	self thread dummy_delete_when_target_goes_back_down( dummy );
	
	// Targets in MW2 moved one ft per second so presever that here
	// unless over written by script_speed field.
	feet_per_sec = ter_op( IsDefined( self.script_speed ), self.script_speed, 1 );
	
	dist = Distance( self.lateralMovementOrgs[ 0 ].origin, self.lateralMovementOrgs[ 1 ].origin );
	time = dist / ( 12.0 * feet_per_sec );
	while ( true )
	{
		dummy MoveTo( self.lateralEndPosition.origin, time );
		wait( time );
		dummy MoveTo( self.lateralStartPosition.origin, time );
		wait( time );
	}
}

target_play_dog_bark()
{
	level endon( "special_op_terminated" );
	self endon( "target_going_back_down" );
	
	while ( 1 )
	{
		self PlaySound( "anml_dog_bark", "bark_done" );
		self waittill( "bark_done" );
		
		wait( RandomFloatRange( 0.1, 0.5 ) );
	}
}

target_path_movement()
{
	dummy = Spawn( "script_origin", ( 0, 0, 0 ) );
	dummy.angles = self.orgEnt.angles;
	dummy.origin = self.orgEnt.origin;
	
	if ( self has_script_parameter( "bounce", ";" ) )
	{
		self.orgEnt thread target_move_with_dummy( dummy, 8, 2.0 );
	}
	else
	{
		self.orgEnt thread target_move_with_dummy( dummy, 0, 0.0 );
	}
	
	dummy endon( "deleted_because_player_was_too_close" );
	dummy endon( "death" );
	foreach ( player in level.players )
	{
		dummy thread delete_when_player_too_close( player );
	}

	self thread dummy_delete_when_target_goes_back_down( dummy );
	
	for ( i = 0; i < self.move_orgs.size - 1; i++ )
	{
		// Targets in MW2 moved one ft per second so presever that here
		// unless over written by script_speed field.
		feet_per_sec = ter_op( IsDefined( self.script_speed ), self.script_speed, 1 );
		
		dist = Distance( self.move_orgs[ i ].origin, self.move_orgs[ i + 1 ].origin );
		time = dist / ( 12.0 * feet_per_sec );
		
		dummy MoveTo( self.move_orgs[ i + 1 ].origin, time );
		wait( time );
	}
	
	dummy Delete();
}

dummy_delete_when_target_goes_back_down( dummy )
{
	dummy endon( "death" );
	//self --> the target
	self waittill( "target_going_back_down" );
	dummy Delete();
}

delete_when_player_too_close( player )
{
	//want to stop lateral movement if player is too close to avoid getting stuck
	self endon( "death" );
	dist = 128;
	distSquared = dist * dist;
	while ( true )
	{
		wait( 0.05 );
		if ( DistanceSquared( player.origin, self.origin ) < distSquared )
			break;
	}
	self notify( "deleted_because_player_was_too_close" );
	self Delete();
}

target_move_with_dummy( dummy, bounce_height, bounce_ft_per_sec )
{
	dummy endon( "death" );
	
	moving_up					= true;
	vertical_move_each_update	= 0;
	vertical_offset				= 0;
	
	if ( IsDefined( bounce_height ) && IsDefined( bounce_ft_per_sec ) )
	{
		// convert ft per second 
		bounce_inches_per_sec = 12.0 * bounce_ft_per_sec;
		vertical_move_each_update = bounce_inches_per_sec / 20.0;
	}
	else
	{
		bounce_height = 0.0;
	}
	
	while ( true )
	{
		wait( 0.05 );
		
		if ( moving_up )
		{
			vertical_offset += vertical_move_each_update;
			if ( vertical_offset > bounce_height )
			{
				vertical_offset = bounce_height;
				moving_up = false;
			}
		}
		else
		{
			vertical_offset -= vertical_move_each_update;
			if ( vertical_offset < 0.0 )
			{
				vertical_offset = 0.0;
				moving_up = true;
			}
		}
		
		self.drop_origin = dummy.origin;
		self.origin = dummy.origin + ( 0, 0, vertical_offset );
	}
}

target_lateral_reset_start_pos()
{
	if ( self.lateralMovementOrgs[ 0 ] has_script_parameter( "force_start_here", ";" ) )
	{
		self.lateralStartPosition = self.lateralMovementOrgs[ 0 ];
		self.lateralEndPosition = self.lateralMovementOrgs[ 1 ];
	}
	else if ( self.lateralMovementOrgs[ 1 ] has_script_parameter( "force_start_here", ";" ) )
	{
		self.lateralStartPosition = self.lateralMovementOrgs[ 1 ];
		self.lateralEndPosition = self.lateralMovementOrgs[ 0 ];
	}
	else if ( cointoss() )
	{
		self.lateralStartPosition = self.lateralMovementOrgs[ 0 ];
		self.lateralEndPosition = self.lateralMovementOrgs[ 1 ];
	}
	else
	{
		self.lateralStartPosition = self.lateralMovementOrgs[ 1 ];
		self.lateralEndPosition = self.lateralMovementOrgs[ 0 ];
	}

	self.orgEnt MoveTo( self.lateralStartPosition.origin, .1 );

}

door_think()
{
	rotation = -90;
	
	if ( IsDefined( self.script_goalyaw ) )
	{
		rotation = self.script_goalyaw;
	}
		
	self waittill( "open" );
	
	self RotateYaw( rotation, 0.5, 0.2, 0.1 );
}

// -.-.-.-.-.-.-.-.-.-.- HUD -.-.-.-.-.-.-.-.-.-.- //

setup_all_player_hud()
{
	foreach ( player in level.players )
	{
		player setup_player_hud();
	}
	
	thread catch_civilian_hits();
}

setup_level_hud()
{
	level.splash_count = 0;
	level.splash_counted = 1;
}

msg_splash( type )
{	
	level.splash_count++;
	num = level.splash_count;

	if ( level.splash_count - level.splash_counted > 0 )
	{
		level waittill( "pre_display_splash" + num );
	} 

	if ( flag( "special_op_terminated" ) )
	{
		return;
	}

	if ( type == "civilian_hit" )
	{
		str = &"SO_DELTACAMP_CIVILIAN_HIT";
	}
	else
	{
		level thread play_sound_in_space( "emt_airhorn_area_clear", level.player.origin + ( 0, 0, 40 ) );
		str = &"SO_DELTACAMP_AREA_CLEARED";
	}

	splash = so_create_hud_item( 2, 0, str );
	splash.alignx = "center";
	splash.horzAlign = "center";
	splash.fontscale = 2;

	if ( type == "civilian_hit" )
	{
		splash set_hud_red();
	}
	else
	{
		splash set_hud_yellow();
	}
	
	wait( 0.2 );
	time = 1;
	splash FadeOverTime( time );
	splash.alpha = 0;
	
	splash ChangeFontScaleOverTime( time );
	splash.fontscale = 0.5;
	
	wait( time * 0.75 );

	level notify( "pre_display_splash" + ( num + 1 ) );
	level.splash_counted++;

	wait( time * 0.25 );
	
	splash Destroy();
}

HUD_area_cleared()
{
	wait( 0.05 );
	msg_splash( "area_cleared" );
}

HUD_civilian_hit()
{
	msg_splash( "civilian_hit" );
}

custom_eog_summary()
{	
	time_mil_total	= level.challenge_end_time - level.challenge_start_time;
	// Divide by 1000 instead of multiplying by
	// 0.001 because the latter causes excess
	// decimal places due to floating point error - JC
	time_string 	= convert_to_time_string( time_mil_total / 1000, true );
	
	// Figure out time's contribution to score
	time_mil_limit	= 50000;
	time_mil_remain = Int( Max( time_mil_limit - time_mil_total, 0 ) );
	
	score_time	= Int( ( time_mil_remain / time_mil_limit ) * 8000 );
	score_kills	= 0;
	foreach ( player in level.players )
	{
		score_kills += 100 * player.stats[ "kills" ];
	}
	score_civs	= level.civs_hit * -500;
	score_final	= Int( Max( score_time + score_kills + score_civs, 0 ) );
	
	foreach ( player in level.players )
	{
		// Force game skill reward before anything else so
		// functions checking start completion below know how the
		// current players did.
		player.forcedGameSkill = player.so_hud_star_count;
		
		p1_kills		= player.stats[ "kills" ];
		p1_civs			= player.civs_hit;
		
		if ( is_coop() )
		{
			p2_kills	= get_other_player( player ).stats[ "kills" ];
			p2_civs		= get_other_player( player ).civs_hit;
						
			if ( IsDefined( level.MissionFailed ) && level.MissionFailed == true )
			{
				setdvar( "ui_hide_hint", 0 );
				
				player add_custom_eog_summary_line( "",										"@SPECIAL_OPS_PERFORMANCE_YOU", 	"@SPECIAL_OPS_PERFORMANCE_PARTNER" );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_FINISH_TIME", time_string,						time_string );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_ENEMIES_HIT", p1_kills,							p2_kills );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_CIVS_HIT",	p1_civs,							p2_civs );
			}
			else
			{
				setdvar( "ui_hide_hint", 1 );	
				
				player add_custom_eog_summary_line( "",										"@SPECIAL_OPS_PERFORMANCE_YOU", 	"@SPECIAL_OPS_PERFORMANCE_PARTNER",	"@SPECIAL_OPS_UI_SCORE" );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_FINISH_TIME", time_string,						time_string,						score_time );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_ENEMIES_HIT", p1_kills,							p2_kills,							score_kills );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_CIVS_HIT",	p1_civs,							p2_civs,							score_civs );
				player add_custom_eog_summary_line_blank();
				
				if ( !player completed_all_difficulties() )
				{
					player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_MEDAL_NEXT_TIME",																	player get_next_medal_time_string() );
					
					if ( !issplitscreen() )
						player add_custom_eog_summary_line_blank();
				}				
				
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TEAM_SCORE",																					score_final );
			}
		}
		else
		{
			if ( IsDefined( level.MissionFailed ) && level.MissionFailed == true )
			{
				setdvar( "ui_hide_hint", 0 );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_FINISH_TIME", 	time_string );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_ENEMIES_HIT", 	p1_kills );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_CIVS_HIT",		p1_civs );
			}
			else
			{
				setdvar( "ui_hide_hint", 1 );
				player add_custom_eog_summary_line( "", 										"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_UI_SCORE" );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_FINISH_TIME", 	time_string,					score_time );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_ENEMIES_HIT", 	p1_kills, 						score_kills );
				player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_CIVS_HIT",		p1_civs,						score_civs );
				player add_custom_eog_summary_line_blank();
				
				if ( !player completed_all_difficulties() )
				{
					player add_custom_eog_summary_line( "@SO_DELTACAMP_SCOREBOARD_MEDAL_NEXT_TIME",								player get_next_medal_time_string() );
				
					if ( !issplitscreen() )
						player add_custom_eog_summary_line_blank();
				}
									
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_SCORE_FINAL",												score_final );
			}
		}
		
		if ( !IsDefined( level.MissionFailed ) || level.MissionFailed == false )
		{
			// Override each player's time with the final time
			player override_summary_time( time_mil_total );
			player override_summary_score( score_final );
		}
	}
}

completed_all_difficulties()
{
	AssertEx( IsDefined( self ) && IsPlayer( self ), "Self must be player in completed_all_difficulties()." );
	// Difficulty is	1-easy, 2-regular, 3-hardened, 4-veteran
	completed_diff = self maps\_specialops::get_previously_completed_difficulty();
	
	// GameSkill is		0-easy, 1-regular, 2-hardened, 3-veteran
	if ( IsDefined( self.forcedGameSkill ) )
	{
		completed_diff = Int( max( completed_diff, self.forcedGameSkill + 1 ) );
	}
	
	return completed_diff == 4;
}

get_next_medal_time_string()
{
	AssertEx( IsDefined( self ) && IsPlayer( self ), "Self must be player in get_next_medal_time_string()." );
	
	next_medal = get_next_medal();
	next_medal_time_sec = 0;
	
	if ( level.trainer_version == 1 )
	{
		switch ( next_medal )
		{
			case 2:
				next_medal_time_sec = CONST_TRAINER_V1_TIME_HARDENED;
				break;
			case 3:
				next_medal_time_sec = CONST_TRAINER_V1_TIME_VETERAN;
				break;
			default:
				AssertMsg( "Invalid next_medal index of: " + next_medal + ". Should be 2 or 3" );
				next_medal_time_sec = CONST_TRAINER_V1_TIME_VETERAN;
				break;
		}
	}
	else if ( level.trainer_version == 2 )
	{
		switch ( next_medal )
		{
			case 2:
				next_medal_time_sec = CONST_TRAINER_V2_TIME_HARDENED;
				break;
			case 3:
				next_medal_time_sec = CONST_TRAINER_V2_TIME_VETERAN;
				break;
			default:
				AssertMsg( "Invalid next_medal index of: " + next_medal + ". Should be 2 or 3" );
				next_medal_time_sec = CONST_TRAINER_V2_TIME_VETERAN;
				break;
		}
	}
	
	return convert_to_time_string( next_medal_time_sec, true );
}

// Bronze (Reg) = 1, Silver (Hard) = 2, Gold (Vet) = 3
get_next_medal()
{
	// Difficulty is	1-easy, 2-regular, 3-hardened, 4-veteran, 
	next_medal_num = self get_previously_completed_difficulty();
	
	// GameSkill is		0-easy, 1-regular, 2-hardened, 3-veteran
	if ( IsDefined( self.forcedGameSkill ) )
	{
		next_medal_num = Int( max( next_medal_num, self.forcedGameSkill + 1 ) );
	}
	AssertEx( next_medal_num == 2 || next_medal_num == 3, "Get next medal called when player has all medals" );
	
	return next_medal_num;
}

// -.-.-.-.-.-.-.-.-.-.- Utility -.-.-.-.-.-.-.-.-.-.- //

has_script_parameter( parameter, delimiter )
{
	Assert( IsDefined( parameter ) );
	Assert( IsDefined( delimiter ) );
	
	if ( !IsDefined( self ) || !IsDefined( self.script_parameters ) )
	{
		return false;
	}
	
	array_params = StrTok( self.script_parameters, delimiter );
	
	return array_contains( array_params, parameter );
}

replace_script_parameter( parameter_old, parameter_new, delimiter )
{
	Assert( IsDefined( parameter_old ) );
	Assert( IsDefined( parameter_new ) );
	Assert( IsDefined( delimiter ) );
	
	if ( !IsDefined( self ) || !IsDefined( self.script_parameters ) )
	{
		return false;
	}
	
	array_params = StrTok( self.script_parameters, delimiter );
	
	parameter_string = "";
	foreach( param in array_params )
	{
		if ( parameter_string != "" )
		{
			parameter_string += delimiter;
		}
		
		if ( param == parameter_old )
		{
			parameter_string += parameter_new;
		}
		else
		{
			parameter_string += param;
		}
	}
	
	self.script_parameters = parameter_string;
}

// -.-.-.-.-.-.-.-.-.-.- Door Logic (Copied from trainer) -.-.-.-.-.-.-.-.-.-.- //

make_door_from_prefab( sTargetname )
{
	ents = getentarray( sTargetname, "targetname" );
	door_org = undefined;
	door_models = [];
	door_brushes = [];
	door_trigger = undefined;
	door_blocker = undefined;
	foreach( ent in ents )
	{
		if ( ent.code_classname == "script_brushmodel" )
		{
			door_brushes[ door_brushes.size ] = ent;
			if ( ( isdefined( ent.script_noteworthy ) ) && ( ent.script_noteworthy == "blocker" ) )
				door_blocker = ent;
			continue;
		}
		if ( ent.code_classname == "script_origin" )
		{
			door_org = ent;
			continue;
		}
		if ( ent.code_classname == "script_model" )
		{
			door_models[ door_models.size ] = ent;
			continue;
		}
		if ( ent.code_classname == "trigger_radius" )
		{
			door_trigger = ent;
			continue;
		}
		
	}
	
	
	foreach( model in door_models )
		model linkto( door_org );
	foreach( brush in door_brushes )
		brush linkto( door_org );
	
	door = door_org;
	door.brushes = door_brushes;
	
	
	if ( isdefined( door_blocker ) )
	{
		door_blocker unlink();
		door.blocker = door_blocker;
	}
		
	if ( isdefined( door_trigger ) )
		door.trigger = door_trigger;
	
	return door;
}

door_open( sFlagToWaitFor, bFast, silent )
{
	if ( isdefined( self.moving ) )
	{
		while( isdefined( self.moving ) )
			wait( 0.05 );
	}
	
	self.moving = true;
	angles = 90;
	if ( isdefined( self.openangles ) )
		angles = self.openangles;
	
	//wait for flag if there
	if ( isdefined( sFlagToWaitFor ) )
		flag_wait( sFlagToWaitFor );
	
	iTime = 4;
	if ( isdefined( bFast ) )
	{
		iTime = 1.5;
		self rotateto( self.angles + ( 0, angles, 0 ), 1.5, .25, .25 );
	}
	else
	{
		self rotateto( self.angles + ( 0, angles, 0 ), 4, 1.5, 1.5 );
	}

	
	if( isdefined( self.blocker ) )
	{
		self.blocker hide_entity();
	}
	
	if ( !IsDefined( silent ) || silent == false )
	{
		self thread play_sound_on_entity( "scn_training_fence_open" );
	}

	array_call( self.brushes,::notsolid );
	wait( iTime );
	self.moving = undefined;
}

door_close( sFlagToWaitFor, bFast )
{
	if ( isdefined( self.moving ) )
	{
		while( isdefined( self.moving ) )
			wait( 0.05 );
	}
	
	self.moving = true;
	angles = -90;
	if ( isdefined( self.closeangles ) )
		angles = self.closeangles;
	
	//wait for flag if there
	if ( isdefined( sFlagToWaitFor ) )
		flag_wait( sFlagToWaitFor );

	iTime = 2;
	if ( isdefined( bFast ) )
	{
		iTime = 1;
		self rotateto( self.angles + ( 0, angles, 0 ), 1, .25, .25 );
	}
	else
	{
		self rotateto( self.angles + ( 0, angles, 0 ), 2, .5, .5 );
	}
	
	if( isdefined( self.blocker ) )
			self.blocker show_entity();
	self thread play_sound_on_entity( "scn_training_fence_close" );
	array_call( self.brushes,::solid );
	wait( iTime );
	self.moving = undefined;
}
