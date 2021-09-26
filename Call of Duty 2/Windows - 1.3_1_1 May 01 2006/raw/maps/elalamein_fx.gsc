#include maps\_utility;

main()
{

	precacheFX();
	treadFX();
	spawnWorldFX();
	exploderfx();
	randomGroundDust();
	level.tread_override_thread = ::tread;	
}

precacheFX()
{
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_dust_libya.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_dust_libya.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_dust_libya.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_dust_libya.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_dust_libya.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_dust_libya.efx"));
	animscripts\utility::setFootstepEffect ("plaster",		loadfx ("fx/impacts/footstep_dust_libya.efx"));
	
	//mortar effects override
	level.mortar = loadfx("fx/explosions/artilleryExp_dirt_libya.efx");
	
	//dust effects for tank
//	level._effect["treads_grass"] 			= loadfx ("fx/tagged/tread_dust_brown.efx");
//	level._effect["treads_dirt"] 			= loadfx ("fx/tagged/tread_dust_brown.efx");
	
	//artillary opening fx
//	level._effect["artillery impact"]		= loadfx ("fx/impacts/largemortar_dirt3.efx");
//	level._effect["missile"] 				= loadfx ("fx/cannon/missile_launch.efx");
	
	level._effect["drifting_smoke"]			= loadfx ("fx/smoke/drifting.efx");
	level._effect["wood plank dust"]		= loadfx ("fx/misc/elalamein_trenchdust.efx");

	dustfx_low = loadfx("fx/dust/tread_dust_elalamein_low.efx");
	dustfx_high = loadfx("fx/dust/tread_dust_elalamein.efx");
	dustwind_low = loadfx("fx/dust/dust_wind_elalamein_low.efx");
	dustwind_high = loadfx("fx/dust/dust_wind_elalamein.efx");
	switch(getcvarint("scr_elalamein_fxlevel"))
	{
		case 0:
			level._effect["dustfx_low"] = dustfx_low;
			level._effect["dustfx"] = dustfx_low;
			level._effect["dust_wind_elalamein"]		= dustwind_low;
			break;
		case 1:
			level._effect["dustfx_low"] = dustfx_low;
			level._effect["dustfx"] = dustfx_high;
			level._effect["dust_wind_elalamein"]		= dustwind_low;
			break;
		case 2:
			level._effect["dustfx_low"] = dustfx_low;
			level._effect["dustfx"] = dustfx_high;
			level._effect["dust_wind_elalamein"]		= dustwind_high;
			break;
		default:
			level._effect["dustfx_low"] = dustfx_low;
			level._effect["dustfx"] = dustfx_high;
			level._effect["dust_wind_elalamein"]		= dustwind_high;

	}
	

	
	level._effect["med_oil_fire"]			= loadfx ("fx/fire/med_oil_fire.efx");
	level._effect["wall_tank_dust"]			= loadfx ("fx/dust/wall_tank_dust.efx");
	level._effect["dust_impact_med"]		= loadfx ("fx/dust/dust_impact_med.efx");
	level._effect["smoke_plumeBG_toujane"]	= loadfx ("fx/smoke/smoke_plumeBG_toujane.efx");
//	level._effect["thin_black_smoke_M"]		= loadfx ("fx/smoke/thin_black_smoke_M.efx");

	level._effect["tunneldust"]				= loadfx ("fx/dust/tunnel_dust.efx");
	level._effect["wallchunk"] 				= loadfx ("fx/explosions/flak88_explosion.efx");
	level.scr_sound["wallsound"] 			= "mortar_explosion";
	level._effect["exp_pack_doorbreach"]	= loadfx( "fx/explosions/exp_pack_hallway.efx" );


}
treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	
	//tiger fx
	switch(getcvarint("scr_elalamein_fxlevel"))
	{
		case 0:
		dustfx = "fx/dust/tread_dust_elalamein_low.efx"; break;
		case 1:
		dustfx = "fx/dust/tread_dust_elalamein_low.efx"; break;
		case 2:
		dustfx = "fx/dust/tread_dust_elalamein.efx"; break;
		default:
		dustfx = "fx/dust/tread_dust_elalamein.efx"; break;
	}


	maps\_treadfx::setVehicleFX("crusader",	"water",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"ice",		dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"snow",		dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"dirt",		dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"asphalt",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"carpet",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"cloth",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"sand",		dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"grass",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"gravel",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"metal",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"mud",		dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"plaster",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"rock",		dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"wood",		dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"brick",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"concrete",	dustfx);
	maps\_treadfx::setVehicleFX("crusader",	"foliage",	dustfx);
	
	//GermanFordTruck FX
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"water",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"dirt",		dustfx);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"asphalt",	dustfx);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"sand",		dustfx);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"gravel",	dustfx);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"plaster",	dustfx);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"rock",		dustfx);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"foliage",	undefined);
	
	//Opel Blitz FX
	maps\_treadfx::setVehicleFX("blitz",	"water",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		dustfx);
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	dustfx);
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"sand",		dustfx);
	maps\_treadfx::setVehicleFX("blitz",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	dustfx);
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"plaster",	dustfx);
	maps\_treadfx::setVehicleFX("blitz",	"rock",		dustfx);
	maps\_treadfx::setVehicleFX("blitz",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	undefined);

	//Kubelwagon FX
	maps\_treadfx::setVehicleFX("Kubelwagon",	"water",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"dirt",		dustfx);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"asphalt",	dustfx);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"sand",		dustfx);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"gravel",	dustfx);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"plaster",	dustfx);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"rock",		dustfx);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"foliage",	undefined);
	
	//Jeep
	maps\_treadfx::setVehicleFX("jeep",	"water",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"dirt",		dustfx);
	maps\_treadfx::setVehicleFX("jeep",	"asphalt",	dustfx);
	maps\_treadfx::setVehicleFX("jeep",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"sand",		dustfx);
	maps\_treadfx::setVehicleFX("jeep",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"gravel",	dustfx);
	maps\_treadfx::setVehicleFX("jeep",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"plaster",	dustfx);
	maps\_treadfx::setVehicleFX("jeep",	"rock",		dustfx);
	maps\_treadfx::setVehicleFX("jeep",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"foliage",	undefined);
}

spawnWorldFX()
{

	
	//Fire and smoke
///	maps\_fx::loopfx("thin_black_smoke_M", (1895,2328,42), 0.6, (1889,2371,131));
	//maps\_fx::loopfx("med_oil_fire", (2840,1376,320), 2.0, (2840,1376,420));
	//maps\_fx::loopfx("med_oil_fire", (1411,-122,31), 2.0, (1411,-122,131));
	
	//background smoke
//	maps\_fx::loopfx("thin_black_smoke_M", (1895,2328,42), 0.6, (1889,2371,131));
	maps\_fx::loopfx("smoke_plumeBG_toujane", (-7488,1084,10), 1, (-7088,1084,110));
	maps\_fx::loopfx("smoke_plumeBG_toujane", (1224,-314,-4), 1, (1624,-314,95));
	
	//outside flak bunker
	maps\_fx::loopfx("dust_wind_elalamein", (-5188,-6736,200), 0.3, (-5179,-6733,300));
	

}

exploderfx()
{
	maps\_fx::exploderfx(1,"exp_pack_doorbreach",(-10915,-8403,437), undefined, (-10881,-8492,467), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
}

randomGroundDust()
{
	//1st Valley Ground Dust
	index = 0;
	fxorigin [index] = 	(-76,-9648,99);			fxvector [index] =  (-67,-9646,198);	index++;
	fxorigin [index] = 	(-369,-11268,99);		fxvector [index] =  (-360,-11266,198);	index++;
	fxorigin [index] = 	(-435,-10019,99);		fxvector [index] =  (-426,-10016,198);	index++;
	fxorigin [index] = 	(-49,-9065,35);			fxvector [index] =  (-40,-9063,134);	index++;
	fxorigin [index] = 	(-283,-10570,99);		fxvector [index] =  (-274,-10567,198);	index++;
	fxorigin [index] = 	(582,-9906,35);			fxvector [index] =  (591,-9903,134);	index++;
	fxorigin [index] = 	(662,-9142,35);			fxvector [index] =  (671,-9140,134);	index++;
	fxorigin [index] = 	(414,-10666,35);		fxvector [index] =  (423,-10664,134);	index++;
	fxorigin [index] = 	(1312,-10663,35);		fxvector [index] =  (1321,-10661,134);	index++;
	fxorigin [index] = 	(1304,-10023,35);		fxvector [index] =  (1313,-10021,134);	index++;
	fxorigin [index] = 	(1750,-9070,35);		fxvector [index] =  (1759,-9068,134);	index++;
	fxorigin [index] = 	(2075,-9803,35);		fxvector [index] =  (2084,-9801,134);	index++;
	fxorigin [index] = 	(2005,-10761,35);		fxvector [index] =  (2014,-10759,134);	index++;
	fxorigin [index] = 	(1942,-11526,35);		fxvector [index] =  (1951,-11524,134);	index++;
	fxorigin [index] = 	(959,-11767,35);		fxvector [index] =  (968,-11765,134);	index++;
	fxorigin [index] = 	(6,-12107,35);			fxvector [index] =  (15,-12105,134);	index++;

	//2nd Valley Ground Dust
	fxorigin [index] = 	(-11982,-5756,639);		fxvector [index] =  (-11982,-5756,10000);	index++;
	fxorigin [index] = 	(-4783,-11792,13);		fxvector [index] =  (-4775,-11790,113);	index++;
	fxorigin [index] = 	(-4248,-10612,45);		fxvector [index] =  (-4239,-10610,145);	index++;
	fxorigin [index] = 	(-4228,-11153,13);		fxvector [index] =  (-4219,-11151,113);	index++;
	fxorigin [index] = 	(-5295,-10778,77);		fxvector [index] =  (-5286,-10775,177);	index++;
	fxorigin [index] = 	(-4795,-10245,77);		fxvector [index] =  (-4787,-10243,177);	index++;
	fxorigin [index] = 	(-3500,-10222,77);		fxvector [index] =  (-3491,-10220,177);	index++;
	fxorigin [index] = 	(-3427,-9137,77);		fxvector [index] =  (-3418,-9135,177);	index++;
	fxorigin [index] = 	(-3651,-8381,77);		fxvector [index] =  (-3643,-8379,177);	index++;
	fxorigin [index] = 	(-3827,-9557,77);		fxvector [index] =  (-3818,-9555,177);	index++;
	fxorigin [index] = 	(-4453,-12397,13);		fxvector [index] =  (-4444,-12395,113);	index++;
	fxorigin [index] = 	(-5174,-9561,141);		fxvector [index] =  (-5165,-9559,241);	index++;
	fxorigin [index] = 	(-4153,-9101,77);		fxvector [index] =  (-4144,-9099,177);	index++;
	fxorigin [index] = 	(-4769,-8969,77);		fxvector [index] =  (-4760,-8967,177);	index++;
	fxorigin [index] = 	(-4363,-8302,77);		fxvector [index] =  (-4354,-8300,177);	index++;
	fxorigin [index] = 	(-4098,-7665,77);		fxvector [index] =  (-4090,-7663,177);	index++;
	fxorigin [index] = 	(-4610,-6819,77);		fxvector [index] =  (-4601,-6817,177);	index++;
	fxorigin [index] = 	(-3459,-7673,77);		fxvector [index] =  (-3450,-7671,177);	index++;
	fxorigin [index] = 	(-3691,-12294,13);		fxvector [index] =  (-3682,-12292,113);	index++;
	fxorigin [index] = 	(-2796,-11666,257);		fxvector [index] =  (-2787,-11663,356);	index++;
	fxorigin [index] = 	(-2879,-10553,193);		fxvector [index] =  (-2870,-10551,292);	index++;
	fxorigin [index] = 	(-2540,-11153,257);		fxvector [index] =  (-2531,-11151,356);	index++;
	fxorigin [index] = 	(-4995,-8317,148);		fxvector [index] =  (-4987,-8315,247);	index++;
	fxorigin [index] = 	(-5962,-8237,317);		fxvector [index] =  (-5954,-8235,416);	index++;
	fxorigin [index] = 	(-6024,-8713,317);		fxvector [index] =  (-6016,-8711,416);	index++;
	fxorigin [index] = 	(-5368,-8860,171);		fxvector [index] =  (-5360,-8858,270);	index++;
	fxorigin [index] = 	(-5621,-9265,192);		fxvector [index] =  (-5612,-9263,291);	index++;
	fxorigin [index] = 	(-6140,-9259,235);		fxvector [index] =  (-6131,-9257,334);	index++;
	fxorigin [index] = 	(-5815,-10423,193);		fxvector [index] =  (-5806,-10421,292);	index++;
	fxorigin [index] = 	(-6469,-11914,393);		fxvector [index] =  (-6460,-11912,492);	index++;
	fxorigin [index] = 	(-6518,-11019,361);		fxvector [index] =  (-6509,-11017,460);	index++;
	fxorigin [index] = 	(-6560,-11475,361);		fxvector [index] =  (-6551,-11473,460);	index++;
	fxorigin [index] = 	(-6364,-6803,341);		fxvector [index] =  (-6355,-6800,441);	index++;
	fxorigin [index] = 	(-6231,-7716,340);		fxvector [index] =  (-6222,-7713,440);	index++;
	fxorigin [index] = 	(-6147,-7178,340);		fxvector [index] =  (-6138,-7175,440);	index++;
	fxorigin [index] = 	(-3591,-11601,13);		fxvector [index] =  (-3582,-11599,113);	index++;
	fxorigin [index] = 	(-3515,-11086,38);		fxvector [index] =  (-3506,-11084,138);	index++;
	fxorigin [index] = 	(-3783,-10731,45);		fxvector [index] =  (-3774,-10729,145);	index++;
	fxorigin [index] = 	(-4555,-11139,13);		fxvector [index] =  (-4546,-11137,113);	index++;
	fxorigin [index] = 	(-4040,-11590,13);		fxvector [index] =  (-4031,-11588,113);	index++;
	fxorigin [index] = 	(-3379,-9944,77);		fxvector [index] =  (-3370,-9942,177);	index++;
	fxorigin [index] = 	(-4148,-10001,77);		fxvector [index] =  (-4139,-9999,177);	index++;
	fxorigin [index] = 	(-4587,-9669,77);		fxvector [index] =  (-4578,-9667,177);	index++;
	fxorigin [index] = 	(-4738,-7657,77);		fxvector [index] =  (-4729,-7655,177);	index++;
	fxorigin [index] = 	(-4468,-7282,77);		fxvector [index] =  (-4459,-7280,177);	index++;
	fxorigin [index] = 	(-3827,-7273,77);		fxvector [index] =  (-3818,-7271,177);	index++;
	fxorigin [index] = 	(-4212,-3817,77);		fxvector [index] =  (-4203,-3815,177);	index++;
	fxorigin [index] = 	(-4061,-6961,77);		fxvector [index] =  (-4052,-6959,177);	index++;
	fxorigin [index] = 	(-3734,-6649,77);		fxvector [index] =  (-3725,-6647,177);	index++;
	fxorigin [index] = 	(-3189,-6870,77);		fxvector [index] =  (-3180,-6868,177);	index++;
	fxorigin [index] = 	(-3383,-6359,77);		fxvector [index] =  (-3374,-6357,177);	index++;
	fxorigin [index] = 	(-4119,-6363,77);		fxvector [index] =  (-4110,-6361,177);	index++;
	fxorigin [index] = 	(-4569,-6045,77);		fxvector [index] =  (-4560,-6043,177);	index++;
	fxorigin [index] = 	(-4703,-5533,77);		fxvector [index] =  (-4694,-5531,177);	index++;
	fxorigin [index] = 	(-4191,-5546,13);		fxvector [index] =  (-4182,-5544,113);	index++;
	fxorigin [index] = 	(-3751,-5877,13);		fxvector [index] =  (-3742,-5875,113);	index++;
	fxorigin [index] = 	(-3298,-5696,77);		fxvector [index] =  (-3289,-5694,177);	index++;
	fxorigin [index] = 	(-3671,-5239,77);		fxvector [index] =  (-3662,-5237,177);	index++;
	fxorigin [index] = 	(-4434,-5027,77);		fxvector [index] =  (-4425,-5025,177);	index++;
	fxorigin [index] = 	(-3980,-4783,77);		fxvector [index] =  (-3971,-4781,177);	index++;
	fxorigin [index] = 	(-3278,-4864,77);		fxvector [index] =  (-3269,-4862,177);	index++;
	fxorigin [index] = 	(-3278,-4864,77);		fxvector [index] =  (-3269,-4862,177);	index++;
	fxorigin [index] = 	(-3644,-4151,77);		fxvector [index] =  (-3635,-4149,177);	index++;
	fxorigin [index] = 	(-4482,-4386,77);		fxvector [index] =  (-4473,-4384,177);	index++;
	fxorigin [index] = 	(-4940,-4759,77);		fxvector [index] =  (-4931,-4757,177);	index++;
	fxorigin [index] = 	(-4940,-4759,77);		fxvector [index] =  (-4931,-4757,177);	index++;
	fxorigin [index] = 	(-4981,-3862,77);		fxvector [index] =  (-4972,-3860,177);	index++;
	fxorigin [index] = 	(-4212,-3817,77);		fxvector [index] =  (-4203,-3815,177);	index++;
	
	//3rd Valley Ground Dust
	fxorigin [index] = 	(-7734,-7078,221);		fxvector [index] =  (-7734,-7078,321);	index++;
	fxorigin [index] = 	(-7808,-7617,221);		fxvector [index] =  (-7808,-7617,321);	index++;
	fxorigin [index] = 	(-8214,-4528,107);		fxvector [index] =  (-8214,-4528,207);	index++;
	fxorigin [index] = 	(-8505,-7549,71);		fxvector [index] =  (-8505,-7549,171);	index++;
	fxorigin [index] = 	(-8291,-7046,71);		fxvector [index] =  (-8291,-7046,171);	index++;
	fxorigin [index] = 	(-8939,-6967,71);		fxvector [index] =  (-8939,-6967,171);	index++;
	fxorigin [index] = 	(-9363,-7499,171);		fxvector [index] =  (-9363,-7499,271);	index++;
	fxorigin [index] = 	(-9713,-6975,203);		fxvector [index] =  (-9713,-6975,303);	index++;
	fxorigin [index] = 	(-10179,-6237,171);		fxvector [index] =  (-10179,-6237,271);	index++;
	fxorigin [index] = 	(-8738,-6265,75);		fxvector [index] =  (-8738,-6265,175);	index++;
	fxorigin [index] = 	(-8067,-6225,139);		fxvector [index] =  (-8067,-6225,239);	index++;
	fxorigin [index] = 	(-8375,-5510,139);		fxvector [index] =  (-8375,-5510,239);	index++;
	fxorigin [index] = 	(-9058,-5362,139);		fxvector [index] =  (-9058,-5362,239);	index++;
	fxorigin [index] = 	(-9412,-6282,75);		fxvector [index] =  (-9412,-6282,175);	index++;
	fxorigin [index] = 	(-9765,-5391,107);		fxvector [index] =  (-9765,-5391,207);	index++;
	fxorigin [index] = 	(-8526,-3685,107);		fxvector [index] =  (-8526,-3685,207);	index++;
	fxorigin [index] = 	(-8917,-4542,107);		fxvector [index] =  (-8917,-4542,207);	index++;
	fxorigin [index] = 	(-9749,-4559,107);		fxvector [index] =  (-9749,-4559,207);	index++;
	fxorigin [index] = 	(-9749,-3791,107);		fxvector [index] =  (-9749,-3791,207);	index++;
	fxorigin [index] = 	(-10874,-2691,235);		fxvector [index] =  (-10874,-2691,335);	index++;
	fxorigin [index] = 	(-8461,-2868,107);		fxvector [index] =  (-8461,-2868,207);	index++;
	fxorigin [index] = 	(-9244,-3472,107);		fxvector [index] =  (-9244,-3472,207);	index++;
	fxorigin [index] = 	(-9158,-2770,107);		fxvector [index] =  (-9158,-2770,207);	index++;
	fxorigin [index] = 	(-9822,-3026,107);		fxvector [index] =  (-9822,-3026,207);	index++;
	fxorigin [index] = 	(-10344,-4233,209);		fxvector [index] =  (-10344,-4233,309);	index++;
	fxorigin [index] = 	(-10430,-3184,273);		fxvector [index] =  (-10430,-3184,373);	index++;
	fxorigin [index] = 	(-10746,-3762,273);		fxvector [index] =  (-10746,-3762,373);	index++;
	fxorigin [index] = 	(-10083,-2226,107);		fxvector [index] =  (-10083,-2226,207);	index++;
	fxorigin [index] = 	(-10732,-2163,235);		fxvector [index] =  (-10732,-2163,335);	index++;
	fxorigin [index] = 	(-10983,-4438,273);		fxvector [index] =  (-10983,-4438,373);	index++;
	fxorigin [index] = 	(-11152,-5099,391);		fxvector [index] =  (-11152,-5099,491);	index++;
	fxorigin [index] = 	(-10793,-5723,279);		fxvector [index] =  (-10793,-5723,379);	index++;
	fxorigin [index] = 	(-11000,-6109,387);		fxvector [index] =  (-11000,-6109,487);	index++;
	fxorigin [index] = 	(-11080,-6959,451);		fxvector [index] =  (-11080,-6959,551);	index++;
	fxorigin [index] = 	(-10888,-7607,487);		fxvector [index] =  (-10888,-7607,587);	index++;
	fxorigin [index] = 	(-11146,-10279,507);	fxvector [index] =  (-11146,-10279,607); index++;
	fxorigin [index] = 	(-10674,-8230,443);		fxvector [index] =  (-10674,-8230,543);	index++;
	fxorigin [index] = 	(-10818,-8738,507);		fxvector [index] =  (-10818,-8738,607);	index++;
	fxorigin [index] = 	(-10712,-9637,427);		fxvector [index] =  (-10712,-9637,527);	index++;
	fxorigin [index] = 	(-11137,-9380,507);		fxvector [index] =  (-11137,-9380,607);	index++;
	
	//4th Valley Ground  Dust
	fxorigin [index] = 	(-12540,-7526,227);		fxvector [index] =  (-12540,-7526,327);	index++;
	fxorigin [index] = 	(-13412,-4832,99);		fxvector [index] =  (-13412,-4832,199);	index++;
	fxorigin [index] = 	(-12585,-8068,227);		fxvector [index] =  (-12585,-8068,327);	index++;
	fxorigin [index] = 	(-13022,-8465,163);		fxvector [index] =  (-13022,-8465,263);	index++;
	fxorigin [index] = 	(-13653,-8380,99);		fxvector [index] =  (-13653,-8380,199);	index++;
	fxorigin [index] = 	(-14998,-8289,35);		fxvector [index] =  (-14998,-8289,135);	index++;
	fxorigin [index] = 	(-14099,-8964,35);		fxvector [index] =  (-14099,-8964,135);	index++;
	fxorigin [index] = 	(-14291,-8305,35);		fxvector [index] =  (-14291,-8305,135);	index++;
	fxorigin [index] = 	(-14927,-8882,35);		fxvector [index] =  (-14927,-8882,135);	index++;
	fxorigin [index] = 	(-15694,-8908,35);		fxvector [index] =  (-15694,-8908,135);	index++;
	fxorigin [index] = 	(-15758,-8271,35);		fxvector [index] =  (-15758,-8271,135);	index++;
	fxorigin [index] = 	(-16089,-7700,35);		fxvector [index] =  (-16089,-7700,135);	index++;
	fxorigin [index] = 	(-15321,-7699,35);		fxvector [index] =  (-15321,-7699,135);	index++;
	fxorigin [index] = 	(-14616,-8018,35);		fxvector [index] =  (-14616,-8018,135);	index++;
	fxorigin [index] = 	(-14105,-7632,35);		fxvector [index] =  (-14105,-7632,135);	index++;
	fxorigin [index] = 	(-13529,-7631,35);		fxvector [index] =  (-13529,-7631,135);	index++;
	fxorigin [index] = 	(-13095,-7107,35);		fxvector [index] =  (-13095,-7107,135);	index++;
	fxorigin [index] = 	(-14119,-7043,35);		fxvector [index] =  (-14119,-7043,135);	index++;
	fxorigin [index] = 	(-15079,-7044,35);		fxvector [index] =  (-15079,-7044,135);	index++;
	fxorigin [index] = 	(-15719,-7044,-28);		fxvector [index] =  (-15719,-7044,71);	index++;
	fxorigin [index] = 	(-16487,-7044,99);		fxvector [index] =  (-16487,-7044,199);	index++;
	fxorigin [index] = 	(-16153,-6315,99);		fxvector [index] =  (-16153,-6315,199);	index++;
	fxorigin [index] = 	(-15323,-6257,35);		fxvector [index] =  (-15323,-6257,135);	index++;
	fxorigin [index] = 	(-14621,-6209,35);		fxvector [index] =  (-14621,-6209,135);	index++;
	fxorigin [index] = 	(-14174,-6272,35);		fxvector [index] =  (-14174,-6272,135);	index++;
	fxorigin [index] = 	(-12943,-6349,99);		fxvector [index] =  (-12943,-6349,199);	index++;
	fxorigin [index] = 	(-13251,-5600,35);		fxvector [index] =  (-13251,-5600,135);	index++;
	fxorigin [index] = 	(-13599,-6138,35);		fxvector [index] =  (-13599,-6138,135);	index++;
	fxorigin [index] = 	(-13844,-5385,35);		fxvector [index] =  (-13844,-5385,135);	index++;
	fxorigin [index] = 	(-14907,-5649,35);		fxvector [index] =  (-14907,-5649,135);	index++;
	fxorigin [index] = 	(-15550,-5639,35);		fxvector [index] =  (-15550,-5639,135);	index++;
	fxorigin [index] = 	(-16315,-5580,35);		fxvector [index] =  (-16315,-5580,135);	index++;
	fxorigin [index] = 	(-15915,-5015,35);		fxvector [index] =  (-15915,-5015,135);	index++;
	fxorigin [index] = 	(-15213,-5100,35);		fxvector [index] =  (-15213,-5100,135);	index++;
	fxorigin [index] = 	(-14639,-5180,35);		fxvector [index] =  (-14639,-5180,135);	index++;
	fxorigin [index] = 	(-16283,-3509,35);		fxvector [index] =  (-16283,-3509,135);	index++;
	fxorigin [index] = 	(-14048,-4685,35);		fxvector [index] =  (-14048,-4685,135);	index++;
	fxorigin [index] = 	(-14764,-4545,35);		fxvector [index] =  (-14764,-4545,135);	index++;
	fxorigin [index] = 	(-15467,-4500,35);		fxvector [index] =  (-15467,-4500,135);	index++;
	fxorigin [index] = 	(-16297,-4447,35);		fxvector [index] =  (-16297,-4447,135);	index++;
	fxorigin [index] = 	(-15875,-3975,35);		fxvector [index] =  (-15875,-3975,135);	index++;
	fxorigin [index] = 	(-15037,-4057,35);		fxvector [index] =  (-15037,-4057,135);	index++;
	fxorigin [index] = 	(-14398,-4021,35);		fxvector [index] =  (-14398,-4021,135);	index++;
	fxorigin [index] = 	(-13759,-3986,35);		fxvector [index] =  (-13759,-3986,135);	index++;
	fxorigin [index] = 	(-14171,-3496,35);		fxvector [index] =  (-14171,-3496,135);	index++;
	fxorigin [index] = 	(-14971,-2373,35);		fxvector [index] =  (-14971,-2373,135);	index++;
	fxorigin [index] = 	(-15515,-3488,35);		fxvector [index] =  (-15515,-3488,135);	index++;
	fxorigin [index] = 	(-14938,-3538,35);		fxvector [index] =  (-14938,-3538,135);	index++;
	fxorigin [index] = 	(-14613,-2927,35);		fxvector [index] =  (-14613,-2927,135);	index++;
	fxorigin [index] = 	(-13979,-2821,35);		fxvector [index] =  (-13979,-2821,135);	index++;
	fxorigin [index] = 	(-15192,-2901,35);		fxvector [index] =  (-15192,-2901,135);	index++;
	fxorigin [index] = 	(-15831,-2943,35);		fxvector [index] =  (-15831,-2943,135);	index++;
	fxorigin [index] = 	(-16478,-2858,35);		fxvector [index] =  (-16478,-2858,135);	index++;
	fxorigin [index] = 	(-16124,-2385,35);		fxvector [index] =  (-16124,-2385,135);	index++;
	fxorigin [index] = 	(-15609,-2415,35);		fxvector [index] =  (-15609,-2415,135);	index++;
	fxorigin [index] = 	(-14971,-2373,35);		fxvector [index] =  (-14971,-2373,135);	index++;
	fxorigin [index] = 	(-14387,-2288,35);		fxvector [index] =  (-14387,-2288,135);	index++;
	fxorigin [index] = 	(-13744,-2272,35);		fxvector [index] =  (-13744,-2272,135);	index++;
	fxorigin [index] = 	(-14089,-1733,35);		fxvector [index] =  (-14089,-1733,135);	index++;
	fxorigin [index] = 	(-14792,-1684,35);		fxvector [index] =  (-14792,-1684,135);	index++;
	fxorigin [index] = 	(-15316,-1841,35);		fxvector [index] =  (-15316,-1841,135);	index++;
	fxorigin [index] = 	(-15758,-1746,35);		fxvector [index] =  (-15758,-1746,135);	index++;
	fxorigin [index] = 	(-16333,-1706,99);		fxvector [index] =  (-16333,-1706,199);	index++;
	fxorigin [index] = 	(-16042,-1213,35);		fxvector [index] =  (-16042,-1213,135);	index++;
	fxorigin [index] = 	(-15468,-1253,99);		fxvector [index] =  (-15468,-1253,199);	index++;
	fxorigin [index] = 	(-14752,-1110,99);		fxvector [index] =  (-14752,-1110,199);	index++;
	fxorigin [index] = 	(-14105,-1026,99);		fxvector [index] =  (-14105,-1026,199);	index++;

	switch(getcvarint("scr_elalamein_fxlevel"))
	{
		case 0:
		mins = 0.5; maxs = 0.7; break;
		case 1:
		mins = 0.4; maxs = 0.5; break;
		case 2:
		mins = 0.1; maxs = 0.3; break;
		default:
		mins = 0.1; maxs = 0.3; break;
	}

	for (i = 0; i < fxorigin.size; i++)
	{
		maps\_fx::gunfireloopfxVec ("dust_wind_elalamein", fxorigin [i], fxvector [i],	// Origin
							50, 100,					// Number of shots
							maxs, mins,				// seconds between shots
							3, 10);					// seconds between sets of shots.
	}	
}

tread (tagname, side, relativeOffset)  //special elalamein tread thread
{
	self endon ("death");
	treadfx = maps\_treads::treadget(self, side);
	wait .1;
	
	switch(getcvarint("scr_elalamein_fxlevel"))
	{
		case 0:
		self.tuningvalue = 140; break;
		case 1:
		self.tuningvalue = 80; break;
		case 2:
		self.tuningvalue = 40; break;
		default:
		self.tuningvalue = 40; break;
	}
	
	
	for (;;)
	{
		speed = self getspeed();
		if (speed == 0)
		{
			wait 0.1;
			continue;
		}
		waitTime = (1 / speed);
		waitTime = (waitTime * self.TuningValue * (level.fxfireloopmod));
		if (waitTime < 0.1)
			waitTime = 0.1;
		else if (waitTime > 0.7)
			waitTime = 0.7;
		wait waitTime;
		lastfx = treadfx;
		treadfx = maps\_treads::treadget(self, side);
		if(treadfx != lastfx)
			self notify ("treadtypechanged");
		if(treadfx != -1)
		{
			ang = self getTagAngles(tagname);
			forwardVec = anglestoforward(ang);
			rightVec = anglestoright(ang);
			upVec = anglestoup(ang);
			effectOrigin = self getTagOrigin(tagname);
			effectOrigin += vectorMultiply(forwardVec, relativeOffset[0]);
			effectOrigin += vectorMultiply(rightVec, relativeOffset[1]);
			effectOrigin += vectorMultiply(upVec, relativeOffset[2]);
			forwardVec = vectorMultiply(forwardVec, waitTime);
			playfx (treadfx, effectOrigin, (0,0,0) - forwardVec);
		}
	}
}