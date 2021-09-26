main()
{
	precacheFX();
	exploderFX();
	spawnWorldFX();
	treadFX();
	
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

	//fx
	level._effect["flare_hill400"]					= loadfx("fx/misc/flare_hill400.efx");              																																																																																																																																	
	level._effect["exp_pack_doorbreach"]			= loadfx("fx/explosions/exp_pack_doorbreach.efx");  																																																																																																																																	
	level._effect["exp_pack_hallway"]	 			= loadfx("fx/explosions/exp_pack_hallway.efx");     																																																																																																																																	
	level._effect["mortar1"]						= loadfx("fx/explosions/mortarExp_mud.efx");        																																																																																																																																	
	level._effectType["mortar_intro"]				= "mortar";	                                    																																																																																																																																	
	level._effect["mortar_intro"]					= loadfx("fx/explosions/mortarExp_mud.efx");        																																																																																																																																	
	level._effectType["mortar1"]					= "mortar";                                     																																																																																																																																	
	level._effect["mortar2"]						= loadfx("fx/explosions/mortarExp_mud.efx");        																																																																																																																																	
	level._effectType["mortar2"]					= "mortar";                                     																																																																																																																																	
	level._effect["mortar3"]						= loadfx("fx/explosions/mortarExp_mud.efx");        																																																																																																																																	
	level._effectType["mortar3"]					= "mortar";		                                																																																																																																																																	
	level._effect["rocketfx"]						= loadfx ("fx/fire/fire_airplane_trail.efx");		                                                                                        																																																																																																																																	
	level._effect["grenade_smoke"]					= loadfx("fx/explosions/smoke_grenade.efx");																																																																																																																																			
	level._effect["battlefield_smokebank_S"]		= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");

}

exploderFX()
{
	maps\_fx::exploderfx(0, "flare_hill400", (-6303,3800,11728), 0, (-6350,3776,11812));
	maps\_fx::exploderfx(1, "exp_pack_doorbreach", (-6185,3824,11569), 0, (-6089,3850,11580));
	maps\_fx::exploderfx(2, "exp_pack_hallway", (-1322,-468,12819), 1, (-1223,-482,12829));
	maps\_fx::exploderfx(69,"exp_pack_hallway",(-5754,3582,11561), 0, (-5852,3604,11564));

}

spawnWorldFX()
{
	// Ground Fog and smoke
	maps\_fx::loopfx("fogbank_small_duhoc", (-13296,3432,10283), 2, (-13296,3432,10383));
	maps\_fx::loopfx("fogbank_small_duhoc", (-13913,2871,10268), 2, (-13913,2871,10368));
	maps\_fx::loopfx("fogbank_small_duhoc", (-14688,2344,10279), 2, (-14688,2344,10379));
	maps\_fx::loopfx("fogbank_small_duhoc", (-12675,4000,10372), 2, (-12675,4000,10472));
	maps\_fx::loopfx("fogbank_small_duhoc", (-11349,2583,10240), 2, (-11349,2583,10340));
	maps\_fx::loopfx("fogbank_small_duhoc", (-11035,1658,10242), 2, (-11035,1658,10342));
	maps\_fx::loopfx("fogbank_small_duhoc", (-12029,1841,10239), 2, (-12029,1841,10339));
	maps\_fx::loopfx("fogbank_small_duhoc", (-8729,2987,10773), 2, (-8729,2987,10873));
	maps\_fx::loopfx("fogbank_small_duhoc", (-5857,1018,11662), 2, (-5857,1018,11762));
	maps\_fx::loopfx("fogbank_small_duhoc", (-12335,2704,10279), 2, (-12335,2704,10379));
	maps\_fx::loopfx("fogbank_small_duhoc", (-9584,2448,10553), 2, (-9584,2448,10653));
	maps\_fx::loopfx("fogbank_small_duhoc", (-10132,3024,10434), 2, (-10132,3024,10534));
	maps\_fx::loopfx("fogbank_small_duhoc", (-10805,3546,10419), 2, (-10805,3546,10519));
	maps\_fx::loopfx("fogbank_small_duhoc", (-10694,2564,10333), 2, (-10694,2564,10433));
	maps\_fx::loopfx("fogbank_small_duhoc", (-5808,2152,11809), 2, (-5808,2152,11909));
	maps\_fx::loopfx("fogbank_small_duhoc", (-6621,1718,11543), 2, (-6621,1718,11643));
	maps\_fx::loopfx("fogbank_small_duhoc", (-5737,56,11657), 2, (-5737,56,11757));
	maps\_fx::loopfx("fogbank_small_duhoc", (-5355,-3645,11125), 2, (-5355,-3645,11225));
	maps\_fx::loopfx("fogbank_small_duhoc", (-4751,-4421,11109), 2, (-4751,-4421,11209));
	maps\_fx::loopfx("fogbank_small_duhoc", (-6016,-2864,11208), 2, (-6016,-2864,11308));
	maps\_fx::loopfx("fogbank_small_duhoc", (-6321,-2252,11235), 2, (-6321,-2252,11335));
	maps\_fx::loopfx("fogbank_small_duhoc", (-7110,-383,11171), 2, (-7110,-383,11271));
	maps\_fx::loopfx("fogbank_small_duhoc", (-6457,-1594,11235), 2, (-6457,-1594,11335));
	maps\_fx::loopfx("fogbank_small_duhoc", (-7402,290,11171), 2, (-7402,290,11271));
	maps\_fx::loopfx("fogbank_small_duhoc", (-6791,-974,11203), 2, (-6791,-974,11303));
	maps\_fx::loopfx("fogbank_small_duhoc", (-4161,-5220,11102), 2, (-4161,-5220,11202));
	
	//Hill top
	maps\_fx::loopfx("battlefield_smokebank_S", (-917,-4023,11750), 1, (-917,-4023,11850));
	maps\_fx::loopfx("battlefield_smokebank_S", (77,-4388,11661), 1, (77,-4388,11761));
	maps\_fx::loopfx("battlefield_smokebank_S", (278,-3662,11940), 1, (278,-3662,12040));
	maps\_fx::loopfx("battlefield_smokebank_S", (1029,-3581,11857), 1, (1029,-3581,11957));
	maps\_fx::loopfx("battlefield_smokebank_S", (1218,-2402,12150), 1, (1218,-2402,12250));
	maps\_fx::loopfx("battlefield_smokebank_S", (2066,-2693,11888), 1, (2066,-2693,11988));
	maps\_fx::loopfx("battlefield_smokebank_S", (2702,-1108,12105), 1, (2702,-1108,12205));
	maps\_fx::loopfx("battlefield_smokebank_S", (2306,306,12273), 1, (2306,306,12373));
	maps\_fx::loopfx("battlefield_smokebank_S", (-618,-641,12829), 1, (-618,-641,12929));
	maps\_fx::loopfx("battlefield_smokebank_S", (-370,-1648,12703), 1, (-370,-1648,12803));
	maps\_fx::loopfx("battlefield_smokebank_S", (-238,599,12785), 1, (-238,599,12885));
	maps\_fx::loopfx("battlefield_smokebank_S", (-2494,-730,12593), 1, (-2494,-730,12693));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1572,-1369,12698), 1, (-1572,-1369,12798));
	maps\_fx::loopfx("battlefield_smokebank_S", (-2297,874,12737), 1, (-2297,874,12837));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1303,505,12804), 1, (-1303,505,12904));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1126,1241,12744), 1, (-1126,1241,12844));
	maps\_fx::loopfx("battlefield_smokebank_S", (669,1070,12574), 1, (669,1070,12674));
	maps\_fx::loopfx("battlefield_smokebank_S", (-130,1843,12534), 1, (-130,1843,12634));
	maps\_fx::loopfx("battlefield_smokebank_S", (778,1815,12435), 1, (778,1815,12535));
	maps\_fx::loopfx("battlefield_smokebank_S", (671,-29,12688), 1, (671,-29,12788));
	maps\_fx::loopfx("battlefield_smokebank_S", (179,-1128,12744), 1, (179,-1128,12844));
	maps\_fx::loopfx("fogbank_small_duhoc", (892,-1537,12478), 2, (892,-1537,12578));
	maps\_fx::loopfx("fogbank_small_duhoc", (1242,-982,12462), 2, (1242,-982,12562));
	maps\_fx::loopfx("fogbank_small_duhoc", (1480,-145,12470), 2, (1480,-145,12570));
	maps\_fx::loopfx("fogbank_small_duhoc", (1507,498,12453), 2, (1507,498,12553));

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

