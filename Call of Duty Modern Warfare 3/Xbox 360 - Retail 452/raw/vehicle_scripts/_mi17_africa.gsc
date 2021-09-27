
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	//SNDFILE=vehicle_mi17
	build_template( "mi17", model, type, classname );
	build_localinit( ::init_local );

	build_drive( %mi17_heli_rotors, undefined, 0 );

	build_treadfx();
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "axis" );
	
	build_bulletshield( true );

	randomStartDelay = randomfloatrange( 0, 1 );
	lightmodel = get_light_model( model, classname );
	build_light( lightmodel, "cockpit_blue_cargo01", 	"tag_light_cargo01", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
	build_light( lightmodel, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 	"interior", 	0.1 );
	build_light( lightmodel, "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 	randomStartDelay );
	build_light( lightmodel, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_red_blink", 		"running", 	randomStartDelay );
	build_light( lightmodel, "wingtip_green", 			"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 	randomStartDelay );
	build_light( lightmodel, "wingtip_red", 				"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 	randomStartDelay );
}

init_local()
{
	self.fastropeoffset = 710 + distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
	self.script_badplace = false;// All helicopters dont need to create bad places

	maps\_vehicle::lights_on( "running" );
	maps\_vehicle::lights_on( "interior" );
	
	// start with non-flying joints
	self HidePart( "main_rotor_jnt_blur" );
	self HidePart( "tail_rotor_jnt_blur" );
}


/*QUAKED script_vehicle_mi17_africa (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_mi17_africa::main( "vehicle_mi17_africa", undefined, "script_vehicle_mi17_africa" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_mi17_africa
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_africa"
default:"vehicletype" "mi17"
default:"script_team" "axis"
*/
