// combat_say.gsc
// Determines when to talk during combat.

init()
{
	// TEMP!!!!  Debugging to try to find why this function fails sometimes.
	oldValues = GetValues();


	// Per-team initialization - these need a seperate check from the per-guy because sometimes a guy's team 
	// will change during a level (eg when commisars shoot conscripts in Russian levels).
	if ( !isDefined(anim.lastSightedTime) || !isDefined(anim.lastSightedTime[self.team]) )
	{
		anim.lastSightedTime[self.team] = getTime();

		if ( !isDefined(anim.lastSayGrenadeTime) || !isDefined(anim.lastSayGrenadeTime[self.team]) )
		{
			anim.lastSayGrenadeTime[self.team] = getTime();
		}
		if ( !isDefined(anim.lastSayFlankTime) || !isDefined(anim.lastSayFlankTime[self.team]) )
		{
			anim.lastSayFlankTime[self.team] = getTime();
		}
	}

	// Per-guy initialization
	if (!isDefined(self.anim_lastTalkedTime))
	{
		self.anim_lastTalkedTime = getTime() - 5000 + randomint(15000);
		self.anim_lastTalkedRandomMult = randomfloat(1);
		self.anim_wasInCombat = false;
		self thread UsedByPlayerThread();
		self thread GrenadeDangerThread();
	}
	// TEMP!!!!  Debugging to try to find why this function fails sometimes.
	checkValues("init failed", oldValues);
}

GetValues()
{
	val["LastTalkedTime"] = self.anim_lastTalkedTime;
	val["LastSightedTime"] = anim.lastSightedTime;
	if (isDefined(anim.lastSightedTime))
		val["LastSightedTimeTeam"] = anim.lastSightedTime[self.team];
	val["LastSayGrenadeTime"] = anim.lastSayGrenadeTime;
	if (isDefined(anim.lastSayGrenadeTime))
		val["LastSayGrenadeTimeTeam"] = anim.lastSayGrenadeTime[self.team];
	val["LastSayFlankTime"] = anim.lastSayFlankTime;
	if (isDefined(anim.lastSayFlankTime))
		val["LastSayFlankTimeTeam"] = anim.lastSayFlankTime[self.team];
	return val;
}
CheckValues(locString, oldValues)
{
	if (	!isDefined(self.anim_lastTalkedTime)|| 
			!isDefined(anim.lastSightedTime)	||	!isDefined(anim.lastSightedTime[self.team])		||
			!isDefined(anim.lastSayGrenadeTime)	||	!isDefined(anim.lastSayGrenadeTime[self.team])	||
			!isDefined(anim.lastSayFlankTime)	||	!isDefined(anim.lastSayFlankTime[self.team])	)
	{
		newValues = GetValues();
		println ( locString );
		println ( "new values: ",newValues["LastTalkedTime"]," ",
					newValues["LastSightedTime"]," ",newValues["LastSightedTimeTeam"]," ",
					newValues["LastSayGrenadeTime"]," ",newValues["LastSayGrenadeTimeTeam"]," ",
					newValues["LastSayFlankTime"]," ",newValues["LastSayFlankTimeTeam"]
					);
		if (isDefined(oldValues))
		{
			println ( "old values: ",oldValues["LastTalkedTime"]," ",
					oldValues["LastSightedTime"]," ",oldValues["LastSightedTimeTeam"]," ",
					oldValues["LastSayGrenadeTime"]," ",oldValues["LastSayGrenadeTimeTeam"]," ",
					oldValues["LastSayFlankTime"]," ",oldValues["LastSayFlankTimeTeam"]
					);
		}
		println ("Team: ", self.team);
//		homemade_error = crap_out_now + please;
	}
}

// Plays miscellaneous combat lines sometimes during combat
generic_combat()
{
	init();

	if ( !self animscripts\utility::IsInCombat() )
	{
		self.anim_lastTalkedTime = getTime();	// Update so that guys don't all talk at once when they enter combat.
		self.anim_wasInCombat = false;
		return;
	}

	if (say_enemy_sighted())
		return;

	timeBetweenTalking = 30000 + (self.anim_lastTalkedRandomMult*20000);	// Time is in milliseconds.

	if (GetTime() > self.anim_lastTalkedTime + timeBetweenTalking)
	{
		self animscripts\face::SayGenericDialogue("misccombat");
		self.anim_lastTalkedTime = getTime();
	}
}

// Plays vaguely context-sensitive combat lines sometimes during combat
specific_combat(dialogueLine)
{
	init();

	if ( !self animscripts\utility::IsInCombat() )
	{
		self.anim_lastTalkedTime = getTime();	// Update so that guys don't all talk at once when they enter combat.
		self.anim_wasInCombat = false;
		return;
	}

	if (say_enemy_sighted())
		return;

	if ( dialogueLine=="flankLeft" || dialogueLine=="flankRight" )
	{
		timeBetweenTalking = 30000 + (self.anim_lastTalkedRandomMult*30000);	// Time is in milliseconds.
		if ( GetTime() > anim.lastSayFlankTime[self.team] + timeBetweenTalking )
		{
			self animscripts\face::SayGenericDialogue(dialogueLine);
			self.anim_lastTalkedTime = getTime();
			self.anim_lastTalkedRandomMult = randomfloat(1);
			anim.lastSayFlankTime[self.team] = getTime();
		}
	}
	else if ( dialogueLine=="coverme" )
	{
		timeBetweenTalking = 20000 + (self.anim_lastTalkedRandomMult*15000);	// Time is in milliseconds.
		if (GetTime() > self.anim_lastTalkedTime + timeBetweenTalking)
		{
			// Only say "cover me" if the player is close enough.
			player = animscripts\utility::GetPlayer();
			if ( distancesquared(self.origin, player.origin) < 128*128 )
			{
				self animscripts\face::SayGenericDialogue(dialogueLine);
				self.anim_lastTalkedTime = getTime();
				self.anim_lastTalkedRandomMult = randomfloat(1);
			}
		}
	}
	else
	{
		timeBetweenTalking = 20000 + (self.anim_lastTalkedRandomMult*15000);	// Time is in milliseconds.
		if (GetTime() > self.anim_lastTalkedTime + timeBetweenTalking)
		{
			self animscripts\face::SayGenericDialogue(dialogueLine);
			self.anim_lastTalkedTime = getTime();
			self.anim_lastTalkedRandomMult = randomfloat(1);
		}
	}
}

say_enemy_sighted()
{
	// If you call this function directly, make sure you've called combat_say::init() first.

	// If we've just entered combat, perhaps play an enemy sighted line.
	timeBetweenTalking = 10000 + (self.anim_lastTalkedRandomMult*10000);	// Time is in milliseconds.
	if (	( self.anim_wasInCombat == false ) &&
			( GetTime() > anim.lastSightedTime[self.team] + 20000 ) && 
			( GetTime() > self.anim_lastTalkedTime + timeBetweenTalking ) &&
			( isDefined(self.enemy) && self CanSee(self.enemy) )
			)
	{
		self animscripts\face::SayGenericDialogue("enemysighted");
		anim.lastSightedTime[self.team] = getTime();
		self.anim_lastTalkedRandomMult = randomfloat(1);
		return true;
	}
	else if ( isDefined(self.enemy) && self.team=="allies" )
	{
		// Remember if we have an enemy, so we don't do a sighted line on him later.
		anim.lastSightedTime[self.team] = getTime();		
	}
	return false;
}

UsedByPlayerThread()
{
	for (;;)
	{
		self waittill ("trigger");
		self animscripts\face::SayGenericDialogue("giveupposition");
		animscripts\look::TryToGlanceAtThePlayerNow();
		wait 5;		// Debounce time - so he doesn't do this behavior twice in quick succession.
	}
}

GrenadeDangerThread()
{
	for (;;)
	{
		self waittill ("grenade danger");
		// (We know that lasSayGrenadeTime is defined because this function is called from init, but if we 
		// switched teams, lasSayGrenadeTime[self.team] might not be.)
		if ( !isDefined(anim.lastSayGrenadeTime[self.team]) )
		{
			init();
		}
		if ( getTime() > anim.lastSayGrenadeTime[self.team] )
		{
			self animscripts\face::SayGenericDialogue("grenadedanger");
			// If someone else said it within the last 2 seconds, update GetTime so no one else will say it 
			// for a few seconds.  This means that only two people will say it at once.
			if (getTime() <= anim.lastSayGrenadeTime[self.team] + 2000)
			{
				anim.lastSayGrenadeTime[self.team] = GetTime() + 5000;
			}
			else
			{
				anim.lastSayGrenadeTime[self.team] = GetTime();
			}
		}
		wait 5;		// Debounce time - so one person doesn't do this behavior twice in quick succession.
	}
}

