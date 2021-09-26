init_loadout()
{
	give_loadout();
	level.loadoutComplete = true;
	level notify ("loadout complete");	
}

give_loadout()
{

	if(!(isdefined(game["gaveweapons"])))
		game["gaveweapons"] = 0;

	if(!(isdefined(game["expectedlevel"])))
		game["expectedlevel"] = "";
	
	if ( game["expectedlevel"] != level.script )
		game["gaveweapons"] = 0;		

	if(!(isdefined (level.campaign)))
		level.campaign = "american";
	
	level.player giveWeapon("binoculars");
	
	if(level.script == "moscow")
	{
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
	//	level.player giveWeapon("svt40");
	//	level.player giveWeapon("tt30");
	//	level.player giveWeapon("fraggrenade");
	//	level.player giveWeapon("smoke_grenade_russian");
	//	level.player switchToWeapon("SVT40");
	//	level.player setweaponslotammo("primary", 0);
	//	level.player setweaponslotclipammo("primary", 0);
	//	level.player setweaponslotammo("primaryb", 0);
	//	level.player setweaponslotclipammo("primaryb", 0);

		//level.player switchToOffhand("fraggrenade");
		level.player takeallweapons();
		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "trainyard")
	{
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon("SVT40");
		level.player giveWeapon("tt30");
		level.player giveWeapon("RGD-33russianfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("SVT40");
		level.player switchToOffhand("RGD-33russianfrag");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "downtown_sniper")
	{
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon("tt30");
		level.player giveWeapon("svt40");
		level.player giveWeapon("RGD-33russianfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("svt40");
		level.player switchToOffhand("RGD-33russianfrag");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "downtown_assault")
	{
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("ppsh");
		level.player giveWeapon("tt30");
		level.player giveWeapon("RGD-33russianfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("ppsh");
		level.player switchToOffhand("RGD-33russianfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "cityhall")
	{
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon("ppsh");
		level.player giveWeapon("SVT40");
		level.player giveWeapon("RGD-33russianfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("SVT40");
		level.player switchToOffhand("RGD-33russianfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "decoytrenches")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player takeallweapons();
		level.player giveWeapon ("enfield");
		level.player giveWeapon ("thompson");
//		level.player giveWeapon ("webley");
		level.player giveWeapon ("MK1britishfrag");
		level.player giveWeapon ("smoke_grenade_american_night");
		
		level.player switchToWeapon ("thompson");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "decoytown")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon ("enfield");
		level.player giveWeapon ("bren");
//		level.player giveWeapon ("webley");
		level.player giveWeapon ("MK1britishfrag");
		level.player giveWeapon ("smoke_grenade_american_night");
		
		level.player switchToWeapon ("bren");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "elalamein")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}

		level.player giveWeapon("enfield_scope");
		level.player giveWeapon("thompson");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("thompson");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "eldaba")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);

		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("thompson");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("thompson");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
		
	if(level.script == "libya")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");
		
		game["gaveweapons"] = 1;
		return;
	}
	
	
	if(level.script == "88ridge")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");
		
		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "tankhunt")
	{
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("svt40");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("RGD-33russianfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("svt40");
		level.player switchToOffhand("RGD-33russianfrag");
		
		game["gaveweapons"] = 1;
		return;
	}
	
	
	if(level.script == "demolition")
	{
		thread setup_russian();
		level.campaign = "russian";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon("svt40");
		level.player giveWeapon("ppsh");
		level.player giveWeapon("RGD-33russianfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("svt40");
		level.player switchToOffhand("RGD-33russianfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if (level.script == "toujane")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}

		
		level.player giveWeapon("enfield");
		level.player giveWeapon("thompson");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");
		
		game["gaveweapons"] = 1;
		return;
	}
	
	
	if (level.script == "toujane_ride")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("thompson");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");
		
		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "matmata")
	{
		thread setup_british_africa();
		level.campaign = "british";

		level.player setnormalhealth (1);

		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("thompson");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "duhoc_assault")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("m1garand");
		level.player giveWeapon("thompson");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("m1garand");
		level.player switchToOffhand("fraggrenade");
		
		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "duhoc_defend")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon("m1garand");
		level.player giveWeapon("thompson");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("m1garand");
		level.player switchToOffhand("fraggrenade");
		
		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "silotown_assault")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("springfield");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("springfield");
		level.player switchToOffhand("fraggrenade");
		
		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "silotown_defense")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon("springfield");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("springfield");
		level.player switchToOffhand("fraggrenade");
		
		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "beltot")
	{
		thread setup_british_normandy();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "crossroads")
	{
		thread setup_british_normandy_wet();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american_night");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}
	
	if(level.script == "newvillers")
	{
		thread setup_british_normandy_wet();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american_night");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}


	if(level.script == "breakout")
	{
		thread setup_british_normandy();
		level.campaign = "british";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}
		
		level.player giveWeapon("enfield");
		level.player giveWeapon("sten");
		level.player giveWeapon("MK1britishfrag");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("enfield");
		level.player switchToOffhand("MK1britishfrag");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "bergstein")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("m1garand");
		level.player giveWeapon("thompson");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american_night");
		
		level.player switchToWeapon("m1garand");
		level.player switchToOffhand("fraggrenade");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "hill400_assault")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		if(game["gaveweapons"] == 1)
		{
			thread refill_ammo();
			// weapons carry over but are REFILLED
			return;
		}

		level.player giveWeapon("m1garand");
		level.player giveWeapon("colt");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("m1garand");
		level.player switchToOffhand("fraggrenade");

		game["gaveweapons"] = 1;
		return;
	}
	
	
	if(level.script == "hill400_defend")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("springfield");
		level.player giveWeapon("thompson");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("springfield");
		level.player switchToOffhand("fraggrenade");

		game["gaveweapons"] = 1;
		return;
	}

	if(level.script == "rhine")
	{
		thread setup_american();
		level.campaign = "american";

		level.player setnormalhealth (1);
		
		// weapons DONT carry over
		
		level.player giveWeapon("m1garand");
		level.player giveWeapon("thompson");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		
		level.player switchToWeapon("m1garand");
		level.player switchToOffhand("fraggrenade");
		
		game["gaveweapons"] = 1;
		return;
	}




	//------------------------------------
	// level.script is not a single player level. give default weapons.
	println ("Z:     No level listing in _loadout.gsc, giving default guns");

	if (level.campaign == "british")
		thread setup_british_normandy();
	else if (level.campaign == "russian")
		thread setup_russian();
	else
	{
		thread setup_american();
		level.campaign = "american";
	}

	level.player giveWeapon("enfield");
	level.player giveWeapon("sten");
	level.player giveWeapon("MK1britishfrag");
	level.player giveWeapon("smoke_grenade_american");
	level.player switchToWeapon("sten");
	level.player switchToOffhand("MK1britishfrag");
	//------------------------------------
}

refill_ammo()
{
	// bullet weapons
	weapons = [];
	weapons[weapons.size] = "bar";
	weapons[weapons.size] = "bren";
	weapons[weapons.size] = "colt";
	weapons[weapons.size] = "enfield";
	weapons[weapons.size] = "enfield_scope";
	weapons[weapons.size] = "g43";
	weapons[weapons.size] = "g43_scope";
	weapons[weapons.size] = "kar98k";
	weapons[weapons.size] = "kar98k_sniper";
	weapons[weapons.size] = "luger";
	weapons[weapons.size] = "m1carbine";
	weapons[weapons.size] = "m1garand";
	weapons[weapons.size] = "mosin_nagant";
	weapons[weapons.size] = "mosin_nagant_sniper";
	weapons[weapons.size] = "mp40";
	weapons[weapons.size] = "mp44";
	weapons[weapons.size] = "mp44_semi";
	weapons[weapons.size] = "pps42";
	weapons[weapons.size] = "ppsh";
	weapons[weapons.size] = "springfield";
	weapons[weapons.size] = "sten";
	weapons[weapons.size] = "svt40";
	weapons[weapons.size] = "thompson";
	weapons[weapons.size] = "thompson_latewar";
	weapons[weapons.size] = "tt30";
	weapons[weapons.size] = "webley";

	// projectile weapons
	weapons[weapons.size] = "panzerschreck";
	weapons[weapons.size] = "panzerfaust";
	
	// grenade weapons
	weapons[weapons.size] = "smoke_grenade_american";
	weapons[weapons.size] = "smoke_grenade_british";
	weapons[weapons.size] = "smoke_grenade_russian";
	weapons[weapons.size] = "smoke_grenade_german";
	weapons[weapons.size] = "fraggrenade";
	weapons[weapons.size] = "MK1britishfrag";
	weapons[weapons.size] = "RGD-33russianfrag";
	weapons[weapons.size] = "Stielhandgranate";

	
	for (i=0;i<weapons.size;i++)
	{
		if (level.player hasWeapon(weapons[i]))
		{
			if ( (weapons[i] == "panzerschreck" || weapons[i] == "panzerfaust") && level.script != "weaponroom")
			{
				println ("z:           taking away weapon: ", weapons[i]);
				level.player takeWeapon(weapons[i]);
			}
			else
			{
				println ("z:           giving the player max ammo for: ", weapons[i]);
				level.player giveMaxAmmo(weapons[i]);
			}
		}
		
		wait 0.05;
	}
}

setup_british_africa()
{
	level.player setViewmodel( "xmodel/viewmodel_hands_british_bare" );
}

setup_british_normandy()
{
	level.player setViewmodel( "xmodel/viewmodel_hands_british" );
}

setup_british_normandy_wet()
{
	level.player setViewmodel( "xmodel/viewmodel_hands_british_wet" );
}

setup_american()
{
	level.player setViewmodel( "xmodel/viewmodel_hands_cloth" );
}

setup_russian()
{
	level.player setViewmodel( "xmodel/viewmodel_hands_russian" );
}
