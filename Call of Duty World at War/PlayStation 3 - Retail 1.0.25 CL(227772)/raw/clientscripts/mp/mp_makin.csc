// Test clientside script for mp_makin

#include clientscripts\mp\_utility;

main()
{
	// If the team nationalites change in this level's gsc file,
	// you must update the team nationality here!
	level.allies_team = "marines";
	level.axis_team   = "japanese";

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_makin_fx::main();

	setdvarbool( "r_watersim_enabled", 1 );

	thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_makin_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : mp_makin running...");
}
