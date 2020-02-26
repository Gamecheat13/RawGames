// Test clientside script for mp_wrecks_test

#include clientscripts\mp\_utility;

main()
{

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\_teamset_junglemarines::level_init();		

	clientscripts\mp\mp_t6_wpn_prototype_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_t6_wpn_prototype_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : mp_t6_wpn_prototype running...");
}
