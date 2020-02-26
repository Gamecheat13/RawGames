#include common_scripts\utility;

init()
{
	level._effect["acousticsensor_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["acousticsensor_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
}

createAcousticSensorWatcher()
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "acoustic_sensor", "acoustic_sensor_mp", self.team );
	watcher.onSpawn = ::onSpawnAcousticSensor;
	watcher.detonate = ::acousticSensorDetonate;
	watcher.stun = maps\mp\gametypes\_weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.reconModel = "t5_weapon_acoustic_sensor_world_detect";
	watcher.hackable = true;
	watcher.onDamage = ::watchAcousticSensorDamage;
}

onSpawnAcousticSensor( watcher, player ) // self == acoustic sensor
{
	self endon( "death" );
	
	self thread maps\mp\gametypes\_weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	player.acousticSensor = self;
	self SetOwner( player );
	self SetTeam( player.team );
	self.owner = player;
	
	self PlayLoopSound ( "fly_acoustic_sensor_lp" );
	
    if ( !self maps\mp\gametypes\_weaponobjects::isHacked() )
	{
		player AddWeaponStat( "acoustic_sensor_mp", "used", 1 );
	}

	self thread watchShutdown( player, self.origin );
}

acousticSensorDetonate( attacker )
{
	PlayFX( level._equipment_explode_fx, self.origin );
	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	self destroyEnt();
}

destroyEnt()
{
	self delete();
}

watchShutdown( player, origin )
{
	self waittill_any( "death", "hacked" );

	if ( isDefined( player ) )
		player.acousticSensor = undefined;
}

watchAcousticSensorDamage( watcher ) // self == acoustic sensor
{
	self endon( "death" );
	self endon( "hacked" );

	self SetCanDamage( true );
	damageMax = 100;

	if ( !self maps\mp\gametypes\_weaponobjects::isHacked() )
	{
		self.damageTaken = 0;
	}

	while( true )
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName, iDFlags );

		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		if ( level.teamBased && attacker.team == self.owner.team && attacker != self.owner )
			continue;

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
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
				}
				// for ffa just make sure the owner isn't the same
				else if( !level.teambased && self.owner != attacker )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
				}
				continue;
			
			default:
				if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
					attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
				break;
			}
		}

		if( isPlayer( attacker ) && level.teambased && isDefined( attacker.team ) && self.owner.team == attacker.team && attacker != self.owner )
			continue;

		if ( IsDefined( weaponName ) && ( weaponName == "emp_grenade_mp" ) )
		{
			watcher thread maps\mp\gametypes\_weaponobjects::waitAndDestroy( self );
			return; 
		}			

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

			attacker maps\mp\_properks::shotEquipment( self.owner, iDFlags );
			watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( self, 0.0, attacker );
			return;
		}
	}
}