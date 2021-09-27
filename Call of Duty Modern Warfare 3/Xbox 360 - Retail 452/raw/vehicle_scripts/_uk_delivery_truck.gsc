#include maps\_vehicle;
#include maps\_vehicle_aianim;

#using_animtree( "vehicles" );
main( model, type, classname )
{
    build_template( "uk_delivery_truck", model, type, classname );
    build_localinit( ::init_local );
    build_deathmodel( model, "vehicle_uk_delivery_truck_destroyed" );
	
	build_deathfx( "explosions/large_vehicle_explosion", 	undefined, 				"car_explode", 						undefined, 			undefined, 		undefined, 		0 );      
    
    build_radiusdamage( ( 0, 0, 32 ), 300, 200, 100, false );
    build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
   
    build_deathquake( 1, 1.6, 500 );
    build_treadfx();
    build_life( 999, 500, 1500 );
    build_team( "axis" );
    
	anim_func = ::setanims;			
	build_aianims( anim_func, ::set_vehicle_anims );
}

init_local()
{
}

unload_groups()
{
	unload_groups = [];

	group = "passengers";
	unload_groups[ group ] = [];
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;

	group = "all";
	unload_groups[ group ] = [];
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;

	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	positions[ 0 ].vehicle_getoutanim = %uaz_driver_exit_into_run_door;
	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim = %innocent_truck_exit_passenger_fwd_truck;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 0 ].vehicle_getinanim = %humvee_mount_frontL_door;
	positions[ 1 ].vehicle_getinanim = %humvee_mount_frontR_door;

	positions[ 0 ].vehicle_getoutsound = "ukdelivery_door_open";
	positions[ 1 ].vehicle_getoutsound = "ukdelivery_door_open";

	positions[ 0 ].vehicle_getinsound = "ukdelivery_door_close";
	positions[ 1 ].vehicle_getinsound = "ukdelivery_door_close";

	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0;i < 4;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";

	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 0 ].idle = %technical_driver_idle;
	positions[ 1 ].idle = %technical_passenger_idle;

	positions[ 0 ].getout = %pickup_passenger_climb_out;
	positions[ 1 ].getout = %innocent_truck_exit_passenger_fwd;

	positions[ 0 ].getin = %pickup_driver_climb_in;
	positions[ 1 ].getin = %pickup_passenger_climb_in;
	
	return positions;
}

/*QUAKED script_vehicle_uk_delivery_truck (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_uk_delivery_truck::main( "vehicle_uk_delivery_truck", undefined, "script_vehicle_uk_delivery_truck" );


These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_uk_delivery_truck
sound,vehicle_uk_delivery_truck,vehicle_standard,all_sp


defaultmdl="vehicle_uk_delivery_truck"
default:"vehicletype" "uk_delivery_truck"
*/ 

/*QUAKED script_vehicle_uk_delivery_truck_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_uk_delivery_truck::main( "vehicle_uk_delivery_truck", "uk_delivery_truck_physics", "script_vehicle_uk_delivery_truck_physics" );


These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_uk_delivery_truck
sound,vehicle_uk_delivery_truck,vehicle_standard,all_sp


defaultmdl="vehicle_uk_delivery_truck"
default:"vehicletype" "uk_delivery_truck_physics"
*/ 

/*QUAKED script_vehicle_uk_delivery_truck_flir_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_uk_delivery_truck::main( "vehicle_uk_delivery_truck_flir", "uk_delivery_truck_physics", "script_vehicle_uk_delivery_truck_flir_physics" );


These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_uk_delivery_truck_flir
sound,vehicle_uk_delivery_truck,vehicle_standard,all_sp


defaultmdl="vehicle_uk_delivery_truck_flir"
default:"vehicletype" "uk_delivery_truck_physics"
*/ 