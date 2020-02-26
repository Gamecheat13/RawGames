#include maps\mp\_utility;
#include common_scripts\utility;

init()
{	
	level._effect["scrambler_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["scrambler_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
	level.scramblerWeapon = "scrambler_mp";	
	level.scramblerLength = 30.0;

	// should be kept in sync with the radius in _scrambler.csc
	level.scramblerOuterRadiusSq = 1000 * 1000;
	level.scramblerInnerRadiusSq = 600 * 600;
}

createScramblerWatcher()
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "scrambler", "scrambler_mp", self.team );
	watcher.onSpawn = ::onSpawnScrambler;
	watcher.detonate = ::scramblerDetonate;
	watcher.stun = maps\mp\gametypes\_weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.reconModel = "t5_weapon_scrambler_world_detect";
	watcher.hackable = true;
	watcher.onDamage = ::watchScramblerDamage;
}

onSpawnScrambler( watcher, player ) // self == scrambler
{
	player endon("disconnect");
	self endon( "death" );
	
	self thread maps\mp\gametypes\_weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	player.scrambler = self;
	self SetOwner( player );
	self SetTeam( player.team );
	self.owner = player;
	self SetClientFlag( level.const_flag_scrambler );

	if ( !self maps\mp\gametypes\_weaponobjects::isHacked() )
	{
		player AddWeaponStat( "scrambler_mp", "used", 1 );
	}

	self thread watchShutdown( player );
	level notify( "scrambler_spawn" );
}

scramblerDetonate( attacker )
{
	PlayFX( level._equipment_explode_fx, self.origin );
	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	self delete();
}

watchShutdown( player )
{
	self waittill_any( "death", "hacked" );
	level notify( "scrambler_death" );

	if ( isDefined( player ) )
		player.scrambler = undefined;
}

destroyEnt()
{
	self delete();
}

watchScramblerDamage( watcher ) // self == scrambler
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
		}
	}
}

ownerSameTeam( owner1, owner2 )
{
	if ( !level.teamBased )
	{
		return false;
	}
	
	if ( !IsDefined( owner1 ) || !IsDefined( owner2 ) )
	{
		return false;
	}

	if ( !IsDefined( owner1.team ) || !IsDefined( owner2.team ) )
	{
		return false;
	}

	return ( owner1.team == owner2.team );
}

checkScramblerStun()
{
	scramblers = GetEntArray( "grenade", "classname" );

	if ( IsDefined( self.name ) && self.name == "scrambler_mp" )
	{
		return false;
	}

	for ( i = 0; i < scramblers.size; i++ )
	{
		scrambler = scramblers[i];
		
		if ( !IsAlive( scrambler ) )
		{
			continue;
		}

		if ( !IsDefined( scrambler.name ) )
		{
			continue;
		}

		if ( scrambler.name != "scrambler_mp" )
		{
			continue;
		}

		if ( ownerSameTeam( self.owner, scrambler.owner ) )
		{
			continue;
		}
		
		// check is cylindrical
		flattenedSelfOrigin = (self.origin[0], self.origin[1], 0 );
		flattenedscramblerOrigin = (scrambler.origin[0], scrambler.origin[1], 0 );
		if ( DistanceSquared( flattenedSelfOrigin, flattenedscramblerOrigin ) < level.scramblerOuterRadiusSq )
		{
			return true;
		}
	}

	return false;
}
