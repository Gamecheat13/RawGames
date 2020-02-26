#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Cover Stand Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_stand");

	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");
	}

	self [[anim.SetPoseMovement]]("stand","stop");

    self thread State_CoverStand ("code");
    return;
}					

State_CoverStand ( changeReason )
{
	self endon("killanimscript");
	self trackScriptState( "CoverStand", changeReason );
    
	nodeOrigin = animscripts\utility::GetNodeOrigin();
	nodeForward = animscripts\utility::GetNodeForward();
	for (;;)
	{
		[[anim.assert]](self.anim_movement=="stop", "cover_stand: about to call aim but not stopped! "+self.anim_movement+" "+self.anim_pose);
		self animscripts\aim::aim(2); //z:   will get overwritten to be .25 anyways.
		[[anim.assert]](self.anim_alertness == "aiming", "cover_stand::cover_stand: About to call ShootVolley but not aiming");
		//		animscripts\combat::ShootVolley(0);
		while ( !(self isSuppressed()) && (self.bulletsInClip>0) && (!self.anim_needsToRechamber ) )
		{
			[[anim.println]]("Cover stand: main attack loop - begin.");
			self OrientMode ("face enemy"); 
			if (self.team=="axis")	// Enemies should give the player a chance to react - this could be tweaked for difficulty.
			{
				self animscripts\aim::aim(0.5);
			}
			else
			{
				self animscripts\aim::aim(0.1);
			}
			self setanimknoball(%stand_aim, %body, 1, 0.2, 1);
			standAimArray["left"] = %stand_aim;		// Since we don't have left and right aiming animations, 
			standAimArray["middle"] = %stand_aim;	// and we're not managing their weights anyhow.
			standAimArray["right"] = %stand_aim;
			animscripts\corner::WaitForAmbush(standAimArray, 3, "Not suppressed and ready to fire");            
			if ( animscripts\utility::sightCheckNode() )
			{
				[[anim.println]]("Cover stand: main attack loop - firing.");
				[[anim.assert]](self.anim_alertness == "aiming", "cover_stand::cover_stand: About to call ShootVolley but not aiming");
				firedAShot = animscripts\combat::ShootVolley(0);
     			anim . CoverStandShots++;
				if (!firedAShot)
					animscripts\aim::aim(0.1);	// Guards against infinite loops caused by enemies within melee range, which should never happen...
				// Sometimes do two bursts in a row.
				if ( anim . CoverStandShots > 10 )
				{    
					anim . CoverStandShots = 0;
					animscripts\combat::ShootVolley(0);
				}
				self animscripts\combat::TryGrenade();
			}
			else if ( animscripts\weaponList::usingAutomaticWeapon() && randomint ( 100 ) < 70 && self canAttackEnemyNode() ) // suppression
			{
				[[anim.println]]("Cover stand: main attack loop - suppressing.");
				[[anim.assert]](self.anim_alertness == "aiming", "cover_stand::cover_stand: About to call ShootVolley but not aiming");
				while (  self.bulletsInClip > 0 )                    
				{    
					animscripts\combat_say::specific_combat("doingsuppression");
					self animscripts\aim::aim( 0.2 + randomfloat (0.7) );
					animscripts\combat::ShootVolley(0);                
					self animscripts\combat::TryGrenade();
				}                
			}
		}
		// Sometimes enemies don't duck between shots, so that the player has a better chance of being able 
		// to shoot someone.
		if ( self.team=="axis" && !(self isSuppressed()) && randomfloat(1)>0.5 )
		{
			[[anim.println]]("Cover stand: reloading, rechambering.");
			self animscripts\combat::TryGrenade();
			if (!(self isSuppressed()))
			{
				self animscripts\combat::Reload(0.2);
				self animscripts\combat::Rechamber();
			}
		}
		else
		{
			[[anim.println]]("Cover stand: suppressed.");
			SubState_Hide(nodeOrigin, nodeForward, "Bottom of CoverStand" );
		}
	}
}



// Duck down from the standing pose by playing the beginning of the stand-to-crouch animation and blending in 
// the crouch-to-crouchhide animation.
GoToCrouchHide()
{
	switch (self.anim_pose)
	{
	case "stand":
		self [[anim.SetPoseMovement]]("stand","stop");	// Generally we're already stopped so this does nothing.
		self animscripts\SetPoseMovement::PlayTransitionAnimation2(%stand2crouch_hide, "crouch", "stop", 0, 0);
		self.anim_idleSet = "b";
		self.anim_special = "cover_crouch";
		break;
	default:
		println("Unhandled pose "+self.anim_pose+" in cover_stand:hide");
		self.anim_pose = "crouch";
		// Fall through.
	case "prone":
		self [[anim.SetPoseMovement]]("crouch","stop");
		// Fall through.
	case "crouch":
		if (self.anim_special == "cover_crouch")
		{
			if (self.anim_idleSet == "a")
			{
				self.anim_special = "none";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWall2crouch, "crouch", "stop", 1, 1);
				self.anim_idleSet = "b";
				self.anim_special = "cover_crouch";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%crouch_aim2hideLowWallb, "crouch", "stop", 1, 1);
			}
			else if (self.anim_idleSet == "c")
			{
				self.anim_idleSet = "b";
				animscripts\SetPoseMovement::PlayTransitionAnimation(%hideLowWallc2hideLowWallb, "crouch", "stop", 1, 1);
			}
			else if (self.anim_idleSet != "b")
			{
				println ("cover_crouch::idle : Invalid self.anim_idleSet "+self.anim_idleSet+" for cover_crouch character ("+self.anim_pose+", "+self.anim_movement+")");
				self.anim_idleSet = "b";
			}
			// Check my logic
			[[anim.assert]](self.anim_idleSet == "b", "Logic error in cover_stand::hide - idleSet == "+self.anim_idleSet);
		}
		else
		{
			self.anim_special = "cover_crouch";
			self.anim_idleSet = "b";
			animscripts\SetPoseMovement::PlayTransitionAnimation2(%crouch_aim2hideLowWallb, "crouch", "stop", 0, 1);	// TODO Set anim_special & idleSet here.
		}
		break;
	}
}


CrouchHideToStand()
{
	self OrientMode ("face enemy"); 
	self animscripts\SetPoseMovement::PlayTransitionAnimation(%crouchhide2stand, "stand", "stop", 1, 0);
	self.anim_special = "none";
}


SubState_Hide(pointToHide, forwardDir, changeReason)
{
	entryState = self . scriptState;
	self trackScriptState( "hide", changeReason );

	// Say random shit.
	animscripts\combat_say::generic_combat();

	self OrientMode( "face direction", forwardDir );
//	animscripts\cover_crouch::idle_start();
	GoToCrouchHide();

	// Make sure we're in the right place.
	self teleport (pointToHide);

	self animscripts\combat::TryGrenade();
	self animscripts\combat::Reload(0.2);
	self animscripts\combat::Rechamber();

	while (self isSuppressed())
	{
		animscripts\cover_crouch::idle();
		self animscripts\combat::TryGrenade();
	}

//	animscripts\cover_crouch::idleToAim();
//
//	//self.desiredAngle = animscripts\utility::GetYawToEnemy();
//	self OrientMode ("face enemy"); 
//	self [[anim.SetPoseMovement]]("stand","stop");	// TODO - find a way to do this that doesn't involve moving from the node.
	CrouchHideToStand();

	self trackScriptState( entryState , "hide returned" );
}
