#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

//AI VS AI MELEE BEHAVIOR
#using scripts\shared\ai\archetype_aivsaimelee;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                         	                                                                           	                                                                                   	       
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                  	                             	  	                                      
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     



#precache( "fx", "lensflares/fx_lensflare_sniper_glint" );

#namespace AiUtility;

function autoexec RegisterBehaviorScriptFunctions()
{	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("forceRagdoll",&forceRagdoll);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasAmmo",&hasAmmo);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasLowAmmo",&hasLowAmmo);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasEnemy",&hasEnemy);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isSafeFromGrenades",&isSafeFromGrenades);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("inGrenadeBlastRadius",&inGrenadeBlastRadius);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("recentlySawEnemy",&recentlySawEnemy);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldBeAggressive",&shouldBeAggressive);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldOnlyFireAccurately",&shouldOnlyFireAccurately);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldReactToNewEnemy",&shouldReactToNewEnemy);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldReactToNewEnemy",&shouldReactToNewEnemy);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasWeaponMalfunctioned",&hasWeaponMalfunctioned);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStopMoving",&shouldStopMoving);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldStopMoving",&shouldStopMoving);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseBestCoverNodeASAP",&chooseBestCoverNodeASAP);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseBetterCoverService",&chooseBetterCoverServiceCodeVersion);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("trackCoverParamsService",&trackCoverParamsService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("refillAmmoIfNeededService",&refillAmmo);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryStoppingService",&tryStoppingService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isFrustrated",&isFrustrated);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("updatefrustrationLevel",&updateFrustrationLevel);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isLastKnownEnemyPositionApproachable",&isLastKnownEnemyPositionApproachable);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryAdvancingOnLastKnownPositionBehavior",&tryAdvancingOnLastKnownPositionBehavior);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryGoingToClosestNodeToEnemyBehavior",&tryGoingToClosestNodeToEnemyBehavior);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryRunningDirectlyToEnemyBehavior",&tryRunningDirectlyToEnemyBehavior);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("flagEnemyUnAttackableService",&flagEnemyUnAttackableService);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("keepClaimNode",&keepClaimNode);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("keepClaimNode",&keepClaimNode);;
		
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("releaseClaimNode",&releaseClaimNode);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("startRagdoll",&scriptStartRagdoll);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("notStandingCondition",&notStandingCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("notCrouchingCondition",&notCrouchingCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("explosiveKilled",&explosiveKilled);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("electrifiedKilled",&electrifiedKilled);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("burnedKilled",&burnedKilled);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("rapsKilled",&rapsKilled);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("meleeAcquireMutex",&meleeAcquireMutex);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("meleeReleaseMutex",&meleeReleaseMutex);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldMutexMelee",&shouldMutexMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareForExposedMelee",&prepareForExposedMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupMelee",&cleanupMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldNormalMelee",&shouldNormalMelee);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldMelee",&shouldMelee);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("shouldMelee",&shouldMelee);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasCloseEnemyMelee",&hasCloseEnemyToMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isBalconyDeath",&isBalconyDeath);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("balconyDeath",&balconyDeath);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("useCurrentPosition",&useCurrentPosition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isUnarmed",&isUnarmed);;
		
	// ------- CHARGE MELEE -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChargeMelee",&shouldChargeMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldAttackInChargeMelee",&shouldAttackInChargeMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupChargeMelee",&cleanupChargeMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("cleanupChargeMeleeAttack",&cleanupChargeMeleeAttack);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setupChargeMeleeAttack",&setupChargeMeleeAttack);;
	
	// ------- SPECIAL PAIN -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialPain",&shouldChooseSpecialPain);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialPronePain",&shouldChooseSpecialPronePain);;
	
	
	// ------- SPECIAL DEATH -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialDeath",&shouldChooseSpecialDeath);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldChooseSpecialProneDeath",&shouldChooseSpecialProneDeath);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setupExplosionAnimScale",&setupExplosionAnimScale);;

	// ------- STEALTH -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStealth",&shouldStealth);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthReactCondition",&stealthReactCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("locomotionShouldStealth",&locomotionShouldStealth);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldStealthResume",&shouldStealthResume);;
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("locomotionShouldStealth",&locomotionShouldStealth);; 
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("stealthReactCondition",&stealthReactCondition);; 
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthReactStart",&stealthReactStart);;	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthReactTerminate",&stealthReactTerminate);;	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("stealthIdleTerminate",&stealthIdleTerminate);;

	// ------- PHALANX -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isInPhalanx",&isInPhalanx);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isInPhalanxStance",&isInPhalanxStance);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("togglePhalanxStance",&togglePhalanxStance);;
	
	// ------- FLASHBANG -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tookFlashbangDamage",&tookFlashbangDamage);;

	// DEFAULT ACTIONS
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("defaultAction",undefined,undefined,undefined);;
	
	//AI vs AI MELEE BEHAVIOR
	archetype_aivsaimelee::RegisterAIvsAIMeleeBehaviorFunctions();
}

// ------- UTILITY BLACKBOARD -----------//

// Has to be called from the any archetype who wants to use the utility blackboard  
function RegisterUtilityBlackboardAttributes() // has to be called on AI
{
	Blackboard::RegisterBlackBoardAttribute(self,"_arrival_stance",undefined,&BB_GetArrivalStance);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_arrival_stance");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_context",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_context");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_context2",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_context2");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_cover_concealed",undefined,&BB_GetCoverConcealed);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_cover_concealed");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_cover_direction","cover_front_direction",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_cover_direction");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_cover_mode","cover_mode_none",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_cover_mode");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_cover_type",undefined,&BB_GetCurrentCoverNodeType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_cover_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_current_location_cover_type",undefined,&BB_GetCurrentLocationCoverNodeType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_current_location_cover_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_exposed_type",undefined,&BB_GetCurrentExposedType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_exposed_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_damage_direction",undefined,&BB_GetDamageDirection);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_damage_direction");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_damage_location",undefined,&BB_ActorGetDamageLocation);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_damage_location");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_damage_weapon_class",undefined,&BB_GetDamageWeaponClass);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_damage_weapon_class");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_damage_weapon",undefined,&BB_GetDamageWeapon);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_damage_weapon");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_damage_mod",undefined,&BB_GetDamageMOD);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_damage_mod");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_damage_taken",undefined,&BB_GetDamageTaken);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_damage_taken");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_desired_stance","stand",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_desired_stance");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_enemy",undefined,&BB_ActorHasEnemy);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_enemy");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_enemy_yaw",undefined,&BB_ActorGetEnemyYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_enemy_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_react_yaw",undefined,&BB_ActorGetReactYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_react_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_fatal_damage_location",undefined,&BB_ActorGetFatalDamageLocation);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_fatal_damage_location");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_fire_mode",undefined,&GetFireMode);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_fire_mode");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_gib_location",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_gib_location");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_juke_direction",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_juke_direction");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_juke_distance",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_juke_distance");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_arrival_distance",undefined,&BB_GetLocomotionArrivalDistance);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_arrival_distance");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_arrival_yaw",undefined,&BB_GetLocomotionArrivalYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_arrival_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_exit_yaw",undefined,&BB_GetLocomotionExitYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_exit_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_face_enemy_quadrant","locomotion_face_enemy_none",&BB_GetLocomotionFaceEnemyQuadrant);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_face_enemy_quadrant");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_motion_angle",undefined,&BB_GetLocomotionMotionAngle);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_motion_angle");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_face_enemy_quadrant_previous","locomotion_face_enemy_none",&BB_GetLocomotionFaceEnemyQuadrantPrevious);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_face_enemy_quadrant_previous");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_pain_type",undefined,&BB_GetLocomotionPainType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_pain_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_turn_yaw",undefined,&BB_GetLocomotionTurnYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_turn_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_lookahead_angle",undefined,&BB_GetLookaheadAngle);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_lookahead_angle");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_patrol",undefined,&BB_ActorIsPatroling);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_patrol");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_perfect_enemy_yaw",undefined,&BB_ActorGetPerfectEnemyYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_perfect_enemy_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_previous_cover_direction","cover_front_direction",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_previous_cover_direction");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_previous_cover_mode","cover_mode_none",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_previous_cover_mode");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_previous_cover_type",undefined,&BB_GetPreviousCoverNodeType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_previous_cover_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_stance","stand",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_stance");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_traversal_type",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_traversal_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_melee_distance",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_melee_distance");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_tracking_turn_yaw",undefined,&BB_ActorGetTrackingTurnYaw);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_tracking_turn_yaw");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_weapon_class","rifle",&BB_GetWeaponClass);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_weapon_class");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_throw_distance",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_throw_distance");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_yaw_to_cover",undefined,&BB_GetYawToCoverNode);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_yaw_to_cover");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_special_death","none",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_special_death");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_awareness","combat",&BB_GetAwareness);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_awareness");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_awareness_prev","combat",&BB_GetAwarenessPrevious);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_awareness_prev");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_melee_enemy_type",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_melee_enemy_type");#/    };
			
	Blackboard::RegisterBlackBoardAttribute(self,"_staircase_num_steps",0,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_staircase_num_steps");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_staircase_num_total_steps",0,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_staircase_num_total_steps");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_staircase_state",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_staircase_state");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_staircase_direction",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_staircase_direction");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_staircase_exit_type",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_staircase_exit_type");#/    };	
	Blackboard::RegisterBlackBoardAttribute(self,"_staircase_skip_num",undefined,&BB_GetStairsNumSkipSteps);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_staircase_skip_num");#/    };		
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
}

function private BB_GetStairsNumSkipSteps()
{	
	assert( IsDefined( self._stairsStartNode ) && IsDefined( self._stairsEndNode ) );

	numTotalSteps 	= Blackboard::GetBlackBoardAttribute( self, "_staircase_num_total_steps" );
	stepsSoFar 		= Blackboard::GetBlackBoardAttribute( self, "_staircase_num_steps" );
	
	direction	 	= Blackboard::GetBlackBoardAttribute( self, "_staircase_direction" );
	
	numOutSteps	= 2;
	totalStepsWithoutOut = numTotalSteps - numOutSteps;
	
	assert( stepsSoFar < ( totalStepsWithoutOut ) );
	
	remainingSteps = totalStepsWithoutOut - stepsSoFar;
	
	// Try 8 steps first
	if( remainingSteps >= 8 )
	{
		return "staircase_skip_8";
	}
	else if( remainingSteps >= 6 )
	{
		return "staircase_skip_6";
	}

	assert( remainingSteps >= 3 );	
	return "staircase_skip_3";
}

function private BB_GetAwareness()
{
	// Awareness is always "combat" unless this agent is in stealth mode
	if( !isDefined( self.stealth ) || !IsDefined( self.awarenesslevelcurrent ) )
		return "combat";
	
	return self.awarenesslevelcurrent;
}

function private BB_GetAwarenessPrevious()
{
	// Awareness is always "combat" unless this agent is in stealth mode
	if( !isDefined( self.stealth ) || !IsDefined( self.awarenesslevelprevious ) )
		return "combat";
	
	return self.awarenesslevelprevious;
}

function private BB_GetYawToCoverNode()
{
	if( !IsDefined( self.node ) )
	{
		return 0;
	}
	
	angleToNode = Floor( AngleClamp180( self.angles[1] - self GetNodeOffsetAngles( self.node )[1] ) );
	
	return angleToNode;
}

function BB_GetHighestStance()
{
	If( self IsAtCoverNodeStrict() && self ShouldUseCoverNode() )
	{
		highestStance = AiUtility::getHighestNodeStance( self.node );
		return highestStance;
	}
	else
	{
		return Blackboard::GetBlackBoardAttribute( self, "_stance" );
	}
}


function BB_GetLocomotionFaceEnemyQuadrantPrevious()
{
	if( IsDefined( self.prevrelativedir ) )
	{
		direction = self.prevrelativedir;

		switch( direction )
		{
			case 0:
				return "locomotion_face_enemy_none";
			case 1:
				return "locomotion_face_enemy_front";
			case 2:
				return "locomotion_face_enemy_right";							
			case 3:
				return "locomotion_face_enemy_left";
			case 4:
				return "locomotion_face_enemy_back";		
		}
	}
	
	return "locomotion_face_enemy_none";
}

function BB_GetCurrentCoverNodeType()
{
	return AiUtility::getCoverType( self.node );
}

function BB_GetCoverConcealed()
{
	if ( AiUtility::isCoverConcealed( self.node ) )
	{
		return "concealed";
	}
	
	return "unconcealed";
}

function BB_GetCurrentLocationCoverNodeType()
{
	// Returns the cover node type that the AI is currently at.
	// This version of cover node type is resilient to timing issues during node selections.
	
	if ( IsDefined( self.node ) && DistanceSquared( self.origin, self.node.origin ) < ( (48) * (48) ) )
	{
		return BB_GetCurrentCoverNodeType();
	}
	
	return BB_GetPreviousCoverNodeType();
}

function BB_GetDamageDirection()
{	
/#	
	if( IsDefined( level._debug_damage_direction ) )
		return level._debug_damage_direction;
#/
	if ( self.damageyaw > 135 || self.damageyaw <= -135 )
		return "front";
	
	if ( ( self.damageyaw > 45 ) && ( self.damageyaw <= 135 ) )
		return "right";
	
	if ( ( self.damageyaw > -45 ) && ( self.damageyaw <= 45 ) )
		return "back";
	
	return "left";
}

function BB_ActorGetDamageLocation()
{
/#
	if( IsDefined( level._debug_damage_pain_location ) )
		return level._debug_damage_pain_location;
#/
	
	sHitLoc = self.damagelocation;
	
	possibleHitLocations = array();
	
	if ( ( IsInArray( array( "helmet", "head", "neck" ), sHitLoc ) ) )
	{
		possibleHitLocations[possibleHitLocations.size] = "head";				
	}
	
	if ( ( IsInArray( array( "torso_upper", "torso_mid" ), sHitLoc ) ) )
	{
		possibleHitLocations[possibleHitLocations.size] = "chest";		
	}
		
	if( ( IsInArray( array( "torso_lower" ), sHitLoc ) ) )
	{
		possibleHitLocations[possibleHitLocations.size] = "groin";		
	}
	
	if ( ( IsInArray( array( "torso_lower" ), sHitLoc ) ) )
	{		
		possibleHitLocations[possibleHitLocations.size] = "legs";
	}
	
	if ( ( IsInArray( array( "left_arm_upper", "left_arm_lower", "left_hand" ), sHitLoc ) ) )
	{			
		possibleHitLocations[possibleHitLocations.size] = "left_arm";			
	}
	
	if ( ( IsInArray( array( "right_arm_upper", "right_arm_lower", "right_hand", "gun" ), sHitLoc ) ) )
	{				
		possibleHitLocations[possibleHitLocations.size] = "right_arm";		
	}
	
	if ( ( IsInArray( array( "right_leg_upper", "left_leg_upper", "right_leg_lower", "left_leg_lower", "right_foot", "left_foot" ), sHitLoc ) ) )
	{
		possibleHitLocations[possibleHitLocations.size] = "legs";
	}
	
	// if this AI was shot recently, then try to not repeat the same damagelocation, so that we get two different responses
	if( IsDefined( self.lastDamageTime ) && GetTime() > self.lastDamageTime && GetTime() <= self.lastDamageTime + 1 * 1000 )
	{
		if( IsDefined( self.lastDamageLocation ) )
			ArrayRemoveValue( possibleHitLocations, self.lastDamageLocation );
	}
	
	if( possibleHitLocations.size == 0 )
	{
		// SUMEET (07/02/2015) - There is an underlying VM bug where something modifying 0 size array does not work. 
		// This script happens to be one of the places where that issue happens often. Just creating a completely new 
		// array seems to fix the issue in this case.
		possibleHitLocations = undefined;
		possibleHitLocations = [];
		
		possibleHitLocations[0] = "chest";
		possibleHitLocations[1] = "groin";			
	}
		
	assert( possibleHitLocations.size > 0, possibleHitLocations.size );
	
	damageLocation = possibleHitLocations[RandomInt(possibleHitLocations.size)];
	
	// save the last damage location
	self.lastDamageLocation = damageLocation;
		
	return damageLocation;
}

function BB_GetDamageWeaponClass()
{
	if ( IsDefined( self.damageMod ) )
	{
		if ( IsInArray( array( "mod_rifle_bullet" ), ToLower( self.damageMod ) ) )
		return "rifle";
	
		if ( IsInArray( array( "mod_pistol_bullet" ), ToLower( self.damageMod ) ) )
			return "pistol";
		
		if ( IsInArray( array( "mod_melee", "mod_melee_assassinate" ), ToLower( self.damageMod ) ) )
			return "melee";
		
		if ( IsInArray( array( "mod_grenade", "mod_grenade_splash", "mod_projectile", "mod_projectile_splash", "mod_explosive" ), ToLower( self.damageMod ) ) )
			return "explosive";
	}
	
	return "rifle";
}

function BB_GetDamageWeapon()
{
	if (isDefined(self.damageWeapon) && isDefined(self.damageWeapon.name) )
	{
		return self.damageWeapon.name;
	}

	return "unknown";
}

function BB_GetDamageMOD()
{
	if (isDefined(self.damageMod))
	{
		return ToLower(self.damageMod);
	}
	
	return "unknown";
}

function BB_GetDamageTaken()
{	
/#	
	if( IsDefined( level._debug_damage_intensity ) )
		return level._debug_damage_intensity;
#/
		
	damageTaken 	= self.damageTaken;
	maxHealth 		= self.maxHealth;
	damageTakenType = "light";
	
	if( IsAlive( self ) )
	{
		// pain damage
		if( IsDefined( self.lastDamageTime ) && IsDefined( self.lastDamageLocation ) )
		{
			if( GetTime() > self.lastDamageTIme && GetTime() < self.lastDamageTime + 1 * 1000 )
				damageTakenType = "heavy";
		}
		else 
		{
			ratio = damageTaken / self.maxHealth;
			
			if( ratio > 0.7 )
				damageTakenType = "heavy";
		}
				
		self.lastDamageTime = GetTime();
	}
	else
	{
		// death/fatal damage
		ratio = damageTaken / self.maxHealth;
			
		if( ratio > 0.7 )
			damageTakenType = "heavy";		
	}	
	
	return damageTakenType;
}

/*
///BehaviorUtilityDocBegin
"Name: AddAIOverrideDamageCallback \n"
"Summary: Adds an AI damage callback function.  This should only be used by the AI system.\n"
"MandatoryArg: <entity> : Entity to add the damage callback to.\n"
"MandatoryArg: <function> : Damage callback function.\n"
"OptionalArg: <boolean> : Whether to add the callback to the front of the overrides\n"
///BehaviorUtilityDocEnd
*/
function AddAIOverrideDamageCallback( entity, callback, addToFront )
{
	assert( IsEntity( entity ) );
	assert( IsFunctionPtr( callback ) );
	assert( !IsDefined( entity.aiOverrideDamage ) || IsArray( entity.aiOverrideDamage ) );
	
	if ( !isdefined( entity.aiOverrideDamage ) ) entity.aiOverrideDamage = []; else if ( !IsArray( entity.aiOverrideDamage ) ) entity.aiOverrideDamage = array( entity.aiOverrideDamage );;
	
	if ( ( isdefined( addToFront ) && addToFront ) )
	{
		damageOverrides = [];
		damageOverrides[ damageOverrides.size ] = callback;
		
		foreach( override in entity.aiOverrideDamage )
		{
			damageOverrides[ damageOverrides.size ] = override;
		}
		
		entity.aiOverrideDamage = damageOverrides;
	}
	else
	{
		if ( !isdefined( entity.aiOverrideDamage ) ) entity.aiOverrideDamage = []; else if ( !IsArray( entity.aiOverrideDamage ) ) entity.aiOverrideDamage = array( entity.aiOverrideDamage ); entity.aiOverrideDamage[entity.aiOverrideDamage.size]=callback;;
	}
}

/*
///BehaviorUtilityDocBegin
"Name: RemoveAIOverrideDamageCallback \n"
"Summary: Removes an AI damage callback function.  This should only be used by the AI system.\n"
"MandatoryArg: <entity> : Entity to remove the damage callback from.\n"
"MandatoryArg: <function> : Damage callback function.\n"
"OptionalArg: \n"
///BehaviorUtilityDocEnd
*/
function RemoveAIOverrideDamageCallback( entity, callback )
{
	assert( IsEntity( entity ) );
	assert( IsFunctionPtr( callback ) );
	assert( IsArray( entity.aiOverrideDamage ) );
	
	currentDamageCallbacks = entity.aiOverrideDamage;
	
	entity.aiOverrideDamage = [];
	
	foreach (key, value in currentDamageCallbacks)
	{
		if ( value != callback )
		{
			entity.aiOverrideDamage[ entity.aiOverrideDamage.size ] = value;
		}
	}
}

/*
///BehaviorUtilityDocBegin
"Name: AddAIOverrideKilledCallback \n"
"Summary: Adds a AI killed callback function.  This should only be used by the AI system.\n"
"MandatoryArg: <entity> : Entity to add the killed callback to.\n"
"MandatoryArg: <function> : Killed callback function.\n"
"OptionalArg: \n"
///BehaviorUtilityDocEnd
*/
function AddAIOverrideKilledCallback( entity, callback )
{
	assert( IsEntity( entity ) );
	assert( IsFunctionPtr( callback ) );
	assert( !IsDefined( entity.aiOverrideKilled ) || IsArray( entity.aiOverrideKilled ) );
	
	if ( !isdefined( entity.aiOverrideKilled ) ) entity.aiOverrideKilled = []; else if ( !IsArray( entity.aiOverrideKilled ) ) entity.aiOverrideKilled = array( entity.aiOverrideKilled ); entity.aiOverrideKilled[entity.aiOverrideKilled.size]=callback;;
}

function ActorGetPredictedYawToEnemy( entity, lookAheadTime )
{
	// don't run this more than once per frame
	if( IsDefined(entity.predictedYawToEnemy) && IsDefined(entity.predictedYawToEnemyTime) && entity.predictedYawToEnemyTime == GetTime() )
		return entity.predictedYawToEnemy;

	selfPredictedPos = entity.origin;
	moveAngle = entity.angles[1] + entity getMotionAngle();
	selfPredictedPos += (cos( moveAngle ), sin( moveAngle ), 0) * 200.0 * lookAheadTime;

	yaw = VectorToAngles( entity LastKnownPos( entity.enemy ) - selfPredictedPos)[1] - entity.angles[1];
	yaw = AbsAngleClamp360( yaw );
	
	// cache
	entity.predictedYawToEnemy = yaw;
	entity.predictedYawToEnemyTime = GetTime();
	
	return yaw;
}

function BB_ActorIsPatroling()
{
	entity = self;

	if( entity ai::has_behavior_attribute( "patrol" ) 
		&& entity ai::get_behavior_attribute( "patrol" ) )
	{
		return "patrol_enabled";
	}
	
	return "patrol_disabled";
}

function BB_ActorHasEnemy()
{
	entity = self;

	if ( IsDefined( entity.enemy ) )
	{
		return "has_enemy";
	}
	
	return "no_enemy";
}


function BB_ActorGetEnemyYaw()
{
	// enemy yaw from AI's forward direction
	enemy = self.enemy;
	
	if( !IsDefined( enemy ) )
		return 0;
	
	toEnemyYaw = ActorGetPredictedYawToEnemy( self, 0.2 );
	///# recordEntText( "EnemyYaw: " + toEnemyYaw, self, RED, "Animscript" ); #/

	return toEnemyYaw;
}

function BB_ActorGetPerfectEnemyYaw()
{
	// enemy yaw from AI's forward direction
	enemy = self.enemy;
	
	if( !IsDefined( enemy ) )
		return 0;
	
	toEnemyYaw = VectorToAngles( enemy.origin - self.origin )[1] - self.angles[1];
	toEnemyYaw = AbsAngleClamp360( toEnemyYaw );
	/# recordEntText( "EnemyYaw: " + toEnemyYaw, self, ( 1, 0, 0 ), "Animscript" ); #/

	return toEnemyYaw;
}

function BB_ActorGetReactYaw()
{
	result = 0;
	
	if ( isDefined( self.react_yaw ) )
	{
		result = self.react_yaw;
		self.react_yaw = undefined;
	}
	else
	{		
		v_origin = self GetEventPointOfInterest();
		if ( isDefined( v_origin ) )
		{
			str_typeName = self GetCurrentEventTypeName();
			e_originator = self GetCurrentEventOriginator();
			
			if ( str_typeName == "bullet" && isDefined( e_originator ) )
			{
				// React to the source of the bullet, not the bullet whiz by location
				v_origin = e_originator.origin;
			}
	
			deltaOrigin = v_origin - self.origin;
			deltaAngles = VectorToAngles( deltaOrigin );
			result = AbsAngleClamp360( self.angles[1] - deltaAngles[1] );
		}
	}
	
	return result;
}

function BB_ActorGetFatalDamageLocation()
{
/#	
	if( IsDefined( level._debug_damage_location ) )
		return level._debug_damage_location;
#/
	sHitLoc = self.damagelocation;
	
	if( IsDefined( sHitLoc ) )
	{
		if( ( IsInArray( array( "helmet", "head", "neck" ), sHitLoc ) ) )
			return "head";
		
		if( ( IsInArray( array( "torso_upper", "torso_mid" ), sHitLoc ) ) )
			return "chest";
		
		if( ( IsInArray( array( "torso_lower" ), sHitLoc ) ) )
			return "hips";
		
		if( ( IsInArray( array( "right_arm_upper", "right_arm_lower", "right_hand", "gun" ), sHitLoc ) ) )
			return "right_arm";
		
		if( ( IsInArray( array( "left_arm_upper", "left_arm_lower", "left_hand" ), sHitLoc ) ) )
			return "left_arm";
		
		if( ( IsInArray( array( "right_leg_upper", "left_leg_upper", "right_leg_lower", "left_leg_lower", "right_foot", "left_foot" ), sHitLoc ) ) )
			return "legs";
	}
	
	randomLocs = array( "chest", "hips" );
	return randomLocs[ RandomInt( randomLocs.size ) ];
}

function GetAngleUsingDirection( direction )
{
	directionYaw = VectorToAngles(direction)[1];
	yawDiff =  directionYaw - self.angles[1];
	yawDiff = yawDiff * (1.0 / 360.0);
	flooredYawDiff = floor(yawDiff + 0.5);
	turnAngle = (yawDiff - flooredYawDiff) * 360.0;
	
	///# recordEntText( "YawAngle: " + AbsAngleClamp360( turnAngle ), self, RED, "Animscript" ); #/
			
	return AbsAngleClamp360( turnAngle );
}


function wasAtCoverNode()
{
	if( IsDefined( self.prevNode ) )
	{
		if( ( (self.prevNode.type == "Cover Left") || (self.prevNode.type == "Cover Right") || (self.prevNode.type == "Cover Pillar") || (self.prevNode.type == "Cover Stand" || self.prevNode.type == "Conceal Stand") || (self.prevNode.type == "Cover Crouch" || self.prevNode.type == "Cover Crouch Window" || self.prevNode.type == "Conceal Crouch" ) ) )
			return true;
	}
	
	return false;
}

function BB_GetLocomotionExitYaw( blackboard, yaw )
{
	exitYaw = undefined;
	
	if( self HasPath() )
	{			
		predictedLookAheadInfo = self PredictExit();
		status = predictedLookAheadInfo["path_prediction_status"];
		
		if( DistanceSquared( self.origin, self.pathgoalpos ) <= 64 * 64 )
		{
			return -1;
		}
	
		if( status == 3 )
		{
			start = self.origin;
			end = start + VectorScale( ( 0, predictedLookAheadInfo["path_prediction_travel_vector"][1], 0 ), 100 );
			
			angleToExit = VectorToAngles( predictedLookAheadInfo["path_prediction_travel_vector"] )[1];
			exitYaw = AbsAngleClamp360( angleToExit - self.prevnode.angles[1] );	
		}
		else if( status == 4 )
		{
			start = self.origin;
			end = start + VectorScale( ( 0, predictedLookAheadInfo["path_prediction_travel_vector"][1], 0 ), 100 );
				
			angleToExit = VectorToAngles( predictedLookAheadInfo["path_prediction_travel_vector"] )[1];
			exitYaw = AbsAngleClamp360( angleToExit - self.angles[1] );	
		}
		else if( status == 0 )
		{
			if( wasAtCoverNode() && DistanceSquared( self.prevNode.origin, self.origin ) < (5 * 5) )
			{
				end = self.pathgoalpos;
				
				angleToDestination = VectorToAngles( end - self.origin )[1];
				angleDifference = AbsAngleClamp360( angleToDestination - self.prevnode.angles[1] );
				///#recordEntText( "Exit Yaw: "+angleDifference, self, RED, "Animscript" );#/
				return angleDifference;
			}
			
			start = predictedLookAheadInfo["path_prediction_start_point"];
			end = start + predictedLookAheadInfo["path_prediction_travel_vector"];
			
			exitYaw = GetAngleUsingDirection( predictedLookAheadInfo["path_prediction_travel_vector"] );		
		}
		else if( status == 2 )
		{	
			if( DistanceSquared( self.origin, self.pathgoalpos ) <= 64 * 64 )
			{
				///#recordEntText( "Exit Yaw: undefined", self, RED, "Animscript" );#/
				return undefined;
			}
			
			if( wasAtCoverNode() && DistanceSquared( self.prevNode.origin, self.origin ) < (5 * 5) )
			{
				end = self.pathgoalpos;
				
				angleToDestination = VectorToAngles( end - self.origin )[1];
				angleDifference = AbsAngleClamp360( angleToDestination - self.prevnode.angles[1] );
				///#recordEntText( "Exit Yaw: "+angleDifference, self, RED, "Animscript" );#/
				return angleDifference;
			}
			
			start = self.origin;
			end = self.pathgoalpos;
			
			exitYaw = GetAngleUsingDirection( VectorNormalize( end - start ) );			
		}
	}
	
	/#
	if ( IsDefined( exitYaw ) )
	{
		Record3DText( "Exit Yaw: " + Int( exitYaw ), self.origin - ( 0, 0, 5 ), ( 1, 0, 0 ), "Animscript", undefined, 0.4 );
	}
	#/
	
	return exitYaw;
}

function BB_GetLocomotionFaceEnemyQuadrant()
{
	/#
	// Used by cp_ai_arrival to force a tactical walk direction
	walkString = GetDvarString( "tacticalWalkDirection" );
	switch( walkString )
	{
		case "RIGHT":
			return "locomotion_face_enemy_right";							
		case "LEFT":
			return "locomotion_face_enemy_left";
		case "BACK":
			return "locomotion_face_enemy_back";			  
	}
	#/
	
	if( IsDefined( self.relativedir ) )
	{
		direction = self.relativedir;
		
		switch( direction )
		{
			case 0:
				return "locomotion_face_enemy_front";
			case 1:
				return "locomotion_face_enemy_front";
			case 2:
				return "locomotion_face_enemy_right";							
			case 3:
				return "locomotion_face_enemy_left";
			case 4:
				return "locomotion_face_enemy_back";		
		}
	}
	
	return "locomotion_face_enemy_front";
}


function BB_GetLocomotionPainType()
{
	if( self HasPath() )
	{
		
		predictedLookAheadInfo = self PredictPath();
		status = predictedLookAheadInfo["path_prediction_status"];
		
		startPos = self.origin;	
		
		// if AI is going in a straight line to the goal, then just need to make sure that, AI will not overshoot
		furthestPointTowardsGoalClear = true;
		
		if( status == 2 )
		{
			furthestPointAlongTowardsGoal = startPos + VectorScale( self.lookaheaddir, 300 );
			furthestPointTowardsGoalClear = self FindPath( startPos, furthestPointAlongTowardsGoal, false, false ) && self MayMoveToPoint( furthestPointAlongTowardsGoal );
		}
				
		if( furthestPointTowardsGoalClear )
		{
			forwardDir = AnglesToForward( self.angles );
			possiblePainTypes = [];
		
			endPos = startPos + VectorScale( forwardDir, 300 );
			if( self MayMoveToPoint( endpos ) && self FindPath( startPos, endpos, false, false ) )
			{
				possiblePainTypes[possiblePainTypes.size] = "locomotion_moving_pain_long";
			}
			
			endPos = startPos + VectorScale( forwardDir, 200 );
			if( self MayMoveToPoint( endpos ) && self FindPath( startPos, endpos, false, false ) )
			{
				possiblePainTypes[possiblePainTypes.size] = "locomotion_moving_pain_med";			
			}
			
			endPos = startPos + VectorScale( forwardDir, 150 );
			if( self MayMoveToPoint( endpos ) && self FindPath( startPos, endpos, false, false )  )
			{
				possiblePainTypes[possiblePainTypes.size] = "locomotion_moving_pain_short";			
			}
			
			if( possiblePainTypes.size )
			{
				return array::random( possiblePainTypes );
			}
		}
	}	
	
	return "locomotion_inplace_pain";		
}

function BB_GetLookaheadAngle()
{
	return AbsAngleClamp360( VectorToAngles( self.lookaheaddir )[1] - self.angles[1] );
}

function BB_GetPreviousCoverNodeType()
{	
	return AiUtility::getCoverType( self.prevNode );	
}


function BB_ActorGetTrackingTurnYaw()
{
	PixBeginEvent( "BB_ActorGetTrackingTurnYaw" );

	if( IsDefined( self.enemy ) )
	{
		// If the enemy is less than the perfect info distance to enemy it looks better
		// to just turn to the enemy, instead of using smaller turns.
		
		// TODO(David Young 2-16-15): Look into using the highlyawareradius instead of a define.
		if ( Distance2D( self.enemy.origin, self.origin ) < ( (180) * (180) ) )
		{
			predictedPos = self.enemy.origin;
			
			// Cheating the enemy's position, don't react to the enemy.
			self.newEnemyReaction = false;
		}
		else
		{
			predictedPos = self LastKnownPos( self.enemy );
		}
		
		if( IsDefined( predictedPos ) )
		{
			turnYaw = AbsAngleClamp360( self.angles[1] - (VectorToAngles(predictedPos-self.origin)[1]) );
			PixEndEvent();
			return turnYaw;
		}
	}
	
	PixEndEvent();
    return undefined;
}

function BB_GetWeaponClass()
{
	// Default to rifle.
	return "rifle";
}

// ------- UTILITY -----------//
function notStandingCondition( behaviorTreeEntity )
{
	if( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" ) != "stand" )
	{
		return true;
	}
	
	return false;
}

function notCrouchingCondition( behaviorTreeEntity )
{
	if( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" ) != "crouch" )
	{
		return true;
	}
	
	return false;
}

function scriptStartRagdoll( behaviorTreeEntity )
{
	behaviorTreeEntity StartRagdoll();
}


// ------- EXPOSED MELEE -----------//
function private prepareForExposedMelee( behaviorTreeEntity )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );
	AiUtility::meleeAcquireMutex( behaviorTreeEntity );
	
	currentStance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	
	if(isDefined(behaviorTreeEntity.enemy) && isDefined(behaviorTreeEntity.enemy.vehicletype) && isSubStr(behaviorTreeEntity.enemy.vehicletype,"firefly") )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_melee_enemy_type", "fireflyswarm");
	}
	
	if( currentStance == "crouch" )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
	}	
}


/*
///BehaviorUtilityDocBegin
"Name: isFrustrated \n"
"Summary: When AI has nothing to do from the cover, then AI's frustration will grow. When he will perform one of the actions, he will reset it.
This should give AI a better behavior to handle situations where he has nothing to do that will be considered as effective attack."
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function isFrustrated( behaviorTreeEntity )
{
	return ( IsDefined( behaviorTreeEntity.frustrationLevel ) && behaviorTreeEntity.frustrationLevel > 0 );
}

/*
///BehaviorUtilityDocBegin
"Name: updateFrustrationLevel \n"
"Summary: When AI has nothing to do from the cover, then AI's frustration will grow. We track this using frustrationLevel
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function updateFrustrationLevel( behaviorTreeEntity )
{
	if( !behaviorTreeEntity IsBadGuy() )
	{
		return false;
	}
	
	if( !IsDefined( behaviorTreeEntity.frustrationLevel ) )
	{
		behaviorTreeEntity.frustrationLevel = 0;
	}
		
	if( !IsDefined( behaviorTreeEntity.enemy ) )
	{
		behaviorTreeEntity.frustrationLevel = 0;
		return false;
	}
		
	/#record3DText( "frustrationLevel " + behaviorTreeEntity.frustrationLevel, behaviortreeentity.origin, ( 1, .5, 0 ), "Animscript" );#/
	
	if( IsActor( behaviorTreeEntity.enemy ) || IsPlayer( behaviorTreeEntity.enemy ) )
	{
		if( !IsDefined( behaviorTreeEntity.frustrationLevel ) || behaviorTreeEntity.frustrationLevel < 0 )
			behaviorTreeEntity.frustrationLevel = 0;
			
		// AI is aware of the enemy for a while?
		isAwareOfEnemy = ( GetTime() - behaviorTreeEntity LastKnownTime( behaviorTreeEntity.enemy ) ) < 10 * 1000;
		
		// AI has seen the enemy for a while?
		if( behaviorTreeEntity.frustrationLevel == 4 )
			hasSeenEnemy = behaviorTreeEntity SeeRecently( behaviorTreeEntity.enemy, 2 );
		else
			hasSeenEnemy = behaviorTreeEntity SeeRecently( behaviorTreeEntity.enemy, 5 );
		
		// AI has attacked the enemy recently
		hasAttackedEnemyRecently = behaviorTreeEntity AttackedRecently( behaviorTreeEntity.enemy, 5 );
		
		if( ( !isAwareOfEnemy || IsActor( behaviorTreeEntity.enemy ) )
			&& !hasSeenEnemy && !hasAttackedEnemyRecently )
		{
			if( behaviorTreeEntity.frustrationLevel < 4 )
				behaviorTreeEntity.frustrationLevel++;
			
			return true;	
		}
	
		if( hasAttackedEnemyRecently || hasSeenEnemy )
		{
			behaviorTreeEntity.frustrationLevel--;
			
			if( behaviorTreeEntity.frustrationLevel < 0 )
				behaviorTreeEntity.frustrationLevel = 0;
			
			return true;
		}
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: flagEnemyUnAttackableService \n"
"Summary: AI will mark the enemy unattackable for certain amount of time. Desired result will be that he will look for some other enemy to fight against.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function flagEnemyUnAttackableService( behaviorTreeEntity )
{
	behaviorTreeEntity FlagEnemyUnattackable();	
}

/*
///BehaviorUtilityDocBegin
"Name: isLastKnownEnemyPositionApproachable \n"
"Summary: Returns true if the last known position of the enemy is within goal and pathable.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function isLastKnownEnemyPositionApproachable( behaviorTreeEntity )
{	
	if( IsDefined( behaviorTreeEntity.enemy ) )	   
	{
		lastKnownPositionOfEnemy = behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy );
			
		if( behaviorTreeEntity IsInGoal( lastKnownPositionOfEnemy ) 
		   && behaviorTreeEntity FindPath( behaviorTreeEntity.origin, lastKnownPositionOfEnemy, true, false ) 
			)
			{	
				return true;
			}	
	}
		
	return false;
}


/*
///BehaviorUtilityDocBegin
"Name: tryAdvancingOnLastKnownPositionBehavior \n"
"Summary: AI will try to run to the last known position of the enemy as long as it is within the goal.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function tryAdvancingOnLastKnownPositionBehavior( behaviorTreeEntity )
{	
	if( IsDefined( behaviorTreeEntity.enemy ) )	   
	{
		if( ( isdefined( behaviorTreeEntity.aggressiveMode ) && behaviorTreeEntity.aggressiveMode ) )
		{
			lastKnownPositionOfEnemy = behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy );
			
			if( behaviorTreeEntity IsInGoal( lastKnownPositionOfEnemy ) 
			   && behaviorTreeEntity FindPath( behaviorTreeEntity.origin, lastKnownPositionOfEnemy, true, false ) 
			  )
			{				
				behaviorTreeEntity UsePosition( lastKnownPositionOfEnemy, lastKnownPositionOfEnemy );
				
				AiUtility::setNextFindBestCoverTime( behaviorTreeEntity, undefined );
						
				return true;				
			}
		}
	}
		
	return false;
}


/*
///BehaviorUtilityDocBegin
"Name: tryGoingToClosestNodeToEnemyBehavior \n"
"Summary: AI will try to run to the closest node to the enemy as long as it is within the goal.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function tryGoingToClosestNodeToEnemyBehavior( behaviorTreeEntity )
{	
	if( IsDefined( behaviorTreeEntity.enemy ) )	 
	{
		if( ( isdefined( behaviorTreeEntity.aggressiveMode ) && behaviorTreeEntity.aggressiveMode ) )
		{
			lastKnownPositionOfEnemy = behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy );
			closestRandomNode = behaviorTreeEntity FindBestCoverNodes( RandomIntRange( 200, 400 ), lastKnownPositionOfEnemy )[0];
		}
		else
		{
			closestRandomNode = behaviorTreeEntity FindBestCoverNodes( behaviorTreeEntity.engageMinDist * 0.8, behaviorTreeEntity.enemy.origin )[0];
		}
		
       if( IsDefined( closestRandomNode ) 
		   && behaviorTreeEntity IsInGoal( closestRandomNode.origin )
		   && behaviorTreeEntity FindPath( behaviorTreeEntity.origin, closestRandomNode.origin, true, false ) 
		  )
		{
			useCoverNodeWrapper( behaviorTreeEntity, closestRandomNode );
							
			return true;				
		}
	}			
	
	return false;
}


/*
///BehaviorUtilityDocBegin
"Name: tryRunningDirectlyToEnemyBehavior \n"
"Summary: AI will try to run directly to enemy as long as it is within the goal. This is a little cheating as we share the origin directly\n
with the enemy, but in combat, it will make AI look smarter."
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function tryRunningDirectlyToEnemyBehavior( behaviorTreeEntity )
{	
	if( IsDefined( behaviorTreeEntity.enemy ) && ( isdefined( behaviorTreeEntity.aggressiveMode ) && behaviorTreeEntity.aggressiveMode )  )
	{
		origin = behaviorTreeEntity.enemy.origin;
		
		if( behaviorTreeEntity IsInGoal( origin ) 
		   && behaviorTreeEntity FindPath( behaviorTreeEntity.origin, origin, true, false ) 
		  )
		{
			behaviorTreeEntity UsePosition( origin, origin );
			
			AiUtility::setNextFindBestCoverTime( behaviorTreeEntity, undefined );
					
			return true;				
		}
	}
		
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: shouldReactToNewEnemy \n"
"Summary: returns true if AI should react to enemy.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldReactToNewEnemy( behaviorTreeEntity )
{
	// TODO(David Young 4-25-15): Currently disabling reactions till they are more reliable.
	return false;

	if( ( isdefined( behaviorTreeEntity.newEnemyReaction ) && behaviorTreeEntity.newEnemyReaction ) )
	{
		return true;	
	}
	
	stance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );

	return stance == "stand" && behaviorTreeEntity.newEnemyReaction && !(behaviorTreeEntity IsAtCoverNodeStrict());
}

/*
///BehaviorUtilityDocBegin
"Name: hasWeaponMalfunctioned \n"
"Summary: returns true if AI has malfunction state.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function hasWeaponMalfunctioned( behaviorTreeEntity )
{
	return( ( isdefined( behaviorTreeEntity.malFunctionReaction ) && behaviorTreeEntity.malFunctionReaction ) );
}

/*
///BehaviorUtilityDocBegin
"Name: isSafeFromGrenades\n"
"Summary: returns if the AI is safe from grenades.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function isSafeFromGrenades( entity )
{
	if( IsDefined( entity.grenade ) &&
		IsDefined( entity.grenade.weapon ) &&
		entity.grenade !== entity.knownGrenade &&
		!entity IsSafeFromGrenade() )
	{
		percentRadius = Distance( entity.grenade.origin, entity.origin ) / entity.grenade.weapon.explosionradius;
		
		if ( entity.grenadeAwareness >= percentRadius )
		{
			return true;
		}
		else
		{
			entity.knownGrenade = entity.grenade;
			return false;
		}
	}
		
	// if this AI is not supposed to be aware of the grenades then just assume that he is safe.
	return true;	
}

/*
///BehaviorUtilityDocBegin
"Name: inGrenadeBlastRadius\n"
"Summary: returns true if the AI is within the blast radius of an enemy grenade.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function inGrenadeBlastRadius( entity )
{
	return !entity IsSafeFromGrenade();
}

/*
///BehaviorUtilityDocBegin
"Name: recentlySawEnemy \n"
"Summary: returns true if an AI has recently seen the enemy (within 4 sec).\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function recentlySawEnemy( behaviorTreeEntity )
{
	const RECENTLY_SEEN_TIME = 6;
	
	if( IsDefined( behaviorTreeEntity.enemy ) && behaviorTreeEntity SeeRecently( behaviorTreeEntity.enemy, RECENTLY_SEEN_TIME ) )
		return true;
	
	return false;	
}

/*
///BehaviorUtilityDocBegin
"Name: shouldOnlyFireAccurately \n"
"Summary: returns at the aitype accurateFire flag.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldOnlyFireAccurately( behaviorTreeEntity )
{
	if( ( isdefined( behaviorTreeEntity.accurateFire ) && behaviorTreeEntity.accurateFire ) )
		return true;
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: shouldBeAggressive \n"
"Summary: returns at the aitype agressiveMode flag.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldBeAggressive( behaviorTreeEntity )
{
	if( ( isdefined( behaviorTreeEntity.aggressiveMode ) && behaviorTreeEntity.aggressiveMode ) )
		return true;
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: useCoverNodeWrapper \n"
"Summary: Tells an actor to use a given cover node. Also updates nextFindBestCoverTime based on engagement distance.\n"
"MandatoryArg: node\n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function useCoverNodeWrapper( behaviorTreeEntity, node )
{
	sameNode = behaviorTreeEntity.node === node;

	behaviorTreeEntity UseCoverNode( node );		
	
	if ( !sameNode )
	{
		// TODO(David Young 4-10-14): This fixes issues where cover_mode is still set to cover_alert
		// even when AI's are walking around.  Need to find a better way of doing this.
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode", "cover_mode_none" );
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_previous_cover_mode", "cover_mode_none" );
	}
	
	setNextFindBestCoverTime( behaviorTreeEntity, node );
}

function setNextFindBestCoverTime( behaviorTreeEntity, node )
{
	currentTime = GetTime();		
			
	if( IsDefined( behaviorTreeEntity.enemy ) )
	{
		dist = undefined;
	
		if( behaviorTreeEntity HasPath() )
		{
			dist = Distance2DSquared( behaviorTreeEntity.pathgoalpos, behaviorTreeEntity.enemy.origin );
		}
		else
		{
			dist = Distance2DSquared( behaviorTreeEntity.origin, behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy ) );
		}
			
		if( dist < ( (behaviorTreeEntity.engageMinDist) * (behaviorTreeEntity.engageMinDist) ) )
		{
			behaviorTreeEntity.nextFindBestCoverTime = currentTime + RandomIntRange( 6000, 8000 );
		}
		else if( dist < ( (behaviorTreeEntity.engagemaxdist) * (behaviorTreeEntity.engagemaxdist) ) )
		{
			behaviorTreeEntity.nextFindBestCoverTime = currentTime + RandomIntRange( 8000, 10000 );
		}
		else
		{
			behaviorTreeEntity.nextFindBestCoverTime = currentTime + RandomIntRange( 6000, 8000 );
		}
	}
	else
	{
		behaviorTreeEntity.nextFindBestCoverTime = currentTime +  behaviorTreeEntity.coversearchinterval;
	}
		
}

/*
///BehaviorUtilityDocBegin
"Name: trackCoverParamsService \n"
"Summary: tracks behaviorTreeEntity.coverNode and nextFindBestCoverTime.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function trackCoverParamsService( behaviorTreeEntity )
{
	if( IsDefined( behaviorTreeEntity.node ) 
	   && behaviorTreeEntity IsAtCoverNodeStrict() 
	   && behaviorTreeEntity ShouldUseCoverNode() )
	{
		if( !IsDefined( behaviorTreeEntity.coverNode ) )
		{
			behaviorTreeEntity.coverNode = behaviorTreeEntity.node;
			setNextFindBestCoverTime( behaviorTreeEntity, behaviorTreeEntity.node );
		}
		
		return;
	}
	
	behaviorTreeEntity.coverNode = undefined;	
}


function chooseBestCoverNodeASAP( behaviorTreeEntity )
{
	if( !IsDefined( behaviorTreeEntity.enemy ) )
		return false;
	
	node = AiUtility::getBestCoverNodeIfAvailable( behaviorTreeEntity );
	if ( IsDefined( node ) )
	{
		useCoverNodeWrapper( behaviorTreeEntity, node );
	}
}

/*
///BehaviorUtilityDocBegin
"Name: shouldChooseBetterCover \n"
"Summary: Returns true if AI should find a better cover node soon.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldChooseBetterCover( behaviorTreeEntity )
{			
	const NEAR_ARRIVAL_DIST_SQ = 64 * 64;		
	
	if( behaviorTreeEntity ai::has_behavior_attribute( "stealth" ) 
	    && behaviorTreeEntity ai::get_behavior_attribute( "stealth" ) )
	{
		return false;
	}	

	if ( ( isdefined( behaviorTreeEntity.avoid_cover ) && behaviorTreeEntity.avoid_cover ) )
	{
		return false;
	}
	
	if( behaviorTreeEntity IsInAnyBadPlace() )
	{
		return true;
	}
		
	if( IsDefined( behaviorTreeEntity.enemy ) )
	{
		shouldUseCoverNodeResult		= false;
		shouldBeBoredAtCurrentCover 	= false;	
		aboutToArriveAtCover 			= false; 
		isWithinEffectiveRangeAlready 	= false;
		isLookingAroundForEnemy			= false;
				
		// SHOULD HOLD GROUND AGAINST THE ENEMY - Withing pathEnemyFightDist
		if( behaviorTreeEntity ShouldHoldGroundAgainstEnemy() )
			return false;
			
		// ABOUT TO ARRIVE AT COVER	
		if( behaviorTreeEntity HasPath() && IsDefined( behaviorTreeEntity.arrivalFinalPos ) && IsDefined( behaviorTreeEntity.pathGoalPos ) && self.pathGoalPos == behaviorTreeEntity.arrivalFinalPos )
		{
			if( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.arrivalFinalPos ) < NEAR_ARRIVAL_DIST_SQ )
			{
				aboutToArriveAtCover = true;	
			}
		}
					
		// COVER RANGES ARE VALID
		shouldUseCoverNodeResult = behaviorTreeEntity ShouldUseCoverNode();
		
		// ONLY CARE FOR ENGAGEMENT DISTANCE AND LOOKING AROUND IF WITHIN THE GOAL
		if( self IsAtGoal() )
		{
			// IS WITHIN APPROPRIATE ENGAGEMENT DISTANCE BAND
			if( shouldUseCoverNodeResult && IsDefined( behaviorTreeEntity.node ) && self IsAtGoal() )
			{
				lastKnownPos = behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy );
				
				dist = Distance2D( behaviorTreeEntity.origin, lastKnownPos );
				
				if( dist > behaviorTreeEntity.engageMinFalloffDist && dist <= behaviorTreeEntity.engageMaxFalloffDist )
					isWithinEffectiveRangeAlready = true;
			}
			
			// SHOULD BE BORED AT CURRENT COVER
			shouldBeBoredAtCurrentCover = !isWithinEffectiveRangeAlready && behaviorTreeEntity IsAtCoverNode() && ( GetTime() > self.nextFindBestCoverTime );
			
			// IS LOOKING AROUND ENEMY AND FRUSTRATED
			if( !shouldUseCoverNodeResult )
			{
				if( IsDefined( behaviorTreeEntity.frustrationLevel ) && behaviorTreeEntity.frustrationLevel > 0 && behaviorTreeEntity HasPath() )
					isLookingAroundForEnemy = true;
			}
		}
		
		shouldLookForBetterCover = !isLookingAroundForEnemy 
									&& !aboutToArriveAtCover 
									&& !isWithinEffectiveRangeAlready
									&& ( !shouldUseCoverNodeResult || shouldBeBoredAtCurrentCover || !self IsAtGoal() );
	
		/#	
		if( shouldLookForBetterCover )
			color = ( 0, 1, 0 );
		else
			color = ( 1, 0, 0 );
		
		recordEntText( "ChooseBetterCoverReason: SUC:" + shouldUseCoverNodeResult 
			           + " LAE:" + isLookingAroundForEnemy
			           + " ARR:" + aboutToArriveAtCover
			           + " EFF:" + isWithinEffectiveRangeAlready
			           + " BOR:" + shouldBeBoredAtCurrentCover
			           , behaviorTreeEntity, color, "Animscript" );
		#/			
	}
	else
	{
		return !( behaviorTreeEntity ShouldUseCoverNode() && behaviorTreeEntity IsApproachingGoal() );
	}
	
	return shouldLookForBetterCover;
}


/*
///BehaviorUtilityDocBegin
"Name: chooseBetterCoverServiceCodeVersion \n"
"Summary: Finds a better cover node using faster code version.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function chooseBetterCoverServiceCodeVersion( behaviorTreeEntity )
{
	if( isDefined( behaviorTreeEntity.stealth ) && behaviorTreeEntity ai::get_behavior_attribute( "stealth" ) )
	{
		return false;
	}

	if ( ( isdefined( behaviorTreeEntity.avoid_cover ) && behaviorTreeEntity.avoid_cover ) )
	{
		return false;
	}	

	if ( !aiutility::isSafeFromGrenades( behaviorTreeEntity ) )
	{
		behaviorTreeEntity.nextFindBestCoverTime = 0;
	}

	newNode = behaviorTreeEntity ChooseBetterCoverNode();

	if( IsDefined( newNode ) )
	{			
		useCoverNodeWrapper( behaviorTreeEntity, newNode );
		return true;		
	}

	setNextFindBestCoverTime( behaviorTreeEntity, undefined );

	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: chooseBetterCoverService \n"
"Summary: Finds a better cover node.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function private chooseBetterCoverService( behaviorTreeEntity )
{		
	shouldChooseBetterCoverResult = shouldChooseBetterCover( behaviorTreeEntity );
			
	// Only search for a new cover node if the AI isn't trying to keep their current claimed node.
	if( shouldChooseBetterCoverResult && !behaviorTreeEntity.keepClaimedNode	)
	{			
		transitionRunning = behaviorTreeEntity ASMIsTransitionRunning();
		subStatePending = behaviorTreeEntity ASMIsSubStatePending();
		transDecRunning = behaviorTreeEntity AsmIsTransDecRunning();
		isBehaviorTreeInRunningState = behaviorTreeEntity GetBehaviortreeStatus() == 5;
	
		if( !transitionRunning && !subStatePending && !transDecRunning && isBehaviorTreeInRunningState )
		{			
			node = AiUtility::getBestCoverNodeIfAvailable( behaviorTreeEntity );
			goingToDifferentNode =  IsDefined( node ) && ( !IsDefined( behaviorTreeEntity.node ) || node != behaviorTreeEntity.node );
					
			if ( goingToDifferentNode )
			{
				useCoverNodeWrapper( behaviorTreeEntity, node );
				return true;
			}			
			
			// Set the next find time, even though we did not find a cover to go to
			setNextFindBestCoverTime( behaviorTreeEntity, undefined );
		}
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: refillAmmo \n"
"Summary: Refills the bullets in clip of the AI.\n"
"MandatoryArg: AI behaviorTreeEntity\n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function refillAmmo( behaviorTreeEntity )
{
	if ( behaviorTreeEntity.weapon != level.weaponNone )
	{
		behaviorTreeEntity.bulletsInClip = behaviorTreeEntity.weapon.clipSize;
	}
}

/*
///BehaviorUtilityDocBegin
"Name: hasAmmo \n"
"Summary: Returns true if AI has any ammo left.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function hasAmmo( behaviorTreeEntity )
{
	if( behaviorTreeEntity.bulletsInClip > 0 )
		return true;
	else
		return false;
}

function hasLowAmmo( behaviorTreeEntity )
{
	if ( behaviorTreeEntity.weapon != level.weaponNone )
	{
		return behaviorTreeEntity.bulletsInClip < (behaviorTreeEntity.weapon.clipSize * 0.2);
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: HasEnemy \n"
"Summary: Returns true if AI has enemy.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function hasEnemy( behaviorTreeEntity )
{
	if( IsDefined( behaviorTreeEntity.enemy ) )
	{		
		return true;
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: getBestCoverNodeIfAvailable \n"
"Summary: Get a good covernode to take against enemy.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function getBestCoverNodeIfAvailable( behaviorTreeEntity )
{
	node = behaviorTreeEntity FindBestCoverNode();
		
	if ( !IsDefined(node) )
	{
		return undefined;
	}
	
	if( behaviorTreeEntity NearClaimNode() )
	{
		currentNode = self.node;
	}
	
	if ( IsDefined( currentNode ) && node == currentNode )
	{
		return undefined;
	}
	
	// work around FindBestCoverNode() resetting my .node in rare cases involving overlapping nodes
	// This prevents us from thinking we've found a new node somewhere when in reality it's the one we're already at, so we won't abort our script.
	if ( IsDefined( behaviorTreeEntity.coverNode ) && node == behaviorTreeEntity.coverNode )
	{
		return undefined;
	}
	
	return node;
}

function getSecondBestCoverNodeIfAvailable( behaviorTreeEntity )
{
	// when fixed node is set, AI should not try to find a better cover on its own.
	if( IsDefined( behaviorTreeEntity.fixedNode ) && behaviorTreeEntity.fixedNode )
		return undefined;
		
	nodes = behaviorTreeEntity FindBestCoverNodes( behaviorTreeEntity.goalRadius, behaviorTreeEntity.origin );
		
	if ( nodes.size > 1 )
	{
		node = nodes[1];
	}
		
	if ( !IsDefined(node) )
	{
		return undefined;
	}
	
	if( behaviorTreeEntity NearClaimNode() )
	{
		currentNode = self.node;
	}
	
	if ( IsDefined( currentNode ) && node == currentNode )
	{
		return undefined;
	}
	
	// work around FindBestCoverNode() resetting my .node in rare cases involving overlapping nodes
	// This prevents us from thinking we've found a new node somewhere when in reality it's the one we're already at, so we won't abort our script.
	if ( IsDefined( behaviorTreeEntity.coverNode ) && node == behaviorTreeEntity.coverNode )
	{
		return undefined;
	}
	
	return node;
}

/*
///BehaviorUtilityDocBegin
"Name: getCoverType \n"
"Summary: returns a covernode type.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function getCoverType( node )
{
	if( IsDefined( node ) )
	{			
		if( (node.type == "Cover Pillar") )
			return "cover_pillar";
		else if( (node.type == "Cover Left") )			
			return "cover_left";
		else if( (node.type == "Cover Right") )			
			return "cover_right";
		else if( (node.type == "Cover Stand" || node.type == "Conceal Stand") )			
			return "cover_stand";
		else if( (node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch" ) )				
			return "cover_crouch";
		else if( (node.type == "Exposed") || (node.type == "Guard") )
			return "cover_exposed";				
	}
	
	return "cover_none";
}

/*
///BehaviorUtilityDocBegin
"Name: isCoverConcealed \n"
"Summary: checks if node is a concealed node.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function isCoverConcealed( node )
{
	if ( IsDefined( node ) )
	{
		return (node.type == "Conceal Crouch" || node.type == "Conceal Stand");
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: canSeeEnemyWrapper \n"
"Summary: checks if the enemy can be seen from a node or from exposed.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function canSeeEnemyWrapper()
{
	if( !IsDefined( self.enemy ) )
		return false;
	
	if( !IsDefined( self.node ) )
	{
		return self canSee( self.enemy );
	}
	else
	{
		node = self.node;		
		enemyEye = self.enemy GetEye();
		yawToEnemy = (AngleClamp180(node.angles[1] - VectorToAngles(enemyEye-node.origin)[1]));
		
		// check corner yaw first
		if( (node.type == "Cover Left") || (node.type == "Cover Right") )
		{
			// we don't need anything like this for pillar as we switch sides if needed.	
			if( yawToEnemy > 60 || yawToEnemy < -60 )
				return false;
				
			// if this is stand node, then AI can not shoot in "Over" mode
			if( ( (isdefined(node.spawnflags)&&((node.spawnflags & 4) == 4))) )
			{
				if( (node.type == "Cover Left") && yawToEnemy > 10 )
				{
					///# recordLine( self.origin, self.enemy.origin, RED, "Animscript", self ); #/
					return false;
				}
				
				if( (node.type == "Cover Right") && yawToEnemy < -10 )
				{
					///# recordLine( self.origin, self.enemy.origin, RED, "Animscript", self ); #/
					return false;
				}
			}
		}
		
		nodeOffset = (0,0,0);
				
		if( (node.type == "Cover Pillar") )
		{
			Assert( !( (isdefined(node.spawnflags)&&((node.spawnflags & 2048) == 2048))) || !( (isdefined(node.spawnflags)&&((node.spawnflags & 1024) == 1024))) );
			canSeeFromLeft = true;
			canSeeFromRight = true;
			
			// PILLAR LEFT		
			nodeOffset = (-32, 3.7, 60);
			lookFromPoint = calculateNodeOffsetPosition( node, nodeOffset );
			canSeeFromLeft = sightTracePassed( lookFromPoint, enemyEye, false, undefined );
		
			// PILLAR RIGHT		
			nodeOffset = (32, 3.7, 60);
			lookFromPoint = calculateNodeOffsetPosition( node, nodeOffset );
			canSeeFromRight = sightTracePassed( lookFromPoint, enemyEye, false, undefined );
		
			return ( canSeeFromRight || canSeeFromLeft );
		}
		else 
		{
			if( (node.type == "Cover Left") )
			{
				nodeOffset = (-36, 7, 63);
			}
			else if( (node.type == "Cover Right") )
			{
				nodeOffset = (36, 7, 63);
			}
			else if( (node.type == "Cover Stand" || node.type == "Conceal Stand") )
			{
				nodeOffset = (-3.7, -22, 63);
			}
			else if( (node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch" ) )
			{
				nodeOffset = (3.5, -12.5, 45);
			}
			
			lookFromPoint = calculateNodeOffsetPosition( node, nodeOffset );
						
			if( sightTracePassed( lookFromPoint, enemyEye, false, undefined ) )
			{
				///# recordLine( lookFromPoint, self.enemy.origin, GREEN, "Animscript", self ); #/
				return true;
			}
			else
			{
				///# recordLine( lookFromPoint, self.enemy.origin, RED, "Animscript", self ); #/
				return false;
			}
		}
	
	}
}

function calculateNodeOffsetPosition( node, nodeOffset )
{
	right 	= AnglesToRight( node.angles );
	forward = AnglesToForward( node.angles );
		
	return node.origin + VectorScale( right, nodeOffset[0] ) + VectorScale( forward, nodeOffset[1] ) + ( 0, 0, nodeOffset[2] );
}

/*
///BehaviorUtilityDocBegin
"Name: getHighestNodeStance \n"
"Summary: returns the highest stance allowed at a given cover node.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function getHighestNodeStance( node ) 
{
	assert( IsDefined( node ) );

	if( ( (isdefined(node.spawnflags)&&((node.spawnflags & 4) == 4))) ) // check for stand
		return "stand";
	
	if( ( (isdefined(node.spawnflags)&&((node.spawnflags & 8) == 8))) ) // check for crouch
		return "crouch";
	
	if( ( (isdefined(node.spawnflags)&&((node.spawnflags & 16) == 16))) ) // check for crouch
		return "prone";
	
	/#
	ErrorMsg( node.type + " node at"  + node.origin + " supports no stance." );
	#/
}

/*
///BehaviorUtilityDocBegin
"Name: isStanceAllowedAtNode \n"
"Summary: returns whether a given stance is allowed at a given cover node.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function isStanceAllowedAtNode( stance, node )
{
	assert( IsDefined( stance ) );
	assert( IsDefined( node ) );

	if( stance == "stand" && ( (isdefined(node.spawnflags)&&((node.spawnflags & 4) == 4))) )
		return true;
	
	if( stance == "crouch" && ( (isdefined(node.spawnflags)&&((node.spawnflags & 8) == 8))) )
		return true;

	if( stance == "prone" && ( (isdefined(node.spawnflags)&&((node.spawnflags & 16) == 16))) )
		return true;

	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: tryStoppingService \n"
"Summary: Clears the path if enemy is within pathEnemyFightDist.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function tryStoppingService( behaviorTreeEntity )
{
	if ( behaviorTreeEntity ShouldHoldGroundAgainstEnemy() )
	{
		behaviorTreeEntity ClearPath();
		behaviorTreeEntity.keepClaimedNode = true;
		return true;
	}

	behaviorTreeEntity.keepClaimedNode = false;
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: shouldStopMoving \n"
"Summary: Return true if enemy is within pathEnemyFightDist.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldStopMoving( behaviorTreeEntity )
{
	if ( behaviorTreeEntity ShouldHoldGroundAgainstEnemy() ) 
	{
		return true;
	}

	return false;
}

function setCurrentWeapon(weapon)
{
	self.weapon = weapon;
	self.weaponclass = weapon.weapClass;
	
	if( weapon != level.weaponNone )
		assert( IsDefined( weapon.worldModel ), "Weaopon " + weapon.name + " has no world model set in GDT." );
	
	self.weaponmodel = weapon.worldModel;
}

function setPrimaryWeapon(weapon)
{
	self.primaryweapon = weapon;
	self.primaryweaponclass = weapon.weapClass;
	
	if( weapon != level.weaponNone )
		assert( IsDefined( weapon.worldModel ), "Weaopon " + weapon.name + " has no world model set in GDT." );
}

function setSecondaryWeapon(weapon)
{
	self.secondaryweapon = weapon;
	self.secondaryweaponclass = weapon.weapClass;
	
	if( weapon != level.weaponNone )
		assert( IsDefined( weapon.worldModel ), "Weaopon " + weapon.name + " has no world model set in GDT." );
}

function keepClaimNode( behaviorTreeEntity )
{
	behaviorTreeEntity.keepClaimedNode = true;
	
	return true;
}

function releaseClaimNode( behaviorTreeEntity )
{
	behaviorTreeEntity.keepClaimedNode = false;
	
	return true;
}

/**
 * Returns the yaw angles between a node and an enemy behaviorTreeEntity
 */
function getAimYawToEnemyFromNode( behaviorTreeEntity, node, enemy )
{
	return AngleClamp180( VectorToAngles( ( behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy ) ) - node.origin )[1] - node.angles[1] );
}

/**
 * Returns the pitch angles between a node and an enemy behaviorTreeEntity
 */
function getAimPitchToEnemyFromNode( behaviorTreeEntity, node, enemy )
{
	return AngleClamp180( VectorToAngles( ( behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy ) ) - node.origin )[0] - node.angles[0] );
}


/**
 * Sets the cover direction blackboard to the front direction
 */
function chooseFrontCoverDirection( behaviorTreeEntity )
{
	coverDirection = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_cover_direction" );
	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_previous_cover_direction", coverDirection );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_cover_direction", "cover_front_direction" );
}

/*
///BehaviorUtilityDocBegin
"Name: shouldTacticalWalk \n"
"Summary: returns true if AI should tactical walk facing the enemy/target.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldTacticalWalk( behaviorTreeEntity )
{
	if( !behaviorTreeEntity HasPath() )
	{
		return false;
	}
	
	if ( ai::HasAiAttribute( behaviorTreeEntity, "forceTacticalWalk" ) &&
		ai::GetAiAttribute( behaviorTreeEntity, "forceTacticalWalk" ) )
	{
		return true;
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
		
		if( pathDist < 96 * 96 )
		{
			return true;
		}
	}

	if( behaviorTreeEntity ShouldFaceMotion() )
	{
		return false;
	}
	
	if ( !behaviorTreeEntity IsSafeFromGrenade() )
	{
		return false;
	}
	
	return true;
}

/*
///BehaviorUtilityDocBegin
"Name: shouldStealth \n"
"Summary: returns true if AI should be doing stealth behavior.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldStealth( behaviorTreeEntity )
{
	if ( isDefined( behaviorTreeEntity.stealth ) )
	{
		now = GetTime();
		
		if ( behaviorTreeEntity IsInScriptedState() )
			return false;
		
		// Make sure that while transitioning from stealth to combat the stealth reaction still takes place
		if ( behaviorTreeEntity HasValidInterrupt( "react" ) )
		{
			behaviorTreeEntity.stealth_react_last = now;
			return true;
		}	
		if ( ( isdefined( behaviorTreeEntity.stealth_reacting ) && behaviorTreeEntity.stealth_reacting ) || ( isDefined( behaviorTreeEntity.stealth_react_last ) && ( now - behaviorTreeEntity.stealth_react_last ) < 250 ) )
		{
			return true;
		}
		
		if( behaviorTreeEntity ai::has_behavior_attribute( "stealth" ) 
		    && behaviorTreeEntity ai::get_behavior_attribute( "stealth" ) )
		{
			return true;
		}
	}

	return false;
}

/*
///locomotionShouldStealth
"Name: locomotionShouldStealth \n"
"Summary: returns true if AI should be moving along a path in stealth.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function locomotionShouldStealth( behaviorTreeEntity )
{
	if ( !shouldStealth( behaviortreeentity ) )
		return false;

	if( behaviorTreeEntity HasPath() )
	{ 
		if ( isDefined( behaviorTreeEntity.arrivalFinalPos ) || isDefined( behaviorTreeEntity.pathGoalPos ) )
		{
			hasWait = ( isDefined( self.currentgoal ) && isDefined( self.currentgoal.script_wait_min ) && isDefined( self.currentgoal.script_wait_max ) );
			if ( hasWait )
				hasWait = self.currentgoal.script_wait_min > 0 || self.currentgoal.script_wait_max > 0;

			if ( hasWait || !isDefined( self.currentgoal ) || ( isDefined( self.currentgoal ) && isDefined( self.currentgoal.scriptbundlename ) ) )
			{
				// Needs to stop at current goal
				goalPos = undefined;
				if( IsDefined( behaviorTreeEntity.arrivalFinalPos ) )
					goalPos = behaviorTreeEntity.arrivalFinalPos;
				else
					goalPos = behaviorTreeEntity.pathGoalPos;
		
				goalDistSq = DistanceSquared( behaviorTreeEntity.origin, goalPos );

				// FIXME: base this on arrival animation movement delta?
				if ( goalDistSq <= ( 70 * 70 ) && ( goalDistSq <= behaviorTreeEntity.goalradius * behaviorTreeEntity.goalradius ) )
					return false; // do arrival and stop
			}
		}
		
		return true;
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: shouldStealthResume \n"
"Summary: returns true if AI is resuming back to less aware status.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function shouldStealthResume( behaviorTreeEntity )
{
	if ( !shouldStealth( behaviorTreeEntity ) )
		return false;
	
	if ( ( isdefined( behaviorTreeEntity.stealth_resume ) && behaviorTreeEntity.stealth_resume ) )
	{
		behaviorTreeEntity.stealth_resume = undefined;
		return true;
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: stealthReactCondition \n"
"Summary: returns true if AI should react to spotting/hearing something.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function private stealthReactCondition( entity )
{
	inScene = ( isDefined( self._o_scene ) && isDefined( self._o_scene._str_state ) && self._o_scene._str_state == "play" );
	
	return ( !( isdefined( entity.stealth_reacting ) && entity.stealth_reacting ) && entity HasValidInterrupt( "react" ) && !inScene );
}

/*
///BehaviorUtilityDocBegin
"Name: stealthReactStart \n"
"Summary: called when actor starts reacting to stealth alert event.\n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function private stealthReactStart( behaviorTreeEntity )
{
	behaviorTreeEntity.stealth_reacting = true;
}

/*
///BehaviorUtilityDocBegin
"Name: stealthReactTerminate \n"
"Summary: called when actor finishes reacting to stealth alert event.\n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function private stealthReactTerminate( behaviorTreeEntity )
{
	behaviorTreeEntity.stealth_reacting = undefined;
}

/*
///BehaviorUtilityDocBegin
"Name: stealthIdleTerminate \n"
"Summary: called when actor finishes a stealth idle anim.\n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function private stealthIdleTerminate( behaviorTreeEntity )
{
	behaviortreeentity notify("stealthIdleTerminate");
	
	if ( ( isdefined( behaviortreeentity.stealth_resume_after_idle ) && behaviortreeentity.stealth_resume_after_idle ) )
	{
		behaviortreeentity.stealth_resume_after_idle = undefined;
		behaviortreeentity.stealth_resume = true;
	}
}

/*
///BehaviorUtilityDocBegin
"Name: locomotionShouldPatrol \n"
"Summary: returns true if AI should patrol walk.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function locomotionShouldPatrol( behaviorTreeEntity )
{
	// Stealth state takes precedence over normal patrol state
	if ( shouldStealth( behaviortreeentity ) )
		return false;

	// if the script interface needs patrol
	if( behaviorTreeEntity HasPath() &&
		behaviorTreeEntity ai::has_behavior_attribute( "patrol" ) 
	    && behaviorTreeEntity ai::get_behavior_attribute( "patrol" ) )
	{
		return true;
	}
	
	return false;
}


/*
///BehaviorUtilityDocBegin
"Name: explosiveKilled \n"
"Summary: returns true if AI was killed by an explosive weapon.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function explosiveKilled( behaviorTreeEntity )
{
	if( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_damage_weapon_class" ) == "explosive" )
	{
		return true;
	}
	
	return false;	
}

function private _dropRiotShield( riotshieldInfo )
{
	entity = self;

	entity shared::ThrowWeapon( riotshieldInfo.weapon, riotshieldInfo.tag, false );
	
	if ( IsDefined( entity ) )
	{
		entity Detach( riotshieldInfo.model, riotshieldInfo.tag );
	}
}

/*
///BehaviorUtilityDocBegin
"Name: attachRiotshield \n"
"Summary: Attaches a riotshield to the AI.\n"
"MandatoryArg: <entity> : Entity to attach the riotshield to.\n"
"MandatoryArg: <weapon> : Specific riotshield weapon, used for dropping.\n"
"MandatoryArg: <string> : Model to attach to the entity.\n"
"MandatoryArg: <string> : Tag to attach the riotshield to.\n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function attachRiotshield( entity, riotshieldWeapon, riotshieldModel, riotshieldTag )
{
	riotshield = SpawnStruct();
	riotshield.weapon = riotshieldWeapon;
	riotshield.tag = riotshieldTag;
	riotshield.model = riotshieldModel;

	entity Attach( riotshieldModel, riotshield.tag );
	
	entity.riotshield = riotshield;
}

/*
///BehaviorUtilityDocBegin
"Name: dropRiotshield \n"
"Summary: Drops the AI's riotshield if the AI has a riotshield.\n"
"MandatoryArg: <entity> : Entity to drop the riotshield from.\n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function dropRiotshield( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.riotshield ) )
	{
		riotshieldInfo = behaviorTreeEntity.riotshield;
	
		behaviorTreeEntity.riotshield = undefined;
		behaviorTreeEntity thread _dropRiotShield( riotshieldInfo );
	}
}


/*
///BehaviorUtilityDocBegin
"Name: electrifiedKilled \n"
"Summary: returns true if AI was killed by an electrified weapon.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function electrifiedKilled( behaviorTreeEntity )
{
	if(  behaviorTreeEntity.damageweapon.rootweapon.name == "shotgun_pump_taser" )
	{
		return true;
	}
	
	if( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_damage_mod" ) == "mod_electrocuted" )
	{
		return true;
	}
	
	return false;
	
}

/*
///BehaviorUtilityDocBegin
"Name: burnedKilled \n"
"Summary: returns true if AI was killed by flames.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function burnedKilled( behaviorTreeEntity )
{
	if( Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_damage_mod" ) == "mod_burned" )
	{
		return true;
	}
	
	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: rapsKilled \n"
"Summary: returns true if AI was killed by a Raps explosion.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function rapsKilled( behaviorTreeEntity )
{
	if( isDefined(self.attacker) && isDefined(self.attacker.archetype) && self.attacker.archetype == "raps")
	{
		return true;
	}
	
	return false;
}


// ------- EXPOSED - MELEE MUTEX -----------//
function meleeAcquireMutex( behaviorTreeEntity )
{
	if( isDefined( behaviorTreeEntity ) && isDefined( behaviorTreeEntity.enemy ))
	{
		behaviorTreeEntity.melee = spawnStruct();
		behaviorTreeEntity.melee.enemy = behaviorTreeEntity.enemy;
		
		if( IsPlayer( behaviorTreeEntity.melee.enemy ) )
		{
			if( !isDefined( behaviorTreeEntity.melee.enemy.meleeAttackers) )
			{
				behaviorTreeEntity.melee.enemy.meleeAttackers = 0;
			}
			//assert( behaviorTreeEntity.enemy.meleeAttackers <= MAX_MELEE_PLAYER_ATTACKERS);
			behaviorTreeEntity.melee.enemy.meleeAttackers++;
		}
	}
}

function meleeReleaseMutex( behaviorTreeEntity )
{	
	if( isdefined(behaviorTreeEntity.melee) )
	{
		if( isdefined(behaviorTreeEntity.melee.enemy) )
		{
			if( IsPlayer( behaviorTreeEntity.melee.enemy ) )
			{
				if( isDefined( behaviorTreeEntity.melee.enemy.meleeAttackers) )
				{
					behaviorTreeEntity.melee.enemy.meleeAttackers = behaviorTreeEntity.melee.enemy.meleeAttackers - 1;
					if ( behaviorTreeEntity.melee.enemy.meleeAttackers <= 0 )
					{
						behaviorTreeEntity.melee.enemy.meleeAttackers = undefined;
					}
				}
			}
		}
		
		behaviorTreeEntity.melee = undefined;
	}
}


function shouldMutexMelee( behaviorTreeEntity )
{
	// Can't acquire when someone is targeting us for a melee
	if ( isDefined( behaviorTreeEntity.melee ) )
	{
		return false;
	}
	
	// Can't acquire enemy mutex if he's already in a melee process
	if ( isDefined( behaviorTreeEntity.enemy))
	{
		if( !isPlayer ( behaviorTreeEntity.enemy ))
		{
			if( isDefined( behaviorTreeEntity.enemy.melee ) )
			{
				return false;
			}
		}
		else
		{
			// Disregard the mutex melee check against the player when not in a campaign game.
			if ( !SessionModeIsCampaignGame() )
			{
				return true;
			}
		
			if (!isDefined( behaviorTreeEntity.enemy.meleeAttackers))
			{
				behaviorTreeEntity.enemy.meleeAttackers = 0;
			}
			
			return behaviorTreeEntity.enemy.meleeAttackers < 1;
		}
	}
	
	return true;
}

function shouldNormalMelee( behaviorTreeEntity)
{
	return AiUtility::hasCloseEnemyToMelee( behaviorTreeEntity );
}


function shouldMelee( entity )
{
	if ( IsDefined( entity.lastShouldMeleeResult ) &&
		!entity.lastShouldMeleeResult &&
		( entity.lastShouldMeleeCheckTime + 50 ) >= GetTime() )
	{
		// Last check was false, and very little time has progressed, return false.
		return false;
	}
	
	entity.lastShouldMeleeCheckTime = GetTime();
	entity.lastShouldMeleeResult = false;

	if ( !IsDefined( entity.enemy ) )
		return false;

	if ( !( entity.enemy.allowDeath ) )
		return false;
	
	if ( !IsAlive( entity.enemy ) )
		return false;
	
	if ( !IsSentient( entity.enemy ) )
		return false;
	
	if ( IsVehicle( entity.enemy ) && !( isdefined( entity.enemy.good_melee_target ) && entity.enemy.good_melee_target ) )
		return false;
	
	// Don't melee prone players.
	if ( IsPlayer( entity.enemy ) && entity.enemy GetStance() == "prone" )
		return false;
	
	chargeDistSQ = ( IsDefined( entity.melee_charge_rangeSQ) ? entity.melee_charge_rangeSQ : ( (140) * (140) ) );
	if( DistanceSquared( entity.origin, entity.enemy.origin ) > chargeDistSQ )
		return false;
	
	if( !AiUtility::shouldMutexMelee( entity ) )
		return false;
	
	if( ai::HasAiAttribute( entity, "can_melee" ) && !ai::GetAiAttribute( entity, "can_melee" ) )
		return false;
		
	if(	ai::HasAiAttribute( entity.enemy, "can_be_meleed" ) && !ai::GetAiAttribute( entity.enemy, "can_be_meleed" ) )
		return false;
	
	if( AiUtility::shouldNormalMelee( entity ) || AiUtility::shouldChargeMelee( entity ) )
	{
		entity.lastShouldMeleeResult = true;
		return true;
	}
			
	return false;
}

function hasCloseEnemyToMelee( entity )
{
	return hasCloseEnemyToMeleeWithRange( entity, ( (64) * (64) ));
}


function hasCloseEnemyToMeleeWithRange( entity, melee_range_sq )
{
	assert( IsDefined( entity.enemy ) );

	predicitedPosition = entity.enemy.origin + VectorScale(entity GetEnemyVelocity(), 0.25 );
	distSQ = DistanceSquared( entity.origin, predicitedPosition );
	yawToEnemy = AngleClamp180( entity.angles[ 1 ] - (VectorToAngles(entity.enemy.origin-entity.origin)[1]) );
	
	//within 3feet, dont need the movetopoint check
	if( distSQ <= ( (36) * (36) ) )
	{		
		return abs( yawToEnemy ) <= 40;
	}
	
	//less than minThresh and there isn't anything blocking us.
	if( distSQ <= melee_range_sq && entity MayMoveToPoint( entity.enemy.origin ) )  
	{			
		return abs( yawToEnemy ) <= 60;
	}	
	
	return false;
}

// ------- CHARGE MELEE -----------//
function shouldChargeMelee( entity )
{	
	assert( IsDefined( entity.enemy ) );
	
	currentStance = Blackboard::GetBlackBoardAttribute( entity, "_stance" );
	if ( currentStance != "stand" )
		return false;
	
	if ( IsDefined( entity.nextChargeMeleeTime ) )
	{
		if ( GetTime() < entity.nextChargeMeleeTime )
			return false;
	}
	
	enemyDistSq = DistanceSquared( entity.origin, entity.enemy.origin );
	
	// already close, no need to charge
	if ( enemyDistSq < ( (64) * (64) ) )
		return false;
	
	// not trying to move to the EXACT location of enemy, just within close melee range
	offset = entity.enemy.origin - ( VectorNormalize( entity.enemy.origin - entity.origin) * 36);
	
	chargeDistSQ = (isDefined(entity.melee_charge_rangeSQ)?entity.melee_charge_rangeSQ:( (140) * (140) ));
	if ( enemyDistSq < chargeDistSQ && entity MayMoveToPoint(offset,true,true)  )
	{
		yawToEnemy = AngleClamp180( entity.angles[ 1 ] - (VectorToAngles(entity.enemy.origin-entity.origin)[1]) );
		return abs( yawToEnemy ) <= 60;
	}
	
	return false;
}

function private shouldAttackInChargeMelee( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.enemy ) )
	{
		if ( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin ) < ( (74) * (74) ) )
		{
			yawToEnemy = AngleClamp180( behaviorTreeEntity.angles[ 1 ] - (VectorToAngles(behaviorTreeEntity.enemy.origin-behaviorTreeEntity.origin)[1]) );
			if ( abs( yawToEnemy ) > 60 )
				return false;

			return true;
		}
	}
}

function private setupChargeMeleeAttack( behaviorTreeEntity )
{
	if(isDefined(behaviorTreeEntity.enemy) && isDefined(behaviorTreeEntity.enemy.vehicletype) && isSubStr(behaviorTreeEntity.enemy.vehicletype,"firefly") )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_melee_enemy_type", "fireflyswarm");
	}
	aiutility::meleeAcquireMutex( behaviorTreeEntity );
	aiutility::keepClaimNode( behaviorTreeEntity );
}

function private cleanupMelee( behaviorTreeEntity )
{
	aiutility::meleeReleaseMutex( behaviorTreeEntity );
	AiUtility::releaseClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_melee_enemy_type", undefined);
}


function private cleanupChargeMelee( behaviorTreeEntity )
{
	behaviorTreeEntity.nextChargeMeleeTime = GetTime() + 2000;
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_melee_enemy_type", undefined);

	aiutility::meleeReleaseMutex( behaviorTreeEntity );
	AiUtility::releaseClaimNode( behaviorTreeEntity );
	
	// Dont move for a sec
	behaviorTreeEntity PathMode( "move delayed", true, RandomFloatRange( 0.75, 1.5 ) );
}

function cleanupChargeMeleeAttack( behaviorTreeEntity )
{
	AiUtility::meleeReleaseMutex( behaviorTreeEntity );
	AiUtility::releaseClaimNode( behaviorTreeEntity );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_melee_enemy_type", undefined);
	
	// Dont move for a sec
	behaviorTreeEntity PathMode( "move delayed", true, RandomFloatRange( 0.5, 1 ) );
}
// ------- CHARGE MELEE -----------//

function private shouldChooseSpecialPronePain ( behaviorTreeEntity )
{
	stance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	return (stance == "prone_back" || stance == "prone_front");
}

// ------- SPECIAL PAIN -----------//
function private shouldChooseSpecialPain( behaviorTreeEntity )
{
	if(IsDefined( behaviorTreeEntity.damageWeapon )) 
	{
		return behaviorTreeEntity.damageWeapon.specialpain;
	}
	return false;
}

// ------- SPECIAL DEATH -----------//
function private shouldChooseSpecialDeath( behaviorTreeEntity )
{
	if(IsDefined( behaviorTreeEntity.damageWeapon )) 
	{
		return behaviorTreeEntity.damageWeapon.specialpain;
	}
	return false;
}

function private shouldChooseSpecialProneDeath( behaviorTreeEntity )
{
	stance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	return (stance == "prone_back" || stance == "prone_front");
}

function private setupExplosionAnimScale( entity, asmStateName )
{
	self.animtranslationScale = 2.0;
	self ASMSetAnimationRate( 0.7 );
	
	return 4;
}

/*
///BehaviorUtilityDocBegin
"Name: isBalconyDeath \n"
"Summary: returns true if AI was killed while on a balcony node.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function isBalconyDeath( behaviorTreeEntity )
{
	//do i have a node?
	if( !isDefined(behaviorTreeEntity.node) )
		return false;
	
	if(!((behaviorTreeEntity.node.spawnflags & 1024) || (behaviorTreeEntity.node.spawnflags & 2048)))
	{
		return false;
	}
	
	coverMode = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_cover_mode" );

	// Don't trigger a balcony death when AI is idling at cover.
	if ( coverMode == "cover_alert" || coverMode == "cover_mode_none" )
	{
		return false;
	}

	if (isDefined(behaviorTreeEntity.node.script_balconydeathchance) && RandomInt(100) > int(100.0 * behaviorTreeEntity.node.script_balconydeathchance))
		return false;

	//am i close enough to the cover node?
	distSQ = DistanceSquared(behaviorTreeEntity.origin,behaviorTreeEntity.node.origin);
	if (distSQ > ( (16) * (16) ))
		return false;
	
	// get the closest player
	if(isDefined(level.players) && level.players.size > 0)
	{
		closest_player = util::get_closest_player( behaviorTreeEntity.origin, level.players[0].team);
		
		if(isDefined(closest_player))
		{
			//Am I in the same level as the closest player
			if(abs(closest_player.origin[2] - behaviorTreeEntity.origin[2]) < 100)
			{
				distance2DfromPlayerSq = Distance2DSquared(closest_player.origin, behaviorTreeEntity.origin);
				
				//Am I too close to that player
				if(distance2DfromPlayerSq < ( (600) * (600) ))
				{
					return false;
				}
			}
		}
	}
	
	return true;
}


/*
///BehaviorUtilityDocBegin
"Name: balconyDeath \n"
"Summary: sets the BB special_death attribute to appropriate balcony type\n"
"MandatoryArg: AI behaviorTreeEntity\n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function balconyDeath( behaviorTreeEntity )
{	
	behaviorTreeEntity.clamptonavmesh = 0;

	if( behaviorTreeEntity.node.spawnflags & 1024 )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_special_death", "balcony");
	}
	else if( behaviorTreeEntity.node.spawnflags & 2048 )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_special_death", "balcony_norail" );
	}
}

function useCurrentPosition( entity )
{
	entity UsePosition( entity.origin );
}

/*
///BehaviorUtilityDocBegin
"Name: isUnarmed \n"
"Summary: returns true if AI doesn't have a weapon.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function isUnarmed( behaviorTreeEntity )
{
	if ( behaviorTreeEntity.weapon == level.weaponNone )
	{
		return true;
	}

	return false;
}

/*
///BehaviorUtilityDocBegin
"Name: forceRagdoll \n"
"Summary: Starts ragdoll on the entity.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///BehaviorUtilityDocEnd
*/
function forceRagdoll( entity )
{
	entity StartRagdoll();
}



function preShootLaserAndGlintOn( ai )
{
	self endon( "death" );
	if( !isDefined( ai.laserstatus ))
	{
		ai.laserstatus = false;
	}
	
	sniper_glint = "lensflares/fx_lensflare_sniper_glint";

	While( 1 )
	{		
		self waittill( "about_to_fire" );
		if( ai.laserstatus !== true )
		{
			ai LaserOn();
			ai.laserstatus = true;
			
			if( ai.team != "allies" )
			{
				tag = ai GetTagOrigin( "tag_glint");
				
				if( isDefined( tag ))
				{
					playfxontag( sniper_glint , ai , "tag_glint" );
				}
				else
				{
					type = (isdefined(ai.classname)?""+ai.classname:"");
					/#println( "AI " + type + " does not have a tag_glint to play sniper glint effects from, playing from tag_eye" );#/
					playfxontag( sniper_glint , ai , "tag_eye" );
				}
			}
		}
	}
	
}


function postShootLaserAndGlintOff( ai )
{
	self endon( "death" );

	While( 1 )
	{		
		self waittill( "stopped_firing" );
		if( ai.laserstatus === true )
		{
			ai LaserOff();
			ai.laserstatus = false;
		}
	}
	
}

function private isInPhalanx( entity )
{
	return entity ai::get_behavior_attribute( "phalanx" );
}

function private isInPhalanxStance( entity )
{
	phalanxStance = entity ai::get_behavior_attribute( "phalanx_force_stance" );
	currentStance = Blackboard::GetBlackBoardAttribute( entity, "_stance" );
	
	switch ( phalanxStance )
	{
		case "stand":
			return currentStance == "stand";
		case "crouch":
			return currentStance == "crouch";
	}
	
	return true;
}

function private togglePhalanxStance( entity )
{
	phalanxStance = entity ai::get_behavior_attribute( "phalanx_force_stance" );
	
	switch ( phalanxStance )
	{
		case "stand":
			Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );
			break;
		case "crouch":
			Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "crouch" );
			break;
	}
}

function private tookFlashbangDamage( entity )
{
	if ( IsDefined( entity.damageweapon ) && IsDefined( entity.damagemod ) )
	{
		weapon = entity.damageweapon;
		
		return entity.damagemod == "MOD_GRENADE_SPLASH" &&
			IsDefined( weapon.rootweapon ) &&
			( IsSubStr( weapon.rootweapon.name, "flash_grenade" ) || IsSubStr( weapon.rootweapon.name, "concussion_grenade" ) );		//checking substring for flashbang grenade variant;  probably this should be a gdt checkbox 'flashbang damage' or similar
	}
	return false;
}