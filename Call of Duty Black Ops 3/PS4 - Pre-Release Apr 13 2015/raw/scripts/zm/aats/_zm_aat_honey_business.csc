#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                    

                                                                                                                               

#precache( "client_fx", "zombie/fx_aat_honey_business_zmb" );

#namespace zm_aat_dead_paint;

function autoexec __init__sytem__() {     system::register("zm_aat_honey_business",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	clientfield::register( "actor", "zm_aat_honey_business", 1, 1, "int", &zm_aat_honey_business_cb, !true, !true ); 

	level._effect["zm_aat_honey_business"]	= "zombie/fx_aat_honey_business_zmb";
}


function zm_aat_honey_business_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( IsDefined( self.zm_aat_honey_business_fx_handle ) )
	{
		StopFX( localClientNum, self.zm_aat_honey_business_fx_handle );
	}

	if ( !newVal )
	{
		return;
	}

	self PlaySound( localClientNum, "wpn_aat_honey_business_npc" );

	tag = "J_SpineUpper";
	if ( self.isdog )
	{
		tag = "J_Spine1";
	}

	self.zm_aat_honey_business_fx_handle = PlayFXOnTag( localClientNum, level._effect["zm_aat_honey_business"], self, tag );
}
