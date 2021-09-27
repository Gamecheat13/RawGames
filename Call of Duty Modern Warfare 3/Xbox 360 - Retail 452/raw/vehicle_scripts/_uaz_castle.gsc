#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );


main( model, type, classname )
{
	vehicle_scripts\_uaz::main(model, type, classname);	
	build_destructible( "vehicle_uaz_open_player_ride", "vehicle_uaz_open" );

	//some specific anim overrides
	level.vehicle_aianims[ classname ] = setoverrideanims( classname );
	build_drive( %castle_truck_escape_drive_idle_truck, %uaz_driving_idle_backward,10);
		
}

#using_animtree( "generic_human" );
setoverrideanims(classname)
{
	positions = level.vehicle_aianims[ classname ];
	

	positions[ 0 ].getin = %castle_truck_escape_mount_price;
	positions[ 0 ].idle = %castle_truck_escape_drive_idle_price;
	

	setoverridevehicleanims(positions);
	
	return positions;	
}

#using_animtree( "vehicles" );
setoverridevehicleanims(positions)
{
		positions[ 0 ].vehicle_getinanim = %castle_truck_escape_mount_truck;
}


/*QUAKED script_vehicle_uaz_castle (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_uaz_castle::main( "vehicle_uaz_open_player_ride", "uaz", "script_vehicle_uaz_castle" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_uaz_castle
sound,vehicle_car_exp,vehicle_standard,all_sp
sound,vehicle_uaz,vehicle_standard,all_sp

defaultmdl="vehicle_uaz_open_player_ride"
default:"vehicletype" "uaz"
*/
