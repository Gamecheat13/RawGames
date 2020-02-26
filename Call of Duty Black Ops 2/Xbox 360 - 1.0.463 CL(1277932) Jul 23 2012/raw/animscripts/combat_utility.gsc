#include animscripts\Utility;
#include animscripts\Debug;
#include animscripts\SetPoseMovement;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_gameskill;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

#using_animtree ("generic_human");

player_init() 
{
}

EnemiesWithinStandingRange()
{
	enemyDistanceSq = self MyGetEnemySqDist();
	return ( enemyDistanceSq < anim.standRangeSq );
}

MyGetEnemySqDist()
{
	//prof_begin( "MyGetEnemySqDist" );
    dist = self GetClosestEnemySqDist();
	if (!IsDefined(dist))
	{
		dist = 100000000000;
	}
		
	//prof_end( "MyGetEnemySqDist" );
    return dist;
}


getTargetAngleOffset(target)
{
	pos = self GetShootAtPos() + (0,0,-3); // compensate for eye being higher than gun
	dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
	dir = VectorNormalize( dir );
	fact = dir[2] * -1;
//	println ("offset "  + fact);
	return fact;
}

getSniperBurstDelayTime()
{
	return RandomFloatRange( anim.min_sniper_burst_delay_time, anim.max_sniper_burst_delay_time );
}

getRemainingBurstDelayTime()
{
	timeSoFar = (GetTime() - self.a.lastShootTime) / 1000;
	delayTime = getBurstDelayTime();

	if ( delayTime > timeSoFar )
	{
		return delayTime - timeSoFar;
	}

	return 0;
}

getBurstDelayTime()
{
	if ( self.weapon==self.sidearm )
	{
		return RandomFloatRange( .15, .55 );
	}
	else if ( self usingShotgun() )
	{
		return RandomFloatRange( 1.0, 1.7 );
	}
	else if ( self isSniper() )
	{
		return getSniperBurstDelayTime();
	}
	else if ( self.fastBurst )
	{
		return RandomFloatRange( .1, .35 );
	}
	else if ( self usingGrenadeLauncher() )
	{
		return RandomFloatRange( 1.5, 2.0 );
	}
	else if ( is_rusher() && self.rusherType == "pistol" )
	{
		return RandomFloatRange( .1, .3 );
	}
	else
	{
		return RandomFloatRange( .4, .9 );
	}
}

burstDelay()
{
	if ( self.bulletsInClip )
	{
		if ( self.shootStyle == "full" && !self.fastBurst )
		{
			if ( self.a.lastShootTime == GetTime() )
			{
				wait .05;
			}

			return;
		}

		delayTime = getRemainingBurstDelayTime();
		if ( delayTime )
		{
			wait delayTime;
		}
	}
}

cheatAmmoIfNecessary()
{
	assert( !self.bulletsInClip );
	
	/#
		if( shouldForceBehavior( "force_cheat_ammo" ) )
		{
			self.bulletsInClip = 10;
			
			if ( self.bulletsInClip > weaponClipSize( self.weapon ) )
				self.bulletsInClip = weaponClipSize( self.weapon );
			
			return true;
		}
			
	#/		
	
	if( animscripts\run::ShouldTacticalWalk() )
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
			return true;
	}

	if( self is_rusher() )
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
		return true;
	}
	
	
	return false;
}

stopFiringOnShootBehaviorChange()
{
	self waittill_any( "shoot_burst_done", "shoot_behavior_change", "stopShooting", "killanimscript", "need_to_turn" );
	
	if( IsDefined( self ) )
		self StopShoot();
}

shootUntilShootBehaviorChange()
{
	self endon("shoot_behavior_change");
	self endon("stopShooting");

	self thread stopFiringOnShootBehaviorChange();

	/#
	self animscripts\debug::debugPopState( "shootUntilShootBehaviorChange", "was interrupted" );
	self animscripts\debug::debugPushState( "shootUntilShootBehaviorChange", "shootStyle: " + self.shootStyle );
	#/
	
	if ( self weaponAnims() == "rocketlauncher" || self isSniper() )
	{
		players = GetPlayers();

		if ( self weaponAnims() == "rocketlauncher" && IsSentient( self.enemy ) )
			wait ( RandomFloat( 2.0 ) );
	}

	if ( IsDefined(self.enemy) && DistanceSquared(self.origin, self.enemy.origin) > 400*400 )
		burstCount = RandomIntRange( 1, 5 );
	else
		burstCount = 10;
	
	while(1)
	{
		burstDelay(); // waits only if necessary

		/#
		self animscripts\debug::debugPopState( "FireUntilOutOfAmmo" );
		#/

		animPrefix	= getShootAnimPrefix();

		if ( self.shootStyle == "full" )
		{
			self FireUntilOutOfAmmo( animArray( animPrefix + "fire" ), true, animscripts\shared::decideNumShotsForFull() );
		}
		else if ( self.shootStyle == "burst" || self.shootStyle == "single" || self.shootStyle == "semi" )
		{
			numShots = 1;
			if ( self.shootStyle == "burst" || self.shootStyle == "semi" )
			{
				numShots = animscripts\shared::decideNumShotsForBurst();	
			}

			if ( numShots == 1 )
			{
				self FireUntilOutOfAmmo( animArrayPickRandom( animPrefix + "single" ), true, numShots );
			}
			else
			{
				self FireUntilOutOfAmmo( animArray( animPrefix + self.shootStyle + numShots ), true, numShots );
			}
		}
		else
		{
			assert( self.shootStyle == "none" );
			self waittill( "hell freezes over" ); // waits for the endons to happen
		}

		if ( !self.bulletsInClip )
		{
			break;
		}
		
		if( animscripts\shared::shouldSwitchWeapons() )
		{
			self notify("need_to_switch_weapons");
			break;
		}

		burstCount--;
		if ( burstCount < 0 )
		{
			self.shouldReturnToCover = true;
			break;
		}
	}

	self notify( "shoot_burst_done" );

	/#
	self animscripts\debug::debugPopState( "shootUntilShootBehaviorChange" );
	#/
}

getUniqueFlagNameIndex()
{
	anim.animFlagNameIndex++;
	return anim.animFlagNameIndex;
}

FireUntilOutOfAmmo( fireAnim, stopOnAnimationEnd, maxshots )
{		
	/#
	self animscripts\debug::debugPushState( "FireUntilOutOfAmmo", self.shootStyle + " (" + maxshots + " of " + self.bulletsInClip + ")" );
	#/

	animName = "fireAnim_" + getUniqueFlagNameIndex();

	// reset our accuracy as we aim
	maps\_gameskill::resetMissTime();

	// first, wait until we're aimed right
	while( !aimedAtShootEntOrPos() )
	{
		wait .05;
	}

	// here AI starts shooting a volly or a single shot based on the weapon
	self StartShoot();

	self SetAnim( %add_fire, 1, .1, 1 );
	
	// CCheng (7/28/2008): Given that fire notetracks are currently spaced every 3 frames @ 30fps, 
	// a rate of 2 or more is faster than we're currently running server scripts like this one,
	// which is at 20 fps. So I lowered the upper bound on the rate from 3.0 to 2.0.
	rate = RandomFloatRange( 0.3, 2.0 ); 
	
	if ( self.shootStyle == "full" || self.shootStyle == "burst" )
	{
		rate = animscripts\weaponList::autoShootAnimRate();
		if ( rate > 1.999 )
		{
			rate = 1.999; // This corresponds to one shot per server frame - any higher and we're throwing away shots.
		}
	}
	else if ( IsDefined( self.shootEnt ) && IsDefined( self.shootEnt.magic_bullet_shield ) )
	{
		rate = 0.25;
	}
	else if( is_rusher() && self.rusherType == "pistol" )
	{
		rate = 2.0;
	}
	
	if ( weaponIsGasWeapon( self.weapon ) ) 
	{
		rate = 1.0;
	}
	else if ( self usingShotgun() ) // ALEXP_MOD (8/19/09): Shotgun fire rate should be constant
	{
		rate = 1.0;
	}
	else if ( self usingRocketLauncher() ) // ALEXP_MOD (7/8/10): Rpg fire rate should be constant
	{
		rate = 1.0;
	}
		
	self SetFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, rate );
	
	// Update the sight accuracy against the player.  Should be called before the volley starts.
	self updatePlayerSightAccuracy();

	
	FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots );
	
	self ClearAnim( %add_fire, .2 );

	// debugPopState is called in shootUntilShootBehaviorChange
}

FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots )
{
	self endon("enemy"); // stop shooting if our enemy changes, because we have to reset our accuracy and stuff
	// stop shooting if the player becomes invulnerable, so we will call resetAccuracyAndPause again
	if ( IsPlayer( self.enemy ) && (self.shootStyle == "full" || self.shootStyle == "semi") )
	{
		level endon("player_becoming_invulnerable");
	}

	if ( stopOnAnimationEnd )
	{
		self thread NotifyOnAnimEnd( animName, "fireAnimEnd" );
		self endon( "fireAnimEnd" );
	}
	
	if ( !IsDefined( maxshots ) )
	{
		maxshots = -1;
	}
	
	numshots = 0;
	
	hasFireNotetrack	= animHasNoteTrack( fireAnim, "fire" );
	usingRocketLauncher = (self.weaponclass == "rocketlauncher");
	
	while(1)
	{
		// BOLT ACTION note:
		// if notetrack and using a boltaction and it's the first time through, do this
		// otgherwise return out - should only go through this loop once
		if ( hasFireNotetrack )
		{
			self waittillmatch( animName, "fire" );
		}
				
		if ( numshots == maxshots ) // note: maxshots == -1 if no limit
		{
			break;
		}

		if ( !self.bulletsInClip )
		{
			if ( !cheatAmmoIfNecessary() )
			{
				break;
			}
		}

		if ( aimedAtShootEntOrPos() && GetTime() > self.a.lastShootTime )
		{
			self shootAtShootEntOrPos();

			assert( self.bulletsInClip >= 0, self.bulletsInClip );
			if ( IsPlayer( self.enemy ) && flag("player_is_invulnerable") )
			{
				if ( RandomInt(3) == 0 )
				{
					self.bulletsInClip--;
				}
			}
			else
			{
				self.bulletsInClip--;
			}

			if ( usingRocketLauncher )
			{
				self.a.rockets--;
				if ( !IsSubStr(self.weapon, "us") && IsSubStr(self.weapon, "rpg") )
				{
					self hidepart("tag_rocket");
					self.a.rocketVisible = false;
				}
			}

			// grenade launchers have to reload
			if ( usingGrenadeLauncher() )
			{
				self.bulletsInClip = 0;
			}
		}

		numshots++;

		self thread shotgunPumpSound( animName );

		if ( self.fastBurst && numshots == maxshots )
		{
			break;
		}

		
		if ( !hasFireNotetrack )
		{
			self waittillmatch( animName, "end" );
		}
	}

	if ( stopOnAnimationEnd )
	{
		self notify( "fireAnimEnd" ); // stops NotifyOnAnimEnd()
	}
}

aimedAtShootEntOrPos()
{
	tag_weapon = self gettagorigin("tag_weapon");
	if ( !IsDefined(tag_weapon) )
	{
		return false;
	}
	if ( !IsDefined( self.shootPos ) )
	{
		assert( !IsDefined( self.shootEnt ) );
		
		return true;
	}
	
	weaponAngles = self GetTagAngles("tag_weapon");
	anglesToShootPos = VectorToAngles( self.shootPos - tag_weapon );

	/#
	//	weaponForward = AnglesToForward( weaponAngles );
	//	recordLine( self getTagOrigin("tag_weapon") + VectorScale(weaponForward, 50), self getTagOrigin("tag_weapon"), level.color_debug["red"], "Animscript", self );
	//	recordLine( self.shootPos, self getTagOrigin("tag_weapon"), level.color_debug["green"], "Animscript", self );
	#/
	
	absyawdiff = AbsAngleClamp180( weaponAngles[1] - anglesToShootPos[1] );
	if ( absyawdiff > self.aimThresholdYaw )
	{
		if ( DistanceSquared( self GetShootAtPos(), self.shootPos ) > 64*64 || absyawdiff > 45 )
		{
			return false;
		}
	}
	
	return AbsAngleClamp180( weaponAngles[0] - anglesToShootPos[0] ) <= self.aimThresholdPitch;
}

NotifyOnAnimEnd( animNotify, endNotify )
{
	self endon("killanimscript");
	self endon( endNotify );
	
	self waittillmatch( animNotify, "end" );
	
	self notify( endNotify );
}

shootAtShootEntOrPos()
{
	// If self.shoot_notify is set, then send it out as a notify.
	if( IsDefined( self.shoot_notify ) )
		self notify( self.shoot_notify );
	
	if ( IsDefined( self.shootEnt ) )
	{
		if ( IsDefined( self.enemy ) && self.shootEnt == self.enemy )
		{
			//println( "shootAtShootEntOrPos calling shootEnemyWrapper(): Entity " + self getEntityNumber() + " shooting with " + self.weapon + " at time " + GetTime() );
			self shootEnemyWrapper();
		}
		
		// it's possible that shootEnt isn't our enemy, which was probably caused by our enemy changing but shootEnt not being updated yet.
		// we don't want to shoot directly at shootEnt because if our accuracy is 0 we shouldn't hit it perfectly.
		// In retrospect, the existance of self.shootEnt was a bad idea and self.enemy should probably have just been used.
		//else
		//	self shootPosWrapper( self.shootEnt GetShootAtPos() );
	}
	else
	{
		// if self.shootPos isn't defined, "shoot_behavior_change" should
		// have been notified and we shouldn't be firing anymore
		assert( IsDefined( self.shootPos ) );
		
		self shootPosWrapper( self.shootPos );
	}

}	

showRocket()
{
	if ( !IsSubStr(self.weapon, "us") && IsSubStr(self.weapon, "rpg") )
	{
		self.a.rocketVisible = true;
		self showpart("tag_rocket");
		self notify("showing_rocket");
	}
}

showRocketWhenReloadIsDone()
{
	if ( self.weapon != "rpg" )
	{
		return;
	}

	self endon("death");
	self endon("showing_rocket");
	self waittill("killanimscript");
	
	self showRocket();
}

decrementBulletsInClip()
{
	// we allow this to happen even when bulletsinclip is zero,
	// because sometimes we want to shoot even if we're out of ammo,
	// like when we've already started a blind fire animation.

	if ( self.bulletsInClip )
	{
		self.bulletsInClip--;
	}
}

shotgunPumpSound( animName )
{
	if ( !self usingShotgun() )
	{
		return;
	}
	
	self endon("killanimscript");
	
	self notify("shotgun_pump_sound_end");
	self endon("shotgun_pump_sound_end");
	
	self thread stopShotgunPumpAfterTime( 2.0 );
	
	self waittillmatch( animName, "rechamber" );
	
	self PlaySound( "wpn_shotgun_pump" );
	
	self notify("shotgun_pump_sound_end");
}

stopShotgunPumpAfterTime( timer )
{
	self endon("killanimscript");
	self endon("shotgun_pump_sound_end");

	wait timer;
	self notify("shotgun_pump_sound_end");
}

// Returns true if character has less than thresholdFraction of his total bullets in his clip.  Thus, a value 
// of 1 would always reload, 0 would only reload on an empty clip.
NeedToReload( thresholdFraction )
{
	/#
	if( shouldForceBehavior("reload") )
		return true;
	#/

	if ( IsDefined( self.noreload ) )
	{
		assert( self.noreload, ".noreload must be true or undefined" );
		if ( self.bulletsinclip < weaponClipSize( self.weapon ) * 0.5 )
		{
			self.bulletsinclip = int( weaponClipSize( self.weapon ) * 0.5 );
		}

		return false;
	}

	if ( self.weapon == "none" )
		return false;
		
	if ( self.bulletsInClip <= weaponClipSize( self.weapon ) * thresholdFraction )
	{
		if ( thresholdFraction == 0 )
		{
			if ( cheatAmmoIfNecessary() )
				return false;
		}
		
		return true;
	}

	return false;
}

// Put the gun back in the AI's hand if he cuts off his weapon throw down animation
putGunBackInHandOnKillAnimScript()
{
	self endon ( "weapon_switch_done" );
	self endon ( "death" );
	
	self notify( "put gun back in hand end unique" );
	self endon( "put gun back in hand end unique" );
	
	self waittill( "killanimscript" );
	
	animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
}

Reload( thresholdFraction, optionalAnimation )
{
	if( weaponIsGasWeapon( self.weapon ) )
		return flamethrower_reload();
		
	self endon("killanimscript");

	if ( !NeedToReload( thresholdFraction ) )
		return false;
	
	self maps\_dds::dds_notify_reload( undefined, ( self.team == "allies" ) );

	if ( IsDefined( optionalAnimation ) )
	{
		self ClearAnim( %body, .1 );
		self SetFlaggedAnimKnobAll( "reloadanim", optionalAnimation, %body, 1, .1, 1 );
		animscripts\shared::DoNoteTracks( "reloadanim" );
		self animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in theory.
	}
	else
	{
		if (self.a.pose == "prone")
		{
			self SetFlaggedAnimKnobAll("reloadanim", animArrayPickRandom("reload"), %body, 1, .1, 1);
			self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.1, 1);
		}
		else 
		{
			/#println ("Bad anim_pose in combat::Reload");#/
			wait 2;
			return;
		}
		animscripts\shared::DoNoteTracks("reloadanim");
		animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in most instances.
		self ClearAnim(%upperbody, .1);		// Only needed for the upper body running reload.
	}

	return true;
}

// MikeD (10/9/2007): Flamethrower Reload function
flamethrower_reload()
{
	wait( 0.05 ); // This is needed, since it seems that reload have a wait (for animation) in them in anyway.
	self animscripts\weaponList::RefillClip();
	return true;
}

// AI_TODO - Why cant we automate this thing?
getGrenadeThrowOffset( throwAnim )
{
	assert( IsDefined( anim.grenadeThrowOffsets ) );
	assert( IsDefined( anim.grenadeThrowOffsets[ throwAnim ] ), "Grenade throwing anim " + throwAnim + " has no grenade offset defined. Add to precache_grenade_offsets()" );

	if( IsDefined( anim.grenadeThrowOffsets[ throwAnim ] ) )
	   return anim.grenadeThrowOffsets[ throwAnim ];
	   
	return( 0, 0, 64 );
}

// this function is called from maps\_utility::ThrowGrenadeAtPlayerASAP
ThrowGrenadeAtPlayerASAP_combat_utility()
{
	if ( anim.numGrenadesInProgressTowardsPlayer == 0 )
	{
		anim.grenadeTimers["player_frag_grenade_sp"] = 0;
		anim.grenadeTimers["player_flash_grenade_sp"] = 0;
	}

	anim.throwGrenadeAtPlayerASAP = true;
	
	/#
	enemies = GetAIArray("axis", "team3" );
	if ( enemies.size == 0 )
	{
		return;
	}

	for ( i = 0; i < enemies.size; i++ )
	{
		if ( enemies[i].grenadeammo > 0 )
		{
			return;
		}
	}
	println("^1Warning: called ThrowGrenadeAtPlayerASAP, but no enemies have any grenadeammo!");
	#/
}

setActiveGrenadeTimer( throwingAt )
{
	if ( IsPlayer( throwingAt ) )
	{
		self.activeGrenadeTimer = "player_" + self.grenadeWeapon;
	}
	else
	{
		self.activeGrenadeTimer = "AI_" + self.grenadeWeapon;
	}
	
	// CODER_MOD - JamesS - need to update grenade system for coop
	//assert( IsDefined( anim.grenadeTimers[self.activeGrenadeTimer] ) );
	if( !IsDefined(anim.grenadeTimers[self.activeGrenadeTimer]) )
	{
		anim.grenadeTimers[self.activeGrenadeTimer] = randomIntRange( 1000, 20000 );
	}
}

considerChangingTarget( throwingAt )
{
	//TODO -- Glocke: 3/19/2009 -- This needs to be modified to actually support co-op
	
	if ( !IsPlayer( throwingAt ) && self.team == "axis" || self.team == "team3" )
	{
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			if ( GetTime() < anim.grenadeTimers[self.activeGrenadeTimer] )
			{
				if ( player IsNoTarget() )
				{
					return throwingAt;
				}
					
				// check if player threatbias is set to be ignored by self
				myGroup = self getthreatbiasgroup();
				playerGroup = player getthreatbiasgroup();
				
				if ( myGroup != "" && playerGroup != "" && getThreatBias( playerGroup, myGroup ) < -10000 )
				{
					return throwingAt;
				}
				
				
				// can't throw at an AI right now anyway.
				// check if the player is an acceptable target (be careful not to be aware of him when we wouldn't know about him)
				if ( self canSee( player ) || (isAI( throwingAt ) && throwingAt canSee( player )) )
				{
					if ( IsDefined( self.covernode ) )
					{
						angles = VectorToAngles( player.origin - self.origin );
						yawDiff =  AngleClamp180( self.covernode.angles[1] - angles[1] );
					}
					else
					{
						yawDiff = self GetYawToSpot( player.origin );
					}
					
					if ( abs( yawDiff ) < 60 )
					{
						throwingAt = player;
						self setActiveGrenadeTimer( throwingAt );
					}
				}
			}
		}
	}
	
	return throwingAt;
}

usingPlayerGrenadeTimer()
{
	return self.activeGrenadeTimer == "player_" + self.grenadeWeapon;
}

setGrenadeTimer( grenadeTimer, newValue )
{
	oldValue = anim.grenadeTimers[ grenadeTimer ];
	anim.grenadeTimers[ grenadeTimer ] = max( newValue, oldValue );
}

getDesiredGrenadeTimerValue()
{
	nextGrenadeTimeToUse = undefined;
	if ( self usingPlayerGrenadeTimer() )
	{
		nextGrenadeTimeToUse = GetTime() + anim.playerGrenadeBaseTime + RandomInt(anim.playerGrenadeRangeTime);
	}
	else
	{
		nextGrenadeTimeToUse = GetTime() + 40000 + RandomInt(60000);
	}

	return nextGrenadeTimeToUse;
}

// a "double" grenade is when 2 grenades land at the player's feet at once.
// we do this sometimes on harder difficulty modes.
mayThrowDoubleGrenade()
{
	assert( self.activeGrenadeTimer == "player_frag_grenade_sp" );
	
	if ( player_died_recently() )
		return false;
	
	if ( !anim.double_grenades_allowed )
		return false;
	
	// if it hasn't been long enough since the last double grenade, don't do it
	if ( GetTime() < anim.grenadeTimers[ "player_double_grenade" ] )
		return false;
	
	// if no one's started throwing a grenade recently, we can't do it
	if ( GetTime() > anim.lastFragGrenadeToPlayerStart + 3000 )
		return false;

	// stagger double grenades by 0.5 sec
	if ( GetTime() > anim.lastFragGrenadeToPlayerStart + 500 )
		return false;

	return anim.numGrenadesInProgressTowardsPlayer < 2;
}

myGrenadeCoolDownElapsed()
{
	if (self.script_forcegrenade == 1)
		return true;
	
	if( self.grenadeAmmo <= 0 )
		return false;
	
	return ( GetTime() >= self.a.nextGrenadeTryTime );
}

grenadeCoolDownElapsed()
{
	if (self.script_forcegrenade == 1)
		return true;
	
	/#
	if( shouldForceBehavior("grenade") )
		return true;
	#/
		
	if ( player_died_recently() )
		return false;
	
	if ( !myGrenadeCoolDownElapsed() )
		return false;
	
	if ( GetTime() >= anim.grenadeTimers[self.activeGrenadeTimer] )
		return true;
	
// AI_TODO - investigate need of this. As such there is already too much grenade spam.
//	if ( self.activeGrenadeTimer == "player_frag_grenade_sp" )
//		return mayThrowDoubleGrenade();
	
	return false;
}

/#
printGrenadeTimers()
{
	level notify("stop_printing_grenade_timers");
	level endon("stop_printing_grenade_timers");
	
	const x = 40;
	y = 40;
	
	level.grenadeTimerHudElem = [];
	
	keys = getArrayKeys( anim.grenadeTimers );
	for ( i = 0; i < keys.size; i++ )
	{
		textelem = newHudElem();
		textelem.x = x;
		textelem.y = y;
		textelem.alignX = "left";
		textelem.alignY = "top";
		textelem.horzAlign = "fullscreen";
		textelem.vertAlign = "fullscreen";
		textelem SetText( keys[i] );
		
		bar = newHudElem();
		bar.x = x + 110;
		bar.y = y + 2;
		bar.alignX = "left";
		bar.alignY = "top";
		bar.horzAlign = "fullscreen";
		bar.vertAlign = "fullscreen";
		bar setshader( "black", 1, 8 );
		
		textelem.bar = bar;
		textelem.key = keys[i];
		
		y += 10;
		
		level.grenadeTimerHudElem[keys[i]] = textelem;
	}
	
	while(1)
	{
		wait .05;
		
		for ( i = 0; i < keys.size; i++ )
		{
			timeleft = (anim.grenadeTimers[keys[i]] - GetTime()) / 1000;
			
			width = max( timeleft * 4, 1 );
			width = int( width );
			
			bar = level.grenadeTimerHudElem[keys[i]].bar;
			bar setShader( "black", width, 8 );
		}
	}
}

destroyGrenadeTimers()
{
	if ( !IsDefined( level.grenadeTimerHudElem ) )
	{
		return;
	}

	keys = getArrayKeys( anim.grenadeTimers );
	for ( i = 0; i < keys.size; i++ )
	{
		level.grenadeTimerHudElem[keys[i]].bar Destroy();
		level.grenadeTimerHudElem[keys[i]] Destroy();
	}
}

grenadeTimerDebug()
{
	if ( GetDvar( "scr_grenade_debug") == "" )
	{
		SetDvar("scr_grenade_debug", "0");
	}
	
	while(1)
	{
		while(1)
		{
			if ( GetDebugDvar("scr_grenade_debug") != "0" )
			{
				break;
			}

			wait .5;
		}

		thread printGrenadeTimers();
		while(1)
		{
			if ( GetDebugDvar("scr_grenade_debug") == "0" )
			{
				break;
			}

			wait .5;
		}

		level notify("stop_printing_grenade_timers");
		destroyGrenadeTimers();
	}
}

grenadeDebug( state, duration, showMissReason )
{
	if ( GetDebugDvar("scr_grenade_debug") == "0" )
	{
		return;
	}
	
	self notify("grenade_debug");
	self endon("grenade_debug");
	self endon("killanimscript");
	self endon("death");

	endtime = GetTime() + 1000 * duration;
	
	while( GetTime() < endtime )
	{
		Print3d( self GetShootAtPos() + (0,0,10), state );
		if ( IsDefined( showMissReason ) && IsDefined( self.grenadeMissReason ) )
		{
			Print3d( self GetShootAtPos() + (0,0,0), "Failed: " + self.grenadeMissReason );
		}
		else if ( IsDefined( self.activeGrenadeTimer ) )
		{
			Print3d( self GetShootAtPos() + (0,0,0), "Timer: " + self.activeGrenadeTimer );
		}

		wait .05;
	}
}

setGrenadeMissReason( reason )
{
	if ( GetDebugDvar("scr_grenade_debug") == "0" )
	{
		return;
	}

	self.grenadeMissReason = reason;
}
#/

TryGrenadePosProc( /*throwingAt,*/ destination, optionalAnimation, armOffset )
{
	// Dont throw a grenade right near you or your buddies
	if ( !self isGrenadePosSafe( destination ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "teammates near target" );
		#/

		return false;
	}
	else if ( DistanceSquared( self.origin, destination ) < 200 * 200 )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "too close (<200)" );
		#/

		return false;
	}
	
	trace = PhysicsTrace( destination + (0,0,1), destination + (0,0,-500) );
	if ( trace == destination + (0,0,-500) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no ground under target" );
		#/

		return false;
	}

	trace += (0,0,.1); // ensure just above ground
	
	
	return TryGrenadeThrow( /*throwingAt,*/ trace, optionalAnimation, armOffset );
}

checkGrenadeThrowDist()
{
	diff = self.enemy.origin - self.origin;
	dist = Length( ( diff[ 0 ], diff[ 1 ], 0 ) );
	distSq = lengthSquared( ( diff[ 0 ], diff[ 1 ], 0 ) );
	 
	// flashbangs are treated separately
//	if ( self.grenadeWeapon == "flash_grenade" )
//		return ( distSq < anim.combatGlobals.MAX_FLASH_GRENADE_THROW_DISTSQ );
	
	// All other grenades have a min/max range
	return ( distSq >= anim.combatGlobals.MIN_EXPOSED_GRENADE_DISTSQ ) && ( distSq <= anim.combatGlobals.MAX_GRENADE_THROW_DISTSQ );
}

TryGrenade( throwingAt, optionalAnimation )
{
	self setActiveGrenadeTimer( throwingAt );
	
	throwingAt = considerChangingTarget( throwingAt );
	
	if ( !grenadeCoolDownElapsed() )
	{
		/#self animscripts\debug::debugPopState( undefined, "cooldown from last throw" );#/
		return false;
	}
	
	/#self thread grenadeDebug( "Tried grenade throw", 4, true );#/

	armOffset = getGrenadeThrowOffset( optionalAnimation );
	
	if ( IsDefined( self.enemy ) && throwingAt == self.enemy )
	{		
		if( !checkGrenadeThrowDist() )
		{
			/#self animscripts\debug::debugPopState( undefined, "Too close or too far" );#/
			/# self setGrenadeMissReason( "Too close or too far" ); #/
			return false;
		}

		if ( self canSeeEnemyFromExposed() )
		{
			if ( !self isGrenadePosSafe( throwingAt.origin ) )
			{
				/#self animscripts\debug::debugPopState( undefined, "teammates near target" );#/
				/# self setGrenadeMissReason( "Teammates near target" ); #/
				return false;
			}

			return TryGrenadeThrow( undefined, optionalAnimation, armOffset );
		}
		else if ( self canSuppressEnemyFromExposed() )
		{
			return TryGrenadePosProc(  self getEnemySightPos(), optionalAnimation, armOffset );
		}
		else
		{
			// hopefully we can get through a grenade hint or something
			if ( !self isGrenadePosSafe( throwingAt.origin ) )
			{
				/#
				self animscripts\debug::debugPopState( undefined, "teammates near target" );
				#/

				/# self setGrenadeMissReason( "Teammates near target" ); #/
				return false;
			}

			return TryGrenadeThrow( undefined, optionalAnimation, armOffset );
		}

		/#self animscripts\debug::debugPopState( undefined, "don't know where to throw" );#/
		
		/# self setGrenadeMissReason( "Don't know where to throw" ); #/
		return false; // didn't know where to throw!
	}
	else
	{
		return TryGrenadePosProc( throwingAt.origin, optionalAnimation, armOffset );
	}
}

TryGrenadeThrow( destination, optionalAnimation, armOffset )
{
	if( weaponIsGasWeapon( self.weapon ) )
	{
		/#self animscripts\debug::debugPopState( undefined, "using gas weapon" );#/
		return false;
	}
	
	// no AI grenade throws in the first 10 seconds, bad during black screen
	if ( GetTime() < 10000 )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "first 10 seconds of game" );
		#/

		/# self setGrenadeMissReason( "First 10 seconds of game" ); #/
		return false;
	}
	
	if (IsDefined(optionalAnimation))
	{
		throw_anim = optionalAnimation;
		// Assume armOffset and gunHand are defined whenever optionalAnimation is.
		gunHand = self.a.gunHand;	// Actually we don't want gunhand in this case.  We rely on notetracks.
	}
	else
	{
		switch (self.a.special)
		{
		case "cover_crouch":
		case "none":
			if (self.a.pose == "stand")
			{
				armOffset = (0,0,80);
				throw_anim = animArray("grenade_throw");
			}
			else // if (self.a.pose == "crouch")
			{
				armOffset = (0,0,65);
				throw_anim = animArray("grenade_throw");
			}
			gunHand = "left";
			break;
		default: // Do nothing - we don't have an appropriate throw animation.
			throw_anim = undefined;
			gunHand = undefined;			
			break;
		}
	}
	
	// If we don't have an animation, we can't throw the grenade.
	if (!IsDefined(throw_anim))
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no throw anim" );
		#/

		return (false);
	}
	
	if (IsDefined (destination)) // Now try to throw it.
	{
		throwvel = self checkGrenadeThrowPos(armOffset, "min energy", destination);
		if (!IsDefined(throwvel))
		{
			throwvel = self checkGrenadeThrowPos(armOffset, "min time", destination);
		}
		
		if (!IsDefined(throwvel))
		{
			throwvel = self checkGrenadeThrowPos(armOffset, "max time", destination);		
		}
	}
	else
	{
		throwvel = self checkGrenadeThrow(armOffset, "min energy", self.randomGrenadeRange);
		if (!IsDefined(throwvel))
		{
			throwvel = self checkGrenadeThrow(armOffset, "min time", self.randomGrenadeRange);
		}

		if (!IsDefined(throwvel))
		{
			throwvel = self checkGrenadeThrow(armOffset, "max time", self.randomGrenadeRange);
		}
	}
	
	// the grenade checks are slow. don't do it too often.
	self.a.nextGrenadeTryTime = GetTime() + randomintrange(1000,2000);
	
	if ( IsDefined(throwvel) )
	{
		if (!IsDefined(self.oldGrenAwareness))
		{
			self.oldGrenAwareness = self.grenadeawareness;
		}

		self.grenadeawareness = 0; // so we dont respond to nearby grenades while throwing one
		
		/#
		if (GetDebugDvar ("anim_debug") == "1")
		{
			thread animscripts\utility::debugPos(destination, "O");
		}
		#/
		
		// remember the time we want to delay any future grenade throws to, to avoid throwing too many.
		// however, for now, only set the timer far enough in the future that it will expire when we throw the grenade.
		// that way, if the throw fails (maybe due to killanimscript), we'll try again soon.
		nextGrenadeTimeToUse = self getDesiredGrenadeTimerValue();
		setGrenadeTimer( self.activeGrenadeTimer, min( GetTime() + 3000, nextGrenadeTimeToUse ) );
		
		secondGrenadeOfDouble = false;
		if ( self usingPlayerGrenadeTimer() )
		{
			anim.numGrenadesInProgressTowardsPlayer++;
			self thread reduceGIPTPOnKillanimscript();

			if ( anim.numGrenadesInProgressTowardsPlayer > 1 )
			{
				secondGrenadeOfDouble = true;
			}
		}
		
		if ( self.activeGrenadeTimer == "player_frag_grenade_sp" && anim.numGrenadesInProgressTowardsPlayer <= 1 )
		{
			anim.lastFragGrenadeToPlayerStart = GetTime();
		}
		
		/#
		if ( GetDvar( "grenade_spam" ) == "on" )
		{
			nextGrenadeTimeToUse = 0;
		}
		#/
		
		DoGrenadeThrow( throw_anim, nextGrenadeTimeToUse, secondGrenadeOfDouble );

		/#
		self animscripts\debug::debugPopState( undefined, "success" );
		#/

        return true;
	}
	else
	{
		/# self setGrenadeMissReason( "Couldn't find trajectory" ); #/
		/#
		if (GetDebugDvar("debug_grenademiss") == "on" && IsDefined (destination))
		{
			thread grenadeLine(armoffset, destination);
		}
		#/		
	}

	/#
	self animscripts\debug::debugPopState( undefined, "couldn't find suitable trajectory" );
	#/
	
	return false;
}

reduceGIPTPOnKillanimscript()
{
	self endon("dont_reduce_giptp_on_killanimscript");
	self waittill("killanimscript");
	anim.numGrenadesInProgressTowardsPlayer--;
}

DoGrenadeThrow( throw_anim, nextGrenadeTimeToUse, secondGrenadeOfDouble )
{
	/#
	self thread grenadeDebug( "Starting throw", 3 );
	#/

	self notify ("stop_aiming_at_enemy");
	self SetFlaggedAnimKnobAllRestart("throwanim", throw_anim, %body, 1, 0.1, 1);

	self thread animscripts\shared::DoNoteTracksForever("throwanim", "killanimscript");

	model = getWeaponModel(self.grenadeweapon);
		
	attachside = "none";
	for (;;)
	{
		self waittill("throwanim", notetrack);
		if ( notetrack == "grenade_left" || notetrack == "grenade_right" )
		{
			attachside = attachGrenadeModel(model, "TAG_INHAND");
			self.isHoldingGrenade = true;
		}

		if ( notetrack == "grenade_throw" || notetrack == "grenade throw" )
		{
			break;
		}

		assert(notetrack != "end"); // we shouldn't hit "end" until after we've hit "grenade_throw"!
		if ( notetrack == "end" ) // failsafe
		{
			anim.numGrenadesInProgressTowardsPlayer--;
			self notify("dont_reduce_giptp_on_killanimscript");
			return false;
		}
	}

	/#
	if (GetDebugDvar("debug_grenadehand") == "on")
	{
		tags = [];
		numTags = self getAttachSize();
		emptySlot = [];

		for (i=0;i<numTags;i++)
		{
			name = self getAttachModelName(i);
			if (issubstr(name, "weapon"))
			{
				tagName = self getAttachTagname(i);
				emptySlot[tagname] = 0;
				tags[tags.size] = tagName;
			}
		}
		
		for (i=0;i<tags.size;i++)
		{
			emptySlot[tags[i]]++;
			if (emptySlot[tags[i]] < 2)
			{
				continue;
			}

			iprintlnbold ("Grenade throw needs fixing (check console)");
			println ("Grenade throw animation ", throw_anim, " has multiple weapons attached to ", tags[i]);
			break;
		}
	}
	#/
	
	/#
	self thread grenadeDebug( "Threw", 5 );
	#/
	
	self notify("dont_reduce_giptp_on_killanimscript");
	
	if ( self usingPlayerGrenadeTimer() )
	{
		// give the grenade some time to get to the player.
		// if it gets there, we'll reset the timer so we don't throw any more in a while.
		self thread watchGrenadeTowardsPlayer( nextGrenadeTimeToUse );
	}


//	self thread watchEMPGrenadeTowardsPlayer();
	
	self maps\_dds::dds_notify_grenade( self.grenadeweapon, ( self.team == "allies" ), false );
	self throwGrenade();
		
	if ( !self usingPlayerGrenadeTimer() )
	{
		setGrenadeTimer( self.activeGrenadeTimer, nextGrenadeTimeToUse );
	}
	
	if ( secondGrenadeOfDouble )
	{
		if ( anim.numGrenadesInProgressTowardsPlayer > 1 || GetTime() - anim.lastGrenadeLandedNearPlayerTime < 2000 )
		{
			// two grenades in progress toward player. give them time to arrive.
			anim.grenadeTimers["player_double_grenade"] = GetTime() + min( 5000, anim.playerDoubleGrenadeTime );
		}
	}
	
	self notify ("stop grenade check");
	
//		assert (attachSide != "none");
	if ( attachSide != "none" )		
	{
		self detach(model, attachside);
	}
	else
	{
		/#
		print ("No grenade hand set: ");
		println (throw_anim);
		println("animation in console does not specify grenade hand");
		#/
	}

	self.isHoldingGrenade = undefined;

	self.grenadeawareness = self.oldGrenAwareness;
	self.oldGrenAwareness = undefined;
	
	
	self waittillmatch("throwanim", "end");
	// modern
	
	// TODO: why is this here? why are we assuming that the calling function wants these particular animnodes turned on?
	self SetAnim(%exposed_modern,1,.2);
	self SetAnim(%exposed_aiming,1);
	self ClearAnim(throw_anim,.2);
}


//they don't like bouncing emp grenades
//watchEMPGrenadeTowardsPlayer()
//{
//	level endon("death"); // endon player death
//	
//	if( self.grenadeWeapon == "emp_grenade_sp" )
//	{
//		grenade = self getGrenadeIThrew();
//		
//		if ( !IsDefined( grenade ) ) // the throw failed. maybe we died.
//			return;
//	
//		grenade.originalOwner = self;
//		grenade thread maps\_weapons::watch_emp_grenade_stage1();
//	}
//}

watchGrenadeTowardsPlayer( nextGrenadeTimeToUse )
{
	// TODO ONLINE: for now watch even though player dies
	//level.player endon("death");
	
	watchGrenadeTowardsPlayerInternal( nextGrenadeTimeToUse );
	anim.numGrenadesInProgressTowardsPlayer--;
}

watchGrenadeTowardsPlayerInternal( nextGrenadeTimeToUse )
{
	// give the grenade at least 5 seconds to land
	activeGrenadeTimer = self.activeGrenadeTimer;
	timeoutObj = SpawnStruct();
	timeoutObj thread watchGrenadeTowardsPlayerTimeout( 5 );
	timeoutObj endon("watchGrenadeTowardsPlayerTimeout");
	
	type = self.grenadeWeapon;
	
	grenade = self getGrenadeIThrew();
	if ( !IsDefined( grenade ) )
	{
		// the throw failed. maybe we died. =(
		return;
	}
	
	setGrenadeTimer( activeGrenadeTimer, min( GetTime() + 5000, nextGrenadeTimeToUse ) );

	/#
	grenade thread grenadeDebug( "Incoming", 5 );
	#/
	
	goodRadiusSqrd = 250 * 250;
	giveUpRadiusSqrd = 400 * 400;
	if ( type == "flash_grenade" )
	{
		goodRadiusSqrd = 900 * 900;
		giveUpRadiusSqrd = 1300 * 1300;
	}
	
	// TODO ONLINE: more grenade problems
	players = GetPlayers();
	
	// wait for grenade to settle
	prevorigin = grenade.origin;
	while(1)
	{
		wait .1;
		
		if ( !IsDefined( grenade ) )
		{
			break;
		}
		
		if ( grenade.origin == prevorigin )
		{
			if ( DistanceSquared( grenade.origin, players[0].origin ) < goodRadiusSqrd || DistanceSquared( grenade.origin, players[0].origin ) > giveUpRadiusSqrd )
			{
				break;
			}
		}
		prevorigin = grenade.origin;
	}

	grenadeorigin = prevorigin;
	if ( IsDefined( grenade ) )
	{
		grenadeorigin = grenade.origin;
	}

	if ( DistanceSquared( grenadeorigin, players[0].origin ) < goodRadiusSqrd )
	{
		/#
		if ( IsDefined( grenade ) )
		{
			grenade thread grenadeDebug( "Landed near player", 5 );
		}
		#/
		
		// the grenade landed near the player! =D
		level notify("threw_grenade_at_player");
		anim.throwGrenadeAtPlayerASAP = undefined;

		if ( GetTime() - anim.lastGrenadeLandedNearPlayerTime < 3000 )
		{
			// double grenade happened
			anim.grenadeTimers["player_double_grenade"] = GetTime() + anim.playerDoubleGrenadeTime;
		}

		anim.lastGrenadeLandedNearPlayerTime = GetTime();

		setGrenadeTimer( activeGrenadeTimer, nextGrenadeTimeToUse );
	}
	else
	{
		/#
		if ( IsDefined( grenade ) )
		{
			grenade thread grenadeDebug( "Missed", 5 );
		}
		#/
	}
}

getGrenadeIThrew()
{
	self endon("killanimscript");
	self waittill( "grenade_fire", grenade );
	return grenade;
}

watchGrenadeTowardsPlayerTimeout( timerlength )
{
	wait timerlength;
	self notify("watchGrenadeTowardsPlayerTimeout");
}

attachGrenadeModel(model, tag)
{
	self attach (model, tag);
	thread detachGrenadeOnScriptChange(model, tag);
	return tag;
}

detachGrenadeOnScriptChange(model, tag)
{
	//self endon ("death"); // don't end on death or it will hover when we die!
	self endon ("stop grenade check");
	self waittill ("killanimscript");
	
	if ( !IsDefined( self ) ) // we may be dead but still defined. if we're not defined, we were probably deleted.
	{
		return;
	}
	
	if (IsDefined(self.oldGrenAwareness))
	{	
		self.grenadeawareness = self.oldGrenAwareness;
		self.oldGrenAwareness = undefined;
	}
	
	self detach(model, tag);
}

offsetToOrigin(start)
{
	forward = AnglesToForward(self.angles);
	right = AnglesToRight(self.angles);
	up = anglestoup(self.angles);
	forward = VectorScale(forward, start[0]);
	right = VectorScale(right, start[1]);
	up = VectorScale(up, start[2]);
	return (forward + right + up);
}

/#
grenadeLine(start, end)
{
	level notify ("armoffset");
	level endon ("armoffset");
	
	start = self.origin + offsetToOrigin(start);
	for (;;)
	{
		line (start, end, (1,0,1));
		Print3d (start, start, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		Print3d (end, end, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}
}
#/
	
getGrenadeDropVelocity()
{
	yaw = RandomFloat( 360 );
	pitch = RandomFloatRange( 30, 75 );
	
	amntz = sin( pitch );
	cospitch = cos( pitch );
	
	amntx = cos( yaw ) * cospitch;
	amnty = sin( yaw ) * cospitch;
	
	speed = RandomFloatRange( 100, 200 );
	
	velocity = (amntx, amnty, amntz) * speed;
	return velocity;
}

dropGrenade()
{
	grenadeOrigin = self GetTagOrigin ( "tag_inhand" );
	velocity = getGrenadeDropVelocity();
	self MagicGrenadeManual( grenadeOrigin, velocity, 3 );
}

lookForBetterCover()
{
	// don't do cover searches if we don't have an enemy.
	if ( !isValidEnemy( self.enemy ) )
		return false;
			
	if ( self.fixedNode || self.doingAmbush )
		return false;
		
	node = self getBestCoverNodeIfAvailable();
	
	if ( IsDefined( node ) )
		return useCoverNodeIfPossible( node );
	
	return false;
}

getBestCoverNodeIfAvailable()
{
	node = self FindBestCoverNode();
	
	if ( !IsDefined(node) )
	{
		/#recordEntText( "FindBestCoverNode from getBestCoverNodeIfAvailable (fail1)", self, level.color_debug["white"], "Cover" );#/
		return undefined;
	}

	currentNode = self GetClaimedNode();
	if ( IsDefined( currentNode ) && node == currentNode )
	{
		/#recordEntText( "FindBestCoverNode from getBestCoverNodeIfAvailable (fail2)", self, level.color_debug["white"], "Cover" );#/
		return undefined;
	}
	
	// work around FindBestCoverNode() resetting my .node in rare cases involving overlapping nodes
	// This prevents us from thinking we've found a new node somewhere when in reality it's the one we're already at, so we won't abort our script.
	if ( IsDefined( self.coverNode ) && node == self.coverNode )
	{
		/#recordEntText( "FindBestCoverNode from getBestCoverNodeIfAvailable (fail3)", self, level.color_debug["white"], "Cover" );#/
		return undefined;
	}
	
	/#recordEntText( "FindBestCoverNode from getBestCoverNodeIfAvailable (success)", self, level.color_debug["white"], "Cover" );#/
	
	return node;
}

useCoverNodeIfPossible( node )
{
	oldKeepNodeInGoal = self.keepClaimedNodeIfValid;
	oldKeepNode = self.keepClaimedNode;
	self.keepClaimedNodeIfValid = false;
	self.keepClaimedNode = false;

	if ( self UseCoverNode( node ) )
	{
		return true;
	}
	else
	{
		/#self thread DebugFailedCoverUsage( node );#/
	}
	
	self.keepClaimedNodeIfValid = oldKeepNodeInGoal;
	self.keepClaimedNode = oldKeepNode;
	
	return false;
}

/#
DebugFailedCoverUsage( node )
{
	if ( GetDvar( "scr_debugfailedcover") == "" )
	{
		SetDvar("scr_debugfailedcover", "0");
	}

	if ( getdebugdvarint("scr_debugfailedcover") == 1 )
	{
		self endon("death");
		for ( i = 0; i < 20; i++ )
		{
			line( self.origin, node.origin );
			Print3d( node.origin, "failed" );
			wait .05;
		}
	}
}
#/

tryRunningToEnemy( ignoreSuppression )
{
	if( IS_TRUE( self.a.disableReacquire  ) )
		return false;
	
	if ( !isValidEnemy( self.enemy ) )
		return false;
		
	if( self.enemy IsVehicle() || ( IsAI( self.enemy ) && self.enemy.isBigDog ) )
		return false;
		
	if ( self.fixedNode )
		return false;
	
	if ( self.combatMode == "ambush" || self.combatMode == "ambush_nodes_only" )
		return false;
		
	if ( self IsInGoal( self.enemy.origin ) )
		self FindReacquireDirectPath( ignoreSuppression );
	else
		self FindReacquireProximatePath( ignoreSuppression );
		
	// TrimPathToAttack is supposed to be called multiple times, until it returns false.
	// it trims the path a little more each time, until trimming it more would make the enemy invisible from the end of the path.
	// we're skipping this step and just running until we get within close range of the enemy.
	// maybe later we can periodically check while moving if the enemy is visible, and if so, enter exposed.
	//self TrimPathToAttack();
	
	if ( self ReacquireMove() )
	{
		self.keepClaimedNodeIfValid = false;
		self.keepClaimedNode = false;
		
		self.a.magicReloadWhenReachEnemy = true;
		return true;
	}
	
	return false;
}

getGunYawToShootEntOrPos()
{
	if ( !IsDefined( self.shootPos ) )
	{
		assert( !IsDefined( self.shootEnt ) );
		return 0;
	}
	
	yaw = self GetTagAngles("tag_weapon")[1] - GET_YAW(self, self.shootPos );
	yaw = AngleClamp180( yaw );
	return yaw;
}

getGunPitchToShootEntOrPos()
{
	if ( !IsDefined( self.shootPos ) )
	{
		assert( !IsDefined( self.shootEnt ) );
		return 0;
	}
	
	pitch = self GetTagAngles("tag_weapon")[0] - VectorToAngles( self.shootPos - self gettagorigin("tag_weapon") )[0];
	pitch = AngleClamp180( pitch );
	return pitch;
}

getPitchToEnemy()
{
	if(!IsDefined(self.enemy))
	{
		return 0;
	}
	
	vectorToEnemy = self.enemy GetShootAtPos() - self GetShootAtPos();	
	vectorToEnemy = VectorNormalize(vectortoenemy);
	pitchDelta = 360 - VectorToAngles(vectorToEnemy)[0];
	
	return AngleClamp180( pitchDelta );
}

getPitchToSpot(spot)
{
	if(!IsDefined(spot))
	{
		return 0;
	}
	
	vectorToEnemy = spot - self GetShootAtPos();	
	vectorToEnemy = VectorNormalize(vectortoenemy);
	pitchDelta = 360 - VectorToAngles(vectorToEnemy)[0];
	
	return AngleClamp180( pitchDelta );
}


watchReloading()
{
	// this only works on the player.
	self.isreloading = false;
	while(1)
	{
		self waittill("reload_start");
		self maps\_dds::dds_notify_reload( self GetCurrentWeapon(), ( self.team == "allies" ) );
		self.isreloading = true;
		
		self waittillreloadfinished();
		self.isreloading = false;
	}
}

waittillReloadFinished()
{
	self thread timedNotify( 4, "reloadtimeout" );
	self endon("reloadtimeout");
	while(1)
	{
		self waittill("reload");
		
		weap = self getCurrentWeapon();
		if ( weap == "none" )
		{
			break;
		}
		
		if ( self getCurrentWeaponClipAmmo() >= weaponClipSize( weap ) )
		{
			break;
		}
	}
	self notify("reloadtimeout");
}

timedNotify( time, msg )
{
	self endon( msg );
	wait time;
	self notify( msg );
}

attackEnemyWhenFlashed()
{
	self endon("killanimscript");
	
	while(1)
	{
		if ( !IsDefined( self.enemy ) || !IsAlive( self.enemy ) || !IsSentient( self.enemy ) )
		{
			self waittill("enemy");
			continue;
		}
		
		attackSpecificEnemyWhenFlashed();
	}
}

attackSpecificEnemyWhenFlashed()
{
	self endon("enemy");
	self.enemy endon("death");
	
	if ( IsDefined( self.enemy.flashendtime ) && GetTime() < self.enemy.flashendtime )
	{
		tryToAttackFlashedEnemy();
	}
	
	while ( 1 )
	{
		self.enemy waittill("flashed");
		
		tryToAttackFlashedEnemy();
	}
}

tryToAttackFlashedEnemy()
{
	if ( self.enemy.flashingTeam != self.team )
	{
		return;
	}
	
	if ( DistanceSquared( self.origin, self.enemy.origin ) > 1024*1024 )
	{
		return;
	}
	
	while ( GetTime() < self.enemy.flashendtime - 500 )
	{
		if ( !self cansee( self.enemy ) && DistanceSquared( self.origin, self.enemy.origin ) < 800*800 )
		{
			tryRunningToEnemy( true );
		}
		
		wait .05;
	}
}

startFlashBanged()
{
	if ( IsDefined( self.flashduration ) )
	{
		duration = self.flashduration;
	}
	else
	{
		duration = self getFlashBangedStrength() * 1000;
	}
	
	self.flashendtime = GetTime() + duration;
	self notify("flashed");
	
	return duration;
}

monitorFlash()
{
	self endon("death");
	self endon("stop_monitoring_flash");
	
	while(1)
	{
		// "flashbang" is code notifying that the AI can be flash banged
		// "doFlashBanged" is sent below if the AI should do flash banged behavior
		self waittill( "flashbang", amount_distance, amount_angle, attacker, attackerteam );
		
		if ( self.flashbangImmunity )
		{
			continue;
		}
		
		if( IsDefined( self.script_immunetoflash ) && self.script_immunetoflash != 0 )
		{
			continue;
		}
		
		if ( IsDefined( self.team ) && IsDefined( attackerteam ) && self.team == attackerteam )
		{
			// AI get a break when their own team flashbangs them.
			amount_distance = 3 * (amount_distance - .75);
			if ( amount_distance < 0 )
			{
				continue;
			}
		}
		
		// at 200 or less of the full range of 1000 units, get the full effect
		const minamountdist = 0.2;
		if ( amount_distance > 1 - minamountdist )
		{
			amount_distance = 1.0;
		}
		else
		{
			amount_distance = amount_distance / (1 - minamountdist);
		}
		
		duration = 4.5 * amount_distance;
		
		if ( duration < 0.25 )
		{
			continue;
		}
		
		self.flashingTeam = attackerteam;
		self SetFlashBanged( true, duration );
		self notify( "doFlashBanged", attacker );
	}
}

isSniper()
{
	return self.isSniper;
}

isSniperRifle( weapon )
{
	return WeaponIsSniperWeapon( weapon );
}

isChargedShotSniperRifle( weapon )
{
	return WeaponIsChargeShot( weapon ) && WeaponIsSniperWeapon( weapon );
}

isCrossbow( weapon )
{
	return ( IsSubstr(weapon, "crossbow") && !IsSubstr(weapon, "explosive") );
}

getShootAnimPrefix()
{
	if( self.a.script == "cover_left" || self.a.script == "cover_right" || self.a.script == "cover_pillar" )
	{
		// check if we're leaning
		if( IS_TRUE(self.cornerAiming) && IsDefined(self.a.cornerMode) && self.a.cornerMode == "lean" )
		{
			return "lean_";
		}
	}

	return "";
}

randomFasterAnimSpeed()
{
	return randomfloatrange( 1, 1.1 );
}

player_sees_my_scope()
{
	// player sees the scope glint if the dot is within a certain range
	start = self geteye();
	
	players = get_players();
	foreach ( player in players )
	{
		if ( !self cansee( player ) )
			continue;
			
		end = player GetEye();
	
		angles = VectorToAngles( start - end );
		forward = AnglesToForward( angles );
		player_angles = player GetPlayerAngles();
		player_forward = AnglesToForward( player_angles );
	
		dot = VectorDot( forward, player_forward );
		if ( dot < 0.805 )
			continue;
			
		if ( cointoss() && dot >= 0.996 )
			continue;
		
		return true;
	}
	return false;
}
