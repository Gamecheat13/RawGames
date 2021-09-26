#using_animtree("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();

	// It'd be nice if I had an animation to get to prone without moving...
	// I do.  Should I do anything with it?
	self.desired_anim_pose = "prone";
	self.anim_movement = "stop";

	turret = self GetTurret();
	turret thread init(self);
	thread animscripts\b30cal\common::main(::DoShoot, ::DoRecover, ::DoAim, turret);
}

DoShoot(turret)
{
	self setTurretAnim(%prone30calgunner_fire);
	self setAnimKnobRestart(%prone30calgunner_fire, 1, 0.2, 1);

	TurretDoShoot(turret);
}

DoRecover(turret)
{
	self endon("killanimscript"); // code

	thread TurretDoRecover(turret);

	self setTurretAnim(%prone30calgunner_fire);
	self setFlaggedAnimKnobRestart("animdone", %prone30calgunner_fire, 1, 0.15, 0);

	self waittill("animdone");
}

DoAim(turret)
{
	TurretDoAim(turret);

	self setTurretAnim(%prone30calgunner_fire);
	self setAnimKnobRestart(%prone30calgunner_fire, 1, 0.15, 0);
}

#using_animtree("30cal");

init(owner)
{
	self UseAnimTree(#animtree);

	owner waittill("killanimscript"); // code

//	self clearanim(%root, 0);

	self stopuseanimtree();
}

TurretDoShoot(turret)
{
	self endon("killanimscript"); // code

	turret endon("turretstatechange"); // code or script

	turret setAnimKnobRestart(%turret30cal_shoot_auto_straight);

	for (;;)
	{
		turret ShootTurret();
		wait 0.1;
	}	
}

TurretDoRecover(turret)
{
	turret setAnimKnobRestart(%turret30cal_shoot_auto_straight, 1, 0.15, 0);
}

TurretDoAim(turret)
{
	turret setAnimKnobRestart(%turret30cal_shoot_auto_straight, 1, 0.15, 0);
}
