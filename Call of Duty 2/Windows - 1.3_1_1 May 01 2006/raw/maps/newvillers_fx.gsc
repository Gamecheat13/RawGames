#include maps\_weather;
#include maps\_utility;
main()
{
	
	// windows in the church that flash on and off
	level.lit_windows["bright"] = getentarray("flash_bright","targetname");
	level.lit_windows["dark"] = getentarray("flash_dark","targetname");
	assert(level.lit_windows["bright"].size);
	
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_mud_dark.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_mud_dark.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_mud_dark.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_water_dark.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_water_dark.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_water_dark.efx"));


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
	
	//ambient FX                            		                                                      																																																																																
	level._effect["thin_black_smoke_M"]				= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["thin_light_smoke_L"]				= loadfx ("fx/smoke/thin_light_smoke_L.efx");
	level._effect["thin_light_smoke_M"]				= loadfx ("fx/smoke/thin_light_smoke_M.efx");
	level._effect["battlefield_smokebank_S"]		= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	level._effect["tank_smoke"]						= loadfx ("fx/smoke/thin_black_smoke_M.efx");

		
	thread rainControl(); // level specific rain settings.
	thread playerWeather(); // make the actual rain effect generate around the player
	
	// Thunder & Lightning
	level._effect["lightning"]				= loadfx ("fx/misc/lightning.efx");
	addLightningExploder(10); // these exploders make lightning flashes in the sky
	addLightningExploder(11);
	addLightningExploder(12);
	level.nextLightning = gettime() + 10000 + randomfloat(4000); // sets when the first lightning of the level will go off
	thread lightning(::normal, ::flash); // starts up a lightning process with the level specific fog settings
	
	// various lightning sky effects around the level
	maps\_fx::exploderfx(10, "lightning", (-4515,-1661,750), 0, (-4515,-1661,800));
	maps\_fx::exploderfx(10, "lightning", (-7052,1418,750), 0, (-7052,1418,800));
	maps\_fx::exploderfx(10, "lightning", (-4874,6357,750), 0, (-4874,6357,800));
	maps\_fx::exploderfx(10, "lightning", (507,7703,750), 0, (507,7703,800));
	maps\_fx::exploderfx(10, "lightning", (3621,4116,750), 0, (3621,4116,800));
	maps\_fx::exploderfx(10, "lightning", (2664,-590,750), 0, (2664,-590,800));
	maps\_fx::exploderfx(10, "lightning", (-3605,-6893,750), 0, (-3605,-6893,800));
	maps\_fx::exploderfx(10, "lightning", (-7096,-1177,750), 0, (-7096,-1177,800));
	maps\_fx::exploderfx(11, "lightning", (-6342,-1558,850), 0, (-6342,-1558,900));
	maps\_fx::exploderfx(11, "lightning", (-5465,3236,850), 0, (-5465,3236,900));
	maps\_fx::exploderfx(11, "lightning", (-2974,8030,850), 0, (-2974,8030,900));
	maps\_fx::exploderfx(11, "lightning", (574,6443,850), 0, (574,6443,900));
	maps\_fx::exploderfx(11, "lightning", (2574,1865,850), 0, (2574,1865,900));
	maps\_fx::exploderfx(11, "lightning", (1970,-6194,850), 0, (1970,-6194,900));
	maps\_fx::exploderfx(11, "lightning", (-2461,-7874,850), 0, (-2461,-7874,900));
	maps\_fx::exploderfx(11, "lightning", (-5350,-2811,850), 0, (-5350,-2811,900));
	maps\_fx::exploderfx(11, "lightning", (-2774,-2015,850), 0, (-2774,-2015,900));
	maps\_fx::exploderfx(11, "lightning", (-2748,6232,1492), 0, (-2748,6232,1542));
	maps\_fx::exploderfx(11, "lightning", (-171,541,1492), 0, (-171,541,1542));
	maps\_fx::exploderfx(12, "lightning", (2169,1108,882), 0, (2169,1108,932));
	maps\_fx::exploderfx(12, "lightning", (1229,6451,882), 0, (1229,6451,932));
	maps\_fx::exploderfx(12, "lightning", (-1473,8051,882), 0, (-1473,8051,932));
	maps\_fx::exploderfx(12, "lightning", (-4078,5578,882), 0, (-4078,5578,932));
	maps\_fx::exploderfx(12, "lightning", (-5426,3682,882), 0, (-5426,3682,932));
	maps\_fx::exploderfx(12, "lightning", (-5459,-669,882), 0, (-5459,-669,932));
	maps\_fx::exploderfx(12, "lightning", (-2271,-2422,882), 0, (-2271,-2422,932));
	maps\_fx::exploderfx(12, "lightning", (2225,913,882), 0, (2225,913,932));
	maps\_fx::exploderfx(12, "lightning", (-4227,6791,882), 0, (-4227,6791,932));

	treadFX();
	ambientFX();
}

rainControl()
{
	// controls the temperment of the weather
	rainInit("none"); // "none" "light" or "hard"

//	wait (1);
//	rainHard(1);
//	wait (2343);
	
	wait (15);
	rainLight(15);
	wait (30);
	rainHard(15);
	wait (20);
	rainLight(10);
	wait (15);
	rainHard(10);
	wait (60);
	for (;;)
	{	
		rainLight(15);
		wait (60);
		rainNone(10);
		wait (25 + randomint(15));
		rainLight(15);
		wait (25 + randomint(15));
		rainHard(15);
		wait (60);
		rainLight(10);
		wait (25 + randomint(15));
		rainHard(10);
		wait (25 + randomint(15));
	}
}

normal()
{
	// the fog when there is no lightning
//	setCullFog (300, 3500, 181/256, 192/256, 191/256, 0.1);
		
	array_thread(level.lit_windows["dark"], ::showEnt);
	array_thread(level.lit_windows["bright"], ::hideEnt);
	wait (0.05);
	setCullFog (300, 3500, 25/256, 45/256, 48/256, 0.1);
    resetSunLight();
}

flash()
{
	// the fog during a lightning flash
//	setCullFog (000, 3500, 1, 1, 1, 0.1);
//	setSunLight( 1.4, 1.4, 1.7 );
//    setSunLight( 1.2, 1.2, 1.4 );
//	wait (0.1);

	// dx7 cant set sunlight

	if (getcvar("r_rendererInUse") == "dx7")
		setCullFog (000, 3500, 1, 1, 1, 0.1);
		
    wait (.05);
    setSunLight( 1, 1, 1.2 );
	array_thread(level.lit_windows["bright"], ::showEnt);
	array_thread(level.lit_windows["dark"], ::hideEnt);
    wait (.05);
    setSunLight( 3, 3, 3.7 );
    wait (.1);
    thread normal();
    setSunLight( 1, 1, 1.2 );
    wait (.05);
}

showEnt()
{
	self show();
}

hideEnt()
{
	self hide();
}

ambientFX()
{
	maps\_fx::loopfx("thin_black_smoke_M", (67,-961,315), 0.6, (67,-961,415));
	maps\_fx::loopfx("thin_light_smoke_M", (-320,900,-133), .6, (-320,900,-33));
	
	maps\_fx::loopfx("battlefield_smokebank_S", (518,-1326,-104), 1, (518,-1326,-4));
	maps\_fx::loopfx("battlefield_smokebank_S", (-2638,4310,48), 1, (-2638,4310,148));
	maps\_fx::loopfx("battlefield_smokebank_S", (-3931,2027,-137), 1, (-3931,2027,-37));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1493,4683,33), 1, (-1493,4683,133));
	maps\_fx::loopfx("battlefield_smokebank_S", (-733,2310,-15), 1, (-733,2310,84));

}
treadFX()
{
	//This overrides the default effects for treads for this level only
	//GermanHalfTrack fx
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"water",	undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"ice",		undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"snow",		undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"dirt",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"asphalt",	undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"carpet",	undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"cloth",	undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"sand",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"gravel",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"metal",	undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"plaster",	undefined);
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"rock",		undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"wood",		undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"brick",	undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"concrete",	undefined);                     
	maps\_treadfx::setVehicleFX("GermanHalfTrack",	"foliage",	undefined);
	
	//tiger fx
	maps\_treadfx::setVehicleFX("tiger",	"water",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"dirt",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"asphalt",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"sand",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"gravel",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"rock",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"foliage",	undefined);
	
	//Crusader
	maps\_treadfx::setVehicleFX("crusader",	"water",	undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"ice",		undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"snow",		undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"dirt",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"asphalt",	undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"carpet",	undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"cloth",	undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"sand",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"gravel",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"metal",	undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"rock",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"wood",		undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"brick",	undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"concrete",	undefined);                     
	maps\_treadfx::setVehicleFX("crusader",	"foliage",	undefined);                     

	//Sherman
	maps\_treadfx::setVehicleFX("sherman",	"water",	undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"ice",		undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"snow",		undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"dirt",		undefined);
	maps\_treadfx::setVehicleFX("sherman",	"asphalt",	undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"carpet",	undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"cloth",	undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"sand",		undefined);
	maps\_treadfx::setVehicleFX("sherman",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("sherman",	"gravel",	undefined);
	maps\_treadfx::setVehicleFX("sherman",	"metal",	undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("sherman",	"rock",		undefined);
	maps\_treadfx::setVehicleFX("sherman",	"wood",		undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"brick",	undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"concrete",	undefined);                     
	maps\_treadfx::setVehicleFX("sherman",	"foliage",	undefined);                 

}

/*
liter()
{
	for (;;)
	{
		array_thread(level.lit_windows["bright"], ::showEnt);
		array_thread(level.lit_windows["dark"], ::hideEnt);
		wait (0.2);
		array_thread(level.lit_windows["dark"], ::showEnt);
		array_thread(level.lit_windows["bright"], ::hideEnt);
		wait (0.2);
	}
}
*/