#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

               

                                                                 
                                                                                                                               

#namespace zm_bgb_in_plain_sight;


function autoexec __init__sytem__() {     system::register("zm_bgb_in_plain_sight",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_in_plain_sight", "activated", 1, undefined, undefined, undefined, &activation );

	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_in_plain_sight))level.vsmgr_prio_visionset_zm_bgb_in_plain_sight=110;
	visionset_mgr::register_info( "visionset", "zm_bgb_in_plain_sight", 1, level.vsmgr_prio_visionset_zm_bgb_in_plain_sight, 31, true, &visionset_mgr::ramp_in_out_thread_per_player, false );

	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_in_plain_sight))level.vsmgr_prio_overlay_zm_bgb_in_plain_sight=110;
	visionset_mgr::register_info( "overlay", "zm_bgb_in_plain_sight", 1, level.vsmgr_prio_overlay_zm_bgb_in_plain_sight, 1, true );
}

function activation()
{
	self endon( "disconnect" );

	self zm_utility::increment_ignoreme();
	
	self playsound( "zmb_bgb_plainsight_start" );
	self playloopsound( "zmb_bgb_plainsight_loop", 1 );

	self thread bgb::run_timer( (0.5 + 9 + 0.5) );

	visionset_mgr::activate( "visionset", "zm_bgb_in_plain_sight", self, 0.5, 9, 0.5 );
	visionset_mgr::activate( "overlay", "zm_bgb_in_plain_sight", self );

	self thread wait_for_deactivate();
	
	wait( 0.5 + 9 );
	
	self notify( "bgb_deactivate" );
}

function wait_for_deactivate()
{
	self util::waittill_any( "bgb_deactivate", "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect" );
	
	self thread deactivate();
}

function deactivate()
{
	visionset_mgr::deactivate( "overlay", "zm_bgb_in_plain_sight", self );

	wait( 0.5 );

	self stoploopsound( 1 );
	self playsound( "zmb_bgb_plainsight_end" );

	self zm_utility::decrement_ignoreme();

	bgb::activation_complete();
}
