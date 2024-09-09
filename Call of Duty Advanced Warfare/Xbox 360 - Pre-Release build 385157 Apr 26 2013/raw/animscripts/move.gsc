#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\notetracks;
#include animscripts\shared;
#include animscripts\melee;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree( "generic_human" );

init_animset_default_move()
{
	initAnimSet = [];
	initAnimSet["fire"] = %exposed_shoot_auto_v3;
	initAnimSet["single"] = [ %exposed_shoot_semi1 ];
	initAnimSet["single_shotgun"] = [ %shotgun_stand_fire_1A, %shotgun_stand_fire_1B ];

	initAnimSet["burst2"] = %exposed_shoot_burst3;
	initAnimSet["burst3"] = %exposed_shoot_burst3;
	initAnimSet["burst4"] = %exposed_shoot_burst4;
	initAnimSet["burst5"] = %exposed_shoot_burst5;
	initAnimSet["burst6"] = %exposed_shoot_burst6;

	initAnimSet["semi2"] = %exposed_shoot_semi2;
	initAnimSet["semi3"] = %exposed_shoot_semi3;
	initAnimSet["semi4"] = %exposed_shoot_semi4;
	initAnimSet["semi5"] = %exposed_shoot_semi5;

	assert( !isdefined( anim.archetypes["soldier"]["shoot_while_moving"] ) );
	anim.archetypes[ "soldier" ]["shoot_while_moving"] = initAnimSet;

	initAnimSet = [];
	initAnimSet["shuffle_start_from_cover_left"] = %CornerCrL_alert_2_shuffle;
	initAnimSet["shuffle_start_from_cover_right"] = %CornerCrR_alert_2_shuffle;
	initAnimSet["shuffle_start_left"] = %covercrouch_hide_2_shuffleL;
	initAnimSet["shuffle_start_right"] = %covercrouch_hide_2_shuffleR;

	initAnimSet["shuffle_to_cover_left"] = %covercrouch_shuffleL;
	initAnimSet["shuffle_end_to_cover_left"] = %CornerCrL_shuffle_2_alert;
	initAnimSet["shuffle_to_cover_right"] = %covercrouch_shuffleR;
	initAnimSet["shuffle_end_to_cover_right"] = %CornerCrR_shuffle_2_alert;

	initAnimSet["shuffle_start_left_stand_to_stand"] = %coverstand_hide_2_shuffleL;
	initAnimSet["shuffle_left_stand_to_stand"] = %coverstand_shuffleL;
	initAnimSet["shuffle_end_left_stand_to_stand"] = %coverstand_shuffleL_2_hide;
	initAnimSet["shuffle_start_right_stand_to_stand"] = %coverstand_hide_2_shuffleR;
	initAnimSet["shuffle_right_stand_to_stand"] = %coverstand_shuffleR;
	initAnimSet["shuffle_end_right_stand_to_stand"] = %coverstand_shuffleR_2_hide;

	initAnimSet["shuffle_to_left_crouch"] = %covercrouch_shuffleL;
	initAnimSet["shuffle_end_to_left_stand"] = %coverstand_shuffleL_2_hide;
	initAnimSet["shuffle_end_to_left_crouch"] = %covercrouch_shuffleL_2_hide;
	initAnimSet["shuffle_to_right_crouch"] = %covercrouch_shuffleR;
	initAnimSet["shuffle_end_to_right_stand"] = %coverstand_shuffleR_2_hide;
	initAnimSet["shuffle_end_to_right_crouch"] = %covercrouch_shuffleR_2_hide;

	assert( !isdefined( anim.archetypes["soldier"]["shuffle"] ) );
	anim.archetypes[ "soldier" ]["shuffle"] = initAnimSet;
}

init_animset_smg_move()
{
	initAnimSet = [];
	initAnimSet["fire"] = %smg_exposed_shoot_auto_v3;
	initAnimSet["single"] = [ %smg_exposed_shoot_semi1 ];
	// The following line is probably not necessary, but just in case ...
	initAnimSet["single_shotgun"] = [ %shotgun_stand_fire_1A, %shotgun_stand_fire_1B ];

	initAnimSet["burst2"] = %smg_exposed_shoot_burst3;
	initAnimSet["burst3"] = %smg_exposed_shoot_burst3;
	initAnimSet["burst4"] = %smg_exposed_shoot_burst4;
	initAnimSet["burst5"] = %smg_exposed_shoot_burst5;
	initAnimSet["burst6"] = %smg_exposed_shoot_burst6;

	initAnimSet["semi2"] = %smg_exposed_shoot_semi2;
	initAnimSet["semi3"] = %smg_exposed_shoot_semi3;
	initAnimSet["semi4"] = %smg_exposed_shoot_semi4;
	initAnimSet["semi5"] = %smg_exposed_shoot_semi5;

	assert( !isdefined( anim.archetypes["soldier"]["smg_shoot_while_moving"] ) );
	anim.archetypes[ "soldier" ]["smg_shoot_while_moving"] = initAnimSet;

	/*
	initAnimSet = [];
	initAnimSet["shuffle_start_from_cover_left"] = %CornerCrL_alert_2_shuffle;
	initAnimSet["shuffle_start_from_cover_right"] = %CornerCrR_alert_2_shuffle;
	initAnimSet["shuffle_start_left"] = %covercrouch_hide_2_shuffleL;
	initAnimSet["shuffle_start_right"] = %covercrouch_hide_2_shuffleR;

	initAnimSet["shuffle_to_cover_left"] = %covercrouch_shuffleL;
	initAnimSet["shuffle_end_to_cover_left"] = %CornerCrL_shuffle_2_alert;
	initAnimSet["shuffle_to_cover_right"] = %covercrouch_shuffleR;
	initAnimSet["shuffle_end_to_cover_right"] = %CornerCrR_shuffle_2_alert;

	initAnimSet["shuffle_start_left_stand_to_stand"] = %coverstand_hide_2_shuffleL;
	initAnimSet["shuffle_left_stand_to_stand"] = %coverstand_shuffleL;
	initAnimSet["shuffle_end_left_stand_to_stand"] = %coverstand_shuffleL_2_hide;
	initAnimSet["shuffle_start_right_stand_to_stand"] = %coverstand_hide_2_shuffleR;
	initAnimSet["shuffle_right_stand_to_stand"] = %coverstand_shuffleR;
	initAnimSet["shuffle_end_right_stand_to_stand"] = %coverstand_shuffleR_2_hide;

	initAnimSet["shuffle_to_left_crouch"] = %covercrouch_shuffleL;
	initAnimSet["shuffle_end_to_left_stand"] = %coverstand_shuffleL_2_hide;
	initAnimSet["shuffle_end_to_left_crouch"] = %covercrouch_shuffleL_2_hide;
	initAnimSet["shuffle_to_right_crouch"] = %covercrouch_shuffleR;
	initAnimSet["shuffle_end_to_right_stand"] = %coverstand_shuffleR_2_hide;
	initAnimSet["shuffle_end_to_right_crouch"] = %covercrouch_shuffleR_2_hide;

	assert( !isdefined( anim.archetypes["soldier"]["shuffle"] ) );
	anim.archetypes[ "soldier" ]["smg_shuffle"] = initAnimSet;
	*/
}

main()
{
	if ( IsDefined( self.custom_animscript ) )
	{
		if ( IsDefined( self.custom_animscript[ "move" ] ) )
		{
			[[ self.custom_animscript[ "move" ] ]]();
			return;
		}
	}
	
	self endon( "killanimscript" );

	[[ self.exception[ "move" ] ]]();

	MoveInit();
	GetUpIfProne();
	animscripts\utility::Initialize( "move" );

	bWasInCover = self WasPreviouslyInCover();

	if ( bWasInCover && IsDefined( self.shuffleMove ) )
	{
		MoveCoverToCover();
		MoveCoverToCoverFinish();
	}
	else if ( IsDefined( self.battleChatter ) && self.battleChatter )
	{
		self MoveStartBattleChatter( bWasInCover );
		self animscripts\battlechatter::PlayBattleChatter();
	}

	self thread UpdateStairsState();

	pathChangeCheck = ::pathChangeListener;
	if ( IsDefined( self.pathChangeCheckOverrideFunc ) )
		pathChangeCheck = self.pathChangeCheckOverrideFunc;
	self thread [[ pathChangeCheck ]]();
		
	self thread AnimDodgeObstacleListener();

	self animscripts\exit_node::StartMoveTransition();

	self.doingReacquireStep = undefined;
	self.ignorePathChange = undefined;

	self thread StartThreadsToRunWhileMoving();

	self ListenForCoverApproach();

	self.shoot_while_moving_thread = undefined;
	self.aim_while_moving_thread = undefined;

/#
	assert( !IsDefined( self.trackLoopThread ) );
	self.trackLoopThread = undefined;
#/

	self.runNGun = undefined;

	MoveMainLoop( true );
}


// called by code on ending this script
end_script()
{
	if ( IsDefined( self.oldGrenadeWeapon ) )
	{
		self.grenadeWeapon = self.oldGrenadeWeapon;
		self.oldGrenadeWeapon = undefined;
	}

	self.teamFlashbangImmunity = undefined;
	self.minInDoorTime = undefined;
	self.ignorePathChange = undefined;
	self.shuffleMove = undefined;
	self.shuffleNode = undefined;
	self.runNGun = undefined;
	self.reactingToBullet = undefined;
	self.requestReactToBullet = undefined;

	self.currentDodgeAnim = undefined;
	self.moveLoopOverrideFunc = undefined;

	animscripts\run::SetShootWhileMoving( false );

	if ( self.swimmer )
		animscripts\swim::Swim_MoveEnd();
}


MoveInit()
{
	self.reactingToBullet = undefined;
	self.requestReactToBullet = undefined;
	self.update_move_anim_type = undefined;
	self.update_move_front_bias = undefined;
	self.runNGunWeight = 0;
	self.arrivalStartDist = undefined;
}

GetUpIfProne()
{
	if ( self.a.pose == "prone" )
	{
		newPose = self animscripts\utility::ChoosePose( "stand" );

		if ( newPose != "prone" )
		{
			self OrientMode( "face current" );
			self AnimMode( "zonly_physics", false );
			rate = 1;
			if ( IsDefined( self.grenade ) )
				rate = 2;
			self animscripts\cover_prone::ProneTo( newPose, rate );
			self AnimMode( "none", false );
			self OrientMode( "face default" );
		}
	}
}

WasPreviouslyInCover()
{
	switch( self.prevScript )
	{
		case "cover_crouch":
		case "cover_left":
		case "cover_prone":
		case "cover_right":
		case "cover_stand":
		case "cover_multi":
		case "cover_swim_left":
		case "cover_swim_right":
		case "concealment_crouch":
		case "concealment_prone":
		case "concealment_stand":
		// do any of the following scripts actually exist?
		case "cover_wide_left":
		case "cover_wide_right":
		case "hide":
		case "turret":
			return true;
	}
	
	return false;
}


MoveStartBattleChatter( bWasInCover )
{
	if ( self.moveMode == "run" )
	{
		// SRS 10/30/08: removed a bunch of unnecessary logic here
		self animscripts\battleChatter_ai::EvaluateMoveEvent( bWasInCover );
	}
}

MoveMainLoop( doWalkCheck )
{
	MoveMainLoopInternal( doWalkCheck );
	self notify( "abort_reload" ); // in case a reload was going and MoveMainLoopInternal hit an endon
}

ArchetypeChanged()
{
	if ( IsDefined( self.animArchetype ) && self.animArchetype != self.prevMoveArchetype )
	{
		return true;
	}
	else if ( !IsDefined( self.animArchetype ) && self.prevMoveArchetype != "none" )
	{
		return true;
	}
	
	return false;
}

UpdateMoveMode( moveMode )
{
	if ( moveMode != self.prevMoveMode || ArchetypeChanged() )
	{
		if ( IsDefined( self.customMoveAnimSet ) && IsDefined( self.customMoveAnimSet[ moveMode ] ) )
		{
			self.a.moveAnimSet = self.customMoveAnimSet[ moveMode ];
		}
		else		
		{
			self.a.moveAnimSet = lookupAnimArray( moveMode );
			
			if ( ( self.combatMode == "ambush" || self.combatMode == "ambush_nodes_only" ) && 
				 ( IsDefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) > squared( 100 ) ) )
			{
				self.sideStepRate = 1;
				animscripts\animset::set_ambush_sidestep_anims();
			}
			else
			{
				self.sideStepRate = 1.35;
			}
		}
			
		self.prevMoveMode = moveMode;
		if ( IsDefined( self.animarchetype ) )
		{
			self.prevMoveArchetype = self.animArchetype;
		}
	}
}

MoveMainLoopInternal( doWalkCheck )
{
	self endon( "killanimscript" );
	self endon( "move_interrupt" );

	prevLoopTime = self GetAnimTime( %walk_and_run_loops );
	self.a.runLoopCount = randomint( 10000 );// integer that is incremented each time we complete a run loop

	self.prevMoveMode = "none";
	self.prevMoveArchetype = "none";
	
	self.moveLoopCleanupFunc = undefined;

	// if initial destination is closer than 64, walk to it.
	for ( ;; )
	{
		loopTime = self GetAnimTime( %walk_and_run_loops );
		if ( loopTime < prevLoopTime )
			self.a.runLoopCount++ ;
		prevLoopTime = loopTime;

		UpdateMoveMode( self.moveMode );
		
		if ( IsDefined( self.moveMainLoopProcessOverrideFunc ) )
			self [[ self.moveMainLoopProcessOverrideFunc ]]( self.moveMode );
		else
			MoveMainLoopProcess( self.moveMode );
		
		if ( IsDefined( self.moveLoopCleanupFunc ) )
		{
			self [[self.moveLoopCleanupFunc]]();
			self.moveLoopCleanupFunc = undefined;
		}
		
		self notify( "abort_reload" ); // in case a reload was going and MoveMainLoopProcess hit an endon
	}
}

MoveMainLoopProcess( moveMode )
{
	self endon( "move_loop_restart" );
	
	//prof_begin("MoveMainLoop");
	
	self animscripts\face::SetIdleFaceDelayed( anim.alertface );
	
	if ( IsDefined( self.moveLoopOverrideFunc ) )
	{
		self [[ self.moveLoopOverrideFunc ]]();
	}
	else if ( self ShouldCQB() )
	{
		self animscripts\cqb::MoveCQB();
	}
	else if ( self.swimmer )
	{
		self animscripts\swim::MoveSwim();
	}
	else
	{
		if ( moveMode == "run" )
		{
			self animscripts\run::MoveRun();
		}
		else
		{
			assert( moveMode == "walk" );
			self animscripts\walk::MoveWalk();
		}
	}

	self.requestReactToBullet = undefined;
	//prof_end("MoveMainLoop");
}


MayShootWhileMoving()
{
	if ( self.weapon == "none" )
		return false;

	weapclass = WeaponClass( self.weapon );
	if ( !UsingRifleLikeWeapon() )
		return false;

	if ( self IsSniper() )
	{
		if ( !( self IsCQBWalking() ) && self.faceMotion )
			return false;
	}

	if ( IsDefined( self.dontShootWhileMoving ) )
	{
		assert( self.dontShootWhileMoving );// true or undefined
		return false;
	}

	return true;
}

ShootWhileMoving()
{
	self endon( "killanimscript" );

	// it's possible for this to be called by CQB while it's already running from run.gsc,
	// even though run.gsc will kill it on the next frame. We can't let it run twice at once.
	self notify( "doing_shootWhileMoving" );
	self endon( "doing_shootWhileMoving" );

	shoot_while_moving_anims = self lookupAnimArray( "shoot_while_moving" );
	if ( usingSMG() )
	{
		shoot_while_moving_anims = self lookupAnimArray( "smg_shoot_while_moving" );
	}
	foreach ( key, value in shoot_while_moving_anims )
	{
		self.a.array[ key ] = value;
	}

	if ( IsDefined( self.combatStandAnims ) && IsDefined( self.combatStandAnims[ "fire" ] ) )
	{
		self.a.array[ "fire" ] = self.combatStandAnims[ "fire" ];
	}

	if ( IsDefined( self.weapon ) && weapon_pump_action_shotgun() )
	{
		self.a.array[ "single" ] = self lookupAnim( "shotgun_stand", "single" );
	}

	while ( 1 )
	{
		if ( !self.bulletsInClip )
		{
			if ( self IsCQBWalkingOrFacingEnemy() )
			{
				self.ammoCheatTime = 0;
				CheatAmmoIfNecessary();
			}

			if ( !self.bulletsInClip )
			{
				wait 0.5;
				continue;
			}
		}

		self ShootUntilShootBehaviorChange();
		// can't clear %exposed_modern because there are transition animations within it that we might play when going to prone
		self ClearAnim( %exposed_aiming, 0.2 );
	}
}


StartThreadsToRunWhileMoving()
{
	self endon( "killanimscript" );

	// wait a frame so MoveMainLoop can start. Otherwise one of the following threads could unsuccesfully try to interrupt movement before it starts
	wait 0.05;

	self thread BulletWhizbyCheck_WhileMoving();
	self thread MeleeAttackCheck_WhileMoving();
	self thread animscripts\door::InDoorCqbToggleCheck();
	self thread animscripts\door::DoorEnterExitCheck();
}

UpdateStairsState()
{
	self endon( "killanimscript" );

	self.prevStairsState = self.stairsState;

	while ( 1 )
	{
		wait .05;
		if ( self.prevStairsState != self.stairsState )
		{
			// don't interrupt path change animation if getting off stairs to flat ground
			if ( !IsDefined( self.ignorePathChange ) || self.stairsState != "none" )
				self notify( "move_loop_restart" );
		}

		self.prevStairsState = self.stairsState;
	}
}


RestartMoveLoop( bSkipMoveTransition )
{
	self endon( "killanimscript" );

	if ( !bSkipMoveTransition )
		animscripts\exit_node::StartMoveTransition();

	self.ignorePathChange = undefined;

	self ClearAnim( %root, 0.1 );
	self OrientMode( "face default" );
	self AnimMode( "none", false );

	self.requestArrivalNotify = true;
	MoveMainLoop( !bSkipMoveTransition );
}


PathChangeListener()
{
	self endon( "killanimscript" );
	self endon( "move_interrupt" );

	self.ignorePathChange = true;	// this will be turned on / off in other threads at appropriate times

	while ( 1 )
	{
		// no other thread should end on "path_changed"
		self waittill( "path_changed", doingReacquire, newDir );

		// no need to check for doingReacquire since faceMotion should be a good check

		assert( !IsDefined( self.ignorePathChange ) || self.ignorePathChange );	// should be true or undefined

		if ( IsDefined( self.ignorePathChange ) || IsDefined( self.noTurnAnims ) )
			continue;

		if ( !self.faceMotion || abs( self GetMotionAngle() ) > 15 )
			continue;

		// not convinced this is necessary... if we got a new path in the middle of our old one,
		// there's a good chance we'll be in "stop" right at this moment.
		//if ( self.a.movement != "run" && self.a.movement != "walk" )
		//	continue;

		if ( self.a.pose != "stand" )
			continue;

		self notify( "stop_move_anim_update" );
		self.update_move_anim_type = undefined;

		newDirAngles = VectorToAngles( newDir );
		yawDiff = AngleClamp180( self.angles[ 1 ] - newDirAngles[ 1 ] );
		pitchDiff = AngleClamp180( self.angles[ 0 ] - newDirAngles[ 0 ] );

		turnAnim = PathChange_GetTurnAnim( yawDiff, pitchDiff );
			
		if ( IsDefined( turnAnim ) )
		{
			self.turnAnim = turnAnim;
			self.turnTime = getTime();
			self.moveLoopOverrideFunc = ::PathChange_DoTurnAnim;
			
			self notify( "move_loop_restart" );
			self animscripts\run::EndFaceEnemyAimTracking();
		}
	}
}

PathChange_GetTurnAnim( angleDiff, pitchDiff )
{
	if ( IsDefined( self.pathTurnAnimOverrideFunc ) )
		return [[ self.pathTurnAnimOverrideFunc ]]( angleDiff, pitchDiff );

	turnAnim = undefined;
	secondTurnAnim = undefined;
	
	if ( self.swimmer )
		animArray = animscripts\swim::GetSwimAnim( "turn" );
	else if ( self ShouldCQB() || self.moveMode == "walk" )
		animArray = lookupAnimArray( "cqb_turn" );
	else if ( self usingSMG() )
		animArray = lookupAnimArray( "smg_run_turn" );
	else
		animArray = lookupAnimArray( "run_turn" );

	// ceil/floor because we'd like to underturn if possible.  it looks better than overturning.
	// we have turn anims for every 45 degrees.
	// +180 to end up with positive numbers.
	// +/- 10 because we'll allow overturning if we're pretty close to that angle, or because we don't have a turn0.
	if ( angleDiff < 0 )
	{
		if ( angleDiff > -45 )
			i = 3;
		else
			i = int( ceil( (angleDiff + 180 - 10) / 45 ) );
	}
	else
	{
		if ( angleDiff < 45 )
			i = 5;
		else
			i = int( floor( (angleDiff + 180 + 10) / 45 ) );
	}

	turnAnim = animArray[ i ];

	if ( IsDefined( turnAnim ) )
	{
		if ( PathChange_CanDoTurnAnim( turnAnim ) )
			return turnAnim;
	}

	// couldn't find use the good turn anim?  then try an okay one instead...
	secondI = -1;
	if ( angleDiff < -60 )
	{
		secondI = int( ceil( ( angleDiff + 180 ) / 45 ) );
		if ( secondI == i )
			secondI = i - 1;
	}
	else if ( angleDiff > 60 )
	{
		secondI = int( floor( ( angleDiff + 180 ) / 45 ) );
		if ( secondI == i )
			secondI = i + 1;
	}
	if ( secondI >= 0 && secondI < 9 )
		secondTurnAnim = animArray[ secondI ];


	if ( IsDefined( secondTurnAnim ) )
	{
		if ( PathChange_CanDoTurnAnim( secondTurnAnim ) )
			return secondTurnAnim;
	}
	
	return undefined;
}

PathChange_CanDoTurnAnim( turnAnim )
{
	if ( !IsDefined( self.pathgoalpos ) )
		return false;

	codeMoveTimes = GetNotetrackTimes( turnAnim, "code_move" );
	assert( codeMoveTimes.size == 1 );

	codeMoveTime = codeMoveTimes[ 0 ];
	assert( codeMoveTime <= 1 );

	moveDelta = GetMoveDelta( turnAnim, 0, codeMoveTime );
	codeMovePoint = self LocalToWorldCoords( moveDelta );

	/#
	animscripts\utility::drawDebugLine( self.origin, codeMovePoint, ( 1, 1, 0 ), 20 );
	animscripts\utility::drawDebugLine( self.origin, self.pathgoalpos, ( 0, 1, 0 ), 20 );
	#/

	// check if we're doing a cover arrival, and we wouldn't have enough room to do the cover arrival after playing the turn animation.
	//if ( distanceSquared( self.origin, codeMovePoint ) > distanceSquared( self.origin, self.pathgoalpos ) )
	if ( IsDefined( self.arrivalStartDist ) && ( squared( self.arrivalStartDist ) > distanceSquared( self.pathgoalpos, codeMovePoint ) ) )
		return false;

	// check if there's enough forward clearance to not smack into a wall after we 'finish' (i.e. codemove) the animation.
	moveDelta = GetMoveDelta( turnAnim, 0, 1 );
	endPoint = self LocalToWorldCoords( moveDelta );

	endPoint = codeMovePoint + VectorNormalize( endPoint - codeMovePoint ) * 20;

	/# animscripts\utility::drawDebugLine( codeMovePoint, endPoint, ( 1, 1, 0 ), 20 ); #/

	bCheckDrop = !self.swimmer;
	return self MayMoveFromPointToPoint( codeMovePoint, endPoint, bCheckDrop, true );
}

PathChange_DoTurnAnim()
{
	self endon( "killanimscript" );
	
	self.moveLoopOverrideFunc = undefined;
	
	turnAnim = self.turnAnim;
	
	if ( gettime() > self.turnTime + 50 )
		return; // too late
	
	if ( self.swimmer )
		self AnimMode( "nogravity", false );
	else
		self AnimMode( "zonly_physics", false );
	self ClearAnim( %body, 0.1 );
	
	self.moveLoopCleanupFunc = ::PathChange_CleanupTurnAnim;
	
	self.ignorePathChange = true;
	
	blendTime = 0.05;
	if ( IsDefined( self.pathTurnAnimBlendTime ) )
		blendTime = IsDefined( self.pathTurnAnimBlendTime );
		
	self SetFlaggedAnimRestart( "turnAnim", turnAnim, 1, blendTime, self.movePlaybackRate );
	self OrientMode( "face current" );

	assert( animHasNotetrack( turnAnim, "code_move" ) );
	self animscripts\shared::DoNoteTracks( "turnAnim" );	// until "code_move"

	self.ignorePathChange = undefined;
	self OrientMode( "face motion" );	// want to face motion, don't do l / r / b anims
	self AnimMode( "none", false );

	//assert( animHasNotetrack( turnAnim, "finish" ) );
	self animscripts\shared::DoNoteTracks( "turnAnim" );
}

PathChange_CleanupTurnAnim()
{
	self.ignorePathChange = undefined;
	
	self OrientMode( "face default" );
	self ClearAnim( %root, 0.1 );
	self AnimMode( "none", false );

	if ( self.swimmer )
		self animscripts\swim::Swim_CleanupTurnAnim();
}

DodgeMoveLoopOverride()
{
	self PushPlayer( true );
	self AnimMode( "zonly_physics", false );
	self ClearAnim( %body, 0.2 );	
	
	self SetFlaggedAnimRestart( "dodgeAnim", self.currentDodgeAnim, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "dodgeAnim" );

	self AnimMode( "none", false );
	self OrientMode( "face default" );

	if ( AnimHasNotetrack( self.currentDodgeAnim, "code_move" ) )
		self animscripts\shared::DoNoteTracks( "dodgeAnim" );	// return on code_move

	self ClearAnim( %civilian_dodge, 0.2 );

	self PushPlayer( false );
	self.currentDodgeAnim = undefined;
	self.moveLoopOverrideFunc = undefined;
	return true;
}


TryDodgeWithAnim( dodgeAnim, dodgeAnimDelta )
{
	rightDir = ( self.lookAheadDir[1], -1 * self.lookAheadDir[0], 0 );

	forward = self.lookAheadDir * dodgeAnimDelta[0];
	right   = rightDir * dodgeAnimDelta[1];
	
	dodgePos = self.origin + forward - right;

	self PushPlayer( true );
	if ( self MayMoveToPoint( dodgePos ) )
	{
		self.currentDodgeAnim = dodgeAnim;
		self.moveLoopOverrideFunc = ::DodgeMoveLoopOverride;
		self notify( "move_loop_restart" );
		
		/# 
		if ( getdvar( "scr_debugdodge" ) == "1" )
			thread debugline( self.origin, dodgePos, ( 0, 1, 0 ), 3 );
		#/
		
		return true;
	}

	/# 
	if ( getdvar( "scr_debugdodge" ) == "1" )
		thread debugline( self.origin, dodgePos, ( 0.5, 0.5, 0 ), 3 );
	#/	
	
	self PushPlayer( false );
	return false;
}

AnimDodgeObstacleListener()
{
	if ( !IsDefined( self.dodgeLeftAnim ) || !IsDefined( self.dodgeRightAnim ) )
		return;

	self endon( "killanimscript" );
	self endon( "move_interrupt" );

	while ( 1 )
	{
		// no other thread should end on "path_changed"
		self waittill( "path_need_dodge", dodgeEnt, dodgeEntPos );
		
		self animscripts\utility::UpdateIsInCombatTimer();
		if ( self animscripts\utility::IsInCombat() )
		{
			self.noDodgeMove = false;
			return;
		}
		
		if ( !IsSentient( dodgeEnt ) )
			continue;
			
		/# 
		if ( getdvar( "scr_debugdodge" ) == "1" )
		{
			thread debugline( dodgeEnt.origin + (0, 0, 10), dodgeEntPos, ( 1, 1, 0 ), 3 );
			thread debugline( self.origin, dodgeEntPos, ( 1, 0, 0 ), 3 );
		}
		#/
			
		dirToDodgeEnt = VectorNormalize( dodgeEntPos - self.origin );
		
		if ( ( self.lookAheadDir[0] * dirToDodgeEnt[1] ) - ( dirToDodgeEnt[0] * self.lookAheadDir[1] ) > 0 )
		{
			// right first
			if ( !TryDodgeWithAnim( self.dodgeRightAnim, self.dodgeRightAnimOffset ) )
				TryDodgeWithAnim( self.dodgeLeftAnim, self.dodgeLeftAnimOffset );
		}
		else
		{
			// left first
			if ( !TryDodgeWithAnim( self.dodgeLeftAnim, self.dodgeLeftAnimOffset ) )
				TryDodgeWithAnim( self.dodgeRightAnim, self.dodgeRightAnimOffset );
		}
		
		if ( IsDefined( self.currentDodgeAnim ) )
			wait GetAnimLength( self.currentDodgeAnim );
		else
			wait 0.1;
	}
}

SetDodgeAnims( leftAnim, rightAnim )
{
	self.noDodgeMove = true;	// don't let code path around obstacle to dodge
	//self pushplayer( true );
	
	self.dodgeLeftAnim = leftAnim;
	self.dodgeRightAnim = rightAnim;
	
	time = 1;
	if ( AnimHasNoteTrack( leftAnim, "code_move" ) )
		time = GetNotetrackTimes( leftAnim, "code_move" )[0];
	
	self.dodgeLeftAnimOffset = GetMoveDelta( leftAnim, 0, time );

	time = 1;
	if ( AnimHasNoteTrack( rightAnim, "code_move" ) )
		time = GetNotetrackTimes( rightAnim, "code_move" )[0];

	self.dodgeRightAnimOffset = GetMoveDelta( rightAnim, 0, time );
	
	self.interval = 80;	// good value for civilian dodge animations
}

ClearDodgeAnims()
{
	self.noDodgeMove = false;
	self.dodgeLeftAnim = undefined;
	self.dodgeRightAnim = undefined;
	self.dodgeLeftAnimOffset = undefined;
	self.dodgeRightAnimOffset = undefined;
}

MeleeAttackCheck_WhileMoving()
{
	self endon( "killanimscript" );
	
	while ( 1 )
	{
		// Try to melee our enemy if it's another AI
		if ( IsDefined( self.enemy ) && ( IsAI( self.enemy ) || IsDefined( self.meleePlayerWhileMoving ) ) )
		{
			if ( abs( self GetMotionAngle() ) <= 135 ) // only when moving forward or sideways
				animscripts\melee::Melee_TryExecuting();
		}
		
		wait 0.1;
	}
}

BulletWhizbyCheck_whileMoving()
{
	self endon( "killanimscript" );

	if ( IsDefined( self.disableBulletWhizbyReaction ) )
		return;

	while ( 1 )
	{
		self waittill( "bulletwhizby", shooter );
		
		if ( self.moveMode != "run" || !self.faceMotion || self.a.pose != "stand" || IsDefined( self.reactingToBullet ) )
			continue;
		
		if ( self.stairsState != "none" )
			continue;
		
		if ( !IsDefined( self.enemy ) && !self.ignoreAll && IsDefined( shooter.team ) && IsEnemyTeam( self.team, shooter.team ) )
		{
			self.whizbyEnemy = shooter;
			self AnimCustom( animscripts\reactions::BulletWhizbyReaction );	// this will end move script
			continue;
		}
		
		if ( self.lookaheadHitsStairs || self.lookaheadDist < 100 )
			continue;
		
		if ( IsDefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) < 10000 )
		{
			wait 0.2;
			continue;
		}
		
		self.requestReactToBullet = gettime();
		self notify( "move_loop_restart" );
		self animscripts\run::EndFaceEnemyAimTracking();
	}
}


get_shuffle_to_corner_start_anim( shuffleLeft, startNode )
{
	coverType = startNode.type;
	if ( coverType == "Cover Multi" )
		coverType = self GetCoverMultiPretendType( startNode );

	if ( coverType == "Cover Left" )
	{
		assert( !shuffleLeft );
		return self lookupAnim( "shuffle", "shuffle_start_from_cover_left" );
	}
	else if ( coverType == "Cover Right" )
	{
		assert( shuffleLeft );
		return self lookupAnim( "shuffle", "shuffle_start_from_cover_right" );
	}
	else
	{
		if ( shuffleLeft )
			return self lookupAnim( "shuffle", "shuffle_start_left" );
		else
			return self lookupAnim( "shuffle", "shuffle_start_right" );
	}
}


setup_shuffle_anim_array( shuffleLeft, startNode, endNode )
{
	anim_array = [];

	assert( IsDefined( startNode ) );
	assert( IsDefined( endNode ) );

	endNodeType = endNode.type;
	if ( endNodeType == "Cover Multi" )
		endNodeType = self GetCoverMultiPretendType( endNode );
	
	if ( endNodeType == "Cover Left" )
	{
		assert( shuffleLeft );
		anim_array[ "shuffle_start" ]	 = get_shuffle_to_corner_start_anim( shuffleLeft, startNode );
		anim_array[ "shuffle" ]			 = self lookupAnim( "shuffle", "shuffle_to_cover_left" );
		anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_to_cover_left" );
	}
	else if ( endNodeType == "Cover Right" )
	{
		assert( !shuffleLeft );
		anim_array[ "shuffle_start" ]	 = get_shuffle_to_corner_start_anim( shuffleLeft, startNode ); 
		anim_array[ "shuffle" ]			 = self lookupAnim( "shuffle", "shuffle_to_cover_right" );
		anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_to_cover_right" );
	}
	else if ( endNodeType == "Cover Stand" && startNode.type == endNodeType )
	{
		if ( shuffleLeft )
		{
			anim_array[ "shuffle_start" ]	 = self lookupAnim( "shuffle", "shuffle_start_left_stand_to_stand" );
			anim_array[ "shuffle" ]			 = self lookupAnim( "shuffle", "shuffle_left_stand_to_stand" );
			anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_left_stand_to_stand" );
		}
		else
		{
			anim_array[ "shuffle_start" ]	 = self lookupAnim( "shuffle", "shuffle_start_left_stand_to_stand" );
			anim_array[ "shuffle" ]			 = self lookupAnim( "shuffle", "shuffle_left_stand_to_stand" );
			anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_left_stand_to_stand" );
		}
	}
	else
	{
		//assert( endNode.type == "Cover Crouch" || endNode.type == "Cover Crouch Window" );
		if ( shuffleLeft )
		{
			anim_array[ "shuffle_start" ]	 = get_shuffle_to_corner_start_anim( shuffleLeft, startNode ); 
			anim_array[ "shuffle" ]			 = lookupAnim( "shuffle", "shuffle_to_left_crouch" );
			
			if ( endNodeType == "Cover Stand" )
				anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_to_left_stand" );
			else
				anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_to_left_crouch" );
		}
		else
		{
			anim_array[ "shuffle_start" ]	 = get_shuffle_to_corner_start_anim( shuffleLeft, startNode ); 
			anim_array[ "shuffle" ]			 = self lookupAnim( "shuffle", "shuffle_to_right_crouch" );
			
			if ( endNodeType == "Cover Stand" )
				anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_to_right_stand" );
			else
				anim_array[ "shuffle_end" ]		 = self lookupAnim( "shuffle", "shuffle_end_to_right_crouch" );
		}
	}

	self.a.array = anim_array;
}

MoveCoverToCover_CheckStartPose( startNode, endNode )
{
	if ( self.a.pose == "stand" && ( endNode.type != "Cover Stand" || startNode.type != "Cover Stand" ) )
	{
		self.a.pose = "crouch";
		return false;
	}
	
	return true;
}

MoveCoverToCover_CheckEndPose( endNode )
{
	if ( self.a.pose == "crouch" && endNode.type == "Cover Stand" )
	{
		self.a.pose = "stand";
		return false;	
	}
	
	return true;
}


serverFPS = 20;
serverSPF = 0.05;

MoveCoverToCover()
{
	self endon( "killanimscript" );
	self endon( "goal_changed" );

	shuffleNode = self.shuffleNode;

	self.shuffleMove = undefined;
	self.shuffleNode = undefined;
	self.shuffleMoveInterrupted = true;

	if ( !IsDefined( self.prevNode ) )
		return;
	
	if ( !IsDefined( self.node ) || !IsDefined( shuffleNode ) || self.node != shuffleNode )
		return;
	
	shuffleNodeType = self.prevNode;

	node = self.node;

	moveDir = node.origin - self.origin;
	if ( LengthSquared( moveDir ) < 1 )
		return;

	moveDir = VectorNormalize( moveDir );
	forward = AnglesToForward( node.angles );
	
	shuffleLeft = ( ( forward[ 0 ] * moveDir[ 1 ] ) - ( forward[ 1 ] * moveDir[ 0 ] ) ) > 0;

	if ( MoveDoorSideToSide( shuffleLeft, shuffleNodeType, node ) )
		return;
	
	if ( MoveCoverToCover_CheckStartPose( shuffleNodeType, node ) )
		blendTime = 0.1;
	else
		blendTime = 0.4;
		
	setup_shuffle_anim_array( shuffleLeft, shuffleNodeType, node );

	self AnimMode( "zonly_physics", false );

	self clearanim( %body, blendTime );

	startAnim	 = animArray( "shuffle_start" );
	shuffleAnim = animArray( "shuffle" );
	endAnim		 = animArray( "shuffle_end" );

	//assertEx( animhasnotetrack( startAnim, "finish" ), "animation doesn't have finish notetrack " + startAnim );
	if ( AnimHasNoteTrack( startAnim, "finish" ) )
		startEndTime = GetNoteTrackTimes( startAnim, "finish" )[ 0 ];
	else
		startEndTime = 1;

	startDist   = Length( GetMoveDelta( startAnim, 0, startEndTime ) );
	shuffleDist	 = Length( GetMoveDelta( shuffleAnim, 0, 1 ) );
	endDist		 = Length( GetMoveDelta( endAnim, 0, 1 ) );

	remainingDist = Distance( self.origin, node.origin );

	if ( remainingDist > startDist )
	{
		self OrientMode( "face angle", GetNodeForwardYaw( shuffleNodeType ) );
		
		self SetFlaggedAnimRestart( "shuffle_start", startAnim, 1, blendTime );
		self animscripts\shared::DoNoteTracks( "shuffle_start" );
		self ClearAnim( startAnim, 0.2 );
		remainingDist -= startDist;

		blendTime = 0.2; // reset blend for looping move
	}
	else
	{
		self OrientMode( "face angle", node.angles[1] );
	}

	playEnd = false;
	if ( remainingDist > endDist )
	{
		playEnd = true;
		remainingDist -= endDist;
	}

	loopTime = GetAnimLength( shuffleAnim );
	playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;
	playTime = floor( playTime * serverFPS ) * serverSPF;

	self SetFlaggedAnim( "shuffle", shuffleAnim, 1, blendTime );
	self DoNoteTracksForTime( playTime, "shuffle" );

	// account for loopTime not being exact since loop animation delta isn't uniform over time
	for ( i = 0; i < 2; i++ )
	{
		remainingDist = Distance( self.origin, node.origin );
		if ( playEnd )
			remainingDist -= endDist;

		if ( remainingDist < 4 )
			break;

		playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;	// don't overshoot
		playTime = floor( playTime * serverFPS ) * serverSPF;

		if ( playTime < 0.05 )
			break;

		self DoNoteTracksForTime( playTime, "shuffle" );
	}

	if ( playEnd )
	{
		if ( MoveCoverToCover_checkEndPose( node ) )
			blendTime = 0.2;
		else
			blendTime = 0.4;
			
		self ClearAnim( shuffleAnim, blendTime );
		self SetFlaggedAnim( "shuffle_end", endAnim, 1, blendTime );
		self animscripts\shared::DoNoteTracks( "shuffle_end" );
		
		// clear animation in moveCoverToCoverFinish if needed
	}

	self SafeTeleport( node.origin );
	self AnimMode( "normal" );

	self.shuffleMoveInterrupted = undefined;
}


MoveCoverToCoverFinish()
{
	if ( IsDefined( self.shuffleMoveInterrupted ) )
	{
		self ClearAnim( %cover_shuffle, 0.2 );
		
		self.shuffleMoveInterrupted = undefined;
		self AnimMode( "none", false );
		self OrientMode( "face default" );
	}
	else
	{
		wait 0.2;	// don't clear animation, wait for cover script to take over
		
		self ClearAnim( %cover_shuffle, 0.2 );
	}
}

MoveDoorSideToSide( shuffleLeft, startNode, endNode )
{
	sideToSideAnim = undefined;
	
	if ( startNode.type == "Cover Right" && endNode.type == "Cover Left" && !shuffleLeft )
		sideToSideAnim = %corner_standR_Door_R2L;
	else if ( startNode.type == "Cover Left" && endNode.type == "Cover Right" && shuffleLeft )
		sideToSideAnim = %corner_standL_Door_L2R;
		
	if ( !IsDefined( sideToSideAnim ) )
		return false;

	self AnimMode( "zonly_physics", false );
	self OrientMode( "face current" );

	self SetFlaggedAnimRestart( "sideToSide", sideToSideAnim, 1, 0.2 );
	
	assert( animHasNoteTrack( sideToSideAnim, "slide_start" ) );
	assert( animHasNoteTrack( sideToSideAnim, "slide_end" ) );

	self animscripts\shared::DoNoteTracks( "sideToSide", ::HandleSideToSideNotetracks );

	slideStartTime = self GetAnimTime( sideToSideAnim );
	slideDir = endNode.origin - startNode.origin;
	slideDir = VectorNormalize( ( slideDir[0], slideDir[1], 0 ) );

	animDelta = GetMoveDelta( sideToSideAnim, slideStartTime, 1 );
	remainingVec = endNode.origin - self.origin;
	remainingVec = ( remainingVec[0], remainingVec[1], 0 );
	slideDist = VectorDot( remainingVec, slideDir ) - abs( animDelta[1] );
	
	if ( slideDist > 2 )
	{
		slideEndTime = GetNoteTrackTimes( sideToSideAnim, "slide_end" )[0];
		slideTime = ( slideEndTime - slideStartTime ) * GetAnimLength( sideToSideAnim );
		assert( slideTime > 0 );

		slideFrames = int( ceil( slideTime / 0.05 ) );
		slideIncrement = slideDir * slideDist / slideFrames;
		self thread SlideForTime( slideIncrement, slideFrames );
	}

	self animscripts\shared::DoNoteTracks( "sideToSide" );

	self safeTeleport( endNode.origin );
	self AnimMode( "none" );
	self OrientMode( "face default" );

	self.shuffleMoveInterrupted = undefined;
	wait 0.2;	
	
	return true;
}

HandleSideToSideNotetracks( note )
{
	if ( note == "slide_start" )
		return true;
}

SlideForTime( slideIncrement, slideFrames )
{
	self endon( "killanimscript" );
	self endon( "goal_changed" );
	
	while ( slideFrames > 0 )
	{
		self SafeTeleport( self.origin + slideIncrement );
		slideFrames--;
		wait 0.05;
	}
}

MoveStand_MoveOverride( override_anim, weights )
{
	self endon( "movemode" );
	self ClearAnim( %combatrun, 0.6 );
	self SetAnimKnobAll( %combatrun, %body, 1, 0.5, self.moveplaybackrate );

	if ( IsDefined( self.requestReactToBullet ) && gettime() - self.requestReactToBullet < 100 && IsDefined( self.run_overrideBulletReact ) && randomFloat( 1 ) < self.a.reactToBulletChance )
	{
		animscripts\run::CustomRunningReactToBullets();
		return;
	}

	if ( IsArray( override_anim ) )
	{
		if ( IsDefined( self.run_override_weights ) )
			moveAnim = choose_from_weighted_array( override_anim, weights );	
		else
			moveAnim = override_anim[ randomint( override_anim.size ) ];
	}
	else
	{
		moveAnim = override_anim;
	}

	self SetFlaggedAnimKnob( "moveanim", moveAnim, 1, 0.2, self.moveplaybackrate );
	animscripts\shared::DoNoteTracks( "moveanim" );
}

ListenForCoverApproach()
{
	self thread animscripts\cover_arrival::SetupApproachNode( true );
}
