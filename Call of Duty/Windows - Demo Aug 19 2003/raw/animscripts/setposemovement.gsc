//================================================================================
// SetPoseMovement - Sets the pose (stand, crouch, prone) and movement (run, walk, 
// crawl, stop) to the specified values.  Accounts for all possible starting poses 
// and movements.
//================================================================================

#using_animtree ("generic_human");


SetPoseMovement(desiredPose, desiredMovement)
{
	self.anim_debug_lastSetPoseMovement_Time = getTime();
	self.anim_debug_lastSetPoseMovement_oldPose = self.anim_pose;
	self.anim_debug_lastSetPoseMovement_oldMovement = self.anim_movement;
	if (IsDefined(self.anim_wounded))
		self.anim_debug_lastSetPoseMovement_oldWounded = self.anim_wounded;
	else
		self.anim_debug_lastSetPoseMovement_oldWounded = "";
	self.anim_debug_lastSetPoseMovement_oldSpecial = self.anim_special;
	self.anim_debug_lastSetPoseMovement_desiredPose = desiredPose;
	if (IsDefined(desiredMovement))
		self.anim_debug_lastSetPoseMovement_desiredMovement = desiredMovement;
	else
		self.anim_debug_lastSetPoseMovement_desiredMovement = "";

	if (self.anim_pose == "wounded")
	{
		println ("SetPoseMovement doesn't handle wounded.  Error in calling script.");
		homemade_error = crap_out_now + please;
	}

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

	[[anim.println]]("	SetPoseMovement "+desiredPose+" "+desiredMovement+" "+self.anim_pose+" "+self.anim_movement);

	// Now call the function.
	[[anim.SetPoseMovementFnArray[desiredPose][desiredMovement]]]();

	self.anim_debug_lastSetPoseMovement_Time = getTime();
	self.anim_debug_lastSetPoseMovement_resultPose = self.anim_pose;
	self.anim_debug_lastSetPoseMovement_resultMovement = self.anim_movement;
}


InitPoseMovementFunctions()
{
	// Make an array of movement and pose changing functions.  
	// Indices are: "desired movement", "desired pose"
	anim.SetPoseMovementFnArray["stand"]["stop"] =	animscripts\SetPoseMovement::StandStop;
	anim.SetPoseMovementFnArray["stand"]["walk"] =	animscripts\SetPoseMovement::StandWalk;
	anim.SetPoseMovementFnArray["stand"]["run"] =	animscripts\SetPoseMovement::StandRun;

	anim.SetPoseMovementFnArray["crouch"]["stop"] =	animscripts\SetPoseMovement::CrouchStop;
	anim.SetPoseMovementFnArray["crouch"]["walk"] =	animscripts\SetPoseMovement::CrouchWalk;
	anim.SetPoseMovementFnArray["crouch"]["run"] =	animscripts\SetPoseMovement::CrouchRun;

	anim.SetPoseMovementFnArray["prone"]["stop"] =	animscripts\SetPoseMovement::ProneStop;
	anim.SetPoseMovementFnArray["prone"]["walk"] =	animscripts\SetPoseMovement::ProneWalk;
	anim.SetPoseMovementFnArray["prone"]["run"] =	animscripts\SetPoseMovement::ProneRun;

	anim.SetPoseMovement = animscripts\SetPoseMovement::SetPoseMovement;
}


//--------------------------------------------------------------------------------
// Standing poses
//--------------------------------------------------------------------------------

StandStop()
{
	[[anim.println]]("	StandStop from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			// Do nothing
			break;
		case "walk":
			StandWalkToStand();
			break;
		case "run":
			StandRunToStand();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandStop "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToStand();
			break;
		case "walk":
			CrouchWalkToCrouch();
			CrouchToStand();
			break;
		case "run":
			CrouchRunToCrouch();
			CrouchToStand();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandStop "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "prone":
		switch (self.anim_movement)
		{
		case "stop":
			ProneToCrouch();
			CrouchToStand();
			break;
		case "walk":
		case "run":
			ProneToCrouch();	// Do I need to stop crawling first?  Hope not.
			CrouchToStand();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandStop "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::StandStop "+self.anim_pose+" "+self.anim_movement);			
	}
}

StandWalk()
{
	[[anim.println]]("	StandWalk from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToStandWalk();
			break;
		case "walk":
			// Do nothing
			break;
		case "run":
			BlendIntoStandWalk();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandWalk "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToCrouchWalk();
			BlendIntoStandWalk();
			break;
		case "walk":
			BlendIntoStandWalk();
			break;
		case "run":
			BlendIntoStandWalk();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandWalk "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "prone":
		switch (self.anim_movement)
		{
		case "stop":
			ProneToCrouch();
			CrouchToCrouchWalk();
			BlendIntoStandWalk();
			break;
		case "walk":
		case "run":
			ProneToCrouch();	// Do I need to stop crawling first?  Hope not.
			CrouchToCrouchWalk();
			BlendIntoStandWalk();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandWalk "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::StandWalk "+self.anim_pose+" "+self.anim_movement);			
	}
}

StandRun()
{
	[[anim.println]]("	StandRun from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToStandRun();
			break;
		case "walk":
			BlendIntoStandRun();
			break;
		case "run":
			// Do nothing
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandRun "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToCrouchRun();
			BlendIntoStandRun();
			break;
		case "walk":
			BlendIntoStandRun();
			break;
		case "run":
			BlendIntoStandRun();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::StandRun "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "prone":
		ProneToCrouchRun();
		BlendIntoStandRun();
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::StandRun "+self.anim_pose+" "+self.anim_movement);			
	}
}

//--------------------------------------------------------------------------------
// Crouching functions
//--------------------------------------------------------------------------------
CrouchStop()
{
	[[anim.println]]("	CrouchStop from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToCrouch();
			break;
		case "walk":
			StandWalkToStand();
			StandToCrouch();
			break;
		case "run":
			StandRunToStand();
			StandToCrouch();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::CrouchStop "+self.anim_pose+" "+self.anim_movement);			
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
			[[anim.assert]](0, "SetPoseMovement::CrouchStop "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "prone":
		ProneToCrouch();
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::CrouchStop "+self.anim_pose+" "+self.anim_movement);			
	}
}

CrouchWalk()
{
	[[anim.println]]("	CrouchWalk from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToStandWalk();
			BlendIntoCrouchWalk();
			break;
		case "walk":
			BlendIntoCrouchWalk();
			break;
		case "run":
			BlendIntoCrouchWalk();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::CrouchWalk "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToCrouchWalk();
			break;
		case "walk":
			// Do nothing
			break;
		case "run":
			BlendIntoCrouchWalk();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::CrouchWalk "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "prone":
		//ProneToCrouch();
		//CrouchToCrouchWalk();
		// Let's try going straight to the run and then blending back to see what it looks like.
		ProneToCrouchRun();
		BlendIntoCrouchWalk();
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::CrouchWalk "+self.anim_pose+" "+self.anim_movement);			
	}
}

CrouchRun()
{
	[[anim.println]]("	CrouchRun from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToStandRun();
			BlendIntoCrouchRun();
			break;
		case "walk":
			BlendIntoCrouchRun();
			break;
		case "run":
			BlendIntoCrouchRun();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToCrouchRun();
			break;
		case "walk":
			BlendIntoCrouchRun();
			break;
		case "run":
			// Do nothing
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "prone":
		ProneToCrouchRun();
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);			
	}
}

//--------------------------------------------------------------------------------
// Prone Functions
//--------------------------------------------------------------------------------

ProneStop()
{
	[[anim.println]]("	ProneStop from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToProne();
			break;
		case "walk":
			StandToProne();		// TODO Should I use CrouchRunToProne here?
			break;
		case "run":
			CrouchRunToProne();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToProne();	
			break;
		case "walk":
			CrouchToProne();		// TODO Should I use CrouchRunToProne here?
			break;
		case "run":
			CrouchRunToProne();
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);			
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
			[[anim.assert]](0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::CrouchRun "+self.anim_pose+" "+self.anim_movement);			
	}
}

ProneWalk()
{
	ProneCrawl("walk");
}
ProneRun()
{
	ProneCrawl("run");
}
ProneCrawl(movement)
{
	[[anim.assert]]( (movement == "walk" || movement == "run"), "SetPoseMovement::ProneCrawl got bad parameter "+movement);
	[[anim.println]]("	ProneCrawl from "+self.anim_pose+" "+self.anim_movement);
	switch (self.anim_pose)
	{
	case "stand":
		switch (self.anim_movement)
		{
		case "stop":
			StandToProne();
			ProneToProneCrawl(movement);
			break;
		case "walk":
			StandToProne();		// TODO Should I use CrouchRunToProne here?
			ProneToProneCrawl(movement);
			break;
		case "run":
			CrouchRunToProne();
			ProneToProneCrawl(movement);
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::ProneCrawl "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "crouch":
		switch (self.anim_movement)
		{
		case "stop":
			CrouchToProne();	
			ProneToProneCrawl(movement);
			break;
		case "walk":
			CrouchToProne();		// TODO Should I use CrouchRunToProne here?
			ProneToProneCrawl(movement);
			break;
		case "run":
			CrouchRunToProne();
			ProneToProneCrawl(movement);
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::ProneCrawl "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	case "prone":
		switch (self.anim_movement)
		{
		case "stop":
			ProneToProneCrawl(movement);
			break;
		case "walk":
		case "run":
			// Do nothing except set anim_movement
			self.anim_movement = movement;
			break;
		default:
			[[anim.assert]](0, "SetPoseMovement::ProneCrawl "+self.anim_pose+" "+self.anim_movement);			
		}
		break;
	default:
		[[anim.assert]](0, "SetPoseMovement::ProneCrawl "+self.anim_pose+" "+self.anim_movement);			
	}
}


//--------------------------------------------------------------------------------
// Standing support functions
//--------------------------------------------------------------------------------

StandToStandWalk()
{
	[[anim.assert]](self.anim_pose == "stand", "SetPoseMovement::StandToStandWalk "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::StandToStandWalk "+self.anim_movement);

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
			PlayTransitionAnimation(%stand_alert2aim, "stand", "stop", 1, 1);
		
		rand = randomint (100);
		[[anim.locSpam]]("w3");
		if ( rand < 50 )
			PlayTransitionAnimation(%stand_walk_start_straight, "stand", "walk", 1, 1, %stand_walk_combat_loop_01);
		else if ( rand < 80 )
			PlayTransitionAnimation(%stand_walk_start_straight, "stand", "walk", 1, 1, %stand_walk_combat_loop_02);
		else
			PlayTransitionAnimation(%stand_walk_start_straight, "stand", "walk", 1, 1, %stand_walk_combat_loop_03);
	}
}


StandToStandRun()
{
		BlendIntoStandRun();
/*
//	if ( self animscripts\utility::IsInCombat() )
//	{
		PlayTransitionAnimation(%stand2quickstep_straight, "stand", "run", 0, 1, %combatrun_quickstep_loop);
//	}
//	else
if (!( self animscripts\utility::IsInCombat() ))
	{
//		// TEMP Until I get real running starts
//		StandToStandWalk();
		BlendIntoStandRun();
	}
*/
}


StandWalkToStand()
{
	[[anim.assert]](self.anim_pose == "stand", "SetPoseMovement::StandWalkToStand "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "walk", "SetPoseMovement::StandWalkToStand "+self.anim_movement);

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
		PlayTransitionAnimation(%stand_walk_stop_rff, "stand", "stop", 1, 1);
	else
		PlayTransitionAnimation(%stand_walk_stop_lff, "stand", "stop", 1, 1);
}


StandRunToStand()
{
	[[anim.assert]](self.anim_pose == "stand", "SetPoseMovement::StandRunToStand "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "run", "SetPoseMovement::StandRunToStand "+self.anim_movement);

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
		PlayTransitionAnimation(%stand_walk_stop_rff, "stand", "stop", 1, 1);	// TODO Make this a running stop instead
	else
		PlayTransitionAnimation(%stand_walk_stop_lff, "stand", "stop", 1, 1);	// TODO Make this a running stop instead
}

BlendIntoStandRun()
{
//	if ( self animscripts\utility::IsInCombat() )
//		PlayBlendTransition(%combatrun_quickstep_loop, 0.75, "stand", "run", 0);
//	else
//		PlayBlendTransition(%precombatrun1, 0.75, "stand", "run", 0);
	blendTime = 1.0;
	if ( self animscripts\utility::IsInCombat() )
	{
		if (isDefined(self.run_combatanim))
		{
			PlayBlendTransition(self.run_combatanim, blendTime, "stand", "run", 0);
		}
		else
		{
			self clearanim(%combatrun, blendTime);
			self thread animscripts\run::UpdateRunWeights(	"BlendIntoStandRun", 
															self.anim_combatrunanim, 
															%combatrun_back, 
															%combatrun_left,
															%combatrun_right
															);
			PlayBlendTransition(%combatrun, blendTime, "stand", "run", 0);
		}
		self notify ("BlendIntoStandRun");
	}
	else
	{
		if (isDefined(self.run_noncombatanim))
		{
			PlayBlendTransition(self.run_noncombatanim, blendTime, "stand", "run", 0);
		}
		else
		{
			self clearanim(%combatrun, blendTime);
			self setanimknob(%precombatrun1, 1, 0.1, 1);
			self thread animscripts\run::UpdateRunWeights(	"BlendIntoStandRun", 
															%combatrun_forward, 
															%combatrun_back, 
															%combatrun_left,
															%combatrun_right
															);
			PlayBlendTransition(%combatrun, blendTime, "stand", "run", 0);
		}
		self notify ("BlendIntoStandRun");
	}
}

BlendIntoStandWalk()
{
	blendTime = 1.6;
	if ( (isDefined(self.walk_combatanim)) && (self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_combatanim2)) )
		{
			PlayBlendTransition(self.walk_combatanim2, blendTime, "stand", "walk", 1);
		}
		else
		{
			PlayBlendTransition(self.walk_combatanim, blendTime, "stand", "walk", 1);
		}
	}
	else if (isDefined(self.walk_noncombatanim))
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_noncombatanim2)) )
		{
			PlayBlendTransition(self.walk_noncombatanim2, blendTime, "stand", "walk", 1);
		}
		else
		{
			PlayBlendTransition(self.walk_noncombatanim, blendTime, "stand", "walk", 1);
		}
	}
	else
	{
		rand = randomint (100);
		[[anim.locSpam]]("w3");
		if ( rand < 50 )
			PlayBlendTransition(%stand_walk_combat_loop_01, blendTime, "stand", "walk", 1);
		else if ( rand < 80 )
			PlayBlendTransition(%stand_walk_combat_loop_02, blendTime, "stand", "walk", 1);
		else
			PlayBlendTransition(%stand_walk_combat_loop_03, blendTime, "stand", "walk", 1);
	}
}

CrouchToStand()
{
	[[anim.assert]](self.anim_pose == "crouch", "SetPoseMovement::CrouchToStand "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::CrouchToStand "+self.anim_movement);

	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		PlayTransitionAnimation(%pistol_crouchaimstraight2stand, "stand", "stop", 1, 1);
	}
	else
	{
		// Decide which idle animation to do
		if (randomint(100)<50)
			self.anim_idleSet = "a";
		else
			self.anim_idleSet = "b";

		PlayTransitionAnimation(%crouch2stand, "stand", "stop", 1, 1);
	}
	self clearanim(%shoot, 0);	// This stops the residue from crouch aiming from showing up when we stand aim.
}


//--------------------------------------------------------------------------------
// Crouched Support Functions
//--------------------------------------------------------------------------------


CrouchToCrouchWalk()
{
	[[anim.assert]](self.anim_pose == "crouch", "SetPoseMovement::CrouchToCrouchWalk "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::CrouchToCrouchWalk "+self.anim_movement);

//	StandCrouchTree (.2);
	PlayTransitionAnimation(%crouch2crouchwalk_straight, "crouch", "walk", 0, 1, %crouchwalk_loop);
}

CrouchWalkToCrouch()
{
	[[anim.assert]](self.anim_pose == "crouch", "SetPoseMovement::CrouchWalkToCrouch "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "walk", "SetPoseMovement::CrouchWalkToCrouch "+self.anim_movement);

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
		PlayTransitionAnimation(%crouchwalk_stop_rff, "crouch", "stop", 1, 1);
	}
}

CrouchRunToCrouch()
{
	[[anim.assert]](self.anim_pose == "crouch", "SetPoseMovement::CrouchRunToCrouch "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "run", "SetPoseMovement::CrouchRunToCrouch "+self.anim_movement);

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
		PlayTransitionAnimation(%crouchwalk_stop_rff, "crouch", "stop", 1, 1);	// TODO Make this a running stop instead
	}
}

CrouchToCrouchRun()
{
	[[anim.assert]](self.anim_pose == "crouch", "SetPoseMovement::CrouchToCrouchRun "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::CrouchToCrouchRun "+self.anim_movement);

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
			crouchrun_loop_forward_1 = %crouchrun_loop_forward_1;
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
		self setAnimKnob(crouchrun_loop_forward_1, 1, 0);
		PlayTransitionAnimation2(%crouch2crouchrun, "crouch", "run", 1, 1, %crouchrun);
		self notify ("stopCrouch2Run");
	}
}

BlendIntoCrouchRun()
{
	if (isDefined(self.crouchrun_combatanim))
	{
		self setanimknoball(self.crouchrun_combatanim, %body, 1, 0.4);
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
	[[anim.assert]](self.anim_pose == "prone", "SetPoseMovement::ProneToCrouchRun "+self.anim_pose);

	self OrientMode ("face current");	// We don't want to rotate arbitrarily until we've actually stood up.
	self exitprone(1.0); // make code stop lerping in the prone orientation to ground
	ProneLegsStraightTree(0.2);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%prone2crouchrun_straight, "crouch", "run", 0, 1, %crouchrun_loop_forward);

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	ProneLegsStraightTree(0.2);
//	self setflaggedanimknob("animdone", %prone2crouchrun_straight, 1, .2, 1);
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	self waittill ("animdone");
//	self.anim_pose = "crouch";
//	self.anim_movement = "run";
}

BlendIntoCrouchWalk()
{
	if (isDefined(self.crouchrun_combatanim))
	{
		self setanimknoball(self.crouchrun_combatanim, %body, 1, 0.4);
	}
	else
	{
		PlayBlendTransition(%crouchwalk_loop, 0.8, "crouch", "walk", 1);
	}
}

StandToCrouch()
{
	[[anim.assert]](self.anim_pose == "stand", "SetPoseMovement::StandToCrouch "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::StandToCrouch "+self.anim_movement);

//	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
//	{
//		PlayTransitionAnimation(%pistol_crouchaimstraight2stand, "stand", "stop", 1, 1);
//	}
//	else
	{
		// Decide which idle animation to do
		if (randomint(100)<50)
			self.anim_idleSet = "a";
		else
			self.anim_idleSet = "b";

		PlayTransitionAnimation(%stand2crouch_attack, "crouch", "stop", 1, 1);
	}
	self clearanim(%shoot, 0);	// This stops the stand aiming residue from showing up when we crouch aim.
}

ProneToCrouch()
{
	[[anim.assert]](self.anim_pose == "prone", "SetPoseMovement::StandToCrouch "+self.anim_pose);

	// Decide which idle animation to do
	if (randomint(100)<50)
		self.anim_idleSet = "a";
	else
		self.anim_idleSet = "b";

	self OrientMode ("face current");	// We don't want to rotate arbitrarily until we've actually stood up.
	self exitprone(1.0); // make code stop lerping in the prone orientation to ground
	ProneLegsStraightTree(0.1);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%prone2crouch_straight, "crouch", "stop", 1, 1);

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	self exitprone(1.0); // make code stop lerping in the prone orientation to ground
//
//	ProneLegsStraightTree(0.1);
//	self setflaggedanimknob("animdone", %prone2crouch_straight, 1, .1, 1);
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	self waittill ("animdone");
//	self.anim_pose = "crouch";
}

//--------------------------------------------------------------------------------
// Prone Support Functions
//--------------------------------------------------------------------------------

ProneToProneCrawl(movement)
{
	// (The parameter "movement" is just used for setting the state variable, since prone guys move the same whether
	// "walking" or "running".
	[[anim.assert]](self.anim_pose == "prone", "SetPoseMovement::ProneToProneCrawl "+self.anim_pose);
	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::ProneToProneCrawl "+self.anim_movement);
	[[anim.assert]]( (movement == "walk" || movement == "run"), "SetPoseMovement::ProneToProneCrawl got bad parameter "+movement);

	ProneLegsStraightTree(0.1);
	PlayTransitionAnimation(%prone_aim2crawl, "prone", movement, 0, 1, %prone_crawl);

	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
}

ProneCrawlToProne()
{
	[[anim.assert]](self.anim_pose == "prone", "SetPoseMovement::ProneCrawlToProne "+self.anim_pose);
	[[anim.assert]]( (self.anim_movement=="walk" || self.anim_movement=="run"), "SetPoseMovement::ProneCrawlToProne "+self.anim_movement);

	ProneLegsStraightTree(0.1);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%prone_crawl2aim, "prone", "stop", 1, 1);

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
	[[anim.assert]](self.anim_pose == "crouch", "SetPoseMovement::CrouchToProne "+self.anim_pose);
	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
	// guys who are walking and running, this is used for them too.
//	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::CrouchToProne "+self.anim_movement);

	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProne(1.0); // make code start lerping in the prone orientation to ground

	ProneLegsStraightTree(0.3);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%crouch2prone_gunsupport, "prone", "stop", 1, 1);

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

StandToProne()
{
	[[anim.assert]](self.anim_pose == "stand", "SetPoseMovement::StandToProne "+self.anim_pose);
	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
	// guys who are walking and running, this is used for them too.
//	[[anim.assert]](self.anim_movement == "stop", "SetPoseMovement::StandToProne "+self.anim_movement);

	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProne(1.0); // make code start lerping in the prone orientation to ground

	ProneLegsStraightTree(0.2);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	PlayTransitionAnimation(%stand2prone_onehand, "prone", "stop", 1, 1);

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

CrouchRunToProne()
{
	[[anim.assert]]((self.anim_pose == "crouch")||(self.anim_pose == "stand"), "SetPoseMovement::CrouchRunToProne "+self.anim_pose);
	[[anim.assert]]((self.anim_movement == "run"), "SetPoseMovement::CrouchRunToProne "+self.anim_movement);
	
	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProne(1.0); // make code start lerping in the prone orientation to ground

	ProneLegsStraightTree(0.2);
	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);

	runDirection = animscripts\utility::getQuadrant ( self getMotionAngle() );
	
	switch(runDirection)
	{
	case "front":
		[[anim.println]]("Diving to prone - moving forward.");
		diveanim = %crouchrun2prone_straight;
		break;
	case "left":
		[[anim.println]]("Diving to prone - moving left.");
		diveanim = %crouchrun2prone_left;
		break;
	case "right":
		[[anim.println]]("Diving to prone - moving right.");
		diveanim = %crouchrun2prone_right;
		break;
	default:
		[[anim.println]]("Diving to prone - moving back.");
		diveanim = %crouch2prone_gunsupport;	// This one doesn't dive - it just goes straight down.
	}

	localDeltaVector = GetMoveDelta (diveanim, 0, 1);
	endPoint = self LocalToWorldCoords( localDeltaVector );
	if (self maymovetopoint(endPoint))
		PlayTransitionAnimation(diveanim, "prone", "stop", 1, 1);
	else
		[[anim.println]]("Can't dive to prone.");
		PlayTransitionAnimation(%crouch2prone_gunsupport, "prone", "stop", 1, 1);
}

//--------------------------------------------------------------------------------
// General support functions
//--------------------------------------------------------------------------------

// PlayTransitionAnimation2 is superceding PlayTransitionAnimation, gradually.  Right now it doesn't set pose 
// and movement (since they should be in notetracks).  Eventually it will take a struct instead of individual 
// parameters for anim state variables.
PlayTransitionAnimation2(transAnim, endPose, endMovement, endAiming, useCriticalSection, finalAnim)
{
	// Start a critical section
	inCritSection=0;
	if (useCriticalSection)
	{
		if (!(self isInCriticalSection()))
		{
			// First make a parameter to pass for debugging
			self.criticalSectionDebugString = self.anim_script+": "+self.anim_pose+" to "+endPose+", "+self.anim_movement+" to "+endMovement;
			self enterCriticalSection(self.criticalSectionDebugString);
			inCritSection=1;
		}
		else
		{
			if (isDefined(self.criticalSectionDebugString))
				println ("SetPoseMovement::PlayTransitionAnimation: Already in critical section: "+self.criticalSectionDebugString);
			else
				println ("SetPoseMovement::PlayTransitionAnimation: Already in critical section!");
		}
	}

	// Play the anim
	self setflaggedanimknoball("transAnimDone", transAnim, %body, 1, .05, 1);
	self animscripts\shared::DoNoteTracks("transAnimDone");

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

	// End the critical section
	if ( inCritSection )
	{
		self leaveCriticalSection();
//println ("Leaving critical section");
	}
//else
//println("No critical section to leave this time.");
}


PlayTransitionAnimation(transAnim, endPose, endMovement, endAiming, useCriticalSection, finalAnim)
{
	// Start a critical section
	inCritSection=0;
	if (useCriticalSection)
	{
		if (!(self isInCriticalSection()))
		{
			// First make a parameter to pass for debugging
//			println("Entering critical section. "+self.anim_script+": "+self.anim_pose+" to "+endPose+", "+self.anim_movement+" to "+endMovement);
			self.criticalSectionDebugString = self.anim_script+": "+self.anim_pose+" to "+endPose+", "+self.anim_movement+" to "+endMovement;
			self enterCriticalSection(self.criticalSectionDebugString);
			inCritSection=1;
		}
		else
		{
			if (isDefined(self.criticalSectionDebugString))
				println ("SetPoseMovement::PlayTransitionAnimation: Already in critical section: "+self.criticalSectionDebugString);
			else
				println ("SetPoseMovement::PlayTransitionAnimation: Already in critical section!");
		}
	}

	// Use a second thread to set the anim state halfway through the animation
	self thread waitSetStates ( getanimlength(transAnim)/2.0, "killtimerscript", endPose, endMovement, endAiming );

	// Play the anim
	self setflaggedanimknoball("transAnimDone", transAnim, %body, 1, .05, 1);
	self animscripts\shared::DoNoteTracks("transAnimDone");

	// In case we finished earlier than we expected (eg the animation was already playing before we started), 
	// set the variables and kill the other thread.
	self notify ("killtimerscript");
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

	// End the critical section
	if ( inCritSection )
	{
		self leaveCriticalSection();
//println ("Leaving critical section");
	}
//else
//println("No critical section to leave this time.");
}


waitSetStates ( timetowait, killmestring, pose, movement, aiming )
{
	self endon("killanimscript");
	self endon ("death");
	self endon(killmestring);
	wait timetowait;

	// We called Enter/ExitProne before this function was called.  These lines should not be necessary, but 
	// for some reason the code is picking up that I'm setting pose from prone to crouch without calling 
	// exitprone().  I just hope it's not a thread leak I've missed.
	if ( pose=="prone" && self.anim_pose!="prone" )
	{
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		self EnterProne(1.0); // make code start lerping in the prone orientation to ground
	}
	else if ( pose!="prone" && self.anim_pose=="prone" )
	{
		self exitprone(1.0); // make code stop lerping in the prone orientation to ground
		self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
	}

	self.anim_pose = pose;
	self.anim_movement = movement;
	if (aiming)
		self.anim_alertness = "aiming";
	else
		self.anim_alertness = "casual";
}


PlayBlendTransition(transAnim, crossblendTime, endPose, endMovement, endAiming)
{
	// Start a critical section
//	if (!(self isInCriticalSection()))
//	{
//		self enterCriticalSection();
//		myCritSection=1;
//	}
//	else
//	{
//		println ("SetPoseMovement::PlayBlendTransition: Already in critical section!");
//		myCritSection=0;
//	}

	endTime = gettime() + (crossblendTime*1000);
	self setflaggedanimknoball("animdone", transAnim, %body, 1, crossblendTime, 1);
	wait ((float)crossblendTime) / 2;
	self.anim_pose = endPose;
	self.anim_movement = endMovement;
	if (endAiming)
		self.anim_alertness = "aiming";
	else
		self.anim_alertness = "casual";

	wait ( (float)(endTime-gettime()) ) / 1000;

//	if ( myCritSection==1 )
//		self leaveCriticalSection();
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
