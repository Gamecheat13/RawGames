/*
 * AI VS AI MELEE SYSTEM
 * The AI vs AI Melee system is initiated from the behavior tree.
 * A set of conditions are used to check if an AI can initiate a scripted melee attack against its enemy.
 * If these pass, the AI designates itself as the initiator of the setup. The initiator then picks the two animations, and sets AnimScripted on both itself and its enemy from the AIvsAIMeleeAction
 * Threads are spawned on the entities to handle death during the sequence since it is outside the tree. The loser is killed and the survivor kicks back into the behavior tree.
TODO: 
- Rethink the initiator system to see if melee can be triggered without it
- Add support for few more animations, including close range melee without runup
- Add more archetypes
 */
 
#using scripts\codescripts\struct;

// COMMON AI SYSTEMS INCLUDES
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\archetype_utility;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                                                                                                               	
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
            	     
                                                              	   	                             	  	                                      
                                                                                                             	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       


function RegisterAIvsAIMeleeBehaviorFunctions()
{			
	// ------- AI vs AI BEHAVIOR TREE FUNCTIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasAIvsAIEnemy",&hasAIvsAIEnemy);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("decideInitiator",&decideInitiator);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isInitiator",&isInitiator);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("canDoAIvsAIMelee",&canDoAIvsAIMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasCloseAIvsAIEnemy",&hasCloseAIvsAIEnemy);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseAIvsAIMeleeAnimations",&chooseAIvsAIMeleeAnimations);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isCloseEnoughForAIvsAIMelee",&isCloseEnoughForAIvsAIMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasPotentalAIvsAIMeleeEnemy",&hasPotentalAIvsAIMeleeEnemy);;
		
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("AIvsAIMeleeAction",&AIvsAIMeleeInitialize,undefined,undefined);;
}


// ------- AI vs AI BEHAVIOR TREE FUNCTIONS -----------//

function hasPotentalAIvsAIMeleeEnemy( behaviorTreeEntity )
{
	if( !hasAIvsAIEnemy( behaviorTreeEntity ) )
		return false;
		
	if( !canDoAIvsAIMelee( behaviorTreeEntity ) )
		return false;
	
	if( !chooseAIvsAIMeleeAnimations( behaviorTreeEntity ) )
		return false;
	
	if( !hasCloseAIvsAIEnemy( behaviorTreeEntity ) )
		return true;
	
	return false;
}

function isCloseEnoughForAIvsAIMelee( behaviorTreeEntity )
{	
	if( !hasAIvsAIEnemy( behaviorTreeEntity ) )
		return false;
		
	if( !canDoAIvsAIMelee( behaviorTreeEntity ) )
		return false;
	
	if( !chooseAIvsAIMeleeAnimations( behaviorTreeEntity ) )
		return false;
	
	if( !hasCloseAIvsAIEnemy( behaviorTreeEntity ) )
		return false;
	
	return true;
}

function private shouldAquireMutexOnEnemyForAIvsAIMelee( behaviorTreeEntity )
{	
	if( IsPlayer ( behaviorTreeEntity.enemy ) )
		return false;
	
	if( !IsDefined( behaviorTreeEntity.enemy ) )
		return false;
	
	// if already meleeing, then see if the enemy we are meleeing is the same as 
	// the one we want to perform AI vs AI melee
	if( IsDefined( behaviorTreeEntity.melee ) )
	{
		if( IsDefined( behaviorTreeEntity.melee.enemy ) && behaviorTreeEntity.melee.enemy == behaviorTreeEntity.enemy )
			return true;
	}
	
	if( IsDefined( behaviorTreeEntity.enemy.melee ) )
	{
		if( IsDefined( behaviorTreeEntity.enemy.melee.enemy ) && behaviorTreeEntity.enemy.melee.enemy != behaviorTreeEntity )
			return false;		
	}
	
	return true;
}

function private hasAIvsAIEnemy( behaviorTreeEntity )
{
	enemy = behaviorTreeEntity.enemy; 

	if( GetDvarInt( "disable_aivsai_melee", 0 ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: Disable dvar set", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	if( !IsDefined( enemy ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: No enemy", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	if( !( IsAlive( behaviorTreeEntity ) && IsAlive( enemy ) ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: A participant may not be alive", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;	
	}
	
	// Only support AI Actors.
	if( !IsAI( enemy ) || !IsActor( enemy ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: Not an actor nor AI", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	
	//for now only human vs human and riotshield and robot
	//NOTE: dog cannot be on the losing side
	if( IsDefined( enemy.archetype ) )
	{
		if( enemy.archetype != "human" && enemy.archetype!= "human_riotshield" && enemy.archetype != "robot" )
		{
			/#
			Record3DText( "AI vs AI Melee Failure: Non human/riotshield/robot enemy", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
			#/
			return false;
		}
	}
	//enemy should be ignored
	if( ( isdefined( enemy.ignoreMe ) && enemy.ignoreMe ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: Enemy should be ignored", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	//already a part of an aivsai melee, _ai_melee_markedDead is used to designate that a decision has been made on the conflict
	if( ( isdefined( enemy._ai_melee_markedDead ) && enemy._ai_melee_markedDead ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: Enemy engaged in another AI vs AI melee", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	//AI should not initiate aivsai melee
	if ( behaviorTreeEntity ai::has_behavior_attribute( "can_initiateaivsaimelee" ) &&
		!behaviorTreeEntity ai::get_behavior_attribute( "can_initiateaivsaimelee" ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: can_initiateaivsaimelee disabled for attacker", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	// Check if the AI can melee.
	if ( behaviorTreeEntity ai::has_behavior_attribute( "can_melee" ) &&
		!behaviorTreeEntity ai::get_behavior_attribute( "can_melee" ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: can_melee disabled for attacker", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	
	// Check if the enemy can be meleed.
	if ( enemy ai::has_behavior_attribute( "can_be_meleed" ) &&
		!enemy ai::get_behavior_attribute( "can_be_meleed" ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: can_melee disabled for enemy", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	
	//to check if enemy is close by
	if( DistanceSquared( behaviorTreeEntity.origin, enemy.origin ) > 150 * 150 )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: Enemy too far", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		behaviorTreeEntity._ai_melee_initiator = undefined;
		return false;
	}
	//making sure our enemy is in front of us
	forwardVec = VectorNormalize( AnglesToForward( behaviorTreeEntity.angles ) );
	rightVec = VectorNormalize( AnglesToRight( behaviorTreeEntity.angles ) );
	toEnemyVec = VectorNormalize( enemy.origin - behaviorTreeEntity.origin );
					
	fDot = VectorDot( toEnemyVec, forwardVec );

	if ( fDot < 0 )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: Enemy behind us", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	//do not melee an enemy that is already playing scripted anim
	if( enemy isInScriptedState() )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: Enemy in scripted state", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	//only allow standing ai vs ai melee
	currentStance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	enemyStance = Blackboard::GetBlackBoardAttribute( enemy, "_stance" );
	if( currentStance != "stand" || enemyStance != "stand" )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: attacker or enemy not standing", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	//return if we should not acquire melee mutex
	if( !shouldAquireMutexOnEnemyForAIvsAIMelee( behaviorTreeEntity ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: should not acquire melee mutex", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	//return if there is not enough open space
	raisedEnemyEntOrigin = ( behaviorTreeEntity.enemy.origin[0], behaviorTreeEntity.enemy.origin[1], behaviorTreeEntity.enemy.origin[2] + 8.0 );
	if( !behaviorTreeEntity MayMoveToPoint( raisedEnemyEntOrigin, false, true, behaviorTreeEntity.enemy ) )
	{
		/#
			Record3DText( "AI vs AI Melee Failure: Trace failed", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	//cannot kill an AI that is not supposed to die
	if( IsDefined( enemy.allowDeath ) && !enemy.allowDeath )
	{
		if( IsDefined( behaviorTreeEntity.allowDeath ) && !behaviorTreeEntity.allowDeath )
		{
			/#
			Record3DText( "AI vs AI Melee Failure: Enemy and attacker cannot die", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
			#/
			
			self notify( "failed_melee_mbs", enemy );
			return false;
		}
		behaviorTreeEntity._ai_melee_attacker_loser = true;
		return true;
	}
	return true;
}

function private decideInitiator( behaviorTreeEntity )
{
	if( !IsDefined( behaviorTreeEntity._ai_melee_initiator ) )
	{
		if( !IsDefined( behaviorTreeEntity.enemy._ai_melee_initiator ) )
		{
			behaviorTreeEntity._ai_melee_initiator = true;
			return true;
		}
	}
	return false;
}

function private isInitiator( behaviorTreeEntity )
{
	if( !( isdefined( behaviorTreeEntity._ai_melee_initiator ) && behaviorTreeEntity._ai_melee_initiator ) )
	{
		return false;
	}
	return true;
}

function private canDoAIvsAIMelee( behaviorTreeEntity )
{
	anglesToEnemy = VectorToAngles( behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin );
	yawToEnemy	  = AngleClamp180( behaviorTreeEntity.enemy.angles[ 1 ] - anglesToEnemy[ 1 ] );
	
	if( abs( yawToEnemy ) < 90 && abs( yawToEnemy ) > 60 )
	{
/#
	//record yaw to enemy for debugging
	Record3DText("Yaw to enemy = " + abs( yawToEnemy ), behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
#/
		return false;
	}
	
	return true;
}

function private hasCloseAIvsAIEnemy( behaviorTreeEntity )
{
	if( !( IsDefined( behaviorTreeEntity._ai_melee_animname ) && IsDefined( behaviorTreeEntity.enemy._ai_melee_animname ) ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: anim pair not found", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
		return false;
	}
	
	animationStartOrigin = GetStartOrigin( behaviorTreeEntity.enemy GetTagOrigin( "tag_sync" ), behaviorTreeEntity.enemy GetTagAngles( "tag_sync" ), behaviorTreeEntity._ai_melee_animname );
	
/#
	Record3DText("Threshold Initiator distance from AnimStart = " + 16 * 16, behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
	Record3DText("Initiatior distance from AnimStart = " + DistanceSquared( animationStartOrigin, behaviorTreeEntity.origin ), behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
	RecordCircle( behaviorTreeEntity.enemy GetTagOrigin( "tag_sync" ), 8, ( 1, 0, 0 ), "Animscript", behaviorTreeEntity );
	
	RecordCircle( animationStartOrigin, 8, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
	RecordLine( animationStartOrigin, behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
#/		
		
	if( DistanceSquared( behaviorTreeEntity.origin, animationStartOrigin ) <= 16 * 16 )
	{
		return true;
	}
		
	//check predicted position of entity, and extrapolate position for back anims
	if( behaviorTreeEntity HasPath() )
	{
		selfPredictedPos = behaviorTreeEntity.origin;
		moveAngle		 = behaviorTreeEntity.angles[1] + behaviorTreeEntity getMotionAngle();
		selfPredictedPos += (cos( moveAngle ), sin( moveAngle ), 0) * 200.0 * 0.2; //0.2 is the lookahead time
		
/#		
		Record3DText("Initiator predicted distance from AnimStart= " + DistanceSquared( selfPredictedPos, animationStartOrigin ), behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
#/
			
		if( DistanceSquared( selfPredictedPos, animationStartOrigin ) <= 16 * 16 )
		{
			return true;
		}		
	}
	
	return false;
}

function private chooseAIvsAIMeleeAnimations( behaviorTreeEntity )
{
	anglesToEnemy = VectorToAngles( behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin );
	yawToEnemy	  = AngleClamp180( behaviorTreeEntity.enemy.angles[ 1 ] - anglesToEnemy[ 1 ] );

	//clear out old anims
	behaviorTreeEntity._ai_melee_animname = undefined;
	behaviorTreeEntity.enemy._ai_melee_animname = undefined;
	
	//get the scriptbundle for these archetypes
	animBundle = struct::get_script_bundle( "aiassassination", "aivsaimelee_" + ToLower( behaviorTreeEntity.archetype ) + "vs" + ToLower( behaviorTreeEntity.enemy.archetype ) );
	
	if( !IsDefined( animBundle ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failure: anim bundle not found", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/
					
		return false;
	}
	
	/#
		if( ( isdefined( behaviorTreeEntity._ai_melee_attacker_loser ) && behaviorTreeEntity._ai_melee_attacker_loser ) )
		{
			Record3DText( "AI vs AI Melee: Attacker selected as loser", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		}
	#/
	
	foundAnims = false;
	possibleMelees = [];
	
	if( abs( yawToEnemy ) > 90 )
	{			
		if( IsDefined( behaviorTreeEntity.__forceAIFlipMelee ) )
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontFlipAnimations;
		}
		else if( IsDefined( behaviorTreeEntity.__forceAIWrestleMelee ) )
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontWrestleAnimations;
		}
		else
		{
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontFlipAnimations;
			possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeFrontWrestleAnimations;
		}			
	}
	else if( abs( yawToEnemy ) < 60 )
	{		
		possibleMelees[possibleMelees.size] = &chooseAIVsAIMeleeBackAnimations;
	}
	
	if( possibleMelees.size > 0 )
	{
		[[possibleMelees[GetArrayKeys(possibleMelees)[RandomInt(GetArrayKeys(possibleMelees).size)]]]]( behaviorTreeEntity, animBundle );
	}
		
	if( IsDefined( behaviorTreeEntity._ai_melee_animname ) )
	{
		Debug_ChosenMeleeAnimations( behaviorTreeEntity );
		return true;
	}
	
	return false;
}

function AIvsAIMeleeInitialize( behaviorTreeEntity, asmStateName )
{
	behaviorTreeEntity.blockingPain = true;
	behaviorTreeEntity.enemy.blockingPain = true;
	//acquire the mutex since we are about to melee
	AiUtility::meleeAcquireMutex( behaviorTreeEntity );
	//keep a reference to the other person incase one of the participants does not have the other selected as enemy (especially in case of back melees)
	behaviorTreeEntity._ai_melee_opponent = behaviorTreeEntity.enemy;
	behaviorTreeEntity.enemy._ai_melee_opponent = behaviorTreeEntity;
	   
	//the winner will call playScriptedMeleeAnimations, since this function waits on winner's victory before resetting some flags
	if( ( isdefined( behaviorTreeEntity._ai_melee_attacker_loser ) && behaviorTreeEntity._ai_melee_attacker_loser ) )
	{
		behaviorTreeEntity._ai_melee_markedDead = true;
		behaviorTreeEntity.enemy thread playScriptedMeleeAnimations();
	}
	else
	{
		behaviorTreeEntity.enemy._ai_melee_markedDead = true;
		behaviorTreeEntity thread playScriptedMeleeAnimations();
	}
	
	return 5;	
}

// ------- AI vs AI INTERNAL FUNCTIONS -----------//

//Threaded call to animscripted so that anim is not blended out too early
function playScriptedMeleeAnimations()
{
	self endon("death");
	
	Assert( IsDefined( self._ai_melee_opponent ) );
	opponent = self._ai_melee_opponent;
	
	// In rare cases the enemy or AI could have died.
	if ( !( IsAlive( self ) && IsAlive( opponent ) ) )
	{
		/#
		Record3DText( "AI vs AI Melee Failsafe Failure: A participant may not be alive", self.origin, ( 1, .5, 0 ), "Animscript", self );
		#/
		return false;
	}
	
	if( ( isdefined( opponent._ai_melee_attacker_loser ) && opponent._ai_melee_attacker_loser ) )
	{
		//link to the defender
		opponent linkToBlendToTag( self, "tag_sync", true );
		self.fixedLinkYawOnly = true;
		
		//call animscripted on both
		opponent AnimScripted( "aivsaimeleeloser", self GetTagOrigin("tag_sync"), self GetTagAngles("tag_sync"), opponent._ai_melee_animname );
		self AnimScripted( "aivsaimeleewinner", self GetTagOrigin("tag_sync"), self GetTagAngles("tag_sync"), self._ai_melee_animname );
	}
	else
	{
		//link to the defender
		self linkToBlendToTag( opponent, "tag_sync", true );
		self.fixedLinkYawOnly = true;
		
		//call animscripted on both
		self AnimScripted( "aivsaimeleewinner", opponent GetTagOrigin("tag_sync"), opponent GetTagAngles("tag_sync"), self._ai_melee_animname );
		opponent AnimScripted( "aivsaimeleeloser", opponent GetTagOrigin("tag_sync"), opponent GetTagAngles("tag_sync"), opponent._ai_melee_animname );
	}
	//spawn a thread that kills off the loser at the end
	opponent thread handleDeath( opponent._ai_melee_animname );
	
	//process interrupted deaths
	self thread processInterruptedDeath();
	opponent thread processInterruptedDeath();
	
	//wait for winner to finish
	self waittillmatch( "aivsaimeleewinner", "end" );
	
	self.fixedLinkYawOnly = false;
	
	//flag cleanup
	//release the melee mutex
	AiUtility:: cleanupChargeMeleeAttack( self );
	//remove knife model if necessary
	if( ( isdefined( self._ai_melee_attachedKnife ) && self._ai_melee_attachedKnife ) )
	{
		self Detach( "t6_wpn_knife_melee", "TAG_WEAPON_LEFT" );
		self._ai_melee_attachedKnife = false;
	}
	self.blockingPain = false;
	self._ai_melee_initiator = undefined;
	self notify("meleeCompleted");
	
	self PathMode( "move delayed", true, 3 );
}

function private chooseAIVsAIMeleeFrontFlipAnimations( behaviorTreeEntity, animBundle )
{
	/#
	Record3DText( "AI vs AI Melee: Direction is front", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
	#/

	assert( IsDefined( animBundle ) );
		
	if( ( isdefined( behaviorTreeEntity._ai_melee_attacker_loser ) && behaviorTreeEntity._ai_melee_attacker_loser ) )
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerFrontAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimFrontAnim;
	}
	
	behaviorTreeEntity._ai_melee_animtype = 1;
	behaviorTreeEntity.enemy._ai_melee_animtype = 1;			
}

function private chooseAIVsAIMeleeFrontWrestleAnimations( behaviorTreeEntity, animBundle )
{
	/#
	Record3DText( "AI vs AI Melee: Direction is front", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
	#/
	
	assert( IsDefined( animBundle ) );
		
	if( ( isdefined( behaviorTreeEntity._ai_melee_attacker_loser ) && behaviorTreeEntity._ai_melee_attacker_loser ) )
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserAlternateFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerAlternateFrontAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerAlternateFrontAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimAlternateFrontAnim;
	}
	
	behaviorTreeEntity._ai_melee_animtype = 0;
	behaviorTreeEntity.enemy._ai_melee_animtype = 0;				
}

function private chooseAIVsAIMeleeBackAnimations( behaviorTreeEntity, animBundle )
{
	/#
	Record3DText( "AI vs AI Melee: Direction is back", behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
	#/
		
	assert( IsDefined( animBundle ) );	
	
	if( ( isdefined( behaviorTreeEntity._ai_melee_attacker_loser ) && behaviorTreeEntity._ai_melee_attacker_loser ) )
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerLoserBackAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.defenderWinnerBackAnim;
	}
	else
	{
		behaviorTreeEntity._ai_melee_animname = animBundle.attackerBackAnim;
		behaviorTreeEntity.enemy._ai_melee_animname = animBundle.victimBackAnim;
	}
	
	behaviorTreeEntity._ai_melee_animtype = 2;
	behaviorTreeEntity.enemy._ai_melee_animtype = 2;			
}

function private Debug_ChosenMeleeAnimations( behaviorTreeEntity ) 
{
	/#
	if( IsDefined( behaviorTreeEntity._ai_melee_animname ) && IsDefined( behaviorTreeEntity.enemy._ai_melee_animname ) )
	{
		Record3DText("AI vs AI chosen anim = " + behaviorTreeEntity._ai_melee_animname, behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		Record3DText("AI vs AI enemy chosen anim = " + behaviorTreeEntity.enemy._ai_melee_animname, behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
	}
	#/
}


//Need this to handle deaths for the loser
function handleDeath( animationName )
{
	self endon("death");
	self endon("interruptedDeath");
	
	self.skipDeath = true;
	self.diedInScriptedAnim = true;
	
	totalTime = GetAnimLength( animationName );
	wait( totalTime - 0.2 );
	
	if( IsDefined( self.overrideActorDamage ) )
	{
		self.overrideActorDamage = undefined;
	}
	
	self kill();
}

//To deal with deaths during animscripted
function processInterruptedDeath()
{
	self endon("meleeCompleted");
	
	Assert( IsDefined( self._ai_melee_opponent ) );
	opponent = self._ai_melee_opponent;
	//do not interrupt and kill someone that is not supposed to die
	if( !( isdefined( self.allowDeath ) && self.allowDeath ) )
	{
		return;
	}
	self waittill("death");
	if( IsAlive( opponent ) )
	{
		//loser always dies
		if( ( isdefined( opponent._ai_melee_markedDead ) && opponent._ai_melee_markedDead ) )
		{
			opponent.diedInScriptedAnim = true;
			opponent.skipDeath = true;
			opponent notify ( "interruptedDeath" );
			opponent notify ( "meleeCompleted" );
		
			opponent StopAnimScripted();
			if( IsDefined( opponent.overrideActorDamage ) )
			{
				opponent.overrideActorDamage = undefined;
			}
			opponent kill();
			opponent StartRagDoll();
		}
		else
		{
			opponent._ai_melee_initiator = undefined;
			opponent.blockingPain = false;
			opponent._ai_melee_markedDead = undefined;
			opponent.skipDeath = false;
			opponent.diedInScriptedAnim = false;
			//release the melee mutex for opponent
			AiUtility:: cleanupChargeMeleeAttack( opponent );
			opponent notify( "interruptedDeath" );	
			opponent notify( "meleeCompleted" );
			opponent StopAnimScripted();
		}
	}
	
	if( IsDefined( self ) )
	{
		self.diedInScriptedAnim = true;
		self.skipDeath = true;
		self notify ( "interruptedDeath" );
		
		self StopAnimScripted();
		if( IsDefined( self.overrideActorDamage ) )
		{
			self.overrideActorDamage = undefined;
		}
		self kill();
		self StartRagDoll();
	}
}

