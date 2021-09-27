
main()
{
	maps\mp\mp_bootleg_precache::main();
	maps\createart\mp_bootleg_art::main();
	maps\mp\mp_bootleg_fx::main();
	
	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_bootleg" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_bootleg" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	setdvar( "sm_sunShadowScale", "0.7" ); // optimization
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "city", 0.25, 0.9, 2 );
}