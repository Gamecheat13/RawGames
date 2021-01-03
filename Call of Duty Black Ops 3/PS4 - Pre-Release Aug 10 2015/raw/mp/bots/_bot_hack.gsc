    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

                                               	               	               	                	                                                               

#namespace bot_hack;

function hack_tank_get_goal_origin( tank )
{
	nodes = GetNodesInRadiusSorted( tank.origin, 256, 0, 64, "Path" );

	foreach( node in nodes )
	{
		dir = VectorNormalize( node.origin - tank.origin );
		dir = VectorScale( dir, 32 );

		goal = tank.origin + dir;

		if ( self FindPath( self.origin, goal, false ) )
		{
			return goal;
		}
	}

	return undefined;
}

function hack_has_goal( tank )
{
	goal = self GetGoal( "hack" );

	if ( isdefined( goal ) )
	{
		if ( DistanceSquared( goal, tank.origin ) < 128 * 128 )
		{
			return true;
		}
	}

	return false;
}

function hack_at_goal()
{
	if ( self AtGoal( "hack" ) )
	{
		return true;
	}

	goal = self GetGoal( "hack" );

	if ( isdefined( goal ) )
	{
		tanks = GetEntArray( "talon", "targetname" );
		tanks = ArraySort( tanks, self.origin );

		foreach( tank in tanks )
		{
			if ( DistanceSquared( goal, tank.origin ) < 128 * 128 )
			{
				if ( isdefined( tank.trigger ) && self IsTouching( tank.trigger ) )
				{
					return true;
				}
			}
		}
	}

	return false;
}

function hack_goal_pregame( tanks )
{
	foreach( tank in tanks )
	{
		if ( isdefined( tank.owner ) )
		{
			continue;
		}

		if ( isdefined( tank.team ) && tank.team == self.team )
		{
			continue;
		}

		goal = self hack_tank_get_goal_origin( tank );

		if ( isdefined( goal ) )
		{
			if ( self AddGoal( goal, 24, 2, "hack" ) )
			{
				self.goal_flag = tank;
				return;
			}
		}
	}
}

function hack_think()
{
	if ( hack_at_goal() )
	{
		self SetStance( "crouch" );
		wait( 0.25 );

		self AddGoal( self.origin, 24, 4, "hack" );
		self PressUseButton( level.drone_hack_time + 1 );
		wait( level.drone_hack_time + 1 );
		
		self SetStance( "stand" );
		self CancelGoal( "hack" );
	}
	
	tanks = GetEntArray( "talon", "targetname" );
	tanks = ArraySort( tanks, self.origin );

	if ( !( isdefined( level.drones_spawned ) && level.drones_spawned ) )
	{
		self hack_goal_pregame( tanks );
	}
	else
	{
		foreach( tank in tanks )
		{
			if ( isdefined( tank.owner ) && tank.owner == self )
			{
				continue;
			}

			if ( !isdefined( tank.owner ) )
			{
				if ( self hack_has_goal( tank ) )
				{
					return;
				}
				
				goal = self hack_tank_get_goal_origin( tank );

				if ( isdefined( goal ) )
				{
					self AddGoal( goal, 24, 2, "hack" );
					return;
				}
			}

			if ( tank.isStunned && DistanceSquared( self.origin, tank.origin ) < 512 * 512 )
			{
				goal = self hack_tank_get_goal_origin( tank );

				if ( isdefined( goal ) )
				{
					self AddGoal( goal, 24, 3, "hack" );
					return;
				}
			}
		}

/*
		if ( !bot::bot_vehicle_weapon_ammo( "emp_grenade" ) )
		{
			ammo = GetEntArray( "weapon_scavenger_item_hack", "classname" );
			ammo = ArraySort( ammo, self.origin );

			foreach( bag in ammo )
			{
				if ( FindPath( self.origin, bag.origin, false ) )
				{
					self AddGoal( bag.origin, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_NORMAL, "hack" );
					return;
				}
			}

			return;
		}
*/

		foreach( tank in tanks )
		{
			if ( isdefined( tank.owner ) && tank.owner == self )
			{
				continue;
			}

			if ( tank.isStunned )
			{
				continue;
			}

			if ( self ThrowGrenade( GetWeapon( "emp_grenade" ), tank.origin ) )
			{
				self waittill( "grenade_fire" );

				goal = self hack_tank_get_goal_origin( tank );

				if ( isdefined( goal ) )
				{
					self AddGoal( goal, 24, 3, "hack" );
					wait( 0.5 );
					return;
				}
			}
		}
	}
}
