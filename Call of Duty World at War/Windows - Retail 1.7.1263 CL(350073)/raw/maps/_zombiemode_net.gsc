#include maps\_utility; 

init()
{
	level.zombie_network_num_spawns = 0;
	level.zombie_network_max_spawns = 2;

	level thread network_spawn_monitor();
}


network_safe_spawn( classname, origin )
{
	while( !network_ok_to_spawn() )
	{
		wait( 0.05 );		
	}

	level.zombie_network_num_spawns++;
	
	return Spawn( classname, origin );
}


network_ok_to_spawn()
{
	return( level.zombie_network_num_spawns < level.zombie_network_max_spawns );
}


network_spawn_monitor()
{
	while( 1 )
	{
		wait_network_frame();
		wait_network_frame();
		level.zombie_network_num_spawns = 0;
	}
}