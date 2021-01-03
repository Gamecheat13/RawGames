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

	bgb::register( "zm_bgb_in_plain_sight", "activation", 1, undefined, undefined, &activation );

	if ( !IsDefined( level.vsmgr_prio_visionset_zm_bgb_in_plain_sight ) )
	{
		level.vsmgr_prio_visionset_zm_bgb_in_plain_sight = 20;
	}					
	visionset_mgr::register_info( "visionset", "zm_bgb_in_plain_sight", 1, level.vsmgr_prio_visionset_zm_bgb_in_plain_sight, 31, true, &visionset_mgr::ramp_in_out_thread_per_player, false );
}


function activation()
{
	self endon( "disconnect" );

	old_ignoreme = self.ignoreme;
	self.ignoreme = true;

	visionset_mgr::activate( "visionset", "zm_bgb_in_plain_sight", self, 1, 8, 1 );

	wait( (1 + 8 + 1) );	

	self.ignoreme = old_ignoreme;
}
