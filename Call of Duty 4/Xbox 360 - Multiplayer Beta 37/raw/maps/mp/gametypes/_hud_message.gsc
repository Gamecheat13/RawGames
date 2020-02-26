#include maps\mp\gametypes\_hud_util;

init()
{
	precacheString( &"MP_FIRSTPLACE_NAME" );
	precacheString( &"MP_SECONDPLACE_NAME" );
	precacheString( &"MP_THIRDPLACE_NAME" );
	precacheString( &"MP_MATCH_BONUS_IS" );
	
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );

		player thread hintMessageDeathThink();
		player thread lowerMessageThink();
		
		player thread initNotifyMessage();
	}
}


hintMessage( hintText )
{
	notifyData = spawnstruct();
	
	notifyData.notifyText = hintText;
	notifyData.glowColor = (0.3, 0.6, 0.3);
	
	notifyMessage( notifyData );
}


initNotifyMessage()
{
	if ( level.splitscreen )
	{
		titleSize = 2.0;
		textSize = 1.5;
		iconSize = 30;
	}
	else
	{
		titleSize = 2.5;
		textSize = 1.75;
		iconSize = 30;
	}
	
	self.notifyTitle = createFontString( "objective", titleSize );
	self.notifyTitle setPoint( "TOP", undefined, 0, 30 );
	self.notifyTitle.glowColor = (0.2, 0.3, 0.7);
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle setText( "Notify Title Message" );
	self.notifyTitle.hideWhenInMenu = true;
	self.notifyTitle.archived = false;
	self.notifyTitle.alpha = 0;

	self.notifyText = createFontString( "objective", textSize );
	self.notifyText setParent( self.notifyTitle );
	self.notifyText setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyText.glowColor = (0.2, 0.3, 0.7);
	self.notifyText.glowAlpha = 1;
	self.notifyText setText( "Notify text message and info." );
	self.notifyText.hideWhenInMenu = true;
	self.notifyText.archived = false;
	self.notifyText.alpha = 0;

	self.notifyText2 = createFontString( "objective", textSize );
	self.notifyText2 setParent( self.notifyTitle );
	self.notifyText2 setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyText2.glowColor = (0.2, 0.3, 0.7);
	self.notifyText2.glowAlpha = 1;
	self.notifyText2 setText( "Notify text message and info." );
	self.notifyText2.hideWhenInMenu = true;
	self.notifyText2.archived = false;
	self.notifyText2.alpha = 0;

	self.notifyIcon = createIcon( "white", iconSize, iconSize );
	self.notifyIcon setParent( self.notifyText2 );
	self.notifyIcon setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyIcon.hideWhenInMenu = true;
	self.notifyIcon.archived = false;
	self.notifyIcon.alpha = 0;

	self.doingNotify = false;
	self.notifyQueue = [];
}

oldNotifyMessage( titleText, notifyText, iconName, glowColor, sound, duration )
{
	notifyData = spawnstruct();
	
	notifyData.titleText = titleText;
	notifyData.notifyText = notifyText;
	notifyData.iconName = iconName;
	notifyData.glowColor = glowColor;
	notifyData.sound = sound;
	notifyData.duration = duration;
	
	notifyMessage( notifyData );
}

notifyMessage( notifyData )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	if ( !self.doingNotify && !isDefined( self.doingOutcome ) )
	{
		self thread showNotifyMessage( notifyData );
		return;
	}
	
	self.notifyQueue[ self.notifyQueue.size ] = notifyData;
}

showNotifyMessage( notifyData )
{
	self endon("disconnect");
	
	while ( isDefined( self.doingOutcome ) )
		wait ( 0.05 );

	self.doingNotify = true;
	self notify ( "reset_outcome" );

	waitRequireVisibility( 0 );

	if ( isDefined( notifyData.duration ) )
		duration = notifyData.duration;
	else if ( level.gameEnded )
		duration = 2.0;
	else
		duration = 4.0;
	
	self thread resetOnCancel();

	if ( isDefined( notifyData.sound ) )
		self playLocalSound( notifyData.sound );

	if ( isDefined( notifyData.leaderSound ) )
		self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( notifyData.leaderSound );
	
	if ( isDefined( notifyData.glowColor ) )
		glowColor = notifyData.glowColor;
	else
		glowColor = (0.3, 0.6, 0.3);

	anchorElem = self.notifyTitle;

	if ( isDefined( notifyData.titleText ) )
	{
		if ( isDefined( notifyData.titleLabel ) )
			self.notifyTitle.label = notifyData.titleLabel;
		else
			self.notifyTitle.label = &"";

		self.notifyTitle setText( notifyData.titleText );
		self.notifyTitle setPulseFX( 100, int(duration*1000), 1000 );
		self.notifyTitle.glowColor = glowColor;	
		self.notifyTitle.alpha = 1;
	}

	if ( isDefined( notifyData.notifyText ) )
	{
		if ( isDefined( notifyData.textLabel ) )
			self.notifyText.label = notifyData.textLabel;
		else
			self.notifyText.label = &"";

		self.notifyText setText( notifyData.notifyText );
		self.notifyText setPulseFX( 100, int(duration*1000), 1000 );
		self.notifyText.glowColor = glowColor;	
		self.notifyText.alpha = 1;
		anchorElem = self.notifyText;
	}

	if ( isDefined( notifyData.notifyText2 ) )
	{
		self.notifyText2 setParent( anchorElem );
		
		if ( isDefined( notifyData.text2Label ) )
			self.notifyText2.label = notifyData.text2Label;
		else
			self.notifyText2.label = &"";

		self.notifyText2 setText( notifyData.notifyText2 );
		self.notifyText2 setPulseFX( 100, int(duration*1000), 1000 );
		self.notifyText2.glowColor = glowColor;	
		self.notifyText2.alpha = 1;
		anchorElem = self.notifyText2;
	}

	if ( isDefined( notifyData.iconName ) )
	{
		self.notifyIcon setParent( anchorElem );
		self.notifyIcon setShader( notifyData.iconName, 60, 60 );
		self.notifyIcon.alpha = 0;
		self.notifyIcon fadeOverTime( 1.0 );
		self.notifyIcon.alpha = 1;
		
		waitRequireVisibility( duration );

		self.notifyIcon fadeOverTime( 0.75 );
		self.notifyIcon.alpha = 0;
	}
	else
	{
		waitRequireVisibility( duration );
	}

	self notify ( "notifyMessageDone" );
	self.doingNotify = false;

	if ( self.notifyQueue.size > 0 )
	{
		nextNotifyData = self.notifyQueue[0];
		
		newQueue = [];
		for ( i = 1; i < self.notifyQueue.size; i++ )
			self.notifyQueue[i-1] = self.notifyQueue[i];
		self.notifyQueue[i-1] = undefined;
		
		self thread showNotifyMessage( nextNotifyData );
	}
}

// waits for waitTime, plus any time required to let flashbangs go away.
waitRequireVisibility( waitTime )
{
	interval = .05;
	
	while ( !self canReadText() )
		wait interval;
	
	while ( waitTime > 0 )
	{
		wait interval;
		if ( self canReadText() )
			waitTime -= interval;
	}
}

canReadText()
{
	if ( self maps\mp\_flashgrenades::isFlashbanged() )
		return false;
	
	return true;
}

resetOnDeath()
{
	self endon ( "notifyMessageDone" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	self waittill ( "death" );

	resetNotify();
}

resetOnGameEnd()
{
	self notify ( "resetOnGameEnd" );
	self endon ( "resetOnGameEnd" );
	self endon ( "notifyMessageDone" );
	self endon ( "disconnect" );

	level waittill ( "game_ended" );
	
	resetNotify();
}

resetOnCancel()
{
	self notify ( "resetOnCancel" );
	self endon ( "resetOnCancel" );
	self endon ( "notifyMessageDone" );
	self endon ( "disconnect" );

	level waittill ( "cancel_notify" );
	
	resetNotify();
}
resetNotify()
{
	self.notifyTitle.alpha = 0;
	self.notifyText.alpha = 0;
	self.notifyIcon.alpha = 0;
	self.doingNotify = false;
}


hintMessageDeathThink()
{
	self endon ( "disconnect" );

	for ( ;; )
	{
		self waittill ( "death" );
		
		if ( isDefined( self.hintMessage ) )
			self.hintMessage destroyElem();
	}
}

lowerMessageThink()
{
	self endon ( "disconnect" );
	
	self.lowerMessage = createFontString( "default", level.lowerTextFontSize );
	self.lowerMessage setPoint( "CENTER", "CENTER", 0, level.lowerTextY );
	self.lowerMessage setText( "" );
	self.lowerMessage.archived = false;
	
	self.lowerTimer = createFontString( "default", 1.5 );
	self.lowerTimer setParent( self.lowerMessage );
	self.lowerTimer setPoint( "TOP", "BOTTOM", 0, 0 );
	self.lowerTimer setText( "" );
	self.lowerTimer.archived = false;
}

addMessageText( message, color )
{
	self iPrintLn( message );

	/*
	for ( index = 4; index >= 0; index-- )
	{
		if ( isDefined( self.messageBuffer[index] ) )
		{
			if ( index == 4 )
			{
				self.messageBuffer[index] destroy();
			}
			else
			{
				self.messageBuffer[index+1] = self.messageBuffer[index];
				self.messageBuffer[index+1] moveOverTime( 0.25 );
				self.messageBuffer[index+1].y += self.messageBuffer[index+1].height;
			}
		}
	}
	
	self.messageBuffer[0] = createFontString( "default", 1.5 );
	self.messageBuffer[0] setPoint( "TOPRIGHT", "TOPRIGHT", -6, 50 );
	self.messageBuffer[0] setText( message );
	self.messageBuffer[0].addTime = getTime();
	self.messageBuffer[0].isFading = false;
	self.messageBuffer[0].alpha = 0;
	self.messageBuffer[0] fadeOverTime( 0.25 );
	self.messageBuffer[0].alpha = 1;
	if ( isDefined( color ) )
		self.messageBuffer[0].color = color;
	*/
}


teamOutcomeNotify( winner, isRound, endReasonText )
{
	self notify( "reset_outcome" );
	self endon ( "reset_outcome" );
	self endon ( "disconnect" );

	if ( !isDefined( self.pers["team"] ) )
		return;

	self.doingOutcome = true;

	while ( self.doingNotify )
		wait 0.05;
	
	if ( level.splitscreen )
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
		spacing = 30;
	}

	duration = 60000;

	outcomeTitle = createFontString( "objective", titleSize );
	outcomeTitle setPoint( "TOP", undefined, 0, 30 );
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeText = createFontString( "objective", 2.0 );
	outcomeText setParent( outcomeTitle );
	outcomeText setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	
	if ( winner == "halftime" )
	{
		outcomeTitle.glowColor = (0, 0, 0);
		outcomeTitle setText( &"MP_HALFTIME" );
		outcomeTitle.color = (0.7, 0.3, 0.2);
		
		outcomeText.glowColor = (0.2, 0.3, 0.7);
		outcomeText setText( endReasonText );
		
		winner = "allies";
	}
	else if ( winner == "overtime" )
	{
		outcomeTitle.glowColor = (0, 0, 0);
		outcomeTitle setText( &"MP_OVERTIME" );
		outcomeTitle.color = (0.7, 0.3, 0.2);
		
		outcomeText.glowColor = (0.2, 0.3, 0.7);
		outcomeText setText( endReasonText );
		
		winner = "allies";
	}
	else if ( winner == "tie" )
	{
		outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( &"MP_ROUND_DRAW" );
		else
			outcomeTitle setText( &"MP_DRAW" );
		outcomeTitle.color = (0.7, 0.3, 0.2);
	
		outcomeText.glowColor = (0.2, 0.3, 0.7);
		outcomeText setText( endReasonText );

		winner = "allies";
	}
	else if ( winner == self.pers["team"] )
	{
		outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( &"MP_ROUND_WIN" );
		else
			outcomeTitle setText( &"MP_VICTORY" );
		outcomeTitle.color = (0.6, 0.9, 0.6);
	
		outcomeText.glowColor = (0, 0, 0);
		outcomeText setText( endReasonText );
	}
	else
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		if ( isRound )
			outcomeTitle setText( &"MP_ROUND_LOSS" );
		else
			outcomeTitle setText( &"MP_DEFEAT" );
		//outcomeTitle.color = (0.7, 0.3, 0.2);
	
		outcomeText.glowColor = (0.2, 0.3, 0.7);
		outcomeText setText( endReasonText );
	}

	outcomeTitle setPulseFX( 100, duration, 1000 );
	outcomeText setPulseFX( 100, duration, 1000 );
	
	team = self.pers["team"];
	if ( team != "allies" && team != "axis" )
		team = "allies";
	
	leftIcon = createIcon( game["icons"][team], iconSize, iconSize );
	leftIcon setParent( outcomeText );
	leftIcon setPoint( "TOP", "BOTTOM", -60, spacing );
	leftIcon.hideWhenInMenu = false;
	leftIcon.archived = false;
	leftIcon.alpha = 0;
	leftIcon fadeOverTime( 0.5 );
	leftIcon.alpha = 1;

	rightIcon = createIcon( game["icons"][level.otherTeam[team]], iconSize, iconSize );
	rightIcon setParent( outcomeText );
	rightIcon setPoint( "TOP", "BOTTOM", 60, spacing );
	rightIcon.hideWhenInMenu = false;
	rightIcon.archived = false;
	rightIcon.alpha = 0;
	rightIcon fadeOverTime( 0.5 );
	rightIcon.alpha = 1;

	leftScore = createFontString( "objective", titleSize );
	leftScore setParent( leftIcon );
	leftScore setPoint( "TOP", "BOTTOM", 0, spacing );
	leftScore.glowColor = game["colors"][team];
	leftScore.glowAlpha = 1;
	leftScore setText( getTeamScore( team ) );
	leftScore.hideWhenInMenu = false;
	leftScore.archived = false;
	leftScore setPulseFX( 100, duration, 1000 );

	rightScore = createFontString( "objective", titleSize );
	rightScore setParent( rightIcon );
	rightScore setPoint( "TOP", "BOTTOM", 0, spacing );
	rightScore.glowColor = game["colors"][level.otherTeam[team]];
	rightScore.glowAlpha = 1;
	rightScore setText( getTeamScore( level.otherTeam[team] ) );
	rightScore.hideWhenInMenu = false;
	rightScore.archived = false;
	rightScore setPulseFX( 100, duration, 1000 );

	matchBonus = undefined;
	if ( isDefined( self.matchBonus ) )
	{
		matchBonus = createFontString( "objective", 2.0 );
		matchBonus setParent( outcomeText );
		matchBonus setPoint( "TOP", "BOTTOM", 0, iconSize + (spacing * 3) + leftScore.height );
		matchBonus.glowAlpha = 1;
		matchBonus.hideWhenInMenu = false;
		matchBonus.archived = false;
		matchBonus.label = &"MP_MATCH_BONUS_IS";
		matchBonus setValue( self.matchBonus );
	}
	
	self thread resetTeamOutcomeNotify( outcomeTitle, outcomeText, leftIcon, rightIcon, leftScore, rightScore, matchBonus );
	
	/*
	wait duration/1000;
	
	leftIcon fadeOverTime( 1.0 );
	leftIcon.alpha = 0;

	rightIcon fadeOverTime( 1.0 );
	rightIcon.alpha = 0;
	
	wait ( 1.0 );
	
	self notify ( "reset_outcome" );
	*/
}


outcomeNotify( winner, endReasonText )
{
	self notify( "reset_outcome" );
	self endon ( "reset_outcome" );
	self endon ( "disconnect" );

	self.doingOutcome = true;

	while ( self.doingNotify )
		wait 0.05;

	if ( level.splitscreen )
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
		spacing = 30;
	}

	duration = 60000;

	players = level.placement["all"];
		
	outcomeTitle = createFontString( "objective", titleSize );
	outcomeTitle setPoint( "TOP", undefined, 0, spacing );
	if ( self == players[0] || (isDefined( players[1] ) && self == players[1]) || (isDefined( players[2] ) && self == players[2]) )
	{
		outcomeTitle setText( "Victory!" );
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
	}
	else
	{
		outcomeTitle setText( "Defeat!" );
		outcomeTitle.glowColor = (0.7, 0.3, 0.2);
	}
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;
	outcomeTitle setPulseFX( 100, duration, 1000 );

	outcomeText = createFontString( "objective", 2.0 );
	outcomeText setParent( outcomeTitle );
	outcomeText setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	outcomeText.glowColor = (0.2, 0.3, 0.7);
	outcomeText setText( endReasonText );

	firstTitle = createFontString( "objective", winnerSize );
	firstTitle setPoint( "TOPLEFT", undefined, 150, spacing*4 );
	firstTitle.glowColor = (0.3, 0.7, 0.2);
	firstTitle.glowAlpha = 1;
	firstTitle.label = &"MP_FIRSTPLACE_NAME";
	firstTitle setText( players[0].name );
	firstTitle.hideWhenInMenu = false;
	firstTitle.archived = false;
	firstTitle setPulseFX( 100, duration, 1000 );

	secondTitle = createFontString( "objective", otherSize );
	secondTitle setPoint( "TOPLEFT", "BOTTOMLEFT", 0, spacing );
	secondTitle setParent( firstTitle );
	secondTitle.glowColor = (0.2, 0.3, 0.7);
	secondTitle.glowAlpha = 1;
	secondTitle.hideWhenInMenu = false;
	secondTitle.archived = false;
	if ( isDefined( players[1] ) )
	{
		secondTitle.label = &"MP_SECONDPLACE_NAME";
		secondTitle setText( players[1].name );
		secondTitle setPulseFX( 100, duration, 1000 );
	}
	
	thirdTitle = createFontString( "objective", otherSize );
	thirdTitle setPoint( "TOPLEFT", "BOTTOMLEFT", 0, spacing );
	thirdTitle setParent( secondTitle );
	thirdTitle.glowColor = (0.2, 0.3, 0.7);
	thirdTitle.glowAlpha = 1;
	thirdTitle.hideWhenInMenu = false;
	thirdTitle.archived = false;
	if ( isDefined( players[2] ) )
	{
		thirdTitle.label = &"MP_THIRDPLACE_NAME";
		thirdTitle setText( players[2].name );
		thirdTitle setPulseFX( 100, duration, 1000 );
	}

	matchBonus = createFontString( "objective", 2.0 );
	matchBonus setParent( thirdTitle );
	matchBonus setPoint( "TOPLEFT", "BOTTOMLEFT", 0, spacing );
	matchBonus.glowAlpha = 1;
	matchBonus.hideWhenInMenu = false;
	matchBonus.archived = false;
	if ( isDefined( self.matchBonus ) )
	{
		matchBonus.label = &"MP_MATCH_BONUS_IS";
		matchBonus setValue( self.matchBonus );
	}

	self thread resetOutcomeNotify( outcomeTitle, outcomeText, firstTitle, secondTitle, thirdTitle, matchBonus );
	/*
	wait duration/1000;
	
	wait ( 1.0 );
	
	self notify ( "reset_outcome" );
	*/
}


resetOutcomeNotify( outcomeTitle, outcomeText, firstTitle, secondTitle, thirdTitle, matchBonus )
{
	self endon ( "disconnect" );
	self waittill ( "reset_outcome" );
	
	if ( isDefined( outcomeTitle ) )
		outcomeTitle destroyElem();
	if ( isDefined( outcomeText ) )
		outcomeText destroyElem();
	if ( isDefined( firstTitle ) )
		firstTitle destroyElem();
	if ( isDefined( secondTitle ) )
		secondTitle destroyElem();
	if ( isDefined( thirdTitle ) )
		thirdTitle destroyElem();
	if ( isDefined( matchBonus ) )
		matchBonus destroyElem();
}

resetTeamOutcomeNotify( outcomeTitle, outcomeText, leftIcon, rightIcon, LeftScore, rightScore, matchBonus )
{
	self endon ( "disconnect" );
	self waittill ( "reset_outcome" );
	
	if ( isDefined( outcomeTitle ) )
		outcomeTitle destroyElem();
	if ( isDefined( outcomeText ) )
		outcomeText destroyElem();
	if ( isDefined( leftIcon ) )
		leftIcon destroyElem();
	if ( isDefined( rightIcon ) )
		rightIcon destroyElem();
	if ( isDefined( leftScore ) )
		leftScore destroyElem();
	if ( isDefined( rightScore ) )
		rightScore destroyElem();
	if ( isDefined( matchBonus ) )
		matchBonus destroyElem();
}
