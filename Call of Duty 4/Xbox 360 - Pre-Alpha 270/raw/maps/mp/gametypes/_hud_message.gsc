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
	}
}


hintMessage( hintText )
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
	self.hintMessage setText( hintText );
	self.hintMessage endon ( "death" );
	
	self.hintMessage setPulseFX( 40, 3000, 1000 );

	wait ( (3000 + 1000) / 1000 );
	/*	
	wait ( 3.0 );	
	self.hintMessage fadeOverTime( 2.5 );
	self.hintMessage.alpha = 0;
	wait ( 3.0 );
	*/
	self.hintMessage destroyElem();
}

teamNotify( teamText, teamIcon )
{
	self.suppressHints = true;
	
	self endon ( "disconnect" );

	teamNotifyMessage = createFontString( "objective", 3.0 );
	teamNotifyMessage setPoint( "TOP", undefined, 0, 30 );
	teamNotifyMessage setText( teamText );
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
