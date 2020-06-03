// Test clientside script for ber2

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\ber2_fx::main();
	
	clientscripts\_t34::main( "vehicle_rus_tracked_t34", "t34_wet" );

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\ber2_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : ber2 running...");
}
