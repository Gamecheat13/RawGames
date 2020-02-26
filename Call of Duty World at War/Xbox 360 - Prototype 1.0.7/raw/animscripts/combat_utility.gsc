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
		dist = 500;	// Arbitrary values for now
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

pauseIfPlayerIsInvulAndYouAreAPauseGuy()
{
	if (1) return;
	// dont shoot at invulnerable player
	if (isalive(self.enemy) && self.enemy == level.player)
	{
		if (flag("player_is_invulnerable") && !self.a.nonstopFire)
		{
			flag_waitopen("player_is_invulnerable");
			resetMissDebounceTime();
		}
	}
}

getBurstDelayTime()
{
	if ( self usingSidearm() )
		return ( .15 + randomFloat( .4 ) );
	else
		return .4 + randomfloat(.5);
}
burstDelay()
{
	// small pause so we dont move while still showing the firing effect 
	if ( self.bulletsInClip )
		wait getBurstDelayTime();
}

FireUntilOutOfAmmo( fireAnim, stopOnAnimationEnd, maxshots )
{
	animName = "fireAnim";
	
	// first, wait until we're aimed right
	while( !aimedAtShootEntOrPos() )
		wait .05;
	
	self setAnim( %additive,1, .1, 1 );
	if ( isDefined( maxShots ) && (maxShots == 1 || self.shootStyle == "semi") )
		self setFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, 1 );
	else if ( isDefined( maxShots ) )
		self setFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, 1 );
//		self setFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, animscripts\weaponList::burstShootAnimRate() );
	else
		self setFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, animscripts\weaponList::autoShootAnimRate() );

	// Update the sight accuracy against the player.  Should be called before the volley starts.
	self updatePlayerSightAccuracy();

	FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots );
	
	self clearAnim( %additive, .2 );
}

FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots )
{
	if ( stopOnAnimationEnd )
	{
		self thread NotifyOnAnimEnd( animName, "fireAnimEnd" );
		self endon( "fireAnimEnd" );
	}
	
	numshots = 0;
	
	hasFireNotetrack = animHasNoteTrack( fireAnim, "fire" );
	
	while(1)
	{
		if ( hasFireNotetrack )
			self waittillmatch( animName, "fire" );
		
		if ( !self.bulletsInClip || (isdefined(maxshots) && numshots == maxshots) )
			break;
		
		if ( aimedAtShootEntOrPos() )
		{
			self shootAtShootEntOrPos();
			self.bulletsInClip--;
			
			if ( weaponClass( self.weapon ) == "rocketlauncher" )
				self.a.rockets--;
		}
		numshots++;
		
		if ( !hasFireNotetrack )
			self waittillmatch( animName, "end" );
	}
	
	if ( stopOnAnimationEnd )
		self notify( "fireAnimEnd" ); // stops NotifyOnAnimEnd()
}

aimedAtShootEntOrPos()
{
	gunyaw   = self getGunYawToShootEntOrPos();
	gunpitch = self getGunPitchToShootEntOrPos();
	return (gunyaw <= 10) && (gunyaw >= -10) && (gunpitch <= 20) && (gunpitch >= -20);
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
			self shootWrapper();
		else
			self shootWrapper( self.shootEnt getShootAtPos() );
	}
	else
	{
		// if self.shootPos isn't defined, "shoot_behavior_change" should
		// have been notified and we shouldn't be firing anymore
		assert( isdefined( self.shootPos ) );
		
		self shootWrapper( self.shootPos );
	}
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
	if (!isDefined(thresholdFraction))
		thresholdFraction = 0;

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

	if ( usingBoltActionWeapon() )
		thread maps\_gameSkill::resetAccuracyBolt(); // So the first shot doesnt hit

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
			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
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

TryGrenadePosProc( destination, optionalAnimation, armOffset, smokeGrenade )
{
	// Dont throw a grenade right near you or your buddies
	if ( !smokeGrenade )
	{
		for ( i = 0; i < self.squad.members.size; i++ )
		{
			if ( !isalive( self.squad.members[i] ) )
				continue;
			if ( distance( self.squad.members[i].origin, destination ) < 200 )
				return false;
		}
	}
	else if ( distance( self.origin, destination ) < 200 )
		return false;
	
	if ( self.weapon == "mg42" || self.grenadeammo <= 0 )
		return false;
	
	trace = physicsTrace( destination + (0,0,1), destination + (0,0,-500) );
	if ( trace == destination + (0,0,-500) )
		return false;
	trace += (0,0,.1); // ensure just above ground
	
	return TryGrenadeThrow(trace, optionalAnimation, armOffset, smokeGrenade);
}

TrySmokeGrenadePos(destination, optionalAnimation, armOffset)
{
	return TryGrenadePosProc(destination, optionalAnimation, armOffset, true);
}

grenadeCoolDownElapsed()
{
	if (self.script_forcegrenade == 1)
		return true;
		
	timer = getTime();
	// Significantly reduced chance of AI throwing grenades at AI.
	if (isalive(self.enemy) && self.enemy != level.player)
		return (timer >= anim.nextAIGrenade);

/*
	if (level.gameSkill >= 3)
		return true;
*/
	return (timer >= anim.lastPlayerGrenade);
}		


TryGrenadePos(destination, optionalAnimation, armOffset)
{
	if (!grenadeCoolDownElapsed())
		return false;

	return (TryGrenadePosProc(destination, optionalAnimation, armOffset, false));
}

TryGrenade(optionalAnimation, armOffset/*, gunHand*/)
{
	if (self.weapon=="mg42" || self.grenadeammo <= 0)
		return false;

	if (!grenadeCoolDownElapsed())
		return false;

 // true/false is smokegrenade
 	return TryGrenadeThrow(undefined, optionalAnimation, armOffset, false);
}

TryGrenadeThrow( destination, optionalAnimation, armOffset, smokeGrenade )
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
			animscripts\utility::showDebugLine( self.origin, self.enemy.origin, (1,.5,.5), 5 );
		println("Grenade throw failed: couldn't find a throw velocity");
	}
	else
	{
		if ( isdefined( destination ) )
			animscripts\utility::showDebugLine( self.origin, destination, (.5,1,1), 5 );
		else
			animscripts\utility::showDebugLine( self.origin, self.enemy.origin, (.5,1,.5), 5 );
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

		if ( isalive(self.enemy) && self.enemy == level.player )
		{
			if (!smokeGrenade)
				anim.lastPlayerGrenade = gettime() + anim.playerGrenadeBaseTime + randomint(anim.playerGrenadeRangeTime);
				
			/#
			if ( getdvar( "grenade_spam" ) == "on" )
				anim.lastPlayerGrenade = 0;
			#/
		}
		else
		{
			// Schedule the next earliest AI grenade for 1 to 2 minutes into the future
			anim.nextAIGrenade = gettime() + 60000 + randomint(60000);
			/#
			if ( getdvar( "grenade_spam" ) == "on" )
				anim.nextAIGrenade = 0;
			#/
		}
		

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
			if ( notetrack == "grenade_left" )
				attachside = attachGrenadeModel(model, "TAG_WEAPON_LEFT");
			if ( notetrack == "grenade_right" )
				attachside = attachGrenadeModel(model, "TAG_WEAPON_RIGHT");
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

		self throwGrenade();
		
		
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
	self endon("killanimscript");
	prepGrenadeCheck();
	self MagicGrenadeManual (self.origin + (0,0,35), self.origin + randomvector(100), 2.5);
	self.grenadeammo--;
}

prepGrenadeCheck()
{
    self endon ("anim entered exposed");
    self endon ("anim entered pain");
	self endon("killanimscript");
    self waittill ("the end of time");
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
	
	node = self FindBestCoverNode();
	
	if ( !isdefined(node) )
		return false;

	currentNode = self GetClaimedNode();
	if ( isdefined( currentNode ) && node == currentNode )
		return false;

	if ( self.a.script == "combat" && !animscripts\combat::shouldGoToNode( node ) )
		return false;
	
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
	// TODO: this cuts out 50% of guys. do we really want this if?
	if ( !self.a.reacquireGuy )
		return false;

	if ( !isValidEnemy( self.enemy ) )
		return false;

	if ( !self isingoal( self.enemy.origin ) )
		return false;
	
	if ( self canSeeEnemyFromExposed() )
		return false;
	
	self FindReacquireDirectPath();
	
	// TrimPathToAttack is supposed to be called multiple times, until it returns false.
	// it trims the path a little more each time, until trimming it more would make the enemy invisible from the end of the path.
	// we're skipping this step and just running until we get within close range of the enemy.
	// maybe later we can periodically check while moving if the enemy is visible, and if so, enter exposed.
	//self TrimPathToAttack();
	
	return self ReacquireMove();
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
	yaw = AngleClamp(yaw, "-180 to 180");
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
	pitch = AngleClamp(pitch, "-180 to 180");
	return pitch;
}

getPitchToEnemy()
{
	if(!isdefined(self.enemy))
		return 0;
	
	vectorToEnemy = self.enemy getshootatpos() - self getshootatpos();	
	vectorToEnemy = vectornormalize(vectortoenemy);
	pitchDelta = 360 - vectortoangles(vectorToEnemy)[0];
	
	return AngleClamp( pitchDelta, "-180 to 180" );
}

getPitchToSpot(spot)
{
	if(!isdefined(spot))
		return 0;
	
	vectorToEnemy = spot - self getshootatpos();	
	vectorToEnemy = vectornormalize(vectortoenemy);
	pitchDelta = 360 - vectortoangles(vectorToEnemy)[0];
	
	return AngleClamp( pitchDelta, "-180 to 180" );
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
