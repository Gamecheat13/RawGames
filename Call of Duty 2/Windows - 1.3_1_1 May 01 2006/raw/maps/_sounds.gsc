main()
{
	if(!isdefined(level.scr_sound))
		level.scr_sound = [];
	
	if ((level.script == "stalingrad") || (level.script == "stalingrad_nolight"))
	{
//		maps\_utility::error ("LOADING SOUNDS");
		// Ambient triggers are not placed yet. You would replace the ["whatever"] with a descriptive name for that
		// ambient track, like ["docks"].

		level.ambient_track ["water"] = "Ambient_stalingrad_water";
		level.ambient_track ["docks"] = "Ambient_stalingrad_docks";
		level.ambient_track ["land"] = "Ambient_stalingrad_inland";
		level.ambient_track ["sniper"] = "Ambient_stalingrad_sniper";

		// Turn into aliases
		level.scr_sound ["plane"] = "stalingrad_flyover"; // Plane flyby
		level.scr_sound ["plane0"] = "stalingrad_flyover0"; // Plane flyby
		level.scr_sound ["plane1"] = "stalingrad_flyover1"; // Plane flyby
		level.scr_sound ["plane2"] = "stalingrad_flyover2"; // Plane flyby
		level.scr_sound ["plane3"] = "stalingrad_flyover3"; // Plane flyby
		level.scr_sound ["plane4"] = "stalingrad_flyover4"; // Plane flyby
		level.scr_sound ["plane5"] = "stalingrad_flyover5"; // Plane flyby
		level.scr_sound ["plane10"] = "stalingrad_flyover10"; // Plane flyby
		level.scr_sound ["plane11"] = "stalingrad_flyover11"; // Plane flyby
		level.scr_sound ["plane12"] = "stalingrad_flyover12"; // Plane flyby
		level.scr_sound ["plane13"] = "stalingrad_flyover13"; // Plane flyby
		level.scr_sound ["plane14"] = "stalingrad_flyover14"; // Plane flyby
		level.scr_sound ["plane25"] = "stalingrad_flyover4"; // Plane flyby

		// New sounds to be used:
		level.scr_sound ["sniper rifle fire"] = "stalingrad_sniper_bang"; // Russian Sniper Rifle Firing
		level.scr_sound ["metal hit"] = "bullet_large_metal"; // Metal hits on Hedgehogs
		level.scr_sound ["dirt hit"] = "bullet_large_dirt"; // Metal hits on Hedgehogs

		level.scr_sound ["boat sinking"] = "boat_sink"; // Stalingrad boats sinking after explosion
		level.scr_sound ["tugboat movement"] = "tugboat_move"; // Tugboat motor sound for tugboats in river
		level.scr_sound ["Train Movement"] = "train_move"; // Stalingrad train pulling away
		level.scr_sound ["exaggerated flesh impact"] = "bullet_mega_flesh"; // Commissar shot by sniper (exaggerated cinematic type impact)
		level.scr_sound ["bullet impact canvas"] = "bullet_large_canvas"; // Bullets impacting canvas tarp on stalingrad barge
		level.scr_sound ["boat movement"] = "stalingrad_boat_move"; // Barge movement sounds
		level.scr_sound ["boat explosion"] = "explo_boat"; // Boat exploding
		level.scr_sound ["Stuka hit"] = "Stuka_hit"; // Stuka gets hit
		level.scr_sound ["Stuka explosion"] = "Stuka_explo"; // Stuka explodes

		level.scr_sound ["stuka gun loop"] = "stuka_gun_loop"; // Stuka guns firin

		// For each ambient sound, specify the alias, origin, and sound length.
		maps\_fx::loopSound("bigfire", (-4292, 544, 332), 12.07);
		maps\_fx::loopSound("bigfire", (-4543, 1063, 567), 12.07);
	}
	
	if (level.script == "burnville")
	{
		//burnville fx sounds:
		level.scr_sound["fireheavysmoke"]		= "Bigfire";
		level.scr_sound["medFire"]			= "Medfire";
		level.scr_sound["medFireTop"]			= "Medfire";
		level.scr_sound["bigFireTop"]			= "Bigfire";
		level.scr_sound["smallFire"]			= "Smallfire";
		level.scr_sound["smallFireWindow"]		= "Smallfire";
		level.scr_sound["firesmoke"]			= "Medfire";
		level.scr_sound["firesmall"]			= "Smallfire";
		
		maps\_fx::loopSound("medfire", (-781, 17970, 91), 12.07);
		maps\_fx::loopSound("bigfire", (2100, -16243, -7), 12.07);
	}

	if (level.script == "dawnville")
	{
		//burnville fx sounds:
		level.scr_sound["tank breakthrough"] = "tank_stone_breakthrough";
		level.scr_sound["tank gatecrash"] = "tank_gate_breakthrough";
		level.scr_sound ["exaggerated flesh impact"] = "bullet_mega_flesh"; // Commissar shot by sniper (exaggerated cinematic type impact)
	}

	if (level.script == "tankdrivecountry")
	{

		// Turn into aliases
//		level.scr_sound ["plane"] = "stalingrad_flyover"; // Plane flyby
//		level.scr_sound ["plane0"] = "stalingrad_flyover0"; // Plane flyby
//		level.scr_sound ["plane1"] = "stalingrad_flyover1"; // Plane flyby
//		level.scr_sound ["plane2"] = "stalingrad_flyover2"; // Plane flyby
//		level.scr_sound ["plane3"] = "stalingrad_flyover3"; // Plane flyby
		level.scr_sound ["plane4"] = "stalingrad_flyover4"; // Plane flyby
//		level.scr_sound ["plane5"] = "stalingrad_flyover5"; // Plane flyby
//		level.scr_sound ["plane10"] = "stalingrad_flyover10"; // Plane flyby
//		level.scr_sound ["plane11"] = "stalingrad_flyover11"; // Plane flyby
//		level.scr_sound ["plane12"] = "stalingrad_flyover12"; // Plane flyby
//		level.scr_sound ["plane13"] = "stalingrad_flyover13"; // Plane flyby
//		level.scr_sound ["plane14"] = "stalingrad_flyover14"; // Plane flyby
//		level.scr_sound ["plane25"] = "stalingrad_flyover4"; // Plane flyby

	}
	if (level.script == "sewer")
	{

	maps\_fx::loopSound("sewer_water", (3092, 749, -473), 15.23);
	maps\_fx::loopSound("sewer_water", (4694, 139, -378), 15.23);
	maps\_fx::loopSound("sewer_water", (2672, 2566, -319), 15.23);
	maps\_fx::loopSound("wind_whistle", (2257, 951, -264), 32.18);
	maps\_fx::loopSound("wind_whistle", (5277, -2347, -93), 32.18);
	maps\_fx::loopSound("wind_whistle", (3384, 2720, 55), 32.18);
	maps\_fx::loopSound("wind_whistle", (4985, -1121, -245), 32.18);

	}
	if (level.script == "dam")
	{

	// Dam Ambient Sounds (waterfall, generators, spotlights, etc)
	maps\_fx::loopSound("waterfall_dam", (-21126, 3695, -1513), 22.10);
	maps\_fx::loopSound("waterfall_dam2", (-23235, 3611, -1513), 22.10);
	maps\_fx::loopSound("generator", (-21822, 3372, -1535), 13.39);
	maps\_fx::loopSound("searchlight", (-18474, 3157, 34), 8.35);
	maps\_fx::loopSound("searchlight", (-28925, 4191, 34), 8.35);
	maps\_fx::loopSound("searchlight", (-21478, -228, -150), 8.35);
	maps\_fx::loopSound("waterlap", (-18324, 5657, -73), 15.39);
	maps\_fx::loopSound("waterlap", (-24359, 1236, -1668), 15.39);
	maps\_fx::loopSound("waterlap", (-21818, -8, -1738), 15.39);
	maps\_fx::loopSound("waterlap", (-22639, 747, -1700), 15.39);
	maps\_fx::loopSound("waterlap", (-19344, 4543, -75), 15.39);
	maps\_fx::loopSound("waterlap", (-20688, 5144, -47), 15.39);
	maps\_fx::loopSound("waterlap", (-27895, 4900, -33), 15.39);
	maps\_fx::loopSound("waterlap", (-22440, 5654, -40), 15.39);
	maps\_fx::loopSound("waterlap", (-24252, 5721, -58), 15.39);
	maps\_fx::loopSound("waterlap", (-22117, 2464, -1699), 15.39);
	maps\_fx::loopSound("german_radio", (-27343, 4682, -8), 60.27);
	
	}

	if (level.script == "ship")
	{

	maps\_fx::loopSound("boiler", (3721, -208, -207), 15.23);
	maps\_fx::loopSound("boiler", (3702, 245, 207), 15.23);

	}
	
	if (level.script == "rocket")
	{

	maps\_fx::loopSound("german_radio", (10589, 4477, 248), 60.27);
	maps\_fx::loopSound("german_radio", (10663, 6741, 315), 60.27);

	}

	if (level.script == "hurtgen")
	{

	maps\_fx::loopSound("german_radio", (3418, 1015, -207), 60.27);
	
	}

	if (level.script == "chateau")
	{

	maps\_fx::loopSound("german_radio", (-1984, 4758, -123), 60.27);
	maps\_fx::loopSound("smallfire", (-1880, 4619, -137), 5.27);
	

	
	}
	
	if (level.script == "powcamp")
	{

	maps\_fx::loopSound("german_radio", (-1973, 4260, -7), 60.27);
	
	}
	
	
	if (level.script == "trainstation")
	{

	maps\_fx::loopSound("killfire", (3691, 13259, 83), .50);
	maps\_fx::loopSound("killfire", (3890, 13398, 268), .50);
	maps\_fx::loopSound("killfire", (4140, 13154, 20), .50);
	maps\_fx::loopSound("killfire", (4102, 13277, 284), .50);
	maps\_fx::loopSound("killfire", (4685, 13378, 10), .50);

	}

}