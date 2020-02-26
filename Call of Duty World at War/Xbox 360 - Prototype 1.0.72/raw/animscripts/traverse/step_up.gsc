// step_up.gsc
// Makes the character step up onto a ledge.  Currently the ledge is assumed to be 36 units.

#using_animtree ("generic_human");

main()
{
	if ( self.type == "human" )
		step_up_human();
	else if ( self.type == "dog" )
		step_up_dog();
}

step_up_human()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self.a.movement = "walk";
	self.a.alertness = "casual";	
	self traverseMode("nogravity");
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert (isdefined( startnode ));
    self OrientMode( "face angle", startnode.angles[1] );

	
	self setFlaggedAnimKnoballRestart("stepanim",%step_up_low_wall, %body, 1, .1, 1);
	self waittillmatch("stepanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("stepanim");
	self setAnimKnobAllRestart(self.a.crouchrunanim, %body, 1, 0.1, 1);
}


#using_animtree ("dog");

step_up_dog()
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );

	self clearanim(%root, 0.2);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_up_40"], 1, 0.2, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );
	
	self clearanim(anim.dogTraverseAnims["jump_up_40"], 0);	// start run immediately
	self traverseMode("gravity");
	self.traverseComplete = true;
}