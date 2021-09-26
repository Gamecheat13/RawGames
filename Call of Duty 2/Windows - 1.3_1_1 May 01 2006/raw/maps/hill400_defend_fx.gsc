main()
{
	precacheFX();
	spawnWorldFX();
	treadFX();

}

precacheFX()
{
	level.mortar = loadfx ("fx/explosions/mortarExp_mud.efx");
	level.artyhit = loadfx("fx/explosions/artilleryExp_dirt_brown_nodecal.efx");
	level.smokegrenade = loadfx("fx/explosions/smoke_grenade.efx");
	level.breachfx = loadfx("fx/explosions/artilleryExp_duhoc_cliff.efx");
	
	level._effect["grenade_smoke"]					= loadfx("fx/explosions/smoke_grenade.efx");																																																																																																																																			
	level._effect["battlefield_smokebank_S"]		= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["thin_light_smoke_M"]				= loadfx ("fx/smoke/thin_light_smoke_M.efx");         																																																																																

}

spawnWorldFX()
{
	/*
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
	*/
	
	//hill top
	maps\_fx::loopfx("battlefield_smokebank_S", (-917,-4023,11750), 1, (-917,-4023,11850));
	maps\_fx::loopfx("battlefield_smokebank_S", (77,-4388,11661), 1, (77,-4388,11761));
	maps\_fx::loopfx("battlefield_smokebank_S", (278,-3662,11940), 1, (278,-3662,12040));
	maps\_fx::loopfx("battlefield_smokebank_S", (1029,-3581,11857), 1, (1029,-3581,11957));
	maps\_fx::loopfx("battlefield_smokebank_S", (1218,-2402,12150), 1, (1218,-2402,12250));
	maps\_fx::loopfx("battlefield_smokebank_S", (2066,-2693,11888), 1, (2066,-2693,11988));
	maps\_fx::loopfx("battlefield_smokebank_S", (2702,-1108,12105), 1, (2702,-1108,12205));
	maps\_fx::loopfx("battlefield_smokebank_S", (2306,306,12273), 1, (2306,306,12373));
	maps\_fx::loopfx("battlefield_smokebank_S", (-370,-1648,12703), 1, (-370,-1648,12803));
	maps\_fx::loopfx("battlefield_smokebank_S", (-238,599,12785), 1, (-238,599,12885));
	maps\_fx::loopfx("battlefield_smokebank_S", (-2494,-730,12593), 1, (-2494,-730,12693));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1441,-1390,12666), 1, (-1441,-1390,12766));
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
	maps\_fx::loopfx("battlefield_smokebank_S", (-1071,2157,12605), 1, (-1071,2157,12705));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1988,1913,12688), 1, (-1988,1913,12788));
	maps\_fx::loopfx("battlefield_smokebank_S", (-3081,836,12570), 1, (-3081,836,12670));
	maps\_fx::loopfx("thin_light_smoke_M", (-757,-684,12805), 1, (-757,-684,12905));
	maps\_fx::loopfx("battlefield_smokebank_S", (-428,-442,12817), 1, (-428,-442,12917));
	maps\_fx::loopfx("thin_light_smoke_M", (-1974,733,12765), 1, (-1974,733,12865));
	maps\_fx::loopfx("thin_light_smoke_M", (-674,774,12763), 1, (-674,774,12863));
}

treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	//tiger fx
	maps\_treadfx::setVehicleFX("tiger",	"water",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"dirt",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"asphalt",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"sand",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"grass",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"gravel",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"mud",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"plaster",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"rock",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("tiger",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"foliage",	undefined);
}
