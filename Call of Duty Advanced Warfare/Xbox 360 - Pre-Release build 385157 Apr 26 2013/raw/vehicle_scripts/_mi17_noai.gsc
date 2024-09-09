
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "mi17_noai", model, type, classname );
	build_localinit( ::init_local );
				  //   model 						      deathmodel   
	build_deathmodel( "vehicle_mi17_woodland" );		   //RADNAME		   = _noai
	build_deathmodel( "vehicle_mi17_woodland_fly" );		   //RADNAME	   = _noai
	build_deathmodel( "vehicle_mi17_woodland_fly_cheap" );			 //RADNAME = _noai
	build_deathmodel( "vehicle_mi17_woodland_landing" );		   //RADNAME   = _noai

	mi17_death_fx									   = [];
	mi17_death_fx[ "vehicle_mi17_woodland"			 ] = "fx/explosions/helicopter_explosion_mi17_woodland";
	mi17_death_fx[ "vehicle_mi17_woodland_fly"		 ] = "fx/explosions/helicopter_explosion_mi17_woodland_low";
	mi17_death_fx[ "vehicle_mi17_woodland_fly_cheap" ] = "fx/explosions/helicopter_explosion_mi17_woodland_low";
	mi17_death_fx[ "vehicle_mi17_woodland_landing"	 ] = "fx/explosions/helicopter_explosion_mi17_woodland_low";
	mi17_death_fx[ "vehicle_mi-28_flying"			 ] = "fx/explosions/helicopter_explosion_mi17_woodland_low";
	deathfxmodel = mi17_death_fx[ model ];
	
			   //   effect 						   tag 				   sound 						    bEffectLooping    delay      bSoundlooping    waitDelay    stayontag    notifyString 		    
	build_deathfx( "fx/fire/fire_smoke_trail_L"	, "tag_engine_right", "mi17_helicopter_dying_loop"	 , true			   , 0.05	  , true		   , 0.5		, true		 , undefined );
	build_deathfx( "fx/explosions/aerial_explosion", "tag_engine_right", "mi17_helicopter_secondary_exp", undefined	   , undefined, undefined	   , 2.5		, true		 , undefined );
	build_deathfx( "fx/explosions/aerial_explosion", "tag_deathfx"		, "mi17_helicopter_secondary_exp", undefined	   , undefined, undefined	   , 4.0		, undefined	 , undefined );
	build_deathfx( deathfxmodel					, undefined			, "mi17_helicopter_crash"		 , undefined	   , undefined, undefined	   , - 1		, undefined	 , "stop_crash_loop_sound" );

	build_drive( %mi17_heli_rotors, undefined, 0 );
			   //   effect 						     tag 			     sound 				    bEffectLooping    delay      bSoundlooping    waitDelay    stayontag   
	build_deathfx( "fx/explosions/grenadeexp_default", "tag_engine_left" , "mi17_helicopter_impact_explo_3d", undefined	   , undefined, undefined	   , 0.2		, true );
	build_deathfx( "fx/explosions/grenadeexp_default", "tag_engine_right", undefined, undefined	   , undefined, undefined	   , 0.5		, true );

	build_treadfx();
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "axis" );
	
	build_bulletshield( true );

	randomStartDelay = RandomFloatRange( 0, 1 );
			 //   model      name 					   tag 				      effect 							   group 	   delay 		    
	build_light( classname, "cockpit_blue_cargo01"	, "tag_light_cargo01"  , "fx/misc/aircraft_light_cockpit_red"	, "interior", 0.0 );
	build_light( classname, "cockpit_blue_cockpit01", "tag_light_cockpit01", "fx/misc/aircraft_light_cockpit_blue" , "interior", 0.1 );
	build_light( classname, "white_blink"			, "tag_light_belly"	   , "fx/misc/aircraft_light_white_blink"	, "running" , randomStartDelay );
	build_light( classname, "white_blink_tail"		, "tag_light_tail"	   , "fx/misc/aircraft_light_red_blink"	, "running" , randomStartDelay );
	build_light( classname, "wingtip_green"			, "tag_light_L_wing"   , "fx/misc/aircraft_light_wingtip_green", "running" , randomStartDelay );
	build_light( classname, "wingtip_red"			, "tag_light_R_wing"   , "fx/misc/aircraft_light_wingtip_red"	, "running" , randomStartDelay );
	build_is_helicopter();
}

init_local()
{
//	self.originheightoffset = 116;  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.originheightoffset = Distance( self GetTagOrigin( "tag_origin" ), self GetTagOrigin( "tag_ground" ) ); // TODO - FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.fastropeoffset		= 710;	//TODO - FIXME: this is ugly. If only there were a getanimendorigin() command
	self.script_badplace	= false;//All helicopters dont need to create bad places

	maps\_vehicle::vehicle_lights_on( "running" );
	maps\_vehicle::vehicle_lights_on( "interior" );
}

/*QUAKED script_vehicle_mi17_woodland_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_mi17_noai::main( "vehicle_mi17_woodland", undefined, "script_vehicle_mi17_woodland_noai" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_mi17_woodland_mi17_noai
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_woodland"
default:"vehicletype" "mi17_noai"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_mi17_woodland_fly_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_mi17_noai::main( "vehicle_mi17_woodland_fly", undefined, "script_vehicle_mi17_woodland_fly_noai" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_mi17_woodland_fly_mi17_noai
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_woodland_fly"
default:"vehicletype" "mi17_noai"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_mi17_woodland_fly_cheap_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_mi17_noai::main( "vehicle_mi17_woodland_fly_cheap", undefined, "script_vehicle_mi17_woodland_fly_cheap_noai" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_mi17_woodland_fly_cheap_mi17_noai
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_woodland_fly_cheap"
default:"vehicletype" "mi17_noai"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_mi17_woodland_landing_noai (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_mi17_noai::main( "vehicle_mi17_woodland_landing", undefined, "script_vehicle_mi17_woodland_landing_noai" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_mi17_woodland_landing_mi17_noai
sound,vehicle_mi17,vehicle_standard,all_sp


defaultmdl="vehicle_mi17_woodland_fly"
default:"vehicletype" "mi17_noai"
default:"script_team" "axis"
*/