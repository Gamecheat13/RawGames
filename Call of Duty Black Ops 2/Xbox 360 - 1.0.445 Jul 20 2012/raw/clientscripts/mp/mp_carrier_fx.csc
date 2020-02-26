
#include clientscripts\mp\_utility; 


precache_util_fx()
{	
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{
	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	
	level._effect["fx_mp_smk_plume_lg_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk");
	level._effect["fx_mp_smk_plume_lg_blk_carrier"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk_carrier");	
	level._effect["fx_mp_carrier_vista_wake01"]						    = loadfx("maps/mp_maps/fx_mp_carrier_vista_wake01");
	level._effect["fx_mp_carrier_vista_wake_med"]						    = loadfx("maps/mp_maps/fx_mp_carrier_vista_wake_med");	
}

main()
{
	clientscripts\mp\createfx\mp_carrier_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();

	wind_initial_setting();

	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

wind_initial_setting()
{
SetSavedDvar( "enable_global_wind", 1); // enable wind for your level
SetSavedDvar( "wind_global_vector", "-120 -115 -120" );    // change "0 0 0" to your wind vector
SetSavedDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetSavedDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetSavedDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}