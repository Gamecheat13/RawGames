#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\debug;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree ("generic_human");

// Every script calls initAnimTree to ensure a clean, fresh, known animtree state.  
// ClearAnim should never be called directly, and this should never occur other than
// at the start of an animscript
// This function now also does any initialization for the scripts that needs to happen 
// at the beginning of every main script.
initAnimTree(animscript)
{
	if ( isValidEnemy( self.a.personImMeleeing ) )
	{
		ImNotMeleeing( self.a.personImMeleeing );
	}
    
    self ClearAnim( %body, 0.3 );
	self SetAnim( %body, 1, 0 );	// The %body node should always have weight 1.
	
	if ( animscript != "pain" && animscript != "death" && animscript != "react" )
		self.a.special = "none";
		
	self.missedSightChecks = 0;

	self.a.aimweight = 1.0;
	self.a.aimweight_start = 1.0;
	self.a.aimweight_end = 1.0;
	self.a.aimweight_transframes = 0;
	self.a.aimweight_t = 0;

	self.a.isAiming = false;
	
	self SetAnim( %shoot, 0, 0.2, 1 );
	
	IsInCombat();
	
	assert( IsDefined( animscript ), "Animscript not specified in initAnimTree" );
	self.a.prevScript = self.a.script;
	self.a.script = animscript;
	self.a.script_suffix = undefined;

	self animscripts\anims::clearAnimCache();
	
	// Call the handler to get out of Cowering pose.
	[[self.a.StopCowering]]();
}

// UpdateAnimPose does housekeeping at the start of every script's main function.  It does stuff like making prone 
// calculations are only being done if the character is actually prone.
UpdateAnimPose()
{
	assert( self.a.movement=="stop" || self.a.movement=="walk" || self.a.movement=="run", "UpdateAnimPose "+self.a.pose+" "+self.a.movement );
	
	if ( IsDefined( self.desired_anim_pose ) && self.desired_anim_pose != self.a.pose )
	{
		if ( self.a.pose == "prone" )
		{
			self ExitProneWrapper( 0.5 );
		}
			
		if ( self.desired_anim_pose == "prone" )
		{
			self SetProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up);
			self EnterProneWrapper(0.5); 
			self SetAnimKnobAll( animArray("straight_level", "combat"), %body, 1, 0.1, 1 );
		}		
	}
	
	self.desired_anim_pose = undefined;
}

initialize( animscript )
{
	if ( IsDefined( self.longDeathStarting ) )
	{
		if ( animscript != "pain" && animscript != "death" )
		{
			// we probably just came out of an animcustom.
			// just die, it's not safe to do anything else
			self DoDamage( self.health + 100, self.origin );
		}
		if ( animscript != "pain" )
		{
			self.longDeathStarting = undefined;
			self notify( "kill_long_death" );
		}
	}
	if ( IsDefined( self.a.mayOnlyDie ) && animscript != "death" )
	{
		// we probably just came out of an animcustom.
		// just die, it's not safe to do anything else
		self DoDamage( self.health + 100, self.origin );
	}

	// scripts can define this to allow cleanup before moving on
	if ( IsDefined( self.a.postScriptFunc ) )
	{
		scriptFunc = self.a.postScriptFunc;
		self.a.postScriptFunc = undefined;

		[[scriptFunc]]( animscript );
	}

	// put away sidearm if using one. Dont do this for specific pistol AI
	if ( animscript == "move" && usingSidearm() && (!IsDefined(self.forceSideArm) || !self.forceSideArm) )
	{
		if( !AIHasOnlyPistol() )
			self animscripts\combat::switchToLastWeapon( animArray("pistol_putaway", "combat"), true );
	}

	// if AI is using a sidearm and its not pistol AI then it should be forced to switch it back to the primaryweapon
	// it this AI is not pistol AI
	if( !AIHasOnlyPistol() && usingSidearm() && self.a.script == "combat" && animscript != "move" && !IS_TRUE( self.a.dontSwitchToPrimaryBeforeMoving ) )
		animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );	
		
	if( animscript != "combat" && animscript != "move" && animscript != "pain" )
		self.a.magicReloadWhenReachEnemy = false;
	
	if ( animscript != "death" )
		self.a.nodeath = false;
	
	if ( IsDefined( self.isHoldingGrenade ) && (animscript == "pain" || animscript == "death" || animscript == "flashed") )
			self dropGrenade();
	
	self.isHoldingGrenade = undefined;

	/#
	//thread checkGrenadeInHand( animscript );
	#/
	
	self animscripts\squadmanager::aiUpdateAnimState( animscript );
	
	/#
	if( IsDefined(self.a.script) && !self animscripts\debug::debugShouldClearState() )
	{
		self animscripts\debug::debugPopState( self.a.script );
	}
	else
	{
		self animscripts\debug::debugClearState();
	}

	self animscripts\debug::debugPushState( animscript );
	#/

	self.coverNode         = undefined;
	self.suppressed		   = false;
	self.isReloading	   = false;
	self.wasChangingCoverPos = self.changingCoverPos; // save this info, so that it can be useful in pain
	self.changingCoverPos  = false;
	self.a.scriptStartTime = GetTime();
	
	self.a.atConcealmentNode = false;
	self.a.atPillarNode = false;
	
	if ( IsDefined( self.node ) )
	{
		if( self.node.type == "Conceal Prone" || self.node.type == "Conceal Crouch" || self.node.type == "Conceal Stand" )
			self.a.atConcealmentNode = true;
		else if( self.node.type == "Cover Pillar" )
			self.a.atPillarNode = true;
	}
	
	initAnimTree( animscript );

	UpdateAnimPose();
}

/#
checkGrenadeInHand( animscript )
{
	// ensure no grenade left in hand
	self endon("killanimscript");
	
	// pain and death animscripts don't execute script between notifying killanimscript and starting the next animscript,
	// so the grenade cleanup thread might still be waiting to run.
	if ( animscript == "pain" || animscript == "death" )
	{
		wait .05;
		waittillframeend;
	}
	
	attachSize = self getattachsize();
	for ( i = 0; i < attachSize; i++ )
	{
		model = toLower( self getAttachModelName( i ) );
		assert( model != "weapon_m67_grenade", "AI has a grenade in hand after animscript finished. Please call over an animscripter! " + self.origin );
		assert( model != "weapon_m84_flashbang_grenade", "AI has a grenade in hand after animscript finished. Please call over an animscripter! " + self.origin );
		assert( model != "weapon_us_smoke_grenade", "AI has a grenade in hand after animscript finished. Please call over an animscripter! " + self.origin );
	}
}
#/

getPreferredWeapon()
{
	if ( IsDefined( self.wantshotgun ) && self.wantshotgun )
	{
		if ( weaponclass( self.primaryweapon ) == "spread" )
		{
			return self.primaryweapon;
		}
		else if ( weaponclass( self.secondaryweapon ) == "spread" )
		{
			return self.secondaryweapon;
		}
	}
	return self.primaryweapon;
}

badplacer(time, org, radius)
{
	for (i=0;i<time*20;i++)
	{
		for (p=0;p<10;p++)
		{
			angles = (0,RandomInt(360),0);
			forward = AnglesToForward(angles);
			scale = VectorScale(forward, radius);
			line (org, org + scale, (1,0.3,0.3));
		}
		wait(0.05);
	}
}

getOldRadius()
{
	self notify ("newOldradius");
	self endon ("newOldradius");
	self endon ("death");
	wait (6);
	self.goalradius = self.a.oldgoalradius;
}

// Returns whether or not the character should be acting like he's under fire or expecting an enemy to appear 
// any second.
IsInCombat()
{
	if ( isValidEnemy( self.enemy ) )
	{
		self.a.combatEndTime = GetTime() + anim.combatMemoryTimeConst + RandomInt(anim.combatMemoryTimeRand);
		return true;
	}

	return ( self.a.combatEndTime > GetTime() );
}

holdingWeapon()
{
	if (self.a.weaponPos["right"] == "none" && self.a.weaponPos["left"] == "none")
	{
		return (false);
	}
		
	if (!IsDefined (self.holdingWeapon))
	{
		return (true);
	}
		
	return (self.holdingWeapon);
}


// Takes a pose ("stand", "crouch", "prone") and an optional offset in local space, [forward, right, up].
canShootEnemyFromPose( pose, offset, useSightCheck )
{
	if( self.weapon == "mg42" )
	{
		return false;
	}
		
	switch (pose)
	{
		case "stand":
			if (self.a.pose == "stand")
			{
				poseOffset = (0,0,0);
			}
			else if (self.a.pose == "crouch")
			{
				poseOffset = (0,0,20);
			}
			else if (self.a.pose == "prone")
			{
				poseOffset = (0,0,55);
			}
			else
			{
				assert(0, "init::canShootEnemyFromPose "+self.a.pose);
				poseOffset = (0,0,0);
			}
			break;
	    
		case "crouch":
			if (self.a.pose == "stand")
			{
				poseOffset = (0,0,-20);
			}
			else if (self.a.pose == "crouch")
			{
				poseOffset = (0,0,0);
			}
			else if (self.a.pose == "prone")
			{
				poseOffset = (0,0,35);
			}
			else
			{
				assert(0, "init::canShootEnemyFromPose "+self.a.pose);
				poseOffset = (0,0,0);
			}
			break;

		case "prone":
			if (self.a.pose == "stand")
			{
				poseOffset = (0,0,-55);
			}
			else if (self.a.pose == "crouch")
			{
				poseOffset = (0,0,-35);
			}
			else if (self.a.pose == "prone")
			{
				poseOffset = (0,0,0);
			}
			else
			{
				assert(0, "init::canShootEnemyFromPose "+self.a.pose);
				poseOffset = (0,0,0);
			}
			break;

		default:
			assert(0, "init::canShootEnemyFromPose - bad supplied pose: "+pose);
			poseOffset = (0,0,0);
			break;
	}

	if (IsDefined(offset))
	{
		poseOffset = poseOffset + self LocalToWorldCoords(offset) - self.origin;
	}

	return canShootEnemyFrom( poseOffset, undefined, useSightCheck );
}

// posOverrideEntity is optional, specifies a substitute enemy.
// useSightCheck is optional, defaults to true.
canShootEnemyFrom( offset, posOverrideEntity, useSightCheck, posOverrideOrigin )
{
	if ( !isValidEnemy( self.enemy ) && !isValidEnemy( posOverrideEntity ) )
	{
 		return false;
	}
 		
	if ( !AIHasWeapon( self.weapon ) )
	{
		return false;
	}

	if (IsDefined(posOverrideEntity))
	{
		if (IsSentient(posOverrideEntity))
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
	else if (IsDefined(posOverrideOrigin))
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
	if (!IsDefined(useSightCheck))
	{
		useSightCheck = true;
	}

	if (useSightCheck)
	{
		// "Proper" way (doesn't work because CanSee cannot be called on a vector or with a vector as a parameter)
		//myEye = self GetShootAtPos();
		//myEye = myEye + offset;
		//canSee = myEye CanSee(self.enemy);
		// Simple way (not thorough enough for all cases)
		//canSee = self CanSee(self.enemy);
		// Hack way, using canShoot and adding the offset from muzzle to eye.
		myEyeOffset = ( self GetShootAtPos() - myGunPos );
		canSee = self canshoot( eye, myEyeOffset+offset );
		// Draw a debug line to my enemy's eye (or just above it, so that the player can see it if the enemy is him).
		/#
		if (canSee)
		{
			if (getdebugdvarint("anim_dotshow") == self getentnum())
			{
				if (GetDebugDvar ("anim_debug") == "3")
				{
					thread showDebugLine(myGunPos + myEyeOffset + offset, eye + (0,0,2), (.5,1,.5), 5);
				}
			}
		}
		else
		{
			if (getdebugdvarint("anim_dotshow") == self getentnum())
			{
				if (GetDebugDvar ("anim_debug") == "3")
				{
					thread showDebugLine(myGunPos + myEyeOffset + offset, eye + (0,0,2), (1,.5,.5), 5);
				}
			}
		}
		#/
	}
	else
	{
		canSee = true;
	}

	if (!canSee)
	{
		return false;
	}

	canShoot = self canshoot( eye, offset ) || self canshoot( chest, offset );

	/#
	if (canShoot)
	{
		if (getdebugdvarint("anim_dotshow") == self getentnum())
		{
			if (GetDebugDvar ("anim_debug") == "3")
			{
				thread showDebugLine(myGunPos + offset + (0,0,2), eye + (0,0,4), (.5,1,.5), 5);
			}
		}
	}
	else
	{
		if (getdebugdvarint("anim_dotshow") == self getentnum())
		{
			if (GetDebugDvar ("anim_debug") == "3")
			{
				thread showDebugLine(myGunPos + offset + (0,0,2), eye + (0,0,4), (1,.5,.5), 5);
			}
		}
	}
	#/

	return ( canShoot );
}


GetEnemyEyePos()
{
	if ( isValidEnemy( self.enemy ) )
	{
		self.a.lastEnemyPos = self.enemy GetShootAtPos();
		self.a.lastEnemyTime = GetTime();
		return self.a.lastEnemyPos;
	}
	else if (	IsDefined(self.a.lastEnemyTime)
				&& IsDefined(self.a.lastEnemyPos)
				&& (self.a.lastEnemyTime + 3000) < GetTime())
	{
		return self.a.lastEnemyPos;
	}
	else
	{
		// Return a point in front of you.  Note that the distance to this point is significant, because 
		// this function is used to determine an appropriate attack stance. 16 feet (196 units) seems good...
		targetPos = self GetShootAtPos();
		targetPos = targetPos + (196*self.lookforward[0], 196*self.lookforward[1], 196*self.lookforward[2]);
		return targetPos;
	}
}

GetNodeForwardYaw( node )
{
	type = node.type;

	if ( type == "Cover Left" )
	{
		return node.angles[1] + 90;
	}
	else if ( type == "Cover Right" )
	{
		return node.angles[1] - 90;
	}
	else if( type == "Cover Pillar" )
	{
		if( usingPistol() ) // AI_TODO: no pillar specific anims for pillar, use cover left or right instead
		{
			if( self.a.script == "cover_left" )
			{
				return node.angles[1] + 90;
			}
			else
			{
				return node.angles[1] - 90;
			}
		}
		else
		{
			return node.angles[1] - 180;
		}
	}

	return node.angles[1];
}

GetNodeYawToOrigin(pos)
{
	if (IsDefined (self.node))
	{
		yaw = self.node.angles[1] - GET_YAW(self, pos);
	}
	else
	{
		yaw = self.angles[1] - GET_YAW(self, pos);
	}
	
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetNodeYawToEnemy()
{
	pos = undefined;
	if ( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		if (IsDefined (self.node))
		{
			forward = AnglesToForward(self.node.angles);
		}
		else
		{
			forward = AnglesToForward(self.angles);
		}

		forward = VectorScale (forward, 150);
		pos = self.origin + forward;
	}
	
	if (IsDefined (self.node))
	{
		yaw = self.node.angles[1] - GET_YAW(self, pos);
	}
	else
	{
		yaw = self.angles[1] - GET_YAW(self, pos);
	}

	yaw = AngleClamp180( yaw );
	return yaw;
}

GetCoverNodeYawToEnemy()
{
	pos = undefined;
	if ( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = AnglesToForward(self.coverNode.angles + self.animarray["angle_step_out"][self.a.cornerMode]);
		forward = VectorScale (forward, 150);
		pos = self.origin + forward;
	}
	
	yaw = self.CoverNode.angles[1] + self.animarray["angle_step_out"][self.a.cornerMode] - GET_YAW(self, pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GET_YAW(self, pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}
// warning! returns (my yaw - yaw to enemy) instead of (yaw to enemy - my yaw)
GetYawToEnemy()
{
	pos = undefined;
	if ( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = AnglesToForward(self.angles);
		forward = VectorScale (forward, 150);
		pos = self.origin + forward;
	}
	
	yaw = self.angles[1] - GET_YAW(self, pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}

/* -- turned into a macro in animscripts\utility.gsh
GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}
*/

/* -- turned into a macro in animscripts\utility.gsh
GetPitch(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[0];
}
*/

/* -- turned into a macro in animscripts\utility.gsh
GetYaw2d(org)
{
	angles = VectorToAngles((org[0], org[1], 0)-(self.origin[0], self.origin[1], 0));
	return angles[1];
}
*/

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy()
{
	assert( isValidEnemy( self.enemy ) );
	
	yaw = self.angles[1] - GET_YAW(self, self.enemy.origin);
	yaw = AngleClamp180( yaw );
	
	return abs(yaw);
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy2d()
{
	assert( isValidEnemy( self.enemy ) );

	yaw = self.angles[1] - GET_YAW2D(self, self.enemy.origin);
	yaw = AngleClamp180( yaw );

	return abs(yaw);
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToOrigin(org)
{
	yaw = self.angles[1] - GET_YAW(self, org);
	yaw = AngleClamp180( yaw );

	return abs(yaw);
}

AbsYawToAngles(angles)
{
	yaw = self.angles[1] - angles;
	yaw = AngleClamp180( yaw );

	return abs(yaw);
}

GetYawFromOrigin(org, start)
{
	angles = VectorToAngles(org-start);
	return angles[1];
}

GetYawToTag(tag, org)
{
	yaw = self GetTagAngles( tag )[1] - GetYawFromOrigin(org, self GetTagOrigin(tag));
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYawToOrigin(org)
{
	yaw = self.angles[1] - GET_YAW(self, org);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetEyeYawToOrigin(org)
{
	yaw = self GetTagAngles("TAG_EYE")[1] - GET_YAW(self, org);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetCoverNodeYawToOrigin(org)
{
	yaw = self.coverNode.angles[1] + self.animarray["angle_step_out"][self.a.cornerMode] - GET_YAW(self, org);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetPitchToOrigin(org)
{
	pitch = self.angles[0] - GET_PITCH(self, org);
	pitch = AngleClamp180( pitch );
	return pitch;
}


isStanceAllowedWrapper( stance )
{
	if ( IsDefined( self.coverNode ) )
	{
		return self.coverNode doesNodeAllowStance( stance );
	}

	return self IsStanceAllowed( stance );
}


choosePose(preferredPose)
{
	if ( !IsDefined( preferredPose ) )
	{
		preferredPose = self.a.pose;
	}
	if ( EnemiesWithinStandingRange() )
	{
		preferredPose = "stand";
	}
	
	// Find out if we should be standing, crouched or prone
	switch (preferredPose)
	{
	case "stand":
		if (self isStanceAllowedWrapper("stand"))
		{
			resultPose = "stand";
		}
		else if (self isStanceAllowedWrapper("crouch"))
		{
			resultPose = "crouch";
		}
		else if (self isStanceAllowedWrapper("prone"))
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
		if (self isStanceAllowedWrapper("crouch"))
		{
			resultPose = "crouch";
		}
		else if (self isStanceAllowedWrapper("stand"))
		{
			resultPose = "stand";
		}
		else if (self isStanceAllowedWrapper("prone"))
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
		if (self isStanceAllowedWrapper("prone"))
		{
			resultPose = "prone";
		}
		else if (self isStanceAllowedWrapper("crouch"))
		{
			resultPose = "crouch";
		}
		else if (self isStanceAllowedWrapper("stand"))
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
		println ("utility::choosePose, called in "+self.a.script+" script: Unhandled anim_pose "+self.a.pose+" - using stand.");
		resultPose = "stand";
		break;
	}
	return resultPose;
}

// Melee stuff.  Note that IsAlive is better than IsDefined when you're checking variables that are either 
// undefined or set to an AI.
okToMelee(person)
{
	assert( IsDefined( person ) );
	if (IsDefined(self.a.personImMeleeing))		// Tried to melee someone else when I am already meleeing, possibly because code changed my enemy.
	{
		ImNotMeleeing(self.a.personImMeleeing);
		assert(!IsDefined(self.a.personImMeleeing));
	}
	
	if (IsDefined(person.a.personMeleeingMe))
	{
		// This means that oldAttacker was the last person to melee person.  He may or may not still be meleeing him.
		oldAttacker = person.a.personMeleeingMe;
		if ( IsDefined(oldAttacker.a.personImMeleeing) && oldAttacker.a.personImMeleeing == person )
		{
			// This means that oldAttacker is currently meleeing person.
			return false;
		}
		println("okToMelee - Shouldn't get to here");
		// This means that oldAttacker is no longer meleeing person and somehow person was never informed.  We can still handle it though.
		person.a.personMeleeingMe = undefined;
		assert(!IsDefined(self.a.personImMeleeing));
		assert(!IsDefined(person.a.personMeleeingMe));
		return true;
	}

	assert(!IsDefined(self.a.personImMeleeing));
	assert(!IsDefined(person.a.personMeleeingMe));
	return true;
}

IAmMeleeing(person)
{
	assert(IsDefined(person));
	assert(!IsDefined(person.a.personMeleeingMe));
	assert(!IsDefined(self.a.personImMeleeing));
	person.a.personMeleeingMe = self;
	self.a.personImMeleeing = person;
}

ImNotMeleeing(person)
{
	// First check that everything is in synch, just for my own peace of mind.  This can go away once there are no bugs.
	if ( (IsDefined(person)) && (IsDefined(self.a.personImMeleeing)) && (self.a.personImMeleeing==person) )
	{
		assert(IsDefined(person.a.personMeleeingMe));
		assert(person.a.personMeleeingMe == self);
	}
	// This function does not require that I was meleeing Person to start with.  
	if (!IsDefined(person))
	{
		self.a.personImMeleeing = undefined;
	}
	else if ( (IsDefined(person.a.personMeleeingMe)) && (person.a.personMeleeingMe==self) )
	{
		person.a.personMeleeingMe = undefined;
		assert(self.a.personImMeleeing==person);
		self.a.personImMeleeing = undefined;
	}
	// A final check that I got this right...
	assert( !IsDefined(person) || !IsDefined(self.a.personImMeleeing) || (self.a.personImMeleeing!=person) );
	assert( !IsDefined(person) || !IsDefined(person.a.personMeleeingMe) || (person.a.personMeleeingMe!=self) );
}

WeaponAnims()
{
	weaponModel = getWeaponModel( self.weapon );
	
	if ( (IsDefined(self.holdingWeapon) && !self.holdingWeapon) || weaponModel=="" )
	{
		return "none";
	}

	class = weaponClass( self.weapon );
	
	switch ( class )
	{
		case "smg":
			if( ( IS_TRUE(level.supportsPistolAnimations) || IS_TRUE( self.a.fakePistolWeaponAnims ) ) && self holdingWeapon() )
			{
				switch( self.weapon )
				{
					case "uzi_sp":
						// special case for militia AI
						// AI_TODO - find a better way to do this, this is getting too hacky
						if(IS_TRUE(self.a.noSMGPistolWeaponAnims))
							return "smg";
						return "pistol";
						
					// special case for dual wield AI
					// AI_TODO - find a better way to do this.					
					case "vector_sp":
					case "mp5k_sp":		
						if( IS_TRUE( self.a.fakePistolWeaponAnims ) )
							return "pistol";
						
					default:
						return "smg";
				}
			}
	
			return "rifle";
		case "mg":
			if( IS_TRUE(level.supportsMGAnimations) )
			{
				return "mg";
			}
			
			return "rifle";

		case "rifle":
		case "pistol":
		case "rocketlauncher":
		case "spread":
		case "gas": 			// MikeD (10/8/2007): Added flamethrower support
		case "grenade":
			return class;
			
		default:
//			assertMsg( "no animations for weapon class: " + class );
			return "rifle";
	}
}

GetClaimedNode()
{
	myNode = self.node;
	if ( IsDefined(myNode) && (self nearNode(myNode) || (IsDefined( self.coverNode ) && myNode == self.coverNode)) )
	{
		return myNode;
	}

	return undefined;
}

GetNodeType()
{
	myNode = GetClaimedNode();
	if (IsDefined(myNode))
	{
		return myNode.type;
	}

	return "none";
}

GetNodeDirection()
{
	myNode = GetClaimedNode();
	if (IsDefined(myNode))
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
	if (IsDefined(myNode))
	{
		return AnglesToForward ( myNode.angles );
	}

	return AnglesToForward( self.angles );
}

GetNodeOrigin()
{
	myNode = GetClaimedNode();
	if (IsDefined(myNode))
	{
		return myNode.origin;
	}

	return self.origin;
}

safemod(a,b)
{
	/*
	Here are some modulus results from in-game:
	10 % 3 = 1
	10 % -3 = 1
	-10 % 3 = -1
	-10 % -3 = -1
	however, we never want a negative result.
	*/
	result = int(a) % b;
	result += b;
	return result % b;
}

// Gives the result as an angle between 0 and 360
AngleClamp( angle )
{
	angleFrac = angle / 360.0;
	angle = (angleFrac - floor( angleFrac )) * 360.0;
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

QuadrantAnimWeights( yaw )
{
	// ALEXP 6/26/09: I don't understand why they'd want trig interpolation between angles instead of linear
	//forwardWeight = cos( yaw );
	//leftWeight    = sin( yaw );

	forwardWeight	= (90 - abs(yaw)) / 90;
	leftWeight		= (90 - AbsAngleClamp180(abs(yaw-90))) / 90;

	result["front"]	= 0;
	result["right"]	= 0;
	result["back"]	= 0;
	result["left"]	= 0;
	
	if ( IsDefined( self.alwaysRunForward ) )
	{
		assert( self.alwaysRunForward ); // always set alwaysRunForward to either true or undefined.
		
		result["front"] = 1;
		return result;
	}
	
	if( call_overloaded_func( "animscripts\run", "ShouldFaceMotionWhileRunning" ) )			
	{
		if ( forwardWeight > 0 )
		{		
			result["front"] = forwardWeight;
			if (leftWeight > 0)
				result["left"] = leftWeight;
			else
				result["right"] = -1 * leftWeight;
		}
		else
		{
			result["back"] = -1 * forwardWeight;
			if ( leftWeight > 0 )
				result["left"] = leftWeight;
			else
				result["right"] = -1 * leftWeight;
		}
	}
	else													
	{	
		if ( forwardWeight > 0 )
		{		
			if ( leftWeight > forwardWeight )
				result[ "left" ] = 1;
			else if ( leftWeight < -1 * forwardWeight )
				result[ "right" ] = 1;
			else
				result[ "front" ] = 1;
		}
		else
		{
			backWeight = -1 * forwardWeight;
			if ( leftWeight > backWeight )
				result["left"] = 1;
			else if ( leftWeight < forwardWeight )
				result["right"] = 1;
			else
				result["back"] = 1;
		}
	}

	/#QuadrantAnimWeightsDebugInfo(result);#/
	return result;
}

/#
QuadrantAnimWeightsDebugInfo(result)
{
	if( GetDvarInt( "ai_quadrantAnimDebug") > 0 )
		recordEntText( "Forward :" + result["front"] + "Left :" + result["left"] + "Right :" + result["right"] + "Back :" + result["back"], self, level.color_debug["green"], "Animscript" );
}
#/

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
		Print3d ((self GetDebugEye()) + (0,0,8), stringtodraw, (1, 1, 1), 1, 0.2);
	}
}

drawStringTime(msg, org, color, timer)
{
	maxtime = timer*20;
	for (i=0;i<maxtime;i++)
	{
		Print3d (org, msg, color, 1, 1);
		wait .05;
	}
}

hasEnemySightPos()
{
	if (IsDefined(self.node))
	{
		return (canSeeEnemyFromExposed() || canSuppressEnemyFromExposed());
	}
	else
	{
		return (canSeeEnemy() || canSuppressEnemy());
	}
}

getEnemySightPos()
{
	assert (self.goodShootPosValid);
	return self.goodShootPos;
}

canShootPos(pos)
{
	myGunPos = self GetTagOrigin ("tag_flash");
	myEyeOffset = ( self GetShootAtPos() - myGunPos );
	return (self canshoot( pos, myEyeOffset ));
}

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
	
	ent = SpawnStruct();
	ent thread debugTimeout();
	ent endon ("timeout");
	
	if (self.enemy.team == "allies")
	{
		color = (0.4, 0.7, 1);
	}
	else
	{
		color = (1, 0.7, 0.4);
	}
		
	while (1)
	{
		wait (0.05);
		Print3d (org, string, color, 1, size);	// origin, text, RGB, alpha, scale
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

printShootProc ()
{
	self endon ("death");
	self notify ("stop shoot " + self.export);
	self endon ("stop shoot " + self.export);

	const printTime = 0.25;

	for (i=0; i < printTime*20; i+=1)
	{
		wait (0.05);
		Print3d (self.origin + (0,0,70), "Shoot", (1,0,0), 1, 1);	// origin, text, RGB, alpha, scale
	}
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

showDebugLine( fromPoint, toPoint, color, printTime )
{
	self thread showDebugProc( fromPoint, toPoint +( 0, 0, -5 ), color, printTime );
}

shootEnemyWrapper()
{
	self shoot_notify_wrapper();

	// MikeD (10/8/2007): Added flamethrower support.
	if( self usingGasWeapon() )
	{
		[[ anim.shootFlameThrowerWrapper_func ]]();
	}
	else
	{
		[[ anim.shootEnemyWrapper_func ]]();
	}
}

shootEnemyWrapper_normal()
{
	self.a.lastShootTime = GetTime();

	// set accuracy at time of shoot rather than in a separate thread that is vulnerable to timing issues
	maps\_gameskill::set_accuracy_based_on_situation();
	
	self shoot( self.script_accuracy );
}	

shootFlameThrowerWrapper_normal()
{
	self.a.lastShootTime = GetTime();

	// set accuracy at time of shoot rather than in a separate thread that is vulnerable to timing issues
	maps\_gameskill::set_accuracy_based_on_situation();

	if( !self.a.flamethrowerShootSwitch && self.a.lastShootTime > self.a.flamethrowerShootSwitchTimer )
	{
		self.a.flamethrowerShootSwitch = true;
		self.a.flamethrowerShootSwitchTimer = self.a.lastShootTime + RandomIntRange( self.a.flamethrowerShootTime_min, self.a.flamethrowerShootTime_max );

		self shoot( self.script_accuracy );

///#
//		println( "STOP -- self.a.flamethrowerSwitchTimer = " , ( self.a.flamethrowerShootSwitchTimer - self.a.lastShootTime ) * 0.001 ); 
//#/
	}
	else if( self.a.flamethrowerShootSwitch && self.a.lastShootTime > self.a.flamethrowerShootSwitchTimer )
	{
		self.a.flamethrowerShootSwitch = false;
		flamethrower_stop_shoot();
		self.a.flamethrowerShootSwitchTimer = self.a.lastShootTime + RandomIntRange( self.a.flamethrowerShootDelay_min, self.a.flamethrowerShootDelay_max );

///#
//		println( "NEXT -- self.a.flamethrowerSwitchTimer = " , ( self.a.flamethrowerShootSwitchTimer - self.a.lastShootTime ) * 0.001 ); 
//#/
	}
}

// MikeD (10/8/2007): Stop the Flamethrower AI from shooting.
flamethrower_stop_shoot( set_switch_timer )
{
	if( self usingGasWeapon() )
	{
		if( IsDefined( set_switch_timer ) )
		{
			self.a.flamethrowerShootSwitchTimer = GetTime() + set_switch_timer;
			self.a.flamethrowerShootSwitch = false;
		}
		
		self notify( "flame stop shoot" );

		self StopShoot();
	}
}

shootPosWrapper( shootPos )
{
	self shoot_notify_wrapper();

	endpos = bulletSpread( self GetTagOrigin( "tag_flash" ), shootPos, 4 );

	self.a.lastShootTime = GetTime();

	self shoot( 1, endpos );
	//if ( self weaponAnims() != "rocketlauncher" )
		//self shootBlank( 1, endpos );
}	

getAimDelay()
{
//	if (level.aim_delay_off)
/*		
	if ((IsAlive(self.enemy)) && ( IsPlayer(self.enemy) ))
	{
		dist = distance (self.origin, self.enemy.origin);
		delay = dist * 0.004;
		delay -= 1;
		delay = delay * 0.5;
		delay += RandomFloat(delay);
//		println ("^7Delaying fire from distance " + dist + " for " + delay + " second");
		if (delay > 0)
			return (delay);
	}
*/	
	return 0.001;
}

setEnv(env)
{
	if (env == "cold")
	{
		array_thread(GetAIArray(),::PersonalColdBreath);
		array_thread(getspawnerarray(),::PersonalColdBreathSpawner);
	}
}

PersonalColdBreath()
{
	tag = "TAG_EYE";
	
	self endon ("death");
	self notify ("stop personal effect");
	self endon ("stop personal effect");

	for (;;)
	{
		if (self.a.movement != "run")
		{
			playfxOnTag ( level._effect["cold_breath"], self, tag );
			wait (2.5 + RandomFloat(3));
		}
		else
		{
			wait (0.5);
		}
	}
}

PersonalColdBreathSpawner()
{
	self endon ("death");
	self notify ("stop personal effect");
	self endon ("stop personal effect");

	for (;;)
	{
		self waittill ("spawned", Spawn);
		if (maps\_utility::spawn_failed(Spawn))
		{
			continue;
		}

		Spawn thread PersonalColdBreath();
	}
}

isSuppressedWrapper()
{
	if ( !IsDefined( self.a ) )
		return false;
	
	if( shouldForceBehavior( "cover_suppressed" ) )
		return true;
	
	// ALEXP_MOD (9/9/09): if player is aiming at stepout pos, don't go exposed
	if( IsDefined(self.coverNode) && IsDefined(self.playerAimSuppression) && self.playerAimSuppression )
	{
		/#recordEntText( "Is Aim Suppressed", self, level.color_debug["white"], "Suppression" );#/
		return true;
	}

	if( IS_TRUE( self.a.favor_suppressedBehavior ) )
	{
		if ( self.suppressionMeter > self.suppressionThreshold * 0.25 )
			return true;			
	}
	
	if(self.suppressionMeter <= self.suppressionThreshold)
		return false;
	
	return self issuppressed();	// takes into account .ignoreSuppression
}

// if not suppressed, sometimes we still want to look cautious, like leaning out of a corner instead of stepping out.
// this determines whether we should do that or not.
isPartiallySuppressedWrapper()
{
	if( shouldForceBehavior( "cover_suppressed" ) )
		return true;

	// ALEXP_MOD (9/9/09): if player is aiming at stepout pos, don't go exposed
	if ( IsDefined(self.coverNode) && IsDefined(self.playerAimSuppression) && self.playerAimSuppression )
	{
		/#recordEntText( "Is Aim Suppressed", self, level.color_debug["white"], "Suppression" );#/
		return true;
	}

	if ( self.suppressionMeter <= self.suppressionThreshold * 0.25 )
		return false;
	
	return ( self issuppressed() );	// takes into account .ignoreSuppression
}

getNodeOffset(node)
{
	if ( IsDefined( node.offset ) )
	{
		return node.offset;
	}

	//(right offset, forward offset, vertical offset)
	// you can get an actor's current eye offset by setting scr_eyeoffset to his entnum.
	// this should be redone whenever animations change significantly.
	cover_left_crouch_offset = 	(-26, .4, 36);
	cover_left_stand_offset = 	(-32, 7, 63);
	cover_right_crouch_offset = (43.5, 11, 36);
	cover_right_stand_offset = 	(36, 8.3, 63);
	cover_crouch_offset = 		(3.5, -12.5, 45); // maybe we could account for the fact that in cover crouch he can stand if he needs to?
	cover_stand_offset = 		(-3.7, -22, 63);

	const cornernode = false;
	nodeOffset = (0,0,0);
	
	right = AnglesToRight(node.angles);
	forward = AnglesToForward(node.angles);

	switch(node.type)
	{
	case "Cover Left":
		if ( node isNodeDontStand() && !node isNodeDontCrouch() )
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_left_crouch_offset );
		}
		else
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_left_stand_offset );
		}
		break;

	case "Cover Right":
		if ( node isNodeDontStand() && !node isNodeDontCrouch() )
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_right_crouch_offset );
		}
		else
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_right_stand_offset );
		}
		break;

	case "Cover Stand":
	case "Conceal Stand":
	case "Turret":
		nodeOffset = calculateNodeOffset( right, forward, cover_stand_offset );
		break;

	case "Cover Crouch":
	case "Cover Crouch Window":
	case "Conceal Crouch":
		nodeOffset = calculateNodeOffset( right, forward, cover_crouch_offset );
		break;
	}

	node.offset = nodeOffset;
	return node.offset;
}

calculateNodeOffset( right, forward, baseoffset )
{
	return VectorScale( right, baseoffset[0] ) + VectorScale( forward, baseoffset[1] ) + (0, 0, baseoffset[2]);
}

recentlySawEnemy()
{
	return( isdefined( self.enemy ) && self seeRecently( self.enemy, 5 ) );
}

canSeeEnemy()
{
	if ( !isValidEnemy( self.enemy ) )
	{
		return false;
	}
	
	if ( (self canSee(self.enemy) && checkPitchVisibility(self geteye(), self.enemy GetShootAtPos()) ) || 
		 (IsDefined(self.cansee_override) && self.cansee_override) )
	{		
		self.goodShootPosValid = true;
		self.goodShootPos = GetEnemyEyePos();
		
		dontGiveUpOnSuppressionYet();
		
		return true;
	}
	
	return false;
}

canSeeEnemyFromExposed()
{
	if ( !isValidEnemy( self.enemy ) )
	{
		self.goodShootPosValid = false;
		return false;
	}

	enemyEye = GetEnemyEyePos();
	if ( !IsDefined( self.node ) )
	{
		result = self canSee( self.enemy );
	}
	else
	{
		result = canSeePointFromExposedAtNode( enemyEye, self.node );
	}
	
	if ( result )
	{
		self.goodShootPosValid = true;
		self.goodShootPos = enemyEye;
		
		dontGiveUpOnSuppressionYet();
	}
	else
	{
		/#
		if ( self getentnum() == getdebugdvarint("anim_dotshow") )
		{
			thread persistentDebugLine( self.node.origin + getNodeOffset( self.node ), enemyEye );
		}
		#/
	}
	
	return result;
}

canSeePointFromExposedAtNode( point, node )
{
	if ( node.type == "Cover Left" || node.type == "Cover Right" )
	{
		if ( !self call_overloaded_func( "animscripts\cover_corner", "canSeePointFromExposedAtCorner", point, node ) )
		{
			return false;
		}
	}
	
	nodeOffset = getNodeOffset( node );
	lookFromPoint = node.origin + nodeOffset;
	
	if( node.type == "Cover Pillar" )
	{
		nodeOffsets = [];

		// AI_TODO: update these numbers once final pillar alert_2_b's are made
		if( node isNodeDontStand() || self.a.pose == "crouch" )
		{
			if( !node IsNodeDontRight() )
				nodeOffsets[ nodeOffsets.size ] = (-28, -10, 30);
					
			if( !node IsNodeDontLeft() )
				nodeOffsets[ nodeOffsets.size ] = (32, -10, 30);
		}
		else
		{
			if( !node IsNodeDontRight() )
				nodeOffsets[ nodeOffsets.size ] = (-32, 3.7, 60);
				
			if( !node IsNodeDontLeft() )
				nodeOffsets[ nodeOffsets.size ] = (34, 0.2, 60);
		}

		// check out the direction he's already facing first
		if( nodeOffsets.size > 1 && IsDefined( self.cornerDirection ) && self.cornerDirection == "left" )
			nodeOffsets = array_swap( nodeOffsets, 0, 1 );
		
		right		  = AnglesToRight(node.angles);
		forward		  = AnglesToForward(node.angles);
		nodeOffset	  = calculateNodeOffset( right, forward, nodeOffsets[0] );
		lookFromPoint = node.origin + nodeOffset;

		///#
		/*if( nodeOffsets[0][0] < 0 )
		{
			record3dtext( "right", lookFromPoint, (1,0,0), "Animscript" );
			recordLine( lookFromPoint, point, (1,0,0), "Animscript", self );
		}
		else
		{
			record3dtext( "left", lookFromPoint, (0,1,0), "Animscript" );
			recordLine( lookFromPoint, point, (0,1,0), "Animscript", self );
		}*/
		//#/

		if( canSeePointFromExposedAtNodeWithOffset(point, node, lookFromPoint) )
		{
			//recordLine( lookFromPoint, point, (0,0,1), "Animscript", self );
			node.offset = nodeOffset;
			return true;
		}
		
		return false;
	}
	else if( !canSeePointFromExposedAtNodeWithOffset(point, node, lookFromPoint) )
	{
		return false;
	}
	
	return true;
}

canSeePointFromExposedAtNodeWithOffset( point, node, lookFromPoint )
{
	if ( !checkPitchVisibility( lookFromPoint, point, node ) )
	{
		return false;
	}
	
	if ( !sightTracePassed( lookFromPoint, point, false, undefined ) )
	{
		if ( node.type == "Cover Crouch" || node.type == "Conceal Crouch" )
		{
			// also consider the ability to stand at crouch nodes
			lookFromPoint = (0,0,64) + node.origin;
			return sightTracePassed( lookFromPoint, point, false, undefined );
		}
		
		return false;
	}

	return true;
}

checkPitchVisibility( fromPoint, toPoint, atNode )
{
	// check vertical angle is within our aiming abilities
	
	pitch = AngleClamp180( VectorToAngles( toPoint - fromPoint )[0] );
	if ( abs( pitch ) > 45 )
	{
		if ( IsDefined( atNode ) && atNode.type != "Cover Crouch" && atNode.type != "Conceal Crouch" )
		{
			return false;
		}

		if ( pitch > 45 || pitch < anim.coverCrouchLeanPitch - 45 )
		{
			// it should be ok to shoot the target at our feet
			dist = DistanceSquared( fromPoint, toPoint );
			if( pitch < 75 && dist  < 64*64 )
			{
				return true;
			}

			return false;
		}
	}
	return true;
}

dontGiveUpOnSuppressionYet()
{
	// we'll reset the giveUpOnSuppression timer the next time we want to suppress
	self.a.shouldResetGiveUpOnSuppressionTimer = true;
}
updateGiveUpOnSuppressionTimer()
{
	if ( !IsDefined( self.a.shouldResetGiveUpOnSuppressionTimer ) )
	{
		self.a.shouldResetGiveUpOnSuppressionTimer = true;
	}
	
	if ( self.a.shouldResetGiveUpOnSuppressionTimer )
	{
		// after this time, we will decide that our enemy might not be where we thought they were
		// this will cause us to look for better cover
		self.a.giveUpOnSuppressionTime = GetTime() + randomintrange( 15000, 30000 );
		
		self.a.shouldResetGiveUpOnSuppressionTimer = false;
	}
}

aiSuppressAI()
{
	if ( !self canAttackEnemyNode() )
	{
		return false;
	}

	shootPos = undefined;
	if ( IsDefined( self.enemy.node ) )
	{
		nodeOffset = getNodeOffset(self.enemy.node);
		shootPos = self.enemy.node.origin + nodeOffset;
	}
	else
	{
		shootPos = self.enemy GetShootAtPos();
	}
	
	// canAttackEnemyNode sometimes returns true even though we can't see the point, because
	// our eye pos is not right at our node's offset
	if ( !self canShoot( shootPos ) )
	{
		return false;
	}

	if( self.a.script == "combat" )
	{
		// make sure we can also see the tip of our gun
		if( !sighttracepassed( self geteye(), self GetTagOrigin( "tag_flash" ), false, undefined ) )
		{
			return false;
		}
	}
	
	self.goodShootPosValid = true;
	self.goodShootPos = shootPos;
	return true;
}

canSuppressEnemyFromExposed()
{
	// FromExposed includes checking from the offset of the node the AI is at
	
	if ( !hasSuppressableEnemy() )
	{
		self.goodShootPosValid = false;
		return false;
	}

	if ( !IsPlayer(self.enemy) )
	{
		return aiSuppressAI();
	}

	if ( IsDefined(self.node) )
	{
		if ( self.node.type == "Cover Left" || self.node.type == "Cover Right" )
		{
			// Don't try to shoot at stuff behind the node
			if ( !self call_overloaded_func( "animscripts\cover_corner", "canSeePointFromExposedAtCorner", self GetEnemyEyePos(), self.node ) )
			{
				return false;
			}
		}
		
		nodeOffset = getNodeOffset(self.node);
		startOffset = self.node.origin + nodeOffset;
	}
	else
	{
		startOffset = self GetTagOrigin ("tag_flash");
	}

	if ( !checkPitchVisibility( startOffset, self.lastEnemySightPos ) )
	{
		return false;
	}
	
	return findGoodSuppressSpot(startOffset);
}

canSuppressEnemy()
{
	if ( !hasSuppressableEnemy() )
	{
		self.goodShootPosValid = false;
		return false;
	}

	hasTagFlash = self GetTagOrigin ("tag_flash");
	if( !IsDefined( hasTagFlash ) )
		return false;

	if ( !IsPlayer(self.enemy) )
	{
		return aiSuppressAI();
	}

	startOffset = self GetTagOrigin ("tag_flash");

	if ( !checkPitchVisibility( startOffset, self.lastEnemySightPos ) )
	{
		return false;
	}

	return findGoodSuppressSpot(startOffset);
}

hasSuppressableEnemy()
{
	if ( !isValidEnemy( self.enemy ) )
	{
		return false;
	}
	
	if ( !IsDefined(self.lastEnemySightPos) )
	{
		return false;
	}
	
	updateGiveUpOnSuppressionTimer();
	if ( GetTime() > self.a.giveUpOnSuppressionTime )
	{
		return false;
	}
	
	if ( !needRecalculateSuppressSpot() )
	{
		return self.goodShootPosValid;
	}

	return true;
}

canSeeAndShootPoint( point )
{
	if ( !sightTracePassed( self GetShootAtPos(), point, false, undefined ) )
	{
		return false;
	}

	if ( self.a.weaponPos["right"] == "none" )
	{
		return false;
	}

	gunpoint = self GetTagOrigin ("tag_flash");
	
	return sightTracePassed( gunpoint, point, false, undefined );
}

needRecalculateSuppressSpot()
{
	if ( self.goodShootPosValid && !self canSeeAndShootPoint( self.goodShootPos ) )
	{
		return true;
	}
	
	// we need to recalculate the suppress spot
	// if we've moved or if we saw our enemy in a different place than when we
	// last calculated it
	return (
		!IsDefined(self.lastEnemySightPosOld) ||
		self.lastEnemySightPosOld != self.lastEnemySightPos ||
		DistanceSquared( self.lastEnemySightPosSelfOrigin, self.origin ) > 1024 // 1024 = 32 * 32
		);
}

findGoodSuppressSpot(startOffset)
{
	if ( !needRecalculateSuppressSpot() )
	{
		return self.goodShootPosValid;
	}
	
	// make sure we can see from our eye to our gun; if we can't then we really shouldn't be trying to suppress at all!
	if ( !sightTracePassed(self GetShootAtPos(), startOffset, false, undefined) )
	{
		self.goodShootPosValid = false;
		return false;
	}
	
	self.lastEnemySightPosSelfOrigin = self.origin;
	self.lastEnemySightPosOld = self.lastEnemySightPos;
	
	currentEnemyPos = GetEnemyEyePos();
	
	trace = bullettrace(self.lastEnemySightPos, currentEnemyPos, false, undefined);
	startTracesAt = trace["position"];
	
	percievedMovementVector = self.lastEnemySightPos - startTracesAt;
	lookVector = VectorNormalize( self.lastEnemySightPos - startOffset );
	percievedMovementVector = percievedMovementVector - VectorScale( lookVector, vectorDot( percievedMovementVector, lookVector ) );
	// percievedMovementVector is what self.lastEnemySightPos - startTracesAt looks like from our position (that is, projected perpendicular to the direction we're looking).
	
	const idealTraceInterval = 20.0;
	
	numTraces = int( Length( percievedMovementVector ) / idealTraceInterval + 0.5 ); // one trace every 20 units, ideally
	if ( numTraces < 1 )
	{
		numTraces = 1;
	}

	if ( numTraces > 20 )
	{
		numTraces = 20; // cap it 
	}

	vectorDif = self.lastEnemySightPos - startTracesAt;
	vectorDif = (vectorDif[0]/numTraces, vectorDif[1]/numTraces, vectorDif[2]/numTraces);
	numTraces++; // to get both start and end points for traces
	
	traceTo = startTracesAt;
	/#
	if (getdebugdvarint("debug_dotshow") == self getentnum())
	{
		thread print3dtime(15, self.lastEnemySightPos, "lastpos", (1, .2, .2), 1, 0.75);	// origin, text, RGB, alpha, scale
		thread print3dtime(15, startTracesAt, "currentpos", (1, .2, .2), 1, 0.75);	// origin, text, RGB, alpha, scale
	}
	#/
	
	self.goodShootPosValid = false;

	goodTraces = 0;
	const neededGoodTraces = 2; // we stop at 3 good traces away from the cover where they disappeared, should be about 40 units
	for ( i = 0; i < numTraces + neededGoodTraces; i++ )
	{
		tracePassed = sightTracePassed(startOffset, traceTo, false, undefined);
		thisTraceTo = traceTo;
		
		/#
		if (getdebugdvarint("debug_dotshow") == self getentnum())
		{
			if ( tracePassed )
			{
				color = (.2,.2,1);
			}
			else
			{
				color = (.2,.2,.2);
			}

			//showDebugLine(startOffset, traceTo, color, 0.75);
			thread print3dtime(15, traceTo, ".", color, 1, 0.75);	// origin, text, RGB, alpha, scale
		}
		#/
		
		// after we've hit self.lastEnemySightPos, look only perpendicular to our line of sight
		if ( i == numTraces - 1 )
		{
			vectorDif = vectorDif - VectorScale( lookVector, vectorDot( vectorDif, lookVector ) );
		}
		
		traceTo += vectorDif; // for next time
		
		if (tracePassed)
		{
			goodTraces++;
			
			self.goodShootPosValid = true;
			self.goodShootPos = thisTraceTo;
			
			// if first trace succeeded, we take it, because it probably means they're crouched under cover and we can shoot over it
			if ( i > 0 && goodTraces < neededGoodTraces && i < numTraces + neededGoodTraces - 1 )
			{
				continue;
			}
			
			return true;
		}
		else
		{
			goodTraces = 0;
		}
	}
	
	return self.goodShootPosValid;
}

// Returns an animation from an array of animations with a corresponding array of weights.
anim_array(animArray, animWeights)
{
	total_anims = animArray.size;
	idleanim = RandomInt(total_anims);
	
	assert (total_anims);
	assert (animArray.size == animWeights.size);
	
	if (total_anims == 1)
	{
		return animArray[0];
	}
		
	total_weight = 0;
	
	for (i = 0; i < total_anims; i++)
	{
		total_weight += animWeights[i];
	}
	
	anim_play = RandomFloat(total_weight);
	current_weight	= 0;
	
	for (i = 0; i < total_anims; i++)
	{
		current_weight += animWeights[i];
		if (anim_play >= current_weight)
		{
			continue;
		}

		idleanim = i;
		break;
	}
	
	return animArray[idleanim];
}		

print3dtime(timer, org, msg, color, alpha, scale)
{
	newtime = timer / 0.05;
	for (i=0;i<newtime;i++)
	{
		Print3d (org, msg, color, alpha, scale);
		wait (0.05);
	}
}

crossproduct(vec1, vec2)
{
	return (vec1[0]*vec2[1] - vec1[1]*vec2[0] > 0);
}

scriptChange()
{
	self.a.current_script = "none";
	self notify (anim.scriptChange);
}

getGrenadeModel()
{
	return getWeaponModel(self.grenadeweapon);
}

canThrowGrenade()
{
	if (!self.grenadeAmmo)
	{
		return false;
	}
	
	if (self.script_forceGrenade)
	{
		return true;
	}
		
	return (IsPlayer(self.enemy));
}

usingGasWeapon()
{
	return ( weaponIsGasWeapon( self.weapon ) );
}

metalHat()
{
	if (!IsDefined (self.hatmodel))
	{
		return false;
	}
	
	return (IsDefined(anim.metalHat[self.model]));
}

/* DEAD CODE REMOVAL 
setFootstepEffect(name, fx)
{
	assert(IsDefined(fx), "Need to define the footstep effect.");

	// deprecated since effects are all clientside now
}
*/

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
	if (self.a.pose != "prone")
	{
		self.a.pose = "prone";
	}
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
	if (self.a.pose == "prone")
	{
		self.a.pose = "crouch";
	}
}

canHitSuppressSpot()
{
	if (!hasEnemySightPos())
	{
		return false;
	}

	myGunPos = self GetTagOrigin ("tag_flash");
	return (sightTracePassed(myGunPos, getEnemySightPos(), false, undefined));
}

getHighestNodeStance() // self = node
{
	if( isNodeDontStand() ) // check for stand
	{
		if( isNodeDontCrouch() ) // check for crouch
		{
			if( isNodeDontProne() ) // check for prone
			{
				AssertMsg( "Node at"  + self.origin + "supports no stance." );
			}
			else
			{
				return "prone";
			}
		}
		else
		{
			return "crouch";
		}
	}
	else
	{
		return "stand";
	}
}

isNodeDontStand()
{
	return ( self has_spawnflag( SPAWNFLAG_PATH_DONT_STAND ) );
}

isNodeDontCrouch()
{
	return ( self has_spawnflag( SPAWNFLAG_PATH_DONT_CROUCH ) );
}

isNodeDontProne()
{
	return ( self has_spawnflag( SPAWNFLAG_PATH_DONT_PRONE ) );
}

doesNodeAllowStance( stance )
{
	if ( stance == "stand" )
	{
		return !self isNodeDontStand();
	}
	else if ( stance == "crouch" )
	{
		return !self isNodeDontCrouch();
	}
	else
	{
		assert( stance == "prone" );
		return !self isNodeDontProne();
	}
}

isNodeDontLeft()
{
	return ( self has_spawnflag( SPAWNFLAG_PATH_DONT_RIGHT ) );
}

isNodeDontRight()
{
	return ( self has_spawnflag( SPAWNFLAG_PATH_DONT_LEFT ) );
}

getAIPrimaryWeapon()
{
	return self.primaryweapon;
}

getAISecondaryWeapon()
{
	return self.secondaryweapon;
}

getAISidearmWeapon()
{
	return self.sidearm;
}

getAICurrentWeapon()
{
	return self.weapon;
}

usingSecondary()
{
	return ( self.weapon == self.secondaryweapon );
}

usingSidearm()
{
	return ( self.weapon == self.sidearm );
}

getAICurrentWeaponSlot()
{
	if ( self.weapon == self.primaryweapon )
	{
		return "primary";
	}
	else if ( self.weapon == self.secondaryweapon )
	{
		return "secondary";
	}
	else if ( self.weapon == self.sidearm )
	{
		return "sidearm";
	}
	else
	{
		assertMsg( "self.weapon does not match any known slot" );
	}
}

AIHasWeapon( weapon )
{
	if ( IsDefined(weapon) && weapon != "" && IsDefined( self.weaponInfo[weapon] ) )
	{
		return true;
	}
	
	return false;
}

AIHasPrimaryWeapon()
{
	return ( self.primaryweapon != "" && self.primaryweapon != "none" );
}

AIHasSecondaryWeapon()
{
	return ( self.secondaryweapon != "" && self.secondaryweapon != "none" );
}

AIHasSidearm()
{
	return ( self.sidearm != "" && self.sidearm != "none" );
}

AIHasOnlyPistol()
{
	holdingSMG = WeaponClass(self.weapon) == "smg";

	return ( self.primaryweapon == self.weapon && usingPistol() && !holdingSMG );
}

AIHasOnlyPistolOrSMG()
{
	class = weaponClass( self.weapon );
	holdingPistolLikeSMG = class == "smg" && self WeaponAnims() == "pistol";

	return ( ( self.primaryweapon == self.weapon && usingPistol() ) || holdingPistolLikeSMG );
}

getAnimEndPos( theanim )
{
	moveDelta = GetMoveDelta( theanim, 0, 1 );
	return self localToWorldCoords( moveDelta );
}

isValidEnemy( enemy )
{
	if ( !IsDefined( enemy ) )
	{
		return false;
	}

	// dead enemies should be valid. AI don't acquire a new enemy until their enemy is done with the death animation, so it's better for them
	// to shoot at a dead enemy for a short time than look like they think they have nothing to do.
	//else if ( IsSentient( enemy ) && !IsAlive( enemy ) && !IsPlayer( enemy ) )
	//	return false;
	
	return true;
}


damageLocationIsAny( a, b, c, d, e, f, g, h, i, j, k, ovr )
{
	/* possibile self.damageLocation's:
		"torso_upper"
		"torso_lower"
		"helmet"
		"head"
		"neck"
		"left_arm_upper"
		"left_arm_lower"
		"left_hand"
		"right_arm_upper"
		"right_arm_lower"
		"right_hand"
		"gun"
		"none"
		"left_leg_upper"
		"left_leg_lower"
		"left_foot"
		"right_leg_upper"
		"right_leg_lower"
		"right_foot"
	*/

	if (!IsDefined(self.damageLocation))
	{
		return false;
	}

	if ( !IsDefined( a ) ) return false; if ( self.damageLocation == a ) return true;
	if ( !IsDefined( b ) ) return false; if ( self.damageLocation == b ) return true;
	if ( !IsDefined( c ) ) return false; if ( self.damageLocation == c ) return true;
	if ( !IsDefined( d ) ) return false; if ( self.damageLocation == d ) return true;
	if ( !IsDefined( e ) ) return false; if ( self.damageLocation == e ) return true;
	if ( !IsDefined( f ) ) return false; if ( self.damageLocation == f ) return true;
	if ( !IsDefined( g ) ) return false; if ( self.damageLocation == g ) return true;
	if ( !IsDefined( h ) ) return false; if ( self.damageLocation == h ) return true;
	if ( !IsDefined( i ) ) return false; if ( self.damageLocation == i ) return true;
	if ( !IsDefined( j ) ) return false; if ( self.damageLocation == j ) return true;
	if ( !IsDefined( k ) ) return false; if ( self.damageLocation == k ) return true;
	assert( !IsDefined(ovr), "Too many parameters" );
	return false;
}

usingRifle()
{
	return weaponClass( self.weapon ) == "rifle";
}

usingShotgun()
{
	return weaponClass( self.weapon ) == "spread";
}

usingRocketLauncher()
{
	return weaponClass( self.weapon ) == "rocketlauncher";
}

usingGrenadeLauncher()
{
	return weaponClass( self.weapon ) == "grenade";
}

usingPistol()
{
	return (self WeaponAnims()) == "pistol";
}

ragdollDeath( moveAnim )
{
	self endon ( "killanimscript" );
	
	lastOrg = self.origin;
	moveVec = (0,0,0);

	for ( ;; )
	{
		wait ( 0.05 );
		force = distance( self.origin, lastOrg );
		lastOrg = self.origin;

		if ( self.health == 1 )
		{
			self.a.nodeath = true;
			self startRagdoll();
			self ClearAnim( moveAnim, 0.1 );
			wait ( 0.05 );
			physicsExplosionSphere( lastOrg, 600, 0, force * 0.1 );
			self notify ( "killanimscript" );
			return;
		}
		
	}
}

isCQB()
{
	return IsDefined( self.cqb ) && self.cqb && !usingPistol();
}

squared( value )
{
	return value * value;
}

randomizeIdleSet()
{
	idleAnimArray = animArray("idle", "stop");

	self.a.idleSet = RandomInt( idleAnimArray.size );
}

weapon_spread()
{
	return weaponclass( self.weapon ) == "spread";
}

// meant to be used with any integer seed, for a small integer maximum (ideally one that divides anim.randomIntTableSize)
getRandomIntFromSeed( intSeed, intMax )
{
	assert( intMax > 0 );

	index = intSeed % anim.randomIntTableSize;
	return anim.randomIntTable[ index ] % intMax;
}

is_rusher()
{
	return IsDefined( self.rusher ) && self.rusher;
}

// SCRIPTER_MOD: JesseS (4/16/2008): HMG guys have their own anims
is_heavy_machine_gun()
{
	return IsDefined( self.heavy_machine_gunner ) && self.heavy_machine_gunner;
}

is_zombie()
{
	if (IsDefined(self.is_zombie) && self.is_zombie)
	{
		return true;
	}

	return false;
}


is_civilian()
{
	if (IsDefined(self.is_civilian) && self.is_civilian)
	{
		return true;
	}

	return false;
}

// CODER_MOD: Austin (7/21/08): added to prevent zombies from gibbing more than once
is_zombie_gibbed()
{
	return ( self is_zombie() && self.gibbed );
}

// CODER_MOD: Austin (7/21/08): added to prevent zombies from gibbing more than once
set_zombie_gibbed()
{
	if ( self is_zombie() )
	{
		self.gibbed = true;
	}
}

is_skeleton(skeleton)
{
	if ((skeleton == "base") && IsSubStr(get_skeleton(), "scaled"))
	{
		// Scaled skeletons should identify as "base" as well
		return true;
	}

	return (get_skeleton() == skeleton);
}

get_skeleton()
{
	if (IsDefined(self.skeleton))
	{
		return self.skeleton;
	}
	else
	{
		return "base";
	}
}

isBalconyNode( node )
{
	return ( ( IsDefined( anim.balcony_node_types[node.type] ) ) 
		  		&& ( node has_spawnflag( SPAWNFLAG_PATH_BALCONY )
				|| node has_spawnflag( SPAWNFLAG_PATH_BALCONY_NORAILING ) )
	       );
}

isBalconyNodeNoRailing( node )
{
	return ( isBalconyNode( node ) && ( node has_spawnflag( SPAWNFLAG_PATH_BALCONY_NORAILING ) ) );
}

do_ragdoll_death()
{
	assert(!IS_TRUE(self.magic_bullet_shield), "Cannot ragdoll death on guy with magic bullet shield.");

	self Unlink();
	self StartRagdoll();

	self call_overloaded_func( "animscripts\death", "PlayDeathSound" );
	
	if (IsAI(self))
	{
		self.a.doingRagdollDeath = true;
	}

	wait(0.1); // wait 2 frames for the animation velocity to be calculated and applied to ragdoll

	if( IsAlive(self) )
	{
		if (IsAI(self))
		{
			self.a.nodeath = true;
			self.a.doingRagdollDeath = true;
			self animscripts\shared::DropAllAIWeapons();
		}
	
		self BloodImpact( "none" );
		self.allowdeath = true;
		self DoDamage( self.health + 100, self.origin, self.attacker );
	}
}

LookingAtEntity()
{
	return self.looking_at_entity;
}

SetLookAtEntity(ent)
{
	self LookAtEntity(ent);	
	self.looking_at_entity = true;
}

StopLookingAtEntity()
{
	if(! (IsDefined(self.lookat_set_in_anim) && self.lookat_set_in_anim) )
	{
		self LookAtEntity();
	}
	
	self.looking_at_entity = false;
}

idleLookatBehaviorTidyup()
{
	self waittill_either("killanimscript", "newLookAtBehavior" );

	/#
	self animscripts\debug::debugPopState( "idleLookatBehavior" );
	#/

	
	if(IsDefined(self))
	{
		self StopLookingAtEntity();
	}
}

IsOkToLookAtEntity()
{
	if(IsDefined(level._dont_look_at_player) && level._dont_look_at_player)
	{
		return false;
	}
	
	if(IsDefined(self.lookat_set_in_anim) && self.lookat_set_in_anim)
	{
		return false;
	}
	
	if(IsDefined(self.coverNode) && IsDefined(self.coverNode.script_dont_look))
	{
		return false;
	}


	if(IsDefined(self.coverNode) && IsDefined(self.a.script) && (self.a.script == "cover_right" || self.a.script == "cover_left") && self.a.pose == "crouch")
	{
		return false;
	}
	
	return true;
}

entityInFront(origin)
{
	forward = AnglesToForward(self.angles);
	dot = VectorDot(forward, VectorNormalize(origin - self.origin));
	//Print3d(self.origin + (0,0,36), dot);
	return(dot > 0.3);
}

idleLookatBehavior(dist_thresh, dot_check)
{
	self notify( "newLookAtBehavior" );
	self endon( "newLookAtBehavior" );
	
	if(self.team != "allies")
		return;
		
	/#
	self animscripts\debug::debugPushState( "idleLookatBehavior" );
	#/


	self endon("killanimscript");
	self thread idleLookatBehaviorTidyup();
	
	dist_thresh *= dist_thresh;
	
	looking = false;
	
	flag_wait("all_players_connected");
	
	wait(RandomFloatRange(0.05, 0.1));
	
	while(1)
	{
		/#
		self animscripts\debug::debugAddStateInfo( "idleLookatBehavior", "StopLookAtPlayerTest" );
		#/

		if(self animscripts\utility::IsInCombat() || !IsOkToLookAtEntity())
		{
			/#
			self animscripts\debug::debugAddStateInfo( "idleLookatBehavior", "StopLookAtPlayer" );
			#/

			self StopLookingAtEntity();
//			break;
		}
		
		dot_check_passed = true;
		
		player = get_players()[0];
		
		if(IsDefined(dot_check) && dot_check && !self entityInFront(player.origin))
		{
			dot_check_passed = false;
		}
		
		player_dist = DistanceSquared(self.origin, player.origin);
		if(((player_dist > dist_thresh) || (!dot_check_passed)) && looking)
		{
			/#
			self animscripts\debug::debugAddStateInfo( "idleLookatBehavior", "StopLookAtPlayer" );
			#/

			self StopLookingAtEntity();
			looking = false;
		}
		else if((player_dist < dist_thresh) && !looking && dot_check_passed)
		{
			
			/#
			self animscripts\debug::debugAddStateInfo( "idleLookatBehavior", "LookAtPlayer" );
			#/


			self SetLookAtEntity(player);
			looking = true;
		}
		wait(1.0);

		/#
		self animscripts\debug::debugPopState();
		#/
	} 
}

shouldForceBehavior( behavior )
{
	// just return false in ship

	/#

	switch( behavior )
	{
		case "cover_suppressed":
			return GetDvarInt( "ai_force_suppressed" );
		
		case "force_stand":
			return ( GetDvarInt( "ai_force_stance" ) == 2 );

		case "force_crouch":
			return ( GetDvarInt( "ai_force_stance" ) == 3 );

		case "force_corner_mode":
			forcedCornerMode = GetDvarInt( "ai_forceCornerMode" ); // 1 means off
			switch ( forcedCornerMode )
			{
				case 2:
					return "A";
				case 3:
					return "B";
				case 4:
					return "lean";
				case 5:
					return "over";
				default:
					return "unsuported";
			}
			
		case "force_corner_direction":
			forcedCornerDirection = GetDvarInt( "ai_forceCornerDirection" ); // 1 means off
			switch ( forcedCornerDirection )
			{
				case 2:
					return "left";
				case 3:
					return "right";
				default:
					return "unsuported";
			}

		default:
			return GetDvar( "ai_forceBehavior" ) == behavior;
	}

	#/

	return false;
}

getAnimDirection( damageyaw )
{
	if( ( damageyaw > 135 ) ||( damageyaw <= -135 ) )	// Front quadrant
	{
		return "front";
	}
	else if( ( damageyaw > 45 ) &&( damageyaw <= 135 ) )		// Right quadrant
	{
		return "right";
	}
	else if( ( damageyaw > -45 ) &&( damageyaw <= 45 ) )		// Back quadrant
	{
		return "back";
	}
	else
	{															// Left quadrant
		return "left";
	}
	return "front";
}
