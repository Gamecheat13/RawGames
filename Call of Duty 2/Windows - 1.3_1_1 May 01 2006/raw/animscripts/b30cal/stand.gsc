#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();

	// It'd be nice if I had an animation to get to stand without moving...
	self.anim_movement = "stop";

	turret = self GetTurret();
	turret thread init(self);
	thread animscripts\b30cal\common::main(::DoShoot, undefined, ::DoAim, turret);
}

DoShoot(turret)
{
	self setTurretAnim(%stand30calgunner_fire);
	self setAnimKnobRestart(%stand30calgunner_fire, 1, 0.05, 1);

	TurretDoShoot(turret);
}

DoAim(turret)
{
	TurretDoAim(turret);

	self setTurretAnim(%stand30calgunner_fire);
	self setAnimKnobRestart(%stand30calgunner_fire, 1, 0.15, 0);	// Rate 0 so it doesn't shake
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

TurretDoAim(turret)
{
	turret setAnimKnobRestart(%turret30cal_shoot_auto_straight, 1, 0.15, 0);
}
