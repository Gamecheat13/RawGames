#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	mapname = getDvar( "mapname" );
	if ( mapname == "mp_suburbia" )
	{
		level.missileRemoteLaunchVert = 7000;
		level.missileRemoteLaunchHorz = 10000;
		level.missileRemoteLaunchTargetDist = 2000;
	}
	else if ( mapname == "mp_mainstreet" )
	{
		level.missileRemoteLaunchVert = 7000;
		level.missileRemoteLaunchHorz = 10000;
		level.missileRemoteLaunchTargetDist = 2000;
	}
	else
	{
		level.missileRemoteLaunchVert = 14000;
		level.missileRemoteLaunchHorz = 7000;
		level.missileRemoteLaunchTargetDist = 1500;

	}	
	precacheItem( "remotemissile_projectile_mp" );
	precacheShader( "ac130_overlay_grain" );
	
	level.rockets = [];
	
	level.killstreakFuncs["predator_missile"] = ::tryUsePredatorMissile;
	
	level.missilesForSightTraces = [];
}


tryUsePredatorMissile( lifeId )
{
	/*
	if ( isDefined( self.lastStand ) && !self _hasPerk( "specialty_finalstand" ) )
	{
		self iPrintLnBold( "Killstreak cannot be used in Last Stand." );
		return false;
	}
	*/
				
	if ( isDefined( level.civilianJetFlyBy ) )
	{
		self iPrintLnBold( "Civilian air traffic in area." );
		return false;
	}

	level thread _fire( lifeId, self );
	
	return true;
}


getBestSpawnPoint( remoteMissileSpawnPoints )
{
	validEnemies = [];

	foreach ( spawnPoint in remoteMissileSpawnPoints )
	{
		spawnPoint.validPlayers = [];
		spawnPoint.spawnScore = 0;
	}
	
	foreach ( player in level.players )
	{
		if ( !isReallyAlive( player ) )
			continue;

		if ( player.team == self.team )
			continue;
		
		if ( player.team == "spectator" )
			continue;
		
		bestDistance = 999999999;
		bestSpawnPoint = undefined;
	
		foreach ( spawnPoint in remoteMissileSpawnPoints )
		{
			//could add a filtering component here but i dont know what it would be.
			spawnPoint.validPlayers[spawnPoint.validPlayers.size] = player;
		
			potentialBestDistance = Distance2D( spawnPoint.targetent.origin, player.origin );
			
			if ( potentialBestDistance <= bestDistance )
			{
				bestDistance = potentialBestDistance;
				bestSpawnpoint = spawnPoint;	
			}	
		}
		
		assertEx( isDefined( bestSpawnPoint ), "Closest remote-missile spawnpoint undefined for player: " + player.name );
		bestSpawnPoint.spawnScore += 2;
	}

	bestSpawn = remoteMissileSpawnPoints[0];
	foreach ( spawnPoint in remoteMissileSpawnPoints )
	{
		foreach ( player in spawnPoint.validPlayers )
		{
			spawnPoint.spawnScore += 1;
			
			if ( bulletTracePassed( player.origin + (0,0,32), spawnPoint.origin, false, player ) )
				spawnPoint.spawnScore += 3;
		
			if ( spawnPoint.spawnScore > bestSpawn.spawnScore )
			{
				bestSpawn = spawnPoint;
			}
			else if ( spawnPoint.spawnScore == bestSpawn.spawnScore ) // equal spawn weights so we toss a coin.
			{			
				if ( coinToss() )
					bestSpawn = spawnPoint;	
			}
		}
	}
	
	return ( bestSpawn );
}


_fire( lifeId, player )
{
	remoteMissileSpawnArray = getEntArray( "remoteMissileSpawn" , "targetname" );
	//assertEX( remoteMissileSpawnArray.size > 0 && getMapCustom( "map" ) != "", "No remote missile spawn points found.  Contact friendly neighborhood designer" );
	
	foreach ( spawn in remoteMissileSpawnArray )
	{
		if ( isDefined( spawn.target ) )
			spawn.targetEnt = getEnt( spawn.target, "targetname" );	
	}
	
	if ( remoteMissileSpawnArray.size > 0 )
		remoteMissileSpawn = player getBestSpawnPoint( remoteMissileSpawnArray );
	else
		remoteMissileSpawn = undefined;
	
	if ( isDefined( remoteMissileSpawn ) )
	{	
		startPos = remoteMissileSpawn.origin;	
		
		if ( isDefined( remoteMissileSpawn.script_targetoffset_z ) )
		{
			offset = remoteMissileSpawn.script_targetoffset_z;
			assertEx ( offset >= 0, "Remote missile offset must be a positive integer." );
			
			startPosVec = vectorNormalize( remoteMissileSpawn.origin - remoteMissileSpawn.targetEnt.origin ) * offset;
			startPos = startPosVec + remoteMissileSpawn.origin;		
		}
		
		targetPos = remoteMissileSpawn.targetEnt.origin;
		rocket = MagicBullet( "remotemissile_projectile_mp", startpos, targetPos, player );
	}
	else
	{
		upVector = (0, 0, level.missileRemoteLaunchVert );
		backDist = level.missileRemoteLaunchHorz;
		targetDist = level.missileRemoteLaunchTargetDist;
	
		forward = AnglesToForward( player.angles );
		startpos = player.origin + upVector + forward * backDist * -1;
		targetPos = player.origin + forward * targetDist;
		
		rocket = MagicBullet( "remotemissile_projectile_mp", startpos, targetPos, player );
	}

	if ( !IsDefined( rocket ) )
		return;
	
	rocket thread maps\mp\gametypes\_weapons::AddMissileToSightTraces( player.team );
	
	rocket thread handleDamage();
	
	rocket.lifeId = lifeId;
	rocket.type = "remote";
	MissileEyes( player, rocket );
}

/#
_fire_noplayer( lifeId, player )
{
	upVector = (0, 0, level.missileRemoteLaunchVert );
	backDist = level.missileRemoteLaunchHorz;
	targetDist = level.missileRemoteLaunchTargetDist;

	forward = AnglesToForward( player.angles );
	startpos = player.origin + upVector + forward * backDist * -1;
	targetPos = player.origin + forward * targetDist;
	
	rocket = MagicBullet( "remotemissile_projectile_mp", startpos, targetPos, player );

	if ( !IsDefined( rocket ) )
		return;

	rocket thread handleDamage();
	
	rocket.lifeId = lifeId;
	rocket.type = "remote";
	
	player CameraLinkTo( rocket, "tag_origin" );
	player ControlsLinkTo( rocket );

	rocket thread Rocket_CleanupOnDeath();

	wait ( 2.0 );

	player ControlsUnlink();
	player CameraUnlink();	
}
#/

handleDamage()
{
	self endon ( "death" );
	self endon ( "deleted" );

	self setCanDamage( true );

	for ( ;; )
	{
	  self waittill( "damage" );
	  
	  println ( "projectile damaged!" );
	}
}	


MissileEyes( player, rocket )
{
	//level endon ( "game_ended" );
	player endon ( "joined_team" );
	player endon ( "joined_spectators" );

	player setUsingRemote( "remotemissile" );
	rocket thread Rocket_CleanupOnDeath();
	player thread Player_CleanupOnGameEnded( rocket );
	player thread Player_CleanupOnTeamChange( rocket );
	
	player VisionSetMissilecamForPlayer( "black_bw", 0 );
	result = player maps\mp\killstreaks\_killstreaks::initRideKillstreak();

	if ( result == "disconnect" )
	{
		rocket delete();
		return;
	}

	player endon ( "disconnect" );

	if ( isDefined( rocket ) && result == "success" )
	{
		player VisionSetMissilecamForPlayer( game["thermal_vision"], 1.0 );
		player ThermalVisionFOFOverlayOn();
		player CameraLinkTo( rocket, "tag_origin" );
		player ControlsLinkTo( rocket );
	
		rocket waittill( "death" );

		// is defined check required because remote missile doesnt handle lifetime explosion gracefully
		// instantly deletes its self after an explode and death notify
		if ( isDefined(rocket) )
			player maps\mp\_matchdata::logKillstreakEvent( "predator_missile", rocket.origin );
		
		player ControlsUnlink();
		player freezeControls( true );
	
		player thread staticEffect( 0.5 );

		wait ( 0.5 );
		
		player ThermalVisionFOFOverlayOff();
		
		player CameraUnlink();
		
	}
	
	player clearUsingRemote();
}


staticEffect( duration )
{
	self endon ( "disconnect" );
	
	static = newClientHudElem( self );
	static.horzAlign = "fullscreen";
	static.vertAlign = "fullscreen";
	static setShader( "ac130_overlay_grain", 640, 480 );
	static.archive = true;
	
	wait ( duration );
	
	static destroy();
}


Player_CleanupOnTeamChange( rocket )
{
	rocket endon ( "death" );
	self endon ( "disconnect" );

	self waittill_any( "joined_team" , "joined_spectators" );

	if ( self.team != "spectator" )
	{
		self ThermalVisionFOFOverlayOff();
		self ControlsUnlink();
		self CameraUnlink();	
	}
	self clearUsingRemote();
	
	level.remoteMissileInProgress = undefined;
}


Rocket_CleanupOnDeath()
{
	entityNumber = self getEntityNumber();
	level.rockets[ entityNumber ] = self;
	self waittill( "death" );	
	
	level.rockets[ entityNumber ] = undefined;
}


Player_CleanupOnGameEnded( rocket )
{
	rocket endon ( "death" );
	self endon ( "death" );
	
	level waittill ( "game_ended" );
	
	self ThermalVisionFOFOverlayOff();
	self ControlsUnlink();
	self CameraUnlink();	
}
