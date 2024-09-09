main()
{
	
	//ambient
	level._effect[ "Flocking_birds_mp" ]										           = loadfx( "misc/Flocking_birds_mp" );
	level._effect[ "Room_dust_200_blend_dam" ]										     = loadfx( "maps/mp_dam/Room_dust_200_blend_dam" );
	level._effect[ "generator_heat_dam" ]										           = loadfx( "maps/mp_dam/generator_heat_dam" );
	level._effect[ "generator_spark_mp_dam" ]				                   = loadfx( "maps/mp_dam/spark_fall_runner_mp_dam" );
	level._effect[ "battlefield_smokebank_S_dam" ]					           = loadfx( "maps/mp_dam/battlefield_smokebank_S_dam" );
	level._effect[ "hallway_smoke" ]							                     = loadfx( "smoke/hallway_smoke_light" );
	level._effect[ "steam_manhole" ] 		                               = loadfx( "smoke/steam_manhole" );
	level._effect[ "leaves_ground_gentlewind" ] 		                   = loadfx( "misc/leaves_ground_gentlewind" );
	level._effect[ "sand_spray_detail_oriented_runner_mp_dome" ]		   = loadfx( "dust/sand_spray_detail_oriented_runner_mp_dome" );
	level._effect[ "dust_wind_slow_paper" ]						                 = loadfx( "dust/dust_wind_slow_paper" );
	level._effect[ "trash_spiral_runner" ]						                 = loadfx( "misc/trash_spiral_runner_cheap" );
	level._effect[ "ground_fog_mp_dam" ] 		      				             = loadfx( "maps/mp_dam/ground_fog_mp_dam" );
	level._effect[ "falling_dirt_frequent_runner" ] 								   = loadfx( "dust/falling_dirt_frequent_runner" );
	level._effect[ "dust_wind_fast_no_paper" ] 								         = loadfx( "maps/mp_dam/wind_fast_dam" );
	
	//lighting
	level._effect[ "Lights_conelight_smokey" ]										     = loadfx( "lights/Lights_conelight_smokey" );
	level._effect[ "Lights_conelight_smokey_warm_dam" ]							   = loadfx( "maps/mp_dam/Lights_conelight_smokey_warm_dam" );
	level._effect[ "lights_uplight_haze_dam" ]							   = loadfx( "maps/mp_dam/lights_uplight_haze_dam" );
	level._effect[ "Lights_godray_beam_dam" ]							   = loadfx( "maps/mp_dam/Lights_godray_beam_dam" );
	level._effect[ "Lights_godray_beam" ]										           = loadfx( "lights/Lights_godray_beam" );
	level._effect[ "Light_glow_white" ]										             = loadfx( "misc/Light_glow_white" );
	level._effect[ "Light_shaft_dust_large_mp_vacant" ]								 = loadfx( "dust/Light_shaft_dust_large_mp_vacant" );
	
	//water
	level._effect[ "Sea_mist_dam" ]										                 = loadfx( "maps/mp_dam/Sea_mist_dam" );
	level._effect[ "rainbow_dam" ]										                 = loadfx( "maps/mp_dam/rainbow_dam" );
	level._effect[ "water_release_dam" ]										           = loadfx( "maps/mp_dam/water_release_dam" );
	level._effect[ "Mist_sea_dam" ]										                 = loadfx( "maps/mp_dam/Mist_sea_dam" );
	level._effect[ "Seatown_pillar_mist" ]										         = loadfx( "water/Seatown_pillar_mist" );
	level._effect[ "Seatown_pillar_mist_yellow" ]										   = loadfx( "maps/mp_dam/Seatown_pillar_mist_yellow" );
	level._effect[ "Seatown_lookout_splash_runner" ]									 = loadfx( "water/Seatown_lookout_splash_runner" );
	level._effect[ "water_drips_hallway_nocull" ]										   = loadfx( "maps/mp_dam/water_drips_hallway_nocull" );
	level._effect[ "mist_distant_drifting_dam" ]										   = loadfx( "maps/mp_dam/mist_distant_drifting_dam" );
	level._effect[ "water_pipe_spray_dam" ]										         = loadfx( "maps/mp_dam/water_pipe_spray_dam" );
	level._effect[ "water_pipe_spray_impact_dam" ]									   = loadfx( "maps/mp_dam/water_pipe_spray_impact_dam" );
	
	//explosion for gas tank
	level._effect[ "gas_pump_exp" ]				                         = loadfx( "explosions/gas_pump_exp" );
		
/#
    if ( getdvar( "clientSideEffects" ) != "1" )
        maps\createfx\mp_dam_fx::main();
#/

}
