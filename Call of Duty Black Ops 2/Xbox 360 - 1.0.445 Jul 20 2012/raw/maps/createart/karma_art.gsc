//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
	
//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 15 );	
}


//
//	Change vision set when triggered
//
//	self is a trigger
vision_set_trigger_think()
{
	self endon("death");
	
	while(1)
	{
		self waittill("trigger");

		if( level.karma_vision != self.script_string )
		{
			vision_set_change( self.script_string );
		}
		
		wait(0.1);
	}
}


//
//	Change the current vision set
//	str_vision_set - the VisionSet to switch to
//	n_time - transition time
vision_set_change( str_vision_set )
{
	n_vs_time = 2;	// vision set transition time

	switch( str_vision_set )
	{
		
		case "sp_karma_flyin_desat":
		  n_vs_time = 0.0;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 15 );
			
			n_near_start = 14;
			n_near_end = 76;
			n_far_start = 5866;
			n_far_end = 6824;
			n_near_blur = .2;
			n_far_blur = .12;
			n_time = .2;
			
			// Need to set this base value because the dvar is not getting reset on restart
			SetSavedDvar( "sm_sunSampleSizeNear", 0.5 );
			break;
		
		case "sp_karma_flyin":
			n_vs_time = 3;
			
			n_near_start = 14;
			n_near_end = 76;
			n_far_start = 5866;
			n_far_end = 6824;
			n_near_blur = .2;
			n_far_blur = .12;
			n_time = .2;
			break;
			
		case "sp_karma_intro":
			n_vs_time = 3;
			SetDvar( "r_rimIntensity_debug", 2 );
			SetDvar( "r_rimIntensity", 15 );
			
			//n_near_start = 2;
			//n_near_end = .3;
			//n_far_start = 789.8;
			//n_far_end = 6612.89;
			//n_near_blur = 10;
			//n_far_blur = 4;
			//n_time = .2;
		
			
			break;
			
			case "sp_karma_IntroGlassesTint":
			n_vs_time = 0.8;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 15 );
			break;
			
		case "sp_karma_IntroGlassesOn":
			n_vs_time = 1;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 15 );
			
			n_near_start = 1;
	    n_near_end = 4.5;
	    n_far_start = 16884.9;
	    n_far_end = 19457.9;
	    n_near_blur = 4;
	    n_far_blur = .4;
	    n_time = .2;
			break;
			
		case "sp_karma_security":
		  n_vs_time = 3;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 6 );
			
			level.map_default_sun_direction = GetDvar( "r_lightTweakSunDirection" );
      SetSavedDvar( "r_lightTweakSunDirection", (-38, -135, 0) );
			break;
			
		case "sp_karma_elevators":
		  n_vs_time = 2;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 6 );
			
			SetSavedDvar( "sm_sunSampleSizeNear", 2 );
			
			break;
			
		case "sp_karma_vista":
		  n_vs_time = 3;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 6 );
			
			break;
			
		case "sp_karma_lobby":
			n_vs_time = 3;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 6 );
			
			n_near_start = 1;
			n_near_end = 4;
			n_far_start = 11210;
			n_far_end = 18930.6;
			n_near_blur = 10;
			n_far_blur = 1.8;
			n_time = .2;
			break;
			
		case "sp_karma_elevator_atrium":
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 4 );

		case "sp_karma_entertainmentdeck01":
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 4.5 );
			
			// Need to set this base value because the dvar is not getting reset on restart
			SetSavedDvar( "sm_sunSampleSizeNear", 0.5 );
			break;
			
		case "sp_karma_ClubMain":
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 50 );
			
			n_near_start = 1;
			n_near_end = 4.5;
			n_far_start = 400;
			n_far_end = 900;
			n_near_blur = 4;
			n_far_blur = .15;
			n_time = .2;
			break;
			
		case "sp_karma_construction":
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 15 );
			
		case "sp_karma_crc":
		  n_vs_time = 3;
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 15 );
			
		case "sp_karma_crc_screens":
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 1 );
			
		case "sp_karma_office":
			SetDvar( "r_rimIntensity_debug", 1 );
			SetDvar( "r_rimIntensity", 15 );
	}
	
	// Change to our new vision set
	VisionSetNaked( str_vision_set, n_vs_time );
	level.karma_vision = str_vision_set;
	level clientNotify( "lowlight_off" );

	// See if a couple of DOF variables are defined.  If so, assume we want to change DOF
	if ( IsDefined( n_near_start ) && IsDefined( n_time ) )
	{
		level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	}
	else
	{
		level.player depth_of_field_off( 0.05 );
	}
}

turn_on_low_light_vision()
{
	VisionSetNaked( "karma_lightsOff", 0.25 );
	level.karma_vision = "karma_lightsOff";
	wait 1.0;
	
	VisionSetNaked( "sp_karma_low_light_warm", 6.0 );
	level.karma_vision = "sp_karma_low_light_warm";	
}

/////////////////////////////////////////////////////////////
//  KARMA 2
/////////////////////////////////////////////////////////////
//sunset fog  (turn this one on when you get to the mall or outdoors.
//call karma_sunset.vision

karma_fog_sunset()
{
	VisionSetNaked( "karma_sunset", 2 );
}

//////////DOF////////////////

///dof_intro()
///{
	
	///n_near_start = 1;
	///n_near_end = 4.5;
	///n_far_start = 16884.9;
	///n_far_end = 19457.9;
	///n_near_blur = 4;
	///n_far_blur = .4;
	///n_time = .2;
	
	///level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
///}

//////Glasses_On//////////

///dof_glasseson()
///{

	///n_near_start = 1;
	///n_near_end = 12.92;
	///n_far_start = 16884.9;
	///n_far_end = 19457.9;
	///n_near_blur = 4.6;
	///n_far_blur = .4;
	///n_time = .2;
	
	///level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
///}

/////View_Over_Railing//////

//dof_railing()

//{

	//n_near_start = 1;
	//n_near_end = 2.24;
	//n_far_start = 10835.4;
	//n_far_end = 17530.6;
	//n_near_blur = 4;
	//n_far_blur = .63;
	//n_time = .2;
	
	//level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
//}

////////////Cinematic_Start////////////////

////Karma_CloseUp/////

defalco_encounter_dof01()
{

	n_near_start = 1;
	n_near_end = 2;
	n_far_start = 73;
	n_far_end = 80;
	n_near_blur = 7;
	n_far_blur = 2.5;
	n_time = .7;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

/////Defalco_Walk//////

defalco_encounter_dof02()
{

	n_near_start = 1;
	n_near_end = 86;
	n_far_start = 128.7;
	n_far_end = 385;
	n_near_blur = 4;
	n_far_blur = 3.7;
	n_time = .2;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}
/////Defalco_DanceFloor////////

defalco_encounter_dof03()
{

	n_near_start = 1;
	n_near_end = 120;
	n_far_start = 215;
	n_far_end = 276;
	n_near_blur = 4;
	n_far_blur = 3.7;
	n_time = .2;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

///Karma_Stage////

defalco_encounter_dof04()
{

	n_near_start = 1;
	n_near_end = 120;
	n_far_start = 215;
	n_far_end = 276;
	n_near_blur = 4;
	n_far_blur = 2;
	n_time = .2;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

///Karma_Punch////

defalco_encounter_dof05()
{

	n_near_start = 1;
	n_near_end = 27.7;
	n_far_start = 215;
	n_far_end = 276;
	n_near_blur = 4;
	n_far_blur = 3.7;
	n_time = .7;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

///Defalco_GunPoint////

defalco_encounter_dof06()
{

	n_near_start = 1;
	n_near_end = 2;
	n_far_start = 1031;
	n_far_end = 2118;
	n_near_blur = .1;
	n_far_blur = .1;
	n_time = .2;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}



//intro DOF

vtol_dof_1()
{

	n_near_start = 1;
	n_near_end = 4;
	n_far_start = 5;
	n_far_end = 84;
	n_near_blur = .1;
	n_far_blur = .1;
	n_time = .4;
	
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	//wait 2;
	
	//n_near_start = 14;
	//n_near_end = 76;
	//n_far_start = 5866;
	//n_far_end = 6824;
	//n_near_blur = .2;
	//n_far_blur = .12;
	//n_time = .5;
	
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	

}

vtol_dof_2()
{
VisionSetNaked( "sp_karma_vtol_interior", 0.5 );

	n_near_start = 1;
	n_near_end = 4;
	n_far_start = 151;
	n_far_end = 171;
	n_near_blur = 4;
	n_far_blur = .35;
	n_time = .5;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	wait 4;
	
	n_near_start = 14;
	n_near_end = 76;
	n_far_start = 5866;
	n_far_end = 6824;
	n_near_blur = .2;
	n_far_blur = .12;
	n_time = .1;
	
	wait 2;
	
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );

			
}

vtol_dof_3()
{
VisionSetNaked( "sp_karma_flyin", 0.5 );

	n_near_start = 1;
	n_near_end = 30.2;
	n_far_start = 151.4;
	n_far_end = 191.6;
	n_near_blur = .2;
	n_far_blur = .1;
	n_time = .2;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	wait 7;
	
	  level.map_default_sun_direction = GetDvar( "r_lightTweakSunDirection" );
    SetSavedDvar( "r_lightTweakSunDirection", (-38, -65, 0) );
}

vtol_dof_4()
{

	n_near_start = 1;
	n_near_end = 2;
	n_far_start = 2156;
	n_far_end = 3012;
	n_near_blur = 1;
	n_far_blur = .2;
	n_time = 5;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}



////spiderbot////

spiderbot_general_dof()
{
	n_near_start = 1;
	n_near_end = 10;
	n_far_start = 30;
	n_far_end = 300;
	n_near_blur = 6;
	n_far_blur = 6;
	n_time = .1;
	
	level.player thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
}

spiderbot_security_dof()
{
	level.player depth_of_field_off( 0.05 );
}