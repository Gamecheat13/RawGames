#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#define RANDOM_ZONE_LOCATIONS_OFF 0
#define RANDOM_ZONE_LOCATIONS_ON 1
#define RANDOM_ZONE_LOCATIONS_AFTER_FIRST 2

#define OBJECTIVE_FLAG_NORMAL 0
#define OBJECTIVE_FLAG_TARGET 1

/*QUAKED mp_multi_team_spawn (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Spawns used for use in some multi team game modes to open up other portions of the map for multi team scenarios.*/

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

	// Precache FX for client script
	LoadFX( "maps/mp_maps/fx_mp_koth_marker_neutral_1" ); 
	LoadFX( "maps/mp_maps/fx_mp_koth_marker_neutral_wndw" ); 


//	precacheShader( "compass_waypoint_captureneutral" );
//	precacheShader( "compass_waypoint_capture" );
//	precacheShader( "compass_waypoint_defend" );
//	precacheShader( "compass_waypoint_contested" );

//	precacheShader( "waypoint_targetneutral" );
//	precacheShader( "waypoint_captureneutral" );
//	precacheShader( "waypoint_capture" );
//	precacheShader( "waypoint_defend" );
//	precacheShader(	"waypoint_contested"); 
	
	precacheString( &"MP_WAITING_FOR_HQ" );
	precacheString ( &"MP_KOTH_CAPTURED_BY" );
	precacheString ( &"MP_KOTH_CAPTURED_BY_ENEMY" );
	precacheString ( &"MP_KOTH_MOVING_IN" );
	precacheString ( &"MP_CAPTURING_OBJECTIVE" );
	precacheString ( &"MP_KOTH_CONTESTED_BY_ENEMY" );
	precacheString ( &"MP_KOTH_AVAILABLE_IN" );
	
	RegisterClientField( "world", "hardpoint", 5, "int" );

	level.zoneAutoMoveTime = GetGametypeSetting( "autoDestroyTime" );
	level.zoneSpawnTime = GetGametypeSetting( "objectiveSpawnTime" );
	level.kothMode = GetGametypeSetting( "kothMode" );
	level.captureTime = GetGametypeSetting( "captureTime" );
	level.destroyTime = GetGametypeSetting( "destroyTime" );
	level.delayPlayer = GetGametypeSetting( "delayPlayer" );
	level.randomZoneSpawn = GetGametypeSetting( "randomObjectiveLocations" );
	level.scorePerPlayer = GetGametypeSetting( "scorePerPlayer" );
		
	level.iconoffset = (0,0,32);
	
	level.onRespawnDelay = ::getRespawnDelay;

	game["dialog"]["gametype"] = "koth_start";
	game["dialog"]["gametype_hardcore"] = "koth_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";

	level.lastDialogTime = 0;
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "captures", "defends" ); 

	maps\mp\gametypes\_globallogic_audio::registerDialogGroup( "gamemode_objective", false );
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

	if ( !isDefined( level.zone.gameobject ) )
		return undefined;
	
	zoneOwningTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	if ( self.pers["team"] == zoneOwningTeam )
	{
		if ( !isDefined( level.zoneMoveTime ) )
			return undefined;
		
		timeRemaining = (level.zoneMoveTime - gettime()) / 1000;

		if (!level.playerObjectiveHeldRespawnDelay )
			return undefined;

		if ( level.playerObjectiveHeldRespawnDelay >= level.zoneAutoMoveTime )
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
	
	level.objectiveHintPrepareZone = &"MP_CONTROL_KOTH";
	level.objectiveHintCaptureZone = &"MP_CAPTURE_KOTH";
	level.objectiveHintDefendHQ = &"MP_DEFEND_KOTH";
	precacheString( level.objectiveHintPrepareZone );
	precacheString( level.objectiveHintCaptureZone );
	precacheString( level.objectiveHintDefendHQ );
	
	if ( level.zoneSpawnTime )
		updateObjectiveHintMessage( level.objectiveHintPrepareZone );
	else
		updateObjectiveHintMessage( level.objectiveHintCaptureZone );
	
	setClientNameMode("auto_change");
	
	// TODO: HQ spawnpoints
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	foreach( team in level.teams )
	{
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( team, "mp_tdm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( team, "mp_multi_team_spawn" );

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
	
	allowed[0] = "koth";
//	allowed[1] = "hq";

	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	thread SetupZones();

	thread KothMainLoop();
}

spawn_first_zone(delay)
{
	// pick next Zone object
	if ( level.randomZoneSpawn == RANDOM_ZONE_LOCATIONS_ON )
	{
		level.zone = PickRandomZoneToSpawn();
	}
	else
	{
		level.zone = GetFirstZone();
	}
	
	if ( isdefined( level.zone ) )
	{
		logString("zone spawned: ("+level.zone.trigOrigin[0]+","+level.zone.trigOrigin[1]+","+level.zone.trigOrigin[2]+")");
		
		level.zone enable_zone_spawn_influencer(true);
	}
	
	return;
}

spawn_next_zone()
{
	// pick next Zone object
	if ( level.randomZoneSpawn != RANDOM_ZONE_LOCATIONS_OFF )
	{
		level.zone = PickZoneToSpawn();
	}
	else
	{
		level.zone = GetNextZone();
	}
	
	if ( isdefined( level.zone ) )
	{
		logString("zone spawned: ("+level.zone.trigOrigin[0]+","+level.zone.trigOrigin[1]+","+level.zone.trigOrigin[2]+")");
		
		level.zone enable_zone_spawn_influencer(true);
	}
	
	return;
}

getNumTouching( )
{
	numTouching = 0;
	foreach( team in level.teams )
	{
		numTouching += self.numTouching[team];
	}
	
	return numTouching;
}

toggleZoneEffects( enabled )
{
	index = 0;
	
	if ( enabled )
	{
		index = self.script_index;
	}
	
	level SetClientField( "hardpoint", index );
}

KothCaptureLoop()
{
	level endon("game_ended");
	level endon("zone_moved");
	
	while( 1 )
	{
		level.zone.gameobject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setUseTime( level.captureTime );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_OBJECTIVE" );
		
		numTouching = level.zone.gameobject getNumTouching( );

//		objective_icon( locationObjID, "compass_waypoint_captureneutral" );
		
//		if ( numTouching > 1 )
//		{
//			level.zone.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_contested" );
//			level.zone.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_contested" );
//		}
//		else
//		{
//			level.zone.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" );
//			level.zone.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" );
//		}
		
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::mustMaintainClaim( false );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::canContestClaim( true );
		
		level.zone.gameobject.onUse = ::onZoneCapture;
		level.zone.gameobject.onBeginUse = ::onBeginUse;
		level.zone.gameobject.onEndUse = ::onEndUse;
		level.zone.gameobject.onTouchUse = ::onTouchUse;
		level.zone.gameobject.onEndTouchUse = ::onEndTouchUse;

		level.zone toggleZoneEffects( true );

		msg = level waittill_any_return( "zone_captured", "zone_destroyed" );
	
		// this happens if it goes from contested to neutral
		if ( msg == "zone_destroyed" )
			continue;
			
		ownerTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();

		foreach( team in level.teams )
		{
			updateObjectiveHintMessages( ownerTeam, level.objectiveHintDefendHQ, level.objectiveHintCaptureZone );
		}

		level.zone.gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
		//level.zone.gameobject maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
//		level.zone.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
//		level.zone.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
//		level.zone.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" );
//		level.zone.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" );

//		if ( !level.kothMode )
//			level.zone.gameobject maps\mp\gametypes\_gameobjects::setUseText( &"MP_DESTROYING_HQ" );
		
		level.zone.gameobject.onUse = undefined;
		level.zone.gameobject.onUnoccupied = ::onZoneUnoccupied;
		level.zone.gameobject.onContested = ::onZoneContested;
			
		level waittill( "zone_destroyed", destroy_team );
		
		if ( !level.kothMode || level.zoneDestroyedByTimer )
			break;
		
		thread forceSpawnTeam( ownerTeam );
		
		if ( isdefined( destroy_team ) )
		{
			level.zone.gameobject maps\mp\gametypes\_gameobjects::setOwnerTeam( destroy_team );
		}
		else
		{
			level.zone.gameobject maps\mp\gametypes\_gameobjects::setOwnerTeam( "none" );
		}
	}
}

KothMainLoop()
{
	level endon("game_ended");
	
	level.zoneRevealTime = -100000;
	
	zoneSpawningInStr = &"MP_KOTH_AVAILABLE_IN";
	if ( level.kothMode )
	{
		zoneDestroyedInFriendlyStr = &"MP_HQ_DESPAWN_IN";
		zoneDestroyedInEnemyStr = &"MP_KOTH_MOVING_IN";
	}
	else
	{
		zoneDestroyedInFriendlyStr = &"MP_HQ_REINFORCEMENTS_IN";
		zoneDestroyedInEnemyStr = &"MP_HQ_DESPAWN_IN";
	}
	
	precacheString( zoneSpawningInStr );
	precacheString( zoneDestroyedInFriendlyStr );
	precacheString( zoneDestroyedInEnemyStr );
	precacheString( &"MP_CAPTURING_HQ" );
	precacheString( &"MP_DESTROYING_HQ" );
	
	objective_name = istring("objective");
	precachestring( objective_name );

	spawn_first_zone();
	
	while ( level.inPrematchPeriod )
		wait ( 0.05 );
	
	wait 5;
		
	timerDisplay = [];
	foreach ( team in level.teams )
	{
		timerDisplay[team] = createServerTimer( "objective", 1.4, team );
		timerDisplay[team] setGamemodeInfoPoint();
		timerDisplay[team].label = zoneSpawningInStr;
		timerDisplay[team].font = "extrasmall";
		timerDisplay[team].alpha = 0;
		timerDisplay[team].archived = false;
		timerDisplay[team].hideWhenInMenu = true;
		timerDisplay[team].hideWhenInKillcam = true;
		
		thread hideTimerDisplayOnGameEnd( timerDisplay[team] );
	}
	
	//locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	
	
	//objective_add( locationObjID, "invisible", (0,0,0), objective_name );
	
	while( 1 )
	{
		playSoundOnPlayers( "mp_suitcase_pickup" );
		maps\mp\gametypes\_globallogic_audio::flushGroupDialog( "gamemode_objective" );
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_located" );
//		maps\mp\gametypes\_globallogic_audio::leaderDialog( "move_to_new" );
		
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		
		level.zoneRevealTime = gettime();
	
		if ( level.zoneSpawnTime )
		{
//			nextObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_next_hq", level.zone.origin + level.iconoffset, "all", "waypoint_targetneutral" );
//			nextObjPoint setWayPoint( true, "waypoint_targetneutral" );
//			objective_position( locationObjID, level.zone.trigorigin );
//			objective_icon( locationObjID, "waypoint_targetneutral" );
//			objective_state( locationObjID, "active" );
	
			level.zone.gameobject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
			level.zone.gameobject maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_TARGET );

			updateObjectiveHintMessage( level.objectiveHintPrepareZone );
			
			foreach( team in level.teams )
			{
				timerDisplay[team].label = zoneSpawningInStr;
				timerDisplay[team] setTimer( level.zoneSpawnTime );
				timerDisplay[team].alpha = 1;
			}

			wait level.zoneSpawnTime;

//			maps\mp\gametypes\_objpoints::deleteObjPoint( nextObjPoint );
			level.zone.gameobject maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_NORMAL );
//			objective_state( locationObjID, "invisible" );
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_online" );
		}

		foreach( team in level.teams )
		{
			timerDisplay[team].alpha = 0;
		}
		
		waittillframeend;
		
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "obj_capture", undefined, "gamemode_objective" );
		updateObjectiveHintMessage( level.objectiveHintCaptureZone );
		playSoundOnPlayers( "mpl_hq_cap_us" );

		level.zone.gameobject maps\mp\gametypes\_gameobjects::enableObject();
		level.zone.gameobject.captureCount = 0;
		
		if ( level.zoneAutoMoveTime )
		{
			thread MoveZoneAfterTime( level.zoneAutoMoveTime );
			foreach( team in level.teams )
			{
				timerDisplay[team] setTimer( level.zoneAutoMoveTime );
			}
			
			foreach( team in level.teams )
			{
//				if ( team  == ownerTeam )
//					timerDisplay[team].label = zoneDestroyedInFriendlyStr;
//				else 
					timerDisplay[team].label = zoneDestroyedInEnemyStr;
					
				if ( !level.splitscreen )
					timerDisplay[team].alpha = 1;
			}
		}
		else
		{
			level.zoneDestroyedByTimer = false;
		}
	
		KothCaptureLoop();
		
		ownerTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		
		if ( level.zone.gameobject.captureCount == 1 )
		{
		// Copy touch list so there aren't any threading issues
		touchList = [];
		touchKeys = GetArrayKeys( level.zone.gameobject.touchList[ownerTeam] );
		for ( i = 0 ; i < touchKeys.size ; i++ )
			touchList[touchKeys[i]] = level.zone.gameobject.touchList[ownerTeam][touchKeys[i]];
			thread give_held_credit( touchList );		
		}
		
		level.zone enable_zone_spawn_influencer(false);
		level.zone.gameobject.lastCaptureTeam = undefined;
		level.zone.gameobject maps\mp\gametypes\_gameobjects::disableObject();
		level.zone.gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::mustMaintainClaim( false );
		level.zone toggleZoneEffects( false );
	
		level notify("zone_reset");
		
		foreach( team in level.teams )
		{
			timerDisplay[team].alpha = 0;
		}
				
		spawn_next_zone();
		
		wait 0.5;
		
		thread forceSpawnTeam( ownerTeam );
		
		wait 0.5;
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
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
		player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "hq_protect", player.pers["team"] );
	}
	else
	{
		foreach( team in level.teams )
		{
			self.objPoints[team] thread maps\mp\gametypes\_objpoints::startFlashing();
		}
		player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "hq_attack", player.pers["team"] );
	}
}


onEndUse( team, player, success )
{
	foreach( team in level.teams )
	{
		self.objPoints[team] thread maps\mp\gametypes\_objpoints::stopFlashing();
	}
	player notify( "event_ended" );
}


onTouchUse( player )
{
	player.preventTacticalInsertion = true;
}


onEndTouchUse( player )
{
	player.preventTacticalInsertion = undefined;
}


onZoneCapture( player )
{
	capture_team = player.pers["team"];

	player logString( "zone captured" );

	string = &"MP_KOTH_CAPTURED_BY";
	
	level.useStartSpawns = false;
	
	if ( !isdefined( self.lastCaptureTeam )  || self.lastCaptureTeam != capture_team )
	{
		// Copy touch list so there aren't any threading issues
		touchList = [];
		touchKeys = GetArrayKeys( self.touchList[capture_team] );
		for ( i = 0 ; i < touchKeys.size ; i++ )
			touchList[touchKeys[i]] = self.touchList[capture_team][touchKeys[i]];
		thread give_capture_credit( touchList, string );
	}

	oldTeam = maps\mp\gametypes\_gameobjects::getOwnerTeam();
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( capture_team );
	if ( !level.kothMode )
		self maps\mp\gametypes\_gameobjects::setUseTime( level.destroyTime );
	
	foreach( team in level.teams )
	{
		if ( team == capture_team )
		{
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_secured", team, "gamemode_objective" );
			thread playSoundOnPlayers( "mp_war_objective_taken", team );
		}
		else // if ( oldTeam == "neutral" || oldTeam == team )
		{
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_captured", team, "gamemode_objective" );
			thread playSoundOnPlayers( "mp_war_objective_lost", team );
		}
	}
			
	level thread awardCapturePoints( capture_team );
	self.captureCount++;
	self.lastCaptureTeam = capture_team;
	
	self maps\mp\gametypes\_gameobjects::mustMaintainClaim( true );
	
	level notify( "zone_captured" );
	player notify( "event_ended" );
}

give_capture_credit( touchList, string )
{
	wait .05;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player = touchList[players[i]].player;
		
		maps\mp\_scoreevents::processScoreEvent( "koth_secure", player, undefined, undefined, true );
		player recordgameevent("capture");

		level thread maps\mp\_popups::DisplayTeamMessageToAll( string, player );

		if( isdefined(player.pers["captures"]) )
		{
			player.pers["captures"]++;
			player.captures = player.pers["captures"];
		}

		maps\mp\_demo::bookmark( "event", gettime(), player );
		player AddPlayerStatWithGameType( "CAPTURES", 1 );
	}
}

give_held_credit( touchList, team )
{
	wait .05;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player = touchList[players[i]].player;
			
		maps\mp\_scoreevents::processScoreEvent( "koth_held", player, undefined, undefined, true );
		
		// do not know if we want either of the following
		//player recordgameevent("held");
		//player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );
	}
}

onZoneDestroy( player )
{
	destroyed_team = player.pers["team"];

	player logString( "zone destroyed" );
	maps\mp\_scoreevents::processScoreEvent( "zone_destroyed", player, undefined, undefined, true );	
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
		destroyTeamMessage = &"MP_KOTH_CAPTURED_BY";
		otherTeamMessage = &"MP_KOTH_CAPTURED_BY_ENEMY";
	}
	
	level thread maps\mp\_popups::DisplayTeamMessageToAll( destroyTeamMessage, player );

	foreach( team in level.teams )
	{
		if ( team == destroyed_team )
		{
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_secured", team, "gamemode_objective" );
		}
		else
		{
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_destroyed", team, "gamemode_objective" );	
		}
	}

	level notify( "zone_destroyed", destroyed_team );
	
	if ( level.kothMode )
		level thread awardCapturePoints( destroyed_team );

	player notify( "event_ended" );
}

onZoneUnoccupied()
{
//	lostTeamMessage = &"MP_KOTH_CAPTURED_BY";
//	
//	foreach( team in level.teams )
//	{
//		maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_destroyed", team );	
//	}

	level notify( "zone_destroyed" );
}

onZoneContested()
{
	level notify( "zone_destroyed" );
	
	zoneOwningTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	foreach( team in level.teams )
	{
		if ( team == zoneOwningTeam )
		{
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_contested", team, "gamemode_objective" );	
		}
	}

//	thread SetBackToNeutral();
}

//SetBackToNeutral()
//{
//	level endon( "zone_destroyed");
//	level endon( "zone_captured");
//	level endon( "zone_reset");
//	level endon( "game_ended");
//	
//	while( 1 )
//	{
//		numTouching = level.zone.gameobject getNumTouching( );
//		if ( numTouching == 0 )
//		{
//			level.zone.gameobject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" );
//			level.zone.gameobject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" );
//			return;
//		}
//		wait(0.1);
//	}
//}

MoveZoneAfterTime( time )
{
	level endon( "game_ended" );
	level endon( "zone_reset" );
	
	level.zoneMoveTime = gettime() + time * 1000;
	level.zoneDestroyedByTimer = false;
	
	wait time;

//	maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_offline" );

	level.zoneDestroyedByTimer = true;

	level notify( "zone_moved" );
}


awardCapturePoints( team )
{
	level endon( "game_ended" );
	level endon( "zone_destroyed" );
	level endon( "zone_reset" );
	level endon( "zone_moved" );
	
	level notify("awardCapturePointsRunning");
	level endon("awardCapturePointsRunning");
	
	seconds = 1;
	score = 1;
	
	while ( !level.gameEnded )
	{
		if ( level.scorePerPlayer )
		{
			score = level.zone.gameobject.numTouching[team];
		}
		
		maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( team, score );
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
		if (IsDefined(level.zone))
		{
			if (IsDefined(level.zone.gameobject))
			{
				zoneOwningTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
				if ( self.pers["team"] == zoneOwningTeam )
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.zone.gameobject.nearSpawns );
				else if ( level.spawnDelay >= level.zoneAutoMoveTime && gettime() > level.zoneRevealTime + 10000 )
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
				else
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.zone.gameobject.outerSpawns );
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

CompareZoneIndexes( zone_a, zone_b )
{
	script_index_a = zone_a.script_index;
	script_index_b = zone_b.script_index;
	
	if( !isdefined(script_index_a) && !isdefined(script_index_b) )
	{
		return false;
	}

	if( !isdefined(script_index_a) && isdefined(script_index_b) )
	{
/#
		println( "KOTH: Missing script_index on zone at " + zone_a.origin );
#/
		return true;
	}
	
	if( isdefined(script_index_a) && !isdefined(script_index_b) )
	{
/#
		println( "KOTH: Missing script_index on zone at " + zone_b.origin );
#/
		return false;
	}
	
	if( script_index_a > script_index_b )
	{
		return true;
	}
	
	return false;
}


getZoneArray()
{
  zones = getentarray( "koth_zone_center", "targetname" );

	if( !isDefined( zones ) )
	{
		return undefined;
	}
	
	swapped = true;
	n = zones.size;
	while ( swapped )
	{
		swapped = false;
		for( i = 0 ; i < n-1 ; i++ )
		{
			if( CompareZoneIndexes(zones[i], zones[i+1]) )
			{
				temp = zones[i];
				zones[i] = zones[i+1];
				zones[i+1] = temp;
				swapped = true;
			}
		}
		n--;
	}
	return zones;
}


SetupZones()
{
	maperrors = [];

	zones = getZoneArray();
	
//	if ( zones.size < 2 )
//	{
//		maperrors[maperrors.size] = "There are not at least 2 entities with targetname \"zone\"";
//	}
	
	trigs = getentarray("koth_zone_trigger", "targetname");
	for ( i = 0; i < zones.size; i++ )
	{
		errored = false;
		
		zone = zones[i];
		zone.trig = undefined;
		for ( j = 0; j < trigs.size; j++ )
		{
			if ( zone istouching( trigs[j] ) )
			{
				if ( isdefined( zone.trig ) )
				{
					maperrors[maperrors.size] = "Zone at " + zone.origin + " is touching more than one \"zonetrigger\" trigger";
					errored = true;
					break;
				}
				zone.trig = trigs[j];
				break;
			}
		}
		
		if ( !isdefined( zone.trig ) )
		{
			if ( !errored )
			{
				maperrors[maperrors.size] = "Zone at " + zone.origin + " is not inside any \"zonetrigger\" trigger";
				continue;
			}
			
			// possible fallback (has been tested)
			//zone.trig = spawn( "trigger_radius", zone.origin, 0, 128, 128 );
			//errored = false;
		}
		
		assert( !errored );
		
		zone.trigorigin = zone.trig.origin;
		
		visuals = [];
		visuals[0] = zone;
		
		if ( isdefined( zone.target ) )
		{
			otherVisuals = getEntArray( zone.target, "targetname" );
			for ( j = 0; j < otherVisuals.size; j++ )
			{
				visuals[visuals.size] = otherVisuals[j];
			}
		}
		
		objective_name = istring("objective");
		precachestring( objective_name );

		zone.gameObject = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", zone.trig, visuals, (zone.origin - zone.trigorigin), objective_name );
		zone.gameObject maps\mp\gametypes\_gameobjects::disableObject();
		zone.gameObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		zone.trig.useObj = zone.gameObject;
		zone setUpNearbySpawns();
		zone createZoneSpawnInfluencer();
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
	
	level.zones = zones;
	
	level.prevzone = undefined;
	level.prevzone2 = undefined;
	
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

GetFirstZone()
{
	zone = level.zones[ 0 ];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	level.prevZoneIndex = 0;
	return zone;
}

GetNextZone()
{
	nextZoneIndex = 	(level.prevZoneIndex + 1) % level.zones.size;
	zone = level.zones[ nextZoneIndex ];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	level.prevZoneIndex = nextZoneIndex;
	
	return zone;
}

PickRandomZoneToSpawn()
{
	level.prevZoneIndex = randomint( level.zones.size);
	zone = level.zones[ level.prevZoneIndex ];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	
	return zone;
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

PickZoneToSpawn()
{
	// find average of positions of each team
	// (medians would be better, to get rid of outliers...)
	// and find the zone which has the least difference in distance from those two averages
	
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
		zone = level.zones[ randomint( level.zones.size) ];
		while ( isDefined( level.prevzone ) && zone == level.prevzone ) // so lazy
			zone = level.zones[ randomint( level.zones.size) ];
		
		level.prevzone2 = level.prevzone;
		level.prevzone = zone;
		
		return zone;
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
		
	bestzone = undefined;
	lowestcost = undefined;
	for ( i = 0; i < level.zones.size; i++ )
	{
		zone = level.zones[i];
		
		// (purposefully using distance instead of distanceSquared)
		cost = GetPointCost( avgpos, zone.origin );
		
		if ( isdefined( level.prevzone ) && zone == level.prevzone )
		{
			continue;
		}
		if ( isdefined( level.prevzone2 ) && zone == level.prevzone2 )
		{
			if ( level.zones.size > 2 )
				continue;
			else
				cost += 512 * 512;
		}
		
		if ( !isdefined( lowestcost ) || cost < lowestcost )
		{
			lowestcost = cost;
			bestzone = zone;
		}
	}
	assert( isdefined( bestzone ) );
	
	level.prevzone2 = level.prevzone;
	level.prevzone = bestzone;
	
	return bestzone;
}

onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || (level.captureTime && !self.touchTriggers.size && !attacker.touchTriggers.size) || attacker.pers["team"] == self.pers["team"] )
		return;

	medalGiven = false;
	scoreEventProcessed = false;
	
	ownerTeam = undefined;
	
	if ( level.captureTime == 0 )
	{
		if ( !isdefined( level.zone ) )
			return;

		ownerTeam = level.zone.gameObject.ownerTeam ;
		
		if ( !isdefined( ownerTeam ) || ownerTeam == "neutral" )
			return;
	}
	
	if ( self.touchTriggers.size || ( level.captureTime == 0 && self IsTouching( level.zone.trig ) ) )
	{
		if ( level.captureTime > 0 )
		{
			triggerIds = getArrayKeys( self.touchTriggers );
			ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		}
		
		if ( ownerTeam != "neutral" )
		{
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
	}	
	
	if ( attacker.touchTriggers.size || ( level.captureTime == 0 && attacker IsTouching( level.zone.trig ) ) )
	{
		if ( level.captureTime > 0 )
		{
			triggerIds = getArrayKeys( attacker.touchTriggers );
			ownerTeam = attacker.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		}
		
		if ( ownerTeam != "neutral" )
		{
			team = attacker.pers["team"];
			if ( team == ownerTeam )
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
}

onEndGame( winningTeam )
{
	for ( i = 0; i < level.zones.size; i++ )
	{
		level.zones[i].gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
	}
}

createZoneSpawnInfluencer()
{
	koth_objective_influencer_score= level.spawnsystem.koth_objective_influencer_score;
	koth_objective_influencer_score_curve= level.spawnsystem.koth_objective_influencer_score_curve;
	koth_objective_influencer_radius= level.spawnsystem.koth_objective_influencer_radius;
	
	koth_objective_influencer_inner_score= level.spawnsystem.koth_objective_influencer_inner_score;
	koth_objective_influencer_inner_score_curve= level.spawnsystem.koth_objective_influencer_inner_score_curve;
	koth_objective_influencer_inner_radius= level.spawnsystem.koth_objective_influencer_inner_radius;
	
		// this affects both teams
	self.spawn_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.gameobject.curOrigin, 
							 koth_objective_influencer_radius,
							 koth_objective_influencer_score,
							 0,
							 "koth_objective,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(koth_objective_influencer_score_curve) );

	self.spawn_influencer_inner = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.gameobject.curOrigin, 
							 koth_objective_influencer_inner_radius,
							 koth_objective_influencer_inner_score,
							 0,
							 "koth_objective,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(koth_objective_influencer_inner_score_curve) );


	// turn it off for now
	self enable_zone_spawn_influencer(false);
}

enable_zone_spawn_influencer( enabled )
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

	// koth: influencer placed around the zone
	ss.koth_objective_influencer_score =	set_dvar_float_if_unset("scr_spawn_koth_objective_influencer_score", "1000", reset_dvars);
	ss.koth_objective_influencer_score_curve =	set_dvar_if_unset("scr_spawn_koth_objective_influencer_score_curve", "linear", reset_dvars);
	ss.koth_objective_influencer_radius =	set_dvar_float_if_unset("scr_spawn_koth_objective_influencer_radius", "" + 3300, reset_dvars);

	ss.koth_objective_influencer_inner_score =	-1100; //set_dvar_float_if_unset("scr_spawn_koth_objective_influencer_score", "-600", reset_dvars);
	ss.koth_objective_influencer_inner_score_curve =	"constant"; //set_dvar_if_unset("scr_spawn_koth_objective_influencer_score_curve", "constant", reset_dvars);
	ss.koth_objective_influencer_inner_radius = 1400;	//set_dvar_float_if_unset("scr_spawn_koth_objective_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);


	// koth: initial spawns influencer to help group starting players at predefined locations
	ss.koth_initial_spawns_influencer_score =	set_dvar_float_if_unset("scr_spawn_koth_initial_spawns_influencer_score", "200", reset_dvars);
	ss.koth_initial_spawns_influencer_score_curve =	set_dvar_if_unset("scr_spawn_koth_initial_spawns_influencer_score_curve", "linear", reset_dvars);
	ss.koth_initial_spawns_influencer_radius =	set_dvar_float_if_unset("scr_spawn_koth_initial_spawns_influencer_radius", "" + 10.0*get_player_height(), reset_dvars);
	
}
