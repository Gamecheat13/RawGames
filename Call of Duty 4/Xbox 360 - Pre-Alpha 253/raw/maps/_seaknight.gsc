#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	build_template( "seaknight", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_ch46e");

	build_deathfx( "explosions/large_vehicle_explosion",undefined,"explo_metal_rand");
	
	build_treadfx();

	build_life ( 999, 500, 1500 );
	
	build_team( "allies");
	
	build_light ( model, "cockpit_red_cargo02", 		"tag_light_cargo02", 	"misc/aircraft_light_cockpit_red",		"interior",	0.0 );
	build_light ( model, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue",		"interior",	0.1 );
	build_light ( model, "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_red_blink",		"running", 	0.0 );
	build_light ( model, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_red_blink",		"running", 	0.3 );
	build_light ( model, "wingtip_green1", 			"tag_light_L_wing1", 	"misc/aircraft_light_wingtip_green",	"running", 	0.0 );
	build_light ( model, "wingtip_green2", 			"tag_light_L_wing2", 	"misc/aircraft_light_wingtip_green",	"running", 	0.0 );
	build_light ( model, "wingtip_red1", 			"tag_light_R_wing1", 	"misc/aircraft_light_wingtip_red",		"running", 	0.2 );
	build_light ( model, "wingtip_red2", 			"tag_light_R_wing2", 	"misc/aircraft_light_wingtip_red",		"running", 	0.0 );
}

init_local()
{
	self.originheightoffset = 116;  //TODO-FIXME: this is ugly.
	self.fastropeoffset = 652; //TODO-FIXME: this is ugly.
	self.script_badplace = false; //All helicopters dont need to create bad places
}

set_vehicle_anims(positions)
{
	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<0;i++)
		positions[i] = spawnstruct();
//copy from _blackhawk when anims are rigged.
	return positions;

}



unload_groups()
{

}


set_attached_models()
{

}