#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.so_compass_zoom = "far";
	
	// settings for this challenge
	setdvar( "pmc_gametype", "mode_objective" );
	setdvar( "pmc_enemies", "50" );
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_breach_ents();
	
	maps\boneyard_precache::main();
	maps\createart\boneyard_fog::main();
	maps\createfx\boneyard_audio::main();
	maps\boneyard_fx::main();
	
	maps\_pmc::preLoad();
	maps\_load::main();
	maps\_pmc::main();

	maps\_compass::setupMiniMap( "compass_map_boneyard" );

	music_loop( "boneyard_flyby", 183 );
}