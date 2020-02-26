#include maps\mp\_utility;
main()
{
	//needs to be first for create fx
	maps\mp\mp_hijacked_fx::main();

  maps\mp\_load::main();

	maps\mp\mp_hijacked_amb::main();

//compass map function, uncomment when adding the minimap
maps\mp\_compass::setupMiniMap("compass_map_mp_hijacked");

	// Set up the default range of the compass
	setdvar("compassmaxrange","2100");

	// enable new spawning system
	//Changed from 2600 to 2100 for initial setup 3.28.12 MS
	//Changed from 2100 to 1900 to control spawn swapping a bit more 4.3.12
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	SetDvar( "scr_spawn_enemy_influencer_radius", 1900 );

}
