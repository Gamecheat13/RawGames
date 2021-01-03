#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic_player;

#using scripts\cp\_challenges;

                                            

#namespace destructible;

function autoexec __init__sytem__() {     system::register("destructible",&__init__,undefined,undefined);    }
	
#using_animtree ( "mp_vehicles" );

function __init__()
{
	level.destructible_callbacks = [];
	destructibles = GetEntArray( "destructible", "targetname" );
	
	// since this is globally run, only continue if we have a destructible in the level
	if( destructibles.size <= 0 )
	{
		return;
	}

	// array::thread_all( destructibles,&destructible_think );

	for ( i = 0; i < destructibles.size; i++ )
	{
		if ( GetSubStr( destructibles[i].destructibledef, 0, 4 ) == "veh_" )
		{
			destructibles[i] thread car_death_think();
			destructibles[i] thread car_grenade_stuck_think();
		}
		else if( IsSubStr( destructibles[i].destructibledef, "barrel" ) )
		{
			destructibles[i] thread barrel_death_think();
		}
		else if( IsSubStr( destructibles[i].destructibledef, "gaspump" ) )
		{
			destructibles[i] thread barrel_death_think();
		}
		else if ( destructibles[i].destructibledef == "fxdest_upl_metal_tank_01" )
		{
			destructibles[i] thread tank_grenade_stuck_think();
		}
	}

	// needed for _destructible.csc 
	destructible_anims = [];
	destructible_anims[ "car" ]	= %veh_car_destroy;
}

function event_callback( destructible_event, attacker, weapon ) // self == the destructible object (like the car or barrel)
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
			self car_explosion( attacker );
			if ( isdefined( weapon ) )
			{
				self.destroyingWeapon = weapon;
			}
		break;

		case "destructible_car_fire":
			level thread battlechatter::bc_AInearExplodable( self, "car" );	
			if ( isdefined( weapon ) )
			{
				self.destroyingWeapon = weapon;
			}
		break;

		case "destructible_barrel_fire":
			level thread battlechatter::bc_AInearExplodable( self, "barrel" );
			self thread barrel_fire_think(attacker);
		break;

		case "destructible_barrel_explosion":
			self barrel_explosion( attacker );
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

	if ( isdefined( level.destructible_callbacks[ destructible_event ] ) )
	{
		self thread [[level.destructible_callbacks[ destructible_event ]]]( destructible_event, attacker );
	}
}

function simple_explosion( attacker )
{
	if ( ( isdefined( self.exploded ) && self.exploded ) )
	{
		return;
	}

	self.exploded = true;

	offset = (0, 0, 5);
	self RadiusDamage( self.origin + offset, 256, 300, 75, attacker, "MOD_EXPLOSIVE", GetWeapon( "explodable_barrel" ) );
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

function simple_timed_explosion( destructible_event, attacker )
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

function complex_explosion( attacker, max_radius )
{
	offset = (0, 0, 5);

	if( isdefined( attacker ) )
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
	if( isdefined( attacker ) )
	{
		self DoDamage( 20000, self.origin + offset, attacker );
	}
	else
	{	
		self DoDamage( 20000, self.origin + offset );
	}
}


function car_explosion( attacker, physics_explosion )
{
	if ( ( isdefined( self.car_dead ) && self.car_dead ) )
	{
		// prevents recursive entry caused by DoDamage call below
		return;
	}
	
	if ( !isdefined( physics_explosion ) )
	{
		physics_explosion = true;
	}

	// force any ragdolls off the car - TODO: see if we can remove this player ragdoll stuff 2/12/2015 - bbarnes
	players = GetPlayers();

	for ( i = 0; i < players.size; i++ )
	{
		body = players[i].body;

		if ( !isdefined( body ) )
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

		body globallogic_player::start_explosive_ragdoll();
	}
	
	self notify( "car_dead" );
	self.car_dead = true;
	
	if ( !IsVehicle( self ) )
	{
		if ( isdefined( attacker ))
		{
			self RadiusDamage( self.origin, 256, 300, 75, attacker, "MOD_EXPLOSIVE", GetWeapon( "destructible_car" ) );
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
	}
	
	if ( isdefined ( attacker ) ) 
		attacker thread challenges::destroyed_car();

	level.globalCarsDestroyed++;
	if ( isdefined ( attacker ) ) 
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1), attacker );
	}
	else 
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1));
	}
	
	self MarkDestructibleDestroyed();
}

function tank_grenade_stuck_think()
{
	self endon( "destructible_base_piece_death" );
	self endon( "death" );

	for ( ;; )
	{
		self waittill( "grenade_stuck", missile );

		if ( !IsDefined( missile ) || !IsDefined( missile.model ) )
		{
			continue;
		}

		if ( missile.model == "t5_weapon_crossbow_bolt" || missile.model == "t6_wpn_grenade_semtex_projectile" || missile.model == "wpn_t7_c4_world" )
		{
			self thread tank_grenade_stuck_explode( missile );
		}
	}
}

function tank_grenade_stuck_explode( missile )
{
	self endon( "destructible_base_piece_death" );
	self endon( "death" );

	owner = GetMissileOwner( missile );

	if ( IsDefined( owner ) && missile.model == "wpn_t7_c4_world" )
	{
		owner endon( "disconnect" );
		owner endon( "weapon_object_destroyed" );
		missile endon( "picked_up" );

		missile thread tank_hacked_c4( self );
	}

	missile waittill( "explode" );

	if ( IsDefined( owner ) )
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1), owner );
	}
	else
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1) );
	}
}

function tank_hacked_c4( tank )
{
	tank endon( "destructible_base_piece_death" );
	tank endon( "death" );
	self endon( "death" );

	self waittill( "hacked" );

	self notify( "picked_up" );
	tank thread tank_grenade_stuck_explode( self );
}

function car_death_think()
{
	self endon( "car_dead" );
	self.car_dead = false;

	self thread car_death_notify();

	self waittill( "destructible_base_piece_death", attacker );

	if ( isdefined( self ) )
	{
		self thread car_explosion( attacker, false );
	}
}

function car_grenade_stuck_think()
{
	self endon( "destructible_base_piece_death" );
	self endon( "car_dead" );
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "grenade_stuck", missile );

		if ( !isdefined( missile ) || !isdefined( missile.model ) )
		{
			continue;
		}

		if ( missile.model == "t5_weapon_crossbow_bolt" || missile.model == "t6_wpn_grenade_semtex_projectile" || missile.model == "wpn_t7_c4_world" )
		{
			self thread car_grenade_stuck_explode( missile );
		}
	}
}

function car_grenade_stuck_explode( missile )
{
	self endon( "destructible_base_piece_death" );
	self endon( "car_dead" );
	self endon( "death" );

	owner = GetMissileOwner( missile );

	if ( isdefined( owner ) && missile.model == "wpn_t7_c4_world" )
	{
		owner endon( "disconnect" );
		owner endon( "weapon_object_destroyed" );
		missile endon( "picked_up" );

		missile thread car_hacked_c4( self );
	}

	missile waittill( "explode" );

	if ( isdefined( owner ) )
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1), owner );
	}
	else
	{
		self DoDamage( self.health + 10000, self.origin + (0, 0, 1) );
	}
}

function car_hacked_c4( car )
{
	car endon( "destructible_base_piece_death" );
	car endon( "car_dead" );
	car endon( "death" );
	self endon( "death" );

	self waittill( "hacked" );
	
	self notify( "picked_up" );
	car thread car_grenade_stuck_explode( self );
}

function car_death_notify()
{
	self endon( "car_dead" );

	self waittill( "death", attacker );
	self notify( "destructible_base_piece_death", attacker );
}

function CodeCallback_DestructibleEvent( event, param1, param2, param3 )
{
	if( event == "broken" )
	{
		notify_type = param1;
		attacker = param2;
		weapon = param3;

		event_callback( notify_type, attacker, weapon );

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

function breakAfter( time, damage, piece )
{
	self notify( "breakafter" );
	self endon( "breakafter" );
	
	wait time;
	
	// this does not work in mp.  DoDamage does not take a piece for mp.
	self dodamage( damage, self.origin, undefined, /*piece*/undefined );
}

function barrel_death_think()
{
	self endon( "barrel_dead" );

	self waittill( "death", attacker );

	if ( isdefined( self ) )
	{
		self thread barrel_explosion( attacker, false );
	}
}

function barrel_fire_think(attacker) // self == the destructible object (like the car or barrel)
{	
	self endon( "barrel_dead" );
	self endon( "explode" );
	self endon( "death" );
	
	wait( RandomIntRange( 7, 10 ) );
	
	self thread barrel_explosion( attacker );
}

function barrel_explosion( attacker, physics_explosion )
{
	if ( !isdefined( physics_explosion ) )
	{
		physics_explosion = true;
	}

	self notify( "barrel_dead" );

	// delete the clip that is attached
	if( isdefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		dest_clip delete();
	}

	self RadiusDamage( self.origin, 256, 300, 75, attacker, "MOD_EXPLOSIVE", GetWeapon( "explodable_barrel" ) );
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	Earthquake( 0.5, 0.5, self.origin, 800 );

	if ( physics_explosion )
	{
		PhysicsExplosionSphere( self.origin, 255, 254, 0.3, 400, 25 );
	}
	level.globalBarrelsDestroyed++;
	self DoDamage( self.health + 10000, self.origin + (0, 0, 1), attacker );
	self MarkDestructibleDestroyed();
}
