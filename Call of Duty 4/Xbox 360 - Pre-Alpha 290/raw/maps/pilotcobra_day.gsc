#include maps\_utility;
main()
{
	precacheStuff();
	precacheModel( "cobra_interior_viewmodel" );
	
	setdvar( "scr_dof_enable", "0" );
	
	maps\_load::main();
	maps\_cobrapilot::init();
	maps\_compass::setupMiniMap( "compass_map_pilotcobra" );
	level thread maps\pilotcobra_amb::main();
	
	flag_clear( "nightvision_enabled" );
	
	setdvar( "scr_fog_type", "0" );
	setdvar( "scr_fog_density", ".00005" );
	setdvar( "scr_fog_nearplane", "0" );
	setdvar( "scr_fog_farplane", "5000" );
	setdvar( "scr_fog_red", "0.756" );
	setdvar( "scr_fog_green", "0.702" );
	setdvar( "scr_fog_blue", "0.5" );
	setdvar( "scr_fog_density", ".000019" );
	
	setExpFog( 0, 36000, 0.756, 0.702, 0.5, 0 );
	
	vehicleDeathFXOverrides();
	
	difficultyMenu();
	thread autosave_by_name( "cobrapilot_day_mission_started" );
	
	thread objectives();
	
	wait 0.1;
	setsaveddvar( "compassMaxRange", "30000" );
	
	level.playervehicle setModel( "cobra_interior_viewmodel" );
}

difficultyMenu()
{
	level.player freezeControls( true );
	level.player openMenu( "cobra_controls" );
	for (;;)
	{
		level.player waittill( "menuresponse", menu, difficulty );
		if ( !isdefined( menu ) )
			continue;
		if ( menu != "cobra_difficulty" )
			continue;
		if ( getdvar( "cobrapilot_debug") == "1" )
			iprintlnbold( "Difficulty: " + difficulty );
		setdvar( "cobrapilot_difficulty", difficulty );
		level.cobrapilot_difficulty = difficulty;
		break;
	}
	level.player freezeControls( false );
}

precacheStuff()
{
	precacheString( &"COBRAPILOT_OBJECTIVE_DESTROY_TARGETS" );
	
	precacheMenu( "cobra_controls" );
	precacheMenu( "cobra_difficulty" );
	precacheMenu( "cobra_stats" );
	
	maps\_bmp::main("vehicle_bmp");	
	maps\_t72::main("vehicle_t72_tank");
	maps\_technical::main("vehicle_pickup_technical");
	maps\_hind::main("vehicle_mi24p_hind_desert");
	maps\_slamraam::main( "vehicle_slamraam" );
	maps\_sa6::main("vehicle_sa6_no_missiles_desert");
	maps\_cobra::main( "vehicle_cobra_helicopter_fly" );
	maps\_cobra_player::main("vehicle_cobra_helicopter_fly");
}

vehicleDeathFXOverrides()
{
	maps\_vehicle::build_deathfx( "bmp", loadfx( "explosions/cobrapilot_vehicle_explosion" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx( "t72", loadfx( "explosions/cobrapilot_vehicle_explosion" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx( "technical", loadfx( "explosions/cobrapilot_vehicle_explosion" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx( "hind", loadfx( "explosions/cobrapilot_vehicle_explosion" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx( "slamraam", loadfx( "explosions/cobrapilot_vehicle_explosion" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx( "sa6", loadfx( "explosions/cobrapilot_vehicle_explosion" ), "tag_origin", "explo_metal_rand" );
}

objectives()
{
	assert( isdefined( level.cobraTarget ) );
	assert( level.cobraTarget.size > 0 );
	
	level.startTime = getTime();
	
	objective_add( 0, "current", &"COBRAPILOT_OBJECTIVE_DESTROY_TARGETS", ( 0, 0, 0 ) );
	objective_string_nomessage( 0, &"COBRAPILOT_OBJECTIVE_DESTROY_TARGETS", level.cobraTarget.size );
	
	while( level.cobraTarget.size > 0 )
	{
		level waittill ( "targets_updated" );
		objective_string( 0, &"COBRAPILOT_OBJECTIVE_DESTROY_TARGETS", level.cobraTarget.size );
	}
	
	objective_state( 0, "done" );
	/*
	level.endTime = getTime();
	minutes = 0;
	seconds = 0;
	timeDifference = ( level.endTime - level.startTime ) / 1000;
	if ( timeDifference < 1 )
		timeDifference = 1;
	
	while( timeDifference > 0 )
	{
		seconds++;
		timeDifference = timeDifference - 1;
	}
	
	while( seconds >= 60 )
	{
		minutes++;
		seconds--;
	}
	
	setdvar( "stat_completion_time", minutes + " minutes, " + seconds + " seconds" );
	setdvar( "stat_enemies_killed", level.stats["enemies_killed"] );
	setdvar( "stat_damage_taken", level.stats["damage_taken"] );
	setdvar( "stat_cobra_20mm", level.stats["cobra_20mm"] );
	setdvar( "stat_cobra_FFAR", level.stats["cobra_FFAR"] );
	setdvar( "stat_cobra_Hellfire", level.stats["cobra_Hellfire"] );
	setdvar( "stat_cobra_Sidewinder", level.stats["cobra_Sidewinder"] );
	setdvar( "stats_flares_used", level.stats["flares_used"] );
	
	level.player openMenu( "cobra_stats" );
	*/
}