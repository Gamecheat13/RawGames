#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic_utils;

#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;

                                               	               	               	                	                                                               

#namespace bot_sd;

function sd_think()
{
	sd_init();
	
	if ( self.team == game[ "attackers" ] )
	{
		if ( level.multiBomb )
		{
			self.isBombCarrier = true;
		}
				
		self sd_attacker_think();
	}
	else
	{
		self sd_defender_think();
	}
}

function sd_init()
{
	if ( !( isdefined( level.botInitialized ) && level.botInitialized ) ) 
	{
		level.botInitialized = true;

		foreach( zone in level.bombZones )
		{
			sd_update_node_cache_for_zone( zone );
		}

		level.bombDropBotEvent = &sd_update_node_cache_for_bomb;	
		level.bombPickupBotEvent = &sd_cancel_bomb_guards;
	}

	if ( !( isdefined( self.botInitialized ) && self.botInitialized ) )
	{
		self.botInitialized = true;

		self.bot.update_bomb_plant = GetTime();

		self.bot.update_zone_patrol = GetTime();
	}
	
	if ( !isdefined(level.sdBomb.nearest_point) )
	{
		sd_update_node_cache_for_bomb();
	}
}

function sd_update_node_cache_for_bomb()
{
	if ( !level.multiBomb )
	{
		sd_update_node_cache_for_zone( level.sdBomb );
	}
}

function sd_cancel_bomb_guards()
{
	defenders = GetPlayers(game["defenders"]);

	foreach ( defender in defenders )
	{
		if ( defender util::is_bot() )
		{
			goal = defender GetGoal("sd_defend");

			if ( isdefined(goal) && isdefined(defender.bot.guardZone) && defender.bot.guardZone == level.sdBomb )
			{
				defender sd_cancel_patrol_and_guard();
			}
		}
	}
}

function sd_update_node_cache_for_zone( zone )
{
	points = GetNavPointsInRadius( zone.trigger.origin, 0, 256 );
	
	// TODO: Fix gametype objective
	if ( !isdefined( points ) || points.size == 0 )
	{
		zone.nearest_point = (0, 0, 0);
		zone.visiblePoints = [];
		return;
	}
	
	assert( points.size );

	zone.nearest_point = points[0];

	zone.visiblePoints = NavPointSightFilter( points, zone.nearest_point );
	assert( zone.visiblePoints.size );
}

function sd_attacker_think()
{
	// assume only 1 bomb
	assert(!level.multiBomb);
	
	if ( level.multiBomb )
	{
		self.isBombCarrier = true;
	}

	// if bomb planted, everyone guard around it	
	if ( level.bombPlanted )
	{
		targetZone = sd_get_closest_zone_to_position( level.sdBomb.curorigin );
		assert( isdefined(targetZone) );
		sd_patrol_and_guard( targetZone, 64 );
	}
	// if carrying bomb, plant it
	else if ( self.isBombCarrier )
	{
		self CancelGoal( "sd_pickup" );
		
		goal = self GetGoal( "sd_plant" );

		if ( IsDefined( goal ) )
		{
			if ( sd_plant_bomb( goal ) )
			{
				self CancelGoal( "sd_plant" );
			}
		}
		else if ( GetTime() > self.bot.update_bomb_plant )
		{
			frac = sd_get_time_frac();

			if ( RandomInt( 100 ) < frac * 100 || frac > .85 )
			{
				zone = sd_get_closest_bomb_zone();
				goal = sd_get_bomb_goal( zone.visuals[0] );
				
				if ( isDefined( goal ) )
				{
					goalPriority = 3;
					
					if ( frac > .85 )
					{
						goalPriority = 4;
					}
					
					self AddGoal( goal, 24, goalPriority, "sd_plant" );
				}
			}

			self.bot.update_bomb_plant = GetTime() + RandomIntRange( 2500, 5000 );
		}
	}
	// if someone else is carrying the bomb
	else if ( IsDefined( level.sdBomb.carrier ) )
	{
		self CancelGoal( "sd_pickup" );
		
		targetZone = undefined;

		carrier = level.sdBomb.carrier;
		
		if ( carrier util::is_bot() )
		{
			goal = level.sdBomb.carrier getGoal( "sd_plant" );

			if ( isDefined( goal ) )
			{
				targetZone = sd_get_closest_zone_to_position( goal );
				assert( isdefined(targetZone) );
			}
		}
		else
		{
			targetZone = sd_get_closest_zone_to_position( carrier.origin, 128 );
			
			if ( !isdefined(targetZone) )
			{
				targetZone = array::random(level.bombZones);
			}
		}

		if ( isdefined(targetZone) )
		{
			sd_patrol_and_guard( targetZone );
		}
	}
	// pick up the bomb if it's available
	else if ( !IsDefined( level.sdBomb.carrier ) )
	{
		if ( !level.sdBomb gameobjects::is_object_away_from_home() )
		{
			if ( !self bot::friend_goal_in_radius( "sd_pickup", level.sdBomb.curOrigin, 64 ) )
			{
				self AddGoal( level.sdBomb.curOrigin, 16, 3, "sd_pickup" );
			}
		}
		else
		{
			self AddGoal( level.sdBomb.curOrigin, 16, 3, "sd_pickup" );
		}
	}
	else
	{
		self CancelGoal( "sd_pickup" );
	}

}

function is_bomb_on_ground()
{
	return !isdefined( level.sdBomb.carrier ) && !level.multiBomb;
}

function sd_get_zones_and_bomb()
{
	zones = level.bombZones;

	if ( is_bomb_on_ground() )
	{
		zones[zones.size] = level.sdBomb;
	}

	return zones;
}

function sd_get_closest_zone_to_position( position, maxDistance = 64 )
{
	zones = sd_get_zones_and_bomb();

	closestZone = undefined;
	shortestDistanceSqr = 99999999;

	for ( i = 0; i < zones.size; i++ )
	{
		distanceSqr = DistanceSquared( position, zones[i].trigger.origin );
		if ( distanceSqr < shortestDistanceSqr && distanceSqr < maxDistance * maxDistance )
		{
			closestZone = zones[i];
			shortestDistanceSqr = distanceSqr;
		}
	}

	return closestZone;
}

function sd_defender_think()
{
	zone = sd_get_planted_zone();

	if ( isdefined( zone ) )
	{
		isPlanted = true;
	}
	else
	{
		zone = array::random( sd_get_zones_and_bomb() );
	}

	sd_grenade();

	if ( ( isdefined( isPlanted ) && isPlanted ) && self HasGoal( "sd_defend" ) )
	{
		//we need to clear our defend goal if we are trying to defend the wrong zone
		goal = self GetGoal( "sd_defend" );
		planted = sd_get_planted_zone();
		foreach( zone in level.bombZones )
		{
			if( planted != zone && Distance2D( goal, zone.nearest_point ) < Distance2D( goal, planted.nearest_point ) )
			{
				sd_cancel_patrol_and_guard();
			}
		}
	}
	
	if ( self AtGoal( "sd_defend" ) || self need_to_defuse() )
	{
		sd_defender_defenceThink( zone );

		if ( self HasGoal( "sd_defend" ) )
		{
			return;
		}
	}

	if ( self HasGoal( "enemy_patrol" ) )
	{
		goal = self GetGoal( "enemy_patrol" );

		closeZone = sd_get_closest_bomb_zone();

		if ( DistanceSquared( goal, closeZone.nearest_point ) < 512 * 512 )
		{
			self ClearLookAt();
			sd_cancel_patrol_and_guard();
			return;
		}
	}

	if ( self HasGoal( "sd_defend" ) )
	{
		self.bot.update_patrol = GetTime() + RandomIntRange( 2500, 5000 );
		return;
	}

	if ( self HasGoal( "enemy_patrol" ) )
	{
		return;
	}
	
	sd_patrol_and_guard( zone );
}

// tell the bot to guard a target
function sd_patrol_and_guard( zone, radius = 24 )
{
	self.bot.guardZone = zone;

	if ( GetTime() < self.bot.update_zone_patrol )
	{
		return;
	}
	else
	{
		self.bot.update_zone_patrol = GetTime() + RandomIntRange( 2500, 5000 );
	}

	best = undefined;
	highest = -100;

	isHighPriority = zone == level.sdbomb || ( isdefined( zone.isPlanted ) && zone.isPlanted );
	
	foreach( point in zone.visiblePoints )
	{
		/*if ( !CanClaimNode( node, self.team ) )
		{
			continue;
		}*/

		if ( DistanceSquared( point, self.origin ) < 256 * 256 )
		{
			continue;
		}

		if ( self bot::friend_goal_in_radius( "sd_defend", point, 256 ) > 0 )
		{
			continue;
		}
		
		height = point[2] - zone.nearest_point[2];
		if ( isHighPriority )
		{
			dist = Distance2D( point, zone.nearest_point );
			score = ( 10000 - dist ) + height;
		}
		else
		{
			score = height;	
		}

		if ( score > highest )
		{
			highest = score;
			best = point;
		}
	}

	if ( isdefined( best ) )
	{
		self AddGoal( best, radius, 2, "sd_defend" );
	}
}

function sd_cancel_patrol_and_guard()
{
	//assert( isdefined(self.bot.guardZone) );
	self.bot.guardZone = undefined;
	self CancelGoal( "sd_defend" );
}

// return bool isPlantingSucceeded
function sd_plant_bomb( goal )
{
	isPlantingSucceeded = false;

	if ( DistanceSquared( self.origin, goal ) < 48 * 48 )
	{
		// see if there is enemies around
		enemies = GetPlayers(game["defenders"]);
		noEnemyAround = true;
		i = 0;
		for( ; i < enemies.size && noEnemyAround; i++ )
		{
			selfEye = self GetEye();
			enemyEye = enemies[i] GetEye();

			noEnemyAround = !BulletTracePassed( selfEye, enemyEye, false, undefined );
		}

		if ( noEnemyAround )
		{
			self SetStance( "prone" );
			wait( 0.5 );
			self PressUseButton( level.plantTime + 1 );

			wait( 0.5 );

			if ( ( isdefined( self.isPlanting ) && self.isPlanting ) )
			{
				wait( level.plantTime + 1 );
				isPlantingSucceeded = true;
			}

			self PressUseButton( 0 );

			self SetStance( "crouch" );
			wait( 0.25 );

			self SetStance( "stand" );
		}
		else if ( enemies.size && isdefined(enemies[i-1]) )
		{
			self ClearLookAt();
			self LookAt( enemies[i-1] GetEye() );
		}
	}
	
	return isPlantingSucceeded;
}

function get_look_at()
{
	enemy = self bot::get_closest_enemy( self.origin, true );

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
		{
			return node.origin;
		}
	}

	enemies = self bot::get_enemies( false );

	if ( enemies.size )
	{
		enemy = array::random( enemies );
	}

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
		{
			return node.origin;
		}
	}

	zone = sd_get_closest_bomb_zone();
	node = GetVisibleNode( self.origin, zone.nearest_point );

	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
	{
		return node.origin;
	}

	forward = AnglesToForward( self GetPlayerAngles() );
	origin = self GetEye() + forward * 1024;

	return origin;
}

function sd_defender_defenceThink( zone )
{
	if ( self need_to_defuse() )
	{
		if ( self bot::friend_goal_in_radius( "sd_defuse", level.sdBombModel.origin, 16 ) > 0 )
		{
			return;
		}
		
		self ClearLookAt();
		goal = self GetGoal( "sd_defuse" );

		if ( isdefined( goal ) && DistanceSquared( self.origin, goal ) < 48 * 48 )
		{
			self SetStance( "prone" );
			wait( 0.5 );
			self PressUseButton( level.defuseTime + 1 );

			wait( 0.5 );

			if ( ( isdefined( self.isDefusing ) && self.isDefusing ) )
			{
				wait( level.defuseTime + 1 );
			}

			self PressUseButton( 0 );

			self SetStance( "crouch" );
			wait( 0.25 );

			self CancelGoal( "sd_defuse" );
			self SetStance( "stand" );
			return;
		}

		if ( !isdefined( goal ) && Distance2DSquared( self.origin, level.sdBombModel.origin ) < 1000 * 1000 )
		{
			self AddGoal( level.sdBombModel.origin, 24, 4, "sd_defuse" );
		}
	
		return;
	}
	
	if ( GetTime() > self.bot.update_patrol )
	{
		if ( math::cointoss() )
		{
			self ClearLookAt();
			sd_cancel_patrol_and_guard();
			return;
		}

		self.bot.update_patrol = GetTime() + RandomIntRange( 2500, 5000 );
	}

	if ( self HasGoal( "enemy_patrol" ) )
	{
		goal = self GetGoal( "enemy_patrol" );

		zone = sd_get_closest_bomb_zone();

		if ( DistanceSquared( goal, zone.nearest_point ) < 512 * 512 )
		{
			self ClearLookAt();
			sd_cancel_patrol_and_guard();
			return;
		}
	}

	if ( GetTime() > self.bot.update_lookat )
	{
		origin = self get_look_at();

		z = 20;

		if ( DistanceSquared( origin, self.origin ) > 512 * 512 )
		{
			z = RandomIntRange( 16, 60 );
		}

		self LookAt( origin + ( 0, 0, z ) );

		self.bot.update_lookat  = GetTime() + RandomIntRange( 1500, 3000 );

		if ( DistanceSquared( origin, self.origin ) > 256 * 256 )
		{
			dir = VectorNormalize( self.origin - origin );
			dir = VectorScale( dir, 256 );

			origin = origin + dir;
		}

		self bot_combat::combat_throw_proximity( origin );
	}
}

function need_to_defuse()
{
	return ( level.bombPlanted && self.team == game[ "defenders" ] );
}

function sd_get_bomb_goal( ent )
{
	goals = [];
	dir = AnglesToForward( ent.angles );
	dir = VectorScale( dir, 32 );

	goals[0] = ent.origin + dir;
	goals[1] = ent.origin - dir;

	dir = AnglesToRight( ent.angles );
	dir = VectorScale( dir, 48 );

	goals[2] = ent.origin + dir;
	goals[3] = ent.origin - dir;

	goals = array::randomize( goals );

	foreach( goal in goals )
	{
		if ( self FindPath( self.origin, goal, false ) )
		{
			return goal;
		}
	}

	return undefined;
}

function sd_get_time_frac()
{
	remaining = globallogic_utils::getTimeRemaining();
	end = level.timeLimit * 60 * 1000;

	if ( end == 0 )
	{
		// treat no time-limit like a 2 minute game
		end = self.spawntime + ( 2 * 60 * 1000 );
		remaining = end - GetTime();
	}

	return ( 1 - ( remaining / end ) );
}

function sd_get_closest_bomb_zone()
{
	best = undefined;
	distSq = 9999999;

	foreach( zone in level.bombZones )
	{
		d = DistanceSquared( self.origin, zone.curOrigin );

		if ( d < distSq || !IsDefined( best ) )
		{
			best = zone;
			distSq = d;
		}
	}

	return best;
}

function sd_get_planted_zone()
{
	if ( level.bombPlanted )
	{
		foreach( zone in level.bombZones )
		{
			if ( zone.interactTeam == "none" )
			{
				return zone;
			}
		}
	}

	return undefined;
}

function sd_grenade()
{
	enemies = bot::get_enemies();

	if ( !enemies.size )
	{
		return;
	}

	zone = sd_get_closest_bomb_zone();

	foreach( enemy in enemies )
	{
		if ( DistanceSquared( enemy.origin, zone.nearest_point ) < 384 * 384 )
		{
			if ( !self bot_combat::combat_throw_lethal( enemy.origin ) )
			{
				self bot_combat::combat_throw_tactical( enemy.origin );
			}

			return;
		}
	}
}