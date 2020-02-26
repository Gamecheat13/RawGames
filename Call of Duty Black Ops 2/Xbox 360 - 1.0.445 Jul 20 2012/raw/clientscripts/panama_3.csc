// Test clientside script for panama

#include clientscripts\_utility;

#define CLIENT_FLAG_MOVER_EXTRA_CAM 1
#define CLIENT_FLAG_BLOOD_POOL 13

main()
{
	// _load!
	clientscripts\_load::main();

	clientscripts\panama_3_fx::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\panama_3_amb::main();

	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MOVER_EXTRA_CAM, ::toggle_extra_cam );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_BLOOD_POOL, ::blood_pool );

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : panama_3 running...");
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

blood_pool( localClientNum, set, newEnt )
{
	self MapShaderConstant( localClientNum, 0, "ScriptVector0" );
	
	PrintLn( "**** setting blood pool - client ****" );
	
	UNUSED = 0;
	N_TRANSITION_TIME = 10;
	
	s_timer = new_timer();
	
	do
	{
		wait .01;
		
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = LerpFloat( 0, 0.9, n_current_time / N_TRANSITION_TIME );
		
		self SetShaderConstant( localClientNum, 0, n_delta_val, UNUSED, UNUSED, UNUSED );
	}
	while ( n_current_time < N_TRANSITION_TIME );
}

new_timer()
{
	s_timer = SpawnStruct();
	s_timer.n_time_created = GetRealTime();
	return s_timer;
}

get_time()
{
	t_now = GetRealTime();
	return t_now - self.n_time_created;
}

get_time_in_seconds()
{
	return get_time() / 1000;
}
