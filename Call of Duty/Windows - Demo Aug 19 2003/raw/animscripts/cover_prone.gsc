#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Cover Prone Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_prone");
	self cover_prone();
}

cover_prone()
{
	nodeOrigin = animscripts\utility::GetNodeOrigin();
	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		animscripts\wounded::SubState_WoundedGetup("pose be wounded", "prone");
	}

	// Say random shit.
	animscripts\combat_say::generic_combat();

	self [[anim.SetPoseMovement]]("prone","stop");

	for (;;)
	{
		// Make sure we're in the right place.
		self teleport (nodeOrigin);

		self animscripts\combat::Rechamber();

		// TODO: Hide for a while here, longer if suppressed.

		// Do prone combat, if you can.
		self OrientMode ("face enemy"); 
        ////		animscripts\combat::ProneCombat();
        self thread animscripts\prone::ProneRangeCombat("cover prone jumps here");
        return;
	}
}					
