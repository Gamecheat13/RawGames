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
    [[anim.PutGunInHand]]("right"); // Make sure gun is in right hand as default
	if (isAlive(self.anim_personImMeleeing))
	{
		ImNotMeleeing(self.anim_personImMeleeing);
	}
    self clearanim(%body, 0.3);
	self.anim_painspecial = self.anim_special;
	self.anim_special = "none";
	self.isHoldingGrenade = false;

	MilestoneAnims(); // See if "milestoneanims" is set, play a bunch of anims if so.
	if (!isdefined (self.facehack))
		thread LevelFacialAnimHackThread();
		
    self setanim(%shoot,0.0,0.2,1);

	// Update our combat state based on the script we were in last, the script we're entering now 
	// and if we have an enemy
	UpdateCombatEndTime(self.anim_script, animscript);
	// Remember which script we're in now
	[[anim.assert]](isDefined(animscript),"Animscript not specified in initAnimTree");
	self.anim_script = animscript;

	// Call the handler to get out of Cowering pose.
	[[self.anim_StopCowering]]();
}

// UpdateAnimPose does housekeeping at the start of every script's main function.  It does stuff like making prone 
// calculations are only being done if the character is actually prone.
UpdateAnimPose()
{
	[[anim.assert]](self.anim_movement=="stop" || self.anim_movement=="walk" || self.anim_movement=="run", "UpdateAnimPose "+self.anim_pose+" "+self.anim_movement);
	
	if (!isdefined(self.desired_anim_pose)) // don't override self.desired_anim_pose
	{
		if ( self.anim_pose == "back" && self.anim_script != "pain" && self.anim_script != "death" )
		{
			[[anim.println]]("Starting a script in pose \"back\"...How does this happen?");
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
		self EnterProne(0.5); 
		
		// NOTE: self.proneok can be checked to tell if it's still ok to be prone where the AI currently is.
	}
	else
	{
		self ExitProne(0.5); // make code stop lerping in the prone orientation to ground
	}
	self.anim_pose = self.desired_anim_pose;
	self.desired_anim_pose = undefined;
}

// initialize() wraps initAnimTree, UpdateAnimPose, and anim.println calls that used to be called at the start of every
// script's main function. TODO: clean up this stuff
initialize(animscript)
{
	initAnimTree(animscript);
	[[anim.println]]("Entering "+animscript+" script");
	UpdateAnimPose();
}

// Allows level script to play a facial animation on characters by notifying "ScriptedFacial".
LevelFacialAnimHackThread()
{
	self.facehack = true;
	while (isalive (self))
	{
		self waittill ("ScriptedFacial");
		self setanim(%facial, .01, .1, 1);
		self setFlaggedAnimKnobRestart("levelfacedone", self.scriptedFacialAnim, 1, .1, 1);
		self.scriptedFacialAnim = undefined;
		self.scriptedFacialSound = undefined;
		self animscripts\shared::DoNoteTracks ("levelfacedone");
		self notify (self.scripted_notifyname);
	}
}

UpdateCombatEndTime(script1name, script2name)
{
	[[anim.println]]("UpdateCombatEndTime called with \"",script1name,"\" and \"",script2name,"\".");
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
		case "run":
		case "scripted":
		case "stop":
		case "walk":
		case "turret":
		case "grenadecower":
			break;
		default:
			println ("Unhandled scriptname "+sn[i]+" in UpdateCombatEndTime.");
			break;
		}
	}

	if ( isDefined (self.enemy) )
	{
		newCombatEndTime = gettime() + anim.combatMemoryTimeConst + randomint(anim.combatMemoryTimeRand);
		if (newCombatEndTime > self.anim_combatEndTime)
		{
			self.anim_combatEndTime = newCombatEndTime;
		}
	}
}


// Called from special node behaviors at times when eyes could see enemy
// After X checks are missed the script tells code to bail on special behavior
sightCheckNode(invalidateNode)
{
    if ( !isDefined ( self . missedSightChecks ) )
        self . missedSightChecks = 0;
	if (!isDefined(invalidateNode))
		invalidateNode = 1;

	canShoot = self canShootEnemy();
    if ( !canShoot && invalidateNode )
        self . missedSightChecks++;
    else
        self . missedSightChecks = 0; // make consecutive
    
    if ( self . missedSightChecks > 6 )
    {
		self cantAttackFromCover();
        self . missedSightChecks = 0;
    }

	return canShoot;
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


hasWeapon()
{
	return ( !isDefined(self.hasWeapon) || self.hasWeapon );
}


// Checks multiple points on the enemy, to see if I can shoot any of them.  Check that I can see my enemy 
// too, since canshoot checks from the gun barrel and the gun barrel is often through a wall.  UseSightCheck 
// is optional, defaults to true.
canShootEnemy (posOverrideEntity, useSightCheck)
{
	return canShootEnemyFrom ( (0,0,0), posOverrideEntity, useSightCheck );
}

// Takes a pose ("stand", "crouch", "prone") and an optional offset in local space, [forward, right, up].
canShootEnemyFromPose ( pose, offset, useSightCheck )
{
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
			[[anim.assert]](0, "init::canShootEnemyFromPose "+self.anim_pose);
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
			[[anim.assert]](0, "init::canShootEnemyFromPose "+self.anim_pose);
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
			[[anim.assert]](0, "init::canShootEnemyFromPose "+self.anim_pose);
			poseOffset = (0,0,0);
		}
		break;

	default:
		[[anim.assert]](0, "init::canShootEnemyFromPose - bad supplied pose: "+pose);
		poseOffset = (0,0,0);
		break;
	}

	if (isDefined(offset))
	{
		poseOffset = poseOffset + self LocalToWorldCoords(offset) - self.origin;
	}

	return canShootEnemyFrom ( poseOffset, undefined, useSightCheck );
}

canShootEnemyFrom ( offset, posOverrideEntity, useSightCheck )	// posOverrideEntity is optional, specifies a substitute enemy.
																// useSightCheck is optional, defaults to true.
{
	[[anim.println]]("CanShootEnemyFrom ",offset[0],", ",offset[1],", ",offset[2],", posOverride: ",posOverrideEntity,", useSightCheck: ",useSightCheck);
	if ( !isDefined(self.enemy) && !isDefined(posOverrideEntity) )
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
		if (canSee)
		{
			self thread drawDebugLine(myGunPos + myEyeOffset + offset, eye + (0,0,2), (.5,1,.5), 5);
		}
		else
		{
			self thread drawDebugLine(myGunPos + myEyeOffset + offset, eye + (0,0,2), (1,.5,.5), 5);
		}
	}
	else
		canSee = true;

	if (!canSee)
		return false;

	canShoot = self canshoot( eye, offset ) || self canshoot( chest, offset );

	if (canShoot)
	{
		self thread drawDebugLine(myGunPos + offset + (0,0,2), eye + (0,0,4), (.5,1,.5), 5);
	}
	else
	{
		self thread drawDebugLine(myGunPos + offset + (0,0,2), eye + (0,0,4), (1,.5,.5), 5);
	}

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


GetYawToEnemy()
{
	enemyPos = GetEnemyEyePos();
	angles = VectorToAngles(enemyPos-self.origin);
	return angles[1];
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy()
{
	yaw = self.angles[1] - GetYawToEnemy();
	if (yaw<0)
		yaw = -1 * yaw;
	return yaw;
}

choosePose(preferredPose)
{
	if (!isDefined(preferredPose))
	{
		preferredPose = self.anim_pose;
	}
	if (animscripts\combat::EnemiesWithinStandingRange())
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
	[[anim.println]]("ChoosePose chose "+resultPose);
	return resultPose;
}

// Melee stuff.  Note that isAlive is better than isDefined when you're checking variables that are either 
// undefined or set to an AI.
okToMelee(person)
{
	if (!isDefined(person))							homemade_error = crap_out_now + please;
	if (isDefined(self.anim_personImMeleeing))		// Tried to melee someone else when I am already meleeing, possibly because code changed my enemy.
	{
		ImNotMeleeing(self.anim_personImMeleeing);
		if (isDefined(self.anim_personImMeleeing))	homemade_error = crap_out_now + please;	
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
		if (isDefined(self.anim_personImMeleeing))	homemade_error = crap_out_now + please;	// Checking my logic1.  I shouldn't be meleeing at this point.
		if (isDefined(person.anim_personMeleeingMe))	homemade_error = crap_out_now + please;	// Checking my logic2.
		return true;
	}
	if (isDefined(self.anim_personImMeleeing))		homemade_error = crap_out_now + please;	// Checking my logic3.  I shouldn't be meleeing at this point.
	if (isDefined(person.anim_personMeleeingMe))	homemade_error = crap_out_now + please;	// Checking my logic4.
	return true;
}

IAmMeleeing(person)
{
	if (!isDefined(person))							homemade_error = crap_out_now + please;
	if (isDefined(person.anim_personMeleeingMe))	homemade_error = crap_out_now + please;
	if (isDefined(self.anim_personImMeleeing))		homemade_error = crap_out_now + please;
	person.anim_personMeleeingMe = self;
	self.anim_personImMeleeing = person;
}

ImNotMeleeing(person)
{
	// First check that everything is in synch, just for my own peace of mind.  This can go away once there are no bugs.
	if ( (isDefined(person)) && (isDefined(self.anim_personImMeleeing)) && (self.anim_personImMeleeing==person) )
	{
		if (!isDefined(person.anim_personMeleeingMe))	homemade_error = crap_out_now + please;
		if (person.anim_personMeleeingMe != self)	homemade_error = crap_out_now + please;
	}
	// This function does not require that I was meleeing Person to start with.  
	if (!isDefined(person))
	{
		self.anim_personImMeleeing = undefined;
	}
	else if ( (isDefined(person.anim_personMeleeingMe)) && (person.anim_personMeleeingMe==self) )
	{
		person.anim_personMeleeingMe = undefined;
		if (self.anim_personImMeleeing!=person)		homemade_error = crap_out_now + please;
		self.anim_personImMeleeing = undefined;
	}
	// A final check that I got this right...
	if ( (isDefined(person)) && (isDefined(self.anim_personImMeleeing)) && (self.anim_personImMeleeing==person) )
													homemade_error = crap_out_now + please;	// ImNotMeleeing didn't work for some reason.1
	if ( isDefined(person) && isDefined(person.anim_personMeleeingMe) && (person.anim_personMeleeingMe==self) )
													homemade_error = crap_out_now + please;	// ImNotMeleeing didn't work for some reason.2
}

WeaponAnims()
{
	weaponModel = getWeaponModel(self.weapon);
	if ( (isDefined(self.hasWeapon) && !self.hasWeapon) || weaponModel=="" )
		return "none";
	else
		return anim.AIWeapon[self.weapon]["anims"];
}

GetPlayer()
{
	if (!isDefined(anim.player))
		anim.player = getent("player", "classname" );

	return anim.player;
}

GetNode()
{
	myNode = self.node;
	if (!isDefined(self.node))
	{
		myNode = self GetStandingNode();
	}
	if (!isDefined(myNode))
	{
		self.anim_nodeDebugInfo = "No node found";
		return undefined;
	}
	myNodeDistance = distance ( myNode.origin, self.origin );
	if (myNodeDistance > 16)
	{
		self.anim_nodeDebugInfo = "Node of type "+myNode.type+" was too far ("+myNodeDistance+") away.";
		return undefined;
	}
	self.anim_nodeDebugInfo = "Node of type "+myNode.type+" was "+myNodeDistance+" away.";
	return myNode;
}

GetNodeType()
{
	myNode = GetNode();
	if (isDefined(myNode))
	{
		self.anim_nodeDebugInfo = self.anim_nodeDebugInfo + " (GetNode returned node of type "+myNode.type+".)";
		return myNode.type;
	}
	self.anim_nodeDebugInfo = self.anim_nodeDebugInfo + " (GetNode returned undefined.)";
	return "none";
}

GetNodeDirection()
{
	myNode = GetNode();
	if (isdefined(mynode))
	{
		[[anim.println]]("GetNodeDirection found node, returned: "+mynode.angles[1]);
		return mynode.angles[1];
	}
	[[anim.println]]("GetNodeDirection didn't find node, returned: "+self.desiredAngle);
	return self.desiredAngle;
}

GetNodeForward()
{
	myNode = GetNode();
	if (isdefined(mynode))
		return AnglesToForward ( mynode.angles );
	return (1,0,0);	// TODO Come up with a good return value here...
}

GetNodeOrigin()
{
	myNode = GetNode();
	if (isdefined(mynode))
		return mynode.origin;
	return self.origin;
}

isDebugOn()
{
	return ( (getcvar("animDebug") == 1) || ( isDefined (anim.debugEnt) && anim.debugEnt == self ) );
}

drawDebugLine(fromPoint, toPoint, color, durationFrames)
{
	if (isDebugOn())
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
}

drawDebugCross(atPoint, radius, color, durationFrames)
{
	if (isDebugOn())
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

UpdateDebugInfo()
{
	self endon("death");
    for (;;)
    {
		if ( isDefined (anim.debugEnt) && (anim.debugEnt==self) )
			doInfo = true;
		else
			doInfo = getCvarInt ("animscriptinfo");

		if (doInfo)
		{
			thread drawDebugInfoThread();
		}
		else
		{
			self notify ("EndDebugInfo");
		}
		wait 1;
    }
}


drawDebugInfoThread()
{
	self endon("EndDebugInfo");
	self endon("death");
	
	for(;;)
	{
		self drawDebugInfo();
		wait 0.05;
	}
}

drawDebugInfo()
{
	// What do we want to print?
	line[0] = self getEntityNumber()+" "+self.anim_script;
	line[1] = self.anim_pose+" "+self.anim_movement;
	line[2] = self.anim_alertness+" "+self.anim_special;
	line[3] = self.anim_lastDebugPrint;

	belowFeet = self.origin + (0,0,-8);	
	//aboveHead = self GetEye() + (0,0,8);
	offset = (0,0,-10);
	for (i=0 ; i<line.size ; i++)
	{
		textPos = ( belowFeet[0]+(offset[0]*i), belowFeet[1]+(offset[1]*i), belowFeet[2]+(offset[2]*i) );
		print3d (textPos, line[i], (.2, .2, 1), 1, 0.75);	// origin, text, RGB, alpha, scale
	}
}

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
	angle = (int)angle % 360;
	angle += 360;
	angle = (int)angle % 360;
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

		if ( isDefined(animarray["anim_run2alert"]) )
			playAnim ( animarray["anim_run2alert"] );	

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
			[[anim.putguninhand]]("left");
			playAnim ( animarray["anim_reload"] );	
			[[anim.putguninhand]](oldHand);
		}
		if ( isDefined(animarray["anim_grenade"]) )
		{
			[[anim.putguninhand]](animarray["gunhand_grenade"]);
			armpos = self LocalToWorldCoords(animarray["offset_grenade"]);
			animscripts\utility::drawDebugCross(armpos, 8, (0,1,0), 20);
			playAnim ( animarray["anim_grenade"] );	
			[[anim.putguninhand]](oldHand);
		}
	}
}

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
		print3d ((self GetEye()) + (0,0,8), stringtodraw, (1, 1, 1), 1, 0.2);
	}
}

// These strings are assembled in run, stop and combat scripts, to help provide a dump of program flow in the 
// case of an anim assert.
StartDebugString(newstring)
{
	if (0)
		self.anim_debug_string = newstring;
}

AddToDebugString(newstring)
{
	if (0)
	{
		if (!isDefined(self.anim_debug_string))
			self.anim_debug_string = "";
		self.anim_debug_string = self.anim_debug_string + newstring;
	}
}
