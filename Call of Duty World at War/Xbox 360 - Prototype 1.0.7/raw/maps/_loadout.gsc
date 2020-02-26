init_loadout()
{
	give_loadout();
	level.loadoutComplete = true;
	level notify ("loadout complete");	
}

give_loadout()
{
	level.player SetActionSlot( 1, "altMode" );			//DPAD_UP toggles between attached grenade launcher
	level.player SetActionSlot( 2, "nightvision" );		//DPAD_DOWN toggles night vision on/off
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
	
	if ( level.script == "armada" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m16_grenadier");
		level.player switchToWeapon("m16_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		//level.player giveWeapon("c4");
		//level.player SetActionSlot( 4, "weapon" , "c4" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "statue" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m16_grenadier");
		level.player switchToWeapon("m16_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "bog_a" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m4_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
//		level.player giveWeapon("c4");
//		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "bog_b" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon( "Beretta" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m4_grenadier" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "hunted" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m4_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m4_grenadier" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "school" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("usp");
		level.player giveWeapon("m4m203_silencer");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player switchtoWeapon("m4m203_silencer");
		level.player setOffhandSecondaryClass( "flash" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "scoutsniper" )
	{
		game["gaveweapons"] = 1;
		level.player giveWeapon("m4_silencer");
		level.player giveWeapon("dragunov");
		level.player switchToWeapon("m4_silencer");
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "sniperescape" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("m14_scoped");
		level.player giveWeapon("m4_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player switchtoWeapon("m14_scoped");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.campaign = "american";
		return;
	}

	//------------------------------------
	// level.script is not a single player level. give default weapons.
	println ("loadout.gsc:     No level listing in _loadout.gsc, giving default guns");

	if (level.campaign == "russian")
		thread setup_russian();
	else
	{
		thread setup_american();
		level.campaign = "american";
	}

	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("m4_grenadier");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon( "mp5" );
	level.player switchToWeapon( "m4_grenadier" );
	
}



setup_american()
{
	level.player setViewmodel( "viewmodel_base_viewhands" );
}

setup_russian()
{
	level.player setViewmodel( "viewmodel_base_viewhands" );
}
