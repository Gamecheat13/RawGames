main()
{
	precacheFX();
	ambientFX();
	exploderFX();
	randomSnowWind();
	treadFX();
}	

precacheFX()
{
	level._effect["giant_smoke_plumeBG"]	= loadfx ("fx/smoke/smoke_plumeBG");
	level._effect["med_oil_fire"]			= loadfx ("fx/fire/med_oil_fire.efx");
	level._effect["thin_black_smoke_M"]		= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["thin_light_smoke_M"]		= loadfx ("fx/smoke/thin_light_smoke_M.efx");
	level._effect["orange_smoke_40sec"]		= loadfx ("fx/smoke/orange_smoke_40sec.efx");
	level._effect["cold_breath"]			= loadfx ("fx/misc/cold_breath.efx");
	level._effect["helmet_hit"]				= loadfx ("fx/impacts/small_metalhit.efx");

	level._effect["tank_fire_engine"] 		= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["building_fire_small"]	= loadfx ("fx/fire/building_fire_small.efx");
	level._effect["tank_fire_night"] 		= loadfx ("fx/fire/tank_fire_night_distant.efx");

	level._effect["snow_wind_cityhall"]			= loadfx ("fx/misc/snow_wind_cityhall.efx");
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");

}


ambientFX()
{
	//smoke plumes
	maps\_fx::loopfx("med_oil_fire", (3432,3433,9), 2, (3432,3433,109));
	maps\_fx::loopfx("med_oil_fire", (3284,9492,57), 2, (3284,9492,157));
	maps\_fx::loopfx("giant_smoke_plumeBG", (6418,489,447), 1.5, (6418,489,547));
	maps\_fx::loopfx("giant_smoke_plumeBG", (7487,16482,1020), 1.5, (7487,16482,1120));
	maps\_fx::loopfx("giant_smoke_plumeBG", (10911,12634,831), 1.5, (10911,12634,931));
	maps\_fx::loopfx("thin_black_smoke_M", (-214,8182,45), 0.6, (-214,8182,145));
	maps\_fx::loopfx("thin_black_smoke_M", (1560,3147,52), 0.6, (1560,3147,152));
	maps\_fx::loopfx("thin_black_smoke_M", (-67,1572,48), 0.6, (-67,1572,148));
	
	maps\_fx::loopfx("building_fire_small", (2504,4015,195), 2, (2504,4015,295));
	maps\_fx::loopfx("building_fire_small", (2554,5661,282), 2, (2508,5573,285));
	maps\_fx::loopfx("tank_fire_night", (2555,5244,295), 1, (2555,5244,395));
	maps\_fx::loopfx("tank_fire_night", (2559,5324,327), 1, (2559,5324,427));
	maps\_fx::loopfx("tank_fire_night", (2560,5340,247), 1, (2560,5340,347));
	maps\_fx::loopfx("tank_fire_night", (2688,5808,447), 1, (2688,5808,547));

	maps\_fx::loopfx("fogbank_small_duhoc", (-1499,1907,48), 2, (-1499,1907,148));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1393,639,16), 2, (-1393,639,116));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1467,1259,16), 2, (-1467,1259,116));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1467,1259,240), 2, (-1467,1259,340));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1398,3137,16), 2, (-1398,3137,116));


  /*
	///Snow Wind original
	maps\_fx::loopfx("snow_wind_cityhall", (-1062,3592,26), 0.3, (-1062,3592,126));
	maps\_fx::loopfx("snow_wind_cityhall", (-1056,3038,26), 0.3, (-1056,3038,126));
	maps\_fx::loopfx("snow_wind_cityhall", (7,3415,32), 0.3, (7,3415,132));
	maps\_fx::loopfx("snow_wind_cityhall", (-304,2159,7), 0.3, (-304,2159,107));
	maps\_fx::loopfx("snow_wind_cityhall", (-1072,2086,31), 0.3, (-1072,2086,131));
	maps\_fx::loopfx("snow_wind_cityhall", (-1105,1246,91), 0.3, (-1105,1246,191));
	maps\_fx::loopfx("snow_wind_cityhall", (-366,1194,20), 0.3, (-366,1194,120));
	maps\_fx::loopfx("snow_wind_cityhall", (736,1981,41), 0.3, (736,1981,141));
	maps\_fx::loopfx("snow_wind_cityhall", (133,2743,87), 0.3, (133,2743,187));
	maps\_fx::loopfx("snow_wind_cityhall", (900,3176,87), 0.3, (900,3176,187));

  */


}

exploderFX()
{
		maps\_fx::exploderfx(0, "orange_smoke_40sec", (-857,2847,23), 0, (-857,2847,123));
}


randomSnowWind()
{
	//Snow Wind random....positions are from Original
	index = 0;

	fxorigin [index] = 	(-1062,3592,26);		fxvector [index] =  (-1062,3592,126);	index++;
	fxorigin [index] = 	(-1056,3038,26);		fxvector [index] =  (-1056,3038,126);	index++;
	fxorigin [index] = 	(7,3415,32);			fxvector [index] =  (7,3415,132);		index++;
	fxorigin [index] = 	(-304,2159,7);			fxvector [index] =  (-304,2159,107);	index++;
	fxorigin [index] = 	(-1072,2086,31);		fxvector [index] =  (-1072,2086,131);	index++;
	fxorigin [index] = 	(-1105,1246,91);		fxvector [index] =  (-1105,1246,191);	index++;
	fxorigin [index] = 	(-366,1194,20);			fxvector [index] =  (-366,1194,120);	index++;
	fxorigin [index] = 	(736,1981,41);			fxvector [index] =  (736,1981,141);		index++;
	fxorigin [index] = 	(133,2743,87);			fxvector [index] =  (133,2743,187);		index++;
	fxorigin [index] = 	(900,3176,87);			fxvector [index] =  (900,3176,187);		index++;

	for (i = 0; i < fxorigin.size; i++)
	{
		maps\_fx::gunfireloopfxVec ("snow_wind_cityhall", fxorigin [i], fxvector [i],	// Origin
						1, 100,					// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	}	
}


treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	//panzer2 fx
	maps\_treadfx::setVehicleFX("panzer2",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"asphalt",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"carpet",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"cloth",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"sand",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"grass",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"gravel",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"mud",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"plaster",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"rock",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"wood",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"brick",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"concrete",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"foliage",	"fx/dust/tread_dust_snow.efx");

	//german halftrack
	maps\_treadfx::setVehicleFX("germanhalftrack",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"asphalt",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"carpet",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"cloth",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"sand",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"grass",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"gravel",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"mud",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"plaster",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"rock",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"wood",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"brick",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"concrete",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"foliage",	"fx/dust/tread_dust_snow.efx");

}
