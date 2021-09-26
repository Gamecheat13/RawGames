#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_newvillers_ext";
	level.ambient_track ["interior"] = "ambient_newvillers_int";
	level.ambient_track ["exteriorlight"] = "ambient_newvillerslight_ext";
	level.ambient_track ["interiorlight"] = "ambient_newvillerslight_int";
	level.ambient_track ["exteriornorain"] = "ambient_newvillersnorain_ext";
	level.ambient_track ["interiornorain"] = "ambient_newvillersnorain_int";
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	1.0);
	ambientEvent("exterior", "elm_windgust2",	1.0);
	ambientEvent("exterior", "elm_windgust3",	1.0);
	/*
	ambientEvent("exterior", "elm_thunder1",	3.0);
	ambientEvent("exterior", "elm_thunder2",	3.0);
	ambientEvent("exterior", "elm_thunder3",	3.0);
	ambientEvent("exterior", "elm_thunder4",	3.0);
	*/
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

	ambientDelay("exteriorlight", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exteriorlight", "elm_windgust1",	1.0);
	ambientEvent("exteriorlight", "elm_windgust2",	1.0);
	ambientEvent("exteriorlight", "elm_windgust3",	1.0);
	/*
	ambientEvent("exteriorlight", "elm_thunder1",	2.0);
	ambientEvent("exteriorlight", "elm_thunder2",	2.0);
	ambientEvent("exteriorlight", "elm_thunder3",	2.0);
	ambientEvent("exteriorlight", "elm_thunder4",	2.0);
	*/
	ambientEvent("exteriorlight", "elm_distant_explod1",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod2",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod3",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod4",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod5",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod6",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod7",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod8",	0.9);
	ambientEvent("exteriorlight", "elm_battle_bren1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren3",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren4",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren5",	0.5);
	ambientEvent("exteriorlight", "elm_battle_mp40_1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_mp40_2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_mp40_3",	0.5);
	ambientEvent("exteriorlight", "elm_battle_sten1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_sten2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle3",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle4",	0.5);
	ambientEvent("exteriorlight", "null",			0.3);

	ambientDelay("exteriornorain", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exteriornorain", "elm_windgust1",	1.0);
	ambientEvent("exteriornorain", "elm_windgust2",	1.0);
	ambientEvent("exteriornorain", "elm_windgust3",	1.0);
	ambientEvent("exteriornorain", "elm_thunder1",	1.0);
	ambientEvent("exteriornorain", "elm_thunder2",	1.0);
	ambientEvent("exteriornorain", "elm_thunder3",	1.0);
	ambientEvent("exteriornorain", "elm_thunder4",	1.0);
	ambientEvent("exteriornorain", "elm_distant_explod1",	0.9);
	ambientEvent("exteriornorain", "elm_distant_explod2",	0.9);
	ambientEvent("exteriornorain", "elm_distant_explod3",	0.9);
	ambientEvent("exteriornorain", "elm_distant_explod4",	0.9);
	ambientEvent("exteriornorain", "elm_distant_explod5",	0.9);
	ambientEvent("exteriornorain", "elm_distant_explod6",	0.9);
	ambientEvent("exteriornorain", "elm_distant_explod7",	0.9);
	ambientEvent("exteriornorain", "elm_distant_explod8",	0.9);
	ambientEvent("exteriornorain", "elm_battle_bren1",	0.5);
	ambientEvent("exteriornorain", "elm_battle_bren2",	0.5);
	ambientEvent("exteriornorain", "elm_battle_bren3",	0.5);
	ambientEvent("exteriornorain", "elm_battle_bren4",	0.5);
	ambientEvent("exteriornorain", "elm_battle_bren5",	0.5);
	ambientEvent("exteriornorain", "elm_battle_mp40_1",	0.5);
	ambientEvent("exteriornorain", "elm_battle_mp40_2",	0.5);
	ambientEvent("exteriornorain", "elm_battle_mp40_3",	0.5);
	ambientEvent("exteriornorain", "elm_battle_sten1",	0.5);
	ambientEvent("exteriornorain", "elm_battle_sten2",	0.5);
	ambientEvent("exteriornorain", "elm_battle_rifle1",	0.5);
	ambientEvent("exteriornorain", "elm_battle_rifle2",	0.5);
	ambientEvent("exteriornorain", "elm_battle_rifle3",	0.5);
	ambientEvent("exteriornorain", "elm_battle_rifle4",	0.5);
	ambientEvent("exteriornorain", "null",			0.3);

	ambientDelay("interior", 18.0, 30.0); // Trackname, min and max delay between ambient events
	/*
	ambientEvent("interior", "elm_thunder1",	3.0);
	ambientEvent("interior", "elm_thunder2",	3.0);
	ambientEvent("interior", "elm_thunder3",	3.0);
	ambientEvent("interior", "elm_thunder4",	3.0);
	*/
	ambientEvent("interior", "elm_distant_explod1",	0.9);
	ambientEvent("interior", "elm_distant_explod2",	0.9);
	ambientEvent("interior", "elm_distant_explod3",	0.9);
	ambientEvent("interior", "elm_distant_explod4",	0.9);
	ambientEvent("interior", "elm_distant_explod5",	0.9);
	ambientEvent("interior", "elm_distant_explod6",	0.9);
	ambientEvent("interior", "elm_distant_explod7",	0.9);
	ambientEvent("interior", "elm_distant_explod8",	0.9);
	ambientEvent("interior", "null",			0.3);

	ambientDelay("interiorlight", 18.0, 30.0); // Trackname, min and max delay between ambient events
	/*
	ambientEvent("interiorlight", "elm_thunder1",	2.0);
	ambientEvent("interiorlight", "elm_thunder2",	2.0);
	ambientEvent("interiorlight", "elm_thunder3",	2.0);
	ambientEvent("interiorlight", "elm_thunder4",	2.0);
	*/
	ambientEvent("interiorlight", "elm_distant_explod1",	0.9);
	ambientEvent("interiorlight", "elm_distant_explod2",	0.9);
	ambientEvent("interiorlight", "elm_distant_explod3",	0.9);
	ambientEvent("interiorlight", "elm_distant_explod4",	0.9);
	ambientEvent("interiorlight", "elm_distant_explod5",	0.9);
	ambientEvent("interiorlight", "elm_distant_explod6",	0.9);
	ambientEvent("interiorlight", "elm_distant_explod7",	0.9);
	ambientEvent("interiorlight", "elm_distant_explod8",	0.9);
	ambientEvent("interiorlight", "null",			0.3);

	ambientDelay("interiornorain", 18.0, 30.0); // Trackname, min and max delay between ambient events
	ambientEvent("interiornorain", "elm_thunder1",	1.0);
	ambientEvent("interiornorain", "elm_thunder2",	1.0);
	ambientEvent("interiornorain", "elm_thunder3",	1.0);
	ambientEvent("interiornorain", "elm_thunder4",	1.0);
	ambientEvent("interiornorain", "elm_distant_explod1",	0.9);
	ambientEvent("interiornorain", "elm_distant_explod2",	0.9);
	ambientEvent("interiornorain", "elm_distant_explod3",	0.9);
	ambientEvent("interiornorain", "elm_distant_explod4",	0.9);
	ambientEvent("interiornorain", "elm_distant_explod5",	0.9);
	ambientEvent("interiornorain", "elm_distant_explod6",	0.9);
	ambientEvent("interiornorain", "elm_distant_explod7",	0.9);
	ambientEvent("interiornorain", "elm_distant_explod8",	0.9);
	ambientEvent("interiornorain", "null",			0.3);

	thread ambientEventStart("exterior");

	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1265,-1813,-68));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-44,-1636,-89));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (121,-2289,-96));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-561,-1958,-92));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-955,-1609,72));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1784,-1768,-87));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-474,1587,309));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1254,1236,198));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-2064,1175,129));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-3419,2314,283));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-4811,2185,9));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-3990,2721,40));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-558,5469,155));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (3,5278,159));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1016,5270,171));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1477,3488,136));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (581,2640,330));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (452,1394,142));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-847,2925,200));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (148,-1132,123));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (344,-165,133));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (140,429,200));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (225,773,109));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-10,-248,138));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-109,-900,135));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-968,513,284));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1075,98,275));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1550,-282,85));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-652,229,264));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-776,-165,417));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-755,-1271,157));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1025,-909,168));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1828,-972,219));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1641,-1277,233));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1904,-373,91));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3129,353,86));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2106,400,218));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2910,704,164));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2017,1645,254));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2675,929,166));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2505,1470,55));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2827,1230,85));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2844,1692,266));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1186,2426,112));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1120,2802,313));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1458,2700,326));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1974,2953,264));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1989,2643,140));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2139,2397,108));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2498,2994,345));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2289,2687,152));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1993,3228,145));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1793,489,212));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (517,1929,315));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (488,3034,344));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (635,3273,347));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (280,3322,348));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-417,3306,203));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-800,4652,370));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1147,4625,385));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1886,4390,323));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-1878,5012,314));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2268,4457,330));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-2277,4973,321));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3058,3933,284));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3825,678,24));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3596,360,229));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-4316,1181,229));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3453,672,236));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3191,1207,94));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3175,1677,274));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (192,4793,245));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-384,2414,296));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-3173,2992,282));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (432,-110,-94));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-260,1923,52));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-821,2370,32));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-1925,2261,5));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (788,4177,107));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (1051,4379,87));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (777,4459,97));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-380,4882,112));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-475,5156,130));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-554,4983,107));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-468,4629,113));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-634,4783,116));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-3212,2207,-55));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-3960,2054,168));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-90,-1249,6));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-1227,-1347,-107));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-140,425,29));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-147,658,29));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-2697,812,23));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-2694,555,27));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-3088,3064,59));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-3236,4139,145));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (670,5076,126));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (1775,4265,117));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (1036,4134,66));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (371,4415,41));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (401,4218,141));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (526,4408,181));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (309,4118,185));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-177,2718,114));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-350,2716,114));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-1008,2351,35));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-2901,3096,27));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (319,7,-93));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-377,4797,107));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1224,-1233,-64));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (732,-1731,90));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-1492,-3341,-134));
	/*
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-1122,-3162,-138));
	*/
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1598,-3640,-153));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1005,-3388,-148));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1734,-3148,-109));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1156,-2868,-115));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-587,-3068,-154));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-261,-2724,-133));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-731,-2462,-118));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (693,-2466,-74));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (463,-2106,76));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1051,-1123,106));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (530,-741,-154));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (14,-576,-111));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (101,346,-151));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (70,421,22));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-316,918,-109));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-268,1091,-48));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-44,1254,-45));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (9,2241,-27));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-131,1982,-2));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-90,2343,-7));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-284,2302,3));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-141,2191,-4));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-944,2383,31));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-628,2681,29));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-379,2518,100));
	maps\_fx::rainfx("emt_rain_roof", "emt_lightrain_roof", (-104,2479,305));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-1109,1993,-14));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-135,2976,-21));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (628,2392,118));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (993,2715,116));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1654,3946,131));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1710,4593,135));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (1603,5092,114));
	maps\_fx::rainfx("emt_rain_foliage", "emt_lightrain_foliage", (-410,3866,405));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (429,5051,165));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-2926,262,-58));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-2589,191,-94));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-203,-1037,6));
	maps\_fx::rainfx("emt_rain_wood", "emt_lightrain_wood", (-690,927,-145));
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-562,-896,-112));
	/*
	maps\_fx::rainfx("emt_rain_metal", "emt_lightrain_metal", (-1390,-758,-54));
	*/

}	
	
