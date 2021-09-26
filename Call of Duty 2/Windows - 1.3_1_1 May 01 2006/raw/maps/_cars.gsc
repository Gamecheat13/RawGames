#include maps\_utility;
#using_animtree ("generic_human");

handle_attached_guys(maxpos,positions)
{
	if(!isdefined(level._vehicle_door_jumpout_anim))
		level._vehicle_door_jumpout_anim = [];
	if(isdefined(level._vehicle_door_jumpout_anim[self.model]))
		thread jumpoutdoor();  // truck plays open door animation for the driver
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "ai_wait_go")
		thread ai_wait_go();
	thread riders_unloaded();	
	self thread attack();
	self.runningtovehicle = [];
	self.usedPositions = [];
	for (i=0;i<maxpos;i++)
		self.usedPositions[i] = false;
//	climbnode [0] = "tag_climbnode";
//	climbanim [0] = %germantruck_guyC_climbin;
	
//	for(i=0;i<climbnode.size;i++)
//		self.climbnode[i] = climbnode[i];
//	for(i=0;i<climbanim.size;i++)
//		self.climbanim[i] = climbanim[i];
	if(!isdefined(self.standuptime))
		self.standuptime = 7;
		
	self.attachedguys = [];
	if(self.vehicletype == "jeep")
//		thread self_turn_handle();
		thread turn_notify();
		
	self.getinorgs = [];	
	for(i=0;i<positions.size;i++)
	{
		if(isdefined(positions[i]["getin"]))
		{
			org = self gettagorigin(positions[i]["sittag"]);
			ang = self gettagangles(positions[i]["sittag"]);
			origin = getstartorigin(org,ang,positions[i]["getin"]);
			angles = getstartangles(org,ang,positions[i]["getin"]);
			org = origin;
			ang = angles;
			spawned_org = spawn("script_origin", org);
			spawned_org.angles = ang;
			spawned_org.getinanim = positions[i]["getin"];
			spawned_org linkto(self);
			spawned_org.tag = positions[i]["sittag"];
			spawned_org.script_startingposition = i;
			self.getinorgs[self.getinorgs.size] = spawned_org;
		}
	}
	thread handle_detached_guys();
	while(self.health > 0)
	{

		guysarray = undefined;
		self waittill ("guyenters" , other);
		guysarray = other;
		
		for(i=0;i<guysarray.size;i++)
		{	
			guy = guysarray[i];
			if(!isdefined(guy))
				continue; // bad defensive stuff. shouldn't notify guyenters with no guys.
			self.attachedguys[self.attachedguys.size] = guy;
			
			pos = undefined;
			if (isdefined (guy.script_startingposition))
			{
				pos = guy.script_startingposition;
				assertEx(((pos < maxpos) && (pos >= 0)), "script_startingposition on a car rider must be between "+maxpos+" and 0");
			}
			else
			{
				//if there isn't one then set it to the lowest unused spot
				for (j=0;j<self.usedPositions.size;j++)
				{
					if (self.usedPositions[j] == true)
						continue;
					pos = j;
					break;
				}
			}
	//		assertEX(isdefined(pos),"Position not being defined in car script, most likely too many guys for this vehicle");
			if(!isdefined(pos))
				continue;		
			self.usedPositions[pos] = true;
			
			thread wait_jump_out(guy,pos);
			thread guy_waitjumpout(guy);

			guy.fakedeathanim = positions[pos]["deathanim"];
			guy.delay = positions[pos]["delay"];
			guy.movetospotanim = positions[pos]["movetospotanim"];
			guy.ridingvehicle = self;
			guy.orghealth = guy.health;
			guy.idle = positions[pos]["idle"];			//multiple idle anims
			guy.idle_forward = guy.idle;
			guy.idle_right = positions[pos]["idle_right"];	
			guy.idle_left = positions[pos]["idle_left"];	
			guy.idle_hardright = positions[pos]["idle_hardright"];	
			guy.idle_hardleft = positions[pos]["idle_hardleft"];	

			guy.idle_animstop = positions[pos]["idleanimstop"];
			guy.idle_anim = positions[pos]["idleanim"];
			
			guy.idleoccurrence = positions[pos]["idleoccurrence"];
			guy.duckidle = positions[pos]["duckidle"];			//multiple duck anims
			guy.duckidleoccurrence = positions[pos]["duckidleoccurrence"];
			
			guy.standidle = positions[pos]["standidle"];
			guy.standattack = positions[pos]["standattack"];
			
			guy.standattackforward = positions[pos]["standattackforward"];
			guy.standattackleft = positions[pos]["standattackleft"];
			guy.standattackright = positions[pos]["standattackright"];
			
			guy.standattackthreads = positions[pos]["standattackthreads"];
			guy.standattacktracks = positions[pos]["standattacktracks"];
			
			guy.sittag = positions[pos]["sittag"];
			guy.getout = positions[pos]["getout"];
			guy.exitdelay = positions[pos]["exitdelay"];
			guy.closedoor = positions[pos]["closedoor"];
			guy.duckin = positions[pos]["duckin"];
			guy.standup = positions[pos]["standup"];
			guy.getout_combat = positions[pos]["getout_combat"];
			guy.standdown = positions[pos]["standdown"];
			guy.duckout =  positions[pos]["duckout"];
			guy.deathanim = positions[pos]["death"];
			guy.deathanimloopvehicle = positions[pos]["deathloop"];
			guy.deathanimscript = positions[pos]["deathscript"];
			guy.fakefire = positions[pos]["fakefire"];

			guy.deathrollfast = positions[pos]["deathrollfast"]; 
			guy.deathrollslow = positions[pos]["deathrollslow"]; 

			guy.deathslow = positions[pos]["deathslow"]; 
			guy.deathfast = positions[pos]["deathfast"]; 
			
			guy.getin = positions[pos]["getin"];
			
			guy.standing = 0;
			guy thread fireing();
			if(isdefined(guy.standattackright))
				guy thread fireingdirection(self,pos);
			
			if(self.vehicletype == "jeep")
				thread idle_turn_handle(guy);
			if(isdefined(guy.deathanim) && !isdefined(guy.magic_bullet_shield))
			{
				guy.allowdeath = 1;
				if(guy.health <= 0)
					continue; // some scripts added dead guys to the que assuming that allowdeath would make them not die. but they die here, ugh..	
			}
			
			org = self gettagorigin(guy.sittag);
			angles = self gettagAngles(guy.sittag);
			guy linkto (self, guy.sittag, (0, 0, 0), (0, 0, 0));
			
			if(isdefined(guy.movetospotanim))
				self thread animatemoveintoplace(guy,org,angles,guy.movetospotanim);
			if(pos != 0)
			{
				guy teleport(org,angles);
				guy thread guy_deathhandle();	
				thread guy_handle(guy);
				thread guy_idle(guy);
			}
			if(pos == 0)
			{
				self.driver = guy;
				thread driverdead(guy);
				thread guy_handle(guy);
				thread guy_idle(guy);
			}
			if(pos < maxpos)
				pos++;
			else
				break;
		}
	}
}

handle_reload()  //wrapper for old "reload" notify
{
	while(1)
	{
		self waittill ("reload",other);
		self notify ("load",other);
	}
}

handle_loadnearby()
{
	while(1)
	{
		self waittill ("load_nearby",dist);
		if(!isdefined(dist))
			dist = 1000;
		loaders = [];
		assert(isdefined(self.script_team));
		ai = getaiarray(self.script_team);
		for(i=0;i<ai.size && i<self.usedPositions.size;i++)
			if(distance(ai[i].origin,self.origin) < dist)
				loaders[loaders.size] = ai[i];
		self notify ("load",loaders);		
	}
}

is_rider(guy)
{
	for(i=0;i<self.riders.size;i++)
		if(self.riders[i] == guy)
			return true;
	return false;
}

handle_detached_guys()
{
	self endon ("death");
	thread handle_reload();
	thread handle_loadnearby();
	while(1)
	{
		self waittill ("load",array);
		guysarray = [];
		if(!isdefined(array))
		{
			array = [];
			ai = getaiarray(self.script_team );
			for(i=0;i<ai.size;i++)
				if(isdefined(ai[i].script_vehicleride) && ai[i].script_vehicleride == self.script_vehicleride)
					array[array.size] = ai[i];
		}
		for(i=0;i<array.size;i++)
			if(!is_rider(array[i]))
				thread runtovehicle(array[i]);
		while(self.runningtovehicle.size)
			wait .1;
		self notify ("loaded");  // guys can die on their way to the vehicle
	}
}

runtovehicle_death (guy)
{
	self endon ("death");
	guy waittill_any ("long_death","death","enteredvehicle");
	self.runningtovehicle = array_remove(self.runningtovehicle,guy);
	if(!self.runningtovehicle.size)
		self notify ("loaded");
}


get_availablepositions ()
{
	availablepositions = [];
	for(i=0;i<self.usedPositions.size;i++)
		if(!self.usedPositions[i])
			availablepositions[availablepositions.size] = self.getinorgs[i];
	return availablepositions;
}

runtovehicle (guy)
{
	if(isdefined(self.runtovehicleoverride))
	{
		self thread [[self.runtovehicleoverride]](guy);
		return;
	}
	self endon ("death");
	guy endon ("death");
	self.runningtovehicle[self.runningtovehicle.size] = guy;
	thread runtovehicle_death(guy);
	guyarray = [];
	guy.animatein = 1;
	availablepositions = [];
	chosenorg = undefined;
	origin = 0;
	if(self.getinorgs.size)
	{
		availablepositions = self get_availablepositions();
		if(!self.usedPositions[0])
		{
			chosenorg =  self.getinorgs[0];
		}
		else
			chosenorg = getclosest(guy.origin,availablepositions);
		guy.script_startingposition = chosenorg.script_startingposition;
		self.usedpositions[chosenorg.script_startingposition] = true;
		origin = chosenorg.origin;
		angles = chosenorg.angles;
	}
	else
	{
		origin = self.origin;
		//temp code to put goal of actor behind the jeep
		angles = anglesToForward (self.angles);
		angles = maps\_utility::vectorScale(angles, -100);
		origin = origin+angles;
	}
	guy set_forcegoal();	
	if(self getspeedmph() < 1)
	{
		guyarray[0] = guy;
		wait .05;
		guy.goalradius = 16;
		guy setgoalpos (origin);
		guy waittill ("goal");
		guy unset_forcegoal();
		if(isdefined(chosenorg))
		{
			self.allowdeath = false;
			self animontag(guy,chosenorg.tag,chosenorg.getinanim);
			self.allowdeath = true;
		}
		guy notify ("enteredvehicle");
		guyarray[0] = guy;
		self notify ("guyenters", guyarray);

	}
}

runtovehicle_handle ()
{
	
}

driverdead(guy)
{
	self endon ("death");
	guy waittill ("death");
	self.deaddriver = 1;  //vehiclechase crash
}

guy_deathinvehicle()
{
	if(!isdefined(self.ridingvehicle) || self.ridingvehicle.health <= 0)
		self delete();
	if(!isdefined(self.deathrollslow) && !isdefined(self.deathrollfast))
	{
		self orientmode ("face current");
		self SetFlaggedAnimKnobAll("deathanim", self.deathanimloopvehicle, %root, 1, .05, 1);
		while(self.ridingvehicle.health > 0)
		{
			angles = self.ridingvehicle gettagAngles (self.sittag);
			self orientmode ("face angle",angles[1]);				
			wait .05;
		}
		self delete();
		return;
	}
	angles = self.ridingvehicle gettagAngles (self.sittag);
	self orientmode ("face angle",angles[1]);	
	if(self.deathanim == self.deathslow)
		self SetFlaggedAnimKnobAll("deathanim", self.deathrollslow, %root, 1, .05, 1);
	else
		self SetFlaggedAnimKnobAll("deathanim", self.deathrollfast, %root, 1, .05, 1);
	self animscripts\shared::DoNoteTracks("deathanim");
	self unlink();
}

guy_deathinvehicle_enddeathloop()
{
	self.guy_deathinvehicle_enddeathloop = false;
	self waittillmatch ("animontagdone","end");
	self.guy_deathinvehicle_enddeathloop = true;
}

guy_deathhandle()
{
	self.ridingvehicle endon ("unload");
	self.ridingvehicle endon ("death");
	self endon ("death");
		
	if(isdefined(self.deathslow))
	while(1)
	{
		if(self.ridingvehicle getspeedmph() < 20)
			self.deathanim = self.deathslow;
		else
			self.deathanim = self.deathfast;
		wait .5;
	}
}


guy_handle(guy)
{
	guy.buddyevent = [];
	guy.idling = 1;
	guy endon ("death");
	while (1)
	{
		self waittill ("groupedanimevent",other);
		if(guy.idling == 1)
		{
			guy.idling = 0;
			if(other == "idle")
			{
				self thread guy_idle(guy);
			}
			else if(other == "duck")
			{
				if(!isdefined(guy.duckin))
				{
					self thread guy_idle(guy);
				}
				else
				{
					self thread guy_duck(guy);
				}
			}
			else if(other == "stand")
			{

				if(!isdefined(guy.standup))
				{
					self thread guy_idle(guy);
				}
				else
				{
					self thread guy_stand(guy);
				}
			}
			else if(other == "unload")
			{

				if(!isdefined(guy.getout))
				{
					self thread guy_idle(guy);
				}
				else
				{
					self guy_unload(guy);
					break;
				}

			}
			else
			{
				println("leaaaaaaaaaaaaaak", other);
			}
		}
	}
}

guy_stand(guy)
{
	guy endon ("jumpingout");
	self endon ("death");
	guy endon ("endstand");
	guy endon ("death");
	animontag(guy,guy.sittag,guy.standup);
	guy_stand_attack(guy);

}

guy_stand_attack(guy)
{
	guy endon ("jumpingout");
	guy endon ("death");
	guy.standing = 1;
	mintime = 0;
	timer = gettime() + 5000;
		if (timer < mintime)
			timer = mintime;
	while (gettime() < timer)
	{
		timer2 = gettime() + 2000;
		while (gettime() < timer2)
			animflaggedontag("firing",guy,guy.sittag,guy.standattack);
		rnum = randomint(5)+10;
		for(i=0;i<rnum;i++)
		{
			if(gettime() > timer)
				break;
			animontag(guy,guy.sittag,guy.standidle);
		}
	}
	guy_stand_down(guy);
}

guy_stand_down(guy)
{
	guy endon ("jumpingout");
	if(!isdefined(guy.standdown))
	{
		thread guy_stand_attack(guy);
		return;
	}
	animontag(guy,guy.sittag,guy.standdown);
	guy.standing = 0;
	guy_idle(guy);
}

driver_idle_speed(driver)
{
	self endon ("death");
	driver endon ("idlestop");
	driver endon ("death");
	while (1)
	{
		if(self getspeedmph() == 0)
			driver.idle = driver.idle_animstop;
		else
			driver.idle = driver.idle_anim;
		wait .25;	
	}	
}

guy_idle(guy)
{
	guy endon ("jumpingout");
	self endon ("groupedanimevent");
	guy endon ("death");
	guy.idling = 1;
	guy notify ("gotime");
	if(!isdefined(guy.idle))
		return; // truck guys just stand there linked

	if(isdefined(guy.idle_animstop) && isdefined(guy.idle_anim))  // idle alternates between stopping and going
		thread driver_idle_speed(guy);
	while(1)
	{
		guy notify ("idle");
		if(isdefined(guy.idleoccurrence))  //kubelwagons have random idles like guy driver pointing forward
		{
			theanim = randomoccurrance(guy,guy.idleoccurrence);
			animontag(guy,guy.sittag,guy.idle[theanim]);
		}
		else	//jeeps just have one idle
			animontag(guy,guy.sittag,guy.idle);
	}
}


randomoccurrance(guy,occurrences)
{
	range = [];
	totaloccurrance = 0;
	for(i=0;i<occurrences.size;i++)
	{
		totaloccurrance += occurrences[i];
		range[i] = totaloccurrance;
	}
	pick = randomint(totaloccurrance);
	for(i=0;i<occurrences.size;i++)
	{
		if(pick < range[i])
		{
			return i;
		}
	}
}

guy_duck (guy)
{
	animontag(guy,guy.sittag, guy.duckin);
	thread guy_duck_idle(guy);
}

guy_duck_idle (guy)
{
	theanim = randomoccurrance(guy,guy.duckidleoccurrence);
	animontag(guy,guy.sittag, guy.duckidle[theanim]);
	thread guy_duck_out(guy);
}

guy_duck_out (guy)
{
	if(isdefined(guy.ducking) && guy.ducking == 1)
	{
		animontag(guy,guy.sittag, guy.duckout);
		guy.ducking = 0;
	}
	thread guy_idle(guy);
}

guy_unload (guy)
{
	if(!(isdefined(guy.magic_bullet_shield) && guy.magic_bullet_shield == true))
		guy.health = guy.orghealth;
	guy endon ("death");
	guy.allowdeath = 0; // nobody should die during the transition
	hascombatjumpout = isdefined(guy.getout_combat);
	if(hascombatjumpout && guy.standing)
		animontag(guy,guy.sittag, guy.getout_combat);
	else
		animontag(guy,guy.sittag, guy.getout);
	guy unlink();
	if(!isdefined(guy.magic_bullet_shield))
		guy.allowdeath = 1; // nobody should die during the transition
	guy.anim_disablelongdeath = false;
}

animontag (guy, tag , animation, notetracks, sthreads)
{
	org = self gettagOrigin (tag);
	angles = self gettagAngles (tag);
	guy animscripted("animontagdone", org, angles, animation);
	guy thread animscripts\shared::DoNoteTracks("animontagdone");

	if(isdefined(notetracks))
	{
		for(i=0;i<notetracks.size;i++)
		{
			guy waittillmatch ("animontagdone",notetracks[i]);
			guy thread [[sthreads[i]]]();
		}

	}
	guy waittillmatch ("animontagdone","end");
}

animflaggedontag (flag,guy, tag , animation, notetracks, sthreads)
{
	guy endon ("death");
	org = self gettagOrigin (tag);
	angles = self gettagAngles (tag);
	guy animscripted(flag, org, angles, animation);
	if(isdefined(notetracks))
	{
		for(i=0;i<notetracks.size;i++)
		{
			guy waittillmatch (flag,notetracks[i]);
			guy thread [[sthreads[i]]]();
		}

	}
	guy waittillmatch (flag,"end");
}

animatemoveintoplace (guy,org,angles,movetospotanim)
{
	guy animscripted("movetospot", org, angles, movetospotanim);
	guy waittillmatch ("movetospot","end");
}


wait_jump_out(guy,pos)
{
	guy.anim_disablelongdeath = true;
	if(!self.initialriders)
		self.riders = self.riders[self.riders.size];
	thread guy_vehicle_death(guy);
	guy endon ("death");
	self waittill ("unload");
	self.riders = array_remove(self.riders,guy);
	self.usedPositions[pos] = false;
	guy notify ("unload");
}

fire()
{
	self shoot();
}

guy_vehicle_death(guy)
{
	guy endon ("death");
	self endon ("unload");
	self waittill("death"); 
	guy delete();
}

guy_waitjumpout (guy)
{
	guy waittill ("unload");
	self endon ("death");
	guy endon ("death");
	if(isdefined(guy.delay))
		wait guy.delay;
	hascombatjumpout = isdefined(guy.getout_combat);
	if(!hascombatjumpout && guy.standing)
	{
		guy notify ("endstand");
	}
	else if(!hascombatjumpout && !guy.idling )
		guy waittill ("idle");

	guy notify ("jumpingout");
	thread guy_unload(guy);
	guy.deathanim = undefined;
	guy.deathanimscript = undefined;
}

fireingdirection (vehicle,pos)
{
	vehicle endon ("unload");
	self endon("death");
	wait (.05*pos); //everybody does their stuff on a different frame
	while(1)
	{
		if(isdefined(self.enemy))
		{
			org1 = self.origin;
			org2 = self.enemy.origin;
			forwardvec = anglestoforward(flat_angle(vehicle.angles));
			rightvec = anglestoright(flat_angle(vehicle.angles));
			normalvec = vectorNormalize(org2-org1);
			vectordotup = vectordot(forwardvec,normalvec);
			vectordotright = vectordot(rightvec,normalvec);
			if(vectordotup > .866)
			{
				if(self.standattack != self.standattackforward)
				{
					self.standattack = self.standattackforward;
					self notify ("firing","end");  // cancels old animation
				}
			}
			else if(vectordotright > 0)
			{
				if(self.standattack != self.standattackright)
				{
					self.standattack = self.standattackright;
					self notify ("firing","end");
				}

			}
			else if(vectordotright < 0)
			{
				if(self.standattack != self.standattackleft)
				{
					self.standattack = self.standattackleft;
					self notify ("firing","end");
				}
			}
		}
		wait (.5);
	}
}

fireing()
{
	if(isdefined(self.fakefire))
		fakefire = self.fakefire;
	else
		fakefire = false;
	
	while(1)
	{
		self waittillmatch("firing","fire");
		if(fakefire)
			self shoot(1000,self gettagorigin("tag_flash")+ vectormultiply(anglestoforward(self gettagangles("tag_flash")),500)+(0,0,50));
		else
			self shoot();

	}
}


enginesmoke(model)
{
	accdist = 0.001;
	fullspeed = 1000.00;
	org = self gettagorigin("tag_engine_left");
	timer = gettime()+10000;
	effect = level._effect["enginesmoke"+model];
	while(self getspeed() > 100 && timer > gettime())
	{
		oldorg = self.origin;
		wait .05;
		if(!isdefined(self))
			break;
		dist = distance(oldorg,self.origin);
		accdist += dist;
		enginedist = 48;
		if(self getspeed() > 1)
		{
			if(accdist > enginedist)
			{
				speedtimes = self getspeed()/fullspeed;
				playfx (effect,self gettagorigin("tag_engine_left"));
				accdist -= enginedist;
			}
		}
	}
	if(isdefined(self))
		org = self gettagorigin("tag_engine_left");
	while(timer > gettime())
	{
		playfx (effect, org);
		wait randomfloat(.3)+.1;
	}
}

attack()
{
	self endon ("death");
	while(1)
	{
		self waittill ("attack");
		self notify ("groupedanimevent","stand"); 
	}
}


self_turn_handle()
{
	self endon ("death");
	self endon ("unload");
	lastturningdir = self.turningdir;
	thread turn_notify();
	for (;;)
	{
		self.lastangles = self.angles[1];
		wait 0.1;
		turnStrength = self maps\_vehicle::getTurnStrength();
		if (turnStrength >= 10 && self.turningdir < 2)
			self.turningdir = 2;
		else if (turnStrength >= 5 && self.turningdir < 1)
			self.turningdir = 1;
		else if (turnStrength <= -10 && self.turningdir > -2)
			self.turningdir = -2;
		else if (turnStrength <= -5 && self.turningdir > -1)
			self.turningdir = -1;
		else
			self.turningdir = 0;
		if(self.turningdir != lastturningdir)
		{
			wait 2;
			lastturningdir = self.turningdir;
		}
	}
}

turn_notify()
{
	self.turningdir = 0;
	while(1)
	{
		self waittill ("turning",other);
		switch(other)
		{
			case "right":
				self.turningdir = 1; break;
			case "left":
				self.turningdir = -1; break;
			case "hard_right":
				self.turningdir = 2; break;
			case "hard_left":
				self.turningdir = -2; break;
			case "forward":
				self.turningdir = 0; break;
		}
	}
}

idle_turn_handle(guy)
{
	self endon ("death");
	guy endon ("death");
	self endon ("unload");
	lastidle = guy.idle;
	for (;;)
	{
		if(self.turningdir == 1)
			guy.idle = guy.idle_right;
		else if(self.turningdir == -1)
			guy.idle = guy.idle_left;
		else if(self.turningdir == 0)
			guy.idle = guy.idle_forward;
		else if(self.turningdir == 2)
			guy.idle = guy.idle_hardright;
		else if(self.turningdir == -2)
			guy.idle = guy.idle_hardleft;
		if(guy.idle != lastidle)
		{	
			iprintlnbold("idlechange: "+self.turningdir);
			guy notify ("animontagdone","end");
			lastidle = guy.idle;
		}
		wait .05;
	}
}

kill ()
{
//	self thread crashroll();

	model = self.model;
	self waittill( "death", attacker );
	if (!isdefined(self))
		return;
	level notify ("car killed");
	radiusDamage (self.origin+(0,0,128), 128, 800, 400);
//	model = self.model;
	playfx (level.deathfx[model], self.origin);
	self setmodel (level.deathmodel[model]);
	self playsound ("explo_metal_rand");
	earthquake(0.25, 3, self.origin, 1050);
//	self thread enginesmoke(model);
	if(self getspeedmph() < 1)
		self notify ("unload");
}

life ()
{
	if ( (isdefined (self.script_startinghealth)) && (self.script_startinghealth > 0) )
		self.health = self.script_startinghealth;
	else
		self.health = 600;
}

jumpoutdoor ()
{
	self endon ("death");
	self useanimtree (level._vehicleanimtree[self.model]);
	while(1)
	{
		self waittill ("unload");
		self setanimknobrestart(level._vehicle_door_jumpout_anim[self.model]);
		origin = self gettagorigin("tag_driver");
		maps\_utility::playsoundinspace("truck_door_open",origin);
		
	}
}

ai_wait_go()
{
	self endon ("death");
	self waittill ("loaded");
	maps\_vehicle::gopath(self);
}

riders_unloaded() // first set of riders set by script_vehicleride..
{
	self.initialriders = true;
	self waittill ("unloaded");
	self.initialriders = false;
}