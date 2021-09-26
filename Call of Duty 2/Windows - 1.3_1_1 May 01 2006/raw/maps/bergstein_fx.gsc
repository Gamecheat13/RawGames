main()
{	
	precache();
	ambientFX();
	treadFX();
	level thread playerEffect();
	
	
	
}

precache()
{

	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_mud.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_water.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_water.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_water.efx"));

	level._effect["rain_heavy"]					= loadfx ("fx/misc/rain_heavy.efx");
	level._effect["rain_heavy_cloudtype"]		= loadfx ("fx/misc/rain_heavy_cloudtype.efx");
	//level._effect["rain_mist"]					= loadfx ("fx/misc/rain_mist.efx");
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M.efx");         																																																																																

	level._effect["building_fire_small"]		= loadfx ("fx/fire/building_fire_small.efx");
	level._effect["ground_fire_med_nosmoke"]	= loadfx ("fx/fire/ground_fire_med_nosmoke.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");

	level._effect["pshreck_smoke"]				= loadfx ("fx/smoke/thin_light_smoke_M.efx");
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["insects_carcass_flies"]		= loadfx ("fx/misc/insects_carcass_flies.efx");
	level._effect["pshreck_impact"]				= loadfx ("fx/explosions/pschreck_dirt_crossroads.efx");

	
	//zombie fire
	level._effect["torso"]						= loadfx ("fx/fire/character_torso_fire.efx");
	level._effect["arms"]						= loadfx ("fx/fire/character_arm_fire.efx");
	
	level._effect["cold_breath"]				= loadfx ("fx/misc/cold_breath.efx");	
	
	//mortar stuff
	level._effect["mortar"] 					= loadfx("fx/explosions/mortarExp_mud.efx");
	level._effect["mortar2"] 					= loadfx("fx/explosions/mortarExp_mud.efx");
	
	level._effectType["mortar"]	= "mortar";
	level._effectType["mortar2"]	= "mortar";
	level.mortar = level._effect["mortar"];
	
}

playerEffect()
{
	player = getent("player","classname");
	for (;;)
	{
		playfx ( level._effect["rain_heavy"], player.origin + (0,0,650));
		playfx ( level._effect["rain_heavy_cloudtype"], player.origin + (0,0,650));
		//playfx ( level._effect["rain_mist"], player.origin + (0,0,350));
		wait (0.3);
	}
}

ambientFX()
{
	
	maps\_fx::exploderfx(1, "pshreck_impact", (-14285,1801,10340), 0, (-14304,1802,10438));

	maps\_fx::loopfx("thin_light_smoke_M", (3244,398,1), 1, (3244,398,100));
	maps\_fx::loopfx("thin_light_smoke_M", (-19990,7501,10139), 1, (-19990,7501,10239));
	maps\_fx::loopfx("thin_light_smoke_M", (-18947,6723,10134), 1, (-18947,6723,10234));
	maps\_fx::loopfx("thin_light_smoke_M", (-21802,5788,10113), 1, (-21802,5788,10213));
	maps\_fx::loopfx("thin_light_smoke_M", (-18354,7230,10137), 1, (-18354,7230,10237));
	maps\_fx::loopfx("thin_light_smoke_M", (-12951,2235,10257), 1, (-12951,2235,10357));
	maps\_fx::loopfx("thin_light_smoke_M", (-14546,1712,10274), 1, (-14546,1712,10374));
//	maps\_fx::loopfx("thin_light_smoke_M", (-15552,3137,10250), 1, (-15552,3137,10350));
	maps\_fx::loopfx("thin_light_smoke_M", (-17695,4121,10192), 1, (-17695,4121,10292));
	maps\_fx::loopfx("thin_light_smoke_M", (-21714,5208,10093), 1, (-21714,5208,10193));
	maps\_fx::loopfx("thin_light_smoke_M", (-21419,4092,10101), 1, (-21419,4092,10201));
	maps\_fx::loopfx("thin_light_smoke_M", (-20258,4756,10128), 1, (-20258,4756,10228));

	//Roadblock Building fire
	maps\_fx::loopfx("building_fire_small", (-16644,5437,10510), 2, (-16624,5533,10529));
	maps\_fx::loopfx("ground_fire_med_nosmoke", (-16576,5141,10533), 2, (-16576,5141,10633));
	maps\_fx::loopfx("thin_black_smoke_M", (-16602,5244,10607), 1, (-16602,5244,10707));
	maps\_fx::loopfx("tank_fire_engine", (-16484,5403,10463), 1, (-16484,5403,10563));
	maps\_fx::loopfx("tank_fire_engine", (-16568,5265,10719), 1, (-16568,5265,10819));

	/*
	//Flies should be reenabled if the rain stops
	maps\_fx::loopfx("insects_carcass_flies", (-21448,3496,10164), 0.3, (-21448,3496,10174));
	maps\_fx::loopfx("insects_carcass_flies", (-20246,6290,10181), 0.3, (-20246,6290,10191));
	maps\_fx::loopfx("insects_carcass_flies", (-16901,4699,10278), 0.3, (-16901,4699,10288));
	maps\_fx::loopfx("insects_carcass_flies", (-17245,4300,10284), 0.3, (-17245,4300,10294));
	maps\_fx::loopfx("insects_carcass_flies", (-15986,2301,10294), 0.3, (-15986,2301,10304));
	maps\_fx::loopfx("insects_carcass_flies", (-14055,2300,10352), 0.3, (-14055,2300,10362));
	maps\_fx::loopfx("insects_carcass_flies", (-16456,4714,10292), 0.3, (-16456,4714,10302));
	maps\_fx::loopfx("insects_carcass_flies", (-14481,1291,10335), 0.3, (-16456,4714,10342));
	*/

}

treadFX()
{
	
	//This overrides the default effects for treads for this level only
	//Jeep fx
	maps\_treadfx::setVehicleFX("jeep",	"water",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"dirt",		"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"asphalt",	"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"sand",		"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"grass",	"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"gravel",	"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"mud",		"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"plaster",	"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"rock",		"fx/impacts/footstep_mud.efx");
	maps\_treadfx::setVehicleFX("jeep",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"foliage",	undefined);
	
}