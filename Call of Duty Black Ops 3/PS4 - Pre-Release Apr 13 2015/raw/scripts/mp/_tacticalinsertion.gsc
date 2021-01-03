#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\shared\util_shared;
#using scripts\shared\sound_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_util;
               

#namespace teamops;
	
function getTeamopsTableID()
{
	teamopsInfoTableLoaded = false;
	teamopsInfoTableID = TableLookupFindCoreAsset( "gamedata/tables/mp/teamops.csv" );
		
	if ( isdefined( teamopsInfoTableID ) )
	{
		teamopsInfoTableLoaded = true;
	}
	assert( teamopsInfoTableLoaded, "Team Ops Event Table is not loaded: " + "gamedata/tables/mp/teamops.csv" );
	return teamopsInfoTableID;
}

function init()
{
	game["teamops"] = SpawnStruct();

	game["teamops"].data = [];
	game["teamops"].teamProgress = [];
	game["teamops"].teamopsName = undefined;

	foreach( team in level.teams )
	{
		game["teamops"].teamProgress[team] = 0;
	}

	level.teamopsOnProcessPlayerEvent = &teamops::processPlayerEvent;

	tableID = getTeamopsTableID();
		
	assert( isdefined( tableID ) );
	if( !isdefined( tableID ) )
	{
		game["teamops"].teamopsInitialed = false;
		return;
	}
		
	for( row = 1; row < 256; row++ )
	{
		name = tableLookupColumnForRow( tableID, row, 0 );
		if( name != "" )
		{
			game["teamops"].data[name] = SpawnStruct();
			game["teamops"].data[name].description = tableLookupColumnForRow( tableID, row, 1 );
			game["teamops"].data[name].pushevent = tableLookupColumnForRow( tableID, row, 2 );
			game["teamops"].data[name].popevent = tableLookupColumnForRow( tableID, row, 3 );
			game["teamops"].data[name].resetevent = tableLookupColumnForRow( tableID, row, 4 );
			game["teamops"].data[name].count = int( tableLookupColumnForRow( tableID, row, 5 ) );
			game["teamops"].data[name].time = int( tableLookupColumnForRow( tableID, row, 6 ) );
			game["teamops"].data[name].modes = StrTok( tableLookupColumnForRow( tableID, row, 7 ), "," );
			game["teamops"].data[name].rewards = StrTok( tableLookupColumnForRow( tableID, row, 8 ), "," );
		}
	}

	game["teamops"].teamopsInitialized = true;
}

function getID( name )
{
	tableID = getTeamopsTableID();
	for( row = 1; row < 256; row++ )
	{
		_name = tableLookupColumnForRow( tableID, row, 0 );
		if( name == _name )
			return row;
	}
	return 0;
}

function teamOpsAllowed( name )
{
	teamops = game["teamops"].data[name];

	if( teamops.modes.size == 0 )
		return true;

	for( mi = 0; mi < teamops.modes.size; mi++ )
	{
		if( teamops.modes[mi] == level.gameType )
			return true;
	}
	return false;
}

function startTeamops( name )
{
	level notify( "teamops_starting" );
	level.teamopsOnPlayerKilled = undefined;
	if( !teamOpsAllowed( name ) )
		return;

	TeamOpsShowHUD( 0 );

	preAnounceTime = GetDvarInt( "teamOpsPreanounceTime", 5 );

	foreach( team in level.teams )
	{
		globallogic_audio::leader_dialog( "teamops_preannounce", team );
	}

	wait ( preAnounceTime );

	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if( isdefined( player ) )
			player playlocalsound( "uin_objective_updated" );
	}

	teamops = game["teamops"].data[name];

	game["teamops"].teamopsName = name;
	game["teamops"].teamOpsID = getID( name );
	game["teamops"].teamopsRewardIndex = RandomIntRange( 0, teamops.rewards.size );
	game["teamops"].teamopsReward = teamops.rewards[game["teamops"].teamopsRewardIndex];
	game["teamops"].teamopsStartTime = GetTime();

	foreach( team in level.teams )
	{
		game["teamops"].teamProgress[team] = 0;
	}

	wait 0.1;

	TeamOpsStart( game["teamops"].teamOpsID, game["teamops"].teamopsRewardIndex, game["teamops"].teamopsStartTime, teamops.time );

	wait 0.1;

	TeamOpsShowHUD( 1 );
	TeamOpsUpdateProgress( "axis",  0 );
	TeamOpsUpdateProgress( "allies",  0 );

	level thread teamOpsWatcher();
}

function teamOpsWatcher()
{
	while( isdefined( game["teamops"].teamopsName ) )
	{
		time = game["teamops"].data[game["teamops"].teamopsName].time;
		if( isdefined( time ) && ( time > 0 ) )
		{
			elapsed = GetTime() - game["teamops"].teamopsStartTime;
			if( elapsed > time * 1000 )
			{
				stopTeamops();
				foreach( team in level.teams )
				{
					globallogic_audio::leader_dialog( "teamops_timeout", team );
				}
			}
		}
		wait 0.5;
	}
}

function stopTeamops()
{
	TeamOpsShowHUD( 0 );
	game["teamops"].teamopsName = undefined;
	game["teamops"].teamopsReward = undefined;
	game["teamops"].teamopsStartTime = undefined;

	foreach( team in level.teams )
	{
		game["teamops"].teamProgress[team] = 0;
	}
}

function processPlayerEvent( event, player )
{
	teamopsName = game["teamops"].teamopsName;

	if( isplayer( player ) && isdefined( teamopsName ) )
	{
		level processTeamEvent( event, player, player.team );
	}
}

function processTeamEvent( event, player, team )
{
	teamopsName = game["teamops"].teamopsName;
	teamops = game["teamops"].data[teamopsName];

	if( isdefined( teamops.pushevent ) && ( event == teamops.pushevent ) )
	{
		game["teamops"].teamProgress[team] += 1; 
		level updateTeamOps( event, player, team );
	}

	if( isdefined( teamops.popevent ) && ( event == teamops.popevent ) )
	{
		game["teamops"].teamProgress[team] -= 1; 
		if( game["teamops"].teamProgress[team] < 0 )
			game["teamops"].teamProgress[team]= 0;
		level updateTeamOps( event, player, team );
	}

	if( isdefined( teamops.resetevent ) && ( event == teamops.resetevent ) )
	{
		game["teamops"].teamProgress[team] = 0; 
		level updateTeamOps( event, player, team );
	}

}

function updateTeamOps( event, player, team )
{
	teamopsName = game["teamops"].teamopsName;
	teamops = game["teamops"].data[teamopsName];

	count_target = teamops.count;
	progress = int( ( 100 * game["teamops"].teamProgress[team] ) / count_target );
			
	TeamOpsUpdateProgress( team, progress );

	if( game["teamops"].teamProgress[team] >= teamops.count )
	{
		if( isdefined( player ) )
		{
			level thread teamOpsAcheived( player, team );
		}
	}
}

function teamOpsAcheived( player, team )
{
	game["teamops"].teamopsName = undefined;
	wait 0.5;
	TeamOpsShowHUD( 0 );

	wait 2;
	globallogic_audio::leader_dialog( "teamops_win", team );
	globallogic_audio::leader_dialog_for_other_teams( "teamops_lose", team );

	player killstreaks::give( game["teamops"].teamopsReward, 1 );
	wait 2; 
	player killstreaks::useKillstreak( game["teamops"].teamopsReward, 1 );
}

function main()
{
	thread watchTeamOpsTime();
	level.teamopsTargetKills = GetDvarInt( "teamOpsKillsCountTrigger_" + level.gameType, 37 );
	if ( level.teamopsTargetKills > 0 )
	{
		level.teamopsOnPlayerKilled = &teamops::onPlayerKilled;
	}
}

function GetCompatibleOperation()
{
	operations = StrTok( GetDvarString( "teamOpsName" ), "," );

	// try to pickup a random one
	for( i = 0; i < 20; i++ )
	{
		operation = operations[RandomIntRange( 0, operations.size )];
		if( teamOpsAllowed( operation ) )
			return operation;
	}

	// check if we have any compatible operation
	for( i = 0; i < operations.size; i++ )
	{
		operation = operations[i];
		if( teamOpsAllowed( operation ) )
			return operation;
	}

	return undefined;
}

function watchTeamOpsTime()
{
	level endon( "teamops_starting" );
	
	if ( ( isdefined( level.inPrematchPeriod ) && level.inPrematchPeriod ) )
		level waittill("prematch_over");

	activeTeamOps = GetCompatibleOperation();
	if( !isdefined( activeTeamOps ) )
		return;

	startDelay = GetDvarInt( "teamOpsStartDelay_" + level.gameType, 300 );
	
	while( 1 )
	{
		if( isdefined( game["teamops"].teamopsName ) )
		{
			if ( GetDvarInt( "scr_stop_teamops" ) == 1 )
			{
				teamops::stopTeamops();
				SetDvar( "scr_stop_teamops", 0 );
			}
		}

		timePassed = globallogic_utils::getTimePassed() / 1000;

		startTeamOps = 0;
		if( timePassed > startDelay )
		{
			level thread startTeamops( activeTeamOps );
			break;
		}
		
		wait 1;		
	}
}


function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	level endon( "teamops_starting" );

	if ( isPlayer( attacker ) == false || attacker.team == self.team )
		return;
	
	if ( !isdefined( level.teamopsKillTracker ) )
	{
		level.teamopsKillTracker = [];
	}
	
	if ( !isdefined( level.teamopsKillTracker[attacker.team] ) )
	{
		level.teamopsKillTracker[attacker.team] = 0;
	}
	
	level.teamopsKillTracker[attacker.team]++;
	
	if ( level.teamopsKillTracker[attacker.team] >= level.teamopsTargetKills  )
	{
		activeTeamOps = GetCompatibleOperation();
		if( !isdefined( activeTeamOps ) )
			return;
	
		level thread startTeamops( activeTeamOps );
	}
}