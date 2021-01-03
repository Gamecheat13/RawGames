#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\archetype_shared\archetype_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace wasp;

function autoexec __init__sytem__() {     system::register("wasp",&__init__,undefined,undefined);    }

function __init__()
{
	// clientfield setup
	clientfield::register( "vehicle", "rocket_wasp_hijacked", 1, 1, "int", &handle_lod_display_for_driver, !true, !true );
	
	level.sentinelBundle = struct::get_script_bundle( "killstreak", "killstreak_sentinel" );
	vehicle::add_vehicletype_callback( level.sentinelBundle.ksVehicle, &spawned );
}

function spawned( localClientNum )
{
	self.killstreakBundle = level.sentinelBundle;
}

function handle_lod_display_for_driver(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{	
	self endon( "entityshutdown" );
	if( isDefined( self ) )
	{			
		if( self IsLocalClientDriver( localClientNum ))
		{
			self SetHighDetail( true );
			wait 0.05;
			self vehicle::lights_off( localClientNum );
		}
	}
}