//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;

#define SKYBOX_TRANS_TIME 5

main()
{
	flag_wait( "level.player" );
	
	level.tweakfile = true;
	
	level thread swap_vista();

	//////////HERO LIGHTING FOR INTRO RIDE////////////////

	//////rimlighting////////
    r_rimIntensity_debug = GetDvar( "r_rimIntensity_debug" );
    SetSavedDvar( "r_rimIntensity_debug", 1 );
    
    r_rimIntensity = GetDvar( "r_rimIntensity" );
    SetSavedDvar( "r_rimIntensity", 8 );

    foreach ( m_godray in GetEntArray( "godrays", "targetname" ) )
	{
		m_godray Hide();
	}

	///////tweaking sun direction for intro ride///////////   
    level.map_default_sun_direction = GetDvar( "r_lightTweakSunDirection" );
    SetSavedDvar( "r_lightTweakSunDirection", (-12.9, 3.6, 0) );
	
	VisionSetNaked( "sp_la_1_intro_secretary", 2 );

	start_dist = 881.052;
	half_dist = 22455.7;
	half_height = 32711.9;
	base_height = 745;
	fog_r = 0.223;
	fog_g = 0.317;
	fog_b = 0.376;
	fog_scale = 27.9583;
	sun_col_r = 1;
	sun_col_g = 0.47451;
	sun_col_b = 0.180392;
	sun_dir_x = 0.479594;
	sun_dir_y = 0.713709;
	sun_dir_z = 0.510498;
	sun_start_ang = 0;
	sun_stop_ang = 45.6479;
	time = 0;
	max_fog_opacity = 0.459078;


	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	

	////////// For after the Cougar exit//////////////
		
	flag_wait( "intro_done" );	

	start_dist = 540.631;
	half_dist = 8471.2;
	half_height = 2372.87;
	base_height = 745.287;
	fog_r = 0.223;
	fog_g = 0.317;
	fog_b = 0.376;
	fog_scale = 12.1452;
	sun_col_r = 0.792157;
	sun_col_g = 0.298039;
	sun_col_b = 0;
	sun_dir_x = 0.479594;
	sun_dir_y = 0.713709;
	sun_dir_z = 0.510498;
	sun_start_ang = 0;
	sun_stop_ang = 48.6711;
	time = 0;
	max_fog_opacity = 0.729652;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "sp_la_1", 5 );
	
	
	
	
	/////restoring sun direction after intro ride is complete/////
	SetSavedDvar( "r_lightTweakSunDirection", level.map_default_sun_direction );
	
	flag_wait( "started_rappelling" );
	
	n_sun_sample_size = 0.25;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
	
	foreach ( m_godray in GetEntArray( "godrays", "targetname" ) )
    {
    	m_godray Show();
    }	
	
	flag_wait( "done_rappelling" );

	start_dist = 350.052;
	half_dist = 22455.7;
	half_height = 29711.9;
	base_height = 0;
	fog_r = 0.223;
	fog_g = 0.317;
	fog_b = 0.376;
	fog_scale = 22.9583;
	sun_col_r = 1;
	sun_col_g = 0.47451;
	sun_col_b = 0.180392;
	sun_dir_x = 0.479594;
	sun_dir_y = 0.713709;
	sun_dir_z = 0.510498;
	sun_start_ang = 0;
	sun_stop_ang = 64.6479;
	time = 0;
	max_fog_opacity = 0.459078;

	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "sp_la_1_after_rope", 5 );
	
	n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
	
	
	flag_wait( "player_in_cougar" );
	
	start_dist = 881.052;
	half_dist = 22455.7;
	half_height = 29711.9;
	base_height = 0;
	fog_r = 0.223;
	fog_g = 0.317;
	fog_b = 0.376;
	fog_scale = 22.9583;
	sun_col_r = 1;
	sun_col_g = 0.47451;
	sun_col_b = 0.180392;
	sun_dir_x = 0.479594;
	sun_dir_y = 0.713709;
	sun_dir_z = 0.510498;
	sun_start_ang = 0;
	sun_stop_ang = 64.6479;
	time = 0;
	max_fog_opacity = 0.459078;
	

	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
		// sun sample size
	n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
	

	
	flag_wait( "la_1_sky_transition" );

	VisionSetNaked( "sp_la1_2", 5 );
	
	//fog settings to blend into when skybox changes (driving section)
	start_dist = 732.714;
	half_dist = 3000;
	half_height = 702;
	base_height = 100;
	fog_r = 0.454;
	fog_g = 0.477;
	fog_b = 0.493;
	fog_scale = 10;
	sun_col_r = 1;
	sun_col_g = 0.702;
	sun_col_b = 0.417;
	sun_dir_x = 0.448634;
	sun_dir_y = 0.39779;
	sun_dir_z = 0.800307;
	sun_start_ang = 0;
	sun_stop_ang = 50;
	time = 0;
	max_fog_opacity = 0.801727;


	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
	v_sun_color = (0.847, 0.647, 0.455);  // ( R, G, B )

	SetSunLight( v_sun_color[ 0 ], v_sun_color[ 1 ], v_sun_color[ 2 ] );
	
	SetSavedDvar( "sm_sunSampleSizeNear", 0.5 );
	
	level thread swap_skybox_over_time( SKYBOX_TRANS_TIME );
}

swap_vista()
{
	a_skyline_2 = GetEntArray( "downtown_skyline_2", "targetname" );
	a_skyline_1 = GetEntArray( "downtown_skyline_1", "targetname" );
	
	foreach ( model in a_skyline_2 )
	{
		model Hide();
	}
	
	flag_wait( "la_1_vista_swap" );
	
	foreach ( model in a_skyline_1 )
	{
		model Hide();
	}
	
	foreach ( model in a_skyline_2 )
	{
		model Show();
	}
}

//
// Depth of Field notetrack functions
//

mount_turret_dof1( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 100;
	const n_near_blur = 6;
	const n_far_blur = 2;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
}

mount_turret_dof2( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 20;
	const n_far_start = 20;
	const n_far_end = 1000;
	const n_near_blur = 6;
	const n_far_blur = 2;
	const n_time = .2;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

mount_turret_dof3( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 2000;
	const n_near_blur = 6;
	const n_far_blur = 1;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

mount_turret_dof4( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 3600;
	const n_near_blur = 6;
	const n_far_blur = 1;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

mount_turret_dof5( m_player_body )
{
	level.player thread depth_of_field_off( .5 );
	/////restoring sun direction after intro ride is complete/////
	scene_wait( "sam_cougar_mount" );
}

cougar_fall_dof1( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 40;
	const n_far_start = 40;
	const n_far_end = 10000;
	const n_near_blur = 0;
	const n_far_blur = 0;
	const n_time = 1.5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

cougar_fall_dof2( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 40;
	const n_far_start = 40;
	const n_far_end = 10000;
	const n_near_blur = 0;
	const n_far_blur = 0;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

cougar_fall_dof3( m_player_body )
{
	level.player depth_of_field_off( .5 );
	SetSavedDvar( "sm_sunSampleSizeNear", 1.0 );
}



/////DOF INTRO RIDE/////



intro_player_dof1( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 40;
	const n_near_blur = 0;
	const n_far_blur = 2;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	SetSavedDvar( "sm_sunSampleSizeNear", 0.2 );
	SetSavedDvar( "r_flashLightSpecularScale", 50 );  
}

intro_player_dof2( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 0;
	const n_far_start = 0;
	const n_far_end = 10000;
	const n_near_blur = 0;
	const n_far_blur = 0;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	VisionSetNaked( "sp_la_1_intro", 3 );
}

intro_player_dof3( m_player_body )
{
  SetSavedDvar( "r_lightTweakSunDirection", (-45, 53, 0) );
	SetSavedDvar( "sm_sunSampleSizeNear", 0.5 );
	SetSavedDvar( "r_flashLightSpecularScale", 1 );  
	
	VisionSetNaked( "sp_la_1_intro_front_view", 2 );
	
	const start_dist = 881.052;
	const half_dist = 5455.7;
	const half_height = 8711.9;
	const base_height = 745;
	const fog_r = .180392;
	const fog_g = 0.25098;
	const fog_b = 0.298039;
	const fog_scale = 27.9583;
	const sun_col_r = 1;
	const sun_col_g = 0.47451;
	const sun_col_b = 0.180392;
	const sun_dir_x = 0.479594;
	const sun_dir_y = 0.713709;
	const sun_dir_z = 0.510498;
	const sun_start_ang = 0;
	const sun_stop_ang = 45.6479;
	const time = 0;
	const max_fog_opacity = 0.459078;
	
	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
	const n_near_start = 0;
	const n_near_end = 10;
	const n_far_start = 10;
	const n_far_end = 10000;
	const n_near_blur = 6;
	const n_far_blur = 1;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}


intro_player_dof4( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 20000;
	const n_near_blur = 6;
	const n_far_blur = 0;
	const n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	VisionSetNaked( "sp_la_1_intro", 1 );
	
}

intro_player_dof5( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 20000;
	const n_near_blur = 6;
	const n_far_blur = .5;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
    SetSavedDvar( "r_lightTweakSunDirection", (-8.9, -3.6, 0) );
	SetSavedDvar( "sm_sunSampleSizeNear", 0.2 );	
}

intro_player_dof6( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 75;
	const n_near_blur = 6;
	const n_far_blur = 2;
	const n_time = .25;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	
}

intro_player_dof7( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 10000;
	const n_near_blur = 6;
	const n_far_blur = 1;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

intro_player_dof8( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 75;
	const n_near_blur = 6;
	const n_far_blur = 2;
	const n_time = .25;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	level.orig_lightTweakSunLight = GetDvarFloat( "r_lightTweakSunLight" );
	lerp_dvar( "r_lightTweakSunLight", 16, 1, true );
}

intro_player_dof9( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 100;
	const n_near_blur = 6;
	const n_far_blur = 2;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );

	
}

intro_player_dof10( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 5;
	const n_far_end = 20000;
	const n_near_blur = 6;
	const n_far_blur = 1;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	//ramp sun back to original intensity over two seconds
	lerp_dvar( "r_lightTweakSunLight", level.orig_lightTweakSunLight, 2, true );
}

intro_player_dof11( m_player_body )
{
    SetSavedDvar( "r_lightTweakSunDirection", (-45, 53, 0) );
	SetSavedDvar( "sm_sunSampleSizeNear", 0.75 );
	
	level.player depth_of_field_off( .5 );
	
	VisionSetNaked( "sp_la_1_intro_front_view", 6 );
	
	const start_dist = 881.052;
	const half_dist = 22455.7;
	const half_height = 8711.9;
	const base_height = 745;
	const fog_r = .180392;
	const fog_g = 0.25098;
	const fog_b = 0.298039;
	const fog_scale = 27.9583;
	const sun_col_r = 1;
	const sun_col_g = 0.47451;
	const sun_col_b = 0.180392;
	const sun_dir_x = 0.479594;
	const sun_dir_y = 0.713709;
	const sun_dir_z = 0.510498;
	const sun_start_ang = 0;
	const sun_stop_ang = 45.6479;
	const time = 0;
	const max_fog_opacity = 0.459078;
	
	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
}

intro_player_dof12( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 80;
	const n_far_start = 80;
	const n_far_end = 20000;
	const n_near_blur = 6;
	const n_far_blur = 0;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
		
}

intro_player_dof13( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 80;
	const n_far_start = 80;
	const n_far_end = 20000;
	const n_near_blur = 6;
	const n_far_blur = 0;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
}

intro_player_dof14( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 80;
	const n_far_start = 80;
	const n_far_end = 20000;
	const n_near_blur = 6;
	const n_far_blur = 0;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

intro_player_dof15( m_player_body )
{
	level.player depth_of_field_off( .5 );
	
	n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
	VisionSetNaked( "sp_la_1_intro", 3 );
}

// TODO: doc
lerp_sun_direction( v_sun_direction_angles, n_time )
{
	if ( !IsDefined( n_time ) )
	{
		n_time = 0;
	}
	
	if ( n_time > 0 )
	{
		r_lightTweakSunDirection = GetDvar( "r_lightTweakSunDirection" );
		a_angle_strings = StrTok( r_lightTweakSunDirection, " " );	
		v_current_angles = ( Int( a_angle_strings[0] ), Int( a_angle_strings[1] ), Int( a_angle_strings[2] ) );
		
		t_delta = 0;
		while ( t_delta < n_time )
		{
			wait .05;
			t_delta += .05;
			
			v_angles_0 = AngleLerp( v_current_angles[0], v_sun_direction_angles[0], t_delta / n_time );
			v_angles_1 = AngleLerp( v_current_angles[1], v_sun_direction_angles[1], t_delta / n_time );
			v_angles_2 = AngleLerp( v_current_angles[2], v_sun_direction_angles[2], t_delta / n_time );
			SetSavedDvar( "r_lightTweakSunDirection", ( v_angles_0, v_angles_1, v_angles_2 ) );
		}
	}
	else
	{
		SetSavedDvar( "r_lightTweakSunDirection", v_sun_direction_angles );
	}
}

// TODO: doc
reset_sun_direction( n_time )
{
	lerp_sun_direction( level.map_default_sun_direction, n_time );
}

// TODO: doc
swap_skybox_over_time( n_time )
{
	// change skybox over time
	t_delta = 0;
	while ( t_delta < n_time )
	{
		wait .05;
		t_delta += .05;
		
		n_val = min( t_delta / n_time, .9 ); // cap sky transition at .9
		SetSavedDvar( "r_skyTransition", n_val );	
	}
}


	//DOF enter cougar looking at hands
	enter_cougar_hands(m_player_body)
	{
	const n_near_start = 0;
	const n_near_end = 25;
	const n_far_start = 1000;
	const n_far_end = 7000;
	const n_near_blur = 6;
	const n_far_blur = 1.8;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	}
	
	
	//DOF enter cougar looking at president
	enter_cougar_potus(m_player_body)
	{
	const n_near_start = 0;
	const n_near_end = 300;
	const n_far_start = 5000;
	const n_far_end = 20000;
	const n_near_blur = 4;
	const n_far_blur = 1.8;
	const n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	}
	
	//DOF enter cougar looking at wheel
	enter_cougar_wheel(m_player_body)
	{
	const n_near_start = 0;
	const n_near_end = 10;
	const n_far_start = 5000;
	const n_far_end = 20000;
	const n_near_blur = 4;
	const n_far_blur = .1;
	const n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait 1.0;
	
	level.player depth_of_field_off( 3 );
	}
	
	
///rappell section///


///rappell normal

	dof_hookup(m_player_body)
	{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 2000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
		
	n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	}
	
	dof_rappelers(m_player_body)
	{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 3500;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	

	}


dof_hands(m_player_body)
	{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 2000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	}


dof_rappelers2(m_player_body)
	{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 3500;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	}


dof_truck(m_player_body)
	{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 200;
	 n_far_end = 3500;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	}

dof_rappelers3(m_player_body)
	{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 200;
	 n_far_end = 2000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

dof_rappelers4(m_player_body)
	{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 400;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait 1.0;
	
	level.player depth_of_field_off( .01 );
}





///rappell sniper

dof_sr_first_rpg (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 200;
	 n_far_end = 8000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_first_explosion (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 200;
	 n_far_end = 8000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_hook_up (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 3;
	 n_far_end = 800;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_hands (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 200;
	 n_far_end = 8000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .25;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_second_rpg (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 200;
	 n_far_end = 8000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_second_explosion (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 30;
	 n_far_start = 200;
	 n_far_end = 3000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_debris_falling (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 60;
	 n_far_start = 200;
	 n_far_end = 3500;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_car (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 20;
	 n_far_start = 200;
	 n_far_end = 3500;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}


dof_sr_get_up_hand (m_player_body)
{
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 3;
	 n_far_end = 800;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait .5;
	
	 n_near_start = 1;
	 n_near_end = 2;
	 n_far_start = 200;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1;
	 n_time = .1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
	
	wait 0.25;
	
	level.player depth_of_field_off( .01 );
}