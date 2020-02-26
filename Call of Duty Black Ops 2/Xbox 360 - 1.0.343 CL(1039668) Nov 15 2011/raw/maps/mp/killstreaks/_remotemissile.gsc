#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;

init()
{
	PrecacheItem( "remote_missile_missile_mp" );
	precacheShader("tow_filter_overlay_no_signal");
	
	level.rockets = [];
	
	registerKillstreak( "remote_missile_mp", "remote_missile_mp", "killstreak_remote_missile", "remote_missle_used", ::tryUsePredatorMissile, true );
	registerKillstreakAltWeapon( "remote_missile_mp", "remote_missile_missile_mp" );
	registerKillstreakStrings( "remote_missile_mp", &"KILLSTREAK_EARNED_REMOTE_MISSILE", &"KILLSTREAK_REMOTE_MISSILE_NOT_AVAILABLE", &"KILLSTREAK_REMOTE_MISSILE_INBOUND" );
	registerKillstreakDialog( "remote_missile_mp", "mpl_killstreak_rmissile_strt", "kls_predator_used", "", "kls_predator_enemy", "", "kls_predator_ready" );
	registerKillstreakDevDvar( "remote_missile_mp", "scr_givemissileremote" );
	
	level.missilesForSightTraces = [];

	level.remotemissile_fx[ "explode" ] = LoadFX( "explosions/aerial_explosion" );
	
	level.missileRemoteLaunchVert = 14000;
	level.missileRemoteLaunchHorz = 7000;
	level.missileRemoteLaunchTargetDist = 1500;

// Uncomment next line to override the default visionset when using the rc car	
//	level.remote_missile_vision = "remote_mortar_infrared";
}


tryUsePredatorMissile( lifeId )
{
	team = self.team;
	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "remote_missile_mp", team, false, true ) )
	{
		return false;
	}

	returnVar = _fire( lifeId, self, team );
	
	return returnVar;
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
		if ( !isAlive( player ) )
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
		
	//	assertEx( isDefined( bestSpawnPoint ), "Closest remote-missile spawnpoint undefined for player: " + player.name );
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

drawLine( start, end, timeSlice, color )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, color,false, 1 );
		wait ( 0.05 );
	}
}

_fire( lifeId, player, team )
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
		targetPos = remoteMissileSpawn.targetEnt.origin;

		//thread drawLine( startPos, targetPos, 30, (0,1,0) );

		vector = vectorNormalize( startPos - targetPos );		
		startPos = ( vector * 14000 ) + targetPos;

		//thread drawLine( startPos, targetPos, 15, (1,0,0) );
	}
	else
	{
		upVector = (0, 0, level.missileRemoteLaunchVert );
		backDist = level.missileRemoteLaunchHorz;
		targetDist = level.missileRemoteLaunchTargetDist;
		
		forward = AnglesToForward( player.angles );
		startpos = player.origin + upVector + forward * backDist * -1;
		targetPos = player.origin + forward * targetDist;
	}

	player.killstreak_waitamount = 10;
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( "qrdrone" );		
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			player.killstreak_waitamount = undefined;
			maps\mp\killstreaks\_killstreakrules::killstreakStop( "remote_missile_mp", team );
		}

		return false;
	}	

	rocket = MagicBullet( "remote_missile_missile_mp", startpos, targetPos, player );
	player LinkToMissile( rocket, true );
	rocket.owner = player;
	player thread cleanupWaiter( rocket );
		
	if ( IsDefined( level.remote_missile_vision ) )
	{
		self UseServerVisionset( true );
		self SetVisionSetForPlayer( level.remote_missile_vision, 1 );
	}
	self SetClientFlag( level.const_flag_operatingpredator );

	rocket missile_sound_play( player );
	player thread missile_sound_boost( rocket );
		
	rocket waittill( "death" );

	rocket missile_sound_stop();
	
	self UseServerVisionset( false );
	self ClearClientFlag( level.const_flag_operatingpredator );
		
	if ( isdefined( player ) ) 
	{
		player PlayRumbleOnEntity( "grenade_rumble" );
		player thread staticEffect( 0.5 );
		player.killstreak_waitamount = undefined;	
		player notify( "remotemissile_done" );
		wait( 0.5 );
		player UnlinkFromMissile();
	}
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "remote_missile_mp", team );

	return true;
}

cleanupWaiter( rocket )
{
	self endon("remotemissile_done"); 
	rocket endon("death");
	
	self waittill_any( "joined_team", "joined_spectators", "disconnect" );
	
	self.killstreak_waitamount = undefined;
	if ( isdefined( rocket.owner ) )
	{
		rocket.owner UnlinkFromMissile();
	}
	rocket Delete();
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
	
	//player CameraLinkTo( rocket, "tag_origin" );
	//player ControlsLinkTo( rocket );

	rocket thread Rocket_CleanupOnDeath();

	wait ( 2.0 );

	//player ControlsUnlink();
	//player CameraUnlink();	
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
/*
	//level endon ( "game_ended" );
	player endon ( "joined_team" );
	player endon ( "joined_spectators" );

	rocket thread Rocket_CleanupOnDeath();
	player thread Player_CleanupOnGameEnded( rocket );
	player thread Player_CleanupOnTeamChange( rocket );
	
	player VisionSetMissilecamForPlayer( "black_bw", 0 );

	player endon ( "disconnect" );

	if ( isDefined( rocket ) )
	{
		player VisionSetMissilecamForPlayer( game["thermal_vision"], 1.0 );
		player thread delayedFOFOverlay();
		//player CameraLinkTo( rocket, "tag_origin" );
		//player ControlsLinkTo( rocket );

		//if ( GetDvarInt( "camera_thirdPerson" ) )
		//	player setThirdPersonDOF( false );
	
		rocket waittill( "death" );

		// is defined check required because remote missile doesnt handle lifetime explosion gracefully
		// instantly deletes its self after an explode and death notify
		//if ( isDefined(rocket) )
		//	player maps\mp\_matchdata::logKillstreakEvent( "predator_missile", rocket.origin );
		
		//player ControlsUnlink();
		player freezeControlsWrapper( true );
	
		// If a player gets the final kill with a hellfire, level.gameEnded will already be true at this point
		if ( !level.gameEnded || isDefined( player.finalKill ) )
			player thread staticEffect( 0.5 );

		wait ( 0.5 );
		
		player ThermalVisionFOFOverlayOff();
		
		player CameraUnlink();
		
		//if ( GetDvarInt( "camera_thirdPerson" ) )
		//	player setThirdPersonDOF( true );
		
	}
	
	player clearUsingRemote();
*/
}


delayedFOFOverlay()
{
/*
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	wait ( 0.15 );
	
	self ThermalVisionFOFOverlayOn();
*/
}

staticEffect( duration )
{
	self endon ( "disconnect" );
	
	staticBG = newClientHudElem( self );
	staticBG.horzAlign = "fullscreen";
	staticBG.vertAlign = "fullscreen";
	staticBG setShader( "white", 640, 480 );
	staticBG.archive = true;
	staticBG.sort = 10;

	static = newClientHudElem( self );
	static.horzAlign = "fullscreen";
	static.vertAlign = "fullscreen";
	static setShader( "tow_filter_overlay_no_signal", 640, 480 );
	static.archive = true;
	static.sort = 20;
	
	wait ( duration );
	
	static destroy();
	staticBG destroy();
}


Player_CleanupOnTeamChange( rocket )
{
/*
	rocket endon ( "death" );
	self endon ( "disconnect" );

	self waittill_any( "joined_team" , "joined_spectators" );

	if ( self.team != "spectator" )
	{
		self ThermalVisionFOFOverlayOff();
		self ControlsUnlink();
		self CameraUnlink();	

		//if ( GetDvarInt( "camera_thirdPerson" ) )
		//	self setThirdPersonDOF( true );
	}
	self clearUsingRemote();
	
	level.remoteMissileInProgress = undefined;
*/
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
/*
	rocket endon ( "death" );
	self endon ( "death" );
	
	level waittill ( "game_ended" );
	
	self ThermalVisionFOFOverlayOff();
	self ControlsUnlink();
	self CameraUnlink();	

	//if ( GetDvarInt( "camera_thirdPerson" ) )
	//	self setThirdPersonDOF( true );
*/
}

missile_sound_play( player )
{
	snd_first_person = Spawn( "script_model", self.origin );
	snd_first_person SetModel( "tag_origin" );
	snd_first_person LinkTo( self );

	snd_first_person SetInvisibleToAll();
	snd_first_person SetVisibleToPlayer( player );
	snd_first_person PlayLoopSound( "wpn_remote_missile_loop_plr", .5 );

	self.snd_first = snd_first_person;

	snd_third_person = Spawn( "script_model", self.origin );
	snd_third_person SetModel( "tag_origin" );
	snd_third_person LinkTo( self );

	snd_third_person SetVisibleToAll();
	snd_third_person SetInvisibleToPlayer( player );
	snd_third_person PlayLoopSound( "wpn_remote_missile_loop_npc", .2 );

	self.snd_third = snd_third_person;
}

missile_sound_boost( rocket )
{
	self endon( "remotemissile_done" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self endon( "disconnect" );

	self waittill( "missile_boost" );
	rocket.snd_first PlayLoopSound( "wpn_remote_missile_boost_plr" );
}

missile_sound_stop()
{
	self.snd_first delete();
	self.snd_third delete();
}