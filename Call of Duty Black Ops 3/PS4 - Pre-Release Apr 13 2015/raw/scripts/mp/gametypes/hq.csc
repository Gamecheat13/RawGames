#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_challenges;
#using scripts\mp\_medals;
#using scripts\mp\_popups;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\mp\killstreaks\_supplydrop;








#precache( "string", "OBJECTIVES_KOTH" );
#precache( "string", "OBJECTIVES_HQ" );
#precache( "string", "OBJECTIVES_HQ_SCORE" );
#precache( "string", "MP_WAITING_FOR_HQ" );
#precache( "string", "MP_HQ_CAPTURED_BY" );
#precache( "string", "MP_CONTROL_HQ" );
#precache( "string", "MP_CAPTURE_HQ" );
#precache( "string", "MP_DESTROY_HQ" );
#precache( "string", "MP_DEFEND_HQ" );
#precache( "string", "MP_HQ_AVAILABLE_IN" );
#precache( "string", "MP_HQ_DESPAWN_IN" );
#precache( "string", "MP_HQ_REINFORCEMENTS_IN" );
#precache( "string", "MP_CAPTURING_HQ" );
#precache( "string", "MP_DESTROYING_HQ" );
#precache( "eventstring", "objective" );

function main()
{
	globallogic::init();

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 1000 );
	util::registerNumLives( 0, 100 );
	util::registerRoundSwitch( 0, 9 );
	util::registerRoundWinLimit( 0, 10 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	
	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.scoreRoundWinBased = true;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.playerSpawnedCB =&koth_playerSpawnedCB;
	level.onRoundSwitch =&onRoundSwitch;
	level.onPlayerKilled =&onPlayerKilled;
	level.onEndGame=&onEndGame;
	
	level.hqAutoDestroyTime = GetGametypeSetting( "autoDestroyTime" );
	level.hqSpawnTime = GetGametypeSetting( "objectiveSpawnTime" );
	level.kothMode = GetGametypeSetting( "kothMode" );
	level.captureTime = GetGametypeSetting( "captureTime" );
	level.destroyTime = GetGametypeSetting( "destroyTime" );
	level.delayPlayer = GetGametypeSetting( "delayPlayer" );
	level.randomHQSpawn = GetGametypeSetting( "randomObjectiveLocations" );
		
	level.maxRespawnDelay = GetGametypeSetting( "timeLimit" ) * 60;
	
	level.iconoffset = (0,0,32);
	
	level.onRespawnDelay =&getRespawnDelay;

	game["dialog"]["gametype"] = "hq_start";
	game["dialog"]["gametype_hardcore"] = "hchq_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";
	
	level.lastDialogTime = 0;
	level.radioSpawnQueue = [];
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "captures", "defends", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "captures", "defends" );
}

function updateObjectiveHintMessages( defenderTeam, defendMessage, attackMessage )
{
	foreach( team in level.teams )
	{
		if ( defenderTeam == team )
		{
			game["strings"]["objective_hint_" + team] = defendMessage;
		}
		else
		{
			game["strings"]["objective_hint_" + team] = attackMessage;
		}
	}
}

function updateObjectiveHintMessage( message )
{
	foreach( team in level.teams )
	{
		game["strings"]["objective_hint_" + team] = message;
	}
}

function getRespawnDelay()
{
	self.lowerMessageOverride = undefined;

	if ( !isdefined( level.radio.gameobject ) )
		return undefined;
	
	hqOwningTeam = level.radio.gameobject gameobjects::get_owner_team();
	if ( self.pers["team"] == hqOwningTeam )
	{
		if ( !isdefined( level.hqDestroyTime ) )
			timeRemaining = level.maxRespawnDelay;
		else
			timeRemaining = (level.hqDestroyTime - gettime()) / 1000;

		if (!level.playerObjectiveHeldRespawnDelay )
			return undefined;

		if ( level.playerObjectiveHeldRespawnDelay >= level.hqAutoDestroyTime )
			self.lowerMessageOverride = &"MP_WAITING_FOR_HQ";				
			
		if ( level.delayPlayer )
		{
			return min( level.spawnDelay, timeRemaining );
		}
		else
		{
			return ceil(timeRemaining);
		}
	}
}

function onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	
	globallogic_score::resetTeamScores();
	
	foreach( team in level.teams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_KOTH" );
	
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_HQ" );
		}
		else
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_HQ_SCORE" );
		}
	}
	
	level.objectiveHintPrepareHQ = &"MP_CONTROL_HQ";
	level.objectiveHintCaptureHQ = &"MP_CAPTURE_HQ";
	level.objectiveHintDestroyHQ = &"MP_DESTROY_HQ";
	level.objectiveHintDefendHQ = &"MP_DEFEND_HQ";
	
	if ( level.kothMode )
		level.objectiveHintDestroyHQ = level.objectiveHintCaptureHQ;
	
	if ( level.hqSpawnTime )
		updateObjectiveHintMessage( level.objectiveHintPrepareHQ );
	else
		updateObjectiveHintMessage( level.objectiveHintCaptureHQ );
	
	setClientNameMode("auto_change");
	
	allowed[0] = "hq";

	gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	// TODO: HQ spawnpoints
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	foreach( team in level.teams )
	{
		spawnlogic::add_spawn_points( team, "mp_tdm_spawn" );
		
		spawnlogic::place_spawn_points( spawning::getTDMStartSpawnName(team) );
	}
	
	spawning::updateAllSpawnPoints();
	
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array( spawning::getTDMStartSpawnName(team) );
	}
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_all = spawnlogic::get_spawnpoint_array( "mp_tdm_spawn" );
	if ( !level.spawn_all.size )
	{
/#
		println("^1No mp_tdm_spawn spawnpoints in level!");
#/
		callback::abort_level();
		return;
	}
	
	
	thread SetupRadios();

	thread HQMainLoop();
}

function spawn_first_radio(delay)
{
	// pick next HQ object
	if ( level.randomHQSpawn == 1 )
	{
		level.radio = GetNextRadioFromQueue();
	}
	else
	{
		level.radio = GetFirstRadio();
	}
	
	/#print("radio spawned: ("+level.radio.trigOrigin[0]+","+level.radio.trigOrigin[1]+","+level.radio.trigOrigin[2]+")");#/
	
	level.radio spawning::enable_influencers(true);
	
	return;
}

function spawn_next_radio()
{
	// pick next HQ object
	if ( level.randomHQSpawn != 0 )
	{
		level.radio = GetNextRadioFromQueue();
	}
	else
	{
		level.radio = GetNextRadio();
	}
	
	/#print("radio spawned: ("+level.radio.trigOrigin[0]+","+level.radio.trigOrigin[1]+","+level.radio.trigOrigin[2]+")");#/
	
	level.radio spawning::enable_influencers(true);
	
	return;
}

function HQMainLoop()
{
	level endon("game_ended");
	
	level.hqRevealTime = -100000;
	
	hqSpawningInStr = &"MP_HQ_AVAILABLE_IN";
	if ( level.kothMode )
	{
		hqDestroyedInFriendlyStr = &"MP_HQ_DESPAWN_IN";
		hqDestroyedInEnemyStr = &"MP_HQ_DESPAWN_IN";
	}
	else
	{
		hqDestroyedInFriendlyStr = &"MP_HQ_REINFORCEMENTS_IN";
		hqDestroyedInEnemyStr = &"MP_HQ_DESPAWN_IN";
	}
		
	spawn_first_radio();
	
	objective_name = istring("objective");

	while ( level.inPrematchPeriod )
		{wait(.05);};
	
	wait 5;
		
	timerDisplay = [];
	foreach ( team in level.teams )
	{
		timerDisplay[team] = hud::createServerTimer( "objective", 1.4, team );
		timerDisplay[team] hud::setGamemodeInfoPoint();
		timerDisplay[team].label = hqSpawningInStr;
		timerDisplay[team].font = "small";
		timerDisplay[team].alpha = 0;
		timerDisplay[team].archived = false;
		timerDisplay[team].hideWhenInMenu = true;
		timerDisplay[team].hideWhenInKillcam = true;
		timerDisplay[team].showplayerteamhudelemtospectator = true;
		
		thread hideTimerDisplayOnGameEnd( timerDisplay[team] );
	}
	
//	locationObjID = gameobjects::get_next_obj_id();
	
//	objective_add( locationObjID, "invisible", (0,0,0) );
	
	while( 1 )
	{
		iPrintLn( &"MP_HQ_REVEALED" );
		sound::play_on_players( "mp_suitcase_pickup" );
		globallogic_audio::leader_dialog( "hq_located" );
//		globallogic_audio::leader_dialog( "move_to_new" );
		
		level.radio.gameobject gameobjects::set_model_visibility( true );
		
		level.hqRevealTime = gettime();
		
		rcbombs = GetEntArray( "rcbomb","targetname" );
		radius = 75;
		for( index = 0; index < rcbombs.size; index ++ )
		{
			if( DistanceSquared( rcbombs[index], level.radio.origin ) < radius * radius )
			{
				rcbombs[index] notify( "rcbomb_shutdown" );
			}
		}
		
		if ( level.hqSpawnTime )
		{
//			nextObjPoint = objpoints::create( "objpoint_next_hq", level.radio.origin + level.iconoffset, "all", "waypoint_targetneutral" );
//			nextObjPoint setWayPoint( true, "waypoint_targetneutral" );
//			objective_position( locationObjID, level.radio.trigorigin );
//			objective_icon( locationObjID, "waypoint_targetneutral" );
//			objective_state( locationObjID, "active" );

			level.radio.gameobject gameobjects::set_visible_team( "any" );
			level.radio.gameobject gameobjects::set_flags( 1 );

			updateObjectiveHintMessage( level.objectiveHintPrepareHQ );
			
			foreach( team in level.teams )
			{
				timerDisplay[team].label = hqSpawningInStr;
				timerDisplay[team] setTimer( level.hqSpawnTime );
				timerDisplay[team].alpha = 1;
			}

			wait level.hqSpawnTime;

//			objpoints::delete( nextObjPoint );
//			objective_state( locationObjID, "invisible" );
			level.radio.gameobject gameobjects::set_flags( 0 );
			globallogic_audio::leader_dialog( "hq_online" );
		}

		foreach( team in level.teams )
		{
			timerDisplay[team].alpha = 0;
		}
		
		waittillframeend;
		
		globallogic_audio::leader_dialog( "obj_capture" );
		updateObjectiveHintMessage( level.objectiveHintCaptureHQ );
		sound::play_on_players( "mpl_hq_cap_us" );

		level.radio.gameobject gameobjects::enable_object();
		level.radio.gameobject.onUpdateUseRate =&onUpdateUseRate;
		
		level.radio.gameobject gameobjects::allow_use( "any" );
		level.radio.gameobject gameobjects::set_use_time( level.captureTime );
		level.radio.gameobject gameobjects::set_use_text( &"MP_CAPTURING_HQ" );
		
		//objective_icon( locationObjID, "compass_waypoint_captureneutral" );
//		level.radio.gameobject gameobjects::set_2d_icon( "enemy", "compass_waypoint_captureneutral" );
//		level.radio.gameobject gameobjects::set_3d_icon( "enemy", "waypoint_captureneutral" );
		level.radio.gameobject gameobjects::set_visible_team( "any" );
		level.radio.gameobject gameobjects::set_model_visibility( true );
		
		level.radio.gameobject.onUse =&onRadioCapture;
		level.radio.gameobject.onBeginUse =&onBeginUse;
		level.radio.gameobject.onEndUse =&onEndUse;
		
		level waittill( "hq_captured" );
		
		ownerTeam = level.radio.gameobject gameobjects::get_owner_team();
		
		if ( level.hqAutoDestroyTime )
		{
			thread DestroyHQAfterTime( level.hqAutoDestroyTime, ownerTeam );
			foreach( team in level.teams )
			{
				timerDisplay[team] setTimer( level.hqAutoDestroyTime );
			}
		}
		else
		{
			level.hqDestroyedByTimer = false;
		}
		
		while( 1 )
		{
			ownerTeam = level.radio.gameobject gameobjects::get_owner_team();
	
			foreach( team in level.teams )
			{
				updateObjectiveHintMessages( ownerTeam, level.objectiveHintDefendHQ, level.objectiveHintDestroyHQ );
			}
	
			level.radio.gameobject gameobjects::allow_use( "enemy" );
//			level.radio.gameobject gameobjects::set_2d_icon( "friendly", "compass_waypoint_defend" );
//			level.radio.gameobject gameobjects::set_3d_icon( "friendly", "waypoint_defend" );
//			level.radio.gameobject gameobjects::set_2d_icon( "enemy", "compass_waypoint_capture" );
//			level.radio.gameobject gameobjects::set_3d_icon( "enemy", "waypoint_capture" );

			if ( !level.kothMode )
				level.radio.gameobject gameobjects::set_use_text( &"MP_DESTROYING_HQ" );
			
			level.radio.gameobject.onUse =&onRadioDestroy;
			
			if ( level.hqAutoDestroyTime )
			{
				foreach( team in level.teams )
				{
					if ( team  == ownerTeam )
						timerDisplay[team].label = hqDestroyedInFriendlyStr;
					else 
						timerDisplay[team].label = hqDestroyedInEnemyStr;
						
					timerDisplay[team].alpha = 1;
				}
			}
			
			level thread dropAllAroundHQ();
			
			level waittill( "hq_destroyed", destroy_team );
			
			level.radio spawning::enable_influencers(false);

			if ( !level.kothMode || level.hqDestroyedByTimer )
				break;
			
			thread forceSpawnTeam( ownerTeam );
			
			if ( isdefined( destroy_team ) )
			{
				level.radio.gameobject gameobjects::set_owner_team( destroy_team );
			}
		}
		
		level.radio.gameobject gameobjects::disable_object();
		level.radio.gameobject gameobjects::allow_use( "none" );
		level.radio.gameobject gameobjects::set_owner_team( "neutral" );
		level.radio.gameobject gameobjects::set_model_visibility( false );
		
		level notify("hq_reset");
		
		foreach( team in level.teams )
		{
			timerDisplay[team].alpha = 0;
		}
				
		spawn_next_radio();
		
		wait .05;
		
		thread forceSpawnTeam( ownerTeam );
		
		wait 3.0;
	}
}


function hideTimerDisplayOnGameEnd( timerDisplay )
{
	level waittill("game_ended");
	timerDisplay.alpha = 0;
}


function forceSpawnTeam( team )
{
	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if ( !isdefined( player ) )
			continue;
		
		if ( player.pers["team"] == team )
		{
			player notify( "force_spawn" );
			wait .1;
		}
	}
}


function onBeginUse( player )
{
	ownerTeam = self gameobjects::get_owner_team();

	if ( ownerTeam == "neutral" )
	{
//		self.objPoints[player.pers["team"]] thread objpoints::start_flashing();
		player thread battlechatter::gametype_specific_battle_chatter( "hq_protect", player.pers["team"] );
	}
	else
	{
//		foreach( team in level.teams )
//		{
//			self.objPoints[team] thread objpoints::start_flashing();
//		}
		player thread battlechatter::gametype_specific_battle_chatter( "hq_attack", player.pers["team"] );
	}
}


function onEndUse( team, player, success )
{
//	foreach( team in level.teams )
//	{
//		self.objPoints[team] thread objpoints::stop_flashing();
//	}
	player notify( "event_ended" );
}


function onRadioCapture( player )
{
	capture_team = player.pers["team"];

	/#print( "radio captured" );#/

	string = &"MP_HQ_CAPTURED_BY";
	
	level.useStartSpawns = false;
	
	thread give_capture_credit( self.touchList[capture_team], string );

	oldTeam = gameobjects::get_owner_team();
	self gameobjects::set_owner_team( capture_team );
	if ( !level.kothMode )
		self gameobjects::set_use_time( level.destroyTime );
	
	foreach( team in level.teams )
	{
		if ( team == capture_team )
		{
			thread util::printOnTeamArg( &"MP_HQ_CAPTURED_BY", team, player );
			globallogic_audio::leader_dialog( "hq_secured", team );
			thread sound::play_on_players( "mp_war_objective_taken", team );
		}
		else
		{
			thread util::printOnTeam( &"MP_HQ_CAPTURED_BY_ENEMY", team );
			globallogic_audio::leader_dialog( "hq_enemy_captured", team );
			thread sound::play_on_players( "mp_war_objective_lost", team );
		}
	}
		
	level thread awardHQPoints( capture_team );
	
	level notify( "hq_captured" );
	player notify( "event_ended" );
}

function give_capture_credit( touchList, string )
{
	time = getTime();
	wait .05;
	util::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player_from_touchlist = touchList[players[i]].player;
		player_from_touchlist challenges::capturedObjective( time );
		scoreevents::processScoreEvent( "hq_secure", player_from_touchlist );
		player_from_touchlist RecordGameEvent("capture");

		level thread popups::DisplayTeamMessageToAll( string, player_from_touchlist );

		if( isdefined(player_from_touchlist.pers["captures"]) )
		{
			player_from_touchlist.pers["captures"]++;
			player_from_touchlist.captures = player_from_touchlist.pers["captures"];
		}

		demo::bookmark( "event", gettime(), player_from_touchlist );
		player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );
	}
}

function dropAllToGround( origin, radius, stickyObjectRadius )
{
	PhysicsExplosionSphere( origin, radius, radius, 0 );
	{wait(.05);};
	weapons::drop_all_to_ground( origin, radius );
	// grenades are now done in code when an entity they were on gets deleted
//	weapons::drop_grenades_to_ground( origin, radius );
	supplydrop::dropCratesToGround( origin, radius );
	level notify( "drop_objects_to_ground", origin, stickyObjectRadius );
}

function dropAllAroundHQ( radio )
{
	origin = level.radio.origin;
	level waittill( "hq_reset" );
	dropAllToGround( origin, 100, 50 );
}

function onRadioDestroy( firstPlayer )
{
	destroyed_team = firstPlayer.pers["team"];
	
	touchList = self.touchList[destroyed_team];

	touchListKeys = getArrayKeys( touchList );
	foreach( index in touchListKeys ) 
	{
		player = touchList[index].player;
		/#print( "radio destroyed" );#/
			
		scoreevents::processScoreEvent( "hq_destroyed", player );	
		player RecordGameEvent("destroy");	
		player AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
			
		if( isdefined(player.pers["destructions"]) )
		{
			player.pers["destructions"]++;
			player.destructions = player.pers["destructions"];
		}
	}
	
	destroyTeamMessage = &"MP_HQ_DESTROYED_BY";
	otherTeamMessage = &"MP_HQ_DESTROYED_BY_ENEMY";
	
	if ( level.kothMode )
	{
		destroyTeamMessage = &"MP_HQ_CAPTURED_BY";
		otherTeamMessage = &"MP_HQ_CAPTURED_BY_ENEMY";
	}
	
	level thread popups::DisplayTeamMessageToAll( destroyTeamMessage, player );

	foreach( team in level.teams )
	{
		if ( team == destroyed_team )
		{
			thread util::printOnTeamArg( destroyTeamMessage, team, player );
			globallogic_audio::leader_dialog( "hq_secured", team );
		}
		else
		{
			thread util::printOnTeam( otherTeamMessage, team );
			globallogic_audio::leader_dialog( "hq_enemy_destroyed", team );	
		}
	}

	level notify( "hq_destroyed", destroyed_team );
	
	if ( level.kothMode )
		level thread awardHQPoints( destroyed_team );

	player notify( "event_ended" );
}


function DestroyHQAfterTime( time, ownerTeam )
{
	level endon( "game_ended" );
	level endon( "hq_reset" );
	
	level.hqDestroyTime = gettime() + time * 1000;
	level.hqDestroyedByTimer = false;
	
	wait time;

	globallogic_audio::leader_dialog( "hq_offline" );

	level.hqDestroyedByTimer = true;
	checkPlayerCount( ownerTeam );

	level notify( "hq_destroyed" );
}

function checkPlayerCount( ownerTeam )
{
	lastPlayerAlive = undefined;
	players = level.players;

	for ( i = 0 ; i < players.size ; i++ )
	{
		if ( players[i].team != ownerTeam ) 
			continue;

		if ( IsAlive( players[i] ) )
		{
			if ( isdefined( lastPlayerAlive ) ) 
			{
				return; // more than one player alive
			}
			lastPlayerAlive = players[i];
		}
	}
	if ( isdefined ( lastPlayerAlive ) ) 
	{
		scoreevents::processScoreEvent( "defend_hq_last_man_alive", lastPlayerAlive );
	}
}

function awardHQPoints( team )
{
	level endon( "game_ended" );
	level endon( "hq_destroyed" );
	
	level notify("awardHQPointsRunning");
	level endon("awardHQPointsRunning");
	
	seconds = 5;
	
	while ( !level.gameEnded )
	{
		globallogic_score::giveTeamScoreForObjective( team, seconds );
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( player.pers["team"] == team )
			{
				//scoreevents::processScoreEvent( "defend", player );	
			}
		}
		
		wait seconds;
	}
}


function onSpawnPlayerUnified()
{
	spawning::onSpawnPlayer_Unified();
}

function onSpawnPlayer(predictedSpawn)
{
	spawnpoint = undefined;
	
	if ( !level.useStartSpawns )
	{
		if (isdefined(level.radio))
		{
			if (isdefined(level.radio.gameobject))
			{
				radioOwningTeam = level.radio.gameobject gameobjects::get_owner_team();
				if ( self.pers["team"] == radioOwningTeam )
					spawnpoint = spawnlogic::get_spawnpoint_near_team( level.spawn_all, level.radio.gameobject.nearSpawns );
				else if ( level.spawnDelay >= level.radioAutoMoveTime && gettime() > level.radioRevealTime + 10000 )
					spawnpoint = spawnlogic::get_spawnpoint_near_team( level.spawn_all );
				else
					spawnpoint = spawnlogic::get_spawnpoint_near_team( level.spawn_all, level.radio.gameobject.outerSpawns );
			}
		}
	}
	
	if ( !isdefined( spawnpoint ) )
	{
		spawnteam = self.pers["team"];
		spawnpoint = spawnlogic::get_spawnpoint_random(level.spawn_start[spawnteam]);
	}
	
	assert( isdefined(spawnpoint) );
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self spawn( spawnpoint.origin, spawnpoint.angles, "koth" );
	}
}


function koth_playerSpawnedCB()
{
	self.lowerMessageOverride = undefined;
}

function CompareRadioIndexes( radio_a, radio_b )
{
	script_index_a = radio_a.script_index;
	script_index_b = radio_b.script_index;
	
	if( !isdefined(script_index_a) && !isdefined(script_index_b) )
	{
		return false;
	}

	if( !isdefined(script_index_a) && isdefined(script_index_b) )
	{
/#
		println( "KOTH: Missing script_index on radio at " + radio_a.origin );
#/
		return true;
	}
	
	if( isdefined(script_index_a) && !isdefined(script_index_b) )
	{
/#
		println( "KOTH: Missing script_index on radio at " + radio_b.origin );
#/
		return false;
	}
	
	if( script_index_a > script_index_b )
	{
		return true;
	}
	
	return false;
}


function getRadioArray()
{
  radios = getentarray( "hq_hardpoint", "targetname" );

	if( !isdefined( radios ) )
	{
		return undefined;
	}
	
	swapped = true;
	n = radios.size;
	while ( swapped )
	{
		swapped = false;
		for( i = 0 ; i < n-1 ; i++ )
		{
			if( CompareRadioIndexes(radios[i], radios[i+1]) )
			{
				temp = radios[i];
				radios[i] = radios[i+1];
				radios[i+1] = temp;
				swapped = true;
			}
		}
		n--;
	}
	return radios;
}


function SetupRadios()
{
	maperrors = [];

	radios = getRadioArray();
	
	if ( radios.size < 2 )
	{
		maperrors[maperrors.size] = "There are not at least 2 entities with targetname \"radio\"";
	}
	
	trigs = getentarray("radiotrigger", "targetname");
	for ( i = 0; i < radios.size; i++ )
	{
		errored = false;
		
		radio = radios[i];
		radio.trig = undefined;
		for ( j = 0; j < trigs.size; j++ )
		{
			if ( radio istouching( trigs[j] ) )
			{
				if ( isdefined( radio.trig ) )
				{
					maperrors[maperrors.size] = "Radio at " + radio.origin + " is touching more than one \"radiotrigger\" trigger";
					errored = true;
					break;
				}
				radio.trig = trigs[j];
				break;
			}
		}
		
		if ( !isdefined( radio.trig ) )
		{
			if ( !errored )
			{
				maperrors[maperrors.size] = "Radio at " + radio.origin + " is not inside any \"radiotrigger\" trigger";
				continue;
			}
			
			// possible fallback (has been tested)
			//radio.trig = spawn( "trigger_radius", radio.origin, 0, 128, 128 );
			//errored = false;
		}
		
		assert( !errored );
		
		radio.trigorigin = radio.trig.origin;
		
		visuals = [];
		visuals[0] = radio;
		
		otherVisuals = getEntArray( radio.target, "targetname" );
		for ( j = 0; j < otherVisuals.size; j++ )
		{
			visuals[visuals.size] = otherVisuals[j];
		}
		
		objective_name = istring("objective");

		radio setUpNodes();

		radio.gameObject = gameobjects::create_use_object( "neutral", radio.trig, visuals, (radio.origin - radio.trigorigin), objective_name );
		radio.gameObject gameobjects::disable_object();
		radio.gameObject gameobjects::set_model_visibility( false );
		radio.trig.useObj = radio.gameObject;
		
		radio setUpNearbySpawns();
		radio createRadioSpawnInfluencer();
	}
	
	if (maperrors.size > 0)
	{
		/#
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		util::error("Map errors. See above");
		#/
		callback::abort_level();
		
		return;
	}
	
	level.radios = radios;
	
	level.prevradio = undefined;
	level.prevradio2 = undefined;
	
	return true;
}

function setUpNearbySpawns()
{
	spawns = level.spawn_all;
	
	for ( i = 0; i < spawns.size; i++ )
	{
		spawns[i].distsq = distanceSquared( spawns[i].origin, self.origin );
	}
	
	// sort by distsq
	for ( i = 1; i < spawns.size; i++ )
	{
		thespawn = spawns[i];
		for ( j = i - 1; j >= 0 && thespawn.distsq < spawns[j].distsq; j-- )
			spawns[j + 1] = spawns[j];
		spawns[j + 1] = thespawn;
	}
	
	first = [];
	second = [];
	third = [];
	outer = [];
	
	thirdSize = spawns.size / 3;
	for ( i = 0; i <= thirdSize; i++ )
	{
		first[ first.size ] = spawns[i];
	}
	for ( ; i < spawns.size; i++ )
	{
		outer[ outer.size ] = spawns[i];
		if ( i <= (thirdSize*2) )
			second[ second.size ] = spawns[i];
		else			
			third[ third.size ] = spawns[i];
	}
	
	self.gameObject.nearSpawns = first;
	self.gameObject.midSpawns = second;
	self.gameObject.farSpawns = third;
	self.gameObject.outerSpawns = outer;
}

function setUpNodes()
{
	self.points = [];
	temp = spawn( "script_model", ( 0, 0, 0 ) );
	
	maxs = self.trig GetPointInBounds( 1, 1, 1 );
	self.node_radius = Distance( self.trig.origin, maxs );

	points = GetNavPointsInRadius( self.trig.origin, 0, self.node_radius, 128 );

	foreach( point in points )
	{
		temp.origin = point;

		if ( temp IsTouching( self.trig ) )
		{
			self.points[ self.points.size ] = point;
		}
	}

	assert( self.points.size ); 
	temp delete();
}

function GetFirstRadio()
{
	radio = level.radios[ 0 ];

	// old linear and "random" systems 
	level.prevradio2 = level.prevradio;
	level.prevradio = radio;
	level.prevRadioIndex = 0;
	
	// new shuffled system
	ShuffleRadios();
	ArrayRemoveValue( level.radioSpawnQueue, radio );
	
	return radio;
}

function GetNextRadio()
{
	nextRadioIndex = 	(level.prevRadioIndex + 1) % level.radios.size;
	radio = level.radios[ nextRadioIndex ];
	level.prevradio2 = level.prevradio;
	level.prevradio = radio;
	level.prevRadioIndex = nextRadioIndex;
	
	return radio;
}

function PickRandomRadioToSpawn()
{
	level.prevRadioIndex = randomint( level.radios.size);
	radio = level.radios[ level.prevRadioIndex ];
	level.prevradio2 = level.prevradio;
	level.prevradio = radio;
	
	return radio;
}

function ShuffleRadios()
{
	level.radioSpawnQueue = [];

	spawnQueue = ArrayCopy(level.radios);	
	total_left = spawnQueue.size;
	
	while( total_left > 0 )
	{
		index = randomint( total_left );
		
		valid_radios = 0;
		for( radio = 0; radio < level.radios.size; radio++ )
		{
			if ( !isdefined(spawnQueue[radio]) )
				continue;
				
			if ( valid_radios == index )
			{
				// dont allow the last radio from the previous shuffle to be put first in the next
				if ( level.radioSpawnQueue.size == 0 && isdefined( level.radio ) && level.radio == spawnQueue[radio] )
					continue;
					
				level.radioSpawnQueue[level.radioSpawnQueue.size] = spawnQueue[radio];
				spawnQueue[radio] = undefined;
				break;
			}
			
			valid_radios++; 
		}
		
		total_left--;
	}
}

// shuffled picking
function GetNextRadioFromQueue()
{
	if ( level.radioSpawnQueue.size == 0 )
		ShuffleRadios();

	assert( level.radioSpawnQueue.size > 0 );

	next_radio = level.radioSpawnQueue[0];
	ArrayRemoveIndex( level.radioSpawnQueue, 0 );
	
	return next_radio;
}

function GetCountOfTeamsWithPlayers(num)
{
	has_players = 0;
	
	foreach( team in level.teams )
	{
		if ( num[team] > 0 )
			has_players++;
	}
	
	return has_players;
}

function GetPointCost( avgpos, origin )
{
	avg_distance = 0;
	total_error = 0;
	distances = [];
	
	foreach( team, position in avgpos )
	{
		distances[team] = Distance(origin, avgpos[team]);
		avg_distance += distances[team];
	}
	
	avg_distance = avg_distance / distances.size;
	
	foreach( team, dist in distances )
	{
		err = (distances[team] - avg_distance);
		total_error += err * err;
	}
	
	return total_error;
}

function PickRadioToSpawn()
{
	// find average of positions of each team
	// (medians would be better, to get rid of outliers...)
	// and find the radio which has the least difference in distance from those two averages
	
	foreach( team in level.teams )
	{	
		avgpos[team] = (0,0,0);
		num[team] = 0;
	}
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isalive( player ) )
		{
			avgpos[ player.pers["team"] ] += player.origin;
			num[ player.pers["team"] ]++;
		}
	}
	
	if ( GetCountOfTeamsWithPlayers(num) <= 1 )
	{
		radio = level.radios[ randomint( level.radios.size) ];
		while ( isdefined( level.prevradio ) && radio == level.prevradio ) // so lazy
			radio = level.radios[ randomint( level.radios.size) ];
		
		level.prevradio2 = level.prevradio;
		level.prevradio = radio;
		
		return radio;
	}
	
	foreach( team in level.teams )
	{	
		if ( num[team] == 0 )
		{
			avgpos[team] = undefined;
		}
		else
		{
			avgpos[team] = avgpos[team] / num[team];
		}
	}
		
	bestradio = undefined;
	lowestcost = undefined;
	for ( i = 0; i < level.radios.size; i++ )
	{
		radio = level.radios[i];
		
		// (purposefully using distance instead of distanceSquared)
		cost = GetPointCost( avgpos, radio.origin );
		
		if ( isdefined( level.prevradio ) && radio == level.prevradio )
		{
			continue;
		}
		if ( isdefined( level.prevradio2 ) && radio == level.prevradio2 )
		{
			if ( level.radios.size > 2 )
				continue;
			else
				cost += 512 * 512;
		}
		
		if ( !isdefined( lowestcost ) || cost < lowestcost )
		{
			lowestcost = cost;
			bestradio = radio;
		}
	}
	assert( isdefined( bestradio ) );
	
	level.prevradio2 = level.prevradio;
	level.prevradio = bestradio;
	
	return bestradio;
}

function onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}


function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || (!self.touchTriggers.size && !attacker.touchTriggers.size) || attacker.pers["team"] == self.pers["team"] )
		return;

	medalGiven = false;
	scoreEventProcessed = false;

	if ( attacker.touchTriggers.size )
	{
		triggerIds = getArrayKeys( attacker.touchTriggers );
		ownerTeam = attacker.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		team = attacker.pers["team"];
		if ( team == ownerTeam || ownerTeam == "neutral" )
		{
			if ( !medalGiven ) 
			{					
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}

				attacker medals::defenseGlobalCount();
				medalGiven = true;
				attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
				attacker RecordGameEvent("return");
			}
			
			attacker challenges::killedZoneAttacker( weapon );
			if (team != ownerTeam )
			{
				scoreevents::processScoreEvent( "kill_enemy_while_capping_hq", attacker, undefined, weapon );
			}
			else
			{
				scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, weapon );
			}
			self RecordKillModifier("assaulting");
			scoreEventProcessed = true;
		}
		else
		{
			if ( !medalGiven ) 
			{
				attacker medals::offenseGlobalCount();
				medalGiven = true;
				attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
			}
			scoreevents::processScoreEvent( "kill_enemy_while_capping_hq", attacker, undefined, weapon );
			self RecordKillModifier("defending");
			scoreEventProcessed = true;
		}		
	}

	if ( self.touchTriggers.size )
	{
		triggerIds = getArrayKeys( self.touchTriggers );
		ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		team = self.pers["team"];
		if ( team == ownerTeam )
		{
			if ( !medalGiven ) 
			{
				attacker medals::offenseGlobalCount();
				attacker AddPlayerStatWithGameType( "OFFENDS", 1 );			
				medalGiven = true;
			}
			if ( !scoreEventProcessed )
			{
				scoreevents::processScoreEvent( "killed_defender", attacker, undefined, weapon );
				self RecordKillModifier("defending");
				scoreEventProcessed = true;
			}
		}
		else
		{
			if ( !medalGiven ) 
			{
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}

				attacker medals::defenseGlobalCount();
				medalGiven = true;
				attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
				attacker RecordGameEvent("return");
			}
			
			if ( !scoreEventProcessed )
			{
				attacker challenges::killedZoneAttacker( weapon );
				scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, weapon );
				self RecordKillModifier("assaulting");
				scoreEventProcessed = true;
			}
		}
		
		if ( scoreEventProcessed == true )
		{
			attacker killWhileContesting( self.touchTriggers[triggerIds[0]].useObj );	
		}
	}	
	

}

function killWhileContesting( radio )
{	
 	self notify( "killWhileContesting" );
 	self endon( "killWhileContesting" );
 	self endon( "disconnect" );
 	
 	killTime = getTime();
 	playerteam = self.pers["team"];
 	if ( !isdefined ( self.clearEnemyCount ) )
 	{
 		self.clearEnemyCount = 0;
 	}
 	
 	self.clearEnemyCount++;
 	
 	radio waittill( "state_change" );
 			
 	if (playerteam != self.pers["team"] || ( isdefined( self.spawntime ) && ( killTime < self.spawntime ) ) )
 	{
 		self.clearEnemyCount = 0;
 		return;
 	}
 	if ( radio.ownerTeam != playerteam && radio.ownerTeam != "neutral" )
 	{
 		self.clearEnemyCount = 0;
 			return;	
 	}
 	
 	if ( self.clearEnemyCount >= 2 && killTime + 200 > getTime() )
 	{
 		scoreevents::processScoreEvent( "clear_2_attackers", self );
 	}
 	self.clearEnemyCount = 0;
}


function onEndGame( winningTeam )
{
	for ( i = 0; i < level.radios.size; i++ )
	{
		level.radios[i].gameobject gameobjects::allow_use( "none" );
	}
}

function createRadioSpawnInfluencer()
{	
		// this affects both teams
	self spawning::create_influencer( "hq_large", self.gameobject.curOrigin, 0 );
	self spawning::create_influencer( "hq_small", self.gameobject.curOrigin, 0 );

	// turn it off for now
	self spawning::enable_influencers(false);
}

function onUpdateUseRate()
{
	if ( !isdefined( self.currentContenderCount ) ) 
	{
		self.currentContenderCount = 0;
	}
	numOthers = gameobjects::get_num_touching_except_team( self.ownerteam ); // 0
	numOwners = self.numTouching[self.ownerteam]; // 1
	previousState = self.currentContenderCount;
	
	if ( numOthers == 0 && numOwners == 0 )
	{
		self.currentContenderCount = 0;
	}
	else
	{	
		if ( self.ownerteam == "neutral" )
		{
			numOtherClaim = gameobjects::get_num_touching_except_team( self.claimteam ); //1

			if ( numOtherClaim > 0 )
			{
				self.currentContenderCount = 2;
			}
			else
			{
				self.currentContenderCount = 1;
			}
		}
		else
		{
			if ( numOthers > 0 )
			{
				self.currentContenderCount = 1;
			}
			else
			{
				self.currentContenderCount = 0;
			}
		}
	}
	
	if ( self.currentContenderCount != previousState )
	{
		self notify( "state_change" );
	}
}