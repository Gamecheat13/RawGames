#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


RANDOM_ZONE_LOCATIONS_OFF = 0;
RANDOM_ZONE_LOCATIONS_ON = 1;
RANDOM_ZONE_LOCATIONS_AFTER_FIRST = 2;

OBJECTIVE_FLAG_NORMAL = 0;
OBJECTIVE_FLAG_TARGET = 1;

/*QUAKED mp_multi_team_spawn (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Spawns used for use in some multi team game modes to open up other portions of the map for multi team scenarios.*/

main()
{
	if ( GetDvar( "mapname") == "mp_background" )
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if ( isUsingMatchRulesData() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();
	}
	else
	{
		registerTimeLimitDvar( level.gameType, 30 );
		registerScoreLimitDvar( level.gameType, 300 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;	
	}

	level.teamBased = true;
	level.hpStartTime = 0;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	//level.onRoundSwitch = ::onRoundSwitch;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.initGametypeAwards = ::initGametypeAwards;
	level.onRespawnDelay = ::getRespawnDelay;

	// Precache FX for client script
	LoadFX( "maps/mp_maps/fx_mp_koth_marker_neutral_1" ); 
	LoadFX( "maps/mp_maps/fx_mp_koth_marker_neutral_wndw" ); 
	
	if ( getdvar("autoDestroyTime") == "" )
		setdvar("autoDestroyTime", "60");
	level.zoneAutoMoveTime = GetDvarInt( "autoDestroyTime" );
	if ( getdvar("objectiveSpawnTime") == "" )
		setdvar("objectiveSpawnTime", "0");
	level.zoneSpawnTime = GetDvarInt( "objectiveSpawnTime" );
	if ( getdvar("captureTime") == "" )
		setdvar("captureTime", "0");
	level.captureTime = GetDvarInt( "captureTime" );
	if ( getdvar("destroyTime") == "" )
		setdvar("destroyTime", "0");
	level.destroyTime = GetDvarInt( "destroyTime" );
	if ( getdvar("delayPlayer") == "" )
		setdvar("delayPlayer", "1");
	level.delayPlayer = GetDvarInt( "delayPlayer" );
	if ( getdvar("randomObjectiveLocations") == "" )
		setdvar("randomObjectiveLocations", "0");
	level.randomZoneSpawn = GetDvarInt( "randomObjectiveLocations" );
	if ( getdvar("scorePerPlayer") == "" )
		setdvar("scorePerPlayer", "0");
	level.scorePerPlayer = GetDvarInt( "scorePerPlayer" );
		
	game["dialog"]["gametype"] = "koth_start";

	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";

	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";
	
	game["objective_gained_sound"] = "mpl_flagcapture_sting_friend";
	game["objective_lost_sound"] = "mpl_flagcapture_sting_enemy";
	game["objective_contested_sound"] = "mpl_flagreturn_sting";

	level.lastDialogTime = 0;
	level.zoneSpawnQueue = [];
		
	/#
		// HQ radio triggers are not scoped to exclude koth right now
		// going to delete them just so if we render triggers we dont see all these
		// TODO in the future is to get them into the automatic game type delete system
		trigs = getentarray("radiotrigger", "targetname");
		foreach( trig in trigs )
		{
			trig delete();
		}
	#/
}


initializeMatchRules()
{
	assert( isUsingMatchRulesData() );

	//	set common values
	setCommonRulesFromMatchRulesData();

	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	registerRoundLimitDvar( level.gameType, 1 );
	registerWinLimitDvar( level.gameType, 1 );
	registerHalfTimeDvar( level.gameType, 0 );
}


onPrecacheGameType()
{
	precacheString( &"MP_WAITING_FOR_HQ" );
	precacheString( &"MP_KOTH_CAPTURED_BY" );
	precacheString( &"MP_KOTH_CAPTURED_BY_ENEMY" );
	precacheString( &"MP_KOTH_MOVING_IN" );
	precacheString( &"MP_CAPTURING_OBJECTIVE" );
	precacheString( &"MP_KOTH_CONTESTED_BY_ENEMY" );
	precacheString( &"MP_KOTH_AVAILABLE_IN" );

	level.objectiveHintPrepareZone = &"MP_CONTROL_KOTH";
	level.objectiveHintCaptureZone = &"MP_CAPTURE_KOTH";
	level.objectiveHintDefendHQ = &"MP_DEFEND_KOTH";
	precacheString( level.objectiveHintPrepareZone );
	precacheString( level.objectiveHintCaptureZone );
	precacheString( level.objectiveHintDefendHQ );	

	level.iconCapture3D = "waypoint_capture";
	level.iconCapture2D = "waypoint_capture";
	level.iconDefend3D = "waypoint_defend";
	level.iconDefend2D = "waypoint_defend";
	level.iconContested3D = "waypoint_captureneutral";
	level.iconContested2D = "waypoint_captureneutral";
	precacheShader( level.iconCapture3D );
	precacheShader( level.iconCapture2D );
	precacheShader( level.iconDefend3D );
	precacheShader( level.iconDefend2D );
	precacheShader( level.iconContested3D );
	precacheShader( level.iconContested2D );
}

updateObjectiveHintMessages( alliesMessage, axisMessage )
{
	game["strings"]["objective_hint_allies"] = alliesMessage;
	game["strings"]["objective_hint_axis"] = axisMessage;
}

updateObjectiveHintMessage( message )
{
	updateObjectiveHintMessages( message, message );
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
	
	setObjectiveText( "allies", &"OBJECTIVES_KOTH" );
	setObjectiveText( "axis", &"OBJECTIVES_KOTH" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_KOTH" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_KOTH" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_KOTH_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_KOTH_SCORE" );
	}
	
	if ( level.zoneSpawnTime )
	{
		updateObjectiveHintMessage( level.objectiveHintPrepareZone );
	}
	else
	{
		updateObjectiveHintMessage( level.objectiveHintCaptureZone );
	}
	
	setClientNameMode("auto_change");

	initSpawns();
	
	allowed[0] = "hp";
	maps\mp\gametypes\_gameobjects::main(allowed);

	maps\mp\gametypes\_rank::registerScoreInfo( "hp_secure", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "quickly_secure_point", 100 );
	
	thread SetupZones();
	thread HardpointMainLoop();
}

//===========================================
// 				initSpawns
//===========================================
initSpawns()
{
	// TODO: HQ spawnpoints
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}

//===========================================
// 			getSpawnPoint
//===========================================
getSpawnPoint()
{
	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );
	
	if ( level.useStartSpawns )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		// zoneOwningTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		// level.zone.gameobject.nearSpawns
		// level.zone.gameobject.outerSpawns
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnscoring::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	assert( isDefined(spawnPoint) );
	return spawnPoint;
}


spawn_first_zone()
{
	// pick next Zone object
	if ( level.randomZoneSpawn == RANDOM_ZONE_LOCATIONS_ON )
	{
		level.zone = GetNextZoneFromQueue();
	}
	else
	{
		level.zone = GetFirstZone();
	}
	
	if ( isdefined( level.zone ) )
	{
		logString("zone spawned: ("+level.zone.trigOrigin[0]+","+level.zone.trigOrigin[1]+","+level.zone.trigOrigin[2]+")");
	}

	//level.zone.gameobject.trigger AllowTacticalInsertion( false ); 
	
	return;
}

spawn_next_zone()
{
	//level.zone.gameobject.trigger AllowTacticalInsertion( true ); 

	// pick next Zone object
	if ( level.randomZoneSpawn != RANDOM_ZONE_LOCATIONS_OFF )
	{
		level.zone = GetNextZoneFromQueue();
	}
	else
	{
		level.zone = GetNextZone();
	}
	
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );

	if ( isdefined( level.zone ) )
	{
		logString("zone spawned: ("+level.zone.trigOrigin[0]+","+level.zone.trigOrigin[1]+","+level.zone.trigOrigin[2]+")");
	}

	//level.zone.gameobject.trigger AllowTacticalInsertion( false ); 
	
	return;
}

getNumTouching( )
{
	return self.numTouching["allies"] + self.numTouching["axis"];
}

hpCaptureLoop()
{
	level endon("game_ended");
	level endon("zone_moved");
	level.hpStartTime = gettime();
	
	while( 1 )
	{
		level.zone.gameobject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setUseTime( level.captureTime );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_OBJECTIVE" );
		
		numTouching = level.zone.gameobject getNumTouching( );

		level.zone.gameobject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::mustMaintainClaim( false );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::canContestClaim( true );
		
		level.zone.gameobject.onUse = ::onZoneCapture;
		level.zone.gameobject.onBeginUse = ::onBeginUse;
		level.zone.gameobject.onEndUse = ::onEndUse;

		msg = level waittill_any_return( "zone_captured", "zone_destroyed" );
	
		// this happens if it goes from contested to neutral
		if ( msg == "zone_destroyed" )
			continue;
			
		ownerTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();

		if ( ownerTeam == "allies" )
			updateObjectiveHintMessages( level.objectiveHintDefendHQ, level.objectiveHintCaptureZone );
		else if ( ownerTeam == "axis" )
			updateObjectiveHintMessages( level.objectiveHintCaptureZone, level.objectiveHintDefendHQ );
		else
			updateObjectiveHintMessages( level.objectiveHintCaptureZone, level.objectiveHintCaptureZone );

		level.zone.gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
		
		level.zone.gameobject.onUse = undefined;
		level.zone.gameobject.onUnoccupied = ::onZoneUnoccupied;
		level.zone.gameobject.onContested = ::onZoneContested;
		level.zone.gameobject.onUncontested = ::onZoneUncontested;
			
		level waittill( "zone_destroyed", destroy_team );
				
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

HardpointMainLoop()
{
	level endon("game_ended");
	
	level.zoneRevealTime = -100000;
	
	zoneSpawningInStr = &"MP_KOTH_AVAILABLE_IN";
	zoneDestroyedInFriendlyStr = &"MP_HQ_DESPAWN_IN";
	zoneDestroyedInEnemyStr = &"MP_KOTH_MOVING_IN";
	
	precacheString( zoneSpawningInStr );
	precacheString( zoneDestroyedInFriendlyStr );
	precacheString( zoneDestroyedInEnemyStr );
	precacheString( &"MP_CAPTURING_HQ" );
	precacheString( &"MP_DESTROYING_HQ" );
	
	//objective_name = istring("objective");
	//precachestring( objective_name );

	spawn_first_zone();
	
	gameFlagWait( "prematch_done" );
	
	timerDisplay = [];

	timerDisplay["allies"] = createServerTimer( "objective", 1.4, "allies" );
	if ( level.splitscreen )
		timerDisplay["allies"] setPoint( "TOPLEFT", "TOPLEFT", 280, 0 );
	else
		timerDisplay["allies"] setPoint( "TOPLEFT", "TOPLEFT", 315, 5 );
	timerDisplay["allies"].label = zoneSpawningInStr;
	timerDisplay["allies"].alpha = 1;
	timerDisplay["allies"].archived = false;
	timerDisplay["allies"].hideWhenInMenu = true;

	thread hideTimerDisplayOnGameEnd( timerDisplay["allies"] );

	timerDisplay["axis"] = createServerTimer( "objective", 1.4, "axis" );
	if ( level.splitscreen )
		timerDisplay["axis"] setPoint( "TOPLEFT", "TOPLEFT", 280, 0 );
	else
		timerDisplay["axis"] setPoint( "TOPLEFT", "TOPLEFT", 315, 5 );
	timerDisplay["axis"].label = zoneSpawningInStr;
	timerDisplay["axis"].alpha = 1;
	timerDisplay["axis"].archived = false;
	timerDisplay["axis"].hideWhenInMenu = true;

	thread hideTimerDisplayOnGameEnd( timerDisplay["axis"] );
	
	while( 1 )
	{
		playSoundOnPlayers( "mp_suitcase_pickup" );
		//maps\mp\gametypes\_globallogic_audio::flushGroupDialog( "gamemode_objective" );
		//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_located" );
		
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		
		level.zoneRevealTime = gettime();
	
		if ( level.zoneSpawnTime )
		{
			level.zone.gameobject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
			// TODO LOOK AT THIS
			//level.zone.gameobject maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_TARGET );

			updateObjectiveHintMessage( level.objectiveHintPrepareZone );
			
			timerDisplay["allies"].label = zoneSpawningInStr;
			timerDisplay["allies"] setTimer( level.zoneSpawnTime );
			timerDisplay["allies"].alpha = 1;

			timerDisplay["axis"].label = zoneSpawningInStr;
			timerDisplay["axis"] setTimer( level.zoneSpawnTime );
			timerDisplay["axis"].alpha = 1;

			wait level.zoneSpawnTime;

			// TODO LOOK AT THIS
			//level.zone.gameobject maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_NORMAL );
			//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_online" );
		}

		timerDisplay["allies"].alpha = 1;
		timerDisplay["axis"].alpha = 1;
		
		waittillframeend;
		
		//maps\mp\gametypes\_globallogic_audio::leaderDialog( "obj_capture", undefined, "gamemode_objective" );
		updateObjectiveHintMessage( level.objectiveHintCaptureZone );
		playSoundOnPlayers( "mpl_hq_cap_us" );

		level.zone.gameobject maps\mp\gametypes\_gameobjects::enableObject();
		level.zone.gameobject.captureCount = 0;
		
		if ( level.zoneAutoMoveTime )
		{
			thread MoveZoneAfterTime( level.zoneAutoMoveTime );

			timerDisplay["allies"].label = zoneDestroyedInEnemyStr;	
			timerDisplay["allies"] setTimer( level.zoneAutoMoveTime );
			timerDisplay["allies"].alpha = 1;

			timerDisplay["axis"].label = zoneDestroyedInEnemyStr;	
			timerDisplay["axis"] setTimer( level.zoneAutoMoveTime );
			timerDisplay["axis"].alpha = 1;
		}
		else
		{
			level.zoneDestroyedByTimer = false;
		}
	
		hpCaptureLoop();
		
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
		
		level.zone.gameobject.lastCaptureTeam = undefined;
		level.zone.gameobject maps\mp\gametypes\_gameobjects::disableObject();
		level.zone.gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		level.zone.gameobject maps\mp\gametypes\_gameobjects::mustMaintainClaim( false );
	
		level notify("zone_reset");
		
		timerDisplay["allies"].alpha = 1;
		timerDisplay["axis"].alpha = 1;
				
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
//		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
		// TODO LOOK AT THIS
		//player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "hq_protect", player.pers["team"] );
	}
	else
	{
//		self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
//		self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
		// TODO LOOK AT THIS
		//player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "hq_attack", player.pers["team"] );
	}
}


onEndUse( team, player, success )
{
//	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
//	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	player notify( "event_ended" );
}


onZoneCapture( player )
{
	capture_team = player.pers["team"];
	captureTime = getTime();

	player logString( "zone captured" );

	level.zone.gameobject.isContested = false;
	level.useStartSpawns = false;

	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );

	if ( !isdefined( self.lastCaptureTeam )  || self.lastCaptureTeam != capture_team )
	{
		// Copy touch list so there aren't any threading issues
		touchList = [];
		touchKeys = GetArrayKeys( self.touchList[capture_team] );
		for ( i = 0 ; i < touchKeys.size ; i++ )
			touchList[touchKeys[i]] = self.touchList[capture_team][touchKeys[i]];
		thread give_capture_credit( touchList, captureTime, capture_team, self.lastCaptureTeam );
	}

	level.hpCapTeam = capture_team;

	oldTeam = maps\mp\gametypes\_gameobjects::getOwnerTeam();
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( capture_team );
	
	if ( IsDefined( self.lastCaptureTeam ) && ( self.lastCaptureTeam != capture_team ) ) // If retaking this point after being contested, don't play VO again
	{
		//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_secured", team, "gamemode_objective" );
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( player.pers["team"] == capture_team )
			{
				if ( player.lastKilltime + 500 > getTime() )
				{
					//player maps\mp\_challenges::killedLastContester();	
				}
			}
		}
	}
	thread playSoundOnPlayers( game["objective_gained_sound"], capture_team );

	not_capture_team = getOtherTeam( capture_team );
	if ( oldTeam == not_capture_team ) // Only the team who just lost the point hear the VO
	{
		//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_lost", team, "gamemode_objective" );
	}
	else if ( oldTeam == "neutral" )
	{
		//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_captured", team, "gamemode_objective" );
	}
	thread playSoundOnPlayers( game["objective_lost_sound"], not_capture_team );
			
	level thread awardCapturePoints( capture_team, self.lastCaptureTeam );
	self.captureCount++;
	self.lastCaptureTeam = capture_team;
	
	self maps\mp\gametypes\_gameobjects::mustMaintainClaim( true );
	
	level notify( "zone_captured" );
	level notify( "zone_captured" + capture_team );
	player notify( "event_ended" );
}

give_capture_credit( touchList, captureTime, capture_team, lastCaptureTeam )
{
	wait .05;
	//maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player = touchList[players[i]].player;

		player updateCapsPerMinute( lastCaptureTeam );

		if ( !isScoreBoosting( player ) )
		{
			//player maps\mp\_challenges::capturedObjective( captureTime );
			if ( level.hpStartTime + 3000 > captureTime && level.hpCapTeam == capture_team ) 
			{
				maps\mp\gametypes\_gamescore::givePlayerScore( "quickly_secure_point", player );
			}
		
			maps\mp\gametypes\_gamescore::givePlayerScore( "hp_secure", player );
			//player RecordGameEvent("capture");

			level thread teamPlayerCardSplash( "callout_hp_captured_by", player );

			if( isdefined(player.pers["captures"]) )
			{
				player.pers["captures"]++;
				player.captures = player.pers["captures"];
			}		
				
			if ( level.hpStartTime + 500 > captureTime ) 
			{
				//player maps\mp\_challenges::immediateCapture();
			}

			//maps\mp\_demo::bookmark( "event", gettime(), player );
			player incPlayerStat( "hp_captures_started", 1 );
		}
		else
		{
			/#
				player IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU CAPTURE CREDIT AS BOOSTING PREVENTION" );
			#/
		}
	}
}

give_held_credit( touchList, team )
{
	wait .05;
	//maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player = touchList[players[i]].player;
			
		//maps\mp\_scoreevents::processScoreEvent( "hp_held", player );

		// do not know if we want the following
		//player RecordGameEvent("held");

	}
}

onZoneDestroy( player )
{
	destroyed_team = player.pers["team"];

	player logString( "zone destroyed" );
	//maps\mp\_scoreevents::processScoreEvent( "zone_destroyed", player );	
	//player RecordGameEvent("destroy");	
	//player AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
		
	if( isdefined(player.pers["destructions"]) )
	{
		player.pers["destructions"]++;
		player.destructions = player.pers["destructions"];
	}
	
	destroyTeamMessage = &"MP_KOTH_CAPTURED_BY";
	otherTeamMessage = &"MP_KOTH_CAPTURED_BY_ENEMY";
	
	//level thread maps\mp\_popups::DisplayTeamMessageToAll( destroyTeamMessage, player );

	//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_secured", destroyed_team, "gamemode_objective" );
	//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_destroyed", getOtherTeam(destroyed_team), "gamemode_objective" );	

	level notify( "zone_destroyed", destroyed_team );
	
	level thread awardCapturePoints( destroyed_team );

	player notify( "event_ended" );
}

onZoneUnoccupied()
{
	level notify( "zone_destroyed" );
	level.hpCapTeam = "neutral";
	level.zone.gameobject.wasLeftUnoccupied = true;
	level.zone.gameobject.isContested = false;
}

onZoneContested()
{	
	zoneOwningTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	level.zone.gameobject.wasContested = true;
	level.zone.gameobject.isContested = true;
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconContested2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconContested3D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconContested2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconContested3D );

	thread playSoundOnPlayers( game["objective_contested_sound"], zoneOwningTeam );
	//maps\mp\gametypes\_globallogic_audio::leaderDialog( "koth_contested", zoneOwningTeam, "gamemode_objective" );
}

onZoneUncontested( lastClaimTeam )
{	
	assert( lastClaimTeam ==  level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam() );
	
	level.zone.gameobject.isContested = false;
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	level.zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );

	level.zone.gameobject maps\mp\gametypes\_gameobjects::SetClaimTeam( lastClaimTeam );
}

MoveZoneAfterTime( time )
{
	level endon( "game_ended" );
	level endon( "zone_reset" );
	
	level.zoneMoveTime = gettime() + time * 1000;
	level.zoneDestroyedByTimer = false;
	
	wait time;

	if ( !isdefined( level.zone.gameobject.wasContested ) || level.zone.gameobject.wasContested == false )
	{
		if ( !isdefined( level.zone.gameobject.wasLeftUnoccupied ) || level.zone.gameobject.wasLeftUnoccupied == false )
		{
			zoneOwningTeam = level.zone.gameobject maps\mp\gametypes\_gameobjects::getOwnerTeam();
			//maps\mp\_challenges::controlZoneEntirely( zoneOwningTeam );
		}
	}

	level.zoneDestroyedByTimer = true;

	level notify( "zone_moved" );
}


awardCapturePoints( team, lastCaptureTeam )
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
		wait seconds;
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		
		if ( !level.zone.gameobject.isContested )
		{
			if ( level.scorePerPlayer )
			{
				score = level.zone.gameobject.numTouching[team];
			}
			
			maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( team, score );
		}
	}
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
  zones = getentarray( "hp_zone_center", "targetname" );

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
	
	trigs = getentarray("hp_zone_trigger", "targetname");
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
		
		objective_name = &"MP_KOTH_CAPTURED_BY";	// placeholder

		zone.gameObject = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", zone.trig, visuals, (0,0,0), objective_name );
		zone.gameObject maps\mp\gametypes\_gameobjects::disableObject();
		zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
		zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
		zone.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
		zone.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
		zone.gameObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		zone.trig.useObj = zone.gameObject;
		zone setUpNearbySpawns();
	}
	
	if (maperrors.size > 0)
	{
		/#
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		// TODO LOOK AT THIS
		//maps\mp\_utility::error("Map errors. See above");
		#/
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		
		return;
	}
	
	level.zones = zones;
	
	level.prevzone = undefined;
	level.prevzone2 = undefined;
	
	setupZoneExclusions();
	
	return true;
}


setupZoneExclusions()
{
	if ( !isdefined( level.levelhpDisable ) ) 
		return;
		
/*	foreach( nullZone in level.levelhpDisable ) 
	{
		foreach( zone in level.zones ) 
		{
//			if ( zone.gameObject.trigger istouching( nullZone ) )
			if ( zone.gameObject.trigger istouchingvolume( nullZone.origin, nullZone getmins(), nullZone getmaxs() ) )
			{
				if ( !isdefined( zone.gameObject.exclusions ) )
				{
					zone.gameObject.exclusions = [];
				}
				
				zone.gameObject.exclusions[ zone.gameObject.exclusions.size ] = nullZone;			
			}
		}
	}	
*/

  	foreach( nullZone in level.levelhpDisable )
	{
		mindist = 100000000;
		foundZone = undefined;
		
		foreach( zone in level.zones ) 
		{
			distance = DistanceSquared( nullZone.origin, zone.origin );
			
			if ( distance < mindist )
			{
				foundZone = zone;
				mindist = distance;
			}
		}
		
		if ( isdefined( foundZone ) )
		{
			if ( !isdefined( foundZone.gameObject.exclusions ) )
			{
				foundZone.gameObject.exclusions = [];
			}
			foundZone.gameObject.exclusions[ foundZone.gameObject.exclusions.size ] = nullZone;
		}
	}

}

setUpNearbySpawns()
{
	spawns = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );
	
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

	// old linear and "random" systems 
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	level.prevZoneIndex = 0;

	// new shuffled system
	ShuffleZones();
	tmp = [];
	j=0;
	for (i=0; i<level.zoneSpawnQueue.size; i++)
	{
		if (level.zoneSpawnQueue[i] != zone)
		{
			tmp[j] = zone;
			j++;
		}
	}
	level.zoneSpawnQueue = tmp;
	//ArrayRemoveValue( level.zoneSpawnQueue, zone );

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

ShuffleZones()
{
	level.zoneSpawnQueue = [];

	spawnQueue = level.zones;	
	total_left = spawnQueue.size;
	
	while( total_left > 0 )
	{
		index = randomint( total_left );
		
		valid_zones = 0;
		for( zone = 0; zone < level.zones.size; zone++ )
		{
			if ( !isdefined(spawnQueue[zone]) )
				continue;
				
			if ( valid_zones == index )
			{
				// dont allow the last radio from the previous shuffle to be put first in the next
				if ( level.zoneSpawnQueue.size == 0 && isdefined( level.zone ) && level.zone == spawnQueue[zone] )
					continue;

				level.zoneSpawnQueue[level.zoneSpawnQueue.size] = spawnQueue[zone];
				spawnQueue[zone] = undefined;
				break;
			}
			
			valid_zones++; 
		}
		
		total_left--;
	}
}


// shuffled picking
GetNextZoneFromQueue()
{
	if ( level.zoneSpawnQueue.size == 0 )
		ShuffleZones();

	assert( level.zoneSpawnQueue.size > 0 );

	next_zone = level.zoneSpawnQueue[0];
	tmp = [];
	for (i=1; i<level.zoneSpawnQueue.size; i++)
		tmp[i-1] = level.zoneSpawnQueue[i];
	level.zoneSpawnQueue = tmp;
	
	return next_zone;
}

GetCountOfTeamsWithPlayers(num)
{
	has_players = 0;
	
	if ( num["allies"] > 0 )
		has_players++;

	if ( num["axis"] > 0 )
		has_players++;
	
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
	avgpos = [];
	num = [];
	avgpos["allies"] = (0,0,0);
	num["axis"] = 0;
	avgpos["allies"] = (0,0,0);
	num["axis"] = 0;
	
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
	
	if ( num["allies"] == 0 )
	{
		avgpos["allies"] = undefined;
	}
	else
	{
		avgpos["allies"] = avgpos["allies"] / num["allies"];
	}

	if ( num["axis"] == 0 )
	{
		avgpos["axis"] = undefined;
	}
	else
	{
		avgpos["axis"] = avgpos["axis"] / num["axis"];
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

//onRoundSwitch()
//{
	//game["switchedsides"] = !game["switchedsides"];
//}


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
			attacker.lastKilltime = getTime();
			team = self.pers["team"];
			if ( team == ownerTeam )
			{
				if ( !medalGiven ) 
				{
					//attacker maps\mp\_medals::offenseGlobalCount();
					//attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
					
					medalGiven = true;
				}
				//maps\mp\_scoreevents::processScoreEvent( "killed_defender", attacker, undefined, sWeapon );// TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
				//maps\mp\_scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, sWeapon );
				//self RecordKillModifier("defending");
				scoreEventProcessed = true;
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

					//attacker maps\mp\_medals::defenseGlobalCount();
					medalGiven = true;
					//attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
					//attacker RecordGameEvent("return");
				}
				//attacker maps\mp\_challenges::killedZoneAttacker( sWeapon );
				//maps\mp\_scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, sWeapon ); // TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
				//maps\mp\_scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, sWeapon );
				//self RecordKillModifier("assaulting");
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
				if ( !medalGiven ) 
				{					
					if( isdefined(attacker.pers["defends"]) )
					{
						attacker.pers["defends"]++;
						attacker.defends = attacker.pers["defends"];
					}

					//attacker maps\mp\_medals::defenseGlobalCount();
					medalGiven = true;
					//attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
					//attacker RecordGameEvent("return");
				}
				if ( scoreEventProcessed == false )
				{
					//attacker maps\mp\_challenges::killedZoneAttacker( sWeapon );
					//maps\mp\_scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, sWeapon );// TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
					//maps\mp\_scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, sWeapon );
					//self RecordKillModifier("assaulting");
				}
			}
			else
			{
				if ( !medalGiven ) 
				{
					//attacker maps\mp\_medals::offenseGlobalCount();
					medalGiven = true;
					//attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
				}
				if ( scoreEventProcessed == false )
				{
					//maps\mp\_scoreevents::processScoreEvent( "killed_defender", attacker, undefined, sWeapon );// TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
					//maps\mp\_scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, sWeapon );
					//self RecordKillModifier("defending");
				}
			}		
		}
	}
	
	if ( medalGiven == true )
	{
		if ( level.zone.gameobject.isContested == true ) 
		{
			attacker thread killWhileContesting();
		}
	}
}


killWhileContesting()
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
	
	zoneReturn = level waittill_any_return( "zone_captured" + playerteam, "zone_destroyed", "zone_captured", "death" );
	
	if ( zoneReturn == "zone_destroyed" || zoneReturn == "death" || playerteam != self.pers["team"] )
	{
		self.clearEnemyCount = 0;
		return;
	}

	if ( self.clearEnemyCount >= 2 && killTime + 200 > getTime() )
	{
		//maps\mp\_scoreevents::processScoreEvent( "clear_2_attackers", self );
	}
	self.clearEnemyCount = 0;
}
			
onEndGame( winningTeam )
{
	for ( i = 0; i < level.zones.size; i++ )
	{
		level.zones[i].gameobject maps\mp\gametypes\_gameobjects::allowUse( "none" );
	}
}

set_dvar_float_if_unset( dvar, val, reset_dvars )
{
	if (reset_dvars)
		SetDvar( dvar, val );
	else
		SetDvarIfUninitialized( dvar, val );
	return GetDvarFloat( dvar, val );
}

set_dvar_if_unset( dvar, val, reset_dvars )
{
	if (reset_dvars)
		SetDvar( dvar, val );
	else
		SetDvarIfUninitialized( dvar, val );
	return GetDvar( dvar, val );
}

get_player_height()
{
	return 60.0;
}

updateCapsPerMinute(lastOwnerTeam)
{
	if ( !isDefined( self.capsPerMinute ) )
	{
		self.numCaps = 0;
		self.capsPerMinute = 0;
	}
	
	// not including neutral flags as part of the boosting prevention
	// to help with false positives at the start
	if ( !isdefined ( lastOwnerTeam ) || lastOwnerTeam == "neutral" )
		return;
		
	self.numCaps++;
	
	//minutesPassed = maps\mp\gametypes\_globallogic_utils::getTimePassed() / ( 60 * 1000 );
	minutesPassed = 1;
	
	// players use the actual time played
	if ( IsPlayer( self ) && IsDefined(self.timePlayed["total"]) )
		minutesPassed = self.timePlayed["total"] / 60;
		
	self.capsPerMinute = self.numCaps / minutesPassed;
	if ( self.capsPerMinute > self.numCaps )
		self.capsPerMinute = self.numCaps;
}

isScoreBoosting( player )
{
	if ( !level.rankedMatch )
		return false;
		
	if ( player.capsPerMinute > level.playerCaptureLPM )
		return true;

	return false;
}

initGametypeAwards()
{
	maps\mp\_awards::initStatAward( "hp_captures_started", 0, maps\mp\_awards::highestWins );
}