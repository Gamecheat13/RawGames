main()
{
	level thread precacheFX();
	level thread spawnWorldFX();
	level thread playerEffect();
	level thread exploders();
	randomSnowWind();

}

precacheFX()
{

	//footstep fx
	animscripts\utility::setFootstepEffect ("snow",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("gravel",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("plaster",		loadfx ("fx/impacts/footstep_snow.efx"));
		
	level._effect["snow_light"]		= loadfx ("fx/misc/snow_light.efx");
	level._effect["snow_wind_cityhall"]	= loadfx ("fx/misc/snow_wind_cityhall.efx");
	level._effect["thin_black_smoke_M"]	= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	//level._effect["thin_light_smoke_M"]	= loadfx ("fx/smoke/thin_light_smoke_M.efx");
	level._effect["thin_black_smoke_S"]	= loadfx ("fx/smoke/thin_black_smoke_S.efx");
	level._effect["tank_fire_engine"] 	= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["tank_fire_turret"] 	= loadfx ("fx/fire/tank_fire_turret_large.efx");
	level._effect["building_fire_med"]	= loadfx ("fx/fire/building_fire_med.efx");
	level._effect["building_fire_large"]	= loadfx ("fx/fire/building_fire_large.efx");
	level._effect["med_oil_fire"]		= loadfx ("fx/fire/med_oil_fire.efx");
	level._effect["cold_breath"]			= loadfx ("fx/misc/cold_breath.efx");
	level._effect["exp_pack_doorbreach"]	= loadfx( "fx/explosions/exp_pack_hallway.efx" );

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

exploders()
{
	//Door Breach
	maps\_fx::exploderfx(4, "exp_pack_doorbreach", (7185,-2486,103), 0.1, (7088,-2486,129));
}


spawnWorldFX()
{
	//tank
	maps\_fx::loopfx("tank_fire_turret", (2896,-3431,137), 1, (2904,-3366,212));
	maps\_fx::loopfx("tank_fire_engine", (2911,-3420,151), 1, (2911,-3420,161));
	maps\_fx::loopfx("tank_fire_engine", (2857,-3353,88), 1, (2857,-3353,98));


	//truck1
	maps\_fx::loopfx("tank_fire_engine", (2634,-2992,4), 1, (2634,-2992,14));
	maps\_fx::loopfx("tank_fire_engine", (2591,-2981,5), 1, (2591,-2981,15));
	maps\_fx::loopfx("thin_black_smoke_S", (2584,-2984,6), 0.6, (2584,-2984,16));
	
	//truck2
	//maps\_fx::loopfx("thin_black_smoke_S", (3741,-3170,39), 0.6, (3741,-3170,49));
	
	//building fire
	maps\_fx::loopfx("building_fire_med", (3609,-3530,520), 2, (3510,-3537,534));
	maps\_fx::loopfx("building_fire_med", (3589,-3653,696), 2, (3490,-3650,701));
	maps\_fx::loopfx("building_fire_large", (3675,-3396,696), 2, (3670,-3496,704));
	maps\_fx::loopfx("med_oil_fire", (3626,-3484,911), 2, (3626,-3484,921));
	maps\_fx::loopfx("tank_fire_engine", (3574,-3547,655), 1, (3574,-3547,665));
	maps\_fx::loopfx("tank_fire_engine", (3579,-3507,799), 1, (3579,-3507,809));

	//misc fire and smoke	
	maps\_fx::loopfx("thin_black_smoke_S", (2584,-2984,6), 0.6, (2584,-2984,16));
	maps\_fx::loopfx("thin_black_smoke_S", (3964,-3165,-56), 0.3, (3964,-3165,-46));
	maps\_fx::loopfx("tank_fire_turret", (2896,-3431,137), 1, (2904,-3366,212));
	maps\_fx::loopfx("tank_fire_turret", (6122,-5402,66), 1, (6128,-5404,166));
	maps\_fx::loopfx("thin_black_smoke_S", (6333,-4307,28), 0.6, (6333,-4307,38));
	maps\_fx::loopfx("thin_black_smoke_S", (6167,-2621,20), 0.6, (6167,-2621,30));
	maps\_fx::loopfx("thin_black_smoke_S", (5942,-1811,40), 0.3, (5942,-1811,50));
	maps\_fx::loopfx("tank_fire_engine", (2857,-3353,88), 1, (2857,-3353,98));
	maps\_fx::loopfx("thin_black_smoke_S", (5137,-3867,40), 0.6, (5137,-3867,50));
	maps\_fx::loopfx("tank_fire_engine", (5137,-3840,59), 1, (5137,-3840,69));
	maps\_fx::loopfx("tank_fire_engine", (6227,-5399,11), 1, (6227,-5399,21));
	maps\_fx::loopfx("tank_fire_engine", (6199,-5468,51), 1, (6199,-5468,61));
	maps\_fx::loopfx("tank_fire_engine", (5865,-2620,16), 1, (5865,-2620,26));
	maps\_fx::loopfx("tank_fire_engine", (5769,-2632,16), 1, (5769,-2632,26));
	maps\_fx::loopfx("thin_black_smoke_S", (5857,-2556,24), 0.3, (5857,-2556,34));
	maps\_fx::loopfx("tank_fire_engine", (5828,-2596,48), 1, (5828,-2596,58));
	maps\_fx::loopfx("tank_fire_engine", (5891,-1887,17), 1, (5891,-1887,27));
	maps\_fx::loopfx("tank_fire_engine", (5931,-1875,37), 1, (5931,-1875,47));
	maps\_fx::loopfx("tank_fire_engine", (5927,-1887,5), 1, (5927,-1887,15));
	maps\_fx::loopfx("tank_fire_engine", (6141,-2608,2), 1, (6141,-2608,12));

	
/*
	//Snow Wind original
	maps\_fx::loopfx("snow_wind_cityhall", (1799,-3120,96), 0.3, (1799,-3120,106));
	maps\_fx::loopfx("snow_wind_cityhall", (4862,-3250,63), 0.3, (4862,-3250,73));
	maps\_fx::loopfx("snow_wind_cityhall", (4002,-3099,1), 0.3, (4002,-3099,11));
	maps\_fx::loopfx("snow_wind_cityhall", (3019,-2930,81), 0.3, (3019,-2930,91));
	maps\_fx::loopfx("snow_wind_cityhall", (5721,-4300,111), 0.3, (5721,-4300,121));
	maps\_fx::loopfx("snow_wind_cityhall", (6533,-4980,111), 0.3, (6533,-4980,121));
	maps\_fx::loopfx("snow_wind_cityhall", (5868,-3325,7), 0.3, (5868,-3325,17));
	maps\_fx::loopfx("snow_wind_cityhall", (5654,-1743,150), 0.3, (5654,-1743,160));
	maps\_fx::loopfx("snow_wind_cityhall", (6228,-1790,150), 0.3, (6228,-1790,160));
	maps\_fx::loopfx("snow_wind_cityhall", (6232,-2481,-5), 0.3, (6232,-2481,4));
	maps\_fx::loopfx("snow_wind_cityhall", (6231,-3439,-5), 0.3, (6231,-3439,4));
*/

}

randomSnowWind()
{
	//Snow Wind random....positions are from Original
	index = 0;

	fxorigin [index] = 	(1799,-3120,96);		fxvector [index] =  (1799,-3120,106);	index++;
	fxorigin [index] = 	(4862,-3250,63);		fxvector [index] =  (4862,-3250,73);	index++;
	fxorigin [index] = 	(4002,-3099,1);			fxvector [index] =  (4002,-3099,11);	index++;
	fxorigin [index] = 	(3019,-2930,81);		fxvector [index] =  (3019,-2930,91);	index++;
	fxorigin [index] = 	(5721,-4300,111);		fxvector [index] =  (5721,-4300,121);	index++;
	fxorigin [index] = 	(6533,-4980,111);		fxvector [index] =  (6533,-4980,121);	index++;
	fxorigin [index] = 	(5868,-3325,7);			fxvector [index] =  (5868,-3325,17);	index++;
	fxorigin [index] = 	(5654,-1743,150);		fxvector [index] =  (5654,-1743,160);	index++;
	fxorigin [index] = 	(6228,-1790,150);		fxvector [index] =  (6228,-1790,160);	index++;
	fxorigin [index] = 	(6232,-2481,-5);		fxvector [index] =  (6232,-2481,4);		index++;
	fxorigin [index] = 	(6231,-3439,-5);		fxvector [index] =  (6231,-3439,4);		index++;

	for (i = 0; i < fxorigin.size; i++)
	{
		maps\_fx::gunfireloopfxVec ("snow_wind_cityhall", fxorigin [i], fxvector [i],	// Origin
						1, 100,					// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	}	
}