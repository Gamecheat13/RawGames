main()
{
	precacheFX();
	treadFX();
	spawnWorldFX();
	level thread soundFX();

}

precacheFX()
{
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_mud_beltot.efx"));
	//animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_mud_beltot.efx"));
	//animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_mud_beltot.efx"));
	//animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_water.efx"));
	//animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_water.efx"));
	//animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_water.efx"));

	level._effect["edge_mortar"]				= loadfx("fx/explosions/mortarExp_mud.efx");
	level._effectType["edge_mortar"]			= "mortar";

	level._effect["edge_mortar_2"]				= loadfx("fx/explosions/mortarExp_mud.efx");
	level._effectType["edge_mortar_2"]			= "mortar";
	
	level._effect["edge_mortar_3"]				= loadfx("fx/explosions/mortarExp_mud.efx");
	level._effectType["edge_mortar_3"]			= "mortar";

	level._effect["grenade"]					= loadfx("fx/explosions/grenadeExp_wood.efx");

	level._effect["wall_burst"]					= loadfx("fx/dust/wall_tank_dust.efx");
	level._effect["beltot_wallblast"]			= loadfx ("fx/dust/beltot_wallblast.efx");

	level._effect["thin_smoke_1"]				= loadfx ("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect["thin_smoke_2"]				= loadfx ("fx/smoke/thin_light_smoke_S.efx");
	level._effect["battlefield_smokebank_S"]	= loadfx ("fx/smoke/battlefield_smokebank_S.efx");
	level._effect["fogbank_small_duhoc"]		= loadfx ("fx/misc/fogbank_small_beltot.efx");
	level._effect["tank_fire_engine"] 			= loadfx ("fx/fire/tank_fire_engine.efx");

	level._effect["ground_fire_med"]			= loadfx ("fx/fire/ground_fire_med.efx");
	
	
}

soundFX()
{
	waittillframeend;
	level.scr_sound["bricks_crumbling"]			= "bricks_crumbling";
	level.scr_sound["truck_brakesqueal"]			= "truck_brakesqueal";
}

treadFX()
{
	//This overrides the default effects for treads for this level only
	
	//tiger fx
	maps\_treadfx::setVehicleFX("tiger",	"water",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"dirt",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("tiger",	"asphalt",	"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("tiger",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"sand",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("tiger",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"gravel",	"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("tiger",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"mud",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("tiger",	"rock",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("tiger",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("tiger",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("tiger",	"foliage",	undefined);
	
	//Opel Blitz FX
	maps\_treadfx::setVehicleFX("blitz",	"water",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"sand",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("blitz",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("blitz",	"rock",		"fx/dust/tread_dust_beltot.efx");
	maps\_treadfx::setVehicleFX("blitz",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	undefined);
	
}

spawnWorldFX()
{
	maps\_fx::loopfx("thin_smoke_2", (1450,-385,64), 0.5, (1470,-385,164));
	maps\_fx::loopfx("thin_smoke_2", (1941,88,56), 0.5, (1941,88,156));
	maps\_fx::loopfx("thin_smoke_2", (433,188,-8), 0.6, (433,188,90));
	maps\_fx::loopfx("thin_smoke_1", (825,-67,319), 1, (825,-67,419));
	maps\_fx::loopfx("thin_smoke_1", (1500,-536,140), 1, (1500,-536,240));
	maps\_fx::loopfx("thin_smoke_1", (1869,569,46), 1.5, (1887,470,51));
	maps\_fx::loopfx("thin_smoke_2", (-848,-1023,57), 0.6, (-848,-1023,156));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1434,-1345,-11), 1, (-1434,-1345,87));
	maps\_fx::loopfx("battlefield_smokebank_S", (-1335,-503,-11), 1, (-1335,-503,87));
	maps\_fx::loopfx("battlefield_smokebank_S", (-919,255,-11), 1, (-919,255,87));
	maps\_fx::loopfx("battlefield_smokebank_S", (216,285,67), 1, (216,285,166));
	maps\_fx::loopfx("battlefield_smokebank_S", (19,-1182,55), 1, (19,-1182,154));
	maps\_fx::loopfx("battlefield_smokebank_S", (181,-362,65), 1, (181,-362,164));
	maps\_fx::loopfx("battlefield_smokebank_S", (2569,1273,50), 1, (2569,1273,149));
	maps\_fx::loopfx("battlefield_smokebank_S", (1463,-9,22), 1, (1463,-9,121));
	maps\_fx::loopfx("battlefield_smokebank_S", (2703,220,30), 1, (2703,220,129));
	maps\_fx::loopfx("battlefield_smokebank_S", (2405,-486,83), 1, (2405,-486,182));
	maps\_fx::loopfx("battlefield_smokebank_S", (1141,-935,42), 1, (1141,-935,141));
	maps\_fx::loopfx("battlefield_smokebank_S", (1165,1565,21), 1, (1165,1565,120));
	maps\_fx::loopfx("battlefield_smokebank_S", (1972,1715,-59), 1, (1972,1715,39));
	maps\_fx::loopfx("battlefield_smokebank_S", (2775,2069,-65), 1, (2775,2069,33));
	maps\_fx::loopfx("thin_smoke_2", (1530,485,80), 0.5, (1530,485,180));
	maps\_fx::loopfx("thin_smoke_2", (1231,1918,-86), 0.5, (1231,1918,13));
	maps\_fx::loopfx("fogbank_small_duhoc", (-21,2460,50), 2, (-21,2460,150));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2739,-1596,-18), 2, (-2739,-1596,81));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2739,-1596,-18), 2, (-2739,-1596,81));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2745,-952,-18), 2, (-2745,-952,81));
	maps\_fx::loopfx("fogbank_small_duhoc", (-3119,-267,-18), 2, (-3119,-267,81));
	maps\_fx::loopfx("fogbank_small_duhoc", (-3415,-1134,-18), 2, (-3415,-1134,81));
	maps\_fx::loopfx("fogbank_small_duhoc", (-3545,-1995,-18), 2, (-3545,-1995,81));
	maps\_fx::loopfx("fogbank_small_duhoc", (-3860,-2722,7), 2, (-3860,-2722,107));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2229,-2141,17), 2, (-2229,-2141,117));
	maps\_fx::loopfx("fogbank_small_duhoc", (-2111,-1209,28), 2, (-2111,-1209,128));
	maps\_fx::loopfx("fogbank_small_duhoc", (-1948,2,10), 2, (-1948,2,110));
	maps\_fx::loopfx("tank_fire_engine", (420,-513,63), 1, (420,-513,162));
	maps\_fx::loopfx("tank_fire_engine", (406,-544,63), 1, (406,-544,162));
	maps\_fx::loopfx("tank_fire_engine", (259,-502,17), 1, (259,-502,116));
	maps\_fx::loopfx("tank_fire_engine", (246,-497,17), 1, (246,-497,116));

	//Tank Shoots Wall
	maps\_fx::exploderfx(2, "beltot_wallblast", (1938,432,104), 0, (1885,508,140));
}