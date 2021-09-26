main()
{

	precacheFX();
	vehicleFXoverride();
	spawnWorldFX();

}

precacheFX()
{
	level._effect["artillery_indicator"]		= loadfx("fx/misc/flare_artillery_runner.efx");
	level._effect["artillery"] 					= loadfx("fx/explosions/tank_impact_night.efx");
	level._effect["wallchunk"] 					= loadfx ("fx/explosions/tank_impact_night.efx");
	level._effect["sandbagblast"] 				= loadfx ("fx/explosions/sandbag_explosion.efx");
	level._effect["wall_impact_chimney"] 		= loadfx ("fx/explosions/tank_impact_night.efx");
	level.scr_sound["wallsound"] 				= "mortar_explosion";
	level._effect["carrier_blowup"] 			= loadfx ("fx/explosions/flak88_explosion.efx");
	level._effect["spotlight_decoytown"] 		= loadfx ("fx/misc/spotlight_decoytown.efx");
	level._effect["lighthaze_decoytown"] 		= loadfx ("fx/misc/lighthaze_decoytown.efx");

}

vehicleFXoverride()
{
	//tread Fx override
	maps\_treadfx::setVehicleFX("crusader",	"water",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"foliage",	undefined);
	
	maps\_treadfx::setVehicleFX("blitz",	"water",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	undefined);

	maps\_treadfx::setVehicleFX("panzer2",	"water",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"foliage",	undefined);

	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"water",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"foliage",	undefined);

	maps\_treadfx::setVehicleFX("unicarrier",	"water",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"foliage",	undefined);


	//panzer explosion, fire and smoke override
	level._effect["xmodel/vehicle_panzer_ii"+"tank_fire_turret"]		= loadfx ("fx/explosions/large_vehicle_explosion.efx");
	level._effect["xmodel/vehicle_panzer_ii"+"tank_fire_turret"] 		= loadfx ("fx/fire/tank_fire_night_distant.efx");
	//level._effect["xmodel/vehicle_panzer_ii"+"damaged_vehicle_smoke"] 	= loadfx ("fx/smoke/damaged_vehicle_smoke.efx"); 
	//level._effect["xmodel/vehicle_panzer_ii"+"tank_fire_engine"] 		= loadfx ("fx/fire/tank_fire_engine.efx");
	level.damagefiretag["xmodel/vehicle_panzer_ii"] = [];

}


spawnWorldFX()
{
	maps\_fx::loopfx("lighthaze_decoytown", (1392,-4677,381), 4, (1392,-4677,281));
	maps\_fx::loopfx("lighthaze_decoytown", (1442,-3584,415), 4, (1442,-3584,315));
	maps\_fx::loopfx("lighthaze_decoytown", (473,-2956,412), 4, (473,-2956,312));
	maps\_fx::loopfx("spotlight_decoytown", (1957,-4584,134), 3, (2042,-4638,129));
	maps\_fx::loopfx("spotlight_decoytown", (1529,-5537,65), 3, (1580,-5623,63));

}