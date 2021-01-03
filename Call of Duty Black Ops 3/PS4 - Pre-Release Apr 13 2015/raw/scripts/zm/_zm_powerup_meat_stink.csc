#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_powerups;

                                                                
                                                                                                                               

#precache( "client_fx", "_t6/maps/zombie/fx_zmb_meat_stink_camera" );
#precache( "client_fx", "_t6/maps/zombie/fx_zmb_meat_stink_torso" );

#namespace zm_powerup_meat_stink;

function autoexec __init__sytem__() {     system::register("zm_powerup_meat_stink",&__init__,undefined,undefined);    }
	
function __init__()
{
	zm_powerups::include_zombie_powerup( "meat_stink" );
	zm_powerups::add_zombie_powerup( "meat_stink" );
	
	clientfield::register( "toplayer", "meat_stink", 1, 1, "int", &meat_stink_cb, !true, true );
	
	level._effect[ "meat_stink_camera" ] = "_t6/maps/zombie/fx_zmb_meat_stink_camera";
	level._effect[ "meat_stink_torso" ] = "_t6/maps/zombie/fx_zmb_meat_stink_torso";
}

function meat_stink_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newval)
	{
		self.meatstink_fx = PlayFXOnTag(localClientNum, level._effect[ "meat_stink_camera" ], self, "J_SpineLower");		
	}
	else
	{
		if(isdefined(self.meatstink_fx))
		{
			stopfx(localClientNum,self.meatstink_fx);
			self.meatstink_fx = undefined;
		}
	}
}
