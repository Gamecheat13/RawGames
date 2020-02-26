main()
{
	maps\mp\mp_subbase_precache::main();
	maps\createart\mp_subbase_art::main();
	maps\mp\mp_subbase_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_subbase" );

	ambientPlay( "ambient_mp_snow" );

	game[ "defenders"] = "axis";
	game[ "attackers"] = "allies";


	setdvar( "r_specularcolorscale", "2" );
	setdvar( "compassmaxrange", "1500" );
	//setsaveddvar( "r_lightGridEnableTweaks", 1 );
	//setsaveddvar( "r_lightGridIntensity", 1.34 );
	//setsaveddvar( "r_lightGridContrast", "0" );
}
