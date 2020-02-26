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
	self OrientMode( "face current" );
	self AnimMode( "zonly_physics" );

	while(1)
	{
		animName = "idle" + animSuffix();

		self SetFlaggedAnimRestart( "idle", animArray(animName), 1, 0.2, 1 );
		self animscripts\shared::DoNoteTracks( "idle" );
	}
}
