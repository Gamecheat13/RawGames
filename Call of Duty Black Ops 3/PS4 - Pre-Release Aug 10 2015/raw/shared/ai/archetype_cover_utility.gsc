#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                  	                             	  	                                      
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace AiUtility;
// Use this utility if AI takes cover, behavior here should not be archetype dependent at all

 // 10 degree allowable threshold for aims against the aimtables

function autoexec RegisterBehaviorScriptFunctions()
{	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCrouchNode",&isAtCrouchNode);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverCondition",&isAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverStrictCondition",&isAtCoverStrictCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverModeOver",&isAtCoverModeOver);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isAtCoverModeNone",&isAtCoverModeNone);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isExposedAtCoverCondition",&isExposedAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keepClaimedNodeAndChooseCoverDirection",&keepClaimedNodeAndChooseCoverDirection);;	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("resetCoverParameters",&resetCoverParameters);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupCoverMode",&cleanupCoverMode);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canBeFlankedService",&canBeFlankedService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldCoverIdleOnly",&shouldCoverIdleOnly);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isSuppressedAtCoverCondition",&isSuppressedAtCoverCondition);;
	
	// ------- COVER - IDLE BEHAVIOR -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverIdleInitialize",&coverIdleInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverIdleUpdate",&coverIdleUpdate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverIdleTerminate",&coverIdleTerminate);;
	
	// ------- COVER - FLANKED BEHAVIOR -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isFlankedByEnemyAtCover",&isFlankedByEnemyAtCover);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverFlankedActionStart",&coverFlankedInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverFlankedActionTerminate",&coverFlankedActionTerminate);;

	// ------- COVER - OVER SHOOT BEHAVIOR -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsOverCoverCondition",&supportsOverCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldOverAtCoverCondition",&shouldOverAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverOverInitialize",&coverOverInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverOverTerminate",&coverOverTerminate);;
	
	// ------- COVER - LEAN SHOOT BEHAVIOR -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsLeanCoverCondition",&supportsLeanCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldLeanAtCoverCondition",&shouldLeanAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("continueLeaningAtCoverCondition",&continueLeaningAtCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverLeanInitialize",&coverLeanInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverLeanTerminate",&coverLeanTerminate);;
	
	// ------- COVER - PEEK SHOOT BEHAVIOR -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("supportsPeekCoverCondition",&supportsPeekCoverCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverPeekInitialize",&coverPeekInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverPeekTerminate",&coverPeekTerminate);;	
	
	// ------- COVER - RELOAD BEHAVIOR -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("coverReloadInitialize",&coverReloadInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("refillAmmoAndCleanupCoverMode",&refillAmmoAndCleanupCoverMode);;
}

// ------- COVER - RELOAD BEHAVIOR -----------//	
function private coverReloadInitialize( behaviorTreeEntity )
{
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_alert" );
	AiUtility::keepClaimNode( behaviorTreeEntity );
}

function refillAmmoAndCleanupCoverMode( behaviorTreeEntity )
{
	if( IsAlive( behaviorTreeEntity ) )
	{
		AiUtility::refillAmmo( behaviorTreeEntity );
	}
	
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
}

// ------- COVER - PEEK BEHAVIOR -----------//
function private supportsPeekCoverCondition( behaviorTreeEntity )
{
	return IsDefined( behaviorTreeEntity.node );
}

function private coverPeekInitialize( behaviorTreeEntity )
{
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_alert" );
	AiUtility::keepClaimNode( behaviorTreeEntity );
	chooseCoverDirection( behaviorTreeEntity );
}

function private coverPeekTerminate( behaviorTreeEntity )
{
	AiUtility::chooseFrontCoverDirection( behaviorTreeEntity );
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
}
// ------- COVER - PEEK BEHAVIOR -----------//


// ------- COVER - LEAN SHOOT BEHAVIOR -----------//
function private supportsLeanCoverCondition( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.node ) )
	{
		if( (behaviorTreeEntity.node.type == "Cover Left") || (behaviorTreeEntity.node.type == "Cover Right") )
		{
			return true;
		}
		else if ( (behaviorTreeEntity.node.type == "Cover Pillar") )
		{
			if ( !( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 1024) == 1024))) || !( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 2048) == 2048))) )
			{
				return true;
			}
		}
	}
	
	return false;
}

function private shouldLeanAtCoverCondition( behaviorTreeEntity )
{
	if( !IsDefined( behaviorTreeEntity.node ) ||
		!IsDefined( behaviorTreeEntity.node.type ) ||
		!IsDefined( behaviorTreeEntity.enemy) ||
		!IsDefined( behaviorTreeEntity.enemy.origin ) )
	{
		return false;
	}

	yawToEnemyPosition = AiUtility::GetAimYawToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
	
	legalAimYaw = false;
		
	if( (behaviorTreeEntity.node.type == "Cover Left") )
	{
		aimLimitsForCover = behaviortreeentity GetAimLimitsFromEntry("cover_left_lean");
		legalAimYaw = yawToEnemyPosition <= ( aimLimitsForCover["aim_left"] + 10 ) && yawToEnemyPosition >= -10;
	}
	else if( (behaviorTreeEntity.node.type == "Cover Right") )
	{
		aimLimitsForCover = behaviortreeentity GetAimLimitsFromEntry("cover_right_lean");
		legalAimYaw = yawToEnemyPosition >= ( aimLimitsForCover["aim_right"] - 10 ) && yawToEnemyPosition <= 10;
	}
	else if( (behaviorTreeEntity.node.type == "Cover Pillar") )
	{
		aimLimitsForCover = behaviortreeentity GetAimLimitsFromEntry("cover");
		supportsLeft = !( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 1024) == 1024)));
		supportsRight = !( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 2048) == 2048)));
		
		// If both left and right are supported, then split the 180 coverage along the center, otherwise pad the leeway to force the AI to lean more often.
		angleLeeway = 10;
		
		if ( supportsRight && supportsLeft )
		{
			angleLeeway = 0;
		}
		
		if ( supportsLeft )
		{
			legalAimYaw = yawToEnemyPosition <= ( aimLimitsForCover["aim_left"] + 10 ) && yawToEnemyPosition >= -angleLeeway;
		}
		
		if ( !legalAimYaw && supportsRight )
		{
			legalAimYaw = yawToEnemyPosition >= ( aimLimitsForCover["aim_right"] - 10 ) && yawToEnemyPosition <= angleLeeway;
		}
	}
	
	return legalAimYaw;
}


function private continueLeaningAtCoverCondition( behaviorTreeEntity )
{
	if ( behaviorTreeEntity ASMIsTransitionRunning() )
	{
		return true; 
	}
	
	return AiUtility::shouldLeanAtCoverCondition( behaviorTreeEntity );
}


function private coverLeanInitialize( behaviorTreeEntity )
{
	AiUtility::setCoverShootStartTime( behaviorTreeEntity );
	AiUtility::keepClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_lean" );
	AiUtility::chooseCoverDirection( behaviorTreeEntity );
}

function private coverLeanTerminate( behaviorTreeEntity )
{
	AiUtility::chooseFrontCoverDirection( behaviorTreeEntity );
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
	AiUtility::clearCoverShootStartTime( behaviorTreeEntity );
}
// ------- COVER - LEAN SHOOT BEHAVIOR -----------//

// ------- COVER - OVER SHOOT BEHAVIOR -----------//
function private supportsOverCoverCondition( behaviorTreeEntity )
{
	stance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	
	if ( IsDefined( behaviorTreeEntity.node ) )
	{				
		if( (behaviorTreeEntity.node.type == "Cover Left") 
			|| (behaviorTreeEntity.node.type == "Cover Right") 
			|| (behaviorTreeEntity.node.type == "Cover Crouch" || behaviorTreeEntity.node.type == "Cover Crouch Window" || behaviorTreeEntity.node.type == "Conceal Crouch" ) )
		{
			if( stance == "crouch" )
				return true;
		}
		else if( (behaviorTreeEntity.node.type == "Cover Stand" || behaviorTreeEntity.node.type == "Conceal Stand") )
		{
			if( stance == "stand" )
				return true;
		}
	}
	
	return false;
}

function private shouldOverAtCoverCondition( behaviorTreeEntity )
{
	if ( !IsDefined( behaviorTreeEntity.node ) ||
		!IsDefined( behaviorTreeEntity.node.type ) ||
		!IsDefined( behaviorTreeEntity.enemy) ||
		!IsDefined( behaviorTreeEntity.enemy.origin ) )
	{
		return false;
	}
		
	yawToEnemyPosition = AiUtility::GetAimYawToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
	pitchToEnemyPosition = AiUtility::GetAimPitchToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
	aimLimitsForCover = behaviortreeentity GetAimLimitsFromEntry( "cover_over" );
	
	if ( AiUtility::isCoverConcealed( behaviorTreeEntity.node ) )
	{
		aimLimitsForCover = behaviortreeentity GetAimLimitsFromEntry( "cover_concealed_over" );
	}
	
	legalAimYaw = false;
	legalAimPitch = false;
	
	if( (behaviorTreeEntity.node.type == "Cover Left") || (behaviorTreeEntity.node.type == "Cover Right") )
	{
		stance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
		
		if( stance == "crouch" )
		{
			modes = GetValidCoverPeekOuts( behaviorTreeEntity.node );
			
			if ( !IsInArray( modes, "over" ) )
			{
				return false;
			}
		
			legalAimYaw = yawToEnemyPosition >= ( aimLimitsForCover["aim_right"] - 10 );
			legalAimYaw = legalAimYaw && ( yawToEnemyPosition <= ( aimLimitsForCover["aim_left"] + 10 ) );
						
			legalAimPitch = pitchToEnemyPosition >= ( aimLimitsForCover["aim_up"] + 10 );
			legalAimPitch = legalAimPitch && ( pitchToEnemyPosition <= ( aimLimitsForCover["aim_down"] + 10 ) );
		}
	}
	else if( (behaviorTreeEntity.node.type == "Cover Stand" || behaviorTreeEntity.node.type == "Conceal Stand") || (behaviorTreeEntity.node.type == "Cover Crouch" || behaviorTreeEntity.node.type == "Cover Crouch Window" || behaviorTreeEntity.node.type == "Conceal Crouch" ) )
	{		
		legalAimYaw = yawToEnemyPosition >= ( aimLimitsForCover["aim_right"] - 10 );
		legalAimYaw = legalAimYaw && ( yawToEnemyPosition <= ( aimLimitsForCover["aim_left"] + 10 ) );
						
		legalAimPitch = pitchToEnemyPosition >= ( aimLimitsForCover["aim_up"] + 10 );
		legalAimPitch = legalAimPitch && ( pitchToEnemyPosition <= ( aimLimitsForCover["aim_down"] + 10 ) );
	}
	
	return legalAimYaw && legalAimPitch;
}

function private coverOverInitialize( behaviorTreeEntity )
{
	AiUtility::setCoverShootStartTime( behaviorTreeEntity );
	AiUtility::keepClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_over" );	
}

function private coverOverTerminate( behaviorTreeEntity )
{	
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
	AiUtility::clearCoverShootStartTime( behaviorTreeEntity );
}
// ------- COVER - OVER SHOOT BEHAVIOR -----------//


// ------- COVER - IDLE BEHAVIOR -----------//	
function private coverIdleInitialize( behaviorTreeEntity )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_alert" );
}

function private coverIdleUpdate( behaviorTreeEntity )
{		
	if( !behaviorTreeEntity ASMIsTransitionRunning() )
	{
		AiUtility::releaseClaimNode( behaviorTreeEntity );
	}
}

function private coverIdleTerminate( behaviorTreeEntity )
{		
	AiUtility::releaseClaimNode( behaviorTreeEntity );
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
}
// ------- COVER - IDLE BEHAVIOR -----------//	


// ------- COVER - FLANKED BEHAVIOR ---------//	
function private isFlankedByEnemyAtCover( behaviorTreeEntity )
{
	return canBeFlanked( behaviorTreeEntity ) &&
		behaviorTreeEntity IsAtCoverNodeStrict() &&
		behaviorTreeEntity IsFlankedAtCoverNode() &&
		!behaviorTreeEntity HasPath();
}

function private canBeFlankedService( behaviorTreeEntity )
{
	AiUtility::setCanBeFlanked( behaviorTreeEntity, true );
}

function private coverFlankedInitialize( behaviorTreeEntity )
{
	if( IsDefined( behaviorTreeEntity.enemy ) )
	{
		// cheat and give perfect info about the close enemy, makes it feel like AI is smart :)
		behaviorTreeEntity GetPerfectInfo( behaviorTreeEntity.enemy );
		
		// Dont move for a few sec, this may trigger AI to charge melee attack
		behaviorTreeEntity PathMode( "move delayed", false, 2 );
	}
		
	setCanBeFlanked( behaviorTreeEntity, false );
	
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
	AiUtility::keepClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
}

function private coverFlankedActionTerminate( behaviorTreeEntity )
{
	behaviorTreeEntity.newEnemyReaction = false;
	AiUtility::releaseClaimNode( behaviorTreeEntity );
}
// ------- COVER - FLANKED BEHAVIOR ---------//


// ------- COVER - COMMON CONDITIONS ---------//

function isAtCrouchNode( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.node ) &&
		( (behaviorTreeEntity.node.type == "Exposed") || (behaviorTreeEntity.node.type == "Guard") || (behaviorTreeEntity.node.type == "Path") ) )
	{
		if ( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.node.origin ) <= ( (24) * (24) ) )
		{
			return !AiUtility::isStanceAllowedAtNode( "stand", behaviorTreeEntity.node ) &&
				AiUtility::isStanceAllowedAtNode( "crouch", behaviorTreeEntity.node );
		}
	}
	
	return false;
}

function isAtCoverCondition( behaviorTreeEntity )
{
	return behaviorTreeEntity IsAtCoverNodeStrict() &&
		behaviorTreeEntity ShouldUseCoverNode() &&
		!behaviorTreeEntity HasPath();
}

function isAtCoverStrictCondition( behaviorTreeEntity )
{
	return behaviorTreeEntity IsAtCoverNodeStrict() &&
		!behaviorTreeEntity HasPath();
}

function isAtCoverModeOver( behaviorTreeEntity )
{
	coverMode = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode" );
	
	return coverMode == "cover_over";
}

function isAtCoverModeNone( behaviorTreeEntity )
{
	coverMode = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode" );
	
	return coverMode == "cover_mode_none";
}

function isExposedAtCoverCondition( behaviorTreeEntity )
{
	return behaviorTreeEntity IsAtCoverNodeStrict() && !behaviorTreeEntity ShouldUseCoverNode();
}

function shouldCoverIdleOnly( behaviorTreeEntity )
{
	if( behaviorTreeEntity ai::get_behavior_attribute( "coverIdleOnly" ) )
	{
		return true;
	}
	
	if( ( isdefined( behaviorTreeEntity.node.script_onlyidle ) && behaviorTreeEntity.node.script_onlyidle ) )
	{
		return true;
	}
	
	return false;
}

function isSuppressedAtCoverCondition( behaviorTreeEntity )
{
	// TODO(David Young 9-6-13): Move this to code.
	return behaviorTreeEntity.suppressionMeter > behaviorTreeEntity.suppressionThreshold;
}

function keepClaimedNodeAndChooseCoverDirection( behaviorTreeEntity )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );
	chooseCoverDirection( behaviorTreeEntity );
}

function resetCoverParameters( behaviorTreeEntity )
{
	AiUtility::chooseFrontCoverDirection( behaviorTreeEntity );
	AiUtility::cleanupCoverMode( behaviorTreeEntity );
	
	AiUtility::clearCoverShootStartTime( behaviorTreeEntity );
}

function chooseCoverDirection( behaviorTreeEntity, stepOut )
{
	if ( !IsDefined( behaviorTreeEntity.node ) )
	{
		return;
	}
	
	coverDirection = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_cover_direction" );
	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_previous_cover_direction", coverDirection );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_direction", calculateCoverDirection( behaviorTreeEntity, stepOut ) );
}

function calculateCoverDirection( behaviorTreeEntity, stepOut )
{
	if( IsDefined( behaviorTreeEntity.treatAllCoversAsGeneric ) )
	{
		if ( !IsDefined( stepOut ) )
		{
			stepOut = false;
		}
	
		coverDirection = "cover_front_direction";
		
		if ( (behaviorTreeEntity.node.type == "Cover Left") )
		{
			if ( ( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 4) == 4))) || math::cointoss() || stepOut )
			{
				coverDirection = "cover_left_direction";
			}
		}
		else if ( (behaviorTreeEntity.node.type == "Cover Right") )
		{
			if ( ( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 4) == 4))) || math::cointoss() || stepOut )
			{
				coverDirection = "cover_right_direction";
			}
		}
		else if ( (behaviorTreeEntity.node.type == "Cover Pillar") )
		{
			// must choose either left or right		
			if( ( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 1024) == 1024))) )
			{
				return "cover_right_direction";
			}
			
			if( ( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 2048) == 2048))) )
			{
				return "cover_left_direction";
			}
	
			coverDirection = "cover_left_direction";
			
			if ( IsDefined( behaviorTreeEntity.enemy ) )
			{
				yawToEnemyPosition = AiUtility::GetAimYawToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
				aimLimitsForDirectionRight = behaviorTreeEntity GetAimLimitsFromEntry("pillar_right_lean");
							
				legalRightDirectionYaw = yawToEnemyPosition >= ( aimLimitsForDirectionRight["aim_right"] - 10 ) && yawToEnemyPosition <= 0;
				
				if ( legalRightDirectionYaw )
				{
					coverDirection = "cover_right_direction";
				}
			}
		}
		
		return coverDirection;
	}
	else
	{
		coverDirection = "cover_front_direction";
		
		if ( (behaviorTreeEntity.node.type == "Cover Pillar") )
		{
			// must choose either left or right		
			if( ( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 1024) == 1024))) )
			{
				return "cover_right_direction";
			}
			
			if( ( (isdefined(behaviorTreeEntity.node.spawnflags)&&((behaviorTreeEntity.node.spawnflags & 2048) == 2048))) )
			{
				return "cover_left_direction";
			}
	
			coverDirection = "cover_left_direction";
			
			if ( IsDefined( behaviorTreeEntity.enemy ) )
			{
				yawToEnemyPosition = AiUtility::GetAimYawToEnemyFromNode( behaviorTreeEntity, behaviorTreeEntity.node, behaviorTreeEntity.enemy );
				aimLimitsForDirectionRight = behaviorTreeEntity GetAimLimitsFromEntry("pillar_right_lean");
							
				legalRightDirectionYaw = yawToEnemyPosition >= ( aimLimitsForDirectionRight["aim_right"] - 10 ) && yawToEnemyPosition <= 0;
				
				if ( legalRightDirectionYaw )
				{
					coverDirection = "cover_right_direction";
				}
			}
		}
	}
	
	return coverDirection;
}

function clearCoverShootStartTime( behaviorTreeEntity )
{
	behaviorTreeEntity.coverShootStartTime = undefined;
}

function setCoverShootStartTime( behaviorTreeEntity )
{
	behaviorTreeEntity.coverShootStartTime = GetTime();
}

function canBeFlanked( behaviorTreeEntity )
{
	return IsDefined( behaviorTreeEntity.canBeFlanked ) && behaviorTreeEntity.canBeFlanked;
}

function setCanBeFlanked( behaviorTreeEntity, canBeFlanked )
{
	behaviorTreeEntity.canBeFlanked = canBeFlanked;
}

function cleanupCoverMode( behaviorTreeEntity )
{
	if( isAtCoverCondition( behaviorTreeEntity ) )
	{
		coverMode = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode" );
		
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_previous_cover_mode", coverMode );
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_mode_none" );
	}
	else
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_previous_cover_mode", "cover_mode_none" );
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_mode_none" );
	}
}

// ------- COVER - COMMON CONDITIONS ---------//