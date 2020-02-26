#include maps\mp\_utility;
#include common_scripts\utility; 

#define LIFT_TIME_MOVEMENT		5
#define LIFT_TIME_COOLDOWN		10
#define LIFT_TIME_AUTO_LOWER	30
#define LIFT_MOVE_DIST			128

#define LIFT_LOWERED	0
#define LIFT_RAISED		1

init()
{
	PrecacheString( &"MP_LIFT_OPERATE" );
	PrecacheString( &"MP_LIFT_COOLDOWN" );

	trigger = GetEnt( "lift_trigger", "targetname" );
	platform = GetEnt( "lift_platform", "targetname" );

	if ( !IsDefined( trigger ) || !IsDefined( platform ) )
	{
		return;
	}
	
	trigger EnableLinkTo();
	trigger LinkTo( platform );

	part = GetEnt( "lift_part", "targetname" );

	if ( IsDefined( part ) )
	{
		part LinkTo( platform );
	}

	level thread lift_think( trigger, platform );
}

lift_think( trigger, platform )
{
	level waittill( "prematch_over" );
	location = LIFT_LOWERED;
	
	for ( ;; )
	{
		trigger SetHintString( &"MP_LIFT_OPERATE" );
		trigger waittill( "trigger" );
		trigger SetHintString( &"MP_LIFT_COOLDOWN" );

		if ( location == LIFT_LOWERED )
		{
			goal = platform.origin + ( 0, 0, LIFT_MOVE_DIST );
			location = LIFT_RAISED;
		}
		else
		{
			goal = platform.origin - ( 0, 0, LIFT_MOVE_DIST );
			location = LIFT_LOWERED;
		}

		platform thread lift_move_think( goal );
		platform waittill( "movedone" );

		if ( location == LIFT_RAISED )
		{
			trigger thread lift_auto_lower_think();
		}

		wait( LIFT_TIME_COOLDOWN );
	}
}

lift_move_think( goal )
{
	self endon( "movedone" );

	timer = LIFT_TIME_MOVEMENT;
	self MoveTo( goal, LIFT_TIME_MOVEMENT );

	while ( timer >= 0 )
	{
		self destroy_equipment();
		self destroy_tactical_insertions();
		self destroy_supply_crates();
		self destroy_corpses();
		self destroy_stuck_weapons();

		wait( 0.5 );
		timer -= 0.5;
	}
}

lift_auto_lower_think()
{
	self endon( "trigger" );
	wait( LIFT_TIME_AUTO_LOWER );
	self notify( "trigger" );
}

destroy_equipment()
{
	grenades = GetEntArray( "grenade", "classname" );

	for( i = 0; i < grenades.size; i++ )
	{
		item = grenades[i];

		if( !IsDefined( item.name ) )
		{
			continue;
		}

		if( !IsDefined( item.owner ) )
		{
			continue;
		}

		if( !IsWeaponEquipment( item.name ) )
		{
			continue;
		}

		if( !item IsTouching( self ) ) 
		{
			continue;
		}

		watcher = item.owner getWatcherForWeapon( item.name );

		if( !IsDefined( watcher ) )
		{
			continue;
		}

		watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( item, 0.0, undefined );
	}
}

destroy_tactical_insertions()
{
	players = get_players();

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !IsDefined( player.tacticalInsertion ) )
		{
			continue;
		}

		if ( player.tacticalInsertion IsTouching( self ) )
		{
			player.tacticalInsertion maps\mp\_tacticalinsertion::destroy_tactical_insertion();
		}
	}
}

destroy_supply_crates()
{
	crates = GetEntArray( "care_package", "script_noteworthy" );

	for ( i = 0; i < crates.size; i++ )
	{
		crate = crates[i];

		if( crate IsTouching( self ) ) 
		{
			PlayFX( level._supply_drop_explosion_fx, crate.origin );
			PlaySoundAtPosition( "wpn_grenade_explode", crate.origin );
			wait ( 0.1 );
			crate maps\mp\killstreaks\_supplydrop::crateDelete();
		}
	}
}

destroy_corpses()
{
	corpses = GetCorpseArray();

	for ( i = 0; i < corpses.size; i++ )
	{
		if ( Distance2DSquared( corpses[i].origin, self.origin ) < 1024 * 1024 )
		{
			corpses[i] delete();
		}
	}
}

destroy_stuck_weapons()
{
	weapons = GetEntArray( "sticky_weapon", "targetname" );

	origin = self GetPointInBounds( 0.0, 0.0, -0.6 );
	z_cutoff = origin[2];

	for( i = 0 ; i < weapons.size ; i++ )
	{
		weapon = weapons[i];

		if ( weapon IsTouching( self ) && weapon.origin[2] > z_cutoff )
		{
			weapon delete();
		}
	}
}

getWatcherForWeapon( weapname )
{
	if ( !IsDefined( self ) )
	{
		return undefined;
	}

	if ( !IsPlayer( self ) )
	{
		return undefined;
	}

	for ( i = 0; i < self.weaponObjectWatcherArray.size; i++ )
	{
		if ( self.weaponObjectWatcherArray[i].weapon != weapname )
		{ 
			continue;
		}

		return ( self.weaponObjectWatcherArray[i] );
	}

	return undefined;
}