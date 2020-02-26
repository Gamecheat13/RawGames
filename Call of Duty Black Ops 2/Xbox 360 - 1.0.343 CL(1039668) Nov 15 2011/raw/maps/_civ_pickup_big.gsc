#include maps\_vehicle;
main()
{
	if( IsSubStr( self.vehicletype, "wturret" ) )
	{
		build_aianims( ::set_50cal_gunner_anims , ::set_50cal_vehicle_anims );
	}	
	else
	{
		build_aianims( ::setanims , ::set_vehicle_anims );
	}

	build_unload_groups( ::unload_groups );
}

#using_animtree( "vehicles" );
set_50cal_vehicle_anims( positions )
{
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_gunner1";
	
	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	
	positions[ 0 ].vehicle_getoutanim = %v_crew_future_truck_left_frontdoor_open;
	positions[ 1 ].vehicle_getoutanim = %v_crew_future_truck_right_frontdoor_open;

	return positions;
}


#using_animtree( "generic_human" );
set_50cal_gunner_anims()
{
	positions = [];
	const num_positions = 3;
	
	for( i = 0; i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}
	
	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger";	
	positions[2].sittag = "tag_gunner1";
	positions[2].vehiclegunner = 1;
	
	positions[2].idle 	 = %ai_50cal_gunner_aim;
	positions[2].aimup 	 = %ai_50cal_gunner_aim_up;
	positions[2].aimdown = %ai_50cal_gunner_aim_down;
	
	positions[ 0 ].getout = %ai_crew_future_truck_driver_exit;
	positions[ 1 ].getout = %ai_crew_future_truck_passenger_exit;
	
	positions[ 0 ].idle = %ai_crew_future_truck_driver_idle;
	positions[ 1 ].idle = %ai_crew_future_truck_passenger_idle;
	
	return positions;
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	
	positions[ 2 ].sittag = "tag_passenger1";
	positions[ 3 ].sittag = "tag_passenger2";
	positions[ 4 ].sittag = "tag_passenger3";
	positions[ 5 ].sittag = "tag_passenger4";

	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	
	positions[ 0 ].vehicle_getoutanim = %v_crew_future_truck_left_frontdoor_open;  // driver
	positions[ 1 ].vehicle_getoutanim = %v_crew_future_truck_right_frontdoor_open; // passenger
	
	positions[ 2 ].vehicle_getoutanim = %v_crew_future_truck_right_backdoor_open;  // passenger 1
	positions[ 3 ].vehicle_getoutanim = %v_crew_future_truck_left_backdoor_open;  // passenger 2

	return positions;
}

#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	const num_positions = 6;
	
	for( i = 0; i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_passenger1";
	positions[ 3 ].sittag = "tag_passenger2";
	positions[ 4 ].sittag = "tag_passenger3";
	positions[ 5 ].sittag = "tag_passenger4";
  
	positions[ 0 ].getout = %ai_crew_future_truck_driver_exit;
	positions[ 1 ].getout = %ai_crew_future_truck_passenger_exit;
	positions[ 2 ].getout = %ai_crew_future_truck_passenger1_exit;
	positions[ 3 ].getout = %ai_crew_future_truck_passenger2_exit;
	positions[ 4 ].getout = %ai_crew_future_truck_passenger3_exit;
	positions[ 5 ].getout = %ai_crew_future_truck_passenger4_exit;
	
	positions[ 0 ].idle = %ai_crew_future_truck_driver_idle;
	positions[ 1 ].idle = %ai_crew_future_truck_passenger_idle;
	positions[ 2 ].idle = %ai_crew_future_truck_passenger1_idle;
	positions[ 3 ].idle = %ai_crew_future_truck_passenger2_idle;
	positions[ 4 ].idle = %ai_crew_future_truck_passenger3_idle;
	positions[ 5 ].idle = %ai_crew_future_truck_passenger4_idle;

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	
	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;	
}