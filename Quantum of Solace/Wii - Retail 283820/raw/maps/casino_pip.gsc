#include maps\_utility;
main()
{
		
		
	
}



intro_pip()
{
	
	SetDVar("r_pipSecondaryX", 0.04);
	SetDVar("r_pipSecondaryY", 0.04);						
	SetDVar("r_pipSecondaryAnchor", 0);						
	SetDVar("r_pipSecondaryScale", "1 1 1.0 1.0");		
	
	
	
	


	
	
	
	




	
	






	



	
	
	
	





	
	


	
	












	

	





	




	
	level waittill( "musicstinger_start" );
	



	
	
	SetDVar("r_pip1X", 0 );
	SetDVar("r_pip1Y", 0 );
				
	
	SetDVar("r_pipMainMode", "0");

	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	SetDVar("r_pipSecondaryAnchor", 4);						
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		
	SetDVar("r_pipSecondaryAspect", false);					

	
	level.player SecurityCustomCamera_change(level.cameraID_elevator , "world", (level.player.origin), (0.0, 0.0, 0.0), 0.0);
	level.player SecurityCustomCamera_pop(level.cameraID_elevator);
}




ledge()
{


	
	
	trig = getent( "move_pip1", "targetname" );
	trig waittill( "trigger" );
	
	
	level thread ledge_main_crop();
	level thread ledge_main_move();
	
	
	level thread ledge_pip();
}


ledge_main_crop()
{

		
		
		setdvar("ui_hud_showstanceicon", "0");
		setsaveddvar ( "ammocounterhide", "1" );
		
		
		setdvar("cg_pipmain_border", 2);
		setdvar("cg_pipmain_border_color", "0 0 0.2 1");

		
		SetDVar("r_pipMainMode", 1);	
		SetDVar("r_pip1Anchor", 4);		








	
	
	
	level.player animatepip( 1000, 1, -1, -1, 1, 0.5, 0, 0);
	wait(1);
		
	level notify( "window_crop" );
		
	
	level waittill( "window_up" );

	
	
	






	
	level.player animatepip( 1000, 1, -1, -1, 1, 1, 0, 0);
	wait(1);
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );

}


ledge_main_move()
{
	
	level waittill( "window_crop" );
	
	
	
	
	





	
	
	level.player animatepip( 500, 1, -1, 0.19 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	





	
		level.player animatepip( 500, 1, -1, 0 );
		wait(0.5);
	
		level notify( "window_up" );
}



ledge_pip()
{
	

	


	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	SetDVar("r_pipSecondaryAnchor", 4);						
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		
	SetDVar("r_pipSecondaryAspect", false);					



	level waittill( "window_down" );
		
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);
	level.cameraID_bomber = level.player securityCustomCamera_Push("world", level.player, ( 150, 1360, 785), ( -8,0,0 ), 0.0);
	
		
	
	
	
	SetDVar("r_pipSecondaryMode", 5);						

	
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");
	
	
	level.player animatepip( 500, 0, .25, -1, 0.8, 0.5 );

	wait(0.5);




























	
	trig = getent( "move_pip3", "targetname" );
	trig waittill( "trigger" );

	
	





	
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	
	level notify( "off_ledge" );
	
	
	SetDVar("r_pipSecondaryMode", 0);						
	
	level.player SecurityCustomCamera_change(level.cameraID_bomber , "offset", (level.player.origin), (0.0, 0.0, 0.0), 0.0);
	level.player securityCustomCamera_pop(level.cameraID_bomber);
}




elevator()
{
	
	
	
	
	
	
	
	
	
	
	
	
	
	SetDVar("r_pipMainMode", 1);	
	
	
	SetDVar("r_pip1Anchor", 4);						
	SetDVar("r_pip1Scale", "0.005 1 0 0");		
		
	
	
	SetDVar("r_pip1Y", -1 );
	for( i = -1 ; i < 1; i = i + 0.015)
	{
		SetDVar("r_pip1Y", i);
		wait(.05);	
	}
	
	
	SetDVar("r_pip1Y", -1 );
	
	
	for( i = -1 ; i < 0; i = i + 0.015)
	{
		SetDVar("r_pip1Y", i);
		wait(.05);	
	}
	
	wait(1);	
	
	
	for( i = 0.005; i < 1; i = i + 0.02)
	{
		SetDVar("r_pip1Scale", i + " 1" +" 0 0");		
		wait( 0.05);
	}
	
	level notify( "doors_open" );
		
	
}




split_screen_spa_1()
{

	
	



	
	
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );

	
	
	
	
	level thread main_crop_spa_1();
	level thread main_move_spa_1();
	
	
	level thread second_move_spa_1();
		
}


main_crop_spa_1()
{

	
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 3);		

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	wait(0.6);
		
	level notify( "window_crop" );
		
	
	level waittill( "window_up" );

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	wait(0.5);
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );

}


main_move_spa_1()
{
	
	level waittill( "window_crop" );
		
	
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.6);
	
	level notify( "window_down" );
	
	level waittill( "off_screen" );
	

	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}



second_move_spa_1()
{
	level.player setsecuritycameraparams( 65, 3/4 );

	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	
	
	
	wait(0.05);	

	
	
	level waittill("window_down");
	level.cameraID_spa = level.player SecurityCustomCamera_push("world", (-896.95, 1454.75, 836.43), (9.38, 106.86, 0.0), 0.0);
	
	
	SetDVar("r_pipSecondaryMode", 5);						
	


	level.player animatepip( 500, 0, 0.25, -1 );
	wait(7);

	
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_screen" );
	

	
	SetDVar("r_pipSecondaryMode", 0);
	level.player securityCustomCamera_Pop( level.cameraID_spa );
						
	
}

split_screen_spa_2()
{
	
	
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );

	
	
	
	
	level thread main_crop_spa_2();
	level thread main_move_spa_2();
	
	
	level thread second_move_spa_2();
		
}


main_crop_spa_2()
{
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 3);		

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	wait(0.6);
		
	level notify( "window_crop" );
		
	
	level waittill( "window_up" );

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	wait(0.5);
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );

}


main_move_spa_2()
{
	
	level waittill( "window_crop" );
		
	
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.6);
	
	level notify( "window_down" );
	
	level waittill( "off_screen" );
	

	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}



second_move_spa_2()
{
	
	
	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	
	
	
	wait(0.05);	
	
	
	level waittill("window_down");
	level.cameraID_spa = level.player SecurityCustomCamera_push( "world", (-1436.17, 1477.75, 864.43), (8.54, 60.21, 0.0), 0.0);
	
	SetDVar("r_pipSecondaryMode", 5);						
	


	level.player animatepip( 500, 0, 0.25, -1 );
	wait(5);

	
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_screen" );
	

	
	SetDVar("r_pipSecondaryMode", 0);		
	level.player securityCustomCamera_Pop( level.cameraID_spa );
				
	

	
	level.player SecurityCustomCamera_change(level.cameraID_spa , "offset", (level.player.origin), (0, -60.21, 0.0), 0.0);
	level.player securityCustomCamera_pop(level.cameraID_spa);
}
