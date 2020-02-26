#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "apache", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_apache" );
	build_deathmodel( "vehicle_apache_dark" );
	
	build_drive( %bh_rotors, undefined, 0 );
	
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explosions/large_vehicle_explosion" );

	build_life( 999, 500, 1500 );
	build_compassicon( "helicopter", false );
	build_treadfx();


	build_team( "allies" );

}

init_local()
{
	self.script_badplace = false;// All helicopters dont need to create bad places
}

set_vehicle_anims( positions )
{

	return positions;
}


#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	for ( i = 0;i < 11;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].getout_delete = true;

	return positions;
}



/*QUAKED script_vehicle_apache (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

put this in your GSC:
maps\_apache::main( "vehicle_apache" );

and these lines in your CSV:
include,vehicle_apache_apache
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_apache"
default:"vehicletype" "apache"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_apache_dark (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

put this in your GSC:
maps\_apache::main( "vehicle_apache_dark" );

and these lines in your CSV:
include,vehicle_apache_dark_apache
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_apache_dark"
default:"vehicletype" "apache"
default:"script_team" "allies"
*/

