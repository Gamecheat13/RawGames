// Test clientside script for oki3

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\oki3_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\oki3_amb::main();
	
	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : oki3 running...");
}
