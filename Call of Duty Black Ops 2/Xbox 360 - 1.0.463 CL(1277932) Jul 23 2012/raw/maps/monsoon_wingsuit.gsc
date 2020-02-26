#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\monsoon_util;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\monsoon.gsh;
	
#define WINGSUIT_SPEED 			200
#define WINGSUIT_SPEED_AI		220	
#define MPH_TO_INCHES_PER_SEC 	17.6	

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

skipto_suit_fly()
{
	//trigger the ambient effects during the wingsuit
	exploder( 33 );
	
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
	
	skipto_teleport_players( "wingsuit_start_spot" );
}

skipto_camo_intro()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
		
	skipto_teleport_players( "player_skipto_camo_intro" );
}


/* ------------------------------------------------------------------------------------------
	FLAGS
-------------------------------------------------------------------------------------------*/

init_wingsuit_flags()
{
	flag_init( "jet_stream_launch_started" );
	flag_init( "wingsuit_start_vo_done" );
	flag_init( "wingsuit_landing_started" );
	flag_init( "wingsuit_player_landed" );
	flag_init( "predator_intro_started" );
	flag_init( "predator_ai_suit_on" );
	flag_init( "predator_intro_scene_done" );
	
	//objectives
	flag_init( "jet_stream_launch_obj" );
	flag_init( "jet_stream_launch_obj_complete" );
	
	//controls
	flag_init( "input_lstick_detected" );
	flag_init( "input_trigs_detected" );
}

wingsuit_main()
{
	array_thread( GetEntArray( "trigger_water_sheeting", "targetname" ), ::trigger_water_sheeting_think );
	array_thread( GetEntArray( "trigger_tree_top", "targetname" ), ::trigger_tree_top_think );
	
	level.weather_wind_shake = false;
	level.player SetClientFlag( CLIENT_FLAG_PLAYER_WINGSUIT );
	level.player ClearClientFlag( CLIENT_FLAG_PLAYER_RAIN );
	
	//transition the skybox over 30 seconds
	level thread lerp_dvar( "r_skyTransition", 1, 30, true );
	
	jet_stream_launch();
	
	stop_exploder( 33 );  // stop beginning global cloud layer
	
	level.player ClearClientFlag( CLIENT_FLAG_PLAYER_WINGSUIT );
	level.player SetClientFlag( CLIENT_FLAG_PLAYER_RAIN );
	level.weather_wind_shake = true;

	array_delete( GetEntArray( "wingsuit_ambient_trigger", "script_noteworthy" ) );
}

trigger_water_sheeting_think()
{
	level endon( "final_approach_started" );
	
	while( 1 )
	{
		if( level.player IsTouching( self ) )
		{
			level.player SetWaterSheeting( 1, 2 );
			return;
		}
		wait 0.05;
	}
}

trigger_tree_top_think()
{
	level endon( "final_approach_started" );
	
	n_vo_index = 0;
	crash_vo[0] = "harp_easy_does_it_0";
	crash_vo[1] = "harp_watch_the_trees_0";
	crash_vo[2] = "harp_you_re_drifting_off_0";
	crash_vo[3] = "harp_dammit_man_0";
	crash_vo[4] = "harp_i_ve_seen_thanksgivi_0";
		
	while( 1 )
	{
		self waittill( "trigger" );
		
		if( flag( "wingsuit_start_vo_done" ) && ( n_vo_index < crash_vo.size ) )
		{
			level.harper thread say_dialog( crash_vo[ n_vo_index ] );
			n_vo_index++;
		}	
	
		Earthquake( 2.0, 0.75, level.player.origin, 500, level.player );
		level.player PlayRumbleOnEntity( "damage_heavy" );	
		level.player StartFadingBlur( 3, 1 );
		wait 1;
	}
}

jet_stream_launch()
{
	//LEE SOUND
	level clientnotify ( "wng_st" );
	
	level thread start_wingsuit_vo();
		
	//for objective tracking
	flag_set( "jet_stream_launch_obj_complete" );
	
	//run_scene( "leap_of_faith" );
	
	// start player wingsuit
	level.player.vh_wingsuit = level.player init_driveable_wingsuit();
	level.player.vh_wingsuit thread start_wingsuit( "path_wingsuit_player_intro" );
		
	//start allied wingsuits on splines
	level.harper delay_thread( 0.5, ::spawn_wingsuit_and_drive_on_path, "path_wingsuit_ai", 700 );
	level.salazar delay_thread( 0.7, ::spawn_wingsuit_and_drive_on_path, "path_wingsuit_ai", 900 );

	//set on a trigger during the flight at the cave
	flag_wait( "wingsuit_landing_started" );
		
	level.player.vh_wingsuit land_wingsuit( "wingsuit_final_approach_start" );
	
	//LEE SOUND
	level clientnotify ( "wg_st_dn" );
}

start_wingsuit_vo()
{
	wait 2;
	level.crosby say_dialog( "cros_this_is_crazy_secti_0" );
	wait 0.5;
	level.harper say_dialog( "harp_don_t_you_know_tha_0" );
	wait 1.2;
	level.crosby say_dialog( "cros_as_in_section_8_0" );
	wait 0.8;
	level.harper say_dialog( "harp_it_s_a_long_story_m_0" );
	
	flag_set( "wingsuit_start_vo_done" );
}

start_wingsuit( str_node ) //self = wingsuit
{
	level.player thread do_flight_feedback();
	
	nd_path = GetVehicleNode( str_node, "targetname" );
	
	self SetPathTransitionTime( 2 );
	self MakeVehicleUnusable();
	self go_path( nd_path );
	self maps\_vehicle::getoffpath();

	level.player thread player_wingsuit_tutorial();

	/* TODO
	// The right way to do it...after exes
	SetSavedDvar( "vehPlaneConventionalFlight", "1" );
	SetSavedDvar( "vehPlanePlayerAvoidance", "0" );	
	self SetSpeed( WINGSUIT_SPEED, 1000, 1000 );
	*/

	// Wrong way to do it...
	self thread set_driveable_wingsuit_speed( "final_approach_started", WINGSUIT_SPEED );

	wait 2;
	self thread wingsuit_collision_check();
}

land_wingsuit( str_node ) // self = wingsuit
{
	level notify( "final_approach_started" );
	
	nd_path = GetVehicleNode( str_node, "targetname" );
	
	self SetPathTransitionTime( 2 );
	self MakeVehicleUnusable();
	self go_path( nd_path );
	
	level.player Unlink();
	self Delete();
}

player_wingsuit_tutorial()
{
	self endon( "death" );
	
	screen_message_create( &"MONSOON_TUTORIAL_WINGSUIT" );
	wait 5;
	screen_message_delete();
}

//called on an AI, creates a wingsuit and attaches the AI to it.  Then places it on spline
#define PATH_OFFSET_X 0
#define PATH_OFFSET_Y 200
#define PATH_OFFSET_Z 100
#define PATH_OFFSET_T 5	
spawn_wingsuit_and_drive_on_path( str_node, n_ideal, n_min )
{
	self.vh_wingsuit = spawn_vehicle_from_targetname( "vh_wingsuit_spawner" );
	self.vh_wingsuit Hide();
	self LinkTo( self.vh_wingsuit, "tag_driver" );
	
	self thread do_flight_anims( "fwd_idle" );
		
	nd_start = GetVehicleNode( str_node, "targetname" );

	self.vh_wingsuit SetSpeed( WINGSUIT_SPEED_AI, WINGSUIT_SPEED );
	self.vh_wingsuit thread go_path( nd_start );
	self.vh_wingsuit PathVariableOffset( (PATH_OFFSET_X, PATH_OFFSET_Y, PATH_OFFSET_Z), PATH_OFFSET_T );
	self.vh_wingsuit thread _wingsuit_ally_speed_monitor( n_ideal, n_min );
	
	if( self == level.harper )
	{
		self.vh_wingsuit thread _wingsuit_ally_direct_vo();
	}
}

_wingsuit_ally_direct_vo()
{
	//TODO hook these lines into the spline nodes of the AI wingsuit
	wait 15;
	level.harper say_dialog( "harp_left_gotta_go_left_0" );
	wait 12;	
	level.harper say_dialog( "harp_right_man_0" );
	wait 2;
	level.harper say_dialog( "harp_there_the_gap_in_t_0" );
}

_wingsuit_ally_speed_monitor( n_ideal = 800, n_min = 400 )
{
	self endon ( "death" );
	
	n_distance_ideal = n_ideal * n_ideal;
	n_dist_too_close = n_min * n_min;
	
	e_player = level.player.vh_wingsuit;
	
	while ( !flag( "wingsuit_landing_started" ) )
	{
		n_dist = Distance2DSquared( self.origin, e_player.origin );
		
		//TODO determine if the ai is behind the player
		v_self_to_enemy = VectorNormalize( e_player.origin - self.origin );
		v_self_forward = VectorNormalize( AnglestoForward( self.angles ) );
		n_dot = VectorDot( v_self_forward, v_self_to_enemy );
		
		n_speed = e_player GetSpeedMPH();
				
		if ( n_dist > n_distance_ideal )	// if we're too far, slow down
		{
			n_speed *= 0.95;
		}
		else if ( n_dist < n_distance_ideal )	// have the ally speed up if too close
		{
			n_speed *= 1.2;
		}
		
		self SetSpeed( n_speed, WINGSUIT_SPEED_AI );

		wait 0.05;		
	}
}

/*--------------------------------------------------------------------
 * run_scene spawns guys - "targetname", "lz_patroller"
 * this is threaded so monsoon_ruins starts while the scene is running
 --------------------------------------------------------------------*/
camo_intro_main()
{
	//heavy rain	
	set_rain_level( 5 );
	
	ignore_squad( true );
			
	level thread camo_intro_harper();
	run_scene( "wingsuit_landing_player", 1 );
	flag_set( "wingsuit_player_landed" );
	level thread camo_intro_squad();
	
	level thread camo_intro_landing_vo();
	
	array_thread( get_heroes(), ::change_movemode, "cqb" );
			
	autosave_by_name( "player_landed" );
	
	// transition lz_patroller_2 from camo to not camoed before player sees him
	GetEnt( "lz_patroller_2", "targetname" ) add_spawn_function( ::camo_intro_camo_ai );
	
	trigger_wait( "trigger_start_camo_intro" );
	flag_set( "predator_intro_started" );
	
	array_thread( get_heroes(), ::reset_movemode );	
	
	t_lookat = GetEnt( "lookat_other_landing", "targetname" );
	t_lookat Delete();
	
	a_vh_wingsuits = GetEntArray( "vh_wingsuit_spawner", "targetname" );
	array_delete( a_vh_wingsuits );
	
	//thread so next section starts immediately
	level thread camo_intro_threaded();
}

camo_intro_landing_vo()
{
	level endon( "predator_intro_started" );
	
	level.harper say_dialog( "harp_you_good_0" );
	wait 0.8;
	level.player say_dialog( "sect_i_m_good_0" );
	wait 0.5;
	level.player say_dialog( "sect_salazar_crosby_y_0" );
	wait 1;
	level.salazar say_dialog( "sala_covered_ready_on_y_0" );
}

camo_intro_squad()
{
	level endon( "predator_intro_started" );
	
	nd_pos = GetNode( "crosby_landing", "targetname" );
	level.crosby ForceTeleport( nd_pos.origin, nd_pos.angles );
	level.crosby SetGoalNode( nd_pos );
		
	nd_pos = GetNode( "salazar_landing", "targetname" );
	level.salazar Unlink();
	end_scene( "salazar_fwd_idle" );
	level.salazar ForceTeleport( nd_pos.origin, nd_pos.angles );
	level.salazar SetGoalNode( nd_pos );

	trigger_wait( "lookat_other_landing" );
	
	level.salazar SetGoalNode( GetNode( "salazar_landing_goal", "targetname" ) );
	wait 2;
	level.crosby SetGoalNode( GetNode( "crosby_landing_goal", "targetname" ) );
}

camo_intro_harper()
{
	level endon( "wingsuit_landing_done" );
	
	//unlink Harper from his suit for the landing animation
	level.harper UnLink();
	level.harper thread say_dialog( "harp_follow_me_0" );
	run_scene( "wingsuit_landing_harper" );
	level thread run_scene( "wingsuit_landing_harper_loop" );
	
	//optionally set objective to enter
	set_objective( level.OBJ_REACH_LAB, GetEnt( "trigger_start_camo_intro", "targetname"), "enter" );
}

camo_intro_camo_ai()
{
	//turn camo off for beginning of the scene
	self toggle_camo_suit( true, false ); 
	
	//set on a notetrack in his animation
	flag_wait( "predator_ai_suit_on" );
	
	//turn the camo suit on
	self toggle_camo_suit( false );
}

camo_intro_threaded()
{
	level notify( "wingsuit_landing_done" );
	
	level thread predator_temp_vo();
	level thread run_scene( "camo_intro_player" );
	level thread run_scene( "camo_intro_enemy" );
	level thread run_scene( "camo_intro_squad" );
			
	scene_wait( "camo_intro_player" );
	flag_set( "predator_intro_scene_done" );
	
	level.player notify( "give_weapons" );
	level.player SetStance( "prone" );
	level.player AllowStand( false );
	level.player AllowCrouch( false );
	
	wait 0.5;
	
	level.player AllowStand( true );
	level.player AllowCrouch( true );
}

predator_temp_vo()
{
	wait 4;
	
	level.harper thread say_dialog( "Harper: Looks like they are prepping the base for the monsoon." );
	
	wait 4;
	
	level.player thread say_dialog( "Mason: We need to get into the lab, should be nested in the temple to the north." );
	
	wait 5;
	
	level.harper thread say_dialog( "Harper: What the hell, they have camo tech?" );
	
	wait 5;
	
	level.player thread say_dialog( "Mason: Shhh." );
}

ignore_squad( b_ignore )
{
	level.harper set_ignoreall( b_ignore );
	level.salazar set_ignoreall( b_ignore );
	level.crosby set_ignoreall( b_ignore );
	level.harper set_ignoreme( b_ignore );
	level.salazar set_ignoreme( b_ignore );
	level.crosby set_ignoreme( b_ignore );
}
	
/* ------------------------------------------------------------------------------------------
	Wingsuit functions
 ********************************************************************************************
-------------------------------------------------------------------------------------------*/
/* ---------------------------------------------------------------------------------
 * player wingsuit
 * Call On: the player
 * Mandatory: str_vehicle - wingsuit spawner targetname 
 * 			  str_node - vehicle path start node
 ---------------------------------------------------------------------------------*/
init_driveable_wingsuit() // self = player
{
	vh_wingsuit = spawn_vehicle_from_targetname( "vh_wingsuit_spawner", false );
	vh_wingsuit Hide();
	vh_wingsuit.origin = self.origin;
	vh_wingsuit.angles = self.angles;
	
	SetHeliHeightPatchEnabled( "player_wingsuit_height_lock", true );
	vh_wingsuit SetHeliHeightLock( true );
	vh_wingsuit UseVehicle( self, 0 );
		
	return vh_wingsuit;
}

/*----------------------------------------------------------------------------------
 * sets player wingsuit constant speed
 * Call On: player's wingsuit
 * Mandatory: str_endon - notify to end on
 * 			  n_speed - speed to maintain (MPH)
 ---------------------------------------------------------------------------------*/
set_driveable_wingsuit_speed( str_endon, n_speed ) // self = wingsuit
{
	level endon( str_endon );
	
	while( true )
	{
		v_forward = AnglesToForward( self.angles );
		n_push_speed = n_speed * MPH_TO_INCHES_PER_SEC; // MPH to inches per sec
		v_forward_vel = v_forward * n_push_speed;

		self SetVehVelocity( v_forward_vel );
		
		wait .05;
	}
}

/*----------------------------------------------------------------------------------------------
 * play flight anim loop
 * Call On: a guy
 * Mandatory: str_animtype = "slowdown_idle", "speedup_idle", "turnright_idle", "turnleft_idle"
 ---------------------------------------------------------------------------------------------*/
do_flight_anims( str_animtype ) // self = guy
{
	self run_scene( self.script_animname + "_" + str_animtype );
}

wingsuit_collision_check()
{
	while( !flag( "wingsuit_landing_started" ) )
	{
//		trace_start = self.origin + ( 0, 0, 50 );
//		vec = AnglesToForward( self.angles );
//		trace_end = trace_start + ( vec * 400 );
//		Line( trace_start, trace_end );
//		
//		results = BulletTrace( trace_start, trace_end, false, self, true );
//	
//		if( results["fraction"] != 1 )
//		{
//			screen_fade_out( 0 );
//			missionfailedwrapper();
//		}
		
		if( self GetSpeedMPH() < ( WINGSUIT_SPEED - 20 ) )
		{
			level.player DoDamage( 1000, level.player.origin );
			screen_fade_out( 0 );
			missionfailedwrapper();
		}

		wait 0.05;
	}
}

//self is the player
do_flight_feedback()
{
	level endon( "wingsuit_player_landed" );
	self endon( "death" );	
	
	while ( 1 )
	{
		self PlayRumbleOnEntity( "monsoon_gloves_impact" );
		Earthquake( 0.15, 0.1, self.origin, 1000, self );		
		wait 0.1;
	}
}