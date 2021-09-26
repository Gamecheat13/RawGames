main()
{
	precacheFX();
	treadFX();
	spawnWorldFX();
	randomGroundDust();
	exploderFX();
}

exploderFX()
{
	level.scr_sound ["wall_crumble"]			= "wall_crumble";
	level.scr_sound ["wall_crumble2"]			= "wall_crumble2";
	level.scr_sound ["tree_collapse"]			= "tree_collapse";
	level.scr_sound ["explo_roadblock"]			= "explo_roadblock";
	level.scr_sound ["wall_crumble_alt"]			= "wall_crumble_alt";
	level.scr_sound ["tank_crashbarrier"]			= "tank_crashbarrier";

	// Sound of tank driving through wall
	maps\_fx::exploderfx(0, undefined, (6553, 18960, 614),   0, (6553, 18960, 614), undefined,undefined,undefined,"wall_crumble",undefined);
	maps\_fx::exploderfx(101, undefined, (6335, 19186, 495), 0, (6335, 19186, 495), undefined,undefined,undefined,"tree_collapse",undefined);

	// Sound of tank destroying walls
	maps\_fx::exploderfx(30, undefined, (6942, 15986, 518),  0, (6942, 15986, 518), undefined,undefined,undefined,"wall_crumble2",undefined);
	maps\_fx::exploderfx(100, undefined, (5736, 17104, 556), 0, (5736, 17104, 556), undefined,undefined,undefined,"wall_crumble2",undefined);

	// tank destroying roadblocks
	maps\_fx::exploderfx(5, undefined, (4556, 16690, 524),   0, (4556, 16690, 524), undefined,undefined,undefined,"explo_roadblock",undefined);
	maps\_fx::exploderfx(2, undefined, (4416, 17470, 580),   0, (4416, 17470, 580), undefined,undefined,undefined,"explo_roadblock",undefined);
	maps\_fx::exploderfx(6, undefined, (5396, 16466, 524),   0, (5396, 16466, 524), undefined,undefined,undefined,"wall_crumble_alt",undefined);
	maps\_fx::exploderfx(20, undefined, (6688, 17640, 500),   0, (6688, 17640, 500), undefined,undefined,undefined,"explo_roadblock",undefined);
	maps\_fx::exploderfx(22, undefined, (6632, 17568, 500),   0, (6632, 17568, 500), undefined,undefined,undefined,"wall_crumble_alt",undefined);

	maps\_fx::exploderfx(7, undefined, (6600, 15686, 456),   0, (6600, 15686, 456), undefined,undefined,undefined,"explo_roadblock",undefined);
	maps\_fx::exploderfx(8, undefined, (6672, 15674, 456),   0, (6672, 15674, 456), undefined,undefined,undefined,"wall_crumble_alt",undefined);
	maps\_fx::exploderfx(9, undefined, (6752, 15662, 456),   0, (6752, 15662, 456), undefined,undefined,undefined,"explo_roadblock",undefined);

	// tank driving over truck.
	maps\_fx::exploderfx(16, undefined, (3593, 15279, 321),   0, (3593, 15279, 321), undefined,undefined,undefined,"tank_crashbarrier",undefined);
}

precacheFX()
{
	level._effect["rhine_wall_burst"]			= loadfx ("fx/dust/wall_tank_dust.efx");

	level._effect["sticky_explosion"]			= loadfx("fx/explosions/default_explosion.efx");
	level._effect["sticky_explosion_smoke"]		= loadfx("fx/smoke/thin_black_smoke_S.efx");

	level._effect["tree_explosion"]				= loadfx("fx/explosions/tree_burst.efx");

	level._effect["water_impact"]				= loadfx("fx/explosions/mortarExp_water_rhine.efx");

	level._effect["cool_smoke"]					= loadfx("fx/explosions/smoke_grenade.efx");

	//ambient fx
	level._effect["fogbank_large_duhoc"]		= loadfx ("fx/misc/fogbank_large_duhoc.efx");
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["fogbank_hidecliff_rhine"]	= loadfx ("fx/misc/fogbank_hidecliff_rhine.efx");
	level._effect["dust_wind"]					= loadfx ("fx/dust/dust_wind_eldaba.efx");
	level._effect["battlefield_smokebank_S"]	= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M.efx");         																																																																																
	level._effect["thin_light_smoke_L"]			= loadfx ("fx/smoke/thin_light_smoke_L.efx");         																																																																																
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M.efx");         		

	level._effect["beltot_wallblast"]			= loadfx ("fx/dust/beltot_wallblast.efx");
	
	level._effect["buffalo"]["wake"]			= loadfx ("fx/misc/wake_buffalo.efx");
	level._effect["buffalo"]["sidesplash"]		= loadfx ("fx/misc/boat_splash_small_buffalo.efx");


	
	level.earthquake["tree_burst"]["magnitude"]	= 0.5;
	level.earthquake["tree_burst"]["duration"]	= 0.5;
	level.earthquake["tree_burst"]["radius"]	= 768;

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
	
	//tiger fx
	maps\_treadfx::setVehicleFX("tiger",	"water",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"dirt",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"asphalt",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"sand",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"gravel",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"mud",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"rock",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"foliage",	undefined);
	
	//Opel Blitz FX
	maps\_treadfx::setVehicleFX("blitz",	"water",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"sand",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("blitz",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("blitz",	"rock",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("blitz",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	undefined);
}

spawnWorldFX()
{
	
	//Fogbanks
	maps\_fx::loopfx("fogbank_hidecliff_rhine", (-3106,13313,67), 0.7, (-3127,13215,64));
	maps\_fx::loopfx("fogbank_large_duhoc", (157,12857,-180), 0.7, (157,12857,-80));
	maps\_fx::loopfx("fogbank_large_duhoc", (5781,12737,-148), 0.7, (5781,12737,-48));
	maps\_fx::loopfx("fogbank_large_duhoc", (2617,12918,-148), 0.7, (2617,12918,-48));
	maps\_fx::loopfx("fogbank_small_duhoc", (92,14139,102), 2, (92,14139,202));
	maps\_fx::loopfx("fogbank_small_duhoc", (1798,14147,275), 2, (1798,14147,375));
	maps\_fx::loopfx("fogbank_small_duhoc", (2236,13978,187), 2, (2236,13978,287));
	maps\_fx::loopfx("fogbank_small_duhoc", (1395,14153,323), 2, (1395,14153,423));
	maps\_fx::loopfx("fogbank_small_duhoc", (1735,15201,328), 2, (1735,15201,428));
	maps\_fx::loopfx("fogbank_small_duhoc", (1389,14682,333), 2, (1389,14682,433));


	maps\_fx::loopfx("battlefield_smokebank_S", (6477,14914,416), 1, (6477,14914,516));
	maps\_fx::loopfx("battlefield_smokebank_S", (7538,15131,416), 1, (7538,15131,516));
	maps\_fx::loopfx("battlefield_smokebank_S", (7046,15279,416), 1, (7046,15279,516));
	maps\_fx::loopfx("battlefield_smokebank_S", (2706,15368,340), 0.8, (2706,15368,440));
	maps\_fx::loopfx("thin_light_smoke_L", (4331,17680,486), 0.6, (4331,17680,586));
	maps\_fx::loopfx("thin_light_smoke_M", (5129,17328,443), 0.6, (5129,17328,543));
	maps\_fx::loopfx("battlefield_smokebank_S", (3841,15623,369), 1, (3841,15623,469));
	maps\_fx::loopfx("thin_light_smoke_M", (7057,14874,392), 0.6, (7057,14874,492));
	maps\_fx::loopfx("thin_light_smoke_M", (6546,17309,459), 0.6, (6546,17309,559));
	maps\_fx::loopfx("battlefield_smokebank_S", (4419,16849,486), 1, (4419,16849,586));
	maps\_fx::loopfx("battlefield_smokebank_S", (5229,16347,510), 1, (5229,16347,610));
	maps\_fx::loopfx("battlefield_smokebank_S", (7848,15866,416), 1, (7848,15866,516));
	maps\_fx::loopfx("battlefield_smokebank_S", (8959,15955,508), 1, (8959,15955,608));
	maps\_fx::loopfx("thin_light_smoke_M", (4732,15787,345), 0.6, (4732,15787,445));
	maps\_fx::loopfx("thin_light_smoke_M", (4456,14790,379), 0.6, (4456,14790,479));
	maps\_fx::loopfx("thin_light_smoke_M", (5761,14953,434), 0.6, (5761,14953,534));

/*
	//Ground Dust before converted to random shots DO NOT DELETE
	maps\_fx::loopfx("dust_wind", (3444,16002,317), 0.6, (3444,16002,417));
	maps\_fx::loopfx("dust_wind", (3688,16570,401), 0.6, (3688,16570,501));
	maps\_fx::loopfx("dust_wind", (6384,16816,477), 0.6, (6384,16816,577));
	maps\_fx::loopfx("dust_wind", (6659,15766,445), 0.6, (6659,15766,545));
	maps\_fx::loopfx("dust_wind", (5518,18571,459), 0.6, (5518,18571,559));
	maps\_fx::loopfx("dust_wind", (4060,18201,476), 0.6, (4060,18201,576));
	maps\_fx::loopfx("dust_wind", (6193,17723,444), 0.6, (6193,17723,544));
	maps\_fx::loopfx("dust_wind", (5794,17937,444), 0.6, (5794,17937,544));
	maps\_fx::loopfx("dust_wind", (5694,17333,444), 0.6, (5694,17333,544));
	maps\_fx::loopfx("dust_wind", (5315,17744,444), 0.6, (5315,17744,544));
	maps\_fx::loopfx("dust_wind", (6100,18283,444), 0.6, (6100,18283,544));
	maps\_fx::loopfx("dust_wind", (6436,18860,444), 0.6, (6436,18860,544));
	maps\_fx::loopfx("dust_wind", (7113,17628,436), 0.6, (7113,17628,536));
	maps\_fx::loopfx("dust_wind", (8031,16412,436), 0.6, (8031,16412,536));
	maps\_fx::loopfx("dust_wind", (7881,16741,436), 0.6, (7881,16741,536));
	maps\_fx::loopfx("dust_wind", (7630,17205,436), 0.6, (7630,17205,536));
	maps\_fx::loopfx("dust_wind", (7436,17418,436), 0.6, (7436,17418,536));
	maps\_fx::loopfx("dust_wind", (5048,18385,444), 0.6, (5048,18385,544));
	maps\_fx::loopfx("dust_wind", (3289,15617,317), 0.6, (3289,15617,417));
	maps\_fx::loopfx("dust_wind", (4712,14842,391), 0.6, (4712,14842,491));
	maps\_fx::loopfx("dust_wind", (6771,16499,445), 0.6, (6771,16499,545));
	maps\_fx::loopfx("dust_wind", (6543,15072,445), 0.6, (6543,15072,545));
	maps\_fx::loopfx("dust_wind", (3911,14859,359), 0.6, (3911,14859,459));
	maps\_fx::loopfx("dust_wind", (5287,14871,423), 0.6, (5287,14871,523));
	maps\_fx::loopfx("dust_wind", (4231,17205,529), 0.6, (4231,17205,629));
	maps\_fx::loopfx("dust_wind", (576,14809,336), 0.6, (576,14809,436));
	maps\_fx::loopfx("dust_wind", (2424,14587,359), 0.6, (2424,14587,459));
	maps\_fx::loopfx("dust_wind", (4311,16284,441), 0.6, (4311,16284,541));
*/

	//Tank burst trough wall
	maps\_fx::exploderfx(0, "rhine_wall_burst", (6551, 19108, 520), 0, (6551, 19108, 560));

	// tmp wall gets blown up
	maps\_fx::exploderfx(100, "beltot_wallblast", (5736, 17104, 556), 0, (5732, 17040, 564));
}

randomGroundDust()
{
	index = 0;
	
	fxorigin [index] = 	(3444,16002,317);			fxvector [index] =  (3444,16002,417);	index++;
	fxorigin [index] = 	(3688,16570,401);			fxvector [index] =  (3688,16570,501);	index++;
	fxorigin [index] = 	(6384,16816,477);			fxvector [index] =  (6384,16816,577);	index++;
	fxorigin [index] = 	(6659,15766,445);			fxvector [index] =  (6659,15766,545);	index++;
	fxorigin [index] = 	(5518,18571,459);			fxvector [index] =  (5518,18571,559);	index++;
	fxorigin [index] = 	(4060,18201,476);			fxvector [index] =  (4060,18201,576);	index++;
	fxorigin [index] = 	(6193,17723,444);			fxvector [index] =  (6193,17723,544);	index++;
	fxorigin [index] = 	(5794,17937,444);			fxvector [index] =  (5794,17937,544);	index++;
	fxorigin [index] = 	(5694,17333,444);			fxvector [index] =  (5694,17333,544);	index++;
	fxorigin [index] = 	(5315,17744,444);			fxvector [index] =  (5315,17744,544);	index++;
	fxorigin [index] = 	(6100,18283,444);			fxvector [index] =  (6100,18283,544);	index++;
	fxorigin [index] = 	(6436,18860,444);			fxvector [index] =  (6436,18860,544);	index++;
	fxorigin [index] = 	(7113,17628,436);			fxvector [index] =  (7113,17628,536);	index++;
	fxorigin [index] = 	(8031,16412,436);			fxvector [index] =  (8031,16412,536);	index++;
	fxorigin [index] = 	(7881,16741,436);			fxvector [index] =  (7881,16741,536);	index++;
	fxorigin [index] = 	(7630,17205,436);			fxvector [index] =  (7630,17205,536);	index++;
	fxorigin [index] = 	(7436,17418,436);			fxvector [index] =  (7436,17418,536);	index++;
	fxorigin [index] = 	(5048,18385,444);			fxvector [index] =  (5048,18385,544);	index++;
	fxorigin [index] = 	(3289,15617,317);			fxvector [index] =  (3289,15617,417);	index++;
	fxorigin [index] = 	(4712,14842,391);			fxvector [index] =  (4712,14842,491);	index++;
	fxorigin [index] = 	(6771,16499,445);			fxvector [index] =  (6771,16499,545);	index++;
	fxorigin [index] = 	(6543,15072,445);			fxvector [index] =  (6543,15072,545);	index++;
	fxorigin [index] = 	(3911,14859,359);			fxvector [index] =  (3911,14859,459);	index++;
	fxorigin [index] = 	(5287,14871,423);			fxvector [index] =  (5287,14871,523);	index++;
	fxorigin [index] = 	(4231,17205,529);			fxvector [index] =  (4231,17205,629);	index++;
	fxorigin [index] = 	(576,14809,336);			fxvector [index] =  (576,14809,436);	index++;
	fxorigin [index] = 	(2424,14587,359);			fxvector [index] =  (2424,14587,459);	index++;
	fxorigin [index] = 	(4311,16284,441);			fxvector [index] =  (4311,16284,541);	index++;

	for (i = 0; i < fxorigin.size; i++)
	{
		maps\_fx::gunfireloopfxVec ("dust_wind", fxorigin [i], fxvector [i],	// Origin
							15, 50,					// Number of shots
							0.3, 0.6,				// seconds between shots
							3, 5);					// seconds between sets of shots.
	}	
}