#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\postfx_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
	                               	                    	                                 	                                        	                            	                                                                  	                               

function autoexec __init__sytem__() {     system::register("gadget_speed_burst",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_localclient_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	clientfield::register( "toplayer", "speed_burst", 1, 1, "int", &player_speed_changed, !true, true );
	visionset_mgr::register_visionset_info( "speed_burst", 1, 9, undefined, "speed_burst_initialize" );
}	


function on_player_connect( local_client_num )
{
	filter::init_filter_speed_burst(self);
}

function on_player_spawned( local_client_num )
{
	if( self == GetLocalPlayer( local_client_num ) )
	{
		filter::disable_filter_speed_burst( self,3 );
	}
}

function player_speed_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	if ( newVal )
	{
		if( self == GetLocalPlayer( localClientNum ) )
		{
			filter::enable_filter_speed_burst( self, 3 );
		}
	}
	else
	{
		if( self == GetLocalPlayer( localClientNum ) )
		{
			filter::disable_filter_speed_burst( self,3 );
		}
	}
}