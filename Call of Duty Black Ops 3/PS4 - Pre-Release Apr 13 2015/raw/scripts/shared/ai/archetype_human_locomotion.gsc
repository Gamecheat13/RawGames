// COMMON AI SYSTEMS INCLUDES
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
// ADDITIONAL INCLUDES
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                         	                                                                           	                                                                                   	       
                                                                                                                                               	
                                                              	   	                             	  	                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

function autoexec RegisterBehaviorScriptfunctions()
{	
	// ------- PREPARE FOR MOVEMENT -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareForMovement",&prepareForMovement);; 
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("prepareForMovement",&prepareForMovement);;
	
	// ------- TACTICAL WALK ARRIVE -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldTacticalArrive",&shouldTacticalArriveCondition);;
	
	// ------- SPRINT -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("humanShouldSprint",&humanShouldSprint);;
	
	// ------- ARRIVAL -----------//
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("planHumanArrivalAtCover",&planHumanArrivalAtCover);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldPlanArrivalIntoCover",&shouldPlanArrivalIntoCover);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldArriveExposed",&shouldArriveExposed);; 
	
	// ------- LOCOMOTION UPDATE -----------//
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("nonCombatLocomotionUpdate",&nonCombatLocomotionUpdate);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("combatLocomotionStart",&combatLocomotionStart);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("combatLocomotionUpdate",&combatLocomotionUpdate);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("humanNonCombatLocomotionCondition",&humanNonCombatLocomotionCondition);; 
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("humanCombatLocomotionCondition",&humanCombatLocomotionCondition);; 
	
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldSwitchToTacticalWalkFromRun",&shouldSwitchToTacticalWalkFromRun);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToStopNearEnemy",&prepareToStopNearEnemy);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("prepareToStopNearEnemy",&prepareToStopNearEnemy);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToMoveAwayFromNearByEnemy",&prepareToMoveAwayFromNearByEnemy);;		
	
	// ------- PAIN -----------//
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("BSMLocomotionHasValidPainInterrupt",&BSMLocomotionHasValidPainInterrupt);;		// only to be used by the BSM
}

// ------- PAIN -----------//
function private BSMLocomotionHasValidPainInterrupt( entity )
{
	return ( entity HasValidInterrupt("pain") );
}

function private shouldArriveExposed( behaviorTreeEntity )
{
	if( behaviorTreeEntity ai::get_behavior_attribute( "disablearrivals" ) )
		return false;
	
	if( behaviorTreeEntity HasPath() )
	{
		if( IsDefined( behaviorTreeEntity.node )
		    && IsCoverNode( behaviorTreeEntity.node )
			&& IsDefined( behaviorTreeEntity.pathGoalPos )
	    	&& DistanceSquared( behaviorTreeEntity.pathGoalPos, behaviorTreeEntity GetNodeOffsetPosition( behaviorTreeEntity.node ) ) < 8
	   	)
		{
			return false;
		}
	}
	
	return true;
}

function private prepareToStopNearEnemy( behaviorTreeEntity )
{
	behaviorTreeEntity ClearPath();
	behaviorTreeEntity.keepClaimedNode = true;
}

function private prepareToMoveAwayFromNearByEnemy( behaviorTreeEntity )
{
	behaviorTreeEntity ClearPath();
	behaviorTreeEntity.keepClaimedNode = true;
}

function private shouldPlanArrivalIntoCover( behaviorTreeEntity )
{
	goingToCoverNode = IsDefined( behaviorTreeEntity.node ) && IsCoverNode( behaviorTreeEntity.node );
	
	if( !goingToCoverNode )
		return false;
		
	if( IsDefined( behaviorTreeEntity.pathGoalPos ) )
	{
		if( IsDefined( behaviorTreeEntity.arrivalfinalpos ) )
		{
			if( behaviorTreeEntity.arrivalfinalpos != behaviorTreeEntity.pathGoalPos )
				return true;
		}
		else
		{
			return true;
		}
	}
	
	return false;
}

function private shouldSwitchToTacticalWalkFromRun( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
	{
		return false;
	}
	
	goalPos = undefined;
	
	if( IsDefined( behaviorTreeEntity.arrivalFinalPos ) )
		goalPos = behaviorTreeEntity.arrivalFinalPos;
	else
		goalPos = behaviorTreeEntity.pathGoalPos;
	
	// for moving short distances
	if( Isdefined( behaviorTreeEntity.pathStartPos ) && Isdefined( goalPos ) )
	{
		pathDist = DistanceSquared( behaviorTreeEntity.pathStartPos, goalPos );
		
		if( pathDist < 250 * 250 )
		{
			return true;
		}
	}

	return false;		
}

function private humanNonCombatLocomotionCondition( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
		return false;
		
	if( ( isdefined( behaviorTreeEntity.accurateFire ) && behaviorTreeEntity.accurateFire ) )
		return true;
	
	if( behaviorTreeEntity humanShouldSprint() )
		return true;
			
	if( IsDefined( behaviorTreeEntity.enemy ) )
		return false;
	
	return true;		
}

function private humanCombatLocomotionCondition( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
		return false;
	
	// AI's like snipers will not fire when on the move.
	if( ( isdefined( behaviorTreeEntity.accurateFire ) && behaviorTreeEntity.accurateFire ) )
		return false;
		
	if( behaviorTreeEntity humanShouldSprint() )
		return false;
		
	if( IsDefined( behaviorTreeEntity.enemy ) )
		return true;
	
	return false;
}

function private combatLocomotionStart( behaviorTreeEntity )
{
	// Choose a runNGun variation. 
	randomChance = RandomInt( 100 );
	
	if( randomChance > 50 )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_run_n_gun_variation", "variation_forward" );		
		return;
	}
	
	if( randomChance > 25 )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_run_n_gun_variation", "variation_strafe_1" );		
		return;
	}
		
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_run_n_gun_variation", "variation_strafe_2" );		
}

function private nonCombatLocomotionUpdate( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
		return false;
			
	// AI will go into CombatLocomotion, unless they are set to accurate fire or sprinting
	if( IsDefined( behaviorTreeEntity.enemy ) && ( !( isdefined( behaviorTreeEntity.accurateFire ) && behaviorTreeEntity.accurateFire ) && !behaviorTreeEntity humanShouldSprint() ) )
		return false;	
	
	if( !behaviorTreeEntity ASMIsTransitionRunning() )
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_stance", "stand" );		
		
	return true;		
}

function private combatLocomotionUpdate( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
		return false;
	
	if( behaviorTreeEntity humanShouldSprint() )
		return false;
	
	if( !behaviorTreeEntity ASMIsTransitionRunning() )
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_stance", "stand" );		
		
	if( IsDefined( behaviorTreeEntity.enemy ) )
		return true;
	
	return false;
}


// ------- PREPARE FOR MOVEMENT -----------//
function private prepareForMovement( behaviorTreeEntity )
{	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_stance", "stand" );		
	
	return true;
}

// ------- TACTICAL WALK ARRIVE -----------//

// Here's how the arrival angles look relative to the cover node x, with the direction
// numbers on the outside
//	   7			8			   9			
//
//			45		0		315
//			
//	   4	90		x		270    6
//					
//			135	   180		225
//
//	   1			2			   3

function private isArrivingFour( arrivalAngle )
{
	if ( arrivalAngle >= 45 && arrivalAngle <= 120 )
	{
		return true;
	}
	return false;
}

function private isArrivingOne( arrivalAngle )
{
	if ( arrivalAngle >= 120 && arrivalAngle <= 165 )
	{
		return true;
	}
	return false;
}

function private isArrivingTwo( arrivalAngle )
{
	if ( arrivalAngle >= 165 && arrivalAngle <= 195 )
	{
		return true;
	}
	return false;
}

function private isArrivingThree( arrivalAngle )
{
	if ( arrivalAngle >= 195 && arrivalAngle <= 240 )
	{
		return true;
	}
	return false;
}

function private isArrivingSix( arrivalAngle )
{
	if ( arrivalAngle >= 240 && arrivalAngle <= 315 )
	{
		return true;
	}
	return false;
}

// Here's how the facing angles look relative to the player x, with the direction
// numbers on the outside
//	  7			    8		        9
//								
//			45		0		-45
//			
//	  4 	90		x		-90	    6
//					
//			135	 180/-180	-135
//
//	  1			    2			    3

function private isFacingFour( facingAngle )
{
	if ( facingAngle >= 45 && facingAngle <= 135 )
	{
		return true;
	}
	return false;
}

function private isFacingEight( facingAngle )
{
	if ( facingAngle >= -45 && facingAngle <= 45 )
	{
		return true;
	}
	return false;
}

function private isFacingSeven( facingAngle )
{
	if ( facingAngle >= 0 && facingAngle <= 90 )
	{
		return true;
	}
	return false;
}

function private isFacingSix( facingAngle )
{
	if ( facingAngle >= -135 && facingAngle <= -45 )
	{
		return true;
	}
	return false;
}

function private isFacingNine( facingAngle )
{
	if ( facingAngle >= -90 && facingAngle <= 0 )
	{
		return true;
	}
	return false;
}





function private shouldTacticalArriveCondition( behaviorTreeEntity )
{
	// TEMP: Alden Higgins 7-30-2014 don't tactical arrive unless dvar is set
	if ( getDvarInt("enableTacticalArrival") != 1 )
	{
		return false;
	}
	
	// Check if behaviorTreeEntity has a cover node as a goal
	if ( !IsDefined( behaviorTreeEntity.node ) )
	{
		return false;
	}
	
	// TEMP: Alden Higgins 7-31-2014 Temporary check cover node type as new tactical arrival animations are added
	if ( !(behaviorTreeEntity.node.type == "Cover Left")
//	    && !NODE_COVER_RIGHT( behaviorTreeEntity.node )
//	    && !NODE_COVER_STAND( behaviorTreeEntity.node )
//	    && !NODE_COVER_CROUCH( behaviorTreeEntity.node )
	)
	{
		return false;
	}
	
	// TEMP: Alden Higgins 8-5-2014 Temporary check cover node stance as well
	stance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_arrival_stance" );
	if ( stance != "stand" )
	{
		return false;
	}
	
	arrivalDistance = 35;
	/#
	// Can be used for testing purposes to see if an animation works better from a different distance
	arrivalDvar = getDvarInt( "tacArrivalDistance" );
	if ( arrivalDvar != 0 )
	{
		arrivalDistance = arrivalDvar;
	}
	#/
	
	nodeOffsetPosition = behaviorTreeEntity GetNodeOffsetPosition( behaviorTreeEntity.node );

	if ( Distance( nodeOffsetPosition, behaviorTreeEntity.origin ) > arrivalDistance ||
	    Distance( nodeOffsetPosition, behaviorTreeEntity.origin ) < 25 )
	{
		return false;
	}

	// If the player is entering from an angle less than minimumTacArrivalAngle degrees away from the cover node's forward angles
	// then don't tactically arrive...here's a diagram where x is the cover node, the dashes are the cover's geo, and the angles
	// are the differences from the node's forward that we are checking:
	//
	//				45	25	0	25	45
	//				60				60
	//					  -----		
	//				90		x		90
	//
	//				135	   180		135
	//				
	entityAngles = VectorToAngles( behaviorTreeEntity.origin - nodeOffsetPosition );
	if ( abs( behaviorTreeEntity.node.angles[ 1 ] - entityAngles[ 1 ] ) < 60 )
	{
		return false;
	}
	
	tacticalFaceAngle = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_tactical_arrival_facing_yaw" );
	arrivalAngle = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_locomotion_arrival_yaw" );
	// Check and make sure the player is facing the right way depending on the the angle they arrive at in order to play a tactical arrival
	if ( isArrivingFour( arrivalAngle ) )
	{
		if ( !isFacingSix( tacticalFaceAngle ) && !isFacingEight( tacticalFaceAngle ) && !isFacingFour( tacticalFaceAngle ) )
		{
			return false;
		}
	}
	else if ( isArrivingOne( arrivalAngle ) )
	{
		if ( !isFacingNine( tacticalFaceAngle ) && !isFacingSeven( tacticalFaceAngle ) )
		{
			return false;
		}
	}
	else if ( isArrivingTwo( arrivalAngle ) )
	{
		if ( !isFacingEight( tacticalFaceAngle ) )
		{
			return false;
		}
	}
	else if ( isArrivingThree( arrivalAngle ) )
	{
		if ( !isFacingSeven( tacticalFaceAngle ) && !isFacingNine( tacticalFaceAngle ) )
		{
			return false;
		}
	}
	else if ( isArrivingSix( arrivalAngle ) )
	{
		if ( !isFacingFour( tacticalFaceAngle ) && !isFacingEight( tacticalFaceAngle ) && !isFacingSix( tacticalFaceAngle ) )
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	return true;
}

// ------- SPRINT -----------//
function private humanShouldSprint()
{
	currentLocoMovementType = Blackboard::GetBlackBoardAttribute( self, "_human_locomotion_movement_type" );
	
	return ( currentLocoMovementType == "human_locomotion_movement_sprint" );
}

// ------- ARRIVAL PLANNER -----------//
function private planHumanArrivalAtCover( behaviorTreeEntity, arrivalAnim )
{
	if( behaviorTreeEntity ai::get_behavior_attribute( "disablearrivals" ) )
		return false;
	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
	
	if( !IsDefined( arrivalAnim ) )
		return false;
	
	if( IsDefined( behaviorTreeEntity.node ) && IsDefined( behaviorTreeEntity.pathGoalPos ) )
	{
		if( !IsCoverNode( behaviorTreeEntity.node ) )
		{
			return false;
		}
		
		nodeOffsetPosition = behaviorTreeEntity GetNodeOffsetPosition( behaviorTreeEntity.node );
			
		if( nodeOffsetPosition != behaviorTreeEntity.pathGoalPos )
		{
			return false;
		}
	
		if( IsDefined( arrivalAnim ) )
		{			
			isRight = (behaviorTreeEntity.node.type == "Cover Right");
			splitTime = GetArrivalSplitTime( arrivalAnim, isRight );
			isSplitArrival = ( splitTime < 1 );
				
			nodeApproachYaw = behaviorTreeEntity GetNodeOffsetAngles( behaviorTreeEntity.node )[1];
			
			angle = (0, nodeApproachYaw - GetAngleDelta( arrivalAnim ), 0);
			
			if( isSplitArrival )
			{					
				forwardDir = AnglesToForward( angle );
				rightDir = AnglesToRight( angle );
								
				// TODO(David Young 2-25-15): This assumes a blend out of 0.2 seconds.
				animLength = GetAnimLength( arrivalAnim );
				moveDelta = GetMoveDelta( arrivalAnim, 0, (animLength - 0.2) / animLength );
				preMoveDelta = GetMoveDelta( arrivalAnim, 0, splitTime );
				postMoveDelta = moveDelta - preMoveDelta;
							
				// post delta
				forward			   = VectorScale( forwardDir, postMoveDelta[0] );
				right			   = VectorScale( rightDir, postMoveDelta[1] );
				coverEnterPos      = nodeOffsetPosition - forward + right;
				postEnterPos 	   = coverEnterPos;
								
				// pre delta
				forward			   = VectorScale( forwardDir, preMoveDelta[0] );
				right			   = VectorScale( rightDir, preMoveDelta[1] );
				coverEnterPos      = coverEnterPos - forward + right;
				
				if( !behaviorTreeEntity MayMoveFromPointToPoint( postEnterPos, nodeOffsetPosition, true ) )
				{
					return false;
				}
				
				if( !behaviorTreeEntity MayMoveFromPointToPoint( coverEnterPos, postEnterPos, true ) )
				{
					return false;
				}
			}
			else	
			{
				forwardDir = AnglesToForward( angle );
				rightDir = AnglesToRight( angle );
			
				moveDeltaArray	   = GetMoveDelta( arrivalAnim );
				forward			   = VectorScale( forwardDir, moveDeltaArray[0] );
				right			   = VectorScale( rightDir, moveDeltaArray[1] );
				coverEnterPos      = nodeOffsetPosition - forward + right;			
				
				if( !behaviorTreeEntity MayMoveFromPointToPoint( coverEnterPos, nodeOffsetPosition, true ) )
				{
					return false;				  
				}
			}
			
			if( !checkCoverArrivalConditions( coverEnterPos, nodeOffsetPosition ) )
			{
				return false;
			}
								
			// Make sure the arrival pos is clear
			if( IsPointOnMesh( coverEnterPos, behaviorTreeEntity ) && self FindPath( behaviorTreeEntity.origin, coverEnterPos, true, false ) )
			{
				/# RecordCircle( coverEnterPos, 2, (1,0,0), "Script", self ); #/
				self UsePosition( coverEnterPos, behaviorTreeEntity.pathGoalPos );
				return true;
			}			
		}
	}
	
	return false;
}

function private checkCoverArrivalConditions( coverEnterPos, coverPos )
{
	distSqToNode = DistanceSquared( self.origin, coverPos );
	distSqFromNodeToEnterPos = DistanceSquared( coverPos, coverEnterPos );
			
	// check if the AI is enough distance away from the coverEnterPos
	awayFromEnterPos = distSqToNode >= ( distSqFromNodeToEnterPos + 150 );
	
	if( !awayFromEnterPos )
		return false;
	
	return true;	
}

// TODO - This function is very expensive, 
// we need to have cover_split notetrack in all the arrival/exit animations wherever there is a split.
function private GetArrivalSplitTime( arrivalAnim, isright )
{
	if ( !isdefined( level.animArrivalSplitTimes ) )
	{
		level.animArrivalSplitTimes = [];
	}
	
	if ( isdefined( level.animArrivalSplitTimes[arrivalAnim] ) )
	{
		return level.animArrivalSplitTimes[arrivalAnim];
	}

	bestsplit = -1;
	
	if( AnimHasNotetrack( arrivalAnim, "cover_split" ) )
	{
		times = GetNotetrackTimes( arrivalAnim, "cover_split" );
		Assert( times.size > 0 );
		bestsplit = times[0];			
	}
	else
	{
		// TODO(David Young 2-25-15): Hardcoded assumption of 0.2 blendout.
		animLength = GetAnimLength( arrivalAnim );
		normalizedLength = (animLength - 0.2) / animLength;
		
		angleDelta = getAngleDelta( arrivalAnim, 0, normalizedLength );
		fullDelta = getMoveDelta( arrivalAnim, 0, normalizedLength );
		const numiter = 100;
			
		bestvalue = -100000000;
	
		for ( i = 0; i < numiter; i++ )
		{
			splitTime = 1.0 * i / (numiter - 1);
			
			delta = getMoveDelta( arrivalAnim, 0, splitTime );
			delta = DeltaRotate( fullDelta - delta, 180 - angleDelta );
			
			if ( isright )
				delta = ( delta[0], 0 - delta[1], delta[2] );
				
			val = min( delta[0] - 32, delta[1] );
			
			if ( val > bestvalue || bestsplit < 0 )
			{
				bestvalue = val;
				bestsplit = splitTime;
			}
		}
	}
	
	level.animArrivalSplitTimes[arrivalAnim] = bestsplit;

	return bestsplit;
}

function private DeltaRotate( delta, yaw )
{
	cosine = cos( yaw );
	sine = sin( yaw );
	return ( delta[0] * cosine - delta[1] * sine, delta[1] * cosine + delta[0] * sine, 0);
}
