#include maps\mp\gametypes\ctf;
#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

#define CTF_GOAL_RADIUS 16

bot_ctf_think()
{
	if ( !bot_ctf_defend() )
	{
		bot_ctf_capture();
	}
}

ctf_get_flag( team )
{
	foreach( f in level.flags )
	{
		if ( f maps\mp\gametypes\_gameobjects::getOwnerTeam() == team )
		{
			return f;
		}
	}

	return undefined;
}

ctf_flag_get_home()
{
	return ( self.trigger.baseOrigin );
}

ctf_flag_in_sight( flag )
{
	if ( IsDefined( flag.carrier ) )
	{
		return false;
	}
	
	offset = ( 0, 0, 60 );
	start = self.origin + offset;
	end = flag.curOrigin + offset;

	return ( BulletTracePassed( start, end, false, flag ) );
}

ctf_flag_is_close( flag )
{
	return ( DistanceSquared( self.origin, flag.curOrigin ) < 512 * 512 );
}

ctf_has_flag( flag )
{
	return ( IsDefined( flag.carrier ) && flag.carrier == self );
}

ctf_move_to_flag()
{
	home = ctf_get_flag( self.team ) ctf_flag_get_home();

	node = random( level.ctf_nodes[ self.team ] );
	self AddGoal( node.origin, 64, PRIORITY_LOW, "ctf_flank" );

	self waittill( "ctf_flank", event );

	if ( event != "goal" )
	{
		return;
	}

	self AddGoal( home, 32, PRIORITY_URGENT, "ctf_flag" );
}

// capture / escort
bot_ctf_capture()
{
	flag_enemy	= ctf_get_flag( getOtherTeam( self.team ) );
	flag_mine	= ctf_get_flag( self.team );

	home_enemy	= flag_enemy ctf_flag_get_home();
	home_mine	= flag_mine ctf_flag_get_home();

	if ( ctf_has_flag( flag_enemy ) )
	{
		self AddGoal( home_mine, CTF_GOAL_RADIUS, PRIORITY_HIGH, "ctf_flag" );
	}
	else if ( IsDefined( flag_enemy.carrier ) )
	{
		if ( self AtGoal( "ctf_flag" ) )
		{
			self CancelGoal( "ctf_flag" );
		}
		
		goal = self GetGoal( "ctf_flag" );

		if ( IsDefined( goal ) && DistanceSquared( goal, flag_enemy.carrier.origin ) < 768 * 768 )
		{
			return;
		}

		nodes = GetNodesInRadius( flag_enemy.carrier.origin, 512, 64, 256, "any", 8 );
		self AddGoal( random( nodes ), CTF_GOAL_RADIUS, PRIORITY_HIGH, "ctf_flag" );
	}
	else 
	{
		self AddGoal( flag_enemy.curOrigin, CTF_GOAL_RADIUS, PRIORITY_HIGH, "ctf_flag" );
	}
}

// defend / retrieve
bot_ctf_defend()
{
	flag_enemy	= ctf_get_flag( getOtherTeam( self.team ) );
	flag_mine	= ctf_get_flag( self.team );

	home_enemy	= flag_enemy ctf_flag_get_home();
	home_mine	= flag_mine ctf_flag_get_home();

	if ( flag_mine isHome() )
	{
		return false;
	}

	if ( ctf_has_flag( flag_enemy ) )
	{
		return false;
	}
	
	if ( isDefined( flag_enemy.carrier ) && RandomInt(100) > 70 )
	{
		return false;	
	}

	if ( !IsDefined( flag_mine.carrier ) )
	{
		self AddGoal( flag_mine.curOrigin, CTF_GOAL_RADIUS, PRIORITY_URGENT, "ctf_flag" );
	}
	else
	{
		if ( !isDefined( self.chaseCarrier ) )
		{
			if ( randomInt(100) > 50 )
			{
				self.chaseCarrier = true;
			}
			else
			{
				self.chaseCarrier = false;
			}
		}
		if ( self.chaseCarrier && ( !flag_enemy isHome() || Distance2DSquared( self.origin, home_enemy) > 500 * 500 ) )
		{
			self AddGoal( flag_mine.curOrigin, CTF_GOAL_RADIUS, PRIORITY_URGENT, "ctf_flag" );			
		}
		else
		{
			self AddGoal( home_enemy, CTF_GOAL_RADIUS, PRIORITY_URGENT, "ctf_flag" );
		}
	}

	return true;
}