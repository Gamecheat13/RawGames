#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_anim;
#include maps\_vehicle;


main()
{
	thread precacheFX();
	maps\createfx\paris_a_fx::main();
	maps\_shg_fx::setup_shg_fx();
	
	maps\_vehicle::build_deathfx_override( "script_vehicle_btr80", "btr80", "vehicle_btr80", "fire/fire_med_pm_nolight_atlas", "TAG_CARGOFIRE", "fire_metal_medium",undefined,undefined,1 );
	maps\_vehicle::build_deathfx_override( "script_vehicle_btr80", "btr80", "vehicle_btr80", "explosions/vehicle_explosion_btr80_physics_paris", "tag_deathfx", "exp_armor_vehicle" );
	
	flag_init( "game_fx_started" );
	flag_init("msg_fx_in_bookstore");
	flag_init("player_rooftop_jump_complete");
	


	//level thread convertOneShot();




	/*********************************************************
	EXPLODER NUMBERS & FX ZONE WATCHERS
	
	**********************************************************/
	//10000	=	ambient land exploder
	//10001 =	ambient aa fire
	//10002 =	2nd round of distant smoke plumes
	
	
	//1100 = rooftop to collapsed apartment
	//1110 = collapsed apartment to stairway
	//1200 = stairway and bookstore
	//2000 = alley way of the kitchen
	//2500 = kitchen specific to lighting
	//3000 = restaurant courtyard and interior rooms (overlaps partial ac130 strike street)
	//4000 = first ac130 strike street
	//5000 = helicopter crash site couryard up to manhole cover location and second ac130 tank strike
	//6000 = underground: manhole ladder and stairway down to the entrance of sewer


	
	thread fx_zone_watcher(1100,"msg_fx_zone1100");////rooftop to collapsed apartment
	thread fx_zone_watcher(1110,"msg_fx_zone1110");//collapsed apartment to stairway
	thread fx_zone_watcher(1200,"msg_fx_zone1200","msg_fx_zone1210");//stairway and bookstore
	thread fx_zone_watcher(2000,"msg_fx_zone2000");//alley way of the kitchen
	thread fx_zone_watcher(2500,"msg_fx_zone2500");//kitchen specific to lighting
	thread fx_zone_watcher(3000,"msg_fx_zone3000");//restaurant courtyard and interior rooms (overlaps partial ac130 strike street)
	thread fx_zone_watcher(3500,"msg_fx_zone3500","msg_fx_zone3600");//Yoga Studio
	thread fx_zone_watcher(4000,"msg_fx_zone4000");//first ac130 strike street
	thread fx_zone_watcher(5000,"msg_fx_zone5000");//helicopter crash site couryard up to manhole cover location and second ac130 tank strike
	thread fx_zone_watcher(6000,"msg_fx_zone6000");//underground: manhole ladder and stairway down to the entrance of sewer
	
	//poison gas walk wind
/*	thread fx_zone_watcher(101,"msg_fx_walkwind_01");
	thread fx_zone_watcher(102,"msg_fx_walkwind_02");
	thread fx_zone_watcher(103,"msg_fx_walkwind_03");
	thread fx_zone_watcher(104,"msg_fx_walkwind_04");
	thread fx_zone_watcher(105,"msg_fx_walkwind_05");
	thread fx_zone_watcher(106,"msg_fx_walkwind_06");
	thread fx_zone_watcher(107,"msg_fx_walkwind_07");
	thread fx_zone_watcher(108,"msg_fx_walkwind_08");
	thread fx_zone_watcher(109,"msg_fx_walkwind_09");*/
	thread fx_zone_watcher(110,"msg_fx_walkwind_10");
	
	thread fx_zone_watcher(201,"msg_fx_entrywind_01");
	thread fx_zone_watcher(202,"msg_fx_entrywind_02");


	/*********************************************************
	START FX LOGIC THREADS HERE
	
	**********************************************************/
	thread start_ambient_landexplosions();
	thread start_ambient_flak();
	thread start_distant_bombShakes();
	thread kill_oneshot_smk_cols();
	thread kill_oneshot_intro_smokecolumn();
	thread loop_skybox_hinds();
	thread loop_skybox_migs();
	thread loop_skybox_paratrooper_jets();
	thread play_slava_missiles();
	thread start_secondary_smoke_plumes();
	thread treadfx_override();
	thread setup_poison_wake_volumes();
	thread fx_trigger_manual_bombshake();
	thread convertOneshot();
	thread init_smVals();
	


	
	
}


precacheFX()
{
	/*===========================
	placeholder vfx
	===========================*/
	level._effect[ "wall_destruction" ] 										= loadfx( "explosions/transformer_explosion" );
	level._effect[ "truck_sparks" ] 												= loadfx( "misc/vehicle_scrape_sparks" );
	level._effect[ "large_vehicle_explosion" ] 							= loadfx( "explosions/large_vehicle_explosion" );
	
	level._effect[ "ground_smoke_dcburning1200x1200" ]			= loadfx( "smoke/ground_smoke1200x1200_dcburning" );
	level._effect[ "firelp_small_pm" ]											= LoadFX( "fire/firelp_small_pm" );
	level._effect[ "firelp_med_pm" ]												= LoadFX( "fire/firelp_med_pm" );
	level._effect[ "firelp_large_pm" ]											= LoadFX( "fire/firelp_large_pm" );
	level._effect[ "heli_strafe_impact" ]										= LoadFX( "impacts/ac130_25mm_IR_impact" );
	level._effect[ "light_police_car" ]										= LoadFX( "lights/light_blink_paris_police" );
	
	
	/*===========================
	non placeholder vfx
	===========================*/
	
	//level ambient vfx
	level._effect[ "fireball_smk_S" ]						  							= loadfx( "fire/fireball_lp_smk_S" );
	level._effect["ambient_explosion"]													= loadfx ("maps/paris/ambient_explosion_paris");	
	level._effect["smoke_geotrail_genericexplosion"]						= loadfx("smoke/smoke_geotrail_genericexplosion_b" );
	level._effect["antiair_runner_flak_day"]												= loadfx("misc/antiair_runner_flak_day");
	level._effect["antiair_runner_cloudy_paris"]												= loadfx("maps/paris/antiair_runner_cloudy_paris");
	level._effect[ "battlefield_smk_directional_white_m_cheap" ]							= loadfx( "smoke/battlefield_smk_directional_white_m_cheap" );
	level._effect[ "battlefield_smk_directional_grey_m_cheap" ]							= loadfx( "smoke/battlefield_smk_directional_grey_m_cheap" );
	level._effect[ "amb_dust_small" ]																	= loadfx( "smoke/amb_dust_small" );
	level._effect[ "amb_ash" ]																	= loadfx( "smoke/amb_ash" );
	level._effect[ "firelp_small_pm" ]													= LoadFX( "fire/firelp_small_pm" );
	level._effect[ "fire_flash" ]													= LoadFX( "fire/fire_flash_small" );
	level._effect[ "embers_smokecolumn" ]													= LoadFX( "fire/embers_smokecolumn" );
	level._effect[ "firelp_tiny" ]													= LoadFX( "fire/firelp_small_pm_a" );
	level._effect[ "firelp_small_streak_pm_v_nolight" ]													= LoadFX( "fire/firelp_small_streak_pm_v_nolight" );
	level._effect[ "fire_line_sm" ]															= LoadFX( "fire/fire_line_sm" );
	level._effect[ "fire_line_sm_cheap" ]															= LoadFX( "fire/fire_line_sm_cheap" );
	level._effect[ "fire_ceiling_md_slow" ]													= LoadFX( "fire/fire_ceiling_md_slow" );
	level._effect[ "firelp_med_pm_nolight_atlas" ]							= LoadFX( "fire/fire_med_pm_nolight_atlas" );
	level._effect[ "firelp_med_pm_atlas_nodist_cheap" ]							= LoadFX( "fire/firelp_med_pm_atlas_nodist_cheap" );
	level._effect["fire_embers_directional_slow"]								= loadfx ("fire/fire_embers_directional_slow");	
	level._effect[ "dust_wind_slow_paper_narrow" ]							= loadfx( "dust/dust_wind_slow_paper_narrow" );
	level._effect[ "dust_wind_slow_paper_narrow_flaming" ]							= loadfx( "dust/dust_wind_slow_paper_narrow_flaming" );
	level._effect[ "distant_ambient_dust" ]							= loadfx( "smoke/amb_smoke_distant_paris" );
	level._effect["cloud_ash_lite_london"]										= loadfx ("weather/cloud_ash_lite_london");
	level._effect[ "trash_spiral_runner" ]											= loadfx( "misc/trash_spiral_runner" );
 	level._effect[ "insects_carcass_flies" ]										= loadfx( "misc/insects_carcass_flies" );
	level._effect[ "embers_burst_runner_mediumlife" ]							= loadfx( "fire/embers_burst_runner_mediumlife");
 	level._effect[ "steam_vent_small" ]													= loadfx( "smoke/steam_vent_small" );
	level._effect[ "powerline_runner_sound"]										= loadfx ("explosions/powerline_runner_sound");	
	level._effect[ "electrical_transformer_spark_runner_loop"]										= loadfx ("explosions/electrical_transformer_spark_runner_loop");
	level._effect["falling_dirt_light_2"]													= loadfx ("dust/falling_dirt_light_2");	
	level._effect["falling_dirt_light_2_runner"]													= loadfx ("dust/falling_dirt_light_2_runner");
	level._effect["falling_dirt_light_2_paris"]													= loadfx ("dust/falling_dirt_light_2_paris");	
	level._effect["falling_dirt_light_2_runner_paris"]													= loadfx ("dust/falling_dirt_light_2_runner_paris");		
	level._effect["lights_conelight_smokey"]											= loadfx("lights/lights_conelight_smokey");
	level._effect["lights_godray_default"]												= loadfx("lights/lights_conelight_default");
	level._effect["lights_uplight_haze"]												= loadfx("lights/lights_uplight_haze");
	level._effect["window_explosion"]														= loadfx ("explosions/window_explosion");	
	level._effect["fire_falling_localized_runner"]								= loadfx ("fire/fire_falling_localized_runner_paris");	
	level._effect["ceiling_smoke_generic"]												= loadfx ("smoke/ceiling_smoke_generic");	
	level._effect["ceiling_smoke_undulating"]												= loadfx ("smoke/ceiling_smoke_undulating");	
	level._effect[ "thick_dark_smoke_giant_paris" ]									= loadfx( "smoke/thick_dark_smoke_giant_paris" );
	level._effect[ "thick_dark_smoke_giant_paris_oneshot" ]									= loadfx( "smoke/thick_dark_smoke_giant_paris" );
	level._effect[ "leaves_runner_1" ]												= loadfx( "misc/leaves_runner_1" );
	level._effect[ "leaves_fall_gentlewind" ]												= loadfx( "misc/leaves_fall_gentlewind" );
	level._effect[ "smoke_column_skybox_paris" ]													= loadfx ("maps/paris/smoke_column_skybox_paris");	
	level._effect[ "smoke_column_skybox_paris_oneshot" ]													= loadfx ("maps/paris/smoke_column_skybox_paris");	
	level._effect[ "skybox_mig29_flyby_manual_loop" ]												= loadfx( "misc/skybox_mig29_flyby_manual_loop" );
	level._effect[ "skybox_hind_flyby_loop" ]												= loadfx( "misc/skybox_hind_flyby" );
	level._effect[ "powerline_runner_cheap_paristv" ]												= loadfx( "explosions/powerline_runner_cheap_paristv" );
	level._effect[ "powerline_runner_cheap" ]												= loadfx( "explosions/powerline_runner_cheap" );
	level._effect[ "drips_faucet_fast" ]												= loadfx( "water/drips_faucet_fast" );
	level._effect[ "drips_faucet_slow" ]												= loadfx( "water/drips_faucet_slow" );
	level._effect[ "stove_burner_blue" ]			 						= loadfx( "misc/stove_burner_blue" );	
	level._effect[ "steam_pot_small" ]			 						= loadfx( "smoke/steam_pot_small" );	
	level._effect[ "embers_paris_alley" ]			 						= loadfx( "fire/embers_paris_alley" );
	level._effect[ "embers_spurt" ]			 						= loadfx( "fire/embers_spurt" );
	level._effect[ "lights_godray_beam" ]			 						= loadfx( "lights/lights_godray_beam" );
	level._effect[ "lights_godray_beam_bookstore" ]			 						= loadfx( "maps/paris/lights_godray_beam_bookstore" );
	level._effect[ "lighthaze_bookstore_window_lg" ]			 						= loadfx( "maps/paris/lighthaze_bookstore_window_lg" );
	level._effect[ "lighthaze_bookstore_window_sm" ]			 						= loadfx( "maps/paris/lighthaze_bookstore_window_sm" );
	level._effect[ "lighthaze_ledgewalk" ]			 						= loadfx( "maps/paris/lighthaze_ledgewalk" );
	level._effect[ "lighthaze_restaurant_window_lg" ]			 						= loadfx( "maps/paris/lighthaze_restaurant_window_lg" );
	level._effect[ "slava_missile_bg" ]			 						= loadfx( "maps/ny_harbor/smoke_geo_ssnm12_cheap_background" );
	level._effect[ "horizon_flash_runner" ]			 						= loadfx( "weather/horizon_flash_runner_harbor" );
	
	// for bloody_death
	level._effect[ "flesh_hit" ] 										= LoadFX( "impacts/flesh_hit_body_fatal_exit" );
	
	//poison gas fx
	level._effect[ "poisonous_gas_paris_vertical" ]												= loadfx( "smoke/poisonous_gas_paris_vertical" );
	level._effect[ "poisonous_gas_paris_vertical_thin" ]												= loadfx( "smoke/poisonous_gas_paris_vertical_thin" );
	level._effect[ "poisonous_gas_paris_vertical_shadow" ]												= loadfx( "smoke/poisonous_gas_paris_vertical_shadow" );
	level._effect[ "poisonous_gas_ground_paris_200" ]												= loadfx( "smoke/poisonous_gas_ground_paris_200" );
	level._effect[ "poisonous_gas_ground_paris_200_light" ]												= loadfx( "smoke/poisonous_gas_ground_paris_200_light" );
	level._effect[ "poisonous_gas_ground_paris_200_sunlight" ]												= loadfx( "smoke/poisonous_gas_ground_paris_200_sunlight" );
	level._effect[ "poisonous_gas_ground_paris_200_bookstore" ]												= loadfx( "smoke/poisonous_gas_ground_paris_200_bookstore" );
	level._effect[ "poisonous_gas_wallCrawl_paris" ]												= loadfx( "smoke/poisonous_gas_wallCrawl_paris" );
	level._effect[ "poisonous_gas_wallCrawl_paris_light" ]												= loadfx( "smoke/poisonous_gas_wallCrawl_paris_light" );
	level._effect[ "poisonous_gas_paris_walkwind" ]												= loadfx( "smoke/poisonous_gas_paris_walkwind" );
	level._effect[ "poisonous_gas_paris_walkwind_dark" ]												= loadfx( "smoke/poisonous_gas_paris_walkwind_dark" );
	level._effect[ "poisonous_gas_paris_entrywind" ]												= loadfx( "smoke/poisonous_gas_paris_entrywind" );
	level._effect[ "poisonous_gas_paris_entrywind_shadow" ]												= loadfx( "smoke/poisonous_gas_paris_entrywind_shadow" );
	level._effect[ "poisonous_gas_paris_pillar1" ]												= loadfx( "smoke/poisonous_gas_paris_pillar1" );
	level._effect[ "poison_movement" ]					= LoadFX( "impacts/footstep_poison" );
	level._effect[ "poison_movement_light" ]					= LoadFX( "impacts/footstep_poison_light" );
	level._effect[ "poison_movement_sunlight" ]					= LoadFX( "impacts/footstep_poison_sunlight" );
	level._effect[ "poison_movement_firelight" ]					= LoadFX( "impacts/footstep_poison_firelight" );
	level._effect[ "poison_movement_dark_groundcover" ]					= LoadFX( "impacts/footstep_poison_dark_groundcover" );
	level._effect[ "poisonous_gas_paris_flowing" ]												= loadfx( "smoke/poisonous_gas_paris_flowing" );
	level._effect[ "poisonous_gas_paris_flowing_far" ]												= loadfx( "smoke/poisonous_gas_paris_flowing_far" );
	level._effect[ "poisonous_gas_paris_truck_wreck" ]												= loadfx( "smoke/poisonous_gas_paris_truck_wreck" );
	level._effect[ "poisonous_gas_paris_flowing_down_small" ]												= loadfx( "smoke/poisonous_gas_paris_flowing_down_small" );
	level._effect[ "poisonous_gas_paris_flowing_down_tall" ]												= loadfx( "smoke/poisonous_gas_paris_flowing_down_tall" );
	level._effect[ "poisonous_gas_paris_flowing_down_impact" ]												= loadfx( "smoke/poisonous_gas_paris_flowing_down_impact" );
	level._effect[ "door_kick_poison_gas" ]												= loadfx( "dust/door_kick_poison_gas" );	

	
	/*===========================
	rooftop vfx
	===========================*/
	level._effect[ "smoke_column_intro_paris_a" ]									= loadfx( "maps/paris/smoke_column_intro_paris_a" );
	level._effect[ "smoke_column_intro_paris_blowaway" ]									= loadfx( "maps/paris/smoke_column_intro_paris_blowaway" );
	level._effect[ "papers_heli_landing" ]									= loadfx( "maps/paris/papers_heli_landing" );
	level._effect["ledge_window_smoke"]													= loadfx ("maps/paris/ledge_window_smoke");	
	level._effect["ledge_footstep_dust"]													= loadfx ("maps/paris/ledge_footstep_dust");	
	level._effect["monitor_flatscreen_explosion"]													= loadfx ("explosions/monitor_flatscreen_explosion");	

	/*===========================
	water vfx
	===========================*/
	level._effect[ "water_drips_fat_fast_speed" ]							= loadfx( "water/water_drips_fat_fast_speed" );
	level._effect[ "water_drips_fat_slow_speed" ]							= loadfx( "water/water_drips_fat_slow_speed" );
	level._effect[ "drips_fast" ]			 												= loadfx( "misc/drips_fast" );
	level._effect[ "drips_slow" ]			 												= loadfx( "misc/drips_slow" );
	
	/*===========================
	catacomb sewage vfx
	===========================*/
	level._effect[ "steam_manhole_paris" ]									= loadfx( "maps/paris/steam_manhole_paris" );
	level._effect[ "steam_manhole_paris_ambient" ]									= loadfx( "maps/paris/steam_manhole_paris_ambient" );
	
	//other vehicle fx
	level._effect[ "littlebird_exhaust" ]	 = loadfx( "distortion/littlebird_exhaust" );
	level._effect[ "tread_dust_paris" ]			 						= loadfx( "treadfx/tread_dust_paris" );	
	level._effect[ "heli_dust_paris" ]			 						= loadfx( "treadfx/heli_dust_paris" );	
	level._effect[ "scripted_flashbang" ]		= loadfx( "explosions/flashbang" );
	level._effect[ "vehicle_explosion_btr80_physics_paris" ]		= loadfx( "explosions/vehicle_explosion_btr80_physics_paris" );
	level._effect[ "btr_dest_blacksmoke" ]		= loadfx( "smoke/btr_dest_blacksmoke" );

	//paratrooper fx
	level._effect[ "russian_paratrp_jet" ]		= loadfx( "misc/russian_paratrp_jet");
	
	//script destructibles
	level._effect[ "plate_shatter_single" ]		= loadfx( "props/plate_shatter_single");

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

kill_oneshot_smk_cols()
{
	wait(.1);
	kill_oneshot("thick_dark_smoke_giant_paris_oneshot");
	kill_oneshot("smoke_column_skybox_paris_oneshot");
	
}

kill_oneshot_intro_smokecolumn()
{
	wait(0.1);
	flag_wait("flag_little_bird_landed");
	flag_waitopen("msg_fx_zone1100");
	flag_waitopen("msg_fx_zone1200");
	wait(10);
	kill_oneshot("smoke_column_intro_paris_a");
}


ambient_room_battles()
{
	//Add in explosions to bg rooms
	
}


littlebird_exhaust_oneoff()
{
	for(i=0;i<40;i++)
	{
		playfxontag(getfx("littlebird_exhaust"),self,"tag_engine");
		wait(.25);
	}
}




start_ambient_landexplosions()
{
	level waitframe();
	expPos = [(6505.49, 5888.73, 1692.79)
        ,(11736.7, 6552, 1769.03)
        ,(11960.1, 5952.24, 1776.06)
        ,(13681.2, 4513.68, 1825.63)
        ,(13315.7, 3572.87, 1884.65)
        ,(13544.6, 4214.83, 1836.6)
        ,(11036.6, 2264.1, 1830.96)
        ,(10258.5, 1526.81, 1808.53)
        ,(9678.35, 1214.24, 1724.61)
        ,(9626.72, -82.2788, 1736.13)
        ,(8947.07, -145.142, 1736.68)
        ,(8170.38, -136.929, 1736.89)
        ,(6498.5, -464.099, 1652.66)
        ,(5680.61, -2832.2, 1909.47)
        ,(5092.5, -5765.18, 1940.72)
        ,(4612.75, -5638.95, 1931.07)
        ,(4143.7, -4824.45, 1953.98)
        ,(2694.37, -3235.55, 1480.88)
        ,(2067.73, -3247.95, 1382.59)
        ,(841.024, -3378.74, 1371.32)
        ,(251.777, -3501.85, 1499.74)
        ,(-940.448, -3931.86, 1674.33)
        ,(-1298.23, -3657.76, 1692.87)
        ,(-1702.45, -2935.15, 1701.41)
        ,(-2552.23, -3350.26, 1613.59)
        ,(-2859.55, -4025.1, 1676.56)
        ,(-3793.26, -5382.22, 1768.94)
        ,(-2859.82, -5271.38, 1702.73)
        ,(-2734.26, -5024.82, 1804.07)
        ,(-3039.49, -5107.27, 1803.52)
        ,(-4420.65, -4046.23, 1816.55)
        ,(-4225.24, -4244.98, 1795.87)
        ,(-4907.63, -3132.69, 1595.52)
        ,(-5006.05, -2424.46, 1494.06)
        ,(-5431.67, -2204.63, 1529.58)
        ,(-5912.19, -2126.15, 1756.93)
        ,(-6460.29, -2156.72, 1773.43)
        ,(-7176.41, -1898.5, 1813.82)
        ,(-8566.13, -1204.44, 1792.86)
        ,(-8550.15, -896.05, 1617.95)
        ,(-9252.61, -949.501, 1392.83)
        ,(-10836.4, -2444.73, 1179.23)
        ,(-11262.8, -2767.1, 1196.43)
        ,(-12248.2, -1860.45, 1220.89)
        ,(-12435.3, -1765.22, 1230.64)
        ,(-14384.7, -1332.65, 1198.2)
        ,(-14137.4, -1335.72, 1173.54)
        ,(-18298.2, -1241.34, 801.097)
        ,(-18710.9, -689.57, 886.749)
        ,(-18432.1, 69.3459, 840.785)
        ,(-17428.5, 231.543, 926.315)
        ,(-15907, 292.558, 1060.87)
        ,(-15723.7, 2789.99, 1156.64)
        ,(-15718.6, 3213.07, 1166.79)
        ,(-14544, 6514.53, 1189.67)
        ,(-14432.8, 6557.28, 1275.29)
        ,(-14328.8, 7188.14, 1145.89)
        ,(-14307, 6970.36, 1228.98)
        ,(-14848, 8598.96, 1146.96)
        ,(-14464.1, 8901.04, 1267.1)
        ,(-14560, 9334.39, 1144.12)
        ,(-14245.5, 10160.9, 1117.66)
        ,(-13912.2, 11016.2, 1043.69)
        ,(-13933.5, 10835.1, 1146.92)
        ,(-13222.2, 11547.7, 1176.94)
        ,(-13434.5, 11244.6, 1279.34)
        ,(-12380, 11506.8, 1091.53)
        ,(-12808.1, 9254.62, 1054.09)
        ,(-12507.6, 8862.31, 1085.23)
        ,(-11674, 9018.09, 1269.91)
        ,(-11174.9, 8862.37, 981.754)
        ,(-10862.2, 8964.89, 1030.13)
        ,(-10344.1, 9055.94, 1200.24)
        ,(-9051.32, 9638.49, 1127.08)
        ,(-9481.87, 8755.83, 1185.17)
        ,(-8407.56, 8968.14, 1023.61)
        ,(-7815.09, 8979.76, 1000.37)
        ,(-7429, 8921.93, 1282.77)
        ,(-6575.75, 8942.94, 1039.22)
        ,(-6375.46, 8925.83, 1046.76)
        ,(-4887, 9344.01, 1104.06)
        ,(-4730.68, 8935.41, 1091.99)
        ,(-4215.5, 8723.02, 1180)
        ,(-2819.03, 8089.01, 1151.03)
        ,(-2880.98, 7266.66, 1065.83)
        ,(-3010.1, 6837, 1291.75)
        ,(-2868, 6558.34, 1158.97)
        ,(-3778.01, 4418.69, 1706.79)
        ,(-3483.11, 3952.02, 1757.42)
        ,(-3100.41, 3951.97, 1760.34)
        ,(-3292.34, 2806.17, 1742.52)
        ,(-3117.31, 2558.45, 1770.68)
        ,(-2586.05, 2259.76, 1715.49)
        ,(-960.534, 2296.68, 1610.08)
        ,(-514.935, 2431.93, 1539.13)
        ,(-553.36, 2101.79, 1602.13)
        ,(-1257.94, 1138.38, 1799.95)
        ,(864.276, 2386.09, 1717.02)
        ,(1259.05, 2391.62, 1650.88)
        ,(2365.52, 3607.41, 1880.91)
        ,(3633.76, 5008.42, 1983.61)
        ,(4715.27, 4932.42, 1904.04)
        ,(5738.63, 5201.83, 1764.85)
        ,(6197.68, 5295.45, 1739.24)
        ,(6771.28, 5160.61, 1789.38)
        ,(7331.13, 5144.45, 1795.47)
        ,(8222.75, 5131.4, 1782.37)
        ,(8944.91, 5176.09, 1862.85)
        ,(9101, 4138.82, 1857.16)
        ,(9465.68, 4034.64, 1780.17)
        ,(10021.9, 7119.32, 1767.32)
        ,(10346.4, 6994.52, 1802.99)
        ,(10818.3, 6622.81, 1770)
        ,(11193, 5763.97, 1798.62)];
	thread shg_spawn_tendrils(10000,"smoke_geotrail_genericexplosion",7,500,2000,10,30,200,75,1200);
	flag_wait( "game_fx_started" );
	wait(5.0);
	for(;;)
	{
		//Wait a # of seconds
		randomInc = randomfloatrange(-.5,.5)+1.5;
		wait(randomInc);
		//flag_waitopen("exp_playing");
		fxEnts = [];
		//Find the explosions the player is looking at
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		ent = get_exploder_ent(10000);
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < expPos.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(expPos[i]-level.player.origin);
			
			if(vectordot(eye,toFX)>.45 && distance(expPos[i],level.player.origin)>6000) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = expPos[i];
			}
		}
		if(found_exp >0)
		{
			curr_exp_num = randomInt((final_exp_pos.size+1));
			if(isdefined(curr_exp_num))
			{
				ent.v["origin"] = final_exp_pos[curr_exp_num];
				if(isdefined(ent.v["origin"]) && isdefined(ent)) exploder(10000);
				aud_send_msg("msg_audio_fx_ambientExp", final_exp_pos[curr_exp_num]);
			}
			wait(1);
		}
		
	}
}

start_distant_bombShakes()
{
	to1 = spawn_tag_origin();
	to1.origin = self.player getorigin();
	to1.angles = ( 270, 0, -45);
	if(!isdefined(level.bombshake_interval))
	{
		level.bombshake_interval = 18;//was at 20
		level.bombshake_interval_rand = 7;//was at 5
	}
	wait(15.0);//Make sure the fade in completes before it starts
	flag_init("enable_distant_bombShakes");
	//flag_set("enable_distant_bombShakes");//temp until audio does the real thing
	for(;;)
	{
		flag_waitopen("msg_fx_in_bookstore");
		//flag_wait( "player_rooftop_jump_complete" ); //don't go off until player is out of little bird
		flag_wait("enable_distant_bombShakes");	// Wait until this system is enabled manually.
		if (flag("enable_distant_bombShakes")) // Still have to check. (e.g., entering_hind could be set while waiting on "enable_distant_bombShakes").
		{
			play_distant_bombshake(to1);
		}
		
		randomInc = randomfloatrange((level.bombshake_interval_rand * -1),level.bombshake_interval_rand)+level.bombshake_interval;
		wait(randomInc);
	}	
}

play_distant_bombshake(to1, b_forceshake)
{
/*	offsetDist = 1008;//look up 10 ft
	to1.origin = level.player getorigin();
	trace = BulletTrace( (level.player.origin+(0,0,12)), level.player.origin+(0,0,1200), false, undefined);
	hitDist = distance(to1.origin,trace["position"]);*/
	
	//Send the message to audio
	aud_send_msg("generic_building_bomb_shake");
	if (!IsDefined (b_forceshake))
		b_forceshake = 0;
	fx_bombShakes("falling_dirt_light_2_paris","viewmodel_medium",.127,2,.3,.53, 1, b_forceshake);
}

start_ambient_flak()
{
	level waitframe();
	flag_wait( "game_fx_started" );
	wait(5.0);
	exploder(10001);
}

loop_skybox_hinds()
{
	waitframe();
	data = spawnStruct();
	get_createfx(999, data);
	ents = data.v["ents"];
	for (i=0; i<ents.size; i++)
	{
		thread loop_skybox_hinds_update(ents[i], "msg_fx_zone1100");
	}
}

loop_skybox_hinds_update(fx_ent,fx_flag)
{
	flag_wait(fx_flag);
	wait randomfloat(4);
	endLoc = (anglestoright(fx_ent.v["angles"]) * -50000) + fx_ent.v["origin"];
	aud_data[0] = fx_ent.v["origin"];
	aud_data[1] = endLoc;
	aud_data[2] = 25;
	aud_send_msg("fx_skybox_hind", aud_data);
	fx_ent activate_individual_exploder();
	for(;;)
	{
		flag_wait(fx_flag);
	  wait(randomfloat(6) + 10);
		fx_ent activate_individual_exploder();
		aud_send_msg("fx_skybox_hind", aud_data);
	}
}

loop_skybox_migs()
{
	waitframe();
	data = spawnStruct();
	get_createfx(998, data);
	ents = data.v["ents"];
	for (i=0; i<ents.size; i++)
	{
		thread loop_skybox_migs_update(ents[i], "msg_fx_zone1100");
	}
}

loop_skybox_migs_update(fx_ent,fx_flag)
{
	flag_wait(fx_flag);
	wait randomfloat(4);
	endLoc = anglestoright(fx_ent.v["angles"]) * -140000 + fx_ent.v["origin"] + (0,0,7000);
	aud_data[0] = fx_ent.v["origin"];
	aud_data[1] = endLoc;
	aud_data[2] = 10;
	aud_send_msg("fx_skybox_mig", aud_data);
	fx_ent activate_individual_exploder();
	for(;;)
	{
		flag_wait(fx_flag);
		wait(randomfloat(9) + 3);
		wait 2;
		fx_ent activate_individual_exploder();
		aud_send_msg("fx_skybox_mig", aud_data);
	}
}

loop_skybox_paratrooper_jets()
{
	waitframe();
	data = spawnStruct();
	get_createfx(997, data);
	ents = data.v["ents"];
	for (i=0; i<ents.size; i++)
	{
		thread loop_skybox_paratrooper_jets_update(ents[i], "msg_fx_zone1100");
	}
}

loop_skybox_paratrooper_jets_update(fx_ent,fx_flag)
{
	waitframe();
	endLoc = anglestoup(fx_ent.v["angles"]) * 68250 + fx_ent.v["origin"];
	aud_data[0] = fx_ent.v["origin"];
	aud_data[1] = endLoc;
	aud_data[2] = 39;
	aud_send_msg("fx_paratrooper_jet", aud_data);
	fx_ent activate_individual_exploder();
	for(i=0;i<3;i++)
	{
		flag_wait(fx_flag);
		wait(9);
		fx_ent activate_individual_exploder();
		aud_send_msg("fx_paratrooper_jet", aud_data);
	}
}

start_secondary_smoke_plumes()
{
	level waitframe();
	flag_wait("flag_little_bird_landed");
	flag_waitopen("msg_fx_zone1100");
	exploder(10002);
}

play_slava_missiles()
{
	waitframe();
	//level endon("msg_fx_stop_slava_missiles");
	missile_launchers = getentarray("missile_launcher", "targetname");
	lastPlayedExplosion = -1;
	num = 0;
	for(;;)
	{
		flag_wait("msg_fx_zone1100");
		while(num == lastPlayedExplosion)
		{
				num = randomint(missile_launchers.size);
					explosionToPlay = missile_launchers[num];
		}
			lastPlayedExplosion = num;
		thread slava_missile_trail(missile_launchers[num]);
		
		randomwait = randomfloat(2.5) + 1;
		wait (randomwait);
	}
}
	
slava_missile_trail(ent)
{
	mis = spawn("script_model", ent.origin);
	//mis SetModel("vehicle_s300_pmu2");
	mis SetModel("tag_origin");
	mis.angles = ent.angles;
	aud_data[0] = mis;
	aud_send_msg("pars_missile_launch", aud_data);
	//PlayFXOnTag( getfx( "slava_missile_bg" ), mis, "tag_fx" );
	PlayFXOnTag( getfx( "slava_missile_bg" ), mis, "tag_origin" );
	impulse = 18000;
	lifetime = 130;
	vectorUp = vectornormalize(anglestoforward(mis.angles));
	finalVector = vectorUp;
	currVel = finalVector * impulse * .05;
	gravity = (0,0,(1600) * -1) * .05 * .05; //squaring the acceleration abount
	explode = 0;
	while(explode == 0)
	{
		mis.origin += currVel;
		currVel += gravity;
		v_orient = vectornormalize(currVel);
		n_angles = vectortoangles(v_orient);
		mis.angles = n_angles;
		level waitframe();
		//once it hits the groudn plane, kill it
		if(mis.origin[2] <= 0)
			explode = 1;
	}
	//stopfxontag( getfx( "slava_missile_bg" ), mis, "tag_fx" );
	stopfxontag( getfx( "slava_missile_bg" ), mis, "tag_origin" );
	playfx(getfx("horizon_flash_runner"), mis.origin);
	aud_data[0] = mis.origin;
	aud_send_msg("pars_missile_explode", aud_data);
	mis delete();
}

treadfx_override()
{
	wait(0.1);
	fx = "treadfx/tread_dust_paris";
	vehicletype_fx[0] = "script_vehicle_t72_tank";
	vehicletype_fx[1] = "script_vehicle_gaz_tigr_harbor";
	

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
	 	maps\_treadfx::setvehiclefx( vehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
	 	//maps\_treadfx::setvehiclefx( vehicletype, "water", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", fx );
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
	helivehicletypefx[0] = "script_vehicle_littlebird_bench";
	helivehicletypefx[1] = "script_vehicle_mi17_woodland_fly";
	fx = "treadfx/heli_dust_paris";
	
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
	 //	maps\_treadfx::setvehiclefx( helivehicletype, "water", water_fx );
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
		
		if (!IsDefined( other ))
			continue;
		
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

#using_animtree("vehicles");	
fx_btr_deathquake()
{
	self waittill("death");
	Earthquake( 0.6, 2, self.origin, 1500 );
	location = self.origin + anglestoforward(self.angles) * (60,0,0);
	physicsexplosionsphere(location, 64, 64, 3.5);
  //self animScripted("btr_dead", self.origin, self.angles, %vehicle_80s_sedan1_destroy);
	//play spark effects
	wait 2;
	playfxontag(getfx("electrical_transformer_spark_runner_loop"), self, "tag_deathfx_hood");
	playfxontag(getfx("firelp_tiny"), self, "tag_deathfx_hood");
	playfxontag(getfx("btr_dest_blacksmoke"), self, "TAG_SIDESMOKE");
	
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
	if(flag_exist("enable_distant_bombshakes"))
		flag_clear("enable_distant_bombshakes");
	aud_send_msg("aud_manual_bombshake_triggered");	
	play_distant_bombshake(level.player, 1);
	wait 16;
	flag_set("enable_distant_bombShakes");
}

fx_halfres_on_flyin()
{
	//turn on halfres when level starts, turn it off after heli flies off roof
	flag_wait("msg_fx_zone1100");
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
	}
	flag_wait("msg_fx_heli_smoke_touch");
	wait(6.5); 
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( false );
	}
}

get_createfx(num, data)
{
	org = [];
	ang = [];
	ents = [];
	exploders = GetExploders( num );
	foreach (ent in exploders)
		{
				org[(org.size)]=ent.v["origin"];
				ang[(ang.size)]=ent.v["angles"];
				ents[(ents.size)]=ent;
			}
	data.v["origins"] =  org;
	data.v["angles"] = ang;
	data.v["ents"] = ents;
}