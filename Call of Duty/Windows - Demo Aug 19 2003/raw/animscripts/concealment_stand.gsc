#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Standing Concealment Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("concealment_stand");

	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::combat("concealment_stand::main");
	}

	// Say random shit.
	animscripts\combat_say::generic_combat();

	[[anim.locspam]]("cons1");

	for (;;)
	{
		self [[anim.SetPoseMovement]]("stand","stop");
		[[anim.locspam]]("cons3");

		self animscripts\face::SetIdleFace(anim.aimface);
		self animscripts\aim::aim(0.25);
		[[anim.locspam]]("cons4");
		if ( animscripts\utility::sightCheckNode () )
		{
			animscripts\combat::ShootVolley(0);	// Twice, because it doesn't fire many bullets in one go
		}
		animscripts\combat::Reload(0);
		[[anim.locspam]]("cons6");
	}
}
