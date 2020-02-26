#include common_scripts\utility;
#include maps\mp\animscripts\utility;
#include maps\mp\_utility;

// no longer playing sounds on the server but we still want the returns to tell
// the script if a non-sound notify needs to be handled
HandleDogSoundNoteTracks( note )
{
	if ( note == "sound_dogstep_run_default" )
	{
		return true;
	}

	prefix = getsubstr( note, 0, 5 );

	if ( prefix != "sound" )
		return false;
		
	return true;
}

growling()
{
	return isdefined( self.script_growl );
}

HandleNoteTrack( note, flagName, customFunction, var1 )
{
/#
	if ( getdvarint( "debug_dog_notetracks" ) )
		println("dog notetrack: " + flagName + " " + note + " " + GetTime() );
#/
	
	if ( isAI( self ) && self.type == "dog" )
		if ( HandleDogSoundNoteTracks( note ) )
			return;
	
	switch ( note )
	{
	case "end":
	case "finish":
	case "undefined":
		return note;
	default:
		if (isDefined(customFunction))
		{
			if (!isdefined(var1))
			{
				return [[customFunction]] (note);
			}
			else
			{
				return [[customFunction]] (note, var1);
			}
		}
		break;
	}
}

// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an "end" or a "finish"
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(flagName, ::customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
DoNoteTracks( flagName, customFunction, var1 ) 
{
	for (;;)
	{
		self waittill (flagName, note);

		if ( !isDefined( note ) )
			note = "undefined";

		val = self HandleNoteTrack( note, flagName, customFunction, var1 );
		
		if ( isDefined( val ) )
			return val;
	}
}

DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, var1 )
{
	if (isdefined (killString))
		self endon (killString);
	self endon ("killanimscript");

	for (;;)
	{
		time = GetTime();
		returnedNote = [[notetracksFunc]](flagName, customFunction, var1);
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = [[notetracksFunc]](flagName, customFunction, var1);
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
/#
				println (GetTime()+" animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
#/
				wait ( 0.05 - timetaken );
			}
		}
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
DoNoteTracksForever(flagName, killString, customFunction, var1 )
{
	DoNoteTracksForeverProc( ::DoNoteTracks, flagName, killString, customFunction, var1 );
}

DoNoteTracksForTimeProc( doNoteTracksForeverFunc, time, flagName, customFunction , ent, var1)
{
	ent endon ("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, var1);
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
DoNoteTracksForTime(time, flagName, customFunction, var1)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForever, time, flagName, customFunction, ent, var1);
}

doNoteTracksForTimeEndNotify(time)
{
	wait (time);
	self notify ("stop_notetracks");
}

trackLoop(  )
{

	players = get_players();
	deltaChangePerFrame = 5;
	
	aimBlendTime = .05;
	
	prevYawDelta = 0;
	prevPitchDelta = 0;
	maxYawDeltaChange = 5; // max change in yaw in 1 frame
	maxPitchDeltaChange = 5;
	
	pitchAdd = 0;
	yawAdd = 0;
	
	if ( self.type == "dog" )
	{
		doMaxAngleCheck = false;
		self.shootEnt = self.enemy;
	}
	else
	{
		doMaxAngleCheck = true;
	if ( self.a.script == "cover_crouch" && isdefined( self.a.coverMode ) && self.a.coverMode == "lean" )
		pitchAdd = -1 * anim.coverCrouchLeanPitch;
	if ( (self.a.script == "cover_left" || self.a.script == "cover_right") && isdefined( self.a.cornerMode ) && self.a.cornerMode == "lean" )
		yawAdd = self.coverNode.angles[1] - self.angles[1];
	}
	
	yawDelta = 0;
	pitchDelta = 0;
	
	firstFrame = true;
	
	for(;;)
	{
		incrAnimAimWeight();
		
		selfShootAtPos = (self.origin[0], self.origin[1], self getEye()[2]);

		shootPos = undefined;
		if ( isdefined( self.enemy ) )
			shootPos = self.enemy getShootAtPos();

		if ( !isdefined( shootPos ) )
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else
		{
			vectorToShootPos = shootPos - selfShootAtPos;
			anglesToShootPos = vectorToAngles( vectorToShootPos );
			
			pitchDelta = 360 - anglesToShootPos[0];
			pitchDelta = AngleClamp180( pitchDelta + pitchAdd );
			
			yawDelta = self.angles[1] - anglesToShootPos[1];
			
			yawDelta = AngleClamp180( yawDelta + yawAdd );
		}
		
		if ( doMaxAngleCheck && ( abs( yawDelta ) > 60 || abs( pitchDelta ) > 60 ) )
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else
		{
			if ( yawDelta > self.rightAimLimit )
				yawDelta = self.rightAimLimit;
			else if ( yawDelta < self.leftAimLimit )
				yawDelta = self.leftAimLimit;
			if ( pitchDelta > self.upAimLimit )
				pitchDelta = self.upAimLimit;
			else if ( pitchDelta < self.downAimLimit )
				pitchDelta = self.downAimLimit;
		}
		
		if ( firstFrame )
		{
			firstFrame = false;
		}
		else
		{
			yawDeltaChange = yawDelta - prevYawDelta;
			if ( abs( yawDeltaChange ) > maxYawDeltaChange )
				yawDelta = prevYawDelta + maxYawDeltaChange * sign( yawDeltaChange );
			
			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if ( abs( pitchDeltaChange ) > maxPitchDeltaChange )
				pitchDelta = prevPitchDelta + maxPitchDeltaChange * sign( pitchDeltaChange );
		}
		
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		
		updown = 0;
		leftright = 0;
		
		if ( yawDelta > 0 )
		{
			assert( yawDelta <= self.rightAimLimit );
			weight = yawDelta / self.rightAimLimit * self.a.aimweight;
			leftright = weight;
		}
		else if ( yawDelta < 0 )
		{
			assert( yawDelta >= self.leftAimLimit );
			weight = yawDelta / self.leftAimLimit * self.a.aimweight;
			leftright = -1 * weight;
		}
		
		if ( pitchDelta > 0 )
		{
			assert( pitchDelta <= self.upAimLimit );
			weight = pitchDelta / self.upAimLimit * self.a.aimweight;
			updown = weight;
		}
		else if ( pitchDelta < 0 )
		{
			assert( pitchDelta >= self.downAimLimit );
			weight = pitchDelta / self.downAimLimit * self.a.aimweight;
			updown = -1 * weight;
		}
		
		self SetAimAnimWeights( updown, leftright );
		wait(0.05);
	}
}

//setAnimAimWeight works just like setanimlimited on an imaginary anim node that affects the four aiming directions.
setAnimAimWeight(goalweight, goaltime)
{
	if ( !isdefined( goaltime ) || goaltime <= 0 )
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = goalweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = 0;
	}
	else
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = self.a.aimweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = int(goaltime * 20);
	}
	self.a.aimweight_t = 0;
}

incrAnimAimWeight()
{
	if ( self.a.aimweight_t < self.a.aimweight_transframes )
	{
		self.a.aimweight_t++;
		t = 1.0 * self.a.aimweight_t / self.a.aimweight_transframes;
		self.a.aimweight = self.a.aimweight_start * (1 - t) + self.a.aimweight_end * t;
	}
}

