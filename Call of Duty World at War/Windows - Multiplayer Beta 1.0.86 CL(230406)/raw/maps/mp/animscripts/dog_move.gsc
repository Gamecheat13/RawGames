#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\shared;

//#using_animtree ("dog");

setup_sound_variables()
{
	// these should be ordered by distance far to close
	level.dog_sounds["far"] = spawnstruct();
	level.dog_sounds["close"] = spawnstruct();
	
	level.dog_sounds["close"].minRange = 0;
	level.dog_sounds["close"].maxRange = 500;
	level.dog_sounds["close"].sound = "anml_dog_bark_close";
	level.dog_sounds["close"].soundLengthPlaceholder = 0.2;
	level.dog_sounds["close"].afterSoundWaitMin = 0.1;
	level.dog_sounds["close"].afterSoundWaitMax = 0.3;
	level.dog_sounds["close"].minRangeSqr = level.dog_sounds["close"].minRange * level.dog_sounds["close"].minRange;
	level.dog_sounds["close"].maxRangeSqr = level.dog_sounds["close"].maxRange * level.dog_sounds["close"].maxRange;
	
	level.dog_sounds["far"].minRange = 500;
	level.dog_sounds["far"].maxRange = 0;   // zero meaning infinity
	level.dog_sounds["far"].sound = "anml_dog_bark";
	level.dog_sounds["far"].soundLengthPlaceholder = 0.2;
	level.dog_sounds["far"].afterSoundWaitMin = 0.1;
	level.dog_sounds["far"].afterSoundWaitMax = 0.3;
	level.dog_sounds["far"].minRangeSqr = level.dog_sounds["far"].minRange * level.dog_sounds["far"].minRange;
	level.dog_sounds["far"].maxRangeSqr = level.dog_sounds["far"].maxRange * level.dog_sounds["far"].maxRange;
	
	
}

main()
{
	self endon("killanimscript");

	debug_anim_print("dog_move::main()" );
	self SetAimAnimWeights( 0, 0 );

	if ( !isdefined( self.traverseComplete ) && !isdefined( self.skipStartMove ) && self.a.movement == "run" )
	{	
		self startMove();
		blendTime = 0;
	}
	else
	{
		blendTime = 0.2;
	}

	self.traverseComplete = undefined;
	self.skipStartMove = undefined;

	if ( self.a.movement == "run" )
	{
		if ( self need_to_turn() )
		{
			self turn();
		}
		else
		{
			debug_anim_print("dog_move::main() - Setting move_run" );
			self setanimstate( "move_run" );
			maps\mp\animscripts\shared::DoNoteTracksForTime(0.1, "done");
			debug_anim_print("dog_move::main() - move_run wait 0.1 done " );
		}
	}
	else
	{
		debug_anim_print("dog_move::main() - Setting move_start ");
		self setanimstate( "move_walk" );
	}
	
	self thread maps\mp\animscripts\dog_stop::lookAtTarget( "normal" );
	
	while ( 1 )
	{	
		self moveLoop();
		
		if ( self.a.movement == "run" )
		{
			if ( self.disableArrivals == false )
			self thread stopMove();
	
			// if a "run" notify is received while stopping, clear stop anim and go back to moveLoop
			self waittill( "run" );
		}
	}
}

moveLoop()
{
	self endon( "killanimscript" );
	self endon( "stop_soon" );

	while (1)
	{
		if ( self.disableArrivals )
			self.stopAnimDistSq = 0;
		else
			self.stopAnimDistSq = level.dogStoppingDistSq;

		if ( self.a.movement == "run" )
		{
			if ( self need_to_turn() )
			{
				self turn();
			}
			else
			{
				debug_anim_print("dog_move::moveLoop() - Setting move_run" );
				self setanimstate( "move_run" );
				maps\mp\animscripts\shared::DoNoteTracksForTime(0.2, "done");
				debug_anim_print("dog_move::moveLoop() - move_run wait 0.2 done " );
			}
		}
		else
		{
			assert( self.a.movement == "walk" );

			debug_anim_print("dog_move::moveLoop() - Setting move_walk " );
			self setanimstate( "move_walk" );
			maps\mp\animscripts\shared::DoNoteTracksForTime(0.1, "done");
			debug_anim_print("dog_move::moveLoop() - move_walk wait 0.2 done " );
		}
	}
}

startMoveTrackLookAhead()
{
	self endon("killanimscript");
	for ( i = 0; i < 2; i++ )
	{
		lookaheadAngle = vectortoangles( self.lookaheaddir );
		self set_orient_mode( "face angle", lookaheadAngle );
	}
}

startMove()
{
	// just use code movement
	if ( self need_to_turn() )
	{
		self turn();
	}
	else
	{
		debug_anim_print("dog_move::startMove() - Setting move_start " );
		self setanimstate( "move_start" );
		maps\mp\animscripts\shared::DoNoteTracks("done");
		debug_anim_print("dog_move::startMove() - move_start notify done." );
	}
	self animMode( "none" );
	self set_orient_mode( "face motion" );
}

		
stopMove()
{
	self endon( "killanimscript" );
	self endon( "run" );

	debug_anim_print("dog_move::stopMove() - Setting move_stop" );
	self setanimstate( "move_stop" );
	maps\mp\animscripts\shared::DoNoteTracks("done");
	debug_anim_print("dog_move::stopMove() - move_stop notify done." );
}

getEnemyDistanceSqr() 
{
	if ( isdefined(self.enemy) )
	{
		return DistanceSquared( self.origin, self.enemy.origin );
	}
	
	return (10000 * 10000);
}

getSoundKey( distanceSqr ) 
{
	keys = getarraykeys(level.dog_sounds);
	for ( i = 0; i < keys.size; i++ )
	{
		sound_set = level.dog_sounds[keys[i]];
		
		if ( sound_set.minRangeSqr > distanceSqr )
			continue;
		
		if ( sound_set.maxRangeSqr && sound_set.maxRangeSqr < distanceSqr )
			continue;
			
		return keys[i];
	}	
	return keys[keys.size - 1];
}

get_turn_angle_delta(print_it)
{
	currentYaw = AngleClamp180(self.angles[1]);
	lookaheadDir = self.lookaheaddir;
	lookaheadAngles = vectortoangles(lookaheadDir);
	lookaheadYaw = AngleClamp180(lookaheadAngles[1]);
	deltaYaw = lookaheadYaw - currentYaw;

	preDeltaYaw = deltaYaw;
	if ( deltaYaw > 180 )
		deltaYaw -= 360;
	if ( deltaYaw < -180 )
		deltaYaw += 360;
		
	return deltaYaw;
}

need_to_turn()
{
	deltaYaw = self get_turn_angle_delta();
	
	if ( (deltaYaw > level.dogTurnAngle) || (deltaYaw < (-1 * level.dogTurnAngle)) )
	{
		debug_turn_print("need_to_turn check: " + self.lookaheaddist );
		if ( self.lookaheaddist > level.dogTurnMinDistanceToGoal )
		{
			debug_turn_print("need_to_turn: " + deltaYaw +" YES" );
			return true;
		}
	} 

	return false;
}

need_to_turn_around( deltaYaw )
{
	if ( (deltaYaw > level.dogTurnAroundAngle) || (deltaYaw < (-1 * level.dogTurnAroundAngle)) )
	{
		debug_turn_print("need_to_turn_around: " + deltaYaw +" YES" );
		return true;
	} 
	
	debug_turn_print("need_to_turn_around: " + deltaYaw +" NO" );
	return false;
}

do_turn_anim( stopped_anim, run_anim, wait_time, run_wait_time )
{
	speed = length( self getvelocity() );
	
	do_anim = stopped_anim;
	
	if ( level.dogRunTurnSpeed < speed )
	{
		do_anim = run_anim;
		wait_time = run_wait_time;
	}	
	
	debug_anim_print("dog_move::do_turn_anim() - Setting " + do_anim );
	self setanimstate( do_anim );
	maps\mp\animscripts\shared::DoNoteTracksForTime( run_wait_time, "done");
	debug_anim_print("dog_move::turn_around_right() - done with " + do_anim + " wait time " + run_wait_time );
}

turn_left()
{
	self do_turn_anim( "move_turn_left", "move_run_turn_left", 0.5, 0.5 );
}

turn_right()
{
	self do_turn_anim( "move_turn_right", "move_run_turn_right", 0.5, 0.5 );
}

turn_around_left()
{
	self do_turn_anim( "move_turn_around_left", "move_run_turn_around_left", 0.5, 0.7 );
}

turn_around_right()
{
	self do_turn_anim( "move_turn_around_right", "move_run_turn_around_right", 0.5, 0.7 );
}

move_out_of_turn()
{
	if ( self.a.movement == "run" )
	{
		debug_anim_print("dog_move::move_out_of_turn() - Setting move_run" );
		self setanimstate( "move_run" );
		maps\mp\animscripts\shared::DoNoteTracksForTime(0.1, "done");
		debug_anim_print("dog_move::move_out_of_turn() - move_run wait 0.1 done " );
	}
	else
	{
		debug_anim_print("dog_move::move_out_of_turn() - Setting move_start ");
		self setanimstate( "move_walk" );
	}
}

turn()
{
	deltaYaw = self get_turn_angle_delta();
	
	if ( need_to_turn_around( deltaYaw ) )
	{
		self turn_around();
		return;
	}	
	currentYaw = AngleClamp180(self.angles[1]);
	self animMode( "zonly_physics" );
	
	// need to force the orient angle to the currentYaw here
	// the desired angles may already be updated for the "turn"
	// and cause a doubling of the rotation.  Telling it to face
	// current yaw resets the desired angles and uses only anim deltas
	self set_orient_mode( "face angle", currentYaw );

	debug_turn_print("turn deltaYaw: " + deltaYaw );
	
	if ( deltaYaw > level.dogTurnAngle )
	{
			debug_turn_print( "turn left", true);
			self turn_left();
	}
	else
	{
			debug_turn_print( "turn right", true);
			self turn_right();
	}

	self set_orient_mode( "face motion" );
	self animMode( "none" );

	move_out_of_turn();
}

turn_around()
{
	currentYaw = AngleClamp180(self.angles[1]);
	self animMode( "zonly_physics" );
	
	// need to force the orient angle to the currentYaw here
	// the desired angles may already be updated for the "turn"
	// and cause a doubling of the rotation.  Telling it to face
	// current yaw resets the desired angles and uses only anim deltas
	self set_orient_mode( "face angle", currentYaw );

	deltaYaw = self get_turn_angle_delta( true );
	//println("turning around " + Gettime() );

	debug_turn_print( "turn_around deltaYaw: " + deltaYaw );
	
	// pick either
	if (deltaYaw > 177 || deltaYaw < -177)
	{
		if ( randomint(2) == 0 )
		{
			debug_turn_print( "turn_around random right", true);
			self turn_around_right();
		}
		else
		{
			debug_turn_print( "turn_around random left", true);
			self turn_around_left();
		}
	}
	else if ( deltaYaw > level.dogTurnAroundAngle )
	{
			debug_turn_print( "turn_around left", true);
			self turn_around_left();
	}
	else
	{
			debug_turn_print( "turn_around right", true);
			self turn_around_right();
	}

	self set_orient_mode( "face motion" );
	self animMode( "none" );

	move_out_of_turn();
}