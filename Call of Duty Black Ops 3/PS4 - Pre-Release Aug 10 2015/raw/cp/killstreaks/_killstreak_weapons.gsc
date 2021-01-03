#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_globallogic_utils;

#using scripts\cp\_util;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_supplydrop;

#precache( "material", "hud_ks_minigun" );
#precache( "material", "hud_ks_m32" );
#precache( "string", "KILLSTREAK_EARNED_MINIGUN" );
#precache( "string", "KILLSTREAK_MINIGUN_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_MINIGUN_INBOUND" );
#precache( "eventstring", "mpl_killstreak_minigun" );
#precache( "eventstring", "mpl_killstreak_m32" );

#namespace killstreak_weapons;

function init()
{
	killstreaks::register("inventory_minigun", "inventory_minigun", "killstreak_minigun", "minigun_used",&useCarriedKillstreakWeapon, false, true, "MINIGUN_USED" );
	killstreaks::register_strings("inventory_minigun", &"KILLSTREAK_EARNED_MINIGUN", &"KILLSTREAK_MINIGUN_NOT_AVAILABLE", &"KILLSTREAK_MINIGUN_INBOUND" );
	killstreaks::register_dialog("inventory_minigun", "mpl_killstreak_minigun", "kls_death_used", "","kls_death_enemy", "", "kls_death_ready");
	killstreaks::register_dev_dvar( "inventory_minigun", "scr_giveminigun_drop" );

	killstreaks::register("minigun", "minigun", "killstreak_minigun", "minigun_used",&useCarriedKillstreakWeapon, false, true, "MINIGUN_USED" );
	killstreaks::register_strings("minigun", &"KILLSTREAK_EARNED_MINIGUN", &"KILLSTREAK_MINIGUN_NOT_AVAILABLE", &"KILLSTREAK_MINIGUN_INBOUND" );
	killstreaks::register_dialog("minigun", "mpl_killstreak_minigun", "kls_death_used", "","kls_death_enemy", "", "kls_death_ready");

	

//	killstreaks::register("inventory_m32", "inventory_m32", "killstreak_m32", "m32_used",&useCarriedKillstreakWeapon, false, true, "M32_USED" );
//	killstreaks::register_strings("inventory_m32", &"KILLSTREAK_EARNED_M32", &"KILLSTREAK_M32_NOT_AVAILABLE", &"KILLSTREAK_M32_INBOUND" );
//	killstreaks::register_dialog("inventory_m32", "mpl_killstreak_m32", "kls_mgl_used", "","kls_mgl_enemy", "", "kls_mgl_ready");
//	killstreaks::register_dev_dvar( "inventory_m32", "scr_givem32_drop" );
//	killstreaks::override_entity_camera_in_demo("inventory_m32", true);
//
//	killstreaks::register("m32", "m32", "killstreak_m32", "m32_used",&useCarriedKillstreakWeapon, false, true, "M32_USED" );
//	killstreaks::register_strings("m32", &"KILLSTREAK_EARNED_M32", &"KILLSTREAK_M32_NOT_AVAILABLE", &"KILLSTREAK_M32_INBOUND" );
//	killstreaks::register_dialog("m32", "mpl_killstreak_m32", "kls_mgl_used", "","kls_mgl_enemy", "", "kls_mgl_ready");
//	killstreaks::override_entity_camera_in_demo("m32", true);



	/*killstreaks::register( "inventory_m32_drop", "inventory_m32_drop", "killstreak_m32", "m32_used", supplydrop::useKillstreakSupplyDrop, undefined, true );
	killstreaks::register_strings( "inventory_m32_drop", &"KILLSTREAK_EARNED_M32", &"KILLSTREAK_M32_NOT_AVAILABLE" );
	killstreaks::register_dialog( "inventory_m32_drop", "mpl_killstreak_m32", "kls_weapon_used", "","kls_weapon_enemy", "", "kls_weapon_ready" );
	killstreaks::register_dev_dvar( "inventory_m32_drop", "scr_givem32_drop" );*/

	/*killstreaks::register( "m32_drop", "m32_drop", "killstreak_m32", "m32_drop_used", supplydrop::useKillstreakSupplyDrop, undefined, true );
	killstreaks::register_strings( "m32_drop", &"KILLSTREAK_EARNED_M32", &"KILLSTREAK_M32_NOT_AVAILABLE" );
	killstreaks::register_dialog( "m32_drop", "mpl_killstreak_m32", "kls_weapon_used", "","kls_weapon_enemy", "", "kls_weapon_ready" );*/
	
/*
	killstreaks::register("m202_flash", "m202_flash", "killstreak_m202_flash", "m202_flash_used",&useCarriedKillstreakWeapon, false, true, "M202_FLASH_USED" );
	killstreaks::register_strings("m202_flash", &"KILLSTREAK_EARNED_M202_FLASH", &"KILLSTREAK_M202_FLASH_NOT_AVAILABLE", &"KILLSTREAK_M202_FLASH_INBOUND" );
	killstreaks::register_dialog("m202_flash", "mpl_killstreak_tvmissile", "kls_grim_used", "","kls_grim_enemy", "", "kls_grim_ready");
	killstreaks::register_dev_dvar("m202_flash", "scr_givem202flash");
*/

		// tv guided missile 
	// gets dropped in using a care package and the killstreak is in the crate
/*
	killstreaks::register("m220_tow", "m220_tow", "killstreak_m220_tow", "m220_tow_used",&useCarriedKillstreakWeapon, true, true, "M220_TOW_USED" );
	killstreaks::register_strings("m220_tow", &"KILLSTREAK_EARNED_M220_TOW", &"KILLSTREAK_M220_TOW_NOT_AVAILABLE", &"KILLSTREAK_M220_TOW_INBOUND");
	killstreaks::register_dialog("m220_tow", "mpl_killstreak_tvmissile", "kls_tv_used", "","kls_tv_enemy", "", "kls_tv_ready");

	killstreaks::register("m220_tow_drop", "m220_tow_drop", "killstreak_m220_tow_drop", "m220_tow_used",&useKillstreakWeaponDrop, undefined, true );
	killstreaks::register_strings("m220_tow_drop", &"KILLSTREAK_EARNED_M220_TOW", &"KILLSTREAK_AIRSPACE_FULL", &"KILLSTREAK_M220_TOW_INBOUND");
	killstreaks::register_dialog("m220_tow_drop", "mpl_killstreak_tvmissile", "kls_tv_used", "","kls_tv_enemy", "", "kls_tv_ready");
	killstreaks::register_dev_dvar("m220_tow", "scr_givem220tow");
*/

	//killstreaks::register("mp40_drop", "mp40_drop", "killstreak_mp40_drop", "mp40_used",&useCarriedKillstreakWeapon, false, false, "MP40_USED" );
	//killstreaks::register_alt_weapon( "mp40_drop", "mp40_blinged" );
	//killstreaks::register_strings("mp40_drop", &"KILLSTREAK_EARNED_MP40", &"KILLSTREAK_MP40_NOT_AVAILABLE", &"KILLSTREAK_MP40_INBOUND" );
	//killstreaks::register_dialog("mp40_drop", "mpl_killstreak_mp40", "kls_mp40_used", "","kls_mp40_enemy", "", "kls_mp40_ready");
	//killstreaks::register_dev_dvar("mp40_drop", "scr_givemp40");
		
	level.killStreakIcons["killstreak_minigun"] = "hud_ks_minigun";
	level.killStreakIcons["killstreak_m32"] = "hud_ks_m32";
	level.killStreakIcons["killstreak_m202_flash"] = "hud_ks_m202";
	level.killStreakIcons["killstreak_m220_tow_drop"] = "hud_ks_tv_guided_marker";
	level.killStreakIcons["killstreak_m220_tow"] = "hud_ks_tv_guided_missile";
	//level.killStreakIcons["killstreak_mp40"] = "hud_mp40";
	
	callback::on_spawned( &on_player_spawned );
	
	SetDvar( "scr_HeldKillstreak_Penalty", 0 );
}

function on_player_spawned()
{
	self endon( "disconnect" );
	
	self.firedKillstreakWeapon = false;
	self.usingKillstreakHeldWeapon = undefined;

	if ( !util::isFirstRound() && !util::isOneRound() )
	{
		if ( level.roundStartKillstreakDelay > (globallogic_utils::getTimePassed() / 1000) )
		{
			self thread watchKillstreakWeaponDelay();
		}
	}
}

function watchKillstreakWeaponDelay()
{
	self endon( "disconnect" );
	self endon( "death" );

	while(1)
	{
		currentWeapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );

		if ( level.roundStartKillstreakDelay < (globallogic_utils::getTimePassed() / 1000) )
			return;

		if ( !killstreaks::is_killstreak_weapon(newWeapon) )
		{
			wait( 0.5 );
			continue;
		}

		killstreak = killstreaks::get_killstreak_for_weapon( newWeapon );
		if ( killstreaks::is_delayable_killstreak( killstreak ) && newWeapon.isCarriedKillstreak )
		{
			timeLeft = Int( level.roundStartKillstreakDelay - (globallogic_utils::getTimePassed() / 1000) );
			
			if( !timeLeft )
				timeLeft = 1;

			self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );

			self switchToWeapon( currentWeapon );
			wait(0.5);
		}
	}
}

function useKillstreakWeaponDrop( hardpointType )
{
	if( self supplydrop::isSupplyDropGrenadeAllowed(hardpointType) == false )
		return false;
	
	result = self supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !isdefined(result) || !result )
	{
		return false;
	}

	return result;
}

function useCarriedKillstreakWeapon( hardpointType )
{
	if( !isdefined(hardpointType) )
		return false;

	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		self switchToWeapon( self.lastDroppableWeapon );
		return false;
	}

	currentWeapon = self GetCurrentWeapon();
	killstreakWeapon = killstreaks::get_killstreak_weapon( hardpointType );

	if ( killstreakWeapon == level.weaponNone )
		return false;

	level weapons::add_limited_weapon( killstreakWeapon, self, 3 );
	
	if ( issubstr( killstreakWeapon.name, "inventory" ) )
		isFromInventory = true;
	else
		isFromInventory = false;

	currentAmmo = self getammocount( killstreakWeapon );
	if ( ( ( hardpointType == "minigun" || hardpointType == "inventory_minigun" ) && !( isdefined( self.minigunStart ) && self.minigunStart ) ) ||
	    ( ( hardpointType == "m32" || hardpointType == "inventory_m32" ) && !( isdefined( self.m32Start ) && self.m32Start ) ) )
	{
		if ( hardpointType == "minigun" || hardpointType == "inventory_minigun" ) 
		{
			self.minigunStart = true;
		}
		else
		{
			self.m32Start = true;
		}
		self killstreaks::play_killstreak_start_dialog( hardpointType, self.team, true );
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
		level thread popups::DisplayTeamMessageToAll( level.killstreaks[hardpointType].inboundText, self );

		self.pers["held_killstreak_clip_count"][hardpointType] = ( killstreakWeapon.clipSize > currentAmmo ? currentAmmo : killstreakWeapon.clipSize );
		
		if ( isFromInventory == false ) 
		{
			if( self.pers["killstreak_quantity"][hardpointType] > 0 )
				ammoPool = killstreakWeapon.maxAmmo;
			else
				ammoPool = self.pers["held_killstreak_ammo_count"][hardpointType];

			self setWeaponAmmoClip( killstreakWeapon, self.pers["held_killstreak_clip_count"][hardpointType] );
			self setWeaponAmmoStock( killstreakWeapon, ammoPool - self.pers["held_killstreak_clip_count"][hardpointType] );
		}
	}
	if ( hardpointType == "minigun" || hardpointType == "inventory_minigun" )
	{
		if ( !( isdefined( self.minigunActive ) && self.minigunActive ) )
		{
			killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team, false, false );

			if( hardpointType == "inventory_minigun" )
				killstreak_id = self.pers["killstreak_unique_id"][self.pers["killstreak_unique_id"].size-1];

			self.minigunId = killstreak_id;
			self.minigunActive = true;
		}
		else
		{
			killstreak_id = self.minigunId;
		}
	}
	else
	{
		if ( !( isdefined( self.m32Active ) && self.m32Active ) )
		{
			killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team, false, false );

			if( hardpointType == "inventory_m32" )
				killstreak_id = self.pers["killstreak_unique_id"][self.pers["killstreak_unique_id"].size-1];

			self.m32Id = killstreak_id;
			self.m32Active = true;
		}
		else
		{
			killstreak_id = self.m32Id;
		}
	}
	//right now we dont have handling for the killstreak not working
	assert ( killstreak_id != -1 );
	self.firedKillstreakWeapon = false;
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup( killstreakWeapon, true );

	if( isFromInventory )
	{
		self setWeaponAmmoClip( killstreakWeapon, self.pers["held_killstreak_clip_count"][hardpointType] );
		self setWeaponAmmoStock( killstreakWeapon, self.pers["killstreak_ammo_count"][self.pers["killstreak_ammo_count"].size - 1] - self.pers["held_killstreak_clip_count"][hardpointType] );
	}

	notifyString = "killstreakWeapon_" + killstreakWeapon;
	self notify( notifyString );
	//Monitor weapon switching from the killstreak weapon
	self thread watchKillstreakWeaponSwitch( killstreakWeapon, killstreak_id, isFromInventory );
	self thread watchKillstreakWeaponDeath( killstreakWeapon, killstreak_id, isFromInventory );
	self thread watchKillstreakRoundChange( isFromInventory, killstreak_id );
	self thread WatchPlayerDeath( killstreakWeapon );

	if( isFromInventory )
		self thread watchKillstreakRemoval( hardpointType, killstreak_id );
	
	self.usingKillstreakHeldWeapon = true;
	return false;
}

function useKillstreakWeaponFromCrate( hardpointType )
{
	if( !isdefined(hardpointType) )
		return false;

	killstreakWeapon = killstreaks::get_killstreak_weapon( hardpointType );
	if ( killstreakWeapon == level.weaponNone )
		return false;

	self.firedKillstreakWeapon = false;

	self setBlockWeaponPickup( killstreakWeapon, true );
	
	killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team, false, false );
	//right now we dont have handling for the killstreak not working
	assert ( killstreak_id != -1 );

	if( issubstr( killstreakWeapon.name, "inventory" ) )
		isFromInventory = true;
	else
		isFromInventory = false;

	self thread watchKillstreakWeaponSwitch( killstreakWeapon, killstreak_id, isFromInventory );
	self thread watchKillstreakWeaponDeath( killstreakWeapon, killstreak_id, isFromInventory );

	if( isFromInventory )
		self thread watchKillstreakRemoval( hardpointType, killstreak_id );

	self.usingKillstreakHeldWeapon = true;

	return true;
}

function watchKillstreakWeaponSwitch( killstreakWeapon, killstreak_id, isFromInventory )
{
	self endon( "disconnect" );
	self endon( "death" );
	//self endon( "killstreak_weapon_taken" );

	while(1)
	{
		currentWeapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );

		if( newWeapon == "none" )
			continue;
		
		currentAmmo = self getammocount( killstreakWeapon );
		currentAmmoInClip = self GetWeaponAmmoClip( killstreakWeapon );
		
		//If an inventory weapon, make sure the ammo is stored at the right index in the stack
		if( isFromInventory && currentAmmo > 0 )
		{
			killstreakIndex = self killstreaks::get_killstreak_index_by_id( killstreak_id );

			if( isdefined( killstreakIndex ) )
			{
				self.pers["killstreak_ammo_count"][killstreakIndex] = currentAmmo;
				self.pers["held_killstreak_clip_count"][killstreakWeapon] = currentAmmoInClip;
			}
		}

		if( killstreaks::is_killstreak_weapon( newWeapon ) && !newWeapon.isCarriedKillstreak )
			continue;

		if( newWeapon.isGameplayWeapon )
			continue;
		
		if( newWeapon == self.lastNonKillstreakWeapon && newWeapon.isCarriedKillstreak )
			continue;

		KillstreakId = killstreaks::get_top_killstreak_unique_id();

		self.pers["held_killstreak_ammo_count"][killstreakWeapon] = currentAmmo;
		self.pers["held_killstreak_clip_count"][killstreakWeapon] = currentAmmoInClip;
	
		if ( killstreak_id != -1 )
		{
			self notify( "killstreak_weapon_switch" );
		}
		self.firedKillstreakWeapon = false;
		self.usingKillstreakHeldWeapon = undefined;
		
		waittillframeend;
		
		if ( currentAmmo == 0 || self.pers["killstreak_quantity"][killstreakWeapon] > 0 || ( isFromInventory && isdefined(KillstreakId) && KillstreakId != killstreak_id ) )
		{			
			killstreakrules::killstreakStop( killstreaks::get_killstreak_for_weapon( killstreakWeapon ), self.team, killstreak_id );
			if ( killstreakWeapon == "minigun" || killstreakWeapon == "inventory_minigun" ) 
			{
				self.minigunStart = false;
				self.minigunActive = false;
			}
			else
			{
				self.m32Start = false;
				self.m32Active = false;
			}	
			
			//Check if we have earned another one, if so refill ammo.
			if( self.pers["killstreak_quantity"][killstreakWeapon] > 0 )
			{
				self.pers["held_killstreak_ammo_count"][killstreakWeapon] = killstreakWeapon.maxAmmo;
				self loadout::setWeaponAmmoOverall( killstreakWeapon, self.pers["held_killstreak_ammo_count"][killstreakWeapon] );
				self.pers["killstreak_quantity"][killstreakWeapon]--;
			}
		}

		if( isFromInventory && currentAmmo == 0 )
		{	
			self TakeWeapon( killstreakWeapon );
			self killstreaks::remove_used_killstreak( killstreaks::get_killstreak_for_weapon( killstreakWeapon ), killstreak_id );
			self killstreaks::activate_next();
		}
		break;

	}
}

function watchKillstreakWeaponDeath( killstreakWeapon, killstreak_id, isFromInventory )
{
	self endon( "disconnect" );
	self endon( "killstreak_weapon_switch" );
	
	if( killstreak_id == -1 )
	{
		return;	
	}
	oldTeam = self.team;
	
	self waittill( "death" );

	penalty = GetDvarFloat( "scr_HeldKillstreak_Penalty", 0.5 );
	maxAmmo = killstreakWeapon.maxAmmo;
	currentAmmo = self getammocount( killstreakWeapon );
	currentAmmoInClip = self GetWeaponAmmoClip( killstreakWeapon );
	
	if ( self.pers["killstreak_quantity"].size == 0 ) // player changed teams
	{
		currentAmmo = 0;
		currentAmmoInClip = 0;
	}
	
	maxClipSize = killstreakWeapon.clipSize;
	newAmmo = int( currentAmmo - (maxAmmo * penalty) );
	KillstreakId = killstreaks::get_top_killstreak_unique_id();


	//Check if we should penalize the player.
	if( self.lastNonKillstreakWeapon == killstreakWeapon )
	{
		if( newAmmo < 0 )
		{
			self.pers["held_killstreak_ammo_count"][killstreakWeapon] = 0;
			self.pers["held_killstreak_clip_count"][killstreakWeapon] = 0;
		}
		else
		{
			self.pers["held_killstreak_ammo_count"][killstreakWeapon] = newAmmo;
			self.pers["held_killstreak_clip_count"][killstreakWeapon] = ( maxClipSize <= newAmmo ? maxClipSize : newAmmo );
		}
	}
	
	self.usingKillstreakHeldWeapon = false;
	killstreakType = killstreaks::get_killstreak_for_weapon( killstreakWeapon );
	if ( newAmmo <= 0 || self.pers["killstreak_quantity"][killstreakWeapon] > 0 || ( isFromInventory && isdefined(KillstreakId) && KillstreakId != killstreak_id ) )
	{
		killstreakrules::killstreakStop( killstreakType, oldTeam, killstreak_id );
		if ( killstreakType == "minigun" || killstreakType == "inventory_minigun" ) 
		{
			self.minigunStart = false;
			self.minigunActive = false;
		}
		else
		{
			self.m32Start = false;
			self.m32Active = false;
		}
		//Check if we have earned another one, if so refill ammo.
		if( isdefined( self.pers["killstreak_quantity"][killstreakWeapon] ) && self.pers["killstreak_quantity"][killstreakWeapon] > 0 )
		{
			self.pers["held_killstreak_ammo_count"][killstreakWeapon] = maxAmmo;
			self.pers["held_killstreak_clip_count"][killstreakWeapon] = maxClipSize;
			self setWeaponAmmoClip( killstreakWeapon, self.pers["held_killstreak_clip_count"][killstreakWeapon] );
			self setWeaponAmmoStock( killstreakWeapon, self.pers["held_killstreak_ammo_count"][killstreakWeapon] - self.pers["held_killstreak_clip_count"][killstreakWeapon] );
			self.pers["killstreak_quantity"][killstreakWeapon]--;
		}
	}
	if( isFromInventory && newAmmo <= 0 )
	{	
		self TakeWeapon( killstreakWeapon );
		self killstreaks::remove_used_killstreak( killstreakType, killstreak_id );
		self killstreaks::activate_next();
	}
	else if( isFromInventory )//If an inventory weapon, make sure the ammo is stored at the right index in the stack
	{
		killstreakIndex = self killstreaks::get_killstreak_index_by_id( killstreak_id );

		if( isdefined( killstreakIndex ) )
		{
			self.pers["killstreak_ammo_count"][killstreakIndex] = self.pers["held_killstreak_ammo_count"][killstreakWeapon];
		}
	}
}

function WatchPlayerDeath( killstreakWeapon )
{
	self endon( "disconnect" );
	
	endonWeaponString = "killstreakWeapon_" + killstreakWeapon;
	self endon( endonWeaponString );

	self waittill( "death" );

	currentAmmo = self getammocount( killstreakWeapon );

	self.pers["held_killstreak_clip_count"][killstreakWeapon] = ( killstreakWeapon.clipSize <= currentAmmo ? killstreakWeapon.clipSize : currentAmmo );
}

function watchKillstreakRemoval( killstreakType, killstreak_id )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "killstreak_weapon_switch" );

	self waittill( "oldest_killstreak_removed", removedKillstreakType, removed_id );

	if ( killstreakType == removedKillstreakType && killstreak_id == removed_id )
	{
		removedKillstreakWeapon = killstreaks::get_killstreak_weapon( removedKillstreakType );
		if ( removedKillstreakWeapon.name == "inventory_minigun" ) 
		{
			self.minigunStart = false;
			self.minigunActive = false;
		}
		else
		{
			self.m32Start = false;
			self.m32Active = false;
		}
	}
}

function watchKillstreakRoundChange( isFromInventory, killstreak_id )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "killstreak_weapon_switch" );

	self waittill( "round_ended" );

	currentWeapon = self getCurrentWeapon();

	if( !currentWeapon.isCarriedKillstreak )
		return;

	currentAmmo = self getammocount( currentWeapon );
	maxClipSize = currentWeapon.clipSize;
		
	//If an inventory weapon, make sure the ammo is stored at the right index in the stack
	if( isFromInventory && currentAmmo > 0 )
	{
		killstreakIndex = self killstreaks::get_killstreak_index_by_id( killstreak_id );

		if( isDefined( killstreakIndex ) )
		{
			self.pers["killstreak_ammo_count"][killstreakIndex] = currentAmmo;
			self.pers["held_killstreak_clip_count"][currentWeapon] = ( maxClipSize <= currentAmmo ? maxClipSize : currentAmmo );
		}
	}
	else
	{
		self.pers["held_killstreak_ammo_count"][currentWeapon] = currentAmmo;
		self.pers["held_killstreak_clip_count"][currentWeapon] = ( maxClipSize <= currentAmmo ? maxClipSize : currentAmmo );
	}
}

function checkIfSwitchableWeapon( currentWeapon, newWeapon, killstreakWeapon, currentKillstreakId )
{
	switchableWeapon = true;
	topKillstreak = killstreaks::get_top_killstreak();
	killstreakId = killstreaks::get_top_killstreak_unique_id();

	if( !isdefined(killstreakId) )
		killstreakId = -1;

	if ( self HasWeapon( killstreakWeapon ) && !self GetAmmoCount( killstreakWeapon ) )//Safety check that we're holding an empty killstreak weapon
		switchableWeapon = true;
	else if( self.firedKillstreakWeapon && newWeapon == killstreakWeapon && currentWeapon.isCarriedKillstreak )//We have a new version of the killstreak weapon and we've already shot the equipped one
		switchableWeapon = true;
	else if( newWeapon.isEquipment )
		switchableWeapon = true;
	else if( isdefined( level.grenade_array[newWeapon] ) )
		switchableWeapon = false;
	else if( newWeapon.isCarriedKillstreak && currentWeapon.isCarriedKillstreak && (!isdefined(currentKillstreakID) || currentKillstreakId != killstreakId) )//new held killstreak weapon
		switchableWeapon = true;
	else if( killstreaks::is_killstreak_weapon( newWeapon ) )//allow killstreaks to be called in
		switchableWeapon = false;
	else if( newWeapon.isGameplayWeapon )//check for briefcase bomb, syrette, etc.
		switchableWeapon = false;
	else if( self.firedKillstreakWeapon )
		switchableWeapon = true;
	else if( self.lastNonKillstreakWeapon == killstreakWeapon )
		switchableWeapon = false;
	else if( isdefined(topKillstreak) && topKillstreak == killstreakWeapon && currentKillstreakId == killstreakId )//putting the killstreak away
		switchableWeapon = false;


	return switchableWeapon;

}


