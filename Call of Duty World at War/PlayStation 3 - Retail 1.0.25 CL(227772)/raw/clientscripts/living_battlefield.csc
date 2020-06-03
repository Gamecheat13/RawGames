// Test clientside script for living_battlefield

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\living_battlefield_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\living_battlefield_amb::main();

	clientscripts\_treadfx::main( "lvt4" );
	clientscripts\_treadfx::main( "rubber_raft" );
	
	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : living_battlefield running...");
}
