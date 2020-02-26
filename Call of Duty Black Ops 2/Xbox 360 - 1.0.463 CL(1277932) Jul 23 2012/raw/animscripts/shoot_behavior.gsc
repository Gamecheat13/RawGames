#include common_scripts\utility;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include maps\_utility;

// Ideally, this will be the only thread *anywhere* that decides what/where to shoot at
// and how to shoot at it.

// This thread keeps three variables updated, and notifies "shoot_behavior_change" when any of them have changed.
// They are:
//  shootEnt - an entity. aim/shoot at this if it's defined.
//  shootPos - a vector. aim/shoot towards this if shootEnt isn't defined. if not defined, stop shooting entirely and return to cover if possible.
//		Whenever shootEnt is defined, shootPos will be defined as its GetShootAtPos().
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
	
	assert( IsDefined( objective ) ); // just use "normal" if you don't know what to use
	
	maps\_gameskill::resetMissTime();
	self.shootObjective = objective;
	// self.shootObjective is always "normal", "suppress", or "ambush"
	
	self.shootEnt = undefined;
	self.shootPos = undefined;
	self.shootStyle = "none";
	self.fastBurst = false;
	self.shouldReturnToCover = false;
	
	if ( !IsDefined( self.changingCoverPos ) )
	{
		self.changingCoverPos = false;
	}

	atCover = IsDefined( self.coverNode ) && self.coverNode.type != "Cover Prone" && self.coverNode.type != "Conceal Prone";
	
	if ( atCover )
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
	
	
	self animscripts\shared::updateLaserStatus( true );
		
	if ( self isSniper() )
	{
		self resetSniperAim( true );
	}
	
	// only watch for incoming fire if it will be beneficial for us to return to cover when shot at.
	if ( atCover && (!self.a.atConcealmentNode || !self canSeeEnemy()) )
	{
		thread watchForIncomingFire();
	}

	thread runOnShootBehaviorEnd();

	self.ambushEndTime = undefined;
	
	while(1)
	{
		assert( self.shootObjective == "normal" || self.shootObjective == "suppress" || self.shootObjective == "ambush" );
		assert( !IsDefined( self.shootEnt ) || IsDefined( self.shootPos ) ); // shootPos must be shootEnt's shootAtPos if shootEnt is defined, for convenience elsewhere
		
		result = undefined;
		if ( self.weapon == "none" )
		{
			noGunShoot();
		}
		else if( !self.a.allow_shooting )
		{
			setShootStyle( "none", false );

			if( IsDefined(self.enemy) )
			{
				setShootEnt( self.enemy );
			}
		}
		else if ( self weaponAnims() == "rocketlauncher" )
		{
			result = rpgShoot();
		}
		else if ( self.weaponclass == "pistol" )
		{
			result = pistolShoot();
		}
		else if(self.weaponclass == "spread")
		{
			result = shotgunshoot();
		}
		else if( self.weaponclass == "gas" ) 
		{
			result = flamethrower_shoot();
		}
		else if( usingGrenadeLauncher() ) 
		{
			result = grenadeShoot();
		}
		else
		{
			result = rifleShoot();
		}
		
		
		if ( checkChanged(prevShootEnt, self.shootEnt) || (!IsDefined( self.shootEnt ) && checkChanged(prevShootPos, self.shootPos)) || checkChanged(prevShootStyle, self.shootStyle) )
		{
			self notify("shoot_behavior_change");
		}

		prevShootEnt = self.shootEnt;
		prevShootPos = self.shootPos;
		prevShootStyle = self.shootStyle;
		
		// (trying to prevent many AI from doing lots of work on the same frame)
		if ( !IsDefined( result ) )
		{
			WaitABit();
		}
	}
	
}	

WaitABit()
{
	self endon("enemy");
	self endon("done_changing_cover_pos");
	self endon("weapon_position_change");
	self endon("enemy_visible");
	
	if ( IsDefined( self.shootEnt ) )
	{
		self.shootEnt endon("death");
		
		self endon("do_slow_things");
		
		// (want to keep self.shootPos up to date)
		wait .05;
		while( IsDefined( self.shootEnt ) )
		{
			self.shootPos = self.shootEnt GetShootAtPos();
			wait .05;
		}
	}
	else
	{
		self waittill("do_slow_things");
	}
}

noGunShoot()
{
	/#
		println( "^1Warning: AI at " + self.origin + ", entnum " + self getEntNum() + ", export " + self.export + " trying to shoot but has no gun" );
	#/

	self.shootEnt = undefined;
	self.shootPos = undefined;
	self.shootStyle = "none";
	self.shootObjective = "normal";
}

shouldSuppress()
{
	return !self isSniper() && !weapon_spread();
}

rifleShoot()
{
	if ( self.shootObjective == "normal" )
	{
		if ( !canSeeEnemy() )
		{
			// enemy disappeared!
			if ( self isSniper() )
				self resetSniperAim();
			
			if ( !IsDefined( self.enemy ) )
			{
				haveNothingToShoot();
			}
			else
			{
				markEnemyPosInvisible();

				if ( (self.provideCoveringFire || RandomInt(5) > 0) && shouldSuppress() )
					self.shootObjective = "suppress";
				else
					self.shootObjective = "ambush";
				
				return "retry";
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
			return "retry";
		}
		
		markEnemyPosInvisible();
		
		if ( self isSniper() )
			self resetSniperAim();
				
		if ( !canSuppressEnemy() )
		{
			// no idea where the enemy is, so we can only ambush a valid enemy
			if ( self.shootObjective == "suppress" || (self.team == "allies" && !isValidEnemy( self.enemy )) )
			{
				haveNothingToShoot();
			}
			else
			{
				assert( self.shootObjective == "ambush" );
				
				self.shootStyle = "none";
				
				likelyEnemyDir = self getAnglesToLikelyEnemyPath();
				if ( !IsDefined( likelyEnemyDir ) )
				{
					if ( IsDefined( self.coverNode ) )
					{
						likelyEnemyDir = self.coverNode.angles;
					}
					else
					{
						likelyEnemyDir = self.angles;
					}
				}

				self.shootEnt = undefined;

				dist = 1024;
				if ( IsDefined( self.enemy ) )
				{
					dist = distance( self.origin, self.enemy.origin );
				}

				newShootPos = self getEye() + AnglesToForward( likelyEnemyDir ) * dist;
				if ( !IsDefined( self.shootPos ) || DistanceSquared( newShootPos, self.shootPos ) > 5*5 ) // avoid frequent "shoot_behavior_change" notifies
				{
					self.shootPos = newShootPos;
				}

				if ( shouldStopAmbushing() )
				{
					self.ambushEndTime = undefined;
					self notify("return_to_cover");
					self.shouldReturnToCover = true;
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
					if ( shouldSuppress() )
					{
						self.shootObjective = "suppress";
					}

					self.ambushEndTime = undefined;
					if ( RandomInt(3) == 0 )
					{
						self notify("return_to_cover");
						self.shouldReturnToCover = true;
					}

					return "retry";
				}
			}
		}
	}
}

shouldStopAmbushing()
{
	if ( !IsDefined( self.ambushEndTime ) )
	{
		if ( self.team == "allies" )
			self.ambushEndTime = GetTime() + randomintrange( 4000, 10000 );
		else
			self.ambushEndTime = GetTime() + randomintrange( 40000, 60000 );	
	}

	return self.ambushEndTime < GetTime();
}

rpgShootExplodable()
{
	self endon("death");

	enemy = self.enemy;
	weapon = self.weapon;

	assert( IsDefined(enemy) );
	assert( IsDefined(enemy._explodable_targets) );

	target = undefined;
	if (enemy._explodable_targets.size > 0)
	{
		for (i = 0; i < enemy._explodable_targets.size; i++)
		{
			// only target something if we can actually see it
			target = enemy._explodable_targets[i];
			if (IsDefined(target) && self CanSee(target))
			{
				self SetEntityTarget(target);
			}
		}
	}

	if (IsDefined(target))
	{
		while (IsDefined(target) && IsAlive(enemy) && (self.weapon == weapon))
		{
			wait( 0.05 );
		}

		self ClearEntityTarget();
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
	
	// shoot the explodable target instead of the enemy
	if (IsDefined(self.enemy) && IsDefined(self.enemy._explodable_targets))
		self thread rpgShootExplodable();
	
	setShootEnt( self.enemy );
	self.shootStyle = "single";

	distSqToShootPos = lengthsquared( self.origin - self.shootPos );

	// too close for RPG
	if( distSqToShootPos < ( 512*512 ) )
	{
		self notify("return_to_cover");
		self.shouldReturnToCover = true;
		return;
	}
}

grenadeShoot()
{
	if ( !canSeeEnemy() )
	{
		markEnemyPosInvisible();
		
		haveNothingToShoot();
		return;
	}

	setShootEnt( self.enemy );

	if( self.bulletsInClip > 1 )
	{
		self.shootStyle = "burst";
	}
	else
	{
		self.shootStyle = "single";
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

// MikeD (9/19/2007): Handles the flamethrower guys for when they fire their weapon.
flamethrower_shoot()
{
	if ( !canSeeEnemy() )
	{
		haveNothingToShoot();
		return;
	}
	
	setShootEnt( self.enemy );
	self.shootStyle = "full";
}

pistolShoot()
{
	if ( self.shootObjective == "normal" )
	{
		if ( !canSeeEnemy() )
		{
			// enemy disappeared!
			if ( !IsDefined( self.enemy ) )
			{
				haveNothingToShoot();
				return;
			}
			else
			{
				markEnemyPosInvisible();
				
				self.shootObjective = "ambush";
				return "retry";
			}
		}
		else
		{
			setShootEnt( self.enemy );

			self.shootStyle = "semi";
		}
	}
	else
	{
		if ( canSeeEnemy() ) // later, maybe we can be more realistic than just shooting at the enemy the instant he becomes visible
		{
			self.shootObjective = "normal";
			self.ambushEndTime = undefined;
			return "retry";
		}
		
		markEnemyPosInvisible();
		
		if ( canSuppressEnemy() )
		{
			self.shootEnt = undefined;
			self.shootPos = getEnemySightPos();
		}
		
		self.shootStyle = "none";
		
		// stop ambushing after a while
		if ( !IsDefined( self.ambushEndTime ) )
		{
			self.ambushEndTime = GetTime() + randomintrange(4000, 8000);
		}
			
		if ( self.ambushEndTime < GetTime() )
		{
			self.shootObjective = "normal";
			self.ambushEndTime = undefined;
			return "retry";
		}
	}
}

markEnemyPosInvisible()
{
	if ( IsDefined( self.enemy ) && !self.changingCoverPos && self.a.script != "combat" )
	{
		// make sure they're not just hiding
		if ( isAI( self.enemy ) && IsDefined( self.enemy.a.script ) && (self.enemy.a.script == "cover_stand" || self.enemy.a.script == "cover_crouch") )
		{
			if ( IsDefined( self.enemy.a.coverMode ) && self.enemy.a.coverMode == "Hide" )
			{
				return;
			}
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
			if ( self readyToReturnToCover() )
			{
				self notify("return_to_cover");
				self.shouldReturnToCover = true;
			}
		}
	}
}

readyToReturnToCover()
{
	if ( self.changingCoverPos )
	{
		return false;
	}

	if( IsDefined( self.isRamboing ) && self.isRamboing )
	{
		return false;
	}

	assert( IsDefined( self.coverPosEstablishedTime ) );
	
	if ( !isValidEnemy( self.enemy ) || !self canSee( self.enemy ) )
	{
		return true;
	}
	
	if ( GetTime() < self.coverPosEstablishedTime + 800 )
	{
		// don't return to cover until we had time to fire a couple shots;
		// better to look daring than indecisive
		return false;
	}
	
	if ( IsPlayer( self.enemy ) && self.enemy.health < self.enemy.maxHealth * .5 )
	{
		// give ourselves some time to take them down
		if ( GetTime() < self.coverPosEstablishedTime + 3000 )
		{
			return false;
		}
	}
	
	return true;
}

runOnShootBehaviorEnd()
{
	self endon ( "death" );
	
	self waittill_any( "killanimscript", "stop_deciding_how_to_shoot", "return_to_cover" );
		
	self animscripts\shared::updateLaserStatus( false );
}

checkChanged( prevval, newval )
{
	if ( IsDefined( prevval ) != IsDefined( newval ) )
	{
		return true;
	}

	if ( !IsDefined( newval ) )
	{
		assert( !IsDefined( prevval ) );
		return false;
	}

	return prevval != newval;
}

setShootEnt( ent )
{
	if (!isDefined(ent) )
		return;
	self.shootEnt = ent;
	self.shootPos = self.shootEnt GetShootAtPos(); // ALEXP_TODO: it would be nice if the AI also aimed at the targetTag
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

shootingPlayerAtHigherDifficulty()
{
	return level.gameskill == 3 && IsPlayer( self.enemy );
}

setShootStyleForVisibleEnemy()
{
	assert( IsDefined( self.shootPos ) );
	assert( IsDefined( self.shootEnt ) );
	
	if ( IsDefined( self.shootEnt.enemy ) && IsDefined( self.shootEnt.enemy.syncedMeleeTarget ) )
	{
		return setShootStyle( "single", false );
	}
	
	if ( self isSniper() || self weapon_spread() )
	{
		return setShootStyle( "single", false );
	}

	distanceSq = DistanceSquared( self GetShootAtPos(), self.shootPos );
	
	if ( weaponIsSemiAuto( self.weapon ) )
	{
		if ( distanceSq < 1600*1600 || shootingPlayerAtHigherDifficulty() )
		{
			return setShootStyle( "semi", false );
		}

		return setShootStyle( "single", false );
	}
		
	if ( self.weaponclass == "mg" )
	{
		return setShootStyle( "full", false );
	}

	if ( distanceSq < 300*300 )
	{
		if ( IsDefined( self.shootEnt ) && IsDefined( self.shootEnt.magic_bullet_shield ) )
		{
			return setShootStyle( "single", false );
		}
		else
		{
			return setShootStyle( "full", false );
		}
	}
	else if ( distanceSq < 900*900 || shootingPlayerAtHigherDifficulty() )
	{
		return setShootStyle( "burst", true );
	}
	if ( self.provideCoveringFire || distanceSq < 1600*1600 )
	{
		if ( shouldDoSemiForVariety() )
		{
			return setShootStyle( "semi", false );
		}
		else
		{
			return setShootStyle( "burst", false );
		}
	}

	return setShootStyle( "single", false );
}

setShootStyleForSuppression()
{
	assert( IsDefined( self.shootPos ) );
	
	distanceSq = DistanceSquared( self GetShootAtPos(), self.shootPos );

	assert( !self isSniper() ); 	 // snipers shouldn't be suppressing!
	assert( !self weapon_spread() ); // shotgun users shouldn't be suppressing!
	
	if ( weaponIsSemiAuto( self.weapon ) )
	{
		if ( distanceSq < 1600*1600 )
			return setShootStyle( "semi", false );
		
		return setShootStyle( "single", false );
	}
	
	if ( self.weaponclass == "mg" )

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
	if ( self.weaponclass != "rifle" )
	
	const SHOOT_SEMIFORVARIETY_CHANCE 		  = 50;
	const SHOOT_SEMIFORVARIETY_TIME_INTERVAL  = 10000;
		return false;
		
	if(!IsDefined(self.semiForVarietycheck))
		self.semiForVarietycheck = 0; 
		
	time = GetTime();
	
	if ( time < self.semiForVarietycheck )
		return false;
		
	if ( RandomInt(100) < SHOOT_SEMIFORVARIETY_CHANCE )
		doSemi = true;
	else
		doSemi = false;
		
	self.semiForVarietycheck = time + SHOOT_SEMIFORVARIETY_TIME_INTERVAL;
	
	return doSemi;
}

resetSniperAim( considerMissing )
{
	assert( self isSniper() );
	self.sniperShotCount = 0;
	self.sniperHitCount = 0;
	
	if ( IsDefined( considerMissing ) )
		self.lastMissedEnemy = undefined;
}

showSniperGlint()
{
	if( !self isSniper() )
		return;
	
	const MINIMUM_DISTANCE_FOR_SNIPER_GLINT_SQ = 256 * 256;
	
	if ( IS_TRUE( self.disable_sniper_glint ) )
		return;
	
	if( !IsDefined(self.enemy) )
		return;
	
	if( self.team == "allies" )
		return;
		
	if( !IsDefined( level._effect[ "sniper_glint" ] ) )
	{
		///#println( "^3Warning, sniper glint is not setup for sniper with classname " + self.classname );#/
		return;
	}
					
	if ( DistanceSquared( self.origin, self.enemy.origin ) > MINIMUM_DISTANCE_FOR_SNIPER_GLINT_SQ )
		PlayFXOnTag( level._effect[ "sniper_glint" ], self, "tag_flash" );
}

