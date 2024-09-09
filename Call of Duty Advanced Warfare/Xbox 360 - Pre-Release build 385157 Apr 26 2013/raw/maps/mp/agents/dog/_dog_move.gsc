#include common_scripts\utility;
#include maps\mp\agents\_scriptedAgents;

main()
{
	self endon( "killanimscript" );

	self.moveMode = "run";

	self.bLockGoalPos = false;

	self StartMove();
	self ContinueMovement();
}

end_script()
{
	self.bLockGoalPos = false;
	self CancelAllBut( undefined );
}

SetupMovement()
{
	self thread WaitForRunWalkChange();
	self thread WaitForHardTurn();
	self thread WaitForStop();
	//self thread WaitForStopEarly();
}

ContinueMovement()
{
	self SetupMovement();

	self ScrAgentSetOrientMode( "face motion" );
	self SetAnimState( self.moveMode );
	//if ( self.a.movement == "run" )
	//	self SetAnimState( "dog_run" );
	//else
	//	self SetAnimState( "dog_walk" );
}

WaitForRunWalkChange()
{
	self endon( "dogmove_endwait_runwalk" );
	curMovement = self.moveMode;
	while ( true )
	{
		if ( curMovement != self.moveMode )
		{
			self SetAnimState( self.moveMode );
			curMovement = self.moveMode;
		}
		wait( 0.1 );
	}
}

WaitForHardTurn()
{
	self endon( "dogmove_endwait_hardturn" );

	self waittill( "path_dir_change", newDir );
	self CancelAllBut( "hardturn" );

	lookaheadAngles = VectorToAngles( newDir );
	angleDiff = AngleClamp180( lookaheadAngles[1] - self.angles[1] );
	angleIndex = GetAngleIndex( angleDiff );

	if ( angleIndex == 4 )		// do i want getanimentry to return undefined instead?
		return;

	animState = "hard_turn_" + angleIndex;

	turnAnim = self GetAnimEntry( animState, 0 );
	animAngleDelta = GetAngleDelta( turnAnim );
	animAngleDiff = angleDiff - animAngleDelta;

	self ScrAgentSetAnimMode( "anim deltas" );
	self ScrAgentSetOrientMode( "face angle abs", ( 0, animAngleDiff + self.angles[1], 0 ) );

	self PlayAnimUntilNotetrack( animState, "hard_turn", "code_move" );

	self ScrAgentSetAnimMode( "code_move" );
	self ScrAgentSetOrientMode( "face motion" );
	self ContinueMovement();
}

WaitForStop()
{
	self endon( "dogmove_endwait_stop" );

	self waittill( "stop_soon" );
	self CancelAllBut( "stop" );

	stopState = self GetStopAnimState();
	stopAnim = self GetAnimEntry( stopState, 0 );
	stopDelta = GetMoveDelta( stopAnim );
	stopAngleDelta = GetAngleDelta( stopAnim );

	stopData = self GetStopData();
	stopStartPos = self CalcAnimStartPos( stopData.pos, stopData.angles[1], stopDelta, stopAngleDelta );
	stopStartPos = GetGroundPosition( stopStartPos, 15, 64, 64 );

	traceStart = stopData.pos + (0, 0, 12);
	traceEnd = stopStartPos + (0, 0, 12);
	traceEndPos = PlayerPhysicsTrace( traceStart, traceEnd );
	if ( DistanceSquared( traceEndPos, traceEnd ) > 1 )
		return;

	//		self thread WaitForPathSetWhileStopping();		// do i want this outside? so i can cancel his stop anim if necessary...
	if ( DistanceSquared( stopStartPos, self.origin ) > 4 )
	{
		self thread WaitForPathSetWhileStopping();

		self ScrAgentSetWaypoint( stopStartPos );
		self waittill( "waypoint_reached" );
	}

	self SetAnimState( stopState );

	// idle state should kick in at some point...
	// self waittill( "hellfreezesover" );

	// note to self: don't get lazy! there are cases where he doesn't quite make it to his
	// destination after playing his stop anim, after which his animation stops.
}

WaitForPathSetWhileStopping()
{
	self endon( "killanimscript" );
	self endon( "dogmove_endwait_pathsetwhilestopping" );

	oldGoalPos = self ScrAgentGetGoalPos();

	self waittill( "path_set" );

	newGoalPos = self ScrAgentGetGoalPos();

	if ( DistanceSquared( oldGoalPos, newGoalPos ) < 1 )
	{
		self thread WaitForPathSetWhileStopping();
		return;
	}

	self notify( "dogmove_endwait_stop" );

	self ContinueMovement();
}

WaitForStopEarly()
{
	self endon( "killanimscript" );
	self endon( "dogmove_endwait_stopearly" );

	stopAnim = self GetAnimEntry( "move_stop_4", 0 );
	stopAnimTranslation = GetMoveDelta( stopAnim );
	stoppingDistance = Length( stopAnimTranslation );
	offset = self.preferredOffsetFromOwner + stoppingDistance;
	offsetSq = offset * offset;

	if ( DistanceSquared( self.origin, self.owner.origin ) <= offsetSq )
		return;

	while ( true )
	{
		if ( !IsDefined( self.owner ) )
			break;

		if ( DistanceSquared( self.origin, self.owner.origin ) < offsetSq )
		{
			stopPos = self LocalToWorldCoords( stopAnimTranslation );
			self ScrAgentSetGoalPos( stopPos );
			break;
		}

		wait( 0.1 );
	}
}

CancelAllBut( doNotCancel )
{
	cleanups = [ "runwalk", "hardturn", "stop", "pathsetwhilestopping", "stopearly" ];

	bCheckDoNotCancel = IsDefined( doNotCancel );

	foreach ( cleanup in cleanups )
	{
		if ( bCheckDoNotCancel && cleanup == doNotCancel )
			continue;
		self notify( "dogmove_endwait_" + cleanup );
	}
}

StartMove()
{
	self.bLockGoalPos = true;

	lookaheadDir = self GetLookaheadDir();
	lookaheadAngles = VectorToAngles( lookaheadDir );
	angleDiff = AngleClamp180( lookaheadAngles[1] - self.angles[1] );
	angleIndex = GetAngleIndex( angleDiff );
	self PlayAnimUntilNotetrack( "move_start_" + angleIndex, "move_start", "code_move" );

	self.bLockGoalPos = false;
}

// -180, -135, -90, -45, 0, 45, 90, 135, 180
// favor underturning, unless you're within <threshold> degrees of the next one up.
GetAngleIndex( angle, threshold )
{
	if ( !IsDefined( threshold ) )
		threshold = 10;

	if ( angle < 0 )
		return int( ceil( ( 180 + angle - threshold ) / 45 ) );
	else
		return int( floor( ( 180 + angle + threshold ) / 45 ) );
}

GetStopData()
{
	stopData = SpawnStruct();

	if ( IsDefined( self.node ) )
	{
		stopData.pos = self.node.origin;
		stopData.angles = self.node.angles;
	}
	else
	{
		pathGoalPos = self GetPathGoalPos();
		assert( IsDefined( pathGoalPos ) );
		stopData.pos = pathGoalPos;
		stopData.angles = self.angles;
	}

	return stopData;
}

GetStopAnimState( angle )
{
	if ( IsDefined( self.node ) )
	{
		angleDiff = self.node.angles[1] - self.angles[1];
		angleIndex = GetAngleIndex( angleDiff );
	}
	else
	{
		angleIndex = 4;
	}

	return "move_stop_" + angleIndex;
}

CalcAnimStartPos( stopPos, stopAngle, animDelta, animAngleDelta )
{
	dAngle = stopAngle - animAngleDelta;
	angles = ( 0, dAngle, 0 );
	vForward = AnglesToForward( angles );
	vRight = AnglesToRight( angles );

	forward = vForward * animDelta[0];
	right = vRight * animDelta[1];

	return stopPos - forward + right;
}

Dog_AddLean()
{
	leanFrac = Clamp( self.leanAmount / 25.0, -1, 1 );
	if ( leanFrac > 0 )
	{
		// set lean left( leanFrac );
		// set lean right( 0 );
	}
	else
	{
		// set lean left( 0 );
		// set lean right( 0 - leanFrac );
	}
}




/*

AdjustPlaybackRate()
{
	if ( IsDefined( self.handler ) && IsDefined( self.command ) )
	{
		if ( self.command == "attack" )
		{
			if ( self IsDogInPursuitOfEnemy() )
				self.movePlaybackRate = 0.9;
			else
				self.movePlaybackRate = 0.58;
		}
		else if ( self.command == "follow" )
		{
			defaultMoveRate = 0.58;
			moveMultiplier = 1;

			handlerForward = AnglesToForward( self.handler.angles );
			handlerToMe = self.origin - self.handler.origin;
			distInFrontOfHandler = VectorDot( handlerForward, handlerToMe );

			myLookaheadDir = self.lookaheadDir;
			myLookaheadDist = self.lookaheadDist;
			myLookaheadPos = self.origin + myLookaheadDir * myLookaheadDist;
			if ( IsAI( self.handler ) )
				handlerLookahead = self.handler.lookaheadDir;
			else
				handlerLookahead = handlerForward;
			handlerLookaheadPerp = ( handlerLookahead[ 1 ], 0-handlerLookahead[ 0 ], 0 );
			//handlerToMyLookahead = myLookaheadPos - self.handler.origin;
			distFromHandlerLookahead = VectorDot( handlerLookaheadPerp, handlerToMe );

			if ( abs( distFromHandlerLookahead ) < 50 )
			{	// i'm closer than i want to be to my handler.  either speed the heck up to get out of his way,
				// so slow the heck down to get out of his way.
				if ( 0 < distInFrontOfHandler && distInFrontOfHandler < 36 )
					moveMultiplier *= 1.2;
				else if ( -60 < distInFrontOfHandler && distFromHandlerLookahead < 0 )
					moveMultiplier *= 0.8;
			}
			else if ( distInFrontOfHandler > 12 )
				moveMultiplier *= 0.8;
			else if ( distInFrontOfHandler < -24 )
				moveMultiplier *= 1.2;

			self.moveplaybackrate = defaultMoveRate * moveMultiplier;
		}
	}
}


moveLoopStep()
{
	self endon( "move_loop_restart" );
	
	if ( self.a.movement == "run" )
	{
		self AdjustPlaybackRate();

		weights = self getRunAnimWeights();

		self clearanim( %german_shepherd_walk, 0.3 );

		self setanim( %german_shepherd_run, weights[ "center" ], 0.2, 1 );
		self setanim( %german_shepherd_run_lean_L, weights[ "left" ], 0.1, 1 );
		self setanim( %german_shepherd_run_lean_R, weights[ "right" ], 0.1, 1 );
		self setflaggedanimknob( "dog_run", %german_shepherd_run_knob, 1, 0.2, self.moveplaybackrate );

		DoNoteTracksForTime( 0.2, "dog_run" );
	}
	else
	{
		assert( self.a.movement == "walk" );

		self clearanim( %german_shepherd_run_knob, 0.3 );
		self setflaggedanim( "dog_walk", %german_shepherd_walk, 1, 0.2, self.moveplaybackrate );
		DoNoteTracksForTime( 0.2, "dog_walk" );
	}
}

pathChangeCheck()
{
	// this looks for acute differences between the model visual yaw and its velocity
	self endon( "killanimscript" );

	self.ignorePathChange = undefined;	// this will be turned on / off in other threads at appropriate times

	while ( 1 )
	{
		if (( self.lookaheaddist > 40 )
		  &&( !isdefined( self.moveLoopOverrideFunc ) )
		  &&( !isdefined( self.ignorePathChange ) )
		  &&( !isdefined( self.noTurnAnims ) )
		  &&( self.a.movement == "run" ) )
		{
			pathYaw = vectorToYaw( self.lookaheaddir );
			angleDiff = AngleClamp180( self.angles[ 1 ] - pathYaw );

			turnAnim = pathChange_getDogTurnAnim( angleDiff );
			if ( isdefined( turnAnim ) )
			{
				self.turnAnim = turnAnim;
				self.turnTime = getTime();
				self.moveLoopOverrideFunc = ::pathChange_doDogTurnAnim;
				
				self notify( "move_loop_restart" );
			}
		}
		wait 0.05;
	}
}

pathChange_getDogTurnAnim( angleDiff )
{
	turnAnim = undefined;
	
	if ( angleDiff < -135 )
	{
		turnAnim = %german_shepherd_run_start_180_L;
	}
	else if ( angleDiff > 135 )
	{
		turnAnim = %german_shepherd_run_start_180_R;
	}
	else if ( angleDiff < -60 )
	{
		turnAnim = %german_shepherd_run_start_L;
	}
	else if ( angleDiff > 60 )
	{
		turnAnim = %german_shepherd_run_start_R;
	}
	
	return turnAnim;
}


pathChange_doDogTurnAnim()
{
	self endon( "killanimscript" );
	
	self.moveLoopOverrideFunc = undefined;
	
	turnAnim = self.turnAnim;
	
	if ( gettime() > self.turnTime + 50 )
		return; // too late
	
	self animMode( "zonly_physics", false );
	self clearanim( %root, 0.2 );
	
	self.moveLoopCleanupFunc = ::pathChange_cleanupDogTurnAnim;
	
	self.ignorePathChange = true;
		
	self setflaggedanimrestart( "turnAnim", turnAnim, 1, 0.2, self.movePlaybackRate );
	self OrientMode( "face current" );

	// code move at 20%
	playTime = getanimlength( turnAnim ) / self.movePlaybackRate;
	self DoNoteTracksForTime( playTime * 0.20, "turnAnim" );

	self OrientMode( "face motion" );	// want to face motion, don't do l / r / b anims
	self animmode( "none", false );

	prevTurnRate = self.turnRate;
	self.turnRate = 0.4;

	// cut off at 85%
	self DoNoteTracksForTime( playTime * 0.65, "turnAnim" );

	self.turnRate = prevTurnRate;

	self.ignorePathChange = undefined;
}

pathChange_cleanupDogTurnAnim()
{
	self.ignorePathChange = undefined;
	
	self OrientMode( "face default" );
	self clearanim( %root, 0.2 );
	self animMode( "none", false );
}

startMoveTrackLookAhead()
{
	self endon( "killanimscript" );
	for ( i = 0; i < 2; i++ )
	{
		lookaheadAngle = vectortoangles( self.lookaheaddir );
		self OrientMode( "face angle", lookaheadAngle );
	}
}


// -180, -135, -90, -45, 0, 45, 90, 135, 180
// favor underturning, unless you're within 10 degrees of the next one up.
Dog_GetAngleIndex( angle )
{
	if ( angle < 0 )
		return int( ceil( ( 180 + angle - 10 ) / 45 ) );
	else
		return int( floor( ( 180 + angle + 10 ) / 45 ) );
}


playMoveStartAnim()
{
	self endon( "move_loop_restart" );

	if ( self.lookaheaddist == 0 )
	{
		self thread pathChangeCheck();
		return;
	}

	endPos = self.origin;
	// 0.6 to match 60% code move start below
	startAnimDistance = anim.dogStartMoveDist * 0.6;
	endPos += ( self.lookaheaddir * startAnimDistance );

	tooClose = distanceSquared( self.origin, self.pathgoalpos ) < startAnimDistance * startAnimDistance;

	lookaheadAngle = vectortoangles( self.lookaheaddir );
	if ( !tooClose && self mayMoveToPoint( endPos ) )
	{
		angle = AngleClamp180( lookaheadAngle[ 1 ] - self.angles[ 1 ] );
		index = Dog_GetAngleIndex( angle );
	
		if ( !IsDefined( anim.dogStartMoveAnim[ index ] ) )
			return;

		self setanimrestart( anim.dogStartMoveAnim[ index ], 1, 0.2, self.movePlaybackRate );

		animEndAngle = self.angles[ 1 ] + anim.dogStartMoveAngles[ index ];
		offsetAngle = AngleClamp180( lookaheadAngle[ 1 ] - animEndAngle );
		
		self OrientMode( "face angle", self.angles[ 1 ] + offsetAngle );
		self animMode( "zonly_physics", false );
		
		// code move at 60%
		playTime = getanimlength( anim.dogStartMoveAnim[ index ] ) / self.movePlaybackRate;
		self DoNoteTracksForTime( playTime * 0.60, "turnAnim" );

		self OrientMode( "face motion" );	// want to face motion, don't do l / r / b anims
		self animmode( "none", false );

		self thread pathChangeCheck();

		// cut off at 85%
		self DoNoteTracksForTime( playTime * 0.25, "turnAnim" );
	}
	else
	{
		self OrientMode( "face angle", lookaheadAngle[ 1 ] );
		self animMode( "none" );
		self.prevTurnRate = self.turnRate;
		self.turnRate = 0.5;

		localYawToMoveDir = AngleClamp180( lookaheadAngle[ 1 ] - self.angles[ 1 ] );
		if ( Abs( localYawToMoveDir ) > 20 )
		{
			if ( localYawToMoveDir > 0)
			{
 				rotateAnim = %german_shepherd_rotate_ccw;
 			}
 			else
 			{
 				rotateAnim = %german_shepherd_rotate_cw;
 			}
			self setflaggedanimrestart( "dog_turn", rotateAnim, 1, 0.2, 1.0 );
			animscripts\shared::DoNoteTracks( "dog_turn" );

			self clearanim( %german_shepherd_rotate_cw, 0.2 );
			self clearanim( %german_shepherd_rotate_ccw, 0.2 );
		}

		self thread pathChangeCheck();

		self.turnRate = self.prevTurnRate;
		self.prevTurnRate = undefined;

		self OrientMode( "face motion" );
	}
}

startMove()
{
	if ( isdefined( self.pathgoalpos ) )
	{
		self playMoveStartAnim();
		self clearanim( %root, 0.2 );
		return;
	}

	// just use code movement
	self OrientMode( "face default" );
	self setflaggedanimknobrestart( "dog_prerun", %german_shepherd_run_start, 1, 0.2, self.moveplaybackrate );

	self animscripts\shared::DoNoteTracks( "dog_prerun" );

	self animMode( "none", false );
	
	self clearanim( %root, 0.2 );
}


stopMove()
{
	self endon( "killanimscript" );
	self endon( "run" );	// from code Actor_PathEndActions

	self clearanim( %german_shepherd_run_knob, 0.1 );
	self setflaggedanimrestart( "stop_anim", %german_shepherd_run_stop, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "stop_anim" );
}


dogPlaySoundAndNotify( sound, notifyStr )
{
	self play_sound_on_tag_endon_death( sound, "tag_eye" );
	if ( isalive( self ) )
		self notify( notifyStr );
}

randomSoundDuringRunLoop()
{
	self endon( "killanimscript" );
	
	wait 0.2; // incase move script gets killed right away
	
	while ( 1 )
	{
/#
		if ( getdebugdvar( "debug_dog_sound" ) != "" )
			iprintln( "dog " + ( self getentnum() ) + " bark start " + getTime() );
#/
		sound = undefined;
		if ( isdefined( self.script_growl ) )
			sound = "anml_dog_growl";
		else if ( !isdefined( self.script_nobark ) )
			sound = "anml_dog_bark";
			
		if ( !isdefined( sound ) )
			break;
		
		self thread dogPlaySoundAndNotify( sound, "randomRunSound" );
		self waittill( "randomRunSound" );
/#
		if ( getdebugdvar( "debug_dog_sound" ) != "" )
			iprintln( "dog " + ( self getentnum() ) + " bark end " + getTime() );
#/

		wait( randomfloatrange( 0.1, 0.3 ) );
	}
}


getRunAnimWeights()
{
	weights = [];
	weights[ "center" ] = 0;
	weights[ "left" ] = 0;
	weights[ "right" ] = 0;

	if ( self.leanAmount > 0 )
	{
		if ( self.leanAmount < 0.95 )
			self.leanAmount	 = 0.95;

		weights[ "left" ] = 0;
		weights[ "right" ] = ( 1 - self.leanAmount ) * 20;

		if ( weights[ "right" ] > 1 )
			weights[ "right" ] = 1;
		else if ( weights[ "right" ] < 0 )
			weights[ "right" ] = 0;

		weights[ "center" ] = 1 - weights[ "right" ];
	}
	else if ( self.leanAmount < 0 )
	{
		if ( self.leanAmount > - 0.95 )
			self.leanAmount	 = -0.95;

		weights[ "right" ] = 0;
		weights[ "left" ] = ( 1 + self.leanAmount ) * 20;

		if ( weights[ "left" ] > 1 )
			weights[ "left" ] = 1;
		if ( weights[ "left" ] < 0 )
			weights[ "left" ] = 0;

		weights[ "center" ] = 1 - weights[ "left" ];
	}
	else
	{
		weights[ "left" ] = 0;
		weights[ "right" ] = 0;
		weights[ "center" ] = 1;
	}

	return weights;
}



*/