#using_animtree ("generic_human");


//
//		 Damage Yaw
//
//           front
//        /----|----\
//       /    180    \
//      /\     |     /\
//     / -135  |  135  \
//     |     \ | /     |
// left|-90----+----90-|right
//     |     / | \     |
//     \  -45  |  45   /
//      \/     |     \/
//       \     0     / 
//        \----|----/
//           back

main()
{
    self trackScriptState( "Death Main", "code" );
	self endon("killanimscript");

	// Grab some info about the previous state before we wipe it all with Initialize()
	anim_special = self.anim_special;
	if( isDefined(self.isHoldingGrenade) && self.isHoldingGrenade )
		isHoldingGrenade = true;
	else
		isHoldingGrenade = false;
	
	animscripts\utility::initialize("death");

	rand = randomint(100);
	[[anim.println]]("death script, pose "+self.anim_pose+", movement "+self.anim_movement+", location: "+self.damageLocation+", rand: "+rand);

	// TEMP: For now, just drop the weapon as soon as they're dead.
	self animscripts\shared::DropAIWeapon();
	if (isHoldingGrenade)
		self DropGrenade();
	// Stop any lookats that are happening and make sure no new ones occur while death animation is playing.
	self notify ("never look at anything again");

	if (isDefined(self.deathanim))
	{
		[[anim.println]]("Playing special death as set by self.deathanim");
		self SetFlaggedAnimKnobAll("deathanim", self.deathanim, %root, 1, .05, 1);
		self animscripts\shared::DoNoteTracks("deathanim");
		if (isDefined(self.deathanimloop))
		{
			[[anim.println]]("Playing special dead/wounded loop animation as set by self.deathanimloop");
			self SetFlaggedAnimKnobAll("deathanim", self.deathanimloop, %root, 1, .05, 1);
			for (;;)
			{
				self animscripts\shared::DoNoteTracks("deathanim");
			}
		}
		return;
	}
	if (anim_special != "none")
	{
		if ( specialDeath(anim_special) )
			return;
	}

	self thread animscripts\pain::PlayHitAnimation();

	PlayDeathSound();
	deathFace = animscripts\face::ChooseAnimFromSet(anim.deathFace);
	self animscripts\face::SaySpecificDialogue(deathFace, undefined, 1.0);

	self setanimknob(%death, 1, .05, 1);

	if (isdefined(self.script_balcony) && self.script_balcony && self.anim_pose == "stand")
	{
		bDoBalcony = self testPrediction();
		if (bDoBalcony)
		{
			self animscripts\predict::playback();
			self animscripts\predict::end();

			self setflaggedanimknob("groundEntChanged", %balcony_fallloop_onback, 1, .05, 1); // "groundEntChanged" is also notified by the code when the ground ent changes

			while (self getGroundEntType() == "none")
			{
				self waittill("groundEntChanged", notetrack);
				if (isdefined(notetrack))
				{
					println("notetrack: ", notetrack); // TODO: test for setting impact animation
				}
			}

//			self setflaggedanimknob("animdone", %balcony_death_onfeet);
//			self setflaggedanimknob("animdone", %balcony_death_onfront);
			self setflaggedanimknob("animdone", %balcony_death_onback, 1, 0, 1);
			self animscripts\shared::DoNoteTracks("animdone");
			return;
		}
	}

    if ( isDefined ( self . alwaysPop ) && self . alwaysPop )
        thread popHelmet();    
    else if ( self.damageLocation == "head" )
    {
        if ( rand < 30 )
            thread popHelmet();
    }

	if ( (self.damageLocation == "none") && (self.damageTaken > 40) )
	{
		// "None" means explosion, so this is a decent explosion impact.  Fly through the air.
        // JBW - set animmode to nogravity to get Z delta, then turn gravity on so bbox plants to ground (otherwise it will float level with initial Z)
        // Delta bboxes cause problems with floating guys since the bbox can easily land on ledges - may be better to go through things with stationary bbox
		if (self.damageTaken > 215)	// TODO This should check if the explosion was underneath me
		{
            self animMode ("nogravity");
			self setflaggedanimknob("animdone", %death_explosion_up10, 1, .05, 1);
		}
		else if (self.damageTaken > 160)
		{
			if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
			{
				self animMode ("nogravity");
				self setflaggedanimknob("animdone", %death_explosion_back13, 1, .05, 1);
			}
			else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
			{
				self animMode ("nogravity");
				self setflaggedanimknob("animdone", %death_explosion_left11, 1, .05, 1);
			}
			else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
			{
				self animMode ("nogravity");
				self setflaggedanimknob("animdone", %death_explosion_forward13, 1, .05, 1);
			}
			else															// Left quadrant
			{
				[[anim.assert]]( (self.damageyaw > -135) && (self.damageyaw <= -45), "death::main: DamageYaw logic error (yaw is "+self.damageyaw);
				self animMode ("nogravity");
				self setflaggedanimknob("animdone", %death_explosion_right13, 1, .05, 1);
			}
		}
		else
		{
			if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
			{
				self setflaggedanimknob("animdone", %death_run_back, 1, .05, 1);
			}
			else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
			{
				self setflaggedanimknob("animdone", %death_run_left, 1, .05, 1);
			}
			else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
			{
				self setflaggedanimknob("animdone", %death_run_forward_crumple, 1, .05, 1);
			}
			else															// Left quadrant
			{
				self setflaggedanimknob("animdone", %death_run_right, 1, .05, 1);
			}
		}
	}
	else if ( (self.anim_movement == "run") && (self.anim_pose != "prone") )
	{
		runDirection = animscripts\utility::getQuadrant ( self getMotionAngle() );
		
		switch(runDirection)
		{
		case "front":
			if (!isDefined(anim.lastDeathRun))
			{
				anim.lastDeathRun = randomint(6);
			}
			else
			{
				anim.lastDeathRun = ( anim.lastDeathRun + 1 ) % 6;
			}
			switch (anim.lastDeathRun)
			{
			case 0:
				self setflaggedanimknob("animdone", %death_run_forward_crumple, 1, .05, 1);
				break;
			case 1:
				self setflaggedanimknob("animdone", %death_run_onfront, 1, .05, 1);
				break;
			case 2:
				self setflaggedanimknob("animdone", %death_run_onleft, 1, .05, 1);
				break;
			case 3:
				self setflaggedanimknob("animdone", %death_run_stumble, 1, .05, 1);
				break;
			case 4:
				self setflaggedanimknob("animdone", %crouchrun_death_drop, 1, .05, 1);
				break;
			case 5:
				self setflaggedanimknob("animdone", %crouchrun_death_crumple, 1, .05, 1);
				break;
			}
			break;
		case "left":
			self setflaggedanimknob("animdone", %death_run_left, 1, .05, 1);
			break;
		case "right":
			self setflaggedanimknob("animdone", %death_run_right, 1, .05, 1);
			break;
		case "back":
			self setflaggedanimknob("animdone", %death_run_back, 1, .05, 1);
			break;
		default:
			println ( "MotionAngle is " + (self getMotionAngle()) );
			println ( "runDirection is " + runDirection );
			homemade_error = crap_out_now + please;
		}
	}
	else
	{
		switch (self.anim_pose)
		{
		case "stand":
            if ( (	//(self.damagelocation == "head") ||
					(self.damagelocation == "helmet") ||
					//(self.damagelocation == "neck") ||
					(self.damagelocation == "torso_upper") ||
					(self.damagelocation == "left_arm_upper") ||
					(self.damagelocation == "right_arm_upper") ) &&
					(self.damageTaken > 80) )
			{
				// I really took a lot of damage.  Play an animation that flings me away from the damage.
				if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
				{
					if (rand<50)
					{
						self setflaggedanimknob("animdone", %stand_death_frontspin, 1, .05, 1);
					}
					else
					{
						self setflaggedanimknob("animdone", %death_run_back, 1, .05, 1);
					}
				}
				else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
				{
					self setflaggedanimknob("animdone", %death_run_left, 1, .05, 1);
				}
				else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
				{
					self setflaggedanimknob("animdone", %death_run_forward_crumple, 1, .05, 1);
				}
				else															// Left quadrant
				{
					self setflaggedanimknob("animdone", %death_run_right, 1, .05, 1);
				}
			}
			else if (self.damageLocation == "head")
			{
				if ( (rand<45) && ((self.damageyaw > 90)||(self.damageyaw <-135)) )	// Shot from front or right-front
				{
					self setflaggedanimknob("animdone", %stand_death_frontspin, 1, .05, 1);
				}
				else if ( (rand<90) && ((self.damageyaw > 90)||(self.damageyaw <-90)) )	// Shot from anywhere in front
				{
					self setflaggedanimknob("animdone", %stand_death_head_collapse, 1, .05, 1);
				}
				else
				{
					self setflaggedanimknob("animdone", %stand_death_headchest_topple, 1, .05, 1);
				}
			}
			else if ( (self.damageLocation == "neck") || (self.damageLocation == "torso_upper") )
			{
				if ( (rand<40) && ((self.damageyaw > 90)||(self.damageyaw <-135)) )	// Shot from front or right-front
				{
					self setflaggedanimknob("animdone", %stand_death_frontspin, 1, .05, 1);
				}
				else
				{
					if (rand<60)
						self setflaggedanimknob("animdone", %stand_death_neckdeath_thrash, 1, .05, 1);
					else
						self setflaggedanimknob("animdone", %stand_death_neckdeath, 1, .05, 1);
				}
			}
			else if ( (self.damageLocation == "left_leg_lower") || (self.damageLocation == "right_leg_lower") || 
						(self.damageLocation == "left_foot") || (self.damageLocation == "right_foot") )
			{
				self setflaggedanimknob("animdone", %stand_death_legs, 1, .05, 1);
			}
			else
			{
				if ( (self.damageyaw < 45) && (self.damageyaw > -45) )	// From the back
				{
					self setflaggedanimknob("animdone", %stand_death_lowerback, 1, .05, 1);
				}
				//else if (rand<50)
				//	self setflaggedanimknob("animdone", %stand_death_lowertorso, 1, .05, 1);	// This animation is too slow
				else
					self setflaggedanimknob("animdone", %stand_death_nervedeath, 1, .05, 1);
			}
			break;

		case "wounded":
		case "crouch":
			if ( (	(self.damagelocation == "head") ||
					(self.damagelocation == "helmet") ||
					(self.damagelocation == "neck") ) &&
					( (self.damageyaw > 135) || (self.damageyaw <-135) )	// Shot from front
					)
			{
				self setflaggedanimknob("animdone", %crouch_death_headshot_front, 1, .05, 1);
			}
			else if (rand<25)
				self setflaggedanimknob("animdone", %crouch_death_clutchchest, 1, .05, 1);
			else if (rand<50)
				self setflaggedanimknob("animdone", %crouch_death_flip, 1, .05, 1);
			else if (rand<75)
				self setflaggedanimknob("animdone", %crouch_death_fetal, 1, .05, 1);
			else
				self setflaggedanimknob("animdone", %crouch_death_falltohands, 1, .05, 1);
			break;

		case "prone":
			self setflaggedanimknob("animdone", %prone_death_quickdeath, 1, .05, 1);
			break;

		case "back":
			if (rand<50)
				self setflaggedanimknob("animdone", %back_death, 1, .05, 1);
			else
				self setflaggedanimknob("animdone", %back_death2, 1, .05, 1);
			break;

		default:
			[[anim.assert]](0, "Bad anim_pose in death.gsc");
		}
	}
//	self SetProneAnimNodes(-45, 45, %root, %root, %root);	// HACK!  This line does nothing except to make the next line run.
//	self EnterProne(1.0); // This makes the character align his front-back axis to the ground.  It's better than nothing...
	self animscripts\shared::DoNoteTracks("animdone");
}

testPrediction()
{
	self BeginPrediction();

	self animscripts\predict::start();

	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
	if (self animscripts\predict::stumbleWall(1))
	{
		self animMode("nogravity");

		self animscripts\predict::_setFlaggedAnimKnobAll("deathanim", %balcony_tumble_railing36_forward, %root, 1, 0.05, 1);
		if (self animscripts\predict::tumbleWall("deathanim"))
		{
			self EndPrediction();
			return true;
		}
	}

	self EndPrediction();
	self BeginPrediction();

	self animscripts\predict::start();

	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
	if (self animscripts\predict::stumbleWall(1))
	{
		self animMode("nogravity");

		self animscripts\predict::_setFlaggedAnimKnobAll("deathanim", %balcony_tumble_railing44_forward, %root, 1, 0.05, 1);
		if (self animscripts\predict::tumbleWall("deathanim"))
		{
			self EndPrediction();
			return true;
		}
	}

	self EndPrediction();

	self animscripts\predict::end();

	return false;
}


// Special death is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the death for the special animation state, or false if it wants the regular 
// death function to handle it.
specialDeath(anim_special)
{
	switch (anim_special)
	{
	case "cover_left":
		if (self.anim_pose == "stand")
		{
			rand = randomint(2);
			if (rand==0)
				self setflaggedanimknoball("deathanim", %cornerstanddeath1_right, %root, 1, .05, 1);
			else
				self setflaggedanimknoball("deathanim", %cornerstanddeath2_right, %root, 1, .05, 1);
		}
		else if (self.anim_pose == "crouch")
		{
			self setflaggedanimknoball("deathanim", %cornercrouchdeath1_right, %root, 1, .05, 1);
		}
		else
		{
			println ("Unexpected anim_pose value : "+self.anim_pose+" in specialDeath cover_left.");
			return false;
		}
		self animscripts\shared::DoNoteTracks ("deathanim");
		return true;
		break;
	case "cover_right":
		if (self.anim_pose == "stand")
		{
			self setflaggedanimknoball("deathanim", %cornerstanddeath1_left, %root, 1, .05, 1);
		}
		else if (self.anim_pose == "crouch")
		{
			rand = randomint(2);
			if (rand==0)
				self setflaggedanimknoball("deathanim", %corner_death_pushup, %root, 1, .05, 1);
			else
				self setflaggedanimknoball("deathanim", %cornercrouchdeath1_left, %root, 1, .05, 1);
		}
		else
		{
			println ("Unexpected anim_pose value : "+self.anim_pose+" in specialDeath cover_right.");
			return false;
		}
		self animscripts\shared::DoNoteTracks("deathanim");
		return true;
		break;
	case "cover_crouch":
		return false;
		break;
	case "rambo_left":
		return false;
		break;
	case "rambo_right":
		return false;
		break;
	case "rambo":
		return false;
		break;
	case "mg42":
		return false;
		break;
	default:
		println ("Unexpected anim_special value : "+anim_special+" in specialDeath.");
		return false;
	}
}


PlayDeathSound()
{
//	if (self.team == "allies")
//		self playsound("allied_death"); 
//	else
//		self playsound("german_death"); 
	self animscripts\face::SayGenericDialogue("death");
}

popHelmet()
{
	if ( isDefined ( self . hatModel ) )
	{
		partName = GetPartName ( self.hatModel, 0 );        
		model = spawn ("script_model", self . origin + (0,0,64) );
		model setmodel ( self.hatModel  );
		model . origin = self GetTagOrigin ( partName ); //self . origin + (0,0,64);
		model . angles = self GetTagAngles ( partName ); //(-90,0 + randomint(90),0 + randomint(90));
		model thread helmetMove ( self.damageDir );

		if (isdefined(self.helmetSideModel))
		{
			helmetSideModel = spawn ("script_model", self . origin + (0,0,64) );
			helmetSideModel setmodel ( self.helmetSideModel  );
			helmetSideModel . origin = self GetTagOrigin ( "TAG_HELMETSIDE" );
			helmetSideModel . angles = self GetTagAngles ( "TAG_HELMETSIDE" );
			helmetSideModel thread helmetMove ( self.damageDir );
		}

		wait 0.05;
		if (isdefined(self.helmetSideModel))
		{
			self detach(self.helmetSideModel, "TAG_HELMETSIDE");
			self.helmetSideModel = undefined;
		}
		self detach ( self.hatModel , "");
		self.hatModel = undefined;
	}
	return 0;
}

helmetMove ( damageDir )
{
    temp_vec = damageDir;
	temp_vec = maps\_utility::vectorScale (temp_vec, 150 + randomint (200));

	x = temp_vec[0];
	y = temp_vec[1];
	z = 100 + randomint (200);
	if (x > 0)
		self rotateroll((2*1500 + 3*randomfloat (2500)) * -1, 5,0,0);
	else
		self rotateroll(2*1500 + 3*randomfloat (2500), 5,0,0);
	
    //	self moveGravity ((x, y, z), 12);
    self launch ( ( x, y, z ) );
	wait (10);
	self delete();
}


DropGrenade()
{
	grenadeOrigin = self GetTagOrigin ( "TAG_WEAPON_RIGHT" ); 
	self MagicGrenadeManual (grenadeOrigin, (0,0,10), 3);
}