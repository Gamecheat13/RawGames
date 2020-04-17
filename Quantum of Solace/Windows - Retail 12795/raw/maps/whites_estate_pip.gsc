#include maps\_utility;
main()
{
	
		
}

// ---------------------//

split_screen()
{
	//no hud
	setSavedDvar("cg_drawHUD","0");

	//let anim play before split screen
	wait(2);
	
	//crop and move down
	level thread main_crop();
	//level thread main_move();
	
	//PIP
	level thread second_move();
		
}


main_crop()
{

	//set border size and color
	//setdvar("cg_pipmain_border", 2);
	//setdvar("cg_pipmain_border_color", "0.48 0.6 0.88 1");
	
	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	SetDVar("r_pip1Anchor", 3);		// use top middle anchor point

	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, .75, .75, 0.75, .75);
	wait(0.5);
		
	level notify( "window_crop" );
		
	level waittill( "off_screen" );
	//level waittill( "window_up" );

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 1, 1, 1);
	wait(0.5);
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	setSavedDvar("cg_drawHUD","1");

}

//
main_move()
{
	
	level waittill( "window_crop" );
		
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}


//pip
second_move()
{
	//moved earlier. will crash unless set up right away - bug?
	//setup pip camera
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);	//need this or it will crash
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);

	//setup PIP
	//SetDVar("r_pipSecondaryX", .6 );						// start off screen
	//SetDVar("r_pipSecondaryY", -.3);						// place top right corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", ".36, .5, .35, .5");		// scale image, without cropping
	//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio

	//set border and color
	//setdvar("cg_pipsecondary_border", 2);
	//setdvar("cg_pipsecondary_border_color", "0.48 0.6 0.88 1");
		
	//set up the pip	
	//start offscreen
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 10, 0, 0.6, -0.5, .36, .5, .35, .5);

	level waittill( "window_crop" );
	
	level thread second_anim();
	
	SetDVar("r_pipSecondaryMode", 5);		// enable video camera display with highest priority 		
	
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 0.6, -.1);
	wait(0.5);
	
	level.player animatepip( 3000, 0, 0.6, .3);

	//notify from 
	level waittill( "explosion_1" );

	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, .6, 1 );
	wait(0.5);
		
	level notify( "off_screen" );
	
	//reset
	SetDVar("r_pipSecondaryMode", 0);	//hide						
	level.player securityCustomCamera_Pop( cameraID_hack );	//turn off
}

//bond anim during pip
second_anim()
{
	level endon("off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("phonehacklock");
		wait .05;
	}
	
}




// ---------------------//

monitor_cam()
{
	feedbox = getent("feedbox", "targetname");
	
	cam_pos = [];
	cam_pos[0] = ( -4860, 1060, -242 );	//boathouse
	cam_pos[1] = ( -491, 58, 642 );	//overlooking garden
	cam_pos[2] = ( 1073, -260, 460 );
	cam_pos[3] = ( 550, -1128, 320 );	//
	

	monitor_cameras = [];
	
	for( i = 0; i < 4; i++ )
	{
		//spawn an origin
		monitor_cameras[i] = spawn( "script_origin", cam_pos[i] );
		
		if( i == 0 )
		{
				//setup parameters
				monitor_cameras[i].angles = ( 24.8, 53.6, 0 );
				monitor_cameras[i].script_float = 0;	//static
		}
		else if( i == 1 )
		{
				monitor_cameras[i].angles = ( 20, -170, 0 );
				monitor_cameras[i].script_float = 90; //rotating
		}
		else if( i == 2 )
		{
				monitor_cameras[i].angles = ( 18, -166, 0 );
				monitor_cameras[i].script_float = 45; 
				monitor_cameras[i].script_int = 5; 
		}
		else if( i == 3 )
		{
				monitor_cameras[i].angles = ( 16.5, 155, 0 );
				monitor_cameras[i].script_float = 60; 		
		}

		//setup cameras	
		monitor_cameras[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
   		
	}
	
	//waittill msg from tanner
	//wait 5;
	
	//no feedbox
	level thread maps\_securitycamera::camera_tap_start( feedbox, monitor_cameras );
	//level thread maps\_securitycamera::camera_tap_start( undefined, monitor_cameras );
	
	feedbox waittill("tapped");
	
	flag_set("feed_tapped");
	
}
