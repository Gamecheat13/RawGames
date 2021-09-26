// step_down.gsc
// Makes the character step down off a ledge.  Currently the ledge is assumed to be 36 units.

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self.anim_movement = "walk";
	self.anim_alertness = "alert";
	self traverseMode("nogravity");
//	self traverseMode("noclip"); // Testing to see if a clip brush will stop regular pathfinding and force the traverse script to be used.
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert (isdefined( startnode ));
    self OrientMode( "face angle", startnode.angles[1] );

	
	self setFlaggedAnimKnoballRestart("stepanim",%step_down_low_wall, %body, 1, .1, 1);
	self waittillmatch("stepanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("stepanim");
	self setAnimKnobAllRestart(%crouchwalk_loop, %body, 1, 0.1, 1);
}
