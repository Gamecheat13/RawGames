



#include maps\_utility;
#include animscripts\utility;

#include common_scripts\utility;

#using_animtree ("generic_human");

placeWeaponOn( weapon, position )
{	
	
	assert( AIHasWeapon( weapon ) );
	
	self notify("weapon_position_change");
	
	curPosition = self.weaponInfo[weapon].position;
	
	
	assert( curPosition == "none" || self.a.weaponPos[curPosition] == weapon );
	
	
	if ( position != "none" && self.a.weaponPos[position] == weapon )
		return;
	
	self detachAllWeaponModels();
	
	
	if ( curPosition != "none" )
		self detachWeapon( weapon );
		
	
	if ( position == "none" )
	{
		self updateAttachedWeaponModels();
		return;
	}

	if ( self.a.weaponPos[position] != "none" )
		self detachWeapon( self.a.weaponPos[position] );

	
	if ( position == "left" || position == "right" )
	{
		self attachWeapon( weapon, position );
		self.weapon = weapon;
	}
	else
	{
		self attachWeapon( weapon, position );
	}

	self updateAttachedWeaponModels();
	
	
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

detachAllWeaponModels()
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
			
		self detachweaponfroment( weapon );
	}	
}

updateAttachedWeaponModels()
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
		
		
		self attachweapontoent( weapon );

		if ( self.weaponInfo[weapon].useClip && !self.weaponInfo[weapon].hasClip )
			self hidepart( "tag_clip" );
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


SetAiWeapon(weapon)
{
	
	weaponPos = self.weaponInfo[self.weapon].position;

	
	if( GetWeaponModel(weapon) != "" )
	{
		self.weapon = weapon;
		self animscripts\init::initWeapon( self.weapon, 0 );
		self animscripts\shared::placeWeaponOn( self.weapon, weaponPos );
	}
	else
	{
		assertMsg( "Can't set weapon to " + weapon + " because it hasn't been precached." );
	}
}



DropAIWeapon()
{
	if ( self.weapon == "none" )
		return;
	
	position = self.weaponInfo[ self.weapon ].position;
	
	if ( getdvarint( "scr_physWeaponDrop" ) != 0 )
	{
		self dropPhysWeapon();
		self.weapon = "none";
		return;
	}
	
	if( self.dropWeapon )
	{
		self DropWeapon( self.weapon, position, 0 );
	}
	animscripts\shared::placeWeaponOn( self.weapon, "none" );
	self.weapon = "none";
}


DropAllAIWeapons()
{
	positions = [];
	positions[positions.size] = "left";
	positions[positions.size] = "right";
	positions[positions.size] = "chest";
	positions[positions.size] = "back";
	
	self detachAllWeaponModels();
	
	for ( index = 0; index < positions.size; index++ )
	{
		weapon = self.a.weaponPos[ positions[ index ] ];
		
		if ( weapon == "none" )
			continue;

		self.weaponInfo[ weapon ].position = "none";
		self.a.weaponPos[ positions[ index ] ] = "none";

		if ( getdvarint( "scr_physWeaponDrop" ) != 0 )
		{
			self dropPhysWeapon( positions[index] );
		}
		else 
		{
			self DropWeapon( weapon, positions[ index ], 0 );
		}	
	}
	
	self.weapon = "none";
}


dropPhysWeapon( pos )
{
	tagName = self getTagForPos( pos ); 
	tagOrigin = self getTagOrigin( tagName );
	tagAngles = self getTagAngles( tagName );
	
	physWeapon = spawn( "script_model", tagOrigin );
	physWeapon.angles = tagAngles;
	physWeapon setModel( getWeaponModel( self.a.weaponPos[pos] ) );
	physWeapon thread addPhysWeapon();
	
	animscripts\shared::placeWeaponOn( self.a.weaponPos[pos], "none" );
	
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

}

LookAtPosition(lookTargetPos, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	assertEX(isAI(self), "Can only call this function on an AI character");											
	assertEX(self.a.targetLookInitilized == true, "LookAtPosition called on AI that lookThread was not called on");	
	assertEX( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");					
	
	if ( !isDefined(interruptOthers) || (interruptOthers=="interrupt others") || (GetTime() > self.a.lookEndTime) )
	{
		self.a.lookTargetPos = lookTargetPos;
		self.a.lookEndTime = GetTime() + (lookDuration*1000);
		if(lookSpeed == "casual")
			self.a.lookTargetSpeed = 800;
		else 
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


}

LookAtAnimations(leftanim, rightanim)
{
	self.a.LookAnimationLeft = leftanim;
	self.a.LookAnimationRight = rightanim;
}


/#
showNoteTrack( note )
{
	if ( getdebugdvar("scr_shownotetracks") != "on" && getdebugdvarint("scr_shownotetracks") != self getentnum() )
		return;
	
	self endon("death");
	
	anim.showNotetrackSpeed = 30; 
	anim.showNotetrackDuration = 30; 
	
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

HandleDogSoundNoteTracks( note )
{
	if ( note == "sound_dogstep_run_default" )
	{
		self playsound( "dogstep_run_default" );
		return true;
	}

	prefix = getsubstr( note, 0, 5 );

	if ( prefix == "sound" )
	{
		self thread play_sound_in_space( "anml" + getsubstr( note, 5 ), self gettagorigin( "tag_eye" ) );
		return true;
	}
	return false;
}


registerNoteTracks()
{
	anim.notetracks["anim_pose = \"stand\""] = ::noteTrackPoseStand;
	anim.notetracks["anim_pose = \"crouch\""] = ::noteTrackPoseCrouch;
	anim.notetracks["anim_pose = \"prone\""] = ::noteTrackPoseProne;
	anim.notetracks["anim_pose = \"crawl\""] = ::noteTrackPoseCrawl;
	anim.notetracks["anim_pose = \"back\""] = ::noteTrackPoseBack;

	anim.notetracks["anim_movement = \"stop\""] = ::noteTrackMovementStop;
	anim.notetracks["anim_movement = \"walk\""] = ::noteTrackMovementWalk;
	anim.notetracks["anim_movement = \"run\""] = ::noteTrackMovementRun;

	anim.notetracks["anim_aiming = 1"] = ::noteTrackAlertnessAiming;
	anim.notetracks["anim_aiming = 0"] = ::noteTrackAlertnessAlert;
	anim.notetracks["anim_alertness = causal"] = ::noteTrackAlertnessCasual;
	anim.notetracks["anim_alertness = alert"] = ::noteTrackAlertnessAlert;
	anim.notetracks["anim_alertness = aiming"] = ::noteTrackAlertnessAiming;
	
	anim.notetracks["gunhand = (gunhand)_left"] = ::noteTrackGunhand;
	anim.notetracks["anim_gunhand = \"left\""] = ::noteTrackGunhand;
	anim.notetracks["gunhand = (gunhand)_right"] = ::noteTrackGunhand;
	anim.notetracks["anim_gunhand = \"right\""] = ::noteTrackGunhand;	
	anim.notetracks["anim_gunhand = \"none\""] = ::noteTrackGunhand;	
	anim.notetracks["gun drop"] = ::noteTrackGunDrop;
	anim.notetracks["dropgun"] = ::noteTrackGunDrop;

	anim.notetracks["gun_2_chest"] = ::noteTrackGunToChest;	
	anim.notetracks["gun_2_back"] = ::noteTrackGunToBack;	
	anim.notetracks["pistol_pickup"] = ::noteTrackPistolPickup;
	anim.notetracks["pistol_putaway"] = ::noteTrackPistolPutaway;
	anim.notetracks["drop clip"] = ::noteTrackDropClip;
	anim.notetracks["refill clip"] = ::noteTrackRefillClip;
	anim.notetracks["load_shell"] = ::noteTrackLoadShell;
	
	anim.notetracks["gravity on"] = ::noteTrackGravity;
	anim.notetracks["gravity off"] = ::noteTrackGravity;

	anim.notetracks["bodyfall large"] = ::noteTrackBodyFall;
	anim.notetracks["bodyfall small"] = ::noteTrackBodyFall;
	
	anim.notetracks["footstep"] = ::noteTrackFootStep;
	anim.notetracks["step"] = ::noteTrackFootStep;
	anim.notetracks["footstep_right_large"] = ::noteTrackFootStep;
	anim.notetracks["footstep_right_small"] = ::noteTrackFootStep;
	anim.notetracks["footstep_left_large"] = ::noteTrackFootStep;
	anim.notetracks["footstep_left_small"] = ::noteTrackFootStep;
	anim.notetracks["footscrape"] = ::noteTrackFootScrape;
	anim.notetracks["land"] = ::noteTrackLand;
	
	anim.notetracks["start_ragdoll"] = ::noteTrackStartRagdoll;
	
	
	anim.notetracks["fov_65"] = ::noteTrackFov_65;
	anim.notetracks["fov_60"] = ::noteTrackFov_60;
	anim.notetracks["fov_55"] = ::noteTrackFov_55;
	anim.notetracks["fov_50"] = ::noteTrackFov_50;
	anim.notetracks["fov_45"] = ::noteTrackFov_45;
	anim.notetracks["fov_40"] = ::noteTrackFov_40;
	anim.notetracks["fov_35"] = ::noteTrackFov_35;
	anim.notetracks["fov_30"] = ::noteTrackFov_30;
}






noteTrackFov_65( note, flagName )
{
	fov_transition( 65 );
}





noteTrackFov_60( note, flagName )
{
	fov_transition( 60 );
}





noteTrackFov_55( note, flagName )
{
	fov_transition( 55 );
}





noteTrackFov_50( note, flagName )
{
	fov_transition( 50 );
}





noteTrackFov_45( note, flagName )
{
	fov_transition( 45 );
}





noteTrackFov_40( note, flagName )
{
	fov_transition( 40 );
}






noteTrackFov_35( note, flagName )
{
	fov_transition( 35 );
}





noteTrackFov_30( note, flagName )
{
	fov_transition( 30 );
}

handleFOVchange(str, val)
{
	for(;;)
	{
		self waittillmatch("anim_notetrack", str);
		fov_transition(val);		
	}	
}

handleFovMovement(str, val)
{
	for(;;)
	{
		self waittillmatch("anim_notetrack", str);
		fov_movement( val );
	}	
}

handleFovNotes( )
{
	if( level.handleFovNotesSetup )
		return;
	level.handleFovNotesSetup = true;
	self thread handleFOVchange("fov_15", 15);
	self thread handleFOVchange("fov_20", 20);
	self thread handleFOVchange("fov_25", 25);
	self thread handleFOVchange("fov_30", 30);
	self thread handleFOVchange("fov_35", 35);
	self thread handleFOVchange("fov_40", 40);
	self thread handleFOVchange("fov_45", 45);
	self thread handleFOVchange("fov_50", 50);
	self thread handleFOVchange("fov_55", 55);
	self thread handleFOVchange("fov_60", 60);
	self thread handleFOVchange("fov_65", 65);
	self thread handleFOVchange("fov_70", 70);
	self thread handleFOVchange("fov_75", 75);
	self thread handleFOVchange("fov_80", 80);
	self thread handleFOVchange("fov_85", 85);
	self thread handleFOVchange("fov_90", 90);
	self thread handleFOVchange("fov_95", 95);
	self thread handleFOVchange("fov_100", 100);
	self thread handleFOVchange("fov_105", 105);
	
	self thread handleFOVMovement("fov_zoom", 0);		
	self thread handleFOVMovement("fov_cut", 1);		
}






noteTrackStopAnim( note, flagName )
{
}

noteTrackStartRagdoll( note, flagName )
{
	self startRagdoll();
}

noteTrackMovementStop( note, flagName )
{
	self.a.movement = "stop";
}

noteTrackMovementWalk( note, flagName )
{
	self.a.movement = "walk";
}

noteTrackMovementRun( note, flagName )
{
	self.a.movement = "run";
}


noteTrackAlertnessAiming( note, flagName )
{
	self.a.alertness = "aiming";
}

noteTrackAlertnessCasual( note, flagName )
{
	self.a.alertness = "casual";
}

noteTrackAlertnessAlert( note, flagName )
{
	self.a.alertness = "alert";
}


noteTrackPoseStand( note, flagName )
{








}

noteTrackPoseCrouch( note, flagName )
{














}

noteTrackPoseProne( note, flagName )
{




}


noteTrackPoseCrawl( note, flagName )
{




}


noteTrackPoseBack( note, flagName )
{








}


noteTrackGunHand( note, flagName )
{






}


noteTrackGunDrop( note, flagName )
{








}


noteTrackGunToChest( note, flagName )
{




}


noteTrackGunToBack( note, flagName )
{




}


noteTrackPistolPickup( note, flagName )
{



}

	
noteTrackPistolPutaway( note, flagName )
{




}

	
noteTrackDropClip( note, flagName )
{


}


noteTrackRefillClip( note, flagName )
{

}

noteTrackLoadShell( note, flagName )
{

}

noteTrackGravity( note, flagName )
{
	if ( isSubStr( note, "on" ) )
        self animMode( "gravity" );
	else if ( isSubStr( note, "off" ) )
		self animMode( "nogravity" );
}


noteTrackBodyFall( note, flagName )
{
	if ( isDefined( self.groundType ) )
		groundType = self.groundType;
	else
		groundType = "dirt";
		
	if ( isSubStr( note, "large" ) )
		self playsound ("bodyfall_" + groundType + "_large");
	else if ( isSubStr( note, "small" ) )
		self playsound ("bodyfall_" + groundType + "_small");
}


noteTrackFootStep( note, flagName )
{
	if ( isSubStr( note, "left" ) )
		playFootStep( "L_Toe" );
	else
		playFootStep( "R_Toe" );
	
	self playSound( "gear_rattle_run" );		
}


noteTrackFootScrape( note, flagName )
{
	if ( isDefined( self.groundType ) )
		groundType = self.groundType;
	else
		groundType = "dirt";
		
	self playsound ("step_scrape_" + groundType );
}

	
noteTrackLand( note, flagName )
{
	if ( isDefined( self.groundType ) )
		groundType = self.groundType;
	else
		groundType = "dirt";
		
	self playsound ("land_" + groundType );
}		



HandleNoteTrack( note, flagName, customFunction )
{
	/#
	self thread showNoteTrack( note );
	#/
	
	if ( isAI( self ) && self.type == "dog" )
		if ( HandleDogSoundNoteTracks( note ) )
			return;
	
	if ( isDefined( anim.notetracks[note] ) )
	{
		return [[anim.notetracks[note]]]( note, flagName );
	}
	
	switch ( note )
	{
	case "end":
	case "finish":
	case "undefined":
		if ( isAI(self) && self.a.pose=="back" ) 
		{
			

		}

		prof_end("DoNoteTracks");
		return note;


	case "swish small":
		self thread play_sound_in_space ("melee_swing_small", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;

	case "swish large":
		self thread play_sound_in_space ("melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		
		break;


	case "rechamber":
		if ( self usingShotgun() )
			self playSound("ai_shotgun_pump");
		self.a.needsToRechamber = 0;
		break;
	case "reload done":
		self animscripts\weaponList::RefillClip();
		self.a.needsToRechamber = 0;
		break;
	case "fire":
		if ( !isdefined( anim.fire_notetrack_functions[ self.a.script ] ) )
			thread [[ animscripts\shared::shootNotetrack ]]();
		else
			thread [[ anim.fire_notetrack_functions[ self.a.script ] ]]();
		break;
	case "no death":
		
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
	case "weapon_retrieve":
	
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
		self notify( "single anim", "end" );
		return note;

	default:
		if (isDefined(customFunction))
			return [[customFunction]] (note);
		break;
	}
}






DoNoteTracks( flagName, customFunction, debugIdentifier ) 
{
	prof_begin("DoNoteTracks");

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


DoNoteTracksIntercept( flagName, interceptFunction, debugIdentifier ) 
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


DoNoteTracksForever(flagName, killString, customFunction, debugIdentifier)
{
	DoNoteTracksForeverProc( ::DoNoteTracks, flagName, killString, customFunction, debugIdentifier);
}

DoNoteTracksForeverIntercept(flagName, killString, interceptFunction, debugIdentifier)
{
	DoNoteTracksForeverProc( ::DoNoteTracksIntercept, flagName, killString, interceptFunction, debugIdentifier );
}

DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, debugIdentifier )
{
	if (isdefined (killString))
		self endon (killString);
	self endon ("killanimscript");
	if (!isDefined(debugIdentifier))
		debugIdentifier = "undefined";

	for (;;)
	{
		time = GetTime();
		returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
				println (GetTime()+" "+debugIdentifier+" animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
				wait ( 0.05 - timetaken );
			}
		}
		
	}
}


DoNoteTracksForTime(time, flagName, customFunction, debugIdentifier)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForever, time, flagName, customFunction, debugIdentifier, ent);
}

DoNoteTracksForTimeIntercept( time, flagName, interceptFunction, debugIdentifier)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForeverIntercept, time, flagName, interceptFunction, debugIdentifier, ent);
}

DoNoteTracksForTimeProc( doNoteTracksForeverFunc, time, flagName, customFunction, debugIdentifier, ent)
{
	ent endon ("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, debugIdentifier);
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








}

fire_straight()
{

















}

sprayNotetrack()
{
































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










}

getAimYawToPoint(point)
{
	yaw = GetYawToSpot(point);

	
	
	dist = distance(self.origin,point);
	if(dist > 3)
	{
		angleFudge = asin(-3/dist);
		yaw += angleFudge; 
	}
	yaw = AngleClamp180( yaw );
	return yaw;
}

trackShootEntOrPos()
{
	self endon("killanimscript");
	self endon("stop tracking");
	self endon("melee");

	trackLoop( %aim_2, %aim_4, %aim_6, %aim_8 );
}

trackLoop( aim2, aim4, aim6, aim8 )
{
	prof_begin("trackLoop");
	
	deltaChangePerFrame = 5;
	
	aimBlendTime = .05;
	
	prevYawDelta = 0;
	prevPitchDelta = 0;
	maxYawDeltaChange = 5; 
	maxPitchDeltaChange = 5;
	
	pitchAdd = 0;
	yawAdd = 0;
	if ( self.a.script == "cover_crouch" && isdefined( self.a.coverMode ) && self.a.coverMode == "lean" )
		pitchAdd = -1 * anim.coverCrouchLeanPitch;
	if ( (self.a.script == "cover_left" || self.a.script == "cover_right") && isdefined( self.a.cornerMode ) && self.a.cornerMode == "lean" )
		yawAdd = self.coverNode.angles[1] - self.angles[1];
	
	yawDelta = 0;
	pitchDelta = 0;
	
	firstFrame = true;
	
	for(;;)
	{
		incrAnimAimWeight();
		
		selfShootAtPos = (self.origin[0], self.origin[1], self getEye()[2]);

		shootPos = self.shootPos;
		if ( isdefined( self.shootEnt ) )
			shootPos = self.shootEnt getShootAtPos();

		if ( !isdefined( shootPos ) && self animscripts\move::shouldCQB() )
		{
			selfForward = anglesToForward( self.angles );
			if ( isdefined( self.cqb_target ) )
			{
				shootPos = self.cqb_target getShootAtPos();
				if ( vectorDot( vectorNormalize( shootPos - selfShootAtPos ), selfForward ) < 0.643 ) 
					shootPos = undefined;
			}
			if ( !isdefined( shootPos ) && isdefined( self.cqb_point_of_interest ) )
			{
				shootPos = self.cqb_point_of_interest;
				if ( vectorDot( vectorNormalize( shootPos - selfShootAtPos ), selfForward ) < 0.643 ) 
					shootPos = undefined;
			}
		}
		
		if ( !isdefined( shootPos ) )
		{
			assert( !isdefined( self.shootEnt ) );
			
			if ( isdefined( self.node ) && self.node.type == "Guard" && distanceSquared(self.origin, self.node.origin) < 16 )
			{
				yawDelta = AngleClamp180( self.angles[1] - self.node.angles[1] );
				pitchDelta = 0;
			}
			else
			{
				likelyEnemyDir = self getAnglesToLikelyEnemyPath();
				if ( isdefined( likelyEnemyDir ) )
				{
					yawDelta = AngleClamp180( self.angles[1] - likelyEnemyDir[1] );
					pitchDelta = AngleClamp180( 360 - likelyEnemyDir[0] );
				}
				else
				{
					yawDelta = 0;
					pitchDelta = 0;
				}
			}
		}
		else
		{
			vectorToShootPos = shootPos - selfShootAtPos;
			anglesToShootPos = vectorToAngles( vectorToShootPos );
			
			pitchDelta = 360 - anglesToShootPos[0];
			pitchDelta = AngleClamp180( pitchDelta + pitchAdd );
			
			yawDelta = self.angles[1] - anglesToShootPos[1];
			
			yawDelta = AngleClamp180( yawDelta + yawAdd );
		}
		
		if ( abs( yawDelta ) > 60 || abs( pitchDelta ) > 60 )
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else
		{
			if ( yawDelta > self.rightAimLimit )
				yawDelta = self.rightAimLimit;
			else if ( yawDelta < self.leftAimLimit )
				yawDelta = self.leftAimLimit;
			if ( pitchDelta > self.upAimLimit )
				pitchDelta = self.upAimLimit;
			else if ( pitchDelta < self.downAimLimit )
				pitchDelta = self.downAimLimit;
		}
		
		if ( firstFrame )
		{
			firstFrame = false;
		}
		else
		{
			yawDeltaChange = yawDelta - prevYawDelta;
			if ( abs( yawDeltaChange ) > maxYawDeltaChange )
				yawDelta = prevYawDelta + maxYawDeltaChange * sign( yawDeltaChange );
			
			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if ( abs( pitchDeltaChange ) > maxPitchDeltaChange )
				pitchDelta = prevPitchDelta + maxPitchDeltaChange * sign( pitchDeltaChange );
		}
		
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		
		if ( yawDelta > 0 )
		{
			assert( yawDelta <= self.rightAimLimit );
			weight = yawDelta / self.rightAimLimit * self.a.aimweight;
			self setAnimLimited( aim4, 0, aimBlendTime );
			self setAnimLimited( aim6, weight, aimBlendTime );
		}
		else if ( yawDelta < 0 )
		{
			assert( yawDelta >= self.leftAimLimit );
			weight = yawDelta / self.leftAimLimit * self.a.aimweight;
			self setAnimLimited( aim6, 0, aimBlendTime );
			self setAnimLimited( aim4, weight, aimBlendTime );
		}
		
		if ( pitchDelta > 0 )
		{
			assert( pitchDelta <= self.upAimLimit );
			weight = pitchDelta / self.upAimLimit * self.a.aimweight;
			self setAnimLimited( aim2, 0, aimBlendTime );			
			self setAnimLimited( aim8, weight, aimBlendTime );
		}
		else if ( pitchDelta < 0 )
		{
			assert( pitchDelta >= self.downAimLimit );
			weight = pitchDelta / self.downAimLimit * self.a.aimweight;
			self setAnimLimited( aim8, 0, aimBlendTime );
			self setAnimLimited( aim2, weight, aimBlendTime );
		}
		
		wait( 0.05 );
	}
	
	prof_end("trackLoop");
}


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


decideNumShotsForBurst()
{
	numShots = 0;
	if ( animscripts\weaponList::usingSemiAutoWeapon() )
		numShots = anim.semiFireNumShots[ randomint( anim.semiFireNumShots.size ) ];
	else if ( self.fastBurst )
		numShots = anim.fastBurstFireNumShots[ randomint( anim.fastBurstFireNumShots.size ) ];
	else
		numShots = anim.burstFireNumShots[ randomint( anim.burstFireNumShots.size ) ];

	if ( numShots <= self.bulletsInClip )
		return numShots;
	
	assertex( self.bulletsInClip >= 0, self.bulletsInClip );
	
	if ( self.bulletsInClip <= 0 )
		return 1;
	
	return self.bulletsInClip;
}

decideNumShotsForFull()
{
	numShots = self.bulletsInClip;
	if ( weaponClass( self.weapon ) == "mg" )
	{
		choice = randomfloat(10);
		if ( choice < 3 )
			numShots = randomIntRange( 2, 6 );
		else if ( choice < 8 )
			numShots = randomIntRange( 6, 12 );
		else
			numShots = randomIntRange( 12, 20 );
	}
	
	return numShots;
}

handleDropClip( flagName )
{
	self endon ( "killanimscript" );
	self endon ( "abort_reload" );

	clipModel = getWeaponClipModel( self.weapon );

	if ( self.weaponInfo[self.weapon].hasClip )
	{
		self hidepart( "tag_clip" );
		self playsound( "clip_out" );	

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
 		case "attach clip right":
			self attach( clipModel, "tag_inhand" );
			self hidepart( "tag_clip" );
			self thread resetClipOnAbort( clipModel, "tag_inhand" );
 			break;



 		case "detach clip right":
 		case "detach clip left":
 			self detach( clipModel, "tag_inhand" );

			self playsound( "clip_in" );	
			self showpart( "tag_clip" );
			self.weaponInfo[self.weapon].hasClip = true;
 			self notify ( "clip_detached" );
 			
 			
			self animscripts\weaponList::RefillClip();
			self.a.needsToRechamber = 0;
 			
 			return;
		}
	}
}


resetClipOnAbort( clipModel, currentTag )
{
	self notify ( "clip_detached" );
	self endon ( "clip_detached" );
	self endon ( "death" );

	self waittill_any( "killanimscript", "abort_reload" );

	if ( isDefined( currentTag ) )
		self detach( clipModel, currentTag );
	
	self showpart( "tag_clip" );
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


throwDownWeapon( swapAnim )
{










}


setupCQBPointsOfInterest()
{
	level.cqbPointsOfInterest = [];
	pointents = getEntArray( "cqb_point_of_interest", "targetname" );
	for ( i = 0; i < pointents.size; i++ )
	{
		level.cqbPointsOfInterest[i] = pointents[i].origin;
		pointents[i] delete();
	}
}

findCQBPointsOfInterest()
{
	if ( isdefined( anim.findingCQBPointsOfInterest ) )
		return;
	anim.findingCQBPointsOfInterest = true;
	
	
	if ( !level.cqbPointsOfInterest.size )
		return;
	
	while(1)
	{
		ai = getaiarray();
		waited = false;
		for ( i = 0; i < ai.size; i++ )
		{
			if ( isAlive( ai[i] ) && ai[i] isCQBWalking() )
			{
				moving = ( ai[i].a.movement != "stop" );
				
				forward = anglesToForward( ai[i].angles );
				shootAtPos = ai[i] getShootAtPos();
				lookAheadPoint = shootAtPos;
				if ( moving )
					lookAheadPoint += forward * 128;
				
				best = -1;
				bestdist = 1024*1024;
				for ( j = 0; j < level.cqbPointsOfInterest.size; j++ )
				{
					point = level.cqbPointsOfInterest[j];
					
					dist = distanceSquared( point, lookAheadPoint );
					if ( dist < bestdist )
					{
						if ( moving && vectorDot( vectorNormalize(point - shootAtPos), forward ) < 0.643 ) 
							continue;
						
						bestdist = dist;
						best = j;
					}
				}
				
				if ( best < 0 )
					ai[i].cqb_point_of_interest = undefined;
				else
					ai[i].cqb_point_of_interest = level.cqbPointsOfInterest[best];
				
				wait .05;
				waited = true;
			}
		}
		if ( !waited )
			wait .25;
	}
}

/#
CQBDebug()
{
	self notify("end_cqb_debug");
	self endon("end_cqb_debug");
	
	if ( getdvar("scr_cqbdebug") == "" )
		setdvar("scr_cqbdebug", "off");
	if ( getdvar("scr_cqbdebug") != "on" && getdvarint("scr_cqbdebug") != self getentnum() )
		return;
	
	while(1)
	{
		if ( isdefined( self.cqb_target ) )
		{
			line( self getShootAtPos(), self.cqb_target.origin, (.5,1,.5) );
			print3d( self.cqb_target.origin, "cqb_target" );
		}
		if ( isdefined( self.cqb_point_of_interest ) )
		{
			line( self getShootAtPos(), self.cqb_point_of_interest, (1,.5,.5) );
			print3d( self.cqb_point_of_interest, "cqb_point_of_interest" );
		}
		
		wait .05;
	}
}
#/
