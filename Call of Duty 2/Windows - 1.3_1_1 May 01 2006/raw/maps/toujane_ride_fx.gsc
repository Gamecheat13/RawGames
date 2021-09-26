main()
{
	precacheFX();
	treadFX();
	exploderFX();
	spawnWorldFX();
}

precacheFX()
{
	level._effect["stuka_smoke"]					= loadfx ("fx/fire/fire_airplane_trail.efx");
	level._effect["building_break"]					= loadfx ("fx/dust/dust_impact_small.efx");
	level._effect["distant_explosions"]				= loadfx ("fx/explosions/tank_impact_libya.efx");
	level._effect["wall_tank_dust"]					= loadfx ("fx/dust/wall_tank_dust.efx");
	level._effect["dust_impact_med"]				= loadfx ("fx/dust/dust_impact_med.efx");
	level._effect["toujane_tunnel_collapse"]        = loadfx ("fx/dust/toujane_tunnel_collapse.efx");
	level._effect["tank_impact_dirt"]               = loadfx ("fx/explosions/tank_impact_libya.efx");
	level._effect["20mm_walldamage"]				= loadfx ("fx/explosions/20mm_wallexplode.efx");
	level._effect["armored car taken out"]			= loadfx ("fx/explosions/large_vehicle_explosion.efx");
	level._effect["stukaBomb"]						= loadfx ("fx/explosions/tank_impact_libya.efx");
	level._effect["mortar explosion"]				= loadfx("fx/explosions/tank_impact_libya.efx");
	level._effect["mortar building explosion"]		= loadfx("fx/explosions/tank_impact_libya.efx");
//	level._effect["20mil_inside"] 					= loadfx("fx/impact/20mil_concrete.efx");
	level._effect["dust_wind_brown"]				= loadfx ("fx/dust/dust_wind_brown.efx");
	level._effect["armoredcar_smoke"]				= loadfx ("fx/smoke/damaged_vehicle_smoke.efx");
}

treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	//armored car fx
	maps\_treadfx::setVehicleFX("armoredcar",	"water",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"dirt",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"asphalt",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"sand",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"gravel",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"plaster",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"rock",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"brick",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"concrete",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"foliage",	undefined);
	
	//panzer2 fx
	maps\_treadfx::setVehicleFX("panzer2",	"water",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"dirt",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"asphalt",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"sand",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"gravel",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"plaster",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"rock",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"brick",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"concrete",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"foliage",	undefined);

	//tiger fx
	maps\_treadfx::setVehicleFX("crusader",	"water",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"dirt",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("crusader",	"asphalt",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("crusader",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"sand",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("crusader",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"gravel",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("crusader",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"plaster",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("crusader",	"rock",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("crusader",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"foliage",	undefined);
	
	//GermanFordTruck FX
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"water",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"dirt",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"asphalt",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"sand",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"gravel",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"plaster",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"rock",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"foliage",	undefined);
	
	//Opel Blitz FX
	maps\_treadfx::setVehicleFX("blitz",	"water",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"sand",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("blitz",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"plaster",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("blitz",	"rock",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("blitz",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	undefined);

	//Kubelwagon FX
	maps\_treadfx::setVehicleFX("Kubelwagon",	"water",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"dirt",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"asphalt",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"sand",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"gravel",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"plaster",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"rock",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"foliage",	undefined);
	
	//Jeep
	maps\_treadfx::setVehicleFX("jeep",	"water",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"dirt",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("jeep",	"asphalt",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("jeep",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"sand",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("jeep",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"gravel",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("jeep",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"plaster",	"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("jeep",	"rock",		"fx/dust/tread_dust_toujane_ride.efx");
	maps\_treadfx::setVehicleFX("jeep",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"foliage",	undefined);
}

exploderFX()
{	
	//Tank drives through Wall	
	maps\_fx::exploderfx(0, "wall_tank_dust", (-1592,7916,89), 0, (-1620,7940,100));
	maps\_fx::exploderfx(0, "dust_impact_med", (-1592,7916,6), 1.25, (-1620,7940,10));
	
	//Tunnel Collapse
	maps\_fx::exploderfx(1, "tank_impact_dirt", (1194,3889,124), 0, (1194,3887,224));
	maps\_fx::exploderfx(1, "tank_impact_dirt", (954,3999,-16), 0.8, (910,4003,73));
	maps\_fx::exploderfx(1, "toujane_tunnel_collapse", (1048,3977,-6), 1.00, (1048,3977,3));

	//Bomb takes out armored car
	maps\_fx::exploderfx(6, "armored car taken out", (3279, 3380, -41), 4, (3279, 3380, -41));
	
	//Random explosions seen while defending the starting point of the level
	level.RandomExploderIndex_Start = 7;
	maps\_fx::exploderfx(7, "distant_explosions", (964,7072,476), 0, (964,7072,476));
	maps\_fx::exploderfx(8, "distant_explosions", (-120,7304,352), 0, (-120,7304,352));
	maps\_fx::exploderfx(9, "distant_explosions", (-656, 9328, 232), 0, (-656, 9328, 232));
	maps\_fx::exploderfx(10, "distant_explosions", (-1936, 6880, 496), 0, (-1936, 6880, 496));
	level.RandomExploderIndex_End = 10;
}

spawnWorldFX()
{
	//Ground Dust
	maps\_fx::loopfx("dust_wind_brown", (80,2008,32), 0.3, (80,2008,132));
	maps\_fx::loopfx("dust_wind_brown", (1592,1976,40), 0.3, (1592,1976,140));
	maps\_fx::loopfx("dust_wind_brown", (3450,2084,10), 0.3, (3450,2084,110));
	maps\_fx::loopfx("dust_wind_brown", (4007,3102,15), 0.3, (4007,3102,115));
	maps\_fx::loopfx("dust_wind_brown", (3703,3845,2), 0.3, (3703,3845,102));
	maps\_fx::loopfx("dust_wind_brown", (2491,4231,42), 0.3, (2491,4231,142));
	maps\_fx::loopfx("dust_wind_brown", (2899,4849,134), 0.3, (2899,4849,234));
	maps\_fx::loopfx("dust_wind_brown", (1988,4769,224), 0.3, (1988,4769,324));
	maps\_fx::loopfx("dust_wind_brown", (3172,4385,38), 0.3, (3172,4385,138));
	maps\_fx::loopfx("dust_wind_brown", (3172,4385,38), 0.3, (3172,4385,138));
	maps\_fx::loopfx("dust_wind_brown", (2394,3819,26), 0.3, (2394,3819,126));
	maps\_fx::loopfx("dust_wind_brown", (1253,5256,200), 0.3, (1253,5256,300));
	maps\_fx::loopfx("dust_wind_brown", (1113,4350,200), 0.3, (1113,4350,300));
	maps\_fx::loopfx("dust_wind_brown", (9,4750,91), 0.3, (9,4750,191));
	maps\_fx::loopfx("dust_wind_brown", (-110,4046,56), 0.3, (-110,4046,156));
	maps\_fx::loopfx("dust_wind_brown", (-649,5109,112), 0.3, (-649,5109,212));
	maps\_fx::loopfx("dust_wind_brown", (-1293,6091,156), 0.3, (-1293,6091,256));
	maps\_fx::loopfx("dust_wind_brown", (-1962,6185,139), 0.3, (-1962,6185,239));
	maps\_fx::loopfx("dust_wind_brown", (-1366,7844,187), 0.3, (-1366,7844,287));
	maps\_fx::loopfx("dust_wind_brown", (-12,8620,116), 0.3, (-12,8620,216));
	maps\_fx::loopfx("dust_wind_brown", (509,7974,144), 0.3, (509,7974,244));
	maps\_fx::loopfx("dust_wind_brown", (662,6891,220), 0.3, (662,6891,320));
	maps\_fx::loopfx("dust_wind_brown", (-760,4398,96), 0.3, (-760,4398,196));
	maps\_fx::loopfx("dust_wind_brown", (-1764,4514,108), 0.3, (-1764,4514,208));
	maps\_fx::loopfx("dust_wind_brown", (-1662,5060,108), 0.3, (-1662,5060,208));
	maps\_fx::loopfx("dust_wind_brown", (-1791,6858,187), 0.3, (-1791,6858,287));
	maps\_fx::loopfx("dust_wind_brown", (-643,5931,208), 0.3, (-643,5931,308));
	maps\_fx::loopfx("dust_wind_brown", (39,5818,152), 0.3, (39,5818,252));
	maps\_fx::loopfx("dust_wind_brown", (1215,6661,265), 0.3, (1215,6661,365));
	maps\_fx::loopfx("dust_wind_brown", (2500,7124,199), 0.3, (2500,7124,299));
	maps\_fx::loopfx("dust_wind_brown", (2634,6367,199), 0.3, (2634,6367,299));
	maps\_fx::loopfx("dust_wind_brown", (853,673,11), 0.3, (853,673,111));
	maps\_fx::loopfx("dust_wind_brown", (-858,945,27), 0.3, (-858,945,127));
	maps\_fx::loopfx("dust_wind_brown", (801,-48,11), 0.3, (801,-48,111));
	maps\_fx::loopfx("dust_wind_brown", (-901,226,11), 0.3, (-901,226,111));
	maps\_fx::loopfx("dust_wind_brown", (2356,8231,74), 0.3, (2356,8231,174));
	maps\_fx::loopfx("dust_wind_brown", (2337,7676,127), 0.3, (2337,7676,227));
	maps\_fx::loopfx("dust_wind_brown", (2389,8881,80), 0.3, (2389,8881,180));
	maps\_fx::loopfx("dust_wind_brown", (1610,9183,101), 0.3, (1610,9183,201));
	maps\_fx::loopfx("dust_wind_brown", (842,8769,116), 0.3, (842,8769,216));
	maps\_fx::loopfx("dust_wind_brown", (1269,8809,75), 0.3, (1269,8809,175));
	maps\_fx::loopfx("dust_wind_brown", (1249,8177,65), 0.3, (1249,8177,165));

}