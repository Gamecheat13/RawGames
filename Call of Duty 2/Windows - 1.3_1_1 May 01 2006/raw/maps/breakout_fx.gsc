main()
{
	precacheFX();
	treadFX();
	ambientFX();
	exploderFX();
}

precacheFX()
{

	level._effect["openingmortar"]					= loadfx("fx/explosions/mortarExp_mud.efx");          																																																																																
	level._effectType["openingmortar"]				= "mortar";                                           																																																																																
                                            		                                                      																																																																																
	level._effect["fieldmortar"]					= loadfx("fx/explosions/mortarExp_mud.efx");          																																																																																
	level._effectType["fieldmortar"]				= "mortar";                                           																																																																																
	level._effect["courtyardmortar"]				= loadfx("fx/explosions/mortarExp_mud.efx");          																																																																																
	level._effectType["courtyardmortar"]			= "mortar";                                           																																																																																
                                            		                                                      																																																																																
	level._effect["spitfire_bomb"]					= loadfx("fx/explosions/mortarExp_mud.efx");          																																																																																
                                            		                                                      																																																																																
	level._effect["mortar_detonation"]				= loadfx("fx/explosions/mortarExp_mud.efx");          																																																																																
	level.scr_sound["mortar_explosion"]				= "mortar_explosion";                                 																																																																																
	                                        		                                                      																																																																																
    level._effect["tank_shot"]						= loadfx("fx/explosions/mortarExp_mud.efx");          																																																																																
	level.scr_sound["tank_shot"]					= "mortar_explosion";                                 																																																																																
                                            		                                                      																																																																																
	level._effect["grenade_smoke"]					= loadfx("fx/explosions/smoke_grenade.efx");          																																																																																
                                     		                                                      																																																																																
	level._effect["hq_wall_explode"] 				= loadfx ("fx/dust/wallblast_dust_linger_grey.efx");  																																																																																
		                                    		                                                      																																																																																
	//ambient FX                            		                                                      																																																																																
	level._effect["thin_black_smoke_M"]				= loadfx ("fx/smoke/thin_black_smoke_M.efx");         																																																																																
	level._effect["thin_light_smoke_L"]				= loadfx ("fx/smoke/thin_light_smoke_L.efx");         																																																																																
	level._effect["thin_light_smoke_M"]				= loadfx ("fx/smoke/thin_light_smoke_M.efx");         																																																																																
	level._effect["battlefield_smokebank_S"]		= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	level._effect["insects_carcass_flies"]			= loadfx ("fx/misc/insects_carcass_flies.efx");


	level._effect["default_explosion"]				= loadfx ("fx/explosions/default_explosion.efx");

	
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

ambientFX()
{
	maps\_fx::loopfx("thin_light_smoke_M", (3244,398,1), 1, (3244,398,100));
	maps\_fx::loopfx("thin_light_smoke_L", (4215,908,17), 1, (4215,908,116));
	maps\_fx::loopfx("thin_light_smoke_M", (3083,44,6), 1, (3083,44,105));
	maps\_fx::loopfx("thin_light_smoke_M", (5296,2084,-52), 1, (5296,2084,46));
	maps\_fx::loopfx("thin_light_smoke_M", (5524,3178,-84), 1, (5524,3178,14));
	maps\_fx::loopfx("thin_light_smoke_M", (5886,3931,-87), 1, (5886,3931,11));
	maps\_fx::loopfx("thin_light_smoke_M", (4356,4204,-27), 1, (4356,4204,71));
	maps\_fx::loopfx("thin_light_smoke_M", (2945,4444,-14), 1, (2945,4444,84));
	maps\_fx::loopfx("thin_light_smoke_M", (3963,4531,-4), 1, (3963,4531,94));
	maps\_fx::loopfx("thin_light_smoke_M", (3157,5214,40), 1, (3157,5214,139));
	maps\_fx::loopfx("thin_black_smoke_M", (-218,7581,-8), 1, (-218,7581,90));
	maps\_fx::loopfx("thin_black_smoke_M", (2424,4803,442), 1, (2424,4803,541));
	maps\_fx::loopfx("thin_black_smoke_M", (-303,2237,168), 1, (-303,2237,267));
	maps\_fx::loopfx("thin_light_smoke_M", (3951,4149,-14), 1, (3951,4149,84));
	maps\_fx::loopfx("thin_light_smoke_M", (2665,5759,4), 1, (2665,5759,103));
	maps\_fx::loopfx("thin_light_smoke_L", (4298,5129,48), 0.5, (4298,5129,147));
	maps\_fx::loopfx("thin_light_smoke_M", (3839,6750,-26), 1, (3839,6750,72));
	maps\_fx::loopfx("thin_light_smoke_M", (2581,6511,-46), 1, (2581,6511,52));
	maps\_fx::loopfx("thin_light_smoke_M", (3370,6520,-40), 1, (3370,6520,58));
	maps\_fx::loopfx("thin_light_smoke_M", (2746,9461,-149), 1, (2746,9461,-50));
	maps\_fx::loopfx("thin_light_smoke_L", (2844,7431,-37), 0.5, (2844,7431,61));
	maps\_fx::loopfx("thin_light_smoke_M", (1662,8699,-100), 1, (1662,8699,-1));
	maps\_fx::loopfx("thin_light_smoke_M", (2409,8286,-100), 1, (2409,8286,-1));
	maps\_fx::loopfx("thin_light_smoke_M", (375,9400,-64), 1, (375,9400,34));
	maps\_fx::loopfx("battlefield_smokebank_S", (2402,421,4), 1, (2402,421,103));
	maps\_fx::loopfx("battlefield_smokebank_S", (3675,4461,70), 1, (3675,4461,169));
	maps\_fx::loopfx("battlefield_smokebank_S", (5008,1601,13), 2, (5008,1601,112));
	maps\_fx::loopfx("battlefield_smokebank_S", (4609,2217,4), 2, (4609,2217,103));
	maps\_fx::loopfx("battlefield_smokebank_S", (5152,3925,-13), 1, (5152,3925,85));
	maps\_fx::loopfx("battlefield_smokebank_S", (1794,3652,-21), 1, (1794,3652,77));
	maps\_fx::loopfx("battlefield_smokebank_S", (1677,4776,-9), 1, (1677,4776,89));
	maps\_fx::loopfx("battlefield_smokebank_S", (1883,5598,-7), 1, (1883,5598,91));
	maps\_fx::loopfx("battlefield_smokebank_S", (3812,6799,8), 0.8, (3812,6799,107));
	maps\_fx::loopfx("battlefield_smokebank_S", (2303,6952,3), 0.8, (2303,6952,102));
	maps\_fx::loopfx("battlefield_smokebank_S", (1785,8497,-100), 0.8, (1785,8497,-1));
	maps\_fx::loopfx("battlefield_smokebank_S", (665,9544,-83), 1, (665,9544,15));

	//Flies
	maps\_fx::loopfx("insects_carcass_flies", (6155,3928,-34), 0.3, (6155,3928,-4));
	maps\_fx::loopfx("insects_carcass_flies", (6189,3735,-42), 0.3, (6189,3735,-32));
	maps\_fx::loopfx("insects_carcass_flies", (6516,3842,-54), 0.3, (6516,3842,-44));
	maps\_fx::loopfx("insects_carcass_flies", (5902,3565,-35), 0.3, (5902,3565,-25));
	maps\_fx::loopfx("insects_carcass_flies", (5162,2349,-38), 0.3, (5162,2349,-28));
	maps\_fx::loopfx("insects_carcass_flies", (2801,595,42), 0.3, (2801,595,52));
	maps\_fx::loopfx("insects_carcass_flies", (2540,357,39), 0.3, (2540,357,49));
	maps\_fx::loopfx("insects_carcass_flies", (2805,146,34), 0.3, (2805,146,44));
	maps\_fx::loopfx("insects_carcass_flies", (2862,6359,10), 0.3, (2862,6359,20));
	maps\_fx::loopfx("insects_carcass_flies", (3007,6585,11), 0.3, (3007,6585,21));
	maps\_fx::loopfx("insects_carcass_flies", (2621,6776,2), 0.3, (2621,6776,12));
	maps\_fx::loopfx("insects_carcass_flies", (2363,6510,8), 0.3, (2363,6510,18));
	maps\_fx::loopfx("insects_carcass_flies", (2270,7019,1), 0.3, (2270,7019,11));
	maps\_fx::loopfx("insects_carcass_flies", (2906,7110,-3), 0.3, (2906,7110,13));
	maps\_fx::loopfx("insects_carcass_flies", (2270,566,52), 0.3, (2270,566,62));
	maps\_fx::loopfx("insects_carcass_flies", (1694,7380,-18), 0.3, (1694,7380,8));


}

exploderFX()
{
	//upper center of HG
	maps\_fx::exploderfx(12,"default_explosion",(1627,9047,207), 0, (1574,9123,243), undefined, undefined, undefined, undefined, undefined, undefined, "breakout_house_impact", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(12, "hq_wall_explode", (1627,9047,207), 0, (1574,9123,243));
	//corner of HG
	maps\_fx::exploderfx(11,"default_explosion",(1874,9058,74), 0, (1821,9134,110), undefined, undefined, undefined, undefined, undefined, undefined, "breakout_house_impact", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(11, "hq_wall_explode", (1874,9058,74), 0, (1821,9134,110));
	//lower center of HG
	maps\_fx::exploderfx(13,"default_explosion",(1623,9049,74), 0, (1570,9125,110), undefined, undefined, undefined, undefined, undefined, undefined, "breakout_house_impact", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(13, "hq_wall_explode", (1623,9049,74), 0, (1570,9125,110));
	//porch of HG
	maps\_fx::exploderfx(14,"default_explosion",(1483,9060,64), 0, (1430,9136,100), undefined, undefined, undefined, undefined, undefined, undefined, "breakout_house_impact", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(14, "hq_wall_explode", (1483,9060,64), 0, (1430,9136,100));
}