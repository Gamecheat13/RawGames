#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include animscripts\utility;

#using_animtree ("vehicles");
main()
{
	build_aianims( ::setanims , ::set_vehicle_anims );
}

#using_animtree( "vehicles" );
set_vehicle_anims(positions)
{
	return positions;
}

#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	const num_positions = 1;
	
	for( i = 0; i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}
	
	positions[0].sittag    = "tag_driver";
	positions[0].idle[0] = %ai_crew_motorcycle_ride;
	positions[0].idle[1] = %ai_crew_motorcycle_ride_lookleft;
	positions[0].idle[2] = %ai_crew_motorcycle_ride_lookright;
	positions[0].idleoccurrence[ 0 ] = 1000;
	positions[0].idleoccurrence[ 1 ] = 400;
	positions[0].idleoccurrence[ 2 ] = 200;

	
	return positions;
}

