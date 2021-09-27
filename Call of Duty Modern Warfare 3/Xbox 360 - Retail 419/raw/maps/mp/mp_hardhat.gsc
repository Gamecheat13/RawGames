
main()
{
	maps\mp\mp_hardhat_precache::main();
	maps\createart\mp_hardhat_art::main();
	maps\mp\mp_hardhat_fx::main();
	maps\mp\_explosive_barrels::main();
	
	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_hardhat" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_hardhat" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "axis";
	game["defenders"] = "allies";

	audio_settings();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "quarry", 0.15, 0.9, 2 );
}

