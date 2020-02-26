#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;

MoveRun()
{	
	if( IsDefined( self.needs_run_update ) && !self.needs_run_update )
	{
		wait( 0.05 );
		return;
	}

	if ( IsDefined( self.is_inert ) && self.is_inert )
	{
		wait( 0.1 );
		return;
	}
	
	self SetAimAnimWeights( 0, 0 );
	self SetAnimStateFromSpeed();
	maps\mp\animscripts\zm_shared::DoNoteTracksForTime( 0.2, "move_anim" );
	
	self.needs_run_update = false;

}


SetAnimStateFromSpeed()
{
	animstate = self append_missing_legs_suffix( "zm_move_" + self.zombie_move_speed );

	if ( isdefined( self.a.gib_ref ) && self.a.gib_ref == "no_legs" )
	{
		animstate = "zm_move_stumpy";
	}

	self SetAnimStateFromASD( animstate );
}
