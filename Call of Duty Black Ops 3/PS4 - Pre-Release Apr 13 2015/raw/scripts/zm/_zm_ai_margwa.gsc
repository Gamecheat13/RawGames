#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\ai\zombie_utility;

// ZM INCLUDES
#using scripts\zm\_zm_utility;

#namespace zm_ai_margwa;

function autoexec init()
{
	level thread margwa_spawning();
}

function margwa_spawning()
{
	while ( !level flag::exists( "begin_spawning" ) )
	{
		{wait(.05);};
	}

	level flag::wait_till( "begin_spawning" );

	level.margwa_spawners = GetEntArray( "margwa_spawner", "targetname" );
	level.margwa_locations = struct::get_array( "margwa_spawn_location", "targetname" );

	if ( IsDefined( level.margwa_spawners[0] ) )
	{
		ai = zombie_utility::spawn_zombie( level.margwa_spawners[0], undefined, level.margwa_locations[0] );
	}
}