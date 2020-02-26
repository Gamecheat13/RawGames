// Test clientside script for module_covernodes

#include clientscripts\_utility;

main()
{
	level._uses_crossbow = true;

	// _load!
	clientscripts\_load::main();

	//clientscripts\module_covernodes_fx::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	//thread clientscripts\module_covernodes_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : module_covernodes running...");
}
