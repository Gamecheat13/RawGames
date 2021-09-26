#include animscripts\Utility;
#include animscripts\Combat_utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

/*
	Corner design:
	AI runs to cover node
	
	AI decides to stand or crouch based on allowed stances or randomness if both are allowed, but prefers stand (more comfortable)
	
	If the AI is supressed then:
		If the AI can throw grenades they try to.
		Reload if less than full ammo.
		If the AI gets hit while suppressed then they try to find new cover.
		If the AI is no longer suppressed then they wait some time then continue

	Reload if less than 75% ammo.

	If the AI wouldnt be able to see the enemy and doesnt have a good suppression point, they look until they see the enemy
		(They should be unable to get a good suppression point until they see the enemy again!!)

	Auto and semi auto AI:
	
	If the enemy is visible from step out position:
		Step out and unload your clip as long as they can see the enemy.
		When the enemy is hidden, fire bursts.
		When the enemy is in view, fire full auto.
		Step back when the clip is empty or you took pain.
	
	If the enemy is not visible from step out position but is suppressable and you have not fired a complete suppression clip:
		Step out and fire suppression bursts. 
		When the enemy is hidden, fire bursts.
		When the enemy is in view, fire full auto.
		If the enemy failed to come into view during the entire duration of the clip,
			then the enemy is considered to be "suppressed"
		Step back when the clip is empty or you took pain.
	
	If the enemy is not visible from step out position but is suppressable and you have already fired a complete suppression clip:
		Step out 
		50% of the time, throw a grenade (if the enemy is the player).
		Wait for the enemy to show themselves. 
		When the enemy is in view, fire full auto.
		When the enemy is hidden, fire bursts.
		Step back when the clip is empty or you took pain.
		The enemy is no longer considered to have had a complete suppression clip fired at him.

	Bolt AI:
	If the enemy is visible from step out position:
		Step out
		Shoot, rechamber, and shoot until the clip is empty.
		If the enemy hides then
			if you at least half your ammo then wait for the enemy to reappear.
			otherwise step back
		Step back when the clip is empty or you took pain.
		
	If the enemy is not visible from step out position but is suppressable:
		Step out
		50% of the time, throw a grenade (if the enemy is the player).
		Wait for the enemy to appear.
		Shoot, rechamber, and shoot until the clip is empty.
		If the enemy hides then
			if you at least half your ammo then wait for the enemy to reappear.
			otherwise step back
		Step back when the clip is empty or you took pain.

*/


main()
{
	if (weaponAnims() == "panzerfaust" || weaponAnims() == "pistol")	
	{
		animscripts\combat::main();
		return;
	}
	
	self endon("killanimscript");
	handleSuppressingEnemy();
	self.coverNode = self.node;

    self trackScriptState( "Cover Stand Main", "code" );
    animscripts\utility::initialize("cover_stand");
    
	// Auto and semi auto use the same logic but separate functions for the actual bullet firing
	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self.autoFire = ::autoFireStand;
		self.autoFireSuppress = ::autoFireStand_suppress;
		self setaimanims(%stand_aim_down, %stand_aim_straight, %stand_aim_up, %stand_shoot_auto_down, %stand_shoot_auto_straight, %stand_shoot_auto_up);
	}
	else
	if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		self.fireanim_setup = ::semiAutoAnim_setup;
		self.fireanim_fire = ::semiAutoAnim_fire;
		self.autoFire = ::SemiAutofireStand;
		self.autoFireSuppress = ::SemiAutofireStand_Suppress;
		self setaimanims(%stand_aim_down, %stand_aim_straight, %stand_aim_up, %stand_shoot_down, %stand_shoot_straight, %stand_shoot_up);
	}
	else
	{
		self setaimanims(%stand_aim_down, %stand_aim_straight, %stand_aim_up, %stand_shoot_down, %stand_shoot_straight, %stand_shoot_up);
	}
	
	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");

	self.fastStand = true;
	self SetPoseMovement("stand","stop");

  	turret = isdefined (self.coverNode.auto_mg42_target);
	// handle starting pose somehow

	firedSuppressionClip = false;
	gotBoredAmbushing = false;
	
	for (;;)
	{
		self animscripts\face::SetIdleFace(anim.alertface);
		if (self.team == "axis")
			gotBoredAmbushing = false;

    	if (turret && tryTurret (self.coverNode.auto_mg42_target))
    		return;

		if (shouldTakeCover(firedSuppressionClip, gotBoredAmbushing))
		{
			// Loop of conditions that could cause us to take cover instead of attacking
			// We have to be free of these conditions before we can attack
			takeCover();
			
			// Bolt action guys don't rechamber while standing when they have no ammo left
			if (self.anim_needsToRechamber)
				rechamber();

			for (;;)
			{
		    	if (turret && tryTurret (self.coverNode.auto_mg42_target))
		    		return;
				
				if (forcedCover("show"))
					break;

				if (!isalive(self.enemy))
					idleWhileYouhaveNoEnemy();
					
				if (isSuppressedWrapper())
					suppressedBehavior();
				else					
					Reload( 0.75 );

				if (forcedCover("hide"))
					idleWhileYouAreForcedToHide();


				if ((!usingBoltActionWeapon() && !firedSuppressionClip) || !gotBoredAmbushing)
				{
					// Guys that have not fired suppression yet or got bored
					// can stand up and suppress, they probably just finished reloading.
					if (canSuppressEnemyFromExposed())
						break;
				}
					
				if (!canSeeEnemyFromExposed())
				{
					idleUntilEnemyWouldBeVisible();
					firedSuppressionClip = false;
					gotBoredAmbushing = false;
					if (!isSuppressedWrapper())
						break;
				}
				else
					break;
			}
			leaveCoverAndAim();
		}
		else
			aimAtEnemyOrSpot();
		
		/*
		if (issuppressedWrapper())
		{
			self setanimknob (%stand_and_crouch, 1, 0.3, 1);
			self notify ("stop_aiming_at_enemy");
			continue;
		}
		*/
		
		visibleEnemy = false;
		suppressableEnemy = false;
		if (isalive(self.enemy))
		{
			visibleEnemy = self canSeeEnemy();
			suppressableEnemy = canSuppressEnemy();
		}
		
		if (!visibleEnemy && !suppressableEnemy)
			aimAtGoodShootPos();

    	if (turret && tryTurret (self.coverNode.auto_mg42_target))
    		return;
		
		if (usingBoltActionWeapon())
		{
			if (visibleEnemy)
				shootEnemy_bolt();
			else
			{
				if (suppressableEnemy)
				{
					// Save the suppression spot in case we lose it while we throw the grenade
					suppressSpot = getEnemySightPos();
					if (randomint(100) > 50)
						tryThrowingGrenade();
					else
						tryReacquire();
	
					gotBoredAmbushing = waitForEnemy_bolt(suppressSpot);
				}
				else
					tryReacquire();
			}
		}
		else
		{
			if (visibleEnemy)
			{
				shootEnemy_auto();
				firedSuppressionClip = false;
				gotBoredAmbushing = false;
			}
			else
			if (suppressableEnemy)
			{
				if (firedSuppressionClip)
				{
					// Save the suppression spot in case we lose it while we throw the grenade
					suppressSpot = getEnemySightPos();

					if (randomint(100) > 50)
						tryThrowingGrenade();
					else
						tryReacquire();

					gotBoredAmbushing = waitForEnemy_auto(suppressSpot);
				}
				else
				{
					tryReacquire();
					firedSuppressionClip = suppressEnemy_auto();
				}
			}
			else
				tryReacquire();
		}

		self setanimknob (%stand_and_crouch, 1, 0.3, 1);
		self notify ("stop_aiming_at_enemy");

		lookForBetterCover();

		animscripts\battleChatter_ai::evaluateSuppressionEvent();
		self animscripts\battleChatter::playBattleChatter();
	}
}

aimAtEnemyOrSpot()
{
	aimed = false;
	if (isalive(self.enemy))
	{
		if (self canSeeEnemyFromExposed())
		{
			thread AimAtEnemy();
			aimed = true;
		}
		else
		if (self canSuppressEnemyFromExposed())
		{
			thread AimAtSpot(getEnemySightPos());
			aimed = true;
		}
	}
	if (!aimed)
		thread AimStraightAhead();
		
	self setanimknob (%shoot, 1, 0.15, 1);
	self setanimknob (%stand_aim, 1, 0.15, 1);
	wait (0.15);
}

shouldTakeCover(firedSuppressionClip, gotBoredAmbushing)
{
	if (self.bulletsInClip / getAIWeapon(self.weapon)["clipsize"] < 0.5)
		return true;

	// guys forced to always be exposed cant take cover except to reload
	if (forcedCover("show"))
		return false;

	if (isSuppressedWrapper())
	{
		createBadPlaceandMove();
		return true;
	}

	visibleEnemy = false;
	suppressableEnemy = false;
	if (isalive(self.enemy))
	{
		visibleEnemy = self canSeeEnemy();
		suppressableEnemy = canSuppressEnemy();
	}
	
	if (!visibleEnemy && !suppressableEnemy)
		return true;
	if ((firedSuppressionClip || usingBoltActionWeapon()) && gotBoredAmbushing)
		return true;
	return false;
}

shouldTakeCover_allies(firedSuppressionClip, gotBoredAmbushing)
{
	if (isSuppressedWrapper())
		return true;
	if (self.bulletsInClip / getAIWeapon(self.weapon)["clipsize"] < 0.5)
		return true;

	visibleEnemy = false;
	suppressableEnemy = false;
	if (isalive(self.enemy))
	{
		visibleEnemy = self canSeeEnemy();
		suppressableEnemy = canSuppressEnemy();
	}
	
	if (!visibleEnemy && !suppressableEnemy)
		return true;
	if ((firedSuppressionClip || usingBoltActionWeapon()) && gotBoredAmbushing)
		return true;
	return false;
}

semiAutoAnim_setup()
{
}

semiAutoAnim_fire()
{
	self setAnimKnob(%shoot, 1, 0.1, 1);
	self setFlaggedAnimKnobRestart("animdone", %stand_shoot, 1, 0, 1);
//	self setFlaggedAnimKnobRestart("animdone", %stand_shoot_straight, 1, 0, 1);
}

AutofireStand()
{
	self.enemy endon ("death");
	self endon ("enemy");

	maps\_gameskill::resetAccuracyAndPause();
	pauseIfPlayerIsInvulAndYouAreAPauseGuy();

	self setanimknob(%shoot, 1, .15, 1);
	self setflaggedanimknob("animdone", %stand_shoot_auto, 1, .15, 1);
	enemy = self.enemy;
	target = enemy getEye();
	// set aim pos again because otherwise the animation can be blended out if we just
	// did autofire end
	self aimAtPos (target); 
	animRate = animscripts\weaponList::autoShootAnimRate();
	
	AutoFire();

	// no recoil if we're gettin back in cover fast
	if (isSuppressedWrapper())
		return;

	self notify ("stop_aiming_at_enemy");	
	if (isalive(enemy))
		target = enemy getEye();
	autofireRecoil(target, 1, 0.1, 1);
	thread aimAtEnemyOrSpot();
}

AutofireStand_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");

	animRate = animscripts\weaponList::autoShootAnimRate();
	self setanimknob(%shoot, 1, .15, 1);
	self setflaggedanimknob("animdone", %stand_shoot_auto, 1, .15, animRate);
	// set aim pos again because otherwise the animation can be blended out if we just
	// did autofire end
	self aimAtPos (suppressSpot);

	enemy = self.enemy;
	target = enemy getEye();
	shootBurst(suppressSpot);
	self notify ("stop_aiming_at_enemy");
	if (isalive(enemy))
		target = enemy getEye();
	autofireRecoil(target, 1, 0.1, 1);
	thread aimAtEnemyOrSpot();

	self setanimknob (%stand_aim, 1, 0.15, 1);
	
	burstDelay();
}

SemiAutofireStand()
{
	self.enemy endon ("death");
	self endon ("enemy");

	animRate = animscripts\weaponList::autoShootAnimRate();
	

	SemiAutoFire();
	
}

SemiAutofireStand_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");

	animRate = animscripts\weaponList::autoShootAnimRate();

	shootSemiAutoBurst(suppressSpot);
		
	burstDelay();
}

tryThrowingGrenade()
{
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	threwGrenade = TryGrenadePos( getEnemySightPos() );
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}

WaitForAmbush(duration )
{
	if (!isalive(self.enemy))
		return;
		
	self.enemy endon ("death");
	self endon ("enemy");
	for (i=0;i<duration*20;i++)
	{
		if (forcedCover("show"))
			i = 0;
		if (!isalive(self.enemy))
			break;
		if (self canSee(self.enemy))
			break;
		if (isSuppressedWrapper())
			break;

		wait 0.05;
	}
}

suppressEnemy_auto()
{
	suppressableTime = gettime() + anim.startSuppressionDelay*1000;

	suppressSpot = getEnemySightPos();
	if (isalive(self.enemy))
		fireSuppressionBursts_UntilEnemyIsVisible(suppressSpot, suppressableTime);

	keptEnemySuppressed = true;
	if (isalive(self.enemy) && self canSee(self.enemy))
	{
		shootAutoIfEnemyIsVisible_OtherwiseDoBursts();
		keptEnemySuppressed = false;	
	}
		
	return keptEnemySuppressed;
}

suppressedBehavior()
{
	createBadPlaceandMove();

	self.suppressed = true;
	if (canSuppressEnemyFromExposed())
	{
		self animMode ( "zonly_physics" ); // Unlatch the feet
		self.keepClaimedNodeInGoal = true;
		TryGrenadePos( getEnemySightPos() + randomVec(10));
		self.keepClaimedNodeInGoal = false;
	}
		
	Reload( 0.9 );
	
	thread loopingHideIdle();
	while (isSuppressedWrapper())
		wait (0.2);
	wait (randomfloat(1));
	self.suppressed = false;
	self notify ("stop_idling");
}

loopingHideIdle()
{
	self endon ("killanimscript");
	self endon ("stop_idling");
	for (;;)
	{
		lookForBetterCover();
		animscripts\cover_crouch_no_wall::idle();
	}
}

idleWhileYouAreForcedToHide()
{
	thread loopingHideIdle();
	while (forcedCover("hide"))
		wait (0.2);
	self notify ("stop_idling");
}

idleWhileYouhaveNoEnemy()
{
	thread loopingHideIdle();
	while (!isalive(self.enemy))
		wait (0.2);
	self notify ("stop_idling");
}


idleUntilEnemyWouldBeVisible()
{
	thread loopingHideIdle();
	while (!canSeeEnemyFromExposed())
	{
		if (!isalive(self.enemy))	
			break;
		wait (0.2);
	}
	self notify ("stop_idling");
}

stand_idleUntilEnemyWouldBeVisible()
{
	self setanimknobrestart (%patrolstand_idle, 1, 0.2, 1);
	while (!canSeeEnemyFromExposed())
	{
		if (!isalive(self.enemy))	
			break;
		wait (0.2);
	}
}

takeCover()
{
	if (isSuppressedWrapper())
		rate = 1.5;
	else
		rate = 1;

	self.anim_Alertness = "casual";
	self OrientMode( "face angle", self.coverNode.angles[1] );
	
	self setflaggedanimknob ("crouchdown", %stand2crouch_hide, 1, 0.15, rate);
	self waittillmatch ("crouchdown", "end");
	self.anim_pose = "crouch";

	self.anim_idleSet = "b";
	self.anim_special = "cover_crouch";
}

notifyOnSuppression()
{
	self endon ("killanimscript");
	self endon ("leftCover");
	for (;;)
	{
		if (issuppressedWrapper())
			break;
		wait (0.05);
		
	}
	self notify ("gotSuppressed");
}


leaveCoverAndAim()
{
	/*
	if (randomint(100) < 40) // 40% chance to ignore suppression outright so we dont oscillate too much
		self.anim_ignoreSuppressionTime = gettime() + 5000;
	if (randomint(100) < 40) // 40% chance to ignore suppression outright so we dont oscillate too much
		self.anim_ignoreSuppressionTime = gettime() + 5000;
	else
		self thread notifyOnSuppression();
		
	self endon ("gotSuppressed");
	*/
	self clearanim (%cover, 0.2);
	self setanimknob (%crouchhide2stand, 1, 0.2, 1);
//	wait (0.4);
//	wait (0.85);
	wait (1.05);
	self.anim_special = "none";
	self.anim_pose = "stand";
	self setanimknob (%shoot, 1, 0.25, 1);
	self setanimknob (%stand_aim, 1, 0.25, 1);
	aimed = false;
	if (isalive(self.enemy))
	{
		if (self canSeeEnemyFromExposed())
		{
			thread AimAtEnemy();
			aimed = true;
		}
		else
		if (self canSuppressEnemyFromExposed())
		{
			thread AimAtSpot(getEnemySightPos());
			aimed = true;
		}
	}
	
	if (!aimed)
		thread AimStraightAhead();
	self notify ("leftCover");
//	wait (0.25);
//	wait (0.3);
	
}

shootEnemy_bolt()
{
	shootEnemyWhileVisible_otherwiseAmbush_bolt();
}

shootEnemyWhileVisible_otherwiseAmbush_bolt()
{
//	self.enemy endon ("death");
	
	thread maps\_gameSkill::resetAccuracyBolt();
	while (isalive (self.enemy) && self.bulletsInClip)
	{
		if (self canSee(self.enemy))
		{
			thread AimAtEnemy();

			// Shoot and rechamber
			shootTime = animscripts\weaponList::shootAnimTime();
			self maps\_gameSkill::shootBolt();
			semiAutoAnim_fire(); // fire one single shot
			self.bulletsInClip --;
			self.anim_needsToRechamber = true;
			if (self.bulletsInClip)
			{
				wait animscripts\weaponList::waitAfterShot();
//				self clearAnim(%stand_shoot, 0.1);
				self clearAnim(%stand_aim, 0.1);
				rechamber();
				self.anim_needsToRechamber = false;

				if (!isalive(self.enemy))
					self aimAtPos ((0,0,0));
				else
					thread aimAtEnemy();
				self setanimknob (%stand_aim, 1, 0.1, 1);
				self clearAnim(%stand_rechamber, 0.3);

				if (self.bulletsInClip)
				{
//					self setanimknob (%stand_and_crouch, 1, 0.3, 1);
	//				self setanimknob (%stand_aim_straight_loop1, 1, 0.3, 1);
					wait (0.4 + randomfloat(0.2));
				}
			}
			else
			{
//				self setanimknob (%stand_and_crouch, 1, 0.3, 1);
				
//				self setanimknob (%stand_aim_straight_loop1, 1, 0.3, 1);
				wait (0.3);
			}			

			if (issuppressedWrapper())
				break;
		}
		else
		{
			thread maps\_gameSkill::resetAccuracyBolt();
			if (canSuppressEnemy() && self.bulletsInClip / getAIWeapon(self.weapon)["clipsize"] >= 0.5)
			{
				suppressSpot = getEnemySightPos();
				if (!tryThrowingGrenade())
					tryReacquire();
				thread AimAtSpot(suppressSpot);
				WaitForAmbush(5);
					
				if (isSuppressedWrapper())
				{
					// We got shot at by another enemy so let's hide and figure things out
					break;
				}
				if (!isalive (self.enemy) || !self canSeeEnemy())
					break;
			}
			else
			{
				tryReacquire();
				// Less than half a clip left, reload
				break;
			}
		}
	}
}

shootEnemy_auto()
{
	shootAutoIfEnemyIsVisible_OtherwiseDoBursts();
}

aimAtEnemy()
{
	self endon ("killanimscript");
	self notify ("stop_aiming_at_enemy");
	self endon ("stop_aiming_at_enemy");
	self.enemy endon ("death");
	self endon ("enemy");
	self OrientMode( "face enemy" );
	self.anim_Alertness = "aiming";
	for (;;)
	{
		self aimAtPos (GetEnemyEyePos());
		wait (0.05);
	}
}

aimAtSpot(spot)
{
	self.anim_Alertness = "aiming";
	self notify ("stop_aiming_at_enemy");
	myYawFromTarget = VectorToAngles(spot - self.origin );
	self OrientMode( "face angle", myYawFromTarget[1] );
	self aimAtPos (spot);
}

aimStraightAhead()
{
	self.anim_Alertness = "aiming";
	forward = anglesToForward(self.angles);
	forward = vector_scale(forward, 100);
	spot = self.origin + forward + (0,0,44);
	self notify ("stop_aiming_at_enemy");
	myYawFromTarget = VectorToAngles(spot - self.origin );
	self OrientMode( "face angle", myYawFromTarget[1] );
	self aimAtPos (spot);
}


waitForEnemy_bolt(suppressSpot)
{
	thread AimAtSpot( suppressSpot );
//	self setanimknob (%stand_aim_straight_loop1, 1, 0.3, 1);
	sawEnemy = false;
	WaitForAmbush(5);
		
	if (isalive(self.enemy) && self canSee(self.enemy))
	{
		sawEnemy = true;
		shootEnemyWhileVisible_otherwiseAmbush_bolt();
	}
	return !sawEnemy;
}

waitForEnemy_auto(suppressSpot)
{
	thread AimAtSpot( suppressSpot );
//	self setanimknob (%stand_aim_straight_loop1, 1, 0.3, 1);
	sawEnemy = false;
	WaitForAmbush(5);
	if (isalive(self.enemy) && self canSee(self.enemy))
	{
		sawEnemy = true;
		shootAutoIfEnemyIsVisible_OtherwiseDoBursts();
	}
	return !sawEnemy;
}

							
shootAutoIfEnemyIsVisible_OtherwiseDoBursts()
{
	suppressableTime = gettime() + anim.startSuppressionDelay*1000;
	while (self.bulletsInClip>0 && isalive(self.enemy))
	{
		if (gettime() > suppressableTime && isSuppressedWrapper())
			break;
			
		if (self canSee(self.enemy))
		{
			// Go full auto if you have a bead on your enemy
			thread AimAtEnemy();
			
			// Firing animation
			[[self.autoFire]]();
		}
		else
		{
			if (canSuppressEnemy())
			{
				if (tryThrowingGrenade())
				{
					if (!isalive(self.enemy))
						break;
				}
				else
					tryReacquire();

				thread AimAtSpot(getEnemySightPos());
				// Otherwise fire suppression bursts until the clip is dry
				fireSuppressionBursts_UntilEnemyIsVisible(getEnemySightPos(), suppressableTime);
			}
			else
			{
				tryReacquire();
				break;
			}
		}
	}
	wait (0.2); // give bullets a chance to finish firing before stepping back
}

fireSuppressionBursts_UntilEnemyIsVisible(suppressSpot, suppressableTime)
{
	thread AimAtSpot( suppressSpot );

	while (self.bulletsInClip>0 && isalive(self.enemy))
	{
		if (gettime() > suppressableTime && isSuppressedWrapper())
			break;
		
		[[self.autoFireSuppress]](suppressSpot);
		if (!isalive (self.enemy) || self canSee(self.enemy))
			break;
	}
}


aimAtGoodShootPos()
{
	if (self.goodShootPosValid)
		aimAtSpot( self.goodShootPos );
	else
		aimStraightAhead();
		
	for (;;)
	{
		if (!isalive(self.enemy))
			break;
		if (self canSeeEnemy())
			break;
		if (canSuppressEnemy())
			break;
		if (issuppressedWrapper())
			break;
		if (forcedCover("hide"))
			break;
		wait (0.2);
	}		

	if (forcedCover("show") && !(isalive(self.enemy)))
	{	
		aimStraightAhead();
		WaitForEnemy();
	}
}

