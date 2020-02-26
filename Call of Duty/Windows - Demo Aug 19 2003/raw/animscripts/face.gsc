// face.gsc
// Supposed to handle all facial and dialogue animations from regular scripts.
//#using_animtree ("generic_human"); - This file doesn't call animations directly.



InitCharacterFace()
{
	// Does any per-character initialization which is required by this facial animation script.  
	// InitLevelFace must be called before this function.
	if (!isDefined(self.anim_currentDialogImportance))
	{
		self.anim_currentDialogImportance = 0;	// Indicates that we are not currently saying anything.
		self.anim_idleFace = anim.alertface;
		self.faceWaiting = [];
		self.faceLastNotifyNum = 0;
	}
}


// Makes a character say the specified line in his voice, if he's not already saying something more 
// important.  
SayGenericDialogue(typeString)
{
	// First pick a random voice number for our character.  We have to do this every time because it's 
	// possible for the character to be changed after the level loads (generally right before it starts).
	// Use (entity number) modulus (number of voices) to get a consistent result.
	voiceString = self.voice;
	[[anim.assert]](isDefined(voiceString));
//	if ( !isDefined(voiceString) )
//	{
//		println ("Voice not defined!");
//		if (self.team == "axis")
//		{
//			voiceString = "german_1";
//		}
//		else
//		{
//			voiceString = "american_1";
//		}
//	}
//	else 
		if (voiceString == "american")
	{
		voicenum = 1 + ( self getentitynumber() % anim.numAmericanVoices );
		voiceString = voiceString + "_" + voicenum;
	}
	else if (voiceString == "british")
	{
		voicenum = 1 + ( self getentitynumber() % anim.numBritishVoices );
		voiceString = voiceString + "_" + voicenum;
	}
	else if (voiceString == "russian")
	{
		voicenum = 1 + ( self getentitynumber() % anim.numRussianVoices );
		voiceString = voiceString + "_" + voicenum;
	}
	else if (voiceString == "german")
	{
		voicenum = 1 + ( self getentitynumber() % anim.numGermanVoices );
		voiceString = voiceString + "_" + voicenum;
	}

	switch (typeString)
	{
	case "enemysighted":
		if (self.team == "axis")
		{
			// Germans call out different things when they see Russians than when they see Americans, for 
			// example, so we need to distinguish the sound aliases.
			if (!isDefined(level.campaign))	// This should only be necessary for test maps.
			{
				level.campaign = "american";
			}
			voiceString = voiceString + "v" + level.campaign;	
		}
		importance = 0.1;
		break;
	case "greetplayerloud":
	case "greetplayerquiet":
		importance = 0.1;
	case "grenadedanger":
		// It's important for Germans to call out when they throw a grenade, and for allies to call out when 
		// they see a grenade, so that the player is more aware of grenade danger.
		if (self.team == "axis")
			importance = 0.3;
		else
			importance = 0.4;
		break;
	case "grenadeattack":
		if (self.team == "axis")
			importance = 0.4;
		else
			importance = 0.3;
		break;
	case "misccombat":
	case "doingsuppression":
	case "enemykilled":
		importance = 0.1;
		break;
	case "coverme":
	case "undersuppression":
	case "flankleft":
	case "flankright":
		importance = 0.2;
		break;
	case "meleecharge":
	case "meleeattack":
		faceAnim = animscripts\face::ChooseAnimFromSet(anim.meleeFace);
		importance = 0.5;
		break;
	case "giveupposition":
		importance = 0.4;
		break;
	case "pain":
		faceAnim = animscripts\face::ChooseAnimFromSet(anim.painFace);
		importance = 0.9;
		break;
	case "death":
		faceAnim = animscripts\face::ChooseAnimFromSet(anim.deathFace);
		importance = 1.0;
		break;
	default:
		println ("Unexpected generic dialog string: "+typeString);
		importance = 0.3;
		break;
	}
	// Now assemble the sound alias and try to play it.
	soundAlias = "generic_" + typeString + "_" + voiceString;
	// Note that faceAnim is allowed to be undefined.
	self thread PlayFaceThread (faceAnim, soundAlias, importance);
}

// Sets the facial expression to return to when not saying dialogue.
// The array is animation1, weight1, animation2, weight2, etc.  The animations will play in turn - each time 
// one finishes a new one will be chosen randomly based on weight.
SetIdleFace(facialAnimationArray)
{
	self.anim_idleFace = facialAnimationArray;
	self PlayIdleFace();
}

// Makes the character play the specified sound and animation.  The anim and the sound are optional - you 
// can just defined one if you don't have both.
// Generally, importance should be in the range of 0.6-0.8 for scripted dialogue.
// Importance is a float, from 0 to 1.  
// 0.0 - Idle expressions
// 0.1-0.5 - most generic dialogue
// 0.6-0.8 - most scripted dialogue 
// 0.9 - pain
// 1.0 - death
// Importance can also be one of these strings: "any", "pain" or "death", which specfies what sounds can 
// interrupt this one.
SaySpecificDialogue(facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait)
{
	[[anim.println]]("SaySpecificDialog, facial: ",facialanim,", sound: ",soundAlias,", importance: "+importance+", notify: ",notifyString, ", WaitOrNot: ", waitOrNot, ", timeToWait: ", timeToWait);
	self thread PlayFaceThread (facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait);
}

// Takes an array with a set of "anim" entries and a corresponding set of "weight" entries.
ChooseAnimFromSet( animSet )
{
	// First, normalize the weights.
	totalWeight = 0;
	numAnims = animSet["anim"].size;
	for ( i=0 ; i<numAnims ; i++ )
	{
		totalWeight += animSet["weight"][i];
	}
	for ( i=0 ; i<numAnims ; i++ )
	{
		animSet["weight"][i] = (float)animSet["weight"][i] / (float)totalWeight;
	}

	// Now choose an animation.
	rand = randomfloat(1);
	runningTotal = 0;
	for ( i=0 ; i<numAnims ; i++ )
	{
		runningTotal += animSet["weight"][i];
		if (runningTotal >= rand)
		{
			chosenAnim = i;
			break;
		}
	}
	[[anim.assert]](isDefined(chosenAnim), "Logic error in ChooseAnimFromSet.  Rand is " + rand + ".");
	return animSet["anim"][chosenAnim];
}



//-----------------------------------------------------
// Housekeeping functions - these are for internal use
//-----------------------------------------------------

// PlayIdleFace doesn't force an idle animation to play - it will interrupt a current idle animation, but it 
// won't play over a more important animation, like dialogue.
PlayIdleFace()
{
	// Choose which idle anim to play.
	faceAnim = ChooseAnimFromSet ( self.anim_idleFace );
	// Try to play this face using the normal facial animation mechanism.  This will ensure that it doesn't 
	// overwrite a more important face.
	self thread PlayFaceThread(faceAnim, undefined, 0.0);
}

// PlayFaceThread is the workhorse of the system - it checks the importance, and if it's high enough, it 
// plays the animation and/or sound specified.
// I'm in the process of adding the waitOrNot parameter, which decides what to do if another animation/sound is already playing.
// Options: "wait" or undefined.  TimeToWait is an optional timeout time for waiting.
PlayFaceThread(facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait)
{
	InitCharacterFace();

	self endon ("death");

	if (importance=="any")
	{
		importance = 0.1;
	}
	else if (importance=="pain")
	{
		importance = 0.9;
	}
	else if (importance=="death")
	{
		importance = 1.0;
	}

	if ( (importance <= self.anim_currentDialogImportance) && ( isDefined(waitOrNot) && (waitOrNot=="wait") ) )
	{
		[[anim.println]]("Face: Waiting to play sound: ",soundAlias,", anim: ",facialanim,", ", notifyString,(", importance "+importance+", old one "+self.anim_currentDialogImportance));
		// Put this face at the end of the queue
		thisEntryNum = self.faceWaiting.size;
		thisNotifyNum = self.faceLastNotifyNum + 1;
		self.faceWaiting[thisEntryNum]["facialanim"]	= facialanim;
		self.faceWaiting[thisEntryNum]["soundAlias"]	= soundAlias;
		self.faceWaiting[thisEntryNum]["importance"]	= importance;
		self.faceWaiting[thisEntryNum]["notifyString"]	= notifyString;
		self.faceWaiting[thisEntryNum]["waitOrNot"]		= waitOrNot;
		self.faceWaiting[thisEntryNum]["timeToWait"]	= timeToWait;
		self.faceWaiting[thisEntryNum]["notifyNum"]		= thisNotifyNum;	// Unique identifier.
		
		// What we do now is, wait for both the notify and the time.  If the time expires first, we give 
		// up and remove this entry from the queue.  If the notify happens first, we stop waiting for the 
		// time and we play the face.
		self thread PlayFace_WaitForNotify( ("animscript face stop waiting "+self.faceWaiting[thisEntryNum]["notifyNum"]), "Face done waiting", "Face done waiting");
		if (isDefined(timeToWait))
			self thread PlayFace_WaitForTime(timeToWait, "Face done waiting", "Face done waiting");
		self waittill ("Face done waiting");
		
		// First, find the entry, since it may have been moved.
		thisEntryNum = undefined;
		for ( i=0 ; i<self.faceWaiting.size ; i++ )
		{
			if (self.faceWaiting[i]["notifyNum"] == thisNotifyNum)
			{
				thisEntryNum = i;
				break;
			}
		}
		[[anim.assert]]( isDefined(thisEntryNum) );
		
		if (self.anim_faceWaitForResult == "notify")
		{
			// Play the face.
			PlayFaceThread(	self.faceWaiting[thisEntryNum]["facialanim"], 
							self.faceWaiting[thisEntryNum]["soundAlias"], 
							self.faceWaiting[thisEntryNum]["importance"], 
							self.faceWaiting[thisEntryNum]["notifyString"]
							);
		}
		else	// ie We timed out.
		{
			if ( isDefined(notifyString) )
			{
				self.faceResult = "failed";
				self notify(notifyString);
			}
		}
		
		// Remove this entry from the queue.  If any entries have been added after this one, move them 
		// forward.  
		for (i = thisEntryNum+1 ; i < self.faceWaiting.size ; i++)
		{
			self.faceWaiting[i-1]["facialanim"]		= self.faceWaiting[i]["facialanim"];
			self.faceWaiting[i-1]["soundAlias"]		= self.faceWaiting[i]["soundAlias"];
			self.faceWaiting[i-1]["importance"]		= self.faceWaiting[i]["importance"];
			self.faceWaiting[i-1]["notifyString"]	= self.faceWaiting[i]["notifyString"];
			self.faceWaiting[i-1]["waitOrNot"]		= self.faceWaiting[i]["waitOrNot"];
			self.faceWaiting[i-1]["timeToWait"]		= self.faceWaiting[i]["timeToWait"];				
			self.faceWaiting[i-1]["notifyNum"]		= self.faceWaiting[i]["notifyNum"];
		}
		self.faceWaiting[self.faceWaiting.size-1] = undefined;
		
	}
	else if (importance >= self.anim_currentDialogImportance)
	{
		// End any threads that are waiting on current facial animations or sounds.
		self notify ("end current face");
		self endon ("end current face");
		[[anim.println]]("Face: Playing facial sound/animation: ", facialanim, ", ",soundAlias,", ",notifyString, ", ",importance);
		if (self.anim_currentDialogImportance > 0)
		{	
			[[anim.println]]("Face: Interrupted facial sound/animation: ",self.anim_currentDialogSound,", ",self.anim_currentDialogNotifyString, ", ",self.anim_currentDialogImportance);
		}
		if ( isDefined(notifyString) )
		{
			if ( isDefined(self.anim_currentDialogNotifyString) )
			{
				self.faceResult = "interrupted";
				self notify(self.anim_currentDialogNotifyString);
			}
		}
		// Remember what we're doing, so we can decide what to do if another face tries to interrupt this one.
		self.anim_currentDialogImportance = importance;
		self.anim_currentDialogSound = soundAlias;	// (This one is only used for debugging.)
		self.anim_currentDialogNotifyString = notifyString;

		// Set finished to true so that if we don't play one of these, we don't have to wait for it to finish.
		self.anim_facialAnimDone = true;
		self.anim_facialSoundDone = true;
		// Play the anim and sound, if they are defined.
		if (isDefined(facialanim))
		{
//			self setanim(%facial, 0.01, .1, 1);	// This doesn't work for non-AI
			self setflaggedanimknobrestart("animscript faceanim", facialanim, 1, .1, 1);
			self.anim_facialAnimDone = false;
			self thread WaitForFacialAnim();
			[[anim.println]]("Face: Waiting for facial animation ", facialanim);
		}
		//else TODO play a generic, looping facial animation.
		if (isDefined(soundAlias))
		{
// TEMP These lines break sound for most lines because of a bug in facial animation (code bug?).  When that 
// bug is fixed, put these lines back in.
//			if ( isDefined(facialanim) && animhasnotetrack(facialanim, "dialogue"))
//			{
//				self waittillmatch ("animscript faceanim", "dialogue");
//			}
			self playsound(soundAlias, "animscript facesound", true);
			self.anim_facialSoundDone = false;
			self thread WaitForFaceSound();
			[[anim.println]]("Face: Waiting for sound ",soundAlias);
		}
		// Now wait until both animation and sound are finished
		while ( (!self.anim_facialAnimDone) || (!self.anim_facialSoundDone) )
		{
			self waittill("animscript facedone");
		}
		// Set importance to 0 so that other facial anims (like the idle) can play.
		[[anim.println]]("Face: Finished facial sound: ",soundAlias,", animation: ",facialanim," notify: ",notifyString,", importance ",importance);
		self.anim_currentDialogImportance = 0;
		self.anim_currentDialogSound = undefined;
		self.anim_currentDialogNotifyString = undefined;
		if ( isDefined(notifyString) )
		{
			self.faceResult = "finished";
			self notify(notifyString);
		}
		if ( isDefined(self.faceWaiting) && (self.faceWaiting.size > 0) )
		{
			// Find out which face we want to play next.  Look through the queue for the highest priority 
			// face.  If we find more than one with the same importance, choose the one that was added first.
			maxImportance = 0;
			nextFaceNum = 1;
			[[anim.println]]("Choosing next face.  List is:");
			for ( i=0 ; i<self.faceWaiting.size ; i++)
			{
				[[anim.println]](" ",i," ",	(self.faceWaiting[i]["facialanim"]),", ",
											(self.faceWaiting[i]["soundAlias"]),", ",
											(self.faceWaiting[i]["importance"]),", ",
											(self.faceWaiting[i]["notifyString"])
											);
				if ( self.faceWaiting[i]["importance"] > maxImportance )
				{
					maxImportance = self.faceWaiting[i]["importance"];
					nextFaceNum = i;
				}
			}
			[[anim.println]]("Chose ", nextFaceNum);
			// Notify the entry in the queue, to play.
			self notify ( "animscript face stop waiting "+self.faceWaiting[nextFaceNum]["notifyNum"] );
		}
		else
		{
			// We're done.  Set an idle face going before we exit.
			// TODO Make the idle face play whenever the animation finishes, for cases when it finishes before the sound.
			if (IsSentient(self))
			{
				self PlayIdleFace();
			}
		}
	}
	else
	{
		if ( isDefined(notifyString) )
		{
			self.faceResult = "failed";
			self notify(notifyString);
		}
		[[anim.println]]("Face: Didn't play facial sound: ",soundAlias,", animation: ",facialanim," notify: ",notifyString,", importance ",importance,", old one ",self.anim_currentDialogImportance);
	}
}

WaitForFacialAnim()	// Used solely by PlayFaceThread
{
	self endon ("death");
	self endon ("end current face");
	self animscripts\shared::DoNoteTracks ("animscript faceanim");
	self.anim_facialAnimDone = true;
	self notify ("animscript facedone");
}

WaitForFaceSound()	// Used solely by PlayFaceThread
{
	self endon ("death");
	self endon ("end current face");
	self waittill("animscript facesound");
	self.anim_facialSoundDone = true;
	self notify ("animscript facedone");
}

PlayFace_WaitForNotify(waitForString, notifyString, killmeString)
{
	self endon ("death");
	self endon (killmeString);
	self waittill (waitForString);
	self.anim_faceWaitForResult = "notify";
	self notify (notifyString);
}

PlayFace_WaitForTime(time, notifyString, killmeString)
{
	self endon ("death");
	self endon (killmeString);
	wait (time);
	self.anim_faceWaitForResult = "time";
	self notify (notifyString);
}


#using_animtree ("generic_human"); // This section of the file calls animations directly since it's only used on AI.
InitLevelFace()
{
	// Does per-level initialization of facial stuff.

	// These numbers indicate how many different sound aliases there are in dialog_generic.csv for each 
	// nationality.  This script will assign each guy a random voice number from 1 to the number indicated 
	// for his voice nationality below.  If we add a new voice type to dialog_generic.csv, we need to update 
	// these numbers accordingly.
	anim.numAmericanVoices = 7;
	anim.numBritishVoices = 6;
	anim.numRussianVoices = 6;
	anim.numGermanVoices = 3;

	// Set up arrays of facial idles
	anim.alertface["anim"][0]	= %facial_alert02;
	anim.alertface["weight"][0]	= 1;
	anim.alertface["anim"][1]	= %facial_neutral;
	anim.alertface["weight"][1]	= 1;
	anim.alertface["anim"][2]	= %facial_alert01;
	anim.alertface["weight"][2]	= 1;

	anim.aimface["anim"][0]		= %facial_aim02;
	anim.aimface["weight"][0]	= 12;
	anim.aimface["anim"][1]		= %facial_aim;
	anim.aimface["weight"][1]	= 7;
	anim.aimface["anim"][2]		= %facial_angst;
	anim.aimface["weight"][2]	= 1;

	anim.autofireface["anim"][0]	= %facial_angst;
	anim.autofireface["weight"][0]	= 1;
	anim.autofireface["anim"][1]	= %facial_angst02;
	anim.autofireface["weight"][1]	= 1;
	anim.autofireface["anim"][2]	= %facial_angst03;
	anim.autofireface["weight"][2]	= 1;

	anim.meleeface["anim"][0]	= %facial_yell;
	anim.meleeface["weight"][0]	= 12;
	anim.meleeface["anim"][1]	= %facial_yell02;
	anim.meleeface["weight"][1]	= 7;
	anim.meleeface["anim"][2]	= %facial_angst03;
	anim.meleeface["weight"][2]	= 1;

	anim.painface["anim"][0]	= %facial_pain;
	anim.painface["weight"][0]	= 6;
	anim.painface["anim"][1]	= %facial_pain02;
	anim.painface["weight"][1]	= 3;
	anim.painface["anim"][2]	= %facial_yell;
	anim.painface["weight"][2]	= 1;

	anim.deathface["anim"][0]	= %facial_dead1;
	anim.deathface["weight"][0]	= 1;
	anim.deathface["anim"][1]	= %facial_dead2;
	anim.deathface["weight"][1]	= 1;
	anim.deathface["anim"][2]	= %facial_dead3;
	anim.deathface["weight"][2]	= 1;
	anim.deathface["anim"][3]	= %facial_dead4;
	anim.deathface["weight"][3]	= 1;
	anim.deathface["anim"][4]	= %facial_dead5;
	anim.deathface["weight"][4]	= 1;
}
