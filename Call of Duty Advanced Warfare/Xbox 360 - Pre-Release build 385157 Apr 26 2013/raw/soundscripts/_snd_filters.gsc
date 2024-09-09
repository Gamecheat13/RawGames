#include soundscripts\_snd;
#include soundscripts\_snd_hud;
#include soundscripts\_audio;
#include soundscripts\_audio_zone_manager;

//////////////////////////////////////////////////////////////////////////////
// DSP-RELATED SCRIPT UTILITIES
//////////////////////////////////////////////////////////////////////////////
 
// CONSTANTS
DSP_BUS_FILE_NAME = "sounddata/dspbuses.csv";
COMMON_FILTER_FILE_NAME = "soundtables/common_filter.csv";
COMMON_OCCLUSION_FILE_NAME = "soundtables/common_occlusion.csv";


snd_filters_init()
{
	assert( IsDefined( level._snd ) );

	snd_enable_zone_filters();
	
	snd_init_current_filters();
	snd_init_current_occlusion();

	snd_load_filter_presets();
	snd_load_occlusion_presets();	
}

snd_set_filter_lerp( lerp )
{
	assert( IsDefined( level._snd.current_filters ) );
	assert( IsDefined( level._snd.current_filters.lerp ) );
	assert( IsDefined( lerp ) );
	assert( lerp >= 0.0 && lerp <= 1.0 );
	
	level._snd.current_filters.lerp = lerp;
	level.player SetEqLerp( lerp, 0 );
}

snd_get_current_filter_lerp()
{
	assert( IsDefined( level._snd.current_filters ) );
	assert( IsDefined( level._snd.current_filters.lerp ) );
	return level._snd.current_filters.lerp;
}

snd_init_current_filters()
{
	assert( snd_is_first_frame() );
	current_filters = SpawnStruct();
	current_filters.names = [];
	current_filters.names[ 0 ] = "";
	current_filters.names[ 1 ] = "";
	current_filters.lerp = 0;
	
	level._snd.current_filters = current_filters;	
}

snd_get_current_filter_name( index )
{
	assert( IsDefined( level._snd.current_filters ) );
	assert( index == 0 || index == 1 );
	return level._snd.current_filters.names[ index ];
}

snd_set_current_filter_name( index, preset_name )
{
	assert( IsDefined( level._snd.current_filters ) );
	assert( index == 0 || index == 1 );
	level._snd.current_filters.names[ index ] = preset_name;
}

snd_init_current_occlusion()
{
	current_occlusion = SpawnStruct();
	current_occlusion.name = "";
	level._snd.current_occlusion = current_occlusion;
	
	snd_set_current_occlusion_name( "" );
}

snd_get_current_occlusion_name()
{
	assert( IsDefined( level._snd.current_occlusion ) );
	return level._snd.current_occlusion.name;
}

snd_set_current_occlusion_name( preset_name )
{
	assert( IsDefined( level._snd.current_occlusion ) );
	level._snd.current_occlusion.name = preset_name;
}

//////////////////////////////////////////////////////////////////////////////
// DSP-BUS API
//////////////////////////////////////////////////////////////////////////////

// Loads the sounddata/dspbuses.csv file, which defines the possible dsp buses
snd_load_dsp_buses()
{
	assert( IsDefined( level._snd ) );
	assert( snd_is_first_frame() );
			
	dsp_buses = snd_parse_soundtables( "DSP bus", [ DSP_BUS_FILE_NAME ], 2 );

	if ( IsDefined( dsp_buses ) )
		level._snd.dsp_buses = dsp_buses;
	else
		level._snd.dsp_buses = [];
}

snd_get_dsp_buses()
{	
	bus_names = [];
	foreach(dsp_bus in level._snd.dsp_buses)
	{
		bus_names[bus_names.size] = dsp_bus.name;
	}
	return bus_names;
}

snd_is_dsp_bus( dsp_bus_name )
{
	return IsDefined( level._snd.dsp_buses[ dsp_bus_name ] );
}

snd_get_dsp_filename()
{
	return DSP_BUS_FILE_NAME;
}

//////////////////////////////////////////////////////////////////////////////
// FILTER API
//////////////////////////////////////////////////////////////////////////////

snd_load_filter_presets()
{	
	assert( snd_is_first_frame() );
	level._snd.filters = SpawnStruct();

	sound_tables = [];
	sound_tables[sound_tables.size] = COMMON_FILTER_FILE_NAME;
	sound_tables[sound_tables.size] = "soundtables/" + snd_get_soundtable_name() + "_filter.csv";

	level._snd.filters.presets = snd_parse_soundtables( "Filter", sound_tables, 7 );
}


/*
=============
///ScriptDocBegin
"Name: snd_set_filter( <preset_name> , <index_> , <set_hud_> )"
"Summary: Sets the current filters state to the given filter preset. Note that for a given dsp_bus, an occlusion and filter setting are not currently supported."
"Module: Sound"
"CallOn: nothing"
"MandatoryArg: <preset_name>: name of the preset"
"OptionalArg: <index_>: index of the filter to set this preset on. Defaults to 0."
"OptionalArg: <set_hud_>: whether or not to update the hud with this command, used for internal utility functions."
"Example: snd_set_filter( "outside", 0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_set_filter( preset_name, index_, set_hud_ )
{			
	if ( !snd_is_filters_enabled() )
		return;

	// red flashing overwrites eq
	if ( IsDefined( level.player.ent_flag ) && IsDefined( level.player.ent_flag[ "player_has_red_flashing_overlay" ] ) && level.player maps\_utility::ent_flag( "player_has_red_flashing_overlay" ) )
		return;
	
	index = 0;
	if (IsDefined(index_))
		index = index_;

	assert( index == 0 || index == 1 );

	if ( !IsDefined( preset_name ) || ( IsDefined( preset_name ) && preset_name == "" ) )
	{
		snd_set_current_filter_name( index, "" );
		level.player Deactivateeq( index ); 
		return;
	}
	
	assert( IsString( preset_name ) );
		
	preset = snd_get_filter_preset( preset_name );
	
	if ( !IsDefined( preset ) )
	{
		PrintLn( "Filter preset " + preset_name + " does not exist. " );
		return;
	}
	
	assert( preset.name == preset_name );
	
	if ( snd_get_current_filter_name( index ) != preset_name )
	{
		snd_set_current_filter_name( index, preset_name );
	
		thread snd_set_filter_threaded( index, preset );

		/#
		set_hud = true;
		if ( IsDefined( set_hud_ ) )
			set_hud = set_hud_;
	
		if ( set_hud )
		{
			set_filter_hud( preset_name );
		}
		#/	
	}
}


sndx_fade_in_filter_lerp( fade_time )
{
	currentLerp = 0.0;
	lerpPerFrame = 0.05 / fade_time; 
	while ( currentLerp < 1.0 )
	{
		snd_set_filter_lerp( currentLerp );
		currentLerp += lerpPerFrame;
		wait (0.05);
	}
}


/*
=============
///ScriptDocBegin
"Name: snd_fade_in_filter( <preset_name> , <fade_time> )"
"Summary: fades in the given filter preset on index 0 over the fade time"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <preset_name>: filter preset defined in the filter preset file"
"MandatoryArg: <fade_time>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_fade_in_filter( preset_name, fade_time )
{
	// set lerp to be 100% on index 1, i.e. no filter heard
	snd_set_filter_lerp( 0 );
	
	// clear the old filters if there were any
	snd_clear_filter( 0 );
	snd_clear_filter( 1 );
	
	// set up the new filter on index 0 (by default)
	snd_set_filter( preset_name );
	
	// call a thread which does the shitty insta-lerp call to 1.0 because engine doesn't do it for you
	thread sndx_fade_in_filter_lerp( fade_time );
}


sndx_fade_out_filter_lerp( fade_time )
{
	currentLerp = snd_get_current_filter_lerp();
	assert( currentLerp >= 0.0 && currentLerp <= 1.0);

	lerpPerFrame = currentLerp * (0.05 / fade_time);
	while ( currentLerp > 0.0 )
	{
		snd_set_filter_lerp( currentLerp );
		currentLerp -= lerpPerFrame;
		wait (0.05);
	}	
}

/*
=============
///ScriptDocBegin
"Name: snd_fade_out_filter( <fade_time> )"
"Summary: fades out the current filter on index 0"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <fade_time>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

snd_fade_out_filter( fade_time )
{	
	thread sndx_fade_out_filter_lerp( fade_time );
}


snd_get_filter_preset( preset_name )
{
	if ( IsDefined( level._snd.filters.presets[ preset_name ] ) )
		return level._snd.filters.presets[ preset_name ];	
	return undefined;
}

sndx_get_dsp_filter_setting( index, dsp_bus, s )
{
	setting = spawnstruct();
	setting.dsp_bus = dsp_bus;
	setting.index = index;
	setting.band = int(s["band"]);
	setting.type = s["type"];
	setting.gain = s["gain"];
	setting.freq = s["freq"];
	setting.q = s["q"];	
	
	return setting;
}

snd_set_filter_threaded( index, preset )
{
	assert( IsArray( preset.settings ) );
	
	throttler = snd_get_throttler();
	
	settings = [];
	
	foreach ( s in preset.settings )
	{
		bus_name = s[ "dsp_bus_name" ];
		
		if ( bus_name == "all" || bus_name == "set_all" )
		{
			dsp_buses = snd_get_dsp_buses();
			foreach( dsp_bus in dsp_buses )
			{
				settings[dsp_bus] = sndx_get_dsp_filter_setting( index, dsp_bus, s );
			}
		}
		else
		{
			if ( snd_is_dsp_bus( bus_name ) )
			{
				settings[bus_name] = sndx_get_dsp_filter_setting( index, bus_name, s );
			}
			else
			{
				PrintLn( "Error: dsp_bus_name \"" + bus_name + "\" is not in " + DSP_BUS_FILE_NAME );
			}
		}		
	}	
	
	foreach ( setting in settings )
	{
		level.player SetEq( setting.dsp_bus, setting.index, setting.band, setting.type, setting.gain, setting.freq, setting.q );
		throttler snd_throttle_wait();
	}
}

snd_clear_filter(index_)
{
	index = 0;
	if ( IsDefined(index_) )
	{
		assert( index_ == 0 || index_ == 1 );
		index = index_;
	}
	
	snd_set_filter(undefined, index);
}

snd_enable_filters()
{
	level._snd.filters.is_enabled = true;	
}

snd_disable_filters()
{
	level._snd.filters.is_enabled = undefined;
}

snd_is_filters_enabled()
{
	return IsDefined( level._snd.filters.is_enabled );
}

snd_disable_zone_filter_setting()
{
	level._snd.filters.is_zone_enabled = undefined;
}

snd_enable_zone_filter_setting()
{
	level._snd.filters.is_zone_enabled = true;
}

snd_is_zone_filter_setting_enabled()
{
	return IsDefined( level._snd.filters.is_zone_enabled );
}


//////////////////////////////////////////////////////////////////////////////
// OCCLUSION API
//////////////////////////////////////////////////////////////////////////////

snd_load_occlusion_presets()
{
	assert( snd_is_first_frame() );
	level._snd.occlusion = SpawnStruct();
	
	sound_tables = [];
	sound_tables[sound_tables.size] = COMMON_OCCLUSION_FILE_NAME;
	level._snd.occlusion.presets = snd_parse_soundtables( "Filter", sound_tables, 6 );	
}

/*
=============
///ScriptDocBegin
"Name: snd_set_occlusion( <preset_name> )"
"Summary: Sets the current occlusion state to the given preset name."
"Module: Sound"
"CallOn: Nothing"
"MandatoryArg: <preset_name>: The preset name of the occlusion defined in an occlusion soundtable."
"Example: snd_set_occlusion( "medium" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_set_occlusion( preset_name )
{
	assert( IsString( preset_name ) );
	
	/#
	if ( snd_stringtables_disabled() ) return;
	#/
	
	if ( !snd_is_occlusion_enabled() )
		return;
	
	// red flashing overwrites eq
	if ( IsDefined(level.player.ent_flag) && IsDefined( level.player.ent_flag[ "player_has_red_flashing_overlay" ] ) && level.player maps\_utility::ent_flag( "player_has_red_flashing_overlay" ) )
		return;
		
	if ( !IsDefined( preset_name ) )
	{
		snd_set_current_occlusion_name( "" );
		/#
		set_occlusion_hud( "" );
		#/
		return;
	}
	
	preset = snd_get_occlusion_preset( preset_name );
	
	if ( !IsDefined( preset ) )
	{
		PrintLn( "Occlusion preset " + preset_name + " does not exist. " );
		return;
	}

	/#
	// Occlusion is still "tracking" but disabled
	if ( !snd_get_zone_filters_enabled() )
		set_occlusion_hud( preset_name +" (disabled)" );
	else
		set_occlusion_hud( preset_name );
	#/	
	
	assert( preset.name == preset_name );
	
	if ( snd_get_current_occlusion_name() != preset_name )
	{
		snd_set_current_occlusion_name( preset_name );
	
		thread snd_set_occlusion_threaded( preset.settings );

		/#
		set_filter_hud( preset_name );
		#/
	}
}

snd_get_occlusion_preset( preset_name )
{
	if ( IsDefined( level._snd.occlusion.presets[ preset_name ] ) )
		return level._snd.occlusion.presets[ preset_name ];	
	return undefined;
}

snd_set_occlusion_threaded( settings )
{
	// if zone filtering/occlusion is not disabled, set the occlusion
	if ( snd_get_zone_filters_enabled() )
	{
		throttler = snd_get_throttler();
		
		foreach ( s in settings )
		{			
			bus_name = s[ "dsp_bus_name" ];
			if ( bus_name == "all" )
			{
				dsp_buses = snd_get_dsp_buses();
				foreach( dsp_bus in dsp_buses )
				{
					level.player SetOcclusion(dsp_bus, s[ "freq" ], s[ "type" ], s[ "gain" ], s[ "q" ] );
					throttler snd_throttle_wait();
				}
				break;
			}
			else
			{
				if ( snd_is_dsp_bus( bus_name ) )
					level.player SetOcclusion( bus_name, s[ "freq" ], s[ "type" ],  s[ "gain" ], s[ "q" ] );
				else
					PrintLn( "Error: SetOcclusion: dsp_bus_name \"" + bus_name + "\" is not in " + DSP_BUS_FILE_NAME );
				throttler snd_throttle_wait();
			}
		}				
	}	
}

snd_enable_occlusion()
{
	level._snd.occlusion.is_enabled = true;	
}

snd_disable_occlusion_threaded()
{
	snd_throttler = snd_get_throttler();	
	dsp_buses = snd_get_dsp_buses();

	foreach( dsp_bus in dsp_buses )
	{
		level.player DeactivateOcclusion( dsp_bus );
		snd_throttler snd_throttle_wait();
	}		
}

snd_disable_occlusion()
{
	level._snd.occlusion.is_enabled = false;
	thread snd_disable_occlusion_threaded();
}

snd_is_occlusion_enabled()
{
	if ( IsDefined( level._snd.occlusion.is_enabled ) )
	{
		return level._snd.occlusion.is_enabled;
	}
	return true;
}

//////////////////////////////////////////////////////////////////////////////
// AUDIO ZONES AND FILTERING API
//////////////////////////////////////////////////////////////////////////////

snd_disable_zone_filters()
{
	level._snd.zone_filters_enabled = undefined;
}

snd_enable_zone_filters()
{
	level._snd.zone_filters_enabled = true;
}

snd_get_zone_filters_enabled()
{
	return IsDefined( level._snd.zone_filters_enabled );
}

// This is what we use to stop zone filtering/occlusion from being processed & applied
// however, internal zone changes are still maintained so we know what filter/occlusion settings to "restore" to
snd_disable_zone_occlusion_and_filtering()
{
	snd_set_filter( undefined, 0 );
	snd_set_filter( undefined, 1 );
	snd_disable_occlusion();	
	snd_disable_zone_filters();
	
	/#
	// Occlusion is still "tracking" but disabled
	if ( !snd_get_zone_filters_enabled() )
		set_occlusion_hud( snd_get_current_occlusion_name() + " (disabled)" );
	#/	
}

// Re-enables zone filtering/occlusion if it was previously disabled
// it will restore current_occlusion since internal zone changes have been maintained
snd_enable_zone_occlusion_and_filtering()
{
	filter_preset_name = undefined;
	occlusion_preset_name = "default";

	if ( IsDefined( level._audio.zone_mgr.current_zone ) && IsDefined ( level._audio.zone_mgr.zones[ level._audio.zone_mgr.current_zone ] ) )
	{
		current_zone = AZM_get_current_zone();
		zone = level._audio.zone_mgr.zones[ current_zone ];
		
		// grab the zone filter and occlusion settings, which may or may not have values...
		if ( IsDefined( zone["occlusion"] ) && zone[ "occlusion" ] != "none" )
			occlusion_preset_name = zone[ "occlusion" ];

		if ( IsDefined( zone[ "filter" ] ) && zone[ "filter" ] != "none" )
			filter_preset_name = zone[ "filter" ];
	}
	
	if ( snd_get_current_occlusion_name() != occlusion_preset_name )
		occlusion_preset_name = snd_get_current_occlusion_name();
	
	snd_enable_zone_filters();	
	snd_set_filter( filter_preset_name, 0 );
	snd_set_filter( undefined, 1 );
	snd_set_occlusion( occlusion_preset_name );
}

