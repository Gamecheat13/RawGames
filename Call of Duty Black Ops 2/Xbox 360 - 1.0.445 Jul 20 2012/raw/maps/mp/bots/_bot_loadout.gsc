#include common_scripts\utility;
#include maps\mp\_utility;

#define BOT_ALLOCATION_MAX 10

bot_give_loadout()
{
	pixbeginevent( "bot_give_loadout" );

	self ClearPerks();

	for ( i = 0; i < level.maxSpecialties; i++ )
	{
		self.bot[ "specialty" + ( i + 1 ) ] = "perk_null";
	}

/#
	if ( bot_should_clone_loadout() )
	{
		self bot_clone_loadout( level.dev_cac_player );
		pixendevent();
		return;
	}
#/
	allocation_remaining = BOT_ALLOCATION_MAX;
	self.chosen_items = [];
	
	while( allocation_remaining > 0 )
	{
		allocation_remaining = self bot_give_random_item( allocation_remaining );
	}

	self bot_equip_items();

/*
	println( "Bot '" + self.name + "' loadout:" );

	foreach( item in self.chosen_items )
	{
		println( "   " + item[ "reference" ] );
	}
*/

	self.chosen_items = undefined;
	
/*
	if ( GetDvarint( "sv_botsForceFragOnly" ) )
	{
		self TakeWeapon( self.bot[ "primary" ] );
		
		if ( IsDefined(self.bot[ "secondary" ] ) )
		{
			self TakeWeapon( self.bot[ "secondary" ] );
		}
		
		self TakeWeapon( self.bot[ "specialgrenade" ] );
	}
	else if ( GetDvarint( "sv_botsForceSpecialOnly" ) )
	{
		self TakeWeapon( self.bot[ "primary" ] );
		
		if ( IsDefined(self.bot[ "secondary" ] ) )
		{
			self TakeWeapon( self.bot[ "secondary" ] );
		}
		
		self TakeWeapon( self.bot[ "primarygrenade" ] );
	}
	else
	{
		self SetSpawnWeapon( self.bot[ "primary" ] );
	}
*/

	if ( isKillstreaksEnabled() && level.loadoutKillstreaksEnabled == true )
	{
		self bot_give_killstreaks();
	}
	self bot_set_player_model();
	pixendevent();
}

bot_equip_items()
{
	pixbeginevent( "bot_equip_items" );

	primary_grenade = "";
	primary_grenade_count = 0;

	secondary_grenade = "";
	secondary_grenade_count = 0;
	
	foreach( item in self.chosen_items )
	{
		if ( item[ "group" ] == "weapon_grenade" )
		{
			if ( primary_grenade == item[ "reference" ] )
			{
				primary_grenade_count++;
			}
			else if ( secondary_grenade == item[ "reference" ] )
			{
				secondary_grenade_count++;
			}
			else if ( primary_grenade == "" )
			{
				primary_grenade = item[ "reference" ];
				primary_grenade_count++;
			}
			else if ( secondary_grenade == "" )
			{
				secondary_grenade = item[ "reference" ];
				secondary_grenade_count++;
			}
		}
	}

	if ( primary_grenade == "" && secondary_grenade == "" )
	{
		self GiveWeapon( level.weapons["frag"] );
		self SetWeaponAmmoClip( level.weapons["frag"], 0 );

		self.grenadeTypePrimary = level.weapons["frag"];
		self.grenadeTypePrimaryCount = 0;
	}
	else if ( primary_grenade != "" )
	{
		weapon = primary_grenade + "_mp";
		self GiveWeapon( weapon );
		self SetWeaponAmmoClip( weapon, primary_grenade_count );
		self SwitchToOffhand( weapon );
		self SetOffhandPrimaryClass( weapon );

		self.grenadeTypePrimary = weapon;
		self.grenadeTypePrimaryCount = primary_grenade_count;
	}
	else if ( secondary_grenade != "" )
	{
		weapon = secondary_grenade + "_mp";

		self GiveWeapon( weapon );
		self SetWeaponAmmoClip( weapon, secondary_grenade_count );

		self.grenadeTypeSecondary = weapon;
		self.grenadeTypeSecondaryCount = secondary_grenade_count;
	}

	self.class_num = 0;

	pixendevent();
}

bot_give_killstreaks()
{
	if ( IsDefined( self.killstreak ) && self.killstreak.size > 0 )
	{
		return;
	}

	self.killstreak = [];

	allowed_killstreaks = [];
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_dogs";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_qrdrone";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_spyplane";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_supply_drop";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_rcbomb";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_auto_turret";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_tow_turret";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_planemortar";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_helicopter_guard";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_spyplane_direction";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_helicopter_comlink";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_missile_swarm";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_helicopter_player_gunner";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_counteruav";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_emp";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_ai_tank_drop";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_microwave_turret";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_remote_missile";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_remote_mortar";
	allowed_killstreaks[ allowed_killstreaks.size ] = "killstreak_straferun";

	allowed_killstreaks = array_randomize( allowed_killstreaks );

	for ( i = 0; i < 3; i++ )
	{
		killstreak_ref = allowed_killstreaks[ i ];
		self.killstreak[ i ] = killstreak_ref;
	}

/*
	println( "Bot '" + self.name + "' killstreaks:" );

	foreach( ks in self.bot[ "killstreaks" ] )
	{
		println( "   " + ks );
	}
*/
}

bot_has_item( item )
{
	pixbeginevent( "bot_has_item" );

	grenade_count = 0;
	weapon_count = 0;

	foreach( chosen_item in self.chosen_items )
	{
		// except for grenades, allow only one of each item
		if ( item[ "group" ] != "weapon_grenade" )
		{
			if ( chosen_item[ "reference" ] == item[ "reference" ] )
			{
				pixendevent();
				return true;
			}
		}

		// allow at most two grenades from the same group
		if ( item[ "group" ] == "weapon_grenade" && chosen_item[ "group" ] == "weapon_grenade" )
		{
			if ( item[ "reference" ] == chosen_item[ "reference" ] )
			{
				switch( item[ "reference" ] )
				{
					case "tactical_insertion":
					case "acoustic_sensor":
					case "trophy_system":
						pixendevent();
						return true;
				}

				pixendevent();
				return false;
			}

			grenade_count++;
			
			if ( grenade_count >= 2 )
			{
				pixendevent();
				return true;
			}
		}

		// allow at most one primary and one secondary
		if ( item[ "group" ] != "specialty" && item[ "group" ] != "weapon_grenade" )
		{
			if ( chosen_item[ "group" ] != "specialty" && chosen_item[ "group" ] != "weapon_grenade" )
			{
				weapon_count++;
			}

			if ( weapon_count >= 2 )
			{
				pixendevent();
				return true;
			}
		}
	}

	pixendevent();
	return false;
}

bot_give_random_item( allocation )
{
	pixbeginevent( "bot_give_random_item" );
	
	rank = self.bot[ "rank" ];

	if ( level.bot_offline )
	{
		rank = level.maxRank;
	}

	index = 77;
	start = -1;
	
	for( ; index != start; index++ )
	{
		if ( index >= level.bot_loadout_items.size )
		{
			index = 0;
		}

		if ( index == start )
		{
			break;
		}

		if ( start == -1 )
		{
			start = index;
		}

		id = level.bot_loadout_items[ index ];

		if ( id[ "reference" ] == "satchel_charge" )
		{
			continue;
		}

		if ( bot_has_item( id ) )
		{
			continue;
		}

		if ( id[ "group" ] == "specialty" )
		{
			pixbeginevent( "bot_give_random_item - specialty" );
			for ( i = 0; i < level.maxSpecialties; i++ )
			{
				if ( self.bot[ "specialty" + ( i + 1 ) ] == "perk_null" )
				{
					self.bot[ "specialty" + ( i + 1 ) ] = id[ "reference_full" ];
					break;
				}
			}

			perks = StrTok( id[ "reference" ], "|" );

			for ( i = 0; i < perks.size; i++ )
			{
				self SetPerk( perks[i] );
			}
			pixendevent();
		}
		else if ( id[ "group" ] == "weapon_grenade" )
		{
			// grenades will be given later
		}
		else
		{
			if ( id[ "attachment" ] != "" && RandomFloatRange( 0, 1 ) < ( rank / level.maxRank ) )
			{
				base_weapon = bot_give_random_attachment( id[ "reference" ], id[ "attachment" ] );
			}
			else
			{
				base_weapon = id[ "reference" ];
			}

			weapon = base_weapon + "_mp";

		/#
			if ( GetDvarint( "scr_botsHasPlayerWeapon" ) != 0 )
			{
				player = GetHostPlayer();
				weapon = player GetCurrentWeapon();
			}

			if ( GetDvar( "devgui_bot_weapon" ) != "" )
			{
				weapon = GetDvar( "devgui_bot_weapon" );
			}
		#/
			self GiveWeapon( weapon );
		}

		self.chosen_items[ self.chosen_items.size ] = id;

		pixendevent();
		return allocation;
	}

	pixendevent();
	return 0;
}

bot_give_random_attachment( weapon, attachments )
{
	/*
	cost = 500; // TODO: get this from data some day

	if ( cost > self.bot[ "cod_points" ] )
	{
		return ( weapon );
	}

	self.bot[ "cod_points" ] = self.bot[ "cod_points" ] - cost;
	*/
	
	attachments = StrTok( attachments, " " );
	ArrayRemoveValue( attachments, "dw" ); // dw weapon madness in the statstable

	if ( attachments.size <= 0 )
	{
		return ( weapon );
	}

	attachment = random( attachments );

	if ( attachment == "" )
	{
		return ( weapon );
	}

	return ( weapon + "_" + attachment );
}

bot_set_player_model()
{
	primaries = self GetWeaponsListPrimaries();

	if ( !IsDefined( primaries[0] ) )
	{
		primaries[0] = "";
	}

	self maps\mp\teams\_teams::set_player_model( self.pers[ "team" ], primaries[0] );
}

/#
bot_weapon_reference_from_weapon( weapon )
{
	toks = StrTok( weapon, "_" );
	reference = toks[0];

	for ( i = 1; i < toks.size - 1; i++ )
	{
		reference = reference + "_" + toks[i];
	}

	return reference;
}

bot_should_clone_loadout()
{
	return ( maps\mp\gametypes\_dev_class::dev_cac_player_valid() && level.dev_cac_player is_bot() );
}

bot_clone_loadout( player )
{
	// primary
	self.bot[ "primary" ] = player.bot[ "primary" ];
	self GiveWeapon( self.bot[ "primary" ] );
	self GiveStartAmmo( self.bot[ "primary" ] );
	self SetSpawnWeapon( self.bot[ "primary" ] );

	reference = bot_weapon_reference_from_weapon( self.bot[ "primary" ] );
	self.pers[ "primaryWeapon" ] = reference;

	// secondary
	self.bot[ "secondary" ] = player.bot[ "secondary" ];
	self GiveWeapon( self.bot[ "secondary" ] );
	self GiveStartAmmo( self.bot[ "secondary" ] );

	// grenades
	self.bot[ "primarygrenade" ] = player.bot[ "primarygrenade" ];
	self GiveWeapon( self.bot[ "primarygrenade" ] );
	self GiveStartAmmo( self.bot[ "primarygrenade" ] );
	self SwitchToOffhand( self.bot[ "primarygrenade" ] ); 

	self.bot[ "specialgrenade" ] = player.bot[ "specialgrenade" ];
	self GiveWeapon( self.bot[ "specialgrenade" ] );
	self GiveStartAmmo( self.bot[ "specialgrenade" ] );
	self SetOffhandSecondaryClass( self.bot[ "specialgrenade" ] );

	// armor
	self maps\mp\teams\_teams::set_player_model( self.pers[ "team" ], self.bot[ "primary" ] );
}
#/