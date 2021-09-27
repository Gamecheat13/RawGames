#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	maps\mp\mp_dome_precache::main();
	maps\createart\mp_dome_art::main();
	maps\mp\mp_dome_fx::main();
	maps\mp\_explosive_barrels::main();	

	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_dome" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_dome" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "quarry", 0.15, 0.9, 2 );
}