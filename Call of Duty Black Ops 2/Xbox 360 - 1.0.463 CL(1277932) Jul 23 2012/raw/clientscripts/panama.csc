// Test clientside script for panama

#include clientscripts\_utility;
#include clientscripts\_filter;

#define CLIENT_FLAG_MOVER_EXTRA_CAM	1
#define CLIENT_FLAG_PLAYER_ZODIAC		7

main()
{
	// _load!
	clientscripts\_load::main();

	clientscripts\panama_fx::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\panama_amb::main();
	
	clientscripts\_swimming::main();  // enable swimming feature
	
	register_clientflag_callback( "player", 0, ::put_on_hat ); // test only: do not call
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MOVER_EXTRA_CAM, ::toggle_extra_cam );
	register_clientflag_callback( "player", CLIENT_FLAG_PLAYER_ZODIAC, ::toggle_zodiac_overlay );

	// This needs to be called after all systems have been registered.
	waitforclient(0);
	
	println("*** Client : panama running...");
	
	init_filter_zodiac_raindrops( level.localPlayers[0] );
	
	set_player_viewmodel( "c_usa_woods_panama_viewhands" );
}

toggle_extra_cam( localClientNum, set, newEnt )
{
	if ( !IsDefined( level.extraCamActive ) )
	{
		level.extraCamActive = false;
	}
    
    if ( !level.extraCamActive && set )
    {
        PrintLn( "**** extra cam on - client ****" );
                    
        level.extraCamActive = true;
        self IsExtraCam( localClientNum );
    }
    else if ( level.extraCamActive && !set )
    {
    	PrintLn( "**** extra cam on - client ****" );
    	
    	StopExtraCam( localClientNum );
        level.extraCamActive = false;
    }
}

put_on_hat(localClientNum, set, newEnt)
{
	if( set )
	{
		self.m_hat = Spawn( self GetLocalClientNumber(), self GetTagOrigin( "J_HEAD" ), "script_model" );
		self.m_hat SetModel( "c_usa_milcas_woods_cap" );
		
		self.m_hat_linker = Spawn( self GetLocalClientNumber(), self GetTagOrigin( "J_HEAD" ), "script_model" );
		self.m_hat_linker SetModel( "tag_origin" );
		self.m_hat_linker.angles = self.angles;
		
		self.m_hat LinkTo( self.m_hat_linker, "tag_origin", ( 0, 0, 0 ), ( 0, 90, 0 ));
		
		self.m_hat_linker LinkToCamera( 4, ( 12, 0, 1.8 ) );
	}
	else
	{
		if ( IsDefined( self.m_hat ) )
		{
			self.m_hat UnLinkFromCamera();
			self.m_hat Delete();
		}
	}	
}


toggle_zodiac_overlay( localClientNum, set, newEnt )
{
	if ( set )
    {
        PrintLn( "**** wingsuit overlay on ****" );
 		enable_filter_zodiac_raindrops( level.localPlayers[0], 3 );
	}
    else
    {
    	PrintLn( "**** wingsuit overlay off ****" );
    	disable_filter_zodiac_raindrops( level.localPlayers[0], 3 );
    }
}