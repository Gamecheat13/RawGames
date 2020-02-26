// Jump_over_high_wall.gsc
// Makes the character dive over a high wall.  Designed for getting bad guys into levels - it looks bad from the back.

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
	self traverseMode("nogravity");
	self traverseMode("noclip");

    // orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( IsDefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self ClearAnim(%stand_and_crouch, 0.1);
	self SetFlaggedAnimKnobAllRestart("diveanim", animArray("jump_over_high_wall", "move"), %body, 1, .1, 1);
	self PlaySound("dive_wall");

	self waittillmatch("diveanim", "gravity on");
	self traverseMode("nogravity");

	self waittillmatch("diveanim", "noclip");
	self traverseMode("noclip");

	self waittillmatch("diveanim", "gravity on");
	self traverseMode("gravity");

	self animscripts\shared::DoNoteTracks("diveanim");
	self.a.movement = "run";
	self.a.alertness = "casual";
//	self SetAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
}

