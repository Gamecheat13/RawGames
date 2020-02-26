// Test clientside script for karma
#include clientscripts\_utility;
#insert raw\maps\_glasses.gsh;
	
//*****************************************************************************
//*****************************************************************************

autoexec init()
{
	// Setup Extra Cam
	// Control the turning on/off of the 'extra cam'
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_GLASSES_CAM, ::glasses_cam );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_EXTRA_CAM, ::extra_cam );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_KARMA_VITAL_CAM, ::karma_vitals_cam );
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);
	// Set ui3d window
	ui3dsetwindow( 0, 0, 0, 1, 1 );		
	//****************
	// EXTRA CAM SETUP
	//****************
	init_sw_cam();
	level.extraCamActive = false;
}


//
//	This is an extra camera that will simulate the view from a teammate's glasses
//	This is the most basic usage
//
glasses_cam( localClientNum, set, newEnt )
{
	if ( set )
	{
	    if ( !level.extraCamActive )
	    {        
	        level.extraCamActive = true;
	
	        self IsExtraCam( 0 );
	    }
	}
	else
	{
		//	Shutdown the glasses video feed
	    if ( level.extraCamActive )
	    {
	    	StopExtraCam( 0 );
	        level.extraCamActive = false;
	    }
	}
}


//
//	This is the old method of extra camera 
//
extra_cam( localClientNum, set, newEnt )
{
	if ( set )
	{
	    if ( !level.extraCamActive )
	    {
	        level.extraCamActive = true;

	        self IsExtraCam( 0 );

			// Start Shaderworks Cam
			start_sw_cam( 0.1, 0.1, 0.1 );
	    }
	}
	else
	{
		//	Shutdown the glasses video feed
	    if ( level.extraCamActive )
	    {
	    	StopExtraCam( 0 );
	        level.extraCamActive = false;
	        
	        stop_sw_cam();
	    }
	}
}


//*****************************************************************************
//*****************************************************************************
init_sw_cam()
{
	level.pip_filterid      = 2;
	level.pip_passid  		= 0;
	level.pip_materialid 	= 12;
	level.pip_opacity 		= 0.5;					// change this (0,2)
	level.pip_squash  		= 1.0;					// change this (0,2)

	level.pip_material		= "generic_filter_karma_club_extracam";
	level.pip_left          = 30;
	level.pip_top           = 30;
	level.pip_right         = 230;
	level.pip_bottom  		= 290;

	player = level.localPlayers[0];
	player map_material( level.pip_materialid, level.pip_material );
	player set_filter_pass_material( level.pip_filterid, level.pip_passid, level.pip_materialid );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 4, level.pip_left );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 5, level.pip_top );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 6, level.pip_right );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 7, level.pip_bottom );
        player set_filter_bit_flag( level.pip_filterid, 2, 1 );    
}

init_crosshair_material()
{
	level.pip_filterid      = 2;
	level.pip_passid  		= 0;
	level.pip_materialid 	= 12;
	level.pip_opacity 		= 0.5;					// change this (0,2)
	level.pip_squash  		= 1.0;					// change this (0,2)

	level.pip_material		= "hud_karma_sw";
	level.pip_left          = 30;
	level.pip_top           = 30;
	level.pip_right         = 230;
	level.pip_bottom  		= 290;

	player = level.localPlayers[0];
	player map_material( level.pip_materialid, level.pip_material );
	player set_filter_pass_material( level.pip_filterid, level.pip_passid, level.pip_materialid, 3 /*scene target*/, 0, 0 );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 4, level.pip_left );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 5, level.pip_top );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 6, level.pip_right );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 7, level.pip_bottom );
	
}

//Function that change material based on level.
//use this function to change material type and size of the extra cam.
set_extracam_material_location( material, left, top, right, bottom)
{
	level.pip_material		= material;
	level.pip_left          = left;
	level.pip_top           = top;
	level.pip_right         = right;
	level.pip_bottom  		= bottom;
	
	player = level.localPlayers[0];
	player map_material( level.pip_materialid, level.pip_material );	
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 4, level.pip_left );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 5, level.pip_top );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 6, level.pip_right );
	player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 7, level.pip_bottom );	
}

//	Keeping for reference - MM
////karma temp
//karma_crc_cam( Localclientnum, set, newent )
//{
//	
//	if ( set )
//	{
//		level.pip_material		= "hud_karma_sw";
//		level.pip_left          = 500;
//		level.pip_top           = 200;
//		level.pip_right         = 830;
//		level.pip_bottom  		= 590;
//		
//		player = level.localPlayers[0];
//		player map_material( level.pip_materialid, level.pip_material );
//		player set_filter_pass_material( level.pip_filterid, level.pip_passid, level.pip_materialid );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 4, level.pip_left );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 5, level.pip_top );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 6, level.pip_right );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 7, level.pip_bottom );
//	
//	
//	    self linktocamera();
//        self IsExtraCam( localClientNum );
//        start_sw_cam( 0.1, 0.1, 0.1 );
//	}
//	else
//	{
//		level.pip_material		= "generic_filter_karma_club_extracam";
//		level.pip_left          = 30;
//		level.pip_top           = 30;
//		level.pip_right         = 230;
//		level.pip_bottom  		= 290;
//
//		fade_out_sw_extra_cam( 0.1, 0.1, 0.1 );
//
//		wait(0.1);
//    	StopExtraCam( localClientNum );
//        level.extraCamActive = false;
//        
//        
//        self UnlinkFromCamera();
//        stop_sw_cam();
//        
//        
//        player = level.localPlayers[0];
//		player map_material( level.pip_materialid, level.pip_material );
//		player set_filter_pass_material( level.pip_filterid, level.pip_passid, level.pip_materialid );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 4, level.pip_left );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 5, level.pip_top );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 6, level.pip_right );
//		player set_filter_pass_constant( level.pip_filterid, level.pip_passid, 7, level.pip_bottom );
//	}
//}
setup_player_control( Localclientnum )
{
	
	player = getlocalplayer( Localclientnum );
	while(1)
	{
		movement =  player GetNormalizedCameraMovement();
		new_angles = self.angles;
		
		x = new_angles[0] - movement[0];
		y = new_angles[1] - movement[1];
		
		
		
		if(x < -4.5 )
		{
			x = -4.5;
		}
		if(x > 6 )
		{
			x = 6;
		}
		
		if(y > 19 )
		{
			y = 19;
		}
		if(y < -1.5 )
		{
			y = -1.5;
		}
		
		new_angles = ( x, y, 0 );
		
		self.angles = new_angles;
		wait(0.01);
		iprintlnbold( new_angles[0] + " " + new_angles[1]);	
	}

}

//*****************************************************************************
// Start the Extra Cam
//
// Currently the Extra can is rendering from the Player 'Camera' Position
//*****************************************************************************
karma_vitals_cam( localClientNum, set, newEnt )
{
	if ( set )
	{
		start_karma_vitals_cam( localClientNum );
	}
	else
	{
		stop_karma_vitals_cam( localClientNum );
	}
}


start_karma_vitals_cam( localClientNum )
{
    if ( !level.extraCamActive )
    {
        level.extraCamActive = true;
        init_crosshair_material();
        self linktocamera();
        self IsExtraCam( localClientNum );

		//**********************************************
		// Turn on the Shader Works Extra Cam
		// NOTE: We are fadnig in the camera from static
		//**********************************************
		start_sw_cam( 0.3, 0.2, 0.2 );

		// Set the default Extra Cam FOV
		level.extracam_required_fov = 7;		// 7
		
		
		//**********************************************
		// While loop - Manages the FOV of the Extra Cam
		//**********************************************
		current_fov = level.extracam_required_fov;
		SetExtraCamFov( localClientNum, current_fov );
		
		min_zoomed_in_time = 1.0;					// 0.6
		fov_inc = 3.2;								// 2.8
		level.zoomed_in_start_time = -10000;
		
		while( level.extraCamActive )
		{
			required_fov = level.extracam_required_fov;
				
			// Do we want to change the fov of the extra cam?
			if( current_fov != required_fov )
			{
				if( current_fov < required_fov )
				{
					// Force the camera to be zoomed in for a minimum amount of time
					time = getrealtime();
					dt = ( time - level.zoomed_in_start_time ) / 1000;
					if( dt > min_zoomed_in_time )
					{
						current_fov += fov_inc;
						if( current_fov >= required_fov )
						{
							current_fov = required_fov;
						}
					}
				}
				
				if( current_fov > required_fov )
				{
					current_fov -= fov_inc;
					if( current_fov <= required_fov )
					{
						current_fov = required_fov;
					}
				}
				SetExtraCamFov( localClientNum, current_fov );	
			}
			
			wait( 0.01 );
		}
    }
}


//*****************************************************************************
//*****************************************************************************
stop_karma_vitals_cam( localClientNum )
{
    if ( level.extraCamActive )
    {
		fade_out_sw_extra_cam( 1.0, 1.0, 3.0 );

		wait( 5 );

    	StopExtraCam( localClientNum );
        level.extraCamActive = false;
        
        stop_sw_cam();
    }
}


//*****************************************************************************
// Call this for the effect to show
//*****************************************************************************
start_sw_cam( fade_in_time, hold_static_time, static_time )
{
	level.localPlayers[0] set_filter_pass_enabled( level.pip_filterid, level.pip_passid, true );
	
	// 0->1 transparent to opaque
	level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 0, level.pip_opacity );	
	
	// 0-1 vertically flat to normal sized
	level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 1, level.pip_squash );
	
	// Fade in the extra cam
	if ( !IsDefined( fade_in_time ) )
	{
		fade_in_time = 2.0;
	}
	if ( !IsDefined( hold_static_time ) )
	{
		hold_static_time = 0.6;
	}
	if ( !IsDefined( static_time ) )
	{
		static_time = 2.2;
	}
	
	level thread fade_in_sw_extra_cam( fade_in_time, hold_static_time, static_time );
}


//*****************************************************************************
//*****************************************************************************
stop_sw_cam()
{
	level.localPlayers[0] set_filter_pass_enabled( level.pip_filterid, level.pip_passid, false );
}


//*****************************************************************************
//*****************************************************************************
fade_in_sw_extra_cam( fade_in_time, hold_static_time, static_time )
{
	// Need to set an initial fuzz level
	level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 2, 0.01 );

	alpha = 0;
	fuzz = 0.01;

	// Fade in the Extra Cam as a static image	
	time = 0;
	start_time = getrealtime();
	while( time < fade_in_time )
	{
		time = ( getrealtime() - start_time ) / 1000;
		if( time > fade_in_time )
		{
			time = fade_in_time;
		}
		alpha = 1.0 - ((fade_in_time - time) / fade_in_time);
	
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 0, alpha );
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 2, fuzz );
		
		wait( 0.01 );
	}

	// Hold static image time
	wait( hold_static_time );

	// Fade out the static
	time = 0;
	start_time = getrealtime();
	while( time < static_time )
	{
		time = ( getrealtime() - start_time ) / 1000;
		if( time > static_time )
		{
			time = static_time;
		}
	
		frac = 1.0 - ((static_time - time) / static_time);
		fuzz = 0.85 * frac;
	
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 0, alpha );
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 2, fuzz );
		
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************
fade_out_sw_extra_cam( fade_out_time, hold_static_time, static_time )
{
	alpha = 1.0;
	fuzz = 1.0;
	
	// Fade in the static
	time = 0;
	start_time = getrealtime();
	while( time < static_time )
	{
		time = ( getrealtime() - start_time ) / 1000;
		if( time > static_time )
		{
			time = static_time;
		}
	
		frac = ((static_time - time) / static_time);
		fuzz = frac;
		if( fuzz < 0.01 )
		{
			fuzz = 0.01;
		}
	
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 0, alpha );
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 2, fuzz );
		
		wait( 0.01 );
	}

	// Hold static image time
	wait( hold_static_time );

	// Fade out the Extra Cam as a static image	
	time = 0;
	start_time = getrealtime();
	while( time < fade_out_time )
	{
		time = ( getrealtime() - start_time ) / 1000;
		if( time > fade_out_time )
		{
			time = fade_out_time;
		}
		alpha = ((fade_out_time - time) / fade_out_time);
	
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 0, alpha );
		level.localPlayers[0] set_filter_pass_constant( level.pip_filterid, level.pip_passid, 2, fuzz );
		
		wait( 0.01 );
	}
}


//
//	Listen for FOV messages and adjust FOV as necessary
//	I really wish there was a better way to do this with parameterized notifies.
//	Until then, just run this thread with whichever messages and FOVs you wish to set.
//
fov_listener( str_msg, n_fov )
{
	while (1)
	{
		level waittill( str_msg );

		SetExtraCamFov( 0, n_fov );
	}
}



