#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_weapons;

#namespace lightning_chain;

function autoexec __init__sytem__() {     system::register("lightning_chain",&init,undefined,undefined);    }





	

#precache( "client_fx", "zombie/fx_tesla_bolt_secondary_zmb" 			);
#precache( "client_fx", "zombie/fx_tesla_shock_zmb" 			);
#precache( "client_fx", "zombie/fx_tesla_bolt_secondary_zmb" 	);
#precache( "client_fx", "zombie/fx_tesla_shock_eyes_zmb"	 	);


function init()
{
	level._effect["tesla_bolt"]				= "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["tesla_shock"]			= "zombie/fx_tesla_shock_zmb";
	level._effect["tesla_shock_secondary"]	= "zombie/fx_tesla_bolt_secondary_zmb";

	level._effect["tesla_shock_eyes"]		= "zombie/fx_tesla_shock_eyes_zmb";

	clientfield::register( "actor", "lc_fx", 1, 2, "int", &lc_shock_fx, !true, true );
	clientfield::register( "vehicle", "lc_fx", 1, 2, "int", &lc_shock_fx, !true, !true );	
}

function lc_shock_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		if ( !isdefined( self.lc_shock_fx ) )
		{
			tag = "J_SpineUpper";
			fx = "tesla_shock";

			if ( !self IsAI() )
			{
				tag = "tag_origin";
			}
				
			if ( newVal > 1 )
			{
				fx = "tesla_shock_secondary";
			}
			self.lc_shock_fx = PlayFxOnTag( localClientNum, level._effect["tesla_shock"], self, "j_spineupper" );
		}
	}
	else
	{
		if ( isdefined( self.lc_shock_fx ) )
		{
			StopFX( localClientNum, self.lc_shock_fx );
			self.lc_shock_fx = undefined;
		}
	}
}
