#using_animtree ("generic_human");

// prone is a bit of a misnomer - it means fighting from prone range,
// not necessarily prone

// FIXME BUG - prone guys start going prone within goal radius and land outside, causing them to get up and run back into radius and repeat - need to check before going prone.
ProneRangeCombat( changeReason )
{
    self trackScriptState( "ProneRangeCombat", changeReason );
	self endon("killanimscript");

	[[anim.println]]("Entering prone::ProneRangeCombat");

	[[anim.assert]]( isDefined ( changeReason ) , "Script state called without reason.");

	self thread ProneTurningThread(::ProneCombatThread, "kill ProneRangeCombat");

	self waittill ("kill ProneRangeCombat");

	// transition back to combat - FIXME JBW decide on different states from here
	[[anim.println]]("Leaving prone::ProneRangeCombat (\"end ProneRangeCombat\" notified)");
	self thread animscripts\exposedcombat::GeneralExposedCombat("Dist < ProneRangeSq" );
	//self thread animscripts\combat::main();
}


// Runs the actual prone combat thread, and handles turning during prone combat.
ProneTurningThread(threadToSpawn, killmeString)
{
	self endon ("killanimscript");
	self endon ("death");
	self endon (killmeString);

	[[anim.println]]("Entering prone::ProneTurningThread");
	self.anim_usingProneLeftAndRight = false;
	if (isDefined(threadToSpawn))
		self thread [[threadToSpawn]]("kill ProneTurningThread children");

	// Detect when we want to turn, kill the combat thread, turn, and restart the thread.
	for (;;)
	{
		if (self.anim_pose != "prone")
		{
			self OrientMode("face default");	// If we're not prone (yet), allow the code to keep turning us as it sees fit.
		}
		else
		{
			self OrientMode("face current");
			attackYaw = animscripts\utility::GetYawToEnemy();
			yawDelta = self.angles[1] - attackYaw;	// FYI self.desiredyaw does not give me the angle I want - it gives me the current angle.
			yawDelta = (int)(yawDelta+360) % 360;
			if ( yawDelta > 180 )
				yawDelta -= 360;
			[[anim.println]]("Prone combat: yaw Delta: "+yawDelta);
			if ( yawDelta > 0 )
			{
				if (self.anim_usingProneLeftAndRight)
				{
					[[anim.locSpam]]("c100t");
					amount = (float)yawDelta / 45.0;
					if (amount<0.01)
						amount = 0.01;
					else if (amount>0.99)
						amount = 0.99;
					// SetAnimKnob on one of them so that other animations can't interfere.
					self SetAnimKnob(%prone_straight, 1.0-amount, 0.1, 1);
					self SetAnim(%prone_right45, amount, 0.1, 1);
					self SetAnim(%prone_left45, 0.01, 0.1, 1);
				}
				if ( yawDelta > 45 )
				{
					[[anim.locSpam]]("c101t");
					[[anim.println]]("Prone, turning right");
					self notify ("kill ProneTurningThread children");
					self [[anim.putGunInHand]]("right");	// In case we interrupted a rechamber
					self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
					self animscripts\shared::DoNoteTracks("turn anim");
					self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
					[[anim.println]]("Prone, finished turning right");
					if (isDefined(threadToSpawn))
						self thread [[threadToSpawn]]("kill ProneTurningThread children");
				}
			}
			else
			{
				if (self.anim_usingProneLeftAndRight)
				{
					[[anim.locSpam]]("c103t");
					amount = (float)yawDelta / -45;
					if (amount<0.01)
						amount = 0.01;
					else if (amount>0.99)
						amount = 0.99;
					// SetAnimKnob on one of them so that other animations can't interfere.
					self SetAnimKnob(%prone_straight, 1.0-amount, 0.1, 1);
					self SetAnim(%prone_left45, amount, 0.1, 1);
					self SetAnim(%prone_right45, 0.01, 0.1, 1);
				}
				if ( yawDelta < -45 )
				{
					[[anim.locSpam]]("c104t");
					[[anim.println]]("Prone, turning left");
					self notify ("kill ProneTurningThread children");
					self [[anim.putGunInHand]]("right");	// In case we interrupted a rechamber
					self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_left, 1, 0.1, 1);
					self animscripts\shared::DoNoteTracks("turn anim");
					self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
					[[anim.println]]("Prone, finished turning left");
					if (isDefined(threadToSpawn))
						self thread [[threadToSpawn]]("kill ProneTurningThread children");
				}
			}
		}
		[[anim.locSpam]]("c105t");
		self thread WaitForNotify("Update prone aim", "Prone aim done waiting", "Prone aim done waiting");
		self thread WaitForTime(0.3, "Prone aim done waiting", "Prone aim done waiting");
		self waittill ("Prone aim done waiting");
	}
}


// This used to be the bulk of ProneRangeCombat
ProneCombatThread(killmeString)
{
	self endon ("killanimscript");
	self endon ("death");
	self endon (killmeString);
	[[anim.println]]("Entering prone::ProneCombatThread");
	wait 0;		// This prevents this thread from notifying before ProneTurningThread has got to a wait. 
    for (;;)
    {
		if ( !self isStanceAllowed("prone") )
		{
			[[anim.println]]("Leaving prone::ProneCombatThread (prone not allowed)");
			self notify ("kill ProneRangeCombat");
			return;
		}

		isProne = self.anim_pose == "prone";
		canShootFromProne = animscripts\utility::canShootEnemyFromPose( "prone", undefined, !isProne );
		canGoProne = CanGoProneHere(self.origin, self.angles[1]);
        if (!canGoProne || !canShootFromProne )
        {
			[[anim.println]]("Leaving prone::ProneCombatThread (can't go prone or can't shoot from prone)");
			self notify ("kill ProneRangeCombat");
			return;
        }        

		[[anim.locSpam]]("c100a");
		ProneShootVolley();
		[[anim.locSpam]]("c100b");
		animscripts\combat::Reload(0);
		[[anim.locSpam]]("c100c");

        self.enemyDistanceSq = self GetClosestEnemySqDist();
        if (animscripts\utility::GetNodeType() != "Cover Prone" && self.enemyDistanceSq < anim.proneRangeSq ) 
        {
			[[anim.println]]("Leaving prone::ProneCombatThread (enemy too close)");
			self notify ("kill ProneRangeCombat");
			return;
        }
    }
    
}

WaitForNotify(waitForString, notifyString, killmeString)
{
	self endon ("killanimscript");
	self endon ("death");
	self endon (killmeString);
	self waittill (waitForString);
	self notify (notifyString);
}

WaitForTime(time, notifyString, killmeString)
{
	self endon ("killanimscript");
	self endon ("death");
	self endon (killmeString);
	wait (time);
	self notify (notifyString);
}


CanDoProneCombat(origin, yaw)
{
    if ( animscripts\combat::MyGetEnemySqDist() < anim.proneRangeSq )
        return 0;

	// Do an early out based on canShootProne because checkProne does a lot if traces
	canShootProne = animscripts\utility::canShootEnemyFromPose ("prone");
	if(!canShootProne)
		return 0;
	
	// We already know canShootProne is true, so just return canFitProne
	return CanGoProneHere(origin, yaw);
}

CanGoProneHere(origin, yaw)
{
	alreadyProne = (self.anim_pose == "prone");
	canFitProne = self checkProne(origin, yaw, alreadyProne);
	return canFitProne;
}


ProneShootVolley()
{
	[[anim.println]]("Entering prone::ProneShootVolley");

	self [[anim.SetPoseMovement]]("prone","stop");
	shootanims["middle"]	= %prone_shoot_straight;
	shootanims["left"]		= %prone_shoot_left;
	shootanims["right"]		= %prone_shoot_right;
	autoshootanims["middle"]	= %prone_shoot_auto_straight;
	autoshootanims["left"]		= %prone_shoot_auto_left;
	autoshootanims["right"]		= %prone_shoot_auto_right;

	[[anim.locSpam]]("c101s");
	self animscripts\face::SetIdleFace(anim.aimface);
	self.anim_usingProneLeftAndRight = true;
	self notify ("Update prone aim");	// This makes sure we're aiming the right way, since we were probably 
										// aiming straight ahead when we entered this thread.

//	self setanimknob(%prone_legsstraight, 1, 0.05, 1); // Didn't want to mess with prone hierarchy
	self setanimknob(%prone, 1, 0.15, 1);
	// Aim for a moment, just to add some variety.
	rand = randomfloat(1);
	self animscripts\corner::Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0.15, 0); // TODO - make this an aim anim.
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	wait rand;
	[[anim.locSpam]]("c102s");
	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self animscripts\face::SetIdleFace(anim.autofireface);
		self animscripts\corner::Set3FlaggedAnimKnobs("shootanim", autoshootanims, 1, 0.15, 0); // TODO - make this an aim anim.
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		wait 0.2;

		animRate = animscripts\weaponList::autoShootAnimRate();
		self animscripts\corner::Set3FlaggedAnimKnobs("shootanim", autoshootanims, 1, 0.05, animRate);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		rand = randomint(8)+6;
//		enemyAngle = animscripts\utility::AbsYawToEnemy();
		for (i=0; i<rand /*&& enemyAngle<20*/; i++)
		{
			[[anim.locSpam]]("c103a");
			self waittillmatch ("shootanim", "fire");
			self shoot();	
			self.bulletsInClip --;
//			enemyAngle = animscripts\utility::AbsYawToEnemy();
		}
	}
	else if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		self animscripts\corner::Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0.2, 0);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		wait 0.2;

		rand = randomint(3)+2;
//		enemyAngle = animscripts\utility::AbsYawToEnemy();
		for (i=0; i<rand /*&& enemyAngle<20*/; i++)
		{
			[[anim.locSpam]]("c103b");
			self animscripts\corner::Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0, 1);
//			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
			self shoot();	
			self.bulletsInClip --;
			shootTime = animscripts\weaponList::shootAnimTime();
			quickTime = animscripts\weaponList::waitAfterShot();
			wait quickTime;
			if (i<rand-1 && shootTime>quickTime)
				wait shootTime - quickTime;
//			enemyAngle = animscripts\utility::AbsYawToEnemy();
		}
	}
	else // Bolt action
	{
		animscripts\combat::Rechamber();	// In theory you will almost never need to rechamber here, 
											// because you will have done it somewhere smarter, like in cover.
		// Slowly blend in the first frame of the shoot instead of playing the transition.
		self animscripts\corner::Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0.2, 0);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		wait 0.2;

		[[anim.locSpam]]("c104a");
		self animscripts\corner::Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0, 1);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		self shoot();	
		self.bulletsInClip --;
		self.anim_needsToRechamber = 1;
		[[anim.locSpam]]("c104b");
		quickTime = animscripts\weaponList::waitAfterShot();
		wait quickTime;
		[[anim.locSpam]]("c104c");
	}
	self.anim_usingProneLeftAndRight = false;
	[[anim.locSpam]]("c105s");
	[[anim.println]]("Leaving prone::ProneShootVolley");
}

/*
ProneAim()
{
	[[anim.println]]("Entering prone::ProneAim");
	self [[anim.SetPoseMovement]]("prone","stop");
	
	[[anim.locSpam]]("c101s");
	self animscripts\face::SetIdleFace(anim.aimface);

//	self setanimknob(%prone_legsstraight, 1, 0.05, 1); // Didn't want to mess with prone hierarchy
	self setanimknob(%prone, 1, 0.15, 1);

	self animscripts\corner::Set3FlaggedAnimKnobs("animdone", shootanims, 1, 0.15, 0); // TODO - make this an aim anim.
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	wait 1 + randomfloat(0.5);
	[[anim.println]]("Leaving prone::ProneAim");
}
*/