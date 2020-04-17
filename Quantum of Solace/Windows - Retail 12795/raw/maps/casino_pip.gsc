#include maps\_utility;
main()
{
		//level thread elevator();
		//level thread ledge();
	
}

// ---------------------//

intro_pip()
{
	//start with large pip
	SetDVar("r_pipSecondaryX", 0.04);
	SetDVar("r_pipSecondaryY", 0.04);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "1 1 1.0 1.0");		//full image, without cropping
	
	//put camera for secondary pip in elevator
	//level.player setsecuritycameraparams( 80, 3/4 );
	//level.cameraID_elevator = level.player securityCustomCamera_Push("world", (-960, 860, 750), (0,0,0), 0.0);


	//level waittill( "setup_cutscene" );
	
	//main window
	//shrunk in corner
//	SetDVar("r_pip1Anchor", 8);						// use bottom corner anchor point
//	SetDVar("r_pip1Scale", "0 0 1.0 1.0");
//	SetDVar("r_pipMainMode", "1");

	//scale secondary
	//SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		

//	for( i = 1; i > 0.5; i = i - 0.04)
//	{
//		SetDVar("r_pipSecondaryScale", i + " " + i +" 1 1");		// scale image, without cropping
//		wait( 0.05);
//	}
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
//	level.player animatepip( 500, 0, 0.04, 0.04, 0.5, 0.5 );
//	wait(0.5);	//this could be shorter 

	//start cutscene because bond 2nd PIP has shrunk
	//level notify( "start_e1_igc" );
	
	//expand main window with cutscene
//	for( i = 0; i < 0.8; i = i + 0.04)
//	{
//		SetDVar("r_pip1Scale", i + " " + i +" 1 1");		// scale image, without cropping
//		wait( 0.05);
//	}
	
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
//	level.player animatepip( 500, 1, -1,-1, 1, 0.7 );
//	wait(0.5);
	
	//level waittill( "cutscene_done" );

//	//hide secondary
//	SetDVar("r_pipSecondaryMode", 0 );			
//
//	//swap main with secondary
//	SetDVar("r_pip1X", 0.04);
//	SetDVar("r_pip1Y", 0.04);
//	SetDVar("r_pip1Anchor", 0);						// use top right anchor point
//	SetDVar("r_pip1Scale", "0.5 0.5 1.0 1.0");
//	SetDVar("r_pipMainMode", "1");


	//move to middle?

	//expand to letterbox
//	for( i = 0.5; i < 1; i = i + 0.04)
//	{
//		SetDVar("r_pip1Scale", i + " " + i +" 0 0");		// scale image, without cropping
//		wait( 0.05);
//	}
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
//	level.player animatepip( 500, 1, -1, -1, 0.7, 0.7 );
//	wait(0.5);


	
	level waittill( "musicstinger_start" );
	
//	//(time,screen,x,y,scalex, scaley, cropx, cropy)
//	level.player animatepip( 500, 1, -1, -1, 1, 1 );
//	wait(0.5);
	
	//reset to pip to default
	SetDVar("r_pip1X", 0 );
	SetDVar("r_pip1Y", 0 );
				
	//back to non PIP
	SetDVar("r_pipMainMode", "0");

	SetDVar("r_pipSecondaryX", -0.2 );						// start off screen
	SetDVar("r_pipSecondaryY", -0.13);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		// scale image, without cropping
	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio

}


// ---------------------//

ledge()
{


	
	//waittill nr the open window	
	trig = getent( "move_pip1", "targetname" );
	trig waittill( "trigger" );
	
	//crop and move down
	level thread ledge_main_crop();
	level thread ledge_main_move();
	
	//PIP
	level thread ledge_pip();
	level thread check_death();
}

check_death()
{

	
	level endon("ledge_pip_done");

	
	iprintlnbold("worked");
	level.player waittill("damage");
	SetDVar("r_pipSecondaryMode", 5);
	level.player animatepip( 1, 0, 1, -1 );
		//wait(1);
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	


}


ledge_main_crop()
{

		//no hud
		//setSavedDvar("cg_drawHUD","0");
		setdvar("ui_hud_showstanceicon", "0");
		setsaveddvar ( "ammocounterhide", "1" );
		
		//set border size and color
		setdvar("cg_pipmain_border", 2);
		setdvar("cg_pipmain_border_color", "0 0 0.2 1");

		//set main window
		SetDVar("r_pipMainMode", 1);	//set window
		SetDVar("r_pip1Anchor", 4);		// use top middle anchor point
//	//SetDVar("r_pip1Scale", "0.9 0.6 0.9 0.6");		// scale image, without cropping
//	//SetDVar("r_pip1Scale", "1 0.6 0 0");		// scale image, without cropping
//	
//	for( i = 1; i > 0.5; i = i - 0.02)
//	{
//		SetDVar("r_pip1Scale", "1 " + i +" 0 0");		// scale image, without cropping
//		wait( 0.05);
//	}
	
	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 1000, 1, -1, -1, 1, 0.5, 0, 0);
	level.player waittill("animatepip_done");
		
	level notify( "window_crop" );
		
	//level waittill( "off_ledge" );
	level waittill( "window_up" );

	//uncrop
	
	//SetDVar("r_pip1Scale", "1 1 1 1");		
//	for( i = 0.5; i < 1; i = i + 0.02)
//	{
//		SetDVar("r_pip1Scale", "1 " + i +" 0 0");		// scale image, without cropping
//		wait( 0.05);
//	}

	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 1000, 1, -1, -1, 1, 1, 0, 0);
	wait(1);
	level notify("ledge_pip_done");
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );

}


ledge_main_move()
{
	
	level waittill( "window_crop" );
	
	//iprintlnbold("move window down");
	
	//SetDVar("r_pip1Y", 0.17);			//move lower
	//move lower, .015 is one line
//	for( i = 0; i < 0.15; i = i + 0.015)
//	{
//		SetDVar("r_pip1Y", i);
//		wait(.05);	//one frame
//	}
	
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	//move back up
//	for( i = .15; i > 0; i = i - 0.015)
//	{
//		SetDVar("r_pip1Y", i);
//		wait(.05);	//one frame
//	}
	
		level.player animatepip( 500, 1, -1, 0 );
		wait(0.5);
	
		level notify( "window_up" );
}



ledge_pip()
{
	//moved earlier. will crash unless set up right away - bug?

	//setup PIP


	SetDVar("r_pipSecondaryX", -0.2 );						// start off screen
	SetDVar("r_pipSecondaryY", -0.13);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		// scale image, without cropping
	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio


//	SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		
	level waittill( "window_down" );
		
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);
	level.cameraID_bomber = level.player securityCustomCamera_Push("world", level.player, ( 150, 1360, 785), ( -8,0,0 ), 0.0);
	//cameraID_bomber = level.player securityCustomCamera_Push( "entity_abs", level.player, level.player, ( -120, 90, 72),(0, 0, 0), (0, 0, 60), 1.0 );
		
	//iprintlnbold("PIP_moving");
	
	//draw in front
	SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		

	//set border and color
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");
	
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 0.25, -1 );

	wait(0.5);

//	trig = getent( "move_pip1", "targetname" );
//	trig waittill( "trigger" );
//
//	//move pip right as bond moves right on ledge
//	for( i = .05 ; i < 0.25; i = i + 0.016)
//	{
//		SetDVar("r_pipSecondaryX", i);
//		wait(.05);	//one frame
//	}
//
//	trig = getent( "move_pip2", "targetname" );
//	trig waittill( "trigger" );
//
////	//move pip right as bond moves right on ledge
////	for( i = 0.25; i < 0.5; i = i + 0.016)
////	{
////		SetDVar("r_pipSecondaryX", i);
////		wait(.05);	//one frame
////	}
////	
//
//	//move pip right as bond moves right on ledge
//	for( i = .25 ; i < 0.75; i = i + 0.016)
//	{
//		SetDVar("r_pipSecondaryX", i);
//		wait(.05);	//one frame
//	}
	
	trig = getent( "move_pip3", "targetname" );
	trig waittill( "trigger" );

	
	//move pip offscreen fast and turn off
//	for( i = .25 ; i < 1; i = i + 0.04)
//	{
//		SetDVar("r_pipSecondaryX", i);
//		wait(.05);	//one frame
//	}
	
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	//wait(2);
	
	level notify( "off_ledge" );
	
	//reset
	SetDVar("r_pipSecondaryMode", 0);						
	level.player securityCustomCamera_Pop( level.cameraID_bomber );
	
}

// ---------------------//


elevator()
{
	
	//set mode to 1
	
	//set anchor pt to 4
	
	//scale crop x to .001
	
	//set a fake window and move so it looks elevator moving
	
	//move 0 to 1 for door to open
	
	
	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	
	//doors start closed 
	SetDVar("r_pip1Anchor", 4);						// use middle anchor point
	SetDVar("r_pip1Scale", "0.005 1 0 0");		// leave a sliver to see
		
	//simulate elevator moving
	//iprintlnbold("elevator moving");
	SetDVar("r_pip1Y", -1 );
	for( i = -1 ; i < 1; i = i + 0.015)
	{
		SetDVar("r_pip1Y", i);
		wait(.05);	//one frame
	}
	
	//reset
	SetDVar("r_pip1Y", -1 );
	
	//stop at floor
	for( i = -1 ; i < 0; i = i + 0.015)
	{
		SetDVar("r_pip1Y", i);
		wait(.05);	//one frame
	}
	
	wait(1);	//ding!
	
	//open doors
	for( i = 0.005; i < 1; i = i + 0.02)
	{
		SetDVar("r_pip1Scale", i + " 1" +" 0 0");		// no scale
		wait( 0.05);
	}
	
	level notify( "doors_open" );
		
	
}

//split screen with pip
//Joe Chiang

split_screen_spa_1()
{

	//trig = getent( "trigger_exit_cover", "targetname" );
	//setup PIP



	//no hud
	//setSavedDvar("cg_drawHUD","0");
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );
	
	//no phone/fixes bug - jc
	forcephoneactive(false);
	wait(0.2);
	setSavedDvar("cg_disableBackButton","1"); // disable
	wait(0.2);
	forcephoneactive(false);

	//crop and move down
	level thread main_crop_spa_1();
	level thread main_move_spa_1();
	
	//PIP
	level thread second_move_spa_1();
		
}


main_crop_spa_1()
{

	//set border size and color
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	SetDVar("r_pip1Anchor", 3);		// use top middle anchor point

	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	wait(0.6);
		
	level notify( "window_crop" );
		
	//wait(7);
	level waittill( "window_up" );

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	wait(0.5);
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	//setSavedDvar("cg_drawHUD","1");
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );
	//phone back
	setSavedDvar("cg_disableBackButton","0"); // disable
}

//
main_move_spa_1()
{
	
	level waittill( "window_crop" );
		
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.6);
	
	level notify( "window_down" );
	
	level waittill( "off_screen" );
	//wait(7);

	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}


//pip
second_move_spa_1()
{
	level.player setsecuritycameraparams( 65, 3/4 );

	SetDVar("r_pipSecondaryX", -0.2 );						// start off screen
	SetDVar("r_pipSecondaryY", -0.13);						// place top left corner of display safe zone
	//SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		// scale image, without cropping
	//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
	wait(0.05);	//need this or it will crash

	
	
	level waittill("window_down");
	level.cameraID_spa = level.player SecurityCustomCamera_push("world", (-896.95, 1454.75, 836.43), (9.38, 106.86, 0.0), 0.0);
	//level.cameraID_elevator = level.player securityCustomCamera_Push("world", (-960, 860, 750), (0,0,0), 0.0);
	
	SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		
	//SetDVar("r_lodBias", -500);


	level.player animatepip( 500, 0, 0.25, -1 );
	wait(7);

	//trig waittill( "trigger" );
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_screen" );
	//wait(7);

	//reset
	SetDVar("r_pipSecondaryMode", 0);
	level.player securityCustomCamera_Pop( level.cameraID_spa );
						
	//SetDVar("r_lodBias", 0);					
}

split_screen_spa_2()
{
	//no hud
	//setSavedDvar("cg_drawHUD","0");
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );

	//let anim play before split screen
	//wait(2);
	
	//crop and move down
	level thread main_crop_spa_2();
	level thread main_move_spa_2();
	
	//PIP
	level thread second_move_spa_2();
		
}


main_crop_spa_2()
{
	
	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	SetDVar("r_pip1Anchor", 3);		// use top middle anchor point

	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	wait(0.6);
		
	level notify( "window_crop" );
		
	//wait(7);
	level waittill( "window_up" );

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	wait(0.5);
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	//setSavedDvar("cg_drawHUD","1");
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );

}

//
main_move_spa_2()
{
	
	level waittill( "window_crop" );
		
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.6);
	
	level notify( "window_down" );
	
	level waittill( "off_screen" );
	//wait(7);

	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}


//pip
second_move_spa_2()
{
	//trig = getent( "trigger_exit_cover", "targetname" );
	//setup PIP
	SetDVar("r_pipSecondaryX", -0.2 );						// start off screen
	SetDVar("r_pipSecondaryY", -0.13);						// place top left corner of display safe zone
	//SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		// scale image, without cropping
	//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
	wait(0.05);	//need this or it will crash
	
	
	level waittill("window_down");
	level.cameraID_spa = level.player SecurityCustomCamera_push( "world", (-1436.17, 1477.75, 864.43), (8.54, 60.21, 0.0), 0.0);
	
	SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		
	//SetDVar("r_lodBias", -500);


	level.player animatepip( 500, 0, 0.25, -1 );
	wait(5);

	//trig waittill( "trigger" );
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_screen" );
	//wait(7);

	//reset
	SetDVar("r_pipSecondaryMode", 0);		
	level.player securityCustomCamera_Pop( level.cameraID_spa );
				
	//SetDVar("r_lodBias", 0);					
}
