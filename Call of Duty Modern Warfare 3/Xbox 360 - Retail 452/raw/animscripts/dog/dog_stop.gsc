#using_animtree( "dog" );

main()
{
	self endon( "killanimscript" );

	self clearanim( %root, 0.1 );
	self clearanim( %german_shepherd_idle, 0.2 );
	self clearanim( %german_shepherd_attackidle_knob, 0.2 );

	self thread lookAtTarget( "attackIdle" );

	while ( 1 )
	{
		if ( shouldAttackIdle() )
		{
			self clearanim( %german_shepherd_idle, 0.2 );
			self randomAttackIdle();
		}
		else
		{
			self orientmode( "face current" );
			self clearanim( %german_shepherd_attackidle_knob, 0.2 );
			self setflaggedanimrestart( "dog_idle", %german_shepherd_idle, 1, 0.2, self.animplaybackrate );
		}

		animscripts\shared::DoNoteTracks( "dog_idle" );

		if ( isdefined( self.prevTurnRate ) )
		{
			self.turnRate = self.prevTurnRate;
			self.prevTurnRate = undefined;
		}
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

	return( ( forward[ 0 ] * vecToEnemy[ 0 ] ) + ( forward[ 1 ] * vecToEnemy[ 1 ] ) ) / distToEnemy > toleranceCosAngle;
}

randomAttackIdle()
{
	self clearanim( %german_shepherd_attackidle_knob, 0.1 );
	if ( isFacingEnemy( 0.866 ) )	// cos30
	{
		self OrientMode( "face angle", self.angles[1] );
	}
	else
	{
		if ( isdefined( self.enemy ) )
		{
			yawToEnemy = vectorToYaw( self.enemy.origin - self.origin );
			localYawToEnemy = AngleClamp180( yawToEnemy - self.angles[1] );
 			if ( Abs( localYawToEnemy ) > 10 )
			{
				self orientmode( "face enemy" );
				self.prevTurnRate = self.turnRate;
				self.turnRate = 0.3;

				if ( localYawToEnemy > 0)
				{
 					rotateAnim = %german_shepherd_rotate_ccw;
 				}
 				else
 				{
 					rotateAnim = %german_shepherd_rotate_cw;
 				}
				self setflaggedanimrestart( "dog_turn", rotateAnim, 1, 0.2, 1.0 );
				animscripts\shared::DoNoteTracks( "dog_turn" );

				self.turnRate = self.prevTurnRate;
				self.prevTurnRate = undefined;
				self clearanim( %german_shepherd_rotate_cw, 0.2 );
				self clearanim( %german_shepherd_rotate_ccw, 0.2 );
			}
		}
		self OrientMode( "face angle", self.angles[1] );
	}

	if ( should_growl() )
	{
		// just growl
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_growl, 1, 0.2, 1 );
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
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_b, 1, 0.2, self.animplaybackrate );
	else if ( rand < barkChance )
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_bark, 1, 0.2, self.animplaybackrate );
	else
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_growl, 1, 0.2, self.animplaybackrate );
}

shouldAttackIdle()
{
	return( isdefined( self.enemy ) && isalive( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 1000000 );
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

	self clearanim( %german_shepherd_look_2, 0 );
	self clearanim( %german_shepherd_look_4, 0 );
	self clearanim( %german_shepherd_look_6, 0 );
	self clearanim( %german_shepherd_look_8, 0 );

	self setDefaultAimLimits();
	self.rightAimLimit = 90;
	self.leftAimLimit = -90;

	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 2 ], 1, 0 );
	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 4 ], 1, 0 );
	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 6 ], 1, 0 );
	self setanimlimited( anim.dogLookPose[ lookPoseSet ][ 8 ], 1, 0 );

	self animscripts\track::setAnimAimWeight( 1, 0.2 );

/#	
	assert( !isdefined( self.trackLoopThread ) );
	self.trackLoopThread = thisthread;
	self.trackLoopThreadType = "lookAtTarget";
#/
	
	self animscripts\track::trackLoop( %german_shepherd_look_2, %german_shepherd_look_4, %german_shepherd_look_6, %german_shepherd_look_8 );
}