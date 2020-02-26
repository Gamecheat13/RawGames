#include animscripts\anims;
#include animscripts\bigdog\bigdog_utility;

#using_animtree ("bigdog");

main()
{
	self endon("killanimscript");
	
	animscripts\bigdog\bigdog_utility::initialize("stop");
	
	idle();
}

end_script()
{
}

idle()
{
	self OrientMode( "face angle", self.angles[1] );
	self AnimMode( "zonly_physics" );

	while(1)
	{
		animName = animscripts\bigdog\bigdog_combat::getIdleAnimName();

		self SetFlaggedAnimRestart( "idle", animArray(animName), 1, 0.2, 1 );
		self animscripts\shared::DoNoteTracks( "idle" );
	}
}
