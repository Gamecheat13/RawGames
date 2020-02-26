#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_dialog;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "morals_start" );
	flag_init( "harper_shot" );
	flag_init( "menendez_shot" );
}


//
//	event-specific spawn functions
init_spawn_funcs()
{

}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_morals()
{
	load_gump( "yemen_gump_morals" );
	
	skipto_teleport( "skipto_morals_player" );
	
	//trigger_wait( "start_morals" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Morals" );
#/
	flag_set( "morals_start" );
	end_market_vo();
	
	level clientnotify( "yemen_disable_sonar" );	// turn off now due to multiple conditions
	
	level thread clean_up_behind();
	
	level thread morals_setup();
	
	trigger_wait( "start_morals" );
	

	
	//Waiting until Menendez blows up the vtol
	level thread maps\_audio::switch_music_wait("YEMEN_HARPER_DECISION", 24);
	
	level thread morals_call_farid();
	
	trigger_wait( "morals_at_menendez" );
	
	//Ducking gunfire\explosions for this scene.
	level ClientNotify ("morals");
	
	shoot_down_vtol();
	vtol_approach();
	morals_choice_outcome();
	morals_mason_intro();
	
	morals_clean_up();
}

clean_up_behind()
{
	cleanup( "metal_storms_wounded", "script_noteworthy" );
}

morals_setup()
{	
	exploder( 2000 );	// fire/fast wind fx
	
	level thread maps\yemen_anim::morals_anims();
	
	level.hammer_audio_limiter = false;
	level thread maps\yemen_amb::yemen_drone_control_tones( false );
	vehicle_add_main_callback( "heli_quadrotor", maps\_quadrotor::quadrotor_think );	// stop the indicator on the quadrotors
	
	maps\yemen_metal_storms::metal_storms_cleanup();
	
	level.player SetLowReady( true );
	
	morals_vtol_setup();
	level thread morals_intro_ambient();
	
	//starting fake battle sounds
	level thread fake_combat_sounds();
	
	level thread run_scene( "morals_menendez_wait" );
	wait 0.1;
	ai_menendez = get_ai( "menendez_morals_ai", "targetname" );
	ai_menendez gun_switchto( "fhj18_sp", "right" );
	ai_menendez set_ignoreme( true );
	ai_menendez set_blend_in_out_times( 0.2 );
	ai_menendez.team = "allies";
}

morals_intro_ambient()
{
	vh_vtol = GetEnt( "morals_vtol_1", "targetname" );
	a_sp_terrorists = GetEntArray( "pre_morals_terrorist", "targetname" );
	
	foreach ( spawner in a_sp_terrorists )
	{
		guy = simple_spawn_single( spawner, maps\yemen_utility::terrorist_teamswitch_spawnfunc );
		guy magic_bullet_shield();
		guy set_ignoreall( true );
		guy thread shoot_at_target( vh_vtol, undefined, RandomFloatRange(0.5, 2), -1 );
	}	
	
	a_qrotors = spawn_quadrotors_at_structs( "morals_ambient_drone_spot" );
	foreach( vh_qrotor in a_qrotors )
	{
		vh_qrotor.goalradius = 128;
		vh_qrotor veh_magic_bullet_shield( true );
		vh_qrotor.targetname = "morals_qrotor";
	}	
	
	trigger_wait( "morals_look_through_door" );
	
	a_qrotors = spawn_vehicles_from_targetname_and_drive( "morals_passby_qrotor" );
	foreach( vh_qrotor in a_qrotors )
	{
		vh_qrotor.goalradius = 128;
		vh_qrotor veh_magic_bullet_shield( true );
		vh_qrotor.targetname = "morals_qrotor";
	}		
	
	ai_guy = simple_spawn_single( "pre_morals_terrorist_runover", maps\yemen_utility::terrorist_teamswitch_spawnfunc, undefined, undefined, undefined, undefined, undefined, true );
	ai_guy magic_bullet_shield();
}

morals_clean_up()
{
	// give the player his starting weapon
	w_primary = GetLoadoutItem( "primary" );
	w_secondary = GetLoadoutItem( "secondary" );
	
	level.player GiveWeapon( w_primary );
	level.player GiveWeapon( w_secondary );
	level.player GiveWeapon( "knife_sp" );
	level.player GiveWeapon( "frag_grenade_sp" );
	level.player SwitchToWeapon( w_secondary );	
	level.player SetLowReady( false );
	a_weapons = level.player GetWeaponsList();
	
	level.player SwitchToWeapon( w_primary );
	
	switch_player_to_mason();
	
	// flush_gump();
	
	SetSavedDvar( "aim_target_ignore_team_checking", 0 );
}

set_blend_in_out_times( time )
{
	self anim_set_blend_in_time( time );
	self anim_set_blend_out_time( time );
}

/* ------------------------------------------------------------------------------------------
	VTOL Shoot functions
-------------------------------------------------------------------------------------------*/

morals_call_farid()
{
	run_scene( "morals_menendez_call_farid" );
	level thread run_scene( "morals_menendez_call_farid_idle" );
}


morals_vtol_setup()
{	
	vh_vtol = spawn_vehicle_from_targetname( "morals_vtol_1" );	
	vh_vtol veh_magic_bullet_shield( true );
	vh_vtol SetVehGoalPos( vh_vtol.origin, 1 );
	
}

morals_ambient_qrotor_delete()
{
	
}

/* ------------------------------------------------------------------------------------------
	VTOL Wreck functions
-------------------------------------------------------------------------------------------*/

shoot_down_vtol()
{	
	level thread run_scene( "morals_shoot_vtol", 0.2 );
		
	wait 1;
	m_player_body = get_model_or_models_from_scene( "morals_shoot_vtol", "player_body" );
	m_player_body SetForceNoCull();
	m_player_body set_blend_in_out_times( 0.2 );
	
	scene_wait( "morals_shoot_vtol" );
	
	// switch which FX are being played here
	stop_exploder( 2000 );
	exploder( 2100 );
}

morals_shoot_vtol_fire_rocket( ai_guy )	// called from notetrack, self = menendez
{
	playsoundatposition ("wpn_rpg_fire_plr", (0,0,0));
	vh_vtol = GetEnt( "morals_vtol_1", "targetname" );
	
	level notify( "fxanim_vtol2_crash_start" );
	level thread run_scene( "morals_vtol_crashing", 0.5 );

	playsoundatposition ("fxa_vtol2_crash", (0,0,0));
//	vh_vtol Delete();	

	wait .2;
//	vh_vtol = get_model_or_models_from_scene( "morals_vtol_crashing", "morals_vtol" );
	turn_off_vehicle_exhaust( vh_vtol );
	turn_off_vehicle_tread_fx( vh_vtol );
	// PlayFXOnTag( GetFX( "crashing_vtol" ), vh_vtol, "tag_origin" );
	PlayFXOnTag( level._effect[ "explosion_midair_heli" ], vh_vtol, "tag_origin" );
	
	scene_wait( "morals_vtol_crashing" );
	vh_vtol vehicle_toggle_sounds(0);
	
	m_linker = spawn_model( "tag_origin", vh_vtol.origin, vh_vtol.angles );
	vh_vtol LinkTo( m_linker, "tag_origin" );
}

/* ------------------------------------------------------------------------------------------
	Harper Captured
-------------------------------------------------------------------------------------------*/

vtol_approach()
{
	level thread vtol_approach_ambient_guys();

	ai_menendez = get_ai( "menendez_morals_ai", "targetname" );
	ai_menendez gun_switchto( "judge_sp", "right" );
	
	run_scene( "morals_capture_approach" );
	
	level thread run_scene( "morals_capture" );
	
	ai_menendez = get_ai( "menendez_morals_ai", "targetname" );
	ai_menendez gun_switchto( "judge_sp", "right" );
	
	level waittill_either( "harper_shot", "menendez_shot" );
	
	screen_message_delete();
}

vtol_approach_ambient_guys()
{
	level thread run_scene( "morals_execution_pilot" );
	
	//Cleanup VTOL shooters
	a_ai_morals_shooters = get_ai_array( "pre_morals_terrorist_ai", "targetname" );
	array_delete( a_ai_morals_shooters );
	a_ai_morals_runners = get_ai_array( "pre_morals_terrorist_runover_ai", "targetname" );
	array_delete( a_ai_morals_runners );
	a_sp_morals_shooters = get_ent_array( "pre_morals_terrorist", "targetname" );
	array_delete( a_sp_morals_shooters );
	a_qrotors = GetEntArray( "morals_qrotor", "targetname" );
	array_thread( a_qrotors, ::qrotor_delete );
}

qrotor_delete()
{
	VEHICLE_DELETE( self );
}

morals_capture_start_choice( player )	// called from notetrack, self = player
{
	level endon( "menendez_shot" );
	level endon( "harper_shot" );
	
	level.player thread watch_shoot_harper(); //-- handles all the extra setup that is involved in the same moment
	level.player thread watch_shoot_menendez();	
	
	scene_wait( "morals_capture" );
	flag_set( "menendez_shot" );
}

//self == player
watch_shoot_harper()
{
	level endon( "morals_rail_start" );// SkyS. - was still listening for input when next section started if no action taken
	level endon("menendez_shot");
	
	screen_message_create( &"YEMEN_SHOOT_HARPER", &"YEMEN_SHOOT_MENENDEZ", undefined, -80 );
	
	//-- menendez shoots you if you take too long
//	level thread aim_at_harper_fail_timer( m_anim_body );
	
	while(!self throwButtonPressed())
	{
		wait .05;	
	}
	
	flag_set( "harper_shot" );
	
	setmusicstate( "YEMEN_HARPER_HARPER_DIED" );

	level notify ("harper_shot_complete");
}

//self == player
watch_shoot_menendez()
{
	level endon("harper_shot");
	level endon("morals_rail_start"); // SkyS. - if no action taken this function still listens for attack button pressed
	
	while(!self attackButtonPressed())
	{
		wait .05;	
	}
	
	flag_set( "menendez_shot" );
	
	setmusicstate ("YEMEN_HARPER_FARID_DIED");

	level notify("menendez_shot_complete");
}

/* ------------------------------------------------------------------------------------------
	Player Pulled Trigger
-------------------------------------------------------------------------------------------*/

morals_choice_outcome()
{
	if ( flag( "harper_shot" ) )
	{
		level.is_farid_alive = true;
		
		level thread run_scene( "morals_shoot_harper" );
		level thread morals_shoot_harper_spawn_vtol();
		wait ( GetAnimLength( %player::p_yemen_05_04_shoot_harper_player ) - 2 );	// wait until 2 seconds before the anim ends
		screen_fade_out(2.0);
		run_scene_first_frame( "morals_outcome_farid_lives" );
		m_body = get_model_or_models_from_scene( "morals_outcome_farid_lives", "player_body" );
		m_body Hide();
	}
	else
	{
		level.is_farid_alive = false;
		
		level thread run_scene( "morals_shoot_menendez" );
		
		wait ( GetAnimLength( %player::p_yemen_05_04_shoot_menendez_player ) - .25 );	// wait until 2 seconds before the anim ends
		screen_fade_out(0.0);
		wait 1;
	}
	
	level ClientNotify ("mbs");
}

morals_shoot_harper_spawn_vtol( )
{
	level thread run_scene( "morals_shoot_harper_vtol" );
	wait 0.1;
	m_vtol = get_model_or_models_from_scene( "morals_shoot_harper_vtol", "morals_shoot_harper_vtol" );
	m_rocket = get_model_or_models_from_scene( "morals_shoot_harper_vtol", "morals_shoot_harper_rocket" );
	
	m_vtol SetForceNoCull();
	m_rocket SetForceNoCull();
	
	PlayFXOnTag( GetFX( "morals_rocket_trail" ), m_rocket, "tag_fx" );
	
	scene_wait( "morals_shoot_harper_vtol" );
}

morals_shoot_harper_explosion( m_player ) 
{
	m_rocket = get_model_or_models_from_scene( "morals_shoot_harper_vtol", "morals_shoot_harper_rocket" );
	PlayFXOnTag( GetFX( "morals_rocket_exp" ), m_rocket, "tag_fx" );
}

/* ------------------------------------------------------------------------------------------
	Mason Intro
-------------------------------------------------------------------------------------------*/

morals_mason_intro()
{
	if ( flag( "harper_shot" ) )
	{
		wait(2);
		
		level thread screen_fade_in(2);

		run_scene( "morals_outcome_farid_lives" );
		wait .1;
		
//		level thread run_scene( "morals_execution_harper_dies_others" );
//		run_scene( "morals_execution_harper_dies" );
	}
}


fake_combat_sounds()
{
	
	canned_combat_1 = spawn ( "script_origin" , (-4915, -4479, 455));
	canned_combat_2 = spawn ( "script_origin" , (-4995, -5589, 572));
	
	canned_combat_1 playloopsound ( "amb_canned_battle_l");
	canned_combat_2 playloopsound ( "amb_canned_battle_r");	
}
