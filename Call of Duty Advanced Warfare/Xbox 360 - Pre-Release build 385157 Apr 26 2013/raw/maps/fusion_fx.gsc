#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_fx;
#include maps\_anim;
#include soundscripts\_snd;

main()
{
	precacheFX();
	maps\createfx\fusion_fx::main();
		
	if(!isdefined(level.createFXent))
	level.createFXent = [];
	
	set_lighting_values();
	set_reactive_motion_values();
	setup_shg_fx();
	

	/*********************************************************
	
	INITIALIZE FLAGS HERE
	
	**********************************************************/	
	
	flag_init("fx_flak_intro");
	flag_init("fx_cliff_heli_dust");
	flag_init("fx_heli_rotorsmoke_start");
	flag_init("fx_heli_rotorsmoke_stop");
	flag_init("fx_warbird_hoverdust");
	flag_init("fx_warbird_hit_tower");
	flag_init("hangar_enemies");
	flag_init("fx_ar_start");
	flag_init("fx_ar_stop");
	flag_init("cam_shake_start");
	flag_init("cam_shake_stop");
	flag_init("walker_death_anim_started");
	flag_init("turbine_room_pre_explosion");
	flag_init("reactor_light_rays");
	
	
	
	/*********************************************************
	
	EXPLODER NUMBERS & FX ZONE WATCHERS
		
	**********************************************************/
	
		//1000 = intro: heli ride along the coastline
		//1100 = zip_line: heli hovering through reactor towers until harpoon shot
		//2000 = courtyard: player start at ground level and along the courtyard
		//3000 = fusion interior: lobby
		//3100 = fusion interior: lab room section 1
        //3200 = fusion interior: lab room section 2
        //3300 = fusion interior: reactor room
        //3400 = fusion interior: elevator ride
        //3500 = fusion interior: turbine room
        //3600 = fusion interior: control room
		//4000 = control_room: indoor control room
		//5000 = loading_zone: loading zone hangar
		//6000 = cooling_towers: cooling towers area
		//7000 = cooling_tower_explosion
	
		
		thread fx_zone_watcher(1000,"msg_vfx_zone1_intro");//1000 = intro: heli ride along the coastline
		thread fx_zone_watcher(1100,"msg_vfx_zone1_zip_line");//1100 = zip_line: heli hovering through reactor towers until harpoon shot
		thread fx_zone_watcher(2000,"msg_vfx_zone2_courtyard");	//2000 = courtyard: player start at ground level and along the courtyard
		thread fx_zone_watcher(3000,"msg_vfx_zone3_interior_lobby");//3000 = fusion interior
		thread fx_zone_watcher(3100,"msg_vfx_zone3_lab_room_section_1");//3100 = fusion interior: lab room section 1
        thread fx_zone_watcher(3200,"msg_vfx_zone3_lab_room_section_2");//3200 = fusion interior: lab room section 2
        thread fx_zone_watcher(3300,"msg_vfx_zone3_reactor_room");//3300 = fusion interior: reactor room
        thread fx_zone_watcher(3310,"msg_vfx_zone3_reactor_control_room");//3310 = fusion interior: reactor room control room
        thread fx_zone_watcher(3400,"msg_vfx_zone3_elevator_ride");//3400 = fusion interior: elevator ride
        thread fx_zone_watcher(3500,"msg_vfx_zone3_turbine_room");//3500 = fusion interior: turbine room
        thread fx_zone_watcher(3600,"msg_vfx_zone3_main_control_room");//3600 = fusion interior: control room
		thread fx_zone_watcher(4000,"msg_vfx_zone4_control_room");//4000 = control_room: from inside control room until bottom of stairs
		thread fx_zone_watcher(5000,"msg_vfx_zone5_loading_zone");//5000 = loading_zone: loading zone hangar
		thread fx_zone_watcher(6000,"msg_vfx_zone6_cooling_towers");//6000 = cooling_towers: cooling towers area
		thread fx_zone_watcher(6900,"msg_vfx_zone6_9_pressure_explosion");//6000 = cooling_towers: cooling towers area
		thread fx_zone_watcher(7000,"msg_vfx_zone7_cooling_tower_explosion");//7000 = cooling_tower_explosion
	
	
	/*********************************************************
	
	START FX LOGIC THREADS HERE
	
	**********************************************************/
	//level thread convertOneShot();  //type in curr_exp_numb dvar followed by a number and then hit z key with the oneshot selected
	thread treadfx_override();
	thread ambient_explosion_before_landing();
	thread ambient_large_pipe_effects_courtyard();
	thread ambient_explosion_courtyard();
	thread flak_intro_sequence();
	thread vfx_control_room_explo();
	thread dust_falling_control_room();
	thread ambient_gas_explosion_loading_zone();
	thread ambient_explosion_dirt_cooling_towers();
	thread ambient_explosion_fireball_cooling_towers();
	thread warbird_hoverdust();
	thread kill_all_env_fx();
	thread init_smVals();
	thread warbird_dropping_mobile_tuerret_camshake();
	thread intro_armap_moment();
	thread reactor_light_rays();
	thread kill_exterior_vfx();
	thread restart_exterior_vfx();
	
	//functions to turn on oneshot smoke vfx, then turn them off when entering the interior and then back on when entering the hangar area
	thread start_smoke_pillar_black_large_fast_fx();
	thread start_smoke_pillar_gray_large_fast_fx();
	thread start_smoke_pillar_black_large_slow_fx();
	
	//level.fx_zone_messages = true;
	
	/*********************************************************
	
	EXPLODER NUMBERS FOR EVENT TRIGGERS
		
	**********************************************************/
	
	// 5 = explosion on intro ally heli crashing into tower
	// 1106 = ambient explosion in the courtyard
	// other ones are being used as temp by design
	
}


set_lighting_values()
{
	if ( IsUsingHDR() )
	{
		//HDR settings
		setSavedDvar( "r_tonemap", "1");
		//setSavedDvar( "r_tonemapadaptspeed", .02 );
		//setsaveddvar( "r_veil", 1 );  
		//setsaveddvar( "r_veilstrength", .087);
		//setsaveddvar( "r_tonemapkey", 0.0);
		setsaveddvar( "r_particleHdr", "1");
		
		//adjusting max exposure HDR brightening to be a bit below default 
		//setsaveddvar("r_tonemapmaxexposure", "7.75");
		
		//sets sun shadow out farther than default for long view distances at start
		//setsaveddvar( "sm_sunsamplesizenear", 0.5 );
		
		//set env ssao settings for fusion
		if ( IsUsingSSAO() )
		{
			//setSavedDvar("r_ssaoPower", "12.0");
			//setSavedDvar("r_ssaoStrength", "0.45");
			//setsavedDvar("r_ssaominstrengthdepth", "25.0");
			//setsavedDvar("r_ssaomaxstrengthdepth", "40.0");
		}
	}
}


set_reactive_motion_values()
{
	SetSavedDvar( "r_reactiveMotionWindAmplitudeScale", "0.3" );
}



precacheFX()
{
	PreCacheShader("qr_mask");
	PreCacheShader("qr_noise");
	PreCacheShader("qr_anchor");
	PreCacheShader("qr_sledgehammer");
	PreCacheShader("ar_loadtext");
	
	
	level._effect[ "emp_reactor_robot_damage" ] 				= LoadFX( "vfx/sparks/emp_drone_damage" );
	level._effect[ "reactor_robot_death" ] 						= loadfx( "vfx/explosion/vehicle_pdrone_explosion" );

	//rpg
	level._effect[ "rpg_trail" ]				 				= LoadFX( "vfx/trail/smoketrail_rpg" );
	level._effect[ "rpg_muzzle" ] 								= LoadFX( "vfx/muzzleflash/x4walker_wheels_rpg_fv" );
	level._effect[ "rpg_explode" ]								= loadfx( "vfx/explosion/rocket_explosion_default" );

	level._effect[ "mortar_explosion" ] 						= LoadFX( "vfx/explosion/ambient_explosion_fireball" );
	
	//intro fly in
	level._effect[ "ar_map" ]					= loadfx( "vfx/map/fusion/fusion_intro_ar_map" );
	level._effect[ "ar_map_dis" ]					= loadfx( "vfx/map/fusion/fusion_intro_ar_map_dis" );
	level._effect[ "ar_pathA" ]					= loadfx( "vfx/map/fusion/fusion_intro_map_pathA" );
	level._effect[ "ar_pathB" ]					= loadfx( "vfx/map/fusion/fusion_intro_map_pathB" );
	level._effect[ "ar_pathC" ]					= loadfx( "vfx/map/fusion/fusion_intro_map_pathC" );
	level._effect[ "ar_pathD" ]					= loadfx( "vfx/map/fusion/fusion_intro_map_pathD" );


	level._effect[ "wave_hit_large_runner" ]			 		= loadfx( "vfx/water/wave_hit_large_runner" );
	level._effect[ "wave_hit_large" ]			 				= loadfx( "vfx/water/wave_hit_large" );
	level._effect[ "wave_hit_large_02" ]			 			= loadfx( "vfx/water/wave_hit_large_02" );
	level._effect[ "wave_hit_large_03" ]			 			= loadfx( "vfx/water/wave_hit_large_03" );
	level._effect[ "wave_hit_mist_runner" ]			 			= loadfx( "vfx/water/wave_hit_mist_runner" );
	level._effect[ "wave_hit_mist_01" ]			 			= loadfx( "vfx/water/wave_hit_mist_01" );

	//missile launch
	level._effect[ "missile_launch_smoke" ]				 				= LoadFX( "vfx/muzzleflash/missile_launch_smoke" );
	level._effect[ "missile_launch_smoke_large" ]				 				= LoadFX( "vfx/muzzleflash/missile_launch_smoke_large" );
	
	//missile effects during the fly in that takes down friendly helicopter
	level._effect[ "smoketrail_groundtoair" ]				 				= LoadFX( "vfx/trail/smoketrail_groundtoair" );
	level._effect[ "smoketrail_groundtoair_large" ]				 				= LoadFX( "vfx/trail/smoketrail_groundtoair_large" );
	
	//helicopter fx
	level._effect[ "aerial_explosion_heli_large" ]				= LoadFX( "vfx/explosion/vehicle_warbird_explosion_a" );
	level._effect[ "heli_impact_concrete_large" ]				= LoadFX( "vfx/explosion/heli_concrete_impact_large" );
	level._effect[ "vehicle_damaged_fire_m" ]				= LoadFX( "vfx/fire/vehicle_damaged_fire_m" );
	level._effect[ "vehicle_damaged_rotorsmoke" ]				= LoadFX( "vfx/smoke/vehicle_damaged_rotorsmoke" );
	level._effect[ "fusion_heli_hover_dust" ]				= LoadFX( "vfx/map/fusion/fusion_heli_hover_dust" );
	level._effect[ "heli_dust_warbird_placed" ]				= LoadFX( "vfx/map/fusion/fusion_heli_dust_warbird_placed" );
	level._effect[ "trail_concrete_dust_m" ]				= LoadFX( "vfx/trail/trail_concrete_dust_m" );
	level._effect[ "fusion_warbird_interior_fire" ]				= LoadFX( "vfx/map/fusion/fusion_warbird_interior_fire" );
	
	// for bloody_death
	level._effect[ "flesh_hit" ] 								= LoadFX( "vfx/weaponimpact/flesh_impact_body_fatal_exit" );
	
	//for burning guys
	level._effect[ "fire_smoke_trail_verysmall" ] 								= LoadFX( "vfx/fire/fire_smoke_trail_verysmall" );
	
	//cooling tower
	level._effect[ "cooling_tower_smoke" ]			 			= loadfx( "vfx/smoke/cooling_tower_smoke" );

	//x4walker landing
	level._effect[ "x4walker_drop_in_dust" ]										= loadfx( "vfx/dust/x4walker_drop_in_dust" );

	//walker tank fx
	level._effect[ "walker_tank_rocket_wv" ]										= loadfx( "vfx/muzzleflash/walker_tank_rocket_wv" );
	level._effect[ "walker_tank_dying_fire" ]										= loadfx( "vfx/fire/vehicle_walker_tank_dying_fire" );
	level._effect[ "walker_tank_dying_fire_small" ]										= loadfx( "vfx/fire/vehicle_walker_tank_dying_fire_small" );
	level._effect[ "walker_footstep" ]										= loadfx( "vfx/treadfx/footstep_walker_tank" );
	level._effect[ "walker_explosion" ]										= loadfx( "vfx/explosion/vehicle_walker_tank_explosion" );
	level._effect[ "vehicle_destroyed_fire_m" ]										= loadfx( "vfx/fire/vehicle_destroyed_fire_m" );
	level._effect[ "vehicle_destroyed_smoke_white_m" ]										= loadfx( "vfx/smoke/vehicle_destroyed_smoke_white_m" );
	level._effect[ "vehicle_damaged_sparks_l" ]										= loadfx( "vfx/sparks/vehicle_damaged_sparks_l" );

	//mobile turret damage
	level._effect[ "mobile_turret_sparks" ]						= LoadFx( "vfx/sparks/vehicle_damaged_sparks_interior_small" );
	level._effect[ "mobile_turret_smoke" ]						= LoadFx( "vfx/smoke/vehicle_damaged_smoke_interior" );
	level._effect[ "mobile_turret_fire_small" ]						= LoadFx( "vfx/fire/vehicle_damaged_fire_interior_small" );
	level._effect[ "mobile_turret_fire_large" ]						= LoadFx( "vfx/fire/vehicle_damaged_fire_x4walker_vm" );
	level._effect[ "mobile_turret_explosion" ]					= LoadFx( "vfx/explosion/vehicle_x4walker_explosion" );
	level._effect[ "mobile_turret_ground_smoke" ]					= LoadFx( "vfx/map/fusion/fusion_mobile_turret_base_smoke" );

	//mobile_cover fx
	level._effect[ "fusion_vehicle_mobile_cover_explosion" ]					= LoadFx( "vfx/map/fusion/fusion_vehicle_mobile_cover_explosion" );
	level._effect[ "fusion_vehicle_mobile_cover_explosion_01" ]					= LoadFx( "vfx/map/fusion/fusion_vehicle_mobile_cover_explosion_01" );
	
	//semi tire
	level._effect[ "tire_industrial_01_rubber" ]						 = loadfx( "vfx/destructible/tire_industrial_01_rubber" );
	
	//parking garage destruction
	level._effect[ "concrete_impact_large_chunks" ]					= LoadFX( "vfx/explosion/concrete_impact_large_chunks" );
	level._effect[ "parking_garage_chunk_impacts" ]					= LoadFx( "vfx/map/fusion/parking_garage_chunk_impacts" );
	level._effect[ "fusion_garage_explosion_arms" ]					= LoadFX( "vfx/explosion/fusion_garage_explosion_arms" );

	//walker trophy
	level._effect[ "trophy_explosion" ] 						= LoadFx( "vfx/explosion/trophy_explosion" );
	level._effect[ "trophy_ignition_smoke" ] 						= LoadFx( "vfx/muzzleflash/x4walker_wheels_rpg_fv" );

	//env fx
	level._effect[ "wind_blowing_debris" ]			    				= loadfx( "vfx/wind/wind_blowing_debris" );
	level._effect[ "fireball_smk_M" ]						  			= loadfx( "vfx/fire/fireball_lp_smk_M" );
	level._effect[ "fire_lp_m" ]						  				= loadfx( "vfx/fire/fire_lp_m" );
	level._effect[ "fire_lp_m_no_light" ]						  		= loadfx( "vfx/fire/fire_lp_m_no_light" );
	level._effect[ "fire_lp_s" ]						  				= loadfx( "vfx/fire/fire_lp_s" );
	level._effect[ "fire_lp_s_no_light" ]						  		= loadfx( "vfx/fire/fire_lp_s_no_light" );
	level._effect[ "fire_lp_xs_no_light" ]						  		= loadfx( "vfx/fire/fire_lp_xs_no_light" );
	level._effect[ "fire_lp_smk_s" ]						  			= loadfx( "vfx/fire/fire_lp_smk_s" );
	level._effect[ "battlefield_smoke_m" ]			 					= loadfx( "vfx/smoke/battlefield_smoke_m" );
	level._effect[ "battlefield_smoke_l" ]			 					= loadfx( "vfx/smoke/battlefield_smoke_l" );
	level._effect[ "battlefield_smoke_l_ground" ]			 			= loadfx( "vfx/smoke/battlefield_smoke_l_ground" );
	level._effect[ "amb_dust_verylight" ]			 					= loadfx( "vfx/dust/amb_dust_verylight" );
	level._effect[ "amb_dust_verylight_far" ]			 				= loadfx( "vfx/dust/amb_dust_verylight_far" );
	level._effect[ "amb_dust_dark" ]			 						= loadfx( "vfx/dust/amb_dust_dark" );
	level._effect[ "smoke_pillar_white_01" ]			 				= loadfx( "vfx/smoke/smoke_pillar_white_01" );
	level._effect[ "smoke_pillar_black_large_fast" ]			 		= loadfx( "vfx/smoke/smoke_pillar_black_large_fast" );
	level._effect[ "smoke_pillar_gray_large_fast" ]			 			= loadfx( "vfx/smoke/smoke_pillar_gray_large_fast" );
	level._effect[ "smoke_pillar_black_large_slow" ]			 		= loadfx( "vfx/smoke/smoke_pillar_black_large_slow" );
	level._effect[ "smoke_pillar_black_medium_slow" ]			 		= loadfx( "vfx/smoke/smoke_pillar_black_medium_slow" );
	level._effect[ "smoke_cloud_black_large" ]			 				= loadfx( "vfx/smoke/smoke_cloud_black_large" );
	level._effect[ "ambient_explosion_dirt_runner" ]					= loadfx( "vfx/explosion/ambient_explosion_dirt_runner" );
	level._effect[ "ambient_explosion_dirt_02" ]						= loadfx( "vfx/explosion/ambient_explosion_dirt_02" );
	level._effect[ "ambient_explosion_fireball" ]						= loadfx( "vfx/explosion/ambient_explosion_fireball" );
	level._effect[ "ambient_explosion_fireball_a_no_decal" ]			= loadfx( "vfx/explosion/ambient_explosion_fireball_a_no_decal" );
	level._effect[ "fast_blowing_dust" ]								= loadfx( "vfx/dust/fast_blowing_dust" );
	level._effect[ "distortion_warbird" ]								= loadfx( "vfx/distortion/distortion_warbird" );
	level._effect[ "warbird_rotor" ]									= loadfx( "vfx/unique/warbird_rotor" );
	level._effect[ "warbird_rotor_sm" ]									= loadfx( "vfx/unique/warbird_rotor_sm" );
	level._effect[ "aa_explosion_runner" ]								= loadfx( "vfx/explosion/aa_explosion_runner" );
	level._effect[ "aa_explosion_runner_single" ]						= loadfx( "vfx/explosion/aa_explosion_runner_single" );
	level._effect[ "aa_explosion_generic_01" ]							= loadfx( "vfx/explosion/aa_explosion_generic_01" );
	level._effect[ "aa_explosion_generic_02" ]							= loadfx( "vfx/explosion/aa_explosion_generic_02" );
	level._effect[ "fireball_smk_S" ]						  			= loadfx( "vfx/fire/fireball_lp_smk_S" );
	level._effect[ "cloud_bank" ]										= loadfx( "vfx/wind/cloud_bank_ocean" );
	level._effect[ "cloud_bank_large" ]									= loadfx( "vfx/wind/cloud_bank_ocean_large" );
	level._effect[ "cloud_bank_cliffedge_thin" ]						= loadfx( "vfx/wind/cloud_bank_cliffedge_thin" );
	level._effect[ "fog_distant_vista" ]								= loadfx( "vfx/fog/fog_distant_vista" );
	level._effect[ "electrical_sparks" ]								= loadfx( "vfx/explosion/electrical_sparks" );
	level._effect[ "electrical_sparks_runner" ]							= loadfx( "vfx/explosion/electrical_sparks_runner" );
	level._effect[ "electrical_sparks_runner_single_burst" ]			= loadfx( "vfx/explosion/electrical_sparks_runner_single_burst" );
	level._effect[ "dust_falling_light_runner" ]						= loadfx( "vfx/dust/dust_falling_light_runner");
	level._effect[ "dust_falling_debris_runner" ]						= loadfx( "vfx/dust/dust_falling_debris_runner");
	level._effect[ "dust_blowing_ground_fast_runner" ]					= loadfx( "vfx/dust/dust_blowing_ground_fast_runner");
	level._effect[ "dust_blowing_ground_fast_01" ]						= loadfx( "vfx/dust/dust_blowing_ground_fast_01");	
	level._effect[ "dust_blowing_ground_fast_02" ]						= loadfx( "vfx/dust/dust_blowing_ground_fast_02");	
	level._effect[ "dust_falling_light_01" ]							= loadfx( "vfx/dust/dust_falling_light_01");
	level._effect[ "dust_falling_light_02" ]							= loadfx( "vfx/dust/dust_falling_light_02");
	level._effect[ "dust_falling_light_03" ]							= loadfx( "vfx/dust/dust_falling_light_03");	
	level._effect[ "dust_falling_debris_01_s" ]							= loadfx( "vfx/dust/dust_falling_debris_01_s");
	level._effect[ "dust_falling_debris_02_s" ]							= loadfx( "vfx/dust/dust_falling_debris_02_s");
	level._effect[ "dust_falling_debris_03_s" ]							= loadfx( "vfx/dust/dust_falling_debris_03_s");
	level._effect[ "dust_falling_debris_04_s" ]							= loadfx( "vfx/dust/dust_falling_debris_04_s");	
	level._effect[ "dust_falling_debris_05" ]							= loadfx( "vfx/dust/dust_falling_debris_05");	
	level._effect[ "dust_falling_debris_s_runner" ]						= loadfx( "vfx/dust/dust_falling_debris_s_runner");
	level._effect[ "firelp_med" ]										= loadfx( "vfx/fire/firelp_med");
	level._effect[ "fire_pipe_large" ]									= loadfx( "vfx/fire/fire_pipe_large");
	level._effect[ "fire_pipe_leak_med" ]								= loadfx( "vfx/fire/fire_pipe_leak_med");
	level._effect[ "fire_pipe_leak_med_single" ]						= loadfx( "vfx/fire/fire_pipe_leak_med_single");
	level._effect[ "steam_pipe_leak_sml" ]								= loadfx( "vfx/steam/steam_pipe_leak_sml");
	level._effect[ "steam_pipe_leak_lrg" ]								= loadfx( "vfx/steam/steam_pipe_leak_lrg");
	level._effect[ "steam_pipe_burst" ]									= loadfx( "vfx/steam/steam_pipe_burst");
	level._effect[ "steam_fill_ground" ]								= loadfx( "vfx/steam/steam_fill_ground");
	level._effect[ "steam_fill_area" ]									= loadfx( "vfx/steam/steam_fill_area");	
	level._effect[ "steam_fill_area_med" ]								= loadfx( "vfx/steam/steam_fill_area_med");
	level._effect[ "ambient_explosion_gas_01" ]							= loadfx( "vfx/explosion/ambient_explosion_gas_01");
	level._effect[ "ambient_explosion_gas_02" ]							= loadfx( "vfx/explosion/ambient_explosion_gas_02");
	level._effect[ "window_smoke_very_large" ]							= loadfx( "vfx/smoke/window_smoke_very_large");	
	level._effect[ "room_smoke_large" ]									= loadfx( "vfx/smoke/room_smoke_large");	
	level._effect[ "glass_falling_debris_01" ]							= loadfx( "vfx/glass/glass_falling_debris_01");	
	level._effect[ "fusion_battlefield_smoke_l_shadow" ]				= loadfx( "vfx/map/fusion/fusion_battlefield_smoke_l_shadow");
	level._effect[ "fusion_battlefield_smoke_l_light" ]					= loadfx( "vfx/map/fusion/fusion_battlefield_smoke_l_light");
	level._effect[ "steam_surface_add" ]								= loadfx( "vfx/steam/steam_surface_add");
	level._effect[ "amb_dust_patch_light" ]								= loadfx( "vfx/dust/amb_dust_patch_light");
	level._effect[ "light_godray_beam_3" ]								= loadfx( "vfx/lights/light_godray_beam_3");
	level._effect[ "dust_falling_light_06" ]							= loadfx( "vfx/dust/dust_falling_light_06");
	level._effect[ "dust_impact_ground_sm" ]							= loadfx( "vfx/dust/dust_impact_ground_sm");
	level._effect[ "light_dust_particles_small" ]						= loadfx( "vfx/dust/light_dust_particles_sm");
	level._effect[ "amb_ground_dust" ]									= loadfx( "vfx/dust/amb_ground_dust");
	level._effect[ "amb_ground_dust_sml" ]								= loadfx( "vfx/dust/amb_ground_dust_sml");
	level._effect[ "fus_vent_air_flow" ]								= loadfx( "vfx/map/fusion/fus_vent_air_flow");
	level._effect[ "fus_vent_streamers" ]								= loadfx( "vfx/map/fusion/fus_vent_streamers");
	
	//pressure explosion
	level._effect[ "pressure_explosion_ground_lrg_01" ]						= loadfx( "vfx/explosion/pressure_explosion_ground_lrg_01");
	level._effect[ "pressure_explosion_ground_lrg_02" ]						= loadfx( "vfx/explosion/pressure_explosion_ground_lrg_02");
	level._effect[ "steam_pipe_burst_looping_lrg_01" ]						= loadfx( "vfx/steam/steam_pipe_burst_looping_lrg_01");
	level._effect[ "pressure_explosion_metal_lrg_01" ]						= loadfx( "vfx/explosion/pressure_explosion_metal_lrg_01");
	level._effect[ "steam_pipe_burst_looping_lrg_02" ]						= loadfx( "vfx/steam/steam_pipe_burst_looping_lrg_02");
	
	//truck explosions
	level._effect[ "dust_impact_ground_lrg" ]								= loadfx( "vfx/dust/dust_impact_ground_lrg");
	level._effect[ "trail_steam_round_lrg" ]								= loadfx( "vfx/trail/trail_steam_round_lrg");
	level._effect[ "trail_steam_round_lrg_runner" ]							= loadfx( "vfx/trail/trail_steam_round_lrg_runner");
	level._effect[ "trail_spark_burst_explosion" ]							= loadfx( "vfx/trail/trail_spark_burst_explosion");
	level._effect[ "impact_scorchmark_med" ]								= loadfx( "vfx/fire/impact_scorchmark_med");
	level._effect[ "impact_scorchmark_sml" ]								= loadfx( "vfx/fire/impact_scorchmark_sml");
	level._effect[ "impact_sparks_01" ]										= loadfx( "vfx/explosion/impact_sparks_01");
	level._effect[ "fireball_explosion_directional_01" ]					= loadfx( "vfx/explosion/fireball_explosion_directional_01");
	level._effect[ "vehicle_fireball_explosion_01" ]						= loadfx( "vfx/explosion/vehicle_fireball_explosion_01");

	//ending big moment
	level._effect[ "fusion_end_armblood_init" ]					= loadfx( "vfx/map/fusion/fusion_end_armblood_init");
	level._effect[ "fusion_end_armblood_bloodsquirts" ]					= loadfx( "vfx/map/fusion/fusion_end_armblood_bloodsquirts");
	level._effect[ "blood_smear_oriented" ]					= loadfx( "vfx/map/fusion/fusion_blood_smear_oriented");
	level._effect[ "fusion_end_rollingsmk" ]						= loadfx( "vfx/map/fusion/fusion_end_rollingsmk");
	level._effect[ "fusion_end_rollingsmk_slow" ]						= loadfx( "vfx/map/fusion/fusion_end_rollingsmk_slow");
	level._effect[ "fusion_end_rollingsmk_thick" ]						= loadfx( "vfx/map/fusion/fusion_end_rollingsmk_thick");
	level._effect[ "fusion_end_grnd_init_explosion" ]					= loadfx( "vfx/map/fusion/fusion_end_grnd_init_explo");
	level._effect[ "fusion_end_grnd_init_shkwv" ]						= loadfx( "vfx/map/fusion/fusion_end_grnd_init_shkwv");
	level._effect[ "fusion_end_lingering_smk" ]							= loadfx( "vfx/map/fusion/fusion_end_lingering_smk");
	level._effect[ "fusion_pressure_explo_leadup" ]						= loadfx( "vfx/map/fusion/fusion_pressure_explo_leadup");
	level._effect[ "fusion_end_tower_explo" ]							= loadfx( "vfx/map/fusion/fusion_end_tower_explo");	
	level._effect[ "fusion_end_smk_emit" ]								= loadfx( "vfx/map/fusion/fusion_end_smk_emit");
	level._effect[ "fusion_end_smk_lrg_emit" ]							= loadfx( "vfx/map/fusion/fusion_end_smk_lrg_emit");
	level._effect[ "fusion_end_smk_med_emit" ]							= loadfx( "vfx/map/fusion/fusion_end_smk_med_emit");
	level._effect[ "fusion_end_thick_smk_up" ]							= loadfx( "vfx/map/fusion/fusion_end_thick_smk_up");	
	level._effect[ "fusion_end_thick_smk_up_tall" ]						= loadfx( "vfx/map/fusion/fusion_end_thick_smk_up_tall");	
	level._effect[ "fusion_end_smk_donut" ]								= loadfx( "vfx/map/fusion/fusion_end_smk_donut");	
	level._effect[ "fusion_end_smk_donut_looping" ]						= loadfx( "vfx/map/fusion/fusion_end_smk_donut_looping");	
	level._effect[ "fusion_end_grnd_splinters_up" ]						= loadfx( "vfx/map/fusion/fusion_end_grnd_splinters_up");
	level._effect[ "fusion_end_falling_rocks" ]							= loadfx( "vfx/map/fusion/fusion_end_falling_rocks");
	level._effect[ "ash_cloud_freq_lrg_loop" ]							= loadfx( "vfx/ash/ash_cloud_freq_lrg_loop");
	level._effect[ "fusion_end_tower_falling_dust" ]					= loadfx( "vfx/map/fusion/fusion_end_tower_falling_dust");
	level._effect[ "fusion_end_tower_inital_crack" ]					= loadfx( "vfx/map/fusion/fusion_end_tower_inital_crack");
	level._effect[ "fusion_end_thick_smk_vm" ]							= loadfx( "vfx/map/fusion/fusion_end_thick_smk_vm");
	level._effect[ "fusion_end_falling_debris" ]						= loadfx( "vfx/map/fusion/fusion_end_falling_debris");
	level._effect[ "fusion_end_falling_rock_sparkfoun" ]				= loadfx( "vfx/map/fusion/fusion_end_falling_rock_sparkfoun");
	level._effect[ "fusion_end_smk_xlrg_emit" ]							= loadfx( "vfx/map/fusion/fusion_end_smk_xlrg_emit");
	level._effect[ "fusion_end_smk_xxlrg_emit" ]						= loadfx( "vfx/map/fusion/fusion_end_smk_xxlrg_emit");
	level._effect[ "fusion_end_pillar_burst" ]							= loadfx( "vfx/map/fusion/fusion_end_pillar_burst");
	level._effect[ "fusion_drag_dust" ]									= loadfx( "vfx/map/fusion/fusion_drag_dust");	
	level._effect[ "fusion_falling_debris_tower" ]						= loadfx( "vfx/map/fusion/fusion_falling_debris_tower");	
	level._effect[ "fusion_end_bouncing_rocks" ]						= loadfx( "vfx/map/fusion/fusion_end_bouncing_rocks");	
	level._effect[ "concrete_impact_xl_chunks_smoky" ]					= loadfx( "vfx/explosion/concrete_impact_xl_chunks_smoky");	
	
	//lighting fx
	level._effect[ "lights_conelight_smokey" ] 							= loadfx( "vfx/lights/lights_conelight_smokey" );	
	level._effect[ "light_glow_teal" ] 									= loadfx( "vfx/lights/light_glow_teal" );	
	level._effect[ "light_glow_single_large" ] 							= loadfx( "vfx/lights/light_glow_single_large" );
	level._effect[ "light_glow_single_large_offscreen" ] 				= loadfx( "vfx/lights/light_glow_single_large_offscreen" );	
	level._effect[ "light_firelight_lrg" ] 								= loadfx( "vfx/lights/light_firelight_lrg" );
	level._effect[ "light_firelight_orange_lrg" ] 						= loadfx( "vfx/lights/light_firelight_orange_lrg" );	
	level._effect[ "light_godray_01" ] 									= loadfx( "vfx/lights/light_godray_beam_1" );	
	level._effect[ "light_godray_transp_lrg_01" ] 						= loadfx( "vfx/lights/light_godray_beam_transp_lrg_1" );	
	level._effect[ "light_godray_transp_lrg_03" ] 						= loadfx( "vfx/lights/light_godray_beam_transp_lrg_3" );	
	level._effect[ "light_godray_lrg_01" ] 								= loadfx( "vfx/lights/light_godray_beam_lrg_1" );	
	level._effect[ "light_godray_xtra_lrg_01" ] 						= loadfx( "vfx/lights/light_godray_beam_xtra_lrg_1" );	
	level._effect[ "light_godray_lrg_02" ] 								= loadfx( "vfx/lights/light_godray_beam_lrg_02" );	
	level._effect[ "light_godray_lrg_03" ] 								= loadfx( "vfx/lights/light_godray_beam_lrg_03" );	
	level._effect[ "light_dust_particles" ] 							= loadfx( "vfx/dust/light_dust_particles" );
	level._effect[ "light_red_rotate" ] 								= loadfx( "vfx/lights/light_red_rotate_02" );
	level._effect[ "light_red_strobe" ] 								= loadfx( "vfx/lights/light_red_strobe" );
	level._effect[ "light_white_strobe" ] 								= loadfx( "vfx/lights/light_white_strobe" );
	level._effect[ "light_godray_02" ] 									= loadfx( "vfx/lights/light_godray_beam_2" );	
	level._effect[ "light_godray_02_warbird" ]							= loadfx( "vfx/lights/light_godray_beam_2_warbird_cg" );
	level._effect[ "light_spot_blue" ] 									= loadfx( "vfx/lights/light_spot_blue" );	
	level._effect[ "light_point_blue" ] 								= loadfx( "vfx/lights/light_point_blue" );	
	level._effect[ "light_point_teal" ] 								= loadfx( "vfx/lights/light_point_teal" );		
	level._effect[ "light_spot_rim_burke" ] 							= loadfx( "vfx/lights/light_spot_rim_burke" );
	level._effect[ "light_spot_rim_burke_fadeout" ] 					= loadfx( "vfx/lights/light_spot_rim_burke_fadeout" );
	level._effect[ "light_spot_key_burke" ] 							= loadfx( "vfx/lights/light_spot_key_burke" );	
	level._effect[ "light_point_amber" ] 								= loadfx( "vfx/lights/light_point_amber" );
	level._effect[ "fusion_light_point_amber_control" ] 				= loadfx( "vfx/map/fusion/fusion_light_point_amber_control" );
	level._effect[ "fusion_light_point_blue_kiosk" ] 					= loadfx( "vfx/map/fusion/fusion_light_point_blue_kiosk" );
	level._effect[ "fusion_light_fill_blue_kiosk" ] 					= loadfx( "vfx/lights/fusion/fusion_light_fill_blue_kiosk" );
	level._effect[ "fusion_light_ctrl_room_monitor" ] 					= loadfx( "vfx/lights/fusion/fusion_light_ctrl_room_monitor" );
	level._effect[ "fusion_light_ctrl_room_fill" ] 						= loadfx( "vfx/lights/fusion/fusion_light_ctrl_room_fill" );
	level._effect[ "light_fire_alarm_strobe" ] 							= loadfx( "vfx/lights/light_fire_alarm_strobe" );
	level._effect[ "fusion_light_fill_generic_glows" ] 					= loadfx( "vfx/lights/fusion/fusion_light_fill_generic_glows" );
	level._effect[ "fusion_light_teal_security_cam" ] 					= loadfx( "vfx/lights/fusion/fusion_light_teal_security_cam" );
	level._effect[ "fusion_light_point_blue_monitors" ] 				= loadfx( "vfx/map/fusion/fusion_light_point_blue_monitors" );
	level._effect[ "fusion_light_white_monitor_lrg" ] 					= loadfx( "vfx/map/fusion/fusion_light_white_monitor_lrg" );
	level._effect[ "fusion_reactor_light_glow_white" ] 					= loadfx( "vfx/map/fusion/fusion_reactor_light_glow_white" );
	level._effect[ "fusion_light_yellow_rotate" ] 						= loadfx( "vfx/map/fusion/fusion_light_yellow_rotate" );
	level._effect[ "fus_light_elevator_monitor" ] 						= loadfx( "vfx/lights/fusion/fus_light_elevator_monitor" );
	level._effect[ "fusion_light_point_amber_finale" ]					= loadfx( "vfx/map/fusion/fusion_light_point_amber_finale");	
	level._effect[ "fusion_light_point_fill_finale" ] 					= loadfx( "vfx/map/fusion/fusion_light_point_fill_finale");
	level._effect[ "fusion_light_point_red_control" ] 					= loadfx( "vfx/map/fusion/fusion_light_point_red_control");
	level._effect[ "fusion_light_point_streetlamp_flicker" ] 			= loadfx( "vfx/map/fusion/fusion_light_point_streetlamp_flicker");
    level._effect[ "light_point_open_door" ] 						    = loadfx( "vfx/lights/light_point_open_door" );			
	level._effect[ "light_point_cockpit" ] 							    = loadfx( "vfx/lights/light_point_cockpit" );	
	level._effect[ "light_point_blue_sm" ] 								= loadfx( "vfx/lights/light_point_blue_sm" );	
	level._effect[ "light_point_blue_sm_far" ] 							= loadfx( "vfx/lights/light_point_blue_sm_far" );	
	level._effect[ "light_point_heli_interior_blink" ] 					= loadfx( "vfx/lights/light_point_heli_interior_blink" );
	level._effect[ "light_haze_distant" ] 								= loadfx( "vfx/lights/light_haze_distant" );	
	level._effect[ "light_sunflare" ] 									= loadfx( "vfx/lights/fusion/fusion_light_sunflare" );	
	level._effect[ "warbird_shadow" ] 									= loadfx( "vfx/unique/warbird_shadow" );	
	
	level._effect[ "warbird_shadow_cloaked" ] 							= loadfx( "vfx/unique/warbird_shadow_cloaked" );
	level._effect[ "light_streetlight_flare" ] 							= loadfx( "vfx/lights/light_streetlight_flare" );
	level._effect[ "light_rays_moving_01" ] 							= loadfx( "vfx/lights/light_rays_moving_01" );
	level._effect[ "light_rays_moving_02" ] 							= loadfx( "vfx/lights/light_rays_moving_02" );
	level._effect[ "light_point_blue_mon_left" ] 						= loadfx( "vfx/lights/light_point_blue_mon_left" );
	level._effect[ "light_point_blue_mon_right" ] 						= loadfx( "vfx/lights/light_point_blue_mon_right" );
	level._effect[ "light_explosion_flash" ] 							= loadfx( "vfx/lights/light_explosion_flash" );
	
	//interior
	level._effect[ "water_movement" ]					 				= LoadFX( "fx/water/player_water_wake" );
	
	level._effect[ "steam_pipe_leak_sml" ]								= loadfx( "vfx/steam/steam_pipe_leak_sml");
	level._effect[ "steam_pipe_leak_lrg" ]								= loadfx( "vfx/steam/steam_pipe_leak_lrg");
	level._effect[ "steam_pipe_burst" ]									= loadfx( "vfx/steam/steam_pipe_burst");
	level._effect[ "steam_fill_ground" ]								= loadfx( "vfx/steam/steam_fill_ground");
	level._effect[ "steam_fill_area" ]									= loadfx( "vfx/steam/steam_fill_area");	
	level._effect[ "steam_fill_area_med" ]								= loadfx( "vfx/steam/steam_fill_area_med");
	
	level._effect[ "door_explosion" ]				 					= LoadFX( "vfx/map/fusion/fusion_cntrl_rm_door_explosion" );
	level._effect[ "control_room_glass_shatter" ]			      		= LoadFX( "vfx/map/fusion/fusion_cntrl_rm_glass_shatter" );	
	level._effect[ "control_room_fire_residual" ]			   			= LoadFX( "vfx/map/fusion/fusion_cntrl_rm_fire_residual" );
//	level._effect[ "control_room_door_smoke_residual" ]			   		= LoadFX( "vfx/map/fusion/fusion_cntrl_rm_door_smoke_residual" );
//	level._effect[ "control_room_door_smoke_filler" ]			   		= LoadFX( "vfx/map/fusion/fusion_cntrl_rm_door_smoke_filler" );
//	level._effect[ "control_room_fire_wall_crawler_sm" ]		   		= LoadFX( "vfx/fire/fire_crawl_interior_wall_small" );
//	level._effect[ "control_room_fire_ceiling_crawler_sm" ]		    	= LoadFX( "vfx/fire/fire_crawl_interior_ceiling_small" );
	
	level._effect[ "turbine_explosion" ]				 				= LoadFX( "vfx/map/fusion/fus_turbine_explo_01" );
	level._effect[ "turbine_explosion_initial_burst" ]				 	= LoadFX( "vfx/map/fusion/fus_turbine_explo_init_burst" );
	level._effect[ "turbine_explosion_initial_burst_l" ]				= LoadFX( "vfx/map/fusion/fus_turbine_explo_init_burst_lp" );
	level._effect[ "turbine_explosion_initial_burst_short" ]			= LoadFX( "vfx/map/fusion/fus_turbine_explo_init_burst_short" );
	level._effect[ "turbine_explosion_initital_burst_short_2" ]			= LoadFX( "vfx/map/fusion/fus_turbine_explo_init_burst_short_2" );
	level._effect[ "turbine_explosion_rear_blast" ]				 		= LoadFX( "vfx/map/fusion/fus_turbine_explo_rear_blast" );
	level._effect[ "turbine_explosion_rear_blast_l" ]				 	= LoadFX( "vfx/map/fusion/fus_turbine_explo_rear_blast_lp" );
	level._effect[ "turbine_explosion_rear_blast_small" ]				= LoadFX( "vfx/map/fusion/fus_turbine_explo_rear_blast_sm" );
	level._effect[ "turbine_explosion_rear_blast_small_l" ]				= LoadFX( "vfx/map/fusion/fus_turbine_explo_rear_blast_sm_lp" );
	level._effect[ "turbine_explosion_steam_volume_loop" ]				= LoadFX( "vfx/map/fusion/fus_turbine_explo_steam_volume_lp" );
	level._effect[ "turbine_explosion_init_burst_spurt_r" ]				= LoadFX( "vfx/map/fusion/fus_turbine_explo_init_burst_spurt_r" );
	level._effect[ "turbine_explo_damage" ]								= LoadFX( "vfx/map/fusion/fus_turbine_explo_damage" );
	level._effect[ "light_dust_particles_far" ]							= LoadFX( "vfx/dust/light_dust_particles_far" );
	level._effect[ "reactor_cntrl_rm_light_ray_1" ]						= LoadFX( "vfx/map/fusion/fus_reactor_cntrl_rm_light_ray_1" );
	level._effect[ "turbine_rm_grnd_steam_lp" ]							= LoadFX( "vfx/map/fusion/fus_turbine_rm_grnd_steam_lp" );
	level._effect[ "turbine_door_grnd_steam" ]							= LoadFX( "vfx/map/fusion/fus_turbine_door_grnd_steam" );
	level._effect[ "dust_falling_light_05_runner" ]						= LoadFX( "vfx/dust/dust_falling_light_05_runner" );
	level._effect[ "reactor_rm_reveal_dust" ]							= LoadFX( "vfx/map/fusion/fus_reactor_rm_reveal_dust" );
	level._effect[ "reactor_rm_reveal_light_rays" ]						= LoadFX( "vfx/map/fusion/fus_reactor_rm_reveal_light_rays" );
	level._effect[ "reactor_rm_reveal_light_rays_a" ]					= LoadFX( "vfx/map/fusion/fus_reactor_rm_reveal_light_rays_a" );
	level._effect[ "reactor_rm_reveal_light_rays_b" ]					= LoadFX( "vfx/map/fusion/fus_reactor_rm_reveal_light_rays_b" );
	level._effect[ "fus_crate_dust_fall" ]								= LoadFX( "vfx/map/fusion/fus_crate_dust_fall" );
	level._effect[ "fus_crane_housing_dust" ]							= LoadFX( "vfx/map/fusion/fus_crane_housing_dust_a" );
	level._effect[ "fus_crane_housing_dust_2" ]							= LoadFX( "vfx/map/fusion/fus_crane_housing_dust_b" );
	level._effect[ "fus_crane_housing_dust_fall" ]						= LoadFX( "vfx/map/fusion/fus_crane_housing_dust_fall" );
	level._effect[ "fus_crate_dust_lift" ]								= LoadFX( "vfx/map/fusion/fus_crate_dust_lift" );
	level._effect[ "fus_crane_track_sparks" ]							= LoadFX( "vfx/map/fusion/fus_crane_track_sparks" );
	level._effect[ "water_crawl" ]										= loadfx( "vfx/water/water_crawl_runner");
	level._effect[ "turbine_steam_spray_lp" ]							= loadfx( "vfx/map/fusion/fus_turbine_steam_spray_lp");
	level._effect[ "turbine_steam_volume_lp" ]							= loadfx( "vfx/map/fusion/fus_turbine_steam_volume_lp");
	level._effect[ "lobby_screen_distort" ]								= loadfx( "vfx/map/fusion/fus_lobby_screen_distort");
	level._effect[ "elevator_open_light_rays" ] 						= loadfx( "vfx/map/fusion/fus_elevator_open_light_rays" );
	level._effect[ "fus_crane_light_red" ] 								= loadfx( "vfx/map/fusion/fus_crane_light_red" );
	level._effect[ "fus_crane_light_green" ] 							= loadfx( "vfx/map/fusion/fus_crane_light_green" );
	level._effect[ "elevator_player_slide_dust" ] 						= loadfx( "vfx/map/fusion/fus_elevator_player_slide_dust" );
	level._effect[ "elevator_burke_slide_dust" ] 						= loadfx( "vfx/map/fusion/fus_elevator_burke_slide_dust" );
	level._effect[ "fus_cover_deploy_impact" ] 							= loadfx( "vfx/map/fusion/fus_cover_deploy_impact" );
	level._effect[ "amb_dust_verylight_fade" ] 							= loadfx( "vfx/dust/amb_dust_verylight_fade" );
	level._effect[ "fus_amb_dust_reactor" ] 							= loadfx( "vfx/map/fusion/fus_amb_dust_reactor" );
	level._effect[ "fus_turbine_dmg_smk" ] 								= loadfx( "vfx/map/fusion/fus_turbine_dmg_smk" );
	level._effect[ "dust_falling_column_lp" ] 								= loadfx( "vfx/dust/dust_falling_column_lp" );

}

treadfx_override()
{
	waittillframeend;
	level.treadfx_maxheight = 2500;
	//helicopter tread fx
	vehicletype_fx[0] = "script_vehicle_xh9_warbird_no_turret";
	vehicletype_fx[1] = "script_vehicle_xh9_warbird_stealth";
	vehicletype_fx[2] = "script_vehicle_xh9_warbird_stealth_no_turret";
	vehicletype_fx[3] = "script_vehicle_xh9_warbird_low";
	vehicletype_fx[4] = "script_vehicle_xh9_warbird_low_no_zipline";
	vehicletype_fx[5] = "script_vehicle_xh9_warbird_low_no_turret_no_zipline";
	fx = "vfx/treadfx/heli_dust_warbird";
	sand_fx = "vfx/treadfx/heli_sand_wet_warbird";
	water_fx = "vfx/treadfx/heli_water_warbird";
	no_fx = "vfx/unique/no_fx";
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
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", sand_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
	  	maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", sand_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none" );
	}
	vehicletype1P_fx[0] = "script_vehicle_xh9_warbird";
	foreach(vehicletype in vehicletype1P_fx)
	{
		maps\_treadfx::setvehiclefx( vehicletype, "brick", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "bark", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "glass", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "grass", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ice", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "metal", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", sand_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", no_fx );
	  	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", no_fx );
	  	maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", sand_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "riotshield", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "slush", no_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", no_fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none" );
	}
	fx = "vfx/treadfx/x4walker_dust";
	maps\_treadfx::setallvehiclefx( "script_vehicle_x4walker_wheels", fx );
	maps\_treadfx::setallvehiclefx( "script_vehicle_x4walker_wheels_physics", fx );
	//maps\_treadfx::setallvehiclefx( "script_vehicle_walker_tank", fx );
	
	fx = "vfx/treadfx/heli_dust_warbird";
	maps\_treadfx::setallvehiclefx( "script_vehicle_mi17_woodland_fly", fx );
}



intro_ar_sethud()
{
	//Set some dup params on the different overlays
	self.x = 0;
	self.y = 0;
	self.splatter = true;
	self.alignX = "center";
	self.alignY = "middle";
	self.foreground = 0;
	self.horzAlign = "center";
	self.vertAlign = "middle";
	self.alpha = 1;
}

intro_ar_anchor_anim(in_time)
{
	qr_anchor[0] = NewClientHudElem( level.player );
	qr_anchor[0] SetShader( "qr_anchor", 30, 30 );
	qr_anchor[0] intro_ar_sethud();
	qr_anchor[0].sort = 9;
	qr_anchor[0].x = -49;
	qr_anchor[0].y = 49;

	qr_anchor[1] = NewClientHudElem( level.player );
	qr_anchor[1] SetShader( "qr_anchor", 30, 30 );
	qr_anchor[1] intro_ar_sethud();
	qr_anchor[1].sort = 9;
	qr_anchor[1].x = -49;
	qr_anchor[1].y = -49;

	qr_anchor[2] = NewClientHudElem( level.player );
	qr_anchor[2] SetShader( "qr_anchor", 30, 30 );
	qr_anchor[2] intro_ar_sethud();
	qr_anchor[2].sort = 9;
	qr_anchor[2].x = 49;
	qr_anchor[2].y = -49;

	qr_anchor[3] = NewClientHudElem( level.player );
	qr_anchor[3] SetShader( "qr_anchor", 30, 30 );
	qr_anchor[3] intro_ar_sethud();
	qr_anchor[3].sort = 9;
	qr_anchor[3].x = 49;
	qr_anchor[3].y = 49;	
	
	for( i = 0; i < ( in_time * 20 ); i++ )
	{
		//Should repeat this cycle every second
		
		curr_time = ( float(i) / 20.0 ) - int( float(i) / 20.0 );
		//anim alpha of each
		qr_anchor[0].alpha = curr_time;
		qr_anchor[1].alpha = max( curr_time - .35, 0 ) / .65;
		qr_anchor[2].alpha = max( curr_time - .6, 0 ) / .4;
		qr_anchor[3].alpha = max( curr_time - .85, 0 ) / .15;
		level waitframe();
		
	}
	qr_anchor[0] Destroy();
	qr_anchor[1] Destroy();
	qr_anchor[2] Destroy();
	qr_anchor[3] Destroy();
		
}

intro_ar_loadtext( in_time )
{
	loadtext = NewClientHudElem( level.player );
	loadtext SetShader( "ar_loadtext", 128, 32 );
	loadtext intro_ar_sethud();
	loadtext.sort = 9;
	//loadtext.x = -128;
	loadtext.y = -96;	for( i = 0; i < ( in_time * 20 ); i++ )
	{
		//Should repeat this cycle every second
		
		curr_time = ( float(i) / 20.0 ) - int( float(i) / 20.0 );
		//anim alpha of each
		loadtext.alpha = curr_time;
		level waitframe();
		
	}	
	loadtext Destroy();
}

intro_ar_anim_shg( elem )
{
	//move the qr to the bottom left of the screen
	for( i = 0; i < 10; i ++)
	{

		curr_i = ( float(i) / 10.0 ) - int( float(i) / 10.0 );
		elem.x = -380 * curr_i;
		elem.y = 186 * curr_i;
		level waitframe();
	}
	wait(20);
	for( i = 0; i < 20; i ++)
	{

		curr_i = ( float(i) / 20.0 ) - int( float(i) / 20.0 );
		elem.alpha = 1 - curr_i;
		level waitframe();
	}
	elem Destroy();
}

intro_ar_load_screen()
{
	//Do the load screen for 3 seconds	
	/*
	qr_mask = NewClientHudElem( level.player );
	qr_mask SetShader( "qr_mask", 128, 128 );
	qr_mask intro_ar_sethud();
	qr_mask.sort = 8;
	qr_noise = NewClientHudElem( level.player );
	qr_noise SetShader( "qr_noise", 128, 128 );	
	qr_noise intro_ar_sethud();
	qr_noise.sort = 2;
	thread intro_ar_anchor_anim(3.0);
	thread intro_ar_loadtext(3.0);
	wait(3.0);
	qr_mask destroy();	
	qr_noise Destroy();
	qr_sledgehammer = NewClientHudElem( level.player );
	qr_sledgehammer SetShader( "qr_sledgehammer", 128, 128 );	
	qr_sledgehammer intro_ar_sethud();
	thread intro_ar_anim_shg(qr_sledgehammer);
	*/
}


intro_ar_path_anim( armap, tag_a, tag_b, tag_c, tag_d )
{
	wait( 7.0 );
	PlayFXOnTag( getfx( "ar_pathA" ), tag_a, "tag_origin" );
	wait( 1.0 );
	PlayFXOnTag( getfx( "ar_pathB" ), tag_b, "tag_origin" );
	wait( 1.0 );
	PlayFXOnTag( getfx( "ar_pathC" ), tag_c, "tag_origin" );
	wait( 1.0 );
	PlayFXOnTag( getfx( "ar_pathD" ), tag_d, "tag_origin" );
}


intro_ar_scale_ssao( target_ssao, lerp_time )
{
	curr_ssao = GetDvarFloat( "r_ssaoStrength" );
	lerp_ssao = target_ssao - curr_ssao;
	iter_max = lerp_time * 20;
	for ( i = 0; i < iter_max; i++ )
	{
		new_ssao = curr_ssao + lerp_ssao * ( i / iter_max );
		SetSavedDvar( "r_ssaoStrength", new_ssao );
		waitframe();
	}
	SetSavedDvar( "r_ssaoStrength", target_ssao );
}

#using_animtree( "script_model" );
intro_armap_moment()
{
	wait(1.0);
	if ( !IsDefined( level.start_point ) || 
	    ( level.start_point != "fly_in_animated" &&
	      level.start_point != "fly_in_animated_part2" ))
		return;

	//intro_ar_load_screen();
	//Play the AR map on the heli ar bone
	//Load actor here
	
	armap = getent("armap","targetname");
	armapshade = getent( "armapshade", "targetname");
	armapdist = getent( "armapdist", "targetname");
	armaplow = getent( "armaplow", "targetname");
	fx_tag = spawn_tag_origin();
	fx_tag.origin = armapshade GetTagOrigin( "tag_fx" );
	fx_tag.angles = armapshade GetTagAngles( "tag_fx" );
	fx_tag linkto( armapshade , "tag_fx" );
	tag_a = spawn_tag_origin();
	tag_a.origin = armapshade GetTagOrigin( "tag_pathA" );
	tag_a.angles = armapshade GetTagAngles( "tag_pathA" );
	tag_a linkto( armapshade , "tag_pathA" );	
	tag_b = spawn_tag_origin();
	tag_b.origin = armapshade GetTagOrigin( "tag_pathA1" );
	tag_b.angles = armapshade GetTagAngles( "tag_pathA1" );
	tag_b linkto( armapshade , "tag_pathA1" );	
	tag_c = spawn_tag_origin();
	tag_c.origin = armapshade GetTagOrigin( "tag_pathA2" );
	tag_c.angles = armapshade GetTagAngles( "tag_pathA2" );
	tag_c linkto( armapshade , "tag_pathA2" );	
	tag_d = spawn_tag_origin();
	tag_d.origin = armapshade GetTagOrigin( "tag_pathA3" );
	tag_d.angles = armapshade GetTagAngles( "tag_pathA3" );
	tag_d linkto( armapshade , "tag_pathA3" );	
	
	
	////refl_closed = GetEnt( "fus_flat_reflector_org", "targetname" );
	armapshade OverrideReflectionProbe( ( 10960, -112640, 1912 ) );
	armaplow OverrideReflectionProbe( ( 10960, -112640, 1912 ) );
	armap OverrideReflectionProbe( ( 10960, -112640, 1912 ) );
	
	armapshade SetMaterialScriptParam( 0.0, 0.0 );
	armapbox = getent( "armapbox", "targetname");
	temp = [];
	temp[0] = armap;
	temp[0].animname = "ar_map";
	temp[0] assign_animtree();
	temp[1] = armapshade;
	temp[1].animname = "ar_map";
	temp[1] assign_animtree();	
	temp[2] = armapdist;
	temp[2].animname = "ar_map";
	temp[2] assign_animtree();	
	temp[3] = armaplow;
	temp[3].animname = "ar_map";
	temp[3] assign_animtree();	
	
	armap hide();
	armapshade hide();
	armapdist hide();
	armaplow hide();
	
	if( !IsDefined( "fusion_map_open" ) ) flag_init( "fusion_map_open" );
	flag_wait( "fusion_map_open" );

	warbird = level.warbird_a;


	
	warbird anim_first_frame( temp, "fly_in_intro", "tag_ar_map" );
	
	//using this flag in the lighting gsc to enable grain and vision set
	flag_set("fx_ar_start");
	curr_ssao = 0;
	if ( IsUsingSSAO() )
	{
		curr_ssao = GetDvarFloat( "r_ssaoStrength" );
		thread intro_ar_scale_ssao( 0.0, 1.0 );
	}
	
	PlayFxOnTag(getfx("ar_map"), fx_tag, "tag_origin" );
	armap LinkTo( warbird, "tag_ar_map" );
	armapshade LinkTo( warbird, "tag_ar_map" );
	armapdist LinkTo( warbird, "tag_ar_map" );
	armaplow LinkTo( warbird, "tag_ar_map" );
	if( !IsDefined( "fusion_start_map_anim" ) ) flag_init( "fusion_start_map_anim" );
	if( !IsDefined( "fusion_stop_map_anim" ) ) flag_init( "fusion_stop_map_anim" );

	flag_wait( "fusion_start_map_anim" );
	//armap show();
	armapshade show();
	armapdist show();
	armaplow show();
	armaplow HidePart( "body_4" );
	armaplow HidePart( "body_6" );
	
	thread intro_ar_path_anim( armap, tag_a, tag_b, tag_c, tag_d );
	
	thread intro_play_ar_anim( warbird, temp );
	
	flag_wait( "fusion_map_target_01" );
	armaplow showPart( "body_4" );
	flag_wait( "fusion_map_target_02" );
	armaplow showPart( "body_6" );
	
	flag_wait( "fusion_stop_map_anim" );
	if ( IsUsingSSAO() )
		thread intro_ar_scale_ssao( curr_ssao, 1.0 );
	armap hide();
	armapshade delete();
	armapdist delete();
	armaplow delete();
	fx_tag.origin = ( 0, 0, 0 );
	tag_a.origin = ( 0, 0, 0 );
	tag_b.origin = ( 0, 0, 0 );
	tag_c.origin = ( 0, 0, 0 );
	tag_d.origin = ( 0, 0, 0 );
	stopFxOnTag(getfx("ar_map"), fx_tag, "tag_origin");
	PlayFxOnTag(getfx("ar_map_dis"), armap, "tag_fx");
	wait( 1.0 );
	armap delete();
	fx_tag delete();
	tag_a delete();
	tag_b delete();
	tag_c delete();
	tag_d delete();
	
	
	//using this flag in the lighting gsc to disable grain and vision set
	flag_set("fx_ar_stop");
	
	//stopFxOnTag(getfx("ar_map"), heli, "tag_ar_map");
	//PlayFxOnTag(getfx("ar_map_dis"), heli, "tag_ar_map");
}

intro_play_ar_anim( warbird, actors )
{
	warbird anim_single( actors, "fly_in_intro", "tag_ar_map" );
	
}

flak_intro_sequence()
{
	flag_wait("fx_flak_intro");
	//wait 19;
	//IPrintLnBold("start exploder");
	exploder(1019);//flak "area"
	exploder(1028);//ambient forest fog behind cooling tower during helicopter approach
	
	//Flak Close Call Sequence
	exploder(1023);
	wait 1;
	exploder(1024);
	wait 1.5;
	exploder(1025);
	wait .5;
	exploder(1026);
	wait 3;
	exploder(1027);

	wait (3);                                       
	kill_exploder(1019);

	//kill flak close call exploders
	kill_exploder(1023);
	kill_exploder(1024);
	kill_exploder(1025);
	kill_exploder(1026);
	kill_exploder(1027);
	wait (12);
	//IPrintLnBold("kill exploder");
	kill_exploder(1028); //killing ambient fog for forest
}


intro_fly_in_missile_hit_warbird(heli)
{
	//playfxontag(getfx("aerial_explosion_heli_large"),heli,"tag_origin");
	//explosionLoc = heli GetTagOrigin("TAG_STATIC_MAIN_ROTOR_L");
	snd_message( "missile_hit_warbird_b" );
	explosionLoc = heli GetTagOrigin("jnt_wingSocket_L");
	playfx(getfx("aerial_explosion_heli_large"), explosionLoc);
	PlayFxOnTag(getfx("light_explosion_flash"), level.warbird_a, "TAG_open_door");
	damagedFireTag = spawn_tag_origin();
	tagOffset = (-18.957,66.128,-7.108);
	damagedFireTag linkto(heli, "body_animate_jnt", tagOffset, (0,0,0));
	playfxontag(getfx("vehicle_damaged_fire_m"), damagedFireTag, "tag_origin");
	playfxontag(getfx("vehicle_damaged_fire_m"), heli, "TAG_STATIC_TAIL_ROTOR");
	playfxontag(getfx("fusion_warbird_interior_fire"), heli, "body_animate_jnt");
	
	flag_wait("fx_heli_rotorsmoke_start");
	playfxontag(getfx("vehicle_damaged_rotorsmoke"), heli, "TAG_STATIC_MAIN_ROTOR_R");
	wait 0.4;
	stopfxontag(getfx("vehicle_damaged_fire_m"), damagedFireTag, "tag_origin");
	
	flag_wait("fx_warbird_hit_tower");
	stopfxontag(getfx("vehicle_damaged_rotorsmoke"), heli, "TAG_STATIC_MAIN_ROTOR_R");
	//wait 0.1;
	//playfxontag(getfx("vehicle_damaged_fire_m"), damagedFireTag, "tag_origin");
	stopfxontag(getfx("vehicle_damaged_fire_m"), heli, "TAG_STATIC_TAIL_ROTOR");
	stopfxontag(getfx("fusion_warbird_interior_fire"), heli, "tag_origin");
	stopfxontag(getfx("light_explosion_flash"), level.warbird_a, "TAG_open_door");
}

intro_fly_in_missile_hit_warbird_tower(heli)
{
	snd_message( "warbird_b_crash_tower" );
	exploder(5);
	flag_set("fx_warbird_hit_tower");
}

play_tower_debris_fx(debris)
{
	flag_wait("fx_warbird_hit_tower");
	wait 0.2;
	playfxontag(getfx("trail_concrete_dust_m"), debris, "jo_fus_tower_concrete_chunk_07");
	playfxontag(getfx("trail_concrete_dust_m"), debris, "jo_fus_tower_concrete_chunk_20");
	playfxontag(getfx("trail_concrete_dust_m"), debris, "jo_fus_tower_concrete_chunk_11");
	wait 4;
	stopfxontag(getfx("trail_concrete_dust_m"), debris, "jo_fus_tower_concrete_chunk_07");
	stopfxontag(getfx("trail_concrete_dust_m"), debris, "jo_fus_tower_concrete_chunk_20");
	stopfxontag(getfx("trail_concrete_dust_m"), debris, "jo_fus_tower_concrete_chunk_11");
}

intro_fly_in_missile_hit_warbird_rotorsmoke(heli)
{
	flag_set("fx_heli_rotorsmoke_start");
}

intro_fly_in_missile_hit_warbird_rotorsmoke_stop(heli)
{
	flag_set("fx_heli_rotorsmoke_stop");
}


ambient_explosion_before_landing()
{
	level waittill( "fly_in_missiles_scene_end" );
	//wait 7.0;
	
	delaythread (6.35, ::exploder, 1111);
	delaythread (11.25, ::exploder, 1112);
	delaythread (10.8, ::exploder, 1113);
	delaythread (12.35, ::exploder, 1114);
	delaythread (15.2, ::exploder, 1115);
	delaythread (17.7, ::exploder, 1116);
	delaythread (20.7, ::exploder, 1117);
	delaythread (26.5, ::exploder, 1118);
	
	//heli rotor dust approach
	delaythread (25.5, ::exploder, 1119);
	delaythread (26.5, ::exploder, 1120);
	delaythread (27, ::exploder, 1121); 
	delaythread (27.0, ::kill_exploder, 1119);
	delaythread (27.75, :: kill_exploder, 1120);
	delaythread (27.75, :: kill_exploder, 1121);
	
}

mobile_turret_landing( ent )
{
	//play vfx
	exploder( "x4walker_landing" );
}

warbird_dropping_mobile_tuerret_camshake()
{
	flag_wait ("cam_shake_start");
	
	self endon( "cam_shake_stop" );
	
	exp = get_exploder_ent("x4walker_landing");
	pos = exp.v["origin"];
	rampup = 0.01;
	i = 0;
	for (;;)
	{
		//IPrintLnBold("shake");
		mag = distance2d(pos,level.player.origin);
		scale = .125 * clamp(1.0-(mag/3000.00),0.01,1.0) * (rampup/2.0);
		waittime = randomfloat(1.0) * 8.0+ 1.0;
		earthquake( scale, waittime * 2, pos, 5000 );
		rampup = clamp(rampup + (waittime /  20.0),0.01,2.0);
		wait(waittime / 20.00);
	}
}

ambient_large_pipe_effects_courtyard()
{
	flag_wait("fx_flak_intro");
		exploder (1122);

		
		flag_wait("msg_vfx_zone4_control_room");
		kill_exploder (1122);
}

ambient_explosion_courtyard()
{
	//level endon ("msg_vfx_zone4_control_room");
	level endon ("flag_walker_tank_on_mount");
	
	wait(0.75);
	
	expPos = [	( -2135.1, -3698.59, -64 ),
	         	( -1181.94, -3841.46, -72 ),
	         ( -738.545, -3005.74, -64 ),
	         ( -2049.48, -653.422, -64 ),
	          ( -795.404, 585.719, -64 ), 
	         //( -931.282, 1051.44, -20.4857 ),
	         ( -1022.7, 902.717, -62.1685 ),
	         ( -917.762, 761.175, -64 ),
	         ( -1479.69, 606.371, -66.4426 ),
	         ( -2464.02, -1118.15, -64 ),
	         ( -2218.7, -1756.35, -64 ),
	         ( -2094.02, -1687.31, -63.8713 ),
	         ( -1931.62, -1732.27, -72 ),
	         ( -1957.58, -1154.64, -75.0965 ),
	         ( -2143.91, -1378.41, -67.8419 ),
	         ( -3387.4, -1368.2, -72 ),
	         ( -3106.98, -1156.51, -64.2818 ),
	         ( -1927.16, -3345.66, -42.5959 ),
	         ( -1948.84, -3207.7, -60.2125 ),
	         ( -1717.67, -3271.47, -94.9994 ),
	         ( -1723.4, -3073.26, -76.9196 ),
	         ( -1307.31, -2911.27, -61 ),
	         //( -839.466, -2821.12, -57.1214 ),
	         ( -601.993, -2740.76, 73.8904 ),
	       	 //( -949.466, -2204.04, -53.3492 ),
	       	 ( -1038.27, -2213.41, -70.8464 ),
	       	 ( -955.833, -2414.59, -72 ),
	        //( -929.269, -1805.3, -70.4676 ),
	        //( -993.023, -1912.48, -64.2161 ),
	        ( -800.89, -372.677, 64.125 ),
	        ( -1323.77, -1042.5, -61.2828 ),
	        ( -1101.12, -866.911, -72 ),
	        //( -1414.93, -916.39, -63.1381 ),
	        ( -1539.22, -988.012, -72 ),
	         ( -2506.34, 669.644, -16.9688 ),
	        ( -2390.12, 356.47, -57.4423 ),
	        ( -2194.72, -379.348, -64 ),
	        ( -2439.9, -660.093, -47.8124 ),
	        ( -1253.71, 1533.15, -66.6647 ),
	       ( -1948.8, 198.326, -72 ),
	       //( -1182.08, 1379.85, -65.6224 ),
	       //( -1126.1, 1220.16, -64 ),
	       ( -1099.36, 1027.41, -60.2436 ),
	       ( -2139.53, 1605.81, -47.8953 ),
	       ( -2129.62, 1400.37, -46.2778 ),
	       ( -2004.05, 1230.47, -71.0872 ),
	       ( -2170.44, 2009.04, -51.2272 ),
	       ( -1423.78, 2737.93, -41.1722 ),
	       ( -1196.03, 2478.15, -55.2367 ),
	       ( -1373.31, 2350.54, 14.5669 ),
	       ( -832.627, -3001.28, -58 ),
	       ( -2227.74, 2582.45, -64 ),
	       ( -824.68, -4585.95, -69 ),
	       ( -750.72, -4358.39, -51 ),
	       	       ( -1874.07, -2645.55, -72 )];
	
	
	
    for(;;)
	{
		flag_wait ("msg_vfx_zone2_courtyard");
    	//Wait a # of seconds
		randomInc = randomfloatrange(.5,1.5)+1;
		wait(randomInc);
				
		fxEnts = [];
		//Find the explosions the player is looking at
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		ent = get_exploder_ent(2011);
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < expPos.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(expPos[i]-level.player.origin);
			if(vectordot(eye,toFX)>.60) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = expPos[i];
				break;
			}
		}
		
		//to1.origin = self.player getorigin();
		if(found_exp >0)
		{
			curr_exp_num = randomInt( final_exp_pos.size );
			if(isdefined(curr_exp_num))
			{
				ent.v["origin"] = final_exp_pos[curr_exp_num];
				if(isdefined(ent.v["origin"]) && isdefined(ent)) 
				{
					exploder_num = 2011;				
					ambient_explosion_play( final_exp_pos[curr_exp_num], "explo_ambientExp_dirt",  exploder_num );
				}
			}
			wait(0.75);
		}
	}

}


vfx_control_room_explo()

{
	flag_wait( "control_room_explosion" );
	explosion_org = getstruct( "control_room_door_explosion_fx_org", "targetname" );
    playfx( getfx( "door_explosion" ), explosion_org.origin );
    Earthquake( 2, 0.5, explosion_org.origin, 500 );

	thread control_room_interior_vfx_on();
}

	Control_room_interior_vfx_on()
{
	Exploder(4005);
}

	
dust_falling_control_room()
{
	flag_wait( "control_room_explosion" );
	///level waittill("dust_falling");
	//IPrintLnBold("SHAKE AND DUST!");
	exploder(4010);
 	
 	//IPrintLnBold("cleanup!");
}



ambient_gas_explosion_loading_zone()
{
	flag_wait ("hangar_enemies");
	//exploder(5010);
	//1st pressure explosion vfx on the left side pipe in the hanger
	
	flag_waitopen( "dialogue_playing" );
	exploder ( 5101 );
	snd_message( "pressure_explosion", 5101);
	exploder ( 5104 );
	
	wait .5;
	
	//2nd pressure explosion vfx on the ground pipe in the hanger
	flag_waitopen( "dialogue_playing" );
	exploder ( 5102 );
	snd_message( "hangar_explo_and_debris_01" );
	wait 1;
	exploder(5010);
	// trigger the fire loops and steam pressure loops in the hangar.
	self snd_message("snd_start_fire_steam");
	
	//3rd pressure explosion vfx on the left side pipe in the hanger
	flag_waitopen( "dialogue_playing" );
	exploder ( 5103 );
	snd_message( "hangar_explo_and_debris_02", 5103 );
	
	flag_wait ("msg_vfx_zone7_cooling_tower_explosion");
	kill_exploder(5010);
}

ambient_explosion_dirt_cooling_towers()
{
	level endon ( "player_start_cooling_tower" );
	
	
	expPos = [	(8957.59, 7017.06, 26.9421),
	         	(9659.96, 8226.08, 117.914),
	         	(9834.7, 8370.35, 114.27),
	         	(10194.9, 9516.71, -8),
	         	(11390, 9530.37, -132.036),
	         	(8927.76, 6878.92, 0.810944),
	         	(9168.17, 7216.31, 85.8958),
	         	(8937.92, 7296.15, 52.2326),
	         	(7803.14, 7801.35, -8),
	         	(10356.8, 8449.89, 213.607),
	         	(10379.7, 8239.65, 306.156),
	         	(10596.6, 8707.56, 89.2881),
	         	(10309.8, 9759.41, -35.0003),
	         	(10422.3, 10575.1, -112.38),
	         	(10449.3, 10832.8, -127.599),
	            (9950.04, 11151.1, -109.244),
	            (10046.7, 10779.7, -63.9351)];
				
		
    for(;;)
	{
		flag_wait ("msg_vfx_zone6_cooling_towers");
    	//Wait a # of seconds
		randomInc = randomfloatrange(1.5,3)+1;
		wait(randomInc);
				
		fxEnts = [];
		//Find the explosions the player is looking at
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		ent = get_exploder_ent(2011);
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < expPos.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(expPos[i]-level.player.origin);
			if(vectordot(eye,toFX)>.60) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = expPos[i];
				break;
			}
		}
		
		//to1.origin = self.player getorigin();
		if(found_exp > 0)
		{
			curr_exp_num = randomInt( final_exp_pos.size );
			if(isdefined(curr_exp_num))
			{
				ent.v["origin"] = final_exp_pos[curr_exp_num];
				if(isdefined(ent.v["origin"]) && isdefined(ent)) 
				{
					exploder_num = 2011;				
					ambient_explosion_play( final_exp_pos[curr_exp_num], "explo_ambientExp_dirt",  exploder_num );
				}
			}
			wait(0.75);
		}
	}
}

ambient_explosion_fireball_cooling_towers()
{
	level endon ( "player_start_cooling_tower" );
	
	
	expPos = [	(7266.51, 7360.84, -87.284),
	         	(9549.09, 6211.15, 5.91302), 
				(8878.34, 6721.48, -8),
				(10943.5, 10231.7, -136), 
				(10507.7, 10992.2, -136), 
				(10252.2, 10559.4, -35.253),
				(10329, 9553.58, -21.2638)];
				
	
    for(;;)
	{
		flag_wait ("msg_vfx_zone6_cooling_towers");
    	//Wait a # of seconds
		randomInc = randomfloatrange(3,5)+1;
		wait(randomInc);
				
		fxEnts = [];
		//Find the explosions the player is looking at
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		ent = get_exploder_ent(1111);
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < expPos.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(expPos[i]-level.player.origin);
			if(vectordot(eye,toFX)>.60) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = expPos[i];
				break;
			}
		}
		
		//to1.origin = self.player getorigin();
		if(found_exp > 0)
		{
			curr_exp_num = randomInt( final_exp_pos.size );
			if(isdefined(curr_exp_num))
			{
				ent.v["origin"] = final_exp_pos[curr_exp_num];
				if(isdefined(ent.v["origin"]) && isdefined(ent)) 
				{
					exploder_num = 1111;
					ambient_explosion_play( final_exp_pos[curr_exp_num], "explo_ambientExp_fireball",  exploder_num );
				}
			}
			wait(0.75);
		}
	}
}

ambient_explosion_play( exploder_pos, exploder_type, exploder_num )
{
	switch ( exploder_type )
	{
		case "explo_ambientExp_dirt":
			if ( Distance( exploder_pos, level.player.origin ) <  1800 )
				flag_waitopen( "dialogue_playing" );
			snd_message( exploder_type, exploder_pos, exploder_num );
			break;
			
		case "explo_ambientExp_fireball":
			exploder(exploder_num);
			snd_message( exploder_type, exploder_pos );
			break;
			
		default:
			break;	
	}
}
					
warbird_hoverdust()
{
	//turn off dust attached to warbird
	flag_wait("fx_flak_intro");
	StopFxOnTag((getfx("fast_blowing_dust")), level.warbird_a, "TAG_outside_door");
	//turn on and off placed heli dust for warbird near landing area
	flag_wait("fx_warbird_hoverdust");
	exploder(1090);
	flag_waitopen("fx_warbird_hoverdust");
	wait 8.5;
	stop_exploder(1090);
}

vfx_zipgun_fire(guy)
{
	//play fx
	playfxontag(getfx("harpoon_dust"), guy, "jnt_harpoon");
	playfxontag(getfx("zipline_flash_view"), guy, "TAG_FLASH");
}

//reactor room light rays near entrance turn off

//kill exterior vfx
kill_exterior_vfx()
{	
	flag_wait("msg_vfx_zone3_lab_room_section_1");
	
	//turn off exterior smoke vfx
	thread stop_smoke_pillar_black_large_fast_fx();
	thread stop_smoke_pillar_gray_large_fast_fx();
	thread stop_smoke_pillar_black_large_slow_fx();
	
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "fxid" ] == "fog_distant_vista" ) || ( fx.v[ "type" ] == "oneshotfx" ))  
			fx pauseEffect();
		
	}
	
}

fx_elevator_descent_burke( burke ) //dust vfx that play from the elevator cables as burke slides down
{
	exploder ( 3350 );
	PlayFxOnTag(getfx( "elevator_burke_slide_dust" ), burke, "j_wrist_le");
	//StopFXOnTag(getfx( "elevator_burke_slide_dust" ), burke, "j_wrist_le" );
}

reactor_light_rays()
{
	flag_wait ( "reactor_light_rays" );
	//IPrintLnBold ( "light_rays" );
	pauseExploder (3302);
	pauseExploder (3303);
	pauseExploder (3304);
	
}

//restart exterior vfx except for fog


restart_exterior_vfx()
{
	flag_wait ( "msg_vfx_zone4_control_room" );
	
	thread start_smoke_pillar_black_large_fast_fx();
	thread start_smoke_pillar_gray_large_fast_fx();
	thread start_smoke_pillar_black_large_slow_fx();

}


//pressure explosion from the big pipe on the street toward the cooling tower
big_pipe_explosion_vfx_after_hangar()
{
	exploder ( 6500 ); //explosion
	snd_message( "pressure_explosion", 6500);
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.4, 1, level.player.origin, 200 );
	
	wait .75;
	exploder ( 6501 ); // 1st lingering looping steam
	wait .15;
	exploder ( 6502 ); // 2nd lingering looping steam
	exploder ( 6503 ); // small pipe burst covering
}

//underground pressure explosion - utility truck
underground_pipe_explosion_utility_truck_vfx(explosion_cart)
{
	exploder ( 6510 ); //explosion
	exploder_number = 6510;
	//level.player playsound ( "big_explosion_02_temp" );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.55, 1, level.player.origin, 200 );
	snd_message("fus_truck_flip_01", exploder_number);	
	
	playfxontag(getfx("trail_steam_round_lrg_runner"), self, "tag_origin");//Steam trail from truck
	playfxontag(getfx("trail_spark_burst_explosion"), self, "tag_origin");//Spark trail from truck
	exploder ( 6512 ); //truck impact ground	
	
	wait 1.75;
	exploder ( 6511 ); //lingering looping steam
}
	
//underground pressure explosion - pickup truck
underground_pipe_explosion_pickup_truck_vfx(explosion_cart)
{
	exploder ( 6520 ); //explosion
	exploder_number = 6520;
	//level.player playsound ( "big_explosion_02_temp" );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 1, 1, level.player.origin, 200 );
	snd_message("fus_truck_flip_02", exploder_number);
	
	playfxontag(getfx("trail_steam_round_lrg_runner"), self, "tag_origin");//steam trail on pick up truck
	//playfxontag(getfx("trail_spark_burst_explosion"), self, "tag_origin");//Spark trail from truck
	exploder ( 6522 ); //truck impact ground Temp FX	
	
	wait 2.65;
	exploder ( 6521 ); //lingering looping steam

}
	


init_smVals()
{
	setsaveddvar("fx_alphathreshold",5);
	
	level waittill ("big_moment_vfx_start");
	setsaveddvar("fx_alphathreshold",12);
	

}		


//kill all env vfx before big moment vfx starts
kill_all_env_fx()
{	
	level waittill ("big_moment_vfx_start");
	
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "type" ] == "oneshotfx" ) || ( fx.v[ "type" ] == "exploder" ))  
		fx pauseEffect();
	}
}

pressure_explosion_lead_up()
{
	delaythread (.05, ::pressure_explosion_leadup_1);
	//delaythread (.15, ::pressure_explosion_leadup_2);
	//delaythread (.35, ::pressure_explosion_leadup_3);
	delaythread (.4, ::pressure_explosion_leadup_4);
	delaythread (.75, ::pressure_explosion_leadup_5);
	delaythread (.8, ::pressure_explosion_leadup_6);
	delaythread (.95, ::pressure_explosion_leadup_7);
	delaythread (.85, ::big_moment_ending_vfx_tower_initial_crack); //spawn vfx to cover the cracks on the tower when geo swaps
}

pressure_explosion_leadup_1()
{
	exploder (7001);
	snd_message( "pressure_explosion", 7001 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.3, .5, level.player.origin, 500 );
}

pressure_explosion_leadup_2()
{
	exploder (7002);
	snd_message( "pressure_explosion", 7002 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.3, .5, level.player.origin, 500 );
}

pressure_explosion_leadup_3()
{
	exploder (7003);
	snd_message( "pressure_explosion", 7003 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.3, .5, level.player.origin, 500 );
}

pressure_explosion_leadup_4()
{
	exploder (7004);
	snd_message( "pressure_explosion", 7004 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.3, .5, level.player.origin, 500 );
}

pressure_explosion_leadup_5()
{
	exploder (7005);
	snd_message( "pressure_explosion", 7005 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.3, .5, level.player.origin, 500 );
}

pressure_explosion_leadup_6()
{
	exploder (7006);
	snd_message( "pressure_explosion", 7006 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.3, .5, level.player.origin, 500 );
}

pressure_explosion_leadup_7()
{
	exploder (7007);
	snd_message( "pressure_explosion", 7007 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	earthquake( 0.3, .5, level.player.origin, 500 );
}

big_moment_ending_vfx_tower_initial_crack()
{
	exploder (7100);
}

big_moment_ending_vfx( collapse_parts )
{
	level notify ("big_moment_vfx_start");
	
	delaythread (.05, ::big_moment_ending_vfx_shockwave);
	delaythread (.1, ::big_moment_ending_vfx_ground_buckling);
	delaythread (1.75, ::big_moment_ending_vfx_tower_explode);
	delaythread (.1, ::big_moment_ending_vfx_trailing_dust, collapse_parts);
	delaythread (1.0, ::big_moment_ending_vfx_tower_smoke_up);
	//delaythread (.7, ::big_moment_ending_vfx_donut_smk);
	delaythread (.7, ::big_moment_ending_vfx_ground_splinter_up);
	delaythread (.3, ::big_moment_ending_vfx_falling_rock);
	delaythread (1.0, ::big_moment_ending_vfx_ash_fall);
	delaythread (1.0, ::big_moment_ending_vfx_rolling_smk);
	delaythread (2.0, ::big_moment_ending_vfx_thick_smk_vm);
	delaythread (22.0, ::big_moment_ending_vfx_falling_debris);
	delaythread (26.0, ::big_moment_ending_vfx_bouncing_rocks);
	delaythread (6.3, ::big_moment_ending_vfx_falling_debris_tower);
	delaythread (6.7, ::big_moment_ending_vfx_tower_pillar_left_burst);
	delaythread (8.5, ::big_moment_ending_vfx_tower_pillar_right_burst);
	delaythread (10.5, ::big_moment_ending_vfx_tower_middle_top_burst);
	delaythread (13.5, ::big_moment_ending_vfx_tower_top_left_burst);
	delaythread (14.15, ::big_moment_ending_vfx_tower_lower_left_burst);
	delaythread (10.25, ::big_moment_ending_vfx_tower_lower_right_burst);
	delaythread (7.2, ::big_moment_ending_vfx_tower_chunk_trailing_smk, collapse_parts);
	delaythread (6.1, ::big_moment_ending_vfx_tower_fall_camshake);
	delaythread (16.5, ::big_moment_ending_vfx_tower_base_smk_looping);
	delaythread (13.5, ::big_moment_ending_vfx_tower_smoke_up_tall);
}
	
big_moment_ending_vfx_shockwave()
{
	earthquake( .2, .2, level.player.origin, 1000 );
	exploder (7101);
}
	
big_moment_ending_vfx_ground_buckling()
{
	exploder (7102);
	earthquake( 0.9, .2, level.player.origin, 1000 );
	wait .2;
	earthquake( 0.4, .2, level.player.origin, 1000 );
	wait .2;
	earthquake( 0.15, 5.0, level.player.origin, 1000 );
}

big_moment_ending_vfx_tower_explode()
{
	//tower mid section explode
	exploder (7103);
	earthquake( 0.3, .5, level.player.origin, 1000 );
	wait .5;
	//earthquake( 0.1, 1, level.player.origin, 1000 );
}

big_moment_ending_vfx_trailing_dust( collapse_parts )
{
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_37"); 
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "street" ], "jo_street_shattered_34");
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "street" ], "jo_street_shattered_35");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_63");
	wait .05;
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_98");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_44");
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "street" ], "jo_street_shattered_59"); 
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_69");
	wait .05;
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "street" ], "jo_street_shattered_70");
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "street" ], "jo_street_shattered_43");
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "street" ], "jo_street_shattered_14");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_47");
	wait .05;
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_67");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_55");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_45");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_37");
	wait .05;
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_84");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_97");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_60");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_46");
	wait .05;
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "street" ], "jo_street_shattered_48");
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_20");
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_21");
	PlayFxOnTag((getfx("fusion_end_smk_lrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_18");
	wait .05;
	PlayFxOnTag((getfx("fusion_end_smk_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_8");
	
	wait 1;
	PlayFxOnTag((getfx("fusion_end_smk_med_emit")), collapse_parts[ "chunks" ], "jo_lower_front_panel_section_4");
	PlayFxOnTag((getfx("fusion_end_smk_med_emit")), collapse_parts[ "chunks" ], "jo_lower_front_panel_section_5");
}
	
	
big_moment_ending_vfx_tower_smoke_up()
{
	exploder (7104);
}
	
big_moment_ending_vfx_tower_smoke_up_tall()
{
	stop_exploder (7104);
	exploder (7401);
}
	
	
big_moment_ending_vfx_donut_smk()
{
	exploder (7105);
}

big_moment_ending_vfx_ground_splinter_up()
{
	exploder (7106);
	wait 0.1;
	exploder (7108);
	wait 0.15;
	exploder (7109);
	wait 0.15;
	exploder (7110);
	wait 0.15;
	exploder (7111);
	wait 0.2;
	exploder (7112);
}

big_moment_ending_vfx_falling_rock()
{
	exploder (7201);
}

big_moment_ending_vfx_ash_fall()
{
	exploder (7202);
}

big_moment_ending_vfx_rolling_smk()
{
	//start out fast
	exploder (7203);
	
	wait 2.5;
	//settle down
	stop_exploder (7203);
	//exploder (7204);
	
	wait 13.6;
	//wave 
	//stop_exploder(7204);
	exploder (7211); //thick smoke waving in and debris flying
	
	//resume fast moving smk as player stumbles again
	wait 20;
	exploder (7204);
}

big_moment_ending_vfx_thick_smk_vm()
{
	ent = spawn( "script_model", level.player.origin );
	ent SetModel( "tag_origin" );
	ent linkto( level.player );
	
	PlayFxOnTag((getfx("fusion_end_thick_smk_vm")), ent, "tag_origin");
	wait 6.0;
	StopFxOnTag((getfx("fusion_end_thick_smk_vm")), ent, "tag_origin");

	/*(wait 10.5;
	PlayFxOnTag((getfx("fusion_end_thick_smk_vm")), ent, "tag_origin");
	wait 3.0;
	StopFxOnTag((getfx("fusion_end_thick_smk_vm")), ent, "tag_origin");*/

	ent delete();
}

big_moment_ending_vfx_falling_debris()
{
	exploder (7205);
	wait 8;
	exploder (7206);
}

big_moment_ending_vfx_bouncing_rocks()
{
	exploder (7209);
}

big_moment_ending_vfx_falling_debris_tower()
{
	exploder (7207);
	wait 5;
	exploder (7208);
}

big_moment_ending_vfx_tower_pillar_left_burst()
{
	exploder (7300);
	//impact fx
	wait 3.6;
	exploder(7402);
}

big_moment_ending_vfx_tower_pillar_right_burst()
{
	exploder (7301);
}

big_moment_ending_vfx_tower_middle_top_burst()
{
	exploder (7302);
}

big_moment_ending_vfx_tower_top_left_burst()
{
	exploder (7303);
}

big_moment_ending_vfx_tower_lower_left_burst()
{
	exploder (7304);
}

big_moment_ending_vfx_tower_lower_right_burst()
{
	exploder (7305);
}

big_moment_ending_vfx_tower_base_smk_looping()
{
	//hide the base of tower with localized rolling smk
	exploder (7400);
}

big_moment_ending_vfx_tower_chunk_trailing_smk(collapse_parts)
{
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_37a");
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered2" ], "jo_concrete_shattered_piece_60c");
	
	wait 2.7;
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_43a");
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered2" ], "jo_concrete_shattered_piece_68");
	
	wait 1.0;
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_35");
	PlayFxOnTag((getfx("fusion_end_smk_xxlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_36");
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_36a");
	
	wait 2.55;
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_37");
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_38a");
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_38b");
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered2" ], "jo_concrete_shattered_piece_73a");
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered" ], "jo_concrete_shattered_piece_37c");
	
	wait .25;
	PlayFxOnTag((getfx("fusion_end_smk_xlrg_emit")), collapse_parts[ "concrete_shattered2" ], "jo_concrete_shattered_piece_72");
}

big_moment_ending_vfx_tower_fall_camshake()
{
	earthquake( 0.15, 3.2, level.player.origin, 1000 );
	wait 3.1;
	earthquake( 0.3, 4.8, level.player.origin, 1000 ); //middle chunk impact
	exploder(7403);
	wait 4.7;
	earthquake( 0.4, 3, level.player.origin, 1000 ); //right chunks impact
	exploder(7404);
	wait 2.9;
	earthquake( 0.6, 2.2, level.player.origin, 1000 ); //left chunks second impact
	exploder(7405);
}


end_arm_blood_init( guys )
{
	// Start finale arm blood fx here
	drag_frame = 1900;
	anim_start = 680;
	wait_time = ( drag_frame - anim_start ) / 30.0; // waittime in seconds
	wait( wait_time );
	//blood smear fx
	blood_origin = spawn_tag_origin();
	blood_origin linkto( guys[1], "j_clavicle_le", (16,0,0), (0,0,0));
	playfxontag(getfx("blood_smear_oriented"), blood_origin, "tag_origin");
	
	//squirting blood from dismembered arm
	pos1 = guys[3] GetTagOrigin( "shoulder_L" );// guys 2 is the chunk, 3 is the arm
	pos1 += ( 0, 1.5, 0 );
	playfx( getfx( "fusion_end_armblood_bloodsquirts" ), pos1, ( 0, 0, 1 ), (0, 1, 0 ) );
	

}


set_guy_on_fire()
{
	args = spawnstruct();
	args.v["ent"]=self;
	args.v["fx"]=getfx("fire_smoke_trail_verysmall");
	args.v["chain"]="all";
	loopTime = 0.04;
	if (level.currentgen)
		loopTime = 0.2;
	args.v["looptime"]=loopTime;
	play_fx_on_actor(args);
	//play_fx_attached_to_actor(args);
	
	level waittill("street_cleanup");
	level notify(self.model + "kill_fx_onactor");
}

walker_dying_fx()
{
	flag_set("walker_death_anim_started");
	self endon("death");
	x = 0;
	//start with small fire
	while(x < 37)
	{
		playfxontag(getfx("walker_tank_dying_fire_small"), self, "tag_fire");
		wait 0.1;
		x++;
	}
	//turn off spark fx
	stopfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS1");
	stopfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS2");
	stopfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS3");
	stopfxontag(getfx("vehicle_damaged_sparks_l"), self, "TAG_SPARKS4");
	//loop big fire until death
	while(true)
	{
		playfxontag(getfx("walker_tank_dying_fire"), self, "tag_fire");
		wait 0.1;
	}
}

walker_tank_footstep_left(guy)
{
	playfxontag(getfx("walker_footstep"), guy, "frontWheelTread01_FL");
}

walker_tank_footstep_right(guy)
{
	playfxontag(getfx("walker_footstep"), guy, "frontWheelTread01_FR");
}

walker_tank_footstep_left_rear(guy)
{
	playfxontag(getfx("walker_footstep"), guy, "frontWheelTread05_KL");
}

walker_tank_footstep_right_rear(guy)
{
	playfxontag(getfx("walker_footstep"), guy, "frontWheelTread05_KR");
}

start_smoke_pillar_black_large_fast_fx()
{
	smkPos = [(-1066.52, 29042.7, 3254.14)
		,(18709.6, 32551.6, 1771.69)
		,(13777.4, 45770.1, 2900.88)		
		,(24840.4, 25515.1, 3500.52)];
	smkAng = [(300, 24, -90)
		,(286, 26, -90)
		,(323.204, 3.74876, 84.8169)		
		,(294.312, 29.0954, -80.2449)];
	level.smokePillar1 = [];
	for(x=0; x < smkPos.size; x++)
	{
		myVectorForward = AnglesToForward(smkAng[x]);
		myVectorUp = AnglesToUp(smkAng[x]);
		level.smokePillar1[level.smokePillar1.size] = spawnfx(getfx("smoke_pillar_black_large_fast"), smkPos[x], myVectorForward, myVectorUp);
	}
	
	foreach(smk in level.smokePillar1)
	{
		triggerfx(smk, -15);
	}
}

stop_smoke_pillar_black_large_fast_fx()
{
	foreach(smk in level.smokePillar1)
	{
		smk delete();
	}
}

start_smoke_pillar_gray_large_fast_fx()
{
	smkPos = [(7442.65, 34328.6, 3101.13)];
	smkAng = [(294.312, 29.0954, -80.2449)];
	level.smokePillar2 = [];
	for(x=0; x < smkPos.size; x++)
	{
		myVectorForward = AnglesToForward(smkAng[x]);
		myVectorUp = AnglesToUp(smkAng[x]);
		level.smokePillar2[level.smokePillar2.size] = spawnfx(getfx("smoke_pillar_gray_large_fast"), smkPos[x], myVectorForward, myVectorUp);
	}
	
	foreach(smk in level.smokePillar2)
	{
		triggerfx(smk, -15);
	}
}

stop_smoke_pillar_gray_large_fast_fx()
{
	foreach(smk in level.smokePillar2)
	{
		smk delete();
	}
}

start_smoke_pillar_black_large_slow_fx()
{
	smkPos = [(5331.64, 27346.8, 2860.05)
			  ,(26342.9, 15259.3, 1438.33)];
	smkAng = [(294, 26, -90)
			  ,(294.312, 29.0954, -168.245)];
	level.smokePillar3 = [];
	for(x=0; x < smkPos.size; x++)
	{
		myVectorForward = AnglesToForward(smkAng[x]);
		myVectorUp = AnglesToUp(smkAng[x]);
		level.smokePillar3[level.smokePillar3.size] = spawnfx(getfx("smoke_pillar_black_large_slow"), smkPos[x], myVectorForward, myVectorUp);
	}
	
	foreach(smk in level.smokePillar3)
	{
		triggerfx(smk, -15);
	}
}

stop_smoke_pillar_black_large_slow_fx()
{
	foreach(smk in level.smokePillar3)
	{
		smk delete();
	}
}
