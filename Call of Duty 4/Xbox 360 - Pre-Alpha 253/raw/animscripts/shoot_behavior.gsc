#include common_scripts\utility;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;

// Ideally, this will be the only thread *anywhere* that decides what/where to shoot at
// and how to shoot at it.

// This thread keeps three variables updated, and notifies "shoot_behavior_change" when any of them have changed.
// They are:
//  shootEnt - an entity. aim/shoot at this if it's defined.
//  shootPos - a vector. aim/shoot towards this if shootEnt isn't defined. if not defined, stop shooting entirely and return to cover if possible.
//		Whenever shootEnt is defined, shootPos will be defined as its getShootAtPos().
//  shootStyle - how to shoot.
//    "full" (unload on the target),
//    "burst" (occasional groups of shots),
//    "semi" (occasianal single shots),
//    "single" (occasional single shots),
//    "none" (don't shoot, just aim).
// This thread will also notify "return_to_cover" and set self.shouldReturnToCover = true if it's a good idea to do so.
// Notify "stop_deciding_how_to_shoot" to end this thread if no longer trying to shoot.

decideWhatAndHowToShoot( objective )
{
	self endon("killanimscript");
	self notify("stop_deciding_how_to_shoot"); // just in case...
	self endon("stop_deciding_how_to_shoot");
	self endon("death");
	
	assert( isdefined( objective ) ); // just use "normal" if you don't know what to use
	
	self.shootObjective = objective;
	// self.shootObjective is always "normal", "suppress", or "ambush"
	
	self.shootEnt = undefined;
	self.shootPos = undefined;
	self.shootStyle = "none";
	self.fastBurst = false;
	self.shouldReturnToCover = false;
	
	if ( !isdefined( self.changingCoverPos ) )
		self.changingCoverPos = false;
	
	if ( self.a.script != "combat" )
	{
		// it's not safe to do some things until the next frame,
		// such as canSuppressEnemy(), which may change the state of
		// self.goodShootPosValid, which will screw up cover_behavior::main
		// when this is called but then stopped immediately.
		wait .05;
	}
	
	prevShootEnt = self.shootEnt;
	prevShootPos = self.shootPos;
	prevShootStyle = self.shootStyle;
	
	if ( self.team == "allies" )
	{
		self.a.laserOn = true;
		self animscripts\shared::updateLaserStatus();
	}
	
	// only watch for incoming fire if it will be beneficial for us to return to cover when shot at.
	if ( !self.a.atConcealmentNode || !self canSeeEnemy() )
		thread watchForIncomingFire();
	thread runOnShootBehaviorEnd();

	self.ambushEndTime = undefined;
	
	prof_begin("decideWhatAndHowToShoot");

	while(1)
	{
		assert( self.shootObjective == "normal" || self.shootObjective == "suppress" || self.shootObjective == "ambush" );
		assert( !isdefined( self.shootEnt ) || isdefined( self.shootPos ) ); // shootPos must be shootEnt's shootAtPos if shootEnt is defined, for convenience elsewhere
		
		
		if ( self weaponAnims() == "rocketlauncher" )
			rpgShoot();
		else if ( self usingSidearm() )
			pistolShoot();
		else if(weaponclass(self.weapon) == "spread")
			shotgunshoot();
		else
			rifleShoot();
		
		
		if ( checkChanged(prevShootEnt, self.shootEnt) || (!isdefined( self.shootEnt ) && checkChanged(prevShootPos, self.shootPos)) || checkChanged(prevShootStyle, self.shootStyle) )
			self notify("shoot_behavior_change");
		prevShootEnt = self.shootEnt;
		prevShootPos = self.shootPos;
		prevShootStyle = self.shootStyle;
		
		
		// (trying to prevent many AI from doing lots of work on the same frame)
		WaitABit();
	}
	
	prof_end("decideWhatAndHowToShoot");
}

WaitABit()
{
	self endon("enemy");
	self endon("done_changing_cover_pos");
	self endon("weapon_position_change");
	self endon("enemy_visible");
	
	if ( isdefined( self.shootEnt ) )
	{
		self.shootEnt endon("death");
		
		numframes = randomintrange( 4, 7 );
		// (want to keep self.shootPos up to date)
		wait .05;
		for ( i = 1; i < numframes; i++ )
		{
			self.shootPos = self.shootEnt getShootAtPos();
			wait .05;
		}
	}
	else
	{
		wait randomfloatrange( 0.2, 0.35 );
	}
}

rifleShoot()
{
	if ( self.shootObjective == "normal" )
	{
		if ( !canSeeEnemy() )
		{
			// enemy disappeared!
			if ( !isdefined( self.enemy ) )
			{
				haveNothingToShoot();
			}
			else
			{
				markEnemyPosInvisible();

				if ( self.provideCoveringFire || randomint(5) > 0 )
					self.shootObjective = "suppress";
				else
					self.shootObjective = "ambush";
				return;
			}
		}
		else
		{
			setShootEnt( self.enemy );
			self setShootStyleForVisibleEnemy();
		}
	}
	else
	{
		if ( canSeeEnemy() ) // later, maybe we can be more realistic than just shooting at the enemy the instant he becomes visible
		{
			self.shootObjective = "normal";
			self.ambushEndTime = undefined;
			return;
		}
		
		markEnemyPosInvisible();
		
		if ( !canSuppressEnemy() )
		{
			// no idea where the enemy is, so we can only ambush a valid enemy
			if ( self.shootObjective == "suppress" || !isValidEnemy( self.enemy ) )
			{
				haveNothingToShoot();
			}
			else
			{
				assert( self.shootObjective == "ambush" );
				assert( isValidEnemy( self.enemy ) );
				
				self.shootStyle = "none";
				
				likelyEnemyDir = self getAnglesToLikelyEnemyPath();
				if ( isdefined( likelyEnemyDir ) )
				{
					self.shootEnt = undefined;
					newShootPos = self getEye() + anglesToForward( likelyEnemyDir ) * distance( self.origin, self.enemy.origin );
					if ( !isdefined( self.shootPos ) || distanceSquared( newShootPos, self.shootPos ) > 5*5 ) // avoid frequent "shoot_behavior_change" notifies
						self.shootPos = newShootPos;
					
					if ( shouldStopAmbushing() )
					{
						self notify("return_to_cover");
						self.shouldReturnToCover = true;
					}
				}
				else
				{
					haveNothingToShoot();
				}
			}
		}
		else
		{
			self.shootEnt = undefined;
			self.shootPos = getEnemySightPos();
			
			if ( self.shootObjective == "suppress" )
			{
				self setShootStyleForSuppression();
			}
			else
			{
				assert( self.shootObjective == "ambush" );
				self.shootStyle = "none";
				
				if ( self shouldStopAmbushing() )
				{
					self.shootObjective = "suppress";
					if ( randomint(3) == 0 )
					{
						self notify("return_to_cover");
						self.shouldReturnToCover = true;
					}
				}
			}
		}
	}
}

shouldStopAmbushing()
{
	if ( !isdefined( self.ambushEndTime ) )
		self.ambushEndTime = gettime() + randomintrange(4000, 8000);
	return self.ambushEndTime < gettime();
}

rpgShoot()
{
	if ( !canSeeEnemy() )
	{
		markEnemyPosInvisible();
		
		haveNothingToShoot();
		return;
	}
	
	setShootEnt( self.enemy );
	self.shootStyle = "single";

	distSqToShootPos = lengthsquared( self.origin - self.shootPos );
	// too close for RPG
	if ( distSqToShootPos < squared( 512 ) )
	{
		self notify("return_to_cover");
		self.shouldReturnToCover = true;
		return;
	}
}


shotgunShoot()
{
	if ( !canSeeEnemy() )
	{
		haveNothingToShoot();
		return;
	}

	setShootEnt( self.enemy );
	self.shootStyle = "single";	
}


pistolShoot()
{
	if ( self.shootObjective == "normal" )
	{
		if ( !canSeeEnemy() )
		{
			// enemy disappeared!
			if ( !isdefined( self.enemy ) )
			{
				haveNothingToShoot();
				return;
			}
			else
			{
				markEnemyPosInvisible();
				
				self.shootObjective = "ambush";
				return;
			}
		}
		else
		{
			setShootEnt( self.enemy );
			self.shootStyle = "single";
		}
	}
	else
	{
		if ( canSeeEnemy() ) // later, maybe we can be more realistic than just shooting at the enemy the instant he becomes visible
		{
			self.shootObjective = "normal";
			self.ambushEndTime = undefined;
			return;
		}
		
		markEnemyPosInvisible();
		
		if ( canSuppressEnemy() )
		{
			self.shootEnt = undefined;
			self.shootPos = getEnemySightPos();
		}
		
		self.shootStyle = "none";
		
		// stop ambushing after a while
		if ( !isdefined( self.ambushEndTime ) )
			self.ambushEndTime = gettime() + randomintrange(4000, 8000);
			
		if ( self.ambushEndTime < gettime() )
			self.shootObjective = "normal";
	}
}

markEnemyPosInvisible()
{
	if ( isdefined( self.enemy ) && !self.changingCoverPos && self.a.script != "combat" )
	{
		// make sure they're not just hiding
		if ( isAI( self.enemy ) && isdefined( self.enemy.a.script ) && (self.enemy.a.script == "cover_stand" || self.enemy.a.script == "cover_crouch") )
		{
			if ( isdefined( self.enemy.a.coverMode ) && self.enemy.a.coverMode == "hide" )
				return;
		}
		
		self.couldntSeeEnemyPos = self.enemy.origin;
	}
}

watchForIncomingFire()
{
	self endon("killanimscript");
	self endon("stop_deciding_how_to_shoot");
	
	while(1)
	{
		self waittill("suppression");
		
		if ( self.suppressionMeter > self.suppressionThreshold )
		{
			self notify("return_to_cover");
			self.shouldReturnToCover = true;
		}
	}
}


runOnShootBehaviorEnd()
{
	self endon ( "death" );
	
	self waittill_any( "killanimscript", "stop_deciding_how_to_shoot"/*, "return_to_cover"*/ );
	
	self.a.laserOn = false;
	self animscripts\shared::updateLaserStatus();
}

checkChanged( prevval, newval )
{
	if ( isdefined( prevval ) != isdefined( newval ) )
		return true;
	if ( !isdefined( newval ) )
	{
		assert( !isdefined( prevval ) );
		return false;
	}
	return prevval != newval;
}

setShootEnt( ent )
{
	self.shootEnt = ent;
	self.shootPos = self.shootEnt getShootAtPos();
}

haveNothingToShoot()
{
	self.shootEnt = undefined;
	self.shootPos = undefined;
	self.shootStyle = "none";
	
	if ( !self.changingCoverPos )
	{
		self notify("return_to_cover");
		self.shouldReturnToCover = true;
	}
}

setShootStyleForVisibleEnemy()
{
	assert( isdefined( self.shootPos ) );
	
	if ( isdefined( self.shootEnt ) && isdefined( self.shootEnt.syncedMeleeTarget ) )
	{
		return setShootStyle( "single", false );
	}

	distanceSq = distanceSquared( self getShootAtPos(), self.shootPos );
	
	if ( weaponIsSemiAuto( self.weapon ) )
	{
		if ( distanceSq < 1600*1600 )
			return setShootStyle( "semi", false );
		return setShootStyle( "single", false );
	}
		
	if ( weaponClass( self.weapon ) == "mg" )
		return setShootStyle( "full", false );

	if ( distanceSq < 300*300 )
		return setShootStyle( "full", false );
	
	else if ( distanceSq < 900*900 )
		return setShootStyle( "burst", true );

	if ( self.provideCoveringFire || distanceSq < 1600*1600 )
	{
		if ( shouldDoSemiForVariety() )
			return setShootStyle( "semi", false );
		else
			return setShootStyle( "burst", false );
	}

	return setShootStyle( "single", false );
}

setShootStyleForSuppression()
{
	assert( isdefined( self.shootPos ) );
	
	distanceSq = distanceSquared( self getShootAtPos(), self.shootPos );
	
	if ( weaponIsSemiAuto( self.weapon ) )
	{
		if ( distanceSq < 1600*1600 )
			return setShootStyle( "semi", false );
		return setShootStyle( "single", false );
	}
	
	if ( weaponClass( self.weapon ) == "mg" )
		return setShootStyle( "full", false );
	
	if ( self.provideCoveringFire || distanceSq < 1300*1300 )
	{
		if ( shouldDoSemiForVariety() )
			return setShootStyle( "semi", false );
		else
			return setShootStyle( "burst", false );
	}

	return setShootStyle( "single", false );
}

setShootStyle( style, fastBurst )
{
	self.shootStyle = style;
	self.fastBurst = fastBurst;
}

shouldDoSemiForVariety()
{
	if ( weaponClass( self.weapon ) != "rifle" )
		return false;
	
	if ( self.team != "allies" )
		return false;

	// true randomness isn't safe, because that will cause frequent shoot_behavior_change notifies.
	// fake the randomness in a way that won't change frequently.
	changeFrequency = safemod( int(self.origin[1]), 10000 ) + 2000;
	fakeTimeValue = int(self.origin[0]) + gettime();
	
	return fakeTimeValue % (2*changeFrequency) > changeFrequency;
}
