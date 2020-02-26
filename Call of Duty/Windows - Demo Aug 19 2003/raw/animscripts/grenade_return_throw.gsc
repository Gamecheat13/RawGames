#using_animtree ("generic_human");

// Grenade_return_throw
// Picks up a grenade from 32 units in front of the character, and throws it.

main()
{
 	self trackScriptState( "Cover Return Throw Main", "code" );
	self endon("killanimscript");

	while (!self canPickUpGrenade())
		wait 0.05;

	if (self.anim_pose == "stand")
	{
		self setFlaggedAnimKnoballRestart("throwanim",%stand_grenade_return_throw, %body, 1, .3, 1);
	}
	else
	{
		self setFlaggedAnimKnoballRestart("throwanim",%crouch_grenade_return_throw, %body, 1, .3, 1);
	}
	[[anim.PutGunInHand]]("left");

	self waittillmatch("throwanim", "pickup");
	self pickUpGrenade();
	self orientMode("face current");
	self waittillmatch("throwanim", "rotation start");
	self orientMode("face default");
	self animscripts\face::SayGenericDialogue("grenadeattack");
	self waittillmatch("throwanim", "fire");
	self throwGrenade();
	self waittillmatch("throwanim", "finish");
	[[anim.PutGunInHand]]("right");
	// TODO Figure out how to make whatever animation I play next, blend in over 0.5 seconds or so.
}
