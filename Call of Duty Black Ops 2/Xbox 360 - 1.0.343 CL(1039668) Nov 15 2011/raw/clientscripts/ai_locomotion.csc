// Test clientside script for ai_locomotion

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);
	
	thread clientscripts\_audio::audio_init(0);

	println("*** Client : ai_locomotion running...");
}
