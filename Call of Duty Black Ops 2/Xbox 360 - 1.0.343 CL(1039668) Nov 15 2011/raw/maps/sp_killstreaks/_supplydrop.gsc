#include common_scripts\utility;
#include maps\_utility;
#include maps\gametypes\_hud_util;
#include maps\sp_killstreaks\_airsupport;

preload()
{
	level.crateModelFriendly = "mp_supplydrop_ally";
	level.crateModelEnemy = "mp_supplydrop_axis";
	level.crateModelBoobyTrapped = "mp_supplydrop_boobytrapped";
	level.supplyDropHelicopterFriendly = "vehicle_ch46e_mp_light";
	level.supplyDropHelicopterEnemy = "vehicle_ch46e_mp_dark";
	level.suppyDropHelicopterVehicleInfo = "heli_supplydrop_mp";
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
	PreCacheShader( "hud_ks_minigun" );
	PreCacheShader( "hud_ks_minigun_drop" );
	PreCacheShader( "hud_ks_m202" );
	PreCacheShader( "hud_ks_m202_drop" );
	PreCacheShader( "hud_ammo_refill" );
	PreCacheShader( "hud_ammo_refill_drop" );
	PreCacheString( &"KILLSTREAK_CAPTURING_CRATE" );
	PreCacheShader( "progress_bar_bg" );
	precacheShader( "progress_bar_fg" );
	precacheShader( "progress_bar_fill" );
	maps\sp_killstreaks\_killstreaks::registerKillstreak("supply_drop_sp", "supplydrop_sp", "killstreak_supply_drop", "supply_drop_used", ::useKillstreakSupplyDrop, undefined, true );
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("supply_drop_sp", &"KILLSTREAK_EARNED_SUPPLY_DROP", &"KILLSTREAK_AIRSPACE_FULL");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("supply_drop_sp", "mpl_killstreak_supply", "kls_supply_used", "","kls_supply_enemy", "", "kls_supply_ready");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("supply_drop_sp", "scr_givesupplydrop");
	
	level._supply_drop_smoke_fx = LoadFX( "env/smoke/fx_smoke_supply_drop_blue_mp" );
	level._supply_drop_explosion_fx = LoadFX( "explosions/fx_grenadeexp_default" );
	LoadFX ("vehicle/props/fx_seaknight_main_blade_full");
	LoadFX ("vehicle/props/fx_seaknight_rear_blade_full");
}

init()
{
	level thread onPlayerConnect();
	
	
	level.crateOwnerUseTime = 500;
	level.crateNonOwnerUseTime = 3000;
	level.crate_headicon_offset = (0, 0, 15);



	//maps\sp_killstreaks\_killstreaks::registerKillstreakAltWeapon("supply_drop_sp", "minigun_sp" );
	//maps\sp_killstreaks\_killstreaks::registerKillstreakAltWeapon("supply_drop_sp", "mp40_blinged_mp" );
//	maps\sp_killstreaks\_killstreaks::setRemoveWeaponWhenUsed("supply_drop_sp", false);hud_ks_m202
	maps\sp_killstreaks\_killstreaks::allowKillstreakAssists("supply_drop_sp", true);

	level.crateTypes = [];

	//registerCrateType( "minigun_drop_mp", "killstreak", "minigun_mp", 1, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_CRATE_GAMBLER", "MEDAL_SHARE_PACKAGE_MINIGUN", ::giveCrateKillstreak );
	//registerCrateType( "m220_tow_drop_mp", "killstreak", "m220_tow_mp", 1, &"KILLSTREAK_M220_TOW_CRATE", undefined, "MEDAL_SHARE_PACKAGE_TOW", ::giveCrateKillstreak );
	
	// percentage of drop explanation:
	//		add all of the numbers up: 15 + 2 + 3 + etc. = 80 for example
	//		now if you want to know the percentage of the minigun_mp drop, you'd do (minigun_mp number / total) or 2/80 = 2.5% chance of dropping
	// right now this is at a perfect 100, so the percentages are easy to understand
	registerCrateType( "supplydrop_sp", "ammo", "ammo", 30, &"KILLSTREAK_AMMO_CRATE", &"PLATFORM_AMMO_CRATE_GAMBLER", "MEDAL_SHARE_PACKAGE_AMMO", ::giveCrateAmmo );
	registerCrateType( "supplydrop_sp", "killstreak", "mortar_sp", 30, &"KILLSTREAK_MORTAR_CRATE", &"PLATFORM_MORTAR_GAMBLER", "MEDAL_SHARE_PACKAGE_MORTAR", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_sp", "killstreak", "helicopter_comlink_sp", 20, &"KILLSTREAK_HELICOPTER_CRATE", &"PLATFORM_HELICOPTER_GAMBLER", "MEDAL_SHARE_PACKAGE_HELICOPTER_COMLINK", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_sp", "killstreak", "autoturret_sp", 10, &"KILLSTREAK_AUTO_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_AUTO_TURRET", ::giveCrateKillstreak );
	registerCrateType( "supplydrop_sp", "killstreak", "auto_tow_sp", 10, &"KILLSTREAK_TOW_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_TOW_TURRET", ::giveCrateKillstreak );
	
	//registerCrateType( "supplydrop_sp", "killstreak", "radar_mp", 15, &"KILLSTREAK_RADAR_CRATE", &"PLATFORM_RADAR_GAMBLER", "MEDAL_SHARE_PACKAGE_RECON", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "counteruav_mp", 15, &"KILLSTREAK_COUNTERU2_CRATE", &"PLATFORM_COUNTERU2_GAMBLER", "MEDAL_SHARE_PACKAGE_COUNTERU2", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "rcbomb_mp", 9, &"KILLSTREAK_RCBOMB_CRATE", &"PLATFORM_RCBOMB_GAMBLER", "MEDAL_SHARE_PACKAGE_RCBOMB", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "m220_tow_mp", 5, &"KILLSTREAK_M220_TOW_CRATE", &"PLATFORM_M220_TOW_GAMBLER", "MEDAL_SHARE_PACKAGE_TOW", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "autoturret_mp", 5, &"KILLSTREAK_AUTO_TURRET_CRATE", &"PLATFORM_AUTO_TURRET_GAMBLER", "MEDAL_SHARE_PACKAGE_AUTO_TURRET", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "auto_tow_mp", 5, &"KILLSTREAK_TOW_TURRET_CRATE", &"PLATFORM_TOW_TURRET_GAMBLER", "MEDAL_SHARE_PACKAGE_TOW_TURRET", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "airstrike_mp", 3, &"KILLSTREAK_AIRSTRIKE_CRATE", &"PLATFORM_AIRSTRIKE_GAMBLER", "MEDAL_SHARE_PACKAGE_AIRSTRIKE", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "m202_flash_mp", 3, &"KILLSTREAK_M202_FLASH_CRATE", &"PLATFORM_M202_FLASH_GAMBLER", "MEDAL_SHARE_PACKAGE_FLASH", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "napalm_mp", 3, &"KILLSTREAK_NAPALM_CRATE", &"PLATFORM_NAPALM_GAMBLER", "MEDAL_SHARE_PACKAGE_NAPALM", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "radardirection_mp", 3, &"KILLSTREAK_SATELLITE_CRATE", &"PLATFORM_SATELLITE_GAMBLER", "MEDAL_SHARE_PACKAGE_SATELLITE", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "minigun_mp", 2, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_GAMBLER", "MEDAL_SHARE_PACKAGE_MINIGUN", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "helicopter_gunner_mp", 2, &"KILLSTREAK_HELICOPTER_GUNNER_CRATE", &"PLATFORM_HELICOPTER_GUNNER_GAMBLER", "MEDAL_SHARE_PACKAGE_HELICOPTER_GUNNER", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "dogs_mp", 1, &"KILLSTREAK_DOGS_CRATE", &"PLATFORM_DOGS_GAMBLER", "MEDAL_SHARE_PACKAGE_DOGS", ::giveCrateKillstreak );
	//registerCrateType( "supplydrop_sp", "killstreak", "heicopter_player_firstperson_mp", 1, &"KILLSTREAK_HELICOPTER_PLAYER_CRATE", &"PLATFORM_HELICOPTER_PLAYER_GAMBLER", "MEDAL_SHARE_PACKAGE_HELICOPTER_PLAYER", ::giveCrateKillstreak );

	

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
		GetDvarIntDefault( "scr_crate_notimeout", 0 ); 
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
	self maps\sp_killstreaks\_killstreaks::giveKillstreak( killstreak );
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
	
//	self AddWeaponStat( weapon, "used", 1 );
	
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
		case "minigun_sp":
		case "m202_flash_sp":
		case "m220_tow_sp":
		case "mp40_blinged_sp":
		case "ally_squad_sp":
			continue;

		case "frag_grenade_sp":
		case "sticky_grenade_sp":
		case "hatchet_sp":
		case "flash_grenade_sp":
		case "concussion_grenade_sp":
		case "tabun_gas_sp":
		case "nightingale_sp":
		case "willy_pete_sp":
			stock = self GetWeaponAmmoStock( weapon );
			maxAmmo = WeaponMaxAmmo( weapon );

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

	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
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
	
	if( self isSupplyDropGrenadeAllowed(hardpointType, "supplydrop_sp" ) == false )
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
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
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
		//self setBlockWeaponPickup(weapon, true);
		return true;
	}

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);

	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
//	self setBlockWeaponPickup(weapon, true);
	return true;
}

use_killstreak_grim_reaper(hardpointType)
{
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
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
//		self setBlockWeaponPickup(weapon, true);
		return true;
	}

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
//	self setBlockWeaponPickup(weapon, true);
	return true;
}

use_killstreak_tv_guided_missile(hardpointType)
{
	if ( maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
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
//		self setBlockWeaponPickup(weapon, true);
		return true;
	}

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
//	self setBlockWeaponPickup(weapon, true);
	return true;
}

use_killstreak_mp40( hardpointType )
{
	if ( maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
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
//		self setBlockWeaponPickup(weapon, true);
		return true;
	}

	self TakeWeapon( currentWeapon );
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
//	self setBlockWeaponPickup(weapon, true);
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
	
	if ( self maps\sp_killstreaks\_killstreakrules::killstreakStart( "supply_drop_sp", team ) == false )
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
		maps\sp_killstreaks\_killstreakrules::killstreakStop( "supply_drop_sp", team );
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
	maps\sp_killstreaks\_killstreakrules::killstreakStop( "supply_drop_sp", team );
	self delete();
}

checkWeaponChange( team )
{
	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "grenade_fire" );
	
	self waittill( "weapon_change" );
	maps\sp_killstreaks\_killstreakrules::killstreakStop( "supply_drop_sp", team );	
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
		killstreak = maps\sp_killstreaks\_killstreaks::getKillstreakForWeapon( weapon );
		maps\sp_killstreaks\_killstreaks::removeUsedKillstreak( killstreak );
	}
	else
	{
		maps\sp_killstreaks\_killstreaks::removeUsedKillstreak("supply_drop_sp");
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
		weapon == "supplydrop_sp" || 
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
				killstreak = maps\sp_killstreaks\_killstreaks::GetKillStreakMenuName( self.crateType.name );
				icon = level.killStreakIcons[killstreak];
			}
			break;
		
		case "weapon":
			{
				switch( self.crateType.name )
				{
				case "minigun_sp":
					icon = "hud_ks_minigun";
					break;
				case "m202_flash_sp":
					icon = "hud_ks_m202";
					break;
				case "m220_tow_sp":
					icon = "hud_ks_tv_guided_missile";
					break;
				case "mp40_drop_sp":
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
	crateObjID = maps\gametypes\_gameobjects::getNextObjID();	
	objective_add( crateObjID, "invisible", self.origin );
	objective_icon( crateObjID, "compass_supply_drop_green" );
	objective_state( crateObjID, "active" );
	self.friendlyObjID = crateObjID;

	icon = self getIconForCrate();
	self thread setEntityHeadIcon( self, level.crate_headicon_offset, icon, true );	
}

setEntityHeadIcon( owner, offset, icon, constant_size) // "allies", "axis", "all", "none"
{
	if( !IsDefined( constant_size ) )
	{
		constant_size = false;
	}

	if (!isdefined(self.entityHeadIconTeam)) 
	{
		self.entityHeadIconTeam = "none";
		self.entityHeadIcons = [];
	}

	if (isdefined(offset))
		self.entityHeadIconOffset = offset;
	else
		self.entityHeadIconOffset = (0,0,0);

	// destroy existing head icons for this entity
	for (i = 0; i < self.entityHeadIcons.size; i++)
		if (isdefined(self.entityHeadIcons[i]))
			self.entityHeadIcons[i] destroy();
	self.entityHeadIcons = [];
	
	self notify("kill_entity_headicon_thread");
	
	if ( !IsDefined( icon ) )
	{
		return;
	}
	
	if ( IsDefined(owner) )
	{
		// sometimes owner comes in as not a player, for instance, the care package crate
		// unfortunately the updateEntityHeadClientIcon calls newClientHudElem and it needs to be a player entity
		if( !IsPlayer( owner ) )
		{
			assert( IsDefined( owner.owner ), "entity has to have an owner if it's not a player");
			owner = owner.owner;
		}
		owner updateEntityHeadClientIcon(self, icon, constant_size );
	}

	self thread destroyHeadIconsOnDeath();
}

updateEntityHeadClientIcon(entity, icon, constant_size )
{
	headicon = newClientHudElem(self);
	headicon.archived = true;
	headicon.x = entity.entityHeadIconOffset[0];
	headicon.y = entity.entityHeadIconOffset[1];
	headicon.z = entity.entityHeadIconOffset[2];
	headicon.alpha = .8;
	headicon setShader(icon, 6, 6);
	headicon setwaypoint( constant_size ); // false = uniform size in 3D instead of uniform size in 2D
	headicon SetTargetEnt( entity );
	
	// update entityHeadIcons arrays so we can delete this later when either the entity or the player don't want it
	entity.entityHeadIcons[entity.entityHeadIcons.size] = headicon;
}

destroyHeadIconsOnDeath()
{
	self waittill_any ( "death", "hacked" );

	for (i = 0; i < self.entityHeadIcons.size; i++) 
	{
		if (isdefined(self.entityHeadIcons[i]))
			self.entityHeadIcons[i] destroy();
	}	
}

crateDeactivate( )
{
	self makeunusable();
	self SetCursorHint("HINT_NOICON");
	//self setHintString( self.crateType.hint );

	if ( IsDefined(self.friendlyObjID) )
	{
		Objective_Delete( self.friendlyObjID );
		self.friendlyObjID = undefined;
	}
	
	if ( IsDefined(self.enemyObjID) )
	{
		Objective_Delete( self.enemyObjID );
		self.enemyObjID = undefined;
	}
	
	if ( IsDefined(self.hackerObjID) )
	{
		Objective_Delete( self.hackerObjID );
		self.hackerObjID = undefined;
	}
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

	if ( IsDefined(owner) )
		crate.owner = owner;
	
	crate setModel( level.crateModelFriendly );
//	crate setEnemyModel( level.crateModelEnemy );
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
		self.friendlyObjID = undefined;
	}
	
	if ( IsDefined(self.enemyObjID) )
	{
		Objective_Delete( self.enemyObjID );
		self.enemyObjID = undefined;
	}
	
	if ( IsDefined(self.hackerObjID) )
	{
		Objective_Delete( self.hackerObjID );
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
	if ( GetDvarIntDefault( "scr_crate_notimeout", 0 ) ) 
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
		
		crate crateDelete();

		return;
	}
}

spawn_explosive_crate( origin, angle, weaponname, owner, team, hacker ) // self == crate
{
	crate = crateSpawn( weaponname, owner, team, origin, angle );
	crate SetOwner( owner );
	crate SetTeam( team );

	crate.hacker = hacker;
	crate crateActivate();
	crate thread crateUseThink();
	crate thread crateUseThinkOwner();
	crate thread watch_explosive_crate();
	crate crateTimeOutThreader();
	//crate setHintStringForPerk( "specialty_gambler", "" );
}

watch_explosive_crate() // self == crate
{
	killCamEnt = spawn( "script_model", self.origin + (0,0,60) );
	self.killcament = killcament;
	self waittill( "captured", player );
	
	// give warning and then explode
	self loop_sound( "wpn_semtex_alert", 0.15 );

	if( !IsDefined( self.hacker ) )
	{
		self.hacker = self;
	}
	self RadiusDamage( self.origin, 256, 300, 75, self.hacker, "MOD_EXPLOSIVE", "supplydrop_sp" );
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
			//self is_equipment_touching_crate( players[i] );

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
			player DoDamage( player.health + 1, player.origin, self.owner, self );
			player playsound ( "mpl_supply_crush" );
			player playsound ( "phy_impact_supply" );			
		}
	}
}

is_touching_crate() // self == crate
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined( players[i] ) && IsAlive( players[i] ) && self IsTouching( players[i] ) )
		{
			players[i] DoDamage( players[i].health + 1, players[i].origin, self.owner, self );
			players[i] playsound ("mpl_supply_crush");
			players[i] playsound ("phy_impact_supply");			
		}

//		self is_equipment_touching_crate( players[i] );
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

		result = useEnt useHoldThink( player, level.crateNonOwnerUseTime );
		
		if ( IsDefined( useEnt ) )
		{
			useEnt Delete();
		}
		
		if ( result )
		{
			if ( isdefined( self.owner ) )
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
//	self setHintStringForPerk( "specialty_gambler", "" );
}

personalUseBar( object ) // self == player, object == a script origin (useEnt) or the crate
{
	self endon("disconnect");
	
	self.useBar = createSecondaryProgressBar();
	self.useBarText = createSecondaryProgressBarText();

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
		maps\sp_killstreaks\_killstreakrules::killstreakStop( "supply_drop_sp", team );
		return undefined;
	}

	chopper.owner = owner;
	chopper.maxhealth = 1500;								// max health
	chopper.health = 999999;								// we check against maxhealth in the damage monitor to see if this gets destroyed, so we don't want this to die prematurely			
	chopper.rocketDamageOneShot = chopper.maxhealth + 1;	// Make it so the heatseeker blows it up in one hit for now
	chopper.damageTaken = 0;
	//chopper thread maps\sp_killstreaks\_helicopter::heli_damage_monitor( "supply_drop_sp" );	
	chopper.spawnTime = GetTime();
	
	supplydropSpeed = GetDvarIntDefault( "scr_supplydropSpeedStarting", 125 ); // 250);
	supplydropAccel = GetDvarIntDefault( "scr_supplydropAccelStarting", 100 ); //175);
	chopper SetSpeed( supplydropSpeed, supplydropAccel );	

	maxPitch = GetDvarIntDefault( "scr_supplydropMaxPitch", 25);
	maxRoll = GetDvarIntDefault( "scr_supplydropMaxRoll", 45 ); // 85);
	chopper SetMaxPitchRoll( 0, maxRoll );	
	
	chopper.team = team;
	
	Target_Set(chopper, ( -200, 0, -100 ));
	
	chopper thread refCountDecChopper(team);
	chopper thread heliDestroyed();

	return chopper;
}

getDropHeight(origin)
{
	return maps\sp_killstreaks\_airsupport::getMinimumFlyHeight();
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
	dist = -1 * GetDvarIntDefault( "scr_supplydropIncomingDistance", 10000 ); // 15000);
	pathRandomness = 100;
	direction = drop_direction + (0, RandomIntRange( -2, 3 ), 0);
	
	start_origin = drop_origin + ( AnglesToForward( direction ) * dist );
	start_origin += ( (randomfloat(2) - 1)*pathRandomness, (randomfloat(2) - 1)*pathRandomness, 0 );
/#
	if ( GetDvarIntDefault( "scr_noflyzones_debug", 0 ) ) 
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
	dist = -1 * GetDvarIntDefault( "scr_supplydropOutgoingDistance", 15000);
	
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
		
		goalPath.path = maps\sp_killstreaks\_airsupport::getHeliPath( goalPath.start, goal );
		
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
		
		goalPath.path = maps\sp_killstreaks\_airsupport::getHeliPath( origin, goal );
		
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
		self maps\sp_killstreaks\_killstreaks::playKillstreakStartDialog( "turret_drop_mp", self.pers["team"] );
	}
	else if ( weaponname == "tow_turret_drop_mp" )
	{
		self maps\sp_killstreaks\_killstreaks::playKillstreakStartDialog( "tow_turret_drop_mp", self.pers["team"] );
	}
	else
	{
		self maps\sp_killstreaks\_killstreaks::playKillstreakStartDialog( "supply_drop_sp", self.pers["team"] );
//		self AddWeaponStat( "killstreak_supply_drop", "used", 1 );
	}

	rear_hatch_offset_local = GetDvarIntDefault( "scr_supplydropOffset", 400);
	
	drop_origin = origin;
	drop_height = getDropHeight(drop_origin);
	
	heli_drop_goal = ( drop_origin[0], drop_origin[1], drop_height ); //  + rear_hatch_offset_world;
	
/#
	sphere( heli_drop_goal, 10, (0,1,0), 1, true, 10, 1000 );
#/

	goalPath = supplyDropHeliStartPath(heli_drop_goal, (rear_hatch_offset_local, 0, 0 ));
	drop_direction = VectorToAngles( (heli_drop_goal[0], heli_drop_goal[1], 0) - (goalPath.start[0], goalPath.start[1], 0));
	
	chopper = spawn_helicopter( owner, team, goalPath.start, drop_direction, level.suppyDropHelicopterVehicleInfo, level.supplyDropHelicopterFriendly);
//	chopper setenemymodel( level.supplyDropHelicopterEnemy );
	chopper SetTeam(team);
	chopper SetOwner( owner );
	killCamEnt = spawn( "script_model", chopper.origin + (0,0,800) );
	killCamEnt.angles = (100, chopper.angles[1], chopper.angles[2]);
	
	killCamEnt.startTime = gettime();
	killCamEnt linkTo( chopper );
	//Wait until the chopper is within the map bounds or within a certain distance of it's target before the SAM turret can target it
	//Target_SetTurretAquire( self, false );
	chopper thread SAMTurretWatcher( drop_origin );

	if ( !IsDefined( chopper ) )
		return;
	
	chopper thread heliDropCrate(weaponname, owner, rear_hatch_offset_local, killCamEnt);
	chopper endon("death");
	
	chopper thread maps\sp_killstreaks\_airsupport::followPath( goalPath.path, "drop_goal", true);

	chopper thread speedRegulator(heli_drop_goal);

	chopper waittill( "drop_goal" );
	
	// give time for the crate to drop, but not much
	wait (0.2);
	
/#
	PrintLn("Chopper Incoming Time: " + ( GetTime() - chopper.spawnTime ) );
#/
	chopper notify("drop_crate", chopper.origin, chopper.angles);
	chopper.dropTime = GetTime();
	
	supplydropSpeed = GetDvarIntDefault( "scr_supplydropSpeedLeaving", 150 ); // 300);
	supplydropAccel = GetDvarIntDefault( "scr_supplydropAccelLeaving", 40 ); // 75);
	chopper setspeed( supplydropSpeed, supplydropAccel );	

	goalPath = supplyDropHeliEndPath(chopper.origin, ( 0, chopper.angles[1], 0 ) );
	
	chopper maps\sp_killstreaks\_airsupport::followPath( goalPath.path, undefined, false );

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

	//Target_SetTurretAquire( self, true );
}

speedRegulator( goal )
{
	self endon("drop_goal");
	self endon("death");
	
	wait (3);

	supplydropSpeed = GetDvarIntDefault( "scr_supplydropSpeed", 75);
	supplydropAccel = GetDvarIntDefault( "scr_supplydropAccel", 40);
	self SetYawSpeed( 100, 60, 60 );
	self SetSpeed( supplydropSpeed, supplydropAccel );	

	wait (1);
	maxPitch = GetDvarIntDefault( "scr_supplydropMaxPitch", 25);
	maxRoll = GetDvarIntDefault( "scr_supplydropMaxRoll", 35 ); // 85);
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
	
	rear_hatch_offset_height = GetDvarIntDefault( "scr_supplydropOffsetHeight", 200);
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
	maps\sp_killstreaks\_killstreakrules::killstreakStop( "supply_drop_sp", team );
}

refCountDecChopperOnDisconnect( team )
{
	self endon( "supply_drop_marker_done" );
	
	self waittill("disconnecct");
	
	maps\sp_killstreaks\_killstreakrules::killstreakStop( "supply_drop_sp", team );
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
		devgui_string = GetDvar( "scr_supply_drop_gui");

		//This  can happen in the dev gui. Look at devgui_mp.cfg.
		switch(devgui_string)
		{
		case "ammo":
			level.dev_gui_supply_drop = "ammo";
			break;
		case "spyplane":
			level.dev_gui_supply_drop = "radar_sp";
			break;
		case "artillery":
			level.dev_gui_supply_drop = "artillery_sp";
			break;
		case "autoturret":
			level.dev_gui_supply_drop = "autoturret_sp";
			break;
		case "towturret":
			level.dev_gui_supply_drop = "auto_tow_sp";
			break;
		case "mortar":
			level.dev_gui_supply_drop = "mortar_sp";
			break;
		case "heli":
			level.dev_gui_supply_drop = "helicopter_comlink_sp";
			break;
		default:
			break;
		}	
	}
}
#/

dropAllToGround( origin, radius, stickyObjectRadius )
{
	PhysicsExplosionSphere( origin, radius, radius, 0 );
	wait(0.05);
	//maps\mp\gametypes\_weapons::dropWeaponsToGround( origin, radius );
	// grenades are now done in code when an entity they were on gets deleted
//	maps\mp\gametypes\_weapons::dropGrenadesToGround( origin, radius );
	maps\sp_killstreaks\_supplydrop::dropCratesToGround( origin, radius );
	level notify( "drop_objects_to_ground", origin, stickyObjectRadius );
}