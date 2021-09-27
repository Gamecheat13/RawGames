#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_audio;
#include maps\_audio_music;
#include maps\paris_shared;
#include maps\_audio_zone_manager;

main()
{
	// we're getting asserts in mgon(), called by mgtoggle(), the function that polls vehicle.script_mg.  Since we don't use that polling functionality,
	// let's get on board with nate's hack for hamburg and disable it.
	// My theory for the asserts is that spec ops deletes the driver when the player dies, then our
	// crash on driver death thing is killing the vehicle on the first frame, and so by the time mgtoggle()
	// runs, the vehicle is already a deleted entity, so there is no more death message, and mgtoggle() then
	// tries to call mgon on the deleted entity.
	level.vehicles_ignore_mg_toggle	= true;
	
	maps\so_jeep_paris_b_precache::main();
	
	// so we don't precache some vehicles whose assets we've moved to the sp map, instead of calling this directly,
	// we do a subset of it ourselves
	//maps\paris_b_precache::main();
	vehicle_scripts\_gaz::main( "vehicle_gaz_tigr_harbor", undefined, "script_vehicle_gaz_tigr_harbor" );
	vehicle_scripts\_gaz::main( "vehicle_gaz_tigr_paris", "gaz_tigr_turret_physics_paris", "script_vehicle_gaz_tigr_turret_physics_paris" );
	vehicle_scripts\_mi17::main( "vehicle_mi17_woodland_fly", undefined, "script_vehicle_mi17_woodland_fly" );
	vehicle_scripts\_hind::main( "vehicle_mi24p_hind_woodland", undefined, "script_vehicle_mi24p_hind_woodland" );
	vehicle_scripts\_mig29::main( "vehicle_mig29_low", undefined, "script_vehicle_mig29_low" );
	vehicle_scripts\_t72::main( "vehicle_t72_tank", undefined, "script_vehicle_t72_tank" );
	common_scripts\_destructible_types_anim_motorcycle_01::main();
	common_scripts\_destructible_types_anim_motorcycle_02::main();
	maps\animated_models\foliage_paris_tree_plane_medium::main();
	
	maps\_shg_common::so_vfx_entity_fixup( "msg_fx" );
	maps\_shg_common::so_mark_class( "trigger_multiple_audio" );
	maps\paris_b_fx::main();
	
	PrecacheMinimapSentryCodeAssets();
	
	maps\so_jeep_paris_b_fx::main();	
	maps\createart\so_jeep_paris_b_art::main();	

	// before load::main so it can delete vehicles before init_vehicles() can complain about missing stuff
	so_delete_all_vehicles();

	maps\_load::main();

	maps\paris_aud::main();
	maps\so_aud::main();

	maps\_compass::setupMiniMap( "compass_map_paris_b" );
	
	level.bomb_truck = getstruct( "struct_bomb_truck_dummy", "targetname" );
	
	/#
	thread debug_magic();
	thread debug_npc_count();
	#/
	
	//PrecacheShader( "gasmask_overlay_delta2" );
	PreCacheShellShock( "slowview" );
	PreCacheShellShock( "default" );
	PreCacheShellShock( "flashbang" );
	
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "mk46_reflex" );
	PrecacheItem( "claymore" );
	
	//vo
	flag_init("flag_conversation_in_progress");
	
	//init flags
	flag_init( "flag_player_dead_stop_vehicle" );
	flag_init( "flag_jeep_path_complete" );
	flag_init( "jeep_slowmo_canal_start" );
	flag_init( "jeep_slowmo_canal_end" );
	flag_init( "flag_gaz_canal_1_dead" );
	flag_init( "flag_gaz_canal_2_dead" );
	flag_init( "flag_gaz_canal_3_dead" );
	flag_init( "flag_gaz_canal_4_dead" );
	flag_init( "flag_ambient_helis_canal" );
	flag_init( "flag_apartment_combat" );
	flag_init( "flag_dialogue_sticktogether" );
	flag_init( "flag_gasmask_on" );
	flag_init( "flag_juggernaut_death" );
	flag_init( "player_has_escaped" );
	flag_init( "flag_level_complete_driver_in_jeep" );
	flag_init( "flag_level_complete_player_in_jeep" );
	flag_init( "flag_level_complete_drive_away" );
	flag_init( "flag_allow_player_exit_vehicle" );
	
	//dsm flags
	flag_init( "dsm_ready_to_use" );
	flag_init( "download_started" );
	flag_init( "download_files_started" );
	flag_init( "dsm_exposed" );
	flag_init( "download_data_initialized" );
	flag_init( "download_complete" );
	flag_init( "dsm_recovered" );

	foreach(player in level.players)
	{
		// player-specific flags
		
		player ent_flag_init("ent_flag_player_in_vehicle");
	}
	
	//anims
	generic_human();
	vehicles();
	
	//weapons
//	PreCacheItem( "smoke_grenade_american" );
	
	add_hint_string("gasmask_hint", &"SO_JEEP_PARIS_B_GASMASK_HINT", ::should_stop_gasmask_hint);
	
	// tell spec ops not to randomly unlink us
	flag_set("special_op_no_unlink");
	
	setup();	
	gameplay_logic();
}

#using_animtree( "generic_human" );
generic_human()
{
	level.scr_anim[ "driver" ]	[ "jeep_driver_enter" ]							= %rubicon_mount_driver;
	level.scr_anim[ "driver" ]	[ "jeep_driver_exit" ]							= %rubicon_dismount_driver;
	
	level.scr_anim[ "driver" ]  [ "drive_idle" ]								= [ %jeep_driver_driving ];
	level.scr_anim[ "driver" ]  [ "drive_turn_pose_left" ]						= [ %jeep_driver_turn_pose_left ];
	level.scr_anim[ "driver" ]  [ "drive_turn_pose_right" ]						= [ %jeep_driver_turn_pose_right ];
}

#using_animtree("vehicles");
vehicles()
{
	level.scr_animtree[ "jeep" ]												= #animtree;
	level.scr_anim[ "jeep" ][ "drive_idle" ]									= [ %jeep_jeep_driving ];
	level.scr_anim[ "jeep" ][ "drive_turn_pose_left" ]							= [ %jeep_jeep_turn_pose_left ];
	level.scr_anim[ "jeep" ][ "drive_turn_pose_right" ]							= [ %jeep_jeep_turn_pose_right ];
}

setup()
{	
	setsaveddvar( "g_friendlyfireDamageScale", .1 );
	setsaveddvar( "compassMaxRange", 3500 ); // default was 3500
	
	thread enable_challenge_timer( "so_jeep_paris_b_start", "so_jeep_paris_b_complete" );
	thread fade_challenge_in();
	thread fade_challenge_out( "so_jeep_paris_b_complete" );
	
	so_delete_all_triggers();
	so_delete_all_spawners();
			
	thread enable_escape_warning();
	thread enable_escape_failure();	

	thread setup_ignore_all_triggers();
	
	thread setup_vo();
	thread setup_music();
	thread setup_poison_wake_volumes();
	thread smoke_large_drive();
	
	thread vision_set_fog_changes( "paris_gallery", 0 );	
	
	handle_end_of_game_bonuses();
	
	CONVERT_MIN_TO_MILLI_SEC = 60 * 1000;
	
    level.so_mission_min_time        = 4 * CONVERT_MIN_TO_MILLI_SEC;
	level.so_mission_worst_time    	 = 9 * CONVERT_MIN_TO_MILLI_SEC;
	
	maps\_shg_common::so_eog_summary( "@SO_JEEP_PARIS_B_BONUS_1_HELI_KILLS", 150, undefined, "@SO_JEEP_PARIS_B_BONUS_2_JUGG_KILL", 25, undefined);
	
	array_thread ( level.players, ::enable_challenge_counter, 3, &"SO_JEEP_PARIS_B_BONUS_1_COUNT_HELI_KILLS", "heli_kill" );
	array_thread ( level.players, ::enable_challenge_counter, 4, &"SO_JEEP_PARIS_B_BONUS_2_COUNT_JUGG_KILL", "explosion_kill" );
		
	setup_players();
	setup_jeep();
	setup_fx();
	thread setup_obj();
	setup_canal_path();
	setup_dsm();
	thread link_players_to_jeep();
	sp_prop_cleaning();
//	thread minimap_switching();
}

sp_prop_cleaning()
{
	clip_table = getentarray( "clip_table_staging_room", "targetname" );
	foreach( clip in clip_table )
	{
		if(IsDefined(clip))
			clip delete();
	}
	props_table = getent( "volk_escape_table_props", "script_noteworthy" );
	table = getent( "volk_escape_table", "script_noteworthy" );
	
	props_table_bomb_parts = getentarray( "props_staging_room_table_bomb_parts", "targetname" );
	foreach( prop in props_table_bomb_parts )
	{
		if(IsDefined(prop))
			prop delete();
	}
	
	path_blocker = getent("blocker_canal_end_1", "script_noteworthy");
	path_blocker ConnectPaths();
	path_blocker delete();
	
	door_blocker = getent_safe("van_door_blocker", "script_noteworthy");
	door_blocker delete();
	
	van_sight_blocker = getent_safe("van_sight_blocker", "script_noteworthy");
	van_sight_blocker Delete();
	
	blocker = getent( "blocker_path_canal_end", "targetname" );
	blocker ConnectPaths();
	blocker delete();
	
	props_table delete();
	table delete();
	
	fx_flagEnt_1 = getEntWithFlag( "msg_fx_zone8500" );
	fx_flagEnt_2 = getEntWithFlag( "msg_fx_staircase_helis" );
	
	fx_flagEnt_1 delete();
	fx_flagEnt_2 delete();
}	

setup_players()
{
	assert(isdefined(level.players[0]));
	
	level.single_player = true;	
	level.players[0].jeep_seat 	= "tag_guy1";
	level.players[0].exit_tag 	= "tag_walker5";

	if (isdefined(level.players[1]))
	{
		level.single_player = false;
		level.players[1].jeep_seat 	= "tag_guy0";
		level.players[1].exit_tag 	= "tag_walker4";
	}
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] thread monitor_explosive_kills();
	}
}	

setup_jeep()
{
	level.jeep = getent( "jeep_player", "targetname" );
	level.jeep.animname = "jeep";
	aud_send_msg("so_paris_start_jeep", level.jeep);
	level.jeep.dont_crush_player = true;
	thread setup_driver();
}

tweak_damage_multiplier_on_vet()
{
	if ( getdifficulty() == "fu" )
	{
		setsaveddvar( "player_damageMultiplier", 0.7 );  
    	/#
		debug_print( "tweak player damage .7" );
		#/
		flag_wait ( "flag_stairs_middle" );
		setsaveddvar( "player_damageMultiplier", 1 );  
		/#
		debug_print( "reset player damage" );
		#/
	}
}	

setup_driver()
{
	level.driver = getent_safe("driver_gign", "targetname") spawn_ai(true);
	level.driver deletable_magic_bullet_shield();
	level.driver gun_remove();
	level.driver.animname = "driver";
	level.driver.ignoreme = true;
	level.driver.so_no_mission_over_delete = true;
	
//	level.jeep anim_first_frame_solo( level.driver, "jeep_driver_enter", "tag_driver" );
	
//	level.jeep anim_single_solo( level.driver, "jeep_driver_enter", "tag_driver" );
	level.driver LinkTo( level.jeep, "tag_driver", (0, 0, 0), (0, 0, 0));
	thread jeep_start();
	
	thread driving_anims(level.jeep, level.driver);
	
	flag_wait( "flag_jeep_path_complete" );
	setsaveddvar( "g_friendlyfireDamageScale", 2 ); // 2 is the SO default
	
	stop_driving_anims(level.jeep);

	level.jeep anim_single_solo( level.driver, "jeep_driver_exit", "tag_driver" );
	level.driver gun_recall();
	level.driver unlink();
	
	volume = getent( "info_v_apartment_entrance_ally", "targetname" );
	level.driver cleargoalvolume();
	level.driver SetGoalVolumeAuto( volume );
	level.driver.ignoreme = false;
	
	thread driver_back_into_jeep();
}

setup_fx()
{
	thread gas_staging_room();
	thread smoke_ramp_drive();
	thread smoke_shaft();
	thread gas_corridor();
	thread gas_boiler_room();
	thread gas_apartment_exit();
}
		
driver_back_into_jeep()
{
	flag_wait( "flag_driver_back_in_jeep" );
	
	level.driver gun_remove();
	level.driver.animname = "driver";
	level.driver.ignoreme = true;
	
	level.jeep anim_single_solo( level.driver, "jeep_driver_enter", "tag_driver" );
	level.driver LinkTo( level.jeep, "tag_driver", (0, 0, 0), (0, 0, 0));
	
	thread driving_anims(level.jeep, level.driver);
	
	flag_set( "flag_level_complete_driver_in_jeep" );	
}	

setup_obj()
{
	triggers_targetname = getentarray( "enable_escape", "targetname" );
	triggers_script_noteworthy = getentarray( "enable_escape", "script_noteworthy" );
	
//	triggers_gas_fx = getentarray( "enable_escape_fx", "script_noteworthy" );
	obj_escape_triggers = array_combine( triggers_targetname, triggers_script_noteworthy );
/*	
	foreach( trigger in triggers_gas_fx )
	{	if(IsDefined(trigger))
			trigger trigger_off();
	}
*/	
	foreach( trigger in obj_escape_triggers )
	{	if(IsDefined(trigger))
			trigger trigger_off();
	}
	
	so_escape_triggers_drive = getentarray( "trigger_so_escape_drive", "targetname" );
	
	foreach( trigger in so_escape_triggers_drive )
	{	if(IsDefined(trigger))
			trigger trigger_off();
	}
	
	so_escape_triggers_catacombs = getentarray( "trigger_so_escape_catacombs", "targetname" );
	
	foreach( trigger in so_escape_triggers_catacombs )
	{	if(IsDefined(trigger))
			trigger trigger_off();
	}
	
	obj_get_to_apartment();
	
	foreach( trigger in so_escape_triggers_drive )
	{	if(IsDefined(trigger))
			trigger trigger_on();
	}
		
	obj_intel();
	
	foreach( trigger in so_escape_triggers_catacombs )
	{	if(IsDefined(trigger))
			trigger trigger_on();
	}
	
	obj_protect_intel();
	
	foreach( trigger in triggers_script_noteworthy )
	{	if(IsDefined(trigger))
			trigger trigger_on();
	}
	
	obj_retrieve_intel();
	
	foreach( trigger in obj_escape_triggers )
	{	if(IsDefined(trigger))
			trigger trigger_on();
	}
	
	foreach( trigger in so_escape_triggers_catacombs )
	{	if(IsDefined(trigger))
			trigger trigger_off();
	}
	
	foreach( trigger in so_escape_triggers_drive )
	{	if(IsDefined(trigger))
			trigger trigger_on();
	}
	
	obj_exit_catacombs();
}

setup_music()
{
	AZM_start_zone( "paris_final_chase_canal" );
	
	MUS_play ( "so_pars_outro", 4 );
	wait 7;
	MUS_play( "so_pars_street_chase", 8 );
	
	flag_wait ("flag_jeep_path_complete");
	MUS_play( "so_pars_street_chase_end", 1 );
	
	wait 2;
	MUS_play( "so_pars_cross_courtyard1", 4 );

	flag_wait( "flag_staging_room_reached" );
	MUS_play( "so_pars_courtyard1_crossed", 8 );
	
	flag_wait( "download_started" );
	wait 2;
	MUS_play( "so_pars_pre_first_contact", 4 );
	wait 10;
	MUS_play( "so_pars_first_contact", 2 );
	
	flag_wait( "download_complete" );
	MUS_play( "so_pars_cross_courtyard2_ending", 4 );
	
	flag_wait( "dsm_recovered" );
	MUS_play( "so_pars_cross_courtyard1", 4 );
		
	flag_wait( "flag_obj_exit_marker_3" );
	MUS_stop(4);

	flag_wait( "flag_corridor_escape" );
	wait 6;
	MUS_play ( "so_pars_outro", 4 );
	
	flag_wait_any( "flag_juggernaut_death", "flag_obj_exit_marker_6" );
	wait 1;
	MUS_stop(2);
	
	wait 2;
	MUS_play ( "so_pars_cross_courtyard1", 4 );

}

setup_vo()
{
	//overlord
	add_radio([
		"so_parisb_hqr_gettheleadout",		//Littlebird is at the RV.  Get the lead out Metal 0-4!
		"so_parisb_hqr_volk",				//Volk is planning something big. We need a thorough SSE.  Marking last known position
		"so_parisb_hqr_almostthere",		//Almost there.
		"so_parisb_hqr_headunder",			//Head underground to the catacombs.
		"so_parisb_hqr_sticktogether",		//Stick together Metal 0-4. Two is one, one is none.
		"so_parisb_hqr_plantdrm",			//Metal 0-4, Plant the DRM on the sever… ready for upload
		"so_parisb_hqr_scanning",			//The Russians are scanning for any transmissions.
		"so_parisb_hqr_loadup",				//Metal 0-4 you're going to have some company.  Load up and secure your position before starting the download.
		"so_parisb_hqr_dataincoming",		//Receiving signal. Data incoming.
		"so_parisb_hqr_fiftypercent",		//Download is 50% complete.
		"so_parisb_hqr_seventyfivepercent",	//75%, hang on Metal 0-4.
		"so_parisb_hqr_uploadcomplete",		//Upload complete.  Retrieve the DRM and head back up top.
		"so_parisb_hqr_morereinforcements",	//More reinforcements incoming Metal 0-4, You gotta move.
		"so_parisb_hqr_chemweapons",		//Heavy traces of Chem weapons detected Metal 0-4, they're gassing the area, get out now!
		"so_parisb_hqr_backtojeep",			//Get back to the Jeep now!
		"so_parisb_hqr_nicework"			//Bring it in Metal 0-4.  Nice work.	
	]);
	
	// GIGN Driver
	add_lines("driver", [
		"so_parisb_ggn_watchsix",		//Watch our 6!
		"so_parisb_ggn_badguys",		//Bad guys behind us!
		"so_parisb_ggn_onoursix",		//On our 6, on our 6!
		"so_parisb_ggn_badguysbehind",	//6 o'clock, bad guys behind!
		"so_parisb_ggn_rightinfront",	//Right in front of us!  12 o'clock!
		"so_parisb_ggn_12oclock",		//12 o'clock, 12 o'clock!
		"so_parisb_ggn_deadahead",		//Bad guys dead ahead!
		"so_parisb_ggn_outinfront"		//Enemies out in front!  In front!
	]);
	thread vo();
}

vo()
{
	level endon ( "missionfailed" );
	
	flag_wait("flag_vo_volk_planning"); 
	
	level.driver endon ( "death" );
	
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_volk" );
	conversation_end();
	
	flag_wait("flag_gallery_combat");
	conversation_begin();
	level.driver dialogue_queue( "so_parisb_ggn_deadahead" );
	conversation_end();
	
	flag_wait( "flag_canal_combat_move_end" );
	conversation_begin();
	level.driver dialogue_queue( "so_parisb_ggn_badguysbehind" );
	conversation_end();
	
	flag_wait("flag_stairs_middle"); 	
	
	wait 2;
	conversation_begin();
	level.driver dialogue_queue( "so_parisb_ggn_rightinfront" );
	conversation_end();
	
	wait 5;
	conversation_begin();
	level.driver dialogue_queue( "so_parisb_ggn_12oclock" );
	conversation_end();

	flag_wait("flag_apartment_combat"); 	
	
	wait 1.5;
	conversation_begin();
	level.driver dialogue_queue( "so_parisb_ggn_outinfront" );
	conversation_end();

	flag_wait("flag_jeep_path_complete"); 
	
	wait 2;
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_headunder" );
	conversation_end();
	
	flag_wait("flag_staging_room_reached"); 
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_plantdrm" );
	conversation_end();
	
	flag_wait("flag_dialogue_staging_room_loadup"); 
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_scanning" );
	radio_dialogue( "so_parisb_hqr_loadup" );
	conversation_end();
	
	thread vo_dialogue_sticktogether();
		
	flag_wait("download_data_initialized"); 
	
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_dataincoming" );
	conversation_end();
	
	wait 27;
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_fiftypercent" );
	conversation_end();
	
	wait 13;
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_seventyfivepercent" );
	conversation_end();
	
	wait 6;
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_almostthere" );
	conversation_end();
	
	/*
	wait 3;
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_chemweapons" );
	conversation_end();
	*/
	
	flag_wait("download_complete"); 
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_uploadcomplete" );
	conversation_end();
	
	flag_wait_any( "flag_obj_exit_marker_2", "dsm_recovered" );
	
	wait 5;
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_backtojeep" );
	conversation_end();
		
	flag_wait("flag_obj_exit_marker_3"); 
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_morereinforcements" );
	conversation_end();
	
	flag_wait_any("flag_juggernaut_death", "flag_obj_exit_marker_5" ); 
	
	wait 3;
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_gettheleadout" );
	conversation_end();
	
	flag_wait( "flag_level_complete_drive_away" );
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_nicework" );
	conversation_end();
}

vo_dialogue_sticktogether()
{
	flag_wait("flag_dialogue_sticktogether");
	conversation_begin();
	radio_dialogue( "so_parisb_hqr_sticktogether");
	conversation_end();
}

vo_dialogue_badguys()
{
	conversation_begin();
	level.driver dialogue_queue( "so_parisb_ggn_badguys" );
	conversation_end();
}	

vo_dialogue_gaz_before_stairs(gaz)
{
	wait 3;
	
	if(isAlive(gaz))
	{
		conversation_begin();
		level.driver dialogue_queue( "so_parisb_ggn_12oclock" );
		conversation_end();
	}	
}	
			
obj_get_to_apartment()
{
	wait 4;
	
	objective_number = 1;
	objective_add( objective_number, "active", &"SO_JEEP_PARIS_B_OBJ_GET_TO_APARTMENT" );
	objective_current( objective_number );
	
	flag_wait( "flag_jeep_path_complete" );
	setsaveddvar( "compassMaxRange", 2000 ); // default was 3500
	
	objective_complete( objective_number );
}

obj_intel()
{
	objective_number = 2;
	objective_add( objective_number, "active", &"SO_JEEP_PARIS_B_OBJ_INTEL" );
	
	wait 2;
	
	objective_current( objective_number );
	
	objective_additionalposition( objective_number, 0, getstruct( "obj_intel_marker_1", "targetname" ).origin );

	flag_wait( "flag_combat_boiler_room_entrance_retreat" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition ( objective_number, 0, getstruct( "obj_intel_marker_2", "targetname" ).origin );
	
	flag_wait( "flag_combat_boiler_room_retreat" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition ( objective_number, 0, getstruct( "obj_intel_marker_3", "targetname" ).origin );
	
	flag_wait( "flag_combat_sewer_corridor_retreat" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition ( objective_number, 0, getstruct( "obj_intel_marker_4", "targetname" ).origin );
	
	flag_wait( "flag_staging_room_reached" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition ( objective_number, 0, getstruct( "obj_intel_marker_5", "targetname" ).origin );
	
	flag_wait( "download_started" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_complete( objective_number );
}

obj_protect_intel()
{
	objective_number = 3;
	objective_add( objective_number, "active", &"SO_JEEP_PARIS_B_OBJ_DOWNLOAD" );
	objective_current( objective_number );
	
	objective_additionalposition ( objective_number, 0, getstruct( "obj_intel_marker_5", "targetname" ).origin );
	Objective_SetPointerTextOverride( objective_number, &"SO_JEEP_PARIS_B_OBJ_POINTER_PROTECT" );
	
	flag_wait( "download_complete" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_complete( objective_number );
}

obj_retrieve_intel()
{
	objective_number = 4;
	objective_add( objective_number, "active", &"SO_JEEP_PARIS_B_OBJ_RETRIEVE" );
	objective_current( objective_number );
	
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition ( objective_number, 0, getstruct( "obj_intel_marker_5", "targetname" ).origin );
	Objective_SetPointerTextOverride( objective_number, &"SO_JEEP_PARIS_B_OBJ_POINTER_RETRIEVE" );
	
	flag_wait( "dsm_recovered" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_complete( objective_number );
}

obj_exit_catacombs()
{
	objective_number = 5;
	objective_add( objective_number, "active", &"SO_JEEP_PARIS_B_OBJ_EXIT" );
	
	wait 2;
	
	objective_current( objective_number );
	objective_additionalposition( objective_number, 0, getstruct( "obj_escape_marker_1", "targetname" ).origin );
	
	flag_wait( "flag_obj_exit_marker_2" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition( objective_number, 0, getstruct( "obj_escape_marker_2", "targetname" ).origin );
	
	flag_wait( "flag_obj_exit_marker_3" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition( objective_number, 0, getstruct( "obj_escape_marker_3", "targetname" ).origin );
	
	flag_wait( "flag_obj_exit_marker_4" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition( objective_number, 0, getstruct( "obj_escape_marker_4", "targetname" ).origin );
	
	flag_wait( "flag_obj_exit_marker_5" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_additionalposition( objective_number, 0, getstruct( "obj_escape_marker_5", "targetname" ).origin );
	
	flag_wait( "flag_obj_exit_marker_6" );
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	
	players_enter_jeep(objective_number);
	
	so_escape_triggers = getentarray( "trigger_so_escape_drive", "targetname" );
	
	foreach( trigger in so_escape_triggers )
	{	if(IsDefined(trigger))
			trigger trigger_off();
	}
	
	flag_set( "flag_level_complete_player_in_jeep" );
	level notify( "level_complete" );
	
	wait 2;
	objective_additionalposition( objective_number, 0, (0, 0, 0));
	objective_complete( objective_number );
}

gasmasks_on()
{
	foreach(player in level.players)
	{
		player thread player_puts_gasmask_on();	
		flag_set( "flag_gasmask_on" );
	}
}	

players_enter_jeep(objective_number)
{	
	Objective_SetPointerTextOverride( objective_number, &"SO_JEEP_PARIS_B_OBJ_POINTER_RIDE_JEEP" );

	SetSavedDvar("player_useRadius", 72);
	
	level.jeep.player_seats = [];
		
	level.jeep.player_seats[0] = player_seat_create(level.jeep, objective_number, 0, "tag_guy1", "tag_walker5", (42,  30, 48), (42,  22, 40));
	if(level.players.size > 1)
		level.jeep.player_seats[1] = player_seat_create(level.jeep, objective_number, 1, "tag_guy0", "tag_walker4", (42, -38, 48), (42,  -28, 40));

	thread handle_allow_player_exit_vehicle();
	
	foreach(seat in level.jeep.player_seats)
		seat thread player_seat_think();
		
	// wait for both players to be in the jeep
	// sigh, no good primitive for this	
	for(;;)
	{
		// first wait on all the flags
		foreach(player in level.players)
		{
			player ent_flag_wait("ent_flag_player_in_vehicle");
		}
		
		// now check they're all still true
		all_flags_set = true;
		foreach(player in level.players)
		{
			if(!player ent_flag("ent_flag_player_in_vehicle"))
			   all_flags_set = false;
		}
		
		if(all_flags_set)
			break;
	}	
	
	level notify("handle_allow_player_exit_vehicle_stop");
	flag_clear("flag_allow_player_exit_vehicle");
	
	foreach(player in level.players)
	{
		player EnableInvulnerability();
	}
	
	wait 2;
}

handle_allow_player_exit_vehicle()
{
	level endon("handle_allow_player_exit_vehicle_stop");
	for(;; waitframe())
	{
		any_player_down = false;
		foreach(player in level.players)
		{
			if(is_player_down(player))
			{
				any_player_down = true;
				break;				
			}				
		}
		
		// doing edge detection because we rely on the notifies only being sent when the flag actually changes
		// (flag_clear() enforces this but flag_set() doesn't)
		if(any_player_down)
		{
			if(!flag("flag_allow_player_exit_vehicle"))
				flag_set("flag_allow_player_exit_vehicle");
		}
		else
		{
			if(flag("flag_allow_player_exit_vehicle"))
				flag_clear("flag_allow_player_exit_vehicle");
		}
	}
}

player_seat_create(vehicle, objective_index, objective_additionalposition_index, seat_tag, exit_tag, objective_offset, usetrigger_offset)
{
	seat = SpawnStruct();
	seat.vehicle = vehicle;
	seat.objective_index = objective_index;
	seat.objective_additionalposition_index = objective_additionalposition_index;
	seat.seat_tag = seat_tag;
	seat.exit_tag = exit_tag;
	seat.objective_offset = objective_offset;
	seat.usetrigger_offset = usetrigger_offset;
	seat ent_flag_init("ent_flag_seat_occupied");
	seat.usable = spawn_tag_origin();
	return seat;
}

player_seat_think()
{
	Assert(IsDefined(self.seat_tag));
	
	for(;;)
	{
		//self.usable.origin = self.vehicle GetTagOrigin(self.exit_tag);
		self.usable LinkTo(self.vehicle, self.exit_tag, self.usetrigger_offset, (0, 0, 0));
		waitframe(); // so the link offset updates
		self.usable MakeUsable();
		self.usable SetHintString(&"SO_JEEP_PARIS_B_OBJ_POINTER_ENTER_JEEP");
		
		objective_position = TransformMove(self.vehicle GetTagOrigin(self.exit_tag), self.vehicle GetTagAngles(self.exit_tag), (0, 0, 0), (0, 0, 0), self.objective_offset, (0, 0, 0));
		
		Objective_AdditionalPosition(self.objective_index, self.objective_additionalposition_index, objective_position["origin"]);
	
		player = undefined;
		for(;;)
		{
			self.usable waittill("trigger", player);
			if(IsDefined(player) && IsPlayer(player) && IsAlive(player) && !player ent_flag("ent_flag_player_in_vehicle"))
				break;
		}
		Assert(IsDefined(player));
		
		self player_seat_occupied_think(player);
	}
}

player_seat_occupied_think(player)
{
	Assert(IsDefined(self.seat_tag));

	Assert(!self ent_flag("ent_flag_seat_occupied"));
	self ent_flag_set("ent_flag_seat_occupied");
	Assert(!player ent_flag("ent_flag_player_in_vehicle"));
	player ent_flag_set("ent_flag_player_in_vehicle");
	
	player thread player_link_think();		
	
	// alas there doesn't seem to be any way to make a hint string only show up for one player, other than to ensure
	// the geometry is such that the other player can't see it.  Screw with the link radius so you don't get the prompt for the
	// other objective.
	SetSavedDvar("player_useRadius", 65);
	
	Assert(!IsDefined(self.player));
	self.player = player;
	self.usable SetHintString("");
	self.usable MakeUnusable();
	Objective_AdditionalPosition(self.objective_index, self.objective_additionalposition_index, (0, 0, 0));
		
	
	player_seat_occupied_player_alive();
	
	// clear this stuff again in case player had the option to unlink but that didn't get cleaned up
	self.usable SetHintString("");
	self.usable MakeUnusable();
	
	self ent_flag_clear("ent_flag_seat_occupied");
	if(IsDefined(self.player))
	{
		Assert(flag("flag_allow_player_exit_vehicle") || !IsAlive(self.player));
		self.player ent_flag_clear("ent_flag_player_in_vehicle");
	}
	self.player = undefined;
}

player_seat_occupied_player_alive()
{
	// returns when the seat becomes unoccupied (including player death)
	// but does not handle clearing flags / etc.
	
	Assert(IsDefined(self.seat_tag));
	Assert(IsDefined(self.player));
	
	self.player endon("death");
	
	self player_seat_link_player();
	
	while(self.player ent_flag("ent_flag_player_in_vehicle"))
	{
		flag_wait("flag_allow_player_exit_vehicle");
		
		self.usable.origin = self.player GetEye();
		self.usable LinkTo(self.vehicle, self.seat_tag);
		self.usable MakeUsable();
		self.usable SetHintString(&"SO_JEEP_PARIS_B_HINT_EXIT_JEEP");
		// bit of a hack: when we become unlinkable, it's because the other player is down
		// spec ops screws with the usable radius, which makes us able to see the other objective, though.
		// screw with the radius here to override that
		SetSavedDvar("player_useRadius", 65);
		
		player_seat_occupied_player_alive_unlinkable();
		
		self.usable SetHintString("");
		self.usable MakeUnusable();
		Objective_AdditionalPosition(self.objective_index, self.objective_additionalposition_index, (0, 0, 0));	
	}
	// set it back to what the spec ops player down code wants it to be
	SetSavedDvar("player_useRadius", 128);
}

player_seat_occupied_player_alive_unlinkable()
{
	Assert(IsDefined(self.seat_tag));
	Assert(IsDefined(self.player));
	
	level endon("flag_allow_player_exit_vehicle");
	
	player = undefined;
	for(;;)
	{
		self.usable waittill("trigger", player);
		if(IsDefined(player) && player == self.player)
			break;
	}
	Assert(IsDefined(player) && player == self.player);
	
	// doing this so it doesn't inherit our endons, since we can die
	// from unlink not being allowed anymore.	
	self add_wait(::player_seat_unlink_player);
	do_wait();
}

player_seat_link_player()
{
	Assert(IsDefined(self.seat_tag));
	Assert(IsDefined(self.player));
	
	duration = 0.5;
	link_ent = self.player spawn_tag_origin();
	self.player PlayerLinkToDelta(link_ent, "tag_origin");		
	seat_pos = self.vehicle GetTagOrigin(self.seat_tag);
	link_ent MoveTo(seat_pos, duration);
	self.player AllowMelee( false );
	self.player AllowSprint(false);	
	wait( duration );
	link_ent LinkTo(self.vehicle, self.seat_tag);	
	
}

player_seat_unlink_player()
{
	Assert(IsDefined(self.seat_tag));
	Assert(IsDefined(self.player));
	Assert(flag("flag_allow_player_exit_vehicle"));
	
	self.player ent_flag_clear("ent_flag_player_in_vehicle");

	self.player endon("death");
	
	lerpTime = .5;
	assert(isdefined(self.exit_tag));
	self.vehicle lerp_player_view_to_tag(self.player, self.exit_tag, lerpTime, 0, 180, 180, 180, 180 );
	self.player Unlink();
	self.player AllowMelee(true);
	self.player AllowSprint(true);	
}

setup_canal_path()
{
	canal_blocker = getent( "blocker_ai_path_canal", "targetname" );
	canal_blocker ConnectPaths();
	canal_blocker Delete();
}	

setup_dsm()
{
	thread dsm_display_control();
	thread download_progress();
	thread claymore_pickups();
}
	
link_players_to_jeep()
{
	foreach( p in level.players )
	{	
		p thread player_link_think();		
	}
}	

minimap_switching()
{
	for(;;)
	{
		maps\_compass::setupMiniMap("compass_map_paris_b", "minimap_corner");
		SetSavedDVar("compassMaxRange", 3000); // default was 3500
		
		flag_wait("trigger_minimap_catacombs");
		
		maps\_compass::setupMiniMap("compass_map_paris_catacombs", "minimap_corner_catacombs");
		SetSavedDVar("compassMaxRange", 1750); // default was 3500
		
		flag_clear("trigger_minimap_chase");
		flag_wait("trigger_minimap_chase");
		
		flag_clear("trigger_minimap_catacombs");
	}
}

claymore_pickups()
{
	claymore_use_trig = GetEnt( "claymore_use_trig", "targetname" );
	claymores = GetEntArray( "claymores", "targetname" );

	claymore_use_trig SetHintString( &"SO_JEEP_PARIS_B_HINT_CLAYMORES" );
	claymore_use_trig UseTriggerRequireLookAt();
	claymore_use_trig waittill( "trigger", guy );
	guy give_claymores();
	array_call(claymores, ::delete);
	claymore_use_trig delete();
	level.player thread play_sound_on_entity( "weap_pickup" );
}

give_claymores()
{
	num = 5;
	
	self giveWeapon("claymore");
	self SetWeaponAmmoClip( "claymore", num );
	self SetWeaponAmmoStock( "claymore", (num -1) );
	self setactionslot( 4, "weapon", "claymore" );
	
	//wait 0.05;
	//for(i = 1; i < (num-1) ; i++)
	//	self giveWeapon("claymore");
}

player_link_think()
{
	Assert(IsPlayer(self));
	Assert(IsDefined(self.jeep_seat));
	
	default_viewfraction = .5;
		
	self playerlinktodelta(level.jeep, self.jeep_seat, default_viewfraction);
	
	self AllowMelee( false );
	self AllowSprint(false);
	
	// a bit of a hack - if player.laststand (a special code flag) is true while the player is linked, the view vibrates
	// luckily, most last stand stuff reads an ent flag on the player instead of the field directly
	// so we can just not allow that flag to be true while we're linked, and crouch you instead.	
	
	player_was_down = is_player_down(self);
	while(self IsLinked())
	{
		if(is_player_down(self))
		{
			waittillframeend;
			self SetStance("crouch"); // prone would be better, but for some reason it doesn't fix the problem
			self AllowStand(false);
			self.laststand = false;
		}
		
		if(player_was_down && !is_player_down(self))
		{			
			waittillframeend;			
			self AllowStand(true);
			self SetStance("stand");		
			
			// hack: SetStance will fail because of collision checks, which it should not do when we are linked.
			// to workaround, we will disallow crouch for a frame
			self AllowCrouch(false);
			self delayCall(0.05, ::AllowCrouch, true);
		}	
		
		player_was_down = is_player_down(self);
		waitframe();
	}

	if(is_player_down(self))
	{
		// undo the hack if you come unlinked (at the end of the jeep ride)
		self.laststand = true;
	}
	
	self AllowStand(true);
}

player_died_in_jeep_notify()
{	
	level endon ( "flag_jeep_path_complete" );
	
	if( !flag( "flag_jeep_path_complete" ) )
	{
		self waittill("death");
		flag_set( "flag_player_dead_stop_vehicle" );
	}	
}	
	
player_dead_notify()
{
	level.players[0] thread player_died_in_jeep_notify();
	
	if (isdefined(level.players[1]))
	{
		level.single_player = false;
		level.players[1] thread player_died_in_jeep_notify();
	}
}	

gameplay_logic()
{
	thread ambient_helis_start();
	gallery_combat();
	thread canal_runners_1();
	canal_combat();
	canal_combat_middle();
	canal_combat_end();
	post_canal_combat();
	up_stairs_middle_combat();
	up_stairs_top_combat();
	thread apartment_combat();
	flag_wait( "flag_jeep_path_complete" );
	unlink_players_from_jeep();
	boiler_room_entrance_combat();
	boiler_room_combat();
	sewer_corridor_combat();
	elevator_shaft_combat();
	staging_room_combat();
	staging_room_combat_defend();
	thread sewer_corridor_escape_runner();
	thread sewer_corridor_escape_combat();
	thread boiler_room_escape_combat();
	thread apartment_escape_combat();
	thread apartment_courtyard_escape_combat();
	level_complete();
}

jeep_start()
{
	wait 1;
	level.jeep = getent( "jeep_player", "targetname" );
	level.jeep gopath();
	level.jeep.BadPlaceModifier = .25;
	thread camera_shake_during_ride();
	thread player_dead_notify();
	level.jeep thread stop_vehicle_if_player_dead();
}

stop_vehicle_if_player_dead(bRandom)
{
	if(!IsDefined(bRandom)) bRandom = false;
	
	self endon( "flag_jeep_path_complete" );
	self endon( "death" );
	
	flag_wait( "flag_player_dead_stop_vehicle" );
	
	
	decel = 15;
		
	if(bRandom)
	{
		wait RandomFloatRange(0, .5);
		decel = RandomFloatRange(10, 30);
	}
	
	self Vehicle_SetSpeed(0, 15, decel);
}	

gallery_combat()
{
	flag_wait( "flag_gallery_combat" );
	thread tweak_damage_multiplier_on_vet();
	heli = spawn_vehicle_from_targetname_and_drive( "mi17_01_canal" );
	heli thread monitor_attacker();
	
	spawners = getentarray( "enemy_gallery_exit", "targetname" );
	array_spawn_function( spawners, ::fire_while_moving );
	array_spawn( spawners, true );
}

canal_runners_1()
{
	flag_wait( "flag_canal_runners_1" );
	spawners = getentarray( "enemy_canal_runners_1", "targetname" );

	array_spawn( spawners, true );
	
	thread rpg_canal_start();
	
	wait 1.75;
	gaz_1 = spawn_vehicle_from_targetname_and_drive( "gaz_canal_1" );
	gaz_1 godon();
	gaz_1 thread paris_vehicle_death();
	gaz_1 thread so_gaz_targeting();
	gaz_1 turret_convergence_tweak(); 
	gaz_1 thread set_flag_on_vehicle_death( "flag_gaz_canal_1_dead" );
	gaz_1 thread stop_vehicle_if_player_dead(true);
	
	gaz_1 delaythread( 2.0, ::godoff );
	
	wait 3;
	if(IsAlive(gaz_1))
	{
		thread vo_dialogue_badguys();
	}	
}

	rpg_canal_start()
{
	fake_rpg_start_1 = getstruct( "org_so_start_fake_rpg_3", "targetname" );
	fake_rpg_target_1 = getstruct( "org_so_target_fake_rpg_3", "targetname" );
	fake_rpg_start_2 = getstruct( "org_so_start_fake_rpg_4", "targetname" );
	fake_rpg_target_2 = getstruct( "org_so_target_fake_rpg_4", "targetname" );

	rpg_1 = MagicBullet( "rpg_straight", fake_rpg_start_1.origin, fake_rpg_target_1.origin );
	aud_data = [rpg_1, fake_rpg_start_1.origin, fake_rpg_target_1.origin];
	aud_send_msg("aud_rpg_3d", aud_data);
	
	wait .75;
	rpg_2 = MagicBullet( "rpg_straight", fake_rpg_start_2.origin, fake_rpg_target_2.origin );
	aud_data = [rpg_2, fake_rpg_start_2.origin, fake_rpg_target_2.origin];
	aud_send_msg("aud_rpg_3d", aud_data);
}	

canal_combat()
{
	flag_wait( "flag_canal_combat" );	
		
	if( level.players.size == 2 )
	{
		spawn_with_func( "enemy_canal_start" );
	}	
		
	gaz_3 = spawn_vehicle_from_targetname_and_drive( "gaz_canal_3" );
	gaz_3 thread paris_vehicle_death();
	gaz_3 thread so_gaz_targeting();
	gaz_3 turret_convergence_tweak(); 
	gaz_3 thread set_flag_on_vehicle_death( "flag_gaz_canal_3_dead" );
	gaz_3 mgoff();
	gaz_3 thread mgon_delay(6.0);
	gaz_3 thread stop_vehicle_if_player_dead(true);
	
	if( level.players.size == 2 )
	{
		gaz_5 = spawn_vehicle_from_targetname( "gaz_canal_5" );
		gaz_5 thread so_gaz_targeting();
		gaz_5 turret_convergence_tweak(); 
		gaz_5 mgoff();
		gaz_5 thread mgon_delay(10.0);
		gaz_5 thread stop_vehicle_if_player_dead(true);
	}		
}

set_flag_on_vehicle_death(level_flag)
{
	// self is the vehicle_ai_event
	self waittill_either("death", "vehicle_crashing_now");
	flag_set(level_flag);
}

canal_combat_middle()
{	
	flag_wait( "flag_canal_combat_move_middle" );
	
	spawners_canal_start = ["enemy_canal_start"];
	delete_spawners(spawners_canal_start);
	
	cleanup_ai_with_script_noteworthy( "enemy_gallery_exit" );
}

canal_combat_end()
{	
	flag_wait( "flag_canal_combat_move_end" );
	spawners_canal_start = ["enemy_canal_start"];
	delete_spawners(spawners_canal_start);
	
	thread rpg_2();
		
	if(flag ( "flag_gaz_canal_1_dead" ))
	{
		gaz = spawn_vehicle_from_targetname_and_drive( "gaz_canal_2" );
		gaz thread paris_vehicle_death();
		gaz thread so_gaz_targeting();
		gaz turret_convergence_tweak();
		gaz thread set_flag_on_vehicle_death( "flag_gaz_canal_2_dead" );
		gaz thread stop_vehicle_if_player_dead(true);
	}
}

rpg_2()
{
	fake_rpg_start = getstruct( "org_so_start_fake_rpg_2", "targetname" );
	fake_rpg_target = getstruct( "org_so_target_fake_rpg_2", "targetname" );

	rpg = MagicBullet( "rpg_straight", fake_rpg_start.origin, fake_rpg_target.origin );
	aud_data = [rpg, fake_rpg_start.origin, fake_rpg_target.origin];
	aud_send_msg("aud_rpg_3d", aud_data);
}	

post_canal_combat()
{
	flag_wait( "flag_post_canal_courtyard" );
	
	if(flag ( "flag_gaz_canal_3_dead" ))
	{
		gaz = spawn_vehicle_from_targetname_and_drive( "gaz_canal_4" );
		gaz thread paris_vehicle_death();
		gaz thread so_gaz_targeting();
		gaz turret_convergence_tweak(); 
		gaz thread set_flag_on_vehicle_death( "flag_gaz_canal_4_dead" );
		gaz thread stop_vehicle_if_player_dead(true);
	}
	
	if( level.players.size == 2 )
	{
		gaz = spawn_vehicle_from_targetname( "gaz_bottom_of_stairs_1" );
		gaz thread so_gaz_targeting();
		gaz turret_convergence_tweak();
		gaz delaythread(4.0, ::gopath);
		thread vo_dialogue_gaz_before_stairs(gaz);
	}	
	
	spawners = getentarray( "enemy_post_canal_runners_1", "targetname" );
	array_spawn( spawners, true );
	
	cleanup_ai_with_script_noteworthy( "enemy_canal_runners_1" );
	cleanup_ai_with_script_noteworthy( "enemy_canal_start" );
	cleanup_ai_with_script_noteworthy( "enemy_canal_middle" );
	cleanup_ai_with_script_noteworthy( "enemy_canal_heli_1" );
	
	thread ambient_helis_stairs();
}
	
up_stairs_middle_combat()
{
	flag_wait( "flag_stairs_middle" );	
	
	guys = spawn_with_func( "enemy_top_of_staits" );
	
	cleanup_ai_with_script_noteworthy( "enemy_post_canal_runners_1" );
	cleanup_ai_with_script_noteworthy( "enemy_gaz_canal_1" );
	cleanup_ai_with_script_noteworthy( "enemy_gaz_canal_3" );
}	
	
up_stairs_top_combat()
{
	flag_wait( "flag_stairs_top" );	
	
	gaz = spawn_vehicle_from_targetname( "gaz_top_of_stairs_1" );
	gaz thread so_gaz_targeting();
	gaz turret_convergence_tweak(); 
	gaz mgoff();
	gaz thread mgon_delay(5.0);
	
	
	thread rpg_1();
	delayThread(8, ::rpg_3);
	
	wait 2;
	spawn_with_func( "enemy_construction_courtyard" );
}		
	
rpg_1()
{
	fake_rpg_start = getstruct( "org_so_start_fake_rpg_1", "targetname" );
	fake_rpg_target = getstruct( "org_so_target_fake_rpg_1", "targetname" );

	rpg = MagicBullet( "rpg_straight", fake_rpg_start.origin, fake_rpg_target.origin );
	aud_data = [rpg, fake_rpg_start.origin, fake_rpg_target.origin];
	aud_send_msg("aud_rpg_3d", aud_data);
}	

rpg_3()
{
	fake_rpg_start = getstruct( "org_so_start_fake_rpg_5", "targetname" );
	fake_rpg_target = getstruct( "org_so_target_fake_rpg_5", "targetname" );

	rpg = MagicBullet( "rpg_straight", fake_rpg_start.origin, fake_rpg_target.origin );
	aud_data = [rpg, fake_rpg_start.origin, fake_rpg_target.origin];
	aud_send_msg("aud_rpg_3d", aud_data);
}	
	
apartment_combat()
{
	flag_wait( "flag_apartment_combat" );
	flag_set( "dsm_ready_to_use" );

	cleanup_ai_with_script_noteworthy( "enemy_top_of_staits" );
	cleanup_ai_with_script_noteworthy( "enemy_gaz_canal_2" );
	cleanup_ai_with_script_noteworthy( "enemy_gaz_canal_4" );
	cleanup_ai_with_script_noteworthy( "enemy_gaz_bottom_of_stairs_1" );
	
	
	gaz_1 = spawn_vehicle_from_targetname_and_drive( "gaz_apartment_1" );
	gaz_1.dont_crush_player = true;
	gaz_1 turret_convergence_tweak(); 
	gaz_1 thread stop_vehicle_if_player_dead(true);
	
	gaz_2 = spawn_vehicle_from_targetname_and_drive( "gaz_apartment_2" );
	gaz_2.dont_crush_player = true;
	gaz_2 turret_convergence_tweak(); 
	gaz_2 thread stop_vehicle_if_player_dead(true);
	
	guys = getentarray( "enemy_gaz_apartment_entrance", "script_noteworthy" );
	
	volume = getent( "info_v_apartment_entrance", "targetname" );
	
	foreach( guy in guys )
	{
		guy thread set_goal_apartment_guys(volume);
	}
	
	if( level.players.size == 2 )
	{
		spawn_with_func( "enemy_apartment_entrance_exterior" );
	}
	
	flag_wait( "flag_jeep_path_complete" );
	cleanup_ai_with_script_noteworthy( "enemy_construction_courtyard" );
	
	wait 2;

	spawn_flood_with_func( "enemy_apartment_entrance_flood" );
	
	flag_wait( "flag_combat_apartment_retreat" );
	
	spawners_apartment_entrance = ["enemy_apartment_entrance_flood"];
	delete_spawners(spawners_apartment_entrance);
}

set_goal_apartment_guys(volume)
{
	self endon( "death" );
	self waittill( "jumpedout" );
	waittillframeend;
	self cleargoalvolume();
	self SetGoalVolumeAuto(volume);
}	

boiler_room_entrance_combat()
{
	flag_wait( "flag_combat_apartment_retreat" );	
	
	spawn_with_func( "enemy_boiler_room_entrance" );
		
	spawn_flood_with_func( "enemy_boiler_room_entrance_flood" );
	
	flag_wait( "flag_combat_boiler_room_entrance_retreat" );
	
	spawners_boiler_room_entrance = ["enemy_boiler_room_entrance_flood"];
	delete_spawners(spawners_boiler_room_entrance);
}		
	
boiler_room_combat()
{
	flag_wait( "flag_combat_boiler_room_entrance_retreat" );	
	
	spawn_with_func( "enemy_boiler_room", ::add_enemy_flashlight );
	
	spawn_flood_with_func( "enemy_boiler_room_flood", ::add_enemy_flashlight );
	
	flag_wait( "flag_combat_boiler_room_retreat" );
	
	spawners_boiler_room = ["enemy_boiler_room_flood"];
	delete_spawners(spawners_boiler_room);
}

sewer_corridor_combat()
{
	flag_wait( "flag_combat_boiler_room_retreat" );
	
//	thread flashbang_boilerroom();
	
	spawn_flood_with_func( "enemy_sewer_corridor_flood", ::add_enemy_flashlight );
	spawn_flood_with_func( "enemy_sewer_corridor_flood_front", ::add_enemy_flashlight );
		
	flag_wait( "flag_combat_sewer_corridor_wave_2" );
	
	spawners_sewer_corridor_front = ["enemy_sewer_corridor_flood_front"];
	delete_spawners(spawners_sewer_corridor_front);
	
	if( level.players.size == 2 )
	{
		spawn_with_func( "enemy_sewer_corridor", ::add_enemy_flashlight );
	}
	
	flag_wait( "flag_combat_sewer_corridor_retreat" );
	spawners_sewer_corridor = ["enemy_sewer_corridor_flood"];
	delete_spawners(spawners_sewer_corridor);
}	
	
flashbang_boilerroom()
{
	if(cointoss())
	{
		flashbang_speed = 600;	// how fast it's thrown, inches per second
	
		flashbang_origin_struct = GetStruct("struct_flashbang_origin_boiler_room", "script_noteworthy");
		flashbang_target_struct = GetStruct(flashbang_origin_struct.target, "targetname");
		flashbang = MagicGrenadeManual("flash_grenade", flashbang_origin_struct.origin, VectorNormalize(flashbang_target_struct.origin - flashbang_origin_struct.origin) * flashbang_speed, 1.25 );		
	}	
}		
		
elevator_shaft_combat()
{
	flag_wait( "flag_combat_sewer_corridor_retreat" );
	
	spawn_flood_with_func( "enemy_elevator_shaft_flood", ::add_enemy_flashlight );
	
	flag_wait( "flag_elevator_shaft_retreat" );
	spawners_elevator_shaft = ["enemy_elevator_shaft_flood"];
	delete_spawners(spawners_elevator_shaft);
	
}		

staging_room_combat()
{
	flag_wait( "flag_elevator_shaft_retreat" );
	
	spawn_flood_with_func( "enemy_staging_room_flood" );
	
	spawn_flood_with_func( "enemy_staging_room_flood_rear", ::add_enemy_flashlight );
	
	flag_wait( "flag_staging_room_reached" );
	spawners_staging_room = ["enemy_staging_room_flood"];
	delete_spawners(spawners_staging_room);

	wait 5;
	
	spawners_staging_room_rear = ["enemy_staging_room_flood_rear"];
	delete_spawners(spawners_staging_room_rear);
	
}	

//**************************//

staging_room_combat_defend()
{
	flag_wait( "download_started" );
	
	wait 4;
	/#
	debug_print( "wave 1" );	
	#/
	spawn_flood_with_func( "enemy_staging_room_defend_flood_wave_1", ::add_enemy_flashlight );
			
	wait 16;

//**************************//	
	//wave 2
	/#
	debug_print( "wave 2 riot" );	
	#/
	spawn_limit_by_player_count( "enemy_staging_room_defend_riot_wave_2" );
	
	wait 10;
	/#
	debug_print( "wave 2" );	
	#/
	spawn_with_func("enemy_staging_room_defend_wave_2");

	wait 25;
	
//**************************//	
	//wave 3
	
	/#
	debug_print( "wave 3 with riot" );	
	#/
	spawn_limit_by_player_count( "enemy_staging_room_defend_riot_wave_3" );
	
	spawn_with_func("enemy_staging_room_defend_wave_3");
	/*
	if( level.players.size == 2 )
	{
		spawn_with_func( "enemy_staging_room_side", ::add_enemy_flashlight );
	}
	*/
	flag_wait( "download_complete" );
}

flashbang_staging_room()
{	
	wait 50;
	/*
	volumes = getentarray( "info_v_flashbang_escape", "targetname" );
	foreach( guy in GetAIArray( "axis" ) )
	{	
		closest_volume = getClosest(guy.origin, volumes);
		guy thread flashbang_staging_room_guy_retreats(closest_volume);
	}
	*/
	flag_set( "flag_staging_room_escape" );
	/*
	volumes_west_escape = getent( "info_v_staging_room_west_escape", "targetname" );
	volumes_west = getent( "info_v_staging_room_west", "targetname" );
	guy_west = volumes_west get_ai_touching_volume( "axis" );
	guy_west thread flashbang_staging_room_guy_retreats(volumes_west_escape);
	
	volumes_east_escape = getent( "info_v_staging_room_east_escape", "targetname" );
	volumes_east = getent( "info_v_staging_room_east", "targetname" );
	guy_east = volumes_east get_ai_touching_volume( "axis" );
	guy_east thread flashbang_staging_room_guy_retreats(volumes_east_escape);
	*/
	
	spawners_staging_room_complete = ["enemy_staging_room_defend_flood_wave_1"];
	delete_spawners(spawners_staging_room_complete);
	
	wait 3;
	/*	
	delaythread(5, ::gasmasks_on);
	
	flashbang_structs = getstructarray("struct_flashbang_origin_staging_room", "script_noteworthy");
	
	thread gas_staging_room();
	
	// todo: make this better
	// is first player intentional?
	flashbang_structs = SortByDistance(flashbang_structs, level.player.origin);
	*/	
	triggers_vision_sets = getentarray( "vision_sets_enable_escape", "script_noteworthy" );
	
	foreach( trigger in triggers_vision_sets )
	{	if(IsDefined(trigger))
			trigger trigger_off();
	}
/*		
	for(i = flashbang_structs.size - 1; i >= 0; i--)
	{
		flashbang_struct = flashbang_structs[i];
		
		magic_flashbang(flashbang_struct, RandomFloatRange(900, 1100), RandomFloatRange(1.5, 2.5));
		wait RandomFloatRange(.5, 1.5);
	}			
	
	// is first player only intentional?
	level.player ShellShock( "slowview", 10);
	level.player ShellShock( "flashbang", 8);
	
	wait 3;
*/	
//	thread vision_set_fog_changes( "paris_b", 6 );
}

flashbang_staging_room_guy_retreats(volume)
{
	self endon("death");
	if(!IsAlive(self)) return;
	
	thread flashbang_staging_room_guy_retreats_sprinting();
	
	self ClearGoalVolume();
	self SetGoalVolumeAuto(volume);
	
	
	while(true)
	{
		
		self waittill("goal");	
		
		volume_target = undefined;
		if(IsDefined(volume.target))
			volume_target = GetEnt(volume.target, "targetname");
			
		if(IsDefined(volume_target))
		{
			volume = volume_target;
			self ClearGoalVolume();
			self SetGoalVolumeAuto(volume);			
		}
		else
		{
			self Delete();	
		}
		
	}
}

flashbang_staging_room_guy_retreats_sprinting()
{
	self endon("death");
	if(!IsAlive(self)) return;

	wait 4;
	set_ignoreall(true);
	wait 8;
	self.sprint = true;	
}

// flashbang_struct should be a script_struct that targets another struct, which is how we know the direction to throw it.
magic_flashbang(flashbang_struct, speed, fuse_time)
{
	target_struct = getstruct(flashbang_struct.target, "targetname");
	Assert(IsDefined(target_struct));
	
	throw_vector = VectorNormalize(target_struct.origin - flashbang_struct.origin) * speed;
	return MagicGrenadeManual("flash_grenade", flashbang_struct.origin, throw_vector, fuse_time );
}

sewer_corridor_escape_runner()
{
	flag_wait( "flag_sewer_corridor_escape_runner" );

//	runner = spawn_with_func( "enemy_escape_corridor_runner", ::add_enemy_flashlight );
	spawner = getent( "enemy_escape_corridor_runner", "targetname" );
	spawner add_spawn_function( ::add_enemy_flashlight );
	runner = spawner spawn_ai(true);
	runner endon( "death" );
	
	runner.ignoreall = true;
	runner.sprint = true;
		
	wait 8;
	
	runner.ignoreall = false;
	runner.sprint = false;
}	
			
#using_animtree("generic_human");
sewer_corridor_escape_combat()
{
	flag_wait( "flag_corridor_escape" );
	
	level.pmc_alljuggernauts = false;
	
/*	
	if( level.players.size == 2 )
	{
		thread spawn_second_juggernaut();
	//	spawn_with_func( "enemy_escape_corridor_riot", ::add_enemy_flashlight );
	//	spawn_with_func( "enemy_escape_corridor", ::add_enemy_flashlight );
	}
*/
			
	spawners_juggernaut = getent( "enemy_escape_corridor_juggernaut", "targetname" );
	juggernaut = spawners_juggernaut spawn_ai(true);
	juggernaut thread jugg_givexp();
//	juggernaut.moveplaybackrate = .8;
	
//	juggernaut thread monitor_damage_type();
	juggernaut set_move_animset( "run", %Juggernaut_walkF, %Juggernaut_walkF );
	
	juggernaut thread juggernaut_death();
	
//	spawn_flood_with_func( "enemy_escape_corridor_flood", ::add_enemy_flashlight );
	
	flag_wait( "flag_combat_sewer_corridor_escape_stop_flood" );
	
	spawners_corridor_escape = ["enemy_escape_corridor_flood"];
	delete_spawners(spawners_corridor_escape);
}

spawn_second_juggernaut()
{
	flag_wait_or_timeout( "flag_combat_sewer_corridor_juggernaut_2", 4.0 );
	spawners_juggernaut = getent( "enemy_escape_corridor_juggernaut_2", "targetname" );
	juggernaut = spawners_juggernaut spawn_ai(true);
	juggernaut.moveplaybackrate = .8;
	juggernaut set_move_animset( "run", %Juggernaut_walkF, %Juggernaut_walkF );
}

juggernaut_death()
{
	self waittill("death");
	flag_set( "flag_juggernaut_death" );
}

boiler_room_escape_combat()
{
	flag_wait( "flag_obj_exit_marker_5" );
	
	spawn_with_func( "enemy_boiler_room_escape", ::add_enemy_flashlight );
	
	spawn_flood_with_func( "enemy_boiler_room_escape_flood", ::add_enemy_flashlight );
	
	flag_wait( "flag_obj_exit_marker_6" );
	
	spawners_boiler_room_escape = ["enemy_boiler_room_escape_flood"];
	delete_spawners(spawners_boiler_room_escape);
}	
		
apartment_escape_combat()
{
	flag_wait( "flag_obj_exit_marker_6" );
	
	spawn_with_func( "enemy_apartment_escape" );
}					

apartment_courtyard_escape_combat()
{
	flag_wait( "flag_combat_apartment_escape_retreat" );
	
	thread ambient_helis_end();
	
	spawn_with_func( "enemy_apartment_courtyard_escape" );
	
	flag_wait( "flag_driver_back_in_jeep" );
	heli = spawn_vehicle_from_targetname_and_drive( "mi17_01_end" );
	heli thread monitor_attacker();
}	

level_complete()
{
	flag_wait_all("flag_level_complete_driver_in_jeep", "flag_level_complete_player_in_jeep" );
	
	Assert( IsDefined( level.players[ 0 ] ) );
	
	level.players[0] EnableInvulnerability(true);
	
	if (isdefined(level.players[1]))
	{
		level.players[1] EnableInvulnerability(true);
	}
	
	flag_set( "flag_level_complete_drive_away" );
	
	wait 3;
	
	flag_set( "so_jeep_paris_b_complete" );
}	
	
player_heartbeat()
{
	level endon( "stop_player_heartbeat" );
	while ( true )
	{
		self PlayLocalSound( "breathing_heartbeat" );
		wait .5;
	}
}

unlink_players_from_jeep()
{
	array_thread( level.players, ::unlink_player_from_jeep );	
}

unlink_player_from_jeep()
{
	lerpTime = .5;
	
	assert(isdefined(self.exit_tag));

	level.jeep lerp_player_view_to_tag( self, self.exit_tag, lerpTime, 0, 180, 180, 180, 180 );

	self Unlink();
	self AllowMelee( true );
	self AllowSprint( true );
//	self enableweaponpickup();	
}
		
ambient_helis_start()
{
	flag_wait( "so_jeep_paris_b_start" );
	
	heli_spawners = GetEntArray( "ambient_helis_start", "targetname" );
	array_thread( heli_spawners, ::add_spawn_function, ::monitor_attacker );
	
	for(i = 0; i < 8; i++)
	{
		spawn_vehicles_from_targetname_and_drive( "ambient_helis_start" );
		wait 6;
	}
	
	flag_wait( "flag_ambient_helis_canal" );
	
	heli_spawners = GetEntArray( "ambient_helis_canal", "targetname" );
	array_thread( heli_spawners, ::add_spawn_function, ::monitor_attacker );
	
	for(i = 0; i < 5; i++)
	{
		spawn_vehicles_from_targetname_and_drive( "ambient_helis_canal" );
		wait 6;
	}
}

ambient_helis_stairs()
{
	heli_spawners = GetEntArray( "ambient_helis_stairs", "targetname" );
	array_thread( heli_spawners, ::add_spawn_function, ::monitor_attacker );
	
	for(i = 0; i < 8; i++)
	{
		spawn_vehicles_from_targetname_and_drive( "ambient_helis_stairs" );
		wait 6;
	}
}

ambient_helis_end()
{
	heli_spawners = GetEntArray( "ambient_helis_end", "targetname" );
	array_thread( heli_spawners, ::add_spawn_function, ::monitor_attacker );
	
	for(i = 0; i < 25; i++)
	{
		spawn_vehicles_from_targetname_and_drive( "ambient_helis_end" );
		wait 6;
	}
}

player_touching(volumes)
{
	foreach(volume in volumes)
	{
		if(self IsTouching(volume))
			return true;	
	}	
	return false;
}

all_players_touching(volumes)
{
	foreach(player in level.players)
	{
		if(!player player_touching(volumes))
			return false;	
	}
	return true;
}

//****************************************//
// DSM									  //
//****************************************//

dsm_display_control()
{
	dsm_real = getent( "dsm", "targetname" );
	dsm_obj = getent( "dsm_obj", "targetname" );
		
	dsm_real hide();
	
	
//	flag_wait( "dsm_ready_to_use" );

	volumes = GetEntArray("info_v_staging_room_players_ready", "targetname");
	trig = getent( "dsm_usetrigger", "targetname" );
	
	near_dsm_volume = getent_safe("info_v_staging_room_near_dsm", "targetname");
	
	for(;; waitframe())
	{
		if(all_players_touching(volumes))
		{
			trig sethintstring( &"SO_JEEP_PARIS_B_DSM_USE_HINT" );

			foreach(player in level.players)
			{
				player text_ping_clear();	
			}			
			
			if(flag( "trigger_use_start_download" ))
			{
				break;
			}
		}
		else
		{
			trig sethintstring( "" );
			
			foreach(player in level.players)
			{
				if(player IsTouching(near_dsm_volume))
				{
					player text_ping(&"SO_JEEP_PARIS_B_DSM_WAIT_FOR_PLAYER_HINT");	
					flag_set( "flag_dialogue_sticktogether" );
				}
				else
				{
					player text_ping_clear();	
				}
			}			

			
			flag_clear("trigger_use_start_download");
		}
	}

	flag_set("download_started");	
	
	flag_set( "dsm_exposed" );
	
	dsm_obj hide();
	dsm_real show();
	
	dsm_real thread dsm_sounds();
	
	flag_clear( "dsm_ready_to_use" );
	
	
	flag_wait( "download_complete" );
	
	trig sethintstring( &"SO_JEEP_PARIS_B_DSM_PICKUP_HINT" );
		
	flag_set( "dsm_ready_to_use" );
	
	dsm_obj show();
	
	trig waittill ( "trigger" );
	
	dsm_obj thread play_sound_on_entity( "dsm_pickup" );
	
	flag_clear( "dsm_ready_to_use" );
	flag_clear( "dsm_exposed" );

	waittillframeend;
	
	dsm_obj delete();
	dsm_real hide();
	
	flag_set( "dsm_recovered" );

}

dsm_sounds()
{
	self playsound( "scn_estate_data_grab_setdown" );
	
	wait 2;
	
	self playloopsound( "scn_estate_data_grab_loop" );
	
	flag_wait( "download_complete" );
	
	self stoploopsound();
}

download_progress()
{
	flag_wait( "download_started" );
	
	level endon ( "player_is_escaping" );
	
	start_x = -200;
	start_y = 80;
	if( IsSplitScreen() )
		start_y = start_y / 2;
	
	level.hudelem = maps\_hud_util::get_countdown_hud( start_x * 1.5, start_y, undefined, true );
	level.hudelem SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem.label = &"SO_JEEP_PARIS_B_DSM_FRAME";	// DSM v11.08
	//level.hudelem.fontScale = 1.5;
	wait 0.65;
	
	level.hudelem_status = maps\_hud_util::get_countdown_hud( start_x, start_y, undefined, true );
	level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_status.label = &"SO_JEEP_PARIS_B_DSM_WORKING"; // ...working...
	wait 2.85;
	
	level.hudelem_status destroy();
	level.hudelem_status = maps\_hud_util::get_countdown_hud( start_x, start_y, undefined, true );
	level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_status.label = &"SO_JEEP_PARIS_B_DSM_NETWORK_FOUND"; // ...network found...
	wait 3.75;
	
	level.hudelem_status destroy();
	level.hudelem_status = maps\_hud_util::get_countdown_hud( start_x, start_y, undefined, true );
	level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_status.label = &"SO_JEEP_PARIS_B_DSM_IRONBOX"; // ...ironbox detected...
	wait 2.25; 
	
	level.hudelem_status destroy();
	
	level.hudelem_status = maps\_hud_util::get_countdown_hud( start_x, start_y, undefined, true );
	level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_status.label = &"SO_JEEP_PARIS_B_DSM_BYPASS"; // ...bypassed.
	wait 3.1;
	
	level.hudelem destroy();
	level.hudelem_status destroy();	
	
	
	start_x = -230;
		
	level.hudelem = maps\_hud_util::get_countdown_hud( start_x, start_y );	//205
	level.hudelem SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem.label = &"SO_JEEP_PARIS_B_DSM_PROGRESS"; // Files copied:
	
	level.hudelem_status = maps\_hud_util::get_download_state_hud( -62, start_y, undefined, true );
	level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_status setvalue( 0 );
	
	level.hudelem_status_total = maps\_hud_util::get_countdown_hud( -62, start_y, undefined, true );
	level.hudelem_status_total SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	
	level.hudelem_dltimer_value = maps\_hud_util::get_countdown_hud( -132, start_y, undefined, true );
	level.hudelem_dltimer_value SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_dltimer_value.fontScale = 1.1;
	level.hudelem_dltimer_value.color = ( 0.4, 0.5, 0.4 );
	level.hudelem_dltimer_value.alignX = "right";

	level.switchtosecs = 0.85;
	
	flag_set( "download_data_initialized" );
	
	level.currentfiles = 0;
	level.totalfiles = 2009;
	thread flashbang_staging_room();
	so_download_files(2 * 30, 2009, 1200);

	flag_set( "download_complete" );
	
	download_display_delete();
}

download_display_delete()
{
	if ( isdefined( level.hudelem ) )
		level.hudelem destroy();
	
	if ( isdefined( level.hudelem_status ) )
		level.hudelem_status destroy();
	
	if ( isdefined( level.hudelem_status_total ) )
		level.hudelem_status_total destroy();
	
	//TIMER
		
	if ( isdefined( level.hudelem_dltimer ) )
		level.hudelem_dltimer destroy();
		
	if ( isdefined( level.hudelem_dltimer_value ) )
		level.hudelem_dltimer_value destroy();
	/*
	if ( isdefined( level.hudelem_dltimer_heading ) )
		level.hudelem_dltimer_heading destroy();
	*/
	if ( isdefined( level.hudelem_dltimer_secs ) )
		level.hudelem_dltimer_secs destroy();
	
	//DATA RATE
	/*
	if ( isdefined( level.hudelem_dlrate_heading ) )
		level.hudelem_dlrate_heading destroy();
		
	if ( isdefined( level.hudelem_dltimer_units ) )
		level.hudelem_dltimer_units destroy();
	
	if ( isdefined( level.hudelem_dlrate_value ) )
		level.hudelem_dlrate_value destroy();
	
	if ( isdefined( level.hudelem_dlrate_units ) )
		level.hudelem_dlrate_units destroy();	
	*/
}

so_download_files(totalTime, numFiles, totalSize)
{
	averageFileTime = totalTime / numFiles;
	
//	level.hudelem_dltimer_value setvalue( totalTime );	
//	level.hudelem_dlrate_value SetValue( totalSize / totalTime ) ;
	level.hudelem_status_total.label = "/" + numFiles;
	
	startTime = GetTime() * .001;
	
	while(true)
	{
		time = GetTime() * .001;
		elapsed = time - startTime;
		if(elapsed > totalTime)
			break;
		
		fraction = elapsed / totalTime;
			
		fileNumber = Int(fraction * numFiles);
		
		level.hudelem_status Setvalue(fileNumber);
		
		waitframe();
	}	
}

smoke_large_drive()
{
	smoke_origin = GetStructarray( "origin_smoke_large_drive", "targetname" );		
	fog_origin = GetStructarray( "origin_fog_drive", "targetname" );		
	
	foreach( struct in smoke_origin)
	{
		playFX( getfx( "somke_large_low" ), struct.origin );
	}
	
	foreach( struct in fog_origin)
	{
		playFX( getfx( "fog_drive" ), struct.origin );
	}
}	

gas_staging_room()
{
	flag_wait( "flag_elevator_shaft_retreat" );
	
//	grenade_origin = getstruct( "org_grenade_staging_room", "targetname" );
//	grenade_target = getstruct( "target_grenade_staging_room", "targetname" );
	
//	MagicGrenade( "smoke_grenade_american", grenade_origin, grenade_target, 1 );

//	smoke_origin = GetStruct( "smoke_origin_staging_room", "targetname" );
//	playFX( getfx( "smokescreen" ), smoke_origin.origin );
//	smoke_origin Playsound ( "exp_9_bang", "sound_played" );
	
	gas_origin_ground = GetStructarray( "gas_origin_staging_room", "targetname" );		
	
	foreach( struct in gas_origin_ground)
	{
		playFX( getfx( "poisonous_gas_ground_paris_200_bookstore" ), struct.origin );
	}

}

gas_corridor()
{
	flag_wait( "flag_combat_boiler_room_retreat" );
	
	gas_origin_ground = GetStructarray( "gas_origin_corridor", "targetname" );		
	
	foreach( struct in gas_origin_ground)
	{
		playFX( getfx( "poisonous_gas_ground_paris_200_bookstore" ), struct.origin );
	}
	
	gas_origin_wall = GetStructarray( "gas_origin_corridor_wall", "targetname" );		
	
	foreach( struct in gas_origin_wall)
	{
		playFX( getfx( "poisonous_gas_wallCrawl_paris" ), struct.origin );
	}
}

gas_boiler_room()
{
	flag_wait("flag_combat_apartment_retreat");
	
	gas_origin_ground = GetStructarray( "gas_origin_boiler_room", "targetname" );		
	
	foreach( struct in gas_origin_ground)
	{
		playFX( getfx( "poisonous_gas_ground_paris_200_bookstore" ), struct.origin );
	}
}

gas_apartment_exit()
{
	flag_wait( "flag_apartment_combat" );
	
	gas_origin_ground = GetStructarray( "gas_origin_apartment_exit", "targetname" );		
	
	foreach( struct in gas_origin_ground)
	{
		playFX( getfx( "poisonous_gas_ground_paris_200_bookstore" ), struct.origin );
	}
}

smoke_ramp_drive()
{
	flag_wait("flag_gallery_combat");
	
	smoke_origin = GetStructarray( "smoke_ramp_drive", "targetname" );		
	
	foreach( struct in smoke_origin)
	{
		playFX( getfx( "somke_ambient_large" ), struct.origin );
	}
}

smoke_shaft()
{
	flag_wait("flag_combat_sewer_corridor_wave_2");
	
	smoke_origin = GetStructarray( "smoke_shaft", "targetname" );		
	
	foreach( struct in smoke_origin)
	{
		playFX( getfx( "shaft_smoke" ), struct.origin );
	}
}

spawn_flood_with_func( tname, spawn_func )
{
	spawners = getentarray( tname, "targetname" );

	assert(spawners.size > 0);
	
	if(isdefined(spawn_func))
		array_spawn_function( spawners, spawn_func );

	maps\_spawner::flood_spawner_scripted( spawners );	
}

spawn_with_func( tname, spawn_func )
{
	spawners = getentarray( tname, "targetname" );

	assert(spawners.size > 0);
	
	if(isdefined(spawn_func))
		array_spawn_function( spawners, spawn_func );
		
	array_spawn( spawners, true );
}

spawn_limit_by_player_count( tname )
{
	spawners = getentarray( tname, "targetname" );
	spawners = array_randomize( spawners );
	assert(spawners.size == 2);
	
	foreach( spawner in spawners )
	{
		if(IsDefined(spawner))
		{
			guy = spawner spawn_ai(true);
			if(isdefined(guy) && level.players.size == 1 )
				break;
		}
	}	
}

add_enemy_flashlight()
{
	PlayFXOnTag( getfx("flashlight_ai"), self, "tag_flash" );
	self.have_flashlight = true;
}

turret_convergence_tweak()
{
	foreach( mg in self.mgturret )
	{
		mg setconvergencetime( 4.5, "yaw" );
		mg set_baseaccuracy( 0.12 );
	}	
}		

setup_poison_wake_volumes()
{
		poison_wake_triggers = getentarray( "poison_wake_volume", "targetname" );
		array_thread( poison_wake_triggers, ::poison_wake_trigger_think);
}

poison_wake_trigger_think()
{
	for( ;; )
	{
		self waittill( "trigger", other );
		if (other ent_flag_exist("in_poison_volume"))
			{}
		else
			other ent_flag_init("in_poison_volume");
		
		// TODO: logic for other players?
		if (DistanceSquared( other.origin, level.player.origin ) < 9250000)
		{	
			if (other ent_flag("in_poison_volume"))
			{}
			else
			{
				other thread poison_wakefx(self);
				other ent_flag_set ("in_poison_volume");
				/*if(isDefined (other.ainame))
					print(other.ainame + "has entered the poison volume\n");
				else
					print("player has entered the poison volume\n");*/
			}
		}
	}
}

poison_wakefx( parentTrigger )
{
	self endon( "death" );

	speed = 160;
	for ( ;; )
	{
		if (self IsTouching(parentTrigger))
		{
			//loop fx based off of player speed
			if (speed > 0)
				wait(max(( 1 - (speed / 120)),0.1) );
			else
				wait (0.15);
			//if ( trace[ "surfacetype" ] != "wood" )
				//continue;
	
			fx = parentTrigger.script_fxid;
			if ( IsPlayer( self ) )
			{
				speed = Distance( self GetVelocity(), ( 0, 0, 0 ) );
				if ( speed < 5 )
				{
					fx = "null";
				}
			}
			if ( IsAI( self ) )
			{
				speed = Distance( self.velocity, ( 0, 0, 0 ) );
				if ( speed < 5 )
				{
					fx = "null";
				}
			}
			
			if (fx != "null")
			{
				start = self.origin + ( 0, 0, 64 );
				end = self.origin - ( 0, 0, 150 );
				trace = BulletTrace( start, end, false, undefined );
				water_fx = getfx( fx );
				start = trace[ "position" ];
				//angles = vectortoangles( trace[ "normal" ] );
				angles = (0,self.angles[1],0);
				forward = anglestoforward( angles );
				up = anglestoup( angles );
				PlayFX( water_fx, start, up, forward );
			}

		}
		else
		{	
			self ent_flag_clear("in_poison_volume");
				/*if(isDefined (self.ainame))
					print(self.ainame + "has exited the poison volume\n");
				else
					print("player has exited the poison volume\n");*/
			return;
		}
	}
}

camera_shake_during_ride()
{
	level endon("flag_jeep_path_complete");
	level.jeep endon("death");

	max_mph = 40;  // after this speed the shake doesn't get more intense
	
	for(;;)
	{
		mph = Min(level.jeep Vehicle_GetSpeed(), max_mph);
		if(mph > 5)
		{
			intensity = 0.1 * mph / 25;
			Earthquake(intensity, 2, level.jeep.origin, 512);
		}

		wait RandomFloatRange(.1, .3);
	}
}

text_ping(text)
{
	Assert(IsPlayer(self));
	Assert(IsDefined(text));

	// don't kill the old ping thread if the text hasn't changed.
	if(IsDefined(self.text_ping_text) && self.text_ping_text == text)
		return;
	
	text_ping_clear();

	self.text_ping_text = text;
	
	// thread it off so there are no endons		
	thread text_ping_internal();
}

text_ping_internal()
{	
	// should be no endons at this point.
	Assert(IsDefined(self.text_ping_text));
	Assert(isplayer(self));
	
	hud_item = self maps\_shg_common::create_splitscreen_safe_hud_item( 3.5, 0, self.text_ping_text );
	hud_item.alignx = "center";
	hud_item.horzAlign = "center";

	text_ping_internal_flash(hud_item);

	hud_item.alpha = 0.5;
	hud_item FadeOverTime( 0.25 );
	hud_item.alpha = 0;
	wait 0.25;

	if(IsDefined(hud_item))
		hud_item Destroy();	
}

text_ping_internal_flash(hud_item)
{
	self endon("death");
	self endon("text_ping_clear");		
	
	while(true)
	{
		hud_item.alpha = 1;
		hud_item FadeOverTime( 1 ) ;
		hud_item.alpha = 0.5;
		
		hud_item.fontscale = 1.5;
		hud_item ChangeFontScaleOverTime( 1 );
		hud_item.fontscale = 1;
		
		wait 1;
	}
}

text_ping_clear()
{
	Assert(IsPlayer(self));
	
	self notify("text_ping_clear");	
	self.text_ping_text = undefined;
}

player_puts_gasmask_on()
{
	Assert(IsPlayer(self));	
	
	self ent_flag_init("gasmask_is_on");
		
	self thread gas_heartbeat();
	self DisableWeapons();
	self SetMoveSpeedScale( .25 );
	self AllowJump( false );
	self AllowSprint( false );
	
	wait 4;
	// will be stopped when should_stop_gasmask_hint() returns true (setup in main())
	display_hint_timeout( "gasmask_hint" );
	
	
	self NotifyOnPlayerCommand("gasmask_on_pressed", "+actionslot 2");
	
	self waittill("gasmask_on_pressed");
	
	self ent_flag_set("gasmask_is_on");
	self gasmask_on_player_so( true, 1.0, 1.0 );
	self thread player_gasmask_breathing();
	
	self enableweapons();
	self SetMoveSpeedScale( 1 );
	self AllowJump( true );
	self AllowSprint( true );
}

gasmask_on_player_so(bFadeIn, fadeOutTime, fadeInTime, darkTime)
{
	Assert(IsPlayer(self));	
	
	if(!IsDefined(bFadeIn)) bFadeIn = true;
	if(!IsDefined(fadeOutTime)) fadeOutTime = 0;
	if(!IsDefined(fadeInTime)) fadeInTime = 1;
	if(!IsDefined(darkTime)) darkTime = .25;
	
	if(bFadeIn)
	{
		fade_out( fadeOutTime );
	}
	
	SetHUDLighting( true );

	self.gasmask_hud_elem = NewClientHudElem( self ); 
	self.gasmask_hud_elem.x = 0;
	self.gasmask_hud_elem.y = 0;
	self.gasmask_hud_elem.alignX = "left";
	self.gasmask_hud_elem.alignY = "top";
	self.gasmask_hud_elem.horzAlign = "fullscreen";
	self.gasmask_hud_elem.vertAlign = "fullscreen";
	self.gasmask_hud_elem.foreground = false;
	self.gasmask_hud_elem.sort = -10; // trying to be behind introscreen_generic_black_fade_in	
	self.gasmask_hud_elem SetShader("gasmask_overlay_delta2", 650, 490);
	self.gasmask_hud_elem.archived = true;
	self.gasmask_hud_elem.hidein3rdperson = true;
	self.gasmask_hud_elem.alpha = 1.0;
	
	thread vision_set_fog_changes( "paris_gasmask", .5 );

	thread bob_mask( self.gasmask_hud_elem );
		
	if(bFadeIn)
	{
		wait( darkTime );
		fade_in( fadeInTime );
	}
}

player_gasmask_breathing()
{
	delay = 1.0;
	self endon( "death" );
	
	while ( 1 )
	{
		self play_sound_on_entity( "breathing_gasmask" );
		wait( delay );
	}
}

should_stop_gasmask_hint()
{
	return ent_flag("gasmask_is_on");	
}

gas_heartbeat()
{
	heartbeat_period_start = .8;
	heartbeat_period_end = .1;
	heartbeat_change_time = 8;
	
	self endon( "death" );

	wait 2;
	
	thread player_breathing_hurt();
	thread player_limp();
		
	start_time_ms = GetTime();
	
	while ( !ent_flag("gasmask_is_on") )
	{
		level.player thread play_sound_on_entity( "breathing_heartbeat" );
		wait 0.05;
		self DoDamage(20, self.origin);
		self PlayRumbleOnEntity( "damage_light" );
		wait linear_map_clamp((GetTime() - start_time_ms) * .001, 0, heartbeat_change_time, heartbeat_period_start, heartbeat_period_end);
		
		wait( 0 + RandomFloat( 0.1 ) );
	}
}

player_breathing_hurt()
{
	while ( !ent_flag("gasmask_is_on") )
	{
		level.player play_sound_on_entity( "breathing_hurt_start" );
		wait(RandomFloatRange(.75, 3));
	}
	
	level.player play_sound_on_entity( "weap_sniper_breathgasp" );
}

player_limp()
{
	level endon( "start_blackout_anim" );
			
	self.stumble_ref = Spawn( "script_model", ( 0, 0, 0 ) );
	self PlayerSetGroundReferenceEnt( self.stumble_ref );
	self thread player_random_blur();

	while ( !ent_flag("gasmask_is_on") )
	{
		velocity = self GetVelocity();
		player_speed = abs( velocity [ 0 ] ) + abs( velocity[ 1 ] );

		if ( player_speed < 5 )
		{
			wait 0.05;
			continue;
		}

		//TODO: FIX THIS MAGIC NUMBER
		speed_multiplier = player_speed / 75;

		p = RandomFloatRange( 3, 5 );
		if ( RandomInt( 100 ) < 20 )
			p *= 3;
		r = RandomFloatRange( 3, 7 );
		y = RandomFloatRange( -8, -2 );

		stumble_angles = ( p, y, r );
		//stumble_angles = vector_multiply( stumble_angles, speed_multiplier );
		stumble_angles = stumble_angles * speed_multiplier;

		stumble_time = RandomFloatRange( .35, .45 );
		recover_time = RandomFloatRange( .65, .8 );

		stumble( stumble_angles, stumble_time, recover_time );
	}
	
	self PlayerSetGroundReferenceEnt( undefined );		
	self.stumble_ref delete();
}

stumble( stumble_angles, stumble_time, recover_time)
{
	assert(isdefined(self.stumble_ref));
	level endon( "death" );

	stumble_angles = adjust_angles_to_player( stumble_angles );

	self.stumble_ref RotateTo( stumble_angles, stumble_time, ( stumble_time / 4 * 3 ), ( stumble_time / 4 ) );
	self.stumble_ref waittill( "rotatedone" );

	base_angles = ( RandomFloat( 4 ) - 4, RandomFloat( 5 ), 0 );
	base_angles = adjust_angles_to_player( base_angles );

	self.stumble_ref RotateTo( base_angles, recover_time, 0, recover_time / 2 );
	self.stumble_ref waittill( "rotatedone" );
}

adjust_angles_to_player( stumble_angles )
{
	pa = stumble_angles[ 0 ];
	ra = stumble_angles[ 2 ];

	rv = AnglesToRight( level.player.angles );
	fv = AnglesToForward( level.player.angles );

	rva = ( rv[ 0 ], 0, rv[ 1 ] * - 1 );
	fva = ( fv[ 0 ], 0, fv[ 1 ] * - 1 );
	angles = ( rva* pa );
	angles = angles + ( fva* ra );
	return angles + ( 0, stumble_angles[ 1 ], 0 );
}

player_random_blur()
{
	level endon( "death" );

	while ( !ent_flag("gasmask_is_on") )
	{
		wait 0.05;

		blur = RandomInt( 3 ) + 2;
		blur_time = RandomFloatRange( 0.3, 0.7 );
		recovery_time = RandomFloatRange( 0.3, 1 );
		self setblurforplayer( blur * 1.2, blur_time );
		wait blur_time;
		wait blur_time;
		SetBlur( 0, recovery_time );
		wait 2;
	}
}

mgon_delay(delay)
{
	self endon("death");
	self endon("delete");
	wait delay;
	
	// somehow when the player dies the turrets can can get deleted, leaving removed entity references in the mgturret array
	if(!IsDefined(self)) return;
	if(!IsDefined(self.mgturret)) return;
	foreach(turret in self.mgturret)
		if(!IsDefined(turret))
			return;
	
	mgon();
	
}

so_gaz_targeting()
{
	/#	
	//self thread debug_gaz_targeting();
	#/
	
	if(!IsDefined(self)) return;
	self endon("death");
	
	self.hit_friendly_gaz_time = 0;
	self thread so_gaz_monitor_friendly_fire();
	
	random_target_time = GetTime();
	target_player = undefined;
	
	while(IsDefined(self) && IsDefined(self.mgturret))
	{
		time = GetTime();
	
		if(time >= random_target_time)
	{
			target_player = random(level.players);
			random_target_time = time + RandomIntRange(2000, 5000);
			// /# Print3d(self.origin, "chose player"); #/
		}

		can_shoot = true;
		foreach( mg in self.mgturret )
		{
			if(IsDefined(mg) && !can_shoot_player(mg, target_player))
			{
				can_shoot = false;
				// /# Print3d(self.origin, "failed raycast"); #/
				break;
			}
		}	
			
		if(time - self.hit_friendly_gaz_time < 500)
		{
			can_shoot = false;
			// /# Print3d(self.origin, "hit friendly"); #/
}

		foreach(mg in self.mgturret)
{
			if(IsDefined(mg))
	{
				mg SetTargetEntity(target_player, (0, 0, 32));
	}
}

		if(can_shoot)
{
			foreach( mg in self.mgturret )
	{
				if(IsDefined(mg))
		{
					mg SetMode("manual_ai");
					mg TurretFireEnable();
		}
	}
}
		else
		{
			foreach( mg in self.mgturret )
{
				if(IsDefined(mg))
	{
					mg SetMode("manual_ai");
					//mg ClearTargetEntity();
					mg TurretFireDisable();
				}
			}
		}
		
		wait 0.05;
	}
}

so_gaz_monitor_friendly_fire()
{
	self endon( "death" );
	while (1)
	{
		self waittill ( "damage", amount, attacker, direction_vec, point, type );
		if( !array_contains(level.players, attacker) )
		{
			self.health = self.health + int(amount);
			
			if(IsAI(attacker))
			{
				turret = attacker GetTurret();
				if(IsDefined(turret))
			{
					if(IsDefined(turret.ownervehicle))
				{
						turret.ownervehicle.hit_friendly_gaz_time = GetTime();				
				}
			}
			}
		}
	}
}


can_shoot_player(turret, player)
{
	min_cos_angle = Cos(20);
	
	head = player GetEye();
	flash_origin = turret gettagorigin("tag_flash");
	flash_vector = AnglesToForward(turret gettagangles("tag_flash"));
			
	if ( VectorDot(VectorNormalize(head - flash_origin), flash_vector) < min_cos_angle )
		return false;
			
	trace = bullettrace( flash_origin, head, false, level.jeep );
	if ( isdefined( trace["entity"]) && !array_contains(level.players, trace["entity"]))
		return false;
			
	return true;	
}

/#
debug_gaz_targeting()
{
	self endon("death");

	for(;; waitframe())
	{
		foreach(mg in self.mgturret)
		{
			target = mg GetTurretTarget(false);
			if(IsDefined(target))
			{
				if(target == level.players[0])
					Print3D(self.origin + (0, 0, 96), "1", (1, 1, 1), 1, 10);
				else if(target == level.players[1])
					Print3D(self.origin + (0, 0, 96), "2", (1, 1, 1), 1, 10);
			}
		}
	}
}
#/

handle_end_of_game_bonuses()
{
	level.bonus1_num = 0;
	level.bonus2_num = 0;
	
	foreach (p in level.players)	
	{
		p.bonus_1 = 0;
		p.bonus_2 = 0;
	}
}

monitor_attacker()
{
	level.bonus1_num++;
	
	self waittill( "death", attacker, cause );
	
	if (isplayer(attacker))
	{
		attacker.bonus_1++;
		attacker notify ( "heli_kill", attacker.bonus_1 );
		/#
		debug_print( "heli killed" );
		#/
	}		
}

monitor_explosive_kills()
{
	level endon( "so_jeep_paris_b_complete" );
	level endon ( "missionfailed" );

	self.bonus_2 = 0;
	
	while( true )
	{
		if( IsDefined( self.stats[ "kills_explosives" ] ) )
		{
			if( self.bonus_2 != self.stats[ "kills_explosives" ] )
			{
				self.bonus_2 = self.stats[ "kills_explosives" ];
				self notify( "explosion_kill", self.bonus_2 );
			}
			
		}
		wait( 0.05 );
	}
}		

monitor_damage_type()
{
	self endon( "jugg_bonus_fail" );
	
	self thread jugg_bonus_fail_on_nonexplosive_damage();
	
	self waittill ( "death", attacker, type );
	
	if ( isplayer( attacker ))
	{
		attacker.bonus_2++;
		attacker notify ( "bonus2_count", attacker.bonus_2 );
	}	
}

jugg_bonus_fail_on_nonexplosive_damage()
{
	self endon("death");
	
	while(true)
	{
		self waittill("damage", amount, attacker, direction_vec, point, type, modelName, tagName);
		if(!is_bonus_weapon(type))
		{
			self notify("jugg_bonus_fail");
			/#
			debug_print( "jugg bonus fail" );
			#/
			return;
		}
	}	
}

is_bonus_weapon( type )
{
	return isdefined(type) && (type == "MOD_GRENADE" ||  type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" || type == "MOD_IMPACT" );	
}

driving_anims(vehicle, driver)
{
	vehicle endon("stop_driving_anims");
	vehicle endon("death");
	driver endon("death");
	
	// if the vehicle rotates at the given rate while going the given speed, then
	// the driver will blend fully to the turn pose.
	max_turn_yaw_rate_dps = 35;
	max_turn_speed_mph = 20;

	blend_time = 0.05;
	
	turn_amount_smoothing = .4;

	vehicle thread anim_loop_solo(driver, "drive_idle", "stop_driving_anims", "tag_driver" );
	
	dt = .05;
	inv_dt = 20;
	last_yaw_degrees = vehicle.angles[1];
	turn_amount = 0;
	for(;; waitframe())
	{
		yaw_rate_dps = AngleClamp180(vehicle.angles[1] - last_yaw_degrees) * inv_dt;
		last_yaw_degrees = vehicle.angles[1];
		
		speed_fraction = max(vehicle Vehicle_GetSpeed() / max_turn_speed_mph, 0.01);
		yaw_fraction = yaw_rate_dps / max_turn_yaw_rate_dps;
		
		turn_amount = linear_interpolate(turn_amount_smoothing, clamp(yaw_fraction / speed_fraction, -1, 1), turn_amount);

		///# debug_print("amount " + turn_amount); #/
		
		// so that our SetFlaggedAnim calls happen after anim_loop() restarts the scripted animations at the end of the loop
		// fixes driver getting away from his correct position.
		waittillframeend;
		
		vehicle driving_anims_set_turn_amount(turn_amount, blend_time);
		driver driving_anims_set_turn_amount(turn_amount, blend_time);
	}
}

driving_anims_set_turn_amount(turn_amount, blend_time)
{
	// for flagged anims, can't set a weight of zero.
	epsilon = 0.0001;
	
	center_anim = self getanim("drive_idle")[0];
	right_anim = self getanim("drive_turn_pose_right")[0];
	left_anim = self getanim("drive_turn_pose_left")[0];
		
	if(turn_amount < 0)
	{		
		self SetAnim(right_anim, clamp(0 - turn_amount, epsilon, 1), blend_time, 1);
		self SetAnim(left_anim, epsilon, blend_time, 1);
		// the "looping anim" flag is necessary so anim_loop gets its end notify and restarts the animation correctly
		self SetFlaggedAnim("looping anim", center_anim, clamp(1 + turn_amount, epsilon, 1), blend_time, 1);
	}
	else
	{
		self SetAnim(right_anim, epsilon, blend_time, 1);
		self SetAnim(left_anim, clamp(turn_amount, epsilon, 1), blend_time, 1);
		self SetFlaggedAnim("looping anim", center_anim, clamp(1 - turn_amount, epsilon, 1), blend_time, 1);
	}

	// don't allow the animation to reach the end, because if anim_loop_solo() restarts the loop with AnimScripted, it will cause a pop
	// .075 is between 1 and 2 server frames
	if(self GetAnimTime(center_anim) > 1 - (.075 / GetAnimLength(center_anim)) )
	{
		self SetAnimTime(center_anim, 0);
	}
}

stop_driving_anims(vehicle)
{
	vehicle notify("stop_driving_anims");
}

jugg_givexp()
{
	self waittill ( "death", attacker );
	
	if ( isdefined ( attacker ) && isplayer ( attacker ) )
		attacker givexp ( "jugg", 400 );
			
}