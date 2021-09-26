#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_crossroads_ext";
	level.ambient_track ["interior"] = "ambient_crossroads_int";
	level.ambient_track ["exteriornorain"] = "ambient_crossroadsnorain_ext";
	level.ambient_track ["interiornorain"] = "ambient_crossroadsnorain_int";
	
	
	level.ambient_track ["exteriorlight"] = "ambient_crossroadsnorain_ext";
	level.ambient_track ["interiorlight"] = "ambient_crossroadsnorain_int";
	
	thread maps\_utility::set_ambient("interior");
		
	ambientDelay("exterior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	1.0);
	ambientEvent("exterior", "elm_windgust2",	1.0);
	ambientEvent("exterior", "elm_windgust3",	1.0);
	ambientEvent("exterior", "elm_thunder1",	3.0);
	ambientEvent("exterior", "elm_thunder2",	3.0);
	ambientEvent("exterior", "elm_thunder3",	3.0);
	ambientEvent("exterior", "elm_thunder4",	3.0);
	ambientEvent("exterior", "elm_distant_explod1",	0.9);
	ambientEvent("exterior", "elm_distant_explod2",	0.9);
	ambientEvent("exterior", "elm_distant_explod3",	0.9);
	ambientEvent("exterior", "elm_distant_explod4",	0.9);
	ambientEvent("exterior", "elm_distant_explod5",	0.9);
	ambientEvent("exterior", "elm_distant_explod6",	0.9);
	ambientEvent("exterior", "elm_distant_explod7",	0.9);
	ambientEvent("exterior", "elm_distant_explod8",	0.9);
	ambientEvent("exterior", "elm_battle_bren1",	0.5);
	ambientEvent("exterior", "elm_battle_bren2",	0.5);
	ambientEvent("exterior", "elm_battle_bren3",	0.5);
	ambientEvent("exterior", "elm_battle_bren4",	0.5);
	ambientEvent("exterior", "elm_battle_bren5",	0.5);
	ambientEvent("exterior", "elm_battle_mp40_1",	0.5);
	ambientEvent("exterior", "elm_battle_mp40_2",	0.5);
	ambientEvent("exterior", "elm_battle_mp40_3",	0.5);
	ambientEvent("exterior", "elm_battle_sten1",	0.5);
	ambientEvent("exterior", "elm_battle_sten2",	0.5);
	ambientEvent("exterior", "elm_battle_rifle1",	0.5);
	ambientEvent("exterior", "elm_battle_rifle2",	0.5);
	ambientEvent("exterior", "elm_battle_rifle3",	0.5);
	ambientEvent("exterior", "elm_battle_rifle4",	0.5);
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("interior", 18.0, 30.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior", "elm_thunder1",	3.0);
	ambientEvent("interior", "elm_thunder2",	3.0);
	ambientEvent("interior", "elm_thunder3",	3.0);
	ambientEvent("interior", "elm_thunder4",	3.0);
	ambientEvent("interior", "elm_distant_explod1",	0.9);
	ambientEvent("interior", "elm_distant_explod2",	0.9);
	ambientEvent("interior", "elm_distant_explod3",	0.9);
	ambientEvent("interior", "elm_distant_explod4",	0.9);
	ambientEvent("interior", "elm_distant_explod5",	0.9);
	ambientEvent("interior", "elm_distant_explod6",	0.9);
	ambientEvent("interior", "elm_distant_explod7",	0.9);
	ambientEvent("interior", "elm_distant_explod8",	0.9);
	ambientEvent("interior", "null",			0.3);

	level.ambienteventent["interiorlight"] = level.ambienteventent["interior"];
	level.ambienteventent["exteriorlight"] = level.ambienteventent["exterior"];
	level.ambienteventent["interiornorain"] = level.ambienteventent["interior"];
	level.ambienteventent["exteriornorain"] = level.ambienteventent["exterior"];

	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (66,-74,167));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (18,-622,218));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-312,26,215));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (214,227,151));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (401,124,153));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (643,932,215));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (569,1225,211));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (851,505,231));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (1288,980,201));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (1323,1717,221));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-45,612,173));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-355,799,166));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1004,660,133));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-747,322,163));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-289,1450,165));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (37,1555,157));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (735,2784,108));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (1092,2809,105));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (2096,4273,154));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (2182,3713,140));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (1621,3621,167));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (1531,4104,178));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (1766,2506,167));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (1918,2249,173));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (21,2578,222));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-745,3292,281));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-380,3948,277));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-430,4586,260));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (438,4445,299));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (539,3946,335));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-621,5360,276));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1200,5666,261));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-528,5847,267));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (58,5833,231));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (3452,5141,332));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (3190,4231,311));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (2098,3036,224));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (2663,2657,230));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1156,2878,200));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1242,2605,37));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1321,2298,142));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-838,1896,235));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-643,2129,245));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-906,1440,56));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (13,3687,294));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (893,4917,205));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (751,5970,309));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1632,6277,325));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (2676,5594,260));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (2275,4684,153));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (2916,4011,159));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (2625,3702,25));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1904,3398,-25));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1146,3181,27));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1983,5195,-13));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (128,5157,82));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1020,1855,96));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-250,1886,51));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-19,2171,1));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1056,2132,32));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-630,937,162));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-490,2720,17));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (262,858,-1));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1521,415,203));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (446,-487,51));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (982,1446,32));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1288,2201,-145));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (529,1680,-11));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (355,1415,11));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (892,923,-118));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (1026,1137,-99));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (1241,1635,-143));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (744,1806,-132));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-312,5449,-87));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-40,5762,-95));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (1126,4680,-45));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (2302,2672,-76));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-989,5982,-68));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (822,599,-114));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (520,2183,-127));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (378,2148,-143));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (1516,2371,-105));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-948,2935,-19));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-1057,2957,-135));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-16,4151,-76));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-308,5106,-109));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (61,5460,-91));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (1368,4814,-69));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (2079,4321,-71));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (1415,4031,-49));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (993,4638,-27));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-128,1879,-144));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-472,2421,-136));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-521,1876,-127));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-750,1499,-137));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (1573,5077,-56));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-276,4757,-89));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (997,3125,-129));
	
	thread ambientEventStart("interior");
	
	maps\_fx::soundfx("medfire", (-997,2749,61));
	maps\_fx::soundfx("medfire", (-913,2997,-6));
	maps\_fx::soundfx("medfire", (-1038,2772,45));
	
	
	
}	
	
