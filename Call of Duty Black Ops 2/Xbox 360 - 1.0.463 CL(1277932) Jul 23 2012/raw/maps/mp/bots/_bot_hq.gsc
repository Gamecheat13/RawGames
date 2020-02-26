#include maps\mp\gametypes\koth;
#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

#define HQ_RADIUS 160

bot_hq_think()
{
	if ( bot_should_patrol_hq() )
	{
		self bot_patrol_hq();
	}
	else if ( !bot_has_hq_goal() )
	{
		self bot_move_to_hq();
	}

	if ( self bot_is_capturing_hq() )
	{
		self bot_capture_hq();
	}

	bot_hq_tactical_insertion();
	bot_hq_grenade();
}

bot_has_hq_goal()
{
	origin = self GetGoal( "hq_radio" );

	if ( IsDefined( origin ) )
	{
		if ( DistanceSquared( level.radio.gameobject.curOrigin, origin ) < HQ_RADIUS * HQ_RADIUS * 2 )
		{
			return true;
		}
	}

	return false;
}

bot_is_capturing_hq()
{
	return ( self AtGoal( "hq_radio" ) );
}

bot_should_patrol_hq()
{
	if ( isDefined( level.radio.gameobject.ownerTeam ) && level.radio.gameobject.ownerTeam != self.team && level.radio.gameobject.ownerTeam != "neutral" )
	{
		return false;	
	}
	
	
	friends = self maps\mp\bots\_bot::bot_get_friends();

	if ( friends.size < 2 )
	{
		return false;
	}

	if ( self maps\mp\bots\_bot::bot_friend_goal_in_radius( "hq_radio", level.radio.baseorigin, HQ_RADIUS ) > ( friends.size / 2 ) - 1 )
	{
		return true;
	}


	return false;
}

bot_patrol_hq()
{
	self CancelGoal( "hq_radio" );

	if ( self AtGoal( "hq_patrol" ) )
	{
		node = GetNearestNode( self.origin );

		if ( node.type == "Path" )
		{
			self SetStance( "crouch" );
		}
		else
		{
			self SetStance( "stand" );
		}
		
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

			self.bot[ "lookat_update" ] = GetTime() + RandomIntRange( 1500, 3000 );
		}

		goal = self GetGoal( "hq_patrol" );
		nearest = hq_nearest_node();

		mine = GetNearestNode( goal );

		if ( !NodesVisible( mine, nearest ) )
		{
			self ClearLookAt();
			self CancelGoal( "hq_patrol" );
		}

		if ( GetTime() > self.bot[ "patrol_update" ] )
		{
			self ClearLookAt();
			self CancelGoal( "hq_patrol" );
		}

		return;
	}

	nearest = hq_nearest_node();

	if ( self HasGoal( "hq_patrol" ) )
	{
		goal = self GetGoal( "hq_patrol" );

		if ( DistanceSquared( self.origin, goal ) < 256 * 256 )
		{
			origin = self bot_get_look_at();
			self LookAt( origin );
		}

		if ( DistanceSquared( self.origin, goal ) < 128 * 128 )
		{
			self.bot[ "patrol_update" ] = GetTime() + RandomIntRange( 3000, 6000 );
		}

		mine = GetNearestNode( goal );

		if ( !NodesVisible( mine, nearest ) )
		{
			self ClearLookAt();
			self CancelGoal( "hq_patrol" );
		}

		return;
	}

	nodes = GetVisibleNodes( nearest );
	assert( nodes.size );

	i = RandomInt( nodes.size );

	for ( ; i < nodes.size; i++ )
	{
		if ( self maps\mp\bots\_bot::bot_friend_goal_in_radius( "hq_radio", nodes[i].origin, 128 ) == 0 )
		{
			if ( self maps\mp\bots\_bot::bot_friend_goal_in_radius( "hq_patrol", nodes[i].origin, 256 ) == 0 )
			{
				self AddGoal( nodes[i], BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "hq_patrol" );
				return;
			}
		}
	}
}

bot_move_to_hq()
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
				
	nodes = GetNodesInRadius( level.radio.baseorigin, HQ_RADIUS, 0, 64 );
	assert( nodes.size );

	foreach( node in nodes )
	{
		if ( self maps\mp\bots\_bot::bot_friend_goal_in_radius( "hq_radio", node.origin, 64 ) == 0 )
		{
			self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "hq_radio" );
			return;
		}
	}
}

bot_get_look_at()
{
	enemy = self maps\mp\bots\_bot::bot_get_closest_enemy( self.origin, true );

	if ( IsDefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( IsDefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
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

		if ( IsDefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
		{
			return node.origin;
		}
	}

	spawn = random( level.spawnpoints );
	node = GetVisibleNode( self.origin, spawn.origin );

	if ( IsDefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
	{
		return node.origin;
	}
	
	return level.radio.gameobject.curOrigin;
}

bot_capture_hq()
{
	self AddGoal( self.origin, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "hq_radio" );
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

		self.bot[ "lookat_update" ] = GetTime() + RandomIntRange( 1500, 3000 );
	}
}

any_other_team_touching( skip_team )
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

is_hq_contested( skip_team )
{
	if ( any_other_team_touching( skip_team ) )
	{
		return true;
	}

	enemy = self maps\mp\bots\_bot::bot_get_closest_enemy( level.radio.gameobject.curOrigin, true );

	if ( IsDefined( enemy ) && DistanceSquared( enemy.origin, level.radio.gameobject.curOrigin ) < 512 * 512 )
	{
		return true;
	}

	return false;
}

bot_hq_grenade()
{
	enemies = bot_get_enemies();

	if ( !enemies.size )
	{
		return;
	}
	
	if ( self AtGoal( "hq_patrol" ) || self AtGoal( "hq_radio" ) )
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

	if ( !is_hq_contested( self.team ) )
	{
		self maps\mp\bots\_bot_combat::bot_combat_throw_smoke( level.radio.gameobject.curOrigin );
		return;
	}

	enemy = self maps\mp\bots\_bot::bot_get_closest_enemy( level.radio.gameobject.curOrigin, false );

	if ( IsDefined( enemy ) )
	{
		origin = enemy.origin;
	}
	else
	{
		origin = level.radio.gameobject.curOrigin;
	}
	
	dir = VectorNormalize( self.origin - origin );
	dir = ( 0, dir[1], 0 );

	origin = origin + VectorScale( dir, 128 );
	
	if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( origin ) )
	{
		self maps\mp\bots\_bot_combat::bot_combat_throw_tactical( origin );
	}
}

bot_hq_tactical_insertion()
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

	node = hq_nearest_node();
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

hq_nearest_node()
{
	nodes = GetNodesInRadiusSorted( level.radio.gameobject.curOrigin, 256, 0 );
	assert( nodes.size );

	return( nodes[0] );
}