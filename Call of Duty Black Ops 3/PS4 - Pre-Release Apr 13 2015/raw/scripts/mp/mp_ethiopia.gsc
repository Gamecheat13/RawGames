#using scripts\codescripts\struct;

#using scripts\shared\compass;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_ethiopia_fx;
#using scripts\mp\mp_ethiopia_sound;

function main()
{
	precache();
	
	mp_ethiopia_fx::main();
	mp_ethiopia_sound::main();
	
	load::main();

	//compass map function, uncomment when adding the minimap
	compass::setupMiniMap("compass_map_mp_ethiopia");

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass

}

function precache()
{
	// DO ALL PRECACHING HERE
}
