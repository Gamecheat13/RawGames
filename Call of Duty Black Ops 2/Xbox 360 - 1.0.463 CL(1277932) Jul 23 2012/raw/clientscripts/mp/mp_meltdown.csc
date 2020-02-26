// Test clientside script for mp_mountain

#include clientscripts\mp\_utility;

main()
{
	// If the team nationalites change in this level's gsc file,
	// you must update the team nationality here!
	clientscripts\mp\_teamset_seals::level_init();

	// _load!
	clientscripts\mp\_load::main();

	thread clientscripts\mp\mp_meltdown_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_meltdown_amb::main();

	// after _load::main
	
	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	/# println("*** Client : mp_meltdown running..."); #/
}
