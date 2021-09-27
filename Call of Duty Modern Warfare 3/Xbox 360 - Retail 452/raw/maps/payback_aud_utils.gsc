// =============================================================================
// STATIC SOUNDS SYSTEM
// created by jsypult@ravensoftware
// 2011.02.16
//
// this system is used for simplifying the
// implementation of static, ambience-like
// sounds in a map.
// 
// *********************************************
// *********************************************
// NOTE:
// USE "loop_fx_sound" defined in utility.gsc. 
//
// =============================================================================
// Technical Details:
// All 'static sound' data is persistently stored in the level.static_sounds
// structure. Each static sound is added to an array with all of the properties
// necessary to determine how to play back and what state it is currently in.
// Debugging will print the unique names (targetname) of each static sound in
// 3D for the player/camera to see. The color of the text determines the state:
// GREEN:	The emitter is active and currently playing a sound/voice.
// YELLOW:	The emitter is active but not currently playing a voice (one-shot delay)
// RED:		The emitter is inactive. It can be started again if needed since
//			the data to handle it is still available.
// =============================================================================
//
// TODO:
//	- figure out how to integrate payback_aud_utils.gsc as an
//	underscore _util script.
//
//	- need a method to obtain a soundaliases maximum distance so we can handle
//	  entity creation checks if we're too far away
//
//	- handle & manage fading better since it can be broken easily when attempting
//    to stop/start during a fade.
//	  keep track of fading in the structure
//	  check & handle when attempting to play/stop
//
//	- add 'destroy' capability?
//	  remove emitter from the data structure as if it were never added.
//	  is it really necessary - to avoid printing "permanently-inactive" sounds?
// =============================================================================

#include maps\_utility_code;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;

createStaticSound( type, unique_name, soundalias, origin, bStartActive )
{
	// ensure our required variables have been defined
	assert( isDefined(type) );
	assert( isDefined(unique_name) );
	assert( isDefined(soundalias) );
	assert( isDefined(origin) );

	// ensure type is properly set
	assertEx( type != "looping" || type != "oneshot", "createStaticSound() type is not looping or oneshot" );
	
	// create our level static_sounds structure if it doesn't exist
	if ( !isDefined( level.static_sounds ) )
		level.static_sounds = [];

	// bStartActive is an optional parameter that defaults to true
	bActive = true;
	if (isDefined(bStartActive))
		bActive = bStartActive;

	// spawn struct and add to the static sound array
	ent = spawnStruct();
	level.static_sounds[ level.static_sounds.size ] = ent;

	// create our new static sound
	ent.audio_properties = [];
	ent.audio_properties[ "type" ] = type;
	ent.audio_properties[ "targetname" ] = unique_name;
	ent.audio_properties[ "active" ] = bActive;
	ent.audio_properties[ "playing" ] = false;
	ent.audio_properties[ "soundalias" ] = soundalias;
	ent.audio_properties[ "origin" ] = origin;
	ent.audio_properties[ "angles" ] = undefined;
	ent.audio_properties[ "delay_min" ] = undefined;
	ent.audio_properties[ "delay_max" ] = undefined;
	ent.drawn = true;
	
	return ent;
}

addStaticSoundLoop( unique_name, soundalias, origin, bStartActive )
{
	assert( isDefined(unique_name) );
	assert( isDefined(soundalias) );
	assert( isDefined(origin) );
	
	ent = createStaticSound( "looping", unique_name, soundalias, origin, bStartActive );
	
	return ent;
}

addStaticSoundOneShot( unique_name, soundalias, origin, delay_min, delay_max, bStartActive )
{
	assert( isDefined(unique_name) );
	assert( isDefined(soundalias) );
	assert( isDefined(origin) );
	assert( isDefined(delay_min) );
	assert( isDefined(delay_max) );
	
	ent = createStaticSound( "oneshot", unique_name, soundalias, origin, bStartActive );
	ent.audio_properties[ "delay_min" ] = delay_min;
	ent.audio_properties[ "delay_max" ] = delay_max;
	
	return ent;
}

playStaticSoundLoop()
{
	// self needs to be the calling entity/struct
	soundalias = self.audio_properties[ "soundalias" ];
	origin = self.audio_properties[ "origin" ];
	self.audio_properties[ "active" ] = true;
	
	// ensure we do not play duplicate looping static sounds
	if (self.audio_properties[ "active" ] == true && self.audio_properties[ "playing" ] == false)
	{
		ent = Spawn( "script_origin", origin );
		self.entity = ent;
		self.audio_properties[ "playing" ] = true;
		self.entity PlayLoopSound( soundalias );
		self.entity willNeverChange();
	}
}

playStaticSoundOneShot()
{
	// self needs to be the calling entity/struct
	soundalias = self.audio_properties[ "soundalias" ];
	origin = self.audio_properties[ "origin" ];
	delay_min = self.audio_properties[ "delay_min" ];
	delay_max = self.audio_properties[ "delay_max" ];
	self.audio_properties[ "active" ] = true;
	
	while(self.audio_properties[ "active" ])
	{
		// wait first so that all the sounds don't start at the same time (level load, etc.)
		wait( randomFloatRange( delay_min, delay_max ) );
		
		// in case this sound was deactivated during the waiting period
		if (self.audio_properties[ "active" ])
		{
			test_entity = self.entity;
			if (!isDefined(test_entity))
			{
				ent = Spawn( "script_origin", origin );
				self.entity = ent;
				self.audio_properties[ "playing" ] = true;
				self.entity PlaySound( soundalias, "sounddone" );
				self.entity waittill( "sounddone" );
				self.audio_properties[ "playing" ] = false;
				waittillframeend;
				self.entity delete();
			}
		}
	}
}

playStaticSound( unique_name, fade_in )
{
	fade_time = 0;
	if ( isDefined(fade_in) )
	{
		assert(fade_in >= 0);
		fade_time = fade_in;
	}
	
	for ( i = 0; i < level.static_sounds.size; i++ )
	{
		ent = level.static_sounds[ i ];
		if (ent.audio_properties[ "targetname" ] == unique_name)
		{
			continue;
		}
		else
		{
			if ( ent.audio_properties[ "type" ] == "looping" )
			{
				ent thread playStaticSoundLoop();
				continue;
			}

			if ( ent.audio_properties[ "type" ] == "oneshot" )
			{
				ent thread playStaticSoundOneShot();
				continue;
			}
				
			if (fade_time > 0)
			{
				ent.entity ScaleVolume(0.0);
				ent.entity ScaleVolume(1.0, fade_time);
				wait (fade_time);
				waittillframeend;
			}
		}
	}
}

stopStaticSound( unique_name, fade_out )
{
	fade_time = 0;
	if ( isDefined(fade_out) )
	{
		assert(fade_out >= 0);
		fade_time = fade_out;
	}

	for ( i = 0; i < level.static_sounds.size; i++ )
	{
		ent = level.static_sounds[ i ];
		if (ent.audio_properties[ "targetname" ] != unique_name)
		{
			continue;
		}
		else
		{
			if (fade_time > 0)
			{
				ent.entity ScaleVolume(0.0, fade_time);
				wait (fade_time);
				waittillframeend;
			}

			ent.audio_properties[ "active" ] = false;
			ent.audio_properties[ "playing" ] = false;

			if ( ent.audio_properties[ "type" ] == "looping" )
			{
				ent.entity StopLoopSound();
				waittillframeend;
				ent.entity Delete();
				continue;
			}
				
			if ( ent.audio_properties[ "type" ] == "oneshot" )
			{
				// jsypult @TODO debug
				//ent.entity StopSounds();
				continue;
			}
		}
	}
}

debugDrawStaticSounds()
{
	if ( GetDvar( "snd_staticDebug" ) == "" )
		SetDevDvar( "snd_staticDebug", "0" );
	/#
	while( true )
	{
		wait( 0.05 );

		if ( GetDvar( "snd_staticDebug" ) == "1" )
		{
			for ( i = 0; i < level.static_sounds.size; i++ )
			{
				ent = level.static_sounds[ i ];
				
				origin = ent.audio_properties[ "origin" ];
				//adjust_amount = 4.0;
				if (origin[0] < 0) 
					adjust_x = -5.0;
				else 
					adjust_x = 5.0;
				if (origin[1] < 0) 
					adjust_y = -5.0; 
				else 
					adjust_y = 5.0;
				if (origin[2] < 0) 
					adjust_z = -5.0; 
				else 
					adjust_z = 5.0;
				origin -= (adjust_x, adjust_y, adjust_z);
				
				red = 0.75;
				green = 0.25;
				blue = 0.25;
				alpha = 0.25;
				scale = 1;
				type = "";
				name = "";
				
				if (ent.audio_properties[ "active" ])
				{
					red = 0.75;
					green = 0.75;
					blue = 0.25;
					alpha = 0.75;
				}
				
				if (ent.audio_properties[ "playing" ])
				{
					red = 0.25;
					green = 0.75;
					blue = 0.25;
					alpha = 0.75;
				}
				
				if (ent.audio_properties[ "type" ] == "looping")
					type = "looping";
				else if (ent.audio_properties[ "type" ] == "oneshot")
					type = "oneshot";
				else
					type = "** UNKNOWN **";

				name = ent.audio_properties[ "targetname" ];
				string = type + ": " + name;
				
				print3D( origin, "X", (red,green,blue), alpha, scale );
				print3D( origin + ( 0, 0, (12 * scale) ), type , (red,green,blue), alpha, scale );
				print3D( origin + ( 0, 0, (24 * scale) ), name , (red,green,blue), alpha, scale );
			}
		}
	}
	#/
}	

initStaticSounds()
{
	// create our level static_sounds structure if it doesn't exist
	// this is a safety measure in case no static sounds were added
	if ( !isDefined( level.static_sounds ) )
		level.static_sounds = [];
		
 	// 
	thread debugDrawStaticSounds();
	
	// loop through our static sounds structure to find sounds to initialize
	for ( i = 0; i < level.static_sounds.size; i++ )
	{
		ent = level.static_sounds[ i ];
		//ent set_forward_and_up_vectors();

		// only play sounds during initialization if active is set
		if ( ent.audio_properties[ "active" ] == true )
		{
			if ( ent.audio_properties[ "type" ] == "looping" )
				ent thread playStaticSoundLoop();
				
			if ( ent.audio_properties[ "type" ] == "oneshot" )
				ent thread playStaticSoundOneShot();
		}
	}
}