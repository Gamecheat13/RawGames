#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

               

                                                                                                                               

#precache( "client_fx", "zombie/fx_aat_dead_paint_zmb" );

#namespace zm_aat_dead_paint;

function autoexec __init__sytem__() {     system::register("zm_aat_dead_paint",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	clientfield::register( "actor", "zm_aat_dead_paint", 1, 1, "counter", &zm_aat_dead_paint_cb, !true, !true ); 

	level._effect["zm_aat_dead_paint"]	= "zombie/fx_aat_dead_paint_zmb";
}


function zm_aat_dead_paint_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	PlaySound( localClientNum, "wpn_aat_dead_paint_npc", self.origin );

	PlayFX( localClientNum, level._effect["zm_aat_dead_paint"], self.origin );
}
