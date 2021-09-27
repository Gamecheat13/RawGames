#include maps\_vehicle;
#include maps\_vehicle_aianim;

#using_animtree( "vehicles" );
main( model, type, classname )
{
    build_template( "sas_van", model, type, classname );
    build_localinit( ::init_local );
    build_deathmodel( model, "vehicle_van_sas_dark_destroyed" );
	
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
	positions[ 1 ].vehicle_getoutanim = %uaz_rear_driver_exit_into_run_door;
	positions[ 2 ].vehicle_getoutanim = %london_sas_van_evac_door;
	positions[ 2 ].vehicle_getoutanim_clear = false;

	positions[ 0 ].vehicle_getinanim = %humvee_mount_frontL_door;
	positions[ 1 ].vehicle_getinanim = %humvee_mount_frontR_door;

	positions[ 0 ].vehicle_getoutsound = "sas_van_door_open";
	positions[ 1 ].vehicle_getoutsound = "sas_van_door_open";

	positions[ 0 ].vehicle_getinsound = "sas_vandoor_close";
	positions[ 1 ].vehicle_getinsound = "sas_van_door_close";

	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0;i < 6;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";
	positions[ 2 ].sittag = "tag_guy1";
	positions[ 3 ].sittag = "tag_guy2";
	positions[ 4 ].sittag = "tag_guy3";
	positions[ 5 ].sittag = "tag_guy4";

	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 0 ].idle = %technical_driver_idle;
	positions[ 1 ].idle = %technical_passenger_idle;
	positions[ 2 ].idle = %london_sas_van_evac_idle_01;
	positions[ 3 ].idle = %london_sas_van_evac_idle_02;
	positions[ 4 ].idle = %london_sas_van_evac_idle_03;
	positions[ 5 ].idle = %london_sas_van_evac_idle_04;

	positions[ 0 ].getout = %pickup_driver_climb_out;
	positions[ 1 ].getout = %pickup_passenger_climb_out;
	positions[ 2 ].getout = %london_sas_van_evac_01;
	positions[ 3 ].getout = %london_sas_van_evac_02;
	positions[ 4 ].getout = %london_sas_van_evac_03;
	positions[ 5 ].getout = %london_sas_van_evac_04;

	positions[ 0 ].getin = %pickup_driver_climb_in;
	positions[ 1 ].getin = %pickup_passenger_climb_in;
	
	return positions;
}

/*QUAKED script_vehicle_sas_van (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_sas_van::main( "vehicle_van_sas_dark_silver", undefined, "script_vehicle_sas_van_physics" );


These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_sas_van
sound,vehicle_sas_van,vehicle_standard,all_sp


defaultmdl="vehicle_van_sas_dark_silver"
default:"vehicletype" "sas_van"
*/ 

/*QUAKED script_vehicle_sas_van_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_sas_van::main( "vehicle_van_sas_dark_silver", "sas_van_physics", "script_vehicle_sas_van_physics" );


These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_sas_van
sound,vehicle_sas_van,vehicle_standard,all_sp


defaultmdl="vehicle_van_sas_dark_silver"
default:"vehicletype" "sas_van_physics"
*/ 