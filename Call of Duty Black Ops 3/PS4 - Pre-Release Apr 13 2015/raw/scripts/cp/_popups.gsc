#using scripts\codescripts\struct;

#using scripts\shared\hud_message_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_persistence;
#using scripts\cp\gametypes\_rank;

#using scripts\cp\_medals;
#using scripts\cp\_util;



#precache( "string", "KILLSTREAK_DESTROYED_UAV" );	
#precache( "string", "KILLSTREAK_DESTROYED_COUNTERUAV" );	
#precache( "string", "KILLSTREAK_DESTROYED_REMOTE_MORTAR" );	
#precache( "string", "KILLSTREAK_MP40_INBOUND" );	
#precache( "string", "KILLSTREAK_M220_TOW_INBOUND" );	
#precache( "string", "KILLSTREAK_MINIGUN_INBOUND" );	
#precache( "string", "KILLSTREAK_M202_FLASH_INBOUND" );	
#precache( "string", "KILLSTREAK_M32_INBOUND");	
#precache( "string", "MP_CAPTURED_THE_FLAG" );	
#precache( "string", "MP_KILLED_FLAG_CARRIER" );	
#precache( "string", "MP_FRIENDLY_FLAG_DROPPED" );
#precache( "string", "MP_ENEMY_FLAG_DROPPED" );
#precache( "string", "MP_FRIENDLY_FLAG_RETURNED" );
#precache( "string", "MP_ENEMY_FLAG_RETURNED" );
#precache( "string", "MP_FRIENDLY_FLAG_TAKEN" );
#precache( "string", "MP_ENEMY_FLAG_TAKEN" );
#precache( "string", "MP_ENEMY_FLAG_CAPTURED" );
#precache( "string", "MP_FRIENDLY_FLAG_CAPTURED" );
#precache( "string", "MP_EXPLOSIVES_BLOWUP_BY" );
#precache( "string", "MP_EXPLOSIVES_DEFUSED_BY" );	
#precache( "string", "MP_EXPLOSIVES_PLANTED_BY" );	
#precache( "string", "MP_HQ_DESTROYED_BY" );
#precache( "string", "KILLSTREAK_DESTROYED_HELICOPTER" );

// some common functions between all the air kill streaks


function init()
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

/#
	level thread popupsFromConsole();
#/

	level thread onPlayerConnect();
}

/#
function popupsFromConsole()
{
	while (1)
	{	
		timeout = GetDvarFloat( "scr_popuptime", 1.0 );
		if ( timeout == 0 )
			timeout = 1;
		wait (timeout);	
		medal = GetDvarInt( "scr_popupmedal", 0 );
		challenge = GetDvarInt( "scr_popupchallenge", 0 );
		rank = GetDvarInt( "scr_popuprank", 0 );
		gun = GetDvarInt( "scr_popupgun", 0 );
		contractPass = GetDvarInt( "scr_popupcontractpass", 0 ); //sting 01	
		contractFail = GetDvarInt( "scr_popupcontractfail", 0 );	// Stinger_02
		gameModeMsg = GetDvarInt( "scr_gamemodeslideout", 0 );
		teamMsg = GetDvarInt( "scr_teamslideout", 0 );
		
		challengeIndex = GetDvarInt( "scr_challengeIndex", 1 );
		
		for ( i = 0 ; i < medal; i++ )
			level.players[0] medals::CodeCallback_Medal( 4 );
		for ( i = 0 ; i < challenge; i++ )
		{
			level.players[0] persistence::CodeCallback_ChallengeComplete( 2500, 1, 84, 3, 0, 0, 851 );
			level.players[0] persistence::CodeCallback_ChallengeComplete( 500, 1, 22, 2, 0, 0, 533 );
		}
		for ( i = 0 ; i < rank; i++ )
			level.players[0] rank::CodeCallback_RankUp( 4, 0, 0 );
		for ( i = 0 ; i < gun; i++ )
			level.players[0] persistence::CodeCallback_GunChallengeComplete( 0, 20, 25, 0 );
		for ( i = 0 ; i < contractPass; i++ )
			level.players[0] persistence::add_contract_to_queue( 12, 1 );
		for ( i = 0 ; i < contractFail; i++ )
			level.players[0] persistence::add_contract_to_queue( 12, 0 );
		for ( i = 0 ; i < teamMsg; i++ )
		{
			player = level.players[0];
			if ( isdefined ( level.players[1] ) )
				player = level.players[1];
			level.players[0] DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_HELICOPTER", player );
		}
		
		reset = GetDvarInt( "scr_popupreset", 1 );
		if ( reset )
		{
			if ( medal ) 
				SetDvar( "scr_popupmedal", 0 );
			if ( challenge ) 
				SetDvar( "scr_popupchallenge", 0 );
			if ( gun ) 
				SetDvar( "scr_popupgun", 0 );
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
#/

function DisplayKillstreakTeamMessageToAll( killstreak, player )
{
	if ( !isdefined ( level.killstreaks[killstreak] ) )
		return;
	if ( !isdefined ( level.killstreaks[killstreak].inboundText ) )
		return;
		
	message = level.killstreaks[killstreak].inboundText;
	self DisplayTeamMessageToAll( message, player );
}

function shouldDisplayTeamMessages()
{
	// level.splitscreen is the local splitscreen mode only
	if ( level.hardcoreMode == true || level.splitscreen == true ) 
		return false;	
		
	return true;
}

function DisplayTeamMessageToAll( message, player )
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

function DisplayTeamMessageToTeam( message, player, team )
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

function displayTeamMessageWaiter()
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
			ArrayRemoveIndex( self.teamMessageQueue, 0, false );

			if ( !isdefined( nextNotifyData.player ) || !isplayer( nextNotifyData.player ) )
				continue;

			if ( self IsEMPJammed() )
				continue;
			
			self LUINotifyEvent( &"player_callout", 2, nextNotifyData.message, nextNotifyData.player.entnum );
		}
		wait ( level.teamMessage.waittime );
	}
}


function displayPopUpsWaiter()
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
				
	while( !level.gameEnded )
	{
		if ( self.startMessageNotifyQueue.size == 0 && self.messageNotifyQueue.size == 0 )
			self waittill( "received award" );
		
		waittillframeend;

		if ( level.gameEnded  )
			break;
		
		if ( self.startMessageNotifyQueue.size > 0 )
		{
			nextNotifyData = self.startMessageNotifyQueue[0];
			ArrayRemoveIndex( self.startMessageNotifyQueue, 0, false );
			
			if ( isdefined( nextNotifyData.duration ) )
				duration = nextNotifyData.duration;
			else
				duration = level.startMessageDefaultDuration;
				
			self hud_message::showNotifyMessage( nextNotifyData, duration );
			wait ( duration );
		}
		else if ( self.messageNotifyQueue.size > 0 )
		{
			nextNotifyData = self.messageNotifyQueue[0];
			ArrayRemoveIndex( self.messageNotifyQueue, 0, false );
			
			if ( isdefined( nextNotifyData.duration ) )
				duration = nextNotifyData.duration;
			else
				duration = level.regularGameMessages.waittime;
			
			self hud_message::showNotifyMessage( nextNotifyData, duration );
		}
		else
		{	
			//assertmsg( "displayPopUpsWaiter not handling case" );
			wait( 1 );
		}
	}
}

//displayEndGamePopUps()
//{
//	self.postGamePromotion = false;
//	self.postGameMilestones = 0;
//	self.postGameContracts = 0;
//	promoted = 0;
//	contract0 = -1;
//	contract1 = -1;
//	contract2 = -1;
//	sendMessage = false;
//	
//	// This is to display end of game notifications, this will show in the endgame menu after the final kill cam
//	if ( self.rankNotifyQueue.size > 0 )
//	{
//		self.postGamePromotion = true;
//		promoted =  1; // endgame promotion
//		sendMessage = true;
//	}
//
//	if ( self.pers["contractNotifyQueue"].size > 0 )
//	{	
//		for( i = 0; i < self.pers["contractNotifyQueue"].size; i++ )
//		{
//			if ( self.pers["contractNotifyQueue"][0]["passed"] == false )
//			{
//				for ( i = 1; i < self.pers["contractNotifyQueue"].size; i++ )
//					self.pers["contractNotifyQueue"][i-1] = self.pers["contractNotifyQueue"][i];
//				
//				self.pers["contractNotifyQueue"][i-1] = undefined;
//			}
//		}
//
//		self.postGameContracts = self.pers["contractNotifyQueue"].size;
//		if ( isdefined( self.pers["contractNotifyQueue"].size > 0 ) )
//		{
//			if ( isdefined (self.pers["contractNotifyQueue"][0] ) )
//			{
//				contract0 = self.pers["contractNotifyQueue"][0]["index"]; 
//				sendMessage = true;
//			}
//		}
//		if ( isdefined( self.pers["contractNotifyQueue"].size > 1 ) )
//		{
//			if ( isdefined (self.pers["contractNotifyQueue"][1] ) )
//			{
//				contract1 = self.pers["contractNotifyQueue"][1]["index"]; 
//				sendMessage = true;
//			}
//		}
//		if ( isdefined( self.pers["contractNotifyQueue"].size > 2 ) )
//		{
//			if ( isdefined (self.pers["contractNotifyQueue"][2] ) )
//			{
//				contract2 = self.pers["contractNotifyQueue"][2]["index"]; 
//				sendMessage = true;
//			}
//		}
//	}
//	
//	for ( challengeNotifyCount = 0; challengeNotifyCount < self.pers["challengeNotifyQueue"].size && challengeNotifyCount < 3; challengeNotifyCount++ )
//	{
//		self.postGameMilestones++;
//		tier = self.pers["challengeNotifyQueue"][challengeNotifyCount]["tier"];
//		index = self.pers["challengeNotifyQueue"][challengeNotifyCount]["index"];
//		itemIndex = self.pers["challengeNotifyQueue"][challengeNotifyCount]["itemIndex"];
//		type = self.pers["challengeNotifyQueue"][challengeNotifyCount]["type"];
//		self DisplayEndGameMilestone( challengeNotifyCount, tier, index, itemIndex, type );
//	}
//}

function onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player.resetGameOverHudRequired = false;
		player thread displayPopupsWaiter();
		if ( !level.hardcoreMode ) 
		{
			player thread displayTeamMessageWaiter();
		}
	}
}

function milestoneNotify( index, itemIndex, type, tier )
{
	level.globalChallenges++;
	
	if ( !isdefined( type ) )
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

