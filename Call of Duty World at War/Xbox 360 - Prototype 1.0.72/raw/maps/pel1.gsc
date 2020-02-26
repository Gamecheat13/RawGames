#include maps\_utility;
main()
{
	// Start Function calls
	add_start( "coral", ::start_coral );
	add_start( "beach", ::start_beach );
	add_start( "mortarrun", ::start_mortar_run );
	add_start( "mortarpits", ::start_mortar_pits );
	default_start( ::event1_setup );
	
	// _load!
	maps\_load::main();
	
	// All the level support scripts.
	maps\pel1_amb::main();
	maps\pel1_anim::main();
	maps\pel1_fx::main();
	maps\pel1_status::main();
		
}

// Rolling up on shore
event1_setup()
{
	
}

//////////////////////////////////////////////////////////////////
///////////////////// START FUNCTIONS ////////////////////////////
//////////////////////////////////////////////////////////////////

start_coral()
{
}

start_beach()
{
	starts = getstructarray("beach_start_points","targetname");
	
	// grab all players
	players = get_players();

	// set up each player, make sure there are four points to start from
	for (i = 0; i < players.size; i++)
	{
		players[i] setOrigin( starts[i].origin );
		players[i] setPlayerAngles( starts[i].angles );
	}
}

start_mortar_run()
{
}

start_mortar_pits()
{
}
