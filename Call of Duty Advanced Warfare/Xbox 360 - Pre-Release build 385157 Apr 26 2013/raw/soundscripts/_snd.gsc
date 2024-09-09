#include soundscripts\_audio;
#include soundscripts\_snd_hud;
#include soundscripts\_snd_filters;
#include soundscripts\_snd_timescale;
#include soundscripts\_audio_mix_manager;
#include soundscripts\_snd_foley;
#include maps\_utility;
#include soundscripts\_snd_common;

// CONSTANTS
DSP_BUS_FILE_NAME	= "sounddata/dspbuses.csv";
ONE_FRAME			= 0.05;

snd_init()
{
	if ( !IsDefined( level._snd ) )
	{
		level._snd = spawnstruct();
		thread snd_init_done();
		snd_debug_init();
		snd_hud_init();
		snd_set_soundtable_name( "shg" );
		snd_load_dsp_buses();
		snd_filters_init();
		snd_timescale_init();
		snd_foley_init();
		snd_message_init();
		snd_common_init();

		assert( snd_is_first_frame() );
	}
}

// Allows for enforcing some functions are only called in the first frame.
snd_init_done()
{
	assert( IsDefined( level._snd ) );
	level._snd.is_first_frame = true;
	waittillframeend;
	level._snd.is_first_frame = false;
}

snd_is_first_frame()
{
	assert( IsDefined(level._snd.is_first_frame ) );
	return level._snd.is_first_frame;
}

//////////////////////////////////////////////////////////////////////////////
// SOUND MESSAGE
//////////////////////////////////////////////////////////////////////////////

snd_message_init()
{
	level._snd.messages = [];
}

snd_register_message( message, callback )
{
	assertEx( IsDefined( level._snd ), "Need to call snd_message_init() before calling this function." );
	assert( IsArray( level._snd.messages ) );
	/#
		if ( IsDefined( level._snd.messages[message] ) && GetDebugDvarInt( "snd_verify_audio_messages" ) )
			IPrintLn( "snd_register_message() - Overwriting a pre-existing message handler: " + message + "." );
	#/
	level._snd.messages[message] = callback;
}

snd_music_message( message, arg1, arg2 )
{
	level notify( "stop_other_music" );
	level endon( "stop_other_music" );
	
	if ( IsDefined( arg2 ) )
		childthread snd_message( "snd_music_handler", message, arg1, arg2 );
	else if ( IsDefined( arg1 ) )
		childthread snd_message( "snd_music_handler", message, arg1 );
	else
		childthread snd_message( "snd_music_handler", message );
}

snd_message( message, arg1, arg2, arg3 )
{
	AssertEx( IsDefined( level._snd ), "Need to call snd_message_init() before calling this function." );
	Assert( IsArray( level._snd.messages ) );
	
	if ( IsDefined( level._snd.messages[message] ) )
	{
		if ( IsDefined( arg3 ) )
			thread [[ level._snd.messages[message] ]]( arg1, arg2, arg3 );
		else if ( IsDefined( arg2 ) )
			thread [[ level._snd.messages[message] ]]( arg1, arg2 );
		else if ( IsDefined( arg1 ) )
			thread [[ level._snd.messages[message] ]]( arg1 );
		else
			thread [[ level._snd.messages[message] ]]();
	}
	
	/#
	if ( !IsDefined( level._snd.messages[message] ) && GetDebugDvarInt( "snd_verify_audio_messages" ) )
		IPrintLn("snd_message not handled: " + message  + ".");
	#/
}

//////////////////////////////////////////////////////////////////////////////
// MISCELLANEOUS UTILS
//////////////////////////////////////////////////////////////////////////////

snd_get_tagarg(tag, args)
{
	assert( IsString(tag) );
	assert(!IsDefined(args) || IsArray(args) );
	result = undefined;
	if ( IsArray(args) )
	{
		result = args[tag];
	}
	return result;
}


snd_get_secs()
{
	return GetTime() * 0.001;
}

//////////////////////////////////////////////////////////////////////////////
// SERVER THROTTLER
//////////////////////////////////////////////////////////////////////////////

// called inside loops that are intended to be server-throttled
snd_throttle_wait()
{	
	assert( IsDefined( self ) && IsDefined( self.name ) && self.name == "throttle_waiter" );
	
	if ( self.count >= self.max_calls_per_frame )
	{
		wait( ONE_FRAME );
	}
	else
	{
		self.count++;
	}
	
	if ( !self.reset_thread_sent )
	{
		self thread snd_throttler_reset();
	}
}

// internal function used by snd_throttleer to reset the count at the end of the frame
snd_throttler_reset()
{
	self.reset_thread_sent = true;

	waittillframeend;
	assert( IsDefined( self ) && IsDefined( self.name ) && self.name == "throttle_waiter" );
	
	self.reset_thread_sent = false;
	self.count = 0;
}

snd_get_throttler( max_calls_per_frame_ )
{
	throttler = spawnstruct();
	throttler.name = "throttle_waiter";
	throttler.count = 0;
	throttler.reset_thread_sent = false;
	
	max_calls_per_frame = 10;
	if ( IsDefined( max_calls_per_frame_ ) )
	{
		max_calls_per_frame = max( max_calls_per_frame_, 1 );
	}

	throttler.max_calls_per_frame = max_calls_per_frame;

	return throttler;
}

//////////////////////////////////////////////////////////////////////////////
// SOUNDTABLE UTILS
//////////////////////////////////////////////////////////////////////////////

snd_set_soundtable_name( name )
{
	assert( IsDefined( level._snd ) );
	level._snd.soundtable = name;	
}

snd_get_soundtable_name()
{
	assert( IsDefined( level._snd ) );
	assert( IsDefined( level._snd.soundtable ) );
	return level._snd.soundtable;
}

// parses a sound preset header line
snd_parse_preset_header( filename, row_count, num_cols )
{
	assert( IsString( filename ) );
	assert( row_count >= 0 );
	assert( num_cols >= 0 );
	
	header = [];
	curr_col = 0;
	while( curr_col < num_cols )
	{
		row_value = tablelookupbyrow( filename, row_count, curr_col );
		header[row_value] = curr_col; // map header val to column num
		curr_col++;
	}
	return header;
}

// Parses the given soundtable_files array in the order they are stored in the indexed array
snd_parse_soundtables( soundtable_type, soundtable_files, num_cols )
{
	assert( IsString( soundtable_type ) );
	assert( IsArray( soundtable_files ) );
	assert( IsDefined( level._snd ) );
	assert( snd_is_first_frame() );

	/#
	if ( snd_stringtables_disabled() ) return undefined;
	#/	
	
	entries = [];

	for ( i = 0; i < soundtable_files.size; i++ )
	{	
		file = soundtable_files[ i ];
		assert( IsString( file ) );

		row_count = 0;
		header = undefined;
		empty_rows = 0;
		name_col = 0;
		entry = undefined;
		entry_name = "";
		
		while( empty_rows < 10 )
		{
			row_name = TableLookupByRow( file, row_count, name_col );
			if ( row_name != "" )
			{
				empty_rows = 0;
		
				if ( !IsDefined( header ) )
				{
					header = snd_parse_preset_header( file, row_count, num_cols );
					assert( IsDefined( header ) && IsDefined( header[ "name" ] ) );

					// update "name_col" in case preset file was re-ordered
					name_col = header[ "name" ];
				}
				else
				{
					spawn_new_entry = false;
					
					if ( !IsDefined( entry ) )
					{
						spawn_new_entry = true;
					}
					else if ( row_name != entry_name )
					{
						assert( IsDefined( entry ) );
						/#
						if ( IsDefined( entries[ entry_name ] ) )					  
							PrintLn( soundtable_type + " soundtable entry " + entry_name + " is defined multiple times." );
						#/
						entries[ entry_name ] = entry;
						spawn_new_entry = true;						
					}
					
					if ( spawn_new_entry )
					{
						entry = SpawnStruct();
						entry.name = row_name;
						entry.settings = [];						
						entry_name = row_name;
					}
					
					// Parse and label the params for this row based on the header order
					params = [];
					foreach( param, param_col in header )
					{
						assert( IsString( param ) );

						param_val = TableLookupByRow( file, row_count, param_col );
						
						if ( param == "name" )
						{
							if ( param_val != entry_name )
								break;
						}
						else
						{
							assertEx( IsDefined( param_val ) && param_val != "", soundtable_type + " parameter " + " is not defined for entry: " + row_name );
							if ( is_string_a_number( param_val ) )
								params[ param ] = float( param_val );
							else
								params[ param ] = param_val;
						}
					}
					
					entry.settings[ entry.settings.size ] = params;					
				}
				
			}
			else
			{
				if ( IsDefined( entry ) )				
				{
					assert( IsDefined( entry ) );
					/#
					if ( IsDefined( entries[ entry_name ] ) )					  
						PrintLn( soundtable_type + " soundtable entry " + entry_name + " is defined multiple times." );
					#/
					entries[ entry_name ] = entry;					
					entry = undefined;
				}
				
				empty_rows++;
			}
			row_count++;
		}	
	}
	return entries;	
}

//////////////////////////////////////////////////////////////////////////////
// DEV-ONLY DEBUG SCRIPTS
//////////////////////////////////////////////////////////////////////////////

snd_debug_init()
{
	/#
	// snd_debug_messages" - 1 turns on debugging of sound messages
	SetDvarIfUninitialized( "snd_debug_messages", 0 );

	thread snd_debug_dvar_monitor_thread();
	#/		
}

/#
snd_stringtables_disabled()
{
	// Stringtables are disabled when !USING( FASTFILE_LOAD ).
	// Use useFastFile dvar to avoid enabling a broken pathway.
	return ( getDvarInt( "useFastFile", 1 ) == 0 );
}
#/
	
/#
snd_debug_dvar_monitor_thread()
{
	wait( 0.1 ); // init wait for system initializations	

	while ( 1 )
	{
		wait( 0.5 );
		check_debug_mix_dvar();
	}
}
#/

/#
check_debug_mix_dvar()
{
	SetDvarIfUninitialized( "debug_mix", "0" );

	if ( !IsDefined( level._audio ) && !IsDefined( level._audio.mix ) && !IsDefined( level._audio.mix.curr_preset ) )
		return;

	dvar = GetDvar( "debug_mix" );

	if ( dvar != "0" && dvar != level._audio.mix.curr_preset )
		MM_start_preset( dvar, 0.5 );
}
#/	
