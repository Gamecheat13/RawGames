#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;

                                               	               	               	                	                                                               


	
#namespace bot_hq;

function hq_think()
{
	time = GetTime();

	if ( time < self.bot.update_objective )
	{
		return;
	}

	self.bot.update_objective = time + RandomIntRange( 500, 1500 );

	if ( should_patrol_hq() )
	{
		self patrol_hq();
	}
	else if ( !has_hq_goal() )
	{
		self move_to_hq();
	}

	if ( self is_capturing_hq() )
	{
		self capture_hq();
	}

	hq_tactical_insertion();
	hq_grenade();

	if ( !is_capturing_hq() && !self AtGoal( "hq_patrol" ) )
	{
		mine = GetNearestNode( self.origin );
		point = hq_nearest_point();

		if ( IsDefined( mine ) && bot::navmesh_points_visible( mine.origin, point ) )
		{
			self LookAt( level.radio.baseorigin + ( 0, 0, 30 ) );
		}
	}
}

function has_hq_goal()
{
	origin = self GetGoal( "hq_radio" );

	if ( isdefined( origin ) )
	{
		foreach( point in level.radio.points )
		{
			if ( DistanceSquared( origin, point ) < 64 * 64 )
			{
				return true;
			}
		}
	}

	return false;
}

function is_capturing_hq()
{
	return ( self AtGoal( "hq_radio" ) );
}

function should_patrol_hq()
{
	if ( level.radio.gameobject.ownerTeam == "neutral" )
	{
		return false;
	}

	if ( level.radio.gameobject.ownerTeam != self.team )
	{
		return false;	
	}

	if ( hq_is_contested() )
	{
		return false;
	}

	return true;
}

function patrol_hq()
{
	self CancelGoal( "hq_radio" );

	if ( self AtGoal( "hq_patrol" ) )
	{
		node = GetNearestNode( self.origin );

		if ( isdefined( node ) && node.type == "Path" )
		{
			self SetStance( "crouch" );
		}
		else
		{
			self SetStance( "stand" );
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

			if ( DistanceSquared( origin, self.origin ) > 256 * 256 )
			{
				dir = VectorNormalize( self.origin - origin );
				dir = VectorScale( dir, 256 );

				origin = origin + dir;
			}

			self bot_combat::combat_throw_proximity( origin );

			self.bot.update_lookat = GetTime() + RandomIntRange( 1500, 3000 );
		}

		goal = self GetGoal( "hq_patrol" );
		nearest = hq_nearest_point();

		mine = GetNearestNode( goal );

		if ( isdefined( mine ) && !bot::navmesh_points_visible( mine.origin, nearest ) )
		{
			self ClearLookAt();
			self CancelGoal( "hq_patrol" );
		}

		if ( GetTime() > self.bot.update_objective_patrol )
		{
			self ClearLookAt();
			self CancelGoal( "hq_patrol" );
		}

		return;
	}

	nearest = hq_nearest_point();

	if ( self HasGoal( "hq_patrol" ) )
	{
		goal = self GetGoal( "hq_patrol" );

		if ( DistanceSquared( self.origin, goal ) < 256 * 256 )
		{
			origin = self get_look_at();
			self LookAt( origin );
		}

		if ( DistanceSquared( self.origin, goal ) < 128 * 128 )
		{
			self.bot.update_objective_patrol = GetTime() + RandomIntRange( 3000, 6000 );
		}

		mine = GetNearestNode( goal );

		if ( isdefined( mine ) && !bot::navmesh_points_visible( mine.origin, nearest ) )
		{
			self ClearLookAt();
			self CancelGoal( "hq_patrol" );
		}

		return;
	}

	points = GetNavPointsInRadius( nearest, 0, 512, 64 );
	points = NavPointSightFilter( points, nearest );
	assert( points.size );

	i = RandomInt( points.size );

	for ( ; i < points.size; i++ )
	{
		if ( self bot::friend_goal_in_radius( "hq_radio", points[i], 128 ) == 0 )
		{
			if ( self bot::friend_goal_in_radius( "hq_patrol", points[i], 256 ) == 0 )
			{
				self AddGoal( points[i], 24, 3, "hq_patrol" );
				return;
			}
		}
	}
}

function move_to_hq()
{
	self ClearLookAt();
	self CancelGoal( "hq_radio" );
	self CancelGoal( "hq_patrol" );

	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
		wait( 0.25 );
	}

	if ( self GetStance() == "crouch" )
	{
		self SetStance( "stand" );
		wait( 0.25 );
	}

	points = array::randomize( level.radio.points );

	foreach( point in points )
	{
		if ( self bot::friend_goal_in_radius( "hq_radio", point, 64 ) == 0 )
		{
			self AddGoal( point, 24, 3, "hq_radio" );
			return;
		}
	}

	self AddGoal( array::random( points ), 24, 3, "hq_radio" );
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

	spawn = array::random( level.spawnpoints );
	node = GetVisibleNode( self.origin, spawn.origin );

	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
	{
		return node.origin;
	}
	
	return level.radio.baseorigin;
}

function capture_hq()
{
	self AddGoal( self.origin, 24, 3, "hq_radio" );
	self SetStance( "crouch" );

	if ( GetTime() > self.bot.update_lookat )
	{
		origin = self get_look_at();

		z = 20;

		if ( DistanceSquared( origin, self.origin ) > 512 * 512 )
		{
			z = RandomIntRange( 16, 60 );
		}

		self LookAt( origin + ( 0, 0, z ) );

		if ( DistanceSquared( origin, self.origin ) > 256 * 256 )
		{
			dir = VectorNormalize( self.origin - origin );
			dir = VectorScale( dir, 256 );

			origin = origin + dir;
		}

		self bot_combat::combat_throw_proximity( origin );

		self.bot.update_lookat = GetTime() + RandomIntRange( 1500, 3000 );
	}
}

function any_other_team_touching( skip_team )
{
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;

		if ( level.radio.gameobject.numtouching[ team ] )
			return true;
	}

	return false;
}

function is_hq_contested( skip_team )
{
	if ( any_other_team_touching( skip_team ) )
	{
		return true;
	}

	enemy = self bot::get_closest_enemy( level.radio.baseorigin, true );

	if ( isdefined( enemy ) && DistanceSquared( enemy.origin, level.radio.baseorigin ) < 512 * 512 )
	{
		return true;
	}

	return false;
}

function hq_grenade()
{
	enemies = bot::get_enemies();

	if ( !enemies.size )
	{
		return;
	}
	
	if ( self AtGoal( "hq_patrol" ) || self AtGoal( "hq_radio" ) )
	{
		if ( self GetWeaponAmmoStock( GetWeapon( "proximity_grenade" ) ) > 0 )
		{
			origin = get_look_at();

			if ( self bot_combat::combat_throw_proximity( origin ) )
			{
				return;
			}
		}
	}

	if ( !is_hq_contested( self.team ) )
	{
		self bot_combat::combat_throw_smoke( level.radio.baseorigin );
		return;
	}

	enemy = self bot::get_closest_enemy( level.radio.baseorigin, false );

	if ( isdefined( enemy ) )
	{
		origin = enemy.origin;
	}
	else
	{
		origin = level.radio.baseorigin;
	}
	
	dir = VectorNormalize( self.origin - origin );
	dir = ( 0, dir[1], 0 );

	origin = origin + VectorScale( dir, 128 );
	
	if ( !self bot_combat::combat_throw_lethal( origin ) )
	{
		self bot_combat::combat_throw_tactical( origin );
	}
}

function hq_tactical_insertion()
{
	if ( !self HasWeapon( GetWeapon( "tactical_insertion" ) ) )
	{
		return;
	}

	dist = self GetLookAheadDist();
	dir = self GetLookaheadDir();

	if ( !isdefined( dist ) || !isdefined( dir ) )
	{
		return;
	}

	point = hq_nearest_point();
	mine = GetNearestNode( self.origin );

	if ( isdefined( mine ) && !bot::navmesh_points_visible( mine.origin, point ) )
	{
		origin = self.origin + VectorScale( dir, dist );

		next = GetNearestNode( origin );

		if ( isdefined( next ) && bot::navmesh_points_visible( next.origin, point ) )
		{
			bot_combat::combat_tactical_insertion( self.origin );
		}
	}
}

function hq_nearest_point()
{
	return array::random( level.radio.points );
}

function hq_is_contested()
{
	enemy = self bot::get_closest_enemy( level.radio.baseorigin, false );
	return ( IsDefined( enemy ) && DistanceSquared( enemy.origin, level.radio.baseorigin ) < level.radio.node_radius * level.radio.node_radius );
}
