#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_hacking;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_dialog;
#using scripts\cp\cybercom\_cybercom_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                       
                                                                                                      	                       	     	                                                                     

#precache( "triggerstring", "CP_MI_SING_SGEN_LAB_HACK_DOOR" );

function skipto_testing_lab_igc_init( str_objective, b_starting )
{
	level flag::init( "lab_door_ready" );
	
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		
		objectives::set( "cp_level_sgen_breadcrumb" , struct::get( "fallen_soldiers_end_breadcrumb" ) );
		
		level scene::init( "cin_sgen_14_humanlab_3rd_sh005" );
	}
	
	level thread vo();
	
	// Turn off floating
	level clientfield::set( "w_underwater_state", 0 );
	
	util::set_streamer_hint( 2 );

	level testing_lab_entrance();

	sgen_util::coop_teleport_on_igc_end( "cin_sgen_14_humanlab_3rd_sh200", "post_testing_lab_igc" );
	level scene::add_scene_func( "cin_sgen_14_humanlab_3rd_sh005", &humanlab_3rd_sh005, "play" );
	level scene::add_scene_func( "cin_sgen_14_humanlab_3rd_sh200", &dni_lab_igc_complete, "done" );
	level scene::play( "cin_sgen_14_humanlab_3rd_sh005" );
}

function skipto_testing_lab_igc_done( str_objective, b_starting, b_direct, player )
{
	level scene::init( "cin_sgen_14_humanlab_3rd_sh005" ); // Need these doors back
}

function humanlab_3rd_sh005( a_ents )
{
	level thread hacking::hack( 1 );
	
	foreach ( e_in_scene in a_ents )
	{
		if ( IsPlayer( e_in_scene ) )
		{
			e_in_scene cybercom::cyberCom_armPulse(1);
		}
	}
}

function dni_lab_igc_complete( a_ents )
{
	util::clear_streamer_hint();
	skipto::objective_completed( "testing_lab_igc" );
}

function testing_lab_entrance()
{
	level.ai_hendricks SetGoal( GetNode( "fallen_soldiers_hendricks_hack_door_node", "targetname" ), true );
	
	level flag::wait_till( "lab_door_ready" );
	
	s_obj = struct::get( "testing_lab_door_obj" );

	objectives::complete( "cp_level_sgen_breadcrumb" );
	objectives::set( "cp_level_sgen_hack_door", s_obj.origin );
	
	trigger::wait_till( "trig_testing_lab_door", undefined, undefined, false );
	
	level.ai_hendricks ClearForcedGoal();

	level notify( "door_opened" );
	
	objectives::complete( "cp_level_sgen_hack_door" );
}

function vo()
{
	trigger::wait_or_timeout( 5, "testing_lab_vo_looktrig", "targetname" );
	
	dialog::remote( "kane_signal_s_beyond_that_0" ); // Signal’s beyond that door, that panel should get you in.
	
	level.ai_hendricks dialog::say( "hend_hack_the_panel_i_go_0", RandomFloatRange( .15, .25 ) );	// Hack the panel. I got your six.
	
	level flag::set( "lab_door_ready" );
	
	do_nag();
}

function do_nag()
{
	level endon( "door_opened" );
	
	wait 8;
	level.ai_hendricks dialog::say( "hend_hack_the_panel_i_go_0", RandomFloatRange( 1, 1.3 ) );	// Hack the panel. I got your six.
	
	wait 16;
	level.ai_hendricks dialog::say( "hend_wanna_hurry_up_we_n_0" ); // Wanna hurry up? We need to get in there.
}
