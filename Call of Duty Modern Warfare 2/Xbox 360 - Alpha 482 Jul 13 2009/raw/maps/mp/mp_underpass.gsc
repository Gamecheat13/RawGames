main()
{
	maps\mp\mp_underpass_precache::main();
	maps\createart\mp_underpass_art::main();
	maps\mp\mp_underpass_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_underpass" );

	//setExpFog( 500, 3500, .5, 0.5, 0.45, 1, 0 );
	ambientPlay( "ambient_mp_rain" );

	game[ "attackers" ] = "axis";
	game[ "defenders" ] = "allies";
	
	setdvar( "r_specularcolorscale", "3.4" );
}
