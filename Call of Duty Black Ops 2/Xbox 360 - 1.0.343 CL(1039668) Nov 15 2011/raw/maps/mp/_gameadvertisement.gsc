#include maps\mp\_utility;

init()
{	
	// Session advertisment
/#
	level.sessionAdvertStatus = true;
	thread sessionAdvertismentUpdateDebugHud();
#/
	thread sessionAdvertisementCheck();

	// QoS advertisment for auto join 
	// (disabled)
	//thread resetSessionQoSData();
	//thread setSessionQoSData();
}

/#
sessionAdvertismentUpdateDebugHud()
{
	level endon( "game_end" );
	
	debug_hud = undefined;

	while( true )
	{
		wait( 1 );
		
		sessionAdvertStatusTest = "Session is advertised";
		
		if( level.sessionAdvertStatus == false )
		{
			sessionAdvertStatusTest = "Session is not advertised";
		}			
		
		showDebugHud = GetDvarIntDefault( "sessionAdvertShowDebugHud", 0 );
		if( isDefined( debug_hud ) )
		{
			if( showDebugHud == 0 )
			{
				debug_hud destroy();				
				debug_hud = undefined;
			}
			else
			{
				debug_hud setText( sessionAdvertStatusTest );
			}				
		}
		else
		{
			if( showDebugHud != 0 )
			{
				debug_hud = maps\mp\gametypes\_dev::new_hud( "session_advert", "debug_hud", 0, 0, 1 );			
				debug_hud.hidewheninmenu = true;
				debug_hud.horzAlign = "right";
				debug_hud.vertAlign = "middle";
				debug_hud.alignX = "right";
				debug_hud.alignY = "middle";
				debug_hud.x = 0;
				debug_hud.y = 0;
				debug_hud.foreground = true;
				debug_hud.font = "default";
				debug_hud.fontScale = 1.0;
				debug_hud.color = ( 1.0, 1.0, 1.0 );
				debug_hud.alpha = 1;
				
				debug_hud setText( sessionAdvertStatusTest );		
			}		
		}
	}
}
#/

setAdvertisedStatus( onOff )
{
/#
	level.sessionAdvertStatus = onOff;
#/	
	changeAdvertisedStatus( onOff );
}

sessionAdvertisementCheck()
{
	if( SessionModeIsPrivate() )
		return;
		
	if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) )
	{
		setAdvertisedStatus( false );
		return;
	}
		
	level endon( "game_end" );
	
	level waittill( "prematch_over" );

	while( true )
	{
		sessionAdvertCheckwait = GetDvarIntDefault( "sessionAdvertCheckwait", 1 );
		sessionAdvertScorePercent = GetDvarIntDefault( "sessionAdvertScorePercent", 10 );
		sessionAdvertTimeLeft = GetDvarIntDefault( "sessionAdvertTimeLeft", 30 ) * 1000;
		
		wait( sessionAdvertCheckwait );

		//====================================================================
		//	score check				
		if ( level.scoreLimit )
		{
			if ( level.teamBased == false ) //free for all
			{
				highestScore = 0;
				players = GET_PLAYERS();
				for( i = 0; i < players.size; i++)
				{
					if( players[i].score > highestScore )
						highestScore = players[i].score;
				}
				scorePercentageLeft = 100 - (( highestScore / level.scoreLimit ) * 100);
				if( sessionAdvertScorePercent >= scorePercentageLeft )
				{	
					setAdvertisedStatus( false ); 	//turn off game advertisment
					continue;
				}
			}
			else //team based games
			{			
				if( isRoundBased() == false )
				{
					scorePercentageLeft = 100 - (( game["teamScores"]["allies"] / level.scoreLimit ) * 100);
					if( sessionAdvertScorePercent >= scorePercentageLeft )
					{	
						setAdvertisedStatus( false ); 	//turn off game advertisment
						continue;
					}
				
					scorePercentageLeft = 100 - (( game["teamScores"]["axis"] / level.scoreLimit ) * 100);
					if( sessionAdvertScorePercent >= scorePercentageLeft )
					{	
						setAdvertisedStatus( false ); 	//turn off game advertisment
						continue;
					}
				}
			}
		}
		
		//====================================================================
		//	time left check
		maxTime = GetDvarint( "scr_" + level.gameType + "_timelimit" );
		
		if( maxTime != 0 )
		{		
			//check if there is less the 30 seconds left
			timeLeft = maps\mp\gametypes\_globallogic_utils::getTimeRemaining();
			if( isRoundBased() == false )
			{
				if( sessionAdvertTimeLeft >= timeLeft )
				{	
					setAdvertisedStatus( false ); 	//turn off game advertisment
					continue;
				}	
			}
			else
			{
				if( sessionAdvertTimeLeft >= timeLeft && true == isLastRound() )
				{	
					setAdvertisedStatus( false ); 	//turn off game advertisment
					continue;
				}
			}
		}
		
		//if we want to check for a percentage of time left
		//timeLimit = level.timeLimit * 60 * 1000;
		//timeLeft = maps\mp\gametypes\_globallogic_utils::getTimeRemaining();
		//timePercentageLeft = timeLeft / timeLimit * 100;
		//
		//if( advertisePercentageTimeLeft >= timePercentageLeft )
		//{	
		//	setAdvertisedStatus( false ); 	//turn off game advertisment
		//	return;
		//}
		
		setAdvertisedStatus( true );	
	}
}

teamScoreLimitSoon( isTrue )
{
	if( isTrue == true )
		setAdvertisedStatus( false );	
}

playerScoreLimitSoon( isTrue )
{
	if( isTrue == true )
		setAdvertisedStatus( false );	
}

resetSessionQoSData()
{
	level waittill("game_ended");
	
	//resetQosGameDataPayload();	
}

getMatchType()
{
	if( GameModeIsMode( level.GAMEMODE_THEATER ) )
	{
		return 4;
	}
	else if( GameModeIsMode( level.GAMEMODE_BASIC_TRAINING ) )
	{
		return 3;
	}
	else if( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) )
	{
		return 2;
	}
	else if( GameModeIsMode( level.GAMEMODE_PRIVATE_MATCH ) )
	{
		return 1;
	}

	return 0; //Player Match
}

setSessionQoSData()
{
	level endon( "game_end" );
	
	teamTypeNonTeamBased = 0;
	teamTypeTeamBased = 1;
	teamTypeRoundTeamBased = 2;
		
	gameType = maps\mp\gametypes\_persistence::getGameTypeName();	
	mapName = GetDvar( "mapname" );
	
	matchType = getMatchType();	
	
	partyPrivacy = GetLocalProfileInt( "party_privacyStatus" );
					
	level waittill( "prematch_over" );
	
	while( true )
	{
		sessionQosUpdate = GetDvarIntDefault( "sessionQosUpdate", 5 );
		
		wait( sessionQosUpdate );

		timeLeft = int( maps\mp\gametypes\_globallogic_utils::getTimeRemaining() + 0.5 );
			
		highestScore = -9999;
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++)
		{
			if( players[i].score > highestScore )
				highestScore = players[i].score;
		}
		
		if ( level.teamBased == false )
		{
			setQosGameDataPayload( gameType, mapName, matchType, partyPrivacy, teamTypeNonTeamBased, timeLeft, highestScore );
			continue;
		}
		
		alliesTeamScore = game["teamScores"]["allies"];
		axisTeamScore = game["teamScores"]["axis"];
			
		if( isRoundBased() == false )
		{
			setQosGameDataPayload( gameType, mapName, matchType, partyPrivacy, teamTypeTeamBased, timeLeft, highestScore, alliesTeamScore, axisTeamScore );
			continue;
		}	
		
		alliesRoundsWon = getRoundsWon( "allies" );
		axisRoundsWon = getRoundsWon( "axis" );
			
		//roundLimit = level.roundLimit;
		roundLimit = level.scoreLimit;
		
		setQosGameDataPayload( gameType, mapName, matchType, partyPrivacy, teamTypeRoundTeamBased, timeLeft, highestScore, alliesTeamScore, axisTeamScore, alliesRoundsWon, axisRoundsWon, roundLimit );
	}
}
