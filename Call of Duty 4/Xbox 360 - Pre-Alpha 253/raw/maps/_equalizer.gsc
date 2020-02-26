#include maps\_utility;

loadPresets()
{

	// add your own preset eq filters here
	// should be used for commonly used, generic filters
	// see _ambient.gsc for defining specialized filters
	
	// sample test eq filters
	// ------------------------------------
	// up to three bands (0,1,2) for a filter
	// filter types are: lowshelf, highshelf, bell, lowpass, highpass
	// freq ranges from 20 Hz to 20 kHz
	// gain has no code restricted range, but should probably be between +/- 18 dB
	// q must be > 0 and has no code restricted max
	
	// example of a three band filter
	// --------------------------------
	// defineFilter( "test", 0, "lowshelf", 3000, 6, 2 );
	// defineFilter( "test", 1, "highshelf", 3000, -12, 2 );
	// defineFilter( "test", 2, "bell", 1500, 6, 3 );
	
	// example of a single band filter
	// --------------------------------
	// defineFilter( "single", 0, "highpass", 10000, 1, 1 );
}


defineFilter ( name, band, type, freq, gain, q )
{
	assert( band >= 0 && band < 3 );
	if ( !isDefined( level.eq_defs ) )
		level.eq_defs = [];
	
	if ( !isDefined( level.eq_defs[ name ] ) )
		level.eq_defs[ name ] = [];
	
	level.eq_defs[ name ][ "type" ][band] = type;
	level.eq_defs[ name ][ "freq" ][band] = freq;
	level.eq_defs[ name ][ "gain" ][band] = gain;
	level.eq_defs[ name ][ "q" ][band] = q;
}


getFilter ( name )
{
	if ( isDefined( name ) && isDefined( level.eq_defs ) && isDefined( level.eq_defs[name] ) )
		return level.eq_defs[ name ];
	else 
		return undefined;
}