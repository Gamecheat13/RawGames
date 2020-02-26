#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	PreCacheString( &"MP_KILLSTREAK_N" );	

	if ( getdvar( "scr_allow_killstreak_building") == "" )
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

	maps\mp\_airsupport::initAirsupport();
	maps\mp\_helicopter::init();
	maps\mp\_airstrike::init();
	maps\mp\_napalm::init();
	maps\mp\_artillery::init();
	maps\mp\_mortar::init();
	maps\mp\_radar::init();
	maps\mp\_rcbomb::init();
	maps\mp\_helicopter_player::init();
	maps\mp\_spyplane::init();
	maps\mp\_dogs::initKillstreak();
	maps\mp\gametypes\_supplydrop::init();
	maps\mp\_killstreakrules::init();
	maps\mp\_turret_killstreak::init();
	maps\mp\gametypes\_killstreak_weapons::init();

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
	level.killstreaks[killstreakType].killstreakLevel = int( tablelookup( "mp/statstable.csv", level.cac_creference, killstreakMenuName, level.cac_ccount ) );
	level.killstreaks[killstreakType].usageKey = killstreakUsageKey;
	level.killstreaks[killstreakType].useFunction = killstreakUseFunction;
	level.killstreaks[killstreakType].menuName = killstreakMenuName; 
	level.killstreaks[killstreakType].delayStreak = killstreakDelayStreak; 
	level.killstreaks[killstreakType].allowAssists = false;
	
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

registerKillstreakDialog( killstreakType,
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
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
}

getKillstreakLevel( index, killstreak )
{
	killstreakLevel = level.killstreaks[ getKillstreakByMenuName( killstreak ) ].killstreakLevel;
	if( getDvarInt( "custom_killstreak_mode" ) == 2 )
	{
		if ( isDefined( self.killstreak[ index ] ) && ( killstreak == self.killstreak[ index ] ) )
		{
			killsRequired = getDvarInt( "custom_killstreak_" + index + 1 + "_kills" );
			if ( killsRequired )
			{
				killstreakLevel = getDvarInt( "custom_killstreak_" + index + 1 + "_kills" );
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
			reduction = getdvarint( "perk_killstreakReduction" );
			killstreakLevel -= reduction;

			// a fix for custom game types being able to adjust the killstreak reduction perk
			if( killstreakLevel <= 0 )
			{
				killstreakLevel = 1;
			}
		}
		
		if ( killstreakLevel == streakCount )
		{
			self thread maps\mp\_properks::earnedAKillstreak();
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
		
	// this is a code callback function so this wait will help with debugging
	//waittillframeend;

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

isOneAwayFromKillstreak()
{
	if( !IsDefined( self.pers["kill_streak_before_death"] ) )
	{
		self.pers["kill_streak_before_death"] = 0;
	}
	
	streakPlusOne = self.pers["kill_streak_before_death"] + 1;
	
	if ( self HasPerk( "specialty_killstreak" ) )
	{
		reduction = GetDvarInt( "perk_killstreakReduction" );
		streakPlusOne += reduction;
	}
	
	oneAway = false;
	killstreakCount = self.killstreak.size;
	
	for ( killstreakNum = 0; killstreakNum < killstreakCount; killstreakNum++ )
	{
		oneAway |= doesStreakCountMatch( self.killstreak[ killstreakNum ], streakPlusOne );
	}

	return oneAway;
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
	
	//iprintln( &"RANK_KILL_STREAK_N", self, streakVal );
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
	
	giveKillstreakWeapon( weapon );

	return true;
}

addKillstreakToQueue( menuName, streakCount, hardpointType, noNotify )
{
	killstreakTableNumber = level.killStreakIndices[ menuName ];
	
	assert( isDefined( killstreakTableNumber ) );
	
	if ( !isDefined( killstreakTableNumber ) )
	{
		return;
	}
	
	if( isDefined( noNotify ) && noNotify )
		return;

	size = self.killstreakNotifyQueue.size;
	self.killstreakNotifyQueue[size] = spawnstruct();
	self.killstreakNotifyQueue[size].streakCount = streakCount;
	self.killstreakNotifyQueue[size].killstreakTableNumber = killstreakTableNumber;
	self.killstreakNotifyQueue[size].hardpointType = hardpointType;
	
	self notify( "received award" );
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

giveKillstreakWeapon( weapon )
{
	weaponsList = self GetWeaponsList();
	currentWeapon = self GetCurrentWeapon();
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
	
	// take the weapon in-case we already have it.  
	// otherwise giveweapon will not give the weapon or ammo
	if(currentWeapon != weapon && !self hasWeapon(weapon) )
	{
		self TakeWeapon( weapon );
		self GiveWeapon( weapon );
	}
	self setActionSlot( 4, "weapon", weapon );
}

activateNextKillstreak( do_not_update_death_count )
{
	if ( level.gameEnded )
		return false;
		
//	if ( hasKillstreakEquipped() )
//		return false;

	self setActionSlot( 4, "" );

 	if ( !IsDefined( self.pers["killstreaks"] ) || self.pers["killstreaks"].size == 0 )
 		return false;
 	
	killstreakType = self.pers["killstreaks"][self.pers["killstreaks"].size - 1];

	if ( !isDefined( level.killstreaks[killstreakType] ) )
		return false;

//	if ( IsDefined( self.pers["killstreakItem"] ) )
//	{
//		weapon = level.killstreaks[self.pers["killstreakItem"]].weapon;
//		self takeWeapon( weapon );
//		self setActionSlot( 4, "" );
//		self.pers["killstreakItem"] = undefined;	
//		self.pers["killstreakItemDeathCount"+killstreakType] = 0;	
//	}
	
	weapon = level.killstreaks[killstreakType].weapon;
	wait( 0.05 );
	
	giveKillstreakWeapon( weapon );
	
//	self.pers["killstreakItem"] = killstreakType;	
	
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

//	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) && killstreakType == "helicopter_mp" )
//		return false;

//	if ( isDefined( self.pers["killstreakItem"] ) )
//	{
//		if ( self.pers["killstreakItem"] != killstreakType )
//			return false;
//	}
	
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

changeWeaponAfterKillstreak( killstreak )
{
	self endon( "disconnect" );
	self endon( "death" );

	currentWeapon = self GetCurrentWeapon();
	/*if( currentWeapon == "minigun_mp" ||
		currentWeapon == "m202_flash_mp" ||
		currentWeapon == "m220_tow_mp" ||
		currentWeapon == "mp40_drop_mp" )
		return;*/

	if ( level.killstreaks[ killstreak ].weaponHoldAllowed )
	{
		return;
	}

	self waittill( "killstreak_done" );

	//Check if we were going into last stand
	if ( isDefined( self.lastStand ) && self.lastStand && isDefined( self.laststandpistol ) && self hasWeapon( self.laststandpistol ) )
		self switchToWeapon( self.laststandpistol );
	else if( self hasWeapon(self.lastNonKillstreakWeapon) )
		self switchToWeapon( self.lastNonKillstreakWeapon );
	else if( self hasWeapon(self.lastDroppableWeapon) )
		self switchToWeapon( self.lastDroppableWeapon );
}

removeKillstreakWhenDone( killstreak, hasKillstreakBeenUsed )
{
	self endon( "disconnect" );
	
	self waittill( "killstreak_done", successful, killstreakType );
	if ( successful )
	{	
		logString( "killstreak: " + getKillStreakMenuName( killstreak ) );
		
		if( !isDefined( hasKillstreakBeenUsed ) || !hasKillstreakBeenUsed )
		{
			self thread maps\mp\gametypes\_missions::useKillstreak( killstreak );
		}
		
		killstreak_weapon = getKillstreakWeapon( killstreak );
		
		removeUsedKillstreak(killstreak);

		self setActionSlot( 4, "" );
		success = true;
	}

	waittillframeend;
	
	currentWeapon = self GetCurrentWeapon();
	if( maps\mp\gametypes\_killstreak_weapons::isHeldKillstreakWeapon(killstreakType) && currentWeapon == killstreakType )
		return;

	activateNextKillstreak( );
}

useKillstreak( )
{
	killstreak = getTopKillstreak();
	hasKillstreakBeenUsed = getIfTopKillstreakHasBeenUsed();
	
	if ( isDefined( self.selectingLocation ) )
		return;

	self thread changeWeaponAfterKillstreak( killstreak );
	self thread removeKillstreakWhenDone( killstreak, hasKillstreakBeenUsed );
	self thread triggerKillstreak( killstreak );
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
	if ( self.pers["killstreak_has_been_used"].size == 0 )
		return undefined;
		
	return self.pers["killstreak_has_been_used"][self.pers["killstreak_has_been_used"].size-1];
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
		
	specificUse = IsWeaponSpecificUse( weapon );
	if ( isdefined( specificUse ) && specificUse == true )
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
		case "syrette_mp":
			continue;
		}

		name = getKillstreakForWeapon( weapon );

		if ( IsDefined( name ) )
		{
			killstreak = level.killstreaks[ name ];

			if ( killstreak.weaponHoldAllowed == true )
			{
				self.lastNonKillstreakWeapon = weapon;
			}

			continue;
		}

		if( currentWeapon != "none" && IsWeaponEquipment( currentWeapon ) && maps\mp\gametypes\_killstreak_weapons::isHeldKillstreakWeapon( self.lastNonKillstreakWeapon ) )
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

		killstreak = getTopKillstreak();
		if( weapon != getKillstreakWeapon(killstreak) )
			continue;

		waittillframeend;

		if( isDefined( self.usingKillstreakHeldWeapon ) && maps\mp\gametypes\_killstreak_weapons::isHeldKillstreakWeapon(killstreak) )
			continue;
		
		thread useKillstreak();

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

	if( maps\mp\gametypes\_killstreak_weapons::isHeldKillstreakWeapon(killstreakType) )
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


triggerKillstreak( killstreakType )
{
	assert( IsDefined(level.killstreaks[killstreakType].useFunction), "No use function defined for killstreak " + killstreakType);
	
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
			xpAmount = getXPAmountForKillstreak( killstreakType );

			//Give the appropriate amount of xp for using the killstreak. RC Car is done in givePlayerControlOfRCBomb since for that killstreak
			//since this function isn't called until the car is blown up.
			if ( xpAmount > 0 && killstreakType != "rcbomb_mp" )
				self thread maps\mp\gametypes\_rank::giveRankXP( "medal", xpAmount );

			self maps\mp\gametypes\_gametype_variants::onPlayerKillstreakActivated();
		}
		

		if ( IsDefined( self ) )
		{
			bbPrint( "mpkillstreakuses: gametime %d spawnid %d name %s", getTime(), getplayerspawnid( self ), killstreakType );

			if ( !IsDefined( self.pers[level.killstreaks[killstreakType].usageKey] ) )
			{
				self.pers[level.killstreaks[killstreakType].usageKey] = 0;
			}
			
			self.pers[level.killstreaks[killstreakType].usageKey]++;
			self notify( "killstreak_used", killstreakType );
			self notify( "killstreak_done", true, killstreakType );
		}
		return true;
	}
	
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
	killstreakBuilding = getdvarint( "scr_allow_killstreak_building" );
	
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
			maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_enemy_start", level.otherTeam[team] );
			level.radarTimers[team] = getTime();
		}
		else
		{
			self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( killstreakType + "_start", team );
		}
		return;
	}
	
	if ( level.teambased )
	{
		maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_start", team );
		maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_enemy_start", level.otherTeam[team] );
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

playKillstreakReadyAndInformDialog( killstreakType )
{
	self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( killstreakType );
	if ( IsDefined( level.killstreaks[killstreakType].informDialog ) )
		self playLocalSound( level.killstreaks[killstreakType].informDialog );
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
		maps\mp\gametypes\_globallogic_audio::leaderDialog( killstreakType + "_enemy_end", level.otherTeam[team] );
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

		pixbeginevent("_hardpoints.gsc/onPlayerSpawned");
		
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
		self.pers["totalKillstreakCount"] = 0;
		self.pers["killstreaks"] = [];
		self.pers["killstreak_has_been_used"] = [];
		self.pers["killstreak_unique_id"] = [];
	}
}

/#

killstreak_debug_think()
{
	SetDvar( "debug_killstreak", "" );

	for( ;; )
	{
		cmd = getdvar( "debug_killstreak" );

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
