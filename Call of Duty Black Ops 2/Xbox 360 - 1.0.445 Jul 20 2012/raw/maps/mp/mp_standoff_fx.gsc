#include maps\mp\_utility;

main()
{
	precache_fxanim_props();
	precache_scripted_fx();
	precache_createfx_fx();
		
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\mp\createfx\mp_standoff_fx::main();
	
	//maps\mp\createart\mp_standoff_art::main();
		
	//Commenting out due to breaking game PTASKER 9/23/11
	//wind_initial_setting();
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

/*  Commenting out due to breaking game PTASKER 9/23/11
wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-120 -115 -120" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}
*/

// FXanim Props
#using_animtree ( "fxanim_props" );
precache_fxanim_props()
{
	level.scr_anim = [];
	level.scr_anim[ "fxanim_props" ] = [];
}