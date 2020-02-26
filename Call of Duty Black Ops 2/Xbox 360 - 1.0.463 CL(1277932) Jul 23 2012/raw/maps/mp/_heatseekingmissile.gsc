#include maps\mp\_utility;
#include common_scripts\utility;

#insert raw\maps\mp\_clientflags.gsh;

init()
{
	precacherumble ( "stinger_lock_rumble" );
	game["locking_on_sound"] = "uin_alert_lockon_start";
	game["locked_on_sound"] = "uin_alert_lockon";
	PreCacheString( &"MP_CANNOT_LOCKON_TO_TARGET" );
	thread onPlayerConnect();

	level.fx_flare = LoadFX( "weapon/straferun/fx_straferun_chaf" );

	//Dvar is used with the dev gui so as to let the player target friendly vehicles with heat-seekers.
	/#
		SetDvar("scr_freelock", "0");
	#/
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self ClearIRTarget();
		thread StingerToggleLoop();
		//thread TraceConstantTest();
		self thread StingerFiredNotify();
	}
}

ClearIRTarget()
{
	self notify( "stinger_irt_cleartarget" );
	self notify( "stop_lockon_sound" );
	self notify( "stop_locked_sound" );
	self.stingerlocksound = undefined;
	self StopRumble( "stinger_lock_rumble" );

	self.stingerLockStartTime = 0;
	self.stingerLockStarted = false;
	self.stingerLockFinalized = false;
	if( isdefined(self.stingerTarget) )
	{
		LockingOn(self.stingerTarget, false);
		LockedOn(self.stingerTarget, false);
	}
	self.stingerTarget = undefined;

	self WeaponLockFree();
	self WeaponLockTargetTooClose( false );
	self WeaponLockNoClearance( false );

	self StopLocalSound( game["locking_on_sound"] );
	self StopLocalSound( game["locked_on_sound"] );

	self DestroyLockOnCanceledMessage();
}


StingerFiredNotify()
{
	self endon( "disconnect" );
	self endon ( "death" );

	while ( true )
	{
		self waittill( "missile_fire", missile, weap );

		if ( maps\mp\gametypes\_weapon_utils::isGuidedRocketLauncherWeapon( weap ) )
		{
				if( isdefined(self.stingerTarget) )
				{
					self.stingerTarget notify( "stinger_fired_at_me", missile, weap, self );
				}

				level notify ( "missile_fired", self, missile, self.stingerTarget, self.stingerLockFinalized );
				self notify( "stinger_fired", missile, weap );
		}
	}
}


StingerToggleLoop()
{
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self waittill( "weapon_change", weapon );

		while ( maps\mp\gametypes\_weapon_utils::isGuidedRocketLauncherWeapon( weapon ) )
		{
			abort = false;

			while( !self PlayerStingerAds() )
			{
				wait 0.05;

				if ( !maps\mp\gametypes\_weapon_utils::isGuidedRocketLauncherWeapon( self GetCurrentWeapon() ) )
				{
					abort = true;
					break;
				}
			}

			if ( abort )
			{
				break;
			}

			self thread StingerIRTLoop();

			while( self PlayerStingerAds() )
			{
				wait 0.05;
			}

			self notify( "stinger_IRT_off" );
			self ClearIRTarget();

			weapon = self GetCurrentWeapon();
		}
	}
}

StingerIRTLoop()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "stinger_IRT_off" );

	lockLength = self getLockOnSpeed();

	for (;;)
	{
		wait 0.05;

		//-------------------------
		// Four possible states:
		//      No missile in the tube, so CLU will not search for targets.
		//		CLU has a lock.
		//		CLU is locking on to a target.
		//		CLU is searching for a target to begin locking on to.
		//-------------------------

		if ( self.stingerLockFinalized )
		{
			passed = SoftSightTest();
			if ( !passed )
				continue;

			if ( ! IsStillValidTarget( self.stingerTarget ) )
			{
				self ClearIRTarget();
				continue;
			}
			
			if ( !self.stingerTarget.locked_on )
			{
				self.stingerTarget notify( "missile_lock", self );
			}
			
			LockingOn(self.stingerTarget, false);
			LockedOn(self.stingerTarget, true);
			thread LoopLocalLockSound( game["locked_on_sound"], 0.75 );

			
			//print3D( self.stingerTarget.origin, "* LOCKED!", (.2, 1, .3), 1, 5 );
			continue;
		}

		if ( self.stingerLockStarted )
		{
			if ( ! IsStillValidTarget( self.stingerTarget ) )
			{
				self ClearIRTarget();
				continue;
			}

			//print3D( self.stingerTarget.origin, "* locking...!", (.2, 1, .3), 1, 5 );
			
			LockingOn(self.stingerTarget, true);
			LockedOn(self.stingerTarget, false);

			passed = SoftSightTest();
			if ( !passed )
				continue;

			timePassed = getTime() - self.stingerLockStartTime;
			if ( timePassed < lockLength )
				continue;

			assert( isdefined( self.stingerTarget ) );
			self notify( "stop_lockon_sound" );
			self.stingerLockFinalized = true;
			self WeaponLockFinalize( self.stingerTarget );

			continue;
		}
		
		bestTarget = self GetBestStingerTarget();
		if ( !isDefined( bestTarget ) )
		{
			self DestroyLockOnCanceledMessage();

			continue;
		}

		if ( !( self LockSightTest( bestTarget ) ) )
		{
			self DestroyLockOnCanceledMessage();
			continue;
		}

		//check for delay allowing helicopters to enter the play area
		if( self LockSightTest( bestTarget ) && isDefined( bestTarget.lockOnDelay ) && bestTarget.lockOnDelay )
		{
			self DisplayLockOnCanceledMessage();
			continue;
		}
		
		self DestroyLockOnCanceledMessage();
		InitLockField( bestTarget );
		
		self.stingerTarget = bestTarget;
		self.stingerLockStartTime = getTime();
		self.stingerLockStarted = true;
		self.stingerLostSightlineTime = 0;

		// most likely I don't need this for the stinger.
		// level.player WeaponLockStart( bestTarget );

		self thread LoopLocalSeekSound( game["locking_on_sound"], 0.6 );
	}
}

DestroyLockOnCanceledMessage()
{
	if( isDefined( self.LockOnCanceledMessage ) )
		self.LockOnCanceledMessage destroy();
}

DisplayLockOnCanceledMessage()
{
	if( isDefined( self.LockOnCanceledMessage ) )
		return;

	self.LockOnCanceledMessage = newclienthudelem( self );
	self.LockOnCanceledMessage.fontScale = 1.25;
	self.LockOnCanceledMessage.x = 0;
	self.LockOnCanceledMessage.y = 50; 
	self.LockOnCanceledMessage.alignX = "center";
	self.LockOnCanceledMessage.alignY = "top";
	self.LockOnCanceledMessage.horzAlign = "center";
	self.LockOnCanceledMessage.vertAlign = "top";
	self.LockOnCanceledMessage.foreground = true;
	self.LockOnCanceledMessage.hidewhendead = false;
	self.LockOnCanceledMessage.hidewheninmenu = true;
	self.LockOnCanceledMessage.archived = false;
	self.LockOnCanceledMessage.alpha = 1.0;
	self.LockOnCanceledMessage SetText( &"MP_CANNOT_LOCKON_TO_TARGET" );
}
GetBestStingerTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		/#
		//This variable is set and managed by the 'dev_friendly_lock' function, which works with the dev_gui
		if( GetDvar( "scr_freelock") == "1" )
		{
			//If the dev_gui dvar is set, only check if the target is in the reticule. 
			if( self InsideStingerReticleNoLock( targetsAll[idx] ) )
			{
				targetsValid[targetsValid.size] = targetsAll[idx];
			}
			continue;
		}
		#/

		if ( level.teamBased ) //team based game modes
		{
			if ( IsDefined(targetsAll[idx].team) && targetsAll[idx].team != self.team) 
			{
				if ( self InsideStingerReticleNoLock( targetsAll[idx] ) )
				{
						targetsValid[targetsValid.size] = targetsAll[idx];
				}
			}
		}		
		else 
		{
			if( self InsideStingerReticleNoLock( targetsAll[idx] ) ) //Free for all
			{
				if( IsDefined( targetsAll[idx].owner ) && self != targetsAll[idx].owner )
				{
					targetsValid[targetsValid.size] = targetsAll[idx];
				}
			}
		}
	}

	if ( targetsValid.size == 0 )
		return undefined;

	chosenEnt = targetsValid[0];
	if ( targetsValid.size > 1 )
	{

		//TODO: find the closest
	}
	
	return chosenEnt;
}

InsideStingerReticleNoLock( target )
{
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}

InsideStingerReticleLocked( target )
{
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}

IsStillValidTarget( ent )
{
	if ( ! isDefined( ent ) )
		return false;
	if ( ! target_isTarget( ent ) )
		return false;
	if ( ! InsideStingerReticleLocked( ent ) )
		return false;

	return true;
}

PlayerStingerAds()
{
	return ( !self IsEMPJammed() && self PlayerAds() == 1.0 );
}

LoopLocalSeekSound( alias, interval )
{
	self endon ( "stop_lockon_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );

		wait interval;
	}
}

LoopLocalLockSound( alias, interval )
{
	self endon ( "stop_locked_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	
	if ( isdefined( self.stingerlocksound ) )
		return;

	self.stingerlocksound = true;

	for (;;)
	{
		// TODO make lock loop audio work correctly  CDC
		
		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/3;

		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/3;

		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/3;

		self StopRumble( "stinger_lock_rumble" );
	}
	self.stingerlocksound = undefined;
}

LockSightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isDefined( target ) ) //targets can disapear during targeting.
		return false;
	
	passed = BulletTracePassed( eyePos, target.origin, false, target );
	if ( passed )
		return true;

	front = target GetPointInBounds( 1, 0, 0 );
	passed = BulletTracePassed( eyePos, front, false, target );
	if ( passed )
		return true;

	back = target GetPointInBounds( -1, 0, 0 );
	passed = BulletTracePassed( eyePos, back, false, target );
	if ( passed )
		return true;

	return false;
}

SoftSightTest()
{
	LOST_SIGHT_LIMIT = 500;

	if ( self LockSightTest( self.stingerTarget ) )
	{
		self.stingerLostSightlineTime = 0;
		return true;
	}

	if ( self.stingerLostSightlineTime == 0 )
		self.stingerLostSightlineTime = getTime();

	timePassed = GetTime() - self.stingerLostSightlineTime;
	//PrintLn( "Losing sight of target [", timePassed, "]..." );

	if ( timePassed >= LOST_SIGHT_LIMIT )
	{
		//PrintLn( "Lost sight of target." );
		self ClearIRTarget();
		return false;
	}
	
	return true;
}

InitLockField( target )
{
	if ( IsDefined( target.locking_on ) )
		return;
		
	target.locking_on = 0;
	target.locked_on = 0;
}

LockingOn( target, lock )
{
	Assert( IsDefined( target.locking_on ) );
	
	clientNum = self getEntityNumber();
	if ( lock )
	{
		target notify( "locking on" );
		target.locking_on |= ( 1 << clientNum );
		
		self thread watchClearLockingOn( target, clientNum );
	}
	else
	{
		self notify( "locking_on_cleared" );
		target.locking_on &= ~( 1 << clientNum );
	}
}

watchClearLockingOn( target, clientNum )
{
	target endon("death");
	self endon( "locking_on_cleared" );
	
	self waittill_any( "death", "disconnect" );
	
	target.locking_on &= ~( 1 << clientNum );
}

LockedOn( target, lock )
{
	Assert( IsDefined( target.locked_on ) );
	
	clientNum = self getEntityNumber();
	if ( lock )
	{
		target.locked_on |= ( 1 << clientNum );
		
		self thread watchClearLockedOn( target, clientNum );
	}
	else
	{
		self notify( "locked_on_cleared" );
		target.locked_on &= ~( 1 << clientNum );
	}
}

watchClearLockedOn( target, clientNum )
{
	self endon( "locked_on_cleared" );
	
	self waittill_any( "death", "disconnect" );

	if ( IsDefined( target ) )
	{
		target.locked_on &= ~( 1 << clientNum );
	}
}

MissileTarget_LockOnMonitor( player, endon1, endon2 )
{
	self endon( "death" );
	
	if ( isdefined(endon1) )
		self endon( endon1 );
	if ( isdefined(endon2) )
		self endon( endon2 );

	for( ;; )
	{

		if( target_isTarget( self ) )
		{	
//			if ( self MissileTarget_isMissileIncoming() )
//			{
//				self SetClientFlag( CLIENT_FLAG_WARN_FIRED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_LOCKED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_TARGETED );
//			}	
//			else if( IsDefined(self.locked_on) && self.locked_on )
//			{
//				self SetClientFlag( CLIENT_FLAG_WARN_LOCKED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_FIRED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_TARGETED );
//			}
//			else if( IsDefined(self.locking_on) && self.locking_on )
//			{
//				self SetClientFlag( CLIENT_FLAG_WARN_TARGETED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_FIRED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_LOCKED );
//			}
//			else
//			{
//				self ClearClientFlag( CLIENT_FLAG_WARN_FIRED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_TARGETED );
//				self ClearClientFlag( CLIENT_FLAG_WARN_LOCKED );
//			}
		}
		
		wait( 0.1 );
	}
}

_incomingMissile( missile )
{
	if ( !IsDefined(self.incoming_missile) )
	{
		self.incoming_missile = 0;
	}
	
	self.incoming_missile++;
	
	self thread _incomingMissileTracker( missile );
}

_incomingMissileTracker( missile )
{
	self endon("death");
	
	missile waittill("death");
	
	self.incoming_missile--;
	
	assert( self.incoming_missile >= 0 );
}

MissileTarget_isMissileIncoming()
{
	if ( !IsDefined(self.incoming_missile) )
		return false;
		
	if ( self.incoming_missile )
		return true;
	
	return false;
}

MissileTarget_HandleIncomingMissile(responseFunc, endon1, endon2)
{
	level endon( "game_ended" );
	self endon( "death" );
	if ( isdefined(endon1) )
		self endon( endon1 );
	if ( isdefined(endon2) )
		self endon( endon2 );

	for( ;; )
	{
		self waittill( "stinger_fired_at_me", missile, weap, attacker );
			
		_incomingMissile(missile);
		
		if ( isdefined(responseFunc) )
			[[responseFunc]]( missile, attacker, endon1, endon2 );
	}
}

MissileTarget_ProximityDetonateIncomingMissile( endon1, endon2 )
{
	MissileTarget_HandleIncomingMissile( ::MissileTarget_ProximityDetonate, endon1, endon2 );
}

_missileDetonate( attacker )
{
	self endon ( "death" );
	radiusDamage( self.origin, 500, 600, 600, attacker );
	wait( 0.05 );
	self detonate();
	wait( 0.05 );
	self delete();
}

MissileTarget_ProximityDetonate( missile, attacker, endon1, endon2 )
{
	level endon( "game_ended" );
	missile endon ( "death" );
	if ( isdefined(endon1) )
		self endon( endon1 );
	if ( isdefined(endon2) )
		self endon( endon2 );
	
	minDist = distance( missile.origin, self.origin );
	lastCenter = self.origin;

	missile Missile_SetTarget( self );

	for ( ;; )
	{
		// already destroyed
		if ( !isDefined( self ) )
			center = lastCenter;
		else
			center = self.origin;
			
		lastCenter = center;		
		
		curDist = distance( missile.origin, center );
		
		if( curDist < 3500 && isdefined(self.numFlares) && self.numFlares > 0 )
		{
			self.numFlares--;			

			self thread MissileTarget_PlayFlareFx();
			self maps\mp\killstreaks\_helicopter::trackAssists( attacker, 0, true );
			newTarget = self MissileTarget_DeployFlares(missile.origin);

			missile Missile_SetTarget( newTarget );
			missileTarget = newTarget;
			
			return;
		}		
		
		if ( curDist < minDist )
			minDist = curDist;
		
		if ( curDist > minDist )
		{
			if ( curDist > 500 )
				return;
				
			missile thread _missileDetonate( attacker );
		}
		
		wait ( 0.05 );
	}	
}

MissileTarget_PlayFlareFx()
{
	if ( !isDefined( self ) )
		return;
	PlayFXOnTag( level.fx_flare, self, "tag_origin" );
	
	if ( isdefined( self.owner ) )
	{
		self playsoundtoplayer ( "veh_huey_chaff_drop_plr", self.owner );
	}
	self PlaySound ( "veh_huey_chaff_explo_npc" );
}

MissileTarget_DeployFlares(origin) // self == missile target
{
	vec_toForward = anglesToForward( self.angles );
	vec_toRight = AnglesToRight( self.angles );

	delta = self.origin - origin;
	dot = VectorDot(delta,vec_toRight);
	
	sign = 1;
	if ( dot > 0 ) 
		sign = -1;
		
	// out to one side or the other slightly backwards
	flare_dir = VectorNormalize(VectorScale( vec_toForward, -0.2 ) + VectorScale( vec_toRight, sign ));
	velocity = VectorScale( flare_dir, RandomIntRange(400, 600));
	velocity = (velocity[0], velocity[1], velocity[2] - RandomIntRange(10, 100) );

	flareOrigin = self.origin;
	if ( isdefined( self.flareOffset ) )
		flareOrigin = flareOrigin + self.flareOffset;
	
	flareObject = spawn( "script_origin", flareOrigin );
	flareObject.angles = self.angles;
	
	flareObject SetModel( "tag_origin" );
	flareObject MoveGravity( velocity, 5.0 );
	
	flareObject thread deleteAfterTime( 5.0 );

	self thread debug_tracker( flareObject );

	return flareObject;
}

debug_tracker( target )
{
	target endon( "death");
	
	while(1)
	{
		maps\mp\killstreaks\_airsupport::debug_sphere( target.origin, 10, (1,0,0), 1, 1 );
		wait(0.05);
	}
}