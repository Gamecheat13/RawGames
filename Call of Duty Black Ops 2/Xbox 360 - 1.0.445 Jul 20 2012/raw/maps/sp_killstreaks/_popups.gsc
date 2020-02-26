// some common functions between all the air kill streaks
#include maps\_utility;
#include common_scripts\utility;


init()
{
	// if the column changes in the medalTable.csv 
	// these need to be changed too
	level.medalSettings.waitTime = 1.25;
	level.contractSettings = spawnstruct();
	level.contractSettings.waitTime = 4.2;
	level.killstreakSettings = spawnstruct();
	level.killstreakSettings.waitTime = 3;
	level.rankSettings = spawnstruct();
	level.rankSettings.waitTime = 3;
	level.startMessage = spawnstruct();
	level.startMessageDefaultDuration = 2.0;
	level.endMessageDefaultDuration = 2.0;
	level.challengeSettings = spawnstruct();
	level.challengeSettings.waitTime = 3;
	level.teamMessage = spawnstruct();
	level.teamMessage.waittime = 3;
	level.regularGameMessages = spawnstruct();
	level.regularGameMessages.waittime = 6;
	level.wagerSettings = spawnstruct();
	level.wagerSettings.waittime = 3;
	level.momentumNotifyWaitTime = 0.5;

	level thread onPlayerConnect();
}

displayPopUpsWaiter()
{
	self endon( "disconnect" );
	// ACOLE: The endon clause in the line below actually causes the game to hang at the end of 
	// any match where a notification is happening when the match ends.  This is because the 
	// "game_ended" notification happens before the end of game screen is done displaying.
	//level endon( "game_ended" );
	
	self.killstreakNotifyQueue = [];

	self.messageNotifyQueue = [];
	self.startMessageNotifyQueue = [];
				
	while( 1 )
	{
		if ( self.killstreakNotifyQueue.size == 0 && self.messageNotifyQueue.size == 0 )
			self waittill( "received award" );
		
		waittillframeend;
		
		if ( self.startMessageNotifyQueue.size > 0 )
		{
			self clearCenterPopups();
							
			nextNotifyData = self.startMessageNotifyQueue[0];
			
			for ( i = 1; i < self.startMessageNotifyQueue.size; i++ )
				self.startMessageNotifyQueue[i-1] = self.startMessageNotifyQueue[i];
			
			self.startMessageNotifyQueue[i-1] = undefined;
			
			if ( isDefined( nextNotifyData.duration ) )
				duration = nextNotifyData.duration;
			else
				duration = level.startMessageDefaultDuration;
				
			//self maps\gametypes\_hud_message::showNotifyMessage( nextNotifyData, duration );
			wait ( duration );
		}	
		else if ( self.killstreakNotifyQueue.size > 0 )
		{
			streakCount = self.killstreakNotifyQueue[0].streakCount;
			killstreakTableNumber = self.killstreakNotifyQueue[0].killstreakTableNumber;
			hardpointType = self.killstreakNotifyQueue[0].hardpointType;
			
			for ( i = 1; i < self.killstreakNotifyQueue.size; i++ )
				self.killstreakNotifyQueue[i-1] = self.killstreakNotifyQueue[i];
			
			self.killstreakNotifyQueue[i-1] = undefined;
			
			if ( !isdefined ( streakCount ) )
				streakCount = 0;
				
			self displayKillstreak( streakCount, killstreakTableNumber );

			wait ( level.killstreakSettings.waitTime );
		}
		else if ( self.messageNotifyQueue.size > 0 )
		{
			self clearCenterPopups();
			
			nextNotifyData = self.messageNotifyQueue[0];
			
			for ( i = 1; i < self.messageNotifyQueue.size; i++ )
				self.messageNotifyQueue[i-1] = self.messageNotifyQueue[i];
			
			self.messageNotifyQueue[i-1] = undefined;
			
			if ( isDefined( nextNotifyData.duration ) )
				duration = nextNotifyData.duration;
			else
				duration = level.regularGameMessages.waittime;
			
			//self maps\gametypes\_hud_message::showNotifyMessage( nextNotifyData, duration );
		}	
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player clearendgame();
		player clearPopups();		
		player.resetGameOverHudRequired = false;
		player thread displayPopupsWaiter();
	}
}

