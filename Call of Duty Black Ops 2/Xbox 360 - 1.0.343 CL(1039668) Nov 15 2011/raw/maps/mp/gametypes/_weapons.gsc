#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	// assigns weapons with stat numbers from 0-99
	// attachments are now shown here, they are per weapon settings instead
	

	//TODO - add to statstable so its a regular weapon?
	precacheItem( "knife_mp" );
	precacheItem( "knife_held_mp" );
	
	//precacheItem( "frag_grenade_short_mp" );
	precacheItem( "dogs_mp" );
	precacheItem( "dog_bite_mp" );
	precacheItem( "explosive_bolt_mp" );
	
	// Detect models
	PrecacheModel( "weapon_claymore_detect" );
	PrecacheModel( "weapon_c4_mp_detect" );
	PrecacheModel( "t5_weapon_acoustic_sensor_world_detect" );
	PrecacheModel( "t5_weapon_scrambler_world_detect" );
	PrecacheModel( "t5_weapon_camera_spike_world_detect" );
	PrecacheModel( "t5_weapon_camera_head_world_detect" );
	PrecacheModel( "t5_weapon_tactical_insertion_world_detect" );
	PrecacheModel( "t6_wpn_grenade_proximity_world_detect" );
	
	// riot shield
	precacheModel( "t6_wpn_shield_stow_world" );
	precacheModel( "t6_wpn_shield_carry_world" );

	// Extra camera spike models needed
	PrecacheModel( "t5_weapon_camera_head_world" );

	// napalmblob_mp is needed for the molitov and flamethrower
	precacheItem( "napalmblob_mp" );	

	// scavenger_bag_mp needed for the scavenger perk
	precacheItem( "scavenger_item_mp" );
	precacheShader( "hud_scavenger_pickup" );
	
	PreCacheShellShock( "default" );
	precacheShellShock( "concussion_grenade_mp" );
	precacheShellShock( "tabun_gas_mp" );
	precacheShellShock( "tabun_gas_nokick_mp" );
	precacheShellShock( "proximity_grenade" );
	
	thread maps\mp\_flashgrenades::main();
	thread maps\mp\_empgrenade::init();
	thread maps\mp\_entityheadicons::init();

	if ( !isdefined(level.grenadeLauncherDudTime) )
		level.grenadeLauncherDudTime = 0;

	if ( !isdefined(level.thrownGrenadeDudTime) )
		level.thrownGrenadeDudTime = 0;
		
	level thread onPlayerConnect();
	
	maps\mp\gametypes\_weaponobjects::init();
	maps\mp\_tabun::init();
	maps\mp\_smokegrenade::init();
	maps\mp\_heatseekingmissile::init();
	maps\mp\_cameraspike::init();
	maps\mp\_acousticsensor::init();
	maps\mp\_tacticalinsertion::init();
	maps\mp\_scrambler::init();
	maps\mp\_explosive_bolt::init();
	maps\mp\_sticky_grenade::init();
	maps\mp\_proximity_grenade::init();
	maps\mp\_flamethrower_plight::init();
//	maps\mp\killstreaks\_tvguidedmissile::init();
	maps\mp\_ballistic_knife::init();
	maps\mp\_satchel_charge::init();
	maps\mp\_riotshield::init();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedWeapons = false;
		player.hits = 0;
		player scavenger_hud_create();

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		self.concussionEndTime = 0;
		self.hasDoneCombat = false;
		self.shieldDamageBlocked = 0;
		self thread watchWeaponUsage();
		self thread watchGrenadeUsage();
		self thread watchMissileUsage();
		self thread watchWeaponChange();
		self thread watchTurretUse();

		self thread trackWeapon();

		self.droppedDeathWeapon = undefined;
		self.tookWeaponFrom = [];
		
		self thread updateStowedWeapon();
	}
}

watchTurretUse()
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		self waittill( "turretownerchange", turret );

		self thread watchForTOWFire(turret);


	}
}

watchForTOWFire(turret)
{
	self endon("death");
	self endon("disconnect");
	self endon("turretownerchange");

	while(1)
	{
		self waittill( "turret_tow_fire" );

		self thread watchMissleUnlink( turret );

		self waittill( "turret_tow_unlink" );
	}
}

watchMissleUnlink( turret )
{
	self endon("death");
	self endon("disconnect");
	self endon("turretownerchange");

	self waittill( "turret_tow_unlink" );

	self relinkToTurret( turret );
}

watchWeaponChange()
{
	self endon("death");
	self endon("disconnect");
	
	self.lastDroppableWeapon = self GetCurrentWeapon();
	self.hitsThisMag = [];

	weapon = self getCurrentWeapon();
	
	if ( isPrimaryWeapon( weapon ) && !isDefined( self.hitsThisMag[ weapon ] ) )
		self.hitsThisMag[ weapon ] = weaponClipSize( weapon );
	
	while(1)
	{
		previous_weapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );
		
		if ( mayDropWeapon( newWeapon ) )
		{
			self.lastDroppableWeapon = newWeapon;
		}


		if ( newWeapon != "none" )
		{
			if ( ( isPrimaryWeapon( newWeapon ) || issidearm( newWeapon ) ) && !isDefined( self.hitsThisMag[ newWeapon ] ) )
				self.hitsThisMag[ newWeapon ] = weaponClipSize( newWeapon );
		}

		// killstreak weapons will not drop to the ground but will go back into the right dpad if not used
		// if used, take the weapon
		//switch( previous_weapon )
		//{
		//case "minigun_mp":		// death machine
		//case "m202_flash_mp":	// grim reaper
		//case "m220_tow_mp":		// tv guided missile
		//case "mp40_blinged_mp":	// cod5 mp40
		//	if( !self.usedKillstreakWeapon[ previous_weapon ] )
		//	{
		//		maps\mp\killstreaks\_killstreaks::giveKillstreak( self.killstreakType[ previous_weapon ], undefined, undefined, true );
		//	}
		//	self TakeWeapon( previous_weapon );
		//	break;

		//default:
		//	break;
		//}
	}
}

updateLastHeldWeaponTimings( newTime )
{
	if ( isDefined( self.currentWeapon ) && isDefined( self.currentWeaponStartTime ) )
	{
		totalTime = int ( ( newTime - self.currentWeaponStartTime ) / 1000 );
		if ( totalTime > 0 )
		{
			self AddWeaponStat( self.currentWeapon, "timeUsed", totalTime );
			self.currentWeaponStartTime = newTime;
		}
	}
}

updateWeaponTimings( newTime )
{
	if ( self is_bot() )
	{
		return;
	}

	updateLastHeldWeaponTimings( newTime );
	
	if ( !isDefined( self.staticWeaponsStartTime ) )
	{
		return;
	}
	
	totalTime = int ( ( newTime - self.staticWeaponsStartTime ) / 1000 );
	
	if ( totalTime < 0 )
	{
		return;
	}
	
	self.staticWeaponsStartTime = newTime;
	
		
	// Record grenades and equipment 
	if( isDefined( self.weapon_array_grenade ) )
	{
		for( i=0; i<self.weapon_array_grenade.size; i++ )
		{
			self AddWeaponStat( self.weapon_array_grenade[i], "timeUsed", totalTime );
		}
	}
	if( isDefined( self.weapon_array_inventory ) )
	{
		for( i=0; i<self.weapon_array_inventory.size; i++ )
		{
			self AddWeaponStat( self.weapon_array_inventory[i], "timeUsed", totalTime );
		}
	}

	// Record killstreaks
	if( isDefined( self.killstreak ) )
	{
		for( i=0; i<self.killstreak.size; i++ )
		{
			killstreakWeapon = level.menuReferenceForKillStreak[ self.killstreak[i] ];
			if ( isDefined( killstreakWeapon ) )
			{
				self AddWeaponStat( killstreakWeapon, "timeUsed", totalTime );
			}
		}
	}

	// Record all of the equipped perks
	if ( GetDvarint( "scr_game_perks" ) && level.rankedmatch )
	{
		perksIndexArray = [];

		specialtys = self.specialty;
		
		if ( !isDefined( specialtys ) )
		{
			return;
		}

		if ( !isDefined( self.class ) )
		{
			return;
		}
		
		if ( isStrStart( self.class, "CLASS_CUSTOM" ) ) // custom class
		{
			if ( isdefined( self.class_num ) )
			{
				for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
				{
					perk = undefined;
					perk = maps\mp\gametypes\_class::getLoadoutItemFromDDLStats( self.class_num, "specialty" + ( numSpecialties + 1 ) );
					if ( isDefined( perk ) )
					{
						perksIndexArray[ perk ] = true;
					}
				}
			}
		}
		else // default class
		{
			for ( i = 0; i < specialtys.size; i++ )
			{
				specialty = specialtys[i];
				if ( !isDefined( specialty ) )
					continue;

				if ( specialty == "specialty_null" || specialty == "weapon_null" )
					continue;

				if ( isdefined( level.specialtyToPerkIndex[ specialtys[ i ] ] ) )
				{
					basePerkIndex = level.specialtyToPerkIndex[ specialtys[ i ] ];

					if ( isdefined( basePerkIndex ) ) // base version
					{
						perksIndexArray[ basePerkIndex ] = true;
					}
				}
			}
		}

		perkIndexArrayKeys = getarraykeys( perksIndexArray );
		for ( i = 0; i < perkIndexArrayKeys.size; i ++ )
		{
			if ( perksIndexArray[ perkIndexArrayKeys[i] ] == true )
			{
				self AddDStat( "itemStats", perkIndexArrayKeys[i], "stats", "timeUsed", "statValue", totalTime );
			}
		}
	}
}

trackWeapon()
{
	currentWeapon = self getCurrentWeapon();
	currentTime = getTime();
	spawnid = getplayerspawnid( self );

	while(1)
	{
		event = self waittill_any_return( "weapon_change", "death", "disconnect" );
		newTime = getTime();
		
		// BLACKBOX
		bbPrint( "mpweapons", "spawnid %d name %s duration %d", spawnid, currentWeapon, newTime - currentTime );

		if( event == "weapon_change" )
		{
			newWeapon = self getCurrentWeapon();
			if( newWeapon != "none" && newWeapon != currentWeapon )
			{
				updateLastHeldWeaponTimings( newTime );
				self maps\mp\gametypes\_class::initWeaponAttachments( newWeapon );
				
				currentWeapon = newWeapon;
				currentTime = newTime;
			}
		}
		else
		{
			if( event != "disconnect" )
			{
				updateWeaponTimings( newTime );
			}
			
			return;
		}
	}
}

isPistol( weapon )
{
	return isdefined( level.side_arm_array[ weapon ] );
}

//hasScope( weapon )
//{
//	if ( isSubStr( weapon, "_acog_" ) )
//		return true;
//	if ( weapon == "m21_mp" )
//		return true;
//	if ( weapon == "aw50_mp" )
//		return true;
//	if ( weapon == "barrett_mp" )
//		return true;
//	if ( weapon == "dragunov_mp" )
//		return true;
//	if ( weapon == "m40a3_mp" )
//		return true;
//	if ( weapon == "remington700_mp" )
//		return true;
//	return false;
//}

isHackWeapon( weapon )
{
	if ( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( weapon ) )
		return true;
	if ( weapon == "briefcase_bomb_mp" )
		return true;
	return false;
}

mayDropWeapon( weapon )
{
	if ( GetDvarint( "scr_disable_weapondrop" ) == 1 )
		return false;
		
	if ( weapon == "none" )
		return false;
		
	// COMMENTED OUT because kill list said to never drop killstreak weapons
	//// need to do this before isHackWeapon because these will be considered kill streak weapons
	//if( weapon == "minigun_mp" ||
	//	weapon == "m202_flash_mp" ||
	//	weapon == "m220_tow_mp" ||
	//	weapon == "mp40_blinged_mp" )
	//	return true;

	if ( isHackWeapon( weapon ) )
		return false;
	
	invType = WeaponInventoryType( weapon );
	if ( invType != "primary" )
		return false;
	
	if ( weapon == "none" )
		return false;
	
	return true;
}

dropWeaponForDeath( attacker )
{
	if ( GetDvarint( "scr_disable_weapondrop" ) == 1 )
		return;
	
	weapon = self.lastDroppableWeapon;
	
	if ( isdefined( self.droppedDeathWeapon ) )
		return;
	
	if ( !isdefined( weapon ) )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: not defined" );
		#/
		return;
	}

	if ( weapon == "none" )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: weapon == none" );
		#/
		return;
	}
	
	if ( !self hasWeapon( weapon ) )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: don't have it anymore (" + weapon + ")" );
		#/
		return;
	}

	if ( !(self AnyAmmoForWeaponModes( weapon )) )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo for weapon modes" );
		#/
		return;
	}
	
	if ( !shouldDropLimitedWeapon( weapon, self ) )
	{
		return;
	}

	clipAmmo = self GetWeaponAmmoClip( weapon );
	stockAmmo = self GetWeaponAmmoStock( weapon );
	clip_and_stock_ammo = clipAmmo + stockAmmo;

	//Check if the weapon has ammo
	if( !clip_and_stock_ammo )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo" );
		#/
		return;
	}

	stockMax = WeaponMaxAmmo( weapon );
	if ( stockAmmo > stockMax )
		stockAmmo = stockMax;

	item = self dropItem( weapon );
	/#
	if ( GetDvar( "scr_dropdebug") == "1" )
		println( "dropped weapon: " + weapon );
	#/

	dropLimitedWeapon( weapon, self, item );
	
	self.droppedDeathWeapon = true;

	item ItemWeaponSetAmmo( clipAmmo, stockAmmo );

	//we no longer want to remove alt weapon ammo.
	//item itemRemoveAmmoFromAltModes();
	
	item.owner = self;
	item.ownersattacker = attacker;
	
	item thread watchPickup();
	
	item thread deletePickupAfterAWhile();
}

dropWeaponToGround( weapon )
{
	if ( !isdefined( weapon ) )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: not defined" );
		#/
		return;
	}

	if ( weapon == "none" )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: weapon == none" );
		#/
		return;
	}

	if ( !self hasWeapon( weapon ) )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: don't have it anymore (" + weapon + ")" );
		#/
		return;
	}

	if ( !(self AnyAmmoForWeaponModes( weapon )) )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo for weapon modes" );
		#/

		// if any of these then we want to take the weapon when it's empty
		switch( weapon )
		{
		case "minigun_mp":		// death machine
		case "m202_flash_mp":	// grim reaper
		case "m220_tow_mp":		// tv guided missile
		case "mp40_blinged_mp":	// cod5 mp40
			self TakeWeapon( weapon );
			break;

		default:
			break;
		}

		return;
	}

	if ( !shouldDropLimitedWeapon( weapon, self ) )
	{
		return;
	}

	clipAmmo = self GetWeaponAmmoClip( weapon );
	stockAmmo = self GetWeaponAmmoStock( weapon );
	clip_and_stock_ammo = clipAmmo + stockAmmo;

	//Check if the weapon has ammo
	if( !clip_and_stock_ammo )
	{
		/#
		if ( GetDvar( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo" );
		#/
		return;
	}

	stockMax = WeaponMaxAmmo( weapon );
	if ( stockAmmo > stockMax )
		stockAmmo = stockMax;

	item = self dropItem( weapon );
	/#
	if ( GetDvar( "scr_dropdebug") == "1" )
		println( "dropped weapon: " + weapon );
	#/

	dropLimitedWeapon( weapon, self, item );

	item ItemWeaponSetAmmo( clipAmmo, stockAmmo );

	//we no longer want to remove alt weapon ammo.
	//item itemRemoveAmmoFromAltModes();

	item.owner = self;

	item thread watchPickup();

	item thread deletePickupAfterAWhile();
}

deletePickupAfterAWhile()
{
	self endon("death");
	
	wait 60;

	if ( !isDefined( self ) )
		return;

	self delete();
}

getItemWeaponName()
{
	classname = self.classname;
	assert( getsubstr( classname, 0, 7 ) == "weapon_" );
	weapname = getsubstr( classname, 7 );
	return weapname;
}

watchPickup()
{
	self endon("death");
	
	weapname = self getItemWeaponName();
	
	while(1)
	{
		self waittill( "trigger", player, droppedItem );
		
		if ( isdefined( droppedItem ) )
			break;
		// otherwise, player merely acquired ammo and didn't pick this up
	}
	
	/#
	if ( GetDvar( "scr_dropdebug") == "1" )
		println( "picked up weapon: " + weapname + ", " + isdefined( self.ownersattacker ) );
	#/

	assert( isdefined( player.tookWeaponFrom ) );
	
	// make sure the owner information on the dropped item is preserved
	droppedWeaponName = droppedItem getItemWeaponName();
	if ( isdefined( player.tookWeaponFrom[ droppedWeaponName ] ) )
	{
		droppedItem.owner = player.tookWeaponFrom[ droppedWeaponName ];
		droppedItem.ownersattacker = player;
		player.tookWeaponFrom[ droppedWeaponName ] = undefined;
	}
	droppedItem thread watchPickup();
	
	// take owner information from self and put it onto player
	if ( isdefined( self.ownersattacker ) && self.ownersattacker == player )
	{
		player.tookWeaponFrom[ weapname ] = self.owner;
	}
	else
	{
		player.tookWeaponFrom[ weapname ] = undefined;
	}
}

itemRemoveAmmoFromAltModes()
{
	origweapname = self getItemWeaponName();
	
	curweapname = weaponAltWeaponName( origweapname );
	
	altindex = 1;
	while ( curweapname != "none" && curweapname != origweapname )
	{
		self itemWeaponSetAmmo( 0, 0, altindex );
		curweapname = weaponAltWeaponName( curweapname );
		altindex++;
	}
}

dropOffhand()
{
	grenadeTypes = [];
	// no dropping of primary grenades.
	//grenadeTypes[grenadeTypes.size] = "frag_grenade_mp";
	// no dropping of secondary grenades.
	//grenadeTypes[grenadeTypes.size] = "smoke_grenade_mp";
	//grenadeTypes[grenadeTypes.size] = "flash_grenade_mp";
	//grenadeTypes[grenadeTypes.size] = "concussion_grenade_mp";

	for ( index = 0; index < grenadeTypes.size; index++ )
	{
		if ( !self hasWeapon( grenadeTypes[index] ) )
			continue;
			
		count = self getAmmoCount( grenadeTypes[index] );
		
		if ( !count )
			continue;
			
		self dropItem( grenadeTypes[index] );
	}
}

//getWeaponBasedGrenadeCount(weapon)
//{
//	return 2;
//}

//getWeaponBasedSmokeGrenadeCount(weapon)
//{
//	return 1;
//}

//getFragGrenadeCount()
//{
//	grenadetype = "frag_grenade_mp";
//
//	count = self getammocount(grenadetype);
//	return count;
//}

//getSmokeGrenadeCount()
//{
//	grenadetype = "smoke_grenade_mp";
//
//	count = self getammocount(grenadetype);
//	return count;
//}

watchWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	// need to know if we used a killstreak weapon
	self.usedKillstreakWeapon = [];
	self.usedKillstreakWeapon["minigun_mp"] = false;
	self.usedKillstreakWeapon["m202_flash_mp"] = false;
	self.usedKillstreakWeapon["m220_tow_mp"] = false;
	self.usedKillstreakWeapon["mp40_blinged_mp"] = false;
	self.killstreakType = [];
	self.killstreakType["minigun_mp"] = "minigun_mp";
	self.killstreakType["m202_flash_mp"] = "m202_flash_mp";
	self.killstreakType["m220_tow_mp"] = "m220_tow_mp";
	self.killstreakType["mp40_blinged_mp"] = "mp40_blinged_drop_mp";

	for ( ;; )
	{	
		self waittill ( "weapon_fired", curWeapon );

		self.hasDoneCombat = true;
		
		if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( curWeapon ) || maps\mp\gametypes\_weapons::isSideArm( curWeapon ) )
		{
			if ( isDefined( self.hitsThisMag[ curWeapon ] ) )
				self thread updateMagShots( curWeapon );
		}
		
		switch ( weaponClass( curWeapon ) )
		{
			case "rifle":
				if( curWeapon == "crossbow_explosive_mp" )
				{
					level.globalCrossbowFired++;
					self AddWeaponStat( curWeapon, "shots", 1 );
					self thread beginGrenadeTracking();
					break;
				}
			case "pistol":
			case "mg":
			case "smg":
			case "spread":
				self trackWeaponFire( curWeapon );
				level.globalShotsFired++;
				break;
			case "rocketlauncher":
			case "grenade":
				self AddWeaponStat( curWeapon, "shots", 1 );
				self thread maps\mp\gametypes\_shellshock::rocket_earthQuake();
				break;
			default:
				break;
		}

		switch( curWeapon )
		{
		case "bazooka_mp":
			self AddWeaponStat( curWeapon, "shots", 1 );
			break;

		case "minigun_mp":		// death machine
		case "m202_flash_mp":	// grim reaper
		case "m220_tow_mp":		// tv guided missile
		case "mp40_blinged_mp":	// cod5 mp40
			self.usedKillstreakWeapon[ curWeapon ] = true;
			break;

		default:
			break;
		}
	}
}



updateMagShots( weaponName )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "updateMagShots_" + weaponName );

	self.hitsThisMag[ weaponName ]--;
	
	wait ( 0.05 );
	
	self.hitsThisMag[ weaponName ] = weaponClipSize( weaponName );
}


checkHitsThisMag( weaponName )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	self notify ( "updateMagShots_" + weaponName );
	waittillframeend;
	
	if ( self.hitsThisMag[ weaponName ] == 0 )
	{
		weaponClass = maps\mp\gametypes\_missions::getWeaponClass( weaponName );
		
		maps\mp\_challenges::fullClipNoMisses( weaponClass, weaponName );

		self.hitsThisMag[ weaponName ] = weaponClipSize( weaponName );
	}	
}


trackWeaponFire( curWeapon )
{
	shotsFired = 1;

	if ( isDefined( self.lastStandParams ) && self.lastStandParams.lastStandStartTime == getTime() )
	{
		self.hits = 0;
		return;
	}
	
	pixbeginevent("trackWeaponFire");
	self AddWeaponStat( curWeapon, "shots", shotsFired );
	self AddWeaponStat( curWeapon, "hits", self.hits );
	
	self AddPlayerStat( "total_shots", shotsFired );		
	self AddPlayerStat( "hits", self.hits );
	self AddPlayerStat( "misses", int( max( 0, shotsFired - self.hits ) ) );

	self.hits = 0;
	pixendevent();
}

checkHit( sWeapon )
{
	switch ( weaponClass( sWeapon ) )
	{
		case "rifle":
		case "pistol":
		case "mg":
		case "smg":
			self.hits++;
			break;
		case "spread":
			self.hits = 1;
			break;
		default:
			break;
	}
	
	// sometimes the "weapon_fired" notify happens after we hit the guy...
	waittillframeend;
	
	if ( isdefined( self.hitsThisMag ) && isDefined( self.hitsThisMag[ sWeapon ] ) )
	{
		self thread checkHitsThisMag( sWeapon );
	}
	
	if ( ( sWeapon == "bazooka_mp" ) || isStrStart( sWeapon, "t34" ) || isStrStart( sWeapon, "panzer" ) )
	{
		self AddWeaponStat( sWeapon, "hits", 1 );
	}
}

watchGrenadeUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
		
	self thread beginOtherGrenadeTracking();
	
	self thread watchForThrowbacks();
	self thread watchForGrenadeDuds();
	self thread watchForGrenadeLauncherDuds();

	for ( ;; )
	{
		self waittill ( "grenade_pullback", weaponName );
		
		self AddWeaponStat( weaponName, "shots", 1 );

		
		self.hasDoneCombat = true;
	 	
	 	/*if ( weaponName == "claymore_mp" )
			continue;*/
		
		self.throwingGrenade = true;
		self.gotPullbackNotify = true;
		
		if ( weaponName == "satchel_charge_mp" )
		{
			self thread beginSatchelTracking();
		}

		self thread beginGrenadeTracking();
	}
}

watchMissileUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	for ( ;; )
	{	
		self waittill ( "missile_fire", missile, weapon_name );

		self.hasDoneCombat = true;
	}
}

dropWeaponsToGround( origin, radius )
{
	weapons = GetDroppedWeapons();
	for ( i = 0 ; i < weapons.size ; i++ )
	{
		if ( DistanceSquared( origin, weapons[i].origin ) < radius * radius )
		{
			trace = bullettrace( weapons[i].origin, weapons[i].origin + (0,0,-2000), false, weapons[i] );
			weapons[i].origin = trace["position"];
		}
	}
}

dropGrenadesToGround( origin, radius )
{
	grenades = getentarray( "grenade", "classname" );
	for( i = 0 ; i < grenades.size ; i++ )
	{
		if( DistanceSquared( origin, grenades[i].origin )< radius * radius )
		{
			grenades[i] launch( (5,5,5) );
		}
	}
}

watchGrenadeCancel()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "grenade_fire" );
	
	self waittill( "weapon_change" );
	
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
}

beginGrenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	startTime = getTime();
	
	self thread watchGrenadeCancel();
	
	self waittill ( "grenade_fire", grenade, weaponName );

	if ( grenade maps\mp\gametypes\_weaponobjects::isHacked() )
	{
		return;
	}
	
	if ( (getTime() - startTime > 1000) )
		grenade.isCooked = true;
	
	switch( weaponName )
	{
	case "frag_grenade_mp":
		level.globalFragGrenadesFired++;
		// fall through on purpose
	case "sticky_grenade_mp":
		self AddWeaponStat( weaponName, "used", 1 );
		// fall through on purpose
	case "explosive_bolt_mp":
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		grenade.originalOwner = self;
		break;
	case "satchel_charge_mp":
		level.globalSatchelChargeFired++;
		grenade thread maps\mp\gametypes\_shellshock::satchel_earthQuake();
		break;
	case "c4_mp":
		grenade thread maps\mp\gametypes\_shellshock::c4_earthQuake();
		break;
	}

	if ( weaponName == "sticky_grenade_mp" || weaponName == "frag_grenade_mp" )
	{
		grenade SetTeam( self.pers["team"] );
		grenade SetOwner( self );
	}
		
	self.throwingGrenade = false;
}

// AE 10-27-09: changed begineSpecialGrenadeTracking to just beginOtherGrenadeTracking to make sense with tracking them all
beginOtherGrenadeTracking()
{
	self notify( "grenadeTrackingStart" );
	
	self endon( "grenadeTrackingStart" );
	self endon( "disconnect" );
	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weaponName, parent );

		if ( grenade maps\mp\gametypes\_weaponobjects::isHacked() )
		{
			continue;
		}
		
		switch( weaponName )
		{
		// TODO: add watch detonation functions that we can then check what surface they explode on
		//case "incendiary_grenade_mp":
		//	grenade thread maps\mp\_incendiary::watchIncendiaryGrenadeDetonation( self );
		//	break;
		case "flash_grenade_mp":
			break;
		case "concussion_grenade_mp":
			break;
		case "willy_pete_mp":
			grenade thread maps\mp\_smokegrenade::watchSmokeGrenadeDetonation( self );
			break;
		case "tabun_gas_mp":
			grenade thread maps\mp\_tabun::watchTabunGrenadeDetonation( self );
			break;
		case "signal_flare_mp":
			grenade thread maps\mp\_flare::watchFlareDetonation( self );
			break;
		case "sticky_grenade_mp":
		case "satchel_charge_mp":
		case "c4_mp":
			grenade thread checkStuckToPlayer();
			break;
		case "proximity_grenade_mp":
			grenade thread maps\mp\_proximity_grenade::watchProximityGrenadeDetonation( self );
			break;
		case "tactical_insertion_mp":
			grenade thread maps\mp\_tacticalinsertion::watch( self );
			break;
		case "scrambler_mp":
			break;
		case "explosive_bolt_mp":
			grenade thread maps\mp\_explosive_bolt::watch_bolt_detonation( self );
			grenade thread checkStuckToPlayer();
			break;
		case "hatchet_mp":
			grenade thread checkHatchetBounce();
			grenade thread checkStuckToPlayer( false );
			self AddWeaponStat( weaponName, "used", 1 );
			break;
		}
	}
}

checkStuckToPlayer( deleteOnTeamChange )
{
	self endon( "death" );

	self waittill( "stuck_to_player", player );
	if ( isdefined ( player ) )
	{
		if ( !IsDefined( deleteOnTeamChange ) || deleteOnTeamChange )
			self thread stuckToPlayerTeamChange( player );
		self.stuckToPlayer = player;
	}
}

checkHatchetBounce()
{
	self endon( "stuck_to_player" );
	self endon( "death");
	self waittill( "grenade_bounce" );
	self.bounced = true;
}

stuckToPlayerTeamChange( player )
{
	self endon("death");
	player endon("disconnect");
	originalTeam = player.pers["team"];

	while(1)
	{
		player waittill("joined_team");
		
		if ( player.pers["team"] != originalTeam )
		{
			self detonate();
			return;
		}
	}
}

beginSatchelTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	self waittill_any ( "grenade_fire", "weapon_change" );
	self.throwingGrenade = false;
}

watchForThrowbacks()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapname );
		if ( self.gotPullbackNotify )
		{
			self.gotPullbackNotify = false;
			continue;
		}
		if ( !isSubStr( weapname, "frag_" ) )
			continue;
		
		// no grenade_pullback notify! we must have picked it up off the ground.
		grenade.threwBack = true;
		
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		grenade.originalOwner = self;
	}
}


//watchSatchel()
//{
//	self endon( "spawned_player" );
//	self endon( "disconnect" );
//
//	//maxSatchels = 2;
//
//	while(1)
//	{
//		self waittill( "grenade_fire", satchel, weapname );
//		if ( weapname == "satchel_charge" || weapname == "satchel_charge_mp" )
//		{
//			if ( !self.satchelarray.size )
//				self thread watchsatchelAltDetonate();
//			self.satchelarray[self.satchelarray.size] = satchel;
//			satchel.owner = self;
//			satchel thread bombDetectionTrigger_wait( self.pers["team"] );
//			satchel thread maps\mp\gametypes\_shellshock::satchel_earthQuake();
//			satchel thread satchelDamage();
//		}
//	}
//}

registerGrenadeLauncherDudDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_grenadeLauncherDudTime");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.grenadeLauncherDudTimeDvar = dvarString;	
	level.grenadeLauncherDudTimeMin = minValue;
	level.grenadeLauncherDudTimeMax = maxValue;
	level.grenadeLauncherDudTime = getDvarInt( level.grenadeLauncherDudTimeDvar );
}

registerThrownGrenadeDudDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_thrownGrenadeDudTime");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.thrownGrenadeDudTimeDvar = dvarString;	
	level.thrownGrenadeDudTimeMin = minValue;
	level.thrownGrenadeDudTimeMax = maxValue;
	level.thrownGrenadeDudTime = getDvarInt( level.thrownGrenadeDudTimeDvar );
}

registerKillstreakDelay( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_killstreakDelayTime");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );

	level.killstreakRoundDelay = getDvarInt( dvarString );
}

turnGrenadeIntoADud( weapname, isThrownGrenade, player )
{
	if ( level.grenadeLauncherDudTime >= (maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000) && !isThrownGrenade )
	{
		if ( isSubStr( weapname, "gl_" ) || weapname == "china_lake_mp" )
		{
			timeLeft = Int( level.grenadeLauncherDudTime - (maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000) );

			if( !timeLeft )
				timeLeft = 1;

			player iPrintLnBold( &"MP_LAUNCHER_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );
			self makeGrenadeDud();
		}
	}
	else if( level.thrownGrenadeDudTime >= (maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000) && isThrownGrenade )
	{
		if( weapname == "frag_grenade_mp" || weapname == "sticky_grenade_mp" )
		{
			if( isDefined(player.suicide) && player.suicide )
				return;

			timeLeft = Int( level.thrownGrenadeDudTime - (maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000) );
		
			if( !timeLeft )
				timeLeft = 1;

			player iPrintLnBold( &"MP_GRENADE_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );
			self makeGrenadeDud();
		}
	}
}

watchForGrenadeDuds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while(1)
	{
		self waittill( "grenade_fire", grenade, weapname );
		grenade turnGrenadeIntoADud(weapname, true, self);
	}
}

watchForGrenadeLauncherDuds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while(1)
	{
		self waittill( "grenade_launcher_fire", grenade, weapname );
		grenade turnGrenadeIntoADud(weapname, false, self);
	}
}


// these functions are used with scripted weapons (like satchels, shoeboxs, artillery)
// returns an array of objects representing damageable entities (including players) within a given sphere.
// each object has the property damageCenter, which represents its center (the location from which it can be damaged).
// each object also has the property entity, which contains the entity that it represents.
// to damage it, call damageEnt() on it.
getDamageableEnts(pos, radius, doLOS, startRadius)
{
	ents = [];
	
	if (!isdefined(doLOS))
		doLOS = false;
		
	if ( !isdefined( startRadius ) )
		startRadius = 0;
	
	// players
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]) || players[i].sessionstate != "playing")
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		distsq = distancesquared(pos, playerpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, playerpos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
			newent.isADestructible = false;
			newent.isActor = false;
			newent.entity = players[i];
			newent.damageCenter = playerpos;
			ents[ents.size] = newent;
		}
	}
	
	// grenades
	grenades = getentarray("grenade", "classname");
	for (i = 0; i < grenades.size; i++)
	{
		entpos = grenades[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.isADestructible = false;
			newent.isActor = false;
			newent.entity = grenades[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	// THIS IS NOT THE SAME AS THE destruct-A-bles BELOW
	destructibles = getentarray("destructible", "targetname");		
	for (i = 0; i < destructibles.size; i++)
	{
		entpos = destructibles[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructibles[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.isADestructible = true;
			newent.isActor = false;
			newent.entity = destructibles[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}

	// THIS IS NOT THE SAME AS THE destruct-I-bles ABOVE
	destructables = getentarray("destructable", "targetname");
	for (i = 0; i < destructables.size; i++)
	{
		entpos = destructables[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = true;
			newent.isADestructible = false;
			newent.isActor = false;
			newent.entity = destructables[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}

	dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();
	
	foreach( dog in dogs )
	{
		if ( !IsAlive( dog ) )
		{
			continue;
		}

		entpos = dog.origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, dog)))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.isADestructible = false;
			newent.isActor = true;
			newent.entity = dog;
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	return ents;
}

weaponDamageTracePassed(from, to, startRadius, ignore)
{
	trace = weaponDamageTrace(from, to, startRadius, ignore);	
	return (trace["fraction"] == 1);
}

weaponDamageTrace(from, to, startRadius, ignore)
{
	midpos = undefined;
	
	diff = to - from;
	if ( lengthsquared( diff ) < startRadius*startRadius )
		midpos = to;
	dir = vectornormalize( diff );
	midpos = from + (dir[0]*startRadius, dir[1]*startRadius, dir[2]*startRadius);

	trace = bullettrace(midpos, to, false, ignore);
	
	if ( GetDvarint( "scr_damage_debug") != 0 )
	{
		if (trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1,1,1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1,.9,.8));
			thread debugline(trace["position"], to, (1,.4,.3));
		}
	}
	
	return trace;
}

// eInflictor = the entity that causes the damage (e.g. a shoebox)
// eAttacker = the player that is attacking
// iDamage = the amount of damage to do
// sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
// sWeapon = string specifying the weapon used (e.g. "mine_shoebox_mp")
// damagepos = the position damage is coming from
// damagedir = the direction damage is moving in
damageEnt(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, damagepos, damagedir)
{
	if (self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			eAttacker, // eAttacker The entity that is attacking.
			iDamage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			sWeapon, // sWeapon The weapon number of the weapon used to inflict the damage
			damagepos, // vPoint The point the damage is from?
			damagedir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			0 // psOffsetTime The time offset for the damage
		);
	}
	else if (self.isactor)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackActorDamage]](
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			eAttacker, // eAttacker The entity that is attacking.
			iDamage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			sWeapon, // sWeapon The weapon number of the weapon used to inflict the damage
			damagepos, // vPoint The point the damage is from?
			damagedir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			0 // psOffsetTime The time offset for the damage
		);
	}
	else if (self.isADestructible)
	{
		self.damageOrigin = damagepos;
		self.entity DoDamage(
			iDamage, // iDamage Integer specifying the amount of damage done
			damagepos, // vPoint The point the damage is from?
			eAttacker, // eAttacker The entity that is attacking.
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			0, 
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sWeapon // sWeapon The weapon number of the weapon used to inflict the damage
		);
	}
	else
	{
		// destructable walls and such can only be damaged in certain ways.
		if ( self.isADestructable && (sWeapon == "artillery_mp" || sWeapon ==  "claymore_mp" ||  sWeapon == "airstrike_mp" ||  sWeapon == "napalm_mp" ) )
			return;

		self.entity damage_notify_wrapper( iDamage, eAttacker, (0,0,0), (0,0,0), "mod_explosive", "", "" );		
	}
}

debugline(a, b, color)
{
	for (i = 0; i < 30*20; i++)
	{
		line(a,b, color);
		wait .05;
	}
}


onWeaponDamage( eAttacker, eInflictor, sWeapon, meansOfDeath, damage )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	switch( sWeapon )
	{
		case "concussion_grenade_mp":
			// should match weapon settings in gdt
			radius = 512;
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			if ( scale < 0 )
				scale = 0;
			
			time = 2 + (4 * scale);
			
			wait ( 0.05 );

			if ( self HasPerk ( "specialty_stunprotection" ) )
			{
				// do a little bit, not a complete negation
				time *= 0.1;
			}

			self thread playConcussionSound( time );
			
			if ( self mayApplyScreenEffect() )
				self shellShock( "concussion_grenade_mp", time );
			self.concussionEndTime = getTime() + (time * 1000);
			break;
		
		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
			break;
	}
}

playConcussionSound( duration )
{	
	self endon( "death" );
	self endon( "disconnect" );

	concussionSound = spawn ("script_origin",(0,0,1));
	concussionSound.origin = self.origin;
	concussionSound linkTo( self );
	concussionSound thread deleteEntOnOwnerDeath( self );
	concussionSound playsound( "" );
	concussionSound playLoopSound ( "" );
	if ( duration > 0.5 )
		wait( duration - 0.5 );
	concussionSound playsound( "" );
	concussionSound StopLoopSound( .5);
	wait(0.5);

	concussionSound notify ( "delete" );
	concussionSound delete();
}

deleteEntOnOwnerDeath( owner )
{
	self endon( "delete" );
	owner waittill( "death" );
	self delete();	
}

monitor_dog_special_grenades() // self == dog
{
	// watch and see if the dog gets damage from a flash or concussion
	//	smoke and tabun handle themselves
	self endon("death");

	while(1)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );

		if( damage < 5 )
		{
			damage_area = Spawn( "trigger_radius", self.origin, 0, 128, 128 );
			attacker thread maps\mp\killstreaks\_dogs::flash_dogs( damage_area );
			wait(0.05);
			damage_area delete();
		}
	}
}

// weapon stowing logic ===================================================================

// weapon class boolean helpers
isPrimaryWeapon( weaponname )
{
	return isdefined( level.primary_weapon_array[weaponname] );
}
isSideArm( weaponname )
{
	return isdefined( level.side_arm_array[weaponname] );
}
isInventory( weaponname )
{
	return isdefined( level.inventory_array[weaponname] );
}
isGrenade( weaponname )
{
	return isdefined( level.grenade_array[weaponname] );
}
getWeaponClass_array( current )
{
	if( isPrimaryWeapon( current ) )
		return level.primary_weapon_array;
	else if( isSideArm( current ) )
		return level.side_arm_array;
	else if( isGrenade( current ) )
		return level.grenade_array;
	else
		return level.inventory_array;
}

// thread loop life = player's life
updateStowedWeapon()
{
	self endon( "spawned" );
	self endon( "killed_player" );
	self endon( "disconnect" );
	
	//detach_all_weapons();
	
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	
	team = self.pers["team"];
	class = self.pers["class"];
	
	while ( true )
	{
		self waittill( "weapon_change", newWeapon );
		
		// weapon array reset, might have swapped weapons off the ground
		self.weapon_array_primary =[];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory =[];
	
		// populate player's weapon stock arrays
		weaponsList = self GetWeaponsList();
		for( idx = 0; idx < weaponsList.size; idx++ )
		{
			// we don't want these in the primary list
			switch( weaponsList[idx] )
			{
			case "minigun_mp":		// death machine
			case "m202_flash_mp":	// grim reaper
			case "m220_tow_mp":		// tv guided missile
			case "mp40_blinged_mp":	// cod5 mp40
			case "zipline_mp":
				continue;

			default:
				break;
			}

			if ( isPrimaryWeapon( weaponsList[idx] ) )
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
			else if ( isSideArm( weaponsList[idx] ) )
				self.weapon_array_sidearm[self.weapon_array_sidearm.size] = weaponsList[idx];
			else if ( isGrenade( weaponsList[idx] ) )
				self.weapon_array_grenade[self.weapon_array_grenade.size] = weaponsList[idx];
			else if ( isInventory( weaponsList[idx] ) )
				self.weapon_array_inventory[self.weapon_array_inventory.size] = weaponsList[idx];
			else if ( IsWeaponPrimary(weaponsList[idx]) )
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
		}

		detach_all_weapons();
		stow_on_back();	
		stow_on_hip();
	}
}

forceStowedWeaponUpdate()
{
	detach_all_weapons();
	stow_on_back();
	stow_on_hip();
}

detachCarryObjectModel()
{
	if ( isDefined( self.carryObject ) && isdefined(self.carryObject maps\mp\gametypes\_gameobjects::getVisibleCarrierModel())  )
	{
		if( isDefined( self.tag_stowed_back ) )
		{
			self detach( self.tag_stowed_back, "tag_stowed_back" );
			self.tag_stowed_back = undefined;
		}
	}
}

detach_all_weapons()
{
	if( isDefined( self.tag_stowed_back ) )
	{
		self detach( self.tag_stowed_back, "tag_stowed_back" );
		self.tag_stowed_back = undefined;
	}
	if( isDefined( self.tag_stowed_hip ) )
	{
		detach_model = getWeaponModel( self.tag_stowed_hip );
		self detach( detach_model, "tag_stowed_hip_rear" );
		self.tag_stowed_hip = undefined;
	}
}

// this should probably be a gdt weapon entry
// if you need to add another just make it a gdt entry
non_stowed_weapon( weapon )
{
	if ( self hasWeapon( "knife_ballistic_mp" ) && weapon != "knife_ballistic_mp" ) 
		return true;
	if ( self hasWeapon( "knife_held_mp" ) && weapon != "knife_held_mp" ) 
		return true;
	
	return false;
}

stow_on_back(current)
{
	current = self getCurrentWeapon();

	self.tag_stowed_back = undefined;
	weaponOptions = 0;
	index_weapon = "";

	//  carry objects take priority
	if ( isDefined( self.carryObject ) && isdefined(self.carryObject maps\mp\gametypes\_gameobjects::getVisibleCarrierModel())  )
	{
		self.tag_stowed_back = self.carryObject maps\mp\gametypes\_gameobjects::getVisibleCarrierModel();
	}
	else if ( non_stowed_weapon( current ) || ( self.hasRiotShield ))
	{
		// no back stowing if you have ballistic knife or riotshield
		return;
	}

	//  large projectile weaponry always show
	/*else if( (self hasWeapon( "rpg_mp" ) && current != "rpg_mp") )
	{
		self.tag_stowed_back = "weapon_rpg7_stow";
		index_weapon = "weapon_rpg7_stow";
	}
	else if( (self hasWeapon( "strela_mp" ) && current != "strela_mp") )
	{
		self.tag_stowed_back = "t5_weapon_strela_stow";
		index_weapon = "t5_weapon_strela_stow";
	}
	else if( (self hasWeapon( "m72_law_mp" ) && current != "m72_law_mp") )
	{
		self.tag_stowed_back = "t5_weapon_law_stow";
		index_weapon = "t5_weapon_law_stow";
	}*/
	/*else if( (self hasWeapon( "crossbow_explosive_mp" ) && current != "crossbow_explosive_mp") )
	{
		self.tag_stowed_back = "t5_weapon_mp_crossbow_stow";
		index_weapon = "t5_weapon_mp_crossbow_stow";
	}*/
	else
	{
		for ( idx = 0; idx < self.weapon_array_primary.size; idx++ )
		{

			temp_index_weapon = self.weapon_array_primary[idx];
			assert( isdefined( temp_index_weapon ), "Primary weapon list corrupted." );

			if ( temp_index_weapon == current )
				continue;

			/*
			if ( (isSubStr( current, "gl_" ) || isSubStr( current, "_gl_" )) && (isSubStr( self.weapon_array_primary[idx], "gl_" ) || isSubStr( self.weapon_array_primary[idx], "_gl_" )) )
			continue; 
			*/

			if( isSubStr( current, "gl_" ) || isSubStr( temp_index_weapon, "gl_" ) ||
				isSubStr( current, "mk_" ) || isSubStr( temp_index_weapon, "mk_" ) || 
				isSubStr( current, "ft_" ) || isSubStr( temp_index_weapon, "ft_" ) )
			{
				index_weapon_tok = strtok( temp_index_weapon, "_" );
				current_tok = strtok( current, "_" );
				// finding the alt-mode of current weapon; the tokens of both weapons are subsets of each other
				for( i=0; i<index_weapon_tok.size; i++ ) 
				{
					if( !isSubStr( current, index_weapon_tok[i] ) || index_weapon_tok.size != current_tok.size )
					{
						i = 0;
						break;
					}
				}
				if( i == index_weapon_tok.size )
					continue;
			}

			index_weapon = temp_index_weapon;

			// camo only applicable for custom classes
			assert( isdefined( self.curclass ), "Player missing current class" );
			if ( isDefined( self.custom_class ) && isDefined( self.custom_class[self.class_num]["camo_num"] ) && isSubStr( index_weapon, self.pers["primaryWeapon"] ) && isSubStr( self.curclass, "CUSTOM" ) )
			{
				self.tag_stowed_back = getWeaponModel( index_weapon, self.custom_class[self.class_num]["camo_num"] );
			}
			else
			{
				stowedModelIndex = GetWeaponStowedModel(index_weapon);
				self.tag_stowed_back = getWeaponModel( index_weapon, stowedModelIndex );
			}
			
			if ( isDefined( self.custom_class ) && isDefined( self.custom_class[self.class_num]["weapon_options"] ) )
			{
				weaponOptions = self.custom_class[self.class_num]["weapon_options"];
			}
		}
	}

	if ( !isDefined( self.tag_stowed_back ) )
		return;

	self attach( self.tag_stowed_back, "tag_stowed_back", true, weaponOptions, index_weapon );
}

stow_on_hip()
{
	current = self getCurrentWeapon();

	self.tag_stowed_hip = undefined;
	/*
	for ( idx = 0; idx < self.weapon_array_sidearm.size; idx++ )
	{
		if ( self.weapon_array_sidearm[idx] == current )
			continue;
			
		self.tag_stowed_hip = self.weapon_array_sidearm[idx];
	}
	*/

	for ( idx = 0; idx < self.weapon_array_inventory.size; idx++ )
	{
		if ( self.weapon_array_inventory[idx] == current )
			continue;

		if ( !self GetWeaponAmmoStock( self.weapon_array_inventory[idx] ) )
			continue;
			
		self.tag_stowed_hip = self.weapon_array_inventory[idx];
	}

	if ( !isDefined( self.tag_stowed_hip ) )
		return;

	// getting rid of these until we get attach models
	if ( self.tag_stowed_hip == "satchel_charge_mp" || self.tag_stowed_hip == "claymore_mp" )
	{
		self.tag_stowed_hip = undefined;
		return;
	}
		
	weapon_model = getWeaponModel( self.tag_stowed_hip );
	self attach( weapon_model, "tag_stowed_hip_rear", true );
}


stow_inventory( inventories, current )
{
	// deatch last weapon attached
	if( isdefined( self.inventory_tag ) )
	{
		detach_model = getweaponmodel( self.inventory_tag );
		self detach( detach_model, "tag_stowed_hip_rear" );
		self.inventory_tag = undefined;
	}

	if( !isdefined( inventories[0] ) || self GetWeaponAmmoStock( inventories[0] ) == 0 )
		return;

	if( inventories[0] != current )
	{
		self.inventory_tag = inventories[0];
		weapon_model = getweaponmodel( self.inventory_tag );
		self attach( weapon_model, "tag_stowed_hip_rear", true );
	}
}


// returns dvar value in int
weapons_get_dvar_int( dvar, def )
{
	return int( weapons_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
weapons_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}


// this function is only for non-remotecontrolled vehicles
player_is_driver()
{
	if ( !isalive(self) )
		return false;
		
	if ( self IsRemoteControlling() )
		return false;
		
	vehicle = self GetVehicleOccupied();
	
	if ( IsDefined( vehicle ) )
	{
		seat = vehicle GetOccupantSeat( self );
		
		if ( isdefined(seat) && seat == 0 )
			return true;
	}
	
	return false;
}

scavenger_think()
{
	self endon( "death" );
	self waittill( "scavenger", player );

	primary_weapons = player GetWeaponsListPrimaries();
	offhand_weapons = array_exclude( player GetWeaponsList(), primary_weapons );
	offhand_weapons = array_remove( offhand_weapons, "knife_mp" );

	player playsound( "fly_equipment_pickup_npc" );
	player playlocalsound( "fly_equipment_pickup_plr" );
	player maps\mp\_properks::scavenged();

	player.scavenger_icon.alpha = 1;
	player.scavenger_icon fadeOverTime( 2.5 );
	player.scavenger_icon.alpha = 0;

	for ( i = 0; i < offhand_weapons.size; i++ )
	{
		weapon = offhand_weapons[i];

		if ( isHackWeapon( weapon ) || isLauncherWeapon( weapon ))
		{
			continue;
		}

		switch ( weapon )
		{
		case "frag_grenade_mp":
		case "sticky_grenade_mp":
		case "hatchet_mp":
		case "proximity_grenade_mp":
		case "flash_grenade_mp":
		case "concussion_grenade_mp":
		case "tabun_gas_mp":
		case "nightingale_mp":
		case "emp_grenade_mp":
		
			maxAmmo = WeaponMaxAmmo( weapon );

			// just give 1 for each scavenger pick up
			stock = player GetWeaponAmmoStock( weapon );

			if ( isdefined( player.grenadeTypePrimary ) && weapon == player.grenadeTypePrimary )
			{
				maxAmmo = player.custom_class[player.class_num]["grenades_count"];
			}
			else if ( isdefined( player.grenadeTypeSecondary ) && weapon == player.grenadeTypeSecondary )
			{
				maxAmmo = player.custom_class[player.class_num]["specialgrenades_count"];
			}

			if ( stock < maxAmmo )
			{
				ammo = stock + 1;
				player SetWeaponAmmoStock( weapon, ammo );
				player thread maps\mp\_properks::scavengedGrenade();
			}
			break;

		case "willy_pete_mp":
		default:
			break;
		}
	}

	for ( i = 0; i < primary_weapons.size; i++ )
	{
		weapon = primary_weapons[i];

		if ( isHackWeapon( weapon ) || isLauncherWeapon( weapon ) )
		{
			continue;
		}

		stock = player GetWeaponAmmoStock( weapon );
		start = player GetFractionStartAmmo( weapon );
		clip = WeaponClipSize( weapon );
		maxAmmo = WeaponMaxAmmo( weapon );

		if ( stock < maxAmmo - clip )
		{
			ammo = stock + clip;
			player SetWeaponAmmoStock( weapon, ammo );
		}

		else
		{
			player SetWeaponAmmoStock( weapon, maxAmmo );
		}
	}
}

scavenger_hud_create()
{
	if( level.wagerMatch )
		return;

	self.scavenger_icon = NewClientHudElem( self );
	self.scavenger_icon.horzAlign = "center";
	self.scavenger_icon.vertAlign = "middle";
	self.scavenger_icon.x = -36;
	self.scavenger_icon.y = 32;
	self.scavenger_icon.alpha = 0;

	width = 64;
	height = 32;

	if ( level.splitscreen )
	{
		width = Int( width * 0.5 );
		height = Int( height * 0.5 );
		self.scavenger_icon.x = -18;
	}

	self.scavenger_icon setShader( "hud_scavenger_pickup", width, height );
}

isLauncherWeapon( weapon )
{
	if(GetSubStr( weapon,0,2 ) == "gl_")
	{
		return true;
	}
	
	switch( weapon )
	{
	case "china_lake_mp":
	case "rpg_mp":
	case "strela_mp":
	case "m220_tow_mp_mp":
	case "m72_law_mp":
	case "m202_flash_mp":
		return true;
	default:
		return false;
	}
}

dropScavengerForDeath( attacker )
{
	if( SessionModeIsZombiesGame() )
		return;
		
	if( level.wagerMatch )
		return;

	if( !isDefined( attacker ) )
 		return;

 	if( attacker == self )
 		return;

	item = self dropScavengerItem( "scavenger_item_mp" );
	item thread scavenger_think();
}


// if we need to store multiple drop limited weapons, we'll need to store an array on the player entity
addLimitedWeapon( weapon_name, owner, num_drops )
{
	limited_info = SpawnStruct();
	limited_info.weapon = weapon_name;
	limited_info.drops = num_drops;

	owner.limited_info = limited_info;
}

shouldDropLimitedWeapon( weapon_name, owner )
{
	limited_info = owner.limited_info;
		
	if ( !IsDefined( limited_info ) )
	{
		return true;
	}

	if ( limited_info.weapon != weapon_name )
	{
		return true;
	}

	if ( limited_info.drops <= 0 )
	{
		return false;
	}

	return true;
}


dropLimitedWeapon( weapon_name, owner, item )
{
	limited_info = owner.limited_info;

	if ( !IsDefined( limited_info ) )
	{
		return;
	}

	if ( limited_info.weapon != weapon_name )
	{
		return;
	}

	limited_info.drops = limited_info.drops - 1;
	owner.limited_info = undefined;

	item thread limitedPickup( limited_info );
}


limitedPickup( limited_info )
{
	self endon( "death" );
	self waittill( "trigger", player, item );

	if ( !IsDefined( item ) )
	{
		return;
	}

	player.limited_info = limited_info;
}