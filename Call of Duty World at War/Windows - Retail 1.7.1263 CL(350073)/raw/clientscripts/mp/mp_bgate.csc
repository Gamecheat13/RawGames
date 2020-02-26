// Clientside script for mp_bgate

#include clientscripts\mp\_utility;

main()
{
	// _load!
	clientscripts\mp\_load::main();
	clientscripts\mp\mp_bgate_fx::main();	
	thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);
	thread clientscripts\mp\mp_bgate_amb::main();

	println("*** Client : mp_bgate running...");
}
