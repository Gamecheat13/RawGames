#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "pavelow_noai", model, type, classname );
		
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_pavelow" );

			   //   effect 											   tag 				   sound 							   bEffectLooping    delay 	    bSoundlooping    waitDelay    stayontag    notifyString 		   
	build_deathfx( "fx/explosions/helicopter_explosion_secondary_small", "tag_engine_left" , "pavelow_helicopter_secondary_exp", undefined		  , undefined, undefined	  , 0.0		   , true		, undefined );
	build_deathfx( "fx/fire/fire_smoke_trail_L"						, "tag_engine_left" , "pavelow_helicopter_dying_loop"	, true			  , 0.05	 , true			  , 0.5		   , true		, undefined );
	build_deathfx( "fx/explosions/helicopter_explosion_secondary_small", "tag_engine_right", "pavelow_helicopter_secondary_exp", undefined		  , undefined, undefined	  , 2.5		   , true		, undefined );
	build_deathfx( "fx/explosions/helicopter_explosion_pavelow"		, undefined			, "pavelow_helicopter_crash"		, undefined		  , undefined, undefined	  , - 1		   , undefined	, "stop_crash_loop_sound" );
	
	//Death by Rocket effects, explodes immediatly
	build_rocket_deathfx( "fx/explosions/aerial_explosion_pavelow_mp", 	"tag_deathfx", 	"pavelow_helicopter_crash",	undefined, 			undefined, 		undefined, 		 undefined, true, 	undefined, 0 );


	build_treadfx();

	build_life( 999, 500, 1500 );

	build_team( "allies" );

	build_drive( %bh_rotors, undefined, 0 );

			 //   model      name 					   tag 				      effect 							   group 	   delay   
	build_light( classname, "cockpit_red_cargo02"	, "tag_light_cargo02"  , "fx/misc/aircraft_light_cockpit_red"	, "interior", 0.0 );
	build_light( classname, "cockpit_blue_cockpit01", "tag_light_cockpit01", "fx/misc/aircraft_light_cockpit_blue" , "interior", 0.1 );
	build_light( classname, "white_blink"			, "tag_light_belly"	   , "fx/misc/aircraft_light_white_blink"	, "running" , 0.15 );
	build_light( classname, "wingtip_green1"		, "tag_light_L_wing1"  , "fx/misc/aircraft_light_wingtip_green", "running" , 0.3 );
	build_light( classname, "wingtip_red1"			, "tag_light_R_wing1"  , "fx/misc/aircraft_light_wingtip_red"	, "running" , 0.2 );
	build_light( classname, "solid_tail"			, "tag_light_tail2"	   , "fx/misc/aircraft_light_wingtip_red"	, "running" , 0.25 );
	build_light( classname, "white_blink_tail"		, "tag_light_tail"	   , "fx/misc/aircraft_light_red_blink"	, "running" , 0.05 );
	build_is_helicopter();

}

init_local()
{
	self.originheightoffset = Distance( self GetTagOrigin( "tag_origin" ), self GetTagOrigin( "tag_ground" ) );
	self.script_badplace	= false;// All helicopters dont need to create bad places
	thread maps\_vehicle::vehicle_lights_on( "running" );

}

/*QUAKED script_vehicle_pavelow_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_pavelow_noai::main( "vehicle_pavelow", undefined, "script_vehicle_pavelow_noai" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pavelow_noai
sound,vehicle_pavelow,vehicle_standard,all_sp

defaultmdl="vehicle_pavelow"
default:"vehicletype" "pavelow_noai"
default:"script_team" "allies"
*/