#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\filter_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace empgrenade;
function autoexec __init__sytem__() {     system::register("empgrenade",&__init__,undefined,undefined);    }		
	
	
function __init__()
{
	clientfield::register( "toplayer", "empd", 1, 1, "int", &onEmpChanged, !true, true );
}

function onEmpChanged( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	localPlayer = GetLocalPlayer( localClientNum );
	filter::init_filter_tactical( localPlayer );
	
	if( newVal == 1 )
	{
		filter::enable_filter_tactical( localPlayer, 2 );
		filter::set_filter_tactical_amount( localPlayer, 2, 1.0 );
		playsound( 0, "mpl_plr_emp_activate", (0,0,0) );
		audio::playloopat( "mpl_plr_emp_looper", (0,0,0) );
	}
	else
	{
		filter::disable_filter_tactical( localPlayer, 2 );
		
		if( oldVal != 0 )
			playsound( 0, "mpl_plr_emp_deactivate", (0,0,0) );
		
		audio::stoploopat( "mpl_plr_emp_looper", (0,0,0) );		
	}
}
