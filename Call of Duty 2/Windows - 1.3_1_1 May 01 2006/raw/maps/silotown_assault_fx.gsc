main()
{
	precacheFX();
	exploderFX();
	spawnWorldFX();
	randomGroundDust();
}

precacheFX()
{
	level._effect["silo_explode"]				= loadfx ("fx/explosions/silo_explode.efx");
	level._effect["tank_fire_turret"] 			= loadfx ("fx/fire/tank_fire_turret_small.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M.efx");         																																																																																
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M.efx");         																																																																																
	level._effect["battlefield_smokebank_S"]	= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	level._effect["dust_wind"]					= loadfx ("fx/dust/dust_wind_eldaba.efx");
	level._effect["insects_carcass_flies"]		= loadfx ("fx/misc/insects_carcass_flies.efx");
}

exploderFX()
{
	maps\_fx::exploderfx(0, "silo_explode", (424, 480, 608), 0, (424, 480, 708));
}

spawnWorldFX()
{
	
	//Flies
	maps\_fx::loopfx("insects_carcass_flies", (-2201,-2146,-103), 0.3, (-2201,-2146,-93));
	maps\_fx::loopfx("insects_carcass_flies", (-797,-2018,-58), 0.3, (-797,-2018,-48));
	maps\_fx::loopfx("insects_carcass_flies", (-1123,-1739,-67), 0.3, (-1123,-1739,-57));
	maps\_fx::loopfx("insects_carcass_flies", (-2093,-2393,-132), 0.3, (-2093,-2393,-122));
	maps\_fx::loopfx("insects_carcass_flies", (-1131,-2221,-100), 0.3, (-1131,-2221,-90));
	maps\_fx::loopfx("insects_carcass_flies", (-927,-2296,-87), 0.3, (-927,-2296,-77));
	maps\_fx::loopfx("insects_carcass_flies", (-646,-1250,1), 0.3, (-646,-1250,11));
	maps\_fx::loopfx("insects_carcass_flies", (-1465,-1822,-73), 0.3, (-1465,-1822,-63));
	maps\_fx::loopfx("insects_carcass_flies", (-1811,-1768,-60), 0.3, (-1811,-1768,-50));
	maps\_fx::loopfx("insects_carcass_flies", (-995,4005,52), 0.3, (-995,4005,62));
	maps\_fx::loopfx("insects_carcass_flies", (-3350,-3319,-189), 0.3, (-3350,-3319,-179));
	maps\_fx::loopfx("insects_carcass_flies", (-4674,-5227,-215), 0.3, (-4674,-5227,-205));
	maps\_fx::loopfx("insects_carcass_flies", (-4846,-5191,-215), 0.3, (-4846,-5191,-205));
	maps\_fx::loopfx("insects_carcass_flies", (-4001,-4893,-188), 0.3, (-4001,-4893,-178));
	maps\_fx::loopfx("insects_carcass_flies", (-3810,-4498,-143), 0.3, (-3810,-4498,-133));
	maps\_fx::loopfx("insects_carcass_flies", (-3730,-3891,-110), 0.3, (-3730,-3891,-100));
	maps\_fx::loopfx("insects_carcass_flies", (-3403,-3509,-189), 0.3, (-3403,-3509,-179));
	maps\_fx::loopfx("insects_carcass_flies", (-3077,-3506,-152), 0.3, (-3077,-3506,-142));
	maps\_fx::loopfx("insects_carcass_flies", (-1592,-3106,-112), 0.3, (-1592,-3106,-102));
	maps\_fx::loopfx("insects_carcass_flies", (-1329,-3103,-85), 0.3, (-1329,-3103,-75));
	maps\_fx::loopfx("insects_carcass_flies", (-1044,-1390,-37), 0.3, (-1044,-1390,-27));
	maps\_fx::loopfx("insects_carcass_flies", (-2078,-1245,-113), 0.3, (-2078,-1245,-103));
	maps\_fx::loopfx("insects_carcass_flies", (-816,-938,-97), 0.3, (-816,-938,-87));
	maps\_fx::loopfx("insects_carcass_flies", (-1415,-1038,-129), 0.3, (-1415,-1038,-119));
	maps\_fx::loopfx("insects_carcass_flies", (-2518,-1396,-165), 0.3, (-2518,-1396,-155));
	maps\_fx::loopfx("insects_carcass_flies", (-1650,-1093,-129), 0.3, (-1650,-1093,-119));
	maps\_fx::loopfx("insects_carcass_flies", (-3105,-1347,-186), 0.3, (-3105,-1347,-176));
	maps\_fx::loopfx("insects_carcass_flies", (-1163,-996,-97), 0.3, (-1163,-996,-87));
	maps\_fx::loopfx("insects_carcass_flies", (-1308,237,11), 0.3, (-1308,237,21));
	maps\_fx::loopfx("insects_carcass_flies", (-1580,520,-13), 0.3, (-1580,520,-3));
	maps\_fx::loopfx("insects_carcass_flies", (-1470,1752,15), 0.3, (-1470,1752,25));
	maps\_fx::loopfx("insects_carcass_flies", (-372,1789,-1), 0.3, (-372,1789,8));
	maps\_fx::loopfx("insects_carcass_flies", (-352,-942,-81), 0.3, (-352,-942,-71));
	maps\_fx::loopfx("insects_carcass_flies", (-484,171,8), 0.3, (-484,171,18));
	maps\_fx::loopfx("insects_carcass_flies", (-1471,1368,12), 0.3, (-1471,1368,22));
	maps\_fx::loopfx("insects_carcass_flies", (-1896,492,26), 0.3, (-1896,492,36));
	maps\_fx::loopfx("insects_carcass_flies", (-321,2170,-14), 0.3, (-321,2170,-4));

	//Fire and smoke 
	maps\_fx::loopfx("thin_light_smoke_M", (-1250,-1835,-124), 1, (-1250,-1835,-114));
	maps\_fx::loopfx("thin_light_smoke_M", (-872,-1454,-68), 1, (-872,-1454,-58));
	maps\_fx::loopfx("battlefield_smokebank_S", (-644,2254,6), 1, (-644,2254,16));
	maps\_fx::loopfx("thin_black_smoke_M", (-186,993,-2), 1, (-186,993,7));
	maps\_fx::loopfx("thin_light_smoke_M", (-2015,-2024,-125), 1, (-2015,-2024,-115));
	maps\_fx::loopfx("thin_light_smoke_M", (3013,848,14), 1, (3013,848,24));
	maps\_fx::loopfx("tank_fire_engine", (-1723,809,19), 1, (-1723,809,29));
	maps\_fx::loopfx("tank_fire_engine", (-1729,835,31), 1, (-1729,835,41));
	maps\_fx::loopfx("thin_black_smoke_M", (-1717,818,21), 1, (-1717,818,31));
	maps\_fx::loopfx("tank_fire_engine", (-1771,822,-5), 1, (-1771,822,5));
	maps\_fx::loopfx("tank_fire_engine", (-1601,789,-11), 1, (-1601,789,-1));
	maps\_fx::loopfx("tank_fire_engine", (-148,992,1), 1, (-148,992,11));
	maps\_fx::loopfx("tank_fire_engine", (-185,1016,-5), 1, (-204,1114,-6));
	maps\_fx::loopfx("tank_fire_engine", (-215,918,15), 1, (-204,821,37));
	maps\_fx::loopfx("tank_fire_turret", (1618,1555,41), 1, (1622,1568,140));
	maps\_fx::loopfx("thin_light_smoke_M", (-276,292,9), 1, (-276,292,19));
	maps\_fx::loopfx("battlefield_smokebank_S", (1242,2366,48), 1, (1242,2366,58));
	maps\_fx::loopfx("battlefield_smokebank_S", (933,232,0), 1, (933,232,9));

	/*
	//Dust Originals - DO NOT DELETE
	maps\_fx::loopfx("dust_wind", (-2326,882,-34), 0.6, (-2326,882,-24));
	maps\_fx::loopfx("dust_wind", (-688,1108,-17), 0.6, (-688,1108,-7));
	maps\_fx::loopfx("dust_wind", (159,2406,-26), 0.6, (159,2406,-16));
	maps\_fx::loopfx("dust_wind", (904,2095,-3), 0.6, (904,2095,6));
	maps\_fx::loopfx("dust_wind", (362,3194,-12), 0.6, (362,3194,-2));
	maps\_fx::loopfx("dust_wind", (2303,1190,-10), 0.6, (2303,1190,0));
	maps\_fx::loopfx("dust_wind", (1471,1164,-20), 0.6, (1471,1164,-10));
	maps\_fx::loopfx("dust_wind", (593,1109,-23), 0.6, (593,1109,-13));
	maps\_fx::loopfx("dust_wind", (-1215,1061,-17), 0.6, (-1215,1061,-7));
	*/
}

randomGroundDust()
{
	index = 0;
	
	fxorigin [index] = 	(-2326,882,-34);			fxvector [index] =  (-2326,882,-24);	index++;
	fxorigin [index] = 	(-688,1108,-17);			fxvector [index] =  (-688,1108,-7);	index++;
	fxorigin [index] = 	(159,2406,-26);				fxvector [index] =  (159,2406,-16);	index++;
	fxorigin [index] = 	(904,2095,-3);				fxvector [index] =  (904,2095,6);	index++;
	fxorigin [index] = 	(362,3194,-12);				fxvector [index] =  (362,3194,-2);	index++;
	fxorigin [index] = 	(2303,1190,-10);			fxvector [index] =  (2303,1190,0);	index++;
	fxorigin [index] = 	(1471,1164,-20);			fxvector [index] =  (1471,1164,-10);	index++;
	fxorigin [index] = 	(593,1109,-23);				fxvector [index] =  (593,1109,-13);	index++;
	fxorigin [index] = 	(-1215,1061,-17);			fxvector [index] =  (-1215,1061,-7);	index++;

	for (i = 0; i < fxorigin.size; i++)
	{
		maps\_fx::gunfireloopfxVec ("dust_wind", fxorigin [i], fxvector [i],	// Origin
							15, 50,					// Number of shots
							0.3, 0.6,				// seconds between shots
							3, 5);					// seconds between sets of shots.
	}	
}