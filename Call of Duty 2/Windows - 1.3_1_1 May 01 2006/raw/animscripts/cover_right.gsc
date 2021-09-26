#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#using_animtree ("generic_human");

// (Note that animations called left are used with right corner nodes, and vice versa.)

main()
{
	if (weaponAnims() == "panzerfaust" || weaponAnims() == "pistol")	
	{
		animscripts\combat::main();
		return;
	}
	
    self trackScriptState( "Cover Right Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_right");

    cornerType = newCorner();
	if (cornerType == "newCorner")
		animscripts\cover_right_axis::main();
	else
	if (cornerType == "noWall")
		animscripts\cover_right_axis::noWall();

	if ( (!self isStanceAllowed("crouch")) && (!self isStanceAllowed("stand")) )
	{
		println("Cover_right: Can't stand or crouch at corner!");
		println (" Entity: " + (self getEntityNumber()) );
		println (" Origin: "+self.origin);
	}

	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");
	}

	animscripts\combat_say::specific_combat("flankleft");

	// 10 second idle select debounce
    if ( GetTime () - self . coverIdleSelectTime > 10000 )
    {    
        if (randomint(100) < 50)
            self.anim_idleset = "a";
        else
            self.anim_idleset = "b";
        self . coverIdleSelectTime = GetTime ();
    }

    self thread State_CornerRight ( "from main" );
    return;
}

State_CornerRight ( changeReason )
{
	self trackScriptState( "CoverRight", changeReason );
	self endon("killanimscript");

	// Make sure we're facing the opposite direction from the node.
	cornerAngle = animscripts\utility::GetNodeDirection();
	nodeOrigin = animscripts\utility::GetNodeOrigin();

	canStand        = self isStanceAllowed("stand");
	canCrouch       = self isStanceAllowed("crouch");
	if (self animscripts\utility::weaponAnims()=="panzerfaust")
		canStand = 0;

	for (;;)
	{
		canStand        = self isStanceAllowed("stand");
		canCrouch       = self isStanceAllowed("crouch");
		if (self animscripts\utility::weaponAnims()=="panzerfaust")
			canStand = 0;
		keepPose = randomint ( 100 ) < 90;
		if (	( self.anim_pose=="stand" && keepPose && canStand ) || 
				( self.anim_pose=="crouch" && !keepPose && canStand ) || 
				(!canCrouch) )
		{
			SubState_StandingCorner("canStand && rand passed", cornerAngle, nodeOrigin);
		}
		else
		{
 			SubState_CrouchingCorner("canCrouch && rand passed", cornerAngle, nodeOrigin);
		}
		self animscripts\battleChatter::playBattleChatter();
	}
}


Anims_StandingPistol()
{
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -30;
	animarray["angle_aim"]["middle"]		= 15;
	animarray["angle_aim"]["right"]			= 60;
	animArray["anim_blend"]["left"]			= %pistol_leftstand_30left;
	animArray["anim_blend"]["middle"]		= %pistol_leftstand_15right;
	animArray["anim_blend"]["right"]		= %pistol_leftstand_60right;
	animarray["anim_alert2aim"]["left"]		= %pistol_leftstand_hide2aim_30left;
	animarray["anim_alert2aim"]["middle"]	= %pistol_leftstand_hide2aim_15right;
	animarray["anim_alert2aim"]["right"]	= %pistol_leftstand_hide2aim_60right;
	animarray["anim_aim"]["left"]			= %pistol_leftstand_aimloop_30left;
	animarray["anim_aim"]["middle"]			= %pistol_leftstand_aimloop_15right;
	animarray["anim_aim"]["right"]			= %pistol_leftstand_aimloop_60right;
	animarray["anim_semiautofire"]["left"]	= %pistol_leftstand_shoot_30left;
	animarray["anim_semiautofire"]["middle"]= %pistol_leftstand_shoot_15right;
	animarray["anim_semiautofire"]["right"]	= %pistol_leftstand_shoot_60right;
	animarray["anim_boltfire"]["left"]		= %pistol_leftstand_shoot_30left;
	animarray["anim_boltfire"]["middle"]	= %pistol_leftstand_shoot_15right;
	animarray["anim_boltfire"]["right"]		= %pistol_leftstand_shoot_60right;
	animarray["anim_aim2alert"]["left"]		= %pistol_leftstand_aim2hide_30left;    
	animarray["anim_aim2alert"]["middle"]	= %pistol_leftstand_aim2hide_15right;    
	animarray["anim_aim2alert"]["right"]	= %pistol_leftstand_aim2hide_60right;    
	animarray["anim_alert"]					= %pistol_leftstand_hide_idle;	// TODO Can also use %pistol_leftstand_hide_twitch here
	//animarray["anim_look"] - does not exist for Pistol.  Nor does rambo, autofire or corner reload.
	return animarray;
}
Anims_StandingRifleA()
{
	animArray["run2alert"]					= %corner_run2alert_left;
	animarray["hideYawOffset"]				= 180;
	animarray["angle_aim"]["left"]			= -30;
	animarray["angle_aim"]["middle"]		= 15;
	animarray["angle_aim"]["right"]			= 60;
	animArray["anim_blend"]["left"]			= %corner_stand_left_30left;
	animArray["anim_blend"]["middle"]		= %corner_stand_left_15right;
	animArray["anim_blend"]["right"]		= %corner_stand_left_60right;
	animarray["anim_alert2aim"]["left"]		= %corner_stand_alert2aim_left_30left;
	animarray["anim_alert2aim"]["middle"]	= %corner_stand_alert2aim_left_15right;
	animarray["anim_alert2aim"]["right"]	= %corner_stand_alert2aim_left_60right;
	animarray["anim_aim"]["left"]			= %corner_stand_aim_left_30left;
	animarray["anim_aim"]["middle"]			= %corner_stand_aim_left_15right;
	animarray["anim_aim"]["right"]			= %corner_stand_aim_left_60right;
	animarray["anim_autofire"]["left"]		= %corner_stand_autofire_left_30left;
	animarray["anim_autofire"]["middle"]	= %corner_stand_autofire_left_15right;
	animarray["anim_autofire"]["right"]		= %corner_stand_autofire_left_60right;
	animarray["anim_semiautofire"]["left"]	= %corner_stand_semiautofire_left_30left;
	animarray["anim_semiautofire"]["middle"]= %corner_stand_semiautofire_left_15right;
	animarray["anim_semiautofire"]["right"]	= %corner_stand_semiautofire_left_60right;
	animarray["anim_boltfire"]["left"]		= %corner_stand_semiautofire_left_30left;
	animarray["anim_boltfire"]["middle"]	= %corner_stand_semiautofire_left_15right;
	animarray["anim_boltfire"]["right"]		= %corner_stand_semiautofire_left_60right;
	animarray["anim_aim2alert"]["left"]		= %corner_stand_aim2alert_left_30left;    
	animarray["anim_aim2alert"]["middle"]	= %corner_stand_aim2alert_left_15right;    
	animarray["anim_aim2alert"]["right"]	= %corner_stand_aim2alert_left_60right;    
	animarray["anim_alert"]					= %cornerstandpose_left;
	animarray["anim_alert2rambo"]			= %corner2rambo_left;
	animarray["anim_rambo2alert"]			= %rambo2corner_left;
	animarray["anim_look"]					= %cornerstandlook_left;
	animarray["anim_reload"]				= %reload_cornera_stand_left_rifle;
	animarray["offset_grenade"]				= (-25,41,36);
	animarray["anim_grenade"]				= %corner_stand_grenade_throw_left;
	animarray["gunhand_grenade"]			= "left";
	return animarray;
}
Anims_StandingRifleB()
{
	animArray["run2alert"]					= %cornerb_run2alert_left;
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -30;
	animarray["angle_aim"]["middle"]		= 15;
	animarray["angle_aim"]["right"]			= 60;
	animArray["anim_blend"]["left"]			= %cornerb_stand_left_30left;
	animArray["anim_blend"]["middle"]		= %cornerb_stand_left_15right;
	animArray["anim_blend"]["right"]		= %cornerb_stand_left_60right;
	animarray["anim_alert2aim"]["left"]		= %cornerb_stand_alert2aim_left_30left;
	animarray["anim_alert2aim"]["middle"]	= %cornerb_stand_alert2aim_left_15right;
	animarray["anim_alert2aim"]["right"]	= %cornerb_stand_alert2aim_left_60right;
	animarray["anim_aim"]["left"]			= %cornerb_stand_aim_left_30left;
	animarray["anim_aim"]["middle"]			= %cornerb_stand_aim_left_15right;
	animarray["anim_aim"]["right"]			= %cornerb_stand_aim_left_60right;
	animarray["anim_autofire"]["left"]		= %cornerb_stand_autofire_left_30left;
	animarray["anim_autofire"]["middle"]	= %cornerb_stand_autofire_left_15right;
	animarray["anim_autofire"]["right"]		= %cornerb_stand_autofire_left_60right;
	animarray["anim_semiautofire"]["left"]	= %cornerb_stand_semiautofire_left_30left;
	animarray["anim_semiautofire"]["middle"]= %cornerb_stand_semiautofire_left_15right;
	animarray["anim_semiautofire"]["right"]	= %cornerb_stand_semiautofire_left_60right;
	animarray["anim_boltfire"]["left"]		= %cornerb_stand_semiautofire_left_30left;
	animarray["anim_boltfire"]["middle"]	= %cornerb_stand_semiautofire_left_15right;
	animarray["anim_boltfire"]["right"]		= %cornerb_stand_semiautofire_left_60right;
	animarray["anim_aim2alert"]["left"]		= %cornerb_stand_aim2alert_left_30left;    
	animarray["anim_aim2alert"]["middle"]	= %cornerb_stand_aim2alert_left_15right;    
	animarray["anim_aim2alert"]["right"]	= %cornerb_stand_aim2alert_left_60right;    
	animarray["anim_alert"]					= %cornerb_stand_alert_idle_left;
	animarray["anim_look"]					= %cornerb_stand_alert_look_left;
	// (There are no rambo animations for "b" idleset.)
	animarray["anim_reload"]				= %reload_cornerb_stand_left_rifle;
	animarray["offset_grenade"]				= (25,-41,36);
	animarray["anim_grenade"]				= %cornerb_stand_grenade_throw_left;
	animarray["gunhand_grenade"]			= "left";
	return animarray;
}

SubState_StandingCorner(changeReason, cornerAngle, nodeOrigin)
{
	entryState = self . scriptState;
	self trackScriptState( "StandingCornerRight", changeReason );    

	// (Keep gun in right hand - in the left corner we move it to the right hand here.)

	GoToCover(cornerAngle);

	// Make sure we're standing
	self.anim_movement = "stop";
	if ( (self.anim_pose == "crouch") || (self.anim_pose == "prone") )	// TODO: Prone should have its own animation.
	{
		self ExitProneWrapper(0.5);
		if (self.anim_idleset == "a")
		{
			animscripts\SetPoseMovement::PlayTransitionAnimation(%cornercrouch2stand_left, "stand", "stop", 0);
		}
		else
		{
			animscripts\SetPoseMovement::PlayTransitionAnimation(%cornerb_crouch2stand_left, "stand", "stop", 0);
		}
	}
	// Now we're standing, get the set of animations to use
	animarray = ChooseAnimArray();
	// Now do the behavior
	animscripts\corner::CornerBehavior( nodeOrigin, cornerAngle, animarray );

	self trackScriptState( entryState, "Standing done" );
}

/*
Anims_CrouchingPanzerfaust()
{
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -30;
	animarray["angle_aim"]["middle"]		= 15;
	animarray["angle_aim"]["right"]			= 60;
	animArray["anim_blend"]["left"]			= %panzerfaust_cornercrouch_left_30left;
	animArray["anim_blend"]["middle"]		= %panzerfaust_cornercrouch_left_15right;
	animArray["anim_blend"]["right"]		= %panzerfaust_cornercrouch_left_60right;
	animarray["anim_alert2aim"]["left"]		= %panzerfaust_cornercrouch_alert2aim_left_30left;
	animarray["anim_alert2aim"]["middle"]	= %panzerfaust_cornercrouch_alert2aim_left_15right;
	animarray["anim_alert2aim"]["right"]	= %panzerfaust_cornercrouch_alert2aim_left_60right;
	animarray["anim_aim"]["left"]			= %panzerfaust_cornercrouchaim_left_30left;
	animarray["anim_aim"]["middle"]			= %panzerfaust_cornercrouchaim_left_15right;
	animarray["anim_aim"]["right"]			= %panzerfaust_cornercrouchaim_left_60right;
	animarray["anim_semiautofire"]["left"]	= %panzerfaust_cornercrouchaim_left_30left;
	animarray["anim_semiautofire"]["middle"]= %panzerfaust_cornercrouchaim_left_15right;
	animarray["anim_semiautofire"]["right"]	= %panzerfaust_cornercrouchaim_left_60right;
	animarray["anim_boltfire"]["left"]		= %panzerfaust_cornercrouchaim_left_30left;
	animarray["anim_boltfire"]["middle"]	= %panzerfaust_cornercrouchaim_left_15right;
	animarray["anim_boltfire"]["right"]		= %panzerfaust_cornercrouchaim_left_60right;
	animarray["anim_aim2alert"]["left"]		= %panzerfaust_cornercrouchaim2alert_left_30left;    
	animarray["anim_aim2alert"]["middle"]	= %panzerfaust_cornercrouchaim2alert_left_15right;    
	animarray["anim_aim2alert"]["right"]	= %panzerfaust_cornercrouchaim2alert_left_60right;    
	animarray["anim_alert"]					= %panzerfaust_cornercrouchaimdown_left;		// FIXME!  Is this the right animation?
	//animarray["anim_look"] - does not exist for Panzerfaust.  Nor does rambo, autofire or reload.
	return animarray;
}
*/

Anims_CrouchingPistol()
{
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -30;
	animarray["angle_aim"]["middle"]		= 15;
	animarray["angle_aim"]["right"]			= 60;
	animArray["anim_blend"]["left"]			= %pistol_leftcrouch_30left;
	animArray["anim_blend"]["middle"]		= %pistol_leftcrouch_15right;
	animArray["anim_blend"]["right"]		= %pistol_leftcrouch_60right;
	animarray["anim_alert2aim"]["left"]		= %pistol_leftcrouch_hide2aim_30left;
	animarray["anim_alert2aim"]["middle"]	= %pistol_leftcrouch_hide2aim_15right;
	animarray["anim_alert2aim"]["right"]	= %pistol_leftcrouch_hide2aim_60right;
	animarray["anim_aim"]["left"]			= %pistol_leftcrouch_aimloop_30left;
	animarray["anim_aim"]["middle"]			= %pistol_leftcrouch_aimloop_15right;
	animarray["anim_aim"]["right"]			= %pistol_leftcrouch_aimloop_60right;
	animarray["anim_semiautofire"]["left"]	= %pistol_leftcrouch_shoot_30left;
	animarray["anim_semiautofire"]["middle"]= %pistol_leftcrouch_shoot_15right;
	animarray["anim_semiautofire"]["right"]	= %pistol_leftcrouch_shoot_60right;
	animarray["anim_boltfire"]["left"]		= %pistol_leftcrouch_shoot_30left;
	animarray["anim_boltfire"]["middle"]	= %pistol_leftcrouch_shoot_15right;
	animarray["anim_boltfire"]["right"]		= %pistol_leftcrouch_shoot_60right;
	animarray["anim_aim2alert"]["left"]		= %pistol_leftcrouch_aim2hide_30left;    
	animarray["anim_aim2alert"]["middle"]	= %pistol_leftcrouch_aim2hide_15right;    
	animarray["anim_aim2alert"]["right"]	= %pistol_leftcrouch_aim2hide_60right;    
	animarray["anim_alert"]					= %pistol_leftcrouch_hide_idle;	// TODO Can also use %pistol_leftcrouch_hide_twitch here
	//animarray["anim_look"] - does not exist for Pistol.  Nor does rambo, autofire or corner reload.
	return animarray;
}
Anims_CrouchingRifleA()
{
	animarray["hideYawOffset"]				= 180;
	animarray["angle_aim"]["left"]			= -30;
	animarray["angle_aim"]["middle"]		= 15;
	animarray["angle_aim"]["right"]			= 60;
	animArray["anim_blend"]["left"]			= %corner_crouch_left_30left;
	animArray["anim_blend"]["middle"]		= %corner_crouch_left_15right;
	animArray["anim_blend"]["right"]		= %corner_crouch_left_60right;
	animarray["anim_alert2aim"]["left"]		= %corner_crouch_alert2aim_left_30left;
	animarray["anim_alert2aim"]["middle"]	= %corner_crouch_alert2aim_left_15right;
	animarray["anim_alert2aim"]["right"]	= %corner_crouch_alert2aim_left_60right;
	animarray["anim_aim"]["left"]			= %corner_crouch_aim_left_30left;
	animarray["anim_aim"]["middle"]			= %corner_crouch_aim_left_15right;
	animarray["anim_aim"]["right"]			= %corner_crouch_aim_left_60right;
	animarray["anim_autofire"]["left"]		= %corner_crouch_autofire_left_30left;
	animarray["anim_autofire"]["middle"]	= %corner_crouch_autofire_left_15right;
	animarray["anim_autofire"]["right"]		= %corner_crouch_autofire_left_60right;
	animarray["anim_semiautofire"]["left"]	= %corner_crouch_semiautofire_left_30left;
	animarray["anim_semiautofire"]["middle"]= %corner_crouch_semiautofire_left_15right;
	animarray["anim_semiautofire"]["right"]	= %corner_crouch_semiautofire_left_60right;
	animarray["anim_boltfire"]["left"]		= %corner_crouch_semiautofire_left_30left;
	animarray["anim_boltfire"]["middle"]	= %corner_crouch_semiautofire_left_15right;
	animarray["anim_boltfire"]["right"]		= %corner_crouch_semiautofire_left_60right;
	animarray["anim_aim2alert"]["left"]		= %corner_crouch_aim2alert_left_30left;    
	animarray["anim_aim2alert"]["middle"]	= %corner_crouch_aim2alert_left_15right;    
	animarray["anim_aim2alert"]["right"]	= %corner_crouch_aim2alert_left_60right;    
	animarray["anim_alert"]					= %cornercrouchpose_left;
	//animarray["anim_look"] - does not exist for crouching corner set a
	animarray["anim_reload"]				= %reload_cornera_crouch_left_rifle;
	animarray["offset_grenade"]				= (-25,41,36);
	animarray["anim_grenade"]				= %corner_crouch_grenade_left;
	animarray["gunhand_grenade"]			= "left";
	return animarray;
}
Anims_CrouchingRifleB()
{
	animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -30;
	animarray["angle_aim"]["middle"]		= 15;
	animarray["angle_aim"]["right"]			= 60;
	animArray["anim_blend"]["left"]			= %cornerb_crouch_left_30left;
	animArray["anim_blend"]["middle"]		= %cornerb_crouch_left_15right;
	animArray["anim_blend"]["right"]		= %cornerb_crouch_left_60right;
	animarray["anim_alert2aim"]["left"]		= %cornerb_crouch_alert2aim_left_30left;
	animarray["anim_alert2aim"]["middle"]	= %cornerb_crouch_alert2aim_left_15right;
	animarray["anim_alert2aim"]["right"]	= %cornerb_crouch_alert2aim_left_60right;
	animarray["anim_aim"]["left"]			= %cornerb_crouch_aim_left_30left;
	animarray["anim_aim"]["middle"]			= %cornerb_crouch_aim_left_15right;
	animarray["anim_aim"]["right"]			= %cornerb_crouch_aim_left_60right;
	animarray["anim_autofire"]["left"]		= %cornerb_crouch_autofire_left_30left;
	animarray["anim_autofire"]["middle"]	= %cornerb_crouch_autofire_left_15right;
	animarray["anim_autofire"]["right"]		= %cornerb_crouch_autofire_left_60right;
	animarray["anim_semiautofire"]["left"]	= %cornerb_crouch_semiautofire_left_30left;
	animarray["anim_semiautofire"]["middle"]= %cornerb_crouch_semiautofire_left_15right;
	animarray["anim_semiautofire"]["right"]	= %cornerb_crouch_semiautofire_left_60right;
	animarray["anim_boltfire"]["left"]		= %cornerb_crouch_semiautofire_left_30left;
	animarray["anim_boltfire"]["middle"]	= %cornerb_crouch_semiautofire_left_15right;
	animarray["anim_boltfire"]["right"]		= %cornerb_crouch_semiautofire_left_60right;
	animarray["anim_aim2alert"]["left"]		= %cornerb_crouch_aim2alert_left_30left;    
	animarray["anim_aim2alert"]["middle"]	= %cornerb_crouch_aim2alert_left_15right;    
	animarray["anim_aim2alert"]["right"]	= %cornerb_crouch_aim2alert_left_60right;    
	animarray["anim_alert"]					= %cornerb_crouch_alert_idle_left;
	animarray["anim_look"]					= %cornerb_crouch_alert_look_left;
	animarray["anim_reload"]				= %reload_cornerb_crouch_left_rifle;
	animarray["offset_grenade"]				= (25,-41,36);
	animarray["anim_grenade"]				= %cornerb_crouch_grenade_throw_left;
	animarray["gunhand_grenade"]			= "left";
	return animarray;
}

SubState_CrouchingCorner(changeReason, cornerAngle, nodeOrigin)
{
	entryState = self.scriptState;
	self trackScriptState( "CrouchingCornerRight", changeReason );

	// Keep gun in right hand.

	GoToCover(cornerAngle);

	// Make sure we're crouching
	self.anim_movement = "stop";
	weaponAnims = getAIWeapon(self.weapon)["anims"];
	if (weaponAnims=="panzerfaust")
	{
		self [[anim.SetPoseMovement]]("crouch","stop");
	}
	else if ( (self.anim_pose == "stand") || (self.anim_pose == "prone") )	// TODO: Prone should have its own animation.
	{
		self ExitProneWrapper(0.5);
		if (self.anim_idleset == "a")
			animscripts\SetPoseMovement::PlayBlendTransition(%cornercrouchpose_left, 0.5, "crouch", "stop", 0);
		else
			animscripts\SetPoseMovement::PlayTransitionAnimation(%cornerb_stand2crouch_left, "crouch", "stop", 0);
	}
	// Now we're crouching, get the set of animations to use
	animarray = ChooseAnimArray();
	// Now do the behavior
	animscripts\corner::CornerBehavior( nodeOrigin, cornerAngle, animarray );

	self trackScriptState( entryState, "CrouchingCorner returns" );
}


ChooseAnimArray()
{
	assertEX( self.anim_pose == "stand" || self.anim_pose == "crouch" );
	weaponAnims = getAIWeapon(self.weapon)["anims"];
	/*
	if (weaponAnims == "panzerfaust")
	{
		animarray = Anims_CrouchingPanzerfaust();
	}
	else 
	*/
	if (weaponAnims == "pistol")
	{
		if (self.anim_pose == "stand")
		{
			animarray = Anims_StandingPistol();
		}
		else
		{
			animarray = Anims_CrouchingPistol();
		}
	}
	else if (self.anim_idleSet=="a")
	{
		if (self.anim_pose == "stand")
		{
			animarray = Anims_StandingRifleA();
		}
		else
		{
			animarray = Anims_CrouchingRifleA();
		}
	}
	else //if (self.anim_idleSet=="b")
	{
		if (self.anim_pose == "stand")
		{
			animarray = Anims_StandingRifleB();
		}
		else
		{
			animarray = Anims_CrouchingRifleB();
		}
	}
	return animarray;
}

GoToCover(cornerAngle)
{
	if ( self.anim_pose != "stand" && self.anim_pose != "crouch" ) // In case we were in Prone.
	{
		self ExitProneWrapper(0.5);
		self.anim_pose = "crouch";
	}
	if (self.anim_special == "cover_right")
	{
		// We're already in position.  Just check for error conditions before continuing.
		if ( self.anim_idleSet!="a" && self.anim_idleSet!="b" )
		{
			println ("cover_left::GoToCover : Invalid self.anim_idleSet "+self.anim_idleSet+" for cover_left character ("+self.anim_pose+", "+self.anim_movement+")");
			self.anim_idleSet="a";
		}
		animarray = ChooseAnimArray();
		playTransitionAnim = false;
	}
	else
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]+15);
		if ( angleDifference >= 180 )
		{
			self.anim_idleset = "a";
		}
		else
		{
			self.anim_idleset = "b";
		}
		animarray = ChooseAnimArray();
		playTransitionAnim = true;
	}

	self OrientMode( "face angle", cornerAngle+animarray["hideYawOffset"] );
	if ( playTransitionAnim && isDefined(animarray["run2alert"]) )
	{
		self setFlaggedAnimKnobAllRestart("run2alert",animarray["run2alert"], %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("run2alert");
	}
	self.anim_special = "stop";
	self.anim_special = "cover_right";
}
