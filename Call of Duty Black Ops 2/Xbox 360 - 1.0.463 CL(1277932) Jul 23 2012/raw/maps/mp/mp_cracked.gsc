#include maps\mp\_utility;
main()
{
	//PrecacheModel( "t5_veh_helo_huey_lowres" );

	//needs to be first for create fx
	maps\mp\mp_cracked_fx::main();

	if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) )
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_cracked_wager");
	}
	else
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_cracked");
	}

	maps\mp\_load::main();

	maps\mp\mp_cracked_amb::main();




	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
}