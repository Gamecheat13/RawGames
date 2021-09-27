#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_anim;
#include maps\_vehicle;


main()
{
	thread precacheFX();
	maps\createfx\paris_fx::main();
	
	flag_init( "game_fx_started" );
	flag_init("flag_catacombs_enemy_gate_gag_vfx");
	flag_init("msg_fx_in_bookstore");
	flag_init("player_rooftop_jump_complete");
	


	//level thread convertOneShot();




	/*********************************************************
	EXPLODER NUMBERS & FX ZONE WATCHERS
	
	**********************************************************/
	//10000	=	ambient land exploder
	//10001 =	ambient aa fire
	
	//1000s = rooftop to bookstore
	//1001 = when little bird pushes smoke out of the way
	//1099 = smoke columns that get spawned immediately on the roof
	//2000 = alley way of the kitchen
	//3000 = restaurant courtyard and interior rooms (overlaps partial ac130 strike street)
	//4000 = first ac130 strike street
	//5000 = helicopter crash site couryard up to manhole cover location and second ac130 tank strike
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
	//8400 = van chase: street 5, galleria ac130 strike
	//8500 = van chase: street 6 
	//8600 = van chase: street 7 
	//8700 = van chase: street 8, toward the end of van chase
	//9000 = ending scene courtyard

	
	//thread fx_zone_watcher(1000,"msg_fx_zone1000");//rooftop to bookstore
	thread fx_zone_watcher(1100,"msg_fx_zone1100","msg_fx_zone1110");//rooftop to stairway
	thread fx_zone_watcher(1200,"msg_fx_zone1200","msg_fx_zone1210");//stairway and bookstore
	thread fx_zone_watcher(2000,"msg_fx_zone2000");//alley way of the kitchen
	thread fx_zone_watcher(3000,"msg_fx_zone3000");//restaurant courtyard and interior rooms (overlaps partial ac130 strike street)
	thread fx_zone_watcher(4000,"msg_fx_zone4000");//first ac130 strike street
	thread fx_zone_watcher(5000,"msg_fx_zone5000");//helicopter crash site couryard up to manhole cover location and second ac130 tank strike
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
	thread fx_zone_watcher(8400,"msg_fx_zone8400");//van chase: street 5, galleria ac130 strike
	thread fx_zone_watcher(8500,"msg_fx_zone8500");//van chase: street 6 
	thread fx_zone_watcher(8600,"msg_fx_zone8600");//van chase: street 7 
	thread fx_zone_watcher(8700,"msg_fx_zone8700");//van chase: street 8, toward the end of van chase
	thread fx_zone_watcher(9000,"msg_fx_zone9000");//ending scene courtyard


	/*********************************************************
	START FX LOGIC THREADS HERE
	
	**********************************************************/
	thread start_ambient_landexplosions();
	thread start_ambient_flak();
	thread start_distant_bombShakes();
	thread kill_oneshot_smk_cols();
	thread catacombs_enemy_gate_gag_vfx();
	thread loop_skybox_hinds();


	
	
}


precacheFX()
{
	/*===========================
	placeholder vfx
	===========================*/
	level._effect[ "wall_destruction" ] 										= loadfx( "explosions/transformer_explosion" );
	level._effect[ "truck_sparks" ] 												= loadfx( "misc/vehicle_scrape_sparks" );
	level._effect[ "large_column" ]			 										= loadfx( "props/dcburning_pillars" );
	level._effect[ "large_vehicle_explosion" ] 							= loadfx( "explosions/large_vehicle_explosion" );
	
	level._effect[ "ground_smoke_dcburning1200x1200" ]			= loadfx( "smoke/ground_smoke1200x1200_dcburning" );
	level._effect[ "firelp_small_pm" ]											= LoadFX( "fire/firelp_small_pm" );
	level._effect[ "firelp_med_pm" ]												= LoadFX( "fire/firelp_med_pm" );
	level._effect[ "firelp_large_pm" ]											= LoadFX( "fire/firelp_large_pm" );
	level._effect[ "heli_strafe_impact" ]										= LoadFX( "impacts/ac130_25mm_IR_impact" );
	
	
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
	level._effect[ "firelp_small_pm" ]													= LoadFX( "fire/firelp_small_pm" );
	level._effect[ "fire_line_sm" ]															= LoadFX( "fire/fire_line_sm" );
	level._effect[ "fire_ceiling_md_slow" ]													= LoadFX( "fire/fire_ceiling_md_slow" );
	level._effect[ "firelp_med_pm_nolight_atlas" ]							= LoadFX( "fire/fire_med_pm_nolight_atlas" );
	level._effect["fire_embers_directional_slow"]								= loadfx ("fire/fire_embers_directional_slow");	
	level._effect[ "dust_wind_slow_paper_narrow" ]							= loadfx( "dust/dust_wind_slow_paper_narrow" );
	level._effect["cloud_ash_lite_nyHarbor"]										= loadfx ("weather/cloud_ash_lite_nyHarbor");
	level._effect[ "trash_spiral_runner" ]											= loadfx( "misc/trash_spiral_runner" );
 	level._effect[ "insects_carcass_flies" ]										= loadfx( "misc/insects_carcass_flies" );
	level._effect[ "embers_burst_runner_longlife" ]							= loadfx( "fire/embers_burst_runner_longlife");
 	level._effect[ "steam_vent_small" ]													= loadfx( "smoke/steam_vent_small" );
	level._effect[ "powerline_runner_sound"]										= loadfx ("explosions/powerline_runner_sound");	
	level._effect["falling_dirt_light"]													= loadfx ("dust/falling_dirt_light");	
	level._effect["lights_conelight_smokey"]											= loadfx("lights/lights_conelight_smokey");
	level._effect["lights_godray_default"]												= loadfx("lights/lights_conelight_default");
	level._effect["window_explosion"]														= loadfx ("explosions/window_explosion");	
	level._effect["fire_falling_localized_runner"]								= loadfx ("fire/fire_falling_localized_runner");	
	level._effect["ceiling_smoke_generic"]												= loadfx ("smoke/ceiling_smoke_generic");	
	level._effect[ "thick_dark_smoke_giant_paris" ]									= loadfx( "smoke/thick_dark_smoke_giant_paris" );
	level._effect[ "thick_dark_smoke_giant_paris_oneshot" ]									= loadfx( "smoke/thick_dark_smoke_giant_paris" );
	level._effect[ "leaves_runner_1" ]												= loadfx( "misc/leaves_runner_1" );
	level._effect[ "smoke_column_skybox_paris" ]													= loadfx ("maps/paris/smoke_column_skybox_paris");	
	level._effect[ "smoke_column_skybox_paris_oneshot" ]													= loadfx ("maps/paris/smoke_column_skybox_paris");	
	level._effect[ "skybox_mig29_flyby" ]												= loadfx( "misc/skybox_mig29_flyby" );
	level._effect[ "skybox_hind_flyby_loop" ]												= loadfx( "misc/skybox_hind_flyby" );


	
	/*===========================
	rooftop vfx
	===========================*/
	level._effect[ "smoke_column_intro_paris_a" ]									= loadfx( "maps/paris/smoke_column_intro_paris_a" );
	level._effect[ "smoke_column_intro_paris_blowaway" ]									= loadfx( "maps/paris/smoke_column_intro_paris_blowaway" );
	/*===========================
	catacomb sewage vfx
	===========================*/
	//enemy flashligt
	level._effect[ "flashlight_ai" ]												= loadfx( "misc/flashlight" );
	
	//ally flashlight (spotlight)
	level._effect["flashlight"] 														= loadfx( "misc/flashlight_spotlight_paris" );
	level._effect["flashlight_bounce"] 											= loadfx( "misc/flashlight_pointlight_paris" );
	
	//Bomb hits dust falling and pipe steam in catacomb
	level._effect["falling_dirt_catacomb"]									= loadfx ("dust/falling_dirt_light");	
	level._effect["pipe_steam"]															= loadfx ("impacts/pipe_steam");
	
	//flare
	level._effect[ "flare_catacombs" ]			 								= loadfx( "misc/flare_ambient_paris" );
	
	//door kick dust
	level._effect[ "door_kick" ]			 											= loadfx( "dust/door_kick" );
	level._effect[ "falling_dirt_groundspawn" ]			 				= loadfx( "dust/falling_dirt_groundspawn" );
	
	//all water elements	
	level._effect[ "water_noise" ]														= loadfx( "weather/water_noise" );
	level._effect[ "water_drips_fat_fast_speed" ]							= loadfx( "water/water_drips_fat_fast_speed" );
	level._effect[ "water_drips_fat_slow_speed" ]							= loadfx( "water/water_drips_fat_slow_speed" );
	level._effect[ "drips_fast" ]			 												= loadfx( "misc/drips_fast" );
	level._effect[ "drips_slow" ]			 												= loadfx( "misc/drips_slow" );
	level._effect[ "drips_splash_tiny" ]			 								= loadfx( "water/drips_splash_tiny" );
	level._effect[ "mist_drifting_catacomb" ]			 						= loadfx( "smoke/mist_drifting_catacomb" );
	level._effect[ "waterfall_drainage_splash_dcemp" ]				= loadfx( "water/waterfall_drainage_splash_dcemp" );
	level._effect[ "falling_water_trickle_infrequent" ]				= loadfx( "water/falling_water_trickle_infrequent" );
	level._effect[ "water_pipe_spray" ]												= loadfx( "water/water_pipe_spray" );
	level._effect[ "powerline_runner_sewer_paris"]						= loadfx ("maps/paris/powerline_runner_sewer_paris");	
	level._effect[ "water_flow_sewage_catacomb" ]						= loadfx( "water/water_flow_sewage_catacomb" );
	level._effect[ "waterfall_splash_large" ]								= loadfx( "water/waterfall_splash_large" );
	level._effect[ "waterfall_drainage_splash_falling" ]		= loadfx( "water/waterfall_drainage_splash_falling" );
	level._effect[ "waterfall_splash_large_drops" ]					= loadfx( "water/waterfall_splash_large_drops" );
	level._effect[ "waterfall_splash_falling_mist" ]				= loadfx( "water/waterfall_splash_falling_mist" );
	level._effect[ "waterfall_splash_medium" ]							= loadfx( "water/waterfall_splash_medium" );
	level._effect[ "waterfall_drainage_distortion" ]				= loadfx( "water/waterfall_drainage_distortion" );
	level._effect[ "waterfall_mist" ]			 									= loadfx( "water/waterfall_mist" );
	level._effect[ "waterfall_drainage_short_dcemp" ]				= loadfx( "water/waterfall_drainage_short_dcemp" );

	
	//ambient vfx in catacomb
	level._effect[ "ground_dust_narrow_light" ]			 											= loadfx( "dust/ground_dust_narrow_light" );
	level._effect[ "fog_ground_200_light_lit" ]			 											= loadfx( "smoke/fog_ground_200_light_lit" );
	level._effect[ "smoke_warm_room_linger_s" ]			 											= loadfx( "smoke/smoke_warm_room_linger_s" );
	
	//tank crush moment
	level._vehicle_effect[ "tankcrush" ][ "window_med" ]	 = loadfx( "props/car_glass_med" );
	level._vehicle_effect[ "tankcrush" ][ "window_large" ]	 = loadfx( "props/car_glass_large" );

	//other vehicle fx
	level._effect[ "littlebird_exhaust" ]	 = loadfx( "distortion/littlebird_exhaust" );
	
	level._effect[ "scripted_flashbang" ]		= loadfx( "explosions/flashbang" );


}


kill_oneshot_smk_cols()
{
	wait(.1);
	kill_oneshot("thick_dark_smoke_giant_paris_oneshot");
	kill_oneshot("fire_eiffel_tower_oneshot");
	kill_oneshot("smoke_column_skybox_paris_oneshot");
	
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
				//aud_send_msg("msg_audio_fx_ambientExp", final_exp_pos[curr_exp_num]);
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
		level.bombshake_interval = 15;//was at 20
		level.bombshake_interval_rand = 7;//was at 5
	}
	wait(15.0);//Make sure the fade in completes before it starts
	flag_init("enable_distant_bombShakes");
	flag_set("enable_distant_bombShakes");//temp until audio does the real thing
	for(;;)
	{
		flag_waitopen("msg_fx_zone6000");
		flag_waitopen("msg_fx_zone6100");
		flag_waitopen("msg_fx_zone6200");
		flag_waitopen("msg_fx_zone6300");
		flag_waitopen("msg_fx_zone6400");
		flag_waitopen("msg_fx_zone6500");
		flag_waitopen("msg_fx_in_bookstore");
		flag_wait( "player_rooftop_jump_complete" ); //don't go off until player is out of little bird
		flag_wait("enable_distant_bombShakes");	// Wait until this system is enabled manually.
		if (flag("enable_distant_bombShakes")) // Still have to check. (e.g., entering_hind could be set while waiting on "enable_distant_bombShakes").
		{
			offsetDist = 1008;//look up 10 ft
			to1.origin = self.player getorigin();
			trace = BulletTrace( (self.player.origin+(0,0,12)), self.player.origin+(0,0,1200), false, undefined);
			hitDist = distance(to1.origin,trace["position"]);
			if(hitDist<200)
			{
				//Send the message to audio
				aud_send_msg("msg_audio_fx_bombshake");
				fx_bombShakes("falling_dirt_light","viewmodel_medium",.127,2,.3,.53);
			}
		}
		
		randomInc = randomfloatrange((level.bombshake_interval_rand * -1),level.bombshake_interval_rand)+level.bombshake_interval;
		wait(randomInc);
	}	
}

start_ambient_flak()
{
	level waitframe();
	flag_wait( "game_fx_started" );
	wait(5.0);
	exploder(10001);
}

catacombs_enemy_gate_gag_vfx()
{
	flag_wait("flag_catacombs_enemy_gate_gag_vfx");
	wait(0.45);
	exploder(6210);
}

loop_skybox_hinds()
{
	wait(0.2);
	exploder(999);
	for(;;)
	{
		//ambient sky fx are using zone 1100
		flag_wait("msg_fx_zone1100");
		wait(12.0);
		//the looping hindfx are on exploder 999
		exploder(999);
	}
}


