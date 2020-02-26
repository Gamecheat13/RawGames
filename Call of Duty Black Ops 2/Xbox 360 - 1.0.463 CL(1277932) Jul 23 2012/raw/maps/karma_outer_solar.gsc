
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\karma_util;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#define REFLECTION_WIDTH 32
#define REFLECTION_HEIGHT 18


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/

//
//	Declare event-specific flags here

init_flags()
{
	flag_init( "player_at_club" );
	flag_init( "harper_pip_done" );
	flag_init( "kill_solar_lounge" );
	flag_init( "kill_outer_solar" );	
	flag_init( "club_door_closed" );
}

//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//    	add_spawn_function_group( "tarmac_workers", "targetname", ::add_cleanup_ent, "checkin" );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_outer_solar()
{
	level.ai_salazar = init_hero( "salazar" );

	skipto_teleport( "skipto_outer_solar", array(level.ai_salazar) );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions

-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "outer_solar" );
	#/
		
	level.n_aggressivecullradius = GetDvar( "Cg_aggressivecullradius" );
	SetSavedDvar( "Cg_aggressivecullradius", 50 );

	// Change the skybox to the alternate one
	SetSavedDvar( "r_skyTransition", 1 );
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_entertainmentdeck01" );

	maps\karma_anim::club_anims();

	level.ai_harper		= init_hero( "harper", maps\karma_inner_solar::harper_think );
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		level.ai_harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	}
	
	level.ai_karma		= simple_spawn_single( "karma",   ::club_actor_think );
	level.ai_karma setforcenocull();	// don't let her disappear

	level thread start_civs_outer_solar( "kill_outer_solar" );

	level thread outer_solar_objectives();

	level.ai_salazar thread salazar_think();

	level outer_solar_fx();
	wait( 1.0 );	// spacing out for performance
	level thread populate_club();
	level thread club_fx();
	level thread harper_finds_karma_pip();
	
	// Limit player movement
	flag_set( "player_among_civilians" );

	//TUEY -  SEt music to OUTER SOLAR
	setmusicstate("KARMA_1_OUTER_SOLAR");
	
	trigger_wait( "t_club_entrance" );
	
	clientnotify( "scle" );
	
	level thread start_civs_lounge( "kill_solar_lounge" );
	
	flag_set( "player_at_club" );
	
//	level thread run_scene_and_delete( "scene_enter_bouncer_door" );
	level thread run_scene_and_delete( "bouncer_lounge_door_idle" );

	trigger_wait( "t_enter_club" );

//	level.player thread enter_club_dialog();

	level thread enter_bar_animations( "club_door_closed" );	// "kill_solar_lounge"

	trigger_wait( "t_lounge_door" );

	level thread outer_door();
	
	level thread lounge_door();

	level thread outer_solar_cleanup();
}

outer_solar_objectives()
{
	self thread objective_breadcrumb( level.OBJ_MEET_KARMA, "t_outer_solar" );
	
	trigger_wait( "t_lounge_door_close" );
}


//
//	Harper radios in
harper_finds_karma_pip()
{
	SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );

	// Turn on dance floor spotlights for the scene
	a_e_lights = GetEntArray( "speechlight", "targetname" );
	// set these lights to nocull so that it doesn't get removed by aggressivecull
	foreach( e_light in a_e_lights )
	{
		e_light setforcenocull();
		e_light SetLightIntensity( 30 );
	}

	level.player show_hud();

	thread run_scene_and_delete( "harper_finds_karma" );
	wait( 0.1 );

	// Nocull the actors
	a_m_actors = get_model_or_models_from_scene( "harper_finds_karma" );
	foreach( m_actor in a_m_actors )
	{
		m_actor setforcenocull();
	}	
	
	// Put the scene on Harper
	m_harper = get_model_or_models_from_scene( "harper_finds_karma", "harper_body" );
	level.e_extra_cam.origin = m_harper GetTagOrigin( "TAG_CAMERA" );
	level.e_extra_cam.angles = m_harper GetTagAngles( "TAG_CAMERA" );
	level.e_extra_cam LinkTo( m_harper, "TAG_CAMERA" );
	
	turn_on_extra_cam();
	scene_wait( "harper_finds_karma" );
	
	turn_off_extra_cam();
	flag_set( "harper_pip_done" );

	level thread harper_and_karma_loop();

	array_thread( a_e_lights, ::lerp_intensity, 0, 1.0 );
}


//
// 
enter_bar_animations( str_cleanup_flag )
{
	level thread walk_to_loop_anim( "outer_solar_enter_bar_a", "outer_solar_enter_bar_a_loop", str_cleanup_flag );
	level thread walk_to_loop_anim( "outer_solar_enter_bar_b", "outer_solar_enter_bar_b_loop", str_cleanup_flag );
	level thread walk_to_loop_anim( "outer_solar_enter_bar_c", "outer_solar_enter_bar_c_loop", str_cleanup_flag );
	level thread walk_to_loop_anim( "outer_solar_enter_bar_d", "outer_solar_enter_bar_d_loop", str_cleanup_flag );
	level thread walk_to_loop_anim( "outer_solar_enter_bar_e", "outer_solar_enter_bar_e_loop", str_cleanup_flag );
}

walk_to_loop_anim( str_scene_walk, str_scene_loop, str_cleanup_flag )
{
	// We may want to exit the area before the loop starts
	str_done = str_scene_walk + "_done";

	level thread run_scene_and_delete( str_scene_walk );
	while( 1 )
	{
		// Move on to the looping part
		if( flag(str_done) )
		{
			break;
		}

		// Finished with the whole animation pair?
		if( flag(str_cleanup_flag) )
		{
			//IPrintLnBold( "ENTER BAR CLEANUP" );
			end_scene( str_scene_walk );
			return;
		}
		wait( 0.01 );
	}

	level thread run_scene_and_delete( str_scene_loop );
	while( 1 )
	{
		if( flag(str_cleanup_flag) )
		{
			//IPrintLnBold( "ENTER BAR CLEANUP" );
			end_scene( str_scene_loop );
			return;
		}
		wait( 0.01 );
	}
}


//
//	
outer_solar_fx()
{
	// Spinning Solar System
	thread globe_activate( "sun_globe", 	30, 	-1, "kill_solar_lounge", "outer_solar","club_sun_small", "tag_origin" );
	thread globe_activate( "mercury_outer",	8.8, 	1,	"kill_solar_lounge", "outer_solar","planet_static", "tag_fx_mercury" );
	thread globe_activate( "venus_outer",	22.45, 	1,	"kill_solar_lounge", "outer_solar","planet_static", "tag_fx_venus" );
	thread globe_activate( "earth_outer",	36.5, 	1,	"kill_solar_lounge", "outer_solar","planet_static", "tag_fx_earth" );
	
	// fx
	exploder( 600 );	// outer solar fx
	exploder( 601 );	// start FX inside the club
}


//
//	Activate a set of heavenly body holograms
globe_activate( str_targetname, n_orbit_time, n_orbit_direction, str_endon, str_cleanup, str_fx, str_tag )
{
	a_m_globes = GetEntArray( str_targetname, "targetname" );
	foreach( m_globe in a_m_globes )
	{
		m_globe setforcenocull();
		if ( IsDefined( str_cleanup ) )
		{
			m_globe add_cleanup_ent( str_cleanup );
		}
			
		// Scale value
		if ( IsDefined( m_globe.script_float ) )
		{
			m_globe IgnoreCheapEntityFlag( true );
		 	m_globe SetScale( m_globe.script_float );
		}
		
		if ( IsDefined( str_fx ) )
		{
			PlayFXOnTag( level._effect[ str_fx ], m_globe, str_tag );
		}
		
		m_globe thread spin_globe( str_endon, n_orbit_time, n_orbit_direction );
	}
}


//	
//	Slowly spin the large sun globes
//	self is a globe model
spin_globe( str_endon, n_orbit_time = 30, n_orbit_direction = 1 )
{
	if ( IsDefined( str_endon ) )
	{
		level endon( str_endon );
	}

	// Now spin!
	while( 1 )
	{
		self RotateYaw( n_orbit_direction * 360, n_orbit_time );
		wait( n_orbit_time );
	}
}

outer_door()
{
	trigger_wait( "t_lounge_door" );
	
	//IPrintLnBold( "Closing Outer Door" );

	time = 2.0;

	a_doors = GetEntArray( "solarentrance_door", "targetname");
	for( i=0; i<a_doors.size; i++ )
	{
		e_door = a_doors[i];
		e_clip = getent( e_door.target, "targetname" );
		e_clip LinkTo( e_door );
		e_door RotateYaw( e_door.script_int, time, 0, 0.15 );
	}
}

lounge_door()
{
	// Stop the bouncers idle	
	end_scene( "bouncer_lounge_door_idle" );

	// Start the bouncer opening door animations
	level thread bouncer_open_lounge_door_anims();

	// Time the door open with the animation
	wait( 1.3 );
	
	clientnotify( "scms" );
	
	//TUEY Set music to KARMA_1_ENTER_CLUB
	setmusicstate ("KARMA_1_ENTER_CLUB");

	m_lounge_door = GetEnt( "lounge_door", "targetname");
	m_lounge_door_clip = GetEnt( "lounge_door_clip", "targetname" );
	m_lounge_door_clip LinkTo( m_lounge_door );
	m_lounge_door RotateYaw( 110, 1.8, 0, 0.15 );		// 110, 3.0. 0. 0.15

	// Wait for the player to pass through the door
	trigger_wait( "t_lounge_door_close" );

	CONST N_TIME = 2.0;
	m_lounge_door RotateYaw( -110, N_TIME, 0, 0.15 );
	wait( N_TIME );
}

bouncer_open_lounge_door_anims()
{
	level run_scene_and_delete( "bouncer_lounge_door_open" );
	
	level thread run_scene_and_delete( "bouncer_lounge_door_wait" );
	flag_wait( "bouncer_lounge_door_wait_started" );
	
	ai_bouncer = get_ais_from_scene( "bouncer_lounge_door_wait", "lounge_bouncer" );
    ai_bouncer say_dialog( "door_have_a_nice_evening_0" );	// Have a nice evening, sir.
	                                
	trigger_wait( "t_lounge_door_close" );

    level thread run_scene_and_delete( "bouncer_lounge_door_close" );
	flag_set( "club_door_closed" );
}


salazar_think()
{
	self gun_remove();
	self maps\karma_civilians::set_civilian_run_cycle( undefined, level.scr_anim[ "hero" ][ "briefcase" ][ "walk" ] );
	self.disableArrivals = 1;	
	self.disableExits = 1;
	self.disableTurns = 1;
	self.goalradius = 8;
	
	trigger_wait( "t_outer_solar" );
}

assign_club_spawners()
{
	maps\karma_civilians::assign_civ_spawners( "club_bouncer" );
	maps\karma_civilians::assign_civ_spawners( "club_shadow_dancer" );
	maps\karma_civilians::assign_civ_spawners( "club_male", 2 );
	maps\karma_civilians::assign_civ_spawners( "club_female", 1 );
	maps\karma_civilians::assign_civ_spawners( "club_male_light", 1 );
	maps\karma_civilians::assign_civ_spawners( "club_female_light", 1 );
}

start_civs_outer_solar( str_kill_flag )
{
	//level thread maps\karma_civilians::spawn_civs( "solar_spawn", 30, "solar_initial", 15, str_kill_flag, 1, 3 );

	// Drones
	assign_club_spawners();
//	maps\karma_civilians::assign_civ_drone_spawners( "civ_club", "solar_drones" );
	maps\_drones::drones_setup_unique_anims( "solar_drones", level.drones.anims[ "civ_walk" ] );
	maps\_drones::drones_speed_modifier( "solar_drones", -0.1, 0.1 );

	// Static drones (need to make this a function)
	level maps\karma_civilians::spawn_static_civs( "static_outer_couples", 0.0 );	// needs to be in sync
	level maps\karma_civilians::spawn_static_civs( "static_outer_solar_elevator_civs" );
	level maps\karma_civilians::spawn_static_civs( "static_outer_civs" );

//	level thread maps\_drones::drones_start( "solar_drones" );
	
	// Outside the club scenes
	level thread run_scene_and_delete( "outer_solar_bouncer" );
	level thread run_scene_and_delete( "outer_solar_line_guy01" );
	level thread run_scene_and_delete( "outer_solar_line_guy02" );
	level thread run_scene_and_delete( "outer_solar_girl01" );
	level thread run_scene_and_delete( "outer_solar_girl02" );
	level thread run_scene_and_delete( "outer_solar_girl03" );
	level thread run_scene_and_delete( "outsol_dancer_a" );
	level thread run_scene_and_delete( "outsol_dancer_b" );
	level thread run_scene_and_delete( "outer_solar_guy01" );
	level thread run_scene_and_delete( "outer_solar_guy02" );
	level thread run_scene_and_delete( "outer_solar_guy03" );
	level thread run_scene_and_delete( "outer_solar_guy04" );
	
	level thread run_scene_and_delete( "outer_solar_coatcheck_area_2guys" );
	level thread run_scene_and_delete( "outer_solar_coatcheck_area_couple" );
	level thread run_scene_and_delete( "outer_solar_bar_seated" );

	// Bar anims
	level thread run_scene_and_delete( "outer_bar_e" );
	level thread run_scene_and_delete( "outer_bar_c" );
	level thread run_scene_and_delete( "outer_bar_a_girl2" );
	level thread run_scene_and_delete( "outer_bar_a_guy1" );
	level thread run_scene_and_delete( "outer_bar_b_guy1" );
	level thread run_scene_and_delete( "outer_bar_d_girl1" );
	level thread run_scene_and_delete( "outer_bar_d_guy2" );
	level thread run_scene_and_delete( "outer_bar_f_girl1" );
	level thread run_scene_and_delete( "outer_bar_f_guy1" );
	level thread run_scene_and_delete( "outer_bar_f_guy2" );
	level thread run_scene_and_delete( "outer_bar_g_girl1" );
	level thread run_scene_and_delete( "outer_bar_g_guy1" );
	level thread run_scene_and_delete( "outer_bar_g_guy2" );

	level thread seductive_lady_in_outer_bar();

	level thread blocking_club_bouncer();

	// Attach glasses to the drinkers
	m_civ = get_model_or_models_from_scene( "outer_bar_g_girl1", "outer_bar_g_girl1" );
	m_civ Attach( "hjk_vodka_glass_lrg", "TAG_WEAPON_LEFT" );

	m_civ = get_model_or_models_from_scene( "outer_bar_g_guy2", "outer_bar_g_guy2" );
	m_civ Attach( "p6_bar_beer_glass", "TAG_WEAPON_LEFT" );

	m_bartender = get_model_or_models_from_scene( "outer_bar_e", "outer_bar_e_bartender1" );
	m_bartender Attach( "p6_bar_shaker_no_lid", "TAG_WEAPON_LEFT" );
	m_bartender Attach( "p6_vodka_bottle", "TAG_WEAPON_RIGHT" );

	m_bartender = get_model_or_models_from_scene( "outer_bar_c", "outer_bar_c_bartender2" );
	m_bartender Attach( "p6_bar_shaker_no_lid", "TAG_WEAPON_LEFT" );
	m_bartender Attach( "p6_vodka_bottle", "TAG_WEAPON_RIGHT" );
	
	flag_wait( str_kill_flag );
	
	// Clear out the civs
//	level maps\_drones::drones_delete_spawned();

	level maps\karma_civilians::delete_civs( "static_outer_couples" );
	level maps\karma_civilians::delete_civs( "static_outer_solar_elevator_civs" );
	level maps\karma_civilians::delete_civs( "static_outer_civs" );
	
	end_scene( "outer_solar_bouncer" );
	end_scene( "outer_solar_line_guy01" );
	end_scene( "outer_solar_line_guy02" );
	end_scene( "outer_solar_girl01" );
	end_scene( "outer_solar_girl02" );
	end_scene( "outer_solar_girl03" );
	end_scene( "outsol_dancer_a" );
	end_scene( "outsol_dancer_b" );
	end_scene( "outer_solar_guy01" );
	end_scene( "outer_solar_guy02" );
	end_scene( "outer_solar_guy03" );
	end_scene( "outer_solar_guy04" );
	
	flag_wait( "kill_solar_lounge" );

	//IPrintLnBold( "DELETING ANIMATIONS - about to enter club" );

	end_scene( "outer_solar_coatcheck_area_2guys" );
	end_scene( "outer_solar_coatcheck_area_couple" );
	end_scene( "outer_solar_bar_seated" );
	wait( 0.1 );
	
	// Kill Bar Animations
	end_scene( "outer_bar_e" );
	end_scene( "outer_bar_c" );
	wait( 0.1 );

	end_scene( "outer_bar_a_girl2" );
	end_scene( "outer_bar_a_guy1" );
	wait( 0.1 );

	end_scene( "outer_bar_b_guy1" );
	end_scene( "outer_bar_d_girl1" );
	end_scene( "outer_bar_d_guy2" );
	wait( 0.1 );

	end_scene( "outer_bar_f_girl1" );
	end_scene( "outer_bar_f_guy1" );
	end_scene( "outer_bar_f_guy2" );
	wait( 0.1 );

	end_scene( "outer_bar_g_girl1" );
	end_scene( "outer_bar_g_guy1" );
	end_scene( "outer_bar_g_guy2" );
}

seductive_lady_in_outer_bar()
{
	trigger_wait( "t_enter_club" );

	//IPrintLnBold( "Starting seductive lady" );

	run_scene_and_delete( "outer_seductive_woman_intro" );

	str_scene_name = "outer_seductive_woman_loop";
	level thread run_scene_and_delete( str_scene_name );
	while( 1 )
	{
		if( flag("kill_solar_lounge") )
		{
			end_scene( str_scene_name );
			return;
		}
		wait( 0.01 );
	}
}

// Main Bouncer at Club Solar Enterance
blocking_club_bouncer()
{
	str_anim_name = "main_bouncer_loop";
	level thread run_scene_and_delete( str_anim_name );

	// Wait for the player to approach the bouncer
	e_trigger = getent( "player_approaches_main_bouncer_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	e_bouncer = getent( "club_main_enterance_bouncer_ai", "targetname" );

	level notify( "salazar_enter_club" );

	// Bouncer moves out of the way
	end_scene( str_anim_name );
	
	e_bouncer thread blocking_bouncer_vo_and_wristband();

	str_anim_name = "main_bouncer_moveout";
	run_scene_and_delete( str_anim_name );

	// Waits for Mason and Salazar to pass
	str_anim_name = "main_bouncer_moveout_loop";
	level thread run_scene_and_delete( str_anim_name );

	trigger_wait( "t_enter_club" );
	
	// Move back to a blocking position
	end_scene( str_anim_name );
	
	str_anim_name = "main_bouncer_moveback";
	run_scene_and_delete( str_anim_name );

	str_anim_name = "main_bouncer_moveback_complete_loop";
	level thread run_scene_and_delete( str_anim_name );

	while( 1 )
	{
		if( flag("kill_outer_solar") )
		{
			break;
		}
		wait( 0.01 );
	}

	end_scene( str_anim_name );
}

blocking_bouncer_vo_and_wristband()
{
	level thread player_show_wristband( 0.75 );

	level.player say_dialog( "woma_hey_how_come_they_0" );		// Hey!  How come they don't have to wait in line?
	self say_dialog( "door_their_ids_say_vip_0" );				// Their IDs say VIP.

	//level.player say_dialog( "dude_come_on_man_the_chi_0" );	// Come on man, the chicks are all inside!
	//self say_dialog( "door_sorry_sir_we_re_v_0" );				// Sorry, sir. We’re very busy tonight.
}

player_show_wristband( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	level.player ShowViewModel();

/*
	level.player TakeWeapon( "noweapon_sp" );
	wait(0.1);
	level.player GiveWeapon( "noweapon_sp" );
	level.player SwitchToWeapon( "noweapon_sp" );
*/

	level.player EnableWeapons();
	level.player GiveWeapon( "noweapon_sp_arm_raise" );
	level.player SwitchToWeapon( "noweapon_sp_arm_raise" );
	wait( 2 );
	level.player TakeWeapon( "noweapon_sp_arm_raise" );

	level.player DisableWeapons();
	level.player HideViewModel();
}


start_civs_lounge( str_kill_flag )
{
	maps\karma_civilians::assign_civ_drone_spawners( "civ_club", "lounge_drones" );	
	
	level maps\karma_civilians::spawn_static_civs( "static_lounge" );
	level maps\karma_civilians::spawn_static_civs( "static_club_approaching" );
	level maps\karma_civilians::spawn_static_civs( "static_club_approaching_couples", 0.0 );
//	level thread maps\_drones::drones_start( "lounge_drones" );	

	flag_wait( str_kill_flag );	

	// Clear out the civs
	level thread maps\_drones::drones_delete_spawned();
	level thread maps\karma_civilians::delete_civs( "static_lounge" );
}

ai_logic()
{
	self gun_remove();
}


//
//
outer_solar_cleanup()
{
	//TODO start door close for club entrance
	flag_set( "kill_outer_solar" );

	// wait for door closed
	flag_wait( "club_door_closed" );
	
	flag_set( "kill_solar_lounge" );
	wait( 0.1 );
	
	stop_exploder( 600 ); 
	wait( 0.1 );
	
	cleanup_ents( "outer_solar" );
}


/////////////////////////////////////////////////////////////////////
//	D I A L O G
/////////////////////////////////////////////////////////////////////

//
//	Player dialog during PIP
//	self is the player
enter_club_dialog()
{
	if ( flag( "harper_pip_done" ) )
	{
	    self say_dialog("sect_salazar_upstairs_0" );		//Salazar, head upstairs.  I?ll take this floor.
		self say_dialog("sect_harper_where_are_y_0" );		//Harper - Where are you?
		self say_dialog("harp_we_re_on_the_dance_f_0" );	//We're on the Dance floor!
		self say_dialog("sect_on_my_way_0" );				//On my way.
	}
}

