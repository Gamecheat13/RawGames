#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_weapon_utils;

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
	PrecacheModel( "t6_wpn_claymore_world_detect" );
	PrecacheModel( "t6_wpn_c4_world_detect" );
	PrecacheModel( "t5_weapon_scrambler_world_detect" );
	PrecacheModel( "t6_wpn_tac_insert_detect" );
	PrecacheModel( "t6_wpn_taser_mine_world_detect" );
	PrecacheModel( "t6_wpn_motion_sensor_world_detect" );
	PrecacheModel( "t6_wpn_trophy_system_world_detect" );
	precacheModel( "t6_wpn_bouncing_betty_world_detect" );
	
	// riot shield
	precacheModel( "t6_wpn_shield_stow_world" );
	precacheModel( "t6_wpn_shield_carry_world" );

	// Extra camera spike models needed
	PrecacheModel( "t5_weapon_camera_head_world" );

	// scavenger_bag_mp needed for the scavenger perk
	precacheItem( "scavenger_item_mp" );
	precacheItem( "scavenger_item_hack_mp" );
	precacheShader( "hud_scavenger_pickup" );
	
	PreCacheShellShock( "default" );
	precacheShellShock( "concussion_grenade_mp" );
	precacheShellShock( "tabun_gas_mp" );
	precacheShellShock( "tabun_gas_nokick_mp" );
	precacheShellShock( "proximity_grenade" );
	precacheShellShock( "proximity_grenade_exit" );
	
	thread maps\mp\_flashgrenades::main();
	thread maps\mp\_empgrenade::init();
	thread maps\mp\_entityheadicons::init();

	if ( !isdefined(level.grenadeLauncherDudTime) )
		level.grenadeLauncherDudTime = 0;

	if ( !isdefined(level.thrownGrenadeDudTime) )
		level.thrownGrenadeDudTime = 0;
		
	level thread onPlayerConnect();
	
	maps\mp\gametypes\_weaponobjects::init();
	maps\mp\_smokegrenade::init();
	maps\mp\_heatseekingmissile::init();
	maps\mp\_acousticsensor::init();
	maps\mp\_sensor_grenade::init();
	maps\mp\_tacticalinsertion::init();
	maps\mp\_scrambler::init();
	maps\mp\_explosive_bolt::init();
	maps\mp\_sticky_grenade::init();
	maps\mp\_proximity_grenade::init();
	maps\mp\_bouncingbetty::init();
	maps\mp\_trophy_system::init();
	maps\mp\_ballistic_knife::init();
	maps\mp\_satchel_charge::init();
	maps\mp\_riotshield::init();
	maps\mp\_hacker_tool::init();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedWeapons = false;
		player.lastFireTime = 0;
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
		self thread watchRiotShieldUse();

		self thread trackWeapon();

		self.droppedDeathWeapon = undefined;
		self.tookWeaponFrom = [];
		self.pickedUpWeaponKills = [];
		
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

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRiotShieldUse() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );

	// watcher for attaching the model to correct player bones
	self thread maps\mp\_riotshield::trackRiotShield();

	for ( ;; )
	{
		self waittill( "raise_riotshield" );
		self thread maps\mp\_riotshield::startRiotshieldDeploy();
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
	if ( level.rankedmatch && level.perksEnabled  )
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
		
		if ( isdefined( self.class_num ) )
		{
			for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
			{
				perk = self GetLoadoutItem( self.class_num, "specialty" + ( numSpecialties + 1 ) );
				if ( perk != 0 )
				{
					perksIndexArray[ perk ] = true;
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

		if( event == "weapon_change" )
		{
			self maps\mp\_bb::commitWeaponData( spawnid, currentWeapon, currentTime );

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
				self maps\mp\_bb::commitWeaponData( spawnid, currentWeapon, currentTime );
				updateWeaponTimings( newTime );
			}
			
			return;
		}
	}
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



mayDropWeapon( weapon )
{
	if ( level.disableWeaponDrop == 1 )
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
	if ( level.disableWeaponDrop == 1 )
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
	
	if ( !isdefined( item ) )
	{
		/# iprintlnbold( "dropItem: was not able to drop weapon " + weapon ); #/
		return;
	}
	
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
		case "m32_mp":			// MGL
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
	assert( isdefined( player.pickedUpWeaponKills ) );
	
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
		player.pickedUpWeaponKills[ weapname ] = 0;
	}
	else
	{
		player.tookWeaponFrom[ weapname ] = undefined;
		player.pickedUpWeaponKills[ weapname ] = undefined;
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
	self.usedKillstreakWeapon["m32_mp"] = false;
	self.usedKillstreakWeapon["m202_flash_mp"] = false;
	self.usedKillstreakWeapon["m220_tow_mp"] = false;
	self.usedKillstreakWeapon["mp40_blinged_mp"] = false;
	self.killstreakType = [];
	self.killstreakType["minigun_mp"] = "minigun_mp";
	self.killstreakType["m32_mp"] = "m32_mp";
	self.killstreakType["m202_flash_mp"] = "m202_flash_mp";
	self.killstreakType["m220_tow_mp"] = "m220_tow_mp";
	self.killstreakType["mp40_blinged_mp"] = "mp40_blinged_drop_mp";
	
	for ( ;; )
	{	
		self waittill ( "weapon_fired", curWeapon );
		self.lastFireTime = GetTime();

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
				break;
			default:
				break;
		}

		switch( curWeapon )
		{
		case "minigun_mp":		// death machine	
		case "m32_mp":			// grenade launcher
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
	
	if ( isdefined(self.hitsThisMag[ weaponName ]) && self.hitsThisMag[ weaponName ] == 0 )
	{
		if( !SessionModeIsZombiesGame() )
		{
			weaponClass = getWeaponClass( weaponName );	
			maps\mp\_challenges::fullClipNoMisses( weaponClass, weaponName );
		}

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
	

	// recording zombie bullets
	if ( IsDefined( level.add_client_stat ) )
	{ 
		self [[level.add_client_stat]]( "total_shots", shotsFired );
		self [[level.add_client_stat]]( "hits", self.hits );
	}
	else
	{
		self AddPlayerStat( "total_shots", shotsFired );		
		self AddPlayerStat( "hits", self.hits );
		self AddPlayerStat( "misses", int( max( 0, shotsFired - self.hits ) ) );
	}

	self maps\mp\_bb::bbAddToStat( "shots", shotsFired );
	self maps\mp\_bb::bbAddToStat( "hits", self.hits );

	//println("hit:" + self.hits + "total_shots:" + shotsFired);

	self.hits = 0;
	pixendevent();
}

checkHit( sWeapon )
{
	//println("checkHit: " + self.hits);

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
	
	bbPrint( "mpequipmentuses", "gametime %d spawnid %d weaponname %s", gettime(), getplayerspawnid( self ), weaponName );

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
		grenade.originalOwner = self;
		break;
	case "satchel_charge_mp":
		level.globalSatchelChargeFired++;
		break;
	}

	if ( weaponName == "sticky_grenade_mp" || weaponName == "frag_grenade_mp" )
	{
		grenade SetTeam( self.pers["team"] );
		grenade SetOwner( self );
	}
		
	self.throwingGrenade = false;
}

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
		case "sticky_grenade_mp":
			grenade thread checkStuckToPlayer( true, true, weaponName );
			break;
		case "satchel_charge_mp":
		case "c4_mp":
			grenade thread checkStuckToPlayer( true, false, weaponName );
			break;
		case "proximity_grenade_mp":
			grenade thread maps\mp\_proximity_grenade::watchProximityGrenadeHitPlayer( self );
			break;
		case "tactical_insertion_mp":
			grenade thread maps\mp\_tacticalinsertion::watch( self );
			break;
		case "scrambler_mp":
			break;
		case "explosive_bolt_mp":
			grenade thread maps\mp\_explosive_bolt::watch_bolt_detonation( self );
			grenade thread checkStuckToPlayer( true, false, weaponName );
			break;
		case "hatchet_mp":
			grenade.lastWeaponBeforeToss = self getLastWeapon();
			grenade thread checkHatchetBounce();
			grenade thread checkStuckToPlayer( false, false, weaponName );
			self AddWeaponStat( weaponName, "used", 1 );
			break;
		}
	}
}

checkStuckToPlayer( deleteOnTeamChange, awardScoreEvent, weaponName )
{
	self endon( "death" );

	self waittill( "stuck_to_player", player );
	if ( isdefined ( player ) )
	{
		if ( deleteOnTeamChange )
			self thread stuckToPlayerTeamChange( player );

		if ( awardScoreEvent && isdefined ( self.originalOwner ) )
		{
			if ( self.originalOwner IsEnemyPlayer( player ) )
			{
				maps\mp\_scoreevents::processScoreEvent( "stick_explosive_kill", self.originalOwner, player, weaponName, true );
			}
		}

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
		
		grenade.originalOwner = self;
	}
}

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
		if ( self.isADestructable && (sWeapon == "claymore_mp" || sWeapon == "airstrike_mp" ) )
			return;

		self.entity damage_notify_wrapper( iDamage, eAttacker, (0,0,0), (0,0,0), "mod_explosive", "", "" );		
	}
}

debugline(a, b, color)
{
	/#
	for (i = 0; i < 30*20; i++)
	{
		line(a,b, color);
		wait .05;
	}
	#/
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
				self shellShock( "concussion_grenade_mp", time, false ); 
			
			self.concussionEndTime = getTime() + (time * 1000); 
			break;

		case "proximity_grenade_mp":
			self proximityGrenadeHitPlayer( eAttacker, eInflictor );
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
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weaponName, iDFlags );

		if( isFlashOrStunWeapon( weaponName ) )
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

isExplosiveBulletWeapon( weaponname )
{
	if( weaponname == "chopper_minigun_mp" || weaponname == "cobra_20mm_mp" || weaponname == "littlebird_guard_minigun_mp" || weaponname == "cobra_20mm_comlink_mp" )
	{
		return true;
	}
	return false;
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
			case "m32_mp":			// grenade launcher
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
			//self ClearStowedWeapon();
			self.tag_stowed_back = undefined;
		}
	}
}

detach_all_weapons()
{
	if( isDefined( self.tag_stowed_back ) )
	{
		clear_weapon = true;

		if ( isDefined( self.carryObject ))
		{
			carrierModel = self.carryObject maps\mp\gametypes\_gameobjects::getVisibleCarrierModel();

			if ( isDefined( carrierModel ) && carrierModel == self.tag_stowed_back )
			{
				self detach( self.tag_stowed_back, "tag_stowed_back" );
				clear_weapon = false;
			}
		}

		if ( clear_weapon )
		{
			self ClearStowedWeapon();
		}

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
		self attach( self.tag_stowed_back, "tag_stowed_back", true, weaponOptions, index_weapon );
		return;
	}
	else if ( non_stowed_weapon( current ) || ( self.hasRiotShield ))
	{
		// no back stowing if you have ballistic knife or riotshield
		return;
	}
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
				isSubStr( current, "dualoptic_" ) || isSubStr( temp_index_weapon, "dualoptic_" ) || 
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
			if ( isSubStr( index_weapon, self.pers["primaryWeapon"] ) && isSubStr( self.curclass, "CUSTOM" ) )
			{
				self.tag_stowed_back = getWeaponModel( index_weapon, self GetLoadoutItem( self.class_num, "primarycamo" ) );
			}
			else
			{
				stowedModelIndex = GetWeaponStowedModel(index_weapon);
				self.tag_stowed_back = getWeaponModel( index_weapon, stowedModelIndex );
			}
			
			if ( isSubStr( self.curclass, "CUSTOM" ) )
			{
				weaponOptions = self CalcWeaponOptions( self.class_num, 0 );
			}
		}
	}

	if ( !isDefined( self.tag_stowed_back ) )
		return;

//	self attach( self.tag_stowed_back, "tag_stowed_back", true, weaponOptions, index_weapon );
	self SetStowedWeapon( index_weapon );
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
	if ( self.tag_stowed_hip == "satchel_charge_mp" || self.tag_stowed_hip == "claymore_mp" || self.tag_stowed_hip == "bouncingbetty_mp" )
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

loadout_get_class_num()
{
	assert( IsPlayer( self ) );
	assert( IsDefined( self.class ) );

	if ( IsDefined( level.classToClassNum[ self.class ] ) )
	{
		return level.classToClassNum[ self.class ];
	}

	class_num = int( self.class[self.class.size-1] )-1;

	//hacky patch to the system since when it was written it was never thought of that there could be 10 custom slots
	if( -1 == class_num )
		class_num = 9;

	return class_num;
}

loadout_get_offhand_weapon( stat )
{
	if ( IsDefined( level.giveCustomLoadout ) )
	{
		return "weapon_null_mp";
	}

	class_num = self loadout_get_class_num();

	index = self maps\mp\gametypes\_class::getLoadoutItemFromDDLStats( class_num, stat );

	if ( IsDefined( level.tbl_weaponIDs[index] ) && IsDefined( level.tbl_weaponIDs[index]["reference"] ) )
	{
		return level.tbl_weaponIDs[index]["reference"] + "_mp";
	}

	return "weapon_null_mp";
}

loadout_get_offhand_count( stat )
{
	if ( IsDefined( level.giveCustomLoadout ) )
	{
		return 0;
	}

	class_num = self loadout_get_class_num();
	count = self maps\mp\gametypes\_class::getLoadoutItemFromDDLStats( class_num, stat );

	return count;
}

scavenger_think()
{
	self endon( "death" );
	self waittill( "scavenger", player );

	primary_weapons = player GetWeaponsListPrimaries();
	offhand_weapons = array_exclude( player GetWeaponsList(), primary_weapons );
	ArrayRemoveValue( offhand_weapons, "knife_mp" );

	player playsound( "fly_equipment_pickup_npc" );
	player playlocalsound( "fly_equipment_pickup_plr" );
	//player maps\mp\_properks::scavenged();

	player.scavenger_icon.alpha = 1;
	player.scavenger_icon fadeOverTime( 2.5 );
	player.scavenger_icon.alpha = 0;

	loadout_primary			= player loadout_get_offhand_weapon( "primarygrenade" );
	loadout_primary_count	= player loadout_get_offhand_count( "primarygrenadecount" );
	loadout_secondary		= player loadout_get_offhand_weapon( "specialgrenade" );
	loadout_secondary_count = player loadout_get_offhand_count( "specialgrenadeCount" );

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
		case "claymore_mp":
		case "sticky_grenade_mp":
		case "satchel_charge_mp":
		case "hatchet_mp":
			if ( isDefined( player.grenadeTypePrimaryCount ) && player.grenadeTypePrimaryCount < 1 ) 
				break; 
			else
				stockIncrease = getdvarintdefault( "scavenger_lethal_proc", 1 );
			// fall through
		case "proximity_grenade_mp":
		case "flash_grenade_mp":
		case "concussion_grenade_mp":
		case "tabun_gas_mp":
		case "nightingale_mp":
		case "emp_grenade_mp":
		case "willy_pete_mp":
			if ( !isdefined( stockIncrease ) && isDefined( player.grenadeTypeSecondaryCount ) && player.grenadeTypeSecondaryCount < 1 )
				break;
		
			if ( !isdefined( stockIncrease ) )
			{
				stockIncrease = getdvarintdefault( "scavenger_tactical_proc", 2 );
			}

			maxAmmo = WeaponMaxAmmo( weapon );

			// just give 1 for each scavenger pick up
			stock = player GetWeaponAmmoStock( weapon );

			if ( IsDefined( level.customLoadoutScavenge ) )
			{
				maxAmmo = self [[level.customLoadoutScavenge]]( weapon );
			}
			else if ( weapon == loadout_primary )
			{
				maxAmmo = loadout_primary_count;
			}
			else if ( weapon == loadout_secondary )
			{
				maxAmmo = loadout_secondary_count;
			}

			if ( stock < maxAmmo )
			{
				ammo = stock + stockIncrease;
				if ( ammo > maxAmmo )
				{
					ammo = maxAmmo;
				}
				player SetWeaponAmmoStock( weapon, ammo );
				player thread maps\mp\_challenges::scavengedGrenade();
			}
			break;

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
		clip *= getdvarfloatdefault( "scavenger_clip_multiplier", 2 );
		clip = Int( clip );
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

	if ( level.gameType == "hack" )
	{
		item = self dropScavengerItem( "scavenger_item_hack_mp" );
	}
	else
	{
		item = self dropScavengerItem( "scavenger_item_mp" );
	}
		
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
