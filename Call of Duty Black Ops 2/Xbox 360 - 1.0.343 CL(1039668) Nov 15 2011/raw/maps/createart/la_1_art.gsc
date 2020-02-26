//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

#define SKYBOX_TRANS_TIME 5

main()
{
	flag_wait( "level.player" );
	
	level.tweakfile = true;
	
	level thread swap_vista();

	//////////HERO LIGHTING FOR INTRO RIDE////////////////
	r_lightGridEnableTweaks = GetDvar( "r_lightGridEnableTweaks" );
	r_lightGridIntensity = GetDvar( "r_lightGridIntensity" );
	r_lightGridContrast = GetDvar( "r_lightGridContrast" );

	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
    SetSavedDvar( "r_lightGridIntensity", .75 );
    SetSavedDvar( "r_lightGridContrast", 0);
 
 
 ///////tweaking sun direction for intro ride   
    r_lightTweakSunDirection = GetDvar( "r_lightTweakSunDirection" );
    SetSavedDvar( "r_lightTweakSunDirection", (-20, 53, 0) );
	
	VisionSetNaked( "la_1_intro", 5 );

	start_dist = 540.631;
  half_dist = 4971.18;
  half_height = 522.493;
  base_height = 745.287;
  fog_r = 0.290196;
  fog_g = 0.317647;
  fog_b = 0.333333;
  fog_scale = 12.1452;
  sun_col_r = 0.764706;
  sun_col_g = 0.301961;
  sun_col_b = 0;
  sun_dir_x = 0.479594;
  sun_dir_y = 0.713709;
  sun_dir_z = 0.510498;
  sun_start_ang = 0;
  sun_stop_ang = 60.5184;
  time = 0;
  max_fog_opacity = 0.729652;


	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	////////// For after the Cougar exit//////////////
		
	flag_wait( "intro_done" );	

	start_dist = 540.631;
  half_dist = 4971.18;
  half_height = 522.493;
  base_height = 745.287;
  fog_r = 0.290196;
  fog_g = 0.317647;
  fog_b = 0.333333;
  fog_scale = 12.1452;
  sun_col_r = 0.764706;
  sun_col_g = 0.301961;
  sun_col_b = 0;
  sun_dir_x = 0.479594;
  sun_dir_y = 0.713709;
  sun_dir_z = 0.510498;
  sun_start_ang = 0;
  sun_stop_ang = 60.5184;
  time = 0;
  max_fog_opacity = 0.729652;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "la_1", 5 );
		
	SetSavedDvar( "r_lightGridEnableTweaks", r_lightGridEnableTweaks );
	SetSavedDvar( "r_lightGridIntensity", r_lightGridIntensity );
	SetSavedDvar( "r_lightGridContrast", r_lightGridContrast );
	
	/////restoring sun direction after intro ride is complete/////
	SetSavedDvar( "r_lightTweakSunDirection", r_lightTweakSunDirection );

	flag_wait( "done_rappelling" );

	start_dist = 540.631;
  half_dist = 4971.18;
	half_height = 522.493;
	base_height = 0;
	fog_r = 0.290196;
  fog_g = 0.317647;
  fog_b = 0.333333;
  fog_scale = 16.1452;
  sun_col_r = 0.764706;
  sun_col_g = 0.301961;
  sun_col_b = 0;
  sun_dir_x = 0.479594;
  sun_dir_y = 0.713709;
  sun_dir_z = 0.510498;
  sun_start_ang = 0;
  sun_stop_ang = 60.5184;
  time = 0;
  max_fog_opacity = 0.729652;

	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "la_1_after_rope", 5 );
	
	flag_wait( "player_in_cougar" );
	
	start_dist = 540.631;
  half_dist = 4971.18;
	half_height = 522.493;
	base_height = 0;
	fog_r = 0.290196;
  fog_g = 0.317647;
  fog_b = 0.333333;
  fog_scale = 12.1452;
  sun_col_r = 0.764706;
  sun_col_g = 0.301961;
  sun_col_b = 0;
  sun_dir_x = 0.479594;
  sun_dir_y = 0.713709;
  sun_dir_z = 0.510498;
  sun_start_ang = 0;
  sun_stop_ang = 60.5184;
  time = 0;
  max_fog_opacity = 0.729652;

	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
		// sun sample size
	n_sun_sample_size = 1.0;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
	
	flag_wait( "la_1_sky_transition" );
	
	
	VisionSetNaked( "la1_2", 5 );
	
	//fog settings to blend into when skybox changes (driving section)
	start_dist = 407.599;
	half_dist = 6863.42;
	half_height = 2000.28;
	base_height = 118.875;
	fog_r = 0.42;
	fog_g = 0.5;
	fog_b = 0.5;
	fog_scale = 17.3861;
	sun_col_r = 1;
	sun_col_g = .5;
	sun_col_b = .12;
	sun_dir_x = 0.476913;
	sun_dir_y = 0.645584;
	sun_dir_z = 0.596469;
	sun_start_ang = 0;
	sun_stop_ang = 68.812;
	time = 0;
	max_fog_opacity = 1;

	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
	v_sun_color = ( 1, .74, 0.47 );  // ( R, G, B )

	SetSunLight( v_sun_color[ 0 ], v_sun_color[ 1 ], v_sun_color[ 2 ] );
	
	SetSavedDvar( "sm_sunSampleSizeNear", 0.5 );
	
	level thread swap_skybox_over_time( SKYBOX_TRANS_TIME );
	
	flag_wait( "entering_arena" );
	
	VisionSetNaked( "la1_staple_center", 5 );

	start_dist = 407.599;
	half_dist = 6863.42;
	half_height = 2000.28;
	base_height = 118.875;
	fog_r = 0.42;
	fog_g = 0.5;
	fog_b = 0.5;
	fog_scale = 13.3861;
	sun_col_r = 0.917647;
	sun_col_g = 0.733333;
	sun_col_b = 0.423529;
	sun_dir_x = 0.476913;
	sun_dir_y = 0.645584;
	sun_dir_z = 0.596469;
	sun_start_ang = 0;
	sun_stop_ang = 68.812;
	time = 0;
	max_fog_opacity = 1;
	
	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	flag_wait( "exiting_arena" );
	
	VisionSetNaked( "la1_2", 5 );
	
	//fog settings to blend into when skybox changes (driving section)
	start_dist = 407.599;
	half_dist = 6863.42;
	half_height = 2000.28;
	base_height = 118.875;
	fog_r = 0.42;
	fog_g = 0.5;
	fog_b = 0.5;
	fog_scale = 13.3861;
	sun_col_r = 0.917647;
	sun_col_g = 0.733333;
	sun_col_b = 0.423529;
	sun_dir_x = 0.476913;
	sun_dir_y = 0.645584;
	sun_dir_z = 0.596469;
	sun_start_ang = 0;
	sun_stop_ang = 68.812;
	time = 0;
	max_fog_opacity = 1;

	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

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

swap_vista()
{
	GetEnt( "downtown_skyline_2", "targetname" ) Hide();
	
	flag_wait( "la_1_vista_swap" );
	
	GetEnt( "downtown_skyline_1", "targetname" ) Hide();
	GetEnt( "downtown_skyline_2", "targetname" ) Show();
}

//
// Depth of Field notetrack functions
//

mount_turret_dof1( m_player_body )
{
	n_near_start = 0;
	n_near_end = 16;
	n_far_start = 16;
	n_far_end = 600;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = 1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

mount_turret_dof2( m_player_body )
{
	n_near_start = 0;
	n_near_end = 16;
	n_far_start = 16;
	n_far_end = 1500;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = 1;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

mount_turret_dof3( m_player_body )
{
	n_near_start = 0;
	n_near_end = 16;
	n_far_start = 16;
	n_far_end = 600;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = 1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

mount_turret_dof4( m_player_body )
{
	n_near_start = 0;
	n_near_end = 16;
	n_far_start = 16;
	n_far_end = 600;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = 1;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

mount_turret_dof5( m_player_body )
{
	n_near_start = 0;
	n_near_end = 0;
	n_far_start = 0;
	n_far_end = 0;
	n_near_blur = 0;
	n_far_blur = 0;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

cougar_fall_dof1( m_player_body )
{
	n_near_start = 0;
	n_near_end = 5;
	n_far_start = 16;
	n_far_end = 1000;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

cougar_fall_dof2( m_player_body )
{
	n_near_start = 0;
	n_near_end = 5;
	n_far_start = 2000;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 0;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

cougar_fall_dof3( m_player_body )
{
	n_near_start = 0;
	n_near_end = 5;
	n_far_start = 2000;
	n_far_end = 20000;
	n_near_blur = 4;
	n_far_blur = 0;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

cougar_fall_dof4( m_player_body )
{
	n_near_start = 0;
	n_near_end = 0;
	n_far_start = 0;
	n_far_end = 0;
	n_near_blur = 0;
	n_far_blur = 0;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}
