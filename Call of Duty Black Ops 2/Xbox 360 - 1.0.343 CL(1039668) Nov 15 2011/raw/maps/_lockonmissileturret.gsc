#include maps\_utility;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

init( bUseAdsLockon, func_GetBestMissileTurretTarget, maxTargets )
{
	//precacherumble ( "missileTurret_lock_rumble" );
	game["locking_on_sound"] = "wpn_sam_locking";
	game["locked_on_sound"] = "wpn_sam_lockon";
	game["acquired_sound"] = "wpn_sam_acquired";
	game["killshot_sound"] = "wpn_sam_hit";
	game["tracking_sound"] = "wpn_sam_tracking";
	game["lost_target_sound"] = "wpn_sam_target_lost";
	game["tracking_loop_sound"] = "wpn_sam_tracking_loop";	
	
	PrecacheString( &"hud_weapon_locking" );	
	PrecacheString( &"hud_weapon_locked" );	
	PrecacheString( &"hud_missile_fire" );
	PrecacheString( &"hud_turret_zoom" );
	
	if ( !IsDefined( bUseAdsLockon ) )
		bUseAdsLockon = false;
	
	game["missileTurret_useadslockon"] = bUseAdsLockon;
	
	thread onPlayerConnect();
	
	if( !IsDefined( func_GetBestMissileTurretTarget ) )
	{
		level.func_GetBestMissileTurretTarget = ::GetBestMissileTurretTarget;
	}
	else
	{
		level.func_GetBestMissileTurretTarget = func_GetBestMissileTurretTarget;
	}
	
	if ( !IsDefined( maxTargets ) )
	{
		level.missileTurretMaxTargets = 1;	
	}
	else
	{
		level.missileTurretMaxTargets = maxTargets;		
	}
		
}

main()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self.lockonmissilezoom = false;
	
	for (;;)
	{
		self waittill_any( "turretownerchange", "enter_vehicle" );

		if ( UsingValidWeapon() )
		{
			self notify( "missileTurret_on" );			
			
			if ( level.missileTurretMaxTargets > 1 )
			{
				self thread MissileTurretMultiLockLoop();				
				self thread MissileFiredNotify( true );
			}
			else
			{
				self thread MissileTurretLoop();
				self thread MissileFiredNotify( false );				
			}
			
		}
		
		self waittill_any( "turretownerchange", "exit_vehicle" );		
		
		self notify( "missileTurret_off" );
		
		self ClearLockonTarget();
		self ClearViewLockEnt();
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		// start the logic
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self ClearLockonTarget();
		
		thread main();
	}
}

ClearLockonTarget()
{
	self notify( "stinger_irt_cleartarget" );
	self notify( "stop_lockon_sound" );
	self notify( "stop_locked_sound" );
	self notify( "stop_tracking_sound" );	
	
	self.missileturretlocksound = undefined;
	self.missileTurretKillshotSound = undefined;
	
	Target_ClearReticlelockon();

	LUINotifyEvent( &"hud_weapon_locking", 1, 0 );
	LUINotifyEvent( &"hud_weapon_locked", 1, 0 );	
	
	level notify( "missile_turret_lock_off" );
	
	//self StopRumble( "missileturret_lock_rumble" );

	self.missileturretLockStartTime = 0;
	self.missileturretLockStarted = false;
	self.missileturretLockFinalized = false;
	self.missileturretLockLostStartTime = 0;
	
	if( isdefined(self.missileturretTarget) )
	{
		self.missileTurretTarget notify( "missileLockTurret_cleared" );	

		if ( level.missileTurretMaxTargets == 1 )
		{
			self.missileTurretTarget.locked_on = false;	
		}
	}
	self.missileTurretTarget = undefined;
	
	turret = self GetTurretWeapon();
	if ( IsDefined( turret ) )
		turret ClearTargetEntity();

	self WeaponLockFree();
	self WeaponLockTargetTooClose( false );
	self WeaponLockNoClearance( false );

	//self StopLocalSound( game["locking_on_sound"] );
	//self StopLocalSound( game["locked_on_sound"] );
}


MissileFiredNotify( b_multi_target_turret )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "missileTurret_off" );	

	self.missileTurretFiring = false;
	
	while ( true )
	{
		turret = self GetTurretWeapon();
		if ( !IsDefined( turret ) )
			continue;
		
		level.player waittill( "missile_fire", missile );
		//missile thread StartMissileCam();

		if ( !UsingValidWeapon() )
			return;
		
		if( isdefined(self.missileTurretTarget) )
		{
			if ( !b_multi_target_turret )
			{
				self.missileTurretTarget notify( "missileTurret_fired_at_me", missile );
				self.missileTurretTarget thread MissileTargetDeath();
			}
			else
			{
				// Add to multi-target list even if we're still locking on
				self.missileTurretTarget.locked_on = true;
				self.missileTurretTargetList[ self.missileTurretTargetList.size ] = self.missileTurretTarget;
				self.missileTurretTarget SetClientFlag( 0 );
				self.missileTurretTarget thread MissileTurretTargetDeathTread( self );
			
				self ClearLockonTarget();
			}
			
			//missile thread MissileDeath();
			LUINotifyEvent( &"hud_weapon_locked", 1, 2 );				
		}
		
		if( IS_TRUE(b_multi_target_turret) )
		{
			if ( IS_FALSE( self.missileTurretFiring ) )
			{
				if ( level.missileTurretMaxTargets > 1 && self.missileTurretTargetList.size > 0  )
				{
					//missile Missile_SetTarget( self.missileTurretTargetList[0] );
					
					if ( IsDefined( level.sam_hud_damage_ent ) )
					{	
						level.sam_hud_damage_ent ClearClientFlag( 4 );					
						level.sam_hud_damage_ent SetClientFlag( 5 );
					}					
					
					self thread MultiLockMissileFire();
				}
				else
				{
					missile Missile_SetTarget( undefined );
				}
			}
		}
		
		LUINotifyEvent( &"hud_missile_fire", 2, 1, Int( WeaponFireTime( self GetTurretWeaponName() ) ) * 1000 );
			
		self notify( "missileTurret_fired" );
	}
}

MultiLockMissileFire()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "missileTurret_off" );	

	const fireDelay = 0.1;

	self.missileTurretFiring = true;
	
	wait( fireDelay );	

	turret = self GetTurretWeapon();
	seat = turret GetOccupantSeat( level.player );
	
	if ( IsDefined( turret ) )
		turret ClearGunnerTarget( seat );	
	
	for ( i = 1; i < self.missileTurretTargetList.size; i++ )
	{
		if ( IsStillValidTarget( self.missileTurretTargetList[i] ) )
		{
			if ( seat == 0 )
			{
				turret FireWeapon( self.missileTurretTargetList[i] );
			}
			else
			{
				turret SetGunnerTargetEnt( self.missileTurretTargetList[i], ( 0, 0, 0 ), seat - 1 );				
				missile = turret FireGunnerWeapon( seat - 1 );				
				missile SetForceNoCull();
			}
			
			LUINotifyEvent( &"hud_missile_fire", 2, i + 1, Int( WeaponFireTime( self GetTurretWeaponName() ) ) * 1000 );
			
			self.missileTurretTargetList[i] notify( "missileTurret_fired_at_me", missile );
			//self.missileTurretTargetList[i] thread MissileTargetDeath();			
			
			level.player PlaySound("evt_turret_shake");
			Earthquake( 0.25, 0.25, self.origin, 512, self );
		}
		
		wait( fireDelay );
	}
	
	turret ClearGunnerTarget( seat );
	self notify( "missile_turret_firing_done" );
	wait( 0.05 );

	for ( i = 0; i < self.missileTurretTargetList.size; i++ )
	{
		if ( IsDefined( self.missileTurretTargetList[i] ) )
		{
			self.missileTurretTargetList[i].locked_on = false;
			self.missileTurretTargetList[i] ClearClientFlag( 0 );		
		}
		self.missileTurretTargetList[i] = undefined;
	}
	self.missileTurretFiring = false;

	self thread MissileTurretClientFlags();
}

MissileTurretClientFlags()
{
	self endon( "damage" );
	
	if ( IsDefined( level.sam_hud_damage_ent ) )
	{
		level.sam_hud_damage_ent SetClientFlag( 4 );		
		level.sam_hud_damage_ent ClearClientFlag( 5 );
		
		wait( 0.33 );
		
		level.sam_hud_damage_ent ClearClientFlag( 4 );		
	}
}


MissileTargetDeath()
{
	self waittill( "death", attacker, damageFromUnderneath, weaponName );	
	LUINotifyEvent( &"hud_weapon_locked", 1, 3 );		
}


MissleDeath()
{
	self endon( "missile_hit" );
	
	self waittill( "death" );
	LUINotifyEvent( &"hud_weapon_locked", 1, 4 );
}


MissileTurretLoop()  // self = player
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "missileTurret_off" );

	lockLength =  WeaponLockOnSpeed( self GetTurretWeaponName() );
	lock_lost_time = 1000;  // milliseconds
	
	// custom missile turret 'lost lock' time can be set here. This is the time it takes to lose a target once it's out of view. -TravisJ 11/12/2011
	if ( IsDefined( self.missile_turret_lock_lost_time ) && IsInt( self.missile_turret_lock_lost_time ) )
	{
		lock_lost_time = self.missile_turret_lock_lost_time;
	}
	
	for (;;)
	{
		wait 0.05;
	
		if ( self.missileTurretLockFinalized )
		{
			if ( !IsStillValidTarget( self.missileTurretTarget ) || !CanLockOn() )
			{
				self ClearLockonTarget();
				continue;
			}
			
			if ( !InsidemissileTurretReticleLocked( self.missileTurretTarget ) )
			{
				if ( self.missileturretLockLostStartTime == 0 )
				{
					self.missileturretLockLostStartTime = GetTime();
				}
				
				timepassed = GetTime() - self.missileturretLockLostStartTime;
				if ( timepassed > lock_lost_time )
				{
					self ClearLockonTarget();
					//SOUND - Shawn J
					//iprintlnbold ("target lost");
					self playlocalsound( game["lost_target_sound"] );
				}
				
				continue;				
			}
			
			thread LoopLocalLockSound( game["locked_on_sound"], 0.5 );
			// SOUND - Shawn J - interval above was 0.3
			
			//thread LoopLocalTrackingSound( game["tracking_sound"], self.missileTurretTarget );
			//SOUND - Shawn J - trying out looping sound instead of looping one-shot
			thread LoopLocalTrackingSoundRealLoop( game["tracking_loop_sound"], self.missileTurretTarget );
			thread PlayLocalKillshotSound( game["killshot_sound"], self.missileTurretTarget );

			self.missileTurretTarget notify( "missileLockTurret_locked" );
			self.missileTurretTarget.locked_on = true;
			
			turret = self GetTurretWeapon();
			turret SetTargetEntity( self.missileTurretTarget );
			
			self SetTargetTooClose( self.missileTurretTarget );
			//self SetNoClearance();
			
			
			//print3D( self.missileTurretTarget.origin, "* LOCKED!", (.2, 1, .3), 1, 5 );
			continue;
		}

		if ( self.missileTurretLockStarted )
		{
			if ( !IsStillValidTarget( self.missileTurretTarget ) || !CanLockOn() || !IsStillBestTarget( self.missileTurretTarget ) )
			{
				self ClearLockonTarget();
				continue;
			}

			timePassed = getTime() - self.missileTurretLockStartTime;
			if ( timePassed < lockLength )
			{
				LUINotifyEvent( &"hud_weapon_locking", 3, 1, Int( timePassed ), Int( lockLength ) );
				continue;
			}

			assert( isdefined( self.missileTurretTarget ) );

			if ( !CanLockOn() )
				continue;
			
			self notify( "stop_lockon_sound" );
			
			self.missileTurretLockFinalized = true;
			self WeaponLockFinalize( self.missileTurretTarget );
			self SetTargetTooClose( self.missileTurretTarget );
//			self SetNoClearance();
//			self.missileTurretTarget DrawTrajectory( true );
			
			LUINotifyEvent( &"hud_weapon_locking", 1, 0 );
			LUINotifyEvent( &"hud_weapon_locked", 1, 1 );	
			
			level notify( "missile_turret_locked" );

			continue;
		}
		
		if ( !CanLockOn() )
			continue;		
		
		//bestTarget = self GetBestMissileTurretTarget();
		bestTarget = self [[level.func_GetBestMissileTurretTarget]]();
		
		if ( !isDefined( bestTarget ) )
			continue;

		//if ( !( self LockSightTest( bestTarget ) ) )
		//	continue;

		self.missileTurretTarget = bestTarget;
		self.missileTurretLockStartTime = getTime();
		self.missileTurretLockStarted = true;

		// most likely I don't need this for the missileTurret.
		self WeaponLockStart( bestTarget );
		Target_StartReticlelockon( bestTarget, 2 );
		
		LUINotifyEvent( &"hud_weapon_locking", 1, 1 );		

		self thread LoopLocalSeekSound( game["locking_on_sound"], 0.8 );
		self notify( "lock_on_missile_turret_start" );
		//SOUND - Shawn J wait was 0.6
	}
}

MissileTurretMultiLockLoop()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "missileTurret_off" );

	lockLength =  WeaponLockOnSpeed( self GetTurretWeaponName() );
	
	if ( !IsDefined( self.missileTurretTargetList ) )
	{
		self.missileTurretTargetList = [];
	}
	else
	{
		for ( i = 0; i < self.missileTurretTargetList.size; i++ )
		{
			self.missileTurretTargetList[i] = undefined;
		}
		
		self.missileTurretTargetList = array_removeundefined( self.missileTurretTargetList );
	}	

	for (;;)
	{
		wait 0.05;
		
		if ( IS_TRUE( self.missileTurretFiring ) )
			continue;
		
		for ( i = 0; i < self.missileTurretTargetList.size; i++ )
		{
			if ( !IsStillValidTarget( self.missileTurretTargetList[i] ) || !InsideMissileTurretReticleLocked( self.missileTurretTargetList[i], 1000 ) )
			{
				if ( IsDefined( self.missileTurretTargetList[i] ) )
				{
					self.missileTurretTargetList[i].locked_on = false;
					self.missileTurretTargetList[i] ClearClientFlag( 0 );
				
					self.missileTurretTargetList = array_remove( self.missileTurretTargetList, self.missileTurretTargetList[i] );
				}
			}
			
			//if ( IsDefined( self.missileTurretTargetList[i] ) )
			//	print3D( self.missileTurretTargetList[i].origin, "* LOCKED!", (10, 10, 10), 1, 5 );
		}
		
		self.missileTurretTargetList = array_removeundefined( self.missileTurretTargetList );											
		
		//IPrintLn( self.missileTurretTargetList.size );
		
		if ( self.missileTurretTargetList.size >= level.missileTurretMaxTargets )
			continue;
		
		if ( self.missileTurretLockFinalized )
		{
			if ( !IsStillValidTarget( self.missileTurretTarget ) || !CanLockOn() )
			{
				self ClearLockonTarget();
				continue;
			}
			
			if ( !InsidemissileTurretReticleLocked( self.missileTurretTarget ) )
			{
				if ( self.missileturretLockLostStartTime == 0 )
				{
					self.missileturretLockLostStartTime = GetTime();
				}
				
				timepassed = GetTime() - self.missileturretLockLostStartTime;
				if ( timepassed > 1000 )
				{
					self ClearLockonTarget();
					//SOUND - Shawn J
					//iprintlnbold ("target lost");
					self playlocalsound( game["lost_target_sound"] );
				}
				
				continue;				
			}
			
			thread LoopLocalLockSound( game["locked_on_sound"], 0.5 );
			// SOUND - Shawn J - interval above was 0.3
			
			//thread LoopLocalTrackingSound( game["tracking_sound"], self.missileTurretTarget );
			//SOUND - Shawn J - trying out looping sound instead of looping one-shot
			thread LoopLocalTrackingSoundRealLoop( game["tracking_loop_sound"], self.missileTurretTarget );
			thread PlayLocalKillshotSound( game["killshot_sound"], self.missileTurretTarget );

			self.missileTurretTarget notify( "missileLockTurret_locked" );
			
			self SetTargetTooClose( self.missileTurretTarget );
			
			// Add to multi-target list
			self.missileTurretTarget.locked_on = true;
			self.missileTurretTargetList[ self.missileTurretTargetList.size ] = self.missileTurretTarget;
			self.missileTurretTarget SetClientFlag( 0 );
			self.missileTurretTarget thread MissileTurretTargetDeathTread( self );
			
			self ClearLockonTarget();
			
			turret = self GetTurretWeapon();
			if ( IsDefined( turret ) )
				turret ClearTargetEntity();	
	
			seat = turret GetOccupantSeat( level.player );
			
			if ( seat == 0 )
			{
				turret SetTargetEntity( self.missileTurretTargetList[ 0 ] );	
			}
			else
			{
				turret SetTargetEntity( self.missileTurretTargetList[ 0 ], ( 0, 0, 0 ), seat - 1 );
			}
			
			continue;
		}
		
		
		if ( self.missileTurretLockStarted )
		{
			if ( !IsStillValidTarget( self.missileTurretTarget ) || !CanLockOn() /*|| !IsStillBestTarget( self.missileTurretTarget )*/ )
			{
				self ClearLockonTarget();
				continue;
			}

			//print3D( self.missileTurretTarget.origin, "* locking...!", (.2, 1, .3), 1, 5 );
			
			timePassed = getTime() - self.missileTurretLockStartTime;
			locktime = locklength - ( locklength * ( self.missileTurretTargetList.size * 0.1 ) );
			
			if ( timePassed < locktime )
			{
				LUINotifyEvent( &"hud_weapon_locking", 3, 1, Int( timePassed ), Int( lockLength ) );
				continue;
			}

			assert( isdefined( self.missileTurretTarget ) );

			if ( !CanLockOn() )
				continue;
			
			self notify( "stop_lockon_sound" );
			
			self.missileTurretLockFinalized = true;
			self WeaponLockFinalize( self.missileTurretTarget );
			self SetTargetTooClose( self.missileTurretTarget );
//			self SetNoClearance();
			
			LUINotifyEvent( &"hud_weapon_locking", 1, 0 );
			LUINotifyEvent( &"hud_weapon_locked", 1, 1 );	

			continue;
		}		
		
		if ( !CanLockOn() )
			continue;		
		
		bestTarget = self [[level.func_GetBestMissileTurretTarget]]();
		
		if ( !isDefined( bestTarget ) )
			continue;

		//if ( !( self LockSightTest( bestTarget ) ) )
		//	continue;

		self.missileTurretTarget = bestTarget;
		self.missileTurretLockStartTime = getTime();
		self.missileTurretLockStarted = true;

		// most likely I don't need this for the missileTurret.
		self WeaponLockStart( bestTarget );
		Target_StartReticlelockon( bestTarget, 2 );
		
		LUINotifyEvent( &"hud_weapon_locking", 1, 1 );		

		self thread LoopLocalSeekSound( game["locking_on_sound"], 0.8 );
		self notify( "lock_on_missile_turret_start" );
		//SOUND - Shawn J wait was 0.6
		
	}
}

MissileTurretTargetDeathTread( player )
{
	self waittill( "death" );
	
	if ( IS_TRUE( player.missileTurretFiring ) )
	{
		player waittill( "missile_turret_firing_done" );
	}
		
	for ( i = 0; i < player.missileTurretTargetList.size; i++ )
	{	
		if ( IsDefined( player.missileTurretTargetList[i] ) )
		{
			if ( self == player.missileTurretTargetList[i] )
			{
				player.missileTurretTargetList[i] = undefined;
			}
		}
	}
}

LockSightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isDefined( target ) ) //targets can disapear during targeting.
		return false;
	
	passed = BulletTracePassed( eyePos, target.origin, false, target );
	if ( !passed )
		return false;

	front = target GetPointInBounds( 1, 0, 0 );
	BulletTracePassed( eyePos, front, false, target );
	if ( !passed )
		return false;

	back = target GetPointInBounds( -1, 0, 0 );
	passed = BulletTracePassed( eyePos, back, false, target );
	if ( !passed )
		return false;

	return true;
}

SoftSightTest()
{
	const LOST_SIGHT_LIMIT = 500;

	if ( self LockSightTest( self.missileTurretTarget ) )
	{
		self.missileTurretLostSightlineTime = 0;
		return true;
	}

	if ( self.missileTurretLostSightlineTime == 0 )
		self.missileTurretLostSightlineTime = getTime();

	timePassed = GetTime() - self.missileTurretLostSightlineTime;
	//PrintLn( "Losing sight of target [", timePassed, "]..." );

	if ( timePassed >= LOST_SIGHT_LIMIT )
	{
		//PrintLn( "Lost sight of target." );
		self ClearLockonTarget();
		return false;
	}
	
	return true;
}


GetBestMissileTurretTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if ( IsDefined( targetsAll[idx].locked_on ) && targetsAll[idx].locked_on == true )
			continue;
		
		if( self InsideMissileTurretReticleNoLock( targetsAll[idx] ) )//Free for all
		{
			targetsValid[targetsValid.size] = targetsAll[idx];
		}
	}

	if ( targetsValid.size == 0 )
		return undefined;

	chosenEnt = targetsValid[0];
	
	//bestdist = 999999;
	bestdot = -999;
	chosenindex = -1;
	if ( targetsValid.size > 1 )
	{
		forward = AnglesToForward( self GetPlayerAngles() );
		
		//TODO: find the closest
		for ( i = 0; i < targetsValid.size; i++ )
		{
			//dist = Distance( self.origin, targetsValid[i].origin );
			//if ( dist < bestdist )
			//{
			//	bestdist = dist;
			//	chosenindex = i;					
			//}
			
			vec_to_target = VectorNormalize( targetsValid[i].origin - self get_eye() );
			dot = VectorDot( vec_to_target, forward );
			
			if ( dot > bestdot )
			{
				bestdot = dot;
				chosenindex = i;				
			}
		}
	}
	
	if ( chosenindex > -1 )
		chosenEnt = targetsValid[chosenindex];
	
	return chosenEnt;
}

GetBestMissileTurretTarget_f38()
{
	a_targets_all = target_getArray();
	a_targets_valid = [];

	// only get targets within lockon distance
	a_targets_all = get_array_of_closest( self.origin, a_targets_all, undefined, 10, 12000 );

	// get all valid targets within lockon cone	
	for ( idx = 0; idx < a_targets_all.size; idx++ )
	{
		if( self InsideMissileTurretReticleNoLock( a_targets_all[ idx ] ) )//Free for all
		{
			a_targets_valid[ a_targets_valid.size ] = a_targets_all[ idx ];
		}
	}

	if ( a_targets_valid.size == 0 )
		return undefined;

	e_best_target = a_targets_valid[ 0 ];
	
	n_best_target_index = -1;
	best_distance = 99999;
	
	// find closest of targets in cone
	if ( a_targets_valid.size > 1 )
	{
		for ( i = 0; i < a_targets_valid.size; i++ )
		{
			n_dist_to_target = Distance( self.origin, a_targets_valid[ i ].origin );
			
			if ( n_dist_to_target < best_distance )
			{
				best_distance = n_dist_to_target;
				n_best_target_index = i;
			}
		}
	}
	
	if ( n_best_target_index > -1 )
		e_best_target = a_targets_valid[ n_best_target_index ];
	
	return e_best_target;
}

GetBestMissileTurretTargetList()
{
		
}


InsideMissileTurretReticleNoLock( target )
{
//	todo: sight trace dont' work well
//	if ( !sighttracepassed(level.player geteye(), target.origin, true, target) )
//		return false;
	
	weaponName = self GetTurretWeaponName();
	if ( weaponName == "" )
		return false;

	// HACK!!!
	fov =  GetDvarFloat( "cg_fov" );
	if ( weaponName == "sam_turret_sp" || weaponName == "sam_turret_player_sp" )
	{
		if ( self AdsButtonPressed() )
			fov = 15;
	}
	else if ( weaponName == "sam_turret_alt_sp" )
	{
		if ( self AdsButtonPressed() )
			fov = 50;
	}
	
	radius =  WeaponLockOnRadius( weaponName );
	return target_isincircle( target, self, fov, radius );
}

InsideMissileTurretReticleLocked( target, fallOff )
{
//	todo: sight trace dont' work well
//	if ( !sighttracepassed(level.player geteye(), target.origin, true, target) )
//		return false;
	
	weaponName = self GetTurretWeaponName();
	if ( weaponName == "" )
		return false;
	
	// HACK!!!	
	fov =  GetDvarFloat( "cg_fov" );
	if ( weaponName == "sam_turret_sp" || weaponName == "sam_turret_player_sp" )
	{
		if ( self AdsButtonPressed() )
			fov = 15;
	}
	
	radius = ( IsDefined( fallOff ) ? WeaponLockOnRadius( weaponName ) + fallOff : WeaponLockOnRadius( weaponName ) );
	return target_isincircle( target, self, fov, radius );
}

IsStillValidTarget( ent )
{
	if ( !IsDefined( ent ) )
		return false;
	if ( !target_isTarget( ent ) )
		return false;
	if ( IS_TRUE( ent.isacorpse ) )
		return false;
	if ( IsDefined(ent.classname ) && ( ent.classname == "script_vehicle_corpse" ) )
		return false;
	if ( ent.health <= 0 )
		return false;
	
	return true;
}

IsStillBestTarget( ent )
{
	//bestTarget = GetBestMissileTurretTarget();
	bestTarget = [[level.func_GetBestMissileTurretTarget]]();
	if ( IsDefined( bestTarget) && ( ent == bestTarget ) )
		return true;
	
	return false;
}

SetNoClearance()
{
	const ORIGINOFFSET_UP = 60;
	const ORIGINOFFSET_RIGHT = 10;
	const DISTANCE = 400;
	
	COLOR_PASSED = (0,1,0);
	COLOR_FAILED = (1,0,0);

	checks = [];
	checks[0] = ( 0, 0, 80 );
	checks[1] = ( -40, 0, 120 );
	checks[2] = ( 40, 0, 120 );
	checks[3] = ( -40, 0, 40 );
	checks[4] = ( 40, 0, 40 );
	
	if ( GetDvar( "missileDebugDraw" ) == "1" )
		debug = true;
	else
		debug = false;
	
	playerAngles = self GetPlayerAngles();
	forward = AnglesToForward( playerAngles );
	right = AnglesToRight( playerAngles );
	up = AnglesToUp( playerAngles );

	origin = self.origin + (0,0,ORIGINOFFSET_UP) + right * ORIGINOFFSET_RIGHT;

	obstructed = false;
	for( idx = 0; idx < checks.size; idx++ )
	{
		endpoint = origin + forward * DISTANCE + up * checks[idx][2] + right * checks[idx][0];
		trace = BulletTrace( origin, endpoint, false, undefined );
		
		if ( trace["fraction"] < 1 )
		{
			obstructed = true;
			if ( debug )
				line( origin, trace["position"], COLOR_FAILED, 1 );
			else
				break;
		}
		else
		{
			if ( debug )
				line( origin, trace["position"], COLOR_PASSED, 1 );
		}
	}
	
	self WeaponLockNoClearance( obstructed );
	self.noclearance = obstructed;

}

SetTargetTooClose( ent )
{
	const MINIMUM_STI_DISTANCE = 1000;

	if ( ! isDefined( ent ) )
		return false;
	dist = Distance2D( self.origin, ent.origin );
	
	//PrintLn( "Jav Distance: ", dist );
	
	if ( dist < MINIMUM_STI_DISTANCE )
	{
		self.targettoclose = true;
		self WeaponLockTargetTooClose( true );
	}
	else
	{
		self.targettoclose = false;
		self WeaponLockTargetTooClose( false );
	}

}

LoopLocalSeekSound( alias, interval )
{
	self endon ( "stop_lockon_sound" );
	self endon( "stop_seeking_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		//iprintlnbold( "Seeking...." );
		
		self playLocalSound( alias );
		//self PlayRumbleOnEntity( "missileTurret_lock_rumble" );

		wait interval;
	}
}

LoopLocalLockSound( alias, interval )
{
	self endon ( "stop_locked_sound" );
	//SOUND - above changed by Shawn J to kill lock sound once missile deployed.
	self endon( "disconnect" );
	self endon ( "death" );
	
	if ( isdefined( self.missileTurretlocksound ) )
		return;

	self.missileTurretlocksound = true;

	self playlocalsound( game["acquired_sound"] );
	
	wait (.5);
	//SOUND - Shawn J added wait
	self thread missile_lock_loop_audio( alias );
	for (;;)
	{
		//self playLocalSound( alias );
		//self PlayRumbleOnEntity( "missileTurret_lock_rumble" );
		wait interval;

		//self StopRumble( "missileTurret_lock_rumble" );
	}
	self.missileTurretlocksound = undefined;
}

missile_lock_loop_audio(alias)
{
	//iprintlnbold( alias );
	player = get_players()[0];
	player playloopsound( alias, .05 );
	self waittill_any( "stop_locked_sound", "disconnect", "death" );
	player stoploopsound(.05);
	
}

LoopLocalTrackingSound( alias, drone )
{
	self endon ( "stop_tracking_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	drone endon( "missileLockTurret_cleared" );
	drone endon( "death" );
	
	drone waittill( "missileTurret_fired_at_me", missile );
	
	self notify( "stop_seeking_sound" );
	self notify( "stop_locked_sound" );
	
	olde = undefined;
	const a = .001;
	const maxde = .1;
	const maxe = 1;
	const mine = .05;
	
	while(isdefined( missile ) && isdefined( drone ) )
	{
		d = Sqrt( Distance2D( missile.origin, drone.origin ) );
		
		e = d*a;
		if( !isdefined( olde ) )
			olde = e;
		
		de = e-olde;
		
		if( de > maxde )
			de = maxde;	
		if( de < -maxde )
			de = -maxde;
		
		e = de+olde;
		
		if( e > maxe )
			e = maxe;
		if( e < mine )
			e = mine;
		
		//iprintlnbold( "On Target...        " + d );
		self playLocalSound( alias );
		
		wait(e);
		olde = e;
	}
}

waittill_drone_done(player, drone, missile)
{
	player endon ( "stop_tracking_sound" );
	player endon( "disconnect" );
	player endon ( "death" );
	missile endon ( "death" );
	drone endon( "missileLockTurret_cleared" );
	drone waittill( "death" );
}

LoopLocalTrackingSoundRealLoop( alias, drone )
{	
	drone waittill( "missileTurret_fired_at_me", missile );
	
	self notify( "stop_seeking_sound" );
	self notify( "stop_locked_sound" );
	
	self playLoopSound( alias );
	
	waittill_drone_done(self,drone,missile);
	self stoploopsound ();
	
}

PLayLocalKillshotSound( alias, drone )
{
	//self endon ( "stop_locked_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	//drone endon( "missileLockTurret_cleared" );
	
	if ( isdefined( self.missileTurretKillshotSound ) )
		return;
	
	self.missileTurretKillshotSound = true;
	drone waittill( "death" );
	
	//iprintlnbold( "Killshot!" );
	self playLocalSound( alias );
	
	//SOUND - Shawn J - getting rid of locking sound that often happens with the hit
	//TODO: set up timing script to prevent locking sound during tracking and for 1 second after hit
	self notify( "stop_lockon_sound" );
	
	self.missileTurretKillshotSound = undefined;
	
	//TODO: Delete DDS call from here
	wait(1);
	self thread maps\_dds::dds_notify( "kill_confirm", true );
}

UsingValidWeapon()
{
	weapon_name = GetTurretWeaponName();
//	if ( !IsDefined( weapon_name ) || ( weapon_name != "m220_tow_emplaced_wireguided_sp" && weapon_name != "f35_missile_turret" && weapon_name != "sam_turret_sp" && weapon_name != "f35_missile_turret_player" ) )
//	{
//		return false;
//	}
	if ( IsDefined( weapon_name ) && weaponguidedmissiletype( weapon_name ) != "none" )
		return true;
	
	return false;
}

GetTurretWeaponName()
{
	viewlockedent = self.viewlockedentity;
	if ( IsDefined( viewlockedent ) )
	{
		if ( viewlockedent.classname == "misc_turret" )
		{
			return viewlockedent.weaponinfo;
		}
		else if ( viewlockedent.classname == "script_vehicle" )
		{
			for ( i = 0; i < 5; i++ )
			{
				occupant = viewlockedent GetSeatOccupant( i );
				if ( IsDefined( occupant ) && ( self == occupant ) )
				{
					return viewlockedent SeatGetWeapon( i );
				}
			}
		}
	}
	
	return "";
}

GetTurretWeapon()
{
	viewlockent = self.viewlockedentity;	
	if ( IsDefined( viewlockent ) )
	{
		return viewlockent;
	}	
	
	return undefined;
}

StartMissileCam()
{
	script_model = Spawn( "script_model", ( 0, 0, 0 ) );
	script_model SetModel( self.model );
	script_model Hide();
	
	script_model LinkTo( self, "tag_origin", ( 25, 0, 0 ) );
	script_model SetClientFlag( 0 );
	
	self waittill( "death" );
	script_model ClearClientFlag( 0 );
	script_model Delete();
}

CanLockOn()
{
	if ( IS_TRUE( self.lockondisabled ) )
		return false;
	
	if ( game["missileTurret_useadslockon"] )
	{
		if ( self AdsButtonPressed() )
		{
			if ( self.lockonmissilezoom == false )
			{
				self.lockonmissilezoom = true;
				LUINotifyEvent( &"hud_turret_zoom", 1, 1 );
			}
			
			return true;
		}
		else
		{
			if ( self.lockonmissilezoom == true )
			{
				self.lockonmissilezoom = false;
				LUINotifyEvent( &"hud_turret_zoom", 1, 0 );
			}
			
			return false;
		}
	}
	
	return true;
}

DisableLockOn()
{
	level.player.lockondisabled = true;	
}

EnableLockOn()
{
	level.player.lockondisabled = false;	
}

