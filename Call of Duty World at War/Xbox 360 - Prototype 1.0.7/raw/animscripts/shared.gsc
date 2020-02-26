// Shared.gsc - Functions that are shared between animscripts and level scripts.  
// Functions in this file can't rely on the animscripts\init function having run, and can't call any 
// functions not allowed in level scripts.

#include maps\_utility;
#include animscripts\Utility;
#include common_scripts\Utility;

#using_animtree ("generic_human");

placeWeaponOn( weapon, position )
{	
	// make sure this it one of our weapons
	assert( AIHasWeapon( weapon ) );
	
	curPosition = self.weaponInfo[weapon].position;
	
	// make sure we're not out of sync
	assert( curPosition == "none" || self.a.weaponPos[curPosition] == weapon );
	
	// weapon already in place
	if ( position != "none" && self.a.weaponPos[position] == weapon )
		return;
	
	self detachAllWeapons();
	
	// detach if we're already in a position
	if ( curPosition != "none" )
		self detachWeapon( weapon );
		
	// nothing more to do
	if ( position == "none" )
	{
		self updateAttachedWeapons();
		return;
	}

	if ( self.a.weaponPos[position] != "none" )
		self detachWeapon( self.a.weaponPos[position] );

	// to ensure that the correct tags for the active weapon are used, we need to make sure it gets attached first
	if ( position == "left" || position == "right" )
	{
		self attachWeapon( weapon, position );
		self.weapon = weapon;
	}
	else
	{
		self attachWeapon( weapon, position );
	}

	self updateAttachedWeapons();
	
	// make sure we don't have a weapon in each hand
	assert( self.a.weaponPos["left"] == "none" || self.a.weaponPos["right"] == "none" );
}

detachWeapon( weapon )
{
	self.a.weaponPos[self.weaponInfo[weapon].position] = "none";
	self.weaponInfo[weapon].position = "none";
}


attachWeapon( weapon, position )
{
	self.weaponInfo[weapon].position = position;
	self.a.weaponPos[position] = weapon;
}

detachAllWeapons()
{
	positions = [];
	positions[positions.size] = "right";
	positions[positions.size] = "left";
	positions[positions.size] = "chest";
	positions[positions.size] = "back";

	self laserOff();

	for ( index = 0; index < positions.size; index++ )
	{
		weapon = self.a.weaponPos[positions[index]];
		
		if ( weapon == "none" )
			continue;
			
		// temp
//		if ( (positions[index] == "right" || positions[index] == "left") && self.weaponInfo[weapon].useClip && self.weaponInfo[weapon].hasClip )
		if ( self.weaponInfo[weapon].useClip && self.weaponInfo[weapon].hasClip )
			self detach( getWeaponClipModel( weapon ), "tag_clip" );

		self detach( getWeaponModel( weapon ), getTagForPos( positions[index] ) );
	}	
}

updateAttachedWeapons()
{
	positions = [];
	positions[positions.size] = "right";
	positions[positions.size] = "left";
	positions[positions.size] = "chest";
	positions[positions.size] = "back";

	for ( index = 0; index < positions.size; index++ )
	{
		weapon = self.a.weaponPos[positions[index]];
		
		if ( weapon == "none" )
			continue;
			
		self attach( getWeaponModel( weapon ), getTagForPos( positions[index] ) );

		// temp
//		if ( (positions[index] == "right" || positions[index] == "left") && self.weaponInfo[weapon].useClip && self.weaponInfo[weapon].hasClip )
		if ( self.weaponInfo[weapon].useClip && self.weaponInfo[weapon].hasClip )
			self attach( getWeaponClipModel( weapon ), "tag_clip" );			
	}

	self updateLaserStatus();
}

updateLaserStatus()
{
	if ( self.a.weaponPos["right"] == "none" )
		return;
		
	if ( self.a.laserOn && isDefined( level.player.nightVision_Enabled ) && isAlive( self ) )
		self laserOn();
	else
		self laserOff();
}

getTagForPos( position )
{
	switch ( position )
	{
		case "chest":
			return "tag_weapon_chest";
		case "back":
			return "tag_stowed_back";
		case "left":
			return "tag_weapon_left";
		case "right":
			return "tag_weapon_right";
		case "hand":
			return "tag_inhand";
		default:
			assertMsg( "unknown weapon placement position: " + position );
		break;
	}
}



DropAIWeapon()
{
	if ( self.a.weaponPos["right"] == "none" )
		return;
		

	if ( getdvarint( "scr_physWeaponDrop" ) != 0 )
	{
		self dropPhysWeapon();
		return;
	}

	if( self.dropWeapon )
	{
		throwVel = 75 + randomInt(50);
		self DropWeapon(self.weapon, "right", throwVel);
	}
	animscripts\shared::placeWeaponOn( self.weapon, "none" );
}


dropPhysWeapon()
{
	tagOrigin = self getTagOrigin( "tag_weapon_right" );
	tagAngles = self getTagAngles( "tag_weapon_right" );
	
	physWeapon = spawn( "script_model", tagOrigin );
	physWeapon.angles = tagAngles;
	physWeapon setModel( getWeaponModel( self.weapon ) );
	physWeapon thread addPhysWeapon();
	
	animscripts\shared::placeWeaponOn( self.weapon, "none" );
	
	physWeapon physicsLaunch( tagOrigin + (randomFloat(6),randomFloat(6),randomFloat(6)), (randomFloat(500)-250,randomFloat(500)-250,randomFloat(50)) );
}


addPhysWeapon()
{
	self thread deleteAtLimit();
}


deleteAtLimit()
{
	wait 30.0;
	
	self delete();
}


LookAtEntity(lookTargetEntity, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	return;
/*
	assertEX(isAI(self), "Can only call this function on an AI character");											
	assert]](self.a.targetLookInitilized == true, "LookAtEntity called on AI that lookThread was not called on");	#/
	assert]](isDefined(lookTargetEntity), "lookTargetEntity is not defined");											#/
	assert]]( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");					#/
	assert]]( !isDefined(interruptOthers) || (interruptOthers=="interrupt") || (interruptOthers=="don't interrupt") );	#/
	// If interruptOthers is set, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to "interrupt".
	if ( !isDefined(interruptOthers) || (interruptOthers=="interrupt") || (GetTime() > self.a.lookEndTime) )
	{
		if(isSentient(lookTargetEntity))
			self.a.lookTargetType = "sentient";
		else
			self.a.lookTargetType = "entity";
		self.a.lookTargetEntity = lookTargetEntity;
		self.a.lookEndTime = GetTime() + (lookDuration*1000);
		if(lookSpeed == "casual")
			self.a.lookTargetSpeed = 800;
		else // alert
			self.a.lookTargetSpeed = 1600;
		if ( isDefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}
*/
}

LookAtPosition(lookTargetPos, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	assertEX(isAI(self), "Can only call this function on an AI character");											
	assertEX(self.a.targetLookInitilized == true, "LookAtPosition called on AI that lookThread was not called on");	
	assertEX( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");					
	// If interruptOthers is true, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to true.
	if ( !isDefined(interruptOthers) || (interruptOthers=="interrupt others") || (GetTime() > self.a.lookEndTime) )
	{
		self.a.lookTargetPos = lookTargetPos;
		self.a.lookEndTime = GetTime() + (lookDuration*1000);
		if(lookSpeed == "casual")
			self.a.lookTargetSpeed = 800;
		else // alert
			self.a.lookTargetSpeed = 1600;
		if ( isDefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}

}

LookAtStop()
{
	assertEX(isAI(self), "Can only call this function on an AI character");
	assertEX(self.a.targetLookInitilized == true, "LookAtStop called on AI that lookThread was not called on");

	animscripts\look::finishLookAt();
}

LookAtAnimations(leftanim, rightanim)
{
	self.a.LookAnimationLeft = leftanim;
	self.a.LookAnimationRight = rightanim;
}


SetInCombat(timeOfEffect)
{
	//("SetInCombat called, time set to ",timeOfEffect);#/
	if (!isDefined(timeOfEffect))
	{
		self.a.combatEndTime = gettime() + anim.combatMemoryTimeConst + randomint(anim.combatMemoryTimeRand);
	}
	else
	{
		self.a.combatEndTime = gettime() + (timeOfEffect*1000);
	}
}


/#
showNoteTrack( note )
{
	if ( getdebugdvar("scr_shownotetracks") != "on" && getdebugdvarint("scr_shownotetracks") != self getentnum() )
		return;
	
	anim.showNotetrackSpeed = 30; // units/sec
	anim.showNotetrackDuration = 30; // frames
	
	if ( !isdefined( self.a.shownotetrackoffset ) )
	{
		thisoffset = 0;
		self.a.shownotetrackoffset = 10;
		self thread reduceShowNotetrackOffset();
	}
	else
	{
		thisoffset = self.a.shownotetrackoffset;
		self.a.shownotetrackoffset += 10;
	}
	
	duration = anim.showNotetrackDuration + int(20.0 * thisoffset / anim.showNotetrackSpeed);
	
	color = (.5,.75,1);
	if ( note == "end" || note == "finish" )
		color = (.25,.4,.5);
	else if ( note == "undefined" )
		color = (1,.5,.5);
	
	for ( i = 0; i < duration; i++ )
	{
		if ( duration - i <= anim.showNotetrackDuration )
			amnt = 1.0 * (i - (duration - anim.showNotetrackDuration)) / anim.showNotetrackDuration;
		else
			amnt = 0.0;
		time = 1.0 * i / 20;
		
		alpha = 1.0 - amnt*amnt;
		pos = self geteye() + (0, 0, 20 + anim.showNotetrackSpeed * time - thisoffset);
		
		print3d( pos, note, color, alpha );
		
		wait .05;
	}
}
reduceShowNotetrackOffset()
{
	self endon("death");
	while( self.a.shownotetrackoffset > 0 )
	{
		wait .05;
		self.a.shownotetrackoffset -= anim.showNotetrackSpeed * .05;
	}
	self.a.shownotetrackoffset = undefined;
}
#/

HandleNoteTrack( note, flagName, customFunction )
{
	/#
	self thread showNoteTrack( note );
	#/
	
	switch ( note )
	{
	case "end":
	case "finish":
	case "undefined":
		if ( isAI(self) && self.a.pose=="back" ) 
		{
			//("HACK!  Changing pose \"back\" to \"crouch\" in DoNoteTracks");#/
//			self.a.pose = "crouch";
		}

		prof_end("DoNoteTracks");
		return note;

// POSE CHANGES BEGIN 
	case "anim_pose = \"stand\"":
		if (self.a.pose == "prone")
		{
			self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
			self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		}
		self.a.pose = "stand";
		self notify ("entered_pose" + "stand");
		break;
	case "anim_pose = \"crouch\"":
		if (self.a.pose == "prone")
		{
			self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
			self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		}
		self.a.pose = "crouch";
		self notify ("entered_pose" + "crouch");
		if (self.a.crouchPain)
		{
			// for dying pain
			self.a.crouchPain = false;
			self.health = 150;
		}
		break;
	case "anim_pose = \"prone\"":
		self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
		self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
		self.a.pose = "prone";
		self notify ("entered_pose" + "prone");
		break;
	case "anim_pose = \"crawl\"":
		self SetProneAnimNodes(-45, 45, %prone_legsdown, %prone_legsstraight, %prone_legsup);
		self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
		self.a.pose = "prone";
		self notify ("entered_pose" + "prone");
		break;
	case "anim_pose = \"back\"":
		if (self.a.pose == "prone")
		{
			self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		}
		self.a.pose = "back";
		self notify ("entered_pose" + "back");
		self.a.movement = "stop";
		break;
// POSE CHANGES END



// MOVEMENT CHANGES BEGIN
	case "anim_movement = \"stop\"":
		self.a.movement = "stop";
		break;
	case "anim_movement = \"walk\"":
		self.a.movement = "walk";
		break;
	case "anim_movement = \"run\"":
		self.a.movement = "run";
		break;
// MOVEMENT CHANGES END


// ALERTNESS CHANGES BEGIN
	case "anim_aiming = 1":
		self.a.alertness = "aiming";
		break;
	case "anim_aiming = 0":
		self.a.alertness = "alert";
		break;
	case "anim_alertness = casual":
		self.a.alertness = "casual";
		break;
	case "anim_alertness = alert":
		self.a.alertness = "alert";
		break;
	case "anim_alertness = aiming":
		self.a.alertness = "aiming";
		break;
// ALERTNESS CHANGES END
		
// GUN CHANGES BEGIN
	case "gunhand = (gunhand)_left":
	case "anim_gunhand = \"left\"":
		if ( !isAI(self) )
			break;

		animscripts\shared::placeWeaponOn( self.weapon, "left" );
		break;

	case "gunhand = (gunhand)_right":
	case "anim_gunhand = \"right\"":
		if ( !isAI(self) )
			break;

		animscripts\shared::placeWeaponOn( self.weapon, "right" );
		break;

	case "anim_gunhand = \"none\"":
		if ( !isAI(self) ) 
			break;

		animscripts\shared::placeWeaponOn( self.weapon, "none" );
		break;

	case "gun_2_chest":
		assert( !usingSidearm() );

		animscripts\shared::placeWeaponOn( self.weapon, "chest" );
		break;

	case "gun_2_back":
		animscripts\shared::placeWeaponOn( self.weapon, "back" );
		// TODO: more asserts and elegant handling of weapon switching here
		self.weapon = self.primaryweapon;
		self.bulletsInClip = weaponClipSize( self.weapon );
		break;

	case "pistol_pickup":
		animscripts\shared::placeWeaponOn( self.sidearm, "right" );
		self.bulletsInClip = weaponClipSize( self.weapon );
		self notify ( "weapon_switch_done" );
		break;

	case "pistol_putaway":
		animscripts\shared::placeWeaponOn( self.weapon, "none" );
		// TODO: more asserts and elegant handling of weapon switching here
		self.weapon = self.primaryweapon;
		self.bulletsInClip = weaponClipSize( self.weapon );
		break;		

	// TODO: change this to handle guns without magazines currently in them
	case "drop clip":
		if ( self.weaponInfo[self.weapon].useClip && self.weaponInfo[self.weapon].hasClip )
			self thread handleDropClip( flagName );
		break;
		
	case "refill clip":
		self animscripts\weaponList::RefillClip();
		break;

// GUN CHANGES END

// GRAVITY CHANGE BEGIN
	case "gravity on":
        self animMode ("gravity");
		break;
	case "gravity off":
        self animMode ("nogravity");
		break;
// GRAVITY CHANGE END

// SOUNDS BEGIN
	case "bodyfall large":
		if ( isAI(self) && isdefined(self.groundType) )
			self playsound ("bodyfall_" + self.groundType + "_large");
		else
			self playsound ("bodyfall_dirt_large");	
		break;
	case "bodyfall small":
		if ( isAI(self) && isdefined(self.groundType) )
			self playsound ("bodyfall_" + self.groundType + "_small");
		else
			self playsound ("bodyfall_dirt_small");	
		break;

	case "footstep":
	case "step":
	case "footstep_right_large":
	case "footstep_right_small":
		playFootStep("J_Ball_RI");
		self playsound( "gear_rattle_run" );
		break;
	case "footstep_left_large":
	case "footstep_left_small":
		playFootStep("J_Ball_LE");
		self playsound( "gear_rattle_run" );
		break;
	case "footscrape":
		if ( isAI(self) && isdefined(self.groundType) )
			self playsound ("step_scrape_" + self.groundType);
		else
			self playsound ("step_scrape_dirt");
		break;
	case "land":
		if ( isAI(self) && isdefined(self.groundType) )
			self playsound ("land_" + self.groundType);
		else
			self playsound ("land_dirt");	
		break;
	case "swish small":
		self thread play_sound_in_space ("melee_swing_small", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
//		case "melee":
	case "swish large":
		self thread play_sound_in_space ("melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		//self thread play_sound_in_space ("melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
// SOUNDS END

	case "rechamber":
		self.a.needsToRechamber = 0;
		break;
	case "reload done":
		self animscripts\weaponList::RefillClip();
		self.a.needsToRechamber = 0;
		break;
	case "fire":
		thread [[ anim.fire_notetrack_functions[ self.a.script ] ]]();
		break;
	case "no death":
		// does not play a death anim when he dies
		self.a.nodeath = true;
		break;
	case "fire_spray":
		thread sprayNotetrack();
		break;
	case "anim_melee = right":
	case "anim_melee = \"right\"":
		self.a.meleeState = "right";
		break;
	case "anim_melee = left":
	case "anim_melee = \"left\"":
		self.a.meleeState = "left";
		break;
	case "dropgun":
		DropAIWeapon();
		break;
	case "weapon_retrieve":
	/*
		assertEx( isdefined( self.oldWeapon ), "Tried to do notetrack weapon_retrieve but pistol_pickup had never been used" );
		self.secondaryWeapon = self.weapon;
		self.weapon = self.oldWeapon;
		self animscripts\shared::PutGunInHand("right");
		*/
		break;
	case "swap taghelmet to tagleft":
		if ( isDefined ( self.hatModel ) )
		{
			if (isdefined(self.helmetSideModel))
			{
				self detach(self.helmetSideModel, "TAG_HELMETSIDE");
				self.helmetSideModel = undefined;
			}
			self detach ( self.hatModel, "");
			self attach ( self.hatModel, "TAG_WEAPON_LEFT");
			self.hatModel = undefined;
		}
		break;
	case "stop anim":
		self stopanimscripted();
		break;
	default:
		if (isDefined(customFunction))
			[[customFunction]] (note);
		break;
	}
}

// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an "end" or a "finish"
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(flagName, ::customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
DoNoteTracks( flagName, customFunction, debugIdentifier )
{
	prof_begin("DoNoteTracks");

	if (!isDefined(debugIdentifier))
		debugIdentifier = "undefined";

	for (;;)
	{
		prof_begin("DoNoteTracks");

		self waittill (flagName, note);

		if ( !isDefined( note ) )
			note = "undefined";

		val = self HandleNoteTrack( note, flagName, customFunction );
		
		if ( isDefined( val ) )
			return val;
	}
}


DoNoteTracksIntercept( flagName, interceptFunction )
{
	assert( isDefined( interceptFunction ) );
	
	prof_begin("DoNoteTracks");

	for (;;)
	{
		prof_begin("DoNoteTracks");

		self waittill ( flagName, note );

		if ( !isDefined( note ) )
			note = "undefined";

		intercepted = [[interceptFunction]]( note );
		if ( isDefined( intercepted ) && intercepted )
			continue;

		val = self HandleNoteTrack( note, flagName );
		
		if ( isDefined( val ) )
			return val;
	}
}


DoNoteTracksPostCallback( flagName, postFunction )
{
	assert( isDefined( postFunction ) );
	
	prof_begin("DoNoteTracks");

	for (;;)
	{
		prof_begin("DoNoteTracks");

		self waittill ( flagName, note );

		if ( !isDefined( note ) )
			note = "undefined";

		val = self HandleNoteTrack( note, flagName );
		
		[[postFunction]]( note );
		
		if ( isDefined( val ) )
			return val;
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
DoNoteTracksForever(flagName, killString, customFunction, debugIdentifier)
{
	if (isdefined (killString))
		self endon (killString);
	self endon ("killanimscript");
	if (!isDefined(debugIdentifier))
		debugIdentifier = "undefined";

	for (;;)
	{
		time = GetTime();
		returnedNote = DoNoteTracks(flagName, customFunction, debugIdentifier);
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = DoNoteTracks(flagName, customFunction, debugIdentifier);
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
				println (GetTime()+" "+debugIdentifier+" animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
				wait ( 0.05 - timetaken );
			}
		}
		//(GetTime()+" "+debugIdentifier+" DoNoteTracksForever returned in "+timetaken+" ms.");#/
	}
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
DoNoteTracksForTime(time, flagName, customFunction, debugIdentifier)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc(time, flagName, customFunction, debugIdentifier, ent);
}

DoNoteTracksForTimeProc(time, flagName, customFunction, debugIdentifier, ent)
{
	ent endon ("stop_notetracks");
	DoNoteTracksForever(flagName, undefined, customFunction, debugIdentifier);
}

doNoteTracksForTimeEndNotify(time)
{
	wait (time);
	self notify ("stop_notetracks");
}

playFootStep(foot)
{
	if (! isAI(self) )
	{
		self playsound ("step_run_dirt");	
		return;
	}

	groundType = undefined;
	// gotta record the groundtype in case it goes undefined on us
	if (!isdefined(self.groundtype))
	{
		if (!isdefined(self.lastGroundtype))
		{
			self playsound ("step_run_dirt");	
			return;
		}

		groundtype = self.lastGroundtype;
	}
	else
	{
		groundtype = self.groundtype;
		self.lastGroundtype = self.groundType;
	}
	
	self playsound ("step_run_" + groundType);
	[[anim.optionalStepEffectFunction]](foot, groundType);
}


playFootStepEffect(foot, groundType)
{
	for (i=0;i<anim.optionalStepEffects.size;i++)
	{
		if (groundType != anim.optionalStepEffects[i])
			continue;
		org = self gettagorigin(foot);
		playfx(level._effect["step_" + anim.optionalStepEffects[i]], org, org + (0,0,100));
		return;
	}
}

shootNotetrack()
{
	waittillframeend; // this gives a chance for anything else waiting on "fire" to shoot
	if ( gettime() > self.a.lastShootTime ) 
	{
		self shootWrapper();
		self.bulletsInClip--;
		if ( weaponClass( self.weapon ) == "rocketlauncher" )
			self.a.rockets--;
	}
}

fire_straight()
{
	if ( self.a.weaponPos[ "right" ] == "none" )
		return;
		
	weaporig = self gettagorigin( "tag_weapon" );
	dir = anglestoforward( self gettagangles( "tag_weapon" ) );
	pos = weaporig + vectorScale( dir, 1000 );
	// note, shootwrapper is not called because shootwrapper applies a random spread, and shots
	// fired in a scripted sequence need to go perfectly straight so they get the same result each time.
	self shoot( 1, pos );
	self.bulletsInClip--;
}

sprayNotetrack()
{
	//TODO: make AI not use anims with this notetrack if they don't have a weapon
	if ( self.a.weaponPos["right"] == "none" )
		return;
		
	weaporig = self gettagorigin("tag_weapon");
	dir = anglestoforward( self gettagangles( "tag_weapon" ) );
	
	hitenemy = false;
	// check if we're aiming closish to our enemy
	if ( issentient(self.enemy) && isalive(self.enemy) )
	{
		enemydir = vectornormalize(self.enemy geteye() - weaporig);
		if ( vectordot(dir, enemydir) > cos(10) )
		{
			hitenemy = true;
		}
	}
	
	if ( hitenemy )
	{
		self shootWrapper();
	}
	else
	{
		dir += ((randomfloat(2)-1) * .1, (randomfloat(2)-1) * .1, (randomfloat(2)-1) * .1);
		pos = weaporig + vectorScale(dir, 1000);
		
		self shootWrapper( pos );
	}
	
	self.bulletsInClip--;
}


getPredictedAimYawToShootEntOrPos(time)
{
	if ( !isdefined( self.shootEnt ) )
	{
		if ( !isdefined( self.shootPos ) )
			return 0;
		
		return getAimYawToPoint( self.shootPos );
	}
	
	predictedPos = self.shootEnt.origin + vectorScale( self.shootEntVelocity, time );
	return getAimYawToPoint( predictedPos );
}

getAimYawToShootEntOrPos()
{
	// make use of the fact that shootPos = shootEnt getShootAtPos() if shootEnt is defined
	if ( !isdefined( self.shootEnt ) )
	{
		if ( !isdefined( self.shootPos ) )
			return 0;
		
		return getAimYawToPoint( self.shootPos );
	}
	
	return getAimYawToPoint( self.shootEnt getShootAtPos() );
}

getAimPitchToShootEntOrPos()
{
	pitch = getPitchToShootEntOrPos();
	if ( self.a.script == "cover_crouch" && isdefined( self.a.coverMode ) && self.a.coverMode == "lean" )
		pitch -= anim.coverCrouchLeanPitch;
	return pitch;
}

getPitchToShootEntOrPos()
{
	if ( !isdefined( self.shootEnt ) )
	{
		// make use of the fact that shootPos = shootEnt getShootAtPos() if shootEnt is defined
		if ( !isdefined( self.shootPos ) )
			return 0;
		
		return animscripts\combat_utility::getPitchToSpot( self.shootPos );
	}
	
	return animscripts\combat_utility::getPitchToSpot( self.shootEnt getShootAtPos() );
}

getAimYawToPoint(point)
{
	yaw = GetYawToSpot(point);

	// need to have fudge factor because the gun's origin is different than our origin,
	// the closer our distance, the more we need to fudge. 
	dist = distance(self.origin,point);
	if(dist > 3)
	{
		angleFudge = asin(-3/dist);
		yaw += angleFudge; 
	}
	yaw = AngleClamp( yaw, "-180 to 180" );
	return yaw;
}

trackShootEntOrPos()
{
	self endon("killanimscript");
	self endon("stop tracking");
	self endon("melee");
	
	deltaChangePerFrame = 5;
	
	aimBlendTime = .05;
	
	prevYawDelta = 0;
	prevPitchDelta = 0;
	maxYawDeltaChange = 5; // max change in yaw in 1 frame
	maxPitchDeltaChange = 5;
	
	for(;;)
	{
		incrAnimAimWeight();
		
		if ( !isdefined( self.shootPos ) )
		{
			assert( !isdefined( self.shootEnt ) );
			wait(0.05);
			continue;
		}
		yawDelta = getAimYawToShootEntOrPos();
		pitchDelta = getAimPitchToShootEntOrPos();
		
		if ( yawDelta > self.rightAimLimit )
			yawDelta = self.rightAimLimit;
		else if ( yawDelta < self.leftAimLimit )
			yawDelta = self.leftAimLimit;
		if ( pitchDelta > self.upAimLimit )
			pitchDelta = self.upAimLimit;
		else if ( pitchDelta < self.downAimLimit )
			pitchDelta = self.downAimLimit;
		
		
		yawDeltaChange = yawDelta - prevYawDelta;
		if ( abs( yawDeltaChange ) > maxYawDeltaChange )
			yawDelta = prevYawDelta + maxYawDeltaChange * sign( yawDeltaChange );
		
		pitchDeltaChange = pitchDelta - prevPitchDelta;
		if ( abs( pitchDeltaChange ) > maxPitchDeltaChange )
			pitchDelta = prevPitchDelta + maxPitchDeltaChange * sign( pitchDeltaChange );
		
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		
		
		if ( yawDelta > 0 )
		{
			assert( yawDelta <= self.rightAimLimit );
			self setanimlimited( %aim_4, 0, aimBlendTime );
			weight = yawDelta / self.rightAimLimit * self.a.aimweight;
			self setanimlimited( %aim_6, weight, aimBlendTime );
		}
		if ( yawDelta < 0 )
		{
			assert( yawDelta >= self.leftAimLimit );
			self setanimlimited( %aim_6, 0, aimBlendTime );
			weight = yawDelta / self.leftAimLimit * self.a.aimweight;
			self setanimlimited( %aim_4, weight, aimBlendTime );
		}
		
		if ( pitchDelta > 0 )
		{
			assert( pitchDelta <= self.upAimLimit );
			self setanimlimited( %aim_2, 0, aimBlendTime );			
			weight = pitchDelta / self.upAimLimit * self.a.aimweight;
			self setanimlimited( %aim_8, weight, aimBlendTime );
		}
		if ( pitchDelta < 0 )
		{
			assert( pitchDelta >= self.downAimLimit );
			self setanimlimited( %aim_8, 0, aimBlendTime );
			weight = pitchDelta / self.downAimLimit * self.a.aimweight;
			self setanimlimited( %aim_2, weight, aimBlendTime );
		}
		
		wait( 0.05 );
	}
}

//setAnimAimWeight works just like setanimlimited on an imaginary anim node that affects the four aiming directions.
setAnimAimWeight(goalweight, goaltime)
{
	if ( !isdefined( goaltime ) || goaltime <= 0 )
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = goalweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = 0;
	}
	else
	{
		self.a.aimweight_start = self.a.aimweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = int(goaltime * 20);
	}
	self.a.aimweight_t = 0;
}
incrAnimAimWeight()
{
	if ( self.a.aimweight_t < self.a.aimweight_transframes )
	{
		self.a.aimweight_t++;
		t = 1.0 * self.a.aimweight_t / self.a.aimweight_transframes;
		self.a.aimweight = self.a.aimweight_start * (1 - t) + self.a.aimweight_end * t;
	}
}

// decides on the number of shots to do in a burst.
decideNumShots()
{
	if ( self.bulletsInClip <= 5 )
	{
		assertex( self.bulletsInClip >= 0, self.bulletsInClip );
		
		if ( self.bulletsInClip == 0 )
			return 1;
		
		return self.bulletsInClip;
	}
	else if ( animscripts\weaponList::usingSemiAutoWeapon() )
	{
		return anim.semiFireNumShots[ randomint( anim.semiFireNumShots.size ) ];		
	}
	else if ( weaponClass( self.weapon ) == "mg" )
	{
		return anim.autoFireNumShots[ randomint( anim.autoFireNumShots.size ) ];
	}
	else
	{
		return anim.burstFireNumShots[ randomint( anim.burstFireNumShots.size ) ];
	}
}

handleDropClip( flagName )
{
	self endon ( "killanimscript" );

	clipModel = getWeaponClipModel( self.weapon );

	if ( self.weaponInfo[self.weapon].hasClip )
	{
		self detach( clipModel, "tag_clip" );

		if ( isDefined( anim._effect[clipModel] ) )
			playFxOnTag( anim._effect[clipModel], self, "tag_clip" );
	
		self.weaponInfo[self.weapon].hasClip = false;
	}
	
	self thread resetClipOnAbort( clipModel );
	
	for ( ;; )
	{
		self waittill( flagName, noteTrack );
		
		switch ( noteTrack )
		{
 		case "attach clip left":
			self attach( clipModel, "tag_inhand" );
			self thread resetClipOnAbort( clipModel, "tag_inhand" );
 			break;
//		case "end":
//		case "finish":
//		case "undefined":
 		case "detach clip left":
 			self detach( clipModel, "tag_inhand" );
			self attach( clipModel, "tag_clip" );
			self.weaponInfo[self.weapon].hasClip = true;
 			self notify ( "clip_detached" );
 			return;
		}
	}
}


resetClipOnAbort( clipModel, currentTag )
{
	self notify ( "clip_detached" );
	self endon ( "clip_detached" );
	self endon ( "death" );

	self maps\_utility::waittill_any( "killanimscript", "abort_reload" );

	if ( isDefined( currentTag ) )
		self detach( clipModel, currentTag );
	
	self attach( clipModel, "tag_clip" );
	self.weaponInfo[self.weapon].hasClip = true;
}


moveToOriginOverTime( origin, time )
{
	self endon("killanimscript");
	
	if ( distanceSquared( self.origin, origin ) > 16*16 && !self mayMoveToPoint( origin ) )
	{
		/# println("^1Warning: AI starting behavior for node at " + origin + " but could not move to that point."); #/
		return;
	}
	
	self.keepClaimedNodeInGoal = true;
	
	offset = self.origin - origin;
	
	frames = int(time * 20);
	offsetreduction = vectorScale( offset, 1.0 / frames );
	
	for ( i = 0; i < frames; i++ )
	{
		offset -= offsetreduction;
		self teleport( origin + offset );
		wait .05;
	}
	
	self.keepClaimedNodeInGoal = false;
}

returnTrue() { return true; }

playLookAnimation( lookAnim, lookTime, canStopCallback )
{
	if ( !isdefined( canStopCallback ) )
		canStopCallback = ::returnTrue;
	
	for ( i = 0; i < lookTime * 10; i++ )
	{
		// Break out if you saw somebody lately
		if ( isalive( self.enemy ) )
		{
			if ( self canSeeEnemy() && [[ canStopCallback ]]() )
				return;
		}
		if ( self isSuppressedWrapper() && [[ canStopCallback ]]() )
			return;
		
		self setAnimKnobAll( lookAnim, %body, 1, .1 );
		wait (0.1);
	}
}


