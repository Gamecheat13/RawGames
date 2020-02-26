// clientside script for mp_drum

#include clientscripts\mp\_utility;

main()
{

	// _load!
	clientscripts\mp\_load::main();
	clientscripts\mp\mp_drum_fx::main();
	thread clientscripts\mp\_fx::fx_init(0);

	thread clientscripts\mp\_audio::audio_init(0);
	thread clientscripts\mp\mp_drum_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : mp_drum running...");
}
