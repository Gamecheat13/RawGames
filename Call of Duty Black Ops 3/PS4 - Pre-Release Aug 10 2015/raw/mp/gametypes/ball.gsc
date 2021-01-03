#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\_oob;
#using scripts\shared\killstreaks_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                             

#using scripts\mp\_armor;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\teams\_teams;




 //"p7_mp_uplink_ball"




	




	



	

#precache( "string", "OBJECTIVES_BALL" );
//#precache( "string", "OBJECTIVES_BALL_SCORE" );
#precache( "string", "OBJECTIVES_BALL_HINT" );
#precache( "string", "MP_BALL_OVERTIME_ROUND_1" );
#precache( "string", "MP_BALL_OVERTIME_ROUND_1" );
#precache( "string", "MP_BALL_OVERTIME_ROUND_2_WINNER" );
#precache( "string", "MP_BALL_OVERTIME_ROUND_2_LOSER" );
#precache( "string", "MP_BALL_OVERTIME_ROUND_2_TIE" );
#precache( "string", "MP_BALL_OVERTIME_ROUND_2_TIE" );
#precache( "string", "MPUI_BALL_OVERTIME_FASTEST_CAP_TIME" );
#precache( "string", "MPUI_BALL_OVERTIME_DEFEAT_TIMELIMIT" );
#precache( "string", "MPUI_BALL_OVERTIME_DEFEAT_DID_NOT_DEFEND" );

#precache( "string", "MP_BALL_PICKED_UP" );
#precache( "string", "MP_BALL_DROPPED" );
#precache( "string", "MP_BALL_CAPTURE" );

#precache( "fx", "ui/fx_uplink_ball_trail" );
#precache( "fx", "ui/fx_uplink_ball_vanish" );

#precache( "objective", "ball_ball" );
#precache( "objective", "ball_goal_allies" );
#precache( "objective", "ball_goal_axis" );

/*
	BALL
	
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

		Goal:
		Ball:
*/

function autoexec __init__sytem__() {     system::register("ball",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "allplayers", "ballcarrier" , 1, 1, "int" );
	clientfield::register( "allplayers", "passoption" , 1, 1, "int" );
	clientfield::register( "world", "ball_home" , 1, 1, "int" );
	clientfield::register( "world", "ball_score_allies" , 1, 1, "int" );
	clientfield::register( "world", "ball_score_axis" , 1, 1, "int" );
}

function main()
{
	globallogic::init();
	
	util::registerTimeLimit( 0, 1440 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerRoundSwitch( 0, 9 );
	util::registerNumLives( 0, 100 );
	util::registerRoundScoreLimit( 0, 5000 );
	util::registerScoreLimit( 0, 5000 );
	
	level.scoreRoundWinBased = ( GetGametypeSetting( "cumulativeRoundScores" ) == false );

	level.teamKillPenaltyMultiplier = GetGametypeSetting( "teamKillPenalty" );
	level.teamKillScoreMultiplier = GetGametypeSetting( "teamKillScore" );
	level.enemyObjectivePingTime =  GetGametypeSetting( "objectivePingTime" );
	
 	level.carryScore = GetGametypeSetting( "carryScore" );	
	level.throwScore = GetGametypeSetting( "throwScore" );	
	level.carryArmor = GetGametypeSetting( "carrierArmor" );	
	level.ballCount = GetGametypeSetting( "ballCount" );	
 	level.enemyCarrierVisible = GetGametypeSetting( "enemyCarrierVisible" );
	level.idleFlagReturnTime = GetGametypeSetting( "idleFlagResetTime" );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.clampScoreLimit = false;
	
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onPlayerKilled =&onPlayerKilled;
	level.onRoundSwitch =&onRoundSwitch;
	level.onEndGame =&onEndGame;
	level.onRoundEndGame =&onRoundEndGame;
	level.getTeamKillPenalty =&ball_getTeamKillPenalty;
	level.getTeamKillScore =&ball_getTeamKillScore;
	level.setMatchScoreHUDElemForTeam =&setMatchScoreHUDElemForTeam;
	level.shouldPlayOvertimeRound =&shouldPlayOvertimeRound;

	gameobjects::register_allowed_gameobject( level.gameType );

	globallogic_audio::set_leader_gametype_dialog ( "startUplink", "hcStartUplink", "uplOrders", "uplOrders" );
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "carries", "throws", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "carries", "throws" );
}

function onPrecacheGameType()
{
	game["strings"]["score_limit_reached"] = &"MP_CAP_LIMIT_REACHED";
	
//	game["ball_dropped_sound"] = "mp_war_objective_lost";
//	game["ball_recovered_sound"] = "mp_war_objective_taken";
}


function onStartGameType()
{
	level.useStartSpawns = true;
	level.ballWorldWeapon = GetWeapon( "ball_world" );
	level.passingBallWeapon = GetWeapon( "ball_world_pass" );
	
	if ( !isdefined( game["switchedsides"] ) )
	{
		game["switchedsides"] = false;
	}
	
	setClientNameMode("auto_change");

	if ( level.scoreRoundWinBased )
	{
		globallogic_score::resetTeamScores();
	}

	util::setObjectiveText( "allies", &"OBJECTIVES_BALL" );
	util::setObjectiveText( "axis", &"OBJECTIVES_BALL" );
	
	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_BALL" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_BALL" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_BALL_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_BALL_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_BALL_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_BALL_HINT" );

	if ( isdefined( game["overtime_round"] ) )
	{
		// This is only necessary when cumulativeRoundScores is on so that the game doesn't immediately end due to scorelimit being set to 1 in OT
		[[level._setTeamScore]]( "allies", 0 );
		[[level._setTeamScore]]( "axis", 0 );
		
		if ( isdefined( game["ball_overtime_score_to_beat"] ) )
		{
			util::registerScoreLimit( game["ball_overtime_score_to_beat"], game["ball_overtime_score_to_beat"] );
		}
		else
		{
			util::registerScoreLimit( 1, 1 );
		}
		
		if ( isdefined( game["ball_overtime_time_to_beat"] ) )
		{
			util::registerTimeLimit( game["ball_overtime_time_to_beat"] / 60000, game["ball_overtime_time_to_beat"] / 60000 );
		}
		
		if ( game["overtime_round"] == 1 )
		{
			util::setObjectiveHintText( "allies", &"MP_BALL_OVERTIME_ROUND_1" );
			util::setObjectiveHintText( "axis", &"MP_BALL_OVERTIME_ROUND_1" );
		}
		else if ( isdefined( game["ball_overtime_first_winner"] ) )
		{
			level.onTimeLimit = &ballOvertimeRound2_onTimeLimit;
			game["teamSuddenDeath"][game["ball_overtime_first_winner"]] = true;
			util::setObjectiveHintText( game["ball_overtime_first_winner"], &"MP_BALL_OVERTIME_ROUND_2_WINNER" );
			util::setObjectiveHintText( util::getOtherTeam( game["ball_overtime_first_winner"] ), &"MP_BALL_OVERTIME_ROUND_2_LOSER" );
		}
		else
		{
			level.onTimeLimit = &ballOvertimeRound2_onTimeLimit;
			util::setObjectiveHintText( "allies", &"MP_BALL_OVERTIME_ROUND_2_TIE" );
			util::setObjectiveHintText( "axis", &"MP_BALL_OVERTIME_ROUND_2_TIE" );
		}
	}
	
	// Spawn Points
	
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
	
	level thread setup_objectives();
}

function ballOvertimeRound2_onTimeLimit()
{
	winner = undefined;
	
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			if( game["teamSuddenDeath"][team] )
			{
				winner = team;
				break;
			}
		}
		
		if( !isDefined( winner ) )
		{
			winner = globallogic::determineTeamWinnerByGameStat( "teamScores" );
		}

		globallogic_utils::logTeamWinString( "time limit", winner );
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();

		/#
		if ( isdefined( winner ) )
			print( "time limit, win: " + winner.name );
		else
			print( "time limit, tie" );
		#/
	}
	
	// i think these two lines are obsolete
	//makeDvarServerInfo( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	SetDvar( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	
	thread globallogic::endGame( winner, game["strings"]["time_limit_reached"] );
}


function onSpawnPlayer(predictedSpawn)
{
	self.isBallCarrier = false;
	self.ballCarried = undefined;
	self clientfield::set( "ctf_flag_carrier", 0 );	
	
	spawning::onSpawnPlayer(predictedSpawn);
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( isdefined( self.carryObject ) )
	{
		otherTeam = util::getOtherTeam( self.team );
		
		if ( isdefined( attacker ) && IsPlayer( attacker ) && attacker != self )
		{
			scoreevents::processScoreEvent( "kill_ball_carrier", attacker, undefined, weapon );
			
			// TODO: Add ball # to objectiveId
			globallogic_audio::leader_dialog( "uplWeDrop", self.team, undefined, "uplink_ball" );
			globallogic_audio::leader_dialog( "uplTheyDrop", otherTeam, undefined, "uplink_ball" );
			
			globallogic_audio::play_2d_on_team( "mpl_balldrop_sting_friend", self.team );
			globallogic_audio::play_2d_on_team( "mpl_balldrop_sting_enemy", otherTeam );
			
			level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_DROPPED", self, self.team );
			level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_DROPPED", self, otherTeam );
		}
	}
	else if ( isdefined( attacker.carryObject ) )
	{
		scoreevents::processScoreEvent( "kill_enemy_while_carrying_ball", attacker, undefined, weapon  );
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
	if ( isdefined( game["overtime_round"] ) && isdefined( winningTeam ) && ( winningTeam != "tie" ) )
	{
		if ( game["overtime_round"] == 1 )
		{
			game["ball_overtime_first_winner"] = winningTeam;
			game["ball_overtime_score_to_beat"] = globallogic_utils::GetTeamScoreForRound( winningTeam );
			game["ball_overtime_time_to_beat"] = globallogic_utils::getTimePassed();
		}
		else
		{
			game["ball_overtime_second_winner"] = winningTeam;
			game["ball_overtime_best_score"] = globallogic_utils::GetTeamScoreForRound( winningTeam );
			game["ball_overtime_best_time"] = globallogic_utils::getTimePassed();
		}
	}
}

function updateTeamScoreByRoundsWon()
{
	if ( level.scoreRoundWinBased ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	}
}


function onRoundEndGame( winningTeam )
{
	if ( isdefined( game["overtime_round"] ) )
	{
		if ( isdefined( game["ball_overtime_first_winner"] ) )
		{
			if ( !isdefined( winningTeam ) || ( winningTeam == "tie" ) )
			{
				winningTeam = game["ball_overtime_first_winner"];
			}
			
			if ( game["ball_overtime_first_winner"] == winningTeam )
			{
				level.endVictoryReasonText = &"MPUI_BALL_OVERTIME_FASTEST_CAP_TIME";
				level.endDefeatReasonText = &"MPUI_BALL_OVERTIME_DEFEAT_TIMELIMIT";
			}
			else
			{
				level.endVictoryReasonText = &"MPUI_BALL_OVERTIME_FASTEST_CAP_TIME";
				level.endDefeatReasonText = &"MPUI_BALL_OVERTIME_DEFEAT_DID_NOT_DEFEND";
			}			
		}
		else if ( !isdefined( winningTeam ) || ( winningTeam == "tie" ) )
		{
			updateTeamScoreByRoundsWon();
			return "tie";
		}
		
		if ( level.scoreRoundWinBased ) 
		{
			foreach( team in level.teams )
			{
				score = game["roundswon"][team];
				if ( team === winningTeam )
				{
					score++;
				}
				[[level._setTeamScore]]( team, score );
			}			
		}
		return winningTeam;
	}
	
	if ( level.scoreRoundWinBased ) 
	{
		updateTeamScoreByRoundsWon();
	
		winner = globallogic::determineTeamWinnerByGameStat( "roundswon" );
	}
	else
	{
		winner = globallogic::determineTeamWinnerByTeamScore();
	}
	
	return winner;
}


function setMatchScoreHUDElemForTeam()
{
		self setText( &"" );
}

function shouldPlayOvertimeRound()
{
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

function ball_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_penalty = globallogic_defaults::default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon );

	if ( ( isdefined( self.isBallCarrier ) && self.isBallCarrier ) )
	{
		teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	}
	
	return teamkill_penalty;
}

function ball_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_score = rank::getScoreInfoValue( "kill" );
	
	if ( ( isdefined( self.isBallCarrier ) && self.isBallCarrier ) )
	{
		teamkill_score = teamkill_score * level.teamKillScoreMultiplier;
	}
	
	return int(teamkill_score);
}

//////////////////////

function setup_objectives()
{
	level.ball_goals = [];
	level.ball_starts = [];
	level.balls = [];
	
	level.ball_starts = getEntArray( "ball_start" ,"targetname");
	
	foreach( ball_start in level.ball_starts )
	{
		level.balls[level.balls.size] = spawn_ball( ball_start );
	}
	
	foreach( team in level.teams )
	{
		if(	!game["switchedsides"] )
		{
			trigger = GetEnt( "ball_goal_" + team, "targetname" );
		}
		else
		{
			trigger = GetEnt( "ball_goal_" + util::getOtherTeam( team ), "targetname" );
		}
		
		level.ball_goals[team] = setup_goal( trigger, team );
	}
	
	

	
/*	
 * 
 * 
	numBalls = GetDvarInt("scr_ball_num_balls", 1);
	ball_create_start( numBalls );
	

	for(i=0; i<numBalls && i<level.ball_starts.size; i++)
	{
		spawn_ball(i);
	}
	
	ball_goal_useObject();
*/

}

// Goals
//========================================

function setup_goal( trigger, team )
{	
	// Goal Object
	useObj = gameobjects::create_use_object( team, trigger, [], ( 0, 0, trigger.height * 0.5 ), istring("ball_goal_"+team) );
	useObj gameobjects::set_visible_team( "any" );
	useObj gameobjects::set_model_visibility( true );
	useObj gameobjects::allow_use( "enemy" );
	useObj gameobjects::set_use_time( 0 );
	useObj gameobjects::set_key_object( level.balls[0] );  // need to get array of key objects working
	
	useObj.canUseObj = &can_use_goal;
	useObj.onUse = &on_use_goal;

	useObj.ball_in_goal = false;
	useObj.radiusSq = trigger.radius * trigger.radius;
	useObj.center = trigger.origin + ( 0, 0, trigger.height * 0.5 );

	// TODO Killcam
	//useObj.killcamEnt = spawn( "script_model", goal.origin );
	
	return useObj;
}

function can_use_goal( player )
{	
	return !self.ball_in_goal;
}

function on_use_goal(player)
{
	if ( !IsDefined(player) || !IsDefined(player.carryObject) )
		return;

	if ( isDefined( player.carryObject.scoreFrozenUntil ) && player.carryObject.scoreFrozenUntil > getTime() )
		return;
	
	self play_goal_score_fx();
	
	player.carryObject.scoreFrozenUntil = getTime() + 10000;

	//player maps\mp\_events::touchdownEvent(score); TODO Score event
	ball_check_assist( player, true );
	
	team = self.team;
	otherTeam = util::getOtherTeam( team );

	// TODO: Ball ID
	globallogic_audio::flush_objective_dialog( "uplink_ball" );
	globallogic_audio::leader_dialog( "uplWeUplink", otherTeam );
	globallogic_audio::leader_dialog( "uplTheyUplink", team );
	
	globallogic_audio::play_2d_on_team( "mpl_ballcapture_sting_friend", otherTeam );
    globallogic_audio::play_2d_on_team( "mpl_ballcapture_sting_enemy", team );
    
	level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_CAPTURE", player, team );
	level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_CAPTURE", player, otherTeam );
    
	if( should_record_final_score_cam( otherTeam,  level.carryScore ) )
	{
//		killcamentity = self.goal.killcamEnt;
//		killcamentityindex = killcamentity GetEntityNumber();
//		killcamentitystarttime = killcamentity.birthtime;
//		if ( !IsDefined( killcamentitystarttime ) )
//		{
//			killcamentitystarttime = 0;
//		}
//		player.deathTime = GetTime();
		//maps\mp\gametypes\_damage::recordFinalKillCam( 5.0, player, player, player GetEntityNumber(), killcamentityindex, killcamentitystarttime, "none", 0, 0, undefined, "score" );	 TODO Killcam
	}
	
	//ball_play_score_fx(self.goal); -- TODO FX
	
	if(IsDefined(player.shoot_charge_bar))
	{
		player.shoot_charge_bar.inUse = false;
	}
	
	ball = player.carryObject;
	ball.lastCarrierScored = true;
	
	player gameobjects::take_carry_weapon( ball.carryWeapon );
	ball ball_set_dropped( true );
	ball thread upload_ball( self );
	
	if( isdefined(player.pers["carries"]) )
	{
		player.pers["carries"]++;
		player.carries = player.pers["carries"];
	}
	
	player AddPlayerStatWithGameType( "CARRIES", 1 );
	scoreevents::processScoreEvent( "ball_capture_carry", player );
	ball_give_score( otherTeam, level.carryScore );
}

// Balls
//========================================

function spawn_ball( trigger )
{
	visuals = [];
	visuals[0] = spawn("script_model", trigger.origin );
	visuals[0] SetModel( "wpn_t7_uplink_ball_world" );
	visuals[0] notsolid();
	
	trigger EnableLinkTo();
	trigger LinkTo( visuals[0] );
	trigger.no_moving_platfrom_unlink = true;
	
	ballObj = gameobjects::create_carry_object( "neutral", trigger, visuals, (0,0,0), istring("ball_ball"), "mpl_hit_alert_ballholder" );
	ballObj gameobjects::allow_carry( "any" );
	ballObj gameobjects::set_visible_team( "any" );
	ballObj gameobjects::set_drop_offset( 8 );  // the radius of the ball model so it looks like its on the ground

	ballObj.objectiveOnVisuals = true;
	ballObj.allowWeapons = false;
	ballObj.carryWeapon = GetWeapon( "ball" );
	ballObj.keepCarryWeapon = true;
	ballObj.waterBadTrigger = false;
	ballObj.disallowRemoteControl = true;
	//ballObj.requiresLOS = true;	I don't think this does anything
	
	ballObj gameobjects::update_objective();
	
	ballObj.canUseObject = &can_use_ball;
	ballObj.onPickup = &on_pickup_ball;
	ballObj.setDropped = &ball_set_dropped;
	ballObj.onReset = &on_reset_ball;
	ballObj.carryWeaponThink = &carry_think_ball;

	ballObj.in_goal = false;	
	ballObj.lastCarrierScored = false;
	ballObj.lastCarrierTeam = "neutral";
	
	if ( level.enemyCarrierVisible == 2 )
	{
		ballObj.objIDPingFriendly = true;
	}

	if ( level.idleFlagReturnTime > 0 )
	{
		ballObj.autoResetTime = level.idleFlagReturnTime;
	}
	else
	{
		ballObj.autoResetTime = undefined;
	}		

	PlayFXOnTag( "ui/fx_uplink_ball_trail", ballObj.visuals[0], "tag_origin" );
	
	return ballObj;
}

// Ball Events
//========================================

function can_use_ball(player)
{
	if(!isDefined(player))
		return false;
	
	if ( IsDefined(self.dropTime) && self.dropTime >= GetTime() )
		return false;
	
	if ( player IsMeleeing() )
		return false;
	
	if ( player isCarryingTurret() )
		return false;
	
	currentWeapon = player GetCurrentWeapon();
	if(isDefined(currentWeapon))
	{
		if( !valid_ball_pickup_weapon( currentWeapon ) )
			return false;
	}
	
	nextWeapon = player.changingWeapon;
	if(IsDefined(nextWeapon) && player IsSwitchingWeapons() )
	{
		if( !valid_ball_pickup_weapon( nextWeapon ) )
			return false;
	}
	
	if ( player player_no_pickup_time() )
		return false;

	ball = self.visuals[0];
	thresh = 15;
	dist2 = Distance2DSquared( ball.origin, player.origin );
	if( dist2 < thresh * thresh )
		return true;
	
	ball = self.visuals[0];
	
	start = player getEye();
	
	end = ( self.curorigin[0], self.curorigin[1], self.curorigin[2] + 5 );
	if ( isdefined( self.carrier ) && isPlayer( self.carrier  ) )
	{ 
		end = self.carrier getEye();
	}

	if ( !SightTracePassed( end, start, false, ball ) && !SightTracePassed( end, player.origin, false, ball ) )
	{
		return false;
	}

	return true;
}

function on_pickup_ball(player)
{
	self gameobjects::set_flags( 0 );

	level.useStartSpawns = false;
	
	level clientfield::set( "ball_home", 0 );

	//Physics objects get linked to entities if they come to rest on them
	linkedParent = self.visuals[0] GetLinkedEnt();
	if(IsDefined(linkedParent))
		self.visuals[0] unlink();

	player resetflashback();
	//self.current_start.in_use = false;
	
	pass = false;
	if(IsDefined(self.projectile))
	{
		pass = true;
		self.projectile Delete();
	}
	
	if( pass )
	{
		if( self.lastCarrierTeam == player.team )
		{
			if ( self.lastCarrier != player )
			{
			player.passTime = GetTime();
			player.passPlayer = self.lastcarrier;
				
				// TODO: Add ball # to objectiveId
				globallogic_audio::leader_dialog( "uplTransferred", player.team, undefined, "uplink_ball" );
			}
		}
		else
		{
			//player maps\mp\_events::interceptionEvent(); -- TODO EVENT
		}
	}
	
	otherTeam = util::getOtherTeam( player.team );
	
	if( self.lastCarrierTeam != player.team )
	{		
		// TODO: Add ball # to objectiveId
		globallogic_audio::leader_dialog( "uplWeTake", player.team, undefined, "uplink_ball" );
		globallogic_audio::leader_dialog( "uplTheyTake", otherTeam, undefined, "uplink_ball" );
	}

	globallogic_audio::play_2d_on_team( "mpl_ballget_sting_friend", player.team );
	globallogic_audio::play_2d_on_team( "mpl_ballget_sting_enemy", otherTeam );
	
	level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_PICKED_UP", player, player.team );
	level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_PICKED_UP", player, otherTeam );
	
	//self ball_fx_stop(); -- TODO FX
	
	self.lastCarrierScored = false;
	self.lastcarrier = player;
	self.lastCarrierTeam = player.team;
	
	self gameobjects::set_owner_team( player.team );

	player GiveWeapon( GetWeapon( "ball" ));
	
	player.ballDropDelay = GetDvarInt( "scr_ball_water_drop_delay", 10 );	//server frames to wait while underwater before dropping the ball
	player.objective = 1;
	
	player.hasPerkSprintFire = player HasPerk("specialty_sprintfire" );
	player setPerk("specialty_sprintfire" );
	
	player disableUsability();

	player clientfield::set( "ballcarrier", 1 );
	
	if ( level.carryArmor > 0 )
		player thread armor::setLightArmor(level.carryArmor);
	else
		player thread armor::unsetLightArmor();

	player thread player_update_pass_target(self);
}

function ball_carrier_cleanup( )
{
	self gameobjects::set_owner_team( "neutral" );

	if ( isdefined(self.carrier) )
	{
		self.carrier clientfield::set( "ballcarrier", 0 );
		self.carrier.ballDropDelay = undefined;
		self.carrier.noPickupTime = GetTime() + 500;
		
		self.carrier player_clear_pass_target();
		self.carrier notify("cancel_update_pass_target");
		
		self.carrier thread armor::unsetLightArmor();
	
		if ( !self.carrier.hasPerkSprintFire )
		{
			self.carrier unsetPerk( "specialty_sprintfire" );
		}
		
		self.carrier enableUsability();
		
		self.carrier SetBallPassAllowed(false);
		self.carrier.objective = 0;
	}
}

function ball_set_dropped( skip_physics )
{	
	if(!isdefined(skip_physics))skip_physics=false;
	
	self.isResetting = true;
	self.dropTime = GetTime();
	
	self notify ( "dropped" );

	dropAngles = (0,0,0);

	carrier = self.carrier;
	if(IsDefined(carrier) && carrier.team != "spectator")
	{
		dropOrigin = carrier.origin;
		dropAngles = carrier.angles;
	}
	else
	{
		dropOrigin = self.safeOrigin;
	}
	dropOrigin += (0,0,40);
	
	self ball_carrier_cleanup();
	self gameobjects::clear_carrier();
	self gameobjects::set_position( dropOrigin, dropAngles );
	self gameobjects::update_icons_and_objective();
	self thread gameobjects::pickup_timeout( dropOrigin[2], dropOrigin[2] - 40);

	self.isResetting = false;
	
	if(!skip_physics)
	{
		angles = ( 0, dropAngles[1], 0 );
		forward = AnglesToForward( angles );
		velocity = 	forward * 200 + (0,0,80);
		ball_physics_launch(velocity);
	}

	return true;
}

function on_reset_ball( prev_origin )
{
	//self ball_assign_random_start();
	
	visual = self.visuals[0];
	
	//Physics objects get linked to entities if they come to rest on them
	linkedParent = visual GetLinkedEnt();
	if( IsDefined(linkedParent) )
	{
		visual unlink();
	}
	
	if( IsDefined( self.projectile ) )
	{
		self.projectile Delete();
	}

	if( !self gameobjects::get_flags( 1 ) )
	{
		PlayFx( "ui/fx_uplink_ball_vanish", prev_origin );
		self play_return_vo();
	}
	self.lastCarrierTeam = "none";
	self thread download_ball();
}

// Ball Functions
//========================================

function reset_ball()
{
	self thread gameobjects::return_home();
}

function upload_ball( goal )
{
	self notify( "score_event" );
	
	self.in_goal = true;
	goal.ball_in_goal = true;	
		
	if(IsDefined(self.projectile))
	{
		self.projectile Delete();
	}
	
	self gameobjects::allow_carry( "none" );
	
	move_to_center_time = .4;
	move_up_time = 1.2;
	rotate_time = 1.0;
	
	in_enemyGoal_time = move_to_center_time + rotate_time;
	total_time = in_enemyGoal_time + move_up_time;
	
	self gameobjects::set_flags( 1 );

	visual = self.visuals[0];
	
	visual MoveTo( goal.center, move_to_center_time, 0, move_to_center_time);
	visual RotateVelocity( (1080,1080,0), total_time, total_time, 0);
	
	wait in_enemyGoal_time;
	
	goal.ball_in_goal = false;
	
	visual MoveZ(4000, move_up_time, move_up_time*.1, 0);
	
	wait move_up_time;
	
	self thread gameobjects::return_home();
}

function download_ball()
{
	self endon ( "pickup_object" );
	
	self gameobjects::allow_carry( "any" );
	self gameobjects::set_owner_team( "neutral" );	
	self gameobjects::set_flags( 2 );

	self.in_goal = false;
	
	visual = self.visuals[0];
	
	visual.origin = visual.baseOrigin + (0,0,4000);
	visual DontInterpolate();
	
	fall_time = 3;
	visual MoveTo( visual.baseOrigin, fall_time, 0, fall_time);
	
	visual RotateVelocity( (0,720,0), fall_time, 0, fall_time);
	
/* TODO: Team player card ?
	if( !self.lastCarrierScored && IsDefined( team ) && IsDefined( otherTeam ) )
	{
		if( IsDefined(self.lastcarrier) )
		{
			thread teamPlayerCardSplash( "callout_ballreset", self.lastCarrier );
		}
	}
*/

	wait( fall_time );
	
	self gameobjects::set_flags( 0 );
	level clientfield::set( "ball_home", 1 ); 

	//PlayFX( level._effect["ball_download_end"], self.current_start.ground_origin ); - TODO FX
	
	PlayFXOnTag( "ui/fx_uplink_ball_trail", visual, "tag_origin" );
	
	self thread ball_download_fx(visual, fall_time);
}


// Ball Carry Watch
//========================================

function carry_think_ball()
{
	self endon("disconnect");
	
	self thread ball_pass_watch();
	self thread ball_shoot_watch();
}
	
function ball_pass_watch()
{
	level endon ( "game_ended" );

	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	while( 1 )
	{
		self waittill( "ball_pass", weapon );
		
		if ( !isDefined(self.pass_target) )
		{
			self IPrintLnBold( "No Pass Target" );
			continue;
		}
		break;
	}

	if( isDefined(self.carryObject))
	{
		self thread ball_pass_or_throw_active();
		pass_target = self.pass_target;
		last_target_origin = self.pass_target.origin;
		wait .15;
		
		if ( IsDefined(self.pass_target) )
			pass_target = self.pass_target;
		
		self.carryObject thread ball_pass_projectile(self, pass_target, last_target_origin);
	}
}

function ball_shoot_watch()
{
	level endon ( "game_ended" );

	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	extra_pitch 	= GetDvarFloat("scr_ball_shoot_extra_pitch", 0);
	force			= GetDvarFloat("scr_ball_shoot_force", 900 );
	
	while(1)
	{
		self waittill("weapon_fired", weapon);
		
		if( weapon != GetWeapon( "ball" ) )
		{
			continue;
		}
		
		break;
	}
		
	if ( IsDefined( self.carryObject ) )
	{
		playerAngles = self GetPlayerAngles();
		playerAngles += (extra_pitch,0,0);
		playerAngles = (math::Clamp(playerAngles[0], -85, 85), playerAngles[1], playerAngles[2]);
		dir = AnglesToForward(playerAngles);
		self thread ball_pass_or_throw_active();
		self thread ball_check_pass_kill_pickup( self.carryObject );
		self.carryObject ball_create_killcam_ent();
		self.carryObject thread ball_physics_launch_drop(dir*force, self);
	}
}

// Ball Pickup Helpers
//========================================

function valid_ball_pickup_weapon( weapon )
{
	if( weapon == level.weaponNone )
		return false;
	
	if( weapon == GetWeapon( "ball" ) )
		return false;
	
	if( killstreaks::is_killstreak_weapon( weapon ) )
		return false;
	
	return true;
}

function player_no_pickup_time()
{
	return isDefined(self.noPickupTime) && self.noPickupTime > GetTime();
}


//self == player
function watchUnderwater( trigger )
{
	self endon ("death" );
	self endon ("disconnect" );
	
	while( 1 )
	{
		if( self isplayerunderwater() )
		{
			foreach(ball in level.balls)
			{
				if( isDefined(ball.carrier) && ball.carrier == self )
				{
					ball gameobjects::set_dropped();
					return;
				}
			}
		}
		
		self.ballDropDelay = undefined;
		{wait(.05);};
	}
}

function ball_physics_launch_drop(force, droppingPlayer)
{
	ball_set_dropped(true);
	ball_physics_launch(force, droppingPlayer);
}

function ball_check_pass_kill_pickup( carryObj )
{
	self endon("death");
	self endon("disconnect");
	
	carryObj endon("reset");
	
	timer = spawnStruct();
	timer endon("timer_done");
	
	timer thread timer_run(1.5);	
	carryObj waittill("pickup_object");
	timer timer_cancel();
	
	if(!IsDefined(carryObj.carrier) || carryObj.carrier.team == self.team)
	{
		return;
	}
	
	carryObj.carrier endon("disconnect");
	
	timer thread timer_run(5);
	carryObj.carrier waittill("death", attacker);
	timer timer_cancel();
	
	if(!IsDefined(attacker) || attacker != self)
	{
		return;
	}
	
	timer thread timer_run(2);
	carryObj waittill("pickup_object");
	timer timer_cancel();
	
//	if( IsDefined(carryObj.carrier) && carryObj.carrier == self) TODO Event
//		self maps\mp\_events::passKillPickupEvent();
}

function timer_run(time)
{
	self endon("cancel_timer");
	wait time;
	self notify("timer_done");
}

function timer_cancel()
{
	self notify("cancel_timer");
}


function ball_pass_projectile(passer, target, last_target_origin)
{
	ball_set_dropped(true);
	
	if(IsDefined(target))
	{
		last_target_origin = target.origin;
	}
	
	offset = (0,0,60);
	
	playerAngles = passer GetPlayerAngles();
	playerAngles = (0, playerAngles[1], 0 );
	dir = AnglesToForward(playerAngles);
	origin = self.visuals[0].origin + dir * 50;
	
	self gameobjects::set_position( origin, playerAngles );

	pass_dir = VectorNormalize((last_target_origin+offset) - self.visuals[0].origin);
	//pass_dir = ( pass_dir[0], pass_dir[1], 0 );
	
	pass_vel = pass_dir * 850;
	
	
	self.projectile = passer MagicMissile( level.passingBallWeapon, self.visuals[0].origin, pass_vel  );
	//self.projectile = passer MagicGrenadeManualPlayer( self.visuals[0].origin, pass_vel, level.ballWorldWeapon, 30 );
	if(IsDefined(target))
	{
		self.projectile ballsettarget( target, offset );
	}
	self.visuals[0] LinkTo(self.projectile);
	self gameobjects::ghost_visuals();
	//self ball_dont_interpolate(); TODO FX
	
	self ball_create_killcam_ent();
	
	self ball_clear_contents(); //Prevent magic grenade from hitting the ball visuals
	
	self thread ball_on_projectile_hit_client();
	self thread ball_on_projectile_death();
	self thread ball_watch_touch_enemy_goal();
}

function ball_on_projectile_death()
{
	self.projectile waittill("death");
	ball = self.visuals[0];
	if(!IsDefined(self.carrier) && !self.in_goal)
	{
		// There's a bug where the ball will be reset during the same frame that the above trigger is notified,
		// but the notification is processed after the reset. This turns physics back on, overrides the MoveTo,
		// and causes the ball to bounce really hard in an arbitrary direction.  
		// This hack is a way to test whether the ball was just reset or not.  If it was just reset, don't fake bounce.  TODO THIS IS FROM AW - WTF DO WE NEED THIS?
		if ( ball.origin != ball.baseOrigin + (0, 0, 4000) )
		{
			self ball_physics_launch((0,0,10));
		}
	}
	self ball_restore_contents();
	
	ball notify("pass_end");
}

function ball_restore_contents()
{
	if(IsDefined(self.visuals[0].old_contents))
	{
		self.visuals[0] SetContents(self.visuals[0].old_contents);
		self.visuals[0].old_contents = undefined;
	}	
}

function ball_on_projectile_hit_client()
{
	self endon("pass_end");
	self.projectile waittill( "projectile_impact_player", player );
	self.trigger notify( "trigger", player );
}

function ball_clear_contents()
{
	self.visuals[0].old_contents = self.visuals[0] SetContents(0);
}

function ball_create_killcam_ent()
{
	if(IsDefined(self.killcamEnt))
		self.killcamEnt Delete();
	self.killcamEnt = spawn( "script_model", self.visuals[0].origin );
	self.killcamEnt linkTo(self.visuals[0]);
	self.killcamEnt SetContents(0);
	//self.killcamEnt SetScriptMoverKillCam( "explosive" ); TODO KILLCAM
}
	
function ball_pass_or_throw_active()
{
	self endon("death");
	self endon("disconnect");
	
	self.pass_or_throw_active = true;
	
	self AllowMelee( false );
	while( GetWeapon( "ball" ) == self GetCurrentWeapon() )
	{
		{wait(.05);};
	}
	
	self AllowMelee( true );
	self.pass_or_throw_active = false;
}

function ball_download_fx(ball_model, waitTime)
{
//	PlayFXOnTag( level._effect["ball_download"], ball_model, "tag_origin");	- TODO FX
//	
//	self waittill_notify_or_timeout("pickup_object", waitTime);
//	
//	StopFXOnTag( level._effect["ball_download"], ball_model, "tag_origin");

	// bit of a hack, but this seems to be the most reliable place to put this...
	self.scoreFrozenUntil = 0;
}


function ball_assign_random_start()
{	
	new_start = undefined;
	
	rand_starts = array::randomize( level.ball_starts );
	foreach(start in rand_starts)
	{
		if(start.in_use)
			continue;
		
		new_start = start;
		break;
	}

	if(!isDefined(new_start))
		return;
	
	ball_assign_start(new_start);
}

function ball_assign_start(start)
{
	foreach(vis in self.visuals)
	{
		vis.baseOrigin = start.origin;
	}
	
	self.trigger.baseOrigin = start.origin;
	
	self.current_start = start;
	start.in_use = true;
}

function ball_physics_launch(force, droppingPlayer)
{
	visuals = self.visuals[0];

	visuals.origin_prev = undefined;
	
	origin = visuals.origin;
	owner = visuals;
	
	if( isDefined( droppingPlayer ) )
	{
		owner = droppingPlayer;
		
		origin = droppingPlayer getweaponmuzzlepoint();
		right = AnglesToRight( force );
		origin = origin + ( right[0], right[1], 0 ) * 7;
		startPos = origin;// + ( 0, 0, 20 );
		delta = VectorNormalize(force) * 80;
		
		///#sphere( startPos, 5, ( 0, 0, 1 ), 1, true, 10, 200 );#/
		
		size = 5;
		trace = physicstrace( startPos, startPos + delta, ( -size, -size, -size ), ( size, size, size ), droppingPlayer, (1 << 0) );
		
		if( trace["fraction"] < 1 )
		{
			t = 0.7 * trace["fraction"];
			self gameobjects::set_position( startPos + delta * t, visuals.angles );
		}
		else 
		{
			self gameobjects::set_position( trace["position"], visuals.angles );
		}
	}
	
	//self ball_fx_start(); -- TODO FX
	
	grenade = owner MagicMissile( level.ballWorldWeapon, visuals.origin, force  );
	visuals linkto( grenade );
	self gameobjects::ghost_visuals();
	self.projectile = grenade;
	
	///#sphere( visuals.origin, 5, ( 1, 0, 0 ), 1, true, 10, 200 );#/
	visuals DontInterpolate(); // This triggers teleport to avoid interpolation from the previous position. 

	self thread ball_physics_out_of_level();
	self thread ball_physics_timeout( droppingPlayer );
	self thread ball_watch_touch_enemy_goal();
	self thread ball_physics_touch_cant_pickup_player(droppingPlayer);
	self thread ball_check_oob();
}

function ball_check_oob()
{
	self endon ( "reset" );
	self endon ( "pickup_object" );
	
	visual = self.visuals[0];
	
	while( 1 )
	{
		if( visual oob::IsTouchingAnyOOBTrigger() || self gameobjects::should_be_reset( visual.origin[2], visual.origin[2] + 10, true ) )
		{
			self reset_ball();
			return;
		}

		{wait(.05);};		
	}
}


function ball_physics_touch_cant_pickup_player(droppingPlayer)
{
	self endon ( "reset" );
	self endon ( "pickup_object" );
	
	ball = self.visuals[0];
	trigger = self.trigger;

	while(1)
	{
		trigger waittill("trigger", player);
		//Dont stop on the throwing player
		if ( IsDefined(droppingPlayer) && droppingPlayer == player && player player_no_pickup_time() )
		{
			continue;
		}
		
		if ( self.dropTime >= GetTime()  )
		{
			continue;
		}
		
		// There's a bug where the ball will be reset during the same frame that the above trigger is notified,
		// but the notification is processed after the reset. This turns physics back on, overrides the MoveTo,
		// and causes the ball to bounce really hard in an arbitrary direction.  
		// This hack is a way to test whether the ball was just reset or not.  If it was just reset, don't fake bounce.		-- TODO - WTF
		if ( ball.origin == ball.baseOrigin + (0, 0, 4000) )
		{
			continue;
		}
		
		if(	!can_use_ball( player ) && ( self.dropTime + 200 < GetTime() ) )
		{
			//self thread ball_physics_fake_bounce();
		}
	}
}

function ball_physics_fake_bounce()
{
	ball = self.visuals[0];						//-- TODO Since we can use the physics, we need to kick the ball by doing another magic grenade, or apply new movement to existing projectile
												// Test this existing projectile and then do stuff with it
	vel = ball GetVelocity();
	bounceForce = Length(vel)/10;
	bounceDir = -1*VectorNormalize(vel);
	
	//ball PhysicsStop();
	//ball PhysicsLaunch(ball.origin, bounceDir*bounceForce);
}


function ball_watch_touch_enemy_goal( )
{
	self endon ( "reset" );
	self endon ( "pickup_object" );
	
	enemyGoal = level.ball_goals[util::getotherteam( self.lastCarrierTeam )];
	
	while(1)
	{
		if ( !enemyGoal can_use_goal() )
		{
			{wait(.05);};
			continue;	
		}

		ballVisual = self.visuals[0];
		
		distSq = DistanceSquared( ballVisual.origin, enemyGoal.center );
		if ( distSq <= enemyGoal.radiusSq )
		{
			self thread ball_touched_goal( enemyGoal );
			return;
		}
		
		if ( isdefined( ballVisual.origin_prev ) )
		{
			result = line_intersect_sphere( ballVisual.origin_prev, ballVisual.origin, enemyGoal.center, enemyGoal.trigger.radius );
			if ( result )
			{
				self thread ball_touched_goal( enemyGoal );
				return;
			}
			
		}
		
		{wait(.05);};
	}
}


function line_intersect_sphere(line_start, line_end, sphere_center, sphere_radius)
{
	dir = VectorNormalize(line_end - line_start);
	
	a = VectorDot(dir,(line_start-sphere_center));
	a*=a;
	b = (line_start-sphere_center);
	b *= b;
	c = sphere_radius*sphere_radius;
	
	return (a-b+c)>=0;
}


function ball_touched_goal(goal)
{
	//ball_play_score_fx(goal); -- TODO FX

	
	if ( isDefined( self.scoreFrozenUntil ) && self.scoreFrozenUntil > getTime() )
		return;

	goal play_goal_score_fx();
	
	self.scoreFrozenUntil = getTime() + 10000;

	team = goal.team;
	otherTeam = util::getOtherTeam( team );

	// TODO: Ball ID
	globallogic_audio::flush_objective_dialog( "uplink_ball" );
	globallogic_audio::leader_dialog( "uplWeUplinkRemote", otherTeam );
	globallogic_audio::leader_dialog( "uplTheyUplinkRemote", team );
	
	globallogic_audio::play_2d_on_team( "mpl_ballcapture_sting_friend", otherTeam );
    globallogic_audio::play_2d_on_team( "mpl_ballcapture_sting_enemy", team );
    
	if ( isDefined(self.lastCarrier) )
	{
		level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_CAPTURE", self.lastCarrier, team );
		level thread popups::DisplayTeamMessageToTeam( &"MP_BALL_CAPTURE", self.lastCarrier, otherTeam );
		
		if( isdefined(self.lastCarrier.pers["throws"]) )
		{
			self.lastCarrier.pers["throws"]++;
			self.lastCarrier.throws = self.lastCarrier.pers["throws"];
		}
		
		self.lastCarrier AddPlayerStatWithGameType( "THROWS", 1 );
		scoreevents::processScoreEvent( "ball_capture_throw", self.lastCarrier );
		self.lastCarrierScored = true;
		ball_check_assist( self.lastcarrier, false );
		
		if(IsDefined(self.killcamEnt) && should_record_final_score_cam( otherTeam, level.throwScore) )
		{
//			killcamentity = self.killcamEnt;
//			killcamentityindex = killcamentity GetEntityNumber();
//			killcamentitystarttime = killcamentity.birthtime;
//			if ( !IsDefined( killcamentitystarttime ) )
//				killcamentitystarttime = 0;
//			player = self.lastCarrier;
//			goal.killcamEnt.deathTime = GetTime();
			//maps\mp\gametypes\_damage::recordFinalKillCam( 5.0, goal.killcamEnt, player, player GetEntityNumber(), killcamentityindex, killcamentitystarttime, "none", 0, 0, undefined, "score" );	-- TODO killcam
		}
	}
	
	if(IsDefined(self.killcamEnt))
	{
		self.killcamEnt Unlink();
	}
	
	self thread upload_ball( goal );
	
	ball_give_score( otherTeam, level.throwScore );
}

function ball_give_score( team, score )
{
	level globallogic_score::giveTeamScoreForObjective( team, score );
	
	if ( isdefined( game["overtime_round"] ) )
	{
		if( game["overtime_round"] == 1 )
		{
			game["ball_overtime_team"] = team;
			game["round_time_to_beat"] = globallogic_utils::getTimePassed();
			//	level thread maps\mp\gametypes\_gamelogic::endGame( "overtime_halftime", game[ "end_reason" ][ "switching_sides" ] ); //-- TODO we have callback for endgame
		}
		else
		{
			team_score = [[level._getTeamScore]]( team );
			other_team_score = [[level._getTeamScore]]( util::getOtherTeam(team));
			
	//		if( team_score >= other_team_score)	
	//			level thread maps\mp\gametypes\_gamelogic::endGame( toTeam, game[ "end_reason" ][ "score_limit_reached" ] ); //-- TODO we have callback for endgame
		}
	}
}


function should_record_final_score_cam(team, score_to_add)
{
	//Don't record kill cam if the team scoring would still be losing
	team_score = [[level._getTeamScore]]( team );
	other_team_score = [[level._getTeamScore]]( util::getOtherTeam(team));
	
	return (team_score + score_to_add) >= other_team_score;
}
	
function ball_check_assist( player, wasDunk )
{
	//Was the player passed to
	if(!IsDefined(player.passTime) || !IsDefined(player.passPlayer))
		return;

	//Was it a recent pass
	if(player.passTime+3000 < GetTime())
		return;
	
	scoreevents::processScoreEvent( "ball_capture_assist",player.passPlayer );
}
	

function ball_physics_timeout( droppingPlayer )
{
	self endon( "reset" );
	self endon( "pickup_object" );
	self endon( "score_event" );
	
	waitTime = GetDvarFloat( "scr_ball_reset_time",  15 );

	minWaitTimeForTransition = 10;
	transitionTime = 3;
	
	if ( waitTime >= minWaitTimeForTransition )
	{
		wait transitionTime;
		waitTime -= transitionTime;
	}

	wait waitTime;
	
	self reset_ball();
}

function ball_physics_out_of_level()
{
	self endon ( "reset" );
	self endon ( "pickup_object" );
	
	ball = self.visuals[0];

	self waittill ( "entity_oob" );

	self reset_ball();
}

function player_update_pass_target(ballObj)
{
	self notify( "update_pass_target" );
	self endon( "update_pass_target" );
	self endon("disconnect");
	self endon("cancel_update_pass_target");
	
	//self player_update_pass_target_hudoutline(); -- TODO outlines using the sitrep
	//self childthread player_joined_update_pass_target_hudoutline();
	
	test_dot = 0.8;
	while(1)
	{
		new_target = undefined;
		
		if ( !self IsOnLadder() )
		{
			playerDir = AnglesToForward( self GetPlayerAngles() );
			playerEye = self GetEye();
			
			possible_pass_targets = [];
			foreach(target in level.players)
			{
				if ( target.team != self.team )
					continue;
			
				if ( !isAlive( target ) )
					continue;
				
				if( !ballObj can_use_ball(target) )
					continue;
				
				targetEye = target GetEye();
				distSq = DistanceSquared( targetEye, playerEye );
				if ( distSq > ( 1000 * 1000 ) )
					continue;

				dirToTarget = VectorNormalize( targetEye - playerEye );
				dot = VectorDot( playerDir, dirToTarget );
				if ( dot > test_dot )
				{
					target.pass_dot = dot;
					target.pass_origin = targetEye;
					possible_pass_targets[possible_pass_targets.size] = target;
				}
			}
			
			//possible_pass_targets = ArraySort(possible_pass_targets, self.origin );
			possible_pass_targets = array::quicksort( possible_pass_targets, &compare_player_pass_dot );
			
			foreach(target in possible_pass_targets)
			{
				if ( SightTracePassed(playerEye, target.pass_origin, false, target ) )
				{
					new_target = target;
					break;
				}
			}
		}
		
		self player_set_pass_target(new_target);
		
		{wait(.05);};
	}
}

function play_return_vo()
{
	foreach( team in level.teams )
	{
		globallogic_audio::play_2d_on_team( "mpl_ballreturn_sting", team );
		
		// TODO: Add ball # to objectiveId
		globallogic_audio::leader_dialog( "uplReset", team, undefined, "uplink_ball" );
	}
}

function compare_player_pass_dot(left, right)
{
	return left.pass_dot>=right.pass_dot;
}

function player_set_pass_target(new_target)
{
	//No Change
	if ( IsDefined(self.pass_target) && IsDefined(new_target) && self.pass_target == new_target )
		return;
	
	if ( !IsDefined(self.pass_target) && !IsDefined(new_target) )
		return;
	
	self player_clear_pass_target();
	
	if(IsDefined(new_target))
	{
		offset = ( 0, 0, 80 );
		//self.pass_icon = new_target maps\mp\_entityheadIcons::setHeadIcon( self, "waypoint_ball_pass", offset, 10, 10, false, 0.05, false, true, false, false, "tag_origin" ); -- TODO HUD
	
		new_target clientfield::set( "passoption", 1 );
		self.pass_target = new_target;
		
		team_players = [];
		foreach(player in level.players)
		{
			if(player.team == self.team && player != self && player != new_target)
				team_players[team_players.size] = player;
		}
		
		self SetBallPassAllowed(true);
	}
	
	//self player_update_pass_target_hudoutline();  -- TODO siterepscan outlines
}

function player_clear_pass_target()
{
	if(IsDefined(self.pass_icon))
		self.pass_icon Destroy();
	
	team_players = [];
	foreach(player in level.players)
	{
		if( player.team == self.team && player != self )
			team_players[team_players.size] = player;
	}
	
	if( isDefined( self.pass_target ) )
	{
		self.pass_target clientfield::set( "passoption", 0 );
	}
	self.pass_target = undefined;
	self SetBallPassAllowed(false);
	
	//self player_update_pass_target_hudoutline(); -- TODO siterepscan outlines
}


function ball_create_start( minStartingBalls )
{
	ball_starts = getEntArray( "ball_start" ,"targetname");

	ball_starts = array::randomize( ball_starts );
	foreach(new_start in ball_starts)
	{
		ballAddStart(new_start.origin);
	}
	
	//Add a default start if none exist
	default_ball_height = 30;
	if( ball_starts.size==0 )
	{
		origin = level.default_ball_origin;
		if(!IsDefined(origin))
		{
			origin = (0,0,0);
		}

		ballAddStart(origin);
	}
	
	//Add extra default starts to support multi ball
	add_num = minStartingBalls - level.ball_starts.size;
	if( add_num <= 0 )
	{
		return;
	}
	
	default_start = level.ball_starts[0].origin;
	
	near_nodes = GetNodesInRadius(default_start, 200, 20, 50);
	near_nodes = array::randomize(near_nodes);
	
	for ( i = 0; i < add_num && i<near_nodes.size; i++ )
	{
		ballAddStart(near_nodes[i].origin);
	}
}

function ballAddStart(origin)
{
	ball_spawn_height = 30;
	
	new_start = SpawnStruct();
	new_start.origin = origin;
	new_start ballFindGround();
	new_start.origin = new_start.ground_origin + (0,0,ball_spawn_height);
	new_start.in_use = false;
	
	level.ball_starts[level.ball_starts.size] = new_start;
}

function ballFindGround(z_offset)
{
	traceStart 	= self.origin + (0,0,32);
	traceEnd 	= self.origin + (0,0,-1000);
	trace 		= bulletTrace( traceStart, traceEnd, false, undefined );

	self.ground_origin = trace["position"];
	
	return trace["fraction"] != 0 && trace["fraction"] != 1;
}

function play_goal_score_fx( )
{
	key = "ball_score_" + self.team;
	level clientfield::set( key, !(level clientfield::get( key )) );
}

// TODO THE FX FOR THIS MODE THAT ARE USED BY AW ARE BELOW, REMOVE AFTER WE HAVE OUR OWN FX REPLACEMENTS

//
//ball_get_path_dist(from_origin, to_origin)
//{
//	if( maps\mp\gametypes\_spawnlogic::isPathDataAvailable() )
//	{
//		dist = GetPathDist( from_origin, to_origin, 999999 );
//		if( IsDefined(dist) && (dist >= 0) )
//			return dist;
//	}
//	
//	// fail safe for bad pathing data		
//	return distance( from_origin, to_origin );
//}
//


//ball_goal_fx()
//{
//	foreach(team, goal in level.ball_goals)
//	{
//		goal.score_fx["friendly"] = SpawnFx(getfx("ball_goal_activated_friendly"), goal.origin, (1,0,0));
//		goal.score_fx["enemy"] = SpawnFx(getfx("ball_goal_activated_enemy"), goal.origin, (1,0,0));
//	}
//	
//	level thread ball_play_fx_joined_team();
//	foreach(player in level.players)
//	{
//		ball_goal_fx_for_player(player);
//	}
//}


//
//ball_play_score_fx(goal)
//{
//	//Update who can see what fx
//	goal.score_fx["friendly"] Hide();
//	goal.score_fx["enemy"] Hide();
//	
//	foreach(player in level.players)
//	{
//		team = ball_get_view_team(player);
//		
//		if( team == goal.team )
//		{
//			goal.score_fx["friendly"] ShowToPlayer(player);
//		}
//		else
//		{
//			goal.score_fx["enemy"] ShowToPlayer(player);
//		}
//	}
//	
//	TriggerFx(goal.score_fx["friendly"]);
//	TriggerFx(goal.score_fx["enemy"]);
//}
//
//ball_score_sound(scoring_team)
//{
//	ball_play_local_team_sound(scoring_team, "mp_obj_notify_pos_lrg", "mp_obj_notify_neg_lrg");
//}
//
//ball_play_local_team_sound(team, teamSound, otherTeamSound)
//{
//	otherTeam = getOtherTeam(team);
//	foreach(player in level.players)
//	{
//		if( player.team == team )
//			player PlayLocalSound( teamSound );
//		else if ( player.team == otherTeam )
//			player PlayLocalSound( otherTeamSound );
//	}
//}
//


//
//compare_script_index(left, right)
//{
//	return left.script_index<=right.script_index;
//}
//
//ball_on_connect()
//{
//	while ( true )
//	{
//		level waittill( "connected", player );
//		
//		player.ball_goal_fx = [];
//		
//		player thread player_on_disconnect();
//	}
//}
//
//player_on_disconnect()	// self == player
//{
//	self waittill ("disconnect" );
//	
//	player_delete_ball_goal_fx();
//}
//
//ball_goal_fx_for_player(player)
//{
//	viewTeam = ball_get_view_team(player);
//	
//	player player_delete_ball_goal_fx();
//		
//	foreach(team, goal in level.ball_goals)
//	{
//		fx_name = ter_op(team == viewTeam, "ball_goal_friendly", "ball_goal_enemy");
//		
//		fx = SpawnFXForClient( getfx(fx_name), goal.origin, player, (1,0,0));
//		SetFXKillOnDelete( fx, true );
//		
//		player.ball_goal_fx[fx_name] = fx;
//		TriggerFX( fx );
//	}
//}
//
//ball_get_view_team(player)
//{
//	viewTeam = player.team;
//	if(	viewTeam != "allies" && viewTeam != "axis")
//		viewTeam = "allies";
//	
//	return viewTeam;
//}
//
//player_delete_ball_goal_fx()
//{
//	foreach (effect in self.ball_goal_fx)
//	{
//		if ( IsDefined( effect ) )
//			effect Delete();
//	}
//}
//
//ball_play_fx_joined_team()
//{
//	while(1)
//	{
//		level waittill ("joined_team", player );
//		ball_goal_fx_for_player(player);
//	}
//}
//


///// FX


//
//function WatchPhysics()
//{
//	self endon("death");
//	
//	while(1)
//	{
//		self waittill("physics_impact", position, normal, velocity, surface);
//		
//		//Print("Impact("+GetTime()+") p:" + position + " n:" + velocity + " v:" + velocity + " s:" + surface + "\n");
//		fxID = level._effect["ball_physics_impact"];
//		if(IsDefined(surface) && IsDefined(level._effect["ball_physics_impact_"+surface]))
//		   fxID = level._effect["ball_physics_impact_"+surface];
//		   
//		PlayFX(fxID, position, normal );
//		
//		wait .3;
//	}
//}

//
//ball_fx_start()
//{
//	if (!self ball_fx_active())
//	{
//		ball = self.visuals[0];
//		PlayFXOnTag(getfx("ball_trail"), ball, "tag_origin");
//		PlayFXOnTag(getfx("ball_idle"), ball, "tag_origin");
//		self.ball_fx_active = true;
//	}
//}
//
//ball_fx_start_player(player)
//{
//	if(self ball_fx_active())
//	{
//		ball = self.visuals[0];
//		PlayFXOnTagForClients(getfx("ball_trail"), ball, "tag_origin", player);
//		PlayFXOnTagForClients(getfx("ball_idle"), ball, "tag_origin", player);
//	}
//}
//
//ball_fx_stop()
//{
//	if ( self ball_fx_active() )
//	{
//		ball = self.visuals[0];
//		StopFXOnTag(getfx("ball_trail"), ball, "tag_origin");
//		killFXOnTag(getfx("ball_idle"), ball, "tag_origin");
//	}
//	self.ball_fx_active = false;
//}
//
//ball_fx_active()
//{
//	return IsDefined(self.ball_fx_active) && self.ball_fx_active;
//}


//function ball_dont_interpolate()
//{
//	self.visuals[0] DontInterpolate();
//	self.ball_fx_active = false; //DontInterpolate kill fx so need to pretent they were turned off.
//}


//// HUD

//
//function player_update_pass_target_hudoutline()
//{
//	if(!IsDefined(self))
//		return;
//	
//	self HudOutlineDisableForClients( level.players );
//	foreach(player in level.players)
//	{
//		player HudOutlineDisableForClient(self);
//	}
//	
//	team_players = [];
//	other_team_players = [];
//	other_team = getOtherTeam(self.team);
//
//	foreach(player in level.players)
//	{
//		if( player == self )
//			continue;
//		
//		if( player.team == self.team )
//			team_players[team_players.size] = player;
//		else if ( player.team == other_team )
//			other_team_players[other_team_players.size] = player;
//	}
//	
//	if(IsDefined(self.carryObject))
//	{
//		foreach(player in team_players)
//		{
//			isPassTarget = IsDefined(self.pass_target) && (self.pass_target == player);
//			if(!isPassTarget)
//				player HudOutlineEnableForClient(self, 4, false);
//		}
//		
//		if(IsDefined(self.pass_target))
//			self.pass_target HudOutlineEnableForClient(self, 5, false);
//		
//		if(other_team_players.size>0)
//			self HudOutlineEnableForClients( other_team_players, 0, true);
//		
//		if(team_players.size>0)
//			self HudOutlineEnableForClients( team_players, 5, false );
//	}
//}

//
//player_joined_update_pass_target_hudoutline()
//{
//	while(1)
//	{
//		level waittill( "joined_team", player );
//		self player_update_pass_target_hudoutline();
//	}
//}
//