#include animscripts\notetracks;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree( "generic_human" );

MoveSwim()
{
	assert ( self.swimmer );
	assertex( IsDefined( self.swim ), "Must init swimmers with Swim_Begin() before swimming." );

	self endon( "movemode" );

	self OrientMode( "face enemy or motion" );

	self.turnRate = 0.05;

	self UpdateIsInCombatTimer();
	if ( self IsInCombat( false ) )
		MoveSwim_Combat();
	else
		MoveSwim_NonCombat();
}

Swim_Begin()
{
	self.swim = SpawnStruct();
	self.swim.combatState = "nostate";
	self.swim.moveState = "combat_stationary";
	self.swim.trackState = "track_none";

	self.swim.stateFns = [];
	// combat state
	self.swim.stateFns["nostate"] = [ ::Swim_Null, ::Swim_Null ];
	self.swim.stateFns["noncombat"] = [ ::MoveSwim_NonCombat_Enter, ::MoveSwim_NonCombat_Exit ];
	self.swim.stateFns["combat"] = [ ::MoveSwim_Combat_Enter, ::MoveSwim_Combat_Exit ];

	// move state
	self.swim.stateFns["combat_stationary"] = [ ::Swim_Null, ::Swim_Null ];
	self.swim.stateFns["combat_forward"] = [ ::MoveSwim_Combat_Forward_Enter, ::MoveSwim_Combat_Forward_Exit ];
	self.swim.stateFns["combat_strafe"] = [ ::MoveSwim_Combat_Strafe_Enter, ::MoveSwim_Combat_Strafe_Exit ];

	// track state
	self.swim.stateFns["track_none"] = [ ::Swim_Null, ::Swim_Null ];
	self.swim.stateFns["track_forward"] = [ ::Swim_Track_Forward_Enter, ::Swim_Track_Forward_Exit ];
	self.swim.stateFns["track_strafe"] = [ ::Swim_Track_Strafe_Enter, ::Swim_Track_Strafe_Exit ];

	// go ahead and init the standing aim/track anims.  they've got no competition.
	// should ideally be done when we enter the combat state, though.
	self SetAnimLimited( GetSwimAnim("aim_stand_D") );
	self SetAnimLimited( GetSwimAnim("aim_stand_U") );
	self SetAnimLimited( GetSwimAnim("aim_stand_L") );
	self SetAnimLimited( GetSwimAnim("aim_stand_R") );

	// override node exit.
	self.customMoveTransition = ::Swim_MoveBegin;
	self.permanentCustomMoveTransition = true;

	// override hard turn animation calculation.
	self.pathTurnAnimOverrideFunc = ::Swim_PathChange_GetTurnAnim;
}
Swim_End()
{
	self.swim = undefined;
}

Swim_Null()
{
}

Swim_MoveEnd()
{
	MoveSwim_Set( "nostate" );
	self Swim_ClearLeanAnims();
	self.turnRate = 0.3;
}

MoveSwim_NonCombat()
{
	if ( self.swim.combatState != "noncombat" )
		self MoveSwim_Set( "noncombat" );

	swimAnim = GetSwimAnim( "forward" );

	self SetFlaggedAnimKnob( "swimanim", swimAnim, 1, 0.2, self.moveplaybackrate );
	self Swim_UpdateLeanAnim();

	self DoNotetracksForTime( 0.2, "swimanim" );
}

MoveSwim_Combat()
{
	if ( self.swim.combatState != "combat" )
		self MoveSwim_Set( "combat" );

	// aiming
	if ( IsDefined( self.enemy ) )
	{
		self animscripts\run::SetShootWhileMoving( true );

		if ( !self.faceMotion )
		{
			//self Swim_ClearLeanAnims();
			Swim_DoStrafe();
			return;
		}
		else
		{
			// basic movement swim loop
			if ( self.swim.moveState != "combat_forward" )
				MoveSwim_Combat_Move_Set( "combat_forward" );

			swimAnim = GetSwimAnim( "forward_aim" );
		}
	}
	else
	{
		if ( self.swim.moveState != "combat_forward" )
			MoveSwim_Combat_Move_Set( "combat_forward" );

		self animscripts\run::SetShootWhileMoving( false );

		// basic movement swim loop
		swimAnim = GetSwimAnim( "forward_aim" );
	}

	self Swim_UpdateLeanAnim();
	self SetFlaggedAnimKnob( "swimanim", swimAnim, 1, 0.2, self.movePlaybackRate );
	self DoNotetracksForTime( 0.2, "swimanim" );
}

MoveSwim_Set( combatState )
{
	if ( combatState == self.swim.combatState )
		return;

	[[ self.swim.stateFns[ self.swim.combatState ][ 1 ] ]] ();
	[[ self.swim.stateFns[ combatState ][ 0 ] ]] ();
	self.swim.combatState = combatState;
}

MoveSwim_NonCombat_Enter()
{
	if ( self.swim.trackState != "track_none" )
		self Swim_Track_Set( "track_none" );

	Swim_SetLeanAnims();
}
MoveSwim_NonCombat_Exit()
{
}
MoveSwim_Combat_Enter()
{
	// activate this node in the tree, clear out all others.
	self SetAnimKnob( %combatrun, 1.0, 0.5, self.movePlaybackRate );

	if ( self.swim.moveState != "combat_forward" )
		self MoveSwim_Combat_Move_Set( "combat_forward" );

	//Swim_SetLeanAnims();
}

MoveSwim_Combat_Exit()
{
}
MoveSwim_Combat_Move_Set( moveState )
{
	if ( moveState == self.swim.moveState )
		return;

	[[ self.swim.stateFns[ self.swim.moveState ][ 1 ] ]] ();
	[[ self.swim.stateFns[ moveState ][ 0 ] ]] ();
	self.swim.moveState = moveState;
}
MoveSwim_Combat_Forward_Enter()
{
	if ( self.swim.trackState != "track_forward" )
		self Swim_Track_Set( "track_forward" );

	Swim_SetLeanAnims();
}
MoveSwim_Combat_Forward_Exit()
{
}
MoveSwim_Combat_Strafe_Enter()
{
	self SetAnimKnobLimited( GetSwimAnim( "strafe_B" ), 1, 0.1, self.sideStepRate, true );
	self SetAnimKnobLimited( GetSwimAnim( "strafe_L" ), 1, 0.1, self.sideStepRate, true );
	self SetAnimKnobLimited( GetSwimAnim( "strafe_R" ), 1, 0.1, self.sideStepRate, true );

	if ( self.swim.trackState != "track_strafe" )
		self Swim_Track_Set( "track_strafe" );

	Swim_ClearLeanAnims();
}
MoveSwim_Combat_Strafe_Exit()
{
	self ClearAnim( %combatrun_forward, 0.2 );
	self ClearAnim( %combatrun_backward, 0.2 );
	self ClearAnim( %combatrun_left, 0.2 );
	self ClearAnim( %combatrun_right, 0.2 );
}

Swim_Track_Set( trackState )
{
	if ( self.swim.trackState == trackState )
		return;

	[[ self.swim.stateFns[ self.swim.trackState ][ 1 ] ]] ();
	[[ self.swim.stateFns[ trackState ][ 0 ] ]] ();
	self.swim.trackState = trackState;
}
Swim_Track_Forward_Enter()
{
	self SetAnimLimited( GetSwimAnim( "aim_move_D" ) );
	self SetAnimLimited( GetSwimAnim( "aim_move_L" ) );
	self SetAnimLimited( GetSwimAnim( "aim_move_R" ) );
	self SetAnimLimited( GetSwimAnim( "aim_move_U" ) );

	self thread MoveSwim_Track_Combat();
}
Swim_Track_Forward_Exit()
{
	self ClearAnim( %aim_2, 0.2 );
	self ClearAnim( %aim_4, 0.2 );
	self ClearAnim( %aim_6, 0.2 );
	self ClearAnim( %aim_8, 0.2 );
}
Swim_Track_Strafe_Enter()
{
}
Swim_Track_Strafe_Exit()
{
	self ClearAnim( %w_aim_4, 0.2 );
	self ClearAnim( %w_aim_6, 0.2 );
	self ClearAnim( %w_aim_8, 0.2 );
	self ClearAnim( %w_aim_2, 0.2 );
}

MoveSwim_Track_Combat()
{
	self endon( "killanimscript" );
	self endon( "end_face_enemy_tracking" );

	if ( !IsDefined( self.aim_while_moving_thread ) )
	{
		self.aim_while_moving_thread = true;
		self SetDefaultAimLimits();
/#
		self.trackLoopThread = thisthread;
		self.trackLoopThreadType = "faceEnemyAimTracking";
#/
		self animscripts\track::TrackLoop( %w_aim_2, %w_aim_4, %w_aim_6, %w_aim_8 );
	}
}

GetSwimAnim( animName, animName2 )
{
	assertEx( IsDefined( anim.archetypes["soldier"]["swim"] ), "must call _swim_ai::init_swim_anims() first!" );
	myAnim = LookupAnim( "swim", animName );
	if ( IsDefined( animName2 ) )
		return myAnim[animName2];
	else
		return myAnim;
}

Swim_ShouldDoNodeExit()
{
	if ( IsDefined( self.disableExits ) )
		return false;

	if ( !IsDefined( self.pathGoalPos ) )
		return false;

	if ( !self ShouldFaceMotion() )
		return false;

	if ( DistanceSquared( self.origin, self.pathGoalPos ) < 10000 )
		return false;

	if ( self.a.movement != "stop" )
		return false;

	if ( LengthSquared( self.prevAnimDelta ) > 1 )
	{
		animAngles = VectorToAngles( self.prevAnimDelta );
		// if animation was moving forward.
		if ( abs( AngleClamp180( animAngles[1] - self.angles[1] ) ) < 90 )
			return false;
	}

	return true;
}

// exit node or idle to move
Swim_MoveBegin()
{
	self.a.pose = "stand";	// just in case something random borked this.  like playing a scripted crouch anim.

	if ( !self Swim_ShouldDoNodeExit() )
		return;

	startAnimStruct = Swim_ChooseStart();
	if ( !IsDefined( startAnimStruct ) )
		return;

	turnAnim = startAnimStruct.m_TurnAnim;
	startAnim = startAnimStruct.m_Anim;
	animAngleDelta = startAnimStruct.m_AngleDelta;

	lookaheadAngles = VectorToAngles( self.lookaheadDir );
	facingAngles = lookaheadAngles - animAngleDelta;
	facingDir = anglestoforward( facingAngles );

	self AnimMode( "nogravity", false );

	rate = randomfloatrange( 0.9, 1.1 );
	blendTime = 0.3;

	if ( IsDefined( turnAnim ) )
	{
		self OrientMode( "face current" );
		self SetFlaggedAnimKnobAllRestart( "startturn", turnAnim, %body, 1, 0.3, rate * self.movePlaybackRate );
		self animscripts\shared::DoNoteTracks( "startturn" );
		blendTime = 0.5;
	}

	prevTurnRate = self.turnRate;
	
	self.turnRate = 0.05;
	self OrientMode( "face direction", facingDir );

	self SetFlaggedAnimKnobAllRestart( "startmove", startAnim, %body, 1, blendTime, rate * self.movePlaybackRate );
	self animscripts\shared::DoNoteTracks( "startmove" );

	self OrientMode( "face default" );
	self AnimMode( "none", false );
	
	//if ( AnimHasNotetrack( startAnim, "code_move" ) )
	//	self animscripts\shared::DoNoteTracks( "startmove" );	// return on code_move

	self.turnRate = prevTurnRate;
}

Swim_SetLeanAnims()
{
	self SetAnimLimited( GetSwimAnim("turn_add_l") );
	self SetAnimLimited( GetSwimAnim("turn_add_r") );
	self SetAnimLimited( GetSwimAnim("turn_add_u") );
	self SetAnimLimited( GetSwimAnim("turn_add_d") );
}

Swim_ClearLeanAnims()
{
	self ClearAnim( %add_turn_l, 0.2 );
	self ClearAnim( %add_turn_r, 0.2 );
	self ClearAnim( %add_turn_u, 0.2 );
	self ClearAnim( %add_turn_d, 0.2 );
}

Swim_ChooseStart()
{
	desiredAngles = VectorToAngles( self.lookaheadDir );

	bInCombat = self IsInCombat();
	exitNode = animscripts\exit_node::GetExitNode();
	myAngles = self.angles;

	bGetAngleDelta = false;
	bUseIdleTurn = false;

	szAnims = undefined;
	if ( IsDefined( exitNode ) && IsDefined( exitNode.type ) )
	{
		exitType = Swim_GetApproachType( exitNode );
		if ( exitType != "exposed" )
		{
			szAnims = "exit_" + exitType;
			myAngles = exitNode.angles;
			bGetAngleDelta = true;
		}
	}
	if ( !IsDefined( szAnims ) )
	{
		if ( bInCombat )
		{
			szAnims = "idle_ready_to_forward";
		}
		else
		{
			szAnims = "idle_to_forward";
			bUseIdleTurn = true;
			bGetAngleDelta = true;
		}
	}

	swimAnims = GetSwimAnim( szAnims );
	assertex( IsDefined( swimAnims ), "exit anims for type " + szAnims + " not found" );

	dYaw = AngleClamp180( desiredAngles[1] - myAngles[1] );
	dPitch = AngleClamp180( desiredAngles[0] - myAngles[0] );

	yawIndex = Swim_GetAngleIndex( dYaw );
	pitchIndex = Swim_GetAngleIndex( dPitch );

	animStruct = SpawnStruct();

	if ( bUseIdleTurn )
	{
		turnAnims = GetSwimAnim( "idle_turn" );
		if ( IsDefined( turnAnims[ yawIndex ] ) )
		{
			animStruct.m_TurnAnim = turnAnims[ yawIndex ];
			yawIndex = 4;
		}
	}

	if ( IsDefined( swimAnims[ yawIndex ] ) && IsDefined( swimAnims[ yawIndex ][ pitchIndex ] ) )
	{
		animStruct.m_Anim = swimAnims[ yawIndex ][ pitchIndex ];
		if ( bGetAngleDelta )
		{
			swimAnims = GetSwimAnim( szAnims + "_angleDelta" );
			animStruct.m_AngleDelta = swimAnims[ yawIndex ][ pitchIndex ];
		}
		else
		{
			animStruct.m_AngleDelta = ( 0, 0, 0 );
		}
		return animStruct;
	}

	animStruct = undefined;
	return undefined;
}


// cover arrival
Swim_SetupApproach()
{
	self endon( "killanimscript" );
	self endon( "swim_cancelapproach" );
	//self endon( "goal_changed" );
	//self endon( "path_changed" );

	// keep this ahead of the early outs, in case conditions change while we aren't listening for it.
	self thread Swim_RestartApproachListener();

	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
		return;

	self.swim.arrivalPathGoalPos = self.pathGoalPos;

	if ( IsDefined( self GetNegotiationStartNode() ) )
		return;

	approachEnt = animscripts\cover_arrival::GetApproachEnt();
	if ( IsDefined( approachEnt ) && Swim_IsApproachableNode( approachEnt ) )
		self thread Swim_ApproachNode();
	else
		self thread Swim_ApproachPos();
}

// restart approach process if we suddenly start going somewhere else.
Swim_RestartApproachListener()
{
	self endon( "killanimscript" );
	self endon( "swim_killrestartlistener" );
	//self waittill_any( "goal_changed", "path_changed", "path_set" );
	self waittill( "path_set" );

	bFalseAlarm = IsDefined( self.pathGoalPos ) && IsDefined( self.swim.arrivalPathGoalPos ) && DistanceSquared( self.pathGoalPos, self.swim.arrivalPathGoalPos ) < 4;

	if ( bFalseAlarm )
	{
		self thread Swim_RestartApproachListener();
		return;
	}

	self Swim_CancelCurrentApproach();
	self Swim_SetupApproach();
}

Swim_CancelCurrentApproach()
{
	self notify( "swim_cancelapproach" );
	self.stopAnimDistSq = 0;	// in case we were canceled while doing WaitForApproachPos.
}

Swim_WaitForApproachPos( goal, dist )
{
	self endon( "swim_cancelwaitforapproachpos" );
	distSq = (dist+60) * (dist+60);

	meToGoalDistSq = DistanceSquared( goal, self.origin );
	if ( meToGoalDistSq <= distSq )
		return;

	self.stopAnimDistSq = distSq;
	self waittill( "stop_soon" );
	self.stopAnimDistSq = 0;
}

Swim_ApproachPos()
{
	self endon( "killanimscript" );
	self endon( "swim_cancelapproach" );
	//self endon( "goal_changed" );
	//self endon( "path_changed" );
	self endon( "move_interrupt" );
	self endon( "swim_killrestartlistener" );

	if ( !IsDefined( self.pathGoalPos ) )
		return;

	maxAnimDist = self Swim_GetMaxAnimDist( "arrival_exposed" );
	self Swim_WaitForApproachPos( self.pathGoalPos, maxAnimDist );
	// woot, now i'm close enough to my destination to get down to business.

	self Swim_DoPosArrival();
}

Swim_ApproachNode()
{
	self endon( "killanimscript" );
	self endon( "swim_cancelapproach" );
	//self endon( "goal_changed" );
	//self endon( "path_changed" );
	self endon( "swim_killrestartlistener" );

	approachEnt = animscripts\cover_arrival::GetApproachEnt();
	// set this early, in case cover_approach never hits, which can happen if, for instance, the color system
	// bounces the actor between two nodes within a single frame.  the setgoalnode will clear the approach notify,
	// but because 'nothing changed' between frames, the restart listener won't pick up on anything.
	self.approachType = Swim_GetApproachType( approachEnt );

	// from code: wait until 500" away.  approachDir is the 2D vector from last-ish node in the path to the destination.
	self.requestArrivalNotify = true;
	self waittill( "cover_approach", approachDir );

	approachEnt = animscripts\cover_arrival::GetApproachEnt();

	approachType = Swim_GetApproachType( approachEnt );
	finalFacingAngles = GetNodeForwardAngles( approachEnt );

	// fork this off for different endon conditions.
	self thread Swim_DoFinalArrival( approachType, approachEnt.origin, approachDir, approachEnt.angles, finalFacingAngles );
}

Swim_DoPosArrival()
{
	goalNode = animscripts\cover_arrival::GetApproachEnt();
	goalPos = self.pathGoalPos;

	goalAngles = ( 0, self.angles[1], self.angles[2] );		// arrival to idle pitch-zero position.
	if ( IsDefined( goalNode ) && goalNode.type != "Path" )
	{
		goalAngles = GetNodeForwardAngles( goalNode );
	}
	else if ( animscripts\cover_arrival::FaceEnemyAtEndOfApproach( ) )
	{
		goalAngles = VectorToAngles( self.enemy.origin - goalPos );
	}

	approachDir = VectorNormalize( goalPos - self.origin );

	if ( IsDefined( goalNode ) && Swim_IsApproachableNode( goalNode ) )
	{	// i'm not sure there ever really ought to be a goalNode defined at this point...
		approachType = Swim_GetApproachType( goalNode );
		finalFacingAngles = GetNodeForwardAngles( goalNode );
		self thread Swim_DoFinalArrival( approachType, goalNode.origin, approachDir, goalNode.angles, finalFacingAngles );
		return;
	}

	// fork this off for different endon conditions.
	self thread Swim_DoFinalArrival( "exposed", goalPos, approachDir, goalAngles, goalAngles );
}

Swim_DoFinalArrival( a_ApproachType, a_GoalPos, a_ApproachDir, a_GoalAngles, a_FinalFacingAngles )
{
	self endon( "killanimscript" );
	self endon( "swim_cancelapproach" );

	self.approachType = a_ApproachType;

	approachAnim = spawnStruct();
	if ( !Swim_DetermineApproachAnim( approachAnim, a_ApproachType, a_GoalPos, a_ApproachDir, a_GoalAngles, a_FinalFacingAngles ) )
		return;
	
	// have we already passed worldStartPos?  if so, then we don't want to turn around just so we can do it.  forget it.
	facingDir = AnglesToForward( self.angles );
	meToStartPos = approachAnim.m_WorldStartPos - self.origin;
	distMeToStartPos = Length( meToStartPos );
	meToStartPos = meToStartPos / distMeToStartPos;
	if ( VectorDot( meToStartPos, facingDir ) < 0.5 )	// cos(60)
		return;	// angle too sharp.  not gonna look good.

	if ( distMeToStartPos > 4 )
	{
		self.swim.arrivalPathGoalPos = approachAnim.m_WorldStartPos;	// setruntopos triggers the restart listener.  set this so it knows to ignore this case.
		self SetRunToPos( approachAnim.m_WorldStartPos );	// tell our guy to go to the anim start position, instead of the final position.
		self waittill( "runto_arrived" );
	}

	self notify( "swim_killrestartlistener" );	// kill the listener, no longer necessary.

	// my situation may have changed.  double-check my animation.
	// not going to redirect him to the new dest, if any.  we should be close enough.
	approachDir = VectorNormalize( a_GoalPos - self.origin );
	if ( !Swim_DetermineApproachAnim( approachAnim, a_ApproachType, a_GoalPos, approachDir, a_GoalAngles, a_FinalFacingAngles ) )
		return;

	self.swim.arrivalAnim = approachAnim.m_Anim;

	//self.pitchRate = 0.05;
	//self.turnRate = 0.05;
	self StartCoverArrival( approachAnim.m_WorldStartPos, a_FinalFacingAngles[1] - approachAnim.m_AngleDelta[1], a_FinalFacingAngles[0] - approachAnim.m_AngleDelta[0] );
}

Swim_CoverArrival_Main()
{
	self endon( "killanimscript" );
	self endon( "abort_approach" );

	assert( IsDefined( self.approachType ) );

	approachType = "arrival_" + self.approachType;

	arrivalAnim = self.swim.arrivalAnim;

	assert( IsDefined( arrivalAnim ) );

	// fixed node means i want the guy to get there, even if he's threatened.
	// otherwise he's threatened, he cancels, code sends him right back, he's threatened, he cancels...
	if ( !self.fixednode )
		self thread animscripts\cover_arrival::AbortApproachIfThreatened();
	
	self ClearAnim( %body, 0.2 );
	self SetFlaggedAnimRestart( "coverArrival", arrivalAnim, 1, 0.2, self.moveTransitionRate );
	self animscripts\shared::DoNoteTracks( "coverArrival", ::Swim_HandleStartCoverAim );

	self.a.pose = "stand";
	self.a.movement = "stop";
	self.a.arrivalType = self.approachType;

	// we rely on cover to start doing something else with animations very soon.
	// in the meantime, we don't want any of our parent nodes lying around with positive weights.
	self ClearAnim( %root, .3 );
	
	self.lastApproachAbortTime = undefined;
	self.swim.arrivalAnim = undefined;
}

Swim_GetAnimStartPos( goalPos, goalAngles, animTranslation, animAngles )
{
	dAngles = goalAngles - animAngles;
	vForward = AnglesToForward( dAngles );
	vRight = AnglesToRight( dAngles );
	vUp = AnglesToUp( dAngles );

	forward = vForward * animTranslation[0];
	right = vRight * animTranslation[1];
	up = vUp * animTranslation[2];

	return goalPos - forward + right - up;
}

Swim_DetermineApproachAnim( approachAnimResult, approachType, goalPos, approachDir, goalAngles, finalFacingAngles )
{
	// approachDir can be 2D.  either something went wrong to make it (0,0,0),
	// or we're straight up/down, which doesn't require an animation.
	if ( LengthSquared( approachDir ) < 0.003 )
		return false;

	approachAngles = VectorToAngles( approachDir );
	// yaw diff
	if ( approachType == "exposed" )
	{
		yawIndex = 4;
		secondaryYawIndex = 4;
	}
	else
	{
		dYaw = AngleClamp180( goalAngles[1] - approachAngles[1] );
		yawIndex = Swim_GetAngleIndex( dYaw );
		secondaryYawIndex = Swim_GetAngleIndex( dYaw, 25 );
	}

	// pitch diff
	dPitch = AngleClamp180( goalAngles[0] - approachAngles[0] );
	pitchIndex = Swim_GetAngleIndex( dPitch );
	secondaryPitchIndex = Swim_GetAngleIndex( dPitch, 25 );

	szType = "arrival_" + approachType;
	if ( approachType == "exposed" && !(self IsInCombat( false )) )
		szType += "_noncombat";
	animArray = GetSwimAnim( szType );

	if ( !IsDefined( animArray[ yawIndex ] ) || !IsDefined( animArray[ yawIndex ][ pitchIndex ] ) )
		return false;

	bValidSecondaries = ( yawIndex != secondaryYawIndex || pitchIndex != secondaryPitchIndex )
		&& IsDefined( animArray[ secondaryYawIndex ] ) && IsDefined( animArray[ secondaryYawIndex ][ secondaryPitchIndex ] );

	m_Anim = animArray[ yawIndex ][ pitchIndex ];
	//approachAnimResult.m_Anim = animArray[ yawIndex ][ pitchIndex ];

	// initialize to make compiler happy.
	delta2 = 0;
	angleDelta2 = 0;

	deltaType = szType + "_delta";
	animArray = GetSwimAnim( deltaType );
	assert( IsDefined( animArray[ yawIndex ] ) && IsDefined( animArray[ yawIndex ][ pitchIndex ] ) );
	//approachAnimResult.m_Delta = animArray[ yawIndex ][ pitchIndex ];
	m_Delta = animArray[ yawIndex ][ pitchIndex ];
	if ( bValidSecondaries )
	{
		assert( IsDefined( animArray[ secondaryYawIndex ] ) && IsDefined( animArray[ secondaryYawIndex ][ secondaryPitchIndex ] ) );
		delta2 = animArray[ secondaryYawIndex ][ secondaryPitchIndex ];
	}

	angleDeltaType = szType + "_angleDelta";
	animArray = GetSwimAnim( angleDeltaType );
	assert( IsDefined( animArray[ yawIndex ] ) && IsDefined( animArray[ yawIndex ][ pitchIndex ] ) );
	//approachAnimResult.m_AngleDelta = animArray[ yawIndex ][ pitchIndex ];
	m_AngleDelta = animArray[ yawIndex ][ pitchIndex ];
	if ( bValidSecondaries )
	{
		assert( IsDefined( animArray[ secondaryYawIndex ] ) && IsDefined( animArray[ secondaryYawIndex ][ secondaryPitchIndex ] ) );
		angleDelta2 = animArray[ secondaryYawIndex ][ secondaryPitchIndex ];
	}

	m_WorldStartPos = Swim_GetAnimStartPos( goalPos, finalFacingAngles, m_Delta, m_AngleDelta );
	if ( !self MayMoveFromPointToPoint( goalPos, m_WorldStartPos, false, true ) && bValidSecondaries )
	{	// if that didn't work, then we're on to checking the secondary (less-good) indices.
		m_Anim = animArray[ secondaryYawIndex ][ secondaryPitchIndex ];
		m_Delta = delta2;
		m_AngleDelta = angleDelta2;
		m_WorldStartPos = Swim_GetAnimStartPos( goalPos, finalFacingAngles, m_Delta, m_AngleDelta );
		if ( !self MayMoveFromPointToPoint( goalPos, m_WorldStartPos, false, true ) )
			return false;	// the good point didn't work, and the less-good point didn't work.
	}

	approachAnimResult.m_Anim = m_Anim;
	approachAnimResult.m_Delta = m_Delta;
	approachAnimResult.m_AngleDelta = m_AngleDelta;
	approachAnimResult.m_WorldStartPos = m_WorldStartPos;

	return true;
}


// -180, -135, -90, -45, 0, 45, 90, 135, 180
// favor underturning, unless you're within <threshold> degrees of the next one up.
Swim_GetAngleIndex( angle, threshold )
{
	if ( !IsDefined( threshold ) )
		threshold = 10;

	if ( angle < 0 )
		return int( ceil( ( 180 + angle - threshold ) / 45 ) );
	else
		return int( floor( ( 180 + angle + threshold ) / 45 ) );
}

Swim_GetMaxAnimDist( animType )
{
	maxDelta = anim.archetypes["soldier"]["swim"][animType]["maxDelta"];
	if ( IsDefined( self.animArchetype ) && self.animArchetype != "soldier" )
	{
		assert( IsDefined( anim.archetypes[self.animArchetype] ) );
		if ( IsDefined( anim.archetypes[self.animArchetype]["swim"] ) && IsDefined( anim.archetypes[self.animArchetype]["swim"][animType] ) )
		{
			thisMaxDelta = anim.archetypes[self.animArchetype]["swim"][animType]["maxDelta"];
			assert( IsDefined( thisMaxDelta) );
			if ( thisMaxDelta > maxDelta )
				maxDelta = thisMaxDelta;
		}
	}
	return maxDelta;
}

Swim_HandleStartCoverAim( note )
{
	if ( note != "start_aim" )
		return;

	self animscripts\combat::set_aim_and_turn_limits();

	self.previousPitchDelta = 0.0;
		
	animscripts\combat_utility::SetupAim( 0 );
		
	self thread animscripts\track::TrackShootEntOrPos();
}

Swim_GetApproachType( approachEnt )
{
	approachType = approachEnt.type;
	if ( !IsDefined( approachType ) )
		return "exposed";

	switch ( approachType )
	{
	case "Cover Right 3D":
		return "cover_corner_r";
	case "Cover Left 3D":
		return "cover_corner_l";
	case "Cover Up 3D":
		return "cover_u";
	case "Exposed 3D":
	case "Path 3D":
		return "exposed";
	default:
		assertex(false, approachType + " is not a supported swim node type.");
	}
}

GetNodeForwardAngles( node )
{
	angles = node.angles;
	yaw = angles[1];
	if ( IsNodeCoverLeft( node ) )
	{
		myAnim = GetSwimAnim( "arrival_cover_corner_l_angleDelta" );
		yaw = yaw + myAnim[4][4][1];
	}
	else if ( IsNodeCoverRight( node ) )
	{
		myAnim = GetSwimAnim( "arrival_cover_corner_r_angleDelta" );
		yaw = yaw + myAnim[4][4][1];
	}
	angles = ( angles[0], yaw, angles[2] );
	return angles;
}


Swim_DoStrafe()
{
	if ( self.swim.moveState != "combat_strafe" )
		MoveSwim_Combat_Move_Set( "combat_strafe" );

	swimAnim = GetSwimAnim( "forward_aim" );
	self SetFlaggedAnimKnobLimited( "swimanim", swimAnim, 1, 0.1, 1, true );

	// Update the strafe weights while we're playing our requisite 0.2s of forward anim.
	self thread Swim_UpdateStrafeAnim();

	DoNoteTracksForTime( 0.2, "swimanim" );
	self notify( "end_swim_updatestrafeanim" );
}

Swim_UpdateStrafeAnim()
{
	self endon( "killanimscript" );
	self endon( "move_interrupt" );
	self endon( "move_mode" );

	self endon( "end_swim_updatestrafeanim" );

	bWasFacingMotion = false;

	while ( true )
	{
		if ( self.faceMotion )
		{
			if ( !bWasFacingMotion )
			{
				self Swim_SetStrafeWeights( 1.0, 0.0, 0.0, 0.0 );
				self Swim_SetStrafeAimWeights( 0, 0, 0, 0 );
			}
		}
		else
		{
		    animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
    		if ( IsDefined( self.update_move_front_bias ) )
			{
				animWeights[ "back" ] = 0.0;
				if ( animWeights[ "front" ] < .2 )
					animWeights[ "front" ] = .2;
			}

			strafeDir = self Swim_SetStrafeWeights( animWeights[ "front" ], animWeights[ "back" ], animWeights[ "left" ], animWeights[ "right" ] );
			self Swim_SetStrafeAimSet( strafeDir );
			self Swim_UpdateStrafeAimAnim();
		}

		bWasFacingMotion = self.faceMotion;

		wait( 0.05 );
		waittillframeend;
	}
}

Swim_SetStrafeWeights( f, b, l, r )
{
	self SetAnim( %combatrun_forward, f, 0.5, 1, true );
	self SetAnim( %combatrun_backward, b, 0.5, 1, true );
	self SetAnim( %combatrun_left, l, 0.5, 1, true );
	self SetAnim( %combatrun_right, r, 0.5, 1, true );

	if ( f > 0 ) return "front";
	else if ( b > 0 ) return "back";
	else if ( l > 0 ) return "left";
	else if ( r > 0 ) return "right";
}

// x_x
Swim_SetStrafeAimSet( strafeDir )
{
	switch ( strafeDir )
	{
	case "front":
		self SetAnimKnobLimited( GetSwimAnim("aim_move_U"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("aim_move_D"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("aim_move_L"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("aim_move_R"), 1, 0.1 );
		break;
	case "back":
		self SetAnimKnobLimited( GetSwimAnim("strafe_B_aim_U"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_B_aim_D"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_B_aim_L"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_B_aim_R"), 1, 0.1 );
		break;
	case "left":
		self SetAnimKnobLimited( GetSwimAnim("strafe_L_aim_U"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_L_aim_D"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_L_aim_L"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_L_aim_R"), 1, 0.1 );
		break;
	case "right":
		self SetAnimKnobLimited( GetSwimAnim("strafe_R_aim_U"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_R_aim_D"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_R_aim_L"), 1, 0.1 );
		self SetAnimKnobLimited( GetSwimAnim("strafe_R_aim_R"), 1, 0.1 );
		break;
	default:
		assert(false);
	}
}

Swim_UpdateStrafeAimAnim()
{
	myYaw = self.angles[1];
	myPitch = self.angles[0];

	u = 0;
	d = 0;
	l = 0;
	r = 0;

	cMaxYaw = 45;
	cMaxPitch = 60;

	if ( IsDefined( self.enemy ) )
	{
		vMeToEnemy = self.enemy.origin - self.origin;
		enemyAngles = VectorToAngles( vMeToEnemy );

		dYaw = AngleClamp180( enemyAngles[1] - myYaw );
		dPitch = AngleClamp180( enemyAngles[0] - myPitch );

		if ( dYaw > 0 )
			l = Clamp( 1 - ( ( cMaxYaw - dYaw ) / cMaxYaw ), 0, 1 );
		else
			r = Clamp( 1 - ( ( cMaxYaw + dYaw ) / cMaxYaw ), 0, 1 );

		if ( dPitch > 0 )
			d = Clamp( 1 - ( ( cMaxPitch - dPitch ) / cMaxPitch ), 0, 1 );
		else
			u = Clamp( 1 - ( ( cMaxPitch + dPitch ) / cMaxPitch ), 0, 1 );
	}

	self Swim_SetStrafeAimWeights( u, d, l, r );
}

Swim_SetStrafeAimWeights( u, d, l, r )
{
	self SetAnim( %w_aim_4, l, 0.2, 1, true );
	self SetAnim( %w_aim_6, r, 0.2, 1, true );
	self SetAnim( %w_aim_8, u, 0.2, 1, true );
	self SetAnim( %w_aim_2, d, 0.2, 1, true );
}

Swim_PathChange_GetTurnAnim( yawDiff, pitchDiff )
{
	assert( IsDefined( pitchDiff ) );

	turnAnim = undefined;
	secondTurnAnim = undefined;
	
	animArray = animscripts\swim::GetSwimAnim( "turn" );

	// ceil/floor because we'd like to underturn if possible.  it looks better than overturning.
	// we have turn anims for every 45 degrees.
	// +180 to end up with positive numbers.
	// +/- 10 because we'll allow overturning if we're pretty close to that angle, or because we don't have a turn0.
	yawIndex = Swim_GetAngleIndex( yawDiff );
	pitchIndex = Swim_GetAngleIndex( pitchDiff );

	if ( IsDefined( animArray[ yawIndex ] ) )
		turnAnim = animArray[ yawIndex ][ pitchIndex ];

	if ( IsDefined( turnAnim ) )
	{
		if ( animscripts\move::PathChange_CanDoTurnAnim( turnAnim ) )
			return turnAnim;
	}

	return undefined;
}

Swim_CleanupTurnAnim()
{
	if ( self.swim.combatState == "noncombat" )
	{
		self Swim_SetLeanAnims();
	}
	else if ( self.swim.combatState == "combat" && self.swim.moveState == "combat_forward" )
		self Swim_SetLeanAnims();
}

Swim_UpdateLeanAnim()
{
	leanFrac = Clamp( self.leanAmount / 25.0, -1, 1 );
	if ( leanFrac > 0 )
	{
		self SetAnim( %add_turn_l, leanFrac, 0.2, 1, true );
		self SetAnim( %add_turn_r, 0.0, 0.2, 1, true );
	}
	else
	{
		self SetAnim( %add_turn_l, 0, 0.2, 1, true );
		self SetAnim( %add_turn_r, 0-leanFrac, 0.2, 1, true );
	}

	leanFrac = Clamp( self.pitchAmount / 25.0, -1, 1 );
	if ( leanFrac > 0 )
	{
		self SetAnim( %add_turn_d, leanFrac, 0.2, 1, true );
		self SetAnim( %add_turn_u, 0.0, 0.2, 1, true );
	}
	else
	{
		self SetAnim( %add_turn_d, 0, 0.2, 1, true );
		self SetAnim( %add_turn_u, 0-leanFrac, 0.2, 1, true );
	}
}

Swim_IsApproachableNode( node )
{
	switch ( node.type )
	{
	case "Cover Right 3D":
	case "Cover Left 3D":
	case "Cover Up 3D":
	case "Exposed 3D":
		return true;
	}
	return false;
}