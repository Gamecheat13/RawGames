    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

// Note that this script is called from the level script command animscripted, only for AI.  If animscripted 
// is done on a script model, this script is not called - startscriptedanim is called directly.

#using_animtree("generic");

function main()
{
	
	self endon ("death");
	self notify ("killanimscript");
	self notify ("clearSuppressionAttack");

	self.codeScripted["root"] = %body;	// TEMP!

	self endon ("end_sequence");

	self.a.script = "scripted";
	self waittill("killanimscript");
	
}

#using_animtree("generic");

function init(notifyName, origin, angles, theAnim, AnimMode, root, rate, goalTime, lerpTime)
{
	
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

function end_script()
{
	// This callback will be called when AI will change states from AIS_SCRIPTED to AIS_BEHAVE
	// i.e when it will go from animscripted state to behavior state
	
	if( IsDefined( self.___ArchetypeOnBehaveCallback ) )
		[[self.___ArchetypeOnBehaveCallback]]( self );
}