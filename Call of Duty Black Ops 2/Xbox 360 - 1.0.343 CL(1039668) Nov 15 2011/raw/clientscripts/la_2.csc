// Test clientside script for la_2

#include clientscripts\_utility;
#include clientscripts\_filter;

main()
{
	clientscripts\la_2_fx::main();
	
	// _load!
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);
	clientscripts\_claw_grenade::main();
	thread clientscripts\la_2_amb::main();

	register_clientflag_callback("player", 0, ::player_flag0_handler);		
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);
	
	// 640 x 480 of a 1024x1024 buffer
	ui3dsetwindow( 0, 0, 0, 1, 1 );		

	println("*** Client : la_2 running...");

       	level thread la2_setup_fullscreen_postfx();

}

la2_setup_fullscreen_postfx()
{
	waitforclient(0);
	
      	init_filter_hud_outline( level.localPlayers[0] );
      	enable_filter_hud_outline( level.localPlayers[0], 0, 0 );
	level.localPlayers[0] setSonarEnabled(1); 	//have to turn it off at sometime
}


player_flag0_handler(localClientNum, set, newEnt)
{
	if(set)
	{
		wait(.05);
		self.visor = Spawn(self GetLocalClientNumber(), self get_eye(), "script_model");
		self.visor.angles = self.angles;
		self.visor SetModel( "test_ui_hud_visor" );
		self.visor LinkToCamera(4, ( 2.35, 0, 0.1 ) );
	}
	else
	{
		wait 0.05;
		if ( IsDefined( self.visor ) )
		{
			self.visor UnLinkFromCamera();
			self.visor Delete();
		}
	}	
}
