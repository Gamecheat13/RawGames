main()
{
	precacheFX();
	spawnWorldFX();
	
	maps\_treadfx::setVehicleFX("crusader",	"dirt",	"fx/dust/tread_dust_libya.efx");
	maps\_treadfx::setVehicleFX("crusader",	"rock",	"fx/dust/tread_dust_libya.efx");

	maps\_treadfx::setVehicleFX("tiger", "dirt",	"fx/dust/tread_dust_libya.efx");
	maps\_treadfx::setVehicleFX("tiger", "rock",	"fx/dust/tread_dust_libya.efx");
	
}

precacheFX()
{
	level._effect["libya_camera_dust"]		= loadfx ("fx/dust/libya_camera_dust.efx");
	level._effect["libya_dust_kickup"]		= loadfx ("fx/dust/tank_dust_blowback_libya.efx");
//	level._effect["rideinmortar"]		= loadfx ("fx/explosions/artilleryExp_dirt_brown.efx");
	level._effect["rideinmortar"]		= loadfx ("fx/explosions/tank_impact_libya.efx");


	//panzer explosion, fire and smoke override
	level.deathfx["xmodel/vehicle_panzer_ii"]							= loadfx ("fx/explosions/tank_explosion_libya.efx");
	level._effect["xmodel/vehicle_panzer_ii"+"tank_fire_turret"] 		= loadfx ("fx/fire/tank_fire_libya_distant.efx");
	level.damagefiretag["xmodel/vehicle_panzer_ii"] = [];

	//cruisader explosion, fire and smoke override
	level.deathfx["xmodel/vehicle_vehicle_crusader2"]							= loadfx ("fx/explosions/tank_explosion_libya.efx");
	level._effect["xmodel/vehicle_crusader2"+"tank_fire_turret"] 		= loadfx ("fx/fire/tank_fire_libya_distant.efx");
	level.damagefiretag["xmodel/vehicle_crusader2"] = [];
			
	//sherman explosion, fire and smoke override
	level.deathfx["xmodel/vehicle_american_sherman"]							= loadfx ("fx/explosions/tank_explosion_libya.efx");
	level._effect["xmodel/vehicle_american_sherman"+"tank_fire_turret"] 		= loadfx ("fx/fire/tank_fire_libya_distant.efx");
	level.damagefiretag["xmodel/vehicle_american_sherman"] = [];
			
}

spawnWorldFX()
{
	if(getcvarint("scr_88ridge_fxlevel") >=1)
	{
		maps\_fx::loopfx("libya_camera_dust", (-628,27149,-100), 0.3, (-628,27149,-90));
		maps\_fx::loopfx("libya_camera_dust", (-7306,-21705,-100), 0.3, (-7306,-21705,-90));
		maps\_fx::loopfx("libya_camera_dust", (-2357,5769,-320), 0.3, (-2357,5769,-310));
		maps\_fx::loopfx("libya_camera_dust", (-43641,3120,198), 0.3, (-43641,3120,208));
		maps\_fx::loopfx("libya_camera_dust", (-41995,22450,198), 0.3, (-41995,22450,208));
	}
}