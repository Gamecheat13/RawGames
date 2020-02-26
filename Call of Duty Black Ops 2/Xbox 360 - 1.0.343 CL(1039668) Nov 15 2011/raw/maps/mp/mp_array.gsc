#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	//needs to be first for create fx
	maps\mp\mp_array_fx::main();

	maps\mp\teams\_teamset_seals::register();
	maps\mp\_load::main();
	if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) )
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_array_wager");
	}
	else
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_array");
	}
	
	maps\mp\mp_array_amb::main();

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
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
	
	radar_move_init();
}

radar_move_init()
{
	level endon ("game_ended");
		
	dish_top = GetEnt( "dish_top", "targetname" );  
	dish_base = GetEnt( "dish_base", "targetname" ); 
	dish_inside = GetEnt( "dish_inside", "targetname" );
	dish_gears = GetEntArray( "dish_gear", "targetname");

	total_time_for_rotation_outside = 240;
	total_time_for_rotation_inside = 60;

	dish_top LinkTo(dish_base);
	dish_base thread rotate_dish_top(total_time_for_rotation_outside);
	dish_inside thread rotate_dish_top(total_time_for_rotation_inside);
	
	if(dish_gears.size > 0)
	{
		array_thread(dish_gears, ::rotate_dish_gears, total_time_for_rotation_inside);
	}
}

rotate_dish_top( time )
{
	self endon ("game_ended");

	while(1)
	{
		self RotateYaw( 360, time );
		self waittill( "rotatedone" );
	}
}

rotate_dish_gears( time )
{
	self endon ("game_ended");

	gear_ratio = 5.0 / 60.0;
	inverse_gear_ratio = 1.0 / gear_ratio;
	
	while(1)
	{
		self RotateYaw( 360 * inverse_gear_ratio, time );
		self waittill( "rotatedone" );
	}
}

addNoTurretTrigger( position, radius, height )
{
    while( !IsDefined( level.noTurretPlacementTriggers ) )
		wait( 0.1 );
                    
    trigger = Spawn( "trigger_radius", position, 0, radius, height );
    
    level.noTurretPlacementTriggers[level.noTurretPlacementTriggers.size] = trigger;
}

