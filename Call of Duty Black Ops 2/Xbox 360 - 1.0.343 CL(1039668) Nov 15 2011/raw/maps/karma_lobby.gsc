#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_objectives;
#include maps\_scene;
#include maps\karma_util;
#include maps\_glasses;

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
	flag_init( "player_entered_service_area" );
	flag_init( "stop_lobby_civs" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_lobby()
{
	// Prep the elevator and teleport it
	bm_lift_left  	= GetEnt( "tower_lift_left",  "targetname" );
	a_doors = GetEntArray( bm_lift_left.target, "targetname" );
	foreach( m_door in a_doors )
	{
		m_door LinkTo( bm_lift_left );
	}

	e_align 		= GetEnt( "align_player", "targetname" );
	e_align LinkTo( bm_lift_left );

	s_dest = GetStruct( "lobby_lift_left", "targetname" );
	bm_lift_left.origin = s_dest.origin;
	
	level.ai_harper 	= init_hero( "harper" );
	level.ai_salazar	= init_hero( "salazar" );

	start_teleport( "skipto_lobby" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	flag_wait( "karma_gump_hotel" );
	
	maps\karma_anim::lobby_anims();

	// Initialization
	clientnotify( "slpa" );		// 
	level thread start_civilians( "stop_lobby_civs" );
//	level thread temp_civ_count();

	flag_wait( "elevator_reached_lobby" );

	level thread maps\createart\karma_art::karma_fog_atrium();
	wait( 0.1 );

	e_obj_marker = GetEnt( "t_dropdown_start", "targetname" );
   	set_objective( level.OBJ_FIND_CRC, e_obj_marker );

   	// Harper runs into Karma
	karma_elevator_scene();

	level thread farid_comm_one();	
	level thread eye_scan_bink();

	flag_wait( "player_entered_service_area" );

	flag_set( "player_act_normally" );
	autosave_by_name( "karma_lobby_end" );

	level thread lobby_cleanup();
	level thread open_crc_elevator_door();
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
//
start_civilians( str_kill_flag )
{
	level thread maps\karma_civilians::spawn_civs( "civ_spawn", 30, "civ_initial", 15, str_kill_flag, 0.5, 2.0 );

	// Drones
	maps\karma_civilians::assign_civ_drone_spawners( "lobby_drones" );
	maps\karma_civilians::assign_wander_anim_points( "poi_lobby", "script_noteworthy" );
	maps\_drones::drones_setup_unique_anims( "lobby_drones", level.drones.anims[ "civ_walk" ] );
	maps\_drones::drones_speed_modifier( "lobby_drones", -0.1, 0.1 );
	maps\_drones::drones_set_max( 75 );

	// Static drones are spawned in a non-threaded manner so we spawn all of 
	//	our statics without worrying about randomly spawned drones choking
	//	our throughput
	level maps\karma_civilians::spawn_static_drones( "lobby_drones", "static_lobby_civs" );

	level thread maps\_drones::drones_start( "lobby_drones" );
	
	// Shrimps
	//start_shrimp_path( shrimp_effect, str_path_start, min_speed, max_speed, min_respawn_delay, max_respawn_delay, start_delay, str_kill_flag )
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_3n_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_3n_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_3s_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_3s_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_3e_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_3e_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_3w_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_3w_left",  2, 4, 3, 15, undefined, str_kill_flag );

	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_4n_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_4n_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_4s_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_4s_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_4e_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_4e_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_4w_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_4w_left",  2, 4, 3, 15, undefined, str_kill_flag );

	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_5n_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_5n_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_5s_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_5s_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_5e_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_5e_left",  2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "lobby_shrimps_5w_right", 2, 4, 3, 15, undefined, str_kill_flag );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"],  "lobby_shrimps_5w_left",  2, 4, 3, 15, undefined, str_kill_flag );

	flag_wait( str_kill_flag );
	
	stop_civilians();
}


//
//	Delete all active civilians, but not spawners or triggers.
stop_civilians()
{
	// Clear out the civs
	level thread maps\_drones::drones_delete_spawned();
	level thread maps\karma_civilians::delete_all_civs();
}

//
//	Harper runs into Karma
karma_elevator_scene()
{
	// Elevator arrives at the lobby.  Open doors
	bm_lift_left  = GetEnt( "tower_lift_left",  "targetname" );
	bm_lift_left  thread elevator_move_doors( true, 2.0, 0.5, 0.5 );

	bm_clip = GetEnt( "clip_lobby_elevator", "targetname" );
	bm_clip trigger_off();
	
	level.ai_harper thread harper_think();
	level.ai_salazar thread salazar_think();

	run_scene_and_delete( "tower_lift_exit" );
	level thread run_scene_and_delete( "tower_lift_exit_wait" );
	
	flag_wait( "player_in_lobby" );	// trigger
	
	// Farid PIP - tells player that enemy is aware of your presence.	
	
	bm_clip trigger_on();

	bm_lift_left thread elevator_move_doors( false, 2.0, 0.5, 0.5 );
	
	// SOUND - Shawn J
	//iprintlnbold ("doors_close_final");
	playsoundatposition ("amb_elevator_close_b", (4589, -5376, -3908));

	// wait for the elevator doors to close
	wait( 5.0 );
	end_scene( "tower_lift_exit_wait" );
	
	//SOUND - Shawn J - deleting temp elevator ents
	//	Added checks in case you use a skipto
	if ( IsDefined( level.sound_elevator_ent_1 ) )
	{
		level.sound_elevator_ent_1 delete();
	}
	if ( IsDefined( level.sound_elevator_ent_2 ) )
	{
		level.sound_elevator_ent_2 delete();
	}
}

//
//	Handles Harper's movement through this event.
//	self is Harper
harper_think()
{
	self.ignoreall = true;
	self Unlink();	// Unlink from the elevator
	self maps\karma_civilians::set_civilian_run_cycle( "civ_walk" );
	self gun_remove();

	self harper_get_to_room();
}


//
//	Salazar's movement through the lobby
salazar_think()
{
	self.ignoreall = true;
	self Unlink();	// Unlink from the elevator
	self maps\karma_civilians::set_civilian_run_cycle( "civ_walk" );
	self gun_remove();
}


//
// Farid PIP - tells player that enemy is aware of your presence.	
//
farid_comm_one()
{
	flag_wait( "player_in_lobby" );
	//SOUND - Shawn J
	level.sound_lobby_ent = spawn( "script_origin", level.player.origin );
	
	wait 3;
	
	level.ai_farid = init_hero( "farid" );	
	
	// Setup generic align node
	s_align = GetStruct( "generic_align", "targetname" );
	s_align.origin = level.ai_farid.origin;
	s_align.angles = level.ai_farid.angles;
	
	// spawn our tag_origin for the animation and link the camera to it
	m_tag_origin = Spawn( "script_model", level.ai_farid.origin ); //Important
	m_tag_origin SetModel( "tag_origin_animate" ); //Important
	m_tag_origin.animname = "farid_camera";
	level.e_extra_cam.origin = m_tag_origin.origin;
	level.e_extra_cam.angles = m_tag_origin.angles;
	level.e_extra_cam LinkTo( m_tag_origin, "origin_animate_jnt" );

	wait 1.0;
	
	turn_on_extra_cam();
	//SOUND - Shawn J
	level.player playsound ("evt_pnp_on");
	level.sound_lobby_ent playloopsound( "evt_pnp_loop", 1 );

	wait 0.5;
	
	run_scene_and_delete( "first_farid_call" );
	
	turn_off_extra_cam();
	//SOUND - Shawn J
	level.player playsound ("evt_pnp_off");
	level.sound_lobby_ent stoploopsound ();
	
	wait 1;

	//SOUND - Shawn J	
	level.sound_lobby_ent delete();
		
	level.e_extra_cam Unlink();
//	m_tag_origin Delete();	// Deleted by scene
	
	delete_hero( level.ai_farid );	
}

open_crc_elevator_door()
{
	level thread run_scene_and_delete("open_crc_lobby_entry_elevator");
	level thread run_scene_and_delete("open_crc_lobby_exit_elevator");
}

eye_scan_bink()
{
	flag_wait( "player_in_lobby" );
	
	wait 5;
	
	
//play_bink_on_hud( bink_name, hud_entity, hud_material, width, height, duration, is_inMemory, is_looping, endon_notify )
//	bomb_hud = NewHudElem();
//	bomb_hud.x = 515;
//	bomb_hud.y = 20;
//	bomb_hud.sort = 0;	
//	bomb_hud.alpha = 1;
//	
//	bomb_hud = create_on_screen_bink_hud(515, 20, 200, 175, "mtl_karma_retina_bink");

	level thread play_bink_on_hud_glasses("eye_v2");

}

//
//	Tells Harper to go to the room.  This can be short-circuited if the player
//	gets to the room first.
//	self is Harper
harper_get_to_room()
{
	// Go to the hotel room
	n_destination = GetNode( "nd_hotel_room_entrance", "targetname" );
	self force_goal( n_destination, 32 );
	self waittill( "goal" );
}


/*
//
//	Wait for the player to use the door.
hotel_room_door_use()
{
	self endon( "player_in_hotel_room" );
	
	self ent_flag_init( "door_open" );
	
	trigger_wait( "trig_hotel_room_door" );
	
	level.player playsound( "evt_hotel_door_open" );

	self thread hotel_room_door_open();
	
	flag_set( "player_opening_door" );
	run_scene_and_delete( "open_hotel_room_player" );
	flag_clear( "player_opening_door" );
}


//
//	Move the door
hotel_room_door_open()
{
	n_yaw = 90;
	n_time = 2.0;
	n_accel = 0.2;	
	n_decel = 0.5;

	// Use trigger for the door	
	t_use = GetEnt( "trig_hotel_room_door", "targetname" );

	// Open
	t_use trigger_off();
	level.m_hotel_room_door RotateYaw( n_yaw, n_time, n_accel, n_decel );
	level.m_hotel_room_door ent_flag_set( "door_open" );
	wait( n_time + 2.0 );	//	Give time for Harper to go through

	// Don't close the door on the player	
	while ( Distance2D( level.player.origin, level.m_hotel_room_door.origin ) < 64 )
	{
		wait( 0.5 );
	}
	
	// Close
	level.m_hotel_room_door RotateYaw( -1*n_yaw, n_time, n_accel, n_decel );
	wait( n_time );

	level.m_hotel_room_door ent_flag_clear( "door_open" );
	t_use trigger_on();
}
*/


//
//	Cleanup lobby ents, kill all civs
//	NOTE: Make sure there's no waiting in this func when run through a later skipto.
lobby_cleanup()
{
	// wait until the player rappels, the point of no turning back
	flag_wait( "player_rappel" );

	a_cleanup = GetEntArray( "lobby", "script_noteworthy" );
	foreach( e_cleanup in a_cleanup )
	{
		e_cleanup Delete();
	}

	flag_set( "stop_lobby_civs" );
}