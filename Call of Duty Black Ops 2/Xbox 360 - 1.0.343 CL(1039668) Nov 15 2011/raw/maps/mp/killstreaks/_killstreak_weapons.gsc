#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	PreCacheShader( "hud_ks_minigun" );
	PreCacheShader( "hud_ks_m202" );

	maps\mp\killstreaks\_killstreaks::registerKillstreak("minigun_mp", "minigun_mp", "killstreak_minigun", "minigun_used", ::useCarriedKillstreakWeapon, false, true, "MINIGUN_USED" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("minigun_mp", &"KILLSTREAK_EARNED_MINIGUN", &"KILLSTREAK_MINIGUN_NOT_AVAILABLE", &"KILLSTREAK_MINIGUN_INBOUND" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("minigun_mp", "mpl_killstreak_minigun", "kls_death_used", "","kls_death_enemy", "", "kls_death_ready");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("minigun_mp", "scr_giveminigun");

/*
	maps\mp\killstreaks\_killstreaks::registerKillstreak("m202_flash_mp", "m202_flash_mp", "killstreak_m202_flash", "m202_flash_used", ::useCarriedKillstreakWeapon, false, true, "M202_FLASH_USED" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("m202_flash_mp", &"KILLSTREAK_EARNED_M202_FLASH", &"KILLSTREAK_M202_FLASH_NOT_AVAILABLE", &"KILLSTREAK_M202_FLASH_INBOUND" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("m202_flash_mp", "mpl_killstreak_tvmissile", "kls_grim_used", "","kls_grim_enemy", "", "kls_grim_ready");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("m202_flash_mp", "scr_givem202flash");
*/

		// tv guided missile 
	// gets dropped in using a care package and the killstreak is in the crate
/*
	maps\mp\killstreaks\_killstreaks::registerKillstreak("m220_tow_mp", "m220_tow_mp", "killstreak_m220_tow", "m220_tow_used", ::useCarriedKillstreakWeapon, true, true, "M220_TOW_USED" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("m220_tow_mp", &"KILLSTREAK_EARNED_M220_TOW", &"KILLSTREAK_M220_TOW_NOT_AVAILABLE", &"KILLSTREAK_M220_TOW_INBOUND");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("m220_tow_mp", "mpl_killstreak_tvmissile", "kls_tv_used", "","kls_tv_enemy", "", "kls_tv_ready");

	maps\mp\killstreaks\_killstreaks::registerKillstreak("m220_tow_drop_mp", "m220_tow_drop_mp", "killstreak_m220_tow_drop", "m220_tow_used", ::useKillstreakWeaponDrop, undefined, true );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("m220_tow_drop_mp", &"KILLSTREAK_EARNED_M220_TOW", &"KILLSTREAK_AIRSPACE_FULL", &"KILLSTREAK_M220_TOW_INBOUND");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("m220_tow_drop_mp", "mpl_killstreak_tvmissile", "kls_tv_used", "","kls_tv_enemy", "", "kls_tv_ready");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("m220_tow_mp", "scr_givem220tow");
*/

	//maps\mp\killstreaks\_killstreaks::registerKillstreak("mp40_drop_mp", "mp40_drop_mp", "killstreak_mp40_drop", "mp40_used", ::useCarriedKillstreakWeapon, false, false, "MP40_USED" );
	//maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "mp40_drop_mp", "mp40_blinged_mp" );
	//maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("mp40_drop_mp", &"KILLSTREAK_EARNED_MP40", &"KILLSTREAK_MP40_NOT_AVAILABLE", &"KILLSTREAK_MP40_INBOUND" );
	//maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("mp40_drop_mp", "mpl_killstreak_mp40", "kls_mp40_used", "","kls_mp40_enemy", "", "kls_mp40_ready");
	//maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("mp40_drop_mp", "scr_givemp40");
		
	level.killStreakIcons["killstreak_minigun"] = "hud_ks_minigun";
	level.killStreakIcons["killstreak_m202_flash_mp"] = "hud_ks_m202";
	level.killStreakIcons["killstreak_m220_tow_drop_mp"] = "hud_ks_tv_guided_marker";
	level.killStreakIcons["killstreak_m220_tow_mp"] = "hud_ks_tv_guided_missile";
	//level.killStreakIcons["killstreak_mp40_mp"] = "hud_mp40";
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );
	
		self.firedKillstreakWeapon = false;
		self.usingKillstreakHeldWeapon = undefined;
		self thread watchKillstreakWeaponUsage();
		self thread watchKillstreakWeaponDelay();
	}
}

watchKillstreakWeaponDelay()
{
	self endon( "disconnect" );
	self endon( "death" );

	while(1)
	{
		currentWeapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );

		if( !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon(newWeapon) )
		{
			wait( 0.5 );
			continue;
		}

		if( level.killstreakRoundDelay >= (maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000) && 
			maps\mp\killstreaks\_killstreaks::isDelayableKillstreak(newWeapon) && isHeldKillstreakWeapon(newWeapon) )
		{
			timeLeft = Int( level.killstreakRoundDelay - (maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000) );
			
			if( !timeLeft )
				timeLeft = 1;

			self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );

			self switchToWeapon( currentWeapon );
			wait(0.5);
		}
	}
}

useKillstreakWeaponDrop(hardpointType)
{
	if( self maps\mp\killstreaks\_supplydrop::isSupplyDropGrenadeAllowed(hardpointType) == false )
		return false;

	self thread maps\mp\killstreaks\_supplydrop::refCountDecChopperOnDisconnect();
	
	result = self maps\mp\killstreaks\_supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !IsDefined(result) || !result )
	{
		return false;
	}

	return result;
}

useCarriedKillstreakWeapon( hardpointType )
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if( !isDefined(hardpointType) )
		return false;

	currentWeapon = self GetCurrentWeapon();

	if( hardpointType == "none" )
		return false;

	level maps\mp\gametypes\_weapons::addLimitedWeapon( hardpointType, self, 3 );

	self.firedKillstreakWeapon = false;
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup(hardpointType, true);

	//Monitor weapon switching from the killstreak weapon
	self thread watchKillsteakWeaponSwitch( hardpointType );
	
	//We will monitor when to take the killstreak.
	/*currentKillstreakId = maps\mp\killstreaks\_killstreaks::getTopKillstreakUniqueId();
	self thread watchKillstreakWeaponUsage( hardpointType, currentKillstreakId );*/
	self.usingKillstreakHeldWeapon = true;
	return false;
}

watchKillsteakWeaponSwitch( killstreakWeapon )
{
	self endon( "disconnect" );
	self endon( "death" );
	//self endon( "killstreak_weapon_taken" );
	KillstreakId = maps\mp\killstreaks\_killstreaks::getTopKillstreakUniqueId();

	while(1)
	{
		currentWeapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );

		if( newWeapon == "none" )
			continue;

		if( !self checkIfSwitchableWeapon( currentWeapon, newWeapon, killstreakWeapon, KillstreakId ) )
			continue;

		self TakeWeapon( killstreakWeapon );
		self.firedKillstreakWeapon = false;
		self.usingKillstreakHeldWeapon = undefined;

		waittillframeend;
		self maps\mp\killstreaks\_killstreaks::activateNextKillstreak();
		break;

	}
}

checkIfSwitchableWeapon( currentWeapon, newWeapon, killstreakWeapon, currentKillstreakId )
{
	switchableWeapon = true;
	topKillstreak = maps\mp\killstreaks\_killstreaks::getTopKillstreak();
	killstreakId = maps\mp\killstreaks\_killstreaks::getTopKillstreakUniqueId();

	if( !isDefined(killstreakId) )
		killstreakId = -1;

	if ( self HasWeapon( killstreakWeapon ) && !self GetAmmoCount( killstreakWeapon ) )//Safty check that we're holding an empty killstreak weapon
		switchableWeapon = true;
	else if( self.firedKillstreakWeapon && newWeapon == killstreakWeapon && isHeldKillstreakWeapon( currentWeapon ) )//We have a new version of the killstreak weapon and we've already shot the equipped one
		switchableWeapon = true;
	else if( IsWeaponEquipment(newWeapon) )
		switchableWeapon = true;
	else if( isdefined( level.grenade_array[newWeapon] ) )
		switchableWeapon = false;
	else if( isHeldKillstreakWeapon( newWeapon ) && isHeldKillstreakWeapon( currentWeapon ) && currentKillstreakId != killstreakId )//new held killstreak weapon
		switchableWeapon = true;
	else if( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( newWeapon ) )//allow killstreaks to be called in
		switchableWeapon = false;
	else if( isGameplayWeapon( newWeapon ) )//check for briefcase bomb, syrette, etc.
		switchableWeapon = false;
	else if( self.firedKillstreakWeapon )
		switchableWeapon = true;
	else if( self.lastNonKillstreakWeapon == killstreakWeapon )
		switchableWeapon = false;
	else if( isDefined(topKillstreak) && topKillstreak == killstreakWeapon && currentKillstreakId == killstreakId )//putting the killstreak away
		switchableWeapon = false;


	return switchableWeapon;

}

watchKillstreakWeaponUsage()
{
		self endon( "disconnect" );
		self endon( "death" );

		while( 1 )
		{
			self waittill( "weapon_fired", killstreakWeapon );

			if( !isHeldKillstreakWeapon(killstreakWeapon) )
			{
				wait(0.1);
				continue;
			}

			if( self.firedKillstreakWeapon )
				continue;

			level thread maps\mp\_popups::DisplayTeamMessageToAll( level.killstreaks[killstreakWeapon].inboundText, self );

			self AddWeaponStat( killstreakWeapon, "used", 1 );
			self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( killstreakWeapon, self.team );
			maps\mp\killstreaks\_killstreaks::removeUsedKillstreak( killstreakWeapon );
			self.firedKillstreakWeapon = true;
			self setActionSlot( 4, "" );
			waittillframeend;
	
			maps\mp\killstreaks\_killstreaks::activateNextKillstreak( );
		}


}

isHeldKillstreakWeapon( killstreakType )
{
	switch( killstreakType )
	{
	case "minigun_mp":
	case "m202_flash_mp":
	case "m220_tow_mp":
	case "mp40_drop_mp":
		return true;
	}

	return false;
}

isGameplayWeapon( weapon )
{
	switch( weapon )
	{
	case "syrette_mp":
	case "briefcase_bomb_mp":
	case "briefcase_bomb_defuse_mp":
		return true;
	default:
		return false;
	}

	return false;
}