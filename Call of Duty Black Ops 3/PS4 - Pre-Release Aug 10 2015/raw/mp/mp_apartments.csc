#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

//commenting audio script out to get the map loading 1-15-14

//#using scripts\mp\_audio;
#using scripts\mp\_load;

#using scripts\mp\mp_apartments_amb;
#using scripts\mp\mp_apartments_fx;
#using scripts\mp\mp_apartments_lighting;

// Test clientside script for mp_apartments

function main()
{
	// _load!
	load::main();

	mp_apartments_fx::main();

	thread mp_apartments_amb::main();

	// This needs to be called after all systems have been registered.
	util::waitforclient( 0 );

	level.endGameXCamName = "ui_cam_endgame_mp_apartments";

	/# println("*** Client : mp_apartments running..."); #/
}
