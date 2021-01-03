#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\zm\_zm_spawner;

                                                                                                                                  
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                              	   	                             	  	                                      
                                                                                                           	                                     	                                                                                                                                                                                                          

#namespace zm_behavior_utility;

/*
///ZmBehaviorUtilityDocBegin
"Name: validateGoalPos \n"
"Summary: Returns a position on the navmesh closest to the give position, or undefined if nothing is found.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///ZmBehaviorUtilityDocEnd
*/
function validateGoalPos( goalPos )
{
	points = GetNavPointsInRadius( goalPos, 0, 48 );
	return points[0];
}

/*
///ZmBehaviorUtilityDocBegin
"Name: zombieSetupAttackProperties \n"
"Summary: This is where zombies go into attack mode, and need different attributes set up.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///ZmBehaviorUtilityDocEnd
*/
function setupAttackProperties()
{
	// allows zombie to attack again
	self.ignoreall = false; 

	self.meleeAttackDist = 64;
	
	//try to prevent always turning towards the enemy
	self.maxsightdistsqrd = 128 * 128;
}

/*
///ZmBehaviorUtilityDocBegin
"Name: enteredPlayableArea \n"
"Summary: Zombie is no longer behind a barricade.\n"
"MandatoryArg: \n"
"OptionalArg: \n"
"Module: Behavior \n"
///ZmBehaviorUtilityDocEnd
*/
function enteredPlayableArea()
{
	self zm_spawner::zombie_complete_emerging_into_playable_area();

	self.pushable = true;
	self setupAttackProperties();
}

