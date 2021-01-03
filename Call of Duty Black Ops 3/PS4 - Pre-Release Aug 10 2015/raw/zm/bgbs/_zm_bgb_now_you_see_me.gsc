#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                 

                                                                 
                                                                                                                               

#namespace zm_bgb_now_you_see_me;


function autoexec __init__sytem__() {     system::register("zm_bgb_now_you_see_me",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_now_you_see_me", "activated", 1, undefined, undefined, undefined, &activation );

	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_now_you_see_me))level.vsmgr_prio_visionset_zm_bgb_now_you_see_me=111;
	visionset_mgr::register_info( "visionset", "zm_bgb_now_you_see_me", 1, level.vsmgr_prio_visionset_zm_bgb_now_you_see_me, 31, true, &visionset_mgr::ramp_in_out_thread_per_player, false );

	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_now_you_see_me))level.vsmgr_prio_overlay_zm_bgb_now_you_see_me=111;
	visionset_mgr::register_info( "overlay", "zm_bgb_now_you_see_me", 1, level.vsmgr_prio_overlay_zm_bgb_now_you_see_me, 1, true );
}

function activation()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "bled_out" );
	
	self.b_is_designated_target = true;

	self thread bgb::run_timer( (0.5 + 9 + 0.5) );

	visionset_mgr::activate( "visionset", "zm_bgb_now_you_see_me", self, 0.5, 9, 0.5 );
	visionset_mgr::activate( "overlay", "zm_bgb_now_you_see_me", self );

	wait( 0.5 + 9 );

	visionset_mgr::deactivate( "overlay", "zm_bgb_now_you_see_me", self );

	wait( 0.5 );

	self.b_is_designated_target = false;

	bgb::activation_complete();
}
