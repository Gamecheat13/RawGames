#include maps\_utility;
#include common_scripts\utility;

init_loadout()
{
	if ( !isdefined( level.dodgeloadout ) )
		give_loadout();
	level.loadoutComplete = true;
	level notify( "loadout complete" );
}


SetDefaultActionSlot()
{
	self SetActionSlot( 1, "" );
	self SetActionSlot( 2, "" );
	self SetActionSlot( 3, "altMode" );	// toggles between attached grenade launcher
	self SetActionSlot( 4, "" );
}

init_player()
{
	self SetDefaultActionSlot();
	self takeAllweapons();
}

// checks if character switched in coop mode, if so returns true, call once.
char_switcher()
{
	level.coop_player1 = level.player;
	level.coop_player2 = level.player2;

	if ( isdefined( level.character_switched ) && level.character_switched )
	{
		if ( is_coop() )
		{
			foreach ( player in level.players )
			{
				player init_player();
			}

			level.coop_player1 = level.player2;
			level.coop_player2 = level.player;
			level.character_switched = true;
			return true;
		}
		else
		{
			level.player init_player();

			level.coop_player1 = undefined;
			level.coop_player2 = level.player;

			level.character_switched = true;
			return true;
		}
	}
	return false;
}


get_loadout()
{
    if( isdefined( level.loadout ) )
        return level.loadout;
    return level.script;
}


give_loadout( character_selected )
{
    loadout_name = get_loadout();

	if ( !isdefined( character_selected ) )
		character_selected = false;

	level.character_selected = character_selected;

	// used to precach weapons for alternate character loadouts, will be replaced by later code efficent support.
	possible_precache_items = [];

	level.player SetDefaultActionSlot();
	if ( is_coop() )
		level.player2 SetDefaultActionSlot();

	if ( !isdefined( game[ "expectedlevel" ] ) )
		game[ "expectedlevel" ] = "";

	if ( !isdefined( level.campaign ) )
		level.campaign = "american";

	if ( string_starts_with( level.script, "pmc_" ) )
	{
		level.player setViewmodel( "viewmodel_base_viewhands" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );
			level.player2 setViewmodel( "viewmodel_base_viewhands" );
		}
		level.campaign = "american";
		return;
	}

	if ( is_specialop() )
	{
		give_loadout_specialops( character_selected );
		return;
	}
	
	if ( level.script == "background" )
	{
		level.player takeallweapons();
		return;
	}
	if ( level.script == "iw4_credits" )
	{
		level.player takeallweapons();
		return;
	}
	
	if ( loadout_name == "london" )
	{
		level.player GiveWeapon( "mp5_silencer_eotech" );
		level.player GiveWeapon( "usp_silencer" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( "mp5_silencer_eotech" );
		level.player SetViewmodel( "viewhands_sas" );
		level.campaign = "british";
		return;
	}
	else if ( loadout_name == "innocent" )
	{
		level.player SetViewmodel( "viewhands_sas" );
		level.campaign = "british";

		if ( !IsDefined( game[ "previous_map" ] ) )
		{
			level.player GiveWeapon( "mp5_silencer_eotech" );
			level.player GiveWeapon( "usp_silencer" );
			level.player GiveWeapon( "fraggrenade" );
			level.player GiveWeapon( "flash_grenade" );
			level.player SetOffhandSecondaryClass( "flash" );
			level.player SwitchToWeapon( "mp5_silencer_eotech" );
		}
		else
		{
			level.player SetOffhandSecondaryClass( "flash" );
			maps\_loadout::RestorePlayerWeaponStatePersistent( "london", true );
		}

		return;
	}
	else if ( loadout_name == "hamburg" )
	{
		level.player GiveWeapon( "m4m203_acog_payback" );
		level.player GiveWeapon( "smaw_nolock" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( "m4m203_acog_payback" );
		level.player SetViewmodel( "viewhands_delta" );
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "prague" )
	{
		level.default_weapon = "rsass_hybrid_silenced";
		level.player GiveWeapon( level.default_weapon );
		level.player GiveWeapon( "usp_silencer" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( level.default_weapon );
		level.player SetViewmodel( "viewhands_yuri_europe" );
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "warlord" )
	{
		level.player GiveWeapon( "m14ebr_scoped_silenced_warlord" );
		level.player GiveWeapon( "ak47_silencer_reflex" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( "m14ebr_scoped_silenced_warlord" );
		level.player SetViewmodel( "viewhands_yuri" );
		
		// TODO: they are private at this point...
		level.campaign = "american";
		return;
	}
	else if ( loadout_name == "castle" )
	{
		level.castle_main_weapon = "mp5_silencer_reflex_castle";
		level.castle_side_weapon = "p99_tactical_silencer";
		level.player GiveWeapon( level.castle_main_weapon );
		level.player GiveWeapon( level.castle_side_weapon );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( level.castle_main_weapon );
		level.player SetViewmodel( "viewhands_yuri_europe" );
		
		// TODO: they are private at this point...
		level.campaign = "american";
		return;
	}
	else if ( loadout_name == "berlin" )
	{
		level.player GiveWeapon( "m14ebr_scope" );
		level.player GiveWeapon( "acr_hybrid_berlin" );
		level.player GiveWeapon( "fraggrenade" );
		level.player SetOffhandSecondaryClass( "flash" );		
		level.player GiveWeapon( "ninebang_grenade" );
		level.player SwitchToWeapon( "acr_hybrid_berlin" );
		level.player SetViewmodel( "viewhands_delta" );
		
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "paris_a" )
	{
		level.player GiveWeapon( "scar_h_acog" );
		level.player giveWeapon( "usp_no_knife" );
		level.player GiveWeapon( "fraggrenade" );
		level.player SetOffhandSecondaryClass( "flash" );		
		level.player GiveWeapon( "ninebang_grenade" );
		level.player SwitchToWeapon( "scar_h_acog" );
		level.player SetViewmodel( "viewhands_delta" );
		
		// TODO: they are private at this point...
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "paris_b" )
	{
		level.player GiveWeapon( "scar_h_acog" );
		level.player giveWeapon( "usp_no_knife" );
		level.player GiveWeapon( "fraggrenade" );
		level.player SetOffhandSecondaryClass( "flash" );		
		level.player GiveWeapon( "ninebang_grenade" );
		level.player SwitchToWeapon( "scar_h_acog" );
		level.player SetViewmodel( "viewhands_delta" );
		
		// TODO: they are private at this point...
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "paris_ac130" )
	{
		level.player SetViewmodel( "viewhands_delta" );
		level.player GiveWeapon( "m4m203_reflex" );
		level.player GiveMaxAmmo( "m4m203_reflex" );
		//level.player GiveWeapon( "beretta" );
		//level.player Givemaxammo( "beretta" );
		
		level.player SetOffhandPrimaryClass( "frag" );
		level.player GiveWeapon( "fraggrenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player GiveWeapon ( "flash_grenade" );	
		level.player SwitchtoWeapon( "m4m203_reflex" );	
		
		level.campaign = "delta";
		return;			
	}
	else if ( loadout_name == "ny_manhattan" )
	{
		level.player GiveWeapon( "m4_hybrid_grunt_optim" );
		level.player GiveWeapon( "xm25" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( "m4_hybrid_grunt_optim" );
		level.player SetViewmodel( "viewhands_delta_shg" );
		
		// TODO: they are private at this point...
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "ny_harbor" )
	{
		level.player GiveWeapon( "mp5_silencer_reflex" );
		level.player GiveMaxAmmo( "mp5_silencer_reflex" );
		level.player GiveWeapon( "usp_no_knife" );
		level.player GiveMaxAmmo( "usp_no_knife" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "ninebang_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( "mp5_silencer_reflex" );
		level.player SetViewmodel( "viewhands_udt" );
		
		// TODO: they are private at this point...
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "dubai" )
	{
		level.dubai_main_weapon = "pecheneg_fastreload";
		
		level.player GiveWeapon( level.dubai_main_weapon );
		level.player GiveMaxAmmo( level.dubai_main_weapon );
		level.player GiveWeapon( "m4m203_acog" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( level.dubai_main_weapon );
		level.player SetViewmodel( "viewhands_juggernaut_ally" );
		
		// TODO: they are private at this point...
		level.campaign = "american";
		return;
	}
	else if ( loadout_name == "payback")
	{
		level.player GiveWeapon( "m4m203_acog_payback" );
		level.player GiveWeapon( "deserteagle" );
		level.player GiveWeapon( "fraggrenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SwitchToWeapon( "m4m203_acog_payback" );
		level.player SetViewmodel( "viewhands_yuri" );
		
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "hijack")
	{
		level.player GiveWeapon( "fnfiveseven" );
		//level.player SetOffhandSecondaryClass( "flash" );
		//level.player GiveWeapon( "flash_grenade" );
		level.player SwitchToWeapon( "fnfiveseven" );
		level.player SetViewmodel( "viewhands_fso" );
		
		// TODO: should this be russian?...
		level.campaign = "american";
		return;
	}
	else if ( loadout_name == "prague_escape")
	{
		level.player GiveWeapon( "deserteagle" );
		level.player GiveWeapon( "m4m203_reflex" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( "m4m203_reflex" );
		level.player SetViewmodel( "viewhands_yuri_europe" );
		level.campaign = "delta";
		return;
	}
	else if ( loadout_name == "intro" )
	{
		level.player GiveWeapon( "ak47_reflex" );
		level.player GiveMaxAmmo( "ak47_reflex" );
		level.player GiveWeapon( "deserteagle" );
		level.player GiveMaxAmmo( "deserteagle" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandPrimaryClass( "frag" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( "ak47_reflex" );
		level.player SetViewmodel( "viewhands_yuri" );
		
		level.campaign = "american";
		return;
	}
	else if ( loadout_name == "rescue" )
	{
		level.default_weapon = "acr_hybrid_silenced";
		level.player GiveWeapon( level.default_weapon );
		level.player GiveMaxAmmo( level.default_weapon );
		level.player GiveWeapon( "usp" );
		level.player GiveMaxAmmo( "usp" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandPrimaryClass( "frag" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( level.default_weapon );
		level.player SetViewmodel( "viewmodel_base_viewhands" );
		
		level.campaign = "american";
		return;
	}
	else if ( loadout_name == "rescue_2" )
	{
		level.default_weapon = "g36c_reflex";
		level.player GiveWeapon( level.default_weapon );
		level.player GiveMaxAmmo( level.default_weapon );
		level.player GiveWeapon( "m4_grunt_acog" );
		level.player GiveMaxAmmo( "m4_grunt_acog" );
		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandPrimaryClass( "frag" );
		level.player SetOffhandSecondaryClass( "flash" );
		level.player SwitchToWeapon( level.default_weapon );
		level.player SetViewmodel( "viewhands_yuri_europe" );
		
		level.campaign = "american";
		return;
	}
	else if ( loadout_name == "innocent" )
	{
		level.campaign = "british";
		return;
	}
	
	if ( issubstr( loadout_name, "firingrange" ) )
	{
		return;	// no weapons in firing range
	}

	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// level.script is not a single player level. give default weapons.
	/#
	println( "loadout.gsc:     No level listing in _loadout.gsc, giving default guns" );
	#/
	level.testmap = true;

	give_default_loadout();
}

give_loadout_specialops( character_selected )
{
    loadout_name = get_loadout();

	if( loadout_name == "so_nyse_ny_manhattan" )
	{
		level.so_campaign = "delta";
		
		foreach ( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "m4_hybrid_grunt_optim";
			secondary = "xm25";
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();			
		
		return;
	}
	
	if( loadout_name == "so_stealth_warlord" )
	{
		level.so_campaign = "delta";
		level.coop_incap_weapon = level.so_warlord_secondary;
		
		foreach ( i, player in level.players )
		{
			so_player_num( i );
			so_player_giveWeapon( level.so_warlord_primary );
			so_player_giveWeapon( level.so_warlord_secondary );
			so_player_set_switchToWeapon( level.so_warlord_primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
		
	if( loadout_name == "so_littlebird_payback" )
	{
		level.so_campaign 	= "delta";
		
		foreach ( i, player in level.players )
		{
			so_player_num( i );
			
			so_player_giveWeapon( level.so_payback_primary );
			so_player_giveWeapon( level.so_payback_secondary );
			so_player_set_switchToWeapon( level.so_payback_primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
		
	if( loadout_name == "so_ied_berlin" )
	{
		level.so_campaign = "delta";
		
		if ( is_coop() )
		{
			if ( GetDvar( "coop_start" ) == "so_char_host" )
			{
				jugg_player = 0;
				sniper_player = 1;
			}
			else
			{
				jugg_player = 1;
				sniper_player = 0;
			}
		}
		else
		{
			jugg_player = 0;
			sniper_player = 1;
		}
		// Juggernaut guy
		so_player_num( jugg_player );

		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_giveWeapon( "sa80lmg_fastreload_reflex" );
		so_player_giveWeapon( "m320" );
		so_player_set_switchToWeapon( "sa80lmg_fastreload_reflex" );
		
		so_player_setup_body( jugg_player );

		// Support guy
		so_player_num( sniper_player );
		
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "semtex_grenade" );
		so_player_set_setOffhandSecondaryClass( "semtex_grenade" );
		so_player_giveWeapon( "barrett" );
		so_player_giveWeapon( "scar_h_thermal_silencer" );
		so_player_set_switchToWeapon( "barrett" );
		
//		so_player_giveWeapon("claymore");
//		so_player_setactionslot( 2, "weapon", "claymore" );
//		
		so_player_setup_body( sniper_player );
		
		so_players_give_loadout();
		
		return;
	}
	
	if( loadout_name == "so_assault_rescue_2")
	{
		default_weapon = "m4_grunt_acog";
		level.so_campaign = "delta";

		foreach( i, player in level.players )
		{
			so_player_num( i );	
				
			so_player_giveWeapon( default_weapon );
			so_player_set_maxammo( default_weapon );
			so_player_giveWeapon( "g36c_reflex" );
			so_player_set_maxammo( "g36c_reflex" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );	
			so_player_set_setOffhandSecondaryClass( "flash" );								
			so_player_setup_body( i );	
			so_player_set_switchToWeapon( default_weapon );
					
		}	
		
		so_players_give_loadout();		
		return;
	}	
	
	if( loadout_name == "so_heliswitch_berlin" )
	{
		level.so_campaign = "delta";	
		
		foreach ( i, player in level.players )
		{

			so_player_num( i );
			
			assert(isdefined(level.primary_weapon));
			assert(isdefined(level.secondary_weapon));
			
			so_player_giveWeapon( level.primary_weapon );
			so_player_giveWeapon( level.secondary_weapon );
			so_player_set_switchToWeapon( level.primary_weapon );


			so_player_giveWeapon( "fraggrenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "flash_grenade" );
			
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		
		return;
	}

	if( loadout_name == "so_killspree_paris_a" )
	{
		level.so_campaign = "ranger";
	
		so_player_num( 0 );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_giveWeapon( "pecheneg_so_fastreload" );
		so_player_giveWeapon( "m320" );
		so_player_set_switchToWeapon( "pecheneg_so_fastreload" );
		so_player_setup_body( 0 );

		so_player_num( 1 );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_giveWeapon( "pecheneg_so_fastreload" );
		so_player_giveWeapon( "m320" );
		so_player_set_switchToWeapon( "m320" );
		so_player_setup_body( 1 );
		

		
		so_players_give_loadout();
		
		return;
	}

	
	if( loadout_name == "so_zodiac2_ny_harbor" )
	{
		level.so_campaign = "delta";
		
		
		foreach ( i, player in level.players )
		{

			so_player_num( i );
			
			assert(isdefined(level.primary_weapon));
			assert(isdefined(level.secondary_weapon));
			
			so_player_giveWeapon( level.primary_weapon );
			so_player_giveWeapon( level.secondary_weapon );
			so_player_set_switchToWeapon( level.primary_weapon );

			so_player_giveWeapon( "fraggrenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "flash_grenade" );
			
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		
		return;
	}
	
	if( loadout_name == "so_jeep_paris_b" )
	{
		level.so_campaign = "delta";
		
		foreach ( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "m320";
			secondary = "scar_h_grenadier_reflex";
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	
	if ( loadout_name == "so_ac130_paris_ac130" )
	{
		level.so_campaign = "delta";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
		
			primary = "m4m203_reflex";
			secondary = "fnfiveseven";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	
	if ( loadout_name == "so_stealth_prague" )
	{
		level.so_campaign = "sas";
		level.so_stealth = true;
		level.coop_incap_weapon = "usp_silencer";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "rsass_silenced";
			secondary = "usp_silencer";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}

	if ( loadout_name == "so_stealth_london" )
	{
		level.so_campaign = "sas";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "mp5_silencer_eotech";
			secondary = "usp_silencer";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}

	if ( loadout_name == "so_timetrial_london" )
	{
		level.so_campaign = "sas";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "mp5";
			secondary = "spas12_silencer";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	
	if ( loadout_name == "so_assaultmine" )
	{
		level.so_campaign = "delta";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "rsass";
			secondary = "acr_hybrid";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	
	if ( loadout_name == "so_deltacamp" )
	{
		level.so_campaign = "delta";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "acr";
			secondary = "usp";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	
	if ( loadout_name == "so_trainer2_so_deltacamp" )
	{
		level.so_campaign = "delta";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "mp5";
			secondary = "usp";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	if ( loadout_name == "so_milehigh_hijack" )
	{
		level.so_campaign = "hijack";
	
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
	
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
	
			so_player_giveWeapon( "ak47" );
			so_player_giveWeapon( "fnfiveseven" );
			so_player_set_switchToWeapon( "ak47" );
	
			so_player_setup_body( i );
		}
	
		so_players_give_loadout();
		return;
	}

	if ( loadout_name == "so_rescue_hijack" )
	{
		level.so_campaign = "fso";
		level.coop_incap_weapon = "usp_silencer_so";

		foreach ( i, player in level.players )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "usp_silencer_so" );
			so_player_set_switchToWeapon( "usp_silencer_so" );
			so_player_setup_body( i );
		}
		so_players_give_loadout();
		return;
	}
		
	
	if ( loadout_name == "so_javelin_hamburg" )
	{
		level.so_campaign = "delta";
		
		foreach( i, player in level.players )
		{
			so_player_num( i );
			
			primary = "javelin";
			secondary = "scar_h_acog";
			
			so_player_giveWeapon( primary );
			so_player_giveWeapon( secondary );
			so_player_set_switchToWeapon( primary );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	
	if ( loadout_name == "so_assassin_payback" )
	{
		level.so_campaign = "delta";
		
		// primary player is sniper
		so_player_num( 0 );
		so_player_giveWeapon( level.sniper_primary );
		so_player_giveWeapon( level.sniper_secondary );
		so_player_set_switchToWeapon( level.sniper_primary );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_setup_body( 0 );
		
		// secondary player is heavy
		so_player_num( 1 );
		so_player_giveWeapon( level.heavy_primary );
		so_player_giveWeapon( level.heavy_secondary );
		so_player_set_switchToWeapon( level.heavy_primary );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_setup_body( 1 );

		so_players_give_loadout();
		
		return;
	}

	if ( is_survival() )
	{
		level.so_campaign = "delta";
		
		// default for survival to have fnfiveseven_mp as last stand pistol
		// per level loadout pistol will override this
		level.coop_incap_weapon = "fnfiveseven_mp";
		
		// give default for now, option to be replaced later by survival script
		give_default_loadout();
		return;
	}

	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	/#
	println( "loadout.gsc:     No level listing in _loadout::give_loadout_specialops(), giving default guns" );
	#/
	level.testmap = true;
	level.so_campaign = "ranger";
	
	give_default_loadout();
}


// To precache possible weapons for alternate character loadout
possible_precache( possible_precache_items )
{
	foreach ( item in possible_precache_items )
		PreCacheItem( item );
}

give_default_loadout()
{
	if ( is_coop() || is_survival() )
	{
		switch_char = char_switcher();

		foreach( i, player in level.players )
			give_default_loadout_coop( i );

		so_players_give_loadout();
		return;
	}

	level.player giveWeapon( "fraggrenade" );
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon( "flash_grenade" );
	if ( is_specialop() )
		level.player giveWeapon( "m1014" );
	level.player giveWeapon( "mp5" );
	level.player switchToWeapon( "mp5" );
	level.player setViewmodel( "viewmodel_base_viewhands" );
}

give_default_loadout_coop( num )
{
	so_player_num( num );
	so_player_giveWeapon( "fraggrenade" );
	so_player_giveWeapon( "flash_grenade" );
	so_player_set_setOffhandSecondaryClass( "flash" );
	so_player_giveWeapon( "mp5" );
	so_player_giveWeapon( "m1014" );
	if (num == 0)
		so_player_set_switchToWeapon( "mp5" );
	else
		so_player_set_switchToWeapon( "m1014" );
	so_player_setup_body( num );
}

///////////////////////////////////////////////
// SavePlayerWeaponStatePersistent
// 
// Saves the player's weapons and ammo state persistently( in the game variable )
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
//
// If the bSaveAmmo parameter is true in SavePlayerWeaponStatePersistent(), the gun's clip
// and stock ammo will be saved, and can be restored with bRestoreAmmo true in the call to
// RestorePlayerWeaponStatePersistent().  (Otherwise weapons will be restored with max ammo.)

SavePlayerWeaponStatePersistent( slot, bSaveAmmo )
{
	if ( !IsDefined( bSaveAmmo ) )
		bSaveAmmo = false;
	
	level.player endon( "death" );
	if ( level.player.health == 0 )
		return;
	current = level.player GetCurrentPrimaryWeapon();
	if ( ( !isdefined( current ) ) || ( current == "none" ) )
		assertmsg( "Player's current weapon is 'none' or undefined. Make sure 'disableWeapons()' has not been called on the player when trying to save weapon states." );
	game[ "weaponstates" ][ slot ][ "current" ] = current;

	offhand = level.player getcurrentoffhand();
	game[ "weaponstates" ][ slot ][ "offhand" ] = offhand;

	game[ "weaponstates" ][ slot ][ "list" ] = [];
	weapList = array_combine( level.player GetWeaponsListPrimaries(), level.player GetWeaponsListOffhands() );
	for ( weapIdx = 0; weapIdx < weapList.size; weapIdx++ )
	{
		game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ] = weapList[ weapIdx ];

		if ( bSaveAmmo )
		{
			game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] = level.player GetWeaponAmmoClip( weapList[ weapIdx ] );
			game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] = level.player GetWeaponAmmoStock( weapList[ weapIdx ] );
		}
	}
}

RestorePlayerWeaponStatePersistent( slot, bRestoreAmmo )
{
	if ( !isDefined( bRestoreAmmo ) )
		bRestoreAmmo = false;
	
	if ( !isDefined( game[ "weaponstates" ] ) )
		return false;
	if ( !isDefined( game[ "weaponstates" ][ slot ] ) )
		return false;

	level.player takeallweapons();

	for ( weapIdx = 0; weapIdx < game[ "weaponstates" ][ slot ][ "list" ].size; weapIdx++ )
	{
		weapName = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ];

		if ( isdefined( level.legit_weapons ) )
		{
			// weapon doesn't exist in this level
			if ( !isdefined( level.legit_weapons[ weapName ] ) )
				continue;
		}

		// don't carry over C4 or claymores
		if ( weapName == "c4" )
			continue;
		if ( weapName == "claymore" )
			continue;
		level.player GiveWeapon( weapName );
		level.player GiveMaxAmmo( weapName );

		if ( bRestoreAmmo )
		{
			AssertEx( IsDefined(game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ]) && IsDefined(game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ]), "RestorePlayerWeaponStatePersistent() with bRestoreAmmo true only works if SavePlayerWeaponStatePersistent() was called with bSaveAmmo true" );
			
			level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
			level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
		}
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


sniper_escape_initial_secondary_weapon_loadout()
{
	level.player giveWeapon( "claymore" );
	level.player giveWeapon( "c4" );
	if ( level.gameskill >= 2 )
	{
		level.player SetWeaponAmmoClip( "claymore", 10 );
		level.player SetWeaponAmmoClip( "c4", 6 );
	}
	else
	{
		level.player SetWeaponAmmoClip( "claymore", 8 );
		level.player SetWeaponAmmoClip( "c4", 3 );
	}
	level.player SetActionSlot( 4, "weapon", "claymore" );
	level.player SetActionSlot( 2, "weapon", "c4" );
	level.player giveWeapon( "fraggrenade" );
	level.player giveWeapon( "flash_grenade" );
	level.player setOffhandSecondaryClass( "flash" );

	level.player setViewmodel( "viewhands_marine_sniper" );
}

set_legit_weapons_for_sniper_escape()
{
	legit_weapons = [];
	legit_weapons = [];
	legit_weapons[ "mp5" ] = true;
	legit_weapons[ "usp_silencer" ] = true;
	legit_weapons[ "ak47" ] = true;
	legit_weapons[ "g3" ] = true;
	legit_weapons[ "usp" ] = true;
	legit_weapons[ level.sniperescape_main_weapon ] = true;
	legit_weapons[ "dragunov" ] = true;
	legit_weapons[ "winchester1200" ] = true;
	legit_weapons[ "beretta" ] = true;
	legit_weapons[ "rpd" ] = true;
	legit_weapons[ "rpg" ] = true;
	level.legit_weapons = legit_weapons;
}

set_legit_weapons_for_favela_escape()
{
	legit_weapons = [];
	legit_weapons[ level.favela_escape_main_weapon ] = true;
	legit_weapons[ "beretta" ] = true;
	legit_weapons[ "glock" ] = true;
	
	legit_weapons[ "uzi" ] = true;
	legit_weapons[ "mp5" ] = true;
	legit_weapons[ "ump45" ] = true;
	legit_weapons[ "ump45_acog" ] = true;
	legit_weapons[ "ump45_reflex" ] = true;
	
	legit_weapons[ "ranger" ] = true;
	legit_weapons[ "model1887" ] = true;
	
	legit_weapons[ "m4m203_reflex" ] = true;
	legit_weapons[ "m4m203_eotech" ] = true;
	legit_weapons[ "m4_grenadier" ] = true;
	legit_weapons[ "m4_grunt" ] = true;
	legit_weapons[ "tavor_mars" ] = true;
	legit_weapons[ "tavor_acog" ] = true;
	legit_weapons[ "masada" ] = true;
	legit_weapons[ "masada_acog" ] = true;
	legit_weapons[ "masada_reflex" ] = true;
	legit_weapons[ "scar_h" ] = true;
	legit_weapons[ "scar_h_acog" ] = true;
	legit_weapons[ "scar_h_reflex" ] = true;
	legit_weapons[ "scar_h_shotgun" ] = true;
	legit_weapons[ "ak47" ] = true;
	legit_weapons[ "ak47_acog" ] = true;
	legit_weapons[ "ak47_reflex" ] = true;
	
	legit_weapons[ "dragunov" ] = true;
	
	legit_weapons[ "rpd" ] = true;
	legit_weapons[ "m240_reflex" ] = true;
	
	legit_weapons[ "rpg" ] = true;
	legit_weapons[ "m79" ] = true;
	
	level.legit_weapons = legit_weapons;
}

set_legit_weapons_for_dc_whitehouse()
{
	legit_weapons = [];
	legit_weapons[ level.dc_whitehouse_main_weapon ] = true;
	legit_weapons[ "beretta" ] = true;
	legit_weapons[ "glock" ] = true;
	
	legit_weapons[ "uzi" ] = true;
	legit_weapons[ "mp5" ] = true;
	legit_weapons[ "ump45" ] = true;
	legit_weapons[ "ump45_acog" ] = true;
	legit_weapons[ "ump45_reflex" ] = true;
	
	legit_weapons[ "ranger" ] = true;
	legit_weapons[ "model1887" ] = true;
	
	legit_weapons[ "m4m203_reflex" ] = true;
	legit_weapons[ "m4m203_eotech" ] = true;
	legit_weapons[ "m4_grenadier" ] = true;
	legit_weapons[ "m4_grunt" ] = true;
	legit_weapons[ "tavor_mars" ] = true;
	legit_weapons[ "tavor_acog" ] = true;
	legit_weapons[ "masada" ] = true;
	legit_weapons[ "masada_acog" ] = true;
	legit_weapons[ "masada_reflex" ] = true;
	legit_weapons[ "scar_h" ] = true;
	legit_weapons[ "scar_h_acog" ] = true;
	legit_weapons[ "scar_h_reflex" ] = true;
	legit_weapons[ "scar_h_shotgun" ] = true;
	legit_weapons[ "ak47" ] = true;
	legit_weapons[ "ak47_acog" ] = true;
	legit_weapons[ "ak47_reflex" ] = true;
	
	legit_weapons[ "dragunov" ] = true;
	
	legit_weapons[ "rpd" ] = true;
	legit_weapons[ "m240_reflex" ] = true;
	
	legit_weapons[ "rpg" ] = true;
	legit_weapons[ "m79" ] = true;
	
	level.legit_weapons = legit_weapons;
}

max_ammo_on_legit_sniper_escape_weapon()
{
	heldweapons = level.player GetWeaponsListAll();
	for ( i = 0; i < heldweapons.size; i++ )
	{
		weapon = heldweapons[ i ];
		if ( !isdefined( level.legit_weapons[ weapon ] ) )
			continue;
		if ( weapon == "rpg" )
			continue;

		level.player givemaxammo( weapon );
	}
}

force_player_to_use_legit_sniper_escape_weapon()
{
	heldweapons = level.player GetWeaponsListAll();

	// take away weapons mo has in scoutsniper that we dont have in sniperescape
	held_weapons = [];
	count = 0;

	for ( i = 0; i < heldweapons.size; i++ )
	{
		weapon = heldweapons[ i ];
		held_weapons[ weapon ] = true;
		if ( isdefined( level.legit_weapons[ weapon ] ) )
		{
			count++ ;
			continue;
		}

		level.player takeweapon( weapon );
	}

	if ( count == 2 )
		return;

	if ( count == 0 )
	{
		// need to fill in a slot
		level.player giveweapon( "ak47" );
		level.player switchtoWeapon( "ak47" );
	}

	// does player have a sniper rifle?
	if ( !isdefined( held_weapons[ level.sniperescape_main_weapon ] ) && !isdefined( held_weapons[ "dragunov" ] ) )
	{
		level.player giveweapon( level.sniperescape_main_weapon );
		level.player switchtoWeapon( level.sniperescape_main_weapon );
	}
}

//======================prototype=======================
// coop character selection script:

coop_gamesetup_menu()
{
	assert( is_coop() );
		
	// update difficulty:
	maps\_gameskill::setGlobalDifficulty();

	foreach ( idx, player in level.players )
		player maps\_gameskill::setDifficulty();

	// character selection: 
	level.character_switched = false;
	flag_init( "character_selected" );

	char_select_levels = "";  // "co_blackout co_suburban_america co_overgrown
	levels_array = [];
	levels_array = strTok( char_select_levels, " " );

	foreach ( level_string in levels_array )
	{
		if ( level_string == level.script )
		{
			// non-switched
			flag_set( "character_selected" );
			
			//precacheMenu( "coop_characterselect" );
			//character_select_menu();
		}
	}

	char_select_coop_ac130 = "so_ac130_co_hunted co_hunted co_ac130";
	levels_array_ac130 = [];
	levels_array_ac130 = strTok( char_select_coop_ac130, " " );

	foreach ( level_string in levels_array_ac130 )
	{
		if ( is_coop() && ( level_string == level.script ) )
		{
			pilot_num = getdvar( "ui_ac130_pilot_num" );
			
			if ( isdefined( pilot_num ) && pilot_num != "0" )
				level.character_switched = true;
			
			//reset
			//setdvar ( "ui_ac130_pilot_num", "" );
			
			flag_set( "character_selected" );
			
			//precacheMenu( "coop_characterselect" );
			//character_select_menu();
		}
	}
}

/*
character_select_menu()
{
	setup_character_menu();

	// close previous menus and open character selection
	level.response_queue = [];

	setblur( 2, .1 );
	foreach ( idx, player in level.players )
	{
		player closepopupMenu();
		player freezecontrols( true );
		player openpopupMenu( "coop_characterselect" );

		flag_init( "player" + idx + "_ready" );

		thread waittill_each_ready( player, "player" + idx + "_ready" );
		add_wait( ::flag_wait, "player" + idx + "_ready" );
	}

	do_wait();
 	setblur( 0, .2 );

 	foreach ( player in level.players )
 	{
		player closepopupMenu();
		player freezecontrols( false );
	}

 	// responses
 	assert( isdefined( level.response_queue[ 0 ] ) );
 	first_player = level.response_queue[ 0 ][ "player" ];
 	first_player_response = level.response_queue[ 0 ][ "response" ];

 	//assert( isdefined( level.response_queue[ 1 ] ) );
 	//second_player = level.response_queue[ 1 ][ "player" ];
 	//second_player_response = level.response_queue[ 1 ][ "response" ];

	// coop two player situation:
	if ( first_player == level.player )
	{
		if ( first_player_response == "char2" )
		{
			level.character_switched = true;
			maps\_loadout::give_loadout( true );
		}
	}
	else
	{
		if ( first_player_response == "char1" )
		{
			level.character_switched = true;
			maps\_loadout::give_loadout( true );
		}
	}

	flag_set( "character_selected" );
	//autosave_now( true );
}
*/

/*
waittill_each_ready( player, ready_flag )
{
	response = " ";
	while ( response != "char1" && response != "char2" )
	{
		player waittill( "menuresponse", menu, response );

		index = level.response_queue.size;
		level.response_queue[ index ] = [];
		level.response_queue[ index ][ "player" ] = player;
		level.response_queue[ index ][ "response" ] = response;

		break;
	}
	flag_set( ready_flag );
}
*/
/*
// temp - prototype, will be using string tables in the future
setup_character_menu()
{
	if ( level.script == "co_ac130" || level.script == "co_hunted" )
	{
		setdvar( "ui_character1_name", "AC130" );
		setdvar( "ui_character1_image", "level_character_ac130" );
		setdvar( "ui_character1_primary", "ui_transparent" );
		setdvar( "ui_character1_inv", "ui_transparent" );
		setdvar( "ui_character1_inv_counter", "" );

		setdvar( "ui_character2_name", "James" );
		setdvar( "ui_character2_image", "level_character_james" );
		setdvar( "ui_character2_primary", "weapon_m4carbine" );
		setdvar( "ui_character2_inv", "weapon_attachment_m203" );
		setdvar( "ui_character2_inv_counter", "x10" );
		return;
	}
	else if ( level.script == "co_blackout" )
	{
		setdvar( "ui_character1_name", "Price" );
		setdvar( "ui_character1_image", "level_character_price" );
		setdvar( "ui_character1_primary", "weapon_m4carbine" );
		setdvar( "ui_character1_inv", "weapon_attachment_m203" );
		setdvar( "ui_character1_inv_counter", "x10" );

		setdvar( "ui_character2_name", "Gaz" );
		setdvar( "ui_character2_image", "level_character_gaz" );
		setdvar( "ui_character2_primary", "weapon_m14_scoped" );
		setdvar( "ui_character2_inv", "ui_transparent" );
		setdvar( "ui_character2_inv_counter", "" );
		return;
	}
	else if ( level.script == "co_overgrown" )
	{
		setdvar( "ui_character1_name", "Price" );
		setdvar( "ui_character1_image", "level_character_price" );
		setdvar( "ui_character1_primary", "weapon_m4carbine" );
		setdvar( "ui_character1_inv", "weapon_attachment_m203" );
		setdvar( "ui_character1_inv_counter", "x10" );

		setdvar( "ui_character2_name", "Gaz" );
		setdvar( "ui_character2_image", "level_character_gaz" );
		setdvar( "ui_character2_primary", "weapon_m14_scoped" );
		setdvar( "ui_character2_inv", "weapon_claymore" );
		setdvar( "ui_character2_inv_counter", "x10" );
		return;
	}
	else if ( level.script == "co_suburban_america" )
	{
		setdvar( "ui_character1_name", "Price" );
		setdvar( "ui_character1_image", "level_character_price" );
		setdvar( "ui_character1_primary", "weapon_m4carbine" );
		setdvar( "ui_character1_inv", "weapon_attachment_m203" );
		setdvar( "ui_character1_inv_counter", "x10" );

		setdvar( "ui_character2_name", "Gaz" );
		setdvar( "ui_character2_image", "level_character_gaz" );
		setdvar( "ui_character2_primary", "weapon_m14_scoped" );
		setdvar( "ui_character2_inv", "weapon_claymore" );
		setdvar( "ui_character2_inv_counter", "x10" );
		return;
	}

	// Default
	setdvar( "ui_character1_name", "Price" );
	setdvar( "ui_character1_image", "level_character_price" );
	setdvar( "ui_character1_primary", "weapon_m4carbine" );
	setdvar( "ui_character1_inv", "weapon_attachment_m203" );
	setdvar( "ui_character1_inv_counter", "x10" );

	setdvar( "ui_character2_name", "Gaz" );
	setdvar( "ui_character2_image", "level_character_gaz" );
	setdvar( "ui_character2_primary", "weapon_m14_scoped" );
	setdvar( "ui_character2_inv", "weapon_claymore" );
	setdvar( "ui_character2_inv_counter", "x10" );
}

*/
//==========================================

/*
=============
///ScriptDocBegin
"Name: coop_gamesetup_ac130()"
"Summary: Opens difficulty menus for both co-op players and returns selected AC130 pilot (player entity). Must call precacheMenu("coop_setup"); precacheMenu("coop_setup2"); in level script."
"Module: gameskill"
"Example: 	ac130_pilot = coop_gamesetup_ac130();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
coop_gamesetup_ac130()
{
	assertex( isdefined( level.specops_character_selector ), "Failed to select character" );
	
	if ( level.specops_character_selector == "so_char_host" )
		return level.players[ 0 ];
		
	if ( level.specops_character_selector == "so_char_client" )
		return level.players[ 1 ];
	
	// failed to select	
	return level.players[ 0 ];
	
/*		
	if ( cointoss() )
		return level.player2;
	else
		return level.player;
		*/
/*
	if ( isdefined( level.character_switched ) && level.character_switched )
		return level.player2;

	return level.player;
*/
}

give_default_loadout_specialops()
{
	foreach( i, player in level.players )
	{
		so_player_num( i );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_giveWeapon( "mp5" );
		so_player_giveWeapon( "m1014" );
		so_player_set_switchToWeapon( "mp5" );
		so_player_setup_body( i );
	}

	so_players_give_loadout();
}

so_player_num( num )
{
	level.so_player_num = num;
	level.so_player_add_player_giveWeapon[ num ] = [];

	// level vars if this becomes more commmonly used should put the init somewhere above the loadout section.	
	if ( !isdefined( level.so_player_set_maxammo ) )
		level.so_player_set_maxammo = [];
	if ( !isdefined( level.so_player_set_setViewmodel ) )
		level.so_player_set_setViewmodel = [];
	if ( !isdefined( level.so_player_add_player_giveWeapon ) )
		level.so_player_add_player_giveWeapon = [];
	if ( !isdefined( level.so_player_set_setOffhandSecondaryClass ) )
		level.so_player_set_setOffhandSecondaryClass = [];
	if ( !isdefined( level.so_player_set_switchToWeapon ) )
		level.so_player_set_switchToWeapon = [];
	if ( !isdefined( level.so_player_SetModelFunc ) )
		level.so_player_SetModelFunc = [];
	if ( !isdefined( level.so_player_SetModelFunc_precache ) )
		level.so_player_SetModelFunc_precache = [];
	if ( !isdefined( level.so_player_SetActionSlot ) )
		level.so_player_SetActionSlot = [];

	level.so_player_set_maxammo[ num ] = [];
	level.so_player_set_setOffhandSecondaryClass[ num ] = [];
	level.so_player_add_player_giveWeapon[ num ] = [];
}

so_player_giveWeapon( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	if ( ! level.character_selected )
		precacheitem( weapon );
	level.so_player_add_player_giveWeapon[ num ][ weapon ] = 1;
}

so_player_set_maxammo( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_set_maxammo[ num ][ weapon ] = 1;
}

so_player_set_setOffhandSecondaryClass( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_set_setOffhandSecondaryClass[ num ] = weapon ;
}

so_player_set_switchToWeapon( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_set_switchToWeapon[ num ] = weapon;
}

so_player_set_setViewmodel( model )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	if ( ! level.character_selected )
		precachemodel( model );
	level.so_player_set_setViewmodel[ num ] = model ;
}

so_player_SetModelFunc( func, precache_func )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_SetModelFunc[ num ] = func;

	assert( isdefined( precache_func ) );
	if ( ! level.character_selected )
		[[ precache_func ]]();

}


so_player_SetActionSlot( slot, parm1, parm2 )
{
	assert( isdefined( slot ) );
	assert( isdefined( parm1 ) );
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;

	struct = spawnstruct();
	struct.slot = slot;
	struct.parm1 = parm1;
	if ( isdefined( parm2 ) )
		struct.parm2 = parm2;
	if ( isdefined( level.so_player_SetActionSlot[ num ] ) )
		index = level.so_player_SetActionSlot[ num ].size;
	else
		index = 0;
	level.so_player_SetActionSlot[ num ][ index ] = struct;
}


#using_animtree( "multiplayer" );


so_player_give_loadout( num )
{
	player = self;

	if ( isdefined( level.so_player_SetModelFunc[ num ] ) )
	{
		player setmodelfunc( level.so_player_SetModelFunc[ num ] );
		player setanim( %code, 1, 0 );
	}

	weapons = getarraykeys( level.so_player_add_player_giveWeapon[ num ] );
	foreach ( weapon in weapons )
	{
		player giveweapon( weapon );
		if ( isdefined( level.so_player_set_maxammo[ num ][ weapon ] ) )
			player givemaxammo( weapon );
	}

	if ( isdefined( level.so_player_set_setOffhandSecondaryClass[ num ] ) )
		player setOffhandSecondaryClass( "flash" );

	if ( isdefined( level.so_player_SetActionSlot[ num ] ) )
		player so_players_give_action( num );

	if ( isdefined( level.so_player_set_switchToWeapon[ num ] ) )
		player switchtoweapon( level.so_player_set_switchToWeapon[ num ] );

	if ( isdefined( level.so_player_set_setViewmodel[ num ] ) )
		player setviewmodel( level.so_player_set_setViewmodel[ num ] );
}

so_players_give_action( num )
{
	player = self;
	
	foreach( struct in level.so_player_SetActionSlot[ num ] )
	{
		if ( isdefined( struct.parm2 ) )
			player SetActionSlot( struct.slot, struct.parm1, struct.parm2 );
		else
			player SetActionSlot( struct.slot, struct.parm1 );
	}
}

so_players_give_loadout()
{
	foreach ( playerIndex, player in level.players )
	{
		player so_player_give_loadout( playerIndex );
	}
}

UpdateModel( modelFunc )
{

	self notify( "newupdatemodel" );

	if ( !isdefined( modelFunc ) )
	{
		self DetachAll();
		self setModel( "" );
		return;
	}

	self.last_modelfunc = modelFunc;

	if ( isdefined( self.is_hidden ) && self.is_hidden )
		return;

	self endon( "newupdatemodel" );

	for ( ;; )
	{
		self DetachAll();

		[[ modelFunc ]]();

		self UpdatePlayerModelWithWeapons();

		self waittill_any_return( "weapon_change", "weaponchange", "player_update_model", "player_downed", "not_in_last_stand" );
	}
}

so_player_setup_body( num )
{
	so_player_set_setViewmodel( so_player_get_hands() );
	
	// survival is added to condition due to sentry gun PIP seeing player
	if ( is_coop() || is_survival() )
		so_player_SetModelFunc( so_player_get_bodyfunc( num ), so_player_get_bodyfunc_precache( num ) );
}

so_player_get_bodyfunc( num )
{
	switch ( level.so_campaign )
	{
		case "ranger"		:		return ::so_body_player_ranger;
		case "seal"			:		return ::so_body_player_seal;
		case "arctic"		:		return ::so_body_player_arctic;
		case "woodland"		:		return ::so_body_player_woodland;
		case "desert"		:		return ::so_body_player_desert;
		case "ghillie"		:		return ::so_body_player_ghillie;
		case "delta"		:		return ::so_body_player_delta;
		case "sas"			:		return ::so_body_player_sas;
		case "hijack":
			if ( num == 0 )
			{
				return ::so_body_player_hijack_1;
			}
			else
			{
				return ::so_body_player_hijack_2;
			}
		case "fso":
			if ( num == 0 )
			{
				return ::so_body_player_fso_1;
			}
			else
			{
				return ::so_body_player_fso_2;
			}
		default:			assertex( false, "Special Ops requires level.campaign to be set to a valid value in order to setup the character body." );	
	}
	return ;
}

so_player_get_bodyfunc_precache( num )
{
	switch ( level.so_campaign )
	{
		case "ranger"		:		return ::so_body_player_ranger_precache;
		case "seal"			:		return ::so_body_player_seal_precache;
		case "arctic"		:		return ::so_body_player_arctic_precache;
		case "woodland"		:		return ::so_body_player_woodland_precache;
		case "desert"		:		return ::so_body_player_desert_precache;
		case "ghillie"		:		return ::so_body_player_ghillie_precache;
		case "delta"		:		return ::so_body_player_delta_precache;
		case "sas"			:		return ::so_body_player_sas_precache;
		case "hijack":
			if ( num == 0 )
			{
				return ::so_body_player_hijack_precache_1;
			}
			else
			{
				return ::so_body_player_hijack_precache_2;
			}
		case "fso":
			if ( num == 0 )
			{
				return ::so_body_player_fso_precache_1;
			}
			else
			{
				return ::so_body_player_fso_precache_2;
			}
	}
	return ;
}

so_player_get_hands()
{
	switch ( level.so_campaign )
	{
		case "ranger"		:		return "viewmodel_base_viewhands";
		case "seal"			:		return "viewhands_udt";
		case "arctic"		:		return "viewhands_arctic";
		case "woodland"		:		return "viewhands_sas_woodland";
		case "desert"		:		return "viewhands_tf141";
		case "ghillie"		:		return "viewhands_marine_sniper";
		case "delta"		:		return "viewhands_delta";
		case "sas"			:		return "viewhands_sas";
		case "hijack"		:		return "viewhands_henchmen";
		case "fso" 			:		return "viewhands_fso";
	}
}

so_body_player_ranger()				{ self SetModel( "coop_body_us_army" );				self Attach( "coop_head_us_army", "", true ); }
so_body_player_seal()				{ self setModel( "coop_body_seal_udt" );			self attach( "coop_head_seal_udt", "", true ); }
so_body_player_arctic()				{ self setModel( "coop_body_tf141_arctic" );		self attach( "coop_head_tf141_arctic", "", true ); }
so_body_player_woodland()			{ self setModel( "coop_body_tf141_forest" );		self attach( "coop_head_tf141_forest", "", true ); }
so_body_player_desert()				{ self setModel( "coop_body_tf141_desert" );		self attach( "coop_head_tf141_desert", "", true ); }
so_body_player_ghillie()			{ self setModel( "coop_body_ghillie_forest" );		self attach( "coop_head_ghillie_forest", "", true ); }
so_body_player_delta()				{ self setModel( "mp_body_delta_elite_assault_bb" );self attach( "head_delta_elite_a", "", true ); }
so_body_player_sas()				{ self setModel( "body_mp_sas_urban_specops" );	}
so_body_player_hijack_1()			{ self setModel( "mp_body_henchmen_assault_d" ); self attach( "head_henchmen_a", "", true ); }
so_body_player_hijack_2()			{ self setModel( "mp_body_henchmen_shotgun_a" ); self attach( "head_henchmen_c", "", true ); }
so_body_player_fso_1()				{ self setModel( "mp_body_fso_vest_c_dirty" ); self attach( "head_fso_e_dirty", "", true );	}
so_body_player_fso_2()				{ self setModel( "mp_body_fso_vest_d_dirty" ); self attach( "head_fso_d_dirty", "", true );	}

so_body_player_ranger_precache()	{ precachemodel( "coop_body_us_army" );				precachemodel( "coop_head_us_army" ); }
so_body_player_seal_precache()		{ precachemodel( "coop_body_seal_udt" );			precachemodel( "coop_head_seal_udt" ); }
so_body_player_arctic_precache()	{ precachemodel( "coop_body_tf141_arctic" );		precachemodel( "coop_head_tf141_arctic" ); }
so_body_player_woodland_precache()	{ precachemodel( "coop_body_tf141_forest" );		precachemodel( "coop_head_tf141_forest" ); }
so_body_player_desert_precache()	{ precachemodel( "coop_body_tf141_desert" );		precachemodel( "coop_head_tf141_desert" ); }
so_body_player_ghillie_precache()	{ precachemodel( "coop_body_ghillie_forest" );		precachemodel( "coop_head_ghillie_forest" ); }
so_body_player_delta_precache()		{ precachemodel( "mp_body_delta_elite_assault_bb" );precachemodel( "head_delta_elite_a" ); }
so_body_player_sas_precache()		{ precachemodel( "body_mp_sas_urban_specops" ); }
so_body_player_hijack_precache_1()	{ precachemodel( "mp_body_henchmen_assault_d" );	precachemodel( "head_henchmen_a" ); }
so_body_player_hijack_precache_2()	{ precachemodel( "mp_body_henchmen_shotgun_a" );	precachemodel( "head_henchmen_c" ); }
so_body_player_fso_precache_1()		{ precachemodel( "mp_body_fso_vest_c_dirty" );	precachemodel( "head_fso_e_dirty" ); }
so_body_player_fso_precache_2()		{ precachemodel( "mp_body_fso_vest_d_dirty" );	precachemodel( "head_fso_d_dirty" ); }
