main()
{
	maps\mp\mp_alpha_precache::main();
	maps\createart\mp_alpha_art::main();
	maps\mp\mp_alpha_fx::main();
	
	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_alpha" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_alpha" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "city", 0.15, 0.9, 2 );
}