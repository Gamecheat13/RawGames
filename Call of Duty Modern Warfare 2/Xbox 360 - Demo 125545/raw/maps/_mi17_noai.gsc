
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, no_death )
{
	//SNDFILE=vehicle_mi17
	build_template( "mi17_noai", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_mi17_woodland" ); // RADNAME = _noai
	build_deathmodel( "vehicle_mi17_woodland_fly" );// RADNAME = _noai
	build_deathmodel( "vehicle_mi17_woodland_fly_cheap" );// RADNAME = _noai

	if ( !isdefined( no_death ) )
	{
		mi17_death_fx = [];
		mi17_death_fx[ "vehicle_mi17_woodland" ] = "explosions/helicopter_explosion_mi17_woodland";
		mi17_death_fx[ "vehicle_mi17_woodland_fly" ] = "explosions/helicopter_explosion_mi17_woodland_low";
		mi17_death_fx[ "vehicle_mi17_woodland_fly_cheap" ] = "explosions/helicopter_explosion_mi17_woodland_low";
		mi17_death_fx[ "vehicle_mi-28_flying" ] = "explosions/helicopter_explosion_mi17_woodland_low";

		build_deathfx( "fire/fire_smoke_trail_L", 			"tag_engine_right", 	"mi17_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
		build_deathfx( "explosions/aerial_explosion", 		"tag_engine_right", "mi17_helicopter_secondary_exp", 				undefined, 			undefined, 		undefined, 		2.5, 		true );
		build_deathfx( "explosions/aerial_explosion", 		"tag_deathfx", 		"mi17_helicopter_secondary_exp", 		 		undefined, 			undefined, 		undefined, 		4.0 );
		build_deathfx( mi17_death_fx[ model ], 		 					undefined, 			"mi17_helicopter_crash", 			undefined, 			undefined, 		undefined, 		 - 1, 		undefined, 	"stop_crash_loop_sound" );
	}
	else
	{
		assertex( no_death, "No_death must be undefined or true" );
	}

	build_drive( %mi17_heli_rotors, undefined, 0 );
	build_deathfx( "explosions/grenadeexp_default", 	"tag_engine_left", 	"mi17_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.2, 		true );
	build_deathfx( "explosions/grenadeexp_default", 	"tag_engine_right", 	"mi17_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.5, 		true );

	build_treadfx();
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "axis" );

	randomStartDelay = randomfloatrange( 0, 1 );
	build_light( model, "cockpit_blue_cargo01", 	"tag_light_cargo01", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
	build_light( model, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 	"interior", 	0.1 );
	build_light( model, "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 	randomStartDelay );
	build_light( model, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_red_blink", 		"running", 	randomStartDelay );
	build_light( model, "wingtip_green", 			"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 	randomStartDelay );
	build_light( model, "wingtip_red", 				"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 	randomStartDelay );
}

init_local()
{
//	self.originheightoffset = 116;  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );// TODO - FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.fastropeoffset = 710;// TODO - FIXME: this is ugly. If only there were a getanimendorigin() command
	self.script_badplace = false;// All helicopters dont need to create bad places

	maps\_vehicle::lights_on( "running" );
	maps\_vehicle::lights_on( "interior" );
}


/*QUAKED script_vehicle_mi17_woodland_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

put this in your GSC:
maps\_mi17_noai::main( "vehicle_mi17_woodland" );

and these lines in your CSV:
include,vehicle_mi17_woodland_mi17_noai
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_woodland"
default:"vehicletype" "mi17_noai"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_mi17_woodland_fly_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

put this in your GSC:
maps\_mi17_noai::main( "vehicle_mi17_woodland_fly" );

and these lines in your CSV:
include,vehicle_mi17_woodland_fly_mi17_noai
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_woodland_fly"
default:"vehicletype" "mi17_noai"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_mi17_woodland_fly_cheap_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

put this in your GSC:
maps\_mi17_noai::main( "vehicle_mi17_woodland_fly_cheap" );

and these lines in your CSV:
include,vehicle_mi17_woodland_fly_cheap_mi17_noai
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_woodland_fly_cheap"
default:"vehicletype" "mi17_noai"
default:"script_team" "axis"
*/