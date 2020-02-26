// Test clientside script for ber1

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\_t34::main( "vehicle_rus_tracked_t34_mg", "t34_ber1" );

	clientscripts\ber1_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\ber1_amb::main();

	clientscripts\_vehicle::build_treadfx( "il2" );	// set up il2 for dust fx.

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	println("*** Client : ber1 running...");
}
