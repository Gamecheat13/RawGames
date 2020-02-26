init_loadout()
{
	give_loadout();
	level.loadoutComplete = true;
	level notify ("loadout complete");
	level.player freezeControls(true);
}


RestorePlayerWeaponStatePersistent( slot )
{
	if ( !isDefined( game[ "weaponstates" ] ) )
	{
		
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player switchtoWeapon("p99_s");
		return false;
	}
	if ( !isDefined( game[ "weaponstates" ][ slot ] ) )
	{
		return false;
	}

	level.player takeallweapons();

	for ( weapIdx = 0; weapIdx < game[ "weaponstates" ][ slot ][ "list" ].size; weapIdx++ )
	{
		weapName = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ];

		if ( isdefined( level.legit_weapons ) )
		{
			
			if ( !isdefined( level.legit_weapons[ weapName ] ) )
				continue;
		}

		level.player GiveWeapon( weapName );
		level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
		level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
	}

	if ( isdefined( level.legit_weapons ) )
	{
		weapname = game[ "weaponstates" ][ slot ][ "offhand" ];
		if ( isdefined( level.legit_weapons[ weapName ] ) )
			level.player switchtooffhand( weapname );

		weapname = game[ "weaponstates" ][ slot ][ "current" ];
		if ( isdefined( level.legit_weapons[ weapName ] ) )
			level.player SwitchToWeapon( weapname );
	}
	else
	{
		level.player switchtooffhand( game[ "weaponstates" ][ slot ][ "offhand" ] );
		level.player SwitchToWeapon( game[ "weaponstates" ][ slot ][ "current" ] );
	}

	return true;
}


give_loadout()
{
	level.player SetActionSlot( 1, "altMode" );			
	level.player SetActionSlot( 2, "nightvision" );		
	level.player SetActionSlot( 3, "" );
	level.player SetActionSlot( 4, "" );

	if ( !isdefined( game[ "gaveweapons" ] ) )
		game[ "gaveweapons" ] = 0;

	if ( !isdefined( game[ "expectedlevel" ] ) )
		game[ "expectedlevel" ] = "";
	
	if ( game[ "expectedlevel" ] != level.script )
		game[ "gaveweapons" ] = 0;		

	if ( !isdefined( level.campaign ) )
		level.campaign = "american";
	
	if ( level.script == "background" )
	{
		level.player takeallweapons();
		game["gaveweapons"] = 1;
		return;
	}
	else if (level.script == "car_chase" )
	{
		thread setup_venice_bond();
		game[ "gaveweapons" ] = 1;
	}
	else if (level.script == "boat_chase")
	{
		thread setup_haiti_bond();
		game[ "gaveweapons" ] = 1;
	}
	else if (level.script == "gettler" || level.script == "gettler_geo" )
	{
		thread setup_venice_bond();
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
		game[ "gaveweapons" ] = 1;
	}
	else if (level.script == "montenegrotrain" || level.script == "montenegrotrain_geo" )
	{
		thread setup_bond_train();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "operahouse" || level.script == "operahouse_geo" )
	{
		thread setup_bond_opera();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon("p99");
		level.player switchtoWeapon("p99");
	}
	else if (level.script == "casino" || level.script == "casino_geo" )
	{
		thread setup_bond_casino();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "casino_poison" || level.script == "casino_poison_geo" )
	{
		thread setup_bond_casino_poison();
	}
	else if (level.script == "shantytown" || level.script == "shantytown_geo" )
	{
		thread setup_bond_shanty();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99");
	}
	else if (level.script == "constructionsite" || level.script == "constructionsite_geo" )
	{
		thread setup_construction_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player switchtoWeapon("p99");
	}
	else if (level.script == "prologuemi6" )
	{
		thread setup_miami_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "miamisciencecenter" )
	{
		thread setup_miami_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if( level.script == "sciencecenter_a" || level.script == "sciencecenter_a_geo" )
	{
		thread setup_bond_SC_A();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("wa2000_sca_s");
		level.player giveWeapon("WA2000_intro");
		level.player switchtoWeapon("WA2000_intro");
	}
	else if (level.script == "whites_estate" || level.script == "whites_intro" || level.script == "whites_outro")
	{
		thread setup_bond_siena();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		
		
		
		level.player switchtoWeapon("p99");
	}
	else if (level.script == "whites_estate_geo" )
	{
		thread setup_bond_siena();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "sciencecenter_b" || level.script == "sciencecenter_b_geo" )
	{
		thread setup_bond_SC_B();
	
		if ( !isDefined( game[ "weaponstates" ] ) )
		{
			
			game[ "gaveweapons" ] = 1;
			level.player giveWeapon("p99_s");
			level.player switchtoWeapon("p99_s");
			level.player giveWeapon("saf9_sca");
		}
		else
		{
			slot = "sciencecenter_a";
			level.player takeallweapons();
			
			for ( weapIdx = 0; weapIdx < game[ "weaponstates" ][ slot ][ "list" ].size; weapIdx++ )
			{
				weapName = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ];

				
				if(weapName == "p99_wet" || weapName == "p99_wet_s")
				{
					level.player GiveWeapon("p99_s");
					level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
					level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
					level.player switchtoWeapon("p99_s");
				}

				if(weapName == "1911" || weapName == "1911_s" || weapName == "1911_wet" || weapName == "1911_wet_s")
				{
					level.player GiveWeapon("1911_s");
					level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
					level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
				}

				if(weapName == "saf9_sca" || weapName == "SAF9_SCa_s")
				{
					level.player GiveWeapon("saf9_Casino");
					level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
					level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
				}

				if(weapName == "m14_sca" || weapName == "M14_SCa_s")
				{
					level.player GiveWeapon("m14_Eco");
					level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
					level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
				}

				if(weapName == "flash_grenade")
				{
					level.player GiveWeapon( weapName );
					level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
					level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
					level.player switchtooffhand( weapname );
				}

				if(weapName == "concussion_grenade")
				{
					level.player GiveWeapon( weapName );
					level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
					level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
					level.player switchtooffhand( weapname );
				}

			}
		}
	}
	
	else if( level.script == "airport" || level.script == "airport_geo" )
	{
		thread setup_bond_airport();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "barge" || level.script == "barge_geo" )
	{
		thread setup_bond_barge();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "barge_b" )
	{
		thread setup_bond_tuxedo();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if( level.script == "eco_hotel" || level.script == "eco_hotel_geo" )
	{
		thread setup_bond_eco();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99");
	}
	else if( level.script == "siena" || level.script == "siena_geo" )
	{
		thread setup_bond_siena();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		
		level.player switchtoWeapon("p99");
	}
		else if( level.script == "siena_rooftops" || level.script == "siena_rooftops_geo" )
	{
		thread setup_bond_siena();

		RestorePlayerWeaponStatePersistent( "siena" );

		
		
		
		
	}
	
	else if( level.script == "sink_hole" || level.script == "sink_hole_geo" )
	{
		thread setup_bond_sinkhole();




	}
	else if( level.script == "haines_estate" || level.script == "haines_estate_geo" )
	{
		thread setup_bond_haines();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "igc_test_int" )
	{
		thread setup_miami_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "wii_test_gameplay" )
	{
		thread setup_miami_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99");
	}
	else if (level.script == "stoneage" )
	{
		thread setup_construction_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player switchtoWeapon("p99");
	}
	else if (level.script == "wii_prefab_test" )
	{
		thread setup_construction_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player switchtoWeapon("p99");
	}
	else if (level.script == "test_ai" )
	{
		thread setup_miami_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "test_ai2" )
	{
		thread setup_bond_tuxedo();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if(level.script == "test_ai3")
	{
		
		
		
		
		thread setup_bond_eco();
		
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "techdemo_persistentbond" )
	{
		thread setup_bond_tuxedo();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
		
	}
	else if (level.script == "techdemo_videomirror" )
	{
		thread setup_miami_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if (level.script == "adam_test" || level.script == "adam_test" )
	{
		thread setup_venice_bond();
		game[ "gaveweapons" ] = 1;
	}
	else if (level.script == "bathroom" )
	{
		thread setup_bathroom_bond();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99");
	}
	else if(level.script == "weapon_test_lighting_demo")
	{
		thread setup_bond_tuxedo();
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon("p99_s");
	}
	else if(level.script == "firing_range")
	{
		thread setup_bond_eco();
		
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99_s");
		level.player switchtoWeapon("p99_s");
	}
	else if(level.script == "test_bossfight_qk")
	{
		thread setup_bond_tuxedo();

		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player switchtoWeapon("p99");
	}
	else
	{
		
		

		println ("loadout.gsc: No level listing in _loadout.gsc, giving default bond model and guns");
	
		
		thread setup_miami_bond();

		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("p99");
		level.player switchtoWeapon("p99");
	}	
}



setup_bathroom_bond()
{
	level.player character\character_bond_bathroom::main();
	level.campaign = "american";
}

setup_miami_bond()
{
	level.player character\character_bond_miami::main();
	level.campaign = "american";
}

setup_construction_bond()
{
	level.player character\character_bond_construction::main();
	level.campaign = "american";	
}

setup_haiti_bond()
{
	level.player character\character_bond_venice::main();
	level.campaign = "american";
}

setup_venice_bond()
{
	level.player character\character_bond_venice::main();
	level.campaign = "american";
}

setup_bond_tuxedo()
{
	level.player character\character_bond_tuxedo::main();
	level.campaign = "american";
}

setup_bond_train()
{
	level.player character\character_bond_train::main();
	level.campaign = "american";
}

setup_bond_eco()
{
	level.player character\character_bond_eco::main();
	level.campaign = "american";
}

setup_bond_sinkhole()
{
	
	level.player character\character_bond_siena::main();
	level.campaign = "american";
}

setup_bond_siena()
{
	level.player character\character_bond_siena::main();
	level.campaign = "american";
}








setup_bond_white()
{
	level.player character\character_bond_white::main();
	level.campaign = "american";
}
setup_bond_opera()
{
	level.player character\character_bond_opera::main();
	level.campaign = "american";
}
setup_bond_shanty()
{
	level.player character\character_bond_shanty::main();
	level.campaign = "american";
}
setup_bond_SC_A()
{
	level.player character\character_bond_SC_A::main();
	level.campaign = "american";
}
setup_bond_SC_B()
{
	level.player character\character_bond_SC_B::main();
	level.campaign = "american";
}
setup_bond_airport()
{
	level.player character\character_bond_airport::main();
	level.campaign = "american";
}
setup_bond_casino()
{
	level.player character\character_bond_casino::main();
	level.campaign = "american";
}
setup_bond_casino_poison()
{
	level.player character\character_bond_poison::main();
	level.campaign = "american";
}
setup_bond_barge()
{
	level.player character\character_bond_barge::main();
	level.campaign = "american";
}
setup_bond_haines()
{
	level.player character\character_bond_haines::main();
	level.campaign = "american";
}

setup_russian()
{
	level.player setmodel( "body_mp_usmc_engineer", "head_mp_usmc_tactical_mich" );
	level.player setfullmodel( "bond_bathroom_body" );
	level.player setViewmodel( "viewmodel_base_viewhands" );	
}
