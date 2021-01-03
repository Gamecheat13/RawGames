#using scripts\codescripts\struct;

#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       


#using scripts\shared\ai\zombie_utility;

// Shared.gsc - Functions that are shared between animscripts and level scripts.  
// Functions in this file can't rely on the maps\mp\animscripts\zm_init function having run, and can't call any 
// functions not allowed in level scripts.
// 
// #using scripts\_utility;

function deleteAtLimit()
{
	wait 30.0;
	
	self delete();
}

function LookAtEntity(lookTargetEntity, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	return;
}

function LookAtPosition(lookTargetPos, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	assert(isAI(self), "Can only call this function on an AI character");											
	assert(self.a.targetLookInitilized == true, "LookAtPosition called on AI that lookThread was not called on");	
	assert( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");					
	
	// If interruptOthers is true, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to true.
	if ( !isdefined(interruptOthers) || (interruptOthers=="interrupt others") || (GetTime() > self.a.lookEndTime) )
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

		if ( isdefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}
}

function LookAtAnimations(leftanim, rightanim)
{
	self.a.LookAnimationLeft = leftanim;
	self.a.LookAnimationRight = rightanim;
}

function HandleDogSoundNoteTracks( note )
{
	if ( note == "sound_dogstep_run_default" || note == "dogstep_rf" || note == "dogstep_lf" )
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
		self thread sound::play_on_tag( alias, "tag_eye" );
	}
	else
	{
		self thread sound::play_in_space( alias, self gettagorigin( "tag_eye" ) );
	}

	return true;
}

function growling()
{
	return isdefined( self.script_growl );
}

function registerNoteTracks()
{
	anim.notetracks["anim_pose = \"stand\""] =&noteTrackPoseStand;
	anim.notetracks["anim_pose = \"crouch\""] =&noteTrackPoseCrouch;

	anim.notetracks["anim_movement = \"stop\""] =&noteTrackMovementStop;
	anim.notetracks["anim_movement = \"walk\""] =&noteTrackMovementWalk;
	anim.notetracks["anim_movement = \"run\""] =&noteTrackMovementRun;

	anim.notetracks["anim_alertness = causal"] =&noteTrackAlertnessCasual;
	anim.notetracks["anim_alertness = alert"] =&noteTrackAlertnessAlert;
	
	anim.notetracks["gravity on"] =&noteTrackGravity;
	anim.notetracks["gravity off"] =&noteTrackGravity;
	anim.notetracks["gravity code"] =&noteTrackGravity;

	anim.notetracks["bodyfall large"] =&noteTrackBodyFall;
	anim.notetracks["bodyfall small"] =&noteTrackBodyFall;
	
	anim.notetracks["footstep"] =&noteTrackFootStep;
	anim.notetracks["step"] =&noteTrackFootStep;
	anim.notetracks["footstep_right_large"] =&noteTrackFootStep;
	anim.notetracks["footstep_right_small"] =&noteTrackFootStep;
	anim.notetracks["footstep_left_large"] =&noteTrackFootStep;
	anim.notetracks["footstep_left_small"] =&noteTrackFootStep; 
	anim.notetracks["footscrape"] =&noteTrackFootScrape; 
	anim.notetracks["land"] =&noteTrackLand;
	
	anim.notetracks["start_ragdoll"] =&noteTrackStartRagdoll;
}

function noteTrackStopAnim( note, flagName )
{
}

function noteTrackStartRagdoll( note, flagName )
{
	if( isdefined( self.noragdoll ) )
	{
		return; // Nate - hack for armless zakhaev who doesn't do ragdoll
	}

	self Unlink();
	self startRagdoll();
}

function noteTrackMovementStop( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "stop";
	}
}

function noteTrackMovementWalk( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "walk";
	}
}

function noteTrackMovementRun( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "run";
	}
}

function noteTrackAlertnessCasual( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.alertness = "casual";
	}
}

function noteTrackAlertnessAlert( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.alertness = "alert";
	}
}


function noteTrackPoseStand( note, flagName )
{
	self.a.pose = "stand";
	self notify ("entered_pose" + "stand");
}

function noteTrackPoseCrouch( note, flagName )
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

function noteTrackGravity( note, flagName )
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

function noteTrackBodyFall( note, flagName )
{
	if ( isdefined( self.groundType ) )
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

function noteTrackFootStep( note, flagName )
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
	// Moved footsteps over to client side - scripts/_footsteps.csc

	if(!level.clientScripts)
	{	
		self PlaySound( "fly_gear_run" );		
	}
}


function noteTrackFootScrape( note, flagName )
{
	if ( isdefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
		
	self PlaySound ("fly_step_scrape_" + groundType );
}

	
function noteTrackLand( note, flagName )
{
	if ( isdefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
		
	self PlaySound ("fly_land_npc_" + groundType );
}

function HandleNoteTrack( note, flagName, customFunction, var1 )
{	
	if ( isAI( self ) && isdefined(anim.notetracks) )
	{
		notetrackFunc = anim.notetracks[note];
		if ( isdefined( notetrackFunc ) )
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
		self thread sound::play_in_space("fly_gear_enemy", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
	case "swish large":
		self thread sound::play_in_space("fly_gear_enemy_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
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
		if ( isdefined ( self.hatModel ) )
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
	default:
		if (isdefined(customFunction))
		{
			if (!isdefined(var1))
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
// already handled by the generic function. This call should take the form DoNoteTracks(flagName,&customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
function DoNoteTracks( flagName, customFunction, var1 ) 
{
	for (;;)
	{
		self waittill (flagName, note);

		if ( !isdefined( note ) )
			note = "undefined";

		val = self HandleNoteTrack( note, flagName, customFunction, var1 );
		
		if ( isdefined( val ) )
			return val;
	}
}

function DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, var1 )
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
				println (GetTime()+" zm_shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
#/
				wait ( 0.05 - timetaken );
			}
		}
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
function DoNoteTracksForever(flagName, killString, customFunction, var1 )
{
	DoNoteTracksForeverProc(&DoNoteTracks, flagName, killString, customFunction, var1 );
}

function DoNoteTracksForTimeProc( doNoteTracksForeverFunc, time, flagName, customFunction , ent, var1)
{
	ent endon ("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, var1);
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
function DoNoteTracksForTime(time, flagName, customFunction, var1)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc(&DoNoteTracksForever, time, flagName, customFunction, ent, var1);
}

function doNoteTracksForTimeEndNotify(time)
{
	wait (time);
	self notify ("stop_notetracks");
}

function playFootStep(foot)
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
	if (!isdefined(self.groundtype))
	{
		if (!isdefined(self.lastGroundtype))
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


function playFootStepEffect(foot, groundType)
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
		if( isdefined( self.fire_footsteps ) && self.fire_footsteps )
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

function moveToOriginOverTime( origin, time )
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

function returnTrue() { return true; }



function trackLoop(  )
{

	players = GetPlayers();
	deltaChangePerFrame = 5;
	
	aimBlendTime = .05;
	
	prevYawDelta = 0;
	prevPitchDelta = 0;
	maxYawDeltaChange = 5; // max change in yaw in 1 frame
	maxPitchDeltaChange = 5;
	
	pitchAdd = 0;
	yawAdd = 0;
	
	if ( (self.type == "dog") || (self.type == "zombie") || (self.type == "zombie_dog") )
	{
		doMaxAngleCheck = false;
		self.shootEnt = self.enemy;
	}
	else
	{
		doMaxAngleCheck = true;
	if ( self.a.script == "cover_crouch" && isdefined( self.a.coverMode ) && self.a.coverMode == "lean" )
		pitchAdd = -1 * anim.coverCrouchLeanPitch;
	if ( (self.a.script == "cover_left" || self.a.script == "cover_right") && isdefined( self.a.cornerMode ) && self.a.cornerMode == "lean" )
		yawAdd = self.coverNode.angles[1] - self.angles[1];
	}
	
	yawDelta = 0;
	pitchDelta = 0;
	
	firstFrame = true;
	
	for(;;)
	{
		incrAnimAimWeight();
		
		selfShootAtPos = (self.origin[0], self.origin[1], self getEye()[2]);

		shootPos = undefined;
		if ( isdefined( self.enemy ) )
			shootPos = self.enemy getShootAtPos();

		if ( !isdefined( shootPos ) )
		{
			yawDelta = 0;
			pitchDelta = 0;
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
		
		if ( doMaxAngleCheck && ( abs( yawDelta ) > 60 || abs( pitchDelta ) > 60 ) )
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
				yawDelta = prevYawDelta + maxYawDeltaChange * math::sign( yawDeltaChange );
			
			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if ( abs( pitchDeltaChange ) > maxPitchDeltaChange )
				pitchDelta = prevPitchDelta + maxPitchDeltaChange * math::sign( pitchDeltaChange );
		}
		
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		
		updown = 0;
		leftright = 0;
		
		if ( yawDelta > 0 )
		{
			assert( yawDelta <= self.rightAimLimit );
			weight = yawDelta / self.rightAimLimit * self.a.aimweight;
			leftright = weight;
		}
		else if ( yawDelta < 0 )
		{
			assert( yawDelta >= self.leftAimLimit );
			weight = yawDelta / self.leftAimLimit * self.a.aimweight;
			leftright = -1 * weight;
		}
		
		if ( pitchDelta > 0 )
		{
			assert( pitchDelta <= self.upAimLimit );
			weight = pitchDelta / self.upAimLimit * self.a.aimweight;
			updown = weight;
		}
		else if ( pitchDelta < 0 )
		{
			assert( pitchDelta >= self.downAimLimit );
			weight = pitchDelta / self.downAimLimit * self.a.aimweight;
			updown = -1 * weight;
		}
		
		//self SetAimAnimWeights( updown, leftright );
		{wait(.05);};
	}
}

//setAnimAimWeight works just like setanimlimited on an imaginary anim node that affects the four aiming directions.
function setAnimAimWeight(goalweight, goaltime)
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
		self.a.aimweight = goalweight;
		self.a.aimweight_start = self.a.aimweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = int(goaltime * 20);
	}
	self.a.aimweight_t = 0;
}

function incrAnimAimWeight()
{
	if ( self.a.aimweight_t < self.a.aimweight_transframes )
	{
		self.a.aimweight_t++;
		t = 1.0 * self.a.aimweight_t / self.a.aimweight_transframes;
		self.a.aimweight = self.a.aimweight_start * (1 - t) + self.a.aimweight_end * t;
	}
}