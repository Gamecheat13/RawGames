#using scripts\shared\callbacks_shared;
#using scripts\shared\music_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_utils;

#using scripts\codescripts\struct;

#using scripts\mp\_util;
	
#namespace globallogic_audio;
	
function autoexec __init__sytem__() {     system::register("globallogic_audio",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );	
	
	level.playLeaderDialogOnPlayer = &leader_dialog_on_player;
	level.playEquipmentDestroyedOnPlayer = &play_equipment_destroyed_on_player;
	level.playEquipmentHackedOnPlayer = &play_equipment_hacked_on_player;
}	

function init()
{		
		game["music"]["defeat"] = "mus_defeat";
		game["music"]["victory_spectator"] = "mus_defeat";
		game["music"]["winning"] = "mus_time_running_out_winning";
		game["music"]["losing"] = "mus_time_running_out_losing";
		game["music"]["match_end"] = "mus_match_end";
		game["music"]["victory_tie"] = "mus_defeat";
		game["music"]["spawn_short"] = "SPAWN_SHORT";	
		
		game["music"]["suspense"] = [];
		game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_01";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_02";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_03";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_04";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_05";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_06";
		
		level thread post_match_snapshot_watcher();
		
		level.multipleDialogKeys = [];
		
		// Play 'multiple incoming' lines for these
		level.multipleDialogKeys["enemyAiTank"] = "enemyAiTankMultiple";
		level.multipleDialogKeys["enemySupplyDrop"] = "enemySupplyDropMultiple";
		level.multipleDialogKeys["enemyCombatRobot"] = "enemyCombatRobotMultiple";
		level.multipleDialogKeys["enemyCounterUav"] = "enemyCounterUavMultiple";
		level.multipleDialogKeys["enemyDart"] = "enemyDartMultiple";
		level.multipleDialogKeys["enemyEmp"] = "enemyEmpMultiple";
		level.multipleDialogKeys["enemySentinel"] = "enemySentinelMultiple";
		level.multipleDialogKeys["enemyMicrowaveTurret"] = "enemyMicrowaveTurretMultiple";
		level.multipleDialogKeys["enemyRcBomb"] = "enemyRcBombMultiple";
		level.multipleDialogKeys["enemyPlaneMortar"] = "enemyPlaneMortarMultiple";
		level.multipleDialogKeys["enemyHelicopterGunner"] = "enemyHelicopterGunnerMultiple";
		level.multipleDialogKeys["enemyRaps"] = "enemyRapsMultiple";
		level.multipleDialogKeys["enemyDroneStrike"] = "enemyDroneStrikeMultiple";
		level.multipleDialogKeys["enemyTurret"] = "enemyTurretMultiple";
		level.multipleDialogKeys["enemyHelicopter"] = "enemyHelicopterMultiple";
		level.multipleDialogKeys["enemyUav"] = "enemyUavMultiple";
		level.multipleDialogKeys["enemySatellite"] = "enemySatelliteMultiple";
		
		// Skip these
		level.multipleDialogKeys["friendlyAiTank"] = "";
		level.multipleDialogKeys["friendlySupplyDrop"] = "";
		level.multipleDialogKeys["friendlyCombatRobot"] = "";
		level.multipleDialogKeys["friendlyCounterUav"] = "";
		level.multipleDialogKeys["friendlyDart"] = "";
		level.multipleDialogKeys["friendlyEmp"] = "";
		level.multipleDialogKeys["friendlySentinel"] = "";
		level.multipleDialogKeys["friendlyMicrowaveTurret"] = "";
		level.multipleDialogKeys["friendlyRcBomb"] = "";
		level.multipleDialogKeys["friendlyPlaneMortar"] = "";
		level.multipleDialogKeys["friendlyHelicopterGunner"] = "";
		level.multipleDialogKeys["friendlyRaps"] = "";
		level.multipleDialogKeys["friendlyDroneStrike"] = "";
		level.multipleDialogKeys["friendlyTurret"] = "";
		level.multipleDialogKeys["friendlyHelicopter"] = "";
		level.multipleDialogKeys["friendlyUav"] = "";
		level.multipleDialogKeys["friendlySatellite"] = "";
}

function set_leader_gametype_dialog( startGameDialogKey, startHcGameDialogKey, offenseOrderDialogKey, defenseOrderDialogKey )
{
	level.leaderDialog = SpawnStruct();
	
	level.leaderDialog.startGameDialog = startGameDialogKey;
	level.leaderDialog.startHcGameDialog = startHcGameDialogKey;
	
	level.leaderDialog.offenseOrderDialog = offenseOrderDialogKey;
	level.leaderDialog.defenseOrderDialog = defenseOrderDialogKey;
}

function announce_round_winner( winner, delay )
{
	if ( delay > 0 )
	{
		wait delay;
	}

	if ( !isdefined( winner ) || isPlayer( winner ) )
	{
		return;
	}

	if ( isdefined( level.teams[ winner ] ) )
	{
		//thread sound::play_on_players( "mus_round_win"+"_"+level.teamPostfix[winner] );
		//thread sound::play_on_players( "mus_round_loss"+"_"+level.teamPostfix[team] );
		leader_dialog( "roundEncourageWon", winner );
		leader_dialog_for_other_teams( "roundEncourageLost", winner );
	}
	else
	{
		foreach ( team in level.teams )
		{
			thread sound::play_on_players( "mus_round_draw"+"_"+level.teamPostfix[team] );
		}
		leader_dialog( "roundDraw" );
	}
}


function announce_game_winner( winner )
{
	if ( !isdefined( winner ) || isPlayer( winner ) )
	{
		return;
	}

	wait ( battlechatter::mpdialog_value( "announceWinnerDelay", 0 ) );
	
	if ( isdefined( level.teams[ winner ] ) )
	{
		leader_dialog( "gameWon", winner );
		leader_dialog_for_other_teams( "gameLost", winner );
	}
	else
	{
		leader_dialog( "gameDraw" );
	}
	
	wait( battlechatter::mpdialog_value( "commanderDialogBuffer", 0 ) );
	
	battlechatter::game_end_vox( winner );
}

function flush_dialog()
{
	foreach( player in level.players )
	{
		player flush_dialog_on_player();
	}
}

function flush_dialog_on_player()
{
	self.leaderDialogQueue = [];
	self.currentLeaderDialog = undefined;
	
	self.killstreakDialogQueue = [];
	self.scorestreakDialogPlaying = false;
	
	self notify( "flush_dialog" );
}

function flush_killstreak_dialog_on_player( killstreakId )
{
	if ( !isdefined( killstreakId ) )
	{
		return;
	}
	
	for( i = self.killstreakDialogQueue.size - 1; i >=0; i-- )
	{
		if ( killstreakId === self.killstreakDialogQueue[i].killstreakId )
		{
			ArrayRemoveIndex( self.killstreakDialogQueue, i );
		}
	}
}

function killstreak_dialog_queued( dialogKey, killstreakType, killstreakId )
{
	if ( !isdefined( dialogKey ) ||
	     !isdefined( killstreakType ) )
    {
    	return;
    }
	if ( isdefined( self.currentKillstreakDialog ) )
	{
		if ( dialogKey === self.currentKillstreakDialog.dialogKey &&
		     killstreakType === self.currentKillstreakDialog.killstreakType &&
		     killstreakId === self.currentKillstreakDialog.killstreakId )
		{
			return true;
		}		
	}
	
	for( i = 0; i < self.killstreakDialogQueue.size; i++ )
	{
		if ( dialogKey === self.killstreakDialogQueue[i].dialogKey &&
		     killstreakType === self.killstreakDialogQueue[i].killstreakType &&
		     killstreakType === self.killstreakDialogQueue[i].killstreakType )
		{
			return true;
		}		
	}
	
	return false;
}

function flush_objective_dialog( objectiveKey )
{
	foreach( player in level.players )
	{
		player flush_objective_dialog_on_player( objectiveKey );
	}
}

function flush_objective_dialog_on_player( objectiveKey )
{
	if ( !isdefined( objectiveKey ) )
	{
		return;
	}
	
	for( i = self.leaderDialogQueue.size - 1; i >=0; i-- )
	{
		if ( objectiveKey === self.leaderDialogQueue[i].objectiveKey )
		{
			ArrayRemoveIndex( self.leaderDialogQueue, i );
			break;	// There should never be more than one objective key of a given type
		}
	}
}

function flush_leader_dialog_key( dialogKey )
{
	foreach ( player in level.players )
	{
		player flush_leader_dialog_key_on_player( dialogKey );
	}
}

function flush_leader_dialog_key_on_player( dialogKey )
{
	if ( !isdefined( dialogKey ) )
	{
		return;
	}
	
	for( i = self.leaderDialogQueue.size - 1; i >=0; i-- )
	{
		if ( dialogKey === self.leaderDialogQueue[i].dialogKey )
		{
			ArrayRemoveIndex( self.leaderDialogQueue, i );
		}
	}
}

function play_taacom_dialog( dialogKey, killstreakType, killstreakId )
{
	self killstreak_dialog_on_player( dialogKey, killstreakType, killstreakId );
}

function killstreak_dialog_on_player( dialogKey, killstreakType, killstreakId,  pilotIndex )
{
	if ( !isdefined( dialogKey ) )
	{
		return;
	}
	
	if ( !level.allowbattlechatter["bc"] )
	{
		return;
	}
		
	newDialog = SpawnStruct();
	
	newDialog.dialogKey = dialogKey;
	newDialog.killstreakType = killstreakType;
	newDialog.pilotIndex = pilotIndex;
	newDialog.killstreakId = killstreakId;
	
	self.killstreakDialogQueue[self.killstreakDialogQueue.size] = newDialog;
	
	if ( isdefined( self.currentKillstreakDialog ) )
	{
		return;
	}
	
	// HACK: Don't start up the killstreak queue with taacom dialog while the player is speaking
	// Keeps the request and arrival lines from getting jumbled up in quiet moments
	if ( self.playingDialog === true && dialogKey == "arrive" )
	{
		self thread wait_for_player_dialog();
	}
	else
	{
		self thread play_next_killstreak_dialog();
	}
}

function wait_for_player_dialog()
{
	self endon( "disconnect" );
	self endon( "flush_dialog" );
	level endon( "game_ended" );
	
	while ( self.playingDialog )
	{
		wait( 0.5 );
	}
	
	self thread play_next_killstreak_dialog();
}

function play_next_killstreak_dialog()
{
	self endon( "disconnect" );
	self endon( "flush_dialog" );
	level endon( "game_ended" );
	
	if ( self.killstreakDialogQueue.size == 0 )
	{
		self.currentKillstreakDialog = undefined;
		return;
	}
	
	nextDialog = self.killstreakDialogQueue[0];
	
	ArrayRemoveIndex( self.killstreakDialogQueue, 0 );

	if ( isdefined( self.pers["mptaacom"] ) )
	{
		taacomBundle = struct::get_script_bundle( "mpdialog_taacom", self.pers["mptaacom"] );
	}
	
	if ( isdefined( taacomBundle ) )
	{
		if ( isdefined( nextDialog.killstreakType ) )
		{
			if ( isdefined( nextDialog.pilotIndex ) )
			{
				pilotArray = taacomBundle.pilotBundles[nextDialog.killstreakType];
				
				if ( isdefined( pilotArray ) && nextDialog.pilotIndex < pilotArray.size )
				{
					killstreakBundle = struct::get_script_bundle( "mpdialog_scorestreak", pilotArray[nextDialog.pilotIndex] );
					
					if ( isdefined( killstreakBundle ) )
					{
						dialogAlias = globallogic_audio::get_dialog_bundle_alias( killstreakBundle, nextDialog.dialogKey );
					}	
				}
			}
			else if ( isdefined( level.killstreaks[nextDialog.killstreakType] ) )
			{
				bundleName = GetStructField( taacomBundle, level.killstreaks[nextDialog.killstreakType].taacomDialogBundleKey );
				
				if ( isdefined( bundleName ) )
				{
					killstreakBundle = struct::get_script_bundle( "mpdialog_scorestreak", bundleName );
				
					if ( isdefined( killstreakBundle ) )
					{
						dialogAlias = self globallogic_audio::get_dialog_bundle_alias( killstreakBundle, nextDialog.dialogKey );
					}
				}
			}
		}
		else
		{
			dialogAlias = self globallogic_audio::get_dialog_bundle_alias( taacomBundle, nextDialog.dialogKey );
		}
	}
	
	if ( !isdefined( dialogAlias ) )
	{
		self play_next_killstreak_dialog();
		return;
	}
	
	self playLocalSound( dialogAlias );
	
	self.currentKillstreakDialog = nextDialog;
	
	self thread wait_next_killstreak_dialog();
}

function wait_next_killstreak_dialog()
{	
	self endon( "disconnect" );
	self endon( "flush_dialog" );
	level endon( "game_ended" );
	
	wait ( battlechatter::mpdialog_value( "killstreakDialogBuffer", 0 ) );
	
	self thread play_next_killstreak_dialog();
}


function leader_dialog_for_other_teams( dialogKey, skipTeam, objectiveKey, killstreakId, dialogBufferKey )
{
	assert( isdefined( skipTeam ) );
	
	foreach( team in level.teams )
	{
		if ( team != skipTeam )
		{
			leader_dialog( dialogKey, team, undefined, objectiveKey, killstreakId, dialogBufferKey );
		}
	}
}

function leader_dialog( dialogKey, team, excludeList, objectiveKey, killstreakId, dialogBufferKey )
{
	assert( isdefined( level.players ) );
	
	foreach ( player in level.players )
	{
		if ( !isdefined( player.pers["team"] ) )
		{
			continue;
		}
		
		if ( isdefined( team ) && team != player.pers["team"] )
		{
			continue;
		}
		
		if ( isdefined( excludeList ) && globallogic_utils::isExcluded( player, excludeList ) )
		{
			continue;
		}
		
		player leader_dialog_on_player( dialogKey, objectiveKey, killstreakId, dialogBufferKey );
	}
}

function leader_dialog_on_player( dialogKey, objectiveKey, killstreakId, dialogBufferKey )
{
	if ( !isdefined( dialogKey ) )
	{
		return;
	}
	
	if ( self.sessionstate == "spectating" )
	{
		return;
	}
	
	self flush_objective_dialog_on_player( objectiveKey );

	// Don't queue up the same objective dialog that is currently playing
	if ( self.leaderDialogQueue.size == 0 &&
		 isdefined( self.currentLeaderDialog ) &&
		 isdefined( objectiveKey ) &&
		 self.currentLeaderDialog.objectiveKey === objectiveKey &&
		 self.currentLeaderDialog.dialogKey == dialogKey )
	{
		return;
	}
	
	// Multiple enemy scorestreak conversion
	if ( isdefined( killstreakId ) )
	{
		// Look for an already queued item
		foreach( item in self.leaderDialogQueue )
		{
			if ( item.dialogKey == dialogKey )
			{
				item.killstreakIds[item.killstreakIds.size] = killstreakId;
				return;
			}
		}
		
		// Flag the new item to play multiple if it's playing up against the current dialog
		if ( self.leaderDialogQueue.size == 0 &&
		     isdefined( self.currentLeaderDialog ) &&
		     self.currentLeaderDialog.dialogKey == dialogKey )
		{
			// We're already playing a multiple so just skip this new one
			if ( self.currentLeaderDialog.playMultiple === true )
			{
				return;
			}
			
			playMultiple = true;
		}
	}
	
	newItem = SpawnStruct();
	
	newItem.dialogKey = dialogKey;
	newItem.multipleDialogKey = level.multipleDialogKeys[dialogKey];
	newItem.playMultiple = playMultiple;
	newItem.objectiveKey = objectiveKey;

	if( isdefined( killstreakId ) )
	{
		newItem.killstreakIds = [];
		newItem.killstreakIds[0] = killstreakId;
	}
	
	newItem.dialogBufferKey = dialogBufferKey;
	// TODO: Add Expiration time
	
	self.leaderDialogQueue[self.leaderDialogQueue.size] = newItem;
	
	if ( isdefined( self.currentLeaderDialog ) )
	{
		return;
	}
	
	self thread play_next_leader_dialog();
}

function play_next_leader_dialog()
{
	self endon( "disconnect" );
	self endon( "flush_dialog" );
	level endon( "game_ended" );
	
	if ( self.leaderDialogQueue.size == 0 )
	{
		self.currentLeaderDialog = undefined;
		return;
	}
	
	nextDialog = self.leaderDialogQueue[0];
	
	ArrayRemoveIndex( self.leaderDialogQueue, 0 );
	
	dialogKey = nextDialog.dialogKey;
	
	if ( isdefined( nextDialog.killstreakIds ) )
	{
		triggeredCount = 0;
		
		foreach( killstreakId in nextDialog.killstreakIds )
		{
			if( isdefined ( level.killstreaks_triggered[ killstreakId ] ) )
			{
				triggeredCount++;
			}
		}
	
		// No active scorestreaks for this item, don't play it		
		if ( triggeredCount == 0 )
		{
			self thread play_next_leader_dialog();
			return;
		}
		else if ( triggeredCount > 1 || nextDialog.playMultiple === true )
		{
			// Found more than one, or we want to play the multiple for some reason
			if( isdefined( level.multipleDialogKeys[ dialogKey ] ) )
			{
				dialogKey = level.multipleDialogKeys[ dialogKey ];
			}
		}
	}
	
	dialogAlias = self get_commander_dialog_alias( dialogKey );
	
	if ( !isdefined( dialogAlias ) )
	{
		self thread play_next_leader_dialog();
		return;
	}
	
	self playLocalSound( dialogAlias );
		
	nextDialog.playTime = GetTime();
	self.currentLeaderDialog = nextDialog;
	
	// Get the provided buffer, default buffer, or 0
	dialogBuffer = battlechatter::mpdialog_value( nextDialog.dialogBufferKey, battlechatter::mpdialog_value( "commanderDialogBuffer", 0 ) );
	
	self thread wait_next_leader_dialog( dialogBuffer );
}

function wait_next_leader_dialog( dialogBuffer )
{	
	self endon( "disconnect" );
	self endon( "flush_dialog" );
	level endon( "game_ended" );
	
	wait ( dialogBuffer );
	
	self thread play_next_leader_dialog();
}

// Commander callbacks

function play_equipment_destroyed_on_player( )
{
	self play_taacom_dialog( "equipmentDestroyed" );
}

function play_equipment_hacked_on_player( )
{
	self play_taacom_dialog( "equipmentHacked" );
}

// Alias Lookups

function get_commander_dialog_alias( dialogKey )
{
	if ( !isdefined( self.pers["mpcommander"] ) )
	{
		return undefined;
	}
	
	commanderBundle = struct::get_script_bundle( "mpdialog_commander", self.pers["mpcommander"] );
	
	return get_dialog_bundle_alias( commanderBundle, dialogKey );
}

function get_dialog_bundle_alias( dialogBundle, dialogKey )
{
	if ( !isdefined( dialogBundle ) || !isdefined( dialogKey ) )
	{
		return undefined;
	}
	
	dialogAlias = GetStructField( dialogBundle, dialogKey );
	
	if ( !isdefined( dialogAlias ) )
	{
		return;
	}
	
	voicePrefix = GetStructField( dialogBundle, "voiceprefix" );
		
	if ( isdefined( voicePrefix ) )
	{
		dialogAlias = voicePrefix + dialogAlias;	
	}
	
	return dialogAlias;
}

function is_team_winning( checkTeam )
{
	score = game["teamScores"][checkTeam];
	
	foreach ( team in level.teams )
	{
		if ( team != checkTeam )
		{
			if ( game["teamScores"][team] >= score )
			{
				return false;
			}
		}
	}
	
	return true;
}

function announce_team_is_winning()
{
	foreach ( team in level.teams )
	{
		if ( is_team_winning( team ) )
		{
			leader_dialog( "gameWinning", team );
			leader_dialog_for_other_teams( "gameLosing", team );
			return true;
		}
	}
	
	return false;
}


function play_2d_on_team( alias, team )
{
	assert( isdefined( level.players ) );
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isdefined( player.pers["team"] ) && (player.pers["team"] == team ) )
		{
			player playLocalSound( alias );
		}	
	}
}

function get_round_switch_dialog( switchType )
{
	switch( switchType )
	{
		case "halftime":
			return "roundHalftime";
		case "overtime":
			return "roundOvertime";
		default:
			return "roundSwitchSides";
	}
}
//Eckert - does a 2 stage sound fade out during and after AAR
function post_match_snapshot_watcher()
{
	level waittill ( "game_ended" );	
	level util::clientNotify( "pm" );
	level waittill ( "sfade" );
	level util::clientNotify( "pmf" );
}

function announcerController()
{
	level endon ( "game_ended" );
	
	level waittill ( "match_ending_soon" );

	if ( util::isLastRound() || util::isOneRound() )
	{	
		if( level.teamBased )
		{
			if( !announce_team_is_winning() )
			{
				leader_dialog( "min_draw" );
			}
		}
			
		level waittill ( "match_ending_very_soon" );
			
		foreach ( team in level.teams )
		{
			leader_dialog( "roundTimeWarning", team, undefined, undefined );
		}
	}
	else
	{
		level waittill ( "match_ending_vox" );

		leader_dialog( "roundTimeWarning" );
	}
}

/*------------------------------------------------------------------------------------------------------
 *------------------------------------------------------------------------------------------------------
 *----------------------------------------MUSIC SYSTEM SCRIPTS------------------------------------------
 *------------------------------------------------------------------------------------------------------
 *------------------------------------------------------------------------------------------------------
 */

/*
 * spawnPreLoop
 * spawnPreRise
 * spawnFull
 * spawnShort
 * RandomOneshot
 * timeOut
 * roundEnd
 * roundSwitch
 * matchWin
 * matchLose
 * matchDraw
 * silent* 
 * endgame
 */

function sndMusicFunctions()
{
	level thread sndMusicTimesOut();
	level thread sndMusicHalfway();
	level thread sndMusicTimeLimitWatcher();
}
function sndMusicSetRandomizer()
{
	if( game[ "roundsplayed" ] == 0 )
	{
		game[ "musicSet" ] = randomintrange(1,5);
		if( game[ "musicSet" ] <= 9 )
		{
			game[ "musicSet" ] = "0"+game[ "musicSet" ];
		}
		game[ "musicSet" ] = "_"+game[ "musicSet" ];
	}
}

function sndMusicTimesOut()
{
    level endon( "game_ended" );
    level endon( "musicEndingOverride" );
    
    level waittill ( "match_ending_very_soon" );
    
    if( isdefined( level.gametype ) && level.gametype == "sd" )
    	level thread set_music_on_team( "timeOutQuiet" );
    else
    	level thread set_music_on_team( "timeOut" );
}
function sndMusicHalfway()
{
	level endon( "game_ended" );
	level endon( "match_ending_soon" );
	level endon( "match_ending_very_soon" );
	
	level waittill( "sndMusicHalfway" );
	
	level thread set_music_on_team( "underscore" );
}
function sndMusicTimeLimitWatcher()
{
	level endon( "game_ended" );
	level endon( "match_ending_soon" );
	level endon( "match_ending_very_soon" );
	level endon( "sndMusicHalfway" );
	
	if( !isdefined( level.timeLimit ) || level.timeLimit == 0 )
		return;
	
	halfway = (level.timeLimit*60)*.5;
	
	while(1)
	{
		timeLeft = globallogic_utils::getTimeRemaining() / 1000;
		if( timeLeft <= halfway )
		{
			level notify( "sndMusicHalfway" );
			return;
		}
		wait(2);
	}
}

function set_music_on_team( state, team = "both", wait_time = 0, save_state = false, return_state = false )
{
	// Assert if there are no players
	assert( isdefined( level.players ) );
		
	foreach( player in level.players )
	{
		if ( team == "both" )
		{
			player thread set_music_on_player( state, wait_time, save_state, return_state );			
		}	
		else if ( isdefined( player.pers["team"] ) && (player.pers["team"] == team ) )
		{
			player thread set_music_on_player( state, wait_time, save_state, return_state );
		}
	}
}
function set_music_on_player( state, wait_time = 0,  save_state = false, return_state = false )
{
	self endon( "disconnect" );
	
	assert( isplayer (self) );
	
	if ( !isdefined( state ) )	
	{
		return;
	}
	
	if( !isdefined( game[ "musicSet" ] ) )
	{
		return;
	}
	
	music::setmusicstate( state+game[ "musicSet" ], self );	
}
function set_music_global( state, wait_time = 0,  save_state = false, return_state = false )
{
	if ( !isdefined( state ) )	
	{
		return;
	}
	
	if( !isdefined( game[ "musicSet" ] ) )
	{
		return;
	}
	
	music::setmusicstate( state+game[ "musicSet" ] );	
}