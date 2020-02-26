#include maps\mp\_utility;
main()
{
	//needs to be first for create fx
	maps\mp\mp_dockside_fx::main();

	maps\mp\teams\_teamset_seals::register();
	maps\mp\_load::main();

	maps\mp\mp_dockside_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_dockside");

	// If the team nationalites change in this file, you must also update the level's csc file,
	// the level's csv file, and the share/raw/mp/mapsTable.csv
	maps\mp\teams\_teamset_seals::level_init();

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
	
	level thread carousel_init();
}

carousel_init()
{
	carousel_crates = [];

	level.carousel_floor = GetEnt( "carousel_floor", "targetname" );
	level.carousel_floor SetMovingPlatformEnabled();

	carousel_crates[0] = GetEnt( "crate1", "targetname" );
	carousel_crates[0].script_org = spawn( "script_origin", carousel_crates[0].origin );
	carousel_crates[0].script_org.angles = carousel_crates[0].angles;
	carousel_crates[1] = GetEnt( "crate2", "targetname" );
	carousel_crates[1].script_org = spawn( "script_origin", carousel_crates[1].origin );
	carousel_crates[1].script_org.angles = carousel_crates[1].angles;
	carousel_crates[2] = GetEnt( "crate3", "targetname" );
	carousel_crates[2].script_org = spawn( "script_origin", carousel_crates[2].origin );
	carousel_crates[2].script_org.angles = carousel_crates[2].angles;

	crate_num = 0;

	foreach( crate in carousel_crates )
	{	
		crate LinkTo( level.carousel_floor );
		crate.script_org LinkTo( level.carousel_floor );
	}

	wait 30;

	while( 1 )
	{
		current_crate = carousel_crates[crate_num];

		current_crate Unlink();
		current_crate MoveZ( 600, 5 );
		current_crate waittill ( "movedone" );

		level.carousel_floor RotateYaw( 120, 15 );
		level.carousel_floor waittill ( "rotatedone" );

		current_crate Unlink();
		current_crate Hide();

		wait 5;

		current_crate.origin = ( current_crate.script_org.origin[0], current_crate.script_org.origin[1], current_crate.script_org.origin[2] - 300 );
		current_crate.angles = current_crate.script_org.angles;
		current_crate Show();
		current_crate MoveZ( 300, 5 );
		current_crate waittill ( "movedone" );
		current_crate LinkTo( level.carousel_floor );

		wait 30;

		if( crate_num < ( carousel_crates.size - 1 ) )
		{
			crate_num ++;
		}
		else
		{
			crate_num = 0; 
		}	
	}
}
