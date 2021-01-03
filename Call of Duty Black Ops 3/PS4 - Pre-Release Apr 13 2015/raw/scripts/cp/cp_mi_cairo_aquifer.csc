#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_aquifer_fx;
#using scripts\cp\cp_mi_cairo_aquifer_sound;
#using scripts\cp\cp_mi_cairo_aquifer_utility;

#using scripts\shared\vehicles\_quadtank;

function main()
{
	cp_mi_cairo_aquifer_fx::main();
	cp_mi_cairo_aquifer_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}
