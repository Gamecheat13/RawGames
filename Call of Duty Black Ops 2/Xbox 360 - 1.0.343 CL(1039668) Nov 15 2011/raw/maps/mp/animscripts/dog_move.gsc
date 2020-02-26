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
	level.dog_sounds["close"].sound = "aml_dog_bark_close";
	level.dog_sounds["close"].soundLengthPlaceholder = 0.2;
	level.dog_sounds["close"].afterSoundWaitMin = 0.1;
	level.dog_sounds["close"].afterSoundWaitMax = 0.3;
	level.dog_sounds["close"].minRangeSqr = level.dog_sounds["close"].minRange * level.dog_sounds["close"].minRange;
	level.dog_sounds["close"].maxRangeSqr = level.dog_sounds["close"].maxRange * level.dog_sounds["close"].maxRange;
	
	level.dog_sounds["far"].minRange = 500;
	level.dog_sounds["far"].maxRange = 0;   // zero meaning infinity
	level.dog_sounds["far"].sound = "aml_dog_bark";
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

	do_movement = true;

	/#
		if( !debug_allow_movement() )
		{
			do_movement = false;
		}
	#/

	if ( isDefined( level.hostMigrationTimer ) )
	{
		do_movement = false;
	}

	if ( !isdefined( self.traverseComplete ) && !isdefined( self.skipStartMove ) && self.a.movement == "run" && do_movement )
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

	if ( do_movement )
	{
		if ( self.a.movement == "run" )
		{
			debug_anim_print("dog_move::main() - Setting move_run" );
			self setanimstate( "move_run" );
			maps\mp\animscripts\shared::DoNoteTracksForTime(0.1, "done");
			debug_anim_print("dog_move::main() - move_run wait 0.1 done " );
		}
		else
		{
			debug_anim_print("dog_move::main() - Setting move_start ");
			self setanimstate( "move_walk" );
		}
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
		do_movement = true;

		/#
			if( !debug_allow_movement() )
			{
				do_movement = false;
			}
		#/

		if ( isDefined( level.hostMigrationTimer ) )
		{
			do_movement = false;
		}

		if( !do_movement )
		{
			self SetAimAnimWeights( 0, 0 );
			self setanimstate( "stop_idle" );
			maps\mp\animscripts\shared::DoNoteTracks( "done" );
			continue;
		}

		if ( self.disableArrivals )
			self.stopAnimDistSq = 0;
		else
			self.stopAnimDistSq = level.dogStoppingDistSq;

		if ( self.a.movement == "run" )
		{
			debug_anim_print("dog_move::moveLoop() - Setting move_run" );
			self setanimstate( "move_run" );
			maps\mp\animscripts\shared::DoNoteTracksForTime(0.2, "done");
			debug_anim_print("dog_move::moveLoop() - move_run wait 0.2 done " );
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
	debug_anim_print("dog_move::startMove() - Setting move_start " );
	self setanimstate( "move_start" );
	maps\mp\animscripts\shared::DoNoteTracks("done");
	debug_anim_print("dog_move::startMove() - move_start notify done." );
	
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