
main()
{
	maps\mp\mp_bravo_precache::main();
	maps\createart\mp_bravo_art::main();
	maps\mp\mp_bravo_fx::main();
	
	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_bravo" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_bravo" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "mountains", 0.2, 0.9, 2 );
}