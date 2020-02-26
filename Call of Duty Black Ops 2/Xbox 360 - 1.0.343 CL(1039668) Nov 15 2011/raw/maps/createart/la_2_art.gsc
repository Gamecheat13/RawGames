//_createart generated.  modify at your own risk. Changing values should be fine.
main( n_fog_blend_time )
{
	b_blend_exposure = false;
	
	//fog settings to blend into when take-off is done
	
//Original
//
//  start_dist = 2955;
//	half_dist = 6531.92;
//	half_height = 3785.18;
//	base_height = 3302.09;
//	fog_r = 0.333333;
//	fog_g = 0.337255;
//	fog_b = 0.333333;
//	fog_scale = 10.9071;
//	sun_col_r = 1;
//	sun_col_g = 0.643137;
//	sun_col_b = 0.368627;
//	sun_dir_x = 0.485288;
//	sun_dir_y = 0.120969;
//	sun_dir_z = 0.865946;
//	sun_start_ang = 0;
//	sun_stop_ang = 132.48;
//	time = 0;
//	max_fog_opacity = 1;

//new new bloom, for generic situation both low and high
	start_dist = 4363.91;
	half_dist = 10734.8;
	half_height = 4198.56;
	base_height = 1085.55;
	fog_r = 0.01937255;
	fog_g = 0.0191961;
	fog_b = 0.0225098;
	fog_scale = 32;
	sun_col_r = 1;
	sun_col_g = 0.545098;
	sun_col_b = 0.196078;
	sun_dir_x = 0.40095;
	sun_dir_y = 0.591264;
	sun_dir_z = 0.699747;
	sun_start_ang = 0;
	sun_stop_ang = 58.2143;
	time = 0;
	max_fog_opacity = 1;

	if ( IsDefined( n_fog_blend_time ) )
	{
		time = n_fog_blend_time;
		b_blend_exposure = true;
	}
	
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);		
	
	// final exposure setting
	//n_exposure = 0.65;	
	n_exposure = 3.32;	
	
	if ( b_blend_exposure )
	{
		level thread blend_exposure_over_time( n_exposure, n_fog_blend_time );
	}
	else 
	{
		// exposure setting
		SetDvar( "r_exposureTweak", 1 );
		SetDvar( "r_exposureValue", n_exposure );
	}
	
	// sun sample size
	n_sun_sample_size = 0.25;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  
	
	// sun color
	//ResetSunLight();
	v_sun_color = ( 0.96, 0.77, 0.47 );  // ( R, G, B )
	SetSunLight( v_sun_color[ 0 ], v_sun_color[ 1 ], v_sun_color[ 2 ] );
}

art_jet_mode_settings()
{
	//For High fog
	
	start_dist = 4363.91;
	half_dist = 10734.8;
	half_height = 4198.56;
	base_height = 1085.55;
	fog_r = .019;
	fog_g = 0.019;
	fog_b = 0.02;
	fog_scale = 32;
	sun_col_r = 1;
	sun_col_g = 0.545098;
	sun_col_b = 0.196078;
	sun_dir_x = 0.40095;
	sun_dir_y = 0.591264;
	sun_dir_z = 0.699747;
	sun_start_ang = 0;
	sun_stop_ang = 58.2143;
	time = 0;
	max_fog_opacity = 1;
	
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);			
	
	// sun sample size
	n_sun_sample_size = 0.25;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
}

art_vtol_mode_settings()
{
// For low fog settings

	start_dist = 4363.91;
	half_dist = 10734.8;
	half_height = 4198.56;
	base_height = 1085.55;
	fog_r = .019;
	fog_g = 0.019;
	fog_b = 0.02;
	fog_scale = 32;
	sun_col_r = 1;
	sun_col_g = 0.545098;
	sun_col_b = 0.196078;
	sun_dir_x = 0.40095;
	sun_dir_y = 0.591264;
	sun_dir_z = 0.699747;
	sun_start_ang = 0;
	sun_stop_ang = 58.2143;
	time = 0;
	max_fog_opacity = 1;
	
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);	

	// sun sample size
	n_sun_sample_size = 2.0;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
}

blend_exposure_over_time( n_exposure_final, n_time )
{
	n_frames = Int( n_time * 20 );
	
	n_exposure_current = GetDvarFloat( "r_exposureValue" );
	n_exposure_change_total = n_exposure_final - n_exposure_current;
	n_exposure_change_per_frame = n_exposure_change_total / n_frames;
	
	SetDvar( "r_exposureTweak", 1 );
	for ( i = 0; i < n_frames; i++ )
	{
		SetDvar( "r_exposureValue", n_exposure_current + ( n_exposure_change_per_frame * i ) );
		wait 0.05;
	}
	
	SetDvar( "r_exposureValue", n_exposure_final );
}

// this is setting for pre-takeoff fog
fog_intro()
{

//Original
//
//	start_dist = 90;
//	half_dist = 1524.2;
//	half_height = 7760.84;
//	base_height = 0;
//	fog_r = 0.2;
//	fog_g = 0.168627;
//	fog_b = 0.121569;
//	fog_scale = 32;
//	sun_col_r = 0.682353;
//	sun_col_g = 0.466667;
//	sun_col_b = 0.254902;
//	sun_dir_x = 0.29;
//	sun_dir_y = 0.62;
//	sun_dir_z = 0.73;
//	sun_start_ang = 0;
//	sun_stop_ang = 84.5729;
//	time = 0; 
//	max_fog_opacity = 1;
	
	start_dist = 90;
	half_dist = 836.645;
	half_height = 2320.93;
	base_height = 0;
	fog_r = 0.219608;
	fog_g = 0.231373;
	fog_b = 0.207843;
	fog_scale = 18.7513;
	sun_col_r = 0.788235;
	sun_col_g = 0.525;
	sun_col_b = 0.255;
	sun_dir_x = 0.29;
	sun_dir_y = 0.62;
	sun_dir_z = 0.73;
	sun_start_ang = 13.5559;
	sun_stop_ang = 65;
	time = 0;
	max_fog_opacity = 0.86;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	// exposure setting
	n_exposure = 4.15;
	level.player SetClientDvars( "r_exposureTweak", 1, "r_exposureValue", n_exposure );
	
	// sun sample size
	n_sun_sample_size = 2.0;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
	
	//sun color
	//v_sun_color = ( 0.91, 0.69, 0.47 );  // ( R, G, B )
	v_sun_color = ( 0.96, 0.8, 0.554 );  // ( R, G, B )

	SetSunLight( v_sun_color[ 0 ], v_sun_color[ 1 ], v_sun_color[ 2 ] );
	
	// vision set
	level.player VisionSetNaked( "la_2_start", 0 );  // immediately transition from intro
}