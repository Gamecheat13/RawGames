#include animscripts\anims;
#include animscripts\utility;
#include animscripts\bigdog\bigdog_utility;
#include maps\_utility;
#include common_scripts\utility;

#using_animtree ("bigdog");

main()
{
	self endon("killanimscript");
	
	// stay in combat if it can't move anymore
	if( !self.canMove )
	{
		animscripts\bigdog\bigdog_combat::main();
		return;
	}
	
	animscripts\bigdog\bigdog_utility::initialize("move");
	
	MoveInit();
	MoveMainLoop();
}

end_script()
{
}

MoveInit()
{
	if( self.lookaheadDist > 350 )
		return;
	
	// face the movement direction first
	tryTurning( 10 );
}

//--------------------------------------------------------------------------------
// Main move loop
//--------------------------------------------------------------------------------
MoveMainLoop()
{
	prevLoopTime			= self getAnimTime( %walk_loops );
	self.a.runLoopCount		= RandomInt( 10000 ); // integer that is incremented each time we complete a run loop

	for (;;)
	{
		loopTime = self getAnimTime( %walk_loops );
		if ( loopTime < prevLoopTime )
			self.a.runLoopCount++;

		prevLoopTime = loopTime;

		animName = "walk";
		animSuffix = animSuffix();

		self OrientMode( "face default" );
		self AnimMode( "none", false );
		
		//recordEntText("reldir: " + self.relativedir, self, (1,1,1), "Animscript" );

		if( ShouldTacticalWalk() )
		{				
			walkAnimName	= animName + "_" + anim.moveGlobals.relativeDirAnimMap[self.relativedir] + animSuffix;
			walkAnim = animArrayPickRandom( walkAnimName, "move", true );

			self SetFlaggedAnimKnob("runanim", walkAnim, 1, 0.5, self.moveplaybackrate);
		}
		else
		{
			if( self.lookaheaddist > 32 && tryTurning( 60 ) )
				continue;
			
			if( ShouldWalkBackwards() )
			{
				faceDir		= VectorScale(self.lookaheaddir, -1);
				faceAngle	= VectorToAngles(faceDir)[1]; 
				self OrientMode( "face angle", faceAngle );	

				self SetFlaggedAnimKnob("runanim", animArray(animName + "_b" + animSuffix), 1, 0.5, self.moveplaybackrate);
			}
			else
			{
				self OrientMode( "face default" );
				
				animName = GetMoveAnimName();					
				self SetFlaggedAnimKnob("runanim", animArray(animName + "_f" + animSuffix), 1, 0.5, self.moveplaybackrate);
			}
		}

		animscripts\shared::DoNoteTracksForTime(0.05, "runanim");
	}
}

ShouldTacticalWalk()
{
	/* disabled for now until I have time to do it properly
	if( IsDefined( self.pathGoalPos ) )
	{
		if( !self ShouldFaceMotionWhileRunning() )
			return true;
	}
	*/

	return false;
}

ShouldFaceMotionWhileRunning()
{
	// if code thinks that we should not be facing motion then respect that.
	// this will be usually true within maxFaceEnemyDistSq which is set to 512 units.
	if( self ShouldFaceMotion() )
		return true;

	return false;
}

ShouldWalkBackwards()
{
	angleDiff = self animscripts\run::GetLookaheadAngle();
	
	if( abs( angleDiff ) > 135 )
	{
		return true;
	}

	return false;
}

GetMoveAnimName()
{
	// move slow if a leg's missing
	if( self.missingLegs.size > 0 )
		return "walk";
	
	if( self.sprint )
		return "trot";
	
	return "walk";
}

tryTurning( angleThreshold )
{
	if( !self.canMove )
		return false;
	
	angleDiff = self animscripts\run::GetLookaheadAngle();
	moveBackwards = false;
	
	// turn the opposite way if walking backwards
	if( ShouldWalkBackwards() )
	{
		moveBackwards = true;
		
		// adjust the angle depending on whether we're walking forward or backward
		angleDiff = AbsAngleClamp180(angleDiff - 180) * sign(angleDiff) * -1;
	}
	
	// don't turn unless it's a big angle
	if( abs(angleDiff) <= angleThreshold )
		return false;
	
	initialGoalPos = self.pathgoalpos;
	
	while( abs(angleDiff) > 10 )
	{		
		// do the actual turn
		animscripts\bigdog\bigdog_combat::turn( anglediff );
		
		angleDiff = self animscripts\run::GetLookaheadAngle();
		
		// adjust the angle depending on whether we're walking forward or backward
		if( moveBackwards )
			angleDiff = AbsAngleClamp180(angleDiff - 180) * sign(angleDiff) * -1;
		
		// if the path has changed, break out
		currentGoalPos = self.pathgoalpos;
		if( DistanceSquared( initialGoalPos, currentGoalPos ) > 16 )
			break;
	}
	
	return true;
}