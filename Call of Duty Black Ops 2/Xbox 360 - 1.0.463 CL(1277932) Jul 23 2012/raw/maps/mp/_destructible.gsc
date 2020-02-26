#include maps\mp\_utility;
#include common_scripts\utility;

#insert raw\maps\mp\_clientflags.gsh;

// used by the client code in destructible.cpp
#define CLIENT_FLAG_DESTRUCTIBLE_DESTROYED 3

#using_animtree ( "mp_vehicles" );

init()
{
	level.destructible_callbacks = [];
	destructibles = GetEntArray( "destructible", "targetname" );
	
	// since this is globally run, only continue if we have a destructible in the level
	if( destructibles.size <= 0 )
	{
		return;
	}

	precacheItem( "destructible_car_mp" );
	precacheItem( "explodable_barrel_mp" );

	// array_thread( destructibles, ::destructible_think );

	for ( i = 0; i < destructibles.size; i++ )
	{
		if ( GetSubStr( destructibles[i].destructibledef, 0, 4 ) == "veh_" )
		{
			destructibles[i] thread destructible_car_death_think();
		}
		else if( IsSubStr( destructibles[i].destructibledef, "barrel" ) )
		{
			destructibles[i] thread destructible_barrel_death_think();
		}
		else if( IsSubStr( destructibles[i].destructibledef, "gaspump" ) )
		{
			destructibles[i] thread destructible_barrel_death_think();
		}
	}

	// needed for _destructible.csc 
	destructible_anims = [];
	destructible_anims[ "car" ]	= %veh_car_destroy;
}

destructible_event_callback( destructible_event, attacker ) // self == the destructible object (like the car or barrel)
{
	explosion_radius = 0;
	if(IsSubStr(destructible_event, "explode") && destructible_event != "explode")
	{
		tokens = StrTok(destructible_event, "_");
		explosion_radius = tokens[1];
				
		if(explosion_radius == "sm")
		{
			explosion_radius = 150;
		}
		else if(explosion_radius == "lg")
		{
			explosion_radius = 450;
		}
		else
		{
			explosion_radius = Int(explosion_radius);
		}
		
		destructible_event = "explode_complex"; // use a different explosion function
	}
	
	if ( IsSubStr( destructible_event, "simple_timed_explosion" ) )
	{
		self thread simple_timed_explosion( destructible_event, attacker );
		return;
	}
	
	switch ( destructible_event )
	{
		case "destructible_car_explosion":
			self destructible_car_explosion( attacker );
		break;

		case "destructible_car_fire":
			self thread destructible_car_fire_think(attacker);
		break;

		case "destructible_barrel_fire":
			self thread destructible_barrel_fire_think(attacker);
		break;

		case "destructible_barrel_explosion":
			self destructible_barrel_explosion( attacker );
		break;

		case "explode":
			self thread simple_explosion( attacker );
		break;

		case "explode_complex":
			self thread complex_explosion( attacker, explosion_radius );
		break;

		default:
		//iprintln( "_destructible.gsc: unknown destructible event: '" + destructible_event + "'" );
		break;
	}

	if ( IsDefined( level.destructible_callbacks[ destructible_event ] ) )
	{
		self thread [[level.destructible_callbacks[ destructible_event ]]]( destructible_event, attacker );
	}
}

simple_explosion( attacker )
{
	offset = (0, 0, 5);
	self RadiusDamage( self.origin + offset, 256, 300, 75, attacker, "MOD_EXPLOSIVE", "explodable_barrel_mp" );
	PhysicsExplosionSphere( self.origin, 255, 254, 0.3, 400, 25 );
	if ( isdefined( attacker ) )
	{
		self DoDamage( self.health + 10000, self.origin + offset, attacker );
	}
	else 
	{
		self DoDamage( self.health + 10000, self.origin + offset );
	}
}

simple_timed_explosion( destructible_event, attacker )
{
	self endon( "death" );
	
	wait_times = [];

	str = GetSubStr( destructible_event, 23 /* strlen( simple_timed_explosion ) */ );
	tokens = StrTok( str, "_" );

	for ( i = 0; i < tokens.size; i++ )
	{
		wait_times[ wait_times.size ] = Int( tokens[i] );
	}

	if ( wait_times.size <= 0 )
	{
		wait_times[ 0 ] = 5;
		wait_times[ 1 ] = 10;
	}

	wait( RandomIntRange( wait_times[0], wait_times[1] ) );
	simple_explosion( attacker );
}

complex_explosion( attacker, max_radius )
{
	offset = (0, 0, 5);

	if( IsDefined( attacker ) )
	{
		self RadiusDamage( self.origin + offset, max_radius, 300, 100, attacker );
	}
	else
	{
		self RadiusDamage( self.origin + offset, max_radius, 300, 100 );
	}

	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	Earthquake( 0.5, 0.5, self.origin, max_radius );
	PhysicsExplosionSphere( self.origin + offset, max_radius, max_radius - 1, 0.3 );
	if( IsDefined( attacker ) )
	{
		self DoDamage( 20000, self.origin + offset, attacker );
	}
	else
	{	
		self DoDamage( 20000, self.origin + offset );
	}
}


destructible_car_explosion( attacker, physics_explosion )
{
	if ( self.car_dead ) 
	{
		// prevents recursive entry caused by DoDamage call below
		return;
	}
	
	if ( !IsDefined( physics_explosion ) )
	{
		physics_explosion = true;
	}

	// force any ragdolls off the car
	players = GET_PLAYERS();

	for ( i = 0; i < players.size; i++ )
	{
		body = players[i].body;

		if ( !IsDefined( body ) )
		{
			continue;
		}

		if ( DistanceSquared( body.origin, self.origin ) > 96 * 96 )
		{
			continue;
		}

		if ( body.origin[2] - ( self.origin[2] + 32 ) > 0 )
		{
			// move the player off of the car's roof collision, ragdoll may sometimes get stuck in the roof collision
			body.origin = ( body.origin[0], body.origin[1], body.origin[2] + 16 );
		}

		body maps\mp\gametypes\_globallogic_player::start_explosive_ragdoll();
	}
	
	self notify( "car_dead" );
	self.car_dead = true;
	self thread destructible_car_explosion_animate();

	if ( isdefined( attacker ))
	{
		self RadiusDamage( self.origin, 256, 300, 75, attacker, "MOD_EXPLOSIVE", "destructible_car_mp" );
	}
	else
	{
		self RadiusDamage( self.origin, 256, 300, 75 );
	}
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	Earthquake( 0.5, 0.5, self.origin, 800 );

	if ( physics_explosion )
	{
		PhysicsExplosionSphere( self.origin, 255, 254, 0.3, 400, 25 );
	}
	
	if ( isdefined ( attacker ) ) 
		attacker thread maps\mp\_challenges::destroyed_car();

	level.globalCarsDestroyed++;
	if ( isdefined ( attacker ) ) 
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1), attacker );
	}
	else 
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1));
	}
	
	self setClientFlag( CLIENT_FLAG_DESTRUCTIBLE_DESTROYED );
}

destructible_car_death_think()
{
	self endon( "car_dead" );
	self.car_dead = false;

	self waittill_any( "death", "destructible_base_piece_death" );

	if ( IsDefined( self ) )
	{
		self thread destructible_car_explosion( undefined, false );
	}
}


destructible_car_explosion_animate()
{
	self SetClientFlag( CLIENT_FLAG_DESTRUCTIBLE_CAR );

	end_origin = self.origin;
	self.origin = ( self.origin[0], self.origin[1], self.origin[2] + 16 );

	wait ( 0.3 );

	// kill any dropped items to prevent them from floating on the car's (now invisible) collision
	items = GetDroppedWeapons();

	for ( i = 0; i < items.size; i++ )
	{
		if ( DistanceSquared( end_origin, items[i].origin ) < 128 * 128 )
		{
			if ( items[i].origin[2] - ( end_origin[2] + 32 ) > 0 )
			{
				items[i] delete();
			}
		}
	}
	
	self MoveTo( end_origin, 0.3, 0.15 );
	self ClearClientFlag( CLIENT_FLAG_DESTRUCTIBLE_CAR );
}

destructible_car_fire_think(attacker)
{
	self endon( "death" );

	wait( RandomIntRange( 7, 10 ) );

	self thread destructible_car_explosion( attacker );
}

CodeCallback_DestructibleEvent( event, param1, param2, param3 )
{
	if( event == "broken" )
	{
		notify_type = param1;
		attacker = param2;

		destructible_event_callback( notify_type, attacker );

		self notify( event, notify_type, attacker );
	}
	else if( event == "breakafter" )
	{
		piece = param1;
		time = param2;
		damage = param3;
		self thread breakAfter( time, damage, piece );
	}
}

breakAfter( time, damage, piece )
{
	self notify( "breakafter" );
	self endon( "breakafter" );
	
	wait time;
	self dodamage( damage, self.origin, undefined, piece );
}

destructible_barrel_death_think()
{
	self endon( "barrel_dead" );

	self waittill( "death", attacker );

	if ( IsDefined( self ) )
	{
		self thread destructible_barrel_explosion( attacker, false );
	}
}

destructible_barrel_fire_think(attacker) // self == the destructible object (like the car or barrel)
{	
	self endon( "barrel_dead" );
	self endon( "explode" );
	self endon( "death" );
	
	wait( RandomIntRange( 7, 10 ) );
	
	self thread destructible_barrel_explosion( attacker );
}

destructible_barrel_explosion( attacker, physics_explosion )
{
	if ( !IsDefined( physics_explosion ) )
	{
		physics_explosion = true;
	}

	self notify( "barrel_dead" );

	// delete the clip that is attached
	if( IsDefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		dest_clip delete();
	}

	self RadiusDamage( self.origin, 256, 300, 75, attacker, "MOD_EXPLOSIVE", "explodable_barrel_mp" );
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	Earthquake( 0.5, 0.5, self.origin, 800 );

	if ( physics_explosion )
	{
		PhysicsExplosionSphere( self.origin, 255, 254, 0.3, 400, 25 );
	}
	level.globalBarrelsDestroyed++;
	self DoDamage( self.health + 10000, self.origin + (0, 0, 1), attacker );
	self setClientFlag( CLIENT_FLAG_DESTRUCTIBLE_DESTROYED );
}
