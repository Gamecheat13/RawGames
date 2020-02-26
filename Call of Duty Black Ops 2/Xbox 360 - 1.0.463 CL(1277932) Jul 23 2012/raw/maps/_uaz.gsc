#include maps\_vehicle;

#using_animtree( "vehicles" );
main( )
{
	//build_radiusdamage( (0,0,32) , 300, 200, 100, false );

	self build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );

	build_aianims( ::setanims , ::set_vehicle_anims );
	
	build_unload_groups( ::unload_groups );
}

#using_animtree ("vehicles");
set_vehicle_anims( positions )
{          
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_passenger2";
	positions[ 3 ].sittag = "tag_passenger3";
	
	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;

	positions[ 0 ].vehicle_getinanim = %v_uaz_driver_door_open;
	positions[ 1 ].vehicle_getinanim = %v_uaz_passenger_door_open;
	positions[ 2 ].vehicle_getinanim = %v_uaz_passenger2_door_open;
	positions[ 3 ].vehicle_getinanim = %v_uaz_passenger3_door_open;

	positions[ 0 ].vehicle_getoutanim = %v_uaz_driver_door_open;
	positions[ 1 ].vehicle_getoutanim = %v_uaz_passenger_door_open;
	positions[ 2 ].vehicle_getoutanim = %v_uaz_passenger2_door_open;
	positions[ 3 ].vehicle_getoutanim = %v_uaz_passenger3_door_open;

	return positions;               
}

#using_animtree( "generic_human" );                                        
setanims()                              
{
	positions = [];
	const num_positions = 4;
	
	for( i =0 ;i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}
                                        
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";
	positions[ 2 ].sittag = "tag_passenger2"; //driver_side_rear
	positions[ 3 ].sittag = "tag_passenger3";  //passenger_side_rear

	positions[ 0 ].idle = %crew_uaz_driver_idle;
	positions[ 1 ].idle = %crew_uaz_passenger1_idle;
	positions[ 2 ].idle = %crew_uaz_passenger2_idle;
	positions[ 3 ].idle = %crew_uaz_passenger3_idle;
	
	positions[ 0 ].getout = %crew_uaz_driver_climbout;
	positions[ 1 ].getout = %crew_uaz_passenger1_climbout;
	positions[ 2 ].getout = %crew_uaz_passenger2_climbout;
	positions[ 3 ].getout = %crew_uaz_passenger3_climbout;
	
	positions[ 0 ].getin = %uaz_driver_enter_from_huntedrun;
	positions[ 1 ].getin = %uaz_passenger_enter_from_huntedrun;
	positions[ 2 ].getin = %uaz_passenger_enter_from_huntedrun;
	positions[ 3 ].getin = %uaz_passenger_enter_from_huntedrun;
	
	positions[0].getout_fast = %crew_uaz_driver_tumbleout;
	positions[1].getout_fast = %crew_uaz_passenger1_tumbleout;
	positions[2].getout_fast = %crew_uaz_passenger3_tumbleout;
	positions[3].getout_fast = %crew_uaz_passenger3_tumbleout;		

	return positions;  
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "driver" ] = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "rear_passengers" ] = [];
	
	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	
	group = "driver";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	
	group = "passengers";		
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;

	group = "rear_passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;	
	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}