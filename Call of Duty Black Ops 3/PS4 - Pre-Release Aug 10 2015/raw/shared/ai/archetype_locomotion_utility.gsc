#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\math_shared;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                         	                                                                           	                                                                                   	       
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                  	                             	  	                                      
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace AiUtility;

// Use this utility if AI moves around using pathfinding should not be archetype dependent at all
// SUMEET TODO - add cover specific blackboard variables here.

function autoexec RegisterBehaviorScriptFunctions()
{	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionBehaviorCondition",&locomotionBehaviorCondition);; 
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionBehaviorCondition",&locomotionBehaviorCondition);; 
		
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("nonCombatLocomotionCondition",&nonCombatLocomotionCondition);; 
			
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setDesiredStanceForMovement",&setDesiredStanceForMovement);; 
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("clearPathFromScript",&clearPathFromScript);; 
	
	// ------- PATROL -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionShouldPatrol",&locomotionShouldPatrol);; 
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldPatrol",&locomotionShouldPatrol);; 
	
	// ------- TACTICAL WALK -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldTacticalWalk",&AiUtility::shouldTacticalWalk);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldTacticalWalk",&AiUtility::shouldTacticalWalk);;
		
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldAdjustStanceAtTacticalWalk",&shouldAdjustStanceAtTacticalWalk);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("adjustStanceToFaceEnemyInitialize",&adjustStanceToFaceEnemyInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("adjustStanceToFaceEnemyTerminate",&adjustStanceToFaceEnemyTerminate);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tacticalWalkActionStart",&tacticalWalkActionStart);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("tacticalWalkActionStart",&tacticalWalkActionStart);;
	
	// ------- ARRIVAL -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("clearArrivalPos",&clearArrivalPos);; 
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("clearArrivalPos",&clearArrivalPos);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStartArrival",&shouldStartArrivalCondition);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldStartArrival",&shouldStartArrivalCondition);;
		
	// ------- TRAVERSAL -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionShouldTraverse",&locomotionShouldTraverse);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldTraverse",&locomotionShouldTraverse);; 
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("traverseActionStart",&traverseActionStart,undefined,undefined);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("traverseSetup",&traverseSetup);; 
	
	// ------- JUKE -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canJuke",&canJuke);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseJukeDirection",&chooseJukeDirection);;
	
	// ------- PAIN -----------//
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionPainBehaviorCondition",&locomotionPainBehaviorCondition);; 
	
	// ------- STAIRS -----------//
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionIsOnStairs",&locomotionIsOnStairs);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldLoopOnStairs",&locomotionShouldLoopOnStairs);;		
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldSkipStairs",&locomotionShouldSkipStairs);;		
	
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionStairsStart",&locomotionStairsStart);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionStairsEnd",&locomotionStairsEnd);;
	
}

// ------- STAIRS -----------//
function private locomotionIsOnStairs( behaviorTreeEntity )
{
	startNode = behaviorTreeEntity.traverseStartNode;
	if ( IsDefined( startNode ) && behaviorTreeEntity ShouldStartTraversal() )
	{
		if( IsDefined( startNode.animscript ) && IsSubStr( ToLower( startNode.animscript ), "stairs" ) )
			return true;
	}

	return false;
}

function private locomotionShouldSkipStairs( behaviorTreeEntity )
{	
	assert( IsDefined( behaviorTreeEntity._stairsStartNode ) && IsDefined( behaviorTreeEntity._stairsEndNode ) );

	numTotalSteps 	= Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_staircase_num_total_steps" );
	stepsSoFar 		= Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_staircase_num_steps" );
	
	direction	 	= Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_staircase_direction" );
	
	if( direction != "staircase_up" )
	{
		return false;
	}
	
	numOutSteps	= 2;
	totalStepsWithoutOut = numTotalSteps - numOutSteps;
	
	if( stepsSoFar >= ( totalStepsWithoutOut ) )
	{
		return false;
	}
	
	remainingSteps = totalStepsWithoutOut - stepsSoFar;
	
	if( remainingSteps >=3 || remainingSteps >= 6 || remainingSteps >= 8 )
	{
		return true;
	}
	
	return false;
}

function private locomotionShouldLoopOnStairs( behaviorTreeEntity )
{
	assert( IsDefined( behaviorTreeEntity._stairsStartNode ) && IsDefined( behaviorTreeEntity._stairsEndNode ) );

	numTotalSteps 	= Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_staircase_num_total_steps" );
	stepsSoFar 		= Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_staircase_num_steps" );
	exitType		= Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_staircase_exit_type" );
	direction	 	= Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_staircase_direction" );
	
	numOutSteps	= 2; // 2 steps out unless we are going up
	if( direction == "staircase_up" )
	{
		switch( exitType )
		{
		case "staircase_up_exit_l_3_stairs":
		case "staircase_up_exit_r_3_stairs":
			numOutSteps = 3;
			break;
		case "staircase_up_exit_l_4_stairs":
		case "staircase_up_exit_r_4_stairs":
			numOutSteps = 4;
			break;
		}
	}
	
	if( stepsSoFar >= ( numTotalSteps - numOutSteps ) )
	{
		behaviorTreeEntity SetStairsExitTransform();
		return false;
	}
	
	return true;
}

function private locomotionStairsStart( behaviorTreeEntity )
{
	startNode = behaviorTreeEntity.traverseStartNode;
	endNode	  = behaviorTreeEntity.traverseEndNode;
	
	assert( IsDefined( startNode ) && IsDefined( endNode ) );
	
	behaviorTreeEntity._stairsStartNode = startNode;
	behaviorTreeEntity._stairsEndNode	= endNode;
	
	if( startNode.type == "Begin" )
		direction = "staircase_down";
	else
		direction = "staircase_up";
		
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_type", behaviorTreeEntity._stairsStartNode.animscript );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_state", "staircase_start" );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_direction", direction );	
	
	numTotalSteps = undefined;
	
	if( IsDefined( startNode.script_int ) )
	{
		numTotalSteps = int( endNode.script_int );
	}
	else if( IsDefined( endNode.script_int ) )
	{
		numTotalSteps = int( endNode.script_int );
	}
	
	// Set total number of steps
	assert( IsDefined( numTotalSteps ) && IsInt( numTotalSteps ) && numTotalSteps > 0 );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_num_total_steps", numTotalSteps );
	
	// so far, we have not taken any steps
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_num_steps", 0 );

	exitType = undefined;
	if ( direction == "staircase_up" )
	{
		switch( int( behaviorTreeEntity._stairsStartNode.script_int ) % 4 )
		{
		case 0:	exitType = "staircase_up_exit_r_3_stairs";	break;
		case 1:	exitType = "staircase_up_exit_r_4_stairs";	break;
		case 2:	exitType = "staircase_up_exit_l_3_stairs";	break;
		case 3:	exitType = "staircase_up_exit_l_4_stairs";	break;
		}
	}
	else
	{
		switch( int( behaviorTreeEntity._stairsStartNode.script_int ) % 2 )
		{
		case 0:	exitType = "staircase_down_exit_l_2_stairs";	break;
		case 1:	exitType = "staircase_down_exit_r_2_stairs";	break;
		}
	}
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_exit_type", exitType );

	return true;
}

function private locomotionStairLoopStart( behaviorTreeEntity )
{
	assert( IsDefined( behaviorTreeEntity._stairsStartNode ) && IsDefined( behaviorTreeEntity._stairsEndNode ) );
			
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_state", "staircase_loop" );
}

function private locomotionStairsEnd( behaviorTreeEntity )
{		
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_state", undefined );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_staircase_direction", undefined );	
}

// ------- PAIN -----------//
function private locomotionPainBehaviorCondition( entity )
{
	return ( entity HasPath() && entity HasValidInterrupt("pain") );
}

function clearPathFromScript( behaviorTreeEntity )
{
	behaviorTreeEntity ClearPath();
}

function private nonCombatLocomotionCondition( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
		return false;
		
	if( ( isdefined( behaviorTreeEntity.accurateFire ) && behaviorTreeEntity.accurateFire ) )
		return true;
		
			
	if( IsDefined( behaviorTreeEntity.enemy ) )
		return false;
	
	return true;		
}

function private combatLocomotionCondition( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
		return false;
	
	// AI's like snipers will not fire when on the move.
	if( ( isdefined( behaviorTreeEntity.accurateFire ) && behaviorTreeEntity.accurateFire ) )
		return false;
	
	
		
	if( IsDefined( behaviorTreeEntity.enemy ) )
		return true;
	
	return false;
}

function locomotionBehaviorCondition( behaviorTreeEntity )
{		
	return behaviorTreeEntity HasPath();
}

function private setDesiredStanceForMovement( behaviorTreeEntity )
{	
	if( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" ) != "stand" )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
	}
}

// ------- TRAVERSAL -----------//
function private locomotionShouldTraverse( behaviorTreeEntity )
{
	startNode = behaviorTreeEntity.traverseStartNode;
	if ( IsDefined( startNode ) && behaviorTreeEntity ShouldStartTraversal() )
	{
		return true;
	}

	return false;
}

function private traverseSetup( behaviorTreeEntity )
{
	// TODO(David Young 7-25-14): This is really weird that we have to set the stance before taking a traversal.
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_stance", "stand" );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_traversal_type", behaviorTreeEntity.traverseStartNode.animscript );
	
	return true;
}

function traverseActionStart( behaviorTreeEntity, asmStateName )
{
	traverseSetup( behaviorTreeEntity );
	
	/#
	// Assert if no animation is found for the given traversal.
	animationResults = behaviorTreeEntity ASTSearch( IString( asmStateName ) );
	
	assert( IsDefined( animationResults[ "animation" ] ), 
	       behaviorTreeEntity.archetype 
	       + " does not support traversal of type "
	       + behaviorTreeEntity.traverseStartNode.animscript 
	       + " \n@"
		   + behaviorTreeEntity.traverseStartNode.origin
		   + "\n"
	      );
	#/
		
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	return 5;
}

// ------- ARRIVAL BEHAVIOR -----------//
function shouldStartArrivalCondition( behaviorTreeEntity )
{
	if( behaviorTreeEntity ShouldStartArrival() )
		return true;
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: ClearArrivalPos \n"
"Summary: Clear arrival planning to a cover.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function clearArrivalPos( behaviorTreeEntity )
{
	// TODO(David Young 7-13-15): Default to clearing the path, until new executables post and "isarrivalpending" is available to script.
	if ( !IsDefined( behaviorTreeEntity.isarrivalpending ) || ( isdefined( behaviorTreeEntity.isarrivalpending ) && behaviorTreeEntity.isarrivalpending ) )
	{
		self ClearUsePosition();
	}
	
	return true;
}

// ------- LOCOMOTION - TACTICAL WALK -----------//	
function private shouldAdjustStanceAtTacticalWalk( behaviorTreeEntity )
{
	stance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	if( stance != "stand" )
	{
		return true;
	}

	return false;
}

function private adjustStanceToFaceEnemyInitialize( behaviorTreeEntity )
{
	// AI's standing up out of cover should not play a reaction.
	behaviorTreeEntity.newEnemyReaction = false;
	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
	behaviorTreeEntity OrientMode( "face enemy" );	
	
	return true;
}

function private adjustStanceToFaceEnemyTerminate( behaviorTreeEntity )
{
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_stance", "stand" );
}

function private tacticalWalkActionStart( behaviorTreeEntity )
{	
	AiUtility::clearArrivalPos( behaviorTreeEntity );
	
	AiUtility::resetCoverParameters( behaviorTreeEntity );
	AiUtility::setCanBeFlanked( behaviorTreeEntity, false );
	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_stance", "stand" );		
	behaviorTreeEntity OrientMode( "face enemy" );	
	
	return true;
}

// ------- LOCOMOTION - JUKE -----------//	

function private validJukeDirection( entity, entityNavMeshPosition, forwardOffset, lateralOffset )
{
 	jukeNavmeshThreshold = 6;
	
 	forwardPosition = entity.origin + lateralOffset + forwardOffset;
 	backwardPosition = entity.origin + lateralOffset - forwardOffset;
	
	forwardPositionValid = IsPointOnNavMesh( forwardPosition, entity ) && TracePassedOnNavMesh( entity.origin, forwardPosition );
	backwardPositionValid = IsPointOnNavMesh( backwardPosition, entity ) && TracePassedOnNavMesh( entity.origin, backwardPosition );
	
	if ( !IsDefined( entity.ignoreBackwardPosition ) )
	{
		return forwardPositionValid && backwardPositionValid;
	}
	else
	{
		return forwardPositionValid;
	}
	
	return false;
}

function calculateJukeDirection( entity, entityRadius, jukeDistance )
{
	jukeNavmeshThreshold = 6;
	defaultDirection = "forward";

	if ( IsDefined( entity.defaultJukeDirection ) )
    {
    	defaultDirection = entity.defaultJukeDirection;
    }
	
	if ( IsDefined( entity.enemy ) )
	{
		navmeshPosition = GetClosestPointOnNavMesh( entity.origin, jukeNavmeshThreshold );

		if ( !IsVec( navmeshPosition ) )
		{
			return defaultDirection;
		}

		vectorToEnemy = entity.enemy.origin - entity.origin;
		vectorToEnemyAngles = VectorToAngles( vectorToEnemy );
		forwardDistance = AnglesToForward( vectorToEnemyAngles ) * entityRadius;
		rightJukeDistance = AnglesToRight( vectorToEnemyAngles ) * jukeDistance;
		
		preferLeft = undefined;
		
		if ( entity HasPath() )
		{
			// Juke closer to the path goal position.
			rightPosition = entity.origin + rightJukeDistance;
			leftPosition = entity.origin - rightJukeDistance;
			
			preferLeft = DistanceSquared( leftPosition, entity.pathgoalpos ) <=
				DistanceSquared( rightPosition, entity.pathgoalpos );
		}
		else
		{
			preferLeft = math::cointoss();
		}

		if ( preferLeft )
		{
			if ( validJukeDirection( entity, navmeshPosition, forwardDistance, -rightJukeDistance ) )
			{
				return "left";
			}
			else if ( validJukeDirection( entity, navmeshPosition, forwardDistance, rightJukeDistance ) )
			{
				return "right";
			}
		}
		else
		{
			if ( validJukeDirection( entity, navmeshPosition, forwardDistance, rightJukeDistance ) )
			{
				return "right";
			}
			else if ( validJukeDirection( entity, navmeshPosition, forwardDistance, -rightJukeDistance ) )
			{
				return "left";
			}
		}
	}

	return defaultDirection;
}

function private calculateDefaultJukeDirection( entity )
{
	jukeDistance = 30;
	entityRadius = 15;
	
	if ( IsDefined( entity.jukeDistance ) )
	{
		jukeDistance = entity.jukeDistance;
	}
	
	if ( IsDefined( entity.entityRadius ) )
	{
		entityRadius = entity.entityRadius;
	}
	
	return AiUtility::calculateJukeDirection( entity, entityRadius, jukeDistance );
}

function canJuke( entity )
{
	// Don't juke if the enemy is too far away.
	if (( isdefined( self.is_disabled ) && self.is_disabled ))
		return false;
		
	
	if ( IsDefined( entity.jukeMaxDistance ) && IsDefined( entity.enemy ) )
	{
		maxDistSquared = entity.jukeMaxDistance * entity.jukeMaxDistance;
		
		if ( Distance2DSquared( entity.origin, entity.enemy.origin ) > maxDistSquared )
		{
			return false;
		}
	}

	jukeDirection =
		AiUtility::calculateDefaultJukeDirection( entity );

	return jukeDirection != "forward";
}

function chooseJukeDirection( entity )
{
	jukeDirection =
		AiUtility::calculateDefaultJukeDirection( entity );

	Blackboard::SetBlackBoardAttribute( entity, "_juke_direction", jukeDirection );
}
