#include maps\mp\gametypes\_hud_util;

init()
{
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

//		player thread initMessageBuffer();
		player thread hintMessageDeathThink();
		player thread lowerMessageThink();
		
		player thread initNotifyMessage();
	}
}


hintMessage( hintText1, hintText2 )
{
	self endon ( "disconnect" );

	if ( isDefined( self.hintMessage ) || isDefined( self.suppressHints ) )
	{
		self endon ( "death" );
		
		while ( isDefined( self.hintMessage ) || isDefined( self.suppressHints ) )
			wait 0.05;		
	}

	self.hintMessage = createFontString( "objective", 1.65 );
	self.hintMessage setPoint( "TOP", undefined, 0, 30 );
	self.hintMessage setText( hintText1 );
	self.hintMessage endon ( "death" );
	self.hintMessage.glowColor = (0.3, 0.6, 0.3);
	self.hintMessage.glowAlpha = 1;
	
	if ( isDefined( hintText2 ) )
	{
		self.hintMessage setPulseFX( 10, 3500, 1000 );
		wait ( 0.5 );

		self.hintMessage2 = createFontString( "objective", 1.65 );
		self.hintMessage2 setPoint( "TOP", undefined, 0, 50 );
		self.hintMessage2 setText( hintText2 );
		self.hintMessage2 endon ( "death" );
		self.hintMessage2.glowColor = (0.3, 0.6, 0.3);
		self.hintMessage2.glowAlpha = 1;
		
		self.hintMessage2 setPulseFX( 40, 3000, 1000 );

		wait ( (3000 + 1000) / 1000 );

		self.hintMessage destroyElem();
		self.hintMessage2 destroyElem();
	}
	else
	{
		self.hintMessage setPulseFX( 40, 3000, 1000 );
		wait ( (3000 + 1000) / 1000 );

		self.hintMessage destroyElem();
	}
}


initNotifyMessage()
{
	self.notifyTitle = createFontString( "objective", 3.0 );
	self.notifyTitle setPoint( "TOP", undefined, 0, 30 );
	self.notifyTitle.glowColor = (0.2, 0.3, 0.7);
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle setText( "Notify Title Message" );
	self.notifyTitle.hideWhenInMenu = true;
	self.notifyTitle.alpha = 0;

	self.notifyText = createFontString( "objective", 2.0 );
	self.notifyText setParent( self.notifyTitle );
	self.notifyText setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyText.glowColor = (0.2, 0.3, 0.7);
	self.notifyText.glowAlpha = 1;
	self.notifyText setText( "Notify text message and info." );
	self.notifyText.hideWhenInMenu = true;
	self.notifyText.alpha = 0;

	self.notifyIcon = createIcon( "white", 60, 60 );
	self.notifyIcon setParent( self.notifyText );
	self.notifyIcon setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyIcon.hideWhenInMenu = true;
	self.notifyIcon.alpha = 0;

	self.doingNotify = false;
}


notifyMessage( titleText, notifyText, iconName, glowColor, sound )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	while ( self.doingNotify )
		wait ( 0.05 );
	
	self.doingNotify = true;

	self thread resetNotify();

	if ( isDefined( sound ) )
		self playLocalSound( sound );
	
	if ( !isDefined( glowColor ) )
		glowColor = (0.3, 0.6, 0.3);

	if ( isDefined( titleText ) )
	{
		self.notifyTitle setText( titleText );
		self.notifyTitle setPulseFX( 100, 3000, 1000 );
		self.notifyTitle.glowColor = glowColor;
		self.notifyTitle.alpha = 1;
	}

	if ( isDefined( notifyText ) )
	{
		self.notifyText setText( notifyText );
		self.notifyText setPulseFX( 100, 3000, 1000 );
		self.notifyText.glowColor = glowColor;
		self.notifyText.alpha = 1;
	}

	if ( isDefined( iconName ) )
	{
		self.notifyIcon setShader( iconName, 60, 60 );
		self.notifyIcon.alpha = 0;
		self.notifyIcon fadeOverTime( 1.0 );
		self.notifyIcon.alpha = 1;
		
		wait ( 4.0 );

		self.notifyIcon fadeOverTime( 0.75 );
		self.notifyIcon.alpha = 0;
	}
	else
	{
		wait ( 4.0 );
	}

	self notify ( "notifyMessageDone" );
	self.doingNotify = false;
}


resetNotify()
{
	self endon ( "notifyMessageDone" );
	self endon ( "disconnect" );
	self waittill ( "death" );
	
	self.notifyTitle.alpha = 0;
	self.notifyText.alpha = 0;
	self.notifyIcon.alpha = 0;
	self.doingNotify = false;
}


teamNotify( teamText, teamIcon )
{
	self.suppressHints = true;
	
	self endon ( "disconnect" );

	teamNotifyMessage = createFontString( "objective", 3.0 );
	teamNotifyMessage setPoint( "TOP", undefined, 0, 30 );
	teamNotifyMessage setText( teamText );
	teamNotifyMessage.glowColor = (0.2, 0.3, 0.7);
	teamNotifyMessage.glowAlpha = 1;

	teamNotifyMessage setPulseFX( 100, 4000, 1000 );
	
	teamNotifyIcon = createIcon( teamIcon, 60, 60 );
	teamNotifyIcon setParent( teamNotifyMessage );
	teamNotifyIcon setPoint( "TOP", "BOTTOM", 0, 0 );
	teamNotifyIcon.alpha = 0;
	teamNotifyIcon fadeOverTime( 1.0 );
	teamNotifyIcon.alpha = 1;

	wait ( 4.0 );
	
	teamNotifyIcon fadeOverTime( 0.75 );
	teamNotifyIcon.alpha = 0;
	
	wait ( 2.0 );
	
	teamNotifyMessage destroyElem();
	teamNotifyIcon destroyElem();
	
	self.suppressHints = undefined;
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
	
	self.lowerTimer = createFontString( "default", 1.5 );
	self.lowerTimer setParent( self.lowerMessage );
	self.lowerTimer setPoint( "TOP", "BOTTOM", 0, 0 );
	self.lowerTimer setText( "" );
}

/*
initMessageBuffer()
{
	self endon( "disconnect" );
	self.messageBuffer = [];
	
	while ( true )
	{
		curTime = getTime();
		
		for ( index = 0; index < 5; index++ )
		{
			if ( !isDefined( self.messageBuffer[index] ) )
				continue;
			
			if ( curTime - self.messageBuffer[index].addTime > 3000 )
			{
				if ( !self.messageBuffer[index].isFading )
				{
					self.messageBuffer[index].isFading = true;
					self.messageBuffer[index] fadeOverTime( 2.0 );			
					self.messageBuffer[index].alpha = 0;
				}
				else if ( curTime - self.messageBuffer[index].addTime > 5000 )
				{
					self.messageBuffer[index] destroy();
				}
			}
		}
		
		wait ( 0.05 );
	}
}
*/

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



outcomeNotify( winner )
{
	duration = 6000;
	
	if ( winner == "tie" )
	{
		winnerTitle = createServerFontString( "objective", 3.0 );
		winnerTitle setPoint( "TOP", undefined, 0, 30 );
		winnerTitle.glowColor = (0.2, 0.3, 0.7);
		winnerTitle.glowAlpha = 1;
		winnerTitle setText( "Draw" );
		winnerTitle.hideWhenInMenu = false;
		winnerTitle setPulseFX( 100, duration, 1000 );
	
		winnerText = createServerFontString( "objective", 2.0 );
		winnerText setParent( winnerTitle );
		winnerText setPoint( "TOP", "BOTTOM", 0, 0 );
		winnerText.glowColor = (0.2, 0.3, 0.7);
		winnerText.glowAlpha = 1;
		winnerText setText( "Mission Failed" );
		winnerText.hideWhenInMenu = false;
		winnerText setPulseFX( 100, duration, 1000 );
		
		loserTitle = undefined;
		loserText = undefined;
		winner = "allies";
	}
	else
	{
		winnerTitle = createServerFontString( "objective", 3.0, winner );
		winnerTitle setPoint( "TOP", undefined, 0, 30 );
		winnerTitle.glowColor = (0.2, 0.3, 0.7);
		winnerTitle.glowAlpha = 1;
		winnerTitle setText( "Victory!" );
		winnerTitle.hideWhenInMenu = false;
		winnerTitle setPulseFX( 100, duration, 1000 );
	
		winnerText = createServerFontString( "objective", 2.0, winner );
		winnerText setParent( winnerTitle );
		winnerText setPoint( "TOP", "BOTTOM", 0, 0 );
		winnerText.glowColor = (0.2, 0.3, 0.7);
		winnerText.glowAlpha = 1;
		winnerText setText( "Mission Accomplished" );
		winnerText.hideWhenInMenu = false;
		winnerText setPulseFX( 100, duration, 1000 );
	
		loserTitle = createServerFontString( "objective", 3.0, level.otherTeam[winner] );
		loserTitle setPoint( "TOP", undefined, 0, 30 );
		loserTitle.glowColor = (0.2, 0.3, 0.7);
		loserTitle.glowAlpha = 1;
		loserTitle setText( "Defeat!" );
		loserTitle.hideWhenInMenu = false;
		loserTitle setPulseFX( 100, duration, 1000 );
	
		loserText = createServerFontString( "objective", 2.0, level.otherTeam[winner] );
		loserText setParent( loserTitle );
		loserText setPoint( "TOP", "BOTTOM", 0, 0 );
		loserText.glowColor = (0.2, 0.3, 0.7);
		loserText.glowAlpha = 1;
		loserText setText( "Mission Failed" );
		loserText.hideWhenInMenu = false;
		loserText setPulseFX( 100, duration, 1000 );
	}
		
	winnerIcon = createServerIcon( game["icons"][winner], 70, 70 );
	winnerIcon setParent( winnerText );
	winnerIcon setPoint( "TOP", "BOTTOM", -60, 30 );
	winnerIcon.hideWhenInMenu = false;
	winnerIcon.alpha = 0;
	winnerIcon fadeOverTime( 0.5 );
	winnerIcon.alpha = 1;

	loserIcon = createServerIcon( game["icons"][level.otherTeam[winner]], 70, 70 );
	loserIcon setParent( winnerText );
	loserIcon setPoint( "TOP", "BOTTOM", 60, 30 );
	loserIcon.hideWhenInMenu = false;
	loserIcon.alpha = 0;
	loserIcon fadeOverTime( 0.5 );
	loserIcon.alpha = 1;

	winnerScore = createServerFontString( "objective", 3.0 );
	winnerScore setParent( winnerIcon );
	winnerScore setPoint( "TOP", "BOTTOM", 0, 30 );
	winnerScore.glowColor = game["colors"][winner];
	winnerScore.glowAlpha = 1;
	winnerScore setText( getTeamScore( winner ) );
	winnerScore.hideWhenInMenu = false;
	winnerScore setPulseFX( 100, duration, 1000 );

	loserScore = createServerFontString( "objective", 3.0 );
	loserScore setParent( loserIcon );
	loserScore setPoint( "TOP", "BOTTOM", 0, 30 );
	loserScore.glowColor = game["colors"][level.otherTeam[winner]];
	loserScore.glowAlpha = 1;
	loserScore setText( getTeamScore( level.otherTeam[winner] ) );
	loserScore.hideWhenInMenu = false;
	loserScore setPulseFX( 100, duration, 1000 );
	
	wait duration/1000;
	
	winnerIcon fadeOverTime( 1.0 );
	winnerIcon.alpha = 0;

	loserIcon fadeOverTime( 1.0 );
	loserIcon.alpha = 0;
	
	wait ( 1.0 );
	winnerTitle destroyElem();
	winnerText destroyElem();
	if ( isDefined( loserTitle ) )
		loserTitle destroyElem();
	if ( isDefined( loserText ) )
		loserText destroyElem();
	winnerIcon destroyElem();
	loserIcon destroyElem();
	winnerScore destroyElem();
	loserScore destroyElem();
}
/*

notifyMessage( titleText, notifyText, iconName, glowColor, sound )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	while ( self.doingNotify )
		wait ( 0.05 );
	
	self.doingNotify = true;

	self thread resetNotify();

	if ( isDefined( sound ) )
		self playLocalSound( sound );
	
	if ( !isDefined( glowColor ) )
		glowColor = (0.3, 0.6, 0.3);

	if ( isDefined( titleText ) )
	{
		self.notifyTitle setText( titleText );
		self.notifyTitle setPulseFX( 100, 3000, 1000 );
		self.notifyTitle.glowColor = glowColor;
		self.notifyTitle.alpha = 1;
	}

	if ( isDefined( notifyText ) )
	{
		self.notifyText setText( notifyText );
		self.notifyText setPulseFX( 100, 3000, 1000 );
		self.notifyText.glowColor = glowColor;
		self.notifyText.alpha = 1;
	}

	if ( isDefined( iconName ) )
	{
		self.notifyIcon setShader( iconName, 60, 60 );
		self.notifyIcon.alpha = 0;
		self.notifyIcon fadeOverTime( 1.0 );
		self.notifyIcon.alpha = 1;
		
		wait ( 4.0 );

		self.notifyIcon fadeOverTime( 0.75 );
		self.notifyIcon.alpha = 0;
	}
	else
	{
		wait ( 4.0 );
	}

	self notify ( "notifyMessageDone" );
	self.doingNotify = false;
}
*/