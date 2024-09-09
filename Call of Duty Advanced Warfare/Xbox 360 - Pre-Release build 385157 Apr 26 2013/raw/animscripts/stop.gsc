// "Stop" makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 

#include animscripts\combat_utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#using_animtree( "generic_human" );

init_animset_idle()
{
	initAnimSet = [];
	initAnimSet["stand"][0] = [ %casual_stand_idle, %casual_stand_idle_twitch, %casual_stand_idle_twitchB ];
	initAnimSet["stand"][1] = [ %casual_stand_v2_idle, %casual_stand_v2_twitch_radio, %casual_stand_v2_twitch_shift, %casual_stand_v2_twitch_talk ];
	initAnimSet["stand_cqb"][0] = [ %cqb_stand_idle, %cqb_stand_twitch ];
	initAnimSet["crouch"][0] = [ %casual_crouch_idle ];

	assert( !isdefined( anim.archetypes["soldier"]["idle"] ) );
	anim.archetypes[ "soldier" ]["idle"] = initAnimSet;

	initAnimSet = [];
	initAnimSet["stand"][0] = [ 2, 1, 1 ];
	initAnimSet["stand"][1] = [ 10, 4, 7, 4 ];
	initAnimSet["stand_cqb"][0] = [ 2, 1 ];
	initAnimSet["crouch"][0] = [ 6 ];

	assert( !isdefined( anim.archetypes["soldier"]["idle_weights"] ) );
	anim.archetypes[ "soldier" ]["idle_weights"] = initAnimSet;

	initAnimSet = [];
	initAnimSet["stand"] = %casual_stand_idle_trans_in;
	initAnimSet["crouch"] = %casual_crouch_idle_in;
	initAnimSet["stand_smg"] = %smg_casual_stand_idle_trans_in;

	assert( !isdefined( anim.archetypes["soldier"]["idle_transitions"] ) );
	anim.archetypes[ "soldier" ]["idle_transitions"] = initAnimSet;
}

main()
{
	if ( IsDefined( self.no_ai ) )
		return;

	if ( IsDefined( self.custom_animscript ) )
	{
		if ( IsDefined( self.custom_animscript[ "stop" ] ) )
		{
			[[ self.custom_animscript[ "stop" ] ]]();
			return;
		}
	}

	self notify( "stopScript" );
	self endon( "killanimscript" );
	 /#
	if ( getdebugdvar( "anim_preview" ) != "" )
		return;
	#/

	[[ self.exception[ "stop_immediate" ] ]]();
	// We do the exception_stop script a little late so that the AI has some animation they're playing
	// otherwise they'd go into basepose.
	thread DelayedException();

	animscripts\utility::Initialize( "stop" );
	
	if ( IsDefined( self.specialIdleAnim ) )
	{
		SpecialIdleLoop();
	}

	self RandomizeIdleSet();

	self thread SetLastStoppedTime();
	self thread animscripts\reactions::ReactionsCheckLoop();

	bTransitionedToIdle = IsDefined( self.customIdleAnimSet );
	if ( !bTransitionedToIdle )
	{
		if ( self.a.weaponPos[ "right" ] == "none" && self.a.weaponPos[ "left" ] == "none" )
			bTransitionedToIdle = true;
		else if ( AngleClamp180( self GetMuzzleAngle()[ 0 ] ) > 20 )
			bTransitionedToIdle = true;
	}

	if ( self.swimmer && !IsDefined( self.enemy ) )
	{
		exitNode = animscripts\exit_node::GetExitNode();
		if ( IsDefined( exitNode ) )
			TurnToAngle( exitNode.angles[1] );
		else
		self OrientMode( "face angle", self.angles[1] );
	}

	for ( ;; )
	{
		desiredPose = GetDesiredIdlePose();

		if ( desiredPose == "prone" )
		{
			bTransitionedToIdle = true;
			self ProneStill();
		}
		else
		{
			assertex( desiredPose == "crouch" || desiredPose == "stand", desiredPose );

			if ( self.a.pose != desiredPose )
			{
				self ClearAnim( %root, 0.3 );
				bTransitionedToIdle = false;
			}
			self SetPoseMovement( desiredPose, "stop" );

			if ( !bTransitionedToIdle )
			{
				self TransitionToIdle( desiredPose, self.a.idleSet );
				bTransitionedToIdle = true;
			}
			else
			{
				self PlayIdle( desiredPose, self.a.idleSet );
			}
		}
	}
}


TurnToAngle( desiredAngle )
{
	currentAngle = self.angles[1];
	angleDiff = AngleClamp180( desiredAngle - currentAngle );

	if ( -20 < angleDiff && angleDiff < 20 )
	{
		RotateToAngle( desiredAngle, 2 );
		return;
	}

	assert( self.swimmer );	// sorry, only writing a swim version at this time.

	turnAnims = animscripts\swim::GetSwimAnim( "idle_turn" );

	if ( angleDiff < -80 )
		turnAnim = turnAnims[ 2 ];	// r90
	else if ( angleDiff < -20 )
		turnAnim = turnAnims[ 3 ];	// r45
	else if ( angleDiff < 80 )
		turnAnim = turnAnims[ 5 ];	// l45
	else
		turnAnim = turnAnims[ 6 ];	// l90

	animLength = GetAnimLength( turnAnim );

	turnTime = abs(angleDiff) / self.turnRate;
	turnTime /= 1000;
	rate = animLength / turnTime;

	self OrientMode( "face angle", desiredAngle );

	self SetFlaggedAnimRestart( "swim_turn", turnAnim, 1, 0.2, rate * self.movePlaybackRate );
	animscripts\shared::DoNoteTracks( "swim_turn" );

	self ClearAnim( turnAnim, 0.2 );
}


RotateToAngle( desiredAngle, tolerance )
{
	self OrientMode( "face angle", desiredAngle );
	while ( AngleClamp( desiredAngle - self.angles[1] ) > tolerance )
		wait ( 0.1 );
}


SetLastStoppedTime()
{
	self endon( "death" );
	self waittill( "killanimscript" );
	self.lastStoppedTime = gettime();
}

SpecialIdleLoop()
{
	self endon( "stop_specialidle" );
	
	assert( IsDefined( self.specialIdleAnim ) );

	idleAnimArray = self.specialIdleAnim;
//	removing these since it seems that everyone that wants to replace an idle anim is having to work around this
//	self.specialIdleAnim = undefined;
//	self notify( "clearing_specialIdleAnim" );
	
	self AnimMode( "gravity" );
	self OrientMode( "face current" );

	self ClearAnim( %root, .2 );	
	
	while ( 1 )
	{
		self SetFlaggedAnimRestart( "special_idle", idleAnimArray[ randomint( idleAnimArray.size ) ], 1, 0.2, self.animPlaybackRate );
		self waittillmatch( "special_idle", "end" );
	}	
}

GetDesiredIdlePose()
{
	myNode = animscripts\utility::GetClaimedNode();
	if ( IsDefined( myNode ) )
	{
		myNodeAngle = myNode.angles[ 1 ];
		myNodeType = myNode.type;
	}
	else
	{
		myNodeAngle = self.desiredAngle;
		myNodeType = "node was undefined";
	}

	self animscripts\face::SetIdleFace( anim.alertface );

	// Find out if we should be standing, crouched or prone
	desiredPose = animscripts\utility::ChoosePose();

	if ( myNodeType == "Cover Stand" || myNodeType == "Conceal Stand" )
	{
		// At cover_stand nodes, we don't want to crouch since it'll most likely make our gun go through the wall.
		desiredPose = animscripts\utility::ChoosePose( "stand" );
	}
	else if ( myNodeType == "Cover Crouch" || myNodeType == "Conceal Crouch" )
	{
		// We should crouch at concealment crouch nodes.
		desiredPose = animscripts\utility::ChoosePose( "crouch" );
	}
	else if ( myNodeType == "Cover Prone" || myNodeType == "Conceal Prone" )
	{
		// We should go prone at prone nodes.
		desiredPose = animscripts\utility::ChoosePose( "prone" );
	}

	return desiredPose;
}

TransitionToIdle( pose, idleSet )
{
	if ( self IsCQBWalking() && self.a.pose == "stand" )
		pose = "stand_cqb";
	else if ( usingSMG() && self.a.pose == "stand" )
		pose = "stand_smg";

	idle_transitions = self lookupAnimArray( "idle_transitions" );

	if ( IsDefined( idle_transitions[ pose ] ) )
	{
		// idles and transitions should have no tag origin movement
		//self animmode( "zonly_physics", false );
		idleAnim = idle_transitions[ pose ];
		self SetFlaggedAnimKnobAllRestart( "idle_transition", idleAnim, %body, 1, .2, self.animPlaybackRate );
		self animscripts\shared::DoNoteTracks( "idle_transition" );
		//self animmode( "normal", false );
	}
}

PlayIdle( pose, idleSet )
{
	if ( self IsCQBWalking() && self.a.pose == "stand" )
	{
		pose = "stand_cqb";
	}
		
	idleAddAnim = undefined;
	
	if ( IsDefined( self.customIdleAnimSet ) && IsDefined( self.customIdleAnimSet[ pose ] ) )
	{
		if ( IsArray( self.customIdleAnimSet[ pose ] ) )
		{
			idleAnim = anim_array( self.customIdleAnimSet[ pose ], self.customIdleAnimWeights[ pose ] );
		}
		else
		{
			idleAnim = self.customIdleAnimSet[ pose ];
			
			additive = pose + "_add";
			if ( isdefined( self.customIdleAnimSet[ additive ] ) )
				idleAddAnim = self.customIdleAnimSet[ additive ];
		}
	}
	else if ( IsDefined(anim.readyAnimArray) && (pose == "stand" || pose == "stand_cqb") && IsDefined(self.bUseReadyIdle) && self.bUseReadyIdle == true )
	{
		idleAnim = anim_array( anim.readyAnimArray[ "stand" ][ 0 ], anim.readyAnimWeights[ "stand" ][ 0 ] );
	}
	else
	{
		idle_anims = self lookupAnimArray( "idle" );
		idle_anim_weights = self lookupAnimArray( "idle_weights" );
		idleSet = idleSet % idle_anims[ pose ].size;

		idleAnim = anim_array( idle_anims[ pose ][ idleSet ], idle_anim_weights[ pose ][ idleSet ] );
	}

	transTime = 0.2;
	if ( gettime() == self.a.scriptStartTime )
		transTime = 0.5;

	if ( IsDefined( idleAddAnim ) )
	{
		self SetAnimKnobAll( idleAnim, %body, 1, transTime, 1 );
		self SetAnim( %add_idle );
		self SetFlaggedAnimKnobAllRestart( "idle", idleAddAnim, %add_idle, 1, transTime, self.animPlaybackRate );
	}
	else
	{
		self SetFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, transTime, self.animPlaybackRate );
	}
	
	self animscripts\shared::DoNoteTracks( "idle" );
}

ProneStill()
{
	if ( self.a.pose != "prone" )
	{
		anim_array[ "stand_2_prone" ] = %stand_2_prone;
		anim_array[ "crouch_2_prone" ] = %crouch_2_prone;

		transAnim = anim_array[ self.a.pose + "_2_prone" ];
		assertex( IsDefined( transAnim ), self.a.pose );
		assert( AnimHasNotetrack( transAnim, "anim_pose = \"prone\"" ) );

		self SetFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, 1.0 );
		animscripts\shared::DoNoteTracks( "trans" );

		assert( self.a.pose == "prone" );
		self.a.movement = "stop";

		self SetProneAnimNodes( -45, 45, %prone_legs_down, %exposed_modern, %prone_legs_up );

		return;// in case we need to change our pose again for whatever reason
	}

	self thread UpdateProneThread();

	if ( randomint( 10 ) < 3 )
	{
		twitches = self lookupAnim( "cover_prone", "twitch" );
		twitchAnim = twitches[ randomint( twitches.size ) ];
		self SetFlaggedAnimKnobAll( "prone_idle", twitchAnim, %exposed_modern, 1, 0.2 );
	}
	else
	{
		self SetAnimKnobAll( self lookupAnim( "cover_prone", "straight_level" ), %exposed_modern, 1, 0.2 );
		self SetFlaggedAnimKnob( "prone_idle", self lookupAnim( "cover_prone", "exposed_idle" )[0], 1, 0.2 );// ( additive idle on top )
	}
	self waittillmatch( "prone_idle", "end" );

	self notify( "kill UpdateProneThread" );
}

UpdateProneThread()
{
	self endon( "killanimscript" );
	self endon( "kill UpdateProneThread" );

	for ( ;; )
	{
		self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
		wait 0.1;
	}
}

DelayedException()
{
	self endon( "killanimscript" );
	wait( 0.05 );
	[[ self.exception[ "stop" ] ]]();
}