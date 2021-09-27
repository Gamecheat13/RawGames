#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_weather;

main()
{
	level._effect[ "cigar_hit_water" ]		 			    = loadfx( "maps/dubai/cigar_ash_impact" );
	level._effect[ "cigar_exhale" ]		 			        = loadfx( "smoke/cigarsmoke_exhale" );
	level._effect[ "cigar_glow_no_dlight" ]		 			= loadfx( "fire/cigar_glow_no_dlight" );
	level._effect[ "cigar_glow_far" ]		 			      = loadfx( "fire/cigar_glow_far" );
	level._effect[ "cigar_glow_puff_strong" ]		 		= loadfx( "fire/cigar_glow_puff_strong" );
	level._effect[ "cigar_smoke_puff" ]		 			    = loadfx( "smoke/cigarsmoke_puff" );
	level._effect[ "door_kick" ]			              = loadfx( "dust/door_kick_catacombs" );
	level._effect[ "falling_debris" ]				        = loadfx( "misc/generic_fallingdebris" );
	level._effect[ "flare_ambient" ]				        = loadfx( "misc/flare_ambient_prague" );
	level._effect[ "cold_breath" ]				          = loadfx( "misc/cold_breath" );
	level._effect[ "water_stop" ]						 				= LoadFX( "misc/parabolic_water_stand" );
	level._effect[ "water_movement" ]					 		  = LoadFX( "water/player_water_wake" );
	level._effect[ "water_wake_objects" ]					 	= LoadFX( "water/water_wake_objects" );
	level._effect[ "body_splash" ]					 				= LoadFX( "water/body_splash" );
	level._effect[ "blood_drip" ]					 				  = LoadFX( "impacts/blood_drip" );
	level._effect[ "dlight_red" ] 							    = LoadFX( "misc/dlight_red" );
	level._effect[ "smoke_stream" ] 						    = LoadFX( "impacts/pipe_steam" );
	level._effect[ "wall_explosion" ] 						  = LoadFX( "explosions/rpg_wall_impact" );
	level._effect[ "snow_flurry" ] 							    = LoadFX( "snow/snow_light_outdoor" );
	level._effect[ "heli_spotlight" ] 						  = LoadFX( "misc/docks_heli_spotlight_model" );
	level._effect[ "heli_spotlight_cheap" ] 				= LoadFX( "misc/docks_heli_spotlight_model_cheap" );
	level._effect[ "flashlight" ]							      = loadfx( "misc/flashlight" );
	level._effect[ "flashlight_spotlight" ]					= loadfx( "misc/flashlight_prague" );
	level._effect[ "flashlight_spotlight_cheap" ]		= loadfx( "misc/flashlight_cheap_prague" );
  level._effect[ "bodyshot1" ] 							      = loadfx( "impacts/flesh_hit" );
	level._effect[ "bodyshot2" ] 							      = loadfx( "impacts/flesh_hit_body_fatal_exit" );
	level._effect[ "headshot1" ] 							      = loadfx( "impacts/flesh_hit_head_fatal_exit" );
	level._effect[ "headshot2" ] 							      = loadfx( "impacts/flesh_hit_head_fatal_exit_exaggerated" );
	level._effect[ "flesh_hit_head_fatal_exit_exaggerated" ] = loadfx( "impacts/flesh_hit_head_fatal_exit_exaggerated" );
	level._effect[ "mist_distant_drifting" ] 		             = LoadFX( "smoke/mist_distant_drifting" );
	level._effect[ "ground_fog_london_river" ] 		    = LoadFX( "smoke/ground_fog_london_river" );
	level._effect[ "room_smoke_200" ] 		            = LoadFX( "smoke/room_smoke_200" );
	level._effect[ "room_smoke_400" ] 		            = LoadFX( "smoke/room_smoke_400" );
	level._effect[ "fire_smoke_trail_l" ] 		        = LoadFX( "fire/fire_smoke_trail_l" );
	level._effect[ "trash_spiral_runner" ] 		        = LoadFX( "misc/trash_spiral_runner" );
	level._effect[ "ceiling_dust_default" ] 		      = LoadFX( "dust/ceiling_dust_default" );
	level._effect[ "heli_dust_estate_large" ] 		    = LoadFX( "treadfx/heli_dust_estate_large" );
	level._effect[ "thick_black_smoke_L" ] 		        = LoadFX( "smoke/thick_black_smoke_L" );
	level._effect[ "thin_black_smoke_M" ] 		        = LoadFX( "smoke/thin_black_smoke_M" );
	level._effect[ "fire_falling_runner_point" ] 		  = LoadFX( "fire/fire_falling_runner_point" );
	level._effect[ "fire_falling_runner_point_far" ] 	= LoadFX( "fire/fire_falling_runner_point_far" );
	level._effect[ "firelp_med_pm" ] 		              = LoadFX( "fire/firelp_med_pm" );
	level._effect[ "firelp_med_pm_cheap" ] 		        = LoadFX( "fire/firelp_med_pm_cheap" );
	level._effect[ "glass_shatter_london" ] 		      = LoadFX( "misc/glass_shatter_london" );
	level._effect[ "steam_vent_large_wind" ] 		      = LoadFX( "smoke/steam_vent_large_wind" );
	level._effect[ "mist_drifting" ] 		              = LoadFX( "smoke/mist_drifting" );
	level._effect[ "mist_drifting_london_docks" ] 		= LoadFX( "smoke/mist_drifting_london_docks" );
	level._effect[ "mist_drifting_groundfog" ] 		    = LoadFX( "smoke/mist_drifting_groundfog" );
	level._effect[ "sparks_falling_runner_loop" ] 		= LoadFX( "explosions/sparks_falling_runner_loop" );
	level._effect[ "transformer_spark_runner_loop" ]  = LoadFX( "explosions/transformer_spark_runner_loop" );
	level._effect[ "generator_spark_runner_loop" ] 		= LoadFX( "explosions/generator_spark_runner_loop" );
	level._effect[ "electrical_transformer_spark_runner_loop" ] 	= LoadFX( "explosions/electrical_transformer_spark_runner_loop" );
	level._effect[ "electrical_transformer_spark_runner_lon" ] 		= LoadFX( "explosions/electrical_transformer_spark_runner_lon" );
	level._effect[ "cloud_ash_lite_london" ] 		            = LoadFX( "weather/cloud_ash_lite_london" );
	level._effect[ "battlefield_smokebank_S_warm" ] 		    = LoadFX( "smoke/battlefield_smokebank_S_warm" );
	level._effect[ "sewer_pipe_drip" ] 		                  = LoadFX( "water/sewer_pipe_drip" );
	level._effect[ "small_splash_constant" ] 		            = LoadFX( "water/small_splash_constant" );
	level._effect[ "room_dust_200_blend_mp_creek" ] 		    = LoadFX( "dust/room_dust_200_blend_mp_creek" );
	level._effect[ "insects_carcass_flies" ] 		            = LoadFX( "misc/insects_carcass_flies" );
	level._effect[ "lights_uplight_haze" ] 		              = LoadFX( "lights/lights_uplight_haze" );
	level._effect[ "water_drips_fat_slow_speed" ] 		      = LoadFX( "water/water_drips_fat_slow_speed" );
	level._effect[ "floating_debris" ] 		                  = LoadFX( "misc/floating_debris" );
	level._effect[ "dense_room_smoke_far" ] 		            = LoadFX( "smoke/dense_room_smoke_far" );
	level._effect[ "lighthaze" ] 		                        = LoadFX( "misc/lighthaze" );
	level._effect[ "leaves_fall_gentlewind" ] 		          = LoadFX( "misc/leaves_fall_gentlewind" );
	level._effect[ "leaves_ground_gentlewind" ] 		        = LoadFX( "misc/leaves_ground_gentlewind" );
	level._effect[ "firelp_small" ] 		                    = LoadFX( "fire/firelp_small" );
	level._effect[ "trash_spiral01" ] 		                  = LoadFX( "misc/trash_spiral01" );
	level._effect[ "ground_fog_prague" ] 		                = LoadFX( "weather/ground_fog_prague" );
	level._effect[ "statue_water_splash" ] 		              = LoadFX( "water/statue_water_splash" );
	level._effect[ "thin_black_smoke_s_fast" ] 		          = LoadFX( "smoke/thin_black_smoke_s_fast" );
	level._effect[ "after_math_embers" ] 		                = LoadFX( "fire/after_math_embers" );
	level._effect[ "molotov_fire_grow_runner" ] 		        = LoadFX( "fire/molotov_fire_grow_runner" );
	level._effect[ "molotov_impact" ] 		                  = LoadFX( "fire/molotov_impact" );
	level._effect[ "molotov_bottle_fire" ] 		              = LoadFX( "fire/molotov_bottle_fire" );
	level._effect[ "fire_flash" ] 		                      = LoadFX( "fire/fire_flash" );
	level._effect[ "light_glow_white_lamp" ] 		            = LoadFX( "misc/light_glow_white_lamp" );
	level._effect[ "prague_bridge_dust" ] 		              = LoadFX( "dust/prague_bridge_dust" );
  level._effect[ "prague_bridge_dust_runner" ] 		        = LoadFX( "dust/prague_bridge_dust_runner" );
  level._effect[ "steam_manhole" ] 		                    = LoadFX( "smoke/steam_manhole" );
  level._effect[ "prague_riot_sewer_dust" ] 		          = LoadFX( "dust/prague_riot_sewer_dust" );
  level._effect[ "spotlight_smokey_model" ] 		          = LoadFX( "misc/spotlight_smokey_model" );
  level._effect[ "insects_light_complex" ] 		            = LoadFX( "misc/insects_light_complex" );
  level._effect[ "rain_heavy" ] 		                      = LoadFX( "weather/rain_heavy_mist" );
  level._effect[ "rain_heavy_cheap" ] 		                      = LoadFX( "weather/rain_heavy" );
  level._effect[ "heli_dust_default" ] 		                = LoadFX( "treadfx/heli_dust_default" );
  level._effect[ "helicopter_explosion_mi17_woodland" ]		= loadfx( "explosions/helicopter_explosion_mi17_woodland" );
  level._effect[ "tank_impact_exaggerated_2" ]						= loadfx( "explosions/large_vehicle_explosion" );
  level._effect[ "tank_impact_exaggerated" ]						  = loadfx( "impacts/Dirt_Large_Prague_Square" );
  level._effect[ "thick_building_fire" ]								  = loadfx( "fire/thick_building_fire" );
  level._effect[ "smoke_grenade_prague" ]								  = loadfx( "smoke/smoke_grenade_prague" );
  level._effect[ "smoke_grenade" ]								        = loadfx( "smoke/smoke_grenade_prague" );
  level._effect[ "ash_prague" ]								            = loadfx( "weather/ash_prague" );
  level._effect[ "embers_prague" ]								        = loadfx( "weather/embers_prague" );
  level._effect[ "banner_fire" ]								          = loadfx( "fire/banner_fire" );
  level._effect[ "thick_building_fire_small" ]						= loadfx( "fire/thick_building_fire_small" );
  level._effect[ "candle_fire" ]						              = loadfx( "fire/candle_fire" );
  level._effect[ "generator_spark_runner_loop" ]					= loadfx( "explosions/generator_spark_runner_loop" );
  level._effect[ "btr80_explode" ]						            = loadfx( "explosions/vehicle_explosion_btr80" );
  level._effect[ "vehicle_explosion_btr80" ]			        = loadfx( "explosions/vehicle_explosion_btr80" );
  level._effect[ "btr_drop_impact" ]			                = loadfx( "impacts/btr_drop_impact" );
  level._effect[ "explosion_type_1" ]				            = loadfx( "explosions/bridge_explode_prague_cheap" );
  level._effect[ "ambient_ground_smoke" ]		            = loadfx( "weather/ambient_ground_smoke" );
  level._effect[ "vehicle_tank_crush" ]		              = loadfx( "explosions/vehicle_tank_crush" );
  level._effect[ "gallery_window_smash" ]		            = loadfx( "explosions/gallery_window_smash" );
  level._effect[ "fire_falling_runner_point" ]		      = loadfx( "fire/fire_falling_runner_point" );
  level._effect[ "embers_prague_light" ]		            = loadfx( "weather/embers_prague_light" );
  level._effect[ "m4m203_silencer_flash" ]			        = loadfx( "muzzleflashes/m4m203_silencer" );
  level._effect[ "pistol_shell_eject" ]		 	            = loadfx( "shellejects/pistol" );
  level._effect[ "electrical_transformer_sparks_a" ]		= loadfx( "explosions/electrical_transformer_sparks_a" );
  level._effect[ "stealthy_water_fog" ]		 	            = loadfx( "weather/stealthy_water_fog" );
  level._effect[ "ball_bounce_dust" ]		 	              = loadfx( "impacts/ball_bounce_dust" );
  level._effect[ "footstep_dust" ]		 	                = loadfx( "impacts/footstep_dust" );
  level._effect[ "water_pipe_spray" ]		 	                = loadfx( "water/water_pipe_spray_5_nosplash" );
	level._effect[ "water_pipe_splash" ]		 	              = loadfx( "water/water_pipe_spray_5_splashonly" );
	level._effect[ "rain_splash_subtle_64x64" ]			        = loadfx( "weather/rain_splash_subtle_64x64" );
	level._effect[ "rain_splash_subtle_128x128" ]		        = loadfx( "weather/rain_splash_subtle_128x128" );
	level._effect[ "rain_splash_lite_64x64" ]			          = loadfx( "weather/rain_splash_lite_64x64" );
	level._effect[ "rain_splash_lite_128x128" ]			        = loadfx( "weather/rain_splash_lite_128x128" );
	level._effect[ "water_drips_fat_fast_singlestream" ]		= loadfx( "water/water_drips_fat_fast_singlestream" );
	level._effect[ "water_drips_fat_fast_speed" ]			      = loadfx( "water/water_drips_fat_fast_speed" );
	level._effect[ "rain_noise_splashes" ]			            = loadfx( "weather/rain_noise_splashes" );
	level._effect[ "floating_room_dust" ]								    = loadfx( "misc/floating_room_dust" );
	level._effect[ "firelp_cheap_mp" ] 		                  = loadfx( "fire/firelp_small_cheap_mp" ); 
	level._effect[ "insects_light_hunted" ] 		            = loadfx( "misc/insects_light_hunted" );
	level._effect[ "room_dust_200_z150_mp" ]							  = loadfx( "dust/room_dust_200_z150_mp" );
	level._effect[ "car_fire_mp" ] 		                      = loadfx( "fire/car_fire_mp" );
	level._effect[ "sewer_pipe_water_flow" ]		 	          = loadfx( "water/sewer_pipe_water_flow" );
	level._effect[ "rain_splash_lite_30x30" ]			          = loadfx( "weather/rain_splash_lite_30x30" );
	level._effect[ "bootleg_alley_steam" ] 		              = loadfx( "smoke/bootleg_alley_steam" );	
  level._effect[ "church_fire_large" ]		                = loadfx( "fire/church_fire_large" );	
	level._effect[ "body_splash_prague" ]					 				  = LoadFX( "water/body_splash_prague" );
	level._effect[ "water_emerge" ]					 			          = loadfx( "water/water_emerge_prague" );
	level._effect[ "insects_light_hunted_prague_runner" ] 	= LoadFX( "misc/insects_light_hunted_prague_runner" );	
	
	
	//LIGHTING
	level._effect[ "lightning" ]				 				= loadfx( "weather/lightning" );
	level._effect[ "lightning_bolt" ]			 				= loadfx( "weather/lightning_bolt" );
	level._effect[ "lightning_bolt_lrg" ]						= loadfx( "weather/lightning_bolt_lrg" );
	addLightningExploder( 10 );// these exploders make lightning flashes in the sky
	addLightningExploder( 11 );
	addLightningExploder( 12 );
	level.nextLightning = gettime() + 1;// 10000 + randomfloat( 4000 );// sets when the first lightning of the level will go off
}


lightning_flash( dir )
{
	level notify( "emp_lighting_flash" );
	level endon( "emp_lighting_flash" );
	
	if ( level.createFX_enabled )
		return;

   	num = randomintrange( 1, 4 );
	
	if( !isdefined( dir ) )
		dir = ( -20, 60, 0 );
	
    for ( i = 0; i < num; i++ )
    {
    	type = randomint( 3 );
	    switch( type )
	    {
	    	case 0:
	    		wait( 0.05 );
						   			    
			    setSunLight( 1, 1, 1.2 );	
//			    parking_lightning( 1.2 );    
			    
			    wait( 0.05 );

			    setSunLight( 2, 2, 2.5 );
//			    parking_lightning( 2.25 );

	    		break;

	    	case 1:{
	    		wait( 0.05 );
			   
			    setSunLight( 1, 1, 1.2 );	
//			   	parking_lightning( 1.2 );	    
			     
			    wait( 0.05 );

			    setSunLight( 2, 2, 2.5 );
//			    parking_lightning( 2.25 );

			   	wait( 0.05 );

			    setSunLight( 3, 3, 3.7 );
//			    parking_lightning( 3 );

	    		}break;

	    	case 2:{
	    		wait( 0.05 );
			   
			    setSunLight( 1, 1, 1.2 );
//			    parking_lightning( 1.2 );	
			     
			    wait( 0.05 );

			    setSunLight( 2, 2, 2.5 );
//			    parking_lightning( 2.25 );

			   	wait( 0.05 );

			    setSunLight( 3, 3, 3.7 );
//			    parking_lightning( 3 );
			    
			    wait( 0.05 );

			    setSunLight( 2, 2, 2.5 );
//			    parking_lightning( 2.25 );

	    		}break;
	    }
	    
	    wait randomfloatrange( 0.05, 0.1 );
   		lightning_normal();
    }
    lightning_normal();
}

lightning_normal()
{
    resetSunLight();
    resetSunDirection();	
 //   parking_lightning_reset();
}
