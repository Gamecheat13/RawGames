#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\_heatseekingmissile;

//#insert raw\maps\mp\_clientflags.gsh;

init()
{
	level.hackerToolLostSightLimitMs = 450;
	level.hackerToolLockOnRadius = 20;
	level.hackerToolLockOnFOV = 65;
	
	//thread tunables();
	thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self clearHackerTarget();
		
		self thread watchHackerToolUse();
		self thread watchHackerToolFired();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
clearHackerTarget() // self == player
{
	self notify( "stop_lockon_sound" );
	self notify( "stop_locked_sound" );

	self.stingerlocksound = undefined;
	self StopRumble( "stinger_lock_rumble" );

	self.hackerToolLockStartTime = 0;
	self.hackerToolLockStarted = false;
	self.hackerToolLockFinalized = false;

	if( IsDefined( self.hackerToolTarget ))
	{
		LockingOn( self.hackerToolTarget, false );
		LockedOn( self.hackerToolTarget, false );
	}
	self.hackerToolTarget = undefined;

	self WeaponLockFree();
	self WeaponLockTargetTooClose( false );
	self WeaponLockNoClearance( false );

	self StopLocalSound( game["locking_on_sound"] );
	self StopLocalSound( game["locked_on_sound"] );

	self DestroyLockOnCanceledMessage();

	if ( IsDefined( self.hackerToolProgressBar ))
	{
		self.hackerToolProgressBar destroyElem();
		self.hackerToolprogressText destroyElem();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchHackerToolFired() // self == player
{
	self endon( "disconnect" );
	self endon ( "death" );

	while ( true )
	{
		self waittill( "hacker_tool_fired", hackerToolTarget );

		if( isdefined( hackerToolTarget ))
		{
			if ( isEntityHackableWeaponObject( hackerToolTarget ) || isDefined( hackerToolTarget.hackerTrigger ))
			{
				hackerToolTarget.hackerTrigger notify( "trigger", self, true );
			}
			else
			{
				if ( isDefined( hackerToolTarget.maxhealth ))
				{
					damage = hackerToolTarget.maxhealth + 1;
				}
				else
				{
					damage = 999999;
				}

				hackerToolTarget DoDamage( damage, self.origin, self, self, 0, "MOD_UNKNOWN", 0, "pda_hack_mp" );
			}
		}

		clearHackerTarget();
		self forceoffhandend();

		clip_ammo = self GetWeaponAmmoClip( "pda_hack_mp" );
		clip_ammo--;
		/#assert( clip_ammo >= 0);#/

		self setWeaponAmmoClip( "pda_hack_mp", clip_ammo );

		self switchToWeapon( self getLastWeapon() ); // won't switch weapons while the shoulder button is held
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchHackerToolUse() // self == player
{
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self waittill ( "grenade_pullback", weapon );

		if ( weapon == "pda_hack_mp" )
		{
			wait 0.05;
			if ( self isUsingOffhand() && ( self getCurrentOffhand() == "pda_hack_mp" ))
			{
				self thread hackerToolTargetLoop();
				self thread watchHackerToolEnd();
			}
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchHackerToolEnd() // self == player
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "hacker_tool_fired" );

	msg = self waittill_any_return( "grenade_fire", "weapon_change" );
	clearHackerTarget();

	if ( msg == "grenade_fire" )
	{
		clip_ammo = self GetWeaponAmmoClip( "pda_hack_mp" );
		clip_max_ammo = WeaponClipSize( "pda_hack_mp" );
	
		if( clip_ammo < clip_max_ammo )
		{
			clip_ammo++;
		}
		self setWeaponAmmoClip( "pda_hack_mp", clip_ammo );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
hackerToolTargetLoop() // self == player
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "weapon_change" );
	self endon( "grenade_fire" );

	while ( true )
	{
		wait 0.05;

		if ( self.hackerToolLockFinalized )
		{
			passed = HackerSoftSightTest();

			if ( !passed )
			{
				continue;
			}

			if ( !isValidHackerToolTarget( self.hackerToolTarget ))
			{
				self clearHackerTarget();
				continue;
			}

			LockingOn( self.hackerToolTarget, false);
			LockedOn( self.hackerToolTarget, true);

			thread LoopLocalLockSound( game["locked_on_sound"], 0.75 );

			self notify( "hacker_tool_fired", self.hackerToolTarget );
			return;
		}

		if ( self.hackerToolLockStarted )
		{
			if ( !isValidHackerToolTarget( self.hackerToolTarget ) )
			{
				self clearHackerTarget();
				continue;
			}
			
			lockLengthMs = self.hackertooltarget getHackTime();

			if ( !IsDefined( self.hackerToolProgressBar ))
			{
				self.hackerToolProgressBar = self createPrimaryProgressBar();
				self.hackerToolProgressBar.lastUseRate = -1;
				self.hackerToolProgressBar showElem();
				self.hackerToolProgressBar updateBar( 0.01, 1 / ( lockLengthMs / 1000 ));

				self.hackerToolprogressText = self createPrimaryProgressBarText();
				self.hackerToolProgressText setText( &"MP_HACKING" );
				self.hackerToolProgressText showElem();

				self PlayLocalSound ( "evt_hacker_hacking" );
			}

			LockingOn( self.hackerToolTarget, true );
			LockedOn( self.hackerToolTarget, false );

			passed = HackerSoftSightTest();

			if ( !passed )
			{
				continue;
			}

			timePassed = getTime() - self.hackerToolLockStartTime;

			if ( timePassed < lockLengthMs )
			{
				continue;
			}

			assert( isdefined( self.hackerToolTarget ));

			self notify( "stop_lockon_sound" );
			self.hackerToolLockFinalized = true;

			self WeaponLockFinalize( self.hackerToolTarget );

			continue;
		}

		bestTarget = self getBestHackerToolTarget();

		if ( !isDefined( bestTarget ))
		{
			self DestroyLockOnCanceledMessage();
			continue;
		}

		if (!self LockSightTest( bestTarget ))
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
		
		self.hackerToolTarget = bestTarget;
		self.hackerToolLockStartTime = getTime();
		self.hackerToolLockStarted = true;
		self.hackerToolLostSightlineTime = 0;

		self thread LoopLocalSeekSound( game["locking_on_sound"], 0.6 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
getBestHackerToolTarget()
{
	targets = target_getArray();
	targetsAll = combineArrays( targets, level.grenades );

	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if ( !IsDefined( targetsAll[ idx ] ) || !IsDefined( targetsAll[ idx ].owner ) )
		{
			continue;
		}			
		
		/#
		//This variable is set and managed by the 'dev_friendly_lock' function, which works with the dev_gui
		if( GetDvar( "scr_freelock") == "1" )
		{
			//If the dev_gui dvar is set, only check if the target is in the reticule. 
			if( self isWithinHackerToolReticle( targetsAll[idx] ) )
			{
				targetsValid[targetsValid.size] = targetsAll[idx];
			}
			continue;
		}
		#/

		if ( level.teamBased ) //team based game modes
		{
			if ( IsDefined( targetsAll[ idx ].team ))
			{
				if ( targetsAll[ idx ].team != self.team )
				{
					if ( self isWithinHackerToolReticle( targetsAll[ idx ] ) )
					{
						targetsValid[ targetsValid.size ] = targetsAll[ idx ];
					}
				}
			}
			else if ( IsDefined( targetsAll[ idx ].owner.team ) )
			{
				if ( targetsAll[ idx ].owner.team != self.team )
				{
					if ( self isWithinHackerToolReticle( targetsAll[ idx ] ) )
					{
						targetsValid[ targetsValid.size ] = targetsAll[ idx ];
					}
				}
			}
		}		
		else 
		{
			if( self isWithinHackerToolReticle( targetsAll[ idx ] )) //Free for all
			{
				if( IsDefined( targetsAll[ idx ].owner ) && self != targetsAll[ idx ].owner )
				{
					targetsValid[ targetsValid.size ] = targetsAll[ idx ];
				}
			}
		}
	}

	chosenEnt = undefined;

	if ( targetsValid.size != 0 )
	{
		//TODO: find the closest
		chosenEnt = targetsValid[0];
	}

	return chosenEnt;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
isWithinHackerToolReticle( target )
{
	return target_isincircle( target, self, level.hackerToolLockOnFOV, level.hackerToolLockOnRadius, 0.0 );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
isEntityHackableWeaponObject( entity )
{
	if ( isDefined( entity.classname ) && entity.classname == "grenade" )
	{
		if ( isDefined( entity.name ))
		{
			watcher = maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcherByWeapon( entity.name );
			if ( isDefined( watcher ))
			{
				if ( watcher.hackable )
				{
					return true;
				}
			}
		}
	}

	return false;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
isValidHackerToolTarget( ent )
{
	if ( !isDefined( ent ))
	{
		return false;
	}

	if ( !target_isTarget( ent ) && !isEntityHackableWeaponObject( ent ))
	{
		return false;
	}

	//if ( !isWithinHackerToolReticle( ent ))
	//{
	//	return false;
	//}

	return true;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
HackerSoftSightTest()
{
	//if ( self LockSightTest( self.hackerToolTarget ) )
	if ( isWithinHackerToolReticle( self.hackerToolTarget ) )
	{
		self.hackerToolLostSightlineTime = 0;
	}
	else
	{
		// doesn't currently function
		if ( self.hackerToolLostSightlineTime == 0 )
		{
			self.hackerToolLostSightlineTime = getTime();
		}

		timePassed = GetTime() - self.hackerToolLostSightlineTime;

		if ( timePassed >= level.hackerToolLostSightLimitMs )
		{
			self clearHackerTarget();
			return false;
		}
	}

	return true;
}

getHackTime()
{
	time = .5;
	
	rcxd_time = 1.5;
	
	uav_time =  4 ;
	cuav_time = 4 ;
	care_package_chopper_time = 4 ;
		
	guardian_time = 5;
	sentry_time =  5;
	wasp_time =  5;
	agr_time =  5;
		
	stealth_helicopter_time = 6;
	escort_drone_time = 6;
	warthog_time =  6;
	lodestar_time =  6;
	chopper_gunner_time = 6;
	
	switch (self.model)
	{
		case "veh_t6_drone_uav":
		{
			time = uav_time;
			break;
		}
		case"veh_t6_drone_cuav":
		{
			time = cuav_time;
			break;
		}
		case "t5_veh_rcbomb_axis":
		{
			time = rcxd_time;
			break;
		}
		case "veh_iw_mh6_littlebird_mp":
		{
			time = care_package_chopper_time;
			break;
		}
		case "t6_wpn_turret_sentry_gun":
		{
			time = sentry_time;
			break;
		}
		case "t6_wpn_turret_ads_world":
		{
			time = guardian_time;
			break;
		}
		case "veh_t6_drone_quad_rotor_mp_alt":
		case "veh_t6_drone_quad_rotor_mp":
		{
			time = wasp_time;
			break;
		}
		case "veh_t6_drone_tank_alt":
		case "veh_t6_drone_tank":
		{
			time = agr_time;
			break;
		}
		case "veh_t6_air_attack_heli_mp_dark":
		case "veh_t6_air_attack_heli_mp_light":
		{
			time = stealth_helicopter_time;
			break;
		}
		case "veh_t6_drone_overwatch_dark":
		case "veh_t6_drone_overwatch_light":
		{
			time = escort_drone_time;
			break;
		}
		case "veh_t6_drone_pegasus":
		{
			time = lodestar_time;
			break;
		}
		case "veh_iw_air_apache_killstreak":
		{
			time = chopper_gunner_time;
			break;
		}
	}		
		
	return time*1000;
}

/#
tunables()
{
	while(1)
	{
		level.hackerToolLostSightLimitMs = weapons_get_dvar_int( "scr_hackerToolLostSightLimitMs", 1000 );
		level.hackerToolLockOnRadius = weapons_get_dvar( "scr_hackerToolLockOnRadius", 20 );
		level.hackerToolLockOnFOV = weapons_get_dvar_int( "scr_hackerToolLockOnFOV", 65 );
		
		level.rcxd_time =  weapons_get_dvar( "scr_rcxd_time", 1.5);
		level.uav_time =  weapons_get_dvar_int( "scr_uav_time", 4 );
		level.cuav_time =  weapons_get_dvar_int( "scr_cuav_time", 4 );
		level.care_package_chopper_time =  weapons_get_dvar_int( "scr_care_package_chopper_time", 3 );
		
		level.guardian_time =  weapons_get_dvar_int( "scr_guardian_time", 5 );
		level.sentry_time =  weapons_get_dvar_int( "scr_sentry_time", 5 );
		level.wasp_time =  weapons_get_dvar_int( "scr_wasp_time", 5 );
		level.agr_time =  weapons_get_dvar_int( "scr_agr_time", 5 );
		
		level.stealth_helicopter_time =  weapons_get_dvar_int( "scr_stealth_helicopter_time", 7 );
		level.escort_drone_time =  weapons_get_dvar_int( "scr_escort_drone_time", 7 );
		level.warthog_time =  weapons_get_dvar_int( "scr_warthog_time", 7 );
		level.lodestar_time =  weapons_get_dvar_int( "scr_lodestar_time", 7 );
		level.chopper_gunner_time =  weapons_get_dvar_int( "scr_chopper_gunner_time", 7 );
		
		wait(1.0);
	}
	
	switch (self.model)
	{
		case "veh_t6_drone_uav":
		{
			time = level.uav_time;
			break;
		}
		case"veh_t6_drone_cuav":
		{
			time = level.cuav_time;
			break;
		}
		case "t5_veh_rcbomb_axis":
		{
			time = level.rcxd_time;
			break;
		}
		case "veh_iw_mh6_littlebird_mp":
		{
			time = level.care_package_chopper_time;
			break;
		}
		case "t6_wpn_turret_sentry_gun":
		{
			time = level.sentry_time;
			break;
		}
		case "t6_wpn_turret_ads_world":
		{
			time = level.guardian_time;
			break;
		}
		case "veh_t6_drone_quad_rotor_mp_alt":
		case "veh_t6_drone_quad_rotor_mp":
		{
			time = level.wasp_time;
			break;
		}
		case "veh_t6_drone_tank_alt":
		case "veh_t6_drone_tank":
		{
			time = level.agr_time;
			break;
		}
		case "veh_t6_air_attack_heli_mp_dark":
		case "veh_t6_air_attack_heli_mp_light":
		{
			time = level.stealth_helicopter_time;
			break;
		}
		case "veh_t6_drone_overwatch_dark":
		case "veh_t6_drone_overwatch_light":
		{
			time = level.escort_drone_time;
			break;
		}
		case "veh_t6_drone_pegasus":
		{
			time = level.lodestar_time;
			break;
		}
		case "veh_iw_air_apache_killstreak":
		{
			time = level.chopper_gunner_time;
			break;
		}
	}		
	
}
#/