#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_Utility;
#include common_scripts\Utility;
#using_animtree ("generic_human");

MeleeCombat()
{
//  self trackScriptState( "melee", changeReason );
	self endon("killanimscript");
	self notify("melee");
//	self endon(anim.scriptChange);

	assert( CanMeleeAnyRange() );

	realMelee = true;

	if ( animscripts\utility::okToMelee(self.enemy) )
		animscripts\utility::IAmMeleeing(self.enemy);
	else
		realMelee = false;

	self thread EyesAtEnemy();
	self OrientMode("face enemy");
	
	MeleeDebugPrint("Melee begin");
	
	self animMode( "zonly_physics" );
	
	resetGiveUpTime();
	
    for ( ;; )
    {
		// first, charge forward if we need to; get into place to play the melee animation
		if ( !PrepareToMelee() )
		{
			// if we couldn't get in place to melee, don't melee.
			// remember that we couldn't get in place so that we don't try again for a while.
			self.lastMeleeGiveUpTime = gettime();
			break;
		}
		assert( self.a.pose == "stand" );
		
		MeleeDebugPrint("Melee main loop" + randomint(100));
		
		// we should now be close enough to melee.
		
		// If no one else is meleeing this person, tell the system that I am, so no one else will charge him.
		if ( !realMelee && animscripts\utility::okToMelee(self.enemy) )
		{
			realMelee = true;
			animscripts\utility::IAmMeleeing(self.enemy);
		}

		self thread EyesAtEnemy();
		
		self animscripts\battleChatter_ai::evaluateMeleeEvent();

		// TODO: we should use enemypose to play crouching melee anims when necessary.
		/*player = anim.player;
		if (self.enemy == player)
		{
			enemypose = player getstance();
		}
		else
		{
			enemypose = self.enemy.a.pose;
		}*/
		
		self OrientMode("face current");
		
		self setflaggedanimknoballrestart("meleeanim", %melee_1, %body, 1, .2, 1);
		
		while ( 1 )
		{
			self waittill("meleeanim", note);
			if ( note == "end" )
			{
				break;
			}
			else if ( note == "fire" )
			{
				oldhealth = self.enemy.health;
				self melee();
				if ( self.enemy.health < oldhealth )
					resetGiveUpTime();
			}
			else if ( note == "stop" )
			{
				// check if it's worth continuing with another melee.
				if ( !CanContinueToMelee() ) // "if we can't melee without charging"
					break;
			}
		}
		
		self OrientMode("face default");
    }
	
	if (realMelee)
	{
		animscripts\utility::ImNotMeleeing(self.enemy);
	}
	
	self animMode("none");
	
	//self thread animscripts\combat::main();
	self thread animscripts\combat::main();
	self notify ("stop EyesAtEnemy");
	self notify ("stop_melee_debug_print");
	scriptChange();
}

resetGiveUpTime()
{
	if ( distanceSquared( self.origin, self.enemy.origin ) > anim.chargeRangeSq )
		self.giveUpOnMeleeTime = gettime() + randomintrange( 2700, 3300 );
	else
		self.giveUpOnMeleeTime = gettime() + randomintrange( 1700, 2300 );
}

MeleeDebugPrint(text)
{
	return;
	self.meleedebugprint = text;
	self thread meleeDebugPrintThreadWrapper();
}

meleeDebugPrintThreadWrapper()
{
	if ( !isdefined(self.meleedebugthread) )
	{
		self.meleedebugthread = true;
		self meleeDebugPrintThread();
		self.meleedebugthread = undefined;
	}
}

meleeDebugPrintThread()
{
	self endon("death");
	self endon("killanimscript");
	self endon("stop_melee_debug_print");
	
	while(1)
	{
		print3d(self.origin + (0,0,60), self.meleedebugprint, (1,1,1), 1, .1);
		wait .05;
	}
}

getEnemyPose()
{
	if ( isplayer( self.enemy ) )
		return self.enemy getStance();
	else
		return self.enemy.a.pose;
}

CanContinueToMelee()
{
	return CanMeleeInternal( "already started" );
}

CanMeleeAnyRange()
{
	return CanMeleeInternal( "any range" );
}

CanMeleeDesperate()
{
	return CanMeleeInternal( "long range" );
}

CanMelee()
{
	return CanMeleeInternal( "normal" );
}

CanMeleeInternal( state )
{
	// no meleeing virtual targets
	if(!issentient(self.enemy))
		return false;

	// or dead ones
	if (!isAlive(self.enemy))
		return false;
	
	// Can't charge if we're not standing
	if (self.a.pose != "stand")
		return false;
	
	enemypose = getEnemyPose();
	if ( enemypose != "stand" && enemypose != "crouch" )
		return false;
	
	// if we're not at least partially facing the guy, wait until we are
	yaw = abs(getYawToEnemy());
	if ( (yaw > 60 && state != "already started") || yaw > 110 )
		return false;
	
	enemyPoint = self.enemy GetOrigin();
	vecToEnemy = enemyPoint - self.origin;
	self.enemyDistanceSq = lengthSquared( vecToEnemy );

	// so we don't melee charge a guy who has gained ignoreme in the past frame
	nearest_enemy_sqrd_dist = self GetClosestEnemySqDist();
	if ( nearest_enemy_sqrd_dist > self.enemyDistanceSq )
		return false;

	// check if the path to the enemy is clear.
	dirToEnemy = vectorNormalize( (vecToEnemy[0], vecToEnemy[1], 0 ) );
	meleePoint = enemyPoint - ( dirToEnemy[0]*32, dirToEnemy[1]*32, 0 );
	clearPath = self maymovetopoint(meleePoint);
	
	if ( !clearPath )
		return false;

	if (self.enemyDistanceSq <= anim.meleeRangeSq)
	{
		// Enemy is already close enough to melee.
		return true;
	}
	if ( state != "any range" )
	{
		chargeRangeSq = anim.chargeRangeSq;
		if ( state == "long range" )
			chargeRangeSq = anim.chargeLongRangeSq;
		if (self.enemyDistanceSq > chargeRangeSq)
		{
			// Enemy isn't even close enough to charge.
			return false;
		}
	}
	
	if ( state == "already started" ) // if we already started, we're checking to see if we can melee *without* charging.
		return false;
	
	// at this point, we can melee iff we can charge.

	// don't charge if we recently missed someone
	if ( isdefined( self.lastMeleeGiveUpTime ) && gettime() - self.lastMeleeGiveUpTime < 3000 )
		return false;
	
	// check if someone else is already meleeing my enemy.
	if ( !animscripts\utility::okToMelee(self.enemy) )
		return false;
	
	return true;
}

// this function makes the guy run towards his enemy, and start raising his gun if he's close enough to melee.
// it will return false if he gives up, or true if he's ready to start a melee animation.
PrepareToMelee()
{
	if ( !CanMeleeAnyRange() )
		return false;
	
	if (self.enemyDistanceSq <= anim.meleeRangeSq)
	{
		// just play a melee-from-standing transition
		self SetFlaggedAnimKnobAll("readyanim", %stand_2_melee_1, %body, 1, .3, 1);
		self animscripts\shared::DoNoteTracks("readyanim");
		return true;
	}

	if (!isdefined (self.a.nextMeleeChargeSound))
		 self.a.nextMeleeChargeSound = 0;
	if ( gettime() > self.a.nextMeleeChargeSound)
	{
		self animscripts\face::SayGenericDialogue("meleecharge");
		self.a.nextMeleeChargeSound = gettime() + 8000;
	}
	
	prevEnemyPos = self.enemy.origin;
	
	sampleTime = 0.1;

	raiseGunAnimTravelDist = length(getmovedelta(%run_2_melee_charge, 0, 1));
	meleeAnimTravelDist = 32;
	shouldRaiseGunDist = anim.meleeRange * 0.75 + meleeAnimTravelDist + raiseGunAnimTravelDist;
	shouldRaiseGunDistSq = shouldRaiseGunDist * shouldRaiseGunDist;
	
	shouldMeleeDist = anim.meleeRange + meleeAnimTravelDist;
	shouldMeleeDistSq = shouldMeleeDist * shouldMeleeDist;
	
	raiseGunFullDuration = getanimlength(%run_2_melee_charge) * 1000;
	raiseGunFinishDuration = raiseGunFullDuration - 100;
	raiseGunPredictDuration = raiseGunFullDuration - 200;
	raiseGunStartTime = 0;

	predictedEnemyDistSqAfterRaiseGun = undefined;
	
	runAnim = %combatrun_forward_1;
	
	self SetFlaggedAnimKnobAll("chargeanim", runAnim, %body, 1, .3, 1);
	raisingGun = false;
	
	while ( 1 )
	{
		MeleeDebugPrint("PrepareToMelee loop" + randomint(100));
		
		time = gettime();
		
		willBeWithinRangeWhenGunIsRaised = (isdefined( predictedEnemyDistSqAfterRaiseGun ) && predictedEnemyDistSqAfterRaiseGun <= shouldRaiseGunDistSq);
		
		if ( !raisingGun )
		{
			if ( willBeWithinRangeWhenGunIsRaised )
			{
				self SetFlaggedAnimKnobAllRestart("chargeanim", %run_2_melee_charge, %body, 1, .2, 1);
				raiseGunStartTime = time;
				raisingGun = true;
			}
		}
		else
		{
			// if we *are* raising our gun, don't stop unless we're hopelessly out of range,
			// or if we hit the end of the raise gun animation and didn't melee yet
			withinRangeNow = self.enemyDistanceSq <= shouldRaiseGunDistSq;
			if ( time - raiseGunStartTime >= raiseGunFinishDuration || (!willBeWithinRangeWhenGunIsRaised && !withinRangeNow) )
			{
				self SetFlaggedAnimKnobAll("chargeanim", runAnim, %body, 1, .3, 1);
				raisingGun = false;
			}
		}
		self animscripts\shared::DoNoteTracksForTime(sampleTime, "chargeanim");
		
		// it's possible something happened in the meantime that makes meleeing impossible.
		if ( !CanMeleeAnyRange() )
			return false;
		assert( isdefined( self.enemyDistanceSq ) ); // should be defined in CanMelee

		enemyVel = vectorScale( self.enemy.origin - prevEnemyPos, 1 / (gettime() - time) ); // units/msec
		prevEnemyPos = self.enemy.origin;
		
		// figure out where the player will be when we hit them if we (a) start meleeing now, or (b) start raising our gun now
		predictedEnemyPosAfterRaiseGun = self.enemy.origin + vectorScale( enemyVel, raiseGunPredictDuration );
		predictedEnemyDistSqAfterRaiseGun = distanceSquared( self.origin, predictedEnemyPosAfterRaiseGun );
		
		// if we're done raising our gun, and starting a melee now will hit the guy, our preparation is finished
		if ( raisingGun && self.enemyDistanceSq <= shouldMeleeDistSq && gettime() - raiseGunStartTime >= raiseGunFinishDuration )
			break;

		// don't keep charging if we've been doing this for too long.
		if ( !raisingGun && gettime() >= self.giveUpOnMeleeTime )
			return false;
	}
	return true;
}