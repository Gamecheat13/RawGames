#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include animscripts\debug;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree ("generic_human");

sideStepInit()
{
	self.a.rusherSteppedDir			= 0; // -1 means went left, 1 means went right
	self.a.rusherGunHand			= "rh";
	self.a.rusherLastSideStepTime	= GetTime();
	self.a.rusherHadSideStepEvent	= false;

	if( allowEvasiveMovement() )
	{
		self addAIEventListener( "bulletwhizby" );
		self thread sideStepWatchForEvent();
	}
}

sideStepWatchForEvent()
{
	self endon("death");
	self endon("killanimscript");

	self.a.rusherHadSideStepEvent = false;

	while(1)
	{
		self waittill_any("bulletwhizby");

		// keep the flag on for one frame
		self.a.rusherHadSideStepEvent = true;
		wait(0.05);
		waittillframeend;
		self.a.rusherHadSideStepEvent = false;
	}
}

canSideStep()
{
	if( !allowEvasiveMovement() )
	{
		return false;
	}

	if( GetTime() - self.a.rusherLastSideStepTime < 500 )
	{
		return false;
	}

	if( !IsDefined(self.enemy) )
	{
		return false;
	}

	if( !self usingRifle() && !self usingPistol() )
	{
		return false;
	}

	if( self.a.pose != "stand" )
	{
		return false;
	}

	const minDistSquared = 300 * 300;

	// don't do it too close to the enemy
	if( DistanceSquared(self.origin, self.enemy.origin) < minDistSquared )
	{
		return false;
	}

	// don't do it if not path or too close to destination
	if( !IsDefined(self.pathgoalpos) || DistanceSquared(self.origin, self.pathgoalpos) < minDistSquared )
	{
		return false;
	}

	// make sure the AI's running straight
	if( abs(self GetMotionAngle()) > 15 )
	{
		return false;
	}

	// and towards the enemy
	yaw = GetYawToOrigin(self.enemy.origin);
	if( abs(yaw) > 15 )
	{
		return false;
	}

	return true;
}

shouldSideStep()
{
	if( canSideStep() )
	{
		runLoopTime = self getAnimTime( %walk_and_run_loops );

		if( self.a.rusherHadSideStepEvent )
		{
			return "roll";
		}
		else if( IsPlayer(self.enemy) && self.enemy IsLookingAt(self) )
		{
			if( RandomFloat(1) < 0.2 )
			{
				return "step";
			}
			else
			{
				return "roll";
			}
		}
		else if( runLoopTime > 0.9 && RandomFloat(1) < 0.75 ) // anims are better synced up at run loop end
		{
			return "step";
		}
	}

	return "none";
}

trySideStep()
{
	self.rusherSideStepType = shouldSideStep();

	if( self.rusherSideStepType == "none" )
	{
		return false;
	}

	/#
	self animscripts\debug::debugPushState( "sideStep" );
	#/

	self.rusherDesiredStepDir = getDesiredSideStepDir( self.rusherSideStepType );
	self.rusherDesiredGunHand = self.a.rusherGunHand;

	// switch hands if necessary
	if( self.a.rusherSteppedDir == 0 && self.rusherDesiredStepDir == "left" && RandomFloat(1) < 0.5 )
	{
		//iprintln("switch hands");
		self.rusherDesiredGunHand = "lh";
	}

	animName = self.rusherSideStepType + "_" + self.rusherDesiredStepDir + "_" + self.rusherDesiredGunHand;
	self.stepAnim = animscripts\anims::animArrayPickRandom( animName ); // save for animcustom
	
	assert( IsDefined(self.stepAnim), "rusher anim " + animName + " not found" );

	// check if the anim will collide with the geo
	if ( !self checkRoomForAnim( self.stepAnim ) )
	{
		hasRoom = false;

		// try rolling forward if there's no room to the side
		if( self.rusherSideStepType == "roll" && self.rusherDesiredStepDir != "forward" )
		{
			self.rusherDesiredStepDir = "forward";

			animName = self.rusherSideStepType + "_" + self.rusherDesiredStepDir + "_" + self.rusherDesiredGunHand;
			self.stepAnim = animscripts\anims::animArrayPickRandom( animName );

			assert( IsDefined(self.stepAnim), "rusher anim " + animName + " not found" );

			hasRoom = self checkRoomForAnim( self.stepAnim );
		}

		if( !hasRoom )
		{
			/#
			self animscripts\debug::debugPopState( "sideStep", "no room for sidestep" );
			#/
		
			return false;
		}
	}

	self AnimCustom( ::doSideStep );
}

doSideStep()
{
	self endon("death");
	self endon("killanimscript");

	// switch hands, if necessary
	if( self.rusherDesiredStepDir == "right" && self.rusherDesiredGunHand == "lh" )
	{
		//iprintln("switch back");
		self.rusherDesiredGunHand = "rh";
	}

	self.a.rusherGunHand = self.rusherDesiredGunHand;

	// set the appropriate run cycle now because it will be used in playSideStepAnim
	setRunCycle();

	// play the actual anim
	playSideStepAnim( self.stepAnim, self.rusherSideStepType );

	// keep track of side steps
	if( self.rusherDesiredStepDir == "left" )
	{
		self.a.rusherSteppedDir--;
	}
	else
	{
		self.a.rusherSteppedDir++;
	}

	self.a.rusherLastSideStepTime = GetTime();

	/#
	self animscripts\debug::debugPopState( "sideStep" );
	#/

	return true;
}

// copied from animscripts\turn::doTurn()
// AI_TODO: refactor this so it's shared between this, turns and whatever else needs this functionality
playSideStepAnim( stepAnim, rusherSideStepType )
{
	// play strict anim
	self AnimMode( "gravity", false );
	self OrientMode( "face angle", self.angles[1] );

	// must keep this low, otherwise there's a weird pop because of the client until we fix the networking
	const runBlendOutTime = 0.20;

	self ClearAnim( %body, runBlendOutTime );
	self SetFlaggedAnimRestart( "stepAnim", stepAnim, 1, runBlendOutTime, self.moveplaybackrate );

	// turn aiming back on
	if( rusherSideStepType == "step" )
	{
		self aimingOn();

		self.shoot_while_moving_thread = undefined;
		self thread animscripts\run::runShootWhileMovingThreads();
	}
	else
	{
		// no pain for rolls right now
		self disable_pain();
		self thread restorePainOnKillanimscript();
		self.deathFunction = ::do_ragdoll_death;
	}

	animStartTime = GetTime();
	animLength    = GetAnimLength(stepAnim);

	hasExitAlign = animHasNotetrack( stepAnim, "exit_align" );
	if ( !hasExitAlign )
	{
		// AI_TODO: print anim name
		println("^1Side step animation has no \"exit_align\" notetrack");
	}

	self thread animscripts\shared::DoNoteTracks( "stepAnim" );
	self thread sideStepBlendOut( animLength, "stepAnim", hasExitAlign );

	// wait till the notetrack telling us to start turning the AI
	self waittillmatch( "stepAnim", "exit_align" );

	// set the time we have to available to turn
	elapsed  = (getTime() - animStartTime) / 1000.0;
	timeLeft = animLength - elapsed;

	// see if there's a notetrack that says when to stop turning, otherwise go till end
	hasCodeMoveNoteTrack = animHasNotetrack( stepAnim, "code_move" );
	if( hasCodeMoveNoteTrack )
	{
		times = getNotetrackTimes( stepAnim, "code_move" );
		assert( times.size == 1, "More than one code_move notetrack found" );

		timeLeft = times[0] * animLength - elapsed;
	}

	// now manually set the facing vector of the AI every frame during this turn window
	self AnimMode( "pos deltas", false );

	const maxYawDelta = 2;
	
	timer = 0;
	while( timer < timeLeft )
	{
		lookaheadAngles = VectorToAngles( self.lookaheaddir );
		yawDelta = AngleClamp180(lookaheadAngles[1] - self.angles[1]);

		if( yawDelta > maxYawDelta )
		{
			yawDelta = maxYawDelta;
		}
		else if( yawDelta < maxYawDelta*-1 )
		{
			yawDelta = maxYawDelta*-1;
		}

		newAngles = (self.angles[0], self.angles[1] + yawDelta, self.angles[2]);
		self Teleport( self.origin, newAngles );

		/# if( GetDvarint( "ai_debugTurns" ) ) recordEntText( "face angle: " + (self.angles[1] + yawDelta), self, level.color_debug["red"], "Animscript" ); #/

		timer += 0.05 * self.moveplaybackrate;
		wait( 0.05 );
	}

	// continue facing the current dir until end of anim
	self OrientMode( "face angle", self.angles[1] );

	// wait till end of anim, if necessary
	elapsed  = (getTime() - animStartTime) / 1000.0;
	timeLeft = animLength - elapsed;

	if( timeLeft > 0 )
	{
		wait(timeLeft / self.moveplaybackrate);
	}

	if( IsAlive(self) )
	{
		self thread faceLookaheadForABit();

		// restart shooting threads for normal run
		animscripts\run::stopShootWhileMovingThreads();

		self enable_pain();
		self.deathFunction = undefined;
	}
}

faceLookaheadForABit()
{
	self endon("death");
	self endon("killanimscript");

	lookaheadAngles = VectorToAngles(self.lookaheaddir);
	self OrientMode( "face angle", lookaheadAngles[1] );

	wait(0.2);

	// return control to the code
	self AnimMode( "normal", false );
	self OrientMode( "face default" );
}

sideStepBlendOut( animLength, animName, hasExitAlign )
{
	self endon("killanimscript");
	self endon("death");
	self endon("stopTurnBlendOut");

	const runBlendInTime = 0.0; // to fix an extra frame of sliding that happens on the client

	assert( animLength > runBlendInTime );
	wait( (animLength - runBlendInTime) / self.moveplaybackrate );

	if( !hasExitAlign )
	{
		self notify( animName, "exit_align" ); // failsafe
	}

	// go back to run
	self ClearAnim( %exposed_modern, 0 );
	self SetFlaggedAnimKnobAllRestart( "run_anim", animArray("run_n_gun_f"), %body, 1, runBlendInTime, self.moveplaybackrate );

	self animscripts\run::aimingOn();
}

restorePainOnKillanimscript()
{
	self waittill("killanimscript");

	if( IsDefined(self) && IsAlive(self) )
	{
		self enable_pain();
		self.deathFunction = undefined;
	}
}

allowEvasiveMovement()
{
	if( !self.a.allowEvasiveMovement )
	{
		return false;
	}

	// only spetsnaz for now
	if( self.animType != "spetsnaz" )
	{
		return false;
	}
	else if( self.isWounded ) // wounded guys aren't agile anymore
	{
		return false;
	}

	return true;
}

setRunCycle()
{
	if( (self.animType == "spetsnaz" || self.lastAnimType == "spetsnaz") && is_rusher() )
	{
		self.anim_array_cache["run_n_gun_f"] = animArrayPickRandom("rusher_run_f_" + self.a.rusherGunHand);
	}
}

aimingOn()
{
	self animscripts\shared::setAimingAnims( %aim_2, %aim_4, %aim_6, %aim_8 );

	self SetAnim( %exposed_aiming, 1, 0 );

	self SetAnimKnobLimited( animArray("add_aim_up",	"turn" ),	1, 0.0 );
	self SetAnimKnobLimited( animArray("add_aim_down",	"turn" ),	1, 0.0 );
	self SetAnimKnobLimited( animArray("add_aim_left",	"turn" ),	1, 0.0 );
	self SetAnimKnobLimited( animArray("add_aim_right", "turn" ),	1, 0.0 );

	self.a.isAiming = true;
	self.aimAngleOffset = 0;
}

checkRoomForAnim( stepAnim )
{
	// check if the anim will collide with the geo
	if ( !self MayMoveFromPointToPoint( self.origin, getAnimEndPos( stepAnim ) ) )
	{
		/#
		recordLine( self.origin, getAnimEndPos(stepAnim), (1,0,0), "Animscript", self );
		#/

		return false;
	}

	/# 
	recordLine( self.origin, getAnimEndPos(stepAnim), (0,1,0), "Animscript", self );
	#/

	return true;
}

getDesiredSideStepDir( rusherSideStepType )
{
	rightChance = 0.333;

	// forward is only for rolls
	if( rusherSideStepType == "step" )
	{
		rightChance = 0.5;
	}

	randomRoll = RandomFloat(1);

	// stay within a "hallway", ie, stay within one step left or right off the original center
	if( self.a.rusherSteppedDir < 0 )
	{
		self.rusherDesiredStepDir = "right";
	}
	else if( self.a.rusherSteppedDir > 0 )
	{
		self.rusherDesiredStepDir = "left";
	}
	else if( randomRoll < rightChance )
	{
		self.rusherDesiredStepDir = "right";
	}
	else if( randomRoll < rightChance*2 )
	{
		self.rusherDesiredStepDir = "left";
	}
	else
	{
		self.rusherDesiredStepDir = "forward";
	}

	return self.rusherDesiredStepDir;
}