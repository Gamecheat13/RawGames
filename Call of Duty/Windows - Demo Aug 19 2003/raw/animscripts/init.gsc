// Notes about scripts
//=====================
//
// Anim variables
// -------------- 
// Anim variables keep track of what the character is doing with respect to his 
// animations.  They know if he's standing, crouching, kneeling, walking, running, etc, 
// so that he can play appropriate transitions to get to the animation he wants.
// anim_movement - "stop", "walk", "run"
// anim_pose - "stand", "crouch", "prone", some others for pain poses.
// I'm putting functions to do the basic animations to change these variables in 
// SetPoseMovement.gsc, 
//
// Error Reporting
// ---------------
// To report a script error condition (similar to assert(0)), I assign a non-existent variable to 
// the variable homemade_error  I use the name of the non-existent variable to try to explain the 
// error.  For example:
// 		homemade_error = Unexpected_anim_pose_value + self.anim_pose;
// I also have a kind of assert, called as follows:
//		[[anim.assert]](condition, message_string);
// If condition evaluates to 0, the assert fires, prints message_string and stops the server. Since 
// I don't have stack traces of any kind, the message string needs to say from where the assert was 
// called.

#using_animtree ("generic_human");

main()
{
	// Initialization that should happen once per level
	if ( !isDefined (anim.NotFirstTime) ) // Use this to trigger the first init
	{
		anim.NotFirstTime = 1;
		AnimPrintln("initializing anim scripts");

		// Set up script entity for debugging
		if(getCvarInt ("animscriptent") <= 0) // This allows you to set an animscriptent and then restart
			setcvar("animscriptent", "-1");
		level thread UpdateDebugEnt();	// By making this a "level" thread, I prevent it from being deleted when the guy dies.

		anim.doSpam  = 1; // uncomment for location debug spam

		// Global function pointers
		anim.println = ::AnimPrintln;
		anim.locSpam = ::AnimLocSpam;
		anim.assert = ::AnimAssert;
		anim.PutGunInHand = animscripts\shared::PutGunInHand;

		// Global constants
        anim . CoverStandShots = 0;
        anim . lastSideStepAnim = 0;
		anim.meleeRangeSq = 64*64;
		anim.standRangeSq = 503.06*503.06;  // was .25 normalize from melee to prone
		anim.chargeRangeSq = 200*200;
		anim.backpedalRangeSq = 200*200;
		anim.proneRangeSq = 1000*1000;
		anim.dodgeRangeSq = 300*300;			// Guys only dodge when inside this range.
		anim.maxShuffleDistance = 50;
		anim.blindAccuracyMult["allies"] = 0.5;
		anim.blindAccuracyMult["axis"] = 0.1;
		anim.ramboAccuracyMult = 1.0;
		anim.runAccuracyMult = 0.5;
		anim.combatMemoryTimeConst = 10000;
		anim.combatMemoryTimeRand = 6000;

		animscripts\SetPoseMovement::InitPoseMovementFunctions();
		animscripts\WeaponList::initWeaponList();
		animscripts\face::InitLevelFace();
		
		anim.set_a_b[0] = "a";
		anim.set_a_b[1] = "b";
	
		anim.set_a_b_c[0] = "a";
		anim.set_a_b_c[1] = "b";
		anim.set_a_b_c[2] = "c";
	
		anim.set_a_c[0] = "a";
		anim.set_a_c[1] = "c";
		
		anim.num_to_letter[1] = "a";
		anim.num_to_letter[2] = "b";
		anim.num_to_letter[3] = "c";
		anim.num_to_letter[4] = "d";
		anim.num_to_letter[5] = "e";
		anim.num_to_letter[6] = "f";
		anim.num_to_letter[7] = "g";
		anim.num_to_letter[8] = "h";
		anim.num_to_letter[9] = "i";
		anim.num_to_letter[10] = "j";

		AnimPrintln("initialization of anim scripts complete");
	}
    
	// Set initial states for poses
	self.anim_movement = "stop";
	self.anim_pose = "stand";
	self.anim_idleSet = "none";
	self.anim_special = "none";
	self.anim_gunHand = "none";	// Initialize so that PutGunInHand works properly.
	self.anim_PrevPutGunInHandTime = -1;
	animscripts\shared::PutGunInHand("right");	
	self.anim_needsToRechamber = 0;
	self.anim_combatEndTime = gettime();
	self.anim_script = "init";
	self.anim_alertness = "casual"; // casual, alert, aiming
	self.anim_woundedBias = 0;	// 1 is left leg, -1 is right leg, 0 is neither (or upper body).
	self.anim_woundedAmount = 0;
	self.anim_woundedTime = GetTime();
	self.anim_lastWound = "upper";
	self.anim_lastDebugPrint = "";
	self.anim_StopCowering = ::DoNothing;	// This is a "handler" function.  SetPoseMovement could be 
											// written entirely with these.
											
	SetupUniqueAnims();

	thread animscripts\look::lookThread();
	thread animscripts\utility::UpdateDebugInfo();
	
	self animscripts\weaponList::RefillClip();	// Start with a full clip.

    // Things that were in scripts that should be done once, or on weapon switch
	if (animscripts\weaponList::usingAutomaticWeapon())
		self . ramboChance = 15;
	else if (animscripts\weaponList::usingSemiAutoWeapon())
		self . ramboChance = 7;
	else
		self . ramboChance = 0;
	if (self.team == "axis")
		self . ramboChance *= 2;

    self . coverIdleSelectTime = -696969;

//	if (self getentitynumber() == 120)
//		self thread printvoice();
}

DoNothing()
{
}

// Debug thread to see when stances are being allowed
PollAllowedStancesThread()
{
	for (;;)
	{
		if (self isStanceAllowed("stand"))
		{
			line[0] = "stand allowed";
			color[0] = (0,1,0);
		}
		else
		{
			line[0] = "stand not allowed";
			color[0] = (1,0,0);
		}
		if (self isStanceAllowed("crouch"))
		{
			line[1] = "crouch allowed";
			color[1] = (0,1,0);
		}
		else
		{
			line[1] = "crouch not allowed";
			color[1] = (1,0,0);
		}
		if (self isStanceAllowed("prone"))
		{
			line[2] = "prone allowed";
			color[2] = (0,1,0);
		}
		else
		{
			line[2] = "prone not allowed";
			color[2] = (1,0,0);
		}


		aboveHead = self GetEye() + (0,0,30);
		offset = (0,0,-10);
		for (i=0 ; i<line.size ; i++)
		{
			textPos = ( aboveHead[0]+(offset[0]*i), aboveHead[1]+(offset[1]*i), aboveHead[2]+(offset[2]*i) );
			print3d (textPos, line[i], color[i], 1, 0.75);	// origin, text, RGB, alpha, scale
		}
		wait 0.05;
	}
}

printvoice()
{
	for(;;)
	{
		println (self.voice);
		aboveHead = self GetEye() + (0,0,10);
		print3d (aboveHead, self.voice, (1,0,0), 1, 0.75);	// origin, text, RGB, alpha, scale
		wait 0.05;
	}
}

UpdateDebugEnt ()
{
    for (;;)
    {
        entNum = getCvarInt ("animscriptent");
        anim.debugEnt = getEntByNum(entNum); // handles -1 and returns undefined
        wait 1;
    }
}


AnimPrintln(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8, printString9, printString10, printString11, printString12, printString13, printString14)
{
	self.anim_lastDebugPrint = printString1;
	if (animscripts\utility::isDebugOn())
	{
		if (isDefined(printString14))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8, printString9, printString10, printString11, printString12, printString13, printString14);
		else if (isDefined(printString13))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8, printString9, printString10, printString11, printString12, printString13);
		else if (isDefined(printString12))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8, printString9, printString10, printString11, printString12);
		else if (isDefined(printString11))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8, printString9, printString10, printString11);
		else if (isDefined(printString10))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8, printString9, printString10);
		else if (isDefined(printString9))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8, printString9);
		else if (isDefined(printString8))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7, printString8);
		else if (isDefined(printString7))
	        println(printString1, printString2, printString3, printString4, printString5, printString6, printString7);
		else if (isDefined(printString6))
	        println(printString1, printString2, printString3, printString4, printString5, printString6);
		else if (isDefined(printString5))
	        println(printString1, printString2, printString3, printString4, printString5);
		else if (isDefined(printString4))
	        println(printString1, printString2, printString3, printString4);
		else if (isDefined(printString3))
	        println(printString1, printString2, printString3);
		else if (isDefined(printString2))
	        println(printString1, printString2);
		else
	        println(printString1);
	}
}

AnimLocSpam(printString)
{
    if ( isDefined (anim.doSpam) && (animscripts\utility::isDebugOn()) )
        println("script location: ",printString);        
}

AnimAssert( condition, printString)
{	if (!condition)
	{
		if (isDefined(self.anim_script))
			println("---------------ANIM ASSERT in "+self.anim_script+"-------------------");
		else
			println("---------------------ANIM ASSERT -------------------------");

        self DumpHistory ();
        println ( "INCLUDE AIHISTORY IN BUG" );

		// Get my entity number, in a way that works even if I'm not an AI
		myEntNum = "unknown";
		for (i = 0; i < 2048; i++)
		{
			ent = getentbynum(i);
			if (!isdefined(ent))
				continue;
			if (ent == self)
				myEntNum = i;
		}
		println ( "Entity: " + (myEntNum) );
		println ("Origin: "+self.origin);
        if (IsDefined(printString))
		{
			println(printString);
		}
		if (IsDefined(self.anim_debug_lastSetPoseMovement_Time))
		{
			println ("Last SetPoseMovement ended "+ (GetTime()-self.anim_debug_lastSetPoseMovement_Time) +" ms ago");
			println ("Previous pose: "+self.anim_debug_lastSetPoseMovement_oldPose);
			println ("Previous movement: "+self.anim_debug_lastSetPoseMovement_oldMovement);
			println ("Previous wounded: "+self.anim_debug_lastSetPoseMovement_oldWounded);
			println ("Previous special: "+self.anim_debug_lastSetPoseMovement_oldSpecial);
			println ("Desired pose: "+self.anim_debug_lastSetPoseMovement_desiredPose);
			println ("Desired movement: "+self.anim_debug_lastSetPoseMovement_desiredMovement);
			println ("Result pose: "+self.anim_debug_lastSetPoseMovement_resultPose);
			println ("Result movement: "+self.anim_debug_lastSetPoseMovement_resultMovement);
		}
		if ( IsDefined(self.anim_debug_string) )
			println (self.anim_debug_string);

		println("-------------------ANIM ASSERT ABOVE!  SCROLL UP! -----------------------");
		homemade_error = ANIM_ASSERT + failed;		
	}
}


// Set all unique animation variables for a character - unique run animations, unique playback rate, 
// whatever.  This function can get called several times during a level, so it needs to produce the same 
// "random" values on successive calls.
SetupUniqueAnims()
{

	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		switch ( self getentitynumber() % 3 )
		{
		case 0:
			self.anim_combatrunanim = %combatrun_forward_1;
			self.anim_crouchrunanim = %pistol_crouchrun_loop_forward_1;
			break;
		case 1:
			self.anim_combatrunanim = %combatrun_forward_2;
			self.anim_crouchrunanim = %pistol_crouchrun_loop_forward_2;
			break;
		case 2:
			self.anim_combatrunanim = %combatrun_forward_3;
			self.anim_crouchrunanim = %pistol_crouchrun_loop_forward_3;
			break;
		}
	}
	else
	{
		// There are four crouchrun loops but three run loops, and we want to make sure that the number three 
		// ones always get assigned together, so assign crouchrun 4 to 1/3 of the guys who get run 1 or 2.
		switch ( self getentitynumber() % 3 )
		{
		case 0:
			self.anim_combatrunanim = %combatrun_forward_1;
			if ( self getentitynumber() % 9 < 6 )
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_1;
			}
			else
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_4;
			}
			break;
		case 1:
			self.anim_combatrunanim = %combatrun_forward_2;
			if ( self getentitynumber() % 9 < 3 )
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_4;
			}
			else
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_2;
			}
			break;
		case 2:
			self.anim_combatrunanim = %combatrun_forward_3;
			self.anim_crouchrunanim = %crouchrun_loop_forward_3;
			break;
		}
	}
	if (!isDefined(self.animplaybackrate))
	{
		self.animplaybackrate = 0.8 + randomfloat(0.4);
	}
}
