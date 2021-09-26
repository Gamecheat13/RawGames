main()
{
	precacheFX();
	level thread playerEffect();
	treadFX();
	exploderFX();
	ambientFX();
}

precacheFX()
{

	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_dust_eldaba.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_dust_eldaba.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_dust_eldaba.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_dust_eldaba.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_dust_eldaba.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_dust_eldaba.efx"));
	animscripts\utility::setFootstepEffect ("plaster",		loadfx ("fx/impacts/footstep_dust_eldaba.efx"));

	
	// the planes
	level._effect["planeshoot"]					= loadfx ("fx/muzzleflashes/mg42hv_far.efx");
  	level._effect["planeenginesmoke"]			= loadfx ("fx/fire/fire_airplane_trail.efx");  
	level._effect["planeexplosion"]				= loadfx ("fx/explosions/eldaba_plane_explosion.efx");
	
	level._effect["flesh_hit"]					= loadfx("fx/impacts/flesh_hit.efx");
		
	// explosions
	level._effect["mosque explosion"]			= loadfx ("fx/explosions/silo_explode.efx");
	//level._effect["exp_pack_hallway"]			= loadfx ("fx/explosions/exp_pack_hallway.efx");
	level._effect["artilleryExp_desert_yellow"]	= loadfx ("fx/explosions/artilleryExp_desert_yellow.efx");
	level._effect["mortarExp_water"]			= loadfx ("fx/explosions/mortarExp_water.efx");
	level._effect["water_bubble"]				= loadfx ("fx/misc/froth_cargoship.efx");
	level._effect["boat_explosion"]				= loadfx ("fx/explosions/eldaba_boat_explosion.efx");
	level._effect["dock_explosion"]				= loadfx ("fx/explosions/dock_explosion.efx");
	level._effect["barrel_explosion"]			= loadfx ("fx/props/barrelExp.efx");

		
	level._effect["bomb"] 						= loadfx ("fx/explosions/artilleryExp_desert_building.efx");
	level._effectType["bomb"]					= "bomb";
	level._effect["bomb_impact"]				= level._effect["bomb"];
	level._effectType["bomb_impact"]			= level._effectType["bomb"];

	
	// misc
	level._effect["thin_black_smoke_M"]			= loadfx ("fx/smoke/thin_black_smoke_M.efx");
	level._effect["med_oil_fire"]				= loadfx ("fx/fire/med_oil_fire.efx");
	level._effect["ground_fire_med"]			= loadfx ("fx/fire/ground_fire_med.efx");
	level._effect["dust wind"]					= loadfx ("fx/dust/dust_wind_eldaba.efx");
	level._effect["orange_smoke"]				= loadfx ("fx/smoke/orange_smoke_20sec.efx");
	level._effect["flak_flash"]					= loadfx ("fx/muzzleflashes/flak_flash.efx");
	level._effect["large_woodhit"]				= loadfx ("fx/impacts/large_woodhit.efx");
	level._effect["dust_door_ambush"]			= loadfx ("fx/dust/dust_door_ambush.efx");
	level._effect["cargoship_fire"]				= loadfx ("fx/fire/cargoship_fire.efx");
	level._effect["thin_light_smoke_L"]			= loadfx ("fx/smoke/thin_light_smoke_L.efx");
//	level._effect["distortion_distant"]			= loadfx ("fx/distortion/distortion_eldaba_distance.efx");
	level._effect["distortion_player_effect"]	= loadfx ("fx/distortion/distortion_playereffect_4k_heatwave.efx");


	level._effect["glow_moroccan_chainlamp"]	= loadfx("fx/props/glow_moroccan_chainlamp.efx");

	
	level.earthquake["artillery"]["magnitude"]	= 0.25;
	level.earthquake["artillery"]["duration"]	= 0.5;
	level.earthquake["artillery"]["radius"]		= 2048;
		
	level.scr_sound["artillery"] = "artillery_explosion";
	level.scr_sound["battleship_gun"] = "battleship_gun";
}


playerEffect()
{
	level endon ("dismounted truck");
	player = getent("player","classname");
	for (;;)
	{
		playfx ( level._effect["distortion_player_effect"], player.origin + (0,0,50));
		wait (0.3);
	}
}

treadFX()
{
	
	//This overrides the default effects for treads for this level only
	
	
	//tiger fx
	maps\_treadfx::setVehicleFX("crusader",	"water",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"dirt",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("crusader",	"asphalt",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("crusader",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"sand",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("crusader",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"gravel",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("crusader",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"plaster",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("crusader",	"rock",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("crusader",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("crusader",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("crusader",	"foliage",	undefined);
	
	//GermanFordTruck FX
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"water",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"dirt",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"asphalt",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"sand",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"gravel",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"plaster",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"rock",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("GermanFordTruck",	"foliage",	undefined);
	
	//Opel Blitz FX
	maps\_treadfx::setVehicleFX("blitz",	"water",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"dirt",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("blitz",	"asphalt",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("blitz",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"sand",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("blitz",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"gravel",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("blitz",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"plaster",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("blitz",	"rock",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("blitz",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("blitz",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("blitz",	"foliage",	undefined);

	//Kubelwagon FX
	maps\_treadfx::setVehicleFX("Kubelwagon",	"water",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"dirt",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"asphalt",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"sand",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"gravel",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"plaster",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"rock",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("Kubelwagon",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("Kubelwagon",	"foliage",	undefined);
	
	//Jeep
	maps\_treadfx::setVehicleFX("jeep",	"water",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"ice",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"snow",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"dirt",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("jeep",	"asphalt",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("jeep",	"carpet",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"cloth",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"sand",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("jeep",	"grass",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"gravel",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("jeep",	"metal",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"mud",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"plaster",	"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("jeep",	"rock",		"fx/dust/tread_dust_eldaba.efx");
	maps\_treadfx::setVehicleFX("jeep",	"wood",		undefined);
	maps\_treadfx::setVehicleFX("jeep",	"brick",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"concrete",	undefined);
	maps\_treadfx::setVehicleFX("jeep",	"foliage",	undefined);
}

exploderFX()
{
	//mosque explosion
	maps\_fx::exploderfx(1, "mosque explosion", (-455,-127,1090), 0, (-458,-128,1190));
			
	//Airplane explosion
	maps\_fx::exploderfx(3, "bomb", (862,-13594,110), 0, (862,-13594,130));
	maps\_fx::exploderfx(3, "planeexplosion", (862,-13594,110), 0.5, (862,-13594,130));
	
	//Orange Smoke
	maps\_fx::exploderfx(4, "orange_smoke", (1529,2043,-1), 0, (1524,2046,98));
	
	//Dock Atillery Impacts
	maps\_fx::exploderfx(5, "mortarExp_water", (991,2868,-109), 0.5, (994,2863,-9), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (313,2550,-109), 3.5, (316,2545,-9), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "artilleryExp_desert_yellow", (-295,2205,-7), 7.5, (-295,2205,91), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (-223,2505,-115), 8.5, (-220,2500,-15), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (728,3687,-122), 9, (728,3687,-22), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (600,3156,-112), 2.8, (600,3156,-12), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (-172,3234,-120), 2.5, (-172,3234,-20), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (2293,2599,-119), 4.5, (2288,2602,-20), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (1187,3424,-112), 6.5, (1187,3424,-14), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (91,4107,-113), 1.5, (91,4107,-13), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (-253,2870,-124), 2, (-253,2870,-24), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "dock_explosion", (1995,2447,-117), 0, (1995,2447,-19), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "artilleryExp_desert_yellow", (205,1774,-3), 4, (208,1769,96), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (1594,2707,-124), 5, (1594,2707,-24), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "artilleryExp_desert_yellow", (1495,1673,29), 7, (1495,1673,127), undefined, undefined, undefined, "artillery", "artillery", undefined);	
	maps\_fx::exploderfx(5, "mortarExp_water", (1640,4663,-120), 8, (1640,4663,-21), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (2577,3125,-74), 1, (2577,3125,25), undefined, undefined, undefined, "artillery", "artillery", undefined);	
	maps\_fx::exploderfx(5, "mortarExp_water", (-845,4317,-121), 9.5, (-845,4317,-21), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(5, "mortarExp_water", (794,4761,-70), 6, (794,4761,29), undefined, undefined, undefined, "artillery", "artillery", undefined);

		
	//Dock Artillery Fire
	maps\_fx::exploderfx(6, "flak_flash", (5200,12800,25), 8.5, (5200,12700,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (3300,14100,25), 9.5, (3300,14000,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (700,13040,25), 6.5, (700,12948,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (400,13062,-25), 7.5, (400,12971,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (-3248,12134,25), 4.5, (-3248,12034,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (-3346,11768,25), 5.5, (-3338,11677,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (784,12945,25), 2.5, (792,12853,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (553,13018,25), 3.5, (561,12927,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (3200,14100,25), 0.5, (3200,14000,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (3500,14100,25), 1.5, (3500,14000,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (-3099,11804,25), 8, (-3088,11720,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (-3370,11865,25), 9, (-3360,11781,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (5400,12800,25), 6, (5400,12700,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (449,13138,25), 7, (459,13054,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (5600,12800,25), 4, (5600,12700,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (5300,12800,25), 5, (5300,12700,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (5800,12800,25), 2, (5800,12700,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (6200,12800,25), 3, (6200,12700,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (-3985,12081,25), 0, (-3985,11981,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	maps\_fx::exploderfx(6, "flak_flash", (1000,13082,25), 1, (1000,12998,50), undefined, undefined, undefined, "battleship_gun", undefined, undefined);
	
	//Intro Artillery
	maps\_fx::exploderfx(7, "artilleryExp_desert_yellow", (97,-1766,31), 0, (97,-1766,131), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(7, "bomb", (1343,-1372,323), 2, (1343,-1372,423), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(7, "artilleryExp_desert_yellow", (-1094,-1308,35), 4, (-1094,-1308,135), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(7, "bomb", (92,-1354,293), 6, (92,-1354,393), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(7, "artilleryExp_desert_yellow", (-2381,-732,14), 8, (-2381,-732,114), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(7, "bomb", (-1620,707,297), 10, (-1620,707,397), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(7, "bomb", (-448,-1364,244), 12, (-448,-1364,344), undefined, undefined, undefined, "artillery", "artillery", undefined);
	
	//MG shoot door fx
	maps\_fx::exploderfx(8,"dust_door_ambush",(2081,-266,58), 0, (2081,-262,157), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);

	//Airplane explosion 2
	maps\_fx::exploderfx(9, "bomb", (-3270, 971, 386), 0, (-3270, 971, 406));
	maps\_fx::exploderfx(9, "planeexplosion", (-3270, 971, 386), 0.5, (-3270, 971, 406));

	//Supply Boat 1
	maps\_fx::exploderfx(10, "boat_explosion", (2303,3855,-6), 0, (2303,3855,92), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(10, "boat_explosion", (2546,4099,-6), 0.8, (2546,4099,92), undefined, undefined, undefined, "artillery", "artillery", undefined);

	//Supply Boat 2
	maps\_fx::exploderfx(11, "boat_explosion", (-1113,3936,28), 0, (-1113,3936,128), undefined, undefined, undefined, "artillery", "artillery", undefined);
	//2ndary Boat Explosion
	//maps\_fx::exploderfx(2, "barrel_explosion", (-1516,4020,-31), 1.3, (-1516,4020,66), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(2, "barrel_explosion", (-1211,4050,-19), 0.8, (-1211,4050,79), undefined, undefined, undefined, "artillery", "artillery", undefined);
	maps\_fx::exploderfx(2, "barrel_explosion", (-1342,3950,-19), 0, (-1342,3950,78), undefined, undefined, undefined, "artillery", "artillery", undefined);



}

ambientFX()
{


	//wind
	maps\_fx::gunfireloopfxVec ("dust wind",(-1116,-707,48),(-1114,-704,148),	// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(-981,-180,42),(-981,-180,52),	// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(17,147,35),(17,147,45),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(-547,2183,59),(-547,2183,69),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(-394,1316,43),(-394,1316,53),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(101,2095,43),(101,2095,53),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(-921,2041,43),(-921,2041,53),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(747,2096,43),(747,2096,53),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(1770,2055,37),(1770,2055,47),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(2521,1878,0),(2521,1878,10),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(2345,921,23),(2345,921,33),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(1024,928,32),(1024,928,42),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(-1226,966,58),(-1226,966,68),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(1530,185,-3),(1530,185,-13),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.
	maps\_fx::gunfireloopfxVec ("dust wind",(2010,136,-4),(2010,136,-14),		// Origin
						1, 100,				// Number of shots
						0.6, 0.3,				// seconds between shots
						3, 10);					// seconds between sets of shots.

	
	//smoke plumes
	maps\_fx::loopfx("med_oil_fire", (593,-295,361), 2.0, (593,-295,461));
	maps\_fx::loopfx("thin_black_smoke_M", (3191,485,72), 1, (3191,485,172));
	//maps\_fx::loopfx("thin_black_smoke_M", (-975,-176,33), 1, (-990,-128,119)); --->this is the car
	maps\_fx::loopfx("thin_black_smoke_M", (1813,-115,-4), 1, (1826,-71,84));
	//maps\_fx::loopfx("thin_black_smoke_M", (7410,-9869,310), 0.6, (7400,-9800,400));
	maps\_fx::loopfx("thin_black_smoke_M", (7410,-9869,38), 1, (7400,-9800,128));
	maps\_fx::loopfx("thin_black_smoke_M", (9446,-9668,96), 1, (9450,-9600,200));
	maps\_fx::loopfx("thin_black_smoke_M", (12515,-8641,27), 1, (12500,-8600,130));
	maps\_fx::loopfx("thin_black_smoke_M", (3336,-10642,-155), 1, (3336,-10600,-50));
	maps\_fx::loopfx("thin_black_smoke_M", (793,846,257), 1, (795,879,351));

	//Smoking ships
//	maps\_fx::loopfx("thin_black_smoke_M", (139,13301,-85), 1, (39,13300,-83));//moved to script
//	maps\_fx::loopfx("thin_black_smoke_M", (406,13326,-60), 1, (309,13330,-82));//moved to script
//	maps\_fx::loopfx("thin_black_smoke_M", (-3587,12396,-12), 1, (-3683,12385,-36));//moved to script
//	maps\_fx::loopfx("thin_black_smoke_M", (-3851,12421,205), 1, (-3948,12410,182));//moved to script


	//Ship Froth
	//maps\_fx::loopfx("water_bubble", (2339,3824,-100), 0.3, (2339,3824,0));
	//maps\_fx::loopfx("water_bubble", (-1064,3685,-102), 0.3, (-1064,3685,-2));

	//maps\_fx::loopfx("glow_moroccan_chainlamp", (-1242,405,124), 0.3, (-1242,405,224));

	//haycart fire
	maps\_fx::loopfx("ground_fire_med", (1320,280,15), 2, (1380,260,90));
	thread maps\_utility::loopfxSound ("medfire", (1320,280,15));
}
