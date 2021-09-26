#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

HackTrackCustomTarget ( )
{
	self endon("killanimscript");
    self endon ("killHackTrackCustomTarget");
	self endon ("end_sequence");

    for (;;)
    {    
        enemyAngle = GetEnemyAngle();
        self OrientMode ("face angle", enemyAngle); 
        wait .05;
    }
}


main()
{
	self endon("killanimscript");
	self endon ("end_sequence");
    animscripts\utility::initialize("stalingrad_cover_crouch");

	/#thread [[anim.println]] ("starting stalingrad_cover_crouch");#/
	self animMode ("angle deltas");	// Stops movement deltas from taking effect, so that he'll stay on his node.

	/#thread [[anim.locspam]]("scc1");#/
	if (self.anim_pose == "wounded")
	{
		animscripts\wounded::MagicallyGetBetter("stalingrad_cover_crouch");
	}

	if (isDefined(self.customnode))
	{
		nodeOrigin = self.customnode.origin;
		nodeAngle = self.customnode.angles[1];
		nodeType = self.customnode.type;
		/#thread [[anim.println]] ("Stalingrad_cover_crouch: custom node is type "+nodeType+".");#/
	}
	else
	{
		/#thread [[anim.println]] ("Stalingrad_cover_crouch: No node specified for custom animscript.");#/
		nodeOrigin = self.origin;
		nodeAngle = self.angles[1];
		nodeType = "none";	// Make something up...
	}

	// Valid values of customAttackSpeed are "hide", "normal" and "fast"
	if (!isDefined(self.customAttackSpeed))
	{
		self.customAttackSpeed = "normal";
	}

	if ( isDefined(self.hasWeapon) && !self.hasWeapon )
	{
		/#thread [[anim.locspam]]("scc2a");#/
		cower_nogun();
	}
	else 
	{
		/#thread [[anim.locspam]]("scc2b");#/
		if (isAI(self))	// Is this necessary?
		{
			thread animscripts\utility::drawDebugLine(self GetEye(), GetEnemyPos(), (0,1,0), 20);
		}

		self OrientMode( "face angle", nodeAngle );
		if (nodeType=="cover_stand")
		{
			self SetPoseMovement("stand","stop");
			/#thread [[anim.locspam]]("scc3a");#/
		}
		else if (nodeType=="cover_crouch")
		{
			self SetPoseMovement("crouch","stop");
			/#thread [[anim.locspam]]("scc3b");#/
		}
		else
		{
			if (isAI(self))	// Is this necessary?
			{
				pose = animscripts\utility::choosePose(self.anim_pose);
				self SetPoseMovement(pose,"stop");
			}
			else
			{
				self SetPoseMovement("","stop");
			}
			/#thread [[anim.locspam]]("scc3c");#/
		}


        self trackScriptState( "Stalingrad Cover Crouch", "code" );

		for (;;)
		{
			/#thread [[anim.println]]("stalingrad_cover_crouch: main loop start");#/

            //            self . scriptState = "stalingrad cover with gun";

			thread animscripts\utility::drawDebugLine(self GetEye(), GetEnemyPos(), (0,1,0), 10);

			while ( !(self isSuppressed()) && (self.bulletsInClip>0) && (!self.anim_needsToRechamber||randomint(100)>50) && (self.customAttackSpeed!="hide") )
			{
				/#thread [[anim.println]]("stalingrad_cover_crouch: preparing to shoot");#/
//				thread animscripts\utility::drawDebugLine(self GetEye(), GetEnemyPos(), (1,0,0), 4);
                
                if ( isDefined ( self . customtarget ) )
                    self thread HackTrackCustomTarget ();
				enemyAngle = GetEnemyAngle();
				self OrientMode ("face angle", enemyAngle); 

				/#thread [[anim.assert]] (self.anim_movement == "stop", "stalingrad_cover_crouch: About to call aim, movement is "+self.anim_movement);#/
				self animscripts\aim::start_aiming();
				self animscripts\aim::keepAimingAtTarget(GetEnemyPos(), 0, 2);
				/#thread [[anim.locspam]]("scc4");#/
				enemyAngle = GetEnemyAngle();
				self OrientMode ("face angle", enemyAngle); 
				/#thread [[anim.assert]](self.anim_alertness == "aiming", "cover_crouch::cover_crouch: About to call ShootVolley but not aiming");#/
				/#thread [[anim.println]]("stalingrad_cover_crouch: shooting");#/
				animscripts\combat::ShootVolley();
                self notify ("killHackTrackCustomTarget");
				/#thread [[anim.locspam]]("scc5");#/
			}
			/#thread [[anim.println]]("stalingrad_cover_crouch: shooting finished");#/


//			if ( !isDefined(self.customFastAttack) || (self.CustomFastAttack==false) )
			if ( self.customAttackSpeed!="fast" && ( nodeType=="cover_crouch" || nodeType=="cover_stand") )
			{
				/#thread [[anim.println]]("stalingrad_cover_crouch: ducking");#/
				if ( animscripts\combat::NeedsToRechamber() || animscripts\combat::NeedsToReload(0) )
				{
					/#thread [[anim.locspam]]("scc6");#/
					duckBetweenShots();
					/#thread [[anim.locspam]]("scc7");#/
					self animscripts\combat::Reload(0);
					self animscripts\combat::Rechamber();
					/#thread [[anim.locspam]]("scc8");#/
				}

				idle_start(nodeAngle);
				/#thread [[anim.locspam]]("scc9");#/

				idle(nodeAngle);
				/#thread [[anim.locspam]]("scc10");#/

				while (self.customAttackSpeed=="hide")
				{
					idle(nodeAngle);
					/#thread [[anim.locspam]]("scc11");#/
				}

				enemyAngle = GetEnemyAngle();
				self OrientMode ("face angle", enemyAngle); 


				if (nodeType=="cover_stand")
				{
					self animscripts\SetPoseMovement::PlayTransitionAnimation(%crouchhide2stand, "stand", "stop", 1);
					self.anim_special = "none";
				}
				else //ie (nodeType=="cover_crouch")
				{
					idleToCrouchAim();
				}
				/#thread [[anim.println]]("stalingrad_cover_crouch: ducking finished");#/
			}
			else
			{
				if ( self.bulletsInClip==0 || self.anim_needsToRechamber )
				{
					self animscripts\combat::Reload(0);
					self animscripts\combat::Rechamber();
					/#thread [[anim.locspam]]("scc12");#/
				}
				else
				{
					// Just pause momentarily for effect.
					self animscripts\aim::start_aiming();	// In case we got here without calling this, which can happen.
					self animscripts\aim::keepAimingAtTarget(GetEnemyPos(), 0.2, 0.4);
					/#thread [[anim.locspam]]("scc13");#/
				}
			}
		}
	}
}


cower_nogun()
{
	self SetPoseMovement("crouch","stop");

	rand = randomint(100);
	if (rand<25)
	{
		for (;;)
		{
            //            self . scriptState = "cower nogun";
            
			playbackRate = 0.9 + randomfloat(0.2);
			self setFlaggedAnimKnobAllRestart("coweranim", %hideLowWall_fetal, %root, 1, .1, playbackRate);
			animscripts\shared::DoNoteTracks("coweranim");
		}
	}
	else if (rand<50)
	{
		scaredSet = undefined;
		for (;;)
		{
			playbackRate = 0.9 + randomfloat(0.2);
			if (!isDefined(scaredSet))
			{
				if (randomint(100)<50)
					scaredSet = "A";
				else
					scaredSet = "B";
			}
			if (scaredSet=="A")
			{
				rand = randomint(100);
				if (rand<60)
					self setFlaggedAnimKnobAllRestart("coweranim", %hideLowWall_scaredA, %root, 1, .1, playbackRate);
				else if (rand<90)
					self setFlaggedAnimKnobAllRestart("coweranim", %hideLowWall_scaredA_twitch, %root, 1, .1, playbackRate);
				else
				{
					self setFlaggedAnimKnobAllRestart("coweranim", %hideLowWall_scaredAtoB, %root, 1, .1, playbackRate);
					scaredSet = "B";
				}
				animscripts\shared::DoNoteTracks("coweranim");
			}
			else
			{
				rand = randomint(100);
				if (rand<85)
					self setFlaggedAnimKnobAllRestart("coweranim", %hideLowWall_scaredB, %root, 1, .1, playbackRate);
				else
				{
					self setFlaggedAnimKnobAllRestart("coweranim", %hideLowWall_scaredBtoA, %root, 1, .1, playbackRate);
					scaredSet = "A";
				}
				animscripts\shared::DoNoteTracks("coweranim");
			}
		}
	}
	else if (rand<75)
	{
		for (;;)
		{
			playbackRate = 0.9 + randomfloat(0.2);
			rand = randomint(100);
			if (rand<50)
				self setFlaggedAnimKnobAllRestart("coweranim", %hidelowwall_scaredc_idle, %root, 1, .1, playbackRate);
			else if (rand<75)
				self setFlaggedAnimKnobAllRestart("coweranim", %hidelowwall_scaredc_twitch, %root, 1, .1, playbackRate);
			else
				self setFlaggedAnimKnobAllRestart("coweranim", %hidelowwall_scaredc_look, %root, 1, .1, playbackRate);
			animscripts\shared::DoNoteTracks("coweranim");
		}
	}
	else
	{
		for (;;)
		{
			playbackRate = 0.9 + randomfloat(0.2);
			rand = randomint(100);
			if (rand<50)
				self setFlaggedAnimKnobAllRestart("coweranim", %hidelowwall_scaredd_idle, %root, 1, .1, playbackRate);
			else if (rand<75)
				self setFlaggedAnimKnobAllRestart("coweranim", %hidelowwall_scaredd_twitch, %root, 1, .1, playbackRate);
			else
				self setFlaggedAnimKnobAllRestart("coweranim", %hidelowwall_scaredd_look, %root, 1, .1, playbackRate);
			animscripts\shared::DoNoteTracks("coweranim");
		}
	}
}


// Idle is meant to actually be idle - ie it's not for just ducking between shots.  Hence it doesn't 
// use pose b, since b is only a slight duck between shots.
idle_start(nodeAngle)
{
	if (self.anim_pose == "stand")
	{
		DuckBetweenShots();
	}
	if (self.anim_special == "cover_crouch")
	{
		// We're already in position.  Just check for error conditions before continuing.
		self OrientMode( "face angle", nodeAngle );

		if (!animscripts\utility::IsInSet(self.anim_idleSet, anim.set_a_b_c))
		{
			println ("cover_crouch::idle : Invalid self.anim_idleSet "+self.anim_idleSet+" for cover_crouch character ("+self.anim_pose+", "+self.anim_movement+")");
			self.anim_idleSet = "a";
		}
		// If we're in pose b, we need to get into a more relaxed pose
		if (self.anim_idleSet == "b")
		{
//			self.anim_special = "none";
//			animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallb2crouch_aim, "crouch", "stop", 0);	// TODO Set anim_special here
//			wait 0.75;	// TODO This should be a look around animation.
			if (randomint(100) > 50)
			{
				self.anim_idleSet = "a";
				self.anim_special = "cover_crouch";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch2hideLowWall, "crouch", "stop", 0);	// TODO Set anim_special here
			}
			else
			{
				self.anim_idleSet = "c";
				self.anim_special = "cover_crouch";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallc, "crouch", "stop", 0);	// TODO Set anim_special here
			}
		}
	}
	else
	{
		// We're not in position yet, so get there.
		self SetPoseMovement("crouch","stop");
		self OrientMode( "face angle", nodeAngle );

		// Usually, we want to stick with one idle set, so we pop up, shoot, and come straight back to the same position.
		if ( (randomint(100) > 70) || (!animscripts\utility::IsInSet(self.anim_idleSet, anim.set_a_b_c)) )
		{
			idleSetNum = randomInt(3) + 1;
			self.anim_idleSet = anim.num_to_letter[idleSetNum];
		}
		switch (self.anim_idleSet)
		{
		case "a":
			self.anim_special = "cover_crouch";
			animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch2hideLowWall, "crouch", "stop", 0);	// TODO Set anim_special here
			break;
		case "b":
			self.anim_special = "cover_crouch";
			animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallb, "crouch", "stop", 0);	// TODO Set anim_special here
			break;
		case "c":
			self.anim_special = "cover_crouch";
			animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallc, "crouch", "stop", 0);	// TODO Set anim_special here
			break;
		default:
			println ("cover_crouch::idle : bad self.anim_idleSet value "+self.anim_idleSet+", "+self.anim_pose+", "+self.anim_movement);
			self.anim_idleSet = "c";
			self.anim_special = "cover_crouch";
			animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallc, "crouch", "stop", 0);	// TODO Set anim_special here
		}
	}
}


// Does one idle animation, so never returns instantly and never takes ages.  Generally takes 0.5 to 2 seconds.
idle(nodeAngle)
{
	/#thread [[anim.assert]]( (self.anim_pose == "crouch"), "cover_crouch::idle: Not in crouch pose. ("+self.anim_pose+", "+self.anim_movement+")");#/
	/#thread [[anim.assert]]( (self.anim_special == "cover_crouch"), "cover_crouch::idle: Not in cover_crouch pose. ("+self.anim_pose+", "+self.anim_movement+")");#/

	switch (self.anim_idleSet)
	{
	case "a":
		idle_a(nodeAngle);
		break;
	case "b":
		idle_b();
		break;
	case "c":
		idle_c(nodeAngle);
		break;
	default:
		println ("cover_crouch::idle : bad self.anim_idleSet value "+self.anim_idleSet+", "+self.anim_pose+", "+self.anim_movement);
		self.anim_idleSet = "c";
		idle_c(nodeAngle);
		break;
	}
}		


// Ducks down into idle b pose.  Doesn't stay down. Doesn't get back up.
duckBetweenShots()
{
	switch (self.anim_pose)
	{
	case "stand":
		self SetPoseMovement("stand","stop");	// Generally we're already stopped so this does nothing.
		self animscripts\SetPoseMovement::PlayTransitionAnimation2(%stand2crouch_hide, "crouch", "stop", 0);
		self.anim_idleSet = "b";
		self.anim_special = "cover_crouch";
		break;
	default:
		println("Unhandled pose "+self.anim_pose+" in cover_stand:hide");
		self.anim_pose = "crouch";
		// Fall through.
	case "prone":
		self SetPoseMovement("crouch","stop");
		// Fall through.
	case "crouch":
		if (self.anim_special == "cover_crouch")
		{
			if (self.anim_idleSet == "a")
			{
				self.anim_special = "none";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWall2crouch, "crouch", "stop", 1);
				self.anim_idleSet = "b";
				self.anim_special = "cover_crouch";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallb, "crouch", "stop", 0);
			}
			else if (self.anim_idleSet == "c")
			{
				self.anim_idleSet = "b";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallc2hideLowWallb, "crouch", "stop", 0);
			}
			else if (self.anim_idleSet != "b")
			{
				println ("cover_crouch::idle : Invalid self.anim_idleSet "+self.anim_idleSet+" for cover_crouch character ("+self.anim_pose+", "+self.anim_movement+")");
				self.anim_idleSet = "b";
			}
			// Check my logic
			/#thread [[anim.assert]](self.anim_idleSet == "b", "Logic error in cover_stand::hide - idleSet == "+self.anim_idleSet);#/
		}
		else
		{
			self.anim_special = "cover_crouch";
			self.anim_idleSet = "b";
			animscripts\SetPoseMovement::PlayTransitionAnimation2(%crouch_aim2hideLowWallb, "crouch", "stop", 0);	// TODO Set anim_special & idleSet here.
		}
		break;
	}
}


idleToCrouchAim()
{
	if (self.anim_idleSet == "a")
	{
		self.anim_special = "none";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWall2crouch, "crouch", "stop", 1);
	}
	else if (self.anim_idleSet == "b")
	{
		self.anim_special = "none";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallb2crouch_aim, "crouch", "stop", 1);
	}
	else if (self.anim_idleSet == "c")
	{
		self.anim_idleSet = "b";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallc2hideLowWallb, "crouch", "stop", 1);
		// Could wait a while here
		self.anim_special = "none";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallb2crouch_aim, "crouch", "stop", 1);
	}
	else
	{
		println ("stalingrad_cover_crouch::idleToCrouchAim : bad self.anim_idleSet value "+self.anim_idleSet+", "+self.anim_pose+", "+self.anim_movement);
		self.anim_idleSet = "b";
		self.anim_special = "none";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallb2crouch_aim, "crouch", "stop", 1);
	}
}


idle_a(nodeAngle)
{
	/#thread [[anim.println]]("  Entering idle_a");#/
	self OrientMode( "face angle", nodeAngle );

	choice = randomint(100);
	playbackRate = 0.9 + randomfloat(0.2);

	if (choice<50)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWall_1, %root, 1, .1, playbackRate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWall_2, %root, 1, .1, playbackRate);
	}
	self animscripts\shared::DoNoteTracks("animdone");
	/#thread [[anim.println]]("  Exiting idle_a");#/
}

idle_b()
{
	/#thread [[anim.println]]("  Entering idle_b");#/
	choice = randomint(100);
	playbackRate = 0.9 + randomfloat(0.2);

	if (choice<75)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallb_idle1, %root, 1, .1, playbackRate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallb_twitch1, %root, 1, .1, playbackRate);
	}
	self animscripts\shared::DoNoteTracks("animdone");
	/#thread [[anim.println]]("  Exiting idle_b");#/
}

idle_c(nodeAngle)
{
	/#thread [[anim.println]]("  Entering idle_c");#/
	self OrientMode( "face angle", nodeAngle );

	choice = randomint(100);
	playbackRate = 0.9 + randomfloat(0.2);

	if (choice<50)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallc_idle1, %root, 1, .1, playbackRate);
	}
	else if (choice<75)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallc_twitch1, %root, 1, .1, playbackRate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallc_twitch2, %root, 1, .1, playbackRate);
	}
	self animscripts\shared::DoNoteTracks("animdone");
	/#thread [[anim.println]]("  Exiting idle_c");#/
}

GetEnemyPos()
{
	if (isDefined(self.customtarget))
	{
		if (isSentient(self.customtarget))
		{
			pos = self.customtarget GetEye();
		}
		else
		{
			pos = self.customtarget.origin;
		}
	}
	else
	{
		pos = animscripts\utility::GetEnemyEyePos();
	}
	return pos;
}

GetEnemyAngle()
{
	if (isDefined(self.customtarget))
	{
		enemyPos = self.customtarget.origin;
		angles = VectorToAngles(enemyPos-self.origin);
		return angles[1];
	}
	else
	{
		return animscripts\utility::GetYawToEnemy();
	}
}
