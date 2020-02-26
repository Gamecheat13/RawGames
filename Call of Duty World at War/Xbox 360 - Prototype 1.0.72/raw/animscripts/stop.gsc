// "Stop" makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 

#include animscripts\combat_utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement; 
#using_animtree ("generic_human");

main()
{
	self notify("stopScript");
	self endon("killanimscript");
	/#
	if (getdebugdvar("anim_preview") != "")
		return;
	#/

	[[ self.exception[ "stop_immediate" ] ]]();
	// We do the exception_stop script a little late so that the AI has some animation they're playing
	// otherwise they'd go into basepose.
	thread delayedException();

	self trackScriptState( "Stop Main", "code" );
	animscripts\utility::initialize("stop");

	transitionedIntoIdle = false;
	
	for(;;)
	{
		myNode = animscripts\utility::GetClaimedNode();
		if ( isDefined( myNode ) )
		{
			myNodeAngle = myNode.angles[1];
			myNodeType = myNode.type;
		}
		else
		{
			myNodeAngle = self.desiredAngle;
			myNodeType = "node was undefined";
		}
		
		self animscripts\face::SetIdleFace(anim.alertface);

		// Find out if we should be standing, crouched or prone
		desiredPose = animscripts\utility::choosePose();

		if ( myNodeType == "Cover Stand" || myNodeType == "Conceal Stand" )
		{
			// At cover_stand nodes, we don't want to crouch since it'll most likely make our gun go through the wall.
			desiredPose = animscripts\utility::choosePose("stand");
		}
		else if ( myNodeType == "Cover Crouch" || myNodeType == "Conceal Crouch")
		{
			// We should crouch at concealment crouch nodes.
			desiredPose = animscripts\utility::choosePose("crouch");
		}
		else if ( myNodeType == "Cover Prone" || myNodeType == "Conceal Prone" )
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
			transitionedIntoIdle = self CrouchStillThink(transitionedIntoIdle);
		}
		else
		{
			assert( desiredPose == "prone" );
			self ProneStill();
		}
	}
}

StandStillThink(transitionedIntoIdle)
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
	else
	{
		if ( 
			(self.a.pose != "stand") || (self.a.movement != "stop") || (self.a.alertness == "aiming") || 
			( (self.a.idleSet != "a") && (self.a.idleSet != "b") ) 
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
			assertEX(self.a.idleSet=="a" || self.a.idleSet=="b", "stop::standStill: anim_idleSet isn't a or b, it's "+self.a.idleSet);
			idleSet = self.a.idleSet;
		}
		
		transitionedIntoIdle = poseIdle(transitionedIntoIdle, "stand", idleSet);
		
		if ( nowTime == gettime() )
		{
			print ("stand alert animation finished instantly!!!!");
			wait 0.2;
		}
	}
	
	return transitionedIntoIdle;
}


poseIdle(transitionedIntoIdle, pose, idleSet)
{
	self.a.idleSet = idleSet;
	self SetPoseMovement(pose, "stop");
	
	if ( self isCQBWalking() && self.a.pose == "stand" && self IsInCombat() )
	{
		// special cqb idle
		idleAnimArray		= anim.idleAnimArray[ pose ][ "cqb" ];
		idleAnimWeights		= anim.idleAnimWeights[ pose ][ "cqb" ];
		transitionArray		= anim.idleTransArray[ pose ][ "cqb" ];
		subsetAnimArray		= anim.subsetAnimArray[ pose ][ "cqb" ];
		subsetAnimWeights	= anim.subsetAnimWeights[ pose ][ "cqb" ];
	}
	else if ( isdefined(self.node) && isdefined(self.node.script_stack) )
	{
		if (weaponAnims() == "pistol")
		{
			idleAnimArray		= anim.pistolStackIdleAnimArray[pose][idleSet];
			idleAnimWeights		= anim.pistolStackIdleAnimWeights[pose][idleSet];
			transitionArray		= anim.pistolStackIdleTransArray[pose][idleSet];
			subsetAnimArray		= anim.pistolStackSubsetAnimArray[pose][idleSet];
			subsetAnimWeights	= anim.pistolStackSubsetAnimWeights[pose][idleSet];
		}
		else
		{
			idleAnimArray		= anim.stackIdleAnimArray[pose][idleSet];
			idleAnimWeights		= anim.stackIdleAnimWeights[pose][idleSet];
			transitionArray		= anim.stackIdleTransArray[pose][idleSet];
			subsetAnimArray		= anim.stackSubsetAnimArray[pose][idleSet];
			subsetAnimWeights	= anim.stackSubsetAnimWeights[pose][idleSet];
		}
	}
	else
	{
		idleAnimArray		= anim.idleAnimArray[pose][idleSet];
		idleAnimWeights		= anim.idleAnimWeights[pose][idleSet];
		transitionArray		= anim.idleTransArray[pose][idleSet];
		subsetAnimArray		= anim.subsetAnimArray[pose][idleSet];
		subsetAnimWeights	= anim.subsetAnimWeights[pose][idleSet];
	}
	
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


CrouchStillThink(transitionedIntoIdle)
{
//	for (;;)
//	{
	if (!self animscripts\utility::holdingWeapon())
	{
		unarmed_crouch_idle();
	}
	else
	{
		if ( 
			(self.a.pose != "crouch") || (self.a.movement != "stop") || (self.a.alertness == "aiming") || 
			( (self.a.idleSet != "a") && (self.a.idleSet != "b") ) 
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
			assertEX( self.a.idleSet=="a" || self.a.idleSet=="b", "stop::CrouchStill: anim_idleSet isn't a or b, it's "+self.a.idleSet);
			idleSet = self.a.idleSet;
		}
		transitionedIntoIdle = poseIdle(transitionedIntoIdle, "crouch", idleSet);
	}
	return transitionedIntoIdle;
}

ProneStill()
{
	self SetPoseMovement("prone","stop");

	for (;;)
	{
		self setAnimKnobAll (%prone_aim_idle, %body, 1, 0.1, 1);
		myCurrentYaw = self.angles[1];
		angleDelta = AngleClamp180( self.desiredangle - myCurrentYaw );
		if ( angleDelta > 5 )
		{
			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
			self thread UpdateProneThread();
			self animscripts\shared::DoNoteTracks("turn anim");
			self notify ("kill UpdateProneThread");
			self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
		}
		else if ( angleDelta < -5 )
		{
			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
			self thread UpdateProneThread();
			self animscripts\shared::DoNoteTracks("turn anim");
			self notify ("kill UpdateProneThread");
			self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
		}
		else 
		{
			self setanimknob(%prone_aim_idle, 1, .1, 1);
//			if ( self.desiredangle - myCurrentYaw > 1 || self.desiredangle - myCurrentYaw < -1 )
//			{
				self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
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
		self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
		wait 0.1;
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
	[[ self.exception[ "stop" ] ]]();
}
