#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	// assigns weapons with stat numbers from 0-149
	// attachments are now shown here, they are per weapon settings instead
	level.weaponIDs = [];
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ )
	{
		weapon_name = tablelookup( "mp/statstable.csv", 0, i, 4 ) + "_mp";
		if( !isdefined( weapon_name ) || weapon_name == "_mp" )
		{
			level.weaponIDs[i] = "";
			continue;
		}
		level.weaponIDs[i] = weapon_name;
	}

	level.weaponNames = [];
	for ( index = 0; index < level.weaponIDs.size; index++ )
	{
		if ( !level.weaponIDs[index].size )
			continue;
			
		level.weaponNames[level.weaponIDs[index]] = index;
		
	}
	
	level.weaponlist = [];
	for( i = 0; i < max_weapon_num; i++ )
	{
		weapon = tablelookup( "mp/statstable.csv", 0, i, 4 );
		if( !isdefined( weapon ) || weapon == "" )
			continue;
		
		weapon = weapon+"_mp";
		level.weaponlist[level.weaponlist.size] = weapon;
	}

	for ( index = 0; index < level.weaponList.size; index++ )
		precacheItem( level.weaponList[index] );
	
	precacheShellShock( "default" );
	precacheShellShock( "concussion_grenade_mp" );
//	thread maps\mp\_pipebomb::main();
//	thread maps\mp\_ied::main();
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
	grenadetype = "frag_grenade_mp";

	count = self getammocount(grenadetype);
	return count;
}

getSmokeGrenadeCount()
{
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
		if ( weapname == "claymore" || weapname == "claymore_mp" )
		{
			self.claymorearray[self.claymorearray.size] = claymore;
			claymore.owner = self;
			claymore thread c4Damage();
			claymore thread claymoreDetonation();
			claymore maps\mp\_entityheadicons::setEntityHeadIcon(self.pers["team"], (0,0,20));
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
			self maps\mp\_entityheadicons::setEntityHeadIcon("none");
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
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
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
			
			time = 2 + (4 * scale);
			
			wait ( 0.05 );
			self shellShock( "concussion_grenade_mp", time );
		break;
		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
		break;
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
	
	self.primary_tag = undefined;
	self.sidearm_tag = undefined;
	self.inventory_tag = undefined;
	
	team = self.pers["team"];
	class = self.pers["class"];
	
	while ( true )
	{
		self waittill( "weapon_change" );
		
		// weapon array reset, might have swapped weapons off the ground
		self.weapon_array_primary =[];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory =[];
	
		// populate player's weapon stock arrays
		weaponsList = self GetWeaponsList();
		for( idx = 0; idx < weaponsList.size; idx++ )
		{
			if ( isPrimaryWeapon( weaponsList[idx] ) )
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
			else if ( isSideArm( weaponsList[idx] ) )
				self.weapon_array_sidearm[self.weapon_array_sidearm.size] = weaponsList[idx];
			else if ( isGrenade( weaponsList[idx] ) )
				self.weapon_array_grenade[self.weapon_array_grenade.size] = weaponsList[idx];
			else if ( isInventory( weaponsList[idx] ) )
				self.weapon_array_inventory[self.weapon_array_inventory.size] = weaponsList[idx];
		}

		current = self getcurrentweapon();
		
		// unthreaded intentionally - stow all weapons except current weapon
		stow_primary( self.weapon_array_primary, current );
		//stow_sidearm( self.weapon_array_sidearm, current );
		//stow_grenade( self.weapon_array_grenade );
		stow_inventory( self.weapon_array_inventory, current );
		
		wait ( 0.05 );
	}
}

detach_all_weapons()
{
	if( isdefined( self.primary_tag ) )
	{
		detach_model = getweaponmodel( self.primary_tag );
		self detach( detach_model, "tag_stowed_back" );
		self.primary_tag = undefined;
	}
	if( isdefined( self.inventory_tag ) )
	{
		detach_model = getweaponmodel( self.inventory_tag );
		self detach( detach_model, "tag_stowed_hip_rear" );
		self.inventory_tag = undefined;
	}
}

stow_primary ( primaryweapons, current )
{
	// deatch last weapon attached
	if( isdefined( self.primary_tag ) )
	{
		detach_model = getweaponmodel( self.primary_tag );
		self detach( detach_model, "tag_stowed_back" );
		self.primary_tag = undefined;
	}

	// weapon re-attachment register - MUST BE IN SYNC with self.primary_tag
	for( idx = 0; idx < primaryweapons.size; idx++ )
	{
		if( primaryweapons[idx] == current )
			continue;
		self.primary_tag = primaryweapons[idx];		
	}
	
	//  large projectile weaponry always show
	if ( self hasweapon( "rpg_mp" ) && current != "rpg_mp" )
		self.primary_tag = "rpg_mp";
	if ( self hasweapon( "at4_mp" ) && current != "at4_mp" )
		self.primary_tag = "at4_mp";
	
	if ( isdefined( self.primary_tag ) && self.primary_tag != "m203_mp" && self.primary_tag != "ag25_mp" )
	{
		weapon_model = getweaponmodel( self.primary_tag );
		self attach( weapon_model, "tag_stowed_back", true );
	}
	else
	{
		self.primary_tag = undefined;
	}
}

stow_sidearm( sidearms, current )
{
	// deatch last weapon attached
	if( isdefined( self.sidearm_tag ) )
	{
		detach_model = getweaponmodel( self.sidearm_tag );
		self detach( detach_model, "tag_stowed_back" );
		self.sidearm_tag = undefined;
	}

	for( idx = 0; idx < sidearms.size; idx++ )
	{
		if( sidearms[idx] == current )
			continue;
		self.sidearm_tag = sidearms[idx];		
	}

	weapon_model = getweaponmodel( self.sidearm_tag );
	self attach( weapon_model, "tag_stowed_back", true );
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
