#include maps\_utility;
#include maps\_equalizer;
#include common_scripts\utility;

/*			Example map_amb.gsc file:
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_test";
	thread maps\_utility::set_ambient("exterior");

	// Set the eq filter for the ambient channels
	// -------------------------------------------	
	//   define a filter and give it a name
	//   or use one of the presets (see _equalizer.gsc)
	//   arguments are: name, band, type, freq, gain, q
	// -------------------------------------------
	// maps\_equalizer::defineFilter( "test", 0, "lowshelf", 3000, 6, 2 );
	// maps\_equalizer::defineFilter( "test", 1, "highshelf", 3000, -12, 2 );
	// maps\_equalizer::defineFilter( "test", 2, "bell", 1500, 6, 3 );
	
	// attach the filter to a region and channel
	// --------------------------------------------
	setupEq( "exterior", "local", "test" );
	
		
	ambientDelay("exterior", 1.3, 3.4); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "burnville_foley_13b",			 0.3);
	ambientEvent("exterior", "boat_sink",					 0.6);
	ambientEvent("exterior", "bullet_large_canvas",			 0.3);
	ambientEvent("exterior", "explo_boat",					 1.3);
	ambientEvent("exterior", "Stuka_hit",					 0.1);
	
	ambientEventStart("exterior");
}
*/

init()
{
	level.ambient_zones = [];
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
	
	level.ambient_functions = [];
	level.ambient_functions[ "trigger_multiple" ] = ::ambient_double_trigger_think;
	level.ambient_functions[ "script_origin" ] = ::ambient_script_origin_think;
	
	if ( !isDefined( level.ambient_reverb ) )
		level.ambient_reverb = [];

	if ( !isDefined( level.ambient_eq ) )
		level.ambient_eq = [];
	
	if ( !isDefined ( level.fxfireloopmod ) )
		level.fxfireloopmod = 1;

	// used to change the meaning of interior/exterior/rain ambience midlevel.
	level.ambient_modifier["interior"] = "";
	level.ambient_modifier["exterior"] = "";
	level.ambient_modifier["rain"] = "";

	// loads any predefined filters in _equalizer.gsc
	loadPresets();
	
}


// starts this ambient track
activateAmbient( ambient )
{
	level.ambient = ambient;

	if ( level.ambient == "exterior" )
		ambient += level.ambient_modifier["exterior"];
	if ( level.ambient == "interior" )
		ambient += level.ambient_modifier["interior"];
		
	assert( isDefined( level.ambient_track ) && isDefined( level.ambient_track[ambient] ) );
	ambientPlay( level.ambient_track[ambient + level.ambient_modifier["rain"]], 1 );
	thread ambientEventStart( ambient + level.ambient_modifier["rain"] );
	println( "Ambience becomes: ", ambient + level.ambient_modifier["rain"] );
}


ambientVolume()
{
	for (;;)
	{
		self waittill ( "trigger" );
		activateAmbient( "interior" );
		while ( level.player isTouching ( self ) )
			wait 0.1;		
		activateAmbient( "exterior" );
	}
}


ambientDelay (track, min, max)
{
	assertEX (max > min, "Ambient max must be greater than min for track " + track);
	if (!isdefined (level.ambientEventEnt))
		level.ambientEventEnt[track] = spawnstruct();
	else
	if (!isdefined (level.ambientEventEnt[track]))
		level.ambientEventEnt[track] = spawnstruct();
	
	level.ambientEventEnt[track].min = min;
	level.ambientEventEnt[track].range = max - min;
}

ambientEvent (track, name, weight)
{
	assertEX (isdefined (level.ambientEventEnt), "ambientDelay has not been run");
	assertEX (isdefined (level.ambientEventEnt[track]), "ambientDelay has not been run");

	if (!isdefined (level.ambientEventEnt[track].event_alias))
		index = 0;
	else
		index = level.ambientEventEnt[track].event_alias.size;

	level.ambientEventEnt[track].event_alias[index] = name;
	level.ambientEventEnt[track].event_weight[index] = weight;
}

ambientReverb(type)
{
	level.player setReverb(level.ambient_reverb[type]["priority"], level.ambient_reverb[type]["roomtype"], level.ambient_reverb[type]["drylevel"], level.ambient_reverb[type]["wetlevel"], level.ambient_reverb[type]["fadetime"]);
	level waittill ("new ambient event track");
//	if(level.ambient != type)
		level.player deactivatereverb(level.ambient_reverb[type]["priority"],2);
}


setupEq( track, channel, filter )
{
	if ( !isDefined( level.ambient_eq[track] ) )
		level.ambient_eq[track] = [];
	
	level.ambient_eq[track][channel] = filter;
}


ambientEq(track)
{
	if ( !isdefined( level.ambient_eq[track] ) )
		return;
		
	channels = getArrayKeys( level.ambient_eq[track] );
	for ( i = 0; i < channels.size; i++ )
	{
		filter = getFilter( level.ambient_eq[track][channels[i]] );
		if ( isdefined( filter ) )
		{
			for ( band = 0; band < 3; band++ )
			{			
				if ( isdefined( filter["type"][band] ) )
					level.player seteq( channels[i], band, filter["type"][band], filter["gain"][band], filter["freq"][band], filter["q"][band] );
				else
					level.player deactivateeq( channels[i], band );
			}				
		}
	}

	level waittill ("new ambient event track");

	for ( i = 0; i < channels.size; i++ )
	{
		for ( band = 0; band < 3; band++ )
		{
			level.player deactivateeq( channels[i], band );
		}
	}
}


ambientEventStart (track)
{
	level notify ("new ambient event track");
	level endon ("new ambient event track");
	
	assertEX (isdefined (level.ambientEventEnt), "ambientDelay has not been run");
	assertEX (isdefined (level.ambientEventEnt[track]), "ambientDelay has not been run");
	
	if (!isdefined(level.player.soundEnt))
	{
		level.player.soundEnt = spawn ("script_origin",(0,0,0));
		level.player.soundEnt.playingSound = false;
	}
	else
	{
		if (level.player.soundEnt.playingSound)
			level.player.soundEnt waittill ("sounddone");
	}	
	
	ent = level.player.soundEnt;
	min = level.ambientEventEnt[track].min;
	range = level.ambientEventEnt[track].range;
	
	lastIndex = 0;
	index = 0;
	assertEX (level.ambientEventEnt[track].event_alias.size > 1, "Need more than one ambient event for track " + track);
	if(isdefined(level.ambient_reverb[track]))
		thread ambientReverb(track);

	if(isdefined(level.ambient_eq[track]))
		thread ambientEq(track);

	for (;;)
	{
		wait (min + randomfloat(range));
		while (index == lastIndex)
			index = ambientWeight(track);
			
		lastIndex = index;
		ent.origin = level.player.origin;
		ent linkto (level.player);
		ent playsound (level.ambientEventEnt[track].event_alias[index], "sounddone");
		ent.playingSound = true;
		ent waittill ("sounddone");
		ent.playingSound = false;
	}
}

ambientWeight (track)
{
	total_events = level.ambientEventEnt[track].event_alias.size;
	idleanim = randomint (total_events);
	if (total_events > 1)
	{
		weights = 0;
		anim_weight = 0;
		
		for (i=0;i<total_events;i++)
		{
			weights++;
			anim_weight += level.ambientEventEnt[track].event_weight[i];
		}
		
		if (weights == total_events)
		{
			anim_play = randomfloat (anim_weight);
			anim_weight	= 0;
			
			for (i=0;i<total_events;i++)
			{
				anim_weight += level.ambientEventEnt[track].event_weight[i];
				if (anim_play < anim_weight)
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
	level.ambient_zones[ zone ] = true;
}
	
ambient_trigger()
{
	// ambient receiver triggers are targetted, they don't run the ambient logic
	if ( !isdefined( self.target ) )
		return;
		
	self endon( "death" );

	// run the ambient logic dependent on what type of entity the trigger targets
	ent = getent( self.target, "targetname" );
	[[ level.ambient_functions[ ent.classname ] ]]( ent );
}

check_ambience( type )
{
//	assertEx( isdefined( level.ambient_zones[ type ] ), "Ambience " + type + " is not a defined ambience zone" );
}

ambient_double_trigger_think( ent )
{
	// trigger multiples call this type of ambient logic
	start = self.origin;
	end = ent.origin;
	dist = distance( start, end );

	inner_ambience = self.ambient;
	outer_ambience = ent.ambient;
	
	/#
	check_ambience( inner_ambience );
	check_ambience( outer_ambience );
	#/
	

	ent thread ambient_end_trigger_think( start, end, dist, outer_ambience, inner_ambience );
	
	
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( other == level.player, "Non-player entity touched an ambient trigger." );
		ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience );
	}
}

ambient_script_origin_think( ent )
{
	// ambient triggers that target a script origin use this logic
	// trigger multiples call this type of ambient logic

	start = ent.origin;
	end = undefined;
	
	if ( isdefined( ent.target ) )
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
	
	// get the ambience zones on this trigger
	tokens = strtok( self.ambient, " " );
	assertEx( tokens.size == 2, "Ambience trigger at " + self.origin + " doesn't have 2 ambient zones set. Usage is \"ambient\" \"zone1 zone2\"" );

	inner_ambience = tokens[ 0 ];
	outer_ambience = tokens[ 1 ];
	
	/#
	check_ambience( inner_ambience );
	check_ambience( outer_ambience );
	#/

	
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( other == level.player, "Non-player entity touched an ambient trigger." );

		progress = undefined;		
		while ( level.player istouching( self ) )
		{
			progress = get_progress( start, end, dist, level.player.origin );
	
			if ( progress < 0 )
				progress = 0;
			
			if ( progress > 1 )
				progress = 1;
	
			set_ambience( progress, inner_ambience, outer_ambience );
			wait( 0.05 );
		}

		// when you leave the trigger set it to whichever point it was closest too		
		if ( progress > 0.5 )
			progress = 1;
		else
			progress = 0;

		set_ambience( progress, inner_ambience, outer_ambience );
	}
}

get_progress( start, end, dist, org )
{
	normal = vectorNormalize( end - start );
	vec = org - start;
	progress = vectorDot( vec, normal );
	progress = progress / dist;
	return progress;
}


ambient_end_trigger_think( start, end, dist, inner_ambience, outer_ambience )
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( other == level.player, "Non-player entity touched an ambient trigger." );
		ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience );
	}
}

ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience )
{
	level notify( "trigger_ambience_touched" );
	level endon( "trigger_ambience_touched" );
	
	for ( ;; )
	{
		progress = get_progress( start, end, dist, level.player.origin );

		if ( progress < 0 )
		{
			progress = 0;
			
			set_ambience( progress, inner_ambience, outer_ambience );
			break;
		}
		
		if ( progress >= 1 )
		{
			progress = 1;
			set_ambience( progress, inner_ambience, outer_ambience );
			break;
		}

		set_ambience( progress, inner_ambience, outer_ambience );
		wait( 0.05 );
	}
}

set_ambience( progress, inner_ambience, outer_ambience )
{
	/*
	if ( progress <= 0.5 )
		ambientplay( inner_ambience );
	else
		ambientplay( outer_ambience );
	*/
	
	/#
	if ( progress == 1 || progress == 0 )
		level.nextmsg = 0;
		
	if ( !isdefined( level.nextmsg ) )
		level.nextmsg = 0;
		
	if ( gettime() < level.nextmsg )
		return;
	
	level.nextmsg = gettime() + 200;
	#/
//	println( progress + " " + outer_ambience + ", " + ( 1 - progress ) + " " + inner_ambience );
}