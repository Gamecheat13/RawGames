#include animscripts\Utility;
#include maps\_gameskill;
#include maps\_utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");


EnemiesWithinStandingRange()
{
	enemyDistanceSq = self MyGetEnemySqDist();
	return ( enemyDistanceSq < anim.standRangeSq );
}

MyGetEnemySqDist()
{

    dist = self GetClosestEnemySqDist();
	if (!isDefined(dist))
		dist = 500;	// Arbitrary values for now
    return dist;
}


// Fires a volley of shots.  The completeLastShot flag indicates whether to wait a full 1-shot after the last 
// shot is fired before returning.  If you're firing two volleys in a row, you want to wait, whereas if 
// you're going to do something else next, you want to abort a little early to look more natural.
// TODO CompleteLastShot is a hack and is preventing me from getting the timing of the shots as I want them.  
// It'd be nice to handle recovery from a shot, and aiming for the next shot, a little better.
// Optional forceShoot can be set to "forceShoot" or "dontForceShoot"

autofireRecoil(target, weight, blendTime, rate)
{
	down = undefined;
	straight = undefined;
	up = undefined;
	if (self.anim_pose == "stand")
	{
		down = %stand_shoot_autoend_down;
		straight = %stand_shoot_autoend_straight;
		up = %stand_shoot_autoend_up;
		self clearanim(%stand_shoot_auto, blendTime);
		self clearanim(%stand_aim, blendTime);
	}
	else
	if (self.anim_pose == "crouch")
	{
		down = %crouch_shoot_autoend_down;
		straight = %crouch_shoot_autoend_straight;
		up = %crouch_shoot_autoend_up;
		self clearanim(%crouch_shoot_auto, blendTime);
		self clearanim(%crouch_aim, blendTime);
	}
	else
		return;

	offset = getTargetAngleOffset(target);
	// so we dont play the opposing animation with 0 weight
	if (offset < -0.99)
		offset = -0.99;
	else
	if (offset > 0.99)
		offset = 0.99;
	else
	if (offset > -0.01 && offset < 0.01)
		offset = 0.01;
		
	if (offset < 0)
	{
		offset+=1;
		self SetFlaggedAnim("recoildone",		down,	1 - offset, blendTime, 1);
		self SetAnim(							straight,	offset,		blendTime, 1);
	}
	else
	{
		self SetFlaggedAnim("recoildone",	straight,	1 - offset, blendTime, 1);
		self SetAnim(							  up,	offset,		blendTime, 1);
	}
	self waittillmatch ("recoildone","end");
	if (self.anim_pose == "stand")
		self clearanim(%stand_shoot_autoend, 0.1);
	else
		self clearanim(%crouch_shoot_autoend, 0.1);
	/*
	offset = getTargetAngleOffset(target);
	
	// 0.1
	self setAnimKnob(%crouch_directions, weight, blendTime, rate);
	self SetFlaggedAnimKnob(animFlag,	self.animArray[animArray][self.anim_pose]["up"],			1, blendTime, 1);
	self SetAnimKnob(					self.animArray[animArray][self.anim_pose]["down"],			1, blendTime, 1);
	*/
}

getTargetAngleOffset(target)
{
	pos = self getEye() + (0,0,-3); // compensate for eye being higher than gun
	dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
	dir = VectorNormalize( dir );
	fact = dir[2] * -1;
//	println ("offset "  + fact);
	return fact;
}

aimAtPanzerTarget()
{
 	if (isdefined(self.panzer_pos))
 	{
		self setanimknob(%shoot, 1, .15, 1);
		myYawFromTarget = VectorToAngles(self.panzer_pos - self.origin );
		self OrientMode( "face angle", myYawFromTarget[1] );

		difference = vectornormalize(self.panzer_pos - self.origin);
	    forward = anglesToForward(self.angles);
		dot = vectordot(forward, difference);
		
		if (isdefined(self.panzer_delay))
		{
			for ( i = 0 ; i < (5 * self.panzer_delay) ; i++ )
			{
				org = self.panzer_ent.origin + self.panzer_ent_offset;
				myYawFromTarget = VectorToAngles(org - self.origin );
				self OrientMode( "face angle", myYawFromTarget[1] );
				wait 0.2;
			}
		}
		
		while (dot < 0.7)
		{
			myYawFromTarget = VectorToAngles(self.panzer_pos - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1] );
			wait (0.15);
			difference = vectornormalize(self.panzer_pos - self.origin);
		    forward = anglesToForward(self.angles);
			dot = vectordot(forward, difference);
		}
	}
	else
	if (isalive(self.panzer_ent))
	{
		org = self.panzer_ent.origin + self.panzer_ent_offset;
		self setanimknob(%shoot, 1, .15, 1);
		myYawFromTarget = VectorToAngles(org - self.origin );
		self OrientMode( "face angle", myYawFromTarget[1] );

		difference = vectornormalize((org[0], org[1], 0) - (self.origin[0], self.origin[1], 0));
	    forward = anglesToForward(self.angles);
		dot = vectordot(forward, difference);
		
		if (isdefined(self.panzer_delay))
		{
			for ( i = 0 ; i < (5 * self.panzer_delay) ; i++ )
			{
				org = self.panzer_ent.origin + self.panzer_ent_offset;
				myYawFromTarget = VectorToAngles(org - self.origin );
				self OrientMode( "face angle", myYawFromTarget[1] );
				wait 0.2;
			}
		}
		
		while (dot < 0.9)
		{
			org = self.panzer_ent.origin + self.panzer_ent_offset;
			myYawFromTarget = VectorToAngles(org - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1] );
			wait (0.15);
			difference = vectornormalize((org[0], org[1], 0) - (self.origin[0], self.origin[1], 0));
		    forward = anglesToForward(self.angles);
			dot = vectordot(forward, difference);
		}
	}
}


pauseIfPlayerIsInvulAndYouAreAPauseGuy()
{
	if (1) return;
	// dont shoot at invulnerable player
	if (isalive(self.enemy) && self.enemy == level.player)
	{
		if (flag("player_is_invulnerable") && !self.anim_nonstopFire)
		{
			flag_waitopen("player_is_invulnerable");
			resetMissDebounceTime();
		}
	}
}

shootBurst(SuppressSpot)
{
	numShots = 3 + randomint(5);
	// Random double length burst
	if (randomint(100) > 75)
		numShots*=2;
	if (self.bulletsInClip < numShots)
		numShots = self.bulletsInClip;
	
	/*
	if (self.enemy == level.player)
	{
		for (i=0; i<numShots; i++)
		{
			wait (0.05);
			if (randomfloat(100>50))
				wait (0.05);
	        self shootWrapper(undefined, suppressSpot + randomvec(15));
			self.bulletsInClip--;
			
			// Stop doing suppressing fire if we can see him, and shoot him!
			// so you can react faster to the player.
			if (self canSee(self.enemy))
				break;
		}
	}
	else
	*/
	{
		for (i=0; i<numShots; i++)
		{
			wait (0.05);
			if (randomfloat(100>50))
				wait (0.05);
	        self shootWrapper(undefined, suppressSpot + randomvec(15));
			self.bulletsInClip--;
		}
	}
}

shootSemiAutoBurst(suppressSpot)
{
	[[self.fireanim_setup]]();
	numShots = 1 + randomint(4);
	if (self.bulletsInClip < numShots)
		numShots = self.bulletsInClip;
	
	for (i=0; i<numShots; i++)
	{
		[[self.fireanim_fire]]();

        self shootWrapper(undefined, suppressSpot + randomvec(15));
		self.bulletsInClip --;
		wait animscripts\weaponList::shootAnimTime();
		
		// Stop doing suppressing fire if we can see him, and shoot him!
		if (self canSee(self.enemy))
			break;
	}

	// Play Garand Ping!
	if ((self.weapon == "m1garand") && (!self.bulletsInClip))
		self playsound ("weap_m1garand_lastshot");
}


burstDelay()
{
	if (!self.bulletsInClip)
	{
		// small pause so we dont move while still showing the firing effect 
		wait (0.2);
		return;
	}

	pauseUntilYouSeeTheEnemy(0.4 + randomfloat(0.5));
}

pauseUntilYouSeeTheEnemy(duration)
{
	for (i=0;i<duration*20;i++)
	{
		if (self canSee(self.enemy))
			break;
		wait (0.05);		
	}
}



// There is a bug we don't have time to fix, where sometimes the autfire animation stops returning notetracks, 
// resulting in guys getting stuck in their autofire animation, not firing bullets.  This thread stops that 
// from continuing forever.
KillRunawayAutofire(notifyString, timeToWait)
{
	assertEX(timeToWait>0);
	self endon(notifyString);
//	self endon("killanimscript");
	self endon("death");
	wait timeToWait;
	self notify (notifyString);
}

stopOnSuppression()
{
	self endon ("killanimscript");
	self notify ("stopSuppressionThread");
	self endon ("stopSuppressionThread");
	wait (anim.startSuppressionDelay);
	if (self.suppressionwait <= 0)
		return;
	if (!self.isSuppressable)
		return false;
	for (;;)
	{
		if (self issuppressed())
			break;
		wait (0.05);
	}
	dist = self GetClosestEnemySqDist();
	if (dist > 256*256) // dont stop shooting if an enemy is right near you
		self notify ("stopShooting");
}

Autofire()
{
	thread stopOnSuppression();
	self endon ("stopShooting"); // For changing shooting pose to compensate for player moving

	// moved this stuff to resetAccuracyAndPause
//	thread maps\_gameSkill::resetAccuracyAuto(); // So the first shot doesnt hit
//	self.anim_missTime*=0.5; // doing half the time as a wait before hand


	lastShot = 0; // to compensate for reading notetracks from multiple animations simultaneously
	adjustedNumshots = false;
	
	numShots = self.bulletsInClip;
	for (i=0;i<numShots;i++)
	{
		timer = gettime();
		if (lastShot == timer)
		{
			wait (0.05);
			continue;
		}
		lastShot = timer;
		
/*
		wait (0.05);
		if (randomfloat(100>50))
			wait (0.05);
*/			
			
		self shootWrapper();
		self.bulletsInClip--;

		// wait until after the first shot before we start waiting for fire
		// this insures we get at least one shot off even if supressed		
		self waittillmatch("animdone", "fire");

		// Stop doing corner fire if you've suppressed the guy.
		if ( !self canSeeEnemy())
			break;

		if (self.enemy == level.player && flag("player_is_invulnerable")) // dont keep shooting the invul player
		{
			if (!self.anim_nonstopFire && !adjustedNumshots)
			{
				newNumshots = i + maps\_gameskill::shotsAfterPlayerBecomesInvul();
				if (newNumshots < numShots)
					numShots = newNumshots;
				adjustedNumshots = true;
			}
		}
	}

	if ( !self canSeeEnemy())
	{
		maxShots = 3;
		if (maxShots > self.bulletsInClip)
			maxShots = self.bulletsInClip;
	
		// Fire off a few more rounds for effect, when you've suppressed the guy.
		lastShot = 0; // to compensate for reading notetracks from multiple animations simultaneously
		for (i=0; i<maxShots; i++)
		{
			assert (self.bulletsInClip > 0);
			/*
			wait (0.05);
			if (randomfloat(100>50))
				wait (0.05);
			*/
			self waittillmatch("animdone", "fire");
			timer = gettime();
			if (lastShot == timer)
				continue;
			lastShot = timer;
			
			self shootWrapper(self.lastEnemySightPos);
			self.bulletsInClip--;
		}
	}
	
	self notify ("stopSuppressionThread");
}

semiAutoFire()
{	
	self endon ("stopShooting"); // For changing shooting pose to compensate for player moving
	thread stopOnSuppression();
	//thread maps\_gameSkill::resetAccuracyAuto(); // So the first shot doesnt hit

	maps\_gameskill::resetAccuracyAndPause();
	pauseIfPlayerIsInvulAndYouAreAPauseGuy();

	[[self.fireanim_setup]]();
	adjustedNumshots = false;
	numShots = self.bulletsInClip;
	for (i=0;i<numShots;i++)
	{
		[[self.fireanim_fire]]();
        self shootWrapper();
		self.bulletsInClip --;
		wait animscripts\weaponList::shootAnimTime();
		
		if (self.enemy == level.player && flag("player_is_invulnerable")) // dont keep shooting the invul player
		{
			if (!self.anim_nonstopFire && !adjustedNumshots)
			{
//				newNumshots = i + maps\_gameskill::shotsAfterPlayerBecomesInvul();
				i = numshots;
//				if (newNumshots < numShots)
//					numShots = newNumshots;
				adjustedNumshots = true;
			}
		}
		
		// Stop doing auto fire if we can't see our opponent
		if (!self canSeeEnemy())
			break;
	}

	if (!self canSeeEnemy())
	{
		maxShots = 3;
		if (maxShots > self.bulletsInClip)
			maxShots = self.bulletsInClip;
		// Fire off a few more rounds for effect, when you've suppressed the guy.
	
		for (i=0; i<maxShots; i++)
		{
			/*
			wait (0.05);
			if (randomfloat(100>50))
				wait (0.05);
			*/			
	
			assert(self.bulletsinclip);			
			[[self.fireanim_fire]]();
	        self shootWrapper(undefined, self.lastEnemySightPos);
			self.bulletsInClip --;
			wait animscripts\weaponList::shootAnimTime();
		}
	}

	self notify ("stopSuppressionThread");
	// Play Garand Ping!
	if ((self.weapon == "m1garand") && (!self.bulletsInClip))
		self playsound ("weap_m1garand_lastshot");
}


DoAutofire(numShots, maxYaw)
{
	assertEX(numShots>0);
	self endon("killanimscript");
	self.enemy endon ("death");
	self endon ("enemy");
	
	wait 0; // This prevents this thread from notifying before the calling thread has got to a wait.
	enemyAngle = AbsYawToEnemy();
	self notify ("started autofire assault");
	lastShot = 0; // to compensate for reading notetracks from multiple animations simultaneously
	adjustedNumshots = false;
	
	for (i = 0; i<numShots; i ++)
	{
		timer = gettime();
		if (lastShot == timer)
			continue;
		lastShot = timer;
		assert (self.bulletsInClip > 0);
        self shootWrapper();
		self.bulletsInClip --;
		self.enemyDistanceSq = self MyGetEnemySqDist();
		assert (isalive (self.enemy));
		
		enemyAngle = AbsYawToEnemy();
		if (self.enemy == level.player && flag("player_is_invulnerable")) // dont keep shooting the invul player
		{
			if (!self.anim_nonstopFire && !adjustedNumshots)
			{
				newNumshots = i + maps\_gameskill::shotsAfterPlayerBecomesInvul();
				if (newNumshots < numShots)
					numShots = newNumshots;
				adjustedNumshots = true;
			}
		}

		if (self.anim_pose == "stand" && self.enemyDistanceSq<anim.meleeRangeSq )
			break;
		if (self.bulletsInClip<= 0)
			break;
		if (enemyAngle>=maxYaw)
			break;
		self waittillmatch ("animdone", "fire");
	}
}

/*
DoAutofireCorner_Suppress(notifyString, numShots, forceShoot)
{
	assertEX(numShots>0);
	self endon(notifyString);
//	self endon (anim.scriptChange);
//	self endon("killanimscript");
	self endon("death");
	wait 0; // This prevents this thread from notifying before the calling thread has got to a wait.

	if (!hasEnemySightPos())
	{
		self notify (notifyString);
		return;
	}


	myGunPos = self GetTagOrigin ("tag_flash");
	
	if (!sightTracePassed(self GetEye(), myGunPos, false, undefined))
	{
		self notify (notifyString);
		return;
	}
	
	sightPos = getEnemySightPos();
	trace = bulletTrace(sightPos, sightPos - (0,0,100), false, undefined);
	destination = trace["position"];
	height = sightPos[2] - destination[2];

	if (sightTracePassed(myGunPos, destination, false, undefined))
		fireEnt = getFirePattern();
	else
		fireEnt = getFirePattern(1.0, 1.0);
	
	
	for (i=0; i<numShots; i++)
	{
		if ((self.enemyDistanceSq<=anim.meleeRangeSq) && (forceShoot!="forceShoot"))
			break;
		if (self.bulletsInClip<=0)
			break;
		if (!hasEnemySightPos())
			break;

		sightPos = getEnemySightPos();
		if (isdefined(sightPos))
		{
			enemyAngle = animscripts\utility::AbsYawToOrigin(sightPos);
			if (enemyAngle>=20)
				break;

			myYawFromTarget = VectorToAngles(sightPos - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1] );

			self waittillmatch ("animdone", "fire");
//			newHeight = [[fireEnt.autoFirePattern]] (height, i, numShots, fireEnt.min, fireEnt.range);
//	        self shootWrapper(1.0, destination + randomvec(15) + (0,0,newHeight));
	        self shootWrapper(undefined, sightPos);
			self.bulletsInClip--;
			self.enemyDistanceSq = self MyGetEnemySqDist();
		}
		else
			break;
	}
	self notify (notifyString);
}
*/

	/*
	myGunPos = self GetTagOrigin ("tag_flash");
	
	if (!sightTracePassed(self GetEye(), myGunPos, false, undefined))
	{
		self notify (notifyString);
		return;
	}
	
	trace = bulletTrace(sightPos, sightPos - (0,0,100), false, undefined);
	destination = trace["position"];
	height = sightPos[2] - destination[2];

	if (sightTracePassed(myGunPos, destination, false, undefined))
		fireEnt = getFirePattern();
	else
		fireEnt = getFirePattern(1.0, 1.0);
	*/

getFirePattern(min, max)
{
	type = "default";
	autoFirePattern = ::autoFireRise;
	
	if ((!isdefined (min)) || (!isdefined (max)))
	{
		min = 0.0;
		max = 1.0;
		
		firePattern = randomint(9) + 1;
		switch (firePattern)
		{
			case 1: // Shoot low
				autoFirePattern = ::autoFireRise; 	min = 0.1; 	max = 0.3; type = "low"; break;
	
			case 2: // Shoot high
				autoFirePattern = ::autoFireRise; 	min = 0.8; 	max = 1.0; type = "high"; break;
	
			case 3: // Shoot mid
				autoFirePattern = ::autoFireFall; 	min = 0.5; max = 0.6;	type = "mid"; break;
	
			case 4: // Shoot low to high
				autoFirePattern = ::autoFireRise;	min = 0.0; 	max = 1.0; type = "low to high"; break;
	
			case 5: // Shoot high to low
				autoFirePattern = ::autoFireFall;	min = 0.0;	max = 1.0; type = "high to low"; break;
	
			case 6: // Shoot low to mid
				autoFirePattern = ::autoFireRise;	min = 0.0; 	max = 0.5; type = "low to mid"; break;
	
			case 7: // Shoot high to mid
				autoFirePattern = ::autoFireFall;	min = 0.5; 	max = 1.0; type = "high to mid"; break;
	
			case 8: // Shoot low mid to high mid
				autoFirePattern = ::autoFireRise;	min = 0.3; max = 0.8; type = "mid up"; break;
	
			case 9: // Shoot high mid to low mid
				autoFirePattern = ::autoFireFall;	min = 0.3; max = 0.8;	type = "mid down"; break;
		}
	}	
	
	assert (min <= max);	
	range = max - min;

	fireEnt = spawnStruct();
	fireEnt.min = min;
	fireEnt.range = max - min;
	fireEnt.type = type;
	fireEnt.autoFirePattern = autoFirePattern;

	/#
	if (getdebugcvar ("anim_debug") == "2")
		thread animscripts\utility::debugPosSize(self.origin + (0,0,25), fireEnt.type, 1.5);
	#/
	
	return fireEnt;
}

getNumShots()
{
	maxShots = animscripts\weaponList::ClipSize();
	numShots = int (maxShots * (0.15 + randomfloat(85) * 0.01));
	
	// Use the rest of the clip if it'd only leave 4 or less shots, or if you're trying to shoot more than the clip has
	if ((numShots >= self.bulletsInClip) || (maxShots - numShots < 4))
		numShots = self.bulletsInClip;

	/#
		if (getdebugcvar ("anim_debug") == "2")
			thread debugBurstPrint(numShots, maxShots);
	#/
	return numShots;
}

autoFireRise(height, i, numShots, min, range)
{
	return (height * (((i / numShots) * range) + min));
}

autoFireFall(height, i, numShots, min, range)
{
	return (autoFireRise(height, numShots - i, numShots, min, range));
}

// Rechambers the weapon if appropriate
Rechamber(isExposed)
{
	if (self NeedsToRechamber())
	{
		if (self animscripts\utility::weaponAnims() == "panzerfaust")
		{
			/*
			self.weapon = self.secondaryweapon;
			self animscripts\shared::PutGunInHand("right");
			self animscripts\weaponList::RefillClip();
			*/
			self animscripts\weaponList::RefillClip();
			self.anim_needsToRechamber = 0;
		}
		else
		{
			thread RechamberDebugThread();
			thread RechamberThread(isExposed);
			self waittill("rechamberdone");
		}
	}
}

NeedsToRechamber()
{
	if ( (animscripts\weaponList::usingAutomaticWeapon()) || (animscripts\weaponList::usingSemiAutoWeapon()) )
		return false;

	return (self.anim_needsToRechamber);
}

RechamberDebugThread()
{
	self endon("rechamberdone");
	self endon("killanimscript");
//	self endon (anim.scriptChange);
	wait 3;

	println ("Guy " + (self getEntityNumber()) + " hung in rechamber at phase "+self.rechamberdebug);

	self.anim_needsToRechamber = 0;
	self notify ("rechamberdone");
}

GetRechamberAnim(isExposed)
{
	if (isdefined (isExposed))
		exposed = isExposed;
	else
		exposed = true;
		
	anim_rechamber = undefined;
	switch (self.anim_pose)
	{
		case "stand":
		switch (self.anim_special)
		{
			case "cover_left":
			if (self.anim_idleSet=="a")
			{
				if (exposed)
					anim_rechamber = %cornerstandrechamber_aim_right;
				else
					anim_rechamber = %cornerstandrechamber_right;
			}
			else
			{
				if (exposed)
					anim_rechamber = %cornerb_stand_rechamber_aim_right;
				else
					anim_rechamber = %cornerb_stand_rechamber_right;
			}
			break;

			case "cover_right":
//			if ((getcvar("newanims") != "") && (self.team == "axis"))
			if (1)
			{
				if (exposed)
					anim_rechamber = %corner_right_stand_rechamber_45right;
				else
					anim_rechamber = %corner_both_stand_rechamberbehind_45right; //cornerstandrechamber_left;
			}
			else
			if (self.anim_idleSet=="a")
			{
				if (exposed)
					anim_rechamber = %cornerstandrechamber_aim_left;
				else
					anim_rechamber = %cornerstandrechamber_left;
			}
			else
			{
				if (exposed)
					anim_rechamber = %cornerb_stand_rechamber_aim_left;
				else
					anim_rechamber = %cornerb_stand_rechamber_left;
			}
			break;
	
			case "none":
			default:
			anim_rechamber = %stand_rechamber;
			break;
		}
		break;
		
		case "crouch":
		switch (self.anim_special)
		{
			case "cover_left":
			if (self.anim_idleSet=="a")
			{
				if (exposed)
					anim_rechamber = %cornercrouchrechamber_aim_right;
				else
					anim_rechamber = %cornercrouchrechamber_right;
			}
			else
			{
				if (exposed)
					anim_rechamber = %cornerb_crouch_rechamber_aim_right;
				else
					anim_rechamber = %cornerb_crouch_rechamber_right;
			}
			break;
			
			case "cover_right":
			if (self.anim_idleSet=="a")
			{
				if (exposed)
					anim_rechamber = %cornercrouchrechamber_aim_left;
				else
					anim_rechamber = %cornercrouchrechamber_left;
			}
			else
			{
				if (exposed)
					anim_rechamber = %cornerb_crouch_rechamber_aim_left;
				else
					anim_rechamber = %cornerb_crouch_rechamber_left;
			}
			break;
			
			case "cover_crouch":
				anim_rechamber = %hidelowwallb_rechamber;
			break;
			
			case "none":
			default:
			anim_rechamber = %crouch_rechamber;
			break;
		}
		break;
		
		case "prone":
		anim_rechamber = %prone_rechamber;
		break;
		
		default:
		anim_rechamber = %crouch_rechamber;
		break;
	}
	
	return anim_rechamber;
}

RechamberThread(isExposed)
{
	self endon("rechamberdone");
	self endon("killanimscript");
//	self endon (anim.scriptChange);
	
	self.rechamberdebug = "start";
	if (self.anim_script == "combat")
		self interruptPoint();
	
	oldHand = self.anim_gunHand;
	playSpeed = 0.9 + randomfloat(0.2);
	
	weight = 1.0;
	anim_rechamber = GetRechamberAnim(isExposed);
	switch (self.anim_pose)
	{
		case "stand":
		switch (self.anim_special)
		{
			case "cover_left":
			if (self.anim_idleSet=="a")
			{
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			}
			else
			{
				assertEX(self.anim_idleSet=="b", "Combat::rechamber - cover_left stand guy not in idleSet a or b, he's in "+self.anim_idleSet);
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			}
			break;

			case "cover_right":
			if (self.anim_idleSet=="a")
			{
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			}
			else
			{
				assertEX(self.anim_idleSet=="b", "Combat::rechamber - cover_right stand guy not in idleSet a or b, he's in "+self.anim_idleSet);
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			}
			break;
	
			case "none":
			default:
			if (isdefined (anim_rechamber))
				self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			break;
		}
		break;
		
		case "crouch":
		switch (self.anim_special)
		{
			case "cover_left":
			if (self.anim_idleSet=="a")
			{
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
				// "Eject" is in this animation if we want it
			}
			else
			{
				assertEX(self.anim_idleSet=="b", "Combat::rechamber - cover_left crouch guy not in idleSet a or b, he's in "+self.anim_idleSet);
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			}
			break;
			
			case "cover_right":
			if (self.anim_idleSet=="a")
			{
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			}
			else
			{
				assertEX(self.anim_idleSet=="b", "Combat::rechamber - cover_right crouch guy not in idleSet a or b, he's in "+self.anim_idleSet);
				if (isdefined (anim_rechamber))
					self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			}
			break;
			
			case "cover_crouch":
			if (self.anim_idleSet != "b")
				animscripts\cover_crouch_no_wall::duckBetweenShots("rechambering");	// This gets it into set b

			if (isdefined (anim_rechamber))
				self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			break;
			
			case "none":
			default:
			if (isdefined (anim_rechamber))
				self setFlaggedAnimKnobRestart("rechamberanim", anim_rechamber, weight, .2, playSpeed);
			self.anim_needsToRechamber = 0;
			break;
		}
		break;
		
		case "prone":
		if (isdefined (anim_rechamber))
			self setFlaggedAnimKnobAll("rechamberanim", anim_rechamber, %body, 1, .2, playSpeed);
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		self.anim_needsToRechamber = 0;
		break;
		
		default:
		if (isdefined (anim_rechamber))
			self setFlaggedAnimKnobAll("rechamberanim", anim_rechamber, %body, 1, .2, playSpeed);
		break;
	}

	self.anim_needsToRechamber = 0;	// TODO Should I put this in a notetrack?  Yes...
	self playsound ("ai_rechamber");
	if (!isdefined (anim_rechamber))
		return;
		
	self animscripts\shared::DoNoteTracks("rechamberanim");
	self notify ("rechamberdone");
//	[[anim.PutGunInHand]](oldHand);	// This is important as some of the animations swap it back on the very last frame.
}


// Returns true if character has less than thresholdFraction of his total bullets in his clip.  Thus, a value 
// of 1 would always reload, 0 would only reload on an empty clip.
NeedsToReload(thresholdFraction)
{
	if (!isDefined(thresholdFraction))
		thresholdFraction = 0;
	if (self.bulletsInClip <= animscripts\weaponList::ClipSize() * thresholdFraction )
		return true;
	else
		return false;
}

tryWeaponThrowDown()
{
//	if (1)
//	return false;
	if (anim.noWeaponToss)
		return false;

	if (weaponAnims() == "panzerfaust")
		return false;
	if (weaponAnims() == "pistol")
		return false;

	if (self.team != "axis")
		return false;

	if (self.anim_pose != "stand")
		return false;
			
	if (!isalive (self.enemy))
		return false;
	
	if (self.anim_script != "combat")
		return false;
		
	if (distance (level.player.origin, self.origin) > 350)
		return false;
	if (!self cansee(self.enemy))
		return false;
		
	/*
	dist = self GetClosestEnemySqDist();
    if ((!isdefined (dist)) || (dist > 500*500))
    	return false;
	*/
	
	tossrand = randomint(3) + 1;
	tossanim = undefined;
	switch (tossrand)
	{
		case 1:
			tossanim = %pistol_boltaction_toss;
			break;
		case 2:
			tossanim = %pistol_boltaction_toss_struggle;
			break;
		case 3:
			tossanim = %pistol_boltaction_toss_fast;
			break;
	}
		
	tossanim = %pistol_boltaction_toss_struggle;
	
	self setFlaggedAnimKnobAllRestart("pistol pullout", tossanim, %body, 1, .1, 1);
	self waittill ("pistol pullout", notetrack);
	
//	self thread throwGun();
	weaponClass = "weapon_" + self.weapon;
	weapon = spawn (weaponClass, self getTagOrigin ("tag_weapon_right"));
	weapon.angles = self getTagAngles ( "tag_weapon_right" ); 
	
	if (self.secondaryweapon == "")
		self.weapon = "luger";
	else
		self.weapon = self.secondaryweapon;
	setAimAndShootAnimations();

	self animscripts\shared::PutGunInHand("none");
	self thread putGunBackInHandOnKillAnimScript();

	self waittill ("pistol pullout", notetrack);
//	wait (0.2);
	self animscripts\shared::PutGunInHand("right");
	self notify ("weapon_throw_down_done");
	self.anim_combatrunanim = %combat_run_fast_pistol;
	
	self animscripts\weaponList::RefillClip();
	self.anim_needsToRechamber = 0;

	self waittillmatch ("pistol pullout", "end");
	self clearanim(%upperbody, .1);		// Only needed for the upper body running reload.
	return true;
}

// Put the gun back in the AI's hand if he cuts off his weapon throw down animation
putGunBackInHandOnKillAnimScript()
{
	self endon ("weapon_throw_down_done");
	self endon ("death");
	self waittill("killanimscript");
	self thread animscripts\shared::PutGunInHand("right");
}

Reload(thresholdFraction, optionalAnimation/*, startingGunHand*/)
{
//	self.keepClaimedNode = true;
	self endon("killanimscript");
	
	/*
	if (self animscripts\utility::weaponAnims() == "panzerfaust")
	{
		Rechamber();	// This handles swapping the panzerfaust for the secondary weapon.
	}
	*/
	
	if (NeedsToReload(thresholdFraction))
	{
		self.anim_Alertness = "casual";
		if (tryWeaponThrowDown())
			return;
			
			/*
			self thread tryWeaponThrowDown();
			self waittill ("weapon_throw_down_done", success);
			if (success)
			{
//				self.keepClaimedNode = false;
				return;
			}
//			self interruptPoint();
		}
		*/
		if (usingBoltActionWeapon())
			thread maps\_gameSkill::resetAccuracyBolt(); // So the first shot doesnt hit

		self animscripts\battleChatter_ai::evaluateReloadEvent();
		self animscripts\battleChatter::playBattleChatter();
		oldHand = self.anim_gunHand;

		if (isDefined(optionalAnimation))
		{
			playReloadSound();
			self animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in theory.
			self setFlaggedAnimKnobAll("reloadanim", optionalAnimation, %body, 1, .1, 1);
			[[anim.PutGunInHand]]("left");
			animscripts\shared::putGunInHand("left");
			animscripts\shared::DoNoteTracks("reloadanim");
			animscripts\shared::PutGunInHand(oldHand);
			self.anim_needsToRechamber = 0;
//			self clearAnim(optionalAnimation, 0);
//			wait (1);
		}
		else if (self animscripts\utility::weaponAnims() == "panzerfaust")
		{
			if (self.anim_pose == "stand")
			{
				self setFlaggedAnimKnobAll("reloadanim",%reload_stand_rifle, %body, 1, .1, 0.6);
				animscripts\shared::putGunInHand("left");
			}			
			else
			{
				self setFlaggedAnimKnobAll("reloadanim",%reload_crouch_rifle, %body, 1, .1, 0.6);
				animscripts\shared::putGunInHand("left");
			}

			self animscripts\shared::DoNoteTracks("reloadanim");
			self animscripts\weaponList::RefillClip();
		}
		else if (self animscripts\utility::weaponAnims() == "pistol")
		{
			playReloadSound();
			if (self.anim_movement == "stop")
			{
				if (self.anim_special == "none")
				{
					if (self.anim_pose == "crouch")
					{
						self setFlaggedAnimKnobAll("reloadanim",%pistol_crouch_reload, %body, 1, .1, 1);
						self animscripts\shared::DoNoteTracks("reloadanim");
					}
					else if (self.anim_pose == "stand")
					{
						self setFlaggedAnimKnobAll("reloadanim",%pistol_stand_reload, %body, 1, .1, 1);
						self animscripts\shared::DoNoteTracks("reloadanim");
					}
				}
			}
			else if (self.anim_pose == "stand")
			{
				self setanim(%upperbody, 1, .1, 1);
				self setflaggedanimknob("reloadanim", %pistol_stand_reload_upperbody, 1, .1, 1);
				self animscripts\shared::DoNoteTracks("reloadanim");
			}
			// There aren't any other pistol animations so just fill it up magically.
			self animscripts\weaponList::RefillClip();
			self.anim_needsToRechamber = 0;
		}
		else
		{
			playReloadSound();
			if (self.anim_pose == "stand")
			{
				if (self.anim_movement == "run")
				{
					self setanim(%upperbody, 1, .1, 1);
					self setflaggedanimknob("reloadanim", %reload_stand_rifle_upperbody, 1, .1, 1);
					animscripts\shared::putGunInHand("left");
				}
				else
				{
					self setFlaggedAnimKnobAll("reloadanim",%reload_stand_rifle, %body, 1, .1, 1);
					animscripts\shared::putGunInHand("left");
				}
			}
			else if (self.anim_pose == "crouch")
			{
				if (self.anim_movement == "run")
				{
					self setanim(%upperbody, 1, .1, 1);
					self setflaggedanimknob("reloadanim", %reload_stand_rifle_upperbody, 1, .1, 1);	// TEMP?  Need crouch anim.
					animscripts\shared::putGunInHand("left");
				}
				else if (self.anim_special == "cover_crouch")
				{
					if (self.anim_idleSet != "b")
					{
						animscripts\cover_crouch_no_wall::duckBetweenShots("rechambering");	// This gets it into set b
					}
					self setFlaggedAnimKnobAll("reloadanim",%reload_crouch_cover_rifle, %body, 1, .1, 1);
					animscripts\shared::putGunInHand("left");
				}
				else
				{
					self setFlaggedAnimKnobAll("reloadanim",%reload_crouch_rifle, %body, 1, .1, 1);
					animscripts\shared::putGunInHand("left");
				}
			}
			else if (self.anim_pose == "prone")
			{
				self setFlaggedAnimKnobAll("reloadanim",%reload_prone_rifle, %body, 1, .1, 1);
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
				animscripts\shared::putGunInHand("left");
			}
			else 
			{
				println ("Bad anim_pose in combat::Reload");
//				self.keepClaimedNode = false;
				wait 2;
				return;
			}
			animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in most instances.
			animscripts\shared::DoNoteTracks("reloadanim");
			animscripts\shared::PutGunInHand(oldHand);
			self.anim_needsToRechamber = 0;
			self clearanim(%upperbody, .1);		// Only needed for the upper body running reload.
		}
	}
//	self.keepClaimedNode = false;
}

TryGrenadePosProc(destination, optionalAnimation, armOffset, smokeGrenade)
{
	// Dont throw a grenade right near you or your buddies
	if (!smokeGrenade)
	{
		for (i=0;i<self.squad.members.size;i++)
		{
			if (!isalive(self.squad.members[i]))
				continue;
			if (distance(self.squad.members[i].origin, destination) < 200)
				return false;
		}
	}
	else
	if (distance (self.origin, destination) < 200)
		return false;
		
	if (self.weapon=="mg42" || self.grenadeammo <= 0)
		return (false);

	if (TryGrenadeThrow(destination, optionalAnimation, armOffset, smokeGrenade))
		return (true);
	
	return (false);
}

TrySmokeGrenadePos(destination, optionalAnimation, armOffset)
{
	return (TryGrenadePosProc(destination, optionalAnimation, armOffset, true));
}

scriptSmokeGrenade()
{
	org = self.smoke_destination_org;
	if (!isdefined(self.oldGrenadeWeapon))
		self.oldGrenadeWeapon = self.grenadeWeapon;
		
	if (isdefined(level.smoke_grenade_weapon))
		self.grenadeWeapon = level.smoke_grenade_weapon;
	else
		self.grenadeWeapon = "smoke_grenade_american";
	self.grenadeAmmo++;

	msg = (" " + org);
	if (TrySmokeGrenadePos(org))
		level.smokeThrowSmokeTime[msg] = gettime();
	else
		self.grenadeAmmo--;
		
	self.grenadeWeapon = self.oldGrenadeWeapon;
}

grenadeCoolDownElapsed()
{
	if (self.script_forcegrenade == 1)
		return true;
		
	timer = getTime();
	// Significantly reduced chance of AI throwing grenades at AI.
	if (isalive(self.enemy) && self.enemy != level.player)
		return (timer >= anim.nextAIGrenade);

/*
	if (level.gameSkill >= 3)
		return true;
*/
	return (timer >= anim.lastPlayerGrenade);
}		


TryGrenadePos(destination, optionalAnimation, armOffset)
{
	if (!grenadeCoolDownElapsed())
		return false;

	return (TryGrenadePosProc(destination, optionalAnimation, armOffset, false));
}

TryGrenade(optionalAnimation, armOffset/*, gunHand*/)
{
	if (self.weapon=="mg42" || self.grenadeammo <= 0)
		return (false);

	if (!grenadeCoolDownElapsed())
		return false;

 // true/false is smokegrenade
 	return (TryGrenadeThrow(undefined, optionalAnimation, armOffset, false));
}


TryGrenadeThrow(destination, optionalAnimation, armOffset, smokeGrenade)
{
	// no AI grenade throws in the first 10 seconds, bad during black screen
	if (gettime() < 10000)
		return false;
	if (isDefined(optionalAnimation))
	{
		throw_anim = optionalAnimation;
		// Assume armOffset and gunHand are defined whenever optionalAnimation is.
		gunHand = self.anim_gunHand;	// Actually we don't want gunhand in this case.  We rely on notetracks.
	}
	else
	{
		switch (self.anim_special)
		{
		case "cover_crouch":
		case "none":
			if (self.anim_pose == "stand")
			{
				armOffset = (0,0,80);
				throw_anim = %stand_grenade_throw;
			}
			else // if (self.anim_pose == "crouch")
			{
				armOffset = (0,0,65);
				throw_anim = %crouch_grenade_throw;
			}
			gunHand = "left";
			break;
		default: // Do nothing - we don't have an appropriate throw animation.
			throw_anim = undefined;
			gunHand = undefined;			
			break;
		}
	}
	
	// If we don't have an animation, we can't throw the grenade.
	if (!isDefined(throw_anim))
	{
		return (false);
	}

	if (isdefined (destination)) // Now try to throw it.
	{
		throwvel = self checkGrenadeThrowPos(armOffset, "min energy", destination);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrowPos(armOffset, "min time", destination);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrowPos(armOffset, "max time", destination);		
			
		// Allow smoke grenades to be thrown as far as required as they are designer scripted
		if (!isdefined(throwvel) && smokeGrenade )
			throwvel = self checkGrenadeThrowPos(armOffset, "infinite energy", destination);
			
		if (!isdefined(throwvel))
		{
			// drop the grenade destination to the ground
			trace = bulletTrace(self.origin + offsetToOrigin(armoffset), destination, false, undefined);
			/#
//			thread debugLine(self.origin + offsetToOrigin(armoffset), destination, (0.2,0.8,0.5), 10);
			#/
			destination = trace["position"];


			// drop the grenade destination to the ground
			trace = bulletTrace(destination + (0,0,15), destination - (0,0,500), false, undefined);
			destination = trace["position"];
			
			throwvel = self checkGrenadeThrowPos(armOffset, "min energy", destination);
			if (!isdefined(throwvel))
				throwvel = self checkGrenadeThrowPos(armOffset, "min time", destination);
			if (!isdefined(throwvel))
				throwvel = self checkGrenadeThrowPos(armOffset, "max time", destination);		
		}
	}
	else
	{
		throwvel = self checkGrenadeThrow(armOffset, "min energy");
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrow(armOffset, "min time");
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrow(armOffset, "max time");
	}

	if ( isdefined(throwvel) )
	{
		if (!isdefined(self.oldGrenAwareness))
			self.oldGrenAwareness = self.grenadeawareness;
		self.grenadeawareness = 0; // so we dont respond to nearby grenades while throwing one

		if (!smokeGrenade && level.gameSkill == 0) 
		{
			// On easy, only throw 1 grenade at a time
			// so each grenade attempt insures nobody else throws one for 3 seconds.
			anim.lastPlayerGrenade = gettime() + 3000;
		}
		
		/#
		if (getdebugcvar ("anim_debug") == "1")
			thread animscripts\utility::debugPos(destination, "O");

		#/

		oldHand = self.anim_gunHand;
		[[anim.putguninhand]](gunHand);
		self animscripts\battleChatter_ai::evaluateAttackEvent("grenade");
		self notify ("stop_aiming_at_enemy");
		self SetFlaggedAnimKnobAllRestart("throwanim", throw_anim, %body, 1, 0.1, 1);

		self thread animscripts\shared::DoNoteTracksForever("throwanim", "killanimscript");
		self.isHoldingGrenade = true;
		self thread prepGrenade();
		if (smokeGrenade && isdefined (self.smoke_destination_org))
			level.smoke_thrower["smoke"+self.smoke_destination_org] = self;

		model = getGrenadeModel();
		
		attachside = "none";
		for (;;)
		{
			self waittill("throwanim", notetrack);
			if (notetrack == "grenade_left")
				attachside = attachGrenadeModel(model, "TAG_WEAPON_LEFT");
			if (notetrack == "grenade_right")
				attachside = attachGrenadeModel(model, "TAG_WEAPON_RIGHT");
			if (notetrack == "fire")
				break;
		}

		/#
			if (getdebugcvar("debug_grenadehand") == "on")
			{
				tags = [];
				numTags = self getAttachSize();
				emptySlot = [];
				for (i=0;i<numTags;i++)
				{
					name = self getAttachModelName(i);
					if (issubstr(name, "weapon"))
					{
						tagName = self getAttachTagname(i);
						emptySlot[tagname] = 0;
						tags[tags.size] = tagName;
					}
				}
				
				for (i=0;i<tags.size;i++)
				{
					emptySlot[tags[i]]++;
					if (emptySlot[tags[i]] < 2)
						continue;
					iprintlnbold ("Grenade throw needs fixing (check console)");
					println ("Grenade throw animation ", throw_anim, " has multiple weapons attached to ", tags[i]);
					break;
				}
			}
		#/
		self throwGrenade();
		
		if (isalive(self.enemy) && self.enemy == level.player)
		{
			// Do a cooldown on grenade throws alllll of the time
//			if (!smokeGrenade && randomint(100) > 60)
			if (!smokeGrenade)
				anim.lastPlayerGrenade = gettime() + anim.playerGrenadeBaseTime + randomint(anim.playerGrenadeRangeTime);
		}
		else
		{
			// Schedule the next earliest AI grenade for 1 to 2 minutes into the future
			anim.nextAIGrenade = gettime() + 60000 + randomint(60000);
		}
		
		
		self notify ("stop grenade check");
		
//		assert (attachSide != "none");
		if (attachSide != "none")		
			self detach(model, attachside);
		else
		{
			print ("No grenade hand set: ");
			println (throw_anim);
			println("animation in console does not specify grenade hand");
		}
		self.isHoldingGrenade = false;

		self.grenadeawareness = self.oldGrenAwareness;
		self.oldGrenAwareness = undefined;
		
		self waittillmatch("throwanim", "end");
		[[anim.putguninhand]](oldHand);
        return (true);
	}
	else
	{
	/#
		if (getdebugcvar("debug_grenademiss") == "on" && isdefined (destination))
			thread grenadeLine(armoffset, destination);
	#/		
	}
	return (false);
}


attachGrenadeModel(model, tag)
{
	self attach (model, tag);
	thread detachOnScriptChange(model, tag);
	return tag;
}


detachOnScriptChange(model, tag)
{
	self endon ("death");
	self endon ("stop grenade check");
	self waittill ("killanimscript");
	if (isdefined(self.oldGrenAwareness))
	{	
		self.grenadeawareness = self.oldGrenAwareness;
		self.oldGrenAwareness = undefined;
	}
	
	self detach(model, tag);
}

offsetToOrigin(start)
{
	forward = anglestoforward(self.angles);
	right = anglestoright(self.angles);
	up = anglestoup(self.angles);
	forward = vector_scale (forward, start[0]);
	right = vector_scale (right, start[1]);
	up = vector_scale (up, start[2]);
	return (forward + right + up);
}

grenadeLine(start, end)
{
	level notify ("armoffset");
	level endon ("armoffset");
	
	start = self.origin + offsetToOrigin(start);
	for (;;)
	{
		line (start, end, (1,0,1));
		print3d (start, start, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		print3d (end, end, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}
}

prepGrenade()
{
	self endon ("stop grenade check");
	self endon("killanimscript");
	prepGrenadeCheck();
	self MagicGrenadeManual (self.origin + (0,0,35), self.origin + randomvec(100), 2.5);
	self.grenadeammo--;
}

prepGrenadeCheck()
{
    self endon ("anim entered exposed");
    self endon ("anim entered pain");
	self endon("killanimscript");
    self waittill ("the end of time");
}


ShootRunningVolleyThread(endString, waitTime)
{
	self endon("killanimscript");
	if (isDefined(endString))
		self endon(endString);
	if (isDefined(waitTime))
		wait (waitTime);
	ShootRunningVolley(endString);
}

ShootRunningVolley(endString)
{
	self endon("killanimscript");
	if (isDefined(endString))
		self endon(endString);

	if (!isalive(self.enemy))
		return false;
		
	self.enemy endon ("death");
	self endon ("enemy");

	// Only shoot while running if you're using an automatic weapon.
	if (!animscripts\weaponList::usingAutomaticWeapon())
		return false;
	
	if (self.bulletsInClip <= 0)
	{
		// Don't shoot/run if you need to reload
		return 0;
	}
	if (self.anim_needsToRechamber)
	{
		// Don't shoot/run if you need to rechamber either
		return 0;
		
		/*
		oldHand = self.anim_gunHand;
		self setanim(%upperbody, 1, .1, 1);
		self setflaggedanimknob("rechamberanim", %upperbody_rechamber, 1, .1, 1);
		self playsound ("ai_rechamber");
		self animscripts\shared::DoNoteTracks("rechamberanim");
		self.anim_needsToRechamber = 0;	// This is in a notetrack but I don't want to miss it.
		[[anim.PutGunInHand]](oldHand);	// This is in a notetrack but I don't want to miss it.
		self clearanim(%upperbody, .1);
		*/
	}
	else
	{
		start = self.origin;
		end = self.enemy.origin;
		difference = vectornormalize(end - start);
//		angles = (0, difference[1], 0);
	    forward = anglesToForward(self.angles);
		dot = vectordot(forward, difference);
		
		// Don't turn far and fire while running
		if (dot < 0.9)
			return false;
		
		self thread EyesAtEnemy();
		numShots = randomint(6)+3;	// 3-8
		
		/*
		if (animscripts\weaponList::usingAutomaticWeapon())
			numShots = randomint(6)+3;	// 3-8
		else if (animscripts\weaponList::usingSemiAutoWeapon())
			numShots = randomint(2)+2;	// 2 or 3
		else
		{
			numShots = 1;
			self.anim_needsToRechamber = 1;	// I can set this now because there is no wait between here and shoot().
			// TODO Should check this variable and actually rechamber when I need to, once I can rechamber while running.
		}
		*/
		
		acc_mult = anim.runAccuracyMult;
		if (distance (self.origin, self.enemy.origin) > 450)
			acc_mult = 0.05;
			
		enemyAngle = animscripts\utility::AbsYawToEnemy();
		for (i=0; i<numShots && (self.bulletsInClip>0 && enemyAngle<25); i++)
		{
			self shootWrapper(acc_mult);
			self.bulletsInClip--;
			wait animscripts\weaponList::shootAnimTime();
			enemyAngle = animscripts\utility::AbsYawToEnemy();
		}
		self notify ("stop EyesAtEnemy");
	}
}


// Suppression volley of shots.
ShootRunningSuppressionVolley( )
{
	self thread ShootRunningSuppressionVolleyThread();
	self waittill ("suppressionAttackComplete");
}	


ShootRunningSuppressionVolleyThread()
{
//	self endon("killanimscript");
//	self endon (anim.scriptChange);
	self endon ("death");
	self notify ("clearSuppressionAttack");
	self endon ("clearSuppressionAttack");
	assert(0);

	// Only shoot while running if you're using an automatic weapon.
	if (!animscripts\weaponList::usingAutomaticWeapon())
		return false;

	if (self.bulletsInClip <= 0)
	{
		// Don't shoot/run if you need to reload
		return 0;
	}
	if (self.anim_needsToRechamber)
	{
		// Don't shoot/run if you need to rechamber either
		return 0;
	}

	numShots = randomint(8) + 6;
		
	if (self.bulletsInClip < numShots)
		numShots = self.bulletsInClip;

	while (numshots>0)
	{
		if (self.anim_suppressingEnemy)
			return false;
			
		if (self.anim_script != "move")
			break;
			
		sightPos = suppressableTarget();
		if (!isdefined(sightPos))
		{
			wait (0.1);
			continue;
		}
		
		for (;;)
		{
			if (self.bulletsInClip <= 0)
				break;
			self.anim_suppressingEnemy = true;

			myYawFromTarget = VectorToAngles(sightPos - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1] );
			
			
		//	acc_mult = anim.runAccuracyMult;
		//	if (distance (self.origin, self.enemy.origin) > 450)
		//		acc_mult = 0.05;
			acc_mult = 1;
				
	//		enemyAngle = animscripts\utility::AbsYawToOrigin(sightPos);
	//		enemyAngle = animscripts\utility::AbsYawToOrigin(originalSightPos);
			
	//		sightPos = goodEnemyPos(vectortoAngles (self.oldOrigin - self.origin));
			self shootWrapper(undefined, sightPos);
			self.bulletsInClip--;
			numshots--;
			wait animscripts\weaponList::shootAnimTime();
			sightPos = suppressableTarget();
			if ((!isdefined(sightPos)) || (!numShots))
			{
				self.anim_suppressingEnemy = false;
				self notify ("suppressionAttackComplete");
				wait (0.1);
				break;
			}
		}
	}

	if (self.anim_suppressingEnemy)
	{
		self.anim_suppressingEnemy = false;
		self notify ("suppressionAttackComplete");
	}
	return true;
}

suppressableTarget()
{
	if (!hasEnemySightPos())
	{
		self OrientMode( "face motion" );
		self.anim_suppressingEnemy = false;
		return undefined;
	}
	
//		sightPos = getEnemySightPos();
	sightPos = getEnemySightPos();
	if (!isdefined(sightPos))
	{
		self OrientMode( "face motion" );
		self.anim_suppressingEnemy = false;
		return undefined;
	}
	
	start = self.origin;
	end = sightPos;
	difference = vectornormalize(end - start);
    forward = anglesToForward(self.angles);
	dot = vectordot(forward, difference);
	
	// Don't turn far and fire while running
	if (dot < 0.1)
	{
		self OrientMode( "face motion" );
		self.anim_suppressingEnemy = false;
		return undefined;
	}
	return sightPos;
}


tryBackPedal()
{

	// Should be aiming at this point, but it's not important enough to assert against

	if (self.anim_pose != "stand" && self.anim_pose != "crouch")
	{
		// Can't backpedal if we're not in crouch or stand
		return false;
	}

	localDeltaVector = GetMoveDelta (%stand_shoot_run_back, 0, 1);
	endPoint = self LocalToWorldCoords( localDeltaVector );
	////	self.enemyDistanceSq = MyGetEnemySqDist();
	self.enemyDistanceSq = self GetClosestEnemySqDist();

	if (!isDefined(self.enemyDistanceSq))
	{
		return false;
	}

	success = false;

//	// Some debug info
//	/#
//		if (!isDefined(self.enemyDistanceSq))
//			println("HOLY COW HOW DID THIS HAPPEN?  self.enemyDistanceSq is undefined!  It was defined a moment ago!");
//		if (!self maymovetopoint(endPoint))
//		if (!isDefined(self.enemyDistanceSq))
//			println("HOLY COW HOW DID THIS HAPPEN?  self.enemyDistanceSq is undefined!  It was defined two moments ago!");
//		if (self.enemyDistanceSq > anim.backPedalRangeSq)
//		if (self.enemyDistanceSq <= anim.meleeRangeSq)
//	#/

	while ( (self maymovetopoint(endPoint)) && (self.enemyDistanceSq <= anim.backPedalRangeSq) && (self.enemyDistanceSq > anim.meleeRangeSq) )
	{
		success = true;
		self setflaggedanimknobAll("backpedalanim", %stand_shoot_run_back, %body, 1, .15, 1);
		////		thread ShootRunningVolleyThread("stopVolley");
		self.anim_pose = "stand";
		self.anim_movement = "run";
		self animscripts\shared::DoNoteTracks("backpedalanim");

		localDeltaVector = GetMoveDelta (%stand_shoot_run_back, 0, 1);
		endPoint = self LocalToWorldCoords( localDeltaVector );
		self.enemyDistanceSq = self GetClosestEnemySqDist();
	}
	return success;
}


// For use by combat scripts, looks at the enemy until the script is interrupted, or "stop EyesAtEnemy" is notified.
EyesAtEnemy()
{
	self notify ("stop EyesAtEnemy internal");	// Prevent buildup of threads.
	self endon ("death");
	self endon ("stop EyesAtEnemy internal");
	for (;;)
	{
		if (isDefined(self.enemy))
			self animscripts\shared::LookAtEntity(self.enemy, 2, "alert", "eyes only", "don't interrupt");
		wait 2;
	}
}

FindCoverNearSelf()
{
	currentNode = GetClaimedNode();
	if (isdefined(currentNode))
	{
		node = self findbestcovernode("prefer", currentNode);
	}
	else
	{
		node = self findbestcovernode();
	}
	
	if (isdefined(node))
	{
		if (self UseCoverNode(node))
			return true;
	}
	return false;
}

interruptpoint()
{
	if (!isDefined(self.enemy))
	{
		self.reacquire_state = 0;
		return;
	}

	if (self FindCoverNearSelf())
	{
		self.reacquire_state = 0;
		return;
	}

	if (self canSee(self.enemy) && self canShootEnemy())
	{
		self.reacquire_state = 0;
		return;
	}

	switch (self.reacquire_state)
	{
	case 0:
		if (self ReacquireStep(32))
		{
			assert(self.reacquire_state == 0);
			return;
		}
		break;

	case 1:
		if (self ReacquireStep(64))
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 2:
		if (self ReacquireStep(96))
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 3:
		self FindReacquireNode();
		self.reacquire_state++;
		// fall through

	case 4:
		node = self GetReacquireNode();
		if (isdefined(node))
		{
			if (self UseReacquireNode(node))
				self.reacquire_state = 0;
			return;
		}
		break;

	case 5:
		self FindReacquireDirectPath();
		self.reacquire_state++;
		// fall through

	case 6:
		// attempt to find a path that does not run out of goal and that can see the enemy (shorten path by 1 each call)
		if (self TrimPathToAttack())
			return;
		// path has succeeded or fully failed
		if (self ReacquireMove())
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 7:
		self FindReacquireProximatePath();
		self.reacquire_state++;
		// fall through

	case 8:
		// attempt to find a path that does not run out of goal and that can see the enemy (shorten path by 1 each call)
		if (self TrimPathToAttack())
			return;
		// path has succeeded or fully failed
		if (self ReacquireMove())
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	default:
		assert(self.reacquire_state == 9);
		self.reacquire_state = 0;
		if (self canSee(self.enemy))
			return;
		self FlagEnemyUnattackable();
		return;
	}
	
	self.reacquire_state++;
}

smoke_grenade ( optionalAnim, optionalOffset)
{
	org = self.smoke_destination_org;
	if (isdefined (level.smoke_thrower["smoke"+org]))
	{
		// So you dont go cutting into move or whatever and breaking your smoke throw
		if (level.smoke_thrower["smoke"+org] == self)
		{
			// Point him towards the grenade point
			myYawFromTarget = VectorToAngles(org - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1] );
			level waittill ("smoke_was_thrown"+org);
		}
			
		return;
	}
	self thread deathSmokeRenew(org);
	self endon("killanimscript");
//	self endon (anim.scriptChange);
	level endon ("smoke_was_thrown"+org);
	// Give him a smoke grenade
	if (isdefined(level.smoke_grenade_weapon))
		self.grenadeWeapon = level.smoke_grenade_weapon;
	else
		self.grenadeWeapon = "smoke_grenade_american";
	self.grenadeAmmo++;
	
	// Point him towards the grenade point
	myYawFromTarget = VectorToAngles(org - self.origin );
	self OrientMode( "face angle", myYawFromTarget[1] );
	
	//give him time to get aimed towards it
//		wait (0.25);
	// escape endons
	thread smoke_grenade_throw(org, optionalAnim, optionalOffset);
	self waittill ("could or could not throw smoke");
}


smoke_grenade_throw(org, optionalAnim, optionalOffset)
{
	self endon ("death");
	// Spawn it off as a separate function so that regardless of what happens, we take the grenade away and
	// do the notify.
	smoke_grenade_throwProc(org, optionalAnim, optionalOffset);
	self notify ("could or could not throw smoke");
	// Take the grenade back
	self.grenadeAmmo--;
}

smoke_grenade_throwProc(org, optionalAnim, optionalOffset)
{
	self endon ("killanimscript");
	if ((self TrySmokeGrenadePos(org, optionalAnim, optionalOffset)))
	{
		self notify ("could or could not throw smoke");
		// notify the group
		level.smoke_thrower["smoke"+org] = undefined;
		level.smoke_thrown["smoke"+org] = true;
		level notify ("smoke_was_thrown"+org);
		// throw was a success
		return;
	}
}

deathSmokeRenew(org)
{
	wait (1.8);
	if (!isdefined(level.smoke_thrower["smoke"+org]))
		return;
	
	if (isalive(self) && level.smoke_thrower["smoke"+org] == self)
	{
		level.smoke_thrower["smoke"+org] = undefined;
		return;
	}
	
	if (!isalive(level.smoke_thrower["smoke"+org]))
	{
		level.smoke_thrower["smoke"+org] = undefined;
		return;
	}
}

/*

smoke_grenade ( optionalAnim, optionalOffset)
{
	self endon("killanimscript");
	org = self.smoke_destination_org;
	level endon ("smoke_was_thrown"+org);
	oldRadius = self.goalradius;
	oldFightdist = self.fightdist;
	oldMaxdist = self.maxdist;
	
	self.goalradius = 4;
	self.fightdist = 0;
	self.maxdist = 10;
	self setgoalnode (self.smoke_destination_node);
	self animscripts\run::MoveStandNoncombatNormal();
	self waittill ("goal");
	
	oldWeapon = self.grenadeWeapon;
	for (;;)
	{	
		// Give him a smoke grenade
		self.grenadeWeapon = "smoke_grenade_british";
		self.grenadeAmmo++;
		
		// Point him towards the grenade point
		myYawFromTarget = VectorToAngles(org - self.origin );
		self OrientMode( "face angle", myYawFromTarget[1] );
		
		//give him time to get aimed towards it
//		wait (0.25);
		
		if ((self TryGrenadePos(org, optionalAnim, optionalOffset)))
		{
			// throw was a success
			break;
		}
		else
		{
			// Take the grenade back
			self.grenadeAmmo--;
			wait (1);
		}
	}

	self.goalradius = oldRadius;
	self.fightdist = oldFightdist;
	self.maxdist = oldMaxdist;
	// notify the group
	level.smoke_thrown["smoke"+org] = true;
	level notify ("smoke_was_thrown"+org);

	// Give him his old grenades back		
	self.grenadeWeapon = oldWeapon;
}
*/


newCorner()
{	
	weaponAnims = getAIWeapon(self.weapon)["anims"];
	if ( weaponAnims == "pistol" )
		return "oldCorner";

	assert (isdefined(self.node));
	oldCorner = isdefined(self.node.script_oldcorner);
	noWall = isdefined(self.node.script_nowall);

	if (oldCorner)
	{
		// only allies can do oldCorner behavior
 		if (self.team == "allies")
			return "oldCorner";
 		else
 			return "noWall";
	}
	
	if (noWall)
		return "noWall";

	return "newCorner";
}

setAimAndShootAnimations()
{
	self clearanim(%shoot, 0);
	anims = animscripts\weaponlist::standAimShootAnims();
	self setaimanims(	anims["aim_down"], 
						anims["aim_straight"], 
						anims["aim_up"], 
						anims["shoot_down"], 
						anims["shoot_straight"], 
						anims["shoot_up"]);
	/*
	if (animscripts\weaponList::usingAutomaticWeapon())
		self setaimanims(%stand_aim_down, %stand_aim_straight, %stand_aim_up, %stand_shoot_auto_down, %stand_shoot_auto_straight, %stand_shoot_auto_up);
	else
	if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		if (self animscripts\utility::weaponAnims() == "pistol")
			self setaimanims(	%stand_aim_down,			%stand_aim_straight,			%stand_aim_up, 
								%pistol_standshoot_down,	%pistol_standshoot_straight,	%pistol_standshoot_up);
		else
			self setaimanims(	%stand_aim_down,	%stand_aim_straight,	%stand_aim_up, 
								%stand_shoot_down,	%stand_shoot_straight,	%stand_shoot_up);
	}
	else // bolt action
		self setaimanims(%stand_aim_down, %stand_aim_straight, %stand_aim_up, %stand_shoot_down, %stand_shoot_straight, %stand_shoot_up);
	*/
}

dropPanz()
{
	if (!isdefined (self.anim_dropPanzer))
		return;
	self.anim_dropPanzerNow = true;

	wait (0.25);
	self setflaggedanimknobrestart("drop_panz", %stand_rocket_drop, 1, 0.1, 1);
	wait (0.2);
//	wait (1);
	weaponClass = "weapon_" + self.weapon;
	weapon = spawn (weaponClass, self getTagOrigin ("tag_weapon_right"));
	weapon.angles = self getTagAngles ( "tag_weapon_right" ); 
	
	if (self.secondaryweapon == "")
		self.weapon = "luger";
	else
		self.weapon = self.secondaryweapon;
	
	self.anim_dropPanzerNow = undefined;
	
	self animscripts\shared::PutGunInHand("right");
	self waittillmatch ("drop_panz", "end");

//	self thread animscripts\aim::aimPose();
/*
	self clearanim(%panzerfaust_cornercrouch_alert2aim_right, 0.5);
	self clearanim(%panzerfaust_cornercrouchaim_right, 0.5);
	self clearanim(%panzerfaust_cornercrouchaim2alert_right, 0.5);
	self clearanim(%panzerfaust_cornercrouchaimdown_right, 0.5);	 // What is this animation?
	self clearanim(%panzerfaust_cornercrouch_alert2aim_left, 0.5);
	self clearanim(%panzerfaust_cornercrouchaim_left, 0.5);
	self clearanim(%panzerfaust_cornercrouchaim2alert_left, 0.5);
	self clearanim(%panzerfaust_cornercrouchaimdown_left, 0.5);	 // What is this animation?
*/
	self clearanim(%panzerfaust_crouchaim_straight, 0.5);
	self clearanim(%panzerfaust_crouchaim_up, 0.5);
	self clearanim(%panzerfaust_crouchaim_down, 0.5);
	self clearanim(%panzerfaust_crouchshoot_straight, 0.5);
	self clearanim(%panzerfaust_crouchshoot_up, 0.5);
	self clearanim(%panzerfaust_crouchshoot_down, 0.5);
	self clearanim(%panzerfaust_crouchaim2lowwallcover, 0.5);
	self clearanim(%panzerfaust_lowwall_idle, 0.5);
	self clearanim(%panzerfaust_lowwall_twitch, 0.5);
	self clearanim(%panzerfaust_lowwallcover2crouchaim, 0.5);
	self clearanim(%panzerfaust_standidle2crouchaim, 0.5);
//	self clearanim(%shoot, 0.5);
	
}	


playReloadSound()
{
	// Code would play the alias here
	reloadSound = getAIWeapon(self.weapon)["reloadSound"];
	if (isdefined (reloadSound))
		self playsound (reloadSound);
//	self playsound ("weap_" + self.weapon + "_reload_npc");
}

tryReacquireNode()
{
	self FindReacquireNode();
	node = self GetReacquireNode();
	if (!isdefined(node))
		return false;
	return (self UseReacquireNode(node));
}

tryForcedReacquire()
{
	tryReacquireProc(true);
}

tryReacquire()
{
	tryReacquireProc(false);
}

tryReacquireProc(forcedReacquire)
{
	if (!self.anim_reacquireGuy)
		return;

	if (!isalive(self.enemy))
		return;

	if (!forcedReacquire && self canSeeEnemyFromExposed())
		return;
/*
	if (tryReacquireNode())
		return;
*/
		
	if (!self isingoal(self.enemy.origin))
		return;
		
	self FindReacquireDirectPath();
	self TrimPathToAttack();
	if (self ReacquireMove())
	{
		currentNode = GetClaimedNode();
		if (isdefined(currentNode))
		{
			// throw a badplace in so he doesnt go running back after			
			thread delayedBadplace(currentNode.origin);
		}
		if (self.anim_script == "combat") // combat script can cause base pose
			return;
		wait (0.1); // give move a chance to start
		self notify ("stop_idling"); // cover_crouch will keep idling, which causes a script assert due to conflicting with aim
		self animscripts\aim::aim(1); // do some animation so we cant basepose if the move script doesnt start
	}
}

delayedBadplace(org)
{
	self endon ("death");
	wait (0.5);
	/#
		if (getdebugcvar("debug_displace") == "on")
			thread badplacer(5, org, 16);
	#/
	
	string = "" + anim.badPlaceInt;
	badplace_cylinder(string, 5, org, 16, 64, self.team);
	anim.badPlaces[anim.badPlaces.size] = string;
	if (anim.badPlaces.size >= 10) // too many badplaces, delete the oldest one and then remove it from the array
	{
		newArray = [];
		for (i=1;i<anim.badPlaces.size;i++)
			newArray[newArray.size] = anim.badPlaces[i];
		badplace_delete(anim.badPlaces[0]);
		anim.badPlaces = newArray;
	}
	anim.badPlaceInt++;
	if (anim.badPlaceInt > 10)
		anim.badPlaceInt-= 20;
}

idleWhileIhaveNoEnemy()
{
	self.anim_Alertness = "casual";

	if (isalive(self.enemy))
		return;
		
	self endon ("got_enemy");
	thread detectEnemy();

	if (self.anim_idleSet != "a" && self.anim_idleSet != "b" )
	{
		if (randomint(100) > 50)
			self.anim_idleSet = "a";
		else
			self.anim_idleSet = "b";
	}

	if (self.anim_movement == "stop")
       	animscripts\aim::dontAim();

	for (;;)
	{
		if (self.anim_pose == "stand")
			animscripts\stop::StandStillThink(false);
		else
			animscripts\stop::CrouchStillThink(false);
	}
}

detectEnemy()
{
	self endon ("killanimscript");
	for (;;)
	{
		if (isalive(self.enemy))
			self notify ("got_enemy");
		wait (0.05);
	}
}

WaitForEnemy()
{
	self endon ("enemy");
	for (;;)
	{
		if (isalive(self.enemy))
			break;
		wait 0.05;
	}
}
