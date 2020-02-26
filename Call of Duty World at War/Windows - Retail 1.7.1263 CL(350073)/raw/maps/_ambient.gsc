
//!!!none of this does anything on code side

// Cleaned up by: MikeD (3/28/2007)

// SCRIPTER_MOD
// JesseS( 3/21/2007 ): for this one, I did a mass replace of level.player with players[0], since
// this one needs a major overhaul for coop. Also, some isplayer checks added, and other passed into
// functions to play FX off of.
// TODO: FIX THIS UP FOR CO-OP! <-------------------------------------------------------------------LOOK HERE!

/*			Example map_amb.gsc file:
main()
{
	// Set the underlying ambient track
	level.ambient_track [ "exterior" ] = "ambient_test";
	thread maps\_utility::set_ambient( "exterior" );

	// Set the eq filter for the ambient channels
	// -------------------------------------------	
	//   define a filter and give it a name
	//   or use one of the presets( see _equalizer.gsc )
	//   arguments are: name, band, type, freq, gain, q
	// -------------------------------------------
	// maps\_equalizer::defineFilter( "test", 0, "lowshelf", 3000, 6, 2 );
	// maps\_equalizer::defineFilter( "test", 1, "highshelf", 3000, -12, 2 );
	// maps\_equalizer::defineFilter( "test", 2, "bell", 1500, 6, 3 );
	
	// attach the filter to a region and channel
	// --------------------------------------------
	setupEq( "exterior", "local", "test" );
	
		
	ambientDelay( "exterior", 1.3, 3.4 ); // Trackname, min and max delay between ambient events
	ambientEvent( "exterior", "burnville_foley_13b", 			 0.3 );
	ambientEvent( "exterior", "boat_sink", 					 0.6 );
	ambientEvent( "exterior", "bullet_large_canvas", 			 0.3 );
	ambientEvent( "exterior", "explo_boat", 					 1.3 );
	ambientEvent( "exterior", "Stuka_hit", 					 0.1 );
	
	ambientEventStart( "exterior" );
}
*/

// This initializes the zones used throughout the level.
init()
{
}

/*
==============
///GSCDocBegin
"Name: activateambient( <ambient> )"
"Summary: Activates the given ambient, usually "interior" or "exterior" This is mainly used by other utility scripts."
"CallOn: Anything"
"ScriptFile: _ambient.gsc"
"MandatoryArg: <ambient> (string) - Determines the ambient to use. Usually "exterior" or "interior""
"Example: activateambient( "interior" );"
"Example: maps\_ambient::activateambient( "exterior" );"
"LEVELVAR: level.ambient - Sets the current ambient track to use."
"LEVELVAR: level.ambient_modifier - An array that stores ambient tracks."
"LEVELVAR: level.ambient_track - Predefined array of ambient tracks."
"SPCOOP: both"
///GSCDocEnd
==============
*/
activateambient( ambient )
{
}

// Sets the ambiencts provided by a trigger. Which is threaded from _load.gsc
// self = trigger with a targetname of "ambient_volume"
ambientvolume()
{
}

ambientdelay( track, min, max )
{
}

ambientEvent( track, name, weight )
{
}

ambientReverb( type )
{
}



setupEq( track, channel, filter )
{
}


setup_eq_channels( track, eqIndex )
{
}

deactivate_index( eqIndex )
{
}

ambientEventStart( track )
{
}

start_ambient_event( track )
{
}

ambientWeight( track )
{
}		
	

add_zone( zone )
{
}

check_ambience( type )
{
}

ambient_trigger()
{
}

get_progress( start, end, dist, org )
{
}


ambient_end_trigger_think( start, end, dist, inner_ambience, outer_ambience )
{
}

ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience, other )
{
}

set_ambience_blend( progress, inner_ambience, outer_ambience )
{
}

set_ambience_single( ambience )
{
}