// Test clientside script for karma
#include clientscripts\_utility;
//*****************************************************************************
//*****************************************************************************

autoexec init()
{
	

	// Setup Extra Cams
	// level.CLIENT_FLAG_*: Hardcoded numbers to match karma.gsc
	// Control the turning on/off of the 'extra cam'
	level.CLIENT_FLAG_EXTRA_CAM = 1;	// Special Scanner for Karma event 10
	level.CLIENT_FLAG_GLASSES_CAM = 2;	// Used for general comm through glasses
	
	register_clientflag_callback( "scriptmover", level.CLIENT_FLAG_EXTRA_CAM, ::extra_cam );
	register_clientflag_callback( "scriptmover", level.CLIENT_FLAG_GLASSES_CAM, ::glasses_cam );

	
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

	/*if ( str_section == "karma_end" )
	{
		level.pip_material		= "hud_karma_sw";
		level.pip_left          = 100;
		level.pip_top           = 100;
		level.pip_right         = 300;
		level.pip_bottom  		= 360;
	}
	else
	{*/
	
	//}

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
}


//*****************************************************************************
// Start the Extra Cam
//
// Currently the Extra can is rendering from the Player 'Camera' Position
//*****************************************************************************
extra_cam( localClientNum, set, newEnt )
{
	if ( set )
	{
		//init_sw_cam( );
		start_extra_cam( localClientNum );
	}
	else
	{
		stop_extra_cam( localClientNum );
	}
}


start_extra_cam( localClientNum )
{
    if ( !level.extraCamActive )
    {
        //IPrintLnBold( "camera_start" );
                    
        level.extraCamActive = true;
        
        
        //******************************************************
        // This version links the extra cam to the entity 'self'
        //******************************************************
        
/*
        self IsExtraCam( localClientNum );
*/


        //**************************************************************************
        // This version links the extra cam to a client entity, that happens to 
        // be linked to the camera
        //**************************************************************************
       
/*
        //level.extraCam = Spawn(0, (0,0,0), "script_model");
        //level.extraCam linktocamera();
        //level.extraCam IsExtraCam( 0 );
*/
  
  
		//****************************************************************
		// The version im using links the extra cam directly to the camera
		// So the extra cam renders from the cameras position
		//****************************************************************
        
        self linktocamera();
        self IsExtraCam( localClientNum );


		//**********************************************
		// Turn on the Shader Works Extra Cam
		// NOTE: We are fadnig in the camera from static
		//**********************************************

		start_sw_cam( 2.0, 0.6, 2.2 );

		// Set the default Extra Cam FOV
		level.extracam_required_fov = 7;		// 7
		
		
		//***********************************************************************
		// We may want to change the FOV of the Extra Cam
		// We can only pass FOV values from the server to the client via notifies
		// This checks for FOV notify requests
		//***********************************************************************
		
//		level thread manage_fov_notifies( level.extracam_required_fov, level.extracam_required_fov+50 );
		
		//level thread manage_ads_notifies();
			
			
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

stop_extra_cam( localClientNum )
{
    if ( level.extraCamActive )
    {
    	//IPrintLnBold("camera_stop");
	
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


//*****************************************************************************
//*****************************************************************************

manage_fov_notifies( min_fov, max_fov )
{
        
	while( 1 )
	{
/*
		// Wait for a zoomed in notify
		level waittill( "fov_zoomed_in" );
		level.extracam_required_fov = min_fov;
		level.zoomed_in_start_time = getrealtime();

		// Wait for a zoomed out notify
		level waittill( "fov_normal" );
		level.extracam_required_fov = max_fov;
*/

		// HACK - For now keep a zoomed in FOV at all times
		level.extracam_required_fov = min_fov;
		wait( 0.01 );
	}
}


//
//	Listen for FOV messages and adjust FOV as necessary
fov_listener( str_msg, n_fov )
{
	while (1)
	{
		level waittill( str_msg );
		
//		level.extracam_required_fov = n_fov;
		SetExtraCamFov( 0, n_fov );	
	}
}



//
//	This is a camera that will simulate the view from a teammate's glasses
glasses_cam( localClientNum, set, newEnt )
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
			fade_out_sw_extra_cam( 0.1, 0.1, 0.1 );
			wait( 0.3 );
	
	    	StopExtraCam( 0 );
	        level.extraCamActive = false;
	        
	        stop_sw_cam();
	    }
	}
}