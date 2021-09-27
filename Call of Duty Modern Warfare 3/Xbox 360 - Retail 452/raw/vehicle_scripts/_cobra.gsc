#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	if( classname == "script_vehicle_cobra_helicopter_so" )
	{
		vehicle_type = "cobra_so";
	}
	else
	{
		vehicle_type = "cobra";
	}
	build_template( vehicle_type, model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_cobra_helicopter", "vehicle_cobra_helicopter" );
	build_deathmodel( "vehicle_cobra_helicopter_low" );
	build_deathmodel( "vehicle_cobra_helicopter_fly" );
	build_deathmodel( "vehicle_cobra_helicopter_fly_low" );
	build_drive( %bh_rotors, undefined, 0, 3.0 );

	cobra_death_fx = [];
	cobra_death_fx[ "vehicle_cobra_helicopter" ] = "explosions/large_vehicle_explosion";
	cobra_death_fx[ "vehicle_cobra_helicopter_low" ] = "explosions/large_vehicle_explosion";
	cobra_death_fx[ "vehicle_cobra_helicopter_fly" ] = "explosions/large_vehicle_explosion";
	cobra_death_fx[ "vehicle_cobra_helicopter_fly_low" ] = "explosions/large_vehicle_explosion";

	build_deathfx( "explosions/grenadeexp_default", 	"tag_engine_left", 	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.2, 		true );
	build_deathfx( "explosions/grenadeexp_default", 	"tail_rotor_jnt", 	"hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.5, 		true );
	build_deathfx( "fire/fire_smoke_trail_L", 			"tail_rotor_jnt", 	"hind_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
	build_deathfx( "explosions/aerial_explosion", 		"tag_engine_right", "hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	build_deathfx( "explosions/aerial_explosion", 		"tag_deathfx", 		"hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		4.0 );
 	build_deathfx( cobra_death_fx[ model ], 		 	undefined, 			"hind_helicopter_crash", 			undefined, 			undefined, 		undefined, 		 - 1, 		undefined, 	"stop_crash_loop_sound" );

	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_mainturret();
	

	randomStartDelay = randomfloatrange( 0, 1 );
	lightmodel = get_light_model( model, classname );

	build_light( lightmodel, "wingtip_green", 			"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 		randomStartDelay );
	build_light( lightmodel, "wingtip_red", 				"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 		randomStartDelay );
	build_light( lightmodel, "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 		randomStartDelay );
	build_light( lightmodel, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_white_blink", 		"running", 		randomStartDelay );
	build_aianims( ::setanims, ::set_vehicle_anims );
}

init_local()
{
	//self.delete_on_death = true;
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
	for ( i = 0;i < 2;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_pilot";
	positions[ 1 ].sittag = "tag_gunner";

	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 1 ].bHasGunWhileRiding = false;


	positions[ 0 ].idle[ 0 ] = %helicopter_pilot1_idle;
	positions[ 0 ].idle[ 1 ] = %helicopter_pilot1_twitch_clickpannel;
	positions[ 0 ].idle[ 2 ] = %helicopter_pilot1_twitch_lookback;
	positions[ 0 ].idle[ 3 ] = %helicopter_pilot1_twitch_lookoutside;
	positions[ 0 ].idleoccurrence[ 0 ] = 500;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;
	positions[ 0 ].idleoccurrence[ 2 ] = 100;
	positions[ 0 ].idleoccurrence[ 3 ] = 100;

	positions[ 1 ].idle[ 0 ] = %helicopter_pilot2_idle;
	positions[ 1 ].idle[ 1 ] = %helicopter_pilot2_twitch_clickpannel;
	positions[ 1 ].idle[ 2 ] = %helicopter_pilot2_twitch_lookoutside;
	positions[ 1 ].idle[ 3 ] = %helicopter_pilot2_twitch_radio;
	positions[ 1 ].idleoccurrence[ 0 ] = 450;
	positions[ 1 ].idleoccurrence[ 1 ] = 100;
	positions[ 1 ].idleoccurrence[ 2 ] = 100;
	positions[ 1 ].idleoccurrence[ 3 ] = 100;

	return positions;

// add generic helicopter pilot anims
// - helicopter_pilot1_idle
// - helicopter_pilot1_twitch_clickpannel
// - helicopter_pilot1_twitch_lookback
// - helicopter_pilot1_twitch_lookoutside
// - helicopter_pilot2_idle
// - helicopter_pilot2_twitch_clickpannel
// - helicopter_pilot2_twitch_lookoutside
// - helicopter_pilot2_twitch_radio
// - adjust mi17 / mi24 / mi28 / cobra tag for new anims	
}

/*QUAKED script_vehicle_cobra_helicopter (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cobra::main( "vehicle_cobra_helicopter", undefined, "script_vehicle_cobra_helicopter"  );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_cobra_helicopter_cobra
sound,vehicle_cobra,vehicle_standard,all_sp


defaultmdl="vehicle_cobra_helicopter"
default:"vehicletype" "cobra"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_cobra_helicopter_fly (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cobra::main( "vehicle_cobra_helicopter_fly", undefined, "script_vehicle_cobra_helicopter_fly" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_cobra_helicopter_fly_cobra
sound,vehicle_cobra,vehicle_standard,all_sp


defaultmdl="vehicle_cobra_helicopter_fly"
default:"vehicletype" "cobra"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_cobra_helicopter_fly_low (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cobra::main( "vehicle_cobra_helicopter_fly_low", undefined, "script_vehicle_cobra_helicopter_fly_low" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_cobra_helicopter_fly_low_cobra
sound,vehicle_cobra,vehicle_standard,all_sp


defaultmdl="vehicle_cobra_helicopter_fly_low"
default:"vehicletype" "cobra"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_cobra_helicopter_low (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cobra::main( "vehicle_cobra_helicopter_low", undefined, "script_vehicle_cobra_helicopter_low" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_cobra_helicopter_low_cobra
sound,vehicle_cobra,vehicle_standard,all_sp


defaultmdl="vehicle_cobra_helicopter_low"
default:"vehicletype" "cobra"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_cobra_helicopter_so (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cobra::main( "vehicle_cobra_helicopter", undefined, "script_vehicle_cobra_helicopter_so"  );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_cobra_helicopter_cobra
sound,vehicle_cobra,vehicle_standard,all_sp


defaultmdl="vehicle_cobra_helicopter"
default:"vehicletype" "cobra_so"
default:"script_team" "allies"
*/