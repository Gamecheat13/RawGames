#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace turret;

function autoexec __init__sytem__() {     system::register("turret",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "vehicle", "toggle_lensflare", 					1, 1, "int", &field_toggle_lensflare, 			!true, !true );
}

function field_toggle_lensflare( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( !isdefined( self.scriptbundlesettings ) )
	{
		return;
	}

	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	if ( !isdefined( settings ) )
	{
		return;
	}

	if( isdefined( self.turret_lensflare_id ) )
	{
		DeleteFX( localClientNum, self.turret_lensflare_id );
		self.turret_lensflare_id = undefined;
	}

	if( newVal )
	{
		if ( isdefined( settings.lensflare_fx ) && isdefined( settings.lensflare_tag ) )
		{
			self.turret_lensflare_id = PlayFxOnTag( localClientNum, settings.lensflare_fx, self, settings.lensflare_tag );
		}
		else
		{
			//self.turret_lensflare_id = PlayFXOnTag( localClientNum, level._effect[ "turret_lens_flare" ], self, "tag_fx" );
		}
	}
}
