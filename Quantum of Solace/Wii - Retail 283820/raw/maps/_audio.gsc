#include maps\_utility; 
#include common_scripts\utility; 




main()
{
	array_thread( GetEntArray( "audio_sound_trigger", "targetname" ), ::thread_sound_trigger ); 	
	
	
	
}

thread_sound_trigger()
{
		self waittill ("trigger");
		
		struct_targs = getstructarray(self.target, "targetname");
		ent_targs = getentarray(self.target,"targetname");
		
		
		if (isdefined(struct_targs))
		{
			for (i = 0; i < struct_targs.size; i++)
			{
				if( !IsDefined( struct_targs[i].script_sound ) )
				{
					assertmsg( "_audio::thread_sound_trigger(): script_sound is UNDEFINED! Aborting..." );
					return;
				}
				struct_targs[i] thread spawn_line_sound(struct_targs[i].script_sound);
			}			
		}
		
		
		if (isdefined(ent_targs))
		{
			for (i = 0; i < ent_targs.size; i++)
			{
				if( !IsDefined( ent_targs[i].script_sound ) )
				{
					assertmsg( "_audio::thread_sound_trigger(): script_sound is UNDEFINED! Aborting..." );
					return;
				}
				
				if (isdefined(ent_targs[i].script_label) && ent_targs[i].script_label == "random")
				{
					ent_targs[i] thread static_sound_random_play(ent_targs[i]);
				}
				else if (isdefined(ent_targs[i].script_label) && ent_targs[i].script_label == "looper")
				{
					ent_targs[i] thread static_sound_loop_play(ent_targs[i]);
				}
			}			
		}
}




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
	
}


line_sound_player()
{
	self endon ("end line sound");
	
	if (isdefined (self.script_looping))
	{
		fadetime = 0;
		if ( isdefined( self.script_soundfadein ) )
		{
			fadetime = self.script_soundfadein;
		}
		self playloopsound(self.script_sound, fadetime);
	}
	else
	{
		self playsound (self.script_sound);
	}
}



move_sound_along_line()
{
	self endon ("end line sound");
	
	closest_dist = undefined;
	while(1)
	{
		self closest_point_on_line_to_point( level.player.origin, self.start, self.end);
/#
		if( getdvarint( "debug_audio" ) > 0 )
		{
			line( self.start, self.end, (0,1,0));
			
			print3d (self.start, "START", (1.0, 0.8, 0.5), 1, 3);
			print3d (self.end, "END", (1.0, 0.8, 0.5), 1, 3);
			print3d (self.origin, self.script_sound, (1.0, 0.8, 0.5), 1, 3);
		}
#/
		
			closest_dist = DistanceSquared( level.player.origin, self.origin );

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
		
		startpoints[i].soundmover notify ("end line sound");	

		
		startpoints[i].soundmover delete();		
	}
}



static_sound_random_play(soundpoint)
{
	
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



static_sound_loop_play(soundpoint)
{
	fadetime = 0;
	if ( isdefined( self.script_soundfadein ) )
	{
		fadetime = self.script_soundfadein;
	}
	self playloopsound(self.script_sound, fadetime);	
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







