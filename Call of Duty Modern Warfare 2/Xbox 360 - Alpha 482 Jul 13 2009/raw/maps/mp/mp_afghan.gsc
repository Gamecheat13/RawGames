#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	maps\mp\mp_afghan_precache::main();
	maps\createart\mp_afghan_art::main();
	maps\mp\mp_afghan_fx::main();
	maps\mp\_explosive_barrels::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_afghan" );

	ambientPlay( "ambient_mp_desert" );

	game[ "attackers" ] = "allies";
	game[ "defenders" ] = "axis";	
}