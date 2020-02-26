// Test clientside script for mp_t6_weapontest

#include clientscripts\mp\_utility;

main()
{
	clientscripts\mp\_teamset_junglemarines::level_init();
	clientscripts\mp\_teamset_urbanspecops::level_init();
	clientscripts\mp\_teamset_winterspecops::level_init();
	clientscripts\mp\_teamset_cubans::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_t6_weapontest_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_t6_weapontest_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : mp_t6_weapontest running...");
}
