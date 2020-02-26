#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include animscripts\debug;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_utility; 

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree ("generic_human");

main()
{
	self endon("killanimscript");

	[[ self.exception[ "move" ] ]]();
    self trackScriptState( "Move Main", "code" );

	self flamethrower_stop_shoot();
	GetUpIfProneBeforeMoving();
	
	animscripts\utility::initialize("move");

	// try shuffling to the node if possible first.
	wasInCover = self wasPreviouslyInCover() && IsDefined( self.prevNode );

	if( wasInCover && !IS_TRUE( self.shuffleMove )  )
	{
		if( IsDefined(self.node) && canShuffleToNode( self.node ) )
		{
			if( DistanceSquared( self.origin, self.prevNode.origin ) < 16 * 16 && self IsShuffleCoverNode( self.node ) && !AIHasOnlyPistol() )
			{			
				self.shuffleMove = true;
				self.shuffleNode = self.node;
			}
			
		}
	}
	
	if( wasInCover && IS_TRUE( self.shuffleMove ) )
	{
		moveCoverToCover();
		moveCoverToCoverFinish();
	}

	// block pain in transitions for allies
	if( self.team == "allies" )
		self.blockingPain = true;
	
	self animscripts\cover_arrival::startMoveTransition();				// Exit
	self thread animscripts\cover_arrival::setupApproachNode( true );	// Arrival
	
	// unblock pain
	if( self.team == "allies" )
		self.blockingPain = false;
		
	MoveInit();
	MoveMainLoop();
}

MoveInit()
{
	// set tactical walk rate
	if ( ( self.combatMode == "ambush" || self.combatMode == "ambush_nodes_only" || self.combatMode == "exposed_nodes_only" ) && 
		( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) > ( 100*100 ) ) )
		self.tacticalWalkRate = 1.5;
	else
	{
		// pistol/"pistol like SMG" AI walk faster as they have a lighter weapon
		if( self AIHasOnlyPistolOrSMG() )
			self.tacticalWalkRate = 1.2 + RandomFloat( 0.3 );
		else
			self.tacticalWalkRate = 0.9 + RandomFloat( 0.4 );
	}
	
	self.tacticalWalkRate = self.tacticalWalkRate * self.moveplaybackrate;

	self.runNGunRate = 0.8 + RandomFloat( 0.2 );
	self.runNGunRate = self.runNGunRate * self.moveplaybackrate;

	self.arrivalStartDist = undefined;
	
	self.shoot_while_moving_thread = undefined;
	animscripts\run::StopUpdateRunAnimWeights();
}

MoveGlobalsInit()
{
	anim.moveGlobals = SpawnStruct();

	anim.moveGlobals.MAX_DISTANCE_TO_SHOOT_SQ	= 1500 * 1500;	// from 2000 onwards, AI will not try to shoot while moving.
	anim.moveGlobals.MOTION_ANGLE_OFFSET		= 60;			// minimum getMotionAngle for strafing sideways or using F/R animations instead of F
	anim.moveGlobals.AIM_YAW_THRESHOLD			= 45;			// enemy yaw threshold for switching to L/R animations while running
	anim.moveGlobals.TRY_FACE_ENEMY_DISTSQ		= 500*500;		// AI will try to Face Enemy while moving within this much distance from enemy
	anim.moveGlobals.CODE_FACE_ENEMY_DIST       = 500;          // default maxFaceEnemyDistSq distance in code for facing the enemy.
	anim.moveGlobals.RUNBACKWARDS_DISTSQ		= anim.moveGlobals.TRY_FACE_ENEMY_DISTSQ;	// within this distance, its always favorable to run backwards and shoot. AI will avoid turning forward.
	anim.moveGlobals.RUNBACKWARDS_CQB_DISTSQ	= 512*512;		// within this distance, its always favorable to run backwards and shoot. AI will avoid turning forward.
	anim.moveGlobals.MIN_RELOAD_DISTSQ			= 256*256;		// minimum distance away from the goal/enemy to be able to reload while running 
	anim.moveGlobals.relativeDirAnimMap			= array( "f", "f", "l", "r", "b" ); // to correspond to RELATIVE_DIR_* enum in actor.h
	anim.moveGlobals.MAX_RUN_N_GUN_ANGLE		= 145;			// animations are upto 135 but its fine to shoot, looks like AI is trying to suppress
	anim.moveGlobals.MIN_DISTSQ_120				= 75*75;		// minimum distance away from the goal/enemy to be able to shoot using runNGun120
	anim.moveGlobals.serverFPS					= 20;
	anim.moveGlobals.serverSPF					= 0.05;
	
	anim.moveGlobals.SHUFFLE_DOOR_MAX_DISTSQ 	= 90 * 90;		// A good distance where AI does not seem like he is sliding while in door shuffle
	anim.moveGlobals.SHUFFLE_COVER_MIN_DISTSQ 	= 32 * 32;		// too short of a distance to shuffle, anims dont look good.
	
	moveTurnGlobalsInit();											
}


GetUpIfProneBeforeMoving()
{
	if ( self.a.pose == "prone" )
	{
		newPose = self animscripts\utility::choosePose( "stand" );

		if ( newPose != "prone" )
		{
			self AnimMode( "zonly_physics", false );
			rate = 1;

			if ( IsDefined( self.grenade ) )
				rate = 2;

			self animscripts\cover_prone::proneTo( newPose, rate );
			self AnimMode( "none", false );
			self OrientMode( "face default" );
		}
	}
}


//--------------------------------------------------------------------------------
// Main move loop
//--------------------------------------------------------------------------------
MoveMainLoop()
{
	startedAiming	= false;
			
	self animscripts\rush::sideStepInit();
	self thread meleeAttackWhileMoving();
	//self thread lookAtPath();

	for (;;)
	{
		///////
		// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
		//addreactionevent ("movement",loopTime,self);
		///////
		//profilestart("MoveMainLoop 1");
		
		self animscripts\face::SetIdleFaceDelayed( anim.alertface );

		if( !startedAiming && self.a.isAiming && ( self.a.pose == "stand" || self.a.pose == "crouch" ) )
		{
			startAiming();
			startedAiming = true;
		}
		
		//profilestart("MoveMainLoop-shouldturn 1");
		shouldTurn = self animscripts\turn::shouldTurn();
		//profileStop();
		
		//profileStop();
		
		if( shouldTurn )	// Turn while moving
		{
			self animscripts\turn::doTurn();
			startedAiming = false;
		}
		else
		{
			isTacticalWalking = !self ShouldFaceMotion();
					
			if( self.moveMode == "run" || isTacticalWalking || self.a.pose == "prone" )
				self animscripts\run::MoveRun();		// MoveRun
			else
				self animscripts\walk::MoveWalk();		// MoveWalk
	
			animscripts\rush::trySideStep();		  	// Rusher SideStepping
		}

	}
}

//--------------------------------------------------------------------------------
// Shooting while moving functions
//--------------------------------------------------------------------------------
MayShootWhileMoving()
{
	if ( self.weapon == "none" )
		return false;
		
	weapclass = self.weaponclass;
	
	if( weapclass != "rifle" 
		 && weapclass != "smg" 
		 && weapclass != "spread" 
		 && weapclass != "mg" 
		 && weapclass != "grenade" 
		 && weapclass != "pistol" 
	  )
	{
		return false;
	}
	
	if( isValidEnemy( self.enemy ) && DistanceSquared( self.origin, self.enemy.origin ) > anim.moveGlobals.MAX_DISTANCE_TO_SHOOT_SQ )
		return false;
	
	// sniper AI will only shoot while facing enemy
	if( ( self isSniper() || self AIHasOnlyPistol() ) && self ShouldFaceMotion() )
		return false;
	
	if ( IsDefined( self.dontShootWhileMoving ) )
	{
		assert( self.dontShootWhileMoving ); // true or undefined
		return false;
	}

	return true;
}
	
shootWhileMoving()
{
	self endon("killanimscript");
	self endon("stopShooting");
	
	// it's possible for this to be called by CQB while it's already running from run.gsc,
	// even though run.gsc will kill it on the next frame. We can't let it run twice at once.
	self notify("doing_shootWhileMoving");
	self endon("doing_shootWhileMoving");

	/#self animscripts\debug::debugPushState( "shootWhileMoving" );#/
	
	while(1)
	{
		if( !self.bulletsInClip )
		{
			if( ISCQB(self) || self is_rusher() )
				cheatAmmoIfNecessary();
				
			if( !self.bulletsInClip )
			{
				wait 0.5;
				continue;
			}
		}
	
		self shootUntilShootBehaviorChange();
	}

	/#self animscripts\debug::debugPopState();#/
}


//--------------------------------------------------------------------------------
// Melee while moving
//--------------------------------------------------------------------------------
meleeAttackWhileMoving()
{
	self endon( "killanimscript" );

	while ( 1 )
	{
		if( isDefined( self.enemy ) ) 
		{
			if ( abs( self GetMotionAngle() ) <= 135 ) // only when moving forward or sideways
				animscripts\melee::Melee_TryExecuting();
		}

		wait 0.1;
	}
}

//--------------------------------------------------------------------------------
// Aiming while moving
//--------------------------------------------------------------------------------
startAiming()
{
	self.rightAimLimit	= 50;
	self.leftAimLimit	= -50;
	self.upAimLimit		= 50;
	self.downAimLimit	= -50;

	self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 );
	self animscripts\shared::trackLoopStart();
}

//--------------------------------------------------------------------------------
// Looking ahead while moving
// AI_TODO - fully remove or find better opportunities to do this.
// SUMEET - This is expensive to do and not so much visbile and AI always have some enemy or is in 
// scripted animation. Also, not sure if it works without having IK anyways. Turning it off.
//--------------------------------------------------------------------------------
lookAtPath()
{
	self endon("killanimscript");

	// clear the lookat position on killanimscript
	self thread stopLookAtPathOnKillAnimscript();

	while(1)
	{
		if( shouldLookAtPath() )
		{
			lookAtPos = undefined;

			if( IsDefined(self.enemy) && self canSee(self.enemy) ) // don't interfere with aiming
			{
				//lookAtPos = self.enemy.origin;
				lookAtPos = undefined;
			}
			else if( self CanSeePathGoal() ) // only an approximation - check nearest node vs nearest node to goal for performance
			{
				lookAtPos = self.pathgoalpos;
			}
			else if( self.lookaheaddist > 100 )
			{
				lookAtPos = self.origin + VectorScale(self.lookaheaddir, self.lookaheaddist) + (0,0,0);
			}
			else
			{
				// 0 iterations returns current lookahead
				currentLookahead = self CalcLookaheadPos( self.origin, 0 );
				if( IsDefined(currentLookahead) )
				{
					lookAtPos = currentLookahead["node"] + (0,0,0);
				}
			}

			// some debugging
			/#
			if( IsDefined(lookAtPos) && GetDvarint( "ai_debugLookAt" ) )
			{
				recordLine( self.origin, lookAtPos, (1,1,0), "Animscript", self );
				Record3DText( "lookAt", lookAtPos, (1,1,0), "Animscript" );		
			}
			#/

			// passing in undefined turns off ik lookAt
			self LookAtPos( lookAtPos );
		}
		else
		{
			// turn off lookAt
			self LookAtPos();
			wait(1);
		}

		wait(0.05);
	}
}

shouldLookAtPath()
{
	if( GetDvarint( "ai_enableMoveLookAt" ) )
	{
		// check dist too for performance?

		if( !self.faceMotion )
			return false;

		return true;
	}

	return false;
}

stopLookAtPathOnKillAnimscript()
{
	self waittill("killanimscript");

	// clear the lookat pos
	if( IsDefined(self) )
	{
		self LookAtPos();
	}
}

//--------------------------------------------------------------------------------
// Shuffle move
//--------------------------------------------------------------------------------
wasPreviouslyInCover()
{
	switch( self.a.prevScript )
	{
		case "cover_crouch":
		case "cover_left":
		case "cover_prone":
		case "cover_right":
		case "cover_stand":
		case "concealment_crouch":
		case "concealment_prone":
		case "concealment_stand":
		case "cover_wide_left":
		case "cover_wide_right":
		case "cover_pillar":
		case "hide":
		case "turret":
			return true;
	}

	return false;
}

canShuffleToNode(node)
{
	switch( node.type ) 
	{
		case "Cover Left":
		case "Cover Right":
		case "Cover Stand":
		case "Conceal Stand":
		case "Cover Crouch":
		case "Conceal Crouch":
			return true;
	}
	
	return false;
}

isShuffleDirectionValid( startNode, endNode, shuffleLeft )
{
	// if going from cover left -> shuffleLeft || cover right -> !shuffleLeft, dont do it. There is nothing in code that prevents this currently. 
	// Ideally, we would not need it if we start using connect paths connection for shuffle nodes
	
	if( startNode.type == "Cover Left" && shuffleLeft )
		return false;
	
	if( startNode.type == "Cover Right" && !shuffleLeft )
		return false;
	
	// if going to cover left and not shuffleLeft || cover right and not !shuffleLeft/shuffleRight, dont do it. There is nothing in code that prevents this currently. 
	// Ideally, we would not need it if we start using connect paths connection for shuffle nodes
	
	if( endNode.type == "Cover Left" && !shuffleLeft )
		return false;
	
	if( endNode.type == "Cover Right" && shuffleLeft )
		return false;
	
	return true;
}

get_shuffle_to_corner_start_anim( shuffleLeft, startNode )
{
	if ( startNode.type == "Cover Left" )
	{
		assert( !shuffleLeft );
		return animArray("cornerL_shuffle_start");
	}
	else if ( startNode.type == "Cover Right" )
	{
		assert( shuffleLeft );
		return animArray("cornerR_shuffle_start");
	}
	else
	{
		if ( shuffleLeft )
			return animArray("shuffleL_start");
		else
			return animArray("shuffleR_start");
	}
}


moveCoverToCover_getShuffleStartAnim( shuffleLeft, startNode, endNode )
{
	assert( isdefined( startNode ) );
	assert( isdefined( endNode ) );

	shuffleAnim = undefined;

	if ( endNode.type == "Cover Left" )
	{
		assert( shuffleLeft );
		shuffleAnim = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
	}
	else if ( endNode.type == "Cover Right" )
	{
		assert( !shuffleLeft );
		shuffleAnim = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
	}
	else if ( endNode.type == "Cover Stand" && startNode.type == endNode.type )
	{
		if ( shuffleLeft )
			shuffleAnim = animArray("coverStand_shuffleL_start");
		else
			shuffleAnim = animArray("coverStand_shuffleR_start");
	}
	else
	{
		//assert( endNode.type == "Cover Crouch" || endNode.type == "Cover Crouch Window" );
		if ( shuffleLeft )
			shuffleAnim = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
		else
			shuffleAnim = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
	}

	return shuffleAnim;
}

moveCoverToCover_getShuffleLoopAnim( shuffleLeft, startNode, endNode )
{
	assert( isdefined( startNode ) );
	assert( isdefined( endNode ) );

	shuffleAnim = undefined;

	if ( endNode.type == "Cover Left" )
	{
		assert( shuffleLeft );
		shuffleAnim = animArray("shuffleL");
	}
	else if ( endNode.type == "Cover Right" )
	{
		shuffleAnim = animArray("shuffleR");
	}
	else if ( endNode.type == "Cover Stand" && startNode.type == endNode.type )
	{
		if ( shuffleLeft )
			shuffleAnim = animArray("coverStand_shuffleL");
		else
			shuffleAnim = animArray("coverStand_shuffleR");
	}
	else
	{
		//assert( endNode.type == "Cover Crouch" || endNode.type == "Cover Crouch Window" );
		if ( shuffleLeft )
			shuffleAnim = animArray("shuffleL");
		else
			shuffleAnim = animArray("shuffleR");
	}

	return shuffleAnim;
}

moveCoverToCover_getShuffleEndAnim( shuffleLeft, startNode, endNode )
{
	assert( isdefined( startNode ) );
	assert( isdefined( endNode ) );

	shuffleAnim = undefined;

	if ( endNode.type == "Cover Left" )
	{
		assert( shuffleLeft );
		shuffleAnim = animArray("cornerL_shuffle_end");
	}
	else if ( endNode.type == "Cover Right" )
	{
		assert( !shuffleLeft );
		shuffleAnim = animArray("cornerR_shuffle_end");
	}
	else if ( endNode.type == "Cover Stand" && startNode.type == endNode.type )
	{
		if ( shuffleLeft )
			shuffleAnim = animArray("coverStand_shuffleL_end");
		else
			shuffleAnim = animArray("coverStand_shuffleR_end");
	}
	else
	{
		//assert( endNode.type == "Cover Crouch" || endNode.type == "Cover Crouch Window" );
		if ( shuffleLeft )
			shuffleAnim = animArray("shuffleL_end");
		else
			shuffleAnim = animArray("shuffleR_end");
	}

	return shuffleAnim;
}

moveCoverToCover_checkStartPose( startNode, endNode )
{
	if ( self.a.pose == "stand" && ( endNode.type != "Cover Stand" || startNode.type != "Cover Stand" ) )
	{
		self.a.pose = "crouch";
		return false;
	}

	return true;
}

moveCoverToCover_checkEndPose( endNode )
{
	if ( self.a.pose == "crouch" && endNode.type == "Cover Stand" )
	{
		self.a.pose = "stand";
		return false;	
	}

	return true;
}

moveCoverToCover()
{
	self endon( "killanimscript" );
	self endon( "goal_changed" );

	shuffleNode = self.shuffleNode;

	self.shuffleMove = undefined;
	self.shuffleNode = undefined;
	self.shuffleMoveInterrupted = true;

	if ( !IsDefined( self.prevNode ) )
		return;

	if ( !IsDefined( self.node ) || !isdefined( shuffleNode ) || self.node != shuffleNode )
		return;

	startNode = self.prevNode;
	node 	  = self.node;
	
	// can't be shuffling to a cornernode of the same type
	if( ( startNode.type == "Cover Left" || startNode.type == "Cover Right" ) && startNode.type == node.type )
		return;
		
	// if the start node is pillar node, dont shuffle
	if( startNode.type == "Cover Pillar" )
		return;
	
	moveDir = node.origin - self.origin;
	if ( lengthSquared( moveDir ) < 1 )
		return;

	moveDir = vectornormalize( moveDir );
	forward = anglestoforward( node.angles );

	shuffleLeft = ( ( forward[ 0 ] * moveDir[ 1 ] ) - ( forward[ 1 ] * moveDir[ 0 ] ) ) > 0;
	
	if ( moveDoorSideToSide( shuffleLeft, startNode, node ) )
		return;
	
	if( !isShuffleDirectionValid(  startNode, node, shuffleLeft ) )
		return;

	if ( moveCoverToCover_checkStartPose( startNode, node ) )
		blendTime = 0.1;
	else
		blendTime = 0.4;

	self animMode( "zonly_physics", false );

	self clearanim( %body, blendTime );
		
	startAnim	 = moveCoverToCover_getShuffleStartAnim( shuffleLeft, startNode, node );
	shuffleAnim  = moveCoverToCover_getShuffleLoopAnim( shuffleLeft, startNode, node );
	endAnim		 = moveCoverToCover_getShuffleEndAnim( shuffleLeft, startNode, node );

	//assertEx( AnimHasNotetrack( startAnim, "finish" ), "animation doesn't have finish notetrack " + startAnim );
	if ( AnimHasNotetrack( startAnim, "finish" ) )
		startEndTime = getNotetrackTimes( startAnim, "finish" )[ 0 ];
	else
		startEndTime = 1;

	startDist    = length( getMoveDelta( startAnim, 0, startEndTime ) );
	shuffleDist	 = length( getMoveDelta( shuffleAnim, 0, 1 ) );
	endDist		 = length( getMoveDelta( endAnim, 0, 1 ) );

	remainingDist = Distance( self.origin, node.origin );

	if ( remainingDist > startDist )
	{
		self OrientMode( "face angle", getNodeForwardYaw( startNode ) );

		self SetFlaggedAnimRestart( "shuffle_start", startAnim, 1, blendTime );
		self animscripts\shared::DoNoteTracks( "shuffle_start" );
		self ClearAnim( startAnim, 0.2 );
		remainingDist -= startDist;

		blendTime = 0.2; // reset blend for looping move
	}
	else
	{
		self OrientMode( "face angle", node.angles[1] );
	}

	playEnd = false;
	if ( remainingDist > endDist )
	{
		playEnd = true;
		remainingDist -= endDist;
	}

	loopTime = getAnimLength( shuffleAnim );
	playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;
	playTime = floor( playTime * anim.moveGlobals.serverFPS ) * anim.moveGlobals.serverSPF;

	self setflaggedanim( "shuffle", shuffleAnim, 1, blendTime );
	self DoNoteTracksForTime( playTime, "shuffle" );

	// account for loopTime not being exact since loop animation delta isn't uniform over time
	for ( i = 0; i < 2; i++ )
	{
		remainingDist = distance( self.origin, node.origin );
		if ( playEnd )
			remainingDist -= endDist;

		if ( remainingDist < 4 )
			break;

		playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;	// don't overshoot
		playTime = floor( playTime * anim.moveGlobals.serverFPS ) * anim.moveGlobals.serverSPF;

		if ( playTime < 0.05 )
			break;

		self DoNoteTracksForTime( playTime, "shuffle" );
	}

	if ( playEnd )
	{
		if ( moveCoverToCover_checkEndPose( node ) )
			blendTime = 0.2;
		else
			blendTime = 0.4;

		self ClearAnim( shuffleAnim, blendTime );
		self SetFlaggedAnim( "shuffle_end", endAnim, 1, blendTime );
		self animscripts\shared::DoNoteTracks( "shuffle_end" );

		// clear animation in moveCoverToCoverFinish if needed
	}

	self Teleport( node.origin );
	self animMode( "normal" );

	self.shuffleMoveInterrupted = undefined;
}

moveCoverToCoverFinish()
{
	if ( isdefined( self.shuffleMoveInterrupted ) )
	{
		self ClearAnim( %cover_shuffle, 0.2 );

		self.shuffleMoveInterrupted = undefined;
		self AnimMode( "none", false );
		self OrientMode( "face default" );
	}
	else
	{
		wait 0.2;	// don't clear animation, wait for cover script to take over

		self ClearAnim( %cover_shuffle, 0.2 );
	}
}

moveDoorSideToSide( shuffleLeft, startNode, endNode )
{	
	sideToSideAnim = undefined;

	if( startNode.type == "Cover Right" && endNode.type == "Cover Left" && !shuffleLeft )
		sideToSideAnim = animArray("corner_door_R2L");
	else if( startNode.type == "Cover Left" && endNode.type == "Cover Right" && shuffleLeft )
		sideToSideAnim = animArray("corner_door_L2R");

	if( !IsDefined( sideToSideAnim ) )
		return false;
	
	if( Distance2DSquared( startNode.origin, endNode.origin ) > anim.moveGlobals.SHUFFLE_DOOR_MAX_DISTSQ )
		return false;
	
	self animMode( "zonly_physics", false );
	self orientmode( "face current" );

	self setflaggedanimrestart( "sideToSide", sideToSideAnim, 1, 0.2 );

	assert( animHasNoteTrack( sideToSideAnim, "slide_start" ) );
	assert( animHasNoteTrack( sideToSideAnim, "slide_end" ) );

	self animscripts\shared::DoNoteTracks( "sideToSide", ::handleSideToSideNotetracks );

	slideStartTime = self getAnimTime( sideToSideAnim );
	slideDir = endNode.origin - startNode.origin;
	slideDir = vectornormalize( ( slideDir[0], slideDir[1], 0 ) );

	animDelta = getMoveDelta( sideToSideAnim, slideStartTime, 1 );
	remainingVec = endNode.origin - self.origin;
	remainingVec = ( remainingVec[0], remainingVec[1], 0 );
	slideDist = vectordot( remainingVec, slideDir ) - abs( animDelta[1] );

	if ( slideDist > 2 )
	{
		slideEndTime = getNoteTrackTimes( sideToSideAnim, "slide_end" )[0];
		slideTime = ( slideEndTime - slideStartTime ) * getAnimLength( sideToSideAnim );
		assert( slideTime > 0 );

		slideFrames = int( ceil( slideTime / 0.05 ) );
		slideIncrement = slideDir * slideDist / slideFrames;
		self thread slideForTime( slideIncrement, slideFrames );
	}

	self animscripts\shared::DoNoteTracks( "sideToSide" );

	self Teleport( endNode.origin );
	self animMode( "none" );
	self orientmode( "face default" );

	self.shuffleMoveInterrupted = undefined;
	wait 0.2;	

	return true;
}

handleSideToSideNotetracks( note )
{
	if ( note == "slide_start" )
		return true;
}

slideForTime( slideIncrement, slideFrames )
{
	self endon( "killanimscript" );
	self endon( "goal_changed" );

	while ( slideFrames > 0 )
	{
		self Teleport( self.origin + slideIncrement );
		slideFrames--;
		wait 0.05;
	}
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------
end_script()
{
	self.a.isTurning = false;
	self.blockingPain = false;
	run_end_script();
}