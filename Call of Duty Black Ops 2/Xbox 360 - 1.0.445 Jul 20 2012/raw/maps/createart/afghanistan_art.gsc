//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{

//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 8 );	


	level.tweakfile = true;
	
	//dust storm
 
VisionSetNaked( "afghanistan_dust_storm", 5 );	

n_sun_sample_size = 0.35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
	//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 8 );	
}
 
 
 
 canyon()
{
VisionSetNaked( "afghanistan_canyon_start", 3 );

//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	
}	




open_area()
{
VisionSetNaked( "afghanistan_open_area", 3 );

//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	
}


rebel_entrance()
{
VisionSetNaked( "afghanistan_rebel_camp", 2 );
   		
//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 6 );	
}


rebel_camp()
{
VisionSetNaked( "afghanistan_rebel_entrance", 3 );

//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	
}


fire_horse()
{
VisionSetNaked( "afghanistan_open_area", 2 );

//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	
}


interrogation()
{
	VisionSetNaked( "afghanistan_interrogation", 3 );


  SetDvar( "r_rimIntensity_debug", 1 );
  SetDvar( "r_rimIntensity", 4 );	
    
 	level.player depth_of_field_off( .1 );

	n_sun_sample_size = 0.35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}

deserted()
{
	VisionSetNaked( "afghanistan_open_area", 1 );
}

dof_time_lapse(m_player_body)
{
	n_near_start = 1;
	n_near_end = 20.59;
	n_far_start = 20.6;
	n_far_end = 1122;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .5;

	SetSunLight( 0.77, 0.63, 0.49);
	SetSavedDvar( "r_lightTweakSunLight", 5);
	
	n_sun_sample_size = .35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}


turn_down_fog()
{

}

///DOF Woods rappell

dof_lookout(m_player_body)
{
	n_near_start = 0;
	n_near_end = 1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;						
		
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}



dof_rappell(m_player_body)
{
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;					
		
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}



dof_landed(m_player_body)
{
	n_near_start = 1;
	n_near_end = 7.7;
	n_far_start = 20.6;
	n_far_end = 1415;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}



dof_run2wall(m_player_body)
{
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;				
		
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}


dof_hit_wall(m_player_body)
{
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;				
		
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}




///DOF_intro_Zhao

dof_woods(m_player_body)
{
	n_near_start = 1;
	n_near_end = 20.59;
	n_far_start = 20.6;
	n_far_end = 1122;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .5;	
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	n_sun_sample_size = 1;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}


dof_horses(m_player_body)
{
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;			
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}


dof_jumped(m_player_body)
{
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;					
		
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}


dof_woods_up(m_player_body)
{
	n_near_start = 1;
	n_near_end = 20.59;
	n_far_start = 20.6;
	n_far_end = 1122;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .5;	
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

dof_zhao(m_player_body)
{
	n_near_start = 1;
	n_near_end = 20.59;
	n_far_start = 20.6;
	n_far_end = 1122;
	n_near_blur = 6;
	n_far_blur = 0.5;
	n_time = .5;	
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}


dof_woods_end(m_player_body)
{
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;					
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );

	wait 1.0;
	
	level.player depth_of_field_off( .3 );
	
	
n_sun_sample_size = 1;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}

dof_omar(m_player_body)
{
	n_near_start = 1;
	n_near_end = 20.59;
	n_far_start = 20.6;
	n_far_end = 715;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .1;	
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	n_sun_sample_size = 0.35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}

dof_beatdown(m_player_body)
{
	n_near_start = 1;
	n_near_end = 7.7;
	n_far_start = 20.96;
	n_far_end = 335.17;
	n_near_blur = 6;
	n_far_blur = 1.83;
	n_time = .2;	
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	n_sun_sample_size = 0.35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
		wait 1.0;
	
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = .1;
	n_far_blur = .1;
	n_time = .3;					
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );

	
	level.player depth_of_field_off( 3 );
}


DOF_tank_on(m_player_body)
{
	n_near_start = 1;
	n_near_end = 7.7;
	n_far_start = 20.6;
	n_far_end = 1415;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	n_sun_sample_size =0.35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}

DOF_tank_off(m_player_body)
{
	n_near_start = 1;
	n_near_end = 1.1;
	n_far_start = 1.2;
	n_far_end = 20000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .3;				
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	n_sun_sample_size =0.35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}


DOF_strangle(m_player_body)
{
	n_near_start = 1;
	n_near_end = 7.7;
	n_far_start = 20.6;
	n_far_end = 2000;
	n_near_blur = 6;
	n_far_blur = 1;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	n_sun_sample_size = .35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
	wait 1.0;
	
	level.player depth_of_field_off( 3 );
}

dof_03(m_player_body)
{
	n_near_start = 1;
	n_near_end = 7.7;
	n_far_start = 20.6;
	n_far_end = 1415;
	n_near_blur = 6;
	n_far_blur = 1;
	n_time = .5;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	SetSunLight( 0.77, 0.63, 0.49);
	SetSavedDvar( "r_lightTweakSunLight", 0.3);
	
	n_sun_sample_size =0.35;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}

