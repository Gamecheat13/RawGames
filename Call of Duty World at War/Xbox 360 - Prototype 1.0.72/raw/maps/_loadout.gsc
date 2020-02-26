#include maps\_utility;

init()
{
	mptype\mptype_ally_cqb::precache();
	mptype\mptype_ally_sniper::precache();
	mptype\mptype_ally_rifleman::precache();
	mptype\mptype_ally_support::precache();
}

init_loadout()
{
// SCRIPTER_MOD
// MikeD (3/16/2007): No more level.player
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] give_loadout();
		players[i].pers["class"] = "closequarters";
	}
	level.loadoutComplete = true;
	level notify("loadout complete");	
}

give_loadout()
{
// SCRIPTER_MOD
// MikeD (3/16/2007): No more level.player
//	level.player SetActionSlot( 1, "altMode" );			//DPAD_UP toggles between attached grenade launcher
//	level.player SetActionSlot( 2, "nightvision" );		//DPAD_DOWN toggles night vision on/off
//	level.player SetActionSlot( 3, "" );
//	level.player SetActionSlot( 4, "" );

	self SetActionSlot( 1, "altMode" );			//DPAD_UP toggles between attached grenade launcher
	
	// SCRIPTER_MOD
	// JesseS (3/21/2007): Took out night vision
	//self SetActionSlot( 2, "nightvision" );		//DPAD_DOWN toggles night vision on/off
	self SetActionSlot( 2, "" );
	self SetActionSlot( 3, "" );
	self SetActionSlot( 4, "" );

	if( !IsDefined( game["gaveweapons"] ) )
	{
		game["gaveweapons"] = 0;
	}

	if( !IsDefined( game["expectedlevel"] ) )
	{
		game["expectedlevel"] = "";
	}
	
	if( game["expectedlevel"] != level.script )
	{
		game["gaveweapons"] = 0;		
	}

	if( !IsDefined( level.campaign ) )
	{
		level.campaign = "american";
	}

// SCRIPTER_MOD
// MikeD (3/16/2007): Testmap for Coop
	if( level.script == "coop_test1" )
	{
		if( game["gaveweapons"] == 0 )
		{
			game["gaveweapons"] = 1;
		}

		self GiveWeapon( "m1garand" );
		self GiveWeapon( "thompson" );
		self SwitchToWeapon( "m1garand" );
		self GiveWeapon( "fraggrenade" );
//		self SetOffhandSecondaryClass( "smoke" );
		level.campaign = "american";
		return;
	}
	
// SCRIPTER_MOD
// MikeD (3/16/2007): OLD COD4! REMOVE LATER!
//	if( level.script == "background" )
//	{
//		level.player TakeAllWeapons();
//		game["gaveweapons"] = 1;
//		return;
//	}
//	
//	if( level.script == "armada" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon("Beretta");
//		level.player giveWeapon("m16_grenadier");
//		level.player switchToWeapon("m16_grenadier");
//		level.player giveWeapon("fraggrenade");
//		level.player giveWeapon("flash_grenade");
//		level.player setOffhandSecondaryClass( "flash" );
//		level.player giveWeapon("claymore");
//		level.player SetActionSlot( 3, "weapon" , "claymore" );
//		//level.player giveWeapon("c4");
//		//level.player SetActionSlot( 4, "weapon" , "c4" );
//		level.campaign = "american";
//		return;
//	}
//	
//	if( level.script == "statue" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon("Beretta");
//		level.player giveWeapon("m16_grenadier");
//		level.player switchToWeapon("m16_grenadier");
//		level.player giveWeapon("fraggrenade");
//		level.player giveWeapon("flash_grenade");
//		level.player setOffhandSecondaryClass( "flash" );
//		level.player giveWeapon("claymore");
//		level.player SetActionSlot( 3, "weapon" , "claymore" );
//		level.player giveWeapon("c4");
//		level.player SetActionSlot( 4, "weapon" , "c4" );
//		level.campaign = "american";
//		return;
//	}
//	
//	if( level.script == "bog_a" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon("Beretta");
//		level.player giveWeapon("m4_grenadier");
//		level.player giveWeapon("fraggrenade");
//		level.player giveWeapon("flash_grenade");
//		level.player setOffhandSecondaryClass( "flash" );
////		level.player giveWeapon("c4");
////		level.player SetActionSlot( 4, "weapon" , "c4" );
//		level.campaign = "american";
//		return;
//	}
//	
//	if( level.script == "bog_b" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon( "Beretta" );
//		level.player giveWeapon( "m4_grenadier" );
//		level.player giveWeapon( "fraggrenade" );
//		level.player giveWeapon( "flash_grenade" );
//		level.player setOffhandSecondaryClass( "flash" );
//		level.player switchToWeapon( "m4_grenadier" );
//		level.campaign = "american";
//		return;
//	}
//	
//	if( level.script == "hunted" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon("Beretta");
//		level.player giveWeapon("m4_grenadier");
//		level.player giveWeapon("fraggrenade");
//		level.player giveWeapon("flash_grenade");
//		level.player setOffhandSecondaryClass( "flash" );
//		level.player switchToWeapon( "m4_grenadier" );
//		level.campaign = "american";
//		return;
//	}
//
//	if( level.script == "school" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon("usp");
//		level.player giveWeapon("m4m203_silencer");
//		level.player giveWeapon("fraggrenade");
//		level.player giveWeapon("flash_grenade");
//		level.player switchtoWeapon("m4m203_silencer");
//		level.player setOffhandSecondaryClass( "flash" );
//		level.campaign = "american";
//		return;
//	}
//	
//	if( level.script == "scoutsniper" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon("m4_silencer");
//		level.player giveWeapon("dragunov");
//		level.player switchToWeapon("m4_silencer");
//		level.campaign = "american";
//		return;
//	}
//	
//	if( level.script == "sniperescape" )
//	{
//		game["gaveweapons"] = 1;
//		level.player giveWeapon("m14_scoped");
//		level.player giveWeapon("m4_grenadier");
//		level.player giveWeapon("fraggrenade");
//		level.player giveWeapon("flash_grenade");
//		level.player switchtoWeapon("m14_scoped");
//		level.player setOffhandSecondaryClass( "flash" );
//		level.player giveWeapon("claymore");
//		level.player SetActionSlot( 3, "weapon" , "claymore" );
//		level.campaign = "american";
//		return;
//	}

	//------------------------------------
	// level.script is not a single player level. give default weapons.
	println ("loadout.gsc:     No level listing in _loadout.gsc, giving default guns");

// SCRIPTER_MOD
// MikeD (3/16/2007): This is now done in the mptype (called in _load::player_init(), so we don't need to do this anymore.
//	if(level.campaign == "russian")
//	{
//		thread setup_russian();
//	}
//	else
//	{
//		thread setup_american();
//	}

// SCRIPTER_MOD
// MikeD (3/16/2007): No more level.player
//	level.player giveWeapon("fraggrenade");
//	level.player giveWeapon("m4_grenadier");
//	level.player giveWeapon("fraggrenade");
//	level.player giveWeapon("flash_grenade");
//	level.player setOffhandSecondaryClass( "flash" );
//	level.player giveWeapon( "mp5" );
//	level.player switchToWeapon( "m4_grenadier" );

	self GiveWeapon( "m1garand" );
	self GiveWeapon( "thompson" );
	self SwitchToWeapon( "m1garand" );
	self GiveWeapon( "fraggrenade" );
//	self SetOffHandSecondaryClass( "smoke" );
}

// SCRIPTER_MOD
// MikeD (3/16/2007): This is now done in the mptype (called in _load::player_init(), so we don't need to do this anymore.
//setup_american()
//{
//	self setViewmodel( "viewmodel_base_viewhands" );
//}
//
//setup_russian()
//{
//	self setViewmodel( "viewmodel_base_viewhands" );
//}

give_model( class )
{
	switch ( class )
	{
		case "rifleman":
			self mptype\mptype_ally_rifleman::main();
		break;
		case "assault":
			self mptype\mptype_ally_sniper::main();
		break;
		case "support":
			self mptype\mptype_ally_support::main();
		break;
		case "closequarters":
		default:
			self mptype\mptype_ally_cqb::main();
		break;
	}
}