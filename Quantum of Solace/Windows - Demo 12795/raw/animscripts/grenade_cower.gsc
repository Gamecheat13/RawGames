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
		self.a.grenadeCowerSide = "left";
	}
	else
	{
		crouch2hide =	%grenadehide_crouch2right;
		hideloop =		%grenadehide_right;
		self.a.grenadeCowerSide = "right";
	}

	if (self.a.pose == "crouch")
	{
		self setFlaggedAnimKnoballRestart("hideanim",crouch2hide, %body, 1, .1, 1);
	}
	else if (self.a.pose == "prone")
	{
		animscripts\stop::main();
		return;	// Should never get to here
	}
	else	// assume stand
	{
		self setFlaggedAnimKnoballRestart("hideanim",crouch2hide, %body, 1, .4, 1);
		
		self.a.pose = "crouch";
	}
	
	self.a.movement = "stop";
	
	animscripts\shared::DoNoteTracks("hideanim");
	self setAnimKnoballRestart(hideloop, %body, 1, .1, 1);
	self.a.StopCowering = ::StopCowering;
	for (;;)
	{
		wait 10;
	}

}


StopCowering()
{
	if ( self.a.script == "pain" || self.a.script == "death" )
	{
		self.a.StopCowering = animscripts\init::DoNothing;
		return;
	}
	if (self.a.grenadeCowerSide == "left")
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
	self.a.pose = "crouch";
	self.a.StopCowering = animscripts\init::DoNothing;
}

