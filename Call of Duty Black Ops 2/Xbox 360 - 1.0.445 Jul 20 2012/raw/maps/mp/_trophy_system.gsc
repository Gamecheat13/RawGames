#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_weaponobjects;

init()
{
	precacheModel( "t6_wpn_trophy_system_world" );
		
	level.trophyLongFlashFX = loadfx( "weapon/trophy_system/fx_trophy_flash_lng");
	level.trophyDetonationFX = loadfx( "weapon/trophy_system/fx_trophy_radius_detonation");
	
	level._effect["fx_trophy_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
	level._effect["fx_trophy_enemy_light"] = loadfx( "misc/fx_equip_light_red" );

	level.trophyStunTime = 5;
	level.trophyAmmoCount = 2;
	level.trophyActiveRadius = 384;
	level.trophyActivationDelay = 0.1;
	level.trophySystemHealth = 50;

	level.trophyFlakZ = 5;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
createTrophySystemWatcher() // self == player
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "trophy_system", "trophy_system_mp", self.team );
	
	watcher.detonate = ::trophySystemDetonate;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.hackable = true;
	watcher.reconModel = "t6_wpn_trophy_system_world_detect";
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.activationDelay = level.trophyActivationDelay;

	watcher.enemyDestroy = true;

	watcher.onSpawn = ::onTrophySystemSpawn;
	watcher.onDamage = ::watchTrophySystemDamage;

	watcher.stun = ::weaponStun;
	watcher.stunTime = level.trophyStunTime;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onTrophySystemSpawn( watcher, player ) // self == trophy system
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );

	self waittillnotmoving();

	self.ammo = level.trophyAmmoCount;
	self thread trophyActive( player );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
trophyActive( owner ) // self == trophy system
{
	owner endon( "disconnect" );
	self endon ( "death" );

	while( true )
	{
		if ( !isDefined( level.grenades ) || level.grenades.size < 1 || isDefined( self.disabled ) )
		{
			wait( .05 );
			continue;
		}

		trophyTargets = combineArrays( level.grenades, level.missiles );

		foreach( grenade in trophyTargets )
		{
			wait( .05 );

			if ( !isDefined(grenade) )
				continue;
			
			if ( grenade == self )
				continue;

			if ( isDefined( grenade.weaponName) )
			{
				switch( grenade.weaponName )
				{
					case "claymore_mp":
						continue;
				}
			}

			switch( grenade.model )
			{
				case "t6_wpn_trophy_system_world":
				//case "weapon_radar":
				//case "weapon_jammer":
				//case "weapon_parabolic_knife":
					continue;
			}

			if ( !isDefined( grenade.owner ) )
			{
				grenade.owner = GetMissileOwner( grenade );
			}

			if ( isDefined( grenade.owner ))
			{
				if ( level.teamBased )
				{
					if ( grenade.owner.team == owner.team )
					{
						continue;
					}
				}
				else
				{
					if ( grenade.owner == owner )
					{
						continue;
					}
				}

				grenadeDistanceSquared = DistanceSquared( grenade.origin, self.origin );
			
				if ( grenadeDistanceSquared < ( level.trophyActiveRadius * level.trophyActiveRadius ))
				{
					if ( BulletTracePassed( grenade.origin, self.origin, false, self ) )
					{
						playFX( level.trophyLongFlashFX, self.origin + (0,0,level.trophyFlakZ), ( grenade.origin - self.origin ), AnglesToUp( self.angles ) );
						owner thread projectileExplode( grenade, self );
						//Eckert - Plays sound when destroying projectile/grenade
						self playsound ( "wpn_trophy_alert" );
						
						self.ammo--;
						if ( self.ammo <= 0 )
						{
							self thread trophySystemDetonate();
						}
					}
				}
			}
		}
	}

}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
projectileExplode( projectile, trophy ) // self == trophy owning player
{
	self endon( "death" );
	
	projPosition = projectile.origin;
	projType = projectile.model;
	projAngles = projectile.angles;
	
	//if ( projType == "weapon_light_marker" )
	//{
	//	playFX( level.empGrenadeExplode, projPosition, AnglesToForward( projAngles ), AnglesToUp( projAngles ) );
	//	
	//	trophy thread trophyBreak();
	//	
	//	projectile delete();
	//	return;
	//}
	playFX( level.trophyDetonationFX, projectile.origin );
	projectile delete();
	
	//playFX( level.mine_explode, projPosition, AnglesToForward( projAngles ), AnglesToUp( projAngles ) );

	RadiusDamage( projPosition, 128, 105, 10, self );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
trophySystemDetonate(attacker, weaponName)
{
	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );

	if ( !from_emp )
	{
		PlayFX( level._equipment_explode_fx, self.origin );
	}

	if ( isdefined(attacker) && ( ( level.teambased && attacker.team != self.owner.team ) || ( attacker != self.owner ))  )
	{
		attacker maps\mp\_challenges::destroyedEquipment();
		maps\mp\_scoreevents::processScoreEvent( "destroyed_trophy_system", attacker, self.owner, weaponName );
	}

	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchTrophySystemDamage( watcher ) // self == trophy system
{
	self endon( "death" );
	self endon( "hacked" );

	self SetCanDamage( true );
	damageMax = level.trophySystemHealth;

	if ( !self maps\mp\gametypes\_weaponobjects::isHacked() )
	{
		self.damageTaken = 0;
	}

	self.maxhealth = 10000;
	self.health = self.maxhealth;

	self setmaxhealth( self.maxhealth );

	attacker = undefined;

	while( true )
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weaponName, iDFlags );

		if( !isplayer( attacker ))
		{
			continue;
		}

		if ( level.teamBased && attacker.team == self.owner.team && attacker != self.owner )
		{
			continue;
		}

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		if ( IsDefined( weaponName ) )
		{
			// do damage feedback
			switch( weaponName )
			{
				case "concussion_grenade_mp":
				case "flash_grenade_mp":
					if( watcher.stunTime > 0 )
					{
						self thread maps\mp\gametypes\_weaponobjects::stunStart( watcher, watcher.stunTime ); 
					}

					// if we're not on the same team then show damage feedback
					if( level.teambased && self.owner.team != attacker.team )
					{
						if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
							attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
					}
					// for ffa just make sure the owner isn't the same
					else if( !level.teambased && self.owner != attacker )
					{
						if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
							attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
					}
					continue;

				case "emp_grenade_mp":
					damage = damageMax;
				default:
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
					break;
			}
		}
		else
		{
			weaponName = "";
		}

		if( isPlayer( attacker ) && level.teambased && isDefined( attacker.team ) && self.owner.team == attacker.team && attacker != self.owner )
			continue;

		if ( type == "MOD_MELEE" )
		{
			self.damageTaken = damageMax;
		}
		else
		{
			self.damageTaken += damage;
		}

		if( self.damageTaken >= damageMax )
		{
			//attacker maps\mp\_properks::shotEquipment( self.owner, iDFlags );
			watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( self, 0.0, attacker, weaponName );
			return;
		}
	}
}