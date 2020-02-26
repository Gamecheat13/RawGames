//#include maps\_utility;
//#include animscripts\utility;
//#include common_scripts\utility;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\shared;

//#using_animtree ("dog");

setup_sound_variables()
{
	// these should be ordered by distance far to close
	level.dog_sounds["far"] = spawnstruct();
	level.dog_sounds["close"] = spawnstruct();
	
//	level.dog_sounds["close"].key = "close";
	level.dog_sounds["close"].minRange = 0;
	level.dog_sounds["close"].maxRange = 500;
	level.dog_sounds["close"].sound = "anml_dog_bark_close";
	level.dog_sounds["close"].soundLengthPlaceholder = 0.2;
	level.dog_sounds["close"].afterSoundWaitMin = 0.1;
	level.dog_sounds["close"].afterSoundWaitMax = 0.3;
	level.dog_sounds["close"].minRangeSqr = level.dog_sounds["close"].minRange * level.dog_sounds["close"].minRange;
	level.dog_sounds["close"].maxRangeSqr = level.dog_sounds["close"].maxRange * level.dog_sounds["close"].maxRange;
	
//	level.dog_sounds["far"].key = "far";
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

////	self clearanim( %root, 0.2 );
////	self clearanim(%german_shepherd_run_stop, 0);

	self thread randomSoundDuringRunLoop();

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

////	self clearanim(%german_shepherd_run_start, 0);

	if ( self.a.movement == "run" )
	{
////		weights = undefined;
////		weights = self getRunAnimWeights();
	
////		self setanimrestart( %german_shepherd_run, weights[ "center" ], blendTime, 1 );
////		self setanimrestart(%german_shepherd_run_lean_L, weights["left"], 0.1, 1);
////		self setanimrestart(%german_shepherd_run_lean_R, weights["right"], 0.1, 1);
////		self setflaggedanimknob( "dog_run", %german_shepherd_run_knob, 1, blendTime, self.moveplaybackrate );
////		animscripts\shared::DoNoteTracksForTime(0.1, "dog_run");
		
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
////		self setflaggedanimrestart( "dog_walk", %german_shepherd_walk, 1, 0.2, self.moveplaybackrate );
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
////			self clearanim( %german_shepherd_run_stop, 0.1 );
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
////			weights = self getRunAnimWeights();

////			self clearanim( %german_shepherd_walk, 0.3 );

////			self setanim(%german_shepherd_run, weights["center"], 0.2, 1);
////			self setanim(%german_shepherd_run_lean_L, weights["left"], 0.2, 1);
////			self setanim(%german_shepherd_run_lean_R, weights["right"], 0.2, 1);
////			self setflaggedanimknob( "dog_run", %german_shepherd_run_knob, 1, 0.2, self.moveplaybackrate );
		
////		animscripts\shared::DoNoteTracksForTime(0.2, "dog_run");
		if ( self need_to_turn() )
		{
			self turn();
		}
		else
		{
//			//println("moving " + Gettime() );
			debug_anim_print("dog_move::moveLoop() - Setting move_run" );
			self setanimstate( "move_run" );
			maps\mp\animscripts\shared::DoNoteTracksForTime(0.2, "done");
			debug_anim_print("dog_move::moveLoop() - move_run wait 0.2 done " );
		}
	}
	else
	{
			assert( self.a.movement == "walk" );

////		self clearanim( %german_shepherd_run_knob, 0.3 );
////			self setflaggedanim( "dog_walk", %german_shepherd_walk, 1, 0.2, self.moveplaybackrate );
////			animscripts\shared::DoNoteTracksForTime( 0.2, "dog_walk" );
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
////	self setanimrestart( %german_shepherd_run_start, 1, 0.2, 1 );

////	self setflaggedanimknobrestart( "dog_prerun", %german_shepherd_run_start_knob, 1, 0.2, self.moveplaybackrate );
	
////	self animscripts\shared::DoNoteTracks( "dog_prerun" );


//	//println("startMove " + Gettime() );
	if ( self need_to_turn() )
	{
		self turn();
	}
	else
	{
//		//println("moving " + Gettime() );
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

//	//println("stopMove " + Gettime() );
////	self clearanim( %german_shepherd_run_knob, 0.1 );
////	self setflaggedanimrestart( "stop_anim", %german_shepherd_run_stop, 1, 0.2, 1 );
////	self animscripts\shared::DoNoteTracks( "stop_anim" );
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

randomSoundDuringRunLoop()
{
	self endon( "killanimscript" );
//	while ( 1 )
//	{
//		self.enemyDistanceSqr =  getEnemyDistanceSqr();
//		
//		key = getSoundKey( self.enemyDistanceSqr );
//		assert(isdefined(key));
//		sound_set = level.dog_sounds[key];
//		assert(isdefined(sound_set));
//		
//		self playsound( sound_set.sound ); // play_sound_on_tag( "anml_dog_bark", "tag_eye" );
//		// play_sound_on_tag would wait for the sound to be done before returning
//		// emulating this with an additional wait
//		// when this is ported over to client side we will be able to go back to the
//		// old system
//		wait (sound_set.soundLengthPlaceholder);
//			
//		wait( randomfloatrange( sound_set.afterSoundWaitMin, sound_set.afterSoundWaitMax ) );
//	}
}

get_turn_angle_delta(print_it)
{
	currentYaw = AngleClamp180(self.angles[1]);
	lookaheadDir = self.lookaheaddir;
	lookaheadAngles = vectortoangles(lookaheadDir);
	lookaheadYaw = AngleClamp180(lookaheadAngles[1]);
	deltaYaw = lookaheadYaw - currentYaw;

//	deltaYaw = AngleClamp180( lookaheadYaw - currentYaw );
	
	preDeltaYaw = deltaYaw;
	if ( deltaYaw > 180 )
		deltaYaw -= 360;
	if ( deltaYaw < -180 )
		deltaYaw += 360;
		
//	if ( isdefined(print_it) )
//	{
//		println( "deltaYaw pre: " + preDeltaYaw );
//		println( "deltaYaw: " + deltaYaw + "  angleclamp " + AngleClamp180( lookaheadYaw - currentYaw ));
//		println( "angle_delta: currentYaw " + currentYaw + " lookAhead " + lookaheadYaw + " deltaYaw " + deltaYaw);
//	}	
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

	//println("need_to_turn: " + deltaYaw +" NO" );
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

	//debug_current_yaw_line_debug(150);
	//println("done turning " + Gettime() );
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

//	debug_current_yaw_line_debug(150);
	//println("done turnging around " + Gettime() );
	self set_orient_mode( "face motion" );
	self animMode( "none" );

	move_out_of_turn();
}

debug_current_yaw_line_debug( duration )
{
/#		
	currentYawColor = (0,1,1);
	currentYaw = AngleClamp180(self.angles[1]);
	pos1 = (self.origin[0],self.origin[1],self.origin[2] + 34);
	pos2 = pos1 + common_scripts\utility::vectorscale( anglestoforward(self.angles), 20);
	line(pos1, pos2, currentYawColor, 0.3, 1, duration);
	println(  "turn done " + getTime() + " cur: " + currentYaw );
#/
}

debug_print( text )
{
}
