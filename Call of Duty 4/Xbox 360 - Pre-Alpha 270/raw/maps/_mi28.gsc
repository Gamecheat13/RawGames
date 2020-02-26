#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "mi28", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_mi-28_flying" );
	
//	build_drive( %bh_rotors, undefined, 0 );
	
	blackhawk_death_fx =( "explosions/helicopter_explosion" );


//	build_deathfx( "explosions/grenadeexp_default" , 		"tag_engine_left", 	"blackhawk_helicopter_hit", 		undefined, 			undefined, 		undefined, 		0.2, 		true );
//	build_deathfx( "explosions/grenadeexp_default" , 		"elevator_jnt", 		"blackhawk_helicopter_hit", 		undefined, 			undefined, 		undefined, 		0.5, 		true );
//	build_deathfx( "fire/fire_smoke_trail_L" , 			"elevator_jnt", 		"blackhawk_helicopter_dying_loop", 	true, 				0.05, 			true, 			0.5, 		true );
//	build_deathfx( "explosions/aerial_explosion" , 		"tag_engine_right", "blackhawk_helicopter_hit", 		undefined, 			undefined, 		undefined, 		2.5, 		true );
//	build_deathfx( "explosions/aerial_explosion" , 		"tag_deathfx", 		"blackhawk_helicopter_hit", 		undefined, 			undefined, 		undefined, 		4.0 );
//	build_deathfx( blackhawk_death_fx, 							undefined, 			"blackhawk_helicopter_crash", 		undefined, 			undefined, 		undefined, 		-1, 		undefined, 	"stop_crash_loop_sound" );
	
//	build_predeathfx( "explosions/aerial_explosion", 		"tag_deathfx", 		"blackhawk_helicopter_hit" );
//	build_predeathfx( "fire/fire_smoke_trail_L", 			"tag_body", 		"blackhawk_helicopter_dying_loop", 	true, 				0.05, 			true, 			0.5, 		true );
	
	build_treadfx();

	build_life( 999, 500, 1500 );

	build_team( "allies" );
	
//	build_aianims( ::setanims , ::set_vehicle_anims );
	
//	build_attach_models( ::set_attached_models );

//	build_unload_groups( ::Unload_Groups );

//	build_light( model, "cockpit_blue_cargo01", 	"tag_light_cargo01", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
//	build_light( model, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 		"interior", 	0.0 );
//	build_light( model, "white_blink", 			"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 	0.0 );
//	build_light( model, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_white_blink", 		"running", 	0.3 );
//	build_light( model, "wingtip_green", 			"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 	0.0 );
//	build_light( model, "wingtip_red", 			"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 	0.0 );

}

init_local()
{
	self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.fastropeoffset = 762; //TODO-FIXME: this is ugly. If only there were a getanimendorigin() command
	
	self.script_badplace = false; //All helicopters dont need to create bad places
	//maps\_vehicle::lights_on( "running" );
	//maps\_vehicle::lights_on( "interior" ); 
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
//	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	
	for( i=0;i<positions.size;i++ )
		positions[ i ].vehicle_getoutanim = %bh_idle;

	return positions;
}

#using_animtree( "fastrope" );

setplayer_anims( positions )
{
	
/*
	positions[ 3 ].player_idle = %bh_player_idle;
	positions[ 3 ].player_getout_sound = "fastrope_start_plr";
	positions[ 3 ].player_getout_sound_loop = "fastrope_loop_plr";
	positions[ 3 ].player_getout_sound_end = "fastrope_end_plr";

	positions[ 3 ].player_getout = %bh_player_drop;
	positions[ 3 ].player_animtree = #animtree;
	*/
	
	return positions;
}

#using_animtree( "generic_human" );

setanims()
{
	
	positions = [];

	return setplayer_anims( positions );                           
}                                             

