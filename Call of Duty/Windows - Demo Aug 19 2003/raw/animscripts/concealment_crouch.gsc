#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Concealment Crouch Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("concealment_crouch");

    // JBW - why are we never stopped when we get here?
	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded", "crouch");
	}

	// Say random shit.
	animscripts\combat_say::generic_combat();

	self [[anim.SetPoseMovement]]("crouch","stop");

	self thread animscripts\cover_crouch::CoverCrouch("Concealment_crouch called");
    return;
}					
