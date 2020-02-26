#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Global Thermal Nuclear War
*/

/*QUAKED mp_ctf_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_ctf_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimitDvar( level.gameType, 3, 0, 1440 );
	registerScoreLimitDvar( level.gameType, 1, 0, 10000 );
	registerRoundLimitDvar( level.gameType, 1, 0, 30 );
	registerWinLimitDvar( level.gameType, 1, 0, 10 );
	registerRoundSwitchDvar( level.gameType, 0, 0, 30 );
	registerNumLivesDvar( level.gameType, 1, 0, 10 );
	registerHalfTimeDvar( level.gameType, 0, 0, 1 );
	
	level.teamBased = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onDeadEvent = ::onDeadEvent;
	level.onPlayerKilled = ::onPlayerKilled;
	level.initGametypeAwards = ::initGametypeAwards;
	level.onTimeLimit = ::onTimeLimit;
	level.gtnw = true;
	
}

gtnw_endGame( winningTeam, endReasonText )
{
	thread maps\mp\gametypes\_gamelogic::endGame( winningTeam, endReasonText );
}


onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( !isdefined( game["original_defenders"] ) )
		game["original_defenders"] = game["defenders"];

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	setClientNameMode("auto_change");
	
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_GTNW" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_GTNW" );
	}
	else
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_GTNW_SCORE" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_GTNW_SCORE" );
	}
	
	setObjectiveText( game["attackers"], &"OBJECTIVES_GTNW" );
	setObjectiveText( game["defenders"], &"OBJECTIVES_GTNW" );
	
	setObjectiveHintText( game["attackers"], &"OBJECTIVES_GTNW_HINT" );
	setObjectiveHintText( game["defenders"], &"OBJECTIVES_GTNW_HINT" );
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_ctf_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_ctf_spawn_axis" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	thread maps\mp\gametypes\_dev::init();
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 20 );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 500 );

	allowed[0] = "airdrop_pallet";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread nuke();
}


nuke()
{
	nukeTarget = getEnt( "nuke" , "targetname" );
	
	while ( level.players.size <= 0 )
	{
		wait 0.05;
	}
	
	randPlayer = RandomInt( level.players.size );
	
	wait ( 10 );
	
	while( !isDefined( level.players[randPlayer] ) || !isReallyAlive(level.players[randPlayer] ) || level.players[randPlayer].team == "spectator" )
	{
		randPlayer = RandomInt( level.players.size );
		wait ( 0.10 );
	}
	//level thread monitorNuke();
	level thread monitorNukeLand();
	
	self thread maps\mp\killstreaks\_airdrop::dropNuke( nukeTarget.origin, level.players[randPlayer], "nuke_drop" );
}


getSpawnPoint()
{
	if ( self.team == "axis" )
	{
		spawnTeam = game["attackers"];
	}
	else
	{
		spawnTeam = game["defenders"];
	}

	if ( level.inGracePeriod )
	{
		spawnPoints = getentarray("mp_ctf_spawn_" + spawnteam + "_start", "classname");		
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;
}


spawnFxDelay( fxid, pos, forward, right, delay )
{
	wait delay;
	effect = spawnFx( fxid, pos, forward, right );
	triggerFx( effect );
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId )
{
	thread checkAllowSpectating();
}

checkAllowSpectating()
{
	wait ( 0.05 );
	
	update = false;
	if ( !level.aliveCount[ game["attackers"] ] )
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( !level.aliveCount[ game["defenders"] ] )
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( update )
		maps\mp\gametypes\_spectating::updateSpectateSettings();
}


onDeadEvent( team )
{
	if ( ( isDefined( level.nukeIncoming ) && level.nukeIncoming ) || ( isDefined( level.nukeDetonated ) && level.nukeDetonated ) )
		return;
	
	if ( team == game["attackers"] )
	{
		level thread gtnw_endGame( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		level thread gtnw_endGame( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
	}
}

initGametypeAwards()
{
	return;
}


onTimeLimit()
{
	level thread gtnw_endGame( "tie", game["strings"]["time_limit_reached"] );
}

onPrecacheGameType()
{
	return;
}

monitorNuke()
{
	level waittill( "nukeCaptured", player );
	
	team = player.pers["team"];
	if ( team == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	wait ( 13 );
	player thread maps\mp\gametypes\_hud_message::SplashNotify( "capture", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
	maps\mp\gametypes\_gamescore::givePlayerScore( "capture", player );
	player thread [[level.onXPEvent]]( "capture" );
	player notify( "objective", "captured" );
	
	maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( team, 1 );	
}


monitorNukeLand()
{
	level endon ( "game_ended" );

	while ( !isDefined( level.nukeCrate ) )
		wait( 1 );
	
	nukeTargetTrigger = spawn( "trigger_radius", level.nukeCrate.origin, 0, 128, 128 );

	visuals = [];
	visuals[0] = level.nukeCrate;
	
	nukeProxTrig = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", nukeTargetTrigger, visuals, (0,0,32) );
	nukeProxTrig maps\mp\gametypes\_gameobjects::allowUse( "any" );
	nukeProxTrig maps\mp\gametypes\_gameobjects::setUseTime( 45.0 );
	nukeProxTrig maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_NUKE" ); //temp
	nukeProxTrig maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	nukeProxTrig.onUse = ::onUse;
	nukeProxTrig.onBeginUse = ::onBeginUse;
}


onBeginUse( player )
{
	self.didStatusNotify = false;
	
	otherTeam = getOtherTeam( player.pers["team"] );
	
	return;
}


onUse( player )
{
	team = player.pers["team"];
	oldTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	label = self maps\mp\gametypes\_gameobjects::getLabel();
	
	self.captureTime = getTime();
	
	otherTeam = getOtherTeam( team );
	
	level.nukeCrate notify( "captured", player );
	player notify( "objective", "captured" );
	self giveFlagCaptureXP( self.touchList[team] );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );
}

giveFlagCaptureXP( touchList )
{
	level endon ( "game_ended" );
	wait .05;
	WaitTillSlowProcessAllowed();
	
	players = getArrayKeys( touchList );
	for ( index = 0; index < players.size; index++ )
	{
		player = touchList[players[index]].player;
		player thread maps\mp\gametypes\_hud_message::SplashNotify( "captured_nuke", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
		player thread [[level.onXPEvent]]( "capture" );
		maps\mp\gametypes\_gamescore::givePlayerScore( "capture", player );
	}
}