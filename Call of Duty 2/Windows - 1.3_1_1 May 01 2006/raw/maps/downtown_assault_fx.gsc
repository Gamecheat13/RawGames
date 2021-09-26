main()
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

	//effect precache
	level._effect["heavysmoke"]					= loadfx ("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect["snow_light"]					= loadfx ("fx/misc/snow_light.efx");
	level._effect["molotov_fire"]				= loadfx ("fx/fire/ground_fire_med.efx");
	level._effect["sticky_explosion"]			= loadfx ("fx/explosions/default_explosion.efx");
	level._effect["sticky_explosion_smoke"]		= loadfx ("fx/smoke/thin_black_smoke_S.efx");
	level._effect["damaged_vehicle_smoke"]		= loadfx ("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect["city_smoke"]					= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["ammo_explosion"]				= loadfx ("fx/explosions/eldaba_boat_explosion.efx");
	level._effect["spark_explosion"]			= loadfx ("fx/explosions/ammo_supply_exp.efx");
	level._effect["ammo_smoke"]					= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["fire_burst"]					= loadfx ("fx/explosions/exp_pack_buildingwindow.efx");
	level._effect["brick"]						= loadfx ("fx/impacts/large_brick.efx");
	level._effect["dust"]						= loadfx ("fx/explosions/pschreck_dirt_crossroads.efx");
	level._effect["wall_explosion"]				= loadfx ("fx/explosions/pschreck_dirt_crossroads.efx");
	level._effect["cold_breath"]				= loadfx ("fx/misc/cold_breath.efx");

	level._effect["smoke_ball"]					= loadfx ("fx/smoke/black_smoke_ball.efx");
	
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M.efx");
	level._effect["snow_wind_cityhall"]			= loadfx ("fx/misc/snow_wind_cityhall.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["tank_fire_turret"] 			= loadfx ("fx/fire/tank_fire_turret_small.efx");


	level thread playerEffect();
	ambientFX();
	exploderFX();
	treadFX();

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

ambientFX()
{
	//rooftop smoke
	maps\_fx::loopfx("city_smoke", (4659,934,509), 0.6, (4659,934,609));
	maps\_fx::loopfx("city_smoke", (3810,-180,1051), 0.6, (3810,-180,1151));
	
	//crater smoke
	maps\_fx::loopfx("thin_light_smoke_M", (1436,141,1), 1, (1436,141,101));
	maps\_fx::loopfx("thin_light_smoke_M", (808,1583,36), 1, (808,1583,136));
	maps\_fx::loopfx("thin_light_smoke_M", (-1389,-2008,-34), 1, (-1389,-2008,65));
	maps\_fx::loopfx("thin_light_smoke_M", (-1017,-2419,-42), 1, (-1017,-2419,57));
	maps\_fx::loopfx("thin_light_smoke_M", (1840,354,-7), 1, (1840,354,92));
	maps\_fx::loopfx("thin_light_smoke_M", (3546,506,-30), 1, (3546,506,69));
	maps\_fx::loopfx("thin_light_smoke_M", (2863,-31,-26), 1, (2863,-31,73));

	//fires
	maps\_fx::loopfx("tank_fire_engine", (-806,-2754,49), 1, (-806,-2754,149));
	maps\_fx::loopfx("tank_fire_engine", (-811,-2685,33), 1, (-811,-2685,133));
	maps\_fx::loopfx("tank_fire_engine", (-851,-2740,33), 1, (-851,-2740,133));
	maps\_fx::loopfx("tank_fire_engine", (-935,-1301,25), 1, (-935,-1301,125));
	maps\_fx::loopfx("tank_fire_engine", (-1433,-594,150), 1, (-1433,-594,250));
	maps\_fx::loopfx("tank_fire_turret", (-710,-2787,59), 1, (-725,-2769,156));
	maps\_fx::loopfx("tank_fire_turret", (-905,-1264,79), 1, (-902,-1252,178));


	maps\_fx::loopfx("snow_wind_cityhall", (-1089,-1497,81), 0.6, (-1089,-1497,181));
	maps\_fx::loopfx("snow_wind_cityhall", (-764,-1494,9), 0.6, (-764,-1494,109));
	maps\_fx::loopfx("snow_wind_cityhall", (-646,-2671,9), 0.6, (-646,-2671,109));
	maps\_fx::loopfx("snow_wind_cityhall", (-1219,-2113,2), 0.6, (-1219,-2113,102));
	maps\_fx::loopfx("snow_wind_cityhall", (-1123,-683,76), 0.6, (-1123,-683,176));
	maps\_fx::loopfx("snow_wind_cityhall", (-932,469,46), 0.6, (-932,469,146));
	maps\_fx::loopfx("snow_wind_cityhall", (-139,169,88), 0.6, (-139,169,188));
	maps\_fx::loopfx("snow_wind_cityhall", (-770,1746,-5), 0.6, (-770,1746,94));
	maps\_fx::loopfx("snow_wind_cityhall", (-1254,1734,6), 0.6, (-1254,1734,106));
	maps\_fx::loopfx("snow_wind_cityhall", (-1007,1057,-6), 0.6, (-1007,1057,93));
	maps\_fx::loopfx("snow_wind_cityhall", (1497,1449,28), 0.6, (1497,1449,128));
	maps\_fx::loopfx("snow_wind_cityhall", (1486,2285,85), 0.6, (1486,2285,185));
	maps\_fx::loopfx("snow_wind_cityhall", (1937,893,-5), 0.6, (1937,893,94));
	maps\_fx::loopfx("snow_wind_cityhall", (2328,460,25), 0.6, (2328,460,125));
	maps\_fx::loopfx("snow_wind_cityhall", (2921,441,19), 0.6, (2921,441,119));
	maps\_fx::loopfx("snow_wind_cityhall", (3669,891,8), 0.6, (3669,891,108));
	maps\_fx::loopfx("snow_wind_cityhall", (3129,-305,-3), 0.6, (3129,-305,96));
	maps\_fx::loopfx("snow_wind_cityhall", (1482,163,58), 0.6, (1482,163,158));
	maps\_fx::loopfx("snow_wind_cityhall", (1958,51,44), 0.6, (1958,51,144));
	maps\_fx::loopfx("snow_wind_cityhall", (847,814,14), 0.6, (847,814,114));
	maps\_fx::loopfx("snow_wind_cityhall", (838,-39,1), 0.6, (838,-39,101));

}

exploderFX()
{
	//downtown_assault first building that a tank shoots into
	maps\_fx::exploderfx(15,"fire_burst",(-1518,-28,253), 0.1, (-1298,-24,316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"fire_burst",(-1518,-174,253), 0.2, (-1298,-170,316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"fire_burst",(-1598,-236,241), 0.3, (-1594,-456,304), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"fire_burst",(-1516,114,253), undefined, (-1296,118,316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,undefined,(-1609,-139,224), 0, (-1609,-134,324), undefined, undefined, undefined, undefined, "explosion", 350, undefined, undefined, undefined, undefined, 384, undefined);
	maps\_fx::exploderfx(15,undefined,(-1615,-37,224), 0, (-1609,-134,324), undefined, undefined, undefined, undefined, "explosion", 350, undefined, undefined, undefined, undefined, 384, undefined);
	maps\_fx::exploderfx(15,undefined,(-1617,91,224), 0, (-1609,-134,324), undefined, undefined, undefined, undefined, "explosion", 350, undefined, undefined, undefined, undefined, 384, undefined);
	maps\_fx::exploderfx(15,"smoke_ball",(-1681,42,224), 0.4, (-1675,-54,324), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"smoke_ball",(-1569,45,224), 0.4, (-1563,-51,324), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"smoke_ball",(-1550,-65,224), 0.5, (-1544,-162,324), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"smoke_ball",(-1662,-85,224), 0.5, (-1656,-182,324), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"smoke_ball",(-1690,-197,224), 0.5, (-1684,-294,324), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"smoke_ball",(-1562,-194,224), 0.7, (-1556,-291,324), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(15,"smoke_ball",(-1608,-291,224), 0.7, (-1602,-388,324), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	
	maps\_fx::exploderfx(12,"dust",(322,824,293), 0, (278,861,375), undefined, undefined, undefined, undefined, "explosion", 350, undefined, undefined, undefined, undefined, 150, undefined);
	maps\_fx::exploderfx(12, undefined, 	(328, 881, 302), 0.0, (328, 881, 402), undefined, undefined, undefined, undefined, "explosion", 550, undefined, undefined, undefined, undefined, 150);
	
	maps\_fx::exploderfx(0,"wall_explosion",(2137,-279,67), 0, (2137,-279,167));
	maps\_fx::exploderfx(3,"wall_explosion",(2014,22,63), 0, (2014,22,163));
	maps\_fx::exploderfx(4,"wall_explosion",(2005,215,78), 0, (2005,215,178));
	maps\_fx::exploderfx(5,"wall_explosion",(2014,402,59), 0, (2014,402,159));
	maps\_fx::exploderfx(6,"wall_explosion",(1684,-183,73), 0, (1684,-183,173));
	maps\_fx::exploderfx(7,"wall_explosion",(1685,-13,84), 0, (1685,-13,184));
	maps\_fx::exploderfx(8,"wall_explosion",(1684,127,77), 0, (1684,127,177));
	maps\_fx::exploderfx(9,"wall_explosion",(1685,268,70), 0, (1685,268,170));
	maps\_fx::exploderfx(11,"wall_explosion",(2102,483,60), 0, (2102,483,160));
	maps\_fx::exploderfx(13,"wall_explosion",(2010,-225,72), 0, (2010,-225,172));
	maps\_fx::exploderfx(14,"wall_explosion",(2014,-117,73), 0, (2014,-117,173));
	maps\_fx::exploderfx(10,"wall_explosion",(1686,410,70), 0, (1686,410,170));
	maps\_fx::exploderfx(11,undefined,(2103,462,60), 0, (2103,462,160), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(11,undefined,(2107,530,60), 0, (2107,530,160), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(5,undefined,(2045,402,59), 0, (2045,402,159), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(5,undefined,(1982,401,59), 0, (1982,401,159), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(4,undefined,(2037,216,78), 0, (2037,216,178), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(4,undefined,(1989,215,78), 0, (1989,215,178), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(3,undefined,(2030,22,63), 0, (2030,22,163), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(3,undefined,(1998,22,63), 0, (1998,22,163), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(14,undefined,(2030,-116,73), 0, (2030,-116,173), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(14,undefined,(1998,-117,73), 0, (1998,-117,173), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(13,undefined,(2025,-225,72), 0, (2025,-225,172), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(13,undefined,(1994,-224,72), 0, (1994,-224,172), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(0,undefined,(2137,-294,67), 0, (2137,-294,167), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(0,undefined,(2136,-263,67), 0, (2136,-263,167), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(6,undefined,(1668,-182,73), 0, (1668,-182,173), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(6,undefined,(1699,-183,73), 0, (1699,-183,173), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(7,undefined,(1700,-13,84), 0, (1700,-13,184), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(7,undefined,(1669,-12,84), 0, (1669,-12,184), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(8,undefined,(1668,127,77), 0, (1668,127,177), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(8,undefined,(1699,126,77), 0, (1699,126,177), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(9,undefined,(1669,268,70), 0, (1669,268,170), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(9,undefined,(1700,267,70), 0, (1700,267,170), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(10,undefined,(1670,409,70), 0, (1670,409,170), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);
	maps\_fx::exploderfx(10,undefined,(1701,410,70), 0, (1701,410,170), undefined, undefined, undefined, undefined, undefined, 150, undefined, undefined, undefined, undefined, 200, undefined);


	//Ammo Depot Explosions
	
	maps\_fx::exploderfx(1,"spark_explosion",(1711,2173,149), 2, (1703,2203,368), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"spark_explosion",(1696,1201,158), 0.75, (1756,1297,386), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"spark_explosion",(1750,1729,146), 0, (1826,1723,374), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"spark_explosion",(1896,2111,311), 2.5, (1927,2106,539), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"spark_explosion",(1873,1377,146), 0, (1849,1357,374), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"spark_explosion",(1789,1908,326), 1.2, (1781,1938,514), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);

	maps\_fx::exploderfx(2,"fire_burst",(1713,1470,159), 0, (1614,1479,159), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1776,1734,321), 0.2, (1556,1730,384), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1776,1858,321), 0.3, (1556,1854,384), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1765,2054,123), 0.4, (1545,2050,186), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1721,1732,155), 0.5, (1621,1740,153), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1776,2182,321), 0.6, (1556,2202,384), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1777,2183,132), 0.7, (1557,2186,186), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1859,2223,321), 0.8, (1841,2443,384), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"fire_burst",(1863,2219,124), 0.9, (1845,2439,184), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"ammo_explosion",(2004,1943,417), 1, (2000,1948,516), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"spark_explosion",(1896,2111,311), 1.7, (1927,2106,539), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"spark_explosion",(1873,1377,146), 2, (1849,1357,374), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(2,"spark_explosion",(1789,1908,326), 2.8, (1781,1938,514), undefined, undefined, undefined, undefined, undefined, undefined, "grenade_explode_default", undefined, undefined, undefined, undefined, undefined);

	maps\_fx::exploderfx(2,undefined,(1426,1580,238), undefined, (1426,1580,338), undefined, undefined, undefined, undefined, undefined, undefined, "explo_ammo_dump", undefined, undefined, undefined, undefined, undefined);
	
//	maps\_fx::exploderfx(2, undefined, (1789, 1738, 127), 4, (1569, 1734, 190), "ammo_smoke", 0.5, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, 15);
//	maps\_fx::exploderfx(2, undefined, (1765, 1342, 127), 4, (1545, 1338, 190), "ammo_smoke", 0.5, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, 15);
//	maps\_fx::exploderfx(2, undefined, (1943, 2135, 135), 4, (1829, 2324, 190), "ammo_smoke", 0.5, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, 15);
}

treadFX()
{
	
	//This overrides the default effects for treads for this level only

	//panzer
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
	maps\_treadfx::setVehicleFX("jeep",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"asphalt",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"carpet",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"cloth",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"sand",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"grass",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"gravel",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"mud",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"plaster",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"rock",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"wood",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"brick",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"concrete",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("jeep",	"foliage",	"fx/dust/tread_dust_snow.efx");

}