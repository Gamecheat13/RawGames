// "Stop" makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 
 
#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Stop Main", "code" );
	self animscripts\utility::StartDebugString("StopStart");
	self endon("killanimscript");

	animscripts\utility::initialize("stop");

	// If I'm wounded, I act differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::rest("stop::main");
	}

	for(;;)
	{
		[[anim.locSpam]]("s1");
		myNode = animscripts\utility::GetNode();
		if (isDefined(myNode))
		{
			myNodeAngle = myNode.angles[1];
			myNodeType = myNode.type;
		}
		else
		{
			myNodeAngle = self.desiredAngle;
			myNodeType = "node was undefined";
		}
		//println ("Node type is "+myNodeType);
		
		[[anim.locSpam]]("s2");
		self animscripts\face::SetIdleFace(anim.alertface);

		// Find out if we should be standing, crouched or prone
		desiredPose = animscripts\utility::choosePose();

		[[anim.println]](self.anim_nodeDebugInfo);	// To help debug why guys are getting to corner nodes and not using corner animations.
		[[anim.println]]("MyNodeType: ",myNodeType, " angle: ", myNodeAngle, " my angle: ", self.angles[1], " difference: ", animscripts\utility::AngleClamp( myNodeAngle-self.angles[1]));
		if (myNodeType == "Cover Left")
		{
			[[anim.locSpam]]("s3cl");
			self animscripts\utility::AddToDebugString(" SA");
			if ( (!self isStanceAllowed("crouch")) && (!self isStanceAllowed("stand")) )
			{
				println("Stop script at Cover_left node: Can't stand or crouch at corner!");
				println (" Entity: " + (self getEntityNumber()) );
				println (" Origin: "+self.origin);
				desiredPose = "crouch";
			}
			if ( desiredPose == "stand" )
			{
				self CoverLeftStandStill(myNodeAngle, "At cover left node");
			}
			else
			{
				self CoverLeftCrouchStill(myNodeAngle, "At cover left node");
			}
		}
		else if (myNodeType == "Cover Right")
		{
			[[anim.locSpam]]("s3cr");
			self animscripts\utility::AddToDebugString(" SB");
			if ( (!self isStanceAllowed("crouch")) && (!self isStanceAllowed("stand")) )
			{
				println("Stop script at Cover_right node: Can't stand or crouch at corner!");
				println (" Entity: " + (self getEntityNumber()) );
				println (" Origin: "+self.origin);
				desiredPose = "crouch";
			}
			if ( desiredPose == "stand" )
			{
				self CoverRightStandStill(myNodeAngle, "At cover right node");
			}
			else
			{
				self CoverRightCrouchStill(myNodeAngle, "At cover right node");
			}
		}
		else if (myNodeType == "Cover Crouch")
		{
			[[anim.locSpam]]("s3cc");
			self animscripts\utility::AddToDebugString(" SC");
			self animscripts\cover_crouch::idle_start();
			for (;;)
			{
				self animscripts\cover_crouch::idle();
			}
		}
		// TODO any other cases here
		else
		{
			if ( (myNodeType == "Cover Stand") || (myNodeType == "Conceal Stand") )
			{
				// At cover_stand nodes, we don't want to crouch since it'll most likely make our gun go through the wall.
				desiredPose = animscripts\utility::choosePose("stand");
			}
			else if (myNodeType == "Conceal Crouch")
			{
				// We should crouch at concealment crouch nodes.
				desiredPose = animscripts\utility::choosePose("crouch");
			}
			else if ( (myNodeType == "Cover Prone") || (myNodeType == "Conceal Prone") )
			{
				// We should go prone at prone nodes.
				desiredPose = animscripts\utility::choosePose("prone");
			}
			self animscripts\utility::AddToDebugString(" SD");
			if ( desiredPose == "stand" )
			{
				[[anim.locSpam]]("s3s");
				self StandStill();
			}
			else if ( desiredPose == "crouch" )
			{
				[[anim.locSpam]]("s3c");
				self CrouchStill();
			}
			else if ( desiredPose == "prone" )
			{
				[[anim.locSpam]]("s3p");
				self ProneStill();
			}
			else
			{
				[[anim.assert]](0, "stop::main - unhandled desired pose "+desiredPose);
			}
		}
	}
}


StandStill()
{
//	for (;;)
//	{
		self animscripts\utility::AddToDebugString(" Sssa");
		if ( self animscripts\utility::IsInCombat() )
		{
			[[anim.println]]("Entering StandStill (combat)");
			self animscripts\utility::AddToDebugString(" Sssb");
			self [[anim.SetPoseMovement]]("stand","stop");
//			animscripts\aim::aim(0);
//			[[anim.assert]] ( (self.anim_movement == "stop")&&(self.anim_pose=="stand")&&(self.anim_alertness=="aiming"), "stop::StandStill: About to call aim, movement is "+self.anim_movement);
			animscripts\combat::reload(0.3);

			if (self animscripts\utility::weaponAnims() == "pistol")
			{
					self setFlaggedAnimKnobAllRestart("idleanim", %pistol_standaim_idle, %body, 1, .1, 1);
					self animscripts\shared::DoNoteTracks("idleanim");
			}
			else
			{
				rand = randomint(100);
				if (rand<25)
				{
					self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop1, %body, 1, .1, 1);
				}
				else if (rand<50)
				{
					self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop2, %body, 1, .1, 1);
				}
				else if (rand<75)
				{
					self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop3, %body, 1, .1, 1);
				}
				else
				{
					self setFlaggedAnimKnobAllRestart("idleanim", %stand_aim_straight_loop4, %body, 1, .1, 1);
				}
				self animscripts\shared::DoNoteTracks ("idleanim");
			}
		}
		else
		{
			self animscripts\utility::AddToDebugString(" Sssc");
			nowTime = gettime();

			if ( isDefined(self.standanim) )
			{
				[[anim.println]]("Entering StandStill (self.standanim is ",self.standanim,")");
				self setFlaggedAnimKnobAllRestart("idleanim", self.standanim, %body, 1, .1, 1);
				self animscripts\shared::DoNoteTracks("idleanim");
			}
			else if (self animscripts\utility::weaponAnims() == "pistol")
			{
				[[anim.println]]("Entering StandStill (pistol)");
				self setFlaggedAnimKnobAllRestart("idleanim", %pistol_standaim_idle, %body, 1, .1, 1);
				self animscripts\shared::DoNoteTracks("idleanim");
			}
			else if ( (GetTime() < self.anim_woundedTime) || (self.anim_woundedAmount > 0.5) )
			{
				StandStill_wounded();
			}
			else
			{
				if ( 
					(self.anim_pose != "stand") || (self.anim_movement != "stop") || (self.anim_alertness == "aiming") || 
					( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
					)
				{
					// Decide which idle animation to do
					if (randomint(100)<50)
						idleSet = "a";
					else
						idleSet = "b";
				}
				else
				{
					[[anim.assert]](self.anim_idleSet=="a" || self.anim_idleSet=="b", "stop::standStill: anim_idleSet isn't a or b, it's "+self.anim_idleSet);
					idleSet = self.anim_idleSet;
				}
				if (idleSet == "a")
					StandStill_a();
				else
					StandStill_b();
				self animscripts\utility::AddToDebugString(" Sssd");

				if ( nowTime == gettime() )
				{
					print ("stand alert animation finished instantly!!!!");
					wait 0.2;
				}
				[[anim.locSpam]]("s10");
			}
		}
//	}
}

StandStill_wounded()
{
	[[anim.println]]("Entering StandStill_wounded");
	self.anim_idleSet = "w";
	self [[anim.SetPoseMovement]]("stand","stop");
		[[anim.locSpam]]("sw1");

	animscripts\combat::reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	

	randNum = randomint (100);
	if (randNum<70)
	{
		[[anim.locSpam]]("sw2");
		self setFlaggedAnimKnobAllRestart("animdone", %wounded_woundedalert_idle, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		[[anim.locSpam]]("sw3");
		self setFlaggedAnimKnobAllRestart("animdone", %wounded_woundedalert_twitch, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
	[[anim.locSpam]]("sw4");
}

StandStill_a()
{
	[[anim.println]]("Entering StandStill_a");
	self animscripts\utility::AddToDebugString(" Sssaa");
	self.anim_idleSet = "a";
	self [[anim.SetPoseMovement]]("stand","stop");

	animscripts\combat::reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	
	
	self animscripts\utility::AddToDebugString(" Sssab");
	randNum = randomint (100);
	if (randNum<30)
	{
		[[anim.locSpam]]("s6a");
		self setFlaggedAnimKnobAllRestart("animdone", %stand_alert_1, %body, 1, .1, self.animplaybackrate);
	}
	else if (randNum<65)
	{
		[[anim.locSpam]]("s7a");
		self setFlaggedAnimKnobAllRestart("animdone", %stand_alert_2, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		[[anim.locSpam]]("s8a");
		self setFlaggedAnimKnobAllRestart("animdone", %stand_alert_3, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
	[[anim.locSpam]]("s9a");
	self animscripts\utility::AddToDebugString(" Sssac");
}

StandStill_b()
{
	[[anim.println]]("Entering StandStill_b");
	self animscripts\utility::AddToDebugString(" Sssba");
	self.anim_idleSet = "b";
	self [[anim.SetPoseMovement]]("stand","stop");

	animscripts\combat::reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	
	self animscripts\utility::AddToDebugString(" Sssbb");

	randNum = randomint (100);
	if (randNum<70)
	{
		[[anim.locSpam]]("s6b");
		self setFlaggedAnimKnobAllRestart("animdone", %stand_alertb_idle1, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		[[anim.locSpam]]("s7b");
		self setFlaggedAnimKnobAllRestart("animdone", %stand_alertb_twitch1, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
	self animscripts\utility::AddToDebugString(" Sssbc");
	[[anim.locSpam]]("s9b");
}

CrouchStill()
{
	self animscripts\utility::AddToDebugString(" Scsa");
//	for (;;)
//	{
		if (!self animscripts\utility::hasWeapon())
		{
			unarmed_crouch_idle();
		}
		else if (self animscripts\utility::weaponAnims() == "pistol")
		{
			[[anim.println]]("Entering CrouchStill (pistol)");
			self setFlaggedAnimKnobAllRestart("idleanim", %pistol_crouchaim_idle, %body, 1, .1, 1);
			self animscripts\shared::DoNoteTracks("idleanim");
		}
		else if ( self animscripts\utility::IsInCombat() )
		{
			[[anim.println]]("Entering CrouchStill (combat)");
			self animscripts\utility::AddToDebugString(" Scsb");
			self [[anim.SetPoseMovement]]("crouch","stop");
			animscripts\combat::reload(0.3);

			[[anim.assert]] (self.anim_movement == "stop", "stop::CrouchStill: About to call aim, movement is "+self.anim_movement);
			animscripts\aim::aim(1);
		}
		else
		{
			self animscripts\utility::AddToDebugString(" Scsc");
			if ( 
				(self.anim_pose != "crouch") || (self.anim_movement != "stop") || (self.anim_alertness == "aiming") || 
				( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
				)
			{
				// Decide which idle animation to do
				if (randomint(100)<50)
					idleSet = "a";
				else
					idleSet = "b";
			}
			else
			{
				[[anim.assert]]( self.anim_idleSet=="a" || self.anim_idleSet=="b", "stop::CrouchStill: anim_idleSet isn't a or b, it's "+self.anim_idleSet);
				idleSet = self.anim_idleSet;
			}
			if (idleSet == "a")
				CrouchStill_a();
			else
				CrouchStill_b();

			self animscripts\utility::AddToDebugString(" Scsd");

			[[anim.locSpam]]("s10");
		}
//	}
}

CrouchStill_a()
{
	[[anim.println]]("Entering CrouchStill_a");
	self animscripts\utility::AddToDebugString(" Scsaa");
	self.anim_idleSet = "a";
	self [[anim.SetPoseMovement]]("crouch","stop");

	animscripts\combat::reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	

	self animscripts\utility::AddToDebugString(" Scsb");
	randNum = randomint (100);
	if (randNum<70)
	{
		[[anim.locSpam]]("s6a");
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_A_idle, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		[[anim.locSpam]]("s7a");
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_A_twitch, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
	self animscripts\utility::AddToDebugString(" Scsc");
	[[anim.locSpam]]("s9a");
}

CrouchStill_b()
{
	[[anim.println]]("Entering CrouchStill_b");
	self animscripts\utility::AddToDebugString(" Scsba");
	self.anim_idleSet = "b";
	self [[anim.SetPoseMovement]]("crouch","stop");

	animscripts\combat::reload(0.5);

	// Lower your weapon.
	animscripts\aim::dontaim();	

	self animscripts\utility::AddToDebugString(" Scsbb");
	randNum = randomint (100);
	if (randNum<70)
	{
		[[anim.locSpam]]("s6b");
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_B_idle1, %body, 1, .1, self.animplaybackrate);
	}
	else
	{
		[[anim.locSpam]]("s7b");
		self setFlaggedAnimKnobAllRestart("animdone", %crouch_alert_B_twitch1, %body, 1, .1, self.animplaybackrate);
	}
	self animscripts\shared::DoNoteTracks ("animdone");
	self animscripts\utility::AddToDebugString(" Scsbc");
	[[anim.locSpam]]("s9b");
}

ProneStill()
{
	[[anim.println]]("Entering ProneStill");
	self animscripts\utility::AddToDebugString(" Spsa");
	[[anim.println]]("Entering ProneStill");

	self [[anim.SetPoseMovement]]("prone","stop");

	animscripts\combat::reload(0.25);
	self setAnimKnobAllRestart (%prone_aim_idle, %body, 1, 0.1, 1);

	for (;;)
	{
		myCurrentYaw = self.angles[1];
		angleDelta = animscripts\utility::AngleClamp(self.desiredangle - myCurrentYaw, "-180 to 180");
		if ( angleDelta > 5 )
		{
			self animscripts\utility::AddToDebugString(" Spsb");
			[[anim.println]]("ProneStill - turning right");
			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
			self thread UpdateProneThread();
			self animscripts\shared::DoNoteTracks("turn anim");
			self notify ("kill UpdateProneThread");
//			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
		}
		else if ( angleDelta < -5 )
		{
			self animscripts\utility::AddToDebugString(" Spsc");
			[[anim.println]]("ProneStill - turning left");
			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
			self thread UpdateProneThread();
			self animscripts\shared::DoNoteTracks("turn anim");
			self notify ("kill UpdateProneThread");
//			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
		}
		else 
		{
			self animscripts\utility::AddToDebugString(" Spsd");
			self setanimknob(%prone_aim_idle, 1, .1, 1);
//			if ( self.desiredangle - myCurrentYaw > 1 || self.desiredangle - myCurrentYaw < -1 )
//			{
				self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
//			}
			wait 1;
		}
	}
}

UpdateProneThread()
{
	self endon ("killanimscript");
	self endon ("death");
	self endon ("kill UpdateProneThread");

	for (;;)
	{
		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.05, 1);
		wait 0.1;
	}
}


CoverLeftStandStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverLeftStandStill", changeReason );

	if ( 
		(self.anim_pose != "stand") || (self.anim_movement != "stop") || (self.anim_special != "cover_left") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]-15);
		if ( angleDifference <= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (idleSet == "a")
		CoverLeftStandStill_a(cornerAngle);
	else
		CoverLeftStandStill_b(cornerAngle);

	self trackScriptState( entryState , "CoverLeftStandStill returned" );
}

CoverLeftStandStill_a(cornerAngle)
{
	[[anim.println]]("Entering CoverLeftStandStill_a");

	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverLeftStandStill_a - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%corner_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	animscripts\combat::reload(0.5, %reload_cornera_stand_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAllRestart("standanim",%cornerstandpose_right, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim_right_15left, %body, 1, .1, self.animplaybackrate);
			wait ( (float)2 + randomfloat(2) );
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerstandlook_right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
		}
}

CoverLeftStandStill_b(cornerAngle)
{
	[[anim.println]]("Entering CoverLeftStandStill_b");

	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverLeftStandStill_b - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	animscripts\combat::reload(0.5, %reload_cornerb_stand_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_stand_alert_idle_right, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim_right_15left, %body, 1, .1, self.animplaybackrate);
			wait ( (float)2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert_look_right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		self OrientMode( "face angle", cornerAngle+90 );
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
	}
}


CoverLeftCrouchStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverLeftCrouchStill", changeReason );
	self animscripts\utility::AddToDebugString(" Sclc");
	if ( 
		(self.anim_pose != "crouch") || (self.anim_movement != "stop") || (self.anim_special != "cover_left") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]-15);
		if ( angleDifference <= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (!self animscripts\utility::hasWeapon())
	{
		unarmed_crouch_idle();
	}
	else if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		if (idleSet == "a")
			CoverLeftCrouchStill_Pistol_a();
		else
			CoverLeftCrouchStill_Pistol_b();
	}
	else
	{
		if (idleSet == "a")
			CoverLeftCrouchStill_a(cornerAngle);
		else
			CoverLeftCrouchStill_b(cornerAngle);
	}
	self trackScriptState( entryState , "CoverLeftCrouchStill returned" );
}

CoverLeftCrouchStill_Pistol_a()
{
	[[anim.println]]("Entering CoverLeftCrouchStill_Pistol_a");
	// Just play the first frame of the transition.  TODO - use correct anim
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverA2crouchaim, %body, 1, .1, 0);
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverLeftCrouchStill_Pistol_b()
{
	[[anim.println]]("Entering CoverLeftCrouchStill_Pistol_b");
	// Just play the first frame of the transition.  TODO - use correct anim
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverB2crouchaim, %body, 1, .1, 0);
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverLeftCrouchStill_a(cornerAngle)
{
	[[anim.println]]("Entering CoverLeftCrouchStill_a");

	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverLeftCrouchStill_a - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	animscripts\combat::reload(0.5, %reload_cornera_crouch_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornercrouchpose_right, %body, 1, .1, 1);
		wait ( (float)2 + randomfloat(4) );

		self setFlaggedAnimKnobAllRestart("crouchanim",%corner_crouch_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("crouchanim");
		self setFlaggedAnimKnobAllRestart("crouchanim",%corner_crouch_aim_right_15left, %body, 1, .1, 1);
		wait ( (float)2 + randomfloat(1) );
		self setFlaggedAnimKnobAllRestart("crouchanim",%corner_crouch_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}

CoverLeftCrouchStill_b(cornerAngle)
{
	[[anim.println]]("Entering CoverLeftCrouchStill_b");
	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverLeftCrouchStill_b - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_run2alert_right, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_left";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "stand";
	[[anim.PutGunInHand]]("left");
	animscripts\combat::reload(0.5, %reload_cornerb_crouch_right_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_crouch_alert_idle_right, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_alert2aim_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim_right_15left, %body, 1, .1, 1);
			wait ( (float)2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim2alert_right_15left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_alert_twitch1_right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		self OrientMode( "face angle", cornerAngle+90 );
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_idle_right, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_alert_right, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_flinch_right, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}


CoverRightStandStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverRightStandStill", changeReason );

	if ( 
		(self.anim_pose != "stand") || (self.anim_movement != "stop") || (self.anim_special != "cover_right") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]-15);
		if ( angleDifference >= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (idleSet == "a")
		CoverRightStandStill_a(cornerAngle);
	else
		CoverRightStandStill_b(cornerAngle);

	self trackScriptState( entryState , "CoverRightStandStill returned" );
}

CoverRightStandStill_a(cornerAngle)
{
	[[anim.println]]("Entering CoverRightStandStill_a");

	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverRightStandStill_a - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%corner_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "stand";

	animscripts\combat::reload(0.5,  %reload_cornera_stand_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAllRestart("standanim",%cornerstandpose_left, %body, 1, .1, 1);
		wait ( (float)2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim_left_15right, %body, 1, .1, self.animplaybackrate);
			wait ( (float)2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%corner_stand_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerstandlook_left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerA_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
	}
}

CoverRightStandStill_b(cornerAngle)
{
	[[anim.println]]("Entering CoverRightStandStill_b");
	self.anim_idleSet = "b";
	self.anim_special = "cover_right";

	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverRightStandStill_b - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "stand";

	animscripts\combat::reload(0.5, %reload_cornerb_stand_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_stand_alert_idle_left, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(4) );

		rand = randomint(100);
		if (rand<50)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim_left_15right, %body, 1, .1, self.animplaybackrate);
			wait ( (float)2 + randomfloat(1) );
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%cornerb_stand_alert_look_left, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("standanim");
		}
	}
	else
	{
		self.anim_alertness = "casual";
		self OrientMode( "face angle", cornerAngle-90 );
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("standanim",%casualcornerB_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("standanim");
	}
}


CoverRightCrouchStill(cornerAngle, changeReason)
{
	entryState = self.scriptState;
	self trackScriptState( "CoverRightCrouchStill", changeReason );
	self animscripts\utility::AddToDebugString(" Scrc");
	if ( 
		(self.anim_pose != "crouch") || (self.anim_movement != "stop") || (self.anim_special != "cover_right") || 
		( (self.anim_idleSet != "a") && (self.anim_idleSet != "b") ) 
		)
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]-15);
		if ( angleDifference >= 180 )
			idleSet = "a";
		else
			idleSet = "b";
	}
	else
	{
		idleSet = self.anim_idleSet;
	}
	if (!self animscripts\utility::hasWeapon())
	{
		unarmed_crouch_idle();
	}
	else if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		if (idleSet == "a")
			CoverRightCrouchStill_Pistol_a();
		else
			CoverRightCrouchStill_Pistol_b();
	}
	else
	{
		if (idleSet == "a")
			CoverRightCrouchStill_a(cornerAngle);
		else
			CoverRightCrouchStill_b(cornerAngle);
	}
	self trackScriptState( entryState , "CoverRightCrouchStill returned" );
}

CoverRightCrouchStill_Pistol_a()
{
	[[anim.println]]("Entering CoverRightCrouchStill_Pistol_a");
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverA2crouchaim, %body, 1, .1, 0);	// TODO - use correct anim
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverRightCrouchStill_Pistol_b()
{
	[[anim.println]]("Entering CoverRightCrouchStill_Pistol_b");
	self setFlaggedAnimKnobAllRestart("idleanim", %pistol_lowwallcoverB2crouchaim, %body, 1, .1, 0);	// TODO - use correct anim
	//self animscripts\shared::DoNoteTracks("idleanim");
	wait (1);
}

CoverRightCrouchStill_a(cornerAngle)
{
	[[anim.println]]("Entering CoverRightCrouchStill_a");
	self OrientMode( "face angle", cornerAngle+180 );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverRightCrouchStill_a - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "a";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "crouch";

	animscripts\combat::reload(0.5, %reload_cornera_crouch_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornercrouchpose_left, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(3) );

		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_aim_left_15right, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(1) );
		self setFlaggedAnimKnobAllRestart("standanim",%corner_crouch_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchA_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}

CoverRightCrouchStill_b(cornerAngle)
{
	[[anim.println]]("Entering CoverRightCrouchStill_b");
	self OrientMode( "face angle", cornerAngle );
	if (self.anim_movement != "stop")	// This test could probably be something more appropriate, like 
										// angle, or anim_special.
	{
		[[anim.println]]("CoverRightCrouchStill_b - playing run2corner anim");
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_run2alert_left, %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		if ( !self animscripts\utility::IsInCombat() )
		{
			// This just makes him play one set of combat anims before going to casual, since 
			// run2alert matches the combat anims.
			self animscripts\shared::SetInCombat(0.5);
		}											
	}
	self.anim_idleSet = "b";
	self.anim_special = "cover_right";
	self.anim_movement = "stop";
	self ExitProne(0.5); // In case we were in Prone.
	self.anim_pose = "crouch";

	animscripts\combat::reload(0.5, %reload_cornerb_crouch_left_rifle);

	if ( self animscripts\utility::IsInCombat() )
	{
		self.anim_alertness = "alert";

		self setFlaggedAnimKnobAll("standanim",%cornerb_crouch_alert_idle_left, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(1) );

		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_alert2aim_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim_left_15right, %body, 1, .1, self.animplaybackrate);
		wait ( (float)2 + randomfloat(1) );
		self setFlaggedAnimKnobAllRestart("standanim",%cornerb_crouch_aim2alert_left_15right, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("standanim");
	}
	else
	{
		self.anim_alertness = "casual";
		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_idle_left, %body, 1, .1, self.animplaybackrate);
		}
		else if (rand<90)
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_alert_left, %body, 1, .1, self.animplaybackrate);
		}
		else
		{
			self setFlaggedAnimKnobAllRestart("crouchanim",%casualcornercrouchB_flinch_left, %body, 1, .1, self.animplaybackrate);
		}
		self animscripts\shared::DoNoteTracks ("crouchanim");
	}
}


unarmed_crouch_idle()
{
//	for (;;)
//	{
		self setFlaggedAnimKnobAll("crouchanim",%unarmed_crouch_idle1, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("crouchanim");

		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAll("crouchanim",%unarmed_crouch_twitch1, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("crouchanim");
		}
//	}
}

