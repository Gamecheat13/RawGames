#include clientscripts\_utility;
#include clientscripts\_filter;
#include clientscripts\la_argus;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

#define UNUSED 0

main()
{
	clientscripts\la_1b_fx::main();
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\la_1b_amb::main();
	
	thread clientscripts\_fire_direction::init();
	
	clientscripts\_claw_grenade::main();
	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MOVER_HOLOGRAM, ::animate_data_glove_hologram );
	
	waitforclient(0);	// This needs to be called after all systems have been registered.
	
	println("*** Client : la_1b running...");
	
	level thread setup_fullscreen_postfx();
	level thread sam_screen();
	
	// Big Dog footsteps are still driven in script.
	
	clientscripts\_footsteps::RegisterAITypeFootstepCB("Enemy_Manticore_LA_BigDog", clientscripts\_footsteps::BigDogFootstepCBFunc);
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

setup_fullscreen_postfx()
{
	waitforclient(0);
	
	init_filter_sonar( level.localPlayers[0] );
	init_filter_hud_outline( level.localPlayers[0] );
	
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
	disable_filter_hud_outline( level.localPlayers[0], 0, 0 );
	level.localPlayers[0] setSonarEnabled(0); 
} 

start_hud_outline()
{
	println("*** START HUD ***");	
	enable_filter_hud_outline( level.localPlayers[0], 0, 0 );
	level.localPlayers[0] setSonarEnabled(1); 
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

#define MIN_SAM_HUD_STRENGTH 0.5
#define MAX_SAM_HUD_STRENGTH 1
#define SAM_HUD_FADE_IN_TIME 0.1
#define SAM_HUD_FADE_OUT_TIME 0.33
#define SAM_HUD_FADE_IN_RATE MIN_SAM_HUD_STRENGTH / SAM_HUD_FADE_IN_TIME	
#define SAM_HUD_FADE_OUT_RATE MAX_SAM_HUD_STRENGTH / SAM_HUD_FADE_OUT_TIME
	
init_sam_hud_damage()
{
	level thread sam_damage();
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
	
