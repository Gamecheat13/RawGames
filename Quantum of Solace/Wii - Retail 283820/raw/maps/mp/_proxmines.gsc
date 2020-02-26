#include maps\mp\gametypes\_hud_util;

main()
{




	level.proxmineDetectionConeAngle = 360;	
	level.proxmineDetectionRadius = 180;
	
	level.proxmineSpeedTheshold = 60.0;	
	level.proxmineDetectionGracePeriod = 0.40;	
	level.proxminePlantGracePeriod = 2.0;	
	level.proxmineDamageRadius = 250;
	level.proxmineMaxDamage = 130;

	
	level.proxmineDamageConeOuterAngle = 180; 
	level.proxmineDamageConeInnerAngle = 160;
	level.proxmineName = "proxmine_mp";
	



	level.proxminemodelcenteroffset = (0,0,0); 
	
	level.proxmineexplodefx = loadfx("props/welding_exp2");
	level.proxmineexplodesound = "explo_grenade_frag";

	precacheString(&"MP_PROXMINE_HOLDING_PROXMINE");
	precacheString(&"MP_PROXMINE_HOLDING_PROXMINE");
	precacheString(&"MP_PROXMINE_PRESS_TO_SWITCH_TO_PROXMINE");
	
	
	precacheString(&"MP_PLANTING_PROXMINE");
	precacheString(&"MP_CANNOT_PLANT_PROXMINE");
	
	precacheItem("proxmine_mp");
	
	
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
}

monitorproxmineUsage()
{
	self endon("stop_monitoring_proxmine_usage");

	
	lastcount = 0;

	while(1)
	{
		self waittill( "grenade_fire", grenade, name );

		if( name == level.proxmineName )
		{
			self addProxMine(grenade);

			grenade.owner = self;
			grenade.team  = self.pers["team"];
			grenade thread waitDoThink();
		}
	}
}


addProxMine(mine)
{
	if( !isDefined(self.proxmines) )
		self.proxmines = [];

	self.proxmines[self.proxmines.size] = mine;
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
		self.proxmines[i] notify("death");
		self.proxmines[i] delete();
	}

	self.proxmines = undefined;
}


waitDoThink()
{
	self endon("detonate");
	self endon("death");

	
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

	self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName );

	if( !isDefined(iType) || ( iType != "MOD_PISTOL_BULLET" && iType != "MOD_RIFLE_BULLET" && iType != "MOD_MELEE" ) )
	{
		
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
	
	wait level.proxminePlantGracePeriod; 

	self setblinkrate(1900);	

	
	
	

	
	while(1)
	{
		
		detonate = false;
	
		
		if( self.owner.sessionstate == "dead" )
		{
			self thread deleteSingleproxmine();
		}
		
		players = getentarray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			if (!isalive(players[i]) || players[i].sessionstate != "playing")
				continue;
				
			if ( level.teambased )
				if( players[i].pers["team"] == self.team )
					continue;
					
			if ( players[i] == self.owner )
				continue;

 
			playerpos = players[i].origin + (0,0,32);

			playerspeed = length( players[i] getplayervelocity() );
			
			
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
	
	
	
	
	
	
	
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait 10; 
	org delete();
}


detonateSingleproxmine(owner) 
{
	
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
			
			
			
			ents[i] maps\mp\gametypes\_weapons::damageEnt(
				self, 
				owner, 
				damage, 
				"MOD_PROXMINE", 
				"proxmine_mp", 
				pos, 
				vectornormalize(ents[i].damageCenter - pos) 
			);
		}
	}

	physicsExplosionSphere(self.origin + level.proxminemodelcenteroffset, max, min, 1);
}
