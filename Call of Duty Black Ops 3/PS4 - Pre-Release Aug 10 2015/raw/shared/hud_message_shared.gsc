#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "string", "MENU_POINTS" );
#precache( "eventstring", "faction_popup" );

#namespace hud_message;

function autoexec __init__sytem__() {     system::register("hud_message",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_start_gametype( &init );
}

function init()
{
	callback::on_connect( &on_player_connect );
}


function on_player_connect()
{
	self thread hintMessageDeathThink();
	self thread lowerMessageThink();
		
	self thread initNotifyMessage();
	self thread initCustomGametypeHeader();
}

function initCustomGametypeHeader()
{
	// Header
	font = "default";
	titleSize = 2.5;
	self.customGametypeHeader = hud::createFontString( font, titleSize );
	self.customGametypeHeader hud::setPoint( "TOP", undefined, 0, 30 );
	self.customGametypeHeader.glowAlpha = 1;
	self.customGametypeHeader.hideWhenInMenu = true;
	self.customGametypeHeader.archived = false;
	self.customGametypeHeader.color = ( 1, 1, 0.6 );
	self.customGametypeHeader.alpha = 1;
	
	// SubHeader
	titleSize = 2.0;
	self.customGametypeSubHeader = hud::createFontString( font, titleSize );
	self.customGametypeSubHeader hud::setParent( self.customGametypeHeader );
	self.customGametypeSubHeader hud::setPoint( "TOP", "BOTTOM", 0, 0 );
	self.customGametypeSubHeader.glowAlpha = 1;
	self.customGametypeSubHeader.hideWhenInMenu = true;
	self.customGametypeSubHeader.archived = false;
	self.customGametypeSubHeader.color = ( 1, 1, 0.6 );
	self.customGametypeSubHeader.alpha = 1;
}

function hintMessage( hintText, duration )
{
	notifyData = spawnstruct();
	
	notifyData.notifyText = hintText;
	notifyData.duration = duration;
	
	notifyMessage( notifyData );
}

function hintMessagePlayers( players, hintText, duration )
{
	notifyData = spawnstruct();
	notifyData.notifyText = hintText;
	notifyData.duration = duration;

	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] notifyMessage( notifyData );
	}
}

function showInitialFactionPopup( team )
{
	self LUINotifyEvent( &"faction_popup", 1, game["strings"][team + "_name"] );
	hud_message::oldNotifyMessage( undefined, undefined, undefined, undefined );
}

function initNotifyMessage()
{
	if( !SessionModeIsZombiesGame() )
	{
		if ( self IsSplitscreen() )
		{
			titleSize = 2.0;
			textSize = 1.4;
			iconSize = 24;
			font = "big";
			point = "TOP";
			relativePoint = "BOTTOM";
			yOffset = 30;
			xOffset = 30;
		}
		else
		{
			titleSize = 2.5;
			textSize = 1.75;
			iconSize = 30;
			font = "big";
			point = "TOP";
			relativePoint = "BOTTOM";
			yOffset = 0;
			xOffset = 0;
		}
	}
	else
	{	
		if ( self IsSplitscreen() )
		{
			titleSize = 2.0;
			textSize = 1.4;
			iconSize = 24;
			font = "big";
			point = "TOP";
			relativePoint = "BOTTOM";
			yOffset = 30;
			xOffset = 30;
		}
		else
		{
			titleSize = 2.5;
			textSize = 1.75;
			iconSize = 30;
			font = "big";
			point = "BOTTOM LEFT";
			relativePoint = "TOP";
			yOffset = 0;
			xOffset = 0;
		}
	}

	
	
	self.notifyTitle = hud::createFontString( font, titleSize );
	self.notifyTitle hud::setPoint( point, undefined, xOffset, yOffset );
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle.hideWhenInMenu = true;
	self.notifyTitle.archived = false;
	self.notifyTitle.alpha = 0;

	self.notifyText = hud::createFontString( font, textSize );
	self.notifyText hud::setParent( self.notifyTitle );
	self.notifyText hud::setPoint( point, relativePoint, 0, 0 );
	self.notifyText.glowAlpha = 1;
	self.notifyText.hideWhenInMenu = true;
	self.notifyText.archived = false;
	self.notifyText.alpha = 0;

	self.notifyText2 = hud::createFontString( font, textSize );
	self.notifyText2 hud::setParent( self.notifyTitle );
	self.notifyText2 hud::setPoint( point, relativePoint, 0, 0 );
	self.notifyText2.glowAlpha = 1;
	self.notifyText2.hideWhenInMenu = true;
	self.notifyText2.archived = false;
	self.notifyText2.alpha = 0;

	self.notifyIcon = hud::createIcon( "white", iconSize, iconSize );
	self.notifyIcon hud::setParent( self.notifyText2 );
	self.notifyIcon hud::setPoint( point, relativePoint, 0, 0 );
	self.notifyIcon.hideWhenInMenu = true;
	self.notifyIcon.archived = false;
	self.notifyIcon.alpha = 0;

	self.doingNotify = false;
	self.notifyQueue = [];
}

function oldNotifyMessage( titleText, notifyText, iconName, glowColor, sound, duration )
{
	if ( level.wagerMatch && !level.teamBased )
		return;
		
	notifyData = spawnstruct();
	
	notifyData.titleText = titleText;
	notifyData.notifyText = notifyText;
	notifyData.iconName = iconName;
	notifyData.sound = sound;
	notifyData.duration = duration;

	self.startMessageNotifyQueue[ self.startMessageNotifyQueue.size ] = notifyData;

	self notify( "received award" );
}

function notifyMessage( notifyData )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	if ( !isdefined( self.messageNotifyQueue ) )
	{
		self.messageNotifyQueue = [];
	}

	self.messageNotifyQueue[ self.messageNotifyQueue.size ] = notifyData;

	self notify( "received award" );
}
function playNotifyLoop(duration)
{
	playNotifyLoop = spawn ( "script_origin" , (0, 0, 0));
	playNotifyLoop PlayLoopSound ( "uin_notify_data_loop" );
	
	duration = duration - 4;
	
	if 	(duration < 1)
	{
		duration = 1;
	}
	
	wait (duration);
	playNotifyLoop Delete();
}

function showNotifyMessage( notifyData, duration )
{
	self endon("disconnect");
	
	self.doingNotify = true;

	waitRequireVisibility( 0 );

	self notify ( "notifyMessageBegin", duration );
	
	self thread resetOnCancel();

	if ( isdefined( notifyData.sound ) )
	{
		self playLocalSound( notifyData.sound );
	}
//	else
//	{
//		//self playLocalSound( "uin_notify_data" );
//		if 	( notifyData.loopSound)
//		{
//		self thread playNotifyLoop(duration);
//		}
//						
//	}
	
	if ( isdefined( notifyData.musicState ) )		
		self music::setmusicstate( notifyData.music );	

	if ( isdefined( notifyData.leaderSound ) )
	{
		if( isdefined( level.globallogic_audio_dialog_on_player_override ) )//TODO T7 - remove once globallogic_audio is shared
		{
			self [[ level.globallogic_audio_dialog_on_player_override ]]( notifyData.leaderSound );
		}
	}
	
	if ( isdefined( notifyData.glowColor ) )
		glowColor = notifyData.glowColor;
	else
		glowColor = (0.0, 0.0, 0.0);

	if ( isdefined( notifyData.color ) )
		color = notifyData.color;
	else
		color = (1.0, 1.0, 1.0);

	anchorElem = self.notifyTitle;

	if ( isdefined( notifyData.titleText ) )
	{
		if ( isdefined( notifyData.titleLabel ) )
			self.notifyTitle.label = notifyData.titleLabel;
		else
			self.notifyTitle.label = &"";

		if ( isdefined( notifyData.titleLabel ) && !isdefined( notifyData.titleIsString ) )
			self.notifyTitle setValue( notifyData.titleText );
		else
			self.notifyTitle setText( notifyData.titleText );
		self.notifyTitle setCOD7DecodeFX( 200, int(duration*1000), 600 );
		self.notifyTitle.glowColor = glowColor;	
		self.notifyTitle.color = color;	
		self.notifyTitle.alpha = 1;
	}

	if ( isdefined( notifyData.notifyText ) )
	{
		if ( isdefined( notifyData.textLabel ) )
			self.notifyText.label = notifyData.textLabel;
		else
			self.notifyText.label = &"";

		if ( isdefined( notifyData.textLabel ) && !isdefined( notifyData.textIsString ) )
			self.notifyText setValue( notifyData.notifyText );
		else
			self.notifyText setText( notifyData.notifyText );
		self.notifyText setCOD7DecodeFX( 100, int(duration*1000), 600 );
		self.notifyText.glowColor = glowColor;	
		self.notifyText.color = color;
		self.notifyText.alpha = 1;
		anchorElem = self.notifyText;
	}

	if ( isdefined( notifyData.notifyText2 ) )
	{
		if ( self IsSplitscreen() )
		{
			if ( isdefined( notifyData.text2Label ) )
				self iPrintLnBold( notifyData.text2Label, notifyData.notifyText2 );
			else
				self iPrintLnBold( notifyData.notifyText2 );
		}
		else
		{
			self.notifyText2 hud::setParent( anchorElem );
			
			if ( isdefined( notifyData.text2Label ) )
				self.notifyText2.label = notifyData.text2Label;
			else
				self.notifyText2.label = &"";
	
			self.notifyText2 setText( notifyData.notifyText2 );
			self.notifyText2 setPulseFX( 100, int(duration*1000), 1000 );
			self.notifyText2.glowColor = glowColor;
			self.notifyText2.color = color;
			self.notifyText2.alpha = 1;
			anchorElem = self.notifyText2;
		}
	}

	if ( isdefined( notifyData.iconName ) )
	{
		iconWidth= 60;
		iconHeight= 60;
		
		if (isdefined(notifyData.iconWidth))
		{
			iconWidth= notifyData.iconWidth;
		}
		if (isdefined(notifyData.iconHeight))
		{
			iconHeight= notifyData.iconHeight;
		}
		
		self.notifyIcon hud::setParent( anchorElem );
		self.notifyIcon setShader( notifyData.iconName, iconWidth, iconHeight );
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
}

// waits for waitTime, plus any time required to let flashbangs go away.
function waitRequireVisibility( waitTime )
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


function canReadText()
{
	if ( self util::is_flashbanged() )
		return false;
	
	return true;
}


function resetOnDeath()
{
	self endon ( "notifyMessageDone" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	self waittill ( "death" );

	resetNotify();
}


function resetOnCancel()
{
	self notify ( "resetOnCancel" );
	self endon ( "resetOnCancel" );
	self endon ( "notifyMessageDone" );
	self endon ( "disconnect" );

	level waittill ( "cancel_notify" );
	
	resetNotify();
}


function resetNotify()
{
	self.notifyTitle.alpha = 0;
	self.notifyText.alpha = 0;
	self.notifyText2.alpha = 0;
	self.notifyIcon.alpha = 0;
	self.doingNotify = false;
}


function hintMessageDeathThink()
{
	self endon ( "disconnect" );

	for ( ;; )
	{
		self waittill ( "death" );
		
		if ( isdefined( self.hintMessage ) )
			self.hintMessage hud::destroyElem();
	}
}

function lowerMessageThink()
{
	self endon ( "disconnect" );
	
	messageTextY = level.lowerTextY;
	if ( self IsSplitscreen() )
		messageTextY = level.lowerTextY - 50;
	
	self.lowerMessage = hud::createFontString( "default", level.lowerTextFontSize );
	self.lowerMessage hud::setPoint( "CENTER", level.lowerTextYAlign, 0, messageTextY );
	self.lowerMessage setText( "" );
	self.lowerMessage.archived = false;
	
	timerFontSize = 1.5;
	if ( self IsSplitscreen() )
		timerFontSize = 1.4;
	
	self.lowerTimer = hud::createFontString( "default", timerFontSize );
	self.lowerTimer hud::setParent( self.lowerMessage );
	self.lowerTimer hud::setPoint( "TOP", "BOTTOM", 0, 0 );
	self.lowerTimer setText( "" );
	self.lowerTimer.archived = false;
}

function setMatchScoreHUDElemForTeam( team )
{
	if ( level.cumulativeRoundScores )
	{
		self setValue( getTeamScore( team ) );
	}
	else
	{
		self setValue( util::get_rounds_won( team ) );
	}
}

function isInTop( players, topN )
{
	for ( i = 0 ; i < topN; i++ )
	{
		if ( isdefined( players[i] ) && ( self == players[i] ) )
		{
			return true;
		}
	}
	
	return false;
}

function destroyHudElem( hudElem )
{
	if( isdefined( hudElem ) )
		hudElem hud::destroyElem();
}

function setShoutcasterWaitingMessage()
{
	if ( !isdefined( self.waitingForPlayersText ) )
	{
		self.waitingForPlayersText = hud::createFontString( "objective", 2.5 );
		self.waitingForPlayersText hud::setPoint( "CENTER", "CENTER", 0, -80 );
		self.waitingForPlayersText.sort = 1001;
		self.waitingForPlayersText setText( &"MP_WAITING_FOR_PLAYERS_SHOUTCASTER" );
		self.waitingForPlayersText.foreground = false;
		self.waitingForPlayersText.hidewheninmenu = true;
	}
}

function clearShoutcasterWaitingMessage()
{
	if ( isdefined( self.waitingForPlayersText ) )
	{
		destroyHudElem( self.waitingForPlayersText );
		self.waitingForPlayersText = undefined;
	}
}

function waitTillNotifiesDone()
{
	pendingNotifies = true;
	timeWaited = 0;
	while( pendingNotifies && timeWaited < 12 )
	{
		pendingNotifies = false;
		players = GetPlayers(); 
		for( i = 0; i < players.size; i++ )
		{
			if( isdefined( players[i].notifyQueue ) && players[i].notifyQueue.size > 0 )
			{
				pendingNotifies = true;
			}
		}
		if( pendingNotifies )
			wait .2;
		timeWaited += .2;
	}
}
