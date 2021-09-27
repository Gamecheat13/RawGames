#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );

/*QUAKED script_vehicle_ac130_simple (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_ac130_simple::main( "vehicle_ac130_low",undefined, "script_vehicle_ac130_simple" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_ac130_simple

defaultmdl="vehicle_ac130_low"
default:"vehicletype" "ac130"
default:"script_team" "allies"
*/

// this version of the ac130 doesn't have any of the special stuff for the paris_ac130 level, so is lighter-weight.
// we're using it in paris_a as a source for the air support strobe bullets.

main( model, type, classname )
{
	template_level = get_template_level();
	simple = ( IsDefined( template_level ) && template_level == "paris_a" );

	build_template( "ac130", model, type, classname );
	
	build_localinit( ::init_local );
	
	build_team( "allies" );
	build_bulletshield( true );
	build_grenadeshield( true );
}

init_local()
{
}
