#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                               	                                                          	              	                                                                                           
                                                           

#using scripts\cp\_ammo_cache;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_objectives;

#using scripts\cp\gametypes\_save;

#using scripts\shared\vehicles\_quadtank;

#using scripts\cp\cp_mi_cairo_infection2_fx;
#using scripts\cp\cp_mi_cairo_infection2_sound;
#using scripts\cp\cp_mi_cairo_infection_util;

#using scripts\cp\cp_mi_cairo_infection_sgen_server_room;
#using scripts\cp\cp_mi_cairo_infection_forest;
#using scripts\cp\cp_mi_cairo_infection_forest_surreal;
#using scripts\cp\cp_mi_cairo_infection_murders;
#using scripts\cp\cp_mi_cairo_infection_village;
#using scripts\cp\cp_mi_cairo_infection_village_surreal;
#using scripts\cp\cp_mi_cairo_infection_church;
#using scripts\cp\cp_mi_cairo_infection_underwater;
#using scripts\cp\cp_mi_cairo_infection_tiger_tank;
#using scripts\cp\cp_mi_cairo_infection_foy_turret;

#precache( "objective", "cp_level_infection_find_dr" );
#precache( "objective", "cp_level_infection_defeat_sarah" );
#precache( "objective", "cp_level_infection_interface_sarah" );
#precache( "objective", "cp_level_infection_access_sarah" );
#precache( "objective", "cp_level_infection_gather_airlock" );
#precache( "objective", "cp_level_infection_gather_church" );
#precache( "objective", "cp_level_infection_destroy_quadtank" );
#precache( "objective", "cp_standard_breadcrumb" );
#precache( "string", "cp_ramses1_fs_connectioninterrupted" );

#precache( "lui_menu", "CACWaitMenu" );

function main()
{
	savegame::set_mission_name("infection");
	
	util::init_streamer_hints( 7 );

	skipto_setup();
	
	callback::on_spawned( &on_player_spawned );
	
	sgen_server_room::main();
	blackstation_murders::main();		
	underwater::main();
	church::init_client_field_callback_funcs();
	forest::init_client_field_callback_funcs();
	village::init_client_field_callback_funcs();
	village_surreal::init_client_field_callback_funcs();
		
	cp_mi_cairo_infection2_fx::main();
	cp_mi_cairo_infection2_sound::main();

	skipto::set_skip_safehouse();

	load::main();

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAPNAME_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAPNAME_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAPNAME_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAPNAME_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAPNAME_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAPNAME_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAPNAME_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAPNAME_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAPNAME_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAPNAME_E";
	
	objectives::complete( "cp_level_infection_find_dr" );
	objectives::complete( "cp_level_infection_defeat_sarah" );
	objectives::complete( "cp_level_infection_interface_sarah" );
	objectives::set( "cp_level_infection_access_sarah" );	
}

function on_player_spawned()
{
	// self = player

	a_skiptos = skipto::get_current_skiptos();
	
	if ( IsDefined( a_skiptos ) )
	{	
		switch( a_skiptos[0] )
		{
			case "sgen_server_room":
				self infection_util::player_enter_cinematic();
				break;
			case "forest_intro":
				self thread reset_snow_fx_respawn();	
				break;							
			case "forest":
				self thread reset_snow_fx_respawn();	
				break;
			case "forest_surreal":
				//self thread reset_snow_fx_respawn();
				self util::set_lighting_state( 1 );
				break;
			case "village":
				self thread reset_snow_fx_respawn();	
				break;
			case "village_house":
				self thread reset_snow_fx_respawn();
				self infection_util::player_enter_cinematic();
				break;
			case "village_inception":
				self thread reset_snow_fx_respawn( 3 );	
				break;							
			case "church":
				self infection_util::player_enter_cinematic();
				break;
			case "cathedral":
				break;	
			default:
				break;
		}
	}
}

function reset_snow_fx_respawn( n_id )
{
	//hack fix when player are teleported
	self infection_util::snow_fx_stop();
	util::wait_network_frame();
	self infection_util::snow_fx_play( n_id );	
}	

function skipto_setup()
{
	skipto::add( "sgen_server_room", &sgen_server_room::sgen_server_room_init, "SGEN - SERVER ROOM", &sgen_server_room::sgen_server_room_done );
	skipto::add_billboard( "sgen_server_room", "SGEN - SERVER ROOM", "IGC 1st Shared", "Small" );
	
	skipto::add( "forest_intro", &forest::intro_main, "BASTOGNE INTRO", &forest::intro_cleanup );
	skipto::add_billboard( "forest_intro", "BASTOGNE INTRO", "IGC - Free Movement", "Small" );

	skipto::add( "forest", &forest::forest_main, "BASTOGNE", &forest::cleanup );
	skipto::add_billboard( "forest", "BASTOGNE", "Combat", "Large" );
	
	skipto::add( "forest_surreal", &forest_surreal::main, "WORLD FALLS AWAY", &forest_surreal::cleanup );
	skipto::add_billboard( "forest_surreal", "WORLD FALLS AWAY", "Combat", "Medium" );
	
	skipto::add( "forest_wolves", &forest_surreal::forest_wolves, "FOREST WOLVES", &forest_surreal::forest_wolves_cleanup );
	
	skipto::add_dev( "dev_black_station_intro", &forest_surreal::dev_black_station_intro, "DEV: BLACK STATION INTRO", &forest_surreal::dev_black_station_cleanup );
	
	skipto::add( "black_station", &blackstation_murders::murders_main, "BLACK STATION", &blackstation_murders::cleanup );
	skipto::add_billboard( "black_station", "BLACK STATION", "IGC - Free Movement", "Small" );
	
	skipto::add( "village", &village::main, "FOY", &village::cleanup );
	skipto::add_billboard( "village", "FOY", "Combat", "Large" );
	
	skipto::add( "village_house", &village::main_house, "FOY HOUSE", &village::cleanup_house );
	skipto::add_billboard( "village_house", "FOY HOUSE", "IGC - Free Movement", "Small" );
	
	skipto::add( "village_inception", &village_surreal::main, "FOLD", &village_surreal::cleanup );
	skipto::add_billboard( "village_inception", "FOLD", "Combat", "Large" );
	
	skipto::add( "church", &church::main_church, "CHURCH", &church::cleanup_church );
	skipto::add_billboard( "church", "CHURCH", "IGC - Free Movement", "Small" );
	
	skipto::add( "cathedral", &church::main_cathedral, "CATHEDRAL", &church::cleanup_cathedral );
	skipto::add_billboard( "cathedral", "CATHEDRAL", "Combat", "Small" );	
	
	skipto::add_dev( "dev_cathedral_outro", &church::dev_cathedral_outro, "CATHEDRAL", &church::dev_cathedral_outro_cleanup );
	
	skipto::add( "underwater", &underwater::underwater_main, "UNDERWATER", &underwater::underwater_cleanup );
	skipto::add_billboard( "underwater", "UNDERWATER", "IGC 1st Shared", "small" );

	//skipto map infection 3
	skipto::add( "hideout", &skipto_infection_3 );
	skipto::add( "interrogation", &skipto_infection_3 );
	skipto::add( "city_barren", &skipto_infection_3 );
	skipto::add( "city", &skipto_infection_3 );
	skipto::add( "city_tree",	&skipto_infection_3 );
	skipto::add( "city_nuked",	&skipto_infection_3 );
	skipto::add( "outro", &skipto_infection_3 );
}


function skipto_infection_3( str_objective, b_starting )
{	
	SwitchMap_Load( "cp_mi_cairo_infection3" );
	
	wait 0.05;
	
	SwitchMap_Switch();
}

