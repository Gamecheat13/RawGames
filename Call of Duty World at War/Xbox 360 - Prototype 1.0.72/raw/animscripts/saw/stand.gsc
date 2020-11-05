#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();

	// It'd be nice if I had an animation to get to stand without moving...
	self.a.movement = "stop";

	turret = self getTurret();
	turret thread init( self );
	thread animscripts\saw\common::main( ::DoShoot, undefined, ::DoAim, turret );
}

DoShoot( turret )
{
	self setTurretAnim( %standSAWgunner_aim );
	self setAnimKnobRestart( %standSAWgunner_aim, 1, 0.05, 1 );

	TurretDoShoot(turret);
}

DoAim(turret)
{
	TurretDoAim(turret);

	self setTurretAnim( %standSAWgunner_aim );
	self setAnimKnobRestart( %standSAWgunner_aim, 1, 0.15, 0 );	// Rate 0 so it doesn't shake
}

#using_animtree("mg42");

init( owner )
{
	self UseAnimTree(#animtree);

	owner waittill( "killanimscript" ); // code

//	self clearanim(%root, 0);

	self stopUseAnimTree();
}

TurretDoShoot( turret )
{
	self endon("killanimscript"); // code

	turret endon("turretstatechange"); // code or script

	turret setAnimKnobRestart( %standMG42gun_fire_foward );

	for (;;)
	{
		turret ShootTurret();
		wait 0.1;
	}
}

TurretDoAim(turret)
{
	turret setAnimKnobRestart( %standMG42gun_fire_foward, 1, 0.15, 0 );
}