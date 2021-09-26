// "Stop" makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 

#include animscripts\combat_utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement; 
#using_animtree ("generic_human");

main()
{
	self endon("killanimscript");
	/#
	if (getdebugcvar("anim_preview") != "")
		return;
	#/

	[[self.exception_stop_immediate]]();
	// We do the exception_stop script a little late so that the AI has some animation they're playing
	// otherwise they'd go into basepose.
	thread delayedException();


    self trackScriptState( "Stop Main", "code" );
	animscripts\utility::initialize("stop");

	// If I'm wounded, I act differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::rest("stop::main");
	}

	animscripts\exposedCombat::panzerGuyShootsTarget();

	transitionedIntoIdle = false;

	for(;;)
	{
		myNode = animscripts\utility::GetClaimedNode();
		if (isDefined(myNode))
		{
			myNodeAngle = myNode.angles[1];
			myNodeType = myNode.type;
		}
		else
		{
			myNodeAngle = self.desiredAngle;
			myNodeType = "node was undefined";
		}
		//println ("Node type is "+myNodeType);
		
		self animscripts\face::SetIdleFace(anim.alertface);

		// Find out if we should be standing, crouched or prone
		desiredPose = animscripts\utility::choosePose();

		if (myNodeType == "Cover Left")
		{
			if ( (!self isStanceAllowed("crouch")) && (!self isStanceAllowed("stand")) )
			{
				/#
				println("Stop script at Cover_left node: Can't stand or crouch at corner!");
				println (" Entity: " + (self getEntityNumber()) );
				println (" Origin: "+self.origin);
				#/
				desiredPose = "crouch";
			}
			if ( desiredPose == "stand" )
			{
				self CoverLeftStandStill(myNodeAngle, "At cover left node");
			}
			else
			{
				self CoverLeftCrouchStill(myNodeAngle, "At cover left node");
			}
		}
		else if (myNodeType == "Cover Right")
		{
			if ( (!self isStanceAllowed("crouch")) && (!self isStanceAllowed("stand")) )
			{
				/#
				println("Stop script at Cover_right node: Can't stand or crouch at corner!");
				println (" Entity: " + (self getEntityNumber()) );
				println (" Origin: "+self.origin);
				#/
				desiredPose = "crouch";
			}
			if ( desiredPose == "stand" )
			{
				self CoverRightStandStill(myNodeAngle, "At cover right node");
			}
			else
			{
				self CoverRightCrouchStill(myNodeAngle, "At cover right node");
			}
		}
		else if (myNodeType == "Cover Crouch")
		{
			self animscripts\cover_crouch_no_wall::idle_start();
			for (;;)
			{
				self animscripts\cover_crouch_no_wall::idle();
			}
		}
		// TODO any other cases here
		else
		{
			if ( (myNodeType == "Cover Stand") || (myNodeType == "Conceal Stand") )
			{
				// At cover_stand nodes, we don't want to crouch since it'll most likely make our gun go through the wall.
				desiredPose = animscripts\utility::choosePose("stand");
			}
			else if (myNodeType == "Conceal Crouch")
			{
				// We should crouch at concealment crouch nodes.
				desiredPose = animscripts\utility::choosePose("crouch");
			}
			else if ( (myNodeType == "Cover Prone") || (myNodeType == "Conceal Prone") )
			{
				// We should go prone at prone nodes.
				desiredPose = animscripts\utility::choosePose("prone");
			}
			if ( desiredPose == "stand" )
			{
				transitionedIntoIdle = self StandStillThink(transitionedIntoIdle);
			}
			else if ( desiredPose == "crouch" )
			{
				transitionedIntoIdle = CrouchStillThink(transitionedIntoIdle);
			}
			else if ( desiredPose == "prone" )
			{
				self ProneStill();
			}
			else
			{
				assertEX(0, "stop::main - unhandled desired pose "+desiredPose);
			}
		}

		// To find an infinite loop in Stop script:
		//debugstoploopguy = self GetEntNum();
		//if ( isDefined(anim.debugstoploopguy) && (debugstoploopguy == anim.debugstoploopguy) )
		//{
		//	if (!isDefined(anim.debugstoplooptimes))
		//		anim.debugstoplooptimes=0;
		//	anim.debugstoplooptimes++;
		//}
		//else
		//{
		//	anim.debugstoplooptimes = 0;
		//}
		//anim.debugstoploopguy = debugstoploopguy;
		//if (anim.debugstoplooptimes > 20)
		//{
		//	println("Detected the infinite loop on guy ",debugstoploopguy);
		//	anim.debugEnt = self;
		//	SetCvar ("animscriptent", debugstoploopguy);
		//}
	}
}

playStandingIdle()
{
	// The guy looks like he's aiming in this animation so we'll set his alertness to aiming.
	self.anim_alertness = "aiming";
	if (self animscripts\utility::weaponAnims() == "pistol")
		self setFlaggedAnimKnobAllRestart("idleanim", %pistol_standaim_idle, %body, 1, .1, 1);
	else
	{
		rand = randomint(100);
		if (rand<25)
			self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop1, %body, 1, .1, 1);
		else 
		if (rand<50)
			self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop2, %body, 1, .1, 1);
		else 
		if (rand<75)
			self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop3, %body, 1, .1, 1);
		else
			self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop4, %body, 1, .1, 1);
	}	
	self animscripts\shared::DoNoteTracks ("idleanim");
}

StandStillThink(transitionedIntoIdle)
{
//	for (;;)
//	{
//	if ( self animscripts\utility::IsInCombat() )
	if ( 0 )
	{
		self SetPoseMovement("stand","stop");
//			animscripts\aim::aim(0);
//			assertEX ( (self.anim_movement == "stop")&&(self.anim_pose=="stand")&&(self.anim_alertness=="aiming"), "stop::StandStill: About to call aim, movement is "+self.anim_movement);
		reload(0.3);
		playStandingIdle();
	}
	else
	{
		nowTime = gettime();

		if ( isDefined(self.standanim) )
		{
			self setFlaggedAnimKnobAllRestart("idleanim", self.standanim, %body, 1, .1, 1);
			self animscripts\shared::DoNoteTracks("idleanim");
		}
		else if (self animscripts\utility::weaponAnims() == "pistol")
		{
			self setFlaggedAnimKnobAllRestart("idleanim", %pistol_standaim_idle, %body, 1, .1, 1);
			self animscripts\shared::DoNoteTracks("idleanim");
		}
		else if ( (GetTime() < self.anim_woundedTime) || (self.anim_woundedAmount > 0.5) )
		{
			StandStill_wounded();
		}
		else
		{
			if ( 
				(self.anim_pose != "stand") || (self.anim_movement != "stop") || (self.anim_alertness == "aiming") || 
				( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
				)
			{
				// Decide which idle animation to do
				if (randomint(100)<50)
					idleSet = "a";
				else
					idleSet = "b";
			}
			else
			{
				assertEX(self.anim_idleSet=="a" || self.anim_idleSet=="b", "stop::standStill: anim_idleSet isn't a or b, it's "+self.anim_idleSet);
				idleSet = self.anim_idleSet;
			}
			
			transitionedIntoIdle = poseIdle(transitionedIntoIdle, "stand", idleSet);

			if ( nowTime == gettime() )
			{
				print ("stand alert animation finished instantly!!!!");
				wait 0.2;
			}
		}
	}
	
	return transitionedIntoIdle;
//	}
}


poseIdle(transitionedIntoIdle, pose, idleSet)
{
	self.anim_idleSet = idleSet;
	self SetPoseMovement(pose, "stop");
	if (isdefined(self.node) && isdefined(self.node.script_stack))
	{
		if (weaponAnims() == "pistol")
		{
			idleAnimArray =		anim.pistolStackIdleAnimArray[pose][idleSet];
			idleAnimWeights =	anim.pistolStackIdleAnimWeights[pose][idleSet];
			transitionArray =	anim.pistolStackIdleTransArray[pose][idleSet];
			subsetAnimArray =	anim.pistolStackSubsetAnimArray[pose][idleSet];
			subsetAnimWeights =	anim.pistolStackSubsetAnimWeights[pose][idleSet];
		}
		else
		{
			idleAnimArray =		anim.stackIdleAnimArray[pose][idleSet];
			idleAnimWeights =	anim.stackIdleAnimWeights[pose][idleSet];
			transitionArray =	anim.stackIdleTransArray[pose][idleSet];
			subsetAnimArray =	anim.stackSubsetAnimArray[pose][idleSet];
			subsetAnimWeights =	anim.stackSubsetAnimWeights[pose][idleSet];
		}
	}
	else
	{
		idleAnimArray = anim.idleAnimArray[pose][idleSet];
		if (fatGuy() && self.anim_pose == "stand")
		{
			size = idleAnimArray.size;
			idleAnimArray = [];
			for (i=0;i<size;i++)
				idleAnimArray[i] = %stand_Alert_1_fat;
		}
		idleAnimWeights = anim.idleAnimWeights[pose][idleSet];
		transitionArray = anim.idleTransArray[pose][idleSet];
		subsetAnimArray = anim.subsetAnimArray[pose][idleSet];
		subsetAnimWeights = anim.subsetAnimWeights[pose][idleSet];
	}

	reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	
	
	if (subsetAnimArray.size)
	{
		assert (transitionArray.size);
		
		// Have a random chance to transition into the subset animations
		if (randomint(100) > 60)
		{
			transitionedIntoIdle = !transitionedIntoIdle;
			if (transitionedIntoIdle)
			{
				// Transition into the subset
				self setFlaggedAnimKnobAllRestart("poseIdle", transitionArray[0], %body, 1, .1, self.animplaybackrate);
			}
			else
			{
				// Transition out of the subset
				self setFlaggedAnimKnobAllRestart("poseIdle", transitionArray[1], %body, 1, .1, self.animplaybackrate);
			}
				
			self animscripts\shared::DoNoteTracks ("poseIdle");
		}
		
		if (transitionedIntoIdle)
		{
			// Play a subset animation since we've transitioned in
			self setFlaggedAnimKnobAllRestart("poseIdle", anim_array(subsetAnimArray, subsetAnimWeights), %body, 1, .1, self.animplaybackrate);
		}
		else	
		{
			// Play a regular idle since we are not transitioned in
			self setFlaggedAnimKnobAllRestart("poseIdle", anim_array(idleAnimArray, idleAnimWeights), %body, 1, .3, self.animplaybackrate);
		}
	}
	else
	{
		// There is no subset animation
		
		if ((!transitionedIntoIdle) && (transitionArray.size))
		{
			// we have a transition animation so we have to play that first before we can play the idles
			self setFlaggedAnimKnobAllRestart("poseIdle", transitionArray[0], %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("poseIdle");
			transitionedIntoIdle = true;
		}
		
		// Now we can play a random idle animation
		self setFlaggedAnimKnobAllRestart("poseIdle", anim_array(idleAnimArray, idleAnimWeights), %body, 1, .1, self.animplaybackrate);
	}

	// Each possibility ends with playing an animation, so now we have to wait for it to finish	
	self animscripts\shared::DoNoteTracks ("poseIdle");
	return transitionedIntoIdle;
}


StandStill_wounded()
{
	self.anim_idleSet = "w";
	self SetPoseMovement("stand","stop");

	reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	

	randNum = randomint (100);
	if (randNum<70)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %wounded_woundedalert_idle, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %wounded_woundedalert_twitch, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
}

oldStandStill_a(transitionedIntoIdle)
{
	self.anim_idleSet = "a";
	self SetPoseMovement("stand","stop");

	reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	
	
	// Play transition animation if one exists and you havent transitioned yet
	if ((isdefined (anim.standing_idle_transition)) && (!transitionedIntoIdle))
	{
		self setFlaggedAnimKnobAllRestart("animdone", anim.standing_idle_transition[0], %body, 1, .3, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("animdone");
		transitionedIntoIdle = true;
	}
	
	self setFlaggedAnimKnobAllRestart("animdone", anim_array(anim.standing_idle, anim.standing_idle_weights), %body, 1, .3, self.animplaybackrate);
	/*
	// setflaggedanimknoballrestart(notifyName, anim, rootAnim, goalWeight, goalTime, rate)
	randNum = randomint (100);
	if (randNum<30)
		self setFlaggedAnimKnobAllRestart("animdone", anim.standing_idle[0], %body, 1, .3, self.animplaybackrate);
	else if (randNum<65)
		self setFlaggedAnimKnobAllRestart("animdone", anim.standing_idle[1], %body, 1, .3, self.animplaybackrate);
	else
		self setFlaggedAnimKnobAllRestart("animdone", anim.standing_idle[2], %body, 1, .3, self.animplaybackrate);
	//		self setFlaggedAnimKnobAllRestart("animdone", %stand_alert_1, %body, 1, .1, self.animplaybackrate);
	*/
	
	self animscripts\shared::DoNoteTracks ("animdone");
	return transitionedIntoIdle;
}

oldStandStill_b(transitionedIntoIdle)
{
	self.anim_idleSet = "b";
	self SetPoseMovement("stand","stop");

	reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	

	// Play transition animation if one exists and you havent transitioned yet
	if ((isdefined (anim.standing_idleB_transition)) && (!transitionedIntoIdle))
	{
		self setFlaggedAnimKnobAllRestart("animdone", anim.standing_idleB_transition[0], %body, 1, .3, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("animdone");
		transitionedIntoIdle = true;
	}
	
	self setFlaggedAnimKnobAllRestart("animdone", anim_array(anim.standing_idleB, anim.standing_idleB_weights), %body, 1, .3, self.animplaybackrate);
/*
	randNum = randomint (100);
	if (randNum<70)
		self setFlaggedAnimKnobAllRestart("animdone", anim.standing_idleB[0], %body, 1, .3, self.animplaybackrate);
	else
		self setFlaggedAnimKnobAllRestart("animdone", anim.standing_idleB[1], %body, 1, .3, self.animplaybackrate);
*/	
	self animscripts\shared::DoNoteTracks ("animdone");
}


oldCrouchStill_a(transitionedIntoIdle)
{
	self.anim_idleSet = "a";
	self SetPoseMovement("crouch","stop");

	reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	

	if ((isdefined (anim.crouching_idle_transition)) && (!transitionedIntoIdle))
	{
		self setFlaggedAnimKnobAllRestart("animdone", anim.crouching_idle_transition[0], %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("animdone");
		transitionedIntoIdle = true;
	}
	
	self setFlaggedAnimKnobAllRestart("animdone", anim_array(anim.standing_idle, anim.standing_idle_weights), %body, 1, .3, self.animplaybackrate);

	randNum = randomint (100);
	if (randNum<70)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_A_idle, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_A_twitch, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
}

oldCrouchStill_b()
{
	self.anim_idleSet = "b";
	self SetPoseMovement("crouch","stop");

	reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	

	randNum = randomint (100);
	if (randNum<70)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_B_idle1, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_B_twitch1, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
}


CrouchStillThink(transitionedIntoIdle)
{
//	for (;;)
//	{
	if (!self animscripts\utility::hasWeapon())
		unarmed_crouch_idle();
	else 
	if (self animscripts\utility::weaponAnims() == "pistol")
	{
		self setFlaggedAnimKnobAllRestart("idleanim", %pistol_crouchaim_idle, %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("idleanim");
	}
	else 
	if ( self animscripts\utility::IsInCombat() )
	{
		self SetPoseMovement("crouch","stop");
		reload(0.3);

		// Play a crouch aim animation.  Aim flat so we don't end up aiming through the ceiling at an 
		// unseen enemy.  Blend in the straight portion of it slowly so that if we were aiming at the 
		// ceiling, we won't suddenly pop to a straight pose.
		self setAnimKnobAll(%crouch_aim_straight, %body, 1, .2, 1);
		self setFlaggedAnimKnobRestart("idleanim", %crouch_aim_straight, 1, .4, 1);
		self animscripts\shared::DoNoteTracks("idleanim");
	}
	else
	{
		if ( 
			(self.anim_pose != "crouch") || (self.anim_movement != "stop") || (self.anim_alertness == "aiming") || 
			( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
			)
		{
			// Decide which idle animation to do
			if (randomint(100)<50)
				idleSet = "a";
			else
				idleSet = "b";
		}
		else
		{
			assertEX( self.anim_idleSet=="a" || self.anim_idleSet=="b", "stop::CrouchStill: anim_idleSet isn't a or b, it's "+self.anim_idleSet);
			idleSet = self.anim_idleSet;
		}
		transitionedIntoIdle = poseIdle(transitionedIntoIdle, "crouch", idleSet);
		/*
		if (idleSet == "a")
			transitionedIntoIdle = CrouchStill_a(transitionedIntoIdle);
		else
			transitionedIntoIdle = CrouchStill_b(transitionedIntoIdle);
		*/			
	}
	return transitionedIntoIdle;
//	}
}

ProneStill()
{
	self SetPoseMovement("prone","stop");

	reload(0.25);

	for (;;)
	{
		self setAnimKnobAll (%prone_aim_idle, %body, 1, 0.1, 1);
		myCurrentYaw = self.angles[1];
		angleDelta = animscripts\utility::AngleClamp(self.desiredangle - myCurrentYaw, "-180 to 180");
		if ( angleDelta > 5 )
		{
			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
			self thread UpdateProneThread();
			self animscripts\shared::DoNoteTracks("turn anim");
			self notify ("kill UpdateProneThread");
//			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
		}
		else if ( angleDelta < -5 )
		{
			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
			self thread UpdateProneThread();
			self animscripts\shared::DoNoteTracks("turn anim");
			self notify ("kill UpdateProneThread");
//			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
		}
		else 
		{
			self setanimknob(%prone_aim_idle, 1, .1, 1);
//			if ( self.desiredangle - myCurrentYaw > 1 || self.desiredangle - myCurrentYaw < -1 )
//			{
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
//			}
			wait 1;
		}
	}
}

UpdateProneThread()
{
	self endon ("killanimscript");
	self endon ("death");
	self endon ("kill UpdateProneThread");

	for (;;)
	{
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
		wait 0.1;
	}
}


CoverLeftStandStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverLeftStandStill", changeReason );

	if ( 
		(self.anim_pose != "stand") || (self.anim_movement != "stop") || (self.anim_special != "cover_left") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]-15);
		if ( angleDifference <= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (idleSet == "a")
		CoverLeftStandStill_a(cornerAngle);
	else
		CoverLeftStandStill_b(cornerAngle);

	self trackScriptState( entryState , "CoverLeftStandStill returned" );
}

CoverLeftStandStill_a(cornerAngle)
{
	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%corner_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	reload(0.5, %reload_cornera_stand_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAllRestart("standanim",%cornerstandpose_right, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim_right_15left, %body, 1, .1, self.animplaybackrate);
			wait ( 2 + randomfloat(2) );
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerstandlook_right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
	}
}

CoverLeftStandStill_b(cornerAngle)
{
	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	reload(0.5, %reload_cornerb_stand_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_stand_alert_idle_right, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim_right_15left, %body, 1, .1, self.animplaybackrate);
			wait ( 2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert_look_right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		self OrientMode( "face angle", cornerAngle+90 );
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
	}
}


CoverLeftCrouchStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverLeftCrouchStill", changeReason );
	if ( 
		(self.anim_pose != "crouch") || (self.anim_movement != "stop") || (self.anim_special != "cover_left") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]-15);
		if ( angleDifference <= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (!self animscripts\utility::hasWeapon())
	{
		unarmed_crouch_idle();
	}
	else if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		if (idleSet == "a")
			CoverLeftCrouchStill_Pistol_a();
		else
			CoverLeftCrouchStill_Pistol_b();
	}
	else
	{
		if (idleSet == "a")
			CoverLeftCrouchStill_a(cornerAngle);
		else
			CoverLeftCrouchStill_b(cornerAngle);
	}
	self trackScriptState( entryState , "CoverLeftCrouchStill returned" );
}

CoverLeftCrouchStill_Pistol_a()
{
	// Just play the first frame of the transition.  TODO - use correct anim
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverA2crouchaim, %body, 1, .1, 0);
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverLeftCrouchStill_Pistol_b()
{
	// Just play the first frame of the transition.  TODO - use correct anim
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverB2crouchaim, %body, 1, .1, 0);
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverLeftCrouchStill_a(cornerAngle)
{

	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	reload(0.5, %reload_cornera_crouch_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornercrouchpose_right, %body, 1, .1, 1);
		wait ( 2 + randomfloat(4) );

		self setFlaggedAnimKnobAllRestart("crouchanim",%corner_crouch_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("crouchanim");
		self setFlaggedAnimKnobAllRestart("crouchanim",%corner_crouch_aim_right_15left, %body, 1, .1, 1);
		wait ( 2 + randomfloat(1) );
		self setFlaggedAnimKnobAllRestart("crouchanim",%corner_crouch_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}

CoverLeftCrouchStill_b(cornerAngle)
{
	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	reload(0.5, %reload_cornerb_crouch_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_crouch_alert_idle_right, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim_right_15left, %body, 1, .1, 1);
			wait ( 2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_alert_twitch1_right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		self OrientMode( "face angle", cornerAngle+90 );
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}


CoverRightStandStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverRightStandStill", changeReason );

	if ( 
		(self.anim_pose != "stand") || (self.anim_movement != "stop") || (self.anim_special != "cover_right") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]+15);
		if ( angleDifference >= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (idleSet == "a")
		CoverRightStandStill_a(cornerAngle);
	else
		CoverRightStandStill_b(cornerAngle);

	self trackScriptState( entryState , "CoverRightStandStill returned" );
}

CoverRightStandStill_a(cornerAngle)
{
	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%corner_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "stand";

	reload(0.5,  %reload_cornera_stand_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAllRestart("standanim",%cornerstandpose_left, %body, 1, .1, 1);
		wait ( 2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim_left_15right, %body, 1, .1, self.animplaybackrate);
			wait ( 2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerstandlook_left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
	}
}

CoverRightStandStill_b(cornerAngle)
{
	self.anim_idleSet = "b";
	self.anim_special = "cover_right";

	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "stand";

	reload(0.5, %reload_cornerb_stand_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_stand_alert_idle_left, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim_left_15right, %body, 1, .1, self.animplaybackrate);
			wait ( 2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert_look_left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		self OrientMode( "face angle", cornerAngle-90 );
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
	}
}


CoverRightCrouchStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverRightCrouchStill", changeReason );
	if ( 
		(self.anim_pose != "crouch") || (self.anim_movement != "stop") || (self.anim_special != "cover_right") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]+15);
		if ( angleDifference >= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (!self animscripts\utility::hasWeapon())
	{
		unarmed_crouch_idle();
	}
	else if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		if (idleSet == "a")
			CoverRightCrouchStill_Pistol_a();
		else
			CoverRightCrouchStill_Pistol_b();
	}
	else
	{
		if (idleSet == "a")
			CoverRightCrouchStill_a(cornerAngle);
		else
			CoverRightCrouchStill_b(cornerAngle);
	}
	self trackScriptState( entryState , "CoverRightCrouchStill returned" );
}

CoverRightCrouchStill_Pistol_a()
{
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverA2crouchaim, %body, 1, .1, 0);	// TODO - use correct anim
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverRightCrouchStill_Pistol_b()
{
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverB2crouchaim, %body, 1, .1, 0);	// TODO - use correct anim
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverRightCrouchStill_a(cornerAngle)
{
	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "crouch";

	reload(0.5, %reload_cornera_crouch_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornercrouchpose_left, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(3) );

		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_aim_left_15right, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(1) );
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}

CoverRightCrouchStill_b(cornerAngle)
{
	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProneWrapper(0.5); // In case we were in Prone.
	self.anim_pose = "crouch";

	reload(0.5, %reload_cornerb_crouch_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_crouch_alert_idle_left, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(1) );

		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim_left_15right, %body, 1, .1, self.animplaybackrate);
		wait ( 2 + randomfloat(1) );
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}


unarmed_crouch_idle()
{
//	for (;;)
//	{
		self setFlaggedAnimKnobAll("crouchanim",%unarmed_crouch_idle1, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("crouchanim");

		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAll("crouchanim",%unarmed_crouch_twitch1, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("crouchanim");
		}
//	}
}

delayedException()
{
	self endon("killanimscript");
	wait (0.05);
	[[self.exception_stop]]();
}
