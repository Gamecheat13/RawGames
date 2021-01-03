#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives; 
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_zurich_newworld;
#using scripts\cp\cp_mi_zurich_newworld_util;
	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
           	    

#namespace newworld_lab;


//----------------------------------------------------------------------------
//	Dev skipto for art/build evaluation purposes
//
function dev_lab_init( str_objective, b_starting )
{
	newworld_util::wait_for_all_players_to_spawn();

	skipto::teleport( "waking_up_igc" );
}
	
	
//----------------------------------------------------------------------------
//
//
function skipto_waking_up_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		newworld_util::wait_for_all_players_to_spawn();
	}
	
	skipto::teleport( str_objective );
	
	level thread util::screen_fade_in( 2.0, "white" );

	level thread scene::play( "cin_new_17_01_wakingup_1st_reveal" );
	
	level waittill( "wakingup_igc_shutdown_note" );
	
	util::screen_fade_out( 2.0, "white" );

	skipto::objective_completed( str_objective );
}

function skipto_waking_up_igc_done( str_objective, b_starting, b_direct, player )
{
}


