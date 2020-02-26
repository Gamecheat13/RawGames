#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

MoveWalk()
{
	// Decide what pose to use
	desiredPose = self animscripts\utility::choosePose();

	return MoveWalkInPose(desiredPose);
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
	self.a.movement = "walk";
	self setflaggedanimknoball("walkdone",%prone_crawl, %body, 1, 1.2, 1);
	self waittill ("walkdone");
}

MoveStand()
{
	if ( (isDefined(self.walk_combatanim)) && (self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_combatanim2)) )
			MoveStandWalkCombat2();
		else
			MoveStandWalkCombat();
	}
	else if ( (isDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(100);
		if ( (rand < 20) && (isDefined(self.walk_noncombatanim2)) )
			MoveStandWalk2();
		else
			MoveStandWalk();
	}
	else
	{
		// If we're not moving far, we "shuffle", which means we don't have to play an intro animation.
		// The requirement that we're standing should go away once we make crouching versions of the shuffle animations.
		if ( self withinApproxPathDist(anim.maxShuffleDistance) && (self.a.movement == "stop") && (!self animscripts\utility::IsInCombat()) && animscripts\utility::getQuadrant( self getMotionAngle() ) == "front" )
		{
			Shuffle();
		}
		else
		{
			if ( BeginStandWalk() )
				return;
		
			rand = randomint (100);
			if ( rand < 40 )
				StandWalkCombat1();
			else if ( rand < 70 )
				StandWalkCombat2();
			else
				StandWalkCombat3();
		}
	}
}

MoveWalkInPose( desiredPose )
{
	switch ( desiredPose )
	{
	case "stand":
		MoveStand();
		break;

	case "crouch":
		if ( BeginCrouchWalk() )
			return;

		CrouchWalk2();
		break;

	default:
		assert(desiredPose == "prone");
		if ( BeginProneWalk() )
			return;

		ProneWalk2();
		break;
	}
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
	self.a.idleSet = "a";
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


Shuffle()
{
	if ( BeginStandStop() )
		return;

	if ( self.a.idleSet == "a" || self.a.idleSet == "none" || self.a.idleSet == "w" )
		Shuffle_a();
	else
		Shuffle_b();
}
