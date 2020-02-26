#include clientscripts\_utility;
#include clientscripts\_filter;
#include clientscripts\la_argus;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

#define UNUSED 0

main()
{
	clientscripts\la_1_fx::main();
	clientscripts\_load::main();
	
	set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewbody" );

	//thread clientscripts\_fx::fx_init(0);
	level thread clientscripts\_audio::audio_init(0);

	level thread clientscripts\la_1_amb::main();
	
	clientscripts\_driving_fx::init();
	clientscripts\_apc_cougar_ride::init();
	
	clientscripts\_claw_grenade::main();
	
	register_clientflag_callback( "vehicle", CLIENT_FLAG_VEHICLE_REFLECTION_BLUR, ::window_reflection_blur );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MOVER_EXTRA_CAM, ::toggle_extra_cam );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MOVER_HOLOGRAM, ::animate_data_glove_hologram );
	
	waitforclient(0);	// This needs to be called after all systems have been registered.
	
	println("*** Client : la_1 running...");
	
	level thread setup_fullscreen_postfx();
	level thread sam_screen();
	level thread sonar_on_nofity();
	level thread sonar_off_nofity();
	
	
}

setup_fullscreen_postfx()
{
	waitforclient(0);
	
	//init_filter_sonar( level.localPlayers[0] );
	init_sam_hud_damage();	
}

sam_screen()
{       
	while ( true )
	{
		level waittill( "sam_on" );
		start_hud_outline();	
        level waittill( "sam_off" );
		stop_hud_outline();	   
 	}
}

stop_hud_outline()
{
  	println("*** STOP HUD ***");
   // disable_filter_hud_outline( level.localPlayers[0], 0, 0 );
    level.localPlayers[0] setSonarEnabled(0); 
} 

start_hud_outline()
{
	println("*** START HUD ***");	
	//enable_filter_hud_outline( level.localPlayers[0], 0, 0 );
	level.localPlayers[0] setSonarEnabled(1); 
}

animate_data_glove_hologram( localClientNum, set, newEnt )
{
	self MapShaderConstant( localClientNum, 0, "ScriptVector7" );
	
	PrintLn( "**** setting reflection blur - client ****" );
	
	N_TIME = 3;
	
	s_timer = new_timer();
	
	do
	{
		n_current_time = s_timer get_time_in_seconds();
		n_val = LerpFloat( -.2, .3, n_current_time / N_TIME );
		
		self SetShaderConstant( localClientNum, 0, n_val, UNUSED, UNUSED, UNUSED );
		
		wait .01;
	}
	while ( n_current_time < N_TIME );
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

window_reflection_blur( localClientNum, set, newEnt )
{
	self MapShaderConstant( localClientNum, 0, "ScriptVector0" );
	
	PrintLn( "**** setting reflection blur - client ****" );
	
	N_BLUR_TIME = .5;
	
	s_timer = new_timer();
	
	do
	{
		wait .01;
		
		n_current_time = s_timer get_time_in_seconds();
		n_blur_val = LerpFloat( 0, 1, n_current_time / N_BLUR_TIME );
		
		self SetShaderConstant( localClientNum, 0, n_blur_val, UNUSED, UNUSED, UNUSED );
	}
	while ( n_current_time < N_BLUR_TIME );
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

get_time_delta()
{
	t_now = GetRealTime();
	t_delta = 0;

	if ( IsDefined( self.n_last_get_time ) )
	{
		t_delta = t_now - self.n_last_get_time;
		
		/* set time delta to 0 if game was paused */
		
		if ( t_delta >= 500 )
		{
			t_delta = 0;
		}
	}
	
	self.n_last_get_time = t_now;
	return t_delta;
}



sonar_on_nofity()
{
	while ( true )
	{
		level waittill( "sonar_on", localClientNum );
		sonar_on( localClientNum );
		wait 0.05;
	}
}

sonar_off_nofity()
{
	while ( true )
	{
		level waittill( "sonar_off", localClientNum );
		sonar_off( localClientNum );
		wait 0.05;
	}
}

sonar_on( localClientNum )
{
	level thread sonar_fade( localClientNum, 1 );
}

sonar_off( localClientNum )
{
	level thread sonar_fade( localClientNum, 0 );
}

sonar_fade( localClientNum, sonar_turning_on )
{
	// Let's enable the sonar reveal filter, ramp it up to 100% opacity in 0.5 seconds, 
	// then actually turn on the sonar effect, then ramp down the sonar reveal filter,
	// and then turn off the sonar reveal filter as to not encure any performance overhead
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
	
	if ( sonar_turning_on )
		enable_filter_sonar_glass( level.localPlayers[0], 0, 0 );
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
	
	starttime   = getrealtime();
	currenttime = starttime;
	elapsedtime = 0;
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
	
	if ( sonar_turning_on )
	{
		delayDark  = 1.0;
		delaySonar = 2.0;
		delayTotal = delayDark + delaySonar;
		
		while( elapsedtime < delayTotal )
		{
			wait( 0.01 );
			currenttime = getrealtime();
			elapsedtime = ( currenttime - starttime ) / 1000.0;
		
			if ( elapsedtime > delayTotal )
				elapsedTime = delayTotal;
				
			if ( elapsedTime < delayDark )
			{
				set_filter_sonar_reveal_amount( level.localPlayers[0], 0, elapsedtime / delayDark * 0.5 );	
			}
			else
			{
				println("csc " + localClientNum + " : turn sonar on");
				level.localPlayers[0] setsonarenabled( 1 );
				
				set_filter_sonar_reveal_amount( level.localPlayers[0], 0, ( elapsedtime - delayDark ) / delaySonar * 0.5 + 0.5 );	
			}
		}
	}
	else
	{
		delayDark  = 0.0;
		delaySonar = 2.0;
		delayTotal = delayDark + delaySonar;
		
		while( elapsedtime < delayTotal )
		{
			wait( 0.01 );
			currenttime = getrealtime();
			elapsedtime = ( currenttime - starttime ) / 1000.0;
		
			if ( elapsedtime > delayTotal )
				elapsedTime = delayTotal;
				
			if ( elapsedtime < delaySonar )
			{
				set_filter_sonar_reveal_amount( level.localPlayers[0], 0, 1 - ( elapsedtime / delaySonar * 0.5 ) );
			}		
			else
			{
				println("csc " + localClientNum + " : turn sonar off");
				level.localPlayers[0] setsonarenabled( 0 );
				
				set_filter_sonar_reveal_amount( level.localPlayers[0], 0, 0.5 - ( ( elapsedtime - delaySonar ) * 0.5 ) );
			}	
		}
	}
		
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
	
	if ( !sonar_turning_on )
		disable_filter_sonar_glass( level.localPlayers[0], 0, 0 );
}

init_sam_hud_damage()
{
	//level thread sam_damage();
}

sam_damage()
{  
	/*while ( true )
	{
		level waittill( "sam_on" );
		enable_filter_sam_damage( level.localPlayers[0], 0 );		
        level waittill( "sam_off" );
        disable_filter_sam_damage( level.localPlayers[0], 0 );
 	}*/
}

