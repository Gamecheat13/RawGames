#using scripts\codescripts\struct;

#using scripts\shared\compass;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_havoc_fx;
#using scripts\mp\mp_havoc_sound;

function main()
{
	precache();
	
	mp_havoc_fx::main();
	mp_havoc_sound::main();
	
	load::main();

	compass::setupMiniMap("compass_map_mp_havoc");

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass
}

function precache()
{
	// DO ALL PRECACHING HERE
}
