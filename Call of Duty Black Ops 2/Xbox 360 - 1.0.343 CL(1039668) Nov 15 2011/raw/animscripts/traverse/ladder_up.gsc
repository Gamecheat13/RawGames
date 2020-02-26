// ladder_up.gsc
// Climbs a ladder of any height by using a looping animation, and gets off at the top.

#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	PrepareForTraverse();

	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
//	self traverseMode("nogravity");
	self traverseMode("noclip");

	startAnim = animArray("ladder_start", "move");
	climbAnim = animArray("ladder_climb", "move");
	endAnim = animArray("ladder_end", "move");

    // orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( IsDefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self animscripts\traverse\shared::TraverseStartRagdollDeath();

	self SetFlaggedAnimKnobAllRestart("climbanim",startAnim, %body, 1, .1, 1);
	self animscripts\shared::DoNoteTracks("climbanim");
	self SetFlaggedAnimKnobAllRestart("climbanim",climbAnim, %body, 1, .1, 1);

	endAnimDelta = GetMoveDelta (endAnim, 0, 1);
	
	endNode = self getnegotiationendnode();
	assert( IsDefined( endnode ) );
	endPos =  endnode.origin - endAnimDelta + (0,0,1);	// 1 unit padding
	
	cycleDelta = GetMoveDelta (climbAnim, 0, 1);
	climbRate = cycleDelta[2] /  getanimlength(climbAnim);
	//("ladder_up: about to start climbing.  Height to climb: " + (endAnimDelta[2] + endPos[2] - self.origin[2]) );#/

	climbingTime = ( endPos[2] - self.origin[2] ) / climbRate;
	if (climbingTime > 0)
	{
		self animscripts\shared::DoNoteTracksForTime(climbingTime, "climbanim");
//	println ("elapsed ", (GetTime() - timer) * 0.001);
		self SetFlaggedAnimKnobAllRestart("climbanim",endAnim, %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("climbanim");
	}

	self animscripts\traverse\shared::TraverseStopRagdollDeath();

	self traverseMode("gravity");
	self.a.movement = "run";
	self.a.pose = "crouch";
	self.a.alertness = "alert";
	self SetAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
	//("ladder_up: all done");#/
}

