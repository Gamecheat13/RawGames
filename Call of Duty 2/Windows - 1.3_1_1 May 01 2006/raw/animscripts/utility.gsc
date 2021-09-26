#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#using_animtree ("generic_human");

// Every script calls initAnimTree to ensure a clean, fresh, known animtree state.  
// clearanim should never be called directly, and this should never occur other than
// at the start of an animscript
// This function now also does any initialization for the scripts that needs to happen 
// at the beginning of every main script.
initAnimTree(animscript)
{
//	myEntNum = self getEntityNumber();
//	println (myEntNum+" entering "+animscript+" at "+getTime()+" ms.");
	if ( isdefined(self.cliffDeath) && (self.cliffDeath == true) )
		return;
    [[anim.PutGunInHand]]("right"); // Make sure gun is in right hand as default
	if (isAlive(self.anim_personImMeleeing))
	{
		ImNotMeleeing(self.anim_personImMeleeing);
	}
    self clearanim(%body, 0.3);
	self setanim(%body, 0.2);	// The %body node should always have weight 1.
	if (animscript == "pain")
		self.anim_painspecial = self.anim_special;
	else
		self.anim_painspecial = "none";

	self.anim_special = "none";
	self.isHoldingGrenade = false;
	self.missedSightChecks = 0;


    self setanim(%shoot,0.0,0.2,1);

	// Update our combat state based on the script we were in last, the script we're entering now 
	// and if we have an enemy
	UpdateCombatEndTime(self.anim_script, animscript);
	// Remember which script we're in now
	assertEX(isDefined(animscript),"Animscript not specified in initAnimTree");
	self.anim_script = animscript;

	// Call the handler to get out of Cowering pose.
	[[self.anim_StopCowering]]();
}

// UpdateAnimPose does housekeeping at the start of every script's main function.  It does stuff like making prone 
// calculations are only being done if the character is actually prone.
UpdateAnimPose()
{
	assertEX(self.anim_movement=="stop" || self.anim_movement=="walk" || self.anim_movement=="run", "UpdateAnimPose "+self.anim_pose+" "+self.anim_movement);
	
	if (!isdefined(self.desired_anim_pose)) // don't override self.desired_anim_pose
	{
		if ( self.anim_pose == "back" && self.anim_script != "pain" && self.anim_script != "death" )
		{
			//thread [[anim.println]]("Starting a script in pose \"back\"...How does this happen?");#/
			self.desired_anim_pose = "prone";
		}
		else
		{
			self.desired_anim_pose = self.anim_pose;
		}
	}

	if (self.desired_anim_pose == "prone")
	{
		// Make code do the prone orientation to ground
		self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
		self EnterProneWrapper(0.5); 
		
		// NOTE: self.proneok can be checked to tell if it's still ok to be prone where the AI currently is.
	}
	else
	{
		self ExitProneWrapper(0.5); // make code stop lerping in the prone orientation to ground
	}
	self.anim_pose = self.desired_anim_pose;
	self.desired_anim_pose = undefined;
}

// initialize() wraps initAnimTree, UpdateAnimPose, and anim.println calls that used to be called at the start of every
// script's main function. TODO: clean up this stuff
initialize(animscript)
{
	self animscripts\squadmanager::aiUpdateAnimState (animscript);
	self.suppressed = false;
	initAnimTree(animscript);
	UpdateAnimPose();
}

UpdateCombatEndTime(script1name, script2name)
{
	/*
	//thread [[anim.println]]("UpdateCombatEndTime called with \"",script1name,"\" and \"",script2name,"\".  Time: ",GetTime(),".");#/
	sn[0] = script1name;
	if (isDefined(script2name))
		sn[1] = script2name;

	for (i=0 ; i<sn.size ; i++)
	{
		switch (sn[i])
		{
		// These scripts are combat scripts
		case "aim":
		case "combat":
		case "concealment_crouch":
		case "concealment_prone":
		case "concealment_stand":
		case "cover_crouch":
		case "cover_left":
		case "cover_prone":
		case "cover_right":
		case "cover_stand":
		case "cover_wide_left":
		case "cover_wide_right":
		case "reacquire":
		case "shoot":
		case "stalingrad_cover_crouch":
			if ( isAlive (self.enemy) )
			{
			newCombatEndTime = gettime() + anim.combatMemoryTimeConst + randomint(anim.combatMemoryTimeRand);
			if (newCombatEndTime > self.anim_combatEndTime)
			{
				self.anim_combatEndTime = newCombatEndTime;
			}
			return;

		// These scripts are not necessarily combat scripts
		case "death":
		case "hide":
		case "init":
		case "pain":
		case "move":
		case "scripted":
		case "stop":
		case "turret":
		case "grenadecower":
			break;
		default:
			println ("Unhandled scriptname "+sn[i]+" in UpdateCombatEndTime.");
			break;
		}
	}
	*/

	if ( isAlive (self.enemy) )
	{
		newCombatEndTime = gettime() + anim.combatMemoryTimeConst + randomint(anim.combatMemoryTimeRand);
		if (newCombatEndTime > self.anim_combatEndTime)
		{
			self.anim_combatEndTime = newCombatEndTime;
		}
	}
}

lookForBetterCover()
{
	if (forceCreateBadPlaceandMove())
		return;
	tryReacquire();
		
	currentNode = GetClaimedNode();
	if (!isdefined(currentNode))
	{
		interruptPoint();
		return false;
	}
		
//	node = self FindBestCoverNode("better", currentNode);
	node = self FindBestCoverNode("better", currentNode);
	if ( isdefined(node) )
	{
		if (self UseCoverNode(node))
			return true;
	}
	
	interruptPoint();
	return false;
}


badplacer(time, org, radius)
{
	for (i=0;i<time*20;i++)
	{
		for (p=0;p<10;p++)
		{
			angles = (0,randomint(360),0);
			forward = anglestoforward(angles);
			scale = vector_scale(forward, radius);
			line (org, org + scale, (1,0.3,0.3));
		}
		wait(0.05);
	}
}

createBadPlaceandMove()
{
	// false means must be suppressed
	return createBadPlaceandMoveProc(false);
}

forceCreateBadPlaceandMove()
{ 
	// true means ignore suppression
	return createBadPlaceandMoveProc(true);
}

printDisplaceInfo()
{
	self endon ("death");
	self notify ("displaceprint");
	self endon ("displaceprint");
	for (;;)
	{
		print3d (self.origin + (0,0,60), "displacer", (0,0.4,0.7), 0.85, 0.5);
		wait (0.05);
	}
}

createBadPlaceandMoveProc(force)
{
	tryReacquire();

	// create a badplace and force the AI to go to a new goal
	if (self.script_displaceable <= 0) 
		return false;

	/#
	if (getdebugcvar("debug_displace") == "on")
		thread printDisplaceInfo();
	#/
	if (!force)
	{
		if (!self issuppressedWrapper())
			return false;
	}
	
	if (randomint(100) < 50) // dont always displace
		return false;
	if (isalive(self.enemy) && self.enemy != level.player)
	{
		// if your enemy isnt the player then dont displace unless you can see the player
 // dont always displace
 		if (!(randomint(100) < 50 || self cansee(level.player)))
			return false;
	}
		
	if (!isdefined(self.coverNode))
		currentNode = GetClaimedNode();
	else
		currentNode = self.coverNode;
	if (!isdefined(currentNode))
		return false;
		
	node = self FindBestCoverNode("ignore", currentNode);
	if ( isdefined(node) && self UseCoverNode(node))
	{
		/#
		if (getdebugcvar("debug_displace") == "on")
			thread badplacer(1, currentNode.origin, 30);
		#/
		badplace_cylinder("", 1, currentNode.origin, 30, 64, self.team);
		self setgoalnode (node);
		if (isdefined(self.anim_oldgoalradius))
			self.goalradius = self.anim_oldgoalradius;
		self.anim_oldgoalradius = self.goalradius;
		self.goalradius = 32;
		thread getOldRadius();
		if (self.movemode == "run" || self.movemode == "walk")
			animscripts\move::main();
		return true;
	}
	
	return false;
}

/*
tryToFindCover()
{
	if (!isdefined(self.coverNode))
		currentNode = GetClaimedNode();
	else
		currentNode = self.coverNode;
	if (!isdefined(currentNode))
	{
		interruptPoint();
		return;
	}
		
	node = self FindBestCoverNode("ignore", currentNode);
	if ( isdefined(node) )
	{
		if (self UseCoverNode(node))
		{
			thread badplacer(5, self.covernode.origin, 30);
			badplace_cylinder("", 5, self.covernode.origin, 30, 64, self.team);
			self setgoalnode (node);
			if (isdefined(self.anim_oldgoalradius))
				self.goalradius = self.anim_oldgoalradius;
			self.anim_oldgoalradius = self.goalradius;
			self.goalradius = 32;
			thread getOldRadius();
			if (self.movemode == "run" || self.movemode == "walk")
				animscripts\move::main();
			return true;
		}
	}
	
	interruptPoint();
	return false;
}
*/

getOldRadius()
{
	self notify ("newOldradius");
	self endon ("newOldradius");
	self endon ("death");
	wait (6);
	self.goalradius = self.anim_oldgoalradius;
}

// Called from special node behaviors at times when eyes could see enemy
// After X checks are missed the script tells code to bail on special behavior
sightCheckNodeProc(invalidateNode, viewOffset)
{
    if ( !isDefined ( self . missedSightChecks ) )
        self . missedSightChecks = 0;
	if (!isDefined(invalidateNode))
		invalidateNode = 1;

	if (isdefined (viewOffset))
		canShoot = canShootEnemyFrom ( viewOffset );
	else
		canShoot = self canShootEnemy();
		
    if ( !canShoot )
	{
		if ( invalidateNode )
		  self . missedSightChecks++;
	}
    else
        self . missedSightChecks = 0; // make consecutive
    
    if ( self . missedSightChecks > 4 )
    {
		//thread [[anim.println]]("SightCheckNode failed one time too many.  Invalidating current cover node.");#/
		self lookForBetterCover();
        self . missedSightChecks = 0;
    }

	return canShoot;
}

// Called from special node behaviors at times when eyes could see enemy
// After X checks are missed the script tells code to bail on special behavior
sightCheckNode_invalidate(viewOffset)
{
	return sightCheckNodeProc(true, viewOffset);
}

// Called from special node behaviors at times when eyes could see enemy
sightCheckNode(viewOffset)
{
	return sightCheckNodeProc(false, viewOffset);
}





// Returns whether or not the character should be acting like he's under fire or expecting an enemy to appear 
// any second.
IsInCombat()
{
	if ( isDefined (self.enemy) )
	{
		newCombatEndTime = gettime() + anim.combatMemoryTimeConst + randomint(anim.combatMemoryTimeRand);
		if (newCombatEndTime > self.anim_combatEndTime)
		{
			self.anim_combatEndTime = newCombatEndTime;
		}
	}
	return ( self.anim_combatEndTime > gettime() );
}


/#
DebugIsInCombat()
{
	return ( self.anim_combatEndTime > gettime() );
}
#/


hasWeapon()
{
	if (self.anim_gunhand == "none")
		return (false);
		
	if (!isdefined (self.hasWeapon))
		return (true);
		
	return (self.hasWeapon);
}


// Takes a pose ("stand", "crouch", "prone") and an optional offset in local space, [forward, right, up].
canShootEnemyFromPose ( pose, offset, useSightCheck )
{
	if (self.weapon=="mg42")
		return false;
		
	switch (pose)
	{
	case "stand":
		// First off, AI can't fire the panzerfaust at all if they're standing.
		if (self.weapon=="panzerfaust")
			return false;

		if (self.anim_pose == "stand")
			poseOffset = (0,0,0);
		else if (self.anim_pose == "crouch")
			poseOffset = (0,0,20);
		else if (self.anim_pose == "prone")
			poseOffset = (0,0,55);
		else
		{
			assertEX(0, "init::canShootEnemyFromPose "+self.anim_pose);
			poseOffset = (0,0,0);
		}
		break;
    
	case "crouch":
		if (self.anim_pose == "stand")
			poseOffset = (0,0,-20);
		else if (self.anim_pose == "crouch")
			poseOffset = (0,0,0);
		else if (self.anim_pose == "prone")
			poseOffset = (0,0,35);
		else
		{
			assertEX(0, "init::canShootEnemyFromPose "+self.anim_pose);
			poseOffset = (0,0,0);
		}
		break;

	case "prone":
		if (self.anim_pose == "stand")
			poseOffset = (0,0,-55);
		else if (self.anim_pose == "crouch")
			poseOffset = (0,0,-35);
		else if (self.anim_pose == "prone")
			poseOffset = (0,0,0);
		else
		{
			assertEX(0, "init::canShootEnemyFromPose "+self.anim_pose);
			poseOffset = (0,0,0);
		}
		break;

	default:
		assertEX(0, "init::canShootEnemyFromPose - bad supplied pose: "+pose);
		poseOffset = (0,0,0);
		break;
	}

	if (isDefined(offset))
	{
		poseOffset = poseOffset + self LocalToWorldCoords(offset) - self.origin;
	}

	return canShootEnemyFrom ( poseOffset, undefined, useSightCheck );
}

// Checks multiple points on the enemy, to see if I can shoot any of them.  Check that I can see my enemy 
// too, since canshoot checks from the gun barrel and the gun barrel is often through a wall.  UseSightCheck 
// is optional, defaults to true.
canShootEnemy (posOverrideEntity, useSightCheck)
{
	return canShootEnemyFrom ( (0,0,0), posOverrideEntity, useSightCheck );
}

canShootEnemyPos ( posOverrideOrigin )
{
	return canShootEnemyFrom ( (0,0,0), undefined, true, posOverrideOrigin );	// posOverrideEntity is optional, specifies a substitute enemy.
}

canShootEnemyFrom ( offset, posOverrideEntity, useSightCheck, posOverrideOrigin )	// posOverrideEntity is optional, specifies a substitute enemy.
																// useSightCheck is optional, defaults to true.
{
	if ( !isalive(self.enemy) && !isDefined(posOverrideEntity) )
 		return false;
	if (!hasWeapon())
		return false;

	if (isDefined(posOverrideEntity))
	{
		if (isSentient(posOverrideEntity))
		{
			eye = posOverrideEntity GetEye();
			chest = eye + ( 0,0,-20);
		}
		else
		{
			eye = posOverrideEntity.origin;
			chest = eye;
		}
	}
	else
	if (isdefined(posOverrideOrigin))
	{
		eye = posOverrideOrigin;
		chest = eye + ( 0,0,-20);
	}
	else
	{
		eye = GetEnemyEyePos();
		chest = eye + ( 0,0,-20);
	}

	myGunPos = self GetTagOrigin ("tag_flash");
	if (!isDefined(useSightCheck))
		useSightCheck = true;
	if (useSightCheck)
	{
		// "Proper" way (doesn't work because CanSee cannot be called on a vector or with a vector as a parameter)
		//myEye = self GetEye();
		//myEye = myEye + offset;
		//canSee = myEye CanSee(self.enemy);
		// Simple way (not thorough enough for all cases)
		//canSee = self CanSee(self.enemy);
		// Hack way, using canShoot and adding the offset from muzzle to eye.
		myEyeOffset = ( self GetEye() - myGunPos );
		canSee = self canshoot( eye, myEyeOffset+offset );
		// Draw a debug line to my enemy's eye (or just above it, so that the player can see it if the enemy is him).
		/#
		if (canSee)
		{
			if (getdebugcvarint("anim_dotshow") == self getentnum())
			if (getdebugcvar ("anim_debug") == "3")
				thread showDebugLine(myGunPos + myEyeOffset + offset, eye + (0,0,2), (.5,1,.5), 5);
		}
		else
		{
			if (getdebugcvarint("anim_dotshow") == self getentnum())
			if (getdebugcvar ("anim_debug") == "3")
				thread showDebugLine(myGunPos + myEyeOffset + offset, eye + (0,0,2), (1,.5,.5), 5);
		}
		#/
	}
	else
		canSee = true;

	if (!canSee)
		return false;

	canShoot = self canshoot( eye, offset ) || self canshoot( chest, offset );

	/#
	if (canShoot)
	{
		if (getdebugcvarint("anim_dotshow") == self getentnum())
		if (getdebugcvar ("anim_debug") == "3")
			thread showDebugLine(myGunPos + offset + (0,0,2), eye + (0,0,4), (.5,1,.5), 5);
	}
	else
	{
		if (getdebugcvarint("anim_dotshow") == self getentnum())
		if (getdebugcvar ("anim_debug") == "3")
			thread showDebugLine(myGunPos + offset + (0,0,2), eye + (0,0,4), (1,.5,.5), 5);
	}
	#/

	return ( canShoot );
}


GetEnemyEyePos()
{
    if ( isDefined ( self.enemy ) )
	{
		self.anim_lastEnemyPos = self.enemy GetEye();
		self.anim_lastEnemyTime = gettime();
		return self.anim_lastEnemyPos;
	}
	else if ( 
			(isDefined ( self.anim_lastEnemyTime )) && 
			(isDefined ( self.anim_lastEnemyPos )) && 
			(self.anim_lastEnemyTime + 3000 < gettime()) 
			)
	{
		return self.anim_lastEnemyPos;
	}
	else
	{
		// Return a point in front of you.  Note that the distance to this point is significant, because 
		// this function is used to determine an appropriate attack stance. 16 feet (196 units) seems good...
		targetPos = self GetEye();
		targetPos = targetPos + (196*self.lookforward[0], 196*self.lookforward[1], 196*self.lookforward[2]);
		return targetPos;
	}
}

GetNodeYawToOrigin(pos)
{
	if (isdefined (self.node))
		yaw = self.node.angles[1] - GetYaw(pos);
	else
		yaw = self.angles[1] - GetYaw(pos);
	
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;
}

GetNodeYawToEnemy()
{
	pos = undefined;
	if (isalive(self.enemy))
		pos = self.enemy.origin;
	else
	{
		if (isdefined (self.node))
			forward = anglestoforward(self.node.angles);
		else
			forward = anglestoforward(self.angles);
		forward = vector_scale (forward, 150);
		pos = self.origin + forward;
	}
	
	if (isdefined (self.node))
		yaw = self.node.angles[1] - GetYaw(pos);
	else
		yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;
}

GetCoverNodeYawToEnemy()
{
	pos = undefined;
	if (isalive(self.enemy))
		pos = self.enemy.origin;
	else
	{
		forward = anglestoforward(self.coverNode.angles + self.animarray["angle_step_out"][self.anim_cornerMode]);
		forward = vector_scale (forward, 150);
		pos = self.origin + forward;
	}
	
	yaw = self.CoverNode.angles[1] + self.animarray["angle_step_out"][self.anim_cornerMode] - GetYaw(pos);
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;

/*	
    if ( isDefined ( self.enemy ) )
    {
		enemyPos = GetEnemyEyePos();
		angles = VectorToAngles(enemyPos-self.origin);
		return (self.angles[1] - angles[1]);
	}
	return self.angles[1];
*/	
}

GetYawToEnemy()
{
	pos = undefined;
	if (isalive(self.enemy))
		pos = self.enemy.origin;
	else
	{
		forward = anglestoforward(self.angles);
		forward = vector_scale (forward, 150);
		pos = self.origin + forward;
	}
	
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;

/*	
    if ( isDefined ( self.enemy ) )
    {
		enemyPos = GetEnemyEyePos();
		angles = VectorToAngles(enemyPos-self.origin);
		return (self.angles[1] - angles[1]);
	}
	return self.angles[1];
*/	
}

GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}

GetYaw2d(org)
{
	angles = VectorToAngles((org[0], org[1], 0)-(self.origin[0], self.origin[1], 0));
	return angles[1];
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy()
{
	assert (isalive(self.enemy));
	yaw = self.angles[1] - GetYaw(self.enemy.origin);
	yaw = AngleClamp(yaw, "-180 to 180");
	if (yaw<0)
		yaw = -1 * yaw;
	return yaw;
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy2d()
{
	assert (isalive(self.enemy));
	yaw = self.angles[1] - GetYaw2d(self.enemy.origin);
	yaw = AngleClamp(yaw, "-180 to 180");
	if (yaw<0)
		yaw = -1 * yaw;
	return yaw;
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToOrigin(org)
{
	yaw = self.angles[1] - GetYaw(org);
	yaw = AngleClamp(yaw, "-180 to 180");
	if (yaw<0)
		yaw = -1 * yaw;
	return yaw;
}

AbsYawToAngles(angles)
{
	yaw = self.angles[1] - angles;
	yaw = AngleClamp(yaw, "-180 to 180");
	if (yaw<0)
		yaw = -1 * yaw;
	return yaw;
}

GetYawFromOrigin(org, start)
{
	angles = VectorToAngles(org-start);
	return angles[1];
}

GetYawToTag(tag, org)
{
	yaw = self gettagangles( tag )[1] - GetYawFromOrigin(org, self gettagorigin(tag));
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;
}

GetYawToOrigin(org)
{
	yaw = self.angles[1] - GetYaw(org);
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;
}

GetEyeYawToOrigin(org)
{
	yaw = self gettagangles("TAG_EYE")[1] - GetYaw(org);
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;
}

GetCoverNodeYawToOrigin(org)
{
	yaw = self.coverNode.angles[1] + self.animarray["angle_step_out"][self.anim_cornerMode] - GetYaw(org);
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;
}



choosePose(preferredPose)
{
	if (!isDefined(preferredPose))
	{
		preferredPose = self.anim_pose;
	}
	if (EnemiesWithinStandingRange())
	{
		preferredPose = "stand";
	}
	
	// Find out if we should be standing, crouched or prone
	switch (preferredPose)
	{
	case "stand":
		if (self isStanceAllowed("stand"))
		{
			resultPose = "stand";
		}
		else if (self isStanceAllowed("crouch"))
		{
			resultPose = "crouch";
		}
		else if (self isStanceAllowed("prone"))
		{
			resultPose = "prone";
		}
		else
		{
			println ("No stance allowed!  Remaining standing.");
			resultPose = "stand";
		}
		break;

	case "crouch":
		if (self isStanceAllowed("crouch"))
		{
			resultPose = "crouch";
		}
		else if (self isStanceAllowed("stand"))
		{
			resultPose = "stand";
		}
		else if (self isStanceAllowed("prone"))
		{
			resultPose = "prone";
		}
		else
		{
			println ("No stance allowed!  Remaining crouched.");
			resultPose = "crouch";
		}
		break;

	case "prone":
		if (self isStanceAllowed("prone"))
		{
			resultPose = "prone";
		}
		else if (self isStanceAllowed("crouch"))
		{
			resultPose = "crouch";
		}
		else if (self isStanceAllowed("stand"))
		{
			resultPose = "stand";
		}
		else
		{
			println ("No stance allowed!  Remaining prone.");
			resultPose = "prone";
		}
		break;

	default:
		println ("utility::choosePose, called in "+self.anim_script+" script: Unhandled anim_pose "+self.anim_pose+" - using stand.");
		resultPose = "stand";
		break;
	}
	return resultPose;
}

// Melee stuff.  Note that isAlive is better than isDefined when you're checking variables that are either 
// undefined or set to an AI.
okToMelee(person)
{
	assert(isDefined(person));
	if (isDefined(self.anim_personImMeleeing))		// Tried to melee someone else when I am already meleeing, possibly because code changed my enemy.
	{
		ImNotMeleeing(self.anim_personImMeleeing);
		assert(!isDefined(self.anim_personImMeleeing));
	}
	if (isDefined(person.anim_personMeleeingMe))
	{
		// This means that oldAttacker was the last person to melee person.  He may or may not still be meleeing him.
		oldAttacker = person.anim_personMeleeingMe;
		if ( isDefined(oldAttacker.anim_personImMeleeing) && oldAttacker.anim_personImMeleeing == person )
		{
			// This means that oldAttacker is currently meleeing person.
			return false;
		}
		println("okToMelee - Shouldn't get to here");
		// This means that oldAttacker is no longer meleeing person and somehow person was never informed.  We can still handle it though.
		person.anim_personMeleeingMe = undefined;
		assert(!isDefined(self.anim_personImMeleeing));
		assert(!isDefined(person.anim_personMeleeingMe));
		return true;
	}
	assert(!isDefined(self.anim_personImMeleeing));
	assert(!isDefined(person.anim_personMeleeingMe));
	return true;
}

IAmMeleeing(person)
{
	assert(isDefined(person));
	assert(!isDefined(person.anim_personMeleeingMe));
	assert(!isDefined(self.anim_personImMeleeing));
	person.anim_personMeleeingMe = self;
	self.anim_personImMeleeing = person;
}

ImNotMeleeing(person)
{
	// First check that everything is in synch, just for my own peace of mind.  This can go away once there are no bugs.
	if ( (isDefined(person)) && (isDefined(self.anim_personImMeleeing)) && (self.anim_personImMeleeing==person) )
	{
		assert(isDefined(person.anim_personMeleeingMe));
		assert(person.anim_personMeleeingMe == self);
	}
	// This function does not require that I was meleeing Person to start with.  
	if (!isDefined(person))
	{
		self.anim_personImMeleeing = undefined;
	}
	else if ( (isDefined(person.anim_personMeleeingMe)) && (person.anim_personMeleeingMe==self) )
	{
		person.anim_personMeleeingMe = undefined;
		assert(self.anim_personImMeleeing==person);
		self.anim_personImMeleeing = undefined;
	}
	// A final check that I got this right...
	assert( !isDefined(person) || !isDefined(self.anim_personImMeleeing) || (self.anim_personImMeleeing!=person) );
	assert( !isDefined(person) || !isDefined(person.anim_personMeleeingMe) || (person.anim_personMeleeingMe!=self) );
}

WeaponAnims()
{
	weaponModel = getWeaponModel(self.weapon);
	if ( (isDefined(self.hasWeapon) && !self.hasWeapon) || weaponModel=="" )
		return "none";
	else
		return getAIWeapon(self.weapon)["anims"];
}

GetPlayer()
{
	if (!isDefined(anim.player))
		anim.player = getent("player", "classname" );

	return anim.player;
}

GetClaimedNode()
{
	myNode = self.node;
	if (isdefined(myNode) && self nearNode(myNode))
		return myNode;
	return undefined;
}

GetNodeType()
{
	myNode = GetClaimedNode();
	if (isDefined(myNode))
		return myNode.type;
	return "none";
}

GetNodeDirection()
{
	myNode = GetClaimedNode();
	if (isdefined(myNode))
	{
		//thread [[anim.println]]("GetNodeDirection found node, returned: "+myNode.angles[1]);#/
		return myNode.angles[1];
	}
	//thread [[anim.println]]("GetNodeDirection didn't find node, returned: "+self.desiredAngle);#/
	return self.desiredAngle;
}

GetNodeForward()
{
	myNode = GetClaimedNode();
	if (isdefined(myNode))
		return AnglesToForward ( myNode.angles );
	return AnglesToForward( self.angles );
}

GetNodeOrigin()
{
	myNode = GetClaimedNode();
	if (isdefined(myNode))
		return myNode.origin;
	return self.origin;
}

/#
isDebugOn()
{
	return ( (getdebugcvarint("animDebug") == 1) || ( isDefined (anim.debugEnt) && anim.debugEnt == self ) );
}

drawDebugLineInternal(fromPoint, toPoint, color, durationFrames)
{
	//println ("Drawing line, color "+color[0]+","+color[1]+","+color[2]);
	//player = getent("player", "classname" );
	//println ( "Point1 : "+fromPoint+", Point2: "+toPoint+", player: "+player.origin );
	for (i=0;i<durationFrames;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}

drawDebugLine(fromPoint, toPoint, color, durationFrames)
{
	if (isDebugOn())
		thread drawDebugLineInternal(fromPoint, toPoint, color, durationFrames);
}

debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}

drawDebugCross(atPoint, radius, color, durationFrames)
{
	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debugLine(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debugLine(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debugLine(atPoint_forward,	atPoint_back,	color, durationFrames);
}

drawDebugCrossOld(atPoint, radius, color, durationFrames)
{
	if (thread isDebugOn())
	{
		atPoint_high =		atPoint + (		0,			0,		   radius	);
		atPoint_low =		atPoint + (		0,			0,		-1*radius	);
		atPoint_left =		atPoint + (		0,		   radius,		0		);
		atPoint_right =		atPoint + (		0,		-1*radius,		0		);
		atPoint_forward =	atPoint + (   radius,		0,			0		);
		atPoint_back =		atPoint + (-1*radius,		0,			0		);
		thread animscripts\utility::drawDebugLine(atPoint_high,	atPoint_low,	color, durationFrames);
		thread animscripts\utility::drawDebugLine(atPoint_left,	atPoint_right,	color, durationFrames);
		thread animscripts\utility::drawDebugLine(atPoint_forward,	atPoint_back,	color, durationFrames);
	}
}

UpdateDebugInfoInternal()
{
	if ( isDefined (anim.debugEnt) && (anim.debugEnt==self) )
		doInfo = true;
	else
		doInfo = getDebugCvarInt ("animscriptinfo");

	if (doInfo)
	{
		thread drawDebugInfoThread();
	}
	else
	{
		self notify ("EndDebugInfo");
	}
}

UpdateDebugInfo()
{
	self endon("death");
    for (;;)
    {
		thread UpdateDebugInfoInternal();
		wait 1;
    }
}


drawDebugInfoThread()
{
	self endon("EndDebugInfo");
	self endon("death");
	
	for(;;)
	{
		self thread drawDebugInfo();
		wait 0.05;
	}
}

drawDebugInfo()
{
	// What do we want to print?
	line[0]  = self getEntityNumber()+" "+self.anim_script;
	line[1]  = self.anim_pose+" "+self.anim_movement;
	line[2]  = self.anim_alertness+" "+self.anim_special;
	if (self thread DebugIsInCombat())
		line[3]  = "in combat for "+(self.anim_combatEndTime - gettime())+" ms.";
	else
		line[3]  = "not in combat";
	line[4]  = self.anim_lastDebugPrint1;

	belowFeet = self.origin + (0,0,-8);	
	//aboveHead = self GetEye() + (0,0,8);
	offset = (0,0,-10);
	for (i=0 ; i<line.size ; i++)
	{
		if (isDefined(line[i]))
		{
			textPos = ( belowFeet[0]+(offset[0]*i), belowFeet[1]+(offset[1]*i), belowFeet[2]+(offset[2]*i) );
			print3d (textPos, line[i], (.2, .2, 1), 1, 0.75);	// origin, text, RGB, alpha, scale
		}
	}
}
#/

// Gives the result as an angle between 0 and 360, or -180 and 180 if "-180 to 180" is specified.
AngleClamp(angle, resultType)
{
	/*
	Here are some modulus results from in-game:
	10 % 3 = 1
	10 % -3 = 1
	-10 % 3 = -1
	-10 % -3 = -1
	*/
	angle = int(angle) % 360;
	angle += 360;
	angle = int(angle) % 360;
	if ( isDefined(resultType) && (resultType == "-180 to 180") )
	{
		if (angle>180)
			angle -= 360;
	}
	return angle;
}

// Returns an array of 4 weights (2 of which are guaranteed to be 0), which should be applied to forward, 
// right, back and left animations to get the angle specified.
//           front
//        /----|----\
//       /    180    \
//      /\     |     /\
//     / -135  |  135  \
//     |     \ | /     |
// left|-90----+----90-|right
//     |     / | \     |
//     \  -45  |  45   /
//      \/     |     \/
//       \     0     / 
//        \----|----/
//           back

QuadrantAnimWeights (yaw)
{
	yaw = AngleClamp(yaw, "-180 to 180");

	weight1 = cos (yaw);
	weight2 = sin (yaw);

	result["front"]	= 0;
	result["right"]	= 0;
	result["back"]	= 0;
	result["left"]	= 0;

	if (weight1 > 0)
		result["back"] = weight1;
	else
		result["front"] = -1 * weight1;

	if (weight2 > 0)
		result["right"] = weight2;
	else
		result["left"] = -1 * weight2;

	return result;
}

getQuadrant(angle)
{
	angle = AngleClamp(angle);

	if (angle<45 || angle>315)
	{
		quadrant = "front";
	}
	else if (angle<135)
	{
		quadrant = "left";
	}
	else if (angle<225)
	{
		quadrant = "back";
	}
	else
	{
		quadrant = "right";
	}
	return quadrant;
}


// Checks to see if the input is equal to any of up to ten other inputs.
IsInSet(input, set)
{
	for (i = set.size - 1; i >= 0; i--)
	{
		if (input == set[i])
			return true;
	}
	return false;
}

/*
// Function to display anims in sequence.  Currently used to display corner anims.
MilestoneAnims()
{
	milestoneanims = getCvarInt ("milestoneanims");
	if(milestoneanims == 0)
		return;
	for (;;)
	{
		self clearanim(%root, 0);
		self setanim(%root, 1);
		self waittill ("trigger");
		milestoneanims = getCvarInt ("milestoneanims");
		if(milestoneanims == 0)
			break;

		// Left
		if ( milestoneanims == 1 )
		{
			println ("Playing Corner Stand Left Pistol (ie cover_right) animations");
			animarray = animscripts\cover_right::Anims_StandingPistol();
		}
		else if ( milestoneanims == 2 )
		{
			println ("Playing Corner Stand Left Rifle A (ie cover_right) animations");
			animarray = animscripts\cover_right::Anims_StandingRifleA();
		}
		else if ( milestoneanims == 3 )
		{
			println ("Playing Corner Stand Left Rifle B (ie cover_right) animations");
			animarray = animscripts\cover_right::Anims_StandingRifleB();
		}
		else if ( milestoneanims == 4 )
		{
			println ("Playing Corner Crouch Left Panzerfaust (ie cover_right) animations");
			animarray = animscripts\cover_right::Anims_CrouchingPanzerfaust();
		}
		else if ( milestoneanims == 5 )
		{
			println ("Playing Corner Crouch Left Pistol (ie cover_right) animations");
			animarray = animscripts\cover_right::Anims_CrouchingPistol();
		}
		else if ( milestoneanims == 6 )
		{
			println ("Playing Corner Crouch Left Rifle A (ie cover_right) animations");
			animarray = animscripts\cover_right::Anims_CrouchingRifleA();
		}
		else if ( milestoneanims == 7 )
		{
			println ("Playing Corner Crouch Left Rifle B (ie cover_right) animations");
			animarray = animscripts\cover_right::Anims_CrouchingRifleB();
		}
		// Right
		else if ( milestoneanims == 8 )
		{
			println ("Playing Corner Stand Right Pistol (ie cover_left) animations");
			animarray = animscripts\cover_left::Anims_StandingPistol();
			[[anim.putguninhand]]("left");
		}
		else if ( milestoneanims == 9 )
		{
			println ("Playing Corner Stand Right Rifle A (ie cover_left) animations");
			animarray = animscripts\cover_left::Anims_StandingRifleA();
			[[anim.putguninhand]]("left");
		}
		else if ( milestoneanims == 10 )
		{
			println ("Playing Corner Stand Right Rifle B (ie cover_left) animations");
			animarray = animscripts\cover_left::Anims_StandingRifleB();
			[[anim.putguninhand]]("left");
		}
		else if ( milestoneanims == 11 )
		{
			println ("Playing Corner Crouch Right Panzerfaust (ie cover_left) animations");
			animarray = animscripts\cover_left::Anims_CrouchingPanzerfaust();
			[[anim.putguninhand]]("left");
		}
		else if ( milestoneanims == 12 )
		{
			println ("Playing Corner Crouch Right Pistol (ie cover_left) animations");
			animarray = animscripts\cover_left::Anims_CrouchingPistol();
			[[anim.putguninhand]]("left");
		}
		else if ( milestoneanims == 13 )
		{
			println ("Playing Corner Crouch Right Rifle A (ie cover_left) animations");
			animarray = animscripts\cover_left::Anims_CrouchingRifleA();
			[[anim.putguninhand]]("left");
		}
		else if ( milestoneanims == 14 )
		{
			println ("Playing Corner Crouch Right Rifle B (ie cover_left) animations");
			animarray = animscripts\cover_left::Anims_CrouchingRifleB();
			[[anim.putguninhand]]("left");
		}
		else
		{
			break;
		}


		if ( isDefined(animarray["run2alert"]) )
			playAnim ( animarray["run2alert"] );	

		playAnim ( animarray["anim_alert"] );	
		playAnim ( animarray["anim_look"] );	

		playAnim ( animarray["anim_alert2rambo"] );	
		playAnim ( animarray["anim_rambo2alert"] );	

		playAnim ( animarray["anim_alert2aim"]["left"] );	
		playAnim ( animarray["anim_aim"]["left"] );	
		if ( isDefined(animarray["anim_autofire"]) )
			playAnim ( animarray["anim_autofire"]["left"] );	
		playAnim ( animarray["anim_semiautofire"]["left"] );	
		playAnim ( animarray["anim_boltfire"]["left"] );	
		playAnim ( animarray["anim_aim2alert"]["left"] );	

		playAnim ( animarray["anim_alert2aim"]["middle"] );	
		playAnim ( animarray["anim_aim"]["middle"] );	
		if ( isDefined(animarray["anim_autofire"]) )
			playAnim ( animarray["anim_autofire"]["middle"] );	
		playAnim ( animarray["anim_semiautofire"]["middle"] );	
		playAnim ( animarray["anim_boltfire"]["middle"] );	
		playAnim ( animarray["anim_aim2alert"]["middle"] );	

		playAnim ( animarray["anim_alert2aim"]["right"] );	
		playAnim ( animarray["anim_aim"]["right"] );	
		if ( isDefined(animarray["anim_autofire"]) )
			playAnim ( animarray["anim_autofire"]["right"] );	
		playAnim ( animarray["anim_semiautofire"]["right"] );	
		playAnim ( animarray["anim_boltfire"]["right"] );	
		playAnim ( animarray["anim_aim2alert"]["right"] );

		oldHand = self.anim_gunHand;
		if ( isDefined(animarray["anim_reload"]) )
		{
			//[[anim.putguninhand]]("left");
			playAnim ( animarray["anim_reload"] );	
			println("Finished reload, putting gun back into ",oldHand," hand.");
			[[anim.putguninhand]](oldHand);
		}
		if ( isDefined(animarray["anim_grenade"]) )
		{
			//[[anim.putguninhand]](animarray["gunhand_grenade"]);
			armpos = self LocalToWorldCoords(animarray["offset_grenade"]);
/#
			thread animscripts\utility::drawDebugCross(armpos, 8, (0,1,0), 20);
#/
			playAnim ( animarray["anim_grenade"] );	
			println("Finished grenade, putting gun back into ",oldHand," hand.");
			[[anim.putguninhand]](oldHand);
		}
	}
}
*/

playAnim(animation)
{
	if (isDefined(animation))
	{
		//self thread drawString(animation);	// Doesn't work for animations, only strings.
		println ("NOW PLAYING: ",animation);
		self setFlaggedAnimKnobAllRestart("playAnim", animation, %root, 1, .1, 1);
		timeToWait = getanimlength(animation);
		timeToWait = ( 3 * timeToWait ) + 1;	// So looping animations play through 3 times.
		self thread PrintNoteTracks("playAnim", "time is up", "time is up");
		self thread NotifyAfterTime("time is up", "time is up", timeToWait);
		self waittill ("time is up");
		self notify("enddrawstring");
	}
}
PrintNoteTracks(animName, notifyString, killmestring)
{
	self endon(killmestring);
	numEnds = 0;
	for (;;)
	{
		self waittill (animName, note);
		println ("Note: ",note);
		if ( note == "anim_gunhand = \"left\"" )
			[[anim.PutGunInHand]]("left");
		else if ( note == "anim_gunhand = \"right\"" )
			[[anim.PutGunInHand]]("right");
		else if ( note == "anim_gunhand = \"none\"" )
			[[anim.PutGunInHand]]("none");
		else if (note=="end")
		{
			// In order to see looping animations properly, we wait until we get 3 "end" notes.  This means 
			// normal anims pause for 0.1 seconds, while looping anims play three times.
			numEnds += 1;
			if (numEnds >= 3)
				break;
		}
	}
	self notify (notifyString);
}
NotifyAfterTime(notifyString, killmestring, time)
{
	self endon("death");
	self endon(killmestring);
	wait time;
	self notify (notifyString);
}

// Utility function, made for MilestoneAnims(), which displays a string until killed.
drawString(stringtodraw)
{
	self endon("killanimscript");
	self endon("enddrawstring");
	for (;;)
	{
		wait .05;
		print3d ((self GetDebugEye()) + (0,0,8), stringtodraw, (1, 1, 1), 1, 0.2);
	}
}

drawStringTime(msg, org, color, timer)
{
	maxtime = timer*20;
	for (i=0;i<maxtime;i++)
	{
		print3d (org, msg, color, 1, 1);
		wait .05;
	}
}



randomVec( dist )
{
	vec = (randomfloat(dist*2)-dist, randomfloat(dist*2)-dist, randomfloat(dist*2)-dist);
	return vec;
}


showLastEnemySightPos(string)
{
	self notify ("got known enemy2");
	self endon ("got known enemy2");
	self endon ("death");
	if (!isalive (self.enemy))
		return;
		
	if (self.enemy.team == "allies")
		color = (0.4, 0.7, 1);
	else
		color = (1, 0.7, 0.4);
		
	while (1)
	{
		wait (0.05);
		if (!isdefined (self.lastEnemySightPos))
			continue;
			
		print3d (self.lastEnemySightPos, string, color, 1, 2.15);	// origin, text, RGB, alpha, scale
	}
}

/#
printDebugTextProc (string, org, printTime, color)
{
	level notify ("stop debug print " + org);
	level endon ("stop debug print " + org);

	if (!isdefined (color))
		color = (0.3,0.9,0.6);
		
	timer = printTime*20;
	for (i=0;i<timer;i+=1)
	{
		wait (0.05);
		print3d (org, string, color, 1, 1);	// origin, text, RGB, alpha, scale
	}
}

printDebugText (string, org, printTime, color)
{
	if (getdebugcvar ("anim_debug") != "")
		level thread printDebugTextProc(string, org, printTime, color);
}
#/

hasEnemySightPos()
{
	if (isdefined(self.node))
		return (canSeeEnemyFromExposed() || canSuppressEnemyFromExposed());
	else
		return (canSeeEnemy() || canSuppressEnemy());
}

getEnemySightPos()
{
	assert (self.goodShootPosValid);
	return self.goodShootPos;
}

tryTurret (targetname)
{
   	turret = getent (targetname, "targetname");
   	if (!isdefined (turret))
   		return false;

	if ((turret.classname != "misc_mg42") && (turret.classname != "misc_turret"))
		return false;

	if ( !self isingoal(self.covernode.origin))
		return false;

	canuse = self useturret(turret); // dude should be near the mg42
	if ( canuse )
	{
		turret setmode("auto_ai"); // auto, auto_ai, manual
		self thread maps\_mg42::mg42_firing(turret);
		turret notify ("startfiring");
		return true;
	}
	else
	{
		return false;
	}
}

util_ignoreCurrentSightPos()
{
	if (!hasEnemySightPos())
		return;
		
	self.ignoreSightPos = getEnemySightPos();
	self.ignoreOrigin = self.origin;
}

canShootPos(pos)
{
	myGunPos = self GetTagOrigin ("tag_flash");
	myEyeOffset = ( self GetEye() - myGunPos );
	return (self canshoot( pos, myEyeOffset ));
}

util_evaluateKnownEnemyLocation()
{
	if (!hasEnemySightPos())
		return false;
	myGunPos = self GetTagOrigin ("tag_flash");
	myEyeOffset = ( self GetEye() - myGunPos );

	if ((isdefined (self.ignoreSightPos)) && (isdefined (self.ignoreOrigin)))
	{
		// Ignore the current last sight pos if you've previously invalidated it from this position
		if (distance (self.origin, self.ignoreOrigin) < 25)
			return false;
	}
	
	self.ignoreSightPos = undefined;

	canSee = self canshoot( getEnemySightPos(), myEyeOffset );
	if (!canSee)
	{
		self.ignoreSightPos = getEnemySightPos();
//		self.lastEnemySightPos = undefined;
/*
		/#
			if (getdebugcvar ("anim_debug") == "1")
				thread showLastEnemySightPos("*");
		#/
		*/

		return false;
	}

/*
	/#
		if (getdebugcvar ("anim_debug") == "1")
			thread showLastEnemySightPos("X");
	#/
	*/
	
	return true;

	/*
	canSee = self canshoot( self.knownEnemyLocation, myEyeOffset );
	if (!canSee)
	{
		if (isdefined (self.oldknownEnemyLocation))
		{
			myGunPos = self GetTagOrigin ("tag_flash");
			myEyeOffset = ( self GetEye() - myGunPos );
			canSee = self canshoot( self.oldknownEnemyLocation, myEyeOffset );
			if (canSee)
			{
				self.knownEnemyLocation = self.oldknownEnemyLocation;
				model = undefined;
				/#
				if (!isdefined (self.knownEnemyLocationModel))
				{
					if (getdebugcvar ("anim_debug") != "")
					{
						if (isdefined (self.knownEnemyLocationModel))
							self.knownEnemyLocationModel delete();
							
						model = spawn ("script_model",(9,9,3));
						model setmodel ("xmodel/temp");
						model.origin = self.knownEnemyLocation;
						self.knownEnemyLocationModel = model;
						self thread getKnownEnemyLocationCleanup(model);
					}
				}
				#/	
			}
		}
		else
			self.oldknownEnemyLocation = self.knownEnemyLocation;
			
		if (canSee)
			return;
			
		self.knownEnemyLocation = undefined;
		self notify ("got known enemy");
		self notify ("stop get known enemy cleanup");
		/#
		if (getdebugcvar ("anim_debug") != "")
			self.knownEnemyLocationModel delete();
		#/	
	}
	*/
}
/*

getKnownEnemyLocation()
{
	self thread getKnownEnemyLocationProc();
}

getKnownEnemyLocationProc()
{
	if (!isalive (self.enemy))
		return;

	self notify ("got known enemy");
	self endon ("got known enemy");
	self.knownEnemyLocation = GetEnemyEyePos(); // self.enemy.origin;
	model = undefined;
	
/#
	if (getdebugcvar ("anim_debug") == "1")
	{
		model = spawn ("script_model",(9,9,3));
		model setmodel ("xmodel/temp");
		model.origin = self.knownEnemyLocation;
		if (isdefined (self.knownEnemyLocationModel))
			self.knownEnemyLocationModel delete();
		self.knownEnemyLocationModel = model;
		self thread getKnownEnemyLocationCleanup(model);
	}
#/	
	
	self endon("death");	
	self.enemy waittill ("death");
	wait (5);
/#
	if (isdefined(model))
		model delete();
#/
	self.knownEnemyLocation = undefined;
}

/#
getKnownEnemyLocationCleanup(model)
{
	assert(isdefined(model));
	self notify ("stop get known enemy cleanup");
	self endon ("stop get known enemy cleanup");
	model endon ("death");
	self waittill ("death");
	model delete();
}
*/

debugTimeout()
{
	wait(5);
	self notify ("timeout");
}

debugPosInternal( org, string, size )
{
	self endon ("death");
	self notify ("stop debug " + org);
	self endon ("stop debug " + org);
	ent = spawnstruct();
	ent thread debugTimeout();
	ent endon ("timeout");
	if (self.enemy.team == "allies")
		color = (0.4, 0.7, 1);
	else
		color = (1, 0.7, 0.4);
		
	while (1)
	{
		wait (0.05);
		print3d (org, string, color, 1, size);	// origin, text, RGB, alpha, scale
	}
}

debugPos( org, string )
{
	thread debugPosInternal( org, string, 2.15 );
}

debugPosSize( org, string, size )
{
	thread debugPosInternal( org, string, size );
}

debugBurstPrint(numShots, maxShots)
{
	burstSize = numShots / maxShots;
	burstSizeStr = undefined;
	
	if (numShots == self.bulletsInClip)
		burstSizeStr = "all rounds";
	else
	if (burstSize < 0.25)
		burstSizeStr = "small burst";
	else
	if (burstSize < 0.5)
		burstSizeStr = "med burst";
	else
		burstSizeStr = "long burst";

	thread animscripts\utility::debugPosSize(self.origin + (0,0,42), burstSizeStr, 1.5);
	thread animscripts\utility::debugPos(self.origin + (0,0,60), "Suppressing");
}


printShootProc ()
{
	self endon ("death");
	self notify ("stop shoot " + self.export);
	self endon ("stop shoot " + self.export);

	printTime = 0.25;
	timer = printTime*20;
	for (i=0;i<timer;i+=1)
	{
		wait (0.05);
		print3d (self.origin + (0,0,70), "Shoot", (1,0,0), 1, 1);	// origin, text, RGB, alpha, scale
	}
}

printShoot ()
{
	/#
	if (getdebugcvar ("anim_debug") == "3")
		self thread printShootProc();
	#/
}

showDebugProc(fromPoint, toPoint, color, printTime)
{
	self endon ("death");
//	self notify ("stop debugline " + self.export);
//	self endon ("stop debugline " + self.export);

	timer = printTime*20;
	for (i=0;i<timer;i+=1)
	{
		wait (0.05);
		line (fromPoint, toPoint, color);
	}
}

showDebugLine(fromPoint, toPoint, color, printTime)
{
	self thread showDebugProc(fromPoint, toPoint + (0,0,-5), color, printTime);
}


/*
randomSpread (range)
{
	edge = range * 0.15;
	edge = randomfloat(edge);
	mult = 1;
	if (randomint(100) > 50)
		mult = -1;
	vec = (mult * (range - edge), randomfloat(range+range) - range, 
}
*/

shootWrapper(accMod, shootOverride)
{
	if (isdefined (shootOverride))
	{
		endpos = bulletSpread (self gettagorigin("tag_flash"), shootOverride, 4);
//		endpos = shootOverride;
//		println ("Start position: ^4" + self.origin + "^7, End position: ^4" + shootOverride + "^7, gives bullet spread position: ^4" + endpos);
 
		if (!self.goodShootPosValid || !isalive(self.enemy) || self canSee(self.enemy))
			self shoot(1);
		else
			self shoot(1, endpos);
	}
	else
		self shoot();

	/*
	if (!self.goodShootPosValid || !isalive(self.enemy) || self canSee(self.enemy))
	{
			self shoot(1, shootOverride);
		else
			self shoot(1);
	}
	else
	{
		if (isdefined (shootOverride))
			self shoot(1, shootOverride);
		else
			self shoot(1, self.goodShootPos);
	}
	*/

	/*
	if (isdefined (shootOverride) && isdefined (accMod))
		self shoot(accMod, shootOverride);
	else if (isdefined (shootOverride))
	{
		accuracy = self.accuracy;// * self.accuracyStationaryMod;
		if (accuracy < 0)
			accuracy = 0;
		if (accuracy > 1)
			accuracy = 1;
		accuracy = 1 - accuracy;
		self shoot(	1 , shootOverride + maps\_utility::randomvector(accuracy*100));
	}
	else if (isdefined (accMod))
		self shoot(accMod);
	else
		self shoot();
	*/
	
	self.lastShootTime = gettime();
}
	/*
	ent = spawnstruct();
	ent thread debugPosDraw(org);
	wait (4);
	ent notify ("stop");
}

debugPosDraw( org )
{
	self endon ("stop");
	
}
*/
vector_scale (vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

throwGun ()
{
	org = spawn ("script_model",(0,0,0));
	org setmodel ("xmodel/temp");
	org.origin = self getTagOrigin ( "tag_weapon_right")  + (50,50,0);
	org.angles = self getTagAngles ( "tag_weapon_right" );
	right = anglestoright(org.angles);
	right = vector_scale(right, 15);
	forward = anglestoforward (org.angles);
	forward = vector_scale(forward, 15);
	org moveGravity ((0,50,150), 100);

	weaponClass = "weapon_" + self.weapon;
	weapon = spawn (weaponClass, org.origin);
	weapon.angles = self getTagAngles ( "tag_weapon_right" ); 
	weapon linkto (org);
	
//	org rotateVelocity ((100,0,0), 12);
	lastOrigin = org.origin;
	while ((isdefined(weapon)) && (isdefined(weapon.origin)))
	{
		start = lastOrigin;
		end = org.origin;
		angles = vectortoangles (end - start);
		forward = anglestoforward (angles);
		forward = vector_scale(forward, 4);
		trace = bulletTrace(end, end + forward, true, weapon);
		if (isalive (trace["entity"]) && trace["entity"] == self)
		{
			wait (0.05);
			continue;
		}
			
		if (trace["fraction"] < 1.0)
			break;
		
		lastOrigin = org.origin;
		wait (0.05);
	}
	/*
	if (isdefined (trace["entity"]))
	{
		if (isSentient (trace["entity"]))
			trace["entity"] DoDamage ( 300, weapon.origin );
	}
	*/
	if ((isdefined(weapon)) && (isdefined(weapon.origin)))
		weapon unlink();
	org delete();
}

getAimDelay()
{
//	if (level.aim_delay_off)
/*		
	if ((isalive(self.enemy)) && (self.enemy == level.player))
	{
		dist = distance (self.origin, self.enemy.origin);
		delay = dist * 0.004;
		delay -= 1;
		delay = delay * 0.5;
		delay += randomfloat(delay);
//		println ("^7Delaying fire from distance " + dist + " for " + delay + " second");
		if (delay > 0)
			return (delay);
	}
*/	
	return 0.001;
}

setEnv(env)
{
	anim.idleAnimArray		["stand"]["a"] = [];
	anim.idleAnimWeights	["stand"]["a"] = [];
	anim.idleTransArray		["stand"]["a"] = [];
	anim.subsetAnimArray	["stand"]["a"] = [];
	anim.subsetAnimWeights	["stand"]["a"] = [];
	
	anim.idleAnimArray		["crouch"]["a"] = [];
	anim.idleAnimWeights	["crouch"]["a"] = [];
	anim.idleTransArray		["crouch"]["a"] = [];
	anim.subsetAnimArray	["crouch"]["a"] = [];
	anim.subsetAnimWeights	["crouch"]["a"] = [];
	
	anim.idleAnimArray		["stand"]["b"] = [];
	anim.idleAnimWeights	["stand"]["b"] = [];
	anim.idleTransArray		["stand"]["b"] = [];
	anim.subsetAnimArray	["stand"]["b"] = [];
	anim.subsetAnimWeights	["stand"]["b"] = [];
	
	anim.idleAnimArray		["crouch"]["b"] = [];
	anim.idleAnimWeights	["crouch"]["b"] = [];
	anim.idleTransArray		["crouch"]["b"] = [];
	anim.subsetAnimArray	["crouch"]["b"] = [];
	anim.subsetAnimWeights	["crouch"]["b"] = [];
	
	anim.pistolStackIdleAnimArray		["stand"]["a"][0] = %pistol_leftstand_hide_idle;
	anim.pistolStackIdleAnimWeights		["stand"]["a"][0] = 10;
	anim.pistolStackIdleTransArray		["stand"]["a"] = [];
	anim.pistolStackSubsetAnimArray		["stand"]["a"] = [];
	anim.pistolStackSubsetAnimWeights	["stand"]["a"] = [];
	
	anim.pistolStackIdleAnimArray		["stand"]["b"][0] = %pistol_rightstand_hide_idle;
	anim.pistolStackIdleAnimWeights		["stand"]["b"][0] = 10;
	anim.pistolStackIdleTransArray		["stand"]["b"] = [];
	anim.pistolStackSubsetAnimArray		["stand"]["b"] = [];
	anim.pistolStackSubsetAnimWeights	["stand"]["b"] = [];
	
	anim.pistolStackIdleAnimArray		["crouch"]["a"][0] = %pistol_leftcrouch_hide_idle;
	anim.pistolStackIdleAnimWeights		["crouch"]["a"][0] = 10;
	anim.pistolStackIdleTransArray		["crouch"]["a"] = [];
	anim.pistolStackSubsetAnimArray		["crouch"]["a"] = [];
	anim.pistolStackSubsetAnimWeights	["crouch"]["a"] = [];
	
	anim.pistolStackIdleAnimArray		["crouch"]["b"][0] = %pistol_rightcrouch_hide_idle;
	anim.pistolStackIdleAnimWeights		["crouch"]["b"][0] = 10;
	anim.pistolStackIdleTransArray		["crouch"]["b"] = [];
	anim.pistolStackSubsetAnimArray		["crouch"]["b"] = [];
	anim.pistolStackSubsetAnimWeights	["crouch"]["b"] = [];

	anim.stackIdleAnimArray		["stand"]["a"][0] = %casualcornera_idle_left;
	anim.stackIdleAnimWeights	["stand"]["a"][0] = 10;
	anim.stackIdleTransArray	["stand"]["a"] = [];
	anim.stackSubsetAnimArray	["stand"]["a"] = [];
	anim.stackSubsetAnimWeights	["stand"]["a"] = [];
	
	anim.stackIdleAnimArray		["stand"]["b"][0] = %casualcornera_idle_left;
	anim.stackIdleAnimWeights	["stand"]["b"][0] = 10;
	anim.stackIdleTransArray	["stand"]["b"] = [];
	anim.stackSubsetAnimArray	["stand"]["b"] = [];
	anim.stackSubsetAnimWeights	["stand"]["b"] = [];
	
	anim.stackIdleAnimArray		["crouch"]["a"][0] = %casualcornera_idle_left; //cornercrouchpose_left;
	anim.stackIdleAnimWeights	["crouch"]["a"][0] = 10;
	anim.stackIdleTransArray	["crouch"]["a"] = [];
	anim.stackSubsetAnimArray	["crouch"]["a"] = [];
	anim.stackSubsetAnimWeights	["crouch"]["a"] = [];
	
	anim.stackIdleAnimArray		["crouch"]["b"][0] = %casualcornera_idle_left; //cornerb_crouch_alert_idle_right;
	anim.stackIdleAnimWeights	["crouch"]["b"][0] = 10;
	anim.stackIdleTransArray	["crouch"]["b"] = [];
	anim.stackSubsetAnimArray	["crouch"]["b"] = [];
	anim.stackSubsetAnimWeights	["crouch"]["b"] = [];

	if (env == "cold")
	{
		anim.idleAnimArray		["stand"]["a"][0] = %standing_ambient_cold_baseposeidle1;
		anim.idleAnimWeights	["stand"]["a"][0] = 10;
		anim.idleTransArray		["stand"]["a"][0] = %standing_ambient_cold_transin;
		anim.idleTransArray		["stand"]["a"][1] = %Standing_ambient_cold_transout;
		anim.subsetAnimArray	["stand"]["a"][0] = %Standing_ambient_cold_rubbinghands;
		anim.subsetAnimWeights	["stand"]["a"][0] = 10;
		anim.subsetAnimArray	["stand"]["a"][1] = %Standing_ambient_cold_blowinghands;
		anim.subsetAnimWeights	["stand"]["a"][1] = 5;
		
		anim.idleAnimArray		["stand"]["b"][0] = %standing_ambient_cold_baseposeidle2;
		anim.idleAnimWeights	["stand"]["b"][0] = 10;
		anim.idleTransArray		["stand"]["b"][0] = %standing_ambient_cold_transin;
		anim.idleTransArray		["stand"]["b"][1] = %Standing_ambient_cold_transout;
		anim.subsetAnimArray	["stand"]["b"][0] = %Standing_ambient_cold_rubbinghands;
		anim.subsetAnimWeights	["stand"]["b"][0] = 10;
		anim.subsetAnimArray	["stand"]["b"][1] = %Standing_ambient_cold_blowinghands;
		anim.subsetAnimWeights	["stand"]["b"][1] = 5;
		
		anim.idleAnimArray		["crouch"]["a"][0] = %crouching_ambient_cold_baseposelook;
		anim.idleAnimWeights	["crouch"]["a"][0] = 10;
		anim.idleAnimArray		["crouch"]["a"][1] = %crouching_ambient_cold_baseposelook;
		anim.idleAnimWeights	["crouch"]["a"][1] = 6;
		anim.idleTransArray		["crouch"]["a"][0] = %crouching_ambient_cold_transin;
		anim.idleTransArray		["crouch"]["a"][1] = %crouching_ambient_cold_transout;
		anim.subsetAnimArray	["crouch"]["a"][0] = %crouching_ambient_cold1;
		anim.subsetAnimWeights	["crouch"]["a"][0] = 10;
		anim.subsetAnimArray	["crouch"]["a"][1] = %crouching_ambient_cold2;
		anim.subsetAnimWeights	["crouch"]["a"][1] = 5;
		
		anim.idleAnimArray		["crouch"]["b"][0] = %crouching_ambient_cold_baseposelook;
		anim.idleAnimWeights	["crouch"]["b"][0] = 10;
		anim.idleAnimArray		["crouch"]["b"][1] = %crouching_ambient_cold_baseposelook;
		anim.idleAnimWeights	["crouch"]["b"][1] = 6;
		anim.idleTransArray		["crouch"]["b"][0] = %crouching_ambient_cold_transin;
		anim.idleTransArray		["crouch"]["b"][1] = %crouching_ambient_cold_transout;
		anim.subsetAnimArray	["crouch"]["b"][0] = %crouching_ambient_cold1;
		anim.subsetAnimWeights	["crouch"]["b"][0] = 10;
		anim.subsetAnimArray	["crouch"]["b"][1] = %crouching_ambient_cold2;
		anim.subsetAnimWeights	["crouch"]["b"][1] = 5;
		
		
		anim.environment = "cold";
		maps\_utility::array_thread(getaiarray(),::PersonalColdBreath);
		maps\_utility::array_thread(getspawnerarray(),::PersonalColdBreathSpawner);
	}
	else
	{
		anim.idleAnimArray		["stand"]["a"][0] = %stand_alert_1;
		anim.idleAnimArray		["stand"]["a"][1] = %stand_alert_2;
		anim.idleAnimArray		["stand"]["a"][2] = %stand_alert_3;
		anim.idleAnimWeights	["stand"]["a"][0] = 10;
		anim.idleAnimWeights	["stand"]["a"][1] = 8;
		anim.idleAnimWeights	["stand"]["a"][2] = 8;
		anim.idleTransArray		["stand"]["a"] = [];
		anim.subsetAnimArray	["stand"]["a"] = [];
		anim.subsetAnimWeights	["stand"]["a"] = [];
		
		anim.idleAnimArray		["stand"]["b"][0] = %stand_alertb_idle1;
		anim.idleAnimArray		["stand"]["b"][1] = %stand_alertb_twitch1;
		anim.idleAnimWeights	["stand"]["b"][0] = 10;
		anim.idleAnimWeights	["stand"]["b"][1] = 4;
		anim.idleTransArray		["stand"]["b"] = [];
		anim.subsetAnimArray	["stand"]["b"] = [];
		anim.subsetAnimWeights	["stand"]["b"] = [];
		
		anim.idleAnimArray		["crouch"]["a"][0] = %crouch_alert_A_idle;
		anim.idleAnimArray		["crouch"]["a"][1] = %crouch_alert_A_twitch;
		anim.idleAnimWeights	["crouch"]["a"][0] = 10;
		anim.idleAnimWeights	["crouch"]["a"][1] = 5;
		anim.idleTransArray		["crouch"]["a"] = [];
		anim.subsetAnimArray	["crouch"]["a"] = [];
		anim.subsetAnimWeights	["crouch"]["a"] = [];
		
		anim.idleAnimArray		["crouch"]["b"][0] = %crouch_alert_B_idle1;
		anim.idleAnimArray		["crouch"]["b"][1] = %crouch_alert_B_twitch1;
		anim.idleAnimWeights	["crouch"]["b"][0] = 10;
		anim.idleAnimWeights	["crouch"]["b"][1] = 5;
		anim.idleTransArray		["crouch"]["b"] = [];
		anim.subsetAnimArray	["crouch"]["b"] = [];
		anim.subsetAnimWeights	["crouch"]["b"] = [];
	}
}

/*
drawTag(tag)
{
	self endon ("death");
	self notify ("stop drawing tag");
	self endon ("stop drawing tag");
	for (;;)
	{
		org = self gettagOrigin (tag);
		ang = self gettagAngles (tag);
		forward = anglestoforward(ang);
		forwardFar = vector_scale(forward, 15);
		forwardClose = vector_scale(forward, 10);
		right = anglestoright (ang);
		left = vector_scale(right, -05);
		right = vector_scale(right, 05);
		line (org, org + forwardFar, (0.9, 0.7, 0.6), 0.9);
		line (org + forwardFar, org + forwardClose + right, (0.9, 0.7, 0.6), 0.9);
		line (org + forwardFar, org + forwardClose + left, (0.9, 0.7, 0.6), 0.9);
		wait (0.05);
	}
}
*/

PersonalColdBreath()
{
	tag = "TAG_EYE";
	self endon ("death");
	self notify ("stop personal effect");
	self endon ("stop personal effect");
	for (;;)
	{
		if (self.anim_movement != "run")
		{
			playfxOnTag ( level._effect["cold_breath"], self, tag );
			wait (2.5 + randomfloat(3));
		}
		else
			wait (0.5);
	}
}

PersonalColdBreathSpawner()
{
	self endon ("death");
	self notify ("stop personal effect");
	self endon ("stop personal effect");
	for (;;)
	{
		self waittill ("spawned", spawn);
		if (maps\_utility::spawn_failed(spawn))
			continue;
		spawn thread PersonalColdBreath();
	}
}

isSuppressedWrapper ()
{
	if (forcedCover("show"))
		return false;
	if (self.suppressionwait <= 0)
		return false;
	if (!self.isSuppressable)
		return false;
	return (self issuppressed());
}

getNodeOffset(node)
{
	if (isdefined(node.offset))
		return node.offset;

	cornernode = false;
	nodeOffset = (0,0,0);
	switch(node.type)
	{
		case "Cover Left":
		case "Cover Left Wide":
			cornerNode = true;
			right = anglestoright(node.angles);
			right = maps\_utility::vectorScale(right, -32);
			forward = anglestoforward(node.angles);
			forward = maps\_utility::vectorScale(forward, 10);
			nodeOffset = right + forward;
			nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
		break;

		case "Cover Right":
		case "Cover Right Wide":
			cornerNode = true;
			right = anglestoright(node.angles);
			right = maps\_utility::vectorScale(right, 32);
			forward = anglestoforward(node.angles);
			forward = maps\_utility::vectorScale(forward, 10);
			nodeOffset = right + forward;
			nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
		break;
		
		case "Cover Stand":
		case "Cover Crouch":
		case "Cover Crouch Window":
		case "Conceal Stand":
		case "Conceal Crouch":
			nodeOffset = (0, 0, 64);
		break;
	}

	node.offset = nodeOffset;
	return node.offset;
}

canSeeEnemy()
{
	if (!isalive(self.enemy))
		return false;
	
//	return (self canattackenemynode());
	if (self canSee (self.enemy))
	{
		self.goodShootPosValid = true;
		self.goodShootPos = GetEnemyEyePos();
		return true;
	}
	return false;
}

canSeeEnemyFromExposed()
{
	if (!isalive(self.enemy))
	{
		self.goodShootPosValid = false;
		return false;
	}

//	if (self.enemy != level.player)
//		return (self canattackenemynode());

	if (!isdefined(self.node))
		return (self canSee (self.enemy));

	if (self.node.type == "Cover Left" || self.node.type == "Cover Right")
	{
		// Don't try to shoot at stuff behind the node
		yaw = self.node GetYawToOrigin(self.enemy.origin);
		if ((yaw > 60) || (yaw < -60))
			return false;
	}
	
	nodeOffset = getNodeOffset(self.node);
	enemyEye = GetEnemyEyePos();
	if (sightTracePassed(self.node.origin + nodeOffset, enemyEye, false, undefined))
	{
		self.goodShootPosValid = true;
		self.goodShootPos = enemyEye;
		return true;
	}
	else
	{
	/#
		if (self getentnum() == getdebugcvarint("anim_dotshow"))
			thread persistentDebugLine(self.node.origin + nodeOffset, enemyEye);
	#/
	}
	
	return false;

	

//	return (self canattackenemynode());

	/*
	return (self cansee (self.enemy));

		
	nodeOffset = getNodeOffset(self.node);
	success = sightTracePassed(self.node.origin + nodeOffset, GetEnemyEyePos(), false, undefined);
//	thread showLines(self.node.origin + nodeOffset, GetEnemyEyePos(), trace["position"]);
	return success;
	*/
}

showLines(start, end, end2)
{
	for (;;)
	{
		line(start, end, (1,0,0), 1);
		wait (0.05);
		line(start, end2, (0,0,1), 1);
		wait (0.05);
	}
}

aiSuppressAI()
{
	if (!self canattackenemynode())
		return false;

	self.goodShootPosValid = true;
	shootPos = undefined;
	if (isdefined(self.enemy.node))
	{
		nodeOffset = getNodeOffset(self.enemy.node);
		shootPos = self.enemy.node.origin + nodeOffset;
	}
	else
		shootPos = self.enemy geteye();
	
	self.goodShootPos = shootPos;
	return true;
}

canSuppressEnemyFromExposed()
{
	// FromExposed includes checking from the offset of the node the AI is at
	if (!hasSuppressableEnemy())
		return false;

	if (self.enemy != level.player)
		return aiSuppressAI();

	if (isdefined(self.node))
	{
		if (self.node.type == "Cover Left" || self.node.type == "Cover Right")
		{
			// Don't try to shoot at stuff behind the node
			yaw = self.node GetYawToOrigin(self.lastEnemySightPos);
			if ((yaw > 60) || (yaw < -60))
				return false;
		}
		
		nodeOffset = getNodeOffset(self.node);
		startOffset = self.node.origin + nodeOffset;
	}
	else
		startOffset = self GetTagOrigin ("tag_flash");

	return foundGoodSuppressSpot(startOffset);
}

canSuppressEnemy()
{
	if (!hasSuppressableEnemy())
		return false;

	if (self.enemy != level.player)
		return aiSuppressAI();

	startOffset = self GetTagOrigin ("tag_flash");

	return foundGoodSuppressSpot(startOffset);
}

hasSuppressableEnemy()
{
		
	if (!isalive(self.enemy))
	{
		self.goodShootPosValid = false;
		return false;
	}
		
	if (!isdefined(self.lastEnemySightPos))
	{
		self.goodShootPosValid = false;
		return false;
	}
	
	if (isdefined(self.lastEnemySightPosOld) && self.lastEnemySightPosOld == self.lastEnemySightPos)
	{
		// This way we don't retrace if its the same last sight pos it was before
		// Assuming we're still in the same place
		if (distance (self.lastEnemySightPosSelfOrigin, self.origin) < 32 &&
			distance (self.lastEnemySightPosEnemyOrigin, self.enemy.origin) < 32)
			return (self.goodShootPosValid);
	}
	return true;
}

foundGoodSuppressSpot(startOffset)
{
	if (!sightTracePassed(self GetEye(), startOffset, false, undefined))
	{
		self.goodShootPosValid = false;
		return false;
	}

	self.lastEnemySightPosSelfOrigin = self.origin;
	self.lastEnemySightPosEnemyOrigin = self.enemy.origin;
	self.lastEnemySightPosOld = self.lastEnemySightPos;
	
	trace = bullettrace(self.lastEnemySightPos, GetEnemyEyePos(), false, undefined);
	destination = trace["position"];
		
	traces = distance(self.lastEnemySightPos, destination) * 0.05;
	if (!traces)
		traces = 1;
	if (traces > 20)
		traces = 20; // cap it 
	vectorDif = self.lastEnemySightPos - destination;
	vectorDif = (vectorDif[0]/traces, vectorDif[1]/traces, vectorDif[2]/traces);
	
	offset = (0,0,0);
	/#
	if (getdebugcvarint("debug_dotshow") == self getentnum())
	{
		thread print3dtime (1.5, self.lastEnemySightPos, "lastpos", (1, .2, .2), 1, 0.75);	// origin, text, RGB, alpha, scale
		thread print3dtime (1.5, destination, "eyepos", (1, .2, .2), 1, 0.75);	// origin, text, RGB, alpha, scale
	}
	#/

	assertTest = 0;
	goodTrace = false;
	for (i=0;i<traces+2;i++)
	{
		tracePassed = sightTracePassed(startOffset, destination + offset, false, undefined);
		/#
		if (getdebugcvarint("debug_dotshow") == self getentnum())
			thread print3dtime (1.5, destination + offset, ".", (.2, .2, 1), 1, 0.75);	// origin, text, RGB, alpha, scale
		#/			
/#
		if (assertTest == 1)
			assertTest = 0;
#/
		if (tracePassed)
		{
			// Get the trace after the one that worked cause then you solve some problems where the gun is farther over than
			// the position we check from, when its time to shoot
			if (!goodTrace)
			{
				goodTrace = true;
				// yet more traces to come so get the next one just to fudge it away from the wall a little
				if (i < traces+1)
				{
/#
					assertTest = 1;
#/
					continue;
				}
			}
			self.goodShootPosValid = true;
			self.goodShootPos = destination + offset;
			return true;
		}
		
		offset += vectorDif;
	}
	assert (assertTest == 0);

/*
	if (sightTracePassed(startOffset, self.lastEnemySightPos, false, undefined))
	{
		self.goodShootPosValid = true;
//		self.goodShootPos = self.lastEnemySightPos;

		return true;
	}
*/
	self.goodShootPosValid = false;
	return false;
	/*


	if (!isalive(self.enemy))
		return false;
	curTime = gettime();
	if (curTime < self.sightPosTime)
		return ( self.goodShootPosValid );

	self.sightPosTime = curTime + 1000;
	self.sightPosLeft = !(self.sightPosLeft);
	pos = goodEnemyPos(self.angles, GetEnemyEyePos());
	if ( isdefined(pos))
	{
		self.goodShootPos = pos;
		self.goodShootPosValid = true;
		thread setGoodEnemy(self.enemy);
		return true;
	}
	return false;
*/
/*	

//	if (isdefined(self.lastEnemySightPos))

	// Update goodshotpos to be your enemies most recent seen pos if you've seen him move recently
	if (isalive (self.enemy) && isdefined (self.lastEnemySightPos))
	{
		sawLiveEnemy = true;
		if (gettime() - self.personalSightTime < 500)
		{
			self.goodShootPos = self.lastEnemySightPos;
			thread setGoodEnemy(self.enemy);
			
			prof_end("hasEnemySightPos");
			return true;
		}
	}

	if (isdefined(self.goodShootPos))
	{
		prof_end("hasEnemySightPos");
		return true;
	}
	
	self.goodShootPos = getGoodShootPos();
	if (isdefined(self.goodShootPos))
	{
		prof_end("hasEnemySightPos");
		return true;
	}
	
	prof_end("hasEnemySightPos");
	return false;
//	if (isalive (self.enemy))
//		return true;
//	return ((isdefined (self.squad)) && (isdefined (self.squad.sightPos)));
*/
}

getGoodShootPos()
{
	sawLiveEnemy = false;
	if (isalive (self.enemy) && isdefined (self.lastEnemySightPos))
	{
		sawLiveEnemy = true;
		if (sawEnemyMove())
		{
			self.goodShootPos = self.lastEnemySightPos;
			self.goodShootPosValid = true;
	 		thread setGoodEnemy(self.enemy);
			return self.lastEnemySightPos;
		}
	}

	if (self.goodShootPosValid)
		return self.goodShootPos;
		
	if (sawLiveEnemy)
	{
//		if (gettime() > self.personalSightTime - 5000)
//			return GetEnemyEyePos();
//		assert (isdefined(self.lastEnemySightPos));
//		if (
//		if (isdefined(self.lastEnemySightPos))
//		if (gettime() > self.personalSightTime - 5000)
//			return GetEnemyEyePos();

		offset = (0,0,0);
		if (isdefined (self.node))
		{		
			if (self.node.type == "Cover Left")
			{
				offset = anglestoright(self.node.angles);
				offset = maps\_utility::vectorScale(offset, -32);
			}
			else
			if (self.node.type == "Cover Right")
			{
				offset = anglestoright(self.node.angles);
				offset = maps\_utility::vectorScale(offset, 32);
			}
		}
		
	 	if (CanShootEnemyFrom(offset, undefined, true, self.lastEnemySightPos))
	 	{
	 		self.goodShootPos = self.lastEnemySightPos;
	 		self.goodShootPosValid = true;
	 		thread setGoodEnemy(self.enemy);
			return self.lastEnemySightPos;
		}
//			return self.lastEnemySightPos;
	}
/*	
	if (isdefined (self.squad.sightPos) && isalive(self.squad.sightEnemy))
	{
		pos = goodEnemyPos(self.angles, self.squad.sightPos);
	
		if ( isdefined(pos) )
		{
			self.goodShootPos = pos;
			self.goodShootPosValid = true;
	 		thread setGoodEnemy(self.squad.sightEnemy);
			return self.goodShootPos;
		}
	}
*/	
	return undefined;
}

setGoodEnemy(enemy)
{
	self notify ("stop waiting for good enemy to die");
	self endon ("stop waiting for good enemy to die");
	self.goodEnemy = enemy;
	self.goodEnemy waittill ("death");
	self.goodEnemy = undefined;	
	self.goodShootPosValid = false;
}

// Returns an animation from an array of animations with a corrosponding array of weights.
anim_array (animArray, animWeights)
{
	total_anims = animArray.size;
	idleanim = randomint (total_anims);
	assert (total_anims);
	assert (animArray.size == animWeights.size);
	if (total_anims == 1)
		return animArray[0];
		
	weights = 0;
	total_weight = 0;
	
	for (i=0;i<total_anims;i++)
		total_weight += animWeights[i];
	
	anim_play = randomfloat (total_weight);
	current_weight	= 0;
	
	for (i=0;i<total_anims;i++)
	{
		current_weight += animWeights[i];
		if (anim_play >= current_weight)
			continue;

		idleanim = i;
		break;
	}
	
	return animArray[idleanim];
}		

notForcedCover()
{
	return ((self.anim_forced_cover == "none") || (self.anim_forced_cover == "show"));
} 

forcedCover(msg)
{
	return (self.anim_forced_cover == msg);
} 

print3dtime (timer, org, msg, color, alpha, scale)
{
	newtime = timer / 0.05;
	for (i=0;i<newtime;i++)
	{
		print3d (org, msg, color, alpha, scale);
		wait (0.05);
	}
}

print3drise (org, msg, color, alpha, scale)
{
	newtime = 5 / 0.05;
	up = 0;
	org = org + maps\_utility::randomvector(30);

	for (i=0;i<newtime;i++)
	{
		up+=0.5;
		print3d (org + (0,0,up), msg, color, alpha, scale);
		wait (0.05);
	}
}

crossproduct (vec1, vec2)
{
	return (vec1[0]*vec2[1] - vec1[1]*vec2[0] > 0);
}

doGoodShootTraces(right, multiplier, originalSightPos, startOffset)
{
	if (!sightTracePassed(self GetEye(), startOffset, false, undefined))
	{
		shotArray[0] = false;
		return;
	}

	offsetAdd = vector_scale (right, (25)*multiplier);
	offset = (0,0,0);
	increment = 25;
	maxDist = 750;
	curDist = 0;
	offsetMax = vector_scale (right, (maxDist)*multiplier);
	trace = bulletTrace(originalSightPos, originalSightPos + offsetMax, false, undefined);
	
	// Trace out to see how far you can go before you hit a wall	
	maxDist = maxDist * trace["fraction"];
	
	shotArray[0] = false; // success
	
	for (i=0;i<30;i++)
	{
		offset = offset + offsetAdd;
		curDist += increment;
		if (curDist >= maxDist)
			break;
			
		/#
		if (getdebugcvarint("anim_dotshow") == self getentnum())
			thread print3dtime (1.5, originalSightPos + offset, ".", (.2, .2, 1), 1, 0.75);	// origin, text, RGB, alpha, scale
		#/					
		if (sightTracePassed(startOffset, originalSightPos + offset, false, undefined))
		{
			shotArray[0] = true; // success
			break;
		}
	}
	shotArray[1] = offset;
	return shotArray;	
}

// Returns the best way to shoot the getenemypos from the current positoin
goodEnemyPos(direction, originalSightPos)
{
	if (sawEnemyMove(1000))
	{
		// saw the enemy move within the last second
		return self.lastEnemySightPos;
	}

	assert (isdefined (originalSightPos));
//	if (!isdefined (originalSightPos))
//		originalSightPos = self.enemy.origin; //getEnemySightPos();
//	originalSightPos = getEnemySightPos();
	success = true;
	canShootPos = false;
	cornerNode = false;
	nodeOffset = undefined;
	
	if (isdefined(self.node))
	{
		if (self.node.type == "Cover Left")
		{
			cornerNode = true;
			nodeOffset = anglestoright(self.node.angles);
			nodeOffset = maps\_utility::vectorScale(nodeOffset, -32);
			nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
		}
		else
		if (self.node.type == "Cover Right")
		{
			cornerNode = true;
			nodeOffset = anglestoright(self.node.angles);
			nodeOffset = maps\_utility::vectorScale(nodeOffset, 32);
			nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
		}
		if (cornerNode)
		{
			// Don't try to shoot at stuff behind the node
			yaw = self.node GetYawToOrigin(originalSightPos);
			if ((yaw > 60) || (yaw < -60))
				return undefined;
		}
			

		/*
		if (cornerNode)
		{
			canShootPos = sightTracePassed(self.node.origin + nodeOffset, originalSightPos, false, undefined);
		}
		*/
	}

	/*
	if (!cornerNode)
		canShootPos = canShootEnemyPos ( originalSightPos );

//	if (!canShootEnemyPos ( originalSightPos ))
	if (!canShootPos)
	*/
	myGunPos = self GetTagOrigin ("tag_flash");
	if (!sightTracePassed(self GetEye(), myGunPos, false, undefined))
		return undefined;
	
	success = false;
	angles = vectortoangles (myGunPos - originalSightPos);
	right = anglesToRight(angles);
	
//		if (self.sightPosLeft)
	multiplier = -1;
	goodPos = [];
	goodPosDist = [];
	goodPosSuccess = [];
	for (i=0;i<2;i++)
	{
		goodPosSuccess[i] = false;
		multiplier = multiplier * -1;
//		if (crossproduct (direction, originalSightPos - self.origin))
//			multiplier = -1;
			
		offset = undefined;
//		for (i=1;i<70;i++)
//			offset = vector_scale (right, (i*1.4)*multiplier);
		if (cornerNode)
			shotArray = doGoodShootTraces(right, multiplier, originalSightPos, self.node.origin + nodeOffset);
		else
		{
			myGunPos = self GetTagOrigin ("tag_flash");
			shotArray = doGoodShootTraces(right, multiplier, originalSightPos, myGunPos);
		}

		success = shotArray[0];
		if (success)
		{
			goodPos[i] = originalSightPos + shotArray[1];
			goodPosDist[i] = distance (goodPos[i], self.origin);
			goodPosSuccess[i] = true;
			
			/#
			if (getdebugcvarint("anim_dotshow") == self getentnum())
			if (getdebugcvar("anim_debug") == "1")
				thread print3dtime (1.5, goodPos[i] + (0,0,2), ".", (.2, 1, .2), 1, 1.75);	// origin, text, RGB, alpha, scale
			#/			
		}
	}

	if (goodPosSuccess[0])
	{
		if (goodPosSuccess[1])
		{
			// Sometimes return the farther one for variety
			if (randomint(10) >= 7)
				return goodPos[randomint(2)];
			if (goodPosDist[0] < goodPosDist[1])
				return goodPos[0];
			else
				return goodPos[1];
		}
		else
			return goodPos[0];
	}
	else
	if (goodPosSuccess[1])
		return goodPos[1];
	
	return undefined;
	/*
	else
	{
		// Try to rake the fire past the sight position if the enemy hasnt been
		// seen lately
		if (gettime() - self.squad.sightTime > 1500)
		{
			myGunPos = self GetTagOrigin ("tag_flash");
			success = false;
			angles = vectortoangles (myGunPos - originalSightPos);
			right = anglesToRight(angles);
			
			multiplier = -1;
			if (crossproduct (direction, originalSightPos - self.origin))
				multiplier = 1;

				
			offset = undefined;
			if (cornerNode)
			{
				for (i=1;i<40;i++)
				{
					offset = vector_scale (right, (i*25)*multiplier); // i*5
					/#
					if (getdebugcvarint("anim_dotshow") == self getentnum())
						thread print3dtime (1.5, originalSightPos + offset, ".", (.2, .2, 1), 1, 0.75);	// origin, text, RGB, alpha, scale
					#/
					if (sightTracePassed(self.node.origin + nodeOffset, originalSightPos + offset, false, undefined))
					{
						success = true;
						break;
					}
				}
			}
			else
			{
				for (i=1;i<40;i++)
				{
					offset = vector_scale (right, (i*25)*multiplier); // i*5
					/#
					if (getdebugcvarint("anim_dotshow") == self getentnum())
						thread print3dtime (1.5, originalSightPos + offset, ".", (.2, .2, 1), 1, 0.75);	// origin, text, RGB, alpha, scale
					#/					
					if (canShootEnemyPos ( originalSightPos + offset))
					{
						success = true;
						break;
					}
				}
			}
			
			if (success)
			{
				sightPos = originalSightPos + offset;
				// Set a new group sightpos if you can see to the side
				self.squad.sightTime = getTime();
				self.squad.sightPos = sightPos;
				/#
				if (getdebugcvarint("anim_dotshow") == self getentnum())
				if (getdebugcvar("anim_debug") == "1")
					thread print3dtime (5, sightPos + (0,0,2), ".", (.2, 1, .2), 1, 1.75);	// origin, text, RGB, alpha, scale
				#/					
			}
		}
	}
	if (success)
		return sightPos;
	return undefined;
	*/
}		


scriptChange()
{
	self.anim_current_script = "none";
	self notify (anim.scriptChange);
}

delayedScriptChange()
{
	wait (0.05);
	scriptChange();
}


handleSuppressingEnemy()
{
	if (!isalive (self))
		return;
		
	self endon ("suppressionAttackComplete");
	assert (!self.anim_suppressingEnemy);
	if (self.anim_suppressingEnemy)
	{
		if ((self.anim_pose != "wounded") && (self.anim_pose != "prone"))
		/*
		{
			if ((self.anim_wounded == "stand") || (self.anim_wounded == "crouch"))
				self SetPoseMovement(self.anim_wounded,"stop");
			else
				self SetPoseMovement("crouch","stop");
		}
		else
		*/
			self SetPoseMovement(self.anim_pose,"stop");
		self waittill ("suppressionAttackComplete");
	}
	// In case a suppression Attack is occurring in shootrunningsuppressionvolley
	self notify ("clearSuppressionAttack"); 
}


getGrenadeModel()
{
	return getWeaponModel(self.grenadeweapon);
	/*
	model = "xmodel/projectile_GermanGrenade";
	if (self.grenadeweapon == "RGD-33russianfrag")
		model = "xmodel/projectile_RussianGrenade";	
	return model;
	*/
}

sawEnemyMove(timer)
{
	if (!isdefined(timer))
		timer = 500;
	return (gettime() - self.personalSightTime < timer);
}

canThrowGrenade()
{
	if (!self.grenadeAmmo)
		return false;
	
	if (self.script_forceGrenade)
		return true;
		
	return (self.enemy == level.player);
}

usingBoltActionWeapon()
{
	return (getAIWeapon(self.weapon)["type"] == "bolt");
}

random_weight (array)
{
	idleanim = randomint (array.size);
	if (array.size > 1)
	{
		anim_weight = 0;
		for (i=0;i<array.size;i++)
			anim_weight += array[i];
		
		anim_play = randomfloat (anim_weight);
		
		anim_weight = 0;
		for (i=0;i<array.size;i++)
		{
			anim_weight += array[i];
			if (anim_play < anim_weight)
			{
				idleanim = i;
				break;
			}
		}
	}
	
	return idleanim;
}		

removeableHat()
{
	if (!isdefined (self.hatmodel))
		return false;

	if (isdefined(anim.noHatClassname[self.classname]))
		return false;
	
	return (!isdefined(anim.noHat[self.model]));
}

metalHat()
{
	if (!isdefined (self.hatmodel))
		return false;
	
	return (isdefined(anim.metalHat[self.model]));
}

fatGuy()
{
	return (isdefined(anim.fatGuy[self.model]));
}

setFootstepEffect(name, fx)
{
	assertEx(isdefined(name), "Need to define the footstep surface type.");
	assertEx(isdefined(fx), "Need to define the mud footstep effect.");
	if (!isdefined(anim.optionalStepEffects))
		anim.optionalStepEffects = [];
	anim.optionalStepEffects[anim.optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
	anim.optionalStepEffectFunction = animscripts\shared::playFootStepEffect;
}


persistentDebugLine(start, end)
{
	self endon ("death");
	level notify ("newdebugline");
	level endon ("newdebugline");
	
	for (;;)
	{
		line (start,end, (0.3,1,0), 1);
		wait (0.05);
	}
}


EnterProneWrapper(timer)
{
	thread enterProneWrapperProc(timer);
}

enterProneWrapperProc(timer)
{
	self endon ("death");
	self notify ("anim_prone_change");
	self endon ("anim_prone_change");
	// wrapper so we can put a breakpoint on it
	self EnterProne(timer);
	self waittill ("killanimscript");
	
	// in case we dont actually make it into prone by the time another script comes in
	if (self.anim_pose != "prone")
		self.anim_pose = "prone";
}

ExitProneWrapper(timer)
{
	thread ExitProneWrapperProc(timer);
}

ExitProneWrapperProc(timer)
{
	self endon ("death");
	self notify ("anim_prone_change");
	self endon ("anim_prone_change");
	// wrapper so we can put a breakpoint on it
	self ExitProne(timer);
	self waittill ("killanimscript");
	
	// in case we dont actually leave prone, change it out of prone
	if (self.anim_pose == "prone")
		self.anim_pose = "crouch";
}

getAIWeapon(weapon)
{
	weapon = tolower(weapon);
	assertEx (isdefined(anim.AIWeapon[weapon]), "Tried to getAIWeapon on undefined weapon " + weapon);
	return anim.AIWeapon[weapon];
}

canHitSuppressSpot()
{
	if (!hasEnemySightPos())
		return false;
	myGunPos = self GetTagOrigin ("tag_flash");
	return (sightTracePassed(myGunPos, getEnemySightPos(), false, undefined));
}