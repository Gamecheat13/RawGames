#include maps\mp\_utility;
#include common_scripts\utility;

#define MAX_DOORS		4

#define DOOR_TIME_OPEN	0.5
#define DOOR_TIME_CLOSE	0.5
#define DOOR_TIME_MIN	0.1
#define DOOR_MOVE_DIST	100

init()
{
	triggers = GetEntArray( "trigger_multiple", "classname" );

	for( i = 0; i < MAX_DOORS; i++ )
	{
		door = GetEnt( "drone_door" + i, "targetname" );

		if ( !IsDefined( door ) )
		{
			continue;
		}
		
		door.opened = true;
		door.origin_opened = door.origin;
		door.origin_closed = door.origin - ( 0, 0, DOOR_MOVE_DIST );

		door.mins = door GetMins();
		door.maxs = door GetMaxs();
		
		door.triggers = [];

		foreach( trigger in triggers )
		{
			if ( IsDefined( trigger.target ) )
			{
				if ( trigger.target == door.targetname )
				{
					trigger.mins = trigger GetMins();
					trigger.maxs = trigger GetMaxs();
										
					door.triggers[ door.triggers.size ] = trigger;
				}
			}
		}

		door thread door_think( i );
	}
}

door_think( index )
{
	wait( 0.05 * index );
	self door_close();

	for ( ;; )
	{
		wait( 0.25 );

		if ( self door_should_open() )
		{
			self door_open();
		}
		else
		{
			self door_close();
		}

		self movement_process();
	}
}

door_should_open()
{
	foreach( trigger in self.triggers )
	{
		if ( trigger trigger_is_occupied() )
		{
			return true;
		}
	}

	return false;
}

door_open()
{
	if ( self.opened )
	{
		return;
	}

	dist = self.origin_opened[2] - self.origin[2];
	frac = dist / DOOR_MOVE_DIST;

	time = clamp( frac * DOOR_TIME_OPEN, DOOR_TIME_MIN, DOOR_TIME_OPEN );

	self MoveTo( self.origin_opened, time );
	self playsound ( "mpl_drone_door_open" );
	self.opened = true;
}

door_close()
{
	if ( !self.opened )
	{
		return;
	}

	dist = self.origin[2] - self.origin_closed[2];
	frac = dist / DOOR_MOVE_DIST;

	time = clamp( frac * DOOR_TIME_CLOSE, DOOR_TIME_MIN, DOOR_TIME_CLOSE );
	
	self MoveTo( self.origin_closed, time );
	self playsound ( "mpl_drone_door_close" );
	self.opened = false;
}

movement_process()
{
	moving = false;

	if ( self.opened )
	{
		if ( self.origin[2] != self.origin_opened[2] )
		{
			moving = true;
		}
	}
	else
	{
		if ( self.origin[2] != self.origin_closed[2] )
		{
			moving = true;
		}
	}

	if ( moving )
	{
		entities = GetTouchingVolume( self.origin, self.mins, self.maxs );

		foreach( entity in entities )
		{
			if ( IsDefined( entity.classname ) && entity.classname == "grenade" )
			{
				if( !IsDefined( entity.name ) )
				{
					continue;
				}

				if( !IsDefined( entity.owner ) )
				{
					continue;
				}

				if( !IsWeaponEquipment( entity.name ) )
				{
					continue;
				}

				watcher = entity.owner getWatcherForWeapon( entity.name );

				if( !IsDefined( watcher ) )
				{
					continue;
				}

				watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( entity, 0.0, undefined );
			}
			
			if ( self.opened )
			{
				continue;
			}

			if ( IsDefined( entity.classname ) && entity.classname == "auto_turret" )
			{
				entity DoDamage( entity.health * 2, self.origin, self, self, 0, "MOD_CRUSH" );
			}

			if ( IsDefined( entity.model ) && entity.model == "t6_wpn_tac_insert_world" )
			{
				entity maps\mp\_tacticalinsertion::destroy_tactical_insertion();
			}
		}
	}
}

trigger_is_occupied()
{
	entities = GetTouchingVolume( self.origin, self.mins, self.maxs );

	foreach( entity in entities )
	{
		if ( IsAlive( entity ) )
		{
			if ( IsPlayer( entity ) || IsAI( entity ) || IsVehicle( entity ) )
			{
				return true;
			}
		}
	}

	return false;
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