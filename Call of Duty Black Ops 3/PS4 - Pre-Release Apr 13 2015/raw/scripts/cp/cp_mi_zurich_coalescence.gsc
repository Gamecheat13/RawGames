#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#using scripts\cp\_load;
#using scripts\cp\_skipto;

#using scripts\cp\cp_mi_zurich_coalescence_util;

#using scripts\cp\cp_mi_zurich_coalescence_zurich_city;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_street;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_rails;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_plaza_battle;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_hq;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_sacrifice;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_server_room;
#using scripts\cp\cp_mi_zurich_coalescence_clearing;
#using scripts\cp\cp_mi_zurich_coalescence_root_cairo;
#using scripts\cp\cp_mi_zurich_coalescence_root_singapore;
#using scripts\cp\cp_mi_zurich_coalescence_root_zurich;
#using scripts\cp\cp_mi_zurich_coalescence_nest;
#using scripts\cp\cp_mi_zurich_coalescence_outro;

#using scripts\cp\cp_mi_zurich_coalescence_fx;
#using scripts\cp\cp_mi_zurich_coalescence_sound;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	setup_skiptos();
	
	cp_mi_zurich_coalescence_fx::main();
	cp_mi_zurich_coalescence_sound::main();
	
	skipto::set_final_level();

	level thread t_skipto_init();
	
	load::main();
	
	init_level_vars();
}

//--------------------------------------------------------------------------------------------------
//	SKIPTOs
//--------------------------------------------------------------------------------------------------
function setup_skiptos()
{
	skipto::add( "zurich", &zurich_city::skipto_main, "Zurich", &zurich_city::skipto_done );		
	skipto::add_billboard( "Zurich", "Zurich", "Combat", "Medium" );		

	skipto::add( "street", &zurich_street::skipto_main, "Don't Panic", &zurich_street::skipto_done );
	skipto::add_billboard( "Zurich", "Zurich", "Combat", "Medium" );
	
	skipto::add( "rails", &zurich_rails::skipto_main, "Off the Rails", &zurich_rails::skipto_done );
	skipto::add_billboard( "Zurich", "Zurich", "None", "Medium" );
	
	skipto::add( "plaza_battle", &zurich_plaza_battle::skipto_main, "Coalescence Plaza", &zurich_plaza_battle::skipto_done );
	skipto::add_billboard( "Zurich", "Zurich", "Combat", "Large" );
	
	skipto::add( "hq", &zurich_hq::skipto_main, "HQ", &zurich_hq::skipto_done );
	skipto::add_billboard( "Zurich", "Zurich", "Combat", "Small" );
	
	skipto::add( "sacrifice_igc", &zurich_sacrifice::skipto_main, "Sacrifice", &zurich_sacrifice::skipto_done );
	skipto::add_billboard( "Zurich", "Zurich", "IGC", "Small" );
	
	skipto::add( "server_room", &zurich_server_room::skipto_main, "Server Room", &zurich_server_room::skipto_done );
	skipto::add_billboard( "Zurich", "Zurich", "None", "Small" );

    skipto::add( "clearing_start", &zurich_clearing::skipto_start, "Clearing Start", &zurich_clearing::skipto_start_done );
    skipto::add_billboard( "tree_circle", "Clearing Start", "Combat", "Medium" );

    skipto::add( "clearing_waterfall", &zurich_clearing::skipto_waterfall, "Clearing Waterfall", &zurich_clearing::skipto_waterfall_done );
    skipto::add_billboard( "waterfall", "Clearing Waterfall", "Combat", "Medium" );

	skipto::add( "clearing_path_choice", &zurich_clearing::skipto_path_choice, "Clearing Path Choice" );
	skipto::add_billboard( "clearing_path_choice", "Clearing Path Choice", "Combat", "Medium" );    
	
	//anything after this point will have to use add_branch or it will assert
	skipto::add_branch( "clearing_end", &zurich_clearing::skipto_end, "Clearing End", &zurich_clearing::end_skipto_done, "clearing_path_choice", "root_cairo_start,root_singapore_start,root_zurich_start" );
	skipto::add_billboard( "clearing_end", "Clearing End", "Combat", "Medium" );		

	skipto::add_branch( "root_cairo_start", &root_cairo::skipto_main,	"Cairo Root", undefined, "clearing_end", "root_cairo_end" );
	skipto::add_branch( "root_cairo_end", &root_cairo::skipto_end,	"Cairo Root End", &root_cairo::skipto_done, "root_cairo_start", "clearing_end" );
	skipto::add_billboard( "root_cairo_end", "Cairo Root", "Combat", "Medium" );		
		
	skipto::add_branch( "root_singapore_start", &root_singapore::skipto_main,	"Singapore Root", undefined, "clearing_end", "root_singapore_end" );
	skipto::add_branch( "root_singapore_end", &root_singapore::skipto_end,	"Singapore Root End", &root_singapore::skipto_done, "root_singapore_start", "clearing_end" );
	skipto::add_billboard( "root_singapore_end", "Singapore Root", "Combat", "Medium" );		

	skipto::add_branch( "root_zurich_start", &root_zurich::skipto_main,	"Zurich Root", undefined, "clearing_end", "root_zurich_end" );	
	skipto::add_branch( "root_zurich_end", &root_zurich::skipto_end,	"Zurich Root End", &root_zurich::skipto_done, "root_zurich_start", "clearing_end" );	
	skipto::add_billboard( "root_zurich_end", "Zurich Root", "Combat", "Medium" );		

	skipto::add_branch( "nest", &zurich_nest::skipto_main, "Nest", &zurich_nest::skipto_done, "root_cairo_start&root_singapore_start&root_zurich_start", "zurich_outro" );
	skipto::add_billboard( "nest", "Nest", "Combat", "Medium" );		
		
	skipto::add_branch( "zurich_outro", &zurich_outro::skipto_main, "Outro", &zurich_outro::skipto_done, "nest", undefined );
	skipto::add_billboard( "zurich_outro", "Outro", "Combat", "Medium" );	
		
}

function init_level_vars()
{
	level.num_roots_completed = 0;	
}	

//--------------------------------------------------------------------------------------------------
//	SKIPTO SYSTEM
//--------------------------------------------------------------------------------------------------
function t_skipto_init()
{
	t_skiptos = GetEntArray( "zurich_skipto", "targetname" );
	array::thread_all( t_skiptos, &t_skipto );
}
	
function t_skipto()
{
	while( true )
	{
		self waittill( "trigger", who );
		
		if( IsPlayer( who ) )
		{	
			str_objective = self.script_objective;
			if( !isdefined( str_objective ) )
			{
				str_objective = "zurich";
			}

			level notify( str_objective + "_done" );

			//currently ending root end triggers for IGCs
			if( IsSubStr( str_objective, "root_" ) && IsSubStr( str_objective, "_end" ) )
			{	
				return;
			}

			skipto::objective_completed( str_objective );
		}
	}	
}
