// level.player giveWeapon("bar");
// level.player giveWeapon("colt");
// level.player giveWeapon("fg42");
// level.player giveWeapon("kar98k");
// level.player giveWeapon("luger");
// level.player giveWeapon("m1carbine");
// level.player giveWeapon("m1garand");
// level.player giveWeapon("mp40");
// level.player giveWeapon("springfield");
// level.player giveWeapon("thompson");
// level.player giveWeapon("fraggrenade");
// level.player giveWeapon("ppsh");
// level.player giveWeapon("mosin_nagant");
// level.player giveWeapon("mosin_nagant_sniper");
// level.player giveWeapon("bren");
// level.player giveWeapon("sten");
// level.player giveWeapon("enfield");

give_loadout()
{

	if(!(isdefined(game["gaveweapons"])))
	{	
		game["gaveweapons"] = 0;
	}

	if(!(isdefined (level.campaign)))
	{	
		level.campaign = "american";
	}

	if(level.script == "training")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@Camp_Toccoa.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@Camp_Toccoa.tga");
		thread setup_american();
		level.campaign = "american";
				
		level.player setnormalhealth (1);
		
		// weapons DONT carry over

		game["gaveweapons"] = 1;
		
		return;
	}

	if (level.script == "pathfinder")
	{	
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@Pathfinder.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@Pathfinder.tga");
		thread setup_american();
		level.campaign = "american";
		
		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		// Player is given weapons manually in Pathfinder
/*
		level.player giveWeapon("m1garand");
		level.player giveWeapon("springfield");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("m1garand");
*/
		game["gaveweapons"] = 1;
		return;
	}

	if((level.script == "burnville") || (level.script == "burnville_nolight"))
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@Ste_Mere_Eglise.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@Ste_Mere_Eglise.tga");
		thread setup_american();
		level.campaign = "american";

		if(game["gaveweapons"] == 1)
			return;
		// weapons carry over if given

		level.player giveWeapon("m1carbine");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("m1carbine");

		game["gaveweapons"] = 1;
		return;
	}

	if((level.script == "dawnville") || (level.script == "dawnville_nolight"))
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@Ste_Mere_Eglise_day.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@Ste_Mere_Eglise_day.tga");
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
			return;
		// weapons carry over if given

		level.player giveWeapon("m1carbine");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("m1carbine");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "carride")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@normandy_route_n13.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@normandy_route_n13.tga");
		thread setup_american();
		level.campaign = "american";
		
		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
			

		level.player giveWeapon("m1carbine");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("thompson");

		game["gaveweapons"] = 1;
		return;
	}

	if (level.script == "brecourt")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@brecourt_manor.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@brecourt_manor.tga");
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
			return;
		// weapons carry over if given

		level.player giveWeapon("m1garand");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("m1garand");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "chateau")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@chateau.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@chateau.tga");
		thread setup_american();
		level.campaign = "american";
		
		// weapons DONT carry over

		level.player setnormalhealth (1);
		
		level.player giveWeapon("bar");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("bar");

		game["gaveweapons"] = 1;
		return;
	}


	if(level.script == "powcamp")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@Dulag IIIA.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@Dulag IIIA.tga");
		thread setup_american();
		level.campaign = "american";
		
		// weapons DONT carry over

		level.player setnormalhealth (1);
		
		level.player giveWeapon("springfield");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("springfield");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "pegasusnight")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@pegasus_bridge.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@pegasus_bridge.tga");
		thread setup_british();
		level.campaign = "british";
		
		// weapons DONT carry over

		level.player setnormalhealth (1);
		
		level.player giveWeapon("bren");
		level.player giveWeapon("enfield");
		level.player giveWeapon("colt");
		level.player giveWeapon("MK1britishfrag");
		level.player switchToWeapon("bren");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "pegasusday")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@pegasus_bridge_day.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@pegasus_bridge_day.tga");
		thread setup_british();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
			return;
		// weapons carry over if given

		level.player giveWeapon("enfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("colt");
		level.player giveWeapon("MK1britishfrag");
		level.player switchToWeapon("enfield");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "dam")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@the_eder_dam.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@the_eder_dam.tga");
		thread setup_british();
		level.campaign = "british";
		
		// weapons DONT carry over

		level.player setnormalhealth (1);
		
		level.player giveWeapon("springfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("colt");
		level.player giveWeapon("MK1britishfrag");
		level.player switchToWeapon("springfield");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "truckride")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@the_eder_dam_getaway.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@the_eder_dam_getaway.tga");
		thread setup_british();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}

		level.player giveWeapon("springfield");
		level.player giveWeapon("bren");
		level.player giveWeapon("colt");
		level.player giveWeapon("MK1britishfrag");
		level.player switchToWeapon("bren");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "airfield")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@airfield_escape.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@airfield_escape.tga");
		thread setup_british();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}

		level.player giveWeapon("springfield");
		level.player giveWeapon("bren");
		level.player giveWeapon("colt");
		level.player giveWeapon("MK1britishfrag");
		level.player switchToWeapon("springfield");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "ship")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@battleship_tirpitz.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@battleship_tirpitz.tga");
		thread setup_british();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		return;
	}
 
	if((level.script == "stalingrad") || (level.script == "stalingrad_nolight"))
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@stalingrad.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@stalingrad.tga");
		thread setup_russian();
		level.campaign = "russian";
		
		level.player setnormalhealth (1);

		// weapons DONT carry over
		
		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "redsquare")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@red_square.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@red_square.tga");
		thread setup_russian();
		level.campaign = "russian";

		// weapons DONT carry over
		
		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "trainstation")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@trainstation.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@trainstation.tga");
		thread setup_russian();
		level.campaign = "russian";

		if(game["gaveweapons"] == 1)
			return;
		// weapons carry over if given
		
		level.player giveWeapon("mosin_nagant_sniper");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("luger");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("ppsh");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "sewer")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@stalingrad_sewers.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@stalingrad_sewers.tga");
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("mosin_nagant_sniper");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("luger");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("ppsh");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "pavlov")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@pavlov's_house.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@pavlov's_house.tga");
		thread setup_russian();
		level.campaign = "russian";

		if(game["gaveweapons"] == 1)
			return;
		// weapons carry over if given

		level.player giveWeapon("mosin_nagant_sniper");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("luger");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("mosin_nagant_sniper");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "factory")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@warsaw_factory.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@warsaw_factory.tga");
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("mosin_nagant_sniper");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("luger");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("ppsh");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "railyard")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@warsaw_railyards.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@warsaw_railyards.tga");
		thread setup_russian();
		level.campaign = "russian";

		if(game["gaveweapons"] == 1)
			return;
		// weapons carry over if given

		level.player giveWeapon("mosin_nagant");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("luger");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("mosin_nagant");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "tankdrivecountry")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@oder_river_country.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@oder_river_country.tga");
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("panzerfaust");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("panzerfaust");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "tankdrivetown")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@oder_river_town.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@oder_river_town.tga");
		thread setup_russian();
		level.campaign = "russian";

		// weapons DONT carry over
		
		level.player giveWeapon("mosin_nagant");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("luger");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("ppsh");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "hurtgen")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@festung_recogne.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@festung_recogne.tga");
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("m1garand");
		level.player giveWeapon("thompson");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player switchToWeapon("m1garand");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "rocket")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@v-2_rocket_site.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@v-2_rocket_site.tga");
		thread setup_british();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("springfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("colt");
		level.player giveWeapon("MK1britishfrag");
		level.player switchToWeapon("springfield");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "berlin")
	{
		setCvar("cg_deadscreen_levelname", "levelshots/level_name_text/hud@the_reichstag.tga");
		setCvar("cg_victoryscreen_levelname", "levelshots/level_name_text/hud@the_reichstag.tga");
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("mosin_nagant_sniper");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("luger");
		level.player giveWeapon("RGD-33russianfrag");
		level.player switchToWeapon("ppsh");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "testfallback")
	{
		level.campaign = "american";

		level.player giveWeapon("bar");
		level.player switchToWeapon("bar");

		game["gaveweapons"] = 1;
		return;
	}

	//------------------------------------
	// level.script is not a single player level. give default weapons.
	println ("Z:     No level listing in _loadout.gsc, giving default guns");

	thread setup_american();
	level.campaign = "american";

	level.player giveWeapon("fg42");
	level.player giveWeapon("thompson");
	level.player giveWeapon("colt");
	level.player giveWeapon("fraggrenade");
	level.player switchToWeapon("fg42");
	//------------------------------------
}

refill_ammo()
{
	weapons[0] = "mp40";
	weapons[1] = "kar98k";
	weapons[2] = "bar";
	weapons[3] = "bren";
	weapons[4] = "colt";
	weapons[5] = "enfield";
	weapons[6] = "fg42";
	weapons[7] = "luger";
	weapons[8] = "m1carbine";
	weapons[9] = "m1garand";
	weapons[10] = "mosin_nagant";
	weapons[11] = "mp44";
	weapons[12] = "ppsh";
	weapons[13] = "springfield";
	weapons[14] = "sten";
	weapons[15] = "thompson";
	weapons[16] = "fraggrenade";
	weapons[17] = "MK1britishfrag";
	weapons[18] = "RGD-33russianfrag";
	weapons[19] = "Stielhandgranate";
	weapons[20] = "panzerfaust";
	
	for (i=0;i<weapons.size;i++)
	{
		if (level.player hasWeapon(weapons[i]))
		{
			level.player giveMaxAmmo(weapons[i]);
			println ("z:           giving the player max ammo for: ", weapons[i]);
		}
	}
}

setup_british()
{
	setCvar("cg_deadscreen_backdrop", "levelshots/deadscreen/defeat_british.tga");
	setCvar("cg_victoryscreen_backdrop", "levelshots/victoryscreen/victory_british.jpg");
	setCvar("ui_campaign", "british");
}

setup_american()
{
	setCvar("cg_deadscreen_backdrop", "levelshots/deadscreen/defeat_american.tga");
	setCvar("cg_victoryscreen_backdrop", "levelshots/victoryscreen/victory_american.jpg");
	setCvar("ui_campaign", "american");
}

setup_russian()
{
	setCvar("cg_deadscreen_backdrop", "levelshots/deadscreen/defeat_russian.tga");
	setCvar("cg_victoryscreen_backdrop", "levelshots/victoryscreen/victory_russian.jpg");
	setCvar("ui_campaign", "russian");
}
