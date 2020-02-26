// Test clientside script for mp_slums

#include clientscripts\mp\_utility;

main()
{
	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_slums_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_slums_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	/# println("*** Client : mp_slums running..."); #/
}
