#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	if ( getdvar("mapname") == "mp_background" )
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimitDvar( level.gameType, 30, 0, 1440 );
	registerScoreLimitDvar( level.gameType, 300, 0, 1000 );
	registerRoundLimitDvar( level.gameType, 1, 0, 10 );
	registerWinLimitDvar( level.gameType, 1, 0, 10 );
	registerNumLivesDvar( level.gameType, 0, 0, 10 );
	registerHalfTimeDvar( level.gameType, 0, 0, 1 );
	
	level.teamBased = true;
	level.doPrematch = true;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.initGametypeAwards = ::initGametypeAwards;

	precacheShader( "compass_waypoint_captureneutral" );
	precacheShader( "compass_waypoint_capture" );
	precacheShader( "compass_waypoint_defend" );

	precacheShader( "waypoint_targetneutral" );
	precacheShader( "waypoint_captureneutral" );
	precacheShader( "waypoint_capture" );
	precacheShader( "waypoint_defend" );
	
	precacheString( &"MP_WAITING_FOR_HQ" );
	
	if ( getdvar("koth_autodestroytime") == "" )
		setdvar("koth_autodestroytime", "60");
	level.hqAutoDestroyTime = getdvarint("koth_autodestroytime");
	
	if ( getdvar("koth_spawntime") == "" )
		setdvar("koth_spawntime", "0");
	level.hqSpawnTime = getdvarint("koth_spawntime");
	
	if ( getdvar("koth_kothmode") == "" )
		setdvar("koth_kothmode", "1");
	level.kothMode = getdvarint("koth_kothmode");

	if ( getdvar("koth_captureTime") == "" )
		setdvar("koth_captureTime", "20");
	level.captureTime = getdvarint("koth_captureTime");

	if ( getdvar("koth_destroyTime") == "" )
		setdvar("koth_destroyTime", "10");
	level.destroyTime = getdvarint("koth_destroyTime");
	
	if ( getdvar("koth_delayPlayer") == "" )
		setdvar("koth_delayPlayer", 1);
	level.delayPlayer = getdvarint("koth_delayPlayer");

	if ( getdvar("koth_spawnDelay") == "" )
		setdvar("koth_spawnDelay", 0);
	level.spawnDelay = getdvarint("koth_spawnDelay");
		
	level.iconoffset = (0,0,32);
	
	level.onRespawnDelay = ::getRespawnDelay;

	game["dialog"]["gametype"] = "headquarters";

	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];

}


updateObjectiveHintMessages( alliesObjective, axisObjective )
{
	game["strings"]["objective_hint_allies"] = alliesObjective;
	game["strings"]["objective_hint_axis"  ] = axisObjective;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
		{
			hintText = getObjectiveHintText( player.pers["team"] );
			player thread maps\mp\gametypes\_hud_message::hintMessage( hintText );
		}
	}
}


getRespawnDelay()
{
	self clearLowerMessage( "hq_respawn" );

	if ( !isDefined( level.radioObject ) )
		return undefined;
	
	hqOwningTeam = level.radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	if ( self.pers["team"] == hqOwningTeam )
	{
		if ( !isDefined( level.hqDestroyTime ) )
			return undefined;
		
		timeRemaining = (level.hqDestroyTime - gettime()) / 1000;

		if (!level.spawnDelay )
			return undefined;

		if ( level.spawnDelay >= level.hqAutoDestroyTime )
			setLowerMessage( "hq_respawn", &"MP_WAITING_FOR_HQ", undefined, 10 );
			
		if ( level.delayPlayer )
		{
			return min( level.spawnDelay, timeRemaining );
		}
		else
		{
			return (int(timeRemaining) % level.spawnDelay);
		}
	}
}


onStartGameType()
{
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
	
	level.objectiveHintPrepareHQ = &"MP_CONTROL_HQ";
	level.objectiveHintCaptureHQ = &"MP_CAPTURE_HQ";
	level.objectiveHintDestroyHQ = &"MP_DESTROY_HQ";
	level.objectiveHintDefendHQ = &"MP_DEFEND_HQ";
	precacheString( level.objectiveHintPrepareHQ );
	precacheString( level.objectiveHintCaptureHQ );
	precacheString( level.objectiveHintDestroyHQ );
	precacheString( level.objectiveHintDefendHQ );
	
	if ( level.kothmode )
		level.objectiveHintDestroyHQ = level.objectiveHintCaptureHQ;
	
	if ( level.hqSpawnTime )
		updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintPrepareHQ );
	else
		updateObjectiveHintMessages( level.objectiveHintCaptureHQ, level.objectiveHintCaptureHQ );
	
	setClientNameMode("auto_change");
	
	// TODO: HQ spawnpoints
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	level.spawn_all = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );
	if ( !level.spawn_all.size )
	{
		println("^1No mp_tdm_spawn spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	
	
	allowed[0] = "hq";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread SetupRadios();

	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 150 );
	
	thread HQMainLoop();
}


HQMainLoop()
{
	level endon("game_ended");
	
	level.hqRevealTime = -100000;
	
	hqSpawningInStr = &"MP_HQ_AVAILABLE_IN";
	if ( level.kothmode )
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
	
	gameFlagWait( "prematch_done" );
	
	wait 5;
		
	timerDisplay = [];
	timerDisplay["allies"] = createServerTimer( "objective", 1.4, "allies" );
	timerDisplay["allies"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	timerDisplay["allies"].label = hqSpawningInStr;
	timerDisplay["allies"].alpha = 0;
	timerDisplay["allies"].archived = false;
	timerDisplay["allies"].hideWhenInMenu = true;
	
	timerDisplay["axis"  ] = createServerTimer( "objective", 1.4, "axis" );
	timerDisplay["axis"  ] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	timerDisplay["axis"  ].label = hqSpawningInStr;
	timerDisplay["axis"  ].alpha = 0;
	timerDisplay["axis"  ].archived = false;
	timerDisplay["axis"  ].hideWhenInMenu = true;
	
	thread hideTimerDisplayOnGameEnd( timerDisplay["allies"] );
	thread hideTimerDisplayOnGameEnd( timerDisplay["axis"  ] );
	
	locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	
	objective_add( locationObjID, "invisible", (0,0,0) );
	
	while( 1 )
	{
		radio = PickRadioToSpawn();
		
		iPrintLn( &"MP_HQ_REVEALED" );
		playSoundOnPlayers( "mp_suitcase_pickup" );
		leaderDialog( "hq_located" );
		
		radioObject = radio.gameobject;
		level.radioObject = radioObject;
		
		radioObject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		
		level.hqRevealTime = gettime();
		
		if ( level.hqSpawnTime )
		{
			nextObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_next_hq", radio.origin + level.iconoffset, "all", "waypoint_targetneutral" );
			nextObjPoint setWayPoint( true, true );
			objective_position( locationObjID, radio.trigorigin );
			objective_icon( locationObjID, "compass_waypoint_captureneutral" );
			objective_state( locationObjID, "active" );

			updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintPrepareHQ );
			
			timerDisplay["allies"].label = hqSpawningInStr;
			timerDisplay["allies"] setTimer( level.hqSpawnTime );
			if ( !level.splitscreen )
				timerDisplay["allies"].alpha = 1;
			timerDisplay["axis"  ].label = hqSpawningInStr;
			timerDisplay["axis"  ] setTimer( level.hqSpawnTime );
			if ( !level.splitscreen )
				timerDisplay["axis"  ].alpha = 1;

			wait level.hqSpawnTime;

			maps\mp\gametypes\_objpoints::deleteObjPoint( nextObjPoint );
			objective_state( locationObjID, "invisible" );
			leaderDialog( "hq_online" );
		}

		timerDisplay["allies"].alpha = 0;
		timerDisplay["axis"  ].alpha = 0;
		
		waittillframeend;
		
		leaderDialog( "obj_capture" );
		updateObjectiveHintMessages( level.objectiveHintCaptureHQ, level.objectiveHintCaptureHQ );
		playSoundOnPlayers( "mp_killstreak_radar" );

		radioObject maps\mp\gametypes\_gameobjects::enableObject();
		
		radioObject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		radioObject maps\mp\gametypes\_gameobjects::setUseTime( level.captureTime );
		radioObject maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_HQ" );
		
		radioObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" );
		radioObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" );
		radioObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		radioObject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		
		radioObject.onUse = ::onRadioCapture;
		radioObject.onBeginUse = ::onBeginUse;
		radioObject.onEndUse = ::onEndUse;
		
		level waittill( "hq_captured" );
		
		ownerTeam = radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		otherTeam = getOtherTeam( ownerTeam );
		
		if ( level.hqAutoDestroyTime )
		{
			thread DestroyHQAfterTime( level.hqAutoDestroyTime );
			timerDisplay[ownerTeam] setTimer( level.hqAutoDestroyTime );
			timerDisplay[otherTeam] setTimer( level.hqAutoDestroyTime );
		}
		else
		{
			level.hqDestroyedByTimer = false;
		}
		
		/#
		thread scriptDestroyHQ();
		#/
		
		while( 1 )
		{
			ownerTeam = radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
			otherTeam = getOtherTeam( ownerTeam );
	
			if ( ownerTeam == "allies" )
			{
				updateObjectiveHintMessages( level.objectiveHintDefendHQ, level.objectiveHintDestroyHQ );
			}
			else
			{
				updateObjectiveHintMessages( level.objectiveHintDestroyHQ, level.objectiveHintDefendHQ );
			}
	
			radioObject maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
			radioObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
			radioObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
			radioObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" );
			radioObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" );

			if ( !level.kothMode )
				radioObject maps\mp\gametypes\_gameobjects::setUseText( &"MP_DESTROYING_HQ" );
			
			radioObject.onUse = ::onRadioDestroy;
			
			if ( level.hqAutoDestroyTime )
			{
				timerDisplay[ownerTeam].label = hqDestroyedInFriendlyStr;
				if ( !level.splitscreen )
					timerDisplay[ownerTeam].alpha = 1;
				timerDisplay[otherTeam].label = hqDestroyedInEnemyStr;
				if ( !level.splitscreen )
					timerDisplay[otherTeam].alpha = 1;
			}
			
			level waittill( "hq_destroyed" );
			
			if ( !level.kothmode || level.hqDestroyedByTimer )
				break;
			
			thread forceSpawnTeam( ownerTeam );
			
			radioObject maps\mp\gametypes\_gameobjects::setOwnerTeam( getOtherTeam( ownerTeam ) );
		}
		
		level notify("hq_reset");
		
		radioObject maps\mp\gametypes\_gameobjects::disableObject();
		radioObject maps\mp\gametypes\_gameobjects::allowUse( "none" );
		radioObject maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
		radioObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		
		timerDisplay["allies"].alpha = 0;
		timerDisplay["axis"  ].alpha = 0;
		
		level.radioObject = undefined;
		
		wait .05;
		
		thread forceSpawnTeam( ownerTeam );
		
		wait 6.0;
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
			player clearLowerMessage( "hq_respawn" );
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
	}
	else
	{
		self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
		self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
	}
}


onEndUse( team, player, success )
{
	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
}


onRadioCapture( player )
{
	team = player.pers["team"];

	//player logString( "radio captured" );
	player thread [[level.onXPEvent]]( "capture" );
	maps\mp\gametypes\_gamescore::givePlayerScore( "capture", player );
	player incPlayerStat( "hqscaptured", 1 );
	player thread maps\mp\_matchdata::logGameEvent( "capture", player.origin );

	oldTeam = maps\mp\gametypes\_gameobjects::getOwnerTeam();
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	if ( !level.kothMode )
		self maps\mp\gametypes\_gameobjects::setUseTime( level.destroyTime );
	
	otherTeam = "axis";
	if ( team == "axis" )
		otherTeam = "allies";
	
	thread printOnTeamArg( &"MP_HQ_CAPTURED_BY", team, player );
	thread printOnTeam( &"MP_HQ_CAPTURED_BY_ENEMY", otherTeam );
	leaderDialog( "hq_secured", team );
	leaderDialog( "hq_enemy_captured", oldTeam );
	thread playSoundOnPlayers( "mp_war_objective_taken", team );
	thread playSoundOnPlayers( "mp_war_objective_lost", otherTeam );
	
	level thread awardHQPoints( team );
	
	player notify( "objective", "captured" );
	level notify( "hq_captured" );
}

/#
scriptDestroyHQ()
{
	level endon("hq_destroyed");
	while(1)
	{
		if ( getdvar("scr_destroyhq") != "1" )
		{
			wait .1;
			continue;
		}
		setdvar("scr_destroyhq","0");
		
		hqOwningTeam = level.radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( level.players[i].team != hqOwningTeam )
			{
				onRadioDestroy( level.players[i] );
				break;
			}
		}
	}
}
#/

onRadioDestroy( player )
{
	team = player.pers["team"];
	otherTeam = "axis";
	if ( team == "axis" )
		otherTeam = "allies";

	//player logString( "radio destroyed" );
	player thread [[level.onXPEvent]]( "capture" );
	maps\mp\gametypes\_gamescore::givePlayerScore( "capture", player );	
	player incPlayerStat( "hqsdestroyed", 1 );
	player thread maps\mp\_matchdata::logGameEvent( "destroy", player.origin );
		
	if ( level.kothmode )
	{
		thread printOnTeamArg( &"MP_HQ_CAPTURED_BY", team, player );
		thread printOnTeam( &"MP_HQ_CAPTURED_BY_ENEMY", otherTeam );
		leaderDialog( "hq_secured", team );
		leaderDialog( "hq_enemy_captured", otherTeam );
	}
	else
	{
		thread printOnTeamArg( &"MP_HQ_DESTROYED_BY", team, player );
		thread printOnTeam( &"MP_HQ_DESTROYED_BY_ENEMY", otherTeam );
		leaderDialog( "hq_secured", team );
		leaderDialog( "hq_enemy_destroyed", otherTeam );
	}
	thread playSoundOnPlayers( "mp_war_objective_taken", team );
	thread playSoundOnPlayers( "mp_war_objective_lost", otherTeam );
	
	level notify( "hq_destroyed" );
	
	if ( level.kothmode )
		level thread awardHQPoints( team );
}


DestroyHQAfterTime( time )
{
	level endon( "game_ended" );
	level endon( "hq_reset" );
	
	level.hqDestroyTime = gettime() + time * 1000;
	level.hqDestroyedByTimer = false;
	
	wait time;
	
	level.hqDestroyedByTimer = true;
	level notify( "hq_destroyed" );
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
		maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( team, seconds );
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( player.pers["team"] == team )
			{
				player thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_gamescore::givePlayerScore( "defend", player );	
			}
		}
		
		wait seconds;
	}
}


getSpawnPoint()
{
	spawnpoint = undefined;
	
	if ( isdefined( level.radioObject ) )
	{
		hqOwningTeam = level.radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		if ( self.pers["team"] == hqOwningTeam )
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.radioObject.nearSpawns );
		else if ( level.spawnDelay >= level.hqAutoDestroyTime && gettime() > level.hqRevealTime + 10000 )
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.radioObject.assaultSpawns );
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.radioObject.outerSpawns );
	}
	
	if ( !isDefined( spawnpoint ) )
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
	
	assert( isDefined(spawnpoint) );
	
	return spawnpoint;
}


onSpawnPlayer()
{
	self clearLowerMessage( "hq_respawn" );
}


SetupRadios()
{
	maperrors = [];

	radios = getentarray( "hq_hardpoint", "targetname" );
	
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
		
		radio.gameObject = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", radio.trig, visuals, (radio.origin - radio.trigorigin) + level.iconoffset );
		radio.gameObject maps\mp\gametypes\_gameobjects::disableObject();
		radio.gameObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		radio.trig.useObj = radio.gameObject;
		
		radio setUpNearbySpawns();
	}
	
	if (maperrors.size > 0)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		error("Map errors. See above");
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
	
	assault = second;
	foreach ( spawnPoint in third )
		assault[assault.size] = spawnPoint;
	
	self.gameObject.nearSpawns = first;
	self.gameObject.midSpawns = second;
	self.gameObject.farSpawns = third;
	self.gameObject.outerSpawns = outer;

	self.gameObject.assaultSpawns = assault;
}


PickRadioToSpawn()
{
	validAllies = [];
	validAxis = [];
	
	foreach ( player in level.players )
	{
		if ( player.team == "spectator" )
			continue;
			
		if ( !isAlive( player ) )
			continue;
			
		player.dist = 0;
		if ( player.team == "allies" )
			validAllies[validAllies.size] = player;
		else
			validAxis[validAxis.size] = player;
	}

	if ( !validAllies.size || !validAxis.size )
	{
		radio = level.radios[ randomint( level.radios.size) ];
		while ( isDefined( level.prevradio ) && radio == level.prevradio ) // so lazy
			radio = level.radios[ randomint( level.radios.size) ];
		
		level.prevradio2 = level.prevradio;
		level.prevradio = radio;
		
		return radio;
	}
	
	for ( i = 0; i < validAllies.size; i++ )
	{
		for ( j = i + 1; j < validAllies.size; j++ )
		{
			dist = distanceSquared( validAllies[i].origin, validAllies[j].origin );
			
			validAllies[i].dist += dist;
			validAllies[j].dist += dist;
		}
	}

	for ( i = 0; i < validAxis.size; i++ )
	{
		for ( j = i + 1; j < validAxis.size; j++ )
		{
			dist = distanceSquared( validAxis[i].origin, validAxis[j].origin );
			
			validAxis[i].dist += dist;
			validAxis[j].dist += dist;
		}
	}

	bestPlayer = validAllies[0];
	foreach ( player in validAllies )
	{
		if ( player.dist < bestPlayer.dist )
			bestPlayer = player;
	}
	avgpos["allies"] = bestPlayer.origin;

	bestPlayer = validAxis[0];
	foreach ( player in validAxis )
	{
		if ( player.dist < bestPlayer.dist )
			bestPlayer = player;
	}
	avgpos["axis"] = validAxis[0].origin;
	
	bestradio = undefined;
	lowestcost = undefined;
	for ( i = 0; i < level.radios.size; i++ )
	{
		radio = level.radios[i];
		
		// (purposefully using distance instead of distanceSquared)
		cost = abs( distance( radio.origin, avgpos["allies"] ) - distance( radio.origin, avgpos["axis"] ) );
		
		if ( isdefined( level.prevradio ) && radio == level.prevradio )
		{
			continue;
		}
		if ( isdefined( level.prevradio2 ) && radio == level.prevradio2 )
		{
			if ( level.radios.size > 2 )
				continue;
			else
				cost += 512;
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



onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId )
{
	if ( !isPlayer( attacker ) || (!self.touchTriggers.size && !attacker.touchTriggers.size) || attacker.pers["team"] == self.pers["team"] )
		return;

	if ( self.touchTriggers.size )
	{
		foreach ( trigger in self.touchTriggers )
		{
			// TODO: way to check for koth specific triggers
			if ( !isDefined( trigger.useObj ) )
				continue;
			
			ownerTeam = trigger.useObj.ownerTeam;
			team = self.pers["team"];

			if ( ownerTeam == "neutral" )
				continue;

			team = self.pers["team"];
			if ( team == ownerTeam )
			{
				attacker thread [[level.onXPEvent]]( "assault" );
				maps\mp\gametypes\_gamescore::givePlayerScore( "assault", attacker );
				
				thread maps\mp\_matchdata::logKillEvent( killId, "defending" );
			}
			else
			{
				attacker thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_gamescore::givePlayerScore( "defend", attacker );
				
				self thread maps\mp\_matchdata::logKillEvent( killId, "assaulting" );
			}
		}
	}	
	
	if ( attacker.touchTriggers.size )
	{
		foreach ( trigger in attacker.touchTriggers )
		{
			// TODO: way to check for koth specific triggers
			if ( !isDefined( trigger.useObj ) )
				continue;
			
			ownerTeam = trigger.useObj.ownerTeam;
			team = attacker.pers["team"];
		
			if ( ownerTeam == "neutral" )

			team = attacker.pers["team"];
			if ( team == ownerTeam )
			{
				attacker thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_gamescore::givePlayerScore( "defend", attacker );

				self thread maps\mp\_matchdata::logKillEvent( killId, "assaulting" );
			}
			else
			{
				attacker thread [[level.onXPEvent]]( "assault" );
				maps\mp\gametypes\_gamescore::givePlayerScore( "assault", attacker );

				thread maps\mp\_matchdata::logKillEvent( killId, "defending" );
			}		
		}
	}
}


initGametypeAwards()
{
	maps\mp\_awards::initStatAward( "hqsdestroyed", 0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "hqscaptured", 0, maps\mp\_awards::highestWins );
}