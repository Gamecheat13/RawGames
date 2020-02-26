#include maps\mp\gametypes\dem;
#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

bot_dem_think()
{
	if ( !IsDefined( level.bombZones[0].dem_nodes ) )
	{
		foreach( zone in level.bombZones )
		{
			zone.dem_nodes = [];
			zone.dem_nodes = GetNodesInRadius( zone.trigger.origin, 1024, 64, 128, "Path" );
		}
	}

	if ( self.team == game["attackers"] )
	{
		bot_dem_attack_think();
	}
	else
	{
		bot_dem_defend_think();
	}
}

bot_dem_attack_think()
{
	zones = dem_get_alive_zones();

	if ( !zones.size )
	{
		return;
	}

	if ( !IsDefined( self.goal_flag ) )
	{
		zones = array_randomize( zones );

		//this amounts to a 75% chance to pick a planted zone, otherwise its 50/50
		foreach( zone in zones )
		{
			if ( zones.size == 1 || ( is_true( zone.bombPlanted ) && !is_true( zone.bombExploded ) ) )
			{
				self.goal_flag = zone;
				break;
			}
			else if ( RandomInt( 100 ) < 50 )
			{
				self.goal_flag = zone;
				break;
			}
		}
	}

	if ( IsDefined( self.goal_flag ) )
	{
		// check the status of our current zone
		if ( is_true( self.goal_flag.bombExploded ) )
		{
			self.goal_flag = undefined;
			self CancelGoal( "dem_guard" );
			self CancelGoal( "bomb" );
		}
		else if ( is_true( self.goal_flag.bombPlanted ) )
		{
			self bot_dem_guard( self.goal_flag, self.goal_flag.dem_nodes, self.goal_flag.trigger.origin );
		}
		else if ( self bot_dem_friend_interacting( self.goal_flag.trigger.origin ) )
		{
			self bot_dem_guard( self.goal_flag, self.goal_flag.dem_nodes, self.goal_flag.trigger.origin );
		}
		else 
		{
			self bot_dem_attack( self.goal_flag );
		}
	}
}

bot_dem_defend_think()
{
	zones = dem_get_alive_zones();

	if ( !zones.size )
	{
		return;
	}

	if ( !IsDefined( self.goal_flag ) )
	{
		zones = array_randomize( zones );

		//this amounts to a 75% chance to pick a planted zone, otherwise its 50/50
		foreach( zone in zones )
		{
			if ( zones.size == 1 || ( is_true( zone.bombPlanted ) && !is_true( zone.bombExploded ) ) )
			{
				self.goal_flag = zone;
				break;
			}
			else if ( RandomInt( 100 ) < 50 )
			{
				self.goal_flag = zone;
				break;
			}
		}
	}

	if ( IsDefined( self.goal_flag ) )
	{
		// check the status of our current zone
		if ( is_true( self.goal_flag.bombExploded ) )
		{
			self.goal_flag = undefined;
			self CancelGoal( "dem_guard" );
			self CancelGoal( "bomb" );
		}
		else if ( is_true( self.goal_flag.bombPlanted ) && !self bot_dem_friend_interacting( self.goal_flag.trigger.origin ) )
		{
			self bot_dem_defuse( self.goal_flag );
		}
		else 
		{
			self bot_dem_guard( self.goal_flag, self.goal_flag.dem_nodes, self.goal_flag.trigger.origin );
		}
	}
}

bot_dem_attack( zone )
{
	self CancelGoal( "dem_guard" );

	if ( !self HasGoal( "bomb" ) )
	{
		self.bomb_goal = self dem_get_bomb_goal( zone.visuals[0] );

		if ( IsDefined( self.bomb_goal ) )
		{
			self AddGoal( self.bomb_goal, 48, PRIORITY_NORMAL, "bomb" );
		}

		return;
	}

	if ( !self AtGoal( "bomb" ) )
	{
		if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_smoke( self.bomb_goal ) )
		{
			if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_proximity( self.bomb_goal ) )
			{
				self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( self.bomb_goal );
			}
		}
		return;
	}

	self AddGoal( self.bomb_goal, 48, PRIORITY_URGENT, "bomb" );
	self SetStance( "prone" );
	self PressUseButton( level.plantTime + 1 );

	wait( 0.5 );

	if ( is_true( self.isPlanting ) )
	{
		wait( level.plantTime + 1 );
	}
		
	self PressUseButton( 0 );
	
	defenders = self bot_get_enemies();
	foreach ( defender in defenders )
	{
		if( defender is_bot() )
		{
			defender.goal_flag = undefined;	
		}
	}	

	self SetStance( "crouch" );
	wait( 0.25 );

	self CancelGoal( "bomb" );
	self SetStance( "stand" );
}

bot_dem_guard( zone, nodes, origin )
{
	self CancelGoal( "bomb" );
	
	// enemy planting/defusing our bomb
	enemy = self bot_dem_enemy_interacting( origin );

	if ( IsDefined( enemy ) )
	{
		self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( enemy.origin );
		self AddGoal( enemy.origin, 128, PRIORITY_HIGH, "dem_guard" );
		return;
	}

	// nearby enemy
	enemy = self bot_dem_enemy_nearby( origin );

	if ( IsDefined( enemy ) )
	{
		self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( enemy.origin );
		self AddGoal( enemy.origin, 128, PRIORITY_HIGH, "dem_guard" );
		return;
	}

	// travelling to guard spot
	if ( self HasGoal( "dem_guard" ) && !self AtGoal( "dem_guard" ) )
	{
		self maps\mp\bots\_bot_combat::bot_combat_throw_proximity( origin );
		return;
	}

	node = random( nodes );
	self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_NORMAL, "dem_guard" );
}

bot_dem_defuse( zone )
{
	self CancelGoal( "dem_guard" );

	if ( !self HasGoal( "bomb" ) )
	{
		self.bomb_goal = self dem_get_bomb_goal( zone.visuals[0] );

		if ( IsDefined( self.bomb_goal ) )
		{
			self AddGoal( self.bomb_goal, 48, PRIORITY_NORMAL, "bomb" );
		}

		return;
	}

	if ( !self AtGoal( "bomb" ) )
	{
		if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_smoke( self.bomb_goal ) )
		{
			if ( !self maps\mp\bots\_bot_combat::bot_combat_throw_proximity( self.bomb_goal ) )
			{
				self maps\mp\bots\_bot_combat::bot_combat_throw_lethal( self.bomb_goal );
			}
		}

		if ( self.goal_flag.detonateTime - GetTime() < 12000 )
		{
			self AddGoal( self.bomb_goal, 48, PRIORITY_URGENT, "bomb" );
		}

		return;
	}

	self AddGoal( self.bomb_goal, 48, PRIORITY_URGENT, "bomb" );
	
	if ( cointoss() )
	{
		self SetStance( "crouch" );
	}
	else
	{
		self SetStance( "prone" );
	}
		
	self PressUseButton( level.defuseTime + 1 );
	wait( 0.5 );

	if ( is_true( self.isDefusing ) )
	{
		wait( level.defuseTime + 1 );
	}

	self PressUseButton( 0 );
		
	self SetStance( "crouch" );
	wait( 0.25 );
	
	self CancelGoal( "bomb" );
	self SetStance( "stand" );
}

bot_dem_enemy_interacting( origin )
{
	enemies = maps\mp\bots\_bot::bot_get_enemies();

	foreach( enemy in enemies )
	{
		if ( DistanceSquared( enemy.origin, origin ) > 256 * 256 )
		{
			continue;
		}
		
		if ( is_true( enemy.isDefusing ) || is_true( enemy.isPlanting ) )
		{
			return enemy;
		}
	}

	return undefined;
}

bot_dem_friend_interacting( origin )
{
	friends = maps\mp\bots\_bot::bot_get_friends();

	foreach( friend in friends )
	{
		if ( DistanceSquared( friend.origin, origin ) > 256 * 256 )
		{
			continue;
		}

		if ( is_true( friend.isDefusing ) || is_true( friend.isPlanting ) )
		{
			return true;
		}
	}

	return false;
}

bot_dem_enemy_nearby( origin )
{
	enemy = maps\mp\bots\_bot::bot_get_closest_enemy( origin, true );

	if ( IsDefined( enemy ) )
	{
		if ( DistanceSquared( enemy.origin, origin ) < 1024 * 1024 )
		{
			return enemy;
		}
	}

	return undefined;
}

dem_get_alive_zones()
{
	zones = [];

	foreach( zone in level.bombZones )
	{
		if ( is_true( zone.bombExploded ) )
		{
			continue;
		}

		zones[ zones.size ] = zone;
	}

	return zones;
}

dem_get_bomb_goal( ent )
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

	goals = array_randomize( goals );

	foreach( goal in goals )
	{
		if ( FindPath( self.origin, goal, false ) )
		{
			return goal;
		}
	}

	return undefined;
}