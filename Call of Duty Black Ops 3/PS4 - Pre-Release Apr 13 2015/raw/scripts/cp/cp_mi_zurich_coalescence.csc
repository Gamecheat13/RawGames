#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_zurich_coalescence_util;

#using scripts\cp\cp_mi_zurich_coalescence_fx;
#using scripts\cp\cp_mi_zurich_coalescence_sound;

function main()
{
	cp_mi_zurich_coalescence_fx::main();
	cp_mi_zurich_coalescence_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}
