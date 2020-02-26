#include maps\mp\_utility;
main()
{
	//needs to be first for create fx
	maps\mp\mp_meltdown_fx::main();

	maps\mp\_load::main();

	maps\mp\mp_meltdown_amb::main();

  maps\mp\_compass::setupMiniMap("compass_map_mp_meltdown");
	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

	// enable new spawning system
	// Reduced enemy influencer to 2400 to reduce frequent swapping
	// Reduced enemy influencer to 2000 to reduce spawn swapping 6.14.12
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	SetDvar( "scr_spawn_enemy_influencer_radius", 2000 );

	//maps\mp\mp_meltdown_lift::init();
}