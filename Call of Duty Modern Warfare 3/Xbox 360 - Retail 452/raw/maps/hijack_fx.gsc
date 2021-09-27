#include maps\_blizzard_hijack;
#include maps\_shg_fx;
#include maps\_utility;
#include common_scripts\utility;

main()
{
	maps\createfx\hijack_fx::main();
	if ( !is_specialop() )
	{
		maps\_blizzard_hijack::blizzard_main();
	}

	level thread convertOneShot(); // for using "Z" to convert oneshot to exploders in createFX mode
	thread setup_footstep_fx();
	
	
	///////////
	// SNOW FX
	///////////
	level._effect[ "snow_blowoff_ledge" ]		 					= loadfx( "snow/snow_blowoff_ledge" );
	level._effect[ "snow_blowoff_ledge_runner" ]					= loadfx( "snow/snow_blowoff_ledge_runner" );
	level._effect[ "snow_spray_detail_oriented_runner_400x400_rvn" ]			= loadfx( "snow/snow_spray_detail_oriented_runner_400x400_rvn" );
	level._effect[ "snow_spray_detail_runner400x400" ]				= loadfx( "snow/snow_spray_detail_runner400x400" );
	level._effect[ "snow_spray_detail_runner0x400" ]	 			= loadfx( "snow/snow_spray_detail_runner0x400" );
	level._effect[ "snow_spray_detail_runner0x400_far" ]			= loadfx( "snow/snow_spray_detail_runner0x400_far" );
	level._effect[ "snow_spray_detail_runner0x200_far" ]			= loadfx( "snow/snow_spray_detail_runner0x200_far" );
	level._effect[ "snow_spray_detail_runner50x50" ]	 			= loadfx( "snow/snow_spray_detail_runner50x50" );
	level._effect[ "snow_spray_detail_rvn" ]	 					= loadfx( "snow/snow_spray_detail_rvn" );
	level._effect[ "snow_spray_detail_dark" ]	 					= loadfx( "snow/snow_spray_detail_oriented_dark" );
	level._effect[ "lighthaze_snow" ]								= loadfx( "misc/lighthaze_snow" );
	level._effect[ "lighthaze_snow_headlights" ]					= loadfx( "misc/lighthaze_snow_headlights" );
	level._effect[ "cold_breath" ]									= loadfx( "misc/cold_breath_cheap" );
	level._effect[ "Ground snow dark" ]								= loadfx( "maps/hijack/hijack_ground_snow" );
	level._effect[ "Ground snow light" ]							= loadfx( "maps/hijack/hijack_ground_snow_light" );
	
	///////////////
	// EXPLOSION FX
	///////////////	
	level._effect["generic_explosions"]								= loadfx( "explosions/generic_explosion" );
	level._effect["big_explosion"] 									= loadfx( "explosions/100ton_bomb" );
	level._effect["powerline_runner_cheap"] 						= loadfx( "explosions/powerline_runner_cheap_hijack" );
	level._effect["powerline_runner"] 								= loadfx( "explosions/powerline_runner_sound_hijack" );
	level._effect["conference_room_breach"]							= loadfx( "maps/hijack/conference_room_breach" );
	level._effect["vehicle_explosion_technical"]					= loadfx( "explosions/vehicle_explosion_technical" );
	
	///////////
	// FIRE FX
	///////////	
  	level._effect[ "hijack_crash_fire_embers" ]						= loadfx( "fire/hijack_crash_fire_embers" );
	level._effect[ "hijack_crash_fire_medium" ]						= loadfx( "fire/hijack_crash_fire_medium" );
	level._effect[ "firelp_med_pm" ]								= loadfx( "maps/hijack/hijack_firelp_med_pm" );
	level._effect[ "after_math_embers" ]							= loadfx( "fire/after_math_embers" );
	level._effect[ "banner_fire" ]									= loadfx( "maps/hijack/hijack_banner_fire" );
	level._effect[ "banner_fire_nodrip" ]							= loadfx( "fire/banner_fire_nodrip" );
 	level._effect[ "field_fire_distant2" ]							= loadfx( "fire/field_fire_distant2" );
 	level._effect[ "airplane_crash_embers"]							= loadfx( "fire/airplane_crash_embers" );
	level._effect[ "firelp_large_pm_nolight" ]						= loadfx( "fire/firelp_large_pm_nolight" );
	level._effect[ "firelp_med_pm_nolight" ]						= loadfx( "maps/hijack/hijack_firelp_med_pm_cheap_nolight" );
	level._effect[ "firelp_small_pm" ]								= loadfx( "fire/firelp_small_pm" );
	level._effect[ "firelp_small_pm_nolight" ]						= loadfx( "fire/firelp_small_pm_nolight" );
	level._effect[ "firelp_small_pm_a_nolight" ]					= loadfx( "fire/firelp_small_pm_a_nolight" );
	level._effect[ "fire_tree_embers" ]								= loadfx( "fire/fire_tree_embers" );
	level._effect[ "window_fire_large" ]							= loadfx( "fire/window_fire_large" );
	level._effect[ "fire_trail_60" ]								= loadfx( "fire/fire_trail_60" );
	level._effect[ "hijack_megafire" ]								= loadfx( "maps/hijack/hijack_megafire" );
	level._effect[ "hijack_megafire_smokeless" ]					= loadfx( "maps/hijack/hijack_megafire_smokeless" );
	level._effect[ "hijack_firelp_huge_pm_nolight" ]				= loadfx( "maps/hijack/hijack_firelp_huge_pm_nolight" );
	level._effect[ "trench_glow" ]									= loadfx( "maps/hijack/trench_glow" );
	level._effect[ "hijack_engine_trail" ]							= loadfx( "maps/hijack/hijack_engine_trail" );
	level._effect[ "hijack_engine_split" ]							= loadfx( "maps/hijack/hijack_engine_split" );

	////////////
	// SMOKE FX
	////////////	
	level._effect[ "thin_black_smoke_M_rvn"]						= loadfx( "smoke/thin_black_smoke_M_rvn" );
  	level._effect[ "airplane_crash_smoke" ]							= loadfx( "smoke/airplane_crash_smoke" );	
	level._effect[ "battlefield_smokebank_s_warm_thick_rvn" ]		= loadfx( "smoke/battlefield_smokebank_s_warm_thick_rvn" );
	level._effect[ "battlefield_smk_directional_yel_xs" ]			= loadfx( "smoke/battlefield_smk_directional_yel_xs" );	
	level._effect[ "thick_dark_smoke_giant" ]						= loadfx( "smoke/thick_dark_smoke_giant_nyharbor" );
	level._effect[ "fog_ground_200_red_rvn" ]						= loadfx( "smoke/fog_ground_200_red_rvn" );
	level._effect[ "conference_room_smoke" ]						= loadfx( "maps/hijack/conference_room_smoke" );

	////////////
	// LIGHT FX
	////////////	
 	level._effect[ "car_taillight_uaz_l" ]							= loadfx( "misc/car_taillight_uaz_l" );
	level._effect[ "power_tower_light_red_blink" ]					= loadfx( "misc/power_tower_light_red_blink" );	
	level._effect[ "power_tower_light_red_blink_large" ]			= loadfx( "misc/power_tower_light_red_blink_large" );	
	level._effect[ "light_blink_subway" ]							= loadfx( "lights/light_blink_subway" );	
	level._effect[ "window_volumetric" ]							= loadfx( "maps/hijack/window_volumetric" );
	level._effect[ "window_volumetric_long" ]						= loadfx( "maps/hijack/window_volumetric_long" );
	level._effect[ "window_volumetric_open" ]						= loadfx( "maps/hijack/window_volumetric_open" );
	level._effect[ "plane_gash_volumetric" ]						= loadfx( "maps/hijack/plane_gash_volumetric" );
	level._effect[ "plane_gash_volumetric_long" ]					= loadfx( "maps/hijack/plane_gash_volumetric_long" );
	level._effect[ "lights_hjk_int" ]								= loadfx( "maps/hijack/lights_hjk_int" );
	level._effect[ "lights_stadium" ]								= loadfx( "lights/lights_stadium" );
	level._effect[ "hijack_lights_stadium" ]						= loadfx( "maps/hijack/hijack_lights_stadium" );
	level._effect[ "debris_fxlight_flash" ]							= loadfx( "maps/hijack/debris_fxlight_flash" );
	level._effect[ "fxlight_fire_600" ]								= loadfx( "maps/hijack/fxlight_fire_600" );
	level._effect[ "hijack_potlight_volumetric" ]					= loadfx( "maps/hijack/hijack_potlight_volumetric" );
	level._effect[ "hijack_iris_volumetric" ]						= loadfx( "maps/hijack/hijack_iris_volumetric" );
	level._effect[ "hijack_flare_ambient" ]						= loadFX( "maps/hijack/hijack_flare_ambient" );	
	level._effect[ "hijack_tarmac_light" ]						= loadFX( "maps/hijack/hijack_tarmac_light" );	
	

	////////////
	// CONFERENCE FX
	////////////	
	level._effect[ "paper_flutter" ]								= loadfx( "props/paper_text_flutter" );
	level._effect[ "paper_pile_flutter" ]							= loadfx( "props/paper_text_pile_flutter" );
	
	////////////
	// ZEROG FX
	////////////	
	level._effect[ "zerog_blood" ]									= loadfx( "maps/hijack/zerog_blood" );
	level._effect[ "luggage_1_des" ]								= loadfx( "props/luggage_1_des" );
	level._effect[ "luggage_2_des" ]								= loadfx( "props/luggage_2_des" );
	level._effect[ "luggage_3_des" ]								= loadfx( "props/luggage_3_des" );
	level._effect[ "luggage_4_des" ]								= loadfx( "props/luggage_4_des" );
	
		
	////////////////	
	// CRASH FX
	////////////////
	//lights
	level._effect[ "hijack_fx_light_red_blink" ]	 			= loadfx( "lights/hijack_fxlight_red_blink" );	
	level._effect[ "hijack_fxlight_red_blink_emissive" ]	 	= loadfx( "lights/hijack_fxlight_red_blink_emissive" );	
	level._effect[ "hijack_fxlight_red_blink_flicker" ]	 		= loadfx( "lights/hijack_fxlight_red_blink_flicker" );			
	level._effect[ "hijack_fx_light_red_blink_spot" ]	 		= loadfx( "lights/hijack_fxlight_red_blink_spot" );	
	level._effect[ "hijack_fxlight_warm" ]	 					= loadfx( "lights/hijack_fxlight_warm" );	
	level._effect[ "hijack_fxlight_default" ]	 				= loadfx( "lights/hijack_fxlight_default" );	
	level._effect[ "hijack_fxlight_default_tiny" ]	 			= loadfx( "lights/hijack_fxlight_default_tiny" );
	level._effect[ "hijack_fxlight_default_med_dim" ]	 		= loadfx( "lights/hijack_fxlight_default_med_dim" );
	level._effect[ "ak47_flash_wv_hijack_crash" ]				= loadfx( "muzzleflashes/ak47_flash_wv_hijack_crash" );
	level._effect[ "beretta_flash_wv" ]							= loadfx( "muzzleflashes/beretta_flash_wv" );
	level._effect[ "flesh_hit_head_fatal_exit" ]				= loadfx( "impacts/flesh_hit_head_fatal_exit" );
	level._effect[ "flesh_hit_body_fatal_exit" ]				= loadfx( "impacts/flesh_hit_body_fatal_exit" );
	level._effect[ "commander_headshot" ]						= loadfx( "maps/hijack/commander_headshot" );	
		
	level._effect[ "crash_snow_trail" ]	 						= loadfx( "maps/hijack/hijack_tail_trail" );	
	level._effect[ "crash_cabin_decompression" ]	 			= loadfx( "dust/decompression_cabin_dust" );	
	level._effect[ "crash_falling_debris" ]	 					= loadfx( "explosions/hijack_airplane_collapse_debri_blast" );	
	level._effect[ "crash_falling_dust" ]	 					= loadfx( "dust/hijack_plane_dust" );	
	level._effect[ "crash_sled_scrape" ] 						= loadfx( "misc/hijack_scrape_airplane_world" );
	
	level._effect[ "hijack_tower_impact" ]						= loadfx( "maps/hijack/hijack_tower_impact" );
	level._effect[ "fuselage_scrape" ]							= loadfx( "maps/hijack/fuselage_scrape" );
	level._effect[ "smoke_trail_black_jet" ]					= loadfx( "smoke/smoke_trail_black_jet" );
	level._effect[ "aircraft_light_wingtip_green" ]				= loadfx( "misc/aircraft_light_wingtip_green" );
	level._effect[ "aircraft_light_wingtip_red" ]				= loadfx( "misc/aircraft_light_wingtip_red" );
	level._effect[ "aircraft_light_white_blink" ]				= loadfx( "misc/aircraft_light_white_blink" );
	level._effect[ "aircraft_light_red_blink" ]					= loadfx( "misc/aircraft_light_red_blink" );
	level._effect[ "tail_wing_impact" ]							= loadfx( "maps/hijack/tail_wing_impact" );
	level._effect[ "hijack_scrape_airplane" ]					= loadfx( "misc/hijack_scrape_airplane" );
	level._effect[ "cliff_explode_cliffhanger" ]				= loadfx( "explosions/cliff_explode_cliffhanger" );
	level._effect[ "smoke_geotrail_debris" ]					= loadfx( "maps/hijack/smoke_geotrail_debris" );
	level._effect[ "reaper_explosion" ]							= loadfx( "explosions/reaper_explosion" );
	level._effect[ "engine_explosion" ]							= loadfx( "maps/hijack/engine_explosion" );
	level._effect[ "hijack_engine_explosion" ]					= loadfx( "maps/hijack/hijack_engine_explosion" );
	level._effect[ "hijack_engine_split" ]						= loadfx( "maps/hijack/hijack_engine_split" );
	level._effect[ "fuselage_break_sparks1" ]					= loadfx( "maps/hijack/fuselage_break_sparks1" );
	level._effect[ "wing_fuel_explosion" ]						= loadfx( "maps/hijack/wing_fuel_explosion" );
	level._effect[ "cloud_tunnel" ]								= loadfx( "maps/hijack/cloud_tunnel" );
	
	level._effect[ "interior_ceiling_smoke" ]					= loadfx( "maps/hijack/interior_ceiling_smoke" );
	level._effect[ "interior_ceiling_smoke2" ]					= loadfx( "maps/hijack/interior_ceiling_smoke2" );
	level._effect[ "interior_ceiling_smoke3" ]					= loadfx( "maps/hijack/interior_ceiling_smoke3" );
	
	level._effect[ "horizon_fireglow" ]							= loadfx( "maps/hijack/horizon_fireglow" );
	level._effect[ "heli_spotlight" ] 							= LoadFX( "misc/docks_heli_spotlight_model" );
	level._effect[ "heli_spotlight_off" ] 						= LoadFX( "misc/docks_heli_spotlight_off_model" );
	level._effect[ "antenna_light_red_blink" ]					= loadFX( "maps/hijack/antenna_light_red_blink" );
	level._effect[ "tail_ambient_explosion" ]					= loadFX( "maps/hijack/tail_ambient_explosion" );
	level._effect[ "hijack_engine_sputter" ]					= loadFX( "maps/hijack/hijack_engine_sputter" );
	level._effect[ "hijack_crash_papers" ]						= loadFX( "maps/hijack/hijack_crash_papers" );
	level._effect[ "hijack_paper_explosion" ]					= loadFX( "maps/hijack/hijack_paper_explosion" );
	level._effect[ "hijack_crash_window_volumetric" ]			= loadFX( "maps/hijack/hijack_crash_window_volumetric");
	level._effect[ "hijack_crash_sparks" ]						= loadFX( "maps/hijack/hijack_crash_sparks");
	level._effect[ "hijack_sparks_int" ]						= loadFX( "maps/hijack/hijack_sparks_int");
	level._effect[ "heli_snow_hijack" ]							= loadFX( "treadfx/heli_snow_hijack");
	level._effect[ "hijack_window_glow" ]						= loadFX( "maps/hijack/hijack_window_glow");
	level._effect[ "hijack_ambient_embers" ]					= loadFX( "maps/hijack/hijack_ambient_embers");
	level._effect[ "hjk_vent_smk" ]								= loadFX( "maps/hijack/hjk_vent_smk");
	
	level._effect[ "makarov_heli_interior_light" ]				= loadFX( "lights/hijack_fxlight_makarov_heli_interior" );
	level._effect[ "hijack_tail_impact" ]						= loadFX( "maps/hijack/hijack_tail_impact" );
	level._effect[ "hijack_tail_spray" ]						= loadFX( "maps/hijack/hijack_tail_spray" );
	level._effect[ "hijack_tail_trail" ]						= loadFX( "maps/hijack/hijack_tail_trail" );
	
	
	//Suburban Light FX
	//level._effect[ "car_headlight_truck_L" ]					= loadfx( "misc/car_headlight_suburban_L" );
	//level._effect[ "car_headlight_truck_R" ]					= loadfx( "misc/car_headlight_suburban_R" );
	//level._effect[ "car_taillight_truck_L" ]					= loadfx( "misc/car_taillight_suburban_L" );
	//level._effect[ "car_taillight_truck_R" ]					= loadfx( "misc/car_taillight_suburban_R" );
	
	level._effect[ "snowcat_lights" ]							= loadfx( "misc/snowcat_lights" );
	
	// commander blood pool
	level._effect[ "commander_blood_pool" ]						= loadfx( "impacts/hjk_commander_blood_pool" );
	
	//Liquid FX
	level._effect["hijack_water_drips_short"]				= loadfx("maps/hijack/hijack_water_drips_short");
	level._effect["hijack_water_splash_short"]				= loadfx("maps/hijack/hijack_water_splash_short");
}

setup_footstep_fx()
{
	level._effect[ "footstep_snow" ]							= loadfx ( "impacts/hjk_footstep_snow" );
	level._effect[ "footstep_snow_small" ]						= loadfx ( "impacts/hjk_footstep_snow_small" );
	level._effect[ "footstep_ice" ]								= loadfx ( "impacts/hjk_footstep_ice" );
	level._effect[ "footstep_dust" ]							= loadfx ( "impacts/footstep_dust" );
	
	//Regular footstep fx
	animscripts\utility::setFootstepEffect( "snow",				level._effect[ "footstep_snow" ] );
	animscripts\utility::setFootstepEffect( "ice",				level._effect[ "footstep_ice" ] );
	animscripts\utility::setFootstepEffect( "asphalt", 			level._effect[ "footstep_dust" ] );
	animscripts\utility::setFootstepEffect( "dirt", 			level._effect[ "footstep_dust" ] );
	
	//Small footstep fx
	animscripts\utility::setFootstepEffectSmall( "snow",		level._effect[ "footstep_snow_small" ] );
	animscripts\utility::setFootstepEffectSmall( "ice",			level._effect[ "footstep_ice" ] );
	animscripts\utility::setFootstepEffectSmall( "asphalt", 	level._effect[ "footstep_dust" ] );
	animscripts\utility::setFootstepEffectSmall( "dirt", 		level._effect[ "footstep_dust" ] );
	
	//Player Footstep fx
	level.player thread PlayerSnowFootstepsHijack();
}

PlayerSnowFootstepsHijack()
{
	for ( ;; )
	{
		wait( RandomFloatRange( 0.25, .5 ) );
		start = self.origin + ( 0, 0, 0 );
		end = self.origin - ( 0, 0, 5 );
		trace = BulletTrace( start, end, false, undefined );
		forward = AnglesToForward( self.angles );
		mydistance = Distance( self GetVelocity(), ( 0, 0, 0 ) );
		if ( IsDefined( self.vehicle ) )
			continue;
		if ( trace[ "surfacetype" ] != "snow" )
			continue;
		if ( mydistance <= 10 )
			continue;
		fx = "snow_movement";
		if ( !flag("hide_player_snow_footprints") )
		{
			if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) <= 154 )
			{
				PlayFX( getfx( "footstep_snow_small" ), trace[ "position" ], trace[ "normal" ], forward );
			}
			if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) > 154 )
			{
				PlayFX( getfx( "footstep_snow" ), trace[ "position" ], trace[ "normal" ], forward );
			}
		}
	}
}