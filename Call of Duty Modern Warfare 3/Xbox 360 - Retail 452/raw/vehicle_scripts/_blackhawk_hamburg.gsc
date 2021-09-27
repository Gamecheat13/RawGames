#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );


main( model, type, classname )
{
	build_template( "blackhawk", model, type, classname );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_blackhawk_hero_hamburg" );

	build_drive( %bh_rotors, undefined, 0 );

	blackhawk_death_fx = [];
	blackhawk_death_fx[ "vehicle_blackhawk_hero_hamburg" ] 		 	= "explosions/large_vehicle_explosion";
	

	build_deathfx( "explosions/helicopter_explosion_secondary_small", 		"tag_engine_left", 		"blackhawk_helicopter_hit", 			undefined, 			undefined, 		undefined, 		0.2, 		true );
	build_deathfx( "explosions/helicopter_explosion_secondary_small", 		"elevator_jnt", 		"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.5, 		true );
	build_deathfx( "fire/fire_smoke_trail_L", 								"elevator_jnt", 		"blackhawk_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
	build_deathfx( "explosions/helicopter_explosion_secondary_small", 		"tag_engine_right", 	"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	build_deathfx( "explosions/helicopter_explosion_secondary_small", 		"tag_deathfx", 			"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		4.0 );
	build_deathfx( blackhawk_death_fx[ model ], 								undefined, 			"blackhawk_helicopter_crash", 			undefined, 			undefined, 		undefined, 		 - 1, 		undefined, 	"stop_crash_loop_sound" );

	build_rocket_deathfx( "explosions/aerial_explosion_heli_large", 	"tag_deathfx", 	"blackhawk_helicopter_crash",undefined, 			undefined, 		undefined, 		 undefined, true, 	undefined, 0  );

	build_treadfx();

	build_life( 999, 500, 1500 );

	build_team( "allies" );

	// Hamburg only
	if ( model == "vehicle_blackhawk_hero_hamburg" && level.script == "hamburg" )
	{
		build_rumble( "chopper_ride_rumble", 0.15, 4.5, 600, 1, 1 );
	}

	build_aianims( ::setanims, vehicle_scripts\_littlebird::set_vehicle_anims );

	build_unload_groups( vehicle_scripts\_littlebird::unload_Groups );

    build_bulletshield( true );

	randomStartDelay = randomfloatrange( 0, 1 );
	lightmodel = get_light_model( model, classname );
	build_light( lightmodel, "cockpit_blue_cargo01", 	"tag_light_cargo01", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
	build_light( lightmodel, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 	"interior", 	0.0 );
	build_light( lightmodel, "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 		randomStartDelay );
	build_light( lightmodel, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_white_blink", 		"running", 		randomStartDelay );
	build_light( lightmodel, "wingtip_green", 			"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 		randomStartDelay );
	build_light( lightmodel, "wingtip_red", 				"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 		randomStartDelay );
	build_light( lightmodel, "wingtip_red", 				"tag_engine_left", 	"fire/heli_engine_exhaust", 		"exhaust", 		randomStartDelay );
	build_light( lightmodel, "wingtip_red", 				"tag_engine_left", 	"fire/heli_engine_exhaust", 		"exhaust", 		randomStartDelay );

}

setanims()
{
	positions = vehicle_scripts\_littlebird::setanims();
	positions[ 5 ].sittag = "tag_body";
	positions[ 5 ].sittag = "tag_detach_left_offset";
	return positions;
}

init_local()
{
	self.script_badplace = false;// All helicopters dont need to create bad places
	maps\_vehicle::lights_on( "running" );
	maps\_vehicle::lights_on( "interior" ); 
	maps\_vehicle::lights_on( "exhaust" ); 
	self thread littlebird_landing();
}


/*QUAKED script_vehicle_blackhawk_hero_hamburg (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_blackhawk_hamburg::main( "vehicle_blackhawk_hero_hamburg", undefined, "script_vehicle_blackhawk_hero_hamburg" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_blackhawk_hero_hamburg
sound,vehicle_blackhawk,vehicle_standard,all_sp

defaultmdl="vehicle_blackhawk_hero_hamburg"
default:"vehicletype" "blackhawk"
default:"script_team" "allies"
*/