#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_robot_interface;
#using scripts\shared\ai\archetype_utility;

#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\ai_squads;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;

#using scripts\shared\vehicles\_raps;

                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                  	                             	  	                                      
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                                                                                                                                                       	     	                                                                                   

function autoexec main()
{
	// INIT BLACKBOARD
	spawner::add_archetype_spawn_function( "robot", &RobotSoldierBehavior::ArchetypeRobotBlackboardInit );
	
	// INIT ROBOT ON SPAWN
	spawner::add_archetype_spawn_function( "robot", &RobotSoldierServerUtils::robotSoldierSpawnSetup );
	
	clientfield::register(
		"actor",
		"robot_mind_control",
		1,
		2,
		"int" );
	
	clientfield::register(
		"actor",
		"robot_mind_control_explosion",
		1,
		1,
		"int" );
		
	clientfield::register(
		"actor",
		"robot_lights",
		1,
		3,
		"int" );
		
	clientfield::register(
		"actor",
		"robot_EMP",
		1,
		1,
		"int" );
	
	RobotInterface::RegisterRobotInterfaceAttributes();
	RobotSoldierBehavior::RegisterBehaviorScriptFunctions();
}

#namespace RobotSoldierBehavior;

function RegisterBehaviorScriptFunctions()
{
	// ------- ROBOT ACTIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotStepIntoAction",&stepIntoInitialize,undefined,&stepIntoTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotStepOutAction",&stepOutInitialize,undefined,&stepOutTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotTakeOverAction",&takeOverInitialize,undefined,&takeOverTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotEmpIdleAction",&robotEmpIdleInitialize,&robotEmpIdleUpdate,&robotEmpIdleTerminate);;

	// ------- ROBOT ACTION APIS ----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotBecomeCrawler",&robotBecomeCrawler);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDropStartingWeapon",&robotDropStartingWeapon);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDontTakeCover",&robotDontTakeCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverOverInitialize",&robotCoverOverInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverOverTerminate",&robotCoverOverTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotExplode",&robotExplode);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotExplodeTerminate",&robotExplodeTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDeployMiniRaps",&robotDeployMiniRaps);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotMoveToPlayer",&moveToPlayerUpdate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotStartSprint",&robotStartSprint);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotStartSuperSprint",&robotStartSuperSprint);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTacticalWalkActionStart",&robotTacticalWalkActionStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDie",&robotDie);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCleanupChargeMeleeAttack",&robotCleanupChargeMeleeAttack);;
	
	// ------- ROBOT CONDITIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsMoving",&robotIsMoving);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotAbleToShoot",&robotAbleToShootCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCrawlerCanShootEnemy",&robotCrawlerCanShootEnemy);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canMoveToEnemy",&canMoveToEnemyCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canMoveCloseToEnemy",&canMoveCloseToEnemyCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasMiniRaps",&hasMiniRaps);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsAtCover",&robotIsAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldTacticalWalk",&robotShouldTacticalWalk);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotHasCloseEnemyToMelee",&robotHasCloseEnemyToMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotHasEnemyToMelee",&robotHasEnemyToMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRogueHasCloseEnemyToMelee",&robotRogueHasCloseEnemyToMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRogueHasEnemyToMelee",&robotRogueHasEnemyToMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsCrawler",&robotIsCrawler);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsMarching",&robotIsMarching);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotPrepareForAdjustToCover",&robotPrepareForAdjustToCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldAdjustToCover",&robotShouldAdjustToCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldBecomeCrawler",&robotShouldBecomeCrawler);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldReactAtCover",&robotShouldReactAtCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldExplode",&robotShouldExplode);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldShutdown",&robotShouldShutdown);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotSupportsOverCover",&robotSupportsOverCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStepIn",&shouldStepInCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldTakeOver",&shouldTakeOverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsStepOut",&supportsStepOutCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setDesiredStanceToStand",&setDesiredStanceToStand);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setDesiredStanceToCrouch",&setDesiredStanceToCrouch);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("toggleDesiredStance",&toggleDesiredStance);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotMovement",&robotMovement);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotDelayMovement",&robotDelayMovement);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotInvalidateCover",&robotInvalidateCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldChargeMelee",&robotShouldChargeMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldMelee",&robotShouldMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotScriptRequiresToSprint",&scriptRequiresToSprintCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotScanExposedPainTerminate",&robotScanExposedPainTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTookEmpDamage",&robotTookEmpDamage);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWithinSprintRange",&robotWithinSprintRange);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWithinSuperSprintRange",&robotWithinSuperSprintRange);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotOutsideTacticalWalkRange",&robotOutsideTacticalWalkRange);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotOutsideSprintRange",&robotOutsideSprintRange);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotLightsOff",&robotLightsOff);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotLightsFlicker",&robotLightsFlicker);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotLightsOn",&robotLightsOn);;
	
	// ------- ROBOT - PROCEDURAL TRAVERSE BEHAVIOR -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("robotProceduralTraversal",&robotTraverseStart,&robotProceduralTraversalUpdate,&robotTraverseRagdollOnDeath);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotProceduralLanding",&robotProceduralLandingUpdate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTraverseEnd",&robotTraverseEnd);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTraverseRagdollOnDeath",&robotTraverseRagdollOnDeath);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldProceduralTraverse",&robotShouldProceduralTraverse);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWallrunTraverse",&robotWallrunTraverse);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotShouldWallrun",&robotShouldWallrun);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotSetupWallRunJump",&robotSetupWallRunJump);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotSetupWallRunLand",&robotSetupWallRunLand);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWallrunStart",&robotWallrunStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotWallrunEnd",&robotWallrunEnd);;
	
	// ------- ROBOT - JUKE BEHAVIOR -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCanJuke",&robotCanJuke);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCanTacticalJuke",&robotCanTacticalJuke);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCanPreemptiveJuke",&robotCanPreemptiveJuke);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotJukeInitialize",&robotJukeInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotPreemptiveJukeTerminate",&robotPreemptiveJukeTerminate);;
	
	// ------- ROBOT - COVER SCAN BEHAVIOR -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverScanInitialize",&robotCoverScanInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCoverScanTerminate",&robotCoverScanTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotIsAtCoverModeScan",&robotIsAtCoverModeScan);;
	
	// ------- ROBOT SERVICES -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotExposedCoverService",&robotExposedCoverService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotPositionService",&robotPositionService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTargetService",&robotTargetService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotTryReacquireService",&robotTryReacquireService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRushEnemyService",&robotRushEnemyService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotRushNeighborService",&robotRushNeighborService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotCrawlerService",&robotCrawlerService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("robotMoveToPlayerService",&moveToPlayerUpdate);;
	
	// ------- ROBOT MOCOMPS -----------//
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_ignore_pain_face_enemy",&mocompIgnorePainFaceEnemyInit,&mocompIgnorePainFaceEnemyUpdate,&mocompIgnorePainFaceEnemyTerminate);;
	AnimationStateNetwork::RegisterAnimationMocomp("robot_adjust_to_cover",&mocompRobotAdjustToCoverInit,&mocompRobotAdjustToCoverUpdate,&mocompRobotAdjustToCoverTerminate);;
	AnimationStateNetwork::RegisterAnimationMocomp("robot_procedural_traversal",&mocompRobotProceduralTraversalInit,&mocompRobotProceduralTraversalUpdate,&mocompRobotProceduralTraversalTerminate);;
	AnimationStateNetwork::RegisterAnimationMocomp("robot_start_traversal",&mocompRobotStartTraversalInit,undefined,&mocompRobotStartTraversalTerminate);;
	AnimationStateNetwork::RegisterAnimationMocomp("robot_start_wallrun",&mocompRobotStartWallrunInit,&mocompRobotStartWallrunUpdate,&mocompRobotStartWallrunTerminate);;
}

function robotCleanupChargeMeleeAttack( behaviorTreeEntity )
{
	AiUtility::meleeReleaseMutex( behaviorTreeEntity );
	AiUtility::releaseClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_melee_enemy_type", undefined);
}

function private robotLightsOff( entity, asmStateName )
{
	entity ai::set_behavior_attribute( "robot_lights", 2 );
	
	clientfield::set( "robot_EMP", 1 );

	return 4;
}

function private robotLightsFlicker( entity, asmStateName )
{
	entity ai::set_behavior_attribute( "robot_lights", 1 );

	clientfield::set( "robot_EMP", 1 );

	return 4;
}

function private robotLightsOn( entity, asmStateName )
{
	entity ai::set_behavior_attribute( "robot_lights", 0 );
	
	clientfield::set( "robot_EMP", 0 );

	return 4;
}

function private robotEmpIdleInitialize( entity, asmStateName )
{
	entity.empStopTime = GetTime() + entity.empShutdownTime;
	
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );
	
	entity notify( "emp_shutdown_start" );
	
	return 5;
}

function private robotEmpIdleUpdate( entity, asmStateName )
{
	if ( GetTime() < entity.empStopTime || entity ai::get_behavior_attribute( "shutdown" ) )
	{
		if ( entity ASMGetStatus() == "asm_status_complete" )
		{
			// Loop the idle animation until enough time has passed.
			AnimationStateNetworkUtility::RequestState( entity, asmStateName );
		}
	
		return 5;
	}
	
	return 4;
}

function private robotEmpIdleTerminate( entity, asmStateName )
{
	entity notify( "emp_shutdown_end" );

	return 4;
}

function private robotProceduralTraversalUpdate( entity, asmStateName )
{
	assert( IsDefined( entity.traversal ) );

	traversal = entity.traversal;

	t = min( ( GetTime() - traversal.startTime ) / traversal.totalTime, 1 );
	curveRemaining = traversal.curveLength * ( 1 - t );

	if ( curveRemaining < traversal.landingDistance )
	{
		traversal.landing = true;
		return 4;
	}

	return 5;
}

function private robotProceduralLandingUpdate( entity, asmStateName )
{
	if ( IsDefined( entity.traversal ) )
	{
		entity Finishtraversal();
	}

	return 5;
}

function private robotTraverseStart( entity, asmStateName )
{
	entity.skipdeath = true;
	entity.traversal = SpawnStruct();
	
	traversal = entity.traversal;
	
	// Static data
	traversal.landingDistance = 24;  // Inches
	traversal.minimumSpeed = 18;  // Feet
	
	traversal.startNode = entity.traverseStartNode;
	traversal.endNode = entity.traverseEndNode;
	
	startIsWallrun = traversal.startNode.spawnflags & 2048;
	endIsWallrun = traversal.endNode.spawnflags & 2048;
	
	// Bezier start and end points
	traversal.startPoint1 = entity.origin;
	traversal.endPoint1 = traversal.endNode.origin;
	
	if ( endIsWallrun )
	{
		// Find the offset point from the wall to jump to, this prevents the AI from clipping during landings.
		faceNormal = GetNavMeshFaceNormal( traversal.endPoint1, 30 );
		traversal.endPoint1 += faceNormal * 30 / 2;
	}
	
	if ( !IsDefined( traversal.endPoint1 ) )
	{
		// This indicates the end node is way off the navmesh.
		traversal.endPoint1 = traversal.endNode.origin;
	}
	
	traversal.distanceToEnd = Distance( traversal.startPoint1, traversal.endPoint1 );
	traversal.absHeightToEnd = Abs( traversal.startPoint1[2] - traversal.endPoint1[2] );
	traversal.absLengthToEnd = Distance2D( traversal.startPoint1, traversal.endPoint1 );
	
	// Calculate approximate speed.  Longer traversals require faster movement.
	speedBoost = 0;
	
	if ( traversal.absLengthToEnd > 200 )
	{
		speedBoost = 16;
	}
	else if ( traversal.absLengthToEnd > 120 )
	{
		speedBoost = 8;
	}
	else if ( traversal.absLengthToEnd > 80 || traversal.absHeightToEnd > 80 )
	{
		speedBoost = 4;
	}
	
	traversal.speedOnCurve = ( traversal.minimumSpeed + speedBoost ) * 12;  // Inches per second
	// End of speed calculations
	
	// Bezier control points
	heightOffset = max( traversal.absHeightToEnd * 0.8, min( traversal.absLengthToEnd, 96 ) );
	
	traversal.startPoint2 = entity.origin + ( 0, 0, heightOffset );
	traversal.endPoint2 = traversal.endPoint1 + ( 0, 0, heightOffset );
	
	// Adjust the lower control point to make a symmetric curve.
	if ( traversal.startPoint1[2] < traversal.endPoint1[2] )
	{
		traversal.startPoint2 += ( 0, 0, traversal.absHeightToEnd );
	}
	else
	{
		traversal.endPoint2 += ( 0, 0, traversal.absHeightToEnd );
	}
	
	// Wallrun traversals may jump directly off or onto the wall, adjust bezier control points.
	if ( startIsWallrun || endIsWallrun )
	{
		startDirection = robotStartJumpDirection();
		endDirection = robotEndJumpDirection();
		
		if ( startDirection == "out" )
		{
			point2Scale = 0.5;
			towardEnd = ( traversal.endNode.origin - entity.origin ) * point2Scale;
		
			traversal.startPoint2 = entity.origin + ( towardEnd[0], towardEnd[1], 0 );
			traversal.endPoint2 = traversal.endPoint1 + ( 0, 0, traversal.absHeightToEnd * point2Scale );
			
			traversal.angles = entity.angles;
		}
		
		if ( endDirection == "in" )
		{
			point2Scale = 0.5;
			towardStart = ( entity.origin - traversal.endNode.origin ) * point2Scale;
		
			traversal.startPoint2 = entity.origin + ( 0, 0, traversal.absHeightToEnd * point2Scale );
			traversal.endPoint2 = traversal.endNode.origin + ( towardStart[0], towardStart[1], 0 );
			
			faceNormal = GetNavMeshFaceNormal( traversal.endNode.origin, 30 );
			direction = _CalculateWallrunDirection( traversal.startNode.origin, traversal.endNode.origin );
			moveDirection = VectorCross( faceNormal, ( 0, 0, 1 ) );
			
			if ( direction == "right" )
			{
				moveDirection = -moveDirection;
			}
			
			traversal.angles = VectortoAngles( moveDirection );
		}
		
				// These are animation specific, and speed specific.
		if ( endIsWallrun )
		{
			traversal.landingDistance = 110;
		}
		else
		{
			traversal.landingDistance = 60;
		}
		
		// Wallruns require faster movement.
		traversal.speedOnCurve *= 1.2;
	}
	
	/#
	// Draw Bezier control point extents.
	RecordLine( traversal.startPoint1, traversal.startPoint2, ( 1, .5, 0 ), "Animscript", entity );
	RecordLine( traversal.startPoint1, traversal.endPoint1, ( 1, .5, 0 ), "Animscript", entity );
	RecordLine( traversal.endPoint1, traversal.endPoint2, ( 1, .5, 0 ), "Animscript", entity );
	RecordLine( traversal.startPoint2, traversal.endPoint2, ( 1, .5, 0 ), "Animscript", entity );
	
	Record3DText( traversal.absLengthToEnd, traversal.endPoint1 + (0, 0, 12), ( 1, .5, 0 ), "Animscript", entity );
	#/
	
	// Calculate an approximate length of the curve.
	segments = 10;
	previousPoint = traversal.startPoint1;
	traversal.curveLength = 0;
	
	for ( index = 1; index <= segments; index++ )
	{
		t = index / segments;
		
		nextPoint = CalculateCubicBezier( t, traversal.startPoint1, traversal.startPoint2, traversal.endPoint2, traversal.endPoint1 );
		
		/#
		recordLine( previousPoint, nextPoint, ( 0, 1, 0 ), "Animscript", entity );
		#/
		
		traversal.curveLength += Distance( previousPoint, nextPoint );
		
		previousPoint = nextPoint;
	}
	
	// Traversal time based on speed.
	traversal.startTime = GetTime();
	traversal.endTime = traversal.startTime + traversal.curveLength * ( 1000 / traversal.speedOnCurve );
	traversal.totalTime = traversal.endTime - traversal.startTime;
	
	traversal.landing = false;
	
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );
	
	return 5;
}

function private robotTraverseEnd( entity )
{
	robotTraverseRagdollOnDeath( entity );

	entity.skipdeath = false;
	entity.traversal = undefined;
	
	return 4;
}

function private robotTraverseRagdollOnDeath( entity, asmStateName )
{
	if ( !IsAlive( entity ) )
	{
		entity StartRagdoll();
	}
	
	return 4;
}

function private robotShouldProceduralTraverse( entity )
{
	return entity ai::get_behavior_attribute( "traversals" ) == "procedural" &&
		IsDefined( entity.traverseStartNode ) && IsDefined( entity.traverseEndNode );
}

function private robotWallrunTraverse( entity )
{
	startNode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	
	if ( IsDefined( startNode ) &&
		IsDefineD( endNode ) &&
		entity ShouldStartTraversal() )
	{
		startIsWallrun = startNode.spawnflags & 2048;
		endIsWallrun = endNode.spawnflags & 2048;
	
		return startIsWallrun || endIsWallrun;
	}

	return false;
}

function private robotShouldWallrun( entity )
{
	return Blackboard::GetBlackBoardAttribute( entity, "_robot_traversal_type" ) == "wall";
}

function private mocompRobotStartWallrunInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity SetRepairPaths( false );
	entity OrientMode( "face angle", entity.angles[1] );
	entity.blockingPain = true;
	
	// entity OrientMode( "face motion" );
	entity AnimMode( "normal_nogravity", false );
	entity SetAvoidanceMask( "avoid none" );
}

function private mocompRobotStartWallrunUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	faceNormal = GetNavMeshFaceNormal( entity.origin, 30 );
	positionOnWall = GetClosestPointOnNavMesh( entity.origin, 30, 0 );
	direction = Blackboard::GetBlackBoardAttribute( entity, "_robot_wallrun_direction" );
	
	if ( IsDefined( faceNormal ) && IsDefined( positionOnWall ) )
	{
		moveDirection = VectorCross( faceNormal, ( 0, 0, 1 ) );
		
		if ( direction == "right" )
		{
			moveDirection = -moveDirection;
		}
		
		forwardPositionOnWall = GetClosestPointOnNavMesh( positionOnWall + moveDirection * 12, 30, 0 );
		
		anglesToEnd = VectortoAngles( forwardPositionOnWall - positionOnWall );
		
		/# recordLine( positionOnWall, forwardPositionOnWall, ( 1, 0, 0 ), "Animscript", entity ); #/
		
		entity OrientMode( "face angle", anglesToEnd[1] );
	}
}

function private mocompRobotStartWallrunTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity SetRepairPaths( true );
	entity SetAvoidanceMask( "avoid all" );
	entity.blockingPain = false;
}

function private CalculateCubicBezier( t, p1, p2, p3, p4 )
{
	return pow( 1 - t, 3 ) * p1 +
		3 * pow( 1 - t, 2 ) * t * p2 +
		3 * ( 1 - t ) * pow( t, 2 ) * p3 +
		pow( t, 3 ) * p4;
}

function private mocompRobotStartTraversalInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	startNode = entity.traverseStartNode;
	startIsWallrun = startNode.spawnflags & 2048;
	endNode = entity.traverseEndNode;
	endIsWallrun = endNode.spawnflags & 2048;
	
	if ( !endIsWallrun )
	{
		angleToEnd = VectortoAngles( entity.traverseEndNode.origin - entity.traverseStartNode.origin );
		entity OrientMode( "face angle", angleToEnd[1] );
		
		if ( startIsWallrun )
		{
			entity AnimMode( "normal_nogravity", false );
		}
		else
		{
			entity AnimMode( "gravity", false );
		}
	}
	else
	{
		// Orient toward the direction of the movement along the wall.
		faceNormal = GetNavMeshFaceNormal( endNode.origin, 30 );
		direction = _CalculateWallrunDirection( startNode.origin, endNode.origin );
		moveDirection = VectorCross( faceNormal, ( 0, 0, 1 ) );
		
		if ( direction == "right" )
		{
			moveDirection = -moveDirection;
		}
		
		/# recordLine( endNode.origin, endNode.origin + faceNormal * 20, ( 1, 0, 0 ),  "Animscript", entity ); #/
		/# recordLine( endNode.origin, endNode.origin + moveDirection * 20, ( 1, 0, 0 ), "Animscript", entity ); #/
		
		angles = VectortoAngles( moveDirection );
		entity OrientMode( "face angle", angles[1] );
		
		if ( startIsWallrun )
		{
			entity AnimMode( "normal_nogravity", false );
		}
		else
		{
			entity AnimMode( "gravity", false );
		}
	}
	
	entity SetRepairPaths( false );
	entity.blockingPain = true;
	
	entity PathMode( "dont move" );
}

function private mocompRobotStartTraversalTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity SetRepairPaths( true );
	entity.blockingPain = false;
}

function private mocompRobotProceduralTraversalInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	traversal = entity.traversal;

	entity SetAvoidanceMask( "avoid none" );
	entity OrientMode( "face angle", entity.angles[1] );
	entity SetRepairPaths( false );
	
	// Initial jump can noclip.
	entity AnimMode( "noclip", false );
	entity.blockingPain = true;
	
	if ( IsDefined( traversal ) && traversal.landing )
	{
		// Traversal is still going on, and we're landing.
		entity AnimMode( "angle deltas", false );
	}
}

function private mocompRobotProceduralTraversalUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	traversal = entity.traversal;
	
	if ( IsDefined( traversal ) )
	{
		endIsWallrun = traversal.endNode.spawnflags & 2048;
		realT = ( GetTime() - traversal.startTime ) / traversal.totalTime;
		t = min( realT, 1 );
		
		if ( t < 1.0 || realT == 1.0 || !endIsWallrun )
		{
			currentPos = CalculateCubicBezier( t, traversal.startPoint1, traversal.startPoint2, traversal.endPoint2, traversal.endPoint1 );
			
			angles = entity.angles;
			
			if ( IsDefined( traversal.angles ) )
			{
				angles = traversal.angles;
			}
			
			// TODO(David Young 3-5-15): Convert to anim mode eventually.
			entity ForceTeleport( currentPos, angles, false );
		}
		else
		{
			entity AnimMode( "normal_nogravity", false );
		}
	}
}

function private mocompRobotProceduralTraversalTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	traversal = entity.traversal;
	
	if ( IsDefined( traversal ) && GetTime() >= traversal.endTime )
	{
		// entity ForceTeleport( traversal.endPoint1, entity.angles, false );
		
		endIsWallrun = traversal.endNode.spawnflags & 2048;
		
		if ( !endIsWallrun )
		{
			// Landed on the ground, allow repathing.
			entity PathMode( "move allowed" );
		}
	}
	
	entity.blockingPain = false;
	entity SetRepairPaths( true );
	entity SetAvoidanceMask( "avoid all" );
}



function private mocompRobotAdjustToCoverInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity OrientMode( "face angle", entity.angles[1] );
	entity AnimMode( "angle deltas", false );
	entity.blockingPain = true;
	
	if ( IsDefined( entity.node ) )
	{
		entity.nodeOffsetOrigin = entity GetNodeOffsetPosition( entity.node );
		entity.nodeOffsetAngles = entity GetNodeOffsetAngles( entity.node );
		entity.nodeOffsetForward = AnglesToForward( entity.nodeOffsetAngles );
		entity.nodeForward = AnglesToForward( entity GetNodeOffsetAngles( entity.node ) );
		
		angleDifference = AbsAngleClamp180(
		AbsAngleClamp360( entity.nodeOffsetAngles[1] ) - AbsAngleClamp360( entity.angles[1] ) );
		
		if ( angleDifference < 90 )
		{
			// Since the front quadrant covers the forward 180 degrees, treat this as a special case.
			if ( angleDifference > 45 )
				entity.mocompAngleStartTime = 0.2;
			else
				entity.mocompAngleStartTime = 0.4;
		}
		else
		{
			// Move the angle difference into quadrant space (0, 90)
			angleDifference -= 90;
			
			// If the angleDifference is 45, this is the worst case, 90 is the best case.
			normalAnglePercent = abs( angleDifference - 45 ) / 45;
			
			// Start blending sooner, in the worst case.
			entity.mocompAngleStartTime = max( normalAnglePercent - 0.2, 0.4 );
		}
	}
}

function private mocompRobotAdjustToCoverUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	if( !IsDefined( entity.node ) )
	{
		return;
	}
		
	moveVector = entity.nodeOffsetOrigin - entity.origin;
		
	if ( LengthSquared( moveVector ) > ( 1.5 * 1.5 ) )
	{
		// Scale the moveVector by the max move distance.
		moveVector = VectorNormalize( moveVector ) * 1.5;
	}
	
	entity ForceTeleport( entity.origin + moveVector, entity.angles, false );
	
	normalizedTime = entity GetAnimTime( mocompAnim ) + mocompAnimBlendOutTime / mocompDuration;

	if ( normalizedTime > entity.mocompAngleStartTime )
	{
		entity OrientMode( "face angle", entity GetNodeOffsetAngles( entity.node ) );
		entity AnimMode( "normal", false );
	}
	
	/#
	if ( GetDvarInt( "ai_debugAdjustMocomp" ) )
	{
		record3DText( entity.mocompAngleStartTime, entity.origin + (0, 0, 5), ( 0, 1, 0 ), "Animscript" );
		
		hipTagOrigin = entity GetTagOrigin( "j_mainroot" );
		
		recordLine( entity.nodeOffsetOrigin, entity.nodeOffsetOrigin + entity.nodeOffsetForward * 30, ( 1, .5, 0 ), "Animscript", entity );
		recordLine( entity.node.origin, entity.node.origin + entity.nodeForward * 20, ( 0, 1, 0 ), "Animscript", entity );
		recordLine( entity.origin, entity.origin + AnglesToForward( entity.angles ) * 10, ( 1, 0, 0 ), "Animscript", entity );
		
		recordLine( hipTagOrigin, ( hipTagOrigin[0], hipTagOrigin[1], entity.origin[2] ), ( 0, 0, 1 ), "Animscript", entity );
	}
	#/
}

function private mocompRobotAdjustToCoverTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.blockingPain = false;
	entity.mocompAngleStartTime = undefined;
	entity.nodeOffsetAngle = undefined;
	entity.nodeOffsetForward = undefined;
	entity.nodeForward = undefined;
	
	if( !IsDefined( entity.node ) )
	{
		entity.nodeOffsetOrigin = undefined;
		return;
	}

	entity ForceTeleport( entity.nodeOffsetOrigin, entity GetNodeOffsetAngles( entity.node ), false );
	entity.nodeOffsetOrigin = undefined;
}

function private mocompIgnorePainFaceEnemyInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.blockingpain = true;
	
	if ( IsDefined( entity.enemy ) )
	{
		entity OrientMode( "face enemy" );
	}
	else
	{
		entity OrientMode( "face angle", entity.angles[1] );
	}
	
	entity AnimMode( "pos deltas" );
}

function private mocompIgnorePainFaceEnemyUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	if ( IsDefined( entity.enemy ) && entity GetAnimTime( mocompAnim ) < 0.5 )
	{
		entity OrientMode( "face enemy" );
	}
	else
	{
		entity OrientMode( "face angle", entity.angles[1] );
	}
}

function private mocompIgnorePainFaceEnemyTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.blockingpain = false;
}

function private _CalculateWallrunDirection( startPosition, endPosition )
{
	entity = self;

	faceNormal = GetNavMeshFaceNormal( endPosition, 30 );

	/# recordLine( startPosition, endPosition, ( 1, .5, 0 ), "Animscript", entity ); #/

	if ( IsDefined( faceNormal ) )
	{
		/# recordLine( endPosition, endPosition + faceNormal * 12, ( 1, .5, 0 ), "Animscript", entity ); #/
	
		angles = VectorToAngles( faceNormal );
		right = AnglesToRight( angles );
		
		d = -VectorDot( right, endPosition );
		
		if ( VectorDot( right, startPosition ) + d > 0 )
		{
			return "right";
		}
		
		return "left";
	}
	
	return "unknown";
}

function private robotWallrunStart()
{
	entity = self;
	entity.skipdeath = true;
}

function private robotWallrunEnd()
{
	entity = self;

	robotTraverseRagdollOnDeath( entity );
	
	entity.skipdeath = false;
}

function private robotSetupWallRunJump()
{
	entity = self;
	startNode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	
	direction = "unknown";
	jumpDirection = "unknown";
	traversalType = "unknown";
	
	if ( IsDefined( startNode ) && IsDefined( endNode ) )
	{
		startIsWallrun = startNode.spawnflags & 2048;
		endIsWallrun = endNode.spawnflags & 2048;
	
		if ( endIsWallrun )
		{
			direction = _CalculateWallrunDirection( startNode.origin, endNode.origin );
		}
		else
		{
			direction = _CalculateWallrunDirection( endNode.origin, startNode.origin );
			
			if ( direction == "right" )
			{
				direction = "left";
			}
			else
			{
				direction = "right";
			}
		}
		jumpDirection = robotStartJumpDirection();
		traversalType = robotTraversalType( startNode );
	}
	
	Blackboard::SetBlackBoardAttribute( entity, "_robot_jump_direction", jumpDirection );
	Blackboard::SetBlackBoardAttribute( entity, "_robot_wallrun_direction", direction );
	Blackboard::SetBlackBoardAttribute( entity, "_robot_traversal_type", traversalType );
	
	return 5;
}

function private robotSetupWallRunLand()
{
	entity = self;
	startNode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;
	
	landDirection = "unknown";
	traversalType = "unknown";
	
	if ( IsDefined( startNode ) && IsDefined( endNode ) )
	{
		landDirection = robotEndJumpDirection( );
		traversalType = robotTraversalType( endNode );
	}
	
	Blackboard::SetBlackBoardAttribute( entity, "_robot_jump_direction", landDirection );
	Blackboard::SetBlackBoardAttribute( entity, "_robot_traversal_type", traversalType );
	
	return 5;
}

function private robotStartJumpDirection()
{
	entity = self;
	startNode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;

	if ( IsDefined( startNode ) && IsDefined( endNode ) )
	{
		startIsWallrun = startNode.spawnflags & 2048;
		endIsWallrun = endNode.spawnflags & 2048;
		
		if ( startIsWallrun )
		{
			absLengthToEnd = Distance2D( startNode.origin, endNode.origin );
		
			if ( startNode.origin[2] - endNode.origin[2] > 48 &&
				absLengthToEnd < 250 )
			{
				// End position is below the start position, jump outwards.
				return "out";
			}
		}
		
		return "up";
	}
	
	return "unknown";
}

function private robotEndJumpDirection()
{
	entity = self;
	startNode = entity.traverseStartNode;
	endNode = entity.traverseEndNode;

	if ( IsDefined( startNode ) && IsDefined( endNode ) )
	{
		startIsWallrun = startNode.spawnflags & 2048;
		endIsWallrun = endNode.spawnflags & 2048;
		
		if ( endIsWallrun )
		{
			absLengthToEnd = Distance2D( startNode.origin, endNode.origin );
		
			if ( endNode.origin[2] - startNode.origin[2] > 48 &&
				absLengthToEnd < 250 )
			{
				// start position is below the end position, jump outwards.
				return "in";
			}
		}
		
		return "down";
	}
	
	return "unknown";
}

function private robotTraversalType( node )
{
	if ( IsDefined( node ) )
	{
		if ( node.spawnflags & 2048 )
		{
			return "wall";
		}
		
		return "ground";
	}

	return "unknown";
}

function private ArchetypeRobotBlackboardInit()
{
	entity = self;

	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( entity );
	
	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( entity );
	
	// USE UTILITY BLACKBOARD
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE ROBOT BLACKBOARD
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_speed","locomotion_speed_sprint",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_speed");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_mind_control","normal",&robotIsMindControlled);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_mind_control");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_move_mode","normal",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_move_mode");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_gibbed_limbs",undefined,&robotGetGibbedLimbs);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_gibbed_limbs");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_robot_jump_direction",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_robot_jump_direction");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_robot_locomotion_type",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_robot_locomotion_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_robot_traversal_type",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_robot_traversal_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_robot_wallrun_direction",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_robot_wallrun_direction");#/    };
	
	// REGISTER ANIMSCRIPTED CALLBACK
	entity.___ArchetypeOnAnimscriptedCallback = &ArchetypeRobotOnAnimScriptedCallback;
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#entity FinalizeTrackedBlackboardAttributes();#/;	
	
	// THREAD PRE BULLET FIRE CALLBACK
	if ( SessionModeIsCampaignGame() || SessionModeIsZombiesGame() )
	{
		self thread gameskill::accuracy_buildup_before_fire( self );
	}
	
	// RUN SNIPER GLINT AND LASER IF ACCURATE FIRE IS ON
	if( self.accurateFire )
	{
		self thread AiUtility::preShootLaserAndGlintOn( self );
		self thread AiUtility::postShootLaserAndGlintOff( self );
	}
}

function private robotCrawlerCanShootEnemy( entity )
{
	if ( !IsDefined( entity.enemy ) )
	{
		return false;
	}

	aimLimits = entity GetAimLimitsFromEntry( "robot_crawler" );

	yawToEnemy = AngleClamp180(
		VectorToAngles( ( entity LastKnownPos( entity.enemy ) ) - entity.origin )[1] - entity.angles[1] );

	angleEpsilon = 10;
	
	return yawToEnemy <= ( aimLimits["aim_left"] + angleEpsilon ) &&
		yawToEnemy >= ( aimLimits["aim_right"] + angleEpsilon );
}

function private ArchetypeRobotOnAnimScriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeRobotBlackboardInit();
}

function private robotGetGibbedLimbs()
{
	entity = self;

	rightArmGibbed = GibServerUtils::IsGibbed( entity, 16 );
	leftArmGibbed = GibServerUtils::IsGibbed( entity, 32 );
	
	if ( rightArmGibbed && leftArmGibbed )
	{
		return "both_arms";
	}
	else if ( rightArmGibbed )
	{
		return "right_arm";
	}
	else if ( leftArmGibbed )
	{
		return "left_arm";
	}
	
	return "none";
}

function private robotInvalidateCover( entity )
{
	entity.steppedOutOfCover = false;
	entity PathMode( "move allowed" );
}

function private robotDelayMovement( entity )
{
	entity PathMode( "move delayed", false, RandomFloatRange( 1, 2 ) );
}

function private robotMovement( entity )
{
	if( Blackboard::GetBlackBoardAttribute( entity, "_stance" ) != "stand" )
	{
		Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );
	}
}

function private robotCoverScanInitialize( entity )
{
	Blackboard::SetBlackBoardAttribute( entity, "_cover_mode", "cover_scan" );
	Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );
	Blackboard::SetBlackBoardAttribute( entity, "_robot_step_in", "slow" );
	
	AiUtility::keepClaimNode( entity );
	
	AiUtility::chooseCoverDirection( entity, true );
	
	entity.steppedOutOfCoverNode = entity.node;
}

function private robotCoverScanTerminate( entity )
{	
	AiUtility::cleanupCoverMode( entity );
	
	entity.steppedOutOfCover = true;
	entity.steppedOutTime = GetTime() - ( 8 * 1000 );
	
	AiUtility::releaseClaimNode( entity );
	
	entity PathMode( "dont move" );
}

function robotCanJuke( entity )
{	
	if ( !entity ai::get_behavior_attribute( "phalanx" ) &&
		!( isdefined( entity.steppedOutOfCover ) && entity.steppedOutOfCover ) &&
		AiUtility::canJuke( entity ) )
	{
		jukeEvents = Blackboard::GetBlackboardEvents( "actor_juke" );
		tooCloseJukeDistanceSqr = 240 * 240;
	
		foreach ( event in jukeEvents )
		{
			if ( Distance2DSquared( entity.origin, event.data.origin ) <= tooCloseJukeDistanceSqr )
			{
				return false;
			}
		}
		
		return true;
	}
	
	return false;
}

function robotCanTacticalJuke( entity )
{
	if ( entity HasPath () &&
		AiUtility::BB_GetLocomotionFaceEnemyQuadrant() == "locomotion_face_enemy_front" )
	{
		jukeDirection = AiUtility::calculateJukeDirection(
			entity, 50, entity.jukeDistance );
		
		return jukeDirection != "forward";
	}
	
	return false;
}

function robotCanPreemptiveJuke( entity )
{
	if ( !IsDefined( entity.enemy ) || !IsPlayer( entity.enemy ) )
	{
		return false;
	}
	
	if ( Blackboard::GetBlackBoardAttribute( entity, "_stance" ) == "crouch" )
	{
		return false;
	}
	
	if ( !entity.shouldPreemptiveJuke )
	{
		return false;
	}
	
	if ( IsDefined( entity.nextPreemptiveJuke ) && entity.nextPreemptiveJuke > GetTime() )
	{
		return false;
	}
	
	if ( entity.enemy PlayerADS() < entity.nextPreemptiveJukeAds )
	{
		return false;
	}
	
	jukeMaxDistance = 600;
	
	if ( IsWeapon( entity.enemy.currentweapon ) && 
		IsDefined( entity.enemy.currentweapon.enemycrosshairrange ) &&
		entity.enemy.currentweapon.enemycrosshairrange > 0)
	{
		jukeMaxDistance = entity.enemy.currentweapon.enemycrosshairrange;
		
		if ( jukeMaxDistance > ( 600 * 2 ) )
		{
			// limit the weapons preemptive juking out to twice the max distance (1200)
			jukeMaxDistance = 600 * 2;
		}
	}
	
	// Only juke if the robot is close enough to their enemy.
	if ( DistanceSquared( entity.origin, entity.enemy.origin ) < ( (jukeMaxDistance) * (jukeMaxDistance) ) )
	{
		angleDifference = AbsAngleClamp180( entity.angles[1] - entity.enemy.angles[1] );
	
		/#
		record3DText( angleDifference, entity.origin + (0, 0, 5), ( 0, 1, 0 ), "Animscript" );
		#/
	
		// Make sure the robot could actually see their enemy.
		if ( angleDifference > 135 )
		{
			enemyAngles = entity.enemy GetGunAngles();
			toEnemy = entity.enemy.origin - entity.origin;
			forward = AnglesToForward( enemyAngles );
			dotProduct = Abs( VectorDot( VectorNormalize( toEnemy ), forward ) );
			
			/#
			record3DText( ACos( dotProduct ), entity.origin + (0, 0, 10), ( 0, 1, 0 ), "Animscript" );
			#/
			
			// Make sure the player is aiming close to the robot.
			if ( dotProduct > 0.9848 )
			{
				// Less than cos(10 degrees) between forard vector and vector to enemy.
				return robotCanJuke( entity );
			}
		}
	}
	
	return false;
}

function robotIsAtCoverModeScan( entity )
{
	coverMode = Blackboard::GetBlackBoardAttribute( entity, "_cover_mode" );
	
	return coverMode == "cover_scan";
}

function private robotPrepareForAdjustToCover( entity )
{
	AiUtility::keepClaimNode( entity );
	
	Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "crouch" );
}

function private robotCrawlerService( entity )
{
	if ( IsDefined( entity.crawlerLifeTime ) &&
		entity.crawlerLifeTime <= GetTime() &&
		entity.health > 0 )
	{
		entity Kill();
	}
	
	return true;
}

function private robotIsCrawler( entity )
{
	return entity.isCrawler;
}

function private robotBecomeCrawler( entity )
{
	if ( !entity ai::get_behavior_attribute( "can_become_crawler" ) )
	{
		return;
	}

	entity.isCrawler = true;
	entity.becomeCrawler = false;
	entity AllowPitchAngle( 1 );
	entity SetPitchOrient();
	entity.crawlerLifeTime = GetTime() + RandomIntRange( 10000, 20000 );
	entity notify( "bhtn_action_notify", "rbCrawler" );
}

function private robotShouldBecomeCrawler( entity )
{
	return entity.becomeCrawler;
}

function private robotIsMarching( entity )
{
	return Blackboard::GetBlackBoardAttribute( entity, "_move_mode" ) == "marching";
}

function private robotLocomotionSpeed()
{
	entity = self;
	
	if ( robotIsMindControlled() == "mind_controlled" )
	{
		switch ( ai::GetAiAttribute( entity, "rogue_control_speed" ) )
		{
		case "walk":
			return "locomotion_speed_walk";
		case "run":
			return "locomotion_speed_run";
		case "sprint":
			return "locomotion_speed_sprint";
		}
	}
	else if ( ai::GetAiAttribute( entity, "sprint" ) )
	{
		return "locomotion_speed_sprint";
	}
	
	return "locomotion_speed_walk";
}

function private robotCoverOverInitialize( behaviorTreeEntity )
{
	AiUtility::setCoverShootStartTime( behaviorTreeEntity );
	AiUtility::keepClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_over" );	
}

function private robotCoverOverTerminate( behaviorTreeEntity )
{	
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
	AiUtility::clearCoverShootStartTime( behaviorTreeEntity );
}

function private robotIsMindControlled()
{
	entity = self;
	
	if ( entity.controlLevel > 1 )
	{
		return "mind_controlled";
	}
	
	return "normal";
}

function private robotDontTakeCover( entity )
{
	entity.combatmode = "no_cover";
	entity.resumeCover = GetTime() + 4000;
}

function private _IsValidPlayer( player )
{
	if( !IsDefined( player ) ||
		!IsAlive( player ) ||
		!IsPlayer( player ) ||
		player.sessionstate == "spectator" ||
		player.sessionstate == "intermission" ||
		player laststand::player_is_in_laststand() ||
		player.ignoreme ) 
	{
		return false;
	}
	
	return true;
}

function private robotRushEnemyService( entity )
{
	if ( !IsDefined( entity.enemy ) )
	{
		return false;
	}
	
	distanceToEnemy = Distance2DSquared( entity.origin, entity.enemy.origin );

	if ( distanceToEnemy >= (600 * 600) &&
		distanceToEnemy <= (1200 * 1200) )
	{
		findPathResult = entity FindPath( entity.origin, entity.enemy.origin, true, false );
	
		if ( findPathResult )
		{
			entity ai::set_behavior_attribute( "move_mode", "rusher" );
		}
	}
}

function private _IsValidRusher( entity, neighbor )
{
	return IsDefined( neighbor ) &&
		IsDefined( neighbor.archetype ) &&
		neighbor.archetype == "robot" &&
		IsDefined( neighbor.team ) &&
		entity.team == neighbor.team &&
		entity != neighbor &&
		IsDefined( neighbor.enemy ) &&
		neighbor ai::get_behavior_attribute( "move_mode" ) == "normal" &&
		!( neighbor ai::get_behavior_attribute( "phalanx" ) ) &&
		neighbor ai::get_behavior_attribute( "rogue_control" ) == "level_0" &&
		DistanceSquared( entity.origin, neighbor.origin ) < (400 * 400) &&
		DistanceSquared( neighbor.origin, neighbor.enemy.origin ) < (1200 * 1200);
}

function private robotRushNeighborService( entity )
{
	actors = GetAiArray();
	
	closestEnemy = undefined;
	closestEnemyDistance = undefined;
	
	foreach( index, ai in actors )
	{
		if ( _IsValidRusher( entity, ai ) )
		{
			enemyDistance = DistanceSquared( entity.origin, ai.origin );
			
			if ( !IsDefined( closestEnemyDistance ) ||
				enemyDistance < closestEnemyDistance )
			{
				closestEnemyDistance = enemyDistance;
				closestEnemy = ai;
			}
		}
	}
	
	if ( IsDefined( closestEnemy ) )
	{
		findPathResult = entity FindPath( closestEnemy.origin, closestEnemy.enemy.origin, true, false );
	
		if ( findPathResult )
		{
			closestEnemy ai::set_behavior_attribute( "move_mode", "rusher" );
		}
	}
}

function private _FindClosest( entity, entities )
{
	closest = SpawnStruct();

	if ( entities.size > 0 )
	{
		closest.entity = entities[0];
		closest.distanceSquared = DistanceSquared( entity.origin, closest.entity.origin );
		
		for ( index = 1; index < entities.size; index++ )
		{
			distanceSquared = DistanceSquared( entity.origin, entities[index].origin );
			
			if ( distanceSquared < closest.distanceSquared )
			{
				closest.distanceSquared = distanceSquared;
				closest.entity = entities[index];
			}
		}
	}
	
	return closest;
}

function private robotTargetService( entity )
{
	if ( robotAbleToShootCondition( entity ) )
	{
		return false;
	}
	
	if ( ( isdefined( entity.ignoreall ) && entity.ignoreall ) )
	{
		return false;
	}
	
	// Wait to select a new target so long as the current one is alive.
	if ( IsDefined( entity.nextTargetServiceUpdate ) &&
		entity.nextTargetServiceUpdate > GetTime() &&
		IsAlive( entity.favoriteenemy ) )
	{
		return false;
	}
	
	positionOnNavMesh = GetClosestPointOnNavMesh( entity.origin, 200 );
	
	if ( !IsDefined( positionOnNavMesh ) )
	{
		return;
	}
	
	// Clean up favoriteenemy information if set.
	if ( IsDefined( entity.favoriteenemy ) &&
		IsDefined( entity.favoriteenemy._currentRogueRobot ) &&
		entity.favoriteenemy._currentRogueRobot == entity )
	{
		entity.favoriteenemy._currentRogueRobot = undefined;
	}

	aiEnemies = [];
	playerEnemies = [];
	ai = GetAiArray();
	players = GetPlayers();

	// Add AI's that are on different teams.
	foreach( index, value in ai )
	{
		// if this entity is a sentient and this robot is told to ignore it, skip over and consider others.
		if ( IsSentient( value ) && entity GetIgnoreEnt( value ) )
		{
			continue;
		}
		
		// Throw out other AI's that are outside the entity's goalheight.
		// This prevents considering enemies on other floors.
		if ( value.team != entity.team && IsActor( value ) && !IsDefined( entity.favoriteenemy ) )
		{
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh( value.origin, 200, 30 );
		
			if ( IsDefined( enemyPositionOnNavMesh ) &&
				entity FindPath( positionOnNavMesh, enemyPositionOnNavMesh, true, false ) )
			{
				aiEnemies[aiEnemies.size] = value;
			}
		}
	}
	
	// Add valid players
	foreach( index, value in players )
	{
		if ( _IsValidPlayer( value ) && value.team != entity.team  )
		{
			// if this robot is told to ignore this player, skip over and consider others.
			if ( IsSentient( value ) && entity GetIgnoreEnt( value ) )
			{
				continue;
			}
			
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh( value.origin, 200, 30 );
		
			if ( IsDefined( enemyPositionOnNavMesh ) &&
				entity FindPath( positionOnNavMesh, enemyPositionOnNavMesh, true, false ) )
			{
				playerEnemies[playerEnemies.size] = value;
			}
		}
	}
	
	closestPlayer = _FindClosest( entity, playerEnemies );
	closestAI = _FindClosest( entity, aiEnemies );
	
	if ( !IsDefined( closestPlayer.entity ) && !IsDefined( closestAI.entity ) )
	{
		// No player or actor to choose, bail out.
		return;
	}
	else if ( !IsDefined( closestAI.entity ) )
	{
		// Only has a player to choose.
		entity.favoriteenemy = closestPlayer.entity;
	}
	else if ( !IsDefined( closestPlayer.entity ) )
	{
		// Only has an AI to choose.
		entity.favoriteenemy = closestAI.entity;
		entity.favoriteenemy._currentRogueRobot = entity;
	}
	else if ( closestAI.distanceSquared < closestPlayer.distanceSquared )
	{
		// AI is closer than a player, time for additional checks.
		entity.favoriteenemy = closestAI.entity;
		entity.favoriteenemy._currentRogueRobot = entity;
	}
	else
	{
		// Player is closer, choose them.
		entity.favoriteenemy = closestPlayer.entity;
	}
	
	entity.nextTargetServiceUpdate = GetTime() + RandomIntRange( 2500, 3500 );
}

function private setDesiredStanceToStand( behaviorTreeEntity )
{
	currentStance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	
	if( currentStance == "crouch" )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
	}	
}

function private setDesiredStanceToCrouch( behaviorTreeEntity )
{
	currentStance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	
	if( currentStance == "stand" )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "crouch" );
	}
}

function private toggleDesiredStance( entity )
{
	currentStance = Blackboard::GetBlackBoardAttribute( entity, "_stance" );
	
	if( currentStance == "stand" )
	{
		Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "crouch" );
	}
	else
	{
		Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );
	}
}

function private robotShouldShutdown( entity )
{
	return entity ai::get_behavior_attribute( "shutdown" );
}

function private robotShouldExplode( entity )
{
	if ( entity.controlLevel >= 3 )
	{
		if ( entity ai::get_behavior_attribute( "rogue_force_explosion" ) )
		{
			return true;
		}
		else if ( IsDefined( entity.enemy ) )
		{
			enemyDistSq = DistanceSquared( entity.origin, entity.enemy.origin );
	
			return enemyDistSq < ( 60 * 60 );
		}
	}
	
	return false;
}

function private robotShouldAdjustToCover( entity )
{
	if( !IsDefined( entity.node ) )
	{
		return false;
	}
	
	return Blackboard::GetBlackBoardAttribute( entity, "_stance" ) != "crouch";
}

function private robotShouldReactAtCover( behaviorTreeEntity )
{
	return
		Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" ) == "crouch" &&
		AiUtility::canBeFlanked( behaviorTreeEntity ) &&
		behaviorTreeEntity IsAtCoverNodeStrict() &&
		behaviorTreeEntity IsFlankedAtCoverNode() &&
		!behaviorTreeEntity HasPath();
}

function private robotExplode( entity )
{
	entity.allowDeath = false;
	entity.noCyberCom = true;
}

function private robotExplodeTerminate( entity )
{
	Blackboard::SetBlackBoardAttribute( entity, "_gib_location", "legs" );
	
	entity RadiusDamage(
		entity.origin + (0, 0, 72 / 2),
		60,
		100,
		50,
		entity,
		"MOD_EXPLOSIVE" );
	
	if ( math::cointoss() )
	{
		GibServerUtils::GibLeftArm( entity );		
	}
	else
	{
		GibServerUtils::GibRightArm( entity );		
	}
	
	GibServerUtils::GibLegs( entity );
	GibServerUtils::GibHead( entity );
	
	clientfield::set(
		"robot_mind_control_explosion", 1 );

	if ( IsAlive( entity ) )
	{
		entity.allowDeath = true;
		entity Kill();
	}
	
	entity StartRagdoll();
}

function private robotExposedCoverService( entity )
{
	// Allows robot AI to move away from their "step out" cover position when
	// the node becomes invalid.
	if ( IsDefined( entity.steppedOutOfCover ) &&
		IsDefined( entity.steppedOutOfCoverNode ) &&
		( !entity IsCoverValid( entity.steppedOutOfCoverNode ) ||
		entity HasPath() ||
		!entity IsSafeFromGrenade() ) )
	{
		entity.steppedOutOfCover = false;
		entity PathMode( "move allowed" );
	}
	
	if ( IsDefined( entity.resumeCover ) && GetTime() > entity.resumeCover )
	{
		entity.combatMode = "cover";
		entity.resumeCover = undefined;
	}
}

function private robotIsAtCoverCondition( entity )
{
	enemyTooClose = false;

	if( IsDefined( entity.enemy ) )
	{
		lastKnownEnemyPos = entity LastKnownPos( entity.enemy );
		distanceToEnemySqr = Distance2DSquared( entity.origin, lastKnownEnemyPos );
		enemyTooClose = distanceToEnemySqr <= ( 240 * 240 );
	}

	return !enemyTooClose &&
		!entity.steppedOutOfCover &&
		entity IsAtCoverNodeStrict() &&
		entity ShouldUseCoverNode() &&
		!entity HasPath() &&
		entity IsSafeFromGrenade() &&
		entity.combatMode != "no_cover";
}

function private robotSupportsOverCover( entity )
{
	if ( IsDefined( entity.node ) )
	{
		if ( ( (isdefined(entity.node.spawnflags)&&((entity.node.spawnflags & 4) == 4))) )
		{
			return (entity.node.type == "Cover Stand" || entity.node.type == "Conceal Stand");
		}
	
		return (entity.node.type == "Cover Left") ||
			(entity.node.type == "Cover Right") ||
			(entity.node.type == "Cover Crouch" || entity.node.type == "Cover Crouch Window" || entity.node.type == "Conceal Crouch" );
	}
	
	return false;
}

function private canMoveToEnemyCondition( entity )
{
	if ( !IsDefined( entity.enemy ) || entity.enemy.health <= 0 )
	{
		return false;
	}

	positionOnNavMesh = GetClosestPointOnNavMesh( entity.origin, 200 );
	enemyPositionOnNavMesh = GetClosestPointOnNavMesh( entity.enemy.origin, 200, 30 );
	
	if ( !IsDefined( positionOnNavMesh ) || !IsDefined( enemyPositionOnNavMesh ) )
	{
		return false;
	}

	findPathResult = entity FindPath( positionOnNavMesh, enemyPositionOnNavMesh, true, false );
	
	/#
	if ( !findPathResult )
	{
		record3DText( "NO PATH", enemyPositionOnNavMesh + (0, 0, 5), ( 1, .5, 0 ), "Animscript" );
		recordLine( positionOnNavMesh, enemyPositionOnNavMesh, ( 1, .5, 0 ), "Animscript", entity );
	}
	#/
	
	return findPathResult;
}

function private canMoveCloseToEnemyCondition( entity )
{
	if ( !IsDefined( entity.enemy ) || entity.enemy.health <= 0 )
	{
		return false;
	}
	
	queryResult = PositionQuery_Source_Navigation(
		entity.enemy.origin,
		0,
		120,
		120,
		20,
		entity );
	
	PositionQuery_Filter_InClaimedLocation( queryResult, entity );

	return queryResult.data.size > 0;
}

function private robotStartSprint( entity )
{
	Blackboard::SetBlackBoardAttribute( entity, "_locomotion_speed", "locomotion_speed_sprint" );
}

function private robotStartSuperSprint( entity )
{
	Blackboard::SetBlackBoardAttribute( entity, "_locomotion_speed", "locomotion_speed_super_sprint" );
}

function private robotTacticalWalkActionStart( entity )
{	
	AiUtility::resetCoverParameters( entity );
	AiUtility::setCanBeFlanked( entity, false );
	
	Blackboard::SetBlackBoardAttribute( entity, "_locomotion_speed", "locomotion_speed_walk" );
	Blackboard::SetBlackBoardAttribute( entity, "_stance", "stand" );
	
	if ( IsDefined( entity.enemy ) )
	{
		entity OrientMode( "face enemy" );
	}
	else
	{
		entity OrientMode( "face motion" );
	}
}

function private robotDie( entity )
{
	if ( IsAlive( entity ) )
	{
		entity Kill();
	}
}

function private moveToPlayerUpdate( entity, asmStateName )
{
	entity.keepclaimednode = false;

	positionOnNavMesh = GetClosestPointOnNavMesh(entity.origin, 200 );
	
	if ( !IsDefined( positionOnNavMesh ) )
	{
		// Not on the navmesh, bail out.
		return 4;
	}
	
	if ( ( isdefined( entity.ignoreall ) && entity.ignoreall ) )
	{
		entity ClearUsePosition();
		return 4;
	}
	
	if ( !IsDefined( entity.enemy ) )
	{
		return 4;
	}
	
	if ( robotRogueHasCloseEnemyToMelee( entity ) )
	{
		// Already at their enemy, bail out.
		return 4;
	}
		
	if ( IsDefined( entity.enemy ) &&
		DistanceSquared( entity.origin, entity.enemy.origin ) > ( (300) * (300) ) )
	{
		// Allow clipping with other AI's at a distance, this helps when the AI's move diagonally into each other.
		entity PushActors( false );
	}
	else
	{
		// Force AI's to push each other close to their enemy.
		entity PushActors( true );
	}
	
	if ( !IsDefined( entity.lastKnownEnemyPos) )
	{
		entity.lastKnownEnemyPos = entity.enemy.origin;
	}
	
	shouldRepath = !IsDefined( entity.lastValidEnemyPos );
	
	if ( !shouldRepath && IsDefined( entity.enemy ) )
	{
		if ( IsDefined( entity.nextMoveToPlayerUpdate ) && entity.nextMoveToPlayerUpdate <= GetTime() )
		{
			// It's been a while, repath!
			shouldRepath = true;
		}
		else if ( DistanceSquared( entity.lastKnownEnemyPos, entity.enemy.origin ) > ( (72) * (72) ) )
		{
			// Enemy has moved far enough to force repathing.
			shouldRepath = true;
		}
		else if ( DistanceSquared( entity.origin, entity.enemy.origin ) <= ( (120) * (120) ) )
		{
			// Repath if close to the enemy.
			shouldRepath = true;
		}
		else if ( IsDefined( entity.pathGoalPos ) )
		{
			// Repath if close to the current goal position.
			distanceToGoalSqr = DistanceSquared( entity.origin, entity.pathGoalPos );
			
			shouldRepath = distanceToGoalSqr < ( (72) * (72) );
		}
	}

	if ( shouldRepath )
	{
		entity.lastKnownEnemyPos = entity.enemy.origin;
		
		// Find the closest pathable position on the navmesh to the enemy.
		queryResult = PositionQuery_Source_Navigation(
			entity.lastKnownEnemyPos,
			0,
			120,
			120,
			20,
			entity );
			
		PositionQuery_Filter_InClaimedLocation( queryResult, entity );
		
		if ( queryResult.data.size > 0 )
		{
			entity.lastValidEnemyPos = queryResult.data[0].origin;
		}
		
		if ( IsDefined( entity.lastValidEnemyPos ) )
		{
			entity UsePosition( entity.lastValidEnemyPos );
		
		// Randomized zig-zag path following if 20+ feet away from the enemy.
			if ( DistanceSquared( entity.origin, entity.lastValidEnemyPos ) > ( (240) * (240) ) )
		{
				path = entity CalcApproximatePathToPosition( entity.lastValidEnemyPos );
			
			/#
			if ( GetDvarInt( "ai_debugZigZag" ) )
			{
				for ( index = 1; index < path.size; index++ )
				{
					RecordLine( path[index - 1], path[index], ( 1, .5, 0 ), "Animscript", entity );
				}
			}
			#/
		
			deviationDistance = RandomIntRange( 240, 480 );  // 20 to 40 feet
		
			segmentLength = 0;
		
			// Walks the current path to find the point where the AI should deviate from their normal path.
			for ( index = 1; index < path.size; index++ )
			{
				currentSegLength = Distance( path[index - 1], path[index] );
				
				if ( ( segmentLength + currentSegLength ) > deviationDistance )
				{
					remainingLength = deviationDistance - segmentLength;
				
					seedPosition = path[index - 1] + ( VectorNormalize( path[index] - path[index - 1] ) * remainingLength );
				
					/# RecordCircle( seedPosition, 2, ( 1, .5, 0 ), "Animscript", entity ); #/
		
					innerZigZagRadius = 0;
					outerZigZagRadius = 64;
					
					// Find a point offset from the deviation point along the path.
					queryResult = PositionQuery_Source_Navigation(
						seedPosition,
						innerZigZagRadius,
						outerZigZagRadius,
						0.5 * 72,
						16,
						entity,
						16 );
					
					PositionQuery_Filter_InClaimedLocation( queryResult, entity );
		
					if ( queryResult.data.size > 0 )
					{
						point = queryResult.data[ RandomInt( queryResult.data.size ) ];
						
						// Use the deviated point as the path instead.
						entity UsePosition( point.origin );
					}
					
					break;
				}
				
				segmentLength += currentSegLength;
			}
		}
	}
	
	// Force repathing after a certain amount of time to smooth out movement.
	entity.nextMoveToPlayerUpdate = GetTime() + RandomIntRange(2000, 3000);
	}
	
	return 5;
}

function private robotShouldChargeMelee(entity)
{
	if( AiUtility::shouldMutexMelee( entity )
	   && robotHasEnemyToMelee( entity ))
	{
		return true;
	}
	
	return false;	
}

function private robotHasEnemyToMelee( entity )
{
	if ( IsDefined( entity.enemy ) &&
		IsSentient( entity.enemy ) &&
		entity.enemy.health > 0 )
	{
		enemyDistSq = DistanceSquared( entity.origin, entity.enemy.origin );

		if ( enemyDistSq < ( (125) * (125) ) && Abs( entity.enemy.origin[2] - entity.origin[2] ) < 24 )
		{
			yawToEnemy = AngleClamp180( entity.angles[ 1 ] -
				(VectorToAngles(entity.enemy.origin-entity.origin)[1]) );
			
			return abs( yawToEnemy ) <= 60;
		}
	}

	return false;
}

function private robotRogueHasEnemyToMelee( entity )
{
	if ( IsDefined( entity.enemy ) &&
		IsSentient( entity.enemy ) &&
		entity.enemy.health > 0 &&
		entity ai::get_behavior_attribute( "rogue_control" ) != "level_3" )
	{
		return DistanceSquared( entity.origin, entity.enemy.origin ) < ( (132) * (132) );
	}

	return false;
}

function private robotShouldMelee(entity)
{
	if( AiUtility::shouldMutexMelee( entity )
	   && robotHasCloseEnemyToMelee( entity ))
	{
		return true;
	}
	
	return false;	
}	

function private robotHasCloseEnemyToMelee( entity )
{
	if ( IsDefined( entity.enemy ) &&
		IsSentient( entity.enemy ) &&
		entity.enemy.health > 0 )
	{
		enemyDistSq = DistanceSquared( entity.origin, entity.enemy.origin );

		if ( enemyDistSq < ( (64) * (64) ) )
		{
			yawToEnemy = AngleClamp180( entity.angles[ 1 ] -
				(VectorToAngles(entity.enemy.origin-entity.origin)[1]) );
			
			return abs( yawToEnemy ) <= 60;
		}
	}

	return false;
}

function private robotRogueHasCloseEnemyToMelee( entity )
{
	if ( IsDefined( entity.enemy ) &&
		IsSentient( entity.enemy ) &&
		entity.enemy.health > 0 &&
		entity ai::get_behavior_attribute( "rogue_control" ) != "level_3" )
	{
		return DistanceSquared( entity.origin, entity.enemy.origin ) < ( (64) * (64) );
	}

	return false;
}

function private scriptRequiresToSprintCondition( entity )
{
	// TODO (David Young 1-29-14): Design is requesting that forcing sprint
	// always occurs, regardless of distance.
	/*
	if ( entity HasPath() &&
		DistanceSquared( entity.pathstartpos, entity.pathgoalpos ) <= ROBOT_WALK_MIN_DISTANCE_SQ )
	{
		return false;
	}
	*/
	
	// if the script interface needs sprinting, then no randomness
	return entity ai::get_behavior_attribute( "sprint" ) &&
		!entity ai::get_behavior_attribute( "disablesprint" );
}

function private robotScanExposedPainTerminate( entity )
{
	AiUtility::cleanupCoverMode( entity );
	Blackboard::SetBlackBoardAttribute( entity, "_robot_step_in", "fast" );
}

function private robotTookEmpDamage( entity )
{
	if ( IsDefined( entity.damageweapon ) && IsDefined( entity.damagemod ) )
	{
		weapon = entity.damageweapon;
		
		return entity.damagemod == "MOD_GRENADE_SPLASH" &&
			IsDefined( weapon.rootweapon ) &&
			isSubStr(weapon.rootweapon.name,"emp_grenade");		//checking substring for emp grenade variant;  probably this should be a gdt checkbox 'emp damage' or similar
	}
	return false;
}

function private _robotOutsideMovementRange( entity, range, useEnemyPos )
{
	assert( IsDefined( range ) );
	
	if ( !IsDefined( entity.enemy ) && !entity HasPath() )
	{
		return false;
	}
	
	goalPos = entity.pathgoalpos;
	
	if ( IsDefined( entity.enemy ) && useEnemyPos )
	{
		goalPos = entity LastKnownPos( entity.enemy );
	}
	
	if( !isdefined( goalPos ) )
	{
		return false;
	}
	
	outsideRange = DistanceSquared( entity.origin, goalPos ) > ( (range) * (range) );
	
	return outsideRange;
}

function private robotWithinSuperSprintRange( entity )
{
	if ( entity ai::get_behavior_attribute( "supports_super_sprint" ) &&
		!entity ai::get_behavior_attribute( "disablesprint" ) )
	{
		return _robotOutsideMovementRange( entity, entity.superSprintDistance, false );
	}
	
	return false;
}

function private robotOutsideSprintRange( entity )
{
	if ( entity ai::get_behavior_attribute( "supports_super_sprint" ) &&
		!entity ai::get_behavior_attribute( "disablesprint" ) )
	{
		return _robotOutsideMovementRange( entity, entity.superSprintDistance * 1.15, false );
	}
	
	return false;
}

function private robotOutsideTacticalWalkRange( entity )
{
	if ( entity ai::get_behavior_attribute( "disablesprint" ) )
	{
		return false;
	}

	if ( IsDefined( entity.enemy ) &&
		DistanceSquared( entity.origin, entity.goalPos ) < ( (entity.minWalkDistance) * (entity.minWalkDistance) ) )
	{
		// Slow down when closing in on the enemy.
		return false;
	}

	return _robotOutsideMovementRange( entity, entity.runAndGunDist * 1.15, true );
}

function private robotWithinSprintRange( entity )
{
	if ( entity ai::get_behavior_attribute( "disablesprint" ) )
	{
		return false;
	}

	if ( IsDefined( entity.enemy ) &&
		DistanceSquared( entity.origin, entity.goalPos ) < ( (entity.minWalkDistance) * (entity.minWalkDistance) ) )
	{
		// Slow down when closing in on the enemy.
		return false;
	}

	return _robotOutsideMovementRange( entity, entity.runAndGunDist, true );
}

function private shouldTakeOverCondition( entity )
{
	switch ( entity.controlLevel )
	{
		case 0:
			return IsInArray( array( "level_1", "level_2", "level_3" ),
				entity ai::get_behavior_attribute( "rogue_control" ) );
		case 1:
			return IsInArray( array( "level_2", "level_3" ),
				entity ai::get_behavior_attribute( "rogue_control" ) );
		case 2:
			return entity ai::get_behavior_attribute( "rogue_control" ) == "level_3";
	}

	return false;
}

function private hasMiniRaps( entity )
{
	return IsDefined( entity.miniRaps );
}

function private robotIsMoving( entity )
{
	velocity = entity GetVelocity();
	velocity = ( velocity[0], 0, velocity[1] );
	
	velocitySqr = LengthSquared( velocity );
	
	return velocitySqr > ( (24) * (24) );
}

function private robotAbleToShootCondition( entity )
{
	// Mind control level 2 and 3 are the only robots that can't shoot.
	return entity.controlLevel <= 1;
}

function private robotShouldTacticalWalk( entity )
{
	if ( !entity HasPath() )
	{
		return false;
	}

	return !robotIsMarching( entity );
}

function private _robotCoverPosition( entity )
{
	if( entity IsFlankedAtCoverNode() )
	{
		return false;
	}
		
	if( entity ShouldHoldGroundAgainstEnemy() )
	{
		return false;
	}

	shouldUseCoverNode = undefined;
	itsBeenAWhile  	   = GetTime() > entity.nextFindBestCoverTime;
	isAtScriptGoal 	   = undefined;	
	
	if ( IsDefined( entity.robotNode ) )
	{
		isAtScriptGoal = entity IsPosAtGoal( entity.robotNode.origin );
		shouldUseCoverNode = entity IsCoverValid( entity.robotNode );
	}
	else
	{
		isAtScriptGoal = entity IsAtGoal();
		shouldUseCoverNode = entity ShouldUseCoverNode();
	}
		
	shouldLookForBetterCover = !shouldUseCoverNode || itsBeenAWhile || !isAtScriptGoal;

/#	
	recordEntText( "ChooseBetterCoverReason: shouldUseCoverNode:" + shouldUseCoverNode 
		           + " itsBeenAWhile:" + itsBeenAWhile
		           + " isAtScriptGoal:" + isAtScriptGoal
		           , entity, ( shouldLookForBetterCover ? ( 0, 1, 0 ) : ( 1, 0, 0 ) ), "Animscript" );
#/

	// Only search for a new cover node if the AI isn't trying to keep their current claimed node.
	if ( shouldLookForBetterCover && IsDefined( entity.enemy ) && !entity.keepClaimedNode )
	{
		transitionRunning = entity ASMIsTransitionRunning();
		subStatePending = entity ASMIsSubStatePending();
		transDecRunning = entity AsmIsTransDecRunning();
		isBehaviorTreeInRunningState = entity GetBehaviortreeStatus() == 5;
	
		if ( !transitionRunning && !subStatePending && !transDecRunning && isBehaviorTreeInRunningState )
		{
			nodes = entity FindBestCoverNodes( entity.goalRadius, entity.goalPos );
			node = undefined;

			// Find the first unclaimed node or the node that is already claimed by entity.
			for ( nodeIndex = 0; nodeIndex < nodes.size; nodeIndex++ )
			{
				if ( entity.robotNode === nodes[nodeIndex] ||
					!IsDefined( nodes[nodeIndex].robotClaimed ) )
				{
					node = nodes[nodeIndex];
					break;
				}
			}
		
			// This covers a case where a robot is sent to a node specifically.
			if ( IsEntity( entity.node ) &&
				( !IsDefined( entity.robotNode ) || entity.robotNode != entity.node ) )
			{
				entity.robotNode = entity.node;
				entity.robotNode.robotClaimed = true;
			}
		
			goingToDifferentNode =
				IsDefined( node ) &&
				( !IsDefined( entity.robotNode ) || node != entity.robotNode ) &&
				( !IsDefined( entity.steppedOutOfCoverNode ) || entity.steppedOutOfCoverNode != node );
			
			AiUtility::setNextFindBestCoverTime( entity, node );
			
			if ( goingToDifferentNode )
			{
				if ( RandomFloat( 1 ) <= 0.75 || entity ai::get_behavior_attribute( "force_cover" ) )
				{
					AiUtility::useCoverNodeWrapper( entity, node );
				}
				else
				{
					searchRadius = entity.goalRadius;
					
					if ( searchRadius > ( 400 / 2 ) )
					{
						searchRadius = 400 / 2;
					}
				
					coverNodePoints = util::PositionQuery_PointArray( 
					    node.origin,
						60 / 2,
						searchRadius,
						72,
						30 );
					
					if ( coverNodePoints.size > 0 )
					{
						entity UsePosition( coverNodePoints[ RandomInt( coverNodePoints.size ) ] );
					}
					else
					{
						entity UsePosition( entity GetNodeOffsetPosition( node ) );
					}
				}
				
				if ( IsDefined( entity.robotNode ) )
				{
					entity.robotNode.robotClaimed = undefined;
				}
				
				entity.robotNode = node;
				entity.robotNode.robotClaimed = true;
				
				entity PathMode( "move delayed", false, RandomFloatRange( 0.25, 2 ) );
				
				return true;
			}
		}
	}
	
	return false;
}

function private _robotEscortPosition( entity )
{
	if ( entity ai::get_behavior_attribute( "move_mode" ) == "escort" )
	{
		escortPosition = entity ai::get_behavior_attribute( "escort_position" );
	
		if ( !IsDefined( escortPosition ) )
		{
			return false;
		}
	
		if ( Distance2DSquared( entity.origin, escortPosition ) <=
			150 * 150 )
		{
			return false;
		}
		
		if ( IsDefined( entity.escortNextTime ) &&
			GetTime() < entity.escortNextTime )
		{
			return false;
		}
		
		if ( entity GetPathMode() == "dont move" )
		{
			return false;
		}
		
		positionOnNavMesh = GetClosestPointOnNavMesh( escortPosition, 200 );
		
		if ( !IsDefined( positionOnNavMesh ) )
		{
			positionOnNavMesh = escortPosition;
		}
		
		queryResult = PositionQuery_Source_Navigation(
			positionOnNavMesh,
			75,
			150,
			0.5 * 72,
			16,
			entity,
			16 );
		
		PositionQuery_Filter_InClaimedLocation( queryResult, entity );
		
		if ( queryResult.data.size > 0 )
		{
			closestPoint = undefined;
			closestDistance = undefined;
		
			foreach ( point in queryResult.data )
			{
				if ( !point.inclaimedlocation )
				{
					newClosestDistance = Distance2DSquared( entity.origin, point.origin );
				
					if ( !IsDefined( closestPoint ) ||
						newClosestDistance < closestDistance )
					{
						closestPoint = point.origin;
						closestDistance = newClosestDistance;
					}
				}
			}
			
			if ( IsDefined( closestPoint ) )
			{
				entity UsePosition( closestPoint );
				entity.escortNextTime = GetTime() + RandomIntRange( 200, 300 );
			}
		}
		
		return true;
	}
	
	return false;
}

function private _robotRusherPosition( entity )
{
	if ( IsDefined( entity.enemy ) &&
		entity ai::get_behavior_attribute( "move_mode" ) == "rusher" )
	{
		if ( Distance2DSquared( entity.origin, entity.enemy.origin ) <=
			250 * 250 )
		{
			return false;
		}
		
		if ( IsDefined( entity.rusherNextTime ) &&
			GetTime() < entity.rusherNextTime )
		{
			return false;
		}
		
		positionOnNavMesh = GetClosestPointOnNavMesh( entity.enemy.origin, 200 );
		
		if ( !IsDefined( positionOnNavMesh ) )
		{
			positionOnNavMesh = entity.enemy.origin;
		}
		
		queryResult = PositionQuery_Source_Navigation(
			positionOnNavMesh,
			150,
			250,
			0.5 * 72,
			16,
			entity,
			16 );
		
		PositionQuery_Filter_InClaimedLocation( queryResult, entity );
		
		if ( queryResult.data.size > 0 )
		{
			closestPoint = undefined;
			closestDistance = undefined;
		
			foreach ( point in queryResult.data )
			{
				if ( !point.inclaimedlocation )
				{
					newClosestDistance = Distance2DSquared( entity.origin, point.origin );
				
					if ( !IsDefined( closestPoint ) ||
						newClosestDistance < closestDistance )
					{
						closestPoint = point.origin;
						closestDistance = newClosestDistance;
					}
				}
			}
			
			if ( IsDefined( closestPoint ) )
			{
				entity UsePosition( closestPoint );
				entity.rusherNextTime = GetTime() + RandomIntRange( 500, 1500 );
			}
		}
		
		return true;
	}
	
	return false;
}

function private _robotGuardPosition( entity )
{
	guardMode = entity ai::get_behavior_attribute( "move_mode" ) == "guard";
	
	if ( entity GetPathMode() == "dont move" )
	{
		return false;
	}

	if ( guardMode &&
		( !IsDefined( entity.guardPosition ) ||
		DistanceSquared( entity.origin , entity.guardPosition ) < ( (60) * (60) ) ) )
	{
		entity PathMode( "move delayed", true, RandomFloatRange( 1, 3 ) );
	
		queryResult = PositionQuery_Source_Navigation(
			entity.goalPos,
			0,
			entity.goalradius / 2,
			0.5 * 72,
			36,
			entity,
			72 );
		
		PositionQuery_Filter_InClaimedLocation( queryResult, entity );
		
		if ( queryResult.data.size > 0 )
		{
			minimumDistanceSq = entity.goalradius * 0.2;
			minimumDistanceSq = minimumDistanceSq * minimumDistanceSq;
			
			distantPoints = [];
			
			foreach( point in queryResult.data )
			{
				if ( DistanceSquared( entity.origin, point.origin ) > minimumDistanceSq )
				{
					distantPoints[ distantPoints.size ] = point;
				}
			}
		
			if ( distantPoints.size > 0 )
			{
				randomPosition = distantPoints[ RandomInt( distantPoints.size ) ];
				
				entity.guardPosition = randomPosition.origin;
				entity.intermediateGuardPosition = undefined;
				entity.intermediateGuardTime = undefined;
			}
		}
	}
	
	if ( guardMode )
	{
		// Checks every second to make sure the robot has moved.  If less than 2 feet
		// have changed, then set the guard position to be the robots current position
		// so a new guard position can be selected.
		currentTime = GetTime();
		
		if ( !IsDefined( entity.intermediateGuardTime ) ||
			entity.intermediateGuardTime < currentTime )
		{
			if ( IsDefined( entity.intermediateGuardPosition ) &&
				DistanceSquared( entity.intermediateGuardPosition , entity.origin ) < ( (24) * (24) ) )
			{
				entity.guardPosition = entity.origin;
			}
		
			entity.intermediateGuardPosition = entity.origin;
			entity.intermediateGuardTime = currentTime + 3000;
		}
	}
	
	if ( guardMode && IsDefined( entity.guardPosition ) )
	{
		// Keep reapplying the guardPosition.
		entity UsePosition( entity.guardPosition );
		
		return true;
	}
	
	entity.guardPosition = undefined;
	entity.intermediateGuardPosition = undefined;
	entity.intermediateGuardTime = undefined;
	return false;
}

function private robotPositionService( entity )
{
	/#
	if ( GetDvarInt( "ai_debugLastKnown" ) && IsDefined( entity.enemy ) )
	{
		lastKnownPos = entity LastKnownPos( entity.enemy );
		recordLine( entity.origin, lastKnownPos, ( 1, .5, 0 ), "Animscript", entity );
		record3DText( "lastKnownPos", lastKnownPos + (0, 0, 5), ( 1, .5, 0 ), "Animscript" );
	}
	#/
	
	// Release robotNode information upon death.
	if ( !IsAlive( entity ) )
	{
		if ( IsDefined( entity.robotNode ) )
		{
			AiUtility::releaseClaimNode( entity );
			entity.robotNode.robotClaimed = undefined;
			entity.robotNode = undefined;
		}
		
		return false;
	}
	
	// Early out tests.
	if ( !robotAbleToShootCondition( entity ) )
	{
		return false;
	}

	if ( entity ai::get_behavior_attribute( "phalanx" ) )
	{
		return false;
	}
	
	if( AiSquads::isFollowingSquadLeader( entity ) )
	{
		return false;
	}
	
	// Position selection logic, ordered by priority.
	if ( _robotRusherPosition( entity ) )
	{
		return true;
	}
	
	if ( _robotGuardPosition( entity ) )
	{
		return true;
	}
	
	if ( _robotEscortPosition( entity ) )
	{
		return true;
	}

	if ( !AiUtility::isSafeFromGrenades( entity ) )
	{
		AiUtility::releaseClaimNode( entity );
		AiUtility::chooseBestCoverNodeASAP( entity );
	}

	if ( _robotCoverPosition( entity ) )
	{
		return true;
	}
	
	// Go into exposed.
	return false;
}

function private robotDropStartingWeapon( entity, asmStateName )
{
	if ( entity.weapon.name == level.weaponNone.name )
	{
		entity shared::placeWeaponOn( entity.startingWeapon, "right" );
		entity thread shared::DropAIWeapon();
	}
}

function private robotJukeInitialize( entity )
{
	AiUtility::chooseJukeDirection( entity );
	entity ClearPath();
	entity notify( "bhtn_action_notify", "rbJuke" );
	
	jukeInfo = SpawnStruct();
	jukeInfo.origin = entity.origin;
	jukeInfo.entity = entity;

	Blackboard::AddBlackboardEvent( "actor_juke", jukeInfo, 3000 );
}

function private robotPreemptiveJukeTerminate( entity )
{
	entity.nextPreemptiveJuke = GetTime() + RandomIntRange( 4000, 6000 );
	entity.nextPreemptiveJukeAds = RandomFloatRange( 0.5, 0.95 );
}

function private robotTryReacquireService( entity )
{
	if ( !IsDefined( entity.reacquire_state ) )
	{
		entity.reacquire_state = 0;
	}

	if ( !IsDefined( entity.enemy ) )
	{
		entity.reacquire_state = 0;
		return false;
	}

	if ( entity HasPath() )
	{
		return false;
	}
	
	if ( !robotAbleToShootCondition( entity ) )
	{
		return false;
	}
	
	if ( entity ai::get_behavior_attribute( "force_cover" ) )
	{
		return false;
	}

	if ( entity CanSee( entity.enemy ) && entity CanShootEnemy() )
	{
		entity.reacquire_state = 0;
		return false;
	}

	// don't do reacquire unless facing enemy 
	dirToEnemy = VectorNormalize( entity.enemy.origin - entity.origin );
	forward = AnglesToForward( entity.angles );

	if ( VectorDot( dirToEnemy, forward ) < 0.5 )	
	{
		entity.reacquire_state = 0;
		return false;
	}

	switch ( entity.reacquire_state )
	{
	case 0:
	case 1:
	case 2:
		step_size = 32 + entity.reacquire_state * 32;
		reacquirePos = entity ReacquireStep( step_size );
		break;

	case 4:
		if ( !( entity CanSee( entity.enemy ) ) || !( entity CanShootEnemy() ) )
		{
			entity FlagEnemyUnattackable();
		}
		break;

	default:
		if ( entity.reacquire_state > 15 )
		{
			entity.reacquire_state = 0;
			return false;
		}
		break;
	}

	if ( IsVec( reacquirePos ) )
	{
		entity UsePosition( reacquirePos );
		return true;
	}

	entity.reacquire_state++;
	return false;
}

function private takeOverInitialize( entity, asmStateName )
{
	switch ( entity ai::get_behavior_attribute( "rogue_control" ) )
	{
		case "level_1":
			entity RobotSoldierServerUtils::forceRobotSoldierMindControlLevel1();
			break;
		case "level_2":
			entity RobotSoldierServerUtils::forceRobotSoldierMindControlLevel2();
			break;
		case "level_3":
			entity RobotSoldierServerUtils::forceRobotSoldierMindControlLevel3();
			break;
	}
	
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );
	return 5;
}

function private takeOverTerminate( entity, asmStateName )
{
	switch ( entity ai::get_behavior_attribute( "rogue_control" ) )
	{
		case "level_2":
		case "level_3":
			entity thread shared::DropAIWeapon();
			break;
	}
	
	return 4;
}

function private stepIntoInitialize( entity, asmStateName )
{
	// TODO(David Young 9-2-14): This is required in a very rare case, determine why that is.
	AiUtility::releaseClaimNode( entity );
	
	AiUtility::useCoverNodeWrapper( entity, entity.steppedOutOfCoverNode );
	Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "crouch" );
	AiUtility::keepClaimNode( entity );
	
	entity.steppedOutOfCoverNode = undefined;
	
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );
	
	return 5;
}

function private stepIntoTerminate( entity, asmStateName )
{
	entity.steppedOutOfCover = false;
	
	AiUtility::releaseClaimNode( entity );
	
	entity PathMode( "move allowed" );
	
	return 4;
}

function private stepOutInitialize( entity, asmStateName )
{
	entity.steppedOutOfCoverNode = entity.node;
	
	AiUtility::keepClaimNode( entity );
	
	if ( math::cointoss() )
	{
		Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );
	}
	else
	{
		Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "crouch" );
	}
	
	Blackboard::SetBlackBoardAttribute( entity, "_robot_step_in", "fast" );
	
	AiUtility::chooseCoverDirection( entity, true );
	
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );
	
	return 5;
}

function private stepOutTerminate( entity, asmStateName )
{
	entity.steppedOutOfCover = true;
	entity.steppedOutTime = GetTime();
	
	AiUtility::releaseClaimNode( entity );
	
	entity PathMode( "dont move" );
	
	return 4;
}

function private supportsStepOutCondition( entity )
{
	return (entity.node.type == "Cover Left") ||
		(entity.node.type == "Cover Right") ||
		(entity.node.type == "Cover Pillar");
}

function private shouldStepInCondition( entity )
{
	if ( !IsDefined( entity.steppedOutOfCover ) ||
		!entity.steppedOutOfCover ||
		!IsDefined( entity.steppedOutTime ) ||
		!entity.steppedOutOfCover )
	{
		return false;
	}
		
	exposedTimeInSeconds = (GetTime() - entity.steppedOutTime) / 1000;
	
	exceededTime = exposedTimeInSeconds >= 4 ||
		exposedTimeInSeconds >= 8;
	
	suppressed = entity.suppressionMeter > entity.suppressionThreshold;
	
	return exceededtime || ( exceededtime && suppressed );
}

function private robotDeployMiniRaps()
{
	entity = self;
	
	if ( IsDefined( entity ) && IsDefined( entity.miniRaps ) )
	{
		/*
		raps = SpawnVehicle(
			ROBOT_MINI_RAPS_SPAWNER,
			entity.miniRaps.origin + ROBOT_MINI_RAPS_OFFSET_POSITION,
			( 0, 0, 0 ) );
		*/
		
		positionOnNavMesh = GetClosestPointOnNavMesh( entity.origin, 200 );
		
		raps = SpawnVehicle(
			"spawner_bo3_mini_raps",
			positionOnNavMesh,
			( 0, 0, 0 ) );
		raps.team = entity.team;
		raps thread RobotSoldierServerUtils::RapsDetonateCountdown( raps );
		
		/*
		entity.miniRaps Delete();
		*/
		entity.miniRaps = undefined;
	}
}

// end #namespace RobotSoldierBehavior;

#namespace RobotSoldierServerUtils;

function private _tryGibbingHead( entity, damage, hitLoc, isExplosive )
{
	if ( isExplosive &&
		RandomFloatRange( 0, 1 ) <= 0.5 )
	{
		GibServerUtils::GibHead( entity );
	}
	else if ( IsInArray( array( "head", "neck", "helmet" ), hitLoc ) &&
		RandomFloatRange( 0, 1 ) <= 1 )
	{
		GibServerUtils::GibHead( entity );
	}
	else if ( ( entity.health - damage ) <= 0 &&
		RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		GibServerUtils::GibHead( entity );
	}
}

function private _tryGibbingLimb( entity, damage, hitLoc, isExplosive, onDeath )
{
	// Early out if one arm is already gibbed.
	if ( GibServerUtils::IsGibbed( entity, 32 ) ||
		GibServerUtils::IsGibbed( entity, 16) )
	{
		return;
	}

	if ( isExplosive &&
		RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		if ( onDeath && math::cointoss() )
		{
			// Only gib the right arm if the robot died.
			GibServerUtils::GibRightArm( entity );
		}
		else
		{
			GibServerUtils::GibLeftArm( entity );
		}
	}
	else if ( IsInArray( array( "left_hand", "left_arm_lower", "left_arm_upper" ), hitLoc ) )
	{
		GibServerUtils::GibLeftArm( entity );
	}
	else if ( onDeath &&
		IsInArray( array( "right_hand", "right_arm_lower", "right_arm_upper" ), hitLoc ) )
	{
		GibServerUtils::GibRightArm( entity );
	}
	else if ( RobotSoldierBehavior::robotIsMindControlled() == "mind_controlled" && 
		IsInArray( array( "right_hand", "right_arm_lower", "right_arm_upper" ), hitLoc ) )
	{
		GibServerUtils::GibRightArm( entity );
	}
	else if ( onDeath && RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		if ( math::cointoss() )
		{
			GibServerUtils::GibLeftArm( entity );
		}
		else
		{
			GibServerUtils::GibRightArm( entity );
		}
	}
}

function private _tryGibbingLegs( entity, damage, hitLoc, isExplosive, attacker )
{
	if ( !IsDefined( attacker ) )
	{
		attacker = entity;
	}

	// Gib on death.
	canGibLegs = ( entity.health - damage ) <= 0 && entity.allowdeath;
	
	// Gib based on damage.
	if ( entity ai::get_behavior_attribute( "can_become_crawler" ) )
	{
		canGibLegs = canGibLegs ||
			( ( ( entity.health - damage ) / entity.maxHealth ) <= 0.25 &&
			DistanceSquared( entity.origin, attacker.origin ) <= (600 * 600) &&
			!RobotSoldierBehavior::robotIsAtCoverCondition( entity ) &&
			entity.allowdeath );
	}
	
	if ( ( entity.health - damage ) <= 0 &&
		entity.allowdeath &&
		isExplosive &&
		RandomFloatRange( 0, 1 ) <= 0.5 )
	{
		GibServerUtils::GibLegs( entity );
		entity StartRagdoll();
	}
	else if ( canGibLegs &&
		IsInArray( array( "left_leg_upper", "left_leg_lower", "left_foot" ), hitLoc ) &&
		RandomFloatRange( 0, 1 ) <= 1 )
	{
		if ( ( entity.health - damage ) > 0 )
		{
			BecomeCrawler( entity );
		}
		
		GibServerUtils::GibLeftLeg( entity );
	}
	else if ( canGibLegs &&
		IsInArray( array( "right_leg_upper", "right_leg_lower", "right_foot" ), hitLoc ) &&
		RandomFloatRange( 0, 1 ) <= 1 )
	{
		if ( ( entity.health - damage ) > 0 )
		{
			BecomeCrawler( entity );
		}
		
		GibServerUtils::GibRightLeg( entity );
	}
	else if ( ( entity.health - damage ) <= 0 &&
		entity.allowdeath &&
		RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		// Randomly gib a leg when dead.
		if ( math::cointoss() )
		{
			GibServerUtils::GibLeftLeg( entity );
		}
		else
		{
			GibServerUtils::GibRightLeg( entity );
		}
	}
}

function private robotGibDamageOverride(
	inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	entity = self;
	
	if ( IsDefined( attacker ) && ( attacker.team == entity.team ) )
	{
		return damage;
	}
	
	if ( !entity ai::get_behavior_attribute( "can_gib" ) )
	{
		return damage;
	}
	
	// Check if any gibbing is allowed.
	if ( ( ( entity.health - damage ) / entity.maxHealth ) > 0.75 )
	{
		return damage;
	}
	
	// Enable spawning gib pieces.
	GibServerUtils::ToggleSpawnGibs( entity, true );
	DestructServerUtils::ToggleSpawnGibs( entity, true );

	isExplosive = IsInArray(
		array(
			"MOD_CRUSH",
			"MOD_GRENADE",
			"MOD_GRENADE_SPLASH",
			"MOD_PROJECTILE",
			"MOD_PROJECTILE_SPLASH",
			"MOD_EXPLOSIVE" ),
		meansOfDeath );
	
	_tryGibbingHead( entity, damage, hitLoc, isExplosive );
	_tryGibbingLimb( entity, damage, hitLoc, isExplosive, false );
	_tryGibbingLegs( entity, damage, hitLoc, isExplosive, attacker );

	return damage;
}

function private robotDeathOverride(
	inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime )
{
	entity = self;

	entity ai::set_behavior_attribute( "robot_lights", 4 );
	
	return damage;
}

function private robotGibDeathOverride(
	inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime )
{
	entity = self;

	if ( !entity ai::get_behavior_attribute( "can_gib" ) )
	{
		return damage;
	}

	// Enable spawning gib pieces.
	GibServerUtils::ToggleSpawnGibs( entity, true );
	DestructServerUtils::ToggleSpawnGibs( entity, true );

	isExplosive = false;

	if ( entity.controlLevel >= 3 )
	{
		clientfield::set(
			"robot_mind_control_explosion", 1 );
	
		DestructServerUtils::DestructNumberRandomPieces( entity );
		GibServerUtils::GibHead( entity );
		if ( math::cointoss() )
		{
			GibServerUtils::GibLeftArm( entity );
		}
		else
		{
			GibServerUtils::GibRightArm( entity );
		}
		GibServerUtils::GibLegs( entity );
		
		velocity = entity GetVelocity() / 9;
		
		entity StartRagdoll();
		entity LaunchRagdoll(
			( velocity[0] + RandomFloatRange( -10, 10 ),
			velocity[1] + RandomFloatRange( -10, 10 ),
			RandomFloatRange( 40, 50 ) ),
			"j_mainroot" );
			
		PhysicsExplosionSphere(
			entity.origin + (0, 0, 72 / 2), 120, 32, 1 );
	}
	else {
		isExplosive = IsInArray(
		array(
			"MOD_CRUSH",
			"MOD_GRENADE",
			"MOD_GRENADE_SPLASH",
			"MOD_PROJECTILE",
			"MOD_PROJECTILE_SPLASH",
			"MOD_EXPLOSIVE" ),
		meansOfDeath );
		
		_tryGibbingLimb( entity, damage, hitLoc, isExplosive, true );
	}
	
	return damage;
}

function private robotDestructDeathOverride(
	inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime )
{
	entity = self;
	
	// Enable spawning gib pieces.
	DestructServerUtils::ToggleSpawnGibs( entity, true );
		
	pieceCount = DestructServerUtils::GetPieceCount( entity );
	possiblePieces = [];
	
	// Find all pieces that haven't been destroyed yet.
	for ( index = 1; index <= pieceCount; index++ )
	{
		if ( !DestructServerUtils::IsDestructed( entity, index ) &&
			RandomFloatRange( 0, 1 ) <= 0.2 )
		{
			possiblePieces[ possiblePieces.size ] = index;
		}
	}
	
	gibbedPieces = 0;
	
	// Destroy up to the maximum number of pieces.
	for ( index = 0; index < possiblePieces.size && possiblePieces.size > 1 && gibbedPieces < 2; index++ )
	{
		randomPiece = RandomIntRange( 0, possiblePieces.size - 1 );
		
		if ( !DestructServerUtils::IsDestructed( entity, possiblePieces[ randomPiece ] ) )
		{
			DestructServerUtils::DestructPiece( entity, possiblePieces[ randomPiece ] );
			gibbedPieces++;
		}
	}
	
	return damage;
}

function private robotDamageOverride(
	inflictor, attacker, damage, flags, meansOfDamage, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	entity = self;
	
	if( hitLoc != "helmet" || hitLoc != "head" || hitLoc != "neck" )
	{
		if( isDefined( attacker ) && !isPlayer( attacker ) && !isVehicle( attacker ) )
		{
			dist = DistanceSquared( entity.origin, attacker.origin );
			
			if( dist < 256*256 )
			{
				damage = Int( damage * 10 );
			}
			else
			{
				damage = Int( damage * 1.5 );
			}
		}
	}

	
	// Reduce headshot damage to robots in script, since this is hardcoded elsewhere for AI's.
	if ( hitLoc == "helmet" || hitLoc == "head" || hitLoc == "neck" )
	{
		damage = Int( damage * 0.5 );
	}
	
	if ( IsDefined( dir ) &&
		IsDefined( meansOfDamage ) &&
		IsDefined( hitLoc ) &&
		VectorDot( AnglesToForward( entity.angles ), dir ) > 0 )
	{
		// Bullet came from behind.
		isBullet = IsInArray(
			array( "MOD_RIFLE_BULLET", "MOD_PISTOL_BULLET" ),
			meansOfDamage );
	
		isTorsoShot = IsInArray(
			array( "torso_upper", "torso_lower" ),
			hitLoc );
		
		if ( isBullet && isTorsoShot )
		{
			damage = Int( damage * 2 );
		}
	}
	
	// TODO(David Young 9-23-14): This is a hacky way to guarantee a kill when a sticky_grenade lands on a robot.
	if ( weapon.name == "sticky_grenade" )
	{
		switch ( meansOfDamage )
		{
			case "MOD_IMPACT":
				entity.stuckWithStickyGrenade = true;
				break;
			case "MOD_GRENADE_SPLASH":
				if ( ( isdefined( entity.stuckWithStickyGrenade ) && entity.stuckWithStickyGrenade ) )
				{
					damage = entity.health;
				}
			break;
		}
	}
	
	if ( meansOfDamage == "MOD_TRIGGER_HURT" && entity.ignoreTriggerDamage )
	{
		damage = 0;
	}
	
	return damage;
}

function private robotDestructRandomPieces(
	inflictor, attacker, damage, flags, meansOfDamage, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	entity = self;

	isExplosive = IsInArray(
		array(
			"MOD_CRUSH",
			"MOD_GRENADE",
			"MOD_GRENADE_SPLASH",
			"MOD_PROJECTILE",
			"MOD_PROJECTILE_SPLASH",
			"MOD_EXPLOSIVE" ),
		meansOfDamage );
		
	if ( isExplosive )
	{
		DestructServerUtils::DestructRandomPieces( entity );
	}
	
	return damage;
}

function private findClosestNavMeshPositionToEnemy( enemy )
{
	enemyPositionOnNavMesh = undefined;

	for ( toleranceLevel = 1; toleranceLevel <= 4; toleranceLevel++ )
	{
		enemyPositionOnNavMesh = GetClosestPointOnNavMesh(
			enemy.origin,
			200 * toleranceLevel,
			30 );
			
		if ( IsDefined( enemyPositionOnNavMesh ) )
		{
			break;
		}
	}
	
	return enemyPositionOnNavMesh;
}

function private robotChooseCoverDirection( entity, stepOut )
{
	if ( !IsDefined( entity.node ) )
	{
		return;
	}
	
	coverDirection = Blackboard::GetBlackBoardAttribute( entity, "_cover_direction" );
	Blackboard::SetBlackBoardAttribute( entity, "_previous_cover_direction", coverDirection );
	Blackboard::SetBlackBoardAttribute( entity, "_cover_direction", AiUtility::calculateCoverDirection( entity, stepOut ) );
}

function private robotSoldierSpawnSetup()
{
	entity = self;
	entity.isCrawler = false;
	entity.becomeCrawler = false;
	entity.combatmode = "cover";
	entity.fullHealth = entity.health;
	entity.controlLevel = 0;
	entity.steppedOutOfCover = false;
	entity.ignoreTriggerDamage = false;
	entity.startingWeapon = entity.weapon;
	entity.jukeDistance = 90;
	entity.jukeMaxDistance = 1200;
	entity.entityRadius = 30 / 2;
	entity.empShutdownTime = 2000;
	
	// Movement parameters
	entity.minWalkDistance = 240;
	entity.superSprintDistance = 300;
	
	entity.treatAllCoversAsGeneric = true;
	entity.onlyCrouchArrivals = true;
	
	entity.nextPreemptiveJukeAds = RandomFloatRange( 0.5, 0.95 );
	entity.shouldPreemptiveJuke = math::cointoss();
	
	DestructServerUtils::ToggleSpawnGibs( entity, true );
	GibServerUtils::ToggleSpawnGibs( entity, true );
	
	clientfield::set( "robot_mind_control", 0 );
	
	/#
	if ( GetDvarInt( "ai_robotForceProcedural" ) )
	{
		entity ai::set_behavior_attribute( "traversals", "procedural" );
	}
	#/
	
	entity thread CleanUpEquipment( entity );
	
	AiUtility::AddAIOverrideDamageCallback( entity, &DestructServerUtils::HandleDamage );
	AiUtility::AddAIOverrideDamageCallback( entity, &robotDamageOverride );
	AiUtility::AddAIOverrideDamageCallback( entity, &robotDestructRandomPieces );
	AiUtility::AddAiOverrideDamageCallback( entity, &robotGibDamageOverride );
	AiUtility::AddAIOverrideKilledCallback( entity, &robotDeathOverride );
	AiUtility::AddAIOverrideKilledCallback( entity, &robotGibDeathOverride );
	AiUtility::AddAIOverrideKilledCallback( entity, &robotDestructDeathOverride );
	
	/#
	if ( GetDvarInt( "ai_robotForceControl" ) == 1 )
		entity ai::set_behavior_attribute( "rogue_control", "level_1" );
	else if ( GetDvarInt( "ai_robotForceControl" ) == 2 )
		entity ai::set_behavior_attribute( "rogue_control", "level_2" );
	else if ( GetDvarInt( "ai_robotForceControl" ) == 3 )
		entity ai::set_behavior_attribute( "rogue_control", "level_3" );
		
	if ( GetDvarInt( "ai_robotSpawnForceControl" ) == 1 )
		entity ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
	else if ( GetDvarInt( "ai_robotSpawnForceControl" ) == 2 )
		entity ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	else if ( GetDvarInt( "ai_robotSpawnForceControl" ) == 3 )
		entity ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
	#/

	if ( GetDvarInt( "ai_robotForceCrawler" ) == 1 )
		entity ai::set_behavior_attribute( "force_crawler", "gib_legs" );
	else if ( GetDvarInt( "ai_robotForceCrawler" ) == 2 )
		entity ai::set_behavior_attribute( "force_crawler", "remove_legs" );
	
	// entity ai::set_behavior_attribute( "robot_mini_raps", true );
	// robotGiveWasp( entity );
	// entity thread robotDeployWasp( entity );
}

// To prevent the escort robot from losing parts when it takes damage
function removeDestructAndGibDamageOverride( entity )
{
	AiUtility::RemoveAIOverrideDamageCallback( entity, &DestructServerUtils::HandleDamage );
	AiUtility::RemoveAIOverrideDamageCallback( entity, &robotDestructRandomPieces );
	AiUtility::RemoveAiOverrideDamageCallback( entity, &robotGibDamageOverride );
}

function private robotGiveWasp( entity )
{
	if ( IsDefined( entity ) && !IsDefined( entity.wasp ) )
	{
		wasp = Spawn( "script_model", ( 0, 0, 0 ) );
		wasp SetModel( "veh_t7_drone_attack_red" );
		wasp SetScale( 0.75 );
		wasp LinkTo( entity, "j_spine4", ( 5, -15, 0 ), ( 0, 0, 90 ) );
		entity.wasp = wasp;
	}
}

function private robotDeployWasp( entity )
{
	entity endon( "death" );
	
	wait RandomFloatRange( 7, 10 );
	
	if ( IsDefined( entity ) && IsDefined( entity.wasp ) )
	{
		spawnOffset = ( 5, -15, 0 );
		
		while ( !IsPointInNavvolume( entity.wasp.origin + spawnOffset, "small volume" ) )
		{
			wait 1;
		}
		
		entity.wasp Unlink();
		
		wasp = SpawnVehicle( "spawner_bo3_wasp_enemy", entity.wasp.origin + spawnOffset, ( 0, 0, 0 ) );
		
		entity.wasp Delete();
	}
	
	entity.wasp = undefined;
}

function private RapsDetonateCountdown( entity )
{
	entity endon( "death" );
	
	wait RandomFloatRange(
		20,
		30 );
	
	raps::detonate();
}

function private BecomeCrawler( entity )
{
	if ( !RobotSoldierBehavior::robotIsCrawler( entity ) &&
		entity ai::get_behavior_attribute( "can_become_crawler" ) )
	{
		entity.becomeCrawler = true;
	}
}

function private CleanUpEquipment( entity )
{
	entity waittill( "death" );
	
	if ( !IsDefined( entity ) )
	{
		return;
	}
	
	if ( IsDefined( entity.miniRaps ) )
	{
		/*
		entity.miniRaps Delete();
		*/
		entity.miniRaps = undefined;
	}
	
	if ( IsDefined( entity.wasp ) )
	{
		entity.wasp Delete();
		entity.wasp = undefined;
	}
}

function private forceRobotSoldierMindControlLevel1()
{
	entity = self;
	
	if ( entity.controlLevel >= 1 )
	{
		return;
	}
	
	entity.team = "team3";
	entity.controlLevel = 1;
	clientfield::set( "robot_mind_control", 1 );
	entity ai::set_behavior_attribute( "rogue_control", "level_1" );
}

function private forceRobotSoldierMindControlLevel2()
{
	entity = self;
	
	if ( entity.controlLevel >= 2 )
	{
		return;
	}
	
	rogue_melee_weapon = GetWeapon( "rogue_robot_melee" );
	
	locomotionTypes = array( "alt1", "alt2", "alt3", "alt4", "alt5" );
	
	Blackboard::SetBlackBoardAttribute( entity, "_robot_locomotion_type", locomotionTypes[ RandomInt( locomotionTypes.size ) ] );
	entity ASMSetAnimationRate( RandomFloatRange( 0.95, 1.05 ) );
	entity forceRobotSoldierMindControlLevel1();
	entity.combatmode = "no_cover";
	entity SetAvoidanceMask( "avoid none" );
	entity.controlLevel = 2;
	entity shared::placeWeaponOn( entity.weapon, "none" );
	entity.meleeweapon = rogue_melee_weapon;
	entity.dontDropWeapon = true;
	
	if ( entity ai::get_behavior_attribute( "rogue_allow_predestruct" ) )
	{
		DestructServerUtils::DestructRandomPieces( entity );
	}
	
	// Half the health when robots become mind controlled.
	if ( entity.health > entity.maxhealth * 0.6 )
	{
		entity.health = int( entity.maxhealth * 0.6 );
	}
	
	clientfield::set( "robot_mind_control", 2 );
	entity ai::set_behavior_attribute( "rogue_control", "level_2" );
	entity ai::set_behavior_attribute( "can_become_crawler", false );
}

function private forceRobotSoldierMindControlLevel3()
{
	entity = self;
	
	if ( entity.controlLevel >= 3 )
	{
		return;
	}
	
	forceRobotSoldierMindControlLevel2();
	entity.controlLevel = 3;
		
	clientfield::set( "robot_mind_control", 3 );
	entity ai::set_behavior_attribute( "rogue_control", "level_3" );
}

function robotEquipMiniRaps(  entity, attribute, oldValue, value  )
{
	entity.miniRaps = value;

	// Do not display a miniraps on a robot.
	/*
	if ( IsDefined( entity ) && !IsDefined( entity.miniRaps ) )
	{
		entity.miniRaps = Spawn( "script_model", ( 0, 0, 0 ) );
		entity.miniRaps SetModel( ROBOT_MINI_RAPS_MODEL );
		entity.miniRaps LinkTo(
			entity,
			ROBOT_MINI_RAPS_LINK_TO_BONE,
			ROBOT_MINI_RAPS_OFFSET_POSITION,
			( 0, 0, 0 ) );
	}
	*/
}

function robotLights( entity, attribute, oldValue, value )
{
	if ( value == 3 )
	{
		clientfield::set( "robot_lights", 3 );
	}
	else if ( value == 0 )
	{
		clientfield::set( "robot_lights", 0 );
	}
	else if ( value == 1 )
	{
		clientfield::set( "robot_lights", 1 );
	}
	else if ( value == 2 )
	{
		clientfield::set( "robot_lights", 2 );
	}
	else if ( value == 4 )
	{
		clientfield::set( "robot_lights", 4 );
	}
}

function RandomGibRogueRobot( entity )
{
	GibServerUtils::ToggleSpawnGibs( entity, false );
	
	if ( math::cointoss() )
	{
		if ( math::cointoss() )
		{
			GibServerUtils::GibRightArm( entity );
		}
		else if ( math::cointoss() )
		{
			GibServerUtils::GibLeftArm( entity );
		}
	}
	else
	{
		if ( math::cointoss() )
		{
			GibServerUtils::GibLeftArm( entity );
		}
		else if ( math::cointoss() )
		{
			GibServerUtils::GibRightArm( entity );
		}
	}
}

function rogueControlAttributeCallback( entity, attribute, oldValue, value )
{
	switch ( value )
	{
		case "forced_level_1":
			if ( entity.controlLevel <= 0 )
			{
				forceRobotSoldierMindControlLevel1();
			}
			break;
		case "forced_level_2":
			if ( entity.controlLevel <= 1 )
			{
				forceRobotSoldierMindControlLevel2();
				DestructServerUtils::ToggleSpawnGibs( entity, false );
				
				if ( entity ai::get_behavior_attribute( "rogue_allow_pregib" ) )
				{
					RandomGibRogueRobot( entity );
				}
			}
			break;
		case "forced_level_3":
			if ( entity.controlLevel <= 2 )
			{
				forceRobotSoldierMindControlLevel3();
				DestructServerUtils::ToggleSpawnGibs( entity, false );
				
				if ( entity ai::get_behavior_attribute( "rogue_allow_pregib" ) )
				{
					RandomGibRogueRobot( entity );
				}
			}
			break;
	}
}

function robotMoveModeAttributeCallback( entity, attribute, oldValue, value )
{
	entity.ignorepathenemyfightdist = false;
	Blackboard::SetBlackBoardAttribute( entity, "_move_mode", "normal" );

	if ( value != "guard" )
	{
		entity.guardPosition = undefined;
	}

	switch ( value )
	{
		case "normal":
			break;
		case "rambo":
			entity.ignorepathenemyfightdist = true;
			break;
		case "marching":
			entity.ignorepathenemyfightdist = true;
			Blackboard::SetBlackBoardAttribute( entity, "_move_mode", "marching" );
			break;
		case "rusher":
			if ( !entity ai::get_behavior_attribute( "can_become_rusher" ) )
			{
				entity ai::set_behavior_attribute( "move_mode", oldValue );
			}
			break;
	}
}

function robotForceCrawler( entity, attribute, oldValue, value )
{
	if ( RobotSoldierBehavior::robotIsCrawler( entity ) )
	{
		return;
	}
	
	if ( !entity ai::get_behavior_attribute( "can_become_crawler" ) )
	{
		return;
	}

	switch ( value )
	{
		case "normal":
			return;
			break;
		case "gib_legs":
			GibServerUtils::ToggleSpawnGibs( entity, true );
			DestructServerUtils::ToggleSpawnGibs( entity, true );
			break;
		case "remove_legs":
			GibServerUtils::ToggleSpawnGibs( entity, false );
			DestructServerUtils::ToggleSpawnGibs( entity, false );
			break;
	}
	
	if ( value == "gib_legs" || value == "remove_legs" )
	{
		if ( math::cointoss() )
		{
			if ( math::cointoss() )
			{
				GibServerUtils::GibRightLeg( entity );
			}
			else
			{
				GibServerUtils::GibLeftLeg( entity );
			}
		}
		else
		{
			GibServerUtils::GibLegs( entity );
		}
		
		// Set the robot to "crawler" levels of health.
		if ( entity.health > ( entity.maxHealth * 0.25 ) )
		{
			entity.health = Int( entity.maxHealth * 0.25 );
		}
		
		DestructServerUtils::DestructRandomPieces( entity );
		
		if ( value == "gib_legs" )
		{
			BecomeCrawler( entity );
		}
		else
		{
			RobotSoldierBehavior::robotBecomeCrawler( entity );
		}
	}
}

function rogueControlForceGoalAttributeCallback( entity, attribute, oldValue, value )
{
	if ( !IsVec( value ) )
	{
		return;
	}

	rogueControlled = IsInArray( array( "level_2", "level_3" ),
		entity ai::get_behavior_attribute( "rogue_control" ) );

	if ( !rogueControlled )
	{
		entity ai::set_behavior_attribute( "rogue_control_force_goal", undefined );
	}
	else
	{
		entity.favoriteenemy = undefined;
		entity ClearPath();
		
		entity UsePosition( entity ai::get_behavior_attribute( "rogue_control_force_goal" ) );
	}
}

function rogueControlSpeedAttributeCallback( entity, attribute, oldValue, value )
{
	switch ( value )
	{
	case "walk":
		Blackboard::SetBlackBoardAttribute( entity, "_locomotion_speed", "locomotion_speed_walk" );
		break;
	case "run":
		Blackboard::SetBlackBoardAttribute( entity, "_locomotion_speed", "locomotion_speed_run" );
		break;
	case "sprint":
		Blackboard::SetBlackBoardAttribute( entity, "_locomotion_speed", "locomotion_speed_sprint" );
		break;
	}
}

function robotTraversalAttributeCallback( entity, attribute, oldValue, value )
{
	switch ( value )
	{
	case "normal":
		entity.manualTraverseMode = false;
		break;
	case "procedural":
		entity.manualTraverseMode = true;
		break;
	}
}

// end #namespace RobotSoldierServerUtils;
