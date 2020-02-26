#include animscripts\SetPoseMovement;
#include animscripts\Utility;
#include animscripts\anims;
#include maps\_utility;
#using_animtree ("generic_human");

MoveWalk()
{
	/#
	self animscripts\debug::debugPushState( "MoveWalk" );
	#/

	// Decide what pose to use
	desiredPose = self animscripts\utility::choosePose();
	// ALEXP_TODO: why is this not changing the pose itself?

	switch ( desiredPose )
	{
	case "stand":
		if ( BeginStandWalk() )
		{
			/#
			self animscripts\debug::debugPopState( "MoveWalk", "already walking" );
			#/
			return;
		}

		walkAnim = getStandWalkAnim();
		DoWalkAnim( walkAnim );
		break;

	case "crouch":
		if ( BeginCrouchWalk() )
		{
			/#
			self animscripts\debug::debugPopState( "MoveWalk", "already walking" );
			#/
			return;
		}

		DoWalkAnim( animArray("walk_f") );
		break;

	default:
		assert(desiredPose == "prone");
		if ( BeginProneWalk() )
		{
			/#
			self animscripts\debug::debugPopState( "MoveWalk", "already walking" );
			#/
			return;
		}

		self.a.movement = "walk";
		DoWalkAnim( animArray("combat_run_f") );
		break;
	}

	/#
	self animscripts\debug::debugPopState( "MoveWalk" );
	#/
}

DoWalkAnim( walkAnim )
{
	self endon("movemode");
		
	if ( self.a.pose == "stand" )
		self animscripts\run::UpdateRunWeightsOnce( walkAnim, animArray("tactical_walk_b"), animArray("tactical_walk_r"), animArray("tactical_walk_l") );
	else
		self animscripts\run::UpdateRunWeightsOnce( walkAnim, animArray("walk_b"), animArray("walk_l"), animArray("walk_r") );
	
	self animscripts\shared::DoNoteTracksForTime( 0.2, "walkanim" );
}

getStandWalkAnim()
{
	if( (IsDefined(self.walk_combatanim)) && (self animscripts\utility::IsInCombat()) )
	{
		return self.walk_combatanim;
	}
	else if( (IsDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) )
	{
		return self.walk_noncombatanim;
	}
	else
	{
		if( self.a.pose == "stand" )
			return animArray("tactical_walk_f");
		else
			return animArray("walk_f");
	}

}


