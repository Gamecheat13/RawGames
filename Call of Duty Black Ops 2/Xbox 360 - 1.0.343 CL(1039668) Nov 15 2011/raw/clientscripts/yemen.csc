// Test clientside script for yemen

#include clientscripts\_utility;
#include clientscripts\_glasses;

main()
{

        // This MUST be first for CreateFX!	
        clientscripts\yemen_fx::main();

        // _load!
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\yemen_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : yemen running...");
}
