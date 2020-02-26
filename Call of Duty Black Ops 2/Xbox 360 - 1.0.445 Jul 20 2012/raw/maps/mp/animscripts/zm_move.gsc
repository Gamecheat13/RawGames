#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;

main()
{
	self endon("killanimscript");
	
	self SetAimAnimWeights( 0, 0 );
	
	previousScript = self.a.script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
	maps\mp\animscripts\zm_utility::initialize("zombie_move");

	MoveMainLoop();
}


MoveMainLoop()
{
	self endon( "killanimscript" );
	self endon( "stop_soon" );
	
	self.needs_run_update = true;

//t6todo	self sideStepInit();
	
	for (;;)
	{
		self maps\mp\animscripts\zm_run::MoveRun();

//t6todo		self trySideStep();	
	}
}



/* t6todo
//-----------------------------------------
// Spetsnaz zombies sidestepping behavior
//-----------------------------------------

sideStepInit()
{
	self.a.steppedDir			= 0; // -1 means went left, 1 means went right
	self.a.lastSideStepTime	= GetTime();

	if( !IsDefined( level.sideStepAnims ) )
	{		
		// tweakable values for changing the behavior
		level.MIN_REACTION_DIST_SQ    = 64*64;	  // minimum distance from the player to be able to react
		level.MAX_REACTION_DIST_SQ	  = 1000*1000;// maximum distance from the player to be able to react
		level.REACTION_INTERVAL		  = 2000;	  // time interval between reactions		
		level.SIDE_STEP_CHANCE		  = 0.7;	  // 70% chance of sidestepping, 30% chance of rolling forward
		level.RIGHT_STEP_CHANCE		  = 0.5;	  // 50% left and 50% right step chance	

		level.FORWARD_REACTION_INTERVAL		  = 2000;	  // time interval between reactions		
		level.FORWARD_MIN_REACTION_DIST_SQ    = 120*120;	  // minimum distance from the player to be able to react
		level.FORWARD_MAX_REACTION_DIST_SQ	  = 2400*2400;// maximum distance from the player to be able to react

		// init animations
		level.sideStepAnims = [];
		
		level.sideStepAnims["step_left"]	= array( %ai_zombie_spets_sidestep_left_a, %ai_zombie_spets_sidestep_left_b );
		level.sideStepAnims["step_right"]	= array( %ai_zombie_spets_sidestep_right_a, %ai_zombie_spets_sidestep_right_b );
		
		level.sideStepAnims["roll_forward"]	= array( %ai_zombie_spets_roll_a, %ai_zombie_spets_roll_b, %ai_zombie_spets_roll_c );
	}
}

trySideStep()
{
	if ( isdefined( self.shouldSideStepFunc ) )
	{
		self.sideStepType = self [[ self.shouldSideStepFunc ]]();
	}
	else
	{
		self.sideStepType = shouldSideStep();
	}

	if( self.sideStepType == "none" )
	{
		if ( is_true( self.zombie_can_forwardstep ) )
		{
			self.sideStepType = shouldForwardStep();
		}
	}

	if( self.sideStepType == "none" )
	{
		return false;
	}
	
	self.desiredStepDir = getDesiredSideStepDir( self.sideStepType );
	
	animName	  = self.sideStepType + "_" + self.desiredStepDir;
	sideStepAnims = level.sideStepAnims;
	if ( IsDefined( self.sideStepAnims ) )
	{
		sideStepAnims = self.sideStepAnims;
	}
	self.stepAnim = sideStepAnims[ animName ][RandomInt( sideStepAnims[ animName ].size )];

	assert( IsDefined(self.stepAnim), "Sidestep anim " + animName + " not found" );

	// check if the anim will collide with the geo
	if ( !self checkRoomForAnim( self.stepAnim ) )
	{
		hasRoom = false;

		// try rolling forward if there's no room to the side
		if( self.sideStepType == "roll" && self.desiredStepDir != "forward" )
		{
			self.desiredStepDir = "forward";

			animName = self.sideStepType + "_" + self.desiredStepDir;
			self.stepAnim = sideStepAnims[ animName ][RandomInt( sideStepAnims[ animName ].size )];

			assert( IsDefined(self.stepAnim), "Sidestep anim " + animName + " not found" );

			hasRoom = self checkRoomForAnim( self.stepAnim );
		}

		if( !hasRoom )
		{
			return false;
		}
	}

	self AnimCustom( ::doSideStep );
}

getDesiredSideStepDir( sideStepType )
{
	if( sideStepType == "roll" || sideStepType == "phase" )
	{
		self.desiredStepDir = "forward";		
		return self.desiredStepDir;
	}

	assert( sideStepType == "step", "Unsupported SideStepType" );
	
	randomRoll = RandomFloat(1);

	// stay within a "hallway", ie, stay within one step left or right off the original center
	if( self.a.steppedDir < 0 )
	{
		self.desiredStepDir = "right";
	}
	else if( self.a.steppedDir > 0 )
	{
		self.desiredStepDir = "left";
	}
	else if( randomRoll < level.RIGHT_STEP_CHANCE )
	{
		self.desiredStepDir = "right";
	}
	else if( randomRoll < level.RIGHT_STEP_CHANCE*2 )
	{
		self.desiredStepDir = "left";
	}
	
	return self.desiredStepDir;
}

checkRoomForAnim( stepAnim )
{
	// check if the anim will collide with the geo
	if ( !self MayMoveFromPointToPoint( self.origin, getAnimEndPos( stepAnim ) ) )
	{
		return false;
	}

	return true;
}


shouldSideStep()
{
	if( canSideStep() && IsPlayer(self.enemy) ) //t6todo && self.enemy IsLookingAt(self) )
	{
		if( self.zombie_move_speed != "sprint" || RandomFloat(1) < level.SIDE_STEP_CHANCE )
			return "step";
		else
			return "roll";
	}

	return "none";
}

canSideStep()
{
	//per-entity bool rather than relying only on spetznaz in name
	if ( !IsDefined( self.zombie_can_sidestep ) || !self.zombie_can_sidestep )
	{
		// legacy behavior
		// this behavior is only for zombie_spetznaz
		if( !issubstr( self.classname, "zombie_spetznaz" ) )
			return false;
	}

	if( GetTime() - self.a.lastSideStepTime < level.REACTION_INTERVAL )
		return false;
	
	if( !IsDefined(self.enemy) )
		return false;
	
	if( self.a.pose != "stand" )
		return false;
	
	distSqFromEnemy = DistanceSquared(self.origin, self.enemy.origin);

	// don't do it too close to the enemy
	if( distSqFromEnemy < level.MIN_REACTION_DIST_SQ )
	{
		return false;
	}

	// don't do it too far from the enemy
	if( distSqFromEnemy > level.MAX_REACTION_DIST_SQ )
	{
		return false;
	}

	// don't do it if not path or too close to destination
	if( !IsDefined(self.pathgoalpos) || DistanceSquared(self.origin, self.pathgoalpos) < level.MIN_REACTION_DIST_SQ )
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

	if( abs(yaw) > 45 )
	{
		return false;
	}

	return true;
}

shouldForwardStep()
{
	if ( canForwardStep() && IsPlayer( self.enemy ) )
	{
		return "phase";
	}

	return "none";
}

canForwardStep()
{
	if ( !isdefined( self.zombie_can_forwardstep ) || !self.zombie_can_forwardstep )
	{
		return false;
	}

	if( GetTime() - self.a.lastSideStepTime < level.FORWARD_REACTION_INTERVAL )
		return false;
	
	if( !IsDefined(self.enemy) )
		return false;
	
	if( self.a.pose != "stand" )
		return false;
	
	distSqFromEnemy = DistanceSquared(self.origin, self.enemy.origin);

	// don't do it too close to the enemy
	if( distSqFromEnemy < level.FORWARD_MIN_REACTION_DIST_SQ )
	{
		return false;
	}

	// don't do it too far from the enemy
	if( distSqFromEnemy > level.FORWARD_MAX_REACTION_DIST_SQ )
	{
		return false;
	}

	// don't do it if not path or too close to destination
	if( !IsDefined(self.pathgoalpos) || DistanceSquared(self.origin, self.pathgoalpos) < level.MIN_REACTION_DIST_SQ )
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

	if( abs(yaw) > 45 )
	{
		return false;
	}

	return true;
}

doSideStep()
{
	self endon("death");
	self endon("killanimscript");
	
	// play the actual anim
	playSideStepAnim( self.stepAnim, self.sideStepType );

	// keep track of side steps
	if( self.desiredStepDir == "left" )
	{
		self.a.steppedDir--;
	}
	else
	{
		self.a.steppedDir++;
	}

	self.a.lastSideStepTime = GetTime();

	return true;
}

playSideStepAnim( stepAnim, sideStepType )
{
	// play strict anim
	self AnimMode( "gravity", false );
	self OrientMode( "face angle", self.angles[1] );

	// must keep this low, otherwise there's a weird pop because of the client until we fix the networking
	runBlendOutTime = 0.20;

	if ( isdefined( self.sideStepFunc ) )
	{
		self thread [[ self.sideStepFunc ]]( "stepAnim", stepAnim );
	}

//t6todo2	self ClearAnim( %body, runBlendOutTime );
//t6todo2	self SetFlaggedAnimRestart( "stepAnim", stepAnim, 1, runBlendOutTime, self.moveplaybackrate );

	animStartTime = GetTime();
	animLength    = GetAnimLength(stepAnim);

	hasExitAlign = animHasNotetrack( stepAnim, "exit_align" );
	if ( !hasExitAlign )
	{
		// AI_TODO: print anim name
		println("^1Side step animation has no \"exit_align\" notetrack");
	}

	self thread maps\mp\animscripts\shared::DoNoteTracks( "stepAnim" );
	self thread sideStepBlendOut( animLength, "stepAnim", hasExitAlign );

	self.exit_align = false;
	// wait till the notetrack telling us to start turning the AI
	self waittillmatch( "stepAnim", "exit_align" );

	self.exit_align = true;
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

	maxYawDelta = 2;

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

		restorePain();
		self.deathFunction = maps\mp\zombies\_zm_spawner::zombie_death_animscript;
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

	runBlendInTime = 0.2; // to fix an extra frame of sliding that happens on the client

	assert( animLength > runBlendInTime );
	wait( (animLength - runBlendInTime) / self.moveplaybackrate );

	if( !hasExitAlign )
	{
		self notify( animName, "exit_align" ); // failsafe
	}

	// go back to run
//t6todo2	self ClearAnim( %exposed_modern, 0 );
//t6todo2	self SetFlaggedAnimKnobAllRestart( "run_anim", maps\mp\animscripts\zm_run::GetRunAnim(), %body, 1, runBlendInTime, self.moveplaybackrate );
}
*/
