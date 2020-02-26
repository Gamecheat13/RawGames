// Test clientside script for mp_seelow

#include clientscripts\mp\_utility;

main()
{
	// If the team nationalites change in this level's gsc file,
	// you must update the team nationality here!
	level.allies_team = "russian";
	level.axis_team   = "german";
		
	clientscripts\mp\_panzeriv::main( "vehicle_ger_tracked_panzer4_mp" );
	clientscripts\mp\_t34::main( "vehicle_rus_tracked_t34_mp" );

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_seelow_fx::main();

	thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_seelow_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : mp_seelow running...");

}
