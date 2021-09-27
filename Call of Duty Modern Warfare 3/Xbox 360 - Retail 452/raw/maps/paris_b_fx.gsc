#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_anim;
#include maps\_vehicle;


main()
{
	thread precacheFX();
	maps\createfx\paris_b_fx::main();
	maps\_shg_fx::setup_shg_fx();
	
	flag_init( "game_fx_started" );
	flag_init("flag_catacombs_enemy_gate_gag_vfx");
	flag_init("player_rooftop_jump_complete");
	flag_init("msg_fx_staircase_helis");
	flag_init("msg_fx_chase_start_helis");
	flag_init("msg_fx_canal_helis");
	flag_init("msg_fx_hood_impacts");
	flag_init("flag_player_in_truck");
	flag_init("msg_fx_landing_hit");
	flag_init("msg_fx_umbrella1");
	flag_init("msg_fx_umbrella2");
	flag_init("msg_fx_umbrella3");
	flag_init("flag_final_crash_wall_impact_1");
	flag_init("enable_distant_bomb_shakes");
	flag_init("flag_slide_sparks_end");
	flag_init("msg_fx_end_drag_glass");
	flag_init("msg_fx_sedan_sparks_left_start");
	flag_init("msg_fx_sedan_sparks_left_stop");
	flag_init("msg_fx_sedan_sparks_right_start");
	flag_init("msg_fx_sedan_sparks_right_stop");
	


	//level thread convertOneShot();




	/*********************************************************
	EXPLODER NUMBERS & FX ZONE WATCHERS
	
	**********************************************************/
	//10000	=	ambient land exploder
	//10001 =	ambient aa fire
	
	//5900 = underground: directly around bottom of manhole.  This is to turn off light beams so they don't penetrate floor when you go downstairs.
	//6000 = underground: manhole ladder and stairway down to the entrance of sewer
	//6100 = underground: sewer
	//6200 = underground: catacomb start to skull chamber
	//6300 = underground: catacomb communication site
	//6400 = underground: staircase up to concrete tubeway
	//6500 = underground: weapon storage area up to exit path to the van site courtyard
	//7000 = van site battle
	//8000 = van chase: street 1
	//8100 = van chase: street 2
	//8200 = van chase: street 3
	//8300 = van chase: street 4, river bank
	//8400 = van chase: street 5,
	//8500 = van chase: galleria A
	//8600 = van chase: galleria B 
	//8700 = van chase: street 6, toward the end of van chase
	//9000 = ending scene courtyard

	
	//thread fx_zone_watcher(1000,"msg_fx_zone1000");//rooftop to bookstore

	thread fx_zone_watcher(5900,"msg_fx_zone5900");//underground: directly around bottom of manhole.
	thread fx_zone_watcher(6000,"msg_fx_zone6000");//underground: manhole ladder and stairway down to the entrance of sewer
	thread fx_zone_watcher(6100,"msg_fx_zone6100");//underground: sewer
	thread fx_zone_watcher(6200,"msg_fx_zone6200");//underground: catacomb start to skull chamber
	thread fx_zone_watcher(6300,"msg_fx_zone6300");//underground: catacomb communication site
	thread fx_zone_watcher(6400,"msg_fx_zone6400");//underground: staircase up to concrete tubeway
	thread fx_zone_watcher(6500,"msg_fx_zone6500");//underground: weapon storage area up to exit path to the van site courtyard
	thread fx_zone_watcher(7000,"msg_fx_zone7000");//van site battle
	thread fx_zone_watcher(8000,"msg_fx_zone8000");//van chase: street 1
	thread fx_zone_watcher(8100,"msg_fx_zone8100");//van chase: street 2
	thread fx_zone_watcher(8200,"msg_fx_zone8200");//van chase: street 3
	thread fx_zone_watcher(8300,"msg_fx_zone8300");//van chase: street 4, river bank
	thread fx_zone_watcher(8400,"msg_fx_zone8400");//van chase: street 5,
	thread fx_zone_watcher(8500,"msg_fx_zone8500");//van chase: galleria A
	thread fx_zone_watcher(8600,"msg_fx_zone8600");//van chase: galleria B 
	thread fx_zone_watcher(8700,"msg_fx_zone8700");//van chase: street 6, toward the end of van chase
	thread fx_zone_watcher(9000,"msg_fx_zone9000");//ending scene courtyard


	/*********************************************************
	START FX LOGIC THREADS HERE
	
	**********************************************************/
	//thread start_ambient_landexplosions();
	//thread start_distant_bombShakes();
	thread fx_trigger_manual_bombshake();
	thread setup_poison_wake_volumes();
	thread catacombs_enemy_gate_gag_vfx();
	thread loop_chase_start_hind();
	thread start_ambient_flak();
	thread fx_van_hit_fences();
	thread fx_van_galleria_physics_wake();
	thread fx_umbrella_spin("umbrella1");
	thread fx_umbrella_spin("umbrella3");
	thread treadfx_override();
	thread play_first_bombshake();
	thread dynamic_lights_all_models();
	thread fx_fruit_cart_destroyables();
	thread init_smVals();
	thread fx_turn_off_bombshakes();
	thread fx_hide_skidmarks();
	thread fx_sedan_escape_sparks_left();
	thread fx_sedan_escape_sparks_right();
	thread fx_toggle_dlights();
	
	PreCacheShellShock( "default" );
}


precacheFX()
{
	/*===========================
	placeholder vfx
	===========================*/
	level._effect[ "wall_destruction" ] 								= loadfx( "explosions/transformer_explosion" );
	level._effect[ "large_column" ]			 							= loadfx( "props/dcburning_pillars" );
	level._effect[ "large_vehicle_explosion" ] 							= loadfx( "explosions/large_vehicle_explosion" );
	level._effect[ "glass_shatter_large" ] 									= loadfx( "misc/glass_falling_shatter" );
	
	level._effect[ "ground_smoke_dcburning1200x1200" ]					= loadfx( "smoke/ground_smoke1200x1200_dcburning" );
	level._effect[ "firelp_small_pm" ]									= LoadFX( "fire/firelp_small_pm" );
	level._effect[ "firelp_med_pm" ]									= LoadFX( "fire/firelp_med_pm" );
	level._effect[ "firelp_large_pm" ]									= LoadFX( "fire/firelp_large_pm" );
	level._effect[ "heli_strafe_impact" ]								= LoadFX( "impacts/large_ac130_concrete_paris" );
	
	/*===========================
	catacomb sewage vfx
	===========================*/
	//enemy flashligt
	level._effect[ "flashlight_ai" ]												= loadfx( "misc/flashlight_lensflare" );
	
	//ally flashlight (spotlight)
	level._effect["flashlight"] 														= loadfx( "misc/flashlight_spotlight_paris" );
	level._effect["flashlight_bounce"] 											= loadfx( "misc/flashlight_pointlight_paris" );
	
	//Bomb hits dust falling and pipe steam in catacomb
	level._effect["falling_dirt_catacomb"]									= loadfx ("dust/falling_dirt_light");	
	level._effect["pipe_steam"]															= loadfx ("impacts/pipe_steam_small");
	level._effect["pipe_steam_looping"]															= loadfx ("impacts/pipe_steam_looping");
	level._effect["pipe_steam_looping_small"]															= loadfx ("impacts/pipe_steam_looping_small");
	level._effect["falling_dirt_dark_2_paris"]									= loadfx ("dust/falling_dirt_dark_2_paris");	
	level._effect["falling_dirt_dark_2_runner_paris"]									= loadfx ("dust/falling_dirt_dark_2_runner_paris");	
	level._effect["falling_dirt_light_2_runner_paris"]									= loadfx ("dust/falling_dirt_light_2_runner_paris");	
	level._effect["elevator_shaft_junk"]									= loadfx ("maps/paris/elevator_shaft_junk");	
	
	//flare and lights
	level._effect[ "flare_catacombs" ]			 								= loadfx( "misc/flare_ambient_paris" );
	level._effect[ "flare_catacombs_moving" ]			 								= loadfx( "misc/flare_ambient_paris_moving" );
	level._effect[ "flare_catacombs_mist" ]			 								= loadfx( "misc/flare_ambient_paris_mist" );
	level._effect[ "lights_spotlight_fan_shadow" ]			 								= loadfx( "lights/lights_spotlight_fan_shadow" );
	level._effect[ "lights_uplight_haze_large" ]			 								= loadfx( "lights/lights_uplight_haze_large" );
	level._effect["lights_conelight_smokey"]											= loadfx("lights/lights_conelight_smokey");
	level._effect["lights_worklight_flare"]											= loadfx("lights/lights_worklight_flare");
	level._effect["lights_tvlight_smokey_catacombs"]											= loadfx("maps/paris/lights_tvlight_smokey_catacombs");
	level._effect["light_glow_walllight_white"]											= loadfx("misc/light_glow_walllight_white");
	level._effect["light_glow_walllight_white_flicker"]											= loadfx("misc/light_glow_walllight_white_flicker");
	
	//door kick dust
	level._effect[ "door_kick" ]			 											= loadfx( "dust/door_kick_catacombs" );
	level._effect[ "falling_dirt_groundspawn" ]			 				= loadfx( "dust/falling_dirt_groundspawn" );
	
	//ambush gate dust
	level._effect[ "ambush_gate_dust" ]			 											= loadfx( "maps/paris/ambush_gate_dust" );
	
	//table flip fx
	level._effect[ "table_flip_dust" ]			 											= loadfx( "maps/paris/table_flip_dust" );
	level._effect[ "large_brick_impact" ]			 											= loadfx( "impacts/expRound_brick" );
	
	//all water elements	
	level._effect[ "water_noise" ]														= loadfx( "weather/water_noise" );
	level._effect[ "water_drips_fat_fast_speed" ]							= loadfx( "water/water_drips_fat_fast_speed" );
	level._effect[ "water_drips_fat_slow_speed" ]							= loadfx( "water/water_drips_fat_slow_speed" );
	level._effect[ "water_drips_fat_slow_speed_catacombs" ]= loadfx( "water/water_drips_fat_slow_speed_catacombs" );
	level._effect[ "drips_fast" ]			 												= loadfx( "misc/drips_fast" );
	level._effect[ "drips_slow" ]			 												= loadfx( "misc/drips_slow" );
	level._effect[ "drips_splash_tiny" ]			 								= loadfx( "water/drips_splash_tiny" );
	level._effect[ "mist_drifting_catacomb" ]			 						= loadfx( "smoke/mist_drifting_catacomb" );
	level._effect[ "waterfall_drainage_splash_dcemp_dark" ]				= loadfx( "water/waterfall_drainage_splash_dcemp_dark" );
	level._effect[ "falling_water_trickle_infrequent" ]				= loadfx( "water/falling_water_trickle_infrequent" );
	level._effect[ "water_pipe_spray_dark" ]												= loadfx( "water/water_pipe_spray_dark" );
	level._effect[ "powerline_runner_sewer_paris"]						= loadfx ("maps/paris/powerline_runner_sewer_paris");	
	level._effect[ "water_flow_sewage_catacomb" ]						= loadfx( "water/water_flow_sewage_catacomb" );
	level._effect[ "waterfall_splash_large" ]								= loadfx( "water/waterfall_splash_large" );
	level._effect[ "waterfall_drainage_splash_falling_dark" ]		= loadfx( "water/waterfall_drainage_splash_falling_dark" );
	level._effect[ "waterfall_splash_large_drops" ]					= loadfx( "water/waterfall_splash_large_drops" );
	level._effect[ "waterfall_splash_falling_mist" ]				= loadfx( "water/waterfall_splash_falling_mist" );
	level._effect[ "waterfall_splash_medium_dark" ]							= loadfx( "water/waterfall_splash_medium_dark" );
	level._effect[ "waterfall_drainage_distortion" ]				= loadfx( "water/waterfall_drainage_distortion" );
	level._effect[ "waterfall_mist" ]			 									= loadfx( "water/waterfall_mist" );
	level._effect[ "waterfall_drainage_short_dcemp_dark" ]				= loadfx( "water/waterfall_drainage_short_dcemp_dark" );
	level._effect[ "waterfall_splash_falling_mist_dark" ]				= loadfx( "water/waterfall_splash_falling_mist_dark" );

	
	//ambient vfx in catacomb
	level._effect[ "ground_dust_narrow_light" ]			 											= loadfx( "dust/ground_dust_narrow_light" );
	level._effect[ "ground_mist_narrow_dark" ]			 											= loadfx( "dust/ground_mist_narrow_dark" );
	level._effect[ "ground_mist_warm" ]			 											= loadfx( "dust/ground_mist_warm" );
	level._effect[ "fog_ground_200_light_lit" ]			 											= loadfx( "smoke/fog_ground_200_light_lit" );
	level._effect[ "smoke_warm_room_linger_s" ]			 											= loadfx( "smoke/smoke_warm_room_linger_s" );
	level._effect[ "rat_scurry_x10" ]			 																= loadfx( "animals/rat_scurry_x10" );
	level._effect[ "rat_scurry_x10_leftturn" ]			 											= loadfx( "animals/rat_scurry_x10_leftturn" );
	level._effect[ "catacombs_mist_wake" ]			 											= loadfx( "smoke/catacombs_mist_wake" );
	level._effect[ "amb_dust_small" ]			 											= loadfx( "smoke/amb_dust_small" );
	level._effect[ "lighthaze_sewer_ladder" ]			 											= loadfx( "maps/paris/lighthaze_sewer_ladder" );
	level._effect[ "lighthaze_sewer_ladder_distant" ]			 											= loadfx( "maps/paris/lighthaze_sewer_ladder_distant" );
	level._effect[ "lighthaze_sewer_ladder_bottom" ]			 											= loadfx( "maps/paris/lighthaze_sewer_ladder_bottom" );
	level._effect[ "falling_dirt_light_2_paris" ]			 											= loadfx( "dust/falling_dirt_light_2_paris" );
	level._effect["lights_godray_default"]												= loadfx("lights/lights_conelight_default");
	
	//tank crush moment
	level._vehicle_effect[ "tankcrush" ][ "window_med" ]	 = loadfx( "props/car_glass_med" );
	level._vehicle_effect[ "tankcrush" ][ "window_large" ]	 = loadfx( "props/car_glass_large" );

	//other vehicle fx
	level._effect[ "littlebird_exhaust" ]								= loadfx( "distortion/littlebird_exhaust" );
	level._effect[ "scripted_flashbang" ]								= loadfx( "explosions/flashbang" );
	level._effect[ "bmp_flash_wv" ]											= loadfx( "muzzleflashes/bmp_flash_wv" );
	level._effect[ "tread_dust_paris" ]			 						= loadfx( "treadfx/tread_dust_paris" );	
	level._effect[ "tread_dust_paris_small" ]			 						= loadfx( "treadfx/tread_dust_paris_small" );	
	level._effect[ "heli_dust_ambush" ]			 						= loadfx( "treadfx/heli_dust_ambush" );	
	level._effect[ "heli_water_paris" ]			 						= loadfx( "treadfx/heli_water_paris" );	
	level._effect[ "no_effect" ]			 									= loadfx( "misc/no_effect" );	
	level._effect[ "truck_sparks" ] 									= loadfx( "misc/vehicle_scrape_sparks_smokey" );
	level._effect[ "sedan_skidmarks" ] 									= loadfx( "treadfx/vehicle_skidmarks" );
	
	//car chase
	level._effect[ "dust_wind_fast_paper_oneshot" ]			 						= loadfx( "dust/dust_wind_fast_paper_oneshot" );
	level._effect[ "van_hood_impacts" ]			 						= loadfx( "maps/paris/van_hood_impacts" );
	level._effect[ "van_dashboard_glass" ]			 						= loadfx( "maps/paris/van_dashboard_glass" );
	level._effect[ "van_dashboard_glass_move" ]			 						= loadfx( "maps/paris/van_dashboard_glass_move" );
	level._effect[ "van_peelout" ]			 						= loadfx( "maps/paris/van_peelout" );
	level._effect[ "van_door_kick" ]			 						= loadfx( "maps/paris/van_door_kick" );
	level._effect[ "van_blockade_impact" ]			 						= loadfx( "maps/paris/van_blockade_impact" );
	level._effect[ "van_crash_1" ]			 						= loadfx( "maps/paris/van_crash_1" );
	level._effect[ "van_final_crash" ]			 						= loadfx( "maps/paris/van_final_crash" );
	level._effect[ "van_fence_impact" ]			 						= loadfx( "maps/paris/van_fence_impact" );
	level._effect[ "car_decal_spawner" ]			 						= loadfx( "maps/paris/car_decal_spawner" );
	level._effect[ "sedan_tire_smoketrail" ]			 						= loadfx( "maps/paris/sedan_tire_smoketrail" );
	level._effect[ "van_grill_smoke" ]			 						= loadfx( "maps/paris/van_grill_smoke" );
	level._effect[ "abrams_flash_wv_brightlite" ]			 						= loadfx( "muzzleflashes/abrams_flash_wv_brightlite" );
	level._effect[ "tankfall_dust_large" ]			 						= loadfx( "impacts/tankfall_dust_large" );
	level._effect[ "glass_punch_paris" ]			 						= loadfx( "maps/paris/glass_punch_paris" );
	level._effect[ "tank_shell_aftermath_paris" ]			 						= loadfx( "maps/paris/tank_shell_aftermath_paris" );
	level._effect[ "tread_burnout_reverse" ]			 						= loadfx( "treadfx/tread_burnout_reverse" );
	level._effect[ "window_hit_hood" ]			 						= loadfx( "maps/paris/window_hit_hood" );		
	level._effect[ "van_behindview_impact_planters" ]			 						= loadfx( "maps/paris/van_behindview_impact_planters" );
	level._effect[ "van_behindview_impact_flowers" ]			 						= loadfx( "maps/paris/van_behindview_impact_flowers" );
	level._effect[ "van_behindview_impact_diningset" ]			 						= loadfx( "maps/paris/van_behindview_impact_diningset" );
	level._effect[ "van_behindview_impact_topiaryright" ]			 						= loadfx( "maps/paris/van_behindview_impact_topiaryright" );
	level._effect[ "van_behindview_impact_topiaryleft" ]			 						= loadfx( "maps/paris/van_behindview_impact_topiaryleft" );
	level._effect[ "van_behindview_impact_fenceleft" ]			 						= loadfx( "maps/paris/van_behindview_impact_fenceleft" );
	level._effect[ "topiary_explosion_crash" ]			 						= loadfx( "maps/paris/topiary_explosion_crash" );
	level._effect[ "behindview_impact_fenceright" ]			 						= loadfx( "maps/paris/van_behindview_impact_fenceright" );
	level._effect[ "galleria_gate_open_1" ]			 						= loadfx( "maps/paris/galleria_gate_open_1" );
	level._effect[ "phone_kiosk_dest_sparks" ]			 						= loadfx( "props/phone_kiosk_dest_sparks" );
	level._effect[ "tankShellImpact" ]			 						= loadfx( "explosions/tankshell_wallImpact" );
	level._effect[ "fire_line_sm" ]			 						= loadfx( "fire/fire_line_sm" );
	level._effect[ "parking_lot_gate_down_dest" ]			 											= loadfx( "props/parking_lot_gate_down_dest" );
	level._effect[ "paris_gallery_metal_gates" ]			 											= loadfx( "props/paris_gallery_metal_gates" );
	level._effect[ "tire_blowout_parent" ]			 											= loadfx( "explosions/tire_blowout_parent" );
	level._effect[ "fire_falling_localized_runner_paris" ]			 											= loadfx( "fire/fire_falling_localized_runner_paris" );
	level._effect[ "blood_gaz_driver" ]								= loadfx( "misc/blood_gaz_driver" );
	level._effect[ "van_window_broken" ]							= loadfx( "props/car_glass_med" );
	level._effect[ "sedan_trunk_papers" ]			 						= loadfx( "maps/paris/sedan_trunk_papers" );
	level._effect[ "car_glass_large_moving" ]							= loadfx( "props/car_glass_large_moving" );
	level._effect[ "car_glass_med_moving" ]							= loadfx( "props/car_glass_med_moving" );
	level._effect[ "car_glass_med" ]							= loadfx( "props/car_glass_med" );
	level._effect[ "car_glass_sunroof" ]							= loadfx( "maps/paris/car_glass_sunroof" );
	level._effect[ "sedan_body_impact" ]							= loadfx( "maps/paris/sedan_body_impact" );
	level._effect[ "sedan_skid_sparks" ]			 						= loadfx( "maps/paris/sedan_skid_sparks" );	
	level._effect[ "drag_glass_trail" ]			 						= loadfx( "maps/paris/drag_glass_trail" );	
	level._effect[ "body_drag_trail" ]			 						= loadfx( "maps/paris/body_drag_trail" );
	level._effect[ "oil_drip_small_continuous" ]			 						= loadfx( "misc/oil_drip_small_continuous" );
	level._effect[ "van_damage_whitesmoke_looping" ]			 						= loadfx( "maps/paris/van_damage_whitesmoke_looping" );
	level._effect[ "crash_debris" ]			 						= loadfx( "maps/paris/crash_debris" );
	level._effect[ "smoke_after_crash_smoulder" ]			 						= loadfx( "maps/paris/smoke_after_crash_smoulder" );
	//temp final crash fx
	level._effect[ "highrise_glass_56x59" ]			 						= loadfx( "maps/paris/highrise_glass_56x59_cheap_paris" );
	
	level._effect[ "guard_blood_splat" ]									= loadfx( "impacts/flesh_hit_body_fatal_exit" );
	
	//galleria destruction
	level._effect[ "gallery_archway_01_dest" ]			 						= loadfx( "props/gallery_archway_01_dest" );	
	level._effect[ "paris_glass_panel1" ]			 						= loadfx( "props/paris_glass_panel1" );	
	level._effect[ "paris_glass_panel2" ]			 						= loadfx( "props/paris_glass_panel2" );	
	level._effect[ "paris_chandelier_dest" ]			 						= loadfx( "props/paris_chandelier_dest" );	
	level._effect[ "lights_godray_beam_gallery" ]			 						= loadfx( "maps/paris/lights_godray_beam_gallery" );
	
	//fruit cart destruction
	level._effect[ "paris_fruit_cart" ]			 											= loadfx( "props/paris_fruit_cart" );
	
	//ambient battle fx
	level._effect["ambient_explosion"]													= loadfx ("maps/paris/ambient_explosion_paris");	
	level._effect["building_explosion_gulag"]													= loadfx ("explosions/building_explosion_gulag");	
	level._effect["belltower_explosion"]													= loadfx ("explosions/belltower_explosion");	
	level._effect[ "smoke_column_skybox_paris" ]			 						= loadfx( "maps/paris/smoke_column_skybox_paris" );
	level._effect[ "thick_fakelit_smoke_paris" ]			 						= loadfx( "maps/paris/thick_fakelit_smoke_paris" );
	level._effect[ "antiair_runner_flak_day" ]			 						= loadfx( "misc/antiair_runner_flak_day" );
	level._effect[ "antiair_runner_cloudy_paris" ]			 						= loadfx( "maps/paris/antiair_runner_cloudy_paris" );
	level._effect[ "skybox_mig29_flyby" ]			 						= loadfx( "misc/skybox_mig29_flyby" );
	level._effect[ "skybox_hind_flyby" ]			 						= loadfx( "misc/skybox_hind_flyby" );
	level._effect[ "leaves_fall_gentlewind_paris" ]			 						= loadfx( "misc/leaves_fall_gentlewind_paris" );
	level._effect[ "leaves_heliblown_paris" ]			 						= loadfx( "misc/leaves_heliblown_paris" );
	
	//street environment vfx
	level._effect[ "leaves_runner_1" ]			 						= loadfx( "misc/leaves_runner_1" );	
	level._effect[ "leaves_fall_gentlewind" ]			 						= loadfx( "misc/leaves_fall_gentlewind" );	
	level._effect[ "moth_runner" ]			 						= loadfx( "misc/moth_runner" );	
	level._effect[ "battlefield_smk_directional_white_m_cheap" ]			 											= loadfx( "smoke/battlefield_smk_directional_white_m_cheap" );
	level._effect[ "battlefield_smk_directional_grey_m_cheap" ]			 											= loadfx( "smoke/battlefield_smk_directional_grey_m_cheap" );
	level._effect[ "amb_smoke_distant_paris" ]			 											= loadfx( "smoke/amb_smoke_distant_paris" );	

	// for bloody_death
	level._effect[ "flesh_hit" ] 									= LoadFX( "impacts/flesh_hit_body_fatal_exit" );
	level._effect[ "flesh_hit_small" ] 									= LoadFX( "impacts/flesh_hit" );
	


}

init_smVals()
{
	//Set the initial shadow values
	//setsaveddvar("sm_spotlimit",1);
	//setsaveddvar("sm_sunshadowscale",.85);
	//setsaveddvar("sm_sunsamplesizenear",.25);
	setsaveddvar("fx_alphathreshold",10);
//	setsaveddvar("r_specularcolorscale",.25);
}

treadfx_override()
{
	wait(0.1);
	fx = "treadfx/tread_dust_paris";
	no_fx = "misc/no_effect";
	vehicletype_fx[0] = "script_vehicle_t72_tank";
	vehicletype_fx[1] = "script_vehicle_gaz_tigr_harbor";
	vehicletype_fx[2] = "script_vehicle_gaz_tigr_turret_physics";
	vehicletype_fx[3] = "script_vehicle_armored_van";
	vehicletype_fx[4] = "script_vehicle_paris_escape_sedan";
	

	foreach(vehicletype in vehicletype_fx)
	{
		maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
	  maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
	 	//maps\_treadfx::setvehiclefx( vehicletype, "water", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none" );
	}
	
	//sedan tread fx
	fx = "treadfx/tread_dust_paris_small";
	no_fx = "misc/no_effect";
	vehicletype_fx[0] = "script_vehicle_paris_escape_sedan";
	

	foreach(vehicletype in vehicletype_fx)
	{
		maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
	  maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
	 	//maps\_treadfx::setvehiclefx( vehicletype, "water", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none" );
	}
	
	//helicopter tread fx
	vehicletype = "script_vehicle_mi24p_hind_woodland";
	fx = "treadfx/heli_dust_ambush";
	water_fx = "treadfx/heli_water_paris";
	
	maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
  maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "water", water_fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
 	maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
	maps\_treadfx::setvehiclefx( vehicletype, "none" );
}

ambient_room_battles()
{
	//Add in explosions to bg rooms
	
}


play_first_bombshake()
{
	//play bomb shake after fade in.  Don' play at any checkpoints after you start chase
	wait 6;
	flag_waitopen("msg_fx_zone7000");
	flag_waitopen("msg_fx_zone8000");
	flag_waitopen("msg_fx_zone8100");
	flag_waitopen("msg_fx_zone8200");
	flag_waitopen("msg_fx_zone8300");
	flag_waitopen("msg_fx_zone8400");
	flag_waitopen("msg_fx_zone8500");
	flag_waitopen("msg_fx_zone8600");
	flag_waitopen("msg_fx_zone8700");
	flag_waitopen("msg_fx_zone9000");
	play_distant_bombshake(level.player);
	wait 7;
	//flag_set("enable_distant_bomb_shakes");
}

dynamic_lights_all_models()
{
	//turn on shadowing for all objects in catacombs to fix bug.  Turn off upon catacombs exit
	waitframe();
	flag_waitopen("msg_fx_zone6500");
	flag_waitopen("msg_fx_zone7000");
	flag_waitopen("msg_fx_zone8000");
	flag_waitopen("msg_fx_zone8100");
	flag_waitopen("msg_fx_zone8200");
	flag_waitopen("msg_fx_zone8300");
	flag_waitopen("msg_fx_zone8400");
	flag_waitopen("msg_fx_zone8500");
	flag_waitopen("msg_fx_zone8600");
	flag_waitopen("msg_fx_zone8700");
	flag_waitopen("msg_fx_zone9000");
	setsaveddvar("sm_dynlightAllSmodels",1);
	flag_wait("msg_fx_zone6500");
	setsaveddvar("sm_dynlightAllSmodels",0);
	//flag_set("enable_distant_bomb_shakes");
}

/*start_distant_bombShakes()
{
	to1 = spawn_tag_origin();
	to1.origin = self.player getorigin();
	to1.angles = ( 270, 0, -45);
	if(!isdefined(level.bombshake_interval))
	{
		level.bombshake_interval = 20;//was at 20
		level.bombshake_interval_rand = 7;//was at 5
	}
	wait(5.0);//Make sure the fade in completes before it starts
	for(;;)
	{
		flag_wait("enable_distant_bomb_shakes");	// Wait until this system is enabled manually.
		if (flag("enable_distant_bomb_shakes")) // Still have to check. (e.g., entering_hind could be set while waiting on "enable_distant_bomb_shakes").
		{
			play_distant_bombshake(to1);
		}
		
		randomInc = randomfloatrange((level.bombshake_interval_rand * -1),level.bombshake_interval_rand)+level.bombshake_interval;
		wait(randomInc);
	}	
}*/

play_distant_bombshake(to1, b_forceshake)
{
	if(level.createfx_enabled) return 0;
	//Send the message to audio
	if (!IsDefined (b_forceshake))
		b_forceshake = 0;
	aud_send_msg("generic_building_bomb_shake");
	fx_bombShakes("falling_dirt_dark_2_paris","viewmodel_medium",.127,2,.3,.53, 1, b_forceshake);

}

fx_trigger_manual_bombshake()
{
	//play bombshake when player hits a trigger
	manual_bombshake_triggers = getentarray( "manual_bombshake", "targetname" );
	array_thread (manual_bombshake_triggers, ::fx_manual_bombshake);
}

fx_manual_bombshake()
{
	//play manual bombshake and temporarily disable automatic ones so they don't stack up accidentally
	self waittill("trigger", other);
	//flag_clear("enable_distant_bomb_shakes");
	play_distant_bombshake(level.player, 1);
	//wait 16;
	//flag_waitopen("msg_fx_chase_start_helis");
	//flag_set("enable_distant_bomb_shakes");
}

fx_turn_off_bombshakes()
{
	flag_wait("msg_fx_chase_start_helis");
	flag_clear("enable_distant_bomb_shakes");
}

fx_doorkick_dust()
{
	wait 6.6;
	exploder(6105);
}

catacombs_enemy_gate_gag_vfx()
{
	flag_wait("flag_catacombs_enemy_gate_gag_vfx");
	wait(0.45);
	exploder(6210);
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

	speed = 200;
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

loop_chase_start_hind()
{
	wait(0.2);
	for(;;)
	{
		flag_wait("msg_fx_chase_start_helis");
		wait(18);
		//the looping hindfx are on exploder 7099
		exploder(7099);
	}
}

start_ambient_flak()
{
	wait(0.2);
	flag_waitopen("msg_fx_zone6000");
	flag_waitopen("msg_fx_zone6100");
	flag_waitopen("msg_fx_zone6200");
	flag_waitopen("msg_fx_zone6300");
	flag_waitopen("msg_fx_zone6400");
	flag_waitopen("msg_fx_zone6500");
	exploder(10001);
}

fx_fruit_cart_destroyables()
{
	fruit_carts = getEntArray("fruit_cart_exploder", "targetname");
	array_thread(fruit_carts,::fx_fruit_cart_watcher);
}

fx_fruit_cart_watcher()
{
	self waittill( "trigger", other );
	physicsExplosionSphere(self.origin, 100, 100, 1.2);
	radiusdamage(self.origin, 150, 5000, 5000);
}

//chase scene functions
fx_car_chase(van)
{
	//play glass on dashbaord stationary
	PlayFXOnTag( getfx( "van_dashboard_glass" ), van, "body_animate_jnt" );
	//play fake impacts on van hood
	flag_wait("msg_fx_hood_impacts");
	PlayFXOnTag( getfx( "van_hood_impacts" ), van, "tag_engine_left" );
}

fx_car_peelout(van)
{
	//kill static glass on dashboard and spawn moving glass
	stopfxontag( getfx( "van_dashboard_glass" ), van, "body_animate_jnt");
	PlayFXOnTag( getfx( "van_dashboard_glass_move" ), van, "body_animate_jnt" );
	PlayFXOnTag( getfx( "van_peelout" ), van, "tag_wheel_front_right" );
}

fx_volk_sedan_peelout(car)
{
	wait 0.15;
	//play dust oneshot
	exploder(7001);
	wait 0.65;
	PlayFXOnTag( getfx( "tread_burnout_reverse" ), car, "tag_wheel_front_right" );
	PlayFXOnTag( getfx( "tread_burnout_reverse" ), car, "tag_wheel_front_left" );

}

fx_blockade_impact(van, rate)
{
	wait(2.2 / rate);
		
	// temp until we animate it sliding away
	maps\paris_shared::bomb_truck_hide_windshield();
	
	PlayFXOnTag( getfx( "van_blockade_impact" ), van, "tag_engine_left" );
	//screen blur
	setblur(2.0, 0.1 / rate);
	wait .5;
	setblur(0, 0.4 / rate);	
	PlayFXOnTag( getfx( "van_grill_smoke" ), van, "body_animate_jnt" );
	//test behindview effects
	wait 5;
	/*iprintln("should be throwing stuff");
	wait 2;
	fx_behindview_impact_fenceleft();
	wait 1;
	fx_behindview_impact_fenceright();
	wait 1;
	fx_behindview_impact_fenceleft();
	wait 1;
	fx_behindview_impact_fenceright();*/
}


fx_toggle_dlights()
{
	level waitframe();
	
	if ( !flag_exist( "flag_canal_combat_01" ) )
	{
		flag_init( "flag_canal_combat_01" );
	}
	flag_wait("flag_canal_combat_01" );
	setsaveddvar("r_dlightlimit",1);
	
	if ( !flag_exist( "flag_chase_canal_uaz_02" ) )
	{
		flag_init( "flag_chase_canal_uaz_02" );
	}	
	flag_wait("flag_chase_canal_uaz_02" );
	setsaveddvar("r_dlightlimit",4);
	
	if ( !flag_exist( "flag_final_crash_begin" ) )
	{
		flag_init( "flag_final_crash_begin" );
	}	
	flag_wait("flag_final_crash_begin");
	//iprintlnbold("got here\n");
	setsaveddvar("r_dlightlimit",1);
	
	
	
	
}

fx_tank_chasefire_1(tank)
{
	PlayFXOnTag( getfx( "abrams_flash_wv_brightlite" ), tank, "tag_flash" );
	wait 0.06;
	Earthquake( 0.5, 2.0, level.player.origin, 1600 );
	
	//level.player ShellShock( "default" , 1.5 );
	
	//turn on tank shell impact fx
	wait(0.25);
	exploder(999);
}

fx_tank_chasefire_2(tank)
{
	//play muzzleflash
	exploder(8101);
	
	//turn on tank shell impact fx
	wait(0.25);
	//use half res particles
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
	}
	exploder(8102);
	wait (0.05);
	Earthquake( 0.65, 1.0, level.player.origin, 1600 );
	//set location of impact
	fxOrigin = (-8587, 3573, 330);
	//cause damage to script exploder to make models swap
	RadiusDamage(fxorigin, 128, 301, 301);
	//screen fx
	setblur(2.0, 0.1);
	wait .1;
	level.player dirtEffect(fxOrigin);
	wait .15;
	setblur(0, 0.4);
	wait 6;
	//disable half res particles
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( false );
	}	
}

fx_behindview_impact_planters(shakeAmt)
{
		if (!isdefined(shakeAmt)) shakeAmt = 0.3;
		PlayFXOnTag( getfx( "van_behindview_impact_planters" ), level.bomb_truck, "tag_origin" );
		wait (0.1);
		Earthquake( shakeAmt, 2.3, level.player.origin, 1600 );
}

fx_behindview_impact_flowers(shakeAmt)
{
		if (!isdefined(shakeAmt)) shakeAmt = 0.2;
		PlayFXOnTag( getfx( "van_behindview_impact_flowers" ), level.bomb_truck, "tag_origin" );
		wait (0.1);
		Earthquake( shakeAmt, 2.0, level.player.origin, 1600 );
}

fx_behindview_impact_diningset(shakeAmt)
{
		if (!isdefined(shakeAmt)) shakeAmt = 0.2;
		PlayFXOnTag( getfx( "van_behindview_impact_diningset" ), level.bomb_truck, "tag_origin" );
		wait (0.12);
		Earthquake( shakeAmt, 1.3, level.player.origin, 1600 );
}

fx_behindview_impact_topiaryright(shakeAmt)
{
		if (!isdefined(shakeAmt)) shakeAmt = 0.15;
		PlayFXOnTag( getfx( "van_behindview_impact_topiaryright" ), level.bomb_truck, "tag_origin" );
		wait (0.1);
		Earthquake( shakeAmt, 0.5, level.player.origin, 1600 );
}

fx_behindview_impact_topiaryleft(shakeAmt)
{
		if (!isdefined(shakeAmt)) shakeAmt = 0.15;
		PlayFXOnTag( getfx( "van_behindview_impact_topiaryleft" ), level.bomb_truck, "tag_origin" );
		wait (0.1);
		Earthquake( shakeAmt, 0.5, level.player.origin, 1600 );
}

fx_behindview_impact_fenceleft(shakeAmt)
{
		if (!isdefined(shakeAmt)) shakeAmt = 0.15;
		PlayFXOnTag( getfx( "van_behindview_impact_fenceleft" ), level.bomb_truck, "tag_origin" );
		wait (0.1);
		Earthquake( shakeAmt, 0.4, level.player.origin, 1600 );
}

fx_behindview_impact_fenceright(shakeAmt)
{
		if (!isdefined(shakeAmt)) shakeAmt = 0.2;
		PlayFXOnTag( getfx( "van_behindview_impact_fenceright" ), level.bomb_truck, "tag_origin" );
		//wait (0.1);
		//Earthquake( shakeAmt, 0.5, level.player.origin, 1600 );
}

fx_van_galleria_physics_wake()
{	
		for(;;)
		{
			//only go off in galleria
			flag_wait("msg_fx_zone8500");
			//set off physics impulse pulling things the direction the van is travelling
			magnitude = 0.06;
			vanDirection = vectornormalize(anglestoforward(level.bomb_truck.angles));
			//set physics origin behind van
			physicsOrigin = level.bomb_truck.origin - (vanDirection * 250);
			//set magnitude and add upward force
			forceDirection = (vanDirection * magnitude) + (0,0,0.075);
			PhysicsJolt(physicsOrigin, 90, 75, forceDirection);
			wait(0.05);
		}
}

fx_umbrella_spin(umbrella)
{
		flag_wait("msg_fx_" + umbrella);
		umbrellaEnt = getEnt(umbrella, "targetname"); 
		if(isDefined(umbrellaEnt))
		{
				umbrellaEnt RotateVelocity((0,-180,0), 3, 0, 2.75); //RotateVelocity( <rotate velocity>, <time>, <acceleration time>, <deceleration time> )
		}
}

fx_sedan_damaged(sedan)
{
	//add tag for blowout effect
	blowout = spawn_tag_origin();
	blowout LinkTo(sedan, "tag_wheel_back_right", (0,0,13), (0,-120,0));
	PlayFXOnTag( getfx( "tire_blowout_parent" ), blowout, "tag_origin" );
	aud_send_msg("player_shot_sedan_ending", sedan);
	sedan ShowPart("wheel_A_KR_D");
	sedan HidePart("wheel_A_KR");

	
	while(!flag("flag_final_crash_wall_impact_1"))
	{
		PlayFXOnTag( getfx( "truck_sparks" ), sedan, "tag_wheel_back_right" );
		waitframe();
	}
	//play skidmarks after wall impact
	//decals need to be spawned rotated 90 degrees from wheel orientation
	skid_timer = 0;
	
	wheel_back_left = spawn_tag_origin();
	wheel_back_left LinkTo(sedan, "tag_wheel_back_left", (0,0,0), (-90,0,0));
	
	wheel_front_left = spawn_tag_origin();
	wheel_front_left LinkTo(sedan, "tag_wheel_front_left", (0,0,0), (-90,0,0));
	
	wheel_front_right = spawn_tag_origin();
	wheel_front_right LinkTo(sedan, "tag_wheel_front_right", (0,0,0), (-90,0,0));
	
	
	
	while (skid_timer < 30)
	{
		PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_back_left, "tag_origin" );
		PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_left, "tag_origin" );
		PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_right, "tag_origin" );
		wait(0.03);
		skid_timer++;
	}
	wheel_front_left delete();
	wheel_back_left delete();
	wheel_front_right delete();
}

fx_hide_skidmarks()
{
	skidmarks = getentarray("final_crash_skidmarks", "targetname");
	foreach (ent in skidmarks)
	{
		ent hide();
	}
}

fx_van_hit_fences()
{
	flag_wait("msg_fx_staircase_helis");
	wait 0.6;
	fx_behindview_impact_fenceleft();
	wait 0.15;
	fx_behindview_impact_fenceleft();
	wait 0.15;
	fx_behindview_impact_fenceleft();
	wait 0.15;
	fx_behindview_impact_fenceleft();
	wait 0.15;
	fx_behindview_impact_fenceleft();
	wait 0.15;
	fx_behindview_impact_fenceleft();
}

fx_sedan_escape_sparks_left()
{
	wait 1;
	
	flag_wait("msg_fx_sedan_sparks_left_start");
	if(!flag("flag_player_shot_sedan_ending"))
	{
		aud_send_msg("pars_volk_escape_failstate");
		wheel_front_right = spawn_tag_origin();
		wheel_front_right LinkTo(level.escape_sedan, "tag_wheel_front_right", (0,0,0), (-90,0,0));
		
		while(!flag("msg_fx_sedan_sparks_left_stop"))
		{
			PlayFXOnTag( getfx( "truck_sparks" ), level.escape_sedan, "tag_door_left_front" );
			PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_right, "tag_origin" );
			wait(0.03);
		}
		wheel_front_right delete();
	}
}

fx_sedan_escape_sparks_right()
{
	wait 1;
	
	flag_wait("msg_fx_sedan_sparks_right_start");
	if(!flag("flag_player_shot_sedan_ending"))
	{
		wheel_back_left = spawn_tag_origin();
		wheel_back_left LinkTo(level.escape_sedan_model, "tag_wheel_back_left", (0,0,0), (-90,0,0));
		
		wheel_front_left = spawn_tag_origin();
		wheel_front_left LinkTo(level.escape_sedan, "tag_wheel_front_left", (0,0,0), (-90,0,0));
	
		while(!flag("msg_fx_sedan_sparks_right_stop"))
		{
			PlayFXOnTag( getfx( "truck_sparks" ), level.escape_sedan, "tag_door_right_back" );
			PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_back_left, "tag_origin" );
			PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_left, "tag_origin" );
			wait(0.03);
		}
		wheel_back_left delete();
		wheel_front_left delete();
	}
}
