#include maps\_utility;

loadPresets()
{
	// add your own preset eq filters here
	// should be used for commonly used, generic filters
	// see _ambient.gsc for defining specialized filters
	
	// sample test eq filters
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// up to three bands( 0, 1, 2 ) for a filter
	// filter types are: lowshelf, highshelf, bell, lowpass, highpass
	// freq ranges from 20 Hz to 20 kHz
	// gain has no code restricted range, but should probably be between + / - 18 dB
	// q must be > 0 and has no code restricted max
	
	// example of a three band filter
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// defineFilter( "test", 0, "lowshelf", 3000, 6, 2 );
	// defineFilter( "test", 1, "highshelf", 3000, -12, 2 );
	// defineFilter( "test", 2, "bell", 1500, 6, 3 );
	
	// example of a single band filter
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// defineFilter( "single", 0, "highpass", 10000, 1, 1 );
	
	level.eq_defs = [];
	level.ambient_reverb = [];

	define_reverb( "exterior" );
	set_reverb_roomtype( "exterior", 		"alley" );
	set_reverb_drylevel( "exterior", 		0.9 );
	set_reverb_wetlevel( "exterior", 		0.01 );
	set_reverb_fadetime( "exterior", 		2 );
	set_reverb_priority( "exterior", 		"snd_enveffectsprio_level" );

	define_reverb( "exterior1" );
	set_reverb_roomtype( "exterior1", 		"alley" );
	set_reverb_drylevel( "exterior1", 		0.9 );
	set_reverb_wetlevel( "exterior1", 		0.3 );
	set_reverb_fadetime( "exterior1", 		2 );
	set_reverb_priority( "exterior1", 		"snd_enveffectsprio_level" );

	define_reverb( "interior_stone" );
	set_reverb_roomtype( "interior_stone", 	"stoneroom" );
	set_reverb_drylevel( "interior_stone", 	0.9 );
	set_reverb_wetlevel( "interior_stone", 	0.4 );
	set_reverb_fadetime( "interior_stone", 	2 );
	set_reverb_priority( "interior_stone", 	"snd_enveffectsprio_level" );
	
	if ( mission( "bog_a" ) )
	{
		// bog_a aint as wet?
		set_reverb_wetlevel( "interior_stone", 	0.3 );
	}

	define_filter( "interior_stone" );
	set_filter_type( "interior_stone", 0, 	"highshelf" );
	set_filter_freq( "interior_stone", 0, 	3500 );
	set_filter_gain( "interior_stone", 0, 	-6 );
	set_filter_q( "interior_stone", 0, 		1 );
	add_channel_to_filter( "interior_stone", "ambient" );
	add_channel_to_filter( "interior_stone", "element" );
	add_channel_to_filter( "interior_stone", "vehicle" );
	add_channel_to_filter( "interior_stone", "weapon" );
	add_channel_to_filter( "interior_stone", "voice" );

	define_filter( "shanty" );
	set_filter_type( "shanty", 0, 			"highshelf" );
	set_filter_freq( "shanty", 0, 			3500 );
	set_filter_gain( "shanty", 0, 			-2 );
	set_filter_q( "shanty", 0, 				1 );
	add_channel_to_filter( "shanty", 		"ambient" );
	add_channel_to_filter( "shanty", 		"element" );
	add_channel_to_filter( "shanty", 		"vehicle" );

	define_filter( "underpass" );
	set_filter_type( "underpass", 0, 		"highshelf" );
	set_filter_freq( "underpass", 0, 		3500 );
	set_filter_gain( "underpass", 0, 		-2 );
	set_filter_q( "underpass", 0, 			1 );
	add_channel_to_filter( "underpass", 	"ambient" );
	add_channel_to_filter( "underpass", 	"element" );
	add_channel_to_filter( "underpass", 	"vehicle" );


}

 /* 
 ============= 
///ScriptDocBegin
"Name: define_filter( <name> )"
"Summary: Creates a new filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"Example: define_filter( "interior_stone" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
define_filter( name )
{
	assertex( !isdefined( level.eq_defs[ name ] ), "Filter " + name + " is already defined" );
	level.eq_defs[ name ] = [];
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_type( <name> , <band> , <type> )"
"Summary: Sets the type for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <type> : The filter type "
"Example: set_filter_type( "underpass", 0, "highshelf" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_type( name, band, type )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "type" ][ band ] = type;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_freq( <name> , <band> , <freq> )"
"Summary: Sets the freq for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <freq> : The filter freq "
"Example: set_filter_freq( "underpass", 0, 3500 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_freq( name, band, freq )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "freq" ][ band ] = freq;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_gain( <name> , <band> , <gain> )"
"Summary: Sets the gain for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <gain> : The filter gain "
"Example: set_filter_gain( "underpass", 0, -2 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_gain( name, band, gain )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "gain" ][ band ] = gain;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_q( <name> , <band> , <q> )"
"Summary: Sets the q for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <q> : The filter q "
"Example: set_filter_q( "underpass", 0, 1 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_q( name, band, q )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "q" ][ band ] = q;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: define_reverb( <name> )"
"Summary: Creates a new reverb setting"
"Module: Ambience"
"MandatoryArg: <name> : The name of the reverb."
"Example: define_reverb( "interior_stone" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
define_reverb( name )
{
	assertex( !isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is already defined" );
	level.ambient_reverb[ name ] = [];
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_roomtype( <name> , <roomtype> )"
"Summary: Sets the roomtype for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The roomtype."
"Example: set_reverb_roomtype( "interior_stone", "stoneroom" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_roomtype( name, roomtype )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "roomtype" ] = roomtype;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_drylevel( <name> , <drylevel> )"
"Summary: Sets the drylevel for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The drylevel."
"Example: set_reverb_drylevel( "interior_stone", 0.6 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_drylevel( name, drylevel )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "drylevel" ] = drylevel;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_wetlevel( <name> , <wetlevel> )"
"Summary: Sets the roomtype for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The wetlevel."
"Example: set_reverb_wetlevel( "interior_stone", 0.3 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_wetlevel( name, wetlevel )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "wetlevel" ] = wetlevel;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_fadetime( <name> , <fadetime> )"
"Summary: Sets the fadetime for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The fadetime."
"Example: set_reverb_fadetime( "interior_stone", 2 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_fadetime( name, fadetime )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "fadetime" ] = fadetime;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_priority( <name> , <priority> )"
"Summary: Sets the priority for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The priority."
"Example: set_reverb_priority( "interior_stone", "snd_enveffectsprio_level" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_priority( name, priority )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "priority" ] = priority;
}

getFilter( name )
{
	if ( isDefined( name ) && isDefined( level.eq_defs ) && isDefined( level.eq_defs[ name ] ) )
		return level.eq_defs[ name ];
	else 
		return undefined;
}

/*
=============
///ScriptDocBegin
"Name: add_channel_to_filter( <track> , <channel> )"
"Summary: Makes a filter effect a sound channel."
"Module: Ambience"
"MandatoryArg: <track>: The filter. "
"MandatoryArg: <channel>: The channel to add. "
"Example: add_channel_to_filter( "interior_stone", "ambient" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
add_channel_to_filter( track, channel )
{
	if( !isDefined( level.ambient_eq[ track ] ) )
		level.ambient_eq[ track ] = [];

	level.ambient_eq[ track ][ channel ] = track;
}
