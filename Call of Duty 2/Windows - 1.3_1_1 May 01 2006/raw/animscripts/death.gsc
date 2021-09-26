#include animscripts\utility;
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

	/#
	if (isdefined(self.damageweapon))
		assertEx(isdefined(getAIWeapon(self.damageWeapon)), "Damage weapon " + tolower(self.damageweapon) + " is not defined in weaponList.gsc");
	#/

	if (self.anim_nodeath == true)
		return;
	if (isdefined (self.deathFunction))
	{
		self [[self.deathFunction]]();
		return;
	}
//	println ("hit at " + self.damagelocation);

	// make sure the guy doesn't keep doing facial animation after death
	changeTime = 0.3;
	self clearanim( %scripted_look_left,			changeTime );
	self clearanim( %scripted_look_right,			changeTime );
	self clearanim( %scripted_look_straight,		changeTime );
	self clearanim( %scripted_talking, changeTime );

	// Grab some info about the previous state before we wipe it all with Initialize()
	if( isDefined(self.isHoldingGrenade) && self.isHoldingGrenade )
		isHoldingGrenade = true;
	else
		isHoldingGrenade = false;

	// Drop the weapon as soon as they're dead.
	self animscripts\shared::DropAIWeapon();
	if (isHoldingGrenade)
		self DropGrenade();
	
	animscripts\utility::initialize("death");

	rand = randomint(100);
//	println("death script, pose "+self.anim_pose+", movement "+self.anim_movement+", location: "+self.damageLocation+", rand: "+rand);

		
	// Stop any lookats that are happening and make sure no new ones occur while death animation is playing.
	self notify ("never look at anything again");

	// should move this to squad manager somewhere...
	removeSelfFrom_SquadLastSeenEnemyPos(self.origin);

	if (isDefined(self.deathanim))
	{
//		println("playing special death");
		//thread [[anim.println]]("Playing special death as set by self.deathanim");#/
		self SetFlaggedAnimKnobAll("deathanim", self.deathanim, %root, 1, .05, 1);
		self animscripts\shared::DoNoteTracks("deathanim");
		if (isDefined(self.deathanimloop))
		{
			// "Playing special dead/wounded loop animation as set by self.deathanimloop");#/
			self SetFlaggedAnimKnobAll("deathanim", self.deathanimloop, %root, 1, .05, 1);
			for (;;)
			{
				self animscripts\shared::DoNoteTracks("deathanim");
			}
		}
		
		// Added so that I can do special stuff in Level scripts on an ai
		if(isdefined(self.deathanimscript))
			self [[self.deathanimscript]]();
		return;
	}
	
	if ( specialDeath("animdone") )
	{
		self animscripts\shared::DoNoteTracks("animdone");
		return;
	}

	self clearanim(%root, 0.2);
//	self thread animscripts\pain::PlayHitAnimation();

	PlayDeathSound();
//	deathFace = animscripts\face::ChooseAnimFromSet(anim.deathFace);
//	self animscripts\face::SaySpecificDialogue(deathFace, undefined, 1.0);

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

			// Play a sound
			if ( isAI(self) && isdefined(self.groundType) )
				self playsound ("bodyfall_" + self.groundType + "_large");
			else
				self playsound ("bodyfall_dirt_large");	// Should I even play anything here?

			// Play the animation
//			self setflaggedanimknob("animdone", %balcony_death_onfeet);
//			self setflaggedanimknob("animdone", %balcony_death_onfront);
			self setflaggedanimknob("animdone", %balcony_death_onback, 1, 0, 1);
			self animscripts\shared::DoNoteTracks("animdone");
			return;
		}
	}

	playDeathAnim( "animdone", rand );
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
specialDeath(msg)
{
	anim_special = self.anim_special;
	if (self.anim_painspecial != "none")
		anim_special = self.anim_painspecial;
	else
	if (anim_special == "none")
		return false;
	
	switch (anim_special)
	{
	case "cover_right":
		/*
		// do a normal death anim for spice sometimes
		if (randomint(100) < 35)
			return false;
			*/
			
		if (self.anim_pose == "stand")
		{
			if (randomint(100) < 50)
				self setflaggedanimknoball(msg, %corner_right_stand_alert2death, %root, 1, .05, 1);
			else
				self setflaggedanimknoball(msg, %corner_right_stand_alert2death_2, %root, 1, .05, 1);
		}
		else if (self.anim_pose == "crouch")
		{
			self setflaggedanimknoball(msg, %corner_right_crouch_alert2death, %root, 1, .05, 1);
		}
		else
		{
			println ("Unexpected anim_pose value : "+self.anim_pose+" in specialDeath cover_right.");
			return false;
		}
		return true;
	}
	return false;
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
	if (!isdefined (self)) // removed immediately on death
		return;
	if (!removeableHat())
		return;
		
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

	helmet =  self.hatmodel;
	self.hatmodel = undefined;
	wait 0.05;
	if (!isdefined (self))
		return;
	if (isdefined(self.helmetSideModel))
	{
		self detach(self.helmetSideModel, "TAG_HELMETSIDE");
		self.helmetSideModel = undefined;
	}
	self detach ( helmet , "");
}

helmetMove ( damageDir )
{
    temp_vec = damageDir;
	temp_vec = maps\_utility::vectorScale (temp_vec, 150 + randomint (200));

	x = temp_vec[0];
	y = temp_vec[1];
	z = 100 + randomint (200);
	if (y > 0)
		self rotatepitch((4000 + randomfloat (500)) * -1, 5,0,0);
	else
		self rotatepitch(4000 + randomfloat (500), 5,0,0);
	
//	self moveGravity ((x, y, z), 12);
    self launch ( ( x, y, z ) );
	wait (5);
	
	if (isdefined(self))
		self delete();
}


DropGrenade()
{
	grenadeOrigin = self GetTagOrigin ( "TAG_WEAPON_RIGHT" ); 
	self MagicGrenadeManual (grenadeOrigin, (0,0,10), 3);
}

removeSelfFrom_SquadLastSeenEnemyPos(org)
{
	for (i=0;i<anim.squadIndex.size;i++)
		anim.squadIndex[i] clearSightPosNear(org);
}

clearSightPosNear(org)
{
	if (!isdefined(self.sightPos))
		return;
			
	if (distance (org, self.sightPos) < 80)
	{
		self.sightPos = undefined;
		self.sightTime = gettime();
	}
}

	
playDeathAnim( msg, rand )
{
    tryHelmetPop();
	
	explosiveDeath = true;
	if (getAIWeapon(self.damageWeapon)["type"] == "bolt")
		explosiveDeath = false;
	if (getAIWeapon(self.damageWeapon)["type"] == "auto")
		explosiveDeath = false;
	if (getAIWeapon(self.damageWeapon)["type"] == "semi")
		explosiveDeath = false;
	
	if ( (self.damageLocation == "none") && (self.damageTaken > 40) )
	{
		// "None" means explosion, so this is a decent explosion impact.  Fly through the air.
        // JBW - set animmode to nogravity to get Z delta, then turn gravity on so bbox plants to ground (otherwise it will float level with initial Z)
        // Delta bboxes cause problems with floating guys since the bbox can easily land on ledges - may be better to go through things with stationary bbox
		if (self.damageTaken > 215 && gettime() > anim.lastUpwardsDeathTime + 500)
		{
			anim.lastUpwardsDeathTime = gettime();
            self animMode ("nogravity");
			self getDeathAnim(msg, %death_explosion_up10, 1, .05, 1);
		}
		else
		if (self.damageTaken > 160)
		{
			if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
			{
				self animMode ("nogravity");
				self getDeathAnim(msg, %death_explosion_back13, 1, .05, 1);
			}
			else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
			{
				self animMode ("nogravity");
				self getDeathAnim(msg, %death_explosion_left11, 1, .05, 1);
			}
			else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
			{
				self animMode ("nogravity");
				self getDeathAnim(msg, %death_explosion_forward13, 1, .05, 1);
			}
			else															// Left quadrant
			{
				assertEX( (self.damageyaw > -135) && (self.damageyaw <= -45), "death::main: DamageYaw logic error (yaw is "+self.damageyaw);
				self animMode ("nogravity");
				self getDeathAnim(msg, %death_explosion_right13, 1, .05, 1);
			}
		}
		else
		{
			if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
			{
				self getDeathAnim(msg, %death_run_back, 1, .05, 1);
			}
			else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
			{
				self getDeathAnim(msg, %death_run_left, 1, .05, 1);
			}
			else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
			{
				self getDeathAnim(msg, %death_run_forward_crumple, 1, .05, 1);
			}
			else															// Left quadrant
			{
				self getDeathAnim(msg, %death_run_right, 1, .05, 1);
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
				self getDeathAnim(msg, %death_run_forward_crumple, 1, .05, 1);
				break;
			case 1:
				self getDeathAnim(msg, %death_run_onfront, 1, .05, 1);
				break;
			case 2:
				self getDeathAnim(msg, %death_run_onleft, 1, .05, 1);
				break;
//			case 3:
//				self getDeathAnim(msg, %death_run_stumble, 1, .05, 1);
//				break;
			case 3:
				self getDeathAnim(msg, %crouchrun_death_crumple, 1, .05, 1);
				break;
			case 4:
				self getDeathAnim(msg, getAnim("crouchrun_death_drop"), 1, .05, 1);
				break;
			case 5:
				self getDeathAnim(msg, %crouchrun_death_crumple, 1, .05, 1);
				break;
			}
			break;
		case "left":
			self getDeathAnim(msg, %death_run_left, 1, .05, 1);
			break;
		case "right":
			self getDeathAnim(msg, %death_run_right, 1, .05, 1);
			break;
		case "back":
//			self getDeathAnim(msg, %crouchrun_death_crumple, 1, .05, 1);
			self getDeathAnim(msg, %death_run_back, 1, .05, 1);
			break;
		default:
			println ( "MotionAngle is " + (self getMotionAngle()) );
			println ( "runDirection is " + runDirection );
			assertmsg("bad run direction");
			break;
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
					(self.damageTaken > 80 && explosiveDeath)  )
			{
				// I really took a lot of damage.  Play an animation that flings me away from the damage.
				if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
				{
					if (rand<50)
					{
						self getDeathAnim(msg, %stand_death_frontspin, 1, .05, 1);
					}
					else
					{
						self getDeathAnim(msg, %death_run_back, 1, .05, 1);
					}
				}
				else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
				{
					self getDeathAnim(msg, %death_run_left, 1, .05, 1);
				}
				else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
				{
					self getDeathAnim(msg, %death_run_forward_crumple, 1, .05, 1);
				}
				else															// Left quadrant
				{
					self getDeathAnim(msg, %death_run_right, 1, .05, 1);
				}
			}
 			else if (self.damageLocation == "head")
 				setHeadDeathAnim(msg, rand);
			else if ( (self.damageLocation == "neck") || (self.damageLocation == "torso_upper") )
			{
				if ( (rand<40) && ((self.damageyaw > 90)||(self.damageyaw <-135)) )	// Shot from front or right-front
				{
					self getDeathAnim(msg, %stand_death_frontspin, 1, .05, 1);
				}
				else
				if ( self.damageyaw < 45 || self.damageyaw > -45 )
				{					
					self getDeathAnim(msg, %stand_death_nervedeath, 1, .05, 1);
				}
				else
				{
					if (rand<60)
						self getDeathAnim(msg, getAnim("stand_death_neckdeath_thrash"), 1, .05, 1);
					else
						self getDeathAnim(msg, %stand_death_neckdeath, 1, .05, 1);
				}
			}
			else if ( (self.damageLocation == "left_leg_lower") || (self.damageLocation == "right_leg_lower") || 
						(self.damageLocation == "left_foot") || (self.damageLocation == "right_foot") )
			{
				self getDeathAnim(msg, getAnim("stand_death_legs"), 1, .05, 1);
			}
			else
			{
				if ( (self.damageyaw < 45) && (self.damageyaw > -45) )	// From the back
				{
					self getDeathAnim(msg, %stand_death_lowerback, 1, .05, 1); // stand_death_lowerback
				}
				//else if (rand<50)
				//	self getDeathAnim(msg, %stand_death_lowertorso, 1, .05, 1);	// This animation is too slow
				else
					self getDeathAnim(msg, %stand_death_nervedeath, 1, .05, 1);
			}
			break;

		case "wounded":
			assert (isdefined(self.anim_wounded));
			if (self.anim_wounded == "crawl")
			{
				if ( self.damageyaw < 135 && self.damageyaw > 45 )	// Shot from right
					self getDeathAnim(msg, %crawl_death_right, 1, .05, 1);
				else
				if ( self.damageyaw > -135 && self.damageyaw < -45 )	// Shot from left
					self getDeathAnim(msg, %crawl_death_left, 1, .05, 1);
				else
					self getDeathAnim(msg, %crawl_death_front, 1, .05, 1);
				break;
			}
		case "crouch":
			if ( (	(self.damagelocation == "head") ||
					(self.damagelocation == "helmet") ||
					(self.damagelocation == "neck") ) &&
					( (self.damageyaw > 135) || (self.damageyaw <-135) )	// Shot from front
					)
			{
				self getDeathAnim(msg, getAnim("crouch_death_headshot_front"), 1, .05, 1);
			}
			else if (rand<25)
				self getDeathAnim(msg, getAnim("crouch_death_clutchchest"), 1, .05, 1);
			else if (rand<50)
				self getDeathAnim(msg, getAnim("crouch_death_flip"), 1, .05, 1);
			else if (rand<75)
				self getDeathAnim(msg, getAnim("crouch_death_fetal"), 1, .05, 1);
			else
				self getDeathAnim(msg, getAnim("crouch_death_falltohands"), 1, .05, 1);
			break;

		case "prone":
			self getDeathAnim(msg, %prone_death_quickdeath, 1, .05, 1);
			break;

		case "back":
			if (rand<50)
				self getDeathAnim(msg, %back_death, 1, .05, 1);
			else
				self getDeathAnim(msg, %back_death2, 1, .05, 1);
			break;

		default:
			assertEX(0, "Bad anim_pose in death.gsc");
			break;
		}
	}
}

setHeadDeathAnim(msg, rand)
{
	if ( specialDeath(msg) )
		return;

	if (metalHat())
		thread maps\_utility::playsoundinspace("bullet_impact_headshot",self gettagorigin ("TAG_EYE"));
	tryHelmetPop();
	if ( (rand<45) && ((self.damageyaw > 90)||(self.damageyaw <-135)) )	// Shot from front or right-front
	{
		self getDeathAnim(msg, %stand_death_frontspin, 1, .05, 1);
	}
	else if ( (rand<90) && ((self.damageyaw > 90)||(self.damageyaw <-90)) )	// Shot from anywhere in front
	{
		self getDeathAnim(msg, getAnim("stand_death_head_collapse"), 1, .05, 1);
	}
	else
		self getDeathAnim(msg, getAnim("stand_death_headchest_topple"), 1, .05, 1);
}

tryHelmetPop()
{
    if ( isDefined ( self . alwaysPop ) && self . alwaysPop )
        thread popHelmet();    
    else if ( self.damageLocation == "head"  || self.damageLocation == "helmet" )
    {
		if ( randomint(100) > 40 )
            thread popHelmet();
    }
}

getDeathAnim(msg, anime, blend, blendrate, rate)
{
	self setflaggedanimknob(msg, anime, blend, blendrate, rate);
	/#
	if (getdebugcvar("debug_grenadehand") == "on")
	{
		if (animhasnotetrack(anime, "bodyfall large"))
			return;
		if (animhasnotetrack(anime, "bodyfall small"))
			return;
			
		println ("Death animation ", anime, " does not have a bodyfall notetrack");
		iprintlnbold ("Death animation needs fixing (check console and report bug in the animation to Boon)");
	}
	#/
}

initFatAnims()
{
	anim.fatdeathanim[true]		["crouch_death_clutchchest"]		= %crouch_death_clutchchest_fat;
	anim.fatdeathanim[false]	["crouch_death_clutchchest"]		= %crouch_death_clutchchest;
	anim.fatdeathanim[true]		["crouch_death_falltohands"]		= %crouch_death_falltohands_fat;
	anim.fatdeathanim[false]	["crouch_death_falltohands"]		= %crouch_death_falltohands;
	anim.fatdeathanim[true]		["crouch_death_fetal"]				= %crouch_death_fetal_fat;
	anim.fatdeathanim[false]	["crouch_death_fetal"]				= %crouch_death_fetal;
	anim.fatdeathanim[true]		["crouch_death_flip"]				= %crouch_death_flip_fat;
	anim.fatdeathanim[false]	["crouch_death_flip"]				= %crouch_death_flip;
	anim.fatdeathanim[true]		["crouch_death_headshot_front"]		= %crouch_death_headshot_front_fat;
	anim.fatdeathanim[false]	["crouch_death_headshot_front"]		= %crouch_death_headshot_front;
	anim.fatdeathanim[true]		["crouchrun_death_drop"]			= %crouchrun_death_drop_fat;
	anim.fatdeathanim[false]	["crouchrun_death_drop"]			= %crouchrun_death_drop;
	anim.fatdeathanim[true]		["stand_death_head_collapse"]		= %stand_death_head_collapse_fat;
	anim.fatdeathanim[false]	["stand_death_head_collapse"]		= %stand_death_head_collapse;
	anim.fatdeathanim[true]		["stand_death_headchest_topple"]	= %stand_death_headchest_topple_fat;
	anim.fatdeathanim[false]	["stand_death_headchest_topple"]	= %stand_death_headchest_topple;
	anim.fatdeathanim[true]		["stand_death_legs"]				= %stand_death_legs_fat;
	anim.fatdeathanim[false]	["stand_death_legs"]				= %stand_death_legs;
	anim.fatdeathanim[true]		["stand_death_neckdeath_thrash"]	= %stand_death_neckdeath_thrash_fat;
	anim.fatdeathanim[false]	["stand_death_neckdeath_thrash"]	= %stand_death_neckdeath_thrash;
}

getAnim(msg)
{
	return (anim.fatdeathanim[fatGuy()][msg]);
}