#include maps\_vehicle;

main()
{
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );
}

#using_animtree("vehicles");
set_vehicle_anims(positions)
{
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 

	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;

// 	positions[ 0 ].vehicle_getinanim = %v_gaz63_driver_door_open;
// 	positions[ 1 ].vehicle_getinanim = %v_gaz63_passenger_door_open;

	positions[ 0 ].vehicle_getoutanim = %v_police_driver_door_open;
	positions[ 1 ].vehicle_getoutanim = %v_police_passenger_door_open;
		
	return positions;
}

#using_animtree("generic_human");
setanims()
{
	positions = [];
	const num_positions = 2;

	for( i =0 ;i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 

	positions[ 0 ].getout = %crew_police_driver_climbout;
	positions[ 1 ].getout = %crew_police_passenger_climbout;

	positions[ 0 ].getout_combat = %crew_police_driver_climbout;
	positions[ 1 ].getout_combat = %crew_police_passenger_climbout;

	positions[ 0 ].idle = %crew_police_driver_idle;
	positions[ 1 ].idle = %crew_police_passenger_idle;

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "driver" ] = [];
	unload_groups[ "passenger" ] = [];	

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	
	group = "driver";		
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	
	group = "passenger";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	
	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}