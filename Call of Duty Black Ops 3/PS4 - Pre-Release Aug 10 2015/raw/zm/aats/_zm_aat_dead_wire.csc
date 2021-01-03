#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                            	

                                                                                                                               

#precache( "client_fx", "zombie/fx_tesla_shock_zmb" );

#namespace zm_aat_dead_wire;

function autoexec __init__sytem__() {     system::register("zm_aat_dead_wire",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}
	
	aat::register( "zm_aat_dead_wire", "zmui_zm_aat_dead_wire" );
	
	clientfield::register( "actor", "zm_aat_dead_wire", 1, 1, "int", &zm_aat_dead_wire_zap, !true, !true );
	
	level._effect[ "zm_aat_dead_wire" ] = "zombie/fx_tesla_shock_zmb";
}


function zm_aat_dead_wire_zap( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		self.fx_aat_dead_wire_zap = PlayFXOnTag( localClientNum, "zombie/fx_tesla_shock_zmb", self, "J_SpineUpper" );
	}
	else if ( isdefined( self.fx_aat_dead_wire_zap ) )
	{
		StopFX( localClientNum, self.fx_aat_dead_wire_zap );
		self.fx_aat_dead_wire_zap = undefined;
	}
}

