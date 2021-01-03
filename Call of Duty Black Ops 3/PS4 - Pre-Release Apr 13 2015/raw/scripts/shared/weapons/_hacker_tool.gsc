#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "triggerstring", "MP_GENERIC_HACKING" );

#namespace hacker_tool;

function init_shared()
{
	level.weaponHackerTool = GetWeapon( "pda_hack" );

	level.hackerToolLostSightLimitMs = 450;
	level.hackerToolLockOnRadius = 25;
	level.hackerToolLockOnFOV = 65;
	level.hackerToolHackTimeMs = 0.4;

	// equipment
	level.equipmentHackerToolRadius = 20;
	level.equipmentHackerToolTimeMs = 100;

	// care packages
	level.carePackageHackerToolRadius = 60;
	level.carePackageHackerToolTimeMs = GetGametypeSetting("crateCaptureTime") * 500;
	level.carePackageFriendlyHackerToolTimeMs = GetGametypeSetting("crateCaptureTime") * 2000 ;
	level.carePackageOwnerHackerToolTimeMs = 250;

	// turrets
	level.sentryHackerToolRadius = 80; //change
	level.sentryHackerToolTimeMs = 1000;

	level.microwaveHackerToolRadius = 80; //change
	level.microwaveHackerToolTimeMs = 1000;

	
	// vehicles
	level.vehicleHackerToolRadius = 80;
	level.vehicleHackerToolTimeMs = 1000;
	
	level.rcxdHackerToolTimeMs = 1000;
	level.rcxdHackerToolRadius = 20;

	level.uavHackerToolTimeMs = 1000;
	level.uavHackerToolRadius = 40;

	level.cuavHackerToolTimeMs = 1000;
	level.cuavHackerToolRadius = 40;

	level.carePackageChopperHackerToolTimeMs = 1500;
	level.carePackageChopperHackerToolRadius = 60;
	
	level.littleBirdHackerToolTimeMs = 1000;
	level.littleBirdHackerToolRadius = 80;

	level.qrDroneHackerToolTimeMs = 1000;
	level.qrDroneHackerToolRadius = 60;

	level.aiTankHackerToolTimeMs = 1000;
	level.aiTankHackerToolRadius = 60;

	level.stealthChopperHackerToolTimeMs = 1000;
	level.stealthChopperHackerToolRadius = 80; 

	level.warthogHackerToolTimeMs = 1000;
	level.warthogHackerToolRadius = 80;

	level.lodestarHackerToolTimeMs = 1000;
	level.lodestarHackerToolRadius = 60;
	
	level.chopperGunnerHackerToolTimeMs = 1000;
	level.chopperGunnerHackerToolRadius = 260; 

	//thread tunables();
	callback::on_spawned( &on_player_spawned );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_spawned()
{
	self endon( "disconnect" );

	self clearHackerTarget();
	
	self thread watchHackerToolUse();
	self thread watchHackerToolFired();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function clearHackerTarget( weapon ) // self == player
{
	self notify( "stop_lockon_sound" );
	self notify( "stop_locked_sound" );

	self.stingerlocksound = undefined;
	self StopRumble( "stinger_lock_rumble" );

	self.hackerToolLockStartTime = 0;
	self.hackerToolLockStarted = false;
	self.hackerToolLockFinalized = false;
	self.hackerToolLockTimeElapsed = 0.0;
	
	if ( isdefined( weapon ) )
	{
		self SetWeaponHeatPercent( weapon, 0.0 );
	}

	if( isdefined( self.hackerToolTarget ))
	{
		heatseekingmissile::LockingOn( self.hackerToolTarget, false );
		heatseekingmissile::LockedOn( self.hackerToolTarget, false );
	}
	self.hackerToolTarget = undefined;

	self WeaponLockFree();
	self WeaponLockTargetTooClose( false );
	self WeaponLockNoClearance( false );

	self StopLocalSound( game["locking_on_sound"] );
	self StopLocalSound( game["locked_on_sound"] );

	self heatseekingmissile::DestroyLockOnCanceledMessage();

	//if ( isdefined( self.hackerToolProgressBar ))
	//{
	//	self.hackerToolProgressBar hud::destroyElem();
	//	self.hackerToolprogressText hud::destroyElem();
	//}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchHackerToolFired() // self == player
{
	self endon( "disconnect" );
	self endon ( "death" );
	self endon ("killHackerMonitor");

	while ( true )
	{
		self waittill( "hacker_tool_fired", hackerToolTarget, weapon  );

		if( isdefined( hackerToolTarget ))
		{
			if ( isEntityHackableCarePackage( hackerToolTarget ))
			{
				scoreevents::giveCrateCaptureMedal( hackerToolTarget, self );
				hackerToolTarget notify( "captured", self, true );
			}
			if ( isEntityHackableWeaponObject( hackerToolTarget ) && isdefined( hackerToolTarget.hackerTrigger ))
			{
				// turrets and weapon objects
				hackerToolTarget.hackerTrigger notify( "trigger", self, true );
			}
			else
			{
				if ( isdefined( hackerToolTarget.classname ) && hackerToolTarget.classname == "grenade" )
				{
					damage = 1;
				}
				else if ( isdefined( hackerToolTarget.hackerToolDamage ))
				{
					damage = hackerToolTarget.hackerToolDamage;
				}
				else if ( isdefined( hackerToolTarget.maxhealth ))
				{
					damage = hackerToolTarget.maxhealth + 1;
				}
				else
				{
					damage = 999999;
				}
								
				if ( isdefined( hackerToolTarget.numFlares ) && hackerToolTarget.numFlares > 0 )
				{
					damage = 1;
					hackerToolTarget.numFlares--;
					hackerToolTarget heatseekingmissile::MissileTarget_PlayFlareFx();
				}

				hackerToolTarget DoDamage( damage, self.origin, self, self, 0, "MOD_UNKNOWN", 0, weapon );
			}
			self AddPlayerStat( "hack_enemy_target", 1 );
			self AddWeaponStat( weapon, "used", 1 );
		}

		clearHackerTarget( weapon );
		self forceoffhandend();

		if ( GetDvarint( "player_sustainAmmo" ) == 0 )
		{
			clip_ammo = self GetWeaponAmmoClip( weapon );
			clip_ammo--;
			/#assert( clip_ammo >= 0);#/
	
			self setWeaponAmmoClip( weapon, clip_ammo );
		}
		

		self killstreaks::switch_to_last_non_killstreak_weapon(); // won't switch weapons while the shoulder button is held
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchHackerToolUse() // self == player
{
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self waittill ( "grenade_pullback", weapon );

		if ( weapon.rootWeapon == level.weaponHackerTool )
		{
			{wait(.05);};
			currentOffhand = self getCurrentOffhand();
			if ( self isUsingOffhand() && ( currentOffhand.rootWeapon == level.weaponHackerTool ) )
			{
				self thread hackerToolTargetLoop( weapon );
				self thread watchHackerToolEnd( weapon );
				self thread watchForGrenadeFire( weapon );
				self thread watchHackerToolInterrupt(weapon );
			}
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchHackerToolInterrupt( weapon ) // self == player
{
	self endon( "disconnect" );
	self endon( "hacker_tool_fired" );
	self endon( "death" );
	self endon( "weapon_change" );
	self endon( "grenade_fire" );

	while( true )
	{
		level waittill( "use_interrupt", interruptTarget );

		if( self.hackerToolTarget == interruptTarget )
		{
			clearHackerTarget( weapon );
		}
		{wait(.05);};
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchHackerToolEnd( weapon ) // self == player
{
	self endon( "disconnect" );
	self endon( "hacker_tool_fired" );

	msg = self util::waittill_any_return( "weapon_change", "death" );
	clearHackerTarget( weapon );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchForGrenadeFire( weapon ) // self == player
{
	self endon( "disconnect" );
	self endon( "hacker_tool_fired" );
	self endon( "weapon_change" );
	self endon( "death" );

	while( true )
	{
		//This notify will be called when a weapon object gets hacked to reboot the watcher. We don't want to give the player ammo for this.
		self waittill( "grenade_fire", grenade_instance, grenade_weapon, respawnFromHack );

		if( isDefined( respawnFromHack ) && respawnFromHack )
			continue;

		clearHackerTarget( grenade_weapon );

		clip_ammo = self GetWeaponAmmoClip( grenade_weapon );
		clip_max_ammo = grenade_weapon.clipSize;
	
		if( clip_ammo < clip_max_ammo )
		{
			clip_ammo++;
		}
		self setWeaponAmmoClip( grenade_weapon, clip_ammo );
		break;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function hackerToolTargetLoop( weapon ) // self == player
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "weapon_change" );
	self endon( "grenade_fire" );

	while ( true )
	{
		{wait(.05);};

		if ( self.hackerToolLockFinalized )
		{
			if ( !self isValidHackerToolTarget( self.hackerToolTarget, weapon ))
			{
				self clearHackerTarget( weapon );
				continue;
			}

			passed = self hackerSoftSightTest( weapon );

			if ( !passed )
			{
				continue;
			}

			heatseekingmissile::LockingOn( self.hackerToolTarget, false);
			heatseekingmissile::LockedOn( self.hackerToolTarget, true);

			thread heatseekingmissile::LoopLocalLockSound( game["locked_on_sound"], 0.75 );

			self notify( "hacker_tool_fired", self.hackerToolTarget, weapon );
			return;
		}

		if ( self.hackerToolLockStarted )
		{
			if ( !self isValidHackerToolTarget( self.hackerToolTarget, weapon ) )
			{
				self clearHackerTarget( weapon );
				continue;
			}
			
			lockOnTime = self getLockOnTime( self.hackerToolTarget, weapon );			
			
			if ( lockOnTime == 0 )
			{
				self clearHackerTarget( weapon );
				continue;
			}

			//if ( !isdefined( self.hackerToolProgressBar ))
			//{
			//	self.hackerToolProgressBar = self hud::createPrimaryProgressBar();
			//	self.hackerToolProgressBar.lastUseRate = -1;
			//	self.hackerToolProgressBar hud::showElem();
			//	self.hackerToolProgressBar hud::updateBar( 0.01, 1 / ( lockOnTime ));

			//	self.hackerToolprogressText = self hud::createPrimaryProgressBarText();
			//	self.hackerToolProgressText setText( &"MP_HACKING" );
			//	self.hackerToolProgressText hud::showElem();
			//}

			if ( self.hackerToolLockTimeElapsed == 0.0 )
			{
				self PlayLocalSound ( "evt_hacker_hacking" );
			}

			heatseekingmissile::LockingOn( self.hackerToolTarget, true );
			heatseekingmissile::LockedOn( self.hackerToolTarget, false );

			passed = self hackerSoftSightTest( weapon );

			if ( !passed )
			{
				continue;
			}			
			
			if ( self.hackerToolLostSightlineTime == 0 )
			{
				self.hackerToolLockTimeElapsed += 0.05;
				hackPercentage = (self.hackerToolLockTimeElapsed / ( lockOnTime ));
				self SetWeaponHeatPercent( weapon, hackPercentage );
			}

			if ( self.hackerToolLockTimeElapsed < ( lockOnTime ) )
			{
				continue;
			}

			assert( isdefined( self.hackerToolTarget ));

			self notify( "stop_lockon_sound" );
			self.hackerToolLockFinalized = true;

			self WeaponLockFinalize( self.hackerToolTarget );

			continue;
		}

		bestTarget = self getBestHackerToolTarget( weapon );

		if ( !isdefined( bestTarget ))
		{
			self heatseekingmissile::DestroyLockOnCanceledMessage();
			continue;
		}

		if (!self heatseekingmissile::LockSightTest( bestTarget ) && distance2d(self.origin, bestTarget.origin) > weapon.lockOnMaxRangeNoLineOfSight )
		{
			self heatseekingmissile::DestroyLockOnCanceledMessage();
			continue;
		}

		//check for delay allowing helicopters to enter the play area
		if( self heatseekingmissile::LockSightTest( bestTarget ) && isdefined( bestTarget.lockOnDelay ) && bestTarget.lockOnDelay )
		{
			self heatseekingmissile::DisplayLockOnCanceledMessage();
			continue;
		}
		
		self heatseekingmissile::DestroyLockOnCanceledMessage();
		heatseekingmissile::InitLockField( bestTarget );
		
		self.hackerToolTarget = bestTarget;
		self.hackerToolLockStartTime = getTime();
		self.hackerToolLockStarted = true;
		self.hackerToolLostSightlineTime = 0;
		self.hackerToolLockTimeElapsed = 0.0;
		self SetWeaponHeatPercent( weapon, 0.0 );

		self thread heatseekingmissile::LoopLocalSeekSound( game["locking_on_sound"], 0.6 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function getBestHackerToolTarget( weapon )
{
	targetsValid = [];

	targetsAll = ArrayCombine( target_getArray(), level.MissileEntities, false, false );
	targetsAll = ArrayCombine( targetsAll, level.hackerToolTargets, false, false );

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		target_ent = targetsAll[ idx ];

		if ( !isdefined( target_ent ) || !isdefined( target_ent.owner ) )
		{
			continue;
		}			
		
		/#
		//This variable is set and managed by the 'dev_friendly_lock' function, which works with the dev_gui
		if( GetDvarString( "scr_freelock") == "1" )
		{
			//If the dev_gui dvar is set, only check if the target is in the reticule. 
			if( self isWithinHackerToolReticle( targetsAll[idx], weapon ) )
			{
				targetsValid[targetsValid.size] = targetsAll[idx];
			}
			continue;
		}
		#/

		if ( level.teamBased ) //team based game modes
		{
			if ( isEntityHackableCarePackage( target_ent ))
			{
				if ( self isWithinHackerToolReticle( target_ent, weapon ) )
				{
					targetsValid[ targetsValid.size ] = target_ent;
				}				
			}
			else if ( isdefined( target_ent.team ))
			{
				if ( target_ent.team != self.team )
				{
					if ( self isWithinHackerToolReticle( target_ent, weapon ) )
					{
						targetsValid[ targetsValid.size ] = target_ent;
					}
				}
			}
			else if ( isdefined( target_ent.owner.team ) )
			{
				if ( target_ent.owner.team != self.team )
				{
					if ( self isWithinHackerToolReticle( target_ent, weapon ) )
					{
						targetsValid[ targetsValid.size ] = target_ent;
					}
				}
			}
		}		
		else 
		{
			if( self isWithinHackerToolReticle( target_ent, weapon )) //Free for all
			{
				if ( isEntityHackableCarePackage( target_ent ))
				{
					targetsValid[ targetsValid.size ] = target_ent;		
				}
				else if( isdefined( target_ent.owner ) && self != target_ent.owner )
				{
					targetsValid[ targetsValid.size ] = target_ent;
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
function isWithinHackerToolReticle( target, weapon )
{
	radius = getHackerToolRadius( target, weapon );
	if( target_isincircle( target, self, level.hackerToolLockOnFOV, radius, 0.0 ) )
	{
		return true;
	}
	
	return Target_BoundingIsUnderReticle( self, target, weapon.lockOnMaxRange );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function isEntityHackableWeaponObject( entity )
{
	if ( isdefined( entity.classname ) && entity.classname == "grenade" )
	{
		if ( isdefined( entity.weapon ) )
		{
			watcher = weaponobjects::getWeaponObjectWatcherByWeapon( entity.weapon );
			if ( isdefined( watcher ))
			{
				if ( watcher.hackable )
				{
					/#
					assert( isdefined( watcher.hackerToolRadius ));
					assert( isdefined( watcher.hackerToolTimeMs ));
					#/

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
function getWeaponObjectHackerRadius( entity )
{
	/#
	assert( isdefined( entity.classname ));
	assert( isdefined( entity.weapon ));
	#/

	watcher = weaponobjects::getWeaponObjectWatcherByWeapon( entity.weapon );

	/#
	assert( watcher.hackable );
	assert( isdefined( watcher.hackerToolRadius ));
	#/

	return watcher.hackerToolRadius;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function getWeaponObjectHackTimeMs( entity )
{
	/#
	assert( isdefined( entity.classname ));
	assert( isdefined( entity.weapon ));
	#/

	watcher = weaponobjects::getWeaponObjectWatcherByWeapon( entity.weapon );

	/#
	assert( watcher.hackable );
	assert( isdefined( watcher.hackerToolTimeMs ));
	#/

	return watcher.hackerToolTimeMs;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function isEntityHackableCarePackage( entity )
{
	if ( isdefined( entity.model ))
	{
		return entity.model == "veh_t7_mil_carepackage";
	}
	else
	{
		return false;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function isValidHackerToolTarget( ent, weapon ) // self == hacking player
{
	if ( !isdefined( ent ))
	{
		return false;
	}
	
	if ( self util::isUsingRemote() )
	{
		return false;
	}

	if ( self IsEMPJammed() )
	{
		return false;
	}

	if ( !target_isTarget( ent ) && !isEntityHackableWeaponObject( ent ) && !IsInArray( level.hackerToolTargets, ent ))
	{
		return false;
	}

	if ( isEntityHackableWeaponObject( ent ))
	{
		if ( DistanceSquared( self.origin, ent.origin ) > ( weapon.lockOnMaxRange * weapon.lockOnMaxRange ) )
		{
			return false;
		}
	}

	//if ( !isWithinHackerToolReticle( ent, weapon ))
	//{
	//	return false;
	//}

	return true;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function hackerSoftSightTest( weapon ) // self == player
{
	passed = true;
	lockOnTime = 0;
	
	if ( isdefined( self.hackerToolTarget ) )
	{
		lockOnTime = self getLockOnTime( self.hackerToolTarget, weapon );
	}

	if ( lockOnTime == 0 || self IsEMPJammed() )
	{
		self clearHackerTarget( weapon );
		passed = false;
	}
	else
	{
		if ( isWithinHackerToolReticle( self.hackerToolTarget, weapon ) )
		{
			//if ( self.hackerToolLostSightlineTime != 0 )
			//{
			//	// reactivate the progress bar
			//	self.hackerToolProgressBar hud::updateBar( self.hackerToolLockTimeElapsed/( lockOnTime ), 1 / ( lockOnTime ) );				
			//}

			self.hackerToolLostSightlineTime = 0;
		}
		else
		{
			if ( self.hackerToolLostSightlineTime == 0 )
			{
				// pause the progress bar
				self.hackerToolLostSightlineTime = getTime();
				//self.hackerToolProgressBar hud::updateBar( self.hackerToolLockTimeElapsed/( lockOnTime ), 0 );				
			}

			timePassed = GetTime() - self.hackerToolLostSightlineTime;

			if ( timePassed >= level.hackerToolLostSightLimitMs )
			{
				self clearHackerTarget( weapon );
				passed = false;
			}
		}
	}

	return passed;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function registerWithHackerTool( radius, hackTimeMs ) // self == some hackable entity
{
	self endon( "death" );

	if ( isdefined( radius ))
	{
		self.hackerToolRadius = radius;
	}
	else
	{
		self.hackerToolRadius = level.hackerToolLockOnRadius;
	}

	if ( isdefined( hackTimeMs ))
	{
		self.hackerToolTimeMs = hackTimeMs;
	}
	else
	{
		self.hackerToolTimeMs = level.hackerToolHackTimeMs;
	}

	self thread watchHackableEntityDeath();
	level.hackerToolTargets[ level.hackerToolTargets.size ] = self;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchHackableEntityDeath()
{
	self waittill( "death" );
	ArrayRemoveValue( level.hackerToolTargets, self );	
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function getHackerToolRadius( target, weapon )
{
	radius = level.hackerToolLockOnRadius;

	if ( isEntityHackableCarePackage( target ))
	{
		/#assert( isdefined( target.hackerToolRadius ));#/
		radius = target.hackerToolRadius;
	}
	else if ( isEntityHackableWeaponObject( target ))
	{
		radius = getWeaponObjectHackerRadius( target );
	}
	else if ( isdefined( target.hackerToolRadius ))
	{
		radius = target.hackerToolRadius;
	}
	else
	{
		// tagTMR<TODO>: registerWithHackerTool()
		// so we don't switch on the ent model
		switch ( target.model )
		{
			case "veh_t6_drone_uav":
			{
				radius = level.uavHackerToolRadius;
				break;
			}
			case"veh_t6_drone_cuav":
			{
				radius = level.cuavHackerToolRadius;
				break;
			}
			case "t5_veh_rcbomb_axis":
			{
				radius = level.rcxdHackerToolRadius;
				break;
			}
			case "veh_iw_mh6_littlebird_mp":
			{
				radius = level.carePackageChopperHackerToolRadius;
				break;
			}
			case "veh_t6_drone_quad_rotor_mp_alt":
			case "veh_t6_drone_quad_rotor_mp":
			{
				radius = level.qrDroneHackerToolRadius;
				break;
			}
			case "veh_t6_drone_tank_alt":
			case "veh_t6_drone_tank":
			{
				radius = level.aiTankHackerToolRadius;
				break;
			}
			case "veh_t6_air_attack_heli_mp_dark":
			case "veh_t6_air_attack_heli_mp_light":
			{
				radius = level.stealthChopperHackerToolRadius;
				break;
			}
			case "veh_t6_drone_overwatch_dark":
			case "veh_t6_drone_overwatch_light":
			{
				radius = level.littleBirdHackerToolRadius;
				break;
			}
			case "veh_t6_drone_pegasus":
			{
				radius = level.lodestarHackerToolRadius;
				break;
			}
			case "veh_iw_air_apache_killstreak":
			{
				radius = level.chopperGunnerHackerToolRadius;
				break;
			}
			case "veh_t6_air_a10f":
			case "veh_t6_air_a10f_alt":
			{
				radius = level.warthogHackerToolRadius;
				break;
			}
		}

	}

	return radius;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function getHackTime( target ) // self == player
{
	time = 500;

	if ( isEntityHackableCarePackage( target )) 
	{
		/#assert( isdefined( target.hackerToolTimeMs ));#/
		//time = target.hackerToolTimeMs;

		if ( isdefined( target.owner ) && ( target.owner == self ))
		{
			time = level.carePackageOwnerHackerToolTimeMs;
		}
		else if ( isdefined(target.owner) && (target.owner.team == self.team) )
		{
			time = level.carePackageFriendlyHackerToolTimeMs;
		}
		else
		{
			time = level.carePackageHackerToolTimeMs;
		}
	}
	else if ( isEntityHackableWeaponObject( target ))
	{
		time = getWeaponObjectHackTimeMs( target );
	}
	else if ( isdefined( target.hackerToolTimeMs ))
	{
		time = target.hackerToolTimeMs;
	}
	else
	{
		// vehicles/targets from the target array
		time = level.vehicleHackerToolTimeMs;

		// tagTMR<TODO>: registerWithHackerTool()
		// so we don't switch on the ent model
		switch ( target.model )
		{
			case "veh_t6_drone_uav":
			{
				time = level.uavHackerToolTimeMs;
				break;
			}
			case"veh_t6_drone_cuav":
			{
				time = level.cuavHackerToolTimeMs;
				break;
			}
			case "t5_veh_rcbomb_axis":
			{
				time = level.rcxdHackerToolTimeMs;
				break;
			}
			case "veh_t6_drone_supply_alt":
			case "veh_t6_drone_supply_alt":
			{
				time = level.carePackageChopperHackerToolTimeMs;
				break;
			}
			case "veh_t6_drone_quad_rotor_mp_alt":
			case "veh_t6_drone_quad_rotor_mp":
			{
				time = level.qrDroneHackerToolTimeMs;
				break;
			}
			case "veh_t6_drone_tank_alt":
			case "veh_t6_drone_tank":
			{
				time = level.aiTankHackerToolTimeMs;
				break;
			}
			case "veh_t6_air_attack_heli_mp_dark":
			case "veh_t6_air_attack_heli_mp_light":
			{
				time = level.stealthChopperHackerToolTimeMs;
				break;
			}
			case "veh_t6_drone_overwatch_dark":
			case "veh_t6_drone_overwatch_light":
			{
				time = level.littleBirdHackerToolTimeMs;
				break;
			}
			case "veh_t6_drone_pegasus":
			{
				time = level.lodestarHackerToolTimeMs;
				break;
			}
			case "veh_t6_air_v78_vtol_killstreak":
			case "veh_t6_air_v78_vtol_killstreak_alt":
			{
				time = level.chopperGunnerHackerToolTimeMs;
				break;
			}
			case "veh_t6_air_a10f":
			case "veh_t6_air_a10f_alt":
			{
				time = level.warthogHackerToolTimeMs;
				break;
			}
		}		
	}

	return time;
}


function getLockOnTime( target, weapon ) // self is the player, weapon is the hacker tool
{
	lockLengthMs = self getHackTime( self.hackerToolTarget );
	
	if ( lockLengthMs == 0 )
	{
		return 0;
	}
	
	lockOnSpeed = weapon.lockOnSpeed;	
			
	if ( lockOnSpeed <= 0 )
	{
		lockOnSpeed = 1000;	
	}
			
	return 	lockLengthMs / lockOnSpeed;
}

/#
function tunables()
{
	while(1)
	{
		level.hackerToolLostSightLimitMs = GetDvarInt( "scr_hackerToolLostSightLimitMs", 1000 );
		level.hackerToolLockOnRadius = GetDvarFloat( "scr_hackerToolLockOnRadius", 20 );
		level.hackerToolLockOnFOV = GetDvarInt( "scr_hackerToolLockOnFOV", 65 );
		
		level.rcxd_time =  GetDvarFloat( "scr_rcxd_time", 1.5);
		level.uav_time =  GetDvarInt( "scr_uav_time", 4 );
		level.cuav_time =  GetDvarInt( "scr_cuav_time", 4 );
		level.care_package_chopper_time =  GetDvarInt( "scr_care_package_chopper_time", 3 );
		
		level.guardian_time =  GetDvarInt( "scr_guardian_time", 5 );
		level.sentry_time =  GetDvarInt( "scr_sentry_time", 5 );
		level.wasp_time =  GetDvarInt( "scr_wasp_time", 5 );
		level.agr_time =  GetDvarInt( "scr_agr_time", 5 );
		
		level.stealth_helicopter_time =  GetDvarInt( "scr_stealth_helicopter_time", 7 );
		level.escort_drone_time =  GetDvarInt( "scr_escort_drone_time", 7 );
		level.warthog_time =  GetDvarInt( "scr_warthog_time", 7 );
		level.lodestar_time =  GetDvarInt( "scr_lodestar_time", 7 );
		level.chopper_gunner_time =  GetDvarInt( "scr_chopper_gunner_time", 7 );
		
		wait(1.0);
	}
}
#/