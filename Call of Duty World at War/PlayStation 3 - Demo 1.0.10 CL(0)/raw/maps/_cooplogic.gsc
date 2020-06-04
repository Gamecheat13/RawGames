#include maps\_utility;

init()
{
	level.splitscreen = isSplitScreen();
	
	// CODER_MOD: Austin (5/5/08): changed string refs to point to MENU str file
	if ( level.splitScreen )
		precacheString( &"GAME_ENDED_GAME" );
	else
		precacheString( &"GAME_HOST_ENDED_GAME" );
	
	if ( !isDefined( game["state"] ) )
		game["state"] = "playing";

	level.gameEnded = false;
	level.postRoundTime = 2.0;
	level.forcedEnd = false;
	level.hostForcedEnd = false;
}

forceEnd()
{
	if ( level.hostForcedEnd || level.forcedEnd )
		return;

    // CODER_MOD: GMJ (08/31/08) Let code side know the player has quit.	
    forcelevelend();

	level.forcedEnd = true;
	level.hostForcedEnd = true;
	
	// CODER_MOD: Austin (5/5/08): changed string refs to point to MENU str file
	if ( level.splitscreen )
		endString = "";
	else
		endString = &"GAME_HOST_ENDED_GAME";
	
	makeDvarServerInfo( "ui_text_endreason", endString );
	setDvar( "ui_text_endreason", endString );
	thread endGame( endString );
}

endGame( endReasonText )
{
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" )
		return;

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
		player thread roundEndDoF( 4.0 );
		
		player setClientDvar( "cg_everyoneHearsEveryone", "1" );
	}
		
	// change this to a nicer print ala mp
	if( isDefined( endReasonText ) )
	{
		iprintln( endReasonText );
	}
	
	if ( !level.hostForcedEnd && !level.forcedEnd )
		roundEndWait( level.postRoundTime, true );
	
	level.intermission = true;
	
	//regain players array since some might've disconnected during the wait above
	players = get_players();
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player Closeingamemenu();
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
				continue;
				
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
				continue;
				
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

roundEndDOF( time )
{
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}
