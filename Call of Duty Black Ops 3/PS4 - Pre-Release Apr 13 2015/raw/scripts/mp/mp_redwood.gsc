#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

#using scripts\shared\compass;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_redwood_fx;
#using scripts\mp\mp_redwood_sound;

function main()
{
	precache();
	
	mp_redwood_fx::main();
	mp_redwood_sound::main();
	
	load::main();
	
	compass::setupMiniMap( "compass_map_mp_redwood" );
	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass
}

function precache()
{
	// DO ALL PRECACHING HERE
}
