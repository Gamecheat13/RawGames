#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );

main( model, type, classname )
{
	//SNDFILE=vehicle_abrams
	build_template( "leopard_2a7", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_leopard_2a7", "vehicle_leopard_2a7_d" );
	build_shoot_shock( "tankblast" );
	build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	build_exhaust( "distortion/leopard_2a7_exhaust_cheap" );
	build_deckdust( "dust/abrams_deck_dust" );
	build_treadfx();
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "exp_armor_vehicle" );
	build_turret( "m1a1_coaxial_mg", "tag_coax_mg", "vehicle_m1a1_abrams_PKT_Coaxial_MG" );
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 900, 1, 1 );
	build_team( "allies" );
	build_mainturret();
	build_aianims( ::setanims, ::set_vehicle_anims );
	build_frontarmor( .33 );// regens this much of the damage from attacks to the front
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
	for ( i = 0;i < 11;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].getout_delete = true;


	return positions;
}


/*QUAKED script_vehicle_leopard_2a7 (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_leopard_2a7::main( "vehicle_leopard_2a7", undefined, "script_vehicle_leopard_2a7" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_2a7_leopard_2a7
sound,vehicle_abrams,vehicle_standard,all_sp


defaultmdl="vehicle_leopard_2a7"
default:"vehicletype" "leopard_2a7"
default:"script_team" "allies"
*/
