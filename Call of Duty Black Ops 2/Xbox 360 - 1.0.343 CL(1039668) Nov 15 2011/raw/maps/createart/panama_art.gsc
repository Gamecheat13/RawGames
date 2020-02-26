//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
 
	// *intro section*

	
	start_dist = 3180.1;
	half_dist = 9527.52;
	half_height = 868.821;
	base_height = 2065.85;
	fog_r = 0.25;
	fog_g = 0.38;
	fog_b = 0.48;
	fog_scale = 1.3;
	sun_col_r = 0.101961;
	sun_col_g = 0.12549;
	sun_col_b = 0.160784;
	sun_dir_x = -0.432069;
	sun_dir_y = 0.87512;
	sun_dir_z = 0.217905;
	sun_start_ang = 180;
	sun_stop_ang = 52.4976;
	time = 0;
	max_fog_opacity = 0.8;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
		VisionSetNaked( "panama_intro", 5 );

}

airfield()
{
 	start_dist = 149.621;
	half_dist = 4363.05;
	half_height = 1988.46;
	base_height = -76.5365;
	fog_r = 0.231373;
	fog_g = 0.305882;
	fog_b = 0.345098;
	fog_scale = 6.19522;
	sun_col_r = 0.658824;
	sun_col_g = 0.815686;
	sun_col_b = 0.870588;
	sun_dir_x = 0.439665;
	sun_dir_y = -0.641805;
	sun_dir_z = 0.628316;
	sun_start_ang = 0;
	sun_stop_ang = 81.4587;
	time = 0;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "panama_airstrip", 0.5 );
}

slums()
{
	start_dist = 249.941;
	half_dist = 3135.89;
	half_height = 649.088;
	base_height = 208.961;
	fog_r = 0.533333;
	fog_g = 0.54902;
	fog_b = 0.568627;
	fog_scale = 5.07503;
	sun_col_r = 1;
	sun_col_g = 0.807843;
	sun_col_b = 0.603922;
	sun_dir_x = 0.936237;
	sun_dir_y = 0.329528;
	sun_dir_z = 0.121952;
	sun_start_ang = 0;
	sun_stop_ang = 70.703;
	time = 0;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "panama_slums", 0.5 );
	
	SetSavedDvar( "r_skyTransition", 1 );
	
		// exposure setting
		SetDvar( "r_exposureTweak", 1 );
		SetDvar( "r_exposureValue", 2.5);
}

docks()
{
	start_dist = 0.0;
	half_dist = 2000.0;
	half_height = 500.0;
	base_height = 508.0;
	fog_r = 0.505882;
	fog_g = 0.592157;
	fog_b = 0.698039;
	fog_scale = 1;
	sun_col_r = 0.101961;
	sun_col_g = 0.12549;
	sun_col_b = 0.160784;
	sun_dir_x = -0.432069;
	sun_dir_y = 0.87512;
	sun_dir_z = 0.217905;
	sun_start_ang = 180;
	sun_stop_ang = 52.4976;
	time = 0;
	max_fog_opacity = 0.75;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "panama_docks", 0.5 );

	SetSavedDvar( "r_skyTransition", 0 );
	
	
		// exposure setting
		SetDvar( "r_exposureTweak", 0 );
}
