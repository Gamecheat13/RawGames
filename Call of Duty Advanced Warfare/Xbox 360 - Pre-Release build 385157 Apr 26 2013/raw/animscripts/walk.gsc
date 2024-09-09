#include animscripts\SetPoseMovement;
#include animscripts\notetracks;
#include animscripts\Utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );

MoveWalk()
{
	// Decide what pose to use
	preferredPose = undefined;
	if ( IsDefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) > 64 * 64 )
		preferredPose = "stand";
		
	desiredPose = [[ self.choosePoseFunc ]]( preferredPose );

	switch( desiredPose )
	{
	case "stand":
		if ( StandWalk_Begin() )
			return;

		if ( IsDefined( self.walk_overrideanim ) )
		{
			animscripts\move::MoveStand_MoveOverride( self.walk_overrideanim, self.walk_override_weights );
			return;
		}

		DoWalkAnim( GetWalkAnim( "straight" ) );
		break;

	case "crouch":
		if ( CrouchWalk_Begin() )
			return;

		DoWalkAnim( GetWalkAnim( "crouch" ) );
		break;

	default:
		assert( desiredPose == "prone" );
		if ( ProneWalk_Begin() )
			return;

		self.a.movement = "walk";
		DoWalkAnim( GetWalkAnim( "prone" ) );
		break;
	}
}

DoWalkAnimOverride( walkAnim )
{
	self endon( "movemode" );
	self ClearAnim( %combatrun, 0.6 );
	self SetAnimKnobAll( %combatrun, %body, 1, 0.5, self.movePlaybackRate );

	if ( isarray( self.walk_overrideanim ) )
	{
		if ( IsDefined( self.walk_override_weights ) )
			moveAnim = choose_from_weighted_array( self.walk_overrideanim, self.walk_override_weights );	
		else
			moveAnim = self.walk_overrideanim[ randomint( self.walk_overrideanim.size ) ];
	}
	else
	{
		moveAnim = self.walk_overrideanim;
	}

	self SetFlaggedAnimKnob( "moveanim", moveAnim, 1, 0.2 );
	animscripts\shared::DoNoteTracks( "moveanim" );
}

GetWalkAnim( desiredAnim )
{
	if ( self.stairsState == "up" )
		return GetMoveAnim( "stairs_up" );
	else if ( self.stairsState == "down" )
		return GetMoveAnim( "stairs_down" );

	walkAnim = GetMoveAnim( desiredAnim );

	if ( isarray( walkAnim ) )
		walkAnim = walkAnim[ randomint( walkAnim.size ) ];
		
	return walkAnim;	
}

DoWalkAnim( walkAnim )
{
	self endon( "movemode" );
	
	rate = self.movePlaybackRate;
	
	if ( self.stairsState != "none" )
		rate *= 0.6;

	if ( self.a.pose == "stand" )
	{
		if ( IsDefined( self.enemy ) )
		{
			self /*thread */animscripts\cqb::CQBTracking();
			// (we don't use %body because that would reset the aiming knobs)
			self SetFlaggedAnimKnobAll( "walkanim", animscripts\cqb::DetermineCQBAnim(), %walk_and_run_loops, 1, 1, rate, true );
		}
		else
		{
			self SetFlaggedAnimKnobAll( "walkanim", walkAnim, %body, 1, 1, rate, true );
		}

		self animscripts\run::SetMoveNonForwardAnims( GetMoveAnim( "move_b" ), GetMoveAnim( "move_l" ), GetMoveAnim( "move_r" ) );
		self thread animscripts\run::SetCombatStandMoveAnimWeights( "walk" );
	}
	else
	{
		self SetFlaggedAnimKnobAll( "walkanim", walkAnim, %body, 1, 1, rate, true );

		self animscripts\run::SetMoveNonForwardAnims( GetMoveAnim( "move_b" ), GetMoveAnim( "move_l" ), GetMoveAnim( "move_r" ) );
		self thread animscripts\run::SetCombatStandMoveAnimWeights( "walk" );
	}

	self DoNoteTracksForTime( 0.2, "walkanim" );

	//self thread animscripts\run::StopShootWhileMovingThreads();
	self animscripts\run::SetShootWhileMoving( false );
}

