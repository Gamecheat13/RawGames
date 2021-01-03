#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

          

                                                                 
                                                                                                                               

#precache( "client_fx", "zombie/fx_bgb_respin_cycle_box_flash_zmb" );

#namespace zm_bgb_respin_cycle;


function autoexec __init__sytem__() {     system::register("zm_bgb_respin_cycle",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_respin_cycle", "activated" );

	clientfield::register( "zbarrier", ("zm_bgb_respin_cycle"), 1, 1, "counter", &zm_bgb_respin_cycle_cb, !true, !true ); 

	level._effect[("zm_bgb_respin_cycle")] = "zombie/fx_bgb_respin_cycle_box_flash_zmb";
}


function zm_bgb_respin_cycle_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	PlayFx( localClientNum, level._effect[("zm_bgb_respin_cycle")], self.origin, AnglesToForward( self.angles ), AnglesToUp( self.angles ) );
}


