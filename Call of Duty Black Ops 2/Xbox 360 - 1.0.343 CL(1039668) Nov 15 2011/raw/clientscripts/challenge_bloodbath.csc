// Test clientside script for adam_test

#include clientscripts\_utility;

main()
{
	level._uses_crossbow = true;

	// _load!
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : challenge_bloodbath running...");
}
