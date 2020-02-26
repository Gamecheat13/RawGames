#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_vehicle;


#insert raw\maps\_so_rts.gsh;
#insert raw\maps\_scene.gsh;

//////////////////////////////////////////////////////////////////////////////////////////////////
main()
{
	//needs to be first for create fx
	maps\so_rts_afghanistan_fx::main();
	
	level.rts_def_table 	= "sp/so_rts/afghanistan_rts.csv";		
	level.compass_map_name = "compass_map_mp_turbine"; // mini map

	// level specific assets
	afghanistan_level_precache();

	maps\_so_rts_main::preload();
	maps\_load::main();
	
	maps\_compass::setupMiniMap( level.compass_map_name ); 

	// blackscreen on
	screen_fade_out( 0 );

	// reset objectives
	objective_clearall();

	maps\_so_rts_main::postload();

	// custom level setup and logic
	afghanistan_level_setup();

	level.era = "twentytwenty";	

	//go time
	maps\_so_rts_main::main();
}
//////////////////////////////////////////////////////////////////////////////////////////////////

afghanistan_setStart()
{
	/////////////////////////////////////////////////////////////
	// The MP map has the info_player_start clear on the other side of the map
	// i'd like to move it, but that's like pulling all your teeth out....
	// hack of sweetness
	ent = GetEnt("rts_player_start","targetname");
	assert(isDefined(ent),"Player starting location must be defined.");
	
	self.origin = ent.origin;
	self setplayerangles(ent.angles);
	
	/////////////////////////////////////////////////////////////
}
//////////////////////////////////////////////////////////////////////////////////////////////////

afghanistan_level_setup()
{
	level.onSpawnPlayer = ::afghanistan_setStart;
	switch( GetDvarInt( "map_scenario" ) )
	{
		case 0:
		case 1:
			level.custom_mission_complete = maps\so_rts_afghanistan_s1::afghanistan_mission_complete_s1;
			level thread maps\so_rts_afghanistan_s1::afghanistan_level_scenario_one();
			break;
		case 2:
			break;
		case 3:
			break;
		default:
			AssertMsg("Unhandled war scenario specified");
			break;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

afghanistan_level_precache()
{
	level.onSpawnPlayer = ::afghanistan_setStart;
	switch(GetDvarInt("map_scenario"))
	{
		case 0:
		case 1:
			level thread maps\so_rts_afghanistan_s1::precache();
			break;
		case 2:
			break;
		case 3:
			break;
		default:
			AssertMsg("Unhandled war scenario specified");
			break;
	}
}

