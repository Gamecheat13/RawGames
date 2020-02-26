// Shared.gsc - Functions that are shared between animscripts and level scripts.  
// Functions in this file can't rely on the maps\mp\animscripts\zm_init function having run, and can't call any 
// functions not allowed in level scripts.
// 
// #include maps\_utility;
// #include maps\mp\animscripts\zm_utility;
// #include animscripts\combat_utility;
// #include common_scripts\utility;

#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;

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
	assert(isAI(self), "Can only call this function on an AI character");											
	assert(self.a.targetLookInitilized == true, "LookAtPosition called on AI that lookThread was not called on");	
	assert( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");					
	
	// If interruptOthers is true, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to true.
	if ( !IsDefined(interruptOthers) || (interruptOthers=="interrupt others") || (GetTime() > self.a.lookEndTime) )
	{
		self.a.lookTargetPos = lookTargetPos;
		self.a.lookEndTime = GetTime() + (lookDuration*1000);

		if(lookSpeed == "casual")
		{
			self.a.lookTargetSpeed = 800;
		}
		else // alert
		{
			self.a.lookTargetSpeed = 1600;
		}

		if ( IsDefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}
}

LookAtAnimations(leftanim, rightanim)
{
	self.a.LookAnimationLeft = leftanim;
	self.a.LookAnimationRight = rightanim;
}

/#
showNoteTrack( note )
{
/* t6todo
	if ( GetDebugDvar("scr_shownotetracks") != "on" && getdebugdvarint("scr_shownotetracks") != self getentnum() )
	{
		return;
	}
	
	self endon("death");
	
	anim.showNotetrackSpeed = 30; // units/sec
	anim.showNotetrackDuration = 30; // frames
	
	if ( !IsDefined( self.a.shownotetrackoffset ) )
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
	{
		color = (.25,.4,.5);
	}
	else if ( note == "undefined" )
	{
		color = (1,.5,.5);
	}
	
	for ( i = 0; i < duration; i++ )
	{
		if ( duration - i <= anim.showNotetrackDuration )
		{
			amnt = 1.0 * (i - (duration - anim.showNotetrackDuration)) / anim.showNotetrackDuration;
		}
		else
		{
			amnt = 0.0;
		}

		time = 1.0 * i / 20;
		
		alpha = 1.0 - amnt*amnt;
		pos = self geteye() + (0, 0, 20 + anim.showNotetrackSpeed * time - thisoffset);
		
		Print3d( pos, note, color, alpha );
		
		wait .05;
	}
*/
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
		self PlaySound( "fly_dog_step_run_default" );
		return true;
	}

	prefix = getsubstr( note, 0, 5 );

	if ( prefix != "sound" )
	{
		return false;
	}

	alias = "aml" + getsubstr( note, 5 );

	if ( IsAlive( self ) )
	{
		//t6todo self thread play_sound_on_tag_endon_death( alias, "tag_eye" );
	}
	else
	{
		//t6todo self thread play_sound_in_space( alias, self gettagorigin( "tag_eye" ) );
	}

	return true;
}

growling()
{
	return IsDefined( self.script_growl );
}

registerNoteTracks()
{
	anim.notetracks["anim_pose = \"stand\""] = ::noteTrackPoseStand;
	anim.notetracks["anim_pose = \"crouch\""] = ::noteTrackPoseCrouch;

	anim.notetracks["anim_movement = \"stop\""] = ::noteTrackMovementStop;
	anim.notetracks["anim_movement = \"walk\""] = ::noteTrackMovementWalk;
	anim.notetracks["anim_movement = \"run\""] = ::noteTrackMovementRun;

	anim.notetracks["anim_alertness = causal"] = ::noteTrackAlertnessCasual;
	anim.notetracks["anim_alertness = alert"] = ::noteTrackAlertnessAlert;
	
	anim.notetracks["gravity on"] = ::noteTrackGravity;
	anim.notetracks["gravity off"] = ::noteTrackGravity;
	anim.notetracks["gravity code"] = ::noteTrackGravity;

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
}

noteTrackStopAnim( note, flagName )
{
}

noteTrackStartRagdoll( note, flagName )
{
	if( IsDefined( self.noragdoll ) )
	{
		return; // Nate - hack for armless zakhaev who doesn't do ragdoll
	}

	self Unlink();
	self startRagdoll();
}

noteTrackMovementStop( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "stop";
	}
}

noteTrackMovementWalk( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "walk";
	}
}

noteTrackMovementRun( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "run";
	}
}

noteTrackAlertnessCasual( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.alertness = "casual";
	}
}

noteTrackAlertnessAlert( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.alertness = "alert";
	}
}


noteTrackPoseStand( note, flagName )
{
	self.a.pose = "stand";
	self notify ("entered_pose" + "stand");
}

noteTrackPoseCrouch( note, flagName )
{
	self.a.pose = "crouch";
	self notify ("entered_pose" + "crouch");

	if (self.a.crouchPain)
	{
		// for dying pain
		self.a.crouchPain = false;
		self.health = 150;
	}
}

noteTrackGravity( note, flagName )
{
	if ( isSubStr( note, "on" ) )
	{
    self AnimMode( "gravity" );
	}
	else if ( isSubStr( note, "off" ) )
	{
		self AnimMode( "nogravity" );
		self.nogravity = true;
	}
	else if ( isSubStr( note, "code" ) )
	{
		self AnimMode( "none" );
		self.nogravity = undefined;
	}
}

noteTrackBodyFall( note, flagName )
{
	if ( IsDefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
		
	if ( isSubStr( note, "large" ) )
	{
		self PlaySound ("fly_bodyfall_large_" + groundType);
	}
	else if ( isSubStr( note, "small" ) )
	{
		self PlaySound ("fly_bodyfall_small_" + groundType);
	}
}

noteTrackFootStep( note, flagName )
{
	if ( isSubStr( note, "left" ) )
	{
		playFootStep( "J_Ball_LE" );
	}
	else
	{
		playFootStep( "J_BALL_RI" );
	}


	// CODER_MOD - DSL - 03/28/08
	// Moved footsteps over to client side - clientscripts/_footsteps.csc

	if(!level.clientScripts)
	{	
		self PlaySound( "fly_gear_run" );		
	}
}


noteTrackFootScrape( note, flagName )
{
	if ( IsDefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
		
	self PlaySound ("fly_step_scrape_" + groundType );
}

	
noteTrackLand( note, flagName )
{
	if ( IsDefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
		
	self PlaySound ("fly_land_npc_" + groundType );
}

HandleNoteTrack( note, flagName, customFunction, var1 )
{
	/#
	self thread showNoteTrack( note );
	#/
	
	if ( isAI( self ) && self.isdog )
	{
		if ( HandleDogSoundNoteTracks( note ) )
		{
			return;
		}
	}
	else
	{
		notetrackFunc = anim.notetracks[note];
		if ( IsDefined( notetrackFunc ) )
		{
			return [[notetrackFunc]]( note, flagName );
		}
	}
	
	switch ( note )
	{
	case "end":
	case "finish":
	case "undefined":
		if ( isAI(self) && self.a.pose=="back" ) 
		{
		}
		return note;


	case "swish small":
		//t6todo self thread play_sound_in_space ("fly_gear_enemy", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
	case "swish large":
		//t6todo self thread play_sound_in_space ("fly_gear_enemy_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
// SOUNDS END

	case "no death":
		// does not play a death anim when he dies
		self.a.nodeath = true;
		break;
	case "no pain":
		self.allowpain = false;
		break;		
	case "allow pain":
		self.allowpain = true;
		break;
	case "anim_melee = right":
	case "anim_melee = \"right\"":
		self.a.meleeState = "right";
		break;
	case "anim_melee = left":
	case "anim_melee = \"left\"":
		self.a.meleeState = "left";
		break;
	case "swap taghelmet to tagleft":
		if ( IsDefined ( self.hatModel ) )
		{
			if (IsDefined(self.helmetSideModel))
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
		//t6todo anim_stopanimscripted();
		return note;
	default:
		if (IsDefined(customFunction))
		{
			if (!IsDefined(var1))
			{
				return [[customFunction]] (note);
			}
			else
			{
				return [[customFunction]] (note, var1);
			}
		}
		break;
	}
}

// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an "end" or a "finish"
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(flagName, ::customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
DoNoteTracks( flagName, customFunction, var1 ) 
{
	for (;;)
	{
		self waittill (flagName, note);

		if ( !isDefined( note ) )
			note = "undefined";

		val = self HandleNoteTrack( note, flagName, customFunction, var1 );
		
		if ( isDefined( val ) )
			return val;
	}
}

DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, var1 )
{
	if (isdefined (killString))
		self endon (killString);
	self endon ("killanimscript");

	for (;;)
	{
		time = GetTime();
		returnedNote = [[notetracksFunc]](flagName, customFunction, var1);
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = [[notetracksFunc]](flagName, customFunction, var1);
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
/#
				println (GetTime()+" maps\mp\animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
#/
				wait ( 0.05 - timetaken );
			}
		}
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
DoNoteTracksForever(flagName, killString, customFunction, var1 )
{
	DoNoteTracksForeverProc( ::DoNoteTracks, flagName, killString, customFunction, var1 );
}

DoNoteTracksForTimeProc( doNoteTracksForeverFunc, time, flagName, customFunction , ent, var1)
{
	ent endon ("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, var1);
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
DoNoteTracksForTime(time, flagName, customFunction, var1)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForever, time, flagName, customFunction, ent, var1);
}

doNoteTracksForTimeEndNotify(time)
{
	wait (time);
	self notify ("stop_notetracks");
}

playFootStep(foot)
{
	if(!level.clientScripts)
	{
		if (! isAI(self) )
		{
			self PlaySound ("fly_step_run_dirt");	
			return;
		}
	}
	
	groundType = undefined;
	// gotta record the groundtype in case it goes undefined on us
	if (!IsDefined(self.groundtype))
	{
		if (!IsDefined(self.lastGroundtype))
		{
			if(!level.clientScripts)
			{
				self PlaySound ("fly_step_run_dirt");	
			}
			return;
		}

		groundtype = self.lastGroundtype;
	}
	else
	{
		groundtype = self.groundtype;
		self.lastGroundtype = self.groundType;
	}
	
	if(!level.clientScripts)
	{
		self PlaySound ("fly_step_run_" + groundType);
	}
	[[anim.optionalStepEffectFunction]](foot, groundType);
}


playFootStepEffect(foot, groundType)
{
	// CODER_MOD
	// DSL - 05/19/08 - Playfx for footsteps now happens on the client.
	
	if(level.clientScripts)
	{
			return;
	}
	
	for (i=0;i<anim.optionalStepEffects.size;i++)
	{
		// MikeD (5/5/2008): Added the ability to have fire footsteps when the 
		// AI is on fire.
		if( IsDefined( self.fire_footsteps ) && self.fire_footsteps )
		{
			groundType = "fire";
		}

		if (groundType != anim.optionalStepEffects[i])
		{
			continue;
		}

		org = self gettagorigin(foot);
		playfx(level._effect["step_" + anim.optionalStepEffects[i]], org, org + (0,0,100));
		return;
	}
}

moveToOriginOverTime( origin, time )
{
	self endon("killanimscript");
	
	if ( DistanceSquared( self.origin, origin ) > 16*16 && !self mayMoveToPoint( origin ) )
	{
		/# println("^1Warning: AI starting behavior for node at " + origin + " but could not move to that point."); #/
		return;
	}
	
	self.keepClaimedNodeInGoal = true;
	
	offset = self.origin - origin;
	
	frames = int(time * 20);
	offsetreduction = VectorScale( offset, 1.0 / frames );
	
	for ( i = 0; i < frames; i++ )
	{
		offset -= offsetreduction;
		self Teleport( origin + offset );
		wait .05;
	}
	
	self.keepClaimedNodeInGoal = false;
}

returnTrue() { return true; }




