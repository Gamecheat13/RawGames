#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include animscripts\utility;

#using_animtree ("generic_human");
main()
{
    self trackScriptState( "AIM MAIN", "code" );
	self endon("killanimscript");
	animscripts\utility::initialize("aim");

	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");
	}

	self SetPoseMovement("","stop");
	
	assertEX (self.anim_movement == "stop", "aim::main: About to call aim, movement is "+self.anim_movement);


	aim();
}

aimPose()
{
	start_aiming();
	POSE_keep_aiming(0,0);
}

aim(minTime, maxTime)
{
	prof_begin("aimer");
	times = defineMinAndMaxTimes(minTime, maxTime);
	start_aiming();
	keep_aiming(times["min"], times["max"]);
	prof_end("aimer");
}

defineMinAndMaxTimes(minTime, maxTime)
{
	times["min"] = minTime;
	times["max"] = maxTime;
	if (!isDefined(minTime))
	{
		times["min"] = 0.1;
	}
	if (!isDefined(maxTime))
	{
		times["max"] = 2;
		if (times["min"] > times["max"])
			times["max"] = times["min"];
	}
	return times;
}

dontaim()
{
	if (self.anim_alertness == "aiming")
	{
		// TODO Figure out what to do if we're walking or running here.
		if (self.anim_pose == "stand")
		{
			if ( (GetTime() < self.anim_woundedTime) || (self.anim_woundedAmount > 0.5) || self.anim_idleSet == "w" )
			{
				self.anim_idleSet = "w";	// "w" for wounded
				animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_aim2woundedalert, "stand", "stop", 0);
			}
			else if (self.anim_idleSet == "a")
			{
				rand = randomint (100);
				if (rand<50)
					animscripts\SetPoseMovement::PlayTransitionAnimation(%stand_aim2alert_1, "stand", "stop", 0);
				else
					animscripts\SetPoseMovement::PlayTransitionAnimation(%stand_aim2alert_2, "stand", "stop", 0);
			}
			else
			{
				assertEX(self.anim_idleSet == "b", "aim::dontaim: self.anim_idleSet isn't a or b ("+self.anim_pose+", "+self.anim_movement+")");
				animscripts\SetPoseMovement::PlayTransitionAnimation(%stand_aim2alertb, "stand", "stop", 0);
			}
		}
		else if ( (self.anim_pose == "crouch") || (self.anim_pose == "prone") ) // Prone actually never calls this function.
		{
			if (self.anim_idleSet == "a")
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2alert_A, "crouch", "stop", 0);
			}
			else
			{
				assertEX(self.anim_idleSet == "b", "aim::dontaim: self.anim_idleSet isn't a or b ("+self.anim_pose+", "+self.anim_movement+")");
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2alert_B, "crouch", "stop", 0);
			}
		}
		else
		{
	//		assertEX(0, "Unexpected anim_pose in aim::dontaim - "+self.anim_pose);
		}
	}
}


start_aiming()
{
	// Right now we can only aim when stopped.  This will probably not always be the case however
	assertEX (self.anim_movement == "stop", "aim::start_aiming "+self.anim_movement);
	self animscripts\face::SetIdleFace(anim.aimface);

	if (self.anim_alertness != "aiming")
	{
		if (self.anim_pose == "stand")
		{
			if (self.anim_idleSet == "w")
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_alert2aim, "stand", "stop", 1);
			}
			else if (self.anim_idleSet == "a")
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%stand_alert2aim, "stand", "stop", 1);
			}
			else
			{
				self.anim_idleSet = "b";	// Make sure
				animscripts\SetPoseMovement::PlayTransitionAnimation(%stand_alertb2aim, "stand", "stop", 1);
			}
		}
		else 
		if ( (self.anim_pose == "crouch") && (self.anim_special == "cover_crouch") )
		{
			animscripts\cover_crouch_no_wall::idleToAim();
		}
		else 
		if ( weaponAnims() != "pistol" && (self.anim_pose == "crouch" || self.anim_pose == "prone"))
		{
			if (self.anim_idleSet == "a")
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_alert2aim_A, "crouch", "stop", 1);
			}
			else
			{
				self.anim_idleSet = "b";	// Make sure
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_alertB2aim, "crouch", "stop", 1);
			}
		}
		else
		{
//			assertEX(0, "Unexpected anim_pose in aim::aim - "+self.anim_pose);
		}
		self.anim_alertness = "aiming";
	}
}

// Aims at the enemy or at nothing if there is no enemy.
keep_aiming(minTime, maxTime)
{
	times = defineMinAndMaxTimes(minTime, maxTime);
	if (isDefined(self.anim_enemyOverride))
	{
		target = self.anim_enemyOverride GetOrigin();
	}
	else
	{
		target = animscripts\utility::GetEnemyEyePos();
	}
	keepAimingAtTarget(target, times["min"], times["max"]);
}

// Aims at the enemy or at nothing if there is no enemy.
POSE_keep_aiming(minTime, maxTime)
{
	times = defineMinAndMaxTimes(minTime, maxTime);
	if (isDefined(self.anim_enemyOverride))
	{
		target = self.anim_enemyOverride GetOrigin();
	}
	else
	{
		target = animscripts\utility::GetEnemyEyePos();
	}
	POSE_keepAimingAtTarget(target, times["min"], times["max"]);
}

// Aims at the point it's told to aim at
POSE_keepAimingAtTarget(targetPoint, minTime, maxTime)
{
	self animscripts\face::SetIdleFace(anim.aimface);

	blendTime = 0.1; // was 0.05
	aimTime = 0.25;	// default value gets overridden by aimAtPose in most cases.
	
	// Right now we can only aim when stopped.  This will probably not always be the case however
	assertEX (self.anim_movement == "stop", "aim::keep_aiming "+self.anim_movement);
	assertEX (self.anim_alertness == "aiming", "aim::keep_aiming, anim_alertness is "+self.anim_alertness);

 	if (self.anim_pose == "stand")
 	{
		self setanimknob(%shoot, 1, blendTime, 1);
		self setanimknob(%stand_aim, 1, blendTime, 1);

		// Find the appropriate firing animation for this weapon
		anims = animscripts\weaponList::standAimShootAnims();
		self setaimanims(anims["aim_down"],anims["aim_straight"],anims["aim_up"],
						 anims["shoot_down"],anims["shoot_straight"],anims["shoot_up"] );
		aimTime = self aimAtPos (targetPoint);
 	}
 	else if (self.anim_pose == "crouch")
 	{
		self setanimknob(%shoot, 1, blendTime, 1);
		self setanimknob(%crouch_aim, 1, blendTime, 1);

		// Find the appropriate firing animation for this weapon
		anims = animscripts\weaponList::crouchAimShootAnims();
		self setaimanims(anims["aim_down"],anims["aim_straight"],anims["aim_up"],
						 anims["shoot_down"],anims["shoot_straight"],anims["shoot_up"] );
		aimTime = self aimAtPos (targetPoint);
 	}
	else	// Assume Prone
 	{
		self setanimknob(%prone_shoot_left, 1, 0.2, 0);	// Use paused shoot anim since we don't have a real aim anim.
		self setanimknob(%prone_shoot_right, 1, 0.2, 0);
		self setanimknob(%prone_shoot_straight, 1, 0.2, 0);
		thread animscripts\prone::ProneTurningThread(undefined, "End aim script");
 	}
	if (aimTime < minTime)
		aimTime = minTime;
	if (aimTime > maxTime)
		aimTime = maxTime;
	if (aimTime > 0)
		wait aimTime;
	prof_begin("aim redux");	
	self notify ("End aim script");	// Kills the prone turning thread.
	
}

// Aims at the point it's told to aim at
keepAimingAtTarget(targetPoint, minTime, maxTime)
{
	self animscripts\face::SetIdleFace(anim.aimface);

	blendTime = 0.2; // was 0.05
	aimTime = 0.25;	// default value gets overridden by aimAtPose in most cases.
	
	// Right now we can only aim when stopped.  This will probably not always be the case however
	assertEX (self.anim_movement == "stop", "aim::keep_aiming "+self.anim_movement);
	assertEX (self.anim_alertness == "aiming", "aim::keep_aiming, anim_alertness is "+self.anim_alertness);

 	if (self.anim_pose == "stand")
 	{
		self setanimknob(%shoot, 1, blendTime, 1);
		self setanimknob(%stand_aim, 1, blendTime, 1);

		// Find the appropriate firing animation for this weapon
		anims = animscripts\weaponList::standAimShootAnims();
		self setaimanims(anims["aim_down"],anims["aim_straight"],anims["aim_up"],
						 anims["shoot_down"],anims["shoot_straight"],anims["shoot_up"] );
		aimTime = self aimAtPos (targetPoint);
 	}
 	else if (self.anim_pose == "crouch")
 	{
		self setanimknob(%shoot, 1, blendTime, 1);
		self setanimknob(%crouch_aim, 1, blendTime, 1);

		// Find the appropriate firing animation for this weapon
		anims = animscripts\weaponList::crouchAimShootAnims();
		self setaimanims(anims["aim_down"],anims["aim_straight"],anims["aim_up"],
						 anims["shoot_down"],anims["shoot_straight"],anims["shoot_up"] );
		aimTime = self aimAtPos (targetPoint);
 	}
	else	// Assume Prone
 	{
		self setanimknob(%prone_shoot_left, 1, 0.2, 0);	// Use paused shoot anim since we don't have a real aim anim.
		self setanimknob(%prone_shoot_right, 1, 0.2, 0);
		self setanimknob(%prone_shoot_straight, 1, 0.2, 0);
		thread animscripts\prone::ProneTurningThread(undefined, "End aim script");
 	}
	if (aimTime < minTime)
		aimTime = minTime;
	if (aimTime > maxTime)
		aimTime = maxTime;
	if (aimTime > 0)
		wait aimTime;
	prof_begin("aim redux");	
	self notify ("End aim script");	// Kills the prone turning thread.
	self setanim(%shoot,0.0,0.2,1); // clean up and turn down shoot knob
	
}


aimAtTarget(targetPoint)
{
	blendTime = 0.2;
	
 	if (self.anim_pose == "stand")
 	{
		self setanimknob(%shoot, 1, blendTime, 1);
		self setanimknob(%stand_aim, 1, blendTime, 1);

		// Find the appropriate firing animation for this weapon
		anims = animscripts\weaponList::standAimShootAnims();
		self setaimanims(anims["aim_down"],anims["aim_straight"],anims["aim_up"],
						 anims["shoot_down"],anims["shoot_straight"],anims["shoot_up"] );
		aimTime = self aimAtPos (targetPoint);
 	}
 	else if (self.anim_pose == "crouch")
 	{
		self setanimknob(%shoot, 1, blendTime, 1);
		self setanimknob(%crouch_aim, 1, blendTime, 1);

		// Find the appropriate firing animation for this weapon
		anims = animscripts\weaponList::crouchAimShootAnims();
		self setaimanims(anims["aim_down"],anims["aim_straight"],anims["aim_up"],
						 anims["shoot_down"],anims["shoot_straight"],anims["shoot_up"] );
		aimTime = self aimAtPos (targetPoint);
 	}
	else	// Assume Prone
 	{
		self setanimknob(%prone_shoot_left, 1, 0.2, 0);	// Use paused shoot anim since we don't have a real aim anim.
		self setanimknob(%prone_shoot_right, 1, 0.2, 0);
		self setanimknob(%prone_shoot_straight, 1, 0.2, 0);
		thread animscripts\prone::ProneTurningThread(undefined, "End aim script");
 	}
}