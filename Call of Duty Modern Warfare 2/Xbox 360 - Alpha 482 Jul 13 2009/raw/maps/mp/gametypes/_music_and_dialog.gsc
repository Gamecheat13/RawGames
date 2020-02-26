#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	game["music"]["spawn_allies"] = maps\mp\gametypes\_teams::getTeamSpawnMusic( "allies" );
	game["music"]["victory_allies"] = maps\mp\gametypes\_teams::getTeamWinMusic( "allies" );
	game["voice"]["allies"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "1mc_";

	game["music"]["spawn_axis"] = maps\mp\gametypes\_teams::getTeamSpawnMusic( "axis" );
	game["music"]["victory_axis"] = maps\mp\gametypes\_teams::getTeamWinMusic( "axis" );
	game["voice"]["axis"] = maps\mp\gametypes\_teams::getTeamVoicePrefix( "axis" ) + "1mc_";

	game["music"]["defeat"] 			= "mp_defeat";
	game["music"]["victory_spectator"] 	= "mp_defeat";
	game["music"]["winning_time"] 		= "mp_time_running_out_winning";
	game["music"]["losing_time"] 		= "mp_time_running_out_losing";
	game["music"]["winning_score"] 		= "mp_time_running_out_winning";
	game["music"]["losing_score"] 		= "mp_time_running_out_losing";
	game["music"]["victory_tie"] 		= "mp_defeat";
	
	game["music"]["suspense"] = [];
	game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_01";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_02";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_03";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_04";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_05";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_06";

	game["dialog"]["mission_success"] = "mission_success";
	game["dialog"]["mission_failure"] = "mission_fail";
	game["dialog"]["mission_draw"] = "draw";

	game["dialog"]["round_success"] = "encourage_win";
	game["dialog"]["round_failure"] = "encourage_lost";
	game["dialog"]["round_draw"] = "draw";
	
	// status
	game["dialog"]["timesup"] = "timesup";
	game["dialog"]["winning_time"] = "winning";
	game["dialog"]["losing_time"] = "losing";
	game["dialog"]["winning_score"] = "winning_fight";
	game["dialog"]["losing_score"] = "losing_fight";
	game["dialog"]["lead_lost"] = "lead_lost";
	game["dialog"]["lead_tied"] = "tied";
	game["dialog"]["lead_taken"] = "lead_taken";
	game["dialog"]["last_alive"] = "lastalive";

	game["dialog"]["boost"] = "boost";

	if ( !isDefined( game["dialog"]["offense_obj"] ) )
		game["dialog"]["offense_obj"] = "boost";
	if ( !isDefined( game["dialog"]["defense_obj"] ) )
		game["dialog"]["defense_obj"] = "boost";
	
	game["dialog"]["hardcore"] = "hardcore";
	game["dialog"]["highspeed"] = "highspeed";
	game["dialog"]["tactical"] = "tactical";

	game["dialog"]["challenge"] = "challengecomplete";
	game["dialog"]["promotion"] = "promotion";

	game["dialog"]["bomb_taken"] = "acheive_bomb";
	game["dialog"]["bomb_lost"] = "bomb_taken";
	game["dialog"]["bomb_defused"] = "bomb_defused";
	game["dialog"]["bomb_planted"] = "bomb_planted";

	game["dialog"]["obj_taken"] = "securedobj";
	game["dialog"]["obj_lost"] = "lostobj";

	game["dialog"]["obj_defend"] = "obj_defend";
	game["dialog"]["obj_destroy"] = "obj_destroy";
	game["dialog"]["obj_capture"] = "capture_obj";
	game["dialog"]["objs_capture"] = "capture_objs";

	game["dialog"]["hq_located"] = "hq_located";
	game["dialog"]["hq_enemy_captured"] = "hq_captured";
	game["dialog"]["hq_enemy_destroyed"] = "hq_destroyed";
	game["dialog"]["hq_secured"] = "hq_secured";
	game["dialog"]["hq_offline"] = "hq_offline";
	game["dialog"]["hq_online"] = "hq_online";

	game["dialog"]["move_to_new"] = "new_positions";

	game["dialog"]["attack"] = "attack";
	game["dialog"]["defend"] = "defend";
	game["dialog"]["offense"] = "offense";
	game["dialog"]["defense"] = "defense";

	game["dialog"]["halftime"] = "halftime";
	game["dialog"]["overtime"] = "overtime";
	game["dialog"]["side_switch"] = "switching";

	game["dialog"]["flag_taken"] = "ourflag";
	game["dialog"]["flag_dropped"] = "ourflag_drop";
	game["dialog"]["flag_returned"] = "ourflag_return";
	game["dialog"]["flag_captured"] = "ourflag_capt";
	game["dialog"]["flag_getback"] = "getback_ourflag";
	game["dialog"]["enemy_flag_bringhome"] = "enemyflag_tobase";
	game["dialog"]["enemy_flag_taken"] = "enemyflag";
	game["dialog"]["enemy_flag_dropped"] = "enemyflag_drop";
	game["dialog"]["enemy_flag_returned"] = "enemyflag_return";
	game["dialog"]["enemy_flag_captured"] = "enemyflag_capt";

	game["dialog"]["capturing_a"] = "capturing_a";
	game["dialog"]["capturing_b"] = "capturing_b";
	game["dialog"]["capturing_c"] = "capturing_c";
	game["dialog"]["captured_a"] = "capture_a";
	game["dialog"]["captured_b"] = "capture_c";
	game["dialog"]["captured_c"] = "capture_b";

	game["dialog"]["securing_a"] = "securing_a";
	game["dialog"]["securing_b"] = "securing_b";
	game["dialog"]["securing_c"] = "securing_c";
	game["dialog"]["secured_a"] = "secure_a";
	game["dialog"]["secured_b"] = "secure_b";
	game["dialog"]["secured_c"] = "secure_c";

	game["dialog"]["losing_a"] = "losing_a";
	game["dialog"]["losing_b"] = "losing_b";
	game["dialog"]["losing_c"] = "losing_c";
	game["dialog"]["lost_a"] = "lost_a";
	game["dialog"]["lost_b"] = "lost_b";
	game["dialog"]["lost_c"] = "lost_c";

	game["dialog"]["enemy_taking_a"] = "enemy_take_a";
	game["dialog"]["enemy_taking_b"] = "enemy_take_b";
	game["dialog"]["enemy_taking_c"] = "enemy_take_c";
	game["dialog"]["enemy_has_a"] = "enemy_has_a";
	game["dialog"]["enemy_has_b"] = "enemy_has_b";
	game["dialog"]["enemy_has_c"] = "enemy_has_c";

	game["dialog"]["lost_all"] = "take_positions";
	game["dialog"]["secure_all"] = "positions_lock";

	game["dialog"]["destroy_sentry"] = "dest_sentrygun";
	//For Arena
	game["dialog"]["enemy_taking"] = "enemy_take";
	game["dialog"]["securing"] = "securing";
	game["dialog"]["arena"] = "arena";
	
	game["music"]["nuke_music"] = "nuke_music";

	game["dialog"]["sentry_gone"] = "sentry_gone";
	game["dialog"]["sentry_destroyed"] = "sentry_gone";
	game["dialog"]["ti_gone"] = "glowstick_gone";
	game["dialog"]["ti_destroyed"] = "glowstick_destroyed";
	
	level thread onPlayerConnect();
	level thread onLastAlive();
	level thread musicController();
	level thread onGameEnded();
	level thread onRoundSwitch();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connected", player );

		player thread onPlayerSpawned();
		player thread finalKillcamMusic();
	}
}


onPlayerSpawned()
{
	self endon ( "disconnect" );

	self waittill( "spawned_player" );

	self playLocalSound( game["music"]["spawn_" + self.team] );

	if ( isDefined( game["dialog"]["gametype"] ) && (!level.splitscreen || self == level.players[0]) )
		self leaderDialogOnPlayer( "gametype" );

	while ( level.prematchPeriod )
		wait ( 0.05 );

	if ( self.team == game["attackers"] )
		self leaderDialogOnPlayer( "offense_obj", "introboost" );
	else
		self leaderDialogOnPlayer( "defense_obj", "introboost" );
}


onLastAlive()
{
	level endon ( "game_ended" );

	level waittill ( "last_alive", player );
	
	if ( !isAlive( player )	)
		return;
	
	player leaderDialogOnPlayer( "last_alive" );
}


onRoundSwitch()
{
	level waittill ( "round_switch", switchType );

	switch( switchType )
	{
		case "halftime":
			foreach ( player in level.players )
				player leaderDialogOnPlayer( "halftime" );
			break;
		case "overtime":
			foreach ( player in level.players )
				player leaderDialogOnPlayer( "overtime" );
			break;
		default:
			foreach ( player in level.players )
				player leaderDialogOnPlayer( "side_switch" );
			break;
	}
}


onGameEnded()
{
	level thread roundWinnerDialog();
	level thread gameWinnerDialog();
	
	level waittill ( "game_win", winner );
	
	if ( isDefined( level.nukeDetonated ) )
	{
		if ( !level.splitScreen )
			playSoundOnPlayers( game["music"]["nuke_music"] );
		else
			level.players[0] playLocalSound( game["music"]["nuke_music"] );
			
		return;
	}

	if ( level.teamBased )
	{
		if ( level.splitscreen )
		{
			if ( winner == "allies" )
				playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
			else if ( winner == "axis" )
				playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
			else
				playSoundOnPlayers( game["music"]["defeat"] );
		}
		else
		{
			if ( winner == "allies" )
			{
				playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
				playSoundOnPlayers( game["music"]["defeat"], "axis" );
			}
			else if ( winner == "axis" )
			{
				playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
				playSoundOnPlayers( game["music"]["defeat"], "allies" );
			}
			else
			{
				playSoundOnPlayers( game["music"]["defeat"] );
			}
		}
	}
	else
	{
		foreach ( player in level.players )
		{
			if ( isDefined( winner ) && player == winner )
				player playLocalSound( game["music"]["victory_" + player.pers["team"] ] );
			else if ( !level.splitScreen )
				player playLocalSound( game["music"]["defeat"] );
		}
	}
}


roundWinnerDialog()
{
	level waittill ( "round_win", winner );

	delay = level.roundEndDelay / 4;
	if ( delay > 0 )
		wait ( delay );

	if ( !isDefined( winner ) || isPlayer( winner ) || isDefined( level.nukeDetonated ) )
		return;

	if ( winner == "allies" )
	{
		leaderDialog( "round_success", "allies" );
		leaderDialog( "round_failure", "axis" );
	}
	else if ( winner == "axis" )
	{
		leaderDialog( "round_success", "axis" );
		leaderDialog( "round_failure", "allies" );
	}
}


gameWinnerDialog()
{
	level waittill ( "game_win", winner );
	
	delay = level.postRoundTime / 2;
	if ( delay > 0 )
		wait ( delay );

	if ( !isDefined( winner ) || isPlayer( winner ) || isDefined( level.nukeDetonated ) )
		return;

	if ( winner == "allies" )
	{
		leaderDialog( "mission_success", "allies" );
		leaderDialog( "mission_failure", "axis" );
	}
	else if ( winner == "axis" )
	{
		leaderDialog( "mission_success", "axis" );
		leaderDialog( "mission_failure", "allies" );
	}
	else
	{
		leaderDialog( "mission_draw" );
	}	
}


musicController()
{
	level endon ( "game_ended" );
	
	if ( !level.hardcoreMode )
		thread suspenseMusic();
	
	level waittill ( "match_ending_soon", reason );
	assert( isDefined( reason ) );

	if ( getWatchedDvar( "roundlimit" ) == 1 || game["roundsPlayed"] == (getWatchedDvar( "roundlimit" ) - 1) )
	{	
		if ( !level.splitScreen )
		{
			if ( reason == "time" )
			{
				if ( level.teamBased )
				{
					if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
					{
						if ( !level.hardcoreMode )
						{
							playSoundOnPlayers( game["music"]["winning_time"], "allies" );
							playSoundOnPlayers( game["music"]["losing_time"], "axis" );
						}
				
						leaderDialog( "winning_time", "allies" );
						leaderDialog( "losing_time", "axis" );
					}
					else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
					{
						if ( !level.hardcoreMode )
						{
							playSoundOnPlayers( game["music"]["winning_time"], "axis" );
							playSoundOnPlayers( game["music"]["losing_time"], "allies" );
						}
							
						leaderDialog( "winning_time", "axis" );
						leaderDialog( "losing_time", "allies" );
					}
				}
				else
				{
					if ( !level.hardcoreMode )
						playSoundOnPlayers( game["music"]["losing_time"] );
	
					leaderDialog( "timesup" );
				}
			}	
			else if ( reason == "score" )
			{
				if ( level.teamBased )
				{
					if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
					{
						if ( !level.hardcoreMode )
						{
							playSoundOnPlayers( game["music"]["winning_score"], "allies" );
							playSoundOnPlayers( game["music"]["losing_score"], "axis" );
						}
				
						leaderDialog( "winning_score", "allies" );
						leaderDialog( "losing_score", "axis" );
					}
					else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
					{
						if ( !level.hardcoreMode )
						{
							playSoundOnPlayers( game["music"]["winning_score"], "axis" );
							playSoundOnPlayers( game["music"]["losing_score"], "allies" );
						}
							
						leaderDialog( "winning_score", "axis" );
						leaderDialog( "losing_score", "allies" );
					}
				}
				else
				{
					winningPlayer = maps\mp\gametypes\_gamescore::getHighestScoringPlayer();
					losingPlayers = maps\mp\gametypes\_gamescore::getLosingPlayers();
					excludeList[0] = winningPlayer;

					if ( !level.hardcoreMode )
					{
						winningPlayer playLocalSound( game["music"]["winning_score"] );
						playSoundOnPlayers( game["music"]["losing_score"], undefined, excludeList );
					}
	
					winningPlayer leaderDialogOnPlayer( "winning_score" );
					leaderDialogOnPlayers( "losing_score", losingPlayers );
				}
			}
			
			level waittill ( "match_ending_very_soon" );
			leaderDialog( "timesup" );
		}
	}
	else
	{
		if ( !level.hardcoreMode )
			playSoundOnPlayers( game["music"]["losing_time"] );

		leaderDialog( "timesup" );
	}
}


suspenseMusic()
{
	level endon ( "game_ended" );
	level endon ( "match_ending_soon" );
	
	numTracks = game["music"]["suspense"].size;
	for ( ;; )
	{
		wait ( randomFloatRange( 60, 120 ) );
		
		playSoundOnPlayers( game["music"]["suspense"][randomInt(numTracks)] ); 
	}
}


finalKillcamMusic()
{
	self waittill ( "showing_final_killcam" );
	
//	self playLocalSound( game["music"]["winning"] );
}