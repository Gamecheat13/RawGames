#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;

#using scripts\cp\_load;
#using scripts\cp\_skipto;

#using scripts\codescripts\struct;

#using scripts\cp\cp_mi_zurich_coalescence_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace zurich_city;
//--------------------------------------------------------------------------------------------------
//	ZURICH CITY
//--------------------------------------------------------------------------------------------------
function skipto_main( str_objective, b_starting )
{
	level notify( "update_billboard" );

	level flag::wait_till( "all_players_spawned" );

	skipto::teleport_players( str_objective, false );
	
	//TODO: temp trigger at end of event until scripting complete
	level waittill( str_objective + "_done" );

	skipto::objective_completed( str_objective );
}

function skipto_done( str_objective, b_starting, b_direct, player )
{
	// will disable exploding deaths after each event.
	zurich_util::enable_surreal_ai_fx( false );
}
