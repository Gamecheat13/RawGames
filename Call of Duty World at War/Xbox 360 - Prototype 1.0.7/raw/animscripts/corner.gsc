#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#include common_scripts\Utility;

#using_animtree ("generic_human");

corner_think( direction )
{
	self endon ("killanimscript");
	
	self.animArrayFuncs["exposed"]["stand"] = animscripts\corner::set_standing_animarray_aiming;
	self.animArrayFuncs["exposed"]["crouch"] = animscripts\corner::set_crouching_animarray_aiming;
	
	firedSuppressionClip = false; 
	gotBoredAmbushing = false;
	self.coverNode = self.node;
	self.cornerDirection = direction;

	if ( self.a.pose == "crouch" )
	{
		set_anim_array( "crouch" );
	}
	else if ( self.a.pose == "stand" )
	{
		set_anim_array( "stand" );
	}
	else
	{
		assert( self.a.pose == "prone" );
		self ExitProneWrapper(1);
		self.a.pose = "crouch";
		self set_anim_array( "crouch" );
	}

	self.isshooting = false;
	self.tracking = false;
	
	self.cornerAiming = false;

	self setanim(%exposed_modern,1);

	
	self set_aiming_limits();
	
	lastgrenadetime = gettime() - randomint(20000);

	animscripts\shared::setAnimAimWeight( 0 );
	
	self.haveGoneToCover = false;
	
	behaviorCallbacks = spawnstruct();
	behaviorCallbacks.mainLoopStart			= ::mainLoopStart;
	behaviorCallbacks.reload				= ::cornerReload;
	behaviorCallbacks.leaveCoverAndShoot	= ::stepOutAndShootEnemy;
	behaviorCallbacks.look					= ::lookForEnemy;
	behaviorCallbacks.fastlook				= ::fastlook;
	behaviorCallbacks.idle					= ::idle;
	behaviorCallbacks.grenade				= ::tryThrowingGrenade;
	behaviorCallbacks.grenadehidden			= ::tryThrowingGrenadeStayHidden;
	behaviorCallbacks.blindfire				= ::blindfire;
	
	animscripts\cover_behavior::main( behaviorCallbacks );
}

mainLoopStart()
{
	desiredStance = "stand";
	if ( !self.coverNode doesNodeAllowStance("stand") && self.coverNode doesNodeAllowStance("crouch") )
		desiredStance = "crouch";
	
	/#
	if ( getdvarint("scr_cornerforcecrouch") == 1 )
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
			stanceChangeAnim = animarray("stance_change");
			GoToCover( stanceChangeAnim, .4, getAnimLength( stanceChangeAnim ) );
			set_anim_array( desiredStance ); // (sets anim_pose to stance)
		}
		assert( self.a.pose == desiredStance );
		self.haveGoneToCover = true;
	}
}

printYaws()
{
	wait(2);
	for(;;)
	{
		println("coveryaw = ",self.coverNode GetYawToOrigin(getEnemyEyePos()));
		printYawToEnemy();
		wait(0.05);
	}
}

// used within canSeeEnemyFromExposed() (in utility.gsc)
canSeePointFromExposedAtCorner( point, node )
{
	yaw = node GetYawToOrigin( point );
	if ( (yaw > 60) || (yaw < -60) )
		return false;
	
	if ( (node.type == "Cover Left" || node.type == "Cover Left Wide") && yaw > 14 )
		return false;
	if ( (node.type == "Cover Right" || node.type == "Cover Right Wide") && yaw < -12 )
		return false;
	
	return true;
}

shootPosOutsideLegalYawRange()
{
	if ( !isdefined( self.shootPos ) )
		return false;
	
	yaw = self.coverNode GetYawToOrigin( self.shootPos );
	
	if(self.cornerDirection == "left")
	{
		if(self.a.cornerMode == "B" && (yaw < 0-self.ABangleCutoff || yaw > 14))
		{
			return true;
		}
		else if(self.a.cornerMode == "A" && (yaw > 0-self.ABangleCutoff))
		{
			return true;
		}
	}
	else if(self.cornerDirection == "right")
	{
		if(self.a.cornerMode == "B" && (yaw > self.ABangleCutoff || yaw < -12))
		{
			return true;
		}
		else if(self.a.cornerMode == "A" && (yaw < self.ABangleCutoff))
		{
			return true;
		}
	}
	return false; 
}

getBestStepOutPos()
{
	yaw = 0;
	if (canSuppressEnemy())
		yaw = self.coverNode GetYawToOrigin( getEnemySightPos() );
	
	if ( self.a.cornerMode == "B" )
	{
		if(self.cornerDirection == "left")
		{
			if(yaw < 0-self.ABangleCutoff)
				return "A";
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw > self.ABangleCutoff)
				return "A";
		}
		return "B";
	}
	else if ( self.a.cornerMode == "A" )
	{
		positionToSwitchTo = "B";
		if(self.cornerDirection == "left")
		{
			if(yaw > 0-self.ABangleCutoff)
				return "B";
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw < self.ABangleCutoff)
				return "B";
		}
		return "A";
	}
}

changeStepOutPos()
{
	self endon ("killanimscript");

	positionToSwitchTo = getBestStepOutPos();
	
	if( positionToSwitchTo == self.a.cornerMode )
		return false;
	
	self.changingCoverPos = true;
	
	animname = self.a.cornerMode + "_to_" + positionToSwitchTo;
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );
	
	midpoint = getPredictedPathMidpoint();
	if ( !self mayMoveToPoint( midpoint ) )
		return false;
	if ( !self mayMoveFromPointToPoint( midpoint, getAnimEndPos( switchanim ) ) )
		return false;
	
	// turn off aiming while we move.
	self StopAiming( .3 );
	
	prev_anim_pose = self.a.pose;
	
	self setanimlimited(animarray("straight_level"), 0, .2);
	
	self setFlaggedAnimKnob( "anim", switchanim, 1, .2, 1 );
	self thread DoNoteTracksWithEndon( "anim" );
	
	if ( animHasNotetrack( switchanim, "start_aim" ) )
	{
		self waittillmatch( "anim", "start_aim" );
	}
	else
	{
		println("^1Corner position switch animation \"" + animname + "\" in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");
		self waittillmatch( "anim", "end" );
	}
	
	self thread StartAiming( undefined, false, .3 );

	self waittillmatch( "anim", "end" );
	self clearanim(switchanim, .1);
	self.a.cornerMode = positionToSwitchTo;
	
	self.changingCoverPos = false;

	assert( self.a.pose == "stand" || self.a.pose == "crouch" );
	if ( self.a.pose != prev_anim_pose )
		set_anim_array( self.a.pose ); // don't call this if we don't have to, because we don't want to reset %exposed_aiming
	
	self thread ChangeAiming( undefined, true, .3 );
	
	return true;
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
	self SetAimingParams( spot, fullbody, transTime, 0 );
}
ChangeAiming( spot, fullbody, transtime )
{
	assert( self.cornerAiming );
	self SetAimingParams( spot, fullbody, transTime, transTime );
}
StopAiming( transtime )
{
	assert( self.cornerAiming );
	self.cornerAiming = false;
	
	// turn off shooting
	self clearAnim( %additive, transtime );
	// and turn off aiming
	animscripts\shared::setAnimAimWeight( 0, transtime );
}

SetAimingParams( spot, fullbody, transTimeAll, transTimeType )
{
	assert( isdefined(fullbody) );
	
	self.spot = spot; // undefined is ok
	
	self setanimlimited( %exposed_modern, 1, transTimeAll );
	self setanimlimited( %exposed_aiming, 1, transTimeAll );
	animscripts\shared::setAnimAimWeight( 1, transTimeAll );

	if ( fullbody )
	{
		self setanimlimited(animarray("straight_level"), 1, transTimeType);
		
		self setanimlimited(animArray("add_aim_up"),1,transTimeType);
		self setanimlimited(animArray("add_aim_down"),1,transTimeType);
		self setanimlimited(animArray("add_aim_left"),1,transTimeType);
		self setanimlimited(animArray("add_aim_right"),1,transTimeType);

		self setanimlimited(animArray("add_turn_aim_up"),0,transTimeType);
		self setanimlimited(animArray("add_turn_aim_down"),0,transTimeType);
		self setanimlimited(animArray("add_turn_aim_left"),0,transTimeType);
		self setanimlimited(animArray("add_turn_aim_right"),0,transTimeType);
	}
	else
	{
		self setanimlimited(animarray("straight_level"), 0, transTimeType);

		self setanimlimited(animArray("add_turn_aim_up"),1,transTimeType);
		self setanimlimited(animArray("add_turn_aim_down"),1,transTimeType);
		self setanimlimited(animArray("add_turn_aim_left"),1,transTimeType);
		self setanimlimited(animArray("add_turn_aim_right"),1,transTimeType);

		self setanimlimited(animArray("add_aim_up"),0,transTimeType);
		self setanimlimited(animArray("add_aim_down"),0,transTimeType);
		self setanimlimited(animArray("add_aim_left"),0,transTimeType);
		self setanimlimited(animArray("add_aim_right"),0,transTimeType);
	}
}

stepOut() /* bool */
{
	self.a.cornerMode = "alert";
	
	self animMode ( "zonly_physics" );

	set_anim_array( self.a.pose );
	
	anim_cornerMode = "none";
	if ( hasEnemySightPos() )
		anim_cornerMode = getCornerMode( self.coverNode, getEnemySightPos() );
	else
		anim_cornerMode = getCornerMode( self.coverNode );
	if ( anim_cornerMode == "none" )
		return false;
	
	self.keepClaimedNodeInGoal = true;
	self.new_anim_cornerMode = anim_cornerMode;
	
	
	animname = "alert_to_" + self.new_anim_cornerMode;
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );
	
	if ( !isPathClear( switchanim ) )
		return false;
	
	
	if( self.cornerDirection == "left" )
		self.a.special = "cover_left";
	else
		self.a.special = "cover_right";

	self.keepclaimednode = true;
	
	self.changingCoverPos = true;
	
	self setFlaggedAnimKnobAllRestart( "stepout", switchanim, %root, 1, .2, 1.0 );
	self.a.cornerMode = self.new_anim_cornerMode;
	
	//self setCornerAnimArray(self.cornerdirection,self.a.pose,self.a.cornerMode);
	
	self waittillmatch("stepout","start_aim");
	
	
	self StartAiming( undefined, false, .3 );
	self thread animscripts\shared::trackShootEntOrPos();
	self waittillmatch("stepout","end");
	
	self ChangeAiming( undefined, true, 0.2 );
	self clearAnim( %cover, 0.2 );
	self clearAnim( switchanim, 0.2 );
	
	self.changingCoverPos = false;
	
	return true;
}

getCornerMode( node, point )
{
	yaw = 0;
	if ( isdefined( point ) )
		yaw = node GetYawToOrigin( point );

	if ( node.type == "Cover Left" || node.type == "Cover Left Wide" )
	{
		if ( yaw > 14 )
			return "none";
		if ( yaw < 0-self.ABangleCutoff )
			return "A";
	}
	else if ( node.type == "Cover Right" || node.type == "Cover Right Wide" )
	{
		if ( yaw < -12 )
			return "none";
		if ( yaw > self.ABangleCutoff )
			return "A";
	}
	return "B";
}

stepOutAndShootEnemy()
{
	/*
	// rambo disabled.
	ramboChance = 10;
	if ( isdefined( self.lastSuppressionTime ) && gettime() - self.lastSuppressionTime < 3000 )
		ramboChance = 30;
	
	if ( self.shootObjective == "normal" && canDoRambo() && randomint(100) < ramboChance && haventRamboedWithinTime( 7 ) )
	{
		return ramboStepOut();
	}*/

	if ( !StepOut() ) // may not be room to step out
		return false;
	
	shootAsTold();
	
	returnToCover();
	
	return true;
}

canDoRambo()
{
	return animArrayAnyExist("rambo") && self.team != "allies";
}

haventRamboedWithinTime(time)
{
	if ( !isdefined( self.lastRamboTime ) )
		return true;
	return gettime() - self.lastRamboTime > time * 1000;
}

ramboStepOut()
{
	assert( animArrayAnyExist("rambo") );
	ramboanim = animArrayPickRandom("rambo");
	
	if ( !isPathClear() )
		return false;
	
	self.a.special = "none";
	
	self animMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;

	self setFlaggedAnimKnobAllRestart("rambo", ramboanim, %body, 1, 0);
	self animscripts\shared::DoNoteTracks("rambo");

	self.lastRamboTime = gettime();

	self.keepClaimedNodeInGoal = false;
	
	return true;
}

shootAsTold()
{
	while(1)
	{
		while(1)
		{
			if ( self.shouldReturnToCover )
				break;
			
			if ( !isdefined( self.shootPos ) ) {
				assert( !isdefined( self.shootEnt ) );
				// give shoot_behavior a chance to iterate
				wait .05;
				waittillframeend;
				if ( isdefined( self.shootPos ) )
					continue;
				break;
			}
			
			if ( !self.bulletsInClip )
				break;
			
			if ( shootPosOutsideLegalYawRange() )
			{
				if ( !changeStepOutPos() )
				{
					// if we failed because there's no better step out pos, give up
					if ( getBestStepOutPos() == self.a.cornerMode )
						break;
					
					// couldn't change position, shoot for a short bit and we'll try again
					shootUntilShootBehaviorChangeForTime( .2 );
					continue;
				}
				
				// if they're moving back and forth too fast for us to respond intelligently to them,
				// give up on firing at them for the moment
				if ( shootPosOutsideLegalYawRange() )
					break;
				
				continue;
			}
			
			shootUntilShootBehaviorChange();
			
			self clearAnim( %additive, .2 );
		}
		
		if ( self canReturnToCover() )
			break;

		// couldn't return to cover. keep shooting and try again
		
		// (change step out pos if necessary and possible)
		if ( shootPosOutsideLegalYawRange() && changeStepOutPos() )
			continue;
		
		shootUntilShootBehaviorChangeForTime( .2 );
	}
}

shootUntilShootBehaviorChangeForTime( time )
{
	self thread notifyStopShootingAfterTime( time );
	
	starttime = gettime();
	
	shootUntilShootBehaviorChange();
	self notify("stopNotifyStopShootingAfterTime");

	timepassed = (gettime() - starttime) / 1000;
	if ( timepassed < time )
		wait time - timepassed;
}

notifyStopShootingAfterTime( time )
{
	self endon("killanimscript");
	self endon("stopNotifyStopShootingAfterTime");
	
	wait time;
	
	self notify("stopShooting");
}

shootUntilShootBehaviorChange()
{
	self endon("return_to_cover");
	self endon("shoot_behavior_change");
	self endon("stopShooting");
	
	self thread angleRangeThread(); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	self thread standIdleThread();
	
	if ( self.shootStyle == "full" )
	{
		self FireUntilOutOfAmmo( animArray("fire"), false );
	}
	else if ( self.shootStyle == "burst" || self.shootStyle == "single" || self.shootStyle == "semi" )
	{
		while(1)
		{
			numShots = 1;
			if ( self.shootStyle == "burst" || self.shootStyle == "semi" )
				numShots = animscripts\shared::decideNumShots();	
				
			if ( numShots == 1 )
				self FireUntilOutOfAmmo( animArray( "single" ), true, numShots );
			else
				self FireUntilOutOfAmmo( animArray( self.shootStyle + numShots ), true, numShots );
			
			if ( !self.bulletsInClip )
				break;
			
			burstDelay();
		}
	}
	else
	{
		assert( self.shootStyle == "none" );
		self waittill( "the end of all time" ); // waits for the endons to happen
	}
}

standIdleThread()
{
	self endon("killanimscript");
	
	self setAnim( %add_idle, 1, .2 );
	standIdleThreadInternal();
	self clearAnim( %add_idle, .2 );
}

standIdleThreadInternal()
{
	self endon("shoot_behavior_change");
	self endon("stop_shooting");
	self endon("return_to_cover");
	
	assert( animArrayAnyExist("exposed_idle") );
	for(;;)
	{
		self setFlaggedAnimKnobLimited( "idle", animArrayPickRandom("exposed_idle"), 1, .2 );
		
		self waittillmatch( "idle", "end" );
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
			break;
		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}

showstate()
{
	self.enemy endon("death");
	self endon("enemy");
	self endon("stopshowstate");
	
	while(1)
	{
		wait .05;
		print3d(self.origin + (0,0,60), self.statetext);
	}
}

canReturnToCover()
{
	if ( !anim.maymoveCheckEnabled )
		return true;
	
	midpoint = getPredictedPathMidpoint();
	
	if ( !self mayMoveToPoint( midpoint ) )
		return false;
	
	return self mayMoveFromPointToPoint( midpoint, self.coverNode.origin );
}

returnToCover()
{
	assert( self canReturnToCover() );
	
	// Go back into hiding.
	suppressed = issuppressedWrapper();
	self notify ("take_cover_at_corner"); // Stop doing the adjust-stance transition thread

	if ( suppressed )
		rate = 1.5;
	else
		rate = 1;
	
	self.changingCoverPos = true;
	
	animname = self.a.cornerMode + "_to_alert";
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );
	
	self StopAiming( .3 );
	self clearAnim( %additive, .2 );
	
	reloading = false;
	if ( suppressed && animArrayAnyExist( animname + "_reload" ) && randomfloat(100) < 75 )
	{
		switchanim = animArrayPickRandom( animname + "_reload" );
		rate = 1;
		reloading = true;
	}
	// turn off the standing anim
	self setanimlimited(animarray("straight_level"), 0, .1);
	
	// as we turn on the hiding anim
	self setFlaggedAnimKnobAllRestart("hide", switchanim, %body, 1, .1, rate);
	self animscripts\shared::DoNoteTracks("hide");
	self.a.alertness = "alert";	// Should be set in the aim2alert animation but sometimes isn't.
	
	if ( reloading )
		self animscripts\weaponList::RefillClip();
	
	self notify ( "stop updating angles" );
	self notify ("stop EyesAtEnemy");
	self notify ("stop tracking");
	
	self.changingCoverPos = false;
	self.a.special = "none";
	
	self.keepClaimedNodeInGoal = false;
	self.keepclaimednode = false;
}

blindfire()
{
	if ( !animArrayAnyExist("blind_fire") )
		return false;
	
	self animMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;

	self setFlaggedAnimKnobAllRestart("blindfire", animArrayPickRandom("blind_fire"), %body, 1, 0, 1);
	self animscripts\shared::DoNoteTracks("blindfire");

	self.keepClaimedNodeInGoal = false;
	
	return true;
}

linethread(a,b,col)
{
	if ( !isdefined(col) )
		col = (1,1,1);
	for ( i = 0; i < 100; i++)
	{
		line(a,b,col);
		wait .05;
	}
}

tryThrowingGrenadeStayHidden()
{
	return tryThrowingGrenade( true );
}

tryThrowingGrenade(safe)
{
	theanim = undefined;
	if ( isdefined(safe) && safe ) {
		if ( !isdefined( self.a.array["grenade_safe"] ) )
			return false;
		theanim = animArray("grenade_safe");
	}
	else {
		if ( !isdefined( self.a.array["grenade_exposed"] ) )
			return false;
		theanim = animArray("grenade_exposed");
	}
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	threwGrenade = TryGrenadePos( getEnemySightPos(), theanim, (32,20,64) );
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}

printYawToEnemy() 
{
	println("yaw: ",self getYawToEnemy());
}

lookForEnemy( lookTime )
{
	if ( !isdefined( self.a.array["alert_to_look"] ) )
		return false;
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	
	// look out from alert
	if ( !peekOut() )
		return false;
	
	animscripts\shared::playLookAnimation( animarray("look_idle"), lookTime, ::canStopPeeking );
	
	lookanim = undefined;
	if ( self isSuppressedWrapper() )
		lookanim = animArray("look_to_alert_fast");
	else
		lookanim = animArray("look_to_alert");
	
	self setflaggedanimknoballrestart("looking_end", lookanim, %body, 1, .1, 1.0);
	animscripts\shared::DoNoteTracks("looking_end");
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	
	self.keepClaimedNodeInGoal = false;
	
	return true;
}


peekOut()
{
	peekanim = animArray("alert_to_look");
	
	if ( !self mayMoveToPoint( getAnimEndPos( peekanim ) ) )
		return false;
	
	// not safe to stop peeking in the middle because it will screw up our deltas
	//self thread _peekStop();
	//self endon ("stopPeeking");
	
	self setflaggedanimknobAll("looking_start", peekanim, %body, 1, .2, 1);
	animscripts\shared::DoNoteTracks("looking_start");
	//self notify ("stopPeekCheckThread");
	
	return true;
}

canStopPeeking()
{
	return self mayMoveToPoint( self.coverNode.origin );
}

fastlook()
{
	// corner fast look animations aren't set up right.
	return false;
	
	/*
	if ( !isdefined( self.a.array["look"] ) )
		return false;
	
	self setFlaggedAnimKnobAllRestart( "look", animArray( "look" ), %body, 1, .1 );
	self animscripts\shared::DoNoteTracks( "look" );
	
	return true;
	*/
}

cornerReload()
{
	// TODO: this should be using DoNoteTracks
	
	assert( animArrayAnyExist( "reload" ) );
	reloadanim = animArrayPickRandom( "reload" );
	self setflaggedanimknobrestart("anim",reloadanim,1,.2);
	self waittillmatch("anim","end");
	self animscripts\weaponList::RefillClip();
	self setanimrestart(animarray("alert_idle"),1,.2);
	self clearanim(reloadanim,.2);

	return true;
}

isPathClear( stepoutanim )
{
	if ( !anim.maymoveCheckEnabled )
		return true;
	
	midpoint = getPredictedPathMidpoint();
	
	if ( !self maymovetopoint( midpoint ) )
		return false;
	
	if ( !isdefined( stepoutanim ) )
		return true;
	
	return self maymovefrompointtopoint( midpoint, getAnimEndPos( stepoutanim ) );
}

getPredictedPathMidpoint()
{
	angles = self.coverNode.angles;
	right = anglestoright(angles);
	switch(self.a.script)
	{
		case "cover_left":
			right = vectorScale(right, -36);
		break;

		case "cover_right":
			right = vectorScale(right, 36);
		break;
		
		default:
			assertEx(0, "What kind of node is this????");
	}
	
	return self.coverNode.origin + (right[0], right[1], 0);
}

idle() 
{
	self endon("end_idle");
	
	if ( randomint(2) == 0 && animArrayAnyExist("alert_idle_twitch") )
		idleanim = animArrayPickRandom("alert_idle_twitch");
	else
		idleanim = animarray("alert_idle");

	playIdleAnimation( idleAnim );
	
	return true;
}

flinch()
{
	if ( !animArrayAnyExist("alert_idle_flinch") )
		return false;

	self notify("end_idle");
	
	playIdleAnimation( animArrayPickRandom("alert_idle_flinch") );
	
	return true;
}

playIdleAnimation( idleAnim )
{
	self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, 1);
	
	self animscripts\shared::DoNoteTracks( "idle" );
}


set_anim_array( stance ) 
{
	[[ self.animArrayFuncs["hiding"][ stance ] ]]();
	[[ self.animArrayFuncs["exposed"][ stance ] ]]();
}


setCornerAnimArray( stance ) 
{
	if(stance == "stand")
		self set_standing_animarray_aiming();	
	else if(stance == "crouch")
		self set_crouching_animarray_aiming();
}

transitionToStance( stance )
{
	if (self.a.pose == stance)
	{
		set_anim_array( stance );
		return;
	}

//	self ExitProneWrapper(0.5);
	self setFlaggedAnimKnobAllRestart( "anim", animarray("stance_change"), %body);

	set_anim_array( stance ); // (sets anim_pose to stance)

	self animscripts\shared::DoNoteTracks ("anim");
	assert( self.a.pose == stance );
	wait (0.2);
}

GoToCover( coveranim, transTime, playTime ) 
{	
	cornerAngle = GetNodeDirection();
	cornerOrigin = GetNodeOrigin();

	self OrientMode( "face angle", cornerAngle + self.hideyawoffset );

	self animMode ( "normal" );
	
	assert( transTime <= playTime );
	
	self thread animscripts\shared::moveToOriginOverTime( cornerOrigin, transTime );
	self setFlaggedAnimKnobAllRestart( "coveranim", coveranim, %body, 1, transTime );
	self animscripts\shared::DoNoteTracksForTime( playTime, "coveranim" );

	self animMode ( "zonly_physics" );
}

drawoffset()
{
	self endon("killanimscript");
	for(;;)
	{
		line(self.node.origin + (0,0,20),(0,0,20) + self.node.origin + vectorscale(anglestoright(self.node.angles + (0,0,0)),16));
		wait(0.05);	
	}
}


set_standing_animarray_aiming() 
{
	if(!isdefined(self.a.array))
		assertmsg("set_standing_animarray_aiming_AandC::this function needs to be called after the initial corner set_ functions"); 
	
	self.ABangleCutoff = 38;
	
	self.a.array["add_aim_up"] = %exposed_aim_8;
	self.a.array["add_aim_down"] = %exposed_aim_2;
	self.a.array["add_aim_left"] = %exposed_aim_4;
	self.a.array["add_aim_right"] = %exposed_aim_6;
	self.a.array["add_turn_aim_up"] = %exposed_turn_aim_8;
	self.a.array["add_turn_aim_down"] = %exposed_turn_aim_2;
	self.a.array["add_turn_aim_left"] = %exposed_turn_aim_4;
	self.a.array["add_turn_aim_right"] = %exposed_turn_aim_6;
	self.a.array["straight_level"] = %exposed_aim_5;
	
	self.a.array["fire"] = %exposed_shoot_auto_v2;
	self.a.array["semi2"] = %exposed_shoot_semi2;
	self.a.array["semi3"] = %exposed_shoot_semi3;
	self.a.array["semi4"] = %exposed_shoot_semi4;
	self.a.array["semi5"] = %exposed_shoot_semi5;

	self.a.array["single"] = %exposed_shoot_semi1;

	self.a.array["burst2"] = %exposed_shoot_burst3; // (will be limited to 2 shots)
	self.a.array["burst3"] = %exposed_shoot_burst3;
	self.a.array["burst4"] = %exposed_shoot_burst4;
	self.a.array["burst5"] = %exposed_shoot_burst5;
	self.a.array["burst6"] = %exposed_shoot_burst6;
	
	self.a.array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
}

set_crouching_animarray_aiming() 
{
	if(!isdefined(self.a.array))
		assertmsg("set_standing_animarray_aiming_AandC::this function needs to be called after the initial corner set_ functions"); 
	
	self.ABangleCutoff = 31;
	
	self.a.array["add_aim_up"] = %exposed_crouch_aim_8;
	self.a.array["add_aim_down"] = %exposed_crouch_aim_2;
	self.a.array["add_aim_left"] = %exposed_crouch_aim_4;
	self.a.array["add_aim_right"] = %exposed_crouch_aim_6;
	self.a.array["add_turn_aim_up"] = %exposed_crouch_turn_aim_8;
	self.a.array["add_turn_aim_down"] = %exposed_crouch_turn_aim_2;
	self.a.array["add_turn_aim_left"] = %exposed_crouch_turn_aim_4;
	self.a.array["add_turn_aim_right"] = %exposed_crouch_turn_aim_6;
	self.a.array["straight_level"] = %exposed_crouch_aim_5;
	
	self.a.array["fire"] = %exposed_crouch_shoot_auto_v2;
	self.a.array["semi2"] = %exposed_crouch_shoot_semi2;
	self.a.array["semi3"] = %exposed_crouch_shoot_semi3;
	self.a.array["semi4"] = %exposed_crouch_shoot_semi4;
	self.a.array["semi5"] = %exposed_crouch_shoot_semi5;
	
	self.a.array["single"] = %exposed_crouch_shoot_semi1;

	self.a.array["burst2"] = %exposed_crouch_shoot_burst3; // (will be limited to 2 shots)
	self.a.array["burst3"] = %exposed_crouch_shoot_burst3;
	self.a.array["burst4"] = %exposed_crouch_shoot_burst4;
	self.a.array["burst5"] = %exposed_crouch_shoot_burst5;
	self.a.array["burst6"] = %exposed_crouch_shoot_burst6;
	
	self.a.array["exposed_idle"] = array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
}

set_aiming_limits() 
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
}

