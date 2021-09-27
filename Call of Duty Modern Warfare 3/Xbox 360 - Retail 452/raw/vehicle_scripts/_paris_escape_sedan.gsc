#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "paris_escape_sedan", model, type, classname );
	build_localinit( ::init_local );
	
	// removed because these are temp and using memory
	//build_deathmodel( "vehicle_paris_escape_sedan", "vehicle_luxurysedan_destroy" );
	//build_deathmodel( "vehicle_luxurysedan_test", "vehicle_luxurysedan_destroy" );
	//build_deathmodel( "vehicle_luxurysedan_2009_viewmodel", "vehicle_luxurysedan_2009_viewmodel" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	
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

	for ( i = 0;i < 1;i++ )
		positions[ i ] = spawnstruct();
	positions[ 0 ].sittag = "tag_driver";
	positions[ 0 ].idle = %coup_driver_idle;

	return positions;
}

/*QUAKED script_vehicle_paris_escape_sedan (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_paris_escape_sedan::main( "vehicle_paris_escape_sedan", undefined, "script_vehicle_paris_escape_sedan" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_paris_escape_sedan
sound,vehicle_paris_escape_sedan,vehicle_standard,all_sp


defaultmdl="vehicle_paris_escape_sedan"
default:"vehicletype" "paris_escape_sedan"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_paris_escape_sedan_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_paris_escape_sedan::main( "vehicle_paris_escape_sedan", "paris_escape_sedan_physics", "script_vehicle_paris_escape_sedan_physics" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_paris_escape_sedan
sound,vehicle_paris_escape_sedan,vehicle_standard,all_sp


defaultmdl="vehicle_paris_escape_sedan"
default:"vehicletype" "paris_escape_sedan_physics"
default:"script_team" "allies"
*/
