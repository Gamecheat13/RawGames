#include maps\mp\_utility;

init()
{
	level.weaponList = [];
	
	level.weaponList[level.weaponList.size] = "flash_grenade_mp";             
	level.weaponList[level.weaponList.size] = "frag_grenade_mp";               
	level.weaponList[level.weaponList.size] = "smoke_grenade_mp";    

	
	level.weaponList[level.weaponList.size] = "p99_mp";
	level.weaponList[level.weaponList.size] = "p99_hero_mp";
	level.weaponList[level.weaponList.size] = "glock_mp";
	level.weaponList[level.weaponList.size] = "1911_mp";
	level.weaponList[level.weaponList.size] = "magnum_mp";
	level.weaponList[level.weaponList.size] = "mp5_mp";

	
	level.weaponList[level.weaponList.size] = "aksu_mp";
	level.weaponList[level.weaponList.size] = "m4_mp";
	level.weaponList[level.weaponList.size] = "scar_mp";
	level.weaponList[level.weaponList.size] = "1300_auto_mp";
	level.weaponList[level.weaponList.size] = "1300_bomber_mp";
	level.weaponList[level.weaponList.size] = "mac11_mp";
	level.weaponList[level.weaponList.size] = "calico_mp";
	level.weaponList[level.weaponList.size] = "aug_mp";
	level.weaponList[level.weaponList.size] = "svd_dragunov_mp";

	
	level.weaponList[level.weaponList.size] = "golden_gun_mp";









	level.weaponList[level.weaponList.size] = "proxmine_mp";



	level.weaponList[level.weaponList.size] = "bomb_mp";
			
	for ( index = 0; index < level.weaponList.size; index++ )
		precacheItem( level.weaponList[index] );

	precacheShellShock( "default" );




	thread maps\mp\_flashgrenades::main();

	thread maps\mp\_entityheadicons::init();
	thread maps\mp\_proxmines::main();

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

watchWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.firingWeapon = false;
	
	for ( ;; )
	{
		self waittill ( "begin_firing" );
		self.hasDoneCombat = true;
		self.firingWeapon = true;
		self waittill ( "end_firing" );		
		self.firingWeapon = false;
	}

}


friendlyFireCheck(owner, attacker)
{
	if ( !isdefined(owner) ) 
		return true;
	
	if ( !level.teamBased ) 
		return true;
	
	if ( level.friendlyfire != 0 ) 
		return true;
	
	if ( attacker == owner ) 
		return true;
	
	if (!isdefined(attacker.pers["team"])) 
		return true;
	
	if ( attacker.pers["team"] != owner.pers["team"] ) 
		return true;
	
	return false; 
}

watchGrenadeUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.throwingGrenade = false;
	
	
	if ( isdefined( self.c4array ) )
	{
		for ( i = 0; i < self.c4array.size; i++ )
		{
			if ( isdefined(self.c4array[i]) )
				self.c4array[i] delete();
		}
	}
	self.c4array = [];
	
	if ( isdefined( self.claymorearray ) )
	{
		for ( i = 0; i < self.claymorearray.size; i++ )
		{
			if ( isdefined(self.claymorearray[i]) )
				self.claymorearray[i] delete();
		}
	}
	self.claymorearray = [];
	
	
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

	

	while(1)
	{
		self waittill( "grenade_fire", c4, weapname );
		if ( weapname == "c4" || weapname == "c4_mp" )
		{
			
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









getDamageableEnts(pos, radius, doLOS, startRadius)
{
	ents = [];
	
	if (!isdefined(doLOS))
		doLOS = false;
		
	if ( !isdefined( startRadius ) )
		startRadius = 0;
	
	
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








damageEnt(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, damagepos, damagedir)
{
	if (self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](
			eInflictor, 
			eAttacker, 
			iDamage, 
			0, 
			sMeansOfDeath, 
			sWeapon, 
			damagepos, 
			damagedir, 
			"none", 
			0 
		);
	}
	else
	{
		
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
			
			radius = 512;
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			time = 1 + (4 * scale);
			
			wait ( 0.05 );
			self shellShock( "concussion_grenade_mp", time );
		break;
		default:
			
			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
		break;
	}
	
}

