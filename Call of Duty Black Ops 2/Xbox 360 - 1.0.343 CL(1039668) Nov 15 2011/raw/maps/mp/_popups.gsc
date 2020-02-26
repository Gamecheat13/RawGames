// some common functions between all the air kill streaks
#include maps\mp\_utility;
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
	level.momentumNotifyWaitLastTime = 1;
	level.teamMessageQueueMax = 8;

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
			level.players[0] maps\mp\gametypes\_missions::milestoneNotify( 1, challengeIndex, 1, 1 );
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
			
			self displayTeamMessage( nextNotifyData.message, nextNotifyData.player, "uin_alert_slideout" );
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
	// ACOLE: The endon clause in the line below actually causes the game to hang at the end of 
	// any match where a notification is happening when the match ends.  This is because the 
	// "game_ended" notification happens before the end of game screen is done displaying.
	//level endon( "game_ended" );
	
	self.medalNotifyQueue = [];
	self.killstreakNotifyQueue = [];
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
		if ( self.startMessageNotifyQueue.size == 0 && self.rankNotifyQueue.size == 0 && self.wagerNotifyQueue.size == 0 && self.pers["contractNotifyQueue"].size == 0 && self.medalNotifyQueue.size == 0 && self.killstreakNotifyQueue.size == 0 && self.messageNotifyQueue.size == 0 && self.pers["challengeNotifyQueue"].size == 0 )
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
		else if ( self.wagerNotifyQueue.size > 0 )
		{
			self.doingNotify = true;
			
			message = self.wagerNotifyQueue[0].message;
			points = self.wagerNotifyQueue[0].points;
			if ( !IsDefined( points ) )
				points = 0;
			subMessage = self.wagerNotifyQueue[0].subMessage;
			announcement = self.wagerNotifyQueue[0].announcement;
			
			for ( i = 1 ; i < self.wagerNotifyQueue.size ; i++ )
				self.wagerNotifyQueue[i-1] = self.wagerNotifyQueue[i];
				
			self.wagerNotifyQueue[i-1] = undefined;
			if ( IsDefined( subMessage ) )
				self displayWagerPopup( message, points, subMessage );
			else
				self displayWagerPopup( message, points );
				
			if ( IsDefined( announcement ) )
				self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( announcement );
			
			wait ( level.wagerSettings.waitTime / 2 );
			if ( self.wagerNotifyQueue.size == 0 )
				wait ( level.wagerSettings.waitTime / 2 );
			
			self.doingNotify = false;
		}			
		else if ( self.medalNotifyQueue.size > 0 )
		{
			nextNotifyData = self.medalNotifyQueue[0];
			
			for ( i = 1; i < self.medalNotifyQueue.size; i++ )
				self.medalNotifyQueue[i-1] = self.medalNotifyQueue[i];
			
			self.medalNotifyQueue[i-1] = undefined;
			
			sound = "uin_challenge_repeatable";
			self displayMedal( level.medalInfo[nextNotifyData.medalName]["index"], level.teambased, level.xpScale, sound );
			
			// This is the scr_popupchallenge - milestones
			wait ( level.medalSettings.waitTime );
		}
		else if ( self.pers["contractNotifyQueue"].size > 0 )
		{
			if ( self.resetGameOverHudRequired == true )
			{
				self notify( "reset_outcome" );
				self.resetGameOverHudRequired = false;
			}
			contractIndex = self.pers["contractNotifyQueue"][0]["index"];
			passed = self.pers["contractNotifyQueue"][0]["passed"];
			
			sound = "null";
			if (passed)
			{
				sound = "mus_contract_complete";
			}
			else
			{
				sound = "mus_contract_expire";	
			}
			self displayContract( contractIndex, sound, passed );


			// scr_popupcontract - Contract Completion
			wait ( level.contractSettings.waitTime );
			
			if ( !level.gameended && !wasLastRound() )
			{
				for ( i = 1; i < self.pers["contractNotifyQueue"].size; i++ )
					self.pers["contractNotifyQueue"][i-1] = self.pers["contractNotifyQueue"][i];
			
				self.pers["contractNotifyQueue"][i-1] = undefined;
			}	
		}
		else if ( self.pers["challengeNotifyQueue"].size > 0 )
		{
			if ( self.resetGameOverHudRequired == true )
			{
				self notify( "reset_outcome" );
				self.resetGameOverHudRequired = false;
			}
			
			tier = self.pers["challengeNotifyQueue"][0]["tier"];
			index = self.pers["challengeNotifyQueue"][0]["index"];
			itemIndex = self.pers["challengeNotifyQueue"][0]["itemIndex"];
			type = self.pers["challengeNotifyQueue"][0]["type"];
			
			sound = "mus_challenge_complete";
			
			self DisplayChallengeComplete( tier, index, 1, itemIndex, sound, type );

			// scr_popupchallenge - milestones
			wait ( level.challengeSettings.waitTime );
						
			if ( !level.gameended && !wasLastRound() )
			{
				for ( i = 1; i < self.pers["challengeNotifyQueue"].size; i++ )
					self.pers["challengeNotifyQueue"][i-1] = self.pers["challengeNotifyQueue"][i];
			
				self.pers["challengeNotifyQueue"][i-1] = undefined;
			}	
		}
		else if ( self.pers[ "gunChallengeQueue" ].size > 0 )
		{
			if ( self.resetGameOverHudRequired == true )
			{
				self notify( "reset_outcome" );
				self.resetGameOverHudRequired = false;
			}
				
			rankID = self.pers[ "gunChallengeQueue" ][0][ "rankID" ];
			itemIndex = self.pers[ "gunChallengeQueue" ][0][ "itemIndex" ];
			rewardXP = self.pers[ "gunChallengeQueue" ][0][ "rewardXP" ];
			attachment = self.pers[ "gunChallengeQueue" ][0][ "attachment" ];
			
			sound = "mus_level_up";
			self DisplayGunLevelUp( rankID, itemIndex, rewardXP, attachment, sound );

		  // scr_popuprank - level up
			wait ( level.challengeSettings.waitTime );
			
			if ( !level.gameended && !wasLastRound() )
			{
				for ( i = 1; i < self.pers[ "gunChallengeQueue" ].size; i++ )
					self.pers[ "gunChallengeQueue" ][i-1] = self.pers[ "gunChallengeQueue" ][i];
			
				self.pers[ "gunChallengeQueue" ][i-1] = undefined;
			}
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
				
			self LUINotifyEvent( &"killstreak_notify", 1, killstreakTableNumber );

			self maps\mp\killstreaks\_killstreaks::playKillstreakReadyAndInformDialog( hardpointType );

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
			
			self maps\mp\gametypes\_hud_message::showNotifyMessage( nextNotifyData, duration );
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
	
	// THis is to display end of game notifications, this will show in the endgame menu after the final kill cam
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
		//player.medalNotifyQueue = [];
		//player.pers["contractNotifyQueue"] = [];
		//player.pers["challengeNotifyQueue"] = [];
		player thread displayPopupsWaiter();
		player thread displayMomentumPopupsWaiter();
		if ( !level.hardcoreMode ) 
		{
			player thread displayTeamMessageWaiter();
		}
	}
}

