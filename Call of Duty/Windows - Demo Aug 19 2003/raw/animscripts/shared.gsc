// Shared.gsc - Functions that are shared between animscripts and level scripts.  
// Functions in this file can't rely on the animscripts\init function having run, and can't call any 
// functions not allowed in level scripts.

#using_animtree ("generic_human");

// PutGunInHand - manages whether or not an AI is holding a gun, and in which hand he's holding it.
PutGunInHand(hand)
{
//	[[Anim.Assert]]( (hand=="left" || hand=="right" || hand=="none"), "Bad parameter to PutGunInHand - "+hand);
//	[[Anim.Assert]]( (self.anim_gunHand=="left" || self.anim_gunHand=="right" || self.anim_gunHand=="none"), "Init::PutGunInHand - "+self.anim_gunHand);

	weaponModel = getWeaponModel(self.weapon);

	if ( (isDefined(self.hasWeapon) && !self.hasWeapon) || weaponModel=="" )
	{
		hand = "none";
	}
	if (!isDefined(self.anim_gunInHand))
	{
		self.anim_gunInHand = "none";
	}

	if ( (hand == self.anim_gunHand) && (weaponModel == self.anim_gunInHand) )
	{
		// Nothing has changed.  Drop out.
		return;
	}

	time = gettime();
	if (self.anim_PrevPutGunInHandTime == time)
	{
		println("WARNING: redundant weapon hand change on AI ", self getEntityNumber());
	}
	else
	{
		self.anim_PrevPutGunInHandTime = time;
	}	

	// Detach the old gun from the old hand
	if (self.anim_gunHand=="left")
	{
		self detach(self.anim_gunInHand, "tag_weapon_left");
	}
	else if (self.anim_gunHand=="right")
	{
		self detach(self.anim_gunInHand, "tag_weapon_right");
	}

	// Attach the new gun to the new hand
	if(hand=="left")
	{
		self attach(weaponModel, "tag_weapon_left");
		self.anim_gunInHand = weaponModel;
		self.anim_gunHand = "left";
	}
	else if (hand=="right")
	{
		self attach(weaponModel, "tag_weapon_right");
		self.anim_gunInHand = weaponModel;
		self.anim_gunHand = "right";
	}
	else	// ie hand=="none"
	{
		self.anim_gunHand = "none";
		self.anim_gunInHand = undefined;
        //Makes some guns dissappear for unknown reason        self.weapon = "none";
	}

	// Make sure our run (and potentially other) animations are appropriate to our new weapon.
	animscripts\init::SetupUniqueAnims();
}

DropAIWeapon()
{
	if(self.dropWeapon)
	{
		throwVel = 75 + randomInt(50);
		self DropWeapon(self.weapon, self.anim_gunHand, throwVel);
	}
	[[anim.PutGunInHand]]("none");
}

LookAtEntity(lookTargetEntity, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	[[anim.assert]](isAI(self), "Can only call this function on an AI character");
	[[anim.assert]](self.anim_targetLookInitilized == true, "LookAtEntity called on AI that lookThread was not called on");
	[[anim.assert]](isDefined(lookTargetEntity), "lookTargetEntity is not defined");
	[[anim.assert]]( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");
	[[anim.assert]]( !isDefined(interruptOthers) || (interruptOthers=="interrupt") || (interruptOthers=="don't interrupt") );
	// If interruptOthers is set, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to "interrupt".
	if ( !isDefined(interruptOthers) || (interruptOthers=="interrupt") || (GetTime() > self.anim_lookEndTime) )
	{
		if(isSentient(lookTargetEntity))
			self.anim_lookTargetType = "sentient";
		else
			self.anim_lookTargetType = "entity";
		self.anim_lookTargetEntity = lookTargetEntity;
		self.anim_lookEndTime = GetTime() + (lookDuration*(float)1000);
		if(lookSpeed == "casual")
			self.anim_lookTargetSpeed = 800;
		else // alert
			self.anim_lookTargetSpeed = 1600;
		if ( isDefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}
}

LookAtPosition(lookTargetPos, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	[[anim.assert]](isAI(self), "Can only call this function on an AI character");
	[[anim.assert]](self.anim_targetLookInitilized == true, "LookAtPosition called on AI that lookThread was not called on");
	[[anim.assert]]( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");
	// If interruptOthers is true, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to true.
	if ( !isDefined(interruptOthers) || (interruptOthers=="interrupt others") || (GetTime() > self.anim_lookEndTime) )
	{
		self.anim_lookTargetPos = lookTargetPos;
		self.anim_lookEndTime = GetTime() + (lookDuration*(float)1000);
		if(lookSpeed == "casual")
			self.anim_lookTargetSpeed = 800;
		else // alert
			self.anim_lookTargetSpeed = 1600;
		if ( isDefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}
}

LookAtStop()
{
	[[anim.assert]](isAI(self), "Can only call this function on an AI character");
	[[anim.assert]](self.anim_targetLookInitilized == true, "LookAtStop called on AI that lookThread was not called on");

	animscripts\look::finishLookAt();
}

LookAtAnimations(leftanim, rightanim)
{
	self.anim_LookAnimationLeft = leftanim;
	self.anim_LookAnimationRight = rightanim;
}


SetInCombat(timeOfEffect)
{
	[[anim.println]]("SetInCombat called, time set to ",timeOfEffect);
	if (!isDefined(boolValue))
	{
		self.anim_combatEndTime = gettime() + anim.combatMemoryTimeConst + randomint(anim.combatMemoryTimeRand);
	}
	else
	{
		self.anim_combatEndTime = gettime() + (timeOfEffect*1000);
	}
}

// Makes sure a guy knows what wounded animations to play.  Damage location is a string, recommended values 
// are "torso", "left_leg_upper" and "right_leg_upper".  DamageTaken is an integer.  These values determine 
// whether or not to limp, and on which leg.  Leaving them undefined means that the wounds are not specific 
// to one leg or another, so the guy should just stagger.
// Note that this function doesn't actually cause damage.
UpdateWounds(damageLocation, damageTaken)
{
	if (!isDefined(damageLocation))
		damageLocation = "torso";
	if (!isDefined(damageTaken))
		damageTaken = 0;
	animscripts\pain::UpdateWounds(damageLocation, damageTaken);
}


// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an "end" or a "finish"
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(animName, ::customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
DoNoteTracks(animName, customFunction, debugIdentifier)
{
	if (!isDefined(debugIdentifier))
		debugIdentifier = "undefined";

	for (;;)
	{
		[[anim.println]](GetTime()," ",debugIdentifier," DoNotetracks - waiting for note on anim flagged ",animName,".");
		self waittill (animName, note);
		[[anim.println]] (GetTime()," ",debugIdentifier," DoNotetracks - Notetrack ",note," found on anim flagged ",animName,".");
		if (!isDefined(note))
		{
			note = "undefined";
		}
		switch (note)
		{
		case "end":
		case "finish":
		case "undefined":
			if ( isAI(self) && self.anim_pose=="back" ) 
			{
				[[anim.println]]("HACK!  Changing pose \"back\" to \"crouch\" in DoNoteTracks");
				self.anim_pose = "crouch";
			}
			return note;
		case "anim_pose = \"stand\"":
			if (self.anim_pose == "prone")
			{
				self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
				self exitprone(1.0); // make code stop lerping in the prone orientation to ground
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
			}
			self.anim_pose = "stand";
			break;
		case "anim_pose = \"crouch\"":
			if (self.anim_pose == "prone")
			{
				self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
				self exitprone(1.0); // make code stop lerping in the prone orientation to ground
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
			}
			self.anim_pose = "crouch";
			break;
		case "anim_pose = \"prone\"":
			self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
			self EnterProne(1.0); // make code start lerping in the prone orientation to ground
			self.anim_pose = "prone";
			break;
		case "anim_pose = \"back\"":
			if (self.anim_pose == "prone")
			{
				self exitprone(1.0); // make code stop lerping in the prone orientation to ground
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
			}
			self.anim_pose = "back";
			break;
		case "anim_movement = \"stop\"":
			self.anim_movement = "stop";
			break;
		case "anim_movement = \"walk\"":
			self.anim_movement = "walk";
			break;
		case "anim_movement = \"run\"":
			self.anim_movement = "run";
			break;
		case "anim_aiming = 1":
			self.anim_alertness = "aiming";
			break;
		case "anim_aiming = 0":
			self.anim_alertness = "alert";
			break;
		case "anim_alertness = casual":
			self.anim_alertness = "casual";
			break;
		case "anim_alertness = alert":
			self.anim_alertness = "alert";
			break;
		case "anim_alertness = aiming":
			self.anim_alertness = "aiming";
			break;
		case "anim_gunhand = \"left\"":
			[[anim.PutGunInHand]]("left");
			break;
		case "anim_gunhand = \"right\"":
			[[anim.PutGunInHand]]("right");
			break;
		case "anim_gunhand = \"none\"":
			[[anim.PutGunInHand]]("none");
			break;
		case "gravity on":
            self animMode ("gravity");
			break;
		case "gravity off":
            self animMode ("nogravity");
			break;
		case "bodyfall large":
			if ( isAI(self) && isdefined(self.groundType) )
				self playsound ("bodyfall_" + self.groundType + "_large");
			else
				self playsound ("bodyfall_dirt_large");	// Should I even play anything here?
			break;
		case "bodyfall small":
			if ( isAI(self) && isdefined(self.groundType) )
				self playsound ("bodyfall_" + self.groundType + "_small");
			else
				self playsound ("bodyfall_dirt_small");	// Should I even play anything here?
			break;
		case "attach clip right":
			// Attach the clip or magazine for my current gun to my right hand
			break;
		case "detach clip right":
			// Detach the clip or magazine for my current gun to my right hand...verify that it's there first.
			break;
		case "rechamber":
			self.anim_needsToRechamber = 0;
			break;
		case "reload done":
			self animscripts\weaponList::RefillClip();
			self.anim_needsToRechamber = 0;
			break;
		case "anim_melee = \"right\"":
			self.anim_meleeState = "right";
			break;
		case "anim_melee = \"left\"":
			self.anim_meleeState = "left";
			break;
		case "footstep":
		case "step":
			if ( isAI(self) && isdefined(self.groundType) )
				self playsound ("step_run_" + self.groundType);
			else
				self playsound ("step_run_dirt");	// Should I even play anything here?
			break;
		case "footscrape":
			if ( isAI(self) && isdefined(self.groundType) )
				self playsound ("step_scrape_" + self.groundType);
			else
				self playsound ("step_scrape_dirt");	// Should I even play anything here?
			break;
		case "swish small":
			self playsound ("melee_swing_large");
			break;
		case "swish large":
			self playsound ("melee_swing_small");
			break;
		case "dropgun":
			DropAIWeapon();
			break;
		default:
			[[anim.println]] ("Notetrack "+note+" not handled by DoNoteTracks. Calling custom function");
			if (isDefined(customFunction))
			{
				[[anim.println]] ("Custom function found, being called.");
				[[customFunction]] (note);
			}
			else
			{
				[[anim.println]] ("No custom function found.");
			}
			break;
		}
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
DoNoteTracksForever(animName, killString, customFunction, debugIdentifier)
{
	self endon (killString);
	self endon ("killanimscript");
	if (!isDefined(debugIdentifier))
		debugIdentifier = "undefined";
	self thread AnimPrintlnOnNotify((debugIdentifier+" DoNoteTracksForever on "+animName+" was terminated."), killstring, "killanimscript");

	for (;;)
	{
		time = GetTime();
		returnedNote = DoNoteTracks(animName, customFunction, debugIdentifier);
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = DoNoteTracks(animName, customFunction, debugIdentifier);
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
				println (GetTime()+" "+debugIdentifier+" animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+animname+", returned "+returnedNote+".");
				wait ( 0.05 - timetaken );
			}
		}
		[[anim.println]](GetTime()+" "+debugIdentifier+" DoNoteTracksForever returned in "+timetaken+" ms.");
	}
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
DoNoteTracksForTime(time, animName, customFunction, debugIdentifier)
{
	thread DoNoteTracksForever(animName, "Stop DoNoteTracks", customFunction, debugIdentifier);
	wait (time);
	self notify ("Stop DoNoteTracks");
}

// Lets me know if either of the notifies were triggered.  The second notify parameter is optional.
AnimPrintlnOnNotify(printString, notifystring1, notifystring2)
{
	self endon ("death");
	if (isDefined(notifystring2))
	{
		self endon (notifystring2);
		self thread AnimPrintlnOnNotify2( (printString+" ("+notifystring2+")"), notifystring1, notifystring2);
	}
	self waittill (notifystring1);
	[[anim.println]](GetTime()+" "+printString+" ("+notifystring1+")");
}
AnimPrintlnOnNotify2(printString, notifystring1, notifystring2)
{
	self endon ("death");
	self endon (notifystring1);
	self waittill (notifystring2);
	[[anim.println]](GetTime()+" "+printString);
}
