#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\animset;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree( "generic_human" );

// constants for exposed approaches
maxSpeed = 250;// units / sec
allowedError = 8;


main()
{
	self endon( "killanimscript" );
	self endon( "abort_approach" );

	if ( self.swimmer )
	{
		self animscripts\swim::Swim_CoverArrival_Main();
		return;
	}

	approachnumber = self.approachNumber;

	assert( IsDefined( self.approachType ) );

	arrivalAnim = self lookupAnim( "cover_trans", self.approachType )[ approachNumber ];
	assert( IsDefined( arrivalAnim ) );
	
	if ( !IsDefined( self.heat ) )
		self thread AbortApproachIfThreatened();
	
	self ClearAnim( %body, 0.2 );
	self SetFlaggedAnimRestart( "coverArrival", arrivalAnim, 1, 0.2, self.moveTransitionRate );
	self animscripts\shared::DoNoteTracks( "coverArrival", ::HandleStartAim );

	newStance = anim.arrivalEndStance[ self.approachType ];
	assertex( IsDefined( newStance ), "bad node approach type: " + self.approachType );

	if ( IsDefined( newStance ) )
		self.a.pose = newStance;
		
	self.a.movement = "stop";

	self.a.arrivalType = self.approachType;

	// we rely on cover to start doing something else with animations very soon.
	// in the meantime, we don't want any of our parent nodes lying around with positive weights.
	self ClearAnim( %root, .3 );
	
	self.lastApproachAbortTime = undefined;
}


HandleStartAim( note )
{
	if ( note == "start_aim" )
	{
		if ( self.a.pose == "stand" )
		{
			self set_animarray_standing();
		}
		else if ( self.a.pose == "crouch" )
		{
			self set_animarray_crouching();
		}
		else
		{
			assertMsg( "Unsupported self.a.pose: " + self.a.pose );
		}
	
		self animscripts\combat::set_aim_and_turn_limits();

		self.previousPitchDelta = 0.0;
		
		SetupAim( 0 );
		
		self thread animscripts\track::TrackShootEntOrPos();
	}
}


IsThreatenedByEnemy()
{
	if ( !IsDefined( self.node ) )
		return false;
		
	if ( IsDefined( self.enemy ) && self SeeRecently( self.enemy, 1.5 ) && DistanceSquared( self.origin, self.enemy.origin ) < 250000 )
		return !( self IsCoverValidAgainstEnemy() );
		
	return false;
}


AbortApproachIfThreatened()
{
	self endon( "killanimscript" );
	
	while ( 1 )
	{
		if ( !IsDefined( self.node ) )
			return;

		if ( IsThreatenedByEnemy() )
		{
			self ClearAnim( %root, .3 );
			self notify( "abort_approach" );
			self.lastApproachAbortTime = GetTime();
			return;
		}
		
		wait 0.1;
	}
}


CanUseSawApproach( node )
{
	if ( !UsingMG() )
		return false;

	if ( !IsDefined( node.turretInfo ) )
		return false;

	if ( node.type != "Cover Stand" && node.type != "Cover Prone" && node.type!= "Cover Crouch" )
		return false;

	if ( IsDefined( self.enemy ) && DistanceSquared( self.enemy.origin, node.origin ) < 256 * 256 )
		return false;

	if ( GetNodeYawToEnemy() > 40 || GetNodeYawToEnemy() < -40 )
		return false;

	return true;
}

DetermineNodeApproachType( node )
{
	nodeType = node.type;

	if ( nodeType == "Cover Multi" )
	{
		if ( !IsDefined(self.cover) )
			self.cover = SpawnStruct();
		nodeDir = animscripts\cover_multi::CoverMulti_GetBestValidDir( [ "over", [ "left", "right" ] ] );
		self.cover.arrivalNodeType = nodeDir;
		multiState = self animscripts\cover_multi::CoverMulti_GetStateFromDir( node, nodeDir );
		nodeType = self GetCoverMultiPretendType( node, multiState );
	}

	if ( canUseSawApproach( node ) )
	{
		if ( nodeType == "Cover Stand" )
			return "stand_saw";
		if ( nodeType == "Cover Crouch" )
			return "crouch_saw";
		else if ( nodeType == "Cover Prone" )
			return "prone_saw";
	}

	if ( !isdefined( anim.approach_types[ nodeType ] ) )
		return;

	if ( isdefined( node.arrivalStance ) )
		stance = node.arrivalStance;
	else
		stance = node getHighestNodeStance();

	// no approach to prone
	if ( stance == "prone" )
		stance = "crouch";
		
	type = anim.approach_types[ nodeType ][ stance ];
	
	if ( self UseReadystand() && type == "exposed" )
	{
		type = "exposed_ready";
	}

	if ( self ShouldCQB() )
	{
		cqbType = type + "_cqb";
		if ( IsDefined( anim.coverTrans[ cqbType ] ) )
			type = cqbType;
	}
	
	return type;		
}

DetermineExposedApproachType( node )
{
	if ( IsDefined( self.heat ) )
	{
		return "heat";
	}

	if ( IsDefined( node.arrivalStance ) )
		stance = node.arrivalStance;
	else
		stance = node GetHighestNodeStance();

	// no approach to prone
	if ( stance == "prone" )
		stance = "crouch";

	if ( stance == "crouch" )
		type = "exposed_crouch";
	else
		type = "exposed";

	if ( type == "exposed" && self UseReadystand() )
		type = type + "_ready";
		
	if ( self ShouldCQB() )
		return type + "_cqb";
		
	return type;
}


CalculateNodeOffsetFromAnimationDelta( nodeAngles, delta )
{
	// in the animation, forward = +x and right = -y
	right = AnglesToRight( nodeAngles );
	forward = AnglesToForward( nodeAngles );

	return ( forward * delta[0] ) + ( right * ( 0 - delta[1] ) );
}

GetApproachEnt()
{
	if ( IsDefined( self.scriptedArrivalEnt ) )
		return self.scriptedArrivalEnt;

	if ( IsDefined( self.node ) )
		return self.node;

	return undefined;
}

GetApproachPoint( node, approachType )
{
	if ( approachType == "stand_saw" )
	{
		approachPoint = ( node.turretInfo.origin[ 0 ], node.turretInfo.origin[ 1 ], node.origin[ 2 ] );
		forward = AnglesToForward( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
		right = AnglesToRight( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
		approachPoint = approachPoint + ( forward * -32.545 ) - ( right * 6.899 ); // -41.343 would work better for the first number if that weren't too far from the node =(
	}
	else if ( approachType == "crouch_saw" )
	{
		approachPoint = ( node.turretInfo.origin[ 0 ], node.turretInfo.origin[ 1 ], node.origin[ 2 ] );
		forward = anglesToForward( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
		right = anglesToRight( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
		approachPoint = approachPoint + ( forward * -32.545 ) - ( right * 6.899 );
	}
	else if ( approachType == "prone_saw" )
	{
		approachPoint = ( node.turretInfo.origin[ 0 ], node.turretInfo.origin[ 1 ], node.origin[ 2 ] );
		forward = anglesToForward( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
		right = anglesToRight( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
		approachPoint = approachPoint + ( forward * -37.36 ) - ( right * 13.279 );
	}
	else if ( IsDefined( self.scriptedArrivalEnt ) )
	{
		approachPoint = self.goalPos;
	}
	else
	{
		approachPoint = node.origin;
	}

	return approachPoint;
}


CheckApproachPreConditions()
{
	// if we're going to do a negotiation, we want to wait until it's over and move.gsc is called again
	if ( IsDefined( self GetNegotiationStartNode() ) )
	{
		/# debug_arrival( "Not doing approach: path has negotiation start node" ); #/
		return false;
	}

	
/*
=============
///ScriptFieldDocBegin
"Name: .disablearrivals"
"Summary: disablearrivals"
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	
	
	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		/# debug_arrival( "Not doing approach: self.disableArrivals is true" ); #/
		return false;
	}

/#
	if ( IsDefined( self.disableCoverArrivalsOnly ) )
	{
		debug_arrival( "Not doing approach: self.disableCoverArrivalsOnly is true" );
		return false;
	}
#/

	/*if ( self shouldCQB() )
	{
		/# debug_arrival("Not doing approach: self.cqbwalking is true"); #/
		return false;
	}*/

	return true;
}


CheckApproachConditions( approachType, approachDir, node )
{
	// we're doing default exposed approaches in doLastMinuteExposedApproach now
	if ( IsDefined( anim.exposedTransition[ approachType ] ) )
		return false;

	if ( approachType == "stand" || approachType == "crouch" )
	{
		assert( IsDefined( node ) );
		if ( AbsAngleClamp180( VectorToYaw( approachDir ) - node.angles[ 1 ] + 180 ) < 60 )
		{
			/# debug_arrival( "approach aborted: approachDir is too far forward for node type " + node.type ); #/
			return false;
		}
	}

	if ( self IsThreatenedByEnemy() || ( IsDefined( self.lastApproachAbortTime ) && self.lastApproachAbortTime + 500 > GetTime() ) )
	{
		/# debug_arrival( "approach aborted: nearby enemy threat" ); #/
		return false;
	}
	
	return true;
}

/#
setupApproachNode_debugInfo( actor, approachType, approach_dir, approachNodeYaw, node )
{
	if ( debug_arrivals_on_actor() )
	{
		println( "^5approaching cover (ent " + actor getentnum() + ", type \"" + approachType + "\"):" );
		println( "   approach_dir = (" + approach_dir[ 0 ] + ", " + approach_dir[ 1 ] + ", " + approach_dir[ 2 ] + ")" );
		angle = AngleClamp180( vectortoyaw( approach_dir ) - approachNodeYaw + 180 );
		if ( angle < 0 )
			println( "   (Angle of " + ( 0 - angle ) + " right from node forward.)" );
		else
			println( "   (Angle of " + angle + " left from node forward.)" );

		if ( approachType == "exposed" )
		{
			if ( isdefined( node ) )
			{
				if ( isdefined( approachtype ) )
					debug_arrival( "Aborting cover approach: node approach type was " + approachtype );
				else
					debug_arrival( "Aborting cover approach: node approach type was undefined" );
			}
			else
			{
				debug_arrival( "Aborting cover approach: node is undefined" );
			}
		}
		else
		{
			thread drawApproachVec( approach_dir );
		}
	}
}
#/


SetupApproachNode( bFirstTime )
{
	self endon( "killanimscript" );
	//self endon("path_changed");

	if ( IsDefined( self.heat ) )
	{
		self thread DoLastMinuteExposedApproachWrapper();
		return;
	}

	// this lets code know that script is expecting the "cover_approach" notify
	if ( bFirstTime )
		self.requestArrivalNotify = true;

    if ( self.swimmer == true )
    {   // swimming needs to do its own thing because of all the 3D cases.
        self thread animscripts\swim::Swim_SetupApproach( );
        return;
    }

	self.a.arrivalType = undefined;
	self thread DoLastMinuteExposedApproachWrapper();
	
	self waittill( "cover_approach", approachDir );

	if ( !self CheckApproachPreConditions() )
		return;

	self thread SetupApproachNode( false );	// wait again in case path goal changes

	approachType = "exposed";
	approachPoint = self.pathGoalPos;
	approachNodeYaw = VectorToYaw( approachDir );
	approachFinalYaw = approachNodeYaw;

	node = GetApproachEnt();

	if ( IsDefined( node ) )
	{
		approachType = DetermineNodeApproachType( node );
		if ( IsDefined( approachType ) && approachType != "exposed" )
		{
			approachPoint = GetApproachPoint( node, approachType );
			approachNodeYaw = node.angles[ 1 ];
			approachFinalYaw = GetNodeForwardYaw( node );
		}
	}
	else if ( self UseReadystand() )
	{
		if ( self ShouldCQB() )
			approachType = "exposed_ready_cqb";
		else
			approachType = "exposed_ready";
	}

	/# setupApproachNode_debugInfo( self, approachType, approachDir, approachNodeYaw, node ); #/

	if ( !CheckApproachConditions( approachType, approachDir, node ) )
		return;

	StartCoverApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approachDir );
}


CoverApproachLastMinuteCheck( approachPoint, approachFinalYaw, approachType, approachNumber, requiredYaw )
{
	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		 /# debug_arrival( "approach aborted at last minute: self.disableArrivals is true" ); #/
		return false;
	}

	// so we don't make guys turn around when they're (smartly) facing their enemy as they walk away
	if ( abs( self getMotionAngle() ) > 45 && isdefined( self.enemy ) && vectorDot( anglesToForward( self.angles ), vectorNormalize( self.enemy.origin - self.origin ) ) > .8 )
	{
		/# debug_arrival( "approach aborted at last minute: facing enemy instead of current motion angle" ); #/
		return false;
	}

	if ( self.a.pose != "stand" || ( self.a.movement != "run" && !( self isCQBWalkingOrFacingEnemy() ) ) )
	{
		 /# debug_arrival( "approach aborted at last minute: not standing and running" ); #/
		return false;
	}

	if ( AbsAngleClamp180( requiredYaw - self.angles[ 1 ] ) > 30 )
	{
		// don't do an approach away from an enemy that we would otherwise face as we moved away from them
		if ( isdefined( self.enemy ) && self canSee( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 256 * 256 )
		{
			// check if enemy is in frontish of us
			if ( vectorDot( anglesToForward( self.angles ), self.enemy.origin - self.origin ) > 0 )
			{
				 /# debug_arrival( "aborting approach at last minute: don't want to turn back to nearby enemy" ); #/
				return false;
			}
		}
	}

	// make sure the path is still clear
	if ( !checkCoverEnterPos( approachPoint, approachFinalYaw, approachType, approachNumber, false ) )
	{
		 /# debug_arrival( "approach blocked at last minute" ); #/
		return false;
	}

	return true;
}

approachWaitTillClose( node, checkDist )
{
	if ( !isdefined( node ) )
		return;
		
	// wait until we get to the point where we have to decide what approach animation to play
	while ( 1 )
	{
		if ( !isdefined( self.pathGoalPos ) )
			self waitForPathGoalPos();

		dist = distance( self.origin, self.pathGoalPos );

		if ( dist <= checkDist + allowedError )
			break;

		// underestimate how long to wait so we don't miss the crucial point
		waittime = ( dist - checkDist ) / maxSpeed - .1;
		if ( waittime < .05 )
			waittime = .05;

		wait waittime;
	}
}

StartCoverApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approachDir )
{
	self endon( "killanimscript" );
	self endon( "cover_approach" );

	assert( IsDefined( approachType ) );
	assert( approachType != "exposed" );

	node = GetApproachEnt();
	result = animscripts\exit_node::GetMaxDirectionsAndExcludeDirFromApproachType( node );
	maxDirections = result.maxDirections;
	excludeDir = result.excludeDir;

	arrivalFromFront = VectorDot( approachDir, AnglesToForward( node.angles ) ) >= 0;
	
	// find best possible position to start arrival animation
	result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approachDir, maxDirections, excludeDir, arrivalFromFront );

	if ( result.approachNumber < 0 )
	{
		/# debug_arrival( "approach aborted: " + result.failure ); #/
		return;
	}

	approachNumber = result.approachNumber;
	/# debug_arrival( "approach success: dir " + approachNumber ); #/

	//if ( level.newArrivals && approachNumber <= 6 && arrivalFromFront )
	if ( approachNumber <= 6 && arrivalFromFront )
	{
		self endon( "goal_changed" );

		self.arrivalStartDist = anim.coverTransLongestDist[ approachtype ];
		ApproachWaitTillClose( node, self.arrivalStartDist );
		
		// get the best approach direction from current position
		dirToNode = VectorNormalize( approachPoint - self.origin );
		result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, dirToNode, maxDirections, excludeDir, arrivalFromFront );
		
		self.arrivalStartDist = Length( lookupTransitionAnim( "cover_trans_dist", approachType, approachNumber ) );
		ApproachWaitTillClose( node, self.arrivalStartDist );
		
		if ( !( self MayMoveToPoint( approachPoint ) ) )
		{
			/# debug_arrival( "approach blocked at last minute" ); #/
			self.arrivalStartDist = undefined;
			return;
		}
		
		if ( result.approachNumber < 0 )
		{
			/# debug_arrival( "final approach aborted: " + result.failure ); #/
			self.arrivalStartDist = undefined;
			return;
		}		
		
		approachNumber = result.approachNumber;
		/# debug_arrival( "final approach success: dir " + approachNumber ); #/
			
	    requiredYaw = approachFinalYaw - self lookupTransitionAnim( "cover_trans_angles", approachType, approachNumber );
	}
	else
	{
	    // set arrival position and wait	
	    self SetRunToPos( self.coverEnterPos );     // <-- this thing right here cancels the exposed wait thread. (notifies goal_changed)
	    self waittill( "runto_arrived" );

	    requiredYaw = approachFinalYaw - self lookupTransitionAnim( "cover_trans_angles", approachType, approachNumber );

	    if ( !self CoverApproachLastMinuteCheck( approachPoint, approachFinalYaw, approachType, approachNumber, requiredYaw ) )
		    return;
	}

	self.approachNumber = approachNumber;	// used in cover_arrival::main()
	self.approachType = approachType;
	self.arrivalStartDist = undefined;
	self StartCoverArrival( self.coverEnterPos, requiredYaw, 0 );
}


CheckArrivalEnterPositions( approachpoint, approachYaw, approachtype, approach_dir, maxDirections, excludeDir, arrivalFromFront )
{
	assert( approachtype != "exposed" );
	angleDataObj = spawnstruct();

	animscripts\exit_node::calculateNodeTransitionAngles( angleDataObj, approachtype, true, approachYaw, approach_dir, maxDirections, excludeDir );
	animscripts\exit_node::sortNodeTransitionAngles( angleDataObj, maxDirections );

	resultobj = spawnstruct();
	/#resultobj.data = [];#/

	arrivalPos = ( 0, 0, 0 );
	resultobj.approachNumber = -1;

	numAttempts = 2;
	
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[ i ] != excludeDir );// shouldn't hit excludeDir unless numAttempts is too big

		resultobj.approachNumber = angleDataObj.transIndex[ i ];
		
		if ( !self checkCoverEnterPos( approachpoint, approachYaw, approachtype, resultobj.approachNumber, arrivalFromFront ) )
		{
			/#resultobj.data[ resultobj.data.size ] = "approach blocked: dir " + resultobj.approachNumber;#/
			continue;
		}
		break;
	}

	if ( i > numAttempts )
	{
		/#resultobj.failure = numAttempts + " direction attempts failed";#/
		resultobj.approachNumber = -1;
		return resultobj;
	}

	// if AI is closer to node than coverEnterPos is, don't do arrival
	distToApproachPoint = distanceSquared( approachpoint, self.origin );
	distToAnimStart = distanceSquared( approachpoint, self.coverEnterPos );
	if ( distToApproachPoint < distToAnimStart * 2 * 2 )
	{
		if ( distToApproachPoint < distToAnimStart )
		{
			/#resultobj.failure = "too close to destination";#/
			resultobj.approachNumber = -1;
			return resultobj;
		}

		//if ( !level.newArrivals || !arrivalFromFront )
		if ( !arrivalFromFront )
		{
			// if AI is less than twice the distance from the node than the beginning of the approach animation,
			// make sure the angle we'll turn when we start the animation is small.
			selfToAnimStart = vectorNormalize( self.coverEnterPos - self.origin );

			requiredYaw = approachYaw - self lookupTransitionAnim( "cover_trans_angles", approachType, resultobj.approachNumber );
			AnimStartToNode = anglesToForward( ( 0, requiredYaw, 0 ) );
			cosAngle = vectorDot( selfToAnimStart, AnimStartToNode );

			if ( cosAngle < 0.707 )// 0.707 == cos( 45 )
			{
				/#resultobj.failure = "angle to start of animation is too great (angle of " + acos( cosAngle ) + " > 45)";#/
				resultobj.approachNumber = -1;
				return resultobj;
			}
		}
	}

	/#
	for ( i = 0; i < resultobj.data.size; i++ )
		debug_arrival( resultobj.data[ i ] );
	#/

	return resultobj;
}

DoLastMinuteExposedApproachWrapper()
{
	self endon( "killanimscript" );
	self endon( "move_interrupt" );

	self notify( "doing_last_minute_exposed_approach" );
	self endon( "doing_last_minute_exposed_approach" );

	self thread WatchGoalChanged();

	while ( 1 )
	{
		DoLastMinuteExposedApproach();

		// try again when our goal pos changes
		while ( 1 )
		{
			self waittill_any( "goal_changed", "goal_changed_previous_frame" );

			// our goal didn't *really* change if it only changed because we called setRunToPos
			if ( IsDefined( self.coverEnterPos ) && IsDefined( self.pathGoalPos ) && Distance2D( self.coverEnterPos, self.pathGoalPos ) < 1 )
				continue;
			break;
		}
	}
}

WatchGoalChanged()
{
	self endon( "killanimscript" );
	self endon( "doing_last_minute_exposed_approach" );

	while ( 1 )
	{
		self waittill( "goal_changed" );
		wait .05;
		self notify( "goal_changed_previous_frame" );
	}
}


exposedApproachConditionCheck( node, goalMatchesNode )
{
	if ( !isdefined( self.pathGoalPos ) )
	{
		 /# debug_arrival( "Aborting exposed approach because I have no path" ); #/
		return false;
	}

	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		 /# debug_arrival( "Aborting exposed approach because self.disableArrivals is true" ); #/
		return false;
	}

	if ( isdefined( self.approachConditionCheckFunc ) )
	{
		if ( !self [[self.approachConditionCheckFunc]]( node ) )
			return false;
	}
	else
	{
		if ( !self.faceMotion && ( !isdefined( node ) || node.type == "Path" )  )
		{
			 /# debug_arrival( "Aborting exposed approach because not facing motion and not going to a node" ); #/
			return false;
		}

		if ( self.a.pose != "stand" )
		{
			 /# debug_arrival( "approach aborted at last minute: not standing" ); #/
			return false;
		}
	}

	if ( self isThreatenedByEnemy() || ( isdefined( self.lastApproachAbortTime ) && self.lastApproachAbortTime + 500 > getTime() ) )
	{
		/# debug_arrival( "approach aborted: nearby enemy threat" ); #/
		return false;
	}
	
	// only do an arrival if we have a clear path
	if ( !self maymovetopoint( self.pathGoalPos ) )
	{
		 /#debug_arrival( "Aborting exposed approach: maymove check failed" );#/
		return false;
	}

	return true;
}

ExposedApproachWaitTillClose()
{
	// wait until we get to the point where we have to decide what approach animation to play
	while ( 1 )
	{
		if ( !IsDefined( self.pathGoalPos ) )
			self WaitForPathGoalPos();

		node = GetApproachEnt();
		if ( IsDefined( node ) && !IsDefined( self.heat ) )
			arrivalPos = node.origin;
		else
			arrivalPos = self.pathGoalPos;
			
		dist = Distance( self.origin, arrivalPos );
		checkDist = anim.longestExposedApproachDist;

		if ( dist <= checkDist + allowedError )
			break;

		// underestimate how long to wait so we don't miss the crucial point
		waitTime = ( dist - anim.longestExposedApproachDist ) / maxSpeed - .1;
		if ( waitTime < 0 )
			break;
			
		if ( waitTime < .05 )
			waitTime = .05;

		// /#self thread animscripts\shared::showNoteTrack("wait " + waittime);#/
		wait waiTtime;
	}
}


FaceEnemyAtEndOfApproach( node )
{
	if ( !IsDefined( self.enemy ) )
		return false;
		
	if ( IsDefined( self.heat ) && IsDefined( node ) ) 
		return false;
		
	if ( self.combatMode == "cover" && IsSentient( self.enemy ) && gettime() - self LastKnownTime( self.enemy ) > 15000 )
		return false;
		
	return SightTracePassed( self.enemy GetShootAtPos(), self.pathGoalPos + ( 0, 0, 60 ), false, undefined );
}


DoLastMinuteExposedApproach()
{
	self endon( "goal_changed" );
	self endon( "move_interrupt" );

	if ( IsDefined( self GetNegotiationStartNode() ) )
		return;

	self ExposedApproachWaitTillClose();

	if ( IsDefined( self.grenade ) && IsDefined( self.grenade.activator ) && self.grenade.activator == self )
		return;
		
	approachType = "exposed";
	maxDistToNodeSq = 1;

	if ( IsDefined( self.approachTypeFunc ) )
	{
		approachType = self [[ self.approachTypeFunc ]]();
	}
	else if ( self UseReadystand() )
	{
		if ( self ShouldCQB() )
			approachType = "exposed_ready_cqb";
		else
			approachType = "exposed_ready";
	}
	else if ( self ShouldCQB() )
	{
		approachType = "exposed_cqb";
	}
	else if ( IsDefined( self.heat ) )
	{
		approachType = "heat";
		maxDistToNodeSq = 64 * 64;
	}
	else if ( self usingSMG() )
	{
		approachType = "exposed_smg";
	}
		
	node = GetApproachEnt();

	if ( IsDefined( node ) && IsDefined( self.pathGoalPos ) && !IsDefined( self.disableCoverArrivalsOnly ) )
		goalMatchesNode = DistanceSquared( self.pathGoalPos, node.origin ) < maxDistToNodeSq;
	else
		goalMatchesNode = false;

	if ( goalMatchesNode )
		approachType = DetermineExposedApproachType( node );

	approachDir = VectorNormalize( self.pathGoalPos - self.origin );

	// by default, want to face forward
	desiredFacingYaw = VectorToYaw( approachDir );
	
	if ( IsDefined( self.faceEnemyArrival ) )
	{
		desiredFacingYaw = self.angles[1];
	}
	else if ( FaceEnemyAtEndOfApproach( node ) )
	{
		desiredFacingYaw = VectorToYaw( self.enemy.origin - self.pathGoalPos );
	}
	else
	{
		faceNodeAngle = IsDefined( node ) && goalMatchesNode;
		faceNodeAngle = faceNodeAngle && ( node.type != "Path" ) && ( node.type != "Ambush" || !RecentlySawEnemy() );

		if ( faceNodeAngle )
		{
			desiredFacingYaw = GetNodeForwardYaw( node );
		}
		else
		{
			likelyEnemyDir = self GetAnglesToLikelyEnemyPath();
			if ( IsDefined( likelyEnemyDir ) )
				desiredFacingYaw = likelyEnemyDir[ 1 ];
		}
	}

	angleDataObj = spawnstruct();
	animscripts\exit_node::CalculateNodeTransitionAngles( angleDataObj, approachType, true, desiredFacingYaw, approachDir, 9, -1 );

	// take best animation
	best = 1;
	for ( i = 2; i <= 9; i++ )
	{
		if ( angleDataObj.transitions[ i ] > angleDataObj.transitions[ best ] )
			best = i;
	}
	self.approachNumber = angleDataObj.transIndex[ best ];
	self.approachType = approachType;

	 /# debug_arrival( "Doing exposed approach in direction " + self.approachNumber );	#/

	approachAnim = self lookupTransitionAnim( "cover_trans", approachType, self.approachNumber );//anim.coverTrans[ approachType ][ self.approachNumber ];

	animDist = length( self lookupTransitionAnim( "cover_trans_dist", approachType, self.approachNumber ) );

	requiredDistSq = animDist + allowedError;
	requiredDistSq = requiredDistSq * requiredDistSq;

	// we should already be close
	while ( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) > requiredDistSq )
		wait .05;

	if ( isdefined( self.arrivalStartDist ) && self.arrivalStartDist < animDist + allowedError )
	{
		/# debug_arrival( "Aborting exposed approach because cover arrival dist is shorter" ); #/
		return;
	}

	if ( !self ExposedApproachConditionCheck( node, goalMatchesNode ) )
		return;

	dist = Distance( self.origin, self.pathGoalPos );
	if ( abs( dist - animDist ) > allowedError )
	{
		 /# debug_arrival( "Aborting exposed approach because distance difference exceeded allowed error: " + dist + " more than " + allowedError + " from " + animDist ); #/
		return;
	}

	facingYaw = VectorToYaw( self.pathGoalPos - self.origin );

	if ( IsDefined( self.heat ) && goalMatchesNode )
	{
		requiredYaw = desiredFacingYaw - self lookupTransitionAnim( "cover_trans_angles", approachType, self.approachNumber );
		idealStartPos = GetArrivalStartPos( self.pathGoalPos, desiredFacingYaw, approachType, self.approachNumber );
	}
	else if ( animDist > 0 )
	{
		delta = self lookupTransitionAnim( "cover_trans_dist", approachType, self.approachNumber );
		assert( delta[ 0 ] != 0 );
		yawToMakeDeltaMatchUp = atan( delta[ 1 ] / delta[ 0 ] );

		if ( !IsDefined( self.faceEnemyArrival ) || self.faceMotion )
		{
			requiredYaw = facingYaw - yawToMakeDeltaMatchUp;
			if ( AbsAngleClamp180( requiredYaw - self.angles[ 1 ] ) > 30 )
			{
				/# debug_arrival( "Aborting exposed approach because angle change was too great" ); #/
				return;
			}
		}
		else
		{
			requiredYaw = self.angles[1];
		}

		closerDist = dist - animDist;
		idealStartPos = self.origin + ( VectorNormalize( self.pathGoalPos - self.origin ) * closerDist );
	}
	else
	{
		requiredYaw = self.angles[1];
		idealStartPos = self.origin;
	}

	self StartCoverArrival( idealStartPos, requiredYaw, 0 );
}

WaitForPathGoalPos()
{
	while ( 1 )
	{
		if ( IsDefined( self.pathGoalPos ) )
			return;

		wait 0.1;
	}
}


CustomMoveTransitionFunc()
{
	if ( !IsDefined( self.startMoveTransitionAnim ) )
		return;
		
	self AnimMode( "zonly_physics", false );
	self OrientMode( "face current" );
	
	self SetFlaggedAnimKnobAllRestart( "move", self.startMoveTransitionAnim, %root, 1 );

	if ( AnimHasNotetrack( self.startMoveTransitionAnim, "code_move" ) )
	{
		self animscripts\shared::DoNoteTracks( "move" );	// return on code_move
		self OrientMode( "face motion" );	// want to face motion since we are only playing exit animation( no l / r / b animations )
		self AnimMode( "none", false );
	}
	
	self animscripts\shared::DoNoteTracks( "move" );
}


str( val )
{
	if ( !isdefined( val ) )
		return "{undefined}";
	return val;
}

/*faceEnemyOrMotionAfterABit()
{
	self endon( "killanimscript" );
	self endon( "move_interrupt" );

	wait 1.0;

	// don't want to spin around if we're almost where we're going anyway
	while ( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) < 200 * 200 )
		wait .25;

	self OrientMode( "face default" );
}*/


drawVec( start, end, duration, color )
{
	for ( i = 0; i < duration * 100; i++ )
	{
		line( start + ( 0, 0, 30 ), end + ( 0, 0, 30 ), color );
		wait 0.05;
	}
}

drawApproachVec( approach_dir )
{
	self endon( "killanimscript" );
	for ( ;; )
	{
		if ( !isdefined( self.node ) )
			break;
		Line( self.node.origin + ( 0, 0, 20 ), ( self.node.origin - ( approach_dir * 64 ) ) + ( 0, 0, 20 ) );
		wait( 0.05 );
	}
}

/#
printdebug( pos, offset, text, color, linecolor )
{
	for ( i = 0; i < 20 * 5; i++ )
	{
		line( pos, pos + offset, linecolor );
		print3d( pos + offset, text, ( color, color, color ) );
		wait .05;
	}
}
#/


// don't want to pass in anim.coverTransDist or coverTransPreDist as parameter, since it will be copied
GetArrivalStartPos( arrivalPoint, arrivalYaw, approachType, approachNumber )
{
	angle = ( 0, arrivalYaw - self lookupTransitionAnim( "cover_trans_angles", approachType, approachNumber ), 0 );

	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );

	trans_dist = self lookupTransitionAnim( "cover_trans_dist", approachType, approachNumber );
	forward = ( forwardDir * trans_dist[ 0 ] );
	right = ( rightDir * trans_dist[ 1 ] );

	return arrivalPoint - forward + right;
}

GetArrivalPreStartPos( arrivalPoint, arrivalYaw, approachType, approachNumber )
{
	angle = ( 0, arrivalYaw - self lookupTransitionAnim( "cover_trans_angles", approachType, approachNumber ), 0 );

	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );

	predist = self lookupTransitionAnim( "cover_trans_predist", approachType, approachNumber );

	forward = ( forwardDir * predist[ 0 ] );
	right = ( rightDir * predist[ 1 ] );

	return arrivalPoint - forward + right;
}


CheckCoverEnterPos( arrivalPoint, arrivalYaw, approachType, approachNumber, arrivalFromFront )
{
	enterPos = GetArrivalStartPos( arrivalPoint, arrivalYaw, approachType, approachNumber );
	self.coverEnterPos = enterPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( enterPos, arrivalpoint, ( 1, .5, .5 ), 1.5 );
	#/
	
	//if ( level.newArrivals && approachNumber <= 6 && arrivalFromFront )
	if ( approachNumber <= 6 && arrivalFromFront )
		return true;
		
	if ( !( self MayMoveFromPointToPoint( enterPos, arrivalPoint ) ) )
		return false;

	if ( approachNumber <= 6 || IsDefined( anim.exposedTransition[ approachType ] ) )
		return true;

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the second part, from corner to node, now doing from start of enter anim to corner)

	originalEnterPos = GetArrivalPreStartPos( enterPos, arrivalYaw, approachType, approachNumber );
	self.coverEnterPos = originalEnterPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( originalEnterPos, enterPos, ( 1, .5, .5 ), 1.5 );
	#/
	return( self MayMoveFromPointToPoint( originalEnterPos, enterPos ) );
}

UseReadystand()
{
	if ( !IsDefined( anim.readystand_anims_inited ) )
	{
		return false;
	}

	if ( !anim.readystand_anims_inited )
	{
		return false;
	}

	if ( !IsDefined( self.bUseReadyIdle ) )
	{
		return false;
	}

	if ( !self.bUseReadyIdle )
	{
		return false;
	}

	return true;
}

debug_arrivals_on_actor()
{
	 /#
	dvar = getdebugdvar( "debug_arrivals" );
	if ( dvar == "off" )
		return false;

	if ( dvar == "on" )
		return true;

	if ( int( dvar ) == self getentnum() )
		return true;
	#/

	return false;
}


debug_arrival( msg )
{
	if ( !debug_arrivals_on_actor() )
		return;
	println( msg );
}