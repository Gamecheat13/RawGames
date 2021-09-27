
main()
{
	maps\mp\mp_interchange_precache::main();
	maps\createart\mp_interchange_art::main();
	maps\mp\mp_interchange_fx::main();
	maps\mp\_explosive_barrels::main();	
	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_interchange" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_interchange" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "parkinglot", 0.2, 0.9, 2 );
}