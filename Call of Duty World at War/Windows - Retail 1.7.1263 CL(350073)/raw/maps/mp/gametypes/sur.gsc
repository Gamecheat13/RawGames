#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


main()
{
	if ( getdvar("mapname") == "mp_background" )
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 300, 0, 1000 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	
	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.playerSpawnedCB = ::sur_playerSpawnedCB;
	level.onPlayerKilled = ::onPlayerKilled;

	precacheString( &"MP_WAITING_FOR_SAFEZONE" );
	precacheString( &"MP_SAFEZONE_AVAILABLE_IN" );
	precacheString( &"MP_SAFEZONE_DESPAWN_IN" );

	precacheString( &"MP_SECURING_CARGO" );
	precacheString( &"MP_LOCATE_CARGO" );
	precacheString( &"MP_CARGO_TO_SAFEZONE" );
	precacheString( &"MP_CARGO_RECOVERED_BY" );
	precacheString( &"MP_CARGO_DROPPED_BY" );

	// temporary cargo pre-cache -->
	game["bombmodelname"] = "mil_tntbomb_mp";
	game["bombmodelnameobj"] = "mil_tntbomb_mp";
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";

	precacheModel( "prop_suitcase_bomb" );	
	precacheShader( "hud_suitcase_bomb" );

	precacheShader( "waypoint_bomb" );	
	precacheShader( "waypoint_capture" );
	precacheShader( "waypoint_captureneutral" );
	precacheShader( "waypoint_defend" );
	precacheShader( "waypoint_kill" );

	precacheShader( "compass_waypoint_bomb" );
	precacheShader( "compass_waypoint_capture" );
	precacheShader( "compass_waypoint_captureneutral" );
	precacheShader( "compass_waypoint_defend" );
	precacheShader( "compass_waypoint_kill" );
	// <-- temporary cargo pre-cache
	
	if ( getdvar("sur_autodestroytime") == "" )
		setdvar("sur_autodestroytime", "60");
	level.safeZoneAutoDestroyTime = getdvarint("sur_autodestroytime");
	
	if ( getdvar("sur_captureTime") == "" )
		setdvar("sur_captureTime", "20");
	level.captureTime = getdvarint("sur_captureTime");

	if ( getdvar("sur_destroyTime") == "" )
		setdvar("sur_destroyTime", "10");
	level.destroyTime = getdvarint("sur_destroyTime");
	
	if ( getdvar("sur_delayPlayer") == "" )
		setdvar("sur_delayPlayer", 1);
	level.delayPlayer = getdvarint("sur_delayPlayer");

	if ( getdvar("sur_spawnDelay") == "" )
		setdvar("sur_spawnDelay", 0);
	level.spawnDelay = getdvarint("sur_spawnDelay");
		
	level.iconoffset = (0,0,32);
	
	level.onRespawnDelay = ::getRespawnDelay;

	game["dialog"]["gametype"] = "survival";
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
			hintText = maps\mp\gametypes\_globallogic::getObjectiveHintText( player.pers["team"] );
			player thread maps\mp\gametypes\_hud_message::hintMessage( hintText );
		}
	}
}


getRespawnDelay()
{
	self.lowerMessageOverride = undefined;

	if ( !isDefined( level.safeZoneObject ) )
		return undefined;
	
	safeZoneOwningTeam = level.safeZoneObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	if ( self.pers["team"] == safeZoneOwningTeam )
	{
		if ( !isDefined( level.safeZoneDestroyTime ) )
			return undefined;
		
		timeRemaining = (level.safeZoneDestroyTime - gettime()) / 1000;

		if (!level.spawnDelay )
			return undefined;

		if ( level.spawnDelay >= level.safeZoneAutoDestroyTime )
			self.lowerMessageOverride = &"MP_WAITING_FOR_SAFEZONE";				
			
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
	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_SUR" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_SUR" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_SUR" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_SUR" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_SUR_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_SUR_SCORE" );
	}
	
	updateObjectiveHintMessages( &"MP_LOCATE_CARGO", &"MP_LOCATE_CARGO" );

	setClientNameMode("auto_change");
	
	// TODO: Survival spawnpoints
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	level.spawn_all = getentarray( "mp_tdm_spawn", "classname" );
	if ( !level.spawn_all.size )
	{
		println("^1No mp_tdm_spawn spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	
	allowed[0] = "sur";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread SetupCargoSpots();
	thread SetupSafeZones();

	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 15 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 4 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 3 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 2 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 1 );
	
	thread SURMainLoop();
}


SURMainLoop()
{
	level endon("game_ended");
	
	level.safeZoneRevealTime = -100000;
	
	while ( level.inPrematchPeriod )
		wait ( 0.05 );
	
	wait 5;
		
	level.timerDisplay = [];
	level.timerDisplay["allies"] = createServerTimer( "objective", 1.4, "allies" );
	level.timerDisplay["allies"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.timerDisplay["allies"].label = &"MP_SAFEZONE_AVAILABLE_IN";
	level.timerDisplay["allies"].alpha = 0;
	level.timerDisplay["allies"].archived = false;
	level.timerDisplay["allies"].hideWhenInMenu = true;
	
	level.timerDisplay["axis"  ] = createServerTimer( "objective", 1.4, "axis" );
	level.timerDisplay["axis"  ] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.timerDisplay["axis"  ].label = &"MP_SAFEZONE_AVAILABLE_IN";
	level.timerDisplay["axis"  ].alpha = 0;
	level.timerDisplay["axis"  ].archived = false;
	level.timerDisplay["axis"  ].hideWhenInMenu = true;
	
	thread hideTimerDisplayOnGameEnd( level.timerDisplay["allies"] );
	thread hideTimerDisplayOnGameEnd( level.timerDisplay["axis"  ] );
	
	locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	
	objective_add( locationObjID, "invisible", (0,0,0) );

	level.cargoTouched = false;
	level.surGameState = "spawnCargo";

	level.cargoObject = undefined;
	level.safeZoneObject = undefined;

	while( 1 )
	{
		switch( level.surGameState )
		{
		case "resetCargo":
			resetCargo( level.cargoObject );
			resetSafeZone( level.safeZoneObject );

			level.cargoObject = undefined;
			level.safeZoneObject = undefined;

			level.surGameState = "spawnCargo";
			break;

		case "spawnCargo":
			if ( isDefined( level.cargoObject ) )
			{
				checkCargoPickup();
			}
			else
			{
				level.cargoObject = spawnCargo();
			}
			break;

		case "spawnSafeZone":
			if ( isDefined( level.safeZoneObject ) )
			{
				checkSafeZoneResets( level.safeZoneObject );
			}
			else
			{
				level.safeZoneObject = spawnSafeZone();
			}
			break;

		default:
			assertex( 0, "Unknown surGameState" );
			break;
		}

		wait 0.5;
	}
}


resetCargo( cargoObject )
{
	cargoObject thread maps\mp\gametypes\_gameobjects::returnHome();

	cargoObject maps\mp\gametypes\_gameobjects::disableObject();
	cargoObject maps\mp\gametypes\_gameobjects::allowUse( "none" );
	cargoObject maps\mp\gametypes\_gameobjects::setOwnerTeam( "none" );
	cargoObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", undefined );
	cargoObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
	cargoObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", undefined );
	cargoObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", undefined );
	cargoObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );

	level.cargoTouched = false;
}


resetSafeZone( safeZoneObject )
{
	level notify("safezone_reset");

	ownerTeam = safeZoneObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
			
	safeZoneObject maps\mp\gametypes\_gameobjects::disableObject();
	safeZoneObject maps\mp\gametypes\_gameobjects::allowUse( "none" );
	safeZoneObject maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
	safeZoneObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
	
	level.timerDisplay["allies"].alpha = 0;
	level.timerDisplay["axis"  ].alpha = 0;
	
	level.safeZoneObject = undefined;
	
	wait .05;
	
	thread forceSpawnTeam( ownerTeam );
	
	wait 3.0;
}


spawnCargo()
{
	cargo = PickCargoToSpawn();

	cargoObject = cargo.gameobject;
	cargoObject maps\mp\gametypes\_gameobjects::enableObject();
	cargoObject maps\mp\gametypes\_gameobjects::allowUse( "any" );
	cargoObject maps\mp\gametypes\_gameobjects::setModelVisibility( true );

	updateObjectiveHintMessages( &"MP_LOCATE_CARGO", &"MP_LOCATE_CARGO" );

	return cargoObject;
}


checkCargoPickup()
{
	if ( level.cargoTouched )
	{
		level.surGameState = "spawnSafeZone";
	}
}


spawnSafeZone()
{
	safeZone = PickSafeZoneToSpawn();
			
	iPrintLn( &"MP_SAFEZONE_REVEALED" );
	playSoundOnPlayers( "mp_suitcase_pickup" );
	// @ TODO : Audio cue when safe zone spawns? Audio asset?
	//maps\mp\gametypes\_globallogic::leaderDialog( "safezone_located" );
	
	safeZoneObject = safeZone.gameobject;
	level.safeZoneObject = safeZoneObject;
	logString( "safeZone spawned: " + safeZone.trigOrigin[0] + " " + safeZone.trigOrigin[1] + " " + safeZone.trigOrigin[2] );
	
	safeZoneObject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
	
	level.safeZoneRevealTime = gettime();

	level.timerDisplay["allies"].alpha = 0;
	level.timerDisplay["axis"  ].alpha = 0;
	
	waittillframeend;
	
	maps\mp\gametypes\_globallogic::leaderDialog( "obj_capture" );

	ownerTeam = getCargoOwnerTeam();
	if ( ownerTeam == "allies" )
	{
		updateObjectiveHintMessages( &"MP_CARGO_TO_SAFEZONE", &"MP_INTERCEPT_CARGO" );
	}
	else if ( ownerTeam == "axis" )
	{
		updateObjectiveHintMessages( &"MP_INTERCEPT_CARGO", &"MP_CARGO_TO_SAFEZONE" );
	}

	playSoundOnPlayers( "mp_killstreak_radar" );

	cargoOwnerTeam = getCargoOwnerTeam();

	safeZoneObject maps\mp\gametypes\_gameobjects::enableObject();
	safeZoneObject maps\mp\gametypes\_gameobjects::setOwnerTeam( cargoOwnerTeam );
	safeZoneObject maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	safeZoneObject maps\mp\gametypes\_gameobjects::setUseTime( level.safeZoneAutoDestroyTime );
	safeZoneObject maps\mp\gametypes\_gameobjects::setUseText( &"MP_SECURING_CARGO" );
	safeZoneObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
	safeZoneObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );

	if ( cargoOwnerTeam == "neutral" )
	{
		safeZoneObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" );
		safeZoneObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" );
	}
	else
	{
		safeZoneObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" );
		safeZoneObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" );
	}

	safeZoneObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	safeZoneObject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
	
	safeZoneObject.onBeginUse = ::onBeginUse;
	safeZoneObject.onEndUse = ::onEndUse;
	
	thread DestroySafeZoneAfterTime( level.safeZoneAutoDestroyTime );
	level.timerDisplay["allies"] setTimer( level.safeZoneAutoDestroyTime );
	level.timerDisplay["axis"  ] setTimer( level.safeZoneAutoDestroyTime );

	return safeZoneObject;
}


checkSafeZoneResets( safeZoneObject )
{
	level.timerDisplay["allies"].label = &"MP_SAFEZONE_DESPAWN_IN";
	if ( !level.splitscreen )
		level.timerDisplay["allies"].alpha = 1;

	level.timerDisplay["axis"  ].label = &"MP_SAFEZONE_DESPAWN_IN";
	if ( !level.splitscreen )
		level.timerDisplay["axis"  ].alpha = 1;

	level waittill( "safezone_destroyed" );

	level.surGameState = "resetCargo";
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


getCargoOwnerTeam()
{
	if ( isDefined( level.cargoObject ) && isDefined( level.cargoObject.carrier ) )
	{
		return level.cargoObject.carrier.pers["team"];
	}

	return "neutral";
}


onDrop( player )
{
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( "none" );

	level notify( "cargo_dropped" );

	if ( isDefined( level.safeZoneObject ) )
	{
		level.safeZoneObject maps\mp\gametypes\_gameobjects::setOwnerTeam( "none" );
		level.safeZoneObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" );
		level.safeZoneObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" );
	}

	if ( level.cargoTouched )
	{
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_bomb" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_bomb" );
	}

	if ( true /*!level.bombPlanted*//*is cargo in safe zone?*/ )
	{
		if ( isDefined( player ) && isDefined( player.name ) )
			printOnTeamArg( &"MP_CARGO_DROPPED_BY", player.pers["team"], player );

		if ( isDefined( player ) )
		 	player logString( "bomb dropped" );
		 else
		 	logString( "bomb dropped" );
	}

	maps\mp\_utility::playSoundOnPlayers( game["bomb_dropped_sound"], game["attackers"] );
}


onPickup( player )
{
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( player.pers["team"] );

	if ( isDefined( level.safeZoneObject ) )
	{
		println("^1------------ onPickup setting safeZoneObject ownerTeam to " + player.pers["team"] );

		level.safeZoneObject maps\mp\gametypes\_gameobjects::setOwnerTeam( player.pers["team"] );
		level.safeZoneObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" );
		level.safeZoneObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" );
	}

	if ( !level.cargoTouched )
	{
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_kill" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_kill" );
	}

	level.cargoTouched = true;

	if ( true /*!level.bombDefused*//*is game over? or is cargo safe zone time up?*/ )
	{
		if ( isDefined( player ) && isDefined( player.name ) )
			printOnTeamArg( &"MP_CARGO_RECOVERED_BY", player.pers["team"], player );
			
		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_taken", player.pers["team"] );
		player logString( "bomb taken" );
	}

	maps\mp\_utility::playSoundOnPlayers( game["bomb_recovered_sound"], player.pers["team"] );
}


onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	level thread awardSafeZonePoints( ownerTeam );

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
}


onEndUse( team, player, success )
{
	player notify( "cargo_left_safezone" );

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
}


DestroySafeZoneAfterTime( time )
{
	level endon( "game_ended" );
	level endon( "safezone_reset" );
	
	level.safeZoneDestroyTime = gettime() + time * 1000;
	level.safeZoneDestroyedByTimer = false;
	
	wait time;
	
	level.safeZoneDestroyedByTimer = true;
	level notify( "safezone_destroyed" );
}


awardSafeZonePoints( team )
{
	level endon( "game_ended" );
	level endon( "safezone_destroyed" );
	level endon( "cargo_dropped" );
	level endon( "cargo_left_safezone" );
	
	level notify("awardSafeZonePointsRunning");
	level endon("awardSafeZonePointsRunning");
	
	seconds = 5;
	
	while ( !level.gameEnded )
	{
		[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + seconds );
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( player.pers["team"] == team )
			{
				player thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "defend", player );	
			}
		}
		
		wait seconds;
	}
}


onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer()
{
	spawnpoint = undefined;
	
	if ( isdefined( level.safeZoneObject ) )
	{
		safeZoneOwningTeam = level.safeZoneObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		if ( self.pers["team"] == safeZoneOwningTeam )
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.safeZoneObject.nearSpawns );
		else if ( level.spawnDelay >= level.safeZoneAutoDestroyTime && gettime() > level.safeZoneRevealTime + 10000 )
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.safeZoneObject.outerSpawns );
	}
	
	if ( !isDefined( spawnpoint ) )
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
	
	assert( isDefined(spawnpoint) );
	
	self spawn( spawnpoint.origin, spawnpoint.angles );
}


sur_playerSpawnedCB()
{
	self.lowerMessageOverride = undefined;
}


SetupCargoSpots()
{
	maperrors = [];

	cargoSpots = getentarray( "sur_cargo", "targetname" );
	if ( cargoSpots.size < 2 )
	{
		maperrors[maperrors.size] = "There are not at least 2 entities with targetname \"sur_cargo\"";
	}
	
	trigs = getentarray("sur_cargo_pickup_trig", "targetname");
	for ( i = 0; i < cargoSpots.size; i++ )
	{
		errored = false;
		
		cargoSpot = cargoSpots[i];
		cargoSpot.trig = undefined;
		for ( j = 0; j < trigs.size; j++ )
		{
			if ( cargoSpot istouching( trigs[j] ) )
			{
				if ( isdefined( cargoSpot.trig ) )
				{
					maperrors[maperrors.size] = "Cargo at " + cargoSpot.origin + " is touching more than one \"sur_cargo_pickup_trig\" trigger";
					errored = true;
					break;
				}
				cargoSpot.trig = trigs[j];
				break;
			}
		}
		
		if ( !isdefined( cargoSpot.trig ) )
		{
			if ( !errored )
			{
				maperrors[maperrors.size] = "Cargo at " + cargoSpot.origin + " is not inside any \"sur_cargo_pickup_trig\" trigger";
				continue;
			}
		}
		
		assert( !errored );
		
		cargoSpot.trigorigin = cargoSpot.trig.origin;
		
		visuals = [];
		visuals[0] = cargoSpot;
		visuals[0] setModel( "prop_suitcase_bomb" );
		
		cargoSpot.gameObject = maps\mp\gametypes\_gameobjects::createCarryObject( "none", cargoSpot.trig, visuals, (0,0,32) );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::allowCarry( "none" );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::setCarryIcon( "hud_suitcase_bomb" );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::setOwnerTeam( "none" );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", undefined );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", undefined );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", undefined );
		cargoSpot.gameObject maps\mp\gametypes\_gameobjects::disableObject();
		cargoSpot.gameObject.allowWeapons = true;
		cargoSpot.gameObject.onPickup = ::onPickup;
		cargoSpot.gameObject.onDrop = ::onDrop;
		cargoSpot.trig.useObj = cargoSpot.gameObject;
	}
	
	if (maperrors.size > 0)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		maps\mp\_utility::error("Map errors. See above");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		
		return;
	}
	
	level.cargoSpots = cargoSpots;
	
	level.prevCargoSpot = undefined;
	level.prevCargoSpot2 = undefined;
	
	return true;
}


SetupSafeZones()
{
	maperrors = [];

	safeZones = getentarray( "sur_hardpoint", "targetname" );
	
	if ( safeZones.size < 2 )
	{
		maperrors[maperrors.size] = "There are not at least 2 entities with targetname \"sur_hardpoint\"";
	}
	
	trigs = getentarray("safezone_trigger", "targetname");
	for ( i = 0; i < safeZones.size; i++ )
	{
		errored = false;
		
		safeZone = safeZones[i];
		safeZone.trig = undefined;
		for ( j = 0; j < trigs.size; j++ )
		{
			if ( safeZone istouching( trigs[j] ) )
			{
				if ( isdefined( safeZone.trig ) )
				{
					maperrors[maperrors.size] = "Safe Zone at " + safeZone.origin + " is touching more than one \"safezone_trigger\" trigger";
					errored = true;
					break;
				}
				safeZone.trig = trigs[j];
				break;
			}
		}
		
		if ( !isdefined( safeZone.trig ) )
		{
			if ( !errored )
			{
				maperrors[maperrors.size] = "Safe Zone at " + safeZone.origin + " is not inside any \"safezone_trigger\" trigger";
				continue;
			}
		}
		
		assert( !errored );
		
		safeZone.trigorigin = safeZone.trig.origin;
		
		visuals = [];
		visuals[0] = safeZone;
		
		otherVisuals = getEntArray( safeZone.target, "targetname" );
		for ( j = 0; j < otherVisuals.size; j++ )
		{
			visuals[visuals.size] = otherVisuals[j];
		}
		
		safeZone.gameObject = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", safeZone.trig, visuals, (safeZone.origin - safeZone.trigorigin) + level.iconoffset );
		safeZone.gameObject maps\mp\gametypes\_gameobjects::disableObject();
		safeZone.gameObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		safeZone.trig.useObj = safeZone.gameObject;
		
		safeZone setUpNearbySpawns();
	}
	
	if (maperrors.size > 0)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		maps\mp\_utility::error("Map errors. See above");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		
		return;
	}
	
	level.safeZones = safeZones;
	
	level.prevSafeZone = undefined;
	level.prevSafeZone2 = undefined;
	
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


PickCargoToSpawn()
{
	// find average of positions of each team
	// (medians would be better, to get rid of outliers...)
	// and find the safeZone which has the least difference in distance from those two averages
	
	avgpos["allies"] = (0,0,0);
	avgpos["axis"] = (0,0,0);
	num["allies"] = 0;
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
	
	if ( num["allies"] == 0 || num["axis"] == 0 )
	{
		cargoSpot = level.cargoSpots[ randomint( level.cargoSpots.size) ];
		while ( isDefined( level.prevCargoSpot ) && cargoSpot == level.prevCargoSpot ) // so lazy
			cargoSpot = level.cargoSpots[ randomint( level.cargoSpots.size) ];
		
		level.prevCargoSpot2 = level.prevCargoSpot;
		level.prevCargoSpot = cargoSpot;
		
		return cargoSpot;
	}
	
	avgpos["allies"] = avgpos["allies"] / num["allies"];
	avgpos["axis"  ] = avgpos["axis"  ] / num["axis"  ];
	
	bestCargoSpot = undefined;
	lowestcost = undefined;
	for ( i = 0; i < level.cargoSpots.size; i++ )
	{
		cargoSpot = level.cargoSpots[i];
		
		// (purposefully using distance instead of distanceSquared)
		cost = abs( distance( cargoSpot.origin, avgpos["allies"] ) - distance( cargoSpot.origin, avgpos["axis"] ) );
		
		if ( isdefined( level.prevCargoSpot ) && cargoSpot == level.prevCargoSpot )
		{
			continue;
		}
		if ( isdefined( level.prevCargoSpot2 ) && cargoSpot == level.prevCargoSpot2 )
		{
			if ( level.cargoSpots.size > 2 )
				continue;
			else
				cost += 512;
		}
		
		if ( !isdefined( lowestcost ) || cost < lowestcost )
		{
			lowestcost = cost;
			bestCargoSpot = cargoSpot;
		}
	}
	assert( isdefined( bestCargoSpot ) );
	
	level.prevCargoSpot2 = level.prevCargoSpot;
	level.prevCargoSpot = bestCargoSpot;
	
	return bestCargoSpot;
}


PickSafeZoneToSpawn()
{
	// find average of positions of each team
	// (medians would be better, to get rid of outliers...)
	// and find the safeZone which has the least difference in distance from those two averages
	
	avgpos["allies"] = (0,0,0);
	avgpos["axis"] = (0,0,0);
	num["allies"] = 0;
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
	
	if ( num["allies"] == 0 || num["axis"] == 0 )
	{
		safeZone = level.safeZones[ randomint( level.safeZones.size) ];
		while ( isDefined( level.prevSafeZone ) && safeZone == level.prevSafeZone ) // so lazy
			safeZone = level.safeZones[ randomint( level.safeZones.size) ];
		
		level.prevSafeZone2 = level.prevSafeZone;
		level.prevSafeZone = safeZone;
		
		return safeZone;
	}
	
	avgpos["allies"] = avgpos["allies"] / num["allies"];
	avgpos["axis"  ] = avgpos["axis"  ] / num["axis"  ];
	
	bestSafeZone = undefined;
	lowestcost = undefined;
	for ( i = 0; i < level.safeZones.size; i++ )
	{
		safeZone = level.safeZones[i];
		
		// (purposefully using distance instead of distanceSquared)
		cost = abs( distance( safeZone.origin, avgpos["allies"] ) - distance( safeZone.origin, avgpos["axis"] ) );
		
		if ( isdefined( level.prevSafeZone ) && safeZone == level.prevSafeZone )
		{
			continue;
		}
		if ( isdefined( level.prevSafeZone2 ) && safeZone == level.prevSafeZone2 )
		{
			if ( level.safeZones.size > 2 )
				continue;
			else
				cost += 512;
		}
		
		if ( !isdefined( lowestcost ) || cost < lowestcost )
		{
			lowestcost = cost;
			bestSafeZone = safeZone;
		}
	}
	assert( isdefined( bestSafeZone ) );
	
	level.prevSafeZone2 = level.prevSafeZone;
	level.prevSafeZone = bestSafeZone;
	
	return bestSafeZone;
}



onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || (!self.touchTriggers.size && !attacker.touchTriggers.size) || attacker.pers["team"] == self.pers["team"] )
		return;

	if ( self.touchTriggers.size )
	{
		triggerIds = getArrayKeys( self.touchTriggers );
		ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		if ( ownerTeam != "neutral" )
		{
			team = self.pers["team"];
			if ( team == ownerTeam )
			{
				attacker thread [[level.onXPEvent]]( "assault" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "assault", attacker );
			}
			else
			{
				attacker thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "defend", attacker );
			}
		}		
	}	
	
	if ( attacker.touchTriggers.size )
	{
		triggerIds = getArrayKeys( attacker.touchTriggers );
		ownerTeam = attacker.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		if ( ownerTeam != "neutral" )
		{
			team = attacker.pers["team"];
			if ( team == ownerTeam )
			{
				attacker thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "defend", attacker );
			}
			else
			{
				attacker thread [[level.onXPEvent]]( "assault" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "assault", attacker );
			}		
		}
	}
}

