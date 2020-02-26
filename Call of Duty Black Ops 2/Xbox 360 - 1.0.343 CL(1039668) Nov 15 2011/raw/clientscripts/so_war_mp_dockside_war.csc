#include clientscripts\_utility;

main()
{	
	clientscripts\_load::main();
	
	thread clientscripts\_audio::audio_init(0); 

	clientscripts\_so_war::war_init();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);
}