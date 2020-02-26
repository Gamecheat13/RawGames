#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	if ( !maps\mp\zombies\_zm_equipment::is_equipment_included( "equip_turret_zm" ) )
	{
		return;
	}

	PreCacheModel( "weapon_zombie_auto_turret" );
	PreCacheTurret( "zombie_bullet_crouch_zm" );

	level.turret_name = "equip_turret_zm";

	maps\mp\zombies\_zm_equipment::register_equipment( "equip_turret_zm", &"ZOMBIE_EQUIP_TURRET_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_TURRET_HOWTO", "turret" );

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

		self thread watchTurretUse();
	}
}

watchTurretUse()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "grenade_fire", weapon, weapname );

		if ( weapname == level.turret_name )
		{
			self.buildableTurret = weapon;
			
			self thread startTurretDeploy( weapon );
		}
	}
}

startTurretDeploy( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( !IsDefined( self.turret_health ) )
	{
		self.turret_health = 60; // Seconds
	}

	if ( IsDefined( weapon ) )
	{
		weapon Hide();
		
		wait ( 0.1 );

		turret = SpawnTurret( "misc_turret", weapon.origin, "zombie_bullet_crouch_zm" );
		turret.turretType = "sentry";
		turret SetTurretType( turret.turretType );
		turret SetModel( "weapon_zombie_auto_turret" );
		turret.origin = weapon.origin;
		turret.angles = weapon.angles;
		turret.sound_ent = spawn( "script_origin", turret.origin );
		turret playsound( "wpn_zmb_turret_start" );
		turret.sound_ent playloopsound( "wpn_zmb_turret_loop", 2.5 );

		turret MakeUnusable();
		turret.owner = self;
		turret SetOwner( turret.owner );

		turret MakeTurretUnusable();
		turret SetMode( "auto_nonai" );
		turret SetDefaultDropPitch( 45.0 );
		turret SetConvergenceTime( 0.3 );
		turret SetTurretTeam( self.team );
		turret.team = self.team;

		turret.turret_active = true;

		turret thread maps\mp\_mgturret::burst_fire_unmanned();

		self thread turretDecay( weapon );
		
		self thread maps\mp\zombies\_zm_buildables::delete_on_disconnect( weapon );

		// Wait For Turret To Be Removed
		//-------------------------------
		while ( IsDefined( weapon ) )
		{
			wait ( 0.1 );
		}
		
		turret playsound( "wpn_zmb_turret_stop" );
		turret.sound_ent delete();
		turret notify( "stop_burst_fire_unmanned" );
		turret notify( "turret_deactivated" );
		turret Delete();
	}
}

turretDecay( weapon )
{
	self endon( "disconnect" );
	
	while ( IsDefined( weapon ) )
	{
		self.turret_health--;

		if ( self.turret_health <= 0 )
		{
			self maps\mp\zombies\_zm_equipment::equipment_take();
			weapon Delete();

			self.turret_health = undefined;

			return;
		}

		wait ( 1 );
	}
}

debugTurret( radius )
{
	/#
	while ( IsDefined( self ) )
	{
		Circle( self.origin, radius, ( 1, 1, 1 ), false, true, 1 );

		wait ( 0.05 );
	}
	#/
}
