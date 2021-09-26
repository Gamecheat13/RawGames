#include maps\_weather;
main()
{
	precacheFX();
	treadFX();
	exploderFX();
	ambientFX();
	thread soundFX();

	thread rainControl(); // level specific rain settings.
	thread playerWeather(); // make the actual rain effect generate around the player
//	thread playerEffect();
}

rainControl()
{
	// Rain
	level._effect["rain_heavy_cloudtype"]	= loadfx ("fx/misc/rain_heavy_cloudtype.efx");
	level._effect["rain_10"]	= loadfx ("fx/misc/rain_heavy.efx");
	level._effect["rain_9"]		= loadfx ("fx/misc/rain_9.efx");
	level._effect["rain_8"]		= loadfx ("fx/misc/rain_8.efx");
	level._effect["rain_7"]		= loadfx ("fx/misc/rain_7.efx");
	level._effect["rain_6"]		= loadfx ("fx/misc/rain_6.efx");
	level._effect["rain_5"]		= loadfx ("fx/misc/rain_5.efx");
	level._effect["rain_4"]		= loadfx ("fx/misc/rain_4.efx");
	level._effect["rain_3"]		= loadfx ("fx/misc/rain_3.efx");
	level._effect["rain_2"]		= loadfx ("fx/misc/rain_2.efx");
	level._effect["rain_1"]		= loadfx ("fx/misc/rain_1.efx");
	level._effect["rain_0"]		= loadfx ("fx/misc/rain_0.efx");

	// controls the temperment of the weather
	rainInit("hard"); // "none" "light" or "hard"
	level waittill("light rain");
	rainLight(15);
	level waittill("no rain");
	rainNone(30);
}

precacheFX()
{
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_water.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_water.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_water.efx"));

	// rain fx
	level._effect["rain_heavy"]			= loadfx ("fx/misc/rain_heavy.efx");
	level._effect["rain_heavy_cloudtype"]		= loadfx ("fx/misc/rain_heavy_cloudtype.efx");
	//level._effect["rain_mist"]			= loadfx ("fx/misc/rain_mist.efx");
	// smoke fx
	level._effect["marker_smoke"]			= loadfx ("fx/smoke/green_smoke_40sec_duhoc.efx");

	// exploder fx
	level._effect["tree_explosion"]			= loadfx("fx/explosions/tree_burst.efx");
	level._effect["spitfire_bomb"]			= loadfx("fx/explosions/spitfire_bomb_dirt.efx");
	level._effect["mortar_impact"]			= loadfx("fx/explosions/mortarExp_dirt.efx");

	//ambient fx
	//level._effect["fogbank_large_duhoc"]		= loadfx ("fx/misc/fogbank_large_duhoc.efx");
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["fogbank_hidecliff_duhoc"]	= loadfx ("fx/misc/fogbank_hidecliff_duhoc.efx");

	level._effect["thin_black_smoke_M"]		= loadfx ("fx/smoke/thin_black_smoke_M_duhoc.efx");
	level._effect["thin_light_smoke_L"]		= loadfx ("fx/smoke/thin_light_smoke_L_duhoc.efx");
	level._effect["thin_light_smoke_M"]		= loadfx ("fx/smoke/thin_light_smoke_M_duhoc.efx");

}

playerEffect()
{
	level endon("stop rain");
	player = getent("player","classname");
	level.heavy_rain = true;
	
	while(true)
	{
		playfx ( level._effect["rain_heavy"], player.origin + (0,0,650));
		if (level.heavy_rain)
		{
			playfx ( level._effect["rain_heavy_cloudtype"], player.origin + (0,0,650));
			// playfx ( level._effect["rain_mist"], player.origin + (0,0,350), player.origin + (0,0,380) );
		}

		wait (0.3);
	}
}

soundFX()
{
	waittillframeend;

	level.scr_sound ["explo_rock"]			= "explo_rock";
	level.scr_sound ["tree_burst"]			= "explo_tree";
	level.scr_sound ["spitfire_plane_loop"] 	= "spitfire_plane_loop";
	level.scr_sound ["plane_flyby_spitfire1"] 	= "plane_flyby_spitfire1";
	level.scr_sound ["plane_flyby_spitfire2"] 	= "plane_flyby_spitfire2";
	level.scr_sound ["plane_flyby_spitfire3"] 	= "plane_flyby_spitfire3";
	level.scr_sound ["mud_impact"]			= "mortar_explosion_dirt";
	level.scr_sound ["mortar_incoming"]		= "mortar_incoming1_new";


}

treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	//GermanHalfTrack fx
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"water",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"dirt",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"asphalt",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"sand",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"grass",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"gravel",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"mud",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"plaster",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"rock",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"foliage",	undefined);
}

exploderFX()
{
	//Smoke marker
	maps\_fx::exploderfx(7,"marker_smoke",(3813,-3581,1153), 0, (3812,-3575,1252), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	// mortar explosions incoming sounds
	maps\_fx::exploderfx(11, undefined, (640, 5984, 1103),  0,   (640, 5984, 1153), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (306, 5988, 1082),  2,   (306, 5988, 1132), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (-192, 6080, 1038), 2.5, (-192, 6080, 1088), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (672, 6240, 1104),  3.5, (672, 6240, 1154), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (1022, 5978, 1165), 5,   (1022, 5978, 1215), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (512, 6112, 1068),  7.5, (512, 6112, 1118), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (-256, 5584, 1080), 8,   (-256, 5584, 1130), undefined,undefined,undefined,"mortar_incoming",undefined);

	// addition
	maps\_fx::exploderfx(11, undefined, (-372, 5049, 1200), 4,  (-372, 5049, 1250), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (64, 5169, 1211),   6,  (64, 5169, 1261), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (276, 5317, 1152),  9,  (276, 5317, 1202), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (360, 5601, 1164),  11, (360, 5601, 1214), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (652, 5533, 1210),  13, (652, 5533, 1260), undefined,undefined,undefined,"mortar_incoming",undefined);
	maps\_fx::exploderfx(11, undefined, (-92, 5501, 1133),  15, (-92, 5501, 1183), undefined,undefined,undefined,"mortar_incoming",undefined);

	// mortar explosions
	maps\_fx::exploderfx(11, "mortar_impact", (640, 5984, 1103),  1,   (640, 5984, 1153), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (306, 5988, 1082),  3,   (306, 5988, 1132), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (-192, 6080, 1038), 3.5, (-192, 6080, 1088), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (672, 6240, 1104),  4.5, (672, 6240, 1154), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (1022, 5978, 1165), 6,   (1022, 5978, 1215), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (512, 6112, 1068),  8.5, (512, 6112, 1118), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (-256, 5584, 1080), 9,   (-256, 5584, 1130), undefined,undefined,undefined,"mud_impact",undefined,150);

	// addition
	maps\_fx::exploderfx(11, "mortar_impact", (-372, 5049, 1200), 5,    (-372, 5049, 1250), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (64, 5169, 1211),   7,    (64, 5169, 1261), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (276, 5317, 1152),  10,   (276, 5317, 1202), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (360, 5601, 1164),  12,   (360, 5601, 1214), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (652, 5533, 1210),  14, (652, 5533, 1260), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(11, "mortar_impact", (-92, 5501, 1133),  16,   (-92, 5501, 1183), undefined,undefined,undefined,"mud_impact",undefined,150);

//	exploderfx(num, fxId, fxPos, waittime, fxPos2, fireFx, fireFxDelay, fireFxSound, fxSound, fxQuake, fxDamage)

	//spitfire bombs plane 1
	maps\_fx::exploderfx(8, "spitfire_bomb", (4128, -2784, 1122), 8.8,  (4128, -2784, 1222), undefined,undefined,undefined,"mud_impact",undefined,150);
//	maps\_fx::exploderfx(8, "spitfire_bomb", (4064, -2304, 1053), 9.0,  (4064, -2304, 1153), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(8, "spitfire_bomb", (3968, -1728, 1144), 9.2,  (3968, -1728, 1244), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(8, "spitfire_bomb", (3872, -1152, 1161), 9.4,  (3872, -1152, 1361), undefined,undefined,undefined,"mud_impact",undefined,150);
//	maps\_fx::exploderfx(8, undefined,       (3744, -640, 1164),  9.6,  (3744, -640, 1264),  undefined,undefined,undefined,"mud_impact",undefined,150);
//	maps\_fx::exploderfx(8, undefined,       (3552, -96, 1150),   9.8,  (3552, -96, 1250),   undefined,undefined,undefined,"mud_impact",undefined,150);

//	maps\_fx::exploderfx(8, "spitfire_bomb", (1528, -2096, 1099), 22.0, (1528, -2096, 1199), undefined,undefined,undefined,"mud_impact",undefined,150); // second pass
	maps\_fx::exploderfx(8, "spitfire_bomb", (1912, -2224, 1167), 22.2, (1912, -2224, 1267), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(8, "spitfire_bomb", (2328, -2384, 1115), 22.6, (2328, -2384, 1215), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(8, "spitfire_bomb", (2744, -2544, 1157), 22.8, (2744, -2544, 1257), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(8, "spitfire_bomb", (3176, -2688, 1163), 23.0, (3176, -2688, 1263), undefined,undefined,undefined,"mud_impact",undefined,150);

	//spitfire bombs plane 2
	maps\_fx::exploderfx(10, "spitfire_bomb", (4024, -2376, 1084), 9.4,  (4024, -2376, 1184), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, "spitfire_bomb", (3992, -1928, 1123), 9.6,  (3992, -1928, 1223), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, "spitfire_bomb", (4056, -1384, 1153), 9.8,  (4056, -1384, 1253), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, undefined, (3992, -712, 1162),  10.0, (3992, -712, 1262),  undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, undefined, (4024, -136, 1165),  10.2, (4024, -136, 1265),  undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, undefined, (4056, 504, 1176),   10.4, (4056, 504, 1276),   undefined,undefined,undefined,"mud_impact",undefined,150);
//	maps\_fx::exploderfx(10, "spitfire_bomb", (3992, -712, 1162),  10.0, (3992, -712, 1262),  undefined,undefined,undefined,"mud_impact",undefined,150);
//	maps\_fx::exploderfx(10, "spitfire_bomb", (4024, -136, 1165),  10.2, (4024, -136, 1265),  undefined,undefined,undefined,"mud_impact",undefined,150);
//	maps\_fx::exploderfx(10, "spitfire_bomb", (4056, 504, 1176),   10.4, (4056, 504, 1276),   undefined,undefined,undefined,"mud_impact",undefined,150);

//	maps\_fx::exploderfx(10, "spitfire_bomb", (2768, -1544, 1122), 23.7, (2768, -1544, 1222), undefined,undefined,undefined,"mud_impact",undefined,150); // second pass
	maps\_fx::exploderfx(10, "spitfire_bomb", (3152, -1832, 1068), 23.9, (3152, -1832, 1168), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, "spitfire_bomb", (3536, -2024, 1166), 24.1, (3536, -2024, 1266), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, "spitfire_bomb", (3816, -2198, 1165), 24.3, (3816, -2198, 1265), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(10, "spitfire_bomb", (4118, -2364, 1027), 24.5, (4118, -2364, 1127), undefined,undefined,undefined,"mud_impact",undefined,150);

	//spitfire bombs plane 3
//	maps\_fx::exploderfx(9, "spitfire_bomb", (2768, -3304, 1113), 10, (2768, -3304, 1213),   undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, "spitfire_bomb", (2896, -2824, 1149), 10.2, (2896, -2824, 1249), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, "spitfire_bomb", (3088, -2344, 1102), 10.4, (3088, -2344, 1202), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, "spitfire_bomb", (3152, -1896, 1076), 10.6, (3152, -1896, 1176), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, "spitfire_bomb", (3280, -1384, 1163), 10.8, (3280, -1384, 1263), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, "spitfire_bomb", (3472, -840, 1161),  11,   (3472, -840, 1261),  undefined,undefined,undefined,"mud_impact",undefined,150);

	maps\_fx::exploderfx(9, undefined,       (4376, -856, 1155),  24.8, (4376, -856, 1255),  undefined,undefined,undefined,"mud_impact",undefined,150); // second pass
	maps\_fx::exploderfx(9, undefined,       (4216, -1272, 1121), 25.0, (4216, -1272, 1221), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, undefined,       (4120, -1656, 1145), 25.2, (4120, -1656, 1245), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, "spitfire_bomb", (3992, -2104, 1095), 25.4, (3992, -2104, 1195), undefined,undefined,undefined,"mud_impact",undefined,150);
	maps\_fx::exploderfx(9, "spitfire_bomb", (3896, -2520, 1160), 25.6, (3896, -2520, 1260), undefined,undefined,undefined,"mud_impact",undefined,150);
	
	maps\_fx::exploderfx(12, "spitfire_bomb", (3824, -4036, 1005), 3.4,   (3824, -4036, 1105), undefined,undefined,undefined,"mud_impact",undefined,300);
	maps\_fx::exploderfx(12, "spitfire_bomb", (3820, -3768, 1139), 3.6, (3820, -3768, 1239), undefined,undefined,undefined,"mud_impact",undefined,300);
	maps\_fx::exploderfx(12, "spitfire_bomb", (3804, -3464, 1152), 3.8, (3804, -3464, 1152), undefined,undefined,undefined,"mud_impact",undefined,300);
	maps\_fx::exploderfx(12, "spitfire_bomb", (3568, -2628, 1098), 4.6, (3568, -2628, 1198), undefined,undefined,undefined,"mud_impact",undefined,300);
	maps\_fx::exploderfx(12, "spitfire_bomb", (3472, -2948, 1144), 4.8, (3472, -2948, 1244), undefined,undefined,undefined,"mud_impact",undefined,300);
	maps\_fx::exploderfx(12, "spitfire_bomb", (3408, -3236, 1136), 5.0, (3408, -3236, 1236), undefined,undefined,undefined,"mud_impact",undefined,300);
}

ambientFX()
{
	//Commneted Out for framerate
	//maps\_fx::loopfx("fogbank_large_duhoc", (3428,-6513,-141), 1, (3428,-6513,-42));
	//maps\_fx::loopfx("fogbank_large_duhoc", (-1421,-6270,-141), 1, (-1421,-6270,-42));
	//maps\_fx::loopfx("fogbank_large_duhoc", (882,-6407,-141), 1, (882,-6407,-42));
	//maps\_fx::loopfx("fogbank_large_duhoc", (1921,-9260,-12), 1, (1921,-9260,86));

	// not needed for defend
	// maps\_fx::loopfx("fogbank_hidecliff_duhoc", (-15549,-17462,-27), 1, (-15509,-17371,-26));

	//mainpath cliff dust and rocks
	//maps\_fx::loopfx("cliff_dust_rocks", (435,-4227,172), 0.5, (434,-4318,212));
	//maps\_fx::loopfx("cliff_dust_rocks", (383,-4171,408), 0.5, (383,-4262,448));
	//maps\_fx::loopfx("cliff_dust_rocks", (345,-4090,636), 0.5, (342,-4155,559));
	
	/*
	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(435,-4227,172),(434,-4318,212),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(383,-4171,408),(383,-4262,448),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(345,-4090,636),(342,-4155,559),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.
	*/

    //random cliffdust
    /*
	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(1509,-4305,247),(1507,-4393,199),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.

	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(1510,-4129,849),(1508,-4217,802),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.

	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(1159,-4170,570),(1159,-4261,610),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.

	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(767,-4134,691),(775,-4233,690),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.

	maps\_fx::gunfireloopfxVec ("cliff_dust_rocks",(-126,-4293,480),(-108,-4391,487),	// Origin
							1, 3,				// Number of shots
							0.6, 0.3,			// seconds between shots
							3, 10);				// seconds between sets of shots.
	*/

	
	//Cliff top smoke
	// probably not needed for duhoc_defend


/*	maps\_fx::loopfx("thin_black_smoke_M", (-898,-3258,1140), 1, (-898,-3258,1150));
	maps\_fx::loopfx("thin_black_smoke_M", (3398,-3720,1056), 1, (3398,-3720,1066));
	maps\_fx::loopfx("thin_black_smoke_M", (613,-1483,1179), 1, (613,-1483,1189));
	maps\_fx::loopfx("thin_black_smoke_M", (269,-1450,1457), 1, (269,-1450,1467));
	maps\_fx::loopfx("thin_light_smoke_M", (3644,-1003,1139), 0.5, (3644,-1003,1149));
	maps\_fx::loopfx("thin_light_smoke_L", (993,-1789,1088), 0.6, (976,-1794,1187));
	maps\_fx::loopfx("thin_light_smoke_L", (2375,-1451,1181), 0.6, (2375,-1451,1281));
	maps\_fx::loopfx("thin_light_smoke_M", (556,-2668,1164), 0.6, (556,-2668,1264));
	maps\_fx::loopfx("thin_light_smoke_L", (840,-708,1115), 0.6, (840,-708,1215));
	maps\_fx::loopfx("thin_light_smoke_M", (1349,-2965,1115), 0.6, (1349,-2965,1215));
	maps\_fx::loopfx("thin_light_smoke_L", (631,148,1201), 0.6, (631,148,1301));
	maps\_fx::loopfx("thin_light_smoke_L", (-1273,-578,1165), 0.6, (-1273,-578,1265));
	maps\_fx::loopfx("thin_light_smoke_M", (-261,-151,1224), 0.6, (-261,-151,1324));
	maps\_fx::loopfx("thin_light_smoke_M", (-485,-1740,1143), 0.6, (-485,-1740,1243));
	maps\_fx::loopfx("thin_light_smoke_L", (-508,-2706,1079), 1, (-508,-2706,1089));
	maps\_fx::loopfx("thin_light_smoke_M", (9,1486,1255), 0.6, (9,1486,1355));
*/
	maps\_fx::loopfx("thin_light_smoke_M", (9,1486,1255), 0.6, (9,1486,1355));
	maps\_fx::loopfx("thin_light_smoke_M", (2350,1708,1118), 1, (2350,1708,1128));
	maps\_fx::loopfx("thin_light_smoke_M", (1159,1491,1150), 1, (1159,1491,1160));
//	maps\_fx::loopfx("thin_black_smoke_M", (2350,1708,1118), 1, (2350,1708,1128));
	

	//town
	maps\_fx::loopfx("thin_light_smoke_M", (392,3211,1214), 0.6, (392,3211,1314));
	maps\_fx::loopfx("fogbank_small_duhoc", (875,2826,1161), 2, (875,2826,1271));
	maps\_fx::loopfx("fogbank_small_duhoc", (401,3820,1177), 2, (401,3820,1287));
	maps\_fx::loopfx("fogbank_small_duhoc", (-722,4102,1232), 2, (-722,4102,1342));

	//backfield
	maps\_fx::loopfx("fogbank_small_duhoc", (190,5819,1051), 2, (187,5853,1145));
	maps\_fx::loopfx("fogbank_small_duhoc", (-128,5139,1138), 2, (-137,5162,1235));
	maps\_fx::loopfx("fogbank_small_duhoc", (-32,6512,954), 2, (-40,6536,1051));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1053,5706,1008), 2, (-1061,5729,1105));
	maps\_fx::loopfx("fogbank_small_duhoc", (882,5213,1192), 2, (882,5213,1302));

/*	
	//fields by guns
	maps\_fx::loopfx("thin_black_smoke_M", (-1076,9851,1182), 1, (-1076,9851,1192));
	maps\_fx::loopfx("thin_black_smoke_M", (1334,8899,1013), 1, (1334,8899,1023));
	
	maps\_fx::loopfx("fogbank_small_duhoc", (-893,7814,941), 2, (-896,7848,1035));
	maps\_fx::loopfx("fogbank_small_duhoc", (274,7903,929), 2, (271,7937,1023));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1910,9406,1032), 2, (-1913,9440,1126));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2227,8890,1024), 2, (-2230,8924,1118));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1666,8919,1041), 2, (-1669,8953,1135));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1235,8451,1001), 2, (-1238,8485,1095));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1265,6826,931), 2, (-1268,6860,1025));
	maps\_fx::loopfx("fogbank_small_duhoc", (-930,7075,944), 2, (-933,7109,1038));
*/
}
