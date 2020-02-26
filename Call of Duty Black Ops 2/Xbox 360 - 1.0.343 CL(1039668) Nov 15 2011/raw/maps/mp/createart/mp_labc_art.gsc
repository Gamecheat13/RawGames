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

	SetDvar("visionstore_glowTweakEnable", "0");
	SetDvar("visionstore_glowTweakRadius0", "5");
	SetDvar("visionstore_glowTweakRadius1", "");
	SetDvar("visionstore_glowTweakBloomCutoff", "0.5");
	SetDvar("visionstore_glowTweakBloomDesaturation", "0");
	SetDvar("visionstore_glowTweakBloomIntensity0", "1");
	SetDvar("visionstore_glowTweakBloomIntensity1", "");
	SetDvar("visionstore_glowTweakSkyBleedIntensity0", "");
	SetDvar("visionstore_glowTweakSkyBleedIntensity1", "");
	
	start_dist = 544.062;
	half_dist = 7935.43;
	half_height = 361.3;
	base_height = -11.2713;
	fog_r = 0.658824;
	fog_g = 0.796079;
	fog_b = 0.882353;
	fog_scale = 17.6089;
	sun_col_r = 1;
	sun_col_g = 1;
	sun_col_b = 1;
	sun_dir_x = -0.444827;
	sun_dir_y = -0.562505;
	sun_dir_z = 0.696934;
	sun_start_ang = 0;
	sun_stop_ang = 46.3942;
	time = 0;
	max_fog_opacity = 0.627205;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "mp_labc", 0 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.33 );
	SetDvar( "r_lightGridContrast", 0.21 );
}

