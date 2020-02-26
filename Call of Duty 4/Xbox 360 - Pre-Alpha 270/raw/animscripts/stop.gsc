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
	
	self randomizeIdleSet();
	
	transitionedToIdle = gettime() < 3000;
	
	for(;;)
	{
		desiredPose = getDesiredIdlePose();
		
		if ( desiredPose == "prone" )
		{
			transitionedToIdle = true;
			self ProneStill();
		}
		else
		{
			assertex( desiredPose == "crouch" || desiredPose == "stand", desiredPose );
			
			if ( !transitionedToIdle )
			{
				self transitionToIdle( desiredPose, self.a.idleSet );
				transitionedToIdle = true;
			}
			else
			{
				self playIdle( desiredPose, self.a.idleSet );
			}
		}
	}
}

getDesiredIdlePose()
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
	
	return desiredPose;
}

transitionToIdle( pose, idleSet )
{
	self SetPoseMovement( pose, "stop" );
	
	if ( self isCQBWalking() && self.a.pose == "stand" && self IsInCombat() )
		pose = "stand_cqb";
	
	if ( isdefined( anim.idleAnimTransition[pose] ) )
	{
		assert( isdefined( anim.idleAnimTransition[pose]["in"] ) );
		
		idleAnim = anim.idleAnimTransition[pose]["in"];
		self setFlaggedAnimKnobAllRestart( "idle_transition", idleAnim, %body, 1, .1, self.animplaybackrate );
		self animscripts\shared::DoNoteTracks ("idle_transition");
	}
}

playIdle( pose, idleSet )
{
	self SetPoseMovement( pose, "stop" );
	
	if ( self isCQBWalking() && self.a.pose == "stand" && self IsInCombat() )
		pose = "stand_cqb";
	
	idleSet = idleSet % anim.idleAnimArray[pose].size;
	
	idleAnim = anim_array( anim.idleAnimArray[pose][idleSet], anim.idleAnimWeights[pose][idleSet] );
	
	self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, self.animplaybackrate );
	self animscripts\shared::DoNoteTracks ("idle");
}

// This is kind of old.
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

delayedException()
{
	self endon("killanimscript");
	wait (0.05);
	[[ self.exception[ "stop" ] ]]();
}
