#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_ethiopia_fx;
#using scripts\mp\mp_ethiopia_sound;

function main()
{
	mp_ethiopia_fx::main();
	mp_ethiopia_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.

	level.endGameXCamName = "ui_cam_endgame_mp_ethiopia";
}
