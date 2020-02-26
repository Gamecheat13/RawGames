//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

#define DEFAULT_SKY_INTENSITY_FACTOR_0 6
#define DEFAULT_SKY_INTENSITY_FACTOR_1 7.62
main()
{


		

//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	


	level.tweakfile = true;
 
	// *intro section*
		
	//VisionSetNaked( "angola_riverbed_intro", 0.5 );
	VisionSetNaked( "sp_angola_burning_man", 0.1 );
	
	//SetSavedDvar( "r_sky_intensity_factor0", 6 );
	//SetSavedDvar( "r_sky_intensity_factor1", 7.62 );

}

//////////burning_man is for when we are looking in the direction of the man trapped in the truck///////////

burning_man()
{
	VisionSetNaked( "sp_angola_burning_man", 0.1 );
	
	//////rimlighting////////
	SetDvar( "r_rimIntensity", 50 );	
	       
	n_near_start = 0;
	n_near_end = 20;
	n_far_start = 20;
	n_far_end = 1000;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	// exposure setting
	n_exposure = 4;	
	SetDvar( "r_exposureTweak", 1 );
	SetDvar( "r_exposureValue", n_exposure );
	
	//Light Grid
	//SetSavedDvar( "r_heroLighting", 1 );
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 0 );
	SetSavedDvar( "r_lightGridContrast", -0.23569 );
	
	n_sun_sample_size = .25;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}

///////////burning_sky is for when we are silhouette the guy climbing out of the truck, (looking into the sun)

#define BURNING_SKY_EXPOSURE 4.9
#define BURNING_SKY_CONTRAST -0.73569
burning_sky()
{
	VisionSetNaked( "sp_angola_burning_sky", 0.5 );
	
	//////rimlighting////////
	SetDvar( "r_rimIntensity", 50 );	
	       
	n_near_start = 0;
	n_near_end = 20;
	n_far_start = 20;
	n_far_end = 1000;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = .2;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
		
	//SetSavedDvar( "r_sky_intensity_useDebugValues", 1 );
	//SetSavedDvar( "r_sky_intensity_factor0", 6 );
	//SetSavedDvar( "r_sky_intensity_factor1", 7.62 );
	
//	SetDvar( "r_sky_intensity_useDebugValues", 1 );
//	SetDvar( "r_sky_intensity_factor0", 6 );
//	SetDvar( "r_sky_intensity_factor1", 7.62 );

// exposure setting
	SetDvar( "r_exposureTweak", 1 );
	SetDvar( "r_exposureValue", BURNING_SKY_EXPOSURE );
	
	//Light Grid
	//SetSavedDvar( "r_heroLighting", 1 );
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 0 );
	SetSavedDvar( "r_lightGridContrast", BURNING_SKY_CONTRAST );	
	
	n_sun_sample_size = .25;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}

#define RIVERBED_EXPOSURE 2.8
#define RIVERBED_CONTRAST 0
#define RIVERBED_SKY_INTENSITY_FACTOR_0 0.5
#define RIVERBED_SKY_INTENSITY_FACTOR_1 1
riverbed()
{
	VisionSetNaked( "sp_angola_riverbed", 2 );
	
	//////rimlighting////////
	SetDvar( "r_rimIntensity", 4 );	
		
	level.player depth_of_field_off( 2 );
	
    // exposure setting
    n_exposure = 2.8;
    SetDvar( "r_exposureTweak", 1 );
    
    const n_transition_time = 2;
    const n_increment_time = 0.05;
    
    level thread ramp_dvar( "r_exposureValue", BURNING_SKY_EXPOSURE, RIVERBED_EXPOSURE, n_transition_time, n_increment_time );
    
    //Light Grid Contrast
    const n_contrast_transition_time = 2;
    const n_contrast_increment_time = 0.1;
    
    ramp_dvar( "r_lightGridContrast", BURNING_SKY_CONTRAST, RIVERBED_CONTRAST, n_transition_time, n_increment_time );
   
	//SetSavedDvar( "r_heroLighting", 0 );
	SetSavedDvar( "r_lightGridEnableTweaks", 0 );
	
	n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
	//DO NOT DELETE.  Neil will want these back after First Playable - mb
	//level thread ramp_lighting_dvar( "r_sky_intensity_factor0", DEFAULT_SKY_INTENSITY_FACTOR_0,  RIVERBED_SKY_INTENSITY_FACTOR_0, 2, 0.1);
	//level thread ramp_lighting_dvar( "r_sky_intensity_factor1", DEFAULT_SKY_INTENSITY_FACTOR_1,  RIVERBED_SKY_INTENSITY_FACTOR_1, 2, 0.1);
}

riverbed_skipto()
{
	VisionSetNaked( "sp_angola_riverbed", 2 );
	
	level.player depth_of_field_off( 2 );
	
	n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	SetSavedDvar( "r_exposureValue", RIVERBED_EXPOSURE );
	
}

savannah_start()
{
 	
		VisionSetNaked( "sp_angola_savannah", 0.5 );
		
		//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	

}

savannah_hill()
{

		VisionSetNaked( "sp_angola_savannah", 0.5 );
		
		//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	

}

savannah_finish()
{
 	
		VisionSetNaked( "sp_angola_savannah", 0.5 );
		
		//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	

}

river()
{
	n_sun_sample_size = 1.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
	
	VisionSetNaked( "sp_angola_2_river", 0.5 );
	
	//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	

}


heli_jump()
{
	n_sun_sample_size = .75;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );
}



river_barge()
{
	VisionSetNaked( "sp_angola_2_river", 0.5 );
	
	//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	
    
  n_sun_sample_size = 0.5;
	SetSavedDvar( "sm_sunSampleSizeNear", n_sun_sample_size );

}

#define CONTAINER_DARK_EXPOSURE 4.0
vision_find_woods()
{
	n_current_exposure = GetDebugDvarFloat( "r_exposureValue" );
	SetDvar( "r_exposureTweak", 1 );
	
		const n_transition_time = 0.5;
    const n_increment_time = 0.05;
    const n_transition_light = 5.0;
    
    ramp_dvar( "r_exposureValue", n_current_exposure, CONTAINER_DARK_EXPOSURE, n_transition_light, n_increment_time );
  		
	//warp boat to a good location and stop it from moving
	wait 5; //Temp until I figure out how to stop the barge, and the proper timing - mb
	level thread ramp_dvar( "r_exposureValue", CONTAINER_DARK_EXPOSURE, n_current_exposure, n_transition_light, n_increment_time );
	
	VisionSetNaked( "sp_angola_2_container_in", 5.0 );
}

vision_leave_container()
{
	
	level waittill("change_vision");
	VisionSetNaked( "sp_angola_2_container_out", 2.0 );
	
	//When near end of tunnel set original vision set
	
	wait 5;  //Temp timing --> need a new notetrack - mb
	
	VisionSetNaked( "sp_angola_2_river", 0.5 );

	SetDvar( "r_exposureTweak", 0 );
}

jungle_stealth()
{
 	
		VisionSetNaked( "sp_angola_2_jungle_stealth", 0.5 );
		
		//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	

}

village()
{
 	
		VisionSetNaked( "sp_angola_2_village", 0.5 );
		
		//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	

}

jungle_escape()
{
 	
		VisionSetNaked( "sp_angola_2_jungle_escape", 0.5 );
		
		//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 4 );	

}

angola2_finale_dof1()
{
	n_near_start = 0;
	n_near_end = 1;
	n_far_start = 1;
	n_far_end = 30;
	n_near_blur = 9.9;
	n_far_blur = 9;
	n_time = 0.4;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	iprintln( "DOF 1");
}

angola2_finale_dof2()
{
	n_near_start = 0;
	n_near_end = 40;
	n_far_start = 40;
	n_far_end = 140;
	n_near_blur = 9.9;
	n_far_blur = 2.0;
	n_time = 1.0;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	iprintln( "DOF 2");
}

angola2_finale_dof3()
{
	n_near_start = 0;
	n_near_end = 40;
	n_far_start = 40;
	n_far_end = 4000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = 3.0;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	iprintln( "DOF 3");
	
	//DOF 4
	//wait 1;
	//level.player depth_of_field_off( 2 );
}

ramp_dvar( str_dvar, n_start, n_end, n_transition_time = 2, n_increment_time = 0.1 )
{
	Assert( (n_start != n_end), "Nothing to ramp for " + str_dvar + " because start value (" + n_start + ") equals end value (" + n_end + ")" );
	
	if( n_transition_time <= 0 )
	{
		n_transition_time = 2;
	}
	
	if( n_transition_time <= 0 )
	{
		n_increment_time = 0.1;
	}
	
	n_iterations = n_transition_time / n_increment_time;
	n_new = n_start; 
	
	//Ramp from low value to high
	if ( n_start < n_end )
	{
		n_increment = (n_end - n_start)/n_iterations;
		
		while (1)
	    {
	    	n_new = n_new + n_increment;
	    	
	    	if( n_new >= n_end )
	    	{
	    		SetSavedDvar( str_dvar, n_end );
	    		break;
	    	}
	    	
	    	SetSavedDvar( str_dvar, n_new );
	    	
	    	wait n_increment_time;
		}
	}
	
	//Ramp from high value to low
	else if( n_start > n_end )
	{
		n_decrement = (n_start - n_end)/n_iterations;
		
		while (1)
	    {
	    	n_new = n_new - n_decrement;
	    	
	    	if( n_new <= n_end )
	    	{
	    		SetSavedDvar( str_dvar, n_end );
	    		break;
	    	}
	    	
	    	SetSavedDvar( str_dvar, n_new );
	    	
	    	wait n_increment_time;
		}
	}
}

 lightGridContrast_transition( n_contrast, n_contrast_transition_time, n_contrast_increment_time )
 {
 	n_iterations = n_contrast_transition_time / n_contrast_increment_time;
 	n_contrast_increment = abs( (n_contrast - RIVERBED_CONTRAST)/n_iterations );
    
    while (1)
    {
    	n_contrast = n_contrast + n_contrast_increment;
    	
    	if( n_contrast >= RIVERBED_CONTRAST)
    	{
    		n_contrast = RIVERBED_CONTRAST;
    		SetSavedDvar( "r_lightGridContrast", n_contrast );	
    		break;
    	}
    	
    	SetSavedDvar( "r_lightGridContrast", n_contrast );	
    	
    	wait n_contrast_increment_time;
 	}
 }
 
 heli_run_DOF_ON()
 {
 	n_near_start = 0;
	n_near_end = 80;
	n_far_start = 1000;
	n_far_end = 12000;
	n_near_blur = 6;
	n_far_blur = 1.8;
	n_time = .25;
	
	level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );	
 	
 }
 
 heli_run_DOF_OFF()
 {
 	//Turn off DOF
 	level.player depth_of_field_off( .25 );
 	
 }
 
set_water_dvars_strafe()
{
	SetDvar( "r_waterwavespeed", "0.470637 0.247217 1 1" );
	SetDvar( "r_waterwaveamplitude", "2.8911 0 0 0" );
	SetDvar( "r_waterwavewavelength", "9.71035 3.4 1 1" );	
	SetDvar( "r_waterwaveangle", "56.75 237.203 0 0" );
	SetDvar( "r_waterwavephase", "0 2.6 0 0" );
	SetDvar( "r_waterwavesteepness", "0 0 0 0" );
	SetDvar( "r_waterwavelength", "9.71035 3.40359 1 1" );
}
