#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;

                                               	               	               	                	                                                               

#namespace bot_dem;

function dem_think()
{
	if ( !isdefined( level.bombZones[0].dem_points ) )
	{
		foreach( zone in level.bombZones )
		{
			zone.dem_points = [];
			zone.dem_points = GetNavPointsInRadius( zone.trigger.origin, 64, 1024, 64 );
		}
	}

	if ( self.team == game["attackers"] )
	{
		dem_attack_think();
	}
	else
	{
		dem_defend_think();
	}
}

function dem_attack_think()
{
	zones = dem_get_alive_zones();

	if ( !zones.size )
	{
		return;
	}

	if ( !isdefined( self.goal_flag ) )
	{
		zones = array::randomize( zones );

		//this amounts to a 75% chance to pick a planted zone, otherwise its 50/50
		foreach( zone in zones )
		{
			if ( zones.size == 1 || ( ( isdefined( zone.bombPlanted ) && zone.bombPlanted ) && !( isdefined( zone.bombExploded ) && zone.bombExploded ) ) )
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

	if ( isdefined( self.goal_flag ) )
	{
		// check the status of our current zone
		if ( ( isdefined( self.goal_flag.bombExploded ) && self.goal_flag.bombExploded ) )
		{
			self.goal_flag = undefined;
			self CancelGoal( "dem_guard" );
			self CancelGoal( "bomb" );
		}
		else if ( ( isdefined( self.goal_flag.bombPlanted ) && self.goal_flag.bombPlanted ) )
		{
			self dem_guard( self.goal_flag, self.goal_flag.dem_points, self.goal_flag.trigger.origin );
		}
		else if ( self dem_friend_interacting( self.goal_flag.trigger.origin ) )
		{
			self dem_guard( self.goal_flag, self.goal_flag.dem_points, self.goal_flag.trigger.origin );
		}
		else 
		{
			self dem_attack( self.goal_flag );
		}
	}
}

function dem_defend_think()
{
	zones = dem_get_alive_zones();

	if ( !zones.size )
	{
		return;
	}

	if ( !isdefined( self.goal_flag ) )
	{
		zones = array::randomize( zones );

		//this amounts to a 75% chance to pick a planted zone, otherwise its 50/50
		foreach( zone in zones )
		{
			if ( zones.size == 1 || ( ( isdefined( zone.bombPlanted ) && zone.bombPlanted ) && !( isdefined( zone.bombExploded ) && zone.bombExploded ) ) )
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

	if ( isdefined( self.goal_flag ) )
	{
		// check the status of our current zone
		if ( ( isdefined( self.goal_flag.bombExploded ) && self.goal_flag.bombExploded ) )
		{
			self.goal_flag = undefined;
			self CancelGoal( "dem_guard" );
			self CancelGoal( "bomb" );
		}
		else if ( ( isdefined( self.goal_flag.bombPlanted ) && self.goal_flag.bombPlanted ) && !self dem_friend_interacting( self.goal_flag.trigger.origin ) )
		{
			self dem_defuse( self.goal_flag );
		}
		else 
		{
			self dem_guard( self.goal_flag, self.goal_flag.dem_points, self.goal_flag.trigger.origin );
		}
	}
}

function dem_attack( zone )
{
	self CancelGoal( "dem_guard" );

	if ( !self HasGoal( "bomb" ) )
	{
		self.bomb_goal = self dem_get_bomb_goal( zone.visuals[0] );

		if ( isdefined( self.bomb_goal ) )
		{
			self AddGoal( self.bomb_goal, 48, 2, "bomb" );
		}

		return;
	}

	if ( !self AtGoal( "bomb" ) )
	{
		if ( !self bot_combat::combat_throw_smoke( self.bomb_goal ) )
		{
			if ( !self bot_combat::combat_throw_proximity( self.bomb_goal ) )
			{
				self bot_combat::combat_throw_lethal( self.bomb_goal );
			}
		}
		return;
	}

	self AddGoal( self.bomb_goal, 48, 4, "bomb" );
	self SetStance( "prone" );
	self PressUseButton( level.plantTime + 1 );

	wait( 0.5 );

	if ( ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		wait( level.plantTime + 1 );
	}
		
	self PressUseButton( 0 );
	
	defenders = self bot::get_enemies();
	foreach ( defender in defenders )
	{
		if( defender util::is_bot() )
		{
			defender.goal_flag = undefined;	
		}
	}	

	self SetStance( "crouch" );
	wait( 0.25 );

	self CancelGoal( "bomb" );
	self SetStance( "stand" );
}

function dem_guard( zone, points, origin )
{
	self CancelGoal( "bomb" );
	
	// enemy planting/defusing our bomb
	enemy = self dem_enemy_interacting( origin );

	if ( isdefined( enemy ) )
	{
		self bot_combat::combat_throw_lethal( enemy.origin );
		self AddGoal( enemy.origin, 128, 3, "dem_guard" );
		return;
	}

	// nearby enemy
	enemy = self dem_enemy_nearby( origin );

	if ( isdefined( enemy ) )
	{
		self bot_combat::combat_throw_lethal( enemy.origin );
		self AddGoal( enemy.origin, 128, 3, "dem_guard" );
		return;
	}

	// travelling to guard spot
	if ( self HasGoal( "dem_guard" ) && !self AtGoal( "dem_guard" ) )
	{
		self bot_combat::combat_throw_proximity( origin );
		return;
	}

	// TODO: Fix gametype objectives
	if ( isdefined( points ) && points.size > 0 )
	{
		point = array::random( points );
		self AddGoal( point, 24, 2, "dem_guard" );
	}
}

function dem_defuse( zone )
{
	self CancelGoal( "dem_guard" );

	if ( !self HasGoal( "bomb" ) )
	{
		self.bomb_goal = self dem_get_bomb_goal( zone.visuals[0] );

		if ( isdefined( self.bomb_goal ) )
		{
			self AddGoal( self.bomb_goal, 48, 2, "bomb" );
		}

		return;
	}

	if ( !self AtGoal( "bomb" ) )
	{
		if ( !self bot_combat::combat_throw_smoke( self.bomb_goal ) )
		{
			if ( !self bot_combat::combat_throw_proximity( self.bomb_goal ) )
			{
				self bot_combat::combat_throw_lethal( self.bomb_goal );
			}
		}

		if ( self.goal_flag.detonateTime - GetTime() < 12000 )
		{
			self AddGoal( self.bomb_goal, 48, 4, "bomb" );
		}

		return;
	}

	self AddGoal( self.bomb_goal, 48, 4, "bomb" );
	
	if ( math::cointoss() )
	{
		self SetStance( "crouch" );
	}
	else
	{
		self SetStance( "prone" );
	}
		
	self PressUseButton( level.defuseTime + 1 );
	wait( 0.5 );

	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) )
	{
		wait( level.defuseTime + 1 );
	}

	self PressUseButton( 0 );
		
	self SetStance( "crouch" );
	wait( 0.25 );
	
	self CancelGoal( "bomb" );
	self SetStance( "stand" );
}

function dem_enemy_interacting( origin )
{
	enemies = bot::get_enemies();

	foreach( enemy in enemies )
	{
		if ( DistanceSquared( enemy.origin, origin ) > 256 * 256 )
		{
			continue;
		}
		
		if ( ( isdefined( enemy.isDefusing ) && enemy.isDefusing ) || ( isdefined( enemy.isPlanting ) && enemy.isPlanting ) )
		{
			return enemy;
		}
	}

	return undefined;
}

function dem_friend_interacting( origin )
{
	friends = bot::get_friends();

	foreach( friend in friends )
	{
		if ( DistanceSquared( friend.origin, origin ) > 256 * 256 )
		{
			continue;
		}

		if ( ( isdefined( friend.isDefusing ) && friend.isDefusing ) || ( isdefined( friend.isPlanting ) && friend.isPlanting ) )
		{
			return true;
		}
	}

	return false;
}

function dem_enemy_nearby( origin )
{
	enemy = bot::get_closest_enemy( origin, true );

	if ( isdefined( enemy ) )
	{
		if ( DistanceSquared( enemy.origin, origin ) < 1024 * 1024 )
		{
			return enemy;
		}
	}

	return undefined;
}

function dem_get_alive_zones()
{
	zones = [];

	foreach( zone in level.bombZones )
	{
		if ( ( isdefined( zone.bombExploded ) && zone.bombExploded ) )
		{
			continue;
		}

		zones[ zones.size ] = zone;
	}

	return zones;
}

function dem_get_bomb_goal( ent )
{
	if ( !isdefined( ent.bot_goals ) )
	{
		goals = [];
		ent.bot_goals = [];

		dir = AnglesToForward( ent.angles );
		dir = VectorScale( dir, 32 );

		goals[0] = ent.origin + dir;
		goals[1] = ent.origin - dir;

		dir = AnglesToRight( ent.angles );
		dir = VectorScale( dir, 48 );

		goals[2] = ent.origin + dir;
		goals[3] = ent.origin - dir;

		foreach( goal in goals )
		{
			start = goal + ( 0, 0, 128 );
			trace = BulletTrace( start, goal, false, undefined );

			ent.bot_goals[ ent.bot_goals.size ] = trace[ "position" ];
		}
	}

	goals = array::randomize( ent.bot_goals );
	
	foreach( goal in goals )
	{
		if ( self FindPath( self.origin, goal, false ) )
		{
			return goal;
		}
	}

	return undefined;
}