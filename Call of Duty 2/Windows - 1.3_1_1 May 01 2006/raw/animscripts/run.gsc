#include animscripts\Utility;
#include animscripts\Combat_Utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

MoveRun_handler()
{
	// Shoot at my enemy:
	// if I have bullets in my gun, and
	// if I am not running from a grenade (easy and medium only, enemies only) and
	// if I don't have a panzerfaust or pistol, and
	// if I'm facing my enemy and I can hit him from here.
	/*
	shootWhileRunning =	(!animscripts\combat::NeedsToReload(0.1)) &&
						( !isDefined(self.grenade) || 
						!(GetDifficulty()=="easy" || GetDifficulty()=="medium") || self.team=="allies" ) &&
						(self animscripts\utility::weaponAnims() != "panzerfaust") &&
						(self animscripts\utility::weaponAnims() != "pistol") &&
						(animscripts\utility::AbsYawToEnemy()<25) && 
						(animscripts\utility::canShootEnemy());
	*/						
	
	shootWhileRunning = false;
	suppression = false;
	if ((self animscripts\utility::weaponAnims() != "panzerfaust") &&
		(self animscripts\utility::weaponAnims() != "pistol"))
	{
	/*
		if ((animscripts\utility::AbsYawToEnemy()<25) && (animscripts\utility::canShootEnemy()))
			shootWhileRunning = true;
		else
		if (hasEnemySightPos())
//			&& (canShootLastEnemyPos()))
		{
//			sightPos = 
//			if( animscripts\utility::AbsYawToOrigin(getEnemySightPos() < 45))
			shootWhileRunning = true;
			suppression = true;
			myYawFromTarget = VectorToAngles(getEnemySightPos() - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1] );
		}
		*/
	}
	
	// Decide what pose to use 
	if (self.anim_pose == "prone")
	{
		preferredPose = "crouch";
	}
	else if ( (self.anim_pose == "crouch") && (randomInt(100) > 90) )
	{
		preferredPose = "stand";
	}
	else if (shootWhileRunning)
	{
		// If I'm going to shoot while running I want to be standing.  
		preferredPose = "stand";
	}
	else
	{
		preferredPose = self.anim_pose;
	}
	if (self isStanceAllowed("stand"))
		preferredPose = "stand";
		
	desiredPose = self animscripts\utility::choosePose(preferredPose);
	
	// If I'm allowed to shoot while running, do that.  Otherwise run normally.
//	if ( shootWhileRunning && ( (desiredPose == "stand") || (desiredPose == "crouch") ) )
	/*
	usingMultiShotWeapon =  animscripts\weaponList::usingAutomaticWeapon() || animscripts\weaponList::usingSemiAutoWeapon();
	if ( usingMultiShotWeapon && ( desiredPose == "stand" || desiredPose == "crouch" ))

	{
//		if (suppression)
//		return MoveRunSuppression_handler(desiredPose);
//		else
		return MoveRunShoot_handler(desiredPose);
	}
	else
	*/
	return MoveRunNonShoot_handler(desiredPose);
}

UpdateRunShootWeights(animName, notifyString)
{
	// Play the appropriately weighted run animations for the direction he's moving
	if (self.anim_pose == "stand")
	{
		self thread UpdateRunWeights(	notifyString, 
										%stand_shoot_run_forward, 
										%stand_shoot_run_back, 
										%stand_shoot_run_left,
										%stand_shoot_run_right
										);

		self setflaggedanimknoball(animName, %stand_shoot_run, %body, 1, 0.2);
	}
	else
	{
		self thread UpdateRunWeights(	notifyString, 
										%crouch_shoot_run_forward, 
										%crouch_shoot_run_back, 
										%crouch_shoot_run_left,
										%crouch_shoot_run_right
										);

		self setflaggedanimknoball(animName, %crouch_shoot_run, %body, 1, 0.2);
	}
}

/*
MoveRunShoot_handler(desiredPose, suppression)
{
	switch (desiredPose)
	{
	case "stand":
		handler = StandRun_handler();
		break;
		
	default:
		assert(desiredPose == "crouch");
		handler = CrouchRun_handler();
		break;
	}

	if (isdefined(handler))
		return handler;

//	if ( self.anim_alertness == "casual" )
//		return ::RunAim;

	return ::RunShoot;
}
*/

/*
MoveRunSuppression_handler(desiredPose, suppression)
{
	switch (desiredPose)
	{
	case "stand":
		handler = StandRun_handler();
		break;
		
	default:
		assert(desiredPose == "crouch");
		handler = CrouchRun_handler();
		break;
	}

	if (isdefined(handler))
		return handler;

//	if ( self.anim_alertness == "casual" )
//		return ::RunAim;

	return ::RunSuppress;
}
*/

MoveStandRun_handler()
{
	handler = StandRun_handler();
	if (isdefined(handler))
		return handler;
	
	if ( self animscripts\utility::IsInCombat() )
		return MoveStandRunCombat_handler();
	else
		return MoveStandRunNoncombat_handler();
}

MoveCrouchRun_handler()
{
	handler = CrouchRun_handler();
	if (isdefined(handler))
		return handler;
	
	if (isDefined(self.crouchrun_combatanim))
		return ::MoveCrouchRunOverride;
	else
		return ::MoveCrouchRunNormal;
}

ProneCrawl()
{
	self.anim_movement = "run";
	self setflaggedanimknob("runanim",%prone_crawl, 1, .3, 1);
	animscripts\shared::DoNoteTracksForTime(0.25, "runanim");
}

MoveProneRun_handler()
{
	handler = ProneRun_handler();
	if (isdefined(handler))
		return handler;
	
	return ::ProneCrawl;
}

RunAim()
{
	animscripts\face::SetIdleFace(anim.aimface);
	UpdateRunShootWeights("runanim", "stopRunning");
	animscripts\shared::DoNoteTracksForTime(0.25, "runanim");
	self.anim_alertness = "aiming";
	self.anim_movement = "run";
	self notify("stopRunning");
}

/*
RunShoot()
{
	assert(false);
	animscripts\face::SetIdleFace(anim.autofireface);
	UpdateRunShootWeights("runanim", "stopRunning");
	thread animscripts\shared::DoNoteTracksForever("runanim", "stopRunning");
	if (!self.anim_suppressingEnemy)
		animscripts\combat::ShootRunningVolley();

	desiredPose = self animscripts\utility::choosePose(self.anim_pose);
	if (desiredPose == self.anim_pose)
		wait 0.25;	// Space out volleys, mainly because it makes the game sound cooler.

	self notify("stopRunning");
}

RunSuppress()
{
	animscripts\face::SetIdleFace(anim.autofireface);
	UpdateRunShootWeights("runanim", "stopRunning");
	thread animscripts\shared::DoNoteTracksForever("runanim", "stopRunning");
	if (!self.anim_suppressingEnemy)
		animscripts\combat::ShootRunningSuppressionVolley();

	desiredPose = self animscripts\utility::choosePose(self.anim_pose);
	if (desiredPose == self.anim_pose)
		wait 0.25;	// Space out volleys, mainly because it makes the game sound cooler.

	self notify("stopRunning");
}
*/

MoveRunNonShoot_handler(desiredPose)
{
	switch (desiredPose)
	{
	case "stand":
		return MoveStandRun_handler();
		// reenebled crouch run
	case "crouch":
		return MoveCrouchRun_handler();

	default:
		assert(desiredPose == "prone");
		return MoveProneRun_handler();
	}
}

MoveStandWounded(animName)
{
	if (GetTime() < self.anim_woundedTime)
	{
		if (self.anim_lastWound == "left")
			self setflaggedanimknob(animName, %wounded_leftleg_run_forward, 1, 0.3);
		else if (self.anim_lastWound == "right")
			self setflaggedanimknob(animName, %wounded_rightleg_run_forward, 1, 0.3);
		else
			self setflaggedanimknob(animName, %wounded_run_forward1, 1, 0.3);
	}
	else
	{
		if (self.anim_woundedBias > 0.5)
		{
			self.currentLimpAnim = chooseAnim(self.currentLimpAnim, 0.8,	%wounded_leftleg_run_forward, .1, 
																			%wounded_run_forward1, .05, 
																			%wounded_run_forward2, .05);
		}
		else if (self.anim_woundedBias < -0.5)
		{
			self.currentLimpAnim = chooseAnim(self.currentLimpAnim, 0.8,	%wounded_rightleg_run_forward, .1, 
																			%wounded_run_forward1, .05, 
																			%wounded_run_forward2, .05);
		}
		else
		{
			self.currentLimpAnim = chooseAnim(self.currentLimpAnim, 0.8,	%wounded_leftleg_run_forward, .04, 
																			%wounded_run_forward1, .08, 
																			%wounded_run_forward2, .08);
		}

		self setflaggedanimknob (animName, self.currentLimpAnim, 1, 0.3);
	}
}

DoNoteTracksNoShootStandCombat(animName)
{
	if (NeedsToReload(0.1))
	{
		self thread animscripts\shared::DoNoteTracksForever(animName, "end runanim");	
		Reload(0.1);
		self notify("end runanim");
	}
	else
	{
		animscripts\shared::DoNoteTracksForTime(0.2, animName);	
	}
}

MoveStandRunCombat_handler()
{
	// If the ld has specified a run animation, use that exclusively.
	if (isDefined(self.run_combatanim))
		return ::MoveStandCombatOverride;
	else
		return ::MoveStandCombatNormal;
}

MoveStandCombatOverride()
{
	self clearanim(%combatrun, 0.6);
	self setanimknoball(%combatrun, %body, 1, 0.5, self.animplaybackrate);
	self setflaggedanimknob("runanim", self.run_combatanim, 1, 0.5);
	DoNoteTracksNoShootStandCombat("runanim");
}

MoveStandCombatNormal()
{
	self clearanim(%combatrun, 0.6);

	// If we're going to reload, use a lower weight on the run animation so the upper-body reload plays more strongly.
	// Otherwise the weight will get normalized to 1.
	
	// AI run with animplaybackrate 1 so the animation doesnt look goofy. We'll get more animations.
	self setanimknoball(%combatrun, %body, 0.1, 0.5, 1);
//	self setanimknoball(%combatrun, %body, 0.1, 0.5, self.animplaybackrate);

	// If we're wounded, play a wounded run animation, otherwise play the run for our character.
	// Limp if you're more than 1/2 wounded.
	if ( (GetTime() < self.anim_woundedTime) || (self.anim_woundedAmount > 0.5) )
		MoveStandWounded("runanim");
	else
	{
		if (isdefined(self.grenade))
			self setflaggedanimknob("runanim", self.anim_grenadeflee, 1, 0.3);
		else
			self setflaggedanimknob("runanim", self.anim_combatrunanim, 1, 0.5);
	}

	// Play the appropriately weighted run animations for the direction he's moving
	self thread UpdateRunWeights(	"stopRunning", 
									%combatrun_forward,
									%combatrun_back, 
									%combatrun_left,
									%combatrun_right
									);
	DoNoteTracksNoShootStandCombat("runanim");

	self notify("stopRunning");
}

MoveStandRunNoncombat_handler()
{
	// Play the appropriately weighted run animations for the direction he's moving
	if (isDefined(self.run_noncombatanim))
		return ::MoveStandNoncombatOverride;
	else
		return ::MoveStandNoncombatNormal;
}

MoveStandNoncombatOverride()
{
	self endon("movemode");

	self clearanim(%combatrun, 0.6);
	self setflaggedanimknoball("runanim", self.run_noncombatanim, %body, 1, 0.3);
	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveStandNoncombatNormal()
{
	self endon("movemode");

	self clearanim(%combatrun, 0.6);
	
	self setanimknoball(%combatrun, %body, 1, 0.2, self.animplaybackrate);

	// If we're wounded, play a wounded run animation, otherwise play the run for our character.
	// Limp if you're more than 1/2 wounded.
	if ( (GetTime() < self.anim_woundedTime) || (self.anim_woundedAmount > 0.5) )
		MoveStandWounded("runanim");
	else
	{
		prerunAnim = undefined;
		if (self.preCombatRunEnabled)
		{
			prerunAnim = %precombatrun1;
			if (weaponAnims() == "pistol")
				prerunAnim = %combat_run_fast_pistol; // replace this with a pistol run when we get one
		}
		else
			prerunAnim = self.anim_combatrunanim;
		
		
		// changed it back to 0.3 because it pops when the AI goes from combat to noncombat
		self setflaggedanimknob("runanim", prerunAnim, 1, 0.3); // was 0.3
	}

	// Play the appropriately weighted animations for the direction he's moving.
	animWeights = animscripts\utility::QuadrantAnimWeights(self getMotionAngle()+180);
	self setanim(%combatrun_forward, animWeights["front"], 0.2, 1);
	self setanim(%combatrun_back, animWeights["back"], 0.2, 1);
	self setanim(%combatrun_left, animWeights["left"], 0.2, 1);
	self setanim(%combatrun_right, animWeights["right"], 0.2, 1);

	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveCrouchRunOverride()
{
	self endon("movemode");

	self setflaggedanimknoball("runanim", self.crouchrun_combatanim, %body, 1, 0.4, self.animplaybackrate);
	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveCrouchRunNormal()
{
	self endon("movemode");

	// Play the appropriately weighted crouchrun animations for the direction he's moving
	self setanimknob(self.anim_crouchrunanim, 1, 0.4);

	animWeights = animscripts\utility::QuadrantAnimWeights(self getMotionAngle()+180);
	self setanim(%crouchrun_loop_forward, animWeights["front"], 0.2, 1);
	self setanim(%crouchrun_loop_back, animWeights["back"], 0.2, 1);
	self setanim(%crouchrun_loop_left, animWeights["left"], 0.2, 1);
	self setanim(%crouchrun_loop_right, animWeights["right"], 0.2, 1);

	self setflaggedanimknoball("runanim", %crouchrun, %body, 1, 0.2, self.animplaybackrate);

	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

// Chooses an animation, from a list of options.  Uses "currentAnim" only if it's in the list of options (in 
// which case it has two chances of being chosen). probabilityCurrent is used as-is (if it's used at all).  
// The other probabilities are normalized to take the total to 1.
chooseAnim(currentAnim, probabilityCurrent, option1, probability1, option2, probability2, option3, probability3)
{
	// Find out which options are defined
	numOptions=0;
	realOption = undefined;
	realProbability = undefined;
	if (isDefined(option1))
	{
		realOption[numOptions] = option1;
		realProbability[numOptions] = probability1;
		numOptions++;
	}
	if (isDefined(option2))
	{
		realOption[numOptions] = option2;
		realProbability[numOptions] = probability2;
		numOptions++;
	}
	if (isDefined(option3))
	{
		realOption[numOptions] = option3;
		realProbability[numOptions] = probability3;
		numOptions++;
	}
	// Find out if the current animation is a valid option
	currentIsAnOption = false;
	if (isDefined(currentAnim))
	{
		for (i=0 ; i<numOptions ; i++)
		{
			if (realOption[i] == currentAnim)
			{
				currentIsAnOption = true;
				break;
			}
		}
	}
	if (!currentIsAnOption)
		probabilityCurrent = 0;

	// Decide whether or not to stick with the current animation
	rand = randomfloat(1);
	if (rand < probabilityCurrent)
		choice = currentAnim;
	else
	{
		// Normalize the other options' probabilities
		totalProb = 0;
		for (i=0 ; i<numOptions ; i++)
		{
			totalProb += realProbability[i];
		}
		for (i=0 ; i<numOptions ; i++)
		{
			realProbability[i] /= totalProb;
		}
		
		// Decide which of the other options we want
		rand = randomfloat(1);
		totalProb = 0;
		choice = undefined;
		for (i=0 ; i<numOptions ; i++)
		{
			totalProb += realProbability[i];
			if (totalProb > rand)
			{
				choice = realOption[i];
				break;
			}
		}
	}
	// We can assume that a choice was made.
	assertEX(isDefined(choice));

	return choice;
}


UpdateRunWeights(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
	if ( isdefined(self.cliffDeath) && (self.cliffDeath == true) )
		return;
	self endon("killanimscript");
	self endon(notifyString);

	for (;;)
	{
		animWeights = animscripts\utility::QuadrantAnimWeights (self getMotionAngle()+180);
		self setanim(frontAnim, animWeights["front"], 0.2, 1);
		self setanim(backAnim, animWeights["back"], 0.2, 1);
		self setanim(leftAnim, animWeights["left"], 0.2, 1);
		self setanim(rightAnim, animWeights["right"], 0.2, 1);
		wait 0.2;
	}
}

// TODO Make this use the notetrack from the run animation playing.
MakeRunSounds ( notifyString )
{
	self endon("killanimscript");
	self endon(notifyString);
	for (;;)
	{
		wait .5;
		self playsound ("misc_step1");
		wait .5;
		self playsound ("misc_step2");
	}
}

InfiniteMoveStandCombatOverride()
{
	self endon ("killanimscript");
	for (;;)
		MoveStandCombatOverride();
}