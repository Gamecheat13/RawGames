#using scripts\codescripts\struct;

#using scripts\cp\gametypes\_save;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                               	                                                          	              	                                                                                           

#using scripts\cp\_ammo_cache;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_objectives;

#using scripts\cp\cp_mi_cairo_infection_fx;
#using scripts\cp\cp_mi_cairo_infection_sound;
#using scripts\cp\cp_mi_cairo_infection_util;

#using scripts\cp\cp_mi_cairo_infection_theia_battle;
#using scripts\cp\cp_mi_cairo_infection_sim_reality_starts;
#using scripts\cp\cp_mi_cairo_infection_sgen_test_chamber;

#precache( "objective", "cp_level_infection_find_dr" );
#precache( "objective", "cp_level_infection_defeat_sarah" );
#precache( "objective", "cp_level_infection_interface_sarah" );
#precache( "objective", "cp_level_infection_access_sarah" );
#precache( "objective", "cp_level_infection_baby_tree" );
#precache( "string", "cp_ramses1_fs_connectioninterrupted" );
#precache( "string", "connectioninterrupted" );
#precache( "string", "cp_infection_fs_sgenserver1" );
#precache( "string", "cp_infection_fs_sgenserver2" );

#precache( "lui_menu", "CACWaitMenu" );

function main()
{
	savegame::set_mission_name("infection");
	
	skipto_setup();

	util::init_streamer_hints( 7 );

	callback::on_spawned( &on_player_spawned );
	
	sarah_battle::main();
	sim_reality_starts::main();
	sgen_test_chamber::main();
		
	cp_mi_cairo_infection_fx::main();
	cp_mi_cairo_infection_sound::main();

	skipto::set_skip_safehouse();
	
	load::main();

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass

	// Set up some generic War Flag Names.
	// Example from COD5: CALLSIGN_SEELOW_A is the name of the 1st flag in Selow whose string is "Cottage" 
	// The string must have MPUI_CALLSIGN_ and _A. Replace Mapname with the name of your map/bsp and in the 
	// actual string enter a keyword that names the location (Roundhouse, Missle Silo, Launchpad, Guard Tower, etc)

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
}

function on_player_spawned()
{
	// self = player
	
	a_skiptos = skipto::get_current_skiptos();
	
	if ( IsDefined( a_skiptos ) )
	{	
		switch( a_skiptos[0] )
		{
			case "sarah_battle":
				self util::set_lighting_state( 1 );
				break;
			case "sarah_battle_end":
				self util::set_lighting_state( 1 );
				break;							
			case "sim_reality_starts":
				self thread reset_snow_fx_respawn();	
				self infection_util::player_enter_cinematic();
				break;
			case "sgen_test_chamber":
			case "time_lapse":
			case "cyber_soliders_invest":
				self infection_util::player_enter_cinematic();
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
	skipto::add( "vtol_arrival", &sarah_battle::vtol_arrival_init, "VTOL ARRIVAL", &sarah_battle::vtol_arrival_done);
	skipto::add_billboard( "vtol_arrival", "VTOL ARRIVAL", "IGC 1st Shared", "Medium" );
		
	skipto::add( "sarah_battle", &sarah_battle::sarah_battle_init, "SARAH BATTLE", &sarah_battle::sarah_battle_done );
	skipto::add_billboard( "sarah_battle", "SARAH BATTLE", "Combat", "Medium" );
	
	skipto::add( "sarah_battle_end", &sarah_battle::sarah_battle_end_init, "SARAH BATTLE END", &sarah_battle::sarah_battle_end_done );
	skipto::add_billboard( "sarah_battle_end", "SARAH BATTLE END", "IGC 1st Shared", "Small" );

	skipto::add( "sim_reality_starts", &sim_reality_starts::sim_reality_starts_init, "BIRTH OF THE AI", &sim_reality_starts::sim_reality_starts_done );
	skipto::add_billboard( "sim_reality_starts", "BIRTH OF THE AI", "Navigation", "Small" );
	
	skipto::add( "sgen_test_chamber", &sgen_test_chamber::sgen_test_chamber_init, "SGEN - 2060", &sgen_test_chamber::sgen_test_chamber_done );
	skipto::add_billboard( "sgen_test_chamber", "SGEN - 2060", "IGC 1st Shared", "Small" );
	
	skipto::add( "time_lapse", &sgen_test_chamber::time_lapse_init, "SGEN - TIME LAPSE", &sgen_test_chamber::time_lapse_done );
	skipto::add_billboard( "time_lapse", "SGEN - TIME LAPSE", "IGC 1st Shared", "Small" );
	
	skipto::add( "cyber_soliders_invest", &sgen_test_chamber::cyber_soliders_invest_init, "SGEN - 2070", &sgen_test_chamber::cyber_soliders_invest_done );
	skipto::add_billboard( "cyber_soliders_invest", "SGEN - 2070", "IGC 1st Shared", "Small" );

	//skipto map infection 2
	skipto::add( "sgen_server_room", &skipto_infection_2 );
	skipto::add( "forest", &skipto_infection_2 );
	skipto::add( "forest_surreal", &skipto_infection_2 );
	skipto::add( "black_station", &skipto_infection_2 );
	skipto::add( "village",	&skipto_infection_2 );
	skipto::add( "village_inception",	&skipto_infection_2 );
	skipto::add( "cathedral",	&skipto_infection_2 );
	skipto::add( "underwater", &skipto_infection_2 );

	//skipto map infection 3
	skipto::add( "hideout", &skipto_infection_3 );
	skipto::add( "interrogation", &skipto_infection_3 );
	skipto::add( "city_barren", &skipto_infection_3 );
	skipto::add( "city", &skipto_infection_3 );
	skipto::add( "city_tree",	&skipto_infection_3 );
	skipto::add( "city_nuked",	&skipto_infection_3 );
	skipto::add( "outro", &skipto_infection_3 );
}

function skipto_infection_2( str_objective, b_starting )
{	
	SwitchMap_Load( "cp_mi_cairo_infection2" );
	
	wait 0.05;
	
	SwitchMap_Switch();
}

function skipto_infection_3( str_objective, b_starting )
{	
	SwitchMap_Load( "cp_mi_cairo_infection3" );
	
	wait 0.05;
	
	SwitchMap_Switch();
}
