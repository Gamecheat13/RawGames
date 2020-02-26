#include animscripts\Utility;
#include animscripts\weaponList;
#include common_scripts\utility;
#include animscripts\Combat_Utility;
#using_animtree ("generic_human");

main()
{
	self setflashbanged(false);
	
	if ([[anim.difficultyFunc]]())
		return;	
	if (self.a.disablePain)
		return;
		
	self.a.painTime = gettime();

	if (self.a.nextStandingHitDying)
		self.health = 1;

	dead = false;
	stumble = false;
	
	ratio = self.health / self.maxHealth;
	
//	println ("hit at " + self.damagelocation);
	
    self trackScriptState( "Pain Main", "code" );
    self notify ("anim entered pain");
	self endon("killanimscript");

	// Two pain animations are played.  One is a longer, detailed animation with little to do with the actual 
	// location and direction of the shot, but depends on what pose the character starts in.  The other is a 
	// "hit" animation that is very location-specific, but is just a single pose for the affected bones so it 
	// can be played easily whichever position the character is in.
    animscripts\utility::initialize("pain");
    
    self animmode("gravity");

	//thread [[anim.println]] ("Shot in "+self.damageLocation+" from "+self.damageYaw+" for "+self.damageTaken+" hit points");#/

	self animscripts\face::SayGenericDialogue("pain");

	if ( specialPain( self.a.special ) )
		return;

	//self thread PlayHitAnimation();

	if ( crawlingPain() )
		return;	
	
	painAnim = getPainAnim();
	
	/#
	if ( getdvarint("scr_paindebug") == 1 )
		println( "^2Playing pain: ", painAnim, " ; pose is ", self.a.pose );
	#/
	
	playPainAnim( painAnim );
}

getPainAnim()
{
	if ( self.a.pose == "stand" )
	{
		if ( self.a.movement == "run" && (self getMotionAngle()<60) && (self getMotionAngle()>-60) )
			return getRunningForwardPainAnim();
		
		return getStandPainAnim();
	}
	else if ( self.a.pose == "crouch" )
	{
		return getCrouchPainAnim();
	}
	else if ( self.a.pose == "prone" )
	{
		return getPronePainAnim();
	}
	else
	{
		assert( self.a.pose == "back" );
		return %back_pain;
	}
}

getRunningForwardPainAnim()
{
	// simple random choice for now
	painArray = array( %run_pain_fallonknee, %run_pain_fallonknee_02, %run_pain_fallonknee_03, %run_pain_stomach, %run_pain_stumble );

	painArray = removeBlockedAnims( painArray );
	if ( !painArray.size )
		return getStandPainAnim();
	
	return painArray[ randomint( painArray.size ) ];
}

getStandPainAnim()
{
	painArray = [];
	
	if ( weaponAnims() == "pistol" )
	{
		if ( self damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
			painArray[painArray.size] = %pistol_stand_pain_chest;
		if ( self damageLocationIsAny( "torso_lower", "left_leg_upper", "right_leg_upper" ) )
			painArray[painArray.size] = %pistol_stand_pain_groin;
		if ( self damageLocationIsAny( "head", "neck" ) )
			painArray[painArray.size] = %pistol_stand_pain_head;
		if ( self damageLocationIsAny( "left_arm_lower", "left_arm_upper", "torso_upper" ) )
			painArray[painArray.size] = %pistol_stand_pain_leftshoulder;
		if ( self damageLocationIsAny( "right_arm_lower", "right_arm_upper", "torso_upper" ) )
			painArray[painArray.size] = %pistol_stand_pain_rightshoulder;
		
		if ( painArray.size < 2 )
			painArray[painArray.size] = %pistol_stand_pain_chest;
		if ( painArray.size < 2 )
			painArray[painArray.size] = %pistol_stand_pain_groin;
	}
	else
	{
		damageAmount = self.damageTaken / self.maxhealth;

		if ( damageAmount > .4 && !damageLocationIsAny( "left_hand", "right_hand", "left_foot", "right_foot", "helmet" ) )
			painArray[painArray.size] = %exposed_pain_2_crouch;
		if ( self damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
			painArray[painArray.size] = %exposed_pain_back;
		if ( self damageLocationIsAny( "right_hand", "right_arm_upper", "right_arm_lower", "torso_upper" ) )
			painArray[painArray.size] = %exposed_pain_dropgun;
		if ( self damageLocationIsAny( "torso_lower", "left_leg_upper", "right_leg_upper" ) )
			painArray[painArray.size] = %exposed_pain_groin;
		if ( self damageLocationIsAny( "left_hand", "left_arm_lower", "left_arm_upper" ) )
			painArray[painArray.size] = %exposed_pain_left_arm;
		if ( self damageLocationIsAny( "right_hand", "right_arm_lower", "right_arm_upper" ) )
			painArray[painArray.size] = %exposed_pain_right_arm;
		if ( self damageLocationIsAny( "left_foot", "right_foot", "left_leg_lower", "right_leg_lower", "left_leg_upper", "right_leg_upper" ) )
			painArray[painArray.size] = %exposed_pain_leg;
		
		if ( painArray.size < 2 )
			painArray[painArray.size] = %exposed_pain_back;
		if ( painArray.size < 2 )
			painArray[painArray.size] = %exposed_pain_dropgun;
	}

	assertex( painArray.size > 0, painArray.size );
	return painArray[ randomint( painArray.size ) ];
}


removeBlockedAnims( array )
{
	newArray = [];
	for ( index = 0; index < array.size; index++ )
	{
		localDeltaVector = getMoveDelta( array[index], 0, 1 );
		endPoint = self localToWorldCoords( localDeltaVector );

		if ( self mayMoveToPoint( endPoint ) )
			newArray[newArray.size] = array[index];
	}
	return newArray;
}

getCrouchPainAnim()
{
	painArray = [];

	if ( damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		painArray[painArray.size] = %exposed_crouch_pain_chest;
	if ( damageLocationIsAny( "head", "neck", "torso_upper" ) )
		painArray[painArray.size] = %exposed_crouch_pain_headsnap;
	if ( damageLocationIsAny( "left_hand", "left_arm_lower", "left_arm_upper" ) )
		painArray[painArray.size] = %exposed_crouch_pain_left_arm;
	if ( damageLocationIsAny( "right_hand", "right_arm_lower", "right_arm_upper" ) )
		painArray[painArray.size] = %exposed_crouch_pain_right_arm;
	
	if ( painArray.size < 2 )
		painArray[painArray.size] = %exposed_crouch_pain_flinch;
	if ( painArray.size < 2 )
		painArray[painArray.size] = %exposed_crouch_pain_chest;
	
	assertex( painArray.size > 0, painArray.size );
	return painArray[ randomint( painArray.size ) ];
}

getPronePainAnim()
{
	if ( randomint(2) == 0 )
		return %prone_painA_holdchest;
	else
		return %prone_painB_holdhead;
}


playPainAnim( painAnim )
{
	self setFlaggedAnimKnobAllRestart( "painanim", painAnim, %body, 1, .1 );
	
	if ( self.a.pose == "prone" )
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);

	self animscripts\shared::DoNoteTracks( "painanim" );
}


// Special pain is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the pain for the special animation state, or false if it wants the regular 
// pain function to handle it.
specialPain( anim_special )
{
	if (anim_special == "none")
		return false;

//	self thread PlayHitAnimation();
	
	switch ( anim_special )
	{
	case "cover_left":
		if (self.a.pose == "stand")
		{
			painArray = [];
			if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painB; // groin hit
			if ( self damageLocationIsAny("torso_lower", "torso_upper", "left_arm_upper", "right_arm_upper", "neck") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painC; // chest hit
			if ( self damageLocationIsAny("left_leg_upper", "left_leg_lower", "left_foot") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painD; // left leg hit
			if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painE; // right leg hit
			if ( painArray.size < 2 )
				painArray[painArray.size] = %corner_standl_pain; // dizzy fall against wall
			self.a.special = anim_special; // stay in this pose for more pain/death
			CornerPain(painArray);
			handled = true;
		}
		else
			handled = false;
		break;
	case "cover_right":
		if (self.a.pose == "stand")
		{
			painArray = [];
			if ( self damageLocationIsAny("right_arm_upper", "torso_upper", "neck") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standr_pain; // right shoulder hit
			if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standr_painB; // right leg hit
			if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standr_painC; // groin hit
			if ( painArray.size == 0 ) {
				painArray[0] = %corner_standr_pain;
				painArray[1] = %corner_standr_painB;
				painArray[2] = %corner_standr_painC;
			}
			self.a.special = anim_special; // stay in this pose for more pain/death
			CornerPain(painArray);
			handled = true;
		}
		else
			handled = false;
		break;
	case "cover_crouch":
		handled = false;
		break;
	case "cover_stand":
		painArray = [];
		if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_groin; // groin hit
		if ( self damageLocationIsAny("torso_lower", "torso_upper", "left_arm_upper", "right_arm_upper", "neck") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_groin; // chest hit
		if ( self damageLocationIsAny("left_leg_upper", "left_leg_lower", "left_foot") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_leg; // left leg hit
		if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_leg; // right leg hit
		if ( painArray.size < 2 )
			painArray[painArray.size] = %coverstand_pain_leg;
		self.a.special = anim_special; // stay in this pose for more pain/death
		CornerPain(painArray);
		handled = true;
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
		if (self.a.pose == "stand")
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

CornerPain( painArray )
{
	painAnim = painArray[randomint(painArray.size)];
	
	self setflaggedanimknob( "painanim", painAnim, 1, .3, 1);
	self animscripts\shared::DoNoteTracks ("painanim");
}

mg42pain()
{
//		assertmsg("mg42 pain anims not implemented yet");//scripted_mg42gunner_pain
		
	/#
	assertEx ( isdefined( level.mg_animmg ), "You're missing maps\\_mganim::main();  Add it to your level." );
	{
		println("	maps\\_mganim::main();");
		return;
	}
	#/

	self setflaggedanimknob( "painanim", level.mg_animmg[ "pain" ], 1, .1, 1);
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

	self.a.movement = "stop";
}

PlayHitAnimation()
{
	// Note the this thread doesn't endon "killanimscript" like most thread, because I don't want it to die 
	// when a new script starts.

	animWeights = animscripts\utility::QuadrantAnimWeights( self.damageYaw + 180 );

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
	self setanim (%dying_straight, 1, 0.5, 1);
	self setflaggedanimknob ("dying", %dying_pistol_aim_straight, 1, 0.5, 1);
	if (self.a.pose == "prone")
	{
		self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	
	self.a.pose = "back";
	self.a.movement = "stop";
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
    /*
	self DropWeapon(self.weapon, self.a.gunHand, throwVel);
	self.dropWeapon = false;
	animscripts\shared::PutGunInHand("none");
	*/
	self waittillmatch ("deathanim","end");
	self.a.nodeath = true;
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
		
	if ( self.a.movement != "stop")
		return false;
	
	if ( isDefined( self.deathFunction ) )
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
	/*
	if (randomint(100) > 75)
		return;
	*/
	
	//notify ac130 missions that a guy is crawling so context sensative dialog can be played
	level notify ( "ai_crawling", self );
	
//	self animscripts\shared::PutGunInHand("right");
	// TODO: put sidearm in hand

	
	proneTime = 0.5; // was 1
	self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
	self EnterProneWrapper(proneTime); // make code start lerping in the prone orientation to ground
	self.a.pose = "prone";
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
	self.a.nodeath = true;
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
	killable = (self.team == "axis" && !self.a.disableLongDeath && self.health < 500);
	if (killable)
	{
		assert (self.team == "axis");
		assert (self.a.disableLongDeath == false);
		assert (self.health < 500);
	}
	return killable;
}


crawlingPain()
{
	/#
	if ( getDvarInt( "scr_forceCrawl" ) == 1 )
	{
		self.health = 10;
		self crawlingPistol();
		return;
	}
	#/
	
	if ( self.a.disableLongDeath )
		return false;
	
	if ( self.team != "axis" )
		return false;
		
	if ( self.health > 35 )
		return false;

	if ( self.a.movement != "stop")
		return false;
	
	if ( isDefined( self.deathFunction ) )
		return false;
		
	if ( distance(self.origin, level.player.origin) < 175)
		return false;

	if ( self hitTorsoOrHigher() )
		return false;
		
	if ( randomFloat( 1 ) > 0.5 )
		return false;
		
	if ( usingSidearm() )
		return false;
	
	self crawlingPistol();
}


crawlingPistol()
{
	self endon ( "killanimscript" );
	self endon ( "death" );

	self.a.array = [];
	self.a.array["stand_2_crawl"] = array( %dying_stand_2_crawl_v1, %dying_stand_2_crawl_v2, %dying_stand_2_crawl_v3 );
	self.a.array["crouch_2_crawl"] = array( %dying_crouch_2_crawl );
	
	self.a.array["crawl"] = %dying_crawl;

	self.a.array["death"] = array( %dying_crawl_death_v1, %dying_crawl_death_v2 );

	self.a.array["prone_2_back"] = array( %dying_crawl_2_back );
	self.a.array["stand_2_back"] = array( %dying_stand_2_back_v1, %dying_stand_2_back_v2, %dying_stand_2_back_v3 );
	self.a.array["crouch_2_back"] = array( %dying_crouch_2_back );
	
	self.a.array["back_idle"] = %dying_back_idle;
	self.a.array["back_crawl"] = %dying_crawl_back;

	self.a.array["back_death"] = array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );

	self.health = 1;

	self notify ("pain_death"); // pain that ends in death
	//notify ac130 missions that a guy is crawling so context sensative dialog can be played
	level notify ( "ai_crawling", self );

	if ( !self dyingCrawl() )
		return;

	assert( self.a.pose == "stand" || self.a.pose == "crouch" || self.a.pose == "prone" );
	transAnim = self.a.pose + "_2_back";

	self setFlaggedAnimKnob( "transition", animArrayPickRandom( transAnim ), 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracks( "transition" );
	assert( self.a.pose == "back" );

	// TODO: better breakout logic here
	while ( keepCrawling() )
	{	
		// TODO: add shooting
		
		delta = getMoveDelta( animArray( "back_crawl" ), 0, 1 );
		endPos = self localToWorldCoords( delta );

		if ( !self mayMoveToPoint( endPos ) && self.a.numCrawls )
			crawlAnim = animArray( "back_idle" );
		else
			crawlAnim = animArray( "back_crawl" );
			
		self setFlaggedAnimKnobAllRestart( "crawling", crawlAnim, %body, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracks( "crawling" );
	}

	self.a.nodeath = true;
	self setFlaggedAnimKnobAllRestart( "dying", animArrayPickRandom( "back_death" ), %body, 1, .1, 1 );
	self animscripts\shared::DoNoteTracks( "dying" );
	self doDamage( self.health + 5, (0,0,0) );
}


dyingCrawl()
{
	assert( self.a.pose == "stand" || self.a.pose == "crouch" );
	
	self setAnimKnob( %dying, 1, 0.1, 1 );

	if ( randomFloat( 1 ) > 0.5 )
		return true;
		
	self setFlaggedAnimKnob( "falling", animArrayPickRandom( self.a.pose + "_2_crawl" ), 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracks( "falling" );
	assert( self.a.pose == "prone" );

	while ( keepCrawling() )
	{
		delta = getMoveDelta( animArray( "crawl" ), 0, 1 );
		endPos = self localToWorldCoords( delta );

		if ( !self mayMoveToPoint( endPos ) )
			return true;
			
		self setFlaggedAnimKnobAllRestart( "crawling", animArray( "crawl" ), %body, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracks( "crawling" );
	}

	// TODO: check if target is in cone to shoot

	if ( randomFloat( 1 ) > 0.5 )
		return true;

	self.a.nodeath = true;
	self setFlaggedAnimKnobAllRestart( "dying", animArrayPickRandom( "death" ), %body, 1, .1, 1 );
	self animscripts\shared::DoNoteTracks( "dying" );
	self doDamage( self.health + 5, (0,0,0) );
	
	return false;
}


keepCrawling()
{
	// TODO: player distance checks, etc...
	
	if ( !isDefined( self.a.numCrawls ) )
		self.a.numCrawls = randomInt( 4 + 1 );
		
	if ( !self.a.numCrawls )
	{
		self.a.numCrawls = undefined;
		return false;
	}
		
	self.a.numCrawls--;
	
	return true;
}
