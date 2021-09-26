#using_animtree("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();

	// It'd be nice if I had an animation to get to prone without moving...
	self.desired_anim_pose = "prone";
	self.anim_movement = "stop";

	turret = self GetTurret();
	turret thread init(self);
	thread animscripts\mg42\common::main(::DoShoot, ::DoRecover, ::DoAim, turret);
}

DoShoot(turret)
{
	self setTurretAnim(%proneMG42gunner_fire);
	self setAnimKnobRestart(%proneMG42gunner_fire, 1, 0.2, 1);

	TurretDoShoot(turret);
}

DoRecover(turret)
{
	thread TurretDoRecover(turret);

	self setTurretAnim(%proneMG42gunner_recover);
	self setFlaggedAnimKnobRestart("animdone", %proneMG42gunner_recover, 1, 0.2, 1);

	self waittill("animdone");
}

DoAim(turret)
{
	TurretDoAim(turret);

	self setTurretAnim(%proneMG42gunner_aim);
	self setAnimKnobRestart(%proneMG42gunner_aim, 1, 0.2, 1);
}

#using_animtree("mg42");

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

	turret setAnimKnobRestart(%proneMG42gun_fire_forward_medium);

	for (;;)
	{
		turret ShootTurret();
		wait 0.1;
	}	
}

TurretDoRecover(turret)
{
	turret setAnimKnobRestart(%proneMG42gun_recover_forward_medium);
}

TurretDoAim(turret)
{
	turret setAnimKnobRestart(%proneMG42gun_aim_forward_medium);
}
