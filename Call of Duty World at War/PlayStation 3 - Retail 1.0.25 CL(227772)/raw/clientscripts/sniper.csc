// Test clientside script for sniper

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\sniper_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\sniper_amb::main();

	clientscripts\_truck::main( "vehicle_ger_wheeled_opel_blitz", "opel" );
	clientscripts\_halftrack::main( "vehicle_ger_tracked_halftrack" , "halftrack");
	clientscripts\_panzeriv::main( "vehicle_ger_tracked_panzer4v1" , "panzeriv");
	clientscripts\_jeep::main( "vehicle_ger_wheeled_horch1a_backseat", "horch" );
	
	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

}
