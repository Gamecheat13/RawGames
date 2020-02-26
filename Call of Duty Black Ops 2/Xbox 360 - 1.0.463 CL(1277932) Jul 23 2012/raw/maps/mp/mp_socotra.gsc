#include maps\mp\_utility;
main()
{
	level.levelSpawnDvars = ::levelSpawnDvars;
	
	//needs to be first for create fx
	maps\mp\mp_socotra_fx::main();

	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_socotra");

	maps\mp\mp_socotra_amb::main();


	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

	SetDvar( "sm_sunsamplesizenear", .39 );
	
	SetHeliHeightPatchEnabled( "war_mode_heli_height_lock", false );

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
}

levelSpawnDvars ( reset_dvars )
{
	ss = level.spawnsystem;
	ss.hq_objective_influencer_inner_radius = set_dvar_float_if_unset("scr_spawn_hq_objective_influencer_inner_radius", "1200", reset_dvars);
	ss.enemy_influencer_radius =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_radius", "2500", reset_dvars);	
}
