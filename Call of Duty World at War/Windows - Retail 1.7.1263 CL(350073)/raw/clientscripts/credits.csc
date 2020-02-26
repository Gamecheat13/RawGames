// Test clientside script for credits

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\credits_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);
	
	println("*** Client : credits running...");
}
