// Test clientside script for la_2

#include clientscripts\_utility;
#include clientscripts\_filter;
#include clientscripts\_glasses;
#include clientscripts\la_argus;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

main()
{
	clientscripts\la_2_fx::main();
	
	// _load!
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);
	clientscripts\_claw_grenade::main();
	thread clientscripts\la_2_amb::main();

	register_clientflag_callback("player", 0, ::player_flag0_handler);		
	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_DAMAGE_OFF, ::f35_damage_off );	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_DAMAGE_LIGHT, ::f35_damage_light );	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_DAMAGE_HEAVY, ::f35_damage_heavy );		
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);
	
	// 640 x 480 of a 1024x1024 buffer
	ui3dsetwindow( 0, 0, 0, 1, 1 );		

	println("*** Client : la_2 running...");

	level thread la2_setup_fullscreen_postfx();
	level thread la2_turn_off_sonar();
	level thread fog_bank_controller();
	level thread fog_bank_eject_sequence();
}

la2_setup_fullscreen_postfx()
{	
	level waittill( "player_put_on_helmet" );
	
	//init_filter_hud_outline( level.localPlayers[0] );
	//enable_filter_hud_outline( level.localPlayers[0], 0, 0 );

	init_f35_hud_damage();
	level thread temp_toggle_hud_damage();
	level.localPlayers[0] setSonarEnabled(1); 	//have to turn it off at sometime
}

la2_turn_off_sonar()
{
	level waittill( "player_turn_off_sonar" );
	
	level.localPlayers[0] setSonarEnabled(0); 
}


player_flag0_handler(localClientNum, set, newEnt)
{
	if(set)
	{
		wait(.05);
		self.visor = Spawn(self GetLocalClientNumber(), self get_eye(), "script_model");
		self.visor.angles = self.angles;
		self.visor SetModel( "test_ui_hud_visor" );
		self.visor LinkToCamera(4, ( 2.35, 0, 0.1 ) );
	}
	else
	{
		wait 0.05;
		if ( IsDefined( self.visor ) )
		{
			self.visor UnLinkFromCamera();
			self.visor Delete();
		}
	}	
}

fog_bank_controller()
{
	level waittill( "set_intro_fog_banks" );
	SetWorldFogActiveBank( 0, 7 );
	
	level waittill( "set_jet_fog_banks" );
	SetWorldFogActiveBank( 0, 1 );
}

fog_bank_eject_sequence()
{
	level waittill ( "set_eject_fog_bank" );
	SetWorldFogActiveBank( 0, 8 );
	
	level waittill ( "set_outro_fog_bank" );
	SetWorldFogActiveBank( 0, 1 );
}

#define SAM_FILTER_INDEX 4
#define MIN_SAM_HUD_STRENGTH 0.5
#define MAX_SAM_HUD_STRENGTH 1
#define SAM_HUD_FADE_IN_TIME 0.1
#define SAM_HUD_FADE_OUT_TIME 0.33
#define SAM_HUD_FADE_IN_RATE MIN_SAM_HUD_STRENGTH / SAM_HUD_FADE_IN_TIME	
#define SAM_HUD_FADE_OUT_RATE MAX_SAM_HUD_STRENGTH / SAM_HUD_FADE_OUT_TIME

init_f35_hud_damage()
{
	level.localPlayers[0].sam_hud_damage_intensity = 0;
	
	init_filter_f35_damage( level.localPlayers[0] );
	enable_filter_f35_damage( level.localPlayers[0], SAM_FILTER_INDEX );	
	set_filter_f35_damage_amount( level.localPlayers[0], SAM_FILTER_INDEX, 0 );
}

temp_toggle_hud_damage()
{
	while ( true )
	{
		level waittill( "temp_disable_hud_damage" );
		disable_filter_f35_damage( level.localPlayers[0], SAM_FILTER_INDEX );	
		println( "+++ disabled damage filter +++" );
		
		level waittill( "temp_enable_hud_damage" );
		enable_filter_f35_damage( level.localPlayers[0], SAM_FILTER_INDEX );	
		set_filter_f35_damage_amount( level.localPlayers[0], SAM_FILTER_INDEX, 0 );		
		println( "+++ enabled damage filter +++" );
	}
}

f35_damage_off( localClientNum, set, newEnt )
{
	level endon( "sam_hud_damage" );
	level endon( "sam_hud_damage_heavy" );
	
	if ( set )
	{
		while ( level.localPlayers[0].sam_hud_damage_intensity > 0 )
		{
			level.localPlayers[0].sam_hud_damage_intensity -= SAM_HUD_FADE_OUT_RATE * ( 1.0 / 60.0 );
			if ( level.localPlayers[0].sam_hud_damage_intensity < 0 )
				level.localPlayers[0].sam_hud_damage_intensity = 0;
			
			set_filter_f35_damage_amount( level.localPlayers[0], SAM_FILTER_INDEX, level.localPlayers[0].sam_hud_damage_intensity );		
			
			wait( 1.0 / 60.0 );
		}
	}
}

f35_damage_light( localClientNum, set, newEnt )
{
	level endon( "sam_hud_damage_heavy" );
	
	if ( set )
	{
		level notify( "sam_hud_damage" );
		
		while ( level.localPlayers[0].sam_hud_damage_intensity < MIN_SAM_HUD_STRENGTH )
		{
			level.localPlayers[0].sam_hud_damage_intensity += SAM_HUD_FADE_IN_RATE * ( 1.0 / 60.0 );
			if ( level.localPlayers[0].sam_hud_damage_intensity > MIN_SAM_HUD_STRENGTH )
				level.localPlayers[0].sam_hud_damage_intensity = MIN_SAM_HUD_STRENGTH;
			
			set_filter_f35_damage_amount( level.localPlayers[0], SAM_FILTER_INDEX, level.localPlayers[0].sam_hud_damage_intensity );				
			
			wait( 1.0 / 60.0 );
		}	
	}
}

f35_damage_heavy( localClientNum, set, newEnt )
{
	if ( set )
	{
		level notify( "sam_hud_damage_heavy" );			
		
		while ( level.localPlayers[0].sam_hud_damage_intensity < MAX_SAM_HUD_STRENGTH )
		{
			level.localPlayers[0].sam_hud_damage_intensity += SAM_HUD_FADE_IN_RATE * ( 1.0 / 60.0 );
			if ( level.localPlayers[0].sam_hud_damage_intensity > MAX_SAM_HUD_STRENGTH )
				level.localPlayers[0].sam_hud_damage_intensity = MAX_SAM_HUD_STRENGTH;
			
			set_filter_f35_damage_amount( level.localPlayers[0], SAM_FILTER_INDEX, level.localPlayers[0].sam_hud_damage_intensity );				
			
			wait( 1.0 / 60.0 );
		}		
	}
}
