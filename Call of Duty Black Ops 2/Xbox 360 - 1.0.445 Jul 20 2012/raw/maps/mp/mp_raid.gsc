#include maps\mp\_utility;
main()
{
	level.levelSpawnDvars = ::levelSpawnDvars;
	
	//needs to be first for create fx
	maps\mp\mp_raid_fx::main();

	maps\mp\_load::main();

	maps\mp\mp_raid_amb::main();
	
  maps\mp\_compass::setupMiniMap("compass_map_mp_raid");
  
	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

	// enable new spawning system
	//Setting enemy radius to 2600 from 1620 3.3.12 MS
	// Updating to new dvar handling.  Set enemy influencer to 1870. 7.17.12
	
}

levelSpawnDvars ( reset_dvars )
{
	ss = level.spawnsystem;
	ss.enemy_influencer_radius =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_radius", "1870", reset_dvars);	
}
