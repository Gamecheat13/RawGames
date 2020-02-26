#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include animscripts\anims;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree ("generic_human");

moveTurnGlobalsInit()
{
	// AI_OPTIMIZATION - setting this one back to 0 from 2 to gain performance.
	anim.TURN_PREDICTION_TYPE_AXIS   = 0; // GetDvarint("ai_turnPredictionType"); // 0 - lookahead only, 1 - lookahead next node, 2 - predicted lookahead next node
	anim.TURN_PREDICTION_TYPE_ALLIES = 2; // GetDvarint("ai_turnPredictionType"); // 0 - lookahead only, 1 - lookahead next node, 2 - predicted lookahead next node
	anim.TURN_MIN_ANGLE 	 	     = 45; // GetDvarfloat( "ai_turnAnimAngleThreshold");
	
	/#anim.debugTurns 		  = GetDvarint( "ai_debugTurns" );#/
}

doTurn( overrideAnim, overrideBlendOutAnim, faceAngleOffset, keepEndYaw )
{
	self endon("killanimscript");
	self endon("death");

	turnAngle = self.a.turnAngle;
	self.a.isTurning = true;

	/#
	angleStr = "";
	if( turnAngle < 0 )
	{
		angleStr = "right " + turnAngle;
	}
	else
	{
		angleStr = "left " + turnAngle;
	}

	self animscripts\debug::debugPushState( "turn", angleStr );
	#/

	animscripts\run::StopUpdateRunAnimWeights(); // stop updating the runAnimWeights
	self notify("stopShooting");
	self notify("stopTurnBlendOut");
	self delay_thread(0.05, ::stopTracking); // delay bc tracking may have started on this frame

	turnAnim = getTurnAnim(turnAngle);

	if( IsDefined(overrideAnim) )
	{
		turnAnim = overrideAnim;
	}

	if( IsDefined(turnAnim) )
	{
		// play strict anim
		self AnimMode( "gravity", false );
		self OrientMode( "face angle", self.angles[1] );

		// must keep this low, otherwise there's a weird pop because of the client until we fix the networking
		const runBlendOutTime = 0.20;

		self ClearAnim( %body, runBlendOutTime );
		self SetFlaggedAnimRestart( "turn_anim", turnAnim, 1, runBlendOutTime );

		// ugh
		self thread forceClearClientRunTree( runBlendOutTime );

		animStartTime = GetTime();
		animLength    = GetAnimLength(turnAnim);

		hasExitAlign = animHasNotetrack( turnAnim, "exit_align" );
		
/#
		if ( !hasExitAlign )
		{
			// AI_TODO: print anim name
			println("^3Warning: turn animation for angle " + turnAngle + " has no \"exit_align\" notetrack.");
		}
#/
			
		self thread doTurnNotetracks( "turn_anim" );

		self thread turnBlendOut( animLength, "turn_anim", hasExitAlign, overrideBlendOutAnim );
	
		// wait till the notetrack telling us to start turning the AI
		self waittillmatch( "turn_anim", "exit_align" );

		// set the time we have to available to turn
		elapsed  = (getTime() - animStartTime) / 1000.0;
		timeLeft = animLength - elapsed;

		// see if there's a notetrack that says when to stop turning, otherwise go till end
		hasCodeMoveNoteTrack = animHasNotetrack( turnAnim, "code_move" );
		if( hasCodeMoveNoteTrack )
		{
			times = getNotetrackTimes( turnAnim, "code_move" );
			assert( times.size == 1, "More than one code_move notetrack found" );

			timeLeft = times[0] * animLength - elapsed;

			/# if( anim.debugTurns ) recordEntText( "hasCodeMove", self, level.color_debug["red"], "Animscript" );#/
		}

		/# if( anim.debugTurns )  recordEntText( "animLength: " + animLength + " elapsed: " + elapsed + " timeLeft: " + timeLeft, self, level.color_debug["red"], "Animscript" ); #/

		// AI_TODO: need to set up test case and fix case when a turn needs to be performed over a very short distance
		// right now the AI will turn too slow and miss the goal, and just keep going back and forth

		// now manually set the facing vector of the AI every frame during this turn window
		self AnimMode( "pos deltas", false );

		// some turns, like f2b, need to face 180 away from lookahead, for example
		if( !IsDefined(faceAngleOffset) )
		{
			faceAngleOffset = 0;
		}

		// cap the turn rate to the original intended, so they don't spin in place (ai_turnRate is 220 by default, for reference)
		intendedYawChangePerFrame = abs(turnAngle) / (timeLeft / 0.05);
		turnRateYawChangePerFrame = self.turnRate / 20;

		lookaheadYaw = VectorToAngles( self.lookaheaddir )[1];
		prevLookaheadYaw = lookaheadYaw;

		// turn the AI to face the desired lookahead
		while( timeLeft > 0 )
		{
			// if the lookahead itself is changing, increase the intended yaw change cap by the AI's max turn rate
			lookaheadYawChange = AbsAngleClamp180(lookaheadYaw - prevLookaheadYaw);
			maxYawChangePerFrame = intendedYawChangePerFrame + min(lookaheadYawChange, turnRateYawChangePerFrame);

			// where should the AI end facing during the turn window
			yawDelta = AngleClamp180(lookaheadYaw - self.angles[1] + faceAngleOffset);	// total
			yawDelta = yawDelta / ceil(timeLeft / 0.05);								// per frame
			yawDelta = min( abs(yawDelta), maxYawChangePerFrame) * sign(yawDelta);		// capped at max turn rate

			//self OrientMode("face angle", self.angles[1] + yawDelta);

			newAngles = (self.angles[0], self.angles[1] + yawDelta, self.angles[2]);
			self Teleport( self.origin, newAngles );

			/# if( anim.debugTurns ) recordEntText( "face angle: " + (self.angles[1] + yawDelta), self, level.color_debug["red"], "Animscript" ); #/

			timeLeft -= 0.05;
			wait( 0.05 );

			prevLookaheadYaw = lookaheadYaw;
			lookaheadYaw = VectorToAngles( self.lookaheaddir )[1];
		}

		self ClearMoveHistory();
		self AnimMode( "normal", false );

		if( !IS_TRUE(keepEndYaw) )
		{
			self OrientMode( "face motion" );
		}

		// wait till end of anim, if necessary
		elapsed  = (getTime() - animStartTime) / 1000.0;
		timeLeft = animLength - elapsed;
	
		while( timeLeft > 0 )
		{
			// make another turn, if necessary
			if( shouldTurn() )
			{
				break;
			}

			timeLeft -= 0.05;

			wait( 0.05 );
		}

		self OrientMode( "face default" );
	}

	self.a.isTurning = false;

	/#self animscripts\debug::debugPopState();#/
}

forceClearClientRunTree( blendTime )
{
	self endon("killanimscript");
	self endon("death");

	wait( 0.05 );

	self ClearAnim( %stand_and_crouch, blendTime - 0.05 );
}

// transition smoothly into locomotion, otherwise it'll look like a stutter
turnBlendOut( animLength, animName, hasExitAlign, overrideBlendOutAnim )
{
	self endon("killanimscript");
	self endon("death");
	self endon("stopTurnBlendOut");

	const runBlendInTime = 0.20; // to fix an extra frame of sliding that happens on the client

	assert( animLength > runBlendInTime );
	wait( animLength - runBlendInTime );

	nextAnim = animscripts\run::GetRunAnim();

	if( IsDefined(overrideBlendOutAnim) )
		nextAnim = overrideBlendOutAnim;
	
	// force running after turning as we only have turn animations and we dont want to blendIntoStandRun from turn.
	// if movement because AI was moving close by and happens to turn then that can cause T-pose. This should be taking care
	// of that edge case.
	self.a.movement = "run"; 
	
	// go back to run
	self ClearAnim( %body, runBlendInTime );
	self SetFlaggedAnimRestart( "run_anim", nextAnim, 1, runBlendInTime );

	if ( !hasExitAlign )
		self notify( animName, "exit_align" ); // failsafe
}

getTurnAngle()
{
	// in case getTurnAngle gets called multiple times in a frame, return the cached version
	if( IsDefined(self.a.turnAngleTime) && self.a.turnAngleTime == GetTime() )
	{
		assert( IsDefined(self.a.turnAngle) );
		return self.a.turnAngle;
	}

	//profilestart("getTurnAngle 1");
	
	turnAngle = self animscripts\run::GetLookaheadAngle();

	/#angleStr = "lookahead: " + int(turnAngle);#/

	// if the lookahead angle relative to the current facing isn't high enough to make a turn
	// try seeing if the angle difference between the facing and one of the two next
	// lookahead nodes is great enough for a turn, assuming that capsule traces pass as well.
	
	if( self.team == "allies" )
		turnPreditionType = anim.TURN_PREDICTION_TYPE_ALLIES;
	else
		turnPreditionType = anim.TURN_PREDICTION_TYPE_AXIS;
	
	if( abs(turnAngle) < anim.TURN_MIN_ANGLE && turnPreditionType > 0 )
	{
		// project future pos for seeing if any turns are coming up
		forwardDist = min( self.lookaheaddist, 30 );
		futurePos = self.origin + VectorScale( self.lookaheaddir, forwardDist );

		lookaheadNode = undefined;
		lookaheadNextNode = undefined;

		prevNodeAngle = undefined;
		for( i=0; i < turnPreditionType; i++ )
		{
			if( i == 0 ) // first try the cheaper next lookahead node since it's already computed
			{
				currentLookahead = self CalcLookaheadPos( futurePos, 0 );	// 0 iterations returns current lookahead

				if( IsDefined(currentLookahead) )
				{
					lookaheadNode = currentLookahead[ "node" ];				// lookahead next node
					lookaheadNextNode = currentLookahead[ "next_node" ];	// lookahead next next node
				}
			}
			else // this is more expensive since it requires more traces
			{
				doExpensiveLookahead = true;
				lookaheadNode = lookaheadNextNode;

				// if the node after the next node doesn't seem to offer anything in terms of angle
				// then don't bother doing the expensive CalcLookaheadPos prediction stuff
				if( IsDefined(lookaheadNextNode) )
				{
					nextNodeAngle = GetYawToOrigin( lookaheadNextNode ) * -1;

					if( abs(nextNodeAngle) <= max(anim.TURN_MIN_ANGLE, abs(prevNodeAngle)) ) // angle not high enough or not as high as last checked
					{
						doExpensiveLookahead = false;
					}
					else if( IsDefined(prevNodeAngle) && sign(nextNodeAngle) != sign(prevNodeAngle) ) // must turn in the same direction as the closer node
					{
						doExpensiveLookahead = false;
					}
				}
				else // no node - no need to check
				{
					doExpensiveLookahead = false;
				}

				if( doExpensiveLookahead )
				{
					lookaheadNode = undefined;

					predictedLookahead = self CalcLookaheadPos( futurePos, 3 );
					 
					if( IsDefined(predictedLookahead) )
					{
						//lookaheadNode = predictedLookahead[ "position" ];	// lookahead pos
						lookaheadNode = predictedLookahead[ "node" ];			// lookahead next node
					}
				}
			}

			// no points if there's no path
			if( !IsDefined(lookaheadNode) )
				continue;

			nextNodeAngle = GetYawToOrigin( lookaheadNode ) * -1;

			/# 
				if( i == 0 )
					angleStr += " node: " + int(nextNodeAngle); 
				else
					angleStr += " predicted: " + int(nextNodeAngle); 
			#/

			if( abs(nextNodeAngle) <= max(anim.TURN_MIN_ANGLE, abs(turnAngle)) ) // angle not high enough or not as high as last checked
			{
				/# if( anim.debugTurns ) recordLine( futurePos, lookaheadNode, level.color_debug["yellow"], "Animscript", self ); #/
			}
			else if( IsDefined(prevNodeAngle) && sign(nextNodeAngle) != sign(prevNodeAngle) ) // must turn in the same direction as the closer node
			{
				/# if( anim.debugTurns ) recordLine( futurePos, lookaheadNode, level.color_debug["yellow"], "Animscript", self ); #/
			}
			else if( !self MayMoveFromPointToPoint(futurePos, lookaheadNode) ) // won't be able to move there
			{
				/# if( anim.debugTurns ) recordLine( futurePos, lookaheadNode, level.color_debug["red"], "Animscript", self ); #/
			}
			else // take the bigger turn
			{
				/# if( anim.debugTurns ) recordLine( futurePos, lookaheadNode, level.color_debug["green"], "Animscript", self ); #/
				turnAngle = nextNodeAngle;
			}

			prevNodeAngle = nextNodeAngle;
		}
	}

	/#
	if( anim.debugTurns ) 
	{
		if( abs(turnAngle) > anim.TURN_MIN_ANGLE )
			recordEntText( angleStr, self, level.color_debug["green"], "Animscript" );
		else
			recordEntText( angleStr, self, level.color_debug["red"], "Animscript" );
	}
	#/

	//profileStop();
	
	return turnAngle;
}

shouldTurn()
{
	const MIN_DIST_FROM_GOAL_TO_TURNSQ =  50*50;
	const MIN_DIST_TO_TURN_A_CRONERSQ  =  150 *150;
	
	if( IsDefined( self.disableTurns ) && self.disableTurns )
		return false;
	
	// must be standing
	if( self.a.pose != "stand" )
		return false;
	
	// must not strafing/Tactical walking
	if( !self.faceMotion )
		return false;
	
	// don't play turns if really close to goal or start of a traversal
	pathGoalPos 	   = self.pathgoalpos;	
	traversalStartNode = self GetNegotiationStartNode();	
	
	if( IsDefined(traversalStartNode) )
		pathGoalPos = traversalStartNode.origin;	

	if( IsDefined(pathGoalPos) )
	{
		distToGoal = DistanceSquared( pathGoalPos, self.origin );
		if( distToGoal < MIN_DIST_FROM_GOAL_TO_TURNSQ )
		{
			/#
			if( anim.debugTurns ) 
				recordEntText( "distSq: " + distToGoal, self, level.color_debug["red"], "Animscript" );
			#/

			return false;
		}
		
	}

	self.a.turnIgnoreMotionAngle = false;

	// this is not scientific at all, just trying to see if the AI's moving
	minSpeed = 190 * 0.05; // typical run speed per frame
	minSpeed *= minSpeed;  // square it
	minSpeed *= 0.25;	   // quarter it

	turnAngle	= self animscripts\run::GetLookaheadAngle();
	motionAngle = self GetMotionAngle();

	// Dont turn b_2_f until we cross the distance for backward running and shooting/ backward strafing
	if( !self.a.turnIgnoreMotionAngle && abs(motionAngle) > 45 && abs(turnAngle) > 135 ) 
	{	
		if( !animscripts\run::ShouldFullSprint() && IsDefined( self.enemy ) && DistanceSquared( self.origin, self.enemy.origin ) < animscripts\run::GetRunBackWardsDistanceSquared() )
			return false;

		if ( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) < 150 * 150 )
			return false;
	}
	
	velocity	= self GetVelocity();
	velocity	= (velocity[0], velocity[1], 0); // only care about horizontal
	speedSq		= LengthSquared(velocity);

	turnAngle = getTurnAngle();

	// no turn necessary
	if( abs(turnAngle) < anim.TURN_MIN_ANGLE )
		return false;
	
	// we can overshoot in this case causing arrival to fail
	if( abs(turnAngle) <= 90 && IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) < 200 * 200 )
		return false;
	
	// must have at least some speed
	if( speedSq < minSpeed )
	{
		// unless just coming out of a traversal
		if( self.a.prevScript == "traverse" && self.a.movement == "run" && self.a.scriptStartTime == GetTime() )
			self.a.turnIgnoreMotionAngle = true;
		else
			return false;
	}

	// turns may make us miss the target
//	if( self.lookaheaddist < 100 )
//	{
//		// unless it's a big turn
//		if( self.lookaheaddist < 50 || abs(turnAngle) < 45 )
//		{
//			return false;
//		}
//	}

	// must have an anim
	if( !IsDefined( getTurnAnim(turnAngle) ) )
		return false;
	
	self.a.turnAngle = turnAngle;
	self.a.turnAngleTime = GetTime();

	return true;
}

getTurnAnim(turnAngle)
{
	// pick a turn anim. if turn shouldn't be done, then leave it undefined;
	turnAnim = undefined;
	turnAnimLookUpKey = undefined;
	turnAnimLookUpSpecial = shouldDoSpecialTurn();
	
	motionAngle	 = self GetMotionAngle();
	
	// ALEXP_TODO: need to check velocity too
	if( !IS_TRUE( self.a.turnIgnoreMotionAngle ) && abs(motionAngle) > 45 ) // strafing
	{
		if( abs(turnAngle) > 135 )
		{
			if( turnAngle > 0 )
			{
				turnAnimLookUpKey = "turn_b_r_180";
			}
			else
			{
				turnAnimLookUpKey = "turn_b_l_180";
			}			
		}
	}
	else
	{
		// positive - L
		if( turnAngle >= 115 && turnAngle <= 155 )
		{			
			turnAnimLookUpKey = "turn_f_l_135";

			if( !animArrayAnyExist( turnAnimLookUpKey + turnAnimLookUpSpecial, "turn" ) )
				turnAnimLookUpKey = "turn_f_l_180";
		}
		else if( turnAngle > 155 )
		{
			turnAnimLookUpKey = "turn_f_l_180";
			
		}
		else if( turnAngle >= 65 )
		{
			turnAnimLookUpKey = "turn_f_l_90";
		}
		else if( turnAngle >= 35 )
		{
			turnAnimLookUpKey = "turn_f_l_45";
		}
		
		// negative - R
		else if ( turnAngle <= -115 &&  turnAngle >= -155 )
		{
			turnAnimLookUpKey = "turn_f_r_135";

			if( !animArrayAnyExist( turnAnimLookUpKey + turnAnimLookUpSpecial, "turn" ) )
				turnAnimLookUpKey = "turn_f_r_180";
		}
		else if( turnAngle < -155 )
		{
			turnAnimLookUpKey = "turn_f_r_180";
		}
		else if( turnAngle <= -65 )
		{
			turnAnimLookUpKey = "turn_f_r_90";
			
		}
		else if( turnAngle < -35 )
		{
			turnAnimLookUpKey = "turn_f_r_45";
			
		}
	}
	
	// get the turn anim based on the selected look up key
	if( IsDefined( turnAnimLookUpKey ) )
	{
		// switch to special turn key if needed for current run cycle
		turnAnimLookUpKey = turnAnimLookUpKey + turnAnimLookUpSpecial;

		turnAnim = animArray( turnAnimLookUpKey, "turn" );
	}
	
	return turnAnim;
}

shouldDoSpecialTurn()
{
	specialTurnSuffix = "";

	// special turn anims for sprint and cqb
	if( ISCQB(self) )
		specialTurnSuffix = "_cqb";
	
	return specialTurnSuffix;
}

doTurnNotetracks( flagName )
{
	self notify("stop_DoNotetracks");

	self endon("killanimscript");
	self endon("death");
	self endon("stop_DoNotetracks");

	self animscripts\shared::DoNoteTracks( flagName );
}
