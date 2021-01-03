#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_rank;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_challenges;
#using scripts\mp\_popups;
#using scripts\mp\_util;
#using scripts\mp\teams\_teams;

                                            




/*
	CTF
	
	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_sd_spawn_attacker
			Allied players spawn from these. Place at least 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_sd_spawn_defender
			Axis players spawn from these. Place at least 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Flag:
			classname				trigger_multiple
			targetname				flagtrigger
			script_gameobjectname	ctf
			script_label				Set to name of flag. This sets the letter shown on the compass in original mode.
			script_team					Set to allies or axis. This is used to set which team a flag is used by.
			This should be a 16x16 unit trigger with an origin brush placed so that it's center lies on the bottom plane of the trigger.
			Must be in the level somewhere. This is the trigger that is used to represent a flag.
			It gets moved to the position of the planted bomb model.
*/

/*QUAKED mp_ctf_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_ctf_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/




	
#precache( "string", "OBJECTIVES_CTF" );
#precache( "string", "OBJECTIVES_CTF_SCORE" );
#precache( "string", "OBJECTIVES_CTF_HINT" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_1" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_1" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_2_WINNER" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_2_LOSER" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_2_TIE" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_2_TIE" );
#precache( "string", "MP_FLAG_TAKEN_BY");
#precache( "string", "MP_ENEMY_FLAG_TAKEN");
#precache( "string", "MP_FRIENDLY_FLAG_TAKEN");
#precache( "string", "MP_FLAG_CAPTURED_BY");
#precache( "string", "MP_ENEMY_FLAG_CAPTURED_BY");
#precache( "string", "MP_FLAG_RETURNED_BY");
#precache( "string", "MP_FLAG_RETURNED");
#precache( "string", "MP_ENEMY_FLAG_RETURNED");
#precache( "string", "MP_FRIENDLY_FLAG_RETURNED");
#precache( "string", "MP_YOUR_FLAG_RETURNING_IN");
#precache( "string", "MP_ENEMY_FLAG_RETURNING_IN");
#precache( "string", "MP_FRIENDLY_FLAG_DROPPED_BY");
#precache( "string", "MP_FRIENDLY_FLAG_DROPPED");
#precache( "string", "MP_ENEMY_FLAG_DROPPED");
#precache( "string", "MP_SUDDEN_DEATH");
#precache( "string", "MP_CAP_LIMIT_REACHED");
#precache( "string", "MP_CTF_CANT_CAPTURE_FLAG" );
#precache( "string", "MP_CTF_OVERTIME_WIN" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_1" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_2_WINNER" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_2_LOSER" );
#precache( "string", "MP_CTF_OVERTIME_ROUND_2_TIE" );
#precache( "string", "MPUI_CTF_OVERTIME_FASTEST_CAP_TIME" );
#precache( "string", "MPUI_CTF_OVERTIME_DEFEAT_TIMELIMIT" );
#precache( "string", "MPUI_CTF_OVERTIME_DEFEAT_DID_NOT_DEFEND" );
#precache( "objective", "allies_base" );
#precache( "objective", "axis_base" );
#precache( "objective", "allies_flag" );
#precache( "objective", "axis_flag" );

function autoexec __init__sytem__() {     system::register("ctf",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "scriptmover", "ctf_flag_away", 1, 1, "int" );	
}

function main()
{
	globallogic::init();
	
	util::registerTimeLimit( 0, 1440 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerRoundSwitch( 0, 9 );
	util::registerNumLives( 0, 100 );
	util::registerScoreLimit( 0, 5000 );

	level.scoreRoundWinBased = ( GetGametypeSetting( "cumulativeRoundScores" ) == false );
	level.flagCaptureCondition = GetGametypeSetting( "flagCaptureCondition" );
	
	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	if ( GetDvarString( "scr_ctf_spawnPointFacingAngle") == "" )
		SetDvar("scr_ctf_spawnPointFacingAngle", "0");

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onPlayerKilled =&onPlayerKilled;
	level.onRoundSwitch =&onRoundSwitch;
	level.onEndGame =&onEndGame;
	level.onRoundEndGame =&onRoundEndGame;
	level.getTeamKillPenalty =&ctf_getTeamKillPenalty;
	level.getTeamKillScore =&ctf_getTeamKillScore;
	level.setMatchScoreHUDElemForTeam =&setMatchScoreHUDElemForTeam;
	level.shouldPlayOvertimeRound =&shouldPlayOvertimeRound;

	if ( !isdefined( game["ctf_teamscore"] ) )
	{
		game["ctf_teamscore"]["allies"] = 0;
		game["ctf_teamscore"]["axis"] = 0;
	}
	
	globallogic_audio::set_leader_gametype_dialog ( 0, 15, 48, 48 );

	level.lastDialogTime = getTime();	

	level thread ctf_icon_hide();

	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "captures", "returns", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "captures", "returns" );

	globallogic_audio::register_dialog_group( "ctf_flag", false );
	globallogic_audio::register_dialog_group( "ctf_flag_enemy", false );
}

function onPrecacheGameType()
{
	game["flag_dropped_sound"] = "mp_war_objective_lost";
	game["flag_recovered_sound"] = "mp_war_objective_taken";

	game["strings"]["score_limit_reached"] = &"MP_CAP_LIMIT_REACHED";

}

function onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	/#
	setdebugsideswitch(game["switchedsides"]);
	#/
	
	setClientNameMode("auto_change");

	globallogic_score::resetTeamScores();

	util::setObjectiveText( "allies", &"OBJECTIVES_CTF" );
	util::setObjectiveText( "axis", &"OBJECTIVES_CTF" );
	
	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_CTF_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_CTF_HINT" );
	
	if ( isdefined( game["overtime_round"] ) )
	{
		// This is only necessary when cumulativeRoundScores is on so that the game doesn't immediately end due to scorelimit being set to 1 in OT
		[[level._setTeamScore]]( "allies", 0 );
		[[level._setTeamScore]]( "axis", 0 );
		
		// One flag wins the round
		util::registerScoreLimit( 1, 1 );
		if ( isdefined( game["ctf_overtime_time_to_beat"] ) )
		{
			util::registerTimeLimit( game["ctf_overtime_time_to_beat"] / 60000, game["ctf_overtime_time_to_beat"] / 60000 );
		}
		
		if ( game["overtime_round"] == 1 )
		{
			util::setObjectiveHintText( "allies", &"MP_CTF_OVERTIME_ROUND_1" );
			util::setObjectiveHintText( "axis", &"MP_CTF_OVERTIME_ROUND_1" );
		}
		else if ( isdefined( game["ctf_overtime_first_winner"] ) )
		{
			util::setObjectiveHintText( game["ctf_overtime_first_winner"], &"MP_CTF_OVERTIME_ROUND_2_WINNER" );
			util::setObjectiveHintText( util::getOtherTeam( game["ctf_overtime_first_winner"] ), &"MP_CTF_OVERTIME_ROUND_2_LOSER" );
		}
		else
		{
			util::setObjectiveHintText( "allies", &"MP_CTF_OVERTIME_ROUND_2_TIE" );
			util::setObjectiveHintText( "axis", &"MP_CTF_OVERTIME_ROUND_2_TIE" );
		}
	}
			
	allowed[0] = "ctf";
	
	gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	spawnlogic::place_spawn_points( "mp_ctf_spawn_allies_start" );
	spawnlogic::place_spawn_points( "mp_ctf_spawn_axis_start" );
	spawnlogic::add_spawn_points( "allies", "mp_ctf_spawn_allies" );
	spawnlogic::add_spawn_points( "axis", "mp_ctf_spawn_axis" );
	spawning::updateAllSpawnPoints();
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_axis = spawnlogic::get_spawnpoint_array( "mp_ctf_spawn_axis" );
	level.spawn_allies = spawnlogic::get_spawnpoint_array( "mp_ctf_spawn_allies" );

	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array("mp_ctf_spawn_" + team + "_start");
	}

		thread updateGametypeDvars();
	
	thread ctf();
}

function shouldPlayOvertimeRound()
{
	// Play 2 rounds of overtime
	if ( isdefined( game["overtime_round"] ) )
	{
		if ( game["overtime_round"] == 1 || !level.gameEnded ) // If we've only played 1 round or we're in the middle of the 2nd keep going
		{
			return true;
		}
		
		return false;
	}
	
	if ( !level.scoreRoundWinBased )
	{
		// Only go to overtime if both teams are tied and it's either the last round or both teams are one away from winning
		if ( ( game["teamScores"]["allies"] == game["teamScores"]["axis"] ) &&
		    ( util::hitRoundLimit() || ( game["teamScores"]["allies"] == level.scoreLimit-1 ) ) )
		{
			return true;
		}
	}
	else
	{
		// Only go to overtime if both teams are one round away from winning
		alliesRoundsWon = util::getRoundsWon( "allies" );
		axisRoundsWon = util::getRoundsWon( "axis" );
		if ( ( level.roundWinLimit > 0 ) && ( axisRoundsWon == level.roundWinLimit-1 ) && ( alliesRoundsWon == level.roundWinLimit-1 ) )
		{
			return true;
		}
		if ( util::hitRoundLimit() && ( alliesRoundsWon == axisRoundsWon ) )
		{
			return true;
		}
	}
	
	return false;
}

function minutesAndSecondsString( milliseconds )
{
	minutes = floor( milliseconds / 60000 );
	milliseconds -= minutes * 60000;
	seconds = floor( milliseconds / 1000 );
	if ( seconds < 10 )
	{
		return minutes+":0"+seconds;
	}
	else
	{
		return minutes+":"+seconds;
	}
}

function setMatchScoreHUDElemForTeam( team )
{
	if ( !isdefined( game["overtime_round"] ) )
	{
		self hud_message::setMatchScoreHUDElemForTeam( team );
	}
	else if ( isdefined( game["ctf_overtime_second_winner"] ) && ( game["ctf_overtime_second_winner"] == team ) )
	{
		self setText( minutesAndSecondsString( game["ctf_overtime_best_time"] ) );
	}
	else if ( isdefined( game["ctf_overtime_first_winner"] ) && ( game["ctf_overtime_first_winner"] == team ) )
	{
		self setText( minutesAndSecondsString( game["ctf_overtime_time_to_beat"] ) );
	}
	else
	{
		self setText( &"" );
	}
}

function onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	level.halftimeType = "halftime";
	game["switchedsides"] = !game["switchedsides"];
}

function onEndGame( winningTeam )
{
	if ( isdefined( game["overtime_round"] ) )
	{
		if ( game["overtime_round"] == 1 )
		{
			if ( isdefined( winningTeam ) && ( winningTeam != "tie" ) )
			{
				game["ctf_overtime_first_winner"] = winningTeam;
				game["ctf_overtime_time_to_beat"] = globallogic_utils::getTimePassed();
			}
		}
		else
		{
			game["ctf_overtime_second_winner"] = winningTeam;
			game["ctf_overtime_best_time"] = globallogic_utils::getTimePassed();
		}
	}
}

function onRoundEndGame( winningTeam )
{
	if ( isdefined( game["overtime_round"] ) )
	{
		if ( isdefined( game["ctf_overtime_first_winner"] ) )
		{
			if ( !isdefined( winningTeam ) || ( winningTeam == "tie" ) )
			{
				winningTeam = game["ctf_overtime_first_winner"];
			}
			
			if ( game["ctf_overtime_first_winner"] == winningTeam )
			{
				level.endVictoryReasonText = &"MPUI_CTF_OVERTIME_FASTEST_CAP_TIME";
				level.endDefeatReasonText = &"MPUI_CTF_OVERTIME_DEFEAT_TIMELIMIT";
			}
			else
			{
				level.endVictoryReasonText = &"MPUI_CTF_OVERTIME_FASTEST_CAP_TIME";
				level.endDefeatReasonText = &"MPUI_CTF_OVERTIME_DEFEAT_DID_NOT_DEFEND";
			}			
		}
		else if ( !isdefined( winningTeam ) || ( winningTeam == "tie" ) )
		{
			return "tie";
		}
		
		return winningTeam;
	}
	
	if ( level.scoreRoundWinBased ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	
		winner = globallogic::determineTeamWinnerByGameStat( "roundswon" );
	}
	else
	{
		winner = globallogic::determineTeamWinnerByTeamScore();
	}
	
	return winner;
}

function onSpawnPlayerUnified()
{
	self.isFlagCarrier = false;
	self.flagCarried = undefined;
	self clientfield::set( "ctf_flag_carrier", 0 );	
	
	spawning::onSpawnPlayer_Unified();
}

function onSpawnPlayer(predictedSpawn)
{
	self.isFlagCarrier = false;
	self.flagCarried = undefined;
	self clientfield::set( "ctf_flag_carrier", 0 );	

	spawnteam = self.pers["team"];
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		spawnteam = util::getOtherTeam( spawnteam );

	if ( level.useStartSpawns )
	{
			spawnpoint = spawnlogic::get_spawnpoint_random(level.spawn_start[spawnteam]);
	}	
	else
	{
		if (spawnteam == "axis")
			spawnpoint = spawnlogic::get_spawnpoint_near_team(level.spawn_axis);
		else
			spawnpoint = spawnlogic::get_spawnpoint_near_team(level.spawn_allies);
	}

	assert( isdefined(spawnpoint) );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "ctf" );
	}
}

function updateGametypeDvars()
{
	level.flagCaptureTime = GetGametypeSetting( "captureTime" );
	level.flagTouchReturnTime = GetGametypeSetting( "defuseTime" );  // using defuseTime for touch return
	level.idleFlagReturnTime = GetGametypeSetting( "idleFlagResetTime" );
	level.flagRespawnTime = GetGametypeSetting( "flagRespawnTime" );
	level.enemyCarrierVisible = GetGametypeSetting( "enemyCarrierVisible" );
	level.roundLimit = GetGametypeSetting( "roundLimit" );
	level.cumulativeRoundScores = GetGametypeSetting( "cumulativeRoundScores" );
	
	level.teamKillPenaltyMultiplier = GetGametypeSetting( "teamKillPenalty" );
	level.teamKillScoreMultiplier = GetGametypeSetting( "teamKillScore" );

	if ( level.flagTouchReturnTime >= 0 && level.flagTouchReturnTime != 63)
	{
		level.touchReturn = true;
	}
	else
	{
		level.touchReturn = false;
	}
}

function createFlag( trigger )
{		
	if ( isdefined( trigger.target ) )
	{
		visuals[0] = getEnt( trigger.target, "targetname" );
	}
	else
	{
		visuals[0] = spawn( "script_model", trigger.origin );
		visuals[0].angles = trigger.angles;
	}

	entityTeam = trigger.script_team;
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		entityTeam = util::getOtherTeam( entityTeam );

	visuals[0] setModel( teams::get_flag_model( entityTeam ) );
	visuals[0] SetTeam( entityTeam );

	flag = gameobjects::create_carry_object( entityTeam, trigger, visuals, (0,0,100), istring(entityTeam+"_flag") );
	flag gameobjects::set_team_use_time( "friendly", level.flagTouchReturnTime );
	flag gameobjects::set_team_use_time( "enemy", level.flagCaptureTime );
	flag gameobjects::allow_carry( "enemy" );
	flag gameobjects::set_visible_team( "any" );
	flag gameobjects::set_visible_carrier_model( teams::get_flag_carry_model( entityTeam ) );
	flag gameobjects::set_2d_icon( "friendly", level.iconDefend2D );
	flag gameobjects::set_3d_icon( "friendly", level.iconDefend3D );
	flag gameobjects::set_2d_icon( "enemy", level.iconCapture2D );
	flag gameobjects::set_3d_icon( "enemy", level.iconCapture3D );
	flag gameobjects::set_carry_icon( teams::get_flag_icon( entityTeam ) );

	if ( level.enemyCarrierVisible == 2 )
	{
		flag.objIDPingFriendly = true;
	}
	flag.allowWeapons = true;
	flag.onPickup =&onPickup;
	flag.onPickupFailed =&onPickup;
	flag.onDrop =&onDrop;
	flag.onReset =&onReset;
			
	if ( level.idleFlagReturnTime > 0 )
	{
		flag.autoResetTime = level.idleFlagReturnTime;
	}
	else
	{
		flag.autoResetTime = undefined;
	}		
	
	return flag;
}

function createFlagZone( trigger )
{
	visuals = [];
	
	entityTeam = trigger.script_team;
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		entityTeam = util::getOtherTeam( entityTeam );

	flagZone = gameobjects::create_use_object( entityTeam, trigger, visuals, (0,0,0), istring(entityTeam+"_base") );
	flagZone gameobjects::allow_use( "friendly" );
	flagZone gameobjects::set_use_time( 0 );
	flagZone gameobjects::set_use_text( &"MP_CAPTURING_FLAG" );
	flagZone gameobjects::set_visible_team( "friendly" );

	enemyTeam = util::getOtherTeam( entityTeam );
	flagZone gameobjects::set_key_object( level.teamFlags[enemyTeam] );
	flagZone.onUse =&onCapture;
	
	flag = level.teamFlags[entityTeam];
	flag.flagBase = flagZone;
	flagZone.flag = flag;
	
	traceStart = trigger.origin + (0,0,32);
	traceEnd = trigger.origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );

	upangles = vectorToAngles( trace["normal"] );
	flagZone.baseeffectforward = anglesToForward( upangles );
	flagZone.baseeffectright = anglesToRight( upangles );
	
	flagZone.baseeffectpos = trace["position"];
	
	flagZone.friendlyBaseEffect = spawnFx( level.flagBaseFXid[ "friendly" ], flagZone.baseeffectpos, flagZone.baseeffectforward, flagZone.baseeffectright );
	flagZone.enemyBaseEffect = spawnFx( level.flagBaseFXid[ "enemy" ], flagZone.baseeffectpos, flagZone.baseeffectforward, flagZone.baseeffectright );
	flagZone.neutralBaseEffect = spawnFx( level.flagBaseFXid[ "neutral" ], flagZone.baseeffectpos, flagZone.baseeffectforward, flagZone.baseeffectright );
	
	triggerFx( flagZone.friendlyBaseEffect, 0.001 );
	triggerFx( flagZone.enemyBaseEffect, 0.001 );
	triggerFx( flagZone.neutralBaseEffect, 0.001 );
	
	flagZone thread resetFlagBaseEffect();
	
	flagZone createFlagSpawnInfluencer( entityTeam );
	
	return flagZone;
}

function createFlagHint( team, origin )
{
	radius = 128;
	height = 64;
	
	trigger = spawn("trigger_radius", origin, 0, radius, height);
	trigger setHintString( &"MP_CTF_CANT_CAPTURE_FLAG" );
	trigger setcursorhint("HINT_NOICON");
	trigger.original_origin = origin;
	
	trigger turn_off();
	
	return trigger;
}
















#precache( "material", "waypoint_grab_red" );
#precache( "material", "waypoint_grab_red" );
#precache( "material", "waypoint_defend_flag" );
#precache( "material", "waypoint_defend_flag" );
#precache( "material", "waypoint_defend_flag" );
#precache( "material", "waypoint_defend_flag" );
#precache( "material", "waypoint_return_flag" );
#precache( "material", "waypoint_return_flag" );
#precache( "material", "waypoint_defend_flag" );
#precache( "material", "waypoint_escort" );
#precache( "material", "waypoint_escort" );
#precache( "material", "waypoint_kill" );
#precache( "material", "waypoint_kill" );
#precache( "material", "waypoint_waitfor_flag" );
#precache( "fx", "ui/fx_ui_flagbase_blue" );
#precache( "fx", "ui/fx_ui_flagbase_orng" );
#precache( "fx", "ui/fx_ui_flagbase_wht" );

function ctf()
{
	level.flags = [];
	level.teamFlags = [];
	level.flagZones = [];
	level.teamFlagZones = [];
	
	level.iconCapture3D = "waypoint_grab_red";
	level.iconCapture2D = "waypoint_grab_red";
	level.iconDefend3D = "waypoint_defend_flag";
	level.iconDefend2D = "waypoint_defend_flag";
	level.iconDropped3D = "waypoint_defend_flag";
	level.iconDropped2D = "waypoint_defend_flag";
	level.iconReturn3D = "waypoint_return_flag";
	level.iconReturn2D = "waypoint_return_flag";
	level.iconBase3D = "waypoint_defend_flag";
	level.iconEscort3D = "waypoint_escort";
	level.iconEscort2D = "waypoint_escort";
	level.iconKill3D = "waypoint_kill";
	level.iconKill2D = "waypoint_kill";
	level.iconWaitForFlag3D = "waypoint_waitfor_flag";
	
	level.flagBaseFXid = [];

	level.flagBaseFXid[ "friendly" ] 	= "ui/fx_ui_flagbase_blue";
	level.flagBaseFXid[ "enemy" ] 		= "ui/fx_ui_flagbase_orng";
	level.flagBaseFXid[ "neutral" ] 	= "ui/fx_ui_flagbase_wht";


	flag_triggers = getEntArray( "ctf_flag_pickup_trig", "targetname" );
	if ( !isdefined( flag_triggers ) || flag_triggers.size != 2)
	{
		/#util::error("Not enough ctf_flag_pickup_trig triggers found in map.  Need two.");#/
		return;
	}

	for ( index = 0; index < flag_triggers.size; index++ )
	{
		trigger = flag_triggers[index];
		
		flag = createFlag( trigger );
		
		team = flag gameobjects::get_owner_team();
		level.flags[level.flags.size] = flag;
		level.teamFlags[team] = flag;
		
	}

	flag_zones = getEntArray( "ctf_flag_zone_trig", "targetname" );
	if ( !isdefined( flag_zones ) || flag_zones.size != 2)
	{
		/#util::error("Not enough ctf_flag_zone_trig triggers found in map.  Need two.");#/
		return;
	}

	for ( index = 0; index < flag_zones.size; index++ )
	{
		trigger = flag_zones[index];
		
		flagZone = createFlagZone( trigger );

		team = flagZone gameobjects::get_owner_team();
		level.flagZones[level.flagZones.size] = flagZone;		
		level.teamFlagZones[team] = flagZone;		

		level.flagHints[team] = createFlagHint( team, trigger.origin );		

		facing_angle = GetDvarint( "scr_ctf_spawnPointFacingAngle");
		
		// the opposite team will want to face this point
		setspawnpointsbaseweight( util::getOtherTeamsMask(team), trigger.origin, facing_angle, level.spawnsystem.objective_facing_bonus);
	}
	
	// once all the flags have been registered with the game,
	// give each spawn point a baseline score for each objective flag,
	// based on whether or not player will be looking in the direction of that flag upon spawning
	//generate_baseline_spawn_point_scores();

	createReturnMessageElems();
}

//Runs each round, as function as restarted at the start of every round.
//Hides the flag status icons and the 2D and 3D icons from the player's view
function ctf_icon_hide()
{
	level waittill ( "game_ended" );

	level.teamFlags["allies"] gameobjects::set_visible_team( "none" );
	level.teamFlags["axis"] gameobjects::set_visible_team( "none" );
}

function removeInfluencers()
{
	if ( isdefined( self.spawn_influencer_enemy_carrier ) )
	{
		// self == player
		self spawning::remove_influencer( self.spawn_influencer_enemy_carrier );
		self.spawn_influencer_enemy_carrier = undefined;
	}
	if ( isdefined( self.spawn_influencer_friendly_carrier ) )
	{
		// self == player
		self spawning::remove_influencer( self.spawn_influencer_friendly_carrier );
		self.spawn_influencer_friendly_carrier = undefined;
	}
	if ( isdefined( self.spawn_influencer_dropped ) )
	{
		// self == flag
		self.trigger spawning::remove_influencer( self.spawn_influencer_dropped );
		self.spawn_influencer_dropped = undefined;
	}
}

function onDrop( player )
{
	if ( isdefined( player ) )
	{
		player clientfield::set( "ctf_flag_carrier", 0 );	
	}

	team = self gameobjects::get_owner_team();
	otherTeam = util::getOtherTeam( team );
	
	bbPrint( "mpobjective", "gametime %d objtype %s team %s", gettime(), "ctf_flagdropped", team );

	self.visuals[0] clientfield::set( "ctf_flag_away", 1 );
	
	if ( level.touchReturn )
	{
		self gameobjects::allow_carry( "any" );
		level.flagHints[otherTeam] turn_off();
	}
		
	if ( isdefined( player ) )
	{
		util::printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_war_objective_lost" );	

		level thread popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_DROPPED", player, team );
		level thread popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_DROPPED", player, otherTeam );
	}
	else
	{
		util::printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_war_objective_lost" );		
	}
	
	globallogic_audio::leader_dialog( 56, team, "ctf_flag" );
	globallogic_audio::leader_dialog( 60, otherTeam, "ctf_flag_enemy" );
	/#
	if ( isdefined( player ) )
	 	print( team + " flag dropped" );
	else
	 	print( team + " flag dropped" );
	#/

	if ( isdefined( player ) )
	{
		player playLocalSound("mpl_flag_drop_plr");
	}


	globallogic_audio::play_2d_on_team( "mpl_flagdrop_sting_friend", otherTeam );
	globallogic_audio::play_2d_on_team( "mpl_flagdrop_sting_enemy", team );

	if ( level.touchReturn )
	{
		self gameobjects::set_3d_icon( "friendly", level.iconReturn3D );
		self gameobjects::set_2d_icon( "friendly", level.iconReturn2D );
	}
	else
	{
		self gameobjects::set_3d_icon( "friendly", level.iconDropped3D );
		self gameobjects::set_2d_icon( "friendly", level.iconDropped2D );
	}	
	self gameobjects::set_visible_team( "any" );
	self gameobjects::set_3d_icon( "enemy", level.iconCapture3D );
	self gameobjects::set_2d_icon( "enemy", level.iconCapture2D );

	thread sound::play_on_players( game["flag_dropped_sound"], game["attackers"] );

	self thread returnFlagAfterTimeMsg( level.idleFlagReturnTime );	
	
	// remove carrier influencers
	if ( isdefined( player ) )
	{
		player removeInfluencers();
	}
		
	// create new influencers on the flag
	ss = level.spawnsystem;
	player_team_mask = util::getTeamMask( otherTeam );	// this is the player that has the flag's team
	enemy_team_mask = util::getTeamMask( team );	// and his enemies

	if ( isdefined( player ) )
		flag_origin = player.origin;
	else
		flag_origin = self.curorigin;
	
	self.spawn_influencer_dropped = self.trigger spawning::create_entity_influencer( "ctf_flag_dropped", player_team_mask|enemy_team_mask );
	SetInfluencerTimeOut( self.spawn_influencer_dropped, level.idleFlagReturnTime );

}


function onPickup( player )
{
	carrierKilledBy = self.carrierKilledBy;
	self.carrierKilledBy = undefined;
	if ( isdefined( self.spawn_influencer_dropped ) )
	{
		self.trigger spawning::remove_influencer( self.spawn_influencer_dropped );
		self.spawn_influencer_dropped = undefined;
	}

	player AddPlayerStatWithGameType( "PICKUPS", 1 );
	
	//scoreevents::processScoreEvent( "flag_grab", player );
	
	if ( level.touchReturn )
	{
		self gameobjects::allow_carry( "enemy" );
	}

	// always clear influencers. we'll create new ones if it's been picked up by an enemy.
	self removeInfluencers();

	team = self gameobjects::get_owner_team();
	otherTeam = util::getOtherTeam( team );

	self clearReturnFlagHudElems();		

	if ( isdefined( player ) && player.pers["team"] == team )
	{	
		self notify("picked_up");

		util::printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_obj_returned" );
	
		if( isdefined(player.pers["returns"]) )
		{
			player.pers["returns"]++;
			player.returns = player.pers["returns"];
		}
		if ( isdefined(carrierKilledBy) && carrierKilledBy == player ) 
		{
			scoreevents::processScoreEvent( "flag_carrier_kill_return_close", player );
		}
		else if (distancesquared(self.trigger.baseOrigin, player.origin) > 300*300) 
		{
			scoreevents::processScoreEvent( "flag_return", player );
		}
		demo::bookmark( "event", gettime(), player );

		player AddPlayerStatWithGameType( "RETURNS", 1 );

		level thread popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_RETURNED", player, team );
		level thread popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_RETURNED", player, otherTeam );

		self.visuals[0] clientfield::set( "ctf_flag_away", 0 );
		self gameobjects::set_flags( 0 );
		
		bbPrint( "mpobjective", "gametime %d objtype %s team %s", gettime(), "ctf_flagreturn", team );
		player RecordGameEvent("return");	
		
		// want to return the flag here
		self returnFlag();
		self gameobjects::return_home();
		/#
		if ( isdefined( player ) )
		 	print( team + " flag returned" );
		 else
		 	print( team + " flag returned" );
		#/
		 
		return;
	}
	else
	{
		bbPrint( "mpobjective", "gametime %d objtype %s team %s", gettime(), "ctf_flagpickup", team );
		player RecordGameEvent("pickup");

		scoreevents::processScoreEvent( "flag_grab", player );
		demo::bookmark( "event", gettime(), player );
	
		util::printAndSoundOnEveryone( otherteam, undefined, &"", undefined, "mp_obj_taken", "mp_enemy_obj_taken" );

		level thread popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_TAKEN", player, team );
		level thread popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_TAKEN", player, otherTeam );

		globallogic_audio::leader_dialog( 58, team, "ctf_flag" );
		globallogic_audio::leader_dialog( 62, otherTeam, "ctf_flag_enemy" );
	
		player.isFlagCarrier = true;
		player.flagCarried = self;
		player playLocalSound("mpl_flag_pickup_plr");
		player clientfield::set( "ctf_flag_carrier", 1 );	
		self gameobjects::set_flags( 1 );
	
		globallogic_audio::play_2d_on_team( "mpl_flagget_sting_friend", otherTeam );
		globallogic_audio::play_2d_on_team( "mpl_flagget_sting_enemy", team );
		
		if ( level.enemyCarrierVisible )
		{
			self gameobjects::set_visible_team( "any" );
		}
		else
		{
			self gameobjects::set_visible_team( "enemy" );
		}

		self gameobjects::set_2d_icon( "friendly", level.iconKill2D );
		self gameobjects::set_3d_icon( "friendly", level.iconKill3D );
		self gameobjects::set_2d_icon( "enemy", level.iconEscort2D );
		self gameobjects::set_3d_icon( "enemy", level.iconEscort3D );

		player thread claim_trigger( level.flagHints[otherTeam] );
		
		update_hints();
		
		
		//Reset flashback here
		player resetflashback();

		/#print( team + " flag taken" );#/
		
		ss = level.spawnsystem;
		player_team_mask = util::getTeamMask( otherTeam );	// this is the player that has the flag's team
		enemy_team_mask = util::getTeamMask( team );	// and his enemies
		
		player.spawn_influencer_friendly_carrier = player spawning::create_entity_masked_friendly_influencer( "ctf_carrier_friendly", player_team_mask );
		player.spawn_influencer_enemy_carrier = player spawning::create_entity_masked_enemy_influencer( "ctf_carrier_enemy", enemy_team_mask );
	}
	
}
function OnPickupMusicState ( player )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	// wait 6 seconds and see if the player still has the flag.
	wait (6);
	if (player.isFlagCarrier)
	{
		//Was the SUSPENSE state changes to ACTION - removed state CDC - 6/19/12
	}
}	
function isHome()
{
	if ( isdefined( self.carrier ) )
		return false;

	if ( self.curOrigin != self.trigger.baseOrigin )
		return false;
		
	return true;
}

function returnFlag()
{
	team = self gameobjects::get_owner_team();
	otherTeam = util::getOtherTeam(team);
	
	globallogic_audio::play_2d_on_team( "mpl_flagreturn_sting", team );
	globallogic_audio::play_2d_on_team( "mpl_flagreturn_sting", otherTeam );
	
	level.teamFlagZones[otherTeam] gameobjects::allow_use( "friendly" );
	level.teamFlagZones[otherTeam] gameobjects::set_visible_team( "friendly" );

	update_hints();
	
	if ( level.touchReturn )
	{
		self gameobjects::allow_carry( "enemy" );
	}
	self gameobjects::return_home();
	self gameobjects::set_visible_team( "any" );
	//TODO: Add 2D Icons
	self gameobjects::set_3d_icon( "friendly", level.iconDefend3D );
	self gameobjects::set_2d_icon( "friendly", level.iconDefend2D );
	self gameobjects::set_3d_icon( "enemy", level.iconCapture3D );	
	self gameobjects::set_2d_icon( "enemy", level.iconCapture2D );
	
	globallogic_audio::leader_dialog( 57, team, "ctf_flag" );
	globallogic_audio::leader_dialog( 61, otherTeam, "ctf_flag_enemy" );
}


function onCapture( player )
{
	team = player.pers["team"];
	enemyTeam = util::getOtherTeam( team );
	time = gettime();
	
	playerTeamsFlag = level.teamFlags[team];
	
	if ( (level.flagCaptureCondition == 1) && playerTeamsFlag gameobjects::is_object_away_from_home() )
	{
		return;
	}

	util::printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_obj_captured", "mp_enemy_obj_captured" );
	bbPrint( "mpobjective", "gametime %d objtype %s team %s", time, "ctf_flagcapture", enemyTeam ); // flag BELONGS to enemyTeam

	game["challenge"][team]["capturedFlag"] = true;
	
	player challenges::capturedObjective( time );
	
	if( isdefined(player.pers["captures"]) )
	{
		player.pers["captures"]++;
		player.captures = player.pers["captures"];
	}

	demo::bookmark( "event", gettime(), player );
	player AddPlayerStatWithGameType( "CAPTURES", 1 );

	level thread popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_CAPTURED", player, team );
	level thread popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_CAPTURED", player, enemyTeam );

	globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_enemy", enemyTeam );
	globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_friend", team );
	
	player giveFlagCaptureXP( player );

	/#print( enemyTeam + " flag captured" );#/

	flag = player.carryObject;
	
	flag.dontAnnounceReturn = true;
	flag gameobjects::return_home();
	flag.dontAnnounceReturn = undefined;
	
	otherTeam = util::getOtherTeam(team);
		level.teamFlags[otherTeam] gameobjects::allow_carry( "enemy" );
		level.teamFlags[otherTeam] gameobjects::set_visible_team( "any" );
		level.teamFlags[otherTeam] gameobjects::return_home();
		level.teamFlagZones[otherTeam] gameobjects::allow_use( "friendly" );
	
	player.isFlagCarrier = false;
	player.flagCarried = undefined;
	player clientfield::set( "ctf_flag_carrier", 0 );	

	// execution will stop on this line on last flag cap of a level
	globallogic_score::giveTeamScoreForObjective( team, 1 );
	
	// NOTE: team is the team of the capturing player, unlike in other flag events
	globallogic_audio::leader_dialog( 59, team, "ctf_flag_enemy" );
	globallogic_audio::leader_dialog( 55, enemyTeam, "ctf_flag" );

	flag removeInfluencers();
	player removeInfluencers();
}

function giveFlagCaptureXP( player )
{
	scoreevents::processScoreEvent( "flag_capture", player );
	player RecordGameEvent("capture");
}

function onReset()
{	
	update_hints();

	team = self gameobjects::get_owner_team();
	
	self gameobjects::set_3d_icon( "friendly", level.iconDefend3D );
	self gameobjects::set_2d_icon( "friendly", level.iconDefend2D );
	self gameobjects::set_3d_icon( "enemy", level.iconCapture3D );
	self gameobjects::set_2d_icon( "enemy", level.iconCapture2D );
	
	if ( level.touchReturn )
	{
		self gameobjects::allow_carry( "enemy" );
	}

	level.teamFlagZones[team] gameobjects::set_visible_team( "friendly" );
	level.teamFlagZones[team] gameobjects::allow_use( "friendly" );
	
	self.visuals[0] clientfield::set( "ctf_flag_away", 0 );
	self gameobjects::set_flags( 0 );
	self clearReturnFlagHudElems();
	self removeInfluencers();
}

function getOtherFlag( flag )
{
	if ( flag == level.flags[0] )
	 	return level.flags[1];
	 	
	return level.flags[0];
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if (  isdefined( attacker ) && isplayer( attacker ) )
	{
		for ( index = 0; index < level.flags.size; index++ )
		{
			flagTeam = "invalidTeam";
			inFlagZone = false;
			defendedFlag = false;
			offendedFlag = false;

			flagCarrier = level.flags[index].carrier;
			if ( isdefined( flagCarrier ) )
			{
				flagOrigin = level.flags[index].carrier.origin;
				isCarried = true;

				if ( isPlayer( attacker ) && ( attacker.pers["team"] != self.pers["team"] ) ) 
				{
					if ( isdefined( level.flags[index].carrier.attackerData ) ) 
					{	
						if ( level.flags[index].carrier != attacker ) 
						{
							if ( isdefined( level.flags[index].carrier.attackerData[self.clientid] ) ) 
							{
								scoreevents::processScoreEvent( "rescue_flag_carrier", attacker, undefined, weapon );
							}
						}
					}
				}
			}
			else 
			{
				flagOrigin = level.flags[index].curorigin;
				isCarried = false;
			}
				
			dist = Distance2d(self.origin, flagOrigin);
			if ( dist < level.defaultOffenseRadius )
			{
				inFlagZone = true;
				if ( level.flags[index].ownerteam == attacker.pers["team"] )
					defendedFlag = true;
				else
					offendedFlag = true;					
			}
			dist = Distance2d(attacker.origin, flagOrigin);
			if ( dist < level.defaultOffenseRadius )
			{
				inFlagZone = true;
				if ( level.flags[index].ownerteam == attacker.pers["team"] )
					defendedFlag = true;
				else
					offendedFlag = true;					
			}
			
			
			if ( inFlagZone && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
			{	
				if ( defendedFlag )
				{
					attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
	
					if ( isdefined( self.isFlagCarrier ) && self.isFlagCarrier )
					{
						scoreevents::processScoreEvent( "kill_flag_carrier", attacker, undefined, weapon );
					}
					else
					{
						scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, weapon );
					}
	
					self RecordKillModifier("assaulting");
				}
				if ( offendedFlag )
				{
					attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
					if ( isCarried == true ) 
					{
						if ( isdefined ( flagCarrier ) && attacker == flagCarrier ) 
						{
							scoreevents::processScoreEvent( "killed_enemy_while_carrying_flag", attacker, undefined, weapon );
						}
						else
						{
							scoreevents::processScoreEvent( "defend_flag_carrier", attacker, undefined, weapon );
						}
					}
					else
					{
						scoreevents::processScoreEvent( "killed_defender", attacker, undefined, weapon );
					}
					self RecordKillModifier("defending");
				}
			}
		}
	}

	if ( !isdefined( self.isFlagCarrier ) || !self.isFlagCarrier )
		return;

	if ( isdefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		if ( isdefined ( self.flagCarried ) ) 
		{
			for ( index = 0; index < level.flags.size; index++ )
			{
				currentFlag = level.flags[index];
				if ( currentFlag.ownerteam == self.team ) 
				{
					if ( currentFlag.curOrigin == currentFlag.trigger.baseOrigin )
					{
						dist = Distance2d(self.origin, currentFlag.curOrigin );
						if ( dist < level.defaultOffenseRadius )
						{	
							self.flagCarried.carrierKilledBy = attacker;
							break;
						}
					}
				}
			}
		}
		
		attacker RecordGameEvent("kill_carrier");	
		self RecordKillModifier("carrying");
	}
}

function createReturnMessageElems()
{
	level.ReturnMessageElems = [];

	level.ReturnMessageElems["allies"]["axis"] = hud::createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["axis"] hud::setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.ReturnMessageElems["allies"]["axis"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["axis"].alpha = 0;
	level.ReturnMessageElems["allies"]["axis"].archived = false;
	level.ReturnMessageElems["allies"]["allies"] = hud::createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["allies"] hud::setPoint( "TOPRIGHT", "TOPRIGHT", 0, 20 );
	level.ReturnMessageElems["allies"]["allies"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["allies"].alpha = 0;
	level.ReturnMessageElems["allies"]["allies"].archived = false;

	level.ReturnMessageElems["axis"]["allies"] = hud::createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["allies"] hud::setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.ReturnMessageElems["axis"]["allies"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["allies"].alpha = 0;
	level.ReturnMessageElems["axis"]["allies"].archived = false;
	level.ReturnMessageElems["axis"]["axis"] = hud::createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["axis"] hud::setPoint( "TOPRIGHT", "TOPRIGHT", 0, 20 );
	level.ReturnMessageElems["axis"]["axis"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["axis"].alpha = 0;
	level.ReturnMessageElems["axis"]["axis"].archived = false;
}

function returnFlagAfterTimeMsg( time )
{
	if ( level.touchReturn || level.idleFlagReturnTime == 0 )
		return;

	self notify("returnFlagAfterTimeMsg");
	self endon("returnFlagAfterTimeMsg");
	
	result = returnFlagHudElems( time );
	
	self removeInfluencers();
	self clearReturnFlagHudElems();
	
	if ( !isdefined( result ) ) // returnFlagHudElems hit an endon
		return;
		
//	self returnFlag();
}

function returnFlagHudElems( time )
{
	self endon("picked_up");
	level endon("game_ended");
	
	ownerteam = self gameobjects::get_owner_team();
	
	assert( !level.ReturnMessageElems["axis"][ownerteam].alpha );
	level.ReturnMessageElems["axis"][ownerteam].alpha = 1;
	level.ReturnMessageElems["axis"][ownerteam] setTimer( time );
	
	assert( !level.ReturnMessageElems["allies"][ownerteam].alpha );
	level.ReturnMessageElems["allies"][ownerteam].alpha = 1;
	level.ReturnMessageElems["allies"][ownerteam] setTimer( time );
	
	if( time <= 0 )
		return false;
	else
		wait time;
	
	return true;
}

function clearReturnFlagHudElems()
{
	ownerteam = self gameobjects::get_owner_team();
	
	level.ReturnMessageElems["allies"][ownerteam].alpha = 0;
	level.ReturnMessageElems["axis"][ownerteam].alpha = 0;
}

function resetFlagBaseEffect()
{
	team = self gameobjects::get_owner_team();
	
	if ( team == "neutral" )
	{
		self.friendlyBaseEffect Hide();
		self.enemyBaseEffect Hide();
		self.neutralBaseEffect Show();
	}
	else
	{
		self.friendlyBaseEffect Show();
		self.enemyBaseEffect Show();
		self.neutralBaseEffect Hide();
	
		otherTeam = util::getOtherTeam( team );
	
		self.friendlyBaseEffect HideFromTeam( otherTeam );
		self.enemyBaseEffect HideFromTeam( team );
	}
}

function turn_on()
{
	if ( level.hardcoreMode )
		return;
		
	self.origin = self.original_origin;
}

function turn_off()
{
	self.origin = ( self.original_origin[0], self.original_origin[1], self.original_origin[2] - 10000);
}

function update_hints()
{
	allied_flag = level.teamFlags["allies"];
	axis_flag = level.teamFlags["axis"];
			
	if ( !level.touchReturn )
		return;

	if ( isdefined(allied_flag.carrier) && axis_flag gameobjects::is_object_away_from_home() )
	{
		level.flagHints["axis"] turn_on();		
	}
	else
	{
		level.flagHints["axis"] turn_off();
	}		
	
	if ( isdefined(axis_flag.carrier) && allied_flag gameobjects::is_object_away_from_home() )
	{
		level.flagHints["allies"] turn_on();		
	}
	else
	{
		level.flagHints["allies"] turn_off();
	}		
}

function claim_trigger( trigger )
{
	self endon("disconnect");
	self ClientClaimTrigger( trigger );
	
	self waittill("drop_object");
	self ClientReleaseTrigger( trigger );
}

function createFlagSpawnInfluencer( entityTeam )
{
	otherteam = util::getOtherTeam(entityTeam);
	team_mask = util::getTeamMask( entityTeam );
	other_team_mask = util::getTeamMask( otherteam );
	
	self.spawn_influencer_friendly = self spawning::create_influencer( "ctf_base_friendly", self.trigger.origin, team_mask );
	self.spawn_influencer_enemy = self spawning::create_influencer( "ctf_base_friendly", self.trigger.origin, other_team_mask );
}

function ctf_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_penalty = globallogic_defaults::default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon );

	if ( ( isdefined( self.isFlagCarrier ) && self.isFlagCarrier ) )
	{
		teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	}
	
	return teamkill_penalty;
}

function ctf_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_score = rank::getScoreInfoValue( "kill" );
	
	if ( ( isdefined( self.isFlagCarrier ) && self.isFlagCarrier ) )
	{
		teamkill_score = teamkill_score * level.teamKillScoreMultiplier;
	}
	
	return int(teamkill_score);
}