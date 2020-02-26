// Test clientside script for afghanistan

#include clientscripts\_utility;

main()
{
	// _load!
	clientscripts\afghanistan_fx::main();
	clientscripts\_load::main();
	clientscripts\_horse_ride::init();

	

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\afghanistan_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : afghanistan running...");
}
