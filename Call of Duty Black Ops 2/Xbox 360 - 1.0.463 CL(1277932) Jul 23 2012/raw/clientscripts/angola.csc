// Test clientside script for angola

#include clientscripts\_utility;

#define CLIENT_FLAG_MOVER_EXTRA_CAM 1

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\angola_fx::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\angola_amb::main();
	
	thread fog_controller();
	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MOVER_EXTRA_CAM, ::toggle_extra_cam );

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : angola running...");
}

toggle_extra_cam( localClientNum, set, newEnt )
{
    if ( !IsDefined( level.extraCamActive ) )
    {
        level.extraCamActive = false;
    }
    
    if ( !level.extraCamActive && set )
    {
        PrintLn( "**** extra cam on - client ****" );
                    
        level.extraCamActive = true;
        self IsExtraCam( localClientNum );
    }
    else if ( level.extraCamActive && !set )
    {
        PrintLn( "**** extra cam on - client ****" );
        
        StopExtraCam( localClientNum );
        level.extraCamActive = false;
    }
}

fog_controller()
{
	level waittill( "fog_change" );
	SetWorldFogActiveBank( 0, 2 );	
	
	level waittill( "fog_change" );
	SetWorldFogActiveBank( 0, 4 );	
	
	level waittill( "fog_change" );
	SetWorldFogActiveBank( 0, 1 );	
}