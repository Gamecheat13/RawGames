
#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\postfx_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   	

#using scripts\zm\_util;
#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_ai_wasp;



function autoexec __init__sytem__() {     system::register("zm_ai_wasp",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "world", "toggle_on_parasite_fog", 1, 2, "int", &parasite_fog_on, !true, !true );
	
	visionset_mgr::register_overlay_info_style_postfx_bundle( "zm_wasp_round", 1, "pstfx_zm_wasp_round", 7, 3 );
}

function parasite_fog_on( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	
	//turn on parasite.
	if ( newVal == 1 )
	{
		for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
		{
			SetLitFogBank( localClientNum, -1, 1, -1 );
			SetWorldFogActiveBank( localClientNum, 2 );
		}
	}
	
	//turn off parasite.
	if ( newVal == 2 )
	{
		for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
		{
			SetLitFogBank( localClientNum, -1, 0, -1 );
			SetWorldFogActiveBank( localClientNum, 1 );	
		}
	}
}