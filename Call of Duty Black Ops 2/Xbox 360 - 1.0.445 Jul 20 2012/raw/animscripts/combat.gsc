#include animscripts\Utility;
#include animscripts\Debug;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include animscripts\shared;
#include animscripts\anims;
#include common_scripts\Utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;


#using_animtree("generic_human");

main()
{
	self endon("killanimscript");

	[[ self.exception[ "exposed" ] ]]();

	animscripts\utility::initialize("combat");

	CombatInit();

	//dds see someone to shoot
	//Print3d(self.origin, "I got Movement!",(1.0,0.8,0.5),1,1,60);
	self maps\_dds::dds_notify( "thrt_movement", ( self.team != "allies" ) );		

	self transitionToCombat();
	self setup();
	self exposedCombatMainLoop();
	

	self notify( "stop_deciding_how_to_shoot" );
}

CombatInit()
{
	self.a.arrivalType = undefined;

	if( IsDefined( self.node ) && IsDefined( anim.isAmbushNode[ self.node.type ] ) && self NearNode( self.node ) )
		self.ambushNode = self.node;
}

CombatGlobalsInit()
{
	if( !IsDefined( anim.combatGlobals ) )
	{
		anim.combatGlobals = SpawnStruct();

		anim.combatGlobals.MIN_EXPOSED_GRENADE_DIST		   = 750;
		anim.combatGlobals.MIN_EXPOSED_GRENADE_DIST_PLAYER = 500;
		anim.combatGlobals.MIN_EXPOSED_GRENADE_DISTSQ	   = 500 * 500;
		anim.combatGlobals.MAX_GRENADE_THROW_DISTSQ		   = 1250 * 1250;
		anim.combatGlobals.MAX_FLASH_GRENADE_THROW_DISTSQ  = 768 * 768;
		anim.combatGlobals.PISTOL_PULLOUT_DISTSQ		   = 400 * 400;
		anim.combatGlobals.PISTOL_PUTBACK_DISTSQ		   = 512 * 512;
	}
}

//--------------------------------------------------------------------------------
// Initial setup for combat
//--------------------------------------------------------------------------------
transitionToCombat()
{	
	if( self.a.prevScript == "stop" && self.a.pose == "stand" && !ISCQB(self) && !ISHEAT(self) && self.animType == "default" )
	{
		if( animArrayExist( "idle_trans_out" ) )
		{
			self animmode( "zonly_physics" );
			self setFlaggedAnimKnobAllRestart( "transition", animArray( "idle_trans_out" ), %root, 1, 0.2, 1.2 * self.animplaybackrate );
			self animscripts\shared::DoNoteTracks( "transition" );
		}
	}
}

setup()
{
	if ( AI_USINGSIDEARM(self) && self isStanceAllowed( "stand" ) )
		transitionTo("stand");

	self set_aimturn_limits();

	self thread stopShortly();
	
	self ClearAnim( %root, .2 );
	self SetAnim( animarray("straight_level") );

	self ClearAnim( %aim_4, .2 );
	self ClearAnim( %aim_6, .2 );
	self ClearAnim( %aim_2, .2 );
	self ClearAnim( %aim_8, .2 );

	setupAim(.2);

	self thread idleThread();
}

set_aimturn_limits()
{
	switch(self.a.pose)
	{
		case "stand":
		case "crouch":
			self.turnThreshold = 35;
			break;
		case "prone":
			assert(!AI_USINGSIDEARM(self));
			self.turnThreshold = 45;
			break;
		default:
			assertMsg( "Unsupported self.a.pose: " + self.a.pose + " at " + self.origin );
			break;
	}

	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
}

stopShortly()
{
	self endon("killanimscript");
	self endon("melee");

	// we want to stop at about the time we blend out of whatever we were just doing.
	wait .2;

	self.a.movement = "stop";
}

setupAim( transTime )
{
	assert( IsDefined( transTime ) );
	self SetAnimKnobLimited( animArray("add_aim_up"   ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_down" ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_left" ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_right"), 1, transTime );
}


//--------------------------------------------------------------------------------
// Idle threads and related functions
//--------------------------------------------------------------------------------
idleThread()
{
	self endon("killanimscript");
	self endon("kill_idle_thread");

	self SetAnim( %add_idle );

	for(;;)
	{
		idleAnim = animArrayPickRandom( "exposed_idle" );
		
		self SetFlaggedAnimKnobLimitedRestart("idle", idleAnim );
		self waittillmatch( "idle", "end" );
		self ClearAnim( idleAnim, .2 );
	}
}

//--------------------------------------------------------------------------------
// exposedCombatMainLoop
//--------------------------------------------------------------------------------
exposedCombatMainLoop()
{
	self endon( "killanimscript" );
	self endon( "combat_restart" );

	self exposedCombatMainLoopSetup();

	self AnimMode("zonly_physics", false);
	self OrientMode( "face angle", self.angles[1] ); // turn will automatically face the enemy later on

	for(;;)
	{
		self IsInCombat(); // reset our in-combat state

		if( exposedCombatWaitForStanceChange() ) // transition to the possible stance
			continue;
		
		if( animscripts\shared::shouldSwitchWeapons() )
		{
			animscripts\shared::switchWeapons();

			resetWeaponAnims();
			continue;
		}
		
		TryMelee();
		
		// can't see enemy behavior
		if( !IsDefined( self.shootPos ) )
		{
			assert( !IsDefined( self.shootEnt ) );

			/#self animscripts\debug::debugPushState( "cantSeeEnemyBehavior" );#/
			exposedCombatCantSeeEnemyBehavior();
			/#self animscripts\debug::debugPopState( "cantSeeEnemyBehavior" );#/

			continue;
		}

		// we can use self.shootPos after this point.
		assert( isdefined( self.shootPos ) );
		self resetGiveUpOnEnemyTime();		

		distSqToShootPos = lengthsquared( self.origin - self.shootPos );

		// check if we need to stop using rpg and throw it down
		if( exposedCombatStopUsingRPGCheck() )
			continue;

		// orient towards the shootEnt if needed
		if( exposedCombatNeedToTurn() )
			continue;

		// consider throwing grenade
		// AI_TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
		if( exposedCombatConsiderThrowGrenade() )
			continue;
				
		// consider switching to side arm or reloading if needed
		if( exposedCombatCheckReloadOrUsePistol( distSqToShootPos ) )
			continue;

		// switch back to primary weapon from pistol/sideArm 
		exposedCombatCheckPutAwayPistol( distSqToShootPos );

		// stand if enemy is very close 
		if( exposedCombatCheckStance( distSqToShootPos ) )
			continue;
		
		// shooting until need to turn
		if ( aimedAtShootEntOrPos() )
		{	
			if( exposedCombatRambo() )
			{
				// if any cleanup neeeded do it here
			}	
			else
			{
				/#self animscripts\debug::debugPushState( "exposedCombatShootUntilNeedToTurn" );#/
					self exposedCombatShootUntilNeedToTurn();
				/#self animscripts\debug::debugPopState( "exposedCombatShootUntilNeedToTurn" );#/

				// clear the fire animation as we are done shooting
				self ClearAnim( %add_fire, .2 );		
			}
		
			continue;
		}
		

		
		//dds going to fire on target trigger
		//Print3d(self.origin, "Going to fire",(1.0,0.8,0.5),1,1,60);	
		self maps\_dds::dds_notify( "thrt_acquired", ( self.team == "allies" ) );	
		
		
		/#self animscripts\debug::debugPushState( "exposedCombatWait" );#/
		exposedCombatWait();
		/#self animscripts\debug::debugPopState();#/
	}
}

exposedCombatMainLoopSetup()
{
	self thread trackShootEntOrPos();
	self thread exposedCombatReacquireWhenNecessary();
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
	self thread watchShootEntVelocity();

	self resetGiveUpOnEnemyTime();

	if ( self.a.magicReloadWhenReachEnemy )
	{
		self animscripts\weaponList::RefillClip();
		self.a.magicReloadWhenReachEnemy = false;
	}

	// Hesitate to crouch. Crouching too early can look stupid because we'll tend to stand right back up in a lot of cases.
	self.a.dontCrouchTime = GetTime() + randomintrange( 500, 1500 );

}


//--------------------------------------------------------------------------------
// exposed rambo
//--------------------------------------------------------------------------------
exposedCombatRambo()
{
	const EXPOSED_BLINDFIRE_WAIT_MIN = 3000;
	const EXPOSED_BLINDFIRE_WAIT_MAX = 5000;
	
	if( !IS_TRUE( self.a.doExposedBlindFire ) )
		return false;
	
	if ( !animscripts\weaponList::usingAutomaticWeapon() )
		return false;
		
	shouldExposedRambo = !IsDefined( self.a.nextAllowedExposedBlindfireTime ) 
						 || ( IsDefined( self.a.nextAllowedExposedBlindfireTime ) && self.a.nextAllowedExposedBlindfireTime < GetTime() );
	
	// SUMEET_TODO - we need additive aims and get a good pose going
	if( shouldExposedRambo && animArrayAnyExist( "exposed_rambo" ) )
	{		
		self notify( "kill_idle_thread" );
		
		self animMode("gravity");
		
		ramboAnim = animArrayPickRandom( "exposed_rambo" );
		time = GetAnimLength( ramboAnim );
		self setFlaggedAnimKnobAllRestart( "ramboAnim", ramboAnim, %body, 1, 0.2, 1 );
		self animscripts\shared::DoNoteTracksForTime( time - 0.2, "ramboAnim" );
		
		self animMode("zonly_physics");
		
		self thread idleThread();

		self.a.nextAllowedExposedBlindfireTime = GetTime() + RandomIntRange( EXPOSED_BLINDFIRE_WAIT_MIN, EXPOSED_BLINDFIRE_WAIT_MAX );
		
		return true;
	}
	
	return false;
}

//--------------------------------------------------------------------------------
// stance change
//--------------------------------------------------------------------------------
exposedCombatWaitForStanceChange()
{
	curstance = self.a.pose;

	stances = array( "stand", "crouch", "prone" );

	if( !self IsStanceAllowed( curstance ) )
	{
		assert( curstance == "stand" || curstance == "crouch" || curstance == "prone" );

		for( i=0; i < stances.size; i++ )
		{
			otherstance = stances[i];

			if( otherstance == curstance )
				continue;

			if ( self IsStanceAllowed( otherstance ) )
			{
				if ( curstance == "stand" && AI_USINGSIDEARM(self) )
				{
					if( switchToLastWeapon() )
						return true;
				}

				transitionTo( otherstance );
				return true;
			}
		}
	}

	return false;
}

//--------------------------------------------------------------------------------
// Can't see enemy behavior
//--------------------------------------------------------------------------------
exposedCombatCantSeeEnemyBehavior()
{
	// 1. try to stand if it makes enemy visible
	if ( self.a.pose != "stand" && self IsStanceAllowed("stand") && standIfMakesEnemyVisible() )
		return true;

	// if standing, don't crouch for a while
	time = GetTime();
	self.a.dontCrouchTime = time + 1500;

	// if this is a guard or exposed node, face its angles
	if ( IsDefined( self.node ) && IsDefined( anim.isCombatScriptNode[ self.node.type ] ) )
	{
		relYaw = AngleClamp180( self.angles[1] - self.node.angles[1] );			
		if ( self TurnToFaceRelativeYaw( relYaw ) )
			return true;
	}
	else if( ( IsDefined( self.enemy ) && self SeeRecently( self.enemy, 2 ) ) || time > self.a.scriptStartTime + 1200 )
	{
		relYaw 		   = undefined;
		likelyEnemyDir = self getAnglesToLikelyEnemyPath();
		
		if( IsDefined( likelyEnemyDir ) )
		{
			relYaw = AngleClamp180( self.angles[ 1 ] - likelyEnemyDir[ 1 ] );
		}
		else if( IsDefined( self.node ) )
		{
			relYaw = AngleClamp180( self.angles[ 1 ] - self.node.angles[ 1 ] );
		}
		else if( IsDefined( self.enemy ) )
		{
			likelyEnemyDir = vectorToAngles( self lastKnownPos( self.enemy ) - self.origin );
			relYaw = AngleClamp180( self.angles[ 1 ] - likelyEnemyDir[ 1 ] );
		}				
		
		if ( IsDefined( relYaw ) && self TurnToFaceRelativeYaw( relYaw ) )
			return true;
	}
		
	// consider throwing grenade now that we have faced the right direction
	if ( exposedCombatConsiderThrowGrenade() )
		return true;

	// if can give up on enemy, then try reloading or switching back to rifle from sidearm if possible.
	givenUpOnEnemy = ( self.a.nextGiveUpOnEnemyTime < time );

	threshold = 0;
	if ( givenUpOnEnemy )
		threshold = 0.99999;
	
	if ( self exposedReload( threshold ) )
		return true;
	
	if ( givenUpOnEnemy && AI_USINGSIDEARM(self) )
	{
		// switch back to main weapon so we can reload it too before another enemy appears
		if( switchToLastWeapon() )
			return true;
	}

	exposedCantSeeEnemyWait();	
	//dds going to cover trigger
	//Print3d(self.origin, "cant get a shot!",(1.0,0.8,0.5),1,1,60);
	self maps\_dds::dds_notify( "rspns_neg", ( self.team == "allies" ) );		
	
	return true;
}

exposedCantSeeEnemyWait()
{
	self endon("shoot_behavior_change");

	wait 0.4 + RandomFloat( 0.4 );
	self waittill("do_slow_things");
}

//--------------------------------------------------------------------------------
// RPG
//--------------------------------------------------------------------------------
exposedCombatStopUsingRPGCheck()
{
	if( usingRocketLauncher() &&  animscripts\shared::shouldThrowDownWeapon() )
	{
		lastWeaponType = weaponAnims();

		if ( self.a.pose != "stand" && self.a.pose != "crouch" )
			transitionTo("crouch");

		self notify( "kill_idle_thread" );

		animscripts\shared::throwDownWeapon();

		// AI_TODO: RPG throwdown anim ends in stand pose - why?
		if( lastWeaponType == "rocketlauncher" )
			self.a.pose = "stand";

		// restart aiming with the new weapon
		resetWeaponAnims();

		// start the idle thread again
		self thread idleThread();

		return true;
	}

	return false;
}

//--------------------------------------------------------------------------------
// exposed turn
//--------------------------------------------------------------------------------
exposedCombatNeedToTurn()
{
	if ( needToTurn() )
	{
		predictTime = 0.25;
		if ( IsDefined( self.shootEnt ) && !IsSentient( self.shootEnt ) )
			predictTime = 1.5;
		
		yawToShootEntOrPos = getPredictedAimYawToShootEntOrPos( predictTime ); // yaw to where we think our enemy will be in x seconds
		if ( TurnToFaceRelativeYaw( yawToShootEntOrPos ) )
			return true;
	}	

	return false;
}

//--------------------------------------------------------------------------------
// Exposed grenade throw
//--------------------------------------------------------------------------------
exposedCombatConsiderThrowGrenade()
{
	if ( !myGrenadeCoolDownElapsed() ) // early out for efficiency
		return false;

	self.a.throwingGrenade = true;

	// SUMEET_TODO - This will always throw the grenade at player 0 as long as he is there
	players = GetPlayers();
	for ( i=0; i< players.size;i++ )
	{
		if ( IsDefined( players[i] ) && IsDefined( anim.throwGrenadeAtPlayerASAP ) && IsAlive( players[i] ) )
		{
			if( tryExposedThrowGrenade( players[i], anim.combatGlobals.MIN_EXPOSED_GRENADE_DIST_PLAYER ) )
				return true;
		}
	}

	if ( IsDefined( self.enemy ) && tryExposedThrowGrenade( self.enemy, anim.combatGlobals.MIN_EXPOSED_GRENADE_DIST ) )
		return true;
	
	self.a.nextGrenadeTryTime = gettime() + 2000;// don't try this too often
	self.a.throwingGrenade = false;

	return false;
}

tryExposedThrowGrenade( throwAt, minDist )
{
	/#self animscripts\debug::debugPushState( "tryThrowGrenade" );#/

	threw = false;

	if( self recentlySawEnemy() )
		return false;
	
	if( !animscripts\cover_behavior::enemyIsHiding() && !IS_TRUE( level.allowExposedAIGrenadeThrow ) )
		return false;
	
	throwSpot = throwAt.origin;
	if( !self canSee( throwAt ) )
	{
		if ( IsDefined( self.enemy ) && throwAt == self.enemy && IsDefined( self.shootPos ) )
			throwSpot = self.shootPos;
	}

	if( !self canSee( throwAt ) )
		minDist = 100;
	
	if( DistanceSquared( self.origin, throwSpot ) > minDist * minDist && self.a.pose == "stand" )
	{
		self setActiveGrenadeTimer( throwAt );

		if ( !grenadeCoolDownElapsed() )
			return false;

		yaw = GetYawToSpot( throwSpot );
		if ( abs( yaw ) < 60 )
		{
			throwAnims = [];

			// SUMEET_TODO - May be there is a better way to do this
			if( isDeltaAllowed(animArray("grenade_throw")) )
				throwAnims[throwAnims.size] = animArray("grenade_throw");
			if ( isDeltaAllowed(animArray("grenade_throw_1")) )
				throwAnims[throwAnims.size] = animArray("grenade_throw_1");
			if ( isDeltaAllowed(animArray("grenade_throw_2")) )
				throwAnims[throwAnims.size] = animArray("grenade_throw_2");
			
			if( throwAnims.size > 0 )
			{
				self SetAnim(%exposed_aiming, 0, .1);
				self AnimMode( "zonly_physics" );

				setAnimAimWeight(0, 0);

				threw = TryGrenade( throwAt, throwAnims[RandomInt(throwAnims.size)] );

				self SetAnim(%exposed_aiming, 1, .1);

				if ( threw )
					setAnimAimWeight(1, .5); // ease into aiming
				else
					setAnimAimWeight(1, 0);
			}
			else
			{
				/#self animscripts\debug::debugPopState( "tryThrowGrenade", "no throw anim that wouldn't collide with env" );#/
			}
		}
		else
		{
			/#self animscripts\debug::debugPopState( "tryThrowGrenade", "angle to enemy > 60" );#/
		}
	}
	else
	{
		/#
		if( DistanceSquared( self.origin, throwSpot ) < minDist * minDist )
			self animscripts\debug::debugPopState( "tryThrowGrenade", "too close (<" + minDist + ")" );
		else
			self animscripts\debug::debugPopState( "tryThrowGrenade", "not standing" );
		#/
	}

	if ( threw )
		self maps\_gameskill::didSomethingOtherThanShooting();
	
	/#self animscripts\debug::debugPopState( "tryThrowGrenade" );#/

	return threw;
}

//--------------------------------------------------------------------------------
// switching to sidearm and reloading and putaway
//--------------------------------------------------------------------------------
exposedCombatCheckReloadOrUsePistol( distSqToShootPos )
{
	/#
		if( GetDvarint( "scr_forceSideArm" ) == 1 )
			self.forceSideArm = true;
	#/
	
	if( !AI_USINGSIDEARM(self) )
	{
		shouldForceSideArm = IsDefined( self.forceSideArm ) && self.forceSideArm;
		if( shouldForceSideArm && self.a.pose == "stand" )
		{
			if( self tryUsingSidearm() )
				return true;

			// SUMEET_TODO - not sure what this is needed here
			if( isSniper() && distSqToShootPos < anim.combatGlobals.PISTOL_PULLOUT_DISTSQ )
			{
				if( self tryUsingSidearm() )
					return true;
			}
		}
	}
	
	if ( NeedToReload(0) )
	{
		// try sideArm first
		if (  !AI_USINGSIDEARM(self) 
			  && cointoss()
			  && !usingRocketLauncher() 
			  && ( self.weapon == self.primaryweapon )
			  && ( distSqToShootPos < anim.combatGlobals.PISTOL_PULLOUT_DISTSQ ) 
			  && self isStanceAllowed( "stand" ) 
			)
		{
			// we need to be standing to switch weapons
			if ( self.a.pose != "stand" )
			{
				transitionTo( "stand" );
				return true;
			}

			if ( self tryUsingSidearm() )
				return true;
		}

		// did not switch to sideArm, just reload
		if ( self exposedReload(0) )
			return true;
	}

	return false;
}

exposedCombatCheckPutAwayPistol( distSqToShootPos )
{
	if( AI_USINGSIDEARM(self) && !isdefined( self.forceSideArm ) && !AIHasOnlyPistol() )
	{
		// should always be standing while using pistol/sideArm
		Assert( self.a.pose == "stand" );

		if( ( distSqToShootPos >  anim.combatGlobals.PISTOL_PUTBACK_DISTSQ ) || ( self.combatMode == "ambush_nodes_only" && ( !isdefined( self.enemy ) || !self cansee( self.enemy ) ) ) )
			switchToLastWeapon();	
	}
}

//--------------------------------------------------------------------------------
// Change stance if it looks tactical
//--------------------------------------------------------------------------------
exposedCombatCheckStance( distSqToShootPos )
{
	const STAND_IF_ENEMY_NEARBY_DISTSQ 		= 285 * 285;
	const TRY_CROUCH_MIN_DISTSQ 	   		= 512 * 512;
	const TRY_CROUCH_MAX_SHOOTENT_VELOCITY 	= 100 * 100;
	const TRY_CROUCH_RANDOM_CHANCE 			= 25;
	
	/#		
		desiredStance = undefined;
		if( shouldForceBehavior( "force_stand" ) )
			desiredStance = "stand";
		else if( shouldForceBehavior( "force_crouch" ) )
			desiredStance = "crouch";
		
		if( IsDefined( desiredStance )  )
		{
			if( self.a.pose != desiredStance )
			{
				transitionTo( desiredStance );
				return true;
			}
			
			return false;
		}
	#/
	
	if( self.a.pose != "stand" && self isStanceAllowed( "stand" ) )
	{
		if( distSqToShootPos < STAND_IF_ENEMY_NEARBY_DISTSQ )
		{
			transitionTo( "stand" );
			return true;
		}

		if( standIfMakesEnemyVisible() )
			return true;
	}

	isCrouchingAtNodeAllowed = true;
	
	if( IsDefined( self.node ) )
		isCrouchingAtNodeAllowed = !ISNODEDONTCROUCH(self.node);
				
	if( distSqToShootPos > TRY_CROUCH_MIN_DISTSQ
		&& self.a.pose != "crouch" 
		&& self IsStanceAllowed("crouch") 
		&& isCrouchingAtNodeAllowed
		&& !AI_USINGSIDEARM(self)
		&& !ISHEAT(self)
		&& GetTime() >= self.a.dontCrouchTime 
		&& RandomInt(100) <= TRY_CROUCH_RANDOM_CHANCE
		&& LengthSquared( self.shootEntVelocity ) < TRY_CROUCH_MAX_SHOOTENT_VELOCITY
	  )
	{
		if( !IsDefined( self.shootPos ) || sightTracePassed( self.origin + ( 0, 0, 36 ), self.shootPos, false, undefined ) )
		{
			transitionTo( "crouch" );
			return true;
		}
	}

	return false;
}


//--------------------------------------------------------------------------------
// exposed turning and shooting
//--------------------------------------------------------------------------------
exposedCombatShootUntilNeedToTurn()
{	
	self thread watchForNeedToTurnOrTimeout();
	self endon( "need_to_turn" );
	
	self thread keepTryingToMelee();

	shootUntilShootBehaviorChange();

	// stop shooting if flamethrower
	self flamethrower_stop_shoot();

	self notify("stop_watching_for_need_to_turn");
	self notify("stop_trying_to_melee");
}

watchForNeedToTurnOrTimeout()
{
	self endon("killanimscript");
	self endon("stop_watching_for_need_to_turn");

	endtime = GetTime() + 4000 + RandomInt(2000);

	while(1)
	{
		if ( GetTime() > endtime || needToTurn() )
		{
			self notify("need_to_turn");
			break;
		}
		wait .1;
	}
}

//--------------------------------------------------------------------------------
// exposed wait
//--------------------------------------------------------------------------------
exposedCombatWait()
{
	if( !IsDefined( self.enemy ) || !self cansee( self.enemy ) )
	{
		self endon("enemy");
		self endon("shoot_behavior_change");

		wait 0.2 + RandomFloat( 0.1 );
		self waittill("do_slow_things");
	}
	else
	{
		wait 0.05;
	}
}


//--------------------------------------------------------------------------------
// exposed re-acquire behavior
//--------------------------------------------------------------------------------
exposedCombatReacquireWhenNecessary()
{
	self endon( "killanimscript" );	

	self.a.exposedReloading = false;

	while ( 1 )
	{
		wait .2;

		if ( isdefined( self.enemy ) && !self seeRecently( self.enemy, 2 ) )
		{
			if ( self.combatMode == "ambush" || self.combatMode == "ambush_nodes_only" )
				continue;				
		}

		TryExposedReacquire();
	}
}

TryExposedReacquire()
{		
	if( IS_TRUE( self.a.disableReacquire ) )
		return;
	
	if ( self.fixedNode )
		return;
	
	// snipers are usually set to stay put in position
	if( isSniper() )
		return;

	//prof_begin( "TryExposedReacquire" );
	if ( !IsDefined( self.enemy ) )
	{
		self.reacquire_state = 0;
		return;
	}
	
	if( self.enemy IsVehicle() || ( IsAI( self.enemy ) && self.enemy.isBigDog ) )
	{
		self.reacquire_state = 0;
		return;
	}

	// don't do reacquire move when temporarily blocked by teammate
	if ( gettime() < self.teamMoveWaitTime )
	{
		self.reacquire_state = 0;
		return;
	}

	if ( IsDefined( self.prevEnemy ) && self.prevEnemy != self.enemy )
	{
		self.reacquire_state = 0;
		self.prevEnemy = undefined;
		return;
	}

	self.prevEnemy = self.enemy;

	if ( self canSee( self.enemy ) && self canShootEnemy() )
	{
		self.reacquire_state = 0;
		return;
	}

	if ( IsDefined( self.a.finishedReload ) && !self.a.finishedReload )
	{
		self.reacquire_state = 0;
		return;
	}

	if( IsDefined( self.a.throwingGrenade ) && self.a.throwingGrenade )
	{
		self.reacquire_state = 0;
		return;
	}

	// SUMEET_TODO - Make sure re-acquire will use the pistol tactical walk while reacquiring move
	if( IsDefined( self.a.switchToSideArmDone ) && !self.a.switchToSideArmDone )
	{
		self.reacquire_state = 0;
		return;
	}

	// don't do reacquire unless facing enemy 
	dirToEnemy = vectornormalize( self.enemy.origin - self.origin );
	forward = anglesToForward( self.angles );

	if ( vectordot( dirToEnemy, forward ) < 0.5 )	// (0.5 = cos60)
	{
		self.reacquire_state = 0;
		return;
	}	

	if ( self.a.exposedReloading && NeedToReload( .25 ) && self.enemy.health > self.enemy.maxhealth * .5 )
	{
		self.reacquire_state = 0;
		return;
	}

	//if ( shouldHelpAdvancingTeammate() && self.reacquire_state < 3 )
	//	self.reacquire_state = 3;

	switch( self.reacquire_state )
	{
		case 0:
			if ( self ReacquireStep( 32 ) )
				return;
			break;

		case 1:
			if ( self ReacquireStep( 64 ) )
			{
				self.reacquire_state = 0;
				return;
			}
			break;

		case 2:
			if ( self ReacquireStep( 96 ) )
			{
				self.reacquire_state = 0;
				return;
			}
			break;

		case 3:
			if ( tryRunningToEnemy( false ) )
			{
				self.reacquire_state = 0;
				return;
			}
			break;

		case 4:
			if ( !( self canSee( self.enemy ) ) || !( self canShootEnemy() ) )
				self FlagEnemyUnattackable();
			break;

		default:
			// don't do anything for a while
			if ( self.reacquire_state > 15 )
			{
				self.reacquire_state = 0;
				return;
			}
			break;
	}

	self.reacquire_state++;
}

//--------------------------------------------------------------------------------
// Melee 
//--------------------------------------------------------------------------------
TryMelee()
{
	animscripts\melee::Melee_TryExecuting();	// will start a new anim script and stop combat when successful
}


keepTryingToMelee()
{
	self endon( "killanimscript" );
	self endon( "stop_trying_to_melee" );
	self endon( "done turning" );
	self endon( "need_to_turn" );
	self endon( "shoot_behavior_change" );

	while(1)
	{
		wait .2 + randomfloat(.3);

		// this function is running when we're doing something like shooting or reloading.
		// we only want to melee if we would look really stupid by continuing to do what we're trying to get done.
		// only melee if our enemy is very close.
		if( IsDefined( self.enemy ) )
		{
			if ( IsPlayer( self.enemy ) )
				checkDistSq = 200 * 200;
			else
				checkDistSq = 100 * 100;

			if ( DistanceSquared( self.enemy.origin, self.origin ) < checkDistSq )
				TryMelee();
		}
	}
}

delayStandardMelee()
{
	if ( isdefined( self.noMeleeChargeDelay ) )
		return;

	if ( isPlayer( self.enemy ) )
		return;

	// give the AI a chance to charge the player if he forced him out of cover
	//if ( isPlayer( self.enemy ) && isDefined( self.meleeCoverChargeGraceEndTime ) && (self.meleeCoverChargeGraceEndTime > getTime()) )
	//	return;

	animscripts\melee::Melee_Standard_DelayStandardCharge( self.enemy );
}


//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
	self.ambushNode = undefined;
	self.a.throwingGrenade = false;
	self.a.finishedReload  = true;
}

//--------------------------------------------------------------------------------
// utility functions for combat
//--------------------------------------------------------------------------------
resetWeaponAnims()
{
	self ClearAnim( %aim_4, 0 );
	self ClearAnim( %aim_6, 0 );
	self ClearAnim( %aim_2, 0 );
	self ClearAnim( %aim_8, 0 );
	self ClearAnim( %exposed_aiming, 0 );

	self SetAnimKnobAllRestart( animarray("straight_level"), %body, 1, .2 );
	setupAim( .2 );
}

resetGiveUpOnEnemyTime()
{
	self.a.nextGiveUpOnEnemyTime = GetTime() + randomintrange( 2000, 4000 );
}

switchToLastWeapon( cleanUp )
{
	self endon ( "killanimscript" );

	// switch only if standing.
	if( self.a.pose != "stand" )
		return false;
	
	// don't switch back if it's forced
	if( IsDefined(self.forceSideArm) && self.forceSideArm && usingPistol() )
		return false;

	// dont switch back if pistol AI
	if( AIHasOnlyPistol() )
		return false;

	// don't switch back if there's nothing to switch to
	if( !AI_HASPRIMARYWEAPON(self) )
		return false;

	/#self animscripts\debug::debugPushState( "switchToLastWeapon" );#/
		
	swapAnim = animArray("pistol_putaway", "combat");
	
	assert( self.lastWeapon != self.sidearm );
	assert( self.lastWeapon == self.primaryweapon || self.lastWeapon == self.secondaryweapon );

	self notify("kill_idle_thread");
	self ClearAnim( %add_idle, 0.2 );
	self ClearAnim( animArray("straight_level", "combat" ), 0.2 );
	self OrientMode("face current");

	self.swapAnim = swapAnim;
	self setFlaggedAnimKnobAllRestart( "weapon swap", swapAnim, %body, 1, .1, 1 );

	if( IsDefined( cleanUp ) )
		self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePutawayCleanUp, "end_weapon_swap" );
	else
		self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePutaway, "end_weapon_swap" );

	self ClearAnim( self.swapAnim, 0.2 );

	self OrientMode( "face angle", self.angles[1] ); // turn will automatically face the enemy later on
	self maps\_gameskill::didSomethingOtherThanShooting();
	
	self animscripts\anims::clearAnimCache();

	/#self animscripts\debug::debugPopState();#/

	return true;
}

handlePutawayCleanUp( notetrack )
{
	if ( notetrack == "pistol_putaway" )
		self ClearAnim( animarray( "straight_level", "combat" ), 0 );
}

handlePutaway( notetrack )
{
	if ( notetrack == "pistol_putaway" )
	{
		self ClearAnim( animarray("straight_level", "combat" ), 0 );
	}
	else if ( notetrack == "start_aim" )
	{
		if ( self needToTurn() )
		{
			self notify("end_weapon_swap");
		}
		else
		{
			self thread idleThread();
			self SetAnimLimited( animarray("straight_level", "combat" ), 1, 0 );
			setupAim( 0 );
			self SetAnim( %exposed_aiming, 1, .2 );
		}
	}
}

standIfMakesEnemyVisible()
{
	assert( self.a.pose != "stand" );
	assert( self isStanceAllowed( "stand" ) );

	if ( isdefined( self.enemy ) && ( !self cansee( self.enemy ) || !self canShootEnemy() ) && sightTracePassed( self.origin + ( 0, 0, 64 ), self.enemy getShootAtPos(), false, undefined ) )
	{
		self.a.dontCrouchTime = gettime() + 3000;
		transitionTo( "stand" );
		return true;
	}

	return false;
}

transitionTo( newPose )
{
	if ( newPose == self.a.pose )
		return;
	
	/#self animscripts\debug::debugPushState( "transitionTo: " + newPose );#/
	
	self ClearAnim( %root, .3 );

	self notify( "kill_idle_thread" );

	
	transAnim = animArray( self.a.pose + "_2_" + newPose, "combat" );
	if ( newPose == "stand" )
		rate = 2;
	else
		rate = 1;
	/#
	if ( !animHasNoteTrack( transAnim, "anim_pose = \"" + newPose + "\"" ) )
		println( "error: ^2Pain missing notetrack to set pose!", transAnim );
	#/
		
	self setFlaggedAnimKnobAllRestart( "trans", transanim, %body, 1, .2, rate );

	//restart aiming
	setupAim( 0 );
	self SetAnim( %exposed_aiming, 1, 0 );

	transTime = getAnimLength( transanim ) / rate;
	playTime = transTime - 0.3;
	if ( playTime < 0.2 )
		playTime = 0.2;
	
	self animscripts\shared::DoNoteTracksForTime( playTime, "trans" );
	self ClearAnim( transanim, 0.2 );

	self.a.pose = newPose;

	self set_aimturn_limits();

	self SetAnimKnobAllRestart( animarray("straight_level"), %body, 1, .25 );
	setupAim( .25 );

	self SetAnim( %add_idle );
	self thread idleThread();

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#self animscripts\debug::debugPopState();#/
}

watchShootEntVelocity()
{
	self endon("killanimscript");

	self.shootEntVelocity = (0,0,0);

	prevshootent = undefined;
	prevpos = self.origin;

	const interval = .15;

	while(1)
	{
		if ( IsDefined( self.shootEnt ) && IsDefined( prevshootent ) && self.shootEnt == prevshootent )
		{
			curpos = self.shootEnt.origin;
			self.shootEntVelocity = VectorScale( curpos - prevpos, 1 / interval );
			prevpos = curpos;
		}
		else
		{
			if ( IsDefined( self.shootEnt ) )
				prevpos = self.shootEnt.origin;
			else
				prevpos = self.origin;
			
			prevshootent = self.shootEnt;
			self.shootEntVelocity = (0,0,0);
		}

		wait interval;
	}
}

isDeltaAllowed( theanim )
{
	delta = getMoveDelta( theanim, 0, 1 );
	endPoint = self localToWorldCoords( delta );

	return self IsInGoal( endPoint ) && self mayMoveToPoint( endPoint );
}

needToTurn()
{
	point = self.shootPos;

	if ( !IsDefined( point ) )
		return false;

	yaw = self.angles[ 1 ] - VectorToAngles( point - self.origin )[1];

	// need to have fudge factor because the gun's origin is different than our origin,
	// the closer our distance, the more we need to fudge. 
	distsq = DistanceSquared( self.origin, point );
	if ( distsq < 256*256 )
	{
		dist = sqrt( distsq );
		if ( dist > 3 )
			yaw += asin(-3/dist);
	}

	return AbsAngleClamp180( yaw ) > self.turnThreshold;
}

exposedReload(threshold)
{
	if ( NeedToReload( threshold ) )
	{	
		if( weaponIsGasWeapon( self.weapon )  )
		{
			self animscripts\weaponList::RefillClip();
			return true;
		}

		/#self animscripts\debug::debugPushState( "exposedReload" );#/

		self.keepClaimedNode = true;
		self.a.exposedReloading = true;
		crouchReload = false;

		if( self.a.pose == "crouch" )
		{
			crouchReload = true;
		}
		else
		{
			if ( self.a.pose == "stand" && self IsStanceAllowed( "crouch" ) && !AI_USINGSIDEARM(self) && cointoss() )
				crouchReload = true;
	
			// heat exposed reload/RPG reload actually puts AI into crouch as well
			if( self.a.pose == "stand" && ( ISHEAT(self) || self weaponAnims() == "rocketlauncher" ) && !AI_USINGSIDEARM(self) )
				crouchReload = true;
		}
		
		if( crouchReload && animArrayAnyExist( "reload_crouchhide" ) )
			reloadAnim = animArrayPickRandom( "reload_crouchhide" );
		else
			reloadAnim = animArrayPickRandom( "reload" );
		
		self thread keepTryingToMelee();
		
		self SetAnim( %reload,1,.2 );

		self ClearAnim( %add_fire, 0 );

		self.a.finishedReload = false;
		
		const shouldKeepAiming = false; //!crouchReload && !AI_USINGSIDEARM(self);
		
		// stop laser on the gun if there is one.
		self animscripts\shared::updateLaserStatus( false );
		
		// doReloadAnim still respects the stop_aim notetrack
		self doReloadAnim( reloadAnim, threshold > .05, shouldKeepAiming ); // this will return at the time when we should start aiming
		self notify("abort_reload"); // make sure threads that doReloadAnim() started finish
		
		self animscripts\shared::updateLaserStatus( true );
		
		if ( self.a.finishedReload )
			self animscripts\weaponList::RefillClip();

		self set_aimturn_limits();
		
		self ClearAnim(%reload, 0.3);
		self SetAnim( %exposed_aiming, 1, 0.2 );
		self SetAnim( %add_idle );
		
		self.keepClaimedNode = false;
		self notify("stop_trying_to_melee");
		self.a.exposedReloading = false;

		self maps\_gameskill::didSomethingOtherThanShooting();

		/#self animscripts\debug::debugPopState();#/

		return true;
	}

	return false;
}

doReloadAnim( reloadAnim, stopWhenCanShoot, shouldKeepAiming )
{
	self endon("abort_reload");

	if ( stopWhenCanShoot )
		self thread abortReloadWhenCanShoot();
	
	animRate = 1;
	
	if( !AI_USINGSIDEARM(self) && !self usingShotgun() && IsDefined( self.enemy ) && self canSee( self.enemy ) && DistanceSquared( self.enemy.origin, self.origin ) < 1024*1024 )
		animRate = 1.2;

	flagName = "reload_" + getUniqueFlagNameIndex();

	self SetFlaggedAnimRestart( flagName, reloadAnim, 1, .3, animRate );
	
	// if the animation has stop_aim then stop aiming when the notetrack hits,
	// otherwise stop aiming right away
	if( !shouldKeepAiming )
	{
		if( AnimHasNotetrack( reloadAnim, "stop_aim" ) )
			self waittillmatch( flagName, "stop_aim" );
		
		self SetAnim( %add_idle, 0, 0.1 );
		self SetAnim( %exposed_aiming, 0, 0.1 );
	}
		
	self thread notifyOnStartAim( "abort_reload", flagName );
	self endon("start_aim");
	self animscripts\shared::DoNoteTracks( flagName );

	self.a.finishedReload = true;
}

abortReloadWhenCanShoot()
{
	self endon("abort_reload");
	self endon("killanimscript");

	while(1)
	{
		if ( IsDefined( self.shootEnt ) && self canSee( self.shootEnt ) )
			break;
		
		wait .05;
	}

	self notify("abort_reload");
}

notifyOnStartAim( endonStr, flagName )
{
	self endon( endonStr );
	self endon("killanimscript");
	self waittillmatch( flagName, "start_aim" );
	self.a.finishedReload = true;
	self notify( "start_aim" );
}

finishNoteTracks(animname)
{
	self endon("killanimscript");
	animscripts\shared::DoNoteTracks(animname);
}

tryUsingSidearm()
{
	if( !AI_HASSIDEARM(self) )
		return false;
		
	if( weaponIsGasWeapon( self.weapon ) )
		return false;
	
	// If AI has secondary weapon other than pistol then AI should not use sidearm
	if( hasSecondaryWeapon() )
		return false;

	if( !self.a.allow_sideArm )
		return false;
	
	if( usingPistol() )
		return false;
	
	switchToSidearm( animArray("pistol_pullout") );
	
	return true;
}

switchToSidearm( swapAnim )
{
	self endon ( "killanimscript" );

	/#self animscripts\debug::debugPushState( "switchToSidearm" );#/

	assert( self.sidearm != "" );

	if( !IsDefined(self.forceSideArm) || !self.forceSideArm )
		self thread putGunBackInHandOnKillAnimScript();
	
	self notify( "kill_idle_thread" );
	self ClearAnim( %add_idle, 0.2 );
	self ClearAnim( animArray("straight_level"), 0.2 );
	self OrientMode("face current");

	self.a.switchToSideArmDone = false;
	
	self.pistolSwitchTime = GetTime() + 9000 + RandomInt(3000);
	self.swapAnim = swapAnim;
	self SetFlaggedAnimKnobAllRestart("weapon swap", swapAnim, %body, 1, .2, 1);
	self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePickup, "end_weapon_swap" );	
	self ClearAnim( self.swapAnim, 0 );
	
	self animscripts\anims::clearAnimCache();
	
	self.a.switchToSideArmDone = true;

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#self animscripts\debug::debugPopState();#/
}

DoNoteTracksPostCallbackWithEndon( flagName, interceptFunction, endonMsg )
{
	self endon( endonMsg );
	self animscripts\shared::DoNoteTracksPostCallback( flagName, interceptFunction );
}

faceEnemyDelay( delay )
{
	self endon("killanimscript");
	wait delay;
	self faceEnemyImmediately();
}

handlePickup( notetrack )
{
	if ( notetrack == "pistol_pickup" )
	{
		self ClearAnim( animarray("straight_level"), 0 );
		self thread faceEnemyDelay( 0.25 );
	}
	else if ( notetrack == "start_aim" )
	{
		if ( self needToTurn() )
		{
			self notify("end_weapon_swap");
		}
		else
		{
			self thread idleThread();
			self SetAnimLimited( animarray("straight_level"), 1, 0 );
			setupAim( 0 );
			self SetAnim( %exposed_aiming, 1, .2 );
		}
	}
}

TurnToFaceRelativeYaw( faceYaw )
{
	/#self animscripts\debug::debugPushState( "turnToFaceRelativeYaw", faceYaw );#/

	if ( faceYaw < 0-self.turnThreshold )
	{
		if ( self.a.pose == "prone" )
		{
			self animscripts\cover_prone::proneTo( "crouch" );
			self set_aimturn_limits();
		}

		self doTurn("left", 0-faceYaw);
		self maps\_gameskill::didSomethingOtherThanShooting();

		/#self animscripts\debug::debugPopState( "turnToFaceRelativeYaw", "faceYaw < 0-self.turnThreshold" );#/

		return true;
	}

	if ( faceYaw > self.turnThreshold )
	{
		if ( self.a.pose == "prone" )
		{
			self animscripts\cover_prone::proneTo( "crouch" );
			self set_aimturn_limits();
		}

		self doTurn("right",  faceYaw);
		self maps\_gameskill::didSomethingOtherThanShooting();

		/#self animscripts\debug::debugPopState( "turnToFaceRelativeYaw", "faceYaw > self.turnThreshold" );#/

		return true;
	}

	/#self animscripts\debug::debugPopState();#/

	return false;
}

// does turntable movement to face the enemy. Should be used sparingly because turn animations look better.
faceEnemyImmediately()
{
	self endon("killanimscript");
	self notify("facing_enemy_immediately");
	self endon("facing_enemy_immediately");

	const maxYawChange = 5; // degrees per frame

	while(1)
	{
		yawChange = 0 - GetYawToEnemy();

		if ( abs( yawChange ) < 2 )
			break;
	
		if ( abs( yawChange ) > maxYawChange )
			yawChange = maxYawChange * sign( yawChange );
	
		self OrientMode( "face angle", self.angles[1] + yawChange );
		wait .05;
	}

	self OrientMode( "face current" );	
	self notify("can_stop_turning");
}

doTurn( direction, amount )
{
	/#self animscripts\debug::debugPushState( "turn", direction + " by " + amount );#/

	rate 	  				 = 1;
	const nodeTurnRate 			 = 1.6;
	transTime 				 = 0.2;
	const TURN_180_MIN_ANGLE = 157.5;
	const TURN_135_MIN_ANGLE = 112.5;
	const TURN_90_MIN_ANGLE  = 67.5;
	const TURN_MUST_FACE_ENEMY_DIST    = 512;
	const TURN_MUST_FACE_ENEMY_DISTSQ  = 512 *512;
	
	mustFaceEnemy = (   IsDefined( self.enemy ) 
	                 && !self.turnToMatchNode 
	                 && self canSee( self.enemy ) 
	                 && DistanceSquared( self.enemy.origin, self.origin ) < TURN_MUST_FACE_ENEMY_DISTSQ );
	
	if ( self.a.scriptStartTime + 500 > GetTime() )
	{
		transTime = 0.25; // if it's the first thing we're doing, always blend slowly
		if ( mustFaceEnemy )
			self thread faceEnemyImmediately();
	}
	else
	{
		if ( mustFaceEnemy )
		{
			urgency = 1.0 - ( distance( self.enemy.origin, self.origin ) / TURN_MUST_FACE_ENEMY_DIST );
			rate = 1 + urgency * 1;

			// ( ensure transTime <= 0.2 / rate )
			if ( rate > 2 )
				transTime = .05;
			else if ( rate > 1.3 )
				transTime = .1;
			else
				transTime = .15;
		}
	}

	angle = 0;
	if ( amount 	 > TURN_180_MIN_ANGLE )
		angle = 180;
	else if ( amount > TURN_135_MIN_ANGLE )
		angle = 135;
	else if ( amount > TURN_90_MIN_ANGLE )
		angle = 90;
	else
		angle = 45;
	
	/#exposedCombatTurnDebugMsg( "TurningAngle:" + amount );#/
	
	animname = "turn_" + direction + "_" + angle;
	turnanim = animarray(animname, "combat");
	
	if ( self.turnToMatchNode )
		self AnimMode( "angle deltas", false );
	else if ( IsDefined( self.node ) && IsDefined( anim.isCombatScriptNode[ self.node.type ] ) && DistanceSquared(self.origin, self.node.origin) < 16*16 && ( self.goalradius < 16 || !IsDefined(self.enemy) ) )
		self AnimMode( "angle deltas" );
	else if ( isDeltaAllowed( turnanim ) )
		self AnimMode( "zonly_physics" );
	else
		self AnimMode( "angle deltas" );
	
	self SetAnimKnobAll( %exposed_aiming, %body, 1, transTime );

	shouldUseStartStopAimNotetrack = animHasNotetrack( turnAnim, "start_aim" ) && animHasNotetrack( turnAnim, "stop_aim" );
		
	if ( !self.turnToMatchNode )
		self thread turningAimingOff( turnAnim, transTime, rate, shouldUseStartStopAimNotetrack );
	
	if( self.turnToMatchNode )
		rate = nodeTurnRate;
	
	self SetAnimLimited( %turn, 1, transTime );
	self SetFlaggedAnimKnobLimitedRestart( "turn", turnanim, 1, 0, rate );
	self notify("turning");
	
	self thread turnStartAiming( turnanim, rate, shouldUseStartStopAimNotetrack );

	doTurnNotetracks();
	self SetAnimLimited( %turn, 0, .2 );

//	if( !self.turnToMatchNode )
//	{
		self turnSetupIdle( transTime );
		self ClearAnim( %turn, .2 );
		self SetAnimKnob( %exposed_aiming, 1, .2, 1 );
//	}
//	else
//	{
//		self ClearAnim( %exposed_modern, .3 );
//	}
//
	// if we didn't actually turn, code prevented us from doing so give up and turntable.
	if ( IsDefined( self.turnLastResort ) )
	{
		self.turnLastResort = undefined;
		self thread faceEnemyImmediately();
	}
		
	if ( !self usingShotgun() )
		self ClearAnim( %add_fire, .2 );

	self notify("done turning");
	
	/#self animscripts\debug::debugPopState( "turn" );#/
}

doTurnNotetracks()
{
	self endon("turning_isnt_working");
	self endon("can_stop_turning");
	
	self animscripts\shared::DoNoteTracks( "turn" );
}

turnStartAiming( turnAnim, rate, shouldUseStartStopAimNotetrack )
{
	self endon("killanimscript");
	self endon("death");
	self endon("turning_isnt_working");
	self endon("can_stop_turning");
	
	if( shouldUseStartStopAimNotetrack )
	{
		self waittillmatch( "turn", "start_aim" );
	}
	else
	{
		animLength = GetAnimLength( turnAnim ) / rate;
		wait( animLength * 0.8 );
	}
	
	/#exposedCombatTurnDebugMsg( "starting_aim:" + shouldUseStartStopAimNotetrack );#/

	trackLoopStart();
}

turningAimingOff( turnAnim, transTime, rate, shouldUseStartStopAimNotetrack )
{
	self endon("killanimscript");
	self endon("death");
	self endon("turning_isnt_working");
	self endon("can_stop_turning");
	
	if( shouldUseStartStopAimNotetrack )
	{
		self waittillmatch( "turn", "stop_aim" );
	}
	else
	{
		animLength = GetAnimLength( turnAnim ) / rate;
		wait( animLength * 0.2 );
	}
	
	/#exposedCombatTurnDebugMsg( "stopping_aim:" + shouldUseStartStopAimNotetrack );#/
	
	self stopTracking();
	self SetAnimLimited( animarray("straight_level", "combat"), 0, transTime );

	self SetAnim( %aim_2, 0, transTime );
	self SetAnim( %aim_4, 0, transTime );
	self SetAnim( %aim_6, 0, transTime );
	self SetAnim( %aim_8, 0, transTime );

	self SetAnim( %add_idle, 0, transTime );
}

turnSetupIdle( transTime )
{
	self SetAnimLimited( animarray("straight_level"), 1, transTime );
	self SetAnim( %add_idle, 1, transTime );
	
	trackLoopStart();
}

makeSureTurnWorks()
{
	self endon("killanimscript");
	self endon("done turning");

	startAngle = self.angles[1];

	wait .3;

	if ( self.angles[1] == startAngle )
	{
		self notify("turning_isnt_working");
		self.turnLastResort = true;
	}
}




//--------------------------------------------------------------------------------
// Debug Functions
//--------------------------------------------------------------------------------
/#
	
exposedCombatTurnDebugMsg( msg )
{
	if( getDvarInt( "ai_debugTrackingTurns" ) == 1 )
		recordEntText( msg, self, level.color_debug["green"], "Script" );	
}
#/
