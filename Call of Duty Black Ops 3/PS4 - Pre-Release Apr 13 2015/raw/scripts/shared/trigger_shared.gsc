
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "_t6/lens_flares/fx_lf_commandcenter_cic" );//TODO T7 - have gdt set this up, use scriptbundle

#namespace turret;

function autoexec __init__sytem__() {     system::register("turret",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "vehicle", "toggle_lensflare", 					1, 1, "int", &field_toggle_lensflare, 			!true, !true );
	
	level._effect[ "turret_lens_flare" ] = "_t6/lens_flares/fx_lf_commandcenter_cic";//TODO T7 - have gdt set this up, use scriptbundle
}

function field_toggle_lensflare( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal )
	{
		self.turret_lensflare_id = PlayFXOnTag( localClientNum, level._effect[ "turret_lens_flare" ], self, "tag_fx" );
	}
	else
	{
		if( isdefined( self.turret_lensflare_id ) )
		{
			DeleteFX( localClientNum, self.turret_lensflare_id );
			self.turret_lensflare_id = undefined;
		}
	}
}
