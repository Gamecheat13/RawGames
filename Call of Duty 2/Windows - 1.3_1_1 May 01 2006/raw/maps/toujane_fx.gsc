main()
{
	precacheFX();
	spawnWorldFX();
	
	maps\_treadfx::setVehicleFX("crusader",	"brick",	"fx/dust/tread_dust_brown.efx");
	maps\_treadfx::setVehicleFX("tiger",	"brick",	"fx/dust/tread_dust_brown.efx");
}

precacheFX()
{
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("plaster",		loadfx ("fx/impacts/footstep_dust_brown.efx"));

	//Ambient FX
	level._effect["med_oil_fire"]				= loadfx ("fx/fire/med_oil_fire.efx");
	level._effect["dust_wind_brown"]			= loadfx ("fx/dust/dust_wind_brown.efx");
	level._effect["wall_tank_dust"]				= loadfx ("fx/dust/wall_tank_dust.efx");
	level._effect["dust_impact_med"]			= loadfx ("fx/dust/dust_impact_med.efx");
	level._effect["smoke_plumeBG_toujane"]		= loadfx ("fx/smoke/smoke_plumeBG_toujane.efx");
	level._effect["thin_light_smoke_S"]			= loadfx ("fx/smoke/thin_light_smoke_S.efx");
	level._effect["dust_impact_16ftladder"]		= loadfx ("fx/dust/dust_impact_16ftladder.efx");
	level._effect["dust_impact_small"]			= loadfx ("fx/dust/dust_impact_small.efx");
	level._effect["ground_fire_med"]			= loadfx ("fx/fire/ground_fire_med.efx");
			
	//Tank drives through Wall	
	maps\_fx::exploderfx(0, "wall_tank_dust", (-455,2967,89), 0, (-376,3027,100));
	maps\_fx::exploderfx(0, "dust_impact_med", (-350,3032,6), 1.25, (-354,3030,106));
	
	//Ladder falls
	maps\_fx::exploderfx(1, "dust_impact_small", (2293,2577,94), 0.667, (2222,2571,164));
	maps\_fx::exploderfx(1, "dust_impact_16ftladder", (2242,2589,66), 1.13, (2204,2682,66));
	
	//AI land on hay
	maps\_fx::exploderfx(2, "dust_impact_small", (2912,2046,104), 0, (2912,2046,110));	
}

spawnWorldFX()
{
	
	//Fire and smoke
	maps\_fx::loopfx("ground_fire_med", (1875,2571,66), 2, (1936,2548,141));
	
	//background smoke
	maps\_fx::loopfx("smoke_plumeBG_toujane", (-7488,1084,10), 1, (-7488,1084,110));
	maps\_fx::loopfx("smoke_plumeBG_toujane", (5290,3491,-56), 1, (5307,3501,41));
	maps\_fx::loopfx("smoke_plumeBG_toujane", (-4141,7172,-192), 1, (-4123,7182,-94));
	maps\_fx::loopfx("smoke_plumeBG_toujane", (863,10730,215), 1, (880,10740,313));

	
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
	maps\_fx::loopfx("dust_wind_brown", (1012,8540,116), 0.3, (1012,8540,216));
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
	
	thread maps\_utility::loopfxSound ("medfire", (1907,2284,54));
}