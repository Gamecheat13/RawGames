#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#using scripts\cp\_load;
#using scripts\cp\_skipto;

#using scripts\cp\cp_mi_zurich_coalescence_util;
#using scripts\cp\cp_mi_zurich_coalescence_root_cinematics;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace root_cairo;
//--------------------------------------------------------------------------------------------------
//	CAIRO ROOT
//--------------------------------------------------------------------------------------------------
function skipto_main( str_objective, b_starting )
{
	level notify( "update_billboard" );

	level flag::wait_till( "all_players_spawned" );

	skipto::teleport_players( str_objective, false );
}

function skipto_end( str_objective, b_starting )
{
	//delete trigger once gone down path
	t_skipto = GetEnt( "root_cairo_start", "script_objective" );
	t_skipto Delete();

	zurich_util::enable_surreal_ai_fx( true );

	level flag::wait_till( "all_players_spawned" );

	skipto::teleport_players( str_objective, false );

	if( !isdefined( level.num_roots_completed ) )
	{
		level.num_roots_completed = 0;
	}		
	level.num_roots_completed++;

	level.force_teleport = true; //to force teleport out of root areas

	level waittill( str_objective + "_done" );
	
	root_cinematics::play_scene();
		
	skipto::objective_completed( str_objective );
}

function skipto_done( str_objective, b_starting, b_direct, player )
{
}
