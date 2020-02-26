#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Walk Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("walk");

	[[anim.locSpam]]("w1");
	// If I'm wounded, I act differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::move("walk::main");
	}

	// Prototype hack - make Price limp
	if ((isdefined (self.targetname)) && (self.targetname == "pricespawn"))
	{
		self PriceLimp();	
		return;
	}

	/*
	// Prototype hack - make intro guy tired-run
	if ((isdefined (self.targetname)) && (self.targetname == "friend") && (isdefined(self.target)))
	{
		self animscripts\walk::TiredRun();	
		return;
	}
	*/

	for (;;)
	{
		// Decide what pose to use
		desiredPose = self animscripts\utility::choosePose();

		[[anim.locSpam]]("w2");


		// If we're not moving far, we "shuffle", which means we don't have to play an intro animation.
		// The requirement that we're standing should go away once we make crouching versions of the shuffle animations.
		distance = self approxPathDist();
		blendToWalkTime = 1.2;
		switch (desiredPose)
		{
		case "stand":
//			if ( self animscripts\utility::IsInCombat() )
//			{
//				// We run everywhere in combat
//				self [[anim.SetPoseMovement]]("stand","run");
//				self setflaggedanimknoball("walkdone",%combatrun_quickstep_loop, %body, 1, blendToWalkTime, 1);
//				self waittill ("walkdone");
//			}
//			else

			if ( (isDefined(self.walk_combatanim)) && (self animscripts\utility::IsInCombat()) )
			{
				rand = randomint(100);
				if ( (rand < 20) && (isDefined(self.walk_combatanim2)) )
				{
					self setflaggedanimknoball("walkdone",self.walk_combatanim2, %body, 1, blendToWalkTime, 1);
					self waittill ("walkdone");
				}
				else
				{
					self setflaggedanimknoball("walkdone",self.walk_combatanim, %body, 1, blendToWalkTime, 1);
					self waittill ("walkdone");
				}
			}
			else if ( (isDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) )
			{
				rand = randomint(100);
				if ( (rand < 20) && (isDefined(self.walk_noncombatanim2)) )
				{
					self setflaggedanimknoball("walkdone",self.walk_noncombatanim2, %body, 1, blendToWalkTime, 1);
					self waittill ("walkdone");
				}
				else
				{
					self setflaggedanimknoball("walkdone",self.walk_noncombatanim, %body, 1, blendToWalkTime, 1);
					self waittill ("walkdone");
				}
			}
			else if ( (GetTime() < self.anim_woundedTime) || (self.anim_woundedAmount > 0.5) )	// Limp if you're more than 1/2 wounded.
			{
				self setflaggedanimknoball("walkdone",%wounded_walk_loop, %body, 1, blendToWalkTime, 1);
				self waittill ("walkdone");
			}
			else
			{
				if ( (distance < anim.maxShuffleDistance) && (self.anim_movement == "stop") && (!self animscripts\utility::IsInCombat()) )
				{
					Shuffle();
				}
				else
				{
					self [[anim.SetPoseMovement]]("stand","walk");
					rand = randomint (100);
					[[anim.locSpam]]("w3");
					if ( rand < 40 )
					{
						[[anim.locSpam]]("w4");
						self setflaggedanimknoball("walkdone",%stand_walk_combat_loop_01, %body, 1, blendToWalkTime, 1);
						self waittill ("walkdone");
					}
					else if ( rand < 70 )
					{
						[[anim.locSpam]]("w5");
						self setflaggedanimknoball("walkdone",%stand_walk_combat_loop_02, %body, 1, blendToWalkTime, 1);
						self waittill ("walkdone");        
					}
					else
					{
						[[anim.locSpam]]("w6");
						self setflaggedanimknoball("walkdone",%stand_walk_combat_loop_03, %body, 1, blendToWalkTime, 1);
						self waittill ("walkdone");        
					}
				}
			}
			break;
		case "crouch":
			self [[anim.SetPoseMovement]]("crouch","walk");
			self setflaggedanimknoball("walkdone",%crouchwalk_loop, %body, 1, blendToWalkTime, 1);
			self waittill ("walkdone");
			break;
		case "prone":
			self [[anim.SetPoseMovement]]("prone","walk");
			self setflaggedanimknoball("walkdone",%prone_crawl, %body, 1, blendToWalkTime, 1);
			self waittill ("walkdone");
			break;
		default:
			println ("walk.gsc, unhandled desiredPose: "+desiredPose);
			break;
		}

		[[anim.locSpam]]("w7");
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
	self [[anim.SetPoseMovement]]("stand","walk");
	[[anim.locSpam]]("w8");

	[[anim.assert]](self.anim_movement == "walk", "walk::main "+self.anim_movement);
	[[anim.assert]](self.anim_pose == "stand", "walk::main "+self.anim_pose);

	self setanimknob(%wounded_walk_loop, 1, .1, 1);
	wait 10;	// Arbitrary wait, so the script doesn't execute every frame.
}


TiredRun()
{
	[[anim.locSpam]]("w9");
	self [[anim.SetPoseMovement]]("stand","run");
	self.anim_movement = "run";
	self.anim_pose = "stand";
	self setanimknob(%levelchateau_TiredRun, 1, .1, 1);
	wait (randomfloat (0.7));
	self playsound ("misc_step1");
	wait (randomfloat (0.7));
	self playsound ("misc_step2");
	wait (randomfloat (0.7));
	self playsound ("misc_step1");
	wait (randomfloat (0.7));
	self playsound ("misc_step2");
	wait 1;	// Arbitrary wait, so the script doesn't execute every frame.
}


Shuffle()
{
	self [[anim.SetPoseMovement]]("stand","stop");
	if (self.anim_idleSet == "none" || self.anim_idleSet == "w" )
		self.anim_idleSet = "a";
	if 	(self.anim_idleSet == "a")
	{
		self setflaggedanimknoball("shuffleanim",%stand_alerta_shuffle_forward, %body, 1, .05, 1);
	}
	else
	{
//		[[anim.assert]](self.anim_idleset=="b", "Walk: Stand stop idleset isn't a or b, it's "+self.anim_idleset);
		self setflaggedanimknoball("shuffleanim",%stand_alertb_shuffle_forward, %body, 1, .05, 1);
	}
	self animscripts\shared::DoNoteTracks ("shuffleanim");
}

	// Other cases
//	if (self.anim_pose == "prone")
//	{
//		self setanim(%prone_crawl, 1, .1, 1);	// TODO - Is this looping?
//	}
//	else if (self.anim_pose == "crouch")
//	{
//		self setanim(%crouchwalk_loop, 1, .1, 1);
//	}
