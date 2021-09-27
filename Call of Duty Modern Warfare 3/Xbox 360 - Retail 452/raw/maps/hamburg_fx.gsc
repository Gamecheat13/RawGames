#include maps\_utility;

main()
{
	if ( !GetDvarInt( "r_reflectionProbeGenerate" ) )
	{
		maps\createfx\hamburg_fx::main();
	}

	// Intro FX
	level._effect[ "osprey_trail" ] 				= LoadFX( "fire/fire_smoke_trail_L" );
	level._effect[ "osprey_explosion" ] 			= LoadFX( "explosions/helicopter_explosion_secondary_small" );
	level._effect[ "hovercraft_side_spray" ]		= LoadFX( "water/hovercraft_side_wake_hamburg" );
	level._effect[ "blackhawk_explosion" ]			= LoadFX( "explosions/heli_engine_osprey_explosion" );
	level._effect[ "osprey_splash" ] 				= LoadFX( "water/osprey_water_crash" );

	// dont mess with these
	level._effect[ "explosion_type_1" ]				= LoadFX( "explosions/bridge_explode" );
	level._effect[ "explosion_type_4" ]				= LoadFX( "explosions/building_explosion_london" );
	level._effect[ "explosion_type_9" ]				= LoadFX( "explosions/bridge_explode_hamburg_medium" );
	
	// outside of tank there's a godray
	level._effect[ "tank_god_ray" ]						= LoadFX( "lights/hamburg_garage_godray" );
	level._effect[ "tank_god_ray_light" ]				= LoadFX( "lights/hamburg_garage_godray_light" );

	//inside of the tank there's a godray
	level._effect[ "hamburg_garage_godray_small_light" ]				= LoadFX( "lights/hamburg_garage_godray_small_light" );
	level._effect[ "hamburg_garage_godray_small" ]						= LoadFX( "lights/hamburg_garage_godray_small" );
	
	level._effect[ "hamburg_tank_red_light" ]				= LoadFX( "misc/hamburg_tank_red_light" );
	level._effect[ "fire_sprinkler" ]				        = LoadFX( "water/fire_sprinkler_cheap" );
	
	level._effect[ "flares_rockety_dodge" ] = LoadFX( "misc/flares_cobra" );
	
	//.map source 
	level._effect[ "tank_blows_up_building_left" ]	= LoadFX( "explosions/bridge_explode_hamburg" );

	level._effect[ "smoke_two" ]					= LoadFX( "smoke/hamburg_cover_smoke_runner" );
	level._effect[ "beach_smoke" ]				 	= LoadFX( "smoke/hamburg_cover_smoke_runner" );

	level._effect[ "hamburg_just_bricks" ]			= LoadFX( "explosions/hamburg_brick_wall_just_bricks" );

	//map source but not being used.  I need to clean out the ents.
	level._effect[ "collapse_garage_ceiling" ]		= LoadFX( "explosions/bridge_explode_hamburg_medium" );
	
	

	//this plays on top of the dirt mount just after the beach. ( guys are stunned and we are instructed to take them out )

	// think this  mikes doing ask him. 
	level._effect[ "smoke_garage" ]					= LoadFX( "smoke/smoke_screen_small_runner" );
	level._effect[ "rpg_trail_garage" ] 			= LoadFX( "smoke/smoke_geotrail_rpg" );
	level._effect[ "rpg_muzzle" ] 					= LoadFX( "muzzleflashes/at4_flash" );
	level._effect[ "rpg_explode" ] 					= LoadFX( "explosions/rpg_wall_impact" );
		
	//tanks shoot smoke screen up the beach
	level._effect[ "rpg_trail" ]				 	= LoadFX( "smoke/smoke_geotrail_rpg" );

	//commented out in end nest ( raven stuff )
	//level._effect[ "FX_s300v_a" ]				   = LoadFX( "explosions/vehicle_explosion_sam" );
	//level._effect[ "thermal_body_gib" ]				= LoadFX( "impacts/thermal_body_gib" );	// splatter
	
	// background flak way back there.
	level._effect[ "FX_runner_air_light" ]			= LoadFX( "misc/antiair_runner_cloudy" ); // very wide
	level._effect[ "FX_runner_air_flak" ]			= LoadFX( "misc/antiair_runner_flak" ); // one gun shooting up
	
	//happens when you get knocked down into the tank I believe.
	level._effect[ "slamraam_explosion"]			= LoadFX( "explosions/vehicle_explosion_slamraam_no_missiles");


	level._effect[ "helic_engine_exhaust" ] = loadfx( "fire/heli_engine_exhaust" );
	level._effect[ "tank_blows_up_sniper" ] = LoadFX( "explosions/bridge_explode_hamburg" );
	level._effect[ "behind_bus_fire" ] 				=  LoadFX( "fire/thick_building_fire" );

	level._effect[ "tank_breach_brick_trail" ] 				=  LoadFX( "dust/tank_breach_brick_trail" );
	//level._effect[ "tank_breach_brick_trail" ] 			= LoadFX( "smoke/smoke_geotrail_rpg" );
	

	// all createfx stuff, some not being used.
	level._effect[ "room_smoke_400" ] 								= LoadFX( "smoke/room_smoke_400" );
	level._effect[ "fire_smoke_trail_l" ] 							= LoadFX( "fire/fire_smoke_trail_l" );
	level._effect[ "trash_spiral_runner" ] 							= LoadFX( "misc/trash_spiral_runner" );
	level._effect[ "thick_black_smoke_L" ] 							= LoadFX( "smoke/thick_black_smoke_L" );
	level._effect[ "thin_black_smoke_M" ] 							= LoadFX( "smoke/thin_black_smoke_M" );
	level._effect[ "thin_black_smoke_M_HELICOPTER" ] 							= LoadFX( "smoke/thin_black_smoke_M" );
	level._effect[ "fire_falling_runner_point" ] 					= LoadFX( "fire/fire_falling_runner_point" );
	level._effect[ "fire_falling_runner_point_far" ]				= LoadFX( "fire/fire_falling_runner_point_far" );
	level._effect[ "firelp_med_pm" ] 								= LoadFX( "fire/firelp_med_pm" );
	level._effect[ "firelp_med_pm_cheap" ] 							= LoadFX( "fire/firelp_med_pm_cheap" );
	level._effect[ "electrical_transformer_spark_runner_loop" ]		= LoadFX( "explosions/electrical_transformer_spark_runner_loop" );
	level._effect[ "electrical_transformer_spark_runner_lon" ]		= LoadFX( "explosions/electrical_transformer_spark_runner_lon" );
	level._effect[ "cloud_ash_lite_london" ]						= LoadFX( "weather/cloud_ash_lite_london" );
	level._effect[ "battlefield_smokebank_S_warm" ] 				= LoadFX( "smoke/battlefield_smokebank_S_warm" );
	level._effect[ "firelp_small" ] 								= LoadFX( "fire/firelp_small" );
	level._effect[ "trash_spiral01" ]								= LoadFX( "misc/trash_spiral01" );
	level._effect[ "thin_black_smoke_s_fast" ]						= LoadFX( "smoke/thin_black_smoke_s_fast" );
	level._effect[ "after_math_embers" ]							= LoadFX( "fire/after_math_embers" );
	level._effect[ "ac130_crash_sparks_hamburg" ]					= LoadFX( "fire/ac130_crash_sparks_hamburg" );
	level._effect[ "ac130_crash_ambient_spArks_hamburg" ]			= LoadFX( "fire/ac130_crash_ambient_sparks_hamburg" );
	level._effect[ "thin_black_smoke_hamburg" ]						= LoadFX( "smoke/thin_black_smoke_hamburg" );
	level._effect[ "insects_light_complex" ]						= LoadFX( "misc/insects_light_complex" );
	level._effect[ "thick_building_fire" ]							= LoadFX( "fire/thick_building_fire" );
	level._effect[ "ash_prague" ]									= LoadFX( "weather/ash_hamburg" );
	level._effect[ "embers_prague" ]								= LoadFX( "weather/embers_prague" );
	level._effect[ "ambient_ground_smoke" ]							= LoadFX( "weather/ambient_ground_smoke" );
	level._effect[ "car_explosion" ]								= LoadFX( "explosions/generic_explosion" );
	level._effect[ "car_fire_mp" ] 									= LoadFX( "fire/car_fire_mp" ); 	
	level._effect[ "insects_light_hunted" ] 						= LoadFX( "misc/insects_light_hunted" );	
	level._effect[ "floating_room_dust" ]							= LoadFX( "misc/floating_room_dust" );
	level._effect[ "firelp_cheap_mp" ] 								= LoadFX( "fire/firelp_cheap_mp" );
	
	level._effect[ "room_dust_200_z150_mp" ]						= LoadFX( "dust/room_dust_200_z150_mp" );	
	level._effect[ "burned_vehicle_sparks_hamburg" ] 				= LoadFX( "fire/burned_vehicle_sparks_hamburg" );	
	level._effect[ "room_dust_200_mp_vacant" ]						= LoadFX( "dust/room_dust_200_blend_mp_vacant" );	
	level._effect[ "spark_fall_runner_mp" ] 						= LoadFX( "explosions/spark_fall_runner_mp" );	
	level._effect[ "paper_falling_burning" ] 			  			= LoadFX( "misc/paper_falling_burning" );
	level._effect[ "building_hole_smoke_mp" ] 						= LoadFX( "smoke/building_hole_smoke_mp" );	
	level._effect[ "building_hole_embers_hamburg" ] 				= LoadFX( "fire/building_hole_embers_hamburg" );	
	level._effect[ "plane_crash_after_smoke" ] 						= LoadFX( "smoke/plane_crash_after_smoke" );		
	level._effect[ "thick_building_fire_small" ]					= LoadFX( "fire/thick_building_fire_small" );	
	level._effect[ "building_fire_hamburg" ]						= LoadFX( "fire/building_fire_hamburg" );		
	level._effect[ "building_fire_hamburg_thick_tower" ]			= LoadFX( "fire/building_fire_hamburg_thick_tower" );
	level._effect[ "drifting_gray_smk_L" ] 							= LoadFX( "smoke/drifting_gray_smk_L" );	
	level._effect[ "building_fire_hamburg_thick_tower_small" ]		= LoadFX( "fire/building_fire_hamburg_thick_tower_small" );	
	level._effect[ "smokebank_clouds_hamburg" ] 					= LoadFX( "smoke/smokebank_clouds_hamburg" );		
	level._effect[ "falling_dirt_hamburg_runner" ] 				= LoadFX( "dust/falling_dirt_hamburg_runner" );	
	level._effect[ "garage_office_exp_hamburg" ] 					= LoadFX( "explosions/garage_office_exp_hamburg" );		
	level._effect[ "building_fire_hamburg_thick_tower_med" ]		= LoadFX( "fire/building_fire_hamburg_thick_tower_med" );	
	level._effect[ "apache_barage_dust_hang_hamburg" ] 				= LoadFX( "dust/apache_barage_dust_hang_hamburg" );	
	level._effect[ "tank_crush" ]									        = LoadFX( "explosions/car_flatten_garage_hamburg" );	
	level._effect[ "garage_floor_collapse_dust_hang" ]		= LoadFX( "dust/garage_floor_collapse_dust_hang" );	
	level._effect[ "tank_wall_breach_hamburg" ] 					= LoadFX( "explosions/tank_wall_breach_hamburg" );		
	level._effect[ "garage_floor_coll_after_fall" ]				= LoadFX( "dust/garage_floor_coll_after_fall" );	
	level._effect[ "garage_floor_coll_dust_hang_floor" ]	= LoadFX( "dust/garage_floor_coll_dust_hang_floor" );	
	level._effect[ "leaves_fall_gentlewind_green" ]				= loadfx( "misc/leaves_fall_gentlewind_green" );	
	level._effect[ "debris_pile_smoke_hang_hamburg" ] 		= LoadFX( "dust/debris_pile_smoke_hang_hamburg" );
	level._effect[ "spark_fall_runner_mp" ] 		          = loadfx( "explosions/spark_fall_runner_mp" );	
	level._effect[ "ceiling_smoke_exchange" ]							= loadfx( "weather/ceiling_smoke_exchange" );
	level._effect[ "wispy_cloud_pass_ride_in_hamburg" ] 	= LoadFX( "smoke/wispy_cloud_pass_ride_in_hamburg" );		
	level._effect[ "tree_fire_hamburg" ]						      = LoadFX( "fire/tree_fire_hamburg" );
	level._effect[ "building_hole_elec_short_runner" ] 		= loadfx( "explosions/building_hole_elec_short_runner" );
	level._effect[ "wall_fire_mp" ] 		                  = loadfx( "fire/wall_fire_mp" );	
	level._effect[ "fire_ceiling" ]							          = loadfx( "fire/fire_ceiling_lg_slow" );
  level._effect[ "steam_room_fill_dark_rescue2" ]			  = loadfx( "smoke/steam_room_fill_dark_rescue2" );		  
  level._effect[ "glass_scrape_runner" ]                = loadfx("misc/glass_scrape_runner");
	level._effect[ "ash_hamburg_cheap" ]							    = LoadFX( "weather/ash_hamburg_cheap" ); 
	level._effect[ "splash_constant_hamburg" ] 		        = LoadFX( "water/splash_constant_hamburg" );	
	
	
	 
  
	// these are the tank effects, you can make it do different stuff on different types of surfaces
	level._effect[ "tank_blast_brick" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_bark" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_carpet" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_cloth" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_concrete" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_dirt" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_flesh" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_foliage" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_glass" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_grass" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_gravel" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_ice" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_metal" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_mud" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_paper" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_plaster" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_rock" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_sand" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_snow" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_water" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_wood" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_asphalt" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_ceramic" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_plastic" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_rubber" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_cushion" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_fruit" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_paintedmetal" ] 	= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_riotshield" ] 	= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_slush" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
 	level._effect[ "tank_blast_default" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
	level._effect[ "tank_blast_none" ] 			= LoadFX( "explosions/tank_shell_impact_hamburg" );
	
	// decals are seperate from the effect, so I can always point them towards the wall.
	level._effect[ "tank_blast_decal_brick" ] 			= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_bark" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_carpet" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_cloth" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_concrete" ] 		= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_dirt" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_flesh" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_foliage" ] 		= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_glass" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_grass" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_gravel" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_ice" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_metal" ] 			= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_mud" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_paper" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_plaster" ] 		= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_rock" ] 			= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_sand" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_snow" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_water" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_wood" ] 			= LoadFX( "explosions/wood_explosion_1_decal" );
 	level._effect[ "tank_blast_decal_asphalt" ] 		= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_ceramic" ] 		= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_plastic" ] 		= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_rubber" ] 			= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_cushion" ] 		= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_fruit" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_paintedmetal" ] 	= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_riotshield" ] 		= LoadFX( "explosions/tank_concrete_explosion_decal" );
 	level._effect[ "tank_blast_decal_slush" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
 	level._effect[ "tank_blast_decal_default" ] 		= LoadFX( "explosions/tank_concrete_explosion_decal" );
	level._effect[ "tank_blast_decal_none" ] 			= LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
	level._effect[ "tank_shell_impact_hamburg" ] 		= LoadFX( "explosions/tank_shell_impact_hamburg" );
	
	
	

	//for collapse through the floor section, like treadfx but this is a special script. 
	level._effect[ "tank_concrete_cracks" ] 			= LoadFX( "misc/tank_concrete_crack" );
	level._effect[ "tank_concrete_cracks_spitup" ] 		= LoadFX( "misc/tank_concrete_crackdust" );
	
	level._effect[ "tank_concrete_crack_dust" ] 		= LoadFX( "misc/hamburg_garage_crack_dust" );
	
	// mortars, think we see mostly mud/dirt/water 
	level._effect[ "mortar" ][ "bunker_ceiling" ]		= LoadFX( "dust/ceiling_dust_bunker" );
	level._effect[ "mortar" ][ "bunker_ceiling_green" ]	= LoadFX( "dust/ceiling_dust_bunker_green" );
	level._effect[ "mortar" ][ "dirt_large2" ]			= LoadFX( "impacts/beach_impact_hamburg" );
	level._effect[ "mortar" ][ "mud" ]					= LoadFX( "impacts/beach_impact_hamburg" );
	level._effect[ "mortar" ][ "water" ] 				= LoadFX( "water/big_hamburg_river_blowup" );
	level._effect[ "mortar" ][ "water_ocean" ] 			= LoadFX( "water/big_hamburg_river_blowup" );
	level._effect[ "mortar" ][ "concrete" ]				= LoadFX( "impacts/beach_impact_hamburg" );
	level._effect[ "mortar" ][ "dirt" ]					= LoadFX( "impacts/beach_impact_hamburg" ); //swap out trenches mortar effect with bigger one

	// these play when the helicopters shoot the buildings in the tank alley
	level._effect[ "strafe_building_1_wall_collapse" ] 			= LoadFX( "dust/hamburg_wall_collapse");
	level._effect[ "strafe_building_2_wall_collapse" ] 			= LoadFX( "dust/hamburg_wall_collapse");
	level._effect[ "strafe_building_1_wall_collapse_ground" ] 	= LoadFX( "dust/wall_collapse_dust_wave_hamburg");
	level._effect[ "strafe_building_2_wall_collapse_ground" ] 	= LoadFX( "dust/wall_collapse_dust_wave_hamburg");
	
	// swinging lamps in the garage shoot out this spotlight, I think mostly the cheap version.
	level._effect[ "hamburg_garage_spotlight" ] 				= LoadFX( "misc/hamburg_garage_spotlight" );
	level._effect[ "hamburg_garage_spotlight_cheap" ] 			= LoadFX( "misc/hamburg_garage_spotlight_cheap" );

	// not used.. 
	level._effect[ "wall_collapse_dust_wave_hamburg" ] 			= LoadFX( "dust/wall_collapse_dust_wave_hamburg" );
	level._effect[ "javelin_muzzle" ] 							= LoadFX( "muzzleflashes/javelin_flash_wv" );
	
	// in the beginning I lazily play this to show flak firing through the invading helicopters
	level._effect[ "flak_at_player1" ] = LoadFX( "misc/antiair_single_tracer01_cloudy");
	
	//not used
	level._effect[ "flak_at_player2" ] = LoadFX( "misc/antiair_single_tracer02_cloudy");
	level._effect[ "flak_at_player3" ] = LoadFX( "misc/antiair_single_tracer03_cloudy");
	level._effect[ "flak_at_player4" ] = LoadFX( "misc/antiair_single_tracer04_cloudy");
	
	level._effect[ "ash_hamburg_crash" ] = LoadFX( "weather/ash_hamburg_crash" );

	level._effect[ "brains" ] 				 = loadfx( "impacts/flesh_hit_body_fatal_exit_cheap" );

	//Raven stuff.. 
	level._effect[ "building_explosion_tower_hole" ]	= LoadFX( "explosions/hamburg_tower_explosion" );
	level._effect[ "building_explosion_roof_common" ]	= LoadFX( "explosions/building_explosion_metal_gulag" );
	level._effect[ "f15_missile_trail" ] 				= LoadFX( "smoke/smoke_geotrail_sidewinder_halfrestrail" );
	
	//ride in anti-air flak ( in map source )
	add_earthquake( "ride_in_quake", 0.6, 0.7, 3400 );
	level._effect[ "ride_in_near_aa_explose" ] 			= LoadFX( "explosions/aa_flak_single_hamburg");
	
	//scripted tank water splashes
	level._effect[ "tank_water_splash_loop" ]		 = LoadFX( "water/tank_splash" );
	level._effect[ "tank_water_splash_ring" ]		 = LoadFX( "water/tank_splash_ring" );
	
	//Raven stuff, not currently being used.
	level._effect[ "lights_point_white_payback" ] 	= LoadFX("lights/lights_point_white_payback");
	level._effect[ "light_glow_white_payback" ] 	= LoadFX("misc/light_glow_white_payback");
	
	// not used
	level._effect[ "heli_crash_fire" ]		 = LoadFX( "fire/heli_crash_fire" );
	
	// think these are raven fx
	level._effect[ "hijack_megafire" ]			= LoadFX( "maps/hijack/hijack_megafire" );
	level._effect[ "firelp_small_pm_a" ]		= LoadFX( "fire/firelp_small_pm_a" );
	level._effect[ "firelp_med_pm_nolight" ]	= LoadFX( "fire/firelp_med_pm_nolight" );
	
	
		//Suburban Light FX
	level._effect[ "car_headlight_truck_L" ]	= LoadFX( "misc/car_headlight_suburban_L" );
	level._effect[ "car_headlight_truck_R" ]	= LoadFX( "misc/car_headlight_suburban_R" );
	level._effect[ "car_taillight_truck_L" ]	= LoadFX( "misc/car_taillight_suburban_L" );
	level._effect[ "car_taillight_truck_R" ]	= LoadFX( "misc/car_taillight_suburban_R" );
	thread treadfx_override();
	
	// hazard lights for ambush SUV
	level._effect[ "SUV_hazard_headlight" ]		= LoadFX( "lights/lights_headlight_hazard" );
	level._effect[ "SUV_hazard_taillight" ]		= LoadFX( "lights/lights_taillight_hazard" );
	
	level._effect[ "water_pipe_spray" ]			= LoadFX("water/water_underground_pipe");
}

treadfx_override()
{
	treadfx = "treadfx/heli_dust_hamburg";
	LoadFX( treadfx );
	level waittill ( "load_finished" ); // wait till defaults are defined
	//now override!
	heli_types = [ 
					"script_vehicle_blackhawk_hero_hamburg"
				, 	"script_vehicle_osprey_fly" 
				, 	"script_vehicle_apache_mg" 
				, 	"script_vehicle_blackhawk_low" 
				, 	"script_vehicle_mi17_woodland_fly_cheap" 
				, 	"script_vehicle_mi28_flying" 
				];
	common_scripts\utility::array_levelthread( heli_types, maps\_treadfx::setallvehiclefx, treadfx );
}
