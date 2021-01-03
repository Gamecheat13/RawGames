#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#using scripts\cp\_load;
#using scripts\cp\_skipto;

#using scripts\cp\cp_mi_zurich_coalescence_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace zurich_outro;
//--------------------------------------------------------------------------------------------------
//	ZURICH OUTRO
//--------------------------------------------------------------------------------------------------
function skipto_main( str_objective, b_starting )
{
	level notify( "update_billboard" );

	level flag::wait_till( "all_players_spawned" );

	skipto::teleport_players( str_objective, false );

}

function skipto_done( str_objective, b_starting, b_direct, player )
{
}
