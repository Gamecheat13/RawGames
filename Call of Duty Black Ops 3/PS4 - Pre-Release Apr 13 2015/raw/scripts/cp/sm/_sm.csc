#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\cp\sm\_sm_ai_manager;
#using scripts\cp\sm\_sm_score;
#using scripts\cp\sm\_sm_ui;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  




#namespace sm;
	
#precache( "client_fx", "light/fx_glow_barricade_close" );
#precache( "client_fx", "light/fx_glow_dogtag" );

function autoexec __init__sytem__() {     system::register("sm_barricade",&sm::__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "scriptmover", "sm_barricade_glow", 1, 1, "int", &barricade_glow_fx, !true, !true );
	clientfield::register( "scriptmover", "sm_scavenger_glow", 1, 1, "int", &scavenger_glow_fx, !true, !true );
}

function barricade_glow_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		n_fx_id = PlayFxOnTag( localClientNum, "light/fx_glow_barricade_close", self, "tag_origin" );
	}
}

function scavenger_glow_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		n_fx_id = PlayFxOnTag( localClientNum, "light/fx_glow_dogtag", self, "tag_origin" );
	}
}
