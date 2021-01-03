#using scripts\codescripts\struct;

#using scripts\cp\gametypes\_save;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                               	                                                          	              	                                                                                           

#using scripts\cp\_ammo_cache;
#using scripts\cp\_mobile_armory;

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_objectives;

#using scripts\cp\cp_mi_cairo_infection3_fx;
#using scripts\cp\cp_mi_cairo_infection3_sound;
#using scripts\cp\cp_mi_cairo_infection_util;

#using scripts\cp\cp_mi_cairo_infection_hideout_outro;
#using scripts\cp\cp_mi_cairo_infection_zombies;

#precache( "objective", "cp_level_infection_find_dr" );
#precache( "objective", "cp_level_infection_defeat_sarah" );
#precache( "objective", "cp_level_infection_interface_sarah" );
#precache( "objective", "cp_level_infection_access_sarah" );
#precache( "objective", "cp_level_infection_kill_sarah" );

#precache( "lui_menu", "CACWaitMenu" );

function main()
{
	savegame::set_mission_name("infection");

	util::init_streamer_hints( 7 );
	
	skipto_setup();
	
	callback::on_spawned( &on_player_spawned );
	
	infection_zombies::main();
	hideout_outro::main();
		
	cp_mi_cairo_infection3_fx::main();
	cp_mi_cairo_infection3_sound::main();

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
	
	self thread infection_util::zombie_behind_vox();
		
	a_skiptos = skipto::get_current_skiptos();
	
	if ( IsDefined( a_skiptos ) )
	{	
		switch( a_skiptos[0] )
		{
			default:
				break;
		}
	}
}

function skipto_setup()
{
	skipto::add( "hideout", &hideout_outro::hideout_main, "HIDEOUT", &hideout_outro::hideout_cleanup );
	skipto::add_billboard( "hideout", "HIDEOUT", "IGC - Free Movement", "Small" );

	skipto::add( "interrogation", &hideout_outro::interrogation_main, "INTERROGATION", &hideout_outro::interrogation_cleanup );
	skipto::add_billboard( "interrogation", "INTERROGATION", "IGC - Free Movement", "Small" );

	skipto::add( "city_barren", &hideout_outro::stalingrad_creation_main, "STALINGRAD CREATION", &hideout_outro::stalingrad_creation_cleanup );
	skipto::add_billboard( "city_barren", "STALINGRAD CREATION", "IGC - Free Movement", "Small" );

	skipto::add( "city", &hideout_outro::pavlovs_house_main, "ZOMBIES", &hideout_outro::pavlovs_house_cleanup );
	skipto::add_billboard( "city", "ZOMBIES", "Combat", "Medium" );

	skipto::add( "city_tree", &hideout_outro::pavlovs_house_end, "ZOMBIES_END", &hideout_outro::pavlovs_end_cleanup );

	skipto::add( "city_nuked", &hideout_outro::stalingrad_nuke_main, "NUKE", &hideout_outro::stalingrad_nuke_cleanup );
	skipto::add_billboard( "city_nuked", "NUKE", "IGC - Free Movement", "Small" );

	skipto::add( "outro", &hideout_outro::outro_main, "OUTRO", &hideout_outro::outro_cleanup );
	skipto::add_billboard( "outro", "KEBECHET OUTRO", "IGC - 1st Shared", "Small" );
}


