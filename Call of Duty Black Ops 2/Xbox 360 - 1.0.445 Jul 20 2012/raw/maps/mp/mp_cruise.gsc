#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	//needs to be first for create fx
	maps\mp\mp_cruise_fx::main();

	maps\mp\teams\_teamset_junglemarines::register();
	maps\mp\_load::main();

	maps\mp\mp_cruise_amb::main();

	// If the team nationalites change in this file, you must also update the level's csc file,
	// the level's csv file, and the share/raw/mp/mapsTable.csv
	maps\mp\teams\_teamset_junglemarines::level_init();
  maps\mp\_compass::setupMiniMap("compass_map_mp_cruise");

	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

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

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	SetDvar( "scr_spawn_enemy_influencer_radius", 2600 );

	//Runs trams
	//level thread moving_tram_init();
}

moving_tram_init()
{
	tram_a = GetEnt( "tram_a", "targetname" );
	tram_b = GetEnt( "tram_b", "targetname" );
	
	tram_a thread moving_tram_think();
	tram_b thread moving_tram_think();

}

//Self is tram script brush model 
moving_tram_think()
{
	self SetMovingPlatformEnabled();
	
	tram_node = getstruct( self.targetname + "_start", "targetname" );
	tram_node_array = [];
	tram_at_start = false;
	tram_wait = 4;

	while ( 1 )
	{
		tram_node_array = add_to_array( tram_node_array, tram_node );

		if( !IsDefined( tram_node.target ) )
		{
			break;
		}

		tram_node = getstruct( tram_node.target, "targetname" );
	}

	reverse_tram_node_array = array_reverse( tram_node_array );

	while( 1 )
	{
		if ( tram_at_start )
		{
			for ( i = 0; i < tram_node_array.size; i++ )
			{
				self MoveTo( tram_node_array[i].origin, 2 );
				self RotateTo( tram_node_array[i].angles, 2 );
				self waittill ( "movedone" );
			}

			wait tram_wait;
			tram_at_start = false;
		}
		else
		{
			for ( i = 0; i < reverse_tram_node_array.size; i++ )
			{
				self MoveTo( reverse_tram_node_array[i].origin, 2 );
				self RotateTo( reverse_tram_node_array[i].angles, 2 );
				self waittill ( "movedone" );
			}

			wait tram_wait;
			tram_at_start = true;
		}
	}
}
