#include maps\_utility; 
#include common_scripts\utility; 

/*/////////////////////////// _audio.gsc ///////////////////////////////////////////////

Functionality:

	Line Emitters: Used to play a moving sound along a line.
	
			Line emitters are set up by placing a trigger (either a brush or a 
			script_radius) in radiant. The trigger is then targeted at a script_stuct
			which will make the start point. The script_struct will target another
			script_struct which will make the end point. Emitter will begin once 
			trigger is hit. Multiple emitters can be targeted from one trigger.
											
			KV Pairs: For the trigger:
																			
				targetname: 				Must be set to "sound_trigger" in order to work.
			
			KV Pairs: For the first script_struct:
			
				script_label:				Must be set to "line_emitter" in order to work.
				script_sound:				The alias of the sound to play.
				script_looping:			Allows for looping sounds to be played. Sound must
														be set to looping in the .CSV or the sound will
														not play.
				script_noteworthy:	Only set if you plan on killing the line emitter.
														Set this to a custom string, then pass that string
														into stop_line_sound() to kill the emitter.			

	Static Sound Loopers: Used to play a looping sound from a trigger.
	
			Static sound loopers are set up by placing a trigger (either a brush or a 
			script_radius) in radiant. The trigger is then targeted at a script_origin
			which is where the sound will play. Multiple loopers can be targeted from
			one trigger.
											
			KV Pairs: For the trigger:
																			
				targetname: 				Must be set to "audio_sound_trigger" in order to work.
				
			KV Pairs: On the script_origin:
				
				script_label:				Must be set to "looper" in order to work.													
				script_sound:				The alias of the sound to play.				

	Static Sound Randoms: Used to play a sound at random intervals from a trigger.
	
			Static sound randoms are set up by placing a trigger (either a brush or a 
			script_radius) in radiant. The trigger is then targeted at a script_origin
			which is where the sound will play. Multiple randoms can be targeted from
			one trigger.
								
			KV Pairs: For the trigger:
																			
				targetname: 				Must be set to "sound_trigger" in order to work.
							
			KV Pairs: On the script_origin:
										
				script_label:				Must be set to "random" in order to work.									
				script_sound:				The alias of the sound to play.		
				script_wait_min:		The minimum time to wait between plays
				script_wait_max:		The maximum time to wait between plays
				
	Note: One trigger can be pointed at any or all combinations of loopers, line emitters
				or randoms.

*///////////////////////////////////////////////////////////////////////////////////////

// This is called from _load.gsc, which grabs all the triggers and sets them up.
main()
{
	array_thread( GetEntArray( "audio_sound_trigger", "targetname" ), ::thread_sound_trigger ); 	
	//array_thread( GetEntArray( "line_emitter", "targetname" ), ::thread_line_sound ); 
	//array_thread( GetEntArray( "static_sound_looper", "targetname" ), ::thread_static_sound_looper ); 
	//array_thread( GetEntArray( "static_sound_random", "targetname" ), ::thread_static_sound_random ); 
}
wait_until_first_player()
{
	players = get_players();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
}

thread_sound_trigger()
{
		self waittill ("trigger");
		
		struct_targs = getstructarray(self.target, "targetname");
		ent_targs = getentarray(self.target,"targetname");
		
		// structs should be line emitters for now
		if (isdefined(struct_targs))
		{
			for (i = 0; i < struct_targs.size; i++)
			{
				// CODER_MOD
				// Migrating line emitters to the client.  DSL
				if(!level.clientscripts)	
				{

					if( !IsDefined( struct_targs[i].script_sound ) )
					{
						assertmsg( "_audio::thread_sound_trigger(): script_sound is UNDEFINED! Aborting..." + struct_targs[i].origin );
						return;
					}
					
					struct_targs[i] thread spawn_line_sound(struct_targs[i].script_sound);
				}
			}			
		}
		
		// ents are loopers and randoms
		if (isdefined(ent_targs))
		{
			for (i = 0; i < ent_targs.size; i++)
			{
				if( !IsDefined( ent_targs[i].script_sound ) )
				{
					assertmsg( "_audio::thread_sound_trigger(): script_sound is UNDEFINED! Aborting... " + ent_targs[i].origin );
					return;
				}
				
				if (isdefined(ent_targs[i].script_label) && ent_targs[i].script_label == "random")
				{
					// CODER_MOD
					// Migrating randoms to the client.  DSL
					if(!level.clientscripts)	
					{
						ent_targs[i] thread static_sound_random_play(ent_targs[i]);
					}
				}
				else if (isdefined(ent_targs[i].script_label) && ent_targs[i].script_label == "looper")
				{
					// CODER_MOD
					// Migrating loopers to the client.  DSL
					if(!level.clientscripts)	
					{
						ent_targs[i] thread static_sound_loop_play(ent_targs[i]);
					}
				}
			}			
		}
}

// self is the trigger
// grabs a SCRIPT_STRUCT (not script_origin) for the start and end points.
// spawns in a scipt_origin for the mover.
spawn_line_sound(sound)
{	
	startOfLine = self; 

	if( !IsDefined( startOfLine ) )
	{
		assertmsg( "_audio::spawn_line_sound(): Could not find start of line entity! Aborting..." );
		return;
	}
	
	self.soundmover = [];

	endOfLineEntity = getstruct( startOfLine.target, "targetname" );
	if( isdefined( endOfLineEntity ) )
	{
		start = startOfLine.origin;
		end = endOfLineEntity.origin;
	
		soundMover = spawn("script_origin", start);
		soundMover.script_sound = sound;
		self.soundmover = soundMover;
			
		if (isdefined (self.script_looping))
		{
			soundMover.script_looping = self.script_looping;
		}
			
		if( isdefined( soundMover ) )
		{
			soundMover.start = start;
			soundMover.end = end;
			soundMover line_sound_player();	
			soundMover thread move_sound_along_line();
		}
		else
		{
			assertmsg( "Unable to create line emitter script origin" );
		}
	}
	else
	{
			assertmsg( "_audio::spawn_line_sound(): Could not find end of line entity! Aborting..." );
	}
	//}
}

// determine whether or not to loop
line_sound_player()
{
	self endon ("end line sound");
	
	if (isdefined (self.script_looping))
	{
		self playloopsound(self.script_sound);
	}
	else
	{
		self playsound (self.script_sound);
	}
}

// self is the script origin mover
// moves the sound along the line
move_sound_along_line()
{
	self endon ("end line sound");
	wait_until_first_player();
	closest_dist = undefined;
	while(1)
	{
		self closest_point_on_line_to_point( get_players()[0].origin, self.start, self.end);
/# 
		if( getdvarint( "debug_audio" ) > 0 )
		{
			line( self.start, self.end, (0,1,0));
			
			print3d (self.start, "START", (1.0, 0.8, 0.5), 1, 3);
			print3d (self.end, "END", (1.0, 0.8, 0.5), 1, 3);
			print3d (self.origin, self.script_sound, (1.0, 0.8, 0.5), 1, 3);
		}
#/
		//Update the sound based on distance to the point
			closest_dist = DistanceSquared( get_players()[0].origin, self.origin );

			if( closest_dist > 1024 * 1024 )
			{
				wait( 2 );
			}
			else if( closest_dist > 512 * 512 )
			{
				wait( 0.2);
			}
			else
			{
				wait( 0.05);
			}
	}
}

// self is the script origin mover
// the crazy math Alex C wrote on COD3, convered to GSC for COD5
closest_point_on_line_to_point( Point, LineStart, LineEnd )
{
	self endon ("end line sound");
	
	LineMagSqrd = lengthsquared(LineEnd - LineStart);
 
    t =	( ( ( Point[0] - LineStart[0] ) * ( LineEnd[0] - LineStart[0] ) ) +
				( ( Point[1] - LineStart[1] ) * ( LineEnd[1] - LineStart[1] ) ) +
				( ( Point[2] - LineStart[2] ) * ( LineEnd[2] - LineStart[2] ) ) ) /
				( LineMagSqrd );
 
  if( t < 0.0  )
	{
		self.origin = LineStart;
	}
	else if( t > 1.0 )
	{
		self.origin = LineEnd;
	}
	else
	{
		start_x = LineStart[0] + t * ( LineEnd[0] - LineStart[0] );
		start_y = LineStart[1] + t * ( LineEnd[1] - LineStart[1] );
		start_z = LineStart[2] + t * ( LineEnd[2] - LineStart[2] );
		
		self.origin = (start_x,start_y,start_z);
	}
}

// Stops called in script manually for now.
stop_line_sound(startOfLineEntity)
{
	startpoints = getstructarray(startOfLineEntity, "script_noteworthy");

	for (i = 0; i < startpoints.size; i++)
	{
		if( !IsDefined( startpoints[i].soundmover ) )
		{
			println ("Line emitter wasn't spawned before delete call... are you sure this isn't messed up?");
			return;
		}
		// this should stop all the associated threads
		startpoints[i].soundmover notify ("end line sound");	

		// delete the entities, cleanup time
		startpoints[i].soundmover delete();		
	}
}

// self is the trigger
// logic for playing the sound at random intervals
static_sound_random_play(soundpoint)
{
	// what is this for?
	wait(RandomIntRange(1, 5));
		
	if (!isdefined (self.script_wait_min))
	{
		self.script_wait_min = 1;
	}
	if (!isdefined (self.script_wait_max))
	{
		self.script_wait_max = 3;
	}
	
	while(1)
	{
		wait( RandomFloatRange( self.script_wait_min, self.script_wait_max ) );
		soundpoint playsound(self.script_sound);
/#
		if( getdvarint( "debug_audio" ) > 0 )
		{
				print3d (soundpoint.origin, self.script_sound, (1.0, 0.8, 0.5), 1, 3, 5);
		}
#/
	}
}

// self is the trigger
// logic for playing the sound on a loop, looping sound must be set to looping in the CSV
static_sound_loop_play(soundpoint)
{
	self playloopsound(self.script_sound);	
/#
		if( getdvarint( "debug_audio" ) > 0 )
		{
			while(1)
			{
				print3d (soundpoint.origin, self.script_sound, (1.0, 0.8, 0.5), 1, 3, 5);
				wait (1);
			}
		}
#/
}

//targs = getarray("blah","targetname");
//
//for (i = 0; i < targs; i++)
//{
//	targs[i] thread static_sound_loop_play(targs[i])
//}