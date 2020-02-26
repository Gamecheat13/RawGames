#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree ("generic_human");

main()
{
	self endon("killanimscript");
	
	approachnumber = self.approachNumber;
	
	newstance = undefined;
	
	assert( isdefined( self.approachtype ) );
	
	arrivalAnim = anim.cornerTrans[ self.approachtype ][ approachnumber ];
	assert( isdefined( arrivalAnim ) );
	
	if ( self.approachtype == "left" || self.approachtype == "right" || self.approachtype == "stand" || self.approachtype == "exposed" )
	{
		newstance = "stand";
	}
	else if ( self.approachtype == "left_crouch" || self.approachtype == "right_crouch" || self.approachtype == "crouch" )
	{
		newstance = "crouch";
	}
	else
	{
		assertmsg("bad node approach type: " + self.approachtype);
		return;
	}
	
	self setFlaggedAnimKnobAllRestart( "anim",arrivalAnim,%body, 1, 0.3, 1 );
	self animscripts\shared::DoNoteTracks("anim");
	
	if ( isdefined( newstance ) )
		self.a.pose = newstance;
	self.a.movement = "stop";
	
	// we rely on cover to start doing something else with animations very soon.
	// in the meantime, we don't want any of our parent nodes lying around with positive weights.
	self clearanim( %root, .3 );
}

getNodeStanceYawOffset( approachtype )
{
	// returns the base stance's yaw offset when hiding at a node, based off the approach type
	
	if ( approachtype == "left" || approachtype == "left_crouch" )
		return 90.0;
	else if ( approachtype == "right" || approachtype == "right_crouch" )
		return -90.0;
	
	return 0;
}

determineNodeApproachType( node )
{
	if ( isdefined( node.approachtype ) )
		return;
	
	approach_types = [];
	standing = 0;
	crouching = 1;

	approach_types[ "Cover Left" ] = [];
	approach_types[ "Cover Left" ][ standing ] = "left";
	approach_types[ "Cover Left" ][ crouching ] = "left_crouch";
	approach_types[ "Cover Left Wide" ] = approach_types[ "Cover Left" ];

	approach_types[ "Cover Right" ] = [];
	approach_types[ "Cover Right" ][ standing ] = "right";
	approach_types[ "Cover Right" ][ crouching ] = "right_crouch";
	approach_types[ "Cover Right Wide" ] = approach_types[ "Cover Right" ];

	approach_types[ "Cover Crouch" ] = [];
	approach_types[ "Cover Crouch" ][ standing ] = "crouch";
	approach_types[ "Cover Crouch" ][ crouching ] = "crouch";
	approach_types[ "Conceal Crouch" ] = approach_types[ "Cover Crouch" ];

	approach_types[ "Cover Stand" ] = [];
	approach_types[ "Cover Stand" ][ standing ] = "stand";
	approach_types[ "Cover Stand" ][ crouching ] = "stand";
	approach_types[ "Conceal Stand" ] = approach_types[ "Cover Stand" ];
	
	approach_types[ "Path" ] = [];
	approach_types[ "Path" ][ standing ] = "exposed";
	approach_types[ "Path" ][ crouching ] = "exposed";
	
	if ( !isdefined( approach_types[ node.type ] ) )
		return;
	
	stance = node isNodeDontStand() && !node isNodeDontCrouch();
	
	node.approachtype = approach_types[ node.type ][ stance ];
}

getMaxDirectionsAndExcludeDirFromApproachType( approachtype )
{
	returnobj = spawnstruct();
	
	if ( approachtype == "left" || approachtype == "left_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = 9;
	}
	else if ( approachtype == "right" || approachtype == "right_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = 7;
	}
	else if ( approachtype == "stand" || approachtype == "crouch" )
	{
		returnobj.maxDirections = 6;
		returnobj.excludeDir = -1;
	}
	else if ( approachtype == "exposed" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = -1;
	}
	else
	{
		assertmsg( "unsupported approach type " + approachtype );
	}
	return returnobj;
}

shouldApproachToExposed()
{
	// decide whether it's a good idea to go directly into the exposed position as we approach this node.
	
	if ( !isValidEnemy( self.enemy ) )
		return false; // nothing to shoot!
	
	if ( self NeedToReload( 0.5 ) )
		return false;
	
	if ( self isSuppressedWrapper() )
		return false; // too dangerous, we need cover
	
	// path nodes have no special "exposed" position
	if ( self.node.approachtype == "exposed" )
		return false;
	
	// no arrival animations into exposed for left/right crouch
	if ( self.node.approachtype == "left_crouch" || self.node.approachtype == "right_crouch" )
		return false;
	
	return canSeePointFromExposedAtNode( self.enemy getShootAtPos(), self.node );
}

// gets the point and angle to approach in order to arrive in exposed
getExposedApproachData()
{
	returnobj = spawnstruct();
	
	if ( self.node.approachtype == "stand" )
	{
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( self.node.angles, getMoveDelta( %coverstand_hide_2_aim ) );
		returnobj.yaw = self.node.angles[1];
	}
	else if ( self.node.approachtype == "crouch" )
	{
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( self.node.angles, getMoveDelta( %covercrouch_hide_2_stand ) );
		returnobj.yaw = self.node.angles[1];
	}
	else if ( self.node.approachtype == "left" || self.node.approachtype == "left_crouch" )
	{
		cornerMode = animscripts\corner::getCornerMode( self.node, self.enemy getShootAtPos() );
		assert( cornerMode != "none" ); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
		
		alert_to_exposed_anim = undefined;
		if ( self.node.approachtype == "left" )
		{
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %corner_standL_trans_alert_2_A;
			else
				alert_to_exposed_anim = %corner_standL_trans_alert_2_B;
		}
		else
		{
			assert( self.node.approachtype == "left_crouch" );
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %CornerCrL_trans_alert_2_A;
			else
				alert_to_exposed_anim = %CornerCrL_trans_alert_2_B;
		}
		
		baseAngles = self.node.angles;
		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset( self.node.approachtype ), baseAngles[2]);
		
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( baseAngles, getMoveDelta( alert_to_exposed_anim ) );
		returnobj.yaw = baseAngles[1] + getAngleDelta( alert_to_exposed_anim )[1];
	}
	else if ( self.node.approachtype == "right" || self.node.approachtype == "right_crouch" )
	{
		cornerMode = animscripts\corner::getCornerMode( self.node, self.enemy getShootAtPos() );
		assert( cornerMode != "none" ); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
		
		alert_to_exposed_anim = undefined;
		if ( self.node.approachtype == "right" )
		{
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %corner_standR_trans_alert_2_A;
			else
				alert_to_exposed_anim = %corner_standR_trans_alert_2_B;
		}
		else
		{
			assert( self.node.approachtype == "right_crouch" );
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %CornerCrR_trans_alert_2_A;
			else
				alert_to_exposed_anim = %CornerCrR_trans_alert_2_B;
		}
		
		baseAngles = self.node.angles;
		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset( self.node.approachtype ), baseAngles[2]);
		
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( baseAngles, getMoveDelta( alert_to_exposed_anim ) );
		returnobj.yaw = baseAngles[1] + getAngleDelta( alert_to_exposed_anim )[1];
	}
	else
	{
		assertmsg( "bad node approach type: " + self.node.approachtype );
	}
	
	return returnobj;
}

calculateNodeOffsetFromAnimationDelta( nodeAngles, delta )
{
	// in the animation, forward = +x and right = -y
	right = anglestoright( nodeAngles );
	forward = anglestoforward( nodeAngles );
		
	return vectorScale( forward, delta[0] ) + vectorScale( right, 0-delta[1] );
}

setupApproachNode( firstTime )
{
	self endon("killanimscript");
	
	// this lets code know that script is expecting the "corner_approach" notify
	if ( firstTime )
		self.requestArrivalNotify = true;
	
	self thread doLastMinuteExposedApproach();
	
	// "corner_approach" actually means "cover_approach".
	self waittill( "corner_approach", approach_dir );
	
	// if we're going to do a negotiation, we want to wait until it's over and move.gsc is called again
	if ( isdefined( self getnegotiationstartnode() ) )
		return;
	
	self thread setupApproachNode( false );	// wait again
	
	approachType = "exposed";
	approachPoint = self.pathGoalPos;
	approachNodeYaw = vectorToAngles( approach_dir )[1];
	approachFinalYaw = approachNodeYaw;
	if ( isdefined( self.node ) )
	{
		determineNodeApproachType( self.node );
		if ( isdefined( self.node.approachtype ) && self.node.approachtype != "exposed" )
		{
			approachType = self.node.approachtype;
			approachPoint = self.node.origin;
			approachNodeYaw = self.node.angles[1];
			approachFinalYaw = approachNodeYaw + getNodeStanceYawOffset( approachType );
		}
		
		/#
		if ( isdefined( level.testingApproaches ) && approachType == "exposed" )
		{
			approachNodeYaw = self.node.angles[1];
			approachFinalYaw = approachNodeYaw;
		}
		#/
	}
	
	// we're doing default exposed approaches in doLastMinuteExposedApproach now
	if ( approachType == "exposed" )
		return;
	
	//if ( approachType == "exposed" && !isdefined( self.pathGoalPos ) )
	//	return;
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		println("^5approaching cover (ent " + self getentnum() + ", type \"" + approachType + "\"):");
		println("   approach_dir = (" + approach_dir[0] + ", " + approach_dir[1] + ", " + approach_dir[2] + ")");
		angle = AngleClamp( vectortoangles( approach_dir )[1] - approachNodeYaw + 180, "-180 to 180");
		if ( angle < 0 )
			println("   (Angle of " + (0-angle) + " right from node forward.)");
		else
			println("   (Angle of " + angle + " left from node forward.)");
	}
	#/
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		// removed this because it needs to be maintained/fixed but i didn't feel it was that important
		//thread drawTransAnglesOnNode(self.node);
		thread drawApproachVec(approach_dir);
	}
	#/
	
	startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir );
}

startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir )
{
	self endon("killanimscript");
	self endon("corner_approach");
	
	assert( isdefined( approachType ) );
	
	if ( approachType == "stand" || approachType == "crouch" )
	{
		assert( isdefined( self.node ) );
		if ( abs( AngleClamp( vectorToAngles( approach_dir )[1] - self.node.angles[1] + 180, "-180 to 180" ) ) < 60 )
		{
			/#
			debug_arrival( "approach aborted: approach_dir is too far forward for node type " + self.node.type );
			#/
			return;
		}
	}
	
	result = getMaxDirectionsAndExcludeDirFromApproachType( approachType );
	maxDirections = result.maxDirections;
	excludeDir = result.excludeDir;
	
	approachNumber = -1;
	approachYaw = undefined;
	finalPositionYawOffset = 0;
	
	if ( approachType == "exposed" )
	{
		result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approach_dir, maxDirections, excludeDir );
		/#
		for ( i = 0; i < result.data.size; i++ )
			debug_arrival( result.data[i] );
		#/
		if ( result.approachNumber < 0 )
		{
			/#
			debug_arrival( "approach aborted: " + result.failure );
			#/
			return;
		}
		approachNumber = result.approachNumber;
	}
	else
	{
		// approaching a node.
		// try arrival directions into exposed
		tryNormalApproach = true;
		// TODO: try approach to exposed
		/*if ( self shouldApproachToExposed() )
		{
			approachdata = getExposedApproachData();
			// use approachdata.point, approachdata.yaw
			
			// be careful not to set these if we're going to try a normal approach:
			approachFinalYaw = approachdata.yaw;
			approachType = "exposed";
			approachNumber = result.approachNumber;
			approachPoint = ...
			
		}*/
		if ( tryNormalApproach )
		{
			// try arrival directions into node itself
			result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approach_dir, maxDirections, excludeDir );
			/#
			for ( i = 0; i < result.data.size; i++ )
				debug_arrival( result.data[i] );
			#/
			if ( result.approachNumber < 0 )
			{
				/#
				debug_arrival( "approach aborted: " + result.failure );
				#/
				return;
			}
			approachNumber = result.approachNumber;
		}
	}
	
	/#
	debug_arrival( "approach success: dir " + approachNumber );
	#/

	self setruntopos( self.coverEnterPos );
	self notify("going_to_do_approach");
	
	
	self waittill("runto_arrived");
	
	
	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("approach aborted at last minute: self.disableArrivals is true");
		#/
		return;
	}
	
	if ( self.a.pose != "stand" || self.a.movement != "run" )
	{
		/#
		debug_arrival( "approach aborted at last minute: not standing and running" );
		#/
		return;
	}
	
	yaw = approachFinalYaw - anim.cornerTransAngles[approachType][approachNumber];
	
	// make sure the path is still clear
	if ( !checkCoverEnterPos( approachPoint, approachFinalYaw, approachType, approachNumber ) )
	{
		/#
		debug_arrival( "approach blocked at last minute" );
		#/
		return;
	}
	
	self.approachNumber = approachNumber;	// used in cover_arrival::main()
	self.approachType = approachType;
	self startcoverarrival( self.coverEnterPos, yaw );
}

CheckArrivalEnterPositions( approachpoint, approachYaw, approachtype, approach_dir, maxDirections, excludeDir )
{
	angleDataObj = spawnstruct();
	
	calculateNodeTransitionAngles( angleDataObj, approachtype, true, approachYaw, approach_dir, maxDirections, excludeDir );
	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	resultobj = spawnstruct();
	/#resultobj.data = [];#/
	
	arrivalPos = (0, 0, 0);
	resultobj.approachNumber = -1;
	
	numAttempts = 2;
	if ( approachtype == "exposed" )
		numAttempts = 1;
	
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
		
		resultobj.approachNumber = angleDataObj.transIndex[i];
		if ( !self checkCoverEnterPos( approachpoint, approachYaw, approachtype, resultobj.approachNumber ) )
		{
			/#resultobj.data[resultobj.data.size] = "approach blocked: dir " + resultobj.approachNumber;#/
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
	if ( distanceSquared( approachpoint, self.origin ) < distanceSquared( approachpoint, self.coverEnterPos ) * 1.25*1.25 )
	{
		/#resultobj.failure = "too close to destination";#/
		resultobj.approachNumber = -1;
		return resultobj;
	}
	
	return resultobj;
}

doLastMinuteExposedApproach()
{
	self notify("doing_last_minute_exposed_approach");
	self endon ("doing_last_minute_exposed_approach");
	
	self endon("killanimscript");
	self endon("going_to_do_approach");
	
	if ( isdefined( self getnegotiationstartnode() ) )
		return;
	
	maxSpeed = 200; // units/sec
	
	allowedError = 6;
	if ( self.goalRadius < allowedError )
		allowedError = self.goalRadius;
	
	// wait until we get to the point where we have to decide what approach animation to play
	while(1)
	{
		if ( !isdefined( self.pathGoalPos ) )
		{
			debug_arrival("Aborting exposed approach because I have no path");
			return;
		}
		
		dist = distance( self.origin, self.pathGoalPos );
		
		if ( dist <= anim.longestExposedApproachDist + allowedError )
			break;
		
		// underestimate how long to wait so we don't miss the crucial point
		waittime = (dist - anim.longestExposedApproachDist) / maxSpeed - .1;
		if ( waittime < .05 )
			waittime = .05;

		/#self thread animscripts\shared::showNoteTrack("wait " + waittime);#/
		wait waittime;
	}
	
	// only do an arrival if we have a clear path
	if ( !self maymovetopoint( self.pathGoalPos ) )
	{
		/#debug_arrival("Aborting exposed approach: maymove check failed");#/
		return;
	}
	
	approachDir = VectorNormalize( self.pathGoalPos - self.origin );
	
	// by default, want to face forward
	desiredFacingYaw = vectorToAngles( approachDir )[1];
	if ( isValidEnemy( self.enemy ) && sightTracePassed( self.enemy getShootAtPos(), self.pathGoalPos + (0,0,60), false, undefined ) )
	{
		desiredFacingYaw = vectorToAngles( self.enemy.origin - self.pathGoalPos )[1];
	}
	
	angleDataObj = spawnstruct();
	calculateNodeTransitionAngles( angleDataObj, "exposed", true, desiredFacingYaw, approachDir, 9, -1 );
	
	// take best animation
	best = 1;
	for ( i = 2; i < 9; i++ )
	{
		if ( angleDataObj.transitions[i] > angleDataObj.transitions[best] )
			best = i;
	}
	self.approachNumber = angleDataObj.transIndex[best];
	self.approachType = "exposed";
	
	/#
	debug_arrival("Doing exposed approach in direction " + self.approachNumber);
	#/
	
	approachAnim = anim.cornerTrans["exposed"][self.approachNumber];
	
	animDist = length( anim.cornerTransDist["exposed"][self.approachNumber] );
	
	requiredDistSq = animDist + allowedError;
	requiredDistSq = requiredDistSq * requiredDistSq;
	
	// we should already be close
	while( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) > requiredDistSq )
		wait .05;
	
	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("Aborting exposed approach because self.disableArrivals is true");
		#/
		return;
	}

	if ( !isdefined( self.pathGoalPos ) )
	{
		/#
		debug_arrival("Aborting exposed approach because I have no path");
		#/
		return;
	}
	
	if ( self.a.pose != "stand" || self.a.movement != "run" )
	{
		/#
		debug_arrival( "approach aborted at last minute: not standing and running" );
		#/
		return;
	}
	
	dist = distance( self.origin, self.pathGoalPos );
	if ( abs( dist - animDist ) > allowedError )
	{
		/#
		debug_arrival("Aborting exposed approach because distance difference exceeded allowed error: " + dist + " more than " + allowedError + " from " + animDist);
		#/
		return;
	}
	
	facingYaw = vectorToAngles( self.pathGoalPos - self.origin )[1];
	
	delta = anim.cornerTransDist["exposed"][self.approachNumber];
	assert( delta[0] != 0 );
	yawToMakeDeltaMatchUp = atan( delta[1] / delta[0] );
	
	requiredYaw = facingYaw - yawToMakeDeltaMatchUp;
	if ( abs( AngleClamp( requiredYaw - self.angles[1], "-180 to 180" ) ) > 30 )
	{
		/#
		debug_arrival("Aborting exposed approach because angle change was too great");
		#/
		return;
	}
	
	closerDist = dist - animDist;
	idealStartPos = self.origin + VectorScale( vectorNormalize( self.pathGoalPos - self.origin ), closerDist );
	
	self startcoverarrival( idealStartPos, requiredYaw );
}

// pretend the word "corner" is "cover and exposed".
startCornerLeave()
{
	self endon("killanimscript");
	
	self.exitingCover = false;
	
	// if we don't know where we're going, we can't check if it's a good idea to do the exit animation
	// (and it's probably not)
	if ( !isdefined( self.pathGoalPos ) )
		return;
	
	if ( self.a.pose == "prone" )
		return;
	
	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
		return;
	
	// assume an exit from exposed.
	exitpos = self.origin;
	exityaw = self.angles[1];
	exittype = "exposed";
	
	// if we're at a node, try to do an exit from the node.
	if ( isdefined( self.prevNode ) )
	{
		determineNodeApproachType( self.prevNode );

		if ( isdefined( self.prevNode.approachtype ) && self.prevNode.approachtype != "exposed" )
		{
			// if far from cover node, or angle is wrong, don't do exit behavior for the node.
			
			distancesq = distancesquared( self.prevNode.origin, self.origin );
			anglediff = abs( AngleClamp( self.angles[1] - self.prevNode.angles[1] - getNodeStanceYawOffset( self.prevNode.approachtype ), "-180 to 180") );
			if ( distancesq < 225 && anglediff < 5 ) // (225 = 15 * 15)
			{
				// do exit behavior for the node.
				exitpos = self.prevNode.origin;
				exityaw = self.prevNode.angles[1];
				exittype = self.prevNode.approachtype;
			}
		}
	}
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		println("^3exiting cover (ent " + self getentnum() + ", type \"" + exittype + "\"):");
		println("   lookaheaddir = (" + self.lookaheaddir[0] + ", " + self.lookaheaddir[1] + ", " + self.lookaheaddir[2] + ")");
		angle = AngleClamp( vectortoangles( self.lookaheaddir )[1] - exityaw, "-180 to 180");
		if ( angle < 0 )
			println("   (Angle of " + (0-angle) + " right from node forward.)");
		else
			println("   (Angle of " + angle + " left from node forward.)");
	}
	#/
	
	if ( !isdefined( exittype ) )
	{
		/#
		debug_arrival( "aborting exit: not supported for node type " + self.prevNode.type );
		#/
		return;
	}
	
	// since we transition directly into a standing run anyway,
	// we might as well just use the standing exits when crouching too
	if ( exittype == "exposed" )
	{
		if ( self.a.pose != "stand" && self.a.pose != "crouch" )
		{
			/#
			debug_arrival( "exposed exit aborted because anim_pose is not \"stand\"" );
			#/
			return;
		}
		if ( self.a.movement != "stop" )
		{
			/#
			debug_arrival( "exposed exit aborted because anim_movement is not \"stop\"" );
			#/
			return;
		}
	}
	
	
	// TODO: TEMP! this can be removed once we get some "exit_align" notetracks in the exposed exits, as well as all the right animations
	/*if ( exittype == "exposed" )
	{
		/#
		debug_arrival( "exposed exit aborted; temporarily unsupported" );
		#/
		return;
	}*/
	
	// TODO: TEMP! this can be removed once we get some "exit_align" notetracks in the cover crouch exits.
	if ( exittype == "crouch" )
	{
		/*if ( !isdefined( level.lastcovercrouchspamtime ) || level.lastcovercrouchspamtime + 10000 < gettime() )
		{
			debug_arrival( "Cover Crouch exits are still TODO! bug #41776" );
			level.lastcovercrouchspamtime = gettime();
		}*/
		return;
	}

	
	if ( exittype == "crouch" || exittype == "stand" )
	{
		if ( abs( AngleClamp( vectorToAngles( self.lookaheaddir )[1] - exityaw, "-180 to 180" ) ) < 60 )
		{
			/#
			debug_arrival( "aborting exit: lookaheaddir is too far forward for node type " + exittype );
			#/
			return;
		}
	}
	
	// since we're leaving, take the opposite direction of lookahead
	leaveDir = ( -1 * self.lookaheaddir[0], -1 * self.lookaheaddir[1], 0 );
	
	//println("lookaheaddir: " + self.lookaheaddir[0] + " " + self.lookaheaddir[1] );
	
	
	result = getMaxDirectionsAndExcludeDirFromApproachType( exittype );
	maxDirections = result.maxDirections;
	excludeDir = result.excludeDir;
	
	exityaw = exityaw + getNodeStanceYawOffset( exittype );
	
	angleDataObj = spawnstruct();
	
	calculateNodeTransitionAngles( angleDataObj, exittype, false, exityaw, leaveDir, maxDirections, excludeDir );
	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	approachnumber = -1;
	numAttempts = 3;
	if ( exittype == "exposed" )
		numAttempts = 2;
	
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
	
		approachNumber = angleDataObj.transIndex[i];
		if ( self checkCoverExitPos( exitpos, exityaw, exittype, approachNumber ) )
			break;

		/#
		debug_arrival( "exit blocked: dir " + approachNumber );
		#/
	}
	
	if ( i > numAttempts )
	{
		/#
		debug_arrival( "aborting exit: too many exit directions blocked" );
		#/
		return;
	}

	// if AI is closer to destination than arrivalPos is, don't do exit
	allowedDistSq = distanceSquared( self.origin, self.coverExitPos ) * 1.25*1.25;
	if ( distanceSquared( self.origin, self.pathgoalpos ) < allowedDistSq )
	{
		/#
		debug_arrival( "exit failed, too close to destination node" );
		#/
		return;
	}

	/#
	debug_arrival( "exit success: dir " + approachNumber );
	#/
	self doCoverExitAnimation( exittype, approachNumber );
}

str( val )
{
	if (!isdefined(val))
		return "{undefined}";
	return val;
}

doCoverExitAnimation( exittype, approachNumber )
{
	assert( isdefined( approachNumber ) );
	assert( approachnumber > 0 );
	
	assert( isdefined( exittype ) );

	leaveAnim = anim.cornerExit[exittype][approachnumber];
	
	assert( isdefined( leaveAnim ) );

	lookaheadAngles = vectortoangles( self.lookaheaddir );
	
	transTime = 0.2;
	// we don't have crouch anims for exposed, so transition over a longer period of time.
	if ( exittype == "exposed" && self.a.pose != "stand" )
	{
		if ( self.a.pose == "prone" )
			return;
		
		transTime = 0.5;
		self.a.pose = "stand";
	}
	
	self animMode( "zonly_physics", 0 );
	self OrientMode( "face current" );
	self setFlaggedAnimKnobAllRestart( "coverexit", leaveAnim, %body, 1, transTime, 1 );
	
	hasExitAlign = animHasNotetrack( leaveAnim, "exit_align" );
	if ( !hasExitAlign )
		println("^1Animation anim.cornerExit[\"" + exittype + "\"][" + approachnumber + "] has no \"exit_align\" notetrack. Please bug this!");

	self thread DoNoteTracksForExit( "coverexit", hasExitAlign );
	
	self waittillmatch( "coverexit", "exit_align" );
	
	self.exitingCover = true;
	
	self.a.pose = "stand";
	self.a.movement = "run";
	
	while ( 1 )
	{
		curfrac = self getAnimTime( leaveAnim );
		remainingMoveDelta = getMoveDelta( leaveAnim, curfrac, 1 );
		remainingAngleDelta = getAngleDelta( leaveAnim, curfrac, 1 );
		faceYaw = lookaheadAngles[1] - remainingAngleDelta;
		
		// make sure we can complete the animation in this direction
		forward = anglesToForward( (0,faceYaw,0) );
		right = anglesToRight( (0,faceYaw,0) );
		endPoint = self.origin + vectorScale( forward, remainingMoveDelta[0] ) - vectorScale( right, remainingMoveDelta[1] );
		
		if ( self mayMoveToPoint( endPoint ) )
		{
			self OrientMode( "face angle", faceYaw );
			break;
		}
		
		// wait a bit or until the animation is over, then try again
		
		timeLeft = getAnimLength( leaveAnim ) * (1 - curfrac) - .05;
		
		if ( timeLeft < .05 )
			break;
		
		if ( timeLeft > .4 )
			timeleft = .4;
		
		wait timeleft;
	}
	
	self waittillmatch("coverexit", "end");
	
	self clearanim( %root, 0 );

	// the end of the exit animations (should) line up *exactly* with the start of the run animations.
	// Play a run animation immediately so that if we blend to something other than a run, we don't pop.
	self setAnimRestart( %combatrun_forward_1, 1, 0 );
	
	self OrientMode( "face motion" );
	self animMode( "normal", 0 );
}

DoNoteTracksForExit( animname, hasExitAlign )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );

	if ( !hasExitAlign )
		self notify( animname, "exit_align" ); // failsafe
}

/*RestartAllMoveAnims( timeUntilTheyWrap )
{
	// rely on loopsynch to reset the time of all movement animations
	fractionalTimeUntilTheyWrap = timeUntilTheyWrap / getAnimLength( %combatrun_forward_1 );
	// this doesn't work unless the anim has a goal weight > 0
	self setanim( %combatrun_forward_1, .01, 1000 );
	self setanim( %precombatrun1, .01, 1000 );
	self setAnimTime( %combatrun_forward_1, 1 - fractionalTimeUntilTheyWrap );
	self setAnimTime( %precombatrun1, 1 - fractionalTimeUntilTheyWrap );
}*/


drawVec( start, end, duration, color )
{
	for( i = 0; i < duration * 100; i++ )
	{
		line( start + (0,0,30), end + (0,0,30), color);
		wait 0.05;
	}
}

drawApproachVec(approach_dir)
{
	self endon("killanimscript");
	for(;;)
	{
		if(!isdefined(self.node))
			break;
		line(self.node.origin + (0,0,20), (self.node.origin - vectorscale(approach_dir,64)) + (0,0,20));	
		wait(0.05);
	}	
}

calculateNodeTransitionAngles( angleDataObj, approachtype, isarrival, arrivalYaw, approach_dir, maxDirections, excludeDir )
{
	angleDataObj.transitions = [];
	angleDataObj.transIndex = [];
	
	anglearray = undefined;
	sign = 1;
	offset = 0;
	if ( isarrival )
	{
		anglearray = anim.cornerTransAngles[approachtype];
		sign = -1;
		offset = 0;
	}
	else
	{
		anglearray = anim.cornerExitAngles[approachtype];
		sign = 1;
		offset = 180;
	}
	
	for ( i = 1; i <= maxDirections; i++ )
	{
		angleDataObj.transIndex[i] = i;
		
		if ( i == 5 || i == excludeDir || !isdefined( anglearray[i] ) )
		{
			angleDataObj.transitions[i] = -1.0001;	// cos180 - epsilon
			continue;
		}
		
		angles = ( 0, arrivalYaw + sign * anglearray[i] + offset, 0 );
		
		dir = vectornormalize( anglestoforward( angles ) );
		angleDataObj.transitions[i] = vectordot( approach_dir, dir );
	}
}

/#
printdebug(pos, offset, text, color, linecolor)
{
	for ( i = 0; i < 20*5; i++ )
	{
		line(pos, pos+offset, linecolor);
		print3d(pos + offset, text, (color,color,color));
		wait .05;
	}
}
#/


// TODO: probably better done in code
// (actually, for an array of 8 elements, insertion sort should be fine)
sortNodeTransitionAngles( angleDataObj, maxDirections )
{
	for ( i = 2; i <= maxDirections; i++ )
	{
		currentValue = angleDataObj.transitions[ angleDataObj.transIndex[i] ];
		currentIndex = angleDataObj.transIndex[i];
		
		for ( j = i-1; j >= 1; j-- )
		{
			if ( currentValue < angleDataObj.transitions[ angleDataObj.transIndex[j] ] )
				break;
			
			angleDataObj.transIndex[j + 1]  = angleDataObj.transIndex[j];
		}
		
		angleDataObj.transIndex[j + 1] = currentIndex;
	}
}

checkCoverExitPos( exitpoint, exityaw, exittype, approachNumber )
{
	angle = (0, exityaw, 0);
	
	forwardDir = anglestoforward( angle );
	rightDir = anglestoright( angle );

	forward = vectorscale( forwardDir, anim.cornerExitDist[exittype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.cornerExitDist[exittype][approachNumber][1] );
	
	exitPos = exitpoint + forward - right;
	self.coverExitPos = exitPos;
	
	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( self.origin, exitpos, (1,.5,.5), 1.5 );
	#/
	if ( !( self maymovefrompointtopoint( self.origin, exitPos ) ) )
		return false;

	if ( approachNumber <= 6 || exittype == "exposed" )
		return true;

	assert( exittype == "left" || exittype == "left_crouch" || exittype == "right" || exittype == "right_crouch" );

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the first part, from node to corner, now doing from corner to end of exit anim)
	forward = vectorscale( forwardDir, anim.cornerExitPostDist[exittype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.cornerExitPostDist[exittype][approachNumber][1] );
	
	finalExitPos = exitPos + forward - right;
	self.coverExitPos = finalExitPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( exitpos, finalExitPos, (1,.5,.5), 1.5 );
	#/
	return ( self maymovefrompointtopoint( exitPos, finalExitPos ) );
}

checkCoverEnterPos( arrivalpoint, arrivalYaw, approachtype, approachNumber )
{
	angle = (0, arrivalYaw - anim.cornerTransAngles[approachtype][approachNumber], 0);
	
	forwardDir = anglestoforward( angle );
	rightDir = anglestoright( angle );

	forward = vectorscale( forwardDir, anim.cornerTransDist[approachtype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.cornerTransDist[approachtype][approachNumber][1] );
	
	enterPos = arrivalpoint - forward + right;
	self.coverEnterPos = enterPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( enterPos, arrivalpoint, (1,.5,.5), 1.5 );
	#/
	if ( !( self maymovefrompointtopoint( enterPos, arrivalpoint ) ) )
		return false;
	
	if ( approachNumber <= 6 || approachtype == "exposed" )
		return true;
	
	assert( approachtype == "left" || approachtype == "left_crouch" || approachtype == "right" || approachtype == "right_crouch" );
	
	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the second part, from corner to node, now doing from start of enter anim to corner)
	
	forward = vectorscale( forwardDir, anim.cornerTransPreDist[approachtype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.cornerTransPreDist[approachtype][approachNumber][1] );
	
	originalEnterPos = enterPos - forward + right;
	self.coverEnterPos = originalEnterPos;
	
	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( originalEnterPos, enterPos, (1,.5,.5), 1.5 );
	#/
	return ( self maymovefrompointtopoint( originalEnterPos, enterPos ) );
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
