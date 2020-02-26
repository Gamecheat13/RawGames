#include clientscripts\_utility; 
#include clientscripts\_filter;

war_init()
{	
	level.CLIENT_FLAG_ALLY_EXTRA_CAM = 1;
	level.CLIENT_FLAG_ALLY_SWITCH = 2;	
	level.CLIENT_FLAG_REMOTE_MISSILE = 3;	
	
	level.satellite_duration = 2;

	register_clientflag_callback( "scriptmover", level.CLIENT_FLAG_ALLY_EXTRA_CAM, ::toggle_extra_cam );
	
	waitforclient(0);
	for(i=0;i<level.localPlayers.size;i++)
	{
		init_filter_satellite_transition( level.localPlayers[i] );
		//level thread satellite_transition( i, level.satellite_duration );	
	}			
		
	register_clientflag_callback( "player", level.CLIENT_FLAG_ALLY_SWITCH, ::toggle_satellite_hotness );
	register_clientflag_callback( "player", level.CLIENT_FLAG_REMOTE_MISSILE, ::toggle_satellite_RemoteMissile );
	
	clientscripts\_claw_grenade::main();
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
    	PrintLn( "**** extra cam off - client ****" );
    	
    	StopExtraCam( localClientNum );
        level.extraCamActive = false;
    }
}

toggle_satellite_hotness(localClientNum,set, newEnt)
{
	if ( !IsDefined( level.satelliteTransisionActive ) )
	{
		level.satelliteTransisionActive = false;
	}
 	if ( !level.satelliteTransisionActive && set )
    {
    	/#
        PrintLn( "**** satellite on - client ****" );
        #/
	    level.satelliteTransisionActive = true;
		level thread satellite_transition( localClientNum, level.satellite_duration );
    }
    else if ( level.satelliteTransisionActive && !set )
    {
    	/#
    	PrintLn( "**** satellite off - client ****" );
    	#/
        level.satelliteTransisionActive = false;
    }	
}
toggle_satellite_RemoteMissile(localClientNum,set, newEnt)
{
	if ( !IsDefined( level.satelliteTransisionActive ) )
	{
		level.satelliteTransisionActive = false;
	}
 	if ( !level.satelliteTransisionActive && set )
    {
		enable_filter_satellite_transition( level.localPlayers[localClientNum], 0, 0 );
    	/#
        PrintLn( "**** satellite on - client ****" );
        #/
	    level.satelliteTransisionActive = true;
	   	set_filter_satellite_transition_amount( level.localPlayers[localClientNum], 0, 0.7);	
     }
    else if ( level.satelliteTransisionActive && !set )
    {
		disable_filter_satellite_transition( level.localPlayers[localClientNum], 0, 0 );
    	/#
    	PrintLn( "**** satellite off - client ****" );
    	#/
        level.satelliteTransisionActive = false;
	   	set_filter_satellite_transition_amount( level.localPlayers[localClientNum], 0, 0 );	
    }	
}
	
satellite_transition( localClientNum, duration )
{
	//while( 1 )
	{
		enable_filter_satellite_transition( level.localPlayers[localClientNum], 0, 0 );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		starttime      = getrealtime();
		currenttime    = starttime;
		elapsedtime    = 0;
		halfTime       = duration * 0.5;
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		while( elapsedtime < duration )
		{
			wait( 0.01 );
			currenttime = getrealtime();
			elapsedtime = ( currenttime - starttime ) / 1000.0;
		
			if ( elapsedtime > duration )
				elapsedTime = duration;

			if ( elapsedTime < halfTime )
				val = elapsedtime/halfTime;
			else
				val = 1 - ( elapsedtime - halfTime ) / halfTime;
				

			set_filter_satellite_transition_amount( level.localPlayers[localClientNum], 0, val );	

			/#
				PrintLn( "**** satelite elapsedTime:" + elapsedTime + " value:" + val);
	 		#/
	 		


		}
				
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		disable_filter_satellite_transition( level.localPlayers[localClientNum], 0, 0 );
	}
}
