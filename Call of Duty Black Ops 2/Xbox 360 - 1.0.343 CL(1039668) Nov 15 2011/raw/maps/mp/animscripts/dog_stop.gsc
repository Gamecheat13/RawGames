//#using_animtree ("dog");
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;

main()
{
	debug_anim_print("dog_stop::main()" );

	self endon("killanimscript");
	self SetAimAnimWeights( 0, 0 );
	
	self thread lookAtTarget( "attackIdle" );

	while (1)
	{
		if ( shouldAttackIdle() )
		{
			self randomAttackIdle();
			maps\mp\animscripts\shared::DoNoteTracks("done");
		}
		else
		{
			self set_orient_mode( "face current" );
			debug_anim_print("dog_stop::main() - Setting stop_idle"  );

			self notify( "stop tracking" );
			self SetAimAnimWeights( 0, 0 );
			self setanimstate( "stop_idle" );
			maps\mp\animscripts\shared::DoNoteTracks("done");
			self thread lookAtTarget( "attackIdle" );
		}

			debug_anim_print("dog_stop::main() - stop idle loop notify done." );
	}
}

isFacingEnemy( toleranceCosAngle )
{
	assert( isdefined( self.enemy ) );
	
	vecToEnemy = self.enemy.origin - self.origin;
	distToEnemy = length( vecToEnemy );
	
	if ( distToEnemy < 1 )
		return true;
	
	forward = anglesToForward( self.angles );
	
	val1 = ( forward[0] * vecToEnemy[0] ) + ( forward[1] * vecToEnemy[1] );
	val2 =(( forward[0] * vecToEnemy[0] ) + ( forward[1] * vecToEnemy[1] ) ) / distToEnemy;
	
	return ( ( forward[0] * vecToEnemy[0] ) + ( forward[1] * vecToEnemy[1] ) ) / distToEnemy > toleranceCosAngle;
}

randomAttackIdle()
{
	if ( isFacingEnemy( -0.5 ) )	// cos120
		self set_orient_mode( "face current" );
	else
		self set_orient_mode("face enemy");
	
	if ( should_growl() )
	{
		// just growl
		debug_anim_print("dog_stop::main() - Setting stop_attackidle_growl" );
		self setanimstate( "stop_attackidle_growl" );
		return;
	}

	idleChance = 33;
	barkChance = 66;

	if ( isdefined( self.mode ) )
	{
		if ( self.mode == "growl" )
		{
			idleChance = 15;
			barkChance = 30;
		}
		else if ( self.mode == "bark" )
		{
			idleChance = 15;
			barkChance = 85;
		}
	}

	rand = randomInt( 100 );
	if ( rand < idleChance )
	{
			debug_anim_print("dog_stop::main() - Setting stop_attackidle" );
			self setanimstate( "stop_attackidle" );
	}
	else if ( rand < barkChance )
	{
			debug_anim_print("dog_stop::main() - Setting stop_attackidle_bark " );
			self setanimstate( "stop_attackidle_bark" );
	}
	else
	{
			debug_anim_print("dog_stop::main() - Setting stop_attackidle_growl " );
			self setanimstate( "stop_attackidle_growl" );
	}
}

shouldAttackIdle()
{
	return ( isdefined( self.enemy ) && isalive( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 1000000 );
}

should_growl()
{
	if ( isdefined( self.script_growl ) )
		return true;
	if ( !isalive( self.enemy ) )
		return true;
	return !( self cansee( self.enemy ) );
}

lookAtTarget( lookPoseSet )
{
	self endon( "killanimscript" );
	self endon( "stop tracking" );
	debug_anim_print("dog_stop::lookAtTarget() - Starting look at " + lookPoseSet  );
	
	self.rightAimLimit = 90;
	self.leftAimLimit = -90;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
	
	self maps\mp\animscripts\shared::setAnimAimWeight( 1, 0.2 );
	self maps\mp\animscripts\shared::trackLoop( );
}
