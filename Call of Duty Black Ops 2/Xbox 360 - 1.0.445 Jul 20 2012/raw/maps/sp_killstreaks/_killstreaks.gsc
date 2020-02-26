#include maps\_utility;
#include maps\gametypes\_hud_util;
#include common_scripts\utility;

#define KILLSTREAK_ACTION_SLOT	2

preload()
{
	level.killstreaks = [];
	level.killstreakWeapons = [];
	level.menuReferenceForKillStreak = [];
	level.numKillstreakReservedObjectives = 0;
	level.killstreakCounter = 0;
	level.spawnMaxs = (0, 0, 0);
	level.spawnMins = (0, 0, 0);
	level.globalKillstreaksCalled = 0;
	if( !isDefined(level.killstreakRoundDelay) )
		level.killstreakRoundDelay = 0;
	if ( GetDvar( "scr_allow_killstreak_building") == "" )
	{
		SetDvar( "scr_allow_killstreak_building", "0" );
	}


	PreCacheString( &"MP_KILLSTREAK_N" );	

	killstreak_setup();
	
	maps\sp_killstreaks\_airsupport::preload();
//	maps\sp_killstreaks\_helicopter::preload();
	maps\sp_killstreaks\_mortar::preload();
//	maps\sp_killstreaks\_smokegrenade::preload();
//	maps\sp_killstreaks\_supplydrop::preload();
	maps\sp_killstreaks\_spyplane::preload();
	maps\sp_killstreaks\_killstreak_weapons::preload();
	maps\sp_killstreaks\_turret_killstreak::preload();
	maps\sp_killstreaks\_remotemissile::preload();
	maps\sp_killstreaks\_talon::preload();

}

init()
{
	level.killstreaksenabled 	= true;
	level.ActionSlotPressed 	= ::IsActionSlotPressed;
	level.actionslot			= KILLSTREAK_ACTION_SLOT;
	level.hardcoreMode			= false;
	
	maps\gametypes\_gameobjects::init();
	maps\sp_killstreaks\_airsupport::initAirsupport();
//	maps\sp_killstreaks\_helicopter::init();
	maps\sp_killstreaks\_mortar::init();
//	maps\sp_killstreaks\_smokegrenade::init();
//	maps\sp_killstreaks\_supplydrop::init();
	maps\sp_killstreaks\_spyplane::init();
	maps\sp_killstreaks\_killstreakrules::init();
	maps\sp_killstreaks\_killstreak_weapons::init();
	maps\sp_killstreaks\_turret_killstreak::init();
	maps\sp_killstreaks\_remotemissile::init();
	maps\sp_killstreaks\_talon::init();
	

	level.overrideActorKilled = ::Callback_KillstreakActorKilled;

	foreach(player in GetPlayers())
	{
		player thread onPlayerSpawned();
	}
	
	level thread onPlayerConnect();

/#
	level thread killstreak_debug_think();
#/
}


IsActionSlotPressed()
{
	switch(level.actionslot)
	{
		case 1:
			return self ActionSlotTwoButtonPressed();
		case 2:
			return self ActionSlotTwoButtonPressed();
		case 3:
			return self ActionSlotThreeButtonPressed();
		case 4:
			return self ActionSlotFourButtonPressed();
	}
	return false;
}

isKillstreakRegistered(killstreakType)
{
	assert(isDefined(killstreakType),"Cannot pass undefined as parameter");

	if (!isDefined(level.killstreaks))
		return false;
	
	if (isDefined(level.killstreaks[killstreakType]))
		return true;
	else
		return false;
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
	
	level.killstreaks[killstreakType].killstreakLevel = Int( tablelookup( "sp/statsTable.csv", level.cac_creference, killstreakMenuName, level.cac_ccount ) );
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

doesPlayerHaveKillstreak(killstreak)
{
	if (!isDefineD(self.pers) )
		return false;
	if (!isDefined(self.pers["killstreaks"]) )
		return false;
	
	for(i=0;i<self.pers["killstreaks"].size;i++)
	{
		if (self.pers["killstreaks"][i] == killstreak)
			return true;
	}
	return false;
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
//	pixbeginevent( "giveKillstreakIfStreakCountMatches" );
	if (!isKillStreaksStreakCountsEnabled())
		return false;
	
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

	hasAlreadyEarnedKillstreak = false;

	if ( IsDefined( killstreak ) && isKillstreakAvailable(killstreak) && !hasAlreadyEarnedKillstreak )
	{
		killstreakLevel = GetKillstreakLevel( index, killstreak );
		
		if ( killstreakLevel == streakCount )
		{
			self giveKillstreak( getKillstreakByMenuName( killstreak ), streakCount );
			self.pers["killstreaksEarnedThisKillstreak"] = index + 1;
//			pixendevent();
			return true;
		}
	}

//	pixendevent();

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
		given |= giveKillstreakIfStreakCountMatches( i, self.killstreak[i], self.pers["totalKillstreakCount"] );
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
	
	//iprintln( &"RANK_KILL_STREAK_N", self, streakVal );
}


giveKillstreak( killstreakType, streak, suppressNotification, noXP )
{
//	pixbeginevent( "giveKillstreak" );
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
//	pixendevent(); //  "giveKillstreak"
}

giveKillstreakInternal( killstreakType, do_not_update_death_count, noXP )
{
	if ( level.gameEnded )
		return false;
		
	if ( !isKillStreaksEnabled() )
		return false;
	
	if ( !isDefined(killstreakType) )
		return false;
	
	if ( !isDefined (level.killstreaks) )
		return false;

	if ( !isDefined( level.killstreaks[killstreakType] ) )
		return false;
	
	if (!isDefined(self.pers) )
		self.pers = [];
	
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
	if ( !isDefined (self.pers["team"]) )
	{
		self.pers["team"] = self.team;
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

	if( !IsDefined( self.killstreakNotifyQueue ) )
	{
		self.killstreakNotifyQueue = [];
	}

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
	self setActionSlot( level.actionslot, "weapon", weapon ); // Commented out for momentum system
}

activateNextKillstreak( do_not_update_death_count )
{
	if ( level.gameEnded )
		return false;
		
//	if ( hasKillstreakEquipped() )
//		return false;

	self setActionSlot( level.actionslot, "" );

 	if ( !IsDefined( self.pers["killstreaks"] ) || self.pers["killstreaks"].size == 0 )
 		return false;
 	
	killstreakType = self.pers["killstreaks"][self.pers["killstreaks"].size - 1];

	if ( !isDefined( level.killstreaks[killstreakType] ) )
		return false;

//	if ( IsDefined( self.pers["killstreakItem"] ) )
//	{
//		weapon = level.killstreaks[self.pers["killstreakItem"]].weapon;
//		self takeWeapon( weapon );
//		self setActionSlot( level.actionslot, "" );
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
	
	weapon = getKillstreakWeapon( killstreakType );
	
	self takeWeapon( weapon );
	self setActionSlot( level.actionslot, "" );
	self.pers["killstreakItemDeathCount"+killstreakType] = 0;	
	
	return true;
}

takeAllKillstreaks()
{
	if( hasAnyKillstreak() )
	{
		takeKillstreak( getTopKillstreak() );
		
		self.pers["killstreaks"] = [];
		self.pers["killstreak_has_been_used"] = [];
		self.pers["killstreak_unique_id"] = [];
	}
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
	else if( isDefined(self.lastNonKillstreakWeapon) && self hasWeapon(self.lastNonKillstreakWeapon) )
		self switchToWeapon( self.lastNonKillstreakWeapon );
	else if( isDefined(self.lastDroppableWeapon) && self hasWeapon(self.lastDroppableWeapon) )
		self switchToWeapon( self.lastDroppableWeapon );
}

removeKillstreakWhenDone( killstreak, hasKillstreakBeenUsed )
{
	self endon( "disconnect" );
	
	self waittill( "killstreak_done", successful, killstreakType );
	if ( successful )
	{	
		logString( "killstreak: " + getKillStreakMenuName( killstreak ) );
		
		if ( isDefined(hasKillstreakBeenUsed))
		{
			removeUsedKillstreak(killstreak);
		}

		self setActionSlot( level.actionslot, "" );
		success = true;
	}

	waittillframeend;
	
	currentWeapon = self GetCurrentWeapon();
	if( maps\sp_killstreaks\_killstreak_weapons::isHeldKillstreakWeapon(killstreakType) && currentWeapon == killstreakType )
		return;

	activateNextKillstreak( );
}

useKillstreak(killstreak)
{
	if ( !isDefined(killstreak) )
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
	if ( !isDefined(self.pers["killstreaks"]) || self.pers["killstreaks"].size == 0 )
		return undefined;
		
	return self.pers["killstreaks"][self.pers["killstreaks"].size-1];
}

hasAnyKillstreak()
{
	return ( IsDefined(self getTopKillstreak()) );
}

getIfTopKillstreakHasBeenUsed()
{
	if (!isDefined(self.pers) )
		self.pers = [];
	
	if ( !isDefined(self.pers["killstreak_has_been_used"]))
	    self.pers["killstreak_has_been_used"] = [];
	    
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
		
	specificUse = false; //IsWeaponSpecificUse( weapon );
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

		if( isDefined( self.usingKillstreakHeldWeapon ) && maps\sp_killstreaks\_killstreak_weapons::isHeldKillstreakWeapon(killstreak) )
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

	if( maps\sp_killstreaks\_killstreak_weapons::isHeldKillstreakWeapon(killstreakType) )
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
	
	if ( [[level.killstreaks[killstreakType].useFunction]](killstreakType) )
	{
		//Killstreak of 3-4:+100, 5: +150, 6-7 +200, 8: +250, 9: +300, 11: +350, Above: +500
		if ( isdefined( level.killstreaks[killstreakType].killstreakLevel ) )
		{
			xpAmount = getXPAmountForKillstreak( killstreakType );
		}
		

		if ( IsDefined( self ) )
		{
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
	if ( !isKillStreaksStreakCountsEnabled())
		return false;
		
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
	
	/*
	if ( !level.hardcoreMode && IsDefined(level.killstreaks[killstreakType].inboundNearPlayerText) )
	{
		if ( pointIsInDangerArea( owner.origin, targetpos, dangerRadius ) )
			owner iprintlnbold(level.killstreaks[killstreakType].inboundNearPlayerText);
	}
	*/
}


playKillstreakStartDialog( killstreakType, team, playNonTeamBasedEnemySounds )
{
	if ( !IsDefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	//Reduce spam of Radar calls, but ensure the player that called in allways hears it
	if ( killstreakType == "radar_mp" )
	{
		if( getTime() - level.radarTimers[team] > 30000 )
		{
			level.radarTimers[team] = getTime();
		}

		return;
	}
}


playKillstreakReadyDialog( killstreakType )
{
}

playKillstreakReadyAndInformDialog( killstreakType )
{
	if ( IsDefined( level.killstreaks[killstreakType].informDialog ) )
		self playLocalSound( level.killstreaks[killstreakType].informDialog );
}


playKillstreakEndDialog( killstreakType, team )
{
	if ( !IsDefined( level.killstreaks[killstreakType] ) )
	{
		return;
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
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	self thread maps\sp_killstreaks\_killstreaks::killstreakWaiter();

	for(;;)
	{
		self waittill("spawned_player");

//		pixbeginevent("_killstreaks.gsc/onPlayerSpawned");
		
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
			
//		pixendevent();
	}
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

// create a class init
killstreak_setup()
{
	// max create a class "class" allowed
	level.cac_size = 5;
	
	level.cac_max_item = 256;
	
	// init cac data table column definitions
	level.cac_numbering = 0;	// unique unsigned int - general numbering of all items
	level.cac_cstat = 1;		// unique unsigned int - stat number assigned
	level.cac_cgroup = 2;		// string - item group name, "primary" "secondary" "inventory" "specialty" "grenades" "special grenades" "stow back" "stow side" "attachment"
	level.cac_cname = 3;		// string - name of the item, "Extreme Conditioning"
	level.cac_creference = 4;	// string - reference string of the item, "m203" "svt40" "bulletdamage" "c4"
	level.cac_ccount = 5;		// signed int - item count, if exists, -1 = has no count
	level.cac_cimage = 6;		// string - item's image file name
	level.cac_cdesc = 7;		// long string - item's description
	level.cac_cstring = 8;		// long string - item's other string data, reserved
	level.cac_cint = 9;			// signed int - item's other number data, used for attachment number representations
	level.cac_cunlock = 10;		// unsigned int - represents if item is unlocked by default
	level.cac_cint2 = 11;		// signed int - item's other number data, used for primary weapon camo skin number representations
	level.cac_cost = 12; // signed int - cost of the item
	level.cac_slot = 13; // string - slot for the given item
	level.cac_classified = 15;	// signed int - number of items of the class purchased need to unlock this weapon
	level.cac_momentum = 16;	// signed int - momentum cost

	level.killStreakNames = [];
	level.killStreakIcons = [];
	level.KillStreakIndices = [];

	// generating kill streak data vars collected form statsTable.csv
	for( i = 0; i < level.cac_max_item; i++ )
	{
		itemRow = tableLookupRowNum( "sp/statsTable.csv", level.cac_numbering, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( "sp/statsTable.csv", itemRow, level.cac_cgroup );
			
			if ( group_s == "killstreak" )
			{
				reference_s = tableLookupColumnForRow( "sp/statsTable.csv", itemRow, level.cac_creference );
				
				if( reference_s != "" )
				{
					level.tbl_KillStreakData[i] = reference_s;
					icon = tableLookupColumnForRow( "sp/statsTable.csv", itemRow, level.cac_cimage );
					name = tableLookupIString( "sp/statsTable.csv", level.cac_numbering, i, level.cac_cname );
					precacheString( name );
					
					level.killStreakNames[ reference_s ] = name;
					level.killStreakIcons[ reference_s ] = icon;
					level.killStreakIndices[ reference_s ] = i;
					precacheShader( icon );
					//precacheShader( icon + "_drop" );
				}
			}
		}
	}
}

Callback_KillstreakActorKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime)
{
	if( IsDefined( attacker ) && IsPlayer( attacker ) )
	{
		if( shouldGiveKillstreak( sWeapon ) )
		{
			attacker addToKillstreakCount( sWeapon );
			attacker thread giveKillstreakForStreak();
		}
	}
	
	self maps\_callbackglobal::Callback("on_actor_killed");
}