#using scripts\shared\callbacks_shared;
#using scripts\shared\music_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_utils;

#using scripts\mp\_util;



	
#namespace globallogic_audio;
	
function autoexec __init__sytem__() {     system::register("globallogic_audio",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );	
	
	level.playLeaderDialogOnPlayer = &leader_dialog_on_player;
	level.playLeaderEquipmentDestroyedOnPlayer = &play_leader_equipment_destroyed_on_player;
	level.playLeaderEquipmentHackedOnPlayer = &play_leader_equipment_hacked_on_player;
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
		
		if ( !isdefined( level.dialogGroup ) )
		{
			level.dialogGroup = [];
		}
		
		level thread post_match_snapshot_watcher();
}

function set_leader_gametype_dialog( startGameDialogIndex, startHcGameDialogIndex, offenseOrderDialogIndex, defenseOrderDialogIndex )
{
	level.leaderDialog = SpawnStruct();
	
	level.leaderDialog.startGameDialogIndex = startGameDialogIndex;
	level.leaderDialog.startHcGameDialogIndex = startHcGameDialogIndex;
	
	level.leaderDialog.offenseOrderDialogIndex = offenseOrderDialogIndex;
	level.leaderDialog.defenseOrderDialogIndex = defenseOrderDialogIndex;
}

function register_dialog_group( group, skipIfCurrentlyPlayingGroup )
{
	if ( !isdefined( level.dialogGroup ) )
	{
		level.dialogGroup = [];
	}
	else if ( isdefined(level.dialogGroup[group]) )
	{
		/#util::error( "registerDialogGroup:  Dialog group " + group + " already registered." );#/
		return;
	}
	
	level.dialogGroup[group] = SpawnStruct();
	level.dialogGroup[group].group = group;
	level.dialogGroup[group].skipIfCurrentlyPlayingGroup = skipIfCurrentlyPlayingGroup;
	level.dialogGroup[group].currentCount = 0;
}

function leader_dialog_for_other_teams( dialog, skip_team, squad_dialog )
{
	foreach( team in level.teams )
	{
		if ( team != skip_team )
		{
			leader_dialog( dialog, team, undefined, undefined, squad_dialog );
		}
	}
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
		leader_dialog( 41, winner );
		leader_dialog_for_other_teams( 40, winner );
	}
	else
	{
		foreach ( team in level.teams )
		{
			thread sound::play_on_players( "mus_round_draw"+"_"+level.teamPostfix[team] );
		}
		leader_dialog( 38 );
	}
}


function announce_game_winner( winner, delay )
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
		leader_dialog( 31, winner );
		leader_dialog_for_other_teams( 30, winner );
	}
	else
	{
		// TODO: Get draw audios
		leader_dialog( 38 );
	}
}

/*
function do_flame_audio()
{
	self endon("disconnect");
	waittillframeend;
	
	if (!isdefined ( self.lastFlameHurtAudio ) )
	{
		self.lastFlameHurtAudio = 0;
	}
		
	currentTime = gettime();
	
	if ( self.lastFlameHurtAudio + level.fire_audio_repeat_duration + RandomInt( level.fire_audio_random_max_duration ) < currentTime )
	{
		self playLocalSound("vox_pain_small");
		self.lastFlameHurtAudio = currentTime;
	} 
}
*/

function leader_dialog( dialog, team, group, excludeList, squadDialog )
{
	assert( isdefined( level.players ) );
		
	if ( level.wagerMatch )
	{
		return;
	}
		
	if ( !isdefined( team ) )
	{
		dialogs = [];
		foreach ( team in level.teams )
		{
			dialogs[team] = dialog;
		}
		leader_dialog_all_teams( dialogs, group, excludeList );
		return;
	}
	
	if ( isdefined( excludeList ) )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( (isdefined( player.pers["team"] ) && (player.pers["team"] == team )) && !globallogic_utils::isExcluded( player, excludeList ) )
			{
				player leader_dialog_on_player( dialog, group );
			}
		}
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isdefined( player.pers["team"] ) && (player.pers["team"] == team ) )
			{
				player leader_dialog_on_player( dialog, group );
			}
		}
	}
}

function leader_dialog_all_teams( dialogs, group, excludeList )
{
	assert( isdefined( level.players ) );
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
		
		if ( !isdefined( team ) )
		{
			continue;
		}
		
		if ( !isdefined( dialogs[team] ) )
		{
			continue;
		}
			
		if ( isdefined( excludeList ) && globallogic_utils::isExcluded( player, excludeList ) )
		{
			continue;
		}
		
		player leader_dialog_on_player( dialogs[team], group );
	}
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
	self.leaderDialogGroups = [];
	self.leaderDialogQueue = [];
	self.leaderDialogActive = false;
	self.currentLeaderDialogGroup = "";
	self notify( "flush_dialog" );
}


function flush_group_dialog( group )
{
	foreach( player in level.players )
	{
		 player flush_group_dialog_on_player( group );
	}
}

function flush_group_dialog_on_player( group )
{
	self.leaderDialogGroups[group] = undefined;
	ArrayRemoveValue( self.leaderDialogQueue, group );

	if ( self.leaderDialogQueue.size == 0 )
	{
		self flush_dialog_on_player();
	}
}

function add_group_dialog_to_player( dialog, group )
{
	if ( !isdefined( level.dialogGroup[group]) )
	{
		/#util::error( "leader_dialog_on_player:  Dialog group " + group + " is not registered" );#/
		return false;
	}
	
	addToQueue = false;
	
	if ( !isdefined( self.leaderDialogGroups[group] ) )
	{
		addToQueue = true;
	}

	if ( !level.dialogGroup[group].skipIfCurrentlyPlayingGroup )
	{
		// we will skip if we are actually playing this VO already, unless almost at the end
		if ( self.currentLeaderDialog === dialog && 	self.currentLeaderDialogTime + 2000 > GetTime() )
		{
			// if we are currentlyPlaying this dialog then we dont want any of the groups dialogs to play
			self.leaderDialogGroups[group] = undefined;
			ArrayRemoveValue( self.leaderDialogQueue, group );
	
			if ( self.leaderDialogQueue.size == 0 )
			{
				self flush_dialog_on_player();
			}
			return false;
		}
		
	}
	else
	{
		// ignore the message if one from the same group is already playing
		if ( self.currentLeaderDialogGroup == group )
		{
			return false;
		}
	}
	
	self.leaderDialogGroups[group] = dialog;
	
	return addToQueue;
}

function scorestreak_dialog_on_player( soundIndex, scorestreakIndex, waitForPlayer )
{
	if ( isdefined( level.gameEnded ) && level.gameEnded )
	{
		return;
	}
	
	if ( isdefined( scorestreakIndex ) )
	{
		soundId = GetMpDialogTaacom( self.pers["mptaacom"], soundIndex, scorestreakIndex );
	}
	else
	{
		soundId = GetMpDialogTaacom( self.pers["mptaacom"], soundIndex );
	}
	
	if ( !isdefined( soundId ) )
	{
		return;
	}
	
	self.scorestreakDialogQueue[self.scorestreakDialogQueue.size] = soundId;
	
	if ( self.scorestreakDialogPlaying )
	{
		return;
	}
	
	self.scorestreakDialogPlaying = true;
	
	if ( self.playingDialog === true && waitForPlayer === true )
	{
		self thread wait_for_player_dialog();
	}
	else
	{
		self thread play_next_scorestreak_dialog();
	}
}

function wait_for_player_dialog()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while ( self.playingDialog )
	{
		wait( 0.5 );
	}
	
	self thread play_next_scorestreak_dialog();
}

function play_next_scorestreak_dialog()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	if ( self.scorestreakDialogQueue.size == 0 )
	{
		self.scorestreakDialogPlaying = false;
		return;
	}
	
	waittillframeend;
	
	soundId = self.scorestreakDialogQueue[0];
	
	ArrayRemoveIndex( self.scorestreakDialogQueue, 0 );
	
	self playLocalSound( soundId );
	alias = SoundGetAlias(soundId);
	
	self thread wait_next_scorestreak_dialog();
}

function wait_next_scorestreak_dialog()
{	
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	wait ( 3 );
	
	self thread play_next_scorestreak_dialog();
}

function play_leader_equipment_destroyed_on_player( )
{
	self leader_dialog_on_player( 127, "item_destroyed" );
}

function play_leader_equipment_hacked_on_player( )
{
	self leader_dialog_on_player( 128, "item_destroyed" );
}

function leader_dialog_on_player( dialog, group )
{
	// TODO: Re-enable this
	//assert( isdefined( dialog ) );

	team = self.pers["team"];

	if ( !isdefined( team ) )
	{
		return;
	}
	
	if ( !isdefined( level.teams[team] ) )
	{
		return;
	}
	
	if ( isdefined( group ) )
	{
		// exit because the "group" dialog call is already in the queue
		if ( !add_group_dialog_to_player( dialog, group ) )
		{
			return;
		}
			
		dialog = group;		
	}

	if ( self.leaderDialogQueue.size < 10 ) 
	{
		self.leaderDialogQueue[self.leaderDialogQueue.size] = dialog;
	}
	if ( !self.leaderDialogActive )
	{
		self thread play_next_leader_dialog();
	}
}

function waitForSound( sound, extraTime )
{
	if (!isdefined(extraTime) )
	{
		// allow the announcer to take a breath
		extraTime = 0.1;
	}
	
	time = soundgetplaybacktime( sound );	
	
	if ( time < 0 )
	{
		wait( 3.0 + extraTime );
	}
	else
	{
		wait( time * 0.001 + extraTime );
	}
}

function play_next_leader_dialog()
{
	self endon( "disconnect" );
	self endon( "flush_dialog" );
	
	if( isdefined(level.allowAnnouncer) && !level.allowAnnouncer )
	{
		return;
	}
	
	self.leaderDialogActive = true;
	
	waittillframeend;
	
	assert( self.leaderDialogQueue.size > 0 );
	dialog = self.leaderDialogQueue[0];
	assert( isdefined( dialog ) );
	ArrayRemoveIndex( self.leaderDialogQueue, 0 );
	
	team = self.pers[ "team" ];
	
	if ( isdefined( self.leaderDialogGroups[dialog] ) )
	{
		group = dialog;
		dialog = self.leaderDialogGroups[group];
		self.leaderDialogGroups[group] = undefined;
		self.currentLeaderDialogGroup = group;
	}

	if( level.allowAnnouncer )
	{
		soundIndex = dialog;
		
		if ( isdefined(soundIndex) && IsInt( soundIndex ) )
		{
			soundId = GetMpDialogCommander( self.pers["mpcommander"], soundIndex );
			
			if ( isdefined( soundId ) )
			{
				alias = SoundGetAlias( soundId );
				self playLocalSound( soundId );
				self.currentLeaderDialog = dialog;
				self.currentLeaderDialogTime = GetTime();
				
				wait( 4.4 );
			}			
		}
	}
	
	//waitForSound( sound_name );
	
	self.leaderDialogActive = false;
	self.currentLeaderDialogGroup = "";
	self.currentLeaderDialog = "";

	if ( self.leaderDialogQueue.size > 0 )
	{			
		self thread play_next_leader_dialog();
	}
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
			leader_dialog( 33, team );
			leader_dialog_for_other_teams( 32, team );
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
			return "halftime";
		case "overtime":
			return "overtime";
		default:
			return "side_switch";
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
			leader_dialog( "timesup", team, undefined, undefined , "squad_30sec" );
		}
	}
	else
	{
		level waittill ( "match_ending_vox" );

		leader_dialog( "timesup" );
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
		game[ "musicSet" ] = randomintrange(1,3);
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
    
    level waittill ( "match_ending_very_soon" );
    
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