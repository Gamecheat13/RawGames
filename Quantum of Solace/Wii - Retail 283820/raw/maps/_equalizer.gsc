#include maps\_utility;

loadPresets()
{

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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