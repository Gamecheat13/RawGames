#include soundscripts\_snd;
#include soundscripts\_snd_filters;

ONE_FRAME = 0.05;
COMMON_TIMESCALE_FILE_NAME = "soundtables/common_timescale.csv";

snd_timescale_init()
{
	assert( IsDefined( level._snd ) );
	snd_load_timescale_presets();
	snd_set_current_timescale_preset_name( "" );
}

snd_set_current_timescale_preset_name( preset_name )
{
	assert( IsDefined( level._snd.timescale ) );
	level._snd.timescale.current_preset_name = preset_name;
}

snd_get_current_timescale_preset_name()
{
	assert( IsDefined( level._snd.timescale.current_preset_name ) );
	return level._snd.timescale.current_preset_name;
}

snd_load_timescale_presets()
{	
	assert( snd_is_first_frame() );
	level._snd.timescale = SpawnStruct();

	sound_tables = [];
	sound_tables[sound_tables.size] = COMMON_TIMESCALE_FILE_NAME;

	level._snd.timescale.presets = snd_parse_soundtables( "Timescale", sound_tables, 3 );
}

/*
=============
///ScriptDocBegin
"Name: snd_set_timescale( <preset_name> )"
"Summary: Sets the timescale to the given preset_name defined in the common timescale soundtable."
"Module: Sound"
"CallOn: Nothing"
"MandatoryArg: <preset_name>: The name of the timescale preset to set."
"Example: snd_set_timescale( "none" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_set_timescale( preset_name )
{			
	assert( IsString( preset_name ) );
		
	preset = snd_get_timescale_preset( preset_name );
	
	if ( !IsDefined( preset ) )
	{
		PrintLn( "Timescale preset " + preset_name + " does not exist. " );
		return;
	}
	
	assert( preset.name == preset_name );
	
	if ( snd_get_current_timescale_preset_name() != preset_name )
	{
		thread snd_set_timescale_threaded( preset );		
	}
}

snd_get_timescale_preset( preset_name )
{
	if ( IsDefined( level._snd.timescale.presets ) && IsDefined( level._snd.timescale.presets[ preset_name ] ) )
		return level._snd.timescale.presets[ preset_name ];	
	return undefined;
}

snd_set_timescale_threaded( preset )
{
	assert ( IsArray( preset.settings ) );
	
	throttler = snd_get_throttler();
	
	foreach ( s in preset.settings )
	{
		bus_name = s[ "dsp_bus_name" ];
		
		if ( bus_name == "all" )
		{
			dsp_buses = snd_get_dsp_buses();
			foreach( dsp_bus in dsp_buses )
			{
				SoundSetTimeScaleFactor( dsp_bus, s[ "scalefactor" ] );
				throttler snd_throttle_wait();
			}
			break;
		}
		else
		{
			assert( snd_is_dsp_bus( bus_name ) );
			SoundSetTimeScaleFactor( bus_name, s[ "scalefactor" ] );
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: snd_set_timescale_all( <value> )"
"Summary: Sets the timescale of all dsp buses to the given value."
"Module: Sound"
"CallOn: Nothing"
"MandatoryArg: <value>: The timescale value to set all the dsp buses to."
"Example: snd_set_timescale_all( 0.0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_set_timescale_all( value )
{
	assert( IsDefined( value ) && value >= 0.0 );
	thread snd_set_timescale_all_threaded( value );
}

snd_set_timescale_all_threaded( value )
{
	throttler = snd_get_throttler();
	dsp_buses = snd_get_dsp_buses();
	foreach( dsp_bus in dsp_buses )
	{
		SoundSetTimeScaleFactor( dsp_bus, value );
		throttler snd_throttle_wait();
	}	
}

/*
=============
///ScriptDocBegin
"Name: snd_set_timescale_array_to_value( <dsp_bus_name_array> , <value> )"
"Summary: Sets the timescale of the given array of dsp buses to the given value."
"Module: Sound"
"CallOn: Nothing"
"MandatoryArg: <dsp_bus_name_array>: An array of dsp buses"
"MandatoryArg: <value>: The value of timescale to set the given array of dsp buses"
"Example: snd_set_timescale_array_to_value( ["physics", "voices", "weapons" ], 0.2 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_set_timescale_array_to_value( dsp_bus_name_array, value )
{
	assert( IsArray( dsp_bus_name_array ) );
	assert( IsDefined( value ) && value >= 0.0 );
	thread snd_set_timescale_array_to_value_threaded( dsp_bus_name_array, value );
}

snd_set_timescale_array_to_value_threaded( dsp_bus_name_array, value )
{
	throttler = snd_get_throttler();
	foreach( dsp_bus in dsp_bus_name_array )
	{
		assert( snd_is_dsp_bus( dsp_bus ) );
		SoundSetTimeScaleFactor( dsp_bus, value );
		throttler snd_throttle_wait();
	}	
}