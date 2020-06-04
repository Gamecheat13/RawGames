// Cleaned up by: SRS (05/02/07)
// STUKA TODO: need final assets for turrets & bombs (models, fx, sounds, turretinfo)

#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include common_scripts\utility;
main( model, type )
{	
	// set up the vehicle. (see _vehicle for nicely commented explanations of these functions.)
	build_template( "stuka", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_stuka_flying", "vehicle_stuka_flying" );  // TODO change to actual deathmodel when we get it
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );  // TODO change to actual explosion fx/sound when we get it
	build_life( 99999, 5000, 15000 );
	build_team( "axis" );
	//build_treadfx();
	// Bomb stuff: TODO update with actual explosion fx, sound, and bomb model when we get them
	//  quakepower, quaketime, quakeradius, range, min_damage, max_damage
	maps\_planeweapons::build_bomb_explosions( level.vttype, 0.5, 2.0, 1024, 768, 400, 25 );
	maps\_planeweapons::build_bombs( level.vttype, "aircraft_bomb", "explosions/fx_mortarExp_dirt", "artillery_explosion" );
	
	// turret stuff: TODO update with actual turret models and types when we get them
	turretType = "stuka_mg";
	turretModel = "weapon_machinegun_tiger";
	build_turret( turretType, "tag_gunLeft", turretModel, true );
	build_turret( turretType, "tag_gunRight", turretModel, true );
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
