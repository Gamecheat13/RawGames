#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_airsupport;
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_missile_swarm;



#namespace missile_swarm;

#precache( "string", "KILLSTREAK_EARNED_MISSILE_SWARM" );
#precache( "string", "KILLSTREAK_MISSILE_SWARM_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_MISSILE_SWARM_INBOUND" );
#precache( "eventstring", "mpl_killstreak_missile_swarm" );
#precache( "fx", "_t6/weapon/harpy_swarm/fx_hrpy_swrm_os_circle_neg_x" );
#precache( "fx", "_t6/weapon/harpy_swarm/fx_hrpy_swrm_exhaust_trail_close" );

function init()
{
	level.missile_swarm_max			= 6;
	level.missile_swarm_flyheight	= 3000;
	level.missile_swarm_flydist		= 5000;
	
	util::set_dvar_float_if_unset( "scr_missile_swarm_lifetime", 40.0 );

	level.swarm_fx[ "swarm" ] = "_t6/weapon/harpy_swarm/fx_hrpy_swrm_os_circle_neg_x";
	level.swarm_fx["swarm_tail"] = "_t6/weapon/harpy_swarm/fx_hrpy_swrm_exhaust_trail_close";
	level.missileDroneSoundStart = "mpl_hk_scan";

	killstreaks::register( "missile_swarm", "missile_swarm", "killstreak_missile_swarm", "missile_swarm_used",&swarm_killstreak, true );
	killstreaks::register_alt_weapon( "missile_swarm", "missile_swarm_projectile" );
	killstreaks::register_strings( "missile_swarm", &"KILLSTREAK_EARNED_MISSILE_SWARM", &"KILLSTREAK_MISSILE_SWARM_NOT_AVAILABLE", &"KILLSTREAK_MISSILE_SWARM_INBOUND" );
	killstreaks::register_dialog( "missile_swarm", "mpl_killstreak_missile_swarm", "kls_swarm_used", "", "kls_swarm_enemy", "", "kls_swarm_ready" );
	killstreaks::register_dev_dvar( "missile_swarm", "scr_givemissileswarm" );
	killstreaks::set_team_kill_penalty_scale( "missile_swarm", 0.0 );
	
	clientfield::register( "world", "missile_swarm", 1, 2, "int" );
	
/#
	util::set_dvar_int_if_unset( "scr_missile_swarm_cam", 0 );
#/
}

function swarm_killstreak( hardpointType )
{
	assert( hardpointType == "missile_swarm" );
	
	level.missile_swarm_origin = level.mapCenter + ( 0, 0, level.missile_swarm_flyheight );
	
	if ( level.script == "mp_drone" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( -5000, 0, 2000 );
	}
	if ( level.script == "mp_la" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( 0, 0, 2000 );
	}
	if ( level.script == "mp_turbine" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( 0, 0, 1500 );
	}
	if ( level.script == "mp_downhill" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( 4000, 0, 1000 );
	}
	if ( level.script == "mp_hydro" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( 0, 0, 5000 );
	}
	if ( level.script == "mp_magma" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( 0, -6000, 3000 );
	}
	if ( level.script == "mp_uplink" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( -6000, 0, 2000 );
	}
	if ( level.script == "mp_bridge" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( 0, 0, 2000 );
	}
	if ( level.script == "mp_paintball" )
	{
		level.missile_swarm_origin = level.missile_swarm_origin + ( 0, 0, 1000 );
	}

	killstreak_id = self killstreakrules::killstreakStart( "missile_swarm", self.team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}

	level thread swarm_killstreak_start( self, killstreak_id );

	return true;
}

function swarm_killstreak_start( owner, killstreak_id )
{
	level endon( "swarm_end" );

	missiles = GetEntArray( "swarm_missile", "targetname" );

	foreach( missile in missiles )
	{
		if ( isdefined( missile ) )
		{
			missile Detonate();
			wait( 0.10 );
		}
	}

	if ( isdefined( level.missile_swarm_fx ) )
	{
		for ( i = 0; i < level.missile_swarm_fx.size; i++ )
		{
			if ( isdefined ( level.missile_swarm_fx[i] ) )
			{
				level.missile_swarm_fx[i] delete();
			}
		}
	}

	level.missile_swarm_fx = undefined;
	level.missile_swarm_team = owner.team;
	level.missile_swarm_owner = owner;
	owner killstreaks::play_killstreak_start_dialog( "missile_swarm", owner.pers["team"] );
	level create_player_targeting_array( owner, owner.team );
	level.globalKillstreaksCalled++;
	owner AddWeaponStat( GetWeapon( "missile_swarm" ), "used", 1 );
	
	level thread swarm_killstreak_abort( owner, killstreak_id );
	level thread swarm_killstreak_watch_for_emp( owner, killstreak_id );
	level thread swarm_killstreak_fx();
	wait ( 2 );
	level thread swarm_think( owner, killstreak_id );
}

function swarm_killstreak_end( owner, detonate, killstreak_id )
{
	level notify( "swarm_end" );
	if ( isdefined(detonate) && detonate )
	{
		level clientfield::set( "missile_swarm", 2 );
	}
	else
	{
		level clientfield::set( "missile_swarm", 0 );
	}

	missiles = GetEntArray( "swarm_missile", "targetname" );
	
	if ( ( isdefined( detonate ) && detonate ) )
	{
		for ( i=0; i<level.missile_swarm_fx.size; i++ )
		{
			if ( isdefined ( level.missile_swarm_fx[i] ) )
			{
				level.missile_swarm_fx[i] delete();
			}
		}
		foreach( missile in missiles )
		{
			if ( isdefined( missile ) )
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
			if ( isdefined( missile ) )
			{
				yaw		= RandomIntRange( 0, 360 );
				angles	= ( 0, yaw, 0 );

				forward = AnglesToForward( angles );
				
				if ( isdefined( missile.goal ) )
					missile.goal.origin = missile.origin + forward * level.missile_swarm_flydist * 1000;
			}
		}
	}

	wait( 1 );
	level.missile_swarm_sound StopLoopSound( 2 );
	
	wait( 2 );
	level.missile_swarm_sound delete();

	// killstreaks::set_killstreak_timer( "missile_swarm", owner.team, 0 );
	recordStreakIndex = level.killstreakindices[level.killstreaks["missile_swarm"].menuname];
	if ( isdefined( recordStreakIndex ) )
	{
		owner RecordkillstreakEndEvent( recordStreakIndex );
	}
	killstreakrules::killstreakStop( "missile_swarm", level.missile_swarm_team, killstreak_id );
	level.missile_swarm_owner = undefined;
	
	wait ( 4 );
	
	missiles = GetEntArray( "swarm_missile", "targetname" );
	
	foreach( missile in missiles )
	{
		if ( isdefined( missile ) )
		{
			missile Delete();
			wait( 0.10 );
		}
	}
	
	wait ( 6 );
	
	for ( i=0; i<level.missile_swarm_fx.size; i++ )
	{
		if( isdefined( level.missile_swarm_fx[i] ) )
		{
			level.missile_swarm_fx[i] delete();
		}
	}
}

function swarm_killstreak_abort( owner, killstreak_id )
{
	level endon( "swarm_end" );

	owner util::waittill_any( "disconnect", "joined_team", "joined_spectators", "emp_jammed" );
	level thread swarm_killstreak_end( owner, true, killstreak_id );
}

function swarm_killstreak_watch_for_emp( owner, killstreak_id )
{
	level endon( "swarm_end" );
	
	owner waittill( "emp_destroyed_missile_swarm", attacker );
	
	attacker challenges::addFlySwatterStat( "emp" );
	
	level thread swarm_killstreak_end( owner, true, killstreak_id );
}

function swarm_killstreak_fx()
{
	level endon( "swarm_end" );
	
	// fx
	level.missile_swarm_fx = [];
	
	yaw = RandomInt( 360 );
	level.missile_swarm_fx[0] = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx[0] SetModel( "tag_origin" );
	level.missile_swarm_fx[0].angles = ( -90, yaw, 0 );
	
	level.missile_swarm_fx[1] = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx[1] SetModel( "tag_origin" );
	level.missile_swarm_fx[1].angles = ( -90, yaw, 0 );
	
	level.missile_swarm_fx[2] = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx[2] SetModel( "tag_origin" );
	level.missile_swarm_fx[2].angles = ( -90, yaw, 0 );
	
	level.missile_swarm_fx[3] = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx[3] SetModel( "tag_origin" );
	level.missile_swarm_fx[3].angles = ( -90, yaw, 0 );
	
	level.missile_swarm_fx[4] = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx[4] SetModel( "tag_origin" );
	level.missile_swarm_fx[4].angles = ( -90, yaw, 0 );
	
	level.missile_swarm_fx[5] = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx[5] SetModel( "tag_origin" );
	level.missile_swarm_fx[5].angles = ( -90, yaw, 0 );
	
	level.missile_swarm_fx[6] = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_fx[6] SetModel( "tag_origin" );
	level.missile_swarm_fx[6].angles = ( -90, yaw, 0 );
	
	level.missile_swarm_sound = spawn( "script_model", level.missile_swarm_origin );
	level.missile_swarm_sound SetModel( "tag_origin" );
	level.missile_swarm_sound.angles = ( 0, 0, 0 );
	
	wait( 0.1 );
	
	PlayFXOnTag( level.swarm_fx[ "swarm" ], level.missile_swarm_fx[0], "tag_origin" );
	
	wait( 2 );

	level.missile_swarm_sound PlayLoopSound( "veh_harpy_drone_swarm_lp", 3 );
	level clientfield::set( "missile_swarm", 1 );
	
	current = 1;
	while ( 1 )
	{
		if( !isdefined( level.missile_swarm_fx[current] ) )
		{
			level.missile_swarm_fx[current] = spawn( "script_model", level.missile_swarm_origin );
			level.missile_swarm_fx[current] SetModel( "tag_origin" );
		}
		yaw = RandomInt( 360 );

		if ( isdefined( level.missile_swarm_fx[current] ) )
		{
			level.missile_swarm_fx[current].angles = ( -90, yaw, 0 );
		}
		
		wait ( 0.1 );

		if ( isdefined( level.missile_swarm_fx[current] ) )
		{
			PlayFXOnTag( level.swarm_fx[ "swarm" ], level.missile_swarm_fx[current], "tag_origin" );
		}
		
		current = (current+1) % 7;
		wait( 1.9 );
	}
}

function swarm_think( owner, killstreak_id )
{
	level endon( "swarm_end" );

	lifetime = GetDvarFloat( "scr_missile_swarm_lifetime" );
	// killstreaks::set_killstreak_timer( "missile_swarm", owner.team, lifetime );
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
			self thread projectile_spawn( owner );
		}

		wait( ( level.missile_swarm_count / level.missile_swarm_max ) + 0.4 );
	}

	level thread swarm_killstreak_end( owner, undefined, killstreak_id );
}

/#
function projectile_cam( player )
{
	player.swarm_cam = true;
	{wait(.05);};
	
	forward = AnglesToForward( self.angles );
	cam = spawn( "script_model", self.origin + ( 0, 0, 300 ) + forward * -200 );
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

function projectile_goal_move()
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

			if ( isdefined( enemy ) )
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
			nfz = airsupport::crossesNoFlyZone(self.origin, self.goal.origin );
			tries = 20;
			while ( isdefined(nfz) && tries > 0 )
			{
				tries--;
				pitch	= RandomIntRange( -45, 45 );
				yaw		= RandomIntRange( 0, 360 );
				angles	= ( 0, yaw, 0 );

				forward = AnglesToForward( angles );

				self.goal.origin = self.origin + forward * level.missile_swarm_flydist;
				nfz = airsupport::crossesNoFlyZone(self.origin, self.goal.origin );
			}
		}
	}
}

function projectile_target_search( acceptSkyExposure, acquireTime, allowPlayerOffset )
{
	self endon( "death" );

	wait( acquireTime );

	for ( ;; )
	{
		wait( RandomFloatRange( 0.5, 1.0 ) );
		//wait( RandomFloatRange( acquireTime/2, acquireTime ) );

		target = self projectile_find_target( acceptSkyExposure );
			
		if ( isdefined( target ) )
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
			if ( !isdefined(target[ "entity" ].swarmSound) || target[ "entity" ].swarmSound == false)
				self thread target_sounds(target[ "entity" ]);
			
			target[ "entity" ] util::waittill_any( "death", "disconnect", "joined_team" );
			self Missile_SetTarget( self.goal );
			self Missile_DroneSetVisible( false );

			continue;
		}
	}
}

function target_sounds( targetent )
{
	targetent endon("death");
	targetent endon("disconnect");
	targetent endon("joined_team");
	self endon( "death" );
		
	//wait until we are close to start the beeping
	dist = 3000;
	if ( isdefined( self.warningSoundDist ) )
		dist = self.warningSoundDist;
	while( DistanceSquared( self.origin, targetent.origin ) > dist * dist )
	{
		{wait(.05);};
	}
	if (isdefined(targetent.swarmSound) && targetent.swarmSound == true)
		return;

	targetent.swarmSound = true;
	self thread reset_sound_blocker( targetent );
	self thread target_stop_sounds( targetent );
	
	if ( isPlayer( targetent ) )
	{
		targetent PlayLocalSound( level.missileDroneSoundStart );
	}
	self PlaySound( level.missileDroneSoundStart );
	
}

function target_stop_sounds( targetent )
{	
	targetent util::waittill_any( "disconnect", "death", "joined_team" );
	
	if ( isdefined( targetent ) && isPlayer( targetent ) )
	{
		targetent StopLocalSound( level.missileDroneSoundStart );
	}
}

function reset_sound_blocker( target )
{
	wait( 2 );
	if (isdefined(target))
		target.swarmSound = false;
}

function projectile_spawn( owner )
{
	level endon( "swarm_end" );
	
	upVector = ( 0, 0, RandomIntRange( level.missile_swarm_flyheight - 1500, level.missile_swarm_flyheight - 1000 ) );

	yaw		= RandomIntRange( 0, 360 );
	angles	= ( 0, yaw, 0 );
	forward = AnglesToForward( angles );

	origin = level.mapCenter + upVector + forward * level.missile_swarm_flydist * -1;
	target = level.mapCenter + upVector + forward * level.missile_swarm_flydist;

	enemy = projectile_find_random_player( owner, owner.team );

	if ( isdefined( enemy ) )
	{
		target = enemy.origin + upVector;
	}
	projectile = projectile_spawn_utility( owner, target, origin, "missile_swarm_projectile", "swarm_missile", true );
	projectile thread projectile_abort_think();
	projectile thread projectile_target_search( math::cointoss(), 1.0, true );
	projectile thread projectile_death_think();
	projectile thread projectile_goal_move();
	
	wait( 0.1 );

	if ( isdefined( projectile ) )
	{
		projectile clientfield::set("missile_drone_projectile_animate", 1);		
	}
}

    
function projectile_spawn_utility( owner, target, origin, weapon, targetname, moveGoal )
{
	goal = spawn( "script_model", target );
    goal SetModel( "tag_origin" );
    
	p = MagicBullet( weapon, origin, target, owner, goal );

	p.owner			= owner;
	p.team			= owner.team;
	p.goal			= goal;
	p.targetname	= "swarm_missile";

/#
	if ( !( isdefined( owner.swarm_cam ) && owner.swarm_cam ) && GetDvarInt( "scr_swarm_cam" ) == 1 )
	{
		p thread projectile_cam( owner );
	}
#/
	return p;
}

function projectile_death_think()
{
	self waittill( "death" );
	level.missile_swarm_count--;
	self.goal delete();
}

function projectile_abort_think()
{
	self endon( "death" );

	self.owner util::waittill_any( "disconnect", "joined_team" );
	self Detonate();
}

function projectile_find_target( acceptSkyExposure )
{
	ks = projectile_find_target_killstreak( acceptSkyExposure );
	player = projectile_find_target_player( acceptSkyExposure );

	if ( isdefined( ks ) && !isdefined( player ) )
	{
		return ks;
	}
	else if ( !isdefined( ks ) && isdefined( player ) )
	{
		return player;
	}
	else if ( isdefined( ks ) && isdefined( player ) )
	{
		if ( math::cointoss() )
		{
			return ks;
		}

		return player;
	}

	return undefined;
}

function projectile_find_target_killstreak( acceptSkyExposure )
{
	ks = [];
	ks[ "offset" ] = ( 0, 0, -10 );

	targets = Target_GetArray();
	rcbombs = GetEntArray( "rcbomb", "targetname" );
	satellites = GetEntArray( "satellite", "targetname" );
	dogs = dogs::dog_manager_get_dogs();

	targets = ArrayCombine( targets, rcbombs, true, false );
	targets = ArrayCombine( targets, satellites, true, false );
	targets = ArrayCombine( targets, dogs, true, false );

	if ( targets.size <= 0 )
	{
		return undefined;
	}

	targets = ArraySort( targets, self.origin );

	foreach( target in targets )
	{
		if ( isdefined( target.owner ) && target.owner == self.owner )
		{
			continue;
		}

		if ( isdefined( target.script_owner ) && target.script_owner == self.owner )
		{
			continue;
		}
	
		if ( level.teambased && isdefined( target.team ) )
		{
			if ( target.team == self.team )
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

		if ( acceptSkyExposure && math::cointoss() )
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


function projectile_find_target_player( acceptExposedToSky )
{
	target = [];

	players = GetPlayers();
	players = ArraySort( players, self.origin );

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

		if ( acceptExposedToSky && math::cointoss() )
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

function create_player_targeting_array( owner, team )
{
	level.playerTargetedTimes = [];
	players = GetPlayers();

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
function projectile_find_random_player( owner, team )
{
	players = GetPlayers();
	
	lowest = 10000;
	
	foreach( player in players )
	{
		if ( !player_valid_target( player, team, owner ) )
		{
			continue;
		}

		if ( !isdefined(level.playerTargetedTimes[ player.clientID ]) )
		{
			level.playerTargetedTimes[ player.clientID ] = 0;
		}
		if ( level.playerTargetedTimes[ player.clientID ] < lowest || ( level.playerTargetedTimes[ player.clientID ] == lowest && RandomInt(100) > 50 ) )
		{
			target = player;
			lowest = level.playerTargetedTimes[ player.clientID ];
		}		
	}

	if ( isdefined( target ) )
	{
		level.playerTargetedTimes[ target.clientID ] = level.playerTargetedTimes[ target.clientID ] + 1;
		return target;
	}

	return undefined;
}

function player_valid_target( player, team, owner )
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

	if ( player airsupport::canTargetPlayerWithSpecialty() == false ) 
	{
		return false;
	}

	if ( isdefined( player.lastspawntime ) && GetTime() - player.lastspawntime < 3000 )
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
