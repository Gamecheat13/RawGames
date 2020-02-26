//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;

main( n_fog_blend_time )
{

	level.tweakfile = true;

	
		
	//rim lighting
	SetDvar( "r_rimIntensity_debug", 1 );
  SetDvar( "r_rimIntensity", 8 );	
   
    
	b_blend_exposure = false;
	
	//fog settings to blend into when take-off is done
	
	
	if ( IsDefined( n_fog_blend_time ) )
	{
		time = n_fog_blend_time;
		b_blend_exposure = true;
	}
	
	
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
	const n_sun_sample_size = 0.25;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  
	
}


///settings for flying high
art_jet_mode_settings( n_transition_time )
{

	
	// added optional transition time parameter for dogfights section fog settings
	if ( IsDefined( n_transition_time ) )
	{
		time = n_transition_time;
	}
	
			
	
	// sun sample size
	const n_sun_sample_size = 0.25;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
	
	// turn off god rays
	m_god_rays = GetEntArray( "godrays", "targetname" );
	foreach( m_godray in m_god_rays )
	{
		m_godray.is_hidden = true;
		m_godray Hide();
	}
}


///settings for flying low
art_vtol_mode_settings( n_transition_time )
{

	
	// added optional transition time parameter for dogfights section fog settings
	if ( IsDefined( n_transition_time ) )
	{
		time = n_transition_time;
	}	
	

	// sun sample size
	const n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
	
	// turn on god rays if they're off
	m_god_rays = GetEntArray( "godrays", "targetname" );
	
	foreach( m_godray in m_god_rays )
	{
		if( IsDefined( m_godray.is_hidden ) && m_godray.is_hidden )
		{
			m_godray.is_hidden = false;
			m_godray Show();	
		}
	}
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


	// exposure setting
	const n_exposure = 4.15;
	level.player SetClientDvars( "r_exposureTweak", 1, "r_exposureValue", n_exposure );
	
	// sun sample size
	const n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  	
	
	
	// vision set
	level.player VisionSetNaked( "sp_la_2_start", 0 );  // immediately transition from intro
}


///DOF enter jet looking at players hand
enter_jet_players_hand( m_player_body)
{

	n_near_start = 0;
	n_near_end = 1;
	n_far_start = 1;
	n_far_end = 400;
	n_near_blur = 6;
	n_far_blur = 3;
	n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

///DOF enter jet looking at cockpit
enter_jet_cockpit( m_player_body)
{

	n_near_start = 0;
	n_near_end = 1;
	n_far_start = 1;
	n_far_end = 400;
	n_near_blur = 6;
	n_far_blur = 3;
	n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}


///DOF enter jet looking at hud
enter_jet_hud( m_player_body)
{

	n_near_start = 0;
	n_near_end = 1;
	n_far_start = 1;
	n_far_end = 1500;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	wait 4;
	
	level.player thread depth_of_field_off( .5 );
	
}



eject()
{
	SetDvar( "r_rimIntensity_debug", 1 );
  SetDvar( "r_rimIntensity", 8 );
}


outro()
{
  SetDvar( "r_rimIntensity", 5 );
  
	const n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  
	

	
	level.map_default_sun_direction = GetDvar( "r_lightTweakSunDirection" );
  SetSavedDvar( "r_lightTweakSunDirection", (-20, 50, 0) );
  
 		level.player VisionSetNaked( "sp_la_2_end", 1 );
 		
 		SetDvar( "r_rimIntensity_debug", 0 );
  	
}

outro_samuels()
{
  SetDvar( "r_rimIntensity", 5 );
  
	const n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );  
	
	
	level.map_default_sun_direction = GetDvar( "r_lightTweakSunDirection" );
  SetSavedDvar( "r_lightTweakSunDirection", (-45, 53, 0) );
  
 		level.player VisionSetNaked( "sp_la_2_end", 1 );
 		
 		SetDvar( "r_rimIntensity_debug", 0 );
  	
}

///DOF for f35 eject
crash_eject(m_player_body)
{
	 n_near_start = 0;
	 n_near_end = 60;
	 n_far_start = 5000;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}
	
///DOF for player looking at parachute	
crash_chute( m_player_body)
{
	 n_near_start = 0;
	 n_near_end = 1;
	 n_far_start = 1000;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

///DOF for player looking at city
crash_city( m_player_body)
{
	 n_near_start = 0;
	 n_near_end = 60;
	 n_far_start = 5000;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

///DOF for player hitting building
crash_hit_building( m_player_body)
{
	 n_near_start = 0;
	 n_near_end = 1;
	 n_far_start = 300;
	 n_far_end = 3000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .2;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

///DOF for player crash landing
crash_land( m_player_body)
{
	 n_near_start = 0;
	 n_near_end = 1;
	 n_far_start = 100;
	 n_far_end = 800;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}




///DOF outro looking at convoy approach
outro_convoy(m_player_body )
{
	 n_near_start = 0;
	 n_near_end = 10;
	 n_far_start = 1000;
	 n_far_end = 20000;
	 n_near_blur = 6;
	 n_far_blur = 1.0;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

///DOF outro looking at harper
outro_harper( m_player_body)
{
	 n_near_start = 0;
	 n_near_end = 10;
	 n_far_start = 1000;
	 n_far_end = 7000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

///DOF looking at president
outro_president(m_player_body )
{
	 n_near_start = 0;
	 n_near_end = 10;
	 n_far_start = 1000;
	 n_far_end = 7000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}

///DOF outro looking at closed door
outro_door(m_player_body )
{
	 n_near_start = 0;
	 n_near_end = 10;
	 n_far_start = 1000;
	 n_far_end = 7000;
	 n_near_blur = 6;
	 n_far_blur = 1.8;
	 n_time = .5;

	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
}