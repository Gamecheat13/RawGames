#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreak_bundles;

           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\gametypes\ctf;

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\teams\_teams;
#using scripts\mp\_util;

/*
	Safeguard: No crimes
	
	Game Settings
	-----
	shutdownDamage		- Set to 0 to disable taking damage
	useRebootTime		- Set to 0 to disable manual reboot
	autoRebootTime		- Set to 0 to disable auto reboot		
	robotSpeed			- 0: walk, 1: run, 3: sprint
	movePlayers			- Number of players needed to escort the robot
	blockPlayers		- Number of enemy players needed to contest the robot

	
	Level requirements
	------------------
		Spawnpoints:
		Attacker Start Spawnpoints:
			classname		mp_escort_spawn_attacker_start
			Attackers spawn from these at start of match.
		
		Attacker Respawn Spawnpoints:
			classname		mp_escort_spawn_attacker
			Attackers respawn from these. Place on the attacking side of the map.

		Defender Start Spawnpoints:
			classname		mp_escort_spawn_defender_start
			Defenders spawn from these at start of match.
		
		Defender Respawn Spawnpoints:
			classname		mp_escort_spawn_defender_start
			Defenders respawn from these. Place on the defending side of the map.

		Spectator Spawnpoints:
		
		Triggers:
			escort_robot_move_trig - The robot will spawn in the middle of this trigger and will move when friendly players are inside it
			escort_robot_goal_trig - 
			
		Use Triggers:
			escort_robot_reboot_trig - Friendly players will interact with this trigger to reboot the robot
			
		Pathnodes:
			escort_robot_path_start - This is the first node the robot will move to
			
	
*/




	


	


	









// Tweaks to how the combat robot's body is thrown after exploding
	// Scales the initial velocity














	
#precache( "string", "OBJECTIVES_ESCORT_ATTACKER" );
#precache( "string", "OBJECTIVES_ESCORT_DEFENDER" );
#precache( "string", "OBJECTIVES_ESCORT_ATTACKER_SCORE" );
#precache( "string", "OBJECTIVES_ESCORT_DEFENDER_SCORE" );
#precache( "string", "OBJECTIVES_ESCORT_ATTACKER_HINT" );
#precache( "string", "OBJECTIVES_ESCORT_DEFENDER_HINT" );

//#precache( "string", "MPUI_ESCORT_ROBOT_IDLE" );
#precache( "string", "MPUI_ESCORT_ROBOT_MOVING" );
//#precache( "string", "MPUI_ESCORT_ROBOT_REBOOTING" );

#precache( "string", "MP_ESCORT_OVERTIME_ROUND_1_ATTACKERS" );
#precache( "string", "MP_ESCORT_OVERTIME_ROUND_1_DEFENDERS" );
#precache( "string", "MP_ESCORT_OVERTIME_ROUND_2_ATTACKERS" );
#precache( "string", "MP_ESCORT_OVERTIME_ROUND_2_DEFENDERS" );
#precache( "string", "MP_ESCORT_OVERTIME_ROUND_2_TIE_ATTACKERS" );
#precache( "string", "MP_ESCORT_OVERTIME_ROUND_2_TIE_DEFENDERS" );

#precache( "string", "MP_ESCORT_ROBOT_DISABLED" );

#precache( "triggerstring", "PLATFORM_HOLD_TO_REBOOT_ROBOT" );
#precache( "string", "MP_REBOOTING_ROBOT" );	

#precache( "fx", "ui/fx_dom_marker_team" );
#precache( "fx", "weapon/fx_c4_exp_metal" );

#precache( "objective", "escort_goal" );
#precache( "objective", "escort_robot" );


function autoexec __init__sytem__() {     system::register("escort",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "actor", "robot_state" , 1, 2, "int" );
	
	callback::on_spawned( &on_player_spawned );
}

function main()
{
	globallogic::init();
	
	util::registerTimeLimit( 0, 1440 );
	util::registerRoundScoreLimit( 0, 2000 );
	util::registerScoreLimit( 0, 5000 );	
	util::registerRoundLimit( 0, 12 );
	util::registerRoundSwitch( 0, 9 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );
	
	level.bootTime = GetGametypeSetting( "bootTime" );				// Initial time for the robot to boot when the game starts
	level.rebootTime = GetGametypeSetting( "rebootTime" );			// Time it takes for the robot to reboot
	level.rebootPlayers = GetGametypeSetting( "rebootPlayers" );	// 0 auto rebot, 1 players in radius, 2 players in radius with bonus
	level.movePlayers = GetGametypeSetting( "movePlayers" );		// 0 auto move, 1 players in radius
	
	level.robotShield = GetGametypeSetting( "robotShield" );		// 0 no riot shield, 1 riot shield
	
	switch( GetGametypeSetting( "shutdownDamage" ) )
	{
		case 1:	// Low
			level.escortRobotKillstreakBundle = "escort_robot_low";
			break;
		case 2:	// Normal
			level.escortRobotKillstreakBundle = "escort_robot";
			break;
		case 3:	// High
			level.escortRobotKillstreakBundle = "escort_robot_high";
		case 0: // Invulnerable
		default:
			level.shutdownDamage = 0;
	}
	
	if ( isdefined( level.escortRobotKillstreakBundle ) )
	{
		killstreak_bundles::register_killstreak_bundle( level.escortRobotKillstreakBundle );
		level.shutdownDamage = killstreak_bundles::get_max_health( level.escortRobotKillstreakBundle );
	}
	
	
	switch ( GetGametypeSetting( "robotSpeed" ) )
	{
		case 1:
			level.robotSpeed = "run";
			break;
		case 2:
			level.robotSpeed = "sprint";
			break;
		case 0:
		default:
			level.robotSpeed = "walk";
	}
	
	globallogic_audio::set_leader_gametype_dialog ( "startSafeguard", "hcStartSafeguard", "sfgStartAttack", "sfgStartDefend" );
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "escorts", "disables", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "escorts", "disables" );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.scoreRoundWinBased = true;
	
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onStartGameType =&onStartGameType;
	
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onPlayerKilled =&onPlayerKilled;
	
	level.onTimeLimit =&onTimeLimit;
	level.onRoundSwitch =&onRoundSwitch;
	level.onEndGame =&onEndGame;
	level.shouldPlayOvertimeRound =&shouldPlayOvertimeRound;
	
	level.onRoundEndGame =&onRoundEndGame;
	
	gameobjects::register_allowed_gameobject( level.gameType );
}

function onPrecacheGameType()
{

}

function onStartGameType()
{
	level.useStartSpawns = true;

	if ( !isdefined( game["switchedsides"] ) )
	{
		game["switchedsides"] = false;
	}
	
	setClientNameMode("auto_change");
	
	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	util::setObjectiveText( game["attackers"], &"OBJECTIVES_ESCORT_ATTACKER" );
	util::setObjectiveText( game["defenders"], &"OBJECTIVES_ESCORT_DEFENDER" );
	
	util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_ESCORT_ATTACKER_SCORE" );
	util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_ESCORT_DEFENDER_SCORE" );
	
	util::setObjectiveHintText( game["attackers"], &"OBJECTIVES_ESCORT_ATTACKER_HINT" );
	util::setObjectiveHintText( game["defenders"], &"OBJECTIVES_ESCORT_DEFENDER_HINT" );
	
	if ( isdefined( game["overtime_round"] ) )
	{
		[[level._setTeamScore]]( "allies", 0 );
		[[level._setTeamScore]]( "axis", 0 );
		
		if ( isdefined( game["escort_overtime_time_to_beat"] ) )
		{
			timeMs = game["escort_overtime_time_to_beat"] / 60000;
			util::registerTimeLimit( timeMs, timeMs );
		}
		
		if ( game["overtime_round"] == 1 )
		{
			level.onTimeLimit = &onTimeLimit_Overtime1;
			util::setObjectiveHintText( game["attackers"], &"MP_ESCORT_OVERTIME_ROUND_1_ATTACKERS" );
			util::setObjectiveHintText( game["defenders"], &"MP_ESCORT_OVERTIME_ROUND_1_DEFENDERS" );
		}
		else if ( isdefined( game["escort_overtime_first_winner"] ) )
		{
			level.onTimeLimit = &onTimeLimit_Overtime2;
			util::setObjectiveHintText( game["attackers"], &"MP_ESCORT_OVERTIME_ROUND_2_ATTACKERS" );
			util::setObjectiveHintText( game["defenders"], &"MP_ESCORT_OVERTIME_ROUND_2_DEFENDERS" );
		}
		else
		{
			level.onTimeLimit = &onTimeLimit_Overtime2;
			util::setObjectiveHintText( game["attackers"], &"MP_ESCORT_OVERTIME_ROUND_2_TIE_ATTACKERS" );
			util::setObjectiveHintText( game["defenders"], &"MP_ESCORT_OVERTIME_ROUND_2_TIE_DEFENDERS" );
		}
	}
	
	// Set up Spawn points
	spawnlogic::place_spawn_points( "mp_escort_spawn_attacker_start" );
	spawnlogic::place_spawn_points( "mp_escort_spawn_defender_start" );
 
	level.spawn_start = [];
	level.spawn_start["allies"] = spawnlogic::get_spawnpoint_array( "mp_escort_spawn_attacker_start" );
	level.spawn_start["axis"] = spawnlogic::get_spawnpoint_array( "mp_escort_spawn_defender_start" );
	
	spawnlogic::add_spawn_points( "allies", "mp_escort_spawn_attacker" );
	spawnlogic::add_spawn_points( "axis", "mp_escort_spawn_defender" );
	
	spawning::updateAllSpawnPoints();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	// Spawn Robot
	level thread start_robot_escort();
}

function onSpawnPlayer( predictedSpawn )
{
	spawning::onSpawnPlayer(predictedSpawn);
}
	
function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isdefined( attacker ) || attacker == self || !IsPlayer( attacker ) || attacker.team == self.team )
	{
		return;
	}
	
	if ( self.team == game["defenders"] && ( isdefined( attacker.escortingRobot ) && attacker.escortingRobot ) )
	{
		scoreevents::processScoreEvent( "killed_defender", attacker );
	}
	else if ( self.team == game["attackers"] && ( isdefined( self.escortingRobot ) && self.escortingRobot ) )
	{
		scoreevents::processScoreEvent( "killed_attacker", attacker );
	}
}
	
function onTimeLimit()
{
	defenders = game["defenders"];
	globallogic_score::giveTeamScoreForObjective_DelayPostProcessing( defenders, 1 );
	level thread globallogic::endGame( defenders, game["strings"]["time_limit_reached"] );
}

function onTimeLimit_Overtime1()
{
	level thread globallogic::endGame( "tie", game["strings"]["time_limit_reached"] );
}

function onTimeLimit_Overtime2()
{
	if ( isdefined( game["escort_overtime_first_winner"] ) )
	{
		winner = game["escort_overtime_first_winner"];
		level thread globallogic::endGame( winner, game["strings"]["time_limit_reached"] );
	}
	else
	{
		level thread globallogic::endGame( "tie", game["strings"]["time_limit_reached"] );
	}
}
	
function onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}

function onEndGame( winningTeam )
{
	if ( isdefined( game["overtime_round"] ) && isdefined( winningTeam ) && ( winningTeam != "tie" ) )
	{
		if ( game["overtime_round"] == 1 )
		{
			if ( winningTeam == game["attackers"] )
			{
				game["escort_overtime_first_winner"] = winningTeam;
				game["escort_overtime_time_to_beat"] = globallogic_utils::getTimePassed();
			}
		}
	}
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
	
	alliesRoundsWon = util::getRoundsWon( "allies" );
	axisRoundsWon = util::getRoundsWon( "axis" );
	
	if ( util::hitRoundLimit() && ( alliesRoundsWon == axisRoundsWon ) )
	{
		return true;
	}
	
	return false;
}

function onRoundEndGame( winningTeam )
{
	if ( isdefined( game["overtime_round"] ) )
	{
		return winningTeam;
	}
	
	return globallogic::determineTeamWinnerByTeamScore();
}

// Callbacks
//========================================

function on_player_spawned()
{
	self.escortingRobot = undefined;
}


// Safeguard Robot
//========================================

function start_robot_escort()
{
	globallogic::waitForPlayers();

	// Robot
	moveTrigger = GetEnt( "escort_robot_move_trig", "targetname" );
	
	startNode = GetNode( "escort_robot_path_start", "targetname" );
	startDir = startNode.origin - moveTrigger.origin;
	startAngles = VectorToAngles( startDir );
/#
	calc_robot_path_length( moveTrigger.origin, startNode );
#/
	level.robot = spawn_robot( moveTrigger.origin, ( 0, startAngles[1], 0 ) );
	level.robot.team = game["attackers"];
	level.robot.currentGoal = startNode;
	
	level.robot thread watch_robot_damaged();
	level.robot thread wait_robot_moving();
	
	level.robot.spawn_influencer_friendly = level.robot spawning::create_entity_friendly_influencer( "escort_robot_attackers", game["attackers"] );
	
	// Triggers
	level.moveObject = setup_move_object( level.robot, "escort_robot_move_trig" );
	setup_reboot_object( level.robot, "escort_robot_reboot_trig" );
	level.goalObject = setup_goal_object( level.robot, "escort_robot_goal_trig" );
	
	// Start the robot shutdown
	level.robot clientfield::set( "robot_state", 2 );
	level.moveObject gameobjects::set_flags( 2 );
	
	level.robot shutdown_robot();
	
	while ( level.inPrematchPeriod )
	{
		{wait(.05);};
	}
	
	level.robot thread auto_reboot_robot( level.bootTime );
	level.robot thread wait_robot_reboot();
}
	
function wait_robot_moving()
{
	level endon( "game_ended" );
	
	while(1)
	{
		self waittill( "robot_moving" );
		
		self clientfield::set( "robot_state", 1 );
		level.moveObject gameobjects::set_flags( 1 );
		
		self thread wait_robot_stopped();
		return;
	}
}
		
function wait_robot_stopped()
{
	level endon( "game_ended" );
	
	while(1)
	{
		self waittill( "robot_stopped" );
		
		if ( self.active )
		{
			self clientfield::set( "robot_state", 0 );
			level.moveObject gameobjects::set_flags( 0 );
		}
		
		self thread wait_robot_moving();
		return;
	}
}
	
function wait_robot_shutdown()
{
	level endon( "game_ended" );
	
	self waittill( "robot_shutdown" );
	
	level.moveObject gameobjects::allow_use( "none" );
	
	Objective_SetProgress( level.moveObject.objectiveID, -0.05 );
	
	self clientfield::set( "robot_state", 2 );
	level.moveObject gameobjects::set_flags( 2 );

	otherTeam = util::getOtherTeam( self.team );
	
	globallogic_audio::leader_dialog( "sfgRobotDisabledAttacker", self.team, undefined, "robot" );
	globallogic_audio::leader_dialog( "sfgRobotDisabledDefender", otherTeam, undefined, "robot" );
	
	globallogic_audio::play_2d_on_team( "mpl_safeguard_disabled_sting_friend", self.team );
	globallogic_audio::play_2d_on_team( "mpl_safeguard_disabled_sting_enemy", otherTeam );
	
	self thread auto_reboot_robot( level.rebootTime );
	self thread wait_robot_reboot();
}

function wait_robot_reboot()
{
	level endon( "game_ended" );
	
	self waittill( "robot_reboot" );
	
	if ( level.moveObject.numTouching[level.moveObject.ownerTeam] == 0 )
	{
		self clientfield::set( "robot_state", 0 );
		level.moveObject gameobjects::set_flags( 0 );
	}
	
	level.moveObject gameobjects::allow_use( "friendly" );
	
	otherTeam = util::getOtherTeam( self.team );
	
	globallogic_audio::leader_dialog( "sfgRobotRebootedAttacker", self.team, undefined, "robot" );
	globallogic_audio::leader_dialog( "sfgRobotRebootedDefender", otherTeam, undefined, "robot" );
	
	globallogic_audio::play_2d_on_team( "mpl_safeguard_reboot_sting_friend", self.team );
	globallogic_audio::play_2d_on_team( "mpl_safeguard_reboot_sting_enemy", otherTeam );
			
	Objective_SetProgress( level.moveObject.objectiveID, 1 );
	
	if ( level.movePlayers == 0 )
	{
		self move_robot();
	}
	
	self thread wait_robot_shutdown();
}

function auto_reboot_robot( time )
{
	self endon( "robot_reboot" );
	self endon( "game_ended" );
	
	shutdownTime = 0;
	
	while( shutdownTime < time )
	{
		friendlyCount = level.moveObject.numTouching[level.moveObject.ownerTeam];
		
		if ( !level.rebootPlayers )
		{
			rate = .05;
		}
		else if ( friendlyCount > 0 )
		{
			rate = .05;	// Base rate for interactive reboot
			
			if ( friendlyCount > 1 )	// Add in multiple player bonus if any
			{
				bonusRate = ( friendlyCount - 1 ) * .05 * 0;
				
				if ( bonusRate > 0 )
				{
					rate += bonusRate;
				}
			}
		}
		else
		{
			rate = 0;
		}
			
		shutdownTime += rate;
		percent = Min( 1, shutdownTime / time );
		Objective_SetProgress( level.moveObject.objectiveID, percent );
		
		{wait(.05);};
	}
	
	
	if ( level.rebootPlayers > 0 )
	{
		foreach( struct in level.moveObject.touchList[game["attackers"]] )
		{
			scoreevents::processScoreEvent( "escort_robot_reboot", struct.player );
		}
	}
	
	self thread reboot_robot();
}

function watch_robot_damaged()
{
	level endon( "game_ended" );
	
	while (1)
	{
		self waittill( "robot_damaged" );
		
		percent = Min( 1, ( self.shutdownDamage / level.shutdownDamage ) );
		Objective_SetProgress( level.moveObject.objectiveID, 1 - percent );
		
		health = level.shutdownDamage - self.shutdownDamage;
		
		lowHealth = killstreak_bundles::get_low_health( level.escortRobotKillstreakBundle );
		
		if ( !( isdefined( self.playedDamage ) && self.playedDamage ) && health <= lowHealth )
		{
			globallogic_audio::leader_dialog( "sfgRobotUnderFire", self.team, undefined, "robot" );
			self.playedDamage = true;
		}
		else if ( health > lowHealth )
		{
			self.playedDamage = false;
		}
	}
}

/#
function calc_robot_path_length( robotOrigin, startNode )
{
	distance = Distance( robotOrigin, startNode.origin );
	
	nextNode = startNode;
	
	while( !isdefined( nextNode.target ) )
	{
		currNode = nextNode;
		nextNode = GetNode( currNode.target, "targetname" );
		distance += Distance( currNode.origin, nextNode.Origin );
	}
	
	PrintLn( "Escort Path Length: " + distance );
}
#/


// Robot
//========================================

function spawn_robot( position, angles )
{
	robot = SpawnActor( "spawner_bo3_robot_grunt_assault_mp_escort",
	                   	position,
						angles,
						"",
						true );	
	
	robot ai::set_behavior_attribute( "rogue_allow_pregib", false );
	robot ai::set_behavior_attribute( "rogue_allow_predestruct", false );
	
	robot ai::set_behavior_attribute( "rogue_control", "forced_level_2" ); // Lights
	robot ai::set_behavior_attribute( "rogue_control_speed", level.robotSpeed );
	
	robot ai::set_ignoreall( true );
	robot.allowdeath = false;
	//robot.magic_bullet_shield = true; 
	
	robot ai::set_behavior_attribute( "can_become_crawler", false );
	robot ai::set_behavior_attribute( "can_be_meleed", false );
	robot ai::set_behavior_attribute( "can_initiateaivsaimelee", false );
	robot ai::set_behavior_attribute( "traversals", "procedural" );
	
	RobotSoldierServerUtils::removeDestructAndGibDamageOverride( robot );
	
	robot.active = true;
	robot.moving = false;
	robot.shutdownDamage = 0;
	robot.properName = "";	
	robot.ignoreTriggerDamage = true;
	
	robot clientfield::set( "robot_mind_control", 0 );
	robot ai::set_behavior_attribute( "robot_lights", 3 );
	
	robot.pushable = false;
	robot PushActors( true );
	robot PushPlayer( true );
	robot SetAvoidanceMask( "avoid none" );
	robot DisableAimAssist();
	
	robot SetSteeringMode( "slow steering" );
	Blackboard::SetBlackBoardAttribute( robot, "_robot_locomotion_type", "alt1" );
			
	if ( level.robotShield )
	{
		aiutility::attachRiotshield( robot, GetWeapon( "riotshield" ), "wpn_t7_shield_riot_world_lh", "tag_stowed_back" );
	}
	
	robot ASMSetAnimationRate( 1 );
	
	Target_Set( robot );
	
	robot.overrideActorDamage = &robot_damage;
	
	robot thread robot_move_chatter();
	
	return robot;
}

function robot_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex )
{	
	if ( level.shutdownDamage <= 0 ||
	     !self.active ||
	     eAttacker.team == game["attackers"] )
	{
		return 0;
	}

	level.useStartSpawns = false;

	weapon_damage = killstreak_bundles::get_weapon_damage( level.escortRobotKillstreakBundle, level.shutdownDamage, eAttacker, weapon, sMeansOfDeath, iDamage, iDFlags, 1 );

	if(!isdefined(weapon_damage))weapon_damage=iDamage;
	
	self.shutdownDamage += weapon_damage;

	self notify( "robot_damaged" );
	
	if(!isdefined(eAttacker.damageRobot))eAttacker.damageRobot=0;
	
	eAttacker.damageRobot += weapon_damage;
	
	if ( self.shutdownDamage >= level.shutdownDamage )
	{
		if ( IsPlayer( eAttacker ) )
		{
			level thread popups::DisplayTeamMessageToAll( &"MP_ESCORT_ROBOT_DISABLED", eAttacker );
			scoreevents::processScoreEvent( "escort_robot_disable", eAttacker );
			
			if( isdefined( eAttacker.pers["disables"]) )
			{
				eAttacker.pers["disables"]++;
				eAttacker.disables = eAttacker.pers["disables"];
			}
			
			eAttacker AddPlayerStatWithGameType( "DISABLES", 1 );
		}
		
		foreach( player in level.players )
		{
			if ( player == eAttacker ||
			     player.team != self.team ||
			     !isdefined( player.robotDamage ) )
			{
				continue;
			}
			
			damagePercent = player.robotDamage / level.shutdownDamage;
				
			if ( damagePercent >= 50 )
			{
				scoreevents::processScoreEvent( "escort_robot_disable_assist_50", player );
			}
			else if ( damagePercent >= 25 )
			{
				scoreevents::processScoreEvent( "escort_robot_disable_assist_25", player );
			}
			
			player.robotDamage = undefined;
		}
		
		self shutdown_robot();
	}

	self.health += 1;
	return 1;
}

function shutdown_robot()
{
	self.active = false;
	
	self stop_robot();
	
	self notify( "robot_shutdown" );	
	
	Target_Remove( self );
	
	if ( isdefined( self.riotshield ) )
	{
		self AsmChangeAnimMappingTable( 1 );
		self Detach( self.riotshield.model, self.riotshield.tag );
		aiutility::attachRiotshield( self, GetWeapon( "riotshield" ), "wpn_t7_shield_riot_world_lh", "tag_weapon_left" );
	}
	
	self ai::set_behavior_attribute( "shutdown", true );
}

function reboot_robot()
{
	self.active = true;
	self.shutdownDamage = 0;

	self notify( "robot_reboot" );
	
	Target_Set( self );
	
	if ( isdefined( self.riotshield ) )
	{
		self AsmChangeAnimMappingTable( 0 );
		
		self Detach( self.riotshield.model, self.riotshield.tag );
		aiutility::attachRiotshield( self, GetWeapon( "riotshield" ), "wpn_t7_shield_riot_world_lh", "tag_stowed_back" );
	}
	
	self ai::set_behavior_attribute( "shutdown", false );
}

function move_robot()
{
	if ( self.active == false ||
	     !isdefined( self.currentGoal ) )
	{
		return;
	}
	
	self notify ( "robot_moving" );

	self.moving = true;
	self SetGoal( self.currentGoal.origin, false, 30 );
	
	self thread robot_wait_next_node();
}

function stop_robot()
{
	if ( !self.moving )
	{
		return;
	}
	
	self.moving = false;
	self SetGoal( self.origin, false );
	
	self notify ( "robot_stopped" );
}
	
function robot_wait_next_node()
{
	self endon( "robot_stopped" );
	level endon( "game_ended" );
	
	while( 1 )
	{
		self waittill( "goal" );	
		
		if ( !isdefined( self.currentGoal.target ) )
		{
			self.currentGoal = undefined;
			self stop_robot();
			return;
		}
		
		nextNode = GetNode( self.currentGoal.target, "targetname" );
		
		if ( !isdefined( nextNode.target ) )
	    {
			otherTeam = util::getOtherTeam( self.team );
	
			globallogic_audio::leader_dialog( "sfgRobotCloseAttacker", self.team, undefined, "robot" );
			globallogic_audio::leader_dialog( "sfgRobotCloseDefender", otherTeam, undefined, "robot" );
	    }
		
		self.currentGoal = nextNode;
		self SetGoal( self.currentGoal.origin, false, 30 );
	}
}

function explode_robot( )
{
	self clientfield::set("arch_actor_fire_fx", 1);
	clientfield::set(
		"robot_mind_control_explosion", 1 );
	self thread wait_robot_corpse();
	
	if ( RandomInt( 100 ) >= 50 )
		GibServerUtils::GibLeftArm( self );
	else
		GibServerUtils::GibRightArm( self );
	
	GibServerUtils::GibLegs( self );
	GibServerUtils::GibHead( self );
	
	velocity = self GetVelocity() * ( 1 / 8 );
	
	self StartRagdoll();
	self LaunchRagdoll(
		( velocity[0] + RandomFloatRange( -20, 20 ),
		velocity[1] + RandomFloatRange( -20, 20 ),
		RandomFloatRange( 60, 80 ) ),
		"j_mainroot" );
	
	PlayFXOnTag( "weapon/fx_c4_exp_metal", self, "tag_origin" );
	
	if ( Target_IsTarget( self ) )
	{
		Target_Remove( self );
	}
	
	PhysicsExplosionSphere( self.origin, 
   	              			200,
							1,
	              			1,
	              			1,
	              			1 );
	
	RadiusDamage( self.origin, 
	              200,
	              1,
	              1,
	              undefined, 
	              "MOD_EXPLOSIVE" );	
	
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
}

function wait_robot_corpse()
{
	archetype = self.archetype;
 	self waittill("actor_corpse", corpse);
 	corpse clientfield::set("arch_actor_fire_fx", 3);
}

function robot_move_chatter()
{
	level endon( "game_ended" );
	
	while(1)
	{
		if ( self.moving )
		{
			self PlaySoundOnTag( "vox_robot_chatter", "J_Head" );
		}
			
		wait( RandomFloatRange( 1.5, 2.5 ) );
	}
}


// Robot Move Trigger
//========================================

function setup_move_object( robot, triggerName )
{
	oldTrigger = GetEnt( triggerName, "targetname" );
	
	// We want a shorter trigger without building bsps
	trigger = spawn( "trigger_radius", oldTrigger.origin, 0, oldTrigger.radius, 100 );
	
	oldTrigger Delete();
	
	trigger.targetname = triggerName;
	
	useObj = gameobjects::create_use_object( game["attackers"], trigger, [], ( 0, 0 ,0 ), &"escort_robot" );
	useObj gameobjects::set_objective_entity( robot );
	useObj gameobjects::allow_use( "none" );
	useObj gameobjects::set_visible_team( "any" );
	useObj gameobjects::set_use_time( 0 );
	
	trigger EnableLinkTo();
	trigger LinkTo( robot );

	useObj.onUse = &on_use_robot_move;
	useObj.onUpdateUseRate = &on_update_use_rate_robot_move;
	useObj.robot = robot;
	               	
	return useObj;
}

function on_use_robot_move( player )
{
	level.useStartSpawns = false;
	
	if ( !( isdefined( player.escortingRobot ) && player.escortingRobot ) )
	{
		self thread track_escort_time( player );
	}
	
	if ( self.robot.moving ||
	     !self.robot.active  || 
	     self.numTouching[self.ownerTeam] < level.movePlayers )
	{
		return;
	}
	
	self.robot move_robot();
}

function on_update_use_rate_robot_move( team, progress, change )
{
	numOwners = self.numTouching[self.ownerTeam];
	
	if ( numOwners < level.movePlayers )
	{	
		self.robot stop_robot();
	}
}

function track_escort_time( player )
{
	player endon( "death" );
	level endon( "game_ended" );
	
	player.escortingRobot = true;
	
	while(1)
	{
		wait 1;
		
		if ( !self.robot.active )
		{
			continue;
		}
		
		touching = false;
		
		foreach( struct in self.touchList[self.team] )
		{
			if ( struct.player == player )
			{
				touching = true;
				break;
			}
		}
		
		if ( touching )
		{
			if( isdefined( player.pers["escorts"] ) )
			{
				player.pers["escorts"]++;
				player.escorts = player.pers["escorts"];
			}
			
			player AddPlayerStatWithGameType( "ESCORTS", 1 );
		}
		else
		{
			player.escortingRobot = false;
			return;
		}
	}
}

// Robot Reboot Trigger
//========================================

function setup_reboot_object( robot, triggerName )
{
	trigger = GetEnt( triggerName, "targetname" );
	
	if ( isdefined( trigger ) )
	{
		trigger Delete();
	}
}


// Goal
//========================================

function setup_goal_object( robot, triggerName )
{	
	trigger = GetEnt( triggername, "targetname" );
	
	useObj = gameobjects::create_use_object( game["defenders"], trigger, [], ( 0, 0 ,0 ), &"escort_goal" );
	useObj gameobjects::set_visible_team( "any" );
	useObj gameobjects::allow_use( "none" );
	useObj gameobjects::set_use_time( 0 );
	
	traceStart = trigger.origin + (0,0,32);
	traceEnd = trigger.origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );
	upangles = vectorToAngles( trace["normal"] );
	fwd = AnglesToForward( upangles );
	right = AnglesToRight( upangles );
	
	useObj.fx = SpawnFx( "ui/fx_dom_marker_team", trace["position"], fwd, right );
	useObj.fx.team = game["defenders"];
	TriggerFx( useObj.fx, 0.001 );
	
	useObj thread watch_robot_enter( robot );
	
	return useObj;
}

function watch_robot_enter( robot )
{
	robot endon( "death" );
	level endon( "game_ended" );
	
	raidusSq = self.trigger.radius * self.trigger.radius;
	
	while(1)
	{
		if ( robot.moving === true &&
		     Distance2DSquared( self.trigger.origin, robot.origin ) < raidusSq )
		{
			attackers = game["attackers"];
			self.fx.team = attackers;
			
			foreach( player in level.alivePlayers[attackers] )
			{
				if ( ( isdefined( player.escortingRobot ) && player.escortingRobot ) )
				{
					scoreevents::processScoreEvent( "escort_robot_escort_goal", player );
				}
			}
			
			setGameEndTime( 0 );
	
			wait 1;
			
			robot explode_robot();
			
			wait 2;
			
			globallogic_score::giveTeamScoreForObjective( attackers, 1 );
			level thread globallogic::endGame( attackers, game["strings"][attackers + "_mission_accomplished"] );
			
			return;
		}
		
		{wait(.05);};
	}
}