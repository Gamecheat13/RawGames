// COMMON AI SYSTEMS INCLUDES
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	

// ADDITIONAL INCLUDES
#using scripts\shared\ai\archetype_utility; 
#using scripts\shared\ai\archetype_cover_utility; 
#using scripts\shared\array_shared;

                                                              	   	                             	  	                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

function autoexec RegisterBehaviorScriptfunctions()
{	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldReturnToCoverCondition",&shouldReturnToCoverCondition);;
			
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldAdjustToCover",&shouldAdjustToCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareForAdjustToCover",&prepareForAdjustToCover);;
			
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverBlindfireShootStart",&coverBlindfireShootActionStart);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canChangeStanceAtCoverCondition",&canChangeStanceAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverChangeStanceActionStart",&coverChangeStanceActionStart);;
		
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToChangeStanceToStand",&prepareToChangeStanceToStand);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanUpChangeStanceToStand",&cleanUpChangeStanceToStand);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldVantageAtCoverCondition",&shouldVantageAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsVantageCoverCondition",&supportsVantageCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverVantageInitialize",&coverVantageInitialize);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldThrowGrenadeAtCoverCondition",&shouldThrowGrenadeAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverPrepareToThrowGrenade",&coverPrepareToThrowGrenade);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverCleanUpToThrowGrenade",&coverCleanUpToThrowGrenade);;
}

// TODO(David Young 9-29-14): This is a temp workaround.  Made the function public so human notetracks
// can do a check before throwing a grenade to fix a SRE.
function shouldThrowGrenadeAtCoverCondition( behaviorTreeEntity )
{		
	if( !IsDefined(  behaviorTreeEntity.enemy ) )
	{
		return false;
	}
	
	// if there was a grenade that was thrown at the enemy recently, then dont throw it again
	grenadeThrowInfos = Blackboard::GetBlackboardEvents( "human_grenade_throw" );
	
	foreach ( grenadeThrowInfo in grenadeThrowInfos )
	{
		if( IsDefined( grenadeThrowInfo.grendadeThrownAt ) && IsAlive( grenadeThrowInfo.grendadeThrownAt ) )
		{
			if( grenadeThrowInfo.grendadeThrownAt == behaviorTreeEntity.enemy )
			{
				return false;
			}
		}
	}
	
	throw_dist = Distance2DSquared( behaviorTreeEntity.origin, behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy ) );
	if ( throw_dist < ( (500) * (500) ) || throw_dist > ( (1250) * (1250) ) )
	{
		return false;
	}
	
	arm_offset = TEMP_get_arm_offset( behaviorTreeEntity );
	throw_vel = behaviorTreeEntity CanThrowGrenadePos( arm_offset, behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy ) );

	if ( !IsDefined( throw_vel ) )
	{
		return false;
	}
	
	return true;
}

function private coverPrepareToThrowGrenade( behaviorTreeEntity )
{	
	grenadeThrowInfo = SpawnStruct();
	grenadeThrowInfo.grenadeThrower = behaviorTreeEntity;
	grenadeThrowInfo.grendadeThrownAt = behaviorTreeEntity.enemy;	
	Blackboard::AddBlackboardEvent( "human_grenade_throw", grenadeThrowInfo, RandomIntRange( 5000, 7500 ) );
	
	AiUtility::keepClaimedNodeAndChooseCoverDirection( behaviorTreeEntity );
}

function private coverCleanUpToThrowGrenade( behaviorTreeEntity )
{
	AiUtility::resetCoverParameters( behaviorTreeEntity );
}

function private canChangeStanceAtCoverCondition( behaviorTreeEntity )
{
	switch ( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" ) )
	{
		case "stand":
			return AiUtility::isStanceAllowedAtNode( "crouch", behaviorTreeEntity.node );
		case "crouch":
			return AiUtility::isStanceAllowedAtNode( "stand", behaviorTreeEntity.node );
	}
	
	return false;
}

function private shouldReturnToCoverCondition( behaviorTreeEntity )
{
	if ( behaviorTreeEntity ASMIsTransitionRunning() )
	{
		return false;
	}

	if ( !IsDefined( behaviorTreeEntity.enemy ) )
	{
		return true;
	}
	
	if ( IsDefined( behaviorTreeEntity.coverShootStartTime ) )
	{
		// take a few shots before returning
		if ( GetTime() < behaviorTreeEntity.coverShootStartTime + 800 )
		{
			return false;
		}

		// try to finish off enemy
		if ( IsPlayer( behaviorTreeEntity.enemy ) && behaviorTreeEntity.enemy.health < behaviorTreeEntity.enemy.maxHealth * 0.5 )
		{
			if ( GetTime() < behaviorTreeEntity.coverShootStartTime + 3000 )
			{
				return false;
			}
		}
	}
	
	if ( AiUtility::isSuppressedAtCoverCondition( behaviorTreeEntity ) )
	{
		return true;
	}

	return false;
}

function private shouldAdjustToCover( behaviorTreeEntity ) 
{
	if( !IsDefined( behaviorTreeEntity.node ) )
	{
		return false;
	}
	
	// if the current stance is crouch, and highest supported stance for the node is crouch too then, 
	// there are no animations for that. Just do a pure animation blend.
	highestSupportedStance = AiUtility::getHighestNodeStance( behaviorTreeEntity.node );
	currentStance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	
	if( currentStance == "crouch" && highestSupportedStance == "crouch" )
	{
		return false;
	}
	
	// if AI has just arrived at this cover node ( meaning previousCoverMode != COVER_ALERT_MODE )
	// That means he needs to adjust to the cover for the first time
	coverMode = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode" );
	previousCoverMode = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_previous_cover_mode" );

	if ( coverMode != "cover_alert" && previousCoverMode != "cover_alert" && !behaviorTreeEntity.keepClaimedNode )
	{		
		return true;
	}

	// if somehow the AI is at the covernode with appropriate COVER_MODE, but unsupported stance, then 
	// let him adjust to the cover node.
	if( !AiUtility::isStanceAllowedAtNode( currentStance, behaviorTreeEntity.node ) )
	{
		return true;
	}
	
	return false;
}


// ------- COVER - VANTAGE SHOOT BEHAVIOR -----------//
// TODO - Fix and enable vantage behavior.
function private shouldVantageAtCoverCondition( behaviorTreeEntity )
{
	if( !IsDefined( behaviorTreeEntity.node ) ||
		!IsDefined( behaviorTreeEntity.node.type ) ||
		!IsDefined( behaviorTreeEntity.enemy) ||
		!IsDefined( behaviorTreeEntity.enemy.origin ) )
	{
		return false;
	}
		
	yawToEnemyPosition = AiUtility::GetAimYawToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
	pitchToEnemyPosition = AiUtility::GetAimPitchToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
	aimLimitsForCover = behaviortreeentity GetAimLimitsFromEntry("cover_vantage");
	
	legalAim = false;

	// allow vantage aiming if our target is within the 25 to 85 degree arc in front of us and 3 or more feet below us
	if ( yawToEnemyPosition < aimLimitsForCover["aim_left"] &&
		 yawToEnemyPosition > aimLimitsForCover["aim_right"] &&
		 pitchToEnemyPosition < 85.0 &&
		 pitchToEnemyPosition > 25.0 &&
		 ( behaviorTreeEntity.node.origin[2] - behaviorTreeEntity.enemy.origin[2] ) >= ( 3 * 12 ) )
	{
		legalAim = true;
	}

	return legalAim;
}

function private supportsVantageCoverCondition( behaviorTreeEntity )
{
	return false;
	
	/*
	coverMode = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, COVER_MODE );
	
	if ( IsDefined( behaviorTreeEntity.node ) && IsDefined( coverMode ) && coverMode == COVER_ALERT_MODE )
	{
		if( NODE_COVER_CROUCH( behaviorTreeEntity.node ) || NODE_COVER_STAND( behaviorTreeEntity.node ) )
		{
			return true;
		}			
	}
	
	return false;
	*/
}

function private coverVantageInitialize( behaviorTreeEntity, asmStateName )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_vantage" );
}
	
// ------- COVER - BLINDFIRE SHOOT BEHAVIOR -----------//
function private coverBlindfireShootActionStart( behaviorTreeEntity, asmStateName )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_blind" );
	AiUtility::chooseCoverDirection( behaviorTreeEntity );
}

// ------- COVER - CHANGE STANCE BEHAVIOR -----------//
function private prepareToChangeStanceToStand( behaviorTreeEntity, asmStateName )
{
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
}

function private cleanUpChangeStanceToStand( behaviorTreeEntity, asmStateName )
{
	AiUtility::releaseClaimNode( behaviorTreeEntity );
	behaviorTreeEntity.newEnemyReaction = false;
}

// ------- COVER - ADJUST STANCE BEHAVIOR -----------//
function private prepareForAdjustToCover( behaviorTreeEntity, asmStateName )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );
	
	highestSupportedStance = AiUtility::getHighestNodeStance( behaviorTreeEntity.node );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", highestSupportedStance );
}

// ------- COVER - CHANGE STANCE BEHAVIOR -----------
function private coverChangeStanceActionStart( behaviorTreeEntity, asmStateName )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );

	switch ( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" ) )
	{
		case "stand":
			Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "crouch" );
			break;
		case "crouch":
			Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
			break;
	}
}

function private TEMP_get_arm_offset( behaviorTreeEntity )
{
	arm_offset = ( 0, 0, 64 );

	if( IsDefined( behaviorTreeEntity.node ) )
	{
		if( (behaviorTreeEntity.node.type == "Cover Left") )
		{
			arm_offset = ( 24, -21, 30 );
		}
		else if( (behaviorTreeEntity.node.type == "Cover Right") )
		{
			arm_offset = ( 21, 17, 35 );
		}
		else if( (behaviorTreeEntity.node.type == "Cover Stand" || behaviorTreeEntity.node.type == "Conceal Stand") )
		{
			arm_offset = ( 10, 7, 77 );
		}
		else if( (behaviorTreeEntity.node.type == "Cover Crouch" || behaviorTreeEntity.node.type == "Cover Crouch Window" || behaviorTreeEntity.node.type == "Conceal Crouch" ) )
		{
			arm_offset = ( 7, 3, 51 );
		}
		else if( (behaviorTreeEntity.node.type == "Cover Pillar") )
		{
			yawToEnemyPosition = AiUtility::GetAimYawToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
			aimLimitsForCover = behaviortreeentity GetAimLimitsFromEntry("cover");
			
			if( yawToEnemyPosition > aimLimitsForCover["aim_right"] && yawToEnemyPosition < 0 )		
				arm_offset = ( 24, 0, 76 );
			else
				arm_offset = ( -24, 0, 76 );		
		}
	}

	return arm_offset;
}
