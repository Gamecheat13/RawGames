main()
{
	maps\mp\mp_derail_precache::main();
	maps\mp\mp_derail_fx::main();
	maps\createart\mp_derail_art::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_derail" );

	ambientPlay( "ambient_mp_snow" );

	game[ "attackers" ] = "axis";
	game[ "defenders" ] = "allies";

	setdvar( "r_specularcolorscale", "1" );
	setdvar( "compassmaxrange", "1500" );
}
