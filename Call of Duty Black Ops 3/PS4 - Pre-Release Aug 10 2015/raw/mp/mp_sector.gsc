#using scripts\codescripts\struct;

#using scripts\shared\compass;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_sector_fx;
#using scripts\mp\mp_sector_sound;

function main()
{
	precache();
	
	mp_sector_fx::main();
	mp_sector_sound::main();
	
	load::main();

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass

    compass::setupMiniMap("compass_map_mp_sector");
    
    link_traversals( "under_bridge", "targetname", true );
}

function link_traversals( str_value, str_key, b_enable )
{
	a_nodes = GetNodeArray( str_value, str_key );
	
	foreach ( node in a_nodes )
	{
		if ( b_enable )
		{
			LinkTraversal( node );
		}
		else 
		{
			UnlinkTraversal( node );
		}
	}
}

function precache()
{
	// DO ALL PRECACHING HERE
}
