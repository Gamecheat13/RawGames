#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	if ( !maps\mp\zombies\_zm_equipment::is_equipment_included( "equip_electrictrap_zm" ) )
	{
		return;
	}

	level.electrictrap_name = "equip_electrictrap_zm";

	maps\mp\zombies\_zm_equipment::register_equipment( "equip_electrictrap_zm", &"ZOMBIE_EQUIP_ELECTRICTRAP_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_ELECTRICTRAP_HOWTO", "electrictrap" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self thread watchElectricTrapUse();
	}
}

watchElectricTrapUse()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "grenade_fire", weapon, weapname );

		if ( weapname == level.electrictrap_name )
		{
			self.buildableElectricTrap = weapon;
			
			self thread startElectricTrapDeploy( weapon );
		}
	}
}

startElectricTrapDeploy( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );

	electricRadius = 150;

	if ( !IsDefined( self.electrictrap_health ) )
	{
		self.electrictrap_health = 60; // Seconds
	}

	if ( IsDefined( weapon ) )
	{
		/#
		weapon thread debugElectricTrap( electricRadius );
		#/
		
		level.electrap_sound_ent = spawn( "script_origin", weapon.origin );
		level.electrap_sound_ent playsound( "wpn_zmb_electrap_start" );
		level.electrap_sound_ent playloopsound( "wpn_zmb_electrap_loop", 2 );
		self thread electricTrapThink( weapon, electricRadius );
		self thread electricTrapDecay( weapon );
		
		self thread maps\mp\zombies\_zm_buildables::delete_on_disconnect( weapon );

		// Wait For ElectricTrap To Be Removed
		//-------------------------------
		weapon waittill( "death" );
		
		if( isdefined( level.electrap_sound_ent ) )
		{
			playsoundatposition( "wpn_zmb_electrap_stop", level.electrap_sound_ent.origin );
			level.electrap_sound_ent delete();
		}

	}
}

electricTrapThink( weapon, electricRadius )
{
	while ( IsDefined( weapon ) )
	{
		zombies = GetAIArray( "axis" );

		foreach ( zombie in zombies )
		{
			if ( is_true( zombie.ignore_electric_trap ) )
			{
				continue;
			}

			if ( DistanceSquared( weapon.origin, zombie.origin ) < ( electricRadius * electricRadius ) )
			{
				weapon playsound( "wpn_zmb_electrap_zap" );
				
				zombie thread play_elec_vocals();
				
				if ( RandomInt( 100 ) > 50 )
				{
					zombie thread maps\mp\zombies\_zm_traps::electroctute_death_fx();
				}
				
				zombie thread electricTrapKill( weapon );
			}
		}
		
		wait ( 1 );
	}
}

electricTrapKill( weapon )
{
	self endon( "death" );
	
	wait ( RandomFloatRange( 0.5, 2.0 ) );
	
	self DoDamage( self.health + 666, self.origin );
}

electricTrapDecay( weapon )
{
	self endon( "disconnect" );
	
	while ( IsDefined( weapon ) )
	{
		self.electrictrap_health--;

		if ( self.electrictrap_health <= 0 )
		{
			self maps\mp\zombies\_zm_equipment::equipment_take();
			weapon Delete();

			self.electrictrap_health = undefined;

			return;
		}

		wait ( 1 );
	}
}

debugElectricTrap( radius )
{
	/#
	while ( IsDefined( self ) )
	{
		Circle( self.origin, radius, ( 1, 1, 1 ), false, true, 1 );

		wait ( 0.05 );
	}
	#/
}
