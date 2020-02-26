#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\killstreaks\_airsupport;
#insert raw\maps\mp\_clientflags.gsh;

init()
{
	level.missile_swarm_max			= 4;
	level.missile_swarm_flyheight	= 2500;
	level.missile_swarm_flydist		= 5000;
	
	set_dvar_float_if_unset( "scr_missile_swarm_lifetime", 40.0 );
	
	PrecacheItem( "missile_swarm_projectile_mp" );

	level.swarm_fx[ "swarm" ] = LoadFX( "weapon/harpy_swarm/fx_hrpy_swrm_runner" );
	level.swarm_fx["swarm_tail"] = LoadFx( "weapon/harpy_swarm/fx_hrpy_swrm_exhaust_trail_close" );

	registerKillstreak( "missile_swarm_mp", "missile_swarm_mp", "killstreak_missile_swarm", "missile_swarm_used", ::swarm_killstreak, true );
	registerKillstreakAltWeapon( "missile_swarm_mp", "missile_swarm_projectile_mp" );
	registerKillstreakStrings( "missile_swarm_mp", &"KILLSTREAK_EARNED_MISSILE_SWARM", &"KILLSTREAK_MISSILE_SWARM_NOT_AVAILABLE", &"KILLSTREAK_MISSILE_SWARM_INBOUND" );
	registerKillstreakDialog( "missile_swarm_mp", "mpl_killstreak_missile_swarm", "kls_swarm_used", "", "kls_swarm_enemy", "", "kls_swarm_ready" );
	registerKillstreakDevDvar( "missile_swarm_mp", "scr_givemissileswarm" );
	
	maps\mp\killstreaks\_killstreaks::createKillstreakTimer( "missile_swarm_mp" );
	
/#
	set_dvar_int_if_unset( "scr_missile_swarm_cam", 0 );
#/
}

swarm_killstreak( hardpointType )
{
	assert( hardpointType == "missile_swarm_mp" );
	
	level.missile_swarm_origin = level.mapCenter + ( 0, 0, level.missile_swarm_flyheight );

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( "missile_swarm_mp", self.team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}

	level thread swarm_killstreak_start( self, killstreak_id );

	return true;
}

swarm_killstreak_start( owner, killstreak_id )
{
	level endon( "swarm_end" );

	missiles = GetEntArray( "swarm_missile", "targetname" );

	foreach( missile in missiles )
	{
		if ( IsDefined( missile ) )
		{
			missile Detonate();
			wait( 0.10 );
		}
	}

	level.missile_swarm_fx = undefined;
	level.missile_swarm_team = owner.team;
	level.missile_swarm_owner = owner;
	owner maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "missile_swarm_mp", owner.pers["team"] );
	level create_player_targeting_array( owner, owner.team );
	
	level thread swarm_killstreak_abort( owner, killstreak_id );
	level thread swarm_killstreak_watch_for_emp( owner, killstreak_id );
	level thread swarm_killstreak_fx();
	wait ( 2 );
	level thread swarm_think( owner, killstreak_id );
}

swarm_killstreak_end( owner, detonate, killstreak_id )
{
	level notify( "swarm_end" );

	level.missile_swarm_fx ClearClientFlag( CLIENT_FLAG_MISSILE_SWARM );

	missiles = GetEntArray( "swarm_missile", "targetname" );
	
	if ( is_true( detonate ) )
	{
		foreach( missile in missiles )
		{
			if ( IsDefined( missile ) )
			{
				missile Detonate();
				wait( 0.10 );
			}
		}
	}
	else
	{
		foreach( missile in missiles )
		{
			if ( IsDefined( missile ) )
			{
				yaw		= RandomIntRange( 0, 360 );
				angles	= ( 0, yaw, 0 );

				forward = AnglesToForward( angles );
				
				if ( IsDefined( missile.goal ) )
					missile.goal.origin = missile.origin + forward * level.missile_swarm_flydist * 1000;
			}
		}
	}

	wait( 1 );
	level.missile_swarm_fx delete();

	level.missile_swarm_sound StopLoopSound( 2 );
	wait( 2 );
	level.missile_swarm_sound delete();

	// maps\mp\killstreaks\_killstreaks::setKillstreakTimer( "missile_swarm_mp", owner.team, 0 );
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "missile_swarm_mp", level.missile_swarm_team, killstreak_id );
	level.missile_swarm_owner = undefined;
	
	wait ( 3 );
	missiles = GetEntArray( "swarm_missile", "targetname" );
	
	foreach( missile in missiles )
	{
		if ( IsDefined( missile ) )
		{
			missile Delete();
			wait( 0.10 );
		}
	}
}

swarm_killstreak_abort( owner, killstreak_id )
{
	level endon( "swarm_end" );

	owner waittill_any( "disconnect", "joined_team", "joined_spectators", "emp_jammed" );
	level thread swarm_killstreak_end( owner, true, killstreak_id );
}

swarm_killstreak_watch_for_emp( owner, killstreak_id )
{
	level endon( "swarm_end" );
	
	owner waittill( "emp_destroyed_missile_swarm", attacker );
	
	maps\mp\_scoreevents::processScoreEvent( "destroyed_missile_swarm", attacker, owner, "emp_mp" );
	
	level thread swarm_killstreak_end( owner, true, killstreak_id );
}

swarm_killstreak_fx()
{
	level endon( "swarm_end" );
	
	// fx
	level.missile_swarm_fx = Spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx SetModel( "tag_origin" );
	level.missile_swarm_fx.angles = ( 0, 0, 0 );

	level.missile_swarm_sound = Spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_sound SetModel( "tag_origin" );
	level.missile_swarm_sound.angles = ( 0, 0, 0 );

	wait( 0.05 );

	PlayFxOnTag( level.swarm_fx[ "swarm" ], level.missile_swarm_fx, "tag_origin" );
	
	wait( 4 );

	level.missile_swarm_sound PlayLoopSound( "veh_harpy_drone_swarm_lp", 3 );
	PlayFxOnTag( level.swarm_fx[ "swarm" ], level.missile_swarm_fx, "tag_origin" );

	wait( 2 );
	
	level.missile_swarm_fx SetClientFlag( CLIENT_FLAG_MISSILE_SWARM );
}

swarm_think( owner, killstreak_id )
{
	level endon( "swarm_end" );

	lifetime = GetDvarFloat( "scr_missile_swarm_lifetime" );
	// maps\mp\killstreaks\_killstreaks::setKillstreakTimer( "missile_swarm_mp", owner.team, lifetime );
	end_time = GetTime() + ( lifetime * 1000 );
	level.missile_swarm_count = 0;
	
	while ( GetTime() < end_time )
	{
		assert( level.missile_swarm_count >= 0 );

		if ( level.missile_swarm_count >= level.missile_swarm_max )
		{
			wait( 0.5 );
			continue;
		}

		count = 1;//RandomIntRange( 1, level.missile_swarm_max );
		level.missile_swarm_count += count;

		for ( i = 0; i < count; i++ )
		{
			projectile_spawn( owner );
		}

		wait( ( level.missile_swarm_count / level.missile_swarm_max ) + 1.5 );
	}

	level thread swarm_killstreak_end( owner, undefined, killstreak_id );
}

/#
projectile_cam( player )
{
	player.swarm_cam = true;
	wait( 0.05 );
	
	forward = AnglesToForward( self.angles );
	cam = Spawn( "script_model", self.origin + ( 0, 0, 300 ) + forward * -200 );
	cam SetModel( "tag_origin" );
	cam LinkTo( self );
		
	player CameraSetPosition( cam );
	player CameraSetLookAt( self );
	player CameraActivate( true );	

	self waittill( "death" );
	wait( 1 );

	player CameraActivate( false );
	cam delete();
	player.swarm_cam = false;
}
#/

projectile_goal_move()
{
	self endon( "death" );

	for ( ;; )
	{
		wait( 0.25 );

		if ( DistanceSquared( self.origin, self.goal.origin ) < 256 * 256 )
		{
			if ( DistanceSquared( self.origin, level.missile_swarm_origin ) > level.missile_swarm_flydist * level.missile_swarm_flydist )
			{
				self.goal.origin = level.missile_swarm_origin;
				continue;
			}

			enemy = projectile_find_random_player( self.owner, self.team );

			if ( IsDefined( enemy ) )
			{
				self.goal.origin = enemy.origin + ( 0, 0, self.origin[2] );
			}
			else
			{
				pitch	= RandomIntRange( -45, 45 );
				yaw		= RandomIntRange( 0, 360 );
				angles	= ( 0, yaw, 0 );

				forward = AnglesToForward( angles );

				self.goal.origin = self.origin + forward * level.missile_swarm_flydist;
			}
			nfz = crossesnoflyzone(self.origin, self.goal.origin );
			tries = 20;
			while ( isDefined(nfz) && tries > 0 )
			{
				tries--;
				pitch	= RandomIntRange( -45, 45 );
				yaw		= RandomIntRange( 0, 360 );
				angles	= ( 0, yaw, 0 );

				forward = AnglesToForward( angles );

				self.goal.origin = self.origin + forward * level.missile_swarm_flydist;
				nfz = crossesnoflyzone(self.origin, self.goal.origin );
			}
		}
	}
}

projectile_target_search( acceptSkyExposure, acquireTime, allowPlayerOffset )
{
	self endon( "death" );

	wait( acquireTime );

	for ( ;; )
	{
		wait( RandomFloatRange( 0.5, 1.0 ) );
		//wait( RandomFloatRange( acquireTime/2, acquireTime ) );

		target = self projectile_find_target( acceptSkyExposure );
			
		if ( IsDefined( target ) )
		{
			self.swarm_target = target[ "entity" ];
			target[ "entity" ].swarm = self;
			if ( allowPlayerOffset ) 
			{
				self Missile_SetTarget( target[ "entity" ], target[ "offset" ] );
				self Missile_DroneSetVisible( true );
			}
			else
			{
				self Missile_SetTarget( target[ "entity" ] );
				self Missile_DroneSetVisible( true );
			}

			self PlaySound( "veh_harpy_drone_swarm_incomming" );
			if ( !isDefined(target[ "entity" ].swarmSound) || target[ "entity" ].swarmSound == false)
				self thread target_sounds(target[ "entity" ]);
			
			target[ "entity" ] waittill_any( "death", "disconnect", "joined_team" );
			self Missile_SetTarget( self.goal );
			self Missile_DroneSetVisible( false );

			continue;
		}
	}
}

target_sounds( target )
{
	target endon("death");
	target endon("disconnect");
	target endon("joined_team");
	self endon( "death" );
		
	//wait until we are close to start the beeping
	while( Distance( self.origin, target.origin ) > 2500 )
	{
		wait (0.05);
	}
	if (isDefined(target.swarmSound) && target.swarmSound == true)
		return;
	
	target.swarmSound = true;
	self thread reset_sound_blocker( target );
	
	if (IsPlayer(target))
	{
		target playlocalsound( "mpl_turret_alert" );
	}
		self PlaySound( "mpl_turret_alert" );
		wait ( .2 );
		
	if (IsPlayer(target))
	{
		target playlocalsound( "mpl_turret_alert" );
	}	
		self PlaySound( "mpl_turret_alert" );
		wait ( .2 );
		
	if (IsPlayer(target))
	{
		target playlocalsound( "mpl_turret_alert" );
	}
		self PlaySound( "mpl_turret_alert" );
		wait ( .1 );
		
	if (IsPlayer(target))
	{
		target playlocalsound( "mpl_turret_alert" );
	}
		self PlaySound( "mpl_turret_alert" );
		wait ( .1 );
		
	if (IsPlayer(target))
	{
		target playlocalsound( "mpl_turret_alert" );
	}
		self PlaySound( "mpl_turret_alert" );
		wait ( .1 );
		
	if (IsPlayer(target))
	{
		target playlocalsound( "mpl_turret_alert" );
	}
		self PlaySound( "mpl_turret_alert" );
}

reset_sound_blocker( target )
{
	wait( 2 );
	if (isDefined(target))
		target.swarmSound = false;
}

projectile_spawn( owner )
{
	upVector = ( 0, 0, RandomIntRange( level.missile_swarm_flyheight + 1000, level.missile_swarm_flyheight + 2000 ) );

	yaw		= RandomIntRange( 0, 360 );
	angles	= ( 0, yaw, 0 );
	forward = AnglesToForward( angles );

	origin = level.mapCenter + upVector + forward * level.missile_swarm_flydist * -1;
	target = level.mapCenter + upVector + forward * level.missile_swarm_flydist;

	enemy = projectile_find_random_player( owner, owner.team );

	if ( IsDefined( enemy ) )
	{
		target = enemy.origin + upVector;
	}
	projectile = projectile_spawn_utility( owner, target, origin, "missile_swarm_projectile_mp", "swarm_missile", true );
	projectile thread projectile_abort_think();
	projectile thread projectile_target_search( true, 1.0, true );
	projectile thread projectile_death_think();
	projectile thread projectile_goal_move();
		
}

    
projectile_spawn_utility( owner, target, origin, weapon, targetname, moveGoal )
{
	goal = Spawn( "script_model", target );
    goal SetModel( "tag_origin" );
    
	p = MagicBullet( weapon, origin, target, owner, goal );

	p.owner			= owner;
	p.team			= owner.team;
	p.goal			= goal;
	p.targetname	= "swarm_missile";

/#
	if ( !is_true( owner.swarm_cam ) && GetDvarInt( "scr_swarm_cam" ) == 1 )
	{
		p thread projectile_cam( owner );
	}
#/
	return p;
}

projectile_death_think()
{
	self waittill( "death" );
	level.missile_swarm_count--;
	self.goal delete();
}

projectile_abort_think()
{
	self endon( "death" );

	self.owner waittill_any( "disconnect", "joined_team" );
	self Detonate();
}

projectile_find_target( acceptSkyExposure )
{
	ks = projectile_find_target_killstreak( acceptSkyExposure );
	player = projectile_find_target_player( acceptSkyExposure );

	if ( IsDefined( ks ) && !IsDefined( player ) )
	{
		return ks;
	}
	else if ( !IsDefined( ks ) && IsDefined( player ) )
	{
		return player;
	}
	else if ( IsDefined( ks ) && IsDefined( player ) )
	{
		if ( cointoss() )
		{
			return ks;
		}

		return player;
	}

	return undefined;
}

projectile_find_target_killstreak( acceptSkyExposure )
{
	ks = [];
	ks[ "offset" ] = ( 0, 0, -10 );

	targets = Target_GetArray();
	rcbombs = GetEntArray( "rcbomb", "targetname" );
	satellites = GetEntArray( "satellite", "targetname" );
	dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();

	targets = ArrayCombine( targets, rcbombs, true, false );
	targets = ArrayCombine( targets, satellites, true, false );
	targets = ArrayCombine( targets, dogs, true, false );

	if ( targets.size <= 0 )
	{
		return undefined;
	}

	targets = get_array_of_closest( self.origin, targets );

	foreach( target in targets )
	{
		if ( IsDefined( target.owner ) && target.owner == self.owner )
		{
			continue;
		}

		if ( IsDefined( target.script_owner ) && target.script_owner == self.owner )
		{
			continue;
		}
	
		if ( level.teambased && IsDefined( target.team ) )
		{
			if ( target.team == self.team )
			{
				continue;
			}
		}

		if ( level.teambased && IsDefined( target.aiteam ) )
		{
			if ( target.aiteam == self.team )
			{
				continue;
			}
		}

		// can see the origin
		if ( BulletTracePassed( self.origin, target.origin, false, target ) )
		{
			ks[ "entity" ] = target;
			return ks;
		}

		if ( acceptSkyExposure && cointoss() )
		{
			// exposed to sky
			end = target.origin + ( 0, 0, 2048 );
			if ( BulletTracePassed( target.origin, end, false, target ) )
			{
				ks[ "entity" ] = target;
				return ks;
			}
		}
	}

	return undefined;
}


projectile_find_target_player( acceptExposedToSky )
{
	target = [];
	players = get_array_of_closest( self.origin, GET_PLAYERS() );

	foreach( player in players )
	{
		if ( !player_valid_target( player, self.team, self.owner ) )
		{
			continue;
		}

		// can see the player's origin
		if ( BulletTracePassed( self.origin, player.origin, false, player ) )
		{
			target[ "entity" ] = player;
			target[ "offset" ] = ( 0, 0, 0 );

			return target;
		}

		// can see the player's head
		if ( BulletTracePassed( self.origin, player GetEye(), false, player ) )
		{
			target[ "entity" ] = player;
			target[ "offset" ] = ( 0, 0, 50 );

			return target;
		}

		if ( acceptExposedToSky && cointoss() )
		{
			// player exposed to sky
			end = player.origin + ( 0, 0, 2048 );
			if ( BulletTracePassed( player.origin, end, false, player ) )
			{
				target[ "entity" ] = player;
				target[ "offset" ] = ( 0, 0, 30 );

				return target;
			}
		}
	}

	return undefined;
}

create_player_targeting_array( owner, team )
{
	level.playerTargetedTimes = [];
	players = GET_PLAYERS();

	foreach( player in players )
	{
		if ( !player_valid_target( player, team, owner ) )
		{
			continue;
		}

		level.playerTargetedTimes[ player.clientid ] = 0;
	}
}

//Added some logic here to favor not already targeted players
projectile_find_random_player( owner, team )
{
	players = GET_PLAYERS();
	
	lowest = 10000;
	
	foreach( player in players )
	{
		if ( !player_valid_target( player, team, owner ) )
		{
			continue;
		}

		if ( !isDefined(level.playerTargetedTimes[ player.clientID ]) )
		{
			level.playerTargetedTimes[ player.clientID ] = 0;
		}
		if ( level.playerTargetedTimes[ player.clientID ] < lowest || ( level.playerTargetedTimes[ player.clientID ] == lowest && RandomInt(100) > 50 ) )
		{
			target = player;
			lowest = level.playerTargetedTimes[ player.clientID ];
		}		
	}

	if ( isDefined( target ) )
	{
		level.playerTargetedTimes[ target.clientID ] = level.playerTargetedTimes[ target.clientID ] + 1;
		return target;
	}

	return undefined;
}

player_valid_target( player, team, owner )
{
	if ( player.sessionstate != "playing" )
	{
		return false;
	}

	if ( !IsAlive( player ) )
	{
		return false;
	}

	if ( player == owner )
	{
		return false;
	}

	if ( level.teambased )
	{
		if ( team == player.team )
		{
			return false;
		}
	}

	if ( player canTargetPlayerWithSpecialty() == false ) 
	{
		return false;
	}

	if ( IsDefined( player.lastspawntime ) && GetTime() - player.lastspawntime < 1000 )
	{
		return false;
	}

/#
	if ( player IsInMoveMode( "ufo", "noclip" ) )
	{
		return false;
	}
#/

	return true;
}