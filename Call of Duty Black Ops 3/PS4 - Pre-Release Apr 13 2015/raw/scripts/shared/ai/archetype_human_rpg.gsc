#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;

// INTERFACE
#using scripts\shared\ai\archetype_human_rpg_interface;

#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;

                                                                                                             	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                              	   	                             	  	                                      
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                                                                                                                                                                                                                                                                                                                                   

function autoexec main()
{
	// INIT BLACKBOARD	
	spawner::add_archetype_spawn_function( "human_rpg", &HumanRpgBehavior::ArchetypeHumanRpgBlackboardInit );
	
	HumanRpgBehavior::RegisterBehaviorScriptFunctions();

	HumanRpgInterface::RegisterHumanRpgInterfaceAttributes();
}

#namespace HumanRpgBehavior;

function RegisterBehaviorScriptFunctions()
{
}

function private ArchetypeHumanRpgBlackboardInit()
{
	entity = self;
	
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( entity );
	
	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( entity );
	
	// USE UTILITY BLACKBOARD
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeHumanRpgOnAnimscriptedCallback;
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#entity FinalizeTrackedBlackboardAttributes();#/;
	
	// USE OVERRIDE ANIMATIONS TO START WITH FOR RPG AI
	entity AsmChangeAnimMappingTable( 1 );
}

function private ArchetypeHumanRpgOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeHumanRpgBlackboardInit();
}

