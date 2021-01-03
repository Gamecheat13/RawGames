#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\weapons\replay_gun;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

#using scripts\shared\abilities\gadgets\_gadget_armor; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_speed_burst;   // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_camo;   // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_vision_pulse; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_hero_weapon; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_other; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_combat_efficiency; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_flashback; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_cleanse; // for loading purposes only - do not use from here

#using scripts\shared\abilities\gadgets\_gadget_system_overload; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_servo_shortout; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_exo_breakdown; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_surge; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_security_breach; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_iff_override; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_takedown; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_es_strike; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_ravage_core; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_concussive_wave; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_overdrive; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_unstoppable_force; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_rapid_strike; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_sensory_overload; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_forced_malfunction; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_immolation; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_firefly_swarm; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_smokescreen; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_misdirection; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_cacophony; // for loading purposes only - do not use from here
//#using scripts\shared\abilities\gadgets\_gadget_active_camo; // reusing optic_camo client script

#using scripts\shared\abilities\gadgets\_gadget_shock_field; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_resurrect; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_heat_wave; // for loading purposes only - do not use from here

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#namespace ability_player;

function autoexec __init__sytem__() {     system::register("ability_player",&__init__,undefined,undefined);    }

function __init__()
{
	setup_clientfields();
	callback::on_localclient_connect(&on_localclient_connect);
	
	// this makes sure we can turn off gadgets visionsets with a default one
	// visionset_mgr::init_fog_vol_to_visionset_monitor( "default_night", 2 );
}

function setup_clientfields()
{
}

function on_localclient_connect( localClientNum )
{
}

