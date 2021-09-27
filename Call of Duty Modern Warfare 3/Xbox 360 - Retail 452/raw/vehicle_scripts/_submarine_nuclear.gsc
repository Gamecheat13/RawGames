#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );

main( model, type, classname )
{
	build_template( "submarine_nuclear", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_submarine_nuclear" );
	build_life( 999, 500, 1500 );
	build_team( "allies" );
}

init_local()
{
}



/*QUAKED script_vehicle_submarine_nuclear (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_submarine_nuclear::main( "vehicle_submarine_nuclear", undefined, "script_vehicle_submarine_nuclear" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_submarine_nuclear_submarine_nuclear


defaultmdl="vehicle_submarine_nuclear"
default:"vehicletype" "submarine_nuclear"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_russian_submarine (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_submarine_nuclear::main( "vehicle_russian_oscar2_sub", undefined, "script_vehicle_russian_submarine" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_russian_submarine


defaultmdl="vehicle_russian_oscar2_sub"
default:"vehicletype" "submarine_nuclear"
default:"script_team" "axis"
*/
