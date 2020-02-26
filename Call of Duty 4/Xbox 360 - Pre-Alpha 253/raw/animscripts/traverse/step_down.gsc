// step_down.gsc
// Makes the character step down off a ledge.  Currently the ledge is assumed to be 36 units.

#using_animtree ("generic_human");


main()
{
	if ( self.type == "human" )
		step_down_human();
	else if ( self.type == "dog" )
		step_down_dog();
}


step_down_human()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self.a.movement = "walk";
	self.a.alertness = "alert";
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


#using_animtree ("dog");

step_down_dog()
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );

	self clearanim(%root, 0.2);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_down_40"], 1, 0.2, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );
	
	self clearanim(anim.dogTraverseAnims["jump_down_40"], 0);	// start run immediately
	self traverseMode("gravity");
	self.traverseComplete = true;
}