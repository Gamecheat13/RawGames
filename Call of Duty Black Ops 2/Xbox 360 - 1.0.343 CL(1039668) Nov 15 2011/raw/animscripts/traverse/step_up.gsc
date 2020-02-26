#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	if ( self.type == "human" )
		step_up_human();
	else if ( self.isdog )
		dog_jump_up( 40, 3 );
}

step_up_human()
{
	PrepareForTraverse();

	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self.a.movement = "walk";
	self.a.alertness = "casual";	
	self traverseMode("nogravity");
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert (IsDefined( startnode ));
    self OrientMode( "face angle", startnode.angles[1] );

	
	self SetFlaggedAnimKnobAllRestart("stepanim", animArray("step_up", "move"), %body, 1, .1, 1);
	self waittillmatch("stepanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("stepanim");
	self SetAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
}

