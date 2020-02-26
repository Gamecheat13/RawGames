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
	self.shootStyle = undefined;
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
		
		
		wasChangingCoverPos = self.changingCoverPos;

		// (trying to prevent many AI from doing lots of work on the same frame)
		numframes = randomint(3) + 1;
		wait .05;
		for ( i = 1; i < numframes; i++ )
		{
			// keep self.shootPos up to date
			if ( isdefined( self.shootEnt ) )
				self.shootPos = self.shootEnt getShootAtPos();
			
			if ( wasChangingCoverPos && !self.changingCoverPos )
				break;
			
			wait .05;
		}
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

				if ( randomint(5) > 0 )
					self.shootObjective = "suppress";
				else
					self.shootObjective = "ambush";
				return;
			}
		}
		else
		{
			setShootEnt( self.enemy );
			self.shootStyle = getShootStyleForVisibleEnemy();
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
			// no idea where the enemy is, so there's nothing to do
			haveNothingToShoot();
		}
		else
		{
			self.shootEnt = undefined;
			self.shootPos = getEnemySightPos();
			
			if ( self.shootObjective == "suppress" )
			{
				self.shootStyle = getShootStyleForSuppression();
			}
			else
			{
				assert( self.shootObjective == "ambush" );
				self.shootStyle = "none";
				
				// stop ambushing after a while
				if ( !isdefined( self.ambushEndTime ) )
					self.ambushEndTime = gettime() + randomintrange(4000, 8000);
				if ( self.ambushEndTime < gettime() )
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
		
		if ( self.goodShootPosValid )
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
		self.couldntSeeEnemyPos = self.enemy.origin;
}

watchForIncomingFire()
{
	self endon("killanimscript");
	self endon("stop_deciding_how_to_shoot");
	
	while(1)
	{
		self waittill("suppression");
		
		self notify("return_to_cover");
		self.shouldReturnToCover = true;
	}
}


runOnShootBehaviorEnd()
{
	self endon ( "death" );
	
	self maps\_utility::waittill_any( "killanimscript", "stop_deciding_how_to_shoot"/*, "return_to_cover"*/ );
	
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

getShootStyleForVisibleEnemy()
{
	assert( isdefined( self.shootPos ) );
	
	distanceSq = distanceSquared( self getShootAtPos(), self.shootPos );

	if ( weaponIsSemiAuto( self.weapon ) )
	{
		if ( distanceSq < 1600*1600 )
			return "semi";
		return "single";
	}
		
	if ( weaponClass( self.weapon ) == "mg" )
		return "full";

	if ( distanceSq < 900*900 )
		return "full";
		
	if ( distanceSq < 1600*1600 )
	{
		if ( shouldDoSemiForVariety() )
			return "semi";
		else
			return "burst";
	}

	return "single";
}

getShootStyleForSuppression()
{
	assert( isdefined( self.shootPos ) );
	
	distanceSq = distanceSquared( self getShootAtPos(), self.shootPos );
	
	if ( weaponIsSemiAuto( self.weapon ) )
	{
		if ( distanceSq < 1600*1600 )
			return "semi";
		return "single";
	}
	
	if ( weaponClass( self.weapon ) == "mg" )
		return "full";
		
	if ( distanceSq < 1300*1300 )
	{
		if ( shouldDoSemiForVariety() )
			return "semi";
		else
			return "burst";
	}

	return "single";
}

shouldDoSemiForVariety()
{
	if ( weaponClass( self.weapon ) != "rifle" )
		return false;
	
	if ( self.team != "allies" )
		return false;

	// true randomness isn't safe, because that will cause frequent shoot_behavior_change notifies.
	// fake the randomness in a way that won't change frequently.
	changeFrequency = int(self.origin[1]) % 10000 + 2000;
	fakeTimeValue = int(self.origin[0]) + gettime();
	
	return fakeTimeValue % (2*changeFrequency) > changeFrequency;
}