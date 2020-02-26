#using_animtree ("generic_human");

GeneralExposedCombat( changeReason )
{
	self endon("killanimscript");

    self trackScriptState( "General Exposed Combat", changeReason );
	[[anim.assert]]( isDefined ( changeReason ) , "Script state called without reason.");

	[[anim.println]]("Entering combat::RangedCombat");

	self OrientMode("face enemy");

	for ( ;; )
	{
		// Nothing below will work if our gun is completely empty.
        self [[anim.SetPoseMovement]]("","stop");
        animscripts\combat::Reload(0);


        // Now decide whether to stand or crouch.
		dist = self GetClosestEnemySqDist();
		isStanding = self.anim_pose == "stand";
		isCrouching = self.anim_pose == "crouch";
		if (!isDefined(dist))
		{
			if (isStanding)
				dist = anim.standRangeSq - 1;
			else
				dist = anim.standRangeSq + 1;
		}
		// If the enemy is close and we can stand, then don't allow crouching.  Similarly if the enemy is far 
		// and we can crouch, then don't allow standing.
		// When checking CanShootFromPose, do a sight check only if we're not in that pose currently.  This 
		// is to prevent guys from, say, crouching and then changing AI states because they lost sight of 
		// their enemy.
		if (dist<anim.standRangeSq)
		{
			canStand				= self isStanceAllowed("stand");
			if (canStand)
				canShootStand		= self animscripts\utility::CanShootEnemyFromPose( "stand", undefined, !isStanding );
			else
				canShootStand		= false;
			if (canShootStand)
			{
				canShootCrouch		= false;
			}
			else
			{
				canCrouch			= self isStanceAllowed("crouch");
				if (canCrouch)
					canShootCrouch	= self animscripts\utility::CanShootEnemyFromPose( "crouch", undefined, !isCrouching );
				else
					canShootCrouch	= false;
			}
		}
		else
		{
			canCrouch				= self isStanceAllowed("crouch");
			if (canCrouch)
				canShootCrouch		= self animscripts\utility::CanShootEnemyFromPose( "crouch", undefined, !isCrouching );
			else
				canShootCrouch		= false;
			if (canShootCrouch)
			{
				canShootStand		= false;
			}
			else
			{
				canStand			= self isStanceAllowed("stand");
				if (canStand)
					canShootStand	= self animscripts\utility::CanShootEnemyFromPose( "stand", undefined, !isStanding );
				else
					canShootStand	= false;
			}
		}
        
        if ( canShootstand )
        {
            [[anim.println]]("ExposedCombat - Standing combat");
            // Since the enemy is likely quite close while we're in standing combat, we need to check his distance 
            // often, so we can engage in melee combat quickly.
            self [[anim.SetPoseMovement]]("stand","stop");

            self animscripts\aim::aim();
            
			// The closer you are, the more likely you'll try to dodge.
			sideStepChance = (anim.dodgeRangeSq - dist) / (anim.dodgeRangeSq - anim.meleeRangeSq);
            if ( self.team != "allies" && randomFloat(1) < sideStepChance)
                trySideStep();

            success = animscripts\combat::ShootVolley(0);
//			if (!success)
				self interruptPoint();	// We couldn't shoot for some reason, so now would be a good time to run for cover.
        }
        else if ( canShootCrouch )
        {
            [[anim.println]]("ExposedCombat - Crouched combat");
            self [[anim.SetPoseMovement]]("crouch","stop");

            self animscripts\aim::aim();
            success = animscripts\combat::ShootVolley(0);
//			if (!success)
				self interruptPoint();	// We couldn't shoot for some reason, so now would be a good time to run for cover.
        }
        else
        {
            [[anim.println]]("ExposedCombat - Can't shoot from standing or crouching, trying sidestep");
            // Can't shoot from standing or crouching.  Try stepping to the side, and then try going prone.
			foundAGoodShot = trySideStep();

            if (!foundAGoodShot)
            {
                // Can't hit the enemy from stand, crouch or prone.  Aim for a short time.
				[[anim.println]]("ExposedCombat - Can't hit enemy - waiting");
                self [[anim.SetPoseMovement]]("","stop");
                [[anim.assert]] (self.anim_movement == "stop", "combat::RangedCombat: About to call aim, movement is "+self.anim_movement);
                animscripts\aim::aim(0.1);
            }
        }
        
        self.enemyDistanceSq = self animscripts\combat::MyGetEnemySqDist();
        if ( (self.enemyDistanceSq > anim.proneRangeSq) )
        {
            self thread animscripts\prone::ProneRangeCombat("enemydist > pronerange");
            return;
        }
		canMelee = animscripts\melee::TryMeleeCharge();
		if (canMelee)
		{
			[[anim.locSpam]]("c4a");
			self thread animscripts\melee::MeleeCombat("TryMeleeCharge passed");
            return;
		}
        animscripts\combat::TryGrenade();   
		self interruptPoint();
    }    
}


FIXMECrouchedCombat()
{
	[[anim.println]]("Entering combat::CrouchedCombat");
	self [[anim.SetPoseMovement]]("crouch","stop");

	[[anim.locSpam]]("c20");

	[[anim.assert]] (self.anim_movement == "stop", "combat::CrouchedCombat: About to call aim, movement is "+self.anim_movement);
	self animscripts\aim::aim();
	if ( ! animscripts\utility::canShootEnemy() )
	{
		[[anim.println]] ("CrouchedCombat - can't shoot enemy, aborting");
		return;
	}

	[[anim.locSpam]]("c21");


	[[anim.assert]](self.anim_alertness == "aiming", "combat::CrouchedCombat: About to call ShootVolley but not aiming");
//	ShootVolley(1);
	animscripts\combat::ShootVolley(0);

}


trySideStep()
{
	// Allies do go back and forth in pegasusday without this
	if ( self.team == "allies" )
		return 0;
	
//	[[anim.assert]](self.anim_alertness == "aiming", "combat::trySideStep: Need to be aiming");
//	[[anim.assert]](self.anim_pose == "stand", "combat::trySideStep: Need to be standing");

	foundAGoodShot = 0;
	if ( (self.anim_pose == "stand") && (self isStanceAllowed("stand")) )
	{
		sideStepAnim[0] = %stand_shoot_jump_left;
		sideStepAnim[1] = %stand_shoot_jump_right;
		sideStepAnim[2] = %stand_shoot_walk_left;
		sideStepAnim[3] = %stand_shoot_walk_right;
		sideStepAnim[4] = %stand_shoot_run_left;
		sideStepAnim[5] = %stand_shoot_run_right;

        startingAnim = anim . lastSideStepAnim;

		for (i=0 ; i<sideStepAnim.size && !foundAGoodShot ; i++)
		{
			thisAnim = i + startingAnim;
			if (thisAnim >= sideStepAnim.size)
				thisAnim -= sideStepAnim.size;

			localDeltaVector = GetMoveDelta (sideStepAnim[thisAnim], 0, 1);
			endPoint = self LocalToWorldCoords( localDeltaVector );

			if ( (self maymovetopoint(endPoint)) && (self animscripts\utility::CanShootEnemyFromPose("stand", localDeltaVector )) )
			{
				thread animscripts\utility::drawDebugLine (self.origin, endPoint, (0, 1, 0), 20);// green line

				// Get in position
				if (self.anim_alertness == "aiming")
				{
					self [[anim.SetPoseMovement]]("stand","");
				}
				else
				{
					self [[anim.SetPoseMovement]]("stand","stop");
					self animscripts\aim::aim();
				}

				// Animate
				self setflaggedanimknobAll("sideStepAnim", sidestepAnim[thisAnim], %body, 1, .15, 1);
				thread animscripts\combat::ShootRunningVolleyThread("stopVolley", 0.2);
				self animscripts\shared::DoNoteTracks("sideStepAnim");
				self notify("stopVolley");
				foundAGoodShot = 1;
                break;
			}
			else
				thread animscripts\utility::drawDebugLine (self.origin, endPoint, (1, 0, 0), 20);// red line
		}
        anim . lastSideStepAnim = i;
	}
	return foundAGoodShot;
}
