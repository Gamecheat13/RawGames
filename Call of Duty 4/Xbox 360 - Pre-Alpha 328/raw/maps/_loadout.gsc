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

	if ( !isdefined( game[ "expectedlevel" ] ) )
		game[ "expectedlevel" ] = "";

	if ( !isdefined( level.campaign ) )
		level.campaign = "american";
	
	if ( level.script == "background" )
	{
		level.player takeallweapons();
		return;
	}
	
	if ( level.script == "killhouse" )
	{
		level.player SetActionSlot( 1, "" );
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player SetWeaponAmmoStock( "fraggrenade", 0 );
		level.player SetWeaponAmmoClip( "fraggrenade", 0 );
		level.player SetWeaponAmmoStock( "flash_grenade", 0 );
		level.player SetWeaponAmmoClip( "flash_grenade", 0 );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "cargoship" )
	{
		level.player SetActionSlot( 1, "" );
		level.player giveWeapon("USP");
		level.player giveWeapon("mp5_silencer");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player switchtoWeapon("mp5_silencer");
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "coup" )
	{
		level.player SetActionSlot( 1, "" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "blackout" )
	{
		level.player giveWeapon("m4m203_silencer_reflex");
		level.player givemaxammo("m4m203_silencer_reflex");
		level.player giveWeapon("m14_scoped");
		level.player giveMaxAmmo("m14_scoped");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "armada" )
	{
		level.player SetActionSlot( 1, "" );
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m4_grunt");
		level.player switchToWeapon("m4_grunt");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon("claymore");
		level.player givemaxammo("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "bog_a" )
	{
		level.player giveWeapon("Beretta");
		level.player giveWeapon("m4_grenadier");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "bog_a_backhalf" )
	{
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
	
	if ( level.script == "ambush" )
	{
		
		level.player giveWeapon("colt45");
		level.player giveWeapon("remington700");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player SetWeaponAmmoStock( "remington700", 10 );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "remington700" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "hunted" )
	{
		level.player giveWeapon("colt45");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player SetActionSlot( 1, "" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "colt45" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "aftermath" )
	{
		level.player takeallweapons();
		level.player SetActionSlot( 1, "" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "bog_b" )
	{
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
	
	if ( level.script == "airlift" )
	{
		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m4_grenadier" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "village_assault" )
	{
		level.player giveWeapon("m4m203_silencer");
		level.player giveWeapon("m1014");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player setOffhandSecondaryClass( "smoke" );
		level.player giveWeapon("c4");
		level.player giveWeapon("cobra_air_support");
		level.player SetActionSlot( 3, "weapon" , "cobra_air_support" );
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player switchToWeapon( "m4m203_silencer" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "scoutsniper" )
	{
		level.player giveWeapon("m14_scoped_silencer");
		level.player givemaxammo("m14_scoped_silencer");
		level.player giveWeapon("usp_silencer");
		level.player givemaxammo("usp_silencer");
		level.player giveWeapon("claymore");
		level.player givemaxammo("claymore");
		level.player giveWeapon("fraggrenade");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player switchToWeapon("m14_scoped_silencer");
		level.player setViewmodel( "viewhands_marine_sniper" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "sniperescape" )
	{
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "scoutsniper" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player giveWeapon("m14_scoped");
			level.player giveWeapon("M4_grunt");
			level.player switchtoWeapon("m14_scoped");		
		}
		
		// set these regardless of starting from level select menu OR previous level
		level.campaign = "british";
		level.initclaymoreammo = 6;
		level.player giveWeapon("claymore");
		level.player givemaxammo("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player setOffhandSecondaryClass( "smoke" );
		level.player setViewmodel( "viewhands_marine_sniper" );
		
		return;
	}
	
	if ( level.script == "village_defend" )
	{
		level.player giveWeapon("m14_scoped_woodland");
		level.player giveWeapon("saw");
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player setOffhandSecondaryClass( "smoke" );
		level.player giveWeapon("claymore");
		level.player givemaxammo("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player switchToWeapon( "saw" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}
	
	if ( level.script == "icbm" )
	{
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
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}

	if ( level.script == "launchfacility_a" )
	{
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "icbm" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player giveWeapon("colt45");
			level.player giveWeapon("m16_grenadier");
			level.player switchToWeapon( "m16_grenadier" );	
		}
				
		// set these regardless of starting from level select menu OR previous level
		level.campaign = "british";
		level.initclaymoreammo = 6;
		level.player giveWeapon("claymore");
		level.player givemaxammo("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("smoke_grenade_american");
		level.player setOffhandSecondaryClass( "smoke" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		
		return;
	}

	if ( level.script == "launchfacility_b" )
	{
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "launchfacility_a" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player giveWeapon("usp_silencer");
			level.player giveWeapon("m4m203_silencer");
			level.player switchToWeapon( "m4m203_silencer" );
		}
				
		// set these regardless of starting from level select menu OR previous level
		level.campaign = "british";
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 3, "weapon" , "claymore" );
		level.player giveWeapon("c4");
		level.player SetActionSlot( 4, "weapon" , "c4" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player giveWeapon("fraggrenade");
		level.player giveWeapon("flash_grenade");
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		
		return;
	}
	
	if ( level.script == "jeepride" )
	{
		level.player giveWeapon("colt45");
		level.player giveWeapon("M4_grunt");
		level.player switchToWeapon( "M4_grunt" );
		level.player giveWeapon("fraggrenade");
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
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
	if ( ( !isdefined( current ) ) || ( current == "none" ) )
		assertmsg( "Player's current weapon is 'none' or undefined. Make sure 'disableWeapons()' has not been called on the player when trying to save weapon states." );
	game["weaponstates"][slot]["current"] = current;
	
	offhand = level.player getcurrentoffhand();
	game["weaponstates"][slot]["offhand"] = offhand;
	
	game["weaponstates"][slot]["list"] = [];
	weapList = level.player GetWeaponsList();
	for ( weapIdx = 0; weapIdx < weapList.size; weapIdx++ )
	{
		game["weaponstates"][slot]["list"][weapIdx]["name"] = weapList[weapIdx];
		
		//below is only used if we want to NOT give max ammo
		//game["weaponstates"][slot]["list"][weapIdx]["clip"] = level.player GetWeaponAmmoClip( weapList[weapIdx] );
		//game["weaponstates"][slot]["list"][weapIdx]["stock"] = level.player GetWeaponAmmoStock( weapList[weapIdx] );
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
		
		//don't carry over C4 or claymores
		if ( weapName == "c4" )
			continue;
		if ( weapName == "claymore" )
			continue;
		level.player GiveWeapon( weapName );
		level.player GiveMaxAmmo( weapName );
		
		//below is only used if we want to NOT give max ammo
		//level.player SetWeaponAmmoClip( weapName, game["weaponstates"][slot]["list"][weapIdx]["clip"] );
		//level.player SetWeaponAmmoStock( weapName, game["weaponstates"][slot]["list"][weapIdx]["stock"] );
	}
	
	level.player switchtooffhand( game["weaponstates"][slot]["offhand"] );
	level.player SwitchToWeapon( game["weaponstates"][slot]["current"] );
	
	return true;
}