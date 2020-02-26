// Load some basic FX to play around with.
precacheFX()
{
	// For level._effect["X"]s, X can be whatever makes sense to the scritper. 
	// The loadfx() call needs to point to a valid effect, however.
	level._effect["large_vehicle_explosion"]	= loadfx ("explosions/large_vehicle_explosion");
//	level._effect["fuel_med_explosion"]		= loadfx ("explosions/fuel_med_explosion");
//	level._effect["mortarExp_water"]		= loadfx ("explosions/mortarExp_water");
//	level._effect["hind_explosion"]			= loadfx ("explosions/hind_explosion");
//	level._effect["fire_paperBurn"]			= loadfx ("fire/fire_paperBurn");
//	level._effect["firelp_small_pm"]		= loadfx ("fire/firelp_small_pm");
//	level._effect["firelp_vhc_lrg_pm_farview"]	= loadfx ("fire/firelp_vhc_lrg_pm_farview");
//	level._effect["smoke_plumeBG"]			= loadfx ("smoke/smoke_plumeBG");
//	level._effect["smoke_geotrail_hellfire"]	= loadfx ("smoke/smoke_geotrail_hellfire");
	
	level._effect["grenadeExp_dirt"]	= loadfx ("explosions/grenadeExp_dirt");
	
	level.mortar = LoadFx( "explosions/fx_mortarExp_dirt" );
	
}