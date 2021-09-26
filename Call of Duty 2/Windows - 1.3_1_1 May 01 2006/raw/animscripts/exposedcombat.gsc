#include animscripts\SetPoseMovement;
#include animscripts\Utility;
#include maps\_utility;
#include animscripts\Combat_utility;
#using_animtree ("generic_human");

debugPrint(origin, msg, timer)
{
	for (i=0;i<timer*20;i++)
	{
		print3d(origin, msg, (1,1,1), 1, 1.5);
		wait (0.05);
	}
}


GeneralExposedCombat( changeReason )
{
//	if (gettime() > 500)
//		self thread debugPrint(self.origin, "exposed", 5);
	if ( isdefined(self.cliffDeath) && (self.cliffDeath == true) )
		return;
	prof_begin("GeneralExposedCombat");

	self endon("killanimscript");
	sidestep = false;
	if (shouldTryInitialSideStep())
		sidestep = trySideStep(::TargetEnemyPos);
	
    self notify ("anim entered exposed");
	assertEX( isDefined ( changeReason ) , "Script state called without reason.");

    self trackScriptState( "General Exposed Combat", changeReason );
    
    // force him to get into "exposed guy pose" so his canshoots are relevant
    if (!sidestep)
    {
    	// make prone guys stand up so they dont pop to crouch when they do aimpose
    	if (self.anim_pose == "prone")
			self SetPoseMovement("crouch","stop");
		else
			self SetPoseMovement("","stop");
		
	//	self animscripts\aim::aim(0.1);
		self animscripts\aim::aimPose();
	}
	
//	if (self animscripts\utility::weaponAnims() == "mg42")
	if (self.weapon == "portable_mg42")
	{
//		animscripts\shared::DropAIWeapon();
		throwVel = 75 + randomInt(50);
		self DropWeapon(self.weapon, self.anim_gunHand, throwVel);
		self.weapon = self.secondaryweapon;
		self.secondaryweapon = "mg42";
		self animscripts\shared::PutGunInHand("right");
		self animscripts\weaponList::RefillClip();
		self.anim_needsToRechamber = 0;
	}

	panzerGuyShootsTarget();

	if (usingBoltActionWeapon())
		thread maps\_gameSkill::resetAccuracyBolt(); // So the first shot doesnt hit

	hasSuppressedEnemy = !animscripts\weaponList::usingAutomaticWeapon();
	hasAmbushed = false;
	forceCrouch = false;
//	while (self.anim_desired_script == "combat")
	for (;;)
	{
		prof_begin("GeneralExposedCombat");
		startTime = gettime();
	
		self OrientMode("face enemy");
		// Nothing below will work if our gun is completely empty.
		if (self.anim_pose == "stand")
	        self SetPoseMovement("stand","stop");
		else
        	self SetPoseMovement("crouch","stop");
        Reload(0);


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
		
		preferredStance = "stand";
		if (isCrouching)
			preferredStance = "crouch";
		
		if (dist>anim.standRangeSq)
			preferredStance = "crouch";
			
		
//		thread aimdebug();

		
		// If the enemy is close and we can stand, then don't allow crouching.  Similarly if the enemy is far 
		// and we can crouch, then don't allow standing.
		// When checking CanShootFromPose, do a sight check only if we're not in that pose currently.  This 
		// is to prevent guys from, say, crouching and then changing AI states because they lost sight of 
		// their enemy.
		canShootStand = false;
		canShootCrouch = false;
		canStand = false;
		canCrouch = false;

		for (;;)
		{		
			if (preferredStance == "stand")
			{
				canStand				= self isStanceAllowed("stand");
				if (canStand)
					canShootStand		= self animscripts\utility::CanShootEnemyFromPose( "stand" );
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
						canShootCrouch	= self animscripts\utility::CanShootEnemyFromPose( "crouch" );
					else
						canShootCrouch	= false;
				}
			}
			else
			{
				canCrouch				= self isStanceAllowed("crouch");
				if (canCrouch)
					canShootCrouch	 	= self animscripts\utility::CanShootEnemyFromPose( "crouch" );
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
						canShootStand	= self animscripts\utility::CanShootEnemyFromPose( "stand" );
					else
						canShootStand	= false;
				}
			}

	        if (!canShootStand )
	        {
				if (!trySideStep(::TargetEnemyPos))
					break;
			}
			else
				break;
		}

        
        if ( canShootStand )
        {
			hasSuppressedEnemy = !animscripts\weaponList::usingAutomaticWeapon();
            // Since the enemy is likely quite close while we're in standing combat, we need to check his distance 
            // often, so we can engage in melee combat quickly.
            self SetPoseMovement("stand","stop");
			self.fastStand = undefined;

			self.anim_alertness = "aiming";
//            self animscripts\aim::aim(getAimDelay());
            self animscripts\aim::aimPose();
            
			// The closer you are, the more likely you'll try to dodge.
			sideStepChance = (anim.dodgeRangeSq - dist) / (anim.dodgeRangeSq - anim.meleeRangeSq);

            if ( self.team != "allies" && randomFloat(1) < sideStepChance)
                trySideStep(::TargetEnemyPos);
            ShootVolley();
           	self setanim(%shoot,0.0,0.2,1); // cleanup and turn down shoot knob
        }
        else if ( canShootCrouch )
        {
			hasSuppressedEnemy = !animscripts\weaponList::usingAutomaticWeapon();
			if ((isdefined (self.fastStand)) && (canStand) && (canShootStand))
				continue;
            self SetPoseMovement("crouch","stop");
			self.fastCrouch = undefined;
			
            self animscripts\aim::aim(0.2);
            ShootVolley();
           	self setanim(%shoot,0.0,0.2,1); // cleanup and turn down shoot knob
        }
        else
        {
        	tryReacquire();
        	
        	suppressableEnemy = canSuppressEnemy();
			if (suppressableEnemy)
			{
				threwGrenade = false;
	        	// Dont throw grenade if we're too close, but you can throw if you're on a different level
		        self.enemyDistanceSq = self MyGetEnemySqDist();
		        tooClose = (self.enemyDistanceSq < 90000); // 300 * 300
		        if (tooClose)
		        {
		        	pos = getEnemySightPos();
		        	if (maps\_utility::abs((self.origin[2] + 72) - pos[2]) > 75)
		        		tooClose = false;
			    }
	
				if (!tooClose)
		        {
					self animMode ( "gravity" ); // Unlatch the feet
					threwGrenade = TryGrenadePos(getEnemySightPos() + randomVec(10));
					if (threwGrenade)
						ambush();
//					self animMode ( "normal" ); // Unlatch the feet
				}

				if (!threwGrenade)
				{				
					// weapon could've changed to a pistol so we have to check automatic again
					if (!hasSuppressedEnemy && animscripts\weaponList::usingAutomaticWeapon()) 
					{
						while (!targetSuppressPos())
						{
							if (!trySideStep(::TargetSuppressPos))
								break;
			            }
	
						if (targetSuppressPos())
						{
							hasSuppressedEnemy = true;
				            suppressSpot = getEnemySightPos();
				            myYawFromTarget = VectorToAngles(suppressSpot - self.origin );
							self OrientMode( "face angle", myYawFromTarget[1] );
				            self animscripts\aim::aimPose();
						
							if (self.anim_pose == "stand")
							{
								while (self.bulletsInClip>0 && isalive(self.enemy))
								{
									AutofireStand_Suppress(suppressSpot);
									if (self canSeeEnemy())
										break;
								}
							}
							else
							{
								while (self.bulletsInClip>0 && isalive(self.enemy))
								{
									AutofireStand_Suppress(suppressSpot);
									if (self canSeeEnemy())
										break;
								}
							}
						}
					}
					else
					if (!hasAmbushed)
					{
						ambush();
						hasAmbushed = true;
						self OrientMode("face enemy");
					}
					else
						lookForBetterCover();
				}
			}
			else
				lookForBetterCover();
			
			/*
            // Can't shoot from standing or crouching.  Try stepping to the side, and then try going prone.
			foundAGoodShot = trySideStep(false, false, ::targetEnemyPos);
            if (!foundAGoodShot)
            {
//		            self animscripts\aim::aim(0.1);
				util_evaluateKnownEnemyLocation();
				if (hasEnemySightPos())
				{
					sightPos = getEnemySightPos();
					if (animscripts\weaponList::usingAutomaticWeapon() && hasEnemySightPos())
					{
		            	self animscripts\aim::aimPose();
						myYawFromTarget = VectorToAngles(sightPos - self.origin );
						self OrientMode( "face angle", myYawFromTarget[1] );
						
						ShootSuppressionVolley(0);
					}
				}
				
				// Can't hit the enemy from stand, crouch or prone.  Aim for a short time.
                self SetPoseMovement("","stop");
                assertEX (self.anim_movement == "stop", "combat::RangedCombat: About to call aim, movement is "+self.anim_movement);
				interruptPoint();	// We couldn't shoot for some reason, so now would be a good time to run for cover.
            }
            */
	    }
        
        self.enemyDistanceSq = self MyGetEnemySqDist();

//        if ( (self.enemyDistanceSq > anim.proneRangeSq) )
        if (animscripts\prone::CanDoProneCombat(self.origin, self.angles[1]))
        {
            self thread animscripts\prone::ProneRangeCombat("enemydist > pronerange");

            prof_end("GeneralExposedCombat");
            return;
        }
		canMelee = animscripts\melee::TryMeleeCharge();
		if (canMelee)
		{
			self thread animscripts\melee::MeleeCombat("TryMeleeCharge passed");

			prof_end("GeneralExposedCombat");
            return;
		}
		if (startTime == gettime())
		{
        	tryForcedReacquire();
			aiming = false;

			if (isalive(self.enemy))
			{
				if (self cansee(self.enemy))
		           	self animscripts\aim::aim(0.1);
				else
				{
		        	forward = anglestoforward((0,self.angles[1],0));
		        	normal = vectornormalize(self.enemy.origin - self.origin);
		        	dot = vectordot(forward, normal);
			        
		        	if (dot > 0.8)
		        	{
			           	self animscripts\aim::aim(0.1); // AI is on nearly the same level
			           	aiming = true;
			        }
			    }
	        }
		
			if (!aiming) // gotta idle if we're not aiming
			{	
	           	// ai is above/below
				if (self.anim_idleSet != "a" && self.anim_idleSet != "b" )
				{
					if (randomint(100) > 50)
						self.anim_idleSet = "a";
					else
						self.anim_idleSet = "b";
				}
				// No time passed
				if (self.anim_movement == "stop")
					stopAimingButBreakIfISeeMyEnemy();
	
				// time still hasnt moved
				if (startTime == gettime())
					idleOnceButBreakIfISeeMyEnemy();
			}
		}
//		interruptPoint();
		self animscripts\battleChatter::playBattleChatter();
//		wait (0.05);
    }    

}

AutofireStand_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");

	animscripts\aim::aimAtTarget(suppressSpot);

	animRate = animscripts\weaponList::autoShootAnimRate();
//	self setanimknob(%shoot, 1, .15, 1);
//	self setflaggedanimknob("animdone", %stand_shoot_auto, 1, .15, animRate);
	if (self.anim_pose == "stand")
	{
		anim_autofire = %stand_shoot_auto;
		anim_semiautofire = %stand_shoot;
		anim_boltfire = %stand_shoot;
	}
	else // assume crouch
	{
		anim_autofire = %crouch_shoot_auto;
		anim_semiautofire = %crouch_shoot;
		anim_boltfire = %crouch_shoot;
	}
	self setFlaggedAnimKnobRestart("animdone", anim_autofire, 1, .1, animRate);

	enemy = self.enemy;
	target = enemy getEye();
	shootBurst(suppressSpot);
	self notify ("stop_aiming_at_enemy");
	if (isalive(enemy))
		target = enemy getEye();
	autofireRecoil(target, 1, 0.1, 1);
//	thread aimAtEnemyOrSpot();

//	self setanimknob (%stand_aim, 1, 0.15, 1);
	animscripts\aim::aimAtTarget(suppressSpot);
	
	burstDelay();
}

AutofireCrouch_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");

	animRate = animscripts\weaponList::autoShootAnimRate();
	self setanimknob(%shoot, 1, .15, 1);
	self setflaggedanimknob("animdone", %crouch_shoot_auto, 1, .15, animRate);

	enemy = self.enemy;
	target = enemy getEye();
	shootBurst(suppressSpot);
	self notify ("stop_aiming_at_enemy");
	if (isalive(enemy))
		target = enemy getEye();
	autofireRecoil(target, 1, 0.1, 1);
//	thread aimAtEnemyOrSpot();

	self setanimknob (%crouch_aim, 1, 0.15, 1);
	
	burstDelay();
}


aimdebug()
{
	level notify ("huh");
	level endon ("huh");
	for (;;)
	{
		end = (self.origin[0], self.origin[1], 0);
		start = (level.player.origin[0], level.player.origin[1], 0);
		angles = level.player getplayerangles();
		angles = (0, angles[1], 0);
		difference = vectornormalize(end - start);
		forward = anglestoforward (angles);
		dot = vectordot(forward, difference);
		println ("dot: ", dot);
		wait (0.05);
	}
}

targetEnemyPos(localDeltaVector)
{
	return (CanShootEnemyFromPose("stand", localDeltaVector ));
}

targetSuppressPos(localDeltaVector)
{
	start = self GetTagOrigin ("tag_flash");
	
	return (sightTracePassed(start, getEnemySightPos(), true, self));
}

trySideStep(checkTargetFunc)
{
	if ( self.team == "allies" )
		return 0;
	if ((isdefined (self.anim_nextSideStepTime)) && (gettime() < self.anim_nextSideStepTime))
		return 0;

	foundAGoodShot = 0;
	if ( (self.anim_pose == "stand") && (self isStanceAllowed("stand")) )
	{
		sideStepAnim = [];
		sideStepAnim[sideStepAnim.size] = %stand_shoot_jump_left;
		sideStepAnim[sideStepAnim.size] = %stand_shoot_jump_right;
		sideStepAnim[sideStepAnim.size] = %stand_shoot_walk_left;
		sideStepAnim[sideStepAnim.size] = %stand_shoot_walk_right;
		sideStepAnim[sideStepAnim.size] = %stand_shoot_jump_left_alt;
		sideStepAnim[sideStepAnim.size] = %stand_shoot_jump_right_alt;
		sideStepAnim[sideStepAnim.size] = %stand_shoot_run_left;
		sideStepAnim[sideStepAnim.size] = %stand_shoot_run_right;

        startingAnim = anim.lastSideStepAnim;
       	startingAnim = randomint (sideStepAnim.size);

		for (i=0 ; i<sideStepAnim.size && !foundAGoodShot ; i++)
		{
			thisAnim = i + startingAnim;
			while (thisAnim >= sideStepAnim.size)
				thisAnim -= sideStepAnim.size;

			localDeltaVector = GetMoveDelta (sideStepAnim[thisAnim], 0, 1);
			endPoint = self LocalToWorldCoords( localDeltaVector );

			if ( self maymovetopoint(endPoint) && [[checkTargetFunc]](localDeltaVector))
			{
				/#thread animscripts\utility::drawDebugLine (self.origin, endPoint, (0, 1, 0), 20);#/ // green line
				self.anim_alertness = "aiming";
				self.anim_pose = "stand";
				self.anim_movement = "stop";

				// Animate
				//   setflaggedanimknoballrestart(notifyName, anim, rootAnim, goalWeight, goalTime, rate) 				
				self setflaggedanimknobAllRestart("sideStepAnim", sideStepAnim[thisAnim], %body, 1, .2, 1.0);
								
				wait (0.5);
//				self animscripts\shared::DoNoteTracks("sideStepAnim");
				foundAGoodShot = 1;
				self.anim_nextSideStepTime = gettime() + 1500;
                break;
			}
			else
			{
//				/#thread animscripts\utility::drawDebugLine (self.origin, endPoint, (1, 0, 0), 20);#/ // red line
/#
				if (getdebugcvar ("anim_debug") == "2")
					self thread showDebugLine(self.origin, endPoint, (.5,1,.5), 5);
#/
			}
		}
		
        anim.lastSideStepAnim = i;
	}
	return foundAGoodShot;
}


ambush()
{
	if (!isalive (self.enemy))
		return;

	// dont ambush ai, looks buggy if you see it from allies perspective		
	if (self.enemy != level.player)
		return;
	self endon ("sawEnemy");
	thread enemySightCheck();
    suppressSpot = getEnemySightPos();
    myYawFromTarget = VectorToAngles(suppressSpot - self.origin );
	self OrientMode( "face angle", myYawFromTarget[1] );
    self animscripts\aim::aim(5);
}
 
enemySightCheck()
{
	self endon ("killanimscript");
	self endon ("enemy");
	self.enemy endon ("death");
	for (;;)
	{
		if (self canSee(self.enemy))
			break;
		wait (0.1);
	}
	self notify ("sawEnemy");
}


exception_exposed_panzer_guy()
{
	assertex(0, "Don't set panzer exceptions anymore");
	self endon("killanimscript");
	
	self.goalradius = 4;
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 10;
	self setgoalnode (self.panzer_node);
	self animscripts\run::MoveStandNoncombatNormal();
	self waittill ("goal");
	if ( (isdefined (self.panzer_ent)) && (isdefined (self.panzer_ent_offset)) )
		self.panzer_pos = (self.panzer_ent.origin + self.panzer_ent_offset);
	if (isdefined (self.panzer_pos))
	{
		myYawFromTarget = VectorToAngles(self.panzer_pos - self.origin );
		self OrientMode( "face angle", myYawFromTarget[1] );
		self SetPoseMovement("crouch","stop");
		self animscripts\aim::aimPose();
	
		self setanimknob(%crouch_shoot, 1, .15, 0);
	//	self setanimknob(%shoot, 1, .15, 1);
		wait 0.5;
	//	self setFlaggedAnimKnobRestart("shootdone", %stand_shoot, 1, 0, 1);
		self shoot(1.0, self.panzer_pos);
		self.anim_exposed_panser_guy_complete = true;
	}
	self.anim_needsToRechamber = 1;
	self.bulletsInClip --;
	self.pathenemylookahead = 64;
	self.pathenemyfightdist = 64;
	self.goalradius = 350;
	self.exception_exposed = animscripts\init::empty;
	self.exception_stop = animscripts\init::empty;
	self notify ("panzer mission complete");
	thread clearPanzerAnims();
	wait (0.5);
}

clearPanzerAnims()
{
	self endon ("death");
	wait (0.5);
	self clearanim(%panzerfaust_crouchaim_straight, 0);
	self clearanim(%panzerfaust_crouchaim_up, 0);
	self clearanim(%panzerfaust_crouchaim_down, 0);
	self clearanim(%panzerfaust_crouchshoot_straight, 0);
	self clearanim(%panzerfaust_crouchshoot_up, 0);
	self clearanim(%panzerfaust_crouchshoot_down, 0);
				
//	self clearanim(%crouch_shoot, 0);
//	self clearanim(%crouch_aim, 0);
}


dropGunIfEnemyGetsClose()
{
	self endon ("killanimscript");
	self endon ("reached_gun_setup");
	
	for (;;)
	{
		if (!isalive(self.enemy))
		{
			wait (1);
			continue;
		}
		
		if (distance (self.enemy.origin, self.origin) < 60)
			break;
		wait (0.2);
	}
	
//	assert (self.weapon == "portable_mg42");

	maps\_spawner::dropTurret();
//	level.theturret = turret;
//	throwVel = 75 + randomInt(50);

	self animscripts\shared::PutGunInHand("right");
	self animscripts\weaponList::RefillClip();
	self.anim_needsToRechamber = 0;
	self notify ("dropped_gun");
	maps\_spawner::restoreDefaults();
}

exception_exposed_mg42_portable()
{
	self endon("killanimscript");
	self endon ("dropped_gun");
	
	thread dropGunIfEnemyGetsClose();
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 10;
	while (isdefined (self.mg42node))
	{
		self setgoalnode(self.mg42node);
		self.goalradius = self.mg42node.radius;
		self waittill ("goal");
		self.mg42node = getnode (self.mg42node.target,"targetname");
	}
	
	self.goalradius = 4;
	org = getStartOrigin (self.mg42.Oldorigin, self.mg42.angles, self.mg42setupanim);
	self setgoalpos (org);	
//	self setgoalnode (self.mg42setup_node);
	for (;;)
		self animscripts\run::MoveStandNoncombatOverride();
//	self waittill ("goal");
//	self notify ("mg42_portable_at_node");
}

exception_exposed_mg42_portable_pickup()
{
	self endon("killanimscript");

	self.goalradius = 4;
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 10;
	self setgoalpos (self.mg42pickup_pos);
	self animscripts\run::MoveStandNoncombatOverride();
	self waittill ("goal");
	self notify ("mg42 portable at pickup");
}

shouldTryInitialSideStep()
{
	// used to let enemies decide if they're going to side step or not initially
	if (!isalive (self.enemy))
		return false;
	if (self.enemy != level.player)
		return false;
	
	right = anglestoright((0,self.angles[1],0));
	base = 4;
	left = vector_scale(right, base * -1);
	right = vector_scale(right, base);
	eye = self geteye();
	enemyEye = self.enemy geteye();
	
	/#
	thread debug_trace(eye + left, enemyEye);
	thread debug_trace(eye + right, enemyEye);
	#/
	
	if (!sightTracePassed(eye + left, enemyEye, false, undefined))
		return true;
	if (!sightTracePassed(eye + right, enemyEye, false, undefined))
		return true;
	return false;	
}

debug_trace(start, end)
{
	/#
	if (getdebugcvarint("anim_trace") != self getentnum())
		return;
	println ("start ", start, " and end ", end);
	for (i=0;i<5*20;i++)
	{
		if (sightTracePassed(start, end, false, undefined))
			line (start, end, (0,1,0));
		else
			line (start, end, (1,0,0));
		wait (0.05);
	}
	#/
}


stopAimingButBreakIfISeeMyEnemy()
{
	self endon ("sawEnemy");
	thread lookForEnemy();
	animscripts\aim::dontAim();
	self notify ("sawEnemy");
}

lookForEnemy()
{
	self endon ("killanimscript");
	self endon ("sawEnemy");
	for (;;)
	{
		if (isalive(self.enemy) && self canSee (self.enemy))
			break;
		wait (0.05);
	}
	self notify ("sawEnemy");
}

idleOnceButBreakIfISeeMyEnemy()
{
	self endon ("sawEnemy");
	thread lookForEnemy();
	if (self.anim_pose == "stand")
		animscripts\stop::StandStillThink(false);
	else
		animscripts\stop::CrouchStillThink(false);
	self notify ("sawEnemy");
}


ShootVolley( numberOfShots )
{
	self endon ("killanimscript");
	wait (0);
	if ( self.anim_pose == "stand" && self MyGetEnemySqDist()<=anim.meleeRangeSq )
		return;

	if (self.bulletsInClip <= 0)
		return;

	if (self animscripts\utility::weaponAnims() == "none")
		return;

	// Don't use a sight check once we're actually in combat.
	if ( !self animscripts\utility::canShootEnemy(undefined, false) )	
		return;

	self animscripts\shared::PutGunInHand("right");
	if (self.anim_pose == "stand")
	{
		anim_autofire = %stand_shoot_auto;
		anim_semiautofire = %stand_shoot;
		anim_boltfire = %stand_shoot;
	}
	else // assume crouch
	{
		anim_autofire = %crouch_shoot_auto;
		anim_semiautofire = %crouch_shoot;
		anim_boltfire = %crouch_shoot;
	}

	self thread EyesAtEnemy();

	assertEX(self.anim_alertness == "aiming", "ShootVolley called when not aiming");

	// Set up the loop variables.
	self.enemyDistanceSq = self MyGetEnemySqDist();
	fired = true;

	maxYaw = 20;
	if (weaponAnims() == "panzerfaust")
		aimAtPanzerTarget();
	else
	{
		// panzerfaust guys dont care if they're not aiming at their enemy
		// because they're not necessarily shooting at their enemy
		if (AbsYawToEnemy2d() > maxYaw)
			return;
	}


	if (animscripts\weaponList::usingAutomaticWeapon())
	{
//		self.anim_suppressingEnemy = true;
		
	 	// Make sure the aim and shoot animations are ready to play
		self setanimknob(%shoot, 1, .15, 1);

		self animscripts\face::SetIdleFace(anim.autofireface);
		self animscripts\battleChatter_ai::evaluateFiringEvent();

		// Slowly blend in shoot instead of playing the transition.
//		self setflaggedanimknob("animdone", anim_autofire, 1, .15, 0);
//		wait 0.20;

		maps\_gameskill::resetAccuracyAndPause(::trySideStep, ::TargetEnemyPos);
		pauseIfPlayerIsInvulAndYouAreAPauseGuy();
			
		if (isalive(self.enemy))
		{
			enemy = self.enemy;
			target = self.enemy getEye();
			animRate = animscripts\weaponList::autoShootAnimRate();
			self setFlaggedAnimKnobRestart("animdone", anim_autofire, 1, .1, animRate);
			if (isdefined (numberOfShots))
				numShots = numberOfShots;
			else
				numShots = randomint(5) + 4;
				
//			self.bulletsinclip = 1;
			if (self.bulletsInClip < numShots)
				numShots = self.bulletsInClip;
			estimatedTime =  0.5 + (0.1 * numShots / animRate);
//			self thread KillRunawayAutofire("cornerattack autofire done", estimatedTime);
			DoAutoFire(numShots,  maxYaw);
			timer = gettime();
			if (isalive(enemy))
				target = enemy getEye();
			autofireRecoil(target, 1, 0.1, 1);
			if (timer == gettime())
				fired = false;
//			wait animscripts\weaponList::waitAfterShot();
			self notify ("stopautofireFace");
		}
	}
	else if (animscripts\weaponList::usingSemiAutoWeapon())
	{
	 	// Make sure the aim and shoot animations are ready to play
		self setanimknob(%shoot, 1, .15, 1);
		

		self animscripts\face::SetIdleFace(anim.aimface);

		// TEMP(?) Slowly blend in shoot instead of playing the transition.
		self setanimknob(anim_semiautofire, 1, .15, 0);
		maps\_gameskill::resetAccuracyAndPause(::trySideStep, ::TargetEnemyPos);
		pauseIfPlayerIsInvulAndYouAreAPauseGuy();

		doSemiAutoFire(anim_semiautofire);
	}
	else // Bolt action
	{
		self endon ("killanimscript");
//		Rechamber();	// In theory you will almost never need to rechamber here, because you will have done 
						// it somewhere smarter, like in cover.
		// Whenever time passes I need to check this...						
		if (self.anim_pose == "stand" && MyGetEnemySqDist()<=anim.meleeRangeSq)
		{
			self notify ("stop EyesAtEnemy");
			return;
		}

		self animscripts\face::SetIdleFace(anim.aimface);
		self animscripts\battleChatter_ai::evaluateFiringEvent();

		if (isalive(self.enemy))
		{
			targetEnemy = self.enemy;
			targetOrg = self.enemy getEye();
			if (weaponAnims() == "panzerfaust")
			{
				if (sightTracePassed(self gettagOrigin ("tag_flash"), targetOrg, true, targetEnemy))
				{
					self setanimknob(anim_boltfire, 1, .15, 0);
					wait 0.5;
					self setFlaggedAnimKnobRestart("animdone", anim_boltfire, 1, 0, 1);
					self shoot (1, targetOrg);
					self notify ("shot_at_target");
					wait 1;
					dropPanz();
				}
			}
			else
			{
				if (NeedsToRechamber())
				{
					Rechamber();
					// aim at target for 0.2 so we dont blend in shoot
					animscripts\aim::POSE_keepAimingAtTarget(targetOrg, 0.1, 0.1);
					wait (0.2);
				}
				// aim at target for 0.2 so we dont blend in shoot
				animscripts\aim::POSE_keepAimingAtTarget(targetOrg, 0.1, 0.1);
				wait (0.1);
				self setFlaggedAnimKnobRestart("animdone", anim_boltfire, 1, 0.0, 1);
				maps\_gameSkill::shootBolt();
				wait (0.4);

				waitTime = maps\_gameSkill::waitTimeIfPlayerIsHit();
				if (waitTime > 0)
					animscripts\aim::aim(waitTime);
				self.anim_needsToRechamber = 1;
				self.bulletsInClip --;
				Rechamber();	// In theory you will almost never need to rechamber here, because you will have done 
			}
		}
		/*
        if ( isDefined ( posOverrideEntity ) )
            self shootWrapper ( undefined , posOverrideEntity . origin );
        else
            self shootWrapper();
		*/

/*		
		shootTime = animscripts\weaponList::shootAnimTime();
		quickTime = animscripts\weaponList::waitAfterShot();
		wait quickTime;
*/

//		if ( (completeLastShot) && (self MyGetEnemySqDist()>anim.meleeRangeSq) )
//			Rechamber();
	}

	self notify ("stop EyesAtEnemy");
}

doSemiAutoFire(anim_semiautofire)
{
	if (!isalive(self.enemy))
		return;
	self.enemy endon ("death");
	self endon ("enemy");
	
	numShots = randomint(2) + 2;
	adjustedNumshots = false;
	for (i = 0; i<numShots; i ++)
	{
		self shootWrapper();
		self setFlaggedAnimKnobRestart("animdone", anim_semiautofire, 1, 0, 1);
		
		self.bulletsInClip --;
		// Play Garand Ping!
		if ((self.weapon == "m1garand") && (!self.bulletsInClip))
			self playsound ("weap_m1garand_lastshot");
		
		shootTime = animscripts\weaponList::shootAnimTime();
		quickTime = animscripts\weaponList::waitAfterShot();
		wait quickTime;
		if ( ( i<numShots-1 ) && (self.anim_pose == "crouch" || self MyGetEnemySqDist()>anim.meleeRangeSq) && shootTime>quickTime)
			wait shootTime - quickTime;
		self.enemyDistanceSq = self MyGetEnemySqDist();
		if (self.anim_pose == "stand" && self.enemyDistanceSq < anim.meleeRangeSq)
			break;
		if (self.bulletsInClip <= 0)
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
}


ShootIt()
{
	timer = gettime();
	aimAtPanzerTarget();
	// wait at least a second before shooting
	if (gettime() < timer + 1000)
		wait (((timer + 1000) - gettime()) * 0.001);
		
	if (isdefined(self.panzer_pos))
	{
		if (sightTracePassed(self gettagOrigin ("tag_flash"), self.panzer_pos, false, undefined))
		{
			self shoot (1, self.panzer_pos);
			self notify ("shot_at_target");
			self dropPanz();
		}
		else
		{
			/#
			if (getdebugcvar("debug_panzer_miss") == "on")
			{
				for (i=0;i<10*20;i++)
				{
					line(self gettagOrigin ("tag_flash"), self.panzer_pos, (1,0,0));
					wait (0.05);
				}
			}
			else
				setcvar("debug_panzer_miss", "off");
			#/
		}
	}
	else
	{
		targetEnemy = undefined;
		targetOrg = undefined;
		if (isdefined(self.panzer_ent) && isdefined(self.panzer_ent.origin))
		{
			targetEnemy = self.panzer_ent;
			targetOrg = self.panzer_ent.origin + self.panzer_ent_offset;
			if (sightTracePassed(self gettagOrigin ("tag_flash"), targetOrg, true, targetEnemy))
			{
				self shoot (1, targetOrg);
				self notify ("shot_at_target");
				self dropPanz();
			}
		}
	}
}


panzerGuyShootsTarget()
{
	while (weaponAnims() == "panzerfaust" && isdefined(self.panzer_pos) || isdefined(self.panzer_ent))
	{	
		pose = self.anim_pose;
		if (pose != "stand" && pose != "crouch")
			pose = "crouch";
		self SetPoseMovement(pose,"stop");
		self animscripts\aim::aimPose();
		ShootIt();
		self animscripts\aim::aim(1);
		// wait (1); aim instead of waiting so we dont go basepose
	}
}