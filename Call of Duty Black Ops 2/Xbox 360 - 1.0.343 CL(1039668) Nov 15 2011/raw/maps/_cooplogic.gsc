#include maps\_utility;

init()
{
	level.splitscreen = isSplitScreen();
	
	// CODER_MOD: Austin (5/5/08): changed string refs to point to MENU str file
	if ( level.onlineGame || level.systemLink )
	{
		precacheString( &"GAME_HOST_ENDED_GAME" );
	}
	else
	{
		precacheString( &"GAME_ENDED_GAME" );
	}
	
	if ( !isDefined( game["state"] ) )
	{
		game["state"] = "playing";
	}

	level.gameEnded = false;
	level.postRoundTime = 4.0;
	level.forcedEnd = false;
	level.hostForcedEnd = false;
}

forceEnd()
{
	if ( level.hostForcedEnd || level.forcedEnd )
	{
		return;
	}

    // CODER_MOD: GMJ (08/31/08) Let code side know the player has quit.	
    forcelevelend();

	level.forcedEnd = true;
	level.hostForcedEnd = true;
	
	// CODER_MOD: Austin (5/5/08): changed string refs to point to MENU str file
	if ( level.onlineGame || level.systemLink )
	{
		endString = &"GAME_HOST_ENDED_GAME";
	}
	else
	{
		endString = "";
	}
	
	makeDvarServerInfo( "ui_text_endreason", endString );
	SetDvar( "ui_text_endreason", endString );
	thread endGame( endString );
}

endGameMessage( endReasonText )
{
	self endon ( "disconnect" );

	if ( level.splitscreen && !IsDefined(level.zombietron_mode) )
	{
		titleSize = 2.0;
		spacing = 10;
		font = "default";
	}
	else
	{
		titleSize = 3.0;
		spacing = 50;
		font = "objective";
	}

	const duration = 60000;

	outcomeTitle = maps\_hud_util::createFontString( font, titleSize,self );
	outcomeTitle maps\_hud_util::setPoint( "TOP", undefined, 0, spacing );
	outcomeTitle setText( endReasonText );

	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;
	outcomeTitle setPulseFX( 100, duration, 1000 );

	if( IsDefined(level.zombietron_mode) )
	{
		players = get_players();
		players[0] clearclientflag( level._ZT_PLAYER_CF_SHOW_SCORES );
	}

	//destroyHudElem( outcomeTitle );
}

endGame( endReasonText )
{
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" )
	{
		return;
	}

	visionSetNaked( "mpOutro", 2.0 );
	
	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level.inGracePeriod = false;
	level notify ( "game_ended" );
	
	// freeze players
	players = get_players();
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player freezePlayerForRoundEnd();
		player thread roundEndDoF( /*4.0*/ );
		
		player setClientDvar( "cg_everyoneHearsEveryone", "1" );

		if( IsDefined(level.zombietron_mode) )
		{
			// This prevents the player from being able to bring up the start menu again
			self.sessionstate = "intermission";
		}
		// change this to a nicer print ala mp
		if( isDefined( endReasonText ) )
		{
			//iprintln( endReasonText );
			player endGameMessage( endReasonText );
		}
	}
		
	level.intermission = true;
	roundEndWait( level.postRoundTime, true );
	
	//regain players array since some might've disconnected during the wait above
	players = get_players();
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player closeInGameMenu();
	}
	
	logString( "game ended" );
	
	exitLevel( false );
}

roundEndWait( defaultDelay, matchBonus )
{
	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = get_players();
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
			{
				continue;
			}
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}

	if ( !matchBonus )
	{
		wait ( defaultDelay );
		return;
	}

  wait ( defaultDelay );

	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = get_players();
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
			{
				continue;
			}
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}
}

freezePlayerForRoundEnd()
{
	self closeMenu();
	self closeInGameMenu();
	
	self freezeControls( true );
//	self disableWeapons();
}

//PARAMETER CLEANUP
roundEndDOF( /*time*/ )
{
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}
