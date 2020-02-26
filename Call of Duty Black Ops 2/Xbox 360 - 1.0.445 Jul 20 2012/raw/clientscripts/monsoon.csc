// Test clientside script for monsoon

#include clientscripts\_utility;
#include clientscripts\_filter;

#define CLIENT_FLAG_PLAYER_RAIN			6
#define CLIENT_FLAG_PLAYER_WINGSUIT		7
#define CLIENT_FLAG_CAMO_TOGGLE 		12
#define CLIENT_FLAG_GASFREEZE_TOGGLE 	13

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\monsoon_fx::main();
	clientscripts\_explosive_dart::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\monsoon_amb::main();
	
	register_clientflag_callback( "player", CLIENT_FLAG_PLAYER_RAIN, ::toggle_rain_overlay );		
	register_clientflag_callback( "player", CLIENT_FLAG_PLAYER_WINGSUIT, ::toggle_wingsuit_overlay );		
		
	register_clientflag_callback( "actor", CLIENT_FLAG_CAMO_TOGGLE, 	 ::toggle_camo_suit );
	register_clientflag_callback( "actor", CLIENT_FLAG_GASFREEZE_TOGGLE, ::toggle_gas_suit );
	
	register_clientflag_callback( "vehicle", CLIENT_FLAG_GASFREEZE_TOGGLE, ::toggle_gas_suit );
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : monsoon running...");
	
	init_filter_raindrops( level.localPlayers[0] );
	init_filter_squirrel_raindrops( level.localPlayers[0] );
	
	level thread setup_goggles();
// wait 1;
// PlayViewmodelFX( 0, level._effect["fx_water_wingsuit"], "tag_view" );	
}

toggle_rain_overlay( localClientNum, set, newEnt )
{
	if ( set )
    {
        PrintLn( "**** rain overlay on ****" );
 		enable_filter_raindrops( level.localPlayers[0], 2 );
	}
    else
    {
    	PrintLn( "**** rain overlay off ****" );
    	disable_filter_raindrops( level.localPlayers[0], 2 );
    }
}

toggle_wingsuit_overlay( localClientNum, set, newEnt )
{
	if ( set )
    {
        PrintLn( "**** wingsuit overlay on ****" );
 		enable_filter_squirrel_raindrops( level.localPlayers[0], 3 );
	}
    else
    {
    	PrintLn( "**** wingsuit overlay off ****" );
    	disable_filter_squirrel_raindrops( level.localPlayers[0], 3 );
    }
}

// Eagle Eye Goggles
setup_goggles()
{
	init_filter_binoculars( level.localPlayers[0] );
	
	enable_goggles();
}

enable_goggles()
{
	level waittill( "binoc_on" );
	
	enable_filter_binoculars( level.localPlayers[0], 0, 0 );
	
	disable_goggles();
}

disable_goggles()
{
	level waittill( "binoc_off" );
	
	disable_filter_binoculars( level.localPlayers[0], 0, 0 );
}

//self is an AI with the suit, setting it to true turns the suit off since it defaults to on
#define N_TRANSITION_ON_TIME		3
#define N_TRANSITION_OFF_TIME		3
#define N_UNUSED					0
toggle_camo_suit( localClientNum, set, newEnt )
{
	self endon( "death" );
	
	self MapShaderConstant( localClientNum, 0, "ScriptVector0" );
	
	s_timer = new_timer();
	
    if ( set )
    {
        PrintLn( "**** AI at origin " + self.origin + " camo suit turned off ****" );
 	
		do
		{
			wait .01;
			
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = LerpFloat( 0, 1, n_current_time / N_TRANSITION_OFF_TIME );
			
			self SetShaderConstant( localClientNum, 0, n_delta_val, N_UNUSED, N_UNUSED, N_UNUSED );
		}
		while ( n_current_time < N_TRANSITION_OFF_TIME );
    }
    else
    {
    	PrintLn( "**** AI at origin " + self.origin + " camo suit turned on ****" );
 	
    	do
		{
			wait .01;
			
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = LerpFloat( 1, 0, n_current_time / N_TRANSITION_ON_TIME );
			
			self SetShaderConstant( localClientNum, 0, n_delta_val, N_UNUSED, N_UNUSED, N_UNUSED );
		}
		while ( n_current_time < N_TRANSITION_ON_TIME );
    }
}

toggle_gas_suit( localClientNum, set, newEnt )
{
	self MapShaderConstant( localClientNum, 0, "ScriptVector0" );
	s_timer = new_timer();
	
	do
	{
		wait(0.01);
		
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = LerpFloat( 0, 0.85, n_current_time / N_TRANSITION_ON_TIME );
	
		self SetShaderConstant( localClientNum, 0, N_UNUSED, N_UNUSED, n_delta_val, N_UNUSED );
	}
	while ( n_current_time < N_TRANSITION_OFF_TIME );
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