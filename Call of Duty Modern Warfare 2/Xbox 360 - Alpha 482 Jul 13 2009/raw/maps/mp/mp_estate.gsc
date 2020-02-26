main()
{

	maps\mp\mp_estate_precache::main();
	maps\createart\mp_estate_art::main();
	maps\mp\mp_estate_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_estate" );

	ambientPlay( "ambient_mp_estate" );

	game[ "attackers" ] = "allies";
	game[ "defenders" ] = "axis";

	setdvar( "r_specularcolorscale", "1.9" );
	setdvar( "compassmaxrange", "1500" );
}