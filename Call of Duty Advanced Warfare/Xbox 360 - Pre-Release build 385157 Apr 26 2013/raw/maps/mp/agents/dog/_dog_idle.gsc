#include maps\mp\agents\_scriptedAgents;

main()
{
	self.animSubstate = "none";

	self ScrAgentSetGoalPos( self.origin );

	self UpdateState();
}

end_script()
{
	// clean up idle state.
}

UpdateState()
{
	self endon( "killanimscript" );

	while ( true )
	{
		nextState = self DetermineState();
		if ( nextState != self.animSubstate )
			self EnterState( nextState );

		self UpdateAngle();

		switch ( self.animSubstate )
		{
		case "idle_combat":
			//self SetAnimState( "idle_combat" );	// can we add weights to animstates in state machine?
			wait ( 0.2 );
			break;
		case "idle_noncombat":
			//self SetAnimState( "idle_noncombat" );
			wait ( 0.2 );
			break;
		default:
			assertmsg( "unknown dog stop state " + self.animSubstate );
			break;
		}
	}
}


DetermineState()
{
	if ( ShouldAttackIdle() )
		return "idle_combat";
	else
		return "idle_noncombat";
}


EnterState( state )
{
	self ExitState( self.animSubstate );
	self.animSubstate = state;
	switch ( state )
	{
	case "idle_combat":
		self SetAnimState( "idle" );
		break;
	case "idle_noncombat":
		self SetAnimState( "idle" );
		break;
	default:
		assertmsg( "unknown dog stop state " + state );
		break;
	}
}


ExitState( prevState )
{
}


UpdateAngle()
{
	faceTarget = undefined;
	if ( IsDefined( self.enemy ) && DistanceSquared( self.enemy.origin, self.origin ) < 1024 * 1024 )
		faceTarget = self.enemy;
	else if ( IsDefined( self.owner ) )
		faceTarget = self.owner;

	if ( IsDefined( faceTarget ) )
	{
		meToTarget = faceTarget.origin - self.origin;
		meToTargetAngles = VectorToAngles( meToTarget );

		self TurnToAngle( meToTargetAngles[1] );
	}
}


PlayAttackIdle()
{
	// bark, growl, idle_b... based on cansee enemy? O_o
}

shouldAttackIdle()
{
	return isdefined( self.enemy )
		&& isalive( self.enemy )
		&& distanceSquared( self.origin, self.enemy.origin ) < 1000000;
		//&& self SeeRecently( self.enemy, 5 );
}

TurnToAngle( desiredAngle )
{
	currentAngle = self.angles[1];
	angleDiff = AngleClamp180( desiredAngle - currentAngle );

	if ( -10 < angleDiff && angleDiff < 10 )
	{
		RotateToAngle( desiredAngle, 2 );
		return;
	}

	// this is an angry looking turn, may not be appropriate for non-combat idle.
	if ( angleDiff < 0 )	// ccw45
		animState = "turn_left_45";
	else	// cw45
		animState = "turn_right_45";

	//turnAnim = self GetAnimEntry( animState, 0 );
	//animLength = GetAnimLength( turnAnim );

	//maxTurnSpeed = self ScrAgentGetMaxTurnSpeed();
	//turnTime = abs(angleDiff) / maxTurnSpeed;
	//turnTime /= 1000;
	//rate = animLength / turnTime;

	angles = ( 0, desiredAngle, 0 );
	self ScrAgentSetOrientMode( "face angle abs", angles );

	self PlayAnimUntilNotetrack( animState, "turn_in_place", "code_move" );

	self SetAnimState( "idle" );
}

RotateToAngle( desiredAngle, tolerance )
{
	if ( AngleClamp180( desiredAngle - self.angles[1] ) <= tolerance )
		return;

	angles = ( 0, desiredAngle, 0 );

	self ScrAgentSetOrientMode( "face angle abs", angles );

	while ( AngleClamp180( desiredAngle - self.angles[1] ) > tolerance )
		wait ( 0.1 );
}

/*
main()
{
	self endon( "killanimscript" );

	self clearanim( %root, 0.1 );
	self clearanim( %german_shepherd_idle, 0.2 );
	self clearanim( %german_shepherd_attackidle_knob, 0.2 );

	self thread lookAtTarget( "attackIdle" );

	while ( 1 )
	{
		if ( shouldAttackIdle() )
		{
			self clearanim( %german_shepherd_idle, 0.2 );
			self randomAttackIdle();
		}
		else
		{
			if ( IsDefined( self.handler ) )
			{
				if ( IsDefined( self.handler.node ) && IsDefined( self.node ) )
				{
					meToHandler = self.handler.origin - self.origin;
					TurnToAngle( VectorToYaw( meToHandler ) );
				}
				else if ( DistanceSquared( self.origin, self.handler.origin ) < 4096 )
				{
					self TurnToAngle( self.handler.angles[1] );
				}
			}
			self orientmode( "face current" );
			self clearanim( %german_shepherd_attackidle_knob, 0.2 );
			self setflaggedanimrestart( "dog_idle", %german_shepherd_idle, 1, 0.2, self.animplaybackrate );
		}

		animscripts\shared::DoNoteTracks( "dog_idle" );

		if ( isdefined( self.prevTurnRate ) )
		{
			self.turnRate = self.prevTurnRate;
			self.prevTurnRate = undefined;
		}
	}
}


TurnToAngle( desiredAngle )
{
	currentAngle = self.angles[1];
	angleDiff = AngleClamp180( desiredAngle - currentAngle );

	if ( -10 < angleDiff && angleDiff < 10 )
	{
		RotateToAngle( desiredAngle, 2 );
		return;
	}

	if ( angleDiff < 0 )	// ccw45
		turnAnim = %german_shepherd_rotate_ccw;
	else	// cw45
		turnAnim = %german_shepherd_rotate_cw;

	animLength = GetAnimLength( turnAnim );

	turnTime = abs(angleDiff) / self.turnRate;
	turnTime /= 1000;
	rate = animLength / turnTime;

	self OrientMode( "face angle", desiredAngle );

	self SetFlaggedAnimRestart( "dog_turn", turnAnim, 1, 0.2, rate );
	animscripts\shared::DoNoteTracks( "dog_turn" );
	// self scr_setanimsubstate( dog turn anim );

	self ClearAnim( turnAnim, 0.2 );
}


RotateToAngle( desiredAngle, tolerance )
{
	self OrientMode( "face angle", desiredAngle );
	while ( AngleClamp( desiredAngle - self.angles[1] ) > tolerance )
		wait ( 0.1 );
}


isFacingEnemy( toleranceCosAngle )
{
	assert( isdefined( self.enemy ) );

	vecToEnemy = self.enemy.origin - self.origin;
	distToEnemy = length( vecToEnemy );

	if ( distToEnemy < 1 )
		return true;

	forward = anglesToForward( self.angles );

	return( ( forward[ 0 ] * vecToEnemy[ 0 ] ) + ( forward[ 1 ] * vecToEnemy[ 1 ] ) ) / distToEnemy > toleranceCosAngle;
}

randomAttackIdle()
{
	self clearanim( %german_shepherd_attackidle_knob, 0.1 );
	if ( isFacingEnemy( 0.866 ) )	// cos30
	{
		self OrientMode( "face angle", self.angles[1] );
	}
	else
	{
		if ( isdefined( self.enemy ) )
		{
			yawToEnemy = vectorToYaw( self.enemy.origin - self.origin );
			localYawToEnemy = AngleClamp180( yawToEnemy - self.angles[1] );
 			if ( Abs( localYawToEnemy ) > 10 )
			{
				self orientmode( "face enemy" );
				self.prevTurnRate = self.turnRate;
				self.turnRate = 0.3;

				if ( localYawToEnemy > 0)
				{
 					rotateAnim = %german_shepherd_rotate_ccw;
 				}
 				else
 				{
 					rotateAnim = %german_shepherd_rotate_cw;
 				}
				self setflaggedanimrestart( "dog_turn", rotateAnim, 1, 0.2, 1.0 );
				animscripts\shared::DoNoteTracks( "dog_turn" );

				self.turnRate = self.prevTurnRate;
				self.prevTurnRate = undefined;
				self clearanim( %german_shepherd_rotate_cw, 0.2 );
				self clearanim( %german_shepherd_rotate_ccw, 0.2 );
			}
		}
		self OrientMode( "face angle", self.angles[1] );
	}

	if ( should_growl() )
	{
		// just growl
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_growl, 1, 0.2, 1 );
		return;
	}

	idleChance = 33;
	barkChance = 66;

	if ( isdefined( self.mode ) )
	{
		if ( self.mode == "growl" )
		{
			idleChance = 15;
			barkChance = 30;
		}
		else if ( self.mode == "bark" )
		{
			idleChance = 15;
			barkChance = 85;
		}
	}

	rand = randomInt( 100 );
	if ( rand < idleChance )
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_b, 1, 0.2, self.animplaybackrate );
	else if ( rand < barkChance )
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_bark, 1, 0.2, self.animplaybackrate );
	else
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_growl, 1, 0.2, self.animplaybackrate );
}

should_growl()
{
	if ( isdefined( self.script_growl ) )
		return true;
	if ( !isalive( self.enemy ) )
		return true;
	return !( self cansee( self.enemy ) );
}

lookAtTarget( lookPoseSet )
{
	self endon( "killanimscript" );
	self endon( "stop tracking" );

	self clearanim( %german_shepherd_look_2, 0 );
	self clearanim( %german_shepherd_look_4, 0 );
	self clearanim( %german_shepherd_look_6, 0 );
	self clearanim( %german_shepherd_look_8, 0 );

	self setDefaultAimLimits();
	self.rightAimLimit = 90;
	self.leftAimLimit = -90;

	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 2 ], 1, 0 );
	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 4 ], 1, 0 );
	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 6 ], 1, 0 );
	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 8 ], 1, 0 );

	self animscripts\track::setAnimAimWeight( 1, 0.2 );

/#	
	assert( !isdefined( self.trackLoopThread ) );
	self.trackLoopThread = thisthread;
	self.trackLoopThreadType = "lookAtTarget";
#/
	
	self animscripts\track::trackLoop( %german_shepherd_look_2, %german_shepherd_look_4, %german_shepherd_look_6, %german_shepherd_look_8 );
}
*/