// Test clientside script for oki2

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\_artillery::main( "artillery_jap_47mm", "at47" );
	clientscripts\_sherman::main( "vehicle_usa_tracked_shermanm4a3_camo" );

	level.earthquake["bunker"]["magnitude"] = 0.185;
	level.earthquake["bunker"]["duration"] = 3;
	level.earthquake["bunker"]["radius"]= 2048;

	clientscripts\oki2_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\oki2_amb::main();

	clientscripts\_vehicle::build_treadfx( "corsair" );	// set up corsair for dust fx.

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : oki2 running...");
}
