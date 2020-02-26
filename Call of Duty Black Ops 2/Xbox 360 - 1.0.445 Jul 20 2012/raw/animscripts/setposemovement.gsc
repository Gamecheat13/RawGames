//================================================================================
// SetPoseMovement - Sets the pose (stand, crouch, prone) and movement (run, walk, 
// crawl, stop) to the specified values.  Accounts for all possible starting poses 
// and movements.
//================================================================================

#include animscripts\Utility;
#include animscripts\anims;
#include maps\_Utility;
#include common_scripts\utility;

#using_animtree ("generic_human");

SetPoseMovement(desiredPose, desiredMovement)
{
	/#
	self animscripts\debug::debugPushState( "SetPoseMovement: " + desiredPose + " - " + desiredMovement );
	#/

	// Scripts can pass empty strings, meaning they don't want to change that aspect of the state.
	if (desiredPose=="")
	{
		if ( (self.a.pose=="prone") && ((desiredMovement=="walk")||(desiredMovement=="run")) )
		{
			desiredPose = "crouch";
		}
		else
		{
			desiredPose = self.a.pose;
		}
	}
	if (!IsDefined(desiredMovement) || desiredMovement=="")
	{
		desiredMovement = self.a.movement;
	}

	// Now call the function.
	[[anim.SetPoseMovementFnArray[desiredPose][desiredMovement]]]();

	/#
	self animscripts\debug::debugPopState( "SetPoseMovement: " + desiredPose + " - " + desiredMovement );
	#/
}

// *****************************
//  All of the following "Begin" functions ensure that the actor is in the given pose and movement type.
//  They return false if nothing needs to be done, true otherwise.
// *****************************

InitPoseMovementFunctions()
{
	// Make an array of movement and pose changing functions.  
	// Indices are: "desired movement", "desired pose"
	anim.SetPoseMovementFnArray["stand"]["stop"] =	::BeginStandStop;
	anim.SetPoseMovementFnArray["stand"]["walk"] =	::BeginStandWalk;
	anim.SetPoseMovementFnArray["stand"]["run"] =	::BeginStandRun;

	anim.SetPoseMovementFnArray["crouch"]["stop"] =	::BeginCrouchStop;
	anim.SetPoseMovementFnArray["crouch"]["walk"] =	::BeginCrouchWalk;
	anim.SetPoseMovementFnArray["crouch"]["run"] =	::BeginCrouchRun;

	anim.SetPoseMovementFnArray["prone"]["stop"] =	::BeginProneStop;
	anim.SetPoseMovementFnArray["prone"]["walk"] =	::BeginProneWalk;
	anim.SetPoseMovementFnArray["prone"]["run"] =	::BeginProneRun;
}

//--------------------------------------------------------------------------------
// Standing poses
//--------------------------------------------------------------------------------

BeginStandStop()
{
	/#
	self animscripts\debug::debugPushState( "BeginStandStop: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
		{
		case "stop":
			/#
			self animscripts\debug::debugPopState( "BeginStandStop: " + self.a.pose + " - " + self.a.movement );
			#/
			return false;

		case "walk":
			StandWalkToStand();
			break;

		default:
			assert(self.a.movement == "run");
			StandRunToStand();
			break;
		}
		break;

	case "crouch":
		switch (self.a.movement)
		{
		case "stop":
			CrouchToStand();
			break;

		case "walk":
			CrouchWalkToStand();
			break;

		default:
			assert(self.a.movement == "run");
			CrouchRunToStand();
			break;
		}
		break;

	default:
		assert(self.a.pose == "prone");
		switch (self.a.movement)
		{
		case "stop":
			ProneToStand();
			break;

		default:
			assert(self.a.movement == "walk" || self.a.movement == "run");
			ProneToStand();	// Do I need to stop crawling first?  Hope not.
			break;
		}
		break;
	}

	/#
	self animscripts\debug::debugPopState( "BeginStandStop: " + self.a.pose + " - " + self.a.movement );
	#/
	
	return true;
}

BeginStandWalk()
{
	/#
	self animscripts\debug::debugPushState( "BeginStandWalk: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
		{
		case "stop":
			BlendIntoStandWalk();
			break;

		case "walk":
			/#
			self animscripts\debug::debugPopState( "BeginStandWalk: " + self.a.pose + " - " + self.a.movement );
			#/

			return false;

		default:
			assert(self.a.movement == "run");
			BlendIntoStandWalk();
			break;
		}
		break;

	case "crouch":
		switch (self.a.movement)
		{
		case "stop":
			CrouchToStandWalk();
			break;

		case "walk":
			BlendIntoStandWalk();
			break;

		default:
			assert(self.a.movement == "run");
			BlendIntoStandWalk();
			break;
		}
		break;

	default:
		assert(self.a.pose == "prone");
		ProneToStandWalk();
		break;
	}

	/#
	self animscripts\debug::debugPopState( "BeginStandWalk: " + self.a.pose + " - " + self.a.movement );
	#/
	
	return true;
}

BeginStandRun()
{
	/#
	self animscripts\debug::debugPushState( "BeginStandRun: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
		{
		case "stop":
		case "walk":
			BlendIntoStandRun();
			break;

		default:
			/#
			self animscripts\debug::debugPopState( "BeginStandRun: " + self.a.pose + " - " + self.a.movement );
			#/

			assert(self.a.movement == "run");
			return false;
		}
		break;

	case "crouch":
		switch (self.a.movement)
		{
		case "stop":
			CrouchToStandRun();
			break;

		default:
			assert(self.a.movement == "run" || self.a.movement == "walk");
			BlendIntoStandRun();
			break;
		}
		break;

	default:
		assert(self.a.pose == "prone");
		ProneToStandRun();
		break;
	}

	/#
	self animscripts\debug::debugPopState( "BeginStandRun: " + self.a.pose + " - " + self.a.movement );
	#/
	
	return true;
}

//--------------------------------------------------------------------------------
// Crouching functions
//--------------------------------------------------------------------------------
BeginCrouchStop()
{
	/#
	self animscripts\debug::debugPushState( "BeginCrouchStop: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
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
			assert(0, "SetPoseMovement::BeginCrouchStop "+self.a.pose+" "+self.a.movement);
		}
		break;
	case "crouch":
		switch (self.a.movement)
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
			assert(0, "SetPoseMovement::BeginCrouchStop "+self.a.pose+" "+self.a.movement);
		}
		break;
	case "prone":
		ProneToCrouch();
		break;
	default:
		assert(0, "SetPoseMovement::BeginCrouchStop "+self.a.pose+" "+self.a.movement);
	}

	/#
	self animscripts\debug::debugPopState( "BeginCrouchStop: " + self.a.pose + " - " + self.a.movement );
	#/
}

BeginCrouchWalk()
{
	/#
	self animscripts\debug::debugPushState( "BeginCrouchWalk: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
		{
		case "stop":
			BlendIntoStandWalk();
			BlendIntoCrouchWalk();
			break;

		case "walk":
			BlendIntoCrouchWalk();
			break;

		default:
			assert(self.a.movement == "run");
			BlendIntoCrouchWalk();
			break;
		}
		break;

	case "crouch":
		switch (self.a.movement)
		{
		case "stop":
			CrouchToCrouchWalk();
			break;
			
		case "walk":
			/#
			self animscripts\debug::debugPopState( "BeginCrouchWalk: " + self.a.pose + " - " + self.a.movement );
			#/

			return false;

		default:
			assert(self.a.movement == "run");
			BlendIntoCrouchWalk();
			break;
		}
		break;

	default:
		assert(self.a.pose == "prone");
		// Let's try going straight to the run and then blending back to see what it looks like.
		ProneToCrouchWalk();
		break;
	}

	/#
	self animscripts\debug::debugPopState( "BeginCrouchWalk: " + self.a.pose + " - " + self.a.movement );
	#/
	
	return true;
}

BeginCrouchRun()
{
	/#
	self animscripts\debug::debugPushState( "BeginCrouchRun: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
		{
		case "stop":
			BlendIntoStandRun();
			BlendIntoCrouchRun();
			break;

		default:
			assert(self.a.movement == "run" || self.a.movement == "walk");
			BlendIntoCrouchRun();
			break;
		}
		break;

	case "crouch":
		switch (self.a.movement)
		{
		case "stop":
			CrouchToCrouchRun();
			break;

		case "walk":
			BlendIntoCrouchRun();
			break;

		default:
			/#
			self animscripts\debug::debugPopState( "BeginCrouchRun: " + self.a.pose + " - " + self.a.movement );
			#/

			assert(self.a.movement == "run");
			return false;
		}
		break;

	default:
		assert(self.a.pose == "prone");
		ProneToCrouchRun();
		break;
	}

	/#
	self animscripts\debug::debugPopState( "BeginCrouchRun: " + self.a.pose + " - " + self.a.movement );
	#/
	
	return true;
}

//--------------------------------------------------------------------------------
// Prone Functions
//--------------------------------------------------------------------------------

BeginProneStop()
{
	/#
	self animscripts\debug::debugPushState( "BeginProneStop: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
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
			assert(0, "SetPoseMovement::BeginCrouchRun "+self.a.pose+" "+self.a.movement);
		}
		break;
	case "crouch":
		switch (self.a.movement)
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
			assert(0, "SetPoseMovement::BeginCrouchRun "+self.a.pose+" "+self.a.movement);
		}
		break;
	case "prone":
		switch (self.a.movement)
		{
		case "stop":
			// Do nothing
			break;
		case "walk":
		case "run":
			ProneCrawlToProne();
			break;
		default:
			assert(0, "SetPoseMovement::BeginCrouchRun "+self.a.pose+" "+self.a.movement);
		}
		break;
	default:
		assert(0, "SetPoseMovement::BeginCrouchRun "+self.a.pose+" "+self.a.movement);
	}

	/#
	self animscripts\debug::debugPopState( "BeginProneStop: " + self.a.pose + " - " + self.a.movement );
	#/
}

BeginProneWalk()
{
	/#
	self animscripts\debug::debugPushState( "BeginProneWalk: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
		{
		case "stop":
			StandToProneWalk();
			break;

		default:
			assert(self.a.movement == "run" || self.a.movement == "walk");
			CrouchRunToProneWalk();
			break;
		}
		break;

	case "crouch":
		switch (self.a.movement)
		{
		case "stop":
			CrouchToProneWalk();
			break;

		default:
			assert(self.a.movement == "run" || self.a.movement == "walk");
			CrouchRunToProneWalk();
			break;
		}
		break;

	default:
		assert(self.a.pose == "prone");
		switch (self.a.movement)
		{
		case "stop":
			ProneToProneRun();
			break;

		default:
			/#
			self animscripts\debug::debugPopState( "BeginProneWalk: " + self.a.pose + " - " + self.a.movement );
			#/

			assert(self.a.movement == "run" || self.a.movement == "walk");
			self.a.movement = "walk";
			return false;
		}
		break;
	}

	/#
	self animscripts\debug::debugPopState( "BeginProneWalk: " + self.a.pose + " - " + self.a.movement );
	#/
	
	return true;
}

BeginProneRun()
{
	/#
	self animscripts\debug::debugPushState( "BeginProneRun: " + self.a.pose + " - " + self.a.movement );
	#/

	switch (self.a.pose)
	{
	case "stand":
		switch (self.a.movement)
		{
		case "stop":
			StandToProneRun();
			break;

		default:
			assert(self.a.movement == "run" || self.a.movement == "walk");
			CrouchRunToProneRun();
			break;
		}
		break;

	case "crouch":
		switch (self.a.movement)
		{
		case "stop":
			CrouchToProneRun();
			break;

		default:
			assert(self.a.movement == "run" || self.a.movement == "walk");
			CrouchRunToProneRun();
			break;
		}
		break;

	default:
		assert(self.a.pose == "prone");
		switch (self.a.movement)
		{
		case "stop":
			assert(self.a.movement == "stop");
			ProneToProneRun();
			break;

		default:
			/#
			self animscripts\debug::debugPopState( "BeginProneRun: " + self.a.pose + " - " + self.a.movement );
			#/

			assert(self.a.movement == "run" || self.a.movement == "walk");
			self.a.movement = "run";
			return false;
		}
		break;
	}

	/#
	self animscripts\debug::debugPopState( "BeginProneRun: " + self.a.pose + " - " + self.a.movement );
	#/
	
	return true;
}


//--------------------------------------------------------------------------------
// Standing support functions
//--------------------------------------------------------------------------------

PlayBlendTransition( transAnim, crossblendTime, endPose, endMovement, endAiming )
{
	/#self animscripts\debug::debugPushState( "PlayBlendTransition: " + endPose + " - " + endMovement );#/

	endTime = GetTime() + crossblendTime * 1000;

	self SetAnimKnobAll( transAnim, %body, 1, crossblendTime, 1 );
	
	wait crossblendTime / 2;
	
	self.a.pose = endPose;
	self.a.movement = endMovement;
	
	waittime = (endTime - GetTime()) / 1000;
	if ( waittime < 0.05 )
		waittime = 0.05;
		
	wait waittime;

	/#self animscripts\debug::debugPopState( "PlayBlendTransition: " + endPose + " - " + endMovement );#/
}

PlayTransitionStandWalk(transAnim, finalAnim)
{
	PlayTransitionAnimation(transAnim, "stand", "walk", 1, finalAnim);
}

StandWalkToStand()
{
	assert(self.a.pose == "stand", "SetPoseMovement::StandWalkToStand "+self.a.pose);
	assert(self.a.movement == "walk", "SetPoseMovement::StandWalkToStand "+self.a.movement);

	// no transition animations.

	self.a.movement = "stop";
}

StandWalkToCrouch()
{
	StandWalkToStand();
	StandToCrouch();
}

StandRunToStand()
{
	assert(self.a.pose == "stand", "SetPoseMovement::StandRunToStand "+self.a.pose);
	assert(self.a.movement == "run", "SetPoseMovement::StandRunToStand "+self.a.movement);

	// Do nothing, just blend straight in
	self.a.movement = "stop";
}

StandRunToCrouch()
{
	self.a.movement = "stop";
	self.a.pose = "crouch";
}

PlayBlendTransitionStandRun(animname)
{
	// if we're blending into stand run from stop,
	// we probably just did utility::initialize's ClearAnim(body, .3)
	// so we don't have to spend more than .3 seconds here.
	// (then we can do fun things like shooting or reloading.)
	transtime = 0.3;
	if (self.a.movement != "stop")
	{
		self endon("movemode");
		transtime = 0.1;
	}

	PlayBlendTransition(animname, transtime, "stand", "run", 0);
}

BlendIntoStandRun()
{
	shouldTacticalWalk	= animscripts\run::ShouldTacticalWalk();

	// do not play any transition if going into tactical walk right away
	if( shouldTacticalWalk )
	{
		self.a.movement = "run";
		
		if ( self.a.pose != "stand" )
			transitionToTacticalWalk( "stand" );

		return false;
	}

	if( self animscripts\cqb::shouldCQB() )
	{
		PlayBlendTransitionStandRun( animArray("start_cqb_run_f", "move") );
	}
	else if( self animscripts\utility::IsInCombat() && IsDefined( self.run_combatanim ) ) 
	{
		PlayBlendTransitionStandRun(self.run_combatanim);
	}
	else if (IsDefined(self.run_noncombatanim))
	{
		PlayBlendTransitionStandRun(self.run_noncombatanim);
	}
	else
	{
		shouldShootWhileMoving	= false;
		runAnimName				= "start_stand_run_f";
		transitionAnimParent	= %combatrun;
		forwardRunAnim			= %combatrun_forward;

		// Set the specific forward animation we are using to weight 1 immediately
		// we will make sure it is blended smoothly by blending in its parent, combatrun_forward
		runAnimTransTime = 0.0;
		if ( self.a.movement != "stop" )
			runAnimTransTime = 0.5;

		if( self.a.pose == "stand" )
		{
			if ( animscripts\move::MayShootWhileMoving() && self.bulletsInClip > 0 && isValidEnemy( self.enemy ) )
			{
				shouldShootWhileMoving = true;
				
				if( self.a.pose == "stand" )
					runAnimName = "run_n_gun_f"; // RunNGun
			}
		}

		self ClearAnim( %walk_and_run_loops, 0.2 );
		self setanimknob( %combatrun, 1.0, 0.5, self.moveplaybackrate );
		self SetAnimKnobLimited( animArray( runAnimName ), 1, runAnimTransTime, 1 );

		if( shouldShootWhileMoving && self.a.pose == "stand" )
			self thread animscripts\run::UpdateRunWeights( "BlendIntoStandRun",	forwardRunAnim,	animArray("run_n_gun_b" ) );				
		else
			self thread animscripts\run::UpdateRunWeights( "BlendIntoStandRun",
															forwardRunAnim,
															animArray("combat_run_b"),
															animArray("combat_run_l"),
															animArray("combat_run_r")
												   		  );
		PlayBlendTransitionStandRun(transitionAnimParent);
	}

	self notify ("BlendIntoStandRun");
}

PlayBlendTransitionStandWalk(animname)
{
	if (self.a.movement != "stop")
		self endon("movemode");

	PlayBlendTransition(animname, 0.6, "stand", "walk", 1);
}

BlendIntoStandWalk()
{	
	if ( self.a.movement != "stop" )
		self endon( "movemode" );
		
	self.a.pose = "stand";
	self.a.movement = "walk";
}

CrouchToStand()
{
	assert(self.a.pose == "crouch", "SetPoseMovement::CrouchToStand "+self.a.pose);
	assert(self.a.movement == "stop", "SetPoseMovement::CrouchToStand "+self.a.movement);

	standSpeed = 0.5;
	if (IsDefined (self.fastStand))
	{
		standSpeed = 1.8;
		self.fastStand = undefined;
	}

	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		PlayTransitionAnimation( animArray("crouch_2_stand"), "stand", "stop", standSpeed );
	}
	else
	{
		// Decide which idle animation to do
		self randomizeIdleSet();

		PlayTransitionAnimation( animArray("crouch_2_stand"), "stand", "stop", standSpeed );
	}
	self ClearAnim(%shoot, 0);	// This stops the residue from crouch aiming from showing up when we stand aim.
}

//--------------------------------------------------------------------------------
// Crouched Support Functions
//--------------------------------------------------------------------------------


CrouchToCrouchWalk()
{
	assert(self.a.pose == "crouch", "SetPoseMovement::CrouchToCrouchWalk "+self.a.pose);
	assert(self.a.movement == "stop", "SetPoseMovement::CrouchToCrouchWalk "+self.a.movement);

	BlendIntoCrouchWalk();
}

CrouchToStandWalk()
{
	CrouchToCrouchWalk();
	BlendIntoStandWalk();
}

CrouchWalkToCrouch()
{
	assert(self.a.pose == "crouch", "SetPoseMovement::CrouchWalkToCrouch "+self.a.pose);
	assert(self.a.movement == "walk", "SetPoseMovement::CrouchWalkToCrouch "+self.a.movement);

	// Do nothing, just blend straight in
		self.a.movement = "stop";
	}

CrouchWalkToStand()
{
	CrouchWalkToCrouch();
	CrouchToStand();
}

CrouchRunToCrouch()
{
	assert(self.a.pose == "crouch", "SetPoseMovement::CrouchRunToCrouch "+self.a.pose);
	assert(self.a.movement == "run", "SetPoseMovement::CrouchRunToCrouch "+self.a.movement);

	// Do nothing, just blend straight in
		self.a.movement = "stop";
	}

CrouchRunToStand()
{
	CrouchRunToCrouch();
	CrouchToStand();
}

CrouchToCrouchRun()
{
	assert(self.a.pose == "crouch", "SetPoseMovement::CrouchToCrouchRun "+self.a.pose);
	assert(self.a.movement == "stop", "SetPoseMovement::CrouchToCrouchRun "+self.a.movement);

		BlendIntoCrouchRun();
	}

CrouchToStandRun()
{
	BlendIntoStandRun();
}

BlendIntoCrouchRun()
{
	if (IsDefined(self.crouchrun_combatanim))
	{
		self SetAnimKnobAll(self.crouchrun_combatanim, %body, 1, 0.4);
		PlayBlendTransition(self.crouchrun_combatanim, 0.6, "crouch", "run", 0);
		self notify ("BlendIntoCrouchRun");
	}
	else
	{
		self setanimknob( animscripts\run::GetCrouchRunAnim(), 1, 0.4 );
		self thread animscripts\run::UpdateRunWeights( "BlendIntoCrouchRun",
														%combatrun_forward, 
														animArray("combat_run_b"), 
														animArray("combat_run_l"),
														animArray("combat_run_r")
													 );

		PlayBlendTransition(%combatrun, 0.6, "crouch", "run", 0);
		self notify ("BlendIntoCrouchRun");
	}
}

ProneToCrouchRun()
{
	assert(self.a.pose == "prone", "SetPoseMovement::ProneToCrouchRun "+self.a.pose);

	self OrientMode ("face current");	// We don't want to rotate arbitrarily until we've actually stood up.
	self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
//	ProneLegsStraightTree(0.2);
	self animscripts\cover_prone::UpdateProneWrapper(0.1);
	PlayTransitionAnimation( animArray("prone_2_crouch_run"), "crouch", "run", 0, animArray("crouch_run_f") );
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
	if (IsDefined(self.crouchrun_combatanim))
	{
		self SetAnimKnobAll(self.crouchrun_combatanim, %body, 1, 0.4);
		PlayBlendTransition(self.crouchrun_combatanim, 0.6, "crouch", "walk", 0);
		self notify ("BlendIntoCrouchWalk");
	}
	else
	{
		PlayBlendTransition( animArray("crouch_run_f"), 0.8, "crouch", "walk", 1 );
	}
}

StandToCrouch()
{
	assert(self.a.pose == "stand", "SetPoseMovement::StandToCrouch "+self.a.pose);
	assert(self.a.movement == "stop", "SetPoseMovement::StandToCrouch "+self.a.movement);

	// Decide which idle animation to do
	self randomizeIdleSet();

	crouchSpeed = 0.5;
	if (IsDefined (self.fastCrouch))
	{
		crouchSpeed = 1.8;
		self.fastCrouch = undefined;
	}
	
	PlayTransitionAnimation( animArray("stand_2_crouch"), "crouch", "stop", 1, undefined, crouchspeed );
	
	self ClearAnim(%shoot, 0);	// This stops the stand aiming residue from showing up when we crouch aim.
}

ProneToCrouch()
{
	assert(self.a.pose == "prone", "SetPoseMovement::StandToCrouch "+self.a.pose);

	// Decide which idle animation to do
	self randomizeIdleSet();

	self OrientMode("face current");	// We don't want to rotate arbitrarily until we've actually stood up.
	self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
//	ProneLegsStraightTree(0.1);
	self animscripts\cover_prone::UpdateProneWrapper(0.1);
	PlayTransitionAnimation( animArray("prone_2_crouch"), "crouch", "stop", 1 );

// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
//	self exitprone(1.0); // make code stop lerping in the prone orientation to ground
//
//	ProneLegsStraightTree(0.1);
//	self SetFlaggedAnimKnob("animdone", %prone2crouch_straight, 1, .1, 1);
//	self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
//	self waittill ("animdone");
//	self.a.pose = "crouch";
}

ProneToStand()
{
	assert( self.a.pose == "prone", self.a.pose );
	
	self OrientMode ("face current");	// We don't want to rotate arbitrarily until we've actually stood up.
	self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
//	ProneLegsStraightTree(0.1);
	self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
	PlayTransitionAnimation( animArray("prone_2_stand"), "stand", "stop", 1 );
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
	assert(self.a.pose == "prone", "SetPoseMovement::ProneToProneMove "+self.a.pose);
	assert(self.a.movement == "stop", "SetPoseMovement::ProneToProneMove "+self.a.movement);
	assert( (movement == "walk" || movement == "run"), "SetPoseMovement::ProneToProneMove got bad parameter "+movement);

//	ProneLegsStraightTree(0.1);
	PlayTransitionAnimation( animArray("aim_2_crawl"), "prone", movement, 0, animArray("combat_run_f") );

	self animscripts\cover_prone::UpdateProneWrapper(0.1);
}

ProneToProneRun()
{
	ProneToProneMove("run");
}

ProneCrawlToProne()
{
	assert(self.a.pose == "prone", "SetPoseMovement::ProneCrawlToProne "+self.a.pose);
	assert( (self.a.movement=="walk" || self.a.movement=="run"), "SetPoseMovement::ProneCrawlToProne "+self.a.movement);

//	ProneLegsStraightTree(0.1);
	self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
	PlayTransitionAnimation( animArray("crawl_2_aim"), "prone", "stop", 1 );

	self ClearAnim( %exposed_modern, 0.2 );
}

CrouchToProne()
{
	assert(self.a.pose == "crouch", "SetPoseMovement::CrouchToProne "+self.a.pose);
	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
	// guys who are walking and running, this is used for them too.
//	assert(self.a.movement == "stop", "SetPoseMovement::CrouchToProne "+self.a.movement);

	self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
	self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground

//	ProneLegsStraightTree(0.3);
	self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
	PlayTransitionAnimation( animArray("crouch_2_prone"), "prone", "stop", 1 );

	self ClearAnim( %exposed_modern, 0.2 );
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
	assert(self.a.pose == "stand", "SetPoseMovement::StandToProne "+self.a.pose);
	// I'd like to be able to assert that I'm stopped at this point, but until I get a better solution for 
	// guys who are walking and running, this is used for them too.
//	assert(self.a.movement == "stop", "SetPoseMovement::StandToProne "+self.a.movement);
//	self endon ("entered_pose" + "prone");

	const proneTime = 0.5; // was 1
	transAnim = animArray("stand_2_prone");

	thread PlayTransitionAnimationThread_WithoutWaitSetStates( transAnim, "prone", "stop", proneTime );
	
	self waittillmatch("transAnimDone2", "anim_pose = \"prone\"");
	waittillframeend; // so that the one in donotetracks gets hit first

	// cause the next pose is prone
	self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
	self EnterProneWrapper(proneTime); // make code start lerping in the prone orientation to ground
	self.a.movement = "stop";

	//ProneLegsStraightTree(0.2);
	//self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
	self waittillmatch("transAnimDone2", "end");

	self ClearAnim( %exposed_modern, 0.2 );
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
	assert((self.a.pose == "crouch")||(self.a.pose == "stand"), "SetPoseMovement::CrouchRunToProne "+self.a.pose);
	assert((self.a.movement == "run"||self.a.movement == "walk"), "SetPoseMovement::CrouchRunToProne "+self.a.movement);
	
	const pronetime = 0.5; // was 1
	self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
	self EnterProneWrapper(proneTime); // make code start lerping in the prone orientation to ground

//	ProneLegsStraightTree(0.2);
	self animscripts\cover_prone::UpdateProneWrapper( 0.1 );

	runDirection = animscripts\utility::getQuadrant ( self getMotionAngle() );
	
	diveanim = animArray("run_2_prone_dive", "move");

	localDeltaVector = GetMoveDelta (diveanim, 0, 1);
	endPoint = self LocalToWorldCoords( localDeltaVector );
	if (self maymovetopoint(endPoint))
	{
		PlayTransitionAnimation( diveanim, "prone", "stop", pronetime );
	}
	else
	{
		//thread [[anim.println]]("Can't dive to prone.");#/
		PlayTransitionAnimation( animArray("run_2_prone_gunsupport", "move"), "prone", "stop", pronetime );
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
	if (!IsDefined (rate))
		rate = 1;
	
/#
	if (GetDebugDvar("debug_animpose") == "on")
	{
		if (endPose != self.a.pose)
		{
			if (!animhasnotetrack(transAnim, "anim_pose = \"" + endPose + "\""))
			{
				println ("Animation ", transAnim, " lacks an endpose notetrack of ", endPose);
				assert(0, "A transition animation is missing a pose notetrack (see the line above)");
			}
		}
		if (endMovement != self.a.movement)
		{
			if (!animhasnotetrack(transAnim, "anim_movement = \"" + endMovement + "\""))
			{
				println ("Animation ", transAnim, " lacks an endmovement notetrack of ", endMovement);
				assert(0, "A transition animation is missing a movement notetrack (see the line above)");
			}
		}
	}
#/
	
	// Use a second thread to set the anim state halfway through the animation
	if (waitSetStatesEnabled)
	{
		self thread waitSetStates ( getanimlength(transAnim)/2.0, "killtimerscript", endPose);
	}

	// Play the anim
	// SetFlaggedAnimKnobAll(notifyName, anim, rootAnim, goalWeight, goalTime, rate) 
	self SetFlaggedAnimKnobAllRestart("transAnimDone2", transAnim, %body, 1, .2, rate);
	if (!IsDefined(self.a.pose))
	{
		self.pose = "undefined";
	}

	if (!IsDefined(self.a.movement))
	{
		self.movement = "undefined";
	}

	debugIdentifier = "";
	/#debugIdentifier = self.a.script+", "+self.a.pose+" to "+endPose+", "+self.a.movement+" to "+endMovement;#/
	self animscripts\shared::DoNoteTracks("transAnimDone2", undefined, debugIdentifier);

	// In case we finished earlier than we expected (eg the animation was already playing before we started), 
	// set the variables and kill the other thread.
	self notify ("killtimerscript");
	self.a.pose = endPose;
	self notify ("entered_pose" + endPose);

	self.a.movement = endMovement;
	
	if (IsDefined(finalAnim))
	{
		// SetFlaggedAnimKnobAll(notifyName, anim, rootAnim, goalWeight, goalTime, rate) 
		self SetAnimKnobAll(finalAnim, %body, 1, 0.3, rate);	// Set the animation instantly
	}
}

waitSetStates ( timetowait, killmestring, endPose )
{
	self endon("killanimscript");
	self endon ("death");
	self endon(killmestring);

	oldpose = self.a.pose;
	wait timetowait;

	// We called Enter/ExitProne before this function was called.  These lines should not be necessary, but 
	// for some reason the code is picking up that I'm setting pose from prone to crouch without calling 
	// exitprone().  I just hope it's not a thread leak I've missed.
	if ( oldpose!="prone" && endPose =="prone" )
	{
		self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
		self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
	}
	else if ( oldpose=="prone" && endPose !="prone" )
	{
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
		self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
	}
}

transitionToTacticalWalk( newPose )
{
	if ( newPose == self.a.pose )
		return;
	
	/#self animscripts\debug::debugPushState( "transitionTo: " + newPose );#/
	
	transAnim = animArray( self.a.pose + "_2_" + newPose, "combat" );
	if ( newPose == "stand" )
		rate = 2;
	else 
		rate = 1;
	
	self orientmode( "face enemy" );
	
	/#
	if ( !animHasNoteTrack( transAnim, "anim_pose = \"" + newPose + "\"" ) )
		println( "error: ^2 missing notetrack to set pose!", transAnim );
	#/
		
	self setFlaggedAnimKnobAllRestart( "trans", transanim, %body, 1, .3, rate );
	
	transTime = getAnimLength( transanim ) / rate;
	playTime = transTime - 0.2;
	if ( playTime < 0.2 )
		playTime = 0.2;
	
	self animscripts\shared::DoNoteTracksForTime( playTime, "trans" );
	
	self orientmode( "face default" );
	self ClearAnim( %exposed_modern, 0.2 );
	
	self.a.pose = newPose;
	/#self animscripts\debug::debugPopState( "transitionTo: " + newPose );#/
}