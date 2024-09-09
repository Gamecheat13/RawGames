#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\animset;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree( "generic_human" );

StartMoveTransition()
{
	if ( isdefined( self.customMoveTransition ) )
	{
		CustomMoveTransition();		
		return;
	}
	
	self endon( "killanimscript" );

	if ( !self CheckTransitionPreConditions() )
		return;

	// assume an exit from exposed.
	exitPos = self.origin;
	exitYaw = self.angles[ 1 ];
	exitType = "exposed";
	exitTypeFromNode = false;

	exitNode = GetExitNode();

	// if we're at a node, try to do an exit from the node.
	if ( IsDefined( exitNode ) )
	{
		nodeExitType = DetermineNodeExitType( exitNode );
		
		if ( IsDefined( nodeExitType ) )
		{
			exitType = nodeExitType;
			exitTypeFromNode = true;
		
			if ( IsDefined( self.heat ) )
				exitType = DetermineHeatCoverExitType( exitNode, exitType );

			if ( !IsDefined( anim.exposedTransition[ exitType ] ) && exitType != "stand_saw" && exitType != "crouch_saw" )
			{
				// if angle is wrong, don't do exit behavior for the node. Distance check already done in getExitNode

				angleDiff = AbsAngleClamp180( self.angles[ 1 ] - GetNodeForwardYaw( exitNode ) );
				if ( angleDiff < 5 )
				{
					// do exit behavior for the node.
					if ( !IsDefined( self.heat ) )
						exitPos = exitNode.origin;
					exitYaw = GetNodeForwardYaw( exitNode );
				}
			}
		}
	}

	/# self startMoveTransition_debugInfo( exittype, exityaw ); #/

	if ( !self CheckTransitionConditions( exittype, exitNode ) )
		return;

	bIsExposedExit = IsDefined( anim.exposedTransition[ exitType ] );
	if ( !exitTypeFromNode )
		exittype = determineNonNodeExitType();

	// since we're leaving, take the opposite direction of lookahead
	leaveDir = ( -1 * self.lookaheaddir[ 0 ], -1 * self.lookaheaddir[ 1 ], 0 );

	result = GetMaxDirectionsAndExcludeDirFromApproachType( exitNode );
	maxDirections = result.maxDirections;
	excludeDir = result.excludeDir;

	angleDataObj = spawnstruct();

	CalculateNodeTransitionAngles( angleDataObj, exitType, false, exitYaw, leaveDir, maxDirections, excludeDir );
	SortNodeTransitionAngles( angleDataObj, maxDirections );

	approachNumber = -1;
	numAttempts = 3;
	if ( bIsExposedExit )
		numAttempts = 1;

	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[ i ] != excludeDir );// shouldn't hit excludeDir unless numAttempts is too big

		approachNumber = angleDataObj.transIndex[ i ];
		if ( self CheckNodeExitPos( exitPos, exitYaw, exitType, bIsExposedExit, approachNumber ) )
			break;

		/# debug_arrival( "exit blocked: dir " + approachNumber ); #/
	}

	if ( i > numAttempts )
	{
		/# debug_arrival( "aborting exit: too many exit directions blocked" ); #/
		return;
	}

	// if AI is closer to destination than exitPos is, don't do exit
	allowedDistSq = DistanceSquared( self.origin, self.coverExitPos ) * 1.25 * 1.25;
	if ( DistanceSquared( self.origin, self.pathgoalpos ) < allowedDistSq )
	{
		/# debug_arrival( "exit failed, too close to destination" ); #/
		return;
	}

	/# debug_arrival( "exit success: dir " + approachNumber ); #/
	self DoNodeExitAnimation( exitType, approachNumber );
}


determineNodeExitType( node )
{
	if ( animscripts\cover_arrival::canUseSawApproach( node ) )
	{
		if ( node.type == "Cover Stand" )
			return "stand_saw";
		if ( node.type == "Cover Crouch" )
			return "crouch_saw";
		else if ( node.type == "Cover Prone" )
			return "prone_saw";
	}

	if ( !isdefined( anim.approach_types[ node.type ] ) )
		return;
		
	if ( isdefined( anim.requiredExitStance[ node.type ] ) && anim.requiredExitStance[ node.type ] != self.a.pose )
		return;

	stance = self.a.pose;

	// no exit from prone
	if ( stance == "prone" )
		stance = "crouch";
		
	type = anim.approach_types[ node.type ][ stance ];

	if ( self animscripts\cover_arrival::UseReadystand() && type == "exposed" )
	{
		type = "exposed_ready";
	}

	if ( self shouldCQB() )
	{
		cqbType = type + "_cqb";
		if ( isdefined( anim.coverExit[ cqbType ] ) )
			type = cqbType;
	}
	
	return type;		
}


CheckTransitionPreConditions()
{
	// if we don't know where we're going, we can't check if it's a good idea to do the exit animation
	// (and it's probably not)
	if ( !IsDefined( self.pathGoalPos ) )
	{
		 /# debug_arrival( "not exiting cover (ent " + self GetEntNum() + "): self.pathGoalPos is undefined" ); #/
		return false;
	}

	if ( !self ShouldFaceMotion() )
	{
		 /# debug_arrival( "not exiting cover (ent " + self GetEntNum() + "): self.faceMotion is false" ); #/
		return false;
	}

	if ( self.a.pose == "prone" )
	{
		 /# debug_arrival( "not exiting cover (ent " + self GetEntNum() + "): self.a.pose is \"prone\"" ); #/
		return false;
	}

	if ( IsDefined( self.disableExits ) && self.disableExits )
	{
		 /# debug_arrival( "not exiting cover (ent " + self GetEntNum() + "): self.disableExits is true" ); #/
		return false;
	}

	if ( self.stairsState != "none" )
	{
		 /# debug_arrival( "not exiting cover (ent " + self GetEntNum() + "): on stairs" ); #/
		return false;
	}

	if ( !self IsStanceAllowed( "stand" ) && !IsDefined( self.heat ) )
	{
		 /# debug_arrival( "not exiting cover (ent " + self GetEntNum() + "): not allowed to stand" ); #/
		return false;
	}
	
	if ( DistanceSquared( self.origin, self.pathGoalPos ) < 10000 )
	{
		/# debug_arrival( "not exiting cover (ent " + self GetEntNum() + "): too close to goal" ); #/
		return false;
	}

	return true;
}


CheckTransitionConditions( exitType, exitNode )
{
	if ( !isdefined( exitType ) )
	{
		 /# debug_arrival( "aborting exit: not supported for node type " + exitNode.type ); #/
		return false;
	}

	// since we transition directly into a standing run anyway,
	// we might as well just use the standing exits when crouching too
	if ( exitType == "exposed" || isdefined( self.heat ) )
	{
		if ( self.a.pose != "stand" && self.a.pose != "crouch" )
		{
			 /# debug_arrival( "exposed exit aborted because anim_pose is not \"stand\" or \"crouch\"" ); #/
			return false;
		}
		if ( self.a.movement != "stop" )
		{
			 /# debug_arrival( "exposed exit aborted because anim_movement is not \"stop\"" ); #/
			return false;
		}
	}

	// don't do an exit away from an enemy that we would otherwise face as we moved away from them
	if ( !isdefined( self.heat ) && isdefined( self.enemy ) && vectorDot( self.lookaheaddir, self.enemy.origin - self.origin ) < 0 )
	{
		if ( self canSeeEnemyFromExposed() && distanceSquared( self.origin, self.enemy.origin ) < 300 * 300 )
		{
			 /# debug_arrival( "aborting exit: don't want to turn back to nearby enemy" ); #/
			return false;
		}
	}

	return true;
}

/#
StartMoveTransition_debugInfo( exittype, exityaw )
{
	if ( animscripts\cover_arrival::debug_arrivals_on_actor() )
	{
		println( "^3exiting cover (ent " + self GetEntNum() + ", type \"" + exittype + "\"):" );
		println( "   lookaheaddir = (" + self.lookaheaddir[ 0 ] + ", " + self.lookaheaddir[ 1 ] + ", " + self.lookaheaddir[ 2 ] + ")" );
		angle = AngleClamp180( vectortoyaw( self.lookaheaddir ) - exityaw );
		if ( angle < 0 )
			println( "   (Angle of " + ( 0 - angle ) + " right from node forward.)" );
		else
			println( "   (Angle of " + angle + " left from node forward.)" );
	}
}
#/

DetermineNonNodeExitType( exitType )
{
	if ( self.a.pose == "stand" )
		exitType = "exposed";
	else
		exitType = "exposed_crouch";

	if ( self animscripts\cover_arrival::UseReadystand() )
		exitType = "exposed_ready";
		
	if ( ShouldCQB() )
		exitType = exitType + "_cqb";
	else if ( IsDefined( self.heat ) )
		exitType = "heat";
		
	return exitType;
}

GetMaxDirectionsAndExcludeDirFromApproachType( node )
{
	returnObj = spawnstruct();

	if ( IsDefined( node ) && IsDefined( anim.maxDirections[ node.type ] ) )
	{
		returnObj.maxDirections = anim.maxDirections[ node.type ];
		returnObj.excludeDir = anim.excludeDir[ node.type ];
	}
	else
	{
		returnObj.maxDirections = 9;
		returnObj.excludeDir = -1;
	}
	
	return returnObj;
}

CalculateNodeTransitionAngles( angleDataObj, approachType, bIsArrival, arrivalYaw, approachDir, maxDirections, excludeDir )
{
	angleDataObj.transitions = [];
	angleDataObj.transIndex = [];

	angleArray = undefined;
	sign = 1;
	offset = 0;
	if ( bIsArrival )
	{
		angleArray = self lookupAnim( "cover_trans_angles", approachType );
		sign = -1;
		offset = 0;
	}
	else
	{
		angleArray = self lookupAnim( "cover_exit_angles", approachtype );
		sign = 1;
		offset = 180;
	}

	for ( i = 1; i <= maxDirections; i++ )
	{
		angleDataObj.transIndex[ i ] = i;

		if ( i == 5 || i == excludeDir || !IsDefined( angleArray[ i ] ) )
		{
			angleDataObj.transitions[ i ] = -1.0003;	// cos180 - epsilon
			continue;
		}

		angles = ( 0, arrivalYaw + sign * anglearray[ i ] + offset, 0 );

		dir = VectorNormalize( AnglesToForward( angles ) );
		angleDataObj.transitions[ i ] = VectorDot( approachDir, dir );
	}
}

SortNodeTransitionAngles( angleDataObj, maxDirections )
{
	for ( i = 2; i <= maxDirections; i++ )
	{
		currentValue = angleDataObj.transitions[ angleDataObj.transIndex[ i ] ];
		currentIndex = angleDataObj.transIndex[ i ];

		for ( j = i - 1; j >= 1; j -- )
		{
			if ( currentValue < angleDataObj.transitions[ angleDataObj.transIndex[ j ] ] )
				break;

			angleDataObj.transIndex[ j + 1 ]  = angleDataObj.transIndex[ j ];
		}

		angleDataObj.transIndex[ j + 1 ] = currentIndex;
	}
}


CheckNodeExitPos( exitPoint, exitYaw, exitType, isExposedExit, approachNumber )
{
	angle = ( 0, exityaw, 0 );

	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );

	exit_dist = self lookupTransitionAnim( "cover_exit_dist", exitType, approachNumber );
	forward = ( forwardDir * exit_dist[ 0 ] );
	right = ( rightDir * exit_dist[ 1 ] );

	exitPos = exitpoint + forward - right;
	self.coverExitPos = exitPos;

	/#
	if ( animscripts\cover_arrival::debug_arrivals_on_actor() )
		thread debugLine( self.origin, exitpos, ( 1, .5, .5 ), 1.5 );
	#/

	if ( !isExposedExit && !( self CheckCoverExitPosWithPath( exitPos ) ) )
	{
		 /#
		debug_arrival( "cover exit " + approachNumber + " path check failed" );
		#/
		return false;
	}

	if ( !( self MayMoveFromPointToPoint( self.origin, exitPos ) ) )
		return false;

	if ( approachNumber <= 6 || isExposedExit )
		return true;

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the first part, from node to corner, now doing from corner to end of exit anim)
	exit_postdist = self lookupTransitionAnim( "cover_exit_postdist", exittype, approachNumber );
	forward = ( forwardDir * exit_postdist[ 0 ] );
	right = ( rightDir * exit_postdist[ 1 ] );

	finalExitPos = exitPos + forward - right;
	self.coverExitPos = finalExitPos;

	 /#
	if ( animscripts\cover_arrival::debug_arrivals_on_actor() )
		thread debugLine( exitpos, finalExitPos, ( 1, .5, .5 ), 1.5 );
	#/
	return( self MayMoveFromPointToPoint( exitPos, finalExitPos ) );
}


doNodeExitAnimation( exittype, approachNumber )
{
	assert( IsDefined( approachNumber ) );
	assert( approachNumber > 0 );

	assert( isdefined( exittype ) );

	leaveAnim = self lookupTransitionAnim( "cover_exit", exitType, approachNumber );

	assert( isdefined( leaveAnim ) );

	lookaheadAngles = VectorToAngles( self.lookaheaddir );

	/#
	if ( animscripts\cover_arrival::debug_arrivals_on_actor() )
	{
		endpos = self.origin + ( self.lookaheaddir * 100 );
		thread debugLine( self.origin, endpos, ( 1, 0, 0 ), 1.5 );
	}
	#/

	if ( self.a.pose == "prone" )
		return;

	transTime = 0.2;

	if ( self.swimmer )
		self AnimMode( "nogravity", false );
	else
	self AnimMode( "zonly_physics", false );
	self OrientMode( "face angle", self.angles[ 1 ] );
	self SetFlaggedAnimKnobAllRestart( "coverexit", leaveAnim, %body, 1, transTime, self.moveTransitionRate );

	assert( animHasNotetrack( leaveAnim, "code_move" ) );

	self animscripts\shared::DoNoteTracks( "coverexit" ); // until "code_move"

	self.a.pose = "stand";
	self.a.movement = "run";

	self.ignorePathChange = undefined;
	self OrientMode( "face motion" );	// want to face motion since we are only playing exit animation( no l / r / b animations )
	self Animmode( "none", false );

	self FinishCoverExitNotetracks( "coverexit" );

	// need to clear everything above leaveAnim
	//self clearanim( leaveAnim, 0.2 );
	self ClearAnim( %root, 0.2 );

	self OrientMode( "face default" );
	//self thread faceEnemyOrMotionAfterABit();
	self AnimMode( "normal", false );
}

FinishCoverExitNotetracks( flagname )
{
	self endon( "move_loop_restart" );
	self animscripts\shared::DoNoteTracks( flagname );
}

DetermineHeatCoverExitType( exitNode, exitType )
{
	if ( exitNode.type == "Cover Right" )
		exitType = "heat_right";
	else if ( exitNode.type == "Cover Left" )
		exitType = "heat_left";
		
	return exitType;
}

GetExitNode()
{
	exitNode = undefined;
	
	if ( !IsDefined( self.heat ) )
		limit = 400;	// 20 * 20
	else
		limit = 4096;	// 64 * 64

	if ( IsDefined( self.node ) && ( DistanceSquared( self.origin, self.node.origin ) < limit ) )
		exitNode = self.node;
	else if ( IsDefined( self.prevNode ) && ( DistanceSquared( self.origin, self.prevNode.origin ) < limit ) )
		exitNode = self.prevNode;

	if ( IsDefined( exitNode ) && IsDefined( self.heat ) && AbsAngleClamp180( self.angles[1] - exitNode.angles[1] ) > 30 )
		return undefined;

	return exitNode;
}

CustomMoveTransition()
{
	assert( IsDefined( self.customMoveTransition ) );

	customTransition = self.customMoveTransition;
	if ( !isdefined( self.permanentCustomMoveTransition ) )
		self.customMoveTransition = undefined;
		
	[[ customTransition ]]();

	if ( !isdefined( self.permanentCustomMoveTransition ) )
		self.startMoveTransitionAnim = undefined;

	self clearanim( %root, 0.2 );
	self orientmode( "face default" );
	self animmode( "none", false );
}

debug_arrival( msg )
{
	if ( !animscripts\cover_arrival::debug_arrivals_on_actor() )
		return;
	println( msg );
}