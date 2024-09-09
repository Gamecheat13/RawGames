#include animscripts\Utility;
#include animscripts\notetracks;
#include animscripts\Combat_Utility;
#include animscripts\SetPoseMovement;
#include common_scripts\utility;
#using_animtree( "generic_human" );

MoveRun()
{
	desiredPose = [[ self.choosePoseFunc ]]( "stand" );

	switch( desiredPose )
	{
	case "stand":
		if ( StandRun_Begin() )	// returns false( and does nothing ) if we're already stand - running
			return;

		if ( IsDefined( self.run_overrideanim ) )
		{
			animscripts\move::MoveStand_MoveOverride( self.run_overrideanim, self.run_override_weights );
			return;
		}

		if ( StandRun_CheckChangeWeapon() )
			return;

		if ( StandRun_CheckReload() )
			return;

		self animscripts\utility::UpdateIsInCombatTimer();
		if ( self animscripts\utility::IsInCombat() )
			StandRun_CombatNormal();
		else
			StandRun_NonCombatNormal();
		break;

	case "crouch":
		if ( CrouchRun_Begin() )// returns false( and does nothing ) if we're already crouch - running
			return;

		if ( IsDefined( self.crouchrun_combatanim ) )
			CrouchRun_RunOverride();
		else
			CrouchRun_RunNormal();
		break;

	default:
		assert( desiredPose == "prone" );
		if ( ProneRun_Begin() )// returns false( and does nothing ) if we're already prone - running
			return;

		ProneCrawl();
		break;
	}
}

GetRunAnim()
{
	if ( !IsDefined( self.a.moveAnimSet ) )
		return self lookupAnim( "run", "straight" );
		
	if ( !self.faceMotion )
	{
		if ( self.stairsState == "none" || abs( self getMotionAngle() ) > 45 )
			return GetMoveAnim( "move_f" );
	}

	if ( self.stairsState == "up" )
		return GetMoveAnim( "stairs_up" );
	else if ( self.stairsState == "down" )
		return GetMoveAnim( "stairs_down" );
	else if (usingSMG())
		return GetMoveAnim( "smg_straight" );

	return GetMoveAnim( "straight" );
}

GetCrouchRunAnim()
{
	if ( !IsDefined( self.a.moveAnimSet ) )
	{
		if ( usingSMG() )
		{
			return self lookupAnim( "smg_crouch_run", "crouch" );
		}
		else
		{
			return self lookupAnim( "run", "crouch" );
		}
	}
		
	return GetMoveAnim( "crouch" );
}


ProneCrawl()
{
	self.a.movement = "run";
	self SetFlaggedAnimKnob( "runanim", GetMoveAnim( "prone" ), 1, .3, self.movePlaybackRate );
	DoNoteTracksForTime( 0.25, "runanim" );
}


InitRunNGun()
{
	if ( !IsDefined( self.runNGun ) )
	{
		self notify( "stop_move_anim_update" );
		self.update_move_anim_type = undefined;
		
		self ClearAnim( %combatrun_backward, 0.2 );
		self ClearAnim( %combatrun_right, 0.2 );
		self ClearAnim( %combatrun_left, 0.2 );
		
		self ClearAnim( %w_aim_2, 0.2 );
		self ClearAnim( %w_aim_4, 0.2 );
		self ClearAnim( %w_aim_6, 0.2 );
		self ClearAnim( %w_aim_8, 0.2 );
		
		self.runNGun = true;
	}
}

StopRunNGun()
{
	if ( IsDefined( self.runNGun ) )
	{
		self ClearAnim( %run_n_gun, 0.2 );
		self.runNGun = undefined;
	}
	
	return false;
}


RunNGun( bValidTarget )
{
	if ( bValidTarget )
	{
		enemyYaw = self GetPredictedYawToEnemy( 0.2 );
		leftWeight = enemyYaw < 0;
	}
	else
	{
		enemyYaw = 0;
		leftWeight = self.runNGunWeight < 0;
	}
	
	rightWeight = 1 - leftWeight;
	
	maxRunNGunAngle = self.maxRunNGunAngle;
	runNGunTransitionPoint = self.runNGunTransitionPoint;
	runNGunIncrement = self.runNGunIncrement;

	if ( !bValidTarget || ( squared( enemyYaw ) > maxRunNGunAngle * maxRunNGunAngle ) )
	{
		// phase out run n gun
		self ClearAnim( %add_fire, 0 );
		if ( squared( self.runNGunWeight ) < runNGunIncrement * runNGunIncrement )
		{
			self.runNGunWeight = 0;
			self.runNGun = undefined;
			return false;
		}
		else if ( self.runNGunWeight > 0 )
		{
			self.runNGunWeight = self.runNGunWeight - runNGunIncrement;
		}
		else
		{
			self.runNGunWeight = self.runNGunWeight + runNGunIncrement;
		}
	}
	else
	{
		newWeight = enemyYaw / maxRunNGunAngle;
		diff = newWeight - self.runNGunWeight;
		
		if ( abs( diff ) < runNGunTransitionPoint * 0.7 )
			self.runNGunWeight = newWeight;
		else if ( diff > 0 )
			self.runNGunWeight = self.runNGunWeight + runNGunIncrement;
		else
			self.runNGunWeight = self.runNGunWeight - runNGunIncrement;
	}

	InitRunNGun();
	
	absRunNGunWeight = abs( self.runNGunWeight );
	runNGunAnims = self lookupAnimArray( "run_n_gun" );

	if ( absRunNGunWeight > runNGunTransitionPoint )
	{
		weight = ( absRunNGunWeight - runNGunTransitionPoint ) / runNGunTransitionPoint;
		weight = clamp( weight, 0, 1 );

		self ClearAnim( runNGunAnims[ "F" ], 0.2 );
		self SetAnimLimited( runNGunAnims[ "L" ], ( 1.0 - weight ) * leftWeight, 0.2 );
		self SetAnimLimited( runNGunAnims[ "R" ], ( 1.0 - weight ) * rightWeight, 0.2 );
		self SetAnimLimited( runNGunAnims[ "LB" ], weight * leftWeight, 0.2 );
		self SetAnimLimited( runNGunAnims[ "RB" ], weight * rightWeight, 0.2 );
	}
	else
	{
		weight = clamp( absRunNGunWeight / runNGunTransitionPoint, 0, 1 );

		self SetAnimLimited( runNGunAnims[ "F" ], 1.0 - weight, 0.2 );
		self SetAnimLimited( runNGunAnims[ "L" ], weight * leftWeight, 0.2 );
		self SetAnimLimited( runNGunAnims[ "R" ], weight * rightWeight, 0.2 );
		
		if ( runNGunTransitionPoint < 1 )
		{
			self ClearAnim( runNGunAnims[ "LB" ], 0.2 );
			self ClearAnim( runNGunAnims[ "RB" ], 0.2 );
		}
	}

	self SetFlaggedAnimKnob( "runanim", %run_n_gun, 1, 0.3, 0.8 );

	self.a.allowedPartialReloadOnTheRunTime = gettime() + 500;

	if ( bValidTarget && IsPlayer( self.enemy ) )
		self UpdatePlayerSightAccuracy();

	return true;
}

RunNGun_Backward()
{
	// we don't blend the running-backward animation because it
	// doesn't blend well with the run-left and run-right animations.
	// it's also easier to just play one animation than rework everything
	// to consider the possibility of multiple "backwards" animations

	InitRunNGun();

	back_anim = self lookupAnim( "run_n_gun", "move_back" );
	self SetFlaggedAnimKnob( "runanim", back_anim, 1, 0.3, 0.8 );

	if ( IsPlayer( self.enemy ) )
		self UpdatePlayerSightAccuracy();

	DoNoteTracksForTime( 0.2, "runanim" );

	//self thread StopShootWhileMovingThreads();

	self ClearAnim( back_anim, 0.2 );
}


ReactToBulletsInterruptCheck()
{
	self endon( "killanimscript" );
	
	while ( 1 )
	{
		wait 0.2;
			
		if ( !IsDefined( self.reactingToBullet ) )
			break;
			
		if ( !IsDefined( self.pathGoalPos ) || distanceSquared( self.pathGoalPos, self.origin ) < squared( 80 ) )
		{
			EndRunningReactToBullets();
			self notify( "interrupt_react_to_bullet" );
			break;			
		}
	}
}

EndRunningReactToBullets()
{
	self orientmode( "face default" );
	self.reactingToBullet = undefined;
	self.requestReactToBullet = undefined;
}

RunningReactToBullets()
{
	self.aim_while_moving_thread = undefined;
	self notify( "end_face_enemy_tracking" );

/#
	assert( !IsDefined( self.trackLoopThread ) );
	self.trackLoopThread = undefined;
#/

	self endon( "interrupt_react_to_bullet" );

	self.reactingToBullet = true;
	self orientmode( "face motion" );

	reactAnimArray = lookupAnimArray( "running_react_to_bullets" );

	reactAnimIndex = randomint( reactAnimArray.size );
	if ( reactAnimIndex == anim.lastRunningReactAnim )
		reactAnimIndex = ( reactAnimIndex + 1 ) % reactAnimArray.size;

	anim.lastRunningReactAnim = reactAnimIndex;
		
	reactAnim = reactAnimArray[ reactAnimIndex ];
	self SetFlaggedAnimKnobRestart( "reactanim", reactAnim, 1, 0.5, self.movePlaybackRate );
	
	self thread ReactToBulletsInterruptCheck();
	self animscripts\shared::DoNoteTracks( "reactanim" );
	
	EndRunningReactToBullets();
}


CustomRunningReactToBullets()
{
	self.aim_while_moving_thread = undefined;
	self notify( "end_face_enemy_tracking" );

/#
	assert( !IsDefined( self.trackLoopThread ) );
	self.trackLoopThread = undefined;
#/

	self.reactingToBullet = true;
	self orientmode( "face motion" );
	
	assert( IsDefined( self.run_overrideBulletReact ) );

	reactAnimIndex = randomint( self.run_overrideBulletReact.size );
	reactAnim = self.run_overrideBulletReact[ reactAnimIndex ];

	self SetFlaggedAnimKnobRestart( "reactanim", reactAnim, 1, 0.5, self.movePlaybackRate );
	self thread ReactToBulletsInterruptCheck();
	self animscripts\shared::DoNoteTracks( "reactanim" );
	
	EndRunningReactToBullets();
}


GetSprintAnim()
{
	sprintAnim = undefined;
	
	if ( IsDefined( self.grenade ) )
		sprintAnim = GetMoveAnim( "sprint_short" );

	if ( !IsDefined( sprintAnim ) )
		sprintAnim = GetMoveAnim( "sprint" );
		
	return sprintAnim;
}

ShouldSprint()
{

/*
=============
///ScriptFieldDocBegin
"Name: .sprint"
"Summary: Make a guy sprint"
"Module: Stub"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/		
	if ( IsDefined( self.sprint ) )
		return true;
		
	if ( IsDefined( self.grenade ) && IsDefined( self.enemy ) && self.frontShieldAngleCos == 1 )
		return ( distanceSquared( self.origin, self.enemy.origin ) > 300 * 300 );
		
	return false;
}


ShouldSprintForVariation()
{
	if ( IsDefined( self.neverSprintForVariation ) )
		return false;
		
	if ( !self.faceMotion || self.stairsState != "none" )
		return false;
		
	time = gettime();
	
	if ( IsDefined( self.dangerSprintTime ) )
	{
		if ( time < self.dangerSprintTime )
			return true;
		
		// if already sprinted, don't do it again for at least 5 seconds
		if ( time - self.dangerSprintTime < 6000 )
			return false;
	}

	if ( !IsDefined( self.enemy ) || !IsSentient( self.enemy ) )
		return false;
		
	if ( randomInt( 100 ) < 25 && ( self lastKnownTime( self.enemy ) + 2000 ) > time )
	{
		self.dangerSprintTime = time + 2000 + randomint( 1000 );
		return true;
	}
	
	return false;
}

GetMovePlaybackRate()
{
	rate = self.moveplaybackrate;
	
	if ( self.lookaheadHitsStairs && self.stairsState == "none" && self.lookaheadDist < 300 )
		rate *= 0.75;
		
	return rate;
}

StandRun_CombatNormal()
{
	//self clearanim( %walk_and_run_loops, 0.2 );

	rate = GetMovePlaybackRate();
		
	self SetAnimKnob( %combatrun, 1.0, 0.5, rate );

	bDecidedAnimation = false;

	bMayReactToBullets = IsDefined( self.requestReactToBullet ) && gettime() - self.requestReactToBullet < 100;

	if ( bMayReactToBullets && randomFloat( 1 ) < self.a.reactToBulletChance )
	{
		StopRunNGun();
		SetShootWhileMoving( false );
		RunningReactToBullets();
		return;
	}
	
	if ( self ShouldSprint() )
	{
		self SetFlaggedAnimKnob( "runanim", GetSprintAnim(), 1, 0.5, self.movePlaybackRate );
		SetShootWhileMoving( false );
		bDecidedAnimation = true;
	}
	else if ( IsDefined( self.enemy ) && animscripts\move::MayShootWhileMoving() )
	{
		SetShootWhileMoving( true );

		if ( !self.faceMotion )
		{
			self thread FaceEnemyAimTracking();
		}
		else if ( ( self.shootStyle != "none" && !IsDefined( self.noRunNGun ) ) )
		{
			self notify( "end_face_enemy_tracking" );
			self.aim_while_moving_thread = undefined;

/#
			assert( !IsDefined( self.trackLoopThread ) );
			self.trackLoopThread = undefined;
#/

			if ( CanShootWhileRunningForward() )
			{
				bDecidedAnimation = self RunNGun( true );
			}
			else if ( CanShootWhileRunningBackward() )
			{
				self RunNGun_Backward();
				return;
			}
		}
		else if ( IsDefined( self.runNGunWeight ) && self.runNGunWeight != 0 )
		{
			// can't shoot enemy anymore but still need to clear out runNGun
			bDecidedAnimation = self RunNGun( false );
		}
	}
	else if ( IsDefined( self.runNGunWeight ) && self.runNGunWeight != 0 )
	{
		SetShootWhileMoving( false );
		bDecidedAnimation = self RunNGun( false );
	}
	else
	{
		SetShootWhileMoving( false );
	}

	if ( !bDecidedAnimation )
	{
		StopRunNGun();
	
		if ( bMayReactToBullets && self.a.reactToBulletChance != 0 )
		{
			RunningReactToBullets();
			return;
		}
		
		if ( ShouldSprintForVariation() )
			runAnim = GetMoveAnim( "sprint_short" );
		else
			runAnim = GetRunAnim();
			
		self SetFlaggedAnimKnobLimited( "runanim", runAnim, 1, 0.1, self.moveplaybackrate, true );
		self SetMoveNonForwardAnims( GetMoveAnim( "move_b" ), GetMoveAnim( "move_l" ), GetMoveAnim( "move_r" ), self.sideStepRate );

		// Play the appropriately weighted run animations for the direction he's moving
		self thread SetCombatStandMoveAnimWeights( "run" );
	}

	DoNoteTracksForTime( 0.2, "runanim" );

	//self thread StopShootWhileMovingThreads();
}

FaceEnemyAimTracking()
{
	//self notify( "want_aim_while_moving" );	// <- does not appear to be used anywhere...

	assert( IsDefined( self.aim_while_moving_thread ) == IsDefined( self.trackLoopThread ) );
	assertex( !IsDefined( self.trackLoopThread ) || (self.trackLoopThreadType == "faceEnemyAimTracking"), self.trackLoopThreadType );

	if ( IsDefined( self.aim_while_moving_thread ) )
		return;

	self.aim_while_moving_thread = true;

/#
	self.trackLoopThread = thisthread;
	self.trackLoopThreadType = "faceEnemyAimTracking";
#/

	self endon( "killanimscript" );
	self endon( "end_face_enemy_tracking" );

	self SetDefaultAimLimits();

	if ( ( !IsDefined( self.combatStandAnims ) ) || ( !IsDefined ( self.combatStandAnims["walk_aims"] ) ) )
	{
 		self SetAnimLimited( self lookupAnim( "walk", "aim_2" ) );
 		self SetAnimLimited( self lookupAnim( "walk", "aim_4" ) );
 		self SetAnimLimited( self lookupAnim( "walk", "aim_6" ) );
 		self SetAnimLimited( self lookupAnim( "walk", "aim_8" ) );
	}
	else
	{
		self SetAnimLimited( self.combatStandAnims["walk_aims"]["walk_aim_2"] );
		self SetAnimLimited( self.combatStandAnims["walk_aims"]["walk_aim_4"] );
		self SetAnimLimited( self.combatStandAnims["walk_aims"]["walk_aim_6"] );
		self SetAnimLimited( self.combatStandAnims["walk_aims"]["walk_aim_8"] );
	}
	self animscripts\track::TrackLoop( %w_aim_2, %w_aim_4, %w_aim_6, %w_aim_8 );
}

EndFaceEnemyAimTracking()
{
	self.aim_while_moving_thread = undefined;
	self notify( "end_face_enemy_tracking" );

/#
	assert( !IsDefined( self.trackLoopThread ) );
	self.trackLoopThread = undefined;
#/
}

SetShootWhileMoving( bShoot )
{
	bThreadsActive = IsDefined( self.bShootWhileMoving );
	if ( bShoot )
	{
		self.bShootWhileMoving = bShoot;
		if ( !bThreadsActive )
		{
			self thread RunDecideWhatAndHowToShoot();
			self thread RunShootWhileMoving();
		}
	}
	else
	{
		self.bShootWhileMoving = undefined;
		if ( bThreadsActive )
		{
			self notify( "end_shoot_while_moving" );
			self notify( "end_face_enemy_tracking" );
			self.shoot_while_moving_thread = undefined;
			self.aim_while_moving_thread = undefined;

			self.runNGun = undefined;
		}
	}
}

RunDecideWhatAndHowToShoot()
{
	self endon( "killanimscript" );
	self endon( "end_shoot_while_moving" );
	self animscripts\shoot_behavior::DecideWhatAndHowToShoot( "normal" );
}
RunShootWhileMoving()
{
	self endon( "killanimscript" );
	self endon( "end_shoot_while_moving" );
	self animscripts\move::ShootWhileMoving();
}

aimedSomewhatAtEnemy()
{
	weaponAngles = self GetMuzzleAngle();
	anglesToShootPos = vectorToAngles( self.enemy GetShootAtPos() - self GetMuzzlePos() );

	if ( AbsAngleClamp180( weaponAngles[ 1 ] - anglesToShootPos[ 1 ] ) > 15 )
		return false;

	return AbsAngleClamp180( weaponAngles[ 0 ] - anglesToShootPos[ 0 ] ) <= 20;
}

CanShootWhileRunningForward()
{
	// continue runNGun if runNGunWeight != 0
	if ( ( !IsDefined( self.runNGunWeight ) || self.runNGunWeight == 0 ) && abs( self GetMotionAngle() ) > self.maxRunNGunAngle )
		return false;

	return true;
}

CanShootWhileRunningBackward()
{
	if ( 180 - abs( self GetMotionAngle() ) >= 45 )
		return false;

	enemyYaw = self GetPredictedYawToEnemy( 0.2 );
	if ( abs( enemyYaw ) > 30 )
		return false;

	return true;
}

CanShootWhileRunning()
{
	return animscripts\move::MayShootWhileMoving() && IsDefined( self.enemy ) && ( CanShootWhileRunningForward() || CanShootWhileRunningBackward() );
}

GetPredictedYawToEnemy( lookAheadTime )
{
	assert( IsDefined( self.enemy ) );

	selfPredictedPos = self.origin;
	moveAngle = self.angles[ 1 ] + self GetMotionAngle();
	selfPredictedPos += ( cos( moveAngle ), sin( moveAngle ), 0 ) * length( self.velocity ) * lookAheadTime;

	yaw = self.angles[ 1 ] - VectorToYaw( self.enemy.origin - selfPredictedPos );
	yaw = AngleClamp180( yaw );
	return yaw;
}


StandRun_NonCombatNormal()
{
	self endon( "movemode" );

	self ClearAnim( %combatrun, 0.6 );

	rate = GetMovePlaybackRate();
	
	self SetAnimKnobAll( %combatrun, %body, 1, 0.2, rate );

	if ( self ShouldSprint() )
		runAnim = GetSprintAnim();
	else
		runAnim = GetRunAnim();

	if ( self.stairsState == "none" )
		transTime = 0.3;	// 0.3 because it pops when the AI goes from combat to noncombat
	else
		transTime = 0.1;	// need to transition to stairs quickly

	self SetFlaggedAnimKnob( "runanim", runAnim, 1, transTime, self.movePlaybackRate, true );

	self SetMoveNonForwardAnims( GetMoveAnim( "move_b" ), GetMoveAnim( "move_l" ), GetMoveAnim( "move_r" ) );
	self thread SetCombatStandMoveAnimWeights( "run" );

	blah = 0;
	// blend in a lean anim as necessary.  once i get the lean anims...
	if ( self.leanAmount > 0 && self.leanAmount < 0.998 )			// turning left
	{
		blah = 1;
	}
	else if ( self.leanAmount < 0 && self.leanAmount > -0.998 )		// turning right
	{
		blah = -1;
	}

	DoNoteTracksForTime( 0.2, "runanim" );
}

CrouchRun_RunOverride()
{
	self endon( "movemode" );

	self SetFlaggedAnimKnobAll( "runanim", self.crouchrun_combatanim, %body, 1, 0.4, self.moveplaybackrate );
	animscripts\shared::DoNoteTracks( "runanim" );
}

CrouchRun_RunNormal()
{
	self endon( "movemode" );

	// Play the appropriately weighted crouchrun animations for the direction he's moving
	forward_anim = GetCrouchRunAnim();

	self SetAnimKnob( forward_anim, 1, 0.4 );

	animset_name = "run";
	if ( usingSMG() )
	{
		animset_name = "smg_crouch_run";
	}

	self thread UpdateMoveAnimWeights( "crouchrun", forward_anim, self lookupAnim( animset_name, "crouch_b" ), self lookupAnim( animset_name, "crouch_l" ), self lookupAnim( animset_name, "crouch_r" ) );

	self SetFlaggedAnimKnobAll( "runanim", %crouchrun, %body, 1, 0.2, self.moveplaybackrate );

	DoNoteTracksForTime( 0.2, "runanim" );
}

StandRun_CheckReload()
{
	reloadIfEmpty = IsDefined( self.a.allowedPartialReloadOnTheRunTime ) && self.a.allowedPartialReloadOnTheRunTime > gettime();
	reloadIfEmpty = reloadIfEmpty || ( IsDefined( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 256 * 256 );
	if ( reloadIfEmpty )
	{
		if ( !self NeedToReload( 0 ) )
			return false;
	}
	else
	{
		if ( !self NeedToReload( .5 ) )
			return false;
	}

	if ( IsDefined( self.grenade ) )
		return false;

	if ( !self.faceMotion || self.stairsState != "none" )
		return false;

	// if not allowed to shoot, not allowed to reload
	if ( IsDefined( self.dontShootWhileMoving ) || IsDefined( self.noRunReload ) )
		return false;

	if ( self CanShootWhileRunning() && !self NeedToReload( 0 ) )
		return false;

	if ( !IsDefined( self.pathGoalPos ) || distanceSquared( self.origin, self.pathGoalPos ) < 256 * 256 )
		return false;

	motionAngle = AngleClamp180( self GetMotionAngle() );

	// want to be running forward; otherwise we won't see the animation play!
	if ( abs( motionAngle ) > 25 )
		return false;

	if ( !UsingRifleLikeWeapon() )
		return false;

	// need to restart the run cycle because the reload animation has to be played from start to finish!
	// the goal is to play it only when we're near the end of the run cycle.
	if ( !runLoopIsNearBeginning() )
		return false;

	// call in a separate function so we can cleanup if we get an endon
	StandRun_ReloadInternal();

	// notify "abort_reload" in case the reload didn't finish, maybe due to "movemode" notify. works with handleDropClip() in shared.gsc
	self notify( "abort_reload" );

	self orientmode( "face default" );

	return true;
}

StandRun_ReloadInternal()
{
	self endon( "movemode" );

	self orientmode( "face motion" );
	
	flagName = "reload_" + GetUniqueFlagNameIndex();

	self SetFlaggedAnimKnobAllRestart( flagName, self lookupAnim( "run", "reload" ), %body, 1, 0.25 );

	self.update_move_front_bias	 = true;

	self SetMoveNonForwardAnims( GetMoveAnim( "move_b" ), GetMoveAnim( "move_l" ), GetMoveAnim( "move_r" ) );
	self thread SetCombatStandMoveAnimWeights( "run" );
	animscripts\shared::DoNoteTracks( flagName );

	self.update_move_front_bias	 = undefined;
}

runLoopIsNearBeginning()
{
	// there are actually 3 loops (left foot, right foot) in one animation loop.

	animFraction = self GetAnimTime( %walk_and_run_loops );
	loopLength = GetAnimLength( self lookupAnim( "run", "straight" ) ) / 3.0;
	animFraction *= 3.0;
	if ( animFraction > 3 )
		animFraction -= 2.0;
	else if ( animFraction > 2 )
		animFraction -= 1.0;

	if ( animFraction < .15 / loopLength )
		return true;
	if ( animFraction > 1 - .3 / loopLength )
		return true;

	return false;
}

SetMoveNonForwardAnims( backAnim, leftAnim, rightAnim, rate )
{
	if ( !IsDefined( rate ) )
		rate = 1;
		
	self SetAnimKnobLimited( backAnim, 1, 0.1, rate, true );
	self SetAnimKnobLimited( leftAnim, 1, 0.1, rate, true );
	self SetAnimKnobLimited( rightAnim, 1, 0.1, rate, true );
}

SetCombatStandMoveAnimWeights( moveAnimType )
{
	UpdateMoveAnimWeights( moveAnimType, %combatrun_forward, %combatrun_backward, %combatrun_left, %combatrun_right );
}

UpdateMoveAnimWeights( moveAnimType, frontAnim, backAnim, leftAnim, rightAnim )
{
	if ( IsDefined( self.update_move_anim_type ) && self.update_move_anim_type == moveAnimType )
		return;

	self notify( "stop_move_anim_update" );

	self.update_move_anim_type = moveAnimType;
	self.wasFacingMotion = undefined;

	self endon( "killanimscript" );
	self endon( "move_interrupt" );
	self endon( "stop_move_anim_update" );

	for ( ;; )
	{
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait .05;
		waittillframeend;
	}
}

UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim )
{
	//assert( !IsDefined( self.runNGun ) || IsDefined( self.update_move_front_bias ) );

	if ( self.faceMotion && !self ShouldCQB() && !IsDefined( self.update_move_front_bias ) )
	{
		// once you start to face motion, don't need to change weights
		if ( !IsDefined( self.wasFacingMotion ) )
		{
			self.wasFacingMotion = 1;
			self SetAnim( frontAnim, 1, 0.2, 1, true );
			self SetAnim( backAnim, 0, 0.2, 1, true );
			self SetAnim( leftAnim, 0, 0.2, 1, true );
			self SetAnim( rightAnim, 0, 0.2, 1, true );
		}
	}
	else
	{
		self.wasFacingMotion = undefined;

		// Play the appropriately weighted animations for the direction he's moving.
	    animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );

    	if ( IsDefined( self.update_move_front_bias ) )
		{
			animWeights[ "back" ] = 0.0;
			if ( animWeights[ "front" ] < .2 )
				animWeights[ "front" ] = .2;
		}

	    self SetAnim( frontAnim, animWeights[ "front" ], 0.2, 1, true );
	    self SetAnim( backAnim, animWeights[ "back" ], 0.2, 1, true );
	    self SetAnim( leftAnim, animWeights[ "left" ], 0.2, 1, true );
	    self SetAnim( rightAnim, animWeights[ "right" ], 0.2, 1, true );
	}
}


// change our weapon while running if we want to and can
StandRun_CheckChangeWeapon()
{
	// right now this only handles shotguns, but it could do other things too
	bWantShotgun = ( IsDefined( self.wantShotgun ) && self.wantShotgun );
	bUsingShotgun = IsShotgun( self.weapon );
	if ( bWantShotgun == bUsingShotgun )
		return false;

	if ( !IsDefined( self.pathGoalPos ) || DistanceSquared( self.origin, self.pathGoalPos ) < 256 * 256 )
		return false;

	if ( UsingSidearm() )
		return false;
	assert( self.weapon == self.primaryWeapon || self.weapon == self.secondaryWeapon );

	if ( self.weapon == self.primaryweapon )
	{
		if ( !bWantShotgun )
			return false;
		if ( IsShotgun( self.secondaryWeapon ) )
			return false;
	}
	else
	{
		assert( self.weapon == self.secondaryWeapon );

		if ( bWantShotgun )
			return false;
		if ( IsShotgun( self.primaryWeapon ) )
			return false;
	}

	// want to be running forward; otherwise we won't see the animation play!
	motionAngle = AngleClamp180( self GetMotionAngle() );
	if ( abs( motionAngle ) > 25 )
		return false;

	if ( !RunLoopIsNearBeginning() )
		return false;

	if ( bWantShotgun )
		ShotgunSwitchStandRunInternal( "shotgunPullout", self lookupAnim( "cqb", "shotgun_pullout" ), "gun_2_chest", "none", self.secondaryweapon, "shotgun_pickup" );
	else
		ShotgunSwitchStandRunInternal( "shotgunPutaway", self lookupAnim( "cqb", "shotgun_putaway" ), "gun_2_back", "back", self.primaryweapon, "shotgun_pickup" );

	self notify( "switchEnded" );

	return true;
}

ShotgunSwitchStandRunInternal( flagName, switchAnim, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
	self endon( "movemode" );

	self SetFlaggedAnimKnobAllRestart( flagName, switchAnim, %body, 1, 0.25 );

	self.update_move_front_bias = true;

	self SetMoveNonForwardAnims( GetMoveAnim( "move_b" ), GetMoveAnim( "move_l" ), GetMoveAnim( "move_r" ) );
	self thread SetCombatStandMoveAnimWeights( "run" );

	self thread WatchShotgunSwitchNotetracks( flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack );

	animscripts\notetracks::DoNoteTracksForTimeIntercept( GetAnimLength( switchAnim ) - 0.25, flagName, ::InterceptNotetracksForWeaponSwitch );

	self.update_move_front_bias = undefined;
}

interceptNotetracksForWeaponSwitch( notetrack )
{
	if ( notetrack == "gun_2_chest" || notetrack == "gun_2_back" )
		return true;// "don't do the default behavior for this notetrack"
}

watchShotgunSwitchNotetracks( flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
	self endon( "killanimscript" );
	self endon( "movemode" );
	self endon( "switchEnded" );

	self waittillmatch( flagName, dropGunNotetrack );

	animscripts\shared::PlaceWeaponOn( self.weapon, putGunOnTag );
	self thread ShotgunSwitchFinish( newGun );

	self waittillmatch( flagName, pickupNewGunNotetrack );
	self notify( "complete_weapon_switch" );
}

shotgunSwitchFinish( newGun )
{
	self endon( "death" );

	self waittill_any( "killanimscript", "movemode", "switchEnded", "complete_weapon_switch" );

	self.lastweapon = self.weapon;

	animscripts\shared::PlaceWeaponOn( newGun, "right" );
	assert( self.weapon == newGun );// placeWeaponOn should have handled this

	// reset ammo (assume fully loaded weapon)
	self.bulletsInClip = WeaponClipSize( self.weapon );
}

