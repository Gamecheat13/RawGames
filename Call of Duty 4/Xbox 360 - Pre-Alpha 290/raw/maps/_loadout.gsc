init_loadout()
{
	if(!isdefined(level.dodgeloadout))
		give_loadout();
	level.loadoutComplete = true;
	level notify ("loadout complete");	
}

give_loadout()
{
	level.player SetActionSlot( 1, "nightvision" );		//DPAD_DOWN toggles night vision on/off
	level.player SetActionSlot( 2, "altMode" );			//DPAD_UP toggles between attached grenade launcher
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
	if ( level.script == "killhouse" )
	{
		game[ "gaveweapons" ] = 1;
		level.player SetActionSlot( 1, "" );
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player SetWeaponAmmoStock( "fraggrenade", 0 );
		level.player SetWeaponAmmoClip( "fraggrenade", 0 );
		level.player SetWeaponAmmoStock( "flash_grenade", 0 );
		level.player SetWeaponAmmoClip( "flash_grenade", 0 );
		level.player setOffhandSecondaryClass( "flash" );
		
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.campaign = "british";
		return;
	}
	if ( level.script == "cargoship" )
	{
		game[ "gaveweapons" ] = 1;
		level.player SetActionSlot( 1, "" );
		level.player giveWeapon("USP");
		level.player giveWeapon("mp5_silencer");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player switchtoWeapon("mp5_silencer");
		level.player setOffhandSecondaryClass( "flash" );
		//level.player giveWeapon("claymore");
		//level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "coup" )
	{
		game[ "gaveweapons" ] = 1;
		level.player SetActionSlot( 1, "" );
		//level.player setViewmodel( "viewhands_black_kit" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "armada" )
	{
		game[ "gaveweapons" ] = 1;
		level.player SetActionSlot( 1, "" );
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m4_grunt");
		level.player switchToWeapon("m4_grunt");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		//level.player giveWeapon("c4");
		//level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
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
		level.player setViewmodel( "viewmodel_base_viewhands" );
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
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "bog_a_backhalf" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("colt45");
		level.player giveWeapon("m4_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player switchToWeapon( "m4_grenadier" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
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
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "hunted" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m4_grunt");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player SetActionSlot( 1, "" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m4_grunt" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	if ( level.script == "zipline" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("m14_scoped");
		level.player giveWeapon("mp5_silencer");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player switchToWeapon( "m4m203_silencer" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
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
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	if ( level.script == "airlift" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "smoke_grenade_american" );
		level.player switchToWeapon( "m4_grenadier" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}	
	if ( level.script == "scoutsniper" )
	{
		game["gaveweapons"] = 1;
		level.player giveWeapon("m14_scoped_silencer");
		level.player givemaxammo("m14_scoped_silencer");
		level.player giveWeapon("usp_silencer");
		level.player givemaxammo("usp_silencer");
		
		level.player giveWeapon("fraggrenade");

		level.player switchToWeapon("m14_scoped_silencer");
		level.player setViewmodel( "viewhands_marine_sniper" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "sniperescape" )
	{
		game[ "gaveweapons" ] = 1;
		level.initclaymoreammo = 6;
		level.player giveWeapon("m14_scoped");
		level.player giveWeapon("m4_silencer");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player giveWeapon("claymore");
		level.player switchtoWeapon("m14_scoped");
//		level.player giveWeapon("flash_grenade");
//		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_marine_sniper" );

		level.player setOffhandSecondaryClass( "smoke" );
		level.player SetActionSlot( 3, "weapon" , "claymore" );

		level.campaign = "american";
		return;
	}
	
	if ( level.script == "village_assault" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("m4_silencer");
		level.player giveWeapon("usp_silencer");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player setOffhandSecondaryClass( "smoke" );
		level.player giveWeapon("c4");
		level.player giveWeapon("cobra_air_support");
		level.player SetActionSlot( 3, "weapon" , "cobra_air_support" );
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player switchToWeapon( "m4_silencer" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "village_defend" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("m14_scoped");
		level.player giveWeapon("m4_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player setOffhandSecondaryClass( "smoke" );
		level.player giveWeapon("c4");
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player switchToWeapon( "m14_scoped" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "parabolic" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("parabolic");
		level.player giveWeapon("m4m203_silencer");
		level.player giveWeapon("usp_silencer");
		level.player giveWeapon("flash_grenade");
		level.player giveWeapon("fraggrenade");
		level.player takeweapon("m4m203_silencer");
		level.player takeweapon("usp_silencer");
		level.player takeweapon("flash_grenade");
		level.player takeweapon("fraggrenade");
		level.player switchToWeapon("parabolic");
		level.campaign = "american";
		return;
	}	

	if ( level.script == "icbm" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("m4m203_silencer");
		level.player switchToWeapon("m4m203_silencer");
		level.player giveWeapon("usp_silencer");
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


	if ( level.script == "launchfacility_a" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("colt45");
		level.player giveWeapon("m16_grenadier");
		level.player switchToWeapon( "m16_grenadier" );
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "jeepride" )
	{
		game[ "gaveweapons" ] = 1;
		level.player giveWeapon("colt45");
		level.player giveWeapon("M4_grunt");
		level.player switchToWeapon( "M4_grunt" );
		level.player giveWeapon("fraggrenade");
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if (issubstr(level.script,"firingrange"))
	{
		return; // no weapons on firing range
	}

	//------------------------------------
	// level.script is not a single player level. give default weapons.
	println ("loadout.gsc:     No level listing in _loadout.gsc, giving default guns");

	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("m4_grenadier");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon( "mp5" );
	level.player switchToWeapon( "m4_grenadier" );
	level.player setViewmodel( "viewmodel_base_viewhands" );
}


///////////////////////////////////////////////
// SavePlayerWeaponStatePersistent
//
// Saves the player's weapons and ammo state persistently (in the game variable)
// so that it can be restored in a different map.
// You can use strings for the slot:
//
// SavePlayerWeaponStatePersistent( "russianCampaign" );
//
// Or you can just use numbers:
//
// SavePlayerWeaponStatePersistent( 0 );
// SavePlayerWeaponStatePersistent( 1 ); etc.
//
// In a different map, you can restore using RestorePlayerWeaponStatePersistent( slot );
// Make sure that you always persist the data between map changes.
SavePlayerWeaponStatePersistent( slot )
{
	current = level.player getCurrentWeapon();
	game["weaponstates"][slot]["current"] = current;
	
	offhand = level.player getcurrentoffhand();
	game["weaponstates"][slot]["offhand"] = offhand;
	
	game["weaponstates"][slot]["list"] = [];
	weapList = level.player GetWeaponsList();
	for ( weapIdx = 0; weapIdx < weapList.size; weapIdx++ )
	{
		game["weaponstates"][slot]["list"][weapIdx]["name"] = weapList[weapIdx];
		game["weaponstates"][slot]["list"][weapIdx]["clip"] = level.player GetWeaponAmmoClip( weapList[weapIdx] );
		game["weaponstates"][slot]["list"][weapIdx]["stock"] = level.player GetWeaponAmmoStock( weapList[weapIdx] );
	}
}

RestorePlayerWeaponStatePersistent( slot )
{
	if ( !isDefined( game["weaponstates"] ) )
		return false;
	if ( !isDefined( game["weaponstates"][slot] ) )
		return false;

	level.player takeallweapons();
			
	for ( weapIdx = 0; weapIdx < game["weaponstates"][slot]["list"].size; weapIdx++ )
	{
		weapName = game["weaponstates"][slot]["list"][weapIdx]["name"];
		level.player GiveWeapon( weapName );
		
		level.player SetWeaponAmmoClip( weapName, game["weaponstates"][slot]["list"][weapIdx]["clip"] );
		level.player SetWeaponAmmoStock( weapName, game["weaponstates"][slot]["list"][weapIdx]["stock"] );
	}
	
	level.player switchtooffhand( game["weaponstates"][slot]["offhand"] );
	level.player SwitchToWeapon( game["weaponstates"][slot]["current"] );
	
	return true;
}