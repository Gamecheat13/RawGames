#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_pallas;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                       

function skipto_revenge_init( str_objective, b_starting )
{
	// NOTE: CAN'T USE THIS SKIPTO SINCE THERE WERE NO SPAWNS SETUP FOR IT AND
	//	WE'RE OUT OF SPAWN POINTS SO WE CAN"T PUT NEW ONES
	if ( b_starting )
	{		
		sgen::init_hendricks( str_objective );
		
		util::set_streamer_hint( 4 );
		
		sgen::wait_for_all_players_to_spawn();

		level thread cp_mi_sing_sgen_pallas::elevator_setup();
	}

	//TODO When this scene is blocked out, we'll need to figure out how we need to move the
	//		lift with the players in it.
	level thread cp_mi_sing_sgen_pallas::elevator_lift_outro( b_starting );

	level thread twin_revenge_igc_fxanims();

	level scene::add_scene_func( "cin_sgen_20_twinrevenge_3rd_sh080", &twin_revenge_igc_complete, "done" ); // *_sh010 automatically calls all 8 IGCs one after the other and resumes script after first one
	level scene::play( "cin_sgen_20_twinrevenge_3rd_sh010" );
}

function skipto_revenge_done( str_objective, b_starting, b_direct, player )
{
	
}

function twin_revenge_igc_complete( a_ents )
{
	util::clear_streamer_hint();

	skipto::teleport( "flood_combat" ); // Move Players to Flood Combat Elevator for SkipTo connection
	
	skipto::objective_completed( "twin_revenge" );
}

function twin_revenge_igc_fxanims( a_ents )
{
	// TODO: Notifies from XCAM not being sent, back-up timeouts that are good estimates
	level util::waittill_notify_or_timeout( "flood_bldg_01", 42 );
	level clientfield::set( "w_twin_igc_fxanim", 1 );

	level util::waittill_notify_or_timeout( "flood_bldg_02", 2 );
	level clientfield::set( "w_twin_igc_fxanim", 2 );

	level util::waittill_notify_or_timeout( "flood_bldg_03", 1.5 );
	level clientfield::set( "w_twin_igc_fxanim", 3 );
}
