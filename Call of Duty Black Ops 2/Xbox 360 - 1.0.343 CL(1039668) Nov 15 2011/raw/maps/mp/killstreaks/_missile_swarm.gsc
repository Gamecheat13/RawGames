#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;

init()
{
	level.missile_swarm_max			= 6;
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

	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "missile_swarm_mp", self.team, false, true ) )
	{
		return false;
	}

	level thread swarm_killstreak_start( self );

	return true;
}

swarm_killstreak_start( owner )
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
	
	level thread swarm_killstreak_abort( owner );
	level swarm_killstreak_fx();
	level thread swarm_think( owner );
}

swarm_killstreak_end( owner, detonate )
{
	level notify( "swarm_end" );

	level.missile_swarm_fx ClearClientFlag( level.const_flag_missile_swarm );

	if ( is_true( detonate ) )
	{
		missiles = GetEntArray( "swarm_missile", "targetname" );

		foreach( missile in missiles )
		{
			missile Detonate();
			wait( 0.10 );
		}
	}

	wait( 1 );
	level.missile_swarm_fx delete();

	level.missile_swarm_sound StopLoopSound( 2 );
	wait( 2 );
	level.missile_swarm_sound delete();

	maps\mp\killstreaks\_killstreaks::setKillstreakTimer( "missile_swarm_mp", owner.team, 0 );
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "missile_swarm_mp", level.missile_swarm_team );
}

swarm_killstreak_abort( owner )
{
	level endon( "swarm_end" );

	owner waittill_any( "disconnect", "joined_team", "joined_spectators", "emp_jammed" );
	level thread swarm_killstreak_end( owner, true );
}

swarm_killstreak_fx()
{
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

	wait( 2 );
	
	level.missile_swarm_fx SetClientFlag( level.const_flag_missile_swarm );
}

swarm_think( owner )
{
	level endon( "swarm_end" );

	lifetime = GetDvarFloat( "scr_missile_swarm_lifetime" );
	maps\mp\killstreaks\_killstreaks::setKillstreakTimer( "missile_swarm_mp", owner.team, lifetime );
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

		wait( ( level.missile_swarm_count / level.missile_swarm_max ) );
	}

	level thread swarm_killstreak_end( owner );
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

			pitch	= RandomIntRange( -45, 45 );
			yaw		= RandomIntRange( 0, 360 );
			angles	= ( 0, yaw, 0 );

			forward = AnglesToForward( angles );

			self.goal.origin = self.origin + forward * level.missile_swarm_flydist;
		}
	}
}

projectile_target_search()
{
	self endon( "death" );

	wait( 1 );

	for ( ;; )
	{
		wait( RandomFloatRange( 0.5, 1.0 ) );

		target = self projectile_find_target();
			
		if ( IsDefined( target ) )
		{
			self.swarm_target = target[ "entity" ];
			target[ "entity" ].swarm = self;
			self Missile_SetTarget( target[ "entity" ], target[ "offset" ] );

			self PlaySound( "veh_harpy_drone_swarm_incomming" );
			
			target[ "entity" ] waittill_any( "death", "disconnect", "joined_team" );
			self Missile_SetTarget( self.goal );

			continue;
		}
	}
}

projectile_spawn( owner )
{
	upVector = ( 0, 0, RandomIntRange( level.missile_swarm_flyheight + 1000, level.missile_swarm_flyheight + 2000 ) );

	yaw		= RandomIntRange( 0, 360 );
	angles	= ( 0, yaw, 0 );
	forward = AnglesToForward( angles );

	origin = level.mapCenter + upVector + forward * level.missile_swarm_flydist * -1;
	target = level.mapCenter + upVector + forward * level.missile_swarm_flydist;
		
	goal = Spawn( "script_model", target );
    goal SetModel( "tag_origin" );
	
	p = MagicBullet( "missile_swarm_projectile_mp", origin, target, owner, goal );

	p.owner			= owner;
	p.team			= owner.team;
	p.goal			= goal;
	p.targetname	= "swarm_missile";
	
	p thread projectile_death_think();
	p thread projectile_abort_think();
	p thread projectile_target_search();
	p thread projectile_goal_move();

/#
	if ( !is_true( owner.swarm_cam ) && GetDvarInt( "scr_swarm_cam" ) == 1 )
	{
		p thread projectile_cam( owner );
	}
#/
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

projectile_find_target()
{
	ks = projectile_find_target_killstreak();
	player = projectile_find_target_player();

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

projectile_find_target_killstreak()
{
	ks = [];
	ks[ "offset" ] = ( 0, 0, -10 );

	targets = Target_GetArray();
	rcbombs = GetEntArray( "rcbomb", "targetname" );
	satellites = GetEntArray( "satellite", "targetname" );
	dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();

	targets = array_combine( targets, rcbombs );
	targets = array_combine( targets, satellites );
	targets = array_combine( targets, dogs );

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

		if ( cointoss() )
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


projectile_find_target_player()
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

		if ( cointoss() )
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

	if ( player HasPerk( "specialty_nottargetedbyai" ) )
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