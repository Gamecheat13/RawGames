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
	
	self.iswounded = false;
	
	MoveInit();
	MoveMainLoop();
}

end_script()
{
}

MoveInit()
{
	/#self animscripts\debug::debugPushState( "MoveInit" );#/
		
	// face the movement direction first
	tryTurning();
	
	animscripts\bigdog\bigdog_combat::hunkerUp();
	
	/#self animscripts\debug::debugPopState();#/
}

//--------------------------------------------------------------------------------
// Main move loop
//--------------------------------------------------------------------------------
MoveMainLoop()
{
	/#self animscripts\debug::debugPushState( "MoveMainLoop" );#/
		
	prevLoopTime			= self getAnimTime( %walk_loops );
	self.a.runLoopCount		= RandomInt( 10000 ); // integer that is incremented each time we complete a run loop

	for (;;)
	{
		// break out if a leg was blown off
		if( !self.canMove )
		{
			animscripts\bigdog\bigdog_combat::main();
			return;
		}
		
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
			if( self.lookaheaddist > 32 && tryTurning() )
				continue;
			
			self OrientMode( "face default" );
				
			animName = GetMoveAnimName();					
			self SetFlaggedAnimKnob("runanim", animArray(animName + "_f" + animSuffix), 1, 0.5, self.moveplaybackrate);
		}

		animscripts\shared::DoNoteTracksForTime(0.05, "runanim");
	}
	
	/#self animscripts\debug::debugPopState();#/
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
	return "walk";
}

tryTurning()
{	
	if( !self.canMove )
		return false;
	
	angleDiff = self animscripts\run::GetLookaheadAngle();
	
	// wait a few frames for lookahead to stabilize a bit
	if( abs(angleDiff) > self.turnAngleThreshold )
	{
		self OrientMode( "face angle", self.angles[1] );
		self AnimMode( "zonly_physics", false );
	
		// play idle in the meantime
		animName = animscripts\bigdog\bigdog_combat::getIdleAnimName();

		self SetFlaggedAnimRestart( "idle", animArray(animName, "stop"), 1, 0.2, 1 );
		
		wait( 0.5 );
		
		angleDiff = self animscripts\run::GetLookaheadAngle();
	}
	
	// do the actual turn
	return animscripts\bigdog\bigdog_combat::turn( anglediff );
	
	/*
	initialGoalPos = self.pathgoalpos;
	
	while( self.canMove )
	{		
		// do the actual turn
		animscripts\bigdog\bigdog_combat::turn( anglediff );
		
		angleDiff = self animscripts\run::GetLookaheadAngle();
		
		// if the path has changed, break out
		currentGoalPos = self.pathgoalpos;
		if( DistanceSquared( initialGoalPos, currentGoalPos ) > 16 )
			break;
	}
	*/
}