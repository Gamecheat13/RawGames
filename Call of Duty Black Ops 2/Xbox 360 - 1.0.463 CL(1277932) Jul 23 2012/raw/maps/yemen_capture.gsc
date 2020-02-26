#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\yemen_utility;
#include maps\_vehicle;
#include maps\_dialog;
#include maps\_music;
#include maps\_osprey;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "capture_started" );
	flag_init( "menendez_surrenders" );
	
	//Objective flags
	flag_init( "obj_capture_sitrep" );
	flag_init( "obj_capture_menendez" );
}

//	event-specific spawn functions
init_spawn_funcs()
{
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_capture()
{
	capture_skipto_setup();
	skipto_teleport( "skipto_capture_player" );
	switch_player_to_mason();
}

skipto_outro_vtol()
{
	load_gump( "yemen_gump_outro" );
	skipto_teleport( "skipto_capture_player" );
	switch_player_to_mason();	
	
	flag_set( "hijacked_bridge_fell" );
	level thread skipto_outro_vtol_play_anim();
}

skipto_outro_vtol_play_anim()
{
	while ( true )
	{
		while ( !level.player ActionSlotOneButtonPressed() )
		{
			wait 0.05;				
		}
		
		level thread run_scene( "surrender_menendez" );
		level thread run_scene( "surrender_menendez_player" );
		
		while ( level.player ActionSlotOneButtonPressed() )
		{
			wait 0.05;				
		}		
	}
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "Table for One" );
	#/
		flag_wait( "capture_started" );
	
		flag_set( "obj_capture_sitrep" );
		
//		level thread debug_get_player_position();
		capture_setup();
		level thread vo_capture();
		level thread menendez_vtol_turret_manager();
		level thread capture_carnage_animation_manager();
		capture_sitrep();
		player_phsych_thread();
		do_flashbacks();
		menendez_surrenders();
}

/* ------------------------------------------------------------------------------------------
	SETUP functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// setup for skipto
// this gets used for another skipto as well
capture_skipto_setup()
{
	flag_set( "hijacked_bridge_fell" );
	wait 1;
	flag_set( "capture_started" );
	flag_set( "spawn_menendez_vtol" );
	
	load_gump( "yemen_gump_outskirts" );
	level thread maps\yemen_hijacked::spawn_menendez_vtol();
	
	init_hero_startstruct( "sp_salazar", "skipto_capture_salazar" );
	
	level thread outskirts_fall_death();
	level thread maps\yemen_hijacked::hijacked_ambient_qrotors();
	level thread maps\yemen_hijacked::hijacked_bridge_swap();
}

 //setup event
capture_setup()
{
	autosave_by_name( "capture_start" );
	
	stop_exploder( 1040 );	// clean up ambient FX behind the player
	exploder( 1050 );		// start ambient FX for capture
	maps\createart\yemen_art::end_start();
	
	level thread maps\yemen_anim::capture_anims();
	
	level thread capture_music();
	level thread capture_trigger_ambient_vtols();
	level thread capture_spawn_fake_qrotors_at_structs_and_move( "s_capture_qrotors_intro", 2 );
	level thread capture_ambient_qrotors();
	capture_setup_animations();
	level thread capture_cleanup();
}

// setup fall death for bridge
outskirts_fall_death()
{
	level endon( "menendez_surrenders" );
	
	trigger_wait( "trig_outskirts_kill" );
	
	// occlude vision so player doesn't see too much of the world
	fadehud = capture_get_fade_hud( "white" );
	fadehud capture_fadeout( 1 );
	
	level thread maps\_utility::missionFailedWrapper( &"YEMEN_FALL_DEATH" );
}

// sets up looping animations for event
capture_setup_animations()
{
	level thread run_scene( "carnage_b_wounded_01_loop_setup" ); // give looping guy a gun once
	wait .05;
	capture_start_animation_loops( "a", 0, 4 ); // start loops 0-3 a ( 0 is sitrep guy loop )
	capture_start_animation_loops( "a", 5, 3 ); // start loops 5-7 a
	capture_start_animation_loops( "b", 1, 1 ); // start loop 1 b
	capture_start_animation_loops( "b", 3, 1 ); // start loop 3 b
	capture_start_animation_loops( "b", 5, 5 ); // start loops 5-9 b
}

/*---------------------------------------------------------------
 * Starts animation loops
 * Mandatory: character group (a, b), start index (0 - 9), count
 * Note: scenes are named like: carnage_a_wounded_01_loop
 * *************************************************************/
capture_start_animation_loops( char_group, n_start, n_count, b_has_gun )
{
	for( i = 0; i < n_count; i++ )
	{
		level thread run_scene( "carnage_" + char_group + "_wounded_0" + String( n_start + i) + "_loop" );
		
		wait .1; // space out spawning of models or ai
	}
}

/*-------------------------------------------------------------------------------
 * Runs a scene then loops its ending
 * Mandatory: scene name
 * Note: scene is named like: carnage_a_wounded_01 / carnage_a_wounded_01_loop
 * *****************************************************************************/
 capture_run_scene_then_loop( str_scene )
 {
 	run_scene( str_scene );
 	level thread run_scene( str_scene + "_loop" );
 }
 
 capture_cleanup()
 {
 	spawn_manager_kill( "hijacked_allied_spawnmanager_right" );
// 	spawn_manager_kill( "hijacked_allied_spawnmanager_bridge" );
 	
 	a_ai_allies = GetEntArray( "hijacked_ally", "script_noteworthy" );
	
	foreach( ai_guy in a_ai_allies )
	{
		ai_guy stop_magic_bullet_shield();
	}
	
	a_ai_allies = GetEntArray( "hijacked_ally_bridge", "script_noteworthy" );
	
	foreach( ai_guy in a_ai_allies )
	{
		ai_guy stop_magic_bullet_shield();
	}
 	 
 	a_ai_bridge_allies = GetEntArray( "hijacked_ally", "script_noteworthy" );
	maps\yemen_hijacked::kill_units( a_ai_bridge_allies );
	
	flag_wait( "player_approach_carnage" );
	
 	a_ai_bridge_allies = GetEntArray( "hijacked_ally_bridge", "script_noteworthy" );
	maps\yemen_hijacked::kill_units( a_ai_bridge_allies );
	
	level waittill( "first_flashback" );
	
	level thread cleanup_quads( "capture_quadrotor" );
	
	level waittill( "second_flashback" );
	
	delete_models_from_scene( "carnage_a_wounded_00_loop" );
	level thread cleanup_quads( "capture_quadrotor"  );
	
	level waittill( "third_flashback" );
	
	level thread cleanup_quads( "capture_quadrotor" );
	
	ai_salazar = GetEnt( "sp_salazar_ai", "targetname" );
	ai_salazar Delete();
	
	capture_delete_animation_loops();
 }
 
 cleanup_quads( str_noteworthy )
 {
 	a_vh_quads = GetEntArray( str_noteworthy, "script_noteworthy" );
	
	foreach( vh_quad in a_vh_quads )
	{
		VEHICLE_DELETE( vh_quad );
	}
 }
 
capture_delete_animation_loops()
{
	delete_models_from_scene( "carnage_a_wounded_01_loop" );
	delete_models_from_scene( "carnage_a_wounded_02_loop" );
	delete_models_from_scene( "carnage_a_wounded_03_loop" );
	delete_models_from_scene( "carnage_a_wounded_04_drag_loop" );
	delete_models_from_scene( "carnage_a_wounded_05_loop" );
	delete_models_from_scene( "carnage_a_wounded_06_loop" );
	delete_models_from_scene( "carnage_a_wounded_07_loop" );
	delete_models_from_scene( "carnage_a_wounded_07_run_loop" );
	delete_models_from_scene( "carnage_b_wounded_01_loop" );
	delete_models_from_scene( "carnage_b_wounded_02_drag_loop" );
	delete_models_from_scene( "carnage_b_wounded_03_loop" );
	delete_models_from_scene( "carnage_b_wounded_04_crawl_loop" );
	delete_models_from_scene( "carnage_b_wounded_05_loop" );
	delete_models_from_scene( "carnage_b_wounded_06_loop" );
	delete_models_from_scene( "carnage_b_wounded_07_loop" );
	delete_models_from_scene( "carnage_b_wounded_08_loop" );
	delete_models_from_scene( "carnage_b_wounded_09_loop" );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// First guy tells us about the situation
capture_sitrep()
{
	level waittill( "start_sit_rep" );
	
	level.player SetLowReady( true );
	level.player SetMoveSpeedScale( .5 );
	level thread quadrotors_flyby();
	
	flag_set( "obj_capture_menendez" );	// update breadcrumb
	
//	level thread run_scene( "soldier_sitrep" );
}

quadrotors_flyby()
{
	wait 1; // wait for animation to progress a bit
	maps\yemen_hijacked::spawn_quadrotor_formation( 8, "capture_sitrep_quad_spline", "capture_quadrotor" );
	
	level waittill( "first_flashback" );
	
	wait .1; // let other quadrotors clean up first
	maps\yemen_hijacked::spawn_quadrotor_formation( 8, "capture_sitrep_quad_spline", "capture_quadrotor" );
}

// Manages flow of carnage 
capture_carnage_animation_manager()
{
	level waittill( "player_approach_carnage" );
	
	level thread capture_run_scene_then_loop( "carnage_a_wounded_04_drag" );
	level thread capture_run_scene_then_loop( "carnage_a_sitrep_04_drag" );
	level thread capture_run_scene_then_loop( "carnage_b_wounded_04_crawl" );
	wait 1;
	level thread capture_run_scene_then_loop( "carnage_a_wounded_07_run" );
	
	level waittill( "second_flashback" );
	
	capture_run_scene_then_loop( "carnage_b_wounded_02_drag" );
}

// Manages vtol turret
menendez_vtol_turret_manager()
{
	level waittill( "capture_started" );
		
	s_target = GetStruct( "capture_steps_vtol_shoot_spot", "targetname" );
	vtol_turret_attacks_target( undefined, undefined, 3, s_target.origin );
	
	level waittill( "start_sit_rep" );
	
	s_target = GetStruct( "capture_knoll_vtol_shoot_spot", "targetname" );
	vtol_turret_attacks_target( undefined, undefined, 6, s_target.origin );
	
	level waittill( "first_flashback" );
}

/*--------------------------------------------------------------------
 * Shoots VTOL turret at target
 * Mandatory: ent target (default) OR vector target, time to fire for
 * Optional: delay before firing
 * ******************************************************************/
vtol_turret_attacks_target( e_target, n_delay, n_shoottime, v_target )
{	
	level endon( "stop_vtol_turret" );
	
	vh_vtol = GetEnt( "yemen_morals_rail_vtol_spawner", "targetname" );
	
	if( IsDefined( n_delay ) )
	{
		wait n_delay; // delay before firing
	}
	
	vh_vtol _set_vtol_turret_target( e_target, v_target );
	vh_vtol _shoot_vtol_turret( n_shoottime );
	
	level notify( "vtol_turret_done" );
}
/*------------------------------------------------------------
 * Sets VTOL's turret target
 * Self = VTOL
 * Mandatory: Ent target OR vector target
 * **********************************************************/
_set_vtol_turret_target( e_target, v_target )
{
	self ClearGunnerTarget( 0 );
	
	if( IsDefined( e_target ) )
	{
		self SetGunnerTargetEnt( e_target, ( 0, 0, 0 ), 0 );
	}
	else
	{
		self SetGunnerTargetVec( v_target, 0 );
	}
}

/*------------------------------------------------------------
 * Shoots VTOL turret
 * Self = VTOL
 * Mandatory: time to fire for
 * **********************************************************/
_shoot_vtol_turret( n_shoottime )
{
	n_time = 0;
	n_firecount = 1;
	n_firetime = WeaponFireTime( "v78_player_minigun_gunner" );
	
	while( n_time < n_shoottime )
	{
		self FireGunnerWeapon( 0 );
		n_firecount++;
		wait n_firetime;
		n_time += n_firetime;
	}
	
	self ClearGunnerTarget( 0 );
}

// manages flasbacks
do_flashbacks()
{
	level thread vo_flashback();
	
	s_first_spot = GetStruct( "first_flashback_spot", "targetname" );
	level.player waittill_radius( s_first_spot );
	
	s_second_spot = GetStruct( "second_flashback_spot", "targetname" );
	player_flashback( s_second_spot, "first_flashback" );
	
	level.player waittill_radius( s_second_spot );
	
	s_third_spot = GetStruct( "third_flashback_spot", "targetname" );
	player_flashback( s_third_spot, "second_flashback" );
	
	level.player waittill_radius( s_third_spot );
	
	a_capture_vtol = GetEntArray( "yemen_capture_vtol_spawner", "targetname" );
	array_delete( a_capture_vtol );
	
	load_gump( "yemen_gump_outro" );
	vh_vtol = GetEnt( "yemen_morals_rail_vtol_spawner", "targetname" );
	VEHICLE_DELETE( vh_vtol );
	
	player_flashback( undefined, "third_flashback", "surrender_menendez_player_setup" );
}

/*-----------------------------------------------------------------------
 * Waits until player is struct radius distance from struct
 * Self = player
 * Mandatory: struct, node, or ent ( needs a radius )
 * *********************************************************************/
waittill_radius( spot )
{
	while( true )
	{
		n_dist = Distance2D( level.player.origin, spot.origin );
		
		if( n_dist >= spot.radius )
		{
			break;
		}
		
		wait .05;
	}
}

/*-----------------------------------------------------------------------
 * Does flashback for player
 * Optional: struct, notify to send, scene to put in first frame
 * *********************************************************************/
player_flashback( s_spot, str_notify, str_scene )
{
	flashback = level thread play_movie_async( "rewind", true, true, undefined, false, "movie_done" );
	
	level.player FreezeControls( true );
	
	if( IsDefined( str_notify ) )
	{
		level notify( str_notify );
	}
	
	if( IsDefined( s_spot ) )
	{
		skipto_teleport( s_spot.targetname );
	}
	else
	{
		wait .05; // HACK: wait a frame after teleport to avoid any strangeness with scene that follows
		level thread run_scene_first_frame( str_scene );
	}
	
	level.player playsound ("evt_time_rev_1");
	
	wait RandomFloatRange( .75, 1.02 );
	
	Stop3DCinematic( flashback );
	level.player FreezeControls( false );
}

// mess with player's mind
player_phsych_thread()
{
	level.player hide_hud();
	level thread capture_heartbeat_rumble();
}

//Menendez captured
menendez_surrenders()
{
	const FADEOUT = 2;
	
	flag_set("menendez_surrenders");
	
	maps\createart\yemen_art::end_menendez();
	
	level.player notify( "mission_finished" );
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "delete" );
	
	run_scene_first_frame( "surrender_menendez" );
	run_scene_first_frame( "surrender_menendez_player" );
	level thread run_scene( "surrender_menendez" );
	
	ready_weapon();
	
	run_scene( "surrender_menendez_player" );
	level thread run_scene( "surrender_menendez_idle" );
	
	fadehud = capture_get_fade_hud( "black" );
	fadehud capture_fadeout( FADEOUT );
	
	NextMission();
}

ready_weapon()
{
	level.player ShowViewModel();
	level.player EnableWeapons();
	level.player DisableWeaponFire();
	level.player SetLowReady( true );
}

/* ------------------------------------------------------------------------------------------
	NOTETRACK functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// give scene model a gun
// m_guy = model
give_me_a_gun( m_guy )
 {
	m_guy attach( "t6_wpn_ar_xm8_world", "tag_weapon_right" );
 }
 
// turret shoots running guy
// e_target = model or guy
turret_attacks_runner( e_target )
{
	vtol_turret_attacks_target( e_target, 3, 3 );
}

/* ------------------------------------------------------------------------------------------
	CUSTOM SIGHT FX
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// returns a hud element
capture_get_fade_hud( str_shader )
{
	fadehud = NewHudElem(); 
	fadehud.x = 0; 
	fadehud.y = 0; 
	fadehud.horzAlign = "fullscreen"; 
	fadehud.vertAlign = "fullscreen"; 
	fadehud.foreground = false;
	fadehud SetShader( str_shader, 640, 480 );

	return fadehud;
}
	
capture_fadeout_and_in( n_alpha, n_fade ) // self = hud element
{
	self.alpha = 0;
	self FadeOverTime( n_fade );
	self.alpha = n_alpha; 
	self FadeOverTime( n_fade );
	self.alpha = 0;
	
	self Destroy();
}

capture_fadeout( n_fade ) // self = hud element
{
	self.alpha = 0;
	self FadeOverTime( n_fade );
	self.alpha = 1; 
}

/* ------------------------------------------------------------------------------------------
	RUMBLE
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// heartbeat gets more intense when facing sniper
capture_heartbeat_rumble()
{	
	level endon( "menendez_surrenders" );
	
	s_sniper_spot = GetStruct( "s_mendendez_spot", "targetname" );
	
	while( true )
	{
		n_dot = capture_get_vector_dot( s_sniper_spot.origin );
		
		if( n_dot < .5 )
		{
			level.player rumble_loop( 1, .25, "heartbeat" ); // intense heartbeat
			
			fadehud = capture_get_fade_hud( "white" );
			fadehud thread capture_fadeout_and_in( .5, .5 );
			
			wait 1.4;
		}
		
		else
		{
			level.player rumble_loop( 1, .25, "heartbeat_low" ); // mild heartbeat
			wait 2;
		}
	}
}

//return 2d dot - player against facing position
capture_get_vector_dot( v_pos )
{
	n_dot = level.player get_dot_direction( v_pos, true, true, "backward", true ); // want look away to be positive
	
	return n_dot; // -1 = looking at, 1 = looking away
}

/* ------------------------------------------------------------------------------------------
	AMBIENT
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//trigger vtol spawn
capture_trigger_ambient_vtols()
{
	a_run_triggers = GetEntArray( "trigs_capture_vtols_spawn", "targetname" );
	array_thread( a_run_triggers, ::capture_trigger_ambient_vtols_think );
}

//self = trigger
capture_trigger_ambient_vtols_think()
{
	self trigger_wait();
	
	spawn_vtols_at_structs( self.script_noteworthy, self.script_string );
}

// ambient quadrotors
capture_ambient_qrotors()
{
	while( true )
	{
		capture_spawn_fake_qrotors_at_structs_and_move( "s_capture_qrotors_middle", RandomIntRange( 3, 4 ) );
		
	    wait RandomIntRange( 2, 4 );
	}
}

//spawn script model quadrotors
capture_spawn_fake_qrotors_at_structs_and_move( str_drone_pos, n_move_time )
{
	a_drone_pos = GetStructArray( str_drone_pos, "targetname" );
	
	foreach( s_drone_pos in a_drone_pos )
	{
		m_drone = Spawn( "script_model", s_drone_pos.origin );
		
		m_drone SetModel( "veh_t6_drone_quad_rotor_sp" );
		
		s_drone_target = GetStruct( s_drone_pos.target, "targetname" );
		
		m_drone MoveTo( s_drone_target.origin, n_move_time );
		
		m_drone waittill ("movedone");
		
		m_drone Delete();
	}
}

/* ------------------------------------------------------------------------------------------
	DEBUG
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// Helps align teleport spots to predetermined points
debug_get_player_position()
{
	while( 1 )
	{
		v_player_pos = level.player.origin;
		v_player_angles = level.player.angles;
		v_player_angles2 = level.player GetPlayerAngles();
		v_player_eye = level.player GetEye();
		wait .05;
	}
}

/* ------------------------------------------------------------------------------------------
	VO functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

vo_capture()
{
	level.player say_dialog( "sala_section_he_ll_kill_0" );		// Section, he’ll kill you where you stand!
//	level.player say_dialog( "sect_no_he_won_t_0" );			// No he won't.
	level.player say_dialog( "sala_all_units_confirm_ho_0" );	// All units confirm hold fire, we are approaching command VTOL.
}
	
vo_sitrep()
{
	level notify( "stop_vtol_turret" ); // Khaaaaaaaaaaaaan
}

vo_flashback()
{
	level waittill( "first_flashback" );
	
	level.player say_dialog( "mene_you_david_you_do_0" );		//You, David. You do not get to choose.
	
	level waittill( "second_flashback" );
	
	level.player say_dialog( "mene_like_woods_you_suff_0" );	//Like Woods, you suffer with me.
	
	level waittill( "third_flashback" );
}

/* ------------------------------------------------------------------------------------------
	Music functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

capture_music()
{
	// level waittill( "something" );
	
	//Music starts at base of steps
	setmusicstate ("YEMEN_SNIPER");
	
	level waittill( "menendez_surrenders" );
	
	// Fade out temp music.
	setmusicstate ("YEMEN_SNIPER_END");
}

/* ------------------------------------------------------------------------------------------
	Challenges
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// capture menendez in x seconds
fearless_challenge( str_notify )
{
	level endon( "capture_not_fearless" );
	
	flag_wait( "capture_started" );
	n_fearless_start = GetTime();
	
	flag_wait( "menendez_surrenders" );
	
	if( GetTime() < n_fearless_start + 25000 )	// less than 25 seconds
	{
		self notify( str_notify );
	}
}