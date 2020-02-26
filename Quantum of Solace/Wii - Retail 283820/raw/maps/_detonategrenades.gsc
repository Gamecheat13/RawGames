#include common_scripts\utility;
#include maps\_utility;


watchGrenadeUsage()
{
	level.c4explodethisframe = false;
	self endon( "death" );
	self.c4array = [];
	self.throwingGrenade = false;
	
	thread watchC4();
	thread watchC4Detonation();
	thread watchClaymores();
	thread watchproxmines();
	
	for ( ;; )
	{
		self waittill ( "grenade_pullback", weaponName );
		self.throwingGrenade = true;
		
		if ( weaponName == "c4" )
			self beginC4Tracking();
		else
			self beginGrenadeTracking();
	}
}


beginGrenadeTracking()
{
	self endon ( "death" );
	
	self waittill ( "grenade_fire", grenade, weaponName );


		
	self.throwingGrenade = false;
}


beginC4Tracking()
{
	self endon ( "death" );
	
	self waittill_any ( "grenade_fire", "weapon_change" );
	self.throwingGrenade = false;
}


watchC4()
{
	

	while(1)
	{
		self waittill( "grenade_fire", c4, weapname );
		if ( weapname == "c4" )
		{
			
			self.c4array[self.c4array.size] = c4;
			c4.owner = self;

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
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), 9, detonateRadius, detonateRadius*2);
	self thread deleteOnDeath( damagearea );
	
	while(1)
	{
		damagearea waittill( "trigger", ent );
		
		if ( isdefined( self.owner ) && ent == self.owner )
			continue;
	
		if ( isplayer( ent ) )
			if ( lengthsquared( ent getVelocity() ) < 10 )
			continue;
		
		if ( ent damageConeTrace(self.origin, self) > 0 )
		{
			self detonate( undefined );
			return;
		}
	}
}

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

proxmineDetonation()
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
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), 9, detonateRadius, detonateRadius*2);
	self thread deleteOnDeath( damagearea );
	
	while(1)
	{
		damagearea waittill("trigger", player);
		
		if ( isdefined( self.owner ) && player == self.owner )
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
	while(1)
	{
		self waittill( "detonate" );
		weap = self getCurrentWeapon();
		if ( weap == "c4" )
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


c4Damage()
{


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
		
		if (self.isADestructable && (sWeapon == "artillery_mp" || sWeapon == "claymore_mp" || sWeapon == "proxmine_mp"))
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
			

		break;
	}
	
}
