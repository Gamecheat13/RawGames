// _aircraft.gsc
// Sets up the behavior for the following aircraft:
//
// US:				Corsair, Avenger
// Japanese:	Betty Bomber, Zero, Zero "Rufe", Tenzan Torpedo Bomber, Mavis Flying Boat
// German:		Me-109, Stuka
// British:		Mosquito
// Russuan: 	IL-2
//
// Notes:		- Ask about splitting this up for various aircraft (what about sounds?)
//					- Make sure we get tags set up on each plane
//					- basing team on model kinda sucks but makes sense...
//					- people will need to pass in stuka for now

#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include common_scripts\utility;
main( model, type, max_turrets, build_bombs, non_default_turret_type )
{
	build_template( "stuka", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_usa_aircraft_f4ucorsair", "vehicle_usa_aircraft_f4ucorsair" );
	build_deathmodel( "vehicle_usa_aircraft_pel1_f4ucorsair", "vehicle_usa_aircraft_pel1_f4ucorsair" );
	build_deathmodel( "vehicle_usa_aircraft_f4ucorsair_dist", "vehicle_usa_aircraft_f4ucorsair_dist" );
	build_deathmodel( "vehicle_stuka_flying", "vehicle_stuka_flying" );
	build_deathmodel( "vehicle_p51_mustang", "vehicle_p51_mustang" );
	build_deathmodel( "vehicle_spitfire_flying", "vehicle_spitfire_flying" );
	build_deathmodel( "vehicle_rus_airplane_il2", "vehicle_rus_airplane_il2" );	
	build_deathmodel( "vehicle_jap_airplane_rufe_fly", "vehicle_jap_airplane_rufe_fly" );
	build_deathmodel( "vehicle_brt_aircraft_spitfire", "vehicle_brt_aircraft_spitfire" );
	build_deathmodel( "weapon_ger_panzershreck_rocket", "weapon_ger_panzershreck_rocket" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );  // TODO change to actual explosion fx/sound when we get it
	build_life( 99999, 5000, 15000 );
	build_treadfx();
	
	//build_rumble( "tank_rumble", 0.55, 1.75, 2200, 0.1, 0.1 );	// this works well for pel1, let Jesse know if it breaks your map
	//build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
			
	if (model == "vehicle_stuka_flying" || model == "vehicle_jap_airplane_rufe_fly")
	{
		build_team( "axis" );		
	}
	else
	{
		build_team( "allies" );		
	}

	// default is to build bombs since that's what everyone is used to3
	if (!isdefined(build_bombs) || build_bombs)
	{
		// Bomb stuff: TODO update with actual explosion fx, sound, and bomb model when we get them
		//  quakepower, quaketime, quakeradius, range, min_damage, max_damage
		maps\_planeweapons::build_bomb_explosions( type, 0.5, 2.0, 1024, 768, 400, 25 );
		maps\_planeweapons::build_bombs( type, "aircraft_bomb", "explosions/fx_mortarExp_dirt", "mortar_dirt" );
	}

	// turret stuff: TODO update with actual turret models and types when we get them
	if( IsDefined(non_default_turret_type ) )
	{
		//-- GLocke ( 8/6/08 ) : Added the ability to specify a specific turret that you want to be built so that you can get a different fx set
		turretType = non_default_turret_type;
	}
	else if( type == "corsair" )
	{
		turretType = "corsair_mg";	
	}
	else
	{
		turretType = "allied_coaxial_mg";	
	}

	turretModel = "weapon_machinegun_tiger";

	// MikeD (5/31/2008): Someone switched the tag names for the zero, so we now have to do a special case since it's too late
	// to change the model
	if( model == "vehicle_jap_airplane_zero_fly" )
	{
		build_turret( turretType, "tag_flash_gunner1", turretModel, true, undefined, undefined, undefined, undefined, max_turrets );
		build_turret( turretType, "tag_flash_gunner2", turretModel, true, undefined, undefined, undefined, undefined, max_turrets  );
	}
	else
	{
		build_turret( turretType, "tag_gunLeft", turretModel, true, undefined, undefined, undefined, undefined, max_turrets );
		build_turret( turretType, "tag_gunRight", turretModel, true, undefined, undefined, undefined, undefined, max_turrets  );
	}
	
	// end turret stuff
}

// When the vehicle spawns, it calls this function, so put vehicle-specific post-spawn stuff here.
// self = the vehicle
init_local()
{
	wait( 0.05 );  // wait a frame for the vehicle to spawn and get set up by _vehicle
	self thread maps\_mgturret::link_turrets( self.mgturret );  // make the turrets fire together
	
	if( IsDefined( self.script_numbombs ) && self.script_numbombs > 0 )
	{
		self thread maps\_planeweapons::bomb_init( self.script_numbombs );
	}
}
