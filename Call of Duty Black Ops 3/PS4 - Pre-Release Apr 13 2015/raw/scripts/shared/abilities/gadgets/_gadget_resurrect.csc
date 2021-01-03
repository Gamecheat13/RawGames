#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


	
function autoexec __init__sytem__() {     system::register("gadget_resurrect",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_localclient_connect( &on_player_connect );
	
	clientfield::register( "allplayers", "resurrecting", 1, 1, "int", &player_resurrect_changed, !true, true );

	duplicate_render::set_dr_filter_offscreen( "resurrecting", 99, 
	                                "resurrecting",                        undefined,                    
	                                2, "mc/hud_keyline_resurrect"  );
}

function on_player_connect( local_client_num )
{
}


function player_resurrect_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	self duplicate_render::set_dr_flag( "resurrecting", newVal );
	self duplicate_render::update_dr_filters();
}

