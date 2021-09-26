#include maps\_utility;
#using_animtree ("stuka");

main(model)
{
	level.vehicleInitThread["stuka"][model] = ::init;

	switch(model)	
	{
		case "xmodel/vehicle_stuka_flying":
			precachemodel("xmodel/vehicle_crusader2");
			precachemodel("xmodel/vehicle_crusader2_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_stuka_flying";
			break;

	}

	precachevehicle("Stuka");
	precacheturret("Stuka_guns");
//	loadfx("fx/explosions/metal_b.efx");
//	loadfx("fx/tagged/tailsmoke_flameout2.efx");
//	loadfx("fx/tagged/stukka_boom1.efx ");
//	loadfx("fx/tagged/stukka_firestream.efx");

}

init()
{
	life();
	thread kill();
	thread plane_end();
	thread takeoff();
	thread wheelsup();
	thread stop_firing();
	thread start_firing();
	thread flightoff();
	thread flighton();

	self.inflight = 0;
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "noturrets")
		return;
	self.leftturret = spawnTurret("misc_turret", (0,0,0), "stuka_guns");
	self.rightturret = spawnTurret("misc_turret", (0,0,0), "stuka_guns");
	self.leftturret setmode("manual");
	self.rightturret setmode("manual");

/*
	self.leftturret setmodel("xmodel/vehicle_plane_stuka_gun");
	self.rightturret setmodel("xmodel/vehicle_plane_stuka_gun");
*/
	self.leftturret.origin = self gettagorigin("tag_gunLeft");
	self.rightturret.origin = self gettagorigin("tag_gunRight");
	self.leftturret.angles = self.angles;
	self.rightturret.angles = self.angles;

	self.leftturret linkto (self,"tag_gunLeft", (0,0,0),(0,0,0));
	self.rightturret linkto (self,"tag_gunRight",(0,0,0),(0,0,0));

}

life()
{
	self.health = 300;
	thread regen();
}

kill()
{
//	self.crashfx = loadfx("fx/explosions/metal_b.efx");
//	self.smokefx = loadfx("fx/tagged/tailsmoke_flameout2.efx");
//	self.explode1 = loadfx("fx/tagged/stukka_boom1.efx ");
//	self.explode2 = loadfx("fx/tagged/stukka_firestream.efx");


	self waittill( "death", attacker );
	if (!isdefined(self))
		return;
	thread turret_kill();

	self playsound ("explo_metal_rand");
	thread deadexploded();

	earthquake(0.25, 3, self.origin, 1050);
	self.enginesmokeleft = spawn("script_origin",(0,0,0));
	self.enginesmokeleft linkto (self,"tag_engine_left",(0,0,0),(0,0,0));
//	self.enginesmokeright = spawn("script_origin",(0,0,0));
//	self.enginesmokeright linkto (self,"tag_engine_right",(0,0,0),(0,0,0));
	thread enginesmoke();
	//println ("^2PLANE SHOT DOWN! MUHAHAHA!!!!");

	self setmodel (level.deathmodel[self.model]);

	wait .7;
	self playsound("Plane_engine_die");
}

enginesmoke()
{
	self endon("death");

	accdist = 0.001;
	fullspeed = 1000.00;


	timer = gettime()+10000;
	while(1)
	{
		oldorg = self.origin;
		wait .05;
		dist = distance(oldorg,self.origin);
		accdist += dist;
		enginedist = 128;
		if(self getspeed() > 1)
		{
			if(accdist > enginedist)
			{
				speedtimes = self getspeed()/fullspeed;
//				playfx (self.smokefx, self.origin);
//				playfx (self.smokefx, self.enginesmokeright.origin);
				accdist -= enginedist;
			}
		}
	}
}

deadexploded()
{
	self endon("death");

	thread explodesequence();
	accdist = 0.001;
	fullspeed = 1000.00;


	timer = gettime()+10000;
	while(1)
	{
		oldorg = self.origin;
		wait .05;
		dist = distance(oldorg,self.origin);
		accdist += dist;
		enginedist = 64;
		if(self getspeed() > 1)
		{
			if(accdist > enginedist)
			{
				speedtimes = self getspeed()/fullspeed;
//				playfx (self.explode2, self.origin);
//				playfx (self.smokefx, self.enginesmokeright.origin);
				accdist -= enginedist;
			}
		}
	}
}
explodesequence()
{
//	playfx (self.explode1, self.origin);
	wait .2;
//	playfx (self.explode1, self.origin);
	wait .4;
//	playfx (self.explode1, self.origin);
}

crash()
{
//	playfx(self.crashfx, self.origin );
	thread playSoundinSpace("Plane_crash",self.origin);
}

/// temp untill turrets are spawnable


/// temp untill turrets are spawnable
plane_end()
{

	self waittill ("reached_end_node");
	if(!(isdefined(self.script_noteworthy) && self.script_noteworthy == "noturrets"))
	{
		turret_kill();
	}

	if(self.health <= 0 && (self.inflight))
	{
		self crash();
		self notify ("delete now");
		wait 0.05;
		self delete();
	}
	else if(self.health > 0)
	{
		self notify ("delete now");
		wait 0.05;
		self delete();
	}
	else
	{
		self freevehicle();
	}

}

turret_kill()
{
	if(isdefined(self.leftturret) && isalive(self.leftturret))
		self.leftturret delete();
	if(isdefined(self.rightturret) && isalive(self.rightturret))
		self.rightturret delete();
}

shoot_guns()
{
	self notify ("stop mg42s");
	self endon ("stop mg42s");
	self endon ("death");
	if(!(self.health > 0))
		return;
//	self thread sirens();

	fFirerate = 0.050;

	self.rightturret settargetentity(level.player);
	self.leftturret settargetentity(level.player);
	while(1)
	{
		self.leftturret shootturret();
		self.rightturret shootturret();
		wait fFirerate;
	}

}

sirens()
{
	self endon ("stop_mg42s");
	while(1)
	{
		self playsound("stuka_siren");
		self waittill ("sounddone");

	}
}

regen()
{
	self endon ("death");
	healthbuffer = 1000;
	self.health+=healthbuffer;
	while(1)
	{
		self waittill ("damage",amount);
		if(amount<300)
			self.health += amount;
		else
		{
			break;
		}
	}
	radiusDamage ( self.origin, 2, 10000, 9000);
}
takeoff()
{
	self UseAnimTree(#animtree);
	self waittill ("takeoff");
/*	
	self setanim(%stuka_takeoff);
	self setanim(%stuka_pose);
*/
}

wheelsup()
{
	return;
	self UseAnimTree(#animtree);
	self waittill ("wheelsup");
	println("wheelsup!!!!!!!");
/*
	self setanim(%stuka_takeoff);
*/
}

stop_firing()
{
	while(1)
	{
		self waittill ("stop_firing");
		self notify ("stop mg42s");
		self thread turret_kill();	
	}		
}

start_firing()
{
	while(1)
	{
		self waittill ("stop_firing");
		self notify ("stop mg42s");
		self thread shoot_guns();
	}	
}

flightoff()
{
	while(1)
	{
		self waittill ("flightoff");
		self.inflight = 0;
	}		
}

flighton()
{
	while(1)
	{
		self waittill ("flighton");
		self notify ("takeoff");
		self.inflight = 1;
	}		
}

