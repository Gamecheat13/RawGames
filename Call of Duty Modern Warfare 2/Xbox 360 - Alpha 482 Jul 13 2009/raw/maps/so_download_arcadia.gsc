#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\so_download_arcadia_code;

main()
{
	// ------------- TWEAKABLES -------------
	level.DOWNLOAD_TIME = 60;				// how long it takes to download the files at each spot
	level.DOWNLOAD_INTERRUPT_RADIUS = 256;	// how close to the download an enemy has to be to "interrupt" it
	level.NEARBY_CHARGE_RADIUS = 1000;		// radius around the download from which we'll pull existing enemies to charge the download spot
	level.NUM_ENEMIES_LEFT_TOLERANCE = 0;	// how many guys we will tolerate still being alive in a wave before it's done
	level.NUM_FILES_MIN = 850;
	level.NUM_FILES_MAX = 1250;
	// --------------------------------------

	so_download_arcadia_init_flags();
	
	so_download_arcadia_precache();
	so_download_arcadia_anims();
	
	maps\_stryker50cal::main( "vehicle_stryker_config2" );
	maps\arcadia_anim::dialog();
	
	so_delete_all_by_type( ::type_spawn_trigger, ::type_flag_trigger, ::type_spawners, ::type_killspawner_trigger, ::type_goalvolume );
	thread enable_escape_warning();
	thread enable_escape_failure();
	
	maps\arcadia_precache::main();
	maps\createart\arcadia_art::main();
	maps\arcadia_fx::main();
	
	default_start( ::start_so_download_arcadia );
	add_start( "so_escape", ::start_so_download_arcadia );
	
	maps\_load::set_player_viewhand_model( "viewhands_player_us_army" );
	maps\_load::main();
	
	common_scripts\_sentry::main();
	
	add_hint_string( "use_laser", &"ARCADIA_LASER_HINT", maps\arcadia_code::should_stop_laser_hint );
	
	maps\_compass::setupMiniMap( "compass_map_arcadia" );
	
	thread so_download_arcadia_enemy_setup();
	
	thread maps\arcadia_amb::main();
	run_thread_on_noteworthy( "plane_sound", maps\_mig29::plane_sound_node );
	
	//thread maps\_debug::debug_character_count();
}

so_download_arcadia_init_flags()
{
	flag_init( "intro_dialogue_done" );
	flag_init( "first_download_started" );
	flag_init( "player_has_escaped" );
	flag_init( "all_downloads_finished" );
	flag_init( "stryker_extraction_done" );
	
	flag_init( "used_laser" );
	flag_init( "laser_hint_print" );
	
	flag_init( "golf_course_vehicles" );
	flag_init( "golf_course_mansion" );
	
	flag_init( "start_challenge" );
}

so_download_arcadia_precache()
{
	PrecacheItem( "m79" );
	PrecacheItem( "claymore" );
	
	PrecacheModel( "mil_wireless_dsm" );
	PrecacheModel( "mil_wireless_dsm_obj" );
	PrecacheModel( "com_laptop_rugged_open" );
	
	precacheShader( "dpad_laser_designator" );
}

start_so_download_arcadia()
{
	thread fade_challenge_in();
	thread enable_challenge_timer( "start_challenge", "stryker_extraction_done" );
	
	so_download_objective_init( 0, &"SO_DOWNLOAD_ARCADIA_OBJ_REGULAR" );
	thread stryker_think();
	thread so_download_arcadia_intro_dialogue();
}

so_download_arcadia_intro_dialogue()
{
	doExtraDialogue = false;
	
	int = GetDvarInt( "so_download_arcadia_introdialogue", -1 );
	if( int <= 0 )
	{
		doExtraDialogue = true;
		SetDvar( "so_download_arcadia_introdialogue", 5 );
	}
	else
	{
		int--;
		SetDvar( "so_download_arcadia_introdialogue", int );
	}
	
	if( doExtraDialogue )
	{
		// Hunter Two-One-Actual, Overlord. Gimme a sitrep over.
		radio_dialogue( "arcadia_hqr_sitrep" );
		
		// We're just past the enemy blockade at heckpoint Lima. Now proceeding into Arcadia, over.
		level.foley dialogue_queue( "arcadia_fly_intoarcadia" );
		
		// Roger that. I have new orders for you. This comes down from the top, over.
		radio_dialogue( "arcadia_hqr_neworders" );
		
		// Solid copy Overlord, send it.
		level.foley dialogue_queue( "arcadia_fly_solidcopy" );
	}
	
	// "There are several ruggedized laptops in your AO that contain high-value information."
	radio_dialogue( "so_dwnld_hqr_laptops" );
	
	// "Download the data from each of the laptops, then return to the Stryker for extraction."
	radio_dialogue( "so_dwnld_hqr_downloaddata" );
	
	flag_set( "intro_dialogue_done" );
	music_loop( "airlift_start_music", 130 );
}

so_download_arcadia_anims()
{
	// "There are several ruggedized laptops in your AO that contain high-value information."
	level.scr_radio[ "so_dwnld_hqr_laptops" ] = "so_dwnld_hqr_laptops";
	
	// "Download the data from each of the laptops, then return to the Stryker for extraction."
	level.scr_radio[ "so_dwnld_hqr_downloaddata" ] = "so_dwnld_hqr_downloaddata";
	
	
	// "All Hunter units, Badger One will not engage targets without your explicit authorization."
	level.scr_radio[ "so_dwnld_stk_explicitauth" ] = "so_dwnld_stk_explicitauth";
	
	// "Hunter Two-One, I repeat, Badger One is not authorized to engage targets that you haven't designated."
	level.scr_radio[ "so_dwnld_stk_designated" ] = "so_dwnld_stk_designated";
	
	// "Hunter Two-One, we can't fire on enemies without your authorization!"
	level.scr_radio[ "so_dwnld_stk_cantfire" ] = "so_dwnld_stk_cantfire";
	
	
	// "Hunter Two-One, ten-plus foot-mobiles approaching from the east!"
	level.scr_radio[ "so_dwnld_stk_tenfootmobiles" ] = "so_dwnld_stk_tenfootmobiles";
	
	// "We've got activity to the west, they're coming from the light brown mansion!"
	level.scr_radio[ "so_dwnld_stk_brownmansion" ] = "so_dwnld_stk_brownmansion";
	
	// "Hostiles spotted across the street, they're moving to your position!"
	level.scr_radio[ "so_dwnld_stk_acrossstreet" ] = "so_dwnld_stk_acrossstreet";
	
	// "Hunter Two-One, you got movement right outside your location!"
	level.scr_radio[ "so_dwnld_stk_gotmovement" ] = "so_dwnld_stk_gotmovement";
	
	
	// "Hunter Two-One, there are hostiles in the area that can wirelessly disrupt the data transfer."
	level.scr_radio[ "so_dwnld_hqr_wirelesslydisrupt" ] = "so_dwnld_hqr_wirelesslydisrupt";
	
	// "Hunter Two-One, the download has been interrupted! You'll have to restart the data transfer manually."
	level.scr_radio[ "so_dwnld_hqr_restartmanually" ] = "so_dwnld_hqr_restartmanually";
	
	// "Hunter Two-One, hostiles have interrupted the download! Get back there and manually resume the transfer!"
	level.scr_radio[ "so_dwnld_hqr_getbackrestart" ] = "so_dwnld_hqr_getbackrestart";
	
	
	// "Good job, Hunter Two-One. Our intel indicates that there are two more laptops in the area - go find them and get their data."
	level.scr_radio[ "so_dwnld_hqr_gofindthem" ] = "so_dwnld_hqr_gofindthem";
	
	// "Stay frosty, Hunter Two-One, there's one laptop left."
	level.scr_radio[ "so_dwnld_hqr_onelaptop" ] = "so_dwnld_hqr_onelaptop";
	
	
	// "Nice work, Hunter Two-One. Now get back to the Stryker, we're pulling you out of the area."
	level.scr_radio[ "so_dwnld_hqr_pullingyouout" ] = "so_dwnld_hqr_pullingyouout";
	
	// "Hunter Two-One, get back to the Stryker for extraction!"
	level.scr_radio[ "so_dwnld_hqr_extraction" ] = "so_dwnld_hqr_extraction";
	
	// "Hunter Two-One, return to the Stryker to complete your mission!"
	level.scr_radio[ "so_dwnld_hqr_completemission" ] = "so_dwnld_hqr_completemission";
}
