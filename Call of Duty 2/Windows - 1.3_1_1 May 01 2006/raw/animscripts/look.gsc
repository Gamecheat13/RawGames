// Look.gsc
// Controls looking left and right by blending animation weights, and provides support functions so that the 
// correct left and right poses are chosen.
#using_animtree ("generic_human");


lookThread()
{
//	self endon ("death");	// So thread won't persist after I die.
//	self endon ("never look at anything again");

	// Global variables
//	anim.playerGlanceDistanceSq = 300*300;	// Friendlies glance at the player if he's within this distance

	// Initialize
//	self.anim_targetLookAnimYawMax = 90;
//	self setLookAtAnimNodes(%look_straight, %look_left, %look_right);
//	self.anim_lookEndTime = GetTime();
//	self.anim_targetLookInitilized = true;

// Looking functionality and animations don't currently exist.  
return;
/*
	self thread cleanUpThread();

	if (self.team == "allies")
	{
		// This thread glances at the player once every x seconds, if he's within range and we can see him.
		self thread periodicallyGlanceAtThePlayer();
	}

	// The functions LookAtEntity and LookAtPosition in shared.gsc allows us to look at other things by notifying "look now" the same 
	// as periodicallyGlanceAtThePlayer does.

	// Now start one loop and start the other in a thread.
	self thread WaitForEyesOnlyLook();
	for (;;)
	{
		self waittill ("look now");
		println]]("look now notified");#/
		self notify ("stop looking");
		self thread lookAtTarget();
	}
*/
}
/*
WaitForEyesOnlyLook()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("eyes look now");
		println]]("eyes look now notified");#/
		self notify ("stop looking");
		self thread lookAtTarget("eyes only");
	}
}
*/
/*
cleanUpThread()
{
	self endon ("death");
	self waittill ("never look at anything again");
	self finishLookAt();
	//self stopLookAt(self.anim_lookTargetSpeed);
}
*/
/*
periodicallyGlanceAtThePlayer()
{
	self endon ("death");	// So thread won't persist after I die.
	self endon ("never look at anything again");

	timeBetweenGlances = randomFloatRange(8.0, 10.0);
	firstLookWait = (timeBetweenGlances/2) + randomfloat(timeBetweenGlances/2);
	lastLookedAtThePlayer = (GetTime()/1000) - firstLookWait; 
	wait (firstLookWait);
	player = animscripts\utility::GetPlayer();
	for (;;)
	{
		success = TryToGlanceAtThePlayerNow();
		if (success)
		{
			lastLookedAtThePlayer = (GetTime()/1000);
		}
		// Wait until next time to check to see if we can see the player
		timeToWait = lastLookedAtThePlayer - (GetTime()/1000) + randomFloatRange(timeBetweenGlances*0.8, timeBetweenGlances);
		if (timeToWait < 0.5)
			timeToWait = 0.5;
		wait (timeToWait);
	}
}
*/
TryToGlanceAtThePlayerNow()
{
	return false; // player was not defined - currently not changing (broken in 1.26 mk checkin) functionality
/*
	if (!isAlive(player))
	{
		return false;		// Don't glance at the player after he's dead.
	}
	milestoneanims = getCvarInt ("milestoneanims");
	if ( (self.anim_alertness!="aiming") &&	// Don't glance at the player when you should be shooting at something.
		(milestoneanims ==0) )				// Don't glance at the player while viewing milestone anims.
	{
		println]]("Alertness is "+self.anim_alertness+", trying to glance at player.");#/
		// Whenever we enter this loop, we want to glance at the player, so check to see if we can.
		playerPos = player GetEye();
		myPos = self GetEye();
		distanceSq = lengthSquared(playerPos - myPos);
		if ( (self.anim_script != "scripted") && (self.anim_script != "turret") &&
			(GetTime() > self.anim_lookEndTime) &&			// We're not looking at anything else
			(distanceSq < anim.playerGlanceDistanceSq) &&	// We're within range
			(self CanSee(player))						// We have line-of-sight
			)
		{
			playerYaw = player.angles[1];
			myYawFromPlayer = VectorToAngles(myPos - playerPos);
			myYawFromPlayer = myYawFromPlayer[1];
			myYawFromPlayer -= playerYaw;
//			if ( (myYawFromPlayer <= 40) && (myYawFromPlayer >= -40) )
			{
				// OK, player is looking near me.  Glance at him.
				self animscripts\shared::lookatentity(player, randomFloatRange(.75, 1.5), "casual");
				return true;
			}
		}
	}
	return false;
*/
}
/*
lookAtTarget(eyesOnly)
{
	self endon ("death");	// So thread won't persist after I die.
	self endon ("stop looking");
	self endon ("never look at anything again");

	assertEX(self.anim_lookTargetType=="sentient" || self.anim_lookTargetType=="entity" || self.anim_lookTargetType=="origin", "Currently, lookTargetType must be sentient or origin, was "+self.anim_lookTargetType);
	assert]]( !isDefined(eyesOnly) || (eyesOnly=="eyes only") );#/
	println]]("Start looking");#/

	if (self.anim_lookTargetType == "sentient")
	{
		targetEntity = self.anim_lookTargetEntity;
		if (!isSentient(targetEntity))
		{
			println("Tried to look at sentient but entity is not a sentient.");
			return;
		}

		lookTargetPos = targetEntity GetEye();
	}
	else if (self.anim_lookTargetType == "entity")
	{
		targetEntity = self.anim_lookTargetEntity;
		if (!isDefined(targetEntity))
		{
			println("Tried to look at entity but entity is not defined.");
			return;
		}

		lookTargetPos = targetEntity.origin;
	}
	else
	{
		targetEntity = undefined;
		lookTargetPos = self.anim_lookTargetPos;
	}

	// Set initial lookat position
	self setLookAt(lookTargetPos, self.anim_lookTargetSpeed);
	
	updatePeriod = 0.05;
	self.anim_lastYawTime = GetTime();
	startTime = GetTime();
	blendtime = 1;

	// Now update the angles once per frame until we're finished looking.
	while ( GetTime() < self.anim_lookEndTime )
	{
		if (self.anim_lookTargetType == "sentient")
		{
			if (isAlive(targetEntity))
			{
				// Only update the target pos if it's alive - otherwise assume it hasn't moved.
				lookTargetPos = targetEntity GetEye();
			}
			self setLookAt(lookTargetPos);
		}
		else if (self.anim_lookTargetType == "entity")
		{
			lookTargetPos = targetEntity.origin;
			self setLookAt(lookTargetPos);
		}
		eyePos = self GetEye();
/#
		debugTargetPos = (lookTargetPos[0], lookTargetPos[1], lookTargetPos[2]-2);	// So player can see debug line aimed at him.
		// Draw a yellow line for eyesonly, green line for full lookat.
		if ( isDefined(eyesOnly) && eyesOnly=="eyes only" )
			thread animscripts\utility::drawDebugLine(eyePos, debugTargetPos, (1,1,0), 2);
		else
			thread animscripts\utility::drawDebugLine(eyePos, debugTargetPos, (0,1,0), 2);
#/

		// Make the eyes look in the correct direction
		currentEyeAngles = self GetTagAngles ("TAG_EYE");
		currentEyeUp = anglesToUp( currentEyeAngles );
		currentEyeRight = anglesToRight( currentEyeAngles );
		targetDir = vectorNormalize( lookTargetPos - eyePos );
		rightAmount = vectorDot(currentEyeRight, targetDir);
		upAmount	= vectorDot(currentEyeUp, targetDir);
		rightAngle	= asin(rightAmount);
		upAngle		= asin(upAmount);
		// Tweak the numbers empirically, to make it work better.
		upAngle += 7;
		upAngle *= 0.6;
		rightAngle *= 0.5;

		// Some things only need to updated periodically, such as what look animations to use for the current pose.
		if ( (GetTime()-startTime) % 500 < 50 )
		{
			SetLookAnims(self.anim_pose, self.anim_movement, self.anim_alertness, self.anim_special, self.anim_idleset, blendtime, eyesOnly);
			// Print debugging info periodically also
			//println]]("LookAtTarget: Right angle: "+rightAngle+", up angle: "+upAngle);#/
		}
		// Limit the angles to a range that I can actually look at.
		eyeLookLimit = 30;
		if ( rightAngle < (-1*eyeLookLimit) )
		{
			rightAngle = (-1*eyeLookLimit);
		}
		else if ( rightAngle > eyeLookLimit )
		{
			rightAngle = eyeLookLimit;
		}
		if ( upAngle < (-1*eyeLookLimit) )
		{
			upAngle = (-1*eyeLookLimit);
		}
		else if ( upAngle > eyeLookLimit )
		{
			upAngle = eyeLookLimit;
		}
		
		eyeLookMax = 30;
		// Do right first
		fractionToBlend = rightAngle / eyeLookMax;
		if (fractionToBlend > 1)
		{
			fractionToBlend = 1;
		}
		else if (fractionToBlend < -1)
		{
			fractionToBlend = -1;
		}
		if (fractionToBlend > 0)
		{
			self SetAnim(%eyes_lookright_30, fractionToBlend, 0.1);
			self SetAnim(%eyes_lookleft_30, 0, 0.1);
		}
		else 
		{
			fractionToBlend = -1*fractionToBlend;
			self SetAnim(%eyes_lookleft_30, fractionToBlend, 0.1);
			self SetAnim(%eyes_lookright_30, 0, 0.1);
		}

		// Now do up the same way.
		fractionToBlend = upAngle / eyeLookMax;
		if (fractionToBlend > 1)
		{
			fractionToBlend = 1;
		}
		else if (fractionToBlend < -1)
		{
			fractionToBlend = -1;
		}
		if (fractionToBlend > 0)
		{
			self SetAnim(%eyes_lookup_30, fractionToBlend, 0.1);
			self SetAnim(%eyes_lookdown_30, 0, 0.1);
		}
		else 
		{
			fractionToBlend = -1*fractionToBlend;
			self SetAnim(%eyes_lookdown_30, fractionToBlend, 0.1);
			self SetAnim(%eyes_lookup_30, 0, 0.1);
		}
		self SetAnim(%eyes_straight, 1, 0.1);	// The animations are all made at double the angle so they can be diluted like this.



		self.anim_lastYawTime = GetTime();
		wait (updatePeriod);
	}

	finishLookAt();
}
*/

finishLookAt()
{
return;	// Look is broken/cut
/*
	// Reset the eyes once the lookat is done.
	self SetAnim(%eyes_lookleft_30, 0, 0.1);
	self SetAnim(%eyes_lookright_30, 0, 0.1);
	self SetAnim(%eyes_lookup_30, 0, 0.1);
	self SetAnim(%eyes_lookdown_30, 0, 0.1);

	// 99.9% of the time this is defined but it's possible to get here without having actually looked at anything.
	if ( isDefined(self.anim_lookTargetSpeed) )	
	{
		// Turn the head slower when we stop looking
		self stopLookAt(self.anim_lookTargetSpeed*0.75);
	}
	else
	{
		self stopLookAt(1000);
	}

	self notify ("stop looking");
	println]]("finishLookAt");#/
*/
}

/*
SetLookAnims(pose, movement, alertness, special, idleset, blendtime, eyesOnly)
{
	assert]](alertness=="aiming" || alertness == "alert" || alertness == "casual", "look::setLookAnims: alertness was "+alertness);#/
	println]]("Look animations are ",self.anim_LookAnimationLeft,", ",self.anim_LookAnimationRight);#/
	if ( (self.anim_script=="pain") || (self.anim_script=="death") )
	{
		//println]]("WARNING0: Look anims set to nothing "+pose+" "+movement+" "+special+" "+alertness+" "+idleset);#/
		lookAnimYawMax = self.anim_targetLookAnimYawMax;
		lookYawLimit = 0;
	}
	else if ( (self.anim_script=="scripted") && (isDefined(self.anim_EyesOnlyLook)) && self.anim_EyesOnlyLook==true )
	{
		//println]]("Look anims set to \"eyes only\" by script");#/
		lookAnimYawMax = self.anim_targetLookAnimYawMax;
		lookYawLimit = 0;
	}
	else if ( (self.anim_script=="scripted") && (isDefined(self.anim_LookAnimationLeft)) )
	{
		// (Assume that anim_LookAnimationRight is also defined.)
		println]]("Look anims set by script");#/
		lookAnimYawMax = 90;
		lookYawLimit = 90;
		self SetAnimKnobAll (self.anim_LookAnimationLeft, %look_left, 1, blendtime);
		self SetAnimKnobAll (self.anim_LookAnimationRight, %look_right, 1, blendtime);
	}
	else if ( isDefined(eyesOnly) && (eyesOnly=="eyes only") )
	{
		//println]]("Doing \"eyes only\" lookat");#/
		lookAnimYawMax = self.anim_targetLookAnimYawMax;
		lookYawLimit = 0;
	}
	else
	{
		switch (pose)
		{
		case "stand":
			if ( (special == "none") && (movement == "stop") )
			{
				if (alertness == "aiming")
				{
					//println]]("Look anims set to stand aim");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%stand_aim_look_left_90, %look_left, 1, blendtime);
					self SetAnimKnobAll (%stand_aim_look_right_90, %look_right, 1, blendtime);
				}
				else
				{
					if (idleset=="a")
					{
						//println]]("Look anims set to stand alert a");#/
						lookAnimYawMax = 90;
						lookYawLimit = 90;
						self SetAnimKnobAll (%stand_alert_look_left_90, %look_left, 1, blendtime);
						self SetAnimKnobAll (%stand_alert_look_right_90, %look_right, 1, blendtime);
					}
					else
					{
						//println]]("Look anims set to stand alert b");#/
						lookAnimYawMax = 90;
						lookYawLimit = 90;
						self SetAnimKnobAll (%stand_alertb_look_left_90, %look_left, 1, blendtime);
						self SetAnimKnobAll (%stand_alertb_look_right_90, %look_right, 1, blendtime);
					}
				}
			}
			else if ( (special == "cover_left") && (alertness == "casual") )
			{
				if (idleset == "a")
				{
					//println]]("Look anims set to stand corner left a");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornerA_right_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornerA_right_lookright, %look_right, 1, blendtime);
				}
				else
				{
					assert]](idleset == "b", "Bad idleset: "+idleset);#/
					//println]]("Look anims set to stand corner left b");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornerB_right_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornerB_right_lookright, %look_right, 1, blendtime);
				}
			}
			else if ( (special == "cover_right") && (alertness == "casual") )
			{
				if (idleset == "a")
				{
					//println]]("Look anims set to stand corner right a");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornerA_left_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornerA_left_lookright, %look_right, 1, blendtime);
				}
				else
				{
					assert]](idleset == "b", "Bad idleset: "+idleset);#/
					//println]]("Look anims set to stand corner right b");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornerB_left_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornerB_left_lookright, %look_right, 1, blendtime);
				}
			}
			else
			{
				//println]]("WARNING1: Look anims set to nothing "+pose+" "+movement+" "+special+" "+alertness+" "+idleset);#/
				lookAnimYawMax = self.anim_targetLookAnimYawMax;
				lookYawLimit = 0;
			}
			break;
		case "crouch":
			if ( (special == "none") && (movement == "stop") )
			{
				if (alertness == "aiming")
				{
					//println]]("Look anims set to crouch aim");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%crouch_aim_look_left_90, %look_left, 1, blendtime);
					self SetAnimKnobAll (%crouch_aim_look_right_90, %look_right, 1, blendtime);
				}
				else
				{
					if (idleset == "a")
					{
						//println]]("Look anims set to crouch alert a");#/
						lookAnimYawMax = 90;
						lookYawLimit = 90;
						self SetAnimKnobAll (%crouch_alerta_look_left_90, %look_left, 1, blendtime);
						self SetAnimKnobAll (%crouch_alerta_look_right_90, %look_right, 1, blendtime);
					}
					else if (idleset == "b")
					{
						//println]]("Look anims set to crouch alert b");#/
						lookAnimYawMax = 90;
						lookYawLimit = 90;
						self SetAnimKnobAll (%crouch_alertb_look_left_90, %look_left, 1, blendtime);
						self SetAnimKnobAll (%crouch_alertb_look_right_90, %look_right, 1, blendtime);
					}
					else
					{
						println ("Error: animscripts\look::SetLookAnims: Crouch, idleset is "+idleset);
						lookAnimYawMax = self.anim_targetLookAnimYawMax;
						lookYawLimit = 0;
					}
				}
			}
			else if ( (special == "cover_left") && (alertness == "casual") )
			{
				if (idleset == "a")
				{
					//println]]("Look anims set to crouch corner left a");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornercrouchA_right_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornercrouchA_right_lookright, %look_right, 1, blendtime);
				}
				else
				{
					assert]](idleset == "b", "Bad idleset: "+idleset);#/
					//rintln]]("Look anims set to crouch corner left b");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornercrouchB_right_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornercrouchB_right_lookright, %look_right, 1, blendtime);
				}
			}
			else if ( (special == "cover_right") && (alertness == "casual") )
			{
				if (idleset == "a")
				{
					//println]]("Look anims set to crouch corner right a");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornercrouchA_left_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornercrouchA_left_lookright, %look_right, 1, blendtime);
				}
				else
				{
					assert]](idleset == "b", "Bad idleset: "+idleset);#/
					//println]]("Look anims set to crouch corner right b");#/
					lookAnimYawMax = 90;
					lookYawLimit = 90;
					self SetAnimKnobAll (%casualcornercrouchB_left_lookleft, %look_left, 1, blendtime);
					self SetAnimKnobAll (%casualcornercrouchB_left_lookright, %look_right, 1, blendtime);
				}
			}
			else
			{
				//println]]("WARNING2: Look anims set to nothing "+pose+" "+movement+" "+special+" "+alertness+" "+idleset);#/
				lookAnimYawMax = self.anim_targetLookAnimYawMax;
				lookYawLimit = 0;
			}
			break;
		default:
			//println]]("WARNING3: Look anims set to nothing "+pose+" "+movement+" "+special+" "+alertness+" "+idleset);#/
			lookAnimYawMax = self.anim_targetLookAnimYawMax;
			lookYawLimit = 0;
		}
	}

	assert]](isDefined(lookAnimYawMax), "lookAnimYawMax wasn't set in SetLookAnims");#/
	assert]](isDefined(lookYawLimit), "lookYawLimit wasn't set in SetLookAnims");#/

	self.anim_targetLookAnimYawMax = lookAnimYawMax;
	
	self setLookAtYawLimits(lookAnimYawMax, lookYawLimit, blendtime);
}
*/