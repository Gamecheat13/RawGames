#using scripts\codescripts\struct;

#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\turret_shared;
#using scripts\core\core_frontend_fx;
#using scripts\core\core_frontend_sound;

#using scripts\core\_multi_extracam;

#using scripts\shared\vehicle_shared;	// just need this to get linked in so the client fields get registered and match the server


function main()
{
	core_frontend_fx::main();
	core_frontend_sound::main();
	
	//load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}
