main()
{
	precacheFX();
    spawnWorldFX();    
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_dust_credits.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_dust_credits.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_dust_credits.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_dust_credits.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_dust_credits.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_dust_credits.efx"));
    
	//tread Fx override
	maps\_treadfx::setVehicleFX("jeep",	"water",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"dirt",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"asphalt",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"sand",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"grass",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"gravel",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"mud",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"plaster",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"rock",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("jeep",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"foliage",	undefined);
 
	maps\_treadfx::setVehicleFX("armoredcar",	"water",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"dirt",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"asphalt",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"sand",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"grass",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"gravel",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"mud",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"plaster",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"rock",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("armoredcar",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("armoredcar",	"foliage",	undefined);
 
    maps\_treadfx::setVehicleFX("tiger",	"water",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"dirt",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"asphalt",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"sand",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"grass",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"gravel",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"mud",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"plaster",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"rock",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("tiger",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"foliage",	undefined);

    maps\_treadfx::setVehicleFX("germanhalftrack",	"water",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"dirt",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"asphalt",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"sand",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"grass",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"gravel",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"mud",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"plaster",	"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"rock",		"fx/dust/tread_dust_credits.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"foliage",	undefined);

}

precacheFX()
{
	//level._effect["smallbon"]			= loadfx ("fx/fire/smallbon.efx"); 
	level._effect["smoking_car"]		= loadfx("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect["smoking_car"]		= loadfx("fx/smoke/thin_black_smoke_M.efx");
//	level._effect["medfire"]			= loadfx("fx/fire/tinybon.efx"); 
//	level._effect["fireWall1"]			= loadfx("fx/fire/firewallfacade_1.efx");
	level._effect["mud_splash"]			= loadfx("fx/impacts/footstep_mud_dark.efx");
	level._effect["water_splash"]		= loadfx("fx/impacts/footstep_water_dark.efx");
	level._effect["spotlight"] 			= loadfx("fx/misc/spotlight_credits.efx");
	level._effect["ambush"]				= loadfx("fx/dust/dust_door_ambush.efx");      
	level._effect["flesh_hit"]			= loadfx("fx/impacts/flesh_hit.efx");
	level._effect["dust_impact_med"]	= loadfx("fx/dust/dust_impact_med.efx");
	level._effect["wall_tank_dust"]		= loadfx("fx/dust/wall_tank_dust.efx");
//	level._effect["mg42"]				= loadfx("fx/muzzleflashes/mg42hv.efx");
	level._effect["mg42"]				= loadfx("fx/muzzleflashes/plane_big_flash.efx");
	
//	level._effect["gravel"]				= loadfx("fx/impacts/gravelimpact_em2.efx");
//	level._effect["gravel"]				= loadfx("fx/impacts/large_gravel.efx");
	level._effect["gravel"]				= loadfx("fx/impacts/mega_gravel.efx");
	level._effect["metal"]				= loadfx("fx/impacts/large_metalhit.efx");
	level._effect["dirt"]				= loadfx("fx/impacts/large_mud_dark.efx");
	
	level._effect["tank_mortar"]		= loadfx("fx/explosions/mortarExp_mud.efx");
	level._effect["tank_explosion"]		= loadfx("fx/explosions/tank_explosion.efx");

	level._effect["ammo_explosion"]		= loadfx("fx/explosions/ammo_supply_exp.efx");
	level._effect["small_explosion"]	= loadfx("fx/explosions/small_vehicle_explosion.efx");
	level._effect["big_explosion"]		= loadfx("fx/explosions/eldaba_boat_explosion.efx");
	level._effect["smoke_shield"]		= loadfx("fx/smoke/credits_smoke_shield.efx");
	
	level._effect["ground_fire_med"]			= loadfx ("fx/fire/ground_fire_med.efx");
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["battlefield_smokebank_S"]	= loadfx ("fx/smoke/battlefield_smokebank_S.efx");

	
}

spawnWorldFX()
{   
	//house Fire
	maps\_fx::loopfx("ground_fire_med", (762,4284,1378), 2, (762,4284,1478));

	//ambient fog
	maps\_fx::loopfx("fogbank_small_duhoc", (13889,2494,1903), 2, (13889,2494,2003));
	maps\_fx::loopfx("fogbank_small_duhoc", (13741,4122,2553), 2, (13741,4122,2653));
	maps\_fx::loopfx("fogbank_small_duhoc", (14148,3695,2313), 2, (14148,3695,2413));
	maps\_fx::loopfx("fogbank_small_duhoc", (12930,4071,2505), 2, (12930,4071,2605));
	maps\_fx::loopfx("fogbank_small_duhoc", (6897,4918,1607), 2, (6897,4918,1707));
	maps\_fx::loopfx("fogbank_small_duhoc", (7764,3604,1671), 2, (7764,3604,1771));
	maps\_fx::loopfx("fogbank_small_duhoc", (6935,3587,1359), 2, (6935,3587,1459));
	maps\_fx::loopfx("fogbank_small_duhoc", (5596,3490,1189), 2, (5596,3490,1289));
	maps\_fx::loopfx("fogbank_small_duhoc", (4429,3266,1195), 2, (4429,3266,1295));
	maps\_fx::loopfx("fogbank_small_duhoc", (5596,3490,1189), 2, (5596,3490,1289));
	maps\_fx::loopfx("fogbank_small_duhoc", (2570,3719,1187), 2, (2570,3719,1287));
	maps\_fx::loopfx("fogbank_small_duhoc", (2078,3609,1192), 2, (2078,3609,1292));
	maps\_fx::loopfx("fogbank_small_duhoc", (-529,3225,1166), 2, (-529,3225,1266));
	maps\_fx::loopfx("fogbank_small_duhoc", (-717,2497,1166), 2, (-717,2497,1266));
	maps\_fx::loopfx("fogbank_small_duhoc", (-5267,2100,751), 2, (-5267,2100,851));
	maps\_fx::loopfx("fogbank_small_duhoc", (-5410,2897,783), 2, (-5410,2897,883));
	maps\_fx::loopfx("fogbank_small_duhoc", (-5451,3478,861), 2, (-5451,3478,961));
	maps\_fx::loopfx("fogbank_small_duhoc", (-4845,5705,934), 2, (-4845,5705,1034));
	maps\_fx::loopfx("fogbank_small_duhoc", (-7419,3377,1029), 2, (-7419,3377,1129));
	maps\_fx::loopfx("fogbank_small_duhoc", (-6625,4096,1032), 2, (-6625,4096,1132));
	maps\_fx::loopfx("fogbank_small_duhoc", (-8602,3896,1054), 2, (-8602,3896,1154));
	maps\_fx::loopfx("fogbank_small_duhoc", (-7874,3457,1022), 2, (-7874,3457,1122));
	maps\_fx::loopfx("fogbank_small_duhoc", (-8628,3311,1054), 2, (-8628,3311,1154));

	//Smoke FX
	maps\_fx::loopfx("battlefield_smokebank_S", (1200,4015,1206), 1, (1200,4015,1306));
	maps\_fx::loopfx("battlefield_smokebank_S", (799,3290,1204), 1, (799,3290,1304));
	maps\_fx::loopfx("battlefield_smokebank_S", (3267,3289,1258), 1, (3267,3289,1358));
	maps\_fx::loopfx("battlefield_smokebank_S", (3621,3738,1241), 1, (3621,3738,1341));



	// first mud splash
	maps\_fx::exploderfx(1,"mud_splash",(12267,3282,2344), 0, (12267,3282,2434), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"water_splash",(12265,3285,2344), 0, (12265,3285,2434), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"water_splash",(12267,3276,2344), 0, (12267,3276,2434), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	// landing mud splash
	maps\_fx::exploderfx(3,"water_splash",(12218,3210,2216), 1.8, (12208,3196,2316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(3,"water_splash",(12229,3210,2216), 1.8, (12219,3196,2316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(3,"mud_splash",(12220,3210,2216), 1.8, (12210,3196,2316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	maps\_fx::exploderfx(20,"dust_impact_med",(-536,2518,1244), 1.25, (-540,2516,1344), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(20,"wall_tank_dust",(-370,2544,1314), 0, (-469,2541,1325), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);


/*
	maps\_fx::exploderfx(50,"gravel",(-4989,4916,986), 0, (-4989,4916,1086), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-5048,5018,986), 0.1, (-5048,5018,1086), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-5010,5096,986), 0.15, (-5010,5096,1086), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-5053,5160,986), 0.2, (-5053,5160,1086), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-5047,5228,986), 0.25, (-5047,5228,1086), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-5038,5270,1022), 0.3, (-5038,5270,1122), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-5014,5285,1034), 0.35, (-5014,5285,1134), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-5035,5311,1024), 0.4, (-5035,5311,1124), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-5027,5362,1000), 0.45, (-5027,5362,1100), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
*/

	maps\_fx::exploderfx(1,"mud_splash",(12267,3282,2344), 0, (12267,3282,2434), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"water_splash",(12265,3285,2344), 0, (12265,3285,2434), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(1,"water_splash",(12267,3276,2344), 0, (12267,3276,2434), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(3,"water_splash",(12218,3210,2216), 1.8, (12208,3196,2316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(3,"water_splash",(12229,3210,2216), 1.8, (12219,3196,2316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(3,"mud_splash",(12220,3210,2216), 1.8, (12210,3196,2316), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(10,"ambush",(1733,3287,1286), 0, (1733,3285,1386), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(20,"dust_impact_med",(-536,2518,1244), 1.25, (-540,2516,1344), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(20,"wall_tank_dust",(-370,2544,1314), 0, (-469,2541,1325), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(37,"smoke_shield",(-7640,3475,1098), 0, (-7640,3475,1198), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(30,"tank_mortar",(-2936,2348,1186), 0, (-2936,2348,1286), undefined, undefined, undefined, undefined, undefined, undefined, "mortar_explosion_dirt", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(31,"tank_mortar",(-3750,2131,1024), 0, (-3750,2131,1124), undefined, undefined, undefined, undefined, undefined, undefined, "mortar_explosion_dirt", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4910,4953,994), 0, (-4910,4953,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4831,4965,994), 0, (-4831,4965,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4824,5117,994), 0.05, (-4824,5117,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4826,5062,994), 0, (-4826,5062,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4906,5033,994), 0, (-4906,5033,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4920,5113,994), 0.05, (-4920,5113,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4823,5203,994), 0.05, (-4823,5203,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4919,5194,994), 0.05, (-4919,5194,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-4814,5282,994), 0.1, (-4814,5282,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4925,5275,994), 0.1, (-4925,5275,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4923,5355,994), 0.15, (-4923,5355,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4806,5353,994), 0.15, (-4806,5353,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4924,5435,994), 0.15, (-4924,5435,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4792,5435,994), 0.15, (-4792,5435,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4938,5499,994), 0.2, (-4938,5499,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4779,5565,994), 0.25, (-4779,5565,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4931,5567,994), 0.25, (-4931,5567,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-4934,5644,1005), 0.35, (-4934,5644,1105), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_metal", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-4956,5632,1032), 0.3, (-4956,5632,1132), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_metal", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4780,5661,994), 0.5, (-4780,5661,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"gravel",(-4781,5757,994), 0.55, (-4781,5757,1094), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_gravel", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-4870,5730,1037), 0.45, (-4870,5730,1137), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_metal", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-4890,5725,1021), 0.4, (-4890,5725,1121), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_metal", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"metal",(-4914,5713,1021), 0.4, (-4914,5713,1121), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_metal", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-4930,5733,995), 0.45, (-4930,5733,1095), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_dirt", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-4950,5672,995), 0.35, (-4950,5672,1095), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_dirt", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-4922,5781,995), 0.5, (-4922,5781,1095), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_dirt", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-4919,5845,995), 0.55, (-4919,5845,1095), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_dirt", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(50,"dirt",(-4932,5815,995), 0.55, (-4932,5815,1095), undefined, undefined, undefined, undefined, undefined, undefined, "bullet_large_dirt", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(35,"tank_explosion",(-6066,4057,1206), undefined, (-6066,4057,1306), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(99,undefined,(-8407,3350,1154), undefined, (-8407,3350,1254), undefined, undefined, undefined, undefined, undefined, undefined, "credits_cheer", undefined, undefined, undefined, undefined, undefined);
/*
	maps\_fx::exploderfx(5,"spotlight",(3691,2855,1570), undefined, (3628,2918,1526), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(5,"spotlight",(3304,2782,1517), undefined, (3282,2870,1473), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(5,"spotlight",(3841,4164,1414), undefined, (3937,4162,1443), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

       maps\_fx::loopfx("medfire", (-14583, -19397, -45), 0.3);
       maps\_fx::loopfx("medfire", (-18183, -19832, -89), 0.3);
       maps\_fx::loopfx("smoke", (-14847, -19203, 1), 0.3);
       maps\_fx::loopfx("smoke_window", (-17270, -19504, 87), 0.3);
       maps\_fx::loopfx("fireWall1", (-17677, -19565, -82), 0.3);     // -19565
*/
}

