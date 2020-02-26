// Wounded.gsc
// Handles wounded states.

#using_animtree ("generic_human");

// Combat - get up on your knees and shoot someone
Combat( changeReason )
{
	self endon("killanimscript");

    self trackScriptState( "WoundedCombat", changeReason );
    
	timeSpentIdling = 0.0;
	while (self.anim_pose=="wounded")
	{
		if (self.anim_wounded == "crawl")
		{
			[[anim.println]]("Wounded combat, getting up from crawl to knees.  (Orient mode set to current.)");
			self OrientMode ("face current");	// So we don't spin around on our kneees
			animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_crawl2knees_forward, "wounded", "stop", 0, 1);
			self.anim_wounded = "knees";
		}
		else if (self.anim_wounded == "knees")
		{
			if (self GetNormalHealth() > 0.2)
			{
				[[anim.println]]("Wounded combat, recovering instantly from knees to crouch");
				// I want him to get back into crouch in a hurry.  Might have to make an animation to go here.  
				self.anim_pose = "crouch";	
			}
			else
			{
				[[anim.println]]("Wounded combat, orient mode set to face current");
				self OrientMode ("face current");	// So we don't spin around on our kneees
				if (animscripts\utility::AbsYawToEnemy()<25)
				{
					[[anim.println]]("Wounded combat, shooting");
					self setFlaggedAnimKnobAllRestart ("woundedshoot", %wounded_kneesshoot_straight, %body, 1, .05, 1);
					self shoot();
					self.bulletsInClip --;
					self animscripts\shared::DoNoteTracks ("woundedshoot");
				}
				else 
				{
					//rand = 0.1 + randomfloat (0.4);
					//if (self GetNormalHealth() > rand)
					if ( self GetNormalHealth() > 0.5 - (4.0*timeSpentIdling) )	// Idle for between 0 and 2 seconds.
					{
						[[anim.println]]("Wounded combat, getting up");
						animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_knees2stand, "stand", "stop", 0, 1);
					}
					else
					{
						[[anim.println]]("Wounded combat, idle");
						self setflaggedanimknoball("woundedidle", %wounded_kneesidle, %body, 1, .05, 1);
						self animscripts\shared::DoNoteTracksForTime ( 0.2, "woundedidle" );
						timeSpentIdling += 0.2;
					}
				}
			}
		}
		else if (self.anim_wounded == "stand")
		{
			[[anim.println]]("Wounded combat, stand recover");
			self.anim_pose = "stand";	// TEMP!  TODO Use wounded standing anims, or do something to make wounded work better.
		}
		else
		{
			println ("Wounded::combat - Unexpected wounded pose ", self.anim_wounded );
		}
	}
	self OrientMode ("face default");	// Now we're off our knees, we can track our enemy again.
}


// Pops into a non-wounded pose.
MagicallyGetBetter(callingFunction)
{
	if (self.anim_wounded == "crawl")
	{
		self.anim_pose = "prone";
	}
	else if (self.anim_wounded == "knees")
	{
		self.anim_pose = "crouch";
	}
	else if (self.anim_wounded == "stand")
	{
		self.anim_pose = "stand";
	}
	else
	{
		println ("Wounded::MagicallyGetBetter - Unexpected wounded pose "+self.anim_wounded+", called from "+callingFunction);
		self.anim_pose = "crouch";
	}
}

// Rest - just sit in one place and try to recover from being wounded
rest(callingFunction)
{
	[[anim.println]] ("wounded rest called from "+callingFunction);
	while (self.anim_pose == "wounded")
	{
		self OrientMode ("face current");	// So we don't spin around on our kneees
		if (self.anim_wounded == "crawl")
		{
			rand = 0.1 + randomfloat (0.4);
			if (self GetNormalHealth() > rand)
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_crawl2knees_forward, "wounded", "stop", 0, 1);	// TODO Set to "knees" here too
				self.anim_wounded = "knees";
			}
			else
			{
				self setFlaggedAnimKnobAllRestart("animdone", %wounded_crawlidle, %body, 1, .1, 1);
				self animscripts\shared::DoNoteTracks ("animdone");
			}
		}
		else if (self.anim_wounded == "knees")
		{
			rand = 0.1 + randomfloat (0.4);
			if (self GetNormalHealth() > rand)
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_knees2stand, "stand", "stop", 0, 1);
			}
			else
			{
				self setFlaggedAnimKnobAllRestart("animdone", %wounded_kneesidle, %body, 1, .1, 1);
				self animscripts\shared::DoNoteTracks ("animdone");
			}
		}
		else if (self.anim_wounded == "stand")
		{
			self.anim_pose = "stand";	// TEMP!  TODO Use wounded standing anims, or do something to make wounded work better.
		}
		else
		{
			println ("Wounded::rest - Unexpected wounded pose "+self.anim_wounded+", called from "+callingFunction);
		}
	}
	self OrientMode ("face default");
}


SubState_WoundedGetup( changeReason , desiredPose )
{
    entryState = self . scriptState;
    self trackScriptState( "Wounded Getup", changeReason );

    
	if (!isDefined(desiredPose))
		desiredPose = "stand";
	while (self.anim_pose == "wounded")
	{
		self OrientMode ("face current");	// So we don't spin around on our kneees
		if (self.anim_wounded == "crawl")
		{
			if (desiredPose == "prone")
			{
				// TODO Use an animation here.
				self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
				self EnterProne(0.5);
				self.anim_pose = "prone";	
			}
			else
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_crawl2knees_forward, "wounded", "stop", 0, 1);	// TODO Set to "knees" here too
				self.anim_wounded = "knees";
			}
		}
		else if (self.anim_wounded == "knees")
		{
			if ( desiredPose == "crouch" || desiredPose == "prone" )
			{
				self.anim_pose = "crouch";	// TODO Use an animation here.
			}
			else
			{
				animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_knees2stand, "stand", "stop", 0, 1);
			}
		}
		else if (self.anim_wounded == "stand")
		{
			self.anim_pose = "stand";	// TEMP!  TODO Use wounded standing anims, or do something to make wounded work better.
		}
		else
		{
            self trackScriptState( entryState, "Unexpected wounded pose" );
            return;
		}
	}
	self OrientMode ("face default");
    self trackScriptState( entryState, "Not wounded anymore" );
    return;
}


// Move - attempt to crawl somewhere
move(callingFunction)
{
	[[anim.println]] ("wounded move called from "+callingFunction);
	// We don't currently have any animation of moving while wounded, so we'll just get up.
	while (self.anim_pose == "wounded")
	{
		if (self.anim_wounded == "crawl")
		{
//			animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_crawl2knees_forward, "wounded", "stop", 0, 1);	// TODO Set to "knees" here too
//			self.anim_wounded = "knees";
			if (self.anim_movement == "stop")
			{
				self setFlaggedAnimKnobAllRestart("crawlanim", %wounded_crawl_forward_loop, %body, 1, .1, 1);
				wait (0.05);	// Hack since getMotionAngle doesn't work unless I'm moving.
				if ( self getMotionAngle()<30 && self getMotionAngle()>-30 )
				{
					self.anim_movement = "walk";
					self OrientMode ("face motion");	// Necessary unless I make animations for crawling in different directions
					self animscripts\shared::DoNoteTracks ("crawlanim");
				}
				else
				{
					animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_knees2stand, "stand", "stop", 0, 1);
				}
			}
			else
			{
				self OrientMode ("face current");	// Necessary unless I make animations for crawling in different directions
				self setFlaggedAnimKnobAllRestart("animdone", %wounded_crawl2stumble, %body, 1, .1, 1);
				self animscripts\shared::DoNoteTracks ("animdone", ::SetRotationOn);
				self.anim_pose = "stand";			// These are in the animation but set them just in case.
				self.anim_movement = "run";
				self OrientMode ("face motion");
			}
		}
		else if (self.anim_wounded == "knees")
		{
			animscripts\SetPoseMovement::PlayTransitionAnimation(%wounded_knees2stand, "stand", "stop", 0, 1);
		}
		else if (self.anim_wounded == "stand")
		{
			// TODO Check that self.anim_movement=="run" and if it doesn't, play a transition.
			self setFlaggedAnimKnobAllRestart("stumbleanim", %stumble1, %body, 1, .1, 1);
			self OrientMode ("face motion");	// Necessary unless I make animations for crawling in different directions
			self animscripts\shared::DoNoteTracks ("stumbleanim");
			self setAnimKnobAllRestart(%stumble2, %body, 1, 0, 1);
//			animscripts\SetPoseMovement::PlayBlendTransition(self.anim_combatrunanim, 0.5, "stand", "run", 0);
			animscripts\SetPoseMovement::BlendIntoStandRun();
		}
		else
		{
			println ("Wounded::move - Unexpected wounded pose "+self.anim_wounded+", called from "+callingFunction);
		}
	}
}

SetRotationOn(note)
{
	if (note=="rotate")
	{
		self OrientMode ("face motion");
	}
}