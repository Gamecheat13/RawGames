#include maps\_utility;
#include common_scripts\utility;


PlayerJavelinAds()
{
	if ( level.player playerads() < 1.0 )
		return false;
	
	weap = level.player getCurrentWeapon();
	if ( weap != "javelin" )
		return false;

	return true;
}


InsideJavelinReticleNoLock( target )
{
	//TODO: sighttrace
	return target_isinrect( target, level.player, 25, 60, 30 );
}


InsideJavelinReticleLocked( target )
{
	//TODO: sighttrace
	return target_isinrect( target, level.player, 25, 90, 45 );
}


ClearCLUTarget()
{
	level.player notify( "javelin_clu_cleartarget" );
	level.player notify( "stop_lockon_sound" );
	level.javelinLockStartTime = 0;
	level.javelinLockStarted = false;
	level.javelinLockFinalized = false;
	level.javelinTarget = undefined;
	level.player WeaponLockFree();
}


GetBestJavelinTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if ( InsideJavelinReticleNoLock( targetsAll[idx] ) )
			targetsValid[targetsValid.size] = targetsAll[idx];
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


IsStillValidTarget( ent )
{
	if ( ! target_isTarget( ent ) )
		return false;
	if ( ! InsideJavelinReticleLocked( ent ) )
		return false;

	return true;
}


JavelinCLULoop()
{
	level.player endon( "death" );
	level.player endon( "javelin_clu_off" );

	LOCK_LENGTH = 2000;

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

		clipAmmo = level.player GetCurrentWeaponClipAmmo();
		if ( !clipAmmo )
		{
			ClearCLUTarget();
			continue;
		}

		if ( level.javelinLockFinalized )
		{
			if ( ! IsStillValidTarget( level.javelinTarget ) )
			{
				ClearCLUTarget();
				continue;
			}
			//print3D( level.javelinTarget.origin, "* LOCKED!", (.2, 1, .3), 1, 5 );
			continue;
		}

		if ( level.javelinLockStarted )
		{
			if ( ! IsStillValidTarget( level.javelinTarget ) )
			{
				ClearCLUTarget();
				continue;
			}

			//print3D( level.javelinTarget.origin, "* locking...!", (.2, 1, .3), 1, 5 );

			timePassed = getTime() - level.javelinLockStartTime;
			if ( timePassed < LOCK_LENGTH )
				continue;

			assert( isdefined( level.javelinTarget ) );
			level.player notify( "stop_lockon_sound" );
			level.javelinLockFinalized = true;
			level.player WeaponLockFinalize( level.javelinTarget );
			level.player playLocalSound( "javelin_clu_lock" );
			continue;
		}
		
		bestTarget = GetBestJavelinTarget();
		if ( !isDefined( bestTarget ) )
			continue;

		level.javelinTarget = bestTarget;
		level.javelinLockStartTime = getTime();
		level.javelinLockStarted = true;
		level.player WeaponLockStart( bestTarget );
		thread LoopLocalSeekSound( "javelin_clu_aquiring_lock", 0.6 );
	}
}


JavelinToggleLoop()
{
	level.player endon ( "death" );
	
	for (;;)
	{
		while( ! PlayerJavelinAds() )
			wait 0.05;
		thread JavelinCLULoop();

		while( PlayerJavelinAds() )
			wait 0.05;
		level.player notify( "javelin_clu_off" );
		ClearCLUTarget();
	}
}


init()
{
	ClearCLUTarget();

	thread JavelinToggleLoop();
}


LoopLocalSeekSound( alias, interval )
{
	level.player endon ( "stop_lockon_sound" );
	
	for (;;)
	{
		level.player playLocalSound( alias );
		wait interval;
	}
}
