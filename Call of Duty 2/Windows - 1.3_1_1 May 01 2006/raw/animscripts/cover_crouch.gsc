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

    self trackScriptState( "Cover Crouch Main", "code" );
    animscripts\utility::initialize("cover_crouch");
    self.coverNode = self.node;
    
    setAnimArrayHasWall();
    
	// Auto and semi auto use the same logic but separate functions for the actual bullet firing
	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self.autoFire = ::autoFireCrouch;
		self.autoFireSuppress = ::autoFireCrouch_suppress;
	}
	else
	if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		self.fireanim_setup = ::semiAutoAnim_setup;
		self.fireanim_fire = ::semiAutoAnim_fire;
		self.autoFire = ::SemiAutofireCrouch;
		self.autoFireSuppress = ::SemiAutofireCrouch_Suppress;
	}
	else
	{
	}
	
	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");

	self.fastStand = true;
	stopAndCrouch();
	
    turret = isdefined (self.coverNode.auto_mg42_target);

	// handle starting pose somehow
	firedSuppressionClip = false;
	gotBoredAmbushing = false;
	
	for (;;)
	{
		if (forcedCover("show"))
			gotBoredAmbushing = false;

		self animscripts\face::SetIdleFace(anim.alertface);
		idleWhileIHaveNoEnemy_crouch();

    	if (turret && tryTurret (self.coverNode.auto_mg42_target))
    		return;
		
		if (shouldTakeCover_axis(firedSuppressionClip, gotBoredAmbushing))
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
				{
					Reload( 0.75, %crouch_cover_reload );
					break;
				}
				
				if (isSuppressedWrapper())
					suppressedBehavior();
				else					
					Reload( 0.75, %crouch_cover_reload );

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
		{
//			if (!self canSeeEnemy() && !canSeeEnemyFromExposed())
//				stand_idleUntilEnemyWouldBeVisible();
			aimAtEnemyOrSpot();
		}
		
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
					{
						// Dont try to aim after trying a grenade throw unless the throw was successful
						if (tryThrowingGrenade())
							waitForEnemy_bolt(suppressSpot);
						else
			        		tryReacquire();
					}
					else
					{
			        	tryReacquire();
						gotBoredAmbushing = waitForEnemy_bolt(suppressSpot);
					}
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
			{
				if (suppressableEnemy)
				{
					if (firedSuppressionClip)
					{
						// Save the suppression spot in case we lose it while we throw the grenade
						suppressSpot = getEnemySightPos();
	
						if (randomint(100) > 50)
						{
							// Dont try to aim after trying a grenade throw unless the throw was successful
							if (tryThrowingGrenade())
								waitForEnemy_auto(suppressSpot);
							else
				        		tryReacquire();
						}
						else
						{
				        	tryReacquire();
							gotBoredAmbushing = waitForEnemy_auto(suppressSpot);
						}
					}
					else
					{
			        	tryReacquire();
						firedSuppressionClip = suppressEnemy_auto();
					}
				}
			}
		}

		stopAiming(0.34);

		lookForBetterCover();
	
		animscripts\battleChatter_ai::evaluateSuppressionEvent();
	}
}


mainConceal()
{
	if (weaponAnims() == "panzerfaust" || weaponAnims() == "pistol")	
	{
		animscripts\combat::main();
		return;
	}
	
	self endon("killanimscript");

    self trackScriptState( "Cover Crouch Main", "code" );
    animscripts\utility::initialize("cover_crouch");
    self.coverNode = self.node;
    
    setAnimArrayHasWall();
    
	// Auto and semi auto use the same logic but separate functions for the actual bullet firing
	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self.autoFire = ::autoFireCrouch;
		self.autoFireSuppress = ::autoFireCrouch_suppress;
	}
	else
	if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		self.fireanim_setup = ::semiAutoAnim_setup;
		self.fireanim_fire = ::semiAutoAnim_fire;
		self.autoFire = ::SemiAutofireCrouch;
		self.autoFireSuppress = ::SemiAutofireCrouch_Suppress;
	}
	else
	{
	}
	
	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");

	self.fastStand = true;
	stopAndCrouch();
	
    turret = isdefined (self.coverNode.auto_mg42_target);
    
	// handle starting pose somehow
	firedSuppressionClip = false;
	
	for (;;)
	{
		self animscripts\face::SetIdleFace(anim.alertface);
		idleWhileIHaveNoEnemy_crouch();

    	if (turret && tryTurret (self.coverNode.auto_mg42_target))
    		return;
		
		if (shouldTakeCoverConceal_axis())
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
				{
					Reload( 0.75, %crouch_cover_reload );
					break;
				}
				
				if (isSuppressedWrapper())
					suppressedBehavior();
				else					
					Reload( 0.75, %crouch_cover_reload );

				if (forcedCover("hide"))
					idleWhileYouAreForcedToHide();
					
				if (!shouldTakeCoverConceal_axis())
					break;
			}
			leaveCoverAndAim();
		}
		else
			aimAtEnemyOrSpot();
		
		visibleEnemy = false;
		suppressableEnemy = false;
		if (isalive(self.enemy))
		{
			visibleEnemy = self canSeeEnemy();
			suppressableEnemy = canSuppressEnemy();
		}

		if (!visibleEnemy && !suppressableEnemy)
			aimAtGoodShootPos();

		if (isalive(self.enemy))
		{
			while (!visibleEnemy && !suppressableEnemy)
			{
				aimStraightAhead();
				visibleEnemy = self canSeeEnemy();
				suppressableEnemy = canSuppressEnemy();
				wait (0.15);
			}
		}

    	if (turret && tryTurret (self.coverNode.auto_mg42_target))
    		return;
				
		if (usingBoltActionWeapon())
		{
			if (visibleEnemy)
				shootEnemy_bolt();
			else
			if (suppressableEnemy)
			{
				// Save the suppression spot in case we lose it while we throw the grenade
				suppressSpot = getEnemySightPos();
				if (randomint(100) > 50)
				{
					// Dont try to aim after trying a grenade throw unless the throw was successful
					if (tryThrowingGrenade())
						waitForEnemy_bolt(suppressSpot);
				}
				else
					waitForEnemy_bolt(suppressSpot);
			}
			else
				waitForEnemyStraightAhead_bolt();
		}
		else
		{
			if (visibleEnemy)
			{
				shootEnemy_auto();
				firedSuppressionClip = false;
			}
			else
			if (suppressableEnemy)
			{
				if (firedSuppressionClip)
				{
					// Save the suppression spot in case we lose it while we throw the grenade
					suppressSpot = getEnemySightPos();

					if (randomint(100) > 50)
					{
						// Dont try to aim after trying a grenade throw unless the throw was successful
						if (tryThrowingGrenade())
							waitForEnemy_auto(suppressSpot);
					}
					else
						waitForEnemy_auto(suppressSpot);
				}
				else
					firedSuppressionClip = suppressEnemy_auto();
			}
			else
				waitForEnemyAimStraight_auto();
		}

		if (!isalive(self.enemy))
		{
			aimStraightAhead();
			WaitForEnemy();
		}

		stopAiming(0.34);

		lookForBetterCover();

		animscripts\battleChatter_ai::evaluateSuppressionEvent();
	}
}

Set3FlaggedAnimKnobs(animFlag, animArray, weight, blendTime, rate)
{
	// 0.1
	self setAnimKnob(%crouch_directions, weight, blendTime, rate);
	self SetFlaggedAnimKnob(animFlag,	self.animArray[animArray][self.anim_pose]["up"],			1, blendTime, 1);
	self SetAnimKnob(					self.animArray[animArray][self.anim_pose]["down"],			1, blendTime, 1);
}

Set3FlaggedAnimKnobsRestart(animFlag, animArray, weight, blendTime, rate)
{
	// 0.1
	self setAnimKnobRestart(%crouch_directions, weight, blendTime, rate);
	self SetFlaggedAnimKnobRestart(animFlag,	self.animArray[animArray][self.anim_pose]["up"],			1, blendTime, 1);
	self SetAnimKnobRestart(					self.animArray[animArray][self.anim_pose]["down"],			1, blendTime, 1);
}

setAnimArrayHasWall()
{
	// Means there is something in front of the AI to lean and shoot over
	setAnimArray(true);
}

setAnimArrayNoWall()
{
	// Means there is something in front of the AI to lean and shoot over
	setAnimArray(false);
}


setAnimArray(leaning_over_wall)
{
	animArray = [];
	
	if (leaning_over_wall)
	{
		animArray["aim"]		["stand"] ["down"]		= %crouch_cover_aim_down60;
		animArray["aim"]		["stand"] ["up"]		= %crouch_cover_aim_dn_straight;
		animArray["aim"]		["crouch"]["down"]		= %crouch_cover_aim_straight;
		animArray["aim"]		["crouch"]["up"]		= %crouch_cover_aim_up60;
		animArray["auto_end"]	["stand"] ["down"]		= %crouch_cover_shoot_autoend_down60;
		animArray["auto_end"]	["stand"] ["up"]		= %crouch_cover_shoot_autoend_dn_straight;
		animArray["auto_end"]	["crouch"]["down"]		= %crouch_cover_shoot_autoend_straight;
		animArray["auto_end"]	["crouch"]["up"]		= %crouch_cover_shoot_autoend_up60;
		animArray["auto"]		["stand"] ["down"]		= %crouch_cover_shoot_auto_down60;
		animArray["auto"]		["stand"] ["up"]		= %crouch_cover_shoot_auto_dn_straight;
		animArray["auto"]		["crouch"]["down"]		= %crouch_cover_shoot_auto_straight;
		animArray["auto"]		["crouch"]["up"]		= %crouch_cover_shoot_auto_up60;
		animArray["rechamber"]	["stand"] ["down"]		= %crouch_cover_rechamber_down60;
		animArray["rechamber"]	["stand"] ["up"]		= %crouch_cover_rechamber_dn_straight;
		animArray["rechamber"]	["crouch"]["down"]		= %crouch_cover_rechamber_straight;
		animArray["rechamber"]	["crouch"]["up"]		= %crouch_cover_rechamber_up60;
		animArray["one_shot"]	["stand"]["down"]		= %crouch_cover_shoot_down60;
		animArray["one_shot"]	["stand"]["up"]			= %crouch_cover_shoot_dn_straight;
		animArray["one_shot"]	["crouch"]["down"]		= %crouch_cover_shoot_straight;
		animArray["one_shot"]	["crouch"]["up"]		= %crouch_cover_shoot_up60;
		animArray["stand"] 		= %crouch_cover_aim_straight2aim_dn_straight;
		animArray["crouch"]		= %crouch_cover_aim_dn_straight2aim_straight;
	}
	else
	{
		animArray["aim"]		["stand"] ["down"]		= %crouch_cover_stand_aim_down;
		animArray["aim"]		["stand"] ["up"]		= %crouch_cover_stand_aim_straight;
		animArray["aim"]		["crouch"]["down"]		= %crouch_cover_aim_straight;
		animArray["aim"]		["crouch"]["up"]		= %crouch_cover_aim_up60;
		animArray["auto_end"]	["stand"] ["down"]		= %crouch_cover_stand_autoend_down; // 	stand_shoot_autoend_down
		animArray["auto_end"]	["stand"] ["up"]		= %crouch_cover_stand_autoend_dn_straight; // stand_shoot_autoend_straight
		animArray["auto_end"]	["crouch"]["down"]		= %crouch_cover_shoot_autoend_straight;
		animArray["auto_end"]	["crouch"]["up"]		= %crouch_cover_shoot_autoend_up60;
		animArray["auto"]		["stand"] ["down"]		= %crouch_cover_stand_auto_down;
		animArray["auto"]		["stand"] ["up"]		= %crouch_cover_stand_auto_straight;
		animArray["auto"]		["crouch"]["down"]		= %crouch_cover_shoot_auto_straight;
		animArray["auto"]		["crouch"]["up"]		= %crouch_cover_shoot_auto_up60;
		animArray["rechamber"]	["stand"] ["down"]		= %crouch_cover_stand_rechamber_down;
		animArray["rechamber"]	["stand"] ["up"]		= %crouch_cover_stand_rechamber_straight;
		animArray["rechamber"]	["crouch"]["down"]		= %crouch_cover_rechamber_straight;
		animArray["rechamber"]	["crouch"]["up"]		= %crouch_cover_rechamber_up60;
		animArray["one_shot"]	["stand"]["down"]		= %crouch_cover_stand_shoot_down;
		animArray["one_shot"]	["stand"]["up"]			= %crouch_cover_stand_shoot_straight;
		animArray["one_shot"]	["crouch"]["down"]		= %crouch_cover_shoot_straight;
		animArray["one_shot"]	["crouch"]["up"]		= %crouch_cover_shoot_up60;
		animArray["stand"] 		= %crouch_cover_crouch_to_stand;
		animArray["crouch"]		= %crouch_cover_stand_to_crouch;
	}

	animArray["leaning_over_wall"]	=	leaning_over_wall;
		

/*
	animArray["stand"] 		= %crouch_cover_aim_straight2aim_dn_straight;
	animArray["crouch"]		= %crouch_cover_aim_dn_straight2aim_straight;


	self setanimknob (%crouchhide2stand, 1, 0.2, 1);


*/

	
	self.animArray = animArray;
}

changeAimStance(offset, spot)
{
	// The "wall" animations have him leaning over the wall, for shooting down on somebody below like from on top of a building
	if (offset < -0.5)
		setAnimArrayHasWall();
	else
		setAnimArrayNoWall();
		
	tippingPoint = -0.01;
	if (offset < tippingPoint && self.anim_pose == "crouch")
	{
		self notify ("stop_aiming");
		self clearAnim(%crouch_directions, 0.2);
		self setflaggedanimknob ("standup", self.animArray["stand"], 1, 0.2, 1);
		if (isalive(self.enemy))
			offset = getEnemyAngleOffset();
		else
			offset = getTargetAngleOffset(spot);
		

		wait (0.15);		
		
		if (offset > -0.1)
			wait (0.15);
		else
		if (offset > -0.3)
			wait (0.2);
		else
		if (offset > -0.5)
			wait (0.25);
		else
		if (offset > -0.7)
			wait (0.3);
		
		self.anim_pose = "stand";
		self.anim_special = "none";
		if (isalive(self.enemy))
			offset = getEnemyAngleOffset();
		else
			offset = getTargetAngleOffset(spot);

		Set3FlaggedAnimKnobs("none", "aim", 1, 0.15, 1);//weight, blendTime, rate)
		applyBlend (offset + 1);
		wait (0.15);
		self.anim_alertness = "aiming";
	}
	else
	if (offset >= tippingPoint && self.anim_pose == "stand")
	{
		self notify ("stop_aiming");
		self clearAnim(%crouch_directions, 0.2);
		self setflaggedanimknob ("standup", self.animArray["crouch"], 1, 0.3, 1);
		if (isalive(self.enemy))
			offset = getEnemyAngleOffset();
		else
			offset = getTargetAngleOffset(spot);

		wait (0.15);		
		
		if (offset > -0.1)
			wait (0.15);
		else
		if (offset > -0.3)
			wait (0.2);
		else
		if (offset > -0.5)
			wait (0.25);
		else
		if (offset > -0.7)
			wait (0.3);
		
		self.anim_pose = "crouch";
		self.anim_idleSet = "b";
		self.anim_special = "cover_crouch";
		self.anim_movement = "stop";
		if (isalive(self.enemy))
			offset = getEnemyAngleOffset();
		else
			offset = getTargetAngleOffset(spot);
		Set3FlaggedAnimKnobs("none", "aim", 1, 0.15, 1);//weight, blendTime, rate)
		applyBlend (offset);
		wait (0.15);
		self.anim_alertness = "aiming";
	}
	else
	if (self.anim_pose == "stand")
	{
		if (self.anim_alertness != "aiming")
			blendTime = 0.5;
		else
			blendTime = 0.15;
		Set3FlaggedAnimKnobs("none", "aim", 1, blendTime, 1);//weight, blendTime, rate)
		applyBlend (offset + 1);
		wait (blendTime);
		self.anim_alertness = "aiming";
	}
	else
	if (self.anim_pose == "crouch")
	{
		if (self.anim_alertness != "aiming")
			blendTime = 0.5;
		else
			blendTime = 0.15;
		Set3FlaggedAnimKnobs("none", "aim", 1, blendTime, 1);//weight, blendTime, rate)
		applyBlend (offset);
		wait (blendTime);
		self.anim_alertness = "aiming";
	}
}	

aimAtEnemy()
{
	offset = getEnemyAngleOffset();
	changeAimStance(offset, self.enemy geteye()); // enemy can die during changeaimstance
	if (isalive(self.enemy))
		thread aimAtEnemyProc();
}

aimAtSpot(spot)
{
	offset = getTargetAngleOffset(spot);
	changeAimStance(offset, spot); // enemy can die during changeaimstance
	if (isalive(self.enemy))
		thread aimAtSpotProc(spot);
}

getEnemyAngleOffset()
{
	return getTargetAngleOffset( self.enemy getEye());
}

applyBlend (offset)
{
	if (offset < 0)
		offset = 0;
	if (offset > 1)
		offset = 1;
	up = offset;
	if (up >= 0.98)
		up = 0.98;
	if (up <= 0.02)
		up = 0.02;
	down = 1 - up;
	waittillframeend; // so the blend can overwrite the knob force weight
	self setanim( %crouch_up, 			up,			0, 1);
	self setanim( %crouch_down, 		down,		0, 1);
}	

aimAtEnemyProc( )
{
	self notify ("stop_aiming");
	self endon ("stop_aiming");
	self endon ("killanimscript");
	self.enemy endon ("death");
	self endon ("enemy");

	self OrientMode( "face enemy" );

	offset = getEnemyAngleOffset();
	changeAimStance(offset, self.enemy geteye());
	stanceAdd = 0;
	if (self.anim_pose == "stand")
		stanceAdd = 1;

	for (;;)
	{
		offset = getEnemyAngleOffset();
		offset += stanceAdd;
		if (self.anim_pose == "crouch" && offset < -0.05)
			self notify ("stopShooting");
		if (self.anim_pose == "stand" && offset > 1.05)
			self notify ("stopShooting");
		
		applyBlend(offset);
		wait (0.05);
	}
}

aimAtSpotProc(spot)
{
	self notify ("stop_aiming");
	self endon ("stop_aiming");
	self endon ("killanimscript");

	myYawFromTarget = VectorToAngles(spot - self.origin );
	self OrientMode( "face angle", myYawFromTarget[1] );

	offset = getTargetAngleOffset(spot);
	changeAimStance(offset, spot);
	stanceAdd = 0;
	if (self.anim_pose == "stand")
		stanceAdd = 1;

	offset = getTargetAngleOffset(spot);
	offset += stanceAdd;
	if (self.anim_pose == "crouch" && offset < -0.05)
		self notify ("stopShooting");
	if (self.anim_pose == "stand" && offset > 1.05)
		self notify ("stopShooting");
	
	applyBlend(offset);
}

aimAtEnemyOrSpot()
{
	if (isalive(self.enemy))
	{
		if (self canSeeEnemyFromExposed())
			AimAtEnemy();
		else
		if (self canSuppressEnemyFromExposed())
			AimAtSpot(getEnemySightPos());
	}
	Set3FlaggedAnimKnobs("none", "aim", 1, 0.15, 1);//weight, blendTime, rate)
	
	
	/*
	self setanimknob (%shoot, 1, 0.6, 1);
	self setanimknob (%stand_aim, 1, 0.6, 1);
	wait (0.6);
	*/
}

idleWhileYouAreForcedToHide()
{
	thread loopingHideIdle();
	while (forcedCover("hide"))
		wait (0.2);
	self notify ("stop_idling");
}


stopAndCrouch()
{
	self OrientMode( "face angle", self.coverNode.angles[1] );
	if (self.anim_pose == "stand")
	{
		self setflaggedanimknob ("crouchdown", %stand_alert2crouch_cover_aim_straight, 1, 0.2, 1);
		self waittillmatch ("crouchdown", "end");
		self.anim_pose = "crouch";
		self.anim_idleSet = "b";
		self.anim_special = "cover_crouch";
		self.anim_movement = "stop";
	}
	else
		self SetPoseMovement("crouch","stop");
}

shouldTakeCover_axis(firedSuppressionClip, gotBoredAmbushing)
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

shouldTakeCoverConceal_axis()
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

	return (forcedCover("hide"));
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
	Set3FlaggedAnimKnobsRestart("animdone", "one_shot", 1, 0, 1);//weight, blendTime, rate)
//	self setAnimKnob(%shoot, 1, 0.1, 1);
//	self setFlaggedAnimKnobRestart("animdone", %stand_shoot, 1, 0, 1);
//	self setFlaggedAnimKnobRestart("animdone", %stand_shoot_straight, 1, 0, 1);
}

AutofireCrouch()
{
	self.enemy endon ("death");
	self endon ("enemy");
	animRate = animscripts\weaponList::autoShootAnimRate();

	maps\_gameskill::resetAccuracyAndPause();
	pauseIfPlayerIsInvulAndYouAreAPauseGuy();

	Set3FlaggedAnimKnobs("animdone", "auto", 1, 0.15, 1);//weight, blendTime, rate)

	oldAmmo = self.bulletsinClip;

	AutoFire();

	// no recoil if we're gettin back in cover fast
	if (isSuppressedWrapper())
		return;

	if (self.bulletsinClip != oldAmmo)
	{
		Set3FlaggedAnimKnobs("animdone", "auto_end", 1, 0.05, 1);//weight, blendTime, rate)
		wait 0.3;
	}
}

AutofireCrouch_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");

	animRate = animscripts\weaponList::autoShootAnimRate();
	Set3FlaggedAnimKnobs("animdone", "auto", 1, 0.15, 1);//weight, blendTime, rate)

	oldAmmo = self.bulletsinClip;
	shootBurst(suppressSpot);

	if (self.bulletsinClip != oldAmmo)
	{
		Set3FlaggedAnimKnobs("animdone", "auto_end", 1, 0.05, 1);//weight, blendTime, rate)
		self waittillmatch ("animdone","end");
	}
		
	Set3FlaggedAnimKnobs("none", "aim", 1, 0.15, 1);//weight, blendTime, rate)
	
	burstDelay();
}

SemiAutofireCrouch()
{
	self.enemy endon ("death");
	self endon ("enemy");

	animRate = animscripts\weaponList::autoShootAnimRate();

	SemiAutoFire();
}

SemiAutofireCrouch_Suppress(suppressSpot)
{
	self.enemy endon ("death");
	self endon ("enemy");

	animRate = animscripts\weaponList::autoShootAnimRate();

	shootSemiAutoBurst(suppressSpot);
		
	burstDelay();
}

tryThrowingGrenade()
{
	// Blend out the aiming animation
	self notify ("stop_aiming");
	self clearAnim(%crouch_directions, 0.2);
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	threwGrenade = TryGrenadePos( getEnemySightPos() );
	if (threwGrenade)
		delayedCoverBlend();
	self clearAnim(%stand_and_crouch, 0.2);
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}

WaitForAmbush(duration )
{
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
		if (self isSuppressedWrapper())
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
		if (TryGrenadePos( getEnemySightPos() + randomVec(10)))
			delayedCoverBlend();
		self clearAnim(%stand_and_crouch, 0.2);
		self.keepClaimedNodeInGoal = false;
	}
		
	Reload( 0.9, %crouch_cover_reload );
	
	thread loopingHideIdle();
	while (isSuppressedWrapper())
		wait (0.2);
	wait (randomfloat(1));
	self.suppressed = false;
	self notify ("stop_idling");
	self clearAnim(%stand_and_crouch, 0.2); 
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
	self clearAnim(%stand_and_crouch, 0.2);
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

stopAiming(blendTime)
{
	self notify ("stop_aiming");

	if (self.anim_pose == "stand")
	{
		self setflaggedanimknob ("standup", %crouch_cover_aim_dn_straight2aim_straight, 1, 0.3, 1);
		wait (0.4);
		self.anim_pose = "crouch";
		self.anim_special = "cover_crouch";
	}
	else
	{
		self clearAnim(%crouch_directions, blendTime);
		// so we cant basepose:
		self setflaggedanimknob ("crouchdown", %crouch_cover_aim2hideLowWallb, 1, 0.2, 1);
	}
	self OrientMode( "face angle", self.coverNode.angles[1] );
}

takeCover()
{
	stopAiming(0.2);
	if (isSuppressedWrapper())
		rate = 1.5;
	else
		rate = 1;
	self setflaggedanimknob ("crouchdown", %crouch_cover_aim2hideLowWallb, 1, 0.2, rate);
	self waittillmatch ("crouchdown", "end");
	self.anim_pose = "crouch";
	
	self.anim_idleSet = "b";
	self.anim_special = "cover_crouch";
}

leaveCoverAndAim()
{
	if (isalive(self.enemy))
		self OrientMode( "face enemy" );
	else
	if (self canSuppressEnemyFromExposed())
	{
		spot = getEnemySightPos();

		myYawFromTarget = VectorToAngles(spot - self.origin );
		self OrientMode( "face angle", myYawFromTarget[1] );
	}
	
	self setflaggedanimknob ("leaveCover", %crouch_cover_hideLowWallb2aim, 1, 0.2, 1);
	self waittillmatch ("leaveCover","end");
//	wait (0.4);
//	wait (0.45);
//	self.anim_special = "none";
//	self.anim_pose = "stand";
//	self setanimknob (%shoot, 1, 0.25, 1);
//	self setanimknob (%stand_aim, 1, 0.25, 1);
	if (isalive(self.enemy))
	{
		if (self canSeeEnemyFromExposed())
			AimAtEnemy();
		else
		if (self canSuppressEnemyFromExposed())
			aimAtSpot(getEnemySightPos());
		else
			aimStraightAhead();
	}
	else
		aimStraightAhead();
	Set3FlaggedAnimKnobs("none", "aim", 1, 0.25, 1);//weight, blendTime, rate)
	
	wait (0.25);
	wait (0.3);
	
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
			aimAtEnemy();
			if (!isalive(self.enemy))
				break;

			// Shoot and rechamber
			shootTime = animscripts\weaponList::shootAnimTime();
			self maps\_gameSkill::shootBolt();
			semiAutoAnim_fire(); // fire one single shot
			self.bulletsInClip --;
			self.anim_needsToRechamber = true;


			if (self.bulletsInClip)
			{
				wait animscripts\weaponList::waitAfterShot();
				if (issuppressedWrapper())
					break;
//				self clearAnim(%stand_shoot, 0.1);
//				self clearAnim(%stand_aim, 0.1);
//				rechamber();

				if (self.animArray["leaning_over_wall"])
				{
					Set3FlaggedAnimKnobs("animdone", "rechamber", 1, 0.05, 1);//weight, blendTime, rate)
					self waittillmatch ("animdone","end");
					Set3FlaggedAnimKnobs("animdone", "aim", 1, 0.05, 1);//weight, blendTime, rate)
				}
				else
				{
					Set3FlaggedAnimKnobs("animdone", "rechamber", 1, 0.25, 1);//weight, blendTime, rate)
					wait (1.25);
					Set3FlaggedAnimKnobs("animdone", "aim", 1, 0.3, 1);//weight, blendTime, rate)
				}
				
				self.anim_needsToRechamber = false;
//				self clearAnim(%stand_rechamber, 0.3);
//				self setanimknob (%stand_aim, 1, 0.1, 1);
				if (!isalive(self.enemy))
					self aimAtPos ((0,0,0));

				if (self.bulletsInClip)
					wait (0.1);

				if (!self.animArray["leaning_over_wall"])
					wait (0.2);
			}
			else
			{
				wait (0.3);
			}			
		}
		else
		{
			thread maps\_gameSkill::resetAccuracyBolt();
			if (canSuppressEnemy() && self.bulletsInClip / getAIWeapon(self.weapon)["clipsize"] >= 0.5)
			{
				suppressSpot = getEnemySightPos();
				if (!tryThrowingGrenade())
	        		tryReacquire();
				aimAtSpot(suppressSpot);
				if (!isalive(self.enemy))
					break;
				WaitForAmbush(5);
				if (self isSuppressedWrapper())
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

waitForEnemyProc_bolt()
{
	if (!isalive(self.enemy))	
		return false;
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

waitForEnemy_bolt(suppressSpot)
{
	aimAtSpot( suppressSpot );
	return waitForEnemyProc_bolt();
}

waitForEnemyStraightAhead_bolt()
{
	aimStraightAhead();
	return waitForEnemyProc_bolt();
}

waitForEnemyProc_auto()
{
	if (!isalive(self.enemy))	
		return false;
		
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

waitForEnemy_auto(suppressSpot)
{
	aimAtSpot( suppressSpot );
	
	return waitForEnemyProc_auto();
}

waitForEnemyAimStraight_auto()
{
	aimStraightAhead();
	
	return waitForEnemyProc_auto();
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
			aimAtEnemy();
			if (!isalive(self.enemy))
				break;

			if (self.enemy == level.player)
			{
				// Firing animation
				[[self.autoFire]]();
			}
			else
				fireBurstsAtEnemy();
		}
		else
		{
			if (canSuppressEnemy())
			{
				suppressSpot = getEnemySightPos();
				if (!tryThrowingGrenade())
		       		tryReacquire();
				aimAtSpot(suppressSpot);
				if (!isalive(self.enemy))
					break;
	
				// Otherwise fire suppression bursts until the clip is dry
				fireSuppressionBursts_UntilEnemyIsVisible(suppressSpot, suppressableTime);
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
	aimAtSpot( suppressSpot );

	while (self.bulletsInClip>0 && isalive(self.enemy))
	{
		if (gettime() > suppressableTime && isSuppressedWrapper())
			break;
			
		[[self.autoFireSuppress]](suppressSpot);
		if (!isalive (self.enemy) || self canSee(self.enemy))
			break;
	}
}

fireBurstsAtEnemy()
{
	self.enemy endon ("death");
	self endon ("enemy");
	aimAtSpot( self.enemy GetEye() );
	while (self.bulletsInClip > 0)
	{
		[[self.autoFireSuppress]](self.enemy GetEye());
		if (!self canSee(self.enemy))
			break;
	}
}

aimStraightAhead()
{
	forward = anglesToForward(self.angles);
	forward = vector_scale(forward, 100);
	spot = self.origin + forward + (0,0,43);
	aimAtSpot(spot);
}


delayedCoverBlend()
{
	// because otherwise cover comes in with a weight of 1 after a grenade throw
	waittillframeend;
	self setanim(%cover, 0, 0, 1);
	self setanim(%cover, 1, 0.2, 1);
}

getTargetAngleOffsetFromOriginOffset(target)
{
	pos = self.origin + (0,0,40);
	dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
	dir = VectorNormalize( dir );
	fact = dir[2] * -1;
//	println ("offset "  + fact);
	return fact;
}

idleWhileIHaveNoEnemy_crouch()
{
	idleWhileIHaveNoEnemy();
	self clearAnim(%stand_and_crouch, 0.2); 
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

