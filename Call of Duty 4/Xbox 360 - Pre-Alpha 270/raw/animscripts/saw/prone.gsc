#using_animtree("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();

	// It'd be nice if I had an animation to get to prone without moving...
	self.desired_anim_pose = "prone";
	self.a.movement = "stop";

	turret = self GetTurret();
	turret thread init( self );
	thread animscripts\saw\common::main( ::DoShoot, undefined, ::DoAim, turret );
}

DoShoot( turret )
{
	self setTurretAnim( %proneSAWgunner_aim );
	self setAnimKnobRestart( %proneSAWgunner_aim, 1, 0, 1 );

	TurretDoShoot(turret);
}

DoAim( turret )
{
	TurretDoAim( turret );

	self setTurretAnim( %proneSAWgunner_aim );
	self setAnimKnobRestart( %proneSAWgunner_aim, 1, 0, 0 );
}

init( owner )
{
	self UseAnimTree(#animtree);
	
	self endon("death");
	owner waittill("killanimscript"); // code

	self stopUseAnimTree();
}

TurretDoShoot( turret )
{
	self endon("killanimscript"); // code

	turret endon("turretstatechange"); // code or script

//	turret setAnimKnobRestart( %proneMG42gun_fire_forward_medium );

	for (;;)
	{
		turret ShootTurret();
		wait 0.1;
	}	
}

TurretDoRecover(turret)
{
//	turret setAnimKnobRestart(%proneMG42gun_recover_forward_medium);
}

TurretDoAim(turret)
{
//	turret setAnimKnobRestart(%proneMG42gun_aim_forward_medium);
}
