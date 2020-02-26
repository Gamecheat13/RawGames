#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#define RANDOM_RADIO_LOCATIONS_OFF 0
#define RANDOM_RADIO_LOCATIONS_ON 1
#define RANDOM_RADIO_LOCATIONS_AFTER_FIRST 2

#define OBJECTIVE_FLAG_NORMAL 0
#define OBJECTIVE_FLAG_TARGET 1

main()
{
	if ( GetDvar( "mapname") == "mp_background" )
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 1000 );
	registerNumLives( 0, 10 );
	registerRoundSwitch( 0, 9 );
	registerRoundWinLimit( 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.scoreRoundBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.playerSpawnedCB = ::koth_playerSpawnedCB;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onEndGame= ::onEndGame;
	level.gamemodeSpawnDvars = ::koth_gamemodeSpawnDvars;

//	precacheShader( "compass_waypoint_captureneutral" );
//	precacheShader( "compass_waypoint_capture" );
//	precacheShader( "compass_waypoint_defend" );
//
//	precacheShader( "waypoint_targetneutral" );
//	precacheShader( "waypoint_captureneutral" );
//	precacheShader( "waypoint_capture" );
//	precacheShader( "waypoint_defend" );
	
	precacheString( &"MP_WAITING_FOR_HQ" );
	precacheString ( &"MP_HQ_CAPTURED_BY" );
	
	level.hqAutoDestroyTime = GetGametypeSetting( "autoDestroyTime" );
	level.hqSpawnTime = GetGametypeSetting( "objectiveSpawnTime" );
	level.kothMode = GetGametypeSetting( "kothMode" );
	level.captureTime = GetGametypeSetting( "captureTime" );
	level.destroyTime = GetGametypeSetting( "destroyTime" );
	level.delayPlayer = GetGametypeSetting( "delayPlayer" );
	level.randomHQSpawn = GetGametypeSetting( "randomObjectiveLocations" );
		
	level.iconoffset = (0,0,32);
	
	level.onRespawnDelay = ::getRespawnDelay;

	game["dialog"]["gametype"] = "hq_start";
	game["dialog"]["gametype_hardcore"] = "hchq_start";
	//game["dialog"]["neutral_obj"] = "cap_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";
	//game["dialog"]["hq_defend"] = "hq_defend";

	level.lastDialogTime = 0;
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "captures", "defends" ); 
}


updateObjectiveHintMessageOnPlayers()
{
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
		{
			hintText = getObjectiveHintText( player.pers["team"] );
			player DisplayGameModeMessage( hintText, "uin_alert_slideout" );
		}
	}
}

updateObjectiveHintMessages( defenderTeam, defendMessage, attackMessage )
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
	
	updateObjectiveHintMessageOnPlayers();
}

updateObjectiveHintMessage( message )
{
	foreach( team in level.teams )
	{
		game["strings"]["objective_hint_" + team] = message;
	}
		
	updateObjectiveHintMessageOnPlayers();
}

getRespawnDelay()
{
	self.lowerMessageOverride = undefined;

	if ( !isDefined( level.radio.gameobject ) )
		return undefined;
	
	hqOwningTeam = level.radio.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	if ( self.pers["team"] == hqOwningTeam )
	{
		if ( !isDefined( level.hqDestroyTime ) )
			return undefined;
		
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

getTeamStartSpawnName( team )
{
		spawn_point_team_name = team;
		
		// for multi-team using slightly different start spawns for axis and allies
		if ( level.multiTeam )
		{
			if ( team == "axis" )
			 	spawn_point_team_name = "team1";
			else if ( team == "allies" )
			 	spawn_point_team_name = "team2";
		}
		
		return "mp_tdm_spawn_" + spawn_point_team_name + "_start" ;
}


onStartGameType()
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
	
	
	maps\mp\gametypes\_globallogic_score::resetTeamScores();
	
	foreach( team in level.teams )
	{
		setObjectiveText( team, &"OBJECTIVES_KOTH" );
	
		if ( level.splitscreen )
		{
			setObjectiveScoreText( team, &"OBJECTIVES_KOTH" );
		}
		else
		{
			setObjectiveScoreText( team, &"OBJECTIVES_KOTH_SCORE" );
		}
	}
	
	level.objectiveHintPrepareHQ = &"MP_CONTROL_HQ";
	level.objectiveHintCaptureHQ = &"MP_CAPTURE_HQ";
	level.objectiveHintDestroyHQ = &"MP_DESTROY_HQ";
	level.objectiveHintDefendHQ = &"MP_DEFEND_HQ";
	precacheString( level.objectiveHintPrepareHQ );
	precacheString( level.objectiveHintCaptureHQ );
	precacheString( level.objectiveHintDestroyHQ );
	precacheString( level.objectiveHintDefendHQ );
	
	if ( level.kothMode )
		level.objectiveHintDestroyHQ = level.objectiveHintCaptureHQ;
	
	if ( level.hqSpawnTime )
		updateObjectiveHintMessage( level.objectiveHintPrepareHQ );
	else
		updateObjectiveHintMessage( level.objectiveHintCaptureHQ );
	
	setClientNameMode("auto_change");
	
	// TODO: HQ spawnpoints
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	foreach( team in level.teams )
	{
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( team, "mp_tdm_spawn" );
		
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( getTeamStartSpawnName(team) );
	}
	
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  maps\mp\gametypes\_spawnlogic::getSpawnpointArray( getTeamStartSpawnName(team) );
	}
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_all = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );
	if ( !level.spawn_all.size )
	{
/#
		println("^1No mp_tdm_spawn spawnpoints in level!");
#/
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	
	allowed[0] = "hq";

	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	thread SetupRadios();

	thread HQMainLoop();
}

spawn_first_radio(delay)
{
	// pick next HQ object
	if ( level.randomHQSpawn == RANDOM_RADIO_LOCATIONS_ON )
	{
		level.radio = PickRandomRadioToSpawn();
	}
	else
	{
		level.radio = GetFirstRadio();
	}
	
	logString("radio spawned: ("+level.radio.trigOrigin[0]+","+level.radio.trigOrigin[1]+","+level.radio.trigOrigin[2]+")");
	
	level.radio enable_radio_spawn_influencer(true);
	
	return;
}

spawn_next_radio()
{
	// pick next HQ object
	if ( level.randomHQSpawn != RANDOM_RADIO_LOCATIONS_OFF )
	{
		level.radio = PickRadioToSpawn();
	}
	else
	{
		level.radio = GetNextRadio();
	}
	
	logString("radio spawned: ("+level.radio.trigOrigin[0]+","+level.radio.trigOrigin[1]+","+level.radio.trigOrigin[2]+")");
	
	level.radio enable_radio_spawn_influencer(true);
	
	return;
}

HQMainLoop()
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
	
	precacheString( hqSpawningInStr );
	precacheString( hqDestroyedInFriendlyStr );
	precacheString( hqDestroyedInEnemyStr );
	precacheString( &"MP_CAPTURING_HQ" );
	precacheString( &"MP_DESTROYING_HQ" );
	
	spawn_first_radio();
	
	objective_name = istring("objective");
	precachestring( objective_name );

	while ( level.inPrematchPeriod )
		wait ( 0.05 );
	
	wait 5;
		
	timerDisplay = [];
	foreach ( team in level.teams )
	{
		timerDisplay[team] = createServerTimer( "objective", 1.4, team );
		timerDisplay[team] setGamemodeInfoPoint();
		timerDisplay[team].label = hqSpawningInStr;
		timerDisplay[team].font = "small";
		timerDisplay[team].alpha = 0;
		timerDisplay[team].archived = false;
		timerDisplay[team].hideWhenInMenu = true;
		timerDisplay[team].hideWhenInKillcam = true;
		
		thread hideTimerDisplayOnGameEnd( timerDisplay[team] );
	}
	
//	locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	
//	objective_add( locationObjID, "invisible", (0,0,0) );
	
	while( 1 )
	{
		iPrintLn( &"MP_HQ_REVEALED" );
		playSoundOnPlayers( "mp_suitcase_pickup" );
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_located" );
//		maps\mp\gametypes\_globallogic_audio::leaderDialog( "move_to_new" );
		
		level.radio.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		
		level.hqRevealTime = gettime();
		
		maps\mp\killstreaks\_rcbomb::detonateAllIfTouchingSphere(level.radio.origin, 75);
	
		if ( level.hqSpawnTime )
		{
//			nextObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_next_hq", level.radio.origin + level.iconoffset, "all", "waypoint_targetneutral" );
//			nextObjPoint setWayPoint( true, "waypoint_targetneutral" );
//			objective_position( locationObjID, level.radio.trigorigin );
//			objective_icon( locationObjID, "waypoint_targetneutral" );
//			objective_state( locationObjID, "active" );

			level.radio.gameobject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
			level.radio.gameobject maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_TARGET );

			updateObjectiveHintMessage( level.objectiveHintPrepareHQ );
			
			foreach( team in level.teams )
			{
				timerDisplay[team].label = hqSpawningInStr;
				timerDisplay[team] setTimer( level.hqSpawnTime );
				timerDisplay[team].alpha = 1;
			}

			wait level.hqSpawnTime;

//			maps\mp\gametypes\_objpoints::deleteObjPoint( nextObjPoint );
//			objective_state( locationObjID, "invisible" );
			level.radio.gameobject maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_NORMAL );
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_online" );
		}

		foreach( team in level.teams )
		{
			timerDisplay[team].alpha = 0;
		}
		
		waittillframeend;
		
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "obj_capture" );
		updateObjectiveHintMessage( level.objectiveHintCaptureHQ );
		playSoundOnPlayers( "mpl_hq_cap_us" );

		level.radio.gameobject maps\mp\gametypes\_gameobjects::enableObject();
		
		level.radio.gameobject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		level.radio.gameobject maps\mp\gametypes\_gameobjects::setUseTime( level.captureTime );
		level.radio.gameobject maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_HQ" );
		
		//objective_icon( locationObjID, "compass_waypoint_captureneutral" );
//		level.radio.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" );
//		level.radio.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" );
		level.radio.gameobject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		level.radio.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		
		level.radio.gameobject.onUse = ::onRadioCapture;
		level.radio.gameobject.onBeginUse = ::onBeginUse;
		level.radio.gameobject.onEndUse = ::onEndUse;
		
		level waittill( "hq_captured" );
		
		ownerTeam = level.radio.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		
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
			ownerTeam = level.radio.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
			foreach( team in level.teams )
			{
				updateObjectiveHintMessages( ownerTeam, level.objectiveHintDefendHQ, level.objectiveHintDestroyHQ );
			}
	
			level.radio.gameobject maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
//			level.radio.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
//			level.radio.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
//			level.radio.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" );
//			level.radio.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" );

			if ( !level.kothMode )
				level.radio.gameobject maps\mp\gametypes\_gameobjects::setUseText( &"MP_DESTROYING_HQ" );
			
			level.radio.gameobject.onUse = ::onRadioDestroy;
			
			if ( level.hqAutoDestroyTime )
			{
				foreach( team in level.teams )
				{
					if ( team  == ownerTeam )
						timerDisplay[team].label = hqDestroyedInFriendlyStr;
					else 
						timerDisplay[team].label = hqDestroyedInEnemyStr;
						
					if ( !level.splitscreen )
						timerDisplay[team].alpha = 1;
				}
			}
			
			level thread dropAllAroundHQ();
			
			level waittill( "hq_destroyed", destroy_team );
			
			level.radio enable_radio_spawn_influencer(false);

			if ( !level.kothMode || level.hqDestroyedByTimer )
				break;
			
			thread forceSpawnTeam( ownerTeam );
			
			if ( isdefined( destroy_team ) )
			{
				level.radio.gameobject maps\mp\gametypes\_gameobjects::setOwnerTeam( destroy_team );
			}
		}
		
		level.radio.gameobject maps\mp\gametypes\_gameobjects::disableObject();
		level.radio.gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
		level.radio.gameobject maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
		level.radio.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		
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


hideTimerDisplayOnGameEnd( timerDisplay )
{
	level waittill("game_ended");
	timerDisplay.alpha = 0;
}


forceSpawnTeam( team )
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


onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	if ( ownerTeam == "neutral" )
	{
//		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
		player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "hq_protect", player.pers["team"] );
	}
	else
	{
//		foreach( team in level.teams )
//		{
//			self.objPoints[team] thread maps\mp\gametypes\_objpoints::startFlashing();
//		}
		player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "hq_attack", player.pers["team"] );
	}
}


onEndUse( team, player, success )
{
//	foreach( team in level.teams )
//	{
//		self.objPoints[team] thread maps\mp\gametypes\_objpoints::stopFlashing();
//	}
	player notify( "event_ended" );
}


onRadioCapture( player )
{
	capture_team = player.pers["team"];

	player logString( "radio captured" );

	string = &"MP_HQ_CAPTURED_BY";
	
	level.useStartSpawns = false;
	
	thread give_capture_credit( self.touchList[capture_team], string );

	oldTeam = maps\mp\gametypes\_gameobjects::getOwnerTeam();
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( capture_team );
	if ( !level.kothMode )
		self maps\mp\gametypes\_gameobjects::setUseTime( level.destroyTime );
	
	foreach( team in level.teams )
	{
		if ( team == capture_team )
		{
			thread printOnTeamArg( &"MP_HQ_CAPTURED_BY", team, player );
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_secured", team );
			thread playSoundOnPlayers( "mp_war_objective_taken", team );
		}
		else
		{
			thread printOnTeam( &"MP_HQ_CAPTURED_BY_ENEMY", team );
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_enemy_captured", team );
			thread playSoundOnPlayers( "mp_war_objective_lost", team );
		}
	}
		
	level thread awardHQPoints( capture_team );
	
	level notify( "hq_captured" );
	player notify( "event_ended" );
}

give_capture_credit( touchList, string )
{
	wait .05;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player_from_touchlist = touchList[players[i]].player;
		maps\mp\_scoreevents::processScoreEvent( "hq_secure", player_from_touchlist, undefined, undefined, true );
		player_from_touchlist recordgameevent("capture");

		level thread maps\mp\_popups::DisplayTeamMessageToAll( string, player_from_touchlist );

		if( isdefined(player_from_touchlist.pers["captures"]) )
		{
			player_from_touchlist.pers["captures"]++;
			player_from_touchlist.captures = player_from_touchlist.pers["captures"];
		}

		maps\mp\_demo::bookmark( "event", gettime(), player_from_touchlist );
		player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );
	}
}

dropAllAroundHQ( radio )
{
	origin = level.radio.origin;
	level waittill( "hq_reset" );
	dropAllToGround( origin, 100, 50 );
}

onRadioDestroy( player )
{
	destroyed_team = player.pers["team"];

	player logString( "radio destroyed" );
	maps\mp\_scoreevents::processScoreEvent( "hq_destroyed", player, undefined, undefined, true );	
	player recordgameevent("destroy");	
	player AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
		
	if( isdefined(player.pers["destructions"]) )
	{
		player.pers["destructions"]++;
		player.destructions = player.pers["destructions"];
	}
	
	destroyTeamMessage = &"MP_HQ_DESTROYED_BY";
	otherTeamMessage = &"MP_HQ_DESTROYED_BY_ENEMY";
	
	if ( level.kothMode )
	{
		destroyTeamMessage = &"MP_HQ_CAPTURED_BY";
		otherTeamMessage = &"MP_HQ_CAPTURED_BY_ENEMY";
	}
	
	level thread maps\mp\_popups::DisplayTeamMessageToAll( destroyTeamMessage, player );

	foreach( team in level.teams )
	{
		if ( team == destroyed_team )
		{
			thread printOnTeamArg( destroyTeamMessage, team, player );
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_secured", team );
		}
		else
		{
			thread printOnTeam( otherTeamMessage, team );
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_enemy_destroyed", team );	
		}
	}

	level notify( "hq_destroyed", destroyed_team );
	
	if ( level.kothMode )
		level thread awardHQPoints( destroyed_team );

	player notify( "event_ended" );
}


DestroyHQAfterTime( time, ownerTeam )
{
	level endon( "game_ended" );
	level endon( "hq_reset" );
	
	level.hqDestroyTime = gettime() + time * 1000;
	level.hqDestroyedByTimer = false;
	
	wait time;

	maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_offline" );

	level.hqDestroyedByTimer = true;
	checkPlayerCount( ownerTeam );

	level notify( "hq_destroyed" );
}

checkPlayerCount( ownerTeam )
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
		maps\mp\_scoreevents::processScoreEvent( "defend_hq_last_man_alive", lastPlayerAlive );
	}
}

awardHQPoints( team )
{
	level endon( "game_ended" );
	level endon( "hq_destroyed" );
	
	level notify("awardHQPointsRunning");
	level endon("awardHQPointsRunning");
	
	seconds = 5;
	
	while ( !level.gameEnded )
	{
		maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( team, seconds );
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( player.pers["team"] == team )
			{
				//maps\mp\_scoreevents::processScoreEvent( "defend", player );	
			}
		}
		
		wait seconds;
	}
}


onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer(predictedSpawn)
{
	spawnpoint = undefined;
	
	if ( !level.useStartSpawns )
	{
		if (IsDefined(level.radio))
		{
			if (IsDefined(level.radio.gameobject))
			{
				radioOwningTeam = level.radio.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
				if ( self.pers["team"] == radioOwningTeam )
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.radio.gameobject.nearSpawns );
				else if ( level.spawnDelay >= level.radioAutoMoveTime && gettime() > level.radioRevealTime + 10000 )
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
				else
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.radio.gameobject.outerSpawns );
			}
		}
	}
	
	if ( !isdefined( spawnpoint ) )
	{
		spawnteam = self.pers["team"];
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_start[spawnteam]);
	}
	
	assert( isDefined(spawnpoint) );
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self spawn( spawnpoint.origin, spawnpoint.angles, "koth" );
	}
}


koth_playerSpawnedCB()
{
	self.lowerMessageOverride = undefined;
}

CompareRadioIndexes( radio_a, radio_b )
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


getRadioArray()
{
  radios = getentarray( "hq_hardpoint", "targetname" );

	if( !isDefined( radios ) )
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


SetupRadios()
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
		precachestring( objective_name );

		radio.gameObject = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", radio.trig, visuals, (radio.origin - radio.trigorigin), objective_name );
		radio.gameObject maps\mp\gametypes\_gameobjects::disableObject();
		radio.gameObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
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
		
		maps\mp\_utility::error("Map errors. See above");
		#/
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		
		return;
	}
	
	level.radios = radios;
	
	level.prevradio = undefined;
	level.prevradio2 = undefined;
	
	return true;
}

setUpNearbySpawns()
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

GetFirstRadio()
{
	radio = level.radios[ 0 ];
	level.prevradio2 = level.prevradio;
	level.prevradio = radio;
	level.prevRadioIndex = 0;
	return radio;
}

GetNextRadio()
{
	nextRadioIndex = 	(level.prevRadioIndex + 1) % level.radios.size;
	radio = level.radios[ nextRadioIndex ];
	level.prevradio2 = level.prevradio;
	level.prevradio = radio;
	level.prevRadioIndex = nextRadioIndex;
	
	return radio;
}

PickRandomRadioToSpawn()
{
	level.prevRadioIndex = randomint( level.radios.size);
	radio = level.radios[ level.prevRadioIndex ];
	level.prevradio2 = level.prevradio;
	level.prevradio = radio;
	
	return radio;
}

GetCountOfTeamsWithPlayers(num)
{
	has_players = 0;
	
	foreach( team in level.teams )
	{
		if ( num[team] > 0 )
			has_players++;
	}
	
	return has_players;
}

GetPointCost( avgpos, origin )
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

PickRadioToSpawn()
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
		while ( isDefined( level.prevradio ) && radio == level.prevradio ) // so lazy
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

onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || (!self.touchTriggers.size && !attacker.touchTriggers.size) || attacker.pers["team"] == self.pers["team"] )
		return;

	medalGiven = false;
	scoreEventProcessed = false;

	if ( self.touchTriggers.size )
	{
		triggerIds = getArrayKeys( self.touchTriggers );
		ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		team = self.pers["team"];
		if ( team == ownerTeam )
		{
			if ( !medalGiven && !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) ) 
			{
				attacker maps\mp\_medals::offense( sWeapon );
				attacker AddPlayerStatWithGameType( "OFFENDS", 1 );			
				medalGiven = true;
			}
			maps\mp\_scoreevents::processScoreEvent( "killed_defender", attacker, undefined, undefined, true );
			self recordKillModifier("defending");
			scoreEventProcessed = true;
		}
		else
		{
			if ( !medalGiven && !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon )  ) 
			{
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}

				attacker maps\mp\_medals::defense( sWeapon );
				medalGiven = true;
				attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
			}
			maps\mp\_scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, undefined, true );
			self recordKillModifier("assaulting");
			scoreEventProcessed = true;
		}
	}	
	
	if ( attacker.touchTriggers.size )
	{
		triggerIds = getArrayKeys( attacker.touchTriggers );
		ownerTeam = attacker.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		team = attacker.pers["team"];
		if ( team == ownerTeam || ownerTeam == "neutral" )
		{
			if ( !medalGiven && !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon )  ) 
			{					
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}

				attacker maps\mp\_medals::defense( sWeapon );
				medalGiven = true;
				attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
			}
			
			if ( scoreEventProcessed == false )
			{
				maps\mp\_scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, undefined, true );
				self recordKillModifier("assaulting");
			}
		}
		else
		{
			if ( !medalGiven && !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon )  ) 
			{
				attacker maps\mp\_medals::offense( sWeapon );
				medalGiven = true;
				attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
			}
			if ( scoreEventProcessed == false )
			{
				maps\mp\_scoreevents::processScoreEvent( "killed_defender", attacker, undefined, undefined, true );
				self recordKillModifier("defending");
			}
		}		
	}
}

onEndGame( winningTeam )
{
	for ( i = 0; i < level.radios.size; i++ )
	{
		level.radios[i].gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
	}
}

createRadioSpawnInfluencer()
{
	hq_objective_influencer_score= level.spawnsystem.hq_objective_influencer_score;
	hq_objective_influencer_score_curve= level.spawnsystem.hq_objective_influencer_score_curve;
	hq_objective_influencer_radius= level.spawnsystem.hq_objective_influencer_radius;
	
	hq_objective_influencer_inner_score= level.spawnsystem.hq_objective_influencer_inner_score;
	hq_objective_influencer_inner_score_curve= level.spawnsystem.hq_objective_influencer_inner_score_curve;
	hq_objective_influencer_inner_radius= level.spawnsystem.hq_objective_influencer_inner_radius;
	
		// this affects both teams
	self.spawn_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.gameobject.curOrigin, 
							 hq_objective_influencer_radius,
							 hq_objective_influencer_score,
							 0,
							 "hq_objective,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(hq_objective_influencer_score_curve) );

	self.spawn_influencer_inner = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.gameobject.curOrigin, 
							 hq_objective_influencer_inner_radius,
							 hq_objective_influencer_inner_score,
							 0,
							 "hq_objective_inner,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(hq_objective_influencer_inner_score_curve) );


	// turn it off for now
	self enable_radio_spawn_influencer(false);
}

enable_radio_spawn_influencer( enabled )
{
	if ( isdefined(self.spawn_influencer) )
	{
		enableinfluencer(self.spawn_influencer, enabled);
		enableinfluencer(self.spawn_influencer_inner, enabled);
	}
}

koth_gamemodeSpawnDvars(reset_dvars)
{
	ss = level.spawnsystem;

	// koth (hq): influencer placed around the radio
	ss.hq_objective_influencer_score =	set_dvar_float_if_unset("scr_spawn_hq_objective_influencer_score", "600", reset_dvars);
	ss.hq_objective_influencer_score_curve =	set_dvar_if_unset("scr_spawn_hq_objective_influencer_score_curve", "linear", reset_dvars);
	ss.hq_objective_influencer_radius =	set_dvar_float_if_unset("scr_spawn_hq_objective_influencer_radius", "" + 3300, reset_dvars);

	ss.hq_objective_influencer_inner_score =	set_dvar_float_if_unset("scr_spawn_hq_objective_influencer_inner_score", "-1100", reset_dvars);
	ss.hq_objective_influencer_inner_score_curve =	"constant"; //set_dvar_if_unset("scr_spawn_hq_objective_influencer_score_curve", "constant", reset_dvars);
	ss.hq_objective_influencer_inner_radius = set_dvar_float_if_unset("scr_spawn_hq_objective_influencer_inner_radius", "2000", reset_dvars);


	// koth (hq): initial spawns influencer to help group starting players at predefined locations
	ss.hq_initial_spawns_influencer_score =	set_dvar_float_if_unset("scr_spawn_hq_initial_spawns_influencer_score", "200", reset_dvars);
	ss.hq_initial_spawns_influencer_score_curve =	set_dvar_if_unset("scr_spawn_hq_initial_spawns_influencer_score_curve", "linear", reset_dvars);
	ss.hq_initial_spawns_influencer_radius =	set_dvar_float_if_unset("scr_spawn_hq_initial_spawns_influencer_radius", "" + 10.0*get_player_height(), reset_dvars);
	
}
