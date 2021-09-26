main()
{
	precacheFX();
	spawnWorldFX();
	treadFX();
	fireAntiAirTracers();
	level thread playerEffect();
}

precacheFX()
{
//	level._effect["bomb"]					= loadfx ("fx/explosions/condor_bomb.efx");
//	level._effect["bomb"]					= loadfx ("fx/explosions/condor_bomb2.efx");
//	level._effect["bomb"]					= loadfx ("fx/impacts/largemortar_dirt3.efx");
//	level._effect["bomb"]					= loadfx ("fx/explosions/testbomb.efx");
	level._effect["bomb"] 					= loadfx ("fx/explosions/artilleryExp_dirt_brown.efx");
	level._effect["snow_light"]				= loadfx ("fx/misc/snow_light.efx");
//	level._effect["snow_heavy"]				= loadfx ("fx/misc/snow_heavy.efx");
	level._effect["cold_breath"]			= loadfx ( "fx/misc/cold_breath.efx" );
	level._effect["pipe_hit"]				= loadfx ("fx/impacts/pipe_impact.efx");
	level._effect["barrel_fire"]			= loadfx ("fx/props/barrel_fire2.efx");
	level._effect["sandbags"]				= loadfx ("fx/explosions/sandbag_explosion.efx");
	level._effect["tankbomb"]				= loadfx ("fx/explosions/grenadeExp_snow.efx");

	level._effectType["bomb"]				= "bomb";
	level._effect["bomb_impact"]			= level._effect["bomb"];
	level._effectType["bomb_impact"]		= level._effectType["bomb"];

	level._effect["mortar"]					= loadfx ("fx/explosions/mortarExp_beach.efx");
	level._effectType["mortar"]				= "mortar";
	level.mortar 							= level._effect["mortar"];
	
	level._effect["german1_mortar"]			= level._effect["mortar"];
	level._effectType["german1_mortar"]		= level._effectType["mortar"];
	level._effect["german2_mortar"]			= level._effect["mortar"];
	level._effectType["german2_mortar"]		= level._effectType["mortar"];
	level._effect["russian_mortar"]			= level._effect["mortar"];
	level._effectType["russian_mortar"]		= level._effectType["mortar"];
    level._effect["antiair_tracers"]	= loadfx ("fx/misc/antiair_tracers.efx");

	level._effect["sticky_explosion"]		= loadfx("fx/explosions/grenadeExp_blacktop.efx");
	level._effect["sticky_explosion_smoke"]		= loadfx("fx/smoke/thin_black_smoke_S.efx");

}

spawnWorldFX()
{
	maps\_fx::loopfx("barrel_fire", (-218,-963,30), 1.0);
}

playerEffect()
{
	player = getent("player","classname");
	for (;;)
	{
		playfx ( level._effect["snow_light"], player.origin + (0,0,300), player.origin + (0,0,350) );
		wait (0.75);
	}
}

fireAntiAirTracers()
{

    maps\_fx::gunfireLoopfx("antiair_tracers", (3904, -4992, 496),
							1, 4,
							5.2, 3.4,
							3.2, 4.5);
    maps\_fx::gunfireLoopfx("antiair_tracers", (3712, -4352, 496),
							2, 4,
							9.2, 4.4,
							1.2, 4.5);
    maps\_fx::gunfireLoopfx("antiair_tracers", (4032, -3840, 496),
							2, 3,
							5.1,6.4,
							2.1, 5.3);
    maps\_fx::gunfireLoopfx("antiair_tracers", (3776, -3200, 496),
							2, 3,
							5.1,6.4,
							2.1, 5.3);
}

treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	//panzer2 fx
	maps\_treadfx::setVehicleFX("panzer2",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"asphalt",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"carpet",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"cloth",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"sand",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"grass",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"gravel",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("panzer2",	"mud",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"plaster",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"rock",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"wood",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"brick",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"concrete",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("panzer2",	"foliage",	"fx/dust/tread_dust_snow.efx");

	//german halftrack
	maps\_treadfx::setVehicleFX("germanhalftrack",	"water",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"ice",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"snow",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"dirt",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"asphalt",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"carpet",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"cloth",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"sand",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"grass",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"gravel",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("germanhalftrack",	"mud",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"plaster",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"rock",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"wood",		"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"brick",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"concrete",	"fx/dust/tread_dust_snow.efx");
	maps\_treadfx::setVehicleFX("germanhalftrack",	"foliage",	"fx/dust/tread_dust_snow.efx");

}
