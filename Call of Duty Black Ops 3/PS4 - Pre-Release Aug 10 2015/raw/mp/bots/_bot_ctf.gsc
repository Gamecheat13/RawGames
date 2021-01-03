#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\ctf;

#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;

                                               	               	               	                	                                                               


	
#namespace bot_ctf;

function ctf_think()
{
	time = GetTime();

	if ( time < self.bot.update_objective )
	{
		return;
	}

	self.bot.update_objective = time + RandomIntRange( 500, 1500 );

	if ( bot::get_difficulty() != "easy" )
	{
		flag_mine = ctf_get_flag( self.team );

		if ( flag_mine ctf::isHome() && DistanceSquared( self.origin, flag_mine.curOrigin ) < 512 * 512 )
		{
			points = util::PositionQuery_PointArray( flag_mine.curOrigin, 0, 256, 70, 64 );
			point = array::random( points );
			
			self bot_combat::combat_throw_proximity( ( math::cointoss() ? flag_mine.curOrigin : point ) );
			self bot_combat::combat_toss_frag( ( math::cointoss() ? flag_mine.curOrigin : point ) );
			self bot_combat::combat_toss_flash( ( math::cointoss() ? flag_mine.curOrigin : point ) );
		}
	}

	if ( should_patrol_flag() )
	{
		patrol_flag();
		return;
	}

	self CancelGoal( "ctf_flag_patrol" );

	if ( !ctf_defend() )
	{
		ctf_capture();
	}

	flag_mine	= ctf_get_flag( self.team );
	flag_enemy	= ctf_get_flag( util::getOtherTeam( self.team ) );
	home_mine	= flag_mine ctf_flag_get_home();

	if ( ctf_has_flag( flag_enemy ) && self IsSprinting() && DistanceSquared( self.origin, home_mine ) < 192 * 192 )
	{
		if ( bot_combat::dot_product( home_mine ) > 0.9 )
		{
			self bot::dive_to_prone( "stand" );
		}
	}
	else if ( !flag_mine ctf::isHome() && !isdefined( flag_mine.carrier ) )
	{
		if ( self IsSprinting() && DistanceSquared( self.origin, flag_mine.curOrigin ) < 192 * 192 )
		{
			if ( bot_combat::dot_product( flag_mine.curOrigin ) > 0.9 )
			{
				self bot::dive_to_prone( "stand" );
			}
		}
	}
}

function should_patrol_flag()
{
	flag_mine	= ctf_get_flag( self.team );
	flag_enemy	= ctf_get_flag( util::getOtherTeam( self.team ) );

	home_mine	= flag_mine ctf_flag_get_home();

	if ( self HasGoal( "ctf_flag" ) && !self AtGoal( "ctf_flag" ) )
	{
		return false;
	}

	if ( ctf_has_flag( flag_enemy ) )
	{
		if ( !flag_mine ctf::isHome() )
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	if ( !flag_mine ctf::isHome() )
	{
		return false;
	}

	if ( DistanceSquared( self.origin, flag_enemy.curOrigin ) < 512 * 512 )
	{
		return false;
	}

	if ( bot::get_friends().size && self bot::friend_goal_in_radius( "ctf_flag_patrol", home_mine, 1024 ) == 0 )
	{
		return true;
	}

	return false;
}

function ctf_get_flag( team )
{
	foreach( f in level.flags )
	{
		if ( f gameobjects::get_owner_team() == team )
		{
			return f;
		}
	}

	return undefined;
}

function ctf_flag_get_home()
{
	return ( self.trigger.baseOrigin );
}

function ctf_has_flag( flag )
{
	return ( isdefined( flag.carrier ) && flag.carrier == self );
}

// capture / escort
function ctf_capture()
{
	flag_enemy	= ctf_get_flag( util::getOtherTeam( self.team ) );
	flag_mine	= ctf_get_flag( self.team );

	home_enemy	= flag_enemy ctf_flag_get_home();
	home_mine	= flag_mine ctf_flag_get_home();

	if ( ctf_has_flag( flag_enemy ) )
	{
		self AddGoal( home_mine, 16, 4, "ctf_flag" );
	}
	else if ( isdefined( flag_enemy.carrier ) )
	{
		if ( self AtGoal( "ctf_flag" ) )
		{
			self CancelGoal( "ctf_flag" );
		}
		
		goal = self GetGoal( "ctf_flag" );

		if ( isdefined( goal ) && DistanceSquared( goal, flag_enemy.carrier.origin ) < 768 * 768 )
		{
			return;
		}

		nodes = GetNodesInRadius( flag_enemy.carrier.origin, 512, 64, 256, "any", 8 );
		
		if ( nodes.size )
			self AddGoal( array::random( nodes ), 16, 3, "ctf_flag" );
		else
			self AddGoal( flag_enemy.carrier.origin, 16, 3, "ctf_flag" );
	}
	else if ( self bot::friend_goal_in_radius( "ctf_flag", flag_enemy.curOrigin, 16 ) <= 1 )
	{
		self AddGoal( flag_enemy.curOrigin, 16, 3, "ctf_flag" );
	}
}

// defend / retrieve
function ctf_defend()
{
	flag_enemy	= ctf_get_flag( util::getOtherTeam( self.team ) );
	flag_mine	= ctf_get_flag( self.team );

	home_enemy	= flag_enemy ctf_flag_get_home();
	home_mine	= flag_mine ctf_flag_get_home();

	if ( flag_mine ctf::isHome() )
	{
		return false;
	}

	if ( ctf_has_flag( flag_enemy ) )
	{
		return false;
	}
	
	if ( !isdefined( flag_mine.carrier ) )
	{
		if ( self bot::friend_goal_in_radius( "ctf_flag", flag_mine.curOrigin, 16 ) <= 1 )
		{
			return self ctf_add_goal( flag_mine.curOrigin, 4, "ctf_flag" );
		}
	}
	else
	{
		if ( !flag_enemy ctf::isHome() || Distance2DSquared( self.origin, home_enemy ) > 500 * 500 )
		{
			return self ctf_add_goal( flag_mine.curOrigin, 4, "ctf_flag" );
		}
		else if ( self bot::friend_goal_in_radius( "ctf_flag", home_enemy, 16 ) <= 1 )
		{
			self AddGoal( home_enemy, 16, 4, "ctf_flag" );
		}
	}

	return true;
}

function ctf_add_goal( origin, goal_priority, goal_name )
{
	goal = undefined;
	
	if ( self FindPath( self.origin, origin, false, true ) )
	{
		goal = origin;
	}
	else
	{
		visibleOrigin = ctf_random_visible_point( origin );

		if ( isdefined( visibleOrigin ) )
		{
			if ( self FindPath( self.origin, visibleOrigin, false, true ) )
			{
				goal = visibleOrigin;
				self.bot.update_objective += RandomIntRange( 3000, 5000 );
			}
		}
	}

	if ( isdefined( goal ) )
	{
		self AddGoal( goal, 16, goal_priority, goal_name );
		return true;
	}

	return false;
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

	flag_mine = ctf_get_flag( self.team );
	home_mine = flag_mine ctf_flag_get_home();

	return home_mine;
}

function patrol_flag()
{
	self CancelGoal( "ctf_flag" );
	flag_mine = ctf_get_flag( self.team );

	if ( self AtGoal( "ctf_flag_patrol" ) )
	{
		node = GetNearestNode( self.origin );

		if ( !isdefined( node ) )
		{
			self ClearLookAt();
			self CancelGoal( "ctf_flag_patrol" );
			return;
		}

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

		goal = self GetGoal( "ctf_flag_patrol" );
		nearest = base_nearest_point( flag_mine );

		mine = GetNearestNode( goal );

		if ( isdefined( mine ) && !bot::navmesh_points_visible( mine.origin, nearest ) )
		{
			self ClearLookAt();
			self CancelGoal( "ctf_flag_patrol" );
		}

		if ( GetTime() > self.bot.update_objective_patrol )
		{
			self ClearLookAt();
			self CancelGoal( "ctf_flag_patrol" );
		}

		return;
	}

	nearest = base_nearest_point( flag_mine );

	if ( self HasGoal( "ctf_flag_patrol" ) )
	{
		goal = self GetGoal( "ctf_flag_patrol" );

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
			self CancelGoal( "ctf_flag_patrol" );
		}

		return;
	}

	if ( GetTime() < self.bot.update_objective_patrol )
	{
		return;
	}

	points = util::PositionQuery_PointArray( nearest, 0, 512, 70, 64 );
	points = NavPointSightFilter( points, nearest );
	assert( points.size );

	i = RandomInt( points.size );

	for ( ; i < points.size; i++ )
	{
		if ( self bot::friend_goal_in_radius( "ctf_flag_patrol", points[i], 256 ) == 0 )
		{
			self AddGoal( points[i], 24, 3, "ctf_flag_patrol" );
			self.bot.update_objective_patrol = GetTime() + RandomIntRange( 3000, 6000 );
			return;
		}
	}
}

function base_nearest_point( flag )
{
	home = flag ctf_flag_get_home();

	points = util::PositionQuery_PointArray( home, 0, 256, 70, 32 );
	assert( points.size );

	return( points[0] );
}

function ctf_random_visible_point( origin )
{
	points = util::PositionQuery_PointArray( origin, 0, 384, 70, 32 );
	nearest = bot_combat::nearest_node( origin );

	if ( isdefined( nearest ) && points.size )
	{
		current = RandomIntRange( 0, points.size );

		for( i = 0; i < points.size; i++ )
		{
			current = ( current + 1 ) % points.size; 

			if ( bot::navmesh_points_visible( points[current], nearest.origin ) )
			{
				return points[current];
			}
		}
	}

	return undefined;
}