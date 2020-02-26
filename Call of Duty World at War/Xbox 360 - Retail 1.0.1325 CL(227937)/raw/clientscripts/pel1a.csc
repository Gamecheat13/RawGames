// Test clientside script for pel1a

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\pel1a_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\pel1a_amb::main();

	clientscripts\_vehicle::build_treadfx( "corsair" ); // set up corsair for dust fx.

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : pel1a running...");
}
