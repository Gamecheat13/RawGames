main( turret )
{
	self endon( "killanimscript" ); // code
 
    animscripts\utility::initialize( "saw" );

	self.a.special = "saw";

	if ( isDefined( turret.script_delay_min ) )
		turret_delay = turret.script_delay_min;
	else
		turret_delay = maps\_mgturret::burst_fire_settings( "delay" );

	if ( isDefined( turret.script_delay_max ) ) 
		turret_delay_range = turret.script_delay_max - turret_delay;
	else
		turret_delay_range = maps\_mgturret::burst_fire_settings( "delay_range" );

	if ( isDefined( turret.script_burst_min ) )
		turret_burst = turret.script_burst_min;
	else
		turret_burst = maps\_mgturret::burst_fire_settings ( "burst" );

	if ( isDefined( turret.script_burst_max ) ) 
		turret_burst_range = turret.script_burst_max - turret_burst;
	else
		turret_burst_range = maps\_mgturret::burst_fire_settings ( "burst_range" );

	pauseUntilTime = getTime();
	turretState = "start";
	
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	turret show();

	if ( isDefined( turret.aiOwner ) )
	{
		assert( turret.aiOwner == self );
		self.a.postScriptFunc = ::postScriptFunc;
		self.a.usingTurret = turret;
	}
	else
	{
		self.a.postScriptFunc = ::preplacedPostScriptFunc;
	}
	
	turret.doFiring = false;
	self thread fireController( turret );
	
	
	self setTurretAnim( self.primaryTurretAnim );
	self setAnimKnobRestart( self.primaryTurretAnim, 1, 0.2, 1 );
	
	self setAnimKnobLimitedRestart( self.additiveTurretIdle );
	self setAnimKnobLimitedRestart( self.additiveTurretFire );
	
	turret setAnimKnobLimitedRestart( turret.additiveTurretIdle );
	turret setAnimKnobLimitedRestart( turret.additiveTurretFire );
	
	
	for (;;)
	{
		if ( turret.doFiring )
		{
			thread DoShoot( turret );
			
			wait ( randomFloatRange( turret_burst, turret_burst + turret_burst_range ) );
			turret notify ( "turretstatechange" );
			
			if ( turret.doFiring )
			{
				thread DoAim( turret );
				wait ( randomFloatRange( turret_delay, turret_delay + turret_delay_range ) );
			}
		}
		else
		{
			thread DoAim( turret );
			turret waittill ( "turretstatechange" );
		}		
	}
}


fireController( turret )
{
	self endon ( "killanimscript" );
	
	for (;;)
	{
		while ( isDefined( self.enemy ) )
		{
			if ( within_fov( turret.origin, turret getTagAngles( "tag_aim" ), self.enemy.origin, cos( 10 ) ) )
			{
				if ( !turret.doFiring )
				{
					turret.doFiring = true;
					turret notify ( "turretstatechange" );
				}
			}
			else if ( turret.doFiring )
			{
				turret.doFiring = false;
				turret notify ( "turretstatechange" );
			}
			
			wait ( 0.05 );
		}
		
		if ( turret.doFiring )
		{
			turret.doFiring = false;
			turret notify ( "turretstatechange" );
		}
		
		wait ( 0.05 );
	}
}	


turretTimer( duration, turret )
{
	if (duration <= 0)
		return;

	self endon( "killanimscript" ); // code
	turret endon( "turretstatechange" ); // code

	wait ( duration );
	turret notify( "turretstatechange" );
}


postScriptFunc( animscript )
{
	if ( animscript == "pain" )
	{
		self.a.usingTurret hide();
		self animscripts\shared::placeWeaponOn( self.weapon, "right" );
		self.a.postScriptFunc = ::postPainFunc;
		return;
	}
	
	assert( self.a.usingTurret.aiOwner == self );
	
	if ( animscript == "saw" )
	{
		turret = self getTurret();
		assert( isDefined( turret ) && turret == self.a.usingTurret );
		return;
	}
	
	self.a.usingTurret delete();
	self.a.usingTurret = undefined;

	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

postPainFunc( animscript )
{
	assert( isDefined( self.a.usingTurret ) );
	if ( animscript != "saw" )
	{
		self.a.usingTurret delete();
	}
}


preplacedPostScriptFunc( animscript )
{
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}


within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = vectorNormalize( end_origin - start_origin );
	forward = anglestoforward( start_angles );
	dot = vectorDot( forward, normal );

	return dot >= fov;
}


// ==================================

#using_animtree("generic_human");

DoShoot( turret )
{
	self setAnim( %additive_saw_idle, 0, .1 );
	self setAnim( %additive_saw_fire, 1, .1 );
	
	turret turretDoShootAnims();
	
	TurretDoShoot(turret);
}

DoAim( turret )
{
	self setAnim( %additive_saw_idle, 1, .1 );
	self setAnim( %additive_saw_fire, 0, .1 );
	
	turret turretDoAimAnims();
}


//=====================================
#using_animtree("mg42");

TurretDoShoot( turret )
{
	self endon("killanimscript");
	turret endon("turretstatechange"); // code or script
	
	for (;;)
	{
		turret ShootTurret();
		wait 0.1;
	}
}

turretDoShootAnims()
{
	self setAnim( %additive_saw_idle, 0, .1 );
	self setAnim( %additive_saw_fire, 1, .1 );
}

turretDoAimAnims()
{
	self setAnim( %additive_saw_idle, 1, .1 );
	self setAnim( %additive_saw_fire, 0, .1 );
}

