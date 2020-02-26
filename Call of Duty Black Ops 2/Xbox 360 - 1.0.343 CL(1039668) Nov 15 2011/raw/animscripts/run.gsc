#include animscripts\Utility;
#include animscripts\Combat_Utility;
#include animscripts\SetPoseMovement;
#include animscripts\debug;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_utility; 

#insert raw\common_scripts\utility.gsh;

#using_animtree ("generic_human");

//--------------------------------------------------------------------------------
// MoveRun
//--------------------------------------------------------------------------------
MoveRun()
{
	/#self animscripts\debug::debugPushState( "MoveRun" );#/
	desiredPose = self animscripts\utility::choosePose( "stand" );

	switch ( desiredPose )
	{
		case "stand":
			if ( BeginStandRun() ) // returns false (and does nothing) if we're already stand-running
			{
				/#self animscripts\debug::debugPopState( "MoveRun", "already running" );#/
				return;
			}
			
			if ( ReloadStandRun() )
			{
				/#self animscripts\debug::debugPopState( "MoveRun", "reloaded" );#/
				return;
			}

			if( self call_overloaded_func( "animscripts\cqb", "shouldCQB" ) )
			{
				/#self animscripts\debug::debugPushState( "MoveStandCombatNormal (CQB)" );#/
				MoveStandCombatNormal();
				/#self animscripts\debug::debugPopState( "MoveStandCombatNormal (CQB)" );#/
				/#self animscripts\debug::debugPopState( "MoveRun" );#/

				// ALEXP 7/2/10: no reloads until we get anim support
				return;
			}
			
			if ( self animscripts\utility::IsInCombat() )
			{
				if ( IsDefined( self.run_combatanim ) )
				{
					/#self animscripts\debug::debugPushState( "MoveStandCombatOverride" );#/
					MoveStandCombatOverride();
					/#self animscripts\debug::debugPopState( "MoveStandCombatOverride" );#/
				}
				else
				{
					/#self animscripts\debug::debugPushState( "MoveStandCombatNormal" );#/
					MoveStandCombatNormal();
					/#self animscripts\debug::debugPopState( "MoveStandCombatNormal" );#/
				}
			}
			else
			{
				if ( IsDefined( self.run_noncombatanim ) )
				{
					/#self animscripts\debug::debugPushState( "MoveStandNoncombatOverride" );#/
					MoveStandNoncombatOverride();
					/#self animscripts\debug::debugPopState( "MoveStandNoncombatOverride" );#/
				}
				else
				{
					/#self animscripts\debug::debugPushState( "MoveStandNoncombatNormal" );#/
					MoveStandNoncombatNormal();
					/#self animscripts\debug::debugPopState( "MoveStandNoncombatNormal" );#/
				}
			}
			break;
		
		case "crouch":
			if ( BeginCrouchRun() ) // returns false (and does nothing) if we're already crouch-running
			{
				/#self animscripts\debug::debugPopState( "MoveRun", "already running" );#/
				return;
			}
			
			if ( IsDefined( self.crouchrun_combatanim ) )
			{
				/#self animscripts\debug::debugPushState( "MoveCrouchRunOverride" );#/
				MoveCrouchRunOverride();
				/#self animscripts\debug::debugPopState( "MoveCrouchRunOverride" );#/
			}
			else
			{
				/#self animscripts\debug::debugPushState( "MoveCrouchRunNormal" );#/
				MoveCrouchRunNormal();
				/#self animscripts\debug::debugPopState( "MoveCrouchRunNormal" );#/
			}
			break;
	
		default:
			assert(desiredPose == "prone");
			if ( BeginProneRun() ) // returns false (and does nothing) if we're already prone-running
			{
				/#self animscripts\debug::debugPopState( "MoveRun", "already running" );#/
				return;
			}

			/#self animscripts\debug::debugPushState( "proneCrawl" );#/
			ProneCrawl();
			/#self animscripts\debug::debugPopState();#/
			break;
	}
	

	/#self animscripts\debug::debugPopState( "MoveRun" );#/
}

//--------------------------------------------------------------------------------
// MoveStandCombatOverride
//--------------------------------------------------------------------------------
MoveStandCombatOverride()
{
	self ClearAnim(%combatrun, 0.6);
	self SetAnimKnobAll(%combatrun, %body, 1, 0.5, self.moveplaybackrate);
	self SetFlaggedAnimKnob("runanim", self.run_combatanim, 1, 0.5, self.moveplaybackrate);
	DoNoteTracksNoShootStandCombat("runanim");
}

//--------------------------------------------------------------------------------
// MoveStandCombatNormal
//--------------------------------------------------------------------------------
MoveStandCombatNormal()
{
	self ClearAnim( %walk_and_run_loops, 0.2 );
	self setanimknob( %combatrun, 1.0, 0.5, self.moveplaybackrate );

	shouldSprint     = ShouldFullSprint();
	decidedAnimation = false;
	AimingOff();	// One of the available locomotions will call aimingOn() if necessary

	self OrientMode( "face default" );

	// cheat the ammo if necessary
	if( !self.bulletsInClip )
		cheatAmmoIfNecessary();
	
	/#RunDebugInfo();#/
	
	if( !shouldSprint && animscripts\move::MayShootWhileMoving() && self.bulletsInClip > 0 && isValidEnemy( self.enemy ) )
	{
		animscripts\run::StopUpdateRunAnimWeights(); // stop updateRunAnimWeights thread if that is running before starting new locomotion
		runShootWhileMovingThreads();				 // decide what and how to shoot while moving, and then shoot it

		CheatAmmoIfRunningBackward();			

		if ( IsPlayer( self.enemy ) )
			self updatePlayerSightAccuracy();
		
		if( ShouldTacticalWalk() ) // Tactical Walk Locomotion
		{	
			TacticalWalkForwardToBackWardTransition(); // front to back transition (uses turn animscript)
			decidedAnimation = TacticalWalk();
		}
		else if ( ShouldRunNGun() ) // RunNGun Locomotion
		{	
			//if( ShouldShootWhileRunningBackward() )		
			//{
				//RunNGunForwardToBackwardTransition(); // front to back transition (uses turn animscript)
			//	decidedAnimation = false; //RunNGunBackward();
			//}
			//else
			{
				decidedAnimation = RunNGunForward();
			}
		}
	}

	if( !decidedAnimation ) // cant do Tactical Walk or RunNGun or Sprint, do regular CombatRun based on GetRunAnim() or try sprinting for variation
	{
		// clear out RunNGun animations
		StopRunNGun();

		// sprint if decided by variation logic or told by the level scripter
		if( ShouldSprintForVariation() || shouldSprint )
		{			
			FullSprint(); // Full sprint Locomotion	
		}
		else
		{
			StopFullSprint(); // clear out FullSprint animations
			CombatRun();
		}
	}

	DoNoteTracksNoShootStandCombat("runanim");
	self thread StopShootWhileMovingThreads();
}


CheatAmmoIfRunningBackward() 
{
	// SUMEET_TODO - find better way to do this rather than forceful cheating
	// while running backwards, if AI runs out of bullets then it can choose combatRun() locomotion which is not ideal as it
	// makes AI look indecisive, we need to forcefully cheat ammo to avoid it. 
	
	if( ShouldTacticalWalk() || ShouldRunNGun() )
	{
		if( ShouldShootWhileRunningBackward() )
			self.bulletsInClip = weaponClipSize( self.weapon );
	}
}

//--------------------------------------------------------------------------------
// Full sprint Locomotion - Don't not shoot while full sprinting as it needs to go to the goal asap
//--------------------------------------------------------------------------------
ShouldFullSprint()
{
	// sprint when self.sprint is set and not cqb, as cqb sprint is handled in RunNGun
	if( self.sprint && !self isCQB() )
		return true;
	
	return false;
}

FullSprint()
{
	if( !IsDefined( self.a.fullSprintAnim ) )
		self.a.fullSprintAnim = animArrayPickRandom("sprint");

	self OrientMode( "face motion" );	
	self SetFlaggedAnimKnob("runanim", self.a.fullSprintAnim, 1, 0.5 );
	return true;
}

StopFullSprint()
{
	self.a.fullSprintAnim = undefined;
}

//--------------------------------------------------------------------------------
// Sprint variation
//--------------------------------------------------------------------------------
ShouldSprintForVariation()
{
	// CQB sprint is only if needed from the level script
	if( self isCQB() || self.isWounded )
		return false;
	
	if ( IS_TRUE( self.a.neverSprintForVariation ) )
		return false;

	time = gettime();

	if ( IsDefined( self.a.dangerSprintTime ) )
	{
		if ( time < self.a.dangerSprintTime )
			return true;

		// if already sprinted, don't do it again for at least 5 seconds
		if ( time - self.a.dangerSprintTime < 6000 )
			return false;
	}

	if ( !isdefined( self.enemy ) || !isSentient( self.enemy ) )
		return false;

	isAllowedToSprint = self lastKnownTime( self.enemy ) + 2000 > time || DistanceSquared( self.enemy.origin, self.origin ) > 600 * 600;

	if ( RandomInt( 100 ) < 40 && isAllowedToSprint  )
	{
		self.a.dangerSprintTime = time + 2000 + randomint( 1000 );
		return true;
	}

	return false;
}

//--------------------------------------------------------------------------------
// Tactical Walk Locomotion
//--------------------------------------------------------------------------------
ShouldTacticalWalk()
{
	if( IsDefined( self.pathGoalPos ) )
	{
		if( !self ShouldFaceMotionWhileRunning() )
			return true;
	}
				
	return false;
}

TacticalWalk() // ( F/L/R/B based on getMotionAngle )
{	
	relativeDir = anim.moveGlobals.relativeDirAnimMap[self.relativedir];

	// two different aims, one set for forward aims and other one for sideways. Only for pistol AI.
	if( relativeDir == "f" )
		AimingOn( "tactical_f", 45 );
	else if( relativeDir == "b" )
		AimingOn( "tactical_b", 45 );
	else
		AimingOn( "tactical_l", 45 );
	
	// change the orientmode so that code faces the AI properly towards enemy
	self orientmode( "face default" );

	motionAngle = self GetMotionAngle();

	if( Abs( motionAngle ) < 10 )	
		blendTime = 0.4;				// forward to forward blend
	else
		blendTime = 0.2;				// forward to sidFeways and backwards blend

	// pick the anim based on the strafe direction
	runForwardAnimName	= "tactical_walk_" + relativeDir;

	runForwardAnim = animArrayPickRandom( runForwardAnimName, "move", true );

	// set the TacticalWalk animation
	self SetFlaggedAnimKnob( "runanim", runForwardAnim, 1, blendTime, self.tacticalWalkRate );
	
	// as there is only one tactical walk animation at a given time (F/L/R), we don't need evaluate weight for leftAnim, rightAnim
	//self thread UpdateRunAnimWeightsThread( "tacticalWalkForward", runForwardAnimName, runBackwardAnimName );

	return true;
}

TacticalWalkForwardToBackwardTransition() // transition to face the opposite direction of the lookahead
{
	toEnemyYaw  = VectorToAngles(self.enemy.origin - self.origin)[1];
	angleDiff   = AngleClamp180( toEnemyYaw - self.angles[1] );

	isRunningForward = AbsAngleClamp180( self getMotionAngle() ) < 20;
	faceDir		= VectorScale(self.lookaheaddir, -1);
	faceAngle	= VectorToAngles(faceDir)[1];
	yawToEnemy	= AbsAngleClamp180( self.angles[1] - faceAngle );

	// don't transition if the distance is not enough to avoid 
	if( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) < 150 * 150 )
		return;

	if( self.lookaheaddist < 150 )
		return;

	if( isRunningForward && anim.moveGlobals.relativeDirAnimMap[self.relativedir] == "b" )
	{
		self thread stopShootWhileMovingThreads();  // stop shooting related threads
		self animscripts\shared::stopTracking();	// pause the trackLoop temporarily 

		if( angleDiff > 0 )
			transitionAnim = animArray("cqb_run_f_to_bL", "move");
		else
			transitionAnim = animArray("cqb_run_f_to_bR", "move");

		runAnimName			= "tactical_walk";
		self.a.turnAngle	= yawToEnemy * sign(angleDiff);
		self animscripts\turn::doTurn( transitionAnim, animArray(runAnimName + "_b"), -180, true );

		// set aims again as turn animation will clear it
		self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 ); 
		runShootWhileMovingThreads();				// start shooting related threads
		self animscripts\shared::trackLoopStart();	// unpause aiming trackloop back again
		
		self OrientMode( "face default" ); // switch back to default orient mode
	}
}

//--------------------------------------------------------------------------------
// RunNGun Locomotion
//--------------------------------------------------------------------------------
ShouldRunNGun()
{
	// Even though MayShootWhileMoving will return false while not facing the enemy preventing RunNGun on pistol AI, 
	// some other script can query, this function, thats is the reason we also check that.
	if( AIHasOnlyPistol() )
		return false;

	toEnemyYaw = VectorToAngles(self.enemy.origin - self.origin)[1];
	angleDiff  = AngleClamp180( toEnemyYaw - self.angles[1] );

	if( abs( angleDiff ) > anim.moveGlobals.MAX_RUN_N_GUN_ANGLE )
		return false;

	if( self.shootStyle != "none" || ( IsDefined( self.scriptenemy ) && self.scriptenemy == self.enemy ) )
		return true;

	return false;
}

RunNGunChooseRunAnimName()
{
	runAnimName = "run_n_gun";

	if( self isCQB() ) // switch to CQB runNGun if needed
	{
		if( self.movemode == "walk" || self.walk )
			runAnimName = "cqb_walk";
		else if( self.sprint )
			runAnimName = "cqb_sprint";
		else
			runAnimName = "cqb_run";
	}

	return runAnimName;
}

RunNGunForward() // forward run and gun
{
	runAnimName			= RunNGunChooseRunAnimName();
	runBackwardAnimName = animArrayPickRandom( runAnimName + "_b", "move", true );
	isCQB		= isCQB();
	
	if( isCQB )
		AimingOn( "cqb_f", 45 );
	
	// there are three animation for forward runNGun, F/L/R. Play one of them based on YAW to the enemy
	toEnemyYaw = VectorToAngles(self.enemy.origin - self.origin)[1];
	angleDiff  = AngleClamp180( toEnemyYaw - self.angles[1] );
		
	if( CanShootWhileRunningForward() || isCQB )				// enemy is in front - F, CQB only uses F anim
	{
		runForwardAnimName = runAnimName + "_f";
		AimingOn( "add_f", 45 ); // add_f/l/r corresponds to RunNGun additive aim animations
	}
	else if( abs( angleDiff ) < 100 )
	{
		if( angleDiff > 0 )										// enemy is on the left	- L
		{
			runForwardAnimName = runAnimName + "_l";
			AimingOn( "add_l", 45 ); // add_f/l/r corresponds to RunNGun additive aim animations
		}
		else															// enemy is on the right - R
		{
			runForwardAnimName = runAnimName + "_r";
			AimingOn( "add_r", 45 ); // add_f/l/r corresponds to RunNGun additive aim animations
		}
	}
	else if( abs( angleDiff ) < 135 && ( animArrayExist("run_n_gun_l_120") && animArrayExist("run_n_gun_r_120") ) )
	{
		if( angleDiff > 0 )										// enemy is on the left	- L
		{
			runForwardAnimName = runAnimName + "_l_120";
			AimingOn( "add_l_120", 45 ); // add_f/l/r corresponds to RunNGun additive aim animations
		}
		else
		{
			runForwardAnimName = runAnimName + "_r_120";
			AimingOn( "add_r_120", 45 ); // add_f/l/r corresponds to RunNGun additive aim animations
		}
	}
	else
	{
		// no supported runNGun animation exists, just return false
		return false;
	}
		
	runForwardAnimName = animArrayPickRandom(  runForwardAnimName, "move", true );

	// set the runNGun animation
	self SetFlaggedAnimKnob( "runanim", runForwardAnimName, 1, 0.2, self.runNGunRate );

	// dont partial reload right away
	self.a.allowedPartialReloadOnTheRunTime = gettime() + 500;

	// as there is only one RunNGun animation at a given time(F/L/R), we don't need to call updateRunAnimWeights thread.
	//self thread UpdateRunAnimWeightsThread( "runNGun", %combatrun_forward, runBackwardAnimName );

	return true;
}

RunNGunForwardToBackwardTransition() // transition to face the opposite direction of the lookahead
{
	toEnemyYaw  = VectorToAngles(self.enemy.origin - self.origin)[1];
	angleDiff   = AngleClamp180( toEnemyYaw - self.angles[1] );
	
	faceDir		= VectorScale(self.lookaheaddir, -1);
	faceAngle	= VectorToAngles(faceDir)[1];
	yawToEnemy	= AbsAngleClamp180( self.angles[1] - faceAngle );

	if( yawToEnemy > 175 )							// this means we can aim at the enemy while running forward
	{
		self thread stopShootWhileMovingThreads();  // stop shooting related threads
		self animscripts\shared::stopTracking();	// pause the trackLoop temporarily 

		if( angleDiff > 0 )
			transitionAnim = animArray("run_f_to_bR", "move");
		else
			transitionAnim = animArray("run_f_to_bL", "move");
	
		runAnimName			= "run_n_gun";
		self.a.turnAngle	= yawToEnemy * sign(angleDiff);
		self animscripts\turn::doTurn( transitionAnim, animArray(runAnimName + "_b"), -180, true );
		self OrientMode( "face angle", self.angles[1] );

		// set aims again as turn animation will clear it
		self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 ); 
		runShootWhileMovingThreads();				// start shooting related threads
		self animscripts\shared::trackLoopStart();	// unpause aiming trackloop back again
	}
}

RunNGunBackward() // backward run and gun
{
	runAnimName			= RunNGunChooseRunAnimName();
	runForwardAnimName	= animArrayPickRandom( runAnimName + "_f", "move", true ); // F
	runBackwardAnimName = animArrayPickRandom( runAnimName + "_b", "move", true ); // B

	AimingOn( "add_f", 50 ); // add_f corresponds to RunNGun additive aim animations
	
	// keep facing towards the opposite direction of lookahead, as if facing the enemy
	faceDir		= VectorScale(self.lookaheaddir, -1);
	faceAngle	= VectorToAngles(faceDir)[1]; 
	self OrientMode( "face angle", faceAngle );	

	// set the runNGun animation
	self SetFlaggedAnimKnob( "runanim", runBackwardAnimName, 1, 0.2, self.runNGunRate );

	// as there is only one RunNGun animation at a given time(F/L/R), we don't need to call updateRunAnimWeights thread.
	//self thread UpdateRunAnimWeightsThread( "runNGun", runForwardAnimName, runBackwardAnimName );

	return true;
}

StopRunNGun()
{
	self ClearAnim( %run_n_gun_f, 0.2 );
	self ClearAnim( %run_n_gun_r, 0.2 );
	self ClearAnim( %run_n_gun_l, 0.2 );
	self ClearAnim( %ai_run_n_gun_l_120, 0.2 );
	self ClearAnim( %ai_run_n_gun_l_120, 0.2 );

	AimingOff();
}

//--------------------------------------------------------------------------------
// CombatRun Locomotion - AI does not have an enemy or somehow can't shoot while moving
//--------------------------------------------------------------------------------
CombatRun() // regular combat run
{
	isCQB		= isCQB(); // We need to turn on aiming if CQB walking and has a cqb_point_of_interest or cqb_target

	if( isCQB && IsDefined( self.cqb_point_of_interest) || IsDefined(self.cqb_target ) )
		AimingOn( "cqb_f", 45 ); 

	self OrientMode( "face motion" ); // always face motion when in combatRun

	runAnim = GetRunAnim();

	self SetFlaggedAnimKnob("runanim", runAnim, 1, 0.5, self.moveplaybackrate );
	self thread UpdateRunAnimWeightsThread( "combatRun", %combatrun_forward, animArray("combat_run_b"), animArray("combat_run_l"), animArray("combat_run_r") );
}

//--------------------------------------------------------------------------------
// MoveStandNoncombatNormal
//--------------------------------------------------------------------------------
MoveStandNoncombatNormal()
{
	self endon("movemode");

	self ClearAnim(%combatrun, 0.6);
	self SetAnimKnobAll(%combatrun, %body, 1, 0.2, self.moveplaybackrate);

	prerunAnim = GetRunAnim();

	self SetFlaggedAnimKnob( "runanim", prerunAnim, 1, 0.3 );
	self thread UpdateRunAnimWeightsThread( "NonCombat", %combatrun_forward, animArray("combat_run_b"), animArray("combat_run_l"), animArray("combat_run_r") );

	DoNoteTracksNoShootStandCombat( "runanim" );
}

//--------------------------------------------------------------------------------
// MoveStandNoncombatOverride
//--------------------------------------------------------------------------------
MoveStandNoncombatOverride()
{
	self endon("movemode");

	self ClearAnim(%combatrun, 0.6);
	self SetFlaggedAnimKnobAll("runanim", self.run_noncombatanim, %body, 1, 0.3, self.moveplaybackrate );

	DoNoteTracksNoShootStandCombat( "runanim" );
}

//--------------------------------------------------------------------------------
// ShouldReloadWhileRunning
//--------------------------------------------------------------------------------
ShouldReloadWhileRunning()
{
	/#
	if( shouldForceBehavior("reload") )
		return true;
	#/

	reloadIfEmpty = IsDefined( self.a.allowedPartialReloadOnTheRunTime ) && self.a.allowedPartialReloadOnTheRunTime > GetTime();
	reloadIfEmpty = reloadIfEmpty || ( IsDefined( self.enemy ) && DistanceSquared( self.origin, self.enemy.origin ) < anim.moveGlobals.MIN_RELOAD_DISTSQ );
	
	if ( reloadIfEmpty )
	{
		if( !self NeedToReload( 0 ) )
			return false;
	}
	else
	{
		if( !self NeedToReload( .5 ) )
			return false;
	}
	
	if( ShouldTacticalWalk() )
		return false;

	CanShootWhileRunning = animscripts\move::MayShootWhileMoving() 
						   && isValidEnemy( self.enemy ) 
						   && ( CanShootWhileRunningForward() || CanShootWhileRunningBackward() );
						   
	if( CanShootWhileRunning && !self NeedToReload( 0 ) )
		return false;
	
	// dont start reloading very close to the goal
	if( !IsDefined( self.pathGoalPos ) || DistanceSquared( self.origin, self.pathGoalPos ) < anim.moveGlobals.MIN_RELOAD_DISTSQ )
		return false;

	// want to be running forward; otherwise we won't see the animation play!
	motionAngle = AngleClamp180( self getMotionAngle() ); // motion angle is the difference between current YAW and lookahead direction
	if( abs( motionAngle ) > 25 )
		return false;
	
	if( self WeaponAnims() != "rifle" )
	{
		if( !(self WeaponAnims() == "pistol" && IsDefined( self.forceSideArm ) && self.forceSideArm ) )
			return false; 
	}

	// rusher AI should not reload, as its against the tactic
	if( self is_rusher() )
		return false;
	
	// need to restart the run cycle because the reload animation has to be played from start to finish!
	// the goal is to play it only when we're near the end of the run cycle.
	if( !runLoopIsNearBeginning() )
		return false;

	return true;
}

//--------------------------------------------------------------------------------
// ReloadStandRun
//--------------------------------------------------------------------------------
ReloadStandRun() // reloading while running
{
	if( !ShouldReloadWhileRunning() )
		return false;
	
	// call in a separate function so we can cleanup if we get an endon
	ReloadStandRunInternal();
	
	// notify "abort_reload" in case the reload didn't finish, maybe due to "movemode" notify. works with handleDropClip() in shared.gsc
	self notify("abort_reload");

	self orientmode( "face default" );

	return true;
}

runLoopIsNearBeginning()
{
	// there are actually 3 loops (left foot, right foot) in one animation loop.
	animfraction  = self getAnimTime( %walk_and_run_loops );
	loopLength	  = getAnimLength( animscripts\run::GetRunAnim() ) / 3.0;
	animfraction *= 3.0;

	if ( animfraction > 3 )
		animfraction -= 2.0;
	else if ( animfraction > 2 )
		animfraction -= 1.0;
	
	if ( animfraction < .15 / loopLength )
		return true;
	
	if ( animfraction > 1 - .3 / loopLength )
		return true;

	return false;
}

ReloadStandRunInternal()
{
	self endon("movemode");

	self orientmode( "face motion" );

	self delay_thread( 0.05, animscripts\shared::stopTracking ); // delay tracking may have started on this frame

	flagName = "reload_" + getUniqueFlagNameIndex();
	flagName = "reload_" + getUniqueFlagNameIndex();

	reloadAnim = undefined;

	if( self isCQB() ) 
	{
		if( self.movemode == "walk" || self.walk )
			reloadAnim = animArrayPickRandom("cqb_reload_walk");
		else
			reloadAnim = animArrayPickRandom("cqb_reload_run");
	}
	else
	{
		reloadAnim = animArrayPickRandom("reload");
	}

	assert( IsDefined(reloadAnim) );

	self SetFlaggedAnimKnobAllRestart( flagName, reloadAnim, %body, 1, 0.25 );
	animscripts\shared::DoNoteTracks( flagName );

	self animscripts\shared::trackLoopStart();	// unpause aiming trackloop back again
}

//--------------------------------------------------------------------------------
// Aiming while running
//--------------------------------------------------------------------------------
AimingOn( aimAnimName, aimLimit )
{
	if( !IsDefined( aimAnimName ) )
		aimAnimName = "add_f";

	self.a.isAiming = true;
	self.aimAngleOffset = 0;
	isPistolTacticalWalkAim = IsSubStr( aimAnimName, "tactical" ) && AIHasOnlyPistol();

	// special case handler for AI using smg weapons that end up using pistol animation set
	// SUMEET - This is probably not the best way to do this but hoping that there are not that many cases where it needed
	if( AIHasOnlyPistolOrSMG() )
	{
		if ( IsSubStr( aimAnimName, "tactical" ) )
		{
			isPistolTacticalWalkAim = true;
		}
		else
		{
			// In this case the aiming must being coming in from RunNGun then clear tactical aims. 
			// this needs to be specially handled because, normal pistol AI does not RunNGun 
			self clearAnim( %tactical_walk_pistol_aim2, 0 );
			self clearAnim( %tactical_walk_pistol_aim4, 0 );
			self clearAnim( %tactical_walk_pistol_aim6, 0 );
			self clearAnim( %tactical_walk_pistol_aim8, 0 );
		}
	}	

	if( isPistolTacticalWalkAim )
		self animscripts\shared::setAimingAnims( %tactical_walk_pistol_aim2, %tactical_walk_pistol_aim4, %tactical_walk_pistol_aim6, %tactical_walk_pistol_aim8 );	
	else
		self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 );

	if( !IsDefined(aimLimit) )
		aimLimit = 50;
	
	self.rightAimLimit	= aimLimit;
	self.leftAimLimit	= aimLimit * -1;
	self.upAimLimit		= aimLimit;
	self.downAimLimit	= aimLimit * -1;
		
	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_up"    ), 1, 0.2 );
	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_down"  ), 1, 0.2 );
	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_left"  ), 1, 0.2 );
	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_right" ), 1, 0.2 );
}

AimingOff()
{
	self.a.isAiming = false;

	self ClearAnim( self.a.aim_2, 0.2 );
	self ClearAnim( self.a.aim_4, 0.2 );
	self ClearAnim( self.a.aim_6, 0.2 );
	self ClearAnim( self.a.aim_8, 0.2 );
}

runShootWhileMovingThreads() // decide what and how to shoot while moving
{
	self notify("want_shoot_while_moving");

	if ( IsDefined( self.shoot_while_moving_thread ) )
		return;

	self.shoot_while_moving_thread = true;

	self thread RunDecideWhatAndHowToShoot();
	self thread RunShootWhileMoving();
}

RunDecideWhatAndHowToShoot() // decides shootEnt and the shootStyle
{
	self endon("killanimscript");
	self endon("end_shoot_while_moving");

	self animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
}

RunShootWhileMoving() // play's additive shoot animation eventually
{
	self endon("killanimscript");
	self endon("end_shoot_while_moving");

	self animscripts\move::shootWhileMoving();
}

StopShootWhileMovingThreads()
{
	self endon("killanimscript");
	self endon("want_shoot_while_moving");

	wait .05;

	self notify("end_shoot_while_moving");
	self.shoot_while_moving_thread = undefined;
}

//--------------------------------------------------------------------------------
// UpdateRunAnimWeightsThread
//--------------------------------------------------------------------------------
UpdateRunAnimWeightsThread( moveAnimType, frontAnim, backAnim, leftAnim, rightAnim )
{
	// if this thread is already running for current moveAnimType, then dont run it again
	if( isdefined( self.a.update_move_anim_type ) && self.a.update_move_anim_type == moveAnimType )
		return;	

	self notify("stop_move_anim_update"); // kills the old thread when the moveAnimType changes
	
	self.a.update_move_anim_type = moveAnimType;
	
	self endon("killanimscript");
	self endon("stop_move_anim_update");

	while(1)
	{
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait(0.05);
	}
}	

StopUpdateRunAnimWeights()
{
	self notify( "stop_move_anim_update" );
	self.a.update_move_anim_type = undefined;
}

UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim )
{
	const blendTime	= 0.1;
	const rate		= 1;
	
	if( self ShouldFaceMotionWhileRunning() )
		yawDiff = self GetLookaheadAngle();
	else
		yawDiff = self getMotionAngle();

	// calculate the weights
	animWeights = animscripts\utility::QuadrantAnimWeights( yawDiff );

	// back animation will not blend into any other animation
	if( animWeights["back"] > 0 )
	{
		animWeights["back"]  = 1;
		animWeights["left"]  = 0;
		animWeights["right"] = 0;	
	}

	// play the anims
	self SetAnim( frontAnim, animWeights["front"], blendTime, rate );
	self SetAnim( backAnim,  animWeights["back"] , blendTime, rate );

	if( IsDefined( leftAnim ) )
		self SetAnim(leftAnim,  animWeights["left"] , blendTime, rate );
	
	if( IsDefined( rightAnim ) )
		self SetAnim( rightAnim, animWeights["right"], blendTime, rate );
}

UpdateRunWeights( notifyString, frontAnim, backAnim, leftAnim, rightAnim ) // only used by setposemovement.gsc
{
	self endon("killanimscript");
	self endon(notifyString);

	if ( GetTime() == self.a.scriptStartTime )
	{
		// our motion angle might change very quickly as we start to run, so reset the anim weights after one frame
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait 0.05;
	}

	for (;;)
	{
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait getRunAnimUpdateFrequency();
	}
}

//--------------------------------------------------------------------------------
// MoveCrouchRunOverride
//--------------------------------------------------------------------------------
MoveCrouchRunOverride()
{
	self endon("movemode");

	self SetFlaggedAnimKnobAll( "runanim", self.crouchrun_combatanim, %body, 1, 0.4, self.moveplaybackrate );
	animscripts\shared::DoNoteTracksForTime( 0.2, "runanim" );
}

//--------------------------------------------------------------------------------
// MoveCrouchRunNormal
//--------------------------------------------------------------------------------
MoveCrouchRunNormal()
{
	self ClearAnim( %walk_and_run_loops, 0.2 );
	self setanimknob( %combatrun, 1.0, 0.5, self.moveplaybackrate );
	
	AimingOff();	// One of the available locomotions will call aimingOn() if necessary
	self OrientMode( "face motion" ); // always face motion when in crouch

	// cheat the ammo if necessary
	if( !self.bulletsInClip )
		cheatAmmoIfNecessary();

	if( animscripts\move::MayShootWhileMoving() && self.bulletsInClip > 0 && isValidEnemy( self.enemy )  )		
	{
		animscripts\run::StopUpdateRunAnimWeights(); // stop updateRunAnimWeights thread if that is running before starting new locomotion
		runShootWhileMovingThreads();				 // decide what and how to shoot while moving, and then shoot it

		/#RunDebugInfo();#/

		if ( IsPlayer( self.enemy ) )
			self updatePlayerSightAccuracy();

		AimingOn( "add_f" );
	}

	runAnim = GetCrouchRunAnim();
	self SetFlaggedAnimKnob("runanim", runAnim, 1, 0.5 );

	// As crouch run is forward only locmotion we do not need sideways animations
	//self thread UpdateRunAnimWeightsThread( "crouchRun", %combatrun_forward, animArray("combat_run_b"),	animArray("combat_run_l"),animArray("combat_run_r") );

	DoNoteTracksNoShootStandCombat("runanim");
	self thread stopShootWhileMovingThreads();

	return true;
}

GetCrouchRunAnim()
{
	if ( IsDefined( self.a.crouchRunAnim ) )
		return self.a.crouchRunAnim;
	
	if( self.a.pose != "crouch" )
		return animArray("crouch_run_f", "move");	
	
	return animArray("combat_run_f", "move");
}

//--------------------------------------------------------------------------------
// ProneCrawl
//--------------------------------------------------------------------------------
ProneCrawl()
{
	self.a.movement = "run";
	self SetFlaggedAnimKnob( "runanim", animArray("combat_run_f"), 1, .3, self.moveplaybackrate );
	animscripts\shared::DoNoteTracksForTime(0.25, "runanim");
}

//--------------------------------------------------------------------------------
// Run utility functions
//--------------------------------------------------------------------------------
CanShootWhileRunningForward() // can I shoot while moving forward?
{
	if( abs( self getMotionAngle() ) > anim.moveGlobals.MOTION_ANGLE_OFFSET )
		return false;

	enemyyaw = self GetPredictedYawToEnemy( 0.2 );
	if( abs( enemyyaw ) <= anim.moveGlobals.AIM_YAW_THRESHOLD )
		return true;

	return false;
}

CanShootWhileRunningBackward() // can I shoot while moving backward?
{
	if ( 180 - abs( self getMotionAngle() ) >= anim.moveGlobals.MOTION_ANGLE_OFFSET )
		return false;

	enemyyaw = self GetPredictedYawToEnemy( 0.2 );
	if ( abs( enemyyaw ) > anim.moveGlobals.AIM_YAW_THRESHOLD )
		return false;

	return true;
}

ShouldShootWhileRunningBackward()
{
	// tactical walk overrides CQB walking. As CQB walking forward only locomotion, if AI is not tactical walking, 
	// it should not walk backwards.
	if( self isCQB() && !self ShouldTacticalWalk() )
		return false;
	
	// for certain AI types we can disable backward RunNGun
	if( IS_TRUE( self.a.disableBackWardRunNGun ) )
		return false;

	if( isValidEnemy( self.enemy ) )
	{
		toEnemy = self.enemy.origin - self.origin;
		toEnemyYaw = VectorToAngles(toEnemy)[1];

		toGoalYaw = VectorToAngles(self.lookaheadDir)[1];

		if( AbsAngleClamp180( toEnemyYaw - toGoalYaw ) >= ( anim.moveGlobals.AIM_YAW_THRESHOLD * 2 ) ) // 120 Deg - aim angle max is 60
		{
			closeToGoal = false;
			isAlreadyRunningBackwards = ( Abs( self GetMotionAngle() ) >= anim.moveGlobals.AIM_YAW_THRESHOLD * 2 );

			// if not tactical walking, don't turn backwards if very close to goal, unless already running backwards
			if( !isAlreadyRunningBackwards )
			{
				if( !ShouldTacticalWalk() && ( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) < 250 * 250 ) )
					closeToGoal = true;
			}
			
			// check the lookahead length, if its smaller than say 150 units then there is a chance that we are cutting corners
			// if its greater than 150 that means that there is a high chance that we are going straight
			if( self.lookaheaddist < 150 && !isAlreadyRunningBackwards )
				return false;

			if( DistanceSquared(self.enemy.origin, self.origin) < GetRunBackwardsDistanceSquared() && !closeToGoal )
				return true;
		}
	}

	return false;
}

GetRunBackwardsDistanceSquared()
{
	if( ShouldTacticalWalk() )
	{
		// pistol and CQB walk do not run backwards that far. They also dont RunNGun
		if( isCQB() || self AIHasOnlyPistol() )
			return anim.moveGlobals.RUNBACKWARDS_CQB_DISTSQ;
		else
			return anim.moveGlobals.RUNBACKWARDS_DISTSQ;
	}
	
	return 0;
}

ShouldFaceMotionWhileRunning()
{
	// if code thinks that we should not be facing motion then respect that.
	// this will be usually true within maxFaceEnemyDistSq which is set to 512 units.
	if( self ShouldFaceMotion() )
		return true;

	return false;
}

GetLookaheadAngle()
{
	yawDiff = VectorToAngles(self.lookaheaddir)[1] - self.angles[1];
	yawDiff = yawDiff * (1.0 / 360.0);
	yawDiff = (yawDiff - floor(yawDiff + 0.5)) * 360.0;

	return yawDiff;
}

DoNoteTracksNoShootStandCombat(animName)
{
	animscripts\shared::DoNoteTracksForTime( 0.05, animName );	// 0.05 because of getRunAnimUpdateFrequency();
}

getRunAnimUpdateFrequency()
{
	return 0.05; //GetDvarFloat( "ai_runAnimUpdateFrequency");
}


GetPredictedYawToEnemy( lookAheadTime )
{
	assert( isValidEnemy( self.enemy ) );

	// don't run this more than once per frame
	if( IsDefined(self.predictedYawToEnemy) && IsDefined(self.predictedYawToEnemyTime) && self.predictedYawToEnemyTime == GetTime() )
		return self.predictedYawToEnemy;

	selfPredictedPos = self.origin;
	moveAngle = self.angles[1] + self getMotionAngle();
	selfPredictedPos += (cos( moveAngle ), sin( moveAngle ), 0) * 200.0 * lookAheadTime;

	yaw = self.angles[1] - VectorToAngles(self.enemy.origin - selfPredictedPos)[1];
	yaw = AngleClamp180( yaw );

	// cache
	self.predictedYawToEnemy = yaw;
	self.predictedYawToEnemyTime = GetTime();

	return yaw;
}

GetRunAnim()
{
	run_anim = undefined;

	if( self isCQB() && self.a.pose == "stand" ) 
	{
		if ( self.movemode == "walk" || self.walk )
			run_anim = animArrayPickRandom("cqb_walk_f", "move", true);
		else if( self.sprint )
			run_anim = animArrayPickRandom("cqb_sprint_f", "move", true);
		else
			run_anim = animArrayPickRandom("cqb_run_f", "move", true);
	}
	else if ( IsDefined( self.a.combatRunAnim ) )
	{
		run_anim = self.a.combatRunAnim;
	}
	else if( self.sprint && self.a.pose == "stand" )
	{
		if( IsDefined( self.a.fullSprintAnim ) )
		{
			run_anim = self.a.fullSprintAnim;
		}
		else
		{
			run_anim = animArrayPickRandom("sprint", "move");
			self.a.fullSprintAnim = run_anim;
		}
	}
	else if( self.a.isAiming && self.a.pose == "stand" )
	{
		run_anim = animArray("run_n_gun_f", "move");
	}
	else
	{
		run_anim = animArray("combat_run_f", "move");
	}

	assert(IsDefined(run_anim), "run.gsc - No run animation for this AI.");

	return run_anim;
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------
run_end_script()
{
	self.a.fullSprintAnim = undefined;
}

//--------------------------------------------------------------------------------
// Debug
//--------------------------------------------------------------------------------
/#
RunDebugInfo()
{
	if( GetDvarInt( "ai_showPaths") > 1 )
	{
		if( IsDefined( self.enemy ) )
		{
			dist = Distance2D( self.origin, self.enemy.origin );
			recordEntText( "DistanceToEnemy - " + dist, self, level.color_debug["white"], "Script" );

			faceAngle	= VectorToAngles(self.lookaheaddir)[1];
			toEnemyYaw  = VectorToAngles(self.enemy.origin - self.origin)[1];
			angleDiff   = AngleClamp180( toEnemyYaw - faceAngle );
			
			recordEntText( "Enemy Yaw: " + angleDiff + " Predicted enemy yaw: " + (self GetPredictedYawToEnemy( 0.2 )) + " motion angle: " + abs( self getMotionAngle() ), self, level.color_debug["yellow"], "Animscript" );

			if( self.FaceMotion )
				recordEntText( "FaceMotion", self, level.color_debug["yellow"], "Animscript" );
			else
				recordEntText( "FaceEnemy", self, level.color_debug["yellow"], "Animscript" );

			if( IsDefined( self.relativeDir ) )
			{
				relativeDir = "UNKNOWN_DIRECTION";

				switch( self.relativeDir )
				{
				case 1: 
					relativeDir = "FRONT";
					break;
				case 2: 
					relativeDir = "RIGHT";
					break;
				case 3: 
					relativeDir = "LEFT";
					break;
				case 4: 
					relativeDir = "BACK";
					break;
				case 0:
				default:
					relativeDir = "NONE";
					break;
				}

				recordEntText( relativeDir, self, level.color_debug["red"], "Animscript" );
			}
		}
		else
		{
			recordEntText( "motion angle: " + abs( self getMotionAngle() ), self, level.color_debug["yellow"], "Animscript" );
		}

		// bullets in clip
		if( IsDefined( self.weapon ) )
			recordEntText( "Bullets - " + self.bulletsInClip, self, level.color_debug["white"], "Script" );

		// distance to goal
		if ( IsDefined( self.pathGoalPos ) )
		{
			// don't face motion if moving small distance
			dist = Distance( self.pathStartPos, self.pathGoalPos );
			recordEntText( "DistanceFromStartToGoal - " + dist, self, level.color_debug["white"], "Script" );

			dist = Distance( self.origin, self.pathGoalPos );
			recordEntText( "DistanceToGoal - " + dist, self, level.color_debug["white"], "Script" );

			dist = Distance( self.origin, self.pathGoalPos );
			recordEntText( "LookAheadDist - " + self.lookaheaddist, self, level.color_debug["white"], "Script" );
		}

	}
}
#/
