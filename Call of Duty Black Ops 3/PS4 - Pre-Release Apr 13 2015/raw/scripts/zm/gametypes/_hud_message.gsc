#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic_audio;

#using scripts\zm\_util;

#precache( "string", "MENU_POINTS" );
#precache( "string", "MP_FIRSTPLACE_NAME" );
#precache( "string", "MP_SECONDPLACE_NAME" );
#precache( "string", "MP_THIRDPLACE_NAME" );
#precache( "string", "MP_WAGER_PLACE_NAME" );
#precache( "string", "MP_MATCH_BONUS_IS" );
#precache( "string", "MP_WAGER_IN_THE_MONEY" );
#precache( "string", "MP_DRAW_CAPS" );
#precache( "string", "MP_ROUND_DRAW_CAPS" );
#precache( "string", "MP_ROUND_WIN_CAPS" );
#precache( "string", "MP_ROUND_LOSS_CAPS" );
#precache( "string", "MP_VICTORY_CAPS" );
#precache( "string", "MP_DEFEAT_CAPS" );
#precache( "string", "MP_GAME_OVER_CAPS" );
#precache( "string", "MP_HALFTIME_CAPS" );
#precache( "string", "MP_OVERTIME_CAPS" );
#precache( "string", "MP_ROUNDEND_CAPS" );
#precache( "string", "MP_INTERMISSION_CAPS" );
#precache( "string", "MP_SWITCHING_SIDES_CAPS" );
#precache( "string", "MP_MATCH_BONUS_IS" );
#precache( "eventstring", "faction_popup" );

#namespace hud_message;

function init()
{
	game["strings"]["draw"] = &"MP_DRAW_CAPS";
	game["strings"]["round_draw"] = &"MP_ROUND_DRAW_CAPS";
	game["strings"]["round_win"] = &"MP_ROUND_WIN_CAPS";
	game["strings"]["round_loss"] = &"MP_ROUND_LOSS_CAPS";
	game["strings"]["victory"] = &"MP_VICTORY_CAPS";
	game["strings"]["defeat"] = &"MP_DEFEAT_CAPS";
	game["strings"]["game_over"] = &"MP_GAME_OVER_CAPS";
	game["strings"]["halftime"] = &"MP_HALFTIME_CAPS";
	game["strings"]["overtime"] = &"MP_OVERTIME_CAPS";
	game["strings"]["roundend"] = &"MP_ROUNDEND_CAPS";
	game["strings"]["intermission"] = &"MP_INTERMISSION_CAPS";
	game["strings"]["side_switch"] = &"MP_SWITCHING_SIDES_CAPS";
	game["strings"]["match_bonus"] = &"MP_MATCH_BONUS_IS";
}

function teamOutcomeNotify( winner, isRound, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	team = self.pers["team"];
	if ( isdefined( team ) && team == "spectator" )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( self.currentspectatingclient == level.players[i].clientId )
			{
				team = 	level.players[i].pers["team"];
				break;
			}
		}
	}
	
	if ( !isdefined( team ) || !isdefined( level.teams[team] ) )
		team = "allies";

	// wait for notifies to finish
	while ( self.doingNotify )
		{wait(.05);};

	self endon ( "reset_outcome" );
	
	headerFont = "extrabig";
	font = "default";
	if ( self IsSplitscreen() )
	{
		titleSize = 2.0;
		textSize = 1.5;
		iconSize = 30;
		spacing = 10;
	}
	else
	{
		titleSize = 3.0;
		textSize = 2.0;
		iconSize = 70;
		spacing = 25;
	}

	duration = 60000;

	outcomeTitle = hud::createFontString( headerFont, titleSize );
	outcomeTitle hud::setPoint( "TOP", undefined, 0, 30 );
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeText = hud::createFontString( font, 2.0 );
	outcomeText hud::setParent( outcomeTitle );
	outcomeText hud::setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	
	if ( winner == "halftime" )
	{
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["halftime"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "intermission" )
	{
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["intermission"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "roundend" )
	{
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["roundend"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "overtime" )
	{
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["overtime"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "tie" )
	{
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_draw"] );
		else
			outcomeTitle setText( game["strings"]["draw"] );
		outcomeTitle.color = (0.29, 0.61, 0.7);
		
		winner = "allies";
	}
	else if ( isdefined( self.pers["team"] ) && winner == team )
	{
		//outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_win"] );
		else
			outcomeTitle setText( game["strings"]["victory"] );
		outcomeTitle.color = (0.42, 0.68, 0.46);
	}
	else
	{
		//outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_loss"] );
		else
			outcomeTitle setText( game["strings"]["defeat"] );
		outcomeTitle.color = (0.73, 0.29, 0.19);
	}
	
	//outcomeText.glowColor = (0.2, 0.3, 0.7);
	//if( winner == "axis" )
	//	outcomeText setText( endReasonText, GetDvarString( "g_TeamName_Axis" ) );
	//else
	//	outcomeText setText( endReasonText, GetDvarString( "g_TeamName_Allies" ) );
	
	outcomeText setText( endReasonText );

	outcomeTitle setCOD7DecodeFX( 200, duration, 600 );
	outcomeText setPulseFX( 100, duration, 1000 );
	
	iconSpacing = 100;
	currentX = -(level.teamCount-1) * iconSpacing / 2;
	teamIcons = [];
	teamIcons[team] = hud::createIcon( game["icons"][team], iconSize, iconSize );
	teamIcons[team] hud::setParent( outcomeText );
	teamIcons[team] hud::setPoint( "TOP", "BOTTOM", currentX, spacing );
	teamIcons[team].hideWhenInMenu = false;
	teamIcons[team].archived = false;
	teamIcons[team].alpha = 0;
	teamIcons[team] fadeOverTime( 0.5 );
	teamIcons[team].alpha = 1;
	currentX += iconSpacing;

	foreach( enemyTeam in level.teams )
	{
		if ( team == enemyTeam )
			continue;
			
		teamIcons[enemyTeam] = hud::createIcon( game["icons"][enemyTeam], iconSize, iconSize );
		teamIcons[enemyTeam] hud::setParent( outcomeText );
		teamIcons[enemyTeam] hud::setPoint( "TOP", "BOTTOM", currentX, spacing );
		teamIcons[enemyTeam].hideWhenInMenu = false;
		teamIcons[enemyTeam].archived = false;
		teamIcons[enemyTeam].alpha = 0;
		teamIcons[enemyTeam] fadeOverTime( 0.5 );
		teamIcons[enemyTeam].alpha = 1;
		currentX += iconSpacing;
	}

	teamScores = [];
	teamScores[team] = hud::createFontString( font, titleSize );
	teamScores[team] hud::setParent( teamIcons[team] );
	teamScores[team] hud::setPoint( "TOP", "BOTTOM", 0, spacing );
	//teamScores[team].glowColor = game["colors"][team];
	teamScores[team].glowAlpha = 1;
	if ( isRound )
	{
		teamScores[team] setValue( getTeamScore( team ) );
	}
	else
	{
		teamScores[team] [[level.setMatchScoreHUDElemForTeam]]( team );
	}
	teamScores[team].hideWhenInMenu = false;
	teamScores[team].archived = false;
	teamScores[team] setPulseFX( 100, duration, 1000 );

	foreach( enemyTeam in level.teams )
	{
		if ( team == enemyTeam )
			continue;
			
		teamScores[enemyTeam] = hud::createFontString( headerFont, titleSize );
		teamScores[enemyTeam] hud::setParent( teamIcons[enemyTeam] );
		teamScores[enemyTeam] hud::setPoint( "TOP", "BOTTOM", 0, spacing );
		//teamScores[enemyTeam].glowColor = game["colors"][enemyTeam];
		teamScores[enemyTeam].glowAlpha = 1;
		if ( isRound )
		{
			teamScores[enemyTeam] setValue( getTeamScore( enemyTeam ) );
		}
		else
		{
			teamScores[enemyTeam] [[level.setMatchScoreHUDElemForTeam]]( enemyTeam );
		}
		teamScores[enemyTeam].hideWhenInMenu = false;
		teamScores[enemyTeam].archived = false;
		teamScores[enemyTeam] setPulseFX( 100, duration, 1000 );
	}

	font = "objective";
	matchBonus = undefined;
	if ( isdefined( self.matchBonus ) )
	{
		matchBonus = hud::createFontString( font, 2.0 );
		matchBonus hud::setParent( outcomeText );
		matchBonus hud::setPoint( "TOP", "BOTTOM", 0, iconSize + (spacing * 3) + teamScores[team].height );
		matchBonus.glowAlpha = 1;
		matchBonus.hideWhenInMenu = false;
		matchBonus.archived = false;
		matchBonus.label = game["strings"]["match_bonus"];
		matchBonus setValue( self.matchBonus );
		/*if ( isdefined( level.codPointsMatchScale ) && level.codPointsMatchScale )
		{
			codPointsMatchBonus = undefined;
			codPointsMatchBonus = hud::createFontString( font, 2.0 );
			codPointsMatchBonus hud::setParent( outcomeText );
			codPointsMatchBonus hud::setPoint( "TOP", "BOTTOM", 0, iconSize + (spacing * 4) + leftScore.height );
			codPointsMatchBonus.glowAlpha = 1;
			codPointsMatchBonus.hideWhenInMenu = false;
			codPointsMatchBonus.archived = false;
			codPointsMatchBonus.label = game["strings"]["codpoints_match_bonus"];
			codPointsMatchBonus setValue( round_up( self.matchBonus * level.codPointsMatchScale ) );
		}*/
	}
	
	self thread resetOutcomeNotify( teamIcons, teamScores, outcomeTitle, outcomeText );
}

function teamOutcomeNotifyZombie( winner, isRound, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	team = self.pers["team"];
	if ( isdefined( team ) && team == "spectator" )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( self.currentspectatingclient == level.players[i].clientId )
			{
				team = 	level.players[i].pers["team"];
				break;
			}
		}
	}
	
	if ( !isdefined( team ) || !isdefined( level.teams[team] ) )
		team = "allies";

	// wait for notifies to finish
	while ( self.doingNotify )
		{wait(.05);};

	self endon ( "reset_outcome" );


	if ( self IsSplitscreen() )
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

	outcomeTitle = hud::createFontString( font, titleSize );
	outcomeTitle hud::setPoint( "TOP", undefined, 0, spacing );
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeTitle setText( endReasonText );
	outcomeTitle setPulseFX( 100, duration, 1000 );
	
	self thread resetOutcomeNotify( undefined, undefined, outcomeTitle );
}

function outcomeNotify( winner, isRoundEnd, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	// wait for notifies to finish
	while ( self.doingNotify )
		{wait(.05);};

	self endon ( "reset_outcome" );

	headerFont = "extrabig";
	font = "default";
	if ( self IsSplitscreen() )
	{
		titleSize = 2.0;
		winnerSize = 1.5;
		otherSize = 1.5;
		iconSize = 30;
		spacing = 10;
	}
	else
	{
		titleSize = 3.0;
		winnerSize = 2.0;
		otherSize = 1.5;
		iconSize = 30;
		spacing = 20;
	}

	duration = 60000;

	players = level.placement["all"];
		
	outcomeTitle = hud::createFontString( headerFont, titleSize );
	outcomeTitle hud::setPoint( "TOP", undefined, 0, spacing );
	if ( !util::isOneRound() && !isRoundEnd )
	{
		outcomeTitle setText( game["strings"]["game_over"] );
	}
	else if ( isdefined( players[1] ) && players[0].score == players[1].score && players[0].deaths == players[1].deaths && (self == players[0] || self == players[1]) )
	{
		outcomeTitle setText( game["strings"]["tie"] );
		////outcomeTitle.glowColor = (0.2, 0.3, 0.7);
	}
	else if ( isdefined( players[2] ) && players[0].score == players[2].score && players[0].deaths == players[2].deaths && self == players[2] )
	{
		outcomeTitle setText( game["strings"]["tie"] );
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
	}
	else if ( isdefined( players[0] ) && self == players[0] )
	{
		outcomeTitle setText( game["strings"]["victory"] );
		outcomeTitle.color = (0.42, 0.68, 0.46);
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
	}
	else
	{
		outcomeTitle setText( game["strings"]["defeat"] );
		outcomeTitle.color = (0.73, 0.29, 0.19);
		//outcomeTitle.glowColor = (0.7, 0.3, 0.2);
	}
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;
	outcomeTitle setCOD7DecodeFX( 200, duration, 600 );

	outcomeText = hud::createFontString( font, 2.0 );
	outcomeText hud::setParent( outcomeTitle );
	outcomeText hud::setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	//outcomeText.glowColor = (0.2, 0.3, 0.7);
	outcomeText setText( endReasonText );

	firstTitle = hud::createFontString( font, winnerSize );
	firstTitle hud::setParent( outcomeText );
	firstTitle hud::setPoint( "TOP", "BOTTOM", 0, spacing );
	//firstTitle.glowColor = (0.3, 0.7, 0.2);
	firstTitle.glowAlpha = 1;
	firstTitle.hideWhenInMenu = false;
	firstTitle.archived = false;
	if ( isdefined( players[0] ) )
	{
		firstTitle.label = &"MP_FIRSTPLACE_NAME";
		firstTitle setPlayerNameString( players[0] );
		firstTitle setCOD7DecodeFX( 175, duration, 600 );
	}

	secondTitle = hud::createFontString( font, otherSize );
	secondTitle hud::setParent( firstTitle );
	secondTitle hud::setPoint( "TOP", "BOTTOM", 0, spacing );
	//secondTitle.glowColor = (0.2, 0.3, 0.7);
	secondTitle.glowAlpha = 1;
	secondTitle.hideWhenInMenu = false;
	secondTitle.archived = false;
	if ( isdefined( players[1] ) )
	{
		secondTitle.label = &"MP_SECONDPLACE_NAME";
		secondTitle setPlayerNameString( players[1] );
		secondTitle setCOD7DecodeFX( 175, duration, 600 );
	}
	
	thirdTitle = hud::createFontString( font, otherSize );
	thirdTitle hud::setParent( secondTitle );
	thirdTitle hud::setPoint( "TOP", "BOTTOM", 0, spacing );
	thirdTitle hud::setParent( secondTitle );
	//thirdTitle.glowColor = (0.2, 0.3, 0.7);
	thirdTitle.glowAlpha = 1;
	thirdTitle.hideWhenInMenu = false;
	thirdTitle.archived = false;
	if ( isdefined( players[2] ) )
	{
		thirdTitle.label = &"MP_THIRDPLACE_NAME";
		thirdTitle setPlayerNameString( players[2] );
		thirdTitle setCOD7DecodeFX( 175, duration, 600 );
	}
	
	matchBonus = hud::createFontString( font, 2.0 );
	matchBonus hud::setParent( thirdTitle );
	matchBonus hud::setPoint( "TOP", "BOTTOM", 0, spacing );
	matchBonus.glowAlpha = 1;
	matchBonus.hideWhenInMenu = false;
	matchBonus.archived = false;
	if ( isdefined( self.matchBonus ) )
	{
		matchBonus.label = game["strings"]["match_bonus"];
		matchBonus setValue( self.matchBonus );
	}

	self thread updateOutcome( firstTitle, secondTitle, thirdTitle );
	self thread resetOutcomeNotify( undefined, undefined, outcomeTitle, outcomeText, firstTitle, secondTitle, thirdTitle, matchBonus );
}

function wagerOutcomeNotify( winner, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	// wait for notifies to finish
	while ( self.doingNotify )
		{wait(.05);};
		
	setMatchFlag( "enable_popups", 0 );

	self endon ( "reset_outcome" );

	headerFont = "extrabig";
	font = "objective";
	if ( self IsSplitscreen() )
	{
		titleSize = 2.0;
		winnerSize = 1.5;
		otherSize = 1.5;
		iconSize = 30;
		spacing = 2;
	}
	else
	{
		titleSize = 3.0;
		winnerSize = 2.0;
		otherSize = 1.5;
		iconSize = 30;
		spacing = 20;
	}
	
	halftime = false;
	if ( isdefined( level.sidebet ) && level.sidebet )
		halftime = true;

	duration = 60000;

	players = level.placement["all"];
		
	outcomeTitle = hud::createFontString( headerFont, titleSize );
	outcomeTitle hud::setPoint( "TOP", undefined, 0, spacing );
	if( halftime )
	{
		outcomeTitle setText( game["strings"]["intermission"] );
		outcomeTitle.color = (1.0, 1.0, 0.0);
		outcomeTitle.glowColor = (1.0, 0.0, 0.0);
	}
	else if( isdefined(level.dontCalcWagerWinnings) && level.dontCalcWagerWinnings == true )
	{
		outcomeTitle setText( game["strings"]["wager_topwinners"] );
		outcomeTitle.color = (0.42, 0.68, 0.46);
	}
	else
	{
		if ( isdefined( self.wagerWinnings ) && ( self.wagerWinnings > 0 ) )
		{
			outcomeTitle setText( game["strings"]["wager_inthemoney"] );
			outcomeTitle.color = (0.42, 0.68, 0.46);
		}
		else
		{
			outcomeTitle setText( game["strings"]["wager_loss"] );
			outcomeTitle.color = (0.73, 0.29, 0.19);
		}
	}
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;
	outcomeTitle setCOD7DecodeFX( 200, duration, 600 );

	outcomeText = hud::createFontString( font, 2.0 );
	outcomeText hud::setParent( outcomeTitle );
	outcomeText hud::setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	//outcomeText.glowColor = (0.2, 0.3, 0.7);
	outcomeText setText( endReasonText );

	playerNameHudElems = [];
	playerCPHudElems = [];
	numPlayers = players.size;
	for ( i = 0 ; i < numPlayers ; i++ )
	{
		if ( !halftime && isdefined( players[i] ) )
		{
			secondTitle = hud::createFontString( font, otherSize );
			if ( playerNameHudElems.size == 0 )
			{
				secondTitle hud::setParent( outcomeText );
				secondTitle hud::setPoint( "TOP_LEFT", "BOTTOM", -175, spacing*3 );
			}
			else
			{
				secondTitle hud::setParent( playerNameHudElems[playerNameHudElems.size-1] );
				secondTitle hud::setPoint( "TOP_LEFT", "BOTTOM_LEFT", 0, spacing );
			}
			//secondTitle.glowColor = (0.2, 0.3, 0.7);
			secondTitle.glowAlpha = 1;
			secondTitle.hideWhenInMenu = false;
			secondTitle.archived = false;
			secondTitle.label = &"MP_WAGER_PLACE_NAME";
			secondTitle.playerNum = i;
			secondTitle setPlayerNameString( players[i] );
			playerNameHudElems[playerNameHudElems.size] = secondTitle;
		
			secondCP = hud::createFontString( font, otherSize );
			secondCP hud::setParent( secondTitle );
			secondCP hud::setPoint( "TOP_RIGHT", "TOP_LEFT", 350, 0 );
			secondCP.glowAlpha = 1;
			secondCP.hideWhenInMenu = false;
			secondCP.archived = false;
			secondCP.label = &"MENU_POINTS";
			secondCP.currentValue = 0;
			if ( isdefined( players[i].wagerWinnings ) )
				secondCP.targetValue = players[i].wagerWinnings;
			else
				secondCP.targetValue = 0;
			if ( secondCP.targetValue > 0 )
				secondCP.color = (0.42, 0.68, 0.46);
			secondCP setValue( 0 );
			playerCPHudElems[playerCPHudElems.size] = secondCP;
		}
	}
	
	/*matchBonus = hud::createFontString( font, 2.0 );
	matchBonus hud::setParent( thirdTitle );
	matchBonus hud::setPoint( "TOP", "BOTTOM_LEFT", 0, spacing );
	matchBonus.glowAlpha = 1;
	matchBonus.hideWhenInMenu = false;
	matchBonus.archived = false;

	sidebetWinnings = undefined;
	if ( !halftime && isdefined( self.wagerWinnings ) )
	{
		if ( isdefined( game["side_bets"] ) && game["side_bets"] )
		{
			sidebetWinnings = hud::createFontString( font, 2.0 );
			sidebetWinnings hud::setParent( matchBonus );
			sidebetWinnings hud::setPoint( "TOP", "BOTTOM", 0, spacing );
			sidebetWinnings.glowAlpha = 1;
			sidebetWinnings.hideWhenInMenu = false;
			sidebetWinnings.archived = false;
			sidebetWinnings.label = game["strings"]["wager_sidebet_winnings"];
			sidebetWinnings setValue( self.pers["wager_sideBetWinnings"] );
		}
	}*/

	self thread updateWagerOutcome( playerNameHudElems, playerCPHudElems );
	self thread resetWagerOutcomeNotify( playerNameHudElems, playerCPHudElems, outcomeTitle, outcomeText );
	
	if ( halftime )
		return;
	
	stillUpdating = true;
	countUpDuration = 2;
	CPIncrement = 9999;
	if ( isdefined( playerCPHudElems[0] ) )
	{
		CPIncrement = int( playerCPHudElems[0].targetValue / ( countUpDuration / 0.05 ) );
		if ( CPIncrement < 1 )
			CPIncrement = 1;
	}
	while( stillUpdating )
	{
		stillUpdating = false;
		for ( i = 0 ; i < playerCPHudElems.size ; i++ )
		{				
			if ( isdefined( playerCPHudElems[i] ) && ( playerCPHudElems[i].currentValue < playerCPHudElems[i].targetValue ) )
			{
				playerCPHudElems[i].currentValue += CPIncrement;
				if ( playerCPHudElems[i].currentValue > playerCPHudElems[i].targetValue )
					playerCPHudElems[i].currentValue = playerCPHudElems[i].targetValue;
				playerCPHudElems[i] SetValue( playerCPHudElems[i].currentValue );
				stillUpdating = true;
			}
		}
		{wait(.05);};
	}
}

function teamWagerOutcomeNotify( winner, isRoundEnd, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	team = self.pers["team"];
	if ( !isdefined( team ) || (!isdefined( level.teams[team] ) ) )
		team = "allies";

	{wait(.05);};

	// wait for notifies to finish
	while ( self.doingNotify )
		{wait(.05);};

	self endon ( "reset_outcome" );
	
	headerFont = "extrabig";
	font = "objective";
	if ( self IsSplitscreen() )
	{
		titleSize = 2.0;
		textSize = 1.5;
		iconSize = 30;
		spacing = 10;
	}
	else
	{
		titleSize = 3.0;
		textSize = 2.0;
		iconSize = 70;
		spacing = 15;
	}

	halftime = false;
	if ( isdefined( level.sidebet ) && level.sidebet )
		halftime = true;

	duration = 60000;

	outcomeTitle = hud::createFontString( headerFont, titleSize );
	outcomeTitle hud::setPoint( "TOP", undefined, 0, spacing );
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeText = hud::createFontString( font, 2.0 );
	outcomeText hud::setParent( outcomeTitle );
	outcomeText hud::setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	
	if ( winner == "tie" )
	{
		//outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		if ( isRoundEnd )
			outcomeTitle setText( game["strings"]["round_draw"] );
		else
			outcomeTitle setText( game["strings"]["draw"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "overtime" )
	{
		outcomeTitle setText( game["strings"]["overtime"] );
		outcomeTitle.color = (1, 1, 1);

	}
	else if ( isdefined( self.pers["team"] ) && winner == team )
	{
		//outcomeTitle.glowColor = (0, 0, 0);
		if ( isRoundEnd )
			outcomeTitle setText( game["strings"]["round_win"] );
		else
			outcomeTitle setText( game["strings"]["victory"] );
		outcomeTitle.color = (0.42, 0.68, 0.46);
	}
	else
	{
		//outcomeTitle.glowColor = (0, 0, 0);
		if ( isRoundEnd )
			outcomeTitle setText( game["strings"]["round_loss"] );
		else
			outcomeTitle setText( game["strings"]["defeat"] );
		outcomeTitle.color = (0.73, 0.29, 0.19);
	}
	if( !isdefined( level.dontShowEndReason ) || !level.dontShowEndReason )
	{
		outcomeText setText( endReasonText );
	}
	
	outcomeTitle setPulseFX( 100, duration, 1000 );
	outcomeText setPulseFX( 100, duration, 1000 );

	teamIcons = [];
	teamIcons[team] = hud::createIcon( game["icons"][team], iconSize, iconSize );
	teamIcons[team] hud::setParent( outcomeText );
	teamIcons[team] hud::setPoint( "TOP", "BOTTOM", -60, spacing );
	teamIcons[team].hideWhenInMenu = false;
	teamIcons[team].archived = false;
	teamIcons[team].alpha = 0;
	teamIcons[team] fadeOverTime( 0.5 );
	teamIcons[team].alpha = 1;

	foreach( enemyTeam in level.teams )
	{
		if ( team == enemyTeam )
			continue;
			
		teamIcons[enemyTeam] = hud::createIcon( game["icons"][enemyTeam], iconSize, iconSize );
		teamIcons[enemyTeam] hud::setParent( outcomeText );
		teamIcons[enemyTeam] hud::setPoint( "TOP", "BOTTOM", 60, spacing );
		teamIcons[enemyTeam].hideWhenInMenu = false;
		teamIcons[enemyTeam].archived = false;
		teamIcons[enemyTeam].alpha = 0;
		teamIcons[enemyTeam] fadeOverTime( 0.5 );
		teamIcons[enemyTeam].alpha = 1;
	}

	teamScores = [];
	teamScores[team] = hud::createFontString( font, titleSize );
	teamScores[team] hud::setParent( teamIcons[team] );
	teamScores[team] hud::setPoint( "TOP", "BOTTOM", 0, spacing );
	//teamScores[team].glowColor = game["colors"][team];
	teamScores[team].glowAlpha = 1;
	teamScores[team] setValue( getTeamScore( team ) );
	teamScores[team].hideWhenInMenu = false;
	teamScores[team].archived = false;
	teamScores[team] setPulseFX( 100, duration, 1000 );

	foreach( enemyTeam in level.teams )
	{
		if ( team == enemyTeam )
			continue;
			
		teamScores[enemyTeam] = hud::createFontString( font, titleSize );
		teamScores[enemyTeam] hud::setParent( teamIcons[enemyTeam] );
		teamScores[enemyTeam] hud::setPoint( "TOP", "BOTTOM", 0, spacing );
		//teamScores[enemyTeam].glowColor = game["colors"][enemyTeam];
		teamScores[enemyTeam].glowAlpha = 1;
		teamScores[enemyTeam] setValue( getTeamScore( enemyTeam ) );
		teamScores[enemyTeam].hideWhenInMenu = false;
		teamScores[enemyTeam].archived = false;
		teamScores[enemyTeam] setPulseFX( 100, duration, 1000 );
	}

	matchBonus = undefined;
	sidebetWinnings = undefined;
	if ( !isRoundEnd && !halftime && isdefined( self.wagerWinnings ) )
	{
		matchBonus = hud::createFontString( font, 2.0 );
		matchBonus hud::setParent( outcomeText );
		matchBonus hud::setPoint( "TOP", "BOTTOM", 0, iconSize + (spacing * 3) + teamScores[team].height );
		matchBonus.glowAlpha = 1;
		matchBonus.hideWhenInMenu = false;
		matchBonus.archived = false;
		matchBonus.label = game["strings"]["wager_winnings"];
		matchBonus setValue( self.wagerWinnings );

		if ( isdefined( game["side_bets"] ) && game["side_bets"] )
		{
			sidebetWinnings = hud::createFontString( font, 2.0 );
			sidebetWinnings hud::setParent( matchBonus );
			sidebetWinnings hud::setPoint( "TOP", "BOTTOM", 0, spacing );
			sidebetWinnings.glowAlpha = 1;
			sidebetWinnings.hideWhenInMenu = false;
			sidebetWinnings.archived = false;
			sidebetWinnings.label = game["strings"]["wager_sidebet_winnings"];
			sidebetWinnings setValue( self.pers["wager_sideBetWinnings"] );
		}
	}
	self thread resetOutcomeNotify( teamIcons, teamScores, outcomeTitle, outcomeText, matchBonus, sidebetWinnings );
}

function resetOutcomeNotify( hudElemList1, hudElemList2, hudElem3, hudElem4, hudElem5, hudElem6, hudElem7, hudElem8, hudElem9, hudElem10 )
{
	self endon ( "disconnect" );
	self waittill ( "reset_outcome" );
	
	destroyHudElem( hudElem3 );
	destroyHudElem( hudElem4 );
	destroyHudElem( hudElem5 );
	destroyHudElem( hudElem6 );
	destroyHudElem( hudElem7 );
	destroyHudElem( hudElem8 );
	destroyHudElem( hudElem9 );
	destroyHudElem( hudElem10 );
	
	if ( isdefined( hudElemList1 ) )
	{
		foreach( elem in hudElemList1 )
		{
			destroyHudElem( elem );
		}
	}
	
	if ( isdefined( hudElemList2 ) )
	{
		foreach( elem in hudElemList2 )
		{
			destroyHudElem( elem );
		}
	}
}

function resetWagerOutcomeNotify( playerNameHudElems, playerCPHudElems, outcomeTitle, outcomeText )
{
	self endon( "disconnect" );
	self waittill( "reset_outcome" );
	
	for ( i = playerNameHudElems.size - 1 ; i >= 0 ; i-- )
	{
		if ( isdefined( playerNameHudElems[i] ) )
			playerNameHudElems[i] destroy();
	}
		
	for ( i = playerCPHudElems.size - 1 ; i >= 0 ; i-- )
	{
		if ( isdefined( playerCPHudElems[i] ) )
			playerCPHudElems[i] destroy();
	}
	
	if ( isdefined( outcomeText ) )
		outcomeText destroy();
	
	if ( isdefined( outcomeTitle ) )
		outcomeTitle destroy();
}

function updateOutcome( firstTitle, secondTitle, thirdTitle )
{
	self endon( "disconnect" );
	self endon( "reset_outcome" );
	
	while( true )
	{
		self waittill( "update_outcome" );

		players = level.placement["all"];

		if ( isdefined( firstTitle ) && isdefined( players[0] ) )
			firstTitle setPlayerNameString( players[0] );
		else if ( isdefined( firstTitle ) )
			firstTitle.alpha = 0;
		
		if ( isdefined( secondTitle ) && isdefined( players[1] ) )
			secondTitle setPlayerNameString( players[1] );
		else if ( isdefined( secondTitle ) )
			secondTitle.alpha = 0;
		
		if ( isdefined( thirdTitle ) && isdefined( players[2] ) )
			thirdTitle setPlayerNameString( players[2] );
		else if ( isdefined( thirdTitle ) )
			thirdTitle.alpha = 0;
	}	
}

function updateWagerOutcome( playerNameHudElems, playerCPHudElems )
{
	self endon( "disconnect" );
	self endon( "reset_outcome" );
	
	while ( true )
	{
		self waittill( "update_outcome" );
		
		players = level.placement["all"];
		
		for ( i = 0 ; i < playerNameHudElems.size ; i++ )
		{
			if ( isdefined( playerNameHudElems[i] ) && isdefined( players[playerNameHudElems[i].playerNum] ) )
				playerNameHudElems[i] SetPlayerNameString( players[playerNameHudElems[i].playerNum] );
			else
			{
				if ( isdefined( playerNameHudElems[i] ) )
					playerNameHudElems[i].alpha = 0;
				if ( isdefined( playerCPHudElems[i] ) )
					playerCPHudElems[i].alpha = 0;
			}
		}
	}
}
