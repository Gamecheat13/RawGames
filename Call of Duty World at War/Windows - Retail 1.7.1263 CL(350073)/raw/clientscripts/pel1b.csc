// Test clientside script for pel1b

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\_artillery::main( "artillery_jap_47mm", "at47" );
	
	// sherman tread effects
	clientscripts\_sherman::main( "vehicle_usa_tracked_shermanm4a3_camo");
	clientscripts\_sherman::main( "vehicle_usa_tracked_shermanm4a3_camo","sherman_flame" );

	clientscripts\pel1b_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);
	thread clientscripts\pel1b_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : pel1b running...");
}
