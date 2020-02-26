#include common_scripts\utility;
#include maps\_utility;

//////////////////////////////////////////////////////////////////////////////////////////////////
main()
{
	//war mode overrides
	level.wave_table 				= "sp/so_war/dockside_waves.csv";		// enables wave definition override
	level.loadout_table 			= "sp/so_war/dockside_waves.csv";		// enables player load out override
	level.scenario_table 			= "sp/so_war/dockside_scenario.csv";	// wave defines
	level.compass_map_name 			= "compass_map_so_war_mp_dockside";		// for killstreaks /etc

	//war mode precache
	maps\_so_war::war_preload();

	//standard level load and setup
	maps\_load::main();

	// war mode post load
	maps\_so_war::war_postload();

	// custom level setup and logic
	dockside_level_setup();

	//main war init
	maps\_so_war::war_init(getDvarInt("war_scenario"));
}
//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_level_setup()
{
	switch(GetDvarInt("war_scenario"))
	{
		case 0:
		case 1:
			level thread dockside_level_scenario_one();
			break;
		case 2:
			level thread dockside_level_scenario_two();
			break;
		case 3:
			level thread dockside_level_scenario_three();
			break;
		default:
			AssertMsg("Unhandled war scenario specified");
			break;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_level_scenario_one()
{
	precacheModel("mil_wireless_dsm");
	precacheModel("mil_wireless_dsm_obj");
	
	level.custom_war_player_insert 		= maps\so_war_mp_dockside_war_s1::dockside_scenario_one_intro;
	level.custom_war_mission_complete	= maps\so_war_mp_dockside_war_s1::dockside_scenario_one_end;
	maps\so_war_mp_dockside_war_s1::main();
}
//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_level_scenario_two()
{
	//intialize whatever
	//:
	//:
	level.custom_war_player_insert 	= ::dockside_custom_playerSpawn;		// custom player insert callback override
	flag_wait("intro_complete");
	
	flag_set("start_war");
	
	//do whatever
	//:
	//: etc
}
//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_level_scenario_three()
{
	//intialize whatever
	//:
	//:
	level.custom_war_player_insert 	= ::dockside_custom_playerSpawn;		// custom player insert callback override
	
	flag_wait("intro_complete");
	
	flag_set("start_war");
	
	//do whatever
	//:
	//: etc
}
//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_custom_playerSpawn()
{
	//custom player intro/spawn

	//:

	//:
	
	
	//flag_set("start_war");  //uncomment this when intro is complete or WHEN you want the war scripts to start generating AI and game modes.
	
	//nothing defined yet, so just use the standard.. comment this out when you do something above.
	level thread maps\_so_war_support::war_zodiac_player_insert();
	level waittill("zodiac_player_insert_done");
	flag_set("intro_complete");
}

