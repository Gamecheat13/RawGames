#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

#insert raw\maps\mp\_statstable.gsh;

#define KILLSTREAK_TIMER_X 15
#define KILLSTREAK_TIMER_Y 100
#define KILLSTREAK_ICON_WIDTH 20
	
init()
{
	PreCacheString( &"MP_KILLSTREAK_N" );	

	if ( GetDvar( "scr_allow_killstreak_building") == "" )
	{
		SetDvar( "scr_allow_killstreak_building", "0" );
	}
	
	level.killstreaks = [];
	level.killstreakWeapons = [];
	level.menuReferenceForKillStreak = [];
	level.numKillstreakReservedObjectives = 0;
	level.killstreakCounter = 0;

	if( !isDefined(level.killstreakRoundDelay) )
		level.killstreakRoundDelay = 0;
	
	level.killstreak_timers = [];
	
	foreach( team in level.teams )
	{
		level.killstreak_timers[team] = [];
	}

	maps\mp\killstreaks\_supplydrop::init();

	maps\mp\killstreaks\_ai_tank::init();
	maps\mp\killstreaks\_airsupport::initAirsupport();
	maps\mp\killstreaks\_dogs::initKillstreak();
	maps\mp\killstreaks\_radar::init(); // Radar registered out of alphabetical order so that its HUD timer appears first
	maps\mp\killstreaks\_emp::init();
	maps\mp\killstreaks\_helicopter::init();
	maps\mp\killstreaks\_helicopter_guard::init();
	maps\mp\killstreaks\_helicopter_gunner::init();
	maps\mp\killstreaks\_killstreakrules::init();
	maps\mp\killstreaks\_killstreak_weapons::init();
	maps\mp\killstreaks\_missile_drone::init();
	maps\mp\killstreaks\_missile_swarm::init();
	maps\mp\killstreaks\_planemortar::init();
	maps\mp\killstreaks\_rcbomb::init();
	maps\mp\killstreaks\_remote_weapons::init();
	maps\mp\killstreaks\_remotemissile::init();
	maps\mp\killstreaks\_remotemortar::init();
	maps\mp\killstreaks\_qrdrone::init();
	maps\mp\killstreaks\_spyplane::init();
	maps\mp\killstreaks\_straferun::init();
	maps\mp\killstreaks\_turret_killstreak::init();

	level thread onPlayerConnect();

/#
	level thread killstreak_debug_think();
#/
}

registerKillstreak(killstreakType, 			// killstreak name	
				   killstreakWeapon, 		// weapon associated with deploying this killstreak
				   killstreakMenuName,		// killstreak name from the cac loadout (could be merged with the type name)
				   killstreakUsageKey,		// variable that shows the usage for the killstreak ( could be merged with type name )
				   killstreakUseFunction,	// function that gets called when the killstreak gets activated	
				   killstreakDelayStreak,	// weather or not to delay the killstreak at round start
				   weaponHoldAllowed,		// if this killstreak weapon can be held by the player, as opposed to activate and remove (i.e. UAV)
				   killstreakStatsName		// Stats name for killstreak weapons (optional)
				   )
{
	assert( IsDefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( !IsDefined(level.killstreaks[killstreakType]), "Killstreak " + killstreakType + " already registered");
	assert( IsDefined(killstreakUseFunction), "No use function defined for killstreak " + killstreakType);
		
	level.killstreaks[killstreakType] = SpawnStruct();
	
	// number of kills required to achieve killstreak
	level.killstreaks[killstreakType].killstreakLevel = int( tablelookup( "mp/statstable.csv", STATS_TABLE_COL_REFERENCE, killstreakMenuName, STATS_TABLE_COL_COUNT ) );
	level.killstreaks[killstreakType].momentumCost = int( tablelookup( "mp/statstable.csv", STATS_TABLE_COL_REFERENCE, killstreakMenuName, STATS_TABLE_COL_MOMENTUM ) );
	level.killstreaks[killstreakType].iconMaterial = tablelookup( "mp/statstable.csv", STATS_TABLE_COL_REFERENCE, killstreakMenuName, STATS_TABLE_COL_IMAGE );
	level.killstreaks[killstreakType].quantity = int( tablelookup( "mp/statstable.csv", STATS_TABLE_COL_REFERENCE, killstreakMenuName, STATS_TABLE_COL_COUNT ) );
	level.killstreaks[killstreakType].usageKey = killstreakUsageKey;
	level.killstreaks[killstreakType].useFunction = killstreakUseFunction;
	level.killstreaks[killstreakType].menuName = killstreakMenuName; 
	level.killstreaks[killstreakType].delayStreak = killstreakDelayStreak; 
	level.killstreaks[killstreakType].allowAssists = false;
	level.killstreaks[killstreakType].overrideEntityCameraInDemo = false;
	
	if ( IsDefined( killstreakWeapon ) )
	{
		assert( !IsDefined(level.killstreakWeapons[killstreakWeapon]), "Can not have a weapon associated with multiple killstreaks.");
		precacheItem( killstreakWeapon );
		level.killstreaks[killstreakType].weapon = killstreakWeapon;
		level.killstreakWeapons[killstreakWeapon] = killstreakType;
	}

	if ( !IsDefined( weaponHoldAllowed ) )
	{
		weaponHoldAllowed = false;
	}

	if( isDefined( killstreakStatsName ) )
	{
		level.killstreaks[killstreakType].killstreakStatsName = killstreakStatsName;
	}

	level.killstreaks[killstreakType].weaponHoldAllowed = weaponHoldAllowed;

	level.menuReferenceForKillStreak[killstreakMenuName] = killstreakType;
}

registerKillstreakStrings( killstreakType, receivedText, notUsableText, inboundText, inboundNearPlayerText ) 
{
	assert( IsDefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( IsDefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling registerKillstreakStrings.");
	
	level.killstreaks[killstreakType].receivedText = 	receivedText;
	level.killstreaks[killstreakType].notAvailableText = notUsableText;
	level.killstreaks[killstreakType].inboundText = inboundText;
	level.killstreaks[killstreakType].inboundNearPlayerText = inboundNearPlayerText;
	
	if( IsDefined(level.killstreaks[killstreakType].receivedText) )
		precacheString( level.killstreaks[killstreakType].receivedText );	
	if( IsDefined(level.killstreaks[killstreakType].notAvailableText) )
		precacheString( level.killstreaks[killstreakType].notAvailableText );		
	if( IsDefined(level.killstreaks[killstreakType].inboundText) )
		precacheString( level.killstreaks[killstreakType].inboundText );		
	if( IsDefined(level.killstreaks[killstreakType].inboundNearPlayerText) )
		precacheString( level.killstreaks[killstreakType].inboundNearPlayerText );	
}

registerKillstreakDialog( 
							killstreakType,
							receivedDialog, 
							friendlyStartDialog, 
							friendlyEndDialog,
							enemyStartDialog, 
							enemyEndDialog,
							dialog
						)
{
	assert( IsDefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( IsDefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling registerKillstreakDialog.");
	precacheString( istring( receivedDialog ) ); // LUI

	level.killstreaks[killstreakType].informDialog = receivedDialog;


	game["dialog"][killstreakType + "_start"] = 	friendlyStartDialog;
	game["dialog"][killstreakType + "_end"] = 	friendlyEndDialog;
	game["dialog"][killstreakType + "_enemy_start"] = 	enemyStartDialog;
	game["dialog"][killstreakType + "_enemy_end"] = 	enemyEndDialog;

	game["dialog"][killstreakType] = dialog;
}

// additional weapons associated with this killstreak
registerKillstreakAltWeapon( killstreakType, weapon )
{
	assert( IsDefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( IsDefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling registerKillstreakAltWeapon.");

	if ( level.killstreaks[killstreakType].weapon == weapon )
		return;
	
		
	if ( !IsDefined( level.killstreaks[killstreakType].altWeapons ) )
	{
		level.killstreaks[killstreakType].altWeapons = [];
	}

	if( !IsDefined( level.killstreakWeapons[weapon] ) )
	{
		level.killstreakWeapons[weapon] = killstreakType;
	}
	level.killstreaks[killstreakType].altWeapons[level.killstreaks[killstreakType].altWeapons.size] = weapon;
}

// remote override weapons associated with this killstreak
registerKillstreakRemoteOverrideWeapon( killstreakType, weapon )
{
	assert( IsDefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( IsDefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling registerKillstreakAltWeapon.");

	if ( level.killstreaks[killstreakType].weapon == weapon )
		return;	
		
	if ( !IsDefined( level.killstreaks[killstreakType].remoteOverrideWeapons ) )
	{
		level.killstreaks[killstreakType].remoteOverrideWeapons = [];
	}

	if( !IsDefined( level.killstreakWeapons[weapon] ) )
	{
		level.killstreakWeapons[weapon] = killstreakType;
	}
	level.killstreaks[killstreakType].remoteOverrideWeapons[level.killstreaks[killstreakType].remoteOverrideWeapons.size] = weapon;
}

isKillstreakRemoteOverrideWeapon( killstreakType, weapon )
{
	if ( IsDefined( level.killstreaks[killstreakType].remoteOverrideWeapons ) )
	{
		for ( i=0; i<level.killstreaks[killstreakType].remoteOverrideWeapons.size; i++)
		{
			if ( level.killstreaks[killstreakType].remoteOverrideWeapons[i] == weapon)
			{
				return true;	
			}
		}
	}
	return false;
}

registerKillstreakDevDvar(killstreakType, dvar)
{
	assert( IsDefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( IsDefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling registerKillstreakDevDvar.");

	level.killstreaks[killstreakType].devDvar = dvar;
}

allowKillstreakAssists( killstreakType, allow )
{
	level.killstreaks[killstreakType].allowAssists = allow;	
}

overrideEntityCameraInDemo( killstreakType, value )
{
	level.killstreaks[killstreakType].overrideEntityCameraInDemo = value;
}

isKillstreakAvailable( killstreak )
{
	if ( isDefined( level.menuReferenceForKillStreak[killstreak] ) )
		return true;
	else
		return false;
}

getKillstreakByMenuName( killstreak )
{
	return level.menuReferenceForKillStreak[killstreak];
}

getKillStreakMenuName( killstreakType )
{
	Assert( IsDefined(level.killstreaks[killstreakType] ) );
	return level.killstreaks[killstreakType].menuName;
}

drawLine( start, end, timeSlice, color )
{
	/#
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
	#/
}

getKillstreakLevel( index, killstreak )
{
	killstreakLevel = level.killstreaks[ getKillstreakByMenuName( killstreak ) ].killstreakLevel;
	if( GetDvarInt( "custom_killstreak_mode" ) == 2 )
	{
		if ( isDefined( self.killstreak[ index ] ) && ( killstreak == self.killstreak[ index ] ) )
		{
			killsRequired = GetDvarInt( "custom_killstreak_" + index + 1 + "_kills" );
			if ( killsRequired )
			{
				killstreakLevel = GetDvarInt( "custom_killstreak_" + index + 1 + "_kills" );
			}
		}
	}
	return killstreakLevel;
}

giveKillstreakIfStreakCountMatches( index, killstreak, streakCount )
{
	pixbeginevent( "giveKillstreakIfStreakCountMatches" );
	
	/#
	if(!IsDefined( killstreak ) )
	{
		println( "Killstreak Undefined.\n" );
	}
	if( IsDefined( killstreak ) )
	{
		println( "Killstreak listed as."+killstreak+"\n" );
	}
	if( !isKillstreakAvailable(killstreak) )
	{
		println( "Killstreak Not Available.\n" );
	}
	#/

	if( self.pers["killstreaksEarnedThisKillstreak"] > index && isRoundBased() )
		hasAlreadyEarnedKillstreak = true;
	else
		hasAlreadyEarnedKillstreak = false;

	if ( IsDefined( killstreak ) && isKillstreakAvailable(killstreak) && !hasAlreadyEarnedKillstreak )
	{
		killstreakLevel = GetKillstreakLevel( index, killstreak );

		if ( self HasPerk( "specialty_killstreak" ) )
		{
			reduction = GetDvarint( "perk_killstreakReduction" );
			killstreakLevel -= reduction;

			// a fix for custom game types being able to adjust the killstreak reduction perk
			if( killstreakLevel <= 0 )
			{
				killstreakLevel = 1;
			}
		}
		
		if ( killstreakLevel == streakCount )
		{
			//self thread maps\mp\_properks::earnedAKillstreak();
			self thread maps\mp\_challenges::earnedKillstreak( killstreak );
			self giveKillstreak( getKillstreakByMenuName( killstreak ), streakCount );
			self.pers["killstreaksEarnedThisKillstreak"] = index + 1;
			pixendevent();
			return true;
		}
	}

	pixendevent();
	return false;
}

//Self is the player. This function looks at the player current killstreak and decides if he should be award a killstreak reward.
//It also manages the prompt that appears when the player  gets killstreaks at intervals of 5 kills once they reach 10 kills. -Leif
giveKillstreakForStreak()
{
	if ( !isKillStreaksEnabled() )
	{
		return;
	}

	//Equals total kills within one life
	if( !IsDefined(self.pers["totalKillstreakCount"]) )
	{
		self.pers["totalKillstreakCount"] = 0;
	}
	
	// send the running tally to see what kill streak we should get
	given = false;
	
	for ( i = 0; i < self.killstreak.size; i++ )
	{
		given |= giveKillstreakIfStreakCountMatches( i, self.killstreak[i], self.pers["cur_kill_streak"] );
	}
}

isOnAKillstreak()
{
	onKillstreak = false;
	if( !IsDefined( self.pers["kill_streak_before_death"] ) )
	{
		self.pers["kill_streak_before_death"] = 0;
	}
	
	streakPlusOne = self.pers["kill_streak_before_death"] + 1;
	
	if ( self.pers["kill_streak_before_death"] >= 5 ) 
	{
		onKillstreak = true;
	}


	return onKillstreak;
}

doesStreakCountMatch( killstreak, streakCount )
{
	if ( IsDefined( killstreak ) && isKillstreakAvailable(killstreak) )
	{
		killstreakLevel = level.killstreaks[ getKillstreakByMenuName( killstreak ) ].killstreakLevel;

		if ( killstreakLevel == streakCount )
		{
			return true;
		}
	}
	
	return false;
}

streakNotify( streakVal )
{
	self endon("disconnect");

	// wait until any challenges have been processed
	self waittill( "playerKilledChallengesProcessed" );
	wait .05;
	
	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = streakVal;
	notifyData.iconHeight = 32;
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}


giveKillstreak( killstreakType, streak, suppressNotification, noXP )
{
	pixbeginevent( "giveKillstreak" );
	self endon("disconnect");
	level endon( "game_ended" );
	
	had_to_delay = false;
	
	killstreakGiven = false;
	if( isDefined( noXP ) )
	{
		if ( self giveKillstreakInternal( killstreakType, undefined, noXP ) )
		{
			killstreakGiven = true;
			self addKillstreakToQueue( level.killstreaks[killstreakType].menuname, streak, killstreakType, noXP );
		}
	}
	else if ( self giveKillstreakInternal( killstreakType, noXP ) )
	{
		killstreakGiven = true;
		self addKillstreakToQueue( level.killstreaks[killstreakType].menuname, streak, killstreakType, noXP );
	}
	if( killstreakGiven )
	{
		self maps\mp\gametypes\_gametype_variants::onPlayerKillstreakEarned();
	}
	pixendevent(); //  "giveKillstreak"
}

giveKillstreakInternal( killstreakType, do_not_update_death_count, noXP )
{
	if ( level.gameEnded )
		return false;
		
	if ( !isKillStreaksEnabled() )
		return false;
		
	if ( !isDefined( level.killstreaks[killstreakType] ) )
		return false;

	if ( !IsDefined( self.pers["killstreaks"] ) )
	{
		self.pers["killstreaks"] = [];
	}
	if( !IsDefined( self.pers["killstreak_has_been_used"] ) )
	{
		self.pers["killstreak_has_been_used"] = [];
	}
	if( !IsDefined( self.pers["killstreak_unique_id"] ) )
	{
		self.pers["killstreak_unique_id"] = [];
	}
	
	self.pers["killstreaks"][self.pers["killstreaks"].size] = killstreakType;
	self.pers["killstreak_unique_id"][self.pers["killstreak_unique_id"].size] = level.killstreakCounter;
	level.killstreakCounter++;
	
	if( isDefined(noXP) )
	{
		self.pers["killstreak_has_been_used"][self.pers["killstreak_has_been_used"].size] = noXP;
	}
	else
	{
		self.pers["killstreak_has_been_used"][self.pers["killstreak_has_been_used"].size] = false;
	}
	
	weapon = getKillstreakWeapon( killstreakType );
	
	giveKillstreakWeapon( weapon, true );

	return true;
}

addKillstreakToQueue( menuName, streakCount, hardpointType, noNotify )
{
	killstreakTableNumber = level.killStreakIndices[ menuName ];

	if ( !isDefined( killstreakTableNumber ) )
	{
		return;
	}
	
	if( isDefined( noNotify ) && noNotify )
		return;

	informDialog = getKillstreakInformDialog( hardpointType );
	self playKillstreakReadyDialog( hardpointType );

	self LUINotifyEvent( &"killstreak_received", 2, killstreakTableNumber, istring( informDialog ) );
}


hasKillstreakEquipped( )
{
	currentWeapon = self getCurrentWeapon();

	keys = getarraykeys( level.killstreaks );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( level.killstreaks[keys[i]].weapon == currentWeapon )
			return true;
	}

	return false;
}

getKillstreakFromWeapon( weapon ) 
{
	keys = getarraykeys( level.killstreaks );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( level.killstreaks[keys[i]].weapon == weapon )
			return keys[i];
		if ( isdefined ( level.killstreaks[keys[i]].altweapons ) )
		{
			foreach( altweapon in level.killstreaks[keys[i]].altweapons )
			{
				if ( altweapon == weapon ) 
				{
					return keys[i];
				}
			}
		}
	}

	return undefined;
}

// dont need the isinventory it will be inventory they all are
giveKillstreakWeapon( weapon, isinventory, useStoredAmmo )
{	
	currentWeapon = self GetCurrentWeapon();
	
	if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum )
	{
		weaponsList = self GetWeaponsList();
		for( idx = 0; idx < weaponsList.size; idx++ )
		{
		 	carriedWeapon = weaponsList[idx];
		 	
		 	if ( currentWeapon == carriedWeapon )
		 		continue;
	
			if( currentWeapon == "none" )
				continue;
	
	
			// special case weapons that are killstreak weapons but shouldn't be taken from the player
			switch( carriedWeapon )
			{
			case "minigun_mp":
			case "m32_mp":
			case "m202_flash_mp":
			case "m220_tow_mp":
			case "mp40_blinged_mp":
				continue;
			}
		 		
		 	if ( isKillstreakWeapon(carriedWeapon) )
		 	{
		 		self TakeWeapon( carriedWeapon );
		 	}
		}
	}
	
	// take the weapon in-case we already have it.  
	// otherwise giveweapon will not give the weapon or ammo
	if( currentWeapon != weapon && ( self hasWeapon(weapon) == false ) )
	{
		self TakeWeapon( weapon );
		self GiveWeapon( weapon );
	}
	
	if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
	{
		self SetInventoryWeapon( weapon );

		if( maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon( weapon ) )
		{
			if( !isDefined( self.pers["held_killstreak_ammo_count"][weapon] ) )
				self.pers["held_killstreak_ammo_count"][weapon] = 0;

			if( isDefined( useStoredAmmo ) && useStoredAmmo && self.pers["held_killstreak_ammo_count"][weapon] > 0 )
			{
				self maps\mp\gametypes\_class::setWeaponAmmoOverall( weapon, self.pers["held_killstreak_ammo_count"][weapon] );
			}
			else
			{
				self.pers["held_killstreak_ammo_count"][weapon] = WeaponMaxAmmo( weapon );
				self maps\mp\gametypes\_class::setWeaponAmmoOverall( weapon, self.pers["held_killstreak_ammo_count"][weapon] );
			}
		}
		else
		{
			if ( ( weapon == "inventory_ai_tank_drop_mp"  || weapon == "inventory_supplydrop_mp"  || weapon == "inventory_minigun_drop_mp" || weapon == "inventory_m32_drop_mp" || weapon == "inventory_missile_drone_mp" ))
			{
				delta = 1;
			}
			else 
			{
				delta = 0;
			}
		
			changeKillstreakQuantity( weapon, delta );
	
		}
	}
	else
	{
		self setActionSlot( 4, "weapon", weapon );
	}
}

activateNextKillstreak( do_not_update_death_count )
{
	if ( level.gameEnded )
		return false;

	if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
		self SetInventoryWeapon( "" );
	else
		self setActionSlot( 4, "" );

 	if ( !IsDefined( self.pers["killstreaks"] ) || self.pers["killstreaks"].size == 0 )
 		return false;
 	
	killstreakType = self.pers["killstreaks"][self.pers["killstreaks"].size - 1];

	if ( !isDefined( level.killstreaks[killstreakType] ) )
		return false;
	
	weapon = level.killstreaks[killstreakType].weapon;
	wait( 0.05 );
	
	giveKillstreakWeapon( weapon, false, true );
	
	if ( !isdefined( do_not_update_death_count ) || do_not_update_death_count != false )
	{
		self.pers["killstreakItemDeathCount"+killstreakType] = self.deathCount;
	}	
	
	return true;
}

// for debug
takeKillstreak( killstreakType )
{
	if ( level.gameEnded )
		return;
		
	if ( !isKillStreaksEnabled() )
		return false;
		
	if ( isDefined( self.selectingLocation ) )
		return false;

	if ( !isDefined( level.killstreaks[killstreakType] ) )
		return false;
	
	self takeWeapon( killstreakType );
	self setActionSlot( 4, "" );
	self.pers["killstreakItemDeathCount"+killstreakType] = 0;	
	
	return true;
}

giveOwnedKillstreak()
{
	if ( isDefined( self.pers["killstreaks"] ) && self.pers["killstreaks"].size > 0 )
		self activateNextKillstreak( false );
}

switchToLastNonKillstreakWeapon()
{
	//Check if we were going into last stand
	if ( isDefined( self.lastStand ) && self.lastStand && isDefined( self.laststandpistol ) && self hasWeapon( self.laststandpistol ) )
		self switchToWeapon( self.laststandpistol );
	else if( self hasWeapon(self.lastNonKillstreakWeapon) )
		self switchToWeapon( self.lastNonKillstreakWeapon );
	else if( self hasWeapon(self.lastDroppableWeapon) )
		self switchToWeapon( self.lastDroppableWeapon );
	else
		return false;
		
	return true;
}

changeWeaponAfterKillstreak( killstreak, takeWeapon )
{
	self endon( "disconnect" );
	self endon( "death" );

	killstreak_weapon = getKillstreakWeapon( killstreak );
	currentWeapon = self GetCurrentWeapon();

	result = self switchToLastNonKillstreakWeapon();
}

changeKillstreakQuantity( killstreakWeapon, delta )
{
	increasedKillstreakCount = false;
	quantity = self.pers["killstreak_quantity"][killstreakWeapon];
	if ( !IsDefined( quantity ) )
	{
		quantity = 0;
	}
	
	previousQuantity = quantity;
	
	if ( delta < 0 )
	{
		assert( quantity > 0 );
	}
	quantity += delta;

	if ( quantity > level.scoreStreaksMaxStacking )
	{
		quantity = level.scoreStreaksMaxStacking;
	}
	
	// take the weapon in-case we already have it.  
	// otherwise giveweapon will not give the weapon or ammo
	if(self hasWeapon( killstreakWeapon ) == false )
	{
		self TakeWeapon( killstreakWeapon );
		self GiveWeapon( killstreakWeapon );
	}

	self.pers["killstreak_quantity"][killstreakWeapon] = quantity;
	self SetWeaponAmmoClip( killstreakWeapon, quantity );
	
	if ( quantity > previousQuantity )
	{
		increasedKillstreakCount = true;
	}
	return increasedKillstreakCount;
}

hasKillstreakInClass( killstreakMenuName )
{
	foreach ( equippedKillstreak in self.killstreak )
	{
		if ( equippedKillstreak == killstreakMenuName )
		{
			return true;
		}
	}
	return false;
}

removeKillstreakWhenDone( killstreak, hasKillstreakBeenUsed, isFromInventory )
{
	self endon( "disconnect" );
	
	self waittill( "killstreak_done", successful, killstreakType );
	if ( successful )
	{	
		logString( "killstreak: " + getKillStreakMenuName( killstreak ) );
		
		// good place to hook into killstreak usage
		killstreak_weapon = getKillstreakWeapon( killstreak );
		
		if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
		{
			if ( IsDefined( isFromInventory ) && isFromInventory )
			{
				removeUsedKillstreak( killstreak );
				if ( self GetInventoryWeapon() == killstreak_weapon )
				{
					self SetInventoryWeapon( "" );
				}
			}
			else
			{
				self changeKillstreakQuantity( killstreak_weapon, -1 );
				removeUsedKillstreak( killstreak );
			}
		}
		else if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
		{
			if ( IsDefined( isFromInventory ) && isFromInventory && ( self GetInventoryWeapon() == killstreak_weapon ) )
			{
				removeUsedKillstreak( killstreak );
				self SetInventoryWeapon( "" );
			}
			else
			{
				maps\mp\gametypes\_globallogic_score::_setPlayerMomentum( self, self.momentum - level.killstreaks[killstreakType].momentumCost );
			}
		}
		else
		{
			removeUsedKillstreak( killstreak );
		}

		if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum )
			self setActionSlot( 4, "" );
	
		success = true;
	}

	waittillframeend;
	
	currentWeapon = self GetCurrentWeapon();
	if( maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon(killstreakType) && currentWeapon == killstreakType )
	{ 
		//changeWeaponAfterKillstreak( killstreak, false ); 
		return;
	}
	
	if ( successful && ( !self hasKillstreakInClass( getKillStreakMenuName( killstreak ) ) || ( IsDefined( isFromInventory ) && isFromInventory ) )  )
	{
		changeWeaponAfterKillstreak( killstreak, true ); 
	}
	else
	{
		// the killstreak could have failed because we switched to another killstreak weapon
		killstreakForCurrentWeapon = getKillstreakFromWeapon( currentWeapon );
		
		if ( successful || !isdefined( killstreakForCurrentWeapon ) || killstreakForCurrentWeapon == killstreak )
		{
			changeWeaponAfterKillstreak( killstreak, false ); 
		}
	}

	if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum || 
	    ( IsDefined( isFromInventory ) && isFromInventory ) )
	{
		if (successful)
			activateNextKillstreak();
	}
}

useKillstreak( killstreak, isFromInventory )
{
	hasKillstreakBeenUsed = getIfTopKillstreakHasBeenUsed();
	
	if ( isDefined( self.selectingLocation ) )
		return;

	self thread removeKillstreakWhenDone( killstreak, hasKillstreakBeenUsed, isFromInventory );
	self thread triggerKillstreak( killstreak, isFromInventory );
}

removeUsedKillstreak( killstreak, killstreakId )
{
	// the killstreak stack is a lifo stack
	// find the top most killstreak in the list 
	// remove it 
	killstreakIndex = undefined;
	for ( i = self.pers["killstreaks"].size - 1; i >= 0; i-- )
	{
		if ( self.pers["killstreaks"][i] == killstreak )
		{
			if( isDefined( killstreakId ) && self.pers["killstreak_unique_id"][i] != killstreakId )
				continue;
	  		
			killstreakIndex = i;
			break;
		}
	}
	
	recordStreakIndex = undefined;
	if( IsDefined( level.killstreaks[killstreak].menuname ) )
	{
		recordStreakIndex = level.killstreakindices[level.killstreaks[killstreak].menuname];
		if ( IsDefined(recordStreakIndex) )
		{
			self recordKillStreakEvent( recordStreakIndex );
		}
	}

	if ( !IsDefined(killstreakIndex) )
		return;
	
	arraySize = self.pers["killstreaks"].size;
	for ( i = killstreakIndex; i < arraySize - 1; i++ )
	{
		self.pers["killstreaks"][i] = self.pers["killstreaks"][i + 1];
		self.pers["killstreak_has_been_used"][i] = self.pers["killstreak_has_been_used"][i + 1];
		self.pers["killstreak_unique_id"][i] = self.pers["killstreak_unique_id"][i + 1];
	}
	
	self.pers["killstreaks"][arraySize-1] = undefined;
	self.pers["killstreak_has_been_used"][arraySize-1] = undefined;
	self.pers["killstreak_unique_id"][arraySize-1] = undefined;
}

getTopKillstreak()
{
	if ( self.pers["killstreaks"].size == 0 )
		return undefined;
		
	return self.pers["killstreaks"][self.pers["killstreaks"].size-1];
}

getIfTopKillstreakHasBeenUsed()
{
	if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum )
	{
		if ( self.pers["killstreak_has_been_used"].size == 0 )
			return undefined;
		
		return self.pers["killstreak_has_been_used"][self.pers["killstreak_has_been_used"].size-1];
	}
}

getTopKillstreakUniqueId()
{
	if ( self.pers["killstreak_unique_id"].size == 0 )
		return undefined;
		
	return self.pers["killstreak_unique_id"][self.pers["killstreak_unique_id"].size-1];
}

getKillstreakWeapon( killstreak )
{
	if( !IsDefined( killstreak ) )
		return "none";

	Assert( IsDefined(level.killstreaks[killstreak]) );
	
	return level.killstreaks[killstreak].weapon;
}

getKillstreakMomentumCost( killstreak )
{
	if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum )
	{
		return 0;
	}

	if( !IsDefined( killstreak ) )
	{
		return 0;
	}

	Assert( IsDefined(level.killstreaks[killstreak]) );
	
	return level.killstreaks[killstreak].momentumCost;
}

getKillstreakForWeapon( weapon )
{
	return level.killstreakWeapons[weapon];
}

isKillstreakWeapon( weapon )
{
	if ( isWeaponAssociatedWithKillstreak( weapon ) )
		return true;

	switch( weapon )
	{
		case "none":	
		case "briefcase_bomb_defuse_mp":
		case "briefcase_bomb_mp":
		case "scavenger_item_mp":
		case "syrette_mp":
		case "tabun_fx_mp":
		case "tabun_center_mp":
		case "tabun_large_mp":
		case "tabun_medium_mp":
		case "tabun_small_mp":
		case "tabun_tiny_mp":
			return false;
	}
		
	if ( IsWeaponSpecificUse( weapon ) )
		return true;
	
	return false;
}

isKillstreakWeaponAssistAllowed( weapon )
{
	killstreak = getKillstreakForWeapon( weapon );

	if ( !IsDefined( killstreak ) )
		return false;
		
		if ( level.killstreaks[killstreak].allowAssists )
			return true;
			
		return false;
}

shouldOverrideEntityCameraInDemo( weapon )
{
	killstreak = getKillstreakForWeapon( weapon );

	if ( !IsDefined( killstreak ) )
		return false;
		
	if ( level.killstreaks[killstreak].overrideEntityCameraInDemo )
		return true;
			
	return false;
}

trackWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );

	self.lastNonKillstreakWeapon = self GetCurrentWeapon();
	lastValidPimary = self GetCurrentWeapon();
	if ( self.lastNonKillstreakWeapon == "none" )
	{
		weapons = self GetWeaponsListPrimaries();
		if ( weapons.size > 0 )
			self.lastNonKillstreakWeapon = weapons[0];
		else
			self.lastNonKillstreakWeapon = "knife_mp";
	}
	Assert( self.lastNonKillstreakWeapon != "none" );
	
	for ( ;; )
	{
		currentWeapon = self GetCurrentWeapon();
		self waittill( "weapon_change", weapon );
		
		if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( weapon ) )
			lastValidPimary = weapon;

		if ( weapon == self.lastNonKillstreakWeapon )
		{
			continue;
		}

		switch( weapon )
		{
		case "none":
		case "knife_mp":
			continue;
		}

		if( maps\mp\killstreaks\_killstreak_weapons::isGameplayWeapon( weapon ) )
			continue;

		name = getKillstreakForWeapon( weapon );

		if ( IsDefined( name ) && !maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon( weapon ) )
		{
			killstreak = level.killstreaks[ name ];
			continue;
		}

		if( currentWeapon != "none" && IsWeaponEquipment( currentWeapon ) && maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon( self.lastNonKillstreakWeapon ) )
		{
			self.lastNonKillstreakWeapon = lastValidPimary;
			continue;
		}


		if ( IsWeaponEquipment( weapon ) )
		{
			continue;
		}

		self.lastNonKillstreakWeapon = weapon;
	}
}

killstreakWaiter()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self thread trackWeaponUsage();
	
	self giveOwnedKillstreak();
	
	for ( ;; )
	{
		self waittill( "weapon_change", weapon );
		
		if( !isKillstreakWeapon( weapon ) )
			continue;
		
		killstreak = getKillstreakForWeapon( weapon );
				
		if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum )
		{
			killstreak = getTopKillstreak();
			if( weapon != getKillstreakWeapon(killstreak) )
				continue;
		}
		
		if( isKillstreakRemoteOverrideWeapon( killstreak, weapon ) )
			continue;
		
		inventoryButtonPressed = ( self InventoryButtonPressed() ) || ( IsDefined( self.pers["isBot"] ) );

		waittillframeend;

		if( isDefined( self.usingKillstreakHeldWeapon ) && self.usingKillstreakHeldWeapon && maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon(killstreak) )
			continue;
		
		isFromInventory = undefined;
		
		if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
		{		
			if ( ( weapon == self GetInventoryWeapon() ) && inventoryButtonPressed )
			{
				isFromInventory = true;
			}
			else if (( self GetAmmoCount( weapon ) <= 0 ) && (weapon != "killstreak_ai_tank_mp"))
			{
				self switchToLastNonKillstreakWeapon();
				continue;
			}
		}
		else if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
		{
			if ( ( weapon == self GetInventoryWeapon() ) && inventoryButtonPressed )
			{
				isFromInventory = true;
			}
			else if ( self.momentum < level.killstreaks[killstreak].momentumCost )
			{
				self switchToLastNonKillstreakWeapon();
				continue;
			}
		}
		
		thread useKillstreak( killstreak, isFromInventory );

		if ( IsDefined( self.selectingLocation ) )
		{
			event = self waittill_any_return( "cancel_location", "game_ended", "used", "weapon_change" );
			
			if ( event == "cancel_location" || event == "weapon_change" )
			{
				// hack to wait for previous weapon 
				wait( 1 );
			}
		}
	}
}

shouldDelayKillstreak( killstreakType )
{
	if( !isDefined(level.startTime) )
		return false;

	if( level.killstreakRoundDelay < ( ( ( gettime() - level.startTime ) - level.discardTime ) / 1000 ) )
		return false;

	if( !isDelayableKillstreak(killstreakType) )
		return false;

	if( maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon(killstreakType) )
		return false;

	return true;
}

//check if this is a killstreak we want to delay at the start of a round
isDelayableKillstreak( killstreakType )
{
	if( isDefined( level.killstreaks[killstreakType] ) && isDefined( level.killstreaks[killstreakType].delayStreak ) && level.killstreaks[killstreakType].delayStreak )
		return true;

	return false;
}

getXPAmountForKillstreak( killstreakType )
{
	// looks like only the rcxd does this
	// all killstreaks need this?
	xpAmount = 0;
	switch( level.killstreaks[killstreakType].killstreakLevel )
	{
	case 1:
	case 2:
	case 3:
	case 4:
		xpAmount = 100;
		break;
	case 5:
		xpAmount = 150;
		break;
	case 6:
	case 7:
		xpAmount = 200;
		break;
	case 8:
		xpAmount = 250;
		break;
	case 9:
		xpAmount = 300;
		break;
	case 10:
	case 11:
		xpAmount = 350;
		break;
	case 12:
	case 13:
	case 14:
	case 15:
		xpAmount = 500;
		break;
	}

	return xpAmount;
}


triggerKillstreak( killstreakType, isFromInventory )
{
	assert( IsDefined(level.killstreaks[killstreakType].useFunction), "No use function defined for killstreak " + killstreakType);
	
	self.usingKillstreakFromInventory = isFromInventory;
	
	if( shouldDelayKillstreak( killstreakType ) )
	{
		timeLeft = Int( level.killstreakRoundDelay - (maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000) );
		
		if( !timeLeft )
			timeLeft = 1;

		self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );
	}
	else if ( [[level.killstreaks[killstreakType].useFunction]](killstreakType) )
	{
		//Killstreak of 3-4:+100, 5: +150, 6-7 +200, 8: +250, 9: +300, 11: +350, Above: +500
		if ( isdefined( level.killstreaks[killstreakType].killstreakLevel ) )
		{
			self maps\mp\gametypes\_gametype_variants::onPlayerKillstreakActivated();
		}
		

		if ( IsDefined( self ) )
		{
			//bbPrint( "mpkillstreakuses", "gametime %d spawnid %d name %s", getTime(), getplayerspawnid( self ), killstreakType );

			if ( !IsDefined( self.pers[level.killstreaks[killstreakType].usageKey] ) )
			{
				self.pers[level.killstreaks[killstreakType].usageKey] = 0;
			}
			
			self.pers[level.killstreaks[killstreakType].usageKey]++;
			self notify( "killstreak_used", killstreakType );
			self notify( "killstreak_done", true, killstreakType );
		}
		
		self.usingKillstreakFromInventory = undefined;
		
		return true;
	}
	
	self.usingKillstreakFromInventory = undefined;
	
	if ( IsDefined( self ) )
		self notify( "killstreak_done", false, killstreakType );
	return false;
}

addToKillstreakCount( weapon )
{
	if ( !isdefined( self.pers["totalKillstreakCount"] ) )
		self.pers["totalKillstreakCount"] = 0;
		
// The check is now done further up the stack to see if this should be counted
		self.pers["totalKillstreakCount"]++;
}

isWeaponAssociatedWithKillstreak( weapon )
{
	return IsDefined( level.killstreakWeapons[weapon] );
}

getFirstValidKillstreakAltWeapon( killstreakType )
{
	assert( IsDefined(level.killstreaks[killstreakType]), "Killstreak not registered.");

	if( isDefined( level.killstreaks[killstreakType].altWeapons ) )
	{
		for( i = 0; i < level.killstreaks[killstreakType].altWeapons.size; i++ )
		{
			if( isDefined( level.killstreaks[killstreakType].altWeapons[i] ) )
				return level.killstreaks[killstreakType].altWeapons[i];
		}
	}
	
	return "none";
}

shouldGiveKillstreak( weapon ) 
{
	killstreakBuilding = GetDvarint( "scr_allow_killstreak_building" );
	
	if ( killstreakBuilding == 0 )
	{
		if ( isWeaponAssociatedWithKillstreak(weapon) )
			return false;
	}
	
	return true;
}

pointIsInDangerArea( point, targetpos, radius )
{
	return distance2d( point, targetpos ) <= radius * 1.25;
}

printKillstreakStartText( killstreakType, owner, team, targetpos, dangerRadius )
{
	if ( !IsDefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode && IsDefined(level.killstreaks[killstreakType].inboundNearPlayerText))
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) 
				{
					if ( pointIsInDangerArea( players[i].origin, targetpos, dangerRadius ) )
						players[i] iprintlnbold(level.killstreaks[killstreakType].inboundNearPlayerText);
				}
			}
		}
		
		if ( IsDefined(level.killstreaks[killstreakType]) )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( level.killstreaks[killstreakType].inboundText, owner );
				}
			}
		}
	}
	else
	{
		if ( !level.hardcoreMode && IsDefined(level.killstreaks[killstreakType].inboundNearPlayerText) )
		{
			if ( pointIsInDangerArea( owner.origin, targetpos, dangerRadius ) )
				owner iprintlnbold(level.killstreaks[killstreakType].inboundNearPlayerText);
		}
	}
}


playKillstreakStartDialog( killstreakType, team, playNonTeamBasedEnemySounds )
{
	if ( !IsDefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	//Reduce spam of Radar calls, but ensure the player that called in allways hears it
	if ( killstreakType == "radar_mp" && level.teambased )
	{
		if( getTime() - level.radarTimers[team] > 30000 )
		{
			maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_start", team );

			maps\mp\gametypes\_globallogic_audio::leaderDialogForOtherTeams( killstreakType + "_enemy_start", team );
			level.radarTimers[team] = getTime();
		}
		else
		{
			self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( killstreakType + "_start" );
		}
		return;
	}
	
	if ( level.teambased )
	{
		maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_start", team );
		maps\mp\gametypes\_globallogic_audio::leaderDialogForOtherTeams( killstreakType + "_enemy_start", team );
	}
	else
	{
		self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( killstreakType + "_start" );
		//if ( IsDefined(playNonTeamBasedEnemySounds) && playNonTeamBasedEnemySounds)
		{
			selfarray = [];
			selfarray[0] = self;
			maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_enemy_start", undefined, undefined, selfarray );
		}
	}
}


playKillstreakReadyDialog( killstreakType )
{
	self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( killstreakType );
}


getKillstreakInformDialog( killstreakType )
{
	// please add inform dialog to killstreak
	assert( isdefined ( level.killstreaks[killstreakType].informDialog ) );
	
	if ( IsDefined( level.killstreaks[killstreakType].informDialog ) )
		return level.killstreaks[killstreakType].informDialog;
	return "";
}

playKillstreakEndDialog( killstreakType, team )
{
	if ( !IsDefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	if ( level.teambased )
	{
		maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_end", team );
		maps\mp\gametypes\_globallogic_audio::leaderDialogForOtherTeams( killstreakType + "_enemy_end", team );
	}
	else
	{
		self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( killstreakType + "_end" );
	}
}

getKillstreakUsageByKillstreak(killstreakType)
{
	assert( IsDefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling getKillstreakUsage.");
	
	return getKillstreakUsage( level.killstreaks[killstreakType].usageKey );
}

getKillstreakUsage(usageKey)
{
	if ( !IsDefined( self.pers[usageKey] ) )
	{
		return 0;
	}
	
	return self.pers[usageKey];
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		pixbeginevent("_killstreaks.gsc/onPlayerSpawned");
		
		giveOwnedKillstreak();
		
		if ( !IsDefined( self.pers["killstreaks"] ) )
			self.pers["killstreaks"] = [];
		if ( !IsDefined( self.pers["killstreak_has_been_used"] ) )
			self.pers["killstreak_has_been_used"] = [];
		if ( !IsDefined( self.pers["killstreak_unique_id"] ) )
			self.pers["killstreak_unique_id"] = [];

		size = self.pers["killstreaks"].size;

		if ( size > 0 )
			playKillstreakReadyDialog( self.pers["killstreaks"][size - 1] );
			
		pixendevent();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");

		self.pers["cur_kill_streak"] = 0;
		self.pers["cur_total_kill_streak"] = 0;		
		self setplayercurrentstreak( 0 );
		self.pers["totalKillstreakCount"] = 0;
		self.pers["killstreaks"] = [];
		self.pers["killstreak_has_been_used"] = [];
		self.pers["killstreak_unique_id"] = [];
	}
}

createKillstreakTimerForTeam( killstreakType, xPosition, team )
{
	assert( IsDefined( level.killstreak_timers[team] ) );
	
	killstreakTimer = spawnstruct();
	killstreakTimer.team = team;
	
	killstreakTimer.icon = createServerIcon( level.killstreaks[killstreakType].iconMaterial, 36, 36, team );
	killstreakTimer.icon.horzAlign = "user_left";
	killstreakTimer.icon.vertAlign = "user_top";
	killstreakTimer.icon.x = xPosition+KILLSTREAK_TIMER_X;
	killstreakTimer.icon.y = KILLSTREAK_TIMER_Y;
	killstreakTimer.icon.alpha = 0;
	killstreakTimer.killstreakType = killstreakType;
	
	level.killstreak_timers[team][level.killstreak_timers[team].size] = killstreakTimer;
}

createKillstreakTimer( killstreakType )
{
	if( killstreakType == "radar_mp" )
	{
		xPosition = 0;
	}
	else if( killstreakType == "counteruav_mp" )
	{
		xPosition = KILLSTREAK_ICON_WIDTH;
	}
	else if(  killstreakType == "missile_swarm_mp" )
	{
		xPosition = 2*KILLSTREAK_ICON_WIDTH;	
	}
	else if(  killstreakType == "emp_mp" )
	{
		xPosition = 3*KILLSTREAK_ICON_WIDTH;	
	}
	else if(  killstreakType == "radardirection_mp" )
	{
		xPosition = 4*KILLSTREAK_ICON_WIDTH;	
	}
	else
	{
		xPosition = 0;
	}
	foreach( team in level.teams )
	{
		createKillstreakTimerForTeam( killstreakType, xPosition, team );
	}	


}

destroyKillstreakTimers()
{
	level notify( "endKillstreakTimers" );
	if ( IsDefined( level.killstreak_timers ) )
	{
		foreach( team in level.teams )
		{
			foreach( killstreakTimer in level.killstreak_timers[team] )
			{
				killstreakTimer.icon destroyElem();
			}
		}
		level.killstreak_timers = undefined;
	}
}

getKillstreakTimerForKillstreak( team, killstreakType, duration )
{
	endTime = gettime() + duration * 1000;
	numKillstreakTimers = level.killstreak_timers[team].size;
	killstreakSlot = undefined;
	targetIndex = 0;
	for ( i = 0 ; i < numKillstreakTimers ; i++ )
	{
		killstreakTimer = level.killstreak_timers[team][i];
		if ( IsDefined( killstreakTimer.killstreakType ) && ( killstreakTimer.killstreakType == killstreakType ) )
		{
			killstreakSlot = i;
			break;
		}
		else if ( !IsDefined( killstreakTimer.killstreakType ) && !IsDefined( killstreakSlot ) )
		{
			killstreakSlot = i;
		}
	}
	
	if ( IsDefined( killstreakSlot ) )
	{
		killstreakTimer = level.killstreak_timers[team][killstreakSlot];
		killstreakTimer.endTime = endTime;
		killstreakTimer.icon.alpha = 1;
		return killstreakTimer;
	}
}

freeKillstreakTimer( killstreakTimer )
{
	killstreakTimer.icon.alpha = 0.2;
	killstreakTimer.endTime = undefined;
}

killstreakTimer( killstreakType, team, duration )
{
	level endon( "endKillstreakTimers" );
	
	if ( level.gameended )
	{
		return;
	}
	
	killstreakTimer = getKillstreakTimerForKillstreak( team, killstreakType, duration );
	if ( !IsDefined( killstreakTimer ) )
	{
		return;
	}
	
	eventName = team+"_"+killstreakType;
	level notify( eventName );
	level endon( eventName );
	
	blinkingDuration = 5;
	
	if ( duration > 0 )
	{		
		wait ( duration - blinkingDuration );
		
		while ( blinkingDuration > 0 )
		{
			killstreakTimer.icon fadeOverTime( .5 );
			killstreakTimer.icon.alpha = 1;
			wait ( .5 );
			killstreakTimer.icon fadeOverTime( .5 );
			killstreakTimer.icon.alpha = 0;
			wait ( .5 );
			blinkingDuration -= 1;
		}
	}
	
	freeKillstreakTimer( killstreakTimer );
}

setKillstreakTimer( killstreakType, team, duration )
{
	thread killstreakTimer( killstreakType, team, duration );
}

initRideKillstreak( streak )
{
	self disableUsability();
	result = self initRideKillstreak_internal( streak );

	if ( IsDefined( self ) )
		self enableUsability();
		
	return result;
}


initRideKillstreak_internal( streak )
{	
	if ( IsDefined( streak ) && ( ( streak == "qrdrone" ) || ( streak == "killstreak_remote_turret_mp" ) || ( streak == "killstreak_ai_tank_mp" ) || (streak == "qrdrone_mp") ) )
	{
		laptopWait = "timeout";
	}
	else
	{
		laptopWait = self waittill_any_timeout( 0.6, "disconnect", "death", "weapon_switch_started" );
	}
		
	maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

	if ( laptopWait == "weapon_switch_started" )
	{
		return ( "fail" );
	}

	if ( !isAlive( self ) )
	{
		return "fail";
	}

	if ( laptopWait == "disconnect" || laptopWait == "death" )
	{
		if ( laptopWait == "disconnect" )
		{
			return ( "disconnect" );
		}

		if ( self.team == "spectator" )
		{
			return "fail";
		}

		return ( "success" );		
	}
	
	if ( self IsEMPJammed() )
	{
		return ( "fail" );
	}
	
	if ( self isInteractingWithObject() )
	{
		return "fail";
	}
	
	self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.2, 0.4, 0.25 );
	blackOutWait = self waittill_any_timeout( 0.60, "disconnect", "death" );

	maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

	if ( blackOutWait != "disconnect" ) 
	{
		self thread clearRideIntro( 1.0 );
		
		if ( self.team == "spectator" )
		{
			return "fail";
		}
	}

	if ( self isOnLadder() )
	{
		return "fail";	
	}

	if ( !isAlive( self ) )
	{
		return "fail";
	}

	if ( self IsEMPJammed() )
	{
		return "fail";
	}
	
	if ( self isInteractingWithObject() )
	{
		return "fail";
	}
	
	if ( blackOutWait == "disconnect" )
	{
		return ( "disconnect" );
	}
	else
	{
		return ( "success" );		
	}
}

clearRideIntro( delay )
{
	self endon( "disconnect" );

	if ( IsDefined( delay ) )
		wait( delay );

	//self freezeControlsWrapper( false );
	
	self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0, 0, 0 );
}

/#

killstreak_debug_think()
{
	SetDvar( "debug_killstreak", "" );

	for( ;; )
	{
		cmd = GetDvar( "debug_killstreak" );

		switch( cmd )
		{
		case "data_dump":	
			killstreak_data_dump();
			break;
		}

		if ( cmd != "" )
		{
			SetDvar( "debug_killstreak", "" );
		}

		wait( 0.5 );
	}
}

killstreak_data_dump()
{
	iprintln( "Killstreak Data Sent to Console" );
	println( "##### Killstreak Data #####");
	println( "killstreak,killstreaklevel,weapon,altweapon1,altweapon2,altweapon3,altweapon4,type1,type2,type3,type4" );
	
	keys = GetArrayKeys( level.killstreaks );
		
	for( i = 0; i < keys.size; i++ )
	{
		data = level.killstreaks[ keys[i] ];
		type_data = level.killstreaktype[ keys[i] ];
		
		print( keys[i] + "," );
		print( data.killstreaklevel + "," );
		print( data.weapon + "," );

		alt = 0;

		if ( IsDefined( data.altweapons ) )
		{
			assert( data.altweapons.size <= 4 );

			for ( alt = 0; alt < data.altweapons.size; alt++ )
			{
				print( data.altweapons[alt] + "," );
			}
		}

		for ( ; alt < 4; alt++ )
		{
			print( "," );
		}

		type = 0;

		if ( IsDefined( type_data ) )
		{
			assert( type_data.size < 4 );
			type_keys = GetArrayKeys( type_data );

			for ( ; type < type_keys.size; type++ )
			{
				if ( type_data[ type_keys[type] ] == 1 )
				{
					print( type_keys[type] + "," );
				}
			}
		}

		for ( ; type < 4; type++ )
		{
			print( "," );
		}

		println( "" );
	}

	println( "##### End Killstreak Data #####");
}

#/


isInteractingWithObject()
{
	if ( self isCarryingTurret() )
		return true;
	if ( is_true( self.isPlanting ) )
		return true;
	if ( is_true( self.isDefusing ) )
		return true;

	return false;
}

