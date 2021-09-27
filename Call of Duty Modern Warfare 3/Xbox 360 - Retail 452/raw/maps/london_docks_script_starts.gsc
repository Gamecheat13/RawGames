#include maps\_utility;

main()
{
    describe_start( "start_of_level",		maps\london_docks::start_alley,					"Start of Level",			maps\london_docks::intro );
    describe_start( "post_intro",			maps\london_docks::start_alley,					"Post Intro",				maps\london_docks::alley_movement );
    describe_start( "2nd_alley",			maps\london_docks::start_alley_2nd_squad,		"2nd Alley",				maps\london_docks::alley_movement );
    describe_start( "warehouse_breach",		maps\london_docks::start_warehouse_breach,		"Warehouse Breach",			maps\london_docks::alley_movement );
    describe_start( "warehouse_hallway",	maps\london_docks::start_warehouse_hallway,		"Warehouse Hallway",		maps\london_docks::alley_movement );
    describe_start( "docks_assault",     	maps\london_docks::start_docks_assault,			"Docks Assault",			maps\london_docks::alley_movement );
    describe_start( "docks_assault_ambush",	maps\london_docks::start_docks_ambush,			"Docks Assault - ambush",	maps\london_docks::docks_assault );
    describe_start( "docks_assault_streets",maps\london_docks::start_docks_streets,			"Docks Assault - streets",	maps\london_docks::docks_streets );
}