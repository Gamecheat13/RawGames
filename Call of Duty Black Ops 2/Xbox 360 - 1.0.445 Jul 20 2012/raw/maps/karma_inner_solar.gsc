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
#insert raw\maps\karma.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "entered_inner_club" );		// triggered
	flag_init( "salazar_start_overwatch" );
	flag_init( "start_club_encounter" );	// triggered
	flag_init( "stop_club_fx" );
	flag_init( "club_left_flee" );
	flag_init( "club_right_flee" );
	flag_init( "club_rear_flee" );
	flag_init( "run_to_bar" );
	flag_init( "start_bar_fight" );
	flag_init( "heroes_open_fire" );
	flag_init( "club_open_fire" );
	flag_init( "club_stop_timescale" );
	flag_init( "club_civs_scream" );
	flag_init( "counterterrorists_win" );
	flag_init( "exit_club" );
	
	flag_init( "club_terrorists_alerted" );
}

//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
	add_spawn_function_group( "club_terrorists", "script_noteworthy", ::club_terrorist_think );
	add_spawn_function_group( "club_pmc1", "targetname", ::club_terrorist_think );
	add_spawn_function_group( "club_pmc2", "targetname", ::club_terrorist_think );
	add_spawn_function_group( "club_pmc3", "targetname", ::club_terrorist_think );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_inner_solar()
{
	maps\karma_anim::club_anims();

	level.ai_salazar = init_hero( "salazar" );
	level.ai_harper	 = init_hero( "harper", ::harper_think );
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		level.ai_harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	}
	
	skipto_teleport( "skipto_inner_solar" );
	
	level thread harper_and_karma_loop();

	maps\karma_outer_solar::assign_club_spawners();
	level maps\karma_civilians::spawn_static_civs( "static_club_approaching" );
	level maps\karma_civilians::spawn_static_civs( "static_club_approaching_couples", 0.0 );

	exploder( 601 );	// start FX inside the club

	//This notify will start the music right when you open the club door
	wait( 3.0 );
	clientnotify( "scms" );
	level thread club_fx();
	level thread populate_club();
	

	
}

skipto_solar_fight()
{
	level.player SetStance( "crouch" );	
	level.player AllowStand( false );

	bm_clip = GetEnt( "dance_floor_clip", "targetname" );
	bm_clip Delete();

	level thread maps\createart\karma_art::vision_set_change( "sp_karma_ClubMain" );
	maps\karma_anim::club_anims();

	level.ai_salazar 	= init_hero( "salazar", ::salazar_think );
	level.ai_harper		= init_hero( "harper", ::harper_think );
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		level.ai_harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	}
	
	maps\karma_outer_solar::assign_club_spawners();
	level thread club_drones();

	skipto_teleport( "skipto_solar_fight" );
	
	// Delete group dancers
	a_m_groups = GetEntArray( "m_civ_club_group1", "targetname" );
	array_delete( a_m_groups );

	level thread change_club_lights();
	level.player thread inner_club_dialog();
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
//
//	Intro Defalco taking Karma
club_intro()
{
	/#
		IPrintLn( "INNER_SOLAR" );
	#/

	level thread inner_solar_objectives();

	level.player thread inner_club_dialog();

	level.ai_salazar thread salazar_think();

	trigger_wait( "t_club_start_harper" );

	if ( !IsDefined( level.n_aggressivecullradius ) )
	{
		level.n_aggressivecullradius = GetDvar( "Cg_aggressivecullradius" );
	}
	SetSavedDvar( "Cg_aggressivecullradius", 50 );
	
	// Player enters the dance floor and Defalco enters
	flag_wait( "start_club_encounter" );
	
	bm_clip = GetEnt( "dance_floor_clip", "targetname" );
	bm_clip Delete();

	level thread clear_background_civilians();
	level thread change_club_lights( 2, 2 );
	level.player EnableInvulnerability();	// don't let player get shot by squibs

	level thread run_scene_and_delete( "club_encounter" );
	level thread run_scene_and_delete( "club_encounter_player" );
	level thread run_scene_and_delete( "club_encounter_dancers2" );
	level thread run_scene_and_delete( "club_encounter_dancers3" );
	
	//sound snapshot notify -- GSpin
	clientnotify ("lull");

	level thread club_drones();

	wait( 5 );	// wait just before Defalco shoots DJ, need some lead time to spawn drones
	
	level.player AllowStand( false );	
	level.player SetStance( "crouch" );	

	flag_set( "club_left_flee" );
	
	wait( 1.5 );	// wait till just before we look away...start deleting shrimps, need some lead time to spawn drones
	
	flag_set( "club_right_flee" );

	// Timing when we turn on PIP.
//	wait 1.75;
//	flag_set( "salazar_start_overwatch" );
	
	level thread play_notify_music_start();
	scene_wait( "club_encounter" );

	thread autosave_now( "club_fight" );
	SetSavedDvar( "Cg_aggressivecullradius", level.n_aggressivecullradius );
}
play_notify_music_start()
{
	setmusicstate ("KARMA_1_DEFALCO");
	//TODO: This needs to be triggered off of a notetrack in the animation once its finalized
	wait(22.5);
	clientnotify( "scm3" );
	setmusicstate ("KARMA_1_CLUB_FIGHT");
}

//
//	Eliminate the guards left behind
club_fight()
{
	flag_set( "start_bar_fight" );
	
	level thread club_fight_objectives();

	thread run_scene( "bar_fight_player" );
	thread run_scene_and_delete( "bar_fight_harper" );
	thread run_scene_and_delete( "bar_fight_pmcs" );
	thread player_bar_fight();

	t_column = GetEnt( "t_explosions_bar", "targetname" );
	t_column thread ready_explosions( true );
	
	exploder( 630 );

	// Hacky waits to time the guy intros
	wait( 2.0 );
	
	thread run_scene( "bar_fight_pmc5" );	//	left side - looking left, swing right

	wait( 1.6 );
	
	thread run_scene( "bar_fight_pmc9" );	// far back-center leaps over railing

	wait( 0.9 );

	thread run_scene( "bar_fight_pmc4" );	//	mid-center, looking other way, surprised raise

	wait( 1.7 );

	thread run_scene( "bar_fight_pmc7" );	// jump off stage, left
	thread run_scene( "bar_fight_pmc8" );	// jump off stage, right

	// Spawn other actors for the scene
	level.a_ai_club_terrorists = simple_spawn( "club_terrorist_floor", ::club_terrorist_think );
//	simple_spawn( "club_terrorist_wave1" );

	level.ai_harper get_ai_targets( "club_target_harper" );

	// Prep massive explosions
	a_t_damage = GetEntArray( "t_explosions", "targetname" );
	array_thread( a_t_damage, ::ready_explosions );
	
	scene_wait( "bar_fight_harper" );

	waittill_ai_group_ai_count( "aig_club_terrorists", 0 );

	flag_set( "counterterrorists_win" );
	
//	trigger_wait( "t_end_club" );

	karma_2_transition();
}



/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

//
//	Club objective management
inner_solar_objectives()
{
	objective_breadcrumb( level.OBJ_MEET_KARMA, "t_lounge_door_close" );

	flag_wait( "start_club_encounter" );	// triggered

	set_objective( level.OBJ_MEET_KARMA, undefined, "done" );
}

club_fight_objectives()
{
	set_objective( level.OBJ_KILL_CLUB_GUARDS, undefined );
	
	flag_wait( "counterterrorists_win" );

	set_objective( level.OBJ_KILL_CLUB_GUARDS, undefined, "done" );
	
	t_exit = GetEnt( "t_end_club", "targetname" );
	set_objective( level.OBJ_EXIT_CLUB, t_exit );
	t_exit waittill( "trigger" );
	
	set_objective( level.OBJ_EXIT_CLUB, undefined, "done" );
}


//
//	Change the lights
#using_animtree("animated_props");
change_club_lights( n_time_floor = 0.05, n_time_exposure = 0.05 )
{
	//	Brighten up the club
	
	// Turn on dance floor spotlights
	a_e_lights = GetEntArray( "speechlight", "targetname" );
	foreach( e_light in a_e_lights )
	{
		e_light setforcenocull();
	}
	if ( !flag( "run_to_bar" ) )
	{
		// set these lights to nocull so that it doesn't get removed by aggressivecull
		array_thread( a_e_lights, ::lerp_intensity, 30, n_time_floor );
	}
	thread blend_exposure_over_time( 4.0, n_time_exposure );

	flag_wait( "run_to_bar" );
	
	// Turn off the speech lights 
	array_thread( a_e_lights, ::lerp_intensity, 0, n_time_floor );
	wait( n_time_floor );
	
	// Turn on the fight lights
//	a_e_lights = GetEntArray( "fight_light", "targetname" );
//	array_thread( a_e_lights, ::lerp_intensity, 20, n_time_floor );

	// Turn up lights on the walls and columns
	ClientNotify( "clon" );	// club lights on
}


//
//	Main club special FX
club_fx()
{
	// Candles
	a_s_candles = GetStructArray( "candle_flame", "targetname" );
	foreach( s_candle in a_s_candles )
	{
		if ( IsDefined( s_candle.angles ) )
		{
			v_forward = AnglesToForward( s_candle.angles );
		}
		else
		{
			v_forward = ( 1, 0, 0 );
		}
		PlayFX( level._effect["kar_candle01"], s_candle.origin, v_forward );
	}

	// Ashtrays
	a_s_ashtrays = GetStructArray( "ashtray_smoke", "targetname" );
	foreach( s_ashtray in a_s_ashtrays )
	{
		if ( IsDefined( s_ashtray.angles ) )
		{
			v_forward = AnglesToForward( s_ashtray.angles );
		}
		else
		{
			v_forward = ( 1, 0, 0 );
		}
		PlayFX( level._effect["kar_ashtray01"], s_ashtray.origin, v_forward );
	}

	
	// DJ Light Cage
	// Note: There is a maximum of 4 effects that can play on a single entity,
	//	so to get 20 effects to play on one, we're using play_fx
//	m_laser = GetEnt( "fxanim_club_dj_light_cage", "targetname" );
//	m_laser setforcenocull();
//
//	for( i=1; i<=9; i++ )
//	{
//		str_tag = "dj_cage_light_0"+i+"_jnt";
//		v_origin = m_laser GetTagOrigin( str_tag );
//		v_angles = m_laser GetTagAngles( str_tag );
//		m_laser play_fx( "club_dj_cage_laser", v_origin, v_angles, "stop_fx", true, str_tag );
//	}
//	for( i=10; i<=20; i++ )
//	{
//		str_tag = "dj_cage_light_"+i+"_jnt";
//		v_origin = m_laser GetTagOrigin( str_tag );
//		v_angles = m_laser GetTagAngles( str_tag );
//		m_laser play_fx( "club_dj_cage_laser", v_origin, v_angles, "stop_fx", true, str_tag );
//	}
//	level notify( "fxanim_club_dj_light_cage_start" );

	flag_wait( "club_door_closed" );
	wait( 2.0 );	// let outer solar shutdown
	
	// Top lasers
	for( i=1; i<= 12; i++ )
	{
		m_laser = GetEnt( "fxanim_club_top_laser_"+i, "targetname" );
		m_laser setforcenocull();
		str_tag = "laser_attach_jnt";
		v_origin = m_laser GetTagOrigin( str_tag );
		v_angles = m_laser GetTagAngles( str_tag );
		m_laser play_fx( "club_dance_floor_laser", v_origin, v_angles, "stop_fx", true, str_tag, true );
	}
	level notify( "fxanim_club_top_lasers_start" );
	wait( 0.05 );

	// Front DJ Lasers	
	level thread club_dj_front_lasers();
	wait( 5.05 );
	

	exploder( 620 );	// club fx

	// Spinning Solar System
	thread globe_activate( "sun_globe_inner", 	30, 	-1, "kill_solar_lounge", "outer_solar","club_sun", 		"tag_origin" );
	thread globe_activate( "mercury",			8.8, 	1,	"kill_solar_lounge", "outer_solar" );
	thread globe_activate( "venus",				22.45, 	1,	"kill_solar_lounge", "outer_solar" );
	thread globe_activate( "earth",				36.5, 	1,	"kill_solar_lounge", "outer_solar" );

	///////////////////////
	// Wait for DJ Death	
	///////////////////////
	flag_wait( "stop_club_fx" );
	
	stop_exploder( 601 );	// club fx
	stop_exploder( 620 );	// club fx

	// Top lasers
	for( i=1; i<= 12; i++ )
	{
		m_laser = GetEnt( "fxanim_club_top_laser_"+i, "targetname" );
		m_laser notify( "stop_fx" );
	}
		
	wait( 0.05 );
	
	// DJ Front laser 1
	m_laser = GetEnt( "fxanim_club_dj_laser_1", "targetname" );
	m_laser.fx_origin Delete();
	wait( 0.05 );

	// Spawn a new FX on laser 1
	m_laser = GetEnt( "fxanim_club_dj_laser_2", "targetname" );
	m_laser.fx_origin Delete();
	m_laser.fx_origin = spawn_model( "tag_origin", m_laser GetTagOrigin( "laser_attach_jnt" ), m_laser GetTagAngles( "laser_attach_jnt" ) );
	m_laser.fx_origin LinkTo( m_laser, "laser_attach_jnt" );
	PlayFxOnTag( level._effect["club_dj_front_laser_static"], m_laser.fx_origin, "tag_origin" );

	// DJ Light Cage
//	m_laser = GetEnt( "fxanim_club_dj_light_cage", "targetname" );
//	m_laser Delete();
}


//
//	Manipulate the front laser FX
club_dj_front_lasers()
{
	level endon( "stop_club_fx" );
		
	// If we used the club_fight skipto...
	if ( flag( "run_to_bar" ) )
	{
		return;
	}

	// Spawn a tag_origin joint to play FX from
	m_laser1 = GetEnt( "fxanim_club_dj_laser_1", "targetname" );
	m_laser1 setforcenocull();
	m_laser1.fx_origin = spawn_model( "tag_origin", m_laser1 GetTagOrigin( "laser_attach_jnt" ), m_laser1 GetTagAngles( "laser_attach_jnt" ) );
	m_laser1.fx_origin LinkTo( m_laser1, "laser_attach_jnt" );
		
	m_laser2 = GetEnt( "fxanim_club_dj_laser_2", "targetname" );
	m_laser2 setforcenocull();
	m_laser2.fx_origin = spawn_model( "tag_origin", m_laser2 GetTagOrigin( "laser_attach_jnt" ), m_laser2 GetTagAngles( "laser_attach_jnt" ) );
	m_laser2.fx_origin LinkTo( m_laser2, "laser_attach_jnt" );

	level notify( "fxanim_club_dj_lasers_start" );

	while (1)
	{
		exploder( 627 );	// dj smoke
		// DJ Laser
		PlayFxOnTag( level._effect["club_dj_front_laser2_smoke"], m_laser1.fx_origin, "tag_origin" );
		PlayFxOnTag( level._effect["club_dj_front_laser2_smoke"], m_laser2.fx_origin, "tag_origin" );
		wait( 10 );
		PlayFxOnTag( level._effect["club_dj_front_laser2_light"], m_laser1.fx_origin, "tag_origin" );
		PlayFxOnTag( level._effect["club_dj_front_laser2_light"], m_laser2.fx_origin, "tag_origin" );
		wait( 10 );
		PlayFxOnTag( level._effect["club_dj_front_laser2_disco"], m_laser1.fx_origin, "tag_origin" );
		PlayFxOnTag( level._effect["club_dj_front_laser2_disco"], m_laser2.fx_origin, "tag_origin" );
		wait( 10 );
		PlayFxOnTag( level._effect["club_dj_front_laser2_fan"], m_laser1.fx_origin, "tag_origin" );
		PlayFxOnTag( level._effect["club_dj_front_laser2_fan"], m_laser2.fx_origin, "tag_origin" );
		wait( 10 );
		PlayFxOnTag( level._effect["club_dj_front_laser2_roller"], m_laser1.fx_origin, "tag_origin" );
		PlayFxOnTag( level._effect["club_dj_front_laser2_roller"], m_laser2.fx_origin, "tag_origin" );
		wait( 10 );
		PlayFxOnTag( level._effect["club_dj_front_laser2_shell"], m_laser1.fx_origin, "tag_origin" );
		PlayFxOnTag( level._effect["club_dj_front_laser2_shell"], m_laser2.fx_origin, "tag_origin" );
		wait( 10 );
	}
}


// 	Initial civilians in the dance club
//	They will clear out when Defalco arrives
start_civs_club()
{
	// Light Drones
	maps\_drones::drones_set_max( 256 );

	// Spawn static drones
	level maps\karma_civilians::spawn_static_civs( "static_club_patrons" );
	level maps\karma_civilians::spawn_static_civs( "static_club_patron_couples", 0.0 );
	wait( 0.5 );
	level maps\karma_civilians::spawn_static_civs( "static_club_dancers" );
}


#using_animtree( "animated_props" );
//
//	animating a model of 6 people 
group_dancing()
{
	self endon( "death" );
	
	self UseAnimTree( #animtree );
	wait( RandomFloatRange( 0.0, 1.0 ) );
	     
	if ( RandomInt( 100 ) < 50 )
	{
		maps\_anim::anim_generic( self, "group_dancing2" );
	}
	while (1)
	{
		maps\_anim::anim_generic( self, "group_dancing1" );
		maps\_anim::anim_generic( self, "group_dancing2" );
	}
}


//
//	Play scenes for our club civs.  Space them out so we don't kill our processor
populate_club()
{
	// Seductive woman	
	level thread seductive_woman();
	
// Dance Floor actors
	// Spawn the actors for the Harper PIP scene

	level thread run_scene_and_delete( "dj_loop" );
	wait( 0.1 );	// spacing out for performance
	level.ai_dj = get_model_or_models_from_scene( "dj_loop", "club_dj" );
	level.ai_dj setforcenocull();

	level thread run_scene_and_delete( "club_encounter_hostages_loop" );
	wait( 0.1 );	// spacing out for performance
	
	level thread run_scene_and_delete( "club_encounter_dancers1_loop" );
	wait( 0.1 );	// spacing out for performance

	level thread run_scene_and_delete( "club_encounter_dancers2_loop" );
	wait( 0.1 );	// spacing out for performance
	
	level thread run_scene_and_delete( "club_encounter_dancers3_loop" );
	wait( 0.1 );	// spacing out for performance

	// Make sure the actors don't get culled out during the PIP
	a_models = get_model_or_models_from_scene( "club_encounter_hostages_loop" );
	foreach( model in a_models )
	{
		model setforcenocull();
	}
	a_models = get_model_or_models_from_scene( "club_encounter_dancers1_loop" );
	foreach( model in a_models )
	{
		model setforcenocull();
	}
	a_models = get_model_or_models_from_scene( "club_encounter_dancers2_loop" );
	foreach( model in a_models )
	{
		model setforcenocull();
	}
	a_models = get_model_or_models_from_scene( "club_encounter_dancers3_loop" );
	foreach( model in a_models )
	{
		model setforcenocull();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////
	flag_wait( "club_door_closed" );
	
	
wait( 1 );	// let outer solar shut down
	
	a_m_group_dancers = GetEntArray( "m_civ_club_group1", "targetname" );
	array_thread( a_m_group_dancers, ::group_dancing );
	wait( 0.1 );	// spacing out for performance
	
// General static civs
	level start_civs_club();
	wait( 0.1 );	// spacing out for performance


// Background shrimps
	exploder( 621 );	// rear section shrimps
	wait( 0.1 );	// spacing out for performance

	exploder( 622 );	// left section shrimps
	wait( 0.1 );	// spacing out for performance

	exploder( 623 );	// right section shrimps
	wait( 0.1 );	// spacing out for performance

// Bar Reactions	
	level thread react_scene( "trig_club_react_a", "club_react_a_start_idle", "club_react_a_react", "club_react_a_end_idle", "start_club_encounter" );
	wait( 0.1 );	// spacing out for performance
	
	level thread react_scene( "trig_club_react_b", "club_react_b_start_idle", "club_react_b_react", "club_react_b_end_idle", "start_club_encounter" );
	wait( 0.1 );	// spacing out for performance
	
	level thread react_scene( "trig_club_react_c", "club_react_c_start_idle", "club_react_c_react", "club_react_c_end_idle", "start_club_encounter" );
	wait( 0.1 );	// spacing out for performance
	
//	Dance Floor parters
	level thread react_scene( "t_part_dancers_a", "club_dance_parters_a_loop", "club_dance_parters_a_react", "club_dance_parters_a_endloop", "start_club_encounter" );
	wait( 0.1 );	// spacing out for performance
	
	level thread react_scene( "t_part_dancers_b", "club_dance_parters_b_loop", "club_dance_parters_b_react", "club_dance_parters_b_endloop", "start_club_encounter" );
	wait( 0.1 );	// spacing out for performance
	
	level thread react_scene( "t_part_dancers_c", "club_dance_parters_c_loop", "club_dance_parters_c_react", "club_dance_parters_c_endloop", "start_club_encounter" );
	wait( 0.1 );	// spacing out for performance

	thread money_showers();
	
// Bar anims
	level thread run_scene( "bar_e" );
	wait( 0.5 );	// spacing out for performance
	level thread run_scene( "bar_c" );
	wait( 0.5 );	// spacing out for performance
	level thread run_scene( "bar_a_girl2" );
	level thread run_scene( "bar_a_guy1" );
	wait( 0.5 );	// spacing out for performance
//	level thread run_scene( "bar_b_guy1" );
//	wait( 0.5 );	// spacing out for performance
	level thread run_scene( "bar_d_girl1" );
	level thread run_scene( "bar_d_guy2" );
	wait( 0.5 );	// spacing out for performance
//	level thread run_scene( "bar_f_girl1" );
//	level thread run_scene( "bar_f_guy1" );
//	level thread run_scene( "bar_f_guy2" );
//	wait( 0.5 );	// spacing out for performance
	level thread run_scene( "bar_g_girl1" );
	level thread run_scene( "bar_g_guy1" );
	level thread run_scene( "bar_g_guy2" );
	wait( 0.5 );	// spacing out for performance

	// Attach glasses to the drinkers
	m_civ = get_model_or_models_from_scene( "bar_g_girl1", "bar_g_girl1" );
	m_civ Attach( "hjk_vodka_glass_lrg", "TAG_WEAPON_LEFT" );

	m_civ = get_model_or_models_from_scene( "bar_g_guy2", "bar_g_guy2" );
	m_civ Attach( "p6_bar_beer_glass", "TAG_WEAPON_LEFT" );

	m_bartender = get_model_or_models_from_scene( "bar_e", "bar_e_bartender1" );
	m_bartender Attach( "p6_bar_shaker_no_lid", "TAG_WEAPON_LEFT" );
	m_bartender Attach( "p6_vodka_bottle", "TAG_WEAPON_RIGHT" );

	m_bartender = get_model_or_models_from_scene( "bar_c", "bar_c_bartender2" );
	m_bartender Attach( "p6_bar_shaker_no_lid", "TAG_WEAPON_LEFT" );
	m_bartender Attach( "p6_vodka_bottle", "TAG_WEAPON_RIGHT" );
	
	flag_wait( "start_club_encounter" );

	// end the scenes early if they are still playing
	end_scene( "club_react_a_react" );
	end_scene( "club_react_b_react" );
	end_scene( "club_react_c_react" );
}


//
//	Woman walks down the hall and looks at you
seductive_woman()
{
	trigger_wait( "trig_club_hallway" );
	
	thread run_scene( "seductive_woman_intro" );
	wait( 0.05 );
	ai_woman = get_ais_from_scene( "seductive_woman_intro", "seductive_woman" );
	ai_woman LookAtEntity( level.player );
	scene_wait( "seductive_woman_intro" );
	
	thread run_scene( "seductive_woman_loop" );
}


//
//	exploders of clubbers throwing money in the air
money_showers()
{
	level endon( "start_club_encounter" );

	// Need to start each exploder to create the civs, which will stick around.  
	//  Then calling the FX again will restart the shower but not create additional civs.
	exploder( 624 );
	wait( 2.0 );	// waiting for performance
	
	exploder( 625 );
	wait( 2.0 );	// waiting for performance

	exploder( 626 );
	wait( 2.0 );	// waiting for performance
	
	a_spots[0] = 624;
	a_spots[1] = 625;
	a_spots[2] = 626;
	a_spots = array_randomize( a_spots );
	
	n_index = 0;
	while( 1 )
	{
		exploder( a_spots[ n_index ] );
		wait( RandomFloatRange( 3, 4 ) );
		n_index++;
		
		// Time to Recycle
		if ( n_index == a_spots.size )
		{
			n_last_spot = a_spots[ n_index - 1 ];
			n_index = 0;
			a_spots = array_randomize( a_spots );

			// Don't repeat the same one twice
			if ( a_spots[ 0 ] == n_last_spot )
			{
				a_spots[0] = a_spots[ a_spots.size - 1 ];
				a_spots[ a_spots.size - 1 ] = n_last_spot;
			}
		}
	}
}


//
// Can't start looping until the pip scene is done
harper_and_karma_loop()
{
	flag_wait( "harper_pip_done" );

	level thread run_scene_and_delete( "club_encounter_harper_loop" );
}


//
//	Drones in the club includes people running from Defalco's men.
club_drones()
{
	// Setup drone spawners	to use civs
	a_str_types[0] = "club_male_light";
	a_str_types[1] = "club_female_light";
	maps\karma_civilians::assign_civ_drone_spawners_by_type( a_str_types, "club_left_flee" );
	maps\karma_civilians::assign_civ_drone_spawners_by_type( a_str_types, "club_right_flee" );
	maps\karma_civilians::assign_civ_drone_spawners_by_type( a_str_types, "club_rear_flee" );
	maps\karma_civilians::assign_civ_drone_spawners_by_type( a_str_types, "dance_floor_flee" );

	level.drone_run_rate = 100;
	level.drones.trace_height = 100;
//	drones_speed_modifier( "club_left_flee",	0.6, 0.8 );
//	drones_speed_modifier( "club_right_flee",	0.6, 0.8 );
//	drones_speed_modifier( "dance_floor_flee",	0.6, 0.8 );
		
	// Setup drone anims
	maps\karma_anim::setup_drone_run_anims();
	drones_setup_unique_anims( "club_left_flee",	level.drone_cycle_override );
	drones_setup_unique_anims( "club_right_flee",	level.drone_cycle_override );
	drones_setup_unique_anims( "club_rear_flee",	level.drone_cycle_override );
	drones_setup_unique_anims( "dance_floor_flee",	level.drone_cycle_override );
	
	// check in case we did a skipto	
	if ( !flag( "stop_club_fx" ) )
	{
		// spawn people fleeing the VIP areas
		flag_wait( "club_left_flee" );

		level thread maps\_drones::drones_start( "club_left_flee" );
		flag_wait( "club_right_flee" );
		
		level thread maps\_drones::drones_start( "club_right_flee" );
		flag_wait( "club_rear_flee" );
		wait( 1.0 );	// timing adjustment
		level thread maps\_drones::drones_start( "club_rear_flee" );
	}
	
	// spawn people fleeing the club

	flag_wait( "start_bar_fight" );

	level thread maps\_drones::drones_start( "dance_floor_flee" );
}
	
	
//////////////////////////////////////////////	
//// Scene callback functions

//	Triggers crowd to flee
start_crowd_flee( m_player_body )
{
	flag_set( "run_to_bar" );
	level thread fire_at_bar();
	level thread run_scene_and_delete( "club_encounter_hostage_flee" );
}


//
//	Startup the bullet time
bullet_time( m_player_body )
{
	flag_set( "heroes_open_fire" );

	// Start timescale and burst into action
	CONST N_TIMESCALE = 0.1;
	CONST N_RAMPDOWN_TIME = 0.05;
	thread timescale_tween( 1.0, N_TIMESCALE, N_RAMPDOWN_TIME, 0.0, 0.05 );
	wait( 0.1 );	// constant time

	CONST N_TIMESCALE2 = 0.2;
	CONST N_RAMPDOWN_TIME2 = 0.05;
	thread timescale_tween( N_TIMESCALE, N_TIMESCALE2, N_RAMPDOWN_TIME2, 0.0, 0.05 );
	wait( 1.5 );	// constant time

	RadiusDamage( (1634, -6797, -2719), 10, 50, 50 );
	flag_set( "club_stop_timescale" );
	thread timescale_tween( N_TIMESCALE2, 1.0, 1.0, 0.0, 0.05 );

	wait( 1.0 );
	RadiusDamage( (1602, -6828, -2719), 10, 100, 100 );
}


//
//
shoot_dj( ai_defalco )
{
	ai_defalco fire_round( level.ai_dj );
	PlayFXOnTag( level._effect["execution_blood"], level.ai_dj, "J_Head" );
	//wait( 1.0 );
	
	clientnotify( "scm2" );
	flag_set( "stop_club_fx" );
	exploder( 628 );
}

shoot_hostage( ai_defalco )
{
	m_hostage = get_model_or_models_from_scene( "club_encounter", "female_hostage1" );
//	ai_defalco fire_round( m_hostage );
	ai_defalco shoot();
	PlayFXOnTag( level._effect["execution_blood"], m_hostage, "J_Head" );
}

//
//	Harper shoots his guys
shoot_pmc1( ai_harper )
{
	ai_harper fire_round( level.ai_harper.a_ai_targets[0] );
}
shoot_pmc2( ai_harper )
{
	ai_harper fire_round( level.ai_harper.a_ai_targets[1] );
}
shoot_pmc3( ai_harper )
{
	ai_harper fire_round( level.ai_harper.a_ai_targets[2] );
}
//
//	Fire a round at the target
fire_round( ai_target )
{
	v_origin = self GetTagOrigin( "TAG_FLASH" );
	
	if ( IsDefined( ai_target ) )
	{
		if ( IsAI( ai_target ) )
		{
			ai_target.a.nodeath = true; 
		}
		v_dest = ai_target GetTagOrigin( "J_Head" );
		MagicBullet ( "fiveseven_sp", v_origin, v_dest, self );
	}
	else
	{
		self Shoot();
	}
}

//
//	Guy gets shot and killed by harper
killed_by_harper( ai_guy )
{

	if ( IsAlive( ai_guy ) )
	{
		if ( IsDefined( level.ai_harper.a_ai_targets ) &&
		     IsDefined( level.ai_harper.a_ai_targets[0] ) &&
		     level.ai_harper.a_ai_targets[0] == ai_guy )
		{
			flag_set( "club_stop_timescale" );
		}

		ai_guy.a.nodeath = true; 
		scene_wait( "bar_fight_pmcs" );

		if ( IsDefined( ai_guy ) )
		{
			ai_guy thread entity_hold_last_anim_frame();
		}
	}
}


//
//
dj_killed( ai_callback )
{
	PlayFXOnTag( level._effect["blood_spurt"], ai_callback, "J_Head" );
}


//
//	Fire bullets at the 
fire_at_bar()
{
	a_s_shooters = GetStructArray( "shooter_squib", "targetname" );
	a_s_bar_targets = GetStructArray( "bar_squib", "targetname" );
	
	// Now fire shots at the bar too
	n_timeout = GetTime() + 6500;
	while( GetTime() < n_timeout )
	{
		s_origin = random( a_s_shooters );
		s_end = random( a_s_bar_targets );

		v_start = s_origin.origin;
		v_random = ( RandomFloatRange( -1.0, 1.0), 0, RandomFloatRange( -1.0, 1.0) );
		v_end = s_end.origin + (v_random*16);
		v_direction = VectorNormalize( v_end - v_start );
		PlayFX( level._effect["club_tracers"], v_start, v_direction );
		MagicBullet ( "hk416_sp", v_start, v_end );
		RadiusDamage( v_end, 5, 100, 100 );
		wait( RandomFloatRange( 0.02, 0.17 ) );
	}
}


//
//	wait for trigger to be damaged, then set off massive explosions
ready_explosions( b_run_immediate )
{
	if ( !IsDefined( b_run_immediate ) || !b_run_immediate )
	{
		self waittill( "trigger" );
	}
	
	s_squib = GetStruct( self.target, "targetname" );
	if ( !IsDefined( s_squib ) )
	{
		s_squib = GetNode( self.target, "targetname" );
	}
	
	while( IsDefined( s_squib ) )
	{
		playsoundatposition( "dst_club_lights", s_squib.origin );
		PhysicsExplosionCylinder( s_squib.origin, 50, 10, 1.5 );
		RadiusDamage( s_squib.origin, 20, 500, 500, level.ai_harper );
		wait( 0.3 );

		if ( IsDefined( s_squib.target ) )
		{
			s_squib = GetStruct( s_squib.target, "targetname" );
		}
		else
		{
			break;
		}
	}
}


//
//	The second group of AI enter the club
spawn_wave2()
{
	// Find out where the player is and spawn accordingly
	e_area_ne = GetEnt( "info_club_ne", "targetname" );
	e_area_nw = GetEnt( "info_club_nw", "targetname" );
	e_area_se = GetEnt( "info_club_se", "targetname" );
	e_area_sw = GetEnt( "info_club_sw", "targetname" );
	
	if ( level.player IsTouching( e_area_ne ) )
	{
		simple_spawn( "club_terrorist_wave2_upper_s" );
		simple_spawn( "club_terrorist_wave2_upper_w" );
		wait( 3.0 );
		
		simple_spawn( "club_terrorist_wave2_s" );
		simple_spawn( "club_terrorist_wave2_sw" );
	}
	else if ( level.player IsTouching( e_area_nw ) )
	{
		simple_spawn( "club_terrorist_wave2_upper_s" );
		simple_spawn( "club_terrorist_wave2_upper_e" );
		wait( 3.0 );

		simple_spawn( "club_terrorist_wave2_s" );
		simple_spawn( "club_terrorist_wave2_se" );
	}
	else if ( level.player IsTouching( e_area_se ) )
	{
		simple_spawn( "club_terrorist_wave2_upper_n" );
		simple_spawn( "club_terrorist_wave2_upper_w" );
		wait( 3.0 );

		simple_spawn( "club_terrorist_wave2_n" );
		simple_spawn( "club_terrorist_wave2_nw" );
	}
	else if ( level.player IsTouching( e_area_sw ) )
	{
		simple_spawn( "club_terrorist_wave2_upper_n" );
		simple_spawn( "club_terrorist_wave2_upper_e" );
		wait( 3.0 );

		simple_spawn( "club_terrorist_wave2_n" );
		simple_spawn( "club_terrorist_wave2_ne" );
	}
}


//###############################################################
//	AI Think logic
//###############################################################

//
// Civs dance on the dance floor until Defalco arrives
//	then they cower
ai_scared_think()
{
	self endon( "death" );

	self.goalradius = 16;	
	self.ignoreall = true;
	self.ignoreme = true;

	self add_cleanup_ent( "club" );
	self gun_remove();
}


//
//	People spawned in to run away
ai_evacuee_think()
{
	self endon( "death" );
	
	self.goalradius = 8;
	self.ignoreall = true;
	self.ignoreme = true;
	
	self add_cleanup_ent( "club" );
	self gun_remove();

	nd_exit_club = GetNode( "club_exit_node_01", "targetname" );
	self SetGoalNode( nd_exit_club );

	flag_wait( "club_shoot_target_down" );

	self delete();
}

//
//	A generic actor with no weapon
club_actor_think()
{
	self endon( "death" );

	self.goalradius = 8;
	self.ignoreall = true;
	self.ignoreme = true;

	self add_cleanup_ent( "club" );
	self gun_remove();
}


//
//	Delete all of the dancing drones
clear_background_civilians()
{
	wait( 0.5 );	// wait for the scene to start
	
	// Start clearing out stuff
	level maps\karma_civilians::delete_civs( "club_rear", "script_noteworthy" );
	stop_exploder( 621 );	// rear section shrimps
	stop_exploder( 624 );	// rear section shower
	wait( 0.05 );			// performance

	level maps\karma_civilians::delete_civs( "club_left", "script_noteworthy" );
	stop_exploder( 622 );	// left section shrimps
	stop_exploder( 625 );	// left section shower
	wait( 0.05 );			// performance

	end_scene( "club_encounter_dancers1_loop" );
	end_scene( "bar_e" );
	wait( 0.1 );	// spacing out for performance

	end_scene( "bar_c" );
	wait( 0.1 );	// spacing out for performance

	end_scene( "bar_a_girl2" );
	end_scene( "bar_a_guy1" );
	end_scene( "bar_b_guy1" );
	end_scene( "bar_d_girl1" );
	end_scene( "bar_d_guy2" );
	end_scene( "bar_f_girl1" );
	end_scene( "bar_f_guy1" );
	end_scene( "bar_f_guy2" );
	end_scene( "bar_g_girl1" );
	end_scene( "bar_g_guy1" );
	end_scene( "bar_g_guy2" );
	wait( 0.1 );	// spacing out for performance

	level maps\karma_civilians::delete_civs( "static_club_approaching" );
	wait( 0.05 );			// performance

	level maps\karma_civilians::delete_civs( "static_club_approaching_couples" );

	// LEFT
	flag_wait( "club_left_flee" );
	
	// RIGHT	
	flag_wait( "club_right_flee" );

	// Delete group dancers
	a_m_groups = GetEntArray( "m_civ_club_group1", "targetname" );
	array_delete( a_m_groups );
	wait( 0.05 );

	stop_exploder( 623 );	// right section shrimps
	stop_exploder( 626 );	// right section shower
	wait( 0.05 );
	level thread maps\karma_civilians::spawn_static_civs( "static_civ_flee" );
	level thread maps\karma_civilians::delete_civs( "club_right", "script_noteworthy" );
	
	scene_wait( "club_encounter_player" );
	
	level thread maps\karma_civilians::delete_civs( "static_civ_flee", "targetname" );
}


club_enemies_think()
{
	self.ignoreall = true;
	self.ignoreme = true;
}


//
//	Civilians react when gunfire erupts
civs_scream()
{
	if ( !flag( "club_civs_scream" ) )
	{
		flag_set( "club_civs_scream" );
		
		ClientNotify( "ccs" );
	}
}


//###############################################################
//	TERRORIST LOGIC
//	The terrorists surrounding the dance floor
club_terrorist_think()
{
	self endon( "death" );
	self endon( "club_terrorists_alerted" );

	// Setup custom deathanims
	if ( IsDefined( self.animname ) )
	{
		switch( self.animname )
		{
		case "club_pmc4":
		case "club_pmc5":
		case "club_pmc6":
		case "club_pmc7":
		case "club_pmc8":
		case "club_pmc9":
		case "salazar_target1":
		case "player_target1":
			self set_deathanim( "death" );
			break;
		}
	}
	
	//TODO temp disable
//	self thread mark_as_target( "club_open_fire" );

	self disable_long_death();
	
	if ( !flag( "club_open_fire" ) )
	{
		self.goalradius = 8;
		self.script_radius = 8;	
		self.ignoreall = true;
		self.ignoreme = true;
		self.fixednode = true;
		
		self change_movemode( "cqb_walk" );
		flag_wait( "heroes_open_fire" );

		// PMCs 1-3 should be set to not die in karma_anim, so we need to do 
		//	this to counteract the settings activated in _scene.gsc. 
		//	PMCs 1,2 and 3 are invulnerable at the start of the scene so they aren't
		//  shot by the magicbullet squibs, but then the player gets control in the middle of
		//	their scene, so they need to switch to being killable here.
		self.allowdeath = true;
		self SetCanDamage( true );

		flag_wait( "club_open_fire" );
	}
	
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "toss_grenade" )
	{
		self grenade_toss();
	}
	
	// Let 'er rip!
//	self change_movemode( "sprint" );
	self.goalradius = 900;	
	self.script_radius = 900;
	self.ignoreall = false;
	self.ignoreme = false;
	self.fixednode = false;
	self.canFlank = true;
//	wait( RandomFloatRange( 4.0, 6.0 ) );
	self.aggressiveMode = true;
	self.script_accuracy = 0.1;

	if ( !IsDefined( self.target ) )
	{
		s_goal = GetStruct( "floor_goal", "targetname" );
		self SetGoalPos( s_goal.origin );
	}
	self change_movemode( "run" );
}


//
//	Make myself "marked" for greater visibility
mark_as_target( str_wait_flag  )
{
	self endon( "death" );

	if ( IsDefined( str_wait_flag ) )
	{
		flag_wait( str_wait_flag );
	}
	
	b_seen = false;
	while ( !b_seen )
	{
		if ( self CanSee( level.ai_salazar ) || self CanSee( level.player ) )
		{
			b_seen = true;
		}
		wait( RandomFloatRange( 0.5, 1.0 ) );
	}
	
	// Mark target
	Target_set( self );
//	self setClientFlag( CLIENT_FLAG_ENEMY_HIGHLIGHT );
//	self.deathfunction = maps\karma::turn_off_tresspasser;

	// Mark using Argus
//	self.n_argus_id = AddArgus( self, "marked_target" );
//	self thread unmark_target();
}


//
//	Remove the argus box when dead
unmark_target()
{
	self waittill( "death" );
	
	RemoveArgus( self.n_argus_id );	// causes issues when new things are added
}


//
//	Throw a grenade at the target point when you reach your goal.
grenade_toss()
{
	self endon( "death" );
	self endon( "damage" );
	
	self.goalradius = 8;
	self SetGoalPos( self.origin );
	wait( 6 );
	
	n_goal = GetNode( self.target, "targetname" );
	self force_goal( n_goal, 8 );

	// Send a magic grenade to the bar
	if ( level.player IsTouching( GetEnt( "trig_floor_bar", "targetname" ) ) )
	{
		v_start_pos = self.origin + (0,0,48);
		s_end_pos = GetStruct( "grenade_target", "targetname" );
		if ( IsAlive( self ) )
		{
			self MagicGrenade( v_start_pos, s_end_pos.origin, 7 );
		}
	}
}


//
//	Shoot up at the ceiling
ai_shoot_wildly()
{
	self endon( "death" );
	
//	self.ignoreall = false;

	// Pick a random target and shoot at it	
	a_fake_targets = GetEntArray( "enemy_fake_targets", "targetname" );
	e_fake = a_fake_targets[ randomint( a_fake_targets.size ) ];
	self thread shoot_at_target( e_fake, undefined, 0, 10 );
	wait( 8 );
	
	if ( !flag( "club_melee_started" ) )
	{
		flag_set( "club_terrorists_alerted" );
	}
}


//
//	Harper actions
harper_think()
{
	self.goalradius = 8;
	self.ignoreall = true;
	self.ignoreme = true;

	self gun_switchto( "fiveseven_sp", "right" );	// we'll need to make sure to switch to the right weapon

	// Wait for it to kick off
	scene_wait( "bar_fight_harper" );

	self.goalradius = 512;
	self SetGoalEntity( level.player );	// fight in this area
	self.ignoreall = false;
	self.ignoreme = false;
	self.script_accuracy = 2;
	wait( 2.0 );	// wait a sec for the scene to end so the weapon switch is less obvious

	// Toss a grenade
	e_target = GetEnt( "harper_grenade_target", "targetname" );
	self SetEntityTarget( e_target );
//	self.script_forceGrenade = 1;
//	wait( 8.0 );
//	
//	self.script_forceGrenade = 0;
	maps\_grenade_toss::force_grenade_toss( e_target.origin, "frag_grenade_sp", 2.0, undefined, "J_WristTwist_RI" );
	self ClearEntityTarget();
	
	wait( 10 );	// shoot for a little bit from behind the bar
	
	// Move out from behind the bar	
	self.fixednode = false;
	self.canFlank = true;
	self force_goal( GetNode( "n_harper_cub_fight_cover", "targetname" ), 8 );
	self SetGoalEntity( level.player );
	flag_wait( "counterterrorists_win" );
	
	// Temp directive	
	self force_goal( GetNode( "n_club_end_harper", "targetname" ), 8 );
}

//###############################################################
//	SALAZAR FUNCTIONS
//
// 	Salazar waits up top for the Player to mark two targets
//	Then he lines up and kills the first.
//	As the player ends his melee, Salazar shoots the second target.
//	Then he lines up the final shot for the meatshield
// 		self is Salazar
salazar_think()
{
	flag_wait( "club_door_closed" );

	self gun_switchto( "hk416_sp", "right" );	// we'll need to make sure to switch to the right weapon
	self change_movemode( "sprint" );
	self.ignoreall = true;
	self.ignoreme = true;
	self.ignoresuppression = true;
	self.goalradius = 8;
	self.script_accuracy = 2;
	wait( 0.5 );	// this is to make skiptos work properly

	s_salazar_eye = GetEnt( "sal_firing_pos", "targetname" );
	nd_salazar_goal = GetNode( s_salazar_eye.target, "targetname" );
	self ForceTeleport( nd_salazar_goal.origin, nd_salazar_goal.angles );
	self thread force_goal( nd_salazar_goal, 8 );
	
	flag_wait( "salazar_start_overwatch" );

//	level thread salazar_pip_on();

	// Wait until it's time to start shooting
//	flag_wait( "club_fight_start" );

	// Wait until the player draws weapons
	flag_wait( "heroes_open_fire" );

	self get_ai_targets( "club_target_salazar" );
	self kill_ai_target( self.a_ai_targets[0], 0.3, 0.2 );
	self kill_ai_target( self.a_ai_targets[1], 1.2, 0.2 );

	flag_wait( "club_open_fire" );

	// Clear some vars in case your target was killed prematurely
	self stop_shoot_at_target();
	self.a.allow_shooting = false;
	
	self.ignoreall = false;
	self.ignoreme = false;
	self.ignoresuppression = false;
	self.goalradius = 1500;
}


//
//	Get an ordered list of targets to kill
//	str_target_group - the base script_noteworthy tag to search for
get_ai_targets( str_target_group )
{
	i = 1;
	b_target_found = true;
	a_ai_array = GetAIArray( "axis" );
	self.a_ai_targets = [];
	while( b_target_found )
	{
		b_target_found = false;
		foreach( ai_guy in a_ai_array )
		{
			if ( IsDefined( ai_guy.script_noteworthy ) && ai_guy.script_noteworthy == str_target_group+i )
			{
				self.a_ai_targets[ self.a_ai_targets.size ] = ai_guy;
				b_target_found = true;
				break;
			}
		}
		i++;
	}
}


//
//	Aim at and kill the target
//		ai_target - the AI we're going to kill
//		n_traverse_time - how long it takes Salazar to get on target
//		n_aim_time - how long we need to aim
//		n_shoot_time - how long to shoot.  leave undefined for 1 shot
//	self is Salazar
kill_ai_target( ai_target, n_traverse_time = 0.5, n_aim_time = 1.0, n_shoot_time = 0.05 )
{
	self endon( "death" );

	if ( !IsAlive( ai_target ) )
	{
		return;
	}
	
	// Check if target is prematurely killed
	ai_target endon( "death" );
	
//	// Move to target
//	if ( self == level.ai_salazar )
//	{
//		self thread kill_ai_target_pip( ai_target, n_traverse_time, n_aim_time, n_shoot_time );
//	}
//
	// Kill the target
	ArrayRemoveValue( level.a_ai_club_terrorists, ai_target );
	self thread shoot_at_target(ai_target, "J_head", n_traverse_time + n_aim_time, n_shoot_time);
	wait( n_traverse_time + n_aim_time + n_shoot_time );
	
	// Sometimes the AI decides to not shoot, but we need a guaranteed kill
	if ( IsAlive( ai_target ) )
	{
		v_aim_point = ai_target GetTagOrigin( "J_head" );
		MagicBullet( self.weapon, self GetTagOrigin( "tag_flash" ), v_aim_point, self );
		wait( 0.1 );	// make sure the bullet hit

		// Failsafe check		
		if( IsAlive( ai_target ))
		{
			ai_target kill();
		}
	}
}

/*
//  Control the pip camera to simulate Salazar aiming
// self is salazar
kill_ai_target_pip( ai_target, n_traverse_time, n_aim_time, n_shoot_time )
{
//	clientNotify( "fov_zoom" );
	self thread aim_at_target( level.e_look_at_target, n_traverse_time );
	v_aim_point = ai_target GetTagOrigin( "J_head" );
	level.e_look_at_target MoveTo( v_aim_point, n_traverse_time );
	wait( n_traverse_time );	// 0.2 gives the camera time to catch up

	// Stay pointed at the head	
//	clientNotify( "fov_zoom_hi" );
	n_end_time = GetTime() + n_aim_time*1000;
	while ( GetTime() < n_end_time )
	{
		v_aim_point = ai_target GetTagOrigin( "J_head" );
		level.e_look_at_target MoveTo( v_aim_point, 0.2 );
		wait( 0.05 );	// This moves at a slower rate because 0.05 caused bad oscillation in the camera.
	}
	self stop_aim_at_target();
}
	
//
//	Turn on extra cam of Salazar's view
salazar_pip_on()
{
	// Stay with Salazar
	level.ai_salazar thread salazar_look_at_target();
	turn_on_extra_cam();
	wait( 0.5 );
	
	clientNotify( "fov_normal" );

	flag_wait( "club_fight_start" );
	flag_wait( "counterterrorists_win" );

	turn_off_extra_cam();
}


//
//	This controls what we want Salazar to look at
//	self is Salazar
salazar_look_at_target()
{
	self endon( "death" );
	self endon( "club_open_fire" );

	// Spawn the entity that we will use to simulate Salazar's look point
	t_dance_floor = GetEnt( "trig_dance_floor", "targetname" );
	level.e_look_at_target = Spawn( "script_origin", t_dance_floor.origin );
	self LookAtEntity( level.e_look_at_target );

	v_salazar_eyes = self GetEye();
	level.e_extra_cam.origin = v_salazar_eyes + (0,0,10);
	level.e_extra_cam.angles = self.angles;
	wait( 0.05 );
	
	// Keep moving with Salazar
	v_camera = GetEnt( "s_target_4", "targetname" );
	while( true )
	{
		v_lookat = level.e_look_at_target.origin - v_camera.origin;
		v_angle = VectorToAngles( VectorNormalize(v_lookat) );

		CONST n_time = 0.05;
		level.e_extra_cam MoveTo( v_camera.origin, n_time );
		level.e_extra_cam RotateTo( v_angle, n_time );
		level.e_extra_cam waittill( "movedone" );
	}
}
*/


//#########################################################
//	PLAYER ACTIONS


//
//	The player attacks from behind the bar
player_bar_fight()
{
	scene_wait( "bar_fight_player" );

	level.player DisableInvulnerability();
	flag_set( "draw_weapons" );

	// Lock player in place
	wait( 0.05 );	// let you pop out of the ground

	level.player player_stick( true, 30, 30, 35, 35 );

	flag_wait( "heroes_open_fire" );

	level thread lights_drop();
	
	wait( 0.05 );

	//	Let's do this!
	// face the first attacker
	// VectorDot will give us the angle between the direction of the attacker and the direction we're looking
	CONST N_TIME = 0.3;
	ai_target = get_ai( "club_target_player1", "script_noteworthy" );
	v_to_target = VectorNormalize( ai_target.origin - level.player.origin );
	v_player_angle = level.player GetPlayerAngles();
	v_player_angle = ( 0, v_player_angle[1], 0 );
	n_dot = VectorDot( AnglesToForward( v_player_angle ), v_to_target );
	n_yaw = acos( n_dot ) - 20;	//haxxor try to keep the bar smash guy in frame
	level.player.m_link RotateYaw( n_yaw, N_TIME, 0.2, 0.1 );
	wait( N_TIME - 0.2 );
	
	level.player AllowStand( true );
	level.player SetStance( "stand" );

	wait( 0.2 );
	level.player player_unstick();
	flag_set( "player_act_normally" );
	flag_set( "club_open_fire" );
}


lights_drop()
{
	level notify( "fxanim_club_laser_2_fall_start" );
	wait( 1.0 );
	
	level notify( "fxanim_club_laser_1_fall_start" );
	wait( 2.0 );
	
	level notify( "fxanim_club_laser_4_fall_start" );
}


////
////	Follow a bullet as it travels to its target
////	self is the player
//bullet_cam_sequence( ai_target )
//{
//	ai_target notify( "stop_shoot_at_target" );
//	ai_target thread aim_at_target( self );
//
//	// Black out to hide the magic
//	screen_fade_out( 0 );
//
//	thread turn_off_extra_cam();
//	self hide_hud();
//
//	// Calculate a few things
//	v_eye_pos = self GetEye();
//	v_direction = AnglesToForward(self.angles);
//
//	// Spawn the barrel a little in front of the player
//	v_origin = v_eye_pos + ( v_direction * 15 );
//	m_barrel = Spawn( "script_model", v_origin );
//	m_barrel.angles = self.angles;
//	m_barrel SetModel( "p6_gun_barrel" );
//	m_barrel SetScale( 0.35 );
//
//	// Spawn the bullet X units in front of the camera
//	v_origin = v_eye_pos + ( v_direction * 6 );
//	m_bullet = Spawn( "script_model", v_origin );
//	m_bullet.angles = self.angles;
//	m_bullet SetModel( "anim_glo_bullet_tip" );
//	m_bullet.animname = "bullet";
//
//	// This origin is what the bullet links to so I can move it while it spins
//	m_bullet_origin = Spawn( "script_model", v_origin );
//	m_bullet_origin SetModel( "tag_origin" );
//	m_bullet_origin.angles = self.angles;
//
//	m_bullet LinkTo( m_bullet_origin, "tag_origin" );
//
//	// Spawn the Camera link
//	//	If I try to link directly to the m_bullet_origin, 
//	//	it will link my origin to the tag_origin.  =(
//	s_camera = Spawn( "script_origin", self.origin );
//	s_camera.angles = self.angles;
//	s_camera LinkTo( m_bullet_origin );
//
//	// Prep the player
//	v_player_start = self.origin;
//	self FreezeControls( true );
//	self PlayerLinkToAbsolute( s_camera );
//	self DisableWeapons();
//	self HideViewModel();
//
//	//	sounds for bullet time
//	level.player StopLoopSound(1);
//	clientnotify ("turn_on_bullet_snapshot");
//	level.player PlaySound ( "evt_solar_slow_bullet" );
//	
//	// Slow down time
//	SetTimeScale( 0.20 );
//
//	// Adjust FOV
//	n_basefov = GetDvarfloat( "cg_fov" );
//	self SetClientDvar( "cg_fov", 15 );
//
//	// Slow fade in
//	screen_fade_in( .15 );
//	PlayFXOnTag( level._effect["bullet_time_muzzle_flash"], m_bullet_origin, "tag_origin" );
//
//	// Ramp up the bullet within the "barrel"
//	level thread run_scene_and_delete( "bullet_time_bullet_spin_start" );
//	n_time = GetAnimLength( %animated_props::o_karma_6_6_bullettime_bullet_ramp_spin );	// it's about 1 sec
//	v_dest = m_bullet.origin + ( v_direction * 20 );
//	m_bullet_origin MoveTo( v_dest, n_time, n_time );
//
//	thread lerp_fov_overtime( n_time, 20, false );
//	wait( n_time );
//	
//	self SetClientDvar( "cg_fov", 20 );
//
//	// Move the bullet to the point of impact on the target
//	// Slow down to super slow time
//	n_time_scale = 0.06;
//	SetTimeScale( n_time_scale );
//	n_time = 0.2;
//	level thread run_scene_and_delete( "bullet_time_bullet_spin" );
//	m_bullet_origin MoveTo( ai_target.v_point_of_impact, n_time );
//
//	// Warp speed!
////	thread lerp_fov_overtime( n_time, n_basefov, false );
//	m_bullet_origin waittill( "movedone" );
//
//	// Cut back to normal
//	self SetClientDvar( "cg_fov", n_basefov );
//	end_scene( "bullet_time_bullet_spin" );
//	clientnotify ("turn_off_bullet_snapshot");
//	level.player Playsound ("evt_solar_slow_bullet_hit");
//	
//	// Actually kill the guy
//	ai_target stop_magic_bullet_shield();
//	ai_target.health = 1;
//	v_start = ai_target.v_point_of_impact - v_direction;	// 1 unit back from the point of impact.
//	MagicBullet( "tar21_sp", v_eye_pos, ai_target.v_point_of_impact, self );
//	ai_target DoDamage( ai_target.health, v_origin, self, self );
//	
//	self FreezeControls( false );
//	self Unlink();
//	self SetOrigin( v_player_start );
//	self EnableWeapons();
//	self ShowViewModel();
//	self hide_hud();
//	
//	thread timescale_tween( n_time_scale, 1.0, 1.0, 0.0, 0.05 );
//	
//	// Sweep it up
//	m_barrel Delete();
//	m_bullet_origin Delete();
//	m_bullet Delete();
//	s_camera Delete();	
//
//	self SetClientDvar( "cg_fov", n_basefov );
//	turn_on_extra_cam();
//}


//
//	Delete anything in the club
club_cleanup()
{
	cleanup_ents( "club" );
}

//
//	Save any data we need to know about for the next mission
karma_2_transition()
{
	wait( 6 );	// let the AI die before fading out.  Don't make it feel so automatic.
	
	level clientnotify( "sndFadeOut" );
	
	screen_fade_out( 3 );	// nice slow fade

	flag_wait( "exit_club" );
	nextmission();
}



/////////////////////////////////////////////////////////////////////
//	D I A L O G
/////////////////////////////////////////////////////////////////////

//
//	Player dialog during PIP
//	self is the player
inner_club_dialog()
{
	flag_wait( "counterterrorists_win" );

	self say_dialog("sect_defalco_has_karma_w_0", 1.0);		//DeFalco has Karma! We're in pursuit.
    self say_dialog("sect_we_need_you_to_track_0");			//We need you to track their movements, Farid - we can't let them get off the ship!
    
	flag_set( "exit_club" );
}
