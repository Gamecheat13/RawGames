#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_blackstation_fx;
#using scripts\cp\cp_mi_sing_blackstation_sound;

                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




	
#precache( "client_fx", "weather/fx_rain_system_lite_runner" );
#precache( "client_fx", "weather/fx_rain_system_med_runner" );
#precache( "client_fx", "weather/fx_rain_system_hvy_runner" );
#precache( "client_fx", "water/fx_temp_water_tidal_wave_sgen" );

function main()
{
	register_clientfields();
	
	level._effect[ "rain_light" ] = "weather/fx_rain_system_lite_runner";
	level._effect[ "rain_med" ] = "weather/fx_rain_system_med_runner";
	level._effect[ "rain_heavy" ] = "weather/fx_rain_system_hvy_runner";
	level._effect[ "wave_pier" ] = "water/fx_temp_water_tidal_wave_sgen";

	//for keyline
	duplicate_render::set_dr_filter_offscreen( "sitrep_keyline_red", 25, "keyline_active_red", "keyfill_active_red", 2, "mc/hud_outline_model_red" );
	
	callback::on_localclient_connect( &on_player_connect );

	cp_mi_sing_blackstation_fx::main();
	cp_mi_sing_blackstation_sound::main();
	
	load::main();
	
	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}


function register_clientfields()
{
	clientfield::register( "toplayer", "fullscreen_rain_fx", 1, 1, "int", &toggle_rain_overlay, !true, !true );
	clientfield::register( "toplayer", "sndWindSystem", 1, 2, "int", &cp_mi_sing_blackstation_sound::sndWindSystem, !true, !true );
	clientfield::register( "world", "water_level", 1, 3, "int", &water_level_manager, !true, !true );
	clientfield::register( "actor", "kill_target_keyline", 1, 4, "int", &keyline_activation,	!true, !true );
	clientfield::register( "world", "pier_wave_init", 1, 1, "int", &pier_wave_initfunc, !true, !true );
	clientfield::register( "world", "pier_wave_play", 1, 1, "int", &pier_wave_playfunc, !true, !true );
	clientfield::register( "toplayer", "player_rain", 1, 2, "int", &rain_on_player, !true, !true );
}

function rain_on_player( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		switch( newVal )
		{
			case 1:  //light rain
				//str_fx = "rain_light";
				str_fx = "rain_heavy";  //using "heavy" fx since light/med have not been updated
				n_delay = 0.5;
				self thread player_rain( localClientNum, str_fx, n_delay );
				break;
				
			case 2:  //med rain
				//str_fx = "rain_med";
				str_fx = "rain_heavy";  //using "heavy" fx since light/med have not been updated
				n_delay = 0.3;
				self thread player_rain( localClientNum, str_fx, n_delay );
				break;
				
			case 3:  //heavy rain
				str_fx = "rain_heavy";
				n_delay = 0.03;
				self thread player_rain( localClientNum, str_fx, n_delay );
				break;
		}
	}
	else
	{
		if ( IsDefined( self.n_fx_id ) )
		{
			self notify( "stop_rain" );
			
			wait 0.1;  //time for rain fx to stop
			
			DeleteFX( localClientNum, self.n_fx_id, true );
		}	
	}
}

function player_rain( localClientNum, str_fx, n_delay )
{
	self notify( "stop_rain" );
	
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	self endon( "stop_rain" );
	
	if ( isdefined( self.n_fx_id ) )
	{
		DeleteFX( localClientNum, self.n_fx_id, true );
	}
	
	while ( true )
	{	
		self.n_fx_id = PlayFX( localClientNum, level._effect[ str_fx ], self.origin );
		
		wait n_delay;
	}
}

function pier_wave_initfunc( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_blackstation_water_pier_bundle" );
	}
}

function pier_wave_playfunc( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level endon( "stop_waves" );
	
	if ( newVal )
	{
		e_align = GetEnt( localClientNum, "align_pier_wave", "targetname" );
		e_wave = GetEnt( localClientNum, "water_pier", "targetname" );
		v_tag = e_wave GetTagOrigin( "wave_01_crest_jnt" );
		v_fxpos = v_tag + ( 280, 0, 200 );
		
		//TODO - fxanim wave test
		while( 1 )
		{
			e_align thread scene::play( "p7_fxanim_cp_blackstation_water_pier_wave_01_bundle" );
			
			//level waittill( "wave_01_hits_pier" );
			wait 0.7;  //TODO - notetrack notify not hitting for some reason
			
			e_wave.n_fx_1 = PlayFX( localClientNum, level._effect[ "wave_pier" ], v_fxpos );
			
			wait 0.25;  //delay before secondary wave hits
			
			e_wave.n_fx_2 = PlayFX( localClientNum, level._effect[ "wave_pier" ], v_fxpos + ( -50, 0, 0 ) );
			
			wait 1.0;  //let fx play out
			
			if ( isdefined( e_wave.n_fx_1 ) )
			{
				DeleteFX( localClientNum, e_wave.n_fx_1, true );
			}
			
			wait 0.5;  //let fx play out
			
			if ( isdefined( e_wave.n_fx_2 ) )
			{
				DeleteFX( localClientNum, e_wave.n_fx_2, true );
			}
			
			wait RandomFloatRange( 1.5, 2.5 );
		}
	}
	else
	{
		level notify( "stop_waves" );
	}
}

function keyline_activation( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	
	e_player = GetLocalPlayer( localClientNum );
	
	if ( !isdefined( e_player ) || ( newVal != e_player GetEntityNumber() + 1 ) )
	{
		return;
	}
	
	Assert( isdefined(self), "Entity trying to keyline is not valid" );
	
	level flagsys::wait_till( "duplicaterender_registry_ready" );//Wait for materials to get registered by manager
	
	Assert( isdefined(self), "Entity trying to keyline was deleted before the system was ready" );
	
	self duplicate_render::change_dr_flags( "keyline_active_red", "keyfill_active_red" );
}

function water_level_manager( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	switch( newVal )
	{
		case 1:
			level thread water_level_rise();
			break;
			
		case 2:
			level thread water_level_lower();
			break;

		case 3:
			SetWaveWaterHeight( "frogger_water", 64 );
			break;			
			
		default:
			SetWaveWaterHeight( "port_water", 0 );
			break;
	}
}

function water_level_lower()
{
	level notify( "stop_water_rise" );
	level endon( "stop_water_lower" );
	
	n_curr = 20;
	n_drop = 0.15;
	n_rate = 0.05;
	b_rising = false;	
	
	while( !b_rising )
	{
		SetWaveWaterHeight( "port_water", n_curr );
		
		if ( n_curr > n_drop )
		{
			n_curr -= n_drop;
			
			if ( n_curr <= n_drop )
			{				
				b_rising = true;
			}
		}
		
		wait 0.01;
	}	
}

function water_level_rise()
{
	level notify( "stop_water_lower" );
	level endon( "stop_water_rise" );
	
	n_curr = 0;
	n_rise = 0.25;
	b_rising = true;	
	
	while( b_rising )
	{
		SetWaveWaterHeight( "port_water", n_curr );
		
		if ( n_curr < 20 )
		{
			n_curr += n_rise;
			
			if ( n_curr >= 20 )
			{				
				b_rising = false;	
			}
		}
		
		wait 0.01;
	}	
}


function on_player_connect( localClientNum )
{
	filter::init_filter_raindrops( self );
}


function toggle_rain_overlay( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
    {
		/#
        PrintLn( "**** rain overlay on ****" );
		#/
			
		filter::enable_filter_raindrops( self, 2 );
	}
    else
    {
    	/#
    	PrintLn( "**** rain overlay off ****" );
    	#/
    		
    	filter::disable_filter_raindrops( self, 2 );
    }
}
