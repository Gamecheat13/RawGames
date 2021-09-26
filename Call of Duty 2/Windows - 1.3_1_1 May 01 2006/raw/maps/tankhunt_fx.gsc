main()
{
	precacheFX();
	level thread playerEffect();
	level thread soundFX();
	spawnWorldFX();
	exploderFX();
	treadFX();

}

precacheFX()
{
	
	//footstep fx
	animscripts\utility::setFootstepEffect ("snow",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("gravel",	loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("mud",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("grass",	loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("dirt",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("concrete",	loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("rock",		loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",	loadfx ("fx/impacts/footstep_snow.efx"));
	animscripts\utility::setFootstepEffect ("plaster",	loadfx ("fx/impacts/footstep_snow.efx"));

	level._effect["heavysmoke"]				= loadfx ("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect["snow_light"]				= loadfx ("fx/misc/snow_light.efx");

	level._effect["sticky_explosion"]			= loadfx("fx/explosions/default_explosion.efx");
	level._effect["sticky_explosion_smoke"]			= loadfx("fx/smoke/thin_black_smoke_S.efx");

	level._effect["cold_breath"]				= loadfx ("fx/misc/cold_breath.efx");

	level._effect["dust"]					= loadfx ("fx/explosions/pschreck_dirt_crossroads.efx");
	level._effect["piano_impact"]				= loadfx("fx/explosions/piano_impact.efx");
	
	level._effect["fogbank_small_duhoc"]			= loadfx ("fx/misc/fogbank_small_duhoc.efx");
	level._effect["snow_wind_cityhall"]			= loadfx ("fx/misc/snow_wind_cityhall.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");
	level._effect["tank_fire_turret"] 			= loadfx ("fx/fire/tank_fire_turret_small.efx");

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

spawnWorldFX()
{
	maps\_fx::loopfx("heavysmoke", (1675,1924,30), 0.6, (1675,1924,130));
	maps\_fx::loopfx("snow_wind_cityhall", (1047,-3118,0), 1, (1047,-3118,100));
	maps\_fx::loopfx("snow_wind_cityhall", (382,-2679,64), 1, (382,-2679,164));
	maps\_fx::loopfx("snow_wind_cityhall", (1073,-2554,2), 1, (1073,-2554,102));
	maps\_fx::loopfx("snow_wind_cityhall", (1063,-2057,-22), 1, (1063,-2057,77));
	maps\_fx::loopfx("snow_wind_cityhall", (1033,-1446,-1), 1, (1033,-1446,98));
	maps\_fx::loopfx("snow_wind_cityhall", (1010,-187,-3), 1, (1010,-187,96));
	maps\_fx::loopfx("snow_wind_cityhall", (506,-1801,68), 1, (506,-1801,168));
	maps\_fx::loopfx("snow_wind_cityhall", (512,-690,112), 1, (512,-690,212));
	maps\_fx::loopfx("snow_wind_cityhall", (-1005,1696,475), 1, (-1005,1696,575));
	maps\_fx::loopfx("snow_wind_cityhall", (454,1144,153), 1, (454,1144,253));
	maps\_fx::loopfx("snow_wind_cityhall", (1102,1305,2), 1, (1102,1305,102));
	maps\_fx::loopfx("snow_wind_cityhall", (1995,889,8), 1, (1995,889,108));
	maps\_fx::loopfx("snow_wind_cityhall", (-239,1546,133), 1, (-239,1546,233));
	maps\_fx::loopfx("snow_wind_cityhall", (-1936,-979,10), 1, (-1936,-979,110));
	maps\_fx::loopfx("snow_wind_cityhall", (-1368,-1253,10), 1, (-1368,-1253,110));
	maps\_fx::loopfx("snow_wind_cityhall", (2073,203,0), 1, (2073,203,99));
	maps\_fx::loopfx("snow_wind_cityhall", (1927,-434,3), 1, (1927,-434,102));
	maps\_fx::loopfx("snow_wind_cityhall", (-1318,-375,26), 1, (-1318,-375,126));
	maps\_fx::loopfx("tank_fire_engine", (-653,-398,26), 1, (-600,-324,67));
	maps\_fx::loopfx("tank_fire_engine", (-701,-395,44), 1, (-695,-386,143));
	maps\_fx::loopfx("snow_wind_cityhall", (-1015,2271,63), 1, (-1015,2271,163));
	maps\_fx::loopfx("snow_wind_cityhall", (-407,2671,0), 1, (-407,2671,99));
	maps\_fx::loopfx("snow_wind_cityhall", (-437,2156,0), 1, (-437,2156,99));
	maps\_fx::loopfx("snow_wind_cityhall", (1085,1817,2), 1, (1085,1817,102));
	maps\_fx::loopfx("fogbank_small_duhoc", (1602,1502,43), 2, (1602,1502,143));
	maps\_fx::loopfx("fogbank_small_duhoc", (575,1430,143), 2, (575,1430,243));
	maps\_fx::loopfx("fogbank_small_duhoc", (332,-322,3), 2, (332,-322,103));
	maps\_fx::loopfx("fogbank_small_duhoc", (2065,-3351,-21), 2, (2065,-3351,78));
	maps\_fx::loopfx("fogbank_small_duhoc", (1453,-3417,1), 2, (1453,-3417,101));
	maps\_fx::loopfx("fogbank_small_duhoc", (514,-3448,-26), 2, (514,-3448,73));
	maps\_fx::loopfx("fogbank_small_duhoc", (-329,-3347,31), 2, (-329,-3347,131));
	maps\_fx::loopfx("fogbank_small_duhoc", (-913,-1539,5), 2, (-913,-1539,105));
	maps\_fx::loopfx("fogbank_small_duhoc", (-312,-1558,-38), 2, (-312,-1558,61));
	maps\_fx::loopfx("fogbank_small_duhoc", (408,-1386,17), 2, (408,-1386,117));
	maps\_fx::loopfx("fogbank_small_duhoc", (-619,-468,-15), 2, (-619,-468,84));
	maps\_fx::loopfx("fogbank_small_duhoc", (-590,492,-24), 2, (-590,492,75));
	maps\_fx::loopfx("fogbank_small_duhoc", (-877,1411,284), 2, (-877,1411,384));
	maps\_fx::loopfx("fogbank_small_duhoc", (25,680,118), 2, (25,680,218));

}

soundFX()
{
	waittillframeend;
	level.scr_sound["wall_crumble"]			= "wall_crumble";
}

exploderFX()
{
	maps\_fx::exploderfx(50,"piano_impact",(-306,564,0), 0, (-306,564,100), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	maps\_fx::exploderfx(1,"dust",(824,-1377,46), 0, (835,-1359,143), undefined, undefined, undefined, undefined, undefined, undefined, "wall_crumble", undefined, undefined, undefined, undefined, undefined);
	maps\_fx::exploderfx(0,"dust",(889,921,147), 0, (836,921,231), undefined, undefined, undefined, undefined, undefined, undefined, "wall_crumble", undefined, undefined, undefined, undefined, undefined);

}

treadFX()
{
	
	//This overrides the default effects for treads for this level only

	//german halftrack
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

}