#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_vehicle;
#include maps\yemen_utility;
#include maps\_anim;
#include maps\_dialog;
#include maps\_drones;
#include maps\_objectives;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "show_introscreen_title" );
	flag_init( "speech_fadein_starting" );
	flag_init( "speech_start_vtol" );
	flag_init( "player_turn" );
	flag_init( "menendez_grabs_player" );
	flag_init( "player_turns_back" );
	flag_init( "menendez_exited" );
}


//
//	event-specific spawn functions
init_spawn_funcs()
{
	add_spawn_function_group( "menendez_speech", "targetname", ::spawn_func_menendez );
}

spawn_func_menendez()
{
	level.menendez = self;
}

init_doors()
{
	e_exit_door = GetEnt( "menendez_exit_door", "targetname" );
	e_exit_door_collision = GetEnt( e_exit_door.target, "targetname" );
	e_exit_door_collision LinkTo( e_exit_door );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_intro()
{
}

skipto_speech()
{
	skipto_teleport( "skipto_speech" );
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
intro_main()
{
/#
	IPrintLn( "Intro" );
#/
		
	level thread speech_fade_in();
	
	load_gump( "yemen_gump_speech" );
	
	yemen_speech_setup();
	menendez_intro();
}

speech_main()
{
/#
	IPrintLn( "Speech" );
#/
		
	menendez_speech();
	level thread speech_vtols_arrive();
	level thread speech_menendez_quad_targets();
	
	level thread speech_clean_up();
}

speech_fade_in()
{
	screen_fade_out( 0 );
	flag_wait( "speech_fadein_starting" );
	level thread screen_fade_in( .5 );
}

yemen_speech_setup()
{
	run_scene_first_frame( "speech_player_intro" );
	run_scene_first_frame( "speech_opendoors_doors" );
	//level.player TakeAllWeapons();
	
	exploder( 1000 );
	exploder( 1010 );
	maps\createart\yemen_art::menendez_intro();
	
	maps\_vehicle::vehicle_add_main_callback( "heli_quadrotor", maps\yemen_utility::yemen_quadrotor_indicator );
	maps\_vehicle::vehicle_add_main_callback( "drone_firestorm", maps\yemen_utility::yemen_metalstorm_indicator );
	maps\_vehicle::vehicle_add_main_callback( "drone_metalstorm", maps\yemen_utility::yemen_metalstorm_indicator );
}

speech_clean_up()
{
	trigger_wait( "speech_clean_up" );
	
	/*
	a_terrorists = GetEntArray( "court_terrorists_ai", "targetname" );
	array_delete( a_terrorists );
	
	a_drones = GetEntArray( "court_drone", "script_noteworthy" );	
	array_delete( a_drones );	
	
	a_speech_structs = GetStructArray( "speech_crowd_center", "targetname" );
	array_delete( a_speech_structs, true );
	*/

	delete_models_from_scene( "vtols_arrive_stage_guards" );
	delete_models_from_scene( "stage_backup_guards" );
	
	delete_scene( "vtols_arrive_stage_guards", true );
	delete_scene( "stage_backup_guards", true );
}

/* ------------------------------------------------------------------------------------------
	Menendez Intro
-------------------------------------------------------------------------------------------*/

menendez_intro()
{
	level thread vo_menendez_intro();
	
	setmusicstate ("YEMEN_INTRO");
	
	run_scene_first_frame( "speech_menendez_intro" );
	
	level.menendez = get_ai( "menendez_speech_ai", "targetname" );
	level.menendez.team = "allies";
	level.menendez.name = "";	// Don't display his name.  It's distracting during the scene when it pops on and off.
	
	flag_wait( "speech_fadein_starting" );
	
	level thread menendez_intro_hallway();
	
	level thread run_player_intro();	
	run_scene_and_delete( "speech_menendez_intro" );
	//run_scene( "speech_menendez_intro_tiein" );
	
	run_scene_and_delete( "speech_menendez_walk_hallway" );
	
	
	level thread run_scene_and_delete( "speech_menendez_hallway_endidle" );
}

run_player_intro()
{
	run_scene_and_delete( "speech_player_intro" );
	menendez_intro_player_setup();
}

menendez_intro_hallway()
{
	menendez_intro_fans();
	level thread menendez_greeters_animate( "speech_greeter_intro_1" );
	level thread menendez_greeters_animate( "speech_greeter_intro_2" );
	
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_a" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_b" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_c" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_d" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_e" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_f" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_g" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_h" );
	level thread menendez_intro_hallway_animate_group( "speech_intro_salute_i" );
	
	level waittill( "start_hallway_actors" );
	wait 7;
	flag_set( "show_introscreen_title" );	// start titlescreen at the same time
}

menendez_intro_hallway_animate_group( str_scene )
{
	run_scene_first_frame( str_scene );
	
	level waittill( "start_hallway_guards" );
	
	level thread run_scene_and_delete( str_scene );
	
	if ( str_scene != "speech_intro_salute_c" && 
	    str_scene != "speech_intro_salute_g" &&
	    str_scene != "speech_intro_salute_h" &&
		str_scene != "speech_intro_salute_i" )
	{
		maps\yemen_utility::give_scene_models_guns( str_scene );
	}
	
	scene_wait( str_scene );
	level thread run_scene_and_delete( str_scene + "_endloop" );
	
	level waittill( "cleanup_hallway" );
	
	// in case the player was facing backwards.
	wait 0.5;
	
	end_scene( str_scene + "_endloop" );
}

menendez_greeters_animate( str_scene )
{
	level thread run_scene_and_delete( str_scene );
	
	scene_wait( str_scene );
	level thread run_scene_and_delete( str_scene + "_endloop" );
	
	level waittill( "cleanup_hallway" );
	
	// in case the player was facing backwards.
	wait 0.5;
	
	end_scene( str_scene + "_endloop" );
}

menendez_intro_cleanup()
{
	delete_models_from_scene( "menendez_intro_doors" );
	run_scene_first_frame( "speech_opendoors_doors" );	// put doors back in place
	level notify( "fxanim_seagull01_delete" );
	
	// Allow the scene data to be released into the ether.
	wait_network_frame();
	end_scene( "speech_opendoors_doors" );
	delete_scene( "speech_opendoors_doors", true );
}

menendez_intro_fans()
{
	fans = GetEntArray( "intro_fan", "targetname" );
	array_thread( fans, ::rotate_continuously, 1.0, "cleanup_hallway" );
}

menendez_intro_opendoors( guy )
{
	run_scene_and_delete( "menendez_intro_doors" );
}

menendez_speech_opendoors( guy )
{
	// don't delete scene--we need the doors to shut using the same animation.
	run_scene( "speech_opendoors_doors" );
}

menendez_exit_opendoors( guy )
{
	run_scene_and_delete( "menendez_exit_doors" );
}

menendez_intro_unlink_player( guy )
{
	while ( Length( level.player GetNormalizedMovement() ) < .5 )
	{
		wait 0.05;	
	}
	
	if ( !flag( "speech_player_intro_done" ) )
	{
		end_scene( "speech_player_intro" );
	}
	
	set_objective( level.OBJ_SPEECH, level.menendez, "follow" );
}

/* ------------------------------------------------------------------------------------------
	Speech
-------------------------------------------------------------------------------------------*/

menendez_speech()
{
	trigger_wait( "stage_door_open" );
	
	level thread maps\_audio::switch_music_wait ("YEMEN_DOOR_OPENED", 1);
	
	level notify( "cleanup_hallway" );
	
	level.player ClientNotify( "speech_spawn_crowd" );
	
	//MENENDEZ OPENS DOORS
	level clientNotify("snd_swell_start");

	level thread speech_stage_guards();
	
	if( level.is_defalco_alive )
	{
		level thread menendez_speech_defalco();
		level thread run_scene_and_delete( "speech_walk_with_defalco" );
	}
	else
	{
		level thread run_scene_and_delete( "speech_walk_no_defalco" );
	}
	level thread menendez_speech_player();
	
	wait_network_frame();
	level.menendez custom_ai_weapon_loadout( "judge_sp" );
	
	maps\createart\yemen_art::large_crowd();

	flag_wait( "speech_start_vtol" );
	
	set_objective( level.OBJ_SPEECH, undefined, "done" );
	
	level thread menendez_intro_cleanup();
}

menendez_speech_player()
{
	level.player EnableInvulnerability();
	if ( level.is_defalco_alive )
	{
		run_scene_and_delete( "speech_walk_with_defalco_player" );
	}
	else
	{
		run_scene_and_delete( "speech_walk_no_defalco_player" );
	}
	level.player DisableInvulnerability();
	menendez_speech_done_player_setup();
}

menendez_speech_defalco()
{
	level thread run_scene_and_delete( "speech_walk_with_defalco_defalco" );
	wait_network_frame();
	
	ai_defalco = GetEnt( "defalco_speech_ai", "targetname" );
	ai_defalco magic_bullet_shield();
	
	scene_wait( "speech_walk_with_defalco_defalco" );
	
	level thread run_scene_and_delete( "speech_defalco_endidl" );
}

menendez_intro_player_setup()
{
	level.player DisableWeapons();
	level.player SetMoveSpeedScale( .35 );
	level.player AllowSprint( false );
	level.player AllowJump( false );
}

menendez_speech_done_player_setup()
{
	level.menendez.name = "Menendez";
	level.player EnableWeapons();	
	level.player SetMoveSpeedScale( 1 );
	level.player AllowSprint( true );
	level.player AllowJump( true );
}

/* ------------------------------------------------------------------------------------------
	VTOL Entrance
-------------------------------------------------------------------------------------------*/

speech_stage_guards()
{
	level thread run_scene_and_delete( "speech_walk_stage_guards" );
	maps\yemen_utility::give_scene_models_guns( "speech_walk_stage_guards" );
	
	level waittill( "speech_backup_spawn" );
	
	level thread run_scene( "stage_backup_guards" );
	maps\yemen_utility::give_scene_models_guns( "stage_backup_guards" );
	
	wait_network_frame();
	
	give_stage_drones_collision();
	
	level waittill( "vtols_arrived" );
	level thread run_scene( "vtols_arrive_stage_guards" );
	
	//Audio ClientNotify for setting low ambience snapshot
	level ClientNotify ("mbs");
}

// Helps us determine which quadrotor each of Mz's shots hits.
//
speech_menendez_quad_kill_counter()
{
	level endon( "menendez_exited" );
	
	level.m_quads_killed_by_mz = 0;
	while ( true )
	{
		level waittill( "menendez_fire" );
		wait 0.2;
		level.m_quads_killed_by_mz++;
	}
}

speech_menendez_quad_run( quad_num )
{
	self endon( "death" );
	self veh_magic_bullet_shield( true );
	
	do {
		level waittill( "menendez_fire" );
	} while ( level.m_quads_killed_by_mz != quad_num );
	
	self veh_magic_bullet_shield( false );
	self DoDamage( self.health * 2, self.origin );
}

speech_menendez_quad_targets()
{
	level thread speech_menendez_quad_kill_counter();
	drone_names = array( "menendez_kill_drone_01", "menendez_kill_drone_02", "menendez_kill_drone_03" );
	drone_delays = array( 12.0, 4.0, 1.0 );
	assert( drone_names.size == drone_delays.size );
	
	for ( i = 0; i < drone_names.size; i++ )
	{
		wait drone_delays[i];
		v_rotor = spawn_vehicle_from_targetname_and_drive( drone_names[i] );
		v_rotor thread speech_menendez_quad_run(i);
	}
}

speech_vtols_arrive()
{
	level notify( "vtols_arrived" );
	
	level thread speech_vtol();
	
	veh_pre_speech_vtol = spawn_vehicle_from_targetname_and_drive( "speech_pre_vtol" );
	veh_pre_speech_vtol SetForceNoCull();

	wait 3;	// TODO: replace with notetrack

	if( level.is_defalco_alive )
	{
		level thread run_scene_and_delete( "vtols_arrive_defalco" );
		scene_wait( "speech_walk_with_defalco" );
	}
	else
	{
		scene_wait( "speech_walk_no_defalco" );
	}
	
	flag_set( "menendez_exited" );
}

// have the player set to ignore for a bit, unless the player engages any enemy
speech_vtol()
{
	wait 1.8;
	
	nd_vtol_stop_spot = getstruct( "speech_vtol_stop", "script_noteworthy" );
	
	exploder( 27 );
	
	level delay_thread( 1.5, maps\yemen_market::speech_quads );
	
	veh_vtol = spawn_vehicle_from_targetname( "speech_vtol" );
	veh_vtol.takedamage = false;
	veh_vtol SetForceNoCull();
	veh_vtol SetVehGoalPos( nd_vtol_stop_spot.origin, 1 );
	veh_vtol waittill( "goal" );
	//veh_vtol maps\_turret::enable_turret( 0 );
	veh_vtol thread maps\_turret::fire_turret_for_time( 3, 0 );
	
	wait 0.5;
	
	MagicBullet( "rpg_magic_bullet_sp", getstruct( "speech_rpg_start" ).origin, veh_vtol.origin - ( 0, 0, 32 ) );
	wait .2;
	MagicBullet( "rpg_magic_bullet_sp", getstruct( "speech_rpg_start" ).origin, veh_vtol.origin - ( 0, 50, -50 ) );
//	wait .2;
//	MagicBullet( "rpg_magic_bullet_sp", getstruct( "speech_rpg_start" ).origin, veh_vtol.origin - ( 0, -50, 50 ) );
	
	wait 1.2;
	
	stop_exploder( 27 );
	run_scene_and_delete( "speech_vtol_crash" );
}

player_turn( m_player )
{
	//Eckert turn off crowd sounds
	level ClientNotify("speech_done");
	level.player ClientNotify( "delete_crowd" );
	wait_network_frame();
	flag_set( "player_turn" );
}

menendez_grabs_player( m_player )
{
	flag_set( "menendez_grabs_player" );
}

player_turns_back( m_player )
{
	flag_set( "player_turns_back" );
}

give_stage_drones_collision()
{
	collision_list = GetEntArray( "stage_drone_collision", "targetname" );
	drone_list_1 = get_model_or_models_from_scene( "speech_walk_stage_guards" );
	drone_list_2 = get_model_or_models_from_scene( "stage_backup_guards" );
	full_drone_list = ArrayCombine( drone_list_1, drone_list_2, true, false );
	
	for ( i = 0; i < full_drone_list.size && i < collision_list.size; i++ )
	{
		drone = full_drone_list[i];
		collision = collision_list[i];
		collision.origin = drone GetTagOrigin( "tag_origin" );
		collision LinkTo( drone, "tag_origin" );
		drone.m_collision = collision;
	}
}

drone_remove_collision( drone )
{
	if ( isdefined( drone.m_collision ) )
	{
		drone.m_collision Delete();
		drone.m_collision = undefined;
	}
}

/* ------------------------------------------------------------------------------------------
	VO functions
-------------------------------------------------------------------------------------------*/
vo_menendez_intro()
{
	wait 0.5;
	level.player say_dialog( "harp_egghead_you_copy_0" );			//Egghead.  You copy?
	level.player say_dialog( "fari_i_copy_harper_0" );				//I copy, Harper.
	flag_set( "speech_fadein_starting" );

	wait 10;
	level notify( "start_hallway_actors" );
}
