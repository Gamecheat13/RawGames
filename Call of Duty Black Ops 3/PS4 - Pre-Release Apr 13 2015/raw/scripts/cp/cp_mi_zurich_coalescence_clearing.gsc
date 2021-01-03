#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#using scripts\cp\_load;
#using scripts\cp\_skipto;

#using scripts\cp\cp_mi_zurich_coalescence_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace zurich_clearing;
//--------------------------------------------------------------------------------------------------
//	ZURICH CLEARING
//--------------------------------------------------------------------------------------------------
function skipto_start( str_objective, b_starting )
{
	level notify( "update_billboard" );

	zurich_util::enable_surreal_ai_fx( true );

	level flag::wait_till( "all_players_spawned" );

	skipto::teleport_players( str_objective, false );

}

function skipto_start_done( str_objective, b_starting, b_direct, player )
{
}

function skipto_waterfall( str_objective, b_starting )
{
	level notify( "update_billboard" );

	zurich_util::enable_surreal_ai_fx( true );

	level flag::wait_till( "all_players_spawned" );

	if( b_starting )
	{
		skipto::teleport_players( str_objective, false );
	}
}

function skipto_waterfall_done( str_objective, b_starting, b_direct, player )
{
}

function skipto_path_choice( str_objective, b_starting )
{
	level notify( "update_billboard" );

	zurich_util::enable_surreal_ai_fx( true );

	level flag::wait_till( "all_players_spawned" );

	if( b_starting )
	{
		skipto::teleport_players( str_objective, false );
	}

}

function skipto_end( str_objective, b_starting )
{
	level flag::wait_till( "all_players_spawned" );

	//TODO: hack, finished all three roots.
	if( ( level.num_roots_completed === 3 ) )
	{
		skipto::teleport_players( "nest", false );
	}	
	else if( b_starting || ( isdefined( level.force_teleport ) && level.force_teleport ) )
	{	
		skipto::teleport_players( str_objective, false );

		level.force_teleport = undefined;
	}
}
function end_skipto_done( str_objective, b_starting, b_direct, player )
{
}


