#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_dialog;
#include maps\_objectives;
#include maps\_scene;
#include maps\_glasses;
#include maps\karma_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
//	flag_init( "hotel_room_door_open" );
//	flag_init( "player_opening_door" );
//	flag_init( "player_in_hotel_room" );
//	flag_init( "harper_in_hotel_room" );
	flag_init( "elevator_reached_lobby" );	// triggered
	flag_init( "player_entered_service_area" );
	flag_init( "stop_lobby_civs" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
// 	add_spawn_function_group( "tarmac_workers", "targetname", ::add_cleanup_ent, "checkin" );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_lobby()
{
	level.ai_harper 		= init_hero( "harper", ::attach_briefcase );
	level.ai_salazar		= init_hero( "salazar", ::attach_briefcase );

	skipto_teleport( "skipto_lobby" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	maps\karma_anim::lobby_anims();

	// Initialization
	clientnotify( "slpa" );		// Start lobby public announcements
	level thread start_civilians( "stop_lobby_civs" );

	thread run_scene( "dropdown_entry_elevator_open" );
	level thread manage_employee_door();
//	level thread temp_civ_count();

	flag_wait( "elevator_reached_lobby" );

	level thread maps\createart\karma_art::vision_set_change( "karma_atrium" );
	wait( 0.1 );

	e_obj_marker = GetEnt( "t_dropdown_start", "targetname" );
   	set_objective( level.OBJ_FIND_CRC, e_obj_marker );

   	// Harper runs into Karma
	level thread farid_comm_one();	
	karma_elevator_scene();
	SetSavedDvar( "g_speed", 250 );
	
	flag_wait( "player_entered_service_area" );

	autosave_by_name( "karma_lobby_end" );

	level thread lobby_cleanup();
}


temp_civ_count()
{
	wait( 20.0 );
	
	while (1)
	{
		a_civs = GetAIArray( "neutral" );
		if ( a_civs.size < 28 )
		{
			iPrintlnBold( "possible civ drop" );
		}
		wait( 1.0 );
	}
}

/* ------------------------------------------------------------------------------------------
	SUPPORT functions
 -------------------------------------------------------------------------------------------*/


//
// Spawn AI, drone and shrimp civilians in the atrium
start_civilians( str_kill_flag )
{
	assign_civ_spawners( "civ_lobby" );

	// AI
	maps\karma_civilians::assign_wander_anim_points( "poi_lobby", "script_noteworthy" );
	level thread maps\karma_civilians::spawn_civs( "civ_spawn", 30, "civ_initial", 15, str_kill_flag, 0.5, 2.0 );

	// Drones
//	maps\karma_civilians::assign_civ_drone_spawners( "civ_lobby", "lobby_drones" );
	maps\karma_civilians::assign_civ_drone_spawners( "civ_lobby_light", "lobby_drones" );
	maps\_drones::drones_setup_unique_anims( "lobby_drones", level.drones.anims[ "civ_walk" ] );
	//maps\_drones::drones_speed_modifier( "lobby_drones", -0.1, 0.1 );
	maps\_drones::drones_set_max( 75 );

	// Static drones are spawned in a non-threaded manner so we spawn all of 
	//	our statics without worrying about randomly spawned drones choking
	//	our throughput
	level maps\karma_civilians::spawn_static_civs( "static_lobby_civs" );

	level thread maps\_drones::drones_start( "lobby_drones" );

	// Shrimps
	CONST n_speed_min = 2;
	CONST n_speed_max = 3.5;
	CONST n_respawn_delay_min = 3;
	CONST n_respawn_delay_max = 15;
	//start_shrimp_path( shrimp_effect, str_path_start, min_speed, max_speed, min_respawn_delay, max_respawn_delay, start_delay, str_kill_flag )
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3n_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3n_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3s_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3s_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3e_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3e_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3w_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_3w_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );

	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4n_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4n_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4s_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4s_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4e_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4e_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4w_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_4w_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );

	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5n_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5n_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5s_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5s_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5e_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5e_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5w_right", n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["fx_kar_shrimp_civ"], "lobby_shrimps_5w_left",  n_speed_min, n_speed_max, n_respawn_delay_min, n_respawn_delay_max, undefined, str_kill_flag );
}


//
//	Delete all active civilians, but not spawners or triggers.
stop_civilians()
{
	flag_set( "stop_lobby_civs" );

	// Clear out the civs
	level thread maps\_drones::drones_delete_spawned();
	level thread maps\karma_civilians::delete_all_civs();
}

//
//	Harper runs into Karma
karma_elevator_scene()
{
	CONST n_door_move_time = 1.0;
	CONST n_door_move_accel = 0.2;
	CONST n_door_move_decel = 0.5;

	// Elevator arrives at the lobby.  Open doors
	bm_lift_left  = GetEnt( "lobby_lift_left",  "targetname" );
	a_doors = GetEntArray( bm_lift_left.target, "targetname" );
	foreach( m_door in a_doors )
	{
		m_door LinkTo( bm_lift_left );
	}
	thread run_scene( "lobby_elevator_open" );
	bm_lift_left  thread elevator_move_doors( true, n_door_move_time, n_door_move_accel, n_door_move_decel );

	bm_clip = GetEnt( "clip_lobby_elevator", "targetname" );
	bm_clip trigger_off();

	level.ai_harper thread harper_think();
	level.ai_salazar thread salazar_think();

	thread run_scene( "tower_lift_exit_squad" );
	run_scene( "tower_lift_exit" );
	level thread run_scene( "tower_lift_exit_wait" );

//	while !t_lobby_elevator
	
	flag_wait( "player_in_lobby" );	// trigger
	
	// Farid PIP - tells player that enemy is aware of your presence.	
	
	bm_clip trigger_on();

	thread run_scene( "lobby_elevator_close" );
	bm_lift_left thread elevator_move_doors( false, n_door_move_time, n_door_move_accel, n_door_move_decel );
	
	// SOUND - Shawn J
	//iprintlnbold ("doors_close_final");
	playsoundatposition ("amb_elevator_close_b", (4589, -5376, -3908));

	// wait for the elevator doors to close
	wait( 5.0 );
	end_scene( "tower_lift_exit_wait" );
}

//
//	Handles Harper's movement through this event.
//	self is Harper
#using_animtree("generic_human");
harper_think()
{
	self.ignoreall = true;
	self maps\karma_civilians::set_civilian_run_cycle( undefined, level.scr_anim[ "hero" ][ "briefcase" ][ "walk" ] );
	self animscripts\anims::setIdleAnimOverride( level.scr_anim[ "hero" ][ "briefcase" ][ "idle" ] );
	self Unlink();	// Unlink from the elevator
	self gun_remove();
	self.disableTurns = true;
	self.disablearrivals = true;
	self.disableexits = true;

	self harper_get_to_room();
}


//
//	Salazar's movement through the lobby
#using_animtree("generic_human");
salazar_think()
{
	self.ignoreall = true;
	self maps\karma_civilians::set_civilian_run_cycle( undefined, level.scr_anim[ "hero" ][ "briefcase" ][ "walk" ] );
	self animscripts\anims::setIdleAnimOverride( level.scr_anim[ "hero" ][ "briefcase" ][ "idle" ] );
	self Unlink();	// Unlink from the elevator
	self gun_remove();
	self.disableTurns = true;
	self.disablearrivals = true;
	self.disableexits = true;

	nd_sal = getnode("nd_hotel_room_entrance_salazar", "targetname");
	self SetGoalNode( nd_sal );
}


//
// Farid PIP - tells player that enemy is aware of your presence.	
//
farid_comm_one()
{
	flag_wait( "player_in_lobby" );
	
	wait 3;
	
	level.ai_farid = simple_spawn_single( "farid" );	
	
	// spawn our tag_origin for the animation and link the camera to it
	m_tag_origin = Spawn( "script_model", level.ai_farid.origin ); //Important
	m_tag_origin SetModel( "tag_origin_animate" ); //Important
	m_tag_origin.animname = "farid_camera";
	level.e_extra_cam.origin = m_tag_origin.origin;
	level.e_extra_cam.angles = m_tag_origin.angles;
	level.e_extra_cam LinkTo( m_tag_origin, "origin_animate_jnt" );

	turn_on_extra_cam();
	level.player thread farid_call_dialog();
	run_scene( "first_farid_call" );
	run_scene( "first_farid_call" );
	run_scene( "first_farid_call" );
	turn_off_extra_cam();
		
	level.e_extra_cam Unlink();
	m_tag_origin Delete();	// Deleted by scene
	
	level.ai_farid Delete();
}


//
//	Tells Harper to go to the room.  This can be short-circuited if the player
//	gets to the room first.
//	self is Harper
harper_get_to_room()
{
	// Go to the hotel room
	n_destination = GetNode( "nd_hotel_room_entrance", "targetname" );
	self thread force_goal( n_destination, 32 );
}


//
//	Controls the automatic door that leads to the employee entrance
//
manage_employee_door()
{
	level endon( "player_rappel" );
	
	atrium_door = getent("atrium_door", "targetname");
	v_door_angles_open = atrium_door.angles;
	v_door_angles_close = (0,115, 0);
	atrium_door RotateTo( v_door_angles_close, 0.05);
	
	t_door = getent("atrium_door_trigger", "targetname");
	while(1)
	{
		while( !t_door istouching(level.player) && !t_door IsTouching(level.ai_salazar) && !t_door IsTouching(level.ai_harper) )
		{
			wait( 0.1 );
		}
		
		atrium_door RotateTo( v_door_angles_open, 0.5);
		wait( 2 );
		
		// wait until they're out of the way
		while( t_door istouching(level.player) || t_door IsTouching(level.ai_salazar) || t_door IsTouching(level.ai_harper) )
		{
			wait( 0.05 );
		}
		
		atrium_door RotateTo( v_door_angles_close, 0.5);
		wait( 0.05 );
	}
	
}


//
//	Cleanup lobby ents, kill all civs
//	NOTE: Make sure there's no waiting in this func when run through a later skipto.
lobby_cleanup()
{
	// wait until the player rappels, the point of no turning back
	trigger_wait("t_near_rope");

	a_cleanup = GetEntArray( "lobby", "script_noteworthy" );
	foreach( e_cleanup in a_cleanup )
	{
		e_cleanup Delete();
	}

	stop_civilians();
}


/////////////////////////////////////////////////////////////////////
//	D I A L O G
/////////////////////////////////////////////////////////////////////

//
//	Player dialog in the lobby/atrium
//	self is player
farid_call_dialog()
{
    self say_dialog("go_ahead_farid_002" );		//Go ahead, Farid.
    self say_dialog("youve_been_made_003" );	//You?ve been made.  DeFalco?s on board.  He knows your there.
    self say_dialog("you_sure_004" );			//You sure?
    self say_dialog("i_just_heard_him_t_005" );	//I just heard him talking to Menendez.  They?re moving on Karma now.
    self say_dialog("thanks_for_the_war_006" );	//Thanks for the warning, Farid.  We?ll be in touch.
    self say_dialog("heads_up_people_h_007" );	//Heads up, people - Menendez? men are moving on Karma.  Everyone stay sharp...
    self say_dialog("you_see_anything_o_008" );	//You see anything out of the ordinary - I want to hear about it.  Septic out.
}