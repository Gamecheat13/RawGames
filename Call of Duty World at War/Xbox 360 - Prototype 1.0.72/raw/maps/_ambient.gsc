#include maps\_utility; 
#include maps\_equalizer; 
#include common_scripts\utility; 

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
	level.ambient_track["exterior"] = "ambient_test"; 
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
	level.ambient_zones = []; 

	// Add these to the level.ambient_zone, and set them to true.
	add_zone( "interior_metal" ); 
	add_zone( "interior_stone" ); 
	add_zone( "interior_vehicle" ); 
	add_zone( "interior_wood" ); 
	add_zone( "alley" ); 
	add_zone( "hangar" ); 
	add_zone( "bunker" ); 
	add_zone( "shanty" ); 
	add_zone( "underpass" ); 
	add_zone( "pipe" ); 
	add_zone( "tunnel" ); 
	
	if( !IsDefined( level.ambient_reverb ) )
	{
		level.ambient_reverb = []; 
	}

	if( !IsDefined( level.ambient_eq ) )
	{
		level.ambient_eq = []; 
	}
	
	if( !IsDefined( level.fxfireloopmod ) )
	{
		level.fxfireloopmod = 1; 
        }

	level.eq_main_track = 0;
	level.eq_mix_track = 1;
	level.eq_track[ level.eq_main_track ] = "";
	level.eq_track[ level.eq_mix_track ] = "";

	// used to change the meaning of interior/exterior/rain ambience midlevel.
	level.ambient_modifier["interior"] = ""; 
	level.ambient_modifier["exterior"] = ""; 
	level.ambient_modifier["rain"] = ""; 

	// loads any predefined filters in _equalizer.gsc
	loadPresets(); 
	
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
	level.ambient = ambient; 

	if( level.ambient == "exterior" )
	{
		ambient += level.ambient_modifier["exterior"]; 
	}
	if( level.ambient == "interior" )
	{
		ambient += level.ambient_modifier["interior"]; 
	}
		
	assert( IsDefined( level.ambient_track ) && IsDefined( level.ambient_track[ambient] ) ); 
	AmbientPlay( level.ambient_track[ambient + level.ambient_modifier["rain"]], 1 ); 
	thread ambientEventStart( ambient + level.ambient_modifier["rain"] ); 
	println( "Ambience becomes: ", ambient + level.ambient_modifier["rain"] ); 
}

// Sets the ambiencts provided by a trigger. Which is threaded from _load.gsc
// self = trigger with a targetname of "ambient_volume"
ambientvolume()
{
	for( ;; )
	{
		players = get_players(); 
		self waittill( "trigger" ); 
		activateAmbient( "interior" ); 
		while( players[0] IsTouching( self ) )
		{
			wait( 0.1 ); 		
		}
		activateAmbient( "exterior" ); 
	}
}

ambientdelay( track, min, max )
{
	assertex( max > min, "Ambient max must be greater than min for track " + track ); 
	if( !IsDefined( level.ambientEventEnt ) )
	{
		level.ambientEventEnt[track] = SpawnStruct(); 
	}
	else if( !IsDefined( level.ambientEventEnt[track] ) )
	{
		level.ambientEventEnt[track] = SpawnStruct(); 
	}
	
	level.ambientEventEnt[track].min = min; 
	level.ambientEventEnt[track].range = max - min; 
}

ambientEvent( track, name, weight )
{
	assertex( IsDefined( level.ambientEventEnt ), "ambientDelay has not been run" ); 
	assertex( IsDefined( level.ambientEventEnt[track] ), "ambientDelay has not been run" ); 

	if( !IsDefined( level.ambientEventEnt[track].event_alias ) )
	{
		index = 0; 
	}
	else
	{
		index = level.ambientEventEnt[track].event_alias.size; 
	}

	level.ambientEventEnt[track].event_alias[index] = name; 
	level.ambientEventEnt[track].event_weight[index] = weight; 
}

ambientReverb( type )
{
	players = get_players(); 
	players[0] SetReverb( level.ambient_reverb[type]["priority"], level.ambient_reverb[type]["roomtype"], level.ambient_reverb[type]["drylevel"], level.ambient_reverb[type]["wetlevel"], level.ambient_reverb[type]["fadetime"] ); 
	level waittill( "new ambient event track" ); 
//	if( level.ambient != type )
		players[0] DeactivateReverb( level.ambient_reverb[type]["priority"], 2 ); 
}


add_channel_to_filter( track, channel )
{
	if( !isDefined( level.ambient_eq[ track ] ) )
        {
		level.ambient_eq[ track ] = [];
        }

	level.ambient_eq[ track ][ channel ] = track;
}

setupEq( track, channel, filter )
{
	if( !IsDefined( level.ambient_eq[track] ) )
	{
		level.ambient_eq[track] = []; 
	}
	
	level.ambient_eq[track][channel] = filter; 
}

/*
ambientEq( track )
{
	if( !isdefined( level.ambient_eq[ track ] ) )
		return;

	setup_eq_channels( track, level.eq_main_track );

	level waittill( "new ambient event track" );
	channels = getArrayKeys( level.ambient_eq[ track ] );
	for( i = 0; i < channels.size; i++ )
	{
		channel = channels[ i ];
		for( band = 0; band < 3; band++ )
		{
	players = get_players(); 
			players[0] deactivateeq( level.eqIndex, channel, band );
		}
	}
}
*/



setup_eq_channels( track, eqIndex )
{
	if ( !isdefined( level.ambient_eq[ track ] ) )
	{
		deactivate_index( eqIndex );
		return;
	}
	
	level.eq_track[ eqIndex ] = track;
	
	channels = getArrayKeys( level.ambient_eq[ track ] );
	for( i = 0; i < channels.size; i++ )
	{
		channel = channels[ i ];
		filter = getFilter( level.ambient_eq[ track ][ channel ] );
		if( !isdefined( filter ) )
                {
			continue;
                }
			
		for( band = 0; band < 3; band++ )
		{			
			if( isdefined( filter[ "type" ][ band ] ) )
                        {
				level.player seteq( channel, eqIndex, band, filter[ "type" ][ band ], filter[ "gain" ][ band ], filter[ "freq" ][ band ], filter[ "q" ][ band ] );
                        }
			else
                        {
				level.player deactivateeq( eqIndex, channel, band );
                        }
		}				
	}
}

deactivate_index( eqIndex )
{
	level.player deactivateeq( eqIndex );
}

ambientEventStart( track )
{
	set_ambience_single( track );
}

start_ambient_event( track )
{
	level notify( "new ambient event track" ); 
	level endon( "new ambient event track" ); 
	
	assertex( IsDefined( level.ambientEventEnt ), "ambientDelay has not been run" ); 
	assertex( IsDefined( level.ambientEventEnt[track] ), "ambientDelay has not been run" ); 
	
	players = get_players(); 
	
	if( !IsDefined( players[0].soundEnt ) )
	{
		players[0].soundEnt = Spawn( "script_origin", ( 0, 0, 0 ) ); 
		players[0].soundEnt.playingSound = false; 
	}
	else
	{
		if( players[0].soundEnt.playingSound )
		{
			players[0].soundEnt waittill( "sounddone" ); 
		}
	}	
	
	ent = players[0].soundEnt; 
	min = level.ambientEventEnt[track].min; 
	range = level.ambientEventEnt[track].range; 
	
	lastIndex = 0; 
	index = 0; 
	assertEX( level.ambientEventEnt[ track ].event_alias.size > 1, "Need more than one ambient event for track " + track );
	if( isdefined( level.ambient_reverb[ track ] ) )
		thread ambientReverb( track ); 

	for( ;; )
	{
		wait( min + RandomFloat( range ) ); 
		while( index == lastIndex )
		{
			index = ambientWeight( track ); 
		}
			
		lastIndex = index; 
		ent.origin = players[0].origin; 
		ent LinkTo( players[0] ); 
		ent PlaySound( level.ambientEventEnt[track].event_alias[index], "sounddone" ); 
		ent.playingSound = true; 
		ent waittill( "sounddone" ); 
		ent.playingSound = false; 
	}
}

ambientWeight( track )
{
	total_events = level.ambientEventEnt[track].event_alias.size; 
	idleanim = RandomInt( total_events ); 
	if( total_events > 1 )
	{
		weights = 0; 
		anim_weight = 0; 
		
		for( i = 0; i < total_events; i++ )
		{
			weights++; 
			anim_weight += level.ambientEventEnt[track].event_weight[i]; 
		}
		
		if( weights == total_events )
		{
			anim_play = RandomFloat( anim_weight ); 
			anim_weight	 = 0; 
			
			for( i = 0; i < total_events; i++ )
			{
				anim_weight += level.ambientEventEnt[track].event_weight[i]; 
				if( anim_play < anim_weight )
				{
					idleanim = i; 
					break; 
				}
			}
		}
	}
	
	return idleanim; 
}		
	

add_zone( zone )
{
	level.ambient_zones[zone] = true; 
}

check_ambience( type )
{
//	assertex( IsDefined( level.ambient_zones[type] ), "Ambience " + type + " is not a defined ambience zone" ); 
}

ambient_trigger()
{
	// get the ambience zones on this trigger
	tokens = strtok( self.ambient, " " );
	if( tokens.size == 1 )
	{
		// if this trigger only has one ambience then there is no lerping done
		ambience = tokens[ 0 ];
		for( ;; )
		{
			self waittill( "trigger", other );
			assertEx( other == level.player, "Non-player entity touched an ambient trigger." );
			set_ambience_single( ambience );
		}
	}

	assertEx( isdefined( self.target ), "Ambience trigger at " + self.origin + " has multiple ambient tracks but doesn't target a script origin." );
	ent = getent( self.target, "targetname" );

	start = ent.origin;
	end = undefined;
	
	if( isdefined( ent.target ) )
	{
		// if the origin targets a second origin, use it as the end point
		target_ent = getent( ent.target, "targetname" );
		end = target_ent.origin;
	}
	else
	{
		// otherwise double the difference between the target origin and start to get the endpoint
		end = start + vectorScale( self.origin - start, 2 );
	}

	dist = distance( start, end );
	
	assertEx( tokens.size == 2, "Ambience trigger at " + self.origin + " doesn't have 2 ambient zones set. Usage is \"ambient\" \"zone1 zone2\"" );

	inner_ambience = tokens[0];
	outer_ambience = tokens[1];
	
	/#
	check_ambience( inner_ambience );
	check_ambience( outer_ambience );
	#/

	for( ;; )
	{
		self waittill( "trigger", other );
		assertEx( IsPlayer( other ), "Non-player entity touched an ambient trigger." );

		progress = undefined;		
		while( IsDefined( other ) && other istouching( self ) )
		{
			progress = get_progress( start, end, dist, level.player.origin );
	
			if( progress < 0 )
                        {
				progress = 0;
                        }

			if( progress > 1 )
                        {
				progress = 1;
                        }
	
			set_ambience_blend( progress, inner_ambience, outer_ambience );
			wait( 0.05 );
		}

		// when you leave the trigger set it to whichever point it was closest too		
		if( progress > 0.5 )
                {
			progress = 1;
                }
		else
                {
			progress = 0;
                }

		set_ambience_blend( progress, inner_ambience, outer_ambience );
	}
}

get_progress( start, end, dist, org )
{
	normal = VectorNormalize( end - start ); 
	vec = org - start; 
	progress = VectorDot( vec, normal ); 
	progress = progress / dist; 
	return progress; 
}


ambient_end_trigger_think( start, end, dist, inner_ambience, outer_ambience )
{
	self endon( "death" ); 
	for( ;; )
	{
		self waittill( "trigger", other ); 
		assertex( IsPlayer( other ), "Non-player entity touched an ambient trigger." ); 
		ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience, other ); 
	}
}

ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience, other )
{
	level notify( "trigger_ambience_touched" ); 
	level endon( "trigger_ambience_touched" ); 
	
	for( ;; )
	{
		progress = get_progress( start, end, dist, other.origin ); 

		if( progress < 0 )
		{
			progress = 0; 
			
			set_ambience_single( inner_ambience );
			break; 
		}
		
		if( progress >= 1 )
		{
			set_ambience_single( outer_ambience );
			break; 
		}

		set_ambience_blend( progress, inner_ambience, outer_ambience );
		wait( 0.05 ); 
	}
}

set_ambience_blend( progress, inner_ambience, outer_ambience )
{
	if( level.eq_track[ level.eq_main_track ] != outer_ambience )
	{
		maps\_ambient::setup_eq_channels( outer_ambience, level.eq_main_track );
	}

	if( level.eq_track[ level.eq_mix_track ] != inner_ambience )
	{
		maps\_ambient::setup_eq_channels( inner_ambience, level.eq_mix_track );
	}
	
        players = get_players();
	players[0] seteqlerp( progress, level.eq_main_track );
	
	/#
	if( progress == 1 || progress == 0 )
	{
		level.nextmsg = 0; 
	}
		
	if( !IsDefined( level.nextmsg ) )
	{
		level.nextmsg = 0; 
	}
		
	if( GetTime() < level.nextmsg )
	{
		return; 
	}
	
	level.nextmsg = GetTime() + 200; 
	#/
//	println( progress + " " + outer_ambience + ", " +( 1 - progress ) + " " + inner_ambience ); 
}

set_ambience_single( ambience )
{
	if( isdefined( level.ambientEventEnt[ ambience ] ) )
	{
//		thread ambientEventStart( ambience );
		thread start_ambient_event( ambience );
	}
	
	if( level.eq_track[ level.eq_main_track ] != ambience )
	{
		maps\_ambient::setup_eq_channels( ambience, level.eq_main_track );
	}

        players = get_players();
	players[0] seteqlerp( 1, level.eq_main_track );
}