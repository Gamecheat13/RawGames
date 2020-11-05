// Client side audio functionality

#include clientscripts\mp\_utility;


soundRandom_Thread(localClientNum, randSound)
{
	if (!isdefined (randSound.script_wait_min))
	{
		randSound.script_wait_min = 1;
	}
	if (!isdefined (randSound.script_wait_max))
	{
		randSound.script_wait_max = 3;
	}
	
	/#
		if( getdvarint( "debug_audio" ) > 0 )
		{
				println("*** Client : SR ( " + randSound.script_wait_min + " - " + randSound.script_wait_max + ")");
		}
#/
	
	while(1)
	{
		pause = RandomFloatRange( randSound.script_wait_min, randSound.script_wait_max ) ;
		wait( pause );
		
		if(!isdefined(randSound.script_sound))
		{
			println("ambient sound at "+randSound.origin+" has undefined script_sound");
		}
		else
		{
			playsound(localClientNum, randSound.script_sound, randSound.origin);
		}
/#
		if( getdvarint( "debug_audio" ) > 0 )
		{
				print3d (randSound.origin, randSound.script_sound, (0.0, 0.8, 0.0), 1, 3, 45);
		}
#/
	}
}

// self is the trigger
// logic for playing the sound on a loop, looping sound must be set to looping in the CSV
soundLoop_Thread(localClientNum, loopSound)
{
	clientscripts\mp\_utility::loop_fx_sound(localClientNum, loopSound.script_sound, loopSound.origin);
/#
		if( getdvarint( "debug_audio" ) > 0 )
		{
			while(1)
			{
				print3d (loopSound.origin, loopSound.script_sound, (0.0, 0.8, 0.0), 1, 3, 30);
				wait (1);
			}
		}
#/
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

line_sound_player()
{
	if (isdefined (self.script_looping))
	{
		self.fake_ent = spawnfakeent(self.localClientNum);
		setfakeentorg(self.localClientNum, self.fake_ent, self.origin);
		playloopsound( self.localClientNum, self.fake_ent, self.script_sound); 
	}
	else
	{
		playsound (self.localClientNum, self.script_sound, self.origin);
	}
}

debug_line_emitter()
{
	while(1)
	{
/# 
		if( getdvarint( "debug_audio" ) > 0 )
		{
			line( self.start, self.end, (0,1,0));
			
			print3d (self.start, "START", (0.0, 0.8, 0.0), 1, 3, 1);
			print3d (self.end, "END", (0.0, 0.8, 0.0), 1, 3, 1);
			print3d (self.origin, self.script_sound, (0.0, 0.8, 0.0), 1, 3, 1);
		}

		wait(0.01);
#/
	}
}

move_sound_along_line()
{
	closest_dist = undefined;
	
	/#
	self thread debug_line_emitter();
	#/
	
	while(1)
	{
			self closest_point_on_line_to_point( getlocalclientpos(0), self.start, self.end);

			if(isdefined(self.fake_ent))
			{
				setfakeentorg(self.localClientNum, self.fake_ent, self.origin);
			}

		//Update the sound based on distance to the point
			closest_dist = DistanceSquared( getlocalclientpos(0), self.origin );	

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

lineEmitter_Thread(localClientNum)
{
	startOfLine = self;

	if( !IsDefined( startOfLine ) )
	{
		assertmsg( "_audio::spawn_line_sound(): Could not find start of line entity! Aborting..." );
		return;
	}
	
	self.soundmover = [];

	endOfLineEntity = undefined;

	if(IsDefined(self.target))
		endOfLineEntity = getstruct( self.target, "targetname" );

	if( isdefined( endOfLineEntity ) )
	{
		soundMover = spawnstruct();
		
		soundMover.start = self.origin;
		soundMover.origin = self.origin;
		soundMover.end = endOfLineEntity.origin;
		soundMover.script_sound = self.script_sound;
		soundMover.localClientNum = localClientNum;
		
		self.soundmover = soundMover;
		
		if(isdefined(self.script_looping))
		{
			soundMover.script_looping = self.script_looping;
		}
	
		soundMover line_sound_player();	
		soundMover thread move_sound_along_line(); 
	
	}
/*	else
	{
			assertmsg( "_audio::spawn_line_sound(): Could not find end of line entity! Aborting..." );
	}  */
}

startSoundRandoms(localClientNum)
{
	randoms = GetStructArray( "random", "script_label" );
	
	if( IsDefined( randoms ) && randoms.size > 0)
	{
		println("*** Client : Initialising random sounds - " + randoms.size + " emitters.");
		for(i = 0; i < randoms.size; i ++)
		{
			thread soundRandom_Thread(localClientNum, randoms[i]);
		}
	}
	else
	{
		println("*** Client : No random sounds.");
	}
}

startSoundLoops(localClientNum)
{
	loopers = GetStructArray( "looper", "script_label" );
	
	if( IsDefined( loopers ) && loopers.size > 0)
	{
		println("*** Client : Initialising looper sounds - " + loopers.size + " emitters.");
		for(i = 0; i < loopers.size; i ++)
		{
			thread soundLoop_Thread(localClientNum, loopers[i]);
			println("    Looper : " + loopers[i].script_sound);
		}
	}
	else
	{
		println("*** Client : No looper sounds.");
	}
}

startLineEmitters(localClientNum)
{
	lineEmitters = GetStructArray( "line_emitter", "script_label" );
	
	if( IsDefined( lineEmitters ) && lineEmitters.size > 0)
	{
		println("*** Client : Initialising line emitter sounds - " + lineEmitters.size + " emitters.");
		for(i = 0; i < lineEmitters.size; i ++)
		{
			 lineEmitters[i] thread lineEmitter_Thread(localClientNum);
		}
	}
	else
	{
		println("*** Client : No line emitter sounds.");
	}
}


audio_init(localClientNum)
{
	startSoundRandoms(localClientNum);
	startSoundLoops(localClientNum);
	startLineEmitters(localClientNum);
}