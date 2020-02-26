#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\traverse\zm_shared;

main()
{
	traverseState = "zm_traverse_barrier";
	traverseAlias = "barrier_walk";
	if ( self.has_legs )
	{
		switch ( self.zombie_move_speed )
		{
		case "walk":
			traverseAlias = "barrier_walk";
			break;
		case "run":
			traverseAlias = "barrier_run";
			break;
		case "sprint":
		case "super_sprint":
			traverseAlias = "barrier_sprint";
			break;
		default:
			if ( IsDefined( level.zm_mantle_over_40_move_speed_override ) )
			{
				traverseAlias = self [[ level.zm_mantle_over_40_move_speed_override ]]();
			}
			else
			{
				assertmsg( "Zombie move speed of '" + self.zombie_move_speed + "' is not supported for mantle_over_40." );
			}
		}
	}
	else
	{
		traverseState = "zm_traverse_barrier_crawl";
		traverseAlias = "barrier_crawl";
	}

	self DoTraverse( traverseState, traverseAlias );
}