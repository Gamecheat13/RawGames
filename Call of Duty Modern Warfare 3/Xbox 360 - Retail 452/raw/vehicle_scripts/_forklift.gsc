#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "forklift", model, type, classname );
	build_localinit( ::init_local );
//	build_deathmodel( "vehicle_ambulance_swat" );
	build_radiusdamage( ( 0, 0, 32 ), 150, 200, 50, false );
	build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
	build_deathquake( 0.5, 0.5, 500 );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_aianims( ::setanims, ::set_vehicle_anims );
}

init_local()
{
}

set_vehicle_anims( positions )
{
	return positions;
}

#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0;i < 2;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "TAG_DRIVER";
	positions[ 0 ].idle = %uaz_driver_idle_drive;

	return positions;
}

/*QUAKED script_vehicle_forklift (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_forklift::main( "vehicle_forklift", undefined, "script_vehicle_forklift" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_forklift
sound,vehicle_forklift,vehicle_standard,all_sp

defaultmdl="vehicle_forklift"
default:"vehicletype" "forklift"
*/

/*QUAKED script_vehicle_forklift_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_forklift::main( "vehicle_forklift", "forklift_physics", "script_vehicle_forklift_physics" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_forklift
sound,vehicle_forklift,vehicle_standard,all_sp

defaultmdl="vehicle_forklift"
default:"vehicletype" "forklift_physics"
*/








