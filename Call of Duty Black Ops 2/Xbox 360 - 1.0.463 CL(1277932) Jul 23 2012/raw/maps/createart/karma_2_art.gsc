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
	n_vs_time 		= 2;			// vision set transition time
	n_near_start 	= undefined;
	n_near_end 		= undefined;
	n_far_start 	= undefined;
	n_far_end 		= undefined;
	n_near_blur		= undefined;
	n_far_blur		= undefined;
	n_time			= undefined;	// DOF transition time

	switch( str_vision_set )
	{
		case "sp_karma2_mall_interior":
		  	n_vs_time = 2;
			SetDvar( "r_rimIntensity_debug", 1 );
   			SetDvar( "r_rimIntensity", 10 );
			break;
			
		case "sp_karma2_clubexit":
		  	n_vs_time = 2;
			SetDvar( "r_rimIntensity_debug", 1 );
   		 	SetDvar( "r_rimIntensity", 4 );
			break;
			
		case "sp_karma2_sundeck":
		  	n_vs_time = 2;
			SetDvar( "r_rimIntensity_debug", 1 );
   		 	SetDvar( "r_rimIntensity", 15 );
			break;
			
		case "sp_karma2_end":
		  	n_vs_time = 2;
			SetDvar( "r_rimIntensity_debug", 1 );
   		 	SetDvar( "r_rimIntensity", 15 );
			break;
			
	}
	
	// Change to our new vision set
	VisionSetNaked( str_vision_set, n_vs_time );
	level.karma_vision = str_vision_set;

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

