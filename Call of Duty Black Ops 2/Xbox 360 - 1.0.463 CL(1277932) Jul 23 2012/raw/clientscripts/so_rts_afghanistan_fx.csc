//
// file: so_rts_afghanistan_fx.gsc
// description: clientside fx script for afghanistan: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
}


// --- FX'S SECTION ---//
precache_createfx_fx()
{	
}


main()
{
	clientscripts\createfx\so_rts_afghanistan_fx::main();
	clientscripts\_fx::reportNumEffects();
	
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

