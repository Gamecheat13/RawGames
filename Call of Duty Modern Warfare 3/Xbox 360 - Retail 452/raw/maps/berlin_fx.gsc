#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_shg_common;

main()
{
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
	
	//Global threads
	maps\createfx\berlin_fx::main();
	level thread treadfx_override();
	
	if(!isdefined(level.createFXent))
		level.createFXent = [];
	setup_shg_fx();
	
	flag_init( "trigger_vfx_expl_heli_ride" );
	flag_init("bridge_one_tank_destroyed");
	flag_init("player_unloaded_from_intro_flight");
	flag_init("sniper_complete");
	flag_init("player_interacting_with_wounded_lonestar");
	flag_init("lone_star_going_down");
	flag_init("rus_all_tanks_dead");
	flag_init("player_teleport_after_collapse_complete");
	flag_init("ambush_after_building_collapse_start");
	flag_init("entered_building_collapse");
	
	maps\_utility::add_earthquake( "generic_earthquake", .35, .75, 2000 );	

	
	
	/*********************************************************
	
	START FX LOGIC THREADS HERE
	
	**********************************************************/
	thread precacheFX();
	thread kill_all_env_fx();
	thread kill_intro_smk();
	thread kill_giant_smk_columns();
	thread kill_skybox_vfx();
	thread kill_vfx_before_building_explode();
	thread loop_skybox_hinds();
	thread loop_skybox_hinds_alleyway();
	thread kill_temp_fx_after_teleport();
	thread ambientExplosion_aabuilding();
	thread ambientExplosion_glassy_aabuilding();
	thread bridge_tanks_destroyed();
	thread water_sheeting();
	thread init_smVals();	
	//thread heli_endinterior();
	level thread convertOneShot();

	
	

	
	
	/*********************************************************
	
	EXPLODER NUMBERS & FX ZONE WATCHERS
	
	**********************************************************/
	
	/*---- notes
	exploder(100): window explosions during heli ride intro
		ent.v[ "flag" ] = "trigger_vfx_expl_heli_ride";
		ent.v[ "flag" ] = "trigger_vfx_expl_heli_ride_closeAA";
		trigger set in fx map
	exploder(200): vfx during rappel; 	--> this is currenctly turned off
		ent.v[ "flag" ] = "trigger_vfx_window_expl_rappel";
		trigger set in fx map
	exploder(300): explosions during pkwy battle
		ent.v[ "flag" ] = "trigger_vfx_expl_window_1";
		ent.v[ "flag" ] = "trigger_vfx_expl_window_2";
		ent.v[ "flag" ] = "trigger_vfx_expl_window_3";
		trigger set in fx map 
	
	----*/
		
	//1000 = intro during heli ride until reaching building at the river front
	//2000 = entire aa building coverage from heli landing rooftop all the way to the top
	//2100 = lower level of aa building including heli landing roof top
	//2200 = upper level of aa building
	//2250 = stairway up to the rooftop
	//2300 = rooftop of aa building
	//3000 = cafe courtyard
	//4000 = riverfront battle
	//5000 = entire parkway starting from the bridge
	//5100 = parkway intersection at river front
	//5200 = parkway middle
	//5300 = parkway rear toward the start point of building collapse
	//7000 = covers river front and partial parkway, use this for heavy env vfx like fog and mist

	//10000 = post building collapse: before entering
	//10100 = post building collapse: inside collapsed building part 1, entry way to traverse path
	//10200 = post building collapse: inside collapsed building part 2
	//10300 = post building collapse: inside collapsed building part 3	
	//10400 = post building collapse: inside collapsed building part 4	
	//10500 = stuff for helipad that needs to start earlier
	
	thread fx_zone_watcher(1000,"msg_vfx_zone1_intro");//intro during heli ride until reaching building at the river front
	thread fx_zone_watcher(2000,"msg_vfx_zone2_aabuilding");//entire aa building coverage from heli landing rooftop all the way to the top
	thread fx_zone_watcher(2100,"msg_vfx_zone2_aabuilding_lvl1");//lower level of aa building including heli landing roof top
	thread fx_zone_watcher(2200,"msg_vfx_zone2_aabuilding_lvl2");//upper level of aa building
	thread fx_zone_watcher(2250,"msg_vfx_zone2_aabuilding_lvl2_stair");//stariway to the rooftop
	thread fx_zone_watcher(2300,"msg_vfx_zone2_aabuilding_lvl3");//rooftop of aa building
	thread fx_zone_watcher(2400,"msg_vfx_zone2_aabuilding_ambExplosion");//triggering ambient explosion in the world
	thread fx_zone_watcher(3000,"msg_vfx_zone3_cafecourtyard","msg_vfx_zone3_cafecourtyard1");//cafe courtyard
	thread fx_zone_watcher(4000,"msg_vfx_zone4_riverfront");//riverfront battle
	thread fx_zone_watcher(5000,"msg_vfx_zone5_parkway","msg_vfx_zone5_parkway1");//entire parkway starting from the bridge
	thread fx_zone_watcher(5100,"msg_vfx_zone5_parkway_intersect");//parkway intersection at river front
	thread fx_zone_watcher(5200,"msg_vfx_zone5_parkway_middle");//parkway middle
	thread fx_zone_watcher(5300,"msg_vfx_zone5_parkway_rear");//parkway rear toward the start point of building collapse 
	thread fx_zone_watcher(7000,"msg_vfx_zone7_river_front");//covers river front and partial parkway, use this for heavy env vfx like fog and mist
	
	thread fx_zone_watcher(10000,"msg_vfx_zone10_post_collapse");//post building collapse: before entering
	thread fx_zone_watcher(10100,"msg_vfx_zone10_collapse_1","msg_vfx_zone10_collapse_1a");//post building collapse: inside collapsed building part 1
	thread fx_zone_watcher(10200,"msg_vfx_zone10_collapse_2");//post building collapse: inside collapsed building part 2
	thread fx_zone_watcher(10300,"msg_vfx_zone10_collapse_3");//post building collapse: inside collapsed building part 3
	thread fx_zone_watcher(10400,"msg_vfx_zone10_collapse_4","msg_vfx_zone10_collapse_4a");//post building collapse: inside collapsed building part 4
	thread fx_zone_watcher(10500,"msg_vfx_zone10_collapse_5","msg_vfx_zone10_collapse_5a");//post building collapse: inside collapsed building part 5
	
	thread fx_zone_watcher(11100,"msg_vfx_zone11_laststand_1","msg_vfx_zone11_laststand_1a");//last stand area: before entering stairway
	thread fx_zone_watcher(11200,"msg_vfx_zone11_laststand_2");//last stand area: stairway
	thread fx_zone_watcher(11300,"msg_vfx_zone11_laststand_3");//last stand area: upstairs hallway
	thread fx_zone_watcher(11400,"msg_vfx_zone11_laststand_4");//last stand area: helipad
	thread fx_zone_watcher(11500,"msg_vfx_zone11_laststand_3","msg_vfx_zone11_laststand_4");//stuff for helipad that needs to start earlier
}

precacheFX()
{
	level._effect[ "f15_missile" ] 								= LoadFX( "smoke/smoke_geotrail_sidewinder" );
	level._effect[ "tank_shot_impact" ]							= LoadFX( "explosions/tank_shell_impact_berlin");
	
	//Breach Fx
	//level._effect[ "breach_door" ]							= LoadFX( "explosions/breach_door5" );
	//level._effect[ "breach_room" ]					 		= LoadFX( "explosions/breach_room" );
	//level._effect[ "breach_room_residual" ]					= LoadFX( "explosions/breach_room_residual" );
	level._effect[ "door_kick" ]								= LoadFX( "dust/door_kick" );
	level._effect[ "breach_reverse_berlin" ]					= LoadFX( "explosions/breach_reverse_berlin" );	
	
	//a10
	level._effect[ "a10_muzzle_flash" ]							= LoadFX( "muzzleflashes/a10_muzzle_flash");
	level._effect[ "a10_shells" ]								= LoadFX( "shellejects/a10_shell");
	level._effect[ "a10_impact" ]								= LoadFX( "explosions/a10_explosion");
	level._effect[ "a10_impact_water" ]							= LoadFX( "water/a10_explosion_water");
	
	//a10 UI
	level._effect[ "a10_target" ] 								= loadfx( "misc/ui_flagbase_gold" );
	level._effect[ "a10_point" ] 								= loadfx( "misc/ui_a10_target" );
	level._effect[ "a10_point_active" ] 								= loadfx( "misc/ui_a10_target_active" );
	level._effect[ "a10_green_line" ] 							= loadfx( "misc/ui_a10_green_line" );
	level._effect[ "a10_green_line_active" ] 							= loadfx( "misc/ui_a10_green_line_active" );
	level._effect[ "a10_green_line_short" ] 					= loadfx( "misc/ui_a10_green_line_short" );
	level._effect[ "a10_green_line_short_active" ] 					= loadfx( "misc/ui_a10_green_line_short_active" );
	level._effect[ "a10_red_line" ] 							= loadfx( "misc/ui_a10_red_line" );
	level._effect[ "a10_red_line_short" ] 						= loadfx( "misc/ui_a10_red_line_short" );
	level._effect[ "a10_point_invalid" ] 						= loadfx( "misc/ui_a10_target_invalid" );
	level._effect[ "a10_point_invalid_active" ] 						= loadfx( "misc/ui_a10_target_invalid_active" );
	level._effect[ "a10_distance_number_0" ] 					= loadfx( "misc/ui_a10_distance_number_0" );
	level._effect[ "a10_distance_number_1" ] 					= loadfx( "misc/ui_a10_distance_number_1" );
	level._effect[ "a10_distance_number_2" ] 					= loadfx( "misc/ui_a10_distance_number_2" );
	level._effect[ "a10_distance_number_3" ] 					= loadfx( "misc/ui_a10_distance_number_3" );
	level._effect[ "a10_target_square" ] 						= loadfx( "misc/ui_a10_target_square" );
	
	
	level._effect[ "mechanical explosion" ]                     = LoadFX( "explosions/grenadeExp_blacktop");
	
	// for bloody_death
	level._effect[ "flesh_hit" ] = LoadFX( "impacts/flesh_hit_body_fatal_exit" );
	
	//littlebird crash fx	
	level._effect[ "crash_main_01" ] 							= loadfx( "explosions/javelin_explosion_dcburn" );
	level._effect[ "crash_end_01" ] 	 						= loadfx( "explosions/helicopter_explosion_little_bird_dcburn" );
	level._effect[ "chopper_smoke_trail" ]		 				= loadfx( "fire/fire_smoke_trail_L" );
		
	//artillery postbuilding collapse
	level._effect[ "artillery" ]								= LoadFX( "maps/berlin/berlin_artillery_explosion");
	//artilllery spawned behind player after teleport to block player's view when looking behind him to avoid see the empty geo
	//sound is not needed
	level._effect[ "artillery_fake" ]							= LoadFX( "maps/berlin/berlin_artillery_explosion_fake");

	
		
	//level wide env vfx
	level._effect[ "antiair_runner_cloudy_l" ]					= loadfx( "misc/antiair_runner_cloudy_l" );
	level._effect[ "antiair_runner_cloudy_short" ]				= loadfx( "misc/antiair_runner_cloudy_short" );
	level._effect[ "ground_fog_berlin" ]						= loadfx( "maps/berlin/ground_fog_berlin" );
	level._effect[ "battlefield_smokebank_s" ]					= loadfx( "smoke/battlefield_smokebank_s" );
	level._effect[ "battlefield_smk_directional_White_S" ]		= loadfx( "smoke/battlefield_smk_directional_White_S" );
	level._effect[ "battlefield_smk_directional_White_M" ]		= loadfx( "smoke/battlefield_smk_directional_White_M" );
	level._effect[ "battlefield_smk_directional_White_L" ]		= loadfx( "smoke/battlefield_smk_directional_White_L" );
	level._effect[ "smoke_large" ]								= loadfx( "smoke/smoke_large" );
	level._effect[ "thin_black_smoke_M" ]						= loadfx( "smoke/thin_black_smoke_M" );
	level._effect[ "thin_black_smoke_s_fast" ]					= loadfx( "smoke/thin_black_smoke_s_fast" );
	level._effect[ "firelp_small" ]								= loadfx( "fire/firelp_small" );
	level._effect[ "firelp_tiny" ]								= LoadFX( "fire/firelp_small_pm_a" );
	level._effect[ "firelp_med_pm_cheap" ]						= loadfx( "fire/firelp_med_pm_cheap" );
	level._effect[ "firelp_xlarge_pm" ]							= loadfx( "fire/firelp_xlarge_pm" );
	level._effect[ "fire_line_sm" ]						  		= loadfx( "fire/fire_line_sm" );
	level._effect[ "fire_line_sm_cheap" ]						= loadfx( "fire/fire_line_sm_cheap" );
	level._effect[ "firelp_small_streak_pm_h" ]					= loadfx( "fire/firelp_small_streak_pm_h" );
	level._effect[ "firelp_small_streak_pm_v_nolight" ]			= loadfx( "fire/firelp_small_streak_pm_v_nolight" );
	level._effect[ "fire_med_pm_nolight_atlas" ]				= loadfx( "fire/fire_med_pm_nolight_atlas" );
	level._effect[ "firelp_med_pm_far" ]						= loadfx( "fire/firelp_med_pm_far" );
	level._effect[ "fire_embers_directional_slow" ]				= loadfx( "fire/fire_embers_directional_slow" );
	level._effect[ "fireball_smk_S" ]						  	= loadfx( "fire/fireball_lp_smk_S" );
	level._effect[ "fireball_smk_M" ]						  	= loadfx( "fire/fireball_lp_smk_M" );
	level._effect[ "fireball_smk_M_grounded" ]					= loadfx( "fire/fireball_lp_smk_M_grounded" );
	level._effect[ "fireball_smk_M_grounded_lightLOD" ]			= loadfx( "fire/fireball_lp_smk_M_grounded_lightLOD" );
	level._effect[ "fireball_smk_L" ]						  	= loadfx( "fire/fireball_lp_smk_L" );
	level._effect[ "fire_ceiling_md_slow" ]						= LoadFX( "fire/fire_ceiling_md_slow" );
	level._effect[ "embers_trees" ]						  		= loadfx( "fire/embers_trees" );
	level._effect[ "fire_falling_runner_point_infrequent" ]		= loadfx( "fire/fire_falling_runner_point_infrequent" );
	level._effect[ "smk_column_giant_berlin" ]					= loadfx( "maps/berlin/smk_column_giant_berlin" );
	level._effect[ "smk_column_giant_berlin_stop" ]				= loadfx( "maps/berlin/smk_column_giant_berlin" );
	level._effect[ "skybox_hind_flyby_loop" ]					= loadfx( "misc/skybox_hind_flyby" );
	level._effect[ "skybox_hind_flyby" ]						= loadfx( "misc/skybox_hind_flyby" );
	level._effect[ "lights_godray_beam" ]						= loadfx( "lights/lights_godray_beam_bright" );
	level._effect[ "lights_godray_beam_l" ]						= loadfx( "lights/lights_godray_beam_l" );
	level._effect[ "lights_uplight_haze" ]						= loadfx( "lights/lights_uplight_haze" );
	level._effect[ "lights_conelight_smokey" ]					= loadfx( "lights/lights_conelight_smokey" );
	level._effect[ "lights_headlight_harbor" ]					= loadfx( "lights/lights_headlight_harbor" );
	level._effect["smoke_wall_m_warm_berlin"]					= loadfx ("maps/berlin/smoke_wall_m_warm_berlin");
	level._effect["smk_shadow_m_berlin"]						= loadfx ("maps/berlin/smk_shadow_m_berlin");
	level._effect["fire_generic_atlas"]							= loadfx ("fire/fire_generic_atlas");
	level._effect["fire_generic_atlas_small"]					= loadfx ("fire/fire_generic_atlas_small");
	level._effect["fire_generic_atlas_nolight"]					= loadfx ("fire/fire_generic_atlas_nolight");
	level._effect["bridge_water_splash"]						= loadfx ("maps/berlin/bridge_water_splash");
	level._effect["bridge_water_splash2"]						= loadfx ("maps/berlin/bridge_water_splash2");
	level._effect[ "amb_dust_small" ]							= loadfx( "smoke/amb_dust_small" );	
	level._effect[ "ship_edge_foam_oriented" ]					= loadfx( "water/ship_edge_foam_oriented" );	

	
	level._effect["chinook_red_light"]					= loadfx ("misc/berlin_heli_red_blink");
	
	
	//random explosion through out the level
	level._effect[ "window_explosion" ]						  	= loadfx( "explosions/window_explosion_cheap" );
	level._effect[ "window_explosion_glassy" ]					= loadfx( "explosions/window_explosion_glassy" );
	level._effect[ "window_explosion_glassy_med" ]				= loadfx( "explosions/window_explosion_glassy_med" );
	level._effect[ "small_vehicle_explosion_nofire" ]			= loadfx( "explosions/small_vehicle_explosion_nofire" );
	level._effect[ "generic_explosion" ]						= loadfx( "explosions/generic_explosion" );
		
	//steam from rooftop AC vents
	level._effect[ "steam_solar_panels" ]		 				= loadfx( "smoke/steam_solar_panels" );
	level._effect[ "steam_manhole" ]							= loadfx( "smoke/steam_manhole" );
	level._effect[ "steam_large_vent_rooftop" ]					= loadfx( "smoke/steam_large_vent_rooftop" );
	
	//random env vfx on street of aa building
	level._effect[ "paper_falling" ]							= loadfx( "misc/paper_falling" );
	level._effect[ "paper_blowing_trash" ]						= loadfx( "misc/paper_blowing_trash" );
	level._effect[ "dust_wind_slow_paper" ]						= loadfx( "dust/dust_wind_slow_paper" );
	level._effect[ "dust_wind_fast_paper" ]						= loadfx( "dust/dust_wind_fast_paper" );
	level._effect[ "powerline_runner" ]							= loadfx( "explosions/powerline_runner" );
	level._effect[ "trash_spiral_runner" ]						= loadfx( "misc/trash_spiral_runner_cheap" );
	level._effect[ "trash_spiral_runner_far" ]					= loadfx( "misc/trash_spiral_runner_far" );
	level._effect[ "cloud_ash_lite" ]						    = loadfx( "weather/cloud_ash_lite" );
	level._effect[ "smoke_geotrail_genericexplosion" ]			= loadfx( "smoke/smoke_geotrail_genericexplosion_d" );

	//env vfx inside aa building 
	level._effect[ "water_pipe_spray" ]							= loadfx( "water/water_pipe_spray" );
	level._effect[ "water_drips_fat_fast_speed" ]			 	= loadfx( "water/water_drips_fat_fast_speed" );
	level._effect[ "drips_fast" ]			 					= loadfx( "misc/drips_fast" );
	level._effect[ "drips_slow" ]			 					= loadfx( "misc/drips_slow" );
	level._effect[ "falling_dirt_light_1_runner" ]				= loadfx( "dust/falling_dirt_light_1_runner" );
	level._effect[ "smoke_white_room_linger" ]					= loadfx( "smoke/smoke_white_room_linger" );
	level._effect[ "powerline_runner_berlin" ]					= loadfx( "explosions/powerline_runner_berlin" );

	//env vfx outside aa building 
	level._effect[ "power_tower_light_red_blink" ]				= loadfx( "misc/power_tower_light_red_blink" );
	
	//sniper sequence fx
	//level._effect[ "ceiling_falling_tile" ] 	= LoadFX( "dust/ceiling_falling_tile" );  this is called below
	level._effect[ "room_explode" ]								= LoadFX( "explosions/tankshell_wallImpact");
	level._effect[ "tank_shell_impact" ]						= LoadFX( "explosions/tank_shell_impact_berlin");
	level._effect[ "smoke_sniper_building_top" ]				= LoadFX( "maps/berlin/smoke_sniper_building_top");
	level._effect[ "smoke_sniper_building_bottom" ]				= LoadFX( "maps/berlin/smoke_sniper_building_bottom");
		
	//smoke to block street end with skybox
	level._effect[ "skybox_smoke_berlin" ]						= loadfx( "maps/berlin/skybox_smoke_berlin" );
	level._effect[ "skybox_mist_berlin" ]						= loadfx( "maps/berlin/skybox_mist_berlin" );
	level._effect[ "skybox_smoke_wide_berlin" ]					= loadfx( "maps/berlin/skybox_smoke_wide_berlin" );
	
	
	//advance pkwy fx
	level._effect[ "t90_flash_berlin_closeup" ]					= loadfx( "muzzleflashes/t90_flash_berlin_closeup" );
	level._effect[ "tank_dirt" ]								= loadfx( "maps/berlin/tank_dirt" );
	level._effect[ "tank_dirt1" ]								= loadfx( "maps/berlin/tank_dirt1" );
	level._effect[ "tank_destroy_cover" ]						= LoadFX( "explosions/tank_shell_impact_cover");
	
	//all vfx for collapsing building sequence
	level._effect[ "building_mega_explosion" ]					= loadfx( "maps/berlin/building_explosion_ground_megasmk_berlin" );
	level._effect[ "building_explosion_smk_column" ]			= loadfx( "maps/berlin/building_explosion_smk_column_berlin" );
	level._effect[ "building_explosion_smk_forward" ]			= loadfx( "maps/berlin/building_explosion_smk_forward_berlin" );
	level._effect[ "building_explosion_init_shock" ]			= loadfx( "maps/berlin/building_explosion_init_shk_berlin" );
	level._effect[ "building_collapse_glass_explosion1" ]		= loadfx( "maps/berlin/building_explosion_glass1_berlin" );
	level._effect[ "building_collapse_glass_explosion2" ]		= loadfx( "maps/berlin/building_explosion_glass2_berlin" );
	level._effect[ "building_collapse_rolling_smk" ]		 	= loadfx( "maps/berlin/building_collapse_rolling_smk_berlin" );
	level._effect[ "building_collapse_glassfall_berlin" ]		= loadfx( "maps/berlin/building_collapse_glassfall_berlin" );	
	level._effect[ "building_explosion_collide" ]				= loadfx( "maps/berlin/building_explosion_collide_berlin" );
	level._effect[ "building_collide_smk_shadow_berlin" ]		= loadfx( "maps/berlin/building_collide_smk_shadow_berlin" );
	level._effect[ "building_falling_explosion_berlin" ]		= loadfx( "maps/berlin/building_falling_explosion_berlin" );
	level._effect[ "fire_smoke_trail_emitter" ]					= loadfx( "fire/fire_smoke_white_trail_l_emitter_light" );
	level._effect[ "building_falling_debris_down_berlin" ]		= loadfx( "maps/berlin/building_falling_debris_down_berlin" );
	level._effect[ "building_falling_debris_down_berlin_tiny" ]	= loadfx( "maps/berlin/building_falling_debris_down_berlin_tiny" );
	level._effect[ "window_explosion_glassy_med_smk_up" ]		= loadfx( "explosions/window_explosion_glassy_med_smk_up" );
	level._effect[ "sparks_subway_truck_collision" ]			= loadfx( "misc/sparks_subway_truck_collision" );
	level._effect[ "vehicle_explosion_flash" ]					= loadfx( "explosions/vehicle_explosion_flash" );		
	level._effect[ "smoke_trail_grey_giant_short_emitter" ]		= loadfx( "smoke/smoke_trail_grey_giant_short_emitter" );		
	level._effect[ "building_explosion_paperfall_berlin" ]		= loadfx( "maps/berlin/building_explosion_paperfall_berlin" );
	level._effect[ "window_explosion_glassy_less_fiery" ]		= loadfx( "explosions/window_explosion_glassy_less_fiery" );
	level._effect[ "building_collide_ceiling_fall" ]			= loadfx( "maps/berlin/building_collide_ceiling_fall" );	
	
	//dust falling of player hand
	level._effect[ "berlin_dustfall_player_hand" ]				= loadfx( "maps/berlin/berlin_dustfall_player_hand" );	
	
	//lingering smoke and ash after teleport
	level._effect[ "building_aftermath_street_ash" ]		 	= loadfx( "dust/building_collapse_street_dust_ash" );	
	level._effect[ "smk_giant_block_postcollapse_berlin" ]		= loadfx( "maps/berlin/smk_giant_block_postcollapse_berlin" );	
	level._effect[ "smk_giant_thin_postcollapse_berlin" ]		= loadfx( "maps/berlin/smk_giant_thin_postcollapse_berlin" );	
	level._effect[ "berlin_postcollapse_ground_dust" ]			= loadfx( "maps/berlin/berlin_postcollapse_ground_dust" );	
			
	//lingering smk inside collapsed building
	level._effect[ "berlin_postcollapse_obscure_smk_l" ]		= loadfx( "maps/berlin/berlin_postcollapse_obscure_smk_l" );	
	level._effect[ "berlin_postcollapse_obscure_smk_m" ]		= loadfx( "maps/berlin/berlin_postcollapse_obscure_smk_m" );
	level._effect[ "berlin_postcollapse_obscure_smk_m_thick" ]	= loadfx( "maps/berlin/berlin_postcollapse_obscure_smk_m_thick" );
	level._effect[ "berlin_postcollapse_obscure_smk_s" ]		= loadfx( "maps/berlin/berlin_postcollapse_obscure_smk_s" );
	level._effect[ "berlin_postcollapse_obscure_smk_v" ]		= loadfx( "maps/berlin/berlin_postcollapse_obscure_smk_v" );
	level._effect[ "berlin_postcollapse_obscure_smk_wide" ]		= loadfx( "maps/berlin/berlin_postcollapse_obscure_smk_wide" );
	level._effect[ "berlin_postcollapse_grn_haze" ]				= loadfx( "maps/berlin/berlin_postcollapse_grn_haze" );
	level._effect[ "berlin_postcollapse_grn_haze_sun" ]			= loadfx( "maps/berlin/berlin_postcollapse_grn_haze_sun" );
	level._effect[ "berlin_postcollapse_embers" ]				= loadfx( "maps/berlin/berlin_postcollapse_embers" );
	level._effect[ "firelp_med_pm_cheap2" ]						= loadfx( "maps/berlin/firelp_med_pm_cheap2" );
	level._effect[ "pipe_fire_looping" ]						= loadfx( "impacts/pipe_fire_looping" );
		
	//god rays inside collapsed building
	level._effect[ "berlin_postcollapse_ray" ]					= loadfx( "maps/berlin/berlin_postcollapse_ray" );
	level._effect[ "berlin_postcollapse_ray_sm" ]				= loadfx( "maps/berlin/berlin_postcollapse_ray_sm" );
		
	//falling vfx inside collapsed building
	level._effect[ "berlin_postcollapse_powerlines" ]			= loadfx( "maps/berlin/berlin_postcollapse_powerlines" );
	level._effect[ "berlin_postcollapse_falling_dirt" ]			= loadfx( "maps/berlin/berlin_postcollapse_falling_dirt" );
	level._effect[ "postcollapse_falling_dirt_camShk" ]			= loadfx( "maps/berlin/berlin_postcollapse_falling_dirt_camShk" );
	level._effect[ "ceiling_falling_tile" ]						= loadfx( "dust/ceiling_falling_tile" );
	level._effect[ "rock_falling" ] 					 		= LoadFX( "misc/rock_falling" );
	level._effect[ "falling_objects" ] 					 		= LoadFX( "maps/berlin/berlin_postcollapse_office_objects_fall" );
	
	//falling column and ibeams impact vfx
	level._effect[ "column_fall_dust_impact" ]					= loadfx( "dust/column_fall_dust_impact" );
	level._effect[ "column_fall_dust_impact_wide" ]				= loadfx( "dust/column_fall_dust_impact_wide" );
	level._effect[ "ibeam_fall_dust_wide_berlin" ]				= loadfx( "maps/berlin/ibeam_fall_dust_wide_berlin" );
	
	//roof collapse in fallen building
	level._effect[ "berlin_ceiling_collapse_dust" ] 			= LoadFX( "maps/berlin/berlin_ceiling_collapse_dust" );
	level._effect[ "hallway_collapse_smk_runner_short_lite" ] 	= LoadFX( "smoke/hallway_collapse_smk_runner_short_lite" );
	
	//damaged bathroom vfx
	level._effect[ "falling_water_trickle_infrequent" ]			= loadfx( "water/falling_water_trickle_infrequent" );
	level._effect[ "water_faucet_spray" ]						= loadfx( "water/water_faucet_spray" );
	level._effect[ "water_flow_sewage_small" ]					= loadfx( "water/water_flow_sewage_small" );
	level._effect[ "waterfall_drainage_mp_small" ]				= loadfx( "water/waterfall_drainage_mp_small" );
	level._effect[ "ash_aftermath_250x250" ]					= loadfx( "weather/ash_aftermath_250x250" );
	level._effect[ "amb_dust_verylight_small_grey" ]			= loadfx( "dust/amb_dust_verylight_small_grey" );
	level._effect[ "smoke_dust_poof" ]							= loadfx( "smoke/smoke_dust_poof" );

	//treadfx
	level._effect[ "heli_dust_berlin" ]			 				= loadfx( "treadfx/heli_dust_berlin" );	
	level._effect[ "heli_dust_berlin2" ]			 				= loadfx( "treadfx/heli_dust_berlin2" );	
	level._effect[ "heli_water_berlin" ]			 			= loadfx( "treadfx/heli_water_berlin" );	
	level._effect[ "tread_dust_berlin" ]			 				= loadfx( "treadfx/tread_dust_berlin" );	
	level._effect[ "a10_tread_dust_berlin" ]			 		= loadfx( "treadfx/a10_tread_dust_berlin" );	
	
}
		
init_smVals()
{
	setsaveddvar("fx_alphathreshold",5);
	
	flag_wait("trigger_vfx_expl_heli_ride");
	setsaveddvar("fx_alphathreshold",12);
	
	level waittill("building_fall_se_vfx_start");
	setsaveddvar("fx_alphathreshold",15);
	
	flag_wait("ambush_after_building_collapse_start");
	setsaveddvar("fx_alphathreshold",10);
}		
		
treadfx_override()
{
	
	helivehicletypefx[0] = "script_vehicle_littlebird_player";
	helivehicletypefx[1] = "script_vehicle_littlebird_bench";
	helivehicletypefx[2] = "script_vehicle_apache_dark";

			
	fx = "treadfx/heli_dust_berlin";
	water_fx = "treadfx/heli_water_berlin";
	
	level.treadfx_maxheight = 5000;
	
	foreach(helivehicletype in helivehicletypefx)
	{
		maps\_treadfx::setvehiclefx( helivehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paper", fx );
	  	maps\_treadfx::setvehiclefx( helivehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "snow", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ceramic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( helivehicletype, "none" );
	}
	//end of level heli dust tread fx
	helivehicletypefxend[0] = "script_vehicle_ny_harbor_hind";
	helivehicletypefxend[1] = "script_vehicle_hind_woodland";
	
	fx = "treadfx/heli_dust_berlin2";
	
	foreach(helivehicletype in helivehicletypefxend)
	{
		maps\_treadfx::setvehiclefx( helivehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paper", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "snow", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ceramic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( helivehicletype, "none" );
	}
	
	//tank dust fx
	tankvehicletypefx[0] = "script_vehicle_leopard_2a7";
	tankvehicletypefx[1] = "script_vehicle_t90_tank_woodland_berlin";
	
	fx = "treadfx/tread_dust_berlin";
	
	foreach(tankvehicletype in tankvehicletypefx)
	{
		maps\_treadfx::setvehiclefx( tankvehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "paper", fx );
	  	maps\_treadfx::setvehiclefx( tankvehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "snow", fx );
	 	//maps\_treadfx::setvehiclefx( tankvehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "ceramic", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( tankvehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( tankvehicletype, "none" );
	}
	
	//a10
	helivehicletypefxa10[0] = "script_vehicle_a10_warthog";
	fx = "treadfx/a10_tread_dust_berlin";
	water_fx = "treadfx/heli_water_berlin";
	level.treadfx_maxheight = 3000;
	foreach(helivehicletype in helivehicletypefxa10)
	{
		maps\_treadfx::setvehiclefx( helivehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paper", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "snow", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ceramic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( helivehicletype, "none" );
	}
}


kill_intro_smk ()
{
	flag_wait("player_unloaded_from_intro_flight");

	foreach ( fx in level.createFXent )
	{
		if(
		(fx.v[ "fxid" ]=="fireball_smk_M" && fx.v[ "type" ]=="oneshotfx")
		||(fx.v[ "fxid" ]=="thin_black_smoke_M" && fx.v[ "type" ]=="oneshotfx")
		||(fx.v[ "fxid" ]=="ground_fog_berlin" && fx.v[ "type" ]=="oneshotfx")
		||(fx.v[ "fxid" ]=="smk_column_giant_berlin_stop" && fx.v[ "type" ]=="oneshotfx")
		)
		fx pauseEffect();
	}
}

kill_giant_smk_columns ()
{
	flag_wait("sniper_complete");

	foreach ( fx in level.createFXent )
	{
		if(fx.v[ "fxid" ]=="smk_column_giant_berlin" && fx.v[ "type" ]=="oneshotfx")
		fx pauseEffect();
	}
}

kill_skybox_vfx()
{	
	flag_wait("rus_all_tanks_dead");
	
	foreach ( fx in level.createFXent )
	{
		if(
		(fx.v[ "fxid" ]=="skybox_smoke_berlin" && fx.v[ "type" ] == "exploder" )  
		||(fx.v[ "fxid" ]=="skybox_mist_berlin" && fx.v[ "type" ]=="exploder")
		||(fx.v[ "fxid" ]=="skybox_smoke_wide_berlin" && fx.v[ "type" ]=="exploder")
		)
		fx pauseEffect();
	}
}

kill_vfx_before_building_explode()
{	
	flag_wait("lone_star_going_down");
	
	foreach ( fx in level.createFXent )
	{
		if(
		(fx.v[ "fxid" ]=="fireball_smk_M" && fx.v[ "type" ] == "exploder" )  
		||(fx.v[ "fxid" ]=="ground_fog_berlin" && fx.v[ "type" ]=="exploder")
		)
		fx pauseEffect();
	}
}

kill_all_env_fx ()
{	
	flag_wait("player_interacting_with_wounded_lonestar");
	
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "type" ] == "oneshotfx" ) || ( fx.v[ "type" ] == "exploder" ))  
		fx pauseEffect();
	}
}

smktrail_giant_flying_debri()
{
	//iprintlnbold( "smktrail" );
	playfxontag(getfx("smoke_trail_grey_giant_short_emitter"),self,"jnt_building_piece_d_lod01_4");
	wait(5);
	stopfxontag(getfx("smoke_trail_grey_giant_short_emitter"),self,"jnt_building_piece_d_lod01_4");
}

building_fall_sequence_vfx()
{
	
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
	}
	
	level notify("building_fall_se_vfx_start");
	
	//initial mega explosion
	exploder(501);	
	
	//glass shooting out from windows of other buildings
	wait(0.1);	
	exploder(551);
	wait(0.1);	
	exploder(552);
	
	//3 impacts from flying subcompact car when hitting the ground surface
	wait(0.45);
	exploder(510);
	
	//falling paper
	exploder(505);
	
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( false );
	}
	
	//initial falling glass from sky and first falling debris_tiny
	wait( 0.55);
	exploder(590);
	//trigger falling debris
	wait( 1.75);
	exploder(591);
	
	//secondary explosion 1: right side as building falls
	wait(1.75);
	exploder(592);
	
	//rolling smoke
	wait (3.25);
	exploder(601);

	wait(0.0);
	//secondary explosion 2: left side as building falls -- 2 firing at almost the same time with different angle
	exploder(593);
		
	wait(0.35);
	//building collide explosions and dustfall
	aud_send_msg("building_collide");
	exploder(599);
					
	wait(0);
	//trigger vfx for the new teleported area
	exploder(602);
	
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
	}
		
	wait(1.95);
	//secondary explosion 2: front face of building -- 2 firing at different times and locations
	exploder(594);
	
	wait(3.2);
	//secondary explosion 3: side of the building as it rests on AA building after crashing into it.
	exploder(595);
	
	wait(3.5);
	//secondary explosion 4: side of the building as it rests on AA building after crashing into it.
	exploder(596);

	wait(1.3);
	//secondary explosion 5: side of the building as it rests on AA building after crashing into it.
	exploder(597);
	
	wait(0.4);
	//secondary explosion 6: side of the building as it rests on AA building after crashing into it.
	exploder(598);
	
	flag_wait("entered_building_collapse");
	
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( false );
	}
}


falling_dust_player_hand()
{
	thread falling_dust_player_hand_left();
	
	wait(5.5);
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Pinky_RI_0");
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Mid_RI_1");
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Thumb_RI_1");
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Index_RI_2");
	
	wait(1.0);
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Mid_RI_1");
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Thumb_RI_1");
	
	wait(1.05);
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Index_RI_2");
	
	wait(1.25);
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Pinky_RI_0");
}

falling_dust_player_hand_left()
{
	wait(6.55);
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Pinky_LE_0");
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Mid_LE_2");
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Pinky_LE_2");
	
	wait(0.25);
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_PinkyPalm_RI");
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Ring_LE_0");
	playfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Ring_LE_2");
	
	wait(4.35);
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Pinky_LE_0");
	
	wait(0.25);
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Mid_LE_2");
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Pinky_LE_2");
	
	wait(0.5);
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_PinkyPalm_RI");
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Ring_LE_0");
	stopfxontag(getfx("berlin_dustfall_player_hand"),self,"J_Ring_LE_2");
}

kill_temp_fx_after_teleport ()
{	
	flag_wait("player_teleport_after_collapse_complete");
	wait (5.0);
	kill_exploder (602);
}

building_falling_column_vfx()
{	
	//iprintlnbold( "column" );
	playfxontag(getfx("falling_dirt_light_1_runner"),self,"jnt_piece02_mid");
	playfxontag(getfx("falling_dirt_light_1_runner"),self,"jnt_piece01_mid");
	wait (0.3);
	stopfxontag(getfx("falling_dirt_light_1_runner"),self,"jnt_piece02_mid");
	stopfxontag(getfx("falling_dirt_light_1_runner"),self,"jnt_piece01_mid");
	
	wait (1.38);
	exploder (10005);
}

intro_dof()
{
	start = level.dofDefault;	

	dof_intro = [];
	dof_intro[ "nearStart" ] = .1;
	dof_intro[ "nearEnd" ] = .2;
	dof_intro[ "nearBlur" ] = 4.0;
	dof_intro[ "farStart" ] = 1000;
	dof_intro[ "farEnd" ] = 15000;
	dof_intro[ "farBlur" ] = 1.25;
	
	blend_dof( start, dof_intro, .2 );
	
	wait( 33 );
	
	blend_dof ( dof_intro, start, .5 );
	
}

building_explosion_dof()
{	
//	assert(isdefined(level.dofOriginal));
//	start = level.currentDof;
	start = level.dofDefault;
//	level.dofOriginal = start;
	
	dof_building_explosion = [];
	dof_building_explosion[ "nearStart" ] = 50.0;
	dof_building_explosion[ "nearEnd" ] = 800;
	dof_building_explosion[ "nearBlur" ] = 9.0;
	dof_building_explosion[ "farStart" ] = 1000;
	dof_building_explosion[ "farEnd" ] = 15000;
	dof_building_explosion[ "farBlur" ] = 1.25;	
	
	blend_dof( start, dof_building_explosion, .05 );
	
	wait ( 18 );
	
//	blend_dof( dof_building_explosion, level.dofOriginal, .25 );
	blend_dof( dof_building_explosion, start, .25 );
}

rappel_dof()
{
	start = level.dofDefault;	

	dof_rappel = [];
	dof_rappel[ "nearStart" ] = .1;
	dof_rappel[ "nearEnd" ] = .2;
	dof_rappel[ "nearBlur" ] = 4.0;
	dof_rappel[ "farStart" ] = 150;
	dof_rappel[ "farEnd" ] = 1000;
	dof_rappel[ "farBlur" ] = 1.8;
	
	blend_dof( start, dof_rappel, 1.2 );
	
	wait ( 8.5 );
	
	blend_dof ( dof_rappel, start, 1.0 );
	
}

loop_skybox_hinds()
{
	wait(0.2);
	exploder(999);
	for(;;)
	{
		//play until street battle
		flag_waitopen("start_bridge_battle");
		wait(12.0);
		//the looping hindfx are on exploder 999
		exploder(999);
	}
}

loop_skybox_hinds_alleyway()
{
	wait(0.2);
	for(;;)
	{
		//play until street battle
		flag_wait_any("msg_vfx_zone3_cafecourtyard", "msg_vfx_zone3_cafecourtyard1");
		wait(8.0);
		//the looping hindfx are on exploder 3005
		exploder(3005);
	}
}

heli_endinterior(heli)
{
	flag_wait("reverse_breach_door_blown");
	playfxontag(getfx("chinook_red_light"), heli, "tag_light_cargo01");	
	//iprintlnbold("breachy");
	
	
	
}

ambientExplosion_aabuilding()
{
	wait(1.5);
	thread shg_spawn_tendrils(2401,"smoke_geotrail_genericexplosion",0,500,2000,10,30,200,90,1200);
	expPos = [( -1369.81, 13555.2, 2514.43 ),
			( -3838.98, 13354.3, 1618.75 ),
			( -2065.98, 7277.36, 1238.13 ),
			( -4835.05, 9188.86, 805.181 ),
			( -5496.43, 9459.58, 1297.62 ),
			( -4903.03, 8583.96, 855.278 ),
			( 2644.42, 10595, 1485.75 ),
			( 3187.99, 11704.7, 1679.51 ),
			( 2098.51, 12829.1, 1768.11 ),
			( 3613.51, 8318.4, 845.943 ),
			( 7045.14, 8380.4, 2040.43 ),
			( 6080.14, 11559.4, 1579.43 ),
			//( 2607.46, 6693.05, 609.125 ),
			//( 2040.18, 6618.46, 392.125 ),
			( 2764.97, 12334.5, 1339.39 ),
			( 2582.02, 10357, 1500.13 ),
			( 3826.83, 13539.7, 1900.73 ),
			( 3495.43, 10239.9, 1419.98 ),
			( 5392.93, 12609.4, 1693.98 ),
			( -406.105, 12185.3, 1435.13 ),
			( -998.955, 12576.2, 2065.53 ),
			( -1115.08, 13750.3, 2717.23 ),
			( -3267.8, 13182.6, 1589.47 ),
			( -1377.31, 13537, 1135.38 ),
			( -5929.24, 10441.3, 1535.01 ),
			(-3460.5, 13598.2, 1659.74),
			(-4559.18, 13904.3, 1272.13),
			(-2090.86, 8000.55, 35.854),
			(-2340.3, 11785.6, 1062.74)];
    
	for(;;)
	{
		flag_wait("msg_vfx_zone2_aabuilding_ambExplosion");
		
		//Wait a # of seconds
		randomInc = randomfloatrange(-.35,.35)+1;
		wait(randomInc);
				
		fxEnts = [];
		//Find the explosions the player is looking at
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		ent = get_exploder_ent(2401);
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < expPos.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(expPos[i]-level.player.origin);
			if(vectordot(eye,toFX)>.45) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = expPos[i];
			}
		}
		
		//to1.origin = self.player getorigin();
		if(found_exp >0)
		{
			curr_exp_num = randomInt((final_exp_pos.size+1));
			if(isdefined(curr_exp_num))
			{
				ent.v["origin"] = final_exp_pos[curr_exp_num];
				if(isdefined(ent.v["origin"]) && isdefined(ent)) exploder(2401);
				aud_send_msg("msg_audio_fx_ambientExp", final_exp_pos[curr_exp_num]);
			}
			wait(2);
		}
		
	}
}


ambientExplosion_glassy_aabuilding()
{
	wait(2.0);
	thread shg_spawn_tendrils(2402,"smoke_geotrail_genericexplosion",0,500,2000,10,30,200,90,1200);
	expPos = [( -1090.31, 13627, 2063.58 ),
			( -3444.3, 12973.4, 1327.57 ),
			( -4394.97, 8652, 765.306 ),
			( -5419.45, 9741.96, 1108.4 ),
			( -4710.04, 14298, 1988.96 ),
			( -275.195, 11501.1, 1133.94 )];
    
    for(;;)
	{
		flag_wait("msg_vfx_zone2_aabuilding_ambExplosion");
		
		//Wait a # of seconds
		randomInc = randomfloatrange(-.45,.45)+1;
		wait(randomInc);
				
		fxEnts = [];
		//Find the explosions the player is looking at
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		ent = get_exploder_ent(2402);
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < expPos.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(expPos[i]-level.player.origin);
			if(vectordot(eye,toFX)>.45) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = expPos[i];
			}
		}
		
		//to1.origin = self.player getorigin();
		if(found_exp >0)
		{
			curr_exp_num = randomInt((final_exp_pos.size+1));
			if(isdefined(curr_exp_num))
			{
				ent.v["origin"] = final_exp_pos[curr_exp_num];
				if(isdefined(ent.v["origin"]) && isdefined(ent)) exploder(2402);
				aud_send_msg("msg_audio_fx_ambientExp", final_exp_pos[curr_exp_num]);
			}
			wait(2);
		}
		
	}
}


door_godray_vfx()
{
	exploder(255);
}

door_emerge_vfx()
{ 
	//godray_large	
	exploder(256);
	
	//door_kick
	wait(0.05);	
	exploder(257);
	
	wait(0.05);	
	foreach ( fx in level.createFXent )
	{
		if(
		(fx.v[ "fxid" ]=="lights_godray_beam" && fx.v[ "type" ] == "exploder" )  
		)
		fx pauseEffect();
	}

	
	wait(40.0);
		foreach ( fx in level.createFXent )
	{
		if(
		(fx.v[ "fxid" ]=="lights_godray_beam_l" && fx.v[ "type" ] == "exploder" )  
		)
		fx pauseEffect();
	}
}

door_kick_vfx_1()
{ 
	wait(0.4);	
	exploder(258);	
}

door_kick_vfx_2()
{ 
	//iprintlnbold( "doorkick2" );
	wait(0.4);	
	exploder(259);	
}

tank_dirt_vfx(tank)
{
	wait( 1 );
	//iprintlnbold( "tank_advance1" );
	exploder(500);
	//playfxontag(getfx("tank_dirt1"), tank, "tag_origin");
}

tank_dirt_vfx2(tank)
{
	wait( 5.5 );
	//iprintlnbold( "tank_advance2" );
	exploder(499);
	//playfxontag(getfx("tank_dirt"), tank, "tag_origin");
}

bridge_tanks_destroyed()
{
	waitframe();
	flag_wait("bridge_one_tank_destroyed");
	exploder(4040);
}

check_volumes( volume_array )
{
	foreach( volume in volume_array )
	{
		if(level.player isTouching( volume ))
			return true;
		wait(0.05);
	}
	return false;
}

water_sheeting()
{
	waitframe();
	flag_wait_any( "msg_vfx_zone10_collapse_2", "msg_vfx_zone2_aabuilding_lvl1" );
	water_vols = getentarray( "sub_water_sheeting_vol", "targetname" );
	water_sheeting_on = false;
	for(;;)
	{
		flag_wait_any( "msg_vfx_zone10_collapse_2", "msg_vfx_zone2_aabuilding_lvl1" );
		if( check_volumes( water_vols ) )
		{
			if( water_sheeting_on == false )
			{
				level.player setwatersheeting( 1 );
				water_sheeting_on = true;
			}
			wait( .05 );
		}else if( water_sheeting_on == true )
		{
			level.player setwatersheeting( 1, 0.5 );
			water_sheeting_on = false;
			wait( .05 );
		}
		else{
			wait( .05 );
		}
	}
}
