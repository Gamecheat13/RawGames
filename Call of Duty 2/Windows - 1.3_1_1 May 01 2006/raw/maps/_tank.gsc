#include maps\_utility;

avoidtank ()
{
	self.avoiding = false;
	if(isdefined(self.spawnflags) && self.spawnflags & 1)
		return; // useable tanks don't avoid stu
	self endon ("reached_end_node");
	self endon ("deadstop");
	self endon ("death");
	self endon ("delete");
	self endon ("stop avoiding tanks");
	level.avoiddelay+= .05;
	if(level.avoiddelay > 1)
		level.avoiddelay = 0;
	wait level.avoiddelay;
	thread debug_vehicleavoid();
	for (;;)
	{
		if(!self.script_avoidvehicles)
		{
			wait .5;
			continue;
		}
		if ( (isdefined (self.dontAvoidTanks)) && (self.dontAvoidTanks == true) )
			return;

		check = tank_check(level.tanks);
		if(check != 0)
		{
			self.avoiding = true;
			if(check == 1)
			{
				self.truecheck = 1;
				stopspeed = self getspeedmph()/15*15;
				if(stopspeed<15)
					stopspeed = 15;
				self maps\_vehicle::vehicle_setspeed(0,stopspeed,"collision avoidance, non player");	
				while(check == 1)
				{
					if(!self.script_avoidvehicles)
						break;
					self maps\_vehicle::vehicle_setspeed(0,stopspeed,"collision avoidance, non player");
					check = tank_check(level.tanks);
				}
				self.truecheck = 0;

				maps\_vehicle::script_resumespeed("collision avoidance done",15);
			}
			self.avoiding = false;
		}
	}
}


debug_vehicleavoid ()
{
	/#
	self endon ("death");
	while(1)
	{

		self.truecheck = 0;
//		self.circlecheck = 0;	
	
		while(getcvar("debug_vehicleavoid") != "off" && self.script_avoidvehicles)
		{		
			speed = self getspeedmph(); 
			if(speed < 15)
				speed = 15;  // at 15/mph the cone stays the samee
			drawcone(self.checkorg.origin,self.angles,self.cosinedangle,(speed/15)*self.coneradius,0,1,0);
			for(i=0;i<self.samplepoints.size;i++)
			{
				print3d(self.samplepoints[i].origin,"o", (0,1,0),1);
			}
			print3d (self.origin+(0,0,32), "conecheck: "+self.truecheck, (0, 1, 0), 1);
//			print3d (self.origin,"circlecheck: "+self.circlecheck, (1, 0, 1), 1);
			wait .05;		
		}
		wait .6;
	}
	#/	
}

drawcone ( origin, angle, coneangle, radius , r, g, b )
{
	threesixtydiv = 64; 
	divs = int(((coneangle*2)/360)*threesixtydiv);
	condivinc = (coneangle*2)/divs;
	plotpoints = [];
	
	angles = (angle[0],angle[1]+coneangle,angle[2]);
	rightvector = anglesToForward(angles);
	rightvector =vectorMultiply(rightvector,radius);
	line (origin,origin+rightvector, (r,g,b), 1);

	angles = (angle[0],angle[1]-coneangle,angle[2]);
	leftvector = anglesToForward(angles);
	leftvector = vectorMultiply(leftvector,radius);
	line (origin,origin+leftvector, (r,g,b), 1);		

	plotang = angle[1]-coneangle;
	for(i=0;i<divs;i++)
	{
		angles = (angle[0],plotang,angle[2]);		
		vector = anglesToForward(angles);
		plotpoints[plotpoints.size] = origin+vectorMultiply(vector,radius);
		plotang += condivinc;
	}
	plotpoints[plotpoints.size] = origin+rightvector;
	
	lastpoint = plotpoints[0];
	for(i=1;i<plotpoints.size;i++)
	{
		line(lastpoint,plotpoints[i],(r,g,b),1);
		lastpoint = plotpoints[i];
	}

}

conechecksamples ()
{
	if(!isdefined(self.cosinedangle))
		self.cosinedangle = 17.0000;
	if(!isdefined(self.conevectordotnumber))
		self.conevectordotnumber = cos(self.cosinedangle);
	if(!isdefined(self.coneradius))
		self.coneradius = 800;

	level.tanks[level.tanks.size] = self;
	angle1 = anglestoright(self.angles);
	vector1 = vectorMultiply(angle1,64);

	point1 = spawn("script_origin", (1,1,1));
	point2 = spawn("script_origin", (1,1,1));
	point3 = spawn("script_origin", (1,1,1));
	point4 = spawn("script_origin", (1,1,1));
	point5 = spawn("script_origin", (1,1,1));

	stoporg1 = spawn("script_origin", (1,1,1));
	stoporg2 = spawn("script_origin", (1,1,1));


	point1.origin =  self.origin+vector1;
	point2.origin =  self.origin-vector1;

	angles = anglestoforward(self.angles);
	vector1 = vectorMultiply(angles,96);

	vector2 = vectorMultiply(angles,84);
	vector3 = vectorMultiply(angles,84);

	stoporg1.origin = self.origin+vector2;
	stoporg2.origin = self.origin-vector3;

	point1.origin = point1.origin+vector1;
	point2.origin = point2.origin+vector1;
	p3add = vectorMultiply(vector1,2);
	point3.origin = point1.origin-(p3add);
	point4.origin = point2.origin-(p3add);
	
	point5.origin = self.origin+vectorMultiply(angles,-194);
	
	self.samplepoints[0] = point1;
	self.samplepoints[1] = point2;
	self.samplepoints[2] = point3;
	self.samplepoints[3] = point4;
//	self.samplepoints[4] = point5;
	
	self.colidecircle[0] = stoporg1;
	self.colidecircle[1] = stoporg2;
	
	self.checkorg = point5;
	
	self.checkorg linkto (self);
	for(i=0;i<self.colidecircle.size;i++)
		self.colidecircle[i] linkto(self);

	for(i=0;i<self.samplepoints.size;i++)
		self.samplepoints[i] linkto (self);
}

stopcheck ( guy1, guy2, radius )
{
//	org1 = flat_origin(guy1.checkorg.origin);  //old way was guy1.oriign
//	org2 = flat_origin(guy2.origin);
	
	if ( (!isdefined (guy1)) || (!isdefined (guy2)) )
		return 0;
	
	dist = distance(guy1.origin,guy2.origin);

	if(dist >= radius)
		return 0; 

		// make sure we aren't checking ourselves
	if(guy1 == guy2) //&& !(guy1.tanksquadfollow && guy2.tanksquadfollow && guy1.squad == guy2.squad))
		return 0;
		
	if(isdefined(guy1.squad) && isdefined(guy2.squad) && guy1.squad == guy2.squad)
		return 0;
		
	org1 = flat_origin(guy1.checkorg.origin);
	forwardvec = anglestoforward(flat_angle(guy1.angles));
	normalvec = vectorNormalize(flat_origin(guy2.origin)-org1);

	//only if guys origins are in front do we check for colisions
	
	if(vectordot(forwardvec,normalvec) <= 0)  
  	return 0;
  	
	if(guy2 == level.player)
	{
		org2 = flat_origin(guy2.origin);
		normalvec = vectorNormalize(org2 - org1); 
		dot = vectordot(forwardvec,normalvec); 
		if(dot > self.conevectordotnumber)
		{
			return 1; 
		}
		return 0;
	}
	
	for(i=0;i<guy2.samplepoints.size;i++)
	{
		org2 = flat_origin(guy2.samplepoints[i].origin);
		normalvec = vectorNormalize(org2-org1);
		dot = vectordot(forwardvec,normalvec);
		if(dot > self.conevectordotnumber)
		{
			if(guy2.script_team != guy1.script_team)
			{
				guy1.enemyque = add_tofrontarray(guy1.enemyque,guy2);
				guy2.enemyque = add_tofrontarray(guy2.enemyque,guy1);										
			}
			return 1;
		}
	}
  
		
	
//	self.truecheck = 0;
//	self.circlecheck = 0;
	return 0;
}

// does check on entities that have a samplepoint array and will add
// baddies that are close to the front of the vehicle to its enemy que 
tank_check ( vehicles )
{
	prof_begin("tank_check");
	check = 0;
	checkdelay = .3;
	speed = self getspeedmph(); 
	if(self.script_avoidplayer == true)
	{
		if(speed < 8)
			speed = 8;  // at 15/mph the cone stays the samee
		if(isdefined(self.script_playerconeradius))
		{
			coneRadius = self.script_playerconeradius;
		}
		else
		{
			coneRadius = 200; 	
		}
		check = stopcheck(self,level.player,(speed/5*coneRadius));
		if(check != 0)
		{
			wait checkdelay;
			prof_end("tank_check");
			return check;
		}
	}
	if(speed < 15)
		speed = 15;  // at 15/mph the cone stays the same
	speed = (speed/15)*self.coneradius;
	for(i=0;i<vehicles.size;i++)
	{
		check = stopcheck(self,vehicles[i],speed);
		if(check != 0)
			break;
	}
	wait checkdelay;
	prof_end("tank_check");
	return check;
}

quecheck ()
{
	if(self.enemyque.size > 0)
	{
		self notify ("enemy tank que found");
		self.attackingtroops = false;
		self.attackingorigins = false;
		return true;
	}
	return false;
}

allowedShoot ( target )
{
	if (!self.script_turret)
		return false;
	if (self.stunned)
		self waittill ("stundone");
	if(!quecheck())
		return false;
	target = self.enemyque[0];
	if(!isdefined(target))
		return false;
	if(target.health <= 0)
		return false;
	return true;
}

infinitendnodeshots ()
{
	self endon ( "death" );
	self waittill ("reached_end_node");
	self.shotcount = -1;
}

array_infront ( origin1, origin2, array, obscurecheck)
{
	origin1 = flat_origin(origin1);
	origin2 = flat_origin(origin2);
	
	newarray = [];
	for(i=0;i<array.size;i++)
	{
		forwardvec = vectornormalize(origin2-origin1);
		normalvec = vectornormalize(array[i]["origin"]-origin1);
		vectordotup = vectordot(forwardvec,normalvec);
		if(vectordotup > 0)
		{
			if(obscurecheck)
			{
				backangle = flat_angle(vectortoangles(origin1-array[i]["origin"]));
//				println("thing is ",1-((gettime()-array[i]["obscurestarttime"])/array[i]["obscurefadetime"]));
				radius = array[i]["startradius"]+array[i]["radiusrange"]*(1-((gettime()-array[i]["obscurestarttime"])/array[i]["obscurefadetime"]));
//				println("radius is",radius);
				/*
				obscure["obscurestarttime"] = gettime();
				obscure["obscurefadetime"] = 25000;
				obscure["obscurefadetimer"] = obscure["obscurestarttime"]+obscure["obscurefadetime"];
				obscure["startradius"] = 256;
				obscure["largeradius"] = 2048;
				obscure["radiusrange"] = obscure["largeradius"]-obscure["startradius"];
				*/
				
				
				offset = vectormultiply(anglestoright(backangle),radius);
				point = array[i]["origin"]+offset;
				point2 = array[i]["origin"]-offset;
				vectortoradiuspoint = vectornormalize(point-origin1);
				vectordottoradiuspoint = vectordot(vectortoradiuspoint,normalvec);
				if(vectordottoradiuspoint>vectordotup)
					continue;
				else
				{
					array[i]["points"] = 1-((1-vectordotup)/(1-vectordottoradiuspoint));
					newarray[newarray.size] = array[i];
	
					
				}
				
			}
			else
			{
				newarray[newarray.size] = array[i];
				
			}
			
			
		}
		
	}
	return newarray;
}


turret_attack_think ()
{
	if (!isdefined (self.script_turret))
		self.script_turret = true;
	self.badshot = false;
	self.predictororigin = spawn("script_origin",self.origin);
	self.originque = [];
	self.attackingtroops = false;
	self.attackingorigins = false;
	self.attackback = true;
	self thread turret_idle();
	self thread attack_threats();
	self thread attack();
	self thread attack_respond();
	self.offsetone = 30;
	self.offsetzero = 430;

	self.offsetrange = self.offsetone-self.offsetzero;

	if(!isdefined(self.script_accuracy))
		self.script_accuracy = .44;
	if(self.script_accuracy > .9999)
		self.script_accuracy = .9999;
	
	if(!isdefined(self.waitingforgate))
		self.waitingforgate = false;
	self.accuracy = self.offsetzero+(self.offsetrange*self.script_accuracy);

	self endon ("death");
	self.shotcount = 2;
	shotattempts = 0;
	self thread infinitendnodeshots();
	self.turretfiretimer = gettime(); // ready to fire
	self.turretaccmins = .35;  // precentag of accuracy.  tank will never fire with accuracy less than this.   To get a tank to be more accurate simply addust the script_accuracy on the nodes.
	self.turretaccmaxs = 1-self.turretaccmins;
	
	self.shotsatzerospeed = 0;
	self.badshotcount = 0;
	if(!isdefined(self.holdfire))
		self.holdfire = false;
	for (;;)
	{
		for (;;)
		{
			if(!quecheck())
				break;
			if (!allowedShoot())
				break;
			if (self.hasriders)
				break;
			//aim at an offset origin with turret_on_vistarget();
			self thread turret_on_vistarget(self.enemyque[0],"vehicle");
			while(allowedShoot() && !self.turretonvistarg && !self.badshot )
				wait .2;
			if(self.badshot)
				break;
			while(self.holdfire)
				wait .1;
			self notify ("novistarget");  //ends turret_on_vistarget
			self.turretonvistarg = false;
			if (!allowedShoot())
				break;
			while(gettime() < self.turretfiretimer && allowedshoot())
				wait .05;
			wait .1;
			if (!allowedShoot())
				break;
			self clearTurretTarget();
			self notify( "turret_fire" );

			if(self getspeedmph() == 0)
				self.shotsatzerospeed++;
			if(self.shotsatzerospeed>9)
				self.shotsatzerospeed = 9;

			self.turretfiretimer = gettime() + (level.turretfiretime*1000);
			if(self.shotcount != -1 && !self.waitingforgate)
				shotattempts++;
			timer = gettime()+1000;
			while(gettime() < timer && allowedShoot())
				wait .05;

			if (!allowedShoot())
				break;
//			thread drawlinefortime(self.origin,offset+heightoffset,0,1,0,4);
			self setTurretTargetEnt(self.enemyque[0], (0, 0, 64) );
//			delay = randomint( 2000 ) + 1500;
//			timer = gettime()+delay;
//			while(gettime() < timer && allowedShoot())
//				wait .3;

			if(self.shotcount != -1 && shotattempts > self.shotcount)
			{
				shotattempts = 0;
				break;
			}
		}
		if(!self.script_turret)
		{
			wait .5;
			continue;
		}
		if(self.badshot && !self.attackingtroops)
		{
			wait .3;
			self.badshot = false;
			continue;
			
		}
		self.shotsatzerospeed = 0;
		shotattempts = 0;
		if(self.enemyque.size > 0)
		{
			if (!allowedShoot())
				queremove(self.enemyque[0]); 
			else	if(self.attackspeed == 0)  //!isdefined(self.killcomit)
			{
				self notify ("turretidle");  // sets tank to resume waits for next attack message from trigger
				self waittill ("attackernow");
			}
		}
		else
		{
			self notify ("turretidle");
			if(self.originque.size > 0)
			{
				if(!self.attackingorigins)
					self thread attack_origins();
			}
			else if(!self.attackingtroops && !self.hasriders && self.script_turret && self.script_attackai)
				self thread attack_troops();
		}
		wait .3;
	}
}

turret_idle()
{
	
	while(1)
	{
		self waittill("turretidle");
		if(!self.script_turret)
			continue;
		if(self.enemyque.size || self.attackingtroops || self.attackingorigins ||  self.hasriders )
			continue;
		self clearTurretTarget();
		vect = (0,0,32)+self.origin+vectormultiply(anglestoforward(self.angles),3000);
		self setturrettargetvec(vect);
//		self setturrettargetvec(level.player.origin);
//		thread DrawLineForTime(self gettagorigin("tag_flash"),vect,0,0,1,1);
		
	}
}



attack_origins()
{
	self.attackingorigins = true;
	self endon ("death");
	self endon ("attack");
	self endon ("enemy tank que found");
	looping = undefined;
	//getting messy perhaps
	self notify ("attacking origins"); // ends attacking troops
	self.attackingtroops = false;	//sets flag of not attacking troops
	self.turretonvistarg = false;

	while((self.script_turret && self.originque.size > 0 && self.originque[0].script_shots > 0) || (self.originque.size && self.originque[0].hinter))
	{
		if(isdefined(self.stop_for_attack_origins))
			self maps\_vehicle::vehicle_setspeed(0,15,"attacking origins");
		//player touching triggers takes priority over ai touching the triggers.
		if(self.script_team == "axis")
			for(i=0;i<self.originque.size;i++)
				if(isdefined(self.originque[i].triggertarget))
					if(level.player istouching (self.originque[i].triggertarget))
						self.originque = add_tofrontarray(self.originque,self.originque[i]);
		target = self.originque[0];
		if(isdefined(self.originque[0].script_noteworthy) && isdefined(level.attack_origin_condition_threadd[self.originque[0].script_noteworthy]))
			if(!self.originque[0] [[level.attack_origin_condition_threadd[self.originque[0].script_noteworthy]]]())
			{
				maps\_vehicle::script_resumespeed("no more origins",level.resumespeed);
				self.originque = array_remove(self.originque,self.originque[0]);
				continue;
			}
		self notify ("novistarget");
		self.turretonvistarg = false;
		self setTurretTargetEnt(target,(0,0,0));
		self thread turret_on_vistarget(target,"origin");
		while(gettime() < self.turretfiretimer || !self.turretonvistarg)
			wait .05;
		self clearTurretTarget();
		if(!self.script_turret)
		{
			self.attackingorigins = false;
			return;
		}
		dofire = true;
		
		if(!self.originque.size)
		{
			self.attackingorigin = false;
			return;
		}

	
		if(isdefined(self.originque[0].triggertarget))
		{
			dofire = false;
			if(self.script_team == "axis")
			{
				ai = getaiarray ("allies");
				ai[ai.size] = level.player;
			}
			else if(self.script_team == "allies")
			{
				ai = getaiarray ("axis");
			}
			else
				ai = [];
			for(i=0;i<ai.size;i++)
			{
				if(ai[i] istouching (self.originque[0].triggertarget))
				{
					dofire = true;
					break;
				}
			}
				
		}
		if(self.originque[0].hinter)
			dofire = false;
		if(dofire)
		{
		  	if(isdefined(self.originque[0].script_exploder))
				maps\_utility::exploder(self.originque[0].script_exploder);
			self notify( "turret_fire" );
		}
	
		self.originque[0].script_shots--;
		self.turretfiretimer = gettime() + (level.turretfiretime*1000);
		if(!self.script_turret)
		{
			self.attackingorigins = false;
			return;
		}
		self notify ("novistarget");
		self clearTurretTarget();
		self notify( "turretidle" );
		if(isdefined(self.originque[0].script_noteworthy) && self.originque[0].script_noteworthy == "looping")
			looping = self.originque[0].script_attackorgs;
		self.originque = array_remove(self.originque,self.originque[0]);
		if(self.originque.size == 0)
			break;
		wait .4;
	}
	if(isdefined(self.stop_for_attack_origins))
		maps\_vehicle::script_resumespeed("no more origins",level.resumespeed);
	if(isdefined(looping))
		self maps\_vehicle::turret_queorgs(looping,true);
	self.attackingorigins = false;
}

attack_troops (  )
{
	self.attackingtroops = true;
	self endon ("death");
	self endon ("attack");
	self endon ("enemy tank que found");
	self endon ("attacking origins");
	self.turretonvistarg = false;
	nearrange = 650;
	maxshots = 3;
	failedguy = [];

	failedcount = 0;
	while(self.script_turret)
	{
		
		troops = undefined;
		if(self.script_team == "axis")
		{
			troops = getaiarray("allies");
			troops[troops.size] = level.player;
			
		}
		else if(self.script_team == "allies")
			troops = getaiarray("axis");
		else 
			break;
		if(!isdefined(troops))
			break;
		fullarray = troops;
		for(i=0;i<failedguy.size;i++)
		{
			troops = array_remove(troops,failedguy[i]);
		}
		if(!troops.size)
		{
			troops = fullarray;
			failedguy = [];  //reset failed guy que start over.  Everybody has failed at this point
		}
		forwardvec = anglestoforward(self gettagangles("tag_flash"));
		target = getnearestvectoroutsiderange( self gettagorigin("tag_flash"), forwardvec, troops, nearrange);
		if(!isdefined(target))
		{
			wait .6;
			failedguy = [];
			continue;
		}
		if(!self.script_turret || !self.script_attackai)
			return;
		shotsfired = 0;
		while(isalive(target) && distance(self.origin, target.origin) > nearrange && shotsfired < maxshots )
		{

			self notify ("novistarget");
			self thread turret_on_vistarget(target,"troop");
			while(!self.turretonvistarg && !self.badshot)
				wait .1;
			if(!self.script_turret || !self.script_attackai)
				return;	
			if(self.badshot)
			{
				wait .05;
				self.badshot = false;
				break;
			}
			tracepassed = true;
			while(gettime() < self.turretfiretimer && isalive(target) && tracepassed)
			{
				tracepassed = bullettracepassed(target.origin+(0,0,48),self gettagorigin("tag_flash"),false,self);
				wait .05;
			}
			if(!(tracepassed))
			{
				wait .05;
				break;
			}
			self clearTurretTarget();

//			trace = bullettrace(self gettagorigin("tag_flash"),target.origin+(0,0,32),true,self);
//			if(!isdefined(trace["entity"]) || trace["entity"] != target)
//				break;
			self notify( "turret_fire" );
			
			failedcount = 0;
			shotsfired++;
			self.turretfiretimer = gettime() + (level.turretfiretime*1000);
		}
		if(failedcount > 2)
		{
			wait .1;
			failedcount = 0;
		}
		shotsfired = 0;
		if(!self.script_turret || !self.script_attackai)
			return;
		self notify ("novistarget");
	
		if(isalive(target))
		{
			failedguy[failedguy.size] = target;
			failedcount++;			
		}
		
		self clearTurretTarget();
		self notify( "turretidle" );
		
		wait .1;
		

	}
	self.attackingtroops = false;
}

getnearestvectoroutsiderange ( org, forwardvec, array, range )
{
	theone = undefined;
	if (array.size < 1)
		return;
		rangeontheone = 0;
	ent = undefined;
	highestvectordot = -1;
	offsetorg = self.origin+(0,0,128);
	for (i=0;i<array.size;i++)
	{
		trace = bullettrace(offsetorg,array[i].origin+(0,0,48),true,self);
		if(trace["fraction"] < .7)
		{
//			thread DrawLineForTime(offsetorg,array[i].origin+(0,0,32),1,0,0,4);
			continue;
		}
//		else
//		{
//			thread DrawLineForTime(offsetorg,array[i].origin+(0,0,32),0,1,0,4);
//		}
		newdist = distance(array[i].origin, org);
		if ( newdist < range )
			continue;
		targetvec = vectornormalize(array[i].origin - org);
		vectordotnumber = vectordot(targetvec,forwardvec);
		if( vectordotnumber > highestvectordot )
		{
			theone = array[i];
			rangeontheone = newdist;
			highestvectordot = vectordotnumber;
		}
			
	}
	
	return theone;
}

stun ( stuntime )
{
	self endon ("death");
	while(self.health > 0)
	{
		self.stunned = false;

		self waittill ("damage");
		self.stunned = true;
		wait stuntime;
		self notify ("stundone");
	}
}

kill ()
{
	self thread tank_delete();
	self waittill( "death", attacker );
	level notify ("tankdied",attacker);
	level.tanks = array_remove(level.tanks,self);
	if(!isdefined(self))
		return;  //this is awkward..  deleted things get notified "death" and their threads stick around
	self stoprumble("tank_rumble");
	if(isdefined(self.nospawning))
		self.tankgetout = 0;
	if(isdefined(self.mgturret))
	{
		for (i=0;i<self.mgturret.size;i++)
		{
			self.mgturret[i] notify ("death");
			self.mgturret[i] cleartargetentity();
			self thread maps\_tankgun::mgoff();
			self.mgturret[i] thread maps\_tankgun::mgoff();
			self.mgturret[i] setmode("manual");
		}
		for (i=0;i<self.mgturret.size;i++)
			self.mgturret[i] delete();
	}
	model = self.model;
	self setmodel( level.deathmodel[self.model] );
	self playsound( "explo_metal_rand" );
	self notify ("tankkilled");  //plays animation under the proper anim tree as set in whatever script called this thread.

	playfx( level.deathfx[model], self.origin );
	if(isdefined(self.deathdamage_max))
		maxdamage = self.deathdamage_max;
	else
		maxdamage = 600;
	if(isdefined(self.deathdamage_min))
		mindamage = self.deathdamage_min;
	else
		mindamage = 50;
	radiusDamage (self.origin+(0,0,128), 350, maxdamage, mindamage);
	earthquake( 0.25, 3, self.origin, 1050 );
	
	if(isdefined(level._effect[model+"tank_fire_turret"]))
	{
		thread playLoopedFxontag( level._effect[model+"tank_fire_turret"], 1, "tag_turret",self gettagorigin ("tag_turret"));
		thread death_firesound();		
	}
	if(isdefined(level._effect[model+"tank_fire_engine"]))
		for(i=0;i<level.damagefiretag[model].size;i++)
			thread playLoopedFxontag( level._effect[model+"tank_fire_engine"], 1, level.damagefiretag[model][i],self gettagorigin (level.damagefiretag[model][i]));			

}
death_firesound()
{
	self playloopsound ("smallfire");
	self waittill_any("death","fire extinguish");
	self stoploopsound ();
}

playLoopedFxontag(effect,durration,tag,deadorigin)
{
	effectorigin = spawn("script_origin",self.origin);
	self endon ("fire extinguish");
	thread playLoopedFxontag_originupdate(tag,effectorigin);
	while(1)
	{
		playfx(effect,effectorigin.origin,effectorigin.upvec);
		wait durration;		
	}
}

playLoopedFxontag_originupdate(tag,effectorigin)
{
	effectorigin.angles = self gettagangles(tag);
	effectorigin.origin  = self gettagorigin(tag);
	effectorigin.forwardvec = anglestoforward(effectorigin.angles);
	effectorigin.upvec = anglestoup(effectorigin.angles);
	while(isdefined(self) && self.classname == "script_vehicle" && self getspeedmph() > 0)
	{
		effectorigin.angles = self gettagangles(tag);
		effectorigin.origin  = self gettagorigin(tag);
		effectorigin.forwardvec = anglestoforward(effectorigin.angles);
		effectorigin.upvec = anglestoup(effectorigin.angles);
		wait .05;
	}
}


drawthing (id,num,lineto,offset,color)
{

	self.drawingthing = 1;
	if(!isdefined(offset))
		offset = (0,0,0);
	if(!isdefined(color))
		color = (1, 1, 1);


	print3d (self.origin + (offset), id+num, color, 1);
	if(isdefined(lineto))
		line ((self.origin + offset + (0,0,-8)),lineto.origin, color, 1);

}

friendlyfire_shield ()
{
	self endon ("death");
	self.healthbuffer = 2000;
	self.health += self.healthbuffer;
	self.currenthealth = self.health;
	attacker = undefined;
	while(self.health > 0)
	{
		self waittill ("damage",amount, attacker);
		if(isdefined(self.godmode) && self.godmode)
			self.health = self.currenthealth;
		if ( (isdefined(attacker)) && isdefined(attacker.script_team) && (isdefined (self.script_team)) && (attacker.script_team == self.script_team) )
			self.health = self.currenthealth;
		else if ( (isdefined(self.script_team)) && (self.script_team == "allies") && (isdefined (attacker)) && (attacker == level.player) )
			self.health = self.currenthealth;
		else if (level.script == "libya" || level.script == "88ridge")  //regen health for tanks in libya if attacked from the front
		{
			hitbyplayervehicle = false;
			if(isdefined(attacker) && attacker == level.playervehicle)
			{
				hitbyplayervehicle = true;
				thread [[level.hitbyplayervehiclethread]]();
				
			}
			else if(isdefined(attacker) && attacker.classname  == "script_vehicle")
			{
				if(attacker.script_team == "allies" && self.script_team == "axis")
					level notify ("hitbyalliedtank");
				else if(attacker.script_team == "axis" && self.script_team == "allies")
					level notify ("hitbyaxistank");
			}
			forwardvec = anglestoforward(self.angles);
			othervec = vectorNormalize(attacker.origin-self.origin);
			if(vectordot(forwardvec,othervec) > .86) 
			{
				if(hitbyplayervehicle)
					level notify ("tank_hit_from_front"); // notify for hintprint
				self.health+= int(amount*self.frontarmorregen);
			}
			self.currenthealth = self.health;
		}
		else
			self.currenthealth = self.health;
			
		if(self == level.playervehicle)
			println( "damaged by attacker: ",attacker.targetname);
		if(self.health < self.healthbuffer)
			break;
		
	}
//	if(isdefined(level.playervehicle))
//	if(isdefined(attacker) && attacker == level.playervehicle && isdefined(self.script_team) && self.script_team == "axis")
//		level notify ("tank shot by player");
	self notify ("death",attacker);
}

queremove (target)
{
	if(self.enemyque.size == 0)
		println("self.enemyque not defined in quermove before array remove");

	self.enemyque = array_remove(self.enemyque,target);
}

queadd (target)
{
	if(!isdefined(target))
	{
//		println("tried to add undefined to que");
		return;		
	}
	if(target.health > 0)
		self.enemyque = add_to_arrayfinotinarray( self.enemyque, target );
}

queaddtofront (target)
{
	if(!isdefined(target))
		println("tried to add undefined to que");
	if(target.health > 0)
		self.enemyque = add_tofrontarray( self.enemyque, target );
}

add_tofrontarray (array,ent)
{
	newarray[0] = ent;
	for(i=0;i<array.size;i++)
	{
		if(ent != array[i])
			newarray[newarray.size] = array[i];
	}
	return newarray;
}

quetoback (array,ent)
{

	newarray = [];
	count = 0;
	if(array.size > 1)
	{
		for(i=0;i<array.size;i++)
		{
			if(i!=0)
			{
				newarray[count] = array[i];
				count++;
			}
		}
		newarray[count] = array[0];
		return newarray;
	}
	else
	{
		return array;
	}
}

turret_on_vistarget (vistarget,type)
{
	self endon ("death");
	if(!self.script_turret)
		return;
	self.turretonvistarg = false;	
	predictorvehicle = undefined;
	predicting = false;
	if(isdefined(vistarget.predictor))
	{
		predicting = true;
		predictorvehicle = vistarget;
		vistarget = vistarget.predictor;
	}
	
	if(type == "vehicle" || type == "troop")
	{
		dist = distance(self.origin,vistarget.origin);
		visibility = getfxvisibility(self.origin,vistarget.origin);

		vismin = 1;
		vismax = 4;
		visrange = vismax-vismin;
		visibilitymod = vismin+(visrange-visibility*visrange);
		
		if(self getspeedmph() < 1 && (type == "troop" || ((predicting && predictorvehicle getspeedmph() < 1) || (!predicting && vistarget getspeedmph() < 1))))
		{
			distacc = (self.accuracy*(1-.1*self.shotsatzerospeed))*visibilitymod*(dist/5000);
		}
		else
		{
			self.shotsatzerospeed = 0;
			distacc = self.accuracy*visibilitymod*(dist/5000);
		}
		if(!predicting)
		{
			if(isdefined(vistarget.accuracyoffsetmod))
				distacc*= vistarget.accuracyoffsetmod; // for players tank artificially modifying enemies accuracy based on whatever wacky conditions I decide to use.
		}
		else
		{
			if(isdefined(predictorvehicle.accuracyoffsetmod))
				distacc*= predictorvehicle.accuracyoffsetmod; // for players tank artificially modifying enemies accuracy based on whatever wacky conditions I decide to use.
			
		}
			
		randomacc = randomfloat(distacc*self.turretaccmaxs)+(distacc*self.turretaccmins);
		angletoenemy = flat_angle(vectortoangles(vistarget.origin-self.origin));
		randrad = -20+randomint(220);
	
		if(type == "vehicle")
			heightoffset = (0,0,78);
		else
			heightoffset = (0,0,16); //try for splash damage
			
		randomthreesixtyangle = angletoenemy+(randrad,90,0);
	
		offset = vectormultiply(anglestoforward(randomthreesixtyangle),randomacc);
		
		if(type == "troop")
			tracetroops = true;
		else
			tracetroops = false;
		trace = bullettrace(self gettagorigin("tag_flash"), vistarget.origin+offset+heightoffset,tracetroops, self);
	//			thread drawlinefortime(self gettagorigin("tag_flash"),vistarget.origin+offset+heightoffset,1,1,1,hangtime);
		offset = trace["position"]-vistarget.origin;		

		/#
		cvar =getcvar("debug_vehicleturretaccuracy"); 
		while(cvar != "off")
		{
			if(
				(cvar == "axis" && self.script_team != "axis")
			||	(cvar == "allies" && self.script_team != "allies")
			  )
			  break;
			hangtime = 2;
			circleres = 14;
			hemires = circleres/2;
			circleinc = 360/circleres;
			circleres++;
			plotpoints = [];
			rad = 0;
	
			plotpoints = [];
			rad = 0.000;
			if(predicting)
				thread drawlinefortime(predictorvehicle.origin+heightoffset,vistarget.origin+offset,0,0,1,hangtime);
	
			for(i=0;i<circleres;i++)
			{
				plotpoints[plotpoints.size] = vistarget.origin+heightoffset+vectormultiply(anglestoforward((angletoenemy+(rad,90,0))),distacc);
				rad+=circleinc;
			}
			plotPoints(plotpoints,0,1,0,hangtime);
	
			plotpoints = [];
			
			rad = 0.000;
			for(i=0;i<circleres;i++)
			{
				plotpoints[plotpoints.size] =  vistarget.origin+heightoffset+vectormultiply(anglestoforward((angletoenemy+(rad,90,0))),distacc*self.turretaccmins);
				rad+=circleinc;
			}
			plotPoints(plotpoints,1,1,0,hangtime);
			thread drawlinefortime(self gettagorigin("tag_flash"),vistarget.origin+offset,1,0,0,hangtime);
			break;
		}		
		#/
		
		if(distance(trace["position"],vistarget.origin+heightoffset)/distacc > 1.5  &&  
		( 
		(predicting &&(!isdefined(trace["entity"]) || trace["entity"] != predictorvehicle)  || 
		(!isdefined(trace["entity"]) || trace["entity"] != vistarget) && vistarget != level.player )
		))
		{
			self.badshotcount++;
			if(self.badshotcount > 5)
			{
				if(type == "vehicle")
				{
					if(predicting)				
						self.enemyque = quetoback(self.enemyque,predictorvehicle);
					else
						self.enemyque = quetoback(self.enemyque,vistarget);
					
				}
				self.badshotcount = 0;
			}
	//				thread drawlinefortime(self gettagorigin("tag_flash"),vistarget.origin+offset+heightoffset,0,0,1,hangtime);
	//				thread drawlinefortime(self gettagorigin("tag_flash"),trace["position"],1,0,0,hangtime);
			wait .2;
			self.badshot = true;
			return;
		}
		else
			self.badshotcount = 0;
	//			thread drawlinefortime(self.origin,offset+heightoffset,0,1,0,4);
	}
	else
	{
		offset = (0,0,0);
		heightoffset = (0,0,0);
	}
	
	if(type != "troop")
		self setTurretTargetvec(vistarget.origin+offset );
	else
		self setTurretTargetent(vistarget,offset );
		

//	self setTurretTargetEnt(vistarget, offset );
	self.turretonvistarg = false;	
	self endon ("turret_fire");
	self endon ("novistarget");
	self waittill ("turret_on_target");
	self.turretonvistarg = true;
}

add_to_arrayfinotinarray (array,ent)
{
	doadd = 1;
	for(i=0;i<array.size;i++)
	{
		if ( (isdefined (array[i])) && (array[i] == ent) )
			doadd = 0;
	}
	if(doadd == 1)
		array = add_to_array (array, ent);
	return array;
}

setteam (team)
{
	if(isdefined(self.script_team))
		if(self.script_team == "axis" || self.script_team == "allies")
			return;
	if(team == "axis")
	{
		self.script_team = "axis";
		return;
	}
	else if(team == "allies")
	{
		self.script_team = "allies";
		return;
	}
}

tank_rumble_death(trigger)
{
	self waittill ("death");
	trigger delete();
}

tank_rumble ()
{
	areatrigger = spawn( "trigger_radius", self.origin+(0,0,-256), 0, 600, 512 );
	areatrigger enablelinkto();
	areatrigger linkto(self, "tag_body");
	self thread tank_rumble_death(areatrigger);
	self endon ("death");
	if(!isdefined(self.rumbleon))
		self.rumbleon = true;
	if(!isdefined(self.rumble_scale))
		self.rumble_scale = 0.15;
	if(!isdefined(self.rumble_duration))
		self.rumble_duration = 4.5;
	if(!isdefined(self.rumble_radius))
		self.rumble_radius = 600;
	if(!isdefined(self.rumble_basetime))
		self.rumble_basetime = 1;
	if(!isdefined(self.rumble_randomaditionaltime))
		self.rumble_randomaditionaltime = 1;
	while (1)
	{
		areatrigger waittill ("trigger");
		if(self getspeedmph() == 0 || !self.rumbleon)
		{
			wait .1;
			continue;
		}

		self playlooprumble("tank_rumble");
		while(level.player istouching(areatrigger) && self.rumbleon && self getspeedmph() > 0)
		{
			earthquake(self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius); // scale duration source radius
			wait (self.rumble_basetime + randomfloat(self.rumble_randomaditionaltime));
		}
		self stoprumble("tank_rumble");
	}
}

debug_vehicleattackthreats ( tagorg, angle, coneangle, radius, r, g, b, targorg )
{
	/#
	if(getcvar("debug_vehicleattackthreats") == "off")
		return;
	timer = gettime()+3000;
	thread DrawLineForTime(tagorg,targorg,1,0,0,4);
	while(getcvar("debug_vehicleattackthreats") != "off" && timer > gettime())
	{
		drawcone(tagorg,angle,coneangle,radius,r,g,b);
		wait .05;
	}
	#/
}

attack_threats ()  //if a tank falls within this cone they will put that tank at the front of their attack que
{
	self endon ("death");
	
	if(!(level.script == "libya" || level.script == "88ridge"))
		return;  
	radius = 3000;
	largeradius = 4500;
	angle = 22;
	conevectordotnumber = -1*cos(angle);
	
	level.attack_threats_delay+= .05;
	if(level.attack_threats_delay > 1)
		level.attack_threats_delay = 0;
	wait level.attack_threats_delay;
	while(1)
	{
		if(!self.script_turret)
		{
			wait .5;
			continue;
		}
		tagang = self gettagangles("tag_barrel");
		tagorg = self gettagorigin("tag_barrel");
		barrelvect = anglesToForward(tagang);
		for(i=0;i<level.tanks.size;i++)
		{
			if(level.tanks[i].script_team == self.script_team)
				continue;
			dist = distance(level.tanks[i].origin,self.origin);
			if(dist > largeradius)
				continue;
			else if(dist > radius && level.tanks[i] == level.playervehicle && level.currentlytargetingplayertanks.size < 3)
			{
				self thread debug_vehicleattackthreats(tagorg,tagang,angle,radius,1,0,1,level.tanks[i].origin);
				self queaddtofront(level.tanks[i]); //teh magic
				wait 4;
				break;		
			}
			else if(dist > radius)
				continue;
			normalvec = vectorNormalize(tagorg-level.tanks[i].origin);
			vectordot = vectordot(barrelvect,normalvec);
			if(level.tanks[i] == level.playervehicle && self.script_team == "axis")
			{
				self queaddtofront(level.tanks[i]); //teh magic
				wait 4;
				break;
				
			}
	//			bullettracepassed(<start>, <end>, <hit characters>, <ignore entity>)
			if(vectordot < conevectordotnumber && bullettracepassed(self.origin +(0,0,40),level.tanks[i].origin+(0,0,40),0,level.tanks[i]))
			{
				self thread debug_vehicleattackthreats(tagorg,tagang,angle,radius,1,0,1,level.tanks[i].origin);
				self queaddtofront(level.tanks[i]); //teh magic
				wait 4;
				break;
			}
		}
		wait 1;
	}
}

attack ()
{

	while(1)
	{
		self waittill ("attack",targets,attackall);
		if(!self.script_turret)
		{
			wait .5;
			continue;
		}
		if(isdefined(attackall))
			queallenemies();
		for(i=0;i<targets.size;i++)
			self thread queadd(targets[i]);
		self notify ("attackernow");
		if(self.enemyque.size == 0)
				continue;
		else
			target = self.enemyque[0];
		target notify ("attackresponse",self);  //fight back
		if(!isdefined(self.rollingdeath))
			self thread attackspeed();
	}
}

attack_respond ()
{
	while(1)
	{
		self waittill ("attackresponse",attacker);
		if(!self.script_turret || !self.attackback)
			continue;
		self thread queadd(attacker);
	}
}

attackspeed ()
{
	self.attacking = true;
	if(!self.tanksquadfollow)  // don't stop if you're in squad formation
	{
		self maps\_vehicle::vehicle_setspeed(self.attackspeed,15,"Attack speed");
	}
	self waittill ("turretidle");
	self.selfresumestate = "attack";
	self.attacking = false;  // lets resumespeed know that there's a script set speed for attacking.
	maps\_vehicle::script_resumespeed("Done attacking,turretidle",level.resumespeed);
}

queallenemies ()
{
	tanks = array_randomize(level.tanks);
	
	for(i=0;i<tanks.size;i++)
	{
		if(tanks[i].script_team != self.script_team)
			queadd(tanks[i]);
	}
}

init ()
{
	if(!isdefined(level.attack_origin_condition_threadd))
		level.attack_origin_condition_threadd = [];
	if(!isdefined(level.vehiclefireanim))
		level.vehiclefireanim = [];
	if(!isdefined(level.vehiclefireanim_settle))
		level.vehiclefireanim_settle = [];
	self.enemyque = [];
	self.stunned = false;
	thread stun(1); //stun( stuntime );

	if(isdefined(self.script_vehicleride))
		thread hasriders();
	else
		self.hasriders = false;
		
	if(!isdefined(self.script_avoidvehicles))
		self.script_avoidvehicles = false;
	if(!isdefined(self.script_badplace))
		self.script_badplace = true;
	if(!isdefined(self.script_attackai))
		self.script_attackai = true;
	if(!isdefined(self.script_avoidplayer))
		self.script_avoidplayer = false; 

	thread conechecksamples();
	thread maps\_tankgun::mginit();
	thread maps\_treads::main();
	
	thread tank_badplace();
	thread friendlyfire_shield();

	if(isdefined(self.spawnflags) && self.spawnflags & 1) // don't want players tank doing these things
		return;
	thread turret_attack_think();
	thread avoidtank();
	thread tank_rumble();

}

hasriders()
{
	self.hasriders = true;
	self waittill ("unload");
	self.hasriders = false;
}

tank_delete()
{
	self waittill_any("delete","death");
	if(isdefined(self.mgturret))
		for (i=0;i<self.mgturret.size;i++)
			if(isdefined(self.mgturret[i]))
				self.mgturret[i] delete();
	for(i=0;i<self.colidecircle.size;i++)
		self.colidecircle[i] delete();
	for(i=0;i<self.samplepoints.size;i++)
		self.samplepoints[i] delete();
	if(isdefined(self.checkorg))
		self.checkorg delete();

	level.tanks = array_remove(level.tanks,self);
}

tanks_think ()  //pulled from _vehicles.gsc
{
	self.attackspeed = 0;
	if(isdefined(self.script_team) && self.script_team == "allies")
	{
		if(isdefined(level.playervehicle) && self == level.playervehicle)
		{
			println("playervehicle thinking");
			return;
		}
		else
		{
			self thread tank_compasshandle();
			friendlytank = true;
		}
	}
	self endon ("death");
	self thread maps\_vehicle::squad();  // may someday apply to vehicles
	if ( (isdefined (self.script_vehicleride)) || (isdefined (self.script_vehiclewalk)) )
	{
		if(isdefined(level.tankai_activate_thread))
			level thread [[level.tankai_activate_thread]](self);
		else
		{
			println("***********************");
			println("maps\\\_tankai::main();");
			println("***********************");
			assertmsg("missing tankai::main, put print above this in your script");
		}
	}
}

tank_compasshandle ()
{
	self endon ("death");
	level.compassradius = int(getcvar("cg_hudCompassMaxRange"));
	self.onplayerscompass = false;
	while(1)
	{
		if(distance(self.origin,level.player.origin) < level.compassradius)
		{
			if(!(self.onplayerscompass))
			{
				self addvehicletocompass();
				self.onplayerscompass = true;
			}
		}
		else
		{
			if(self.onplayerscompass)
			{
				self removevehiclefromcompass();
				self.onplayerscompass = false;
			}
		}
		wait .5;	
	}
}

tank_badplace()
{
	self endon ("death");
	self endon ("delete");
	if(isdefined(level.custombadplacethread))
	{
		self thread [[level.custombadplacethread]]();
		return;
	}
	bp_duration = .5;
	bp_height = 300;
	bp_angle_left = 17;
	bp_angle_right = 17;
	for (;;)
	{
		if(!self.script_badplace)
		{
//			badplace_delete("tankbadplace");
			while(!self.script_badplace)
				wait .5;
		}
		speed = self getspeedmph();
		if (speed > 0)
		{
			if (speed < 5)
				bp_radius = 200;
			else if ((speed > 5) && (speed < 8))
				bp_radius = 350;
			else
				bp_radius = 500;
			
			if (isdefined(self.BadPlaceModifier))
				bp_radius = (bp_radius * self.BadPlaceModifier);
			
//			bp_direction = anglestoforward(self.angles);
			bp_direction = anglestoforward(self gettagangles ("tag_turret"));
			badplace_arc("", bp_duration, self.origin, bp_radius*1.9, bp_height, bp_direction, bp_angle_left, bp_angle_right,"allies","axis");
			badplace_cylinder("", bp_duration, self.colidecircle[0].origin, 200, bp_height, "allies","axis");
			badplace_cylinder("", bp_duration, self.colidecircle[1].origin, 200, bp_height, "allies","axis");
		}
		wait bp_duration+.05;
	}
}

shoot()
{
	self endon ("death");
	while(self.health > 0)
	{
		self waittill( "turret_fire" );
		self thread shoot_anim();
		self FireTurret();
	}
}

shoot_anim()
{
	self endon ("death");
	self endon ("turret_fire");
	assert(isdefined(level._vehicleanimtree[self.model]));
	self useanimtree(level._vehicleanimtree[self.model]);
	if(!isdefined(level.vehiclefireanim[self.model]))
		return;
	self clearanim(level.vehiclefireanim_settle[self.model],0);
	self setanim(level.vehiclefireanim[self.model],1,0);
	wait .25;
	self clearanim(level.vehiclefireanim[self.model],0);
	if(!isdefined(level.vehiclefireanim_settle[self.model]))
		return;
	self setflaggedanim("shooting_animation",level.vehiclefireanim_settle[self.model],1,0);
	self waittillmatch("shooting_animation","end");
	self clearanim(level.vehiclefireanim_settle[self.model],0);
}

openHatch_Pose()
{
	self UseAnimTree(level._vehicleanimtree[self.model]);
	self setAnim( level.TankopenHatch_anim_pose[self.model] );
}

closeHatch_Animated()
{
/*
	self UseAnimTree(level._vehicleanimtree[self.model]);
	self setanimknobrestart( level.TankopenHatch_anim_animate[self.model]);
*/
}
