// Test clientside script for angola_2

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\angola_2_fx::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\angola_2_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : angola_2 running...");
}
