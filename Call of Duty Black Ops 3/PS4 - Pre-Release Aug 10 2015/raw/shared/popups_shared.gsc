#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

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

#namespace popups;

// some common functions between all the air kill streaks

function autoexec __init__sytem__() {     system::register("popups",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
}

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
	level thread devgui_notif_init();
#/

	callback::on_connecting( &on_player_connect );
}

function on_player_connect()
{
	self.resetGameOverHudRequired = false;
	self thread displayPopupsWaiter();
	if ( !level.hardcoreMode )
	{
		self thread displayTeamMessageWaiter();
	}
}

/#
//---------------------------------------------------------
// DEVGUI







function devgui_notif_getGunLevelTableName()
{
	if ( SessionModeIsCampaignGame() )
	{
		return "gamedata/weapons/cp/cp_gunlevels.csv";
	}
	else if ( SessionModeIsZombiesGame() )
	{
		return "gamedata/weapons/zm/zm_gunlevels.csv";
	}
	else
	{
		return "gamedata/weapons/mp/mp_gunlevels.csv";
	}
}

function devgui_notif_init()
{
	SetDvar( "scr_notif_devgui_rank", 0 );
	SetDvar( "scr_notif_devgui_gun_lvl_xp", 0 );
	SetDvar( "scr_notif_devgui_gun_lvl_attachment_index", 0 );
	SetDvar( "scr_notif_devgui_gun_lvl_item_index", 0 );
	SetDvar( "scr_notif_devgui_gun_lvl_rank_id", 0 );

	if( IsDedicated() )
	{
		return;
	}

	level thread notif_devgui_rank();
	level thread notif_devgui_gun_rank();
}

function notif_devgui_rank()
{
	if( !IsDefined( level.rankTable ) )
	{
		return;
	}

	notif_rank_devgui_base = "devgui_cmd \"UI/Notifications/Rank/Level ";
	for( i = 1; i < level.rankTable.size; i++ )
	{
		display_level = i + 1;
		if( display_level < 10 )
		{
			display_level = "0" + display_level;
		}

		AddDebugCommand( notif_rank_devgui_base + display_level + "\" " + "\"" + "scr_notif_devgui_rank" + " " + i + "\" \n" );
	}

	{wait(.05);}; // so we don't overflow the Cbuf_InsertText()

	level thread notif_devgui_rank_up_think();
}

function notif_devgui_rank_up_think()
{
	for( ;; )
	{
		rank_number = GetDvarInt( "scr_notif_devgui_rank" );

		if( rank_number == 0 )
		{
			{wait(.05);};
			continue;
		}

		level.players[0] rank::CodeCallback_RankUp( rank_number , 0, 1 );

		SetDvar( "scr_notif_devgui_rank", 0 );
		wait( 1 );
	}
}

function notif_devgui_gun_rank()
{
	notif_gun_rank_devgui_base = "devgui_cmd \"UI/Notifications/Gun Level/";
	GUNLEVEL_RANKID_COL = 0;
	GUNLEVEL_GUNREF_COL = 2;
	GUNLEVEL_ATTACHMENT_UNLOCK_COL = 3;
	GUNLEVEL_XPGAINED_COL = 4;

	level flag::wait_till( "all_players_spawned" );
	
	if( !IsDefined( level.tbl_weaponIDs ) )
	{
		return;
	}

	a_weapons = [];
	a_weapons["assault"] = [];
	a_weapons["smg"] = [];
	a_weapons["lmg"] = [];
	a_weapons["shotgun"] = [];
	a_weapons["sniper"] = [];
	a_weapons["pistol"] = [];
	a_weapons["launcher"] = [];
	a_weapons["knife"] = [];
	
	gun_levels_table = devgui_notif_getGunLevelTableName();

	foreach( weapon in level.tbl_weaponIDs )
	{
		gun = [];
		gun["ref"] = weapon["reference"];
		gun["itemIndex"] = GetItemIndexFromRef( weapon["reference"] );
		gun["attachments"] = [];

		gun_weapon_attachments = StrTok( weapon["attachment"], " " );
		foreach( index, attachment in gun_weapon_attachments )
		{
			gun["attachments"][attachment] = [];
			gun["attachments"][attachment]["itemIndex"] = GetAttachmentTableIndex( attachment );
			gun["attachments"][attachment]["rankID"] = TableLookup( gun_levels_table, GUNLEVEL_GUNREF_COL, gun["ref"], GUNLEVEL_ATTACHMENT_UNLOCK_COL, attachment, GUNLEVEL_RANKID_COL );
			gun["attachments"][attachment]["xp"] = TableLookup( gun_levels_table, GUNLEVEL_GUNREF_COL, gun["ref"], GUNLEVEL_ATTACHMENT_UNLOCK_COL, attachment, GUNLEVEL_XPGAINED_COL );
		}
		
		switch( weapon["group"] )
		{
			case "weapon_pistol":
				if( weapon["reference"] != "weapon_null" )
				{
					ArrayInsert( a_weapons["pistol"], gun, 0 );
				}
				break;
			case "weapon_launcher":
				ArrayInsert( a_weapons["launcher"], gun, 0 );
				break;
			case "weapon_assault":
				ArrayInsert( a_weapons["assault"], gun, 0 );
				break;
			case "weapon_smg":
				ArrayInsert( a_weapons["smg"], gun, 0 );
				break;
			case "weapon_lmg":
				ArrayInsert( a_weapons["lmg"], gun, 0 );
				break;
			case "weapon_cqb":
				ArrayInsert( a_weapons["shotgun"], gun, 0 );
				break;
			case "weapon_sniper":
				ArrayInsert( a_weapons["sniper"], gun, 0 );
				break;
			case "weapon_knife":
				ArrayInsert( a_weapons["knife"], gun, 0 );
				break;
			default:
				break;
		}
	}
	
	foreach( group_name, gun_group in a_weapons )
	{
		foreach( gun, attachment_group in gun_group )
		{
			foreach( attachment, attachment_data in attachment_group["attachments"] )
			{
				devgui_cmd_gun_path = notif_gun_rank_devgui_base + group_name + "/" + gun_group[gun]["ref"] + "/" + attachment;
				AddDebugCommand( devgui_cmd_gun_path + "\" " + "\"" +
									";set " + "scr_notif_devgui_gun_lvl_xp" + " " + attachment_data["xp"] +
									";set " + "scr_notif_devgui_gun_lvl_attachment_index" + " " + attachment_data["itemIndex"] +
									";set " + "scr_notif_devgui_gun_lvl_item_index" + " " + gun_group[gun]["itemIndex"] +
									";set " + "scr_notif_devgui_gun_lvl_rank_id" + " " + attachment_data["rankID"] + "\" \n" );

			}
		}
		{wait(.05);}; // so we don't overflow the Cbuf_InsertText()
	}

	level thread notif_devgui_gun_level_think();
}

function notif_devgui_gun_level_think()
{
	for( ;; )
	{
		weapon_item_index = GetDvarInt( "scr_notif_devgui_gun_lvl_item_index" );

		if( weapon_item_index == 0 )
		{
			{wait(.05);};
			continue;
		}

		xp_reward = GetDvarInt( "scr_notif_devgui_gun_lvl_xp" );
		attachment_index = GetDvarInt( "scr_notif_devgui_gun_lvl_attachment_index" );
		rank_id = GetDvarInt( "scr_notif_devgui_gun_lvl_rank_id" );
		
		level.players[0] persistence::CodeCallback_GunChallengeComplete( xp_reward, attachment_index, weapon_item_index, rank_id );

		SetDvar( "scr_notif_devgui_gun_lvl_xp", 0 );
		SetDvar( "scr_notif_devgui_gun_lvl_attachment_index", 0 );
		SetDvar( "scr_notif_devgui_gun_lvl_item_index", 0 );
		SetDvar( "scr_notif_devgui_gun_lvl_rank_id", 0 );

		wait( 1 );
	}
}

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
		{
			level.players[0] medals::CodeCallback_Medal( 86 );
		}
		for ( i = 0 ; i < challenge; i++ )
		{
			level.players[0] persistence::CodeCallback_ChallengeComplete( 2500, 1, 84, 3, 0, 0, 851 );
			level.players[0] persistence::CodeCallback_ChallengeComplete( 500, 1, 22, 2, 0, 0, 533 );
		}
		for ( i = 0 ; i < rank; i++ )
		{
			level.players[0] rank::CodeCallback_RankUp( 4, 0, 1 );
		}
		for ( i = 0 ; i < gun; i++ )
		{
			level.players[0] persistence::CodeCallback_GunChallengeComplete( 0, 20, 25, 0 );
		}
		for ( i = 0 ; i < contractPass; i++ )
		{
			level.players[0] persistence::add_contract_to_queue( 12, 1 );
		}
		for ( i = 0 ; i < contractFail; i++ )
		{
			level.players[0] persistence::add_contract_to_queue( 12, 0 );
		}
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

function DisplayKillstreakHackedTeamMessageToAll( killstreak, player )
{
	if ( !isdefined ( level.killstreaks[killstreak] ) )
		return;
	if ( !isdefined ( level.killstreaks[killstreak].hackedText ) )
		return;
	
	message = level.killstreaks[killstreak].hackedText;
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

