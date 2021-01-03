#using scripts\shared\array_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;

                                               	               	               	                	                                                               

#namespace bot_koth;

function koth_think()
{
	if ( !isdefined( level.zone.trig.goal_radius ) )
	{
		maxs = level.zone.trig GetMaxs();
		maxs = level.zone.trig.origin + maxs;

		level.zone.trig.goal_radius = Distance( level.zone.trig.origin, maxs );
		/# println( "distance: " + level.zone.trig.goal_radius ); #/

		ground = BulletTrace( level.zone.gameobject.curOrigin, level.zone.gameobject.curOrigin - (0, 0, 1024), false, undefined );
		level.zone.trig.goal = ground["position"] + ( 0, 0, 8 );
	}

	if ( !has_hill_goal() )
	{
		self move_to_hill();
	}

	if ( self is_at_hill() )
	{
		self capture_hill();
	}

	hill_tactical_insertion();
	hill_grenade();
}

function has_hill_goal()
{
	origin = self GetGoal( "koth_hill" );

	if ( isdefined( origin ) )
	{
		if ( Distance2DSquared( level.zone.gameobject.curOrigin, origin ) < level.zone.trig.goal_radius * level.zone.trig.goal_radius )
		{
			return true;
		}
	}

	return false;
}

function is_at_hill()
{
	return ( self AtGoal( "koth_hill" ) );
}

function move_to_hill()
{
	if ( GetTime() < self.bot.update_objective + 4000 )
	{
		return;
	}

	self ClearLookAt();
	self CancelGoal( "koth_hill" );

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
				
	nodes = GetNodesInRadiusSorted( level.zone.trig.goal, level.zone.trig.goal_radius, 0, 128 );
	//assert( nodes.size );

	foreach( node in nodes )
	{
		if ( self bot::friend_goal_in_radius( "koth_hill", node.origin, 64 ) == 0 )
		{
			if( self FindPath( self.origin, node.origin, false, true ) )
			{
				self AddGoal( node, 24, 3, "koth_hill" );
				self.bot.update_objective = GetTime();
				return;
			}
		}
	}
}

function get_look_at()
{
	enemy = self bot::get_closest_enemy( self.origin, true );

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
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

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
		{
			return node.origin;
		}
	}

	spawn = array::random( level.spawnpoints );
	node = GetVisibleNode( self.origin, spawn.origin );

	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
	{
		return node.origin;
	}
	
	return level.zone.gameobject.curOrigin;
}

function capture_hill()
{
	self AddGoal( self.origin, 24, 3, "koth_hill" );
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

		if ( math::cointoss() && LengthSquared( self GetVelocity() ) < 2 )
		{
			nodes = GetNodesInRadius( level.zone.trig.goal, level.zone.trig.goal_radius + 128, 0, 128 );
			i = RandomIntRange( 0, nodes.size );

			for( ; i < nodes.size; i++ )
			{
				node = nodes[i];

				if ( DistanceSquared( node.origin, self.origin ) > 32 * 32 )
				{
					if ( self bot::friend_goal_in_radius( "koth_hill", node.origin, 128 ) == 0 )
					{
						if( self FindPath( self.origin, node.origin, false, true ) )
						{
							self AddGoal( node, 24, 3, "koth_hill" );
							self.bot.update_objective = GetTime();
							break;
						}
					}
				}
			}
		}

		self.bot.update_lookat = GetTime() + RandomIntRange( 1500, 3000 );
	}
}

function any_other_team_touching( skip_team )
{
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;

		if ( level.zone.gameobject.numtouching[ team ] )
			return true;
	}

	return false;
}

function is_hill_contested( skip_team )
{
	if ( any_other_team_touching( skip_team ) )
	{
		return true;
	}

	enemy = self bot::get_closest_enemy( level.zone.gameobject.curOrigin, true );

	if ( isdefined( enemy ) && DistanceSquared( enemy.origin, level.zone.gameobject.curOrigin ) < 512 * 512 )
	{
		return true;
	}

	return false;
}

function hill_grenade()
{
	enemies = bot::get_enemies();

	if ( !enemies.size )
	{
		return;
	}
	
	if ( self AtGoal( "hill_patrol" ) || self AtGoal( "koth_hill" ) )
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

	if ( !is_hill_contested( self.team ) )
	{
		if ( !isdefined( level.next_smoke_time ) )
		{
			level.next_smoke_time = 0;
		}

		if ( GetTime() > level.next_smoke_time )
		{
			if ( self bot_combat::combat_throw_smoke( level.zone.gameobject.curOrigin ) )
			{
				level.next_smoke_time = GetTime() + RandomIntRange( 60000, 120000 );
			}
		}
		
		return;
	}

	enemy = self bot::get_closest_enemy( level.zone.gameobject.curOrigin, false );

	if ( isdefined( enemy ) )
	{
		origin = enemy.origin;
	}
	else
	{
		origin = level.zone.gameobject.curOrigin;
	}
	
	dir = VectorNormalize( self.origin - origin );
	dir = ( 0, dir[1], 0 );

	origin = origin + VectorScale( dir, 128 );

	if ( bot::get_difficulty() == "easy" )
	{
		if ( !isdefined( level.next_grenade_time ) )
		{
			level.next_grenade_time = 0;
		}

		if ( GetTime() > level.next_grenade_time )
		{
			if ( !self bot_combat::combat_throw_lethal( origin ) )
			{
				self bot_combat::combat_throw_tactical( origin );
			}
			else
			{
				level.next_grenade_time = GetTime() + RandomIntRange( 60000, 120000 );
			}
		}
	}
	else
	{
		if ( !self bot_combat::combat_throw_lethal( origin ) )
		{
			self bot_combat::combat_throw_tactical( origin );
		}
	}
}

function hill_tactical_insertion()
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

	node = hill_nearest_node();
	mine = GetNearestNode( self.origin );

	if ( isdefined( mine ) && !NodesVisible( mine, node ) )
	{
		origin = self.origin + VectorScale( dir, dist );

		next = GetNearestNode( origin );

		if ( isdefined( next ) && NodesVisible( next, node ) )
		{
			bot_combat::combat_tactical_insertion( self.origin );
		}
	}
}

function hill_nearest_node()
{
	nodes = GetNodesInRadiusSorted( level.zone.gameobject.curOrigin, 256, 0 );
	assert( nodes.size );

	return( nodes[0] );
}
