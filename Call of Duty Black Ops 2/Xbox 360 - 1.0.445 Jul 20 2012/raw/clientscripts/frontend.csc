// Test clientside script for frontend

#include clientscripts\_callbacks;
#include clientscripts\_utility;
#include clientscripts\frontend_menu;
#include clientscripts\_qrcode;

#define CLIENT_FLAG_FROSTED_GLASS 11
#define CLIENT_FLAG_CLOCK 12
#define CLIENT_FLAG_MAP_MONITOR 13
#define UNUSED 0
	
main()
{
	// Keep this here for CreateFx
	clientscripts\frontend_fx::main();
	
	// _load!
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\frontend_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	default_settings();
	frontend_menu_init();
	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_FROSTED_GLASS, ::frosted_glass );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_CLOCK, ::world_clock_run );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MAP_MONITOR, ::map_monitor_run );

	//-- bink on the screens
	level.screen_bink = PlayBink( "frontend_screen", 2 );
	
	// all world maps share this same data.
	//
	{
		level.world_map = SpawnStruct();
	
		// translate x, translate y, rotation, scale
		level.world_map.transform = array( 0, 0, 0, 1.0 );
		
		// valid range 0-3, 3 = off.
		level.world_map.tint = array( 0, 2, 1, 2, 1, 0 );
		
		// valid range: 0 = off, 1 = on
		level.world_map.marker_toggle = array( 1, 1, 1, 1, 1, 1 );
		level.world_map.widget_toggle = array( 1, 1, 1, 1, 1, 1 );
		
		// valid range: 0-6, 6 = off
		level.world_map.main_icon = 0;
	}
	
	/#PrintLn("*** Client : frontend is running...");#/
}


frosted_glass( localClientNum, set, newEnt )
{
	self MapShaderConstant( localClientNum, 0, "ScriptVector0" );
	
	/#PrintLn( "**** starting frosted glass - client ****" );#/

	N_TRANSITION_TIME = 1;
	
	n_start_pct = 1;
	n_end_pct = 0;
	
	if ( set )
	{
		n_start_pct = 0;
		n_end_pct = 1;
	}
	
	step_size = 1 / ( 60 * N_TRANSITION_TIME );
	transition_pct = 0.0;
	
	do
	{
		wait .01;
		
		n_delta_val = LerpFloat( n_start_pct, n_end_pct, transition_pct );
		//PrintLn( "Glass Shader Val: " + n_delta_val );
		self SetShaderConstant( localClientNum, 0, n_delta_val, n_delta_val, n_delta_val, n_delta_val );
		transition_pct = transition_pct + step_size;
		
	} while ( transition_pct < 1.0 );
}

world_clock_get_offset()
{
	if ( IsSubStr( self.model, "chicago" ) )
	{
		return -6;
	}
	else if ( IsSubStr( self.model, "los_angeles" ) )
	{
		return -8;
	}
	else if ( IsSubStr( self.model, "new_york" ) )
	{
		return -5;
	}
	else if ( IsSubStr( self.model, "tokyo" ) )
	{
		return 9;
	}
	else if ( IsSubStr( self.model, "hong_kong" ) )
	{
		return 8;
	}
	
	return 0;
}

#define SHADER_DIGIT_X(num) (num%5)
#define SHADER_DIGIT_Y(num) Floor(num/5)
	
world_clock_run( localClientNum, set, newEnt )
{
	self mapShaderConstant( localClientNum, 0, "ScriptVector0" );
	
	gmt_offset = self world_clock_get_offset();
	
	/#
		if ( isdefined( self.script_noteworthy ) )
	    {
	    	PrintLn( "Client: clock digit running: " + self.script_noteworthy );
	    }
	#/
	
	while ( true )
	{
		// the format should be an array (hour, min, sec), military time
		//	if we pass in a 1 then we'll get GMT 0 London time, else we get the local time on the kit
		curr_time = GetSystemTime( 1 );
	
		hours = Int(curr_time[0]);
		minutes = Int(curr_time[1]);
		seconds = Int(curr_time[2]);
		
		// adjust for time zone.
		hours += gmt_offset;
		
		// Clamp 0-23
		{
			if ( hours < 0 )
				hours += 24;
			else if ( hours >= 24 )
				hours -= 24;
		}
		
		time = array( Floor( hours / 10 ), hours % 10, Floor( minutes / 10 ), minutes % 10);
		
		// Shift the numbers down one (or back to 9 for zero).
		for ( i = 0; i < time.size; i++ )
		{
			time[i] = Float(Int(time[i] + 9) % 10);
		}
		
		self setShaderConstant( localClientNum, 0, time[0], time[1], time[2], time[3] );
		
		wait 1.0;
	}
}

refresh_map_shaders( localClientNum )
{
	self SetShaderConstant( localClientNum, 0, level.world_map.transform[0],		level.world_map.transform[1],		level.world_map.transform[2],		level.world_map.transform[3] );
	self SetShaderConstant( localClientNum, 1, level.world_map.tint[0],				level.world_map.tint[1],			level.world_map.tint[2],			level.world_map.tint[3] );
	self SetShaderConstant( localClientNum, 2, level.world_map.tint[4],				level.world_map.tint[5],			level.world_map.marker_toggle[0],	level.world_map.marker_toggle[1] );
	self SetShaderConstant( localClientNum, 3, level.world_map.marker_toggle[2],	level.world_map.marker_toggle[3],	level.world_map.marker_toggle[4],	level.world_map.marker_toggle[5] );
	self SetShaderConstant( localClientNum, 4, level.world_map.widget_toggle[0],	level.world_map.widget_toggle[1],	level.world_map.widget_toggle[2],	level.world_map.widget_toggle[3] );
	self SetShaderConstant( localClientNum, 5, level.world_map.widget_toggle[4],	level.world_map.widget_toggle[5],	level.world_map.main_icon,			0 );
}

// Setting the flag assigns the shader constants.
// Clearing it updates the values according to what's stored in script.
//
map_monitor_run( localClientNum, set, newEnt )
{
	if ( set )
	{
		if ( !isdefined( self.shader_inited ) )
		{
			self MapShaderConstant( localClientNum, 0, "ScriptVector0" );
			self MapShaderconstant( localClientNum, 1, "ScriptVector1" );
			self MapShaderconstant( localClientNum, 2, "ScriptVector2" );
			self MapShaderconstant( localClientNum, 3, "ScriptVector3" );
			self MapShaderconstant( localClientNum, 4, "ScriptVector4" );
			self MapShaderconstant( localClientNum, 5, "ScriptVector5" );
		}
		
		self refresh_map_shaders( localClientNum );
	}
}


set_world_map_tint( index, tint_type_index )
{
	level.world_map.tint[index] = tint_type_index;
}

toggle_world_map_widget( index, toggle_on )
{
	level.world_map.widget_toggle[index] = toggle_on;
}

toggle_world_map_marker( index, toggle_on )
{
	level.world_map.marker_toggle[index] = toggle_on;
}

set_world_map_icon( icon_index )
{
	level.world_map.main_icon = icon_index;
}

set_world_map_translation( x, y )
{
	level.world_map.transform[0] = x;
	level.world_map.transform[1] = y;
}

set_world_map_rotation( theta )
{
	level.world_map.transform[2] = theta;
}

set_world_map_scale( scale )
{
	level.world_map.transform[3] = scale;
}

default_settings()
{
	SetClientDvar( "hud_showstance", 0 );
	SetClientDvar( "compass", 0);
}


SetTrackInfoQRCode(index)
{
	setup_qr_code("frontend", 3, index);
}
