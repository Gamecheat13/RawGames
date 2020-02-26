#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Run Main", "code" );
	self endon("killanimscript");
	previousScript = self.anim_script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
    animscripts\utility::initialize("run");
	self animscripts\utility::StartDebugString("RunStart");

	// Prototype hack - make Price limp
	if ((isdefined (self.targetname)) && (self.targetname == "pricespawn"))
	{
		self animscripts\walk::PriceLimp();	
		return;
	}

	// If I'm wounded, I act differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::move("run::main");
	}

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
		animscripts\combat_say::specific_combat("coverme");
		break;
	default:
		// Say random shit.
		animscripts\combat_say::generic_combat();
	}


	runningReloadFraction = 0.1;
	timesThrough = 0;
	for (;;)
	{
		timesThrough += 1;;
		self animscripts\utility::AddToDebugString(" RA");
		self notify ("stopRunning");
		// Shoot at my enemy:
		// if I have bullets in my gun, and
		// if I am not running from a grenade (easy and medium only, enemies only) and
		// if I don't have a panzerfaust, and
		// if I'm facing my enemy and I can hit him from here.
		shootWhileRunning =	(!animscripts\combat::NeedsToReload(runningReloadFraction)) &&
							( !isDefined(self.grenade) || GetDifficulty()=="easy" || GetDifficulty()=="medium" || self.team=="axis" ) &&
							(self animscripts\utility::weaponAnims() != "panzerfaust") &&
							(animscripts\utility::AbsYawToEnemy()<25) && 
							(animscripts\utility::canShootEnemy());

		// Decide what pose to use 
		if (self.anim_pose == "prone")
		{
			preferredPose = "crouch";
		}
		else if ( (self.anim_pose == "crouch") && (randomInt(100) > 90) )
		{
			preferredPose = "stand";
		}
		else if (shootWhileRunning)
		{
			// If I'm going to shoot while running I want to be standing.  
			preferredPose = "stand";
		}
		else
		{
			preferredPose = self.anim_pose;
		}
		desiredPose = self animscripts\utility::choosePose(preferredPose);
		shootWhileRunning = shootWhileRunning && ( (desiredPose == "stand") || (desiredPose == "crouch") );

		// So if I'm allowed to shoot while running, do that.  Otherwise run normally.
		if (shootWhileRunning)
		{
			self animscripts\utility::AddToDebugString(" RB");
			debugMovement = self.anim_movement;
			debugPose = self.anim_pose;
			// I can blend directly from a stand aim pose to the running shooting pose, but if I'm crouched 
			// or prone I need to stand up.  (TODO If I'm not aiming should I play a transition animation?)
			// Same goes for crouch.
			if ( (self.anim_pose != "stand") && (desiredPose == "stand") )
			{
				self [[anim.SetPoseMovement]]("stand","run");
			}
			else if ( (self.anim_pose != "crouch") && (desiredPose == "crouch") )
			{
				self [[anim.SetPoseMovement]]("crouch","run");
			}
			[[anim.assert]]((desiredPose == "stand")||(desiredPose == "crouch"), "run::main "+self.anim_movement+" "+self.anim_pose+", "+desiredPose+", "+debugMovement+" "+debugPose);
			[[anim.assert]](self.anim_pose == desiredPose, "run::main "+self.anim_movement+" "+self.anim_pose+", "+desiredPose+", "+debugMovement+" "+debugPose);

			//self setanimknoball(%stand_shoot_run_forward, %body, 1, .2, 1);	// TODO This should be a blend of directions

			// Play the appropriately weighted run animations for the direction he's moving
			if (self.anim_pose == "stand")
			{
				self thread UpdateRunWeights(	"stopRunning", 
												%stand_shoot_run_forward, 
												%stand_shoot_run_back, 
												%stand_shoot_run_left,
												%stand_shoot_run_right
												);
				self setflaggedanimknoball("runanim", %stand_shoot_run, %body, 1, 0.2);
			}
			else
			{
				self thread UpdateRunWeights(	"stopRunning", 
												%crouch_shoot_run_forward, 
												%crouch_shoot_run_back, 
												%crouch_shoot_run_left,
												%crouch_shoot_run_right
												);
				self setflaggedanimknoball("runanim", %crouch_shoot_run, %body, 1, 0.2);
			}


//			self thread MakeRunSounds ( "killSoundThread" );
			self thread animscripts\shared::DoNoteTracksForever("runanim", "end runanim", undefined, timesThrough);
			if ( (self.anim_alertness == "casual") || (self.anim_movement != "run") )	// Happens if we didn't change pose
			{
				wait 0.25;
				self.anim_alertness = "aiming";
				self.anim_movement = "run";
			}
			self animscripts\utility::AddToDebugString(" RC");

			// Drop out immediately if we now need to change poses; otherwise, shoot
			desiredPose = self animscripts\utility::choosePose(self.anim_pose);
			if (desiredPose == self.anim_pose)
			{
				self animscripts\combat::ShootRunningVolley();

				// Drop out immediately if we now need to change poses; otherwise, run for a moment
				desiredPose = self animscripts\utility::choosePose(self.anim_pose);
				if (desiredPose == self.anim_pose)
					wait 0.25;	// Space out volleys, mainly because it makes the game sound cooler.
			}
			self notify ("end runanim");
		}
		else	// Not shooting while running.
		{
			self animscripts\utility::AddToDebugString(" RD");
			debugMovement = self.anim_movement;
			debugPose = self.anim_pose;
			self [[anim.SetPoseMovement]](desiredPose,"run");

			[[anim.assert]](self.anim_movement == "run", "run::main "+self.anim_movement+" "+self.anim_pose+", "+desiredPose+", "+debugMovement+" "+debugPose);
			[[anim.assert]]((desiredPose == "stand")||(desiredPose == "crouch")||(desiredPose == "prone"), "run::main "+self.anim_movement+" "+self.anim_pose+", "+desiredPose+", "+debugMovement+" "+debugPose);
			[[anim.assert]](self.anim_pose == desiredPose, "run::main "+self.anim_movement+" "+self.anim_pose+", "+desiredPose+", "+debugMovement+" "+debugPose);

			// Drop out immediately if we need to change poses again; otherwise, keep running
			desiredPose = self animscripts\utility::choosePose(self.anim_pose);
			if (desiredPose != self.anim_pose)
			{
				self animscripts\utility::AddToDebugString(" RE1");
				continue;	// This drops out of this cycle of the loop.
			}
			self animscripts\utility::AddToDebugString(" RE2");
			switch (desiredPose)
			{
			case "stand":
				if ( self animscripts\utility::IsInCombat() )
				{
					self clearanim(%combatrun, 0.6);
					// If we're going to reload, use a lower weight on the run animation so the upper-body reload plays more strongly.
					if (animscripts\combat::NeedsToReload(runningReloadFraction))
					{
						self setanimknoball(%combatrun, %body, 0.1, 0.5, self.animplaybackrate);
					}
					else
					{
						self setanimknoball(%combatrun, %body, 1, 0.5, self.animplaybackrate);
					}
					// If the ld has specified a run animation, use that exclusively.
					if (isDefined(self.run_combatanim))
					{
						self setflaggedanimknob("runanim", self.run_combatanim, 1, 0.5);
					}
					else
					{
						// If we're wounded, play a wounded run animation, otherwise play the run for our character.
						if (GetTime() < self.anim_woundedTime) 
						{
							if (self.anim_lastWound == "left")
								self setflaggedanimknob("runanim", %wounded_leftleg_run_forward, 1, 0.3);
							else if (self.anim_lastWound == "right")
								self setflaggedanimknob("runanim", %wounded_rightleg_run_forward, 1, 0.3);
							else
								self setflaggedanimknob("runanim", %wounded_run_forward1, 1, 0.3);
						}
						// Rather than blending in limping animations, we just want to pick the best one to play.
						else if (self.anim_woundedAmount > 0.5)	// Limp if you're more than 1/2 wounded.
						{
							if (self.anim_woundedBias > 0.5) woundedBias = "left";
							else if (self.anim_woundedBias < -0.5) woundedBias = "right";
							else woundedBias = "none";
							switch (woundedBias)
							{
							case "left":
								currentLimpAnim = chooseAnim(currentLimpAnim, 0.8,	%wounded_leftleg_run_forward, .1, 
																					%wounded_run_forward1, .05, 
																					%wounded_run_forward2, .05);
							case "right":
								currentLimpAnim = chooseAnim(currentLimpAnim, 0.8,	%wounded_rightleg_run_forward, .1, 
																					%wounded_run_forward1, .05, 
																					%wounded_run_forward2, .05);
							case "none":
								currentLimpAnim = chooseAnim(currentLimpAnim, 0.8,	%wounded_leftleg_run_forward, .04, 
																					%wounded_run_forward1, .08, 
																					%wounded_run_forward2, .08);
							}
							self setflaggedanimknob ("runanim", currentLimpAnim, 1, 0.3);
						}
						else
						{
							self setflaggedanimknob ("runanim", self.anim_combatrunanim, 1, 0.3);
						}

						// Play the appropriately weighted run animations for the direction he's moving
						self thread UpdateRunWeights(	"stopRunning", 
														%combatrun_forward,
														%combatrun_back, 
														%combatrun_left,
														%combatrun_right
														);
					}
					//self thread MakeRunSounds ( "killSoundThread" );
					self thread animscripts\shared::DoNoteTracksForever("runanim", "end runanim", undefined, timesThrough);
					if (animscripts\combat::NeedsToReload(runningReloadFraction))
					{
						animscripts\combat::Reload(runningReloadFraction);
					}
					else
					{
						wait 0.2;
					}
					self notify ("end runanim");
				}
				else
				{    
					self clearanim(%combatrun, 0.6);
					// Play the appropriately weighted run animations for the direction he's moving
					if (isDefined(self.run_noncombatanim))
					{
						self setflaggedanimknoball("runanim", self.run_noncombatanim, %body, 1, 0.3);
					}
					else
					{
						// If we're wounded, play a wounded run animation, otherwise play the run for our character.
						if (GetTime() < self.anim_woundedTime) 
						{
							if (self.anim_lastWound == "left")
								self setflaggedanimknob("runanim", %wounded_leftleg_run_forward, 1, 0.3);
							else if (self.anim_lastWound == "right")
								self setflaggedanimknob("runanim", %wounded_rightleg_run_forward, 1, 0.3);
							else
								self setflaggedanimknob("runanim", %wounded_run_forward1, 1, 0.3);
						}
						// Rather than blending in limping animations, we just want to pick the best one to play.
						else if (self.anim_woundedAmount > 0.5)	// Limp if you're more than 1/2 wounded.
						{
							if (self.anim_woundedBias > 0.5) woundedBias = "left";
							else if (self.anim_woundedBias < -0.5) woundedBias = "right";
							else woundedBias = "none";
							switch (woundedBias)
							{
							case "left":
								currentLimpAnim = chooseAnim(currentLimpAnim, 0.8,	%wounded_leftleg_run_forward, .1, 
																					%wounded_run_forward1, .05, 
																					%wounded_run_forward2, .05);
							case "right":
								currentLimpAnim = chooseAnim(currentLimpAnim, 0.8,	%wounded_rightleg_run_forward, .1, 
																					%wounded_run_forward1, .05, 
																					%wounded_run_forward2, .05);
							case "none":
								currentLimpAnim = chooseAnim(currentLimpAnim, 0.8,	%wounded_leftleg_run_forward, .04, 
																					%wounded_run_forward1, .08, 
																					%wounded_run_forward2, .08);
							}
							self setflaggedanimknob ("runanim", currentLimpAnim, 1, 0.3);
						}
						else
						{
							self setanimknob(%precombatrun1, 1, 0.3);
						}
						// Play the appropriately weighted animations for the direction he's moving.
						self thread UpdateRunWeights(	"stopRunning", 
														%combatrun_forward, 
														%combatrun_back, 
														%combatrun_left,
														%combatrun_right
														);
						self setflaggedanimknoball("runanim", %combatrun, %body, 1, 0.2, self.animplaybackrate);
					}
					//self thread MakeRunSounds ( "killSoundThread" );
					self thread animscripts\shared::DoNoteTracksForever("runanim", "end runanim", undefined, timesThrough);
					wait 0.2;
					self notify ("end runanim");
				}
				break;
			case "crouch":
				if (isDefined(self.crouchrun_combatanim))
				{
					self setflaggedanimknoball("runanim", self.crouchrun_combatanim, %body, 1, 0.4, self.animplaybackrate);
				}
				else
				{
					// Play the appropriately weighted crouchrun animations for the direction he's moving
					self setanimknob(self.anim_crouchrunanim, 1, 0.4);
					self thread UpdateRunWeights(	"stopRunning", 
													%crouchrun_loop_forward, 
													%crouchrun_loop_back, 
													%crouchrun_loop_left,
													%crouchrun_loop_right
													);
					self setflaggedanimknoball("runanim", %crouchrun, %body, 1, 0.2, self.animplaybackrate);
				}
				//self thread MakeRunSounds ( "killSoundThread" );
				self thread animscripts\shared::DoNoteTracksForever("runanim", "end runanim", undefined, timesThrough);
				wait 0.2;
				self notify ("end runanim");
				break;
			case "prone":
				self setflaggedanimknoball("runanim",%prone_crawl, %body, 1, .3, 1);
				self thread animscripts\shared::DoNoteTracksForever("runanim", "end runanim", undefined, timesThrough);
				wait 0.25;
				self notify ("end runanim");
				break;
			default:
				println ("run.gsc, unhandled desiredPose: "+desiredPose);
				break;
			}
			self animscripts\utility::AddToDebugString(" RF");
		}
	}
}

// Chooses an animation, from a list of options.  Uses "currentAnim" only if it's in the list of options (in 
// which case it has two chances of being chosen). probabilityCurrent is used as-is (if it's used at all).  
// The other probabilities are normalized to take the total to 1.
chooseAnim(currentAnim, probabilityCurrent, option1, probability1, option2, probability2, option3, probability3)
{
	// Find out which options are defined
	numOptions=0;
	if (isDefined(option1))
	{
		realOption[numOptions] = option1;
		realProbability[numOptions] = probability1;
		numOptions++;
	}
	if (isDefined(option2))
	{
		realOption[numOptions] = option2;
		realProbability[numOptions] = probability2;
		numOptions++;
	}
	if (isDefined(option3))
	{
		realOption[numOptions] = option3;
		realProbability[numOptions] = probability3;
		numOptions++;
	}
	// Find out if the current animation is a valid option
	currentIsAnOption = false;
	if (isDefined(currentAnim))
	{
		for (i=0 ; i<numOptions ; i++)
		{
			if (realOption[i] == currentAnim)
			{
				currentIsAnOption = true;
				break;
			}
		}
	}
	if (!currentIsAnOption)
		probabilityCurrent = 0;

	// Decide whether or not to stick with the current animation
	rand = randomfloat(1);
	if (rand < probabilityCurrent)
		choice = currentAnim;
	else
	{
		// Normalize the other options' probabilities
		totalProb = (float)0;
		for (i=0 ; i<numOptions ; i++)
		{
			totalProb += realProbability[i];
		}
		for (i=0 ; i<numOptions ; i++)
		{
			realProbability[i] /= totalProb;
		}
		
		// Decide which of the other options we want
		rand = randomfloat(1);
		totalProb = (float)0;
		for (i=0 ; i<numOptions ; i++)
		{
			totalProb += realProbability[i];
			if (totalProb > rand)
			{
				choice = realOption[i];
				break;
			}
		}
	}
	// We can assume that a choice was made.
	[[anim.assert]](isDefined(choice));

	return choice;
}


UpdateRunWeights(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
	self endon("killanimscript");
	self endon(notifystring);

	for (;;)
	{
		animWeights = animscripts\utility::QuadrantAnimWeights (self getMotionAngle()+180);
//		self clearanim(rootAnim, 0.2);
//		self setanimknoball(rootAnim, %body, 0.2);
		self setanim(frontAnim, animweights["front"], 0.2, 1);
		self setanim(backAnim, animweights["back"], 0.2, 1);
		self setanim(leftAnim, animweights["left"], 0.2, 1);
		self setanim(rightAnim, animweights["right"], 0.2, 1);
		wait 0.2;
	}
}

// TODO Make this use the notetrack from the run animation playing.
MakeRunSounds ( notifystring )
{
	self endon("killanimscript");
	self endon(notifystring);
	for (;;)
	{
		wait .5;
		self playsound ("misc_step1");
		wait .5;
		self playsound ("misc_step2");
	}
}
