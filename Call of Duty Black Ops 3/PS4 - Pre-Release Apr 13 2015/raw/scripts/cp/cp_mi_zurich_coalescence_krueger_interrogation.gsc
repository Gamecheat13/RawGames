#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#using scripts\cp\_load;
#using scripts\cp\_skipto;

#using scripts\cp\cp_mi_zurich_coalescence_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace krueger_interrogation;
//--------------------------------------------------------------------------------------------------
//	KRUEGER INTERROGATION
//--------------------------------------------------------------------------------------------------
function skipto_main( str_objective, b_starting )
{
	level notify( "update_billboard" );

	skipto::teleport_players( str_objective, false );

	level flag::wait_till( "all_players_spawned" );

	//TODO: temp trigger at end of event until scripting complete
	level waittill( str_objective + "_done" );

	skipto::objective_completed( str_objective );
}

function skipto_done( str_objective, b_starting, b_direct, player )
{
}