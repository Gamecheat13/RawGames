#include animscripts\Utility;
#include maps\_Utility;
#include animscripts\Combat_utility;
#using_animtree ("generic_human");


/*
	Corner design:
	AI runs to cover node
	
	AI decides to stand or crouch based on allowed stances or randomness if both are allowed, but prefers stand (more comfortable)
	
	If the AI is supressed then:
		If the AI can throw grenades they try to.
		AI crouches at the wall if standing
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

cornerDebug()
{
	level notify ("newdebuger");
	level endon ("newdebuger");
	org = self.node.origin;
	ang = self.node.angles;
	forward = anglestoforward (ang);
	scale = 4;
	forwardFar = maps\_utility::vectorScale(forward, 5*scale);
	forwardClose = maps\_utility::vectorScale(forward, 2*scale);
	right = anglestoright (ang);
	left = maps\_utility::vectorScale(right, -2*scale);
	right = maps\_utility::vectorScale(right, 2*scale);
	color = (1, 0.5, 0.3);
	for (;;)
	{
		line (org, org + forwardFar, color, 0.9);
		line (org + forwardFar, org + forwardClose + right, color, 0.9);
		line (org + forwardFar, org + forwardClose + left, color, 0.9);
		wait (0.05);
	}
}
	


coverThink(animArrayFuncs, coverRight)
{
	
	
	self endon("killanimscript");
	self.coverNode = self.node;
	self.anim_cornerMode = "straight";
	self.anim_3flag = "";

	[[self.exception_corner_normal]]();
	if (self animscripts\utility::weaponAnims()=="panzerfaust")
	{
		animscripts\combat::main();
		return;
	}

	// Auto and semi auto use the same logic but separate functions for the actual bullet firing
	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self.weaponAnimRate = animscripts\weaponList::autoShootAnimRate();
		self.autoFire = ::AutofireCorner;
		self.autoFireSuppress = ::AutofireCorner_Suppress;
	}
	else
	if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		self.weaponAnimRate = animscripts\weaponList::autoShootAnimRate();
		self.autoFire = ::SemiAutofireCorner;
		self.autoFireSuppress = ::SemiAutofireCorner_Suppress;
		self.fireanim_setup = ::semiAutoAnim_setup;
		self.fireanim_fire = ::semiAutoAnim_fire;
	}

	assert(self isStanceAllowed("crouch") || self isStanceAllowed("stand") );

	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");
	}

	animscripts\combat_say::specific_combat("flankleft");

//	self endon (anim.scriptChange);

	// Make sure we're facing the opposite direction from the node.
		
	cornerAngle = animscripts\utility::GetNodeDirection();
	nodeOrigin = animscripts\utility::GetNodeOrigin();

	canStand        = self isStanceAllowed("stand");
	canCrouch       = self isStanceAllowed("crouch");

//	keepPose = (self.anim_forced_cover == "show" || randomint(100) > 50);
	hideNode = (isdefined (self.coverNode) && isdefined(self.coverNode.targetname) && self.coverNode.targetname == "cover_hide");

	if (canStand)
		[[animArrayFuncs["stand"]]]();	
	else
		[[animArrayFuncs["crouch"]]]();	
	
	GoToCover();
//	wait (2); // why?
//	thread nodeOutOfRange();
//	println ("Guy " + self getentnum() + " reached corner!");

//	thread cornerdebug();
	/*
	self clearanim(%body, 0);
	self OrientMode( "face angle", self.node.angles[1]+self.animArray["hideYawOffset"]);
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	for (;;)
	{

		self setflaggedanimknobrestart("flag", %corner_right_stand_alert2aimstraight, 1, 0, 1);
		self waittillmatch ("flag", "end");
		self setflaggedanimknobrestart("flag", %corner_right_stand_aimstraight2alert, 1, 0, 1);
		self waittillmatch ("flag", "end");
	}
	*/
//	println ("Guy " + self getentnum() + " started corner!");
//	thread debugPoint ();
//	thread debugorigin();
	
	

	firedSuppressionClip = usingBoltActionWeapon(); // bolt action weapons cant do suppression fire by themselves
	gotBoredAmbushing = false;

	for (;;)
	{
		// To remove any accumulated delta error
		if (distance(self.origin, self.coverNode.origin) < 32)
			self teleport (self.coverNode.origin, (0,self.coverNode.angles[1]+self.animArray["hideYawOffset"],0));
		self animscripts\face::SetIdleFace(anim.alertface);

		canStand        = self isStanceAllowed("stand");
		canCrouch       = self isStanceAllowed("crouch");
		preferStand = canStand;

		if (self.anim_pose != "stand" && canCrouch)
			preferStand = false;
		
		if (canStand && canCrouch && randomint(100) > 85)
			preferStand = !preferstand;
			
		if (preferStand)
			transitionToStance("stand", animArrayFuncs);
		else
			transitionToStance("crouch", animArrayFuncs);
			
		suppressedBehavior(animArrayFuncs); 
		Reload( 0.75, random(self.animArray["anim_reload"]) );

		visibleEnemy = false;
		suppressableEnemy = false;
		if (isalive(self.enemy))
		{
			visibleEnemy = canSeeEnemyFromExposed();
			suppressableEnemy = canSuppressEnemyFromExposed();
		}

		if (forcedCover("hide"))
			idleWhileYouAreForcedToHide();

		idleIfPathBlocked();			

//	gotBoredAmbushing = false;
//	firedSuppressionClip = false;

		if (forcedCover("show"))
			gotBoredAmbushing = false;

		if ((!visibleEnemy && !suppressableEnemy) || (firedSuppressionClip && gotBoredAmbushing))
		{
			firedSuppressionClip = usingBoltActionWeapon(); // bolt action weapons cant do suppression fire by themselves
			gotBoredAmbushing = false;
			[[self.animArray["look_func"]]](); // lookForEnemyAndIdle
//			if (tryReacquiringTheEnemy())
//				return;
			
			idleUntilYouCouldSeeSomebody();

			visibleEnemy = canSeeEnemyFromExposed();
			suppressableEnemy = canSuppressEnemyFromExposed();
		}
		
		// Check suppressed again because we could've been suppressed while we were looking
		suppressedBehavior(animArrayFuncs); 
		visibleEnemy = canSeeEnemyFromExposed();
		suppressableEnemy = canSuppressEnemyFromExposed();
		
		if (usingBoltActionWeapon())
		{
			if (visibleEnemy)
				stepOutAndShootEnemy_bolt();
			else
			{
				if (suppressableEnemy)
				{
					// Save the suppression spot in case we lose it while we throw the grenade
					suppressSpot = getEnemySightPos();
					
	//				if (randomint(100) > 50)
					if (!tryThrowingGrenade())
						tryReacquire();
	
					gotBoredAmbushing = stepOutAndWaitForEnemy_bolt(suppressSpot);
				}
				else
					tryReacquire();
			}
		}
		else
		{
			if (visibleEnemy)
			{
				stepOutAndShootEnemy_auto();
				firedSuppressionClip = usingBoltActionWeapon(); // bolt action weapons cant do suppression fire by themselves
				gotBoredAmbushing = false;
			}
			else
			{
				if (suppressableEnemy)
				{
					if (firedSuppressionClip)
					{
						// Save the suppression spot in case we lose it while we throw the grenade
						suppressSpot = getEnemySightPos();
	
	//					if (randomint(100) > 50)
						if (!tryThrowingGrenade())
							tryReacquire();
	
						gotBoredAmbushing = stepOutAndWaitForEnemy_auto(suppressSpot);
					}
					else
					{
						tryReacquire();
						firedSuppressionClip = stepOutAndSuppressEnemy_auto();
					}
				}
				else
					tryReacquire();
			}
		}

		lookForBetterCover();
		/*
		if (lookForBetterCover())
		{
			[[animArrayFuncs["stand"]]]();	
			GoToCover();
		}
		*/
		
		
		animscripts\battleChatter_ai::evaluateSuppressionEvent();
		self animscripts\battleChatter::playBattleChatter();
	}
}

suppressedBehavior(animArrayFuncs)
{
	if (!isSuppressedWrapper())
		return;
	
	createBadPlaceandMove();
	
	self.suppressed = true;
	if (canSuppressEnemyFromExposed())
	{
		self animMode ( "zonly_physics" ); // Unlatch the feet
		self.keepClaimedNodeInGoal = true;
		TryGrenadePos( getEnemySightPos(), self.animArray["anim_grenade"], self.animArray["offset_grenade"] );
		self.keepClaimedNodeInGoal = false;
		
	}
		
	if (self isStanceAllowed("crouch"))
		transitionToStance("crouch", animArrayFuncs);

	Reload( 0.9, random( self.animArray["anim_reload"] ));
	
	// Idle alert animation
	self setAnimKnobAll(self.animArray["anim_alert"], %body, 1, .1, 1);
	while (isSuppressedWrapper())
		wait (0.2);
	wait (randomfloat(1));
	self.suppressed = false;
}

tryReacquiringTheEnemy()
{
	self FindReacquireDirectPath();
	return (self ReacquireMove());
		
}

tryThrowingGrenade()
{
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	threwGrenade = TryGrenadePos( getEnemySightPos(), self.animArray["anim_grenade"], self.animArray["offset_grenade"] );
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}


clearBlendedAnimation (animArray, blendTime)
{
	self clearAnim(animArray["left"], blendTime);
	self clearAnim(animArray["right"], blendTime);
}

setBlendedAnimation(animFlag, animArray, weight, blendTime, rate)
{
	self SetFlaggedAnimknob(animFlag,	animArray["left"],		weight, blendTime, rate);
	self SetAnimknob(					animArray["right"],		weight, blendTime, rate);
}


// Changes the AIs pose based on enemy angle
changeAimPose(spot)
{
	self endon ("killanimscript");
	self endon ("take_cover_at_corner");
	if (self.animArray["direction"] == "left")
	{
		modifyYawReverse(spot);
		return;
	}

	yaw = 0;
	if (canSuppressEnemy())
		yaw = self.coverNode GetYawToOrigin(getEnemySightPos());

	changeStance = false;
	switchTo = undefined;
	dif = 0.5;
	if (self.anim_cornerMode == "straight")
	{
		if (yaw <= anim.corner_straight_yaw_limit * -1)
		{
			dif = 0.01;
			switchTo = "left";
			changeStance = true;
		}
		if (yaw >= anim.corner_straight_yaw_limit)
		{
			dif = 0.99;
			switchTo = "right";
			changeStance = true;
		}
	}
	else
	if (self.anim_cornerMode == "left")
	{
		if (yaw >= -25)
		{
			dif = 0.99;
			switchTo = "straight";
			changeStance = true;
		}
	}
	else
	if (self.anim_cornerMode == "right")
	{
		if (yaw <= 25)
		{
			dif = 0.01;
			switchTo = "straight";
			changeStance = true;
		}
		if (yaw >= 80)
		{
			dif = 0.99;
			switchTo = "behind";
			changeStance = true;
		}
	}
	else
	if (self.anim_cornerMode == "behind")
	{
		if (yaw <= 55)
		{
			dif = 0.01;
			switchTo = "right";
			changeStance = true;
		}
	}	
	
	if (!changeStance)
		return;
	
//	self notify ("stop_aiming");
//	self setanim( %corner_45_left,	dif,	0.62 );	// anim, weight, blend-time
//	self setanim( %corner_45_right,	1-dif,	0.62 );
	
	self setflaggedanimknob("stanceChange", self.animArray["anim_" + self.anim_cornerMode +"_to_" + switchTo], 1.00, .0, 1.5); // 1.5
	self.anim_cornerMode = switchTo;
	self animscripts\shared::DoNoteTracks("stanceChange");
	if (isdefined(spot))
		thread AimAtSpot(spot);
	else
		thread AimAtEnemy();
}

// Changes the AIs pose based on enemy angle
modifyYawReverse(spot)
{
	
	// In case takecover was waiting for stancechance to finish
	yaw = 0;
	if (canSuppressEnemy())
		yaw = self.coverNode GetYawToOrigin(getEnemySightPos());

	changeStance = false;
	switchTo = undefined;
	dif = 0.5;
	if (self.anim_cornerMode == "straight")
	{
		if (yaw <= anim.corner_straight_yaw_limit * -1)
		{
			dif = 0.01;
			switchTo = "left";
			changeStance = true;
		}
		if (yaw >= anim.corner_straight_yaw_limit)
		{
			dif = 0.99;
			switchTo = "right";
			changeStance = true;
		}
	}
	else
	if (self.anim_cornerMode == "right")
	{
		if (yaw <= 25)
		{
			dif = 0.01;
			switchTo = "straight";
			changeStance = true;
		}
	}
	else
	if (self.anim_cornerMode == "left")
	{
		if (yaw >= -25)
		{
			dif = 0.99;
			switchTo = "straight";
			changeStance = true;
		}
		if (yaw <= -80)
		{
			dif = 0.01;
			switchTo = "behind";
			changeStance = true;
		}
	}
	else
	if (self.anim_cornerMode == "behind")
	{
		if (yaw >= -55)
		{
			dif = 0.99;
			switchTo = "left";
			changeStance = true;
		}
	}	
	if (!changeStance)
		return;
	
//	self notify ("stop_aiming");
//	self setanim( %corner_45_left,	dif,	0.62 );	// anim, weight, blend-time
//	self setanim( %corner_45_right,	1-dif,	0.62 );

	self setflaggedanimknob("stanceChange", self.animArray["anim_" + self.anim_cornerMode +"_to_" + switchTo], 1.00, .0, 1.5); // 1.5
	self.anim_cornerMode = switchTo;
	self animscripts\shared::DoNoteTracks("stanceChange");
	if (isdefined(spot))
		thread AimAtSpot(spot);
	else
		thread AimAtEnemy();
	
}

takecover()
{
	// Go back into hiding.
	wasSuppressed = issuppressedWrapper();
	self notify ("take_cover_at_corner"); // Stop doing the adjust-stance transition thread
	
//	self clearanim(self.animArray["anim_blend"]["left"], 0.2);
//	self clearanim(self.animArray["anim_blend"]["right"], 0.2);
//	println ("Blend out aim");
//	self clearanim (%corner_directions, 0.5);
	self notify ("stop_aiming");
	self setanimknob (%corner_pose, 1, 0.3, 1);
	self animscripts\face::SetIdleFace(anim.alertface);

	self clearanim(self.animArray["anim_alert_to_" + self.anim_cornerMode], 0);
	if (isSuppressedWrapper())
		rate = 1.5;
	else
		rate = 1;
	
	self setflaggedAnimknob("hide", self.animArray["anim_" + self.anim_cornerMode + "_to_alert"], 1, .0, rate);
	clearBlendedAnimation(self.animArray["anim_aim"], 0.3); // was 1 0.1 1
	self animscripts\shared::DoNoteTracks("hide");
	self.anim_alertness = "alert";	// Should be set in the aim2alert animation but sometimes isn't.

	self notify ( "stop updating angles" );
	self notify ("stop EyesAtEnemy");

	wait (0.05);

	self.keepClaimedNodeInGoal = false;
	if (distance(self.origin, self.coverNode.origin) < 32)
		self teleport (self.coverNode.origin);

	if (wasSuppressed)
		createBadPlaceandMove();
}


Set3FlaggedAnimKnobs(animFlag, animArrayname, weight, blendTime, rate)
{
	animArray = self.animArray[animArrayname];
	self.anim_3flag = animArrayname;
	self SetFlaggedAnimKnob(animFlag,	animArray["left"],		weight, blendTime, rate);
	self SetAnimKnob(					animArray["right"],		weight, blendTime, rate);

	//UpdateCornerAim( animArray, angleArray, cornerYaw );
}

Set3AnimKnobsRestart( animArray, weight, blendTime, rate)
{
	self SetAnimKnobRestart(animArray["left"],		weight, blendTime, rate);
	self SetAnimKnobRestart(animArray["right"],		weight, blendTime, rate);
}

WaitForAmbush(duration )
{
	if (!isalive(self.enemy))
		return;
	self.enemy endon ("death");
	self endon ("enemy");
	
	for (i=0;i<duration*20;i++)
	{
		if (self canSeeEnemy())
			break;
		if (self isSuppressedWrapper())
			break;
		if (forcedCover("show"))
			i = 0;
			
		self SetAnimKnob(self.animArray["anim_aim"]["left"], 1, .1, 1);
		self SetAnimKnob(self.animArray["anim_aim"]["right"], 1, .1, 1);
		wait 0.05;
	}
}

stepOut()
{
	self setanim (%corner_directions, 0.01, 0, 1);
	if (self.team == "axis")
		self.accuracy = anim.baseAccuracyBolt;
	// To clear out old look or reload animations we wait a frame
	self setAnimknobRestart(self.animArray["anim_alert"], 1, .1, 1);
	wait (0.05);

	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;

	yaw = 0;
	if (hasEnemySightPos())
		yaw = self.coverNode GetYawToOrigin(getEnemySightPos());

	self.anim_cornerAngle = 0;
	self.anim_cornerMode = "alert";

	anim_cornerAngle = 0;
	anim_cornerMode = "straight";
	if (yaw < -10)
	{
		anim_cornerMode = "left";
		anim_cornerAngle = -45;
	}
	if (yaw > 10)
	{
		anim_cornerMode = "right";
		anim_cornerAngle = 45;
	}

	// small chance to do an extra stepout just because the transitions look cool
	// and it makes them look more human	
	if (randomint(100) < 25)
	{
		// cover_left
		if (self.animArray["direction"] == "left")
		{
			if (anim_cornerMode == "straight")
			{
				self.new_anim_cornermode = "left";
				self.new_anim_cornerAngle = -45;
				playStepoutAnim();
			}
			else
			if (anim_cornerMode == "right")
			{
				self.new_anim_cornermode = "straight";
				self.new_anim_cornerAngle = 0;
				playStepoutAnim();
			}
		}
		else
		{	// cover right
			if (anim_cornerMode == "straight")
			{
				self.new_anim_cornermode = "right";
				self.new_anim_cornerAngle = 45;
				playStepoutAnim();
			}
			else
			if (anim_cornerMode == "left")
			{
				self.new_anim_cornermode = "straight";
				self.new_anim_cornerAngle = 0;
				playStepoutAnim();
			}
		}
	}

	self.new_anim_cornerAngle = anim_cornerAngle;
	self.new_anim_cornerMode = anim_cornerMode;
	playStepoutAnim();
	
	wait (0.15);
	return true;
}

playStepoutAnim()
{
	oldMode = self.anim_cornerMode;
	oldAngle = self.anim_cornerAngle;
	self.anim_cornerMode = self.new_anim_cornerMode;
	self.anim_cornerAngle = self.new_anim_cornerAngle;
	

	self setflaggedanimknob("animdone", self.animArray["anim_" + oldMode + "_to_" + self.anim_cornerMode], 1, 0, 1);
	setBlendedAnimation("not_flagged", self.animArray["anim_aim"], 1, 0, 1); // was 1 0.1 1
//	wait (0.95); // 0.15
	wait (0.5); // 0.15
	self setanim (%corner_directions, 1, 0.15, 1);
	self setanim (%corner_pose, 0.01, 0.15, 1);
	setBlendedAnimation("not_flagged", self.animArray["anim_aim"], 1, 0.3, 1); // was 1 0.1 1
	self setflaggedanimknob("animdone", self.animArray["anim_" + oldMode + "_to_" + self.anim_cornerMode], 1, 0.3, 1);
	self animscripts\shared::DoNoteTracks("animdone");
	self.anim_alertness = "aiming";	// Should be set in the alert2aim animation but sometimes isn't.
}

stepOutAndWaitForEnemy_bolt(suppressSpot)
{
	thread AimAtSpot( suppressSpot );
	sawEnemy = false;
	if (!StepOut()) // may not be room to step out
		return true; // got bored ambushing because there's no space to step out anyway.
	WaitForAmbush(5);
	if (isalive(self.enemy) && self canSeeEnemy())
	{
		sawEnemy = true;
		shootEnemyWhileVisible_otherwiseAmbush_bolt();
	}
	takeCover();
	return !sawEnemy;
}


stepOutAndShootEnemy_bolt()
{
	thread AimAtEnemy();
	if (!StepOut()) // may not be room to step out
		return;
	if (isalive(self.enemy))
		shootEnemyWhileVisible_otherwiseAmbush_bolt();
	takeCover();
}

shootEnemyWhileVisible_otherwiseAmbush_bolt()
{
	self.enemy endon ("death");
	self endon ("enemy");
	self endon ("stopShooting"); // For changing shooting pose to compensate for player moving OR FOR SUPPRESSION
	thread stopOnSuppression();
		
	thread maps\_gameSkill::resetAccuracyBolt(); // So the first shot doesnt hit
	while (self.bulletsInClip)
	{
		if (self canSeeEnemy())
		{
			if (enemyOutsideLegalYawRange())
				changeAimPose();
			thread AimAtEnemy();
			// Shoot and rechamber
			shootTime = animscripts\weaponList::shootAnimTime();
			self maps\_gameSkill::shootBolt();
			setBlendedAnimation("not_flagged", self.animArray["anim_boltfire"], 1, 0, 1);
			self.bulletsInClip --;
			self.anim_needsToRechamber = true;
			self playsound ("ai_rechamber");
			wait animscripts\weaponList::waitAfterShot();
			setBlendedAnimation("anim_rechamber", self.animArray["anim_rechamber"], 1, 0.3, 1);
			self animscripts\shared::DoNoteTracks("anim_rechamber");
			self.anim_needsToRechamber = false;
			continue;
		}

		// Less than half a clip left, reload
		if (self.bulletsInClip / getAIWeapon(self.weapon)["clipsize"] < 0.5)
			break;

		thread maps\_gameSkill::resetAccuracyBolt(); // So the first shot doesnt hit
		tryReacquire();
		if (canSuppressEnemy())
			thread AimAtSpot( getEnemySightPos() );

		WaitForAmbush(5);
		if (self isSuppressedWrapper())
		{
			// We got shot at by another enemy so let's hide and figure things out
			break;
		}
		if (!self canSeeEnemy())
			break;
	}
}


stepOutAndSuppressEnemy_auto()
{
	suppressSpot = getEnemySightPos();
	thread AimAtSpot( suppressSpot );
	if (!StepOut()) // may not be room to step out
		return false; // didnt suppress the enemy
	if (isalive(self.enemy))
		fireSuppressionBursts_UntilEnemyIsVisible(suppressSpot);

	keptEnemySuppressed = true;
	if (isalive(self.enemy) && self canSeeEnemy())
	{
		shootAutoIfEnemyIsVisible_OtherwiseDoBursts();
		keptEnemySuppressed = false;	
	}
		
	takeCover();
	return keptEnemySuppressed;
}

stepOutAndShootEnemy_auto()
{
	thread AimAtEnemy();
	if (!StepOut()) // may not be room to step out
		return;
	if (isalive(self.enemy)) // enemy may have died while stepping out
		shootAutoIfEnemyIsVisible_OtherwiseDoBursts();
	takeCover();
}

stepOutAndWaitForEnemy_auto(suppressSpot)
{
	thread AimAtSpot( suppressSpot );
	sawEnemy = false;
	if (!StepOut()) // may not be room to step out
		return true; // got bored ambushing because there's no space to step out anyway.
	WaitForAmbush(5);
	if (isalive(self.enemy) && self canSeeEnemy())
	{
		sawEnemy = true;
		shootAutoIfEnemyIsVisible_OtherwiseDoBursts();
	}
	takeCover();
	return !sawEnemy;
}


shootAutoIfEnemyIsVisible_OtherwiseDoBursts()
{
	self.enemy endon ("death");
	self endon ("enemy");
	
	while (self.bulletsInClip>0 && !isSuppressedWrapper())
	{
		// Idle aim animation
		if (self.anim_3flag != "autofire_end") // autofire_end transitions into anim_aim so we dont need to overwrite it
			self Set3FlaggedAnimKnobs("animdone", "anim_aim", 1, .1, 1);
		
		if (self canSeeEnemy())
		{
			if (enemyOutsideLegalYawRange())
				changeAimPose();

			// Go full auto if you have a bead on your enemy
			thread AimAtEnemy();
			
			// Firing animation
//			self Set3FlaggedAnimKnobs("animdone", self.animArray["anim_autofire"], 1, .1, self.weaponAnimRate);
			[[self.autoFire]]();
			continue;
		}

		tryReacquire();
		if (canSuppressEnemy())
		{
			suppressSpot = getEnemySightPos();
			changeAimPose(suppressSpot);
			if (!canHitSuppressSpot())
				break;
			
			// Otherwise fire suppression bursts until the clip is dry
			fireSuppressionBursts_UntilEnemyIsVisible(suppressSpot);
		}
		else
			break;
	}
	wait (0.2); // give bullets a chance to finish firing before stepping back
}

debugPoint (org)
{
	if (1) return;
	
	level.debugPoint = (0,0,0);
	for (;;)
	{
		if (level.debugPoint != (0,0,0))
			level.player Setorigin (level.debugpoint);
		print3d(level.debugPoint, "X", (1,1,1), 1, 50);
		wait (0.05);
	}
}

fireSuppressionBursts_UntilEnemyIsVisible(suppressSpot)
{
	thread AimAtSpot( suppressSpot );

	while (self.bulletsInClip>0 && isalive(self.enemy) && !isSuppressedWrapper())
	{
		changeAimPose(suppressSpot);
		// enemy could've died during changeaimpose
		if (!isalive(self.enemy))
			break; 
		if (!canHitSuppressSpot())
			break;

		[[self.autoFireSuppress]](suppressSpot);
		if (self canSeeEnemy())
			break;
	}
}

transitionToStance( stance, animArrayFuncs)
{
	[[animArrayFuncs[stance]]]();
	if (self.anim_pose == stance)
		return;

	self ExitProneWrapper(0.5);
	animscripts\SetPoseMovement::PlayBlendTransition(self.animarray["anim_transition_into_pose"], 0.18, stance, "stop", 0);
	self animscripts\shared::DoNoteTracks ("animdone");
	wait (0.2);
}

GoToCover()
{
	if ( self.anim_pose != "stand" && self.anim_pose != "crouch" ) // In case we were in Prone.
	{
		self ExitProneWrapper(0.5);
		self.anim_pose = "crouch";
	}

	playTransitionAnim = true;
	if (self.anim_special == "cover_" + self.animarray["direction"])
	{
		// We're already in position.  Just check for error conditions before continuing.
		playTransitionAnim = false;
	}

/*
	if ( self.anim_forced_cover == "show")
		playTransitionAnim = false;
*/

	self OrientMode( "face angle", self.coverNode.angles[1]+self.animArray["hideYawOffset"]);
	if ( playTransitionAnim )
	{
		self setAnimKnobAllRestart(self.animArray["anim_alert"], %body, 1, 2, self.animplaybackrate);
		self setAnimKnobAllRestart(%stand_alert_1, %body, 0.5, 2, self.animplaybackrate);
		self SetAnimKnobAll( %cover, %body, 1, 0.4);
		self.anim_pose = self.animArray["stance"];
		wait (0.5);
		self clearanim(%stand_alert_1, 0);
	}
	
	self.anim_special = "stop";
	self.anim_special = "cover_" + self.animarray["direction"];
	self.anim_movement = "stop";
}


semiAutoAnim_setup()
{
}

semiAutoAnim_fire()
{
	self Set3AnimKnobsRestart( self.animArray["anim_semiautofire"], 1, .1, 1);
}

enemyOutsideLegalYawRange()
{
	yaw = GetYawToOrigin(self.enemy.origin);
	return (yaw < anim.corner_straight_yaw_limit * -1 || yaw > anim.corner_straight_yaw_limit);
}

angleRangeThread()
{
	self.enemy endon ("death");
	self endon ("enemy");
	self endon ("killanimscript");
	self notify ("newAngleRangeCheck");
	self endon ("newAngleRangeCheck");
	self endon ("take_cover_at_corner");

	/*
	if (self.anim_cornermode == "straight")
	{
		leftLimit = anim.corner_straight_yaw_limit * -1;
		rightLimit = anim.corner_straight_yaw_limit;
	*/
		
	changeStance = false;
	while (!changeStance)
	{
		if (enemyOutsideLegalYawRange())
			break;
		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}

AutofireCorner()
{
	self.enemy endon ("death");
	self endon ("enemy");

	// give the player a chance to react
	maps\_gameskill::resetAccuracyAndPause();
	pauseIfPlayerIsInvulAndYouAreAPauseGuy();
	
	// Firing animation
	self Set3FlaggedAnimKnobs("animdone", "anim_autofire", 1, .2, self.weaponAnimRate);
	// Determines if the enemy is outside the yaw range of the pose so we need to adjust our pose
	thread angleRangeThread();
	AutoFire();
	
	// no recoil if we're gettin back in cover fast
	if (isSuppressedWrapper())
		return;

	thread burstRecoil();
}

burstRecoil()
{
	self endon ("killanimscript");
	self notify ("killburstfire"); // this animation may never end so kill overlapping occurances
	self endon ("killburstfire");
	self Set3FlaggedAnimKnobs("autofire", "autofire_end", 1, 0, 1);
	self waittillmatch("autofire","end");
	
	if (self.anim_3flag != "autofire_end") // not doing autofire end anymore
		return;
	// Idle aim animation
	self Set3FlaggedAnimKnobs("animdone", "anim_aim", 1, 0, 1);
}

AutofireCorner_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");

	// Firing animation
	self Set3FlaggedAnimKnobs("animdone", "anim_autofire", 1, .1, self.weaponAnimRate);

	shootBurst(suppressSpot);

	self Set3FlaggedAnimKnobs("autofire", "autofire_end", 1, 0, self.weaponAnimRate);
	self waittillmatch("autofire","end");
		
	// Idle aim animation
	self Set3FlaggedAnimKnobs("animdone", "anim_aim", 1, 0, 1);
	
	burstDelay();
}

SemiAutofireCorner()
{
	self.enemy endon ("death");
	self endon ("enemy");
	
	// Determines if the enemy is outside the yaw range of the pose so we need to adjust our pose
	thread angleRangeThread();
	semiAutoFire();
	
	// Idle aim animation
	self Set3FlaggedAnimKnobs("animdone", "anim_aim", 1, .1, 1);
}

SemiAutofireCorner_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");
	
	shootSemiAutoBurst(suppressSpot);
	
	// Idle aim animation
	self Set3FlaggedAnimKnobs("animdone", "anim_aim", 1, .1, 1);

	burstDelay();
}

peekStop()
{
	self endon ("stopPeekCheckThread");
	self endon ("killanimscript");

	for (;;)
	{
		if (isalive(self.enemy) && self canSeeEnemy())
			break;
		wait (0.05);
	}
	
	self notify ("stopPeeking");
}

peekOut(hat)
{
	self thread peekStop();
	self endon ("stopPeeking");
	self setflaggedanimknobAll("looking_start", self.animArray["anim_alert_to_look"][hat], %body, 1, .0, 1);
	animscripts\shared::DoNoteTracks("looking_start");
	self notify ("stopPeekCheckThread");
}

lookForEnemyAndIdleOriginMoves()
{
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	hat = "no_hat";
	if (removeableHat() && !IsInCombat())
		hat = "hat";
	peekOut(hat);

	waitUntilYouSeeSomebodyOrGetBored(hat, 2+randomfloat(2));
	if (isalive(self.enemy) && self canSeeEnemy())
	{
		// Gets back fast if he sees someone.
		if (hasLookFastAnim(hat) && self issuppressed())
			self setflaggedanimknob("looking_end", self.animArray["anim_look_to_alert_fast"][hat], 1, .0, 1.0); // 1.5
		else
			self setflaggedanimknob("looking_end", self.animArray["anim_look_to_alert"][hat], 1, .0, 1.5); // 1.5
		animscripts\shared::DoNoteTracks("looking_end");
		self.keepClaimedNodeInGoal = false;
		return;
	}
	
	self setflaggedanimknobAll("looking_end", self.animArray["anim_look_to_alert"][hat], %body, 1, .0, 1);
	animscripts\shared::DoNoteTracks("looking_end");
	self teleport (self.covernode.origin);
	self.keepClaimedNodeInGoal = false;
	lookForBetterCover();
}

lookForEnemyAndIdleOriginDoesntMove()
{
	hat = "no_hat";
	if (removeableHat() && !IsInCombat())
		hat = "hat";
	peekOut(hat);

	waitUntilYouSeeSomebodyOrGetBored(hat, 2+randomfloat(2));
	if (isalive(self.enemy) && self canSeeEnemy())
	{
		// Gets back fast if he sees someone.
		if (hasLookFastAnim(hat) && self issuppressed())
			self setflaggedanimknob("looking_end", self.animArray["anim_look_to_alert_fast"][hat],  1, .0, 1.0); // 1.5
		else
			self setflaggedanimknob("looking_end", self.animArray["anim_look_to_alert"][hat],  1, .0, 1.5); // 1.5
		animscripts\shared::DoNoteTracks("looking_end");
		return;
	}
	
	self setflaggedanimknobAll("looking_end", self.animArray["anim_look_to_alert"][hat], %body, 1, .0, 1);
	animscripts\shared::DoNoteTracks("looking_end");
	lookForBetterCover();
}

lookForEnemy()
{
	self endon ("killanimscript");
	for (;;)
	{
		if (isalive(self.enemy))
		{
			if (canSeeEnemyFromExposed())
				break;
//			if (canSuppressEnemyFromExposed())
//				return;
		}
		
		wait (0.15);
	}
	self notify ("sawEnemy");
}

idleIfPathBlocked()
{
	thread idleHide();
//	predictedSelfOrigin = getNodeOffset(self.coverNode) + self.coverNode.origin + (0,0,-64);
	angles = self.coverNode.angles;
	right = anglestoright(angles);
	switch(self.coverNode.type)
	{
		case "Cover Left":
		case "Cover Wide Left":
			right = maps\_utility::vectorScale(right, -32);
		break;

		case "Cover Right":
		case "Cover Wide Right":
			right = maps\_utility::vectorScale(right, 32);
		break;
		default:
		assertEx(0, "What kind of node is this????");
	}
	predictedSelfOrigin = self.coverNode.origin + (right[0], right[1], 0);

	while (anim.maymoveCheckEnabled)
	{
		clearPath = self maymovetopoint(predictedSelfOrigin);
		if (clearPath)
			break;
		wait (0.2);
	}
	
	self notify ("stopHiding");
}

idleWhileYouAreForcedToHide()
{
	thread idleHide();
	while (forcedCover("hide"))
		wait (0.5);
	self notify ("stopHiding");
}

idleHide()
{
	self endon ("killanimscript");
	self endon ("stopHiding");
	nextTwitch = 2 + randomint(2);
	lastTwitch = 1;
	
	for (;;)
	{
		idleAnim = 0;
		nextTwitch--;
		if (!nextTwitch)
		{
			nextTwitch = 2 + randomint(2);
			idleAnim = lastTwitch;
			lastTwitch++;
			if (lastTwitch >= self.animArray["anim_look_idle"]["weight"].size)
				lastTwitch = 1;
		}
			
		self setflaggedanimknobAll("look idle", self.animArray["anim_look_idle"][idleAnim], %body, 1, .1, 1);
		animscripts\shared::DoNoteTracks("look idle");
	}
}

/*
		idleAnim = random_weight(self.animArray["anim_look_idle"]["weight"]);
		// Make it use the default alert idle rather than two of the same twitches in a row
		if (idleAnim == oldAnim)
		{
			if (idleAnim == 1)
				idleAnim = 2;
			else
				idleAnim = 1;
		}

		if (idleAnim > 0)
			oldAnim = idleAnim;
*/

idleUntilYouCouldSeeSomebody()
{
	self endon ("sawEnemy");
	thread lookForEnemy();
	
	nextTwitch = 2 + randomint(2);
	lastTwitch = 1;
	
//	self.keepClaimedNodeInGoal = true;
	for (;;)
	{
		idleAnim = 0;
		nextTwitch--;
		if (!nextTwitch)
		{
			nextTwitch = 2 + randomint(2);
			idleAnim = lastTwitch;
			lastTwitch++;
			if (lastTwitch >= self.animArray["anim_look_idle"]["weight"].size)
				lastTwitch = 1;
		}

		lookForBetterCover();
		self setflaggedanimknobAll("look idle", self.animArray["anim_look_idle"][idleAnim], %body, 1, .1, 1);
		animscripts\shared::DoNoteTracks("look idle");
	}
//	self.keepClaimedNodeInGoal = false;
}

waitUntilYouSeeSomebodyOrGetBored(hat, duration)
{
	for (i=0;i<duration*20;i++)
	{
		// Break out if you saw somebody lately
		if (isalive(self.enemy))
		{ 
			if (self canSeeEnemy())
				return;
//			if (canSuppressEnemy())
//				return;
		}
			
		self setanimknobAll(self.animArray["anim_look"][hat], %body, 1, .0, 1);
		wait (0.05);
	}
}

nodeOutOfRange()
{
	self endon ("killanimscript");
	
	for(;;)
	{
		self waittill( "node out of range" );
		assert(0);
		saveClaimedNode = self.keepClaimedNodeInGoal;
		self.keepClaimedNodeInGoal = false;
		if (lookForBetterCover())
		{
			return;
		}
		else
		{
			self.keepClaimedNodeInGoal = saveClaimedNode;
		}
		wait( 0.05 );
	}
}

CornerAlertIdle( timeToIdle, idleAnim, changeReason )
{
    entryState = self . scriptState;
//    self trackScriptState ( "CornerAlertIdle", changeReason );

	// NB idleAnim is either a single frame or a looping anim, so we can set and forget.
//			setanimknoball(anim, rootAnim, goalWeight, goalTime, rate) 
	self setAnimKnobAllRestart(idleAnim, %body, 1, .1, 1);
	wait timeToIdle;

//    self trackScriptState ( entryState, "CornerAlertIdle finished" );
}

clearPathDebug(delta, org)
{
	self endon ("killanimscript");
	timer = 5;
	timer *= 20;
	for (i=0;i<timer;i++)
	{
		line (self.origin, org, (0,1,0.3), 1);
		print3d (org, delta, (0,1,0.3), 1, 0.3);
		wait (0.05);
	}
	
}



// TODO - Put me in code!
// Requires that animArray and angleArray each contain 3 corresponding entries.  The angles must be in 
// ascending order, "left", "middle" and "right".  Also assumes that any angle between angleArray["right"] 
// and 180 is > angleArray["right"], and any angle between -180 and angleArray["left"] is < 
// angleArray["left"].
UpdateCornerAimThread( endString, animArray, targetOrg, targetFunction )
{
	self endon ("killanimscript");
//	self endon (anim.scriptChange);
	self notify (endString);
	self endon (endString);

	for (;;)
	{
		updateCrossBlendedAnimation ( animArray, self.animArray["angle_aim"], targetOrg, targetFunction);
		wait 0.05;
	}
}

AimAtSpot( targetOrg )
{
	if (!isalive (self.enemy))
		return;
	UpdateCornerAimThread( "stop_aiming", self.animArray["anim_blend"], targetOrg, animscripts\utility::GetCoverNodeYawToOrigin );
}

AimAtEnemy()
{
	if (!isalive (self.enemy))
		return;
	self thread eyesAtEnemy();
	self.enemy endon ("death");
	self endon ("enemy");
	UpdateCornerAimThread( "stop_aiming", self.animArray["anim_blend"], undefined, ::getYawToEnemyNoParam );
}

getYawToEnemyNoParam ( noparam )
{
	return animscripts\utility::getCoverNodeYawToEnemy();
}

updateCrossBlendedAnimation ( animArray, angleArray, targetOrg, targetFunction )
{
	// We're careful not to set any weights to 0 for two reasons.  First, we need to make sure that 
	// Set3FlaggedAnimKnobs doesn't flag an animation with weight 0, and second, if Set3FlaggedAnimKnobs sets 
	// an animation whose parent weight is 0, that parent's weight gets set to 1, which causes an odd twitch.
	closeToZero = 0.01;
/*	
	if (self.anim_yawTransition != "exposed")
	{
		if (!isdefined(targetOrg))
		{
			if (!isalive (self.enemy))
				return;
			targetOrg = self.enemy.origin;
		}
		
		yawDelta = self.angles[1] - GetYaw(targetOrg);
		yawDelta = AngleClamp(yawDelta, "-180 to 180");
	}
	else
*/	
	yawDelta = [[targetFunction]](targetOrg);
		
	yawDelta = int(yawDelta+360) % 360;
	if ( yawDelta > 180 )
		yawDelta -= 360;
		
		
	if (yawDelta<=angleArray["left"])
	{
		animWeights["left"] = 1;
		animWeights["right"] = closeToZero;
	}
	else if (yawDelta<angleArray["right"])
	{
		middleFraction = ( angleArray["right"] - yawDelta ) / ( angleArray["right"] - angleArray["left"] );
		if (middleFraction < closeToZero)	middleFraction = closeToZero;
		if (middleFraction > 1-closeToZero)	middleFraction = 1-closeToZero;
		animWeights["left"] = middleFraction;
		animWeights["right"] = 1 - middleFraction;
	}
	else
	{
		animWeights["left"] = closeToZero;
		animWeights["right"] = 1;
	}

	/*
	println ("");
	println ("Time: ", gettime());
	println ("Yaw:", yawDelta);
	println ("Left:", animWeights["left"]);
	println ("Right:", animWeights["right"]);
	*/

	waittillframeend;	
//	animWeights["left"] = 0.99;
//	animWeights["right"] = 0.01;
	
	self setanim( animArray["left"],		animWeights["left"],		0.5 );	// anim, weight, blend-time
	self setanim( animArray["right"],		animWeights["right"],		0.5 );
//	self setanim( animArray["left"], 0,0);
//	self setanim( animArray["right"],0,0);
//	wait (0.15);
}

hasLookFastAnim(hat)
{
	if (!isdefined ( self.animArray["anim_look_to_alert_fast"] ))
		return false;
	return (isdefined ( self.animArray["anim_look_to_alert_fast"][hat] ));
}