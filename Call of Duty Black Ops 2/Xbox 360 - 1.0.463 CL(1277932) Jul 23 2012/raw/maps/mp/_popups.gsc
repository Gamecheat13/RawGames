// some common functions between all the air kill streaks
#include maps\mp\_utility;
#include common_scripts\utility;

#insert raw\maps\mp\_scoreevents.gsh;

init()
{
	// if the column changes in the medalTable.csv 
	// these need to be changed too
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
	level.momentumNotifyWaitTime = 0;
	level.momentumNotifyWaitLastTime = 0;
	level.teamMessageQueueMax = 8;

	precacheString( &"KILLSTREAK_DESTROYED_UAV" );	
	precacheString( &"KILLSTREAK_DESTROYED_COUNTERUAV" );	
	precacheString( &"KILLSTREAK_DESTROYED_REMOTE_MORTAR" );	
	precacheString( &"KILLSTREAK_MP40_INBOUND" );	
	precacheString( &"KILLSTREAK_M220_TOW_INBOUND" );	
	precacheString( &"KILLSTREAK_MINIGUN_INBOUND" );	
	precacheString( &"KILLSTREAK_M202_FLASH_INBOUND" );	
	precacheString( &"KILLSTREAK_M32_INBOUND");	
	precacheString( &"MP_CAPTURED_THE_FLAG" );	
	precacheString( &"MP_KILLED_FLAG_CARRIER" );	
	precacheString( &"MP_FRIENDLY_FLAG_DROPPED" );
	precacheString( &"MP_ENEMY_FLAG_DROPPED" );
	precacheString( &"MP_FRIENDLY_FLAG_RETURNED" );
	precacheString( &"MP_ENEMY_FLAG_RETURNED" );
	precacheString( &"MP_FRIENDLY_FLAG_TAKEN" );
	precacheString( &"MP_ENEMY_FLAG_TAKEN" );
	precacheString( &"MP_ENEMY_FLAG_CAPTURED" );
	precacheString( &"MP_FRIENDLY_FLAG_CAPTURED" );
	precacheString( &"MP_EXPLOSIVES_BLOWUP_BY" );
	precacheString( &"MP_EXPLOSIVES_DEFUSED_BY" );	
	precacheString( &"MP_EXPLOSIVES_PLANTED_BY" );	
	precacheString( &"MP_HQ_DESTROYED_BY" );
	precacheString( &"KILLSTREAK_DESTROYED_HELICOPTER" );
/#
	level thread popupsFromConsole();
#/

	level thread onPlayerConnect();
}

popupsFromConsole()
{
	while (1)
	{	
		timeout = GetDvarIntDefault( "scr_popuptime", 1.0 );
		if ( timeout == 0 )
			timeout = 1;
		wait (timeout);	
		medal = GetDvarIntDefault( "scr_popupmedal", 0 );
		challenge = GetDvarIntDefault( "scr_popupchallenge", 0 );
		rank = GetDvarIntDefault( "scr_popuprank", 0 );
		contractPass = GetDvarIntDefault( "scr_popupcontractpass", 0 ); //sting 01	
		contractFail = GetDvarIntDefault( "scr_popupcontractfail", 0 );	// Stinger_02
		gameModeMsg = GetDvarIntDefault( "scr_gamemodeslideout", 0 );
		teamMsg = GetDvarIntDefault( "scr_teamslideout", 0 );
		
		challengeIndex = GetDvarIntDefault( "scr_challengeIndex", 1 );
		
		for ( i = 0 ; i < medal; i++ )
			level.players[0] AddPlayerStat( "BACK_STABBER", 1 );
		for ( i = 0 ; i < challenge; i++ )
			level.players[0] milestoneNotify( 1, challengeIndex, 1, 1 );
		for ( i = 0 ; i < rank; i++ )
			level.players[0] maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		for ( i = 0 ; i < contractPass; i++ )
			level.players[0] maps\mp\gametypes\_persistence::addContractToQueue( 12, 1 );
		for ( i = 0 ; i < contractFail; i++ )
			level.players[0] maps\mp\gametypes\_persistence::addContractToQueue( 12, 0 );
		for ( i = 0 ; i < gameModeMsg; i++ )
			level.players[0] DisplayGameModeMessage( &"MP_HQ_REVEALED", "uin_alert_slideout" );
		for ( i = 0 ; i < teamMsg; i++ )
		{
			player = level.players[0];
			if ( isdefined ( level.players[1] ) )
				player = level.players[1];
			level.players[0] DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_HELICOPTER", player );
		}
		
		reset = GetDvarIntDefault( "scr_popupreset", 1 );
		if ( reset )
		{
			if ( medal ) 
				SetDvar( "scr_popupmedal", 0 );
			if ( challenge ) 
				SetDvar( "scr_popupchallenge", 0 );
			if ( rank ) 
				SetDvar( "scr_popuprank", 0 );
			if ( contractPass ) 
				SetDvar( "scr_popupcontractpass", 0 );	
			if ( contractFail ) 
				SetDvar( "scr_popupcontractfail", 0 );	
			if ( gameModeMsg ) 
				SetDvar( "scr_gamemodeslideout", 0 );
			if ( teamMsg ) 
				SetDvar( "scr_teamslideout", 0 );
		}
	}
}

DisplayKillstreakTeamMessageToAll( killstreak, player )
{
	if ( !isdefined ( level.killstreaks[killstreak] ) )
		return;
	if ( !isdefined ( level.killstreaks[killstreak].inboundText ) )
		return;
		
	message = level.killstreaks[killstreak].inboundText;
	self DisplayTeamMessageToAll( message, player );
}

shouldDisplayTeamMessages()
{
	// level.splitscreen is the local splitscreen mode only
	if ( level.hardcoreMode == true || level.splitscreen == true ) 
		return false;	
		
	return true;
}

DisplayTeamMessageToAll( message, player )
{
	if ( !shouldDisplayTeamMessages() )
		return;
		
	for ( i = 0; i < level.players.size; i++ )
	{		
		cur_player = level.players[i];

		if ( cur_player IsEMPJammed() )
			continue;

		size = cur_player.teamMessageQueue.size;

		if ( size >= level.teamMessageQueueMax )
			continue;
				
		cur_player.teamMessageQueue[size] = spawnStruct();
		cur_player.teamMessageQueue[size].message = message;
		cur_player.teamMessageQueue[size].player = player;
		
		cur_player notify ( "received teammessage" );
	}
}

DisplayTeamMessageToTeam( message, player, team )
{ 
	if ( !shouldDisplayTeamMessages() ) 
		return;

	for ( i = 0; i < level.players.size; i++ ) 
	{
		cur_player = level.players[i]; 

		if ( cur_player.team != team ) 
			continue;

		if ( cur_player IsEMPJammed() )
			continue;

		size = cur_player.teamMessageQueue.size;

		if ( size >= level.teamMessageQueueMax )
			continue;

		cur_player.teamMessageQueue[size] = spawnStruct();
		cur_player.teamMessageQueue[size].message = message;
		cur_player.teamMessageQueue[size].player = player; 

		cur_player notify ( "received teammessage" ); 
	}
}

displayTeamMessageWaiter()
{
	if ( !shouldDisplayTeamMessages() )
		return;

	self endon( "disconnect" );
	level endon( "game_ended" );
	
	self.teamMessageQueue = [];
	
	for ( ;; )
	{
		if ( self.teamMessageQueue.size == 0 )
			self waittill( "received teammessage" );
		
		if ( self.teamMessageQueue.size > 0 )
		{	
			nextNotifyData = self.teamMessageQueue[0];
			
			size = self.teamMessageQueue.size;
			for ( i = 0; i < size - 1; i++ )
			{
				self.teamMessageQueue[i] = self.teamMessageQueue[i+1];
			}
				
			self.teamMessageQueue[size-1] = undefined;

			if ( !isdefined( nextNotifyData.player ) || !isplayer( nextNotifyData.player ) )
				continue;

			if ( self IsEMPJammed() )
				continue;
			
			self LUINotifyEvent( &"player_callout", 2, nextNotifyData.message, nextNotifyData.player.entnum );
		}
		wait ( level.teamMessage.waittime );
	}
}

displayMomentumPopupsWaiter()
{
	self endon( "disconnect" );
	
	self.momentumNotifyQueue = [];
	
	while( !level.gameEnded && !wasLastRound() )
	{
		if ( self.momentumNotifyQueue.size == 0 )
			self waittill( "momentum_popup" );
		
		waittillframeend;
		
		if ( level.gameEnded && !wasLastRound()  )
			break;
		
		if ( self.momentumNotifyQueue.size > 0 )
		{
			score = self.momentumNotifyQueue[0].score;
			label = self.momentumNotifyQueue[0].label;
			descValue = self.momentumNotifyQueue[0].descValue;
			countsTowardRampage = self.momentumNotifyQueue[0].countsTowardRampage;
			
			for ( i = 1; i < self.momentumNotifyQueue.size; i++ )
				self.momentumNotifyQueue[i-1] = self.momentumNotifyQueue[i];
			
			self.momentumNotifyQueue[i-1] = undefined;
			
			self maps\mp\gametypes\_globallogic_score::givePlayerMomentumNotification( score, label, descValue, countsTowardRampage );
			
			if ( self.momentumNotifyQueue.size == 0 )
			{
				wait( level.momentumNotifyWaitLastTime );
			}
			else
			{
				wait( level.momentumNotifyWaitTime );
			}
		}
	}
}

displayPopUpsWaiter()
{
	self endon( "disconnect" );
	
	self.rankNotifyQueue = [];
	if ( !isdefined( self.pers["challengeNotifyQueue"] ) )
	{		
		self.pers["challengeNotifyQueue"] = [];
	}
	if ( !isdefined( self.pers["contractNotifyQueue"] ) )
	{		
		self.pers["contractNotifyQueue"] = [];
	}

	self.messageNotifyQueue = [];
	self.startMessageNotifyQueue = [];
	self.wagerNotifyQueue = [];
				
	while( !level.gameEnded && !wasLastRound() )
	{
		if ( self.startMessageNotifyQueue.size == 0 && self.rankNotifyQueue.size == 0 && self.messageNotifyQueue.size == 0 )
			self waittill( "received award" );
		
		waittillframeend;

		if ( level.gameEnded && !wasLastRound()  )
			break;
		
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
				
			self maps\mp\gametypes\_hud_message::showNotifyMessage( nextNotifyData, duration );
			wait ( duration );
		}
		else if ( self.rankNotifyQueue.size > 0 )
		{
			if ( self.resetGameOverHudRequired == true )
			{
				self notify( "reset_outcome" );
				self.resetGameOverHudRequired = false;
			}
				
			rank = self.rankNotifyQueue[0].rank;
			prestige = self.rankNotifyQueue[0].prestige;
			
			sound = "mus_level_up";
			self displayRankUp( rank, prestige, sound );

		    // scr_popuprank - level up
			wait ( level.rankSettings.waitTime );
			
			if ( !level.gameended && !wasLastRound() )
			{
				for ( i = 1; i < self.rankNotifyQueue.size; i++ )
					self.rankNotifyQueue[i-1] = self.rankNotifyQueue[i];
			
				self.rankNotifyQueue[i-1] = undefined;
			}
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
			
			self maps\mp\gametypes\_hud_message::showNotifyMessage( nextNotifyData, duration );
		}
		else
		{	
			//assertmsg( "displayPopUpsWaiter not handling case" );
			wait( 1 );
		}
	}
}

displayEndGamePopUps()
{
	self.postGamePromotion = false;
	self.postGameMilestones = 0;
	self.postGameContracts = 0;
	promoted = 0;
	contract0 = -1;
	contract1 = -1;
	contract2 = -1;
	sendMessage = false;
	
	// This is to display end of game notifications, this will show in the endgame menu after the final kill cam
	if ( self.rankNotifyQueue.size > 0 )
	{
		self.postGamePromotion = true;
		promoted =  1; // endgame promotion
		sendMessage = true;
	}

	if ( self.pers["contractNotifyQueue"].size > 0 )
	{	
		for( i = 0; i < self.pers["contractNotifyQueue"].size; i++ )
		{
			if ( self.pers["contractNotifyQueue"][0]["passed"] == false )
			{
				for ( i = 1; i < self.pers["contractNotifyQueue"].size; i++ )
					self.pers["contractNotifyQueue"][i-1] = self.pers["contractNotifyQueue"][i];
				
				self.pers["contractNotifyQueue"][i-1] = undefined;
			}
		}

		self.postGameContracts = self.pers["contractNotifyQueue"].size;
		if ( isdefined( self.pers["contractNotifyQueue"].size > 0 ) )
		{
			if ( isdefined (self.pers["contractNotifyQueue"][0] ) )
			{
				contract0 = self.pers["contractNotifyQueue"][0]["index"]; 
				sendMessage = true;
			}
		}
		if ( isdefined( self.pers["contractNotifyQueue"].size > 1 ) )
		{
			if ( isdefined (self.pers["contractNotifyQueue"][1] ) )
			{
				contract1 = self.pers["contractNotifyQueue"][1]["index"]; 
				sendMessage = true;
			}
		}
		if ( isdefined( self.pers["contractNotifyQueue"].size > 2 ) )
		{
			if ( isdefined (self.pers["contractNotifyQueue"][2] ) )
			{
				contract2 = self.pers["contractNotifyQueue"][2]["index"]; 
				sendMessage = true;
			}
		}
	}
	
	if ( sendMessage == true )
	{
		self DisplayEndGame( promoted, contract0, contract1, contract2 );
	}
	
	
	for ( challengeNotifyCount = 0; challengeNotifyCount < self.pers["challengeNotifyQueue"].size && challengeNotifyCount < 3; challengeNotifyCount++ )
	{
		self.postGameMilestones++;
		tier = self.pers["challengeNotifyQueue"][challengeNotifyCount]["tier"];
		index = self.pers["challengeNotifyQueue"][challengeNotifyCount]["index"];
		itemIndex = self.pers["challengeNotifyQueue"][challengeNotifyCount]["itemIndex"];
		type = self.pers["challengeNotifyQueue"][challengeNotifyCount]["type"];
		self DisplayEndGameMilestone( challengeNotifyCount, tier, index, itemIndex, type );
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
		player thread displayMomentumPopupsWaiter();
		if ( !level.hardcoreMode ) 
		{
			player thread displayTeamMessageWaiter();
		}
	}
}

milestoneNotify( index, itemIndex, type, tier )
{
	level.globalChallenges++;
	
	if ( !isDefined( type ) )
	{
		type = "global";
	}
	size = self.pers["challengeNotifyQueue"].size;
	self.pers["challengeNotifyQueue"][size] = [];
	self.pers["challengeNotifyQueue"][size]["tier"] = tier;
	self.pers["challengeNotifyQueue"][size]["index"] = index;
	self.pers["challengeNotifyQueue"][size]["itemIndex"] = itemIndex;
	self.pers["challengeNotifyQueue"][size]["type"] = type;
		
	self notify( "received award" );
}

