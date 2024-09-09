#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

KILLSTREAK_STRING_TABLE = "mp/killstreakTable.csv";
STREAKCOUNT_MAX_COUNT = 3;
KILLSTREAK_NAME_COLUMN = 1;
KILLSTREAK_KILLS_COLUMN = 4;
KILLSTREAK_EARNED_HINT_COLUMN = 6;
KILLSTREAK_SOUND_COLUMN = 7;
KILLSTREAK_EARN_DIALOG_COLUMN = 8;
KILLSTREAK_ENEMY_USE_DIALOG_COLUMN = 11;
KILLSTREAK_WEAPON_COLUMN = 12;
KILLSTREAK_ICON_COLUMN = 14;
KILLSTREAK_OVERHEAD_ICON_COLUMN = 15;
KILLSTREAK_DPAD_ICON_COLUMN = 16;

NUM_KILLS_GIVE_ALL_PERKS = 8;

// Copied to multiple places, keep them all in sync!
KILLSTREAK_GIMME_SLOT = 0;
KILLSTREAK_SLOT_1 = 1;
KILLSTREAK_SLOT_2 = 2;
KILLSTREAK_SLOT_3 = 3;
KILLSTREAK_SLOT_4 = 4;
KILLSTREAK_ALL_PERKS_SLOT = 5;
KILLSTREAK_STACKING_START_SLOT = 6;

init()
{
	// &&1 Kill Streak!
	PreCacheString( &"MP_KILLSTREAK_N" );
	PreCacheString( &"MP_NUKE_ALREADY_INBOUND" );
	PreCacheString( &"MP_UNAVILABLE_IN_LASTSTAND" );
	PreCacheString( &"MP_UNAVAILABLE_FOR_N_WHEN_EMP" );
	PreCacheString( &"MP_UNAVAILABLE_FOR_N_WHEN_NUKE" );
	PreCacheString( &"MP_UNAVAILABLE_USING_TURRET" );
	PreCacheString( &"MP_UNAVAILABLE_WHEN_INCAP" );
	PreCacheString( &"MP_HELI_IN_QUEUE" );
	PreCacheString( &"MP_SPECIALIST_STREAKING_XP" );
	PreCacheString( &"MP_AIR_SPACE_TOO_CROWDED" );
	PreCacheString( &"MP_CIVILIAN_AIR_TRAFFIC" );
	PreCacheString( &"MP_TOO_MANY_VEHICLES" );
	
	//	events
	PreCacheString( &"SPLASHES_HEADSHOT" );
	PreCacheString( &"SPLASHES_FIRSTBLOOD" );
	PreCacheString( &"MP_ASSIST" );	
	PreCacheString( &"MP_ASSIST_TO_KILL" );	
	
	precacheShader( "hud_killstreak_dpad_arrow_down" );
	precacheShader( "hud_killstreak_dpad_arrow_right" );
	precacheShader( "hud_killstreak_dpad_arrow_up" );
	precacheShader( "hud_killstreak_highlight" );
	precacheShader( "hud_killstreak_bar_empty" );
	precacheShader( "hud_killstreak_bar_full" );

	initKillstreakData();

	level.killstreakFuncs = [];
	level.killstreakSetupFuncs = [];
	level.killstreakWeapons = [];

	// NOTE: match leveling prototype
	level.killstreakFuncs[ "give_rpg" ] = ::tryUseRPG;
	level.killstreakFuncs[ "give_xm25" ] = ::tryUseXM25;

	thread maps\mp\killstreaks\_ac130::init();
	thread maps\mp\killstreaks\_remotemissile::init();
	thread maps\mp\killstreaks\_uav::init();
	thread maps\mp\killstreaks\_airstrike::init();
	thread maps\mp\killstreaks\_airdrop::init();
	thread maps\mp\killstreaks\_helicopter::init();
	thread maps\mp\killstreaks\_helicopter_flock::init();
	thread maps\mp\killstreaks\_helicopter_guard::init();
	thread maps\mp\killstreaks\_autosentry::init();
	//thread maps\mp\killstreaks\_tank::init();
	thread maps\mp\killstreaks\_emp::init();
	thread maps\mp\killstreaks\_nuke::init();
	thread maps\mp\killstreaks\_escortairdrop::init();
	//thread maps\mp\killstreaks\_mobilemortar::init();
	thread maps\mp\killstreaks\_remotemortar::init();
	//thread maps\mp\killstreaks\_a10::init();
	thread maps\mp\killstreaks\_deployablebox::init();
	//thread maps\mp\killstreaks\_teamammorefill::init();
	//thread maps\mp\killstreaks\_heligunner::init();
	thread maps\mp\killstreaks\_ims::init();
	//thread maps\mp\killstreaks\_aastrike::init();
	thread maps\mp\killstreaks\_perkstreaks::init();
	thread maps\mp\killstreaks\_remoteturret::init();
	thread maps\mp\killstreaks\_remoteuav::init();
	thread maps\mp\killstreaks\_remotetank::init();
	thread maps\mp\killstreaks\_juggernaut::init();
	
	//BLACKSMITH
	thread maps\mp\killstreaks\_orbital_laser::init();
	thread maps\mp\killstreaks\_map_killstreak::init();
	thread maps\mp\killstreaks\_warbird::init();
	//level.mp_solar_init_pointer is the function pointer for mp_solar's map-based killstreak. It is declared in maps\mp\mp_solar.gsc.
	//If we are not loading into the mp_solar map, this function pointer will not be defined and it will not be called. This is our way of initializing only the killstreaks for the level being played.
	if ( IsDefined( level.mp_solar_init_pointer ) )
	{
		thread [[level.mp_solar_init_pointer]]();
	}
	if ( IsDefined( level.mp_lab2_init_pointer ) )
	{
		thread [[level.mp_lab2_init_pointer]]();
	}
	if ( IsDefined( level.mp_greenband_init_pointer ) )
	{
		thread [[level.mp_greenband_init_pointer]]();
	}
	if ( IsDefined( level.mp_laser2_init_pointer ) )
	{
		thread [[level.mp_laser2_init_pointer]]();
	}
	if ( IsDefined( level.mp_prison_init_pointer ) )
	{
		thread [[level.mp_prison_init_pointer]]();
	}
	if ( IsDefined( level.mp_dam_init_pointer ) )
	{
		thread [[level.mp_dam_init_pointer]]();
	}
	if ( IsDefined( level.mp_refraction_init_pointer ) )
	{
		thread [[level.mp_refraction_init_pointer]]();
	}
	
	//	all killstreak weapons that:
	//		- the player actually weilds
	//		- are a turret on a killstreak
	level.killstreakWeildWeapons = [];
	level.killstreakWeildWeapons["cobra_player_minigun_mp"] = true;		// Chopper Gunner
	level.killstreakWeildWeapons["artillery_mp"] = true;				// Precision Airstrike
	level.killstreakWeildWeapons["stealth_bomb_mp"] = true;				// Stealth Bomber
	level.killstreakWeildWeapons["pavelow_minigun_mp"] = true;			// Pave Low
	level.killstreakWeildWeapons["sentry_minigun_mp"] = true;			// Sentry Gun
	level.killstreakWeildWeapons["harrier_20mm_mp"] = true;				// Harrier Strike
	level.killstreakWeildWeapons["ac130_105mm_mp"] = true;				// AC130
	level.killstreakWeildWeapons["ac130_40mm_mp"] = true;				// AC130
	level.killstreakWeildWeapons["ac130_25mm_mp"] = true;				// AC130
	level.killstreakWeildWeapons["remotemissile_projectile_mp"] = true;	// Hellfire
	level.killstreakWeildWeapons["cobra_20mm_mp"] = true;				// Attack Helicopter
	level.killstreakWeildWeapons["nuke_mp"] = true;						// Nuke		
	level.killstreakWeildWeapons["apache_minigun_mp"] = true;			// littlebird strafe
	level.killstreakWeildWeapons["littlebird_guard_minigun_mp"] = true;	// littlebird guard/support
	level.killstreakWeildWeapons["uav_strike_marker_mp"] = true;		// uav strike
	level.killstreakWeildWeapons["osprey_minigun_mp"] = true;			// escort airdrop
	level.killstreakWeildWeapons["strike_marker_mp"] = true;			// littlebird support
	level.killstreakWeildWeapons["a10_30mm_mp"] = true;					// a10 support
	level.killstreakWeildWeapons["manned_minigun_turret_mp"] = true;	// minigun turret
	level.killstreakWeildWeapons["manned_gl_turret_mp"] = true;			// GL turret
	level.killstreakWeildWeapons["airdrop_trap_explosive_mp"] = true;	// airdrop trap
	level.killstreakWeildWeapons["uav_strike_projectile_mp"] = true;	// uav strike
	level.killstreakWeildWeapons["remote_mortar_missile_mp"] = true;	// remote mortar
	level.killstreakWeildWeapons["manned_littlebird_sniper_mp"] = true;	// heli sniper	
	level.killstreakWeildWeapons["iw5_m60jugg_mp"] = true;				// juggernaut assault primary	
	level.killstreakWeildWeapons["iw5_mp412jugg_mp"] = true;			// juggernaut assault secondary	
	level.killstreakWeildWeapons["iw5_riotshieldjugg_mp"] = true;		// juggernaut support primary	
	level.killstreakWeildWeapons["iw5_usp45jugg_mp"] = true;			// juggernaut support secondary	
	level.killstreakWeildWeapons["remote_turret_mp"] = true;			// remote turret
	level.killstreakWeildWeapons["osprey_player_minigun_mp"] = true;	// osprey gunner
	level.killstreakWeildWeapons["deployable_vest_marker_mp"] = true;	// deployable vest
	level.killstreakWeildWeapons["ugv_turret_mp"] = true;				// remote tank turret
	level.killstreakWeildWeapons["ugv_gl_turret_mp"] = true;			// remote tank gl turret
	//level.killstreakWeildWeapons["remote_tank_projectile_mp"] = true;	// remote tank missile
	level.killstreakWeildWeapons["uav_remote_mp"] = true;				// remote uav
	//BLACKSMITH
	level.killstreakWeildWeapons["orbital_laser_mp"] = true;			// Orbital Laser
	level.killstreakWeildWeapons["mp_solar"] = true;					//mp_solar map-based kilstreak
	level.killstreakWeildWeapons["mp_dam"] = true;						//mp_dam map-based kilstreak
	level.killstreakWeildWeapons["mp_refraction"] = true;				//mp_refraction map-based killstreak
	level.killstreakWeildWeapons["warbird_player_turret_mp"] = true;	//mp warbird turret
	level.killstreakWeildWeapons["warbird_turret_mp"] = true;			//mp warbird turret
	level.killstreakWeildWeapons["warbird_25mm_mp"] = true;				//mp warbird mg

	//	killstreak weapons that allow chaining	
	level.killstreakChainingWeapons = [];
	level.killstreakChainingWeapons["remotemissile_projectile_mp"] = "predator_missile";	// Predator Missile/Hellfire
	level.killstreakChainingWeapons["ims_projectile_mp"] = "ims";							// IMS
	level.killstreakChainingWeapons["sentry_minigun_mp"] = "airdrop_sentry_minigun";		// Sentry Gun
	level.killstreakChainingWeapons["artillery_mp"] = "precision_airstrike";				// Precision Airstrike
	level.killstreakChainingWeapons["cobra_20mm_mp"] = "helicopter";						// attack helicopter
	level.killstreakChainingWeapons["apache_minigun_mp"] = "littlebird_flock";				// helicopter flock
	level.killstreakChainingWeapons["littlebird_guard_minigun_mp"] = "littlebird_support";	// littlebird guard
	level.killstreakChainingWeapons["remote_mortar_missile_mp"] = "remote_mortar";			// remote mortar
	level.killstreakChainingWeapons["ugv_turret_mp"] = "airdrop_remote_tank";				// remote tank
	level.killstreakChainingWeapons["ugv_gl_turret_mp"] = "airdrop_remote_tank";			// remote tank
	//level.killstreakChainingWeapons["remote_tank_projectile_mp"] = "airdrop_remote_tank";	// remote tank
	level.killstreakChainingWeapons["pavelow_minigun_mp"] = "helicopter_flares";			// Pave Low
	level.killstreakChainingWeapons["ac130_105mm_mp"] = "ac130";							// AC130
	level.killstreakChainingWeapons["ac130_40mm_mp"] = "ac130";								// AC130
	level.killstreakChainingWeapons["ac130_25mm_mp"] = "ac130";								// AC130
	level.killstreakChainingWeapons["iw5_m60jugg_mp"] = "airdrop_juggernaut";				// juggernaut assault primary	
	level.killstreakChainingWeapons["iw5_mp412jugg_mp"] = "airdrop_juggernaut";				// juggernaut assault/def secondary	
	level.killstreakChainingWeapons["osprey_player_minigun_mp"] = "osprey_gunner";			// osprey gunner
	level.killstreakChainingWeapons["warbird_player_turret_mp"] = "warbird";				//mp warbird turret
	level.killstreakChainingWeapons["warbird_25mm_mp"] = "warbird";							//mp warbird mg

	level.killstreakRoundDelay = getIntProperty( "scr_game_killstreakdelay", 8 );

	level thread onPlayerConnect();
}

tryUseRPG( lifeId )
{
	// NOTE: match leveling prototype
	//	we have a killstreak that let's you swap out your secondary weapon, so it doesn't need to do all of the normal killstreak stuff
	if( IsDefined( self.secondaryWeapon ) && self.secondaryWeapon != "none" )
		self TakeWeapon( self.secondaryWeapon );
		
	self _giveWeapon( "rpg_mp" );
	self.secondaryWeapon = "rpg_mp";
	self.pers[ "activeSecondaryWeaponBonus" ] = "rpg_mp";

	return true;
}

tryUseXM25( lifeId )
{
	// NOTE: match leveling prototype
	//	we have a killstreak that let's you swap out your secondary weapon, so it doesn't need to do all of the normal killstreak stuff
	if( IsDefined( self.secondaryWeapon ) && self.secondaryWeapon != "none" )
		self TakeWeapon( self.secondaryWeapon );

	self _giveWeapon( "xm25_mp" );
	self.secondaryWeapon = "xm25_mp";
	self.pers[ "activeSecondaryWeaponBonus" ] = "xm25_mp";

	return true;
}

initKillstreakData()
{
	for ( i = 1; true; i++ )
	{
		retVal = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 1 );
		if ( !IsDefined( retVal ) || retVal == "" )
			break;

		streakRef = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 1 );
		assert( streakRef != "" );

		streakUseHint = tableLookupIString( KILLSTREAK_STRING_TABLE, 0, i, 6 );
		assert( streakUseHint != &"" );
		PreCacheString( streakUseHint );

		streakEarnDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 8 );
		assert( streakEarnDialog != "" );
		game["dialog"][ streakRef ] = streakEarnDialog;

		streakAlliesUseDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 9 );
		assert( streakAlliesUseDialog != "" );
		game["dialog"][ "allies_friendly_" + streakRef + "_inbound" ] = "use_" + streakAlliesUseDialog;
		game["dialog"][ "allies_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAlliesUseDialog;

		streakAxisUseDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 10 );
		assert( streakAxisUseDialog != "" );
		game["dialog"][ "axis_friendly_" + streakRef + "_inbound" ] = "use_" + streakAxisUseDialog;
		game["dialog"][ "axis_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAxisUseDialog;

		streakWeapon = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 12 );
		precacheItem( streakWeapon );

		streakPoints = int( tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 13 ) );
		assert( streakPoints != 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "killstreak_" + streakRef, streakPoints );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 14 );
		precacheShader( streakShader );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 15 );
		if ( streakShader != "" )
			precacheShader( streakShader );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 16 );
		if ( streakShader != "" )
			precacheShader( streakShader );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 17 );
		if ( streakShader != "" )
			precacheShader( streakShader );
	}
}


onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		
		if( !IsDefined ( player.pers[ "killstreaks" ] ) )
			player.pers[ "killstreaks" ] = [];

		if( !IsDefined ( player.pers[ "kID" ] ) )
			player.pers[ "kID" ] = 10;

		//if( !IsDefined ( player.pers[ "kIDs_valid" ] ) )
		//	player.pers[ "kIDs_valid" ] = [];
		
		player.lifeId = 0;
		player.curDefValue = 0;
			
		if ( IsDefined( player.pers["deaths"] ) )
			player.lifeId = player.pers["deaths"];

		player VisionSetMissilecamForPlayer( game["thermal_vision"] );	
	
		player thread onPlayerSpawned();
	
		player.spUpdateTotal = 0;
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );			
		
		self thread killstreakUseWaiter();
		self thread waitForChangeTeam();		
				
		// these three threads need to be run regardless of the streak type because you could switch during the grace period from specialist to assault or support and not be able to toggle up/down
		self thread streakSelectUpTracker();
		self thread streakSelectDownTracker();
		
		if( !level.console )
		{
			// pc doesn't do killstreak selections, just a single button press
			self thread pc_watchStreakUse();
		}
		self thread streakNotifyTracker();	

		if ( !IsDefined( self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ] ) )
			self initPlayerKillstreaks();
		if ( !IsDefined( self.earnedStreakLevel ) )
			self.earnedStreakLevel = 0;
		// we want to reset the adrenaline back to what it was for round based games
		// we reset the adrenaline on first connect in playerlogic and if they are in the game until the end
		if( !IsDefined( self.adrenaline ) )
		{
			self.adrenaline = self GetPlayerData( "killstreaksState", "count" );
		}
		// if we reset stats then countToNext will be 0 and no bars will show until you kill someone
		// this also means the first time someone plays the game they won't see bars, so we need to set it
		//if( self.adrenaline == self GetPlayerData( "killstreaksState", "countToNext" ) )
		{
			self setStreakCountToNext();
			self updateStreakSlots();
		}

		if ( self.streakType == "specialist" )
			self updateSpecialistKillstreaks();
		else
			self giveOwnedKillstreakItem();
	}
}

initPlayerKillstreaks()
{
	// this IsDefined check keeps the clearkillstreaks call when we quit the game without selecting a class, from erroring out
	if( !IsDefined( self.streakType ) )
		return;

	if ( self.streakType == "specialist" )
		self setPlayerData( "killstreaksState", "isSpecialist", true );
	else
		self setPlayerData( "killstreaksState", "isSpecialist", false );
	
	// gimme slot is where care package items and special given items go
	// we want the gimme slot to be stackable so we don't lose killstreaks when we pick another up
	// so we'll make index 0 be a pointer of sorts to show where the next usable killstreak is in the killstreak array
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ] = spawnStruct();
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].available = false;
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].streakName = undefined;
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].earned = false;
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].awardxp = undefined;
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].owner = undefined;
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].kID = undefined;
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].lifeId = undefined;
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].isGimme = true;		
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].isSpecialist = false;		
	self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].nextSlot = undefined;		

	// reserved for each killstreak whether they have them or not
	for( i = 1; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
	{
		self.pers["killstreaks"][ i ] = spawnStruct();
		self.pers["killstreaks"][ i ].available = false;
		self.pers["killstreaks"][ i ].streakName = undefined;
		self.pers["killstreaks"][ i ].earned = true;
		self.pers["killstreaks"][ i ].awardxp = 1;
		self.pers["killstreaks"][ i ].owner = undefined;
		self.pers["killstreaks"][ i ].kID = undefined;
		self.pers["killstreaks"][ i ].lifeId = -1;
		self.pers["killstreaks"][ i ].isGimme = false;		
		self.pers["killstreaks"][ i ].isSpecialist = false;		
	}

	// reserved for specialist all perks bonus
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ] = spawnStruct();
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].available = false;
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].streakName = "all_perks_bonus";
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].earned = true;
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].awardxp = 0;
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].owner = undefined;
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].kID = undefined;
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].lifeId = -1;
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].isGimme = false;		
	self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].isSpecialist = true;		

	// init all of the icons to 0 in case the player hasn't selected all 3 streaks
	//	also init the hasStreak to false
	for( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
	{
		self setPlayerData( "killstreaksState", "icons", i, 0 );
		self setPlayerData( "killstreaksState", "hasStreak", i, false );
	}
	self setPlayerData( "killstreaksState", "hasStreak", KILLSTREAK_GIMME_SLOT, false );
	
	index = 1;
	foreach ( streakName in self.killstreaks )
	{
		self.pers["killstreaks"][index].streakName = streakName;
		self.pers["killstreaks"][index].isSpecialist = ( self.streakType == "specialist" );	
		
		killstreakIndexName = self.pers["killstreaks"][index].streakName;
		// if specialist then we need to check to see if they have the pro version of the perk and get that icon
		if( self.streakType == "specialist" )
		{
			perkTokens = StrTok( self.pers["killstreaks"][index].streakName, "_" );
			if( perkTokens[ perkTokens.size - 1 ] == "ks" )
			{
				perkName = undefined;
				foreach( token in perkTokens )
				{
					if( token != "ks" )
					{
						if( !IsDefined( perkName ) )
							perkName = token;
						else
							perkName += ( "_" + token );
					}
				}

				// blastshield has an _ at the beginning
				if( isStrStart( self.pers["killstreaks"][index].streakName, "_" ) )
					perkName = "_" + perkName;

				//if( IsDefined( perkName ) && self maps\mp\gametypes\_class::getPerkUpgrade( perkName ) != "specialty_null" )
				//	killstreakIndexName = self.pers["killstreaks"][index].streakName + "_pro";
			}
		}

		self setPlayerData( "killstreaksState", "icons", index, getKillstreakIndex( killstreakIndexName ) );
		self setPlayerData( "killstreaksState", "hasStreak", index, false );
		
		index++;	
	}

	self setPlayerData( "killstreaksState", "nextIndex", 1 );		
	self setPlayerData( "killstreaksState", "selectedIndex", -1 );
	self setPlayerData( "killstreaksState", "numAvailable", 0 );

	// specialist shows one more icon
	self setPlayerData( "killstreaksState", "hasStreak", KILLSTREAK_ALL_PERKS_SLOT, false );
}

updateStreakCount()
{
	if ( !IsDefined( self.pers["killstreaks"] ) )
		return;	
	if ( self.adrenaline == self.previousAdrenaline )
		return;	

	curCount = self.adrenaline;
	
	self setPlayerData( "killstreaksState", "count", self.adrenaline );
		
	if ( self.adrenaline >= self getPlayerData( "killstreaksState", "countToNext" ) )
		self setStreakCountToNext();		
}

resetStreakCount()
{
	self setPlayerData( "killstreaksState", "count", 0 );
	self setStreakCountToNext();
}

setStreakCountToNext()
{
	// this IsDefined check keeps the resetadrenaline call when we first connect in playerlogic, from erroring out
	if( !IsDefined( self.streakType ) )
	{
		// if they have no streak then count to next should be zero
		self setPlayerData( "killstreaksState", "countToNext", 0 );
		return;
	}

	// if they have no killstreaks
	if( self getMaxStreakCost() == 0 )
	{
		self setPlayerData( "killstreaksState", "countToNext", 0 );
		return;
	}

	// specialist but have maxed out
	if( self.streakType == "specialist" )
	{
		if( self.adrenaline >= self getMaxStreakCost() )
			return;
	}

	// set the next streaks cost
	nextStreakName = getNextStreakName();
	if ( !IsDefined( nextStreakname ) )
		return;
	nextStreakCost = getStreakCost( nextStreakName );
	self setPlayerData( "killstreaksState", "countToNext", nextStreakCost );
}

getNextStreakName()
{
	if ( self.adrenaline == self getMaxStreakCost() && ( self.streakType != "specialist" ) )
	{
		adrenaline = 0;
	}
	else
	{
		adrenaline = self.adrenaline;
	}
	
	foreach ( streakName in self.killstreaks )
	{
		streakVal = self getStreakCost( streakName );	
		
		if ( streakVal > adrenaline )
		{					
			return streakName;
		}
	}	
	return undefined;
}

getMaxStreakCost()
{
	maxCost = 0;
	foreach ( streakName in self.killstreaks )
	{
		streakVal = self getStreakCost( streakName );	
		
		if ( streakVal > maxCost )	
		{
			maxCost = streakVal;
		}
	}	
	return maxCost;
}

updateStreakSlots()
{
	// this IsDefined check keeps the clearkillstreaks call when we quit the game without selecting a class, from erroring out
	if( !IsDefined( self.streakType ) )
		return;

	if ( !isReallyAlive(self) )
		return;

	//	what's available?
	numStreaks = 0;
	for( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
	{
		if( IsDefined( self.pers["killstreaks"][i] ) && IsDefined( self.pers["killstreaks"][i].streakName ) )
		{
			self setPlayerData( "killstreaksState", "hasStreak", i, self.pers["killstreaks"][i].available );	
			if ( self.pers["killstreaks"][i].available == true )
				numStreaks++;	
		}	
	}	
	if ( self.streakType != "specialist" )
		self setPlayerData( "killstreaksState", "numAvailable", numStreaks );
	
	//	next to earn
	minLevel = self.earnedStreakLevel;
	maxLevel = self getMaxStreakCost();
	if ( self.earnedStreakLevel == maxLevel && self.streakType != "specialist" )
		minLevel = 0;
			
	nextIndex = 1;
	
	foreach ( streakName in self.killstreaks )
	{
		streakVal = self getStreakCost( streakName );	
		
		if ( streakVal > minLevel )	
		{
			nextStreak = streakName;
			break;
		}

		// for specialsit we don't want the next index to go above the max
		if( self.streakType == "specialist" )
		{
			if( self.earnedStreakLevel == maxLevel )
				break;
		}

		nextIndex++;
	} 
	
	self setPlayerData( "killstreaksState", "nextIndex", nextIndex );	
	
	//	selected index
	if ( IsDefined( self.killstreakIndexWeapon ) && ( self.streakType != "specialist" ) )
	{
		self setPlayerData( "killstreaksState", "selectedIndex", self.killstreakIndexWeapon );
	}
	else
	{
		if( self.streakType == "specialist" && self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].available )
			self setPlayerData( "killstreaksState", "selectedIndex", 0 );	
		else
			self setPlayerData( "killstreaksState", "selectedIndex", -1 );	
	}
}


waitForChangeTeam()
{
	self endon ( "disconnect" );
	self endon( "faux_spawn" );
	
	self notify ( "waitForChangeTeam" );
	self endon ( "waitForChangeTeam" );
	
	for ( ;; )
	{
		self waittill ( "joined_team" );
		clearKillstreaks();
	}
}


isRideKillstreak( streakName )
{
	switch( streakName )
	{
		case "helicopter_minigun":
		case "helicopter_mk19":
		case "ac130":
		case "predator_missile":
		case "osprey_gunner":
		case "remote_mortar":
		case "remote_uav":
		case "remote_tank":
		case "mp_solar":
		case "mp_dam":
			return true;

		default:
			return false;
	}
}

isCarryKillstreak( streakName )
{
	switch( streakName )
	{
		case "sentry":
		case "sentry_gl":
		case "minigun_turret":
		case "gl_turret":		
		case "deployable_vest":
		case "deployable_exp_ammo":
		case "ims":
			return true;

		default:
			return false;
	}
}


deadlyKillstreak( streakName )
{
	switch ( streakName )
	{
		case "predator_missile":
		case "precision_airstrike":
		case "orbital_laser":
		case "harrier_airstrike":
		case "helicopter":
		case "helicopter_flares":
		case "stealth_airstrike":
		case "helicopter_minigun":
		case "littlebird_support":
		case "littlebird_flock":
		case "remote_mortar":
		case "osprey_gunner":
		case "ac130":
		case "remote_tank":
		case "mp_solar":
		case "mp_dam":
		case "warbird":
			return true;
	}
	
	return false;
}


killstreakUsePressed()
{
	streakName = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
	lifeId = self.pers["killstreaks"][self.killstreakIndexWeapon].lifeId;
	isEarned = self.pers["killstreaks"][self.killstreakIndexWeapon].earned;
	awardXp = self.pers["killstreaks"][self.killstreakIndexWeapon].awardXp;
	kID = self.pers["killstreaks"][self.killstreakIndexWeapon].kID;
	isGimme = self.pers["killstreaks"][self.killstreakIndexWeapon].isGimme;

	if ( !self isOnGround() && ( isRideKillstreak( streakName ) || isCarryKillstreak( streakName ) ) )
		return ( false );

	if ( self isUsingRemote() )
		return ( false );

	if ( IsDefined( self.selectingLocation ) )
		return ( false );
		
	if ( deadlyKillstreak( streakName ) && level.killstreakRoundDelay && getGametypeNumLives() )
	{
		if ( level.gracePeriod - level.inGracePeriod < level.killstreakRoundDelay )
		{
			self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N", (level.killstreakRoundDelay - (level.gracePeriod - level.inGracePeriod)) );
			return ( false );
		}
	}

	if ( (level.teamBased && level.teamEMPed[self.team]) || (!level.teamBased && IsDefined( level.empPlayer ) && level.empPlayer != self) )
	{
		// we shouldn't stop you from using non electronic killstreaks
		if( streakName != "deployable_vest" )
		{
			self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N_WHEN_EMP", level.empTimeRemaining );
			return ( false );
		}
	}

	if ( IsDefined( self.nuked ) && self.nuked )
	{
		// we shouldn't stop you from using non electronic killstreaks
		if( streakName != "deployable_vest" )
		{
			self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N_WHEN_NUKE", level.nukeEmpTimeRemaining );
			return ( false );
		}
	}

	if ( self IsUsingTurret() && ( isRideKillstreak( streakName ) || isCarryKillstreak( streakName ) ) )
	{
		self iPrintLnBold( &"MP_UNAVAILABLE_USING_TURRET" );
		return ( false );
	}
	
	if ( IsDefined( self.lastStand )  && isRideKillstreak( streakName ) )
	{
		self iPrintLnBold( &"MP_UNAVILABLE_IN_LASTSTAND" );
		return ( false );
	}
	
	if ( !self isWeaponEnabled() )
		return ( false );

	//	Balance for anyone using the explosive ammo killstreak, remove it when they activate the next killstreak
	removeExplosiveAmmo = false;
	if ( self _hasPerk( "specialty_explosivebullets" ) && !issubstr( streakName, "explosive_ammo" ) )
		removeExplosiveAmmo = true;

	if( IsSubStr( streakName, "airdrop" ) || streakName == "littlebird_flock" )	
	{
		if ( !self [[ level.killstreakFuncs[ streakName ] ]]( lifeId, kID ) )
			return ( false );
	}
	else
	{
		if ( !self [[ level.killstreakFuncs[ streakName ] ]]( lifeId ) )
		  return ( false );
	}
	
/#
	// let bots use the full functionality of the killstreak usage	
	if( IsDefined( self.pers[ "isBot" ] ) && self.pers[ "isBot" ] )
		return true;
#/

	//	Balance for anyone using the explosive ammo killstreak, remove it when they activate the next killstreak
	if ( removeExplosiveAmmo )
		self _unsetPerk( "specialty_explosivebullets" );
	
	self thread updateKillstreaks();
	self usedKillstreak( streakName, awardXp );

	return ( true );
}


usedKillstreak( streakName, awardXp )
{	
	self playLocalSound( "weap_c4detpack_trigger_plr" );

	if ( awardXp )
	{
		self thread [[ level.onXPEvent ]]( "killstreak_" + streakName );
		self thread maps\mp\gametypes\_missions::useHardpoint( streakName );
	}
	
	awardref = maps\mp\_awards::getKillstreakAwardRef( streakName );
	if ( IsDefined( awardref ) )
		self thread incPlayerStat( awardref, 1 );

	if( isAssaultKillstreak( streakName ) )
	{
		self thread incPlayerStat( "assaultkillstreaksused", 1 );
	}
	else if( isSupportKillstreak( streakName ) )
	{
		self thread incPlayerStat( "supportkillstreaksused", 1 );
	}
	else if( isSpecialistKillstreak( streakName ) )
	{
		self thread incPlayerStat( "specialistkillstreaksearned", 1 );
		// no need to play specialist because we do leader dialog on the player with killstreakSplashNotify() and not just team specific things
		return;
	}

	// play killstreak dialog
	team = self.team;
	if ( level.teamBased )
	{
		thread leaderDialog( team + "_friendly_" + streakName + "_inbound", team );
		
		if ( getKillstreakInformEnemy( streakName ) )
			thread leaderDialog( team + "_enemy_" + streakName + "_inbound", level.otherTeam[ team ] );
	}
	else
	{
		self thread leaderDialogOnPlayer( team + "_friendly_" + streakName + "_inbound" );
		
		if ( getKillstreakInformEnemy( streakName ) )
		{
			excludeList[0] = self;
			thread leaderDialog( team + "_enemy_" + streakName + "_inbound", undefined, undefined, excludeList );
		}
	}
}


updateKillstreaks( keepCurrent )
{
	if ( !IsDefined( keepCurrent ) )
	{
		self.pers["killstreaks"][self.killstreakIndexWeapon].available = false;
	
		// if this is the gimme slot and we still have some stacked then leave available and set the new icon
		if( self.killstreakIndexWeapon == KILLSTREAK_GIMME_SLOT )
		{
			// if this is the gimme slot then clear the last used stacked killstreak before updating killstreaks
			self.pers["killstreaks"][ self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].nextSlot ] = undefined;		

			// loop through the stacked killstreaks and find the next available one
			streakName = undefined;
			for( i = KILLSTREAK_STACKING_START_SLOT; i < self.pers["killstreaks"].size; i++ )
			{
				if( !IsDefined( self.pers["killstreaks"][i] ) || !IsDefined( self.pers["killstreaks"][i].streakName ) )
					continue;

				streakName = self.pers["killstreaks"][i].streakName;
				self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].nextSlot = i;
			}
			
			if( IsDefined( streakName ) )
			{
				self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].available = true;
				self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].streakName = streakName;

				streakIndex = getKillstreakIndex( streakName );	
				self setPlayerData( "killstreaksState", "icons", KILLSTREAK_GIMME_SLOT, streakIndex );

				// pc need to put this new one in the actionslot for use
				if( !level.console && !self is_player_gamepad_enabled() )
				{
					killstreakWeapon = getKillstreakWeapon( streakName );
					_setActionSlot( 4, "weapon", killstreakWeapon );	
				}
			}
		}
	}
	
	//	find the highest remaining streak and select it
	highestStreakIndex = undefined;
	if( self.streakType == "specialist" )
	{
		if ( self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].available )
			highestStreakIndex = KILLSTREAK_GIMME_SLOT;
	}	
	else
	{
		for ( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
		{
			if( IsDefined( self.pers["killstreaks"][i] ) && 
				IsDefined( self.pers["killstreaks"][i].streakName ) &&
				self.pers["killstreaks"][i].available )
			{
				highestStreakIndex = i;
			}
		}
	}

	if ( IsDefined( highestStreakIndex ) )
	{
		if( level.console || self is_player_gamepad_enabled() )
		{
			self.killstreakIndexWeapon = highestStreakIndex;
			self.pers["lastEarnedStreak"] = self.pers["killstreaks"][highestStreakIndex].streakName;

			self giveSelectedKillstreakItem();			
		}
		// pc doesn't select killstreaks
		else
		{
			// make sure we still have all of the available killstreak weapons, things like the airdrop will get taken if you have more than one
			for ( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
			{
				if( IsDefined( self.pers["killstreaks"][i] ) && 
					IsDefined( self.pers["killstreaks"][i].streakName ) &&
					self.pers["killstreaks"][i].available )
				{
					killstreakWeapon = getKillstreakWeapon( self.pers["killstreaks"][i].streakName );
					weaponsListItems = self GetWeaponsListItems();
					hasKillstreakWeapon = false;
					for( j = 0; j < weaponsListItems.size; j++ )
					{
						if( killstreakWeapon == weaponsListItems[j] )
						{
							hasKillstreakWeapon = true;
							break;
						}
					}

					if( !hasKillstreakWeapon )
					{
						self _giveWeapon( killstreakWeapon );
					}
					else
					{
						// if we have more than one airdrop type weapon the ammo gets set to 0 because we give the next airdrop weapon before we take the last one
						//	this is a quicker fix than trying to figure out how to take and give at the right times
						if( IsSubStr( killstreakWeapon, "airdrop_" ) )
							self SetWeaponAmmoClip( killstreakWeapon, 1 );
					}

					// we should re-set the action slot just to make sure everything is correct (juggernaut needs this or they won't be able to use their killstreaks once obtained because we clear the action slots in giveLoadout())
					self _setActionSlot( i + 4, "weapon", killstreakWeapon );
				}
			}

			self.killstreakIndexWeapon = undefined;
			self.pers["lastEarnedStreak"] = self.pers["killstreaks"][highestStreakIndex].streakName;
			self updateStreakSlots();
		}
	}
	else
	{
		self.killstreakIndexWeapon = undefined;
		self.pers["lastEarnedStreak"] = undefined;
		self updateStreakSlots();

		// NOTE: we used to take item weapons from the player here but that stopped killstreak weapon animations from playing if it was the only killstreak
		//		since we take the item weapons when we give a killstreak weapon anyways, no need to do that here
		//		we've also added the waitTakeKillstreakWeapon() function to take them when appropriate
		// VERY IMPORTANT: with the current system, we NEVER want to loop and take all weapon list items
	}
}

clearKillstreaks()
{
	for( i = self.pers["killstreaks"].size - 1; i > -1; i-- )
	{
		if( IsDefined( self.pers["killstreaks"][i] ) )
			self.pers["killstreaks"][i] = undefined;
	}		
	
	initPlayerKillstreaks();
		
	self resetAdrenaline();
	self.killstreakIndexWeapon = undefined;
	self updateStreakSlots();
}

updateSpecialistKillstreaks()
{
	// reset if no adrenaline
	if( self.adrenaline == 0 )
	{
		for( i = KILLSTREAK_SLOT_1; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
		{
			if( IsDefined( self.pers["killstreaks"][i] ) )
			{
				self.pers["killstreaks"][i].available = false;
				self SetPlayerData( "killstreaksState", "hasStreak", i, false );
			}
		}
		self SetPlayerData( "killstreaksState", "nextIndex", 1 );
		self SetPlayerData( "killstreaksState", "hasStreak", KILLSTREAK_ALL_PERKS_SLOT, false );
	}
	else
	{
		// loop through each earnable killstreak
		for( i = KILLSTREAK_SLOT_1; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
		{			
			if( IsDefined( self.pers["killstreaks"][i] ) && 
				IsDefined( self.pers["killstreaks"][i].streakName ) &&
				self.pers["killstreaks"][i].available )
			{
				streakVal = getStreakCost( self.pers["killstreaks"][i].streakName );
				if( streakVal > self.adrenaline )
				{
					// reset them because we're going to check them again and set them
					self.pers["killstreaks"][i].available = false;
					self SetPlayerData( "killstreaksState", "hasStreak", i, false );
					continue;
				}

				if( self.adrenaline >= streakVal )
				{
					// no need to give this again if we've already got it, this fixes a bug where all of the achieved sounds play as you enter the next round
					//	this also fixes a possibility of getting credit for getting another set of this killstreak in your player stats
					if( self GetPlayerData( "killstreaksState", "hasStreak", i ) )
					{
						// just call the killstreak function so we give the specialist perk back to the player each round
						if( IsDefined( level.killstreakFuncs[ self.pers["killstreaks"][i].streakName ] ) )
							self [[ level.killstreakFuncs[ self.pers["killstreaks"][i].streakName ] ]]();
						
						continue;
					}

					self giveKillstreak( self.pers["killstreaks"][i].streakName, self.pers["killstreaks"][i].earned, false, self, true );
				}
			}
		}

		// at a certain number of kills we'll give you all perks
		numKills = NUM_KILLS_GIVE_ALL_PERKS;
		if( self _hasPerk( "specialty_hardline" ) )
			numKills--;
		if( self _hasPerk( "specialty_hardline2" ) )
			numKills--;

		if( self.adrenaline >= numKills )
		{
			self SetPlayerData( "killstreaksState", "hasStreak", KILLSTREAK_ALL_PERKS_SLOT, true );
			self giveAllPerks();
		}
		else
			self SetPlayerData( "killstreaksState", "hasStreak", KILLSTREAK_ALL_PERKS_SLOT, false );
	}

	// update gimme slot killstreak regardless
	if ( self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].available )
	{
		streakName = self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].streakName;
		killstreakWeapon = getKillstreakWeapon( streakName );
		
		if( level.console || self is_player_gamepad_enabled() )
		{
			self giveKillstreakWeapon( killstreakWeapon );		
			self.killstreakIndexWeapon = KILLSTREAK_GIMME_SLOT;		
		}
		else
		{
			self _giveWeapon( killstreakWeapon );
			self _setActionSlot( 4, "weapon", killstreakWeapon );
			self.killstreakIndexWeapon = undefined;		
		}
	}
}

getFirstPrimaryWeapon()
{
	weaponsList = self getWeaponsListPrimaries();
	
	assert ( IsDefined( weaponsList[0] ) );
	assert ( !isKillstreakWeapon( weaponsList[0] ) );

	return weaponsList[0];
}


killstreakUseWaiter()
{
	self endon( "disconnect" );
	self endon( "finish_death" );
	self endon( "joined_team" );
	self endon( "faux_spawn" );
	level endon( "game_ended" );
	
	self notify( "killstreakUseWaiter" );
	self endon( "killstreakUseWaiter" );

	self.lastKillStreak = 0;
	if ( !IsDefined( self.pers["lastEarnedStreak"] ) )
		self.pers["lastEarnedStreak"] = undefined;
		
	self thread finishDeathWaiter();

	for ( ;; )
	{
		self waittill ( "weapon_change", newWeapon );
		
		if ( !isAlive( self ) )
			continue;

		if ( !IsDefined( self.killstreakIndexWeapon ) )
			continue;

		if ( !IsDefined( self.pers["killstreaks"][self.killstreakIndexWeapon] ) || !IsDefined( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName ) )
			continue;

		killstreakWeapon = getKillstreakWeapon( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName );
		if ( newWeapon != killstreakWeapon )
		{
			// since this weapon is not the killstreak we have selected, go back to the last weapon if we're holding an airdrop canister
			if( isStrStart( newWeapon, "airdrop_" ) )
			{
				self TakeWeapon( newWeapon );
				self SwitchToWeapon( self.lastdroppableweapon );
			}
			continue;
		}

		waittillframeend;
		
		//	get this stuff now because self.killstreakIndexWeapon will change after killstreakUsePressed()
		streakName = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
		isGimme = self.pers["killstreaks"][self.killstreakIndexWeapon].isGimme;		
		
		assert( IsDefined( streakName ) );
		assert( IsDefined( level.killstreakFuncs[ streakName ] ) );		
		
		result = self killstreakUsePressed();

		lastWeapon = undefined;
		
		if ( !result && !isAlive( self ) && !self hasWeapon( self getLastWeapon() ) )
		{
			//	on death your weapon is dropped, if a private match default class was created with no secondary
			//	then getFirstPrimaryWeapon() in the 'else if' below will assert because you have no weapons left
			lastWeapon = self getLastWeapon();
			self _giveWeapon( lastWeapon );
		}		
		else if( !self hasWeapon( self getLastWeapon() ) )
		{
			lastWeapon = self getFirstPrimaryWeapon();			
		}
		else
		{
			lastWeapon = self getLastWeapon();
		}
		
		// we need to take the killstreak weapon away once we've switched back to our last weapon
		// this fixes an issue where you can call in a killstreak and then press right again to pull the killstreak weapon out
		if( result )
			self thread waitTakeKillstreakWeapon( killstreakWeapon, lastWeapon );

		//no force switching weapon for ridable killstreaks
		if ( shouldSwitchWeaponPostKillstreak( result, streakName ) )
		{
			self SwitchToWeapon( lastWeapon );
		}

		// give time to switch to the near weapon; when the weapon is none (such as during a "disableWeapon()" period
		// re-enabling the weapon immediately does a "weapon_change" to the killstreak weapon we just used.  In the case that 
		// we have two of that killstreak, it immediately uses the second one
		if ( self GetCurrentWeapon() == "none" )
		{
			while ( self GetCurrentWeapon() == "none" )
				wait ( 0.05 );

			waittillframeend;
		}
		
		if( IsDefined( level.cb_usedKillstreak ) && result )
		{
			[[level.cb_usedKillstreak]]( streakName, isGimme );
	}
}
}

waitTakeKillstreakWeapon( killstreakWeapon, lastWeapon )
{
	self endon( "disconnect" );
	self endon( "finish_death" );
	self endon( "joined_team" );
	level endon( "game_ended" );

	self notify( "waitTakeKillstreakWeapon" );
	self endon( "waitTakeKillstreakWeapon" );

	// planted killstreaks like the sam, sentry, remote turret, and ims, will come in here with none as the current weapon sometimes because we _disableWeapons() while you carry them
	//	we need to know this so we can take the weapon correctly in these cases
	wasNone = ( self GetCurrentWeapon() == "none" );

	// this lets the killstreak weapon animation play and then take it once we switch away from it
	self waittill( "weapon_change", newWeapon );

	if( newWeapon == lastWeapon )
	{
		takeKillstreakWeaponIfNoDupe( killstreakWeapon );
		// pc needs to reset the killstreakIndexWeapon because we set this when they press the use button and we don't want the value lingering
		if( !level.console && !self is_player_gamepad_enabled() )
			self.killstreakIndexWeapon = undefined;
	}
	// this could happen with ridden killstreaks like the ac130
	else if( newWeapon != killstreakWeapon )
	{
		self thread waitTakeKillstreakWeapon( killstreakWeapon, lastWeapon );
	}
	// this could happen with planted killstreaks like the sam, sentry, remote turret, and ims
	//	they come into this function with current weapon as none and then the weapon change fires off immediately because we call _enableWeapons()
	//	that gives us back the killstreak weapon and it plays an animation before switching back to your normal weapon
	else if( wasNone && self GetCurrentWeapon() == killstreakWeapon )
	{
		self thread waitTakeKillstreakWeapon( killstreakWeapon, lastWeapon );
	}
}

takeKillstreakWeaponIfNoDupe( killstreakWeapon )
{
	// only take the killstreak weapon if they don't have anymore
	// the player could have two of the same killstreak and if we take the weapon then they can't use the second one
	hasKillstreak = false;
	for( i = 0; i < self.pers["killstreaks"].size; i++ )
	{
		if( IsDefined( self.pers["killstreaks"][i] ) && 
			IsDefined( self.pers["killstreaks"][i].streakName ) &&
			self.pers["killstreaks"][i].available )
		{
			// the specialist streaks use the killstreak_uav_mp weapon so don't try to compare specialist killstreak weapons
			//	this fixes a bug where you earn a uav, change classes to specialist and earn the first streak, use the uav and the killstreak weapon doesn't get taken because it thinks you still have one
			if( !isSpecialistKillstreak( self.pers["killstreaks"][i].streakName ) && killstreakWeapon == getKillstreakWeapon( self.pers["killstreaks"][i].streakName ) )
			{
				hasKillstreak = true;
				break;
			}
		}
	}

	// if they have the killstreak then check to see if the currently selected killstreak is the same killstreak, if not take the weapon because it'll be given to them when they select it
	if( hasKillstreak )
	{
		if( level.console || self is_player_gamepad_enabled() )
		{
			if( IsDefined( self.killstreakIndexWeapon ) && killstreakWeapon != getKillstreakWeapon( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName ) )
			{
				// take the weapon because it's currently not the selected killstreak
				self TakeWeapon( killstreakWeapon );
			}
			else if( IsDefined( self.killstreakIndexWeapon ) && killstreakWeapon == getKillstreakWeapon( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName ) )
			{
				// take and give it right back, this fixes an issue where you could have two of the same weapons and after using the first then you couldn't use the second
				//	this was reproduced by doing predator, precision airstrike, strafe run, where airstrike and strafe run use the same weapon
				//	so if you called in the predator, then called in the strafe, you couldn't use the airstrike because you no longer have the weapon
				//	script isn't taking the weapon from you but code was saying clear that slot because the weapons were 'clip only', they shouldn't be
				self TakeWeapon( killstreakWeapon );
				self _giveWeapon( killstreakWeapon, 0 );
				self _setActionSlot( 4, "weapon", killstreakWeapon );
			}
		}
		// pc doesn't have selected killstreaks
		else
		{
			// we still want to take and give to make sure they have the weapon
			self TakeWeapon( killstreakWeapon );
			self _giveWeapon( killstreakWeapon, 0 );
		}
	}
	else
		self TakeWeapon( killstreakWeapon );
}

shouldSwitchWeaponPostKillstreak( result, streakName )
{
	// certain killstreaks handle the weapon switching
	switch( streakName )
	{
	case "uav_strike":
		if( !result )
			return false;
	}
	if( !result )
		return true;
	if( isRideKillstreak( streakName ) )
		return false;

	return true;	
}


finishDeathWaiter()
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "finishDeathWaiter" );
	self endon ( "finishDeathWaiter" );
	
	self waittill ( "death" );
	wait ( 0.05 );
	self notify ( "finish_death" );
	self.pers["lastEarnedStreak"] = undefined;
}

checkStreakReward()
{
	foreach ( streakName in self.killstreaks )
	{
		streakVal = getStreakCost( streakName );
		
		if ( streakVal > self.adrenaline )
			break;
		
		if ( self.previousAdrenaline < streakVal && self.adrenaline >= streakVal )
		{
			// to avoid confusion about not really earning a killstreak if you already have it and come around again
			//	we're going to give you the killstreak again and also allow it to chain
			self earnKillstreak( streakName, streakVal ); 

			////	No stacking (double earning)
			//alreadyEarned = false;
			//for ( i=1; i<self.pers["killstreaks"].size; i++ )
			//{
			//	if( IsDefined( self.pers["killstreaks"][i] ) && 
			//		( IsDefined( self.pers["killstreaks"][i].streakName ) && self.pers["killstreaks"][i].streakName == streakName ) && 
			//		( IsDefined( self.pers["killstreaks"][i].available ) && self.pers["killstreaks"][i].available == true ) )
			//	{
			//		alreadyEarned = true;
			//		break;
			//	}
			//}
			//if ( alreadyEarned )
			//{
			//	self.earnedStreakLevel = streakVal;
			//	updateStreakSlots();
			//}
			//else
			//	self earnKillstreak( streakName, streakVal ); 
			//break;
		}
	}
}

getCustomClassLoc()
{
	if ( getdvarint( "xblive_privatematch" ) )
	{
		return "privateMatchCustomClasses";
	}
	else
	{
		return "customClasses";
	} 
}

killstreakEarned( streakName )
{
	streakArray = "assault";
	switch ( self.streakType )
	{
		case "assault":
			streakArray = "assaultStreaks";
			break;
		case "support":
			streakArray = "defenseStreaks";
			break;
		case "specialist":
			streakArray = "specialistStreaks";
			break;
	}

	if( IsDefined( self.class_num ) )
	{
		customClassLoc = getCustomClassLoc();
		if ( self getPlayerData( customClassLoc, self.class_num, streakArray, 0 ) == streakName )
		{
			self.firstKillstreakEarned = getTime();
		}	
		else if ( self getPlayerData( customClassLoc, self.class_num, streakArray, 2 ) == streakName && IsDefined( self.firstKillstreakEarned ) )
		{
			if ( getTime() - self.firstKillstreakEarned < 20000 )
				self thread maps\mp\gametypes\_missions::genericChallenge( "wargasm" );
		}
	}
}


earnKillstreak( streakName, streakVal )
{
	level notify ( "gave_killstreak", streakName );
	
	self.earnedStreakLevel = streakVal;

	if ( !level.gameEnded )
	{
		appendString = undefined;
		// if this is specialist then we need to see if they are using the pro versions of perks in the streak
		//if( self.streakType == "specialist" )
		//{
			//perkName = GetSubStr( streakName, 0, streakName.size - 3 );
			//if( maps\mp\gametypes\_class::isPerkUpgraded( perkName ) )
			//{
			//	appendString = "pro";
			//}
		//}
		self thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( streakName, streakVal, appendString );
	}

	self thread killstreakEarned( streakName );
	self.pers["lastEarnedStreak"] = streakName;

	self setStreakCountToNext();		

	self giveKillstreak( streakName, true, true );
}

giveKillstreak( streakName, isEarned, awardXp, owner, skipMiniSplash )
{
	self endon( "givingLoadout" );

	if ( !IsDefined( level.killstreakFuncs[streakName] ) || tableLookup( KILLSTREAK_STRING_TABLE, 1, streakName, 0 ) == "" )
	{
		AssertMsg( "giveKillstreak() called with invalid killstreak: " + streakName );
		return;
	}	
	//	for devmenu give with spectators in match 
	if( !IsDefined( self.pers["killstreaks"] ) )
		return;
	
	self endon ( "disconnect" );	
	
	if( !IsDefined( skipMiniSplash ) )
		skipMiniSplash = false;

	//	streaks given from crates go in the gimme 
	index = undefined;
	if ( !IsDefined( isEarned ) || isEarned == false )
	{
		// put this killstreak in the next available position
		// 0 - gimme slot (that will index stacked killstreaks)
		// 1-3 - cac selected killstreaks
		// 4 - specialist all perks bonus
		// 5 or more - stacked killstreaks

		// MW3 way so it will stack in the gimme slot
		nextSlot = self.pers[ "killstreaks" ].size; // the size should be 5 by default, it will grow as they get stacked killstreaks
		// NOTE: match leveling prototype
		//	replacing whatever is in slot 0 every time we get a killstreak, MW3 did stacking
		//nextSlot = 5;
		if( !IsDefined( self.pers[ "killstreaks" ][ nextSlot ] ) )
			self.pers[ "killstreaks" ][ nextSlot ] = spawnStruct();

		self.pers[ "killstreaks" ][ nextSlot ].available = false;
		self.pers[ "killstreaks" ][ nextSlot ].streakName = streakName;
		self.pers[ "killstreaks" ][ nextSlot ].earned = false;
		self.pers[ "killstreaks" ][ nextSlot ].awardxp = IsDefined( awardXp ) && awardXp;
		self.pers[ "killstreaks" ][ nextSlot ].owner = owner;
		self.pers[ "killstreaks" ][ nextSlot ].kID = self.pers["kID"];
		self.pers[ "killstreaks" ][ nextSlot ].lifeId = -1;
		self.pers[ "killstreaks" ][ nextSlot ].isGimme = true;		
		self.pers[ "killstreaks" ][ nextSlot ].isSpecialist = false;		

		self.pers[ "killstreaks" ][ KILLSTREAK_GIMME_SLOT ].nextSlot = nextSlot;		
		self.pers[ "killstreaks" ][ KILLSTREAK_GIMME_SLOT ].streakName = streakName;

		index = KILLSTREAK_GIMME_SLOT;	
		streakIndex = getKillstreakIndex( streakName );	
		self setPlayerData( "killstreaksState", "icons", KILLSTREAK_GIMME_SLOT, streakIndex );
		
		// some things may need to skip the mini-splash, like deathstreaks that give killstreaks
		if( !skipMiniSplash )
		{
			showSelectedStreakHint( streakName );		
		}
	}
	else
	{
		for( i = KILLSTREAK_SLOT_1; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
		{
			if( IsDefined( self.pers["killstreaks"][i] ) && 
				IsDefined( self.pers["killstreaks"][i].streakName ) &&
				streakName == self.pers["killstreaks"][i].streakName )
			{
				index = i;
				break;
			}
		}		
		if ( !IsDefined( index ) )
		{
			AssertMsg( "earnKillstreak() trying to give unearnable killstreak with giveKillstreak(): " + streakName );
			return;
		}		
	}
	
	self.pers["killstreaks"][index].available = true;
	self.pers["killstreaks"][index].earned = IsDefined( isEarned ) && isEarned;
	self.pers["killstreaks"][index].awardxp = IsDefined( awardXp ) && awardXp;
	self.pers["killstreaks"][index].owner = owner;
	self.pers["killstreaks"][index].kID = self.pers["kID"];
	//self.pers["kIDs_valid"][self.pers["kID"]] = true;
	self.pers["kID"]++;

	if ( !self.pers["killstreaks"][index].earned )
		self.pers["killstreaks"][index].lifeId = -1;
	else
		self.pers["killstreaks"][index].lifeId = self.pers["deaths"];
		
	// the specialist streak type automatically turns on and there is no weapon to use
	if( self.streakType == "specialist" && index != KILLSTREAK_GIMME_SLOT )
	{
		self.pers[ "killstreaks" ][ index ].isSpecialist = true;		
		if( IsDefined( level.killstreakFuncs[ streakName ] ) )
			self [[ level.killstreakFuncs[ streakName ] ]]();
		//self thread updateKillstreaks();
		self usedKillstreak( streakName, awardXp );
	}
	else
	{
		if( level.console || self is_player_gamepad_enabled() )
		{
			weapon = getKillstreakWeapon( streakName );
			self giveKillstreakWeapon( weapon );	

			// NOTE_A (also see NOTE_B): before we change the killstreakIndexWeapon, let's make sure it's not the one we're holding
			//	if we're currently holding something like an airdrop marker and we earned a killstreak while holding it then we want that to remain the weapon index
			//	because if it's not, then when you throw it, it'll think we're using a different killstreak and not take it away but it'll take away the other one
			if( IsDefined( self.killstreakIndexWeapon ) )
			{
				streakName = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
				killstreakWeapon = getKillstreakWeapon( streakName );
				if( self GetCurrentWeapon() != killstreakWeapon )
				{
					self.killstreakIndexWeapon = index;
				}
			}
			else
			{
				self.killstreakIndexWeapon = index;		
			}
		}
		else
		{
			// for pc, we need to give you the killstreak weapon in the right action slot
			
			// if this is the gimme slot then take away the weapon for what is in there right now and just give them this new one
			//	we don't want to keep giving weapons every time they get something in the gimme slot because there is a cap eventually
			if( KILLSTREAK_GIMME_SLOT == index && self.pers[ "killstreaks" ][ KILLSTREAK_GIMME_SLOT ].nextSlot > KILLSTREAK_STACKING_START_SLOT )
			{
				// since nextSlot has already been incremented, get the next lowest and take the weapon
				slotToTake = self.pers[ "killstreaks" ][ KILLSTREAK_GIMME_SLOT ].nextSlot - 1;
				killstreakWeaponToTake = getKillstreakWeapon( self.pers["killstreaks"][ slotToTake ].streakName );		
				self TakeWeapon( killstreakWeaponToTake );
			}

			killstreakWeapon = getKillstreakWeapon( streakName );		
			self _giveWeapon( killstreakWeapon, 0 );
			self _setActionSlot( index + 4, "weapon", killstreakWeapon );
		}
	}
		
	self updateStreakSlots();
	
	if ( IsDefined( level.killstreakSetupFuncs[ streakName ] ) )
		self [[ level.killstreakSetupFuncs[ streakName ] ]]();
		
	if ( IsDefined( isEarned ) && isEarned && IsDefined( awardXp ) && awardXp )
		self notify( "received_earned_killstreak" );
}


giveKillstreakWeapon( weapon )
{
	self endon( "disconnect" );

	// pc doesn't need to give the weapon because you use on a single button press (unless using gamepad)
	if( !level.console && !self is_player_gamepad_enabled() )
		return;

	weaponList = self GetWeaponsListItems();
	
	foreach( item in weaponList )
	{
		if( !isStrStart( item, "killstreak_" ) && !isStrStart( item, "airdrop_" ) && !isStrStart( item, "deployable_" ) )
			continue;
	
		if( self GetCurrentWeapon() == item )
			continue;
		
		while( self isChangingWeapon() )
			wait ( 0.05 );	
			
		self TakeWeapon( item );
	}
	
	// NOTE_B (also see NOTE_A) : before we giving the killstreak weapon, let's make sure it's not the one we're holding
	//	if we're currently holding something like an airdrop marker and we earned a killstreak while holding it then we want that to remain the killstreak weapon
	//	because if it's not, then when we earn the new killstreak, we won't be able to put this one away because it thinks it's something else
	if( IsDefined( self.killstreakIndexWeapon ) )
	{
		streakName = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
		killstreakWeapon = getKillstreakWeapon( streakName );
		if( self GetCurrentWeapon() != killstreakWeapon )
		{
			self _giveWeapon( weapon, 0 );
			self _setActionSlot( 4, "weapon", weapon );
		}
	}
	else
	{
		self _giveWeapon( weapon, 0 );
		self _setActionSlot( 4, "weapon", weapon );
	}
}


getStreakCost( streakName )
{
	cost = int( tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_KILLS_COLUMN ) );

	if( IsDefined( self ) && IsPlayer( self ) )
	{
		if( isSpecialistKillstreak( streakName ) )
		{
			if ( isDefined( self.pers["gamemodeLoadout"] ) )
			{
				if ( isDefined( self.pers["gamemodeLoadout"]["loadoutKillstreak1"] ) && self.pers["gamemodeLoadout"]["loadoutKillstreak1"] == streakName )
					cost = 2;
				else if ( isDefined( self.pers["gamemodeLoadout"]["loadoutKillstreak2"] ) && self.pers["gamemodeLoadout"]["loadoutKillstreak2"] == streakName )
					cost = 4;
				else if ( isDefined( self.pers["gamemodeLoadout"]["loadoutKillstreak3"] ) && self.pers["gamemodeLoadout"]["loadoutKillstreak3"] == streakName )
					cost = 6;
				else
					AssertMsg( "getStreakCost: killstreak doesn't exist in player's loadout" );	
			}			
			else if ( IsSubStr( self.curClass, "custom" ) )
			{
				customClassLoc = getCustomClassLoc();
				index = 0;
				for( ; index < KILLSTREAK_ALL_PERKS_SLOT; index++ )
				{
					killstreak = self GetPlayerData( customClassLoc, self.class_num, "specialistStreaks", index );
					if( killstreak == streakName )
						break;
				}
				AssertEx( index < KILLSTREAK_ALL_PERKS_SLOT, "getStreakCost: killstreak index greater than allowed." );
				cost = self GetPlayerData( customClassLoc, self.class_num, "specialistStreakKills", index );
			}
			else if ( isSubstr( self.curClass, "axis" ) || isSubstr( self.curClass, "allies" ) )
			{
				index = 0;
				teamName = "none";
				if( isSubstr( self.curClass, "axis" ) )
				{
					teamName = "axis";
				}
				else if( isSubstr( self.curClass, "allies" ) )
				{
					teamName = "allies";
				}

				classIndex = maps\mp\gametypes\_class::getClassIndex( self.curClass );
				for( ; index < KILLSTREAK_ALL_PERKS_SLOT; index++ )
				{
					killstreak = GetMatchRulesData( "defaultClasses", teamName, classIndex, "class", "specialistStreaks", index );					
					if( killstreak == streakName )
						break;
				}
				AssertEx( index < KILLSTREAK_ALL_PERKS_SLOT, "getStreakCost: killstreak index greater than allowed." );
				cost = GetMatchRulesData( "defaultClasses", teamName, classIndex, "class", "specialistStreakKills", index );
			}
		}

		if( self _hasPerk( "specialty_hardline" ) && cost > 0 )
			cost--;
		if( self _hasPerk( "specialty_hardline2" ) && cost > 0 )
			cost--;
	}
	return cost;
}

isAssaultKillstreak( refString )
{
	switch ( refString )
	{
	case "uav":
	case "airdrop_assault":
	case "predator_missile":
	case "ims":
	case "airdrop_sentry_minigun":
	case "precision_airstrike":
	case "orbital_laser":
	case "helicopter":
	case "littlebird_flock":
	case "littlebird_support":
	case "remote_mortar":
	case "airdrop_remote_tank":
	case "helicopter_flares":
	case "ac130":
	case "airdrop_juggernaut":
	case "osprey_gunner":
	case "guard_dog":
		return true;
	default:
		return false;
	}
}

isSupportKillstreak( refString )
{
	switch ( refString )
	{
	case "uav_support":
	case "counter_uav":
	case "deployable_vest":
	case "airdrop_trap":
	case "sam_turret":
	case "remote_uav":
	case "triple_uav":
	case "remote_mg_turret":
	case "stealth_airstrike":
	case "emp":
	case "airdrop_juggernaut_recon":
	case "escort_airdrop":
		return true;
	default:
		return false;
	}
}

isSpecialistKillstreak( refString )
{
	switch ( refString )
	{
	case "specialty_longersprint_ks":
	case "specialty_fastreload_ks":
	case "specialty_scavenger_ks":
	case "specialty_blindeye_ks":
	case "specialty_paint_ks":
	case "specialty_hardline_ks":
	case "specialty_coldblooded_ks":
	case "specialty_quickdraw_ks":
	case "specialty_assists_ks":
	case "_specialty_blastshield_ks":
	case "specialty_detectexplosive_ks":
	case "specialty_autospot_ks":
	case "specialty_bulletaccuracy_ks":
	case "specialty_quieter_ks":
	case "specialty_stalker_ks":
	case "all_perks_bonus":
		return true;
	default:
		return false;
	}
}

getKillstreakHint( streakName )
{
	return tableLookupIString( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_EARNED_HINT_COLUMN );
}


getKillstreakInformEnemy( streakName )
{
	return int( tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_ENEMY_USE_DIALOG_COLUMN ) );
}


getKillstreakSound( streakName )
{
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_SOUND_COLUMN );
}


getKillstreakDialog( streakName )
{
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_EARN_DIALOG_COLUMN );
}


getKillstreakWeapon( streakName )
{
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_WEAPON_COLUMN );
}

getKillstreakIcon( streakName )
{
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_ICON_COLUMN );
}

getKillstreakCrateIcon( streakName )
{
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_OVERHEAD_ICON_COLUMN );
}

getKillstreakDpadIcon( streakName )
{
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_DPAD_ICON_COLUMN );
}

getKillstreakIndex( streakName )
{
	return tableLookupRowNum( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName )-1;
}

streakTypeResetsOnDeath( streakType )
{
	switch ( streakType )
	{
		case "assault":
		case "specialist":
			return true;
		case "support":
			return false;
	}
}

giveOwnedKillstreakItem( skipDialog )
{	
	if( level.console || self is_player_gamepad_enabled() )
	{
		//	find the highest costing streak
		keepIndex = -1;
		highestCost = -1;
		for( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
		{
			if( IsDefined( self.pers["killstreaks"][i] ) && 
				IsDefined( self.pers["killstreaks"][i].streakName ) &&
				self.pers["killstreaks"][i].available && 
				getStreakCost( self.pers["killstreaks"][i].streakName ) > highestCost )
			{
				// make sure the gimme slot is the lowest regardless of the cost of the killstreak in it
				highestCost = 0;
				if( !self.pers["killstreaks"][i].isGimme )
					highestCost = getStreakCost( self.pers["killstreaks"][i].streakName );
				keepIndex = i;	
			} 
		}

		if ( keepIndex != -1 )
		{
			//	select it
			self.killstreakIndexWeapon = keepIndex;

			//	give the weapon
			streakName = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;
			weapon = getKillstreakWeapon( streakName );
			self giveKillstreakWeapon( weapon );		

			if ( !IsDefined( skipDialog ) && !level.inGracePeriod )
				showSelectedStreakHint( streakName );		
		}	
		else
			self.killstreakIndexWeapon = undefined;			
	}
	// pc doesn't select killstreaks
	else
	{
		keepIndex = -1;
		highestCost = -1;
		// make sure we still have all of the available killstreak weapons
		for( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
		{
			if( IsDefined( self.pers["killstreaks"][i] ) && 
				IsDefined( self.pers["killstreaks"][i].streakName ) &&
				self.pers["killstreaks"][i].available )
			{
				killstreakWeapon = getKillstreakWeapon( self.pers["killstreaks"][i].streakName );
				weaponsListItems = self GetWeaponsListItems();
				hasKillstreakWeapon = false;
				for( j = 0; j < weaponsListItems.size; j++ )
				{
					if( killstreakWeapon == weaponsListItems[j] )
					{
						hasKillstreakWeapon = true;
						break;
					}
				}

				if( !hasKillstreakWeapon )
				{
					self _giveWeapon( killstreakWeapon );
				}
				else
				{
					// if we have more than one airdrop type weapon the ammo gets set to 0 because we give the next airdrop weapon before we take the last one
					//	this is a quicker fix than trying to figure out how to take and give at the right times
					if( IsSubStr( killstreakWeapon, "airdrop_" ) )
						self SetWeaponAmmoClip( killstreakWeapon, 1 );
				}

				// since the killstreak is available, make sure the actionslot is set correctly
				//	this fixes a bug where you could have, for example, a uav in your gimme slot and earned a uav before you died, when you respawned the earned uav actionslot wasn't set and you couldn't use it
				self _setActionSlot( i + 4, "weapon", killstreakWeapon );

				// get the highest value killstreak so we can show hint text for it on spawn
				// make sure the gimme slot is the lowest regardless of the cost of the killstreak in it
				if( getStreakCost( self.pers["killstreaks"][i].streakName ) > highestCost )
				{
					highestCost = 0;
					if( !self.pers["killstreaks"][i].isGimme )
						highestCost = getStreakCost( self.pers["killstreaks"][i].streakName );
					keepIndex = i;	
				}
			}
		}

		if ( keepIndex != -1 )
		{
			streakName = self.pers["killstreaks"][ keepIndex ].streakName;
			if ( !IsDefined( skipDialog ) && !level.inGracePeriod )
				showSelectedStreakHint( streakName );		
		}

		self.killstreakIndexWeapon = undefined;
	}
		
	updateStreakSlots();	
}


initRideKillstreak( streak )
{
	self _disableUsability();
	result = self initRideKillstreak_internal( streak );

	if ( IsDefined( self ) )
		self _enableUsability();
		
	return result;
}


initRideKillstreak_internal( streak )
{	
	if ( IsDefined( streak ) && ( ( streak == "osprey_gunner" ) || ( streak == "remote_uav" ) || ( streak == "remote_tank" ) || ( streak == "warbird" ) ) )
		laptopWait = "timeout";
	else
		laptopWait = self waittill_any_timeout( 1.0, "disconnect", "death", "weapon_switch_started" );
		
	maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

	if ( laptopWait == "weapon_switch_started" )
		return ( "fail" );

	if ( !isAlive( self ) )
		return "fail";

	if ( laptopWait == "disconnect" || laptopWait == "death" )
	{
		if ( laptopWait == "disconnect" )
			return ( "disconnect" );

		if ( self.team == "spectator" )
			return "fail";

		return ( "success" );		
	}
	
	if ( self isEMPed() || self isNuked() || self isAirDenied() )
	{
		return ( "fail" );
	}
	
	self VisionSetNakedForPlayer( "black_bw", 0.75 );
	blackOutWait = self waittill_any_timeout( 0.80, "disconnect", "death" );

	maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();

	if ( blackOutWait != "disconnect" ) 
	{
		self thread clearRideIntro( 1.0 );
		
		if ( self.team == "spectator" )
			return "fail";
	}

	if ( self isOnLadder() )
		return "fail";	

	if ( !isAlive( self ) )
		return "fail";

	if ( self isEMPed() || self isNuked() || self isAirDenied() )
		return "fail";
	
	if ( blackOutWait == "disconnect" )
		return ( "disconnect" );
	else
		return ( "success" );		
}


clearRideIntro( delay )
{
	self endon( "disconnect" );

	if ( IsDefined( delay ) )
		wait( delay );

	//self freezeControlsWrapper( false );
	
	if ( IsDefined( level.nukeDetonated ) )
		self VisionSetNakedForPlayer( level.nukeVisionSet, 0 );
	else
		self VisionSetNakedForPlayer( "", 0 ); // go to default visionset
}


giveSelectedKillstreakItem()
{
	streakName = self.pers["killstreaks"][self.killstreakIndexWeapon].streakName;

	weapon = getKillstreakWeapon( streakName );
	self giveKillstreakWeapon( weapon );
	
	self updateStreakSlots();
}

showSelectedStreakHint( streakName )
{
	actionData = spawnStruct();
	actionData.name = "selected_" + streakName;
	actionData.type = "killstreak_minisplash";	
	actionData.optionalNumber = getStreakCost( streakName );
	actionData.leaderSound = streakName;
	actionData.leaderSoundGroup = "killstreak_earned";
	actionData.slot = 0;	
	
	self.notifyText.alpha = 0;
	self.notifyText2.alpha = 0;
	self.notifyIcon.alpha = 0;
	self thread maps\mp\gametypes\_hud_message::actionNotifyMessage( actionData );
}

getKillstreakCount()
{
	numAvailable = 0;
	for( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
	{
		if( IsDefined( self.pers["killstreaks"][i] ) && 
			IsDefined( self.pers["killstreaks"][i].streakName ) &&
			self.pers["killstreaks"][i].available )
		{
			numAvailable++;
		}
	}
	return numAvailable;
}

shuffleKillstreaksUp()
{
	if ( getKillstreakCount() > 1 )
	{		
		while ( true )
		{
			self.killstreakIndexWeapon++;		
			if ( self.killstreakIndexWeapon > KILLSTREAK_ALL_PERKS_SLOT )
				self.killstreakIndexWeapon = 0;
			if ( self.pers["killstreaks"][self.killstreakIndexWeapon].available == true )
				break;			
		}
		
		giveSelectedKillstreakItem();		
		showSelectedStreakHint( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName );
	}
}

shuffleKillstreaksDown()
{
	if ( getKillstreakCount() > 1 )
	{
		while ( true )
		{
			self.killstreakIndexWeapon--;		
			if ( self.killstreakIndexWeapon < 0 )
				self.killstreakIndexWeapon = KILLSTREAK_ALL_PERKS_SLOT - 1;
			if ( self.pers["killstreaks"][self.killstreakIndexWeapon].available == true )
				break;
		}
		
		giveSelectedKillstreakItem();		
		showSelectedStreakHint( self.pers["killstreaks"][self.killstreakIndexWeapon].streakName );
	}
}

streakSelectUpTracker()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "faux_spawn" );
	level endon ( "game_ended" );
	
	for (;;)
	{
		self waittill( "toggled_up" );
		
		if ( !level.Console && !self is_player_gamepad_enabled() )
			continue;
		
		if( !self isMantling() &&
			( !IsDefined( self.changingWeapon ) || ( IsDefined( self.changingWeapon ) && self.changingWeapon == "none" ) ) && 
			( !isKillstreakWeapon( self GetCurrentWeapon() ) || ( isKillstreakWeapon( self GetCurrentWeapon() ) && self isJuggernaut() ) ) &&
			self.streakType != "specialist" &&
			( !IsDefined( self.isCarrying ) || ( IsDefined( self.isCarrying ) && self.isCarrying == false ) ) )
		{
			self shuffleKillstreaksUp();
		}
		wait( .12 );
	}
}

streakSelectDownTracker()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "faux_spawn" );
	level endon ( "game_ended" );
	
	for (;;)
	{
		self waittill( "toggled_down" );
		
		if ( !level.Console && !self is_player_gamepad_enabled() )
			continue;
		
		if( !self isMantling() &&
			( !IsDefined( self.changingWeapon ) || ( IsDefined( self.changingWeapon ) && self.changingWeapon == "none" ) ) && 
			( !isKillstreakWeapon( self GetCurrentWeapon() ) || ( isKillstreakWeapon( self GetCurrentWeapon() ) && self isJuggernaut() ) ) &&
			self.streakType != "specialist" &&
			( !IsDefined( self.isCarrying ) || ( IsDefined( self.isCarrying ) && self.isCarrying == false ) ) )
		{
			self shuffleKillstreaksDown();
		}
		wait( .12 );
	}
}

streakNotifyTracker()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	gameFlagWait( "prematch_done" );

	self notifyOnPlayerCommand( "toggled_up", "+actionslot 1" );
	self notifyOnPlayerCommand( "toggled_down", "+actionslot 2" );
	
	if( !level.console )
	{
		self notifyOnPlayerCommand( "streakUsed1", "+actionslot 4" );
		self notifyOnPlayerCommand( "streakUsed2", "+actionslot 5" );
		self notifyOnPlayerCommand( "streakUsed3", "+actionslot 6" );
		self notifyOnPlayerCommand( "streakUsed4", "+actionslot 7" );
		self notifyOnPlayerCommand( "streakUsed5", "+actionslot 8" );
	}
}



//	ADRENALINE STUFF MOVED FROM _UTILITY.GSC
//	TODO: rename

registerAdrenalineInfo( type, value )
{
	if ( !IsDefined( level.adrenalineInfo ) )
		level.adrenalineInfo = [];
		
	level.adrenalineInfo[type] = value;
}


giveAdrenaline( type )
{	
	assertEx( IsDefined( level.adrenalineInfo[type] ), "Unknown adrenaline type: " + type );	
	
	if ( level.adrenalineInfo[type] == 0 && !self _hasPerk( "specialty_adrenaline_bonus_" + type ) )
		return;		
	
	newAdrenaline = self.adrenaline + level.adrenalineInfo[type];
	if ( self _hasPerk( "specialty_adrenaline_bonus_" + type ) )
		newAdrenaline++;

	adjustedAdrenaline = newAdrenaline;
	maxStreakCost = self getMaxStreakCost();
	if ( adjustedAdrenaline > maxStreakCost && ( self.streakType != "specialist" ) )
	{
		adjustedAdrenaline = adjustedAdrenaline - maxStreakCost;
	}
	else if ( level.killstreakRewards && adjustedAdrenaline > maxStreakCost && self.streakType == "specialist" )
	{
		// at a certain number of kills we'll give you all perks
		numKills = NUM_KILLS_GIVE_ALL_PERKS;
		if( self _hasPerk( "specialty_hardline" ) )
			numKills--;
		if( self _hasPerk( "specialty_hardline2" ) )
			numKills--;

		if( adjustedAdrenaline == numKills )
		{
			//self thread giveKillstreak( "airdrop_assault", false, true, self, true );
			//self thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "airdrop_assault", 8 );

			self giveAllPerks();

			self usedKillstreak( "all_perks_bonus", true );
			self thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "all_perks_bonus", numKills );
			self setPlayerData( "killstreaksState", "hasStreak", KILLSTREAK_ALL_PERKS_SLOT, true );
			self.pers["killstreaks"][ KILLSTREAK_ALL_PERKS_SLOT ].available = true;
		}

		// give a little xp for being maxed out and continued streaking, for the specialist only
		// every two kills after max
		if( maxStreakCost > 0 && !( ( adjustedAdrenaline - maxStreakCost ) % 2 ) )
		{
			self thread maps\mp\gametypes\_rank::xpEventPopup( &"MP_SPECIALIST_STREAKING_XP" );
			self thread maps\mp\gametypes\_rank::giveRankXP( "kill" );
		}
	}

	self setAdrenaline( adjustedAdrenaline );
	self checkStreakReward();
	
	if ( newAdrenaline == maxStreakCost && ( self.streakType != "specialist" ) )
		setAdrenaline( 0 );
}

giveAllPerks() // self == player
{
	// for the specialist strike package when you get to a certain number of kills
	// give them all of the perks
	perks = [];
	perks[ perks.size ] = "specialty_longersprint";
	perks[ perks.size ] = "specialty_fastreload";
	perks[ perks.size ] = "specialty_scavenger";
	perks[ perks.size ] = "specialty_blindeye";
	perks[ perks.size ] = "specialty_paint";
	perks[ perks.size ] = "specialty_hardline"; // give hardline because of the hidden killstreaks, like the nuke
	perks[ perks.size ] = "specialty_coldblooded";
	perks[ perks.size ] = "specialty_quickdraw";
	// two primaries doesn't make sense to give
	perks[ perks.size ] = "_specialty_blastshield";
	perks[ perks.size ] = "specialty_detectexplosive";
	perks[ perks.size ] = "specialty_autospot";
	perks[ perks.size ] = "specialty_bulletaccuracy";
	// we aren't doing steadyimpro right now
	perks[ perks.size ] = "specialty_quieter";
	perks[ perks.size ] = "specialty_stalker";
	// give weapon buffs also as an added bonus
	// don't give bullet penetration because there is a performance issue with shotguns and fx when they shoot 8 chunks at once
	perks[ perks.size ] = "specialty_marksman";
	perks[ perks.size ] = "specialty_sharp_focus";
	// don't give hold breath while ads because it'll show up on things like pistols
	perks[ perks.size ] = "specialty_longerrange";
	perks[ perks.size ] = "specialty_fastermelee";
	perks[ perks.size ] = "specialty_reducedsway";
	perks[ perks.size ] = "specialty_lightweight";

	foreach( perkName in perks )
	{
		if( !self _hasPerk( perkName ) )
		{
			self givePerk( perkName, false );
			//if( maps\mp\gametypes\_class::isPerkUpgraded( perkName ) )
			//{
			//	perkUpgrade = tablelookup( "mp/perktable.csv", 1, perkName, 8 );
			//	self givePerk( perkUpgrade, false );
			//}
		}
	}
}

resetAdrenaline()
{
	self.earnedStreakLevel = 0;
	self setAdrenaline(0);		
	self resetStreakCount();	
	if ( IsDefined( self.pers["lastEarnedStreak"] ) )
		self.pers["lastEarnedStreak"] = undefined;
}


setAdrenaline( value )
{
	if ( value < 0 )
		value = 0;
	
	if ( IsDefined( self.adrenaline ) )
		self.previousAdrenaline = self.adrenaline;
	else
		self.previousAdrenaline = 0;
	
	self.adrenaline = value;
	
	self setClientDvar( "ui_adrenaline", self.adrenaline );
	
	self updateStreakCount();
}

pc_watchStreakUse() // self == player
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	self.actionSlotEnabled = [];
	self.actionSlotEnabled[ KILLSTREAK_GIMME_SLOT ] = true;
	self.actionSlotEnabled[ KILLSTREAK_SLOT_1 ] = true;
	self.actionSlotEnabled[ KILLSTREAK_SLOT_2 ] = true;
	self.actionSlotEnabled[ KILLSTREAK_SLOT_3 ] = true;
	self.actionSlotEnabled[ KILLSTREAK_SLOT_4 ] = true;

	while( true )
	{
		result = self waittill_any_return( "streakUsed1", "streakUsed2", "streakUsed3", "streakUsed4", "streakUsed5" );
		
		if( self is_player_gamepad_enabled() )
			continue;

		if( !IsDefined( result ) )
			continue;

		// specialist can only use the gimme slot
		if( self.streakType == "specialist" && result != "streakUsed1" )
			continue;

		// don't let the killstreakIndexWeapon change while we are at none weapon because that could mean we're carrying something like sentry or ims
		if( IsDefined( self.changingWeapon ) && self.changingWeapon == "none" )
			continue;

		switch( result )
		{
		case "streakUsed1":
			if( self.pers["killstreaks"][ KILLSTREAK_GIMME_SLOT ].available && self.actionSlotEnabled[ KILLSTREAK_GIMME_SLOT ] )
				self.killstreakIndexWeapon = KILLSTREAK_GIMME_SLOT;
			break;
		case "streakUsed2":
			if( self.pers["killstreaks"][ KILLSTREAK_SLOT_1 ].available && self.actionSlotEnabled[ KILLSTREAK_SLOT_1 ] )
				self.killstreakIndexWeapon = KILLSTREAK_SLOT_1;
			break;
		case "streakUsed3":
			if( self.pers["killstreaks"][ KILLSTREAK_SLOT_2 ].available && self.actionSlotEnabled[ KILLSTREAK_SLOT_2 ] )
				self.killstreakIndexWeapon = KILLSTREAK_SLOT_2;
			break;
		case "streakUsed4":
			if( self.pers["killstreaks"][ KILLSTREAK_SLOT_3 ].available && self.actionSlotEnabled[ KILLSTREAK_SLOT_3 ] )
				self.killstreakIndexWeapon = KILLSTREAK_SLOT_3;
			break;
		case "streakUsed5":
			if( self.pers["killstreaks"][ KILLSTREAK_SLOT_4 ].available && self.actionSlotEnabled[ KILLSTREAK_SLOT_4 ] )
				self.killstreakIndexWeapon = KILLSTREAK_SLOT_4;
			break;
		}

		// just a sanity check to make sure we reset the killstreakIndexWeapon
		if( IsDefined( self.killstreakIndexWeapon ) && !self.pers["killstreaks"][ self.killstreakIndexWeapon ].available )
			self.killstreakIndexWeapon = undefined;

		if( IsDefined( self.killstreakIndexWeapon ) )
		{
			self disableKillstreakActionSlots();
			while( true )
			{
				self waittill( "weapon_change", newWeapon );
				if( IsDefined( self.killstreakIndexWeapon ) )
				{
					killstreakWeapon = getKillstreakWeapon( self.pers["killstreaks"][ self.killstreakIndexWeapon ].streakName );
					// if this is the killstreak weapon or none then continue and wait for the next weapon change
					//	remote uav gives you a different weapon than the killstreak weapon from the killstreaktable.csv, so we need to also check for that
					if( newWeapon == killstreakWeapon || 
						newWeapon == "none" || 
						( killstreakWeapon == "killstreak_uav_mp" && newWeapon == "killstreak_remote_uav_mp" ) ||
						( killstreakWeapon == "killstreak_uav_mp" && newWeapon == "uav_remote_mp" ) )
						continue;

					break;
				}
				
				break;
			}
			// they either used the killstreak or cancelled it
			self enableKillstreakActionSlots();
			self.killstreakIndexWeapon = undefined;
		}
	}
}

disableKillstreakActionSlots() // self == player
{
	for( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
	{
		if( !IsDefined( self.killstreakIndexWeapon ) )
			break;

		if( self.killstreakIndexWeapon == i )
			continue;

		// clear all other killstreak slots while we are using a killstreak so they can't try to use another one
		self _setActionSlot( i + 4, "" );
		self.actionSlotEnabled[ i ] = false;
	}
}

enableKillstreakActionSlots() // self == player
{
	for( i = KILLSTREAK_GIMME_SLOT; i < KILLSTREAK_ALL_PERKS_SLOT; i++ )
	{
		// turn all of the action slots back on
		if( self.pers["killstreaks"][ i ].available )
		{
			killstreakWeapon = getKillstreakWeapon( self.pers["killstreaks"][ i ].streakName );
			self _setActionSlot( i + 4, "weapon", killstreakWeapon );
		}
		else
		{
			// since this killstreak isn't available, clear the action slot so they can't pull an empty weapon out
			self _setActionSlot( i + 4, "" );
		}

		// even if they don't have a killstreak in this slot we need to switch this flag for later uses
		//	if we don't, then once they earn it they won't be able to use it because this flag is off
		self.actionSlotEnabled[ i ] = true;
	}
}


killstreakHit( attacker, weapon, vehicle )
{
	if( IsDefined( weapon ) && isPlayer( attacker ) && IsDefined( vehicle.owner ) && IsDefined( vehicle.owner.team ) )
	{
		if ( ( (level.teamBased && vehicle.owner.team != attacker.team) || !level.teamBased ) && attacker != vehicle.owner )
		{
			if( isKillstreakWeapon( weapon ) )
				return;
				
			if ( !isDefined( attacker.lastHitTime[ weapon ] ) )
				attacker.lastHitTime[ weapon ] = 0;
		
			// already hit with this weapon on this frame
			if ( attacker.lastHitTime[ weapon ] == getTime() )
				return;

			attacker.lastHitTime[ weapon ] = getTime();
			
			attacker thread maps\mp\gametypes\_gamelogic::threadedSetWeaponStatByName( weapon, 1, "hits" );
				
			totalShots = attacker maps\mp\gametypes\_persistence::statGetBuffered( "totalShots" );		
			hits = attacker maps\mp\gametypes\_persistence::statGetBuffered( "hits" ) + 1;

			if ( hits <= totalShots )
			{
				attacker maps\mp\gametypes\_persistence::statSetBuffered( "hits", hits );
				attacker maps\mp\gametypes\_persistence::statSetBuffered( "misses", int(totalShots - hits) );
				attacker maps\mp\gametypes\_persistence::statSetBuffered( "accuracy", int(hits * 10000 / totalShots) );
			}
		}
	}
}
