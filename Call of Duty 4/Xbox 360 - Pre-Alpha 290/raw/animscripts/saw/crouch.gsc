#using_animtree("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();

	// It'd be nice if I had an animation to get to stand without moving...
	self.a.movement = "stop";
	

	turret = self getTurret();
	turret thread init( self );
	thread animscripts\saw\common::main( ::DoShoot, undefined, ::DoAim, turret );
}

DoShoot( turret )
{
	self setTurretAnim( %crouchSAWgunner_aim );
	self setAnimKnobRestart( %crouchSAWgunner_aim, 1, 0, 1 );

	TurretDoShoot(turret);
}

DoAim( turret )
{
	TurretDoAim( turret );

	self setTurretAnim( %crouchSAWgunner_aim );
	self setAnimKnobRestart( %crouchSAWgunner_aim, 1, 0, 0 );	// Rate 0 so it doesn't shake
}

init( owner )
{
	self UseAnimTree(#animtree);

	self endon("death");
	owner waittill( "killanimscript" ); // code

	self stopUseAnimTree();
}

TurretDoShoot( turret )
{
	self endon("killanimscript"); // code

	turret endon("turretstatechange"); // code or script

//	turret setAnimKnobRestart( %standMG42gun_fire_foward );

	for (;;)
	{
		turret ShootTurret();
		wait 0.1;
	}
}

TurretDoAim(turret)
{
//	turret setAnimKnobRestart( %standMG42gun_fire_foward, 1, 0.15, 0 );
}
