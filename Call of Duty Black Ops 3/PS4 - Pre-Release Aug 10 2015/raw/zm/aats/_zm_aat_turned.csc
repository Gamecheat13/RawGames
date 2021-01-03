#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                             	

                                                                                                                               

#precache( "client_fx", "zombie/fx_octobomb_spore_burn_torso_zod_zmb" );

#namespace zm_aat_turned;

function autoexec __init__sytem__() {     system::register("zm_aat_turned",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}
	
	aat::register( "zm_aat_turned", "zmui_zm_aat_turned" );
	
	clientfield::register( "actor", "zm_aat_turned", 1, 1, "int", &zm_aat_turned_cb, !true, !true ); 
}


function zm_aat_turned_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( IsDefined( self.zm_aat_turned_eyes ) )
	{
		return;
	}

	if ( !newVal )
	{
		return;
	}

	self PlaySound( localClientNum, "" );
	
	// If zombie is afflicted by Turned, FX on eyes flashes every 1 second. Ends when zm_aat_turned_eyes is undefined
	self zombie_turned_fx( localClientNum );
	
	// TODO FURTHER FX
}

function zombie_turned_fx( localClientNum )
{
	self endon( "entityshutdown" );
	
	linktag = "j_eyeball_le";
	self.zm_aat_turned_eyes = PlayFXOnTag( localClientNum, "zombie/fx_octobomb_spore_burn_torso_zod_zmb", self, linktag );
	
	while ( isdefined( self.zm_aat_turned_eyes ) && isdefined( self ) )
	{
		wait 1.0;
		self.zm_aat_turned_eyes = PlayFXOnTag( localClientNum, "zombie/fx_octobomb_spore_burn_torso_zod_zmb", self, "j_eyeball_le" );
	} 
}
