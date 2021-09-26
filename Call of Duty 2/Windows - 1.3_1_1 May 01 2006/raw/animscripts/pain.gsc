#include animscripts\Utility;
#include animscripts\weaponList;
#include maps\_Utility;
#include animscripts\Combat_Utility;
#using_animtree ("generic_human");

main()
{
	/*
	if (gettime() > self.anim_lastWoundTime + 3000)
	{
		if ((self.health > 0) && (self.maxhealth - self.damageTaken > 0))
			self setnormalhealth ((self.maxhealth - self.damageTaken) / self.maxHealth);
	}
	self.anim_lastWoundTime = gettime();

	if (!isdefined(anim.paintime))
		anim.paintime = 0;
	if (anim.paintime > gettime())
		return;
	anim.paintime = gettime() + 1000;
	*/
	/#
	if (isdefined(self.damageweapon))
		assertEx(isdefined(getAIWeapon(self.damageWeapon)), "Damage weapon " + self.damageweapon + " is not defined in weaponList.gsc");
	#/
	
	
	if ([[anim.difficultyFunc]]())
		return;	
	if (self.anim_disablePain)
		return;
		
	self.anim_painTime = gettime();
	forceCreateBadPlaceandMove();

	if (self.anim_nextStandingHitDying)
		self.health = 1;

	dead = false;
	stumble = false;
	
	ratio = self.health / self.maxHealth;
//	if (ratio < 100)
		
//	println ("hit at " + self.damagelocation);
		
	self animscripts\shared::PutGunInHand("right");
//	if (self.team == "axis" && self.health / self.maxHealth > 0.5)
//		return;
	
    self trackScriptState( "Pain Main", "code" );
    self notify ("anim entered pain");
	self endon("killanimscript");
//	thread print3drise (self.origin + (0,0,70), self.damageTaken, (1,0,0), 1, 0.8);

	// Two pain animations are played.  One is a longer, detailed animation with little to do with the actual 
	// location and direction of the shot, but depends on what pose the character starts in.  The other is a 
	// "hit" animation that is very location-specific, but is just a single pose for the affected bones so it 
	// can be played easily whichever position the character is in.
    animscripts\utility::initialize("pain");

	//thread [[anim.println]] ("Shot in "+self.damageLocation+" from "+self.damageYaw+" for "+self.damageTaken+" hit points");#/

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

	if (self.anim_painspecial != "none")
	{
		if (specialPain(self.anim_painspecial))
			return;
	}

//	[[anim.PutGunInHand]]("right");

//	self thread PlayHitAnimation();

	// Default result from the pain animation so I don't have to set it in every case.
	painmovement = "stop";	
	painpose = self.anim_pose;
	painwounded = self.anim_wounded;
	playPainAnim = 1;

	weapon = weaponAnims();
	
	// panzerfaust and pistol guys dont do wounded behavior
	noWounded = weapon == "panzerfaust" || weapon == "pistol";

	shotsTillIDie = self.health / self.damageTaken;	// How many more shots like that I could take.
	boltDamageWeapon = false;
	if (isdefined(getAIWeapon(self.damageWeapon)))
	{
		if (getAIWeapon(self.damageWeapon)["type"] == "bolt")
		{
			boltDamageWeapon = true;
			shotsTillIDie = 1;
		}
	}

	semiAutoWeapon = false;
	if (isdefined(getAIWeapon(self.damageWeapon)))
	{
		if (getAIWeapon(self.damageWeapon)["type"] == "semi")
			semiAutoWeapon = true;
	}
	
//	else
//		return;

/*
	println ("loc: ", self.damageLocation);
	if (self.damageLocation == "head" || self.damageLocation == "helmet")
	{
		if (isdefined (self.hatmodel))
		{
			self detach(self.hatmodel);
			model = spawn ("script_model",(0,0,0));
			model setmodel (self.hatmodel);
			model.origin = self GetTagOrigin ("J_Head");
			model.angles = self GetTagAngles ("J_Head");
			x = 150;
			y = 150;
			z = 150;
			model rotateVelocity((x,y,z), 12);
			model moveGravity((x, y, z), 12);

			self.hatmodel = undefined;
			
		}
	}
	*/
	backPain = false;
	// Stumble or fall down if you're running forwards
	if ( (self.anim_movement == "run") && (self getMotionAngle()<60) && (self getMotionAngle()>-60) 
	&&(self.anim_pose=="stand" || self.anim_pose=="crouch") )

	{
		if (shotsTillIDie < 1 || noWounded)
		{
			if (self.anim_pose=="crouch" || noWounded)
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
		else
		if (shotsTillIDie < 2)
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
			// There is an issue with pain.gsc exiting in zero frames, so play an animation here to avoid basepose
			self setAnimKnobAllRestart(%stumble1, %body, 1, .1, 1);
			stumble = true;
		}
	}
	else
	{
		switch (self.anim_pose)
		{
		case "stand":
			if (self.anim_nextStandingHitDying && hitTorsoOrHigher())
			{
				backPain = dying_pistol_check();
				if (backPain)
				{
					self.anim_nextStandingHitDying = false;
					self setflaggedanimknob("paindone", %stand_pain_Stand2crawl_stumbleback, 1, .1, 1); // anim, weight, xblend time, rate
					// Finish the animation that gets to crawl, then start the crawl-to-dying animation
					self clearAnim(%pain, 0.3);
					self animscripts\shared::DoNoteTracks("paindone");
					crawl();
					self setflaggedanimknob("paindone", %dying_pistol_from_crawl_front, 1, .1, 1); // anim, weight, xblend time, rate
					break;
				}
				else
				if (boltDamageWeapon && canDieFast())
				{
					animscripts\death::playDeathAnim("paindone", randomint(100));
					self notify ("pain_death"); // pain that ends in death
					self.health = 1;
					dead = true;
					break;
				}
			}
			
			switch(self.damageLocation)
			{
			case "left_leg_upper":
			case "left_leg_lower":
			case "left_foot":
			case "right_leg_upper":
			case "right_leg_lower":
			case "right_foot":
				self setflaggedanimknob("paindone", %stand_pain_fallToHand, 1, .1, 1); // stand_pain_leghit
				painpose = "crouch";
				break;
			case "helmet":
			case "head":
				// heltmet gets knocked off for axis shot in the head
				if ((boltDamageWeapon || SemiAutoWeapon) && canDieFast())
				{
					if (randomint(100) > 50 && metalHat() && removeableHat() && self.weapon != "luger") // not on pistol guys
					{
						self setflaggedanimknob("paindone", %stand_helmet_hit, 1, .0, 1); // stand_pain_leghit
						thread animscripts\death::popHelmet();
					}
					else
					{
						animscripts\death::setHeadDeathAnim("paindone", randomint(100));
						self notify ("pain_death"); // pain that ends in death
						self.health = 1;
						dead = true;
					}
					break;
				}
			case "torso_lower":
			case "torso_upper":
			case "neck":
				
				// Really low health:
				//self setflaggedanimknob("paindone", %stand_pain_stand2crawl_stumbleback, 1, .1, 1);	// TODO Put proper anim in here
				//self.anim_painpose = "wounded";
				//self.anim_painwounded = "crawl";

				// upper torso in the front
				if (self.damageLocation == "torso_upper" && ( self.damageyaw > 135 || self.damageyaw <=-135 ))
				{			
					if (randomint(100) > 60) // see this one too often
						backPain = dying_pistol_check();
					else
						backPain = false;
						
					if (backPain)
					{
						self setflaggedanimknob("paindone", %stand_pain_Stand2crawl_stumbleback, 1, .1, 1); // anim, weight, xblend time, rate
						// Finish the animation that gets to crawl, then start the crawl-to-dying animation
						self clearAnim(%pain, 0.3);
						self animscripts\shared::DoNoteTracks("paindone");
						crawl();
						self setflaggedanimknob("paindone", %dying_pistol_from_crawl_front, 1, .1, 1); // anim, weight, xblend time, rate
						break;
					}
					else
					if (boltDamageWeapon && canDieFast())
					{
						animscripts\death::playDeathAnim("paindone", randomint(100));
						self notify ("pain_death"); // pain that ends in death
						self.health = 1;
						dead = true;
						break;
					}
				}

				if (( self.health < 50 || boltDamageWeapon) && self.damageLocation == "torso_lower" && canDieFast())
				{
					if (randomint(100) > 65)
						self setflaggedanimknob("paindone", %stand_death_lowertorso, 1, .1, 1);
					else
						self setflaggedanimknob("paindone", %stand_death_stomach, 1, .1, 1);
					
					self notify ("pain_death"); // pain that ends in death
					self.health = 1;
					dead = true;
					painpose = "crouch";
					break;
				}

				// (Only do the pains which end in crawl if the enemy is more than twice melee range away.)
				if ( (shotsTillIDie < 1) && (MyGetEnemySqDist() > anim.meleeRangeSq*4) )
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
			if ( self.anim_wounded == "crawl" && canDieFast())
			{
				backPain = true;
				self notify ("pain_death"); // pain that ends in death
				self.health = 1;
				crawl();
				self setflaggedanimknob("paindone", %dying_pistol_from_crawl_front, 1, .1, 1); // anim, weight, xblend time, rate
				break;
			}
		case "crouch":

			/*
			self setflaggedanimknob("paindone", %crouch_pain_crouch2crawl_ktwist, 1, .1, 1); // anim, weight, xblend time, rate
			self OrientMode ("face current");
			painpose = "crouch";
			painmovement = "stop";
			self thread waitSetStop ( 0.2 );

			dying_pistol_from_crawl_front
			
			%crouch_pain_crouch2crawl_ktwist from crouching right shoulder from front
			%crouch_pain_crouch2crawl_grabhead from crouching upper torso from front
			%crouch_pain_crouch2crawl_back	from crouching from behind
			%stand_pain_Stand2crawl_stumbleback from standing upper torso
			*/

			// helmet/head hits with bolt are a kill on crouch guys
			if (self.damagelocation == "helmet" || self.damagelocation == "head")
			{
				if ((boltDamageWeapon || SemiAutoWeapon) && canDieFast())
				{
					animscripts\death::setHeadDeathAnim("paindone", randomint(100));
					self notify ("pain_death"); // pain that ends in death
					self.health = 1;
					dead = true;
					break;
				}
			}
			
	
			backPain = dying_pistol_check();
			if (backPain)
			{			
				endsInCrawl = false;
				self setanimknob (%dying, 1, 0.1, 1);
				if ( self.damageyaw < 45 && self.damageyaw > -45 )	// From the back
				{
					self setflaggedanimknob("paindone", %crouch_pain_crouch2crawl_back, 1, .1, 1); // anim, weight, xblend time, rate
					endsInCrawl = true;
				}
				else
				{
					switch (self.damageLocation)
					{
						case "left_arm_upper":
						case "left_arm_lower":
						case "left_hand":
							self setflaggedanimknob("paindone", %crouch_pain_crouch2crawl_ktwist, 1, .1, 1); // anim, weight, xblend time, rate
							endsInCrawl = true;
							break;
						case "torso_upper":
						case "torso_lower":
							if (randomint(100) > 50)
							{
								self setflaggedanimknob("paindone", %crouch_pain_crouch2crawl_grabhead, 1, .1, 1); // anim, weight, xblend time, rate
								endsInCrawl = true;
							}
							else
								self setflaggedanimknob("paindone", %dying_pistol_from_crouch_front, 1, .1, 1); // anim, weight, xblend time, rate
							break;
						default:
							self setflaggedanimknob("paindone", %dying_pistol_from_crouch_front, 1, .1, 1); // anim, weight, xblend time, rate
							break;
					}
				}

				if (endsInCrawl)
				{
					// Finish the animation that gets to crawl, then start the crawl-to-dying animation
					self clearAnim(%pain, 0.3);
					self animscripts\shared::DoNoteTracks("paindone");
					crawl();
					self setflaggedanimknob("paindone", %dying_pistol_from_crawl_front, 1, .1, 1); // anim, weight, xblend time, rate
				}
			}
			else
			if (boltDamageWeapon && canDieFast())
			{
				animscripts\death::playDeathAnim("paindone", randomint(100));
				self notify ("pain_death"); // pain that ends in death
				self.health = 1;
				dead = true;
				break;
			}
			else
			{
				if (self.damageyaw > 135 || self.damageyaw <=-135 ) // front
				{
					self setflaggedanimknob("paindone", %crouch_pain_fallToGround, 1, .1, 1); // anim, weight, xblend time, rate
					self OrientMode ("face current");
					painpose = "crouch";
					painmovement = "stop";
					self thread waitSetStop ( 0.2 );
				}
				else
				{
					self setflaggedanimknob("paindone", %crouch_pain_holdStomach, 1, .1, 1);
					self OrientMode ("face current");
					painpose = "crouch";
					painmovement = "stop";
					self thread waitSetStop ( 0.2 );
				}
			}

			break;
		case "prone":
			randNum = randomint(2);
			if (randNum == 0)
			{
				self setflaggedanimknob("paindone", %prone_painA_holdchest, 1, .1, 1); // anim, weight, xblend time, rate
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
				self OrientMode ("face current");
			}
			else
			{
				self setflaggedanimknob("paindone", %prone_painB_holdhead, 1, .1, 1);
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
				self OrientMode ("face current");
			}
			break;
		case "back":
			self setflaggedanimknob("paindone", %back_pain, 1, .1, 1);
			self OrientMode ("face current");
			painpose = "crouch";
			break;
		default:
			assertmsg("unhandle pose "+self.anim_pose+" in pain script");
			break;
		}
	}

	crouchPain = false;
	if (playPainAnim)
	{
		if (canDieFast() && !dead && !self.anim_nextStandingHitDying)
		{
			if (self.anim_pose == "stand")
			{
				self.anim_nextStandingHitDying = true;
				if (painpose == "crouch")
				{
					self.health = 150;
					self.anim_crouchpain = true;
					crouchPain = true;
				}
				else
				if (painpose == "wounded")
					crouchPain = true;
			}
			else
			if (self.anim_pose == "crouch")
			{
				
			}
			
			if (!crouchPain)
			{
				if (self.health > 50 && self.health < 80 && !isdefined(self.lostBonus))
				{
					self.lostBonus = true;
					self.health -= 50;
				}
			}
		}

		if (backPain)
		{
			self clearAnim(%pain, 0.3);

			// Dont continue to hog the pain slot if you're doing long death
			if (isdefined (level.painAI) && level.painAI == self)
				level.painAI = undefined;
		}
		if (dead)
		{
			// Dont continue to hog the pain slot if you're doing long death
			if (isdefined (level.painAI) && level.painAI == self)
				level.painAI = undefined;
		}
				
		self animscripts\shared::DoNoteTracks("paindone");
		if (stumble)
			self clearanim (%stumble1, 0);
		if (dead)
		{
			// long death animations get played in pain so you can break them out into a death
			self.anim_nodeath = true;
			self dodamage(self.health + 5, (0,0,0));
			wait (0.05); // because dodamage may not occur until later in the frame
			return;
		}
		if (backPain)
			dying_pistol_guy();
	}

	if (self.anim_pose == "prone" && painpose != "prone")
	{
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	
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
//println (self.damagelocation+" "+direction+" "+self.damageTaken);
		return;
	default:
		assertmsg("pain.gsc/HitAnimation: unknown hit location "+self.damageLocation);
		return;
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

		self setanim(frontAnim, animWeights["front"], 0.05, 1);	// Setting the blendtime to 0.05 will result in 
		self setanim(backAnim, animWeights["back"], 0.05, 1);	// some non-linear blending in of these anims, 
		self setanim(leftAnim, animWeights["left"], 0.05, 1);	// but that's not such a bad thing.  A pop 
		self setanim(rightAnim, animWeights["right"], 0.05, 1);	// would be a bad thing.

		self setanim(%minor_pain, weight, (0.05/weight), 1);
		wait 0.05;
		if (!isdefined(self))
			return;
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
	damageSignificance = ( damageTaken / self.health ) * 5;
	if (damageSignificance > 1)
		damageSignificance = 1;
	if (self.team == "axis")
	{
		// no wounded for friendlies
		self.anim_woundedTime = GetTime() + 5000;
		self.anim_woundedAmount = 2 - (2 * self GetNormalHealth());
	
		if (self.anim_woundedAmount>0.99)
			self.anim_woundedAmount = 0.99;	//epsillon
	}

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
			
			
dying_pistol_guy()
{
	// spin it off so we never leave this function and go back to regular behavior
	dying_pistol_guyproc();
	self waittill ("forever and ever");
}
	
dying_pistol_guyproc()
{
			/*
		
			for (;;)
			{
				randNum = randomint(3);
								
				if (randNum == 0)
					self setflaggedanimknob ("dying", %dying_pistol_aim_straight, 1, 0.15, 1);
				if (randNum == 1)
					self setflaggedanimknob ("dying", %dying_pistol_shoot_straight1, 1, 0.15, 1);
				if (randNum == 2)
					self setflaggedanimknob ("dying", %dying_pistol_shoot_straight2, 1, 0.15, 1);
				self waittillmatch ("dying", "end");
			}
			*/
	
//	self thread animscripts\shared::DoNoteTracks("paindone");
//	wait (1.5);
//	self setanimknob (%dying, 1, 0.5, 1);
	self endon ("stop_dying_pistol");

	self setanimknob (%dying, 1, 0.1, 1);
	self setanimknob (%dying_directions, 1, 0.1, 1);
	self setflaggedanimknob ("dying", %dying_pistol_aim_straight, 1, 0.5, 1);
	if (self.anim_pose == "prone")
	{
		self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	
	self.anim_pose = "back";
	self.anim_movement = "stop";
	/*
	weaponClass = "weapon_" + self.weapon;
	weapon = spawn (weaponClass, self getTagOrigin ("tag_weapon_right"));
	weapon.angles = self getTagAngles ( "tag_weapon_right" ); 
	
	*/

	wait (0.35);
//	self waittillmatch ("dying", "end");
	
	self.animArray = undefined;
	self.animArray["aim"]		["left"] 		= %dying_pistol_aim_left;
	self.animArray["aim"]		["straight"] 	= %dying_pistol_aim_straight;
	self.animArray["aim"]		["right"]	 	= %dying_pistol_aim_right;
	
	self.animArray["shoot"]		["left"] 		= %dying_pistol_shoot_left1;
	self.animArray["shoot"]		["straight"] 	= %dying_pistol_shoot_straight1;
	self.animArray["shoot"]		["right"]	 	= %dying_pistol_shoot_right1;
	
	self.animArray["shoot_2"]	["left"] 		= %dying_pistol_shoot_left2;
	self.animArray["shoot_2"]	["straight"] 	= %dying_pistol_shoot_straight2;
	self.animArray["shoot_2"]	["right"]	 	= %dying_pistol_shoot_right2;
	
	
	closeToZero = 0.01;
	self.aimyaw = 0;
	destYaw = 0;
	yawRate = 2;
//	yawRate = 20;
	angleArray["left"] = -45;
	angleArray["middle"] = 0;
	angleArray["right"] = 45;

	thread dyingShooting();
//	self clearanim(%dying_pistol_from_crawl_front, 0.5);
	self clearanim(%dying_base, 0);
		
	for (;;)
	{
		// conditions that cause early out on pistol dying guys
		if (!isalive(self.enemy))
		{
			// stops behavior if he has no enemy
			self notify ("stop_dying_pistol");
			assert(0); // should not be hittable because of the notify
		}
		destYaw = GetYawToOrigin(self.enemy.origin);

		if (destYaw > angleArray["right"] + 10)
			self notify ("stop_dying_pistol");
		if (destYaw < angleArray["left"] - 10)
			self notify ("stop_dying_pistol");
		if (self.enemy != level.player)
		{
			playerYaw = GetYawToOrigin(level.player.origin);
			if (playerYaw > angleArray["right"] + 10)
				self notify ("stop_dying_pistol");
			if (playerYaw < angleArray["left"] - 10)
				self notify ("stop_dying_pistol");
		}
			
		if (destYaw < angleArray["left"])
			destYaw = angleArray["left"];
		if (destYaw > angleArray["right"])
			destYaw = angleArray["right"];
			
		if (self.aimyaw > destYaw)
		{
			self.aimyaw -= yawRate;
			if (self.aimyaw < destYaw)
				self.aimyaw = destYaw;
		}
		if (self.aimyaw < destYaw)
		{
			self.aimyaw += yawRate;
			if (self.aimyaw > destYaw)
				self.aimyaw = destYaw;
		}

//		changeTime = abs(self.aimyaw - destyaw);
		self.aimyaw = destYaw;
			
		if (self.aimyaw<=angleArray["left"])
		{
			animWeights["left"] = 1;
			animWeights["middle"] = closeToZero;
			animWeights["right"] = closeToZero;
		}
		else if (self.aimyaw<angleArray["middle"])
		{
			leftFraction = ( angleArray["middle"] - self.aimyaw ) / ( angleArray["middle"] - angleArray["left"] );
			if (leftFraction < closeToZero)		leftFraction = closeToZero;
			if (leftFraction > 1-closeToZero)	leftFraction = 1-closeToZero;
			animWeights["left"] = leftFraction;
			animWeights["middle"] = (1 - leftFraction);
			animWeights["right"] = closeToZero;
		}
		else if (angleArray["right"])
		{
			middleFraction = ( angleArray["right"] - self.aimyaw ) / ( angleArray["right"] - angleArray["middle"] );
			if (middleFraction < closeToZero)	middleFraction = closeToZero;
			if (middleFraction > 1-closeToZero)	middleFraction = 1-closeToZero;
			animWeights["left"] = closeToZero;
			animWeights["middle"] = middleFraction;
			animWeights["right"] = (1 - middleFraction);
		}
		else
		{
			animWeights["left"] = closeToZero;
			animWeights["middle"] = closeToZero;
			animWeights["right"] = 1;
		}

		changeTime = 0.6;
		self setanim( %dying_left,		animWeights["left"],	changeTime );	// anim, weight, blend-time
		self setanim( %dying_straight,	animWeights["middle"],	changeTime );
		self setanim( %dying_right,		animWeights["right"],	changeTime );
		wait (changeTime);
	}
}

dyingShooting()
{
	self endon ("killanimscript");
	self endon ("stop_dying_pistol");
	
	destYaw = 0;
	thread dying_pistol_death();
	thread fireNotetracks();
	thread playerDistanceEnd();
	thread timeoutDeath();
	self notify ("long_death");
	self.accuracy = 0.2;
	for (;;)
	{
		if (isalive(self.enemy))
			destYaw = GetYawToOrigin(self.enemy.origin);
			
		if (abs(destYaw - self.aimyaw) > 5 || !isalive(self.enemy))
			playBlendAnimArray("aim", 0.2);
		else
		{
			if (randomint(100) > 50)
				playBlendAnimArray("shoot");
			else
				playBlendAnimArray("shoot_2");
		}			
		
		if (randomint(100) > 70)
			playBlendAnimArray("aim");
	}
}

timeoutDeath()
{
	self endon ("death");
	self endon ("stop_dying_pistol");
	wait (6 + randomfloat(5));
	self notify ("stop_dying_pistol");
}

dying_pistol_death()
{
	self endon ("death");
	self waittill ("stop_dying_pistol");
	
	self setanimknob (%dying_base, 1, 0.3, 1);
	self setflaggedanimknob ("deathanim", %dying_pistol_death, 1, 0.3, 1);
	wait (0.45);	
	throwVel = 15;
	self DropWeapon(self.weapon, self.anim_gunHand, throwVel);
	self.dropWeapon = false;
	animscripts\shared::PutGunInHand("none");
	
	self waittillmatch ("deathanim","end");
	self.anim_nodeath = true;
	self dodamage(self.health + 5, (0,0,0));
}

playerDistanceEnd()
{
	self endon ("death");
	self endon ("stop_dying_pistol");
	while ( distance(self.origin, level.player.origin) > 95 )
		wait (0.5);
	self notify ("stop_dying_pistol");
}

playBlendAnimArray(msg, timer)
{
	self setflaggedanimknob( "animend", self.animArray[msg]["straight"], 1, 0.15, 1);	// anim, weight, blend-time
	self setanimknob( self.animArray[msg]["left"], 1, 0.15, 1);	// anim, weight, blend-time
	self setanimknob( self.animArray[msg]["right"], 1, 0.15, 1);	// anim, weight, blend-time
	if (!isdefined(timer))
		self waittillmatch ("animend","end");
	else
		wait (timer);
}

fireNotetracks()
{
	self endon ("death");
	self endon ("stop_dying_pistol");
	numshots = randomint (2) + 3;
	for (i=0;i<numshots;i++)
	{
		self waittillmatch ("animend", "fire");
		self shootWrapper();
	}
	self notify ("stop_dying_pistol");
}

dying_pistol_check()
{
	if (!canDieFast())
		return false;
		
	if ( self.anim_movement != "stop")
		return false;
	
	
		
//	if ( self.health >= 35 )
//		return false;

	if ( distance(self.origin, level.player.origin) < 175)
		return false;

	self notify ("pain_death"); // pain that ends in death
	self.health = 1;
	return true;
}

chasedByPlayer()
{
	if (!isalive(self.enemy))
		return false;
	if (self.enemy != level.player)
		return false;
	if (distance(self.origin, level.player.origin) > 300)
		return false;
		
    forward = anglesToForward(self.angles);
	difference = vectornormalize(self.enemy.origin - self.origin);
    dot = vectordot(forward, difference);
//    println ("dot " + dot);
    return (dot < -0.6);
}

crawl()
{
	// does dying pistol instead
	if (randomint(100) > 75)
		return;

	if (self.secondaryweapon == "")
		self.weapon = "luger";
	else
		self.weapon = self.secondaryweapon;
	self animscripts\shared::PutGunInHand("right");
		
	proneTime = 0.5; // was 1
	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProneWrapper(proneTime); // make code start lerping in the prone orientation to ground
	self.anim_pose = "prone";
	self clearanim(%dying, 0.1);

	self setFlaggedAnimKnobAllRestart("crawlanim", %wounded_crawl2bellycrawl, %body, 1, .1, 1);
	self animscripts\shared::DoNoteTracks("crawlanim");
	crawlanim = %wounded_bellycrawl_forward;
	for (;;)
	{	
		localDeltaVector = GetMoveDelta (crawlanim, 0, 1);
		endPoint = self LocalToWorldCoords( localDeltaVector );
		if (!self maymovetopoint(endPoint))
			break;
			
		rate = 0.9;
		if (chasedByPlayer())
			rate = 1.5;
			
		self setFlaggedAnimKnobAllRestart("crawlanim", crawlanim, %body, 1, .1, rate);
		self animscripts\shared::DoNoteTracks("crawlanim");
	}
	
	self setFlaggedAnimKnobAllRestart("crawlanim", %wounded_bellycrawl_death, %body, 1, .1, 1);
	self animscripts\shared::DoNoteTracks("crawlanim");
	self.anim_nodeath = true;
	self animscripts\shared::DropAIWeapon(); // have to do it again since we have a new pistol in our hand
	self dodamage(self.health + 5, (0,0,0));
}


hitTorsoOrHigher()
{
	switch(self.damageLocation)
	{
		case "left_leg_upper":
		case "left_leg_lower":
		case "left_foot":
		case "right_leg_upper":
		case "right_leg_lower":
		case "right_foot":
			return false;
	}
	
	return true;
}

canDieFast()
{
	killable = (self.team == "axis" && !self.anim_disableLongDeath && self.health < 500);
	if (killable)
	{
		assert (self.team == "axis");
		assert (self.anim_disableLongDeath == false);
		assert (self.health < 500);
	}
	return killable;
}

