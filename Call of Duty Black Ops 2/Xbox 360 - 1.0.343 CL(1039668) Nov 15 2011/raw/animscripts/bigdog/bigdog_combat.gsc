#include animscripts\anims;
#include animscripts\utility;
#include animscripts\bigdog\bigdog_utility;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree ("bigdog");

main()
{
	self endon("killanimscript");

	animscripts\bigdog\bigdog_utility::initialize("combat");

	combatIdle();
}

end_script()
{
}

combatIdle()
{
	self OrientMode( "face angle", self.angles[1] );
	self AnimMode( "zonly_physics" );
			
	while(1)
	{
		if( fireLauncher() )
			continue;
		
		if( combatTurn() )
			continue;

		if( self.canMove && IsDefined(self.enemy) && (!self canSee( self.enemy ) || !self canShootEnemy()) )
		{
			if( self ReacquireStep( 32 ) )
				return;
			else if( self ReacquireStep( 64 ) )
				return;
			else if( self ReacquireStep( 96 ) )
				return;
		}

		animName = "idle" + animSuffix();

		self SetFlaggedAnimRestart( "combat_idle", animArray( animName, "stop" ), 1, 0.2, 1 );
		self animscripts\shared::DoNoteTracks( "combat_idle" );
	}
}

combatTurn()
{
	if( !IsDefined(self.enemy) )
		return false;
	
	if( !self.canMove )
		return false;
	
	if( GetTime() < self.a.scriptStartTime + 5000 )
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
	self OrientMode( "face angle", self.angles[1] );
	self AnimMode( "zonly_physics", false );

	turnAnimName = "turn_r";
	if( angleDiff > 0 )
	{
		turnAnimName = "turn_l";
	}

	turnAnimName += animSuffix();
	turnAnim = animArray( turnAnimName, "combat" );

	self SetFlaggedAnimKnobAllRestart( "turn", turnAnim, %body, 1, 0.2, 1 );

	// wait till end of anim or close enough
	timeLeft = GetAnimLength( turnAnim );
	while( timeLeft > 0 )
	{
		//angleDiff = AngleClamp180( desiredAngle - self.angles[1] );

		// break out if close enough
//			if( abs(angleDiff) < 10 )
//				break;

		wait(0.05);
		timeLeft -= 0.05;
	}

	self ClearAnim( %turns, 0.2 );
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
	
	grenadeTarget = self.enemy.origin + VectorScale(toEnemy, 100);
	
	self MagicGrenade( self GetTagOrigin( "tag_flash" ), grenadeTarget, 4.0 );
	
	self notify( "grenade_fire" );

	// play an anim so the dog slows down while shooting grenades
	self OrientMode( "face angle", self.angles[1] );
	self AnimMode( "zonly_physics" );

	animSuffix = animSuffix();

	self SetFlaggedAnimKnobAllRestart( "grenade_fire", animArray( "idle" + animSuffix, "stop" ), %body, 1, 0.2, 0.7 ); //slow down
	self animscripts\shared::DoNoteTracks( "grenade_fire" );
	
	self.a.lastShootTime = GetTime();

	self.SafeToChangeScript = true;

	return true;
}