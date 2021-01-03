// COMMON AI SYSTEMS INCLUDES
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\archetype_utility;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                                                                                               	
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                  	                             	  	                                      

// ADDITIONAL INCLUDES
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function autoexec RegisterBehaviorScriptfunctions()
{			
	// ------- EXPOSED - CONDITIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("hasCloseEnemy",&hasCloseEnemy);; 
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("noCloseEnemyService",&noCloseEnemyService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tryReacquireService",&tryReacquireService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("prepareToReactToEnemy",&prepareToReactToEnemy);;	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("resetReactionToEnemy",&resetReactionToEnemy);;	
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("exposedSetDesiredStanceToStand",&exposedSetDesiredStanceToStand);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("setPathMoveDelayedRandom",&setPathMoveDelayedRandom);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("vengeanceService",&vengeanceService);;
}

// ------- EXPOSED REACT TO ENEMY -----------//
function private prepareToReactToEnemy( behaviorTreeEntity )
{
	behaviorTreeEntity.newEnemyReaction = false;
	behaviorTreeEntity.malFunctionReaction = false;
	
	// Delay movement when surprised.
	behaviorTreeEntity PathMode( "move delayed", true, 3 );	
}

function private resetReactionToEnemy( behaviorTreeEntity )
{
	behaviorTreeEntity.newEnemyReaction = false;
	behaviorTreeEntity.malFunctionReaction = false;
}

// ------- EXPOSED CHARGE MELEE -----------//
function private noCloseEnemyService( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.enemy ) &&
		AiUtility::hasCloseEnemyToMelee( behaviorTreeEntity ) )
	{
		behaviorTreeEntity ClearPath();
		return true;
	}
	
	return false;
}

function private hasCloseEnemy( behaviorTreeEntity )
{	
	if( !IsDefined( behaviorTreeEntity.enemy ) )
	   return false;
	
	if ( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin ) < 150 * 150 ) 
		return true;
	
	return false;
}

function private _IsValidNeighbor( entity, neighbor )
{
	return IsDefined( neighbor ) &&
		entity.team === neighbor.team;
}



function private vengeanceService( entity )
{
	actors = GetAiArray();
	
	if ( !IsDefined( entity.attacker ) )
	{
		return;
	}
	
	foreach( index, ai in actors )
	{
		if ( _IsValidNeighbor( entity, ai ) &&
			DistanceSquared( entity.origin, ai.origin ) <= ( (360) * (360) ) &&
			RandomFloat( 1 ) >= 0.5 )
		{
			ai GetPerfectInfo( entity.attacker, true );
		}
	}
}



function private setPathMoveDelayedRandom( behaviorTreeEntity, asmStateName )
{	
	// Delay movement to prevent jittering.
	behaviorTreeEntity PathMode( "move delayed", false, RandomFloatRange( 1, 3 ) );
}

function private exposedSetDesiredStanceToStand( behaviorTreeEntity, asmStateName )
{
	AiUtility::keepClaimNode( behaviorTreeEntity );
	
	currentStance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
}

// ------- EXPOSED - REACQUIRE -----------//
function private tryReacquireService( behaviorTreeEntity )
{
	if ( !IsDefined( behaviorTreeEntity.reacquire_state ) )
	{
		behaviorTreeEntity.reacquire_state = 0;
	}

	if ( !IsDefined( behaviorTreeEntity.enemy ) )
	{
		behaviorTreeEntity.reacquire_state = 0;
		return false;
	}

	if ( behaviorTreeEntity HasPath() )
	{
		behaviorTreeEntity.reacquire_state = 0;
		return false;
	}

	if ( behaviorTreeEntity SeeRecently( behaviorTreeEntity.enemy, 4 ) )
	{
		behaviorTreeEntity.reacquire_state = 0;
		return false;
	}

	// don't do reacquire unless facing enemy 
	dirToEnemy = VectorNormalize( behaviorTreeEntity.enemy.origin - behaviorTreeEntity.origin );
	forward = AnglesToForward( behaviorTreeEntity.angles );

	if ( VectorDot( dirToEnemy, forward ) < 0.5 )	
	{
		behaviorTreeEntity.reacquire_state = 0;
		return false;
	}

	switch ( behaviorTreeEntity.reacquire_state )
	{
	case 0:
	case 1:
	case 2:
		step_size = 32 + behaviorTreeEntity.reacquire_state * 32;
		reacquirePos = behaviorTreeEntity ReacquireStep( step_size );
		break;

	case 4:
		if ( !( behaviorTreeEntity CanSee( behaviorTreeEntity.enemy ) ) || !( behaviorTreeEntity CanShootEnemy() ) )
		{
			behaviorTreeEntity FlagEnemyUnattackable();
		}
		break;

	default:
		if ( behaviorTreeEntity.reacquire_state > 15 )
		{
			behaviorTreeEntity.reacquire_state = 0;
			return false;
		}
		break;
	}

	if ( IsVec( reacquirePos ) )
	{
		behaviorTreeEntity UsePosition( reacquirePos );
		return true;
	}

	behaviorTreeEntity.reacquire_state++;
	return false;
}
