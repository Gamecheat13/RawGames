main()
{
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
		maps\createfx\rescue_2_fx::main();
	
	maps\_utility::add_earthquake( "generic_earthquake", 0.35, 0.5, 5000 );	
	maps\_utility::add_earthquake( "air_earthquake", 0.3, 0.6, 99999 );
	
	generic_fx();
	maps\rescue_2_cavern_fx::main();
}

generic_fx()
{
	
	// Skybox fx
	
	level._effect[ "aa_tracer" ] 							= loadfx( "misc/antiair_runner" );
	level._effect[ "aa_flak" ] 								= loadfx( "misc/antiair_runner_flak" );
	level._effect[ "aa_cloud" ]								= loadfx( "misc/antiair_runner_cloudy" );
	
	// Ambient level fx
	level._effect[ "ceiling_dust_default" ] 		     	= loadfx( "dust/ceiling_dust_default" );
	level._effect[ "test_effect" ] 		     	            = loadfx( "dust/ceiling_dust_default" );
	level._effect[ "door_kick" ]							= loadfx( "dust/door_kick_cheap" );
	level._effect[ "falling_dirt_area_runner" ]				= loadfx( "dust/falling_dirt_area_runner" );
	level._effect[ "falling_dirt_subtle_area_runner" ]		= loadfx( "dust/falling_dirt_subtle_area_runner" );
	level._effect[ "falling_dirt_subtle_area_runner_far" ]	= loadfx( "dust/falling_dirt_subtle_area_runner_far" );
	level._effect[ "falling_dirt_subtle_area_cavern_runner" ]	= loadfx( "dust/falling_dirt_subtle_area_cavern_runner" );
	level._effect[ "falling_dirt_dark_2_runner_paris" ]		= loadfx( "dust/falling_dirt_dark_2_runner_paris" );
	level._effect[ "falling_dirt_subtle" ]					= loadfx( "dust/falling_dirt_subtle" );
	level._effect[ "falling_dirt_subtle_runner" ]			= loadfx( "dust/falling_dirt_subtle_runner" );
	
	level._effect[ "embers_small" ]							= loadfx( "fire/after_math_embers" );
	level._effect[ "fire_ceiling" ]							= loadfx( "fire/fire_ceiling_lg_slow" );
	level._effect[ "fire_ceiling_rescue2" ]					= loadfx( "fire/fire_ceiling_lg_slow_rescue2" );
	level._effect[ "fire_small" ]							= loadfx( "fire/firelp_small" );
	level._effect[ "fire_med" ]								= loadfx( "fire/firelp_med_pm" );
	level._effect[ "fire_falling_debris" ]					= loadfx( "fire/fire_fallingdebris_cheap" );
	level._effect[ "firelp_small_cheap_mp" ] 				= loadfx( "fire/firelp_small_cheap_mp" );
	level._effect[ "firelp_med_pm_cheap" ] 					= loadfx( "fire/firelp_med_pm_cheap" );
 	level._effect[ "car_fire_mp" ] 		                    = loadfx( "fire/car_fire_mp" );
	level._effect[ "falling_ash_mp" ] 		            	= loadfx( "misc/falling_ash_mp" );	
 	level._effect[ "fire_falling_runner_point_infrequent_mp" ] 	= loadfx( "fire/fire_falling_runner_point_infrequent_mp" );
	
	level._effect[ "sunflare_intro_large" ] 		     	= loadfx( "lights/sunflare_intro_large" );
	level._effect[ "lights_strobe_red_dist_max" ] 	    	= loadfx( "lights/lights_strobe_red_dist_max" );
	level._effect[ "lights_strobe_red_dist_maxb" ] 	    	= loadfx( "lights/lights_strobe_red_dist_maxb" );
	level._effect[ "light_worklight" ]						= loadfx( "lights/lights_worklight_flare" );
	level._effect[ "light_volumetric" ]						= loadfx( "lights/lights_uplight_haze_large" );
	level._effect[ "rescue_2_haxon_light" ]					= loadfx( "lights/rescue_2_haxon_light" );
	level._effect[ "lights_strobe_red_dist" ]	 			= loadfx( "lights/lights_strobe_red_dist" );
	level._effect[ "hijack_fxlight_red_blink" ]	 			= loadfx( "lights/hijack_fxlight_red_blink" );
	level._effect[ "lights_alarm_strobe" ]	 				= loadfx( "lights/lights_alarm_strobe" );
	level._effect[ "grate_light" ]	 						= loadfx( "misc/grate_light" );
	level._effect[ "grate_light_yellow" ]	 				= loadfx( "misc/grate_light_yellow" );
	level._effect[ "falling_fire_debris_rescue" ]					= loadfx( "fire/falling_fire_debris_rescue" );
	
	level._effect[ "smoke_grenade" ]						= loadfx( "smoke/smoke_grenade" );
	level._effect[ "steam_rising" ]							= loadfx( "smoke/steam_cs" );
	level._effect[ "fog_air" ]								= loadfx( "smoke/ground_fog_afchase" );
	level._effect[ "vent_steam" ]							= loadfx( "smoke/steam_manhole" );
	level._effect[ "vent_steam_yellow" ]					= loadfx( "smoke/steam_manhole_yellow" );

    level._effect[ "steam_room_100_dark_rescue2" ]			= loadfx( "smoke/steam_room_100_dark_rescue2" );
    level._effect[ "steam_room_add_large_dark_rescue2" ]	= loadfx( "smoke/steam_room_add_large_dark_rescue2" );
    level._effect[ "steam_room_add_small_dark_rescue2" ]	= loadfx( "smoke/steam_room_add_small_dark_rescue2" );
    level._effect[ "steam_room_fill_dark_rescue2" ]			= loadfx( "smoke/steam_room_fill_dark_rescue2" );
    level._effect[ "steam_room_ceiling_dark_rescue2" ]		= loadfx( "smoke/steam_room_ceiling_dark_rescue2" );
    level._effect[ "steam_room_floor_dark_rescue2" ]		= loadfx( "smoke/steam_room_floor_dark_rescue2" );
    level._effect[ "steam_room_floor_dark_rescue2_small" ]	= loadfx( "smoke/steam_room_floor_dark_rescue2_small" );
    level._effect[ "room_smoke_200" ]						= loadfx( "smoke/room_smoke_200" );
    level._effect[ "room_smoke_200_heavy" ]					= loadfx( "smoke/room_smoke_200_heavy" );
    level._effect[ "room_smoke_400" ]						= loadfx( "smoke/room_smoke_400" );
    level._effect[ "fluorescent_light_smoke" ]				= loadfx( "smoke/fluorescent_light_smoke" );
    level._effect[ "fluorescent_light_smoke_subtle" ]		= loadfx( "smoke/fluorescent_light_smoke_subtle" );
    level._effect[ "flood_light_smoke" ]					= loadfx( "smoke/flood_light_smoke" );
    level._effect[ "flood_light_smoke_large" ]				= loadfx( "smoke/flood_light_smoke_large" );
    level._effect[ "flood_light_smoke_red" ]				= loadfx( "smoke/flood_light_smoke_red" );
    level._effect[ "room_smoke_400_volume_heavy" ]			= loadfx( "smoke/room_smoke_400_volume_heavy" );
    level._effect[ "room_smoke_large_rescue2" ]				= loadfx( "smoke/room_smoke_large_rescue2" );
    level._effect[ "room_smoke_large_yellow_rescue2" ]		= loadfx( "smoke/room_smoke_large_yellow_rescue2" );
    level._effect[ "light_smoke_undergrate" ]				= loadfx( "smoke/light_smoke_undergrate" );
    level._effect[ "light_smoke_undergrate_orange" ]		= loadfx( "smoke/light_smoke_undergrate_orange" );
    level._effect[ "smoke_cavern_large" ]					= loadfx( "smoke/smoke_cavern_large" );
    
    level._effect[ "snow_light" ]					= loadfx( "snow/snow_light_rescue2_player" );
    level._effect[ "snow_light_old" ]							= loadfx( "snow/snow_light" );
    level._effect[ "snow_light_b" ]							= loadfx( "snow/snow_light_b" );
	level._effect[ "snow_flurry" ]							= loadfx( "snow/snow_climbing_up" );
	level._effect[ "snow_ground_wispy" ]					= loadfx( "snow/snow_spray_large_oriented_runner" );
	level._effect[ "snow_ground_blowing" ]					= loadfx( "snow/blowing_ground_snow" );
	level._effect[ "snow_spray_detail" ]					= loadfx( "snow/snow_spray_detail_oriented" );
	level._effect[ "snow_spray_large" ]						= loadfx( "snow/snow_spray_detail_oriented_large_runner" );
	level._effect[ "snow_dump_superhigh_runner" ]			= loadfx( "snow/snow_dump_superhigh_runner" );
	level._effect[ "cave_mouth_wall_spark_blast_rescue" ] 		= loadfx( "explosions/cave_mouth_wall_spark_blast_rescue" );
	level._effect[ "wall_exp_rpg_rescue2" ] 		= loadfx( "explosions/wall_exp_rpg_rescue2" );
	
	
	level._effect[ "water_drips_fat_fast_singlestream_mp_carbon" ] 	= loadfx( "water/water_drips_fat_fast_singlestream_mp_carbon" );
	
	level._effect[ "dust" ]								 	= loadfx( "weather/fog_cover" );
	level._effect[ "cloud_bank_a" ] 		     	        = loadfx( "weather/cloud_bank_a" );
	level._effect[ "fog_ground" ]							= loadfx( "weather/fog_daytime_rescue2" );
	level._effect[ "fog_dark" ]								= loadfx( "weather/fog_dark" );
	level._effect[ "cloud_ash_rescue2" ]					= loadfx( "weather/cloud_ash_rescue2" );
    
	level._effect[ "ceiling_smoke_exchange" ]				= loadfx( "weather/ceiling_smoke_exchange" );	
	level._effect[ "ceiling_smoke_rescue2" ]				= loadfx( "smoke/ceiling_smoke_rescue2" );	
	level._effect[ "ceiling_smoke_far" ]					= loadfx( "smoke/ceiling_smoke_far" );	
	
	// Snow Section
	level._effect[ "snow_blowoff_ledge_runner" ]			= loadfx( "snow/snow_blowoff_ledge_runner" );
	
	level._effect[ "snow_updraft_runner" ]					= loadfx( "snow/snow_updraft_runner" );

	level._effect[ "snow_clifftop_runner" ]					= loadfx( "snow/snow_clifftop_runner" );

	level._effect[ "snow_spray_detail_runner400x400" ]		= loadfx( "snow/snow_spray_detail_runner400x400" );
	level._effect[ "snow_spray_detail_runner0x400" ]	 	= loadfx( "snow/snow_spray_detail_runner0x400" );
	level._effect[ "snow_spray_detail_runner0x400_far" ]	= loadfx( "snow/snow_spray_detail_runner0x400_far" );
	level._effect[ "snow_spray_detail_runner0x200_far" ]	= loadfx( "snow/snow_spray_detail_runner0x200_far" );
	level._effect[ "snow_spray_detail_runner50x50" ]	 	= loadfx( "snow/snow_spray_detail_runner50x50" );
	
	level._effect[ "snow_spray_detail_oriented_runner" ]	= loadfx( "snow/snow_spray_detail_oriented_runner" );
	level._effect[ "snow_spray_large_oriented_runner" ]	 	= loadfx( "snow/snow_spray_large_oriented_runner" );
	
	//Lights
	level._effect[ "lighthaze_snow" ]						= loadfx( "misc/lighthaze_snow" );
	level._effect[ "lighthaze_snow_headlights" ]			= loadfx( "misc/lighthaze_snow_headlights" );
	level._effect[ "car_taillight_uaz_l" ]					= loadfx( "misc/car_taillight_uaz_l" );
	level._effect[ "lighthaze_snow_spotlight" ]				= loadfx( "misc/lighthaze_snow_spotlight" );
	level._effect[ "aircraft_light_red_blink" ]				= loadfx( "misc/aircraft_light_red_blink" );
	level._effect[ "power_tower_light_red_blink" ]			= loadfx( "misc/power_tower_light_red_blink" );
	level._effect[ "light_glow_red_snow_pulse" ]			= loadfx( "misc/light_glow_red_snow_pulse" );

	level._effect[ "heater" ]								= loadfx( "distortion/heater" );
	level._effect[ "snow_vortex_giant_pit" ]				= loadfx( "snow/snow_vortex_giant_pit" );
	level._effect[ "snow_vortex_runner" ]					= loadfx( "snow/snow_vortex_runner" );
	level._effect[ "snow_vortex_runner_cheap" ]				= loadfx( "snow/snow_vortex_runner_cheap" );
	level._effect[ "snow_light_rescue2_giant_pit" ]			= loadfx( "snow/snow_light_rescue2_giant_pit" );
	
	// Moment fx
	
	level._effect[ "dust_elevator_shaft" ] 		    		= loadfx( "dust/dust_elevator_shaft" );
	level._effect[ "dust_elevator_shake" ] 		    		= loadfx( "dust/dust_elevator_shake" );
	level._effect[ "dust_light_shaft" ] 		    		= loadfx( "dust/dust_light_shaft" );
	
	level._effect[ "wall_explosion_small_elevator" ] 		= loadfx( "explosions/wall_explosion_small_elevator" );
	level._effect[ "sparks_falling_runner_elevator" ] 		= loadfx( "explosions/sparks_falling_runner_elevator" );
	level._effect[ "sparks_falling_elevator" ] 				= loadfx( "explosions/sparks_falling_elevator" );
	level._effect[ "electrical_transformer_spark_runner_loop" ] = loadfx( "explosions/electrical_transformer_spark_runner_loop" );
	level._effect[ "electrical_transformer_spark_runner_tight" ] = loadfx( "explosions/electrical_transformer_spark_runner_tight" );
	level._effect[ "elevator_collapse_impact" ] 			= loadfx( "explosions/elevator_collapse_impact" );
	
	level._effect[ "saw_sparks_one" ] 		    			= loadfx( "misc/rescuesaw_sparks" );
	level._effect[ "saw_sparks_bounce" ] 		   			= loadfx( "misc/rescuesaw_sparks_bounce" );
	
	level._effect[ "flashlight_spotlight" ]					= loadfx( "misc/flashlight_spotlight" );
	level._effect[ "laserTarget" ] 							= loadfx( "misc/laser_glow" );
	level._effect[ "sparks_wall" ]							= loadfx( "misc/jumper_cable_sparks" );
	 
	
	// Downward Breach fx
	level._effect[ "breach_downward_falling_dirt" ] 		= loadfx( "dust/breach_downward_falling_dirt_runner" );
	level._effect[ "breach_downward_room_residual" ]		= loadfx( "explosions/breach_downward_room_residual" );
	level._effect[ "breach_downward_charge" ]				= loadfx( "explosions/breach_downward_charge" );
	level._effect[ "breach_downward_concrete_wall" ]		= loadfx( "explosions/breach_downward_concrete_wall" );
	
	// Explosion fx
	level._effect[ "snowshack_wall_explosion" ]				= loadfx( "explosions/wall_explosion_2_short" );
	level._effect[ "explosion_type_1" ]				        = loadfx( "explosions/bridge_explode" );
    level._effect[ "explosion_type_8" ]				        = loadfx( "explosions/bridge_explode_hamburg" );
	level._effect[ "bomb_explosion_ac130" ] 				= loadfx( "explosions/bomb_explosion_ac130" );
	level._effect[ "bomb_explosion_ac130_small" ] 			= loadfx( "explosions/bomb_explosion_ac130_small" );
	level._effect[ "100ton_bomb_shockwave" ] 				= loadfx( "explosions/100ton_bomb_shockwave" );
	level._effect[ "floor_breach" ]							= loadfx( "explosions/breach_wall_concrete_berlin" );
	level._effect[ "wall_explosion" ]						= loadfx( "explosions/wall_explosion_small" );
	
	level._effect[ "ball_bounce_dust" ]		 	            = loadfx( "impacts/ball_bounce_dust" );
	
	level._effect[ "a_test_fire" ]		 	              	= loadfx( "maps/hijack/wing_fuel_explosion" );
	
	
	level._effect[ "spotlight_dlight" ]		 	  			= loadfx( "misc/spotlight_dlight" );
	level._effect[ "london_train_spotlight" ]		 	    = loadfx( "misc/london_train_spotlight" );
}