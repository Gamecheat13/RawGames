main()
{
	precacheFX();
	ambientFX();
	treadFX();
	exploderFX();
	level thread playerEffect();

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
	
	level._effect["snow_light"]				= loadfx ("fx/misc/snow_light.efx");
	
	//building destruction FX
	level._effect["demolition_dust_base"]		= loadfx ("fx/dust/demolition_dust_base.efx");
	level._effect["demolition_dust_base_after"]	= loadfx ("fx/dust/demolition_dust_base_after.efx");
	level._effect["demolition_base_charge"]		= loadfx ("fx/explosions/default_explosion.efx");
	level._effect["demolition_dust_column"]		= loadfx ("fx/dust/demolition_dust_column.efx");
	level._effect["demolition_windowBlast"]		= loadfx ("fx/explosions/demolition_windowBlast.efx");
	level._effect["demolition_side"]			= loadfx ("fx/dust/demolition_dust_side.efx");
	level._effect["brick"]						= loadfx ("fx/cannon/brick_spot.efx");
	level._effect["brick_spawn"]				= loadfx ("fx/cannon/brick_spawn.efx");
	level._effect["brick_spawn_short"]			= loadfx ("fx/cannon/brick_spawn_short.efx");
	level._effect["brick_spawn_long"]			= loadfx ("fx/cannon/brick_spawn_long.efx");
	level._effect["cold_breath"]				= loadfx ("fx/misc/cold_breath.efx");
	
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["snow_wind_cityhall"]			= loadfx ("fx/misc/snow_wind_cityhall.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["tank_fire_turret"] 			= loadfx ("fx/fire/tank_fire_turret_small.efx");
	
	//tank impacts
	level._effect["snow_impact_small"]			= loadfx ("fx/misc/snow_impact_small.efx");

}


ambientFX()
{
	maps\_fx::loopfx("fogbank_small_duhoc", (-4030,-839,-245), 1, (-4030,-839,-145));
	maps\_fx::loopfx("snow_wind_cityhall", (-2844,-633,-217), 1, (-2844,-633,-117));
	maps\_fx::loopfx("snow_wind_cityhall", (-3666,19,-228), 1, (-3666,19,-128));
	maps\_fx::loopfx("snow_wind_cityhall", (-3097,-292,-254), 1, (-3097,-292,-154));
	maps\_fx::loopfx("snow_wind_cityhall", (-1308,584,-246), 1, (-1308,584,-146));
	maps\_fx::loopfx("snow_wind_cityhall", (-617,717,-150), 1, (-617,717,-50));
	maps\_fx::loopfx("snow_wind_cityhall", (92,546,-181), 1, (92,546,-81));
	maps\_fx::loopfx("snow_wind_cityhall", (1452,402,-127), 1, (1452,402,-27));
	maps\_fx::loopfx("snow_wind_cityhall", (1418,1540,-112), 1, (1418,1540,-12));
	maps\_fx::loopfx("snow_wind_cityhall", (2378,1274,-13), 1, (2378,1274,86));
	maps\_fx::loopfx("snow_wind_cityhall", (1574,919,-112), 1, (1574,919,-12));
	maps\_fx::loopfx("snow_wind_cityhall", (1784,214,-105), 1, (1784,214,-5));
	maps\_fx::loopfx("snow_wind_cityhall", (2827,882,-102), 1, (2827,882,-2));
	maps\_fx::loopfx("snow_wind_cityhall", (3505,501,-77), 1, (3505,501,22));
	maps\_fx::loopfx("snow_wind_cityhall", (2757,16,-3), 1, (2757,16,96));
	maps\_fx::loopfx("snow_wind_cityhall", (3946,145,-64), 1, (3946,145,35));
	maps\_fx::loopfx("snow_wind_cityhall", (4600,-186,-62), 1, (4600,-186,37));
	maps\_fx::loopfx("snow_wind_cityhall", (5194,-520,-115), 1, (5194,-520,-15));
	maps\_fx::loopfx("snow_wind_cityhall", (5159,241,-100), 1, (5159,241,0));
	maps\_fx::loopfx("snow_wind_cityhall", (4570,462,-128), 1, (4570,462,-28));
	maps\_fx::loopfx("snow_wind_cityhall", (4290,984,-97), 1, (4290,984,2));
	maps\_fx::loopfx("snow_wind_cityhall", (3452,1195,-58), 1, (3452,1195,41));
	maps\_fx::loopfx("snow_wind_cityhall", (3102,1945,-110), 1, (3102,1945,-10));
	maps\_fx::loopfx("snow_wind_cityhall", (3689,1800,-72), 1, (3689,1800,27));
	maps\_fx::loopfx("snow_wind_cityhall", (4054,1573,-97), 1, (4054,1573,2));
	maps\_fx::loopfx("snow_wind_cityhall", (5018,1350,-47), 1, (5018,1350,52));
	maps\_fx::loopfx("snow_wind_cityhall", (5509,1221,-115), 1, (5509,1221,-15));
	maps\_fx::loopfx("snow_wind_cityhall", (6117,1233,-117), 1, (6117,1233,-17));
	maps\_fx::loopfx("snow_wind_cityhall", (6137,491,-132), 1, (6137,491,-32));
	maps\_fx::loopfx("snow_wind_cityhall", (6195,-290,-118), 1, (6195,-290,-18));
	maps\_fx::loopfx("snow_wind_cityhall", (2077,797,-115), 1, (2077,797,-15));
	maps\_fx::loopfx("tank_fire_turret", (2327,463,-38), 1, (2327,463,61));
	maps\_fx::loopfx("tank_fire_engine", (2333,563,-62), 1, (2333,563,37));
	maps\_fx::loopfx("fogbank_small_duhoc", (-3607,-1431,-245), 1, (-3607,-1431,-145));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2665,224,-266), 1, (-2665,224,-166));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2334,-256,-246), 1, (-2334,-256,-146));
	maps\_fx::loopfx("fogbank_small_duhoc", (681,423,-151), 1, (681,423,-51));
	maps\_fx::loopfx("fogbank_small_duhoc", (916,384,-5), 1, (916,384,94));
	maps\_fx::loopfx("fogbank_small_duhoc", (6551,891,-147), 1, (6551,891,-47));
	maps\_fx::loopfx("fogbank_small_duhoc", (6486,352,-147), 1, (6486,352,-47));
	maps\_fx::loopfx("snow_wind_cityhall", (1192,921,-98), 1, (1192,921,1));

	maps\_fx::soundfx("demolition_german_planning1", (6512,451,173), "stopGermanPlanning");
	maps\_fx::soundfx("demolition_german_planning2", (6529,1213,241), "stopGermanPlanning");
	maps\_fx::soundfx("demolition_german_planning3", (6919,991,241), "stopGermanPlanning");
	maps\_fx::soundfx("demolition_german_planning4", (6899,249,241), "stopGermanPlanning");
}


treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	//panzer2 fx
	maps\_treadfx::setVehicleFX("panzer2",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"asphalt",	undefined);
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
	maps\_treadfx::setVehicleFX("panzer2",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"foliage",	undefined);
}

exploderFX()
{
	//base charges
	maps\_fx::exploderfx(1, "demolition_base_charge", (6347,1177,-31), 0, (6347,1177,-21), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_demoexplosion");
	maps\_fx::exploderfx(1, "demolition_base_charge", (6350,970,-45), 0.3, (6350,970,-35), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_demoexplosion");
	maps\_fx::exploderfx(1, "demolition_base_charge", (6355,779,-45), 0.6, (6355,779,-35), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_demoexplosion");
	maps\_fx::exploderfx(1, "demolition_base_charge", (6352,587,-50), 0.9, (6352,587,-40), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_demoexplosion");
	maps\_fx::exploderfx(1, "demolition_base_charge", (6351,382,-52), 1.2, (6351,382,-42), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_demoexplosion");
	maps\_fx::exploderfx(1, "demolition_windowBlast", (6373,671,429), 0.6, (6273,672,425), undefined, undefined, undefined, undefined, undefined, undefined, "explo_mine");
	maps\_fx::exploderfx(1, "demolition_windowBlast", (6396,857,223), 0.3, (6297,863,219), undefined, undefined, undefined, undefined, undefined, undefined, "explo_mine");

	//demolition base dust
	maps\_fx::exploderfx(2, "demolition_dust_base", (6674,707,-93), 0, (6678,705,6), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_dustbase");
	maps\_fx::exploderfx(2, "demolition_side", (6765,3,-30), undefined, (6765,3,-20), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_dustbase2");

	//demolition dust columns
	maps\_fx::exploderfx(3, "demolition_dust_column", (6350,977,345), 0, (6353,977,445), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_dustbase");
	maps\_fx::exploderfx(3, "demolition_windowBlast", (6382,1065,408), 0, (6282,1060,408), undefined, undefined, undefined, undefined, undefined, undefined, "explo_mine");

	maps\_fx::exploderfx(4, "demolition_dust_column", (6374,774,346), 0, (6377,777,446), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_dustbase");

	maps\_fx::exploderfx(5, "demolition_dust_column", (6378,583,343), 0, (6377,584,443), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_dustbase");
	maps\_fx::exploderfx(5, "demolition_windowBlast", (6339,489,230), 0, (6239,491,229), undefined, undefined, undefined, undefined, undefined, undefined, "explo_mine");

	maps\_fx::exploderfx(6, "demolition_dust_column", (6362,396,341), 0, (6366,400,441), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_dustbase");
	maps\_fx::exploderfx(6, "demolition_windowBlast", (6341,480,663), 0, (6241,480,664), undefined, undefined, undefined, undefined, undefined, undefined, "explo_mine");

	maps\_fx::exploderfx(20, "demolition_dust_base_after", (5699,587,-233), undefined, (5699,587,-133), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_dustbase4");

	// walla walla sounds	
	maps\_fx::exploderfx(51, undefined, (2736,713,166), 28, (2736,713,266), undefined, undefined, undefined, undefined, undefined, undefined, "walla_german_large", undefined, undefined, undefined);
	maps\_fx::exploderfx(50, undefined, (1531,851,4), 4.5, (1531,851,104), undefined, undefined, undefined, undefined, undefined, undefined, "walla_russian_large", undefined, undefined, undefined);

	// germans preparing
	maps\_fx::exploderfx(70,undefined,(5966,411,145), undefined, (5966,411,245), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_german_preparations", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(71,undefined,(5966,859,145), undefined, (5966,859,245), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_german_preparations", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(72,undefined,(5966,651,145), undefined, (5966,651,245), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_german_preparations", undefined, undefined, undefined, undefined, undefined);

	
	//Closest tank 7
	maps\_fx::exploderfx(7, "snow_impact_small", (-949,553,-230), 0, (-951,520,-135), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(7, "snow_impact_small", (-871,541,-228), 0, (-873,508,-133), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(7, "snow_impact_small", (-949,553,-230), 0.1, (-951,520,-135), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(7, "snow_impact_small", (-871,541,-228), 0.1, (-873,508,-133), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(7, "snow_impact_small", (-949,553,-230), 0.2, (-951,520,-135), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(7, "snow_impact_small", (-871,541,-228), 0.2, (-873,508,-133), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(7, "snow_impact_small", (-963,421,-240), 1.1, (-962,443,-142), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(7, "snow_impact_small", (-876,411,-240), 1.1, (-875,433,-142), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	// sound
	maps\_fx::exploderfx(7,undefined,(-921,420,-220), 0.8, (-921,420,-120), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_trenchhit", undefined, undefined, undefined);

	// furthest tank 8
	maps\_fx::exploderfx(8, "snow_impact_small", (-695,539,-227), 0, (-696,506,-132), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-780,546,-226), 0, (-781,513,-131), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-795,529,-230), 0.05, (-796,496,-135), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-695,539,-227), 0.1, (-696,506,-132), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-780,546,-226), 0.1, (-781,513,-131), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-795,529,-230), 0.15, (-796,496,-135), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-695,539,-227), 0.2, (-696,506,-132), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-780,546,-226), 0.2, (-781,513,-131), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-795,529,-230), 0.25, (-796,496,-135), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-695,539,-227), 0.3, (-696,506,-132), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-780,546,-226), 0.3, (-781,513,-131), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-795,529,-230), 0.35, (-796,496,-135), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-800,400,-227), 0.9, (-799,422,-129), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(8, "snow_impact_small", (-699,379,-227), 0.9, (-698,401,-129), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	// sound
	maps\_fx::exploderfx(8,undefined,(-747,396,-220), 0.8, (-747,396,-120), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_trenchhit");
	maps\_fx::exploderfx(19,undefined,(6275,678,88), undefined, (6275,678,188), undefined, undefined, undefined, undefined, undefined, undefined, "demolition_building_collapse", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(0,undefined,(575,418,-105), undefined, (575,418,-5), undefined, undefined, undefined, undefined, undefined, undefined, "wall_crumble", undefined, undefined, undefined, undefined, undefined);
}



createWallShredExploders()
{	
	rate = 0.0;
	startOrg = (6356,1007,-130);
	for (i=0;i<40;i++)
	{
		startOrg += (0,0,25);
		maps\_fx::exploderfx(21, "brick", startOrg, i*rate, startOrg + (0,0,100));
	}
	startOrg = (6359,777,-130);
	for (i=0;i<40;i++)
	{
		startOrg += (0,0,25);
		maps\_fx::exploderfx(22, "brick", startOrg, i*rate, startOrg + (0,0,100));
	}
	startOrg = (6362,593,-130);
	for (i=0;i<40;i++)
	{
		startOrg += (0,0,25);
		maps\_fx::exploderfx(23, "brick", startOrg, i*rate, startOrg + (0,0,100));
	}
	startOrg = (6358,376,-130);
	for (i=0;i<40;i++)
	{
		startOrg += (0,0,25);
		maps\_fx::exploderfx(24, "brick", startOrg, i*rate, startOrg + (0,0,100));
	}


	startOrg = (6388,1025,860);
	level.build_brick[10] = [];
	offset = 0;
	offsetSetting[0] = 0;
	offsetSetting[1] = 85;
	offsetSetting[2] = 55;
	offsetSetting[3] = 125;
	offsetSetting[4] = 75;
	offsetSetting[5] = 100;
	offsetSetting[6] = 60;
	offsetSetting[7] = 25;
	offsetSetting[8] = 35;
	offsetSetting[9] = 15;
	offsetSetting[10] = 60;
	offsetSetting[11] = 25;
	offsetSetting[12] = 55;
	offsetSetting[13] = 15;
	offsetSetting[14] = 0;
	for (i=0;i<15;i++)
	{
		startOrg -= (0,0,20+offset);
		offset+=4;
		ent = spawn ("script_model", (0,0,0));
		ent.origin = startOrg + (offsetSetting[i], 0, 0);
		level.build_brick[10][level.build_brick[10].size] = ent;
	}

	startOrg = (6395,792,920);
	level.build_brick[20] = [];
	offset = 0;
	offsetSetting[0] = 0;
	offsetSetting[1] = 85;
	offsetSetting[2] = 55;
	offsetSetting[3] = 125;
	offsetSetting[4] = 75;
	offsetSetting[5] = 100;
	offsetSetting[6] = 60;
	offsetSetting[7] = 25;
	offsetSetting[8] = 35;
	offsetSetting[9] = 15;
	for (i=0;i<5;i++)
	{
		startOrg -= (0,0,20+offset);
		offset+=4;
		ent = spawn ("script_model", (0,0,0));
		ent.origin = startOrg + (offsetSetting[i], 0, 0);
		level.build_brick[20][level.build_brick[20].size] = ent;
	}
	level.build_brick[25] = [];
	for (i=0;i<10;i++)
	{
		startOrg -= (0,0,20+offset);
		offset+=4;
		ent = spawn ("script_model", (0,0,0));
		ent.origin = startOrg + (offsetSetting[i], 0, 0);
		level.build_brick[25][level.build_brick[25].size] = ent;
	}


	startOrg = (6395,615,850);
	level.build_brick[30] = [];
	offsetSetting[0] = 0;
	offsetSetting[1] = 75;
	offsetSetting[2] = 100;
	offsetSetting[3] = 60;
	offsetSetting[4] = 15;
	offsetSetting[5] = 50;
	
	offset = 0;
	for (i=0;i<6;i++)
	{
//		startOrg -= (0,0,offsetSetting[i]);
		startOrg -= (0,0,15+offset);
		offset+=4;
		ent = spawn ("script_model", (0,0,0));
		ent.origin = startOrg + (offsetSetting[i], 0, 0);
		level.build_brick[30][level.build_brick[30].size] = ent;
	}

/*
	startOrg = (6395,615,580);
	offsetSetting[0] = 0;
	offsetSetting[1] = 50;
	offsetSetting[2] = 20;
	offsetSetting[3] = 40;
	offsetSetting[4] = 30;
	for (i=0;i<5;i++)
	{
		startOrg -= (0,0,offsetSetting[i]);
		ent = spawn ("script_model", (0,0,0));
		ent.origin = startOrg;
		level.build_brick[30][level.build_brick[30].size] = ent;
	}
*/


	startOrg = (6385,380,880);
	level.build_brick[40] = [];
	offset = 0;
	for (i=0;i<7;i++)
	{
		startOrg -= (0,0,25+offset);
		offset+=6;
		ent = spawn ("script_model", (0,0,0));
		ent.origin = startOrg;
		level.build_brick[40][level.build_brick[40].size] = ent;
	}
}


playerEffect()
{
	player = getent("player","classname");
	for (;;)
	{
		playfx ( level._effect["snow_light"], player.origin + (0,0,300), player.origin + (0,0,350) );
		wait (0.75);
	}
}
