#include animscripts\anims;
#include animscripts\utility;
#include animscripts\bigdog\bigdog_utility;
#include common_scripts\utility;
#include maps\_turret;
#include maps\_utility;

#define CONST_WAIT_REACQUIRE_TIME 2000

#using_animtree ("bigdog");

main()
{
	self endon("killanimscript");

	animscripts\bigdog\bigdog_utility::initialize("combat");
	
	// return to normal cover behavior
	//self.keepClaimedNode = false;

	combatIdle();
}

end_script()
{
}

combatIdle()
{
	/#self animscripts\debug::debugPushState( "combatIdle" );#/
		
	self OrientMode( "face angle", self.angles[1] );
	self AnimMode( "zonly_physics" );
	
	hunkerDown();
	
	lastSawEnemyTime = GetTime();
			
	while(1)
	{
		if( fireLauncher() )
			continue;
		
		if( combatTurn() )
			continue;
		
		canSeeEnemy = IsDefined(self.enemy) && self canSee( self.enemy );
		if( canSeeEnemy )
			lastSawEnemyTime = GetTime();

		// if you can move, but can't shoot the enemy from current position
		if( self.canMove && IsDefined(self.enemy) && !self.fixedNode )
		{
			canShootEnemy = self.turret can_turret_hit_target( self.enemy );
			 	
			if( !canSeeEnemy || !canShootEnemy )
			{
				// and it's been a little while
				if( GetTime() - lastSawEnemyTime > CONST_WAIT_REACQUIRE_TIME )
				{
					// see if we can find a better node
					betterNode = self FindBestCoverNode();
					
					if( IsDefined( betterNode ) && ( !IsDefined(self.node) || betterNode != self.node ) )
					{
						self UseCoverNode( betterNode );
					}
					else if( tryReacquire() )
					{
						return;
					}
				}
			 }
		}

		animName = getIdleAnimName();
		self SetFlaggedAnimRestart( "combat_idle", animArray( animName, "stop" ), 1, 0.2, 1 );
		self animscripts\shared::DoNoteTracks( "combat_idle" );
	}
	
	/#self animscripts\debug::debugPopState();#/
}

hunkerDown()
{		
	if( !self.hunkeredDown )
	{
		/#self animscripts\debug::debugPushState( "hunkerDown" );#/
			
		self OrientMode( "face angle", self.angles[1] );
		self AnimMode( "zonly_physics", false );
		
		PlayFX( anim._effect["bigdog_dust_cloud"], self.origin );
		
		animName = "hunker_down" + animSuffix();
		hunkerAnim = animArray( animName, "stop" );
		
		self SetFlaggedAnimKnobAllRestart( "hunker", hunkerAnim, %root, 1, 0.2, 1 );
		self animscripts\shared::DoNoteTracks( "hunker" );
		self ClearAnim( hunkerAnim, 0.2 );		
		
		self.hunkeredDown = true;
		
		/#self animscripts\debug::debugPopState();#/
	}
}

hunkerUp()
{
	if( self.hunkeredDown )
	{
		/#self animscripts\debug::debugPushState( "hunkerUp" );#/
			
		self OrientMode( "face angle", self.angles[1] );
		self AnimMode( "zonly_physics", false );
		
		animName = "hunker_up" + animSuffix();
		hunkerAnim = animArray( animName, "stop" );
		
		self SetFlaggedAnimKnobAllRestart( "hunker", hunkerAnim, %root, 1, 0.2, 1 );
		self animscripts\shared::DoNoteTracks( "hunker" );
		self ClearAnim( hunkerAnim, 0.2 );	
		
		self.hunkeredDown = false;
		
		/#self animscripts\debug::debugPopState();#/
	}
}

combatTurn()
{
	return false;
	
	if( !IsDefined(self.enemy) )
		return false;
	
	if( !self.canMove )
		return false;
	
	if( GetTime() < self.a.scriptStartTime + 5000 )
		return false;
	
	if( !self canSee( self.enemy ) )
		return false;

	toEnemy = self.enemy.origin - self.origin;
	desiredAngle = VectorToAngles(toEnemy)[1];

	// how far to turn to face enemy
	angleDiff = AngleClamp180( desiredAngle - self.angles[1] );

	if( abs(angleDiff) > 10 )
	{
		// don't allow breaking out into locomotion
		self.SafeToChangeScript = false;

		turn( angleDiff );

		self.SafeToChangeScript = true;

		return true;
	}

	return false;
}

turn( angleDiff )
{	
	turnRate = 10;
	
	absAngleDiff = abs( angleDiff );
	sign = sign( angleDiff );
	
	if( absAngleDiff < self.turnAngleThreshold )
		return false;
	
	/#self animscripts\debug::debugPushState( "turn", angleDiff );#/
		
	if( !self.hunkeredDown )
		hunkerDown();

	self OrientMode( "face angle", self.angles[1] );
	self AnimMode( "zonly_physics", false );
	
	// get up on piston
	animName = "hunker_up_turn";
	hunkerAnim = animArray( animName, "stop" );
	
	self SetFlaggedAnimKnobAllRestart( "hunker", hunkerAnim, %root, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "hunker" );

	while( absAngleDiff > 0 )
	{
		delta = Min( turnRate, absAngleDiff );		
		absAngleDiff -= delta;
		
		newYaw = self.angles[1] + (delta * sign);
		newAngles = ( self.angles[0], newYaw, self.angles[2] );
		self ForceTeleport( self.origin, newAngles );

		wait(0.05);
	}
	
	self.hunkeredDown = false;
	
	self ClearAnim( %root, 0.2 );
	
	/*
	// Need a script model for RotateTo
	rotator = Spawn( "script_model", self.origin );
	rotator.angles = self.angles;
	rotator SetModel( "tag_origin" );
	self LinkTo( rotator );
	
	rotator RotateYaw( newYaw, 1.0, 0.25, 0.25 );
	rotator waittill( "rotatedone" );
	
	self Unlink();
	rotator Delete();	
	*/
	
	/#self animscripts\debug::debugPopState();#/
	
	return true;
}

fireLauncher()
{
	if( !IsDefined(self.enemy) )
		return false;

	if( !self.a.allow_shooting )
		return false;

	if( self.grenadeammo <= 0 )
		return false;

	// 5 second cooloff
	if( GetTime() - self.a.lastShootTime < 5000 )
		return false;

	// don't allow breaking out into locomotion
	self.SafeToChangeScript = false;
	
	// the grenade is landing a bit too far forward for some reason
	toEnemy = self.enemy.origin - self.origin;
	toEnemy = (toEnemy[0], toEnemy[1], 0);
	toEnemy = VectorNormalize( toEnemy );
		
	grenadeTarget = self.enemy.origin;// + VectorScale(toEnemy, 100);
	
	launchPos = self GetTagOrigin( "tag_grenade" );
	launchPos += (0, 0, 20 ); // so it doesn't collide with the geo
	launchOffset = launchPos - self.origin;
	
	tempVec = ( launchOffset[0], launchOffset[1], 0 );
	launchOffset = ( Length( tempVec ), 0, launchOffset[2]); // return to model space because that's what checkGrenadeThrowPos expects
	
	recordLine( self.origin, launchPos, (1,0,0), "Script" );
	
	// try different arcs, starting with most direct one
	throwVel = self checkGrenadeThrowPos( launchOffset, "min time", grenadeTarget );
	if( !IsDefined( throwVel ) )
	{
		throwVel = self checkGrenadeThrowPos( launchOffset, "min energy", grenadeTarget );
		
		if( !IsDefined( throwVel ) )
		{
			throwVel = self checkGrenadeThrowPos( launchOffset, "max time", grenadeTarget );
		}
	}
	
	// don't launch if there's no good trajectory for the grenade
	if( !IsDefined( throwVel ) )
		return false;
	
	self MagicGrenadeManual( launchPos, throwVel, 5.0 );
	
	self notify( "grenade_fire_bigdog", grenadeTarget );

	self.a.lastShootTime = GetTime();

	self.SafeToChangeScript = true;

	return true;
}

moveToNextBestNode()
{
	// TODO: hack, do properly later
	// self.iswounded = true;
	
	// don't move if fixed
	if( self.fixedNode )
		return;
	
	betterNodes = self FindBestCoverNodes( self.goalradius, self.goalpos );
	
	bestNode = undefined;
	bestDistSq = 9999999;
	const minDistSq = 128*128;
	
	//FindPath( start, end, false );
				
	// find the closest good node
	foreach( node in betterNodes )
	{
		if( !IsDefined(self.node) || node != self.node )
		{
			distSq = DistanceSquared( self.origin, node.origin );
			
			if( distSq < bestDistSq && distSq > minDistSq )
			{
				bestDistSq = distSq;
				bestNode = node;
			}
		}
	}
	
	if( IsDefined( bestNode ) )
	{
		recordLine( self.origin, bestNode.origin, (0,1,0), "Script", self );
		
		// doesn't work because claimed node will get flushed in code for a million reasons
		self UseCoverNode( bestNode );
	}
}

getIdleAnimName()
{
	animSuffix = animSuffix();
	
	animName = "idle" + animSuffix;
	
	if( self.hunkeredDown )
		animName = "hunker_idle" + animSuffix;
	
	return animName;
}

tryReacquire()
{
	// try to manually move to get a sight line
	if( self ReacquireStep( 64 ) )
		return true;
	else if( self ReacquireStep( 128 ) )
		return true;
	else if( self ReacquireStep( 192 ) )
		return true;
	else if( self ReacquireStep( 256 ) )
		return true;
	
	return false;
}