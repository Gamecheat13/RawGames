#include maps\_utility;
main()
{
	
		
}



split_screen()
{
	
	setSavedDvar("cg_drawHUD","0");

	
	wait(2);
	
	
	level thread main_crop();
	
	
	
	level thread second_move();
		
}


main_crop()
{

	
	
	
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 3);		

	
	
	level.player animatepip( 500, 1, -1, -1, .75, .75, 0.75, .75);
	wait(0.5);
		
	level notify( "window_crop" );
		
	level waittill( "off_screen" );
	

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 1, 1);
	wait(0.5);
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	setSavedDvar("cg_drawHUD","1");

}


main_move()
{
	
	level waittill( "window_crop" );
		
	
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}



second_move()
{
	
	
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);	
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);

	
	
	
	SetDVar("r_pipSecondaryAnchor", 4);						
	
	

	
	
	
		
	
	
	
	level.player animatepip( 10, 0, 0.6, -0.5, .36, .5, .35, .5);

	level waittill( "window_crop" );
	
	level thread second_anim();
	
	SetDVar("r_pipSecondaryMode", 5);		
	
	
	level.player animatepip( 500, 0, 0.6, -.1);
	wait(0.5);
	
	level.player animatepip( 3000, 0, 0.6, .3);

	
	level waittill( "explosion_1" );

	
	level.player animatepip( 500, 0, .6, 1 );
	wait(0.5);
		
	level notify( "off_screen" );
	
	
	SetDVar("r_pipSecondaryMode", 0);	
	level.player securityCustomCamera_Pop( cameraID_hack );	
}


second_anim()
{
	level endon("off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("phonehacklock");
		wait .05;
	}
	
}






monitor_cam()
{
	feedbox = getent("feedbox", "targetname");
	
	cam_pos = [];
	cam_pos[0] = ( -4860, 1060, -242 );	
	cam_pos[1] = ( -491, 58, 642 );	
	cam_pos[2] = ( 1073, -260, 460 );
	cam_pos[3] = ( 550, -1128, 320 );	
	

	monitor_cameras = [];

	for( i = 0; i < 4; i++ )
	{
		
		monitor_cameras[i] = spawn( "script_origin", cam_pos[i] );
		
		if( i == 0 )
		{
				
				monitor_cameras[i].angles = ( 24.8, 53.6, 0 );
				monitor_cameras[i].script_float = 0;	
		}
		else if( i == 1 )
		{
				monitor_cameras[i].angles = ( 20, -170, 0 );
				monitor_cameras[i].script_float = 90; 
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

		
		monitor_cameras[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );	
	}

	
	
	
	level thread maps\_securitycamera::camera_tap_start( feedbox, monitor_cameras );
	

	feedbox waittill("tapped");
	flag_set("feed_tapped");
}
