#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\dom;

#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;

                                               	               	               	                	                                                               


	
#namespace bot_dom;	

 // size of radius trigger in BO2


	// Default Radius * 2.5

	
function dom_think()
{
	time = GetTime();
	
	if ( time < self.bot.update_objective )
	{
		return;
	}

	self.bot.update_objective = time + RandomIntRange( 500, 1500 );
	
	//Am I already capturing -> continue capping
	if ( self is_capturing_flag() )
	{
		flag = self dom_get_closest_flag();
		self capture_flag( flag );
		return;
	}
	
	//Am I very near an enemy flag -> set as goal
	flag = self dom_get_closest_flag();
	if ( flag dom::getFlagTeam() != self.team && Distance2DSquared( self.origin, flag.origin ) < 384 * 384 && !has_flag_goal( flag ) )
	{
		self move_to_flag( flag );
		return;
	}
		
	//get closest neutral flag
	flag = dom_get_weighted_flag( "neutral" );

	//if no neutrals -> get best enemy/contested flag
	if ( !isdefined( flag ) )
	{
		flag = dom_get_best_flag( self.team );
	}
	
	//My team owns 2 flags -> pick one to defend
	if ( dom_has_two_flags( self.team ) )
	{
		flag = dom_get_best_flag( self.team );
	}
		
	if ( !isdefined( flag ) )
	{
		return;
	}

	//I dont already have an enemy/contested flag goal -> accept my new goal
	if ( !has_flag_goal( flag ) && !self goal_is_enemy_flag() )
	{
		self move_to_flag( flag );
	}
	else
	{
		if ( !dom_is_game_start() )
		{
			self flag_grenade( flag );
		}

		if ( self isTouching( flag ) )
		{
			self capture_flag( flag );
		}
	}
}

function move_to_flag( flag )
{
	radius = 160;
	
	if ( IsDefined( flag.radius ) )
	{
		radius = flag.radius;
	}
	
	points = util::PositionQuery_PointArray( flag.origin, 0, radius, 72, 37.5, 15 );
	assert( points.size );

	point = array::random( points );
	self AddGoal( point, 24, 3, "dom_flag" );
}

function is_capturing_flag()
{
	return ( self AtGoal( "dom_flag" ) );
}

function is_touching_flag( flag, origin )
{
	radius = 160;
	
	if ( IsDefined( flag.radius ) )
	{
		radius = flag.radius;
	}
	
	// need to better handle geometric triggers
	if ( DistanceSquared( flag.origin, origin ) < radius * radius )
	{
		return true;
	}
	return false;
}

function has_flag_goal( flag )
{
	origin = self GetGoal( "dom_flag" );

	if ( isdefined( origin ) )
	{
		if ( is_touching_flag( flag, origin ) )
		{
			return true;
		}
	}

	return false;
}

function has_no_goal()
{
	origin = self GetGoal( "dom_flag" );

	if ( isdefined( origin ) )
	{
		return false;
	}
	
	return true;
}

function goal_is_enemy_flag()
{
	origin = self GetGoal( "dom_flag" );

	if ( isdefined( origin ) )
	{
		foreach (flag in level.flags)
		{
			if ( is_touching_flag( flag, origin ) )
			{
				if ( flag dom::getFlagTeam() != self.team || dom_is_flag_contested( flag ) )
				{
					return true;
				}
			}
		}
	}

	return false;
}

function flag_grenade( flag )
{
	if ( flag dom::getFlagTeam() != self.team )
	{
		if ( tactical_insertion( flag ) )
		{
			return;
		}

		self bot_combat::combat_throw_smoke( flag.origin );
	}

	if ( !dom_is_flag_contested( flag ) )
	{
		return;
	}
	
	if ( !self bot_combat::combat_throw_lethal( flag.origin ) )
		if ( !self bot_combat::combat_throw_tactical( flag.origin ) )
			self bot_combat::combat_throw_proximity( flag.origin );
}

function get_look_at( flag )
{
	enemy = self bot::get_closest_enemy( self.origin, false );

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
		{
			return node.origin;
		}
	}

	spawn = array::random( level.spawn_all );
	node = GetVisibleNode( self.origin, spawn.origin );

	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 128 * 128 )
	{
		return node.origin;
	}

	return flag.origin;
}

function capture_flag( flag )
{
	time = GetTime();
	
	if ( flag dom::getFlagTeam() != self.team )
	{
		if ( self GetStance() == "prone" )
		{
			self AddGoal( self.origin, 24, 4, "dom_flag" );
		}
		else
		{
			self AddGoal( self.origin, 24, 3, "dom_flag" );
		}
		

		if ( time > self.bot.update_lookat )
		{
			origin = self get_look_at( flag );

			z = 20;

			if ( DistanceSquared( origin, self.origin ) > 512 * 512 )
			{
				z = RandomIntRange( 16, 60 );
			}
						
			self LookAt( origin + ( 0, 0, z ) );

			self.bot.update_lookat = time + RandomIntRange( 1500, 3000 );

			if ( DistanceSquared( origin, self.origin ) > 256 * 256 )
			{
				dir = VectorNormalize( self.origin - origin );
				dir = VectorScale( dir, 256 );

				origin = origin + dir;
			}

			self bot_combat::combat_throw_proximity( origin );
			self bot_combat::combat_toss_frag( self.origin );
			self bot_combat::combat_toss_flash( self.origin );

			if ( !dom_is_game_start() )
			{
				weapon = self GetCurrentWeapon();

				if ( weapon.isRiotShield || weapon.name == "minigun" )
				{
					if ( math::cointoss() )
					{
						self AddGoal( self.origin, 24, 4, "dom_flag" );
						self SetStance( "crouch" );
					}
				}
				else if ( math::cointoss() && !bot::friend_in_radius( self.origin, 384 ) )
				{
					self AddGoal( self.origin, 24, 4, "dom_flag" );
					wait( RandomFloatRange( 0.5, 1 ) );
					self SetStance( "prone" );
					self.bot.update_lookat += 5000;
				}
			}
		}
		else if ( !dom_is_game_start() )
		{
			if ( self GetStance() == "stand" )
			{
				wait( RandomFloatRange( 0.5, 1 ) );
				self SetStance( "crouch" );
			}
		}
	}
	else
	{
		self ClearLookAt();
		self CancelGoal( "dom_flag" );

		if ( self GetStance() == "crouch" )
		{
			self SetStance( "stand" );
			wait( 0.25 );
		}
		else if ( self GetStance() == "prone" )
		{
			self SetStance( "crouch" );
			wait( 0.25 );
			self SetStance( "stand" );
			wait( 0.25 );
		}
	}
}

function dom_is_game_start()
{
	assert( isdefined( level.flags ) );

	foreach( flag in level.flags )
	{
		if ( flag dom::getFlagTeam() != "neutral" )
		{
			return false;
		}
	}

	return true;
}

function dom_get_closest_flag()
{
	flags = ArraySort( level.flags, self.origin );
	return ( flags[0] );
}

function dom_get_weighted_flag( owner )
{
	assert( isdefined( level.flags ) );
	
	best = undefined;
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		if ( isdefined( owner ) && flag dom::getFlagTeam() != owner )
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

function dom_get_weighted_enemy_flag( team )
{
	assert( isdefined( level.flags ) );
	
	best = undefined;
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		if ( flag dom::getFlagTeam() == team )
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

function dom_is_flag_contested( flag )
{
	enemy = self bot::get_closest_enemy( flag.origin, false );
	return ( isdefined( enemy ) && DistanceSquared( enemy.origin, flag.origin ) < 384 * 384 );
}

function dom_has_two_flags( team )
{
	count = 0;
	
	foreach( flag in level.flags )
	{
		if ( dom_is_flag_contested( flag ) )
		{
			continue;
		}

		if ( flag dom::getFlagTeam() == team )
		{
			count++;
		}
	}

	return ( count >= 2 );
}

function dom_get_weighted_contested_flag( team )
{
	assert( isdefined( level.flags ) );

	best = undefined;
	distSq = 9999999;

	foreach( flag in level.flags )
	{
		if ( !dom_is_flag_contested( flag ) )
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

function dom_get_random_flag( owner )
{
	assert( isdefined( level.flags ) );

	flagIndex = RandomIntRange( 0, level.flags.size );

	if ( !isdefined( owner ) )
	{
		return level.flags[ flagIndex ];
	}

	for ( i = 0; i < level.flags.size; i++ )
	{
		if ( level.flags[ flagIndex ] dom::getFlagTeam() == owner )
		{
			return level.flags[ flagIndex ];
		}

		flagIndex = ( flagIndex + 1 ) % level.flags.size;
	}

	return undefined;
}

function dom_get_best_flag( team )
{
	flag1 = dom_get_weighted_enemy_flag( team );
	flag2 = dom_get_weighted_contested_flag( team );

	if ( !isdefined( flag1 ) )
	{
		return flag2;
	}

	if ( !isdefined( flag2 ) )
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

function tactical_insertion( flag )
{
	if ( self GetWeaponAmmoStock( GetWeapon( "tactical_insertion" ) ) <= 0 )
	{
		return false;
	}

	dist = self GetLookAheadDist();
	dir = self GetLookaheadDir();

	if ( !isdefined( dist ) || !isdefined( dir ) )
	{
		return false;
	}

	node = bot_combat::nearest_node( flag.origin );
	mine = bot_combat::nearest_node( self.origin );

	if ( isdefined( mine ) && !NodesVisible( mine, node ) )
	{
		origin = self.origin + VectorScale( dir, dist );

		next = bot_combat::nearest_node( origin );

		if ( next IsDangerous( self.team ) )
		{
			return false;
		}

		if ( isdefined( next ) && NodesVisible( next, node ) )
		{
			return bot_combat::combat_tactical_insertion( self.origin );
		}
	}

	return false;
}