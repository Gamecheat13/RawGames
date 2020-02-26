#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\shared;

main()
{
	self endon("killanimscript");

	debug_anim_print("dog_turn::main()" );
	self SetAimAnimWeights( 0, 0 );

	self.safeToChangeScript = false;

	deltaYaw = self GetDeltaTurnYaw();

	if ( need_to_turn_around( deltaYaw ) )
	{
		turn_180( deltaYaw );
	}
	else
	{
		turn_90( deltaYaw );
	}

	move_out_of_turn();
	
	self.skipStartMove = true;
	self.safeToChangeScript = true;
}

need_to_turn_around( deltaYaw )
{
	angle = GetDvarfloat( "dog_turn180_angle" );
	
	if ( ( deltaYaw > angle ) || ( deltaYaw < ( -1 * angle ) ) )
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

//	self setanimstate( do_anim );
//	maps\mp\animscripts\shared::DoNoteTracksForTime( run_wait_time, "done" );

	self SetAnimStateFromASD( do_anim );
	maps\mp\animscripts\zm_shared::DoNoteTracksForTime( run_wait_time, "move_turn" );


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

turn_180_left()
{
	self do_turn_anim( "move_turn_around_left", "move_run_turn_around_left", 0.5, 0.7 );
}

turn_180_right()
{
	self do_turn_anim( "move_turn_around_right", "move_run_turn_around_right", 0.5, 0.7 );
}

move_out_of_turn()
{
	if ( self.a.movement == "run" )
	{
		debug_anim_print("dog_move::move_out_of_turn() - Setting move_run" );
		//self setanimstate( "move_run" );
		//maps\mp\animscripts\shared::DoNoteTracksForTime(0.1, "done");

		self SetAnimStateFromASD( "zm_move_run" );
		maps\mp\animscripts\zm_shared::DoNoteTracksForTime( 0.1, "move_run" );


		debug_anim_print("dog_move::move_out_of_turn() - move_run wait 0.1 done " );
	}
	else
	{
		debug_anim_print("dog_move::move_out_of_turn() - Setting move_start ");
		//self setanimstate( "move_walk" );

		self SetAnimStateFromASD( "zm_move_walk" );
		maps\mp\animscripts\zm_shared::DoNoteTracks( "move_walk" );
	}
}

turn_90( deltaYaw )
{
	self animMode( "zonly_physics" );
	debug_turn_print("turn_90 deltaYaw: " + deltaYaw );
	
	if ( deltaYaw > GetDvarfloat( "dog_turn90_angle" ) )
	{
		debug_turn_print( "turn_90 left", true);
		self turn_left();
	}
	else
	{
		debug_turn_print( "turn_90 right", true);
		self turn_right();
	}
}

turn_180( deltaYaw )
{
	self animMode( "zonly_physics" );
	debug_turn_print( "turn_180 deltaYaw: " + deltaYaw );
	
	// pick either
	if ( deltaYaw > 177 || deltaYaw < -177 )
	{
		if ( randomint(2) == 0 )
		{
			debug_turn_print( "turn_around random right", true );
			self turn_180_right();
		}
		else
		{
			debug_turn_print( "turn_around random left", true );
			self turn_180_left();
		}
	}
	else if ( deltaYaw > GetDvarfloat( "dog_turn180_angle" ) )
	{
		debug_turn_print( "turn_around left", true );
		self turn_180_left();
	}
	else
	{
		debug_turn_print( "turn_around right", true );
		self turn_180_right();
	}
}
