#include clientscripts\_utility;

main()
{
	clientscripts\so_rts_mp_dockside_fx::main();
	clientscripts\_claw_grenade::main();
	
	clientscripts\_load::main();
	
	thread clientscripts\_audio::audio_init(0); 
	thread clientscripts\so_rts_mp_dockside_amb::main();
	
	thread clientscripts\_so_rts::rts_init();
	
	clientscripts\_footsteps::RegisterAITypeFootstepCB("So_Enemy_Bigdog", clientscripts\_footsteps::BigDogFootstepCBFunc);
	
		// This needs to be called after all systems have been registered.
	thread waitforclient(0);
}
