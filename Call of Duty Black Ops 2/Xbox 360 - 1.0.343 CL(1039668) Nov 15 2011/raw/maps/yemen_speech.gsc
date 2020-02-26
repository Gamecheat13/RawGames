#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	
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
skipto_speech()
{
	skipto_setup();
	
	start_teleport( "skipto_speech_player" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Speech" );
#/

	yemen_speech_setup();
		
	intro_prayer();
	menendez_intro();
	menendez_speech();
	
	yemen_speech_clean_up();
}

yemen_speech_setup()
{
	level.player DisableWeapons();
}

yemen_speech_clean_up()
{
	level.player EnableWeapons();
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

intro_prayer()
{
	level endon( "prayer_cleanup" );
	
	const n_prayer_group_count = 4;
	const n_prayer_helper_group_id = 5;
	const n_speak_time = 3;
	
	run_scene_first_frame( "speech_prayer" );
	run_scene_first_frame( "speech_prayer_player" );
	
	//TODO: wait here for fade to finish
	
	// TODO: change these idle anims to just one scene, need anim support
	level thread run_scene( "speech_amb_idle_01" );
	level thread run_scene( "speech_amb_idle_02" );
	level thread run_scene( "speech_amb_idle_03" );
	
	level thread run_scene( "speech_prayer" );
	level thread run_scene( "speech_prayer_player" );
	
	// TODO: Change this to a notetrack
	n_anim_length = GetAnimLength( %player::p_yemen_01_01_prayer_player_praying );
	wait n_anim_length - n_speak_time;
	iprintln( "Terrorist: Farid, Menendez is waiting for you" );
	wait n_speak_time;
	
	run_scene( "speech_he_is_waiting" );
	level thread run_scene( "speech_amb_idle_05" );
}

// play all ambient AI anims
intro_prayer_moveto_and_idle( n_group_id )
{
	level endon( "prayer_cleanup" );
	
	run_scene( "speech_amb_move_to_idle_0" + n_group_id );
	
}

intro_prayer_cleanup()
{
	level notify( "prayer_cleanup" );
	
	a_prayer_actors = GetEntArray( "intro_prayers", "script_noteworthy" );
	array_delete( a_prayer_actors );
}



menendez_intro()
{
	run_scene_first_frame( "speech_menendez_intro_menendez" );
	
	wait 1;
	e_menendez = get_ai( "menendez_speech_ai", "targetname" );
	e_menendez.team = "allies";
	
	level.player DisableWeapons();
	trigger_wait( "menendez_intro_start" );
	
	level thread intro_prayer_cleanup();
	
	level thread run_scene( "speech_menendez_intro_menendez" );
	run_scene( "speech_menendez_intro_player" );
}



menendez_speech()
{
	level thread menendez_speech_vo();
	run_scene( "speech_opendoors" );
	
	if( level.is_defalco_alive )
	{
		run_scene( "speech_walk_with_defalco" );
		level thread run_scene( "speech_defalco_endidl" );
	}
	else
	{
		run_scene( "speech_walk_no_defalco" );
	}
	
	run_scene( "speech_talk" );
}

menendez_speech_vo()
{
	IPrintLn( "Han (Radio): Farid, we got your distress signal, you've lost your Blue Force Tracking Device" );
	wait 4;
	IPrintLn( "Han (Radio): Be aware that we can no longer track who you are." );
	wait 2;
	iPrintLn( "Han (Radio): Our soldiers and drones will engage you." );
	wait 2;
	iPrintLn( "Han (Radio): Take out drones if you must, try not to engage the soldiers" );
}