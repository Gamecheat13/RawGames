#using_animtree ("generic_human");

// Grenade_return_kick
// Kicks or fumbles a grenade forwards from 32 units in front of the character.

main()
{
    self trackScriptState( "Grenade Kick Main", "code" );
	self endon("killanimscript");

	if (self.anim_pose=="stand")
	{
		self setFlaggedAnimKnoballRestart("kickanim",%stand_grenade_return_kick, %body, 1, .1, 1);
	}
	else
	{
		self setFlaggedAnimKnoballRestart("kickanim",%crouch_grenade_return_fumble, %body, 1, .1, 1);
	}

	self.anim_movement = "stop";
	// TODO: This should use DoNoteTracks.
	for (;;)
	{
		self waittill ("kickanim", note);
		switch (note)
		{
		case "end":
		case "finish":
			return;
		case "pickup":
			self pickUpGrenade();
		case "fire":
			self throwGrenade();
		case "anim_gunhand = \"left\"":
			[[anim.PutGunInHand]]("left");
			break;
		case "anim_gunhand = \"right\"":
			[[anim.PutGunInHand]]("right");
			break;
		default:
			println ("Unexpected note track "+note+" in grenade_return_kick "+self.anim_pose);
		}
	}
}
