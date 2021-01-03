#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;

//INTERFACE
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\archetype_zombie_interface;

                                                                                                             	     	                                                                                                                                                                
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                                                                                                                                                       	     	                                                                                   
                                                                  	                             	  	                                      
                                                                                                           	                                     	                	                       	            	                                                                                                                                                                                                                               
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	




function autoexec init()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("bonuszmZombieTraversalDoesAnimationExist",&bonuszmZombieTraversalDoesAnimationExist);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("bonuszmSpecialTraverseAction",&bonuszmSpecialTraverseActionStart,undefined,&bonuszmSpecialTraverseActionTerminate);;
	
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_bonuszm_special_traversal",&mocompBonuszmSpecialTraversalStart,undefined,&mocompBonuszmSpecialTraversalTerminate);;
}

function private bonuszmZombieTraversalDoesAnimationExist( entity )
{
	assert(IsDefined( entity.traverseStartNode ));
		
	isCustomTraversal = ( IsDefined( entity.traverseStartNode ) && entity.traverseStartNode.script_noteworthy === "custom_traversal" ) 
						|| ( IsDefined( entity.traverseEndNode ) && entity.traverseEndNode.script_noteworthy === "custom_traversal" );
	
	if( isCustomTraversal )
	{
		if( IsDefined( entity.traverseStartNode ) && !IsSubStr( entity.traverseStartNode.animscript, "human" ) )
		{			
			/#
			if( IsDefined( entity.traverseStartNode.animscript ) )
			{
				IPrintLn("Special Traversal " + entity.traverseStartNode.animscript);
			}
			#/
				
			return false;	
		}

		if( IsDefined( entity.traverseEndNode ) && !IsSubStr( entity.traverseStartNode.animscript, "human" ) )
		{
			/#
			if( IsDefined( entity.traverseStartNode.animscript ) )
			{
				IPrintLn("Special Traversal " + entity.traverseStartNode.animscript);
			}
			#/
				
			return false;
		}	
		
		// if we get here that means that this is a human custom traversal, then in that case, let it play out normally assumming that animation does exist
		return true;
	}		
	
	Blackboard::SetBlackBoardAttribute( entity, "_traversal_type", entity.traverseStartNode.animscript );
	
	if( entity.missingLegs === true )
		animationResults = entity ASTSearch( IString( "traverse_legless@zombie" ) );	
	else
		animationResults = entity ASTSearch( IString( "traverse@zombie" ) );	
	
	if( IsDefined( animationResults[ "animation" ] ) )
		return true;
	
	/#
	if( IsDefined( entity.traverseStartNode.animscript ) )
	{
		IPrintLn("Special Traversal " + entity.traverseStartNode.animscript);
	}
	#/
	
	return false;
}

function private bonuszmSpecialTraverseActionStart( entity, asmStateName )
{
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );
	
	entity Ghost();
	entity NotSolid();	
		
	entity clientfield::set("zombie_appear_vanish_fx", 1);	
	
	return 5;
}

function private bonuszmSpecialTraverseActionTerminate( entity, asmStateName )
{
	entity clientfield::set("zombie_appear_vanish_fx", 3);	
	
	entity Show();
	entity Solid();	
			
	return 4;
}

function private mocompBonuszmSpecialTraversalStart( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity OrientMode( "face angle", entity.angles[1] );
	entity SetRepairPaths( false );
	
	locomotionSpeed = Blackboard::GetBlackBoardAttribute( entity, "_locomotion_speed" );
	
	if( locomotionSpeed == "locomotion_speed_walk" )
		rate = 1;
	else if( locomotionSpeed == "locomotion_speed_run" )
		rate = 2;
	else
		rate = 3;
	
	entity ASMSetAnimationRate( rate );
			
	if( entity HasPath() )
	{
		entity.oldPathGoalPos = entity.pathgoalpos;
	}
	
	Assert( IsDefined( entity.traverseEndNode ) );
	entity ForceTeleport( entity.traverseEndNode.origin, entity.angles );
	
	entity AnimMode( "noclip", false );
	entity.blockingPain = true;	
}

function private mocompBonuszmSpecialTraversalTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.blockingPain = false;
	entity SetRepairPaths( true );
		
	if( IsDefined( entity.oldPathGoalPos ) )
	{
		entity SetGoal( entity.oldPathGoalPos );
	}
	
	entity ASMSetAnimationRate( 1 );
	entity FinishTraversal();	
}