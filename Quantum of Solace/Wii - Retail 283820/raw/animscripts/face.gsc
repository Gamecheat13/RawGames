





InitCharacterFace()
{
	if (!anim.useFacialAnims)
		return;
		
	
	
	if (!isDefined(self.a.currentDialogImportance))
	{
		self.a.currentDialogImportance = 0;	
		self.a.idleFace = anim.alertface;
		self.faceWaiting = [];
		self.faceLastNotifyNum = 0;
	}
}




SayGenericDialogue(typeString)
{
	


	
	
	
	
	
	


	
	voiceString = self.voice;
	assertEX(isDefined(voiceString));
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
	else if (voiceString == "arab")
	{
		voicenum = 1 + ( self getentitynumber() % anim.numArabVoices );
		voiceString = voiceString + "_" + voicenum;
	}
	
	faceAnim = undefined;

	switch (typeString)
	{

	case "meleecharge":
	case "meleeattack":

		importance = 0.5;
		break;
	case "pain":

		importance = 0.9;
		break;
	case "death":

		importance = 1.0;
		break;
	default:
		println ("Unexpected generic dialog string: "+typeString);
		importance = 0.3;
		break;
	}
	
	soundAlias = "generic_" + typeString + "_" + voiceString;
	
	self thread PlayFaceThread (faceAnim, soundAlias, importance);
}

SetIdleFaceDelayed(facialAnimationArray)
{
	self animscripts\battleChatter::playBattleChatter();
	
	self.a.idleFace = facialAnimationArray;
}




SetIdleFace(facialAnimationArray)
{
	if (!anim.useFacialAnims)
		return;

	self animscripts\battleChatter::playBattleChatter();
	
	self.a.idleFace = facialAnimationArray;
	self PlayIdleFace();
}












SaySpecificDialogue(facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait)
{
	
	self thread PlayFaceThread (facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait);
}


ChooseAnimFromSet( animSet )
{
	return;	

}









PlayIdleFace()
{
	return;	
}






PlayFaceThread(facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait)
{
	self.a.facialAnimDone = true;
	self.a.facialSoundDone = true;
	
	if (isdefined (notifyString))
	{
		if (isDefined(soundAlias))
		{
			self playsound(soundAlias, "animscript facesound" + notifyString, true);
			
			self thread WaitForFaceSound(notifyString);
		}
	}
	else
		self playsound(soundAlias);
			
	if (!anim.useFacialAnims)
		return;
	
	InitCharacterFace();

	if ( !isDefined(facialanim) && !isDefined(soundAlias) )
	{
		
		assertEX(0, "Either facialanim or soundAlias should be defined when calling PlayFaceThread or SaySpecificDialogue");
		if (isDefined(notifyString))
		{
			wait (0);	
			self.faceResult = "failed";
			self notify(notifyString);
		}
		return;
	}

	self endon ("death");
	
	if (isString(importance))
	{
		switch (importance)
		{
		case "any":
			importance = 0.1;
			break;

		case "pain":
			importance = 0.9;
			break;

		case "death":
			importance = 1.0;
			break;
		}
	}

	if ( (importance <= self.a.currentDialogImportance) && ( isDefined(waitOrNot) && (waitOrNot=="wait") ) )
	{
		
		
		thisEntryNum = self.faceWaiting.size;
		thisNotifyNum = self.faceLastNotifyNum + 1;
		self.faceWaiting[thisEntryNum]["facialanim"]	= facialanim;
		self.faceWaiting[thisEntryNum]["soundAlias"]	= soundAlias;
		self.faceWaiting[thisEntryNum]["importance"]	= importance;
		self.faceWaiting[thisEntryNum]["notifyString"]	= notifyString;
		self.faceWaiting[thisEntryNum]["waitOrNot"]		= waitOrNot;
		self.faceWaiting[thisEntryNum]["timeToWait"]	= timeToWait;
		self.faceWaiting[thisEntryNum]["notifyNum"]		= thisNotifyNum;	
		
		
		
		
		self thread PlayFace_WaitForNotify( ("animscript face stop waiting "+self.faceWaiting[thisEntryNum]["notifyNum"]), "Face done waiting", "Face done waiting");
		if (isDefined(timeToWait))
			self thread PlayFace_WaitForTime(timeToWait, "Face done waiting", "Face done waiting");
		self waittill ("Face done waiting");
		
		
		thisEntryNum = undefined;
		for ( i=0 ; i<self.faceWaiting.size ; i++ )
		{
			if (self.faceWaiting[i]["notifyNum"] == thisNotifyNum)
			{
				thisEntryNum = i;
				break;
			}
		}
		assertEX( isDefined(thisEntryNum) );
		
		if (self.a.faceWaitForResult == "notify")
		{
			
			PlayFaceThread(	self.faceWaiting[thisEntryNum]["facialanim"], 
							self.faceWaiting[thisEntryNum]["soundAlias"], 
							self.faceWaiting[thisEntryNum]["importance"], 
							self.faceWaiting[thisEntryNum]["notifyString"]
							);
		}
		else	
		{
			if ( isDefined(notifyString) )
			{
				self.faceResult = "failed";
				self notify(notifyString);
			}
		}
		
		
		
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
	else if (importance >= self.a.currentDialogImportance)
	{
		
		self notify ("end current face");
		self endon ("end current face");
		
		
		
			
		
		if ( isDefined(notifyString) )
		{
			if ( isDefined(self.a.currentDialogNotifyString) )
			{
				self.faceResult = "interrupted";
				self notify(self.a.currentDialogNotifyString);
			}
		}
		
		self.a.currentDialogImportance = importance;
		self.a.currentDialogSound = soundAlias;	
		self.a.currentDialogNotifyString = notifyString;

		
		self.a.facialAnimDone = true;
		self.a.facialSoundDone = true;
		
		if (isDefined(facialanim))
		{

			self setflaggedanimknobrestart("animscript faceanim", facialanim, 1, .1, 1);
			self.a.facialAnimDone = false;
			self thread WaitForFacialAnim();
			
		}
		
		if (isDefined(soundAlias))
		{






			self playsound(soundAlias, "animscript facesound", true);
			self.a.facialSoundDone = false;
			self thread WaitForFaceSound();
			
		}
		
		while ( (!self.a.facialAnimDone) || (!self.a.facialSoundDone) )
		{
			self waittill("animscript facedone");
		}
		
		
		self.a.currentDialogImportance = 0;
		self.a.currentDialogSound = undefined;
		self.a.currentDialogNotifyString = undefined;
		if ( isDefined(notifyString) )
		{
			self.faceResult = "finished";
			self notify(notifyString);
		}
		if ( isDefined(self.faceWaiting) && (self.faceWaiting.size > 0) )
		{
			
			
			maxImportance = 0;
			nextFaceNum = 1;
			
			for ( i=0 ; i<self.faceWaiting.size ; i++)
			{
				
				if ( self.faceWaiting[i]["importance"] > maxImportance )
				{
					maxImportance = self.faceWaiting[i]["importance"];
					nextFaceNum = i;
				}
			}
			
			
			self notify ( "animscript face stop waiting "+self.faceWaiting[nextFaceNum]["notifyNum"] );
		}
		else
		{
			
			
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
		
	}
}

WaitForFacialAnim()	
{
	self endon ("death");
	self endon ("end current face");
	self animscripts\shared::DoNoteTracks ("animscript faceanim");
	self.a.facialAnimDone = true;
	self notify ("animscript facedone");
}

WaitForFaceSound(msg)	
{
	self endon ("death");
	self waittill("animscript facesound" + msg);
	self notify (msg);
}

PlayFace_WaitForNotify(waitForString, notifyString, killmeString)
{
	self endon ("death");
	self endon (killmeString);
	self waittill (waitForString);
	self.a.faceWaitForResult = "notify";
	self notify (notifyString);
}

PlayFace_WaitForTime(time, notifyString, killmeString)
{
	self endon ("death");
	self endon (killmeString);
	wait (time);
	self.a.faceWaitForResult = "time";
	self notify (notifyString);
}


#using_animtree ("generic_human"); 
InitLevelFace()
{
	

	
	
	
	
	anim.numAmericanVoices = 8;
	anim.numBritishVoices = 8;
	anim.numRussianVoices = 8;
	anim.numArabVoices = 8;
}
