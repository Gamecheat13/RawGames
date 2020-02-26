#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	precacheString( &"MP_FIRSTPLACE_NAME" );
	precacheString( &"MP_SECONDPLACE_NAME" );
	precacheString( &"MP_THIRDPLACE_NAME" );
	precacheString( &"MP_MATCH_BONUS_IS" );

	precacheMenu( "splash" );
	precacheMenu( "challenge" );
	precacheMenu( "defcon" );
	precacheMenu( "killstreak" );
	precacheMenu( "perk_display" );
	precacheMenu( "perk_hide" );
	precacheMenu( "killedby_card_display" );
	precacheMenu( "killedby_card_hide" );
	precacheMenu( "youkilled_card_display" );
	precacheMenu( "endgameupdate" );

	game["strings"]["draw"] = &"MP_DRAW";
	game["strings"]["round_draw"] = &"MP_ROUND_DRAW";
	game["strings"]["round_win"] = &"MP_ROUND_WIN";
	game["strings"]["round_loss"] = &"MP_ROUND_LOSS";
	game["strings"]["victory"] = &"MP_VICTORY";
	game["strings"]["defeat"] = &"MP_DEFEAT";
	game["strings"]["halftime"] = &"MP_HALFTIME";
	game["strings"]["overtime"] = &"MP_OVERTIME";
	game["strings"]["roundend"] = &"MP_ROUNDEND";
	game["strings"]["intermission"] = &"MP_INTERMISSION";
	game["strings"]["side_switch"] = &"MP_SWITCHING_SIDES";
	game["strings"]["match_bonus"] = &"MP_MATCH_BONUS_IS";
	
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

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
		iconSize = 24;
		font = "default";
		point = "TOP";
		relativePoint = "BOTTOM";
		yOffset = 30;
		xOffset = 0;
	}
	else
	{
		titleSize = 2.5;
		textSize = 1.75;
		iconSize = 30;
		font = "objective";
		point = "TOP";
		relativePoint = "BOTTOM";
		yOffset = 20;
		xOffset = 0;
	}
	
	self.notifyTitle = createFontString( font, titleSize );
	self.notifyTitle setPoint( point, undefined, xOffset, yOffset );
	self.notifyTitle.glowColor = (0.2, 0.3, 0.7);
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle.hideWhenInMenu = true;
	self.notifyTitle.archived = false;
	self.notifyTitle.alpha = 0;

	self.notifyText = createFontString( font, textSize );
	self.notifyText setParent( self.notifyTitle );
	self.notifyText setPoint( point, relativePoint, 0, 0 );
	self.notifyText.glowColor = (0.2, 0.3, 0.7);
	self.notifyText.glowAlpha = 1;
	self.notifyText.hideWhenInMenu = true;
	self.notifyText.archived = false;
	self.notifyText.alpha = 0;

	self.notifyText2 = createFontString( font, textSize );
	self.notifyText2 setParent( self.notifyTitle );
	self.notifyText2 setPoint( point, relativePoint, 0, 0 );
	self.notifyText2.glowColor = (0.2, 0.3, 0.7);
	self.notifyText2.glowAlpha = 1;
	self.notifyText2.hideWhenInMenu = true;
	self.notifyText2.archived = false;
	self.notifyText2.alpha = 0;

	self.notifyIcon = createIcon( "white", iconSize, iconSize );
	self.notifyIcon setParent( self.notifyText2 );
	self.notifyIcon setPoint( point, relativePoint, 0, 0 );
	self.notifyIcon.hideWhenInMenu = true;
	self.notifyIcon.archived = false;
	self.notifyIcon.alpha = 0;

	self.notifyOverlay = createIcon( "white", iconSize, iconSize );
	self.notifyOverlay setParent( self.notifyIcon );
	self.notifyOverlay setPoint( "CENTER", "CENTER", 0, 0 );
	self.notifyOverlay.hideWhenInMenu = true;
	self.notifyOverlay.archived = false;
	self.notifyOverlay.alpha = 0;

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
	
	if ( !self.doingNotify )
	{
		self thread showNotifyMessage( notifyData );
		return;
	}
	
	self.notifyQueue[ self.notifyQueue.size ] = notifyData;
}


dispatchNotify( notifyData )
{
	//while ( level.showingFinalKillcam )
	//	wait ( 0.05 );
		
	//if ( levelFlag( "block_notifies" ) )
	//	levelFlagWaitOpen( "block_notifies" );
	
	if ( isDefined( notifyData.name ) )
		actionNotify( notifyData );
	else
		showNotifyMessage( notifyData );
}


showNotifyMessage( notifyData )
{
	self endon("disconnect");

	if ( level.gameEnded )
	{
		if ( isDefined( notifyData.type ) && notifyData.type == "rank" )
		{
			self setClientDvar( "ui_promotion", 1 );
			self.postGamePromotion = true;
		}

		if ( self.notifyQueue.size > 0 )
		{
			nextNotifyData = self.notifyQueue[0];
			
			newQueue = [];
			for ( i = 1; i < self.notifyQueue.size; i++ )
				self.notifyQueue[i-1] = self.notifyQueue[i];
			self.notifyQueue[i-1] = undefined;
			
			self thread dispatchNotify( nextNotifyData );
		}
		return;
	}
	
	self.doingNotify = true;

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
		self leaderDialogOnPlayer( notifyData.leaderSound );
	
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

		if ( isDefined( notifyData.titleLabel ) && !isDefined( notifyData.titleIsString ) )
			self.notifyTitle setValue( notifyData.titleText );
		else
			self.notifyTitle setText( notifyData.titleText );
		self.notifyTitle setPulseFX( int(25*duration), int(duration*1000), 1000 );
		self.notifyTitle.glowColor = glowColor;	
		self.notifyTitle.alpha = 1;
	}

	if ( isDefined( notifyData.textGlowColor ) )
		glowColor = notifyData.textGlowColor;

	if ( isDefined( notifyData.notifyText ) )
	{
		if ( isDefined( notifyData.textLabel ) )
			self.notifyText.label = notifyData.textLabel;
		else
			self.notifyText.label = &"";

		if ( isDefined( notifyData.textLabel ) && !isDefined( notifyData.textIsString ) )
			self.notifyText setValue( notifyData.notifyText );
		else
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

		if ( isDefined( notifyData.iconOverlay ) )
		{
			self.notifyIcon fadeOverTime( 0.15 );
			self.notifyIcon.alpha = 1;

			//if ( !isDefined( notifyData.overlayOffsetY ) )
				notifyData.overlayOffsetY = 0;

			self.notifyOverlay setParent( self.notifyIcon );
			self.notifyOverlay setPoint( "CENTER", "CENTER", 0, notifyData.overlayOffsetY );
			self.notifyOverlay setShader( notifyData.iconOverlay, 512, 512 );
			self.notifyOverlay.alpha = 0;
			self.notifyOverlay.color = (1,0,0);

			self.notifyOverlay fadeOverTime( 0.4 );
			self.notifyOverlay.alpha = 0.85;
	
			self.notifyOverlay scaleOverTime( 0.4, 32, 32 );
			
			waitRequireVisibility( duration );

			self.notifyIcon fadeOverTime( 0.75 );
			self.notifyIcon.alpha = 0;
	
			self.notifyOverlay fadeOverTime( 0.75 );
			self.notifyOverlay.alpha = 0;
		}
		else
		{
			self.notifyIcon fadeOverTime( 1.0 );
			self.notifyIcon.alpha = 1;

			waitRequireVisibility( duration );

			self.notifyIcon fadeOverTime( 0.75 );
			self.notifyIcon.alpha = 0;
		}		
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
		
		self thread dispatchNotify( nextNotifyData );
	}
}


killstreakSplashNotify( streakName, streakVal, appendString )
{
	self endon ( "disconnect" );
	waittillframeend;

	if ( level.gameEnded )
		return;

	actionData = spawnStruct();
	
	if ( isDefined( appendString ) )
		actionData.name = streakName + "_" + appendString;
	else
		actionData.name = streakName;

	actionData.optionalNumber = streakVal;	
	actionData.sound = maps\mp\killstreaks\_killstreaks::getKillstreakSound( streakName );
	actionData.leaderSound = streakName;
	actionData.leaderSoundGroup = "killstreak_earned";
	actionData.slot = 0;

	self thread actionNotify( actionData, true );
}


defconSplashNotify( defconLevel, forceNotify )
{
	actionData = spawnStruct();
	
	actionData.name = "defcon_" + defconLevel;
	actionData.sound = tableLookup( "mp/splashTable.csv", 0, actionData.name, 9 );
	actionData.slot = 0;

	self thread actionNotify( actionData, forceNotify );
}


challengeSplashNotify( challengeRef )
{
	self endon ( "disconnect" );
	waittillframeend;
	
	// this is used to ensure the client receives the new challenge state before the splash is shown.
	wait ( 0.05 );

	//subtracting one from state becase state was incremented after completing challenge
	challengeState = ( self getPlayerData( "challengeState", challengeRef )  - 1 );
	challengeTarget = int( tableLookup( "mp/allChallengesTable.csv", 0, challengeRef, 6 + ((challengeState-1)*2) ) );
	
	if( challengeTarget == 0 )
		challengeTarget = 1;
	
	if( isSubStr( challengeRef,  "marathon" ) || isSubStr( challengeRef,  "lightweight" ) )
		challengeTarget = int( challengeTarget/5280 );
	
	actionData = spawnStruct();
	actionData.type = "challenge";
	actionData.optionalNumber = challengeTarget;
	actionData.name = challengeRef;
	actionData.sound = tableLookup( "mp/splashTable.csv", 0, actionData.name, 9 );
	actionData.slot = 0;

	self thread actionNotify( actionData );
}


splashNotify( text, optionalNumber )
{
	self endon ( "disconnect" );
	// wait until any challenges have been processed
	//self waittill( "playerKilledChallengesProcessed" );
	wait .05;

	actionData = spawnStruct();
	
	actionData.name = text;
	actionData.optionalNumber = optionalNumber;
	actionData.sound = tableLookup( "mp/splashTable.csv", 0, actionData.name, 9 );
	actionData.slot = 0;

	self thread actionNotify( actionData );
}


splashNotifyDelayed( text, optionalNumber )
{
	self endon ( "disconnect" );
	waittillframeend;

	if ( level.gameEnded )
		return;

	actionData = spawnStruct();
	
	actionData.name = text;
	actionData.optionalNumber = optionalNumber;
	actionData.sound = tableLookup( "mp/splashTable.csv", 0, actionData.name, 9 );
	actionData.slot = 0;

	self thread actionNotify( actionData );
}


playerCardSplashNotify( splashRef, player, optionalNumber )
{
	self endon ( "disconnect" );
	waittillframeend;

	if ( level.gameEnded )
		return;

	actionData = spawnStruct();
	
	actionData.name = splashRef;
	actionData.optionalNumber = optionalNumber;
	actionData.sound = tableLookup( "mp/splashTable.csv", 0, actionData.name, 9 );
	actionData.playerCardPlayer = player;
	actionData.slot = 1;

	self thread actionNotify( actionData );
}


actionNotify( actionData, forceNotify )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	if ( !self.doingNotify || (isDefined( forceNotify ) && forceNotify) )
	{
		self thread actionNotifyMessage( actionData );
		return;
	}
	
	self.notifyQueue[ self.notifyQueue.size ] = actionData;
}


actionNotifyMessage( actionData )
{
	self endon ( "disconnect" );

	if ( level.gameEnded )
	{
		if ( isDefined( actionData.type ) && actionData.type == "challenge" )
		{
			self.postGameChallenges++;
			self setClientDvar( "ui_challenge_"+ self.postGameChallenges +"_ref", actionData.name );
		}

		if ( self.notifyQueue.size > 0 )
		{
			nextNotifyData = self.notifyQueue[0];
			
			newQueue = [];
			for ( i = 1; i < self.notifyQueue.size; i++ )
				self.notifyQueue[i-1] = self.notifyQueue[i];
			self.notifyQueue[i-1] = undefined;
			
			self thread dispatchNotify( nextNotifyData );
		}
		return;
	}

	assert( isDefined( actionData.slot ) );

	if ( isDefined( actionData.playerCardPlayer ) )
		self SetCardDisplaySlot( actionData.playerCardPlayer, 5 );
	
	if ( isDefined( actionData.optionalNumber ) )
		self ShowHudSplash( actionData.name, actionData.slot, actionData.optionalNumber );
	else
		self ShowHudSplash( actionData.name, actionData.slot );

	self.doingNotify = true;

	assertEx( tableLookup( "mp/splashTable.csv", 0, actionData.name, 0 ) != "", "ERROR: unknown splash - " + actionData.name );

	duration = stringToFloat( tableLookup( "mp/splashTable.csv", 0, actionData.name, 4 ) );

	if ( isDefined( actionData.sound ) )
		self playLocalSound( actionData.sound );

	if ( isDefined( actionData.leaderSound ) )
	{
		if ( isDefined( actionData.leaderSoundGroup ) )
			self leaderDialogOnPlayer( actionData.leaderSound, actionData.leaderSoundGroup );
		else
			self leaderDialogOnPlayer( actionData.leaderSound );
	}

	wait ( duration - 0.05 );

	//menuName = tableLookup( "mp/splashTable.csv", 0, actionData.name, 11 );
	//if ( menuName != "splash" )
	//	self closeMenu( menuName );

	self.doingNotify = false;

	if ( self.notifyQueue.size > 0 )
	{
		nextActionData = self.notifyQueue[0];
		
		newQueue = [];
		for ( i = 1; i < self.notifyQueue.size; i++ )
			self.notifyQueue[i-1] = self.notifyQueue[i];
		self.notifyQueue[i-1] = undefined;
		
		self thread dispatchNotify( nextActionData );
		return;
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
	self.notifyOverlay.alpha = 0;
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
	
	self.lowerMessages = [];
	
	self.lowerMessage = createFontString( "default", level.lowerTextFontSize );
	self.lowerMessage setPoint( "CENTER", level.lowerTextYAlign, 0, level.lowerTextY );
	self.lowerMessage setText( "" );
	self.lowerMessage.archived = false;
	
	timerFontSize = 0.75;
	if ( level.splitscreen )
		timerFontSize = 0.75;
	
	self.lowerTimer = createFontString( "hudbig", timerFontSize );
	self.lowerTimer setParent( self.lowerMessage );
	self.lowerTimer setPoint( "TOP", "BOTTOM", 0, 0 );
	self.lowerTimer setText( "" );
	self.lowerTimer.archived = false;
}


outcomeOverlay( winner )
{
	if ( level.teamBased )
	{
		if ( winner == "tie" )
			self matchOutcomeNotify( "draw" );
		else if ( winner == self.team )
			self matchOutcomeNotify( "victory" );
		else
			self matchOutcomeNotify( "defeat" );
	}
	else
	{
		if ( winner == self )
			self matchOutcomeNotify( "victory" );
		else
			self matchOutcomeNotify( "defeat" );
	}
}


matchOutcomeNotify( outcome )
{
	team = self.team;
	
	outcomeTitle = createFontString( "bigfixed", 1.0 );
	outcomeTitle setPoint( "TOP", undefined, 0, 50 );
	outcomeTitle.foreground = true;
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeTitle setText( game["strings"][outcome] );
	outcomeTitle.alpha = 0;
	outcomeTitle fadeOverTime( 0.5 );
	outcomeTitle.alpha = 1;	
	
	switch( outcome )
	{
		case "victory":
			outcomeTitle.glowColor = (0.6, 0.9, 0.6);
			break;
		default:
			outcomeTitle.glowColor = (0.9, 0.6, 0.6);
			break;
	}

	centerIcon = createIcon( game["icons"][team], 64, 64 );
	centerIcon setParent( outcomeTitle );
	centerIcon setPoint( "TOP", "BOTTOM", 0, 30 );
	centerIcon.foreground = true;
	centerIcon.hideWhenInMenu = false;
	centerIcon.archived = false;
	centerIcon.alpha = 0;
	centerIcon fadeOverTime( 0.5 );
	centerIcon.alpha = 1;	
	
	wait ( 3.0 );
	
	outcomeTitle destroyElem();
	centerIcon destroyElem();
}


teamOutcomeNotify( winner, isRound, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	wait ( 0.5 );

	team = self.pers["team"];
	if ( !isDefined( team ) || (team != "allies" && team != "axis") )
		team = "allies";

	// wait for notifies to finish
	while ( self.doingNotify )
		wait 0.05;

	self endon ( "reset_outcome" );
	
	if ( level.splitscreen )
	{
		titleSize = 2.0;
		textSize = 1.5;
		iconSize = 30;
		spacing = 10;
		font = "default";
	}
	else
	{
		titleSize = 3.0;
		textSize = 2.0;
		iconSize = 70;
		spacing = 30;
		font = "objective";
	}

	duration = 60000;

	outcomeTitle = createFontString( font, titleSize );
	outcomeTitle setPoint( "TOP", undefined, 0, 30 );
	outcomeTitle.foreground = true;
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeText = createFontString( font, 2.0 );
	outcomeText setParent( outcomeTitle );
	outcomeText.foreground = true;
	outcomeText setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	
	if ( winner == "halftime" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["halftime"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "intermission" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["intermission"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "roundend" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["roundend"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "overtime" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		outcomeTitle setText( game["strings"]["overtime"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( winner == "tie" )
	{
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_draw"] );
		else
			outcomeTitle setText( game["strings"]["draw"] );
		outcomeTitle.color = (1, 1, 1);
		
		winner = "allies";
	}
	else if ( isDefined( self.pers["team"] ) && winner == team )
	{
		outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_win"] );
		else
			outcomeTitle setText( game["strings"]["victory"] );
		outcomeTitle.color = (0.6, 0.9, 0.6);
	}
	else
	{
		outcomeTitle.glowColor = (0, 0, 0);
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_loss"] );
		else
			outcomeTitle setText( game["strings"]["defeat"] );
		outcomeTitle.color = (0.7, 0.3, 0.2);
	}
	
	outcomeText.glowColor = (0.2, 0.3, 0.7);
	outcomeText setText( endReasonText );
	
	outcomeTitle setPulseFX( 100, duration, 1000 );
	outcomeText setPulseFX( 100, duration, 1000 );
	
	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		leftIcon = createIcon( game["icons"][team] + "_blue", iconSize, iconSize );
	else
		leftIcon = createIcon( game["icons"][team], iconSize, iconSize );
	leftIcon setParent( outcomeText );
	leftIcon setPoint( "TOP", "BOTTOM", -60, spacing );
	leftIcon.foreground = true;
	leftIcon.hideWhenInMenu = false;
	leftIcon.archived = false;
	leftIcon.alpha = 0;
	leftIcon fadeOverTime( 0.5 );
	leftIcon.alpha = 1;

	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		rightIcon = createIcon( game["icons"][level.otherTeam[team]] + "_red", iconSize, iconSize );
	else
		rightIcon = createIcon( game["icons"][level.otherTeam[team]], iconSize, iconSize );
	rightIcon setParent( outcomeText );
	rightIcon setPoint( "TOP", "BOTTOM", 60, spacing );
	rightIcon.foreground = true;
	rightIcon.hideWhenInMenu = false;
	rightIcon.archived = false;
	rightIcon.alpha = 0;
	rightIcon fadeOverTime( 0.5 );
	rightIcon.alpha = 1;

	leftScore = createFontString( font, titleSize );
	leftScore setParent( leftIcon );
	leftScore setPoint( "TOP", "BOTTOM", 0, spacing );
	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		leftScore.glowColor = game["colors"]["blue"];
	else
		leftScore.glowColor = game["colors"][team];
	leftScore.glowAlpha = 1;
	if ( !isRoundBased() || !isObjectiveBased() )
		leftScore setValue( maps\mp\gametypes\_gamescore::_getTeamScore( team ) );
	else
		leftScore setValue( game["roundsWon"][team] );
	leftScore.foreground = true;
	leftScore.hideWhenInMenu = false;
	leftScore.archived = false;
	leftScore setPulseFX( 100, duration, 1000 );

	rightScore = createFontString( font, titleSize );
	rightScore setParent( rightIcon );
	rightScore setPoint( "TOP", "BOTTOM", 0, spacing );
	if ( getIntProperty( "useRelativeTeamColors", 0 ) )
		rightScore.glowColor = game["colors"]["red"];
	else
		rightScore.glowColor = game["colors"][level.otherTeam[team]];
	rightScore.glowAlpha = 1;
	if ( !isRoundBased() || !isObjectiveBased() )
		rightScore setValue( maps\mp\gametypes\_gamescore::_getTeamScore( level.otherTeam[team] ) );
	else
		rightScore setValue( game["roundsWon"][level.otherTeam[team]] );
	rightScore.foreground = true;
	rightScore.hideWhenInMenu = false;
	rightScore.archived = false;
	rightScore setPulseFX( 100, duration, 1000 );

	matchBonus = undefined;
	if ( isDefined( self.matchBonus ) )
	{
		matchBonus = createFontString( font, 2.0 );
		matchBonus setParent( outcomeText );
		matchBonus setPoint( "TOP", "BOTTOM", 0, iconSize + (spacing * 3) + leftScore.height );
		matchBonus.glowAlpha = 1;
		matchBonus.foreground = true;
		matchBonus.hideWhenInMenu = false;
		matchBonus.archived = false;
		matchBonus.label = game["strings"]["match_bonus"];
		matchBonus setValue( self.matchBonus );
	}
	
	self thread resetTeamOutcomeNotify( outcomeTitle, outcomeText, leftIcon, rightIcon, leftScore, rightScore, matchBonus );
}


outcomeNotify( winner, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	// wait for notifies to finish
	while ( self.doingNotify )
		wait 0.05;

	self endon ( "reset_outcome" );

	if ( level.splitscreen )
	{
		titleSize = 2.0;
		winnerSize = 1.5;
		otherSize = 1.5;
		iconSize = 30;
		spacing = 2;
		font = "default";
	}
	else
	{
		titleSize = 3.0;
		winnerSize = 2.0;
		otherSize = 1.5;
		iconSize = 30;
		spacing = 20;
		font = "objective";
	}

	duration = 60000;

	players = level.placement["all"];
		
	outcomeTitle = createFontString( font, titleSize );
	outcomeTitle setPoint( "TOP", undefined, 0, spacing );
	if ( isDefined( players[1] ) && players[0].score == players[1].score && players[0].deaths == players[1].deaths && (self == players[0] || self == players[1]) )
	{
		outcomeTitle setText( game["strings"]["tie"] );
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
	}
	else if ( isDefined( players[2] ) && players[0].score == players[2].score && players[0].deaths == players[2].deaths && self == players[2] )
	{
		outcomeTitle setText( game["strings"]["tie"] );
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
	}
	else if ( isDefined( players[0] ) && self == players[0] )
	{
		outcomeTitle setText( game["strings"]["victory"] );
		outcomeTitle.glowColor = (0.2, 0.3, 0.7);
	}
	else
	{
		outcomeTitle setText( game["strings"]["defeat"] );
		outcomeTitle.glowColor = (0.7, 0.3, 0.2);
	}
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.foreground = true;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;
	outcomeTitle setPulseFX( 100, duration, 1000 );

	outcomeText = createFontString( font, 2.0 );
	outcomeText setParent( outcomeTitle );
	outcomeText setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.foreground = true;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	outcomeText.glowColor = (0.2, 0.3, 0.7);
	outcomeText setText( endReasonText );

	firstTitle = createFontString( font, winnerSize );
	firstTitle setParent( outcomeText );
	firstTitle setPoint( "TOP", "BOTTOM", 0, spacing );
	firstTitle.glowColor = (0.3, 0.7, 0.2);
	firstTitle.glowAlpha = 1;
	firstTitle.foreground = true;
	firstTitle.hideWhenInMenu = false;
	firstTitle.archived = false;
	if ( isDefined( players[0] ) )
	{
		firstTitle.label = &"MP_FIRSTPLACE_NAME";
		firstTitle setPlayerNameString( players[0] );
		firstTitle setPulseFX( 100, duration, 1000 );
	}

	secondTitle = createFontString( font, otherSize );
	secondTitle setParent( firstTitle );
	secondTitle setPoint( "TOP", "BOTTOM", 0, spacing );
	secondTitle.glowColor = (0.2, 0.3, 0.7);
	secondTitle.glowAlpha = 1;
	secondTitle.foreground = true;
	secondTitle.hideWhenInMenu = false;
	secondTitle.archived = false;
	if ( isDefined( players[1] ) )
	{
		secondTitle.label = &"MP_SECONDPLACE_NAME";
		secondTitle setPlayerNameString( players[1] );
		secondTitle setPulseFX( 100, duration, 1000 );
	}
	
	thirdTitle = createFontString( font, otherSize );
	thirdTitle setParent( secondTitle );
	thirdTitle setPoint( "TOP", "BOTTOM", 0, spacing );
	thirdTitle setParent( secondTitle );
	thirdTitle.glowColor = (0.2, 0.3, 0.7);
	thirdTitle.glowAlpha = 1;
	thirdTitle.foreground = true;
	thirdTitle.hideWhenInMenu = false;
	thirdTitle.archived = false;
	if ( isDefined( players[2] ) )
	{
		thirdTitle.label = &"MP_THIRDPLACE_NAME";
		thirdTitle setPlayerNameString( players[2] );
		thirdTitle setPulseFX( 100, duration, 1000 );
	}

	matchBonus = createFontString( font, 2.0 );
	matchBonus setParent( thirdTitle );
	matchBonus setPoint( "TOP", "BOTTOM", 0, spacing );
	matchBonus.glowAlpha = 1;
	matchBonus.foreground = true;
	matchBonus.hideWhenInMenu = false;
	matchBonus.archived = false;
	if ( isDefined( self.matchBonus ) )
	{
		matchBonus.label = game["strings"]["match_bonus"];
		matchBonus setValue( self.matchBonus );
	}

	self thread updateOutcome( firstTitle, secondTitle, thirdTitle );
	self thread resetOutcomeNotify( outcomeTitle, outcomeText, firstTitle, secondTitle, thirdTitle, matchBonus );
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


updateOutcome( firstTitle, secondTitle, thirdTitle )
{
	self endon( "disconnect" );
	self endon( "reset_outcome" );
	
	while( true )
	{
		self waittill( "update_outcome" );

		players = level.placement["all"];

		if ( isDefined( firstTitle ) && isDefined( players[0] ) )
			firstTitle setPlayerNameString( players[0] );
		else if ( isDefined( firstTitle ) )
			firstTitle.alpha = 0;
		
		if ( isDefined( secondTitle ) && isDefined( players[1] ) )
			secondTitle setPlayerNameString( players[1] );
		else if ( isDefined( secondTitle ) )
			secondTitle.alpha = 0;
		
		if ( isDefined( thirdTitle ) && isDefined( players[2] ) )
			thirdTitle setPlayerNameString( players[2] );
		else if ( isDefined( thirdTitle ) )
			thirdTitle.alpha = 0;
	}	
}

