#include maps\mp\_utility; 

precache_util_fx()
{
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{
	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
}

main()
{

	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	
	maps\mp\createfx\mp_nightclub_fx::main();
	// maps\mp\createart\mp_nightclub_art::main();

	wind_initial_setting();

}

wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-120 -115 -120" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}