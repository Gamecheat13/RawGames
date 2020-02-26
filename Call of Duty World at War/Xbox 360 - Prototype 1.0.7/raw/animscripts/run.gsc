#include animscripts\Utility;
#include animscripts\Combat_Utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

MoveRun()
{
	// Shoot at my enemy:
	// if I have bullets in my gun, and
	// if I am not running from a grenade (easy and medium only, enemies only) and
	// if I'm facing my enemy and I can hit him from here.
	
	shootWhileRunning = false;
	suppression = false;
	// Decide what pose to use 
	if (self.a.pose == "prone")
	{
		preferredPose = "crouch";
	}
	else if ( (self.a.pose == "crouch") && (randomInt(100) > 90) )
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
		preferredPose = self.a.pose;
	}
	if (self isStanceAllowed("stand"))
		preferredPose = "stand";
		
	desiredPose = self animscripts\utility::choosePose(preferredPose);
	
	// If I'm allowed to shoot while running, do that.  Otherwise run normally.
	//if ( shootWhileRunning && ( (desiredPose == "stand") || (desiredPose == "crouch") ) )
	/*
	usingMultiShotWeapon =  animscripts\weaponList::usingAutomaticWeapon() || animscripts\weaponList::usingSemiAutoWeapon();
	if ( usingMultiShotWeapon && ( desiredPose == "stand" || desiredPose == "crouch" ))

	{
		//if (suppression)
		//return MoveRunSuppression(desiredPose);
		//else
		return MoveRunShoot(desiredPose);
	}
	else
	*/
	
	MoveRunNonShoot(desiredPose);
}

UpdateRunShootWeights(animName, notifyString)
{
	// Play the appropriately weighted run animations for the direction he's moving
	if (self.a.pose == "stand")
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
MoveRunShoot(desiredPose, suppression)
{
	switch (desiredPose)
	{
	case "stand":
		if ( BeginStandRun() )
			return;
		break;
		
	default:
		assert(desiredPose == "crouch");
		if ( BeginCrouchRun() )
			return;
		break;
	}

	RunShoot();
}
*/

/*
MoveRunSuppression(desiredPose, suppression)
{
	switch (desiredPose)
	{
	case "stand":
		if ( BeginStandRun() )
			return;
		break;
		
	default:
		assert(desiredPose == "crouch");
		if ( BeginCrouchRun() )
			return;
		break;
	}
	
	RunSuppress();
}
*/

MoveStandRun()
{
	if ( BeginStandRun() ) // returns false (and does nothing) if we're already stand-running
		return;
	
	if ( self animscripts\utility::IsInCombat() )
		return MoveStandRunCombat();
	else
		return MoveStandRunNoncombat();
}

MoveCrouchRun()
{
	if ( BeginCrouchRun() ) // returns false (and does nothing) if we're already crouch-running
		return;
	
	if ( isDefined( self.crouchrun_combatanim ) )
		MoveCrouchRunOverride();
	else
		MoveCrouchRunNormal();
}

MoveProneRun()
{
	if ( BeginProneRun() ) // returns false (and does nothing) if we're already prone-running
		return;
	
	ProneCrawl();
}

ProneCrawl()
{
	self.a.movement = "run";
	self setflaggedanimknob("runanim",%prone_crawl, 1, .3, 1);
	animscripts\shared::DoNoteTracksForTime(0.25, "runanim");
}

RunAim()
{
	animscripts\face::SetIdleFace(anim.aimface);
	UpdateRunShootWeights("runanim", "stopRunning");
	animscripts\shared::DoNoteTracksForTime(0.25, "runanim");
	self.a.alertness = "aiming";
	self.a.movement = "run";
	self notify("stopRunning");
}

MoveRunNonShoot(desiredPose)
{
	switch (desiredPose)
	{
	case "stand":
		MoveStandRun();
		break;
		
		// reenebled crouch run
	case "crouch":
		MoveCrouchRun();
		break;

	default:
		assert(desiredPose == "prone");
		MoveProneRun();
		break;
	}
}


DoNoteTracksNoShootStandCombat(animName)
{
	animscripts\shared::DoNoteTracksForTime(0.2, animName);	
}

MoveStandRunCombat()
{
	// If the ld has specified a run animation, use that exclusively.
	if ( isDefined( self.run_combatanim ) )
		MoveStandCombatOverride();
	else
		MoveStandCombatNormal();
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
	self setanim(%stand_and_crouch,1,1);
	self setanim(%walk_and_run_loops,1,1);
	self setanimknob(%combatrun, 0.1, 0.5, 1);
//	self setanimknoball(%combatrun, %body, 0.1, 0.5, self.animplaybackrate);

	if (isdefined(self.grenade))
		self setflaggedanimknob("runanim", self.a.grenadeflee, 1, 0.3);
	else
		self setflaggedanimknob("runanim", self.a.combatrunanim, 1, 0.5);

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

MoveStandRunNoncombat()
{
	// Play the appropriately weighted run animations for the direction he's moving
	if ( isDefined( self.run_noncombatanim ) )
		MoveStandNoncombatOverride();
	else
		MoveStandNoncombatNormal();
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

	prerunAnim = undefined;
	if (self.preCombatRunEnabled)
	{
		prerunAnim = %precombatrun1;
		if (weaponAnims() == "pistol")
			prerunAnim = %combat_run_fast_pistol; // replace this with a pistol run when we get one
	}
	else
		prerunAnim = self.a.combatrunanim;
	
	
	// changed it back to 0.3 because it pops when the AI goes from combat to noncombat
	self setflaggedanimknob("runanim", prerunAnim, 1, 0.3); // was 0.3

	// Play the appropriately weighted animations for the direction he's moving.
	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
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
	self setanimknob(self.a.crouchrunanim, 1, 0.4);

	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
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
		animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
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

