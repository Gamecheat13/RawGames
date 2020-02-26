#include maps\mp\gametypes\koth;
#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

#define HILL_RADIUS 500

bot_koth_think()
{
	if ( !IsDefined( level.zone.trig.goal_radius ) )
	{
		maxs = level.zone.trig GetMaxs();
		maxs = level.zone.trig.origin + maxs;

		level.zone.trig.goal_radius = Distance( level.zone.trig.origin, maxs );
		/# println( "distance: " + level.zone.trig.goal_radius ); #/
	}

	if ( !IsDefined( self.koth_goal_time ) )
	{
		self.koth_goal_time = 0;
	}
	
	if ( !bot_has_hill_goal() )
	{
		self bot_move_to_hill();
	}

	if ( self bot_is_at_hill() )
	{
		self bot_capture_hill();
	}

	bot_hill_tactical_insertion();
	bot_hill_grenade();
}

bot_has_hill_goal()
{
	origin = self GetGoal( "koth_hill" );

	if ( IsDefined( origin ) )
	{
		if ( Distance2DSquared( level.zone.gameobject.curOrigin, origin ) < level.zone.trig.goal_radius * level.zone.trig.goal_radius )
		{
			return true;
		}
	}

	return false;
}

bot_is_at_hill()
{
	return ( self AtGoal( "koth_hill" ) );
}

bot_move_to_hill()
{
	if ( GetTime() < self.koth_goal_time + 4000 )
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
				
	nodes = GetNodesInRadiusSorted( level.zone.gameobject.curOrigin, level.zone.trig.goal_radius, 0, 128 );
	//assert( nodes.size );

	foreach( node in nodes )
	{
		if ( self maps\mp\bots\_bot::bot_friend_goal_in_radius( "koth_hill", node.origin, 64 ) == 0 )
		{
			if( FindPath( self.origin, node.origin, self, false ) )
			{
				self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "koth_hill" );
				self.koth_goal_time = GetTime();
				return;
			}
		}
	}
}

bot_get_look_at()
{
	enemy = self maps\mp\bots\_bot::bot_get_closest_enemy( self.origin, true );

	if ( IsDefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( IsDefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
		{
			return node.origin;
		}
	}

	enemies = self maps\mp\bots\_bot::bot_get_enemies( false );

	if ( enemies.size )
	{
		enemy = random( enemies );
	}

	if ( IsDefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( IsDefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
		{
			return node.origin;
		}
	}

	spawn = random( level.spawnpoints );
	node = GetVisibleNode( self.origin, spawn.origin );

	if ( IsDefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
	{
		return node.origin;
	}
	
	return level.zone.gameobject.curOrigin;
}

bot_capture_hill()
{
	self AddGoal( self.origin, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "koth_hill" );
	self SetStance( "crouch" );

	if ( GetTime() > self.bot[ "lookat_update" ] )
	{
		origin = self bot_get_look_at();

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

		self maps\mp\bots\_bot_combat::bot_combat_throw_proximity( origin );

		if ( cointoss() && LengthSquared( self GetVelocity() ) < 2 )
		{
			nodes = GetNodesInRadius( level.zone.gameobject.curOrigin, level.zone.trig.goal_radius + 128, 0, 128 );
			i = RandomIntRange( 0, nodes.size );

			for( ; i < nodes.size; i++ )
			{
				node = nodes[i];

				if ( DistanceSquared( node.origin, self.origin ) > 32 * 32 )
				{
					if ( self maps\mp\bots\_bot::bot_friend_goal_in_radius( "koth_hill", node.origin, 128 ) == 0 )
					{
						if( FindPath( self.origin, node.origin, self, false ) )
						{
							self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "koth_hill" );
							self.koth_goal_time = GetTime();
							break;
						}
					}
				}
			}
		}

		self.bot[ "lookat_update" ] = GetTime() + RandomIntRange( 1500, 3000 );
	}
}

any_other_team_touching( skip_team )
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

is_hill_contested( skip_team )
{
	if ( any_other_team_touching( skip_team ) )
	{
		return true;
	}

	enemy = self maps\mp\bots\_bot::bot_get_closest_enemy( level.zone.gameobject.curOrigin, true );

	if ( IsDefined( enemy ) && DistanceSquared( enemy.origin, level.zone.gameobject.curOrigin ) < 512 * 512 )
	{
		return true;
	}

	return false;
}

bot_hill_grenade()
{
	enemies = bot_get_enemies();

	if ( !enemies.size )
	{
		return;
	}
	
	if ( self AtGoal( "hill_patrol" ) || self AtGoal( "koth_hill" ) )
	{
		if ( self GetWeaponAmmoStock( "proximity_grenade_mp" ) > 0 )
		{
			origin = bot_get_look_at();

			if ( self maps\mp\bots\_bot_combat::bot_combat_throw_proximity( origin ) )
			{
				return;
			}
		}
	}

	if ( !is_hill_contested( self.team ) )
	{
		if ( !IsDefined( level.next_smoke_time ) )
		{
			level.next_smoke_time = 0;
		}

		if ( GetTime() > level.next_smoke_time )
		{
			if ( self maps\mp\bots\_bot_combat::bot_combat_throw_smoke( level.zone.gameobject.curOrigin ) )
			{
				level.next_smoke_time = GetTime() + RandomIntRange( 60000, 120000 );
			}
		}
		
		return;
	}

	enemy = self maps\mp\bots\_bot::bot_get_closest_enemy( level.zone.gameobject.curOrigin, false );

	if ( IsDefined( enemy ) )
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

	if ( maps\mp\bots\_bot::bot_get_difficulty() == "easy" )
	{
		if ( !IsDefined( level.next_grenade_time ) )
		{
			level.next_grenade_time = 0;
		}

		if ( GetTime() > level.next_grenade_time )
		{
			if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( origin ) )
			{
				self maps\mp\bots\_bot_combat::bot_combat_throw_tactical( origin );
			}
			else
			{
				level.next_grenade_time = GetTime() + RandomIntRange( 60000, 120000 );
			}
		}
	}
	else
	{
		if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( origin ) )
		{
			self maps\mp\bots\_bot_combat::bot_combat_throw_tactical( origin );
		}
	}
}

bot_hill_tactical_insertion()
{
	if ( !self HasWeapon( "tactical_insertion_mp" ) )
	{
		return;
	}

	dist = self GetLookAheadDist();
	dir = self GetLookaheadDir();

	if ( !IsDefined( dist ) || !IsDefined( dir ) )
	{
		return;
	}

	node = hill_nearest_node();
	mine = GetNearestNode( self.origin );

	if ( IsDefined( mine ) && !NodesVisible( mine, node ) )
	{
		origin = self.origin + VectorScale( dir, dist );

		next = GetNearestNode( origin );

		if ( IsDefined( next ) && NodesVisible( next, node ) )
		{
			bot_combat_tactical_insertion( self.origin );
		}
	}
}

hill_nearest_node()
{
	nodes = GetNodesInRadiusSorted( level.zone.gameobject.curOrigin, 256, 0 );
	assert( nodes.size );

	return( nodes[0] );
}