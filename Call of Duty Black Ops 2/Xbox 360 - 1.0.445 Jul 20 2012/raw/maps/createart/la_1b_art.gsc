//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
	
	VisionSetNaked( "sp_la1_2", 5 );
	

	
//////rimlighting////////
  r_rimIntensity_debug = GetDvar( "r_rimIntensity_debug" );
  SetSavedDvar( "r_rimIntensity_debug", 1 );
    
  r_rimIntensity = GetDvar( "r_rimIntensity" );
  SetSavedDvar( "r_rimIntensity", 15 );

}

// from notetrack "dof steering_wheel"
cougar_exit_dof1( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 30;
	const n_far_start = 31;
	const n_far_end = 7000;
	const n_near_blur = 6;
	const n_far_blur = 1.8;
	const n_time = .2;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );

	SetSavedDvar( "r_lightTweakSunDirection", (-45, 78, 0) ); 
}


// from notetrack "dof harper"
cougar_exit_dof2( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 30;
	const n_far_start = 31;
	const n_far_end = 250;
	const n_near_blur = 6;
	const n_far_blur = 1.8;
	const n_time = .2;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}


// from notetrack "dof hatch"
cougar_exit_dof3( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 5;
	const n_far_start = 31;
	const n_far_end = 500;
	const n_near_blur = 6;
	const n_far_blur = 1.8;
	const n_time = .2;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	SetSavedDvar( "r_lightTweakSunDirection", (-45, 53, 0) );
}

// from notetrack "dof f35"
cougar_exit_dof4( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 30;
	const n_far_start = 31;
	const n_far_end = 7000;
	const n_near_blur = 6;
	const n_far_blur = 1.8;
	const n_time = 1.0;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

// from notetrack "dof convoy"
cougar_exit_dof5( m_player_body )
{
	const n_near_start = 0;
	const n_near_end = 30;
	const n_far_start = 31;
	const n_far_end = 15000;
	const n_near_blur = 6;
	const n_far_blur = 1.8;
	const n_time = 1.0;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

// from notetrack "dof claw"
cougar_exit_dof6( m_player_body )
{
	
	const n_near_start = 10;
	const n_near_end = 60;
	const n_far_start = 1000;
	const n_far_end = 7000;
	const n_near_blur = 0.1;
	const n_far_blur = 0.1;
	const n_time = .2;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	level.player thread depth_of_field_off( .01 );
}
