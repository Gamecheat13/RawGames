#include animscripts\anims;
#include animscripts\combat_utility;
#include animscripts\cover_utility;
#include animscripts\utility;
#include common_scripts\Utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree ("generic_human");

corner_think( direction, nodeAngleOffset )
{
	self endon("killanimscript");

	self.coverNode = self.node;
	assert( IsDefined(self.coverNode) );

	self.wasChangingCoverPos = false;
	setCornerDirection(direction);
	self.coverNode.desiredCornerDirection = direction;
	self.a.cornerMode = "unknown";
	
	self.a.standIdleThread = undefined;

	// use exposed turns to rotate into correct facing direction at node
	animscripts\cover_utility::turnToMatchNodeDirection( nodeAngleOffset );
	
	if( self.a.pose != "stand" && self.a.pose != "crouch" )
	{
		assert( self.a.pose == "prone" );
		self ExitProneWrapper(1);
		self.a.pose = "crouch";
	}

	self.isshooting = false;
	self.tracking = false;
	
	self.cornerAiming = false;
	
	animscripts\shared::setAnimAimWeight( 0 );
	
	self.haveGoneToCover = false;
	
	behaviorCallbacks = SpawnStruct();
	behaviorCallbacks.mainLoopStart			= ::mainLoopStart;
	behaviorCallbacks.reload				= ::cornerReload;
	behaviorCallbacks.leaveCoverAndShoot	= ::stepOutAndShootEnemy;
	behaviorCallbacks.look					= ::lookForEnemy;
	behaviorCallbacks.fastlook				= ::fastlook;
	behaviorCallbacks.idle					= ::idle;
	behaviorCallbacks.flinch				= ::flinch;
	behaviorCallbacks.grenade				= ::tryThrowingGrenade;
	behaviorCallbacks.grenadehidden			= ::tryThrowingGrenadeStayHidden;
	behaviorCallbacks.blindfire				= animscripts\cover_utility::blindfire;
	behaviorCallbacks.resetWeaponAnims		= ::resetWeaponAnims;
	behaviorCallbacks.switchSides			= ::switchSides;
	behaviorCallbacks.rambo					= ::rambo;
	
	animscripts\cover_behavior::main( behaviorCallbacks );
}

end_script_corner()
{
	self.blockingPain = false;
}

mainLoopStart()
{
	desiredStance = "stand";
	
	// change stances, if necessary or desired
	if ( self.a.pose == "crouch" )
	{
		desiredStance = "crouch";
		if ( self.coverNode doesNodeAllowStance( "stand" ) )
		{
			if ( !self.coverNode doesNodeAllowStance( "crouch" ) || shouldChangeStanceForFun() )
				desiredStance = "stand";
		}
	}
	else
	{
		if( self.coverNode doesNodeAllowStance( "crouch" ) )
		{
			if( !self.coverNode doesNodeAllowStance( "stand" ) || shouldChangeStanceForFun() )
				desiredStance = "crouch";
		}
	}
	
	/#
		if( shouldForceBehavior( "force_stand" ) && doesNodeAllowStance( "stand" ) )
		desiredStance = "stand";
	else if( shouldForceBehavior( "force_crouch" ) && doesNodeAllowStance( "crouch" ) )
		desiredStance = "crouch";
	#/
		
	if ( self.haveGoneToCover )
	{
		self transitionToStance( desiredStance );
	}
	else
	{
		if ( self.a.pose == desiredStance )
		{
			GoToCover( animArray( "alert_idle" ), .4, .4 );
		}
		else
		{
			stanceChangeAnim = animArray("stance_change");
			GoToCover( stanceChangeAnim, .4, getAnimLength( stanceChangeAnim ) );
		}

		assert( self.a.pose == desiredStance );
		self.haveGoneToCover = true;
	}
}

shouldChangeStanceForFun() // and for variety
{
	if ( !IsDefined( self.enemy ) )
		return false;

	if ( !IsDefined( self.changeStanceForFunTime ) )
		self.changeStanceForFunTime = GetTime() + RandomIntRange( 5000, 20000 );

	if ( GetTime() > self.changeStanceForFunTime )
	{
		self.changeStanceForFunTime = GetTime() + RandomIntRange( 5000, 20000 );

		if ( IsDefined( self.ramboChance ) && self.a.pose == "stand" )
			return false;

		// AI_TODO: see what prevAttack is for
		self.a.prevAttack = undefined;
		return true;
	}

	return false;
}

// AI_TODO - standardize and verify these yaw ranges
shootPosOutsideLegalYawRange()
{
	if ( !IsDefined( self.shootPos ) )
		return false;

	yaw = self.coverNode GetYawToOrigin( self.shootPos );

	if( self.a.cornerMode == "over" || self.a.cornerMode == "blind_over" )
		return yaw < self.leftAimLimit || self.rightAimLimit < yaw;
	
	if( !IsDefined( self.cornerDirection ) ) // must be crouch or stand node
		return yaw < self.leftAimLimit || self.rightAimLimit < yaw;
		
	if( self.a.atPillarNode )
		cornerLeftDirection = ( self.cornerDirection == "right" );
	else
		cornerLeftDirection = ( self.cornerDirection == "left" );
	
	if( cornerLeftDirection )
	{
		if( self.a.cornerMode == "B" )
		{
			return yaw < 0-self.ABangleCutoff || yaw > 14;
		}
		else if( self.a.cornerMode == "A" )
		{
			return yaw > 0-self.ABangleCutoff;
		}
		else if( self.a.cornerMode == "blindfire" )
		{
			return yaw < 0;
		}
		else
		{
			assert( self.a.cornerMode == "lean" );
			return yaw < anim.coverGlobals.CORNER_LEFT_LEAN_YAW_MAX || yaw > 8; 
		}		
	}
	else
	{
		assert( !cornerLeftDirection );
		
		if ( self.a.cornerMode == "B" )
		{
			return yaw > self.ABangleCutoff || yaw < -12;
		}
		else if ( self.a.cornerMode == "A" )
		{
			return yaw < self.ABangleCutoff;
		}
		else if( self.a.cornerMode == "blindfire" )
		{
			return yaw > 0;
		}
		else
		{
			assert( self.a.cornerMode == "lean" );
			return yaw > anim.coverGlobals.CORNER_RIGHT_LEAN_YAW_MAX || yaw < -8; 
		}
	}
}

// getCornerMode will return "none" if no corner modes are acceptable.
getCornerMode( node, point )
{
	noStepOut = false;
	yaw = 0;

	if ( IsDefined( point ) )
	{
		yaw = node GetYawToOrigin( point );
	}

	/# // forcecorner mode debugging
		forceCornerMode = shouldForceBehavior( "force_corner_mode" );
	if ( forceCornerMode == "lean" || forceCornerMode == "A" || forceCornerMode == "B" )
		return forceCornerMode;

	// handle over case
	if( forceCornerMode == "over" )
	{
		// don't want to get cover peekouts for crouch while standing
		stanceSupported = self.a.pose == "crouch" && !self.a.atPillarNode;
		if ( IsDefined( node ) && ( stanceSupported ) && ( yaw > self.leftAimLimit && self.rightAimLimit > yaw ) )
		{
			modes = node GetValidCoverPeekOuts();
			
			// if at a pillarnode that allows standing and AI is crouching then AI should not use "over" mode as 
			// it will clip its gun into the wall.
			//if( self.a.atPillarNode && self.a.pose == "crouch" && !ISNODEDONTSTAND(self.coverNode) )
			//	modes = array_exclude( modes, array("over") );
			
			if( IsInArray( modes, forceCornerMode ) )
				return forceCornerMode;
		}
	}
	#/

	modes = [];

	// don't want to get cover peekouts for crouch while standing
	stanceSupported = self.a.pose == "crouch";
	
	if ( IsDefined( node ) && ( stanceSupported ) && ( yaw > self.leftAimLimit && self.rightAimLimit > yaw ) )
		modes = node GetValidCoverPeekOuts();
	
	// over at pillar is only used for blindfires
	if( self.a.atPillarNode )
		modes = array_exclude( modes, array("over") );
	
	// cover pillar right is left on regular corners
	if( self.a.atPillarNode )
		cornerLeftDirection = ( self.cornerDirection == "right" );
	else
		cornerLeftDirection = self.cornerDirection == "left";
	

	if ( cornerLeftDirection ) // left
	{
		// lean
		if( canLean( yaw, anim.coverGlobals.CORNER_LEFT_LEAN_YAW_MAX, 0 ) )
		{
			noStepOut = shouldLean();
			modes[ modes.size ] = "lean";
		}

		// A/B
		if( !noStepOut && yaw < anim.coverGlobals.CORNER_LEFT_AB_YAW && !usingPistol() )
		{
			if ( yaw < 0 - self.ABangleCutoff )
				modes[ modes.size ] = "A";
			else
				modes[ modes.size ] = "B";
		}
	}
	else 					// right
	{
		assert( !cornerLeftDirection );

		// lean
		if ( canLean( yaw, 0, anim.coverGlobals.CORNER_RIGHT_LEAN_YAW_MAX ) )
		{
			noStepOut = shouldLean();
			modes[ modes.size ] = "lean";
		}

		// A/B
		if ( !noStepOut && yaw > anim.coverGlobals.CORNER_RIGHT_AB_YAW && !usingPistol() )
		{
			if ( yaw > self.ABangleCutoff )
				modes[ modes.size ] = "A";
			else
				modes[ modes.size ] = "B";
		}
	}
	
	// wounded AI should only "lean" as there is a pose match issue with A and B, they can still blind fire.
	if( self.isWounded )
	{
		modes = array_exclude( modes, array("over") );
		modes = array_exclude( modes, array("A") );
		modes = array_exclude( modes, array("B") );
	}
	
	return getRandomCoverMode( modes );
}

// getBestStepOutPos never returns "none".
// it returns the best stepoutpos that we can get to from our current one.
getBestStepOutPos()
{
	yaw = 0;

	// decide shoot angle
	if (canSuppressEnemy())
	{
		yaw = self.coverNode GetYawToOrigin( getEnemySightPos() );
	}
	else if ( self.doingAmbush && IsDefined( self.shootPos ) )
	{
		yaw = self.coverNode GetYawToOrigin( self.shootPos );
	}
	
	/#
		dvarval = GetDvar( "scr_cornerforcestance");
	if ( dvarval == "lean" || dvarval == "a" || dvarval == "b" )
	{
		return dvarval;
	}
	#/

		if ( self.a.cornerMode == "lean" )
	{
		return "lean";
	}
	else if ( self.a.cornerMode == "over" )
	{
		return "over";
	}
	else if ( self.a.cornerMode == "B" )
	{
		if(self.cornerDirection == "left")
		{
			if(yaw < 0-self.ABangleCutoff)
			{
				return "A";
			}
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw > self.ABangleCutoff)
			{
				return "A";
			}
		}
		return "B";
	}
	else if ( self.a.cornerMode == "A" )
	{
		positionToSwitchTo = "B";
		if(self.cornerDirection == "left")
		{
			if(yaw > 0-self.ABangleCutoff)
			{
				return "B";
			}
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw < self.ABangleCutoff)
			{
				return "B";
			}
		}

		return "A";
	}
}

changeStepOutPos()
{
	self endon ("killanimscript");

	positionToSwitchTo = getBestStepOutPos();
	
	if ( positionToSwitchTo == self.a.cornerMode )
		return false;
	
	// can't switch between lean/over and other stepoutposes
	// so if this assert fails then getBestStepOutPos gave us a bad return value
	assert( self.a.cornerMode != "lean" && positionToSwitchTo != "lean" );
	assert( self.a.cornerMode != "over" && positionToSwitchTo != "over" );
	
	self.changingCoverPos = true;
	self notify("done_changing_cover_pos");
	
	animname = self.a.cornerMode + "_to_" + positionToSwitchTo;
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );
	
	// make sure there's room for the animation
	midpoint = getPredictedPathMidpoint();

	if ( !self mayMoveToPoint( midpoint ) )
		return false;

	if ( !self MayMoveFromPointToPoint( midpoint, getAnimEndPos( switchanim ) ) )
		return false;
	
	self endStandIdleThread();
	
	// turn off aiming while we move.
	hasStopAim = animHasNotetrack( switchanim, "stop_aim" );
	
	if( !hasStopAim )
	{
		/#
		if( getDvarInt( "ai_debugStartAimNotetrack" ) == 1 )
			println("^2StopStartAim Debug - ", switchanim +  " in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"stop_aim\" notetrack");
		#/
				
		self StopAiming(.3);
		resetAnimSpecial(.3);	
	}
		
	// block pain while changing stepOut positions for allies only
	if( self.team == "allies" )
		self.blockingPain = true;
	
	prev_anim_pose = self.a.pose;
	
	self SetAnimLimited(animArray("straight_level"), 0, .2);
	
	self SetFlaggedAnimKnob( "changeStepOutPos", switchanim, 1, .2, 1 );
	self thread DoNoteTracksWithEndon( "changeStepOutPos" );
	
	if( hasStopAim )
	{
		self waittillmatch( "changeStepOutPos", "stop_aim" );
	
		self StopAiming(.1);
		resetAnimSpecial(.1);	
	}
		
	hasStartAim = animHasNotetrack( switchanim, "start_aim" );
	
	if ( hasStartAim )
	{
		self waittillmatch( "changeStepOutPos", "start_aim" );
	}
	else
	{
		/#
		if( getDvarInt( "ai_debugStartAimNotetrack" ) == 1 )
			println("^2StopStartAim Debug - ", switchanim +  " in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");
		#/
		
		self waittillmatch( "changeStepOutPos", "end" );
	}
	
	self StartAiming( undefined, false, 0.1 );
	
	if ( hasStartAim )
		self waittillmatch("changeStepOutPos","end");
	
	self ClearAnim(switchanim, .1);
	self.a.cornerMode = positionToSwitchTo;
		
	setStepOutAnimSpecial( positionToSwitchTo );
	
	// start reacting to pain again
	if( self.team == "allies" )
		self.blockingPain = false;
		
	self.changingCoverPos = false;
	self.coverPosEstablishedTime = GetTime();

	assert( self.a.pose == "stand" || self.a.pose == "crouch" );

	self ChangeAiming( undefined, true, .3 );
	
	return true;
}

canLean( yaw, yawMin, yawMax )
{
	if ( self.a.neverLean )
		return false;

	return ( yawMin <= yaw && yaw <= yawMax );
}

shouldLean()
{
	// AI_TODO: add support for pistol step out anims?
	if ( self usingPistol() )
		return true;
	
	// allies/spetz
	if( IS_TRUE( self.a.favor_lean ) )
		return true;
	
	// if player is aiming at stepout pos, don't go exposed
	if ( IS_FALSE(self.coverSafeToPopOut) )
		return true;

	if ( self isPartiallySuppressedWrapper() )
		return true;

	return false;
}

DoNoteTracksWithEndon( animname )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );
}

StartAiming( spot, fullbody, transtime )
{
	assert( !self.cornerAiming );
	self.cornerAiming = true;
	
	self SetAimingParams( spot, fullbody, transTime, true );
}

ChangeAiming( spot, fullbody, transtime )
{
	assert( self.cornerAiming );

	self SetAimingParams( spot, fullbody, transTime, false );
}

StopAiming( transtime )
{
	assert( self.cornerAiming );
	self.cornerAiming = false;
	
	// turn off shooting
	self ClearAnim( %add_fire, transtime );
	// and turn off aiming
	animscripts\shared::setAnimAimWeight( 0, transtime );
}

SetAimingParams( spot, fullbody, transTime, start )
{
	assert( IsDefined(fullbody) );
	
	self.spot = spot; // undefined is ok
	
	self SetAnimLimited( %exposed_modern, 1, transTime );
	self SetAnimLimited( %exposed_aiming, 1, transTime );

	// use 0 transtime because the aiming is blended in internally already
	animscripts\shared::setAnimAimWeight( 1, 0 );

	// AI_TODO: necessary?
	//self thread aimIdleThread();

	aimAnimPrefix = "";

	if ( self.a.cornerMode == "over" || self.a.cornerMode == "lean" )
	{
		if( !start )
		{
			self SetAnimLimited( animArray(self.a.cornerMode + "_aim_straight"), 1, transTime);
		}
		
		aimAnimPrefix = self.a.cornerMode;
	}
	else if ( fullbody )
	{
		self SetAnimLimited( animArray("straight_level"), 1, transTime);
		
		aimAnimPrefix = "add";
	}
	else
	{
		self SetAnimLimited( animArray("straight_level"), 0, transTime);

		aimAnimPrefix = "add_turn";
	}

	playAdditiveAimingAnims( aimAnimPrefix, transTime, 45 );
}

stepOutAndHideSpeed()
{
	if ( self.a.cornerMode == "over" )
		return 1;

	return randomFasterAnimSpeed();
}

stepOut() 
{
	/#self animscripts\debug::debugPushState( "stepOut" );#/

	self.a.cornerMode = "alert";
	
	self AnimMode( "zonly_physics" );
	
	if ( self.a.pose == "stand" )
	{
		self.ABangleCutoff = 38;
	}
	else
	{
		assert( self.a.pose == "crouch" );
		self.ABangleCutoff = 31;
	}
	
	thisNodePose = self.a.pose;
	
	newCornerMode = "none";
	if ( hasEnemySightPos() )
	{
		newCornerMode = getCornerMode( self.coverNode, getEnemySightPos() );
	}
	else
	{
		newCornerMode = getCornerMode( self.coverNode );
	}
	
	if ( !IsDefined(newCornerMode) )
	{
		/#self animscripts\debug::debugPopState( "stepOut", "newCornerMode is undefined" );#/
		return false;
	}
	
	if ( newCornerMode == "lean" && !self isPeekOutPosClear() )
	{
		/#self animscripts\debug::debugPopState( "stepOut", "no room to lean out" );#/
		return false;
	}

	self animscripts\anims::clearAnimCache();
	
	animname = "alert_to_" + newCornerMode;
	assert( animArrayAnyExist( animname ), "Animation " + animname + " not found" );
	switchanim = animArrayPickRandom( animname );

	if ( newCornerMode != "over" && !isPathClear( switchanim, newCornerMode != "lean" ) )
	{
		/#self animscripts\debug::debugPopState( "stepOut", "no room to step out" );#/
		return false;
	}	

	resetAnimSpecial();
	
	self.a.cornerMode = newCornerMode;
	self.a.prevAttack = newCornerMode;

	// AI_TODO: add aim_limit notetracks to the anims so we can get rid of this
	self set_aiming_limits();
	if ( self.a.cornerMode == "lean" )
	{
		if ( self.cornerDirection == "left" )
			self.rightaimlimit = 0;
		else
			self.leftaimlimit = 0;
	}
	
	self.keepClaimedNode = true;
	self.pushable = false;

	self.changingCoverPos = true;
	self notify("done_changing_cover_pos");

	if( self.team == "allies" )
		self.blockingPain = true;
	
	animRate = stepOutAndHideSpeed();
	
	self setFlaggedAnimKnobAllRestart( "stepout", switchanim, %root, 1, .2, animRate );
	self thread DoNoteTracksWithEndon( "stepout" );

	hasStartAim = animHasNotetrack( switchanim, "start_aim" );
	if ( hasStartAim )
	{
		self waittillmatch("stepout","start_aim");
	}
	else
	{
	/#
		if( getDvarInt( "ai_debugStartAimNotetrack" ) == 1 )
			println("^2StopStartAim Debug - ", switchanim +  " in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");
	#/	
		self waittillmatch( "stepout", "end" );
	}

	fullbody = ( newCornerMode == "over" );

	setStepOutAnimSpecial( newCornerMode );
	
	self StartAiming( undefined, fullbody, 0.1 );
	self thread animscripts\shared::trackShootEntOrPos();
			
	if ( hasStartAim )
		self waittillmatch("stepout","end");
	
	if( self.team == "allies" )
		self.blockingPain = false;
		
	self ChangeAiming( undefined, true, 0.2 );
	self ClearAnim( %cover, 0.2 );
	self ClearAnim( %corner, 0.2 );
	
	self.changingCoverPos = false;
	self.coverPosEstablishedTime = GetTime();
	self.pushable = true;

	/#self animscripts\debug::debugPopState( "stepOut" );#/
		
	return true;
}



stepOutAndShootEnemy()
{
	/#self animscripts\debug::debugPushState( "stepOutAndShootEnemy" );#/

	self.keepClaimedNode = true;

	if ( !StepOut() ) // may not be room to step out
	{
		/#self animscripts\debug::debugPopState( undefined, "no room to step out" );#/
		
		self.keepClaimedNode		= false;
		return false;
	}

	shootAsTold();

	// check for RPG weapon throwdown
	if ( IsDefined( self.shootPos ) )
	{
		if( animscripts\shared::shouldThrowDownWeapon() )
		{
			animscripts\shared::throwDownWeapon();

			resetWeaponAnims();

			self ChangeAiming( undefined, true, 0.2 );

			self animMode( "zonly_physics" );

			shootAsTold();
		}
	}
	
	returnToCover();
	self.keepClaimedNode = false;

	/#self animscripts\debug::debugPopState( "stepOutAndShootEnemy" );#/
		
	return true;
}

rambo()
{
	/#self animscripts\debug::debugPushState( "rambo" );#/

	if ( !hasEnemySightPos() )
	return false;

	shouldRambo = IsDefined( self.coverNode.script_forcerambo ) || ( IsDefined( self.ramboChance ) && RandomFloat(1) < self.ramboChance );
	
	if( shouldRambo && canRambo() )
	{
		if( ramboStepOut() )
		{
			/#self animscripts\debug::debugPopState( "rambo" );#/
				return true;
		}
	}
	
	/#self animscripts\debug::debugPopState( "rambo", "not allowed or can't step out" );#/
		return false;
}

ramboStepOut()
{
	animType = "rambo";

	// we dont want to see rambo jam as often
	if( RandomFloat(1) < 0.2 && animArrayAnyExist("rambo_jam") )
		animType = "rambo_jam";
	
	// Use different animation based on the angle to enemy
	if ( animType != "rambo_jam" )
	{
		yawToEnemy = self.coverNode GetYawToOrigin( getEnemySightPos() );

		if( self.cornerDirection == "left" && yawToEnemy < 0 )
			yawToEnemy = yawToEnemy * -1;
		
		if( yawToEnemy > anim.ramboSwitchAngle && animArrayAnyExist("rambo_45") )
			animType = "rambo_45";
	}

	assert( animArrayAnyExist( animType ) );

	ramboanim = animArrayPickRandom( animType );
	if( !isRamboPathClear( ramboanim ) )
		return false;

	resetAnimSpecial();
	
	self AnimMode ( "zonly_physics" );
	self.keepClaimedNode = true;
	self.keepClaimedNodeIfValid = true;
	self.isRamboing = true;

	self setFlaggedAnimKnobAllRestart("rambo", ramboanim, %body, 1, 0);

	// aiming
	if( canUseBlindAiming( "rambo" ) && animType != "rambo_jam" )
	{
		self thread startBlindAiming( ramboanim, "rambo" );
		self thread stopBlindAiming( ramboanim, "rambo" );
	}
	
	// set target
	if( IsDefined(self.enemy) )
		self animscripts\shoot_behavior::setShootEnt( self.enemy );

	self animscripts\shared::DoNoteTracks("rambo");

	self.keepClaimedNode = false;
	self.keepClaimedNodeIfValid = false;
	self.isRamboing = false;
	self.a.prevAttack = "rambo";
	waittillframeend;
	
	return true;
}

isRamboPathClear( theanim )
{
	ramboOutNotetrackCheck = AnimHasNotetrack( theanim, "rambo_out" );

	Assert( ramboOutNotetrackCheck ); // Every rambo animation needs to have this notetrack for stepout position
	
	stepOutTimeArray = GetNotetrackTimes( theanim, "rambo_out" );

	Assert( stepOutTimeArray.size == 1 ); // There should be only one notetrack for stepout in the whole animation

	movedelta	 = GetMoveDelta( theanim, 0, stepOutTimeArray[0] );
	ramboOutPos  = self LocalToWorldCoords( movedelta );
	distToPos	 = Distance2D( self.origin, ramboOutPos );

	angles = self.coverNode.angles;
	right = AnglesToRight(angles);
	
	switch ( self.a.script )
	{
		case "cover_left":
			ramboOutPos = self.origin + VectorScale( right, distToPos * -1 );
			break;

		case "cover_right":
			ramboOutPos = self.origin + VectorScale( right, distToPos );
			break;
			
		default:
			Assert("Rambo behavior is not supported on cover node " + self.a.script );
	}
	
/#
		if( ramboOutNotetrackCheck )
		self thread debugRamboOutPosition( ramboOutPos );
#/

		return self mayMoveToPoint( ramboOutPos );
}

/#
debugRamboOutPosition( ramboOutPos ) // self = ai
{
	if( GetDvar( "ai_rambo") != "1" )
		return;

	self endon("death");

	for ( i = 0;i< 30*20 ;i++ )
	{
		RecordLine( self.origin, ramboOutPos, ( 1,1,1 ), "Animscript", self );
	}
}
#/
	
shootAsTold()
{
	self endon("need_to_switch_weapons");

	self maps\_gameskill::didSomethingOtherThanShooting();

	while(1)
	{
		/#self animscripts\debug::debugPushState( "shootAsTold" );#/

		while(1)
		{
			if ( self.shouldReturnToCover )
			{
				/#self animscripts\debug::debugPopState( "shootAsTold", "shouldReturnToCover" );#/
					break;
			}

			if( animscripts\cover_behavior::shouldSwitchSides(false) )
			{
				/#self animscripts\debug::debugPopState( "shootAsTold", "shouldSwitchSides" );#/
					break;
			}

			if ( !IsDefined( self.shootPos ) )
			{
				assert( !IsDefined( self.shootEnt ) );

				// give shoot_behavior a chance to iterate
				self waittill( "do_slow_things" );
				waittillframeend;

				if ( IsDefined( self.shootPos ) )
					continue;

				/#self animscripts\debug::debugPopState( "shootAsTold", "no shootPos" );#/
					break;
			}

			if ( !self.bulletsInClip )
			{
				/#self animscripts\debug::debugPopState( "shootAsTold", "no ammo" );#/
					break;
			}
			
			if ( shootPosOutsideLegalYawRange() )
			{
				if ( !changeStepOutPos() )
				{
					// if we failed because there's no better step out pos, give up
					if ( getBestStepOutPos() == self.a.cornerMode )
					{
						/#self animscripts\debug::debugPopState( "shootAsTold", "shootPos outside yaw range and no better step out pos" );#/
							break;
					}
					
					// couldn't change position, shoot for a short bit and we'll try again
					shootUntilShootBehaviorChangeForTime( .2 );

					// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
					self flamethrower_stop_shoot();
					continue;
				}
				
				// if they're moving back and forth too fast for us to respond intelligently to them,
				// give up on firing at them for the moment
				if ( shootPosOutsideLegalYawRange() )
				{
					/#self animscripts\debug::debugPopState( "shootAsTold", "shootPos outside yaw range" );	#/
						break;
				}
				
				continue;
			}
			
			shootUntilShootBehaviorChange_corner( true );

			// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
			self flamethrower_stop_shoot();

			self ClearAnim( %add_fire, .2 );
		}

		// No need to do midpoint check for over and lean both.
		doMidPointCheck = ( self.a.cornerMode != "lean" && self.a.cornerMode != "over" );
		if ( self canReturnToCover( doMidPointCheck ) )
			break;
		
		// couldn't return to cover. keep shooting and try again

		// (change step out pos if necessary and possible)
		if ( shootPosOutsideLegalYawRange() && changeStepOutPos() )
			continue;
		
		shootUntilShootBehaviorChangeForTime( .2 );

		// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
		self flamethrower_stop_shoot();
	}
}

shootUntilShootBehaviorChangeForTime( time )
{
	self thread notifyStopShootingAfterTime( time );
	
	starttime = GetTime();
	
	shootUntilShootBehaviorChange_corner( false );
	self notify("stopNotifyStopShootingAfterTime");

	timepassed = (GetTime() - starttime) / 1000;
	if ( timepassed < time )
	{
		wait time - timepassed;
	}
}

notifyStopShootingAfterTime( time )
{
	self endon("killanimscript");
	self endon("stopNotifyStopShootingAfterTime");
	
	wait time;
	
	self notify("stopShooting");
}

shootUntilShootBehaviorChange_corner( runAngleRangeThread )
{
	self endon("return_to_cover");
	
	if ( runAngleRangeThread )
	{
		self thread angleRangeThread(); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	}

	self thread standIdleThread();
	
	shootUntilShootBehaviorChange();
}

// AI_TODO: need to refactor this similar to IW so it's common to most animscripts
standIdleThread()
{
	self endon("killanimscript");
	
	if ( IsDefined( self.a.standIdleThread ) )
	{
		return;
	}

	self.a.standIdleThread = true;
	
	self SetAnim( %add_idle, 1, .2 );
	standIdleThreadInternal();
	self ClearAnim( %add_idle, .2 );
}

endStandIdleThread()
{
	self.a.standIdleThread = undefined;
	self notify("end_stand_idle_thread");
}

standIdleThreadInternal()
{
	self endon("killanimscript");
	self endon("end_stand_idle_thread");
	
	animArrayArg = "exposed_idle";
	if( self.a.cornerMode == "lean" )
		animArrayArg = "lean_idle";
	else if ( self.a.cornerMode == "over" && animArrayAnyExist( "over_idle" ) )
		animArrayArg = "over_idle";
	
	assert( animArrayAnyExist( animArrayArg ) );
	for( i = 0; ; i++ )
	{
		flagname = "idle" + i;
		idleanim = animArrayPickRandom( animArrayArg );
		
		self SetFlaggedAnimKnobLimitedRestart( flagname, idleanim, 1, 0.2 );
		
		self waittillmatch( flagname, "end" );
	}
}

angleRangeThread()
{
	self endon ("killanimscript");
	self notify ("newAngleRangeCheck");
	self endon ("newAngleRangeCheck");
	self endon ("take_cover_at_corner");
	
	while (1)
	{
		if ( shootPosOutsideLegalYawRange() )
		{
			break;
		}

		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}

canReturnToCover( doMidpointCheck )
{
	if ( doMidpointCheck )
	{
		midpoint = getPredictedPathMidpoint();

		if ( !self mayMoveToPoint( midpoint ) )
		{
			return false;
		}

		return self MayMoveFromPointToPoint( midpoint, self.coverNode.origin );
	}
	else
	{
		return self mayMoveToPoint( self.coverNode.origin );
	}
}

returnToCover()
{
	/#self animscripts\debug::debugPushState( "returnToCover" );#/

	assert( self canReturnToCover( ( self.a.cornerMode != "lean" && self.a.cornerMode != "over" ) ) );
	
	self endStandIdleThread();
	
	// Go back into hiding.
	suppressed = issuppressedWrapper();
	self notify ("take_cover_at_corner"); // Stop doing the adjust-stance transition thread
	
	self.changingCoverPos = true;
	self notify("done_changing_cover_pos");

	if( self.a.cornerMode != "lean" )
		self thread resetAnimSpecial( 0.2 );
		
	animname = self.a.cornerMode + "_to_alert";
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );

	self StopAiming( .3 );
	self ClearAnim( %add_fire, .2 );
	
	reloading = false;
	if ( self.a.cornerMode != "lean" && self.subclass == "regular" && animArrayAnyExist( animname + "_reload" ) && RandomFloat(100) < 75 )
	{
		switchanim = animArrayPickRandom( animname + "_reload" );
		reloading = true;
	}

	// turn off the standing anim
	// use 0 goaltime to make sure none of the translation from the transition anim is lost
	if( self.a.cornerMode == "lean" || self.a.cornerMode == "over" )
	{
		self ClearAnim( animArray(self.a.cornerMode + "_aim_straight"), 0);
	}
	else
	{
		self ClearAnim(animArray("straight_level"), 0);
	}

	if( self.team == "allies" )
		self.blockingPain = true;
		
	rate = stepOutAndHideSpeed();
	
	// AI_TODO - cover left has a special lean pains. and we should reset the self.a.specialPain before starting the transtion into the cover back.
		
	// as we turn on the hiding anim
	self setFlaggedAnimRestart("hide", switchanim, 1, .1, rate);
	self animscripts\shared::DoNoteTracks("hide");
		
	if ( reloading )
		self animscripts\weaponList::RefillClip();
		
	self notify ( "stop updating angles" );
	self animscripts\shared::stopTracking();
	
	self.changingCoverPos = false;
	
	setAnimSpecial();
	self.keepClaimedNode = false;
	
	self ClearAnim( %exposed_modern, 0.2 );
	
	if( self.team == "allies" )
		self.blockingPain = false;
	
	/#self animscripts\debug::debugPopState( "returnToCover" );#/
}

tryThrowingGrenadeStayHidden( throwAt )
{
	return tryThrowingGrenade( throwAt, true );
}

tryThrowingGrenade( throwAt, safe )
{
	if ( !self mayMoveToPoint( self getPredictedPathMidpoint() ) )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "no room to throw" );
		#/

			return false;
	}

	theanim = undefined;

	if( animArrayExist("grenade_rambo") && Isdefined( self.ramboChance ) && randomFloat(1) < self.ramboChance )
	{
		theAnim = animArray("grenade_rambo");
	}
	else
	{
		if ( IsDefined(safe) && safe )
		{
			if ( !animArrayExist("grenade_safe") )
			{
				/#self animscripts\debug::debugPopState( undefined, "no safe throw anim" );#/
					return false;
			}

			theanim = animArray("grenade_safe");
		}
		else
		{
			if ( !animArrayExist("grenade_exposed") )
			{
				/#self animscripts\debug::debugPopState( undefined, "no exposed throw anim" );#/
					return false;
			}

			theanim = animArray("grenade_exposed");
		}

	}
	
	self AnimMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeIfValid = true;
	
	threwGrenade = TryGrenade( throwAt, theanim );
	
	self.keepClaimedNodeIfValid = false;
	return threwGrenade;
}

/#
printYawToEnemy()
{
	println("yaw: ",self getYawToEnemy());
}
#/
	
lookForEnemy( lookTime )
{
	if ( !animArrayExist("alert_to_look") )
	{
		/#self animscripts\debug::debugPopState( undefined, "no look anim" );#/
		return false;
	}

	// no anim support for now
	if( usingPistol() )
	{
		/#self animscripts\debug::debugPopState( undefined, "no pistol anims" );#/
		return false;
	}
	
	self AnimMode( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeIfValid = true;
	
	// look out from alert
	if ( !peekOut() )
	{
		return false;
	}

	animscripts\shared::playLookAnimation( animArray("look_idle"), lookTime, ::canStopPeeking );

	lookanim = undefined;
	if ( self isSuppressedWrapper() )
		lookanim = animArray("look_to_alert_fast");
	else
		lookanim = animArray("look_to_alert");
		
	self setflaggedanimknoballrestart("looking_end", lookanim, %body, 1, .1, 1.0);
	animscripts\shared::DoNoteTracks("looking_end");
	
	self AnimMode( "zonly_physics" ); // Unlatch the feet
	
	self.keepClaimedNodeIfValid = false;
	
	return true;
}

isPeekOutPosClear()
{
	assert( IsDefined( self.coverNode ) );

	eyePos = self GetEye();
	rightDir = AnglesToRight( self.coverNode.angles );

	// cover pillar right is left on regular corners
	if( self.a.atPillarNode )
		cornerLeftDirection = ( self.cornerDirection == "right" );
	else
		cornerLeftDirection = self.cornerDirection == "left";

	if ( cornerLeftDirection )
		eyePos = eyePos - (rightDir * anim.coverGlobals.PEEKOUT_OFFSET);
	else
		eyePos = eyePos + (rightDir * anim.coverGlobals.PEEKOUT_OFFSET);
	

	lookAtPos = eyePos + AnglesToForward( self.coverNode.angles ) * anim.coverGlobals.PEEKOUT_OFFSET;

	/*thread debugLine( eyePos, lookAtPos, ( 1, 0, 0 ), 1.5 );*/

	return SightTracePassed( eyePos, lookAtPos, true, self );
}

peekOut()
{
	if ( IsDefined( self.coverNode.script_dontpeek ) )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "cover node has script_dontpeek on" );
		#/

			return false;
	}

	if ( IsDefined( self.a.dontpeek ) )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "self.a.dontpeek on" );
		#/

			return false;
	}

	if ( IsDefined( self.nextPeekOutAttemptTime ) && GetTime() < self.nextPeekOutAttemptTime )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "nextPeekOutAttemptTime > GetTime()" );
		#/

			return false;
	}

	peekanim = animArray("alert_to_look");

	if ( !self mayMoveToPoint( getAnimEndPos( peekanim ) ) || self.looking_at_entity)
	{
		/#
			self animscripts\debug::debugPopState( undefined, "no room to step out or looking at ent" );
		#/

			self.nextPeekOutAttemptTime = GetTime() + 3000;
		return false;
	}
	
	self SetFlaggedAnimKnobAll("looking_start", peekanim, %body, 1, .2, 1);
	animscripts\shared::DoNoteTracks("looking_start");
	
	return true;
}

canStopPeeking()
{
	return self mayMoveToPoint( self.coverNode.origin );
}

fastlook()
{
	if ( !animArrayAnyExist("look") )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "no fastlook anim" );
		#/

			return false;
	}

	peekanim = animArrayPickRandom("look");

	if ( !self mayMoveToPoint( getAnimEndPos( peekanim ) ) || self.looking_at_entity)
	{
		/#
			self animscripts\debug::debugPopState( undefined, "no room to fastlook out" );
		#/

			return false;
	}
	
	self setFlaggedAnimKnobAllRestart( "look", peekanim, %body, 1, .1 );
	self animscripts\shared::DoNoteTracks( "look" );
	
	return true;
}

cornerReload()
{
	// MikeD (10/9/2007): Flamethrower AI do not reload
	if( weaponIsGasWeapon( self.weapon ) )
	{
		return flamethrower_reload();
	}

	assert( animArrayAnyExist( "reload" ) );

	reloadanim = animArrayPickRandom( "reload" );
	self SetFlaggedAnimKnobRestart( "cornerReload", reloadanim, 1, .2 );

	self animscripts\shared::DoNoteTracks( "cornerReload" );

	self animscripts\weaponList::RefillClip();

	self SetAnimRestart( animArray( "alert_idle" ), 1, .2 );
	self ClearAnim( reloadanim, .2 );

	return true;
}

isPathClear( stepoutanim, doMidpointCheck )
{
	if ( doMidpointCheck )
	{
		midpoint = getPredictedPathMidpoint();

		/#
			// set to true to get animation deltas in case they change
			if( false )
		{
			recordLine( self.origin, midpoint, (0,1,0), "Animscript", self );
			recordLine( midpoint, getAnimEndPos( stepoutanim ), (1,0,0), "Animscript", self );

			endPos = getAnimEndPos( stepoutanim );
			moveDelta = endPos - self.origin;
			recordenttext( "Delta: " + moveDelta[0] + ", " + moveDelta[1] + ", " + moveDelta[2], self, (0,1,0), "Animscript" );
		}
		#/

			if ( !self maymovetopoint( midpoint ) )
		{
			return false;
		}

		return self MayMoveFromPointToPoint( midpoint, getAnimEndPos( stepoutanim ) );
	}
	else
	{
		return self maymovetopoint( getAnimEndPos( stepoutanim ) );
	}
}

getPredictedPathMidpoint()
{

	// SUMEET/ALEX P, devtrack bug 478 - AI should only be in this animscript if it is as cover_left or cover_right
	assert( IsDefined( self.coverNode ), "Covernode undefined, AI's current animscript is " + self.a.script );

	angles = self.coverNode.angles;
	right = AnglesToRight(angles);
	switch ( self.a.script )
	{
		case "cover_left":
			right = VectorScale(right, -36);
			break;

		case "cover_right":
			right = VectorScale(right, 36);
			break;

		case "cover_pillar":
			if( self.cornerDirection == "left" )
			{
				right = VectorScale(right, -36);
			}
			else
			{
				right = VectorScale(right, 36);
			}
			break;
			
		default:
			assert(0, "What kind of node is this????");
	}
	
	return self.coverNode.origin + (right[0], right[1], 0);
}

idle()
{
	self endon("end_idle");

	while( 1 )
	{
		useTwitch = (RandomInt(2) == 0 && animArrayAnyExist("alert_idle_twitch"));
		if ( useTwitch && !self.looking_at_entity )
		{
			idleanim = animArrayPickRandom("alert_idle_twitch");
		}
		else
		{
			idleanim = animArray("alert_idle");
		}

		playIdleAnimation( idleAnim, useTwitch );
	}
}

flinch()
{
	if ( !animArrayAnyExist("alert_idle_flinch") )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "no flinch anim" );
		#/

			return false;
	}

	playIdleAnimation( animArrayPickRandom("alert_idle_flinch"), true );
	
	return true;
}

playIdleAnimation( idleAnim, needsRestart )
{
	if ( needsRestart )
		self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .2, 1);
	else
		self SetFlaggedAnimKnobAll( "idle", idleAnim, %body, 1, .2, 1);
	
	self animscripts\shared::DoNoteTracks( "idle" );
}

transitionToStance( stance )
{
	if (self.a.pose == stance)
	{
		return;
	}

//	self ExitProneWrapper(0.5);
	self setFlaggedAnimKnobAllRestart( "changeStance", animArray("stance_change"), %body);

	self animscripts\shared::DoNoteTracks( "changeStance" );
	assert( self.a.pose == stance );
	wait (0.2);
}

GoToCover( coveranim, transTime, playTime )
{
	cornerAngle = GetNodeDirection();
	cornerOrigin = GetNodeOrigin();
	
	desiredYaw = cornerAngle + self.hideyawoffset;

	self OrientMode( "face angle", AngleClamp180( desiredYaw ) );

	self AnimMode ( "normal" );
	
	assert( transTime <= playTime );

	setAnimSpecial();
	
	self thread animscripts\shared::moveToOriginOverTime( cornerOrigin, transTime );
	self setFlaggedAnimKnobAllRestart( "coveranim", coveranim, %body, 1, transTime );
	self animscripts\shared::DoNoteTracksForTime( playTime, "coveranim" );
	
	while ( AbsAngleClamp180( self.angles[1] - desiredYaw ) > 1 )
	{
		self animscripts\shared::DoNoteTracksForTime( 0.1, "coveranim" );
	}
	
	self AnimMode( "zonly_physics" );

	setAnimSpecial();
}

/#
drawoffset()
{
	self endon("killanimscript");

	for(;;)
	{
		line(self.node.origin + (0,0,20),(0,0,20) + self.node.origin + VectorScale(AnglesToRight(self.node.angles + (0,0,0)),16));
		wait(0.05);
	}
}
#/
	
set_aiming_limits()
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
}

runCombat()
{
	self notify( "killanimscript" );
	waittillframeend;
	self thread animscripts\combat::main();
}

resetWeaponAnims()
{
	assert( self.a.pose == "stand" || self.a.pose == "crouch" );

	self ClearAnim( %aim_4, 0 );
	self ClearAnim( %aim_6, 0 );
	self ClearAnim( %aim_2, 0 );
	self ClearAnim( %aim_8, 0 );
	self ClearAnim( %exposed_aiming, 0 );
}

setCornerDirection(direction)
{
	self.cornerDirection = direction;

	// to make it easier on the anim system
	if( self.a.script == "cover_pillar" )
	{
		self.a.script_suffix = "_" + direction;
	}
}

switchSides()
{
	if( !self.a.atPillarNode )
		return false;
	
	if( self.cornerDirection == "left" && !ISNODEDONTRIGHT(self.coverNode) )
		setCornerDirection("right");
	else if( !ISNODEDONTLEFT(self.coverNode) )
		setCornerDirection("left");
	
	/#
		forceCornerMode = shouldForceBehavior( "force_corner_direction" );

		if( forceCornerMode == "left" || forceCornerMode == "right" )
			setCornerDirection( forceCornerMode );
	#/

	self ClearAnim( %exposed_aiming, 0.2 );
	self animscripts\anims::clearAnimCache();

	self notify("dont_end_idle");

	// behavior callbacks need to have a wait
	wait(0.05);

	return true;
}

setStepOutAnimSpecial( newCornerMode )
{
	// AI_TODO - This whole function is messy and needs consolidation of the logic.
	if( self.a.script == "cover_pillar" )
	{
		if( IsDefined( self.a.cornerMode ) && self.a.cornerMode == "lean" )
			self.a.special = "cover_pillar_lean";
		
		if ( newCornerMode == "A" || newCornerMode == "B" )
			self.a.special = "cover_pillar_" + self.cornerDirection + "_" + newCornerMode;
	}
	else
	{
		// lean and over are supported for pistol 
		if( AIHasOnlyPistol() && newCornerMode != "lean" && newCornerMode != "over" )
		{
			setAnimSpecial();
		}
		else
		{
			if( newCornerMode == "lean" ) 
			{				
				if( self.a.atPillarNode && AIHasOnlyPistol() ) // leans pains are available for pistol AI now, but we still have to treat pillar differently
				{
					if( self.cornerDirection == "left" )
						self.a.special = "cover_right_" + newCornerMode;	
					else
						self.a.special = "cover_left_" + newCornerMode;				
				}
				else
				{
					self.a.special = "cover_" + self.cornerDirection + "_" + newCornerMode;	
				}
			}
			else if( !AIHasOnlyPistol() && ( newCornerMode == "A" || newCornerMode == "B" || newCornerMode == "blindfire" ) )
			{
				self.a.special = "cover_" + self.cornerDirection + "_" + newCornerMode;				
			}
			else if( newCornerMode == "over" ) // over special pains are available for both rifle and pistol
			{
				self.a.special = "cover_" + self.cornerDirection + "_" + newCornerMode;				
			}
			else			
			{
				self.a.special = "none";
			}
		}
	}
}

setAnimSpecial()
{
	if( self.a.atPillarNode && self.a.script == "cover_pillar" )
	{
		self.a.special = "cover_pillar";
	}
	else
	{	
		// HACK AI_TODO - Pistol AI at pillar has to be handled better. 
		if( self.a.atPillarNode && AIHasOnlyPistol() )
		{
			if( self.cornerDirection == "left" )
				self.a.special = "cover_right";
			else
				self.a.special = "cover_left";				
		}
		else
		{
			if( self.cornerDirection == "left" )
				self.a.special = "cover_left";
			else
				self.a.special = "cover_right";	
		}
	}
}
