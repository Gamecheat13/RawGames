#using_animtree ("generic_human");




main()
{
    self trackScriptState( "Grenade Kick Main", "code" );
	self endon("killanimscript");

	if (self.a.pose=="stand")
	{
		self setFlaggedAnimKnoballRestart("kickanim",%stand_grenade_return_kick, %body, 1, .1, 1);
	}
	else
	{
		self setFlaggedAnimKnoballRestart("kickanim",%crouch_grenade_return_fumble, %body, 1, .1, 1);
	}

	self.a.movement = "stop";
	
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

			break;
		case "anim_gunhand = \"right\"":

			break;
		default:
			println ("Unexpected note track "+note+" in grenade_return_kick "+self.a.pose);
		}
	}
}
