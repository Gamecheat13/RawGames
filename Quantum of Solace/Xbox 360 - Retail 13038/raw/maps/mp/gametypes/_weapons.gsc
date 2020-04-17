#include maps\mp\_utility;

init()
{
	level.weaponIDs = [];
/*
	// pistol
	level.weaponIDs[0] = "p99_mp";
	level.weaponIDs[1] = "p99_silenced_mp"; 
	level.weaponIDs[2] = "";
	level.weaponIDs[3] = "";
	level.weaponIDs[4] = "";
	level.weaponIDs[5] = "";
	level.weaponIDs[6] = "";
	level.weaponIDs[7] = "";
	level.weaponIDs[8] = "";
	level.weaponIDs[9] = "";

	// smg
	level.weaponIDs[10] = "mp5_mp";
	level.weaponIDs[11] = "mac11_mp";
	level.weaponIDs[12] = "mac11_silencer_mp";
	level.weaponIDs[13] = "";
	level.weaponIDs[14] = "";
	level.weaponIDs[15] = "";
	level.weaponIDs[16] = "";
	level.weaponIDs[17] = "";
	level.weaponIDs[18] = "";
	level.weaponIDs[19] = "";

	// assault rifle
	level.weaponIDs[20] = "ak74u_mp";
	level.weaponIDs[21] = "scar_mp";
	level.weaponIDs[22] = "";
	level.weaponIDs[23] = "";
	level.weaponIDs[24] = "";
	level.weaponIDs[25] = "";
	level.weaponIDs[26] = "";
	level.weaponIDs[27] = "";
	level.weaponIDs[28] = "";
	level.weaponIDs[29] = "";
	level.weaponIDs[30] = "";
	level.weaponIDs[31] = "";
	level.weaponIDs[32] = "";
	level.weaponIDs[33] = "";
	level.weaponIDs[34] = "";
	level.weaponIDs[35] = "";
	level.weaponIDs[36] = "";
	level.weaponIDs[37] = "";
	level.weaponIDs[38] = "";
	level.weaponIDs[39] = "";
	level.weaponIDs[40] = "";
	level.weaponIDs[41] = "";
	level.weaponIDs[42] = "";
	level.weaponIDs[43] = "";
	level.weaponIDs[44] = "";
	level.weaponIDs[45] = "";
	level.weaponIDs[46] = "";
	level.weaponIDs[47] = "";
	level.weaponIDs[48] = "";
	level.weaponIDs[49] = "";

	// grenade/rocket launchers
	level.weaponIDs[50] = "";
	level.weaponIDs[51] = "";
	level.weaponIDs[52] = "";
	level.weaponIDs[53] = "";
	level.weaponIDs[54] = "";
	level.weaponIDs[55] = "";
	level.weaponIDs[56] = "";
	level.weaponIDs[57] = "";
	level.weaponIDs[58] = "";
	level.weaponIDs[59] = "";

	// sniper rifle
	level.weaponIDs[60] = "";
	level.weaponIDs[61] = "";
	level.weaponIDs[62] = "";
	level.weaponIDs[63] = "";
	level.weaponIDs[64] = "";
	level.weaponIDs[65] = "";
	level.weaponIDs[66] = "";
	level.weaponIDs[67] = "";
	level.weaponIDs[68] = "";
	level.weaponIDs[69] = "";

	// shotguns
	level.weaponIDs[70] = "";
	level.weaponIDs[71] = "";
	level.weaponIDs[72] = "";
	level.weaponIDs[73] = "";
	level.weaponIDs[74] = "";
	level.weaponIDs[75] = "";
	level.weaponIDs[76] = "";
	level.weaponIDs[77] = "";
	level.weaponIDs[78] = "";
	level.weaponIDs[79] = "";

	// lmgs
	level.weaponIDs[80] = "";
	level.weaponIDs[81] = "";
	level.weaponIDs[82] = "";
	level.weaponIDs[83] = "";
	level.weaponIDs[84] = "";
	level.weaponIDs[85] = "";
	level.weaponIDs[86] = "";
	level.weaponIDs[87] = "";
	level.weaponIDs[88] = "";
	level.weaponIDs[89] = "";

	// specials	
	level.weaponIDs[90] = "c4_mp";
	level.weaponIDs[91] = "claymore_mp";
	level.weaponIDs[92] = "proxmine_mp";
	level.weaponIDs[93] = "scrambler_mp";
	level.weaponIDs[94] = "night_vision_mp";
	level.weaponIDs[95] = "defibrillator_mp";
	level.weaponIDs[96] = "motion_sensor_mp";
	level.weaponIDs[97] = "";
	level.weaponIDs[98] = "";
	level.weaponIDs[99] = "";

	// grenades
	level.weaponIDs[100] = "frag_grenade_mp";
	level.weaponIDs[101] = "flash_grenade_mp";
	level.weaponIDs[102] = "smoke_grenade_mp";
	level.weaponIDs[103] = "concussion_grenade_mp";
	level.weaponIDs[104] = "tear_grenade_mp";
	level.weaponIDs[105] = "";
	level.weaponIDs[106] = "";
	level.weaponIDs[107] = "";
	level.weaponIDs[108] = "";
	level.weaponIDs[109] = "";

	level.weaponNames = [];
	
	for ( index = 0; index < level.weaponIDs.size; index++ )
	{
		if ( !level.weaponIDs[index].size )
			continue;
			
		level.weaponNames[level.weaponIDs[index]] = index;
		
	}
*/
	PrecacheWeapons();

	precacheShellShock( "default" );
	precacheShellShock( "concussion_grenade_mp" );
//	thread maps\mp\_pipebomb::main();
//	thread maps\mp\_ied::main();
	thread maps\mp\_claymores::main();
	thread maps\mp\_flashgrenades::main();
	thread maps\mp\_teargrenades::main();
	thread maps\mp\_entityheadicons::init();
	thread maps\mp\_proxmines::main();

	level thread onPlayerConnect();

	level.c4explodethisframe = false;
}

PrecacheWeapons()
{
	level.weaponList = [];
	level.weaponList[level.weaponList.size] = "flash_grenade_mp";             
	level.weaponList[level.weaponList.size] = "tear_grenade_mp";              
	level.weaponList[level.weaponList.size] = "frag_grenade_mp";               
	level.weaponList[level.weaponList.size] = "concussion_grenade_mp";        
	level.weaponList[level.weaponList.size] = "smoke_grenade_mp";    
	level.weaponList[level.weaponList.size] = "proxmine_mp";

	level.weaponList[level.weaponList.size] = "mp5_mp";
	level.weaponList[level.weaponList.size] = "mp5_mp_acog";
	level.weaponList[level.weaponList.size] = "mp5_mp_silencer";
	level.weaponList[level.weaponList.size] = "mp5_mp_silencer_acog";

	level.weaponList[level.weaponList.size] = "mac11_mp";
	level.weaponList[level.weaponList.size] = "mac11_mp_silencer";

	level.weaponList[level.weaponList.size] = "scar_mp";
	level.weaponList[level.weaponList.size] = "scar_mp_acog";
	level.weaponList[level.weaponList.size] = "scar_mp_red_dot";
	level.weaponList[level.weaponList.size] = "scar_mp_silencer";
	level.weaponList[level.weaponList.size] = "scar_mp_silencer_acog";
	level.weaponList[level.weaponList.size] = "scar_mp_silencer_red_dot";
	level.weaponList[level.weaponList.size] = "scar_mp_red_dot";
	level.weaponList[level.weaponList.size] = "scar_mp_acog";
	level.weaponList[level.weaponList.size] = "scar_mp_scope";
	level.weaponList[level.weaponList.size] = "scar_mp_silencer_scope";

	level.weaponList[level.weaponList.size] = "aksu_mp";
	level.weaponList[level.weaponList.size] = "aksu_mp_silencer";
	level.weaponList[level.weaponList.size] = "aksu_mp_silencer_acog";
	level.weaponList[level.weaponList.size] = "aksu_mp_silencer_red_dot";
	level.weaponList[level.weaponList.size] = "aksu_mp_acog";
	level.weaponList[level.weaponList.size] = "aksu_mp_red_dot";

	level.weaponList[level.weaponList.size] = "calico_mp";
	level.weaponList[level.weaponList.size] = "calico_mp_silencer";
	level.weaponList[level.weaponList.size] = "calico_mp_silencer_red_dot";
	level.weaponList[level.weaponList.size] = "calico_mp_red_dot";

	level.weaponList[level.weaponList.size] = "m60e3_mp";
	level.weaponList[level.weaponList.size] = "m60e3_mp_silencer";
	level.weaponList[level.weaponList.size] = "m60e3_mp_red_dot";
	level.weaponList[level.weaponList.size] = "m60e3_mp_silencer_red_dot";

	level.weaponList[level.weaponList.size] = "svd_dragunov_mp";
	level.weaponList[level.weaponList.size] = "svd_dragunov_mp_silencer";

	level.weaponList[level.weaponList.size] = "m4_mp";
	level.weaponList[level.weaponList.size] = "m4_mp_silencer";
	level.weaponList[level.weaponList.size] = "m4_mp_silencer_red_dot";
	level.weaponList[level.weaponList.size] = "m4_mp_silencer_scope";
	level.weaponList[level.weaponList.size] = "m4_mp_red_dot";
	level.weaponList[level.weaponList.size] = "m4_mp_scope";
	level.weaponList[level.weaponList.size] = "m4_foregrip_mp";

	level.weaponList[level.weaponList.size] = "saf45_mp";
	level.weaponList[level.weaponList.size] = "saf45_mp_silencer";

	level.weaponList[level.weaponList.size] = "m14_mp";
	level.weaponList[level.weaponList.size] = "m14_mp_silencer";
	level.weaponList[level.weaponList.size] = "m14_mp_silencer_acog";
	level.weaponList[level.weaponList.size] = "m14_mp_silencer_red_dot";
	level.weaponList[level.weaponList.size] = "m14_mp_acog";
	level.weaponList[level.weaponList.size] = "m14_mp_red_dot";
	level.weaponList[level.weaponList.size] = "m14_mp_scope";
	level.weaponList[level.weaponList.size] = "m14_mp_silencer_scope";

	level.weaponList[level.weaponList.size] = "aug_mp";
	level.weaponList[level.weaponList.size] = "aug_mp_silencer";

	level.weaponList[level.weaponList.size] = "wa2000_mp";
	level.weaponList[level.weaponList.size] = "wa2000_mp_silencer";

	level.weaponList[level.weaponList.size] = "vkp08_mp";
	level.weaponList[level.weaponList.size] = "vkp08_mp_acog";
	level.weaponList[level.weaponList.size] = "vkp08_mp_scope";
	level.weaponList[level.weaponList.size] = "vkp08_mp_silencer";
	level.weaponList[level.weaponList.size] = "vkp08_mp_silencer_scope";
	level.weaponList[level.weaponList.size] = "vkp08_mp_silencer_acog";

	level.weaponList[level.weaponList.size] = "p99_mp";
	level.weaponList[level.weaponList.size] = "p99_mp_silencer";
	level.weaponList[level.weaponList.size] = "colt1911_mp";
	level.weaponList[level.weaponList.size] = "colt1911_mp_silencer";
	level.weaponList[level.weaponList.size] = "glock_mp";
	level.weaponList[level.weaponList.size] = "glock_mp_silencer";
	level.weaponList[level.weaponList.size] = "sw500_mp";
	level.weaponList[level.weaponList.size] = "sw500_mp_acog";
	level.weaponList[level.weaponList.size] = "glock_18_mp";
	level.weaponList[level.weaponList.size] = "glock_18_mp_silencer";
	level.weaponList[level.weaponList.size] = "magnum_mp";
	level.weaponList[level.weaponList.size] = "golden_gun_mp";
	level.weaponList[level.weaponList.size] = "golden_gun_mp_exp";
	level.weaponList[level.weaponList.size] = "m32_mp";

	level.weaponList[level.weaponList.size] = "nailgun_mp";

	level.weaponList[level.weaponList.size] = "s1300_pump_mp";
	level.weaponList[level.weaponList.size] = "s1300_pump_mp_red_dot";
	level.weaponList[level.weaponList.size] = "s1300_auto_mp";
	level.weaponList[level.weaponList.size] = "s1300_auto_mp_silencer";

	level.weaponList[level.weaponList.size] = "phone_mp";
	level.weaponList[level.weaponList.size] = "phone_interact_mp";
	level.weaponList[level.weaponList.size] = "phone_intro_mp";
	level.weaponList[level.weaponList.size] = "bomb_mp";

	// precache the golden guns

	level.weaponList[level.weaponList.size] = "gold_p99_mp";
	level.weaponList[level.weaponList.size] = "gold_p99_mp_silencer";

	level.weaponList[level.weaponList.size] = "gold_mp5_mp";
	level.weaponList[level.weaponList.size] = "gold_mp5_mp_acog";
	level.weaponList[level.weaponList.size] = "gold_mp5_mp_silencer";
	level.weaponList[level.weaponList.size] = "gold_mp5_mp_silencer_acog";

	level.weaponList[level.weaponList.size] = "gold_mac11_mp_silencer";

	level.weaponList[level.weaponList.size] = "gold_aksu_mp_silencer";
	level.weaponList[level.weaponList.size] = "gold_aksu_mp_silencer_acog";
	level.weaponList[level.weaponList.size] = "gold_aksu_mp_silencer_red_dot";
	level.weaponList[level.weaponList.size] = "gold_aksu_mp_acog";
	level.weaponList[level.weaponList.size] = "gold_aksu_mp_red_dot";
	level.weaponList[level.weaponList.size] = "gold_aksu_foregrip_mp";

	level.weaponList[level.weaponList.size] = "gold_calico_mp_silencer";
	level.weaponList[level.weaponList.size] = "gold_calico_mp_silencer_red_dot";
	level.weaponList[level.weaponList.size] = "gold_calico_mp_red_dot";

	level.weaponList[level.weaponList.size] = "gold_m60e3_mp";
	level.weaponList[level.weaponList.size] = "gold_m60e3_mp_silencer";
	level.weaponList[level.weaponList.size] = "gold_m60e3_mp_red_dot";
	level.weaponList[level.weaponList.size] = "gold_m60e3_mp_silencer_red_dot";

	level.weaponList[level.weaponList.size] = "gold_magnum_mp";

	level.weaponList[level.weaponList.size] = "gold_wa2000_mp";
	level.weaponList[level.weaponList.size] = "gold_wa2000_mp_silencer";

	level.weaponList[level.weaponList.size] = "gold_colt1911_mp_silencer";
	level.weaponList[level.weaponList.size] = "gold_colt1911_mp_silencer";

	level.weaponList[level.weaponList.size] = "gold_glock_18_mp";
	level.weaponList[level.weaponList.size] = "gold_glock_18_mp_silencer";

	level.weaponList[level.weaponList.size] = "gold_s1300_pump_mp";
	level.weaponList[level.weaponList.size] = "gold_s1300_pump_mp_red_dot";

	level.weaponList[level.weaponList.size] = "gold_m32_mp";
			
	for ( index = 0; index < level.weaponList.size; index++ )
		precacheItem( level.weaponList[index] );

	// make sure we don't have any weapons left out
	PrecacheAllBuyableItems();

}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedweapons = false;
		player.hits = 0;

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		self.hasDoneCombat = false;
		self thread watchWeaponUsage();
		self thread watchGrenadeUsage();
		//self thread updateStowedWeapon();
	}
}

dropWeapon()
{
	weapon = self GetCurrentWeapon();

	if ( weapon == "none" )
		return;

	ammoSize = self GetAmmoCount( weapon );

	if( !ammoSize )
		return;
		
	return ( self dropItem( weapon ) );
}

dropOffhand()
{
	grenadeTypes = [];
	grenadeTypes[grenadeTypes.size] = "frag_grenade_mp";
	grenadeTypes[grenadeTypes.size] = "smoke_grenade_mp";
	grenadeTypes[grenadeTypes.size] = "flash_grenade_mp";
	grenadeTypes[grenadeTypes.size] = "concussion_grenade_mp";
	grenadeTypes[grenadeTypes.size] = "tear_grenade_mp";

	for ( index = 0; index < grenadeTypes.size; index++ )
	{
		if ( !self hasWeapon( grenadeTypes[index] ) )
			continue;
			
		count = self getAmmoCount( grenadeTypes[index] );
		
		if ( !count )
			continue;
		
		// We are not dropping these right now.  Maybe later.	
		//self dropItem( grenadeTypes[index] );
	}
}

getWeaponBasedGrenadeCount(weapon)
{
	return 2;
}

getWeaponBasedSmokeGrenadeCount(weapon)
{
	return 1;
}

getFragGrenadeCount()
{
	/*if(self.pers["team"] == "allies")
		grenadetype = "frag_grenade_" + game["allies"] + "_mp";
	else
	{
		assert(self.pers["team"] == "axis");
		grenadetype = "frag_grenade_" + game["axis"] + "_mp";
	}*/
	grenadetype = "frag_grenade_mp";

	count = self getammocount(grenadetype);
	return count;
}

getSmokeGrenadeCount()
{
	/*if(self.pers["team"] == "allies")
		grenadetype = "smoke_grenade_" + game["allies"] + "_mp";
	else
	{
		assert(self.pers["team"] == "axis");
		grenadetype = "smoke_grenade_" + game["axis"] + "_mp";
	}*/
	grenadetype = "smoke_grenade_mp";

	count = self getammocount(grenadetype);
	return count;
}

isPistol(weapon)
{
	switch(weapon)
	{
	case "beretta_mp":
		return true;
	default:
		return false;
	}
}

watchWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	self.firingWeapon = false;
	
	for ( ;; )
	{
		self waittill ( "begin_firing" );
		self.hasDoneCombat = true;
		self.firingWeapon = true;
		
		curWeapon = self getCurrentWeapon();
		
		switch ( weaponClass( curWeapon ) )
		{
			case "rifle":
			case "pistol":
			case "mg":
			case "smg":
			case "spread":
				self thread watchCurrentFiring( curWeapon );
				break;
			default:
				break;
		}
		self waittill ( "end_firing" );
		self.firingWeapon = false;
	}
}

watchCurrentFiring( curWeapon )
{
	self endon("disconnect");
	
	startAmmo = self getWeaponAmmoClip( curWeapon );
	wasInLastStand = isDefined( self.lastStand );
	
	self waittill ( "end_firing" );
	
	if ( !self hasWeapon( curWeapon ) )
		return;
	
	// ignore the case where a player is firing as they enter last stand.
	// it makes it too hard to calculate shotsFired properly.
	if ( isDefined( self.lastStand ) && !wasInLastStand )
		return;
	
	shotsFired = startAmmo - (self getWeaponAmmoClip( curWeapon )) + 1;

	if ( isDefined( self.lastStandParams ) && self.lastStandParams.lastStandStartTime == getTime() )
	{
		self.hits = 0;
		return;
	}

	assertEx( shotsFired >= 0, shotsFired + " startAmmo: " + startAmmo + " clipAmmo: " + self getWeaponAmmoclip( curWeapon ) + " w/ " + curWeapon  );	
	if ( shotsFired <= 0 )
		return;
	
	statTotal = self maps\mp\gametypes\_persistence_util::statGet( "stats", "total_shots" ) + shotsFired;		
	statHits  = self maps\mp\gametypes\_persistence_util::statGet( "stats", "hits" ) + self.hits;
	statMisses = self maps\mp\gametypes\_persistence_util::statGet( "stats", "misses" ) + shotsFired - self.hits;
	
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "total_shots", statTotal );
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "hits", statHits );
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "misses", statMisses );
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "accuracy", int(statHits * 10000 / statTotal) );
/*
	printLn( "total:    " + statTotal );
	printLn( "hits:     " + statHits );
	printLn( "misses:   " + statMisses );
	printLn( "accuracy: " + int(statHits * 10000 / statTotal) );
*/
	self.hits = 0;
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
}

// returns true if damage should be done to the item given its owner and the attacker
friendlyFireCheck(owner, attacker)
{
	if ( !isdefined(owner) ) // owner has disconnected? allow it
		return true;
	
	if ( !level.teamBased ) // not a team based mode? allow it
		return true;
	
	if ( level.friendlyfire != 0 ) // friendly fire is on? allow it
		return true;
	
	if ( attacker == owner ) // owner may attack his own items
		return true;
	
	if (!isdefined(attacker.pers["team"])) // attacker not on a team? allow it
		return true;
	
	if ( attacker.pers["team"] != owner.pers["team"] ) // attacker not on the same team as the owner? allow it
		return true;
	
	return false; // disallow it
}

watchGrenadeUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.throwingGrenade = false;
	
	// delete c4 from previous spawn
	if ( isdefined( self.c4array ) )
	{
		for ( i = 0; i < self.c4array.size; i++ )
		{
			if ( isdefined(self.c4array[i]) )
				self.c4array[i] delete();
		}
	}
	self.c4array = [];
	// delete claymores from previous spawn
	if ( isdefined( self.claymorearray ) )
	{
		for ( i = 0; i < self.claymorearray.size; i++ )
		{
			if ( isdefined(self.claymorearray[i]) )
				self.claymorearray[i] delete();
		}
	}
	self.claymorearray = [];
	
	// delete proxmines from previous spawn
	if ( isdefined( self.proxminearray ) )
	{
		for ( i = 0; i < self.proxminearray.size; i++ )
		{
			if ( isdefined(self.proxminearray[i]) )
				self.proxminearray[i] delete();
		}
	}
	self.proxminearray = [];	
	
	thread watchC4();
	thread watchC4Detonation();
	thread watchClaymores();
	//thread watchproxmines();
	thread deleteC4AndClaymoresOnDisconnect();
	
	for ( ;; )
	{
		self waittill ( "grenade_pullback", weaponName );
		self.hasDoneCombat = true;
		self.throwingGrenade = true;
		
		if ( weaponName == "c4_mp" )
			self beginC4Tracking();
		else
			self beginGrenadeTracking();
	}
}


beginGrenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	self waittill ( "grenade_fire", grenade, weaponName );
	if ( weaponName == "frag_grenade_mp" )
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		
	self.throwingGrenade = false;
}


beginC4Tracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	self waittill_any_mp ( "grenade_fire", "weapon_change" );
	self.throwingGrenade = false;
}


watchC4()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	//maxc4 = 2;

	while(1)
	{
		self waittill( "grenade_fire", c4, weapname );
		if ( weapname == "c4" || weapname == "c4_mp" )
		{
			/*if ( self.c4array.size >= maxc4 )
			{
				newarray = [];
				for ( i = 0; i < self.c4array.size; i++ )
				{
					if ( isdefined(self.c4array[i]) )
						newarray[newarray.size] = self.c4array[i];
				}
				self.c4array = newarray;
				for ( i = 0; i < self.c4array.size - maxc4 + 1; i++ )
				{
					self.c4array[i] delete();
				}
				newarray = [];
				for ( i = 0; i < maxc4 - 1; i++ )
				{
					newarray[i] = self.c4array[self.c4array.size - maxc4 + 1 + i];
				}
				self.c4array = newarray;
			}*/
			self.c4array[self.c4array.size] = c4;
			c4.owner = self;
			c4 thread maps\mp\gametypes\_shellshock::c4_earthQuake();
			c4 thread c4Damage();
		}
	}
}


watchClaymores()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "grenade_fire", claymore, weapname );
		if ( weapname == "claymore" || weapname == "claymore2_mp" )
		{
			self.claymorearray[self.claymorearray.size] = claymore;
			claymore.owner = self;
			claymore thread c4Damage();
			claymore thread claymoreDetonation();
		}
	}
}

claymoreDetonation()
{
	self endon("death");
	
	// wait until we settle
	prevorigin = self.origin;
	while(1)
	{
		wait .2;
		if ( self.origin == prevorigin )
			break;
		prevorigin = self.origin;
	}
	
	detonateRadius = 64;
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), 0, detonateRadius, detonateRadius*2);
	self thread deleteOnDeath( damagearea );
	
	while(1)
	{
		damagearea waittill("trigger", player);
		
		if ( isdefined( self.owner ) && player == self.owner )
			continue;
		if ( !friendlyFireCheck(self.owner, player) )
			continue;
		
		if ( player sightConeTrace(self.origin, self) > 0 )
		{
			self detonate();
			return;
		}
	}
}

/*
watchproxmines()
{

	while(1)
	{
		self waittill( "grenade_fire", proxmine, weapname );
		if ( weapname == "proxmine_mp" )
		{
			self.proxminearray[self.proxminearray.size] = proxmine;
			proxmine.owner = self;
			proxmine thread c4Damage();
			proxmine thread proxmineDetonation();
		}
	}
}
*/

/*
proxmineDetonation()
{
	self endon("death");
	
	// wait until we settle
	prevorigin = self.origin;
	while(1)
	{
		wait .2;
		if ( self.origin == prevorigin )
			break;
		prevorigin = self.origin;
	}
	
	detonateRadius = 100;
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), 0, detonateRadius, detonateRadius*2);
	self thread deleteOnDeath( damagearea );
	
	while(1)
	{
		damagearea waittill("trigger", player);
		
		if ( isdefined( self.owner ) && player == self.owner )
			continue;
		if ( !friendlyFireCheck(self.owner, player) )
			continue;
		
		if ( player sightConeTrace(self.origin, self) > 0 )
		{
			self detonate();
			return;
		}
	}
}
*/

deleteOnDeath(ent)
{
	self waittill("death");
	wait .05;
	if ( isdefined(ent) )
		ent delete();
}

watchC4Detonation()
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		self waittill( "detonate" );
		weap = self getCurrentWeapon();
		if ( weap == "c4_mp" )
		{
			for ( i = 0; i < self.c4array.size; i++ )
			{
				if ( isdefined(self.c4array[i]) )
					self.c4array[i] thread waitAndDetonate( 0.1 );
			}
			self.c4array = [];
		}
	}
}

waitAndDetonate( delay )
{
	self endon("death");
	wait delay;

	self detonate();
}

deleteC4AndClaymoresOnDisconnect()
{
	self endon("death");
	self waittill("disconnect");
	
	c4array = self.c4array;
	claymorearray = self.claymorearray;
	proxminearray = self.proxminearray;
		
	wait .05;
	
	for ( i = 0; i < c4array.size; i++ )
	{
		if ( isdefined(c4array[i]) )
			c4array[i] delete();
	}
	for ( i = 0; i < claymorearray.size; i++ )
	{
		if ( isdefined(claymorearray[i]) )
			claymorearray[i] delete();
	}
	
	for ( i = 0; i < proxminearray.size; i++ )
	{
		if ( isdefined(proxminearray[i]) )
			proxminearray[i] delete();
	}	
}

c4Damage()
{
	self endon( "death" );

	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	while(1)
	{
		self waittill("damage", amount, attacker);
		if ( !isplayer(attacker) )
			continue;

		// don't allow people to destroy C4 on their team if FF is off
		if ( !friendlyFireCheck(self.owner, attacker) )
			continue;
		
		break;
	}
	
	if ( level.c4explodethisframe )
		wait .1 + randomfloat(.4);
	else
		wait .05;
	
	if (!isdefined(self))
		return;
	
	level.c4explodethisframe = true;
	
	thread resetC4ExplodeThisFrame();
	
	self detonate( attacker );
	// won't get here; got death notify.
}

resetC4ExplodeThisFrame()
{
	wait .05;
	level.c4explodethisframe = false;
}

saydamaged(orig, amount)
{
	for (i = 0; i < 60; i++)
	{
		print3d(orig, "damaged! " + amount);
		wait .05;
	}
}




// these functions are used with scripted weapons (like c4, claymores, artillery)
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
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]) || players[i].sessionstate != "playing")
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, playerpos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
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
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = grenades[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	claymores = getentarray("claymore", "targetname");
	for (i = 0; i < claymores.size; i++)
	{
		entpos = claymores[i].origin + (0,0,4);
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, claymores[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = claymores[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}


	proxmines = getentarray("proxmine", "targetname");
	for (i = 0; i < proxmines.size; i++)
	{
		entpos = proxmines[i].origin + (0,0,4);
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, proxmines[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = proxmines[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	
	destructables = getentarray("destructable", "targetname");
	for (i = 0; i < destructables.size; i++)
	{
		entpos = destructables[i].origin;
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = true;
			newent.entity = destructables[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	return ents;
}

weaponDamageTracePassed(from, to, startRadius, ignore)
{
	midpos = undefined;
	
	diff = to - from;
	if ( lengthsquared( diff ) < startRadius*startRadius )
		midpos = to;
	dir = vectornormalize( diff );
	midpos = from + (dir[0]*startRadius, dir[1]*startRadius, dir[2]*startRadius);

	trace = bullettrace(midpos, to, false, ignore);
	
	if ( getdvarint("scr_damage_debug") != 0 )
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
	
	return (trace["fraction"] == 1);
}

// eInflictor = the entity that causes the damage (e.g. a claymore)
// eAttacker = the player that is attacking
// iDamage = the amount of damage to do
// sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
// sWeapon = string specifying the weapon used (e.g. "claymore_mp")
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
	else
	{
		// destructable walls and such can only be damaged in certain ways.
		if (self.isADestructable && (sWeapon == "artillery_mp" || sWeapon == "claymore_mp"))
			return;
		
		self.entity notify("damage", iDamage, eAttacker);
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


onWeaponDamage( eInflictor, sWeapon, meansOfDeath, damage )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	switch( sWeapon )
	{
		case "concussion_grenade_mp":
			// should match weapon settings in gdt
			radius = 512;
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			time = 1 + (4 * scale);
			
			wait ( 0.05 );
			self shellShock( "concussion_grenade_mp", time );
		break;
		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
		break;
	}
	
}

getItemWeaponName()
{
	classname = self.classname;
	assert( getsubstr( classname, 0, 7 ) == "weapon_" );
	weapname = getsubstr( classname, 7 );
	return weapname;
}