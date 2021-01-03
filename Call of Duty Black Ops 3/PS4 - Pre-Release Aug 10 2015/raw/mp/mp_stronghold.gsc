#using scripts\codescripts\struct;

#using scripts\shared\compass;

#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_stronghold_doors;
#using scripts\mp\mp_stronghold_fx;
#using scripts\mp\mp_stronghold_sound;

function main()
{
	precache();
	
	mp_stronghold_fx::main();
	mp_stronghold_sound::main();
	
	load::main();

	compass::setupMiniMap( "compass_map_mp_stronghold" );
	SetDvar( "compassmaxrange", "2100" );	
	// Set up the default range of the compass
	
	
	if ( GetGametypeSetting( "allowMapScripting" ) )
	{
			//level mp_stronghold_doors::init();
	}
}

function precache()
{
	// DO ALL PRECACHING HERE
}
