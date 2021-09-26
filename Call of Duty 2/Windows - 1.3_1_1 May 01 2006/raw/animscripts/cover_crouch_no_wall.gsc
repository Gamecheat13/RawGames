#include animscripts\Utility;
#include animscripts\Combat_Utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");
// Idle is meant to actually be idle - ie it's not for just ducking between shots.  Hence it doesn't 
// use pose b, since b is only a slight duck between shots.
idle_start()
{
	if (self.anim_special == "cover_crouch")
	{
		// We're already in position.  Just check for error conditions before continuing.
		if (self animscripts\utility::weaponAnims()=="panzerfaust")
		{
			cornerAngle = animscripts\utility::GetNodeDirection();
			self OrientMode( "face angle", cornerAngle );
			// Do I need to do anything in this case?
		}
		else if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
		{
			cornerAngle = animscripts\utility::GetNodeDirection();
			self OrientMode( "face angle", cornerAngle );
			
			if (!animscripts\utility::IsInSet(self.anim_idleSet, anim.set_a_b))
			{
				println ("cover_crouch::idle : Invalid self.anim_idleSet "+self.anim_idleSet+" for cover_crouch character ("+self.anim_pose+", "+self.anim_movement+")");
				self.anim_idleSet = "a";
			}
			// If we're in pose b, we need to get into a more relaxed pose
			if (self.anim_idleSet == "b")
			{
				self.anim_special = "none";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%pistol_lowwallcoverB2crouchaim, "crouch", "stop", 0);	// TODO Set anim_special here
				wait 0.75;	// TODO This should be a look around animation.
				self.anim_idleSet = "a";
				self.anim_special = "cover_crouch";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%pistol_crouch2lowwallcoverA, "crouch", "stop", 0);	// TODO Set anim_special here
			}
		}
		else
		{
			cornerAngle = animscripts\utility::GetNodeDirection();
			self OrientMode( "face angle", cornerAngle );

			if (!animscripts\utility::IsInSet(self.anim_idleSet, anim.set_a_b_c))
			{
				println ("cover_crouch::idle : Invalid self.anim_idleSet "+self.anim_idleSet+" for cover_crouch character ("+self.anim_pose+", "+self.anim_movement+")");
				self.anim_idleSet = "a";
			}
			// If we're in pose b, we need to get into a more relaxed pose
			if (self.anim_idleSet == "b")
			{
				self.anim_special = "none";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallb2crouch_aim, "crouch", "stop", 0);	// TODO Set anim_special here
				wait 0.75;	// TODO This should be a look around animation.
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
	}
	else
	{
		// We're not in position yet, so get there.
		self SetPoseMovement("crouch","stop");
		if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
		{
			cornerAngle = animscripts\utility::GetNodeDirection();
			self OrientMode( "face angle", cornerAngle );

			self.anim_idleSet = "a";
			self.anim_special = "cover_crouch";
			animscripts\SetPoseMovement::PlayTransitionAnimation(%pistol_crouch2lowwallcoverA, "crouch", "stop", 0);	// TODO Set anim_special here
		}
		else if (self animscripts\utility::weaponAnims()=="panzerfaust")
		{
			cornerAngle = animscripts\utility::GetNodeDirection();
			self OrientMode( "face angle", cornerAngle );

			self.anim_special = "cover_crouch";
			animscripts\SetPoseMovement::PlayTransitionAnimation(%panzerfaust_crouchaim2lowwallcover, "crouch", "stop", 0);	// TODO Set anim_special here
		}
		else
		{
			cornerAngle = animscripts\utility::GetNodeDirection();
			self OrientMode( "face angle", cornerAngle );

			// Usually, we want to stick with one idle set, so we pop up, shoot, and come straight back to the same position.
			if ( (randomint(100) > 70) || (!animscripts\utility::IsInSet(self.anim_idleSet, anim.set_a_c)) )
			{
				if (randomint(100)<50)
					self.anim_idleSet = "a";
				else
					self.anim_idleSet = "c";
			}
			switch (self.anim_idleSet)
			{
			case "a":
				self.anim_special = "cover_crouch";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch2hideLowWall, "crouch", "stop", 0);	// TODO Set anim_special here
				break;
//			case "b":
//				self.anim_special = "cover_crouch";
//				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallb, "crouch", "stop", 0);	// TODO Set anim_special here
//				break;
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
}


// Does one idle animation, so never returns instantly and never takes ages.  Generally takes 0.5 to 2 seconds.
idle()
{
	assertEX( (self.anim_pose == "crouch"), "cover_crouch::idle: Not in crouch pose. ("+self.anim_pose+", "+self.anim_movement+")");
	assertEX( (self.anim_special == "cover_crouch"), "cover_crouch::idle: Not in cover_crouch pose. ("+self.anim_pose+", "+self.anim_movement+")");
	if (forcedCover("hide"))
		self endon ("anim_show_now");

	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		switch (self.anim_idleSet)
		{
		case "a":
			idle_Pistol_a();
			break;
		case "b":
			idle_Pistol_b();
			break;
		default:
			println ("cover_crouch::idle with pistol : bad self.anim_idleSet value "+self.anim_idleSet+", "+self.anim_pose+", "+self.anim_movement);
			self.anim_idleSet = "c";
			idle_c();
			break;
		}
	}
	else if (self animscripts\utility::weaponAnims()=="panzerfaust")
	{
		cornerAngle = animscripts\utility::GetNodeDirection();
		self OrientMode( "face angle", cornerAngle );

		choice = randomint(100);
		playbackRate = 0.9 + randomfloat(0.2);

		if (choice<70)
		{
			self setFlaggedAnimKnobAllRestart("animdone", %panzerfaust_lowwall_idle, %body, 1, .1, playbackRate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("animdone", %panzerfaust_lowwall_twitch, %body, 1, .1, playbackRate);
		}
		self animscripts\shared::DoNoteTracks("animdone");
	}
	else
	{
		switch (self.anim_idleSet)
		{
		case "a":
			idle_a();
			break;
		case "b":
			idle_b();
			break;
		case "c":
			idle_c();
			break;
		default:
			println ("cover_crouch::idle : bad self.anim_idleSet value "+self.anim_idleSet+", "+self.anim_pose+", "+self.anim_movement);
			self.anim_idleSet = "c";
			idle_c();
			break;
		}
	}
}		


// Ducks down into idle b pose.  Doesn't stay down. Doesn't get back up.
duckBetweenShots(changeReason)
{
    entryState = self . scriptState;
    self trackScriptState( "DuckBetweenShots", changeReason );

	if (self animscripts\utility::weaponAnims()=="panzerfaust")
	{
		idle_start();	// We always duck properly with the panzerfaust
	}
	else if (self.anim_special != "cover_crouch")
	{
		// We're not in position yet, so get there.
		self SetPoseMovement("crouch","stop");
		self.anim_idleSet = "b";
		self.anim_special = "cover_crouch";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallb, "crouch", "stop", 1);
	}

	if (self.anim_idleSet == "b")
	{
//		rand = randomint(3) + 1;
//		for (i=0; i<rand; i++)
//		{
//			idle_b();
//		}
	}
	else if (self.anim_idleSet == "a")
	{
		self.anim_special = "none";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWall2crouch, "crouch", "stop", 1);
		self.anim_idleSet = "b";
		self.anim_special = "cover_crouch";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallb, "crouch", "stop", 1);
	}
	else //ie (self.anim_idleSet == "c")
	{
		self.anim_idleSet = "b";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallc2hideLowWallb, "crouch", "stop", 1);
	}

    self trackScriptState( entryState , "DuckBetweenShots returned" );
}		


idleToAim()
{
	if (self animscripts\utility::weaponAnims()=="panzerfaust")
	{
		self.anim_special = "none";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%panzerfaust_lowwallcover2crouchaim, "crouch", "stop", 1);
	}
	else if (self.anim_idleSet == "a")
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
		println ("cover_crouch::idleToAim : bad self.anim_idleSet value "+self.anim_idleSet+", "+self.anim_pose+", "+self.anim_movement);
		self.anim_idleSet = "b";
		self.anim_special = "none";
		animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallb2crouch_aim, "crouch", "stop", 1);
	}
}


idle_a()
{
	cornerAngle = animscripts\utility::GetNodeDirection();
	self OrientMode( "face angle", cornerAngle );

	choice = randomint(100);
	playbackRate = 0.9 + randomfloat(0.2);

	waittillframeend; // so run cant come in after and mess us up if it hits right on thisf rame
	if (choice<50)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWall_1, %body, 1, .1, playbackRate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWall_2, %body, 1, .1, playbackRate);
	}
	self animscripts\shared::DoNoteTracks("animdone");
}

idle_b()
{
	choice = randomint(100);
	playbackRate = 0.9 + randomfloat(0.2);

	waittillframeend; // so run cant come in after and mess us up if it hits right on thisf rame
	if (choice<75)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallb_idle1, %body, 1, .1, playbackRate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallb_twitch1, %body, 1, .1, playbackRate);
	}
	self animscripts\shared::DoNoteTracks("animdone");
}

idle_c()
{
	cornerAngle = animscripts\utility::GetNodeDirection();
	self OrientMode( "face angle", cornerAngle );

	choice = randomint(100);
	playbackRate = 0.9 + randomfloat(0.2);

	waittillframeend; // so run cant come in after and mess us up if it hits right on thisf rame
	if (choice<50)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallc_idle1, %body, 1, .1, playbackRate);
	}
	else if (choice<75)
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallc_twitch1, %body, 1, .1, playbackRate);
	}
	else
	{
		self setFlaggedAnimKnobAllRestart("animdone", %hideLowWallc_twitch2, %body, 1, .1, playbackRate);
	}
	self animscripts\shared::DoNoteTracks("animdone");
}

idle_Pistol_a()
{
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverA2crouchaim, %body, 1, .1, 0);	// TODO - use correct anim
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

idle_Pistol_b()
{
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverB2crouchaim, %body, 1, .1, 0);	// TODO - use correct anim
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}
