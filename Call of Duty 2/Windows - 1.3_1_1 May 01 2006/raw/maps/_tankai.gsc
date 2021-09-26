/***********************************************************************************************
************************************************************************************************
			USE THIS SCRIPT TO MAKE GUYS RIDE ON A TANK OR WALK WITH A TANK

To make guys ride on a tank:
	-Select AI or Spawners and a tank and group them (press shift-g) with the name "script_tankride"
	-Riders will automatically jump off the tank if one of the riders or ai walking with the tank are shot at by enemies. This
		feature can be disabled or enabled by setting .allowUnloadIfAttacked to true/false (defaults to true, making guys unload)
	
	Advanced:
		- you can specify an exact location for each guy by setting "script_startingposition" to a number 0-10
		- you can notify the tank "unload" to make all the riders unload from the tank
		- you can notify the tank "reaction" to make all the riders play their reaction animation

To make guys walk with a tank:
	-Select AI or Spawners and a tank and group them (press shift-g) with the name "script_tankwalk"
	-When these walkers take damage from enemies people riding on the same tank will unload from it. This feature can also be
		disabled or enabled by setting .allowUnloadIfAttacked to true/false (defaults to true, making riders unload when walkers are shot)
	-On each AI or Spawner specify if they should walk close to the tank, or walk near the tank using cover nodes.
		Do this by setting each AI or Spawners "script_followmode" to "close" or "cover nodes" (defaults to cover nodes)
	
	Advanced:
		-You can specify an exact location for each walker b y setting "script_startingposition" to a number 0-5

To activate the tank and riders or walkers
	-By default a tank with riders or walkers will automatically be activated at the start of a level. You can make it a triggered
		event by making a trigger_multiple or trigger_radius with a "script_tankride" or "script_tankwalk" equal to the tank you
		want the trigger to activate.

************************************************************************************************
***********************************************************************************************/
#include maps\_utility;

main(model)
{
	level.tankai_activate_thread = ::Tank_activate;
}

#using_animtree("generic_human");

RideOnTank(tank)
{	
	for (i=0;i<11;i++)
		tank.ride_tags_used[i] = false;
	
	//Do the guys that have custom positions set first
	for (i=0;i<self.size;i++)
	{
		if (!isdefined (self[i].script_startingposition))
			continue;
		self[i] RideOnTank_GivePosition(tank);
	}
	
	//Now do the rest of the guys to fill in the other spots
	for (i=0;i<self.size;i++)
	{
		if (isdefined (self[i].script_startingposition))
			continue;
		self[i] RideOnTank_GivePosition(tank);
	}
}

RideOnTank_GivePosition(tank)
{
	if (isdefined (self.script_startingposition))
	{
		assertEX (((self.script_startingposition >= 0) && (self.script_startingposition < tank.ride_tags_used.size)), "script_startingposition is set to " + self.script_startingposition + ". It must be greater than 0 and less than 11.");
		//set the guys position to a custom spot
		//If it's unavailable then put him in the next free spot and print a warning message
		if (tank.ride_tags_used[self.script_startingposition] == true)
		{
			println ("^3Guy has script_startingposition set but that spot is already taken");
			self.script_startingposition = undefined;
			return;
		}
		else
			PositionNumber = self.script_startingposition;
	}
	else
	{
		//find the next available spot to ride the tank...
		nextAvailable = -1;
		for (posIndex=0;posIndex<tank.ride_tags_used.size;posIndex++)
		{
			if (tank.ride_tags_used[posIndex] == true)
				continue;
			nextAvailable = posIndex;
		}
		assertEX (nextAvailable >= 0, "Tank ran out of riding spots. This is usually caused by making more than 11 AI ride on a tank, including the tank commander.");
		PositionNumber = nextAvailable;
	}
	
	tank.ride_tags_used[PositionNumber] = true;
	self.tankanimNumber = PositionNumber;
	self.tankride_tag = ("tag_guy" + PositionNumber);
	self.RidingTank = tank;
	if(!isdefined(level.tankai_loadanims) || !isdefined(level.tankai_loadanims[self.RidingTank.model]))
	{
		println("***********************");
		println("maps\\\_tankai_"+self.RidingTank.vehicletype+"::main(\""+self.RidingTank.model+"\");");
		println("***********************");
		assertmsg("anims for tankai not precached. add the above lines to script above _load::main");
		level waittill ("never");
	}
	self [[level.tankai_loadanims[self.RidingTank.model]]]();
	
	assertEX(PositionNumber <= 10, "Too many AI trying to ride on the tank. A tank can only have 11 total riders including the tank commander");
	self linkto (tank, ("tag_guy" + PositionNumber), (0,0,0), (0,0,0));
//	self setGoalEntity (self);
	//self teleport ((tank gettagOrigin ("tag_guy" + PositionNumber)) + (0,0,32));
	
	if (PositionNumber == 0)
	{
		tank.tankcommander = self;
		self animscripts\shared::PutGunInHand("none");
		tank thread [[level.TankopenHatch_Pose[tank.model]]]();
	}
	
	self thread loop_riding_anim(tank);
	self thread tankrider_blowup();
	self thread tankrider_UnderAttack(tank);
}

tankrider_underAttack(tank)
{
	self endon ("unloaded");
	self endon ("death");
	self.ridingtank endon ("death");
	for (;;)
	{
		self waittill ("damage", amount, attacker);
		if (!isdefined (attacker))
			continue;
		if (!isdefined (attacker.team))
			continue;
		if ( (isdefined (tank.allowUnloadIfAttacked)) && (tank.allowUnloadIfAttacked == false) )
			continue;
		
		if (!isdefined (tank))
			return;
		tank.teamUnderAttack = true;
		wait .1;
		tank notify ("unload");
		return;
	}
}

loop_riding_anim(tank)
{	
	if (!isdefined (tank))
		return;
	
	tank endon ("death");
	self endon ("death");
	self endon ("unload");
	self endon ("blowing up");
	self endon ("stop ride idle");
	
	while (isdefined (self))
	{
		if (randomint (4) == 0)
			animType = "tanktwitch";
		else
			animType = "tankidle";
		
		if ( (isdefined (self.playingCustomAnim)) && (self.playingCustomAnim == true) )
			return;
		level maps\_anim::anim_single_solo (self, animType, self.tankride_tag, undefined, tank);
	}	
}

tankrider_animateTurn(direction)
{
	self endon ("death");
	self endon ("blowing up");
	
	if (isdefined (self.turningAnimationPlaying))
		return;
	if ( (isdefined (self.turningAnimationPlaying)) && (self.turningAnimationPlaying == false) )
		return;
	if ( (isdefined(self.playingCustomAnim)) && (self.playingCustomAnim == true) )
		return;
	self.turningAnimationPlaying = true;
	
	name = undefined;
	if (direction == "left")
		name = "leanright";
	else if (direction == "right")
		name = "leanleft";
	self notify ("stop ride idle");
	level maps\_anim::anim_single_solo (self, name, self.tankride_tag, undefined, self.RidingTank);
	self.turningAnimationPlaying = undefined;
	self thread loop_riding_anim(self.RidingTank);
}

tank_reaction_wait()
{
	self endon ("death");
	self endon ("unloaded");
	
	for (;;)
	{
		self waittill ("reaction");
		
		ai = getaiarray();
		for (i=0;i<ai.size;i++)
		{
			if ( (!isdefined (ai[i])) || ( (isdefined (ai[i])) && (!isalive (ai[i])) ) )
				continue;
			if ( (isdefined (ai[i].RidingTank)) && (ai[i].RidingTank == self) )
				if (ai[i].tankride_tag != "tag_guy0")
					ai[i] thread tankrider_react();
		}
	}
}

tankrider_react()
{
	self notify ("stop ride idle");
	self endon ("blowing up");

	self.reacting = true;
	level maps\_anim::anim_single_solo (self, "reaction", self.tankride_tag, undefined, self.RidingTank);
	self.reacting = undefined;
	self thread loop_riding_anim(self.RidingTank);
}

//A Tank runs this function to make all riding guys associated with this tank unload
unload()
{
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if ( (!isdefined (ai[i])) || ( (isdefined (ai[i])) && (!isalive (ai[i])) ) )
			continue;
		if ( (isdefined (ai[i].RidingTank)) && (ai[i].RidingTank == self) )
		{
			hasriders = true;
			if (ai[i].tankride_tag == "tag_guy0")
				ai[i] thread tankrider_closehatch();
			else
				ai[i] thread tankrider_unload();
		}
	}
}

tankrider_closehatch()
{
	self endon ("blowing up");

	if (isdefined (self.DontUnloadTank))
		return;
	if (isdefined (self.closinghatch))
		return;
	if (!isdefined (self.RidingTank))
		return;
	self.closinghatch = true;
	self.RidingTank.tankcommander = undefined;
	self.RidingTank thread [[level.TankcloseHatch_Animated[self.RidingTank.model]]]();
	level maps\_anim::anim_single_solo (self, "jumpoff", self.tankride_tag, undefined, self.RidingTank);
	
	self notify ("unloaded");
	if (isdefined (self))
		self delete();
}

//This makes an individual guy unload from riding on a tank
tankrider_unload()
{
	self endon ("death");
	self endon ("blowing up");
	self.RidingTank endon ("death");
	
	wait randomfloat(0.8);
	while (isdefined (self.reacting))
		wait 0.05;
	if (!isdefined (self.RidingTank))
		return;
	self.deathanim = undefined;
		
	self notify ("unload");
	self thread tankrider_unload_notetracks();
	
	thread tankrider_unload_anim();
	self.RidingTank.riders = array_remove(self.RidingTank.riders,self);
	if (isdefined (self.RidingTank))
	{
		self setgoalpos (self.RidingTank.origin);
		self.RidingTank = undefined;
	}
	if(isdefined(self.target))
		self maps\_spawner::go_to_node();
	else if(isdefined(self.oldgoalradius))
		self.goalradius = self.oldgoalradius;
	self notify ("unloaded");
}

tankrider_unload_anim()
{
	self endon ("death");
	self endon ("blowing up");
	tank = self.RidingTank;
	tank endon ("death");
	if(tank.vehicletype != "sherman")
		self unlink();
	level maps\_anim::anim_single_solo (self, "jumpoff", self.tankride_tag, undefined, self.RidingTank);
	self notify ("unloaded");
	if(tank.vehicletype == "sherman")
		self unlink();
	
}

tankrider_unload_notetracks()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("single anim",notetrack);
		switch (notetrack)
		{
			case "gravity on":
				self stopanimscripted();
			case "end":
			case "finish":
				return;
		}
	}
}

tankrider_blowup()
{
	self endon ("unloaded");
	self.RidingTank waittill ("death");	
	if (isdefined (self))
	{
		self notify ("blowing up");
		self.deathanim = level.scr_anim[self.animname]["blowup"];
		self.deathanimscript = ::tankrider_blowup_delete;
		self.allowdeath = 1;
//		vect = vectornormalize(self.RidingTank.origin-self.origin);
//		angles = vectortoangles(vect);
		angles = self.RidingTank gettagAngles (self.tankride_tag);
		self orientmode ("face angle",angles[1]);
		self traverseMode("gravity");
		self unlink();
		self dodamage( self.health+2000,self.ridingtank.origin);
		
	}
	else
		return;
}

tankrider_blowup_delete()
{
	self delete();
}


WalkWithTank(tank)
{
	for (i=0;i<self.size;i++)
	{
		if ( (isdefined (self[i])) && (isalive (self[i])) )
		{
			if (!isdefined (self[i].FollowMode))
				self[i].FollowMode = "close";
			self[i].WalkingTank = tank;
			if (self[i].FollowMode == "close")
			{
				if (isdefined (self[i].script_startingposition))
				{
					customNum = self[i].script_startingposition;
					assertEX (((customNum >= 0) && (customNum < tank.walk_tags.size)), "script_startingposition must be equal to or greater than 0 and less than " + tank.walk_tags.size);
					self[i].tankmember = customNum;
					tank.walk_tags_used[customNum] = true;
				}
				else
				{
					//take the next open spot
					//---------------------------
					nextAvailable = -1;
					for (posIndex=0;posIndex<tank.walk_tags_used.size;posIndex++)
					{
						if (tank.walk_tags_used[posIndex] == true)
							continue;
						nextAvailable = posIndex;
					}
					
					assertEX (nextAvailable >= 0, "Tank ran out of walking spots. This is usually caused by making more than 6 AI walk with a tank.");
					
					self[i].tankmember = i;
					tank.walk_tags_used[i] = true;
					//---------------------------
				}
				
				//self[i].old_interval = self[i].interval;
				//self[i].interval = 0;
				level thread tankwalker_freespot_ondeath(self[i]);
			}
			self[i] notify ("stop friendly think");
			self[i] tankwalker_updateGoalPos(tank, "once");
			self[i] thread tankwalker_updateGoalPos(tank);
			self[i] thread tankwalker_teamUnderAttack();
		}
	}
}

//Makes guys walking on the right side of a tank shift to the left side
//of the tank until all spots available on the left side are filled up
shiftSides(side)
{
	if (!isdefined (side))
		return;
	if ( (side != "left") && (side != "right") )
	{
		iprintln ("Valid sides are 'left' and 'right' only");
		return;
	}
		
	//find out if this guy is still part of a tank...
	if (!isdefined (self.WalkingTank))
		return;
	
	//see if this guy is already on the requested side...
	if (self.WalkingTank.walk_tags[self.tankmember].side == side)
		return;
	
	//move this guy to the next available spot on the new side of the tank
	for (i=0;i<self.WalkingTank.walk_tags.size;i++)
	{
		if (self.WalkingTank.walk_tags[i].side != side)
			continue;
		if (self.WalkingTank.walk_tags_used[i] == false)
		{
			if (self.WalkingTank getspeedMPH() > 0)
			{
				//tank is moving to make the AI get to the other side by walking behind the tank
				self notify ("stop updating goalpos");
				self setgoalpos (self.WalkingTank.backpos.origin);
				self.WalkingTank.walk_tags_used[self.tankmember] = false;
				self.tankmember = i;
				self.WalkingTank.walk_tags_used[self.tankmember] = true;
				self waittill ("goal");
				self thread tankwalker_updateGoalPos(self.WalkingTank);
			}
			else
				self.tankmember = i;
			return;
		}
		iprintln ("TANKAI: Guy couldn't move to the " + side + " side of the tank because no positions on that side are free");
	}
	
}

tankwalker_freespot_ondeath(guy)
{
	guy waittill ("death");
	if (!isdefined (guy.WalkingTank))
		return;
	guy.WalkingTank.walk_tags_used[guy.tankmember] = false;
}

tankwalker_teamUnderAttack()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("damage", amount, attacker);
		if (!isdefined (attacker))
			continue;
		if ( (!isdefined (attacker.team)) || (attacker != level.player) )
			continue;
		
		if ( (isdefined (self.RidingTank)) && (isdefined (self.RidingTank.allowUnloadIfAttacked)) && (self.RidingTank.allowUnloadIfAttacked == false) )
			continue;
		if ( (isdefined (self.WalkingTank)) && (isdefined (self.WalkingTank.allowUnloadIfAttacked)) && (self.WalkingTank.allowUnloadIfAttacked == false) )
			continue;
		
		self.WalkingTank.teamUnderAttack = true;
		self.WalkingTank notify ("unload");
		return;
	}
}

GetNewNodePositionAheadofTank(guy)
{
	minimumDistance = 300 + (50 * (self getspeedMPH()));
	//get the next node in front of the tank
	nextNode = undefined;
	if (!isdefined (self.CurrentNode.target))
		return self.origin;
	
	nextNode = getVehicleNode(self.CurrentNode.target,"targetname");
	
	if (!isdefined (nextNode))
	{
		if (isdefined (guy.NodeAfterTankWalk))
			return guy.NodeAfterTankWalk.origin;
		else
			return self.origin;
	}
	
	//Is this position far enough from the tank?
	if (distance(self.origin, nextNode.origin) >= minimumDistance)
		return nextNode.origin;
	
	for(;;)
	{
		//Is this position far enough from the tank?
		if (distance(self.origin, nextNode.origin) >= minimumDistance)
			return nextNode.origin;
		if (!isdefined (nextNode.target))
			break;
		nextNode = getVehicleNode(nextNode.target,"targetname");
	}
	
	if (isdefined (guy.NodeAfterTankWalk))
		return guy.NodeAfterTankWalk.origin;
	else
		return self.origin;
}

tankwalker_updateGoalPos(tank, option)
{
	self endon ("death");
	tank endon ("death");
	self endon ("stop updating goalpos");
	self endon ("unload");
	for (;;)
	{
		if (self.FollowMode == "cover nodes")
		{
			self.oldgoalradius = self.goalradius;
			self.goalradius = 300;
			self.walkdist = 64;
			position = tank GetNewNodePositionAheadofTank(self);
		}
		else //followmode = "close"
		{
			self.oldgoalradius = self.goalradius;
			self.goalradius = 2;
			self.walkdist = 64;
			position = tank gettagOrigin(tank.walk_tags[self.tankmember]);
		}
		
		//SETS THE GOAL POSITION ONLY ONCE IF THAT OPTION IS SPECIFIED
		if ( (isdefined (option)) && (option == "once") )
		{
			trace = bulletTrace((position + (0,0,100)), (position - (0,0,500)), false, undefined);
			if (self.FollowMode == "close")
				self teleport (trace["position"]);
			self setGoalPos (trace["position"]);
			return;
		}
		//----------------
		
		
		tankSpeed = tank getspeedmph();
		if (tankSpeed > 0)
		{
			trace = bulletTrace((position + (0,0,100)), (position - (0,0,500)), false, undefined);
			self setGoalPos (trace["position"]);
		}
		
		wait 0.5;
	}
}

NotifyUnloadWait()
{
	self endon ("death");
	self endon ("unloaded");
	
	self waittill ("unload");
	self thread unload();
}


tank_unload_underFire()
{
	self endon ("death");
	while (self.health > 0)
	{
		// Make the front of the tank a place AI will not want to be (make badplace)
		//badplace_arc(name, durration, origin, radius, height, direction, left angle, right angle, team[, other team...]);
		//if (self getspeedMPH() > 0)
		//	badplace_arc("tank_bp" + bpnumber, 1, (self.origin + (0,0,128)), 320, 400, (0.00, 1.00, 0.00), 35, 35, "neutral");
		
		//if (isdefined (self))
		//{
		//	if (self getspeedMPH() > 0)
		//		self disconnectpaths();
		//}
		
		wait 1;
		
		//if the guys moving with the tank become under attack stop the tank until it's safe again
		if ( (isdefined (self.teamUnderAttack)) && (self.teamUnderAttack) )
		{
			//self setSpeed (0, 5);
			while (self getspeedMPH() > 1)
				wait 1;
			self notify ("unload");
		}
	}
}

UpdateLastAngles()
{
	self endon ("death");
	self endon ("unload");
	for (;;)
	{
		self.lastangles = self.angles[1];
		wait 0.5;
		turnStrength = self maps\_vehicle::getTurnStrength();
		if (turnStrength >= 5)
			for (i=0;i<self.riders.size;i++)
				self.riders[i] thread tankrider_animateTurn("right");
		else if (turnStrength <= -5)
			for (i=0;i<self.riders.size;i++)
				self.riders[i] thread tankrider_animateTurn("left");
	}
}

Tank_Activate(tank)
{
	for (i=0;i<6;i++)
	{
		tank.walk_tags[i] = ("tag_walker" + i);
		tank.walk_tags_used[i] = false;
	}
	tank thread tank_unload_underFire();

	if (isdefined (tank.walkers))
		tank.walkers thread WalkWithTank(tank);
	if (isdefined (tank.riders))
	{
		tank thread UpdateLastAngles();
		tank.riders thread RideOnTank(tank);
		
	}
	tank thread NotifyUnloadWait();
	tank thread tank_reaction_wait();
}

