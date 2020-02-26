#include maps\mp\_utility;

main()
{
	precache_fxanim_props();
	precache_scripted_fx();
	precache_createfx_fx();
//	wind_init();
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\mp\createfx\mp_raid_fx::main();
	
	//maps\mp\createart\mp_raid_fx::main();
}

// Scripted effects
precache_scripted_fx()
{
	
}

// Ambient effects
precache_createfx_fx()
{
	//level._effect["effect_alias"]	= loadFX("path/to/effect");
}

//wind_init()
//{
//	SetSavedDvar( "wind_global_vector", "1 0 0" );						// change "1 0 0" to your wind vector
//	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
//	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
//	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage
//}


// FXanim Props
precache_fxanim_props()
{
	
}