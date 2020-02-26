#include maps\_utility;
#include common_scripts\utility;

init()
{
	//precacherumble ( "stinger_lock_rumble" );
	game["locking_on_sound"] = "wpn_sam_locking";
	game["locked_on_sound"] = "wpn_f35_lockon";
	game["acquired_sound"] = "wpn_sam_acquired";
	game["killshot_sound"] = "wpn_sam_hit";
	game["tracking_sound"] = "wpn_sam_tracking";
	
	// 1/22/2010 - TFLAME - Had a note to remove this minimum distance.  Setting to 0 for now.
	level.MINIMUM_STI_DISTANCE = 0;
	
	thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );


		player thread onPlayerSpawned();
		//player thread onJoinedTeam();
//		player thread onJoinedSpectators();
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
	//self StopRumble( "stinger_lock_rumble" );

	self.stingerLockStartTime = 0;
	self.stingerLockStarted = false;
	self.stingerLockFinalized = false;
	if( isdefined(self.stingerTarget) )
	{
		self.stingerTarget.no_lock = 0;
		self.stingerTarget.locked_on = 0;
	}
	self.stingerTarget = undefined;

	self WeaponLockFree();
	self WeaponLockTargetTooClose( false );
	self WeaponLockNoClearance( false );

	self StopLocalSound( game["locking_on_sound"] );
	self StopLocalSound( game["locked_on_sound"] );
}


StingerFiredNotify()
{
	self endon( "disconnect" );
	self endon( "death" );

	while ( true )
	{
		self waittill( "weapon_fired" );

		weap = self getCurrentWeapon();
		if ( weap != "strela_sp" && weap != "stinger_sp" && weap != "afghanstinger_ff_sp" && weap != "fhj18_sp" && weap != "fhj18_dpad_sp" && weap != "smaw_sp" )
			continue;
			
		if( isdefined(self.stingerTarget) )
			self.stingerTarget notify( "stinger_fired_at_me" );
			
		self notify( "stinger_fired" );
	}
}


StingerToggleLoop()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	for (;;)
	{
		while( !self PlayerStingerAds() )
		{
			wait 0.05;
		}
		
		self thread StingerIRTLoop();

		while( self PlayerStingerAds() )
		{
			wait 0.05;
		}
		
		self notify( "stinger_IRT_off" );
		self ClearIRTarget();
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

/*
		clipAmmo = level.player GetCurrentWeaponClipAmmo();
		if ( !clipAmmo )
		{
			ClearCLUTarget();
			continue;
		}
*/

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
			
			self.stingerTarget.no_lock = 0;
			self.stingerTarget.locked_on = 1;
			thread LoopLocalLockSound( game["locked_on_sound"], 0.75 );

			self SetTargetTooClose( self.stingerTarget );
			self SetNoClearance();
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
			
			self.stingerTarget.no_lock = 1;
			self.stingerTarget.locked_on = 0;

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
			self SetTargetTooClose( self.stingerTarget );
			self SetNoClearance();

			continue;
		}
		
		bestTarget = self GetBestStingerTarget();
		if ( !isDefined( bestTarget ) )
			continue;

		if ( !( self LockSightTest( bestTarget ) ) )
			continue;

		self.stingerTarget = bestTarget;
		self.stingerLockStartTime = getTime();
		self.stingerLockStarted = true;

		// most likely I don't need this for the stinger.
		// level.player WeaponLockStart( bestTarget );

		//-- MSG to switch to lock-on mode if using the afghanstinger
		if( self GetCurrentWeapon() == "afghanstinger_sp" )
		{
			screen_message_create( &"SCRIPT_AFGHANSTINGER_SWITCHTO_LOCKON" );
			
			self thread kill_lockon_screen_message( 3 );
			
			while( self GetCurrentWeapon() != "afghanstinger_ff_sp" ) //-- 3 seconds
			{
				wait(0.05);
			}
			
			screen_message_delete();
			self notify( "lockon_msg_killed" );
			return; //-- don't play any sounds or anything, just exit
		}
		
		self thread LoopLocalSeekSound( game["locking_on_sound"], 0.6 );
	}
}

kill_lockon_screen_message( n_time )
{
	self endon( "lockon_msg_killed" );
	
	count = 0;
	while( (n_time*20) > count ) //-- 3 seconds
	{
		count++;
		wait(0.05);
	}
	
	screen_message_delete();
}

LockSightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isDefined( target ) ) //targets can disapear during targeting.
		return false;
	
	passed = false;

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


GetBestStingerTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if( self InsideStingerReticleNoLock( targetsAll[idx] ) )//Free for all
		{
			targetsValid[targetsValid.size] = targetsAll[idx];
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
//	todo: sight trace dont' work well
//	if ( !sighttracepassed(level.player geteye(), target.origin, true, target) )
//		return false;
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}

InsideStingerReticleLocked( target )
{
//	todo: sight trace dont' work well
//	if ( !sighttracepassed(level.player geteye(), target.origin, true, target) )
//		return false;
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
	weap = self getCurrentWeapon();
	if ( weap != "strela_sp" && weap != "fhj18_sp" && weap != "fhj18_dpad_sp" && weap != "stinger_sp" && weap != "afghanstinger_ff_sp" && weap != "afghanstinger_sp" && weap != "smaw_sp" )
		return false;

	if ( self playerads() == 1.0 )
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
	
	debug = false;
/#
	if ( GetDvar( "missileDebugDraw" ) == "1" )
	{
		debug = true;
	}
#/
	
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
			{
				/#line( origin, trace["position"], COLOR_FAILED, 1 );#/
			}
			else
				break;
		}
		else
		{
			/#
			if ( debug )
				line( origin, trace["position"], COLOR_PASSED, 1 );
			#/
		}
	}
	
	self WeaponLockNoClearance( obstructed );
	self.noclearance = obstructed;

}

SetTargetTooClose( ent )
{
	if ( ! isDefined( ent ) )
		return false;
	dist = Distance2D( self.origin, ent.origin );
	
	//PrintLn( "Jav Distance: ", dist );
	
	if ( dist < level.MINIMUM_STI_DISTANCE )
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
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self playLocalSound( alias );
		//self PlayRumbleOnEntity( "stinger_lock_rumble" );

		wait interval;
	}
}

LoopLocalLockSound( alias, interval )
{   
    if ( isdefined( self.stingerlocksound ) )
        return;

    self.stingerlocksound = true;
        
    player = get_players()[0];
    player playloopsound( alias, .05 );
    self waittill_any( "stop_locked_sound", "disconnect", "death" );
    player stoploopsound(.05);

    self.stingerlocksound = undefined;
}


SetMinimumSTIDistance( dist )
{
	level.MINIMUM_STI_DISTANCE = dist;
}

