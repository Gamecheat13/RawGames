#include animscripts\Utility;
#include maps\_gameskill;
#include maps\_utility;
#include common_scripts\utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

EnemiesWithinStandingRange()
{
	enemyDistanceSq = self MyGetEnemySqDist();
	return ( enemyDistanceSq < anim.standRangeSq );
}


MyGetEnemySqDist()
{
    dist = self GetClosestEnemySqDist();
	if (!isDefined(dist))
		dist = 100000000000;
    return dist;
}


getTargetAngleOffset(target)
{
	pos = self getshootatpos() + (0,0,-3); // compensate for eye being higher than gun
	dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
	dir = VectorNormalize( dir );
	fact = dir[2] * -1;
//	println ("offset "  + fact);
	return fact;
}

getRemainingBurstDelayTime()
{
	timeSoFar = (gettime() - self.a.lastShootTime) / 1000;
	delayTime = getBurstDelayTime();
	if ( delayTime > timeSoFar )
		return delayTime - timeSoFar;
	return 0;
}
getBurstDelayTime()
{
	if ( self usingSidearm() )
		return randomFloatRange( .15, .55 );
	else if ( self usingShotgun() )
		return randomFloatRange( 1.0, 1.7 );
	else if ( self.fastBurst )
		return randomFloatRange( .1, .35 );
	else
		return randomFloatRange( .4, .9 );
}
burstDelay()
{
	if ( self.bulletsInClip )
	{
		delayTime = getRemainingBurstDelayTime();
		if ( delayTime )
			wait delayTime;
	}
}

FireUntilOutOfAmmo( fireAnim, stopOnAnimationEnd, maxshots )
{
	animName = "fireAnim";
	
	prof_begin("FireUntilOutOfAmmo");
	
	// first, wait until we're aimed right
	while( !aimedAtShootEntOrPos() )
		wait .05;
	
	// give the player a chance to react, or conserve ammo
	maps\_gameskill::resetAccuracyAndPause();
	
	self setAnim( %additive,1, .1, 1 );
	
	rate = 1;
	if ( self.shootStyle == "full" || self.shootStyle == "burst" )
		rate = animscripts\weaponList::autoShootAnimRate();
	
	self setFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, rate );
	
	// Update the sight accuracy against the player.  Should be called before the volley starts.
	self updatePlayerSightAccuracy();

	prof_end("FireUntilOutOfAmmo");

	FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots );
	
	self clearAnim( %additive, .2 );
}

FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots )
{
	self endon("enemy"); // stop shooting if our enemy changes, because we have to reset our accuracy and stuff
	// stop shooting if the player becomes invulnerable, so we will call resetAccuracyAndPause again
	if ( isPlayer( self.enemy ) && (self.shootStyle == "full" || self.shootStyle == "semi") )
		level endon("player_becoming_invulnerable");
	
	if ( stopOnAnimationEnd )
	{
		self thread NotifyOnAnimEnd( animName, "fireAnimEnd" );
		self endon( "fireAnimEnd" );
	}
	
	if ( !isdefined( maxshots ) )
		maxshots = -1;
	
	numshots = 0;
	
	hasFireNotetrack = animHasNoteTrack( fireAnim, "fire" );
	
	usingRocketLauncher = (weaponClass( self.weapon ) == "rocketlauncher");
	
	prof_begin("FireUntilOutOfAmmoInternal");
	
	while(1)
	{
		if ( hasFireNotetrack )
			self waittillmatch( animName, "fire" );
		
		if ( numshots == maxshots ) // note: maxshots == -1 if no limit
			break;
		
		if ( !self.bulletsInClip )
		{
			// cheat and finish off the player if we can.
			if ( isPlayer( self.enemy ) && self.enemy.health <= self.enemy.maxHealth * level.healthOverlayCutoff && weaponClipSize( self.weapon ) >= 15 && !flag("player_is_invulnerable") && self canSee( self.enemy ) )
				self.bulletsInClip = 5;
			else
				break;
		}
		
		if ( aimedAtShootEntOrPos() )
		{
			self shootAtShootEntOrPos();

			assertex( self.bulletsInClip >= 0, self.bulletsInClip );
			if ( isPlayer( self.enemy ) && flag("player_is_invulnerable") )
			{
				if ( randomint(3) == 0 )
					self.bulletsInClip--;
			}
			else
			{
				self.bulletsInClip--;
			}
			
			if ( usingRocketLauncher )
				self.a.rockets--;
		}
		numshots++;
		
		self thread shotgunPumpSound( animName );
		
		if ( self.fastBurst && numshots == maxshots )
			break;
		
		if ( !hasFireNotetrack )
			self waittillmatch( animName, "end" );
	}
	
	prof_end("FireUntilOutOfAmmoInternal");
	
	if ( stopOnAnimationEnd )
		self notify( "fireAnimEnd" ); // stops NotifyOnAnimEnd()
}

aimedAtShootEntOrPos()
{
	if ( !isdefined( self.shootPos ) )
	{
		assert( !isdefined( self.shootEnt ) );
		return true;
	}
	
	weaponAngles = self gettagangles("tag_weapon");
	anglesToShootPos = vectorToAngles( self.shootPos - self gettagorigin("tag_weapon") );
	
	absyawdiff = AbsAngleClamp180( weaponAngles[1] - anglesToShootPos[1] );
	if ( absyawdiff > 10 )
	{
		if ( distanceSquared( self getShootAtPos(), self.shootPos ) > 64*64 || absyawdiff > 45 )
			return false;
	}
	
	return AbsAngleClamp180( weaponAngles[0] - anglesToShootPos[0] ) <= 20;
}

NotifyOnAnimEnd( animNotify, endNotify )
{
	self endon( endNotify );
	self waittillmatch( animNotify, "end" );
	self notify( endNotify );
}

shootAtShootEntOrPos()
{
	if ( isdefined( self.shootEnt ) )
	{
		if ( isDefined( self.enemy ) && self.shootEnt == self.enemy )
			self shootEnemyWrapper();
		else
			self shootPosWrapper( self.shootEnt getShootAtPos() );
	}
	else
	{
		// if self.shootPos isn't defined, "shoot_behavior_change" should
		// have been notified and we shouldn't be firing anymore
		assert( isdefined( self.shootPos ) );
		
		self shootPosWrapper( self.shootPos );
	}
}

decrementBulletsInClip()
{
	// we allow this to happen even when bulletsinclip is zero,
	// because sometimes we want to shoot even if we're out of ammo,
	// like when we've already started a blind fire animation.
	if ( self.bulletsInClip )
		self.bulletsInClip--;
}

shotgunPumpSound( animName )
{
	if ( !self usingShotgun() )
		return;
	
	self endon("killanimscript");
	
	self notify("shotgun_pump_sound_end");
	self endon("shotgun_pump_sound_end");
	
	self thread stopShotgunPumpAfterTime( 2.0 );
	
	self waittillmatch( animName, "rechamber" );
	
	self playSound( "ai_shotgun_pump" );
	
	self notify("shotgun_pump_sound_end");
}

stopShotgunPumpAfterTime( timer )
{
	self endon("killanimscript");
	self endon("shotgun_pump_sound_end");
	wait timer;
	self notify("shotgun_pump_sound_end");
}

// Rechambers the weapon if appropriate
Rechamber(isExposed)
{
	// obsolete...
}

// Returns true if character has less than thresholdFraction of his total bullets in his clip.  Thus, a value 
// of 1 would always reload, 0 would only reload on an empty clip.
NeedToReload( thresholdFraction )
{
	return self.bulletsInClip <= weaponClipSize( self.weapon ) * thresholdFraction;
}

tryWeaponThrowDown()
{
	if (1)
		return false;

	if (anim.noWeaponToss)
		return false;

	if (weaponAnims() == "pistol")
		return false;

	if (self.team != "axis")
		return false;

	if (self.a.pose != "stand")
		return false;
			
	if (!isalive (self.enemy))
		return false;
	
	if (self.a.script != "combat")
		return false;
		
	if (distance (level.player.origin, self.origin) > 350)
		return false;
	if (!self cansee(self.enemy))
		return false;
		
	/*
	dist = self GetClosestEnemySqDist();
    if ((!isdefined (dist)) || (dist > 500*500))
    	return false;
	*/
	
	tossrand = randomint(3) + 1;
	tossanim = undefined;
	
	assertmsg("these pistol anims don't exist yet");
	/*	
	switch (tossrand)
	{
		case 1:
			tossanim = %pistol_boltaction_toss;
			break;
		case 2:
			tossanim = %pistol_boltaction_toss_struggle;
			break;
		case 3:
			tossanim = %pistol_boltaction_toss_fast;
			break;
	}
	*/
		
//	tossanim = %pistol_boltaction_toss_struggle;
	
	self setFlaggedAnimKnobAllRestart("pistol pullout", tossanim, %body, 1, .1, 1);
	self waittill ("pistol pullout", notetrack);
	
//	self thread throwGun();
	weaponClass = "weapon_" + self.weapon;

	// TEST STUFF	
	if(self.classname == "actor_axis_ramboguytest2")
	{
		weapon = spawn (weaponClass, self getTagOrigin ("TAG_WEAPON_PRIMARY"));
		weapon.angles = self getTagAngles ( "TAG_WEAPON_PRIMARY" ); 
		
	}
	else 
	{
		weapon = spawn (weaponClass, self getTagOrigin ("tag_weapon_right"));
		weapon.angles = self getTagAngles ( "tag_weapon_right" ); 
	}
	if (self.secondaryweapon == "")
		self.weapon = "luger";
	else
		self.weapon = self.secondaryweapon;

//	self animscripts\shared::PutGunInHand("none");
	self thread putGunBackInHandOnKillAnimScript();

	self waittill ("pistol pullout", notetrack);
//	wait (0.2);
//	self animscripts\shared::PutGunInHand("right");
	self notify ("weapon_throw_down_done");
	self.a.combatrunanim = %combat_run_fast_pistol;
	
	self animscripts\weaponList::RefillClip();
	self.a.needsToRechamber = 0;

	self waittillmatch ("pistol pullout", "end");
	self clearanim(%upperbody, .1);		// Only needed for the upper body running reload.
	return true;
}

// Put the gun back in the AI's hand if he cuts off his weapon throw down animation
putGunBackInHandOnKillAnimScript()
{
	self endon ( "weapon_switch_done" );
	self endon ( "death" );
	
	self waittill( "killanimscript" );
//	self thread animscripts\shared::PutGunInHand( "right" );
}

Reload( thresholdFraction, optionalAnimation )
{
	self endon("killanimscript");

	if ( !NeedToReload( thresholdFraction ) )
		return false;
		
	self.a.Alertness = "casual";

	self animscripts\battleChatter_ai::evaluateReloadEvent();
	self animscripts\battleChatter::playBattleChatter();

	if ( isDefined( optionalAnimation ) )
	{
		self setFlaggedAnimKnobAll( "reloadanim", optionalAnimation, %body, 1, .1, 1 );
		animscripts\shared::DoNoteTracks( "reloadanim" );
		self animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in theory.
		self.a.needsToRechamber = 0;
	}
	else
	{
		if (self.a.pose == "prone")
		{
			self setFlaggedAnimKnobAll("reloadanim",%reload_prone_rifle, %body, 1, .1, 1);
			self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.1, 1);
		}
		else 
		{
			println ("Bad anim_pose in combat::Reload");
			wait 2;
			return;
		}
		animscripts\shared::DoNoteTracks("reloadanim");
		animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in most instances.
		self.a.needsToRechamber = 0;
		self clearanim(%upperbody, .1);		// Only needed for the upper body running reload.
	}

	return true;
}

getGrenadeThrowOffset( throwAnim )
{
	offset = (0, 0, 64);
	
	if ( isdefined( throwAnim ) )
	{
		// generated with scr_testgrenadethrows in combat.gsc
		// TODO: these numbers are obviously wrong. must look at scr_testgrenadethrows functionality and regenerate them.
		if      ( throwAnim == %exposed_grenadethrowb ) offset = (387.499, 149.969, 8.33731);
		else if ( throwAnim == %exposed_grenadethrowc ) offset = (379.23, 141.293, 10.1736);
		else if ( throwAnim == %corner_standl_grenade_a ) offset = (388.176, 103.652, 17.6033);
		else if ( throwAnim == %corner_standl_grenade_b ) offset = (375.085, 87.7697, -34.5773);
		else if ( throwAnim == %cornercrl_grenadea ) offset = (379.532, 85.9659, -33.3955);
		else if ( throwAnim == %cornercrl_grenadeb ) offset = (434.893, 86.5731, 0.501427);
		else if ( throwAnim == %corner_standr_grenade_a ) offset = (378.364, 79.0133, 12.6993);
		else if ( throwAnim == %corner_standr_grenade_b ) offset = (403.426, 64.9875, -47.3735);
		else if ( throwAnim == %cornercrr_grenadea ) offset = (393.651, 44.5235, -39.2894);
		else if ( throwAnim == %covercrouch_grenadea ) offset = (387.347, 86.0928, -3.77436);
		else if ( throwAnim == %covercrouch_grenadeb ) offset = (387.347, 86.0928, -3.77436);
		else if ( throwAnim == %coverstand_grenadea ) offset = (395.072, 73.5404, 13.3603);
		else if ( throwAnim == %coverstand_grenadeb ) offset = (393.564, 65.2286, 9.35239);
		else if ( throwAnim == %prone_grenade_a ) offset = (383.835, 78.2458, -61.5018);
	}
	
	if ( offset[2] == 64 )
	{
		if ( isdefined( throwAnim ) )
			println( "^1Warning: undefined grenade throw animation used; hand offset unknown" );
		else
			println( "^1Warning: grenade throw animation ", throwAnim, " has no recorded hand offset" );
	}
	
	return offset;
}

// this function is called from maps\_utility::ThrowGrenadeAtPlayerASAP
ThrowGrenadeAtPlayerASAP_combat_utility()
{
	if ( !isdefined( anim.someoneIsTryingToThrowGrenadeAtPlayer ) )
		anim.lastPlayerGrenade = 0;
	anim.throwGrenadeAtPlayerASAP = true;
	
	/#
	enemies = getaiarray("axis");
	if ( enemies.size == 0 )
		return;
	numwithgrenades = 0;
	for ( i = 0; i < enemies.size; i++ )
	{
		if ( enemies[i].grenadeammo > 0 )
			return;
	}
	println("^1Warning: called ThrowGrenadeAtPlayerASAP, but no enemies have any grenadeammo!");
	#/
}

grenadeCoolDownElapsed( throwingAt )
{
	if (self.script_forcegrenade == 1)
		return true;
	
	timer = getTime();
	
	if ( isalive(throwingAt) && throwingAt != level.player )
		return (timer >= anim.nextAIGrenade);
	
	return (timer >= anim.lastPlayerGrenade);
}

isGrenadePosSafe( throwingAt, destination )
{
	if ( isdefined( anim.throwGrenadeAtPlayerASAP ) && throwingAt == level.player )
		return true;
	
	distanceThreshold = 200;
	if ( self.grenadeWeapon == "flash_grenade" )
		distanceThreshold = 512;
	distanceThresholdSq = distanceThreshold * distanceThreshold;
	
	closest = undefined;
	closestdist = 100000000;
	secondclosest = undefined;
	secondclosestdist = 100000000;
	
	for ( i = 0; i < self.squad.members.size; i++ )
	{
		if ( !isalive( self.squad.members[i] ) )
			continue;
		dist = distanceSquared( self.squad.members[i].origin, destination );
		if ( dist > distanceThresholdSq )
			continue;
		if ( dist < closestdist )
		{
			secondclosestdist = closestdist;
			secondclosest = closest;
			closestdist = dist;
			closest = self.squad.members[i];
		}
		else if ( dist < secondclosestdist )
		{
			secondclosestdist = dist;
			secondclosest = self.squad.members[i];
		}
	}
	
	if ( isdefined( closest ) && sightTracePassed( closest getEye(), destination, false, undefined ) )
		return false;
	if ( isdefined( secondclosest ) && sightTracePassed( closest getEye(), destination, false, undefined ) )
		return false;
	
	return true;
}

TryGrenadePosProc( throwingAt, destination, optionalAnimation, armOffset, smokeGrenade )
{
	// Dont throw a grenade right near you or your buddies
	if ( !smokeGrenade && !isGrenadePosSafe( throwingAt, destination ) )
		return false;
	else if ( distanceSquared( self.origin, destination ) < 200 * 200 )
		return false;
	
	trace = physicsTrace( destination + (0,0,1), destination + (0,0,-500) );
	if ( trace == destination + (0,0,-500) )
		return false;
	trace += (0,0,.1); // ensure just above ground
	
	return TryGrenadeThrow( throwingAt, trace, optionalAnimation, armOffset, smokeGrenade);
}

TrySmokeGrenadePos( throwingAt, destination, optionalAnimation, armOffset )
{
	if ( self.weapon == "mg42" || self.grenadeammo <= 0 )
		return false;
	
	return TryGrenadePosProc( self.enemy, destination, optionalAnimation, armOffset, true );
}

TryGrenade( throwingAt, optionalAnimation )
{
	if ( self.weapon=="mg42" || self.grenadeammo <= 0 )
		return false;

	if ( !grenadeCoolDownElapsed( throwingAt ) )
		return false;
	
	armOffset = getGrenadeThrowOffset( optionalAnimation );
	
	if ( isdefined( self.enemy ) && throwingAt == self.enemy )
	{
		if ( self canSeeEnemyFromExposed() )
		{
			if ( !isGrenadePosSafe( throwingAt, throwingAt.origin ) )
				return false;
			return TryGrenadeThrow( throwingAt, undefined, optionalAnimation, armOffset, false );
		}
		else if ( self canSuppressEnemyFromExposed() )
		{
			return TryGrenadePosProc( throwingAt, self getEnemySightPos(), optionalAnimation, armOffset, false );
		}
		else if ( isPlayer( throwingAt ) && isdefined( anim.throwGrenadeAtPlayerASAP ) )
		{
			if ( !isGrenadePosSafe( throwingAt, throwingAt.origin ) )
				return false;
			return TryGrenadeThrow( throwingAt, undefined, optionalAnimation, armOffset, false );
		}
		
		return false; // didn't know where to throw!
	}
	else
	{
		return TryGrenadePosProc( throwingAt, throwingAt.origin, optionalAnimation, armOffset, false );
	}
}

TryGrenadeThrow( throwingAt, destination, optionalAnimation, armOffset, smokeGrenade )
{
	// no AI grenade throws in the first 10 seconds, bad during black screen
	if (gettime() < 10000)
		return false;
	if (isDefined(optionalAnimation))
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
				throw_anim = %stand_grenade_throw;
			}
			else // if (self.a.pose == "crouch")
			{
				armOffset = (0,0,65);
				throw_anim = %crouch_grenade_throw;
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
	if (!isDefined(throw_anim))
	{
		return (false);
	}

	if (isdefined (destination)) // Now try to throw it.
	{
		throwvel = self checkGrenadeThrowPos(armOffset, "min energy", destination);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrowPos(armOffset, "min time", destination);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrowPos(armOffset, "max time", destination);		
			
		// Allow smoke grenades to be thrown as far as required as they are designer scripted
		if (!isdefined(throwvel) && smokeGrenade )
			throwvel = self checkGrenadeThrowPos(armOffset, "infinite energy", destination);
	}
	else
	{
		throwvel = self checkGrenadeThrow(armOffset, "min energy");
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrow(armOffset, "min time");
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrow(armOffset, "max time");
	}
	
	/*
	if ( !isdefined( throwvel ) )
	{
		if ( isdefined( destination ) )
			animscripts\utility::showDebugLine( self.origin, destination, (1,.5,1), 5 );
		else
			animscripts\utility::showDebugLine( self.origin, throwingAt.origin, (1,.5,.5), 5 );
		println("Grenade throw failed: couldn't find a throw velocity");
	}
	else
	{
		if ( isdefined( destination ) )
			animscripts\utility::showDebugLine( self.origin, destination, (.5,1,1), 5 );
		else
			animscripts\utility::showDebugLine( self.origin, throwingAt.origin, (.5,1,.5), 5 );
	}
	*/

	if ( isdefined(throwvel) )
	{
		if (!isdefined(self.oldGrenAwareness))
			self.oldGrenAwareness = self.grenadeawareness;
		self.grenadeawareness = 0; // so we dont respond to nearby grenades while throwing one
		
		/#
		if (getdebugdvar ("anim_debug") == "1")
			thread animscripts\utility::debugPos(destination, "O");

		#/
		
		lastGrenadeTimeToUse = undefined;
		
		// remember the time we want to delay any future grenade throws to, to avoid throwing too many.
		// however, for now, only set the timer far enough in the future that it will expire when we throw the grenade.
		// that way, if the throw fails (maybe due to killanimscript), we'll try again soon.
		if ( isalive(throwingAt) && isPlayer( throwingAt ) )
		{
			if (!smokeGrenade)
			{
				anim.someoneIsTryingToThrowGrenadeAtPlayer = true;
				lastGrenadeTimeToUse = gettime() + anim.playerGrenadeBaseTime + randomint(anim.playerGrenadeRangeTime);
				anim.lastPlayerGrenade = min( gettime() + 5000, lastGrenadeTimeToUse );
			}
		}
		else
		{
			// Schedule the next earliest AI grenade for 1 to 2 minutes into the future
			lastGrenadeTimeToUse = gettime() + 60000 + randomint(60000);
			
			anim.nextAIGrenade = gettime() + 2000;
		}
		/#
		if ( getdvar( "grenade_spam" ) == "on" )
			lastGrenadeTimeToUse = undefined;
		#/
		

		self animscripts\battleChatter_ai::evaluateAttackEvent("grenade");
		self notify ("stop_aiming_at_enemy");
		self SetFlaggedAnimKnobAllRestart("throwanim", throw_anim, %body, 1, 0.1, 1);

		self thread animscripts\shared::DoNoteTracksForever("throwanim", "killanimscript");
		self.isHoldingGrenade = true;
		self thread prepGrenade();
		if (smokeGrenade && isdefined (self.smoke_destination_org))
			level.smoke_thrower["smoke"+self.smoke_destination_org] = self;

		model = getGrenadeModel();
		
		attachside = "none";
		for (;;)
		{
			self waittill("throwanim", notetrack);
			if ( notetrack == "grenade_left" || notetrack == "grenade_right" )
				attachside = attachGrenadeModel(model, "TAG_INHAND");
			if ( notetrack == "grenade_throw" || notetrack == "grenade throw" )
				break;
			assert(notetrack != "end"); // we shouldn't hit "end" until after we've hit "grenade_throw"!
			if ( notetrack == "end" ) // failsafe
				return false;
		}

		/#
			if (getdebugdvar("debug_grenadehand") == "on")
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
						continue;
					iprintlnbold ("Grenade throw needs fixing (check console)");
					println ("Grenade throw animation ", throw_anim, " has multiple weapons attached to ", tags[i]);
					break;
				}
			}
		#/
		
		if ( isdefined( lastGrenadeTimeToUse ) && isalive(throwingAt) && isPlayer( throwingAt ) )
		{
			// give the grenade some time to get to the player.
			// if it gets there, we'll reset the timer so we don't throw any more in a while.
			self thread watchGrenadeTowardsPlayer( lastGrenadeTimeToUse );
		}

		self throwGrenade();
		
		
		if ( !isalive(throwingAt) || !isPlayer( throwingAt ) )
		{
			if ( isdefined( lastGrenadeTimeToUse ) )
				anim.nextAIGrenade = lastGrenadeTimeToUse;
		}
		
		
		self notify ("stop grenade check");
		
//		assert (attachSide != "none");
		if (attachSide != "none")		
			self detach(model, attachside);
		else
		{
			print ("No grenade hand set: ");
			println (throw_anim);
			println("animation in console does not specify grenade hand");
		}
		self.isHoldingGrenade = false;

		self.grenadeawareness = self.oldGrenAwareness;
		self.oldGrenAwareness = undefined;
		
		self waittillmatch("throwanim", "end");
		// modern
		
		// TODO: why is this here? why are we assuming that the calling function wants these particular animnodes turned on?
		self setanim(%exposed_modern,1,.2);
		self setanim(%exposed_aiming,1);
		self clearanim(throw_anim,.2);
        return (true);
	}
	else
	{
	/#
		if (getdebugdvar("debug_grenademiss") == "on" && isdefined (destination))
			thread grenadeLine(armoffset, destination);
	#/		
	}
	return (false);
}

watchGrenadeTowardsPlayer( lastGrenadeTimeToUse )
{
	level.player endon("death");
	level.player thread resetTryingToThrowGrenadeAtPlayerOnDeath();
	
	level notify("watchGrenadeTowardsPlayerTimeout"); // just in case
	
	// give the grenade at least 5 seconds to land
	anim.lastPlayerGrenade = min( gettime() + 5000, lastGrenadeTimeToUse );
	level thread watchGrenadeTowardsPlayerTimeout( 5 );
	level endon("watchGrenadeTowardsPlayerTimeout");
	
	grenade = self getGrenadeIThrew();
	if ( !isdefined( grenade ) )
	{
		// the throw failed. maybe we died. =(
		// try again soon!
		anim.lastPlayerGrenade = 0;
		anim.someoneIsTryingToThrowGrenadeAtPlayer = undefined;
		level notify("reset_someoneIsTryingToThrowGrenadeAtPlayer");
		return;
	}
	grenade endon("death");
	grenade thread resetTryingToThrowGrenadeAtPlayerOnDeath();
	
	// wait for grenade to settle
	prevorigin = grenade.origin;
	while(1)
	{
		wait .1;
		
		// (temp fix for grenades not getting death notify on throwback)
		if ( !isdefined( grenade ) )
		{
			grenade notify("death");
			return;
		}
		
		if ( grenade.origin == prevorigin )
		{
			if ( distanceSquared( grenade.origin, level.player.origin ) < 170 * 170 || distanceSquared( grenade.origin, level.player.origin ) > 400 * 400 )
				break;
		}
		prevorigin = grenade.origin;
	}
	
	anim.someoneIsTryingToThrowGrenadeAtPlayer = undefined;
	level notify("reset_someoneIsTryingToThrowGrenadeAtPlayer");
	
	if ( distanceSquared( grenade.origin, level.player.origin ) < 170 * 170 )
	{
		// the grenade landed near the player! =D
		level notify("threw_grenade_at_player");
		anim.throwGrenadeAtPlayerASAP = undefined;
		anim.lastPlayerGrenade = lastGrenadeTimeToUse;
	}
}

resetTryingToThrowGrenadeAtPlayerOnDeath()
{
	level endon("reset_someoneIsTryingToThrowGrenadeAtPlayer");
	
	self waittill("death");
	anim.lastPlayerGrenade = 0;
	anim.someoneIsTryingToThrowGrenadeAtPlayer = undefined;
	
	level notify("reset_someoneIsTryingToThrowGrenadeAtPlayer");
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
	level notify("watchGrenadeTowardsPlayerTimeout");
}


attachGrenadeModel(model, tag)
{
	self attach (model, tag);
	thread detachOnScriptChange(model, tag);
	return tag;
}


detachOnScriptChange(model, tag)
{
	self endon ("death");
	self endon ("stop grenade check");
	self waittill ("killanimscript");
	if (isdefined(self.oldGrenAwareness))
	{	
		self.grenadeawareness = self.oldGrenAwareness;
		self.oldGrenAwareness = undefined;
	}
	
	self detach(model, tag);
}

offsetToOrigin(start)
{
	forward = anglestoforward(self.angles);
	right = anglestoright(self.angles);
	up = anglestoup(self.angles);
	forward = vectorScale (forward, start[0]);
	right = vectorScale (right, start[1]);
	up = vectorScale (up, start[2]);
	return (forward + right + up);
}

grenadeLine(start, end)
{
	level notify ("armoffset");
	level endon ("armoffset");
	
	start = self.origin + offsetToOrigin(start);
	for (;;)
	{
		line (start, end, (1,0,1));
		print3d (start, start, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		print3d (end, end, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}
}

prepGrenade()
{
	self endon ("stop grenade check");
	self endon ("killanimscript");
	
	prepGrenadeCheck();
	
	self MagicGrenadeManual (self.origin + (0,0,35), self.origin + randomvector(100), 2.5);
	self.grenadeammo--;
}

prepGrenadeCheck()
{
    self endon ("anim entered exposed");
    self endon ("anim entered pain");
	self waittill ("killanimscript");
}

// For use by combat scripts, looks at the enemy until the script is interrupted, or "stop EyesAtEnemy" is notified.
EyesAtEnemy()
{
	self notify ("stop EyesAtEnemy internal");	// Prevent buildup of threads.
	self endon ("death");
	self endon ("stop EyesAtEnemy internal");
	for (;;)
	{
		if (isDefined(self.enemy))
			self animscripts\shared::LookAtEntity(self.enemy, 2, "alert", "eyes only", "don't interrupt");
		wait 2;
	}
}

FindCoverNearSelf()
{
	oldKeepNodeInGoal = self.keepClaimedNodeInGoal;
	oldKeepNode = self.keepClaimedNode;
	self.keepClaimedNodeInGoal = false;
	self.keepClaimedNode = false;
	
	node = self findbestcovernode();
	
	if ( isdefined( node ) )
	{
		if ( self.a.script != "combat" || animscripts\combat::shouldGoToNode( node ) )
		{
			if ( self UseCoverNode( node ) )
				return true;
		}
	}
	
	self.keepClaimedNodeInGoal = oldKeepNodeInGoal;
	self.keepClaimedNode = oldKeepNode;
	return false;
}

smoke_grenade ( optionalAnim, optionalOffset)
{
	org = self.smoke_destination_org;
	if (isdefined (level.smoke_thrower["smoke"+org]))
	{
		// So you dont go cutting into move or whatever and breaking your smoke throw
		if (level.smoke_thrower["smoke"+org] == self)
		{
			// Point him towards the grenade point
			myYawFromTarget = VectorToAngles(org - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1] );
			level waittill ("smoke_was_thrown"+org);
		}
			
		return;
	}
	self thread deathSmokeRenew(org);
	self endon("killanimscript");
//	self endon (anim.scriptChange);
	level endon ("smoke_was_thrown"+org);
	// Give him a smoke grenade
	if (isdefined(level.smoke_grenade_weapon))
		self.grenadeWeapon = level.smoke_grenade_weapon;
	else
		self.grenadeWeapon = "smoke_grenade_american";
	self.grenadeAmmo++;
	
	// Point him towards the grenade point
	myYawFromTarget = VectorToAngles(org - self.origin );
	self OrientMode( "face angle", myYawFromTarget[1] );
	
	//give him time to get aimed towards it
//		wait (0.25);
	// escape endons
	thread smoke_grenade_throw(org, optionalAnim, optionalOffset);
	self waittill ("could or could not throw smoke");
}


smoke_grenade_throw(org, optionalAnim, optionalOffset)
{
	self endon ("death");
	// Spawn it off as a separate function so that regardless of what happens, we take the grenade away and
	// do the notify.
	smoke_grenade_throwProc(org, optionalAnim, optionalOffset);
	self notify ("could or could not throw smoke");
	// Take the grenade back
	self.grenadeAmmo--;
}

smoke_grenade_throwProc(org, optionalAnim, optionalOffset)
{
	self endon ("killanimscript");
	if ((self TrySmokeGrenadePos(org, optionalAnim, optionalOffset)))
	{
		self notify ("could or could not throw smoke");
		// notify the group
		level.smoke_thrower["smoke"+org] = undefined;
		level.smoke_thrown["smoke"+org] = true;
		level notify ("smoke_was_thrown"+org);
		// throw was a success
		return;
	}
}

deathSmokeRenew(org)
{
	wait (1.8);
	if (!isdefined(level.smoke_thrower["smoke"+org]))
		return;
	
	if (isalive(self) && level.smoke_thrower["smoke"+org] == self)
	{
		level.smoke_thrower["smoke"+org] = undefined;
		return;
	}
	
	if (!isalive(level.smoke_thrower["smoke"+org]))
	{
		level.smoke_thrower["smoke"+org] = undefined;
		return;
	}
}


lookForBetterCover()
{
	// don't do cover searches if we don't have an enemy.
	if ( !isValidEnemy( self.enemy ) )
		return false;
		
	if ( self.fixedNode )
		return false;
	
	node = self getBestCoverNodeIfAvailable();
	
	if ( isdefined( node ) )
		return useCoverNodeIfPossible( node );
	
	return false;
}

getBestCoverNodeIfAvailable()
{
	node = self FindBestCoverNode();
	
	if ( !isdefined(node) )
		return undefined;

	currentNode = self GetClaimedNode();
	if ( isdefined( currentNode ) && node == currentNode )
		return undefined;

	if ( self.a.script == "combat" && !animscripts\combat::shouldGoToNode( node ) )
		return undefined;
	
	return node;
}

useCoverNodeIfPossible( node )
{
	oldKeepNodeInGoal = self.keepClaimedNodeInGoal;
	oldKeepNode = self.keepClaimedNode;
	self.keepClaimedNodeInGoal = false;
	self.keepClaimedNode = false;

	if ( self UseCoverNode(node) )
	{
		return true;
	}
	
	self.keepClaimedNodeInGoal = oldKeepNodeInGoal;
	self.keepClaimedNode = oldKeepNode;
	
	return false;
}

// this function seems okish,
// but the idea behind FindReacquireNode() is that you call it once,
// and then call GetReacquireNode() many times until it returns undefined.
// if we're just taking the first node (the best), we might as well just be using
// FindBestCoverNode().
/*
tryReacquireNode()
{
	self FindReacquireNode();
	node = self GetReacquireNode();
	if (!isdefined(node))
		return false;
	return (self UseReacquireNode(node));
}
*/

tryRunningToEnemy()
{
	if ( !isValidEnemy( self.enemy ) )
		return false;
	
	if ( !self isingoal( self.enemy.origin ) )
		return false;
		
	if ( self.fixedNode )
		return false;
	
	self FindReacquireDirectPath();
	
	// TrimPathToAttack is supposed to be called multiple times, until it returns false.
	// it trims the path a little more each time, until trimming it more would make the enemy invisible from the end of the path.
	// we're skipping this step and just running until we get within close range of the enemy.
	// maybe later we can periodically check while moving if the enemy is visible, and if so, enter exposed.
	//self TrimPathToAttack();
	
	if ( self ReacquireMove() )
	{
		self.keepClaimedNodeInGoal = false;
		self.keepClaimedNode = false;
		
		return true;
	}
	
	return false;
}

delayedBadplace(org)
{
	self endon ("death");
	wait (0.5);
	/#
		if (getdebugdvar("debug_displace") == "on")
			thread badplacer(5, org, 16);
	#/
	
	string = "" + anim.badPlaceInt;
	badplace_cylinder(string, 5, org, 16, 64, self.team);
	anim.badPlaces[anim.badPlaces.size] = string;
	if (anim.badPlaces.size >= 10) // too many badplaces, delete the oldest one and then remove it from the array
	{
		newArray = [];
		for (i=1;i<anim.badPlaces.size;i++)
			newArray[newArray.size] = anim.badPlaces[i];
		badplace_delete(anim.badPlaces[0]);
		anim.badPlaces = newArray;
	}
	anim.badPlaceInt++;
	if (anim.badPlaceInt > 10)
		anim.badPlaceInt-= 20;
}

valueIsWithin(value,min,max)
{
	if(value > min && value < max)
		return true;
	return false;	
}

getGunYawToShootEntOrPos()
{
	if ( !isdefined( self.shootPos ) )
	{
		assert( !isdefined( self.shootEnt ) );
		return 0;
	}
	
	yaw = self gettagangles("tag_weapon")[1] - GetYaw( self.shootPos );
	yaw = AngleClamp180( yaw );
	return yaw;
}

getGunPitchToShootEntOrPos()
{
	if ( !isdefined( self.shootPos ) )
	{
		assert( !isdefined( self.shootEnt ) );
		return 0;
	}
	
	pitch = self gettagangles("tag_weapon")[0] - VectorToAngles( self.shootPos - self gettagorigin("tag_weapon") )[0];
	pitch = AngleClamp180( pitch );
	return pitch;
}

getPitchToEnemy()
{
	if(!isdefined(self.enemy))
		return 0;
	
	vectorToEnemy = self.enemy getshootatpos() - self getshootatpos();	
	vectorToEnemy = vectornormalize(vectortoenemy);
	pitchDelta = 360 - vectortoangles(vectorToEnemy)[0];
	
	return AngleClamp180( pitchDelta );
}

getPitchToSpot(spot)
{
	if(!isdefined(spot))
		return 0;
	
	vectorToEnemy = spot - self getshootatpos();	
	vectorToEnemy = vectornormalize(vectortoenemy);
	pitchDelta = 360 - vectortoangles(vectorToEnemy)[0];
	
	return AngleClamp180( pitchDelta );
}

anim_set_next_move_to_new_cover()
{
	self.a.next_move_to_new_cover = randomintrange( 1, 4 );
}

watchReloading()
{
	// this only works on the player.
	self.isreloading = false;
	while(1)
	{
		self waittill("reload_start");
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
			break;
		
		if ( self getCurrentWeaponClipAmmo() >= weaponClipSize( weap ) )
			break;
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
		if ( !isdefined( self.enemy ) || !isalive( self.enemy ) )
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
	
	while ( 1 )
	{
		self.enemy waittill("flashed");
		
		if ( distanceSquared( self.origin, self.enemy.origin ) > 1024*1024 )
			continue;
		
		if ( !self isingoal( self.enemy.origin ) )
			continue;
		
		while ( gettime() < self.enemy.flashendtime - 500 )
		{
			if ( !self cansee( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 700*700 )
				tryRunningToEnemy();
			
			wait .5;
		}
	}
}


startFlashBanged()
{
	percent = self getFlashBangedStrength();
	if ( !isdefined( self.flashduration ) )
		duration = 4500 * percent;
	else
		duration = self.flashduration;
	self.flashendtime = gettime() + duration;
	self notify("flashed");
	
	return duration;
}