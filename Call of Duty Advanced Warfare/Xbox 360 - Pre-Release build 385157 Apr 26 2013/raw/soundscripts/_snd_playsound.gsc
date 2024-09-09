#include soundscripts\_audio;
#include soundscripts\_snd_hud;
#include soundscripts\_snd_filters;
#include soundscripts\_snd_timescale;
#include soundscripts\_audio_mix_manager;
#include soundscripts\_snd_foley;
#include maps\_utility;
#include soundscripts\_snd_common;

// This is a utility script for a "playsound" api

/*
=============
///ScriptDocBegin
"Name: snd_play( <alias_name> , <script_notify_> )"
"Summary: Plays a one-shot sound with an optional script notify. This function wraps an internal PlaySound call with a call to SoundExists. Prevents asserts when assets move, which is good for legacy maps."
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias_name>: name of the alias"
"MandatoryArg: <script_notify_>: string notify on the playsound"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_play( alias_name, script_notify_ )
{
	Assert( IsString( alias_name ) );
	
	if ( SoundExists( alias_name ) )
	{
		if ( IsDefined( script_notify_ ) )
		{
			Assert( IsString( script_notify_ ) );
			self PlaySound( alias_name, script_notify_ );
		}
		else
		{
			self PlaySound( alias_name );
		}
		self.snd_is_one_shot = true;
	}
	else
	{
/#
		msg = "snd_play: sound alias " + alias_name + " does not exist.";
		println( msg );
		if ( GetDebugDvarInt("snd_verify_aliases") )
			AssertEx( false, msg);
#/			
	}
}


/*
=============
///ScriptDocBegin
"Name: snd_play_loop( <alias_name> )"
"Summary: Plays a looping sound, wraps a call to SoundExists before playing"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias_name>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

snd_play_loop( alias_name )
{
	if ( SoundExists( alias_name ) )
	{
		if ( !IsDefined( self.snd_is_loop ) )
		{		
			self PlayLoopSound( alias_name );
			self.snd_is_loop = true;
		}
		else
		{
/#
			msg = "snd_play_loop: can't call snd_play_loop on an entity multiple times. Entities only track one loop.";
			println( msg );
			if ( GetDebugDvarInt("snd_verify_aliases") )
				AssertEx( false, msg);
#/
		}
	}
	else
	{
/#
		msg = "snd_play_loop: sound alias " + alias_name + " does not exist.";
		println( msg );
		if ( GetDebugDvarInt("snd_verify_aliases") )
			AssertEx( false, msg);
#/				
	}
}

/*
=============
///ScriptDocBegin
"Name: snd_stop()"
"Summary: Stops a sound playing on the entity. Should pair with calls to snd_play and snd_play_loop."
"Module: Sound"
"CallOn: An entity"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_stop_sound()
{
	if ( IsDefined( self.snd_is_one_shot ) )
	{
		self.snd_is_one_shot = undefined;
		self StopSounds();
	}
	else if ( IsDefined( self.snd_is_loop ) )
	{
		self.snd_is_loop = undefined;
		self StopLoopSound();
	}
}

/*
=============
///ScriptDocBegin
"Name: snd_play_amb_loop( <alias_name> , <org>, <stop_loop_notify>, <fadeout_time_> )"
"Summary: Plays a loopsound in space with a stop loop notify string. "
"Module: Sound"
"CallOn: A Thread"
"MandatoryArg: <alias_name>: name of the alias"
"MandatoryArg: <org>: Vector"
"MandatoryArg: <stop_loop_notify>: Notify string used to stop the sound."
"OptionalArg: <fadeout_time_>: Changes the fadeout time of the sound once the stop loop notify is called."
"Example: "snd_play_amb_loop( "best_fire_loop_ever" , ( 100, 1203, 10 ), "stop_best_fire_loop_ever", 0.5 )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

snd_play_amb_loop( alias_name, org, stop_loop_notify, fadeout_time_ )
{
	if( SoundExists( alias_name ))
	{
		// Default Fadeout Time.
		fadeout_time = 0.1;
	
		snd_ent = spawn( "script_origin", org );
		snd_ent playloopsound( alias_name );
		
		level waittill( stop_loop_notify );			
	
		if(isDefined( fadeout_time_ ) )
			fadeout_time = fadeout_time_;
		
		if(IsDefined( snd_ent ) )
		{
			snd_ent scalevolume( 0, fadeout_time );
			wait( 0.05 );
			snd_ent delete();				
		}		
	}
	else
	{	
		/#
		if ( GetDebugDvarInt("snd_verify_aliases") )
		{
			msg = "snd_play_amb_loop - ALIAS: " + alias_name + " does not exist.";
			iprintln( msg );
		}
		#/		
	}
}