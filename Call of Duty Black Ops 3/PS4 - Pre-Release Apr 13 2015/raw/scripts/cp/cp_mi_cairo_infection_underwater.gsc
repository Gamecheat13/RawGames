#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_dialog;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_infection_util;


#precache( "model", "p7_church_pew_01" );
#precache( "model", "c_ger_winter_soldier_1_body" );
#precache( "model", "c_ger_winter_soldier_2_body" );
#precache( "model", "p7_book_vintage_02_burn" );
#precache( "model", "p7_book_vintage_open_01_burn" );

#namespace underwater;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	init_clientfields();
}

function init_clientfields()
{
	clientfield::register("world", "infection_underwater_debris", 1, 1, "int" );
}	
//--------------------------------------------------------------------------------------------------
//		UNDERWATER
//		30 sec. cinematic
//		camera locked, rail. can look around
//--------------------------------------------------------------------------------------------------
function underwater_main(str_objective, b_starting)
{
	level notify( "update_billboard" );

	level flag::wait_till( "all_players_spawned" );

	level thread handle_underwater_environment();

	foreach ( player in level.players )
	{
		player EnableInvulnerability();
	}
	
	level thread scene::play( "cin_inf_12_01_underwater_1st_fall_underwater02");
}	

function handle_underwater_environment()
{
	//creates clientsided underwater debris
	level thread clientfield::set("infection_underwater_debris", 1);
		
	level util::waittill_either( "underwater_scene_fade", "underwater_scene_done" );
	level thread util::screen_fade_out( 2, "black" );
		
//	level infection_util::movie_transition( "cp_ramses1_fs_connectioninterrupted" );

	level thread skipto::objective_completed("underwater");		
}	

//---- CLEANUP -------------------------------------------------------------------------------------
function underwater_cleanup(str_objective, b_starting, b_direct, player)
{
	//deletes clientsided underwater debris
	level thread clientfield::set("infection_underwater_debris", 0);
}

