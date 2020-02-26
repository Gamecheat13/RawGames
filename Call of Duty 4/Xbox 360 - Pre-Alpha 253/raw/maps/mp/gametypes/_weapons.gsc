#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	level.weaponIDs = [];

	// pistol
	level.weaponIDs[0] = "beretta_mp";
	level.weaponIDs[1] = ""; 
	level.weaponIDs[2] = "usp_mp";
	level.weaponIDs[3] = "deserteagle_mp";
	level.weaponIDs[4] = "colt45_mp";
	level.weaponIDs[5] = "";
	level.weaponIDs[6] = "";
	level.weaponIDs[7] = "";
	level.weaponIDs[8] = "";
	level.weaponIDs[9] = "";

	// smg
	level.weaponIDs[10] = "mp5_mp";
	level.weaponIDs[11] = "";
	level.weaponIDs[12] = "uzi_mp";
	level.weaponIDs[13] = "skorpion_mp";
	level.weaponIDs[14] = "";
	level.weaponIDs[15] = "";
	level.weaponIDs[16] = "";
	level.weaponIDs[17] = "";
	level.weaponIDs[18] = "";
	level.weaponIDs[19] = "";

	// assault rifle
	level.weaponIDs[20] = "ak47_mp";
	level.weaponIDs[21] = "ak74u_mp";
	level.weaponIDs[22] = "";
	level.weaponIDs[23] = "";
	level.weaponIDs[24] = "g3_mp";
	level.weaponIDs[25] = "g36c_mp";
	level.weaponIDs[26] = "";
	level.weaponIDs[27] = "m16_mp";
	level.weaponIDs[28] = "m4";
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
	level.weaponIDs[40] = "ak47_gp25_mp";
	level.weaponIDs[41] = "";
	level.weaponIDs[42] = "g3_hk79_mp";
	level.weaponIDs[43] = "g36c_ag36_mp";
	level.weaponIDs[44] = "m16_m203_mp";
	level.weaponIDs[45] = "m4_m203_mp";
	level.weaponIDs[46] = "";
	level.weaponIDs[47] = "";
	level.weaponIDs[48] = "";
	level.weaponIDs[49] = "";

	// grenade/rocket launchers
	level.weaponIDs[50] = "m203_mp";
	level.weaponIDs[51] = "gp25_mp";
	level.weaponIDs[52] = "";
	level.weaponIDs[53] = "hk79_mp";
	level.weaponIDs[54] = "ag36_mp";
	level.weaponIDs[55] = "rpg_mp";
	level.weaponIDs[56] = "at4_mp";
	level.weaponIDs[57] = "";
	level.weaponIDs[58] = "";
	level.weaponIDs[59] = "";

	// sniper rifle
	level.weaponIDs[60] = "dragunov_mp";
	level.weaponIDs[61] = "m40a3_mp";
	level.weaponIDs[62] = "barrett_mp";
	level.weaponIDs[63] = "aw50_mp";
	level.weaponIDs[64] = "remington700_mp";
	level.weaponIDs[65] = "";
	level.weaponIDs[66] = "";
	level.weaponIDs[67] = "";
	level.weaponIDs[68] = "";
	level.weaponIDs[69] = "";

	// shotguns
	level.weaponIDs[70] = "m1014_mp";
	level.weaponIDs[71] = "winchester1200_mp";
	level.weaponIDs[72] = "";
	level.weaponIDs[73] = "";
	level.weaponIDs[74] = "";
	level.weaponIDs[75] = "";
	level.weaponIDs[76] = "";
	level.weaponIDs[77] = "";
	level.weaponIDs[78] = "";
	level.weaponIDs[79] = "";

	// lmgs
	level.weaponIDs[80] = "rpd_mp";
	level.weaponIDs[81] = "saw_mp";
	level.weaponIDs[82] = "m60e4_mp";
	level.weaponIDs[83] = ""; //?
	level.weaponIDs[84] = ""; //?
	level.weaponIDs[85] = "";
	level.weaponIDs[86] = "";
	level.weaponIDs[87] = "";
	level.weaponIDs[88] = "";
	level.weaponIDs[89] = "";

	// specials	
	level.weaponIDs[90] = "c4_mp";
	level.weaponIDs[91] = "claymore_mp";
	level.weaponIDs[92] = "";
	level.weaponIDs[93] = "";
	level.weaponIDs[94] = "";
	level.weaponIDs[95] = "";
	level.weaponIDs[96] = "";
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

	level.weaponList = [];
	level.weaponList[level.weaponList.size] = "flash_grenade_mp";             
	level.weaponList[level.weaponList.size] = "tear_grenade_mp";              
	level.weaponList[level.weaponList.size] = "frag_grenade_mp";               
	level.weaponList[level.weaponList.size] = "concussion_grenade_mp";        
	level.weaponList[level.weaponList.size] = "smoke_grenade_mp";    
	level.weaponList[level.weaponList.size] = "mp5_mp";                       
	level.weaponList[level.weaponList.size] = "c4_mp";                                                    
	level.weaponList[level.weaponList.size] = "m16_mp";                       
	level.weaponList[level.weaponList.size] = "m16_m203_mp";                  
	level.weaponList[level.weaponList.size] = "m203_mp";                      
	level.weaponList[level.weaponList.size] = "g36c_mp";                      
	level.weaponList[level.weaponList.size] = "g36c_ag36_mp";                 
	level.weaponList[level.weaponList.size] = "ag36_mp";                                        
	level.weaponList[level.weaponList.size] = "m14_scoped_mp";                
	level.weaponList[level.weaponList.size] = "m40a3_mp";                     
	level.weaponList[level.weaponList.size] = "barrett_mp";                   
	level.weaponList[level.weaponList.size] = "winchester1200_mp";            
	level.weaponList[level.weaponList.size] = "m1014_mp";                     
	level.weaponList[level.weaponList.size] = "m4_mp";                                             
	level.weaponList[level.weaponList.size] = "saw_mp";                       
	level.weaponList[level.weaponList.size] = "m60e4_mp";                     
	level.weaponList[level.weaponList.size] = "skorpion_mp";                  
	level.weaponList[level.weaponList.size] = "uzi_mp";                                           
	level.weaponList[level.weaponList.size] = "ak47_mp";                      
	level.weaponList[level.weaponList.size] = "ak47_gp25_mp";                 
	level.weaponList[level.weaponList.size] = "gp25_mp";                      
	level.weaponList[level.weaponList.size] = "g3_mp";                        
	level.weaponList[level.weaponList.size] = "g3_hk79_mp";                   
	level.weaponList[level.weaponList.size] = "hk79_mp";                                                         
	level.weaponList[level.weaponList.size] = "dragunov_mp";                  
	level.weaponList[level.weaponList.size] = "remington700_mp";              
	level.weaponList[level.weaponList.size] = "aw50_mp";                      
	level.weaponList[level.weaponList.size] = "ak74u_mp";                                                               
	level.weaponList[level.weaponList.size] = "rpd_mp";                       
	level.weaponList[level.weaponList.size] = "rpg_mp";                       
	level.weaponList[level.weaponList.size] = "at4_mp";                       
	level.weaponList[level.weaponList.size] = "beretta_mp";           
	level.weaponList[level.weaponList.size] = "usp_mp";
	level.weaponlist[level.weaponlist.size] = "m4_m203_mp";

	for ( index = 0; index < level.weaponList.size; index++ )
		precacheItem( level.weaponList[index] );
	
	precacheShellShock( "default" );
	precacheShellShock( "concussion_grenade_mp" );
//	thread maps\mp\_pipebomb::main();
//	thread maps\mp\_ied::main();
	thread maps\mp\_claymores::main();
	thread maps\mp\_flashgrenades::main();
	thread maps\mp\_teargrenades::main();
	thread maps\mp\_entityheadicons::init();

	level thread onPlayerConnect();
	
	level.c4explodethisframe = false;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedweapons = false;

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

	if ( !(self AnyAmmoForWeaponModes( weapon )) )
		return;

	self dropItem( weapon );
}

dropOffhand()
{
	grenadeTypes = [];
	grenadeTypes[grenadeTypes.size] = "frag_grenade_mp";
	grenadeTypes[grenadeTypes.size] = "smoke_grenade_mp";
	grenadeTypes[grenadeTypes.size] = "flash_grenade_mp";
	grenadeTypes[grenadeTypes.size] = "concussion_grenade_mp";

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


updateWeaponUsageStats()
{
	fired = self.clipammo - self getWeaponAmmoClip( self.weapon );
	if ( fired <= 0 )
		return;

	total = self maps\mp\gametypes\_persistence_util::statGet( "stats", "total_shots" ) + fired;				
	hits  = self maps\mp\gametypes\_persistence_util::statGet( "stats", "hits" );				
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "misses", total - hits );
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "total_shots", total );
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "accuracy", int(hits * 10000 / total) );

	self.clipammo = 0;
	self.weapon = "none";
}


watchWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.firingWeapon = false;
	self.clipammo = 0;
	self.weapon = "none";
	
	for ( ;; )
	{	
		self waittill ( "begin_firing" );
		self.hasDoneCombat = true;
		self.firingWeapon = true;	
		
		self.weapon = self getCurrentWeapon();
		switch( self.weapon )
		{
			// ignore special weapons, explosives, and projectiles
			case "c4_mp":
			case "claymore_mp":
			case "m203_mp":
			case "gp25_mp":
			case "elgm_mp":
			case "hk79_mp":
			case "ag36_mp":
			case "rpg_mp":
			case "at4_mp":
				break;
			
			default:
				// add one to account for the shot that notified "begin_firing"
				self.clipammo = self getWeaponAmmoClip( self.weapon ) + 1;
		}

		self waittill ( "end_firing" );		
		self.firingWeapon = false;
		self updateWeaponUsageStats();
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
	
	thread watchC4();
	thread watchC4Detonation();
	thread watchClaymores();
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
	
	self waittill_any ( "grenade_fire", "weapon_change" );
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

	self.claymorearray = [];
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
		if ( lengthsquared( player getVelocity() ) < 10 )
			continue;
		
		if ( player damageConeTrace(self.origin, self) > 0 )
		{
			self detonate();
			return;
		}
	}
}

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

