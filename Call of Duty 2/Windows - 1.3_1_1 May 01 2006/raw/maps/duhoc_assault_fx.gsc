#using_animtree("generic_human");
main()
{
	precacheFX();
	treadFX();
	exploders();
	ambientFX();
	thread sounds();
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

	//Mortar effects
	level._effect["mortar"]["beach"]			= loadfx ("fx/explosions/mortarExp_beach.efx");
	level._effect["mortar"]["dirt"]				= loadfx ("fx/explosions/mortarExp_mud.efx");
	level._effect["mortar"]["water"]			= loadfx ("fx/explosions/mortarExp_water.efx");
	level._effect["mortar"]["launch"] 			= loadfx ("fx/muzzleflashes/cruisader_flash.efx");
	level._effect["mortar"]["concrete"]			= loadfx ("fx/explosions/mortarExp_concrete.efx");
		
	//Higgins effects
	level._effect["higgins"]["enginespray"]		= loadfx ("fx/misc/boat_enginespray_higgins.efx");
	level._effect["higgins"]["splash"]			= loadfx ("fx/misc/boat_splash1_higgins.efx");
	level._effect["higgins"]["wake"]			= loadfx ("fx/misc/wake_higgins.efx");
	level._effect["higgins"]["sidesplash"]		= loadfx ("fx/misc/boat_splash_small_higgins.efx");
	level._effect["higgins"]["rocket_launch"]	= loadfx ("fx/muzzleflashes/higgens_rocket_launch.efx");
	level._effect["higgins"]["fire"]			= loadfx ("fx/fire/higgens_fire.efx");
	level._effect["higgins"]["floorsplash"]		= loadfx ("fx/misc/boat_floorsplash_higgens.efx");
		
	//exploder effects
	level._effect["bunker_collapse"]			= loadfx ("fx/dust/bunker_cavein_duhoc.efx");
	level._effect["bunker_ceilingDust"]			= loadfx ("fx/dust/tunnel_dust_duhoc.efx");
	level._effect["artilleryExp_duhoc_cliff"]	= loadfx ("fx/explosions/artilleryExp_duhoc_cliff.efx");
	level._effect["artilleryExp_duhoc_clifftop"]= loadfx ("fx/explosions/artilleryExp_duhoc_clifftop.efx");
	level._effect["tank_impact_dirt"]			= loadfx ("fx/explosions/tank_impact_dirt.efx");
	level._effect["smoke_grenade_duhoc_40sec"]	= loadfx ("fx/smoke/smoke_grenade_duhoc_40sec.efx");
	level._effect["ammo_explosion"]				= loadfx ("fx/explosions/eldaba_boat_explosion.efx");
	level._effect["ammo_supply_exp"]			= loadfx ("fx/explosions/ammo_supply_exp.efx");
	level._effect["grenadeExp_windowblast"]		= loadfx ("fx/explosions/grenadeExp_windowblast.efx");
	
	//cliff dirt effects
	level._effect["body_impact_cliff"]			= loadfx ("fx/dust/dust_impact_small_duhoc.efx");
	level._effect["cliff_dust_rocks"]			= loadfx ("fx/dust/cliff_dust_rocks_duhoc.efx");
	
	//ambient fx
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["fogbank_hidecliff_duhoc"]	= loadfx ("fx/misc/fogbank_hidecliff_duhoc.efx");

	level._effect["muzzleflash"]				= loadfx ("fx/muzzleflashes/mg42hv_far.efx");
	level._effect["flakveirling_muzzleflash"]	= loadfx ("fx/muzzleflashes/flak_veirling_flash.efx");
	level._effect["bulletStrafe"]["water"]		= loadfx ("fx/impacts/large_waterhit.efx");
	level._effect["bulletStrafe"]["beach"]		= loadfx ("fx/impacts/large_dirthit_duhoc.efx");
	level._effect["smoke_plumeBG"]				= loadfx ("fx/smoke/smoke_plumeBG.efx");
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M_duhoc.efx");
	level._effect["thin_light_smoke_L"]			= loadfx ("fx/smoke/thin_light_smoke_L_duhoc.efx");
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M_duhoc.efx");
	
	level._effect["insects_carcass_flies"]		= loadfx ("fx/misc/insects_carcass_flies.efx");
	
	level._effect["american_smoke_grenade"]		= loadfx ("fx/props/american_smoke_grenade.efx");
	
	//burning guy effects
	level._effect["torso"]						= loadfx ("fx/fire/character_torso_fire.efx");
	level._effect["arms"]						= loadfx ("fx/fire/character_arm_fire.efx");
	
	//vomit guy
	level._effect["puke"]						= loadfx ("fx/misc/vomit.efx");

	//fake grenade fx
	level._effect["grenade"]["concrete"]		= loadfx ("fx/explosions/grenadeExp_concrete.efx");
	level._effect["grenade"]["mud"]				= loadfx ("fx/explosions/grenadeExp_mud.efx");
	level._effect["grenadeExp_cliffblast"]		= loadfx ("fx/explosions/grenadeExp_cliffblast.efx");
	
	//Boatride impact fx
	level._effect["plinkage"]["wood"]			= loadfx ("fx/impacts/large_woodhit_higgens.efx");
	level._effect["plinkage"]["metal"]			= loadfx ("fx/impacts/large_metalhit.efx");
	
	//bullet flesh impacts
	level._effect["headshot"]					= loadfx ("fx/impacts/flesh_hit.efx");
	level._effect["impact_flesh1"]				= loadfx ("fx/impacts/flesh_hit.efx");
	level._effect["impact_flesh2"]				= loadfx ("fx/impacts/flesh_hit_noblood.efx");
	
	//misc
	level._effect["trenchframe01_break"]		= loadfx ("fx/impacts/trenchframe01_break.efx");
	level._effect["thermite"]					= loadfx ("fx/fire/thermite_grenade.efx");
	level._effect["gate"]						= loadfx ("fx/explosions/default_explosion.efx");
	
	level.earthquake["artillery"]["magnitude"]	= 0.25;
	level.earthquake["artillery"]["duration"]	= 0.5;
	level.earthquake["artillery"]["radius"]		= 4096;
}

sounds()
{
	waittillframeend;
	level.scr_sound["artillery"] = "artillery_explosion";
	level.scr_sound["barrel_exp"] = "grenade_explode_default";
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

exploders()
{
	maps\_fx::exploderfx(0, "bunker_collapse", (1858,-1352,1023), 0.5, (1763,-1385,1027));
	maps\_fx::exploderfx(0, "body_impact_cliff", (1863,-1341,1064), 0, (1768,-1374,1068));
	maps\_fx::exploderfx(0, "body_impact_cliff", (1793,-1383,1064), 0, (1698,-1416,1068));
	
	//Cliff Top Artillery Explosions
	maps\_fx::exploderfx(1, "artilleryExp_duhoc_cliff", (1549,-4351,763), 0, (1544,-4437,812));
	maps\_fx::exploderfx(2, "artilleryExp_duhoc_clifftop", (184,-3663,1042), 0, (205,-3696,1134));
	maps\_fx::exploderfx(3, "tank_impact_dirt", (3395,-3702,1033), 0, (3396,-3706,1133));
	maps\_fx::exploderfx(4, "artilleryExp_duhoc_clifftop", (1820,-3670,1098), 0, (1820,-3670,1108));
	maps\_fx::exploderfx(5, "artilleryExp_duhoc_clifftop", (-1885,-3511,1234), 0, (-1885,-3511,1244));
	maps\_fx::exploderfx(6, "tank_impact_dirt", (583,-3361,1084), 0, (583,-3361,1094));
	maps\_fx::exploderfx(7, "artilleryExp_duhoc_cliff", (-978,-4244,940), 0, (-952,-4322,998));
	maps\_fx::exploderfx(8, "artilleryExp_duhoc_clifftop", (1444,-3486,1150), 0, (1444,-3486,1160));
	maps\_fx::exploderfx(9, "tank_impact_dirt", (1004,-3294,1150), 0, (1004,-3294,1160));
	maps\_fx::exploderfx(10, "artilleryExp_duhoc_clifftop", (2771,-3718,1078), 0, (2769,-3736,1176));
	maps\_fx::exploderfx(11, "tank_impact_dirt", (-1590,-2807,1217), 0, (-1587,-2813,1317));
	maps\_fx::exploderfx(12, "artilleryExp_duhoc_clifftop", (2339,-3758,1096), 0, (2339,-3758,1106));
	maps\_fx::exploderfx(13, "artilleryExp_duhoc_cliff", (-40,-3280,1169), 0, (-44,-3282,1269));
	
	//MG42 fall effect
	maps\_fx::exploderfx(14, "body_impact_cliff", (-256,-3853,1164), 0.5, (-261,-3939,1213));
	maps\_fx::exploderfx(14, "body_impact_cliff", (-238,-3884,1164), 0.5, (-243,-3970,1213));

	//smoke grenades
	maps\_fx::exploderfx(15, "smoke_grenade_duhoc_40sec", (826,-906,1108), 0, (831,-909,1208));
	maps\_fx::exploderfx(15, "smoke_grenade_duhoc_40sec", (960,-282,1204), 2, (962,-285,1304));

	//artillery destroys flakvierling	
	maps\_fx::exploderfx(16, "artilleryExp_duhoc_cliff", (2347,-1364,1141), 0, (2347,-1365,1241), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "artilleryExp_duhoc_cliff", (2970,-534,1199), 0.5, (2971,-534,1299), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "artilleryExp_duhoc_cliff", (767,-572,1127), 1, (767,-573,1227), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "artilleryExp_duhoc_cliff", (1928,748,1248), 1.7, (1929,748,1348), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "artilleryExp_duhoc_cliff", (2824,854,1228), 2, (2825,854,1328), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_explosion", (1727,431,1331), 2.4, (1728,431,1431), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_explosion", (2124,-714,1342), 3.2, (2125,-714,1442), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_supply_exp", (1819,-14,1241), 3.8, (1820,-14,1341), undefined, undefined, undefined, "barrel_exp", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_supply_exp", (1613,419,1269), 4.1, (1614,419,1369), undefined, undefined, undefined, "barrel_exp", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_supply_exp", (1569,105,1292), 4.5, (1570,105,1392), undefined, undefined, undefined, "barrel_exp", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_supply_exp", (1551,572,1245), 5, (1552,572,1345), undefined, undefined, undefined, "barrel_exp", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_explosion", (1703,219,1252), 5.4, (1704,219,1352), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(16, "ammo_supply_exp", (1700,536,1262), 6, (1701,536,1362), undefined, undefined, undefined, "barrel_exp", "artillery", undefined);

	//village grenade smoke out windows
	maps\_fx::exploderfx(17, "grenadeExp_windowblast", (59,3591,1477), 0.2, (137,3645,1509));
	maps\_fx::exploderfx(17, "grenadeExp_windowblast", (107,3511,1310), 1.15, (185,3565,1342), undefined, undefined, undefined, "barrel_exp", undefined, undefined);
	maps\_fx::exploderfx(17, "grenadeExp_windowblast", (65,3605,1296), 1.3, (143,3659,1328), undefined, undefined, undefined, "barrel_exp", undefined, undefined);
	maps\_fx::exploderfx(17, "grenadeExp_windowblast", (96,3469,1477), 0.1, (174,3522,1509));
	maps\_fx::exploderfx(17, "grenadeExp_windowblast", (160,3327,1416), 0.1, (241,3281,1454));

	
	//explosions in distance behind guns
	maps\_fx::exploderfx(18, "artilleryExp_duhoc_cliff", (-7668,3157,1111), 0, (-7668,3157,1211), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(18, "artilleryExp_duhoc_cliff", (-4439,3181,1139), 1, (-4439,3181,1239), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(18, "ammo_explosion", (-6438,3037,1029), 2, (-6438,3037,1129), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(18, "artilleryExp_duhoc_cliff", (-4824,3836,1159), 3.5, (-4824,3836,1259), undefined, undefined, undefined, "artillery", "artillery", undefined);

	//AteamBlast
	maps\_fx::exploderfx(19, "grenadeExp_cliffblast", (467,-4128,688), .5, (480,-4227,685), undefined, undefined, undefined, "barrel_exp", "artillery", undefined);
	maps\_fx::exploderfx(19, "grenadeExp_cliffblast", (442,-4094,720), 0.6, (430,-4191,741), undefined, undefined, undefined, "barrel_exp", undefined, undefined);
	maps\_fx::exploderfx(19, "grenadeExp_cliffblast", (406,-4091,672), 0.55, (374,-4185,671), undefined, undefined, undefined, "barrel_exp", undefined, undefined);
}

ambientFX()
{
	maps\_fx::loopfx("fogbank_hidecliff_duhoc", (-15549,-17462,-27), 1, (-15509,-17371,-26));

	//Cliff top smoke
	smokeRepeatRate = 0.6;
	if (getcvarint("scr_duhoc_assault_fast") > 0)
		smokeRepeatRate = 1.0;
	maps\_fx::loopfx("thin_black_smoke_M", (-898,-3258,1140), 1, (-898,-3258,1150));
	maps\_fx::loopfx("thin_black_smoke_M", (3398,-3720,1056), 1, (3398,-3720,1066));
	maps\_fx::loopfx("thin_black_smoke_M", (613,-1483,1179), 1, (613,-1483,1189));
	maps\_fx::loopfx("thin_black_smoke_M", (269,-1450,1457), 1, (269,-1450,1467));
	maps\_fx::loopfx("thin_light_smoke_M", (3644,-1003,1139), smokeRepeatRate, (3644,-1003,1149));
	maps\_fx::loopfx("thin_light_smoke_L", (993,-1789,1088), smokeRepeatRate, (976,-1794,1187));
	maps\_fx::loopfx("thin_light_smoke_L", (2375,-1451,1181), smokeRepeatRate, (2375,-1451,1281));
	maps\_fx::loopfx("thin_light_smoke_M", (556,-2668,1164), smokeRepeatRate, (556,-2668,1264));
	maps\_fx::loopfx("thin_light_smoke_L", (840,-708,1115), smokeRepeatRate, (840,-708,1215));
	maps\_fx::loopfx("thin_light_smoke_M", (1349,-2965,1115), smokeRepeatRate, (1349,-2965,1215));
	maps\_fx::loopfx("thin_light_smoke_L", (631,148,1201), smokeRepeatRate, (631,148,1301));
	maps\_fx::loopfx("thin_light_smoke_L", (-1273,-578,1165), smokeRepeatRate, (-1273,-578,1265));
	maps\_fx::loopfx("thin_light_smoke_M", (-261,-151,1224), smokeRepeatRate, (-261,-151,1324));
	maps\_fx::loopfx("thin_light_smoke_M", (-485,-1740,1143), smokeRepeatRate, (-485,-1740,1243));
	maps\_fx::loopfx("thin_light_smoke_L", (-508,-2706,1079), 1, (-508,-2706,1089));
	maps\_fx::loopfx("thin_light_smoke_M", (9,1486,1255), smokeRepeatRate, (9,1486,1355));
	maps\_fx::loopfx("thin_black_smoke_M", (2350,1708,1118), 1, (2350,1708,1128));
	
	//town
	maps\_fx::loopfx("thin_light_smoke_M", (392,3211,1214), smokeRepeatRate, (392,3211,1314));
	maps\_fx::loopfx("fogbank_small_duhoc", (875,2826,1161), 2, (875,2826,1271));
	maps\_fx::loopfx("fogbank_small_duhoc", (401,3820,1177), 2, (401,3820,1287));
	maps\_fx::loopfx("fogbank_small_duhoc", (-722,4102,1232), 2, (-722,4102,1342));

	//backfield
	maps\_fx::loopfx("fogbank_small_duhoc", (190,5819,1051), 2, (187,5853,1145));
	maps\_fx::loopfx("fogbank_small_duhoc", (-128,5139,1138), 2, (-137,5162,1235));
	maps\_fx::loopfx("fogbank_small_duhoc", (-32,6512,954), 2, (-40,6536,1051));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1053,5706,1008), 2, (-1061,5729,1105));
	maps\_fx::loopfx("fogbank_small_duhoc", (882,5213,1192), 2, (882,5213,1302));
	
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

	//Flies
	maps\_fx::loopfx("insects_carcass_flies", (-1921,8945,1102), 0.3, (-1921,8945,1112));
	maps\_fx::loopfx("insects_carcass_flies", (-1266,8393,1069), 0.3, (-1266,8393,1079));

}