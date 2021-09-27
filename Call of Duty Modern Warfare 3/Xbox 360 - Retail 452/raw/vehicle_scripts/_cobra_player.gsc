#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "cobra_player", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_cobra_helicopter" );
	build_deathmodel( "vehicle_cobra_helicopter_fly" );

	// this doesn't happen very much but it's a nicer cleaner format than the case statement.
	cobra_death_fx = [];
	cobra_death_fx[ "vehicle_cobra_helicopter" ] 			 = "explosions/helicopter_explosion_hind_desert";
	cobra_death_fx[ "vehicle_cobra_helicopter_fly" ] 	 = "explosions/helicopter_explosion_hind_desert";

	build_deathfx( "explosions/grenadeexp_default", 	"tag_engine_left", 	"hind_helicopter_hit", 						undefined, 			undefined, 		undefined, 		0.2, 		true );
	build_deathfx( "explosions/grenadeexp_default", 	"tail_rotor_jnt", 	"hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.5, 		true );
	build_deathfx( "fire/fire_smoke_trail_L", 				"tail_rotor_jnt", 	"hind_helicopter_dying_loop", 		true, 					0.05, 				true, 				0.5, 		true );
	build_deathfx( "explosions/aerial_explosion", 		"tag_engine_right", "hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	build_deathfx( "explosions/aerial_explosion", 		"tag_deathfx", 			"hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		4.0 );
	build_deathfx( cobra_death_fx[ model ], 		 			undefined, 					"hind_helicopter_crash", 					undefined, 			undefined, 		undefined, 		 - 1, 		undefined, 	"stop_crash_loop_sound" );

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
}

init_local()
{
	self.delete_on_death = true;
	self.script_badplace = false;// All helicopters dont need to create bad places
}

/*QUAKED script_vehicle_cobra_helicopter_player (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cobra_player::main( "vehicle_cobra_helicopter", undefined, "script_vehicle_cobra_helicopter_player" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_cobra_helicopter_cobra
sound,vehicle_cobra,vehicle_standard,all_sp


defaultmdl="vehicle_cobra_helicopter"
default:"vehicletype" "cobra_player"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_cobra_helicopter_fly_player (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cobra_player::main( "vehicle_cobra_helicopter_fly", undefined, "script_vehicle_cobra_helicopter_fly_player" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_cobra_helicopter_fly_cobra
sound,vehicle_cobra,vehicle_standard,all_sp


defaultmdl="vehicle_cobra_helicopter_fly"
default:"vehicletype" "cobra_player"
default:"script_team" "allies"
*/