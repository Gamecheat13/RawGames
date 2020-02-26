#include maps\_utility;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include common_scripts\utility;

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
	idles briefly (1-2 seconds), doesn't need to return true or false.
flinch()
	flinches briefly (1-2 seconds), doesn't need to return true or false.
	should kill idle() if run at the same time
grenade()
	steps out and throws a grenade
grenadehidden()
	throws a grenade without leaving cover
blindfire()
	blindfires from cover

example:
behaviorCallbacks = spawnstruct();
behaviorCallbacks.reload = ::reload;
...
animscripts\cover_behavior::main( behaviorCallbacks );

*/

main( behaviorCallbacks )
{
	self.couldntSeeEnemyPos = self.origin; // (set couldntSeeEnemyPos to a place the enemy can't be while we're in corner behavior)
	
	knowEnemyIsVisible = true;
	
	time = gettime();
	nextAllowedLookTime = time;
	nextAllowedSuppressTime = time;
	nextAllowedGrenadeTime = time;
	
	// we won't look for better cover purely out of boredom until this time
	self.a.getBoredOfThisNodeTime = gettime() + randomintrange( 2000, 6000 );
	resetSeekOutEnemyTime();
	self.a.lastEncounterTime = gettime();
	
	self thread watchSuppression();
	
	for(;;)
	{
		if ( isdefined( behaviorCallbacks.mainLoopStart ) )
			[[ behaviorCallbacks.mainLoopStart ]]();
		
		self teleport( self.covernode.origin );
		
		// if we're suppressed, we do other things.
		if ( suppressedBehavior( behaviorCallbacks ) )
		{
			knowEnemyIsVisible = isEnemyVisibleFromExposed();
			resetSeekOutEnemyTime();
			self.a.lastEncounterTime = gettime();
			continue;
		}
		
		
		reloadThreshold = .75;
		// we want to reload more often when we have the shotty
		if(animscripts\weaponList::usingShotGunWeapon())
			reloadThreshold = .25;
		
		// reload if we need to; everything in this loop involves shooting.
		if ( coverReload( behaviorCallbacks, reloadThreshold ) )
			continue;
		
		
		// determine visibility and suppressability of enemy.
		visibleEnemy = false;
		suppressableEnemy = false;
		if ( isalive(self.enemy) )
		{
			visibleEnemy = isEnemyVisibleFromExposed();
			suppressableEnemy = canSuppressEnemyFromExposed();
		}
		
		
		// decide what to do.
		if ( visibleEnemy && knowEnemyIsVisible )
		{
			if ( !leaveCoverAndShoot( behaviorCallbacks, "normal" ) )
				idle( behaviorCallbacks );
			
			resetSeekOutEnemyTime();
			self.a.lastEncounterTime = gettime();
		}
		else
		{
			knowEnemyIsVisible = false; // we now assume our enemy isn't visible until we've looked and seen him.
			
			if ( !visibleEnemy && enemyIsHiding() )
			{
				if ( advanceOnHidingEnemy() )
					return;
			}
			
			if ( suppressableEnemy )
			{
				// randomize the order of trying the following options
				permutation = getPermutation(2);
				done = false;
				for ( i = 0; i < permutation.size && !done; i++ )
				{
					switch( i )
					{
					case 0:
						if ( gettime() >= nextAllowedSuppressTime )
						{
							preferredActivity = "suppress";
							if ( (gettime() - self.lastSuppressionTime) > 5000 && randomint(3) < 2 )
								preferredActivity = "ambush";
							
							if ( leaveCoverAndShoot( behaviorCallbacks, preferredActivity ) )
							{
								nextAllowedSuppressTime = gettime() + randomintrange( 3000, 20000 );
								// if they're there, we've seen them
								knowEnemyIsVisible = isEnemyVisibleFromExposed();
								if ( knowEnemyIsVisible )
									self.a.lastEncounterTime = gettime();
								done = true;
							}
						}
						break;
					
					case 1:
						if ( gettime() >= nextAllowedGrenadeTime )
						{
							if ( tryThrowingGrenade( behaviorCallbacks, false ) )
							{
								nextAllowedGrenadeTime = gettime() + randomintrange( 10000, 25000 );
								done = true;
							}
						}
						break;
					}
				}
				if ( done )
					continue;
				
				idle( behaviorCallbacks );
			}
			else
			{
				// nothing to do!
				
				if ( coverReload( behaviorCallbacks, 0.9999 ) )
					continue;
				
				if ( gettime() >= nextAllowedLookTime )
				{
					if ( lookForEnemy( behaviorCallbacks ) )
					{
						nextAllowedLookTime = gettime() + randomintrange( 4000, 15000 );
						
						// if they're there, we've seen them
						knowEnemyIsVisible = isEnemyVisibleFromExposed();
						
						continue;
					}
				}
				
				// we're *really* bored right now
				if ( gettime() > self.a.getBoredOfThisNodeTime )
				{
					if ( cantFindAnythingToDo() )
						return;
				}
				
				idle( behaviorCallbacks );
			}
		}
	}
}

isEnemyVisibleFromExposed()
{
	if ( !isdefined( self.enemy ) )
		return false;
	
	// if we couldn't see our enemy last time we stepped out, and they haven't moved, assume we still can't see them.
	if ( distanceSquared(self.enemy.origin, self.couldntSeeEnemyPos) < 16*16 )
		return false;
	else
		return canSeeEnemyFromExposed();
}

suppressedBehavior( behaviorCallbacks )
{
	if ( !isSuppressedWrapper() )
		return false;
	
	nextAllowedBlindfireTime = gettime();
	nextAllowedGrenadeTime = gettime();
	
	justlooked = true;
	
	while ( isSuppressedWrapper() )
	{
		justlooked = false;

		self teleport( self.coverNode.origin );
		
		if ( tryToGetOutOfDangerousSituation() )
		{
			self notify("killanimscript");
			return true;
		}
		
		
		// if we're only at a concealment node, and it's not providing cover, we shouldn't try to use the cover to keep us safe!
		if ( self.a.atConcealmentNode && self canSeeEnemy() )
			return false;
		
		
		if ( coverReload( behaviorCallbacks, .25 ) )
			continue;
		
		
		// randomize the order of trying the following options
		permutation = getPermutation(2);
		done = false;
		for ( i = 0; i < permutation.size && !done; i++ )
		{
			switch( i )
			{
			case 0:
				if ( self.team != "allies" && gettime() >= nextAllowedBlindfireTime )
				{
					if ( blindfire( behaviorCallbacks ) )
					{
						nextAllowedBlindfireTime = gettime() + randomintrange( 3000, 12000 );
						done = true;
					}
				}
				break;
			
			case 1:
				if ( gettime() >= nextAllowedGrenadeTime && canSeeEnemyFromExposed() )
				{
					if ( tryThrowingGrenade( behaviorCallbacks, true ) )
					{
						nextAllowedGrenadeTime = gettime() + randomintrange( 10000, 25000 );
						justlooked = true;
						done = true;
					}
				}
				break;
			}
		}
		if ( done )
			continue;
		
		
		if ( coverReload( behaviorCallbacks, 0.9999 ) )
			continue;
		
		idle( behaviorCallbacks );
	}
	
	if ( !justlooked && randomint(2) == 0 )
		lookfast( behaviorCallbacks );
	
	return true;
}

// returns array of integers 0 through n-1, in random order
getPermutation( n )
{
	permutation = [];
	assert( n > 0 );
	if ( n == 1 )
	{
		permutation[0] = 0;
	}
	else if ( n == 2 )
	{
		permutation[0] = randomint(2);
		permutation[1] = 1 - permutation[0];
	}
	else
	{
		for ( i = 0; i < n; i++ )
			permutation[i] = i;
		for ( i = 0; i < n; i++ )
		{
			switchIndex = i + randomint(n - i);
			temp = permutation[switchIndex];
			permutation[SwitchIndex] = permutation[i];
			permutation[i] = temp;
		}
	}
	return permutation;
}

callOptionalBehaviorCallback( callback, arg, arg2, arg3 )
{
	if ( !isdefined( callback ) )
		return false;
	
	starttime = gettime();
	
	val = undefined;
	if( isdefined( arg3 ) )
		val = [[callback]]( arg, arg2, arg3 );
	else if ( isdefined( arg2 ) )
		val = [[callback]]( arg, arg2 );
	else if ( isdefined( arg ) )
		val = [[callback]]( arg );
	else
		val = [[callback]]();
	
	/#
	// if this assert fails, a behaviorCallback callback didn't return true or false.
	assert( isdefined( val ) && (val == true || val == false) );
	
	// behaviorCallbacks must return true if and only if they let time pass.
	// (it is also important that they only let time pass if they did what they were supposed to do,
	//  but that's not so easy to enforce.)
	if ( val )
		assert( gettime() != starttime );
	else
		assert( gettime() == starttime );
	#/
	
	return val;
}

watchSuppression()
{
	self endon("killanimscript");
	
	// self.lastSuppressionTime is the last time a bullet whizzed by.
	// self.suppressionStart is the last time we were thinking it was safe when a bullet whizzed by.
	
	self.lastSuppressionTime = gettime() - 100000;
	self.suppressionStart = self.lastSuppressionTime;
	
	while(1)
	{
		self waittill("suppression");
		
		time = gettime();
		if ( self.lastSuppressionTime < time - 700 )
			self.suppressionStart = time;
		self.lastSuppressionTime = time;
	}
}

coverReload( behaviorCallbacks, threshold )
{
	if ( self.bulletsInClip > weaponClipSize( self.weapon ) * threshold )
		return false;
	
	self.isreloading = true;
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.reload );
	
	self.isreloading = false;
	
	return result;
}

// initialGoal can be either "normal", "suppress", or "ambush".
leaveCoverAndShoot( behaviorCallbacks, initialGoal )
{
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( initialGoal );
	
	val = callOptionalBehaviorCallback( behaviorCallbacks.leaveCoverAndShoot );
	
	self notify("stop_deciding_how_to_shoot");
	
	return val;
}

lookForEnemy( behaviorCallbacks )
{
	if ( self.a.atConcealmentNode && self canSeeEnemy() )
		return false;
	
	if ( self.a.lastEncounterTime + 6000 > gettime() )
	{
		return lookfast( behaviorCallbacks );
	}
	else
	{
		// look slow if possible
		result = callOptionalBehaviorCallback( behaviorCallbacks.look, 2 + randomfloat( 2 ) );
		if ( result )
			return true;
		return callOptionalBehaviorCallback( behaviorCallbacks.fastlook );
	}
}

lookfast( behaviorCallbacks )
{
	// look fast if possible
	result = callOptionalBehaviorCallback( behaviorCallbacks.fastlook );
	if ( result )
		return true;
	return callOptionalBehaviorCallback( behaviorCallbacks.look, 0 );
}

idle( behaviorCallbacks )
{
	self.flinching = false;
	
	if ( isdefined( behaviorCallbacks.flinch ) )
	{
		// flinch if we just started getting shot at very recently
		if ( gettime() - self.suppressionStart < 600 )
		{
			if ( [[ behaviorCallbacks.flinch ]]() )
				return true;
		}
		else
		{
			// if bullets aren't already whizzing by, idle for now but flinch if we get incoming fire
			self thread flinchWhenSuppressed( behaviorCallbacks );
		}
	}
	
	assert( isdefined( behaviorCallbacks.idle ) ); // idle must be available!
	val = [[ behaviorCallbacks.idle ]]();
	
	if ( self.flinching )
		self waittill("flinch_done");
	else
		assert( val ); // idle must always succeed and return true if uninterrupted!
	
	self notify("stop_waiting_to_flinch");
}

flinchWhenSuppressed( behaviorCallbacks )
{
	self endon ("killanimscript");
	self endon ("stop_waiting_to_flinch");
	
	lastSuppressionTime = self.lastSuppressionTime;
	
	while(1)
	{
		self waittill("suppression");
		
		time = gettime();
		
		if ( lastSuppressionTime < time - 2000 )
			break;
		
		lastSuppressionTime = time;
	}
	
	self.flinching = true;
	
	assert( isdefined( behaviorCallbacks.flinch ) );
	[[ behaviorCallbacks.flinch ]]();
	
	self.flinching = false;
	self notify("flinch_done");
}

tryThrowingGrenade( behaviorCallbacks, safe )
{
	if ( safe )
	{
		return callOptionalBehaviorCallback( behaviorCallbacks.grenadehidden );
	}
	else
	{
		return callOptionalBehaviorCallback( behaviorCallbacks.grenade );
	}
}

blindfire( behaviorCallbacks )
{
	if ( !canBlindFire() )
		return false;
	
	return callOptionalBehaviorCallback( behaviorCallbacks.blindfire );
}

enemyIsHiding()
{
	// if this function is called, we already know that our enemy is not visible from exposed.
	// check to see if they're doing anything hiding-like.
	
	if ( !isdefined( self.enemy ) )
		return false;
	
	if ( isplayer( self.enemy ) )
	{
		if ( isdefined( self.enemy.health ) && self.enemy.health < self.enemy.maxhealth )
			return true;
	}
	else
	{
		if ( issentient( self.enemy ) && self.enemy isSuppressedWrapper() )
			return true;
	}
	
	if ( isdefined( self.enemy.isreloading ) && self.enemy.isreloading )
		return true;
	
	return false;
}

wouldBeSmartForMyAITypeToSeekOutEnemy()
{
	// TODO: return false if I'm a sniper or RPG guy,
	// or any other kind of guy who wouldn't want to be close to the enemy.
	return true;
}

resetSeekOutEnemyTime()
{
	// we'll be willing to actually run right up to our enemy in order to find them if we haven't seen them by this time.
	// however, we'll try to find better cover before seeking them out
	self.seekOutEnemyTime = gettime() + randomintrange( 7000, 20000 );
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
	foundBetterCover = lookForBetterCover();
	
	if ( !foundBetterCover && isValidEnemy( self.enemy ) && wouldBeSmartForMyAITypeToSeekOutEnemy() )
	{
		if ( gettime() >= self.seekOutEnemyTime )
		{
			return tryRunningToEnemy();
		}
	}
	
	// TODO: maybe at this point we could look for someone who's suppressing our enemy,
	// and if someone is, we can say "cover me!" and have them say "i got you covered" or something.
	
	return foundBetterCover;
}

tryToGetOutOfDangerousSituation()
{
	// maybe later we can do something more sophisticated here
	return lookForBetterCover();
}
