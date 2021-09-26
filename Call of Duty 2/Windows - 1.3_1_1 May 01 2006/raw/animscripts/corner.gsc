#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#using_animtree ("generic_human");


CornerBehavior( cornerOrigin, cornerAngle, corneranims )
{
	self teleport (cornerOrigin);

	self animscripts\face::SetIdleFace(anim.alertface);
	CornerAlertIdle( 0.5, corneranims["anim_alert"], "Entered corner behavior" );

	// Reload if we need to
//	self TryGrenade( corneranims["anim_grenade"], corneranims["offset_grenade"]/*, corneranims["gunhand_grenade"]*/ );
	self Reload( 0.15, corneranims["anim_reload"] );
	self Rechamber();

	wasSuppressed = 0;
	while (self isSuppressed())
	{
		self.suppressed = true;
		if (wasSuppressed)
		{
			// Talk about it
			animscripts\battleChatter_ai::evaluateSuppressionEvent();
			animscripts\combat_say::specific_combat("undersuppression");
		}
		wasSuppressed = 1;
		CornerAlertIdle( self.suppressionwait, corneranims["anim_alert"], "Suppressed" );
		if ( self.suppressionwait == 0.0 ) // fix infinite loop due to changing suppressionwait in console
			break;
//		self TryGrenade( corneranims["anim_grenade"], corneranims["offset_grenade"]/*, corneranims["gunhand_grenade"]*/ );
	}
	self.suppressed = false;
	// If you were suppressed, you might want to check before attacking
	rand = randomint(100);
	if ( wasSuppressed && rand<50 && isDefined(corneranims["anim_look"]) )
	{
		self setflaggedanimknobAll("animdone", corneranims["anim_look"], %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("animdone");
	}
	else if (randomint(100) < self.ramboChance && isDefined(corneranims["anim_alert2rambo"]) && self.team != "allies" )
	{
		CornerRambo(corneranims["anim_alert2rambo"], corneranims["anim_rambo2alert"]);
	}
	else
	{
		CornerAttack(cornerAngle, corneranims, "Rand > rambo");
	}

}


CornerAlertIdle( timeToIdle, idleAnim, changeReason )
{
    entryState = self . scriptState;
    self trackScriptState ( "CornerAlertIdle", changeReason );

	// NB idleAnim is either a single frame or a looping anim, so we can set and forget.
	self setAnimKnobAllRestart(idleAnim, %body, 1, .1, 1);
	wait timeToIdle;

    self trackScriptState ( entryState, "CornerAlertIdle finished" );
}


CornerAttack( cornerAngle, corneranims , changeReason )
{
    entryState = self . scriptState;
    self trackScriptState( "CornerAttack", changeReason );

	self SetAnimKnobAll( %cover, %body, 1, 0.2);
	self clearanim(%cover, 0.2);

	// Get the yaw to the enemy.  This might be handled by a constantly-updating code function eventually.
	thread UpdateCornerAimThread( "stop updating angles", corneranims["anim_blend"], corneranims["angle_aim"], cornerAngle );

	self Set3FlaggedAnimKnobs("animdone", corneranims["anim_alert2aim"], 1, .1, 1);
	self animscripts\shared::DoNoteTracks("animdone");
	self.anim_alertness = "aiming";	// Should be set in the alert2aim animation but sometimes isn't.
	self animscripts\face::SetIdleFace(anim.aimface);


	// Wait a moment, so the animation looks better.  (This time could be tweaked for difficulty.)
	self SetAnimKnobRestart(corneranims["anim_semiautofire"]["left"],	1, .1, 0);
	self SetAnimKnobRestart(corneranims["anim_semiautofire"]["middle"],	1, .1, 0);
	self SetAnimKnobRestart(corneranims["anim_semiautofire"]["right"],	1, .1, 0);
	wait 0.1;
	
	self thread EyesAtEnemy();

	// Now shoot
	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		// First few shots have lower accuracy.
		totalShots = randomint(9) + 7;
		quickShots = randomint(2) + 3;
		animRate = animscripts\weaponList::autoShootAnimRate();
		if ( animscripts\utility::sightCheckNode() )
		{
			self Set3FlaggedAnimKnobs("animdone", corneranims["anim_autofire"], 1, .1, animRate);
			if (self.bulletsInClip < quickShots)
				numShots = self.bulletsInClip;
			else
				numShots = quickShots;
			estimatedTime =  0.1 * (numShots) / (animRate);
			self thread KillRunawayAutofire("cornerattack autofire done", estimatedTime);
			self thread DoAutoFireLocal("cornerattack autofire done", numShots, anim.blindAccuracyMult[self.team]);	// Poor accuracy until we "look".
			self waittill("cornerattack autofire done");
		}
		if (self.bulletsInClip<=0)
		{
			self notify ("stop EyesAtEnemy");
			return;
		}
		WaitForAmbush(corneranims["anim_aim"], 3, "Waiting to see enemy");
		if ( !self isSuppressed() && animscripts\utility::sightCheckNode() )
		{
			self Set3FlaggedAnimKnobs("animdone", corneranims["anim_autofire"], 1, .1, animRate);
			if (self.bulletsInClip < totalShots-quickShots)
				numShots = self.bulletsInClip;
			else
				numShots = totalShots-quickShots;
			estimatedTime =  0.1 * (numShots) / (animRate);
			self thread KillRunawayAutofire("cornerattack autofire done", estimatedTime);
			self thread DoAutoFireLocal("cornerattack autofire done", numShots, 1);
			self waittill("cornerattack autofire done");
		}
	}
	else if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		// First couple of shots have lower accuracy.
		totalShots = randomint(4) + 3;
		quickShots = randomint(totalShots-2);
		shootTime = animscripts\weaponList::shootAnimTime();
		if ( animscripts\utility::sightCheckNode() )
		{
//			self OrientMode ("face enemy with offset", attackYawOffset);
			for (i=0; i<quickShots && self.bulletsInClip>0; i++)
			{
				self Set3FlaggedAnimKnobs("not_flagged", corneranims["anim_semiautofire"], 1, .1, 1);
				self shoot(anim.blindAccuracyMult[self.team]);	// Poor accuracy until we "look".
				self.bulletsInClip --;
				animscripts\utility::sightCheckNode();
				wait shootTime;
			}
		}
		if (self.bulletsInClip<=0)
		{
			self notify ("stop EyesAtEnemy");
			return;
		}
		WaitForAmbush(corneranims["anim_aim"], 3, "Waiting to see enemy");
		if ( animscripts\utility::sightCheckNode() )
		{
			for (i=quickShots; i<(totalShots-1) && self.bulletsInClip>0; i++)
			{
				self Set3FlaggedAnimKnobs("not_flagged", corneranims["anim_semiautofire"], 1, .1, 1);
				self shoot ();		// Better accuracy after looking.
				self.bulletsInClip --;
				wait shootTime;
			}
			self Set3FlaggedAnimKnobs("not_flagged", corneranims["anim_semiautofire"], 1, .1, 1);
			self shoot ();
			wait animscripts\weaponList::waitAfterShot();
		}
	}
	else // bolt action
	{
		assertEX(!self.anim_needsToRechamber, "Cover attack - forgot to rechamber first!");
		//self Rechamber();	// Only does something if we actually need to rechamber.
		// WaitForAmbush returns instantly if the enemy is in sight.
		if (self.team=="axis")	// Enemies should give the player a chance to react - this could be tweaked for difficulty.
		{
			wait 0.4;	
		}
		WaitForAmbush(corneranims["anim_aim"], 3, "Waiting to see enemy");
		if ( animscripts\utility::sightCheckNode() )
		{
			// Just shoot once.
			shootTime = animscripts\weaponList::shootAnimTime();
			self Set3FlaggedAnimKnobs("not_flagged", corneranims["anim_boltfire"], 1, .1, 1);
			self shoot ();
			self.anim_needsToRechamber = 1;
			self.bulletsInClip --;
			wait animscripts\weaponList::waitAfterShot();
		}
	}
	// Wait a moment longer if you're not suppressed - like you're looking to see if you hit
	if (!self isSuppressed())
	{
		self Set3FlaggedAnimKnobs("not_flagged", corneranims["anim_aim"], 1, .1, 1);
		wait 0.25;
	}

	// Go back into hiding.
	self animscripts\face::SetIdleFace(anim.alertface);
	self Set3FlaggedAnimKnobs("animdone", corneranims["anim_aim2alert"], 1, .1, 1);
	self animscripts\shared::DoNoteTracks("animdone");
	self.anim_alertness = "alert";	// Should be set in the aim2alert animation but sometimes isn't.
	self notify ( "stop updating angles" );

    self trackScriptState( entryState , "CornerAttack returned" );
	self notify ("stop EyesAtEnemy");
}

DoAutoFireLocal(notifystring, numshots, accuracy)
{
	assert(numshots>0);
	self endon(notifyString);
	self endon("killanimscript");
	self endon("death");
	for (i=0; i<numshots; i++)
	{
		self waittillmatch("animdone", "fire");
		self shoot (accuracy);
		self.bulletsInClip --;
	}
	self notify (notifyString);
}
/*ClampAngle(angle, clampTo, playUpper, playLower)
{
	// nb Upper and lower must be +ve numbers.
	if (angle > clampTo+360)
		angle -= 360;
	if (angle < clampTo-360)
		angle += 360;
	if (angle > clampTo+playUpper)
	{
		angle = clampTo+playUpper;
	}
	else if (angle < clampTo-playLower)
	{
		angle = clampTo-playLower;
	}
	return angle;
}*/


CornerRambo(ramboStartAnim, ramboEndAnim)
{
	entryState = self . scriptState;
	self trackScriptState ( "CornerRambo", "function" );

	self animMode ( "gravity" ); // Unlatch the feet

	// We're backwards
	delta = GetMoveDelta (ramboStartAnim, 0, 1);
	delta = ( -1 * delta[0] , -1 * delta[1] , delta[2] );

	ramboPoint = self LocalToWorldCoords( delta );

 	if ( (self maymovetopoint(ramboPoint)) /*&& (self animscripts\utility::CanShootEnemyFromPose("stand", delta ))*/ )
	{
		self thread EyesAtEnemy();
		oldAnimSpecial = self.anim_special;
		self.anim_special = "none";
		/#thread animscripts\utility::drawDebugLine (self.origin, ramboPoint, (0, 1, 0), 20);#/ // green line


		self setflaggedanimknobAll("animdone", ramboStartAnim, %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("animdone");

		RamboFire();

		self notify ("stop EyesAtEnemy");
		self setflaggedanimknobAll("animdone", ramboEndAnim, %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("animdone");
		self.anim_special = oldAnimSpecial;	// Should be handled in notetracks but might not be.
	}
 	else
	{
 		/#thread animscripts\utility::drawDebugLine (self.origin, ramboPoint, (1, 0, 0), 20);#/ // red line
	}
    self trackScriptState ( entryState, "CornerRambo finished" );
}


RamboFire()
{
	self setflaggedanimknobAll("animdone", %ramboanticipation, %body, 1, .1, 1);
	self animscripts\shared::DoNoteTracks("animdone");

	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self setflaggedanimknobAll("firedone", %ramboautomaticfire, %body, 1, .1, 1);
		animscripts\utility::sightCheckNode();

		// Check to see if we're going to hit our enemy before firing - mainly because we don't want to hit our friends.
		if ( self animscripts\utility::CanShootEnemy(undefined, false) )	// Only check canshoot, not cansee.
		{
			rand = randomint(5) + 5;
			for (i=0;i<rand;i++)
			{
				self shoot(anim.ramboAccuracyMult);
				self waittillmatch("firedone", "fire");
			}
		}
		// else play a pause animation, where he looks around
	}
	else
	{
		animscripts\utility::sightCheckNode();
		rand = randomint(3) + 2;
		for (i=0;i<rand;i++)
		{
			// Check to see if we're going to hit our enemy before firing - mainly because we don't want to hit our friends.
			if ( self animscripts\utility::CanShootEnemy(undefined, false) )	// Only check canshoot, not cansee.
			{
				shootTime = animscripts\weaponList::shootAnimTime();
				self setflaggedanimknobAll("firedone", %rambosemiautofire, %body, 1, .1, 1);
				self shoot(anim.ramboAccuracyMult);
				wait shootTime;
			}
		}
	}
}


Set3FlaggedAnimKnobs(animFlag, animArray, weight, blendTime, rate)
{
	self SetAnimKnob(					animArray["left"],	weight, blendTime, rate);
	self SetFlaggedAnimKnob(animFlag,	animArray["middle"],weight, blendTime, rate);
	self SetAnimKnob(					animArray["right"],	weight, blendTime, rate);

	//UpdateCornerAim( animArray, angleArray, cornerYaw );
}


// Blocking substate
WaitForAmbush(waitAnimArray, timeToWait, changeReason )
{
	if ( !isDefined (changeReason) )
		changeReason = "FIXME";
	entryState = self . scriptState;
	self trackScriptState( "WaitForAmbush", changeReason );
	// Check for my enemy every 0.25 seconds, but only contribute to the invalidation of the node once a second.
	timeWaited = 0.0;
	while (!animscripts\utility::sightCheckNode() && timeWaited<timeToWait && (!self isSuppressed()) )
	{
		for (i=0 ; i<4 && !animscripts\utility::sightCheckNode() && timeWaited<timeToWait ; i++)
		{
			self SetAnimKnob(waitAnimArray["left"], 1, .1, 1);
			self SetAnimKnob(waitAnimArray["middle"], 1, .1, 1);
			self SetAnimKnob(waitAnimArray["right"], 1, .1, 1);
			wait 0.25;
			timeWaited += 0.25;
		}
	}
	// Blocking substate - set state back to calling state
	self trackScriptState( entryState, "WaitForAmbush finished." );
}


// TODO - Put me in code!
// Requires that animArray and angleArray each contain 3 corresponding entries.  The angles must be in 
// ascending order, "left", "middle" and "right".  Also assumes that any angle between angleArray["right"] 
// and 180 is > angleArray["right"], and any angle between -180 and angleArray["left"] is < 
// angleArray["left"].
UpdateCornerAimThread( endString, animArray, angleArray, cornerYaw )
{
	self endon ("killanimscript");
	self endon (endString);

	for (;;)
	{
		UpdateCornerAim ( animArray, angleArray, cornerYaw );
		
		wait 0.2;
	}
}

UpdateCornerAim( animArray, angleArray, cornerYaw )
{
	// We're careful not to set any weights to 0 for two reasons.  First, we need to make sure that 
	// Set3FlaggedAnimKnobs doesn't flag an animation with weight 0, and second, if Set3FlaggedAnimKnobs sets 
	// an animation whose parent weight is 0, that parent's weight gets set to 1, which causes an odd twitch.
	closeToZero = 0.01;

	attackYaw = GetCornerYawToEnemy();

	yawDelta = cornerYaw - attackYaw;
//	yawDelta = attackYaw;
	yawDelta = int(yawDelta+360) % 360;
	if ( yawDelta > 180 )
		yawDelta -= 360;
	
	if (yawDelta<=angleArray["left"])
	{
		animWeights["left"] = 1;
		animWeights["middle"] = closeToZero;
		animWeights["right"] = closeToZero;
	}
	else if (yawDelta<angleArray["middle"])
	{
		leftFraction = ( angleArray["middle"] - yawDelta ) / ( angleArray["middle"] - angleArray["left"] );
		if (leftFraction < closeToZero)		leftFraction = closeToZero;
		if (leftFraction > 1-closeToZero)	leftFraction = 1-closeToZero;
		animWeights["left"] = leftFraction;
		animWeights["middle"] = (1 - leftFraction);
		animWeights["right"] = closeToZero;
	}
	else if (yawDelta<angleArray["right"])
	{
		middleFraction = ( angleArray["right"] - yawDelta ) / ( angleArray["right"] - angleArray["middle"] );
		if (middleFraction < closeToZero)	middleFraction = closeToZero;
		if (middleFraction > 1-closeToZero)	middleFraction = 1-closeToZero;
		animWeights["left"] = closeToZero;
		animWeights["middle"] = middleFraction;
		animWeights["right"] = (1 - middleFraction);
	}
	else
	{
		animWeights["left"] = closeToZero;
		animWeights["middle"] = closeToZero;
		animWeights["right"] = 1;
	}

	self setanim( animArray["left"],	animWeights["left"],	0.1 );	// anim, weight, blend-time
	self setanim( animArray["middle"],	animWeights["middle"],	0.1 );
	self setanim( animArray["right"],	animWeights["right"],	0.1 );

}

GetCornerYawToEnemy()
{
	enemyPos = GetEnemyEyePos();
	angles = VectorToAngles(enemyPos-self.origin);
	return angles[1];
}
