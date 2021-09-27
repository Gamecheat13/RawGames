#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "london_cab", model, type, classname );
	build_localinit( ::init_local );
	build_destructible( "vehicle_london_cab_black_destructible", "vehicle_london_cab_black" );
	build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
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

	positions = [];
	positions[ 0 ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";

	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 0 ].idle = %technical_driver_idle;

	return positions;
}


/*QUAKED script_vehicle_london_cab_black (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_london_cab::main( "vehicle_london_cab_black_destructible", undefined, "script_vehicle_london_cab_black" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_london_cab_black
sound,vehicle_car_exp,vehicle_standard,all_sp
sound,vehicle_80s_car,vehicle_standard,all_sp


defaultmdl="vehicle_london_cab_black_destructible"
default:"vehicletype" "london_cab"
default:"script_team" "allies"
*/
