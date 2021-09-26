main()
{
	precacheFX();
	ambientFX();
	if(level.scr_moscow_fx == 0)
		randomSnowWind();
	exploderFX();
	treadFX();
}

precacheFX()
{
	
	//footstep fx
	animscripts\utility::setFootstepEffect ("snow",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("gravel",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("plaster",		loadfx ("fx/impacts/footstep_snow.efx"));
	

	// misc
	level._effect["cold_breath"]				= loadfx ("fx/misc/cold_breath.efx");	
	level._effect["med_oil_fire"]				= loadfx ("fx/fire/med_oil_fire.efx");	
	level._effect["snow_wind_doorway"]			= loadfx ("fx/misc/snow_wind_doorway.efx");	
	level._effect["tree_splinter"]				= loadfx ("fx/explosions/tree_burst.efx");	
	level._effect["wall_exp"]					= loadfx ("fx/explosions/tree_burst.efx");
	level._effect["rocketfx"]					= loadfx ("fx/fire/nebelwerfer_trail.efx");
	level._effect["rocket_launch"]				= loadfx ("fx/fire/rocket_launch.efx");
	level._effect["tank_fire_turret"] 			= loadfx ("fx/fire/tank_fire_turret_small.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["building_fire_small"]		= loadfx ("fx/fire/building_fire_small.efx");
	//level._effect["building_fire_med"]			= loadfx ("fx/fire/building_fire_med.efx");
	level._effect["building_fire_large"]		= loadfx ("fx/fire/building_fire_distant.efx");
	level._effect["ground_fire_med"]			= loadfx ("fx/fire/ground_fire_med.efx");
	level._effect["ground_fire_med_nosmoke"]	= loadfx ("fx/fire/ground_fire_med_nosmoke.efx");
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["snow_wind_cityhall"]			= loadfx ("fx/misc/snow_wind_cityhall.efx");
	level._effect["giant_smoke_plumeBG"]		= loadfx ("fx/smoke/smoke_plumeBG");	
	
}

ambientFX()
{
	if(level.scr_moscow_fx == 0)
	{
		maps\_fx::loopfx("med_oil_fire", (-719,1369,129), 2, (-717,1375,229));
		maps\_fx::loopfx("med_oil_fire", (1281,848,-85), 2, (1283,854,14));
		maps\_fx::loopfx("med_oil_fire", (-404,-195,26), 2, (-406,-196,125));
		
		maps\_fx::loopfx("building_fire_large", (-6148,300,756), 2, (-6051,299,782));
		maps\_fx::loopfx("building_fire_large", (-6468,-688,730), 2, (-6371,-689,756));
		maps\_fx::loopfx("building_fire_large", (-7365,-1194,606), 2, (-7268,-1195,632));
		maps\_fx::loopfx("building_fire_large", (-7307,-1446,790), 2, (-7232,-1381,796));
		maps\_fx::loopfx("building_fire_large", (-6172,-114,638), 2, (-6075,-115,664));
		maps\_fx::loopfx("building_fire_large", (-6189,-427,552), 2, (-6114,-493,558));
		maps\_fx::loopfx("building_fire_large", (-6173,-281,752), 2, (-6076,-282,778));
		maps\_fx::loopfx("building_fire_large", (-6185,-362,646), 2, (-6088,-363,672));
		maps\_fx::loopfx("building_fire_large", (-6180,391,756), 2, (-6083,390,782));
		maps\_fx::loopfx("building_fire_large", (-7320,-1107,654), 2, (-7223,-1108,680));
		maps\_fx::loopfx("giant_smoke_plumeBG", (-6697,147,615), 1.3, (-6706,124,712));
		
		maps\_fx::loopfx("tank_fire_turret", (-558,40,-51), 1, (-559,57,47));
	}
	
	if(level.scr_moscow_fx == 0)
	{
		maps\_fx::loopfx("ground_fire_med", (-1611,-949,53), 2, (-1609,-956,152));
		maps\_fx::loopfx("ground_fire_med", (-1373,-1076,68), 2, (-1371,-1083,167));
		maps\_fx::loopfx("ground_fire_med", (29,12,-112), 2, (30,4,-13));
		maps\_fx::loopfx("ground_fire_med", (246,-1042,97), 2, (247,-1050,196));
		maps\_fx::loopfx("ground_fire_med", (-2082,-171,117), 2, (-2080,-178,216));
		maps\_fx::loopfx("ground_fire_med", (1380,632,-87), 2, (1381,622,11));
		maps\_fx::loopfx("ground_fire_med", (1280,746,-95), 2, (1282,737,3));
		maps\_fx::loopfx("ground_fire_med", (849,1049,-97), 2, (850,1039,2));
		maps\_fx::loopfx("ground_fire_med", (990,702,-183), 2, (992,692,-84));
		maps\_fx::loopfx("ground_fire_med", (-537,830,0), 2, (-560,734,10));
		maps\_fx::loopfx("ground_fire_med", (1178,900,-110), 2, (1180,890,-10));
		maps\_fx::loopfx("ground_fire_med", (1019,-1191,-7), 2, (1022,-1191,92));
		maps\_fx::loopfx("ground_fire_med", (464,-1395,-52), 2, (489,-1395,48));
	}
	else
	{
		maps\_fx::loopfx("ground_fire_med_nosmoke", (-1611,-949,53), 2, (-1609,-956,152));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (-1373,-1076,68), 2, (-1371,-1083,167));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (29,12,-112), 2, (30,4,-13));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (246,-1042,97), 2, (247,-1050,196));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (-2082,-171,117), 2, (-2080,-178,216));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (1380,632,-87), 2, (1381,622,11));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (1280,746,-95), 2, (1282,737,3));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (849,1049,-97), 2, (850,1039,2));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (990,702,-183), 2, (992,692,-84));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (-537,830,0), 2, (-560,734,10));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (1178,900,-110), 2, (1180,890,-10));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (1019,-1191,-7), 2, (1022,-1191,92));
		maps\_fx::loopfx("ground_fire_med_nosmoke", (464,-1395,-52), 2, (489,-1395,48));
	}
	
	maps\_fx::loopfx("building_fire_small", (-1800,598,221), 2, (-1801,499,226));
	maps\_fx::loopfx("tank_fire_engine", (-1638,623,294), 1, (-1634,523,299));
	maps\_fx::loopfx("tank_fire_engine", (-26,89,-95), 1, (-28,82,3));
	maps\_fx::loopfx("tank_fire_engine", (10,124,-108), 1, (8,117,-8));
	maps\_fx::loopfx("building_fire_small", (-1048,-1152,234), 2, (-1054,-1250,249));
	maps\_fx::loopfx("tank_fire_engine", (-1604,613,181), 1, (-1606,606,280));
	maps\_fx::loopfx("tank_fire_engine", (-1151,-1058,203), 1, (-1208,-1062,284));
	maps\_fx::loopfx("tank_fire_engine", (-1063,-997,219), 1, (-1065,-1004,319));
	maps\_fx::loopfx("building_fire_small", (789,1071,69), 2, (782,971,66));	
	maps\_fx::loopfx("tank_fire_engine", (1221,669,-117), 1, (1215,665,-18));	
	maps\_fx::loopfx("building_fire_small", (-1737,597,221), 2, (-1734,498,225));
	maps\_fx::loopfx("building_fire_small", (684,624,69), 2, (677,524,66));
	maps\_fx::loopfx("tank_fire_engine", (501,-1308,-54), 1, (495,-1312,44));
	maps\_fx::loopfx("tank_fire_engine", (471,-1300,-25), 1, (465,-1304,74));
	maps\_fx::loopfx("tank_fire_engine", (506,656,32), 1, (500,652,131));
	maps\_fx::loopfx("tank_fire_engine", (-1404,-1038,49), 1, (-1437,-1057,142));
	maps\_fx::loopfx("tank_fire_engine", (-1445,-1007,44), 1, (-1478,-1027,137));
	maps\_fx::loopfx("tank_fire_engine", (-1569,-920,52), 1, (-1602,-940,145));
	maps\_fx::loopfx("tank_fire_engine", (-1657,-909,44), 1, (-1690,-929,137));
	maps\_fx::loopfx("ground_fire_med_nosmoke", (1475,595,-70), 2, (1477,588,27));
	maps\_fx::loopfx("ground_fire_med_nosmoke", (1591,450,-68), 2, (1593,443,30));
	maps\_fx::loopfx("ground_fire_med_nosmoke", (1093,1104,-107), 2, (1095,1097,-9));
	maps\_fx::loopfx("ground_fire_med_nosmoke", (943,1005,-106), 2, (945,998,-8));	
	maps\_fx::loopfx("ground_fire_med_nosmoke", (1387,732,-82), 2, (1389,725,15));	
	maps\_fx::loopfx("ground_fire_med_nosmoke", (1502,512,-67), 2, (1504,502,31));
	

	/*
	//Snow Wind original - donot delete
	maps\_fx::loopfx("snow_wind_cityhall", (-2480,-766,74), 1, (-2482,-773,174));
	maps\_fx::loopfx("snow_wind_cityhall", (-2731,-1428,89), 1, (-2733,-1435,189));
	maps\_fx::loopfx("snow_wind_cityhall", (-1190,180,-11), 1, (-1192,173,88));
	maps\_fx::loopfx("snow_wind_cityhall", (56,490,-103), 1, (54,483,-3));
	maps\_fx::loopfx("snow_wind_cityhall", (-1082,-442,25), 1, (-1084,-449,125));
	maps\_fx::loopfx("snow_wind_cityhall", (-1711,-762,34), 1, (-1713,-769,134));
	maps\_fx::loopfx("snow_wind_cityhall", (-2089,-852,21), 1, (-2091,-859,121));
	maps\_fx::loopfx("snow_wind_cityhall", (186,-1389,7), 1, (184,-1396,107));
	maps\_fx::loopfx("snow_wind_cityhall", (-1782,-1705,30), 1, (-1784,-1712,130));
	maps\_fx::loopfx("snow_wind_cityhall", (-2719,-414,85), 1, (-2721,-421,185));
	maps\_fx::loopfx("snow_wind_cityhall", (-3147,-703,127), 1, (-3149,-710,227));
	maps\_fx::loopfx("snow_wind_cityhall", (-1874,-208,77), 1, (-1876,-215,177));
	maps\_fx::loopfx("snow_wind_cityhall", (1153,368,-161), 1, (1151,361,-61));
	maps\_fx::loopfx("snow_wind_cityhall", (998,-89,-147), 1, (996,-96,-47));
	maps\_fx::loopfx("snow_wind_cityhall", (844,-547,-106), 1, (842,-554,-6));
	maps\_fx::loopfx("snow_wind_cityhall", (730,-1185,-48), 1, (728,-1192,51));
	maps\_fx::loopfx("snow_wind_cityhall", (276,-1844,-48), 1, (274,-1851,51));
	maps\_fx::loopfx("snow_wind_cityhall", (-845,-648,84), 1, (-847,-655,184));
	maps\_fx::loopfx("snow_wind_cityhall", (-113,-1133,50), 0.3, (-115,-1140,150));
	maps\_fx::loopfx("snow_wind_cityhall", (-782,-1222,50), 0.3, (-784,-1229,150));
	maps\_fx::loopfx("snow_wind_cityhall", (-1291,-749,34), 1, (-1293,-756,134));
	*/
}

randomSnowWind()
{
	//Snow Wind random....positions are from Original
	index = 0;

	fxorigin [index] = 	(-2480,-766,74);		fxvector [index] =  (-2482,-773,174);	index++;
	fxorigin [index] = 	(-2731,-1428,89);		fxvector [index] =  (-2733,-1435,189);	index++;
	fxorigin [index] = 	(-1190,180,-11);		fxvector [index] =  (-1192,173,88);	index++;
	fxorigin [index] = 	(56,490,-103);			fxvector [index] =  (54,483,-3);	index++;
	fxorigin [index] = 	(-1082,-442,25);		fxvector [index] =  (-1084,-449,125);	index++;
	fxorigin [index] = 	(-1711,-762,34);		fxvector [index] =  (-1713,-769,134);	index++;
	fxorigin [index] = 	(-2089,-852,21);		fxvector [index] =  (-2091,-859,121);	index++;
	fxorigin [index] = 	(186,-1389,7);			fxvector [index] =  (184,-1396,107);	index++;
	fxorigin [index] = 	(-1782,-1705,30);		fxvector [index] =  (-1784,-1712,130);	index++;
	fxorigin [index] = 	(-2719,-414,85);		fxvector [index] =  (-2721,-421,185);	index++;
	fxorigin [index] = 	(-3147,-703,127);		fxvector [index] =  (-3149,-710,227);	index++;
	fxorigin [index] = 	(-1874,-208,77);		fxvector [index] =  (-1876,-215,177);	index++;
	fxorigin [index] = 	(1153,368,-161);		fxvector [index] =  (1151,361,-61);	index++;
	fxorigin [index] = 	(998,-89,-147);			fxvector [index] =  (996,-96,-47);	index++;
	fxorigin [index] = 	(844,-547,-106);		fxvector [index] =  (842,-554,-6);	index++;
	fxorigin [index] = 	(730,-1185,-48);		fxvector [index] =  (728,-1192,51);	index++;
	fxorigin [index] = 	(276,-1844,-48);		fxvector [index] =  (274,-1851,51);	index++;
	fxorigin [index] = 	(-845,-648,84);			fxvector [index] =  (-847,-655,184);	index++;
	fxorigin [index] = 	(-113,-1133,50);		fxvector [index] =  (-115,-1140,150);	index++;
	fxorigin [index] = 	(-782,-1222,50);		fxvector [index] =  (-784,-1229,150);	index++;
	fxorigin [index] = 	(-1291,-749,34);		fxvector [index] =  (-1293,-756,134);	index++;


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

	//german halftrack
	maps\_treadfx::setVehicleFX("blitz",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"sand",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"grass",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"plaster",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"rock",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"wood",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"brick",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	"fx/dust/tread_dust_snow.efx");

	//german halftrack
	maps\_treadfx::setVehicleFX("germanfordtruck",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"asphalt",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"carpet",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"cloth",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"sand",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"grass",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"gravel",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("germanfordtruck",	"mud",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"plaster",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"rock",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"wood",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"brick",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"concrete",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanfordtruck",	"foliage",	"fx/dust/tread_dust_snow.efx");
}

exploderFX()
{
	maps\_fx::exploderfx(1, "snow_wind_doorway", (-1383,-135,72), 0, (-1483,-135,82));

}