main()
{
	maps\mp\mp_boneyard_precache::main();

	maps\mp\mp_boneyard_fx::main();
	maps\createart\mp_boneyard_art::main();
	maps\mp\mp_boneyard_precache::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap( "compass_map_mp_boneyard" );

	ambientPlay( "ambient_mp_desert" );

	game[ "attackers" ] = "axis";
	game[ "defenders" ] = "allies";
}
