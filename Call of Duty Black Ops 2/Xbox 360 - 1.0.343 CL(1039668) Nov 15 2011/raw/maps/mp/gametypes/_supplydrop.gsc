#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_airsupport;

init()
{
	level thread onPlayerConnect();
	
	level.crateModelFriendly = "mp_supplydrop_ally";
	level.crateModelEnemy = "mp_supplydrop_axis";
	level.crateModelBoobyTrapped = "mp_supplydrop_boobytrapped";
	level.supplyDropHelicopterFriendly = "vehicle_ch46e_mp_light";
	level.supplyDropHelicopterEnemy = "vehicle_ch46e_mp_dark";
	level.suppyDropHelicopterVehicleInfo = "heli_supplydrop_mp";
	
	level.crateOwnerUseTime = 500;
	level.crateNonOwnerUseTime = 3000;
	level.crate_headicon_offset = (0, 0, 15);

	PreCacheModel( level.crateModelFriendly );
	PreCacheModel( level.crateModelEnemy );
	PreCacheModel( level.crateModelBoobyTrapped );
	PreCacheModel( level.supplyDropHelicopterFriendly );
	PreCacheModel( level.supplyDropHelicopterEnemy );
	PreCacheVehicle( level.suppyDropHelicopterVehicleInfo );
	PreCacheShader( "compass_supply_drop_black" );
	PreCacheShader( "compass_supply_drop_green" );
	PreCacheShader( "compass_supply_drop_red" );
	PreCacheShader( "waypoint_recon_artillery_strike" );
	PreCacheShader( "hud_ks_minigun" );
	PreCacheShader( "hud_ks_minigun_drop" );
	PreCacheShader( "hud_ks_m202" );
	PreCacheShader( "hud_ks_m202_drop" );
	PreCacheShader( "hud_ammo_refill" );
	PreCacheShader( "hud_ammo_refill_drop" );
	PreCacheString( &"KILLSTREAK_CAPTURING_CRATE" );
	
	// TODO: this is a placeholder head icon for when a supply drop is hacked and a booby trap is made
	PreCacheShader("headicon_dead");

	level._supply_drop_smoke_fx = LoadFX( "env/smoke/fx_smoke_supply_drop_blue_mp" );
	level._supply_drop_explosion_fx = LoadFX( "explosions/fx_grenadeexp_default" );
	LoadFX ("vehicle/props/fx_seaknight_main_blade_full");
	LoadFX ("vehicle/props/fx_seaknight_rear_blade_full");

	maps\mp\killstreaks\_killstreaks::registerKillstreak("supply_drop_mp", "supplydrop_mp", "killstreak_supply_drop", "supply_drop_used", ::useKillstreakSupplyDrop, undefined, true );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("supply_drop_mp", &"KILLSTREAK_EARNED_SUPPLY_DROP", &"KILLSTREAK_AIRSPACE_FULL");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("supply_drop_mp", "mpl_killstreak_supply", "kls_supply_used", "","kls_supply_enemy", "", "kls_supply_ready");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("supply_drop_mp", "scr_givesupplydrop");
	//maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon("supply_drop_mp", "minigun_mp" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon("supply_drop_mp", "mp40_blinged_mp" );
//	maps\mp\killstreaks\_killstreaks::setRemoveWeaponWhenUsed("supply_drop_mp", false);hud_ks_m202
	maps\mp\killstreaks\_killstreaks::allowKillstreakAssists("supply_drop_mp", true);

	level.crateTypes = [];

	//registerCrateType( "minigun_drop_mp", "killstreak", "minigun_mp", 1, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_CRATE_GAMBLER", "MEDAL_SHARE_PACKAGE_MINIGUN", ::giveCrateKillstreak );
	registerCrateType( "m220_tow_drop_mp", "killstreak", "m220_tow_mp", 1, &"KILLSTREAK_M220_TOW_CRATE", undefined, "MEDAL_SHARE_PACKAGE_TOW", ::giveCrateKillstreak );
	
	// percentage of drop explanation:
	//		add all of the numbers up: 15 + 2 + 3 + etc. = 80 for example
	//		now if you want to know the percentage of the minigun_mp drop, you'd do (minigun_mp number / total) or 2/80 = 2.5% chance of dropping
	// right now this is at a perfect 100, so the percentages are easy to understand
	registerCrateType( "supplydrop_mp", "ammo", "ammo", 20, &"KILLSTREAK_AMMO_CRATE", &"PLATFORM_AMMO_CRATE_GAMBLER", "MEDAL_SHARE_PACKAGE_AMMO", ::giveCrateAmmo );
	registerCrateType( "supplydrop_mp", "killstreak", "radar_mp", 15, &"KILLSTREAK_RADAR_CRATE", &"PLATFORM_RADAR_GAMBLER", "MEDAL_SHARE_PACKAGE_RECON", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "counteruav_mp", 15, &"KILLSTREAK_COUNTERU2_CRATE", &"PLATFORM_COUNTERU2_GAMBLER", "MEDAL_SHARE_PACKAGE_COUNTERU2", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "rcbomb_mp", 9, &"KILLSTREAK_RCBOMB_CRATE", &"PLATFORM_RCBOMB_GAMBLER", "MEDAL_SHARE_PACKAGE_RCBOMB", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "m220_tow_mp", 5, &"KILLSTREAK_M220_TOW_CRATE", &"PLATFORM_M220_TOW_GAMBLER", "MEDAL_SHARE_PACKAGE_TOW", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "mortar_mp", 5, &"KILLSTREAK_MORTAR_CRATE", &"PLATFORM_MORTAR_GAMBLER", "MEDAL_SHARE_PACKAGE_MORTAR", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "autoturret_mp", 5, &"KILLSTREAK_AUTO_TURRET_CRATE", &"PLATFORM_AUTO_TURRET_GAMBLER", "MEDAL_SHARE_PACKAGE_AUTO_TURRET", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "auto_tow_mp", 5, &"KILLSTREAK_TOW_TURRET_CRATE", &"PLATFORM_TOW_TURRET_GAMBLER", "MEDAL_SHARE_PACKAGE_TOW_TURRET", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "airstrike_mp", 3, &"KILLSTREAK_AIRSTRIKE_CRATE", &"PLATFORM_AIRSTRIKE_GAMBLER", "MEDAL_SHARE_PACKAGE_AIRSTRIKE", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "m202_flash_mp", 3, &"KILLSTREAK_M202_FLASH_CRATE", &"PLATFORM_M202_FLASH_GAMBLER", "MEDAL_SHARE_PACKAGE_FLASH", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "napalm_mp", 3, &"KILLSTREAK_NAPALM_CRATE", &"PLATFORM_NAPALM_GAMBLER", "MEDAL_SHARE_PACKAGE_NAPALM", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "radardirection_mp", 3, &"KILLSTREAK_SATELLITE_CRATE", &"PLATFORM_SATELLITE_GAMBLER", "MEDAL_SHARE_PACKAGE_SATELLITE", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "helicopter_comlink_mp", 3, &"KILLSTREAK_HELICOPTER_CRATE", &"PLATFORM_HELICOPTER_GAMBLER", "MEDAL_SHARE_PACKAGE_HELICOPTER_COMLINK", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "minigun_mp", 2, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_GAMBLER", "MEDAL_SHARE_PACKAGE_MINIGUN", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "helicopter_gunner_mp", 2, &"KILLSTREAK_HELICOPTER_GUNNER_CRATE", &"PLATFORM_HELICOPTER_GUNNER_GAMBLER", "MEDAL_SHARE_PACKAGE_HELICOPTER_GUNNER", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "dogs_mp", 1, &"KILLSTREAK_DOGS_CRATE", &"PLATFORM_DOGS_GAMBLER", "MEDAL_SHARE_PACKAGE_DOGS", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_mp", "killstreak", "helicopter_player_firstperson_mp", 1, &"KILLSTREAK_HELICOPTER_PLAYER_CRATE", &"PLATFORM_HELICOPTER_PLAYER_GAMBLER", "MEDAL_SHARE_PACKAGE_HELICOPTER_PLAYER", ::giveCrateKillstreak );

	// for the gambler perk, have its own crate types with a greater chance to get good stuff
	// right now this is at a perfect 100, so the percentages are easy to understand
	registerCrateType( "gambler_mp", "ammo", "ammo", 9, &"KILLSTREAK_AMMO_CRATE", undefined, "MEDAL_SHARE_PACKAGE_AMMO", ::giveCrateAmmo );
	registerCrateType( "gambler_mp", "killstreak", "radar_mp", 9, &"KILLSTREAK_RADAR_CRATE", undefined, "MEDAL_SHARE_PACKAGE_RECON", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "counteruav_mp", 9, &"KILLSTREAK_COUNTERU2_CRATE", undefined, "MEDAL_SHARE_PACKAGE_COUNTERU2", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "rcbomb_mp", 9, &"KILLSTREAK_RCBOMB_CRATE", undefined, "MEDAL_SHARE_PACKAGE_RCBOMB", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "m220_tow_mp", 9, &"KILLSTREAK_M220_TOW_CRATE", undefined, "MEDAL_SHARE_PACKAGE_TOW", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "mortar_mp", 9, &"KILLSTREAK_MORTAR_CRATE", undefined, "MEDAL_SHARE_PACKAGE_MORTAR", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "autoturret_mp", 9, &"KILLSTREAK_AUTO_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_AUTO_TURRET", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "auto_tow_mp", 9, &"KILLSTREAK_TOW_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_TOW_TURRET", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "airstrike_mp", 4, &"KILLSTREAK_AIRSTRIKE_CRATE", undefined, "MEDAL_SHARE_PACKAGE_AIRSTRIKE", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "m202_flash_mp", 4, &"KILLSTREAK_M202_FLASH_CRATE", undefined, "MEDAL_SHARE_PACKAGE_FLASH", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "napalm_mp", 4, &"KILLSTREAK_NAPALM_CRATE", undefined, "MEDAL_SHARE_PACKAGE_NAPALM", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "radardirection_mp", 4, &"KILLSTREAK_SATELLITE_CRATE", undefined, "MEDAL_SHARE_PACKAGE_SATELLITE", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "helicopter_comlink_mp", 4, &"KILLSTREAK_HELICOPTER_CRATE", undefined, "MEDAL_SHARE_PACKAGE_HELICOPTER_COMLINK", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "minigun_mp", 3, &"KILLSTREAK_MINIGUN_CRATE", undefined, "MEDAL_SHARE_PACKAGE_MINIGUN", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "helicopter_gunner_mp", 3, &"KILLSTREAK_HELICOPTER_GUNNER_CRATE", undefined, "MEDAL_SHARE_PACKAGE_HELICOPTER_GUNNER", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "dogs_mp", 1, &"KILLSTREAK_DOGS_CRATE", undefined, "MEDAL_SHARE_PACKAGE_DOGS", ::giveCrateKillstreak );
	registerCrateType( "gambler_mp", "killstreak", "helicopter_player_firstperson_mp", 1, &"KILLSTREAK_HELICOPTER_PLAYER_CRATE", undefined, "MEDAL_SHARE_PACKAGE_HELICOPTER_PLAYER", ::giveCrateKillstreak );

	level.crateCategoryWeights = [];
	crateCategoryKeys = getarraykeys( level.crateTypes );
	for ( crateCategory = 0; crateCategory < crateCategoryKeys.size; crateCategory++ )
	{
		categoryKey = crateCategoryKeys[crateCategory];
		
		level.crateCategoryWeights[categoryKey] = 0;
		
		crateTypeKeys = getarraykeys( level.crateTypes[categoryKey] );
		for ( crateType = 0; crateType < crateTypeKeys.size; crateType++ )
		{
			typeKey = crateTypeKeys[crateType];
			level.crateCategoryWeights[categoryKey] += level.crateTypes[categoryKey][typeKey].weight;
			level.crateTypes[categoryKey][typeKey].weight = level.crateCategoryWeights[categoryKey];
		}
	}

	/#
		level thread supply_drop_dev_gui();
		getDvarIntDefault( "scr_crate_notimeout", 0 ); 
	#/
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
	}
}

registerCrateType( category, type, name, weight, hint, hint_gambler, shareStat, giveFunction )
{
	if ( !IsDefined(level.crateTypes[category]) )
	{
		level.crateTypes[category] = [];
	}
	
	crateType = SpawnStruct();
	crateType.type = type;
	crateType.name = name;
	crateType.weight = weight;
	crateType.hint = hint;
	crateType.hint_gambler = hint_gambler;
	crateType.shareStat = shareStat;
	crateType.giveFunction = giveFunction;
	
	level.crateTypes[category][name] = crateType;
	
	game["strings"][name + "_hint"] = hint;
}

getRandomCrateType( category, gambler_crate_name )
{
	Assert( IsDefined(level.crateTypes) );
	Assert( IsDefined(level.crateTypes[category]) );
	Assert( IsDefined(level.crateCategoryWeights[category]) );

	typeKey = undefined;	
	randomWeight = RandomInt( level.crateCategoryWeights[category] );
	find_another = false;

	crateTypeKeys = getarraykeys( level.crateTypes[category] );
	for ( crateType = 0; crateType < crateTypeKeys.size; crateType++ )
	{
		typeKey = crateTypeKeys[crateType];
		
		if ( level.crateTypes[category][typeKey].weight > randomWeight )
		{
			// need to see if certain weapons around and only allow 1 for now
			switch( level.crateTypes[category][typeKey].name )
			{
			case "minigun_mp":
				find_another = validate_crate_type( "minigun_mp", "minigun_mp", "minigun_mp" );
				break;
			case "m202_flash_mp":
				find_another = validate_crate_type( "m202_flash_mp", "m202_flash_mp", "m202_flash_mp" );
				break;
			case "m220_tow_drop_mp":
				find_another = validate_crate_type( "m220_tow_drop_mp", "m220_tow_mp", "m220_tow_drop_mp" );
				break;
			case "mp40_drop_mp":
				find_another = validate_crate_type( "mp40_drop_mp", "mp40_blinged_mp", "mp40_drop_mp" );
				break;

			default:
				break;
			}

			// if we have the gambler perk then make sure we aren't getting the same thing again
			if( IsDefined( gambler_crate_name ) && level.crateTypes[category][typeKey].name == gambler_crate_name )
			{
				find_another = true;
			}

			// go find another crate
			if( find_another )
			{
				if( crateType < crateTypeKeys.size - 1 )
				{
					crateType++;
				}
				else if( crateType > 0 )
				{
					crateType--;
				}
				typeKey = crateTypeKeys[crateType];
			}

			break;
		}
	}

	/#
	if( IsDefined(level.dev_gui_supply_drop) && level.dev_gui_supply_drop != "random" )
	{
		typeKey = level.dev_gui_supply_drop;
	}
	#/

	return level.crateTypes[category][typeKey];
}

validate_crate_type( killstreak_name, weapon_name, crate_type_name )
{
	// need to see if certain weapons around and only allow 1 for now
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( IsAlive( players[i] ) )
		{
			// check the killstreaks
			for( j = 0; j < players[i].pers["killstreaks"].size; j++)
			{
				if( players[i].pers["killstreaks"][j] == killstreak_name )
				{
					return true;
				}
			}

			// check the primary weapons
			primary_weapons = players[i] GetWeaponsListPrimaries();
			for( j = 0; j < primary_weapons.size; j++ )
			{
				if( primary_weapons[j] == weapon_name )
				{
					return true;
				}
			}

			// check to see if one is on the ground
			ents = GetEntArray( "weapon_" + weapon_name, "classname" );
			if( IsDefined( ents ) && ents.size > 0 )
			{
				return true;
			}

			// check to see if another crate already has one waiting
			crate_ents = GetEntArray( "care_package", "script_noteworthy" );
			for( j = 0; j < crate_ents.size; j++ )
			{
				if( !IsDefined( crate_ents[j].crateType ) )
					continue;

				if( IsDefined( crate_ents[j].crateType.name ) ) 
				{
					if( crate_ents[j].crateType.name == crate_type_name )
					{
						return true;
					}
				}
			}
		}
	}

	return false;
}

giveCrateItem( crate )
{
	if ( !IsAlive(self) ) 
		return;
		
	[[crate.crateType.giveFunction]](crate.crateType.name);
}

giveCrateKillstreak( killstreak )
{
	self maps\mp\killstreaks\_killstreaks::giveKillstreak( killstreak );
}

giveCrateWeapon( weapon )
{
	currentWeapon = self GetCurrentWeapon();

	if ( currentWeapon == weapon || self HasWeapon( weapon ) ) 
	{
		self GiveMaxAmmo( weapon );
		return true;
	}
	
	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( isSupplyDropWeapon( currentWeapon ) || isdefined( level.grenade_array[currentWeapon] )|| isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon(weapon);
		self switchToWeapon(weapon);
		return true;
	}
	
	self AddWeaponStat( weapon, "used", 1 );

	switch( weapon )
	{
	case "minigun_mp":
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_MINIGUN_INBOUND", self );
		level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );
		break;
	case "m202_flash_mp":
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_M202_FLASH_INBOUND", self );
		level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );
		break;
	case "m220_tow_mp":
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_M220_TOW_INBOUND", self );
		level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );
		break;
	case "mp40_blinged_mp":
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_MP40_INBOUND", self );
		level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );
		break;

	default:
		break;
	}
	
	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self switchToWeapon(weapon);

	return true;
}

giveCrateAmmo( ammo )
{
  weaponsList = self GetWeaponsList();
  for( idx = 0; idx < weaponsList.size; idx++ )
  {
		weapon = weaponsList[idx];

		switch( weapon )
		{
		case "minigun_mp":
		case "m202_flash_mp":
		case "m220_tow_mp":
		case "mp40_blinged_mp":
			continue;

		case "frag_grenade_mp":
		case "sticky_grenade_mp":
		case "hatchet_mp":
		case "flash_grenade_mp":
		case "concussion_grenade_mp":
		case "tabun_gas_mp":
		case "nightingale_mp":
		case "willy_pete_mp":
			stock = self GetWeaponAmmoStock( weapon );
			maxAmmo = WeaponMaxAmmo( weapon );

			if( !( self HasPerk( "specialty_twogrenades" ) ) )
			{
				maxAmmo = WeaponStartAmmo( weapon );
			}

			if ( stock < maxAmmo )
			{
				self SetWeaponAmmoStock( weapon, maxAmmo );
			}
			break;

		default:
			self GiveMaxAmmo( weapon );
			break;
		}
  }
}

useSupplyDropMarker()
{
	self endon ( "death" );

	self thread supplyDropWatcher();

	supplyDropWeapon = undefined;
	currentWeapon = self GetCurrentWeapon();
	prevWeapon = currentWeapon;
	if ( isSupplyDropWeapon( currentWeapon ) )
	{
		supplyDropWeapon = currentWeapon;
	}
	
	while ( isSupplyDropWeapon( currentWeapon ) && prevWeapon == currentWeapon )
	{
		prevWeapon = currentWeapon;
		self waittill( "weapon_change", currentWeapon );
	
		if ( isSupplyDropWeapon( currentWeapon ) )
		{
			supplyDropWeapon = currentWeapon;
		}
	}
	
	// for some reason we never had the supply drop weapon
	if ( !IsDefined( supplyDropWeapon ) )
		return false;
		
	// if we have the weapon but no ammo, something went wrong. take the weapon.
	if ( self HasWeapon( supplyDropWeapon ) && !self GetAmmoCount( supplyDropWeapon ) )
		self TakeWeapon( supplyDropWeapon );
		
	// if we no longer are have the supply drop weapon in our inventory then 
	// it must have been successful
	if ( self HasWeapon( supplyDropWeapon ) || self GetAmmoCount( supplyDropWeapon ) )
		return false;
		
	return true;
}

isSupplyDropGrenadeAllowed( hardpointType, killstreakWeapon )
{
	if( !isDefined(killstreakWeapon) )
		killstreakWeapon = hardpointType;

	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		if ( isDefined( self.lastStand ) && self.lastStand && isDefined( self.laststandpistol ) && self hasWeapon( self.laststandpistol ) )
			self switchToWeapon( self.laststandpistol );
		else if( isDefined(self.lastNonKillstreakWeapon) && self.lastNonKillstreakWeapon != killstreakWeapon && self.lastNonKillstreakWeapon != "none" )
			self SwitchToWeapon( self.lastNonKillstreakWeapon );
		else if( isDefined(self.lastDroppableWeapon) && self.lastDroppableWeapon != killstreakWeapon && self.lastDroppableWeapon != "none" )
			self SwitchToWeapon( self.lastDroppableWeapon );
	
		return false;
	}

	return true;
}
useKillstreakSupplyDrop(hardpointType)
{
	
	if( self isSupplyDropGrenadeAllowed(hardpointType, "supplydrop_mp" ) == false )
		return false;


	self thread refCountDecChopperOnDisconnect( self.team );
	
//	self thread abortSupplyDropMarkerWaiter( "disconnect" );
//	self thread abortSupplyDropMarkerWaiter( "spawned_player" );
//	self thread playerChangeWeaponWaiter();
	
	result = self useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !IsDefined(result) || !result )
	{
		return false;
	}

	return result;
}

use_killstreak_death_machine(hardpointType)
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	weapon = "minigun_mp";
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( isSupplyDropWeapon( currentWeapon ) || isdefined( level.grenade_array[currentWeapon] )|| isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon(weapon);
		self SwitchToWeapon(weapon);

		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup(weapon, true);
		return true;
	}

	level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_MINIGUN_INBOUND", self );
	level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);

	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup(weapon, true);
	return true;
}

use_killstreak_grim_reaper(hardpointType)
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	weapon = "m202_flash_mp";
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( isSupplyDropWeapon( currentWeapon ) || isdefined( level.grenade_array[currentWeapon] )|| isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon(weapon);
		self SwitchToWeapon(weapon);

		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup(weapon, true);
		return true;
	}

	level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_M202_FLASH_INBOUND", self );
	level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup(weapon, true);
	return true;
}

use_killstreak_tv_guided_missile(hardpointType)
{
	if ( maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		self iPrintLnBold( level.killstreaks[hardpointType].notAvailableText );

		return false;
	}

	weapon = "m220_tow_mp";
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( isSupplyDropWeapon( currentWeapon ) || isdefined( level.grenade_array[currentWeapon] )|| isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon(weapon);
		self SwitchToWeapon(weapon);

		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup(weapon, true);
		return true;
	}

	level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_M220_TOW_INBOUND", self );
	level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup(weapon, true);
	return true;
}

use_killstreak_mp40( hardpointType )
{
	if ( maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		self iPrintLnBold( level.killstreaks[hardpointType].notAvailableText );

		return false;
	}

	weapon = "mp40_blinged_mp";
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( isSupplyDropWeapon( currentWeapon ) || isdefined( level.grenade_array[currentWeapon] )|| isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon(weapon);
		self SwitchToWeapon(weapon);
		
		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup(weapon, true);
		return true;
	}

	level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_MP40_INBOUND", self );
	level maps\mp\gametypes\_weapons::addLimitedWeapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup(weapon, true);
	return true;
}

supplyDropWatcher( supplyDropWeapon )
{
	self notify("supplyDropWatcher");
	
	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "weapon_change" );

	team = self.team;
	
	self thread checkWeaponChange( team );

	self thread supplyDropGrenadePullWatcher();
	
	if ( self maps\mp\killstreaks\_killstreakrules::killstreakStart( "supply_drop_mp", team ) == false )
		return;
	
	self waittill( "grenade_fire", weapon, weapname );
		
	if ( isSupplyDropWeapon( weapname ) )
	{
		self thread doSupplyDrop( weapon, weapname, self );
		weapon thread do_supply_drop_detonation( weapname );
		weapon thread supplyDropGrenadeTimeout( team );
	}
	else
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "supply_drop_mp", team );
	}
}

supplyDropGrenadeTimeout( team )
{
	self endon( "death" );
	self endon("stationary");
	
	GRENADE_LIFETIME = 10;

	//If the grenade hasn't stopped moving after a certain time delete it.
	wait( GRENADE_LIFETIME );
	
	if( !isDefined( self ) )
		return;

	self notify( "grenade_timeout" );
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "supply_drop_mp", team );
	self delete();
}

checkWeaponChange( team )
{
	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "grenade_fire" );
	
	self waittill( "weapon_change" );
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "supply_drop_mp", team );	
}

supplyDropGrenadePullWatcher()
{
	self endon( "disconnect" );
	self endon( "weapon_change" );

	self waittill ( "grenade_pullback", weapon );

	self _disableUsability();

	self thread watchForGrenadePutDown();
	
	self waittill ( "death" );

	if( isSupplyDropWeapon(weapon) )
	{
		killstreak = maps\mp\killstreaks\_killstreaks::getKillstreakForWeapon( weapon );
		maps\mp\killstreaks\_killstreaks::removeUsedKillstreak( killstreak );
	}
	else
	{
		maps\mp\killstreaks\_killstreaks::removeUsedKillstreak("supply_drop_mp");
	}
}

watchForGrenadePutDown()
{
	self notify( "watchForGrenadePutDown" );
	self endon( "watchForGrenadePutDown" );
	self endon( "death" );
	self endon( "disconnect" );

	self waittill_any( "grenade_fire", "weapon_change" );
	self _enableUsability();
}

abortSupplyDropMarkerWaiter( waitTillString )
{
	self endon( "supply_drop_marker_done" );
	
	self waittill( waitTillString );

	self notify( "supply_drop_marker_done" );
}

playerChangeWeaponWaiter()
{
	self endon( "supply_drop_marker_done" );

	self endon( "disconnect" );
	self endon( "spawned_player" );

	currentWeapon = self GetCurrentWeapon();
	
	while ( isSupplyDropWeapon( currentWeapon ) )
	{
		self waittill( "weapon_change", currentWeapon );
	}

	// if the killstreak ended because of a weapon change
	// give a frame to allow the weapon_change to trigger in other scripts
	waittillframeend;

	self notify( "supply_drop_marker_done" );
}

isSupplyDropWeapon( weapon )
{
	if( weapon == "supplystation_mp" || 
		weapon == "supplydrop_mp" || 
		weapon == "turret_drop_mp" || 
		/*weapon == "minigun_drop_mp" ||*/
		weapon == "tow_turret_drop_mp" ||
		weapon == "m220_tow_drop_mp" )
	{
		return true;
	}
	
	return false;
}

getIconForCrate()
{
	icon = undefined;
	
	switch ( self.crateType.type )
	{
		case "killstreak":
			{
				killstreak = maps\mp\killstreaks\_killstreaks::GetKillStreakMenuName( self.crateType.name );
				icon = level.killStreakIcons[killstreak];
			}
			break;
		
		case "weapon":
			{
				switch( self.crateType.name )
				{
				case "minigun_mp":
					icon = "hud_ks_minigun";
					break;
				case "m202_flash_mp":
					icon = "hud_ks_m202";
					break;
				case "m220_tow_mp":
					icon = "hud_ks_tv_guided_missile";
					break;
				case "mp40_drop_mp":
					icon = "hud_mp40";
						break;
				default:
					icon = "waypoint_recon_artillery_strike";
					break;
				}
			}
			break;
		
		case "ammo":
			{
				icon = "hud_ammo_refill";
			}
			break;

		default:
			break;
	}
	
	return icon + "_drop";
}

crateActivate()
{
	self MakeUsable();
	self SetCursorHint("HINT_NOICON");

	self setHintString( self.crateType.hint );	
	if ( isdefined( self.crateType.hint_gambler ) )
	{
		self setHintStringForPerk( "specialty_gambler", self.crateType.hint_gambler );
	}

	crateObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( crateObjID, "invisible", self.origin );
	objective_icon( crateObjID, "compass_supply_drop_green" );
	objective_state( crateObjID, "active" );
	self.friendlyObjID = crateObjID;
	
	icon = self getIconForCrate();
	
	if ( level.teambased )
	{
		objective_team( crateObjID, self.team );

		crateObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
		objective_add( crateObjID, "invisible", self.origin );
		if( IsDefined( self.hacker ) )
		{
			objective_icon( crateObjID, "compass_supply_drop_black" );
		}
		else
		{
			objective_icon( crateObjID, "compass_supply_drop_red" );
		}
		objective_team( crateObjID, level.otherTeam[self.team] );
		objective_state( crateObjID, "active" );
		self.enemyObjID = crateObjID;	
	}
	else
	{
		Objective_SetInvisibleToAll( crateObjID );
		Objective_SetVisibleToPlayer( crateObjID, self.owner );
		
		crateObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
		objective_add( crateObjID, "invisible", self.origin );
		objective_icon( crateObjID, "compass_supply_drop_red" );
		objective_state( crateObjID, "active" );
		Objective_SetInvisibleToPlayer( crateObjID, self.owner );
		self.enemyObjID = crateObjID;
		
		if( IsDefined( self.hacker ) )
		{
			Objective_SetInvisibleToPlayer( crateObjID, self.hacker );
			
			crateObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
			objective_add( crateObjID, "invisible", self.origin );
			objective_icon( crateObjID, "compass_supply_drop_black" );
			objective_state( crateObjID, "active" );
			Objective_SetInvisibleToAll( crateObjID );
			Objective_SetVisibleToPlayer( crateObjID, self.hacker );
			self.hackerObjID = crateObjID;
		}
	}
	
	self thread maps\mp\_entityheadIcons::setEntityHeadIcon( self.team, self, level.crate_headicon_offset, icon, true );	
	
	if ( IsDefined( self.owner ) && self.owner is_bot() )
	{
		self.owner notify( "bot_crate_landed", self );
	}
}

crateDeactivate( )
{
	self makeunusable();
	//self SetCursorHint("HINT_NOICON");
	//self setHintString( self.crateType.hint );

	if ( IsDefined(self.friendlyObjID) )
	{
		Objective_Delete( self.friendlyObjID );
		maps\mp\gametypes\_gameobjects::releaseObjID(self.friendlyObjID);
		self.friendlyObjID = undefined;
	}
	
	if ( IsDefined(self.enemyObjID) )
	{
		Objective_Delete( self.enemyObjID );
		maps\mp\gametypes\_gameobjects::releaseObjID(self.enemyObjID);
		self.enemyObjID = undefined;
	}
	
	if ( IsDefined(self.hackerObjID) )
	{
		Objective_Delete( self.hackerObjID );
		maps\mp\gametypes\_gameobjects::releaseObjID(self.hackerObjID);
		self.hackerObjID = undefined;
	}
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
}


ownerTeamChangeWatcher()
{
	self endon("death");

	if ( !level.teamBased || !isdefined( self.owner ) )
		return;

	self.owner waittill("joined_team");

	self.owner = undefined;
}

dropEverythingTouchingCrate( origin )
{
	// a sphere with a radius of 44 covers the current supply drop exactly
	dropAllToGround( origin, 70, 70 );
}

dropAllToGroundAfterCrateDelete( crate, crate_origin )
{
	crate waittill("death");
	wait( 0.1 );
	
	crate dropEverythingTouchingCrate( crate_origin );
}

dropCratesToGround( origin, radius )
{
	crate_ents = GetEntArray( "care_package", "script_noteworthy" );
	radius_sq = radius * radius;
	for ( i = 0 ; i < crate_ents.size ; i++ )
	{
		if ( DistanceSquared( origin, crate_ents[i].origin ) < radius_sq )
		{
			crate_ents[i] thread dropCrateToGround();
		}
	}
}

dropCrateToGround()
{
	self endon("death");
	
	if ( IsDefined( self.droppingToGround ) )
		return;
		
	self.droppingToGround = true;
	
	// we need to recursively have this crate trigger a drop to ground as well
	dropEverythingTouchingCrate( self.origin );
	
	self crateDeactivate();
	self thread crateDropToGroundKill();
	self crateRedoPhysics();
	self crateActivate();
		
	self.droppingToGround = undefined;
}

crateSpawn( weaponname, owner, team, drop_origin, drop_angle )
{
	crate = spawn( "script_model", drop_origin, 1 );
	crate.angles = drop_angle;
	crate.team = team;
	crate SetTeam(team);
	crate SetOwner( owner );
	crate.script_noteworthy = "care_package";

	if ( !level.teamBased || ( isdefined(owner) && owner.team == team ) )
	crate.owner = owner;

	crate thread ownerTeamChangeWatcher();
	
	crate setModel( level.crateModelFriendly );
	crate setEnemyModel( level.crateModelEnemy );
	switch( weaponName )
	{
	case "turret_drop_mp":
		crate.crateType = level.crateTypes[ weaponname ][ "autoturret_mp" ];
		break;
	case "tow_turret_drop_mp":
		crate.crateType = level.crateTypes[ weaponname ][ "auto_tow_mp" ];
		break;
	case "minigun_drop_mp":
		crate.crateType = level.crateTypes[ weaponname ][ "minigun_mp" ];
		break;
	case "m220_tow_drop_mp":
		crate.crateType = level.crateTypes[ weaponname ][ "m220_tow_mp" ];
		break;
	
	default:
		crate.crateType = getRandomCrateType( weaponname );
		break;
	}

	return crate;
}

crateDelete( drop_all_to_ground )
{
	if( !IsDefined( drop_all_to_ground ) )
	{
		drop_all_to_ground = true;
	}
	
	if ( IsDefined(self.friendlyObjID) )
	{
		Objective_Delete( self.friendlyObjID );
		maps\mp\gametypes\_gameobjects::releaseObjID(self.friendlyObjID);
		self.friendlyObjID = undefined;
	}
	
	if ( IsDefined(self.enemyObjID) )
	{
		Objective_Delete( self.enemyObjID );
		maps\mp\gametypes\_gameobjects::releaseObjID(self.enemyObjID);
		self.enemyObjID = undefined;
	}
	
	if ( IsDefined(self.hackerObjID) )
	{
		Objective_Delete( self.hackerObjID );
		maps\mp\gametypes\_gameobjects::releaseObjID(self.hackerObjID);
		self.hackerObjID = undefined;
	}
	
	if( drop_all_to_ground )
	{
		level thread dropAllToGroundAfterCrateDelete( self, self.origin );
	}
	
	if ( isdefined ( self.killcament ) )
	{
		self.killcament thread deleteAfterTime( 5 );	
	}

	self Delete();
}

timeoutCrateWaiter()
{
	self endon("death");
	self endon("stationary");
	
	// if the crate has not stopped moving for some time just get rid of it
	wait( 20 );
	
	self crateDelete();
}

cratePhysics()
{
	forcePointVariance = 200.0;
	vertVelocityMin = -100.0;
	vertVelocityMax = 100.0;
	
	forcePointX = RandomFloatRange( 0-forcePointVariance, forcePointVariance );
	forcePointY = RandomFloatRange( 0-forcePointVariance, forcePointVariance );
	forcePoint = ( forcePointX, forcePointY, 0 );
	forcePoint += self.origin;
	
	initialVelocityZ = RandomFloatRange( vertVelocityMin, vertVelocityMax );
	initialVelocity = ( 0, 0, initialVelocityZ );

	self PhysicsLaunch(forcePoint,initialVelocity);
	
	self thread timeoutCrateWaiter();

	self thread update_crate_velocity();
	self thread play_impact_sound();

	self waittill("stationary");
}

play_impact_sound() //self == crate
{
	self endon( "entityshutdown" );
	self endon( "stationary" );
	wait( 0.5 ); //this wait is to delay the fall speed check

	while( abs( self.velocity[2] ) > 5 ) //this is not 0 since the crate will sometimes rock a bit before it stops moving
	{
		//PrintLn( "snd_tst: self.velocity[2]: " + self.velocity[2] );
		wait( 0.1 );
	}

	//PrintLn( "snd_tst: playing crate impact sound" );
	self PlaySound( "phy_impact_supply" );
}

update_crate_velocity() //self == crate
{
	self endon( "entityshutdown" );
	self endon( "stationary" );

	self.velocity = ( 0,0,0 );
	self.old_origin = self.origin;

	while( IsDefined( self ) )
	{
		self.velocity = ( self.origin - self.old_origin );
		self.old_origin = self.origin;

		wait( 0.01 );
	}
}


crateRedoPhysics()
{
	forcePoint = self.origin;
	
	initialVelocity = ( 0, 0, 0 );

	self PhysicsLaunch(forcePoint,initialVelocity);
	
	self thread timeoutCrateWaiter();
	self waittill("stationary");
}

do_supply_drop_detonation( weapname ) // self == weapon
{
	self notify("supplyDropWatcher");

	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "death" );
	self endon ( "grenade_timeout" );

	// control the explosion events to circumvent the code cleanup
	self waitTillNotMoving();
	self.angles = ( 0, self.angles[1], 90 );
	fuse_time = GetWeaponFuseTime( weapname ) / 1000; // fuse time comes back in milliseconds
	wait( fuse_time );
	thread playSmokeSound( self.origin, 6, level.sound_smoke_start, level.sound_smoke_stop, level.sound_smoke_loop );
	PlayFXOnTag( level._supply_drop_smoke_fx, self, "tag_fx" );
	proj_explosion_sound = GetWeaponProjExplosionSound( weapname );
	play_sound_in_space( proj_explosion_sound, self.origin );

	// need to clean up the canisters
	wait( 3 );
	self delete();
}

doSupplyDrop( weapon, weaponname, owner )
{
	weapon endon ( "explode" );
	weapon endon ( "grenade_timeout" );
	self endon( "disconnect" );
	team = owner.team;
	weapon thread watchExplode( weaponname, owner );
	weapon waitTillNotMoving();
	weapon notify( "stoppedMoving" );
	
	self thread heliDeliverCrate( weapon.origin, weaponname, owner, team );
}

watchExplode( weaponname, owner )
{
	self endon( "stoppedMoving" );
	team = owner.team;
	self waittill( "explode", position ); 
	
	owner thread heliDeliverCrate( position, weaponname, owner, team );
}

crateTimeOutThreader()
{
/#
	if ( getDvarIntDefault( "scr_crate_notimeout", 0 ) ) 
		return;
#/
	self thread crateTimeOut(90);
}

dropCrate( origin, angle, weaponname, owner, team, killcamEnt )
{
	crate = crateSpawn( weaponname, owner, team, origin, angle );
	killCamEnt unlink();
	killCamEnt linkto( crate );
	crate.killcamEnt = killcamEnt;
	killCamEnt thread deleteAfterTime( 15 );
	crate endon("death");
	
	crate thread crateKill();

	crate cratePhysics();
	crate crateActivate();

	crate thread crateUseThink();
	crate thread crateUseThinkOwner();
	
	if( isdefined( crate.crateType.hint_gambler )) 
	{
		crate thread crateGamblerThink();
	}
	
	
	crate crateTimeOutThreader();
	
	while ( 1 )
	{
		crate waittill("captured", player);

		player giveCrateItem( crate );
		
		// added functionality to specialty_disarmexplosive to create a booby trapped supply crate once this is captured
		if( player HasPerk( "specialty_disarmexplosive" ) && 
			owner != player &&
			((level.teambased && team != player.team) || !level.teambased) )
		{
			// spawn an explosive crate right before we delete the other
			spawn_explosive_crate( crate.origin, crate.angles, weaponname, owner, team, player );
			crate crateDelete( false );
		}
		else
		{
			crate crateDelete();
		}
		return;
	}
}

spawn_explosive_crate( origin, angle, weaponname, owner, team, hacker ) // self == crate
{
	crate = crateSpawn( weaponname, owner, team, origin, angle );
	crate SetOwner( owner );
	crate SetTeam( team );

	if ( level.teambased )
	{
		crate setEnemyModel( level.crateModelBoobyTrapped );
		crate MakeUsable( team );
	}
	else
	{
		crate setEnemyModel( level.crateModelEnemy );
	}

	crate.hacker = hacker;
	crate crateActivate();
	crate thread crateUseThink();
	crate thread crateUseThinkOwner();
	crate thread watch_explosive_crate();
	crate crateTimeOutThreader();
	crate setHintStringForPerk( "specialty_gambler", "" );
}

watch_explosive_crate() // self == crate
{
	killCamEnt = spawn( "script_model", self.origin + (0,0,60) );
	self.killcament = killcament;
	self waittill( "captured", player );
	
	// give warning and then explode
	self thread maps\mp\_entityheadIcons::setEntityHeadIcon( player.team, player, level.crate_headicon_offset, "headicon_dead", true );	
	self loop_sound( "wpn_semtex_alert", 0.15 );

	if( !IsDefined( self.hacker ) )
	{
		self.hacker = self;
	}
	self RadiusDamage( self.origin, 256, 300, 75, self.hacker, "MOD_EXPLOSIVE", "supplydrop_mp" );
	PlayFX( level._supply_drop_explosion_fx, self.origin );
	PlaySoundAtPosition( "wpn_grenade_explode", self.origin );
	wait ( 0.1 );
	self crateDelete();
	killcament thread deleteAfterTime( 5 );
}

loop_sound( alias, interval ) // self == crate
{
	self endon( "death" );
	while( 1 )
	{
		PlaySoundAtPosition( alias, self.origin );

		wait interval;
		interval = (interval / 1.2);

		if (interval < .08)
		{
			break;
		}	
	}
}

crateKill() // self == crate
{
	self endon( "death" );

	// kill anyone under it
	stationaryThreshold = 2;
	killThreshold = 15;
	maxFramesTillStationary = 20;
	numFramesStationary = 0;
	while( true )
	{	
		vel = 0;
		if ( IsDefined( self.velocity ) )
			vel = abs( self.velocity[2] );
		
		if ( vel > killThreshold )
			self is_touching_crate();

		if ( vel < stationaryThreshold )
			numFramesStationary++;
		else
			numFramesStationary = 0;

		if ( numFramesStationary >= maxFramesTillStationary )
			break;
		
		wait 0.01;
	}
}

crateDropToGroundKill()
{
	self endon( "death" );
	self endon( "stationary" );

	for ( ;; )
	{
		players = get_players();
		doTrace = false;

		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i].sessionstate != "playing" )
				continue;

			if ( players[i].team == "spectator" )
				continue;

			//Check if any equipment gets landed on
			self is_equipment_touching_crate( players[i] );

			if ( !IsAlive( players[i] ) )
				continue;
			
			flattenedSelfOrigin = (self.origin[0], self.origin[1], 0 );
			flattenedPlayerOrigin = (players[i].origin[0], players[i].origin[1], 0 );
			
			if ( DistanceSquared( flattenedSelfOrigin, flattenedPlayerOrigin ) > 64 * 64 )
				continue;

			doTrace = true;
			break;
		}

		// do the trace
		if ( doTrace )
		{
			start = self.origin;
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 1.0, 0.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( -1.0, 0.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 0.0, -1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 0.0, 1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 1.0, 1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( -1.0, 1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 1.0, -1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( -1.0, -1.0, 0.0 );
			crateDropToGroundTrace( start );

			wait( 0.2 );
		}
		else
		{
			wait( 0.5 );
		}
	}
}

crateDropToGroundTrace( start )
{
	end = start + ( 0, 0, -8000 );

	trace = BulletTrace( start, end, true, self, true, true );

	//DebugStar( start, 200, ( 1, 0, 0 ) );
	//DebugStar( trace[ "position" ], 100, ( 0, 1, 0 ) );

	if ( IsDefined( trace[ "entity" ] ) && IsPlayer( trace[ "entity" ] ) && IsAlive( trace[ "entity" ] ) )
	{
		player = trace[ "entity" ];

		if ( player.sessionstate != "playing" )
			return;

		if ( player.team == "spectator" )
			return;

		if ( DistanceSquared( start, trace[ "position" ] ) < 12 * 12 || self IsTouching( player ) )
		{
			player DoDamage( player.health + 1, player.origin, self.owner, self, 0, "MOD_HIT_BY_OBJECT", 0, "supplydrop_mp" );
			player playsound ( "mpl_supply_crush" );
			player playsound ( "phy_impact_supply" );			
		}
	}
}

is_touching_crate() // self == crate
{
	extraBoundary = ( 10, 10, 10 );
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined( players[i] ) && IsAlive( players[i] ) && self IsTouching( players[i], extraBoundary ) )
		{
			players[i] DoDamage( players[i].health + 1, players[i].origin, self.owner, self, 0, "MOD_HIT_BY_OBJECT", 0, "supplydrop_mp" );
			players[i] playsound ("mpl_supply_crush");
			players[i] playsound ("phy_impact_supply");			
		}

		self is_equipment_touching_crate( players[i] );
	}
}

is_equipment_touching_crate( player ) // self == crate, player is passed to access their equipment
{
	extraBoundary = ( 10, 10, 10 );
	if( IsDefined( player ) && isDefined( player.weaponObjectWatcherArray ) )
	{
		for( watcher = 0; watcher < player.weaponObjectWatcherArray.size; watcher++ )
		{ 
			objectWatcher = player.weaponObjectWatcherArray[watcher];
			objectArray = objectWatcher.objectArray;
			
			if( isDefined( objectArray ) )
			{
				for( weaponObject = 0; weaponObject < objectArray.size; weaponObject++ )
				{
					 if( isDefined(objectArray[weaponObject]) && self IsTouching( objectArray[weaponObject], extraBoundary ) )
					 {
						if( isDefined(objectWatcher.detonate) )
						{
							objectWatcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( objectArray[weaponObject], 0 );
						}
						else
						{
							maps\mp\gametypes\_weaponobjects::deleteWeaponObject( objectWatcher, objectArray[weaponObject] );
						}
					 }
				}
			}
		}
	}

	//Check for tactical insertion
	extraBoundary = ( 15, 15, 15 );
	if( IsDefined( player ) && isDefined( player.tacticalInsertion ) && self IsTouching( player.tacticalInsertion, extraBoundary ) )
	{
		player.tacticalInsertion thread maps\mp\_tacticalinsertion::fizzle();
	}
}

crateTimeOut( time )
{
	self endon("death");
	wait (time);
	self crateDelete( );
}
	


spawnUseEnt()
{
	useEnt = spawn( "script_origin", self.origin );
	useEnt.curProgress = 0;
	useEnt.inUse = false;
	useEnt.useRate = 0;
	useEnt.useTime = 0;
	useEnt.owner = self;
	
	useEnt thread useEntOwnerDeathWaiter( self );

	return useEnt;
}

useEntOwnerDeathWaiter( owner )
{
	self endon ( "death" );
	owner waittill ( "death" );
	
	self delete();
}

// taken from _gameobject maybe we can just use the _gameobject code
crateUseThink() // self == crate
{
	while( IsDefined(self) )
	{
		self waittill("trigger", player );
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
		
		if ( IsDefined( self.owner ) && self.owner == player )
			continue;
			
		useEnt = self spawnUseEnt();
		result = false;
		
		// if the crate has been hacked then we'll need to know later on the useEnt
		if( IsDefined( self.hacker ) )
		{
			useEnt.hacker = self.hacker;
		}
		
		// we need to keep an eye on the useEnt for the gambler to know if the crate is being captured or not
		self.useEnt = useEnt;

		if ( player HasPerk( "specialty_fastinteract" ) )
		{
			if( level.teambased && player.team == self.owner.team )
			{
				// don't let teammates fast interact other teammates, that's just mean spirited
				result = useEnt useHoldThink( player, level.crateNonOwnerUseTime );
			}
			else
			{
				result = useEnt useHoldThink( player, level.crateOwnerUseTime );
			}
		}
		else
		{
			result = useEnt useHoldThink( player, level.crateNonOwnerUseTime );
		}
		
		if ( IsDefined( useEnt ) )
		{
			useEnt Delete();
		}
		
		if ( result )
		{
			if ( isdefined( self.owner ) )
			{
				if ( level.teambased ) 
				{
					if ( player.team != self.owner.team )
					{
						self.owner playlocalsound( "mpl_crate_enemy_steals" );
						// don't give a medal for capturing a booby trapped crate
						if( !IsDefined( self.hacker ) )
						{
							player notify ( "hijacked crate" );
						}
					}
					else 
					{
						if ( isdefined ( self.owner ) )
						{
							self.owner playlocalsound( "mpl_crate_friendly_steals" );
							// don't give a medal for capturing a booby trapped crate
							if( !IsDefined( self.hacker ) )
							{
								self.owner notify ( "team crate hijacked", self.crateType );
							}
						}
					}
				}
				else
				{
					if ( player != self.owner )
					{
						self.owner playlocalsound( "mpl_crate_enemy_steals" );
						// don't give a medal for capturing a booby trapped crate
						if( !IsDefined( self.hacker ) )
						{
							player notify ( "hijacked crate" );
						}
					}
				}
			}
			self notify("captured", player );
		}
	}
}

crateUseThinkOwner() // self == crate
{
	self endon("joined_team");

	while( IsDefined(self) )
	{
		self waittill("trigger", player );
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
		
		if ( !IsDefined( self.owner ) )
			continue;

		if ( self.owner != player )
			continue;
			
		result = self useHoldThink( player, level.crateOwnerUseTime );

		if ( result )
		{
			self notify("captured", player );
		}
	}
}

useHoldThink( player, useTime ) // self == a script origin (useEnt) or the crate
{
	player notify ( "use_hold" );
	player freeze_player_controls( true );

	player _disableWeapon();

	self.curProgress = 0;
	self.inUse = true;
	self.useRate = 0;
	self.useTime = useTime;
	
	player thread personalUseBar( self );

	result = useHoldThinkLoop( player );
	
	if ( isDefined( player ) )
	{
		player notify( "done_using" );
	}
	
	if ( isDefined( player ) )
	{
		
		if ( IsAlive(player) )
		{
			player _enableWeapon();
	
			player freeze_player_controls( false );
		}
	}
	
	if ( IsDefined( self ) )
	{
		self.inUse = false;
	}

	// result may be undefined if useholdthinkloop hits an endon
	if ( isdefined( result ) && result )
		return true;
	
	return false;
}

useHoldThinkLoop( player )
{
	level endon ( "game_ended" );
	self endon("disabled");
	
	timedOut = 0;
	
	while( IsDefined(self) && isAlive( player ) && player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() && !player IsInVehicle() && self.curProgress < self.useTime )
	{
		timedOut += 0.05;

		self.curProgress += (50 * self.useRate);
		self.useRate = 1;

		if ( self.curProgress >= self.useTime )
		{
			self.inUse = false;
						
			wait .05;
			
			return isAlive( player );
		}
		
		wait 0.05;
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
	
	return false;
}

crateGamblerThink()
{
	self endon( "death" );

	for ( ;; )
	{

		self waittill( "trigger_use_doubletap", player );

			
		if ( !player HasPerk( "specialty_gambler" ) )
		{
			continue;
		}
		if( IsDefined( self.useEnt ) && self.useEnt.inUse )
		{
			// TODO: get a fail sound for this
			continue;
		}
		
		player playlocalsound ("uin_gamble_perk");
		
		self.crateType = getRandomCrateType( "gambler_mp", self.crateType.name );
		self crateReactivate();
		
		return;
	}
}

crateReactivate()
{
	self setHintString( self.crateType.hint );
	self setHintStringForPerk( "specialty_gambler", "" );

	icon = self getIconForCrate();
	
	self thread maps\mp\_entityheadIcons::setEntityHeadIcon( self.team, self, level.crate_headicon_offset, icon, true );
}

personalUseBar( object ) // self == player, object == a script origin (useEnt) or the crate
{
	self endon("disconnect");
	
	self.useBar = createSecondaryProgressBar();
	self.useBarText = createSecondaryProgressBarText();

	if( self HasPerk( "specialty_disarmexplosive" ) && 
		object.owner != self && 
		!IsDefined( object.hacker ) &&
		( ( level.teambased && object.owner.team != self.team ) || !level.teambased ) )
	{
		self.useBarText setText( &"KILLSTREAK_HACKING_CRATE" );
		self PlayLocalSound ( "evt_hacker_hacking" );
	}
	else
	{
		self.useBarText setText( &"KILLSTREAK_CAPTURING_CRATE" );
	}

	lastRate = -1;
	while ( isAlive( self ) && IsDefined(object) && object.inUse && !level.gameEnded )
	{
		if ( lastRate != object.useRate )
		{
			if( object.curProgress > object.useTime)
				object.curProgress = object.useTime;

			self.useBar updateBar( object.curProgress / object.useTime, (1000 / object.useTime) * object.useRate );

			if ( !object.useRate )
			{
				self.useBar hideElem();
				self.useBarText hideElem();
			}
			else
			{
				self.useBar showElem();
				self.useBarText showElem();
			}
		}	
		lastRate = object.useRate;
		wait ( 0.05 );
	}
	
	self.useBar destroyElem();
	self.useBarText destroyElem();
}

spawn_helicopter( owner, team, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	if ( !IsDefined( chopper ) )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "supply_drop_mp", team );
		return undefined;
	}

	chopper.owner = owner;
	chopper.maxhealth = 1500;								// max health
	chopper.health = 999999;								// we check against maxhealth in the damage monitor to see if this gets destroyed, so we don't want this to die prematurely			
	chopper.rocketDamageOneShot = chopper.maxhealth + 1;	// Make it so the heatseeker blows it up in one hit for now
	chopper.damageTaken = 0;
	chopper thread maps\mp\killstreaks\_helicopter::heli_damage_monitor( "supply_drop_mp" );	
	chopper.spawnTime = GetTime();
	
	supplydropSpeed = getDvarIntDefault( "scr_supplydropSpeedStarting", 125 ); // 250);
	supplydropAccel = getDvarIntDefault( "scr_supplydropAccelStarting", 100 ); //175);
	chopper SetSpeed( supplydropSpeed, supplydropAccel );	

	maxPitch = getDvarIntDefault( "scr_supplydropMaxPitch", 25);
	maxRoll = getDvarIntDefault( "scr_supplydropMaxRoll", 45 ); // 85);
	chopper SetMaxPitchRoll( 0, maxRoll );	
	
	chopper.team = team;
	
	Target_Set(chopper, ( -200, 0, -100 ));
	
	chopper thread refCountDecChopper(team);
	chopper thread heliDestroyed();

	return chopper;
}

getDropHeight(origin)
{
	return maps\mp\_airsupport::getMinimumFlyHeight();
}

getDropDirection()
{
	return (0, RandomInt(360), 0);
}

getNextDropDirection( drop_direction, degrees )
{
	drop_direction = (0, drop_direction[1] + degrees, 0 );

	if( drop_direction[1] >= 360 )
		drop_direction = (0, drop_direction[1] - 360, 0 );

	return drop_direction;
}

getHeliStart( drop_origin, drop_direction )
{
	dist = -1 * getDvarIntDefault( "scr_supplydropIncomingDistance", 10000 ); // 15000);
	pathRandomness = 100;
	direction = drop_direction + (0, RandomIntRange( -2, 3 ), 0);
	
	start_origin = drop_origin + ( AnglesToForward( direction ) * dist );
	start_origin += ( (randomfloat(2) - 1)*pathRandomness, (randomfloat(2) - 1)*pathRandomness, 0 );
/#
	if ( getDvarIntDefault( "scr_noflyzones_debug", 0 ) ) 
	{
		if ( level.noFlyZones.size )
		{
			index = RandomIntRange( 0, level.noFlyZones.size );
			delta = drop_origin - level.noFlyZones[index].origin;
			delta = ( delta[0] + RandomInt(10), delta[1] + RandomInt(10), 0 );
			delta = VectorNormalize( delta );
			start_origin = drop_origin + ( delta * dist );
		}
	}
#/
	return start_origin;
}

getHeliEnd( drop_origin, drop_direction )
{
	pathRandomness = 150;
	dist = -1 * getDvarIntDefault( "scr_supplydropOutgoingDistance", 15000);
	
	// have the heli do a sharp turn when leaving
	if ( RandomIntRange(0,2) == 0 )
		turn = RandomIntRange( 60,121);
	else
		turn = -1 * RandomIntRange( 60,121);
		
	direction = drop_direction + (0, turn, 0);
	
	end_origin = drop_origin + ( AnglesToForward( direction ) * dist );
	end_origin += ( (randomfloat(2) - 1)*pathRandomness  , (randomfloat(2) - 1)*pathRandomness  , 0 );

	return end_origin;
}

addOffsetOntoPoint( point, direction, offset )
{
	angles = VectorToAngles( (direction[0], direction[1], 0) );
	
	offset_world = RotatePoint( offset, angles );
	
	return (point + offset_world);			
}

supplyDropHeliStartPath(goal, goal_offset)
{
	total_tries = 12;
	tries = 0;
	
	goalPath = SpawnStruct();
	drop_direction = getDropDirection();
	
	
	while ( tries < total_tries )
	{
		goalPath.start = getHeliStart( goal, drop_direction );
		
		goalPath.path = maps\mp\_airsupport::getHeliPath( goalPath.start, goal );
		
		if ( IsDefined( goalPath.path ) )
		{
			if ( goalPath.path.size > 1 )
			{
				direction = ( goalPath.path[goalPath.path.size - 1] - goalPath.path[goalPath.path.size - 2] );
			}
			else
			{
				direction = ( goalPath.path[goalPath.path.size - 1] - goalPath.start );
			}
			goalPath.path[goalPath.path.size - 1] = addOffsetOntoPoint(goalPath.path[goalPath.path.size - 1], direction, goal_offset);
/#
			sphere( goalPath.path[goalPath.path.size - 1], 10, (0,0,1), 1, true, 10, 1000 );
#/
			return goalPath;
		}
		
		//Couldn't find a path that didn't cross a no fly zone picking random directions, so try the last tried direction plus 30 degrees
		drop_direction = getNextDropDirection( drop_direction, 30 );
		
		tries++;
	}

	//Couldn't find a valid direction, so just bring it in even if it will fly through something
	drop_direction = getDropDirection();
	goalPath.start = getHeliStart( goal, drop_direction );
	
	direction = ( goal - goalPath.start );
	goalPath.path = [];
	goalPath.path[0] = addOffsetOntoPoint( goal, direction, goal_offset );
	
	return goalPath;
}

supplyDropHeliEndPath(origin, drop_direction)
{
	total_tries = 5;
	tries = 0;
	
	goalPath = SpawnStruct();
	
	while ( tries < total_tries )
	{
		goal = getHeliEnd( origin, drop_direction );
		
		goalPath.path = maps\mp\_airsupport::getHeliPath( origin, goal );
		
		if ( IsDefined( goalPath.path ) )
		{
			return goalPath;
		}
		
		tries++;
	}
	
	goalPath.path = [];
	goalPath.path[0] = getHeliEnd( origin, drop_direction );
	
	return goalPath;
}


heliDeliverCrate(origin, weaponname, owner, team)
{
	if ( weaponname == "turret_drop_mp" )
	{
		self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "turret_drop_mp", self.pers["team"] );
		self maps\mp\gametypes\_persistence::statAdd( "AUTO_TURRET_USED", 1, false );
	}
	else if ( weaponname == "tow_turret_drop_mp" )
	{
		self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "tow_turret_drop_mp", self.pers["team"] );
		self maps\mp\gametypes\_persistence::statAdd( "TOW_TURRET_USED", 1, false );
	}
	else
	{
		self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "supply_drop_mp", self.pers["team"] );
		self maps\mp\gametypes\_persistence::statAdd( "SUPPLY_DROP_USED", 1, false );
		self AddWeaponStat( "killstreak_supply_drop", "used", 1 );
	}

	rear_hatch_offset_local = getDvarIntDefault( "scr_supplydropOffset", 400);
	
	drop_origin = origin;
	drop_height = getDropHeight(drop_origin);
	
	heli_drop_goal = ( drop_origin[0], drop_origin[1], drop_height ); //  + rear_hatch_offset_world;
	
/#
	sphere( heli_drop_goal, 10, (0,1,0), 1, true, 10, 1000 );
#/

	goalPath = supplyDropHeliStartPath(heli_drop_goal, (rear_hatch_offset_local, 0, 0 ));
	drop_direction = VectorToAngles( (heli_drop_goal[0], heli_drop_goal[1], 0) - (goalPath.start[0], goalPath.start[1], 0));
	
	chopper = spawn_helicopter( owner, team, goalPath.start, drop_direction, level.suppyDropHelicopterVehicleInfo, level.supplyDropHelicopterFriendly);
	chopper setenemymodel( level.supplyDropHelicopterEnemy );
	chopper SetTeam(team);
	chopper SetOwner( owner );
	killCamEnt = spawn( "script_model", chopper.origin + (0,0,800) );
	killCamEnt.angles = (100, chopper.angles[1], chopper.angles[2]);
	
	killCamEnt.startTime = gettime();
	killCamEnt linkTo( chopper );
	//Wait until the chopper is within the map bounds or within a certain distance of it's target before the SAM turret can target it
	Target_SetTurretAquire( self, false );
	chopper thread SAMTurretWatcher( drop_origin );

	if ( !IsDefined( chopper ) )
		return;
	
	chopper thread heliDropCrate(weaponname, owner, rear_hatch_offset_local, killCamEnt);
	chopper endon("death");
	
	chopper thread maps\mp\_airsupport::followPath( goalPath.path, "drop_goal", true);

	chopper thread speedRegulator(heli_drop_goal);

	chopper waittill( "drop_goal" );
	
	// give time for the crate to drop, but not much
	wait (0.2);
	
/#
	PrintLn("Chopper Incoming Time: " + ( GetTime() - chopper.spawnTime ) );
#/
	chopper notify("drop_crate", chopper.origin, chopper.angles);
	chopper.dropTime = GetTime();
	
	supplydropSpeed = getDvarIntDefault( "scr_supplydropSpeedLeaving", 150 ); // 300);
	supplydropAccel = getDvarIntDefault( "scr_supplydropAccelLeaving", 40 ); // 75);
	chopper setspeed( supplydropSpeed, supplydropAccel );	

	goalPath = supplyDropHeliEndPath(chopper.origin, ( 0, chopper.angles[1], 0 ) );
	
	chopper maps\mp\_airsupport::followPath( goalPath.path, undefined, false );

/#
	PrintLn("Chopper Outgoing Time: " + ( GetTime() - chopper.dropTime ) );
#/
	chopper notify( "leaving" );
	chopper Delete();
}

SAMTurretWatcher( destination )
{
	self endon( "leaving" );
	self endon( "helicopter_gone" );
	self endon( "death" );

	SAM_TURRET_AQUIRE_DIST = 1500;

	while(1)
	{
		if( Distance( destination, self.origin ) < SAM_TURRET_AQUIRE_DIST )
			break;

		if( self.origin[0] > level.spawnMins[0] && self.origin[0] < level.spawnMaxs[0] &&
			self.origin[1] > level.spawnMins[1] && self.origin[1] < level.spawnMaxs[1] )
			break;

		wait( 0.1 );
	}

	Target_SetTurretAquire( self, true );
}

speedRegulator( goal )
{
	self endon("drop_goal");
	self endon("death");
	
	wait (3);

	supplydropSpeed = getDvarIntDefault( "scr_supplydropSpeed", 75);
	supplydropAccel = getDvarIntDefault( "scr_supplydropAccel", 40);
	self SetYawSpeed( 100, 60, 60 );
	self SetSpeed( supplydropSpeed, supplydropAccel );	

	wait (1);
	maxPitch = getDvarIntDefault( "scr_supplydropMaxPitch", 25);
	maxRoll = getDvarIntDefault( "scr_supplydropMaxRoll", 35 ); // 85);
	self SetMaxPitchRoll( maxPitch, maxRoll );	
//
//	while(1)
//	{
//		dist = Distance( self.origin, goal );
//		
//		speed = self GetSpeed();
//		time = speed / ( (supplydropAccel * 17.6)  * 0.5 );
//		stopDist = speed * 0.5 * time;
//		
//		if ( stopDist > dist )
//		{
//			self SetSpeed( 20, accel );			
//			return;
//		}
//	}
}

heliDropCrate(weaponname, owner, offset, killCamEnt)
{
	owner endon ( "disconnect" );
	
	self waittill("drop_crate", origin, angles);
	
	rear_hatch_offset_height = getDvarIntDefault( "scr_supplydropOffsetHeight", 200);
	rear_hatch_offset_world = RotatePoint( ( offset, 0, 0), angles );
	drop_origin = origin - (0,0,rear_hatch_offset_height) - rear_hatch_offset_world;
	thread dropCrate(drop_origin, angles, weaponname, owner, self.team, killCamEnt );
}

heliDestroyed()
{
	self endon( "leaving" );
	self endon( "helicopter_gone" );
	self endon( "death" );
	
	while( true )
	{
		if( self.damageTaken > self.maxhealth )
			break;

		wait( 0.05 );
	}

	if (! isDefined(self) )
		return;
		
	self SetSpeed( 25, 5 );
	self thread lbSpin( RandomIntRange(180, 220) );
	
	wait( RandomFloatRange( .5, 1.5 ) );
	
	self notify( "drop_crate", self.origin, self.angles );
	
	lbExplode();
}

// crash explosion
lbExplode()
{
	forward = ( self.origin + ( 0, 0, 1 ) ) - self.origin;
	playfx ( level.chopper_fx["explode"]["death"], self.origin, forward );
	
	// play heli explosion sound
	self playSound( level.heli_sound[self.team]["crash"] );
	self notify ( "explode" );

	self delete();
}


lbSpin( speed )
{
	self endon( "explode" );
	
	// tail explosion that caused the spinning
	playfxontag( level.chopper_fx["explode"]["medium"], self, "tail_rotor_jnt" );
	playfxontag( level.chopper_fx["fire"]["trail"]["medium"], self, "tail_rotor_jnt" );
	
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}

refCountDecChopper( team )
{
	self waittill("death");
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "supply_drop_mp", team );
}

refCountDecChopperOnDisconnect( team )
{
	self endon( "supply_drop_marker_done" );
	
	self waittill("disconnecct");
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "supply_drop_mp", team );
}



/#
//Adds functionality so we can drop specific supply drops when we want for development purposes
supply_drop_dev_gui()
{	
	//Init my dvar
	SetDvar("scr_supply_drop_gui", "");

	while(1)
	{
		wait(0.5);

		//Grab my dvar every frame
		devgui_string = getdvar( "scr_supply_drop_gui");

		//This  can happen in the dev gui. Look at devgui_mp.cfg.
		switch(devgui_string)
		{
		case "ammo":
			level.dev_gui_supply_drop = "ammo";
			break;
		case "spyplane":
			level.dev_gui_supply_drop = "radar_mp";
			break;
		case "counter_u2":
			level.dev_gui_supply_drop = "counteruav_mp";
			break;
		case "airstrike":
			level.dev_gui_supply_drop = "airstrike_mp";
			break;
		case "artillery":
			level.dev_gui_supply_drop = "artillery_mp";
			break;
		case "napalm":
			level.dev_gui_supply_drop = "napalm_mp";
			break;
		case "autoturret":
			level.dev_gui_supply_drop = "autoturret_mp";
			break;
		case "tow_turret":
			level.dev_gui_supply_drop = "auto_tow_mp";
			break;
		case "dogs":
			level.dev_gui_supply_drop = "dogs_mp";
			break;
		case "m202":
			level.dev_gui_supply_drop = "m202_flash_mp";
			break;
		case "rc_bomb":
			level.dev_gui_supply_drop = "rcbomb_mp";
			break;
		case "mortar":
			level.dev_gui_supply_drop = "mortar_mp";
			break;
		case "mini_gun":
			level.dev_gui_supply_drop = "minigun_mp";
			break;
		case "m220_tow":
			level.dev_gui_supply_drop = "m220_tow_mp";
			break;
		case "mp40":
			level.dev_gui_supply_drop = "mp40_drop_mp";
			break;
		case "heli":
			level.dev_gui_supply_drop = "helicopter_comlink_mp";
			break;
		case "heli_gunner":
			level.dev_gui_supply_drop = "helicopter_gunner_mp";
			break;
		case "player_heli":
			level.dev_gui_supply_drop = "helicopter_player_firstperson_mp";
			break;
		case "satellite":
			level.dev_gui_supply_drop = "radardirection_mp";
			break;
		case "random":
			level.dev_gui_supply_drop = "random";
			break;
		default:
			break;
		}	
	}
}
#/
