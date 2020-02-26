#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\killstreaks\_airsupport;

#insert raw\maps\mp\_clientflags.gsh;

#define REMOTE_MISSILE_MAX_OTHER_TARGETS_HUD 3
#define REMOTE_MISSILE_TARGETING_RADIUS 600
#define REMOTE_MISSILE_BOMBLETS_NUMBER 8
#define REMOTE_MISSILE_TIMEOUT 10

init()
{
	PrecacheItem( "remote_missile_missile_mp" );
	PrecacheItem( "remote_missile_bomblet_mp" );
	precacheShader("tow_filter_overlay_no_signal");
	//PrecacheShader( "hud_rts_reticle" );
	PrecacheShader( "reticle_side_round_big_top" );
	PrecacheShader( "reticle_side_round_big_right" );
	PrecacheShader( "reticle_side_round_big_left" );
	PrecacheShader( "reticle_side_round_big_bottom" );
	PrecacheShader( "hud_remote_missile_target" );
	
	level.rockets = [];
	
	registerKillstreak( "remote_missile_mp", "remote_missile_mp", "killstreak_remote_missile", "remote_missle_used", ::tryUsePredatorMissile, true );
	registerKillstreakAltWeapon( "remote_missile_mp", "remote_missile_missile_mp" );
	registerKillstreakAltWeapon( "remote_missile_mp", "remote_missile_bomblet_mp" );
	registerKillstreakStrings( "remote_missile_mp", &"KILLSTREAK_EARNED_REMOTE_MISSILE", &"KILLSTREAK_REMOTE_MISSILE_NOT_AVAILABLE", &"KILLSTREAK_REMOTE_MISSILE_INBOUND" );
	registerKillstreakDialog( "remote_missile_mp", "mpl_killstreak_cruisemissile", "kls_predator_used", "", "", "", "kls_predator_ready" );
	registerKillstreakDevDvar( "remote_missile_mp", "scr_givemissileremote" );
	
	level.missilesForSightTraces = [];

	level.missileRemoteDeployFX = loadFX( "weapon/predator/fx_predator_cluster_trigger" );
	level.missileRemoteLaunchVert = 18000;
	level.missileRemoteLaunchHorz = 7000;
	level.missileRemoteLaunchTargetDist = 1500;
}


tryUsePredatorMissile( lifeId )
{
	team = self.team;
	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( "remote_missile_mp", team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}

	returnVar = _fire( lifeId, self, team, killstreak_id );
	
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
	/#
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, color,false, 1 );
		wait ( 0.05 );
	}
	#/
}

_fire( lifeId, player, team, killstreak_id )
{
	remoteMissileSpawnArray = getEntArray( "remoteMissileSpawn" , "targetname" );
	
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

		vector = vectorNormalize( startPos - targetPos );		
		startPos = ( vector * level.missileRemoteLaunchVert ) + targetPos;
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
			maps\mp\killstreaks\_killstreakrules::killstreakStop( "remote_missile_mp", team, killstreak_id );
		}

		return false;
	}	

	rocket = MagicBullet( "remote_missile_missile_mp", startpos, targetPos, player );
	
	rocket.targetname = "remote_missile";
	rocket.team = team;
	rocket setTeam( team );
	
	rocket thread handleDamage();
	
	player LinkToMissile( rocket, true );
	rocket.owner = player;
	rocket.killcament = player;
	player thread cleanupWaiter( rocket );
	rocket.targeting_radius = REMOTE_MISSILE_TARGETING_RADIUS;
		
	if ( IsDefined( level.remote_missile_vision ) )
	{
		self UseServerVisionset( true );
		self SetVisionSetForPlayer( level.remote_missile_vision, 1 );
	}
	self SetClientFlag( CLIENT_FLAG_OPERATING_PREDATOR );
	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "remote_missile_mp", self.pers["team"] );

	rocket missile_sound_play( player );
	rocket thread missile_timeout_watch();
	player thread missile_sound_boost( rocket );
	player thread missile_deploy_watch( rocket );
	
	rocket maps\mp\gametypes\_spawning::create_tvmissile_influencers( team );
		
	rocket waittill( "death" );

	if( isDefined(rocket) )
	{
		rocket maps\mp\gametypes\_spawning::remove_tvmissile_influencers();
	
		rocket missile_sound_stop();
	}
	
	self thread destroy_missile_hud();
	
	self UseServerVisionset( false );
	self ClearClientFlag( CLIENT_FLAG_OPERATING_PREDATOR );
		
	if ( isdefined( player ) ) 
	{
		player PlayRumbleOnEntity( "grenade_rumble" );
		player thread staticEffect( 0.75 );
		player thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0.5, 0.25, 0.1, 0.25 );
		player.killstreak_waitamount = undefined;	
		player notify( "remotemissile_done" );
		rocket hide();
		wait( 0.85 );
		player UnlinkFromMissile();
	}
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "remote_missile_mp", team, killstreak_id );
	
	if (isDefined(rocket))
		rocket Delete();

	return true;
}

missile_timeout_watch()
{
	self endon( "death" );
	
	wait ( REMOTE_MISSILE_TIMEOUT - 0.05 );
	if ( isDefined( self ) )
	{
		self maps\mp\gametypes\_spawning::remove_tvmissile_influencers();
		self missile_sound_stop();
	}
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
	
	rocket thread Rocket_CleanupOnDeath();

	wait ( 2.0 );
}
#/

handleDamage()
{
	self endon ( "death" );
	self endon ( "deleted" );

	self setCanDamage( true );

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, tagName, modelName, partName, weapon );
		
		if ( isdefined ( attacker ) ) 
		{
			maps\mp\_scoreevents::processScoreEvent( "destroyed_remote_missile", attacker, self.owner, weapon );
		}
		self remove_tvmissile_influencers();
		self Detonate();
	}
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

Rocket_CleanupOnDeath()
{
	entityNumber = self getEntityNumber();
	level.rockets[ entityNumber ] = self;
	self waittill( "death" );	
	
	level.rockets[ entityNumber ] = undefined;
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
	rocket.snd_first PlaySound( "wpn_remote_missile_fire_boost" );
}

missile_sound_stop()
{
	self.snd_first delete();
	self.snd_third delete();
}

getValidTargets( rocket )
{
	targets = [];
	
	traceOrigin = rocket.origin;
	forward = AnglesToForward ( rocket.angles );
	aimTarget = BulletTrace( traceOrigin, traceOrigin + forward * 100000, true, rocket );

//	/#
//	circle( aimTarget["position"], REMOTE_MISSILE_TARGETING_RADIUS, (1,1,1), true, true, 2000 );
//	#/
	
	foreach( player in level.players )
	{
		if ( Distance2D( player.origin, aimTarget["position"]) < rocket.targeting_radius && player.team != self.team && !player HasPerk( "specialty_nokillstreakreticle" ))
		{
			targets[targets.size] = player;
		}
		
	}

	dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();
		
	foreach( dog in dogs )
	{
		if ( Distance2D( dog.origin, aimTarget["position"]) < rocket.targeting_radius && dog.aiteam != self.team )
		{
			targets[targets.size] = dog;
		}
	}
	
	tanks = GetEntArray( "talon", "targetname" );
		
	foreach( tank in tanks )
	{
		if ( Distance2D( tank.origin, aimTarget["position"]) < rocket.targeting_radius && tank.aiteam != self.team )
		{
			targets[targets.size] = tank;
		}
	}
	
	return targets;
}

create_missile_hud( rocket )
{	
	
	self.deploy_hud_center = newclienthudelem( self );
	self.deploy_hud_center.alignX = "center";
	self.deploy_hud_center.alignY = "bottom";
	self.deploy_hud_center.horzAlign = "user_center";
	self.deploy_hud_center.vertAlign = "user_bottom";
	self.deploy_hud_center.foreground = true;
	self.deploy_hud_center.font = "small";
	self.deploy_hud_center.fontScale = 1.25;
	self.deploy_hud_center SetText(&"KILLSTREAK_REMOTE_MISSILE_DEPLOY");
	self.deploy_hud_center.hidewheninmenu = true;
	self.deploy_hud_center.x = 0;
	self.deploy_hud_center.y = -90;
		
//	self.missile_reticle = newclienthudelem( self );
//	self.missile_reticle.alignX = "center";
//	self.missile_reticle.alignY = "middle";
//	self.missile_reticle.horzAlign = "user_center";
//	self.missile_reticle.vertAlign = "user_center";
//	self.missile_reticle.foreground = true;
//	self.missile_reticle.font = "small";ya 
//	self.missile_reticle SetShader("hud_rts_reticle", 20, 20);
//	self.missile_reticle.hidewheninmenu = false;
//	self.missile_reticle.x = 0;
//	self.missile_reticle.y = 0;
	
	self.missile_reticle_top = newclienthudelem( self );
	self.missile_reticle_top.alignX = "center";
	self.missile_reticle_top.alignY = "middle";
	self.missile_reticle_top.horzAlign = "user_center";
	self.missile_reticle_top.vertAlign = "user_center";
	self.missile_reticle_top.foreground = true;
	self.missile_reticle_top.font = "small";
	self.missile_reticle_top SetShader("reticle_side_round_big_top", 140, 64);
	self.missile_reticle_top.hidewheninmenu = false;
	self.missile_reticle_top.x = 0;
	self.missile_reticle_top.y = 0;
	
	self.missile_reticle_bottom = newclienthudelem( self );
	self.missile_reticle_bottom.alignX = "center";
	self.missile_reticle_bottom.alignY = "middle";
	self.missile_reticle_bottom.horzAlign = "user_center";
	self.missile_reticle_bottom.vertAlign = "user_center";
	self.missile_reticle_bottom.foreground = true;
	self.missile_reticle_bottom.font = "small";
	self.missile_reticle_bottom SetShader("reticle_side_round_big_bottom", 140, 64);
	self.missile_reticle_bottom.hidewheninmenu = false;
	self.missile_reticle_bottom.x = 0;
	self.missile_reticle_bottom.y = 0;
	
	self.missile_reticle_right = newclienthudelem( self );
	self.missile_reticle_right.alignX = "center";
	self.missile_reticle_right.alignY = "middle";
	self.missile_reticle_right.horzAlign = "user_center";
	self.missile_reticle_right.vertAlign = "user_center";
	self.missile_reticle_right.foreground = true;
	self.missile_reticle_right.font = "small";
	self.missile_reticle_right SetShader("reticle_side_round_big_right", 64, 140);
	self.missile_reticle_right.hidewheninmenu = false;
	self.missile_reticle_right.x = 0;
	self.missile_reticle_right.y = 0;
	
	self.missile_reticle_left = newclienthudelem( self );
	self.missile_reticle_left.alignX = "center";
	self.missile_reticle_left.alignY = "middle";
	self.missile_reticle_left.horzAlign = "user_center";
	self.missile_reticle_left.vertAlign = "user_center";
	self.missile_reticle_left.foreground = true;
	self.missile_reticle_left.font = "small";
	self.missile_reticle_left SetShader("reticle_side_round_big_left", 64, 140);
	self.missile_reticle_left.hidewheninmenu = false;
	self.missile_reticle_left.x = 0;
	self.missile_reticle_left.y = 0;	
	
	self.missile_target_icons = [];
	
	foreach (player	in level.players)
	{
		if (player.team == self.team)
			continue;
		index = player.clientId;
		self.missile_target_icons[index] = newClientHudElem( self );
		self.missile_target_icons[index].x = 0;
		self.missile_target_icons[index].y = 0;
		self.missile_target_icons[index].z = 0;
		self.missile_target_icons[index].alpha = 0;
		self.missile_target_icons[index].archived = true;
		self.missile_target_icons[index] setShader( "hud_remote_missile_target", 700, 700 );
		self.missile_target_icons[index] setWaypoint( false );
		self.missile_target_icons[index].foreground = true;
		self.missile_target_icons[index].hidewheninmenu = false;
		self.missile_target_icons[index].overrridewhenindemo = true;	
	}	
	
	for(i=0; i<REMOTE_MISSILE_MAX_OTHER_TARGETS_HUD; i++ )
	{
		self.missile_target_other[i] = newClientHudElem( self );
		self.missile_target_other[i].x = 0;
		self.missile_target_other[i].y = 0;
		self.missile_target_other[i].z = 0;
		self.missile_target_other[i].alpha = 0;
		self.missile_target_other[i].archived = true;
		self.missile_target_other[i] setShader( "hud_remote_missile_target", 700, 700 );
		self.missile_target_other[i] setWaypoint( false );
		self.missile_target_other[i].foreground = true;
		self.missile_target_other[i].hidewheninmenu = false;
		self.missile_target_other[i].overrridewhenindemo = true;	
	}
	rocket.iconIndexOther = 0;
	
	self thread targeting_hud_think( rocket );
	self thread reticle_hud_think( rocket );
}

destroy_missile_hud()
{
	
	if (isDefined(self.deploy_hud_center))
	{
		self.deploy_hud_center destroy();
	}
	if (isDefined(self.missile_reticle))
	{
		self.missile_reticle destroy();
	}
	if (isDefined(self.missile_reticle_top))
	{
		self.missile_reticle_top destroy();
	}
	if (isDefined(self.missile_reticle_bottom))
	{
		self.missile_reticle_bottom destroy();
	}
	if (isDefined(self.missile_reticle_right))
	{
		self.missile_reticle_right destroy();
	}
	if (isDefined(self.missile_reticle_left))
	{
		self.missile_reticle_left destroy();
	}
	if (isDefined( self.missile_target_icons) )
	{
		foreach (player	in level.players)
		{
			if (player.team == self.team)
				continue;
			index = player.clientId;
			if (isDefined(self.missile_target_icons[index]))
			{
				self.missile_target_icons[index] Destroy();
			}
		}
	}
	if (isDefined( self.missile_target_other) )
	{
		for( i=0; i<REMOTE_MISSILE_MAX_OTHER_TARGETS_HUD; i++)
		{
			self.missile_target_other[i] Destroy();
		}
	}
}

targeting_hud_think( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("death");
	level endon ( "game_ended" );
	
			
	while( true )
	{	
		foreach (icon in self.missile_target_icons)
		{
			icon.alpha = 0;
		}
		targets = self getValidTargets( rocket );
		if (targets.size > 0)
		{
			foreach (target in targets)
			{				
				if ( target.classname != "actor_enemy_dog_mp" && target.classname != "script_vehicle")
				{
					index = target.clientId;			
					self.missile_target_icons[index].x = target.origin[0];
					self.missile_target_icons[index].y = target.origin[1];
					self.missile_target_icons[index].z = target.origin[2] + 35;
					self.missile_target_icons[index].alpha = 1;
				}
				else
				{
					if( !isDefined(target.missileIconIndex))
					{
						target.missileIconIndex = rocket.iconIndexOther;
						rocket.iconIndexOther = (rocket.iconIndexOther + 1) % REMOTE_MISSILE_MAX_OTHER_TARGETS_HUD;
					}
					index = target.missileIconIndex;			
					self.missile_target_other[index].x = target.origin[0];
					self.missile_target_other[index].y = target.origin[1];
					self.missile_target_other[index].z = target.origin[2];
					self.missile_target_other[index].alpha = 1;
				}
			}
		}			
		
		wait (0.05);
	}
}
		
reticle_hud_think( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("death");
	level endon ( "game_ended" );
	
	first = true;
	while( true )
	{	
		//1000 is max that will fit the screen		
		//real FOV is 15 so we should be dividing by 7.5 if we switch to the camera eye location
		reticleSize = int( min( max( 0, 1000 * atan( REMOTE_MISSILE_TARGETING_RADIUS / max( 0.1, (rocket.origin[2] - self.origin[2]))) / 9 ), 1500));
		//self.missile_reticle SetShader("hud_rts_reticle", reticleSize, reticleSize);
		if ( !first )
		{
			self.missile_reticle_top MoveOverTime( 0.05 );
			self.missile_reticle_bottom MoveOverTime( 0.05 );
			self.missile_reticle_right MoveOverTime( 0.05 );
			self.missile_reticle_left MoveOverTime( 0.05 );
		}
		else
		{
			first = false;
		}
		
		self.missile_reticle_top.y = -reticleSize/2.4;
		self.missile_reticle_bottom.y = reticleSize/2.4;
		self.missile_reticle_right.x = reticleSize/2.4;
		self.missile_reticle_left.x = -reticleSize/2.4;
		//self.missile_reticle_top.alpha = max(1 - reticleSize/1000, 0);
		wait (0.05);
	}
}

missile_deploy_watch( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("death");
	level endon ( "game_ended" );	
	
	wait ( 0.25 );
	
	self thread create_missile_hud( rocket );
	
	explosionRadius = 0;
	
	while( true )
	{
		if ( self FragButtonPressed() )
		{				
			targets = self getValidTargets( rocket );
			if (targets.size > 0)
			{
				foreach (target in targets)
				{
					self thread fire_bomblet( rocket, explosionRadius, target );
				}
			}
			
			bomblet = MagicBullet( "remote_missile_bomblet_mp", rocket.origin, rocket.origin + AnglesToForward ( rocket.angles ) * 1000, self);
			bomblet.killcamEnt = rocket;
			for (i=targets.size; i<=REMOTE_MISSILE_BOMBLETS_NUMBER; i++)
			{
				self thread fire_random_bomblet( rocket, explosionRadius );
			}
			
			playfx( level.missileRemoteDeployFX, rocket.origin, anglestoForward( rocket.angles ) );
			self playLocalSound("mpl_turret_alert");
			self PlayRumbleOnEntity( "sniper_fire" );			
			Earthquake( 0.2, 0.2, rocket.origin, 200 );
						
			//still rocket for viewing the bomblets
			rocket Hide();
			//wait(0.5);
			rocket notify("death");
			self notify("remotemissile_done");
			return;
		}
		else
		{
			wait( 0.05 ); 				
		} 
	}
}

fire_bomblet( rocket, explosionRadius, target )
{
	origin = rocket.origin; 

	bomblet = MagicBullet( "remote_missile_bomblet_mp", origin, target.origin + (0,0,50), self, target, (0,0,30) );
	bomblet.killcamEnt = rocket.owner;
}

fire_random_bomblet( rocket, explosionRadius )
{
	origin = rocket.origin;
	angles = rocket.angles;
	owner = rocket.owner;
	
	wait ( RandomFloat(0.4) );
	
	bomblet = MagicBullet( "remote_missile_bomblet_mp", origin, origin + AnglesToForward ( angles + (RandomIntRange(-6,7), RandomIntRange(-20,21), 0 )) * 1000, self);
	bomblet.killcamEnt = owner;
}