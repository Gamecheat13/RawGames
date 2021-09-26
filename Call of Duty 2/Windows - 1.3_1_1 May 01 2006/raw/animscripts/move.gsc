#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#using_animtree ("generic_human");

combatBreaker()
{
	self endon("killanimscript");
	while (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
	{
		if (seekingCoverInMyFov())
			break;
		wait (0.25);
	}
	self thread moveAgain();
}

moveAgain()
{
	self notify("killanimscript");
	animscripts\move::main();
}

seekingCoverInMyFov()
{
	// Run back to cover if you're not in your goalradius
	if (distance(self.origin, self.node.origin) > self.goalradius)
		return true;
	if (distance(self.origin, self.node.origin) < 80)
		return true;
//	print3d(self.node.origin, "node for " + self getentnum(), (1,1,0));
	enemyAngles = vectorToAngles(self.origin - self.enemy.origin);
	enemyForward = anglesToForward(enemyAngles);
	nodeAngles = vectorToAngles(self.origin - self.node.origin);
	nodeForward = anglesToForward(nodeAngles);
	return (vectorDot(enemyForward, nodeforward) > 0.1);
}

RunBreaker()
{
	self endon("killanimscript");
	for (;;)
	{
		if (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
		{
			if (!seekingCoverInMyFov())
				break;
		}
		wait (0.25);
	}
	self thread moveAgain();
}



main()
{
	prof_begin("move");
	self endon("killanimscript");
	
	if ( isdefined(self.cliffDeath) && (self.cliffDeath == true) )
		return;

	if (weaponAnims() == "panzerfaust" && isdefined(self.anim_dropPanzerNow))
		dropPanz();
	
	[[self.exception_move]]();

    self trackScriptState( "Move Main", "code" );
	

	previousScript = self.anim_script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
    animscripts\utility::initialize("move");
    
	// If I'm wounded, I act differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::move("move::main");
	}

	if (self.moveMode == "run")
	{
		// Say something
		switch (previousScript)
		{
		case "concealment_crouch":
		case "concealment_prone":
		case "concealment_stand":
		case "cover_crouch":
		case "cover_left":
		case "cover_prone":
		case "cover_right":
		case "cover_stand":
		case "cover_wide_left":
		case "cover_wide_right":
		case "stalingrad_cover_crouch":
		case "hide":
		case "turret":
			// Leaving cover.  Say something like "cover me".
			self animscripts\battleChatter_ai::evaluateMoveEvent (true);
			break;

		default:
			// Say random shit.
			self animscripts\battleChatter_ai::evaluateMoveEvent (false);
			break;
		}
	}
	self animscripts\battlechatter::playBattleChatter();

	self.currentLimpAnim = undefined;
	
	for (;;)
	{
		prof_begin("move");

		self animscripts\face::SetIdleFaceDelayed(anim.alertface); // set default value

		if (self.moveMode == "run")
		{
			self.move_handler = self animscripts\run::MoveRun_handler();
		}
		else
		{
			assert(self.moveMode == "walk");
			
			self.move_handler = self animscripts\walk::MoveWalk_handler();
		}

		[[self.move_handler]]();
	}
}
