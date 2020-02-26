#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Sabotage
	
	// ...etc...
*/

/*QUAKED mp_sab_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_sab_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_sab_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_sab_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if ( getdvar("mapname") == "mp_background" )
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( level.gameType, 1, 1, 9 );
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 5, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 0, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 2, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onTimeLimit = ::onTimeLimit;
	level.onDeadEvent = ::onDeadEvent;
	level.onRoundSwitch = ::onRoundSwitch;
	
	game["dialog"]["gametype"] = "sabotage";
	
	badtrig = getent( "sab_bomb_defuse_allies", "targetname" );
	if ( isdefined( badtrig ) )
		badtrig delete();

	badtrig = getent( "sab_bomb_defuse_axis", "targetname" );
	if ( isdefined( badtrig ) )
		badtrig delete();
}

onPrecacheGameType()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
	
	precacheShader("waypoint_bomb");
	precacheShader("waypoint_bomb_enemy");
	precacheShader("waypoint_bomb_headicon");
	precacheShader("waypoint_defend");
	precacheShader("waypoint_defuse");
	precacheShader("waypoint_target");
	precacheShader("compass_waypoint_bomb");
	precacheShader("compass_waypoint_defend");
	precacheShader("compass_waypoint_defuse");
	precacheShader("compass_waypoint_target");
	precacheShader("hud_suitcase_bomb");
	precacheShader("objective");
	precacheShader("hudStopwatch");
	precacheShader("hudstopwatchneedle");
	
	precacheHeadicon("waypoint_bomb_headicon");
	
	precacheString( &"MP_THE_ENEMY" );
	precacheString( &"MP_YOUR_TEAM" );
	precacheString(&"MP_EXPLOSIVES_RECOVERED_BY");
	precacheString(&"MP_EXPLOSIVES_DROPPED_BY");
	precacheString(&"MP_EXPLOSIVES_PLANTED_BY");
	precacheString(&"MP_EXPLOSIVES_DEFUSED_BY");
	precacheString(&"MP_YOU_HAVE_RECOVERED_THE_BOMB");
	precacheString(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
	precacheString(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
	precacheString(&"MP_PLANTING_EXPLOSIVE");
	precacheString(&"MP_DEFUSING_EXPLOSIVE");
}

onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	game["switchedsides"] = !game["switchedsides"];
}

onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	setClientNameMode("auto_change");
	
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_SAB" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_SAB" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_SAB" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_SAB" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_SAB_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_SAB_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_SAB_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_SAB_HINT" );
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_sab_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_sab_spawn_axis" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	level.spawn_axis = getentarray("mp_sab_spawn_axis", "classname");
	level.spawn_allies = getentarray("mp_sab_spawn_allies", "classname");
	level.spawn_axis_start = getentarray("mp_sab_spawn_axis_start", "classname");
	level.spawn_allies_start = getentarray("mp_sab_spawn_allies_start", "classname");


	thread maps\mp\gametypes\_dev::init();

	maps\mp\gametypes\_rank::registerScoreInfo( "plant", 20, &"" );
	maps\mp\gametypes\_rank::registerScoreInfo( "defuse", 15, &"" );

	allowed[0] = "sab";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread updateGametypeDvars();
	
	if ( level.roundswitch == 1 && level.roundlimit == 2 )
	{
		if ( game["roundsplayed"] > 0 )
		{
			level.skipRoundEnd = true;
		}
		else
		{
			level.displayHalftimeText = true;
			level.displayRoundEndText = false;
		}
	}

	level.suppressHardpoint3DIcons = true;
	
	thread sabotage();
}

onTimeLimit()
{
	if ( level.inOvertime )
		return;
	
	level.inOvertime = true;
	maps\mp\gametypes\_globallogic::pauseTimer();
	
	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index]  thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"MP_OVERTIME", "Sudden Death", undefined, (1, 0, 0), game["music"]["defeat"] );
	}
	
	return;
	
	/*
	// on round-based modes (default), winner will be overridden inside endGame(). this is just for roundlimit = 1.
	winner = undefined;
	if ( maps\mp\gametypes\_globallogic::getGameScore( "allies" ) == maps\mp\gametypes\_globallogic::getGameScore( "axis" ) )
		winner = "tie";
	else if ( maps\mp\gametypes\_globallogic::getGameScore( "allies" ) > maps\mp\gametypes\_globallogic::getGameScore( "axis" ) )
		winner = "allies";
	else
		winner = "axis";
	
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["time_limit_reached"] );
	*/
}


onDeadEvent( team )
{
	if ( level.bombExploded )
		return;
		
	if ( team == "all" )
	{
		if ( level.bombPlanted )
		{
			thread maps\mp\gametypes\_globallogic::endGame( level.bombPlantedBy, game["strings"][level.bombPlantedBy+"_mission_accomplished"] );
		}
		else
		{
			thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["tie"] );
		}
	}
	else if ( level.bombPlanted )
	{
		if ( team == level.bombPlantedBy )
		{
			level.plantingTeamDead = true;
			return;
		}
			
		thread maps\mp\gametypes\_globallogic::endGame( level.bombPlantedBy, game["strings"][level.otherTeam[level.bombPlantedBy]+"_eliminated"] );
	}
	else
	{
		thread maps\mp\gametypes\_globallogic::endGame( level.otherTeam[team], game["strings"][team+"_eliminated"] );
	}
}


onSpawnPlayer()
{
	self.isPlanting = false;
	self.isDefusing = false;
	self.isBombCarrier = false;

	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.useStartSpawns )
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}	
	else
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}

	assert( isDefined(spawnpoint) );

	self spawn( spawnpoint.origin, spawnpoint.angles );
}


updateGametypeDvars()
{
	level.plantTime = dvarFloatValue( "planttime", 5, 0, 20 );
	level.defuseTime = dvarFloatValue( "defusetime", 5, 0, 20 );
	level.bombTimer = dvarFloatValue( "bombtimer", 45, 1, 300 );
	level.hotPotato = dvarIntValue( "hotpotato", 0, 0, 1 );
}


sabotage()
{
	level.bombPlanted = false;
	level.bombExploded = false;
		
	level.suppressHardpoint3DIcons = true;
	
	level._effect["bombexplosion"] = loadfx("explosions/large_vehicle_explosion");

	trigger = getEnt( "sab_bomb_pickup_trig", "targetname" );
	if ( !isDefined( trigger ) ) 
	{
		error( "No sab_bomb_pickup_trig trigger found in map." );
		return;
	}

	visuals[0] = getEnt( "sab_bomb", "targetname" );
	if ( !isDefined( visuals[0] ) ) 
	{
		error( "No sab_bomb script_model found in map." );
		return;
	}
	
	precacheModel( "prop_suitcase_bomb" );	
	visuals[0] setModel( "prop_suitcase_bomb" );
	level.sabBomb = maps\mp\gametypes\_gameobjects::createCarryObject( "neutral", trigger, visuals, (0,0,32) );
	level.sabBomb maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	level.sabBomb maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::setHeadIcon( "enemy", "waypoint_bomb_headicon" );
	level.sabBomb maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::setHeadIcon( "friendly", "waypoint_bomb_headicon" );
	level.sabBomb maps\mp\gametypes\_gameobjects::setCarryIcon( "hud_suitcase_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	level.sabBomb.showHeadicon = true;
	level.sabBomb.onPickup = ::onPickup;
	level.sabBomb.onDrop = ::onDrop;
	level.sabBomb.allowWeapons = true;
	level.sabBomb.objIDPingEnemy = true;
	if ( !isDefined( getEnt( "sab_bomb_axis", "targetname" ) ) ) 
	{
		error("No sab_bomb_axis trigger found in map.");
		return;
	}
	if ( !isDefined( getEnt( "sab_bomb_allies", "targetname" ) ) )
	{
		error("No sab_bomb_allies trigger found in map.");
		return;
	}

	if ( game["switchedsides"] )
	{
		level.bombZones["allies"] = createBombZone( "allies", getEnt( "sab_bomb_axis", "targetname" ) );
		level.bombZones["axis"] = createBombZone( "axis", getEnt( "sab_bomb_allies", "targetname" ) );
	}
	else
	{
		level.bombZones["allies"] = createBombZone( "allies", getEnt( "sab_bomb_allies", "targetname" ) );
		level.bombZones["axis"] = createBombZone( "axis", getEnt( "sab_bomb_axis", "targetname" ) );
	}
}


createBombZone( team, trigger )
{
	visuals = getEntArray( trigger.target, "targetname" );
	
	bombZone = maps\mp\gametypes\_gameobjects::createUseObject( team, trigger, visuals, (0,0,64) );
	bombZone resetBombsite();
	bombZone.onUse = ::onUse;
	bombZone.onBeginUse = ::onBeginUse;
	bombZone.onCantUse = ::onCantUse;
	bombZone.useWeapon = "briefcase_bomb_mp";
	
	for ( i = 0; i < visuals.size; i++ )
	{
		if ( isDefined( visuals[i].script_exploder ) )
		{
			bombZone.exploderIndex = visuals[i].script_exploder;
			break;
		}
	}
	
	return bombZone;
}

onBeginUse( player )
{
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
		self.isPlanting = true;
	else
		self.isDefusing = false;
}

onPickup( player )
{
	level notify ( "bomb_picked_up" );
	
	level.useStartSpawns = false;
	
	team = player.pers["team"];
	
	if ( team == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";
	
	//player iPrintLnBold( &"MP_YOU_HAVE_RECOVERED_THE_BOMB" );
	player playLocalSound( "mp_suitcase_pickup" );
	player logString( "bomb taken" );
	
	player maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "obj_destroy", "bomb" );
	excludeList[0] = player;
	maps\mp\gametypes\_globallogic::leaderDialog( "bomb_taken", team, "bomb", excludeList );

	maps\mp\gametypes\_globallogic::leaderDialog( "bomb_lost", otherTeam );
	maps\mp\gametypes\_globallogic::leaderDialog( "obj_defend", otherTeam );
	player.isBombCarrier = true;

	// recovered the bomb before abandonment timer elapsed
	if ( team == self maps\mp\gametypes\_gameobjects::getOwnerTeam() )
	{
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", team, player.name );
		playSoundOnPlayers( game["bomb_recovered_sound"], team );
	}
	else
	{
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", team, player.name );
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", otherTeam, &"MP_THE_ENEMY" );
		playSoundOnPlayers( game["bomb_recovered_sound"] );
	}
	
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_bomb_enemy" );
	
	
	level.bombZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	level.bombZones[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
}


onDrop( player )
{
	if ( level.bombPlanted )
	{
		
	}
	else
	{
		if ( isDefined( player ) && isDefined( player.name ) )
			printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", self maps\mp\gametypes\_gameobjects::getOwnerTeam(), player.name );
		else
			printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", self maps\mp\gametypes\_gameobjects::getOwnerTeam(), &"MP_YOUR_TEAM" );
	
		playSoundOnPlayers( game["bomb_dropped_sound"], self maps\mp\gametypes\_gameobjects::getOwnerTeam() );
		player logString( "bomb dropped" );
//		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_lost", player.pers["team"] );

		thread abandonmentThink( 0.0 );
	}
}


abandonmentThink( delay )
{
	level endon ( "bomb_picked_up" );
	
	wait ( delay );

	if ( isDefined( self.carrier ) )
		return;

	if ( self maps\mp\gametypes\_gameobjects::getOwnerTeam() == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", otherTeam, &"MP_THE_ENEMY" );
	playSoundOnPlayers( game["bomb_dropped_sound"], otherTeam );

	self maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_bomb" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_bomb" );
	self maps\mp\gametypes\_gameobjects::setHeadIcon( "enemy", "waypoint_bomb_headicon" );

	level.bombZones["allies"] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	level.bombZones["axis"] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );		
}


onUse( player )
{
	team = player.pers["team"];
	otherTeam = level.otherTeam[team];
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		player notify ( "bomb_planted" );
		player playSound( "mp_bomb_plant" );
		player logString( "bomb planted" );
		if ( !level.hardcoreMode )
		{
			printBoldOnTeamArg( &"MP_EXPLOSIVES_PLANTED_BY", team, player.name );
			printBoldOnTeam( &"MP_EXPLOSIVES_PLANTED", otherTeam );
		}
		iPrintLn( &"MP_EXPLOSIVES_PLANTED_BY", player.name );
		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_planted" );

		maps\mp\gametypes\_globallogic::givePlayerScore( "plant", player );
		player thread [[level.onXPEvent]]( "plant" );
		level thread bombPlanted( self, player.pers["team"] );

//		self.keyObject maps\mp\gametypes\_gameobjects::disableObject();
		level.sabBomb maps\mp\gametypes\_gameobjects::allowCarry( "none" );
		level.sabBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
		level.sabBomb maps\mp\gametypes\_gameobjects::setDropped();
		self.useWeapon = "briefcase_bomb_defuse_mp";
		
		self setUpForDefusing();
	}
	else // defused the bomb
	{
		player notify ( "bomb_defused" );
		player logString( "bomb defused" );
		if ( !level.hardcoreMode )
			iPrintLnBold( &"MP_EXPLOSIVES_DEFUSED_BY", player.name );
		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_defused" );

		maps\mp\gametypes\_globallogic::givePlayerScore( "defuse", player );
		player thread [[level.onXPEvent]]( "defuse" );

		level thread bombDefused( self );
		
		if ( level.inOverTime && isDefined( level.plantingTeamDead ) )
		{
			thread maps\mp\gametypes\_globallogic::endGame( player.pers["team"], game["strings"][level.bombPlantedBy+"_eliminated"] );
			return;
		}
		
		self resetBombsite();
		
		level.sabBomb maps\mp\gametypes\_gameobjects::allowCarry( "any" );
		level.sabBomb maps\mp\gametypes\_gameobjects::setPickedUp( player );
	}
}


onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}


bombPlanted( destroyedObj, team )
{
	maps\mp\gametypes\_globallogic::pauseTimer();
	level.bombPlanted = true;
	level.bombPlantedBy = team;
	level.timeLimitOverride = true;
	
	// communicate timer information to menus
	setGameEndTime( int( getTime() + (level.bombTimer * 1000) ) );
	
	destroyedObj.visuals[0] thread maps\mp\gametypes\_globallogic::playTickingSound();
	
	starttime = gettime();
	bombTimerWait();
	
	destroyedObj.visuals[0] maps\mp\gametypes\_globallogic::stopTickingSound();

	if ( !level.bombPlanted )
	{
		if ( level.hotPotato )
		{
			timePassed = (gettime() - starttime) / 1000;
			level.bombTimer -= timePassed;
		}
		return;
	}
	
	explosionOrigin = level.sabBomb.visuals[0].origin;
	level.bombExploded = true;	
	
	destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20 );
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	thread playSoundinSpace( "exp_suitcase_bomb_main", explosionOrigin );
	
	if ( isDefined( destroyedObj.exploderIndex ) )
		exploder( destroyedObj.exploderIndex );
	
	[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + 1 );
	
	setGameEndTime( 0 );
	
	wait 3;
	
	// end the round without resetting the timer
	if ( level.roundLimit != 1 )
	{
		level.subRound = true;
		if ( maps\mp\gametypes\_globallogic::getTimeRemaining() / 1000 >= 15 )
		{
			level.subRoundOnly = true;
		}
		else
		{
			level.realEndReasonText = game["strings"]["time_limit_reached"];
		}
	}
	thread maps\mp\gametypes\_globallogic::endGame( team, game["strings"]["target_destroyed"] );
	
	//resetBombAndBombsites( destroyedObj );
}

playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}


bombTimerWait()
{
	level endon("bomb_defused");
	wait level.bombTimer;
}

resetBombAndBombsites( destroyedObj )
{
	level.sabBomb maps\mp\gametypes\_gameobjects::returnHome();
	level.sabBomb maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
	level.sabBomb maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	level.sabBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	
	destroyedObj resetBombsite();
	
	maps\mp\gametypes\_globallogic::resumeTimer();
	level.bombPlanted = false;
	level.bombPlantedBy = "";
	level.timeLimitOverride = false;
}

resetBombsite()
{
	self maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
	self maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
	self maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
	self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	self maps\mp\gametypes\_gameobjects::setKeyObject( level.sabBomb );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	self.useWeapon = "briefcase_bomb_mp";
}

setUpForDefusing()
{
	self maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	self maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
	self maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
	self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	self maps\mp\gametypes\_gameobjects::setKeyObject( undefined );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defuse" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_defend" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
}

bombDefused( object )
{
	maps\mp\gametypes\_globallogic::resumeTimer();
	level.bombPlanted = false;
	level.timeLimitOverride = false;
	level notify("bomb_defused");	
}
