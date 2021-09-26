#using_animtree ("generic_human");

main ( )
{
    self trackScriptState( "GrenadeCower Main", "code" );
	self endon("killanimscript");
	animscripts\utility::initialize("grenadecower");

	// We have 0.3 seconds before the initialize function zeros out all animations, so use some of that to 
	// get some variation in timing.  This allows groups of AI not to all crouch at exactly the same moment.
	wait ( randomfloat(0.25) );	// NB This will wait up to but not including 0.25 seconds.
	
	// For now, we invent the position of the grenade, since we can't get it from code (yet?)
	if (randomint(100) < 50)
	{
		crouch2hide =	%grenadehide_crouch2left;
		hideloop =		%grenadehide_left;
		self.anim_grenadeCowerSide = "left";
	}
	else
	{
		crouch2hide =	%grenadehide_crouch2right;
		hideloop =		%grenadehide_right;
		self.anim_grenadeCowerSide = "right";
	}

	if (self.anim_pose == "crouch")
	{
		self setFlaggedAnimKnoballRestart("hideanim",crouch2hide, %body, 1, .1, 1);
	}
	else if (self.anim_pose == "prone")
	{
		animscripts\stop::main();
		return;	// Should never get to here
	}
	else	// assume stand
	{
		self setFlaggedAnimKnoballRestart("hideanim",crouch2hide, %body, 1, .4, 1);
		
		self.anim_pose = "crouch";
	}
	
	self.anim_movement = "stop";
	
	animscripts\shared::DoNoteTracks("hideanim");
	self setAnimKnoballRestart(hideloop, %body, 1, .1, 1);
	self.anim_StopCowering = ::StopCowering;
	for (;;)
	{
		wait 10;
	}

}


StopCowering()
{
	if ( self.anim_script == "pain" || self.anim_script == "death" )
	{
		self.anim_StopCowering = animscripts\init::DoNothing;
		return;
	}
	if (self.anim_grenadeCowerSide == "left")
	{
		hideloop =		%grenadehide_left;
		hide2crouch =	%grenadehide_left2crouch;
	}
	else
	{
		hideloop =		%grenadehide_right;
		hide2crouch =	%grenadehide_right2crouch;
	}

	self setAnimKnoball(hideloop, %body, 1, .4, 1);
	wait ( randomfloat(0.25) );	// NB This will wait up to but not including 0.25 seconds.
	self setFlaggedAnimKnoballRestart("hideanim",hide2crouch, %body, 1, .4, 1);
	self.anim_pose = "crouch";
	self.anim_StopCowering = animscripts\init::DoNothing;
}

