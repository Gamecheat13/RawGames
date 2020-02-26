// Test clientside script for mak

#include clientscripts\_utility;

main()
{
	// _load!
	clientscripts\_load::main();

	clientscripts\mak_fx::main();

	clientscripts\_treadfx::main( "rubber_raft" );
	clientscripts\_treadfx::main( "type94" );

	level.vehicle_treads["rubber_raft"] = true;

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\mak_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : mak running...");
}
