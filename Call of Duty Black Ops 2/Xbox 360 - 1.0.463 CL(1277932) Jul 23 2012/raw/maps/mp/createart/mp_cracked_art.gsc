//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* Fog section * 

	SetDvar("scr_fog_exp_halfplane", "3759.28");
	SetDvar("scr_fog_exp_halfheight", "243.735");
	SetDvar("scr_fog_nearplane", "601.593");
	SetDvar("scr_fog_red", "0.806694");
	SetDvar("scr_fog_green", "0.962521");
	SetDvar("scr_fog_blue", "0.9624");
	SetDvar("scr_fog_baseheight", "-475.268");
	
	start_dist = 580;
	half_dist = 2068.48;
	half_height = 812.351;
	base_height = -249.492;
	fog_r = 0.189412;
	fog_g = 0.212941;
	fog_b = 0.244314;
	fog_scale = 7.94307;
	sun_col_r = 0.627451;
	sun_col_g = 0.866667;
	sun_col_b = 1;
	sun_dir_x = -0.511266;
	sun_dir_y = -0.348825;
	sun_dir_z = 0.785447;
	sun_start_ang = 13.9519;
	sun_stop_ang = 99.6917;
	time = 0;
	max_fog_opacity = 0.98;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	VisionSetNaked( "mp_cracked", 0 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.4 );
	SetDvar( "r_lightGridContrast", .2 );
}
