#include maps\_hud_util;
#include maps\_utility; 

init()
{
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );

		//player thread hintMessageDeathThink();
		//player thread lowerMessageThink();
		
		player thread initNotifyMessage();
	}
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
		yOffset = 30;
		xOffset = 0;
	}
	
	// CODER_MOD - BNANDAKUMAR (7/16/08): Added the player as the 4th argument to make sure the hudelem is created only for that player alone
	self.notifyTitle = createFontString( font, titleSize, self );
	self.notifyTitle setPoint( point, undefined, xOffset, yOffset );
	//self.notifyTitle.glowColor = (0.2, 0.3, 0.7);
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle.hideWhenInMenu = true;
	self.notifyTitle.archived = false;
	self.notifyTitle.alpha = 0;

	// CODER_MOD - BNANDAKUMAR (7/16/08): Added the player as the 4th argument to make sure the hudelem is created only for that player alone
	self.notifyText = createFontString( font, textSize, self );
	self.notifyText setParent( self.notifyTitle );
	self.notifyText setPoint( point, relativePoint, 0, 0 );
	//self.notifyText.glowColor = (0.2, 0.3, 0.7);
	self.notifyText.glowAlpha = 1;
	self.notifyText.hideWhenInMenu = true;
	self.notifyText.archived = false;
	self.notifyText.alpha = 0;

	// CODER_MOD - BNANDAKUMAR (7/16/08): Added the player as the 4th argument to make sure the hudelem is created only for that player alone
	self.notifyText2 = createFontString( font, textSize, self );
	self.notifyText2 setParent( self.notifyTitle );
	self.notifyText2 setPoint( point, relativePoint, 0, 0 );
	//self.notifyText2.glowColor = (0.2, 0.3, 0.7);
	self.notifyText2.glowAlpha = 1;
	self.notifyText2.hideWhenInMenu = true;
	self.notifyText2.archived = false;
	self.notifyText2.alpha = 0;

	// CODER_MOD - BNANDAKUMAR (7/16/08): Added the player as the 4th argument to make sure the hudelem is created only for that player alone
	self.notifyIcon = createIcon( "white", iconSize, iconSize, self );
	self.notifyIcon setParent( self.notifyText2 );
	self.notifyIcon setPoint( point, relativePoint, 0, 0 );
	self.notifyIcon.hideWhenInMenu = true;
	self.notifyIcon.archived = false;
	self.notifyIcon.alpha = 0;

	// CODER_MOD - BNANDAKUMAR (9/10/08): Added 3rd line of notification text 
	self.notifyText3 = createFontString( font, textSize, self );
	self.notifyText3 setParent( self.notifyTitle );
	self.notifyText3 setPoint( point, relativePoint, 0, 0 );
	//self.notifyText3.glowColor = (0.2, 0.3, 0.7);
	self.notifyText3.glowAlpha = 1;
	self.notifyText3.hideWhenInMenu = true;
	self.notifyText3.archived = false;
	self.notifyText3.alpha = 0;

	self.doingNotify = false;
	self.notifyQueue = [];
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


showNotifyMessage( notifyData )
{
	self endon("disconnect");
	
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

	//if ( isDefined( notifyData.leaderSound ) )
	//	self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( notifyData.leaderSound );
	
	if ( isDefined( notifyData.glowColor ) )
		glowColor = notifyData.glowColor;
	else
		glowColor = (0.0, 0.0, 0.0);

	anchorElem = self.notifyTitle;

	if ( isDefined( notifyData.titleText ) )
	{
		if ( level.splitScreen )
		{
			if ( isDefined( notifyData.titleLabel ) )
				self iPrintLnBold( notifyData.titleLabel, notifyData.titleText );
			else
				self iPrintLnBold( notifyData.titleText );
		}
		else
		{
			if ( isDefined( notifyData.titleLabel ) )
				self.notifyTitle.label = notifyData.titleLabel;
			else
				self.notifyTitle.label = &"";

			if ( isDefined( notifyData.titleLabel ) && !isDefined( notifyData.titleIsString ) )
				self.notifyTitle setValue( notifyData.titleText );
			else
				self.notifyTitle setText( notifyData.titleText );
			self.notifyTitle setPulseFX( 100, int(duration*1000), 1000 );
			self.notifyTitle.glowColor = glowColor;	
			self.notifyTitle.alpha = 1;
		}
	}

	if ( isDefined( notifyData.notifyText ) )
	{
		if ( level.splitScreen )
		{
			if ( isDefined( notifyData.textLabel ) )
				self iPrintLnBold( notifyData.textLabel, notifyData.notifyText );
			else
				self iPrintLnBold( notifyData.notifyText );
		}
		else
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
	}

	if ( isDefined( notifyData.notifyText2 ) )
	{
		if ( level.splitScreen )
		{
			if ( isDefined( notifyData.text2Label ) )
				self iPrintLnBold( notifyData.text2Label, notifyData.notifyText2 );
			else
				self iPrintLnBold( notifyData.notifyText2 );
		}
		else
		{
			self.notifyText2 setParent( anchorElem );
			
			if ( isDefined( notifyData.text2Label ) )
				self.notifyText2.label = notifyData.text2Label;
			else
				self.notifyText2.label = &"";

			if ( isDefined( notifyData.text2Label ) && !isDefined( notifyData.textIsString ) )
				self.notifyText2 setValue( notifyData.notifyText2 );
			else
				self.notifyText2 setText( notifyData.notifyText2 );
	
			self.notifyText2 setText( notifyData.notifyText2 );
			self.notifyText2 setPulseFX( 100, int(duration*1000), 1000 );
			self.notifyText2.glowColor = glowColor;	
			self.notifyText2.alpha = 1;
			anchorElem = self.notifyText2;
		}
	}

	if ( isDefined( notifyData.notifyText3 ) )
	{
		if ( level.splitScreen )
		{
			if ( isDefined( notifyData.text3Label ) )
				self iPrintLnBold( notifyData.text3Label, notifyData.notifyText3 );
			else
				self iPrintLnBold( notifyData.notifyText3 );
		}
		else
		{
			self.notifyText3 setParent( anchorElem );
			
			if ( isDefined( notifyData.text3Label ) )
				self.notifyText3.label = notifyData.text3Label;
			else
				self.notifyText3.label = &"";

			if ( isDefined( notifyData.text3Label ) && !isDefined( notifyData.textIsString ) )
				self.notifyText3 setValue( notifyData.notifyText3 );
			else
				self.notifyText3 setText( notifyData.notifyText3 );
	
			self.notifyText3 setText( notifyData.notifyText3 );
			self.notifyText3 setPulseFX( 100, int(duration*1000), 1000 );
			self.notifyText3.glowColor = glowColor;	
			self.notifyText3.alpha = 1;
			anchorElem = self.notifyText3;
		}
	}

	if ( isDefined( notifyData.iconName ) && !level.splitScreen )
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
	// TODO - find coop version of this
	//if ( self maps\mp\_flashgrenades::isFlashbanged() )
	//	return false;
	
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
	self.doingNotify = false;
}

lowerMessageThink()
{
	self endon ( "disconnect" );
	
	self.lowerMessage = createFontString( "default", level.lowerTextFontSize );
	self.lowerMessage setPoint( "CENTER", level.lowerTextYAlign, 0, level.lowerTextY );
	self.lowerMessage setText( "" );
	self.lowerMessage.archived = false;
	
	timerFontSize = 1.5;
	if ( level.splitscreen )
		timerFontSize = 1.4;
	
	self.lowerTimer = createFontString( "default", timerFontSize );
	self.lowerTimer setParent( self.lowerMessage );
	self.lowerTimer setPoint( "TOP", "BOTTOM", 0, 0 );
	self.lowerTimer setText( "" );
	self.lowerTimer.archived = false;
}

waitTillNotifiesDone()
{
	pendingNotifies = true;
	timeWaited = 0;
	while( pendingNotifies && timeWaited < 12 )
	{
		pendingNotifies = false;
		players = get_players(); 
		for( i = 0; i < players.size; i++ )
		{
			if( IsDefined( players[i].notifyQueue ) && players[i].notifyQueue.size > 0 )
			{
				pendingNotifies = true;
			}
		}
		if( pendingNotifies )
			wait .2;
		timeWaited += .2;
	}
}