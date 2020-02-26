#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Pain Main", "code" );
	self endon("killanimscript");

	// Two pain animations are played.  One is a longer, detailed animation with little to do with the actual 
	// location and direction of the shot, but depends on what pose the character starts in.  The other is a 
	// "hit" animation that is very location-specific, but is just a single pose for the affected bones so it 
	// can be played easily whichever position the character is in.
    animscripts\utility::initialize("pain");

	[[anim.println]] ("Shot in "+self.damageLocation+" from "+self.damageYaw+" for "+self.damageTaken+" hit points");

	self animscripts\face::SayGenericDialogue("pain");

	if ( isDefined(self.playPainAnim) && (!self.playPainAnim) )
	{
		// This is really just for one spot in truckride, where we don't want the player to be able to interrupt Waters.
		return;
	}

	UpdateWounds(self.damageLocation, self.damageTaken);

	if (self.anim_pose != "prone")	// (Prone pain is in the prone section of the animtree.)
	{
		self setanimknob(%pain, 1, 0.1, 1);
	}

	// Prototype hack - make mg42 guy do special pain
	if ((isdefined (self.targetname)) && (self.targetname == "mg42guy"))
	{
		self mg42pain();
		return;
	}

	if (self.anim_painspecial != "none")
	{
		if (specialPain(self.anim_painspecial))
			return;
	}

	[[anim.PutGunInHand]]("right");

	self thread PlayHitAnimation();

	// Default result from the pain animation so I don't have to set it in every case.
	painmovement = "stop";	
	painpose = self.anim_pose;
	painwounded = self.anim_wounded;
	playPainAnim = 1;

	shotsTillIDie = (float)self.health / (float)self.damageTaken;	// How many more shots like that I could take.

	// Stumble or fall down if you're running forwards
	if ( (self.anim_movement == "run") && (self getMotionAngle()<60) && (self getMotionAngle()>-60) &&(self.anim_pose=="stand" || self.anim_pose=="crouch") )

	{
		if (shotsTillIDie < 1)
		{
			if (self.anim_pose=="crouch")
			{
				self setflaggedanimknob("paindone", %crouchrun_painfall, 1, .1, 1);
				painmovement = "stop";
				painpose = "crouch";
			}
			else // ie self.anim_pose=="stand"
			{
				// This is kind of a hack - it's the same as if his health is higher (see below), but by setting his 
				// movement to "stop" we make him do a crawl cycle before getting up.
				self setflaggedanimknob("paindone", %run2crawl, 1, .1, 1);
				painmovement = "stop";
				painwounded = "crawl";
				painpose = "wounded";
				self OrientMode ("face motion");	// Necessary unless we make animations for falling in different directions
			}
		}
		else if (shotsTillIDie < 2)
		{
			self setflaggedanimknob("paindone", %run2crawl, 1, .1, 1);
			painmovement = "walk";
			painwounded = "crawl";
			painpose = "wounded";
			self OrientMode ("face motion");	// Necessary unless we make animations for falling in different directions
		}
		else
		{
			// Put him into the wounded state and he'll stumble if he continues running.
			painmovement = "run";
			painwounded = "stand";
			painpose = "wounded";
			playPainAnim = 0;	// Means we'll exit pain without waiting for any animations to finish.
			self OrientMode ("face motion");	// Necessary unless we make animations for stumbling in different directions
		}
	}
	else
	{
		switch (self.anim_pose)
		{
		case "stand":
			switch(self.damageLocation)
			{
			case "left_leg_upper":
			case "left_leg_lower":
			case "left_foot":
			case "right_leg_upper":
			case "right_leg_lower":
			case "right_foot":
				self setflaggedanimknob("paindone", %stand_pain_leghit, 1, .1, 1);
				painpose = "crouch";
				break;
			case "helmet":
			case "head":
			case "neck":
			case "torso_upper":
			case "torso_lower":
				// Really low health:
				//self setflaggedanimknob("paindone", %stand_pain_stand2crawl_stumbleback, 1, .1, 1);	// TODO Put proper anim in here
				//self.anim_painpose = "wounded";
				//self.anim_painwounded = "crawl";

				// (Only do the pains which end in crawl if the enemy is more than twice melee range away.)
				if ( (shotsTillIDie < 1) && (animscripts\combat::MyGetEnemySqDist() > anim.meleeRangeSq*4) )
				{
					randNum = randomInt(100);
					if (randNum < 50)
					{
						self setFlaggedAnimKnobRestart("paindone", %stand_pain_hunch, 1, .1, 1);
						painpose = "crouch";
						painmovement = "stop";
						self thread waitSetStop ( 0.2 );
					}
					else
					{
						self setFlaggedAnimKnobRestart("paindone", %stand_pain_fallToHand, 1, .1, 1);
						self OrientMode ("face current");
						painpose = "crouch";
						painmovement = "stop";
						self thread waitSetStop ( 0.2 );
					}
				}
				else
				{
					randNum = randomInt(100);
					if (randNum > 50)
					{
						self setFlaggedAnimKnobRestart("paindone", %stand_pain_front_lshoulder, 1, .1, 1);
						painpose = "stand";
						painmovement = "stop";
						self thread waitSetStop ( 0.2 );
					}
					else
					{
						self setFlaggedAnimKnobRestart("paindone", %stand_pain_front_rshoulder, 1, .1, 1);
						painpose = "stand";
						painmovement = "stop";
						self thread waitSetStop ( 0.2 );
					}
				}
				break;
			case "left_arm_upper":
			case "left_arm_lower":
				self setFlaggedAnimKnobRestart("paindone", %stand_pain_front_lshoulder, 1, .1, 1);
				painpose = "stand";
				painmovement = "stop";
				self thread waitSetStop ( 0.2 );
				break;
			case "right_arm_upper":
			case "right_arm_lower":
				self setFlaggedAnimKnobRestart("paindone", %stand_pain_front_rshoulder, 1, .1, 1);
				painpose = "stand";
				painmovement = "stop";
				self thread waitSetStop ( 0.2 );
				break;
			default:
				randNum = randomInt(100);
				if (randNum <25)
				{
					self setFlaggedAnimKnobRestart("paindone", %stand_pain_front_lshoulder, 1, .1, 1);
					painpose = "stand";
					painmovement = "stop";
					self thread waitSetStop ( 0.2 );
				}
				else if (randNum < 50)
				{
					self setFlaggedAnimKnobRestart("paindone", %stand_pain_front_rshoulder, 1, .1, 1);
					painpose = "stand";
					painmovement = "stop";
					self thread waitSetStop ( 0.2 );
				}
				else if (randNum < 75)
				{
					self setFlaggedAnimKnobRestart("paindone", %stand_pain_hunch, 1, .1, 1);
					painpose = "crouch";
					painmovement = "stop";
					self thread waitSetStop ( 0.2 );
				}
				else
				{
					self setFlaggedAnimKnobRestart("paindone", %stand_pain_fallToHand, 1, .1, 1);
					self OrientMode ("face current");
					painpose = "crouch";
					painmovement = "stop";
					self thread waitSetStop ( 0.2 );
				}
				break;
			}
			break;
		case "wounded":	// TEMP!  TODO - Figure out what to do with wounded pain
		case "crouch":
			randNum = randomint(2);
			if (randNum == 0)
			{
				[[anim.println]]("Playing crouch_pain_falltoground");
				self setflaggedanimknob("paindone", %crouch_pain_fallToGround, 1, .1, 1); // anim, weight, xblend time, rate
				self OrientMode ("face current");
				painpose = "crouch";
				painmovement = "stop";
				self thread waitSetStop ( 0.2 );
			}
			else
			{
				[[anim.println]]("Playing crouch_pain_holdStomach");
				self setflaggedanimknob("paindone", %crouch_pain_holdStomach, 1, .1, 1);
				self OrientMode ("face current");
				painpose = "crouch";
				painmovement = "stop";
				self thread waitSetStop ( 0.2 );
			}
			break;
		case "prone":
			randNum = randomint(2);
			if (randNum == 0)
			{
				[[anim.println]]("Playing prone_painA_holdchest");
				self setflaggedanimknob("paindone", %prone_painA_holdchest, 1, .1, 1); // anim, weight, xblend time, rate
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
				self OrientMode ("face current");
			}
			else
			{
				[[anim.println]]("Playing prone_painB_holdhead");
				self setflaggedanimknob("paindone", %prone_painB_holdhead, 1, .1, 1);
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
				self OrientMode ("face current");
			}
			break;
		case "back":
			[[anim.println]]("Playing back_pain");
			self setflaggedanimknob("paindone", %back_pain, 1, .1, 1);
			self OrientMode ("face current");
			painpose = "crouch";
			break;
		default:
			[[anim.println]]("unhandle pose "+self.anim_pose+" in pain script");
			homemade_error = Unexpected_anim_pose_value + self.anim_pose;
			break;
		}
	}

	if (playPainAnim)
		self animscripts\shared::DoNoteTracks("paindone");
	self.anim_pose = painpose;
	self.anim_movement = painmovement;
	self.anim_wounded = painwounded;
	self OrientMode ("face default");
}


// Special pain is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the pain for the special animation state, or false if it wants the regular 
// pain function to handle it.
specialPain(anim_special)
{
	self thread PlayHitAnimation();
	
	switch (anim_special)
	{
	case "cover_left":
		handled = false;
		break;
	case "cover_right":
		handled = false;
		break;
	case "cover_crouch":
		handled = false;
		break;
	case "rambo_left":
		handled = false;
		break;
	case "rambo_right":
		handled = false;
		break;
	case "rambo":
		handled = false;
		break;
	case "mg42":
		if (self.anim_pose == "stand")
		{
			mg42pain();
			handled = true;
		}
		else
		{
			handled = false;
		}
		break;
	default:
		println ("Unexpected anim_special value : "+anim_special+" in specialPain.");
		handled = false;
	}
	return handled;
}


mg42pain()
{
	self setflaggedanimknob("painanim", %scripted_mg42gunner_pain, 1, .1, 1);
	self animscripts\shared::DoNoteTracks ("painanim");
}


// This is to stop guys from taking off running if they're interrupted during pain.  This used to happen when 
// guys were running when they entered pain, but didn't play a special running pain (eg because they were 
// running sideways).  It resulted in a running pain or death being played when they were shot again.
waitSetStop ( timetowait, killmestring )
{
	self endon("killanimscript");
	self endon ("death");
	if (isDefined(killmestring))
		self endon(killmestring);
	wait timetowait;

	self.anim_movement = "stop";
}

PlayHitAnimation()
{
	// Note the this thread doesn't endon "killanimscript" like most thread, because I don't want it to die 
	// when a new script starts.

	animWeights = animscripts\utility::QuadrantAnimWeights (self.damageYaw);

	// Pick the animation to play, based on location and direction.
	playHitAnim = 1;
	switch(self.damageLocation)
	{
	case "torso_upper":
	case "torso_lower":
		frontAnim =	%minorpain_chest_front;
		backAnim =	%minorpain_chest_back;
		leftAnim =	%minorpain_chest_left;
		rightAnim =	%minorpain_chest_right;
		break;
	case "helmet":
	case "head":
	case "neck":
		frontAnim =	%minorpain_head_front;
		backAnim =	%minorpain_head_back;
		leftAnim =	%minorpain_head_left;
		rightAnim =	%minorpain_head_right;
		break;
	case "left_arm_upper":
	case "left_arm_lower":
	case "left_hand":
		frontAnim =	%minorpain_leftarm_front;
		backAnim =	%minorpain_leftarm_back;
		leftAnim =	%minorpain_leftarm_left;
		rightAnim =	%minorpain_leftarm_right;
		break;
	case "right_arm_upper":
	case "right_arm_lower":
	case "right_hand":
	case "gun":
		frontAnim =	%minorpain_rightarm_front;
		backAnim =	%minorpain_rightarm_back;
		leftAnim =	%minorpain_rightarm_left;
		rightAnim =	%minorpain_rightarm_right;
		break;
	case "none":
	case "left_leg_upper":
	case "left_leg_lower":
	case "left_foot":
	case "right_leg_upper":
	case "right_leg_lower":
	case "right_foot":
		playHitAnim = 0;
		break;
	default:
		println("pain.gsc/HitAnimation: unknown hit location "+self.damageLocation);
		homemade_error = Unexpected_hit_location + self.damageLocation;
		playHitAnim = 0;
		break;
	}

//println (self.damagelocation+" "+direction+" "+self.damageTaken+" "+playHitAnim);
	// Now play the animation for a really sort amount of time.  Weight the animation based on the 
	// damage inflicted (or k-factor?).
	if (playHitAnim)
	{
		if(self.damageTaken > 200)
			weight = 1;
		else
			weight = (self.damageTaken+50.0)/250;
//println (weight);
		// (Note that setanim makes the animation transition to the weight set at a rate of 1 per the time 
		// set, so if the weight is less than 1, I need to set my time longer since it will get there faster 
		// than my time.)
		self clearanim(%minor_pain, 0.1);	// In case there's a minor pain already playing.

		self setanim(frontAnim, animweights["front"], 0.05, 1);	// Setting the blendtime to 0.05 will result in 
		self setanim(backAnim, animweights["back"], 0.05, 1);	// some non-linear blending in of these anims, 
		self setanim(leftAnim, animweights["left"], 0.05, 1);	// but that's not such a bad thing.  A pop 
		self setanim(rightAnim, animweights["right"], 0.05, 1);	// would be a bad thing.

		self setanim(%minor_pain, weight, (0.05/weight), 1);
		wait 0.05;
		self clearanim(%minor_pain, (0.2/weight));	// Don't want to leave residue for the next pain.
		wait 0.2;
	}
}


// UpdateWounds
// Tries to remember the most recent, significant wounds, so that limping animations can be played 
// appropriately.  What I'm trying to do is to end up with a blend between limping on one leg and a generic 
// stagger.
UpdateWounds(damageLocation, damageTaken)
{
	damageSignificance = ( (float)damageTaken / self.health ) * 5;
	if (damageSignificance > 1)
		damageSignificance = 1;
	self.anim_woundedTime = GetTime() + 5000;
	self.anim_woundedAmount = 2 - (2 * self GetNormalHealth());
	if (self.anim_woundedAmount>0.99)
		self.anim_woundedAmount = 0.99;	//epsillon

	switch(damageLocation)
	{
	case "left_leg_upper":
	case "left_leg_lower":
	case "left_foot":
		self.anim_lastWound = "left";
		self.anim_woundedBias = 1*damageSignificance + (self.anim_woundedBias) * (1-damageSignificance);
		break;
	case "right_leg_upper":
	case "right_leg_lower":
	case "right_foot":
		self.anim_lastWound = "right";
		self.anim_woundedBias = -1*damageSignificance + (self.anim_woundedBias) * (1-damageSignificance);
		break;
	default:
		self.anim_lastWound = "upper";
		self.anim_woundedBias = 0*damageSignificance + (self.anim_woundedBias) * (1-damageSignificance);
		break;
	}
}