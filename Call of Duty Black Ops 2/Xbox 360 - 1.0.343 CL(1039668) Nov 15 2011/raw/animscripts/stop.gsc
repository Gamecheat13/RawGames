// "Stop" makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 

#include animscripts\combat_utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement; 
#include animscripts\anims; 

#using_animtree ("generic_human");

main()
{
	self notify("stopScript");
	self endon("killanimscript");

	/#
	if (GetDebugDvar("anim_preview") != "")
	{
		return;
	}
	#/

	self thread animscripts\utility::idleLookatBehavior(160, true);

	[[ self.exception[ "stop_immediate" ] ]]();
	// We do the exception_stop script a little late so that the AI has some animation they're playing
	// otherwise they'd go into basepose.
	thread delayedException();

	self trackScriptState( "Stop Main", "code" );
	animscripts\utility::initialize("stop");

	// MikeD (10/9/2007): Flamethrower should stop firing if stop::main() is called.
	self flamethrower_stop_shoot();

	self randomizeIdleSet();
	
	self thread setLastStoppedTime();
	self thread stanceChangeWatcher();
	
	transitionedToIdle = GetTime() < 3000;
	if ( !transitionedToIdle )
	{
		if ( self.a.weaponPos["right"] == "none" && self.a.weaponPos["left"] == "none" )
		{
			transitionedToIdle = true;
		}
		else if( self.weapon == "none" )
		{
			transitionedToIdle = true;
		}
		else if ( AngleClamp180( self GetTagAngles( "tag_weapon" )[0] ) > 20 )
		{
			transitionedToIdle = true;
		}
	}
	
	for(;;)
	{
		desiredPose = getDesiredIdlePose();
				
		if ( self.a.pose != desiredPose )
		{
			self ClearAnim( %root, 0.3 );
			transitionedToIdle = false;
		}
		
		self SetPoseMovement( desiredPose, "stop" );
		
		if ( self.a.pose != "prone" && !transitionedToIdle )
		{
			self thread transitionToIdle( /*desiredPose, self.a.idleSet*/ );
			transitionedToIdle = true;
			self waittill( "endIdle" );
		}
		else
		{
			self thread playIdle( desiredPose, self.a.idleSet );
			self waittill( "endIdle" );
		}
	}
}

stanceChangeWatcher()
{
	self endon("death");
	self endon("killanimscript");

	while(1)
	{
		desiredPose = getDesiredIdlePose();

		if( desiredPose != self.a.pose )
		{
			/#
			self animscripts\debug::debugPopState( "playIdle" );
			#/

			self notify("endIdle");
		}

		wait(0.1);
	}
}

setLastStoppedTime()
{
	self endon("death");
	self waittill("killanimscript");
	self.lastStoppedTime = GetTime();
}

getDesiredIdlePose()
{
		myNode = animscripts\utility::GetClaimedNode();
		if ( IsDefined( myNode ) )
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
//PARAMETER CLEANUP
transitionToIdle( /*pose, idleSet*/ )
{
	self endon("endIdle");
	self endon("killanimscript");

	/#self animscripts\debug::debugPushState( "transitionToIdle" );#/
	
	waittillframeend;

	special = "";
	if( self isCQB() && self.a.pose == "stand" )
	{
		special = "_cqb";
	}
	else if(self is_heavy_machine_gun() && self.a.pose == "stand" )
	{
		special = "_hmg";
	}

	self OrientMode( "face angle", self.angles[1] );
	
	if ( animArrayExist("idle_trans_in" + special) )
	{
		// TODO: do a gas weapon check to stop trans in		
		if (!self usingGasWeapon() )
		{
			idleAnim = animArray("idle_trans_in" + special);
			self SetFlaggedAnimKnobAllRestart( "idle_transition", idleAnim, %body, 1, .3, self.animplaybackrate );
			self animscripts\shared::DoNoteTracks("idle_transition");
		}
	}

	/#self animscripts\debug::debugPopState( "transitionToIdle" );#/
	
	self notify("endIdle");
}
		
playIdle( pose, idleSet )
{
	self endon("endIdle");
	self endon("killanimscript");
	
	/#self animscripts\debug::debugPushState( "playIdle" );#/
	
	waittillframeend;

	if( pose == "prone" )
	{
		self ProneStill();

		/#self animscripts\debug::debugPopState( "playIdle" );#/

		self notify("endIdle");
		return;
	}

	special = "";
	if( self isCQB() && self.a.pose == "stand" )
	{
		special = "_cqb";
	}
	else if(self is_heavy_machine_gun() )
	{
		special = "_hmg";
	}

	// find the idle set
	idleAnimSetArray = animArray( "idle" + special );

	assert( idleAnimSetArray.size > 0 );

	idleSet = idleSet % idleAnimSetArray.size;

	// anims in that particular set
	idleAnimArray = idleAnimSetArray[idleSet];

	assert( idleAnimArray.size > 0 );

	// pick a random one
	idleAnim = idleAnimArray[ RandomIntRange( 0, idleAnimArray.size ) ];

	transTime = 0.2;
	if( GetTime() == self.a.scriptStartTime )
	{
		transTime = 0.5;
	}

	self OrientMode( "face angle", self.angles[1] );
	
	self SetFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, transTime, self.animplaybackrate );
	self animscripts\shared::DoNoteTracks("idle");

	/#self animscripts\debug::debugPopState( "playIdle" );#/

	self notify("endIdle");
}
	
ProneStill()
{
	/#self animscripts\debug::debugPushState( "ProneStill" );#/

	if( self.a.pose != "prone" )
	{
		transAnim = animArray( self.a.pose + "_2_prone" );
		assert( IsDefined( transAnim ), self.a.pose );
		assert( animHasNotetrack( transAnim, "anim_pose = \"prone\"" ) );
		
		self SetFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, 1.0 );
		animscripts\shared::DoNoteTracks( "trans" );
		
		assert( self.a.pose == "prone" );
		self.a.movement = "stop";
		
		self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );

		/#self animscripts\debug::debugPopState( "ProneStill" );#/

		return; // in case we need to change our pose again for whatever reason
	}

	if( 0 )
	{
		twitchAnim = animArrayPickRandom("twitch");
		self SetFlaggedAnimKnobAll( "prone_idle", twitchAnim, %prone_modern, 1, 0.2 );
	}
	else
	{
		self SetAnim( animArray("straight_level"), 1, 0.2 );
		self SetFlaggedAnimKnob( "prone_idle", animArrayPickRandom("idle")[0], 1, 0.2 ); // (additive idle on top)
	}

	wait(0.05);
	self thread UpdateProneThread();

	self waittillmatch( "prone_idle", "end" );

	self notify ("kill UpdateProneThread");

	/#self animscripts\debug::debugPopState( "ProneStill" );#/
}

UpdateProneThread()
{
	self endon ("killanimscript");
	self endon ("kill UpdateProneThread");
	self endon ("endIdle");

	for (;;)
	{
		self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
		wait 0.1;
	}
}

delayedException()
{
	self endon("killanimscript");
	wait (0.05);
	[[ self.exception[ "stop" ] ]]();
}


//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}