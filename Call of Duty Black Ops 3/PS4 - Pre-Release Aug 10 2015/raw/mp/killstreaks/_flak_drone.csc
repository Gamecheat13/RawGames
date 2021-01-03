#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using  scripts\shared\vehicle_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\_helicopter_sounds;
#using scripts\mp\_util;

                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     

#using scripts\shared\duplicaterender_mgr;
                                                                                

#namespace flak_drone;



function autoexec __init__sytem__() {     system::register("flak_drone",&__init__,undefined,undefined);    }
	
function __init__()
{		
	clientfield::register( "vehicle", "flak_drone_camo", 1, 3, "int", &active_camo_changed, !true, !true );
}

function active_camo_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	flags_changed = self duplicate_render::set_dr_flag( "active_camo_flicker", newVal == ( 2 ) );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "active_camo_on", false );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "active_camo_reveal", true );
	if ( flags_changed )
	{
		self duplicate_render::update_dr_filters();
	}
	
	self notify( "endtest" );
	
	self thread doReveal( localClientNum, newVal != ( 0 ) );
}

function doReveal( localClientNum, direction )
{
	self notify( "endtest" );
	self endon( "endtest" );
	
	self endon( "entityshutdown" );
	
	if( direction )
	{
		startVal = 1;
	}
	else
	{
		startVal = 0;
	}
	
	while( ( startVal >= 0 ) && ( startVal <= 1 ) )
	{
		self MapShaderConstant( localClientNum, 0, "scriptVector0", startVal, 0, 0, 0 );
		if( direction )
		{
			startVal -= .016 / 0.5;
		}
		else
		{
			startVal += .016 / 0.5;
		}
		wait( .016 );
	}
	
	flags_changed = self duplicate_render::set_dr_flag( "active_camo_reveal", false );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "active_camo_on", direction );
	if ( flags_changed )
	{
		self duplicate_render::update_dr_filters();
	}
}