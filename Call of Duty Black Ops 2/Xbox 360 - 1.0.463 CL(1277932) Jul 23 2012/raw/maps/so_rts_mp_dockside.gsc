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
	maps\so_rts_mp_dockside_fx::main();
	
	level.rts_def_table 	= "sp/so_rts/mp_dockside_rts.csv";		
	level.compass_map_name = "compass_map_mp_dockside_rts";// mini map
	// level specific assets
	dockside_level_precache();

	maps\_so_rts_main::preload();
	maps\_load::main();
	
	maps\_compass::setupMiniMap(level.compass_map_name); 

	// blackscreen on
	screen_fade_out( 0 );

	// reset objectives
	objective_clearall();

	maps\_so_rts_main::postload();


	maps\voice\voice_singapore::init_voice();

	// custom level setup and logic
	dockside_level_setup();

	level.era = "twentytwenty";	

	//go time
	maps\_so_rts_main::main();
}
//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_setStart()
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
dockside_level_setup()
{
	level.onSpawnPlayer = ::dockside_setStart;
	switch(GetDvarInt("map_scenario"))
	{
		case 0:
		case 1:
			level.custom_mission_complete = maps\so_rts_mp_dockside_s1::dockside_mission_complete_s1;
			level thread maps\so_rts_mp_dockside_s1::dockside_level_scenario_one();
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
dockside_level_precache()
{
    SetHeliHeightPatchEnabled( "mp_mode_heli_height_lock", false );

	level.onSpawnPlayer = ::dockside_setStart;
	switch(GetDvarInt("map_scenario"))
	{
		case 0:
		case 1:
			level thread maps\so_rts_mp_dockside_s1::precache();
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

