#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Cover Wide Left Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_wide_left");

	// Make sure we're facing the opposite direction from the node.
	cornerAngle = animscripts\utility::GetNodeDirection();
	//self.desiredAngle = cornerAngle;
	self OrientMode( "face angle", cornerAngle+180 );
	nodeOrigin = animscripts\utility::GetNodeOrigin();

	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");
	}

	// Make sure the cover animation part of the tree is switched on
	self setanimknoball(%cover, %root, 1, .1, 1);

	for (;;)
	{
		self.anim_special = "cover_left";
		self.anim_idleset = "a";
		// Make sure we're facing the right way, in the right place.
		//self.desiredAngle = cornerAngle;
		self OrientMode( "face angle", cornerAngle+180 );
		self teleport (nodeOrigin);

		// Make sure we're in the right pose
// 		if (self isStanceAllowed("stand"))
// 			animscripts\cover_left::CornerStandUp();
// 		else
// 			animscripts\cover_left::CornerCrouchDown();

		// Say random shit.
		animscripts\combat_say::generic_combat();

		self animscripts\combat::Rechamber();

		// Wait a little while
		rand = randomfloat(1);
		hideBetweenShots(rand);

		while (self isSuppressed())
		{
			hideBetweenShots(1);
		}

		// Stand up and jump out
// 		animscripts\cover_left::CornerStandUp();
// 		animscripts\cover_left::CornerRambo();
	}
}

hideBetweenShots(timeToWait)
{
	if (self isStanceAllowed("stand"))
		self setanimknoball(%cornerstandpose_right, %look_straight, 1, .1, 1);
	else
		self setanimknoball(%cornercrouchpose_right, %look_straight, 1, .1, 1);
	wait timeToWait;
}
