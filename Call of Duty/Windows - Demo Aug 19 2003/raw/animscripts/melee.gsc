#using_animtree ("generic_human");

MeleeCombat( changeReason )
{
    self trackScriptState( "melee", changeReason );
	self endon("killanimscript");


	[[anim.println]]("Entering combat::MeleeCombat");
	[[anim.assert]]((self GetClosestEnemySqDist()) <= anim.meleeRangeSq, "combat::MeleeCombat - not in range!");
	[[anim.assert]](isAlive(self.enemy),"Can't melee - I don't have an enemy.");

	[[anim.assert]]( isDefined ( changeReason ) , "Script state called without reason.");

    for ( ;; )
    {
		//        self . scriptState = "melee";
		if ( !TryMeleeCharge() )
		{
			break;
		}

		// If no one else is meleeing this person, tell the system that I am, so no one else will charge him.
		myTurn = animscripts\utility::okToMelee(self.enemy);
		if (myTurn)
		{
			animscripts\utility::IAmMeleeing(self.enemy);
			realMelee = true;
		}
		else
		{
			// If someone else is meleeing, I will still melee, but don't bother telling the system.
			//[[anim.println]]("Someone else is meleeing my enemy so I can't");
			//// Try to back off
			//backPedalled = tryBackPedal();
			//if (backPedalled)
			//{
			//	continue;
			//}
			//println ("Cornered - I have to melee even though someone else already is.");
			realMelee = false;
		}


		[[anim.PutGunInHand]]("right");
		self thread animscripts\combat::EyesAtEnemy();

		if ( (self.anim_movement=="run") && (self.anim_pose=="stand") )
		{
			Melee_RunToStop();
		}
		else
		{
			self [[anim.SetPoseMovement]]("stand","stop");
		}
		[[anim.assert]](self.anim_movement == "stop", "combat::MeleeCombat "+self.anim_movement);
		if (!isAlive(self.enemy))
		{
			break;	// Enemy died while I was stopping.
		}

		[[anim.locSpam]]("c30");

		self animscripts\face::SayGenericDialogue("meleeattack");	// This does sound and facial animation.

		self setanimknoball(%melee, %body, 1, .05, 1);

		endmeleeState = self.anim_meleeState;

		player = animscripts\utility::GetPlayer();
		if (self.enemy == player)
		{
			enemypose = player getstance();
		}
		else
		{
			enemypose = self.enemy.anim_pose;
		}

        // Now whack!
        switch(self.anim_meleeState)
        {
        case "charge":
            [[anim.locSpam]]("c31a");
            self setflaggedanimknob("meleeanim", %melee_charge2right, 1, .1, 1); // anim, weight, xblend time, rate
            endmeleeState = "right";
            [[anim.locSpam]]("c32a");
            endmeleeState = "right";
            break;
        case "aim":
            if (enemypose == "stand")
            {
                [[anim.locSpam]]("c31b");
                self setflaggedanimknob("meleeanim", %aim2melee_right, 1, .15, 1); // anim, weight, xblend time, rate
                endmeleeState = "right";
            }
            else
            {
                [[anim.locSpam]]("c31c");
                self setflaggedanimknob("meleeanim", %aim2meleecrouch_left, 1, .15, 1);
                endmeleeState = "left";
            }
            [[anim.locSpam]]("c32b");
            break;
        case "right":
            rand = randomint(100);
            if (enemypose == "stand")
            {
                [[anim.locSpam]]("c33");
                if (rand<30)
                {
                    [[anim.locSpam]]("c34");
                    self setflaggedanimknob("meleeanim", %melee_right2right_1, 1, .1, 1);	
                }
                else if (rand<60)
                {
                    [[anim.locSpam]]("c35");
                    self setflaggedanimknob("meleeanim", %melee_right2right_2, 1, .1, 1);	
                }
                else
                {
                    [[anim.locSpam]]("c36");
                    self setflaggedanimknob("meleeanim", %melee_right2left, 1, .1, 1);	
                    endmeleeState = "left";
                }
            }
            else
            {
                if (rand<50)
                {
                    [[anim.locSpam]]("c37");
                    self setflaggedanimknob("meleeanim", %meleecrouch_right2right, 1, .1, 1);	
                }
                else
                {
                    [[anim.locSpam]]("c38");
                    self setflaggedanimknob("meleeanim", %meleecrouch_right2left, 1, .1, 1);	
                    endmeleeState = "left";
                }
            }
            [[anim.locSpam]]("c39");
            break;
        case "left":
            rand = randomint(100);
            [[anim.locSpam]]("c40");
            if (enemypose == "stand")
            {
                if (rand<30)
                {
                    [[anim.locSpam]]("c41");
                    self setflaggedanimknob("meleeanim", %melee_left2left_1, 1, .1, 1);	
                }
                else if (rand<60)
                {
                    [[anim.locSpam]]("c41");
					self setflaggedanimknob("meleeanim", %melee_left2left_2, 1, .1, 1);	
				}
				else 
				{
					[[anim.locSpam]]("c42");
					self setflaggedanimknob("meleeanim", %melee_left2right, 1, .1, 1);	
					endmeleeState = "right";
				}
			}
			else
			{
				if (rand<50)
				{
					[[anim.locSpam]]("c42b");
					self setflaggedanimknob("meleeanim", %meleecrouch_left2left, 1, .1, 1);	
				}
				else if (rand<60)
				{
					[[anim.locSpam]]("c42c");
					self setflaggedanimknob("meleeanim", %meleecrouch_left2right, 1, .1, 1);	
					endmeleeState = "right";
				}
			}
			[[anim.locSpam]]("c42d");
			break;
		default:
			homemade_error = Unexpected_meleeState_value + meleeState;
			break;
		}
		animscripts\shared::DoNoteTracks("meleeanim", ::CatchMeleeNote);
		self.anim_meleeState = endmeleeState;	// This is because I don't entirely trust notetracks yet.
		[[anim.locSpam]]("c43");
		if (!isAlive(self.enemy))
		{
			break;	// Killed my enemy.
		}
    }

	if (realMelee)
	{
		animscripts\utility::ImNotMeleeing(self.enemy);
	}
	[[anim.println]]("Leaving combat::MeleeCombat");

	self thread animscripts\combat::main();
	self notify ("stop EyesAtEnemy");
	return; // transition back to combat - FIXME JBW decide on different states from here
}


TryMeleeCharge()
{
	[[anim.println]]("Entering TryMeleeCharge");

	if (!isAlive(self.enemy))
	{
		[[anim.println]]("Can't meleeCharge - I don't have an enemy.");
		return false;
	}
	// Should be aiming at this point, but it's not important enough to assert against
	if (self.anim_alertness != "aiming")
		[[anim.println]]("Not aiming on entry to meleeCharge - that's bad.");

	if (self.anim_pose != "stand")
	{
		// Can't charge if we're not standing
		[[anim.println]]("Can't meleeCharge in pose "+self.anim_pose);
		return false;
	}

	enemyPoint = self.enemy GetOrigin();
	self.enemyDistanceSq = lengthSquared ( self.origin - enemyPoint );	// TODO This should probably be a code function
	if (self.enemyDistanceSq <= anim.meleeRangeSq)
	{
		[[anim.println]](" Enemy is already close enough to melee.");
		return true;
	}
	if (self.enemyDistanceSq > anim.chargeRangeSq)
	{
		[[anim.println]](" Enemy isn't close enough to charge.");
		return false;
	}

	myTurn = animscripts\utility::okToMelee(self.enemy);
	if (!myTurn)
	{
		[[anim.println]](" Someone else is meleeing my enemy so I can't charge");
		// Don't return false, because if enemy is already within melee range then this charge was actually successful.
	}
	else
	{
		self thread animscripts\combat::EyesAtEnemy();
		// Constants.
		localDeltaVector = GetMoveDelta (%melee_charge2right, 0, 1);
	//	chargeCycleTime = getanimlength(%melee_charge);
		sampleTime = 0.2;
		// Values which change every time we resample.
		// (These first two are already known from just above)
		//enemyPoint = self.enemy GetOrigin();
		//self.enemyDistanceSq = lengthSquared ( self.origin - enemyPoint );	// TODO This should probably be a code function
		predictedDistanceSq = self.enemyDistanceSq;
		vecToEnemy = enemyPoint - self.origin;
		dirToEnemy = vectorNormalize (vecToEnemy);
		meleePoint = enemyPoint - (dirToEnemy[0]*32, dirToEnemy[1]*32, dirToEnemy[2]*32);
		clearPath = self maymovetopoint(meleePoint);
		success = false;

		// Some debug info
		{
			if (!clearPath)
			{
				thread animscripts\utility::drawDebugLine(self.origin, meleePoint, (1,0,0), 20);
				[[anim.println]](" Can't run to enemy.");
			}
		}

		[[anim.PutGunInHand]]("right");
		firstTimeThrough = true;
		while ( (clearPath) && 
				(self.enemyDistanceSq <= anim.chargeRangeSq) && 
				(self.enemyDistanceSq > anim.meleeRangeSq) &&
				(predictedDistanceSq > anim.meleeRangeSq) 
				)
		{
			thread animscripts\utility::drawDebugLine(self.origin, meleePoint, (0,1,0), 20);
			if (firstTimeThrough)
			{
				self animscripts\face::SayGenericDialogue("meleecharge");
				animscripts\utility::IAmMeleeing(self.enemy);
				firstTimeThrough = false;
			}
			self SetFlaggedAnimKnobAll("chargeanim", %melee_charge, %body, 1, .15, 1);
			self animscripts\shared::DoNoteTracksForTime(sampleTime, "chargeanim");
			self.anim_movement = "run";	// In case the note wasn't there or was missed.

			if (!isAlive(self.enemy))	// Enemy died while I was charging
			{
				[[anim.println]](" Enemy died while I was charging.");
				self notify ("stop EyesAtEnemy");
				return false;
			}
			enemyPoint = self.enemy GetOrigin();
			self.enemyDistanceSq = lengthSquared ( self.origin - enemyPoint );	// TODO This should probably be a code function
			predictedSelfOrigin = self LocalToWorldCoords( localDeltaVector );
			predictedDistanceSq = lengthSquared ( predictedSelfOrigin - enemyPoint );
			vecToEnemy = enemyPoint - self.origin;
			dirToEnemy = vectorNormalize (vecToEnemy);
			meleePoint = enemyPoint - (dirToEnemy[0]*32, dirToEnemy[1]*32, dirToEnemy[2]*32);
			clearPath = self maymovetopoint(meleePoint);
			success = true;
		}
	
		// (We know enemy is alive at this point.)  If we got to within running-striking distance, and we're 
		// running, then play the running melee animation.
		if ( (predictedDistanceSq <= anim.meleeRangeSq) && clearPath && (self.anim_movement == "run") )
		{
			Melee_RunToStop();
			if (isAlive(self.enemy))
			{
				enemyPoint = self.enemy GetOrigin();
				self.enemyDistanceSq = lengthSquared ( self.origin - enemyPoint );	// TODO This should probably be a code function
			}
			else
			{
				self notify ("stop EyesAtEnemy");
				return false;	// Enemy died while I was stopping.
			}
		}
		animscripts\utility::ImNotMeleeing(self.enemy);
	}
	if ( isAlive(self.enemy) && (self.enemyDistanceSq <= anim.meleeRangeSq) )
		success = true;
	else
		success = false;
	[[anim.println]]("Leaving meleecharge (result "+success+")");
	self notify ("stop EyesAtEnemy");
	return success;
}




Melee_RunToStop()
{
	self animscripts\face::SayGenericDialogue("meleeattack");	// This does sound and facial animation.
	self SetFlaggedAnimKnobAll("meleeanim", %melee_charge2right, %body, 1, .1, 1); // name, anim, rootanim, weight, xblend time, rate
	animscripts\shared::DoNoteTracks("meleeanim", ::CatchMeleeNote);
	self.anim_meleeState = "right";	// This is because I don't entirely trust notetracks yet.
	self.anim_movement = "stop";
}



CatchMeleeNote(note)
{
	if (note == "melee")
	{
		self melee();
	}
	else
	{
		println ("Note "+note+" was not handled by DoNoteTrack or CatchMeleeNote.");
	}
}