#include maps\_weather;
main()
{
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_water.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_water.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_water.efx"));

//	level._effect["rain_heavy"]					= loadfx ("fx/misc/rain_heavy.efx");
//	level._effect["rain_heavy_cloudtype"]		= loadfx ("fx/misc/rain_heavy_cloudtype.efx");
	
	level._effect["tank_barn_explode"] 			= loadfx ("fx/explosions/barn_explosion.efx");
	level._effect["barn_wall_collapse"]			= loadfx ("fx/dust/bunker_cavein_duhoc.efx");

	//ambient fx
	level._effect["fogbank_small"]				= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["thin_light_smoke_L"]			= loadfx ("fx/smoke/thin_light_smoke_L.efx");
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M.efx");
	level._effect["building_fire_small"]		= loadfx ("fx/fire/building_fire_small.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["radio_explosion"] 			= loadfx ("fx/props/radio_explosion.efx");
	level._effect["radio_sparks_smoke"] 		= loadfx ("fx/props/radio_sparks_smoke.efx");
	
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

	treadFX();
	ambientFX();
	exploderFX();
//	level thread playerEffect();
	thread rainControl();
	thread playerWeather(); // make the actual rain effect generate around the player

}

rainControl()
{
	rainInit("hard");
	wait 20;
	rainLight(15);
	wait 10;
	rainNone(15);
	wait 20;
	rainHard(20);
	

	/*
	wait (10);
	rainNone(20);
	wait (30);
	rainHard(20);
	*/
}

/*
playerEffect()
{
	level endon ("fogstart");
	player = getent("player","classname");
	for (;;)
	{
		playfx ( level._effect["rain_heavy"], player.origin + (0,0,650));
		playfx ( level._effect["rain_heavy_cloudtype"], player.origin + (0,0,650));
		wait (0.3);
	}
}
*/


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

	//unicarrier fx
	maps\_treadfx::setVehicleFX("unicarrier",	"water",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"dirt",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"asphalt",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"sand",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"gravel",	"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"mud",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"rock",		"fx/dust/tread_dust_duhoc.efx");
	maps\_treadfx::setVehicleFX("unicarrier",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("unicarrier",	"foliage",	undefined);

}

ambientFX()
{
	maps\_fx::loopfx("thin_light_smoke_M", (1050,1173,-89), 1, (1050,1173,11));
	maps\_fx::loopfx("thin_light_smoke_M", (1583,2583,-135), 1, (1583,2583,-35));
	maps\_fx::loopfx("thin_light_smoke_M", (748,1832,-132), 1, (748,1832,-32));
	maps\_fx::loopfx("thin_black_smoke_M", (1430,2674,192), 0.6, (1430,2674,292));
	maps\_fx::loopfx("thin_black_smoke_M", (-1174,2887,227), 0.6, (-1176,2877,326));
	maps\_fx::loopfx("thin_black_smoke_M", (-1122,1412,29), 0.6, (-1124,1401,128));
	maps\_fx::loopfx("thin_black_smoke_M", (3610,6792,57), 0.6, (3608,6782,156));
	maps\_fx::loopfx("thin_black_smoke_M", (2547,8759,139), 0.6, (2641,8727,135));
	maps\_fx::loopfx("building_fire_small", (-913,2997,-6), 2, (-923,2997,93));
	maps\_fx::loopfx("building_fire_small", (-1038,2772,45), 2, (-962,2708,53));
	maps\_fx::loopfx("tank_fire_engine", (1471,2660,23), 1, (1461,2660,123));
	maps\_fx::loopfx("tank_fire_engine", (-1057,2902,33), 1, (-1049,2912,132));
	maps\_fx::loopfx("tank_fire_engine", (-953,2877,81), 1, (-945,2887,180));
}

fogbankFX()
{
	rainNone(5);
	wait 5;
	
//	level.ambient_track ["exterior"] = "ambient_crossroadsnorain_ext";
//	level.ambient_track ["interior"] = "ambient_crossroadsnorain_int";
//	thread maps\_utility::set_ambient("exterior");	
	
	maps\_fx::loopfx("fogbank_small", (1045,1634,-161), 2, (1045,1634,-61));
	maps\_fx::loopfx("fogbank_small", (-195,3440,-165), 2, (-195,3440,-65));
	maps\_fx::loopfx("fogbank_small", (-151,4067,-132), 2, (-151,4067,-32));
	maps\_fx::loopfx("fogbank_small", (1099,3714,-94), 2, (1099,3714,5));
	maps\_fx::loopfx("fogbank_small", (-1412,1643,-183), 2, (-1412,1643,-83));
	maps\_fx::loopfx("fogbank_small", (-785,2646,-183), 2, (-785,2646,-83));
	maps\_fx::loopfx("fogbank_small", (-181,2153,-182), 2, (-181,2153,-82));
	maps\_fx::loopfx("fogbank_small", (725,2291,-154), 2, (725,2291,-54));
	maps\_fx::loopfx("fogbank_small", (379,1594,-193), 2, (379,1594,-93));
	maps\_fx::loopfx("fogbank_small", (-15,5481,-155), 2, (-15,5481,-55));
	maps\_fx::loopfx("fogbank_small", (-90,4753,-145), 2, (-90,4753,-45));
	maps\_fx::loopfx("fogbank_small", (1418,4778,-111), 2, (1418,4778,-11));
	maps\_fx::loopfx("fogbank_small", (2501,4462,-98), 2, (2501,4462,1));
	maps\_fx::loopfx("fogbank_small", (525,3484,-94), 2, (525,3484,5));
	maps\_fx::loopfx("fogbank_small", (157,554,-211), 2, (157,554,-111));
	maps\_fx::loopfx("fogbank_small", (1070,658,-154), 2, (1070,658,-54));
}

exploderFX()
{

	//first barn part destoryed
	maps\_fx::exploderfx(1, "tank_barn_explode", (2118,4216,193), 0, (2108,4284,265), undefined, undefined, undefined, undefined, undefined, undefined, "crossroads_barn_impact");
	maps\_fx::exploderfx(1, "tank_barn_explode", (2155,4117,291), 0.2, (2153,4126,391), undefined, undefined, undefined, undefined, undefined, undefined, "crossroads_barn_impact");
	
	//Second barn part destoryed
	maps\_fx::exploderfx(2, "tank_barn_explode", (1472,4057,179), 0, (1460,4137,238), undefined, undefined, undefined, undefined, undefined, undefined, "crossroads_barn_impact");
	
	//third barn part destoryed
	maps\_fx::exploderfx(3, "barn_wall_collapse", (1740,4263,-2), 0.25, (1758,4165,1), undefined, undefined, undefined, undefined, undefined, undefined, "crossroads_barn_impact");
	maps\_fx::exploderfx(3, "tank_barn_explode", (1749,4203,5), 0, (1732,4301,9), undefined, undefined, undefined, undefined, undefined, undefined, "crossroads_barn_impact");

	//Fourth barn part destoryed
	maps\_fx::exploderfx(4, "tank_barn_explode", (1668,4114,150), 0, (1659,4196,206), undefined, undefined, undefined, undefined, undefined, undefined, "crossroads_barn_impact");
	maps\_fx::exploderfx(4, "tank_barn_explode", (1595,4019,262), 0.2, (1587,4040,360), undefined, undefined, undefined, undefined, undefined, undefined, "crossroads_barn_impact");
	
	//radio explosion
	maps\_fx::exploderfx(5,"radio_explosion",(1935,3702,-16), 0.25, (1925,3702,83), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(5,"radio_explosion",(1910,3693,-24), 0, (1900,3693,75), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(5,"radio_explosion",(1882,3682,-38), 0.35, (1872,3682,61), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	//first comm tank explosion 
	maps\_fx::exploderfx(6, "tank_barn_explode", (269,2264,-61), 0, (174,2253,-32));
	//second comm tank explosion 
	maps\_fx::exploderfx(7, "tank_barn_explode", (701,2142,64), 0, (606,2132,94));


}
