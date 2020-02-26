#include common_scripts\utility;

#include animscripts\utility;
#include animscripts\shared;


















decideWhatAndHowToShoot( objective )
{
	self endon("killanimscript");
	self notify("stop_deciding_how_to_shoot"); 
	self endon("stop_deciding_how_to_shoot");
	self endon("death");
	
	assert( isdefined( objective ) ); 
	
	self.shootObjective = objective;
	
	
	self.shootEnt = undefined;
	self.shootPos = undefined;
	self.shootStyle = "none";
	self.fastBurst = false;
	self.shouldReturnToCover = false;
	
	if ( !isdefined( self.changingCoverPos ) )
		self.changingCoverPos = false;
	
	if ( self.a.script != "combat" )
	{
		
		
		
		
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
	
	
	if ( !self.a.atConcealmentNode || !self canSeeEnemy() )
		thread watchForIncomingFire();
	thread runOnShootBehaviorEnd();

	self.ambushEndTime = undefined;
	
	prof_begin("decideWhatAndHowToShoot");

	while(1)
	{
		assert( self.shootObjective == "normal" || self.shootObjective == "suppress" || self.shootObjective == "ambush" );
		assert( !isdefined( self.shootEnt ) || isdefined( self.shootPos ) ); 
		
		result = undefined;
		if ( self weaponAnims() == "rocketlauncher" )
			result = rpgShoot();
		else if ( self usingSidearm() )
			result = pistolShoot();
		else if(weaponclass(self.weapon) == "spread")
			result = shotgunshoot();
		else
			result = rifleShoot();
		
		
		if ( checkChanged(prevShootEnt, self.shootEnt) || (!isdefined( self.shootEnt ) && checkChanged(prevShootPos, self.shootPos)) || checkChanged(prevShootStyle, self.shootStyle) )
			self notify("shoot_behavior_change");
		prevShootEnt = self.shootEnt;
		prevShootPos = self.shootPos;
		prevShootStyle = self.shootStyle;
		
		
		
		if ( !isdefined( result ) )
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
		if ( canSeeEnemy() ) 
		{
			self.shootObjective = "normal";
			self.ambushEndTime = undefined;
			return "retry";
		}
		
		markEnemyPosInvisible();
		
		if ( !canSuppressEnemy() )
		{
			
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
					if ( !isdefined( self.shootPos ) || distanceSquared( newShootPos, self.shootPos ) > 5*5 ) 
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
					self.ambushEndTime = undefined;
					if ( randomint(3) == 0 )
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
			
			if ( !isdefined( self.enemy ) )
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
			self.shootStyle = "single";
		}
	}
	else
	{
		if ( canSeeEnemy() ) 
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
		
		
		if ( !isdefined( self.ambushEndTime ) )
			self.ambushEndTime = gettime() + randomintrange(4000, 8000);
			
		if ( self.ambushEndTime < gettime() )
		{
			self.shootObjective = "normal";
			self.ambushEndTime = undefined;
			return "retry";
		}
	}
}

markEnemyPosInvisible()
{
	if ( isdefined( self.enemy ) && !self.changingCoverPos && self.a.script != "combat" )
	{
		
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
	
	self waittill_any( "killanimscript", "stop_deciding_how_to_shoot" );
	
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

	
	
	changeFrequency = safemod( int(self.origin[1]), 10000 ) + 2000;
	fakeTimeValue = int(self.origin[0]) + gettime();
	
	return fakeTimeValue % (2*changeFrequency) > changeFrequency;
}
