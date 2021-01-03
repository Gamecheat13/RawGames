#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\postfx_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
       	   	                 	                               	                    	                                 	                                        	                            	                                                                  	                               	  	                               	                    	                                 	                                        	                            	                                                                  	                               	      	     	  


	
function autoexec __init__sytem__() {     system::register("gadget_resurrect",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "allplayers", "resurrecting", 1, 1, "int", &player_resurrect_changed, !true, true );
	clientfield::register( "toplayer", "resurrect_state", 1, 2, "int", &player_resurrect_state_changed, !true, true );

	duplicate_render::set_dr_filter_offscreen( "resurrecting", 99, 
	                                "resurrecting",                        undefined,                    
	                                2, "mc/hud_keyline_resurrect", 0  );
	
	visionset_mgr::register_visionset_info( "resurrect", 1, 16, undefined, "mp_ability_resurrection" );
	visionset_mgr::register_visionset_info( "resurrect_up", 1, 16, undefined, "mp_ability_wakeup" );
}


function player_resurrect_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	self duplicate_render::update_dr_flag( "resurrecting", newVal );
}

function resurrect_down_fx( localClientNum )
{
	self endon ( "entityshutdown" );
	self endon ( "finish_rejack" );
		
	self thread postfx::PlayPostfxBundle( "pstfx_resurrection_close" );
	wait( .5 );
	self thread postfx::PlayPostfxBundle( "pstfx_resurrection_pus" );
}

function resurrect_up_fx( localClientNum )
{
	self endon ( "entityshutdown" );
	self notify( "finish_rejack" );
	
	self thread postfx::PlayPostfxBundle( "pstfx_resurrection_open" );
}

function player_resurrect_state_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		self thread resurrect_down_fx( localClientNum );
	}
	else if( newVal == 2 )
	{
		self thread resurrect_up_fx( localClientNum );
	}
	else
	{
		self thread postfx::stopPostfxBundle();
	}
}

