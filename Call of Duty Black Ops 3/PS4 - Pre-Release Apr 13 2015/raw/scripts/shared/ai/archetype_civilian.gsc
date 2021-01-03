#using scripts\shared\ai_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\spawner_shared;

                                                                                                             	   	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                                                                                                               	
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

function autoexec main()
{
	ArchetypeCivilian::RegisterBehaviorScriptFunctions();
}

#namespace ArchetypeCivilian;

function RegisterBehaviorScriptFunctions()
{
	// ------- SPAWN FUNCTIONS ------------//
	spawner::add_archetype_spawn_function( "civilian", &civilianBlackboardInit );

	// register some required ai interface attributes
	ai::RegisterMatchedInterface( "civilian", "sprint", false, array( true, false ) );
	ai::RegisterMatchedInterface( "civilian", "panic", true, array( true, false ) );

	// ------- CIVILIAN ACTIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("civilianMoveAction",&civilianMoveActionInitialize,undefined,&civilianMoveActionFinalize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("civilianCowerAction",&civilianCowerActionInitialize,undefined,undefined);;
}

function private civilianBlackboardInit() // self = AI
{
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );

	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( self );

	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE CIVILIAN BLACKBOARD
	Blackboard::RegisterBlackBoardAttribute(self,"_panic","panic",&BB_GetPanic);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_panic");#/    };
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &civilianOnAnimscriptedCallback;
		
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
}

function private BB_GetPanic()
{
	if ( ( isdefined( ai::GetAiAttribute( self, "panic" ) ) && ai::GetAiAttribute( self, "panic" ) ) )
		return "panic";
	return "calm";
}

function private civilianOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;

	// REREGISTER BLACKBOARD
	entity civilianBlackboardInit();
}

function private civilianMoveActionInitialize( entity, asmStateName )
{
	Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );

	AnimationStateNetworkUtility::RequestState( entity, asmStateName );

	return 5;
}

function private civilianMoveActionFinalize( entity, asmStateName )
{
	if ( Blackboard::GetBlackBoardAttribute( entity, "_stance" ) != "stand" )
	{
		Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );
	}

	return 4;
}

function private civilianCowerActionInitialize( entity, asmStateName )
{
	if ( isdefined( entity.node ) )
	{
		highestStance = AiUtility::getHighestNodeStance( entity.node );
		if ( highestStance == "crouch" )
		{
			Blackboard::SetBlackBoardAttribute( entity, "_stance", "crouch" );
		}
		else
		{
			Blackboard::SetBlackBoardAttribute( entity, "_stance", "stand" );
		}
	}

	AnimationStateNetworkUtility::RequestState( entity, asmStateName );

	return 5;
}

// end #namespace ArchetypeCivilian;
