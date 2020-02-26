// AI_TODO: make formatting consistent: remove extra braces, normalize "if ("
// AI_TODO: update asserts with helpful messages

#include animscripts\combat_utility;
#include animscripts\cover_utility;
#include animscripts\debug;
#include animscripts\shared;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

/*
This file contains the overall behavior for all "whack-a-mole" cover nodes.

Callbacks which must be defined:

 All callbacks should return true or false depending on whether they succeeded in doing something.
 If functionality for a callback isn't available, just don't define it.

mainLoopStart()
	optional
reload()
	plays a reload animation in a hidden position
leaveCoverAndShoot()
	does the main attacking; steps out or stands up and fires, goes back to hiding.
	should obey orders from decideWhatAndHowToShoot in shoot_behavior.gsc.
look( maxtime )
	looks for up to maxtime, stopping and returning if enemy becomes visible or if suppressed
fastlook()
	looks quickly
idle()
	idles until the "end_idle" notify.
flinch()
	flinches briefly (1-2 seconds), doesn't need to return true or false.
grenade( throwAt )
	steps out and throws a grenade at the given player / ai
grenadehidden( throwAt )
	throws a grenade at the given player / ai without leaving cover
blindfire()
	blindfires from cover
switchSides()
	switches from left to right, if possible (ex. pillar nodes);
rambo()
	runs out from cover and shoots wildly, then goes back to hiding

example:
behaviorCallbacks = SpawnStruct();
behaviorCallbacks.reload = ::reload;
...
animscripts\cover_behavior::main( behaviorCallbacks );

*/

CoverGlobalsInit()
{
	anim.coverGlobals = SpawnStruct();

	anim.coverGlobals.DESYNCHED_TIME					= 2500;
	anim.coverGlobals.RESPOND_TO_DEATH_RETRY_INTERVAL	= 30 * 1000;
	anim.coverGlobals.MIN_GRENADE_THROW_DISTANCE_SQ		= 750 * 750;

	anim.coverGlobals.SUPPRESS_WAIT_MIN					= 3000;
	anim.coverGlobals.SUPPRESS_WAIT_AMBUSH_MIN			= 6000;
	anim.coverGlobals.SUPPRESS_WAIT_MAX					= 20000;

	anim.coverGlobals.LOOK_WAIT_MIN						= 4000;
	anim.coverGlobals.LOOK_WAIT_MAX						= 15000;

	anim.coverGlobals.ENEMY_BLINDFIRE_WAIT_TIME_MIN		= 3000;
	anim.coverGlobals.ENEMY_BLINDFIRE_WAIT_TIME_MAX		= 12000;
	
	anim.coverGlobals.ALLY_BLINDFIRE_WAIT_TIME_MIN		= 8000;
	anim.coverGlobals.ALLY_BLINDFIRE_WAIT_TIME_MAX		= 12000;
		
	anim.coverGlobals.PEEKOUT_OFFSET					= 30;
	
	anim.coverGlobals.CORNER_LEFT_LEAN_YAW_MAX  		= -60;
	anim.coverGlobals.CORNER_RIGHT_LEAN_YAW_MAX 		= 60;
	
	anim.coverGlobals.CORNER_LEFT_AB_YAW	  			= 14;
	anim.coverGlobals.CORNER_RIGHT_AB_YAW	 			= -14;
}

main( behaviorCallbacks )
{	
	self.couldntSeeEnemyPos = self.origin; // (set couldntSeeEnemyPos to a place the enemy can't be while we're in corner behavior)
	
	behaviorStartTime = GetTime();
	
	// we won't look for better cover purely out of boredom until this time
	resetLookForBetterCoverTime();
	resetSeekOutEnemyTime();
	resetRespondToDeathTime();

	self.a.lastEncounterTime = behaviorStartTime;
	self.a.nextAllowedLookTime = behaviorStartTime;
	self.a.nextAllowedSuppressTime = behaviorStartTime;
	
	self.a.idlingAtCover = false;
	self.a.movement = "stop";

	self thread watchPlayerAim();
	self thread watchSuppression();
	//self thread attackEnemyWhenFlashed();

	// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
	//self thread serviceReactionEvents();

	self thread animscripts\utility::idleLookatBehavior(160, true);
	
	desynched = (GetTime() > anim.coverGlobals.DESYNCHED_TIME);
	
	correctAngles = getCorrectCoverAngles();
	
	for(;;)
	{
		// AI_TODO: take a look at the shouldHelpAdvancingTeammate in mw3

		if( IsDefined( behaviorCallbacks.mainLoopStart ) )
		{
			startTime = GetTime();
			self thread endIdleAtFrameEnd();

			[[ behaviorCallbacks.mainLoopStart ]]();

			if( GetTime() == startTime )
				self notify("dont_end_idle");
		}

		////////////////////////////////////////////////////
		////////// FOR TESTING ONLY ////////////////////////
		/#
		if( runForcedBehaviors( behaviorCallbacks ) )
			continue;
		#/
		////////////////////////////////////////////////////
		////////////////////////////////////////////////////

		// shuffle to a nearby node, if available
		if( moveToNearbyCover() )
			continue;
		
		// make sure the dude is actually on the node
		angles = ( correctAngles[0], AngleClamp180( correctAngles[1] ), correctAngles[2] );
		self Teleport( self.covernode.origin, angles );
		
		// only for the first 2.5 seconds of the level
		if( !desynched )
		{
			idle( behaviorCallbacks, 0.05 + RandomFloat( 1.5 ) );
			desynched = true;
			continue;
		}

		// idle, reload, switching sides or weapons, suppressed
		if( doNonAttackCoverBehavior( behaviorCallbacks ) )
			continue;

		// can be requsted by script to throw grenades
		if( throwGrenadeAtPlayerASAP(behaviorCallbacks) )
			continue;
		
		// try and get out of a dangerous situation
		if( respondToDeadTeammate() )
			return;
		
		// determine visibility and suppressability of enemy.
		visibleEnemy = false;
		suppressableEnemy = false;
		if( IsAlive(self.enemy) )
		{
			visibleEnemy = isEnemyVisibleFromExposed();
			suppressableEnemy = canSuppressEnemyFromExposed();
		}
		
		// decide what to do.
		if( visibleEnemy )
		{
			// is there a better cover spot?
			if( self.a.getBoredOfThisNodeTime < GetTime() )
			{
				if( lookForBetterCover() )
					return;
			}

			attackVisibleEnemy( behaviorCallbacks );
		}			
		else
		{
			if( IS_TRUE( self.aggressiveMode ) || enemyIsHiding() )
			{
				if( advanceOnHidingEnemy() )
					return;
			}

			if( suppressableEnemy )
			{
				attackSuppressableEnemy( behaviorCallbacks );
			}
			else
			{
				if( attackNothingToDo( behaviorCallbacks ) )
					return;
			}
		}
	}
}

end_script()
{
	self.turnToMatchNode = false;
	self.a.prevAttack = undefined;

	if( isDefined( self.meleeCoverChargeMinTime ) && (self.meleeCoverChargeMinTime <= getTime()) )
	{
		// give the AI a chance to charge the player if he forced him out of cover
		self.meleeCoverChargeGraceEndTime = getTime() + 0;//MELEE_GRACE_PERIOD_GIVEN_TIME;
		self.meleeCoverChargeMinTime = undefined;
	}
}

getCorrectCoverAngles()
{
	correctAngles = ( self.coverNode.angles[ 0 ], getNodeForwardYaw( self.coverNode ), self.coverNode.angles[ 2 ] );
	return correctAngles;
}

resetRespondToDeathTime()
{
	self.a.respondToDeathTime = 0;
}

resetLookForBetterCoverTime()
{
	currentTime = GetTime();

	// treat group of shuffle nodes as one node, don't increase getBoredOfThisNodeTime by too much
	if( IsDefined( self.didShuffleMove ) && currentTime > self.a.getBoredOfThisNodeTime )
	{
		self.a.getBoredOfThisNodeTime = currentTime + RandomIntRange( 2000, 5000 );
	}
	else if( IsDefined( self.enemy ) )
	{
		dist = distance2D( self.origin, self.enemy.origin );
		if( dist < self.engageMinDist )
			self.a.getBoredOfThisNodeTime = currentTime + RandomIntRange( 5000, 10000 );
		else if( dist > self.engageMaxDist && dist < self.goalradius )
			self.a.getBoredOfThisNodeTime = currentTime + RandomIntRange( 2000, 5000 );
		else
			self.a.getBoredOfThisNodeTime = currentTime + RandomIntRange( 10000, 15000 );
	}
	else
	{
		self.a.getBoredOfThisNodeTime = currentTime + RandomIntRange( 5000, 15000 );
	}
}

respondToDeadTeammate()
{
	if( self atDangerousNode() && self.a.respondToDeathTime < GetTime() )
	{
		if( lookForBetterCover() )
			return true;
		
		self.a.respondToDeathTime = GetTime() + anim.coverGlobals.RESPOND_TO_DEATH_RETRY_INTERVAL;
	}

	return false;
}

doNonAttackCoverBehavior( behaviorCallbacks )
{
	// forced by script not to peek out at this node
	if( IS_TRUE( self.coverNode.script_onlyidle ) || IS_TRUE(self.a.coverIdleOnly) )
	{
		idle( behaviorCallbacks );
		return true;
	}

	// on pillar nodes, try switching sides
	if( shouldSwitchSides(true) )
	{
		if( switchSides( behaviorCallbacks ) )
			return true;
	}

	// if we're suppressed, we do other things.
	if( suppressedBehavior( behaviorCallbacks ) )
	{
		if( isEnemyVisibleFromExposed() )
			resetSeekOutEnemyTime();

		self.a.lastEncounterTime = GetTime();
		return true;
	}

	// reload if we need to; everything in this loop involves shooting.
	if( coverReload( behaviorCallbacks, 0 ) )
		return true;

	// switch weapons based on the situation
	if( animscripts\shared::shouldSwitchWeapons() )
	{
		animscripts\shared::switchWeapons();

		// update settings based on the new weapon
		if( IsDefined(behaviorCallbacks.resetWeaponAnims) )
			[[ behaviorCallbacks.resetWeaponAnims ]]();

		return true;
	}

	return false;
}

throwGrenadeAtPlayerASAP(behaviorCallbacks)
{
	if( IS_TRUE( anim.throwGrenadeAtPlayerASAP ) )
	{
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			if( IsAlive( players[i] ) )
			{
				if( tryThrowingGrenade( behaviorCallbacks, players[i] ) )
				{
					return true;
				}
			}
		}
	}

	return false;
}

// AI_TODO: shoot at the friendly's enemy, if possible
provideCoveringFire( behaviorCallbacks )
{
	if( shouldProvideCoveringFire() )
	{
		//recordEntText( "Try Covering Fire!", self, level.color_debug["green"], "Messaging" );
		if( leaveCoverAndShoot( behaviorCallbacks, "suppress" ) )
		{
			resetSeekOutEnemyTime();
			self.a.lastEncounterTime = GetTime();
			return true;
		}
	}

	return false;
}

attackVisibleEnemy( behaviorCallbacks )
{
	// request from a moving teammate
	if( provideCoveringFire( behaviorCallbacks ) )
		return;

	// try throwing a grenade
	if( distanceSquared( self.origin, self.enemy.origin ) > anim.coverGlobals.MIN_GRENADE_THROW_DISTANCE_SQ )
	{
		if( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
			return;
	}

	// pop out
	if( leaveCoverAndShoot( behaviorCallbacks, "normal" ) )
	{
		resetSeekOutEnemyTime();
		self.a.lastEncounterTime = GetTime();
	}
	else
	{
		idle( behaviorCallbacks );
	}
}

attackSuppressableEnemy( behaviorCallbacks )
{
	if( self.doingAmbush )
	{
		if( leaveCoverAndShoot( behaviorCallbacks, "ambush" ) )
			return;
	}
	else if( self.provideCoveringFire || GetTime() >= self.a.nextAllowedSuppressTime )
	{
		preferredActivity = "suppress";

		if( !self.provideCoveringFire && ( GetTime() - self.lastSuppressionTime ) > 5000 && RandomInt( 3 ) < 2 )
			preferredActivity = "ambush";
		else if( !self animscripts\shoot_behavior::shouldSuppress() )
			preferredActivity = "ambush";

		if( leaveCoverAndShoot( behaviorCallbacks, preferredActivity ) )
		{
			self.a.nextAllowedSuppressTime = GetTime() + RandomIntRange( anim.coverGlobals.SUPPRESS_WAIT_MIN, anim.coverGlobals.SUPPRESS_WAIT_MAX );

			// if they're there, we've seen them
			if( isEnemyVisibleFromExposed() )
				self.a.lastEncounterTime = GetTime();

			return;
		}
	}

	if( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
		return;

	idle( behaviorCallbacks );
}


attackNothingToDo( behaviorCallbacks )
{
	if( coverReload( behaviorCallbacks, 0.1 ) )
		return false;

	if( isValidEnemy( self.enemy ) )
	{
		if( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
			return false;
	}

	if( !self.doingAmbush && GetTime() >= self.a.nextAllowedLookTime )
	{
		if( lookForEnemy( behaviorCallbacks ) )
		{
			self.a.nextAllowedLookTime = GetTime() + RandomIntRange( anim.coverGlobals.LOOK_WAIT_MIN, anim.coverGlobals.LOOK_WAIT_MAX );

			// if they're there, we've seen them
			return false;
		}
	}

	// we're *really* bored right now
	if( GetTime() > self.a.getBoredOfThisNodeTime )
	{
		if( cantFindAnythingToDo() )
			return true;
	}

	if( self.doingAmbush || ( GetTime() >= self.a.nextAllowedSuppressTime && isValidEnemy( self.enemy ) ) )
	{
		// be ready to ambush them if they happen to show up
		if( leaveCoverAndShoot( behaviorCallbacks, "ambush" ) )
		{
			if( isEnemyVisibleFromExposed() )
				resetSeekOutEnemyTime();

			self.a.lastEncounterTime = GetTime();
			self.a.nextAllowedSuppressTime = GetTime() + RandomIntRange( anim.coverGlobals.SUPPRESS_WAIT_AMBUSH_MIN, anim.coverGlobals.SUPPRESS_WAIT_MAX );

			return false;
		}
	}

	idle( behaviorCallbacks );
	return false;
}

isEnemyVisibleFromExposed()
{
	if( !IsDefined( self.enemy ) )
	{
		return false;
	}

	// if we couldn't see our enemy last time we stepped out, and they haven't moved, assume we still can't see them.
	if( DistanceSquared(self.enemy.origin, self.couldntSeeEnemyPos) < 16*16 )
	{
		return false;
	}
	else
	{
		return canSeeEnemyFromExposed();
	}
}

suppressedBehavior( behaviorCallbacks )
{
	if( !isSuppressedWrapper() )
	{
		return false;
	}
	
	nextAllowedBlindfireTime = GetTime();
	
	justlooked = true;
	
	/#
	self animscripts\debug::debugPushState( "suppressedBehavior" );
	#/	

	while ( isSuppressedWrapper() )
	{
		justlooked = false;

		self Teleport( self.coverNode.origin );

		////////////////////////////////////////////////////
		////////// FOR TESTING ONLY ////////////////////////
		/#
		if( runForcedBehaviors( behaviorCallbacks ) )
			return false;
		#/
		////////////////////////////////////////////////////
		////////////////////////////////////////////////////

		tryMovingNodes = true;
		if( IS_TRUE( self.a.favor_blindfire ) )
			tryMovingNodes = coinToss();
		
		if( tryMovingNodes && tryToGetOutOfDangerousSituation() )
		{
			self notify("killanimscript");
			waittillframeend;

			/#
			self animscripts\debug::debugPopState( "suppressedBehavior", "found better cover" );
			#/

			return true;
		}

		// break out of suppressed if someone's requesting covering fire
		if( shouldProvideCoveringFire() )
		{
			/#
			self animscripts\debug::debugPopState( "suppressedBehavior", "should provide covering fire" );
			#/

			return false;
		}		
		
		// if we're only at a concealment node, and it's not providing cover, we shouldn't try to use the cover to keep us safe!
		if( self.a.atConcealmentNode && self canSeeEnemy() )
		{
			/#
			self animscripts\debug::debugPopState( "suppressedBehavior", "at unsafe concealment node" );
			#/

			return false;
		}

		if( isEnemyVisibleFromExposed() || canSuppressEnemyFromExposed() )
		{
			if( throwGrenadeAtPlayerASAP(behaviorCallbacks) )
				continue;

			if( coverReload( behaviorCallbacks, 0 ) )
				continue;

			// blindfire
			if( GetTime() >= nextAllowedBlindfireTime )
			{
				if( blindfire( behaviorCallbacks ) )
				{
					if( !IS_TRUE( self.a.favor_blindfire ) )
					{
						if( self.team != "allies" )
							nextAllowedBlindfireTime += RandomIntRange( anim.coverGlobals.ENEMY_BLINDFIRE_WAIT_TIME_MIN, anim.coverGlobals.ENEMY_BLINDFIRE_WAIT_TIME_MAX );
						else
							nextAllowedBlindfireTime += RandomIntRange( anim.coverGlobals.ALLY_BLINDFIRE_WAIT_TIME_MIN, anim.coverGlobals.ALLY_BLINDFIRE_WAIT_TIME_MAX );
					}
					else
						nextAllowedBlindfireTime = GetTime();	

					continue;
				}
			}

			if( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
			{
				justlooked = true;
				continue;
			}
		}	

		if( shouldSwitchSides(false) )
		{
			if( switchSides( behaviorCallbacks ) )
			{
				continue;
			}
		}
		
		if( coverReload( behaviorCallbacks, 0.1 ) )
			continue;

		idle( behaviorCallbacks );
	}
	
	if( !justlooked && RandomInt(2) == 0 )
	{
		peekOut( behaviorCallbacks );
	}

	/#
	self animscripts\debug::debugPopState( "suppressedBehavior" );
	#/

	return true;
}

/* // was used to alternate between leaveCoverAndShoot and throwGrenade, deprecated for now
// returns array of integers 0 through n-1, in random order
getPermutation( n )
{
	permutation = [];
	assert( n > 0 );

	if( n == 1 )
	{
		permutation[0] = 0;
	}
	else if( n == 2 )
	{
		permutation[0] = RandomInt(2);
		permutation[1] = 1 - permutation[0];
	}
	else
	{
		for ( i = 0; i < n; i++ )
		{
			permutation[i] = i;
		}

		for ( i = 0; i < n; i++ )
		{
			switchIndex = i + RandomInt(n - i);
			temp = permutation[switchIndex];
			permutation[SwitchIndex] = permutation[i];
			permutation[i] = temp;
		}
	}

	return permutation;
}
*/

callOptionalBehaviorCallback( callback, arg, arg2, arg3 )
{
	if( !IsDefined( callback ) )
	{
		return false;
	}
	
	self thread endIdleAtFrameEnd();
	
	starttime = GetTime();
	
	val = undefined;
	if( IsDefined( arg3 ) )
	{
		val = [[callback]]( arg, arg2, arg3 );
	}
	else if( IsDefined( arg2 ) )
	{
		val = [[callback]]( arg, arg2 );
	}
	else if( IsDefined( arg ) )
	{
		val = [[callback]]( arg );
	}
	else
	{
		val = [[callback]]();
	}
	
	/#
	// if this assert fails, a behaviorCallback callback didn't return true or false.
	assert( IsDefined( val ) && (val == true || val == false), "behavior callback must return true or false" );
	
	// behaviorCallbacks must return true if and only if they let time pass.
	// (it is also important that they only let time pass if they did what they were supposed to do,
	//  but that's not so easy to enforce.)
	if( IS_TRUE(val) )
	{
		assert( GetTime() != starttime, "behavior callback must return true only if its lets time pass" );
	}
	else
	{
		assert( GetTime() == starttime, "behavior callbacks returning false must not have a wait in them" );
	}
	#/

	if( !val )
	{
		self notify("dont_end_idle");
	}
		
	
	return val;
}

watchSuppression()
{
	self endon("killanimscript");

	// self.lastSuppressionTime is the last time a bullet whizzed by.
	// self.suppressionStart is the last time we were thinking it was safe when a bullet whizzed by.

	self.lastSuppressionTime = GetTime() - 100000;
	self.suppressionStart = self.lastSuppressionTime;

	while(1)
	{
		self waittill("suppression");

		time = GetTime();
		if( self.lastSuppressionTime < time - 700 )
		{
			self.suppressionStart = time;
		}

		self.lastSuppressionTime = time;
	}
}

coverReload( behaviorCallbacks, threshold )
{
	assert(IsDefined(self.bulletsInClip));
	assert(IsDefined(self.weapon));
	assert(IsDefined(threshold));
	assert(IsDefined(weaponClipSize( self.weapon )));

	forceBehavior=false;
	/#forceBehavior=shouldForceBehavior("reload");#/
	
	if( !forcebehavior && self.bulletsInClip > weaponClipSize( self.weapon ) * threshold )
	{
		return false;
	}
		
	self.isreloading = true;

	/#
	self animscripts\debug::debugPushState( "reload" );
	#/
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.reload );

	/#
	self animscripts\debug::debugPopState( "reload" );
	#/
	
	self.isreloading = false;
	
	return result;
}

rambo( behaviorCallbacks )
{
	return callOptionalBehaviorCallback( behaviorCallbacks.rambo );
}

// initialGoal can be either "normal", "suppress", or "ambush".
leaveCoverAndShoot( behaviorCallbacks, initialGoal )
{
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( initialGoal );
	
	if( !self.fixedNode && !self.doingAmbush )
	{
		self thread breakOutOfShootingIfWantToMoveUp();
	}

	/#
	self animscripts\debug::debugPushState( "leaveCoverAndShoot" );
	#/

	// try rambo first (corner only)
	val = rambo( behaviorCallbacks );

	if( !val )
	{
		val = callOptionalBehaviorCallback( behaviorCallbacks.leaveCoverAndShoot );
	}

	/#
	self animscripts\debug::debugPopState( "leaveCoverAndShoot" );
	#/
	
	self notify("stop_deciding_how_to_shoot");
	
	return val;
}

lookForEnemy( behaviorCallbacks )
{
	// can see enemy already
	if( self.a.atConcealmentNode && self canSeeEnemy() )
		return false;

	/#
	self animscripts\debug::debugPushState( "lookForEnemy" );
	#/

	looked = false;

	if( self.a.lastEncounterTime + 6000 > GetTime() )
	{
		looked = peekOut( behaviorCallbacks );
	}
	else
	{
		if( weaponIsGasWeapon( self.weapon ) )
		{
			looked = callOptionalBehaviorCallback( behaviorCallbacks.look, 5 + RandomFloat( 2 ) );
		}
		else
		{
			looked = callOptionalBehaviorCallback( behaviorCallbacks.look, 2 + RandomFloat( 2 ) );
		}

		if( !looked )
		{
			looked = callOptionalBehaviorCallback( behaviorCallbacks.fastlook );

			/#
			self animscripts\debug::debugAddStateInfo( "lookForEnemy", "look failed, used fastlook" );
			#/
		}
	}

	/#
	self animscripts\debug::debugPopState( "lookForEnemy" );
	#/

	return looked;
}

peekOut( behaviorCallbacks )
{
	/#
	self animscripts\debug::debugPushState( "peekOut" );
	#/

	// look fast if possible
	looked = callOptionalBehaviorCallback( behaviorCallbacks.fastlook );
	if( !looked )
	{
		looked = callOptionalBehaviorCallback( behaviorCallbacks.look, 0 );

		/#
		self animscripts\debug::debugAddStateInfo( "peekOut", "fastlook failed, used look" );
		#/
	}

	/#
	self animscripts\debug::debugPopState( "peekOut" );
	#/

	return looked;
}

idle( behaviorCallbacks, howLong )
{
	/#
	self animscripts\debug::debugPushState( "idle" );
	#/
	
	self.flinching = false;
	
	if( IsDefined( behaviorCallbacks.flinch ) )
	{
		// flinch if we just started getting shot at very recently
		if( !self.a.idlingAtCover && GetTime() - self.suppressionStart < 600 )
		{
			if( [[ behaviorCallbacks.flinch ]]() )
			{
				/#
				self animscripts\debug::debugPopState( "idle", "flinched" );
				#/

				return true;
			}
		}
		else
		{
			// if bullets aren't already whizzing by, idle for now but flinch if we get incoming fire
			self thread flinchWhenSuppressed( behaviorCallbacks );
		}
	}
	
	if( !self.a.idlingAtCover )
	{
		assert( IsDefined( behaviorCallbacks.idle ) ); // idle must be available!
		self thread idleThread( behaviorCallbacks.idle ); // this thread doesn't stop until "end_idle", which must be notified before we start anything else! use endIdleAtFrameEnd() to do this.
		self.a.idlingAtCover = true;
	}

	if( IsDefined( howLong ) )
	{
		self idleWait( howLong );
	}
	else
	{
		self idleWaitABit();
	}

	if( self.flinching )
	{
		self waittill("flinch_done");
	}
	
	self notify("stop_waiting_to_flinch");

	/#
	self animscripts\debug::debugPopState( "idle" );
	#/
}

idleWait( howLong )
{
	self endon("end_idle");
	wait howLong;
}

idleWaitAbit()
{
	self endon("end_idle");
	wait 0.3 + RandomFloat( 0.1 );
	self waittill("do_slow_things");
}

idleThread( idlecallback )
{
	self endon("killanimscript");
	self [[ idlecallback ]]();
}

flinchWhenSuppressed( behaviorCallbacks )
{
	self endon ("killanimscript");
	self endon ("stop_waiting_to_flinch");
	
	lastSuppressionTime = self.lastSuppressionTime;
	
	while(1)
	{
		self waittill("suppression");
		
		time = GetTime();
		
		if( lastSuppressionTime < time - 2000 )
		{
			break;
		}

		lastSuppressionTime = time;
	}

	/#
	self animscripts\debug::debugPushState( "flinchWhenSuppressed" );
	#/
	
	self.flinching = true;
	
	self thread endIdleAtFrameEnd();
	
	assert( IsDefined( behaviorCallbacks.flinch ) );
	val = [[ behaviorCallbacks.flinch ]]();
	
	if( !val )
	{
		self notify("dont_end_idle");
	}

	self.flinching = false;
	self notify("flinch_done");

	/#
	self animscripts\debug::debugPopState( "flinchWhenSuppressed" );
	#/
}

endIdleAtFrameEnd()
{
	self endon("killanimscript");
	self endon("dont_end_idle");
	waittillframeend;

	if( !IsDefined( self ) )
		return;

	self notify("end_idle");
	self.a.idlingAtCover = false;
}

tryThrowingGrenade( behaviorCallbacks, throwAt )
{
	result = undefined;

	/#
	self animscripts\debug::debugPushState( "tryThrowingGrenade" );
	#/

	assert( isdefined( throwAt ) );

	// dont bother trying if you cant throw one
	if( !canThrowGrenade() )
	{
		/#
		self animscripts\debug::debugPopState( "tryThrowingGrenade", "Cant throw grenade, canThrowGrenade() failed"  );
		#/
	
	}
	
	// don't throw backwards
	forward = anglesToForward( self.angles );
	dir = vectorNormalize( throwAt.origin - self.origin );
	if( vectorDot( forward, dir ) < 0 && self.a.script != "cover_pillar" )
	{
		/#
		self animscripts\debug::debugPopState( "tryThrowingGrenade", "don't want to throw backwards" );
		#/

		return false;
	}

	if( self.doingAmbush && !recentlySawEnemy() )
	{
		/#
		self animscripts\debug::debugPopState( "tryThrowingGrenade", "doingAmbush and haven't seen enemy recently" );
		#/

		return false;
	}

	// although current might be good enough for other cover behaviors, recalculate it for pillar before 
	// throwing grenade.
	if( shouldSwitchSides(false) )
		switchSides( behaviorCallbacks );
		
	if( self isPartiallySuppressedWrapper() )
	{
		result = callOptionalBehaviorCallback( behaviorCallbacks.grenadehidden, throwAt );
	}
	else
	{
		result = callOptionalBehaviorCallback( behaviorCallbacks.grenade, throwAt );
	}

	/#
	self animscripts\debug::debugPopState( "tryThrowingGrenade" );
	#/

	return result;
}

blindfire( behaviorCallbacks )
{
	if( !canBlindFire() )
	{
		return false;
	}

	// AI_TODO: evaluate impact in-game
	if( IsDefined(self.enemy) )
		self animscripts\shoot_behavior::setShootEnt( self.enemy );

	/#self animscripts\debug::debugPushState( "blindfire" );#/
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.blindfire );

	/#self animscripts\debug::debugPopState( "blindfire" );#/

	return result;
}

breakOutOfShootingIfWantToMoveUp()
{
	self endon("killanimscript");
	self endon("stop_deciding_how_to_shoot");
	
	while(1)
	{
		if( self.fixedNode || self.doingAmbush )
		{
			return;
		}

		wait 0.5 + RandomFloat( 0.75 );
		
		if( !isValidEnemy( self.enemy ) )
		{
			continue;
		}

		if( enemyIsHiding() )
		{
			if( advanceOnHidingEnemy() )
			{
				return;
			}
		}

		if( !self recentlySawEnemy() && !self canSuppressEnemy() )
		{
			if( GetTime() > self.a.getBoredOfThisNodeTime )
			{
				if( cantFindAnythingToDo() )
				{
					return;
				}
			}
		}
	}
}

enemyIsHiding()
{
	// if this function is called, we already know that our enemy is not visible from exposed.
	// check to see if they're doing anything hiding-like.
	
	if( !IsDefined( self.enemy ) )
		return false;
	
	if( self.enemy isFlashed() )
		return true;
	
	if( IsPlayer( self.enemy ) )
	{
		if( IsDefined( self.enemy.health ) && self.enemy.health < self.enemy.maxhealth )
			return true;
	}
	else
	{
		if( IsSentient( self.enemy ) && self.enemy isSuppressedWrapper() )
			return true;
	}

	if( IsDefined( self.enemy.isreloading ) && self.enemy.isreloading )
		return true;
		
	return false;
}

wouldBeSmartForMyAITypeToSeekOutEnemy()
{
	if( self weaponAnims() == "rocketlauncher" )
		return false;
	
	if( self isSniper() )
		return false;
	
	return true;
}

resetSeekOutEnemyTime()
{
	// we'll be willing to actually run right up to our enemy in order to find them if we haven't seen them by this time.
	// however, we'll try to find better cover before seeking them out
	if( IS_TRUE( self.aggressiveMode ) )
		self.seekOutEnemyTime = gettime() + RandomIntRange( 500, 1000 );
	else
		self.seekOutEnemyTime = gettime() + RandomIntRange( 3000, 5000 );
}

// these next functions are "look for better cover" functions.
// they don't always need to cause the actor to leave the node immediately,
// but if they keep being called over and over they need to become more and more likely to do so,
// as this indicates that new cover is strongly needed.
cantFindAnythingToDo()
{
	return advanceOnHidingEnemy();
}

advanceOnHidingEnemy()
{
	// fixedNode dudes don't move
	if( self.fixedNode || self.doingAmbush )
		return false;

	// aggressive = go go go
	if( IS_TRUE( self.aggressiveMode ) && gettime() >= self.seekOutEnemyTime )
		return tryRunningToEnemy( false );

	// check for better cover first
	foundBetterCover = false;
	if( !isValidEnemy( self.enemy ) || !self.enemy isFlashed() )
		foundBetterCover = lookForBetterCover();

	// no cover? just try running to enemy
	if( !foundBetterCover && isValidEnemy( self.enemy ) && wouldBeSmartForMyAITypeToSeekOutEnemy() && !self canSeeEnemyFromExposed() )
	{
		if( GetTime() >= self.seekOutEnemyTime || self.enemy isFlashed() )
		{
			return tryRunningToEnemy( false );
		}
	}

	// maybe at this point we could look for someone who's suppressing our enemy,
	// and if someone is, we can say "cover me!" and have them say "i got you covered" or something.
	
	return foundBetterCover;
}

tryToGetOutOfDangerousSituation()
{
	// shuffle to a nearby cover
	if( moveToNearbyCover() )
	{
		return true;
	}

	// maybe later we can do something more sophisticated here
	return lookForBetterCover();
}

moveToNearbyCover()
{
	if( !IsDefined( self.enemy ) )
		return false;

	if( IS_TRUE( self.didShuffleMove ) )
	{
		self.didShuffleMove = undefined;
		return false;
	}

	// pistol AI do not shuffle for now as the poses are significantly different
	if( AIHasOnlyPistol() )
		return false;
	
	if( !IsDefined( self.node ) )
		return false;
	
	if( self.fixedNode || self.doingAmbush || self.keepClaimedNode || self.keepClaimedNodeIfValid )
		return false;

	if( DistanceSquared( self.origin, self.node.origin ) > 16 * 16 )
		return false;

	node = self FindShuffleCoverNode();
	
	if( !IsDefined( self.node ) )
		return false;
	
	if( IsDefined( node ) && DistanceSquared( node.origin, self.node.origin ) <= anim.moveGlobals.SHUFFLE_COVER_MIN_DISTSQ )
		return false;
	
	if( IsDefined( node ) && ( node != self.node ) && self UseCoverNode( node ) )
	{
		self.shuffleMove = true;
		self.shuffleNode = node;
		self.didShuffleMove = true;
		self.keepClaimedNode = false;
		
		// give code a chance use new cover node
		wait 0.5;
		return true;
	}

	return false;
}

shouldProvideCoveringFire()
{
	//if( self isSniper() )
	//	return false;

	// AI_SQUADMANAGER_TODO - removed references to squad manager as it always returns false. May be we can create something like this later.
	// Modify and remove this function call
	//hasCoverMeRequest = self animscripts\squadmanager::hasMessage("coverMe");

	//return hasCoverMeRequest;
	return false;
}

watchPlayerAim()
{
	self endon("killanimscript");
	self endon("death");
	self endon("stop_watchPlayerAim");

	// delete the old trigger if it's still around
	if( IsDefined(self.coverLookAtTrigger) )
	{
		self.coverLookAtTrigger Delete();
	}

	assert( IsDefined(self.coverNode) );

	self.coverSafeToPopOut = true;

	// find approximate stepout pos
	stepOutPos = self.coverNode.origin;

	// offset for left/right stepouts
	if( self.a.script == "cover_left" || (self.a.script == "cover_pillar" && self.cornerDirection == "left") )
	{
		stepOutPos -= VectorScale( AnglesToRight(self.coverNode.angles), 32 );
	}
	else if( self.a.script == "cover_right" || (self.a.script == "cover_pillar" && self.cornerDirection == "right") )
	{
		stepOutPos += VectorScale( AnglesToRight(self.coverNode.angles), 32 );
	}

	const triggerWidth = 15;	// AIPHYS_RADIUS
	triggerHeight = 72;
	if( self.a.pose == "crouch" )
	{
		triggerHeight = 48;
	}

	// create temp lookat trigger at step out pos
	self.coverLookAtTrigger = Spawn( "trigger_lookat", stepOutPos, 0, triggerWidth, triggerHeight );
	
	/#
	//	PrintLn( "Spawning coverLookAtTrigger for entity " + self GetEntityNumber() + " at time " + GetTime() );
	#/

	while( true )
	{
		// wait till end of frame to allow other threads to access the info below
		waittillframeend;

		self.coverSafeToPopOut = true;
		self.playerAimSuppression = false;

		//if( IsDefined(self.enemy) && IsPlayer(self.enemy) && self.enemy IsLookingAt(self.coverLookAtTrigger) )
		self.coverLookAtTrigger waittill( "trigger", watcher );

		if( IsDefined(watcher) && IsDefined(self.enemy) && watcher == self.enemy )
		{
			/#
			self thread watchPlayerAimDebug(12);
			#/

			//canLean = self.a.pose == "stand" && (self.a.script == "cover_left" || self.a.script == "cover_right");

			self.coverSafeToPopOut = false;

			// ALEXP_TODO: this is temp, need to figure out a better way of controlling blindfire due to player aiming
			self.playerAimSuppression = RandomFloat(1) < 0.9;

			wait(0.5);
		}

		wait(0.05);
	}

	self.coverSafeToPopOut = true;
	self.playerAimSuppression = false;

	// delete temp trigger
	self.coverLookAtTrigger Delete();
}

/#
watchPlayerAimDebug(numFrames)
{
	self endon("death");

	i = 0;
	while( i < numFrames )
	{
		recordEntText( "Cover Trigger Watched", self, level.color_debug["white"], "Suppression" );
		i++;

		wait(0.05);
	}
}
#/

shouldSwitchSides( forVariety )
{	
	if( !canSwitchSides() )
		return false;
		
	/#
	forceCornerMode = shouldForceBehavior( "force_corner_direction" );
	if( forceCornerMode == self.cornerDirection )
		return false;
	#/

	// Nodes will choose a desiredCornerDirection from canSeePointFromExposedAtNode
	// function or this function itself. 
	// If AI has enemy then he will switch sides but will make sure that few sec will be given for the last switch

	enemyRightBehindMe = false;	
		
	if( self.cornerDirection != self.coverNode.desiredCornerDirection )
	{
		return true;
	}
	else if( IsDefined( self.enemy ) )
	{
		yaw = self.coverNode GetYawToOrigin( self.enemy.origin );

		desiredCornerDirection = self.cornerDirection;
			
		if( yaw < -5 && !ISNODEDONTRIGHT(self.coverNode) )
			desiredCornerDirection = "right";
		else if( yaw > 5 && !ISNODEDONTLEFT(self.coverNode) )
			desiredCornerDirection = "left";
		else 
			enemyRightBehindMe = true;
		
		if( !enemyRightBehindMe && self.cornerDirection != desiredCornerDirection )
		{
			self.coverNode.desiredCornerDirection = desiredCornerDirection;
			return true;
		}
	}
	
	if( ( enemyRightBehindMe || forVariety ) && GetTime() > self.a.nextAllowedSwitchSidesTime )
	{
		if( self.cornerDirection == "left" && !ISNODEDONTRIGHT(self.coverNode) )
			self.coverNode.desiredCornerDirection = "right";
		else if( !ISNODEDONTLEFT(self.coverNode) )
			self.coverNode.desiredCornerDirection = "left";

		return true;
	}
	

	return false;
}

switchSides( behaviorCallbacks )
{
	/#
	self animscripts\debug::debugPushState( "switchSides" );
	#/
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.switchSides );

	if( result )
	{
		// reset the player aim trigger
		self notify("stop_watchPlayerAim");
		self thread watchPlayerAim();

		self.a.nextAllowedSwitchSidesTime = GetTime() + RandomIntRange( 5000, 7500 );
		self.a.lastSwitchSidesTime = GetTime();
	}

	/#
	self animscripts\debug::debugPopState( "switchSides" );
	#/

	return result;
}

/#
runForcedBehaviors( behaviorCallbacks )
{
	didSomething = false;

	if( !didSomething && shouldForceBehavior("idle") )
	{
		idle( behaviorCallbacks );
		didSomething = true;
	}

	if( !didSomething && shouldForceBehavior("look") )
	{
		if( callOptionalBehaviorCallback( behaviorCallbacks.look, 2 + RandomFloat( 2 ) ) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("lookFast") )
	{
		if( callOptionalBehaviorCallback( behaviorCallbacks.fastlook ) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("reload") )
	{
		if( coverReload( behaviorCallbacks, 0 ) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("switchSides") )
	{
		if( GetTime() > self.a.nextAllowedSwitchSidesTime )
		{
			if( switchSides( behaviorCallbacks ) )
			{
				didSomething = true;
			}
		}
	}

	if( !didSomething && shouldForceBehavior("stepOut") )
	{
		if( leaveCoverAndShoot( behaviorCallbacks, "normal" ) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("advance") )
	{
		if( advanceOnHidingEnemy() )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("blindfire") )
	{
		if( blindfire( behaviorCallbacks ) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("grenade") )
	{
		// provide at least one grenade to throw
		if( self.grenadeammo <= 0 )
		{
			self.grenadeammo = 1;
		}

		if( IsDefined(self.enemy) && tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("flinch") )
	{
		if( callOptionalBehaviorCallback(behaviorCallbacks.flinch) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("rambo") )
	{
		if( rambo( behaviorCallbacks ) )
		{
			didSomething = true;
		}
	}

	if( !didSomething && shouldForceBehavior("switchWeapons") )
	{
		if( animscripts\shared::shouldSwitchWeapons() )
		{
			animscripts\shared::switchWeapons();
			didSomething = true;
		}
	}

	return didSomething;
}
#/
