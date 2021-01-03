#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_zurich_coalescence_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace root_cinematics;
//--------------------------------------------------------------------------------------------------
//	ROOT CINEMATICS
//--------------------------------------------------------------------------------------------------
function play_scene()
{
	util::screen_fade_out( 0, "black" );
	level thread util::screen_fade_in( 2, "black" );	
	
	if ( isdefined( level.num_roots_completed ) )
	{	
		switch( level.num_roots_completed )
		{
			case 1:
				str_scene = "cin_inf_04_humanlabdeath_3rd_sh010";
				final_scene = "cin_inf_04_humanlabdeath_3rd_sh140";
				break;
			case 2:
				str_scene = "cin_inf_05_taylorinfected_server_3rd_sh010";
				final_scene = "cin_inf_05_taylorinfected_server_3rd_sh090";
				break;
			case 3:
				//str_scene = "cin_inf_14_01_nasser_vign_interrogate";
				//final_scene = "cin_inf_14_01_nasser_vign_interrogate";
				//break;
				level waittill( "root_scene_completed" ); //scene doesn't have player camera.
				return;				
		}
	}

	scene::add_scene_func(final_scene, &scene_done_watcher , "done" );
	
	level thread scene::play( str_scene );
		
	level waittill( "root_scene_completed" );	
}

function scene_done_watcher( a_ents )
{
	level notify( "root_scene_completed" );	
}	

