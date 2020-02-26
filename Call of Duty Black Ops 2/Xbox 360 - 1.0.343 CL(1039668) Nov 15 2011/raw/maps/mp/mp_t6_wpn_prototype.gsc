#include maps\mp\_utility;
#include common_scripts\utility; 

main()
{
	level.forceAirsupportMapHeight = 130;
	level.airsupportHeightScale = 8;

	//needs to be first for create fx
	maps\mp\mp_t6_wpn_prototype_fx::main();

	maps\mp\_load::main();
	
	//maps\mp\_compass::setupMiniMap("compass_map_mp_firingrange");

	maps\mp\mp_t6_wpn_prototype_amb::main();

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	maps\mp\gametypes\_teamset_junglemarines::level_init();


	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
}
