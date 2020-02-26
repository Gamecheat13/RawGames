#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\debug;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree ("generic_human");

// --------------------------------------------------------------------------------
// ---- Cover Arrival  ----
// --------------------------------------------------------------------------------
main()
{
	/#self animscripts\debug::debugPushState( "Cover Arrival" );#/

	self endon("killanimscript");

	if( self.a.pose != "stand" )
	{
		// arrivals only available from stand right now
		/#self animscripts\debug::debugPopState( "Cover Arrival", "Not standing" );#/
		return;
	}
	
	newstance = getNewStance();
	if(newstance == "")
		return;

	const blendInDuration = 0.3;

	assert( IsDefined( self.approachAnim ), "Arrival anim not defined (" + self.animtype + " - exit_" + self.approachType + " - " + self.approachNumber + ")" );

	/////// Some arrival animations are long so movement events need to be added here.
	// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
	//animTime = self getAnimTime( self.approachAnim);
	//addreactionevent ("movement",animTime+blendInDuration,self);
	///////

	self ClearAnim( %root, blendInDuration );
	self SetFlaggedAnimKnobRestart( "coverArrival", self.approachAnim, 1, blendInDuration, 1 );
	self animscripts\shared::DoNoteTracks( "coverArrival" );
	
	//dds going to cover trigger
	self maps\_dds::dds_notify( "thrt_open", ( self.team != "allies" ) );
		
	///////
	// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
	//addreactionevent ("movement",3,self);
	///////
	
	if ( IsDefined( newstance ) )
	{
		self.a.pose = newstance;
	}

	self.a.movement = "stop";
	self.a.arrivalType = self.approachType;
	self ClearAnim( %root, .3 );	
	
	/#self animscripts\debug::debugPopState( "Cover Arrival" );#/
}

setupAapproachNodePreConditions()
{
	// if we're going to do a negotiation, we want to wait until it's over and move.gsc is called again
	if ( IsDefined( self getnegotiationstartnode() ) )
	{
		/#debug_arrival( "Not doing approach: path has negotiation start node" );#/
		return false;
	}

	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#debug_arrival("Not doing approach: self.disableArrivals is true");#/
		return false;
	}

	if ( !self IsStanceAllowed("stand" ) && !self IsStanceAllowed("crouch") )
	{
		/#debug_arrival("Not doing approach: May not be allowed to stand or crouch while arriving");#/
		return false;
	}
	
	if ( self.a.pose == "prone" )
	{
		/#debug_arrival("Not doing approach: (ent " + self getentnum() + "): self.a.pose is \"prone\"");#/
		return false;
	}

	return true;
}

setupApproachNode( firstTime )
{
	self endon("killanimscript");
	
	// this lets code know that script is expecting the "corner_approach" notify
	if ( firstTime )
		self.requestArrivalNotify = true;
		
	self.a.arrivalType = undefined;
	self thread doLastMinuteExposedApproachWrapper();
		
	// "corner_approach" actually means "cover_approach".
	self waittill( "corner_approach", approach_dir );
	
	if( !self setupAapproachNodePreConditions() )
	{
		return;
	}

	self thread setupApproachNode( false );	// wait again
	
	approachType		= "exposed";
	approachPoint		= self.pathGoalPos;
	approachNodeYaw		= VectorToAngles( approach_dir )[1];
	approachFinalYaw	= approachNodeYaw;

	if ( IsDefined( self.node ) )
	{
		determineNodeApproachType( self.node );
		if ( IsDefined( self.node.approachtype ) && self.node.approachtype != "exposed" )
		{
			approachType = self.node.approachtype;

			if ( approachType == "stand_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = AnglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = AnglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + VectorScale( forward, -32.545 ) - VectorScale( right, 6.899 );
			}
			else if ( approachType == "crouch_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = AnglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = AnglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + VectorScale( forward, -32.545 ) - VectorScale( right, 6.899 );
			}
			else if ( approachType == "prone_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = AnglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = AnglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + VectorScale( forward, -37.36 ) - VectorScale( right, 13.279 );
			}
			else
			{
				approachPoint = self.node.origin;
			}
				
			approachNodeYaw = self.node.angles[1];
			approachFinalYaw = approachNodeYaw + getNodeStanceYawOffset( approachType );
		}
	}

	/#setupApproachNodeDebug( approachType, approach_dir, approachNodeYaw );#/
	
	// we're doing default exposed approaches in doLastMinuteExposedApproach now
	if ( approachType == "exposed" || approachtype == "exposed_cqb" )
		return;
	
	startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir );
}

startCornerApproachPreConditions( approachType, approach_dir )
{
	if ( approachType == "stand" || approachType == "crouch" )
	{
		assert( IsDefined( self.node ) );
		
		forwardAngle = AbsAngleClamp180( VectorToAngles( approach_dir )[1] - self.node.angles[1] + 180 );
		
		if ( forwardAngle <= 80 )
		{
			/#debug_arrival( "approach aborted: approach_dir is too far forward for node type " + self.node.type );#/
			return false;
		}
	}

	return true;
}

startCornerApproachConditions( approachPoint, approachType, approachNumber, approachFinalYaw )
{
	 if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#debug_arrival("approach aborted at last minute: self.disableArrivals is true");#/
		return false;
	}

	// so we don't make guys turn around when they're (smartly) facing their enemy as they walk away
	if ( abs( self getMotionAngle() ) > 45 && IsDefined( self.enemy ) && vectorDot( AnglesToForward( self.angles ), VectorNormalize( self.enemy.origin - self.origin ) ) > .6 )
	{
		if( DistanceSquared( self.origin, self.enemy.origin ) < 512 * 512 )
		{
			/#debug_arrival("approach aborted at last minute: facing enemy instead of current motion angle");#/
			return false;
		}	
	}

	if ( self.a.pose != "stand" || ( self.a.movement != "run" && self.a.movement != "walk" && !( ISCQB(self) ) ) )
	{
		/#debug_arrival( "approach aborted at last minute: not standing and running" );#/
		return false;
	}

	requiredYaw = approachFinalYaw - angleDeltaArray("arrive_" + approachType)[approachNumber];	 
	if( AbsAngleClamp180( requiredYaw - self.angles[1] ) > 30 )
	{
		// don't do an approach away from an enemy that we would otherwise face as we moved away from them
		if( isValidEnemy( self.enemy ) && self canSee( self.enemy ) )
		{
			// check if enemy is in frontish of us
			if ( vectorDot( AnglesToForward( self.angles ), self.enemy.origin - self.origin ) > 0 )
			{
				/#debug_arrival( "aborting approach at last minute: don't want to turn back to nearby enemy" );#/
				return false;
			}
		}
	}

	// make sure the path is still clear
	if ( !checkCoverEnterPos( approachPoint, approachFinalYaw, approachType, approachNumber, false ) )
	{
		/#debug_arrival( "approach blocked at last minute" );#/
		return false;
	}

	return true;
}

approachWaitTillClose( node, checkDist )
{
	const allowedError = 8;
	const maxSpeed	= 250; // units/sec

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

getApproachEnt()
{
	if ( isdefined( self.node ) )
		return self.node;

	return undefined;
}

startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir, forceCQB )
{
	self endon("killanimscript");
	self endon("corner_approach");
	
	assert( IsDefined( approachType ) );
	
	if( !self startCornerApproachPreConditions( approachType, approach_dir ) )
	{
		return;
	}
		
	result				   = getMaxDirectionsAndExcludeDirFromApproachType( approachType );
	maxDirections		   = result.maxDirections;
	excludeDir			   = result.excludeDir;
	approachNumber		   = -1;

	node				   = getApproachEnt();
	arrivalFromFront	   = vectorDot( approach_dir, anglestoforward( node.angles ) ) >= 0;
	arrivalFromFront	   = arrivalFromFront && vectorDot( VectorNormalize( self.origin - node.origin ), anglestoforward( node.angles ) ) <= 0;
		
	doingCQBApproach = shouldDoCQBTransition( self.node, approachType, 1, forceCQB );
	if( doingCQBApproach )
		approachType = approachType + "_cqb";
	
	result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approach_dir, maxDirections, excludeDir, arrivalFromFront );

	/#
	for ( i = 0; i < result.data.size; i++ )
	{
		debug_arrival( result.data[i] );
	}
	#/

	if ( result.approachNumber < 0 )
	{
		// try the cqb transitions since they're shorter
		if( !doingCQBApproach && canDoCQBTransition( self.node, approachType, 1 ) )
		{
			/#debug_arrival( "approach aborted: " + result.failure );#/
			/#debug_arrival( "attempting cqb approach" );#/
			

			return startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir, true );
		}

		/#debug_arrival( "approach aborted: " + result.failure );#/
		return;
	}

	approachNumber = result.approachNumber;
	/#debug_arrival( "approach success: dir " + approachNumber );#/


	// send an AI to the cover enter position from the current position.
	if( IsDefined(result.approachPoint) )	
	{		
		/#thread debug_arrival_line( self.origin, result.approachPoint, level.color_debug[ "red" ], 1.5 );#/
		self.coverEnterPos = result.approachPoint;
	}
	
	if ( approachNumber <= 6 && arrivalFromFront )
	{
		self endon( "goal_changed" );

		const allowedError = 8;
		self.arrivalStartDist = longestApproachDist( "arrive_" + approachtype );
		approachWaitTillClose( node, self.arrivalStartDist + allowedError );

		// get the best approach direction from current position
		dirToNode = vectorNormalize( approachPoint - self.origin );
		
		// HACK - if the previous approachNumber is 6 then we do want to ignore 9 as it will not remain a arrivalFromFront in that case.
		// if the previous approachNumber is 4 then we do want to ignore 7 as it will not remain a arrivalFromFront in that case.
		if( approachNumber == 4 )
			excludeDir = 7;
		
		if( approachNumber == 6 )
			excludeDir = 9;
		
		result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, dirToNode, maxDirections, excludeDir, arrivalFromFront );

		// get the new approach number as that can be different from the original one
		if( result.approachNumber != -1 && result.approachNumber != approachNumber )
			approachNumber = result.approachNumber;

		/#thread debug_arrival_line( self.origin, self.coverEnterPos, level.color_debug["red"], 1.5 );#/
		
		moveDeltaArray		  = moveDeltaArray("arrive_"+approachtype);
		self.arrivalStartDist = length( moveDeltaArray[approachNumber] );
		approachWaitTillClose( node, self.arrivalStartDist );

		if ( !( self maymovetopoint( approachPoint ) ) )
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

		// do not arrive if turning currently and trying to arrive at the same time
		if( IsDefined( self.a.isTurning ) && self.a.isTurning ) 
			return;

		if( !self startCornerApproachConditions( approachPoint, approachType, approachNumber, approachFinalYaw ) )
			return;
		
		/# debug_arrival( "final approach success: dir " + approachNumber ); #/

		requiredYaw = approachFinalYaw - angleDeltaArray("arrive_" + approachType)[approachNumber];
	}
	else
	{
		self setRunToPos( self.coverEnterPos );
		self waittill("runto_arrived");

		requiredYaw = approachFinalYaw - angleDeltaArray("arrive_" + approachType)[approachNumber];	 

		if( !self startCornerApproachConditions( approachPoint, approachType, approachNumber, approachFinalYaw ) )
			return;
	}
	
	self.approachNumber = approachNumber;
	self.approachType = approachType;
	self.approachAnim = animArray("arrive_" + approachType)[approachNumber];
	self.startcoverarrival = true;
	self startcoverarrival( self.coverEnterPos, requiredYaw );
}

CheckArrivalEnterPositions( approachpoint, approachYaw, approachtype, approach_dir, maxDirections, excludeDir, arrivalFromFront )
{
	angleDataObj = SpawnStruct();
	
	calculateNodeTransitionAngles( angleDataObj, approachtype, true, approachYaw, approach_dir, maxDirections, excludeDir );
	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	resultobj = SpawnStruct();
	/#resultobj.data = [];#/
	
	arrivalPos = (0, 0, 0);
	resultobj.approachNumber = -1;
	resultobj.approachPoint = undefined;
			
	numAttempts = 2;
	if ( approachtype == "exposed" || approachtype == "exposed_cqb" )
		numAttempts = 1;
		
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
		
		resultobj.approachNumber = angleDataObj.transIndex[i];
		if ( !self checkCoverEnterPos( approachpoint, approachYaw, approachtype, resultobj.approachNumber, arrivalFromFront ) )
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
	
	/#
	distToApproachPoint = Distance( approachpoint, self.origin );
	distToAnimStart = Distance( approachpoint, self.coverEnterPos );
	#/
	
	distToApproachPoint = DistanceSquared( approachpoint, self.origin );
	distToAnimStart = DistanceSquared( approachpoint, self.coverEnterPos );

	/#recordLine( approachpoint, self.coverEnterPos, level.color_debug[ "green" ], "Cover", self );#/

	if ( distToApproachPoint < distToAnimStart )
	{
		if ( distToApproachPoint < distToAnimStart )
		{
			/#resultobj.failure = "too close to destination";#/
			resultobj.approachNumber = -1;
			return resultobj;
		}

		if ( !arrivalFromFront )
		{
			selfToAnimStart = VectorNormalize( self.coverEnterPos - self.origin );
			AnimStartToNode = VectorNormalize( approachpoint - self.coverEnterPos );
		
			cosAngle = vectorDot( selfToAnimStart, AnimStartToNode );

			if ( cosAngle <  0.707 )// 0.707 == cos( 45 )
			{
				/#resultobj.failure = "angle to start of animation is too great ( angle of " + acos( cosAngle ) + " > 45 )";#/
				resultobj.approachNumber = -1;
				return resultobj;
			}
		}
	}
	
	return resultobj;
}

checkCoverEnterPos( arrivalpoint, arrivalYaw, approachtype, approachNumber, arrivalFromFront )
{	
	/#
	if ( debug_arrivals_on_actor() )
		debug_arrival("checkCoverEnterPos() checking for arrive_" + approachtype + "_" + approachNumber );
	#/

		
	angle = (0, arrivalYaw - angleDeltaArray("arrive_"+approachtype)[approachNumber], 0);

	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );

	moveDeltaArray	   = moveDeltaArray("arrive_"+approachtype);
	forward			   = VectorScale( forwardDir, moveDeltaArray[approachNumber][0] );
	right			   = VectorScale( rightDir, moveDeltaArray[approachNumber][1] );
	enterPos	       = arrivalpoint - forward + right;
	self.coverEnterPos = enterPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debug_arrival_line( enterPos, arrivalpoint, level.color_debug[ "cyan" ], 1.5 );
	#/
		
	if ( approachNumber <= 6 && arrivalFromFront )
		return true;

	if ( !( self MayMoveFromPointToPoint( enterPos, arrivalpoint ) ) )
		return false;
	
	if ( approachNumber <= 6 || IsSubStr( ToLower( approachtype ), "exposed" ) )
		return true;
	
	assert( approachtype == "left" || approachtype == "left_crouch" || approachtype == "right" || approachtype == "right_crouch" ||
		approachtype == "left_cqb" || approachtype == "left_crouch_cqb" || approachtype == "right_cqb" || approachtype == "right_crouch_cqb" ||
		approachtype == "pillar" || approachtype == "pillar_crouch" );

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the second part, from corner to node, now doing from start of enter anim to corner)
	preMoveDeltaArray  = preMoveDeltaArray("arrive_"+approachtype);
	forward		       = VectorScale( forwardDir, preMoveDeltaArray[approachNumber][0] );
	right			   = VectorScale( rightDir, preMoveDeltaArray[approachNumber][1] );
	originalEnterPos   = enterPos - forward + right;
	self.coverEnterPos = originalEnterPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debug_arrival_line( originalEnterPos, enterPos, level.color_debug[ "cyan" ], 1.5 );
	#/

	return ( self MayMoveFromPointToPoint( originalEnterPos, enterPos ) );
}



// --------------------------------------------------------------------------------
// ---- Last minute exposed approach  ----
// --------------------------------------------------------------------------------
doLastMinuteExposedApproachWrapper()
{
	self endon("killanimscript");

	self notify("doing_last_minute_exposed_approach");
	self endon ("doing_last_minute_exposed_approach");
	
	self thread watchGoalChanged();
	
	while(1)
	{
		doLastMinuteExposedApproach();
		
		// try again when our goal pos changes
		while(1)
		{
			self waittill_any("goal_changed", "goal_changed_previous_frame");

			// our goal didn't *really* change if it only changed because we called setRunToPos
			if ( IsDefined( self.coverEnterPos ) && IsDefined( self.pathGoalPos ) && DistanceSquared( self.coverEnterPos, self.pathGoalPos ) < 1 )
			{
				continue;
			}

			break;
		}
	}
}

watchGoalChanged()
{
	self endon("killanimscript");
	self endon ("doing_last_minute_exposed_approach");
	
	while(1)
	{
		self waittill("goal_changed");
		wait .05;
		self notify("goal_changed_previous_frame");
	}
}

doLastMinuteExposedApproachPreConditions()
{
	if ( IsDefined( self getnegotiationstartnode() ) )
		return false;

	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#debug_arrival("Aborting exposed approach because self.disableArrivals is true");#/
		return false;
	}

	return true;
}

doLastMinuteExposedApproachMidConditions()
{
	if( self.a.pose != "stand" || ( self.a.movement != "run" && self.a.movement != "walk" ) )
	{
		/#debug_arrival( "Aborting exposed approach - not standing and running" );#/
		return false;
	}
	
	if( IsDefined( self.grenade ) && IsDefined( self.grenade.activator ) && self.grenade.activator == self )
	{
		/#debug_arrival( "Aborting exposed approach - holding the grenade." );#/
		return false;
	}

	return true;
}

doLastMinuteExposedApproachConditions( animDist, allowedError )
{
	if ( !IsDefined( self.pathGoalPos ) )
	{
		/#debug_arrival("Aborting exposed approach because I have no path");#/
		return false;
	}

	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		/# debug_arrival( "Aborting exposed approach because self.disableArrivals is true" ); #/
		return false;
	}

	// check if facing enemy in ( TacticalWalk or RunNGun )
	if( abs( self getMotionAngle() ) > 45 )
	{
		/# debug_arrival( "Aborting exposed approach because not facing motion and not going to a node" ); #/
		return false;
	}

	if ( self.a.pose != "stand" || ( self.a.movement != "run" && self.a.movement != "walk" ) )
	{
		/#debug_arrival( "approach aborted at last minute: not standing and running" );#/
		return false;
	}

	dist = distance( self.origin, self.pathGoalPos );	
	
	// only do an arrival if we have a clear path
	if ( !self maymovetopoint( self.pathGoalPos ) )
	{
		/#debug_arrival( "Aborting exposed approach: maymove check failed, AnimDist = " + animDist + " Dist = " + dist );#/
		return false;
	}

	if ( abs( dist - animDist ) > allowedError )
	{
		/#debug_arrival("Aborting exposed approach because distance difference exceeded allowed error: " + dist + " more than " + allowedError + " from " + animDist);#/
		return false;
	}

	return true;
}

determineExposedApproachType( node )
{
	type = "exposed";

	stance = node getHighestNodeStance();

	// no approach to prone
	if ( stance == "prone" )
		stance = "crouch";

	if ( stance == "crouch" )
		type = "exposed_crouch";
	else
		type = "exposed";

	// switch to cqb if needed
	if( self shouldDoCQBTransition( node, type ) )
		type = type + "_cqb";

	return type;
}

faceEnemyAtEndOfApproach( node )
{
	if ( !IsValidEnemy( self.enemy ) )
		return false;

	if( self.combatmode == "exposed_nodes_only" )
		return true;

	if ( ISHEAT(self) && Isdefined( node ) ) 
		return false;
	
	if ( self.combatmode == "cover" && isSentient( self.enemy ) && gettime() - self lastKnownTime( self.enemy ) > 15000 )
		return false;

	return sightTracePassed( self.enemy getShootAtPos(), self.pathGoalPos + ( 0, 0, 60 ), false, undefined );
}

doLastMinuteExposedApproach()
{
	self endon("goal_changed");
	
	if( !self doLastMinuteExposedApproachPreConditions() )
		return;

	// wait until we get close enough to start the arrival
	self exposedApproachWaitTillClose();

	if( !self doLastMinuteExposedApproachMidConditions() )
		return;
	
	const allowedError	= 8;
	const maxSpeed		= 250; // units/sec

	// decide the approach type
	approachType	= "exposed";
	const maxDistToNodeSq = 1;
	goalMatchesNode = false;

	// if pathGoalPos matches the node position then we are going to the node.
	// in that case, change the approachtype according to the allowed stance at the node
	// its still going to be exposed approach though.
	if( IsDefined( self.node ) && IsDefined( self.pathGoalPos ) )
		goalMatchesNode = DistanceSquared( self.pathGoalPos, self.node.origin ) < maxDistToNodeSq;
	
	if( goalMatchesNode )	
		approachType = determineExposedApproachType( self.node );

	approachDir = VectorNormalize( self.pathGoalPos - self.origin );
	
	// by default, want to face forward
	desiredFacingYaw = VectorToAngles( approachDir )[1];

	if( faceEnemyAtEndOfApproach( self.node )  )
	{
		desiredFacingYaw = VectorToAngles( self.enemy.origin - self.pathGoalPos )[1];
	}
	else 
	{
		faceNodeAngle = IsDefined( self.node ) && goalMatchesNode;
		faceNodeAngle = faceNodeAngle && ( self.node.type != "Path" ) && ( self.node.type != "ambush" || !recentlySawEnemy() );

		if ( faceNodeAngle )
		{
			desiredFacingYaw = getNodeForwardYaw( self.node );
		}
		else
		{
			likelyEnemyDir = self getAnglesToLikelyEnemyPath();
			if ( IsDefined( likelyEnemyDir ) )
				desiredFacingYaw = likelyEnemyDir[1];
		}
	}
		
	angleDataObj = SpawnStruct();
	calculateNodeTransitionAngles( angleDataObj, approachType, true, desiredFacingYaw, approachDir, 9, -1 );
	
	// take best animation
	best = 1;
	for ( i = 2; i <= 9; i++ )
	{
		if ( angleDataObj.transitions[i] > angleDataObj.transitions[best] )
			best = i;
	}

	// node cqb is handled in determineExposedApproachType() already
	if( !IsSubStr( approachType, "_cqb" ) && shouldDoCQBTransition( undefined, approachType ) )
		approachType = approachType + "_cqb";
	
	self.approachNumber = angleDataObj.transIndex[best];
	self.approachType = approachType;
			
	self.approachAnim = animArray("arrive_"+approachType)[self.approachNumber];
	animDist = length( moveDeltaArray("arrive_"+approachType)[self.approachNumber] );	
	
	requiredDistSq = animDist + allowedError;
	requiredDistSq = requiredDistSq * requiredDistSq;
	
	// we should already be close
	while( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) > requiredDistSq )
		wait .05;
		
	if ( isdefined( self.arrivalStartDist ) && self.arrivalStartDist < animDist + allowedError )
	{
		/# debug_arrival( "Aborting exposed approach because cover arrival dist is shorter" ); #/
		return;
	}

	if( !self doLastMinuteExposedApproachConditions( animDist, allowedError )	)
		return;
	
	dist	  = distance( self.origin, self.pathGoalPos );
	facingYaw = VectorToAngles( self.pathGoalPos - self.origin )[1];
		
	if( animDist > 0 )
	{
		delta				  = moveDeltaArray("arrive_"+approachType)[self.approachNumber];
		assert( delta[0] != 0 );
		yawToMakeDeltaMatchUp = atan( delta[1] / delta[0] );

		if( self.faceMotion )
		{
			requiredYaw			  = facingYaw - yawToMakeDeltaMatchUp;
			if ( AbsAngleClamp180( requiredYaw - self.angles[1] ) > 30 )
			{
				/#debug_arrival("Aborting exposed approach because angle change was too great");#/
				return;
			}
		}
		else
		{
			requiredYaw = self.angles[1];
		}

		closerDist = dist - animDist;
		idealStartPos = self.origin + VectorScale( VectorNormalize( self.pathGoalPos - self.origin ), closerDist );
	}
	else
	{
		requiredYaw	  = self.angles[1];
		idealStartPos = self.origin;
	}
	
	/#debug_arrival("Doing exposed approach in direction " + self.approachNumber);#/
			
	self startcoverarrival( idealStartPos, requiredYaw );
}


exposedApproachWaitTillClose()
{
	const maxSpeed	 = 200; // units/sec
	const allowedError = 6;

	// wait until we get to the point where we have to decide what approach animation to play
	while(1)
	{
		if ( !IsDefined( self.pathGoalPos ) )
			self waitForPathGoalPos();
	
		dist = distance( self.origin, self.pathGoalPos );

		if ( dist <= longestExposedApproachDist() + allowedError )
			break;
		
		// underestimate how long to wait so we don't miss the crucial point
		waittime = (dist - longestExposedApproachDist()) / maxSpeed - .1;
		if ( waittime < .05 )
			waittime = .05;
		
		wait waittime;
	}
}

waitForPathGoalPos()
{
	while(1)
	{
		if ( IsDefined( self.pathgoalpos ) )
		{
			return;
		}
		
		wait 1;
	}
}

alignToNodeAngles()
{
	self endon("killanimscript");
	self endon("goal_changed");
	self endon( "dont_align_to_node_angles" );
	self endon("doing_last_minute_exposed_approach");
	
	waittillframeend;

	// this is a last ditch fake approach.
	// we gradually turn to face the direction we want to face at the node
	// as we get there.
	const maxdist = 80;
	
	while(1)
	{
		if ( !IsDefined( self.node ) || IsDefined( anim.isPathNode[ self.node.type ] ) || IsDefined( anim.isCombatScriptNode[ self.node.type ] ) || !IsDefined( self.pathGoalPos ) || DistanceSquared( self.node.origin, self.pathGoalPos ) > 1 )
			return;
			
		// don't do this if we're too far away.
		if ( DistanceSquared( self.origin, self.node.origin ) > maxdist * maxdist )
		{
			wait .05;
			continue;
		}
		
		// don't do this if we're going to do an approach.
		if ( IsDefined( self.coverEnterPos ) && IsDefined( self.pathGoalPos ) && DistanceSquared( self.coverEnterPos, self.pathGoalPos ) < 1 )
		{
			wait .1;
			continue;
		}
		
		break;
	}
	
	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		return;
	}

	startdist = distance( self.origin, self.node.origin );
	
	if ( startdist <= 0 )
	{
		return;
	}
	
	determineNodeApproachType( self.node );
	
	startYaw = self.angles[1];
	targetYaw = self.node.angles[1];
	if ( IsDefined( self.node.approachtype ) )
	{
		targetYaw += getNodeStanceYawOffset( self.node.approachtype );
	}

	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);
	
	self thread resetOrientModeOnGoalChange();

	while(1)
	{
		if ( !IsDefined( self.node ) )
		{
			self OrientMode("face default");
			return;
		}
				
		dist = distance( self.origin, self.node.origin );
		
		if ( dist > startdist * 1.1 ) // failsafe
		{
			self OrientMode("face default");
			return;
		}
		
		distfrac = 1.0 - (dist / startdist);
		
		currentYaw = startYaw + distfrac * (targetYaw - startYaw);
		self OrientMode( "face angle", currentYaw );
		wait .05;
	}
}

resetOrientModeOnGoalChange()
{
	self endon("killanimscript");
	self waittill_any("goal_changed", "dont_align_to_node_angles");
	
	self OrientMode("face default");
}

// --------------------------------------------------------------------------------
// ---- Cover Exit  ----
// --------------------------------------------------------------------------------

startMoveTransitionPreConditions()
{
	if ( !IsDefined( self.pathGoalPos ) )
	{
		/#debug_arrival("not exiting cover (ent " + self getentnum() + "): self.pathGoalPos is undefined");	#/
		return false;
	}

	if ( !self ShouldFaceMotion() )
	{
		if( !animscripts\run::ShouldFullSprint() && self WeaponAnims() != "rocketlauncher" )
		{
			/# debug_arrival( "not exiting cover (ent " + self getentnum() + "): ShouldFaceMotion is false" ); #/
			return false;
		}
	}

	if ( self.a.pose == "prone" )
	{
		/#debug_arrival("not exiting cover (ent " + self getentnum() + "): self.a.pose is \"prone\"");#/
		return false;
	}

	if ( IsDefined( self.disableExits ) && self.disableExits )
	{
		/#debug_arrival("not exiting cover (ent " + self getentnum() + "): self.disableExits is true");#/
		return false;
	}

	if ( !self IsStanceAllowed( "stand" ) )
	{
		/#debug_arrival("not exiting cover (ent " + self getentnum() + "): not allowed to stand");#/
		return false;
	}

	return true;
}

startMoveTransitionMidConditions( exitNode, exittype )
{
	if ( !IsDefined( exittype ) )
	{
		/#debug_arrival( "aborting exit: not supported for node type " + exitNode.type );#/
		return false;
	}

	// since we transition directly into a standing run anyway, we might as well just use the standing exits when crouching too
	if ( exittype == "exposed" )
	{
		if ( self.a.pose != "stand" && self.a.pose != "crouch" )
		{
			/#debug_arrival( "exposed exit aborted because anim_pose is not \"stand\" or \"crouch\"" );	#/
			return false;
		}

		if ( self.a.movement != "stop" )
		{
			/#debug_arrival( "exposed exit aborted because anim_movement is not \"stop\"" );#/
			return false;
		}
	}

	return true;
}

startMoveTransitionFinalConditions( exittype, approachNumber )
{
	// don't do an exit away from an enemy that we would otherwise face as we moved away from them
	//if its either 1/2/3 direction then there is a chance that AI will be turning back on the nearby enemy
	if ( exittype == "exposed" && approachNumber < 4 )
	{
		if ( isValidEnemy( self.enemy ) )
		{
			if ( vectorDot( AnglesToForward( self.angles ), self.enemy.origin - self.origin ) > 0.707 )
			{
				if ( self canSeeEnemyFromExposed() && DistanceSquared( self.origin, self.enemy.origin ) < 200 * 200 )
				{
					/#debug_arrival( "aborting exit in dir" + approachNumber + ": don't want to turn back to nearby enemy" );#/
					return false;
				}
			}
		}
	}
	
	return true;
}

startMoveTransition()
{
	self endon("killanimscript");
	
	if( !self startMoveTransitionPreConditions() ) 		
		return;

	// assume an exit from exposed to start with.
	exitpos = self.origin;
	exityaw = self.angles[1];
	exittype = "exposed";
	
	// get the exit node
	exitNode = undefined;
	if ( IsDefined( self.node ) && ( DistanceSquared( self.origin, self.node.origin ) < 225 ) )
		exitNode = self.node;
	else if ( IsDefined( self.prevNode ) )
		exitNode = self.prevNode;

	// if we're at a node, try to do an exit from the node.
	if ( IsDefined( exitNode ) )
	{
		determineNodeExitType( exitNode );

		if ( IsDefined( exitNode.approachtype ) && exitNode.approachtype != "exposed" && exitNode.approachtype != "stand_saw" && exitNode.approachType != "crouch_saw" )
		{
			// if far from cover node, or angle is wrong, don't do exit behavior for the node.
			distancesq = DistanceSquared( exitNode.origin, self.origin );
			anglediff = AbsAngleClamp180( self.angles[1] - exitNode.angles[1] - getNodeStanceYawOffset( exitNode.approachtype ) );
			if ( distancesq < 225 && anglediff < 5 ) // (225 = 15 * 15)
			{
				// do exit behavior for the node.
				exitpos = exitNode.origin;
				exityaw = exitNode.angles[1];
				exittype = exitNode.approachtype;
			}
		}
	}
	
	/#self startMoveTransitionDebug(  exittype, exityaw );#/
	
	if( !startMoveTransitionMidConditions( exitNode, exittype ) )
		return;

	// since we transition directly into a standing run anyway, we might as well just use the standing exits when crouching too
	if ( exittype == "exposed" )
	{
		if ( self.a.pose == "crouch" )
			exittype = "exposed_crouch";
	}
	
	// since we're leaving, take the opposite direction of lookahead
	leaveDir	  = ( -1 * self.lookaheaddir[0], -1 * self.lookaheaddir[1], 0 );
	result		  = getMaxDirectionsAndExcludeDirFromApproachType( exittype );
	maxDirections = result.maxDirections;
	excludeDir	  = result.excludeDir;
	exityaw		  = exityaw + getNodeStanceYawOffset( exittype );
	
	// Switch to CQB transition if needed
	if( shouldDoCQBTransition( exitNode, exittype ) )
		exittype = exittype + "_cqb";
	
	angleDataObj = SpawnStruct();
	calculateNodeTransitionAngles( angleDataObj, exittype, false, exityaw, leaveDir, maxDirections, excludeDir );
	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	approachnumber = -1;
	numAttempts = 2;

	// if this is an exposed exit then prevent going in different directin than the original path
	if ( IsSubStr( exittype, "exposed" ) )
		numAttempts = 1;

	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
	
		approachNumber = angleDataObj.transIndex[i];
		if ( self checkCoverExitPos( exitpos, exityaw, exittype, approachNumber, true ) )
		{
			break;
		}

		/#debug_arrival( "exit blocked: dir " + approachNumber );#/
	}
	
	if ( i > numAttempts )
	{
		/#debug_arrival( "aborting exit: too many exit directions blocked" );#/
		return;
	}
	
	// If AI is closer to destination than arrivalPos is, don't do exit
	allowedDistSq	= DistanceSquared( self.origin, self.coverExitPos );// * 1.25*1.25;
	availableDistSq = DistanceSquared( self.origin, self.pathgoalpos ); 

	if( availableDistSq < allowedDistSq )
	{
		/#debug_arrival( "exit failed, too close to destination");#/
		return;
	}

	if( !startMoveTransitionFinalConditions( exittype, approachNumber ) )
		return;
	
	/#debug_arrival( "exit success: dir " + approachNumber );#/

	//dds Ai leaving cover "He's breakign from cover""!= will play on oposite team that triggered dds, == for same team" 
	//Print3d(self.origin, "Going to leave cover",(1.0,0.8,0.5),1,1,60);
	self thread maps\_dds::dds_notify( "thrt_breaking", ( self.team != "allies" ) );

	//dds Ai movement trigger "I am moveing!"
	//Print3d(self.origin, "lets GO",(1.0,0.8,0.5),1,1,60);		
	self maps\_dds::dds_notify( "rspns_movement", ( self.team == "allies" ) );	
	
	self doCoverExitAnimation( exittype, approachNumber );
}

checkCoverExitPos( exitpoint, exityaw, exittype, approachNumber, checkWithPath )
{
	angle = (0, exityaw, 0);

	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );

	moveDeltaArray = moveDeltaArray("exit_"+exittype);

	forward = VectorScale( forwardDir, moveDeltaArray[approachNumber][0] );
	right   = VectorScale( rightDir, moveDeltaArray[approachNumber][1] );

	exitPos = exitpoint + forward - right;
	self.coverExitPos = exitPos;

	isExposedApproach = ( exittype == "exposed" || exittype == "exposed_crouch" );
	isExposedApproach = ( isExposedApproach || ( exittype == "exposed_cqb" || exittype == "exposed_crouch_cqb" ) );

	/#
	if ( debug_arrivals_on_actor() )
		thread debug_arrival_line( self.origin, exitpos, level.color_debug[ "green" ], 1.5 );
	#/

	if ( !isExposedApproach && checkWithPath && !( self checkCoverExitPosWithPath( exitPos ) ) )
	{
		/#debug_arrival( "cover exit " + approachNumber + " path check failed" );#/
		return false;
	}

	if ( !( self MayMoveFromPointToPoint( self.origin, exitPos ) ) )
	{
		return false;
	}

	if ( approachNumber <= 6 || isExposedApproach )
	{
		return true;
	}

	assert( exittype == "left" || exittype == "left_crouch" || exittype == "right" || exittype == "right_crouch" ||
		exittype == "left_cqb" || exittype == "left_crouch_cqb" || exittype == "right_cqb" || exittype == "right_crouch_cqb" ||
		exittype == "pillar" || exittype == "pillar_crouch" );

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the first part, from node to corner, now doing from corner to end of exit anim)
	postMoveDeltaArray = postMoveDeltaArray("exit_"+exittype);
	forward = VectorScale( forwardDir, postMoveDeltaArray[approachNumber][0] );
	right   = VectorScale( rightDir, postMoveDeltaArray[approachNumber][1] );

	finalExitPos = exitPos + forward - right;
	self.coverExitPos = finalExitPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debug_arrival_line( exitpos, finalExitPos, level.color_debug[ "green" ], 1.5 );
	#/

	return ( self MayMoveFromPointToPoint( exitPos, finalExitPos ) );
}


doCoverExitAnimation( exittype, approachNumber )
{
	assert( IsDefined( approachNumber ) );
	assert( approachnumber > 0 );
	assert( IsDefined( exittype ) );

	leaveAnim = animArray("exit_"+exittype)[approachnumber];
	assert( IsDefined( leaveAnim ), "Exit anim not found (" + self.animtype + " - exit_" + exittype + " - " + approachnumber + ")" );

	lookaheadAngles = VectorToAngles( self.lookaheaddir );
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		endpos = self.origin + VectorScale( self.lookaheaddir, 100 );
		thread debug_arrival_line( self.origin, endpos, level.color_debug[ "red" ], 1.5 );
	}
	#/
	
	if ( self.a.pose == "prone" )
		return;
	
	/#self animscripts\debug::debugPushState( "Cover Exit" );#/

	const transTime = 0.2;
	self AnimMode( "zonly_physics", false );
	self OrientMode( "face angle", self.angles[1] );
	const rate = 1;	
			
	self setFlaggedAnimKnobAllRestart( "coverexit", leaveAnim, %body, 1, transTime, rate );

	animStartTime = GetTime();
	const blendOutDuration = 0.15;
	const runBlendInDuration = 0.15;
	
	hasExitAlign = animHasNotetrack( leaveAnim, "exit_align" );
	
	/#
	if ( !hasExitAlign )
		debug_arrival( "^1Animation exit_" + exittype + "[" + approachnumber + "] has no \"exit_align\" notetrack" );
	#/
		
	self thread DoNoteTracksForExit( "coverexit", hasExitAlign );
	
	self waittillmatch( "coverexit", "exit_align" );
	self.a.pose = "stand";
	self.a.movement = "run";

	hasCodeMoveNoteTrack = animHasNotetrack( leaveAnim, "code_move" );

	while ( 1 )
	{
		curfrac = self getAnimTime( leaveAnim );
		remainingMoveDelta = getMoveDelta( leaveAnim, curfrac, 1 );
		remainingAngleDelta = getAngleDelta( leaveAnim, curfrac, 1 );
		faceYaw = lookaheadAngles[1] - remainingAngleDelta;
		
		// make sure we can complete the animation in this direction
		forward = AnglesToForward( (0,faceYaw,0) );
		right = AnglesToRight( (0,faceYaw,0) );
		endPoint = self.origin + VectorScale( forward, remainingMoveDelta[0] ) - VectorScale( right, remainingMoveDelta[1] );
		
		if ( self mayMoveToPoint( endPoint ) )
		{
			self OrientMode( "face angle", faceYaw );
			break;
		}
		
		if ( hasCodeMoveNoteTrack )
			break;
		
		// wait a bit or until the animation is over, then try again
		timeLeft = getAnimLength( leaveAnim ) * (1 - curfrac) - blendOutDuration - .05;
		
		if ( timeLeft < .05 )
		{
			break;
		}
		
		if ( timeLeft > .4 )
		{
			timeleft = .4;
		}
		
		wait timeleft;
	}

	if ( hasCodeMoveNoteTrack )
	{
		notetrack_times = GetNotetrackTimes( leaveAnim, "code_move" );
		absolute_code_move_time = getAnimLength(leaveAnim) * notetrack_times[0];

		curfrac = self getAnimTime( leaveAnim );
		current_anim_time = getAnimLength(leaveAnim) * curfrac;

		if( absolute_code_move_time > current_anim_time + 0.05 )
		{
			// the code_move notetrack won't fire if the anim is being blended out
			if( absolute_code_move_time + blendOutDuration > getAnimLength(leaveAnim) )
			{
				wait( getAnimLength(leaveAnim) - absolute_code_move_time );
			}
			else
			{
				self waittillmatch( "coverexit", "code_move" );
			}
		}
	
		self OrientMode( "face motion" );
		self AnimMode( "none", false );
	}

	// Wait until [blendOutDuration] seconds before the end of the animation to start the next one.
	// This way, we start blending in the new anim before this one ends.
	totalAnimTime	= getAnimLength( leaveAnim ) / rate;
	timePassed		= (GetTime() - animStartTime) / 1000;
	timeLeft		= totalAnimTime - timePassed - blendOutDuration;
	if ( timeLeft > 0 )
	{
		wait timeLeft;
	}

	self ClearAnim( %root, blendOutDuration );

	self OrientMode( "face default" );
	//self thread faceEnemyOrMotionAfterABit();
	self AnimMode( "normal", false );

	/#self animscripts\debug::debugPopState( "Cover Exit" );#/
}

/*
faceEnemyOrMotionAfterABit()
{
	self endon("killanimscript");
	
	wait 1.0;
	
	// don't want to spin around if we're almost where we're going anyway
	while ( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) < 200*200 )
	{
		wait .25;
	}
	
	self OrientMode( "face default" );
}
*/

DoNoteTracksForExit( animname, hasExitAlign )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );

	if ( !hasExitAlign )
	{
		self notify( animname, "exit_align" ); // failsafe
	}
}

// --------------------------------------------------------------------------------
// ---- Common cover exit/arrival functions ----
// --------------------------------------------------------------------------------

getNewStance()
{
	newstance = undefined;

	switch ( self.approachtype )
	{
	case "left":
	case "right":
	case "left_cqb":
	case "right_cqb":
	case "stand":
	case "stand_saw":
	case "exposed":
	case "exposed_cqb":
	case "pillar":
		newstance = "stand";
		break;

	case "left_crouch":
	case "right_crouch":
	case "left_crouch_cqb":
	case "right_crouch_cqb":
	case "crouch_saw":
	case "crouch":
	case "exposed_crouch":
	case "exposed_crouch_cqb":
	case "pillar_crouch":
		newstance = "crouch";
		break;

	case "prone_saw":
		newstance = "prone";
		break;

	default:
		assertmsg("bad node approach type: " + self.approachtype);
		return "";			
	}

	return newstance;
}


getNodeStanceYawOffset( approachtype )
{
	// returns the base stance's yaw offset when hiding at a node, based off the approach type
	if ( approachtype == "left" || approachtype == "left_crouch" )
	{
		return 90.0;
	}
	else if ( approachtype == "right" || approachtype == "right_crouch" )
	{
		return -90.0;
	}
	else if ( approachtype == "pillar" || approachtype == "pillar_crouch" )
	{
		return 180.0;
	}

	return 0;
}


canUseSawApproach( node )
{
	// SCRIPTER_MOD: JesseS (6/25/2007): updated for COD 5 weapons
	if ( 	self.weapon != "saw" 		&& self.weapon != "rpd" 
		&& 	self.weapon != "dp28"		&& self.weapon != "dp28_bipod" 
		&& 	self.weapon != "bren" 		&& self.weapon != "bren_bipod"  
		&& 	self.weapon != "30cal" 		&& self.weapon != "30cal_bipod"
		&& 	self.weapon != "bar" 		&& self.weapon != "bar_bipod"
		&& 	self.weapon != "mg42" 		&& self.weapon != "mg42_bipod" 
		&& 	self.weapon != "fg42" 		&& self.weapon != "fg42_bipod" 
		&& 	self.weapon != "type99_lmg" && self.weapon != "type99_lmg_bipod" )
	{
		return false;
	}

	if ( !IsDefined( node.turretInfo ) )
	{
		return false;
	}

	if ( node.type != "Cover Stand" && node.type != "Cover Prone" && node.type!= "Cover Crouch" )
	{
		return false;
	}

	if ( IsDefined( self.enemy ) && DistanceSquared( self.enemy.origin, node.origin ) < 256*256 )
	{
		return false;
	}

	if ( GetNodeYawToEnemy() > 40 || GetNodeYawToEnemy() < -40 )
	{
		return false;
	}

	return true;
}

determineNodeApproachType( node )
{
	if ( canUseSawApproach( node ) )
	{
		if ( node.type == "Cover Stand" )
			node.approachtype = "stand_saw";
	
		if ( node.type == "Cover Crouch" )
			node.approachtype = "crouch_saw";
		else if ( node.type == "Cover Prone" )
			node.approachtype = "prone_saw";
	
		assert( IsDefined( node.approachtype ) );
		return;
	}

	// AI_TODO - Do we need this? HMG guys should only go on pathnodes or deploy.
	// So lets disable their arrivals unless they're set up the MG.
	if (self is_heavy_machine_gun())
	{ 
		if ( node.type == "Path" )
			self.disablearrivals = true;
		else
			self.disablearrivals = false;
	}

	if ( !IsDefined( anim.approach_types[ node.type ] ) )
		return;
	
	nodeType = node.type;

	// no pillar arrival anims for pistol, so cheat by using cover left and right
	if( nodeType == "Cover Pillar" && usingPistol() )
	{
		if( ISNODEDONTRIGHT(node) )
			nodeType = "Cover Right";
		else
			nodeType = "Cover Left";
	}

	stance = ISNODEDONTSTAND(node) && !ISNODEDONTCROUCH(node);
	node.approachtype = anim.approach_types[ nodeType ][ stance ];
}


determineNodeExitType( node )
{
	if ( canUseSawApproach( node ) )
	{
		if ( node.type == "Cover Stand" )
			node.approachtype = "stand_saw";
		
		if ( node.type == "Cover Crouch" )
			node.approachtype = "crouch_saw";
		else if ( node.type == "Cover Prone" )
			node.approachtype = "prone_saw";
		
		assert( IsDefined( node.approachtype ) );
		return;
	}
	
	if ( !IsDefined( anim.approach_types[ node.type ] ) )
		return;
	
	nodeType = node.type;
	
	// no pillar arrival anims for pistol, so cheat by using cover left and right
	if( nodeType == "Cover Pillar" && usingPistol() )
	{
		if( ISNODEDONTRIGHT(node) )
			nodeType = "Cover Right";
		else
			nodeType = "Cover Left";
	}
			
	if( self.a.pose == "stand" )
		node.approachtype = anim.approach_types[ nodeType ][0];
	else
		node.approachtype = anim.approach_types[ nodeType ][1];
}

getMaxDirectionsAndExcludeDirFromApproachType( approachtype )
{
	returnobj = SpawnStruct();

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
	else if ( approachtype == "stand" || approachtype == "crouch" || approachtype == "stand_saw" || approachType == "crouch_saw" )
	{
		returnobj.maxDirections = 6;
		returnobj.excludeDir = -1;
	}
	else if ( approachtype == "exposed" || approachtype == "exposed_crouch" || approachtype == "pillar" || approachtype == "pillar_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = -1;
	}
	else if ( approachtype == "prone_saw" )
	{
		returnobj.maxDirections = 3;
		returnobj.excludeDir = -1;
	}
	else
	{
		assertmsg( "unsupported approach type " + approachtype );
	}

	return returnobj;
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
		anglearray = angleDeltaArray("arrive_"+approachtype);

		sign = -1;
		offset = 0;
	}
	else
	{
		anglearray = angleDeltaArray("exit_"+approachtype);

		sign = 1;
		offset = 180;
	}
	
	for ( i = 1; i <= maxDirections; i++ )
	{
		angleDataObj.transIndex[i] = i;
		
		if ( i == 5 || i == excludeDir || !IsDefined( anglearray[i] ) )
		{
			angleDataObj.transitions[i] = -1.0003;	// cos180 - epsilon
			continue;
		}
		
		angles = ( 0, arrivalYaw + sign * anglearray[i] + offset, 0 );
		
		dir = VectorNormalize( AnglesToForward( angles ) );
		angleDataObj.transitions[i] = vectordot( approach_dir, dir );
	}
}

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
			{
				break;
			}
			
			angleDataObj.transIndex[j + 1]  = angleDataObj.transIndex[j];
		}
		
		angleDataObj.transIndex[j + 1] = currentIndex;
	}
}

shouldDoCQBTransition( node, type, isExit, forceCQB )
{
	// no CQB transition if this AI is in heat mode
	if( ( !IsDefined( forceCQB ) || !forceCQB ) && ISHEAT(self) )
		return false;

	if( !animscripts\cqb::shouldCQB() )
	{
		if( !IsDefined(forceCQB) || !forceCQB )
			return false;
	}

	return canDoCQBTransition( node, type, isExit );
}

canDoCQBTransition( node, type, isExit )
{
	// pistol AI does not do CQB
	if( AIHasOnlyPistol() )
		return false;
	
	// CQB transitions are supported for exposed but not for pillar
	if( ( IsSubStr( type, "_cqb" ) && !IsSubStr( ToLower( type ), "pillar" ) ) || type == "exposed" || type == "exposed_crouch" )
		return true;

	if( IsDefined( isExit ) && isExit )
	{
		Assert( IsDefined(type) );

		if( type == "left" || type == "right" )
			return true;
	}

	// CQB transitions are supported only for cover left and right for now	
	if( IsDefined( node ) && ( node.type == "Cover Left" || node.type == "Cover Right"  ) && !IsSubStr( ToLower( type ), "pillar" ) )
		return true;

	return false;
}


//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}

// --------------------------------------------------------------------------------
// ---- Cover Arrival Debug functions  ----
// --------------------------------------------------------------------------------

/#
// Cover Exit debug functions
startMoveTransitionDebug( exittype, exityaw )
{
	debug_arrival("^3exiting cover (ent " + self getentnum() + ", type \"" + exittype + "\"):");
	debug_arrival("lookaheaddir = (" + self.lookaheaddir[0] + ", " + self.lookaheaddir[1] + ", " + self.lookaheaddir[2] + ")");

	angle = AngleClamp180( VectorToAngles( self.lookaheaddir )[1] - exityaw );
	if ( angle < 0 )
	{
		debug_arrival("   (Angle of " + (0-angle) + " right from node forward.)");
	}
	else
	{
		debug_arrival("   (Angle of " + angle + " left from node forward.)");
	}
}

// Cover arrival debug functions
setupApproachNodeDebug( approachType, approach_dir, approachNodeYaw )
{
	debug_arrival("^5approaching cover (ent " + self getentnum() + ", type \"" + approachType + "\"):");
	debug_arrival("   approach_dir = (" + approach_dir[0] + ", " + approach_dir[1] + ", " + approach_dir[2] + ")");

	angle = AngleClamp180( VectorToAngles( approach_dir )[1] - approachNodeYaw + 180 );
	if ( angle < 0 )
	{
		debug_arrival("   (Angle of " + (0-angle) + " right from node forward.)");
	}
	else
	{
		debug_arrival("   (Angle of " + angle + " left from node forward.)");
	}


	// we're doing default exposed approaches in doLastMinuteExposedApproach now
	if ( approachType == "exposed" )
	{		
		if ( IsDefined( self.node ) )
		{
			if ( IsDefined( self.node.approachtype ) )
			{
				debug_arrival( "Aborting cover approach: node approach type was " + self.node.approachtype );
			}
			else
			{
				debug_arrival( "Aborting cover approach: node approach type was undefined" );
			}
		}
		else
		{
			debug_arrival( "Aborting cover approach: self.node is undefined" );
		}

		return;	
	}

	if ( debug_arrivals_on_actor() )
	{
		thread drawApproachVec(approach_dir);
	}
}

drawApproachVec(approach_dir)
{
	self endon("killanimscript");

	for(;;)
	{
		if(!IsDefined(self.node))
		{
			break;
		}

		line(self.node.origin + (0,0,20), (self.node.origin - VectorScale(approach_dir,64)) + (0,0,20));	
		recordLine(self.node.origin + (0,0,20), (self.node.origin - VectorScale(approach_dir,64)) + (0,0,20));	
		wait(0.05);
	}	
}

#/

/#
debug_arrivals_on_actor()
{
	dvar = GetDvarint( "ai_debugCoverArrivals" );
	if ( dvar == 0 )
	{
		return false;
	}
	
	if ( dvar == 1 )
	{
		return true;
	}
	
	if ( int( dvar ) == self getentnum() )
	{
		return true;
	}
	
	return false;
}
#/
	
/#
debug_arrival( msg )
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

	println( msg );

	recordEntText( msg, self, level.color_debug["white"], "Cover" );
}
#/
	
/#
debug_arrival_cross(atPoint, radius, color, durationFrames)
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debug_arrival_line(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debug_arrival_line(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debug_arrival_line(atPoint_forward,	atPoint_back,	color, durationFrames);
}
#/
	
/#
debug_arrival_line( start, end, color, duration )
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

	if( IsDefined(self) )
	{
		recordLine( start, end, color, "Cover", self );
	}

	debugLine( start, end, color, duration );
}
#/
	
/#
debug_arrival_record_text( msg, position, color )
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

	Record3DText( msg, position, color, "Animscript" );

}
#/

// --------------------------------------------------------------------------------
// ---- Cover Arrival/Exit Tool  ----
// --------------------------------------------------------------------------------

/#
fakeAiLogic()
{
	self.animType		= "default";
	self.a.script		= "move";
	self.a.pose			= "stand";
	self.a.prevPose		= "stand";
	self.weapon			= "ak47_sp";

	self.ignoreMe		= true;
	self.ignoreAll		= true;

	self AnimMode("nogravity");
	self ForceTeleport( get_players()[0].origin + (0,0,-1000), self.origin );

	while( IsDefined(self) && IsAlive(self) )
	{
		wait(0.05);
	}
}

coverArrivalDebugTool()
{
	// same as nodeColorTable in pathnode.cpp
	nodeColors =  [];
	nodeColors["Cover Stand"]			=  (0, 0.54, 0.66);
	nodeColors["Cover Crouch"]			=  (0, 0.93, 0.72);
	nodeColors["Cover Crouch Window"]	=  (0, 0.7, 0.5);
	nodeColors["Cover Prone"]			=  (0, 0.6, 0.46);
	nodeColors["Cover Right"]			=  (0.85, 0.85, 0.1);
	nodeColors["Cover Left"]			=  (1, 0.7, 0);
	nodeColors["Conceal Stand"]			=  (0, 0, 1);
	nodeColors["Conceal Crouch"]		=  (0, 0, 0.75);
	nodeColors["Conceal Prone"]			=  (0, 0, 0.5);
	nodeColors["Turret"]				=  (0, 0.93, 0.72);
	nodeColors["Bad"]					=  (1, 0, 0);
	nodeColors["Poor"]					=  (1,0.5,0);
	nodeColors["Ok"]					=  (1, 1, 0);
	nodeColors["Good"]					=  (0, 1, 0);

	wait_for_first_player();

	player = get_players()[0];

	// same as PREDICTION_TRACE_MIN + AIPHYS_STEPSIZE and PREDICTION_TRACE_MAX in actor_navigation.cpp
	traceMin = (-15,-15,18);
	traceMax = (15,15,72);

	hudGood = NewDebugHudElem();
	hudGood.location = 0;
	hudGood.alignX = "left";
	hudGood.alignY = "middle";
	hudGood.foreground = 1;
	hudGood.fontScale = 1.3;
	hudGood.sort = 20;
	hudGood.x = 680;
	hudGood.y = 240;
	hudGood.og_scale = 1;
	hudGood.color = nodeColors["Good"];
	hudGood.alpha = 1;

	hudOk = NewDebugHudElem();
	hudOk.location = 0;
	hudOk.alignX = "left";
	hudOk.alignY = "middle";
	hudOk.foreground = 1;
	hudOk.fontScale = 1.3;
	hudOk.sort = 20;
	hudOk.x = 680;
	hudOk.y = 260;
	hudOk.og_scale = 1;
	hudOk.color = nodeColors["Ok"];
	hudOk.alpha = 1;

	hudPoor = NewDebugHudElem();
	hudPoor.location = 0;
	hudPoor.alignX = "left";
	hudPoor.alignY = "middle";
	hudPoor.foreground = 1;
	hudPoor.fontScale = 1.3;
	hudPoor.sort = 20;
	hudPoor.x = 680;
	hudPoor.y = 280;
	hudPoor.og_scale = 1;
	hudPoor.color = nodeColors["Poor"];
	hudPoor.alpha = 1;

	hudBad = NewDebugHudElem();
	hudBad.location = 0;
	hudBad.alignX = "left";
	hudBad.alignY = "middle";
	hudBad.foreground = 1;
	hudBad.fontScale = 1.3;
	hudBad.sort = 20;
	hudBad.x = 680;
	hudBad.y = 300;
	hudBad.og_scale = 1;
	hudBad.color = nodeColors["Bad"];
	hudBad.alpha = 1;

	hudTotal = NewDebugHudElem();
	hudTotal.location = 0;
	hudTotal.alignX = "left";
	hudTotal.alignY = "middle";
	hudTotal.foreground = 1;
	hudTotal.fontScale = 1.3;
	hudTotal.sort = 20;
	hudTotal.x = 680;
	hudTotal.y = 330;
	hudTotal.og_scale = 1;
	hudTotal.color = (1,1,1);
	hudTotal.alpha = 1;

	hudGoodText = NewDebugHudElem();
	hudGoodText.location = 0;
	hudGoodText.alignX = "right";
	hudGoodText.alignY = "middle";
	hudGoodText.foreground = 1;
	hudGoodText.fontScale = 1.3;
	hudGoodText.sort = 20;
	hudGoodText.x = 670;
	hudGoodText.y = 240;
	hudGoodText.og_scale = 1;
	hudGoodText.color = nodeColors["Good"];
	hudGoodText.alpha = 1;
	hudGoodText SetText("Good: ");

	hudOkText = NewDebugHudElem();
	hudOkText.location = 0;
	hudOkText.alignX = "right";
	hudOkText.alignY = "middle";
	hudOkText.foreground = 1;
	hudOkText.fontScale = 1.3;
	hudOkText.sort = 20;
	hudOkText.x = 670;
	hudOkText.y = 260;
	hudOkText.og_scale = 1;
	hudOkText.color = nodeColors["Ok"];
	hudOkText.alpha = 1;
	hudOkText SetText("Ok: ");

	hudPoorText = NewDebugHudElem();
	hudPoorText.location = 0;
	hudPoorText.alignX = "right";
	hudPoorText.alignY = "middle";
	hudPoorText.foreground = 1;
	hudPoorText.fontScale = 1.3;
	hudPoorText.sort = 20;
	hudPoorText.x = 670;
	hudPoorText.y = 280;
	hudPoorText.og_scale = 1;
	hudPoorText.color = nodeColors["Poor"];
	hudPoorText.alpha = 1;
	hudPoorText SetText("Poor: ");

	hudBadText = NewDebugHudElem();
	hudBadText.location = 0;
	hudBadText.alignX = "right";
	hudBadText.alignY = "middle";
	hudBadText.foreground = 1;
	hudBadText.fontScale = 1.3;
	hudBadText.sort = 20;
	hudBadText.x = 670;
	hudBadText.y = 300;
	hudBadText.og_scale = 1;
	hudBadText.color = nodeColors["Bad"];
	hudBadText.alpha = 1;
	hudBadText SetText("Bad: ");	

	hudLineText = NewDebugHudElem();
	hudLineText.location = 0;
	hudLineText.alignX = "left";
	hudLineText.alignY = "middle";
	hudLineText.foreground = 1;
	hudLineText.fontScale = 1.3;
	hudLineText.sort = 20;
	hudLineText.x = 630;
	hudLineText.y = 315;
	hudLineText.og_scale = 1;
	hudLineText.color = (1,1,1);
	hudLineText.alpha = 1;
	hudLineText SetText("------------------");

	hudTotalText = NewDebugHudElem();
	hudTotalText.location = 0;
	hudTotalText.alignX = "right";
	hudTotalText.alignY = "middle";
	hudTotalText.foreground = 1;
	hudTotalText.fontScale = 1.3;
	hudTotalText.sort = 20;
	hudTotalText.x = 670;
	hudTotalText.y = 330;
	hudTotalText.og_scale = 1;
	hudTotalText.color = (1,1,1);
	hudTotalText.alpha = 1;
	hudTotalText SetText("Total: ");

	badNode = undefined;

	fakeAi = undefined;

	while(1)
	{
		tool = GetDvarint( "ai_debugCoverArrivalsTool");

		// check if there's a node selected in Radiant
		if( tool <= 0 && IsDefined(level.nodedrone) && IsDefined(level.nodedrone.currentnode) )
		{
			tool = 1;
		}

		if( tool <= 0 )
		{
			if( IsDefined(fakeAi) )
			{
				fakeAi Delete();
				fakeAi = undefined;
			}

			// hide the UI
			hudBad.alpha		= 0;
			hudPoor.alpha		= 0;
			hudOk.alpha			= 0;
			hudGood.alpha		= 0;
			hudTotal.alpha		= 0;
			hudBadText.alpha	= 0;
			hudPoorText.alpha	= 0;
			hudOkText.alpha		= 0;
			hudGoodText.alpha	= 0;
			hudLineText.alpha	= 0;
			hudTotalText.alpha	= 0;

			wait 0.2;
			continue;
		}

		// spawn the fakeAi
		if( !IsDefined(fakeAi) )
		{
			spawners = getSpawnerArray();

			for( i=0; i < spawners.size; i++ )
			{
				fakeAi = spawners[i] StalingradSpawn();

				if( IsDefined(fakeAi) )
				{
					fakeAi AnimCustom( ::fakeAiLogic );
					break;
				}
			}

			if( !IsDefined(fakeAi) )
			{
				//iprintlnbold("no suitable spawners found in level");
				wait 0.2;
				continue;
			}
		}

		// show the UI
		hudBad.alpha		= 1;
		hudPoor.alpha		= 1;
		hudOk.alpha			= 1;
		hudGood.alpha		= 1;
		hudTotal.alpha		= 1;
		hudBadText.alpha	= 1;
		hudPoorText.alpha	= 1;
		hudOkText.alpha		= 1;
		hudGoodText.alpha	= 1;
		hudLineText.alpha	= 1;
		hudTotalText.alpha	= 1;

		numBad				= 0;
		numPoor				= 0;
		numOk				= 0;
		numGood				= 0;
		tracesThisFrame		= 0;
		renderedThisFrame	= 0;
		evaluatedThisframe	= 0;

		// find all cover node within given radius
		radius = GetDvarfloat( "ai_debugCoverArrivalsToolRadius");
		nodes = GetAnyNodeArray( player.origin, radius );

		// show the node selected in Radiant
		if( tool > 0 && IsDefined(level.nodedrone) && IsDefined(level.nodedrone.currentnode) )
		{
			nodes = [];
			nodes[0] = level.nodedrone.currentnode;
		}

		showNodes = GetDvarint( "ai_debugCoverArrivalsToolShowNodes");

		totalNodes = 1;
		if( showNodes > 0 || nodes.size == 0 )
		{
			totalNodes = nodes.size;
		}

		fakeAi.cqb	= false;
		fakeAi.weapon		= "ak47_sp";
		fakeAi.heat			= false;

		// set cqb/pistol
		toolType = GetDvarint( "ai_debugCoverArrivalsToolType");
		if( toolType == 1 )
		{
			fakeAi.cqb = true;
		}
		else if( toolType == 2 )
		{
			fakeAi.weapon = "m1911_sp";
		}

		// ALEXP_TODO: this is pretty useless.. need to do it off FPS
		// scale based on number of AI (more AI -> lower FPS)
		const minAi = 5;
		const maxAi = 15;
		const nodesMin = 5;
		const nodesMax = 30;

		allAi = entsearch( level.CONTENTS_ACTOR, player.origin, 10000 );
		numAi = allAi.size;
		
		// clamp
		if( numAi < minAi )
		{
			numAi = minAi;
		}
		else if( numAi > maxAi )
		{
			numAi = maxAi;
		}

		maxNodesPerFrame = (numAi - minAi) / (maxAi - minAi);
		maxNodesPerFrame = (1-maxNodesPerFrame) * (nodesMax - nodesMin) + nodesMin;

		// how often to evaluate nodes (spread them out for optimization)
		frameInterval = int( ceil( totalNodes / maxNodesPerFrame ) );
		//println("interval: " + frameInterval + " nodes: " + maxNodesPerFrame + " ai: " + numAi);

		for( i=0; i < totalNodes && i < nodes.size; i++ )
		{
			node = nodes[i];

			// clear the cached data
			if( !IsDefined(node.tool) || node.tool != tool || !IsDefined(node.toolType) || node.toolType != toolType )
			{
				node.angleDeltaArray	= undefined;
				node.moveDeltaArray		= undefined;
				node.preMoveDeltaArray	= undefined;
				node.postMoveDeltaArray	= undefined;
				node.tool				= tool;
				node.toolType			= toolType;
			}

			assert( IsDefined(node) );
			if( !IsDefined(node) || node.type == "BAD NODE" || node.type == "Path" )
			{
				totalNodes++;
				continue;
			}
			else if( node.type == "Begin" )
			{
				print3d( node.origin, node.animscript, (1,0,0), 1, 0.2, frameInterval );
				continue;
			}
			else if( !IsDefined( anim.approach_types[node.type] ) )
			{
				totalNodes++;
				continue;
			}

			// skip node evaluation every few frames (PhysicsTrace is expensive)
			if( IsDefined(node.lastCheckedTime) && (gettime() - node.lastCheckedTime) < 50*frameInterval )
			{
				if( node.lastRatio == 0 )
				{
					numBad++;
				}
				else if( node.lastRatio < 0.5 )
				{
					numPoor++;
				}
				else if( node.lastRatio < 1.0 )
				{
					numOk++;
				}
				else
				{
					numGood++;
				}

				continue;
			}

			// limit the number of traces per frame
			if( evaluatedThisFrame > maxNodesPerFrame ) // 30 nodes
			{
				continue;
			}

			// use the the AI that's on the node if there is one
			testAi = fakeAi;
			nearAiArray = entsearch( level.CONTENTS_ACTOR, node.origin, 16 );

			if( nearAiArray.size > 0 )
			{
				testAi = nearAiArray[0];
			}

			renderNode = true;
			if( DistanceSquared(node.origin, player.origin) > 800*800 ) //|| renderedThisFrame*frameInterval > maxNodesPerFrame )
			{
				renderNode = false;
			}

			nodeColor = nodeColors["Good"];

			// find transition type
			stance = ISNODEDONTSTAND(node) && !ISNODEDONTCROUCH(node);
			transType = anim.approach_types[node.type][stance];

			totalTransitions = 0;
			validTransitions = 0;

			animName = "arrive_" + transType;

			// exit support
			if( tool == 2 )
			{
				animName = "exit_" + transType;
			}

			if( fakeAi shouldDoCQBTransition( node, transType ) )
				animName = animName + "_cqb";

			// cache for performance
			if( !IsDefined(node.angleDeltaArray) )
			{
				node.angleDeltaArray = fakeAi angleDeltaArray( animName, "move" );
			}

			// go through all available transitions
			for( j=1; j <= 9; j++ )
			{
				if( IsDefined(node.angleDeltaArray[j]) )
				{
					totalTransitions++;

					lineColor = (0.5,0,0);

					approachIsGood = false;
					originalEnterPos = undefined;

					// final yaw at node
					approachFinalYaw = node.angles[1] + animscripts\cover_arrival::getNodeStanceYawOffset( transType );

					angle = (0, approachFinalYaw - node.angleDeltaArray[j], 0);

					// exits
					if( tool == 2 )
					{
						angle = (0, approachFinalYaw, 0 );
					}
			
					forwardDir = AnglesToForward( angle );
					rightDir = AnglesToRight( angle );

					// cache for performance
					if( !IsDefined(node.moveDeltaArray) )
					{
						node.moveDeltaArray = fakeAi moveDeltaArray( animName, "move" );
					}

					enterPos = node.origin;

					forward = VectorScale( forwardDir, node.moveDeltaArray[j][0] );
					right   = VectorScale( rightDir, node.moveDeltaArray[j][1] );

					// start position of arrival animation
					if( tool == 1 ) // arrival
					{
						enterPos = node.origin - forward + right;
					}
					else
					{
						enterPos = node.origin + forward - right;
					}

					// check if the AI can move between the node and anim start pos or corner
					if( testAi MayMoveFromPointToPoint(node.origin, enterPos) )
					{
						approachIsGood = true;

						lineColor = (0,0.75,0);
					}

					if( renderNode )
					{
						line( node.origin, enterPos, lineColor, 1, 1, frameInterval );
					}
	
					// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
					// (already did the second part, from corner to node, now doing from start of enter anim to corner)
					if( approachIsGood && j >= 7 && !isSubstr(transType, "exposed") )
					{
						originalEnterPos = enterPos;

						if( tool == 1 ) // arrival
						{
							if( !IsDefined(node.preMoveDeltaArray) )
							{
								node.preMoveDeltaArray = fakeAi preMoveDeltaArray( animName, "move" );
							}

							forward = VectorScale( forwardDir, node.preMoveDeltaArray[j][0] );
							right   = VectorScale( rightDir, node.preMoveDeltaArray[j][1] );

							originalEnterPos = enterPos - forward + right;
						}
						else // exit
						{
							if( !IsDefined(node.postMoveDeltaArray) )
							{
								node.postMoveDeltaArray = fakeAi postMoveDeltaArray( animName, "move" );
							}

							forward = VectorScale( forwardDir, node.postMoveDeltaArray[j][0] );
							right   = VectorScale( rightDir, node.postMoveDeltaArray[j][1] );

							originalEnterPos = enterPos + forward - right;
						}

						// check if the AI can move between the corner and anim start pos
						if( !testAi MayMoveFromPointToPoint(originalEnterPos, enterPos) )
						{
							approachIsGood = false;
							lineColor = (0.5,0,0);
						}

						if( renderNode )
						{
							line( originalEnterPos, enterPos, lineColor, 1, 1, frameInterval );
							print3d( originalEnterPos, j + " (" + Distance2D( originalEnterPos, enterPos ) + ")", lineColor, 1, 0.2, frameInterval );
						}
					}
					else if( renderNode )
					{
						print3d( enterPos, j + " (" + Distance2D( node.origin, enterPos ) + ")", lineColor, 1, 0.2, frameInterval );
					}

					if( approachIsGood )
					{
						validTransitions++;
					}

					tracesThisFrame++;
				}
			}

			// assign categories based on number of valid transitions
			node.lastRatio = validTransitions / totalTransitions;
			if( node.lastRatio == 0 )
			{
				nodeColor = nodeColors["Bad"];
				numBad++;

				badNode = node;
			}
			else if( node.lastRatio < 0.5 )
			{
				nodeColor = nodeColors["Poor"];
				numPoor++;
			}
			else if( node.lastRatio < 1.0 )
			{
				nodeColor = nodeColors["Ok"];
				numOk++;
			}
			else
			{
				numGood++;
			}

			if( renderNode )
			{
				// render box, node type and node forward
				print3d( node.origin, node.type + " (" + transType + ")", nodeColor, 1, 0.35, frameInterval );
				box( node.origin, (-16,-16,0), (16,16,16), node.angles[1], nodeColor, 1, 1, frameInterval );

				nodeForward = anglesToForward( node.angles );
				nodeForward = VectorScale( nodeForward, 8 );
				line( node.origin, node.origin + nodeForward, nodeColor, 1, 1, frameInterval );

				renderedThisFrame++;
			}

			// save last time
			evaluatedThisFrame++;
			node.lastCheckedTime = gettime();
		}

		//println("evaluated: " + evaluatedThisFrame + " traced: " + tracesThisFrame + " rendered: " + renderedThisFrame);

		// render stats
		hudTotal	SetValue( numBad + numPoor + numOk + numGood );
		hudBad		SetValue( numBad );
		hudPoor		SetValue( numPoor );
		hudOk		SetValue( numOk );
		hudGood		SetValue( numGood );

		wait(0.05);
	}
}
#/
