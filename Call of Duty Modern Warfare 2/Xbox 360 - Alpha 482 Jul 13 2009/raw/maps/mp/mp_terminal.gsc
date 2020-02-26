
main()
{
	maps\mp\mp_terminal_precache::main();
	maps\createart\mp_terminal_art::main();
	maps\mp\mp_terminal_fx::main();
	maps\mp\_explosive_barrels::main();
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap( "compass_map_mp_terminal" );
	
	ambientPlay( "ambient_mp_airport" );
	
	VisionSetNaked( "mp_terminal" );
	
	//setsaveddvar( "r_lightGridEnableTweaks", 1 );
	//setsaveddvar( "r_lightGridIntensity", 0 );
	//setsaveddvar( "r_lightGridContrast", 0 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";
}