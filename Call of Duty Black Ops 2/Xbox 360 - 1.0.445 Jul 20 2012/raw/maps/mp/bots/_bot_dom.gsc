#include maps\mp\gametypes\dom;
#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

bot_dom_think()
{
	//Am I already capturing -> continue capping
	if ( self bot_is_capturing_flag() )
	{
		flag = self dom_get_closest_flag();
		self bot_capture_flag( flag );
		return;
	}
	
	//Am I very near an enemy flag -> set as goal
	flag = self dom_get_closest_flag();
	if ( flag getFlagTeam() != self.team && Distance2DSquared( self.origin, flag.origin ) < 300 * 300 && !bot_has_flag_goal( flag ) )
	{
		self bot_move_to_flag( flag );
		return;
	}
		
	//get closest neutral flag
	flag = undefined;	
	flag = dom_get_weighted_flag( "neutral" );

	//if no neutrals -> get best enemy/contested flag
	if ( !IsDefined( flag ) )
	{
		flag = dom_get_best_flag( self.team );
	}
	
	//My team owns 2 flags -> pick one to defend
	if ( dom_has_two_flags( self.team ) )
	{
		if ( self bot_goal_is_enemy_flag() || self bot_has_no_goal() )
		{
			flag = dom_get_random_friendly_flag( self.team );
			self bot_move_to_flag( flag );
		}
		return;
	}
		
	if ( !IsDefined( flag ) )
	{
		return;
	}

	//I dont already have an enemy/contested flag goal -> accept my new goal
	if ( !bot_has_flag_goal( flag ) && !self bot_goal_is_enemy_flag() )
	{
		self bot_move_to_flag( flag );
	}
	else
	{
		if ( !dom_is_game_start() )
		{
			self bot_flag_grenade( flag );
		}

		if ( ( DistanceSquared( self.origin, flag.origin ) < flag.radius * flag.radius ) )
		{
			self bot_capture_flag( flag );
		}
	}
}

bot_move_to_flag( flag )
{
	nodes = GetNodesInRadius( flag.origin, flag.radius, 0 );
	assert( nodes.size );

	node = random( nodes );
	self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "dom_flag" );
}

bot_is_capturing_flag()
{
	return ( self AtGoal( "dom_flag" ) );
}

bot_has_flag_goal( flag )
{
	origin = self GetGoal( "dom_flag" );

	if ( IsDefined( origin ) )
	{
		if ( DistanceSquared( flag.origin, origin ) < flag.radius * flag.radius )
		{
			return true;
		}
	}

	return false;
}

bot_has_no_goal()
{
	origin = self GetGoal( "dom_flag" );

	if ( IsDefined( origin ) )
	{
		return false;
	}
	
	return true;
}

bot_goal_is_enemy_flag()
{
	origin = self GetGoal( "dom_flag" );

	if ( IsDefined( origin ) )
	{
		foreach (flag in level.flags)
		{
			if ( DistanceSquared( flag.origin, origin ) < flag.radius * flag.radius && ( any_other_team_touching( flag, self.team ) || flag getFlagTeam() != self.team ) )
			{
				return true;
			}
		}
	}

	return false;
}

bot_flag_grenade( flag )
{
	if ( flag getFlagTeam() != self.team )
	{
		self maps\mp\bots\_bot_combat::bot_combat_throw_smoke( flag.origin );
	}

	if ( !dom_is_flag_contested( flag, self.team ) )
	{
		return;
	}

	if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( flag.origin ) )
		if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_tactical( flag.origin ) )
			self maps\mp\bots\_bot_combat::bot_combat_throw_proximity( flag.origin );
}

bot_get_look_at( flag )
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

	spawn = random( level.spawn_all );
	node = GetVisibleNode( self.origin, spawn.origin );

	if ( IsDefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
	{
		return node.origin;
	}

	return flag.origin;
}

bot_capture_flag( flag )
{
	if ( flag getFlagTeam() != self.team )
	{
		self AddGoal( self.origin, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "dom_flag" );

		if ( GetTime() > self.bot[ "lookat_update" ] )
		{
			origin = self bot_get_look_at( flag );

			z = 20;

			if ( DistanceSquared( origin, self.origin ) > 512 * 512 )
			{
				z = RandomIntRange( 16, 60 );
			}
						
			self LookAt( origin + ( 0, 0, z ) );

			self.bot[ "lookat_update" ] = GetTime() + RandomIntRange( 1500, 3000 );

			if ( DistanceSquared( origin, self.origin ) > 256 * 256 )
			{
				dir = VectorNormalize( self.origin - origin );
				dir = VectorScale( dir, 256 );

				origin = origin + dir;
			}

			self maps\mp\bots\_bot_combat::bot_combat_throw_proximity( origin );
		}

		if ( !dom_is_game_start() )
		{
			self SetStance( "crouch" );
		}
	}
	else
	{
		self ClearLookAt();
		self CancelGoal( "dom_flag" );

		if ( self GetStance() == "crouch" )
		{
			//self SetStance( "crouch" );
			//wait( 0.25 );
			self SetStance( "stand" );
			wait( 0.25 );
		}
	}
}

dom_is_game_start()
{
	assert( IsDefined( level.flags ) );

	foreach( flag in level.flags )
	{
		if ( flag getFlagTeam() != "neutral" )
		{
			return false;
		}
	}

	return true;
}

dom_get_closest_flag( owner )
{
	assert( IsDefined( level.flags ) );
	
	best = undefined;
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		if ( IsDefined( owner ) && flag getFlagTeam() != owner )
		{
			continue;
		}

		d = DistanceSquared( self.origin, flag.origin );
		
		if ( d < distSq )
		{
			best = flag;
			distSq = d;
		}
	}

	return best;
}

dom_get_weighted_flag( owner )
{
	assert( IsDefined( level.flags ) );
	
	best = undefined;
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		if ( IsDefined( owner ) && flag getFlagTeam() != owner )
		{
			continue;
		}

		d = DistanceSquared( self.origin, flag.origin );
		
		if ( distSq == 9999999 || (d < distSq && randomInt(100) < 70) || randomInt(100) > 70 )
		{
			best = flag;
			distSq = d;
		}
	}

	return best;
}

dom_is_near_flag()
{
	assert( IsDefined( level.flags ) );
	
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		d = DistanceSquared( self.origin, flag.origin );
		
		if ( d < 500 * 500 )
		{
			return true;
		}
	}

	return false;
}

dom_get_random_friendly_flag( owner )
{
	assert( IsDefined( level.flags ) );
	
	randomFlags = [];

	foreach( flag in level.flags )
	{
		if ( IsDefined( owner ) && flag getFlagTeam() != owner )
		{
			continue;
		}
		
		randomFlags[randomFlags.size] = flag;
	}

	return randomFlags[RandomInt(randomFlags.size)];
}

dom_get_weighted_enemy_flag( team )
{
	assert( IsDefined( level.flags ) );
	
	best = undefined;
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		if ( flag getFlagTeam() == team )
		{
			continue;
		}

		d = DistanceSquared( self.origin, flag.origin );
		
		if ( distSq == 9999999 || (d < distSq && randomInt(100) < 80) || randomInt(100) > 80  )
		{
			best = flag;
			distSq = d;
		}
	}

	return best;
}

any_other_team_touching( flag, skip_team )
{
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;
			
		if ( flag.useobj.numtouching[ team ] )
			return true;
	}
	
	return false;
}

dom_is_flag_contested( flag, skip_team )
{
	if ( any_other_team_touching( flag, skip_team ) )
	{
		return true;
	}
	
	enemy = self maps\mp\bots\_bot::bot_get_closest_enemy( flag.origin, true );

	if ( IsDefined( enemy ) && DistanceSquared( enemy.origin, flag.origin ) < 384 * 384 )
	{
		return true;
	}

	return false;
}

dom_has_two_flags( team )
{
	count = 0;
	
	foreach( flag in level.flags )
	{
		if ( any_other_team_touching( flag, team ) )
		{
			continue;
		}

		if ( flag getFlagTeam() == team )
		{
			count++;
		}
	}

	return ( count >= 2 );
}

dom_get_weighted_contested_flag( team )
{
	assert( IsDefined( level.flags ) );

	best = undefined;
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		if ( !dom_is_flag_contested( flag, team ) )
		{
			continue;
		}

		d = DistanceSquared( self.origin, flag.origin );

		if ( distSq == 9999999 || (d < distSq && randomInt(100) < 80) || randomInt(100) > 80  )
		{
			best = flag;
			distSq = d;
		}
	}

	return best;
}

dom_get_random_flag( owner )
{
	assert( IsDefined( level.flags ) );

	flagIndex = RandomIntRange( 0, level.flags.size );

	if ( !IsDefined( owner ) )
	{
		return level.flags[ flagIndex ];
	}

	for ( i = 0; i < level.flags.size; i++ )
	{
		if ( level.flags[ flagIndex ] getFlagTeam() == owner )
		{
			return level.flags[ flagIndex ];
		}

		flagIndex = ( flagIndex + 1 ) % level.flags.size;
	}

	return undefined;
}

dom_get_best_flag( team )
{
	flag1 = dom_get_weighted_enemy_flag( team );
	flag2 = dom_get_weighted_contested_flag( team );

	if ( !IsDefined( flag1 ) )
	{
		return flag2;
	}

	if ( !IsDefined( flag2 ) )
	{
		return flag1;
	}

	offChance = RandomInt(100) > 80;
	
	if ( DistanceSquared( self.origin, flag1.origin ) < DistanceSquared( self.origin, flag2.origin ) )
	{
		if( !offChance )
			return flag1;
		else
			return flag2;
	}
	
	if ( !offChance )
		return flag2;
	else
		return flag1;
}