//================================================================================
// SetPoseMovement - Sets the pose (stand, crouch, prone) and movement (run, walk, 
// crawl, stop) to the specified values.  Accounts for all possible starting poses 
// and movements.
//================================================================================

#include animscripts\Utility;
#using_animtree ("generic_human");


SetPoseMovement(desiredPose, desiredMovement)
{
	assertex(self.anim_pose != "wounded", "SetPoseMovement doesn't handle wounded.  Error in calling script.");

	// Scripts can pass empty strings, meaning they don't want to change that aspect of the state.
	if (desiredPose=="")
	{
		if ( (self.anim_pose=="prone") && ((desiredMovement=="walk")||(desiredMovement=="run")) )
			desiredPose = "crouch";
		else
			desiredPose = self.anim_pose;
	}
	if (!IsDefined(desiredMovement) || desiredMovement=="")
	{
		desiredMovement = self.anim_movement;
	}


	// Now call the function.
	[[anim.SetPoseMovementFnArray[desiredPose][desiredMovement]]]();
}


InitPoseMovementFunctions()
{
	// Make an array of movement and pose changing functions.  
	// Indices are: "desired movement", "desired pose"
	anim.SetPoseMovementFnArray["stand"]["stop"] =	::StandStop;
	anim.SetPoseMovementFnArray["stand"]["walk"] =	::StandWalk;
	anim.SetPoseMovementFnArray["stand"]["run"] =	::StandRun;

	anim.SetPoseMovementFnArray["crouch"]["stop"] =	::CrouchStop;
	anim.SetPoseMovementFnArray["crouch"]["walk"] =	::CrouchWalk;
	anim.SetPoseMovementFnArray["crouch"]["run"] =	::CrouchRun;

	anim.SetPoseMovementFnArray["prone"]["stop"] =	::ProneStop;
	anim.SetPoseMovementFnArray["prone"]["walk"] =	::ProneWalk;
	anim.SetPoseMovementFnArray["prone"]["run"] =	::ProneRun;
}


//--------------------------------------------------------------------------------
// Standing poses
//--------------------------------------------------------------------------------

StandStop_handler()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			return undefined;

		case "walk":
			return ::StandWalkToStand;

		default:
			assert(self.anim_movement == "run");
			return ::StandRunToStand;
		}

	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			return ::CrouchToStand;

		case "walk":
			return ::CrouchWalkToStand;

		default:
			assert(self.anim_movement == "run");
			return ::CrouchRunToStand;
		}

	default:
		assert(self.anim_pose == "prone");
		switch (self.anim_movement)
		{
		case "stop":
			return ::ProneToStand;

		default:
			assert(self.anim_movement == "walk" || self.anim_movement == "run");
			return ::ProneToStand;	// Do I need to stop crawling first?  Hope not.
		}
	}
}

StandStop()
{
	handler = StandStop_handler();
	if (isdefined(handler))
		[[handler]]();
}

StandWalk_handler()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			return ::StandToStandWalk;

		case "walk":
			return undefined;

		default:
			assert(self.anim_movement == "run");
			return ::BlendIntoStandWalk;
		}

	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			return ::CrouchToStandWalk;

		case "walk":
			return ::BlendIntoStandWalk;

		default:
			assert(self.anim_movement == "run");
			return ::BlendIntoStandWalk;
		}

	default:
		assert(self.anim_pose == "prone");
		return ::ProneToStandWalk;
	}
}

StandWalk()
{
	handler = StandWalk_handler();
	if (isdefined(handler))
		[[handler]]();
}

StandRun_handler()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			return ::StandToStandRun;

		case "walk":
			return ::BlendIntoStandRun;

		default:
			assert(self.anim_movement == "run");
			return undefined;
		}

	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			return ::CrouchToStandRun;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return ::BlendIntoStandRun;
		}

	default:
		assert(self.anim_pose == "prone");
		return ::ProneToStandRun;
	}
}

StandRun()
{
	handler = StandRun_handler();
	if (isdefined(handler))
		[[handler]]();
}

//--------------------------------------------------------------------------------
// Crouching functions
//--------------------------------------------------------------------------------
CrouchStop()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToCrouch();
			break;
		case "walk":
			StandWalkToCrouch();
			break;
		case "run":
			StandRunToCrouch();
			break;
		default:
			assertEX(0, "SetPoseMovement::CrouchStop "+self.anim_pose+" "+self.anim_movement);
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			// Do nothing
			break;
		case "walk":
			CrouchWalkToCrouch();
			break;
		case "run":
			CrouchRunToCrouch();
			break;
		default:
			assertEX(0, "SetPoseMovement::CrouchStop "+self.anim_pose+" "+self.anim_movement);
		}
		break;
	case "prone":
		ProneToCrouch();
		break;
	default:
		assertEX(0, "SetPoseMovement::CrouchStop "+self.anim_pose+" "+self.anim_movement);
	}
}

CrouchWalk_handler()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			return ::StandToCrouchWalk;

		case "walk":
			return ::BlendIntoCrouchWalk;

		default:
			assert(self.anim_movement == "run");
			return ::BlendIntoCrouchWalk;
		}

	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			return ::CrouchToCrouchWalk;
			
		case "walk":
			return undefined;

		default:
			assert(self.anim_movement == "run");
			return ::BlendIntoCrouchWalk;
		}
		break;

	default:
		assert(self.anim_pose == "prone");
		// Let's try going straight to the run and then blending back to see what it looks like.
		return ::ProneToCrouchWalk;
	}
}

CrouchWalk()
{
	handler = CrouchWalk_handler();
	if (isdefined(handler))
		[[handler]]();
}

CrouchRun_handler()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			return ::StandToCrouchRun;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return ::BlendIntoCrouchRun;
		}

	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			return ::CrouchToCrouchRun;

		case "walk":
			return ::BlendIntoCrouchRun;

		default:
			assert(self.anim_movement == "run");
			return undefined;
		}

	default:
		assert(self.anim_pose == "prone");
		return ::ProneToCrouchRun;
	}
}

CrouchRun()
{
	handler = CrouchRun_handler();
	if (isdefined(handler))
		[[handler]]();
}

//--------------------------------------------------------------------------------
// Prone Functions
//--------------------------------------------------------------------------------

ProneStop()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToProne();
			break;
		case "walk":
			StandToProne();
			break;
		case "run":
			CrouchRunToProne();
			break;
		default:
			assertEX(0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToProne();	
			break;
		case "walk":
			CrouchToProne();
			break;
		case "run":
			CrouchRunToProne();
			break;
		default:
			assertEX(0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);
		}
		break;
	case "prone":
		switch (self.anim_movement)
		{
		case "stop":
			// Do nothing
			break;
		case "walk":
		case "run":
			ProneCrawlToProne();
			break;
		default:
			assertEX(0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);
		}
		break;
	default:
		assertEX(0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);
	}
}

ProneWalk()
{
	handler = ProneWalk_handler();
	if (isdefined(handler))
	{
		[[handler]]();
		return;
	}
	
	self.anim_movement = "walk";
}

ProneRun()
{
	handler = ProneRun_handler();
	if (isdefined(handler))
	{
		[[handler]]();
		return;
	}
	
	self.anim_movement = "run";
}

ProneWalk_handler()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			return ::StandToProneWalk;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return ::CrouchRunToProneWalk;
		}

	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			return ::CrouchToProneWalk;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return ::CrouchRunToProneWalk;
		}

	default:
		assert(self.anim_pose == "prone");
		switch (self.anim_movement)
		{
		case "stop":
			return ::ProneToProneRun;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return undefined;
		}
	}
}

ProneRun_handler()
{
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			return ::StandToProneRun;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return ::CrouchRunToProneRun;
		}

	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			return ::CrouchToProneRun;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return ::CrouchRunToProneRun;
		}

	default:
		assert(self.anim_pose == "prone");
		switch (self.anim_movement)
		{
		case "stop":
			assert(self.anim_movement == "stop");
			return ::ProneToProneRun;

		default:
			assert(self.anim_movement == "run" || self.anim_movement == "walk");
			return undefined;
		}
	}
}


//--------------------------------------------------------------------------------
// Standing support functions
//--------------------------------------------------------------------------------

PlayTransitionStandWalk(transAnim, finalAnim)
{
	PlayTransitionAnimation(transAnim, "stand", "walk", 1, finalAnim);
}

StandToStandWalk()
{
	assertEX(self.anim_pose == "stand", "SetPoseMovement::StandToStandWalk "+self.anim_pose);
	assertEX(self.anim_movement == "stop", "SetPoseMovement::StandToStandWalk "+self.anim_movement);

	if ( ( (isDefined(self.walk_combatanim))    && ( self animscripts\utility::IsInCombat()) ) || 
		 ( (isDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) ) ||
		 ( (isDefined(self.standanim)) ) )
	{
		BlendIntoStandWalk();
	}
	else
	{
		// The walk start is from an aiming pose so do that.
		if (self.anim_alertness == "casual")
			PlayTransitionAnimation(%stand_alert2aim, "stand", "stop", 1);
		
		rand = randomint (100);
		if ( rand < 50 )
			PlayTransitionStandWalk(%stand_walk_start_straight, %stand_walk_combat_loop_01);
		else if ( rand < 80 )
			PlayTransitionStandWalk(%stand_walk_start_straight, %stand_walk_combat_loop_02);
		else
			PlayTransitionStandWalk(%stand_walk_start_straight, %stand_walk_combat_loop_03);
	}
}

StandToCrouchWalk()
{
	StandToStandWalk();
	BlendIntoCrouchWalk();
}

StandToStandRun()
{
	BlendIntoStandRun();
}

StandToCrouchRun()
{
	StandToStandRun();
	BlendIntoCrouchRun();
}

StandWalkToStand()
{
	assertEX(self.anim_pose == "stand", "SetPoseMovement::StandWalkToStand "+self.anim_pose);
	assertEX(self.anim_movement == "walk", "SetPoseMovement::StandWalkToStand "+self.anim_movement);

	// Decide which idle animation to do
	if (randomint(100)<50)
		self.anim_idleSet = "a";
	else
		self.anim_idleSet = "b";

	// Now stop
	if ( ( (isDefined(self.walk_combatanim))    && ( self animscripts\utility::IsInCombat()) ) || 
		 ( (isDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) ) ||
		 ( (isDefined(self.standanim)) ) )
	{
		// Do nothing, just pop for now.
		self.anim_movement = "stop";
	}
	else if ( (self getAnimTime(%walk_and_run_loops)) < 0.5 )
		PlayTransitionAnimation(%stand_walk_stop_rff, "stand", "stop", 1);
	else
		PlayTransitionAnimation(%stand_walk_stop_lff, "stand", "stop", 1);
}


StandWalkToCrouch()
{
	StandWalkToStand();
	StandToCrouch();
}


StandRunToStand()
{
	assertEX(self.anim_pose == "stand", "SetPoseMovement::StandRunToStand "+self.anim_pose);
	assertEX(self.anim_movement == "run", "SetPoseMovement::StandRunToStand "+self.anim_movement);

	// Decide which idle animation to do
	if (randomint(100)<50)
		self.anim_idleSet = "a";
	else
		self.anim_idleSet = "b";

	// Now stop
	if ( ( (isDefined(self.walk_combatanim))    && ( self animscripts\utility::IsInCombat()) ) || 
		 ( (isDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) ) )
	{
		// Do nothing, just pop for now.
		self.anim_movement = "stop";
	}
	else if ( (self getAnimTime(%walk_and_run_loops)) < 0.5 )
		PlayTransitionAnimation(%stand_walk_stop_rff, "stand", "stop", 0, undefined, 3);	// TODO Make this a running stop instead
	else
		PlayTransitionAnimation(%stand_walk_stop_lff, "stand", "stop", 0, undefined, 3);	// TODO Make this a running stop instead

//		PlayTransitionAnimation(transAnim, endPose, endMovement, endAiming, finalAnim, rate)
}

StandRunToCrouch()
{
	self.anim_movement = "stop";
	self.anim_pose = "crouch";
}

PlayBlendTransitionStandRun(animname)
{
	if (self.anim_movement != "stop")
		self endon("movemode");

	PlayBlendTransition(animname, 1, "stand", "run", 0);
}

BlendIntoStandRun()
{
	if ( isdefined(self.cliffDeath) && (self.cliffDeath == true) )
		return;
	if ( self animscripts\utility::IsInCombat() )
	{
		if (isDefined(self.run_combatanim))
		{
			PlayBlendTransitionStandRun(self.run_combatanim);
		}
		else
		{
			// Set the specific forward animation we are using to weight 1 immediatley
			// we will make sure it is blended smoothly by blending in its parent, combatrun_forward
//			self setanimknob(self.anim_combatrunanim, 1, 0.0, 1);

			if (usingDefaultRun())
				self setanimknob(%combat_run_fast_rampup_short, 1, 0.5, 1);
			else
				self setanimknob(self.anim_combatrunanim, 1, 0.0, 1);
//			self setanimknob(%combat_run_fast_rampup, 1, 0.0, 1);
			
			self thread animscripts\run::UpdateRunWeights(	"BlendIntoStandRun", 
															%combatrun_forward, 
															%combatrun_back, 
															%combatrun_left,
															%combatrun_right
															);
			PlayBlendTransitionStandRun(%combatrun);
		}
	}
	else
	{
		if (isDefined(self.run_noncombatanim))
		{
			PlayBlendTransitionStandRun(self.run_noncombatanim);
		}
		else
		{
			// Set the specific forward animation we are using to weight 1 immediatley
			// we will make sure it is blended smoothly by blending in its parent, combatrun_forward
			prerunAnim = undefined;
			if (self.preCombatRunEnabled)
				prerunAnim = %precombatrun1;
			else
				prerunAnim = self.anim_combatrunanim;
			
			self setanimknob(prerunAnim, 1, 0.5, 1);
			self thread animscripts\run::UpdateRunWeights(	"BlendIntoStandRun", 
															%combatrun_forward, 
															%combatrun_back, 
															%combatrun_left,
															%combatrun_right
															);
			PlayBlendTransitionStandRun(%combatrun);
		}
	}
	self notify ("BlendIntoStandRun");
}

PlayBlendTransitionStandWalk(animname)
{
	if (self.anim_movement != "stop")
		self endon("movemode");

	PlayBlendTransition(animname, 1.6, "stand", "walk", 1);
}

BlendIntoStandWalk()
{
	if ( (isDefined(self.walk_combatanim)) && (self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_combatanim2)) )
		{
			PlayBlendTransitionStandWalk(self.walk_combatanim2);
		}
		else
		{
			PlayBlendTransitionStandWalk(self.walk_combatanim);
		}
	}
	else if (isDefined(self.walk_noncombatanim))
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_noncombatanim2)) )
		{
			PlayBlendTransitionStandWalk(self.walk_noncombatanim2);
		}
		else
		{
			PlayBlendTransitionStandWalk(self.walk_noncombatanim);
		}
	}
	else
	{
		rand = randomint (100);
		if ( rand < 50 )
			PlayBlendTransitionStandWalk(%stand_walk_combat_loop_01);
		else if ( rand < 80 )
			PlayBlendTransitionStandWalk(%stand_walk_combat_loop_02);
		else
			PlayBlendTransitionStandWalk(%stand_walk_combat_loop_03);
	}
}

CrouchToStand()
{
	assertEX(self.anim_pose == "crouch", "SetPoseMovement::CrouchToStand "+self.anim_pose);
	assertEX(self.anim_movement == "stop", "SetPoseMovement::CrouchToStand "+self.anim_movement);

	standSpeed = 1;
	if (isdefined (self.fastStand))
	{
		standSpeed = 1.8;
		self.fastStand = undefined;
	}

	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		PlayTransitionAnimation(%pistol_crouchaimstraight2stand, "stand", "stop", standSpeed);
	}
	else
	{
		// Decide which idle animation to do
		if (randomint(100)<50)
			self.anim_idleSet = "a";
		else
			self.anim_idleSet = "b";

		PlayTransitionAnimation(%crouch2stand, "stand", "stop", standSpeed);
	}
	self clearanim(%shoot, 0);	// This stops the residue from crouch aiming from showing up when we stand aim.
}


//--------------------------------------------------------------------------------
// Crouched Support Functions
//--------------------------------------------------------------------------------


CrouchToCrouchWalk()
{
	assertEX(self.anim_pose == "crouch", "SetPoseMovement::CrouchToCrouchWalk "+self.anim_pose);
	assertEX(self.anim_movement == "stop", "SetPoseMovement::CrouchToCrouchWalk "+self.anim_movement);

	PlayTransitionAnimation(%crouch2crouchwalk_straight, "crouch", "walk", 0, %crouchwalk_loop);
}

CrouchToStandWalk()
{
	CrouchToCrouchWalk();
	BlendIntoStandWalk();
}

CrouchWalkToCrouch()
{
	assertEX(self.anim_pose == "crouch", "SetPoseMovement::CrouchWalkToCrouch "+self.anim_pose);
	assertEX(self.anim_movement == "walk", "SetPoseMovement::CrouchWalkToCrouch "+self.anim_movement);

	// Decide which idle animation to do
	if (randomint(100)<50)
		self.anim_idleSet = "a";
	else
		self.anim_idleSet = "b";

	if (isDefined(self.crouchrun_combatanim))
	{
		// Do nothing, just pop for now.
		self.anim_movement = "stop";
	}
	else if (self animscripts\utility::weaponAnims() == "none")
	{
		// Do nothing, just pop for now
		self.anim_movement = "stop";
	}
	else
	{
		PlayTransitionAnimation(%crouchwalk_stop_rff, "crouch", "stop", 1);
	}
}

CrouchWalkToStand()
{
	CrouchWalkToCrouch();
	CrouchToStand();
}

CrouchRunToCrouch()
{
	assertEX(self.anim_pose == "crouch", "SetPoseMovement::CrouchRunToCrouch "+self.anim_pose);
	assertEX(self.anim_movement == "run", "SetPoseMovement::CrouchRunToCrouch "+self.anim_movement);

	// Decide which idle animation to do
	if (randomint(100)<50)
		self.anim_idleSet = "a";
	else
		self.anim_idleSet = "b";

	if (isDefined(self.crouchrun_combatanim))
	{
		// Do nothing, just pop for now.
		self.anim_movement = "stop";
	}
	else if (self animscripts\utility::weaponAnims() == "none")
	{
		// Do nothing, just pop for now
		self.anim_movement = "stop";
	}
	else
	{
		PlayTransitionAnimation(%crouchwalk_stop_rff, "crouch", "stop", 1);	// TODO Make this a running stop instead
	}
}

CrouchRunToStand()
{
	CrouchRunToCrouch();
	CrouchToStand();
}

CrouchToCrouchRun()
{
	assertEX(self.anim_pose == "crouch", "SetPoseMovement::CrouchToCrouchRun "+self.anim_pose);
	assertEX(self.anim_movement == "stop", "SetPoseMovement::CrouchToCrouchRun "+self.anim_movement);

	if (isDefined(self.crouchrun_combatanim))
	{
		BlendIntoCrouchRun();
	}
	else
	{
		// First, choose all the animations we need
		if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
		{
			crouch2crouchrun_forward = %pistol_crouch2crouchrun_forward;
			crouchrun_loop_forward_1 = %pistol_crouchrun_loop_forward_1;
		}
		else
		{
			crouch2crouchrun_forward = %crouch2crouchrun_forward;
			crouchrun_loop_forward_1 = %crouchrun_loop_forward_2; // 1
		}
		crouch2crouchrun_back = %crouch2crouchrun_back;
		crouch2crouchrun_left = %crouch2crouchrun_left;
		crouch2crouchrun_right = %crouch2crouchrun_right;
		crouchrun_loop_back = %crouchrun_loop_back;
		crouchrun_loop_left = %crouchrun_loop_left;
		crouchrun_loop_right = %crouchrun_loop_right;

		// There's a lot going on here.  We use a thread to choose the correct transition direction, and another 
		// thread to choose the correct run animation for after the transition.  We knob the plain forward 
		// running animation in case we are running forward, because that's the one that matches the transition.  
		// After the transition plays and the loop starts, we'll slowly transition into the forward run animation 
		// that matches our character (this is done in BlendIntoCrouchRun).
		if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
		{
			self setanimknoball(%pistol_crouch2crouchrun_forward, %body, 1, 0.1);
		}
		else
		{
			self setanimknoball(%crouch2crouchrun, %body, 1, 0.1);
		}
		self thread animscripts\run::UpdateRunWeights(	"stopCrouch2Run", 
														%crouch2crouchrun_forward, 
														crouch2crouchrun_back, 
														crouch2crouchrun_left,
														crouch2crouchrun_right
														);
		self thread animscripts\run::UpdateRunWeights(	"stopCrouch2Run", 
														%crouchrun_loop_forward, 
														crouchrun_loop_back, 
														crouchrun_loop_left,
														crouchrun_loop_right
														);
		self setAnimKnob(crouchrun_loop_forward_1, 1, 0.2); // changed blendtime to 0.2 so they cant pop into run
		PlayTransitionAnimation2(%crouch2crouchrun, "crouch", "run", 1, %crouchrun);
		self notify ("stopCrouch2Run");
	}
}

CrouchToStandRun()
{
	BlendIntoStandRun();
}

BlendIntoCrouchRun()
{
	if (isDefined(self.crouchrun_combatanim))
	{
		self setanimknoball(self.crouchrun_combatanim, %body, 1, 0.4);
		PlayBlendTransition(self.crouchrun_combatanim, 0.6, "crouch", "run", 0);
		self notify ("BlendIntoCrouchRun");
	}
	else
	{
		self setanimknob(self.anim_crouchrunanim, 1, 0.4);
		self thread animscripts\run::UpdateRunWeights(	"BlendIntoCrouchRun", 
														%crouchrun_loop_forward, 
														%crouchrun_loop_back, 
														%crouchrun_loop_left,
														%crouchrun_loop_right
														);
		PlayBlendTransition(%crouchrun, 0.6, "crouch", "run", 0);
		self notify ("BlendIntoCrouchRun");
	}
}

ProneToCrouchRun()
{
	assertEX(self.anim_pose == "prone", "SetPoseMovement::ProneToCrouchRun "+self.anim_pose);

	self OrientMode ("face current");	// We don't want to rotate arbitrarily until we've actually stood up.
	self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
	ProneLegsStraightTree(0.2);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%prone2crouchrun_straight, "crouch", "run", 0, %crouchrun_loop_forward);

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	ProneLegsStraightTree(0.2);
//	self setflaggedanimknob("animdone", %prone2crouchrun_straight, 1, .2, 1);
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	self waittill ("animdone");
//	self.anim_pose = "crouch";
//	self.anim_movement = "run";
}

ProneToStandRun()
{
	ProneToCrouchRun();
	BlendIntoStandRun();
}

ProneToCrouchWalk()
{
	ProneToCrouchRun();
	BlendIntoCrouchWalk();
}

BlendIntoCrouchWalk()
{
	if (isDefined(self.crouchrun_combatanim))
	{
		self setanimknoball(self.crouchrun_combatanim, %body, 1, 0.4);
		PlayBlendTransition(self.crouchrun_combatanim, 0.6, "crouch", "walk", 0);
		self notify ("BlendIntoCrouchWalk");
	}
	else
	{
		PlayBlendTransition(%crouchwalk_loop, 0.8, "crouch", "walk", 1);
	}
}

StandToCrouch()
{
	assertEX(self.anim_pose == "stand", "SetPoseMovement::StandToCrouch "+self.anim_pose);
	assertEX(self.anim_movement == "stop", "SetPoseMovement::StandToCrouch "+self.anim_movement);

//	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
//	{
//		PlayTransitionAnimation(%pistol_crouchaimstraight2stand, "stand", "stop", 1);
//	}
//	else
	{
		// Decide which idle animation to do
		if (randomint(100)<50)
			self.anim_idleSet = "a";
		else
			self.anim_idleSet = "b";

		crouchSpeed = 1;
		if (isdefined (self.fastCrouch))
		{
			crouchSpeed = 1.8;
			self.fastCrouch = undefined;
		}
		
		//PlayTransitionAnimation(transAnim, endPose, endMovement, endAiming, finalAnim)
		PlayTransitionAnimation(%stand2crouch_attack, "crouch", "stop", 1, undefined, crouchspeed);
	}
	self clearanim(%shoot, 0);	// This stops the stand aiming residue from showing up when we crouch aim.
}

ProneToCrouch()
{
	assertEX(self.anim_pose == "prone", "SetPoseMovement::StandToCrouch "+self.anim_pose);

	// Decide which idle animation to do
	if (randomint(100)<50)
		self.anim_idleSet = "a";
	else
		self.anim_idleSet = "b";

	self OrientMode ("face current");	// We don't want to rotate arbitrarily until we've actually stood up.
	self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
	ProneLegsStraightTree(0.1);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%prone2crouch_straight, "crouch", "stop", 1);

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	self exitprone(1.0); // make code stop lerping in the prone orientation to ground
//
//	ProneLegsStraightTree(0.1);
//	self setflaggedanimknob("animdone", %prone2crouch_straight, 1, .1, 1);
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	self waittill ("animdone");
//	self.anim_pose = "crouch";
}

ProneToStand()
{
	ProneToCrouch();
	CrouchToStand();
}

ProneToStandWalk()
{
	ProneToCrouch();
	CrouchToCrouchWalk();
	BlendIntoStandWalk();
}

//--------------------------------------------------------------------------------
// Prone Support Functions
//--------------------------------------------------------------------------------

ProneToProneMove(movement)
{
	// (The parameter "movement" is just used for setting the state variable, since prone guys move the same whether
	// "walking" or "running".
	assertEX(self.anim_pose == "prone", "SetPoseMovement::ProneToProneMove "+self.anim_pose);
	assertEX(self.anim_movement == "stop", "SetPoseMovement::ProneToProneMove "+self.anim_movement);
	assertEX( (movement == "walk" || movement == "run"), "SetPoseMovement::ProneToProneMove got bad parameter "+movement);

	ProneLegsStraightTree(0.1);
	PlayTransitionAnimation(%prone_aim2crawl, "prone", movement, 0, %prone_crawl);

	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
}


ProneToProneRun()
{
	ProneToProneMove("run");
}

ProneCrawlToProne()
{
	assertEX(self.anim_pose == "prone", "SetPoseMovement::ProneCrawlToProne "+self.anim_pose);
	assertEX( (self.anim_movement=="walk" || self.anim_movement=="run"), "SetPoseMovement::ProneCrawlToProne "+self.anim_movement);

	ProneLegsStraightTree(0.1);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%prone_crawl2aim, "prone", "stop", 1);

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	ProneLegsStraightTree(0.1);
//	self setflaggedanimknob("animdone", %prone_crawl2aim, 1, 0.1, 1);
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	self waittill("animdone");
//	self.anim_movement = "stop";
//	self.anim_alertness = "aiming";
}

CrouchToProne()
{
	assertEX(self.anim_pose == "crouch", "SetPoseMovement::CrouchToProne "+self.anim_pose);
	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
	// guys who are walking and running, this is used for them too.
//	assertEX(self.anim_movement == "stop", "SetPoseMovement::CrouchToProne "+self.anim_movement);

	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground

	ProneLegsStraightTree(0.3);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%crouch2prone_gunsupport, "prone", "stop", 1);

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
//	self EnterProne(1.0); // make code start lerping in the prone orientation to ground
//
//	ProneLegsStraightTree(0.3);
//	self setflaggedanimknob("animdone", %crouch2prone_gunsupport, 1, .3, 1);
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	self waittill ("animdone");
//	self.anim_pose = "prone";
}

CrouchToProneWalk()
{
	CrouchToProne();	
	ProneToProneRun();
}

CrouchToProneRun()
{
	CrouchToProne();	
	ProneToProneRun();
}

StandToProne()
{
	assertEX(self.anim_pose == "stand", "SetPoseMovement::StandToProne "+self.anim_pose);
	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
	// guys who are walking and running, this is used for them too.
//	assertEX(self.anim_movement == "stop", "SetPoseMovement::StandToProne "+self.anim_movement);
	self endon ("entered_pose" + "prone");

	proneTime = 0.5; // was 1
	thread PlayTransitionAnimationThread_WithoutWaitSetStates(%stand2prone_onehand, "prone", "stop", proneTime);
	
	self waittillmatch ("transAnimDone2", "anim_pose = \"crouch\"");
	waittillframeend; // so that the one in donotetracks gets hit first
	// cause the next pose is prone
	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProneWrapper(proneTime); // make code start lerping in the prone orientation to ground
	self.anim_movement = "stop";

	ProneLegsStraightTree(0.2);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, proneTime);
	self waittillmatch ("transAnimDone2", "end");

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
//	self EnterProne(1.0); // make code start lerping in the prone orientation to ground
//
//	ProneLegsStraightTree(0.2);
//	self setflaggedanimknob("animdone", %stand2prone_onehand, 1, .2, 1);
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	self waittill ("animdone");
//	self.anim_pose = "prone";
}

StandToProneWalk()
{
	StandToProne();
	ProneToProneRun();
}

StandToProneRun()
{
	StandToProne();
	ProneToProneRun();
}

CrouchRunToProne()
{
	assertEX((self.anim_pose == "crouch")||(self.anim_pose == "stand"), "SetPoseMovement::CrouchRunToProne "+self.anim_pose);
	assertEX((self.anim_movement == "run"||self.anim_movement == "walk"), "SetPoseMovement::CrouchRunToProne "+self.anim_movement);
	
	pronetime = 0.5; // was 1
	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProneWrapper(proneTime); // make code start lerping in the prone orientation to ground

	ProneLegsStraightTree(0.2);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, proneTime);

	runDirection = animscripts\utility::getQuadrant ( self getMotionAngle() );
	
	switch(runDirection)
	{
	case "front":
		//thread [[anim.println]]("Diving to prone - moving forward.");#/
		diveanim = %crouchrun2prone_straight;
		break;
	case "left":
		//thread [[anim.println]]("Diving to prone - moving left.");#/
		diveanim = %crouchrun2prone_left;
		break;
	case "right":
		//thread [[anim.println]]("Diving to prone - moving right.");#/
		diveanim = %crouchrun2prone_right;
		break;
	default:
		//thread [[anim.println]]("Diving to prone - moving back.");#/
		diveanim = %crouch2prone_gunsupport;	// This one doesn't dive - it just goes straight down.
		break;
	}

	localDeltaVector = GetMoveDelta (diveanim, 0, 1);
	endPoint = self LocalToWorldCoords( localDeltaVector );
	if (self maymovetopoint(endPoint))
	{
		PlayTransitionAnimation(diveanim, "prone", "stop", pronetime);
	}
	else
	{
		//thread [[anim.println]]("Can't dive to prone.");#/
		PlayTransitionAnimation(%crouch2prone_gunsupport, "prone", "stop", pronetime);
	}
}

CrouchRunToProneWalk()
{
	CrouchRunToProne();
	ProneToProneRun();
}

CrouchRunToProneRun()
{
	CrouchRunToProne();
	ProneToProneRun();
}

//--------------------------------------------------------------------------------
// General support functions
//--------------------------------------------------------------------------------

// PlayTransitionAnimation2 is superceding PlayTransitionAnimation, gradually.  Right now it doesn't set pose 
// and movement (since they should be in notetracks).  Eventually it will take a struct instead of individual 
// parameters for anim state variables.
PlayTransitionAnimation2(transAnim, endPose, endMovement, endAiming, finalAnim)
{
	// Play the anim
	self setflaggedanimknoball("transAnimDone1", transAnim, %body, 1, .05, 1);
	if (!isDefined(self.anim_pose))
		self.pose = "undefined";
	if (!isDefined(self.anim_movement))
		self.movement = "undefined";
	debugIdentifier = self.anim_pose+" to "+endPose+", "+self.anim_movement+" to "+endMovement;
	self animscripts\shared::DoNoteTracks("transAnimDone1", undefined, debugIdentifier);

	// Set state variables in case anything went wrong (like the anim was already halfway through, or the 
	// framerate was so low that the "end" note came before a change pose note.
	self.anim_pose = endPose;
	self.anim_movement = endMovement;
	if (endAiming)
		self.anim_alertness = "aiming";
	else
		self.anim_alertness = "casual";

	if (isDefined(finalAnim))
	{
		self setanimknoball(finalAnim, %body, 1, 0, 1);	// Set the animation instantly
	}
}


PlayTransitionAnimationThread_WithoutWaitSetStates(transAnim, endPose, endMovement, endAiming, finalAnim, rate)
{
	self endon ("killanimscript"); // the threaded one needs this or it wont die
	self endon ("entered_pose" + endPose);
	PlayTransitionAnimationFunc(transAnim, endPose, endMovement, endAiming, finalAnim, rate, false);
}

PlayTransitionAnimation(transAnim, endPose, endMovement, endAiming, finalAnim, rate)
{
	PlayTransitionAnimationFunc(transAnim, endPose, endMovement, endAiming, finalAnim, rate, true);
}


PlayTransitionAnimationFunc(transAnim, endPose, endMovement, endAiming, finalAnim, rate, waitSetStatesEnabled)
{
	if (!isdefined (rate))
		rate = 1;
/#
	if (getdebugcvar("debug_grenadehand") == "on")
	{
		if (endPose != self.anim_pose)
		{
			if (!animhasnotetrack(transAnim, "anim_pose = \"" + endPose + "\""))
			{
				println ("Animation ", transAnim, " lacks an endpose notetrack of ", endPose);
				assertEx(0, "A transition animation is missing a pose notetrack (see the line above)");
			}
		}
		if (endMovement != self.anim_movement)
		{
			if (!animhasnotetrack(transAnim, "anim_movement = \"" + endMovement + "\""))
			{
				println ("Animation ", transAnim, " lacks an endmovement notetrack of ", endMovement);
				assertEx(0, "A transition animation is missing a movement notetrack (see the line above)");
			}
		}
	}
#/
	// Use a second thread to set the anim state halfway through the animation
	if (waitSetStatesEnabled)
		self thread waitSetStates ( getanimlength(transAnim)/2.0, "killtimerscript", endPose);

	// Play the anim
	// setflaggedanimknoball(notifyName, anim, rootAnim, goalWeight, goalTime, rate) 
	self setflaggedanimknoballrestart("transAnimDone2", transAnim, %body, 1, .2, rate);
	if (!isDefined(self.anim_pose))
		self.pose = "undefined";
	if (!isDefined(self.anim_movement))
		self.movement = "undefined";
	debugIdentifier = "";
	/#debugIdentifier = self.anim_script+", "+self.anim_pose+" to "+endPose+", "+self.anim_movement+" to "+endMovement;#/
	self animscripts\shared::DoNoteTracks("transAnimDone2", undefined, debugIdentifier);

	// In case we finished earlier than we expected (eg the animation was already playing before we started), 
	// set the variables and kill the other thread.
	self notify ("killtimerscript");
	self.anim_pose = endPose;
	self notify ("entered_pose" + endPose);

	self.anim_movement = endMovement;
	if (endAiming)
		self.anim_alertness = "aiming";
	else
		self.anim_alertness = "casual";

	if (isDefined(finalAnim))
	{
		// setflaggedanimknoball(notifyName, anim, rootAnim, goalWeight, goalTime, rate) 
		self setanimknoball(finalAnim, %body, 1, 0.3, rate);	// Set the animation instantly
	}
}


waitSetStates ( timetowait, killmestring, endPose )
{
	self endon("killanimscript");
	self endon ("death");
	self endon(killmestring);
	oldpose = self.anim_pose;
	wait timetowait;

	// We called Enter/ExitProne before this function was called.  These lines should not be necessary, but 
	// for some reason the code is picking up that I'm setting pose from prone to crouch without calling 
	// exitprone().  I just hope it's not a thread leak I've missed.
	if ( oldpose!="prone" && endPose =="prone" )
	{
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
	}
	else
	if ( oldpose=="prone" && endPose !="prone" )
	{
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
		self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
	}

/*
	if (self.anim_pose != pose)
		self.anim_pose = pose;
	
	if (self.anim_movement != movement)
		self.anim_movement = movement;
		
	if (aiming)
		self.anim_alertness = "aiming";
	else
		self.anim_alertness = "casual";
*/
}


PlayBlendTransition(transAnim, crossblendTime, endPose, endMovement, endAiming)
{
	endTime = gettime() + (crossblendTime*1000);
	self setflaggedanimknoball("animdone", transAnim, %body, 1, crossblendTime, 1);
	wait crossblendTime / 2;
	self.anim_pose = endPose;
	self.anim_movement = endMovement;
	if (endAiming)
		self.anim_alertness = "aiming";
	else
		self.anim_alertness = "casual";

	waittime =  ( endTime-gettime() ) / 1000;
	if (waittime <= 0)
		waittime = 0.05;

	// Dont wait 0.		
	wait (waittime);
//	wait ( endTime-gettime() ) / 1000;
}


/*StandCrouchTree(blendtime)
{
	self setanimknob(%body, 1, blendtime, 1);
	self setanimknob(%stand_and_crouch, 1, blendtime, 1);	
}*/

ProneLegsStraightTree(blendtime)
{
	self setanimknoball(%prone_legsstraight, %body, 1, blendtime, 1);
}


usingDefaultRun()
{
	for (i=0;i<anim.combatRunAnim.size;i++)
	{
		if (self.anim_combatrunanim == anim.combatRunAnim[i])
			return true;
	}
	return false;
}