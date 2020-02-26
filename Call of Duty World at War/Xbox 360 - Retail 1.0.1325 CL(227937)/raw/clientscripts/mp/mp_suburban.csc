// Test clientside script for mp_suburban

#include clientscripts\mp\_utility;

main()
{
	// If the team nationalites change in this level's gsc file,
	// you must update the team nationality here!
	level.allies_team = "russian";
	level.axis_team   = "german";

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_suburban_fx::main();

	thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_suburban_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : mp_suburban running...");

}
