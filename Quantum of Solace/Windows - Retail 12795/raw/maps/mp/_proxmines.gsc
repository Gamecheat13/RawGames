#include maps\mp\gametypes\_hud_util;

main()
{

//////////////////////////////////////////////////////////
// HEY VAHN LOOK HERE

	level.proxmineDetectionConeAngle = 360;	// Note: still doesn't detect through walls though
	level.proxmineDetectionRadius = 180;
	
	level.proxmineSpeedTheshold = 60.0;	// Minimum speed that will trigger explosion
	level.proxmineDetectionGracePeriod = 0.75;	// time from detection until BOOM
	level.proxminePlantGracePeriod = 2.0;	// Time after planting mine that it starts scanning
	level.proxmineDamageRadius = 250;
	level.proxmineMaxDamage = 350; //100 * level.proxmineDamageRadius/60; 

	// Damage lerps from inner cone to outer cone
	level.proxmineDamageConeOuterAngle = 180; 
	level.proxmineDamageConeInnerAngle = 160;
	level.proxmineName = "proxmine_mp";

	level.proxmineMaxAllowedActivePerPerson = 4;
	
//////////////////////////////////////////////////////////


	level.proxminemodelcenteroffset = (0,0,0); // offset of the center of the damage point from the origin
	
	level.proxmineexplodefx = loadfx("weapons/MP/frag_grenade");
	level.proxmineexplodesound = "explo_grenade_frag";

	precacheString(&"MP_PROXMINE_HOLDING_PROXMINE");
	precacheString(&"MP_PROXMINE_HOLDING_PROXMINE");
	precacheString(&"MP_PROXMINE_PRESS_TO_SWITCH_TO_PROXMINE");
	//precacheString(&"MP_PROXMINE_PRESS_TO_SWITCH_TO_DETONATOR");
	
	precacheString(&"MP_PLANTING_PROXMINE");
	precacheString(&"MP_CANNOT_PLANT_PROXMINE");
	
	precacheItem("proxmine_mp");
	//precacheItem("proxmine_detonator_mp");
	
	proxminemonitor = maps\mp\gametypes\_perplayer::init("proxminemonitor", ::startMonitoringproxmineUsage, ::stopMonitoringproxmineUsage);
	maps\mp\gametypes\_perplayer::enable(proxminemonitor);
}

startMonitoringproxmineUsage()
{
	self thread monitorproxmineUsage();
}

stopMonitoringproxmineUsage(disconnected)
{
	self notify("stop_monitoring_proxmine_usage");
	if( disconnected )
	{
		self deleteAllProxmines();
	}
	else
	{
		self thread waitDestroyProxmines();
		
	}
}

monitorproxmineUsage()
{
	self endon("stop_monitoring_proxmine_usage");

	// at this point, the player has just spawned.
	lastcount = 0;

	while(1)
	{
		self waittill( "grenade_fire", grenade, name );

		if( name == level.proxmineName )
		{
			self addProxMine(grenade);
			
			grenade maps\mp\_entityheadicons::setEntityHeadIcon(self.pers["team"], (0,0,20));

			grenade.owner = self;
			grenade thread waitDoThink();
		}
	}
}


addProxMine(mine)
{
	if( !isDefined(self.proxmines) )
		self.proxmines = [];

	self.proxmines[self.proxmines.size] = mine;

	if( self.proxmines.size > level.proxmineMaxAllowedActivePerPerson )
	{
		self.proxmines[ 0 ] thread deleteSingleproxmine();
	}
}


rmvProxMine(mine)
{
	newarray = [];
	for(i=0; i<self.proxmines.size; i++)
	{
		if( self.proxmines[i] != mine )
		{
			newarray[newarray.size] = self.proxmines[i];
		}
	}

	self.proxmines = newarray;
}


deleteAllProxmines()
{
	if( !isDefined(self.proxmines) )
		return;

	for(i=0; i<self.proxmines.size; i++)
	{
		if ( isDefined( self.proxmines[i] ) ) {		
			self.proxmines[i] maps\mp\_entityheadicons::setEntityHeadIcon("none");
			self.proxmines[i] notify("death");
			self.proxmines[i] delete();
		}
	}

	self.proxmines = undefined;
}

waitDestroyProxmines()
{
	wait 5;
	
	self deleteAllProxmines();
	
}

waitDoThink()
{
	self endon("detonate");
	self endon("death");

	// wait until it stops moving, then run proxmine_think()
	lastorigin = self.origin;
	while(1)
	{
		wait 0.05;
		if(lastorigin == self.origin)
			break;
		lastorigin = self.origin;
	}

	self thread proxmine_think();
	self thread proxmine_checkDamage();
}


proxmine_checkDamage()
{
	self endon("detonate");
//	self endon("death");
	self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName );

	if( !isDefined(iType) || ( iType != "MOD_PISTOL_BULLET" && iType != "MOD_RIFLE_BULLET" && iType != "MOD_MELEE" ) )
	{
		// delay for chain reaction
		wait 0.25;
	}

	self thread detonateSingleproxmine();
}


proxmine_think()
{
	self endon("detonate");
	self endon("death");
	
	detectionradius = level.proxmineDetectionRadius;
	detectionangle = level.proxmineDetectionConeAngle;
	
	pos = self.origin + level.proxminemodelcenteroffset;
	forward = anglestoforward(self.angles);
	
	wait level.proxminePlantGracePeriod; // no immediate detonation

	self setblinkrate(1900);	// note: blink is on for 100 ms

	//self playsound("proxmine_armed");
	
	//wait .5;

	
	while(1)
	{
		// look for enemies within damage cone
		detonate = false;
	
		players = getentarray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			if (!isalive(players[i]) || players[i].sessionstate != "playing")
				continue;
			//if (level.teambased && (!isdefined(players[i].pers["team"]) || (players[i].pers["team"] == self.team /*&& players[i] != self.owner*/)))
			//	continue;

 
			playerpos = players[i].origin + (0,0,32);

			playerspeed = length( players[i] getplayervelocity() );
			// temp
			//playerspeed = 190.0;
			speedthreshold = 100.0;

			playerpos = players[i].origin + (0,0,32);			
			dist = distance(pos, playerpos);			
			
			if (dist < detectionradius && bullettracepassed(pos, playerpos, false, self))
			{
				playerdir = vectornormalize(playerpos - pos);
				angle = acos(vectordot(playerdir, forward));
				
				if (angle < detectionangle && playerspeed > speedthreshold) {
					detonate = true;
					break;
				}
			}
		}
		if (detonate)
			break;

		/#
			if( getDvarInt("debug_proxmines") )
				debug_draw();
		#/
		wait .1;
	} 
	
	// kaboom
	
	self setblinkrate(75);

	wait level.proxmineDetectionGracePeriod;
	
	self thread detonateSingleproxmine();
}

/#
debug_draw()
{
	detectionradius = level.proxmineDetectionRadius;
	detectionangle = level.proxmineDetectionConeAngle;
	
	pos = self.origin + level.proxminemodelcenteroffset;
	forward = anglestoforward(self.angles);

	sphere(pos, detectionradius);
}
#/

// used by spawning; needs to be fast.
isPointVulnerable(playerorigin)
{
	pos = self.origin + level.proxminemodelcenteroffset;
	playerpos = playerorigin + (0,0,32);
	distsqrd = distancesquared(pos, playerpos);
	
	forward = anglestoforward(self.angles);
	
	if (distsqrd < level.proxmineDetectionRadius*level.proxmineDetectionRadius)
	{
		playerdir = vectornormalize(playerpos - pos);
		angle = acos(vectordot(playerdir, forward));
		if (angle < level.proxmineDetectionConeAngle) {
			return true;
		}
	}
	return false;
}


playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	// playsound and playsoundasmaster only seem to take one parameter at the moment...
	//if (isdefined(master) && master)
	//	org playsoundasmaster (alias, "sounddone");
	//else
	//	org playsound (alias, "sounddone");
	//org waittill ("sounddone");
	//org delete();
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait 10; // 10 seconds will hopefully be enough.
	org delete();
}


detonateSingleproxmine(owner) // should only be called from within detonateAllproxmine or detonateSingleproxmine.
{
	// explode, delete
	self notify("detonate");

	if( !isDefined(owner) )
		owner = self.owner;
	
	playfx(level.proxmineexplodefx, self.origin + level.proxminemodelcenteroffset);
	thread playsoundinspace(level.proxmineexplodesound, self.origin + level.proxminemodelcenteroffset);
	
	self proxmineDamage(self.origin + level.proxminemodelcenteroffset, anglesToForward(self.angles), owner, owner.pers["team"]);
	
	self thread deleteSingleproxmine();
}


deleteSingleproxmine()
{
	self notify("death");
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	self.owner rmvProxMine(self);
	self delete();
}


proxmineDamage(pos, forward, owner, team)
{
	radius = level.proxmineDamageRadius;
	max = level.proxmineMaxDamage;
	min = level.proxmineMaxDamage/2;

	anglemin = level.proxmineDamageConeInnerAngle;
	anglemax = level.proxmineDamageConeOuterAngle;

	forward = vectornormalize(forward);
	
	// ( start the trace 7 units away from the proxmine )
	ents = maps\mp\gametypes\_weapons::getDamageableEnts(pos, radius, true, 7);
	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;
		
		dist = distance(pos, ents[i].damageCenter);
		damage = int(max + (min-max)*dist/radius);
		
		entdir = vectornormalize(ents[i].damageCenter - pos);
		angle = acos(vectordot(entdir, forward));
		if (angle < anglemax)
		{
			if (angle > anglemin)
				damage = damage * (angle-anglemax)/(anglemin-anglemax);
			
			damage = int(damage);
			
			// do damage to the entity.
			
			ents[i] maps\mp\gametypes\_weapons::damageEnt(
				self, // eInflictor = the entity that causes the damage (e.g. a proxmine)
				owner, // eAttacker = the player that is attacking
				damage, // iDamage = the amount of damage to do
				"MOD_PROXMINE", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"proxmine_mp", // sWeapon = string specifying the weapon used (e.g. "proxmine_mp")
				pos, // damagepos = the position damage is coming from
				vectornormalize(ents[i].damageCenter - pos) // damagedir = the direction damage is moving in
			);
		}
	}

	physicsExplosionSphere(self.origin + level.proxminemodelcenteroffset, max, min, 1);
}
