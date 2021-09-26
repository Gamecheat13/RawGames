#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

MoveWalk_handler()
{
	// Decide what pose to use
	desiredPose = self animscripts\utility::choosePose();

	return Move_handler(desiredPose);
}

MoveStandWalkCombat2()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",self.walk_combatanim2, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

MoveStandWalkCombat()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",self.walk_combatanim, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

MoveStandWalk2()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",self.walk_noncombatanim2, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

MoveStandWalk()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",self.walk_noncombatanim, %body, 1, 1.2, self.animplaybackrate);
	self waittill ("walkdone");
}

MoveStandWalkWounded()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",%wounded_walk_loop, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

StandWalkCombat1()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",%stand_walk_combat_loop_01, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

StandWalkCombat2()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",%stand_walk_combat_loop_02, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

StandWalkCombat3()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",%stand_walk_combat_loop_03, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

CrouchWalk2()
{
	self endon("movemode");
	self setflaggedanimknoball("walkdone",%crouchwalk_loop, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

ProneWalk2()
{
	self.anim_movement = "walk";
	self setflaggedanimknoball("walkdone",%prone_crawl, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

MoveStand_handler()
{
	if ( (isDefined(self.walk_combatanim)) && (self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_combatanim2)) )
			return ::MoveStandWalkCombat2;
		else
			return ::MoveStandWalkCombat;
	}
	else if ( (isDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_noncombatanim2)) )
			return ::MoveStandWalk2;
		else
			return ::MoveStandWalk;
	}
	else if ( (GetTime() < self.anim_woundedTime) || (self.anim_woundedAmount > 0.5) )	// Limp if you're more than 1/2 wounded.
	{
		return ::MoveStandWalkWounded;
	}
	else
	{
		// If we're not moving far, we "shuffle", which means we don't have to play an intro animation.
		// The requirement that we're standing should go away once we make crouching versions of the shuffle animations.
		if ( self withinApproxPathDist(anim.maxShuffleDistance) && (self.anim_movement == "stop") && (!self animscripts\utility::IsInCombat()) )
		{
			return Shuffle_handler();
		}
		else
		{
			handler = StandWalk_handler();
			if (isdefined(handler))
				return handler;
		
			rand = randomint (100);
			if ( rand < 40 )
				return ::StandWalkCombat1;
			else if ( rand < 70 )
				return ::StandWalkCombat2;
			else
				return ::StandWalkCombat3;
		}
	}
}

Move_handler(desiredPose)
{
	switch (desiredPose)
	{
	case "stand":
		return MoveStand_handler();

	case "crouch":
		handler = CrouchWalk_handler();
		if (isdefined(handler))
			return handler;

		return ::CrouchWalk2;

	default:
		assert(desiredPose == "prone");
		handler = ProneWalk_handler();
		if (isdefined(handler))
			return handler;

		return ::ProneWalk2;
	}
}

PriceLimp()
{
	if (self.anim_pose == "wounded")
	{
		// Price shouldn't be wounded, so pop him into a non-wounded pose
		switch (self.anim_wounded)
		{
		case "crawl":
		case "knees":
			self.anim_pose = "crouch";
			break;
		case "stand":
		default:
			self.anim_pose = "stand";
			break;
		}
	}
	self SetPoseMovement("stand","walk");

	assertEX(self.anim_movement == "walk", "walk::main "+self.anim_movement);
	assertEX(self.anim_pose == "stand", "walk::main "+self.anim_pose);

	self setanimknob(%wounded_walk_loop, 1, .1, 1);
	wait 10;	// Arbitrary wait, so the script doesn't execute every frame.
}


CheckShuffleEnd()
{
	self endon("killanimscript");
	self endon("movemode");
	
	for (;;)
	{
		wait 0.05;
		if (self withinApproxPathDist(anim.maxShuffleDistance))
			continue;
		self notify("movemode");
	}	
}


Shuffle_a()
{
	self endon("movemode");
	thread CheckShuffleEnd();
	self.anim_idleSet = "a";
	self setflaggedanimknoball("shuffleanim",%stand_alerta_shuffle_forward, %body, 1, .05, 1);
	self animscripts\shared::DoNoteTracks ("shuffleanim");
	self notify("movemode");
}


Shuffle_b()
{
	self endon("movemode");
	thread CheckShuffleEnd();
	self setflaggedanimknoball("shuffleanim",%stand_alertb_shuffle_forward, %body, 1, .05, 1);
	self animscripts\shared::DoNoteTracks ("shuffleanim");
	self notify("movemode");
}


Shuffle_handler()
{
	handler = StandStop_handler();
	if (isdefined(handler))
		return handler;

	if (self.anim_idleSet == "a" || self.anim_idleSet == "none" || self.anim_idleSet == "w" )
		return ::Shuffle_a;
	else
		return ::Shuffle_b;
}
