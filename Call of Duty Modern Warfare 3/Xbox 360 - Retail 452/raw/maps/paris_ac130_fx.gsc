main()
{
	
	level._effect[ "ground_dust_paris_ac130" ]                  = LoadFX( "dust/ground_dust_paris_ac130" );
	
	level._effect[ "ambient_bombing" ]                          = LoadFX( "explosions/clusterbomb_ac130_paris" );
	level._effect[ "smoke_grenade" ]							= LoadFX( "smoke/smoke_screen_ac_prs_bridge_a");
	level._effect[ "eiffel_explosion" ]							= LoadFX( "impacts/ac_prs_fx_eiffel_tower_debris_a");
	level._effect[ "no_effect" ]								= LoadFX( "misc/no_effect" );
//	level._effect[ "test" ]										= LoadFX( "misc/test" );
	level._effect[ "slamzoom_clouds" ]							= LoadFX( "weather/cloud_speed_player_ac130");
	level._effect[ "ac130_105mm_IR_impact_paris" ]				= LoadFX( "impacts/ac130_105mm_color_impact_paris" );
	level._effect[ "ac130_40mm_IR_impact_paris" ]				= LoadFX( "impacts/ac130_40mm_color_impact_paris" );
//	level._effect[ "ac130_40mm_IR_impact_paris_building" ]		= LoadFX( "impacts/ac130_40mm_IR_impact_paris_building_quick" );
//	level._effect[ "ac130_40mm_IR_impact_paris_building_quick" ]	= LoadFX( "impacts/ac130_40mm_IR_impact_paris_building_quick" );
	
	// Vehicles
	
	level._effect[ "FX_mi17_explosion" ]						= LoadFX( "explosions/helicopter_explosion_mi17_woodland_ac130" );
	level._effect[ "FX_mi17_air_explosion" ]					= LoadFx( "explosions/aerial_explosion_mi17_woodland" );
	level._effect[ "FX_mi17_air_explosion_LA" ]					= LoadFX( "explosions/aerial_explosion_ac130" );
	level._effect[ "FX_apache_hydra_rocket_flash" ]				= LoadFX( "muzzleflashes/ac130_hydra_rocket_flash_wv" );
	
	level._effect[ "FX_s300v_a" ]                       		= LoadFx( "explosions/vehicle_explosion_sam" );
	level._effect[ "FX_s300v_a_missile_startup" ]       		= LoadFx( "muzzleflashes/missile_flash_wv_cheap" );
	level._effect[ "FX_s300v_a_missile_trail" ]         		= LoadFx( "smoke/ac130_smoke_geotrail_missile_large" );
	
	level._effect[ "FX_mig_missile_trail" ]         			= LoadFx( "smoke/ac130_smoke_geotrail_missile_large" );
	
	level._effect[ "FX_gaz_on_fire" ]							= LoadFx( "fire/fire_ac130_linger_med" );
	level._effect[ "FX_gaz_hurt_explosion" ]					= LoadFx( "explosions/small_vehicle_explosion_ac130" );
	level._effect[ "FX_gaz_death_explosion" ]					= LoadFX( "explosions/vehicle_explosion_technical_ac130" );
	level._effect[ "FX_gaz_dust_slide" ]						= LoadFX( "impacts/tankfall_dust_large" );
	
	level._effect[ "FX_bm21_on_fire" ]							= LoadFx( "fire/fire_ac130_linger_med" );
	level._effect[ "FX_bm21_hurt_explosion" ]					= LoadFx( "explosions/small_vehicle_explosion_ac130" );
	level._effect[ "FX_bm21_death_explosion" ]					= LoadFX( "explosions/vehicle_explosion_bm21_ac130" );
	level._effect[ "FX_bm21_dust_slide" ]						= LoadFX( "impacts/tankfall_dust_large" );
	
	level._effect[ "FX_hummer_mg_ricochet" ]					= LoadFX( "impacts/ac130_25mm_IR_impact_paris" );
	level._effect[ "FX_hummer_dust_slide" ]						= LoadFX( "impacts/tankfall_dust_large" );

	level._effect[ "FX_hind_air_explosion" ]					= LoadFX( "explosions/aerial_explosion_hind_chernobyl" );
	level._effect[ "FX_c130_paratroop_aircaft" ]				= LoadFX( "misc/c130_paratroop_aircraft" );
	level._effect[ "FX_b52_bomber_squadron_a" ]					= LoadFX( "misc/b52_bomber_squadron_a" );
	
	// Osprey
	
	level._effect[ "FX_osprey_air_explosion" ]					= LoadFX( "explosions/helicopter_explosion_osprey_air" );
	level._effect[ "FX_osprey_engine_explosion" ]				= LoadFX( "explosions/heli_engine_osprey_explosion" );
	level._effect[ "FX_osprey_engine_explosion_sm" ]			= LoadFX( "explosions/heli_engine_osprey_explosion_small" );
	level._effect[ "FX_osprey_engine_fire" ]					= LoadFX( "fire/heli_engine_fire" );
	level._effect[ "FX_osprey_engine_fire_small" ]				= LoadFX( "fire/heli_engine_fire_small" );
	level._effect[ "FX_osprey_jet_engine_fire" ]				= LoadFX( "fire/jet_engine_fire_osprey_crash" );
	level._effect[ "FX_osprey_engine_smoke" ]					= LoadFX( "smoke/heli_engine_smoke" );
	level._effect[ "FX_osprey_ground_explosion" ]				= LoadFX( "explosions/helicopter_explosion_osprey_ground" );
	level._effect[ "FX_osprey_dust" ]							= LoadFX( "treadfx/heli_dust_large" );
	level._effect[ "FX_osprey_rpg_impact" ]						= LoadFX( "misc/heli_rotor_impact_dirt" );
	level._effect[ "FX_osprey_crash_ground_engine" ]			= LoadFX( "misc/crash_heli_dirt_kickup_high" );
	level._effect[ "FX_osprey_crash_ground" ]					= LoadFX( "misc/crash_heli_dirt_kickup_high" );
	level._effect[ "FX_osprey_blade_1_hit" ]					= LoadFX( "misc/crash_heli_dirt_kickup_rotor_small" );
	level._effect[ "FX_osprey_blade_2_hit" ]					= LoadFX( "misc/crash_heli_dirt_kickup_rotor_small" );
	level._effect[ "FX_osprey_blade_3_hit" ]					= LoadFX( "misc/crash_heli_dirt_kickup_rotor_small" );
	level._effect[ "FX_osprey_side_skid" ]						= LoadFX( "misc/crash_heli_dirt_kickup_body_loop" );
	level._effect[ "FX_osprey_nose_skid" ]						= LoadFX( "misc/crash_heli_dirt_kickup_nose_loop" );
	level._effect[ "FX_osprey_engine_skid" ]					= LoadFX( "misc/crash_heli_dirt_kickup_engine_loop" );
	level._effect[ "FX_osprey_car_crash" ]						= LoadFX( "misc/crash_heli_car_dirt_kickup" );
	level._effect[ "FX_osprey_car_crash_small" ]				= LoadFX( "misc/crash_heli_car_dirt_kickup_small" );
	level._effect[ "FX_osprey_dirt_kickup_settle" ]				= LoadFX( "misc/crash_heli_dirt_kickup_settle" );
	level._effect[ "FX_osprey_dirt_kickup_settle_small" ]		= LoadFX( "misc/crash_heli_dirt_kickup_settle_small" );
	level._effect[ "crash_heli_dirt_kickup_settle_small" ]		= LoadFX( "misc/crash_heli_dirt_kickup_settle_small" );
	level._effect[ "crash_heli_dustwave" ]						= LoadFX( "misc/crash_heli_dustwave" );
	
	

	level._effect[ "FX_osprey_sparks_scrape_line_short" ]		= LoadFX( "misc/crash_heli_sparks_scrape_line_short" );

	level._effect[ "FX_angel_flare_geotrail" ]					= LoadFX( "smoke/angel_flare_geotrail_ac130" );
	level._effect[ "FX_angel_flare_explosion" ]					= LoadFX( "explosions/aa_flak_single_close_paris_ac130" );
	level._effect[ "FX_c130_contrail" ]							= LoadFX( "smoke/jet_contrail" );
	level._effect[ "FX_c130_water_crash" ]						= LoadFX( "impacts/105mm_water_impact_fast" );
	
	level._effect[ "FX_jet_afterburner_ignite" ]				= LoadFX( "fire/jet_afterburner_ignite" );
	level._effect[ "FX_jet_smoke_trail" ]						= LoadFX( "smoke/smoke_trail_black_jet" );
	level._effect[ "FX_jet_smoke_trail_quick" ]					= LoadFX( "smoke/smoke_trail_black_jet_quick" );
	level._effect[ "FX_jet_20mm_tracer" ]						= LoadFX( "misc/f15_20mm_tracer" );
	level._effect[ "FX_jet_20mm_tracer_ac130" ]					= LoadFX( "misc/f15_20mm_tracer_ac130" );
	level._effect[ "FX_jet_20mm_tracer_close_ac130" ]			= LoadFx( "misc/f15_20mm_tracer_close_ac130" );
	level._effect[ "FX_mig29_air_explosion" ]					= LoadFX( "explosions/aerial_explosion_mig29" );
	level._effect[ "FX_mig29_on_fire" ]							= LoadFX( "fire/jet_on_fire" );
	
	level._effect[ "FX_m1a1_explosion" ]						= LoadFX( "explosions/mortarexp_ac130_mud" );
	
	level._effect[ "FX_t72_explosion" ]							= LoadFX( "explosions/mortarexp_ac130_concrete" );
	level._effect[ "FX_t72_shell_hitting_building" ]			= LoadFX( "impacts/t72_125mm_building_impact" );
	level._effect[ "FX_t72_shell_hitting_road" ]				= LoadFX( "explosions/mortarexp_ac130_concrete" );
	level._effect[ "FX_t72_death_explosion" ]					= LoadFX( "explosions/vehicle_explosion_t72_ac130" );
	level._effect[ "FX_t72_death_debris" ]  					= LoadFX( "explosions/ac_prs_fx_flir_debris_explosion_a" );
	level._effect[ "FX_t72_damaged_smoke" ]  					= LoadFX( "smoke/damaged_vehicle_smoke_ac130" );
	level._effect[ "shell" ]   									= LoadFX( "shellejects/20mm_cargoship" );
	level._effect[ "huge_explosion2" ]  						= LoadFX( "explosions/fuel_storage_no_plume" );
	level._effect[ "courtyard_fire" ]  							= LoadFX( "fire/window_fire_large_short_smoke_ac130_cheap" );
	level._effect[ "courtyard_fire_cheap" ]  					= LoadFX( "fire/window_fire_large_short_smoke_ac130_cheap" );
	level._effect[ "courtyard_fire_cheap_nofire" ]  			= LoadFX( "fire/window_fire_large_short_smoke_ac130_cheap_nofire" );
	level._effect[ "turret_smoke" ]  							= LoadFX( "fire/firelp_small_cheap_mp" );
	
	level._effect[ "intro_building_explosion" ]					= LoadFX( "explosions/building_explosion_paris_ac130_intro" );
	
	
	// Destructibles

	level._effect[ "FX_barge_a_explosion" ]             		= LoadFX( "impacts/105mm_water_impact_fast" );
	level._effect[ "FX_barrels_a_1" ]                   		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_barrels_a_2" ]                   		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_cargo_crate_a_1" ]               		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_con_digger_a" ]                  		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_con_dump_truck_a" ]              		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_crates_a_1" ]                    		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_crates_a_2" ]                    		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_crates_b_1" ]                    		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_crates_b_2" ]                    		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_fuel_tank_a" ]                   		= LoadFX( "explosions/fuel_storage" );
	level._effect[ "FX_fuel_tank_a_fire_trail" ]        		= LoadFX( "explosions/large_vehicle_explosion_IR" );
	level._effect[ "FX_maz_a" ]                         		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_mi26_halo_a" ]                   		= LoadFX( "explosions/helicopter_explosion_mi26_halo" );
	level._effect[ "FX_missile_boat_a_explosion" ]      		= LoadFX( "impacts/105mm_water_impact_fast" );
	level._effect[ "FX_mobile_crane_a" ]                		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_mstas_a" ]                       		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_radar_maz_a" ]                   		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_speed_boat_a" ]                  		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_storage_bld_a_1" ]               		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_storage_bld_a_2" ]               		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_storage_bld_b" ]                 		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_tent_a" ]                        		= LoadFX( "explosions/tent_collapse" );
	level._effect[ "FX_tent_a_smoke" ]                  		= LoadFX( "explosions/tent_collapse" );
	level._effect[ "FX_tent_b" ]                        		= LoadFX( "explosions/tent_collapse" );
	level._effect[ "FX_tent_b_smoke" ]                  		= LoadFX( "explosions/tent_collapse" );
	level._effect[ "FX_tent_c" ]                        		= LoadFX( "explosions/tent_collapse" );
	level._effect[ "FX_tent_c_smoke" ]                  		= LoadFX( "explosions/tent_collapse" );
	level._effect[ "FX_truck_a" ]                       		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_truck_a_fire_trail" ]            		= LoadFX( "explosions/large_vehicle_explosion_IR" );
	level._effect[ "FX_watch_tower_a" ]                 		= LoadFX( "explosions/building_explosion_paris_ac130" );
	level._effect[ "FX_satellite_dish_explosion" ]      		= LoadFX( "explosions/ac_prs_fx_satellite_dish_explosion_a" );
	level._effect[ "FX_flir_debris_explosion_a" ]       		= LoadFX( "explosions/ac_prs_fx_flir_debris_explosion_a" );
	level._effect[ "FX_flir_debris_explosion_max_a" ]   		= LoadFX( "explosions/ac_prs_fx_flir_debris_explosion_max_a" );
	level._effect[ "FX_enm_crates_a_explosion_1" ]   			= LoadFX( "explosions/ac_prs_fx_enm_crates_a_explosion_1" );
	level._effect[ "FX_enm_crates_b_explosion_1" ]   			= LoadFX( "explosions/ac_prs_fx_enm_crates_b_explosion_1" );
	level._effect[ "FX_debris_explosion_fire_a" ]   			= LoadFX( "explosions/ac_prs_fx_debris_explosion_fire_a" );
	level._effect[ "FX_40mm_metal_impact_a" ]   				= LoadFX( "impacts/ac_prs_fx_40mm_metal_impact_a" );
	level._effect[ "FX_40mm_wood_impact_a" ]   					= LoadFX( "impacts/ac_prs_fx_40mm_wood_impact_a" );
	level._effect[ "FX_eiffel_tower_debris_a" ]   				= LoadFX( "impacts/ac_prs_fx_eiffel_tower_debris_a" );
	level._effect[ "FX_eiffel_tower_debris_b" ]   				= LoadFX( "impacts/ac_prs_fx_eiffel_tower_debris_b" );
	level._effect[ "FX_eiffel_tower_stress" ]   				= LoadFX( "impacts/ac_prs_fx_eiffel_tower_stress" );
	level._effect[ "FX_eiffel_tower_debris_loop_a" ]   			= LoadFX( "misc/eiffel_tower_debris_loop_a" );
	level._effect[ "FX_eiffel_tower_debris_loop_a_main" ]   	= LoadFX( "misc/eiffel_tower_debris_loop_a_main" );
	level._effect[ "FX_eiffel_tower_debris_loop_a_meteor" ]   	= LoadFX( "misc/eiffel_tower_debris_loop_a_meteor" );
	level._effect[ "FX_eiffel_tower_debris_loop_b" ]   			= LoadFX( "misc/eiffel_tower_debris_loop_b" );
	level._effect[ "FX_eiffel_tower_debris_loop_b_meteor" ]   	= LoadFX( "misc/eiffel_tower_debris_loop_b_meteor" );
	level._effect[ "FX_eiffel_tower_debris_burst_a" ]   		= LoadFX( "misc/eiffel_tower_debris_burst_a" );
	level._effect[ "FX_eiffel_tower_debris_burst_b" ]   		= LoadFX( "misc/eiffel_tower_debris_burst_b" );
	level._effect[ "FX_eiffel_tower_debris_fall_a_wide" ]   	= LoadFX( "misc/eiffel_tower_debris_fall_a_wide" );
	level._effect[ "FX_eiffel_tower_flash_burst_a" ]   			= LoadFX( "misc/eiffel_tower_flash_burst_a" );
	level._effect[ "FX_eiffel_tower_spark_burst_a" ]   			= LoadFX( "misc/eiffel_tower_spark_burst_a" );
	level._effect[ "FX_eiffel_tower_spark_burst_b" ]   			= LoadFX( "misc/eiffel_tower_spark_burst_b" );

	level._effect[ "FX_fire_ac130_linger_lrg_glow_short" ]   	= LoadFX( "fire/fire_ac130_linger_lrg_glow_short" );
	level._effect[ "FX_fire_ac130_simple_lrg_glow_ranged_a" ]  	= LoadFX( "fire/fire_ac130_simple_lrg_glow_ranged_a" );
	level._effect[ "FX_ac_prs_fx_dust_explosion_a" ]  			= LoadFX( "explosions/ac_prs_fx_dust_explosion_a" );
	level._effect[ "FX_ac_prs_extc_balc_a_explosion_1" ]  		= LoadFX( "explosions/ac_prs_fps_extc_balcony_a_explosion_1" );
	level._effect[ "FX_ac_prs_extc_balc_b_explosion_1" ]  		= LoadFX( "explosions/ac_prs_fps_extc_balcony_b_explosion_1" );
	level._effect[ "FX_ac_prs_extc_balc_c_explosion_1" ]  		= LoadFX( "explosions/ac_prs_fps_extc_balcony_c_explosion_1" );
	level._effect[ "FX_ac_prs_extc_balc_c_explosion_2" ]  		= LoadFX( "explosions/ac_prs_fps_extc_balcony_c_explosion_2" );
	level._effect[ "FX_firelight" ]  							= LoadFX( "lights/firelight" );
	level._effect[ "FX_lights_firelight_small" ]  				= LoadFX( "lights/lights_firelight_small" );
	level._effect[ "FX_ac_prs_smoke_amb_1" ]  					= LoadFX( "smoke/ac_prs_fx_smoke_amb_1" );
	
	
	
	
	level._effect[ "FX_grand_palais_roof" ]             		= LoadFX( "explosions/building_explosion_paris_ac130" );

	level._effect[ "FX_open_area_ambient_explosion" ]   		= LoadFX( "explosions/building_explosion_paris_ac130" );
	
	level._effect[ "FX_osprey_explosion" ]              		= LoadFX( "explosions/large_vehicle_explosion" );
	level._effect[ "FX_tank_explosion" ]                		= LoadFX( "explosions/vehicle_explosion_btr80" );
	level._effect[ "FX_bombing_run_large_explosion" ]   		= LoadFX( "explosions/bomb_explosion_large_ac130" );
	level._effect[ "FX_bombing_run_small_explosion" ]   		= LoadFX( "explosions/bomb_explosion_ac130_runner" );
	level._effect[ "FX_bombing_run_small_explosion_med" ]   	= LoadFX( "explosions/bomb_explosion_ac130" );
	level._effect[ "FX_bombing_run_small_explosion_small" ]   	= LoadFX( "explosions/bomb_explosion_ac130_small" );
	level._effect[ "FX_bombing_run_small_explosion_large" ]   	= LoadFX( "explosions/bomb_explosion_ac130_large" );
	level._effect[ "FX_bombing_run_tiny_explosion" ]   			= LoadFX( "explosions/building_explosion_paris_ac130" );

	
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_runner" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_runner" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_small" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_small" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_medium" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_medium" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_large" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_large" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_mega" ]		= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_mega" );
	
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_dist_runner" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_dist_runner" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_dist_small" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_dist_small" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_dist_medium" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_dist_medium" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_dist_large" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_dist_large" );
	level._effect[ "FX_bomb_explosion_ac130_bombing_run_dist_mega" ]	= LoadFX( "explosions/bomb_explosion_ac130_bombing_run_dist_mega" );
	
	level._effect[ "car_explosion_ac130_car1" ]		= LoadFX( "explosions/small_vehicle_explosion_ac130_car1" );
	level._effect[ "car_explosion_ac130_car2" ]		= LoadFX( "explosions/small_vehicle_explosion_ac130_car2" );
	level._effect[ "car_explosion_ac130_car3" ]		= LoadFX( "explosions/small_vehicle_explosion_ac130_car3" );
	level._effect[ "car_explosion_ac130_car4_debris" ] = LoadFX( "explosions/small_vehicle_explosion_ac130_car4_debris" );
	level._effect[ "car_explosion_ac130_car5_meteor" ] = LoadFX( "explosions/small_vehicle_explosion_ac130_car5_meteor" );
	level._effect[ "car_explosion_ac130_car6_dirtrain" ] = LoadFX( "explosions/small_vehicle_explosion_ac130_car6_dirtrain" );
	
	
	level._effect[ "FX_flak_tracers" ]		            		= LoadFX( "misc/antiair_single_tracer_flak" );
	level._effect[ "FX_flak" ]		                    		= LoadFX( "explosions/aa_flak_single_paris_ac130" );
	level._effect[ "FX_flak_large" ]		                    = LoadFX( "explosions/aa_flak_single_paris_ac130_large" );
	level._effect[ "FX_aa_fire_1" ]		                		= LoadFX( "misc/antiair_single_tracer01_day_flak_no_sfx" );
	level._effect[ "FX_aa_fire_2" ]		                		= LoadFX( "misc/antiair_single_tracer02_day_flak_no_sfx" );
	level._effect[ "FX_aa_fire_3" ]		                		= LoadFX( "misc/antiair_single_tracer03_day_flak_no_sfx" );
	level._effect[ "FX_aa_fire_short_1" ]		        		= LoadFX( "misc/antiair_single_tracer01_cloudy_short_no_sfx" );
	level._effect[ "FX_aa_fire_short_2" ]		        		= LoadFX( "misc/antiair_single_tracer02_cloudy_short_no_sfx" );
	level._effect[ "FX_aa_fire_short_3" ]		        		= LoadFX( "misc/antiair_single_tracer03_cloudy_short_no_sfx" );
	level._effect[ "FX_aa_fire_short_4" ]		        		= LoadFX( "misc/antiair_single_tracer04_cloudy_short_no_sfx" );
	level._effect[ "FX_aa_fire_tracer_1" ]		        		= LoadFX( "misc/antiair_single_tracer01_no_sfx" );
	level._effect[ "FX_aa_fire_tracer_2" ]		        		= LoadFX( "misc/antiair_single_tracer02_no_sfx" );
	level._effect[ "FX_aa_fire_tracer_3" ]		        		= LoadFX( "misc/antiair_single_tracer03_no_sfx" );
	level._effect[ "FX_aa_fire_tracer_4" ]		        		= LoadFX( "misc/antiair_single_tracer04_no_sfx" );
	level._effect[ "FX_aa_fire_flash" ]		        			= LoadFX( "explosions/aa_explosion_super_cloudonly" );
	
	level._effect[ "cloud_bank_paris_ac130" ]		    		= LoadFX( "weather/cloud_bank_paris_ac130" );
	level._effect[ "cloud_bank_paris_ac130_background" ]		= LoadFX( "weather/cloud_bank_paris_ac130_background" );
	level._effect[ "cloud_bank_paris_ac130_start" ]				= LoadFX( "weather/cloud_bank_paris_ac130_start" );
	level._effect[ "FX_cloud_bank_paris_ac130_slamzoom_out" ] 	= LoadFX( "weather/cloud_bank_paris_ac130_slamzoom_out" );
	level._effect[ "FX_cloud_single" ]							= LoadFX( "weather/cloud_single_paris_ac130" );
	
	level._effect[ "FX_rpg_building_collapsing" ]				= LoadFX( "impacts/ac130_105mm_IR_impact_paris_cheap" );
	level._effect[ "FX_hind_rocket_hitting_building" ]			= LoadFX( "impacts/ac130_105mm_IR_impact_paris_cheap" );
	
	level._effect[ "FX_smoke_signal_osprey" ]					= LoadFX( "smoke/signal_smoke_green_paris_ac130_start" );
	level._effect[ "FX_smoke_signal_osprey_blowing" ]			= LoadFX( "smoke/signal_smoke_green_paris_ac130_blowing" );
	level._effect[ "FX_smoke_signal_osprey_penetrated" ]		= LoadFX( "smoke/signal_smoke_green_paris_ac130_penetrated" );
	level._effect[ "FX_smoke_signal_osprey_sequence" ]			= LoadFX( "smoke/signal_smoke_green_paris_ac130_sequence" );
	level._effect[ "FX_smoke_signal_osprey_start" ]				= LoadFX( "smoke/signal_smoke_green_paris_ac130_start" );
	
	level._effect[ "FX_mortar_explosion_mud" ]					= LoadFX( "explosions/mortarexp_ac130_mud" );
	level._effect[ "FX_mortar_explosion_concrete" ]				= LoadFX( "explosions/mortarexp_ac130_concrete" );
	
	level._effect[ "FX_signal_ac130" ]							= LoadFX( "smoke/signal_smoke_purple_2min_ac130" );
	level._effect[ "FX_signal_evac_hot" ]						= LoadFx( "smoke/signal_smoke_red_2min_ac130" );
	
	level._effect[ "FX_horizon_flash_runner_harbor" ]			= LoadFX( "weather/horizon_flash_runner_harbor" );
	level._effect[ "FX_ambient_explosion_paris" ]				= LoadFX( "maps/paris/ambient_explosion_paris" );
	
	// Drone

	level._effect[ "FX_drone_ak47_muzzle_flash" ]				= LoadFX( "muzzleflashes/ac130_ak47_flash_wv" );
	level._effect[ "FX_drone_m16_muzzle_flash" ] 				= LoadFX( "muzzleflashes/ac130_ak47_flash_wv" );
	
	// Enemies Crawling and Dying
	
	level._effect[ "crawling_death_blood_smear" ]       		= LoadFX( "impacts/blood_smear_decal" );
	level._effect[ "blood_drip" ]					    		= LoadFX( "impacts/blood_drip" );
	
	level._effect[ "test_effect" ]								= LoadFX( "misc/moth_runner" );
    
    //hvt courtyard
	level._effect["105_impact"]	        						= loadfx ("impacts/ac130_105mm_impact_slamzoom");
    level._effect["debris_explosion"]							= loadfx ("explosions/generic_explosion_debris");
    level._effect["debris_fall_big"]							= loadfx ("misc/building_debris_falling_ny");
    level._effect["debris_fall_small"]							= loadfx ("misc/falling_debris_small");
    level._effect["wood_impact"]								= loadfx ("impacts/expround_big_default");
    level._effect["big_muzzle"]									= loadfx ("muzzleflashes/bmp_flash_wv");
    
    level._effect[ "water_stop" ]								= LoadFX( "misc/parabolic_water_stand" );
	level._effect[ "water_movement" ]							= LoadFX( "misc/parabolic_water_movement" );
	level._effect[ "sand_wall" ]								= LoadFX( "sand/sand_wall_payback" );
	
    level._effect["debris_explosion_intro"]						= loadfx ("explosions/generic_explosion_debris_paris_ac130_intro");
    
    //bridge splash for crashing jet
  	//eiffel tower collapse
  	 level._effect[ "tower_ash"]								= loadfx ("dust/building_collapse_street_dust_ash_eiffel_tower");
  	 level._effect[ "tower_cloud"]								= loadfx ("dust/building_collapse_eiffel_tower");
  	 level._effect[ "huge_explosion" ]   						= LoadFX( "explosions/100ton_bomb_eifel_tower" );
  	 level._effect[ "jet_crash" ]   							= LoadFX( "explosions/jet_crash_paris_ac130" );
  	 level._effect[ "dirt_kickup_eiffel_tower" ]   				= LoadFX( "misc/dirt_kickup_eiffel_tower" );
  	 level._effect[ "dirt_kickup_eiffel_tower_mid" ]   			= LoadFX( "misc/dirt_kickup_eiffel_tower_mid" );
  	 level._effect[ "dirt_kickup_eiffel_tower_rear" ]   		= LoadFX( "misc/dirt_kickup_eiffel_tower_rear" );
  	 level._effect[ "fence_blowout_eiffel_tower" ]   			= LoadFX( "misc/fence_blowout_eiffel_tower" );
  	 level._effect[ "gust_debris" ]   							= LoadFX( "misc/gust_debris" );
  	 level._effect[ "water_splash_large_eiffel_tower" ]   		= LoadFX( "water/water_splash_large_eiffel_tower" );
  	 level._effect[ "water_splash_large_eiffel_tower_bigger" ]  = LoadFX( "water/water_splash_large_eiffel_tower_bigger" );
  	 level._effect[ "water_splash_large_eiffel_tower_ripple" ]  = LoadFX( "water/water_splash_large_eiffel_tower_ripple" );
  	 level._effect[ "metal_eject" ]   							= LoadFX( "misc/metal_eject" );
  	 level._effect[ "metal_eject_far" ]   						= LoadFX( "misc/metal_eject_far" );
  	 level._effect[ "jet_crash_water_impact_ac130" ]   			= LoadFX( "impacts/jet_crash_water_impact_ac130" );
  	 

  	// Ambient fx
	level._effect[ "leaves_spiral_runner" ] 					= LoadFX( "misc/leaves_spiral_runner" );
	level._effect[ "room_smoke_200" ] 							= LoadFX( "smoke/room_smoke_200" );


	level._effect[ "fire_falling_runner_point" ] 				= LoadFX( "fire/fire_falling_runner_point" );
	level._effect[ "fire_falling_runner_point_nocull" ] 		= LoadFX( "fire/fire_falling_runner_point_nocull" );
	level._effect[ "fire_falling_runner_point_infrequent" ] 	= LoadFX( "fire/fire_falling_runner_point_infrequent" );
	level._effect[ "falling_dirt_frequent_runner_ac130" ] 		= LoadFX( "dust/falling_dirt_frequent_runner_ac130" );

	level._effect[ "firelp_med_pm_cheap_nolight" ] 				= LoadFX( "fire/firelp_med_pm_cheap_nolight" );
	level._effect[ "firelp_med_pm_cheap_nolight_nocull" ] 		= LoadFX( "fire/firelp_med_pm_cheap_nolight_nocull" );
	level._effect[ "firelp_small_pm_a_nolight" ] 				= LoadFX( "fire/firelp_small_pm_a_nolight" );
	
	
	level._effect[ "firelp_cheap_mp" ] 							= LoadFX( "fire/firelp_cheap_mp" );
	level._effect[ "firelp_small_cheap_mp" ] 					= LoadFX( "fire/firelp_small_cheap_mp" );
	level._effect[ "car_fire_mp" ] 								= LoadFX( "fire/car_fire_mp" );
	level._effect[ "car_fire_mp_far" ] 							= LoadFX( "fire/car_fire_mp_far" );
	level._effect[ "firelp_med_cheap_dist_mp" ] 				= LoadFX( "fire/firelp_med_cheap_dist_mp" );
	level._effect[ "firelp_small_cheap_dist_mp" ] 				= LoadFX( "fire/firelp_small_cheap_dist_mp" );
	
	level._effect[ "leaves_fall_gentlewind" ] 					= LoadFX( "misc/leaves_fall_gentlewind" );
	level._effect[ "leaves_ground_gentlewind" ] 				= LoadFX( "misc/leaves_ground_gentlewind" );
	level._effect[ "battlefield_smokebank_S_warm" ] 			= LoadFX( "smoke/battlefield_smokebank_S_warm" );
	level._effect[ "battlefield_smokebank_S_warm_thick" ] 		= LoadFX( "smoke/battlefield_smokebank_S_warm_thick" );
	level._effect[ "insect_trail_runner_icbm" ] 				= LoadFX( "misc/insect_trail_runner_icbm" );
	level._effect[ "insects_light_invasion" ] 					= LoadFX( "misc/insects_light_invasion" );
	
	
  	 
 
	LoadFX( "treadfx/tread_concrete_ac130" );
	LoadFX( "treadfx/tread_water_ac130" );
	
	footstep_fx();
	
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
		maps\createfx\paris_ac130_fx::main();
}


footstep_fx()
{
	animscripts\utility::setFootstepEffect( "default", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffect( "asphalt", 	LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "brick", 	LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "carpet", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffect( "cloth",  	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffect( "concrete", LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "cushion",  LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffect( "dirt", 	LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "foliage", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffect( "grass", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffect( "gravel", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffect( "mud", 		LoadFX( "impacts/footstep_mud" ) );
	animscripts\utility::setFootstepEffect( "rock", 	LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "sand", 	LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "water", 	LoadFX( "impacts/footstep_water" ) );
	animscripts\utility::setFootstepEffect( "wood", 	LoadFX( "impacts/footstep_dust_subtle" ) );

	animscripts\utility::setFootstepEffectSmall( "default", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffectSmall( "asphalt", 	LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "brick", 		LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "carpet", 		LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffectSmall( "cloth", 		LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffectSmall( "concrete", 	LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "cushion", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffectSmall( "dirt", 		LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "foliage", 	LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffectSmall( "grass", 		LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffectSmall( "gravel", 		LoadFX( "impacts/footstep_dust_subtle" ) );
	animscripts\utility::setFootstepEffectSmall( "mud", 		LoadFX( "impacts/footstep_mud" ) );
	animscripts\utility::setFootstepEffectSmall( "rock", 		LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "sand", 		LoadFX( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "water", 		LoadFX( "impacts/footstep_water" ) );
	animscripts\utility::setFootstepEffectSmall( "wood", 		LoadFX( "misc/dirt_kickup_feet_skid" ) );
  
	//Other notetrack fx
	/*
	setNotetrackEffect( <notetrack>, <tag>, <surface>, <loadfx>, <sound_prefix>, <sound_suffix> )
		<notetrack>: name of the notetrack to do the fx/sound on
		<tag>: name of the tag on the AI to use when playing fx
		<surface>: the fx will only play when the AI is on this surface. Specify "all" to make it work for all surfaces.
		<loadfx>: load the fx to play here
		<sound_prefix>: when this notetrack hits a sound can be played. This is the prefix of the sound alias to play ( gets followed by surface type )
		<sound_suffix>: suffix of sound alias to play, follows the surface type. Example: prefix of "bodyfall_" and suffix of "_large" will play sound alias "bodyfall_dirt_large" when the notetrack happens on dirt.
	*/
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"dirt",		loadfx ( "impacts/bodyfall_dust_small_runner" ), "bodyfall_", "_small" );
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"concrete",	loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"asphalt",	loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"rock",		loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
	
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"dirt",		loadfx ( "impacts/bodyfall_dust_large_runner" ), "bodyfall_", "_large" );
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"concrete",	loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"asphalt",	loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"rock",		loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
	
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"dirt",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"concrete",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"asphalt",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"rock",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"mud",		loadfx ( "impacts/footstep_mud" ) );
	
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"dirt",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"concrete",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"asphalt",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"rock",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"mud",		loadfx ( "impacts/footstep_mud" ) );
}

