main()
{
	precacheFX();
	vehicleFXoverride();
	spawnWorldFX();
	exploders();
	randomGroundDust();
}

precacheFX()
{
	level._effect["tank_impact_night"]		= loadfx( "fx/explosions/tank_impact_night.efx" );
	level._effect["exp_pack_doorbreach"]	= loadfx( "fx/explosions/exp_pack_hallway.efx" );
	level._effect["dust_wind_night"] 		= loadfx ("fx/dust/dust_wind_night.efx");
	level._effect["cold_breath"]			= loadfx( "fx/misc/cold_breath.efx" );
	level._effect["lighthaze_decoytown"] 	= loadfx ("fx/misc/lighthaze_decoytown.efx");
	level._effect["thin_black_smoke_M"]		= loadfx ("fx/smoke/thin_black_smoke_M.efx");
}

vehicleFXoverride()
{
	//tread Fx override
	maps\_treadfx::setVehicleFX("crusader",	"water",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("crusader",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"foliage",	undefined);
	
	maps\_treadfx::setVehicleFX("blitz",	"water",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("blitz",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	undefined);

	maps\_treadfx::setVehicleFX("panzer2",	"water",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"foliage",	undefined);

	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"water",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"foliage",	undefined);

	maps\_treadfx::setVehicleFX("unicarrier",	"water",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"dirt",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"asphalt",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"sand",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"grass",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"gravel",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"mud",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"plaster",	"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"rock",		"fx/dust/tread_dust_decoytown.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"foliage",	undefined);

	//panzer explosion, fire and smoke override
	level._effect["xmodel/vehicle_panzer_ii"+"tank_fire_turret"] 		= loadfx ("fx/fire/tank_fire_night_distant.efx");
	//level._effect["xmodel/vehicle_panzer_ii"+"damaged_vehicle_smoke"] 	= loadfx ("fx/smoke/damaged_vehicle_smoke.efx"); 
	//level._effect["xmodel/vehicle_panzer_ii"+"tank_fire_engine"] 		= loadfx ("fx/fire/tank_fire_engine.efx");
	level.damagefiretag["xmodel/vehicle_panzer_ii"] = [];

}

spawnWorldFX()
{
/*	//original ground dust-before random firing DO NOT DELETE
	maps\_fx::loopfx("dust_wind_night", (5946,-12952,-147), 0.3, (5946,-12952,-47));
	maps\_fx::loopfx("dust_wind_night", (8908,-11851,-128), 0.3, (8908,-11851,-28));
	maps\_fx::loopfx("dust_wind_night", (6469,-12810,-128), 0.3, (6469,-12810,-28));
	maps\_fx::loopfx("dust_wind_night", (7153,-13550,-144), 0.3, (7153,-13550,-44));
	maps\_fx::loopfx("dust_wind_night", (7008,-12849,-128), 0.3, (7008,-12849,-28));
	maps\_fx::loopfx("dust_wind_night", (7267,-12013,-128), 0.3, (7267,-12013,-28));
	maps\_fx::loopfx("dust_wind_night", (7679,-11758,-128), 0.3, (7679,-11758,-28));
	maps\_fx::loopfx("dust_wind_night", (8091,-11575,-128), 0.3, (8091,-11575,-28));
	maps\_fx::loopfx("dust_wind_night", (8469,-11695,-128), 0.3, (8469,-11695,-28));
	maps\_fx::loopfx("dust_wind_night", (8138,-12107,-128), 0.3, (8138,-12107,-28));
	maps\_fx::loopfx("dust_wind_night", (7642,-12674,-128), 0.3, (7642,-12674,-28));
	maps\_fx::loopfx("dust_wind_night", (6701,-13118,-128), 0.3, (6701,-13118,-28));
	maps\_fx::loopfx("dust_wind_night", (7493,-13248,-144), 0.3, (7493,-13248,-44));
	maps\_fx::loopfx("dust_wind_night", (8130,-12977,-128), 0.3, (8130,-12977,-28));
	maps\_fx::loopfx("dust_wind_night", (8219,-13424,-128), 0.3, (8219,-13424,-28));
	maps\_fx::loopfx("dust_wind_night", (8420,-15330,-406), 0.3, (8420,-15330,-306));
	maps\_fx::loopfx("dust_wind_night", (8076,-13992,-342), 0.3, (8076,-13992,-242));
	maps\_fx::loopfx("dust_wind_night", (9412,-15402,-342), 0.3, (9412,-15402,-242));
	maps\_fx::loopfx("dust_wind_night", (8599,-14750,-406), 0.3, (8599,-14750,-306));
	maps\_fx::loopfx("dust_wind_night", (9576,-14129,-342), 0.3, (9576,-14129,-242));
	maps\_fx::loopfx("dust_wind_night", (8920,-14895,-446), 0.3, (8920,-14895,-346));
	maps\_fx::loopfx("dust_wind_night", (9496,-14767,-406), 0.3, (9496,-14767,-306));
	maps\_fx::loopfx("dust_wind_night", (8564,-14223,-406), 0.3, (8564,-14223,-306));
	maps\_fx::loopfx("dust_wind_night", (9256,-13808,-278), 0.3, (9256,-13808,-178));
	maps\_fx::loopfx("dust_wind_night", (9487,-13124,-155), 0.3, (9487,-13124,-55));
	maps\_fx::loopfx("dust_wind_night", (10028,-12682,-91), 0.3, (10028,-12682,8));
	maps\_fx::loopfx("dust_wind_night", (9578,-12559,-155), 0.3, (9578,-12559,-55));
	maps\_fx::loopfx("dust_wind_night", (8565,-13666,-327), 0.3, (8565,-13666,-227));
	maps\_fx::loopfx("dust_wind_night", (8723,-13259,-252), 0.3, (8723,-13259,-152));
*/
	maps\_fx::loopfx("lighthaze_decoytown", (9144,-14699,-119), 3, (9144,-14699,-219));
	maps\_fx::loopfx("lighthaze_decoytown", (8828,-15551,-110), 3, (8828,-15551,-210));
	maps\_fx::loopfx("lighthaze_decoytown", (8278,-14913,-100), 3, (8278,-14913,-200));
}

exploders()
{
	//bunker1
	maps\_fx::exploderfx(1, "tank_impact_night", (9024,-15615,-420), 0, (9023,-15528,-371));
	maps\_fx::exploderfx(1, "tank_impact_night", (8723,-15923,-359), 0.15, (8723,-15923,-259));
	maps\_fx::exploderfx(1, "tank_impact_night", (9070,-15763,-295), 0.1, (9070,-15763,-195));
	maps\_fx::exploderfx(1, undefined, (9024,-15615,-420), 0, (9024,-15615, -320), "thin_black_smoke_M", 1, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	//bunker2
	maps\_fx::exploderfx(2, "tank_impact_night", (8115,-15259,-310), 0.1, (8115,-15259,-210));
	maps\_fx::exploderfx(2, "tank_impact_night", (8234,-15093,-433), 0, (8305,-15101,-362));
	maps\_fx::exploderfx(2, "tank_impact_night", (8094,-14895,-310), 0.15, (8094,-14895,-210));
	maps\_fx::exploderfx(2, undefined, (8234,-15093,-433), 0, (8234,-15093,-333), "thin_black_smoke_M", 1, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	//bunker3
	maps\_fx::exploderfx(3, "tank_impact_night", (9176,-14494,-297), 0.1, (9176,-14494,-197));
	maps\_fx::exploderfx(3, "tank_impact_night", (8835,-14450,-297), 0.15, (8835,-14450,-197));
	maps\_fx::exploderfx(3, "tank_impact_night", (8958,-14624,-444), 0, (8962,-14706,-385));
	maps\_fx::exploderfx(3, undefined, (8958,-14624,-444), 0, (8958,-14624,-344), "thin_black_smoke_M", 1, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	//Door Breach
	maps\_fx::exploderfx(4, "exp_pack_doorbreach", (9651,-13732,-217), 0.1, (9595,-13811,-191));

	//Crate Wall
	maps\_fx::exploderfx(5, "exp_pack_doorbreach", (7740,-13150,-232), 0.1, (7740,-13130,-232));

}

randomGroundDust()
{
	//Random Dust postition copied from above
	index = 0;
	
	fxorigin [index] = 	(5946,-12952,-147);			fxvector [index] =  (5946,-12952,-47);	index++;
	fxorigin [index] = 	(8908,-11851,-128);			fxvector [index] =  (8908,-11851,-28);	index++;
	fxorigin [index] = 	(6469,-12810,-128);			fxvector [index] =  (6469,-12810,-28);	index++;
	fxorigin [index] = 	(7153,-13550,-144);			fxvector [index] =  (7153,-13550,-44);	index++;
	fxorigin [index] = 	(7008,-12849,-128);			fxvector [index] =  (7008,-12849,-28);	index++;
	fxorigin [index] = 	(7267,-12013,-128);			fxvector [index] =  (7267,-12013,-28);	index++;
	fxorigin [index] = 	(7679,-11758,-128);			fxvector [index] =  (7679,-11758,-28);	index++;
	fxorigin [index] = 	(8091,-11575,-128);			fxvector [index] =  (8091,-11575,-28);	index++;
	fxorigin [index] = 	(8469,-11695,-128);			fxvector [index] =  (8469,-11695,-28);	index++;
	fxorigin [index] = 	(8138,-12107,-128);			fxvector [index] =  (8138,-12107,-28);	index++;
	fxorigin [index] = 	(7642,-12674,-128);			fxvector [index] =  (7642,-12674,-28);	index++;
	fxorigin [index] = 	(6701,-13118,-128);			fxvector [index] =  (6701,-13118,-28);	index++;
	fxorigin [index] = 	(7493,-13248,-144);			fxvector [index] =  (7493,-13248,-44);	index++;
	fxorigin [index] = 	(8130,-12977,-128);			fxvector [index] =  (8130,-12977,-28);	index++;
	fxorigin [index] = 	(8219,-13424,-128);			fxvector [index] =  (8219,-13424,-28);	index++;
	fxorigin [index] = 	(8420,-15330,-406);			fxvector [index] =  (8420,-15330,-306);	index++;
	fxorigin [index] = 	(8076,-13992,-342);			fxvector [index] =  (8076,-13992,-242);	index++;
	fxorigin [index] = 	(9412,-15402,-342);			fxvector [index] =  (9412,-15402,-242);	index++;
	fxorigin [index] = 	(8599,-14750,-406);			fxvector [index] =  (8599,-14750,-306);	index++;
	fxorigin [index] = 	(9576,-14129,-342);			fxvector [index] =  (9576,-14129,-242);	index++;
	fxorigin [index] = 	(8920,-14895,-446);			fxvector [index] =  (8920,-14895,-346);	index++;
	fxorigin [index] = 	(9496,-14767,-406);			fxvector [index] =  (9496,-14767,-306);	index++;
	fxorigin [index] = 	(8564,-14223,-406);			fxvector [index] =  (8564,-14223,-306);	index++;
	fxorigin [index] = 	(9256,-13808,-278);			fxvector [index] =  (9256,-13808,-178);	index++;
	fxorigin [index] = 	(9487,-13124,-155);			fxvector [index] =  (9487,-13124,-55);	index++;
	fxorigin [index] = 	(10028,-12682,-91);			fxvector [index] =  (10028,-12682,8);	index++;
	fxorigin [index] = 	(9578,-12559,-155);			fxvector [index] =  (9578,-12559,-55);	index++;
	fxorigin [index] = 	(8565,-13666,-327);			fxvector [index] =  (8565,-13666,-227);	index++;
	fxorigin [index] = 	(8723,-13259,-252);			fxvector [index] =  (8723,-13259,-152);	index++;


	for (i = 0; i < fxorigin.size; i++)
	{
		maps\_fx::gunfireloopfxVec ("dust_wind_night", fxorigin [i], fxvector [i],	// Origin
							50, 100,					// Number of shots
							0.3, 0.1,				// seconds between shots
							3, 10);					// seconds between sets of shots.
	}	
}