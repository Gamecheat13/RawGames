#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\monsoon_util;
#include maps\_scene;
#include maps\_anim;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

// intro goggles
#define GOGGLES_FOV 30
#define GOGGLES_ZOOM_LERP .05
	
/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

skipto_intro()
{
	skipto_teleport_players( "player_skipto_intro" );
}

skipto_harper_reveal()
{
	skipto_teleport_players( "player_skipto_intro" );
}

skipto_rock_swing()
{
	skipto_teleport_players( "wingsuit_start_spot" );
}

skipto_suit_jump()
{
	level thread run_scene( "squirrel_intro_idle" );
		
	skipto_teleport_players( "wingsuit_start_spot" );
}


/* ------------------------------------------------------------------------------------------
	FLAGS
-------------------------------------------------------------------------------------------*/

init_intro_flags()
{
	flag_init( "goggles_started" );
	flag_init( "intro_lift_down" );
	flag_init( "intro_start_ambient_activity" );
	flag_init( "goggles_done" );
	flag_init( "vertigo_started" );
	flag_init( "player_equipped_suit" );
	flag_init( "squad_equipped_suits" );
	flag_init( "leap_of_faith_started" );
}

/* ------------------------------------------------------------------------------------------
	MAIN
-------------------------------------------------------------------------------------------*/

main()
{
	eagle_eye_setup();
	
	switch( level.skipto_point )
	{
		case "intro":
			eagle_eye_far_flung();
		case "harper_reveal":
			eagle_eye_vertigo();	
			eagle_eye_surface_link();
		case "rock_swing":
			eagle_eye_swing();
			eagle_eye_rough_landing();
		case "suit_jump":
			eagle_eye_leap_of_faith();
	}
}


/* ------------------------------------------------------------------------------------------
	Setup functions
-------------------------------------------------------------------------------------------*/

eagle_eye_setup()
{                         
	level.player thread take_and_giveback_weapons( "give_weapons" );
	set_rain_level( 5 );
	level.weather_wind_shake = false;
	
	exploder( 33 );  // spawn global cloud base
	
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
}

patroller_spawnfunc() // self = guy
{
	self set_ignoreme( true );
	self set_ignoreall( true );
	
	self play_fx( "enemy_marker", undefined, undefined, "marked", true, "J_SpineLower" );
	
	flag_wait( "goggles_started" );
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "autospot" )
	{
		self thread auto_spot_think();
	}
	else
	{
		self thread spot_think();
	}
}

//starts by autofollowing a guy
#define LOCK_TIME 7
#define SPOT_TIME 20
auto_spot_think()
{
	level.player FreezeControls( true );
	level.player FreezeControlsAllowLook( true );
	
	level.player delay_thread( 3.0, ::goggles_zoom, true );
	level.player delay_thread( 6.0, ::goggles_zoom, false );
	
	n_start_time = GetTime();
	while( GetTime() < n_start_time + 7000 ) // less than 7 sec
	{
		level.player look_at(self, 0, true, "tag_eye" ); // make player look at
		wait 0.05;
	}
	
	level.player FreezeControls( false );
	level.player FreezeControlsAllowLook( false );
			
	spot_guy();
	
	flag_set( "intro_start_ambient_activity" );
	
	// timer for spotting mechanic
	wait SPOT_TIME; 
	
	flag_set( "goggles_done" );
}

// self = ai
spot_think() 
{
	// accuracy of look
	const DOT = .999; 
	
	while( !flag( "goggles_done" ) ) 
	{		
		n_dot = get_3d_dot( self.origin ); // -1 = look away, 1 = looking at

		if( level.player attack_button_held() ) // pull trigger to spot
		{
			if( n_dot > DOT )
			{
				spot_guy();
				return;
			}
		}	
		wait 0.05;
	}
}

// self = ai
spot_guy() 
{
	// "CHIME" marked sound
	level notify( "guy_spotted" );
	
	level.n_intro_spotted++;
		
	//notify to turn off previous fx
	self notify( "marked" );
	self play_fx( "enemy_marker_spotted", undefined, undefined, "marked", true, "J_SpineLower" );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

eagle_eye_far_flung()
{
	//TODO Remove this once it's set on a notetrack
	delay_thread( 30, ::flag_set, "show_introscreen_title" );
	
	level.n_intro_spotted = 0;
	a_patrollers = simple_spawn( "lz_patroller", ::patroller_spawnfunc );
	
	level thread eagle_eye_vo();
	
	setup_goggles();
	level.player AllowCrouch( false );
	level.player hide_hud();
	level.player turn_on_goggles_vision(); //shabs - disabling this for lighting.
	//level thread do_goggles_hints();
	intro_start_ambient_activity();
	level.player thread goggles_controls();
	
	flag_set( "goggles_started" );
	
	flag_wait( "goggles_done" );
	
	level.player notify( "stop_input_detection" );
	screen_message_delete();
	level.player zoom_out_to_cliff();
	screen_fade_out( .5 );
	level.player turn_off_goggles_vision();
	screen_fade_in( .5 );
	level.player AllowCrouch( true );
	
	//turn the glasses back on from the EMP
	maps\_glasses::play_bootup();
	level.player delay_thread( 1.0, ::show_hud );
	
	array_delete( a_patrollers );
	a_sp_patrollers = GetEntArray( "lz_patroller", "targetname" );
	array_delete( a_sp_patrollers );
}

eagle_eye_vo()
{
	wait 4;
	level.harper say_dialog( "harp_what_s_the_story_se_0" );
	wait 1;
	level.player say_dialog( "sect_base_is_2_clicks_sou_0" );
	wait 2;
	level.player say_dialog( "sect_less_than_ten_guards_0" );
	wait 1;
	level.harper say_dialog( "harp_no_sharpened_sticks_0" );
	wait 1.5;
	level.player say_dialog( "sect_unfortunately_not_0" );
	wait 1;
	level.harper say_dialog( "harp_then_let_s_go_un_eq_0" );
}

eagle_eye_vertigo()
{
	flag_set( "vertigo_started" );
		
	o_player_start = GetEnt( "intro_far_flung_player_spot_org", "targetname" );
	a_m_fx_models = GetEntArray( "enemy_marker_model", "targetname" );
	
	o_player_start Delete();
	array_delete( a_m_fx_models );
}

eagle_eye_surface_link()
{
	level thread surface_link_vision(); 
	run_scene( "cliff_intro" ); 
}

eagle_eye_swing()
{
	autosave_by_name( "cliff_intro_done" );
	
	cliff_swing( &"MONSOON_PROMPT_HARPER_FALL", "reload_button", "cliff_swing_1_idle", "cliff_swing_1", "input_lstick_detected" );
	cliff_swing( &"MONSOON_PROMPT_PLAYER_FALL", "jump_button", "cliff_swing_2_idle", "cliff_swing_2", "input_trigs_detected" );
	cliff_swing( &"MONSOON_PROMPT_HARPER_FALL", "reload_button", "cliff_swing_3_idle", "cliff_swing_3", "input_lstick_detected" );
	
	autosave_by_name( "first_set_of_swings_done" );
	
	cliff_swing( &"MONSOON_PROMPT_PLAYER_FALL", "jump_button", "cliff_swing_4_idle", "cliff_swing_4", "input_trigs_detected" );
	cliff_swing( &"MONSOON_PROMPT_HARPER_FALL", "reload_button", "cliff_swing_5_idle", "cliff_swing_5", "input_lstick_detected" );
	
	level.salazar = init_hero( "salazar" );
	
	// this one is a special case so cliff_swing can't handle it 
	level.player thread cliff_swing_6_rumble();
	cliff_swing( &"MONSOON_PROMPT_PLAYER_FALL", "jump_button", "cliff_swing_6_idle", "cliff_swing_6", "input_lstick_detected", "cliff_swing_6_player" );
	
	autosave_by_name( "all_swings_done" );
}

eagle_eye_rough_landing()
{
	//squad has their suit equipped now
	flag_set( "squad_equipped_suits" );
	
	//place the squad in their ready idles
	level thread run_scene( "squirrel_intro_idle" );
	
	autosave_by_name( "ready_for_takeoff" );
}

eagle_eye_leap_of_faith()
{
	flag_wait_all( "player_equipped_suit", "squad_equipped_suits" );
	
	//remove player clip for the cliff sides
	array_delete( GetEntArray( "wingsuit_launch_blocker", "targetname" ) );
	level.player thread jump_fail_check();
	
	//set objective marker to be the jump point
	flag_set( "jet_stream_launch_obj" );
	
	//wait for the jump animation trigger to get hit
	flag_wait( "leap_of_faith_started" );
	
	//remove the objective marker
	flag_set( "jet_stream_launch_obj_complete" );
	
	//end the loops for the AI
	end_scene( "squirrel_intro_idle" );
}

//self is the player
player_equip_suit()
{
	flag_wait( "cliff_swing_6_player_done" );
	
	wait 5;
	
	level.weather_wind_shake = true;
	
	//waits for the player to push both triggers
	self waittill_input( &"MONSOON_PROMPT_WINGS", "ltrig_rtrig" );
	
	//spawn the align node for the animation at the player's origin and angles
	anchor = Spawn( "script_origin", self.origin );
	anchor.angles = self.angles ;
	anchor.targetname = "equip_suit";
	
	flag_set( "player_equipped_suit" );
	
	//animation of player equipping his suit
	run_scene( "player_equip_suit" );
	
	//removed spawned align node
	anchor Delete();
}

//self is the player
jump_fail_check()
{
	level endon( "leap_of_faith_started" );
	
	e_volume = GetEnt( "wingsuit_leap_fail_volume", "targetname" );
	            
	while( 1 )
	{
		if( self IsTouching( e_volume ) )
		{
			missionfailedwrapper( &"MONSOON_FLIGHT_PATH" );
			return;
		}
		wait 0.05;
	}
}

/* ------------------------------------------------------------------------------------------
	Goggles Functions
-------------------------------------------------------------------------------------------*/

do_goggles_hints()
{
	level endon( "goggles_done" );
	
	level waittill( "goggles_started" );
	
	level.player waittill_input( &"MONSOON_PROMPT_GOGGLES_ZOOM", "ads_button" );
	
	flag_wait( "intro_start_ambient_activity" );
	
	level.player waittill_input( &"MONSOON_PROMPT_GOGGLES_SCAN", "attack_button" );
}

// sets up goggles
setup_goggles()
{
	const LEFT_RIGHT_ARC = 20;
	const UP_ARC = 50;
	const DOWN_ARC = 0;
	const WAIT_TIME = 10;
	
	level.str_default_vision = level.player GetVisionSetNaked();	
	o_player_start = GetEnt( "intro_far_flung_player_spot_org", "targetname" );
	level.player.angles = o_player_start.angles;
	level.player.origin = o_player_start.origin;
	
	level.player PlayerLinkToDelta( o_player_start, undefined, 1, LEFT_RIGHT_ARC, LEFT_RIGHT_ARC, UP_ARC, DOWN_ARC );
}

turn_on_goggles_vision() // self = player
{
	level ClientNotify( "binoc_on" );
	level.str_prev_vision = self GetVisionSetNaked();
	//self VisionSetNaked( "claw_base", 0 );
}

turn_off_goggles_vision() // self = player
{
	level ClientNotify( "binoc_off" );
	//self VisionSetNaked( level.str_prev_vision, 0 );
	level.str_prev_vision = undefined;
}


// controls while in goggles, spotting handled seperately
goggles_controls() // self = player
{
	level endon( "goggles_done" );
	
	self lerp_fov_overtime( GOGGLES_ZOOM_LERP, GOGGLES_FOV ); // set fov to goggles
	
	while( true )
	{		
		if( self ads_button_held() )
		{
			self goggles_zoom( true );

			while( self ads_button_held() )
			{
				wait .05;
			}
			
			self goggles_zoom( false );
		}	
		wait .05;
	}
}

// zoom goggles, default = true
goggles_zoom( b_zoom ) // self = player
{
	if( b_zoom == false )
	{
		// "CLICK" zoom out sound
		self set_zoom( 10, .1, GOGGLES_ZOOM_LERP, GOGGLES_FOV );
	}
	else
	{
		// "CLICK" zoom in sound
		self set_zoom( 10, .1, GOGGLES_ZOOM_LERP, 21 );
	}
}

set_zoom( n_fade_blur, n_blur_time, n_lerp, n_fov ) // self = player
{
	self StartFadingBlur( n_fade_blur, n_blur_time );
//	TODO: find out why setting dof always asserts even when values are correct, no time left for blockout
//	self maps\monsoon_wingsuit::lerp_vision( n_lerp, n_fov, n_near_start, n_far_start, n_near_end, n_far_end, n_near_blur, n_far_blur );
	self thread lerp_fov_overtime( n_lerp, n_fov );
}

// TODO: get notetracks for this
zoom_out_to_cliff() // self = player
{
	self set_zoom( 10, .1, GOGGLES_ZOOM_LERP, 55 );
	wait 3;
	self thread set_zoom( 10, .5, GOGGLES_ZOOM_LERP, 65 );
	run_scene_first_frame( "cliff_intro" );
	wait 2;
}

intro_start_ambient_activity()
{
	level thread ambient_heli();
	level thread lift_control();
}
	
ambient_heli()
{
	level waittill( "intro_start_ambient_activity" );
	
	s_goal = GetStruct( "intro_heli_pos_helipad", "targetname" );
	s_goal_2 = GetStruct( "intro_heli_pos_helipad_land", "targetname" );
	
	vh_heli = maps\_vehicle::spawn_vehicle_from_targetname( "heli_goggles_intro", false );
	
	vh_heli veh_toggle_tread_fx( 0 );
	vh_heli SetSpeed( 10 );
	vh_heli thread maps\monsoon_heli::heli_adjust_pitch_down( 0, 20 );
	
	vh_heli SetVehGoalPos( s_goal.origin );	
	
	flag_wait( "vertigo_started" );
	vh_heli Delete();
}

lift_control()
{
	level waittill( "intro_start_ambient_activity" );
	
	outside_lift_move_down();
	wait 10;
	outside_lift_move_up();
}

get_3d_dot( v_pos )
{
	n_dot = level.player get_dot_direction( v_pos, false, true, "forward", true ); 
	
	return n_dot;
}


/* ------------------------------------------------------------------------------------------
	Vertigo functions
-------------------------------------------------------------------------------------------*/

#define VERT_FAST_FOV 66
#define VERT_NEAR_START 1
#define VERT_NEAR_END 512
#define VERT_FAR_START 4000
#define VERT_FAR_END 10000
#define VERT_NEAR_BLUR 4
#define VERT_FAR_BLUR 0
#define HARPER_LERP_TIME .05
surface_link_vision() // TODO: If this is good then make a system for it
{
	wait 5; // HACK: until I get a notetrack
	level.player thread lerp_vision( 4, VERT_FAST_FOV, VERT_NEAR_START, VERT_NEAR_END, VERT_FAR_START, VERT_FAR_END, VERT_NEAR_BLUR, VERT_FAR_BLUR );
	wait 1;
	level.player thread lerp_vision( HARPER_LERP_TIME );

	wait HARPER_LERP_TIME;
}


/* ------------------------------------------------------------------------------------------
	NOTETRACK functions
-------------------------------------------------------------------------------------------*/

// dramatically introduce harper
cliff_intro_harper_intro( guy )
{
	//triggers cloud lightning
	exploder( 88 );
}

// player swing harper
cliff_swing_success_window_assist_start( guy )
{
	level.player thread player_camera_shake_loop( 0.15, .5, level.player.origin, 1000 );
	cliff_swing_success_window( .5, .2, "monsoon_gloves_impact", &"MONSOON_PROMPT_SWING", "lstick", "left" );
}

// harper swing player
cliff_swing_success_window_grab_start( guy )
{
	level.player thread player_camera_shake_loop( 0.25, .5, level.player.origin, 1000 );
	cliff_swing_success_window( .5, .2, "monsoon_gloves_impact", &"MONSOON_PROMPT_GLOVES_ON", "ltrig_rtrig" );
}

// final swing landing
cliff_swing_6_landing( guy )
{
//	level.player thread player_camera_shake_loop( 0.25, .5, level.player.origin, 1000 );
}

// player swing
cliff_swing_flying_rumble( guy )
{
	level.player PlayRumbleOnEntity( "monsoon_player_swing" );
}

cliff_swing_6_flying_rumble( guy )
{
	level.player PlayRumbleOnEntity( "monsoon_gloves_impact" );
	wait 5;
	level.player StopRumble( "monsoon_gloves_impact" );
}

// harper swing
cliff_swing_assist_rumble( guy )
{
	level.player PlayRumbleOnEntity( "monsoon_harper_swing" );
}

nanoglove_impact( guy )
{
	level.player PlayRumbleOnEntity( "monsoon_gloves_impact" );
	
	// play fx on both hands
	guy thread play_fx( "nanoglove_impact", level.player.origin, level.player.angles, 1, true, "j_index_le_1" );
	guy play_fx( "nanoglove_impact", level.player.origin, level.player.angles, 1, true, "j_index_ri_1" );
}

single_rumble( guy )
{
	level.player PlayRumbleOnEntity( "monsoon_gloves_impact" );
}

cliff_swing_harper_1_fail( player )
{
	cliff_swing_fail( "input_lstick_detected", "cliff_swing_1_fail" );
}

cliff_swing_player_1_fail( player )
{
	cliff_swing_fail( "input_trigs_detected", "cliff_swing_2_fail" );
}

cliff_swing_harper_2_fail( player )
{
	cliff_swing_fail( "input_lstick_detected", "cliff_swing_3_fail" );
}

cliff_swing_player_2_fail( player )
{
	cliff_swing_fail( "input_trigs_detected", "cliff_swing_4_fail" );
}

cliff_swing_harper_3_fail( player )
{
	cliff_swing_fail( "input_lstick_detected", "cliff_swing_5_fail" );
}

#define N_FAIL_DELAY 0.75
cliff_swing_fail( str_flag, str_scene )
{
	level notify( "swing_done" );
	level.player StopRumble( "monsoon_player_swing" );
	level.player PlayRumbleOnEntity( "monsoon_gloves_impact" );
	
	if( !flag( str_flag ) )
	{
		if( str_flag == "input_lstick_detected" )
		{
			delay_thread( N_FAIL_DELAY, ::missionfailedwrapper, &"MONSOON_FAIL_HARPER_SWING" );
		}
		else if( str_flag == "input_trigs_detected" )
		{
			delay_thread( N_FAIL_DELAY, ::missionfailedwrapper, &"MONSOON_FAIL_PLAYER_SWING" );
		}
		
		//animate the failed scene
		run_scene( str_scene );
	}
}

player_camera_shake_loop( n_intensity, n_time, v_org, n_radius ) // self = player
{
	level endon( "swing_done" );
	level endon( "fail_done" );
	
	while( 1 )
	{
		Earthquake( n_intensity, n_time, v_org, n_radius, self );
		wait .05;
	}
}

// HACK: until i get more notetracks
cliff_swing_6_rumble()
{
	wait GetAnimLength( %player::p_mon_01_01_cliffswing6_player ) - 3;
	
	level notify( "cliff_swing_6_done" );
}


/* ------------------------------------------------------------------------------------------
	Challenges
-------------------------------------------------------------------------------------------*/

challenge_spotguys( str_notify )
{
	flag_wait( "goggles_done" );
		
	a_patrollers = GetEntArray( "lz_patroller" + "_ai", "targetname" );
	
	if( level.n_intro_spotted >= a_patrollers.size )
	{
		self notify( str_notify );
	}			
}

/* ------------------------------------------------------------------------------------------
	Utility functions
-------------------------------------------------------------------------------------------*/

cliff_swing( str_prompt, str_button, str_idle_anim, str_swing_anim, str_flag, str_swing_anim_thread )
{
	scene_idle_waittill_input( str_prompt, str_button, str_idle_anim );
	
	if( IsDefined( str_swing_anim_thread ) )
	{
		level thread cliff_vo();
		level thread run_scene( str_swing_anim_thread ); // if we need to thread another scene with the main scene
		level.player thread player_equip_suit();
	}

	run_scene( str_swing_anim );
	flag_clear( str_flag );
}

cliff_vo()
{
	wait 4;
	level.salazar say_dialog( "sala_you_establish_an_lz_0" );
	wait 1;
	level.harper say_dialog( "harp_wide_open_little_m_0" );
	wait 0.5;
	level.harper say_dialog( "harp_maybe_this_menendez_0" );
	wait 1;
	level.salazar say_dialog( "sala_it_would_be_unwise_t_0" );
	wait 1;
	level.crosby say_dialog( "cros_about_that_what_do_0" );
	wait 1.2;
	level.harper say_dialog( "harp_it_s_latin_day_of_0" );
	wait 0.8;
	level.player say_dialog( "sect_although_what_it_mea_0" );
	wait 0.4;
	
	flag_wait( "player_equipped_suit" );
	
	level.player say_dialog( "sect_alright_everyone_r_0" );
	wait 1;
	level.harper say_dialog( "harp_ladies_first_0" );
}

// play idle wait for input
scene_idle_waittill_input( str_prompt, str_button, str_scenename )
{	
	level thread run_scene( str_scenename );
	level.player waittill_input( str_prompt, str_button );
}

set_time_scale_for_time( n_scale, n_time )
{
	SetTimeScale( n_scale );
	wait n_time;
	SetTimeScale( 1 );
}

/* -------------------------------------------------------------
 * do success window actions
 * Mandatory: time scale, timer, rumble, prompt, button press
 * Optional: direction (if stick is button press)
--------------------------------------------------------------*/
cliff_swing_success_window( n_time_scale, n_scale_timer, str_rumble, str_prompt, str_button, str_direction )
{
	level thread set_time_scale_for_time( n_time_scale, n_scale_timer );
	level.player PlayRumbleOnEntity( str_rumble );
	level.player waittill_input( str_prompt, str_button, str_direction );
	level.player PlayRumbleOnEntity( str_rumble );
}