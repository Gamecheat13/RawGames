#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
 

#using scripts\zm\gametypes\_globallogic_player;

#using scripts\zm\_challenges;

                                             

#namespace destructible;

#using_animtree ( "mp_vehicles" );








	







function autoexec __init__sytem__() {     system::register("destructible",&__init__,undefined,undefined);    }
	
function __init__()
{
	level.destructible_callbacks = [];
	destructibles = GetEntArray( "destructible", "targetname" );
	
	clientfield::register( "scriptmover", "start_destructible_explosion", 1, 10, "int" );
	
	// since this is globally run, only continue if we have a destructible in the level
	if( destructibles.size <= 0 )
	{
		return;
	}

	for ( i = 0; i < destructibles.size; i++ )
	{
		if ( GetSubStr( destructibles[i].destructibledef, 0, 4 ) == "veh_" )
		{
			destructibles[i] thread destructible_car_death_think();
			destructibles[i] thread destructible_car_grenade_stuck_think();
		}
	}
	
	init_explosions();
}

function init_explosions()
{
	level.explosion_manager = SpawnStruct();
	level.explosion_manager.count = 0;
	level.explosion_manager.a_explosions = [];
	
	i = 0;
	while( i < 32 )
	{
		sExplosion = Spawn( "script_model", (0,0,0) );
		if ( !isdefined( level.explosion_manager.a_explosions ) ) level.explosion_manager.a_explosions = []; else if ( !IsArray( level.explosion_manager.a_explosions ) ) level.explosion_manager.a_explosions = array( level.explosion_manager.a_explosions ); level.explosion_manager.a_explosions[level.explosion_manager.a_explosions.size]=sExplosion;;
		i++;
	}
}

function get_unused_explosion()
{
	foreach( explosion in level.explosion_manager.a_explosions )
	{
		if( !( isdefined( explosion.in_use ) && explosion.in_use ) )
		{
			return explosion;			
		}
	}
	return level.explosion_manager.a_explosions[0];
}

function physics_explosion_and_rumble( origin, radius, physics_explosion )
{
	sExplosion = get_unused_explosion();
	sExplosion.in_use = true;
	sExplosion.origin = origin;
	
	assert( radius <= pow( 2, 10 ) - 1 );
	
	if( ( isdefined( physics_explosion ) && physics_explosion ) )
	{
		radius += ( 1 << ( 10 - 1 ) );
	}
	
	{wait(.05);};
	
	sExplosion clientfield::set( "start_destructible_explosion", radius );
	
	sExplosion.in_use = false;
}

function destructible_event_callback( destructible_event, attacker, weapon ) // self == the destructible object (like the car or barrel)
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
	
	// Until these are moved into GDTs:
	// Determine the type of explosive.
	// Assign use the correct explosion radius.
	if( IsSubStr( destructible_event, "explosive" ) )
	{
		// Grab damage type and radius
		tokens = StrTok(destructible_event, "_");
		damage_type = tokens[2];
		explosion_radius_type = tokens[3];
		
		// Set a default radius in case this doesn't catch somewhere.
		explosion_radius = 300;
		
		// Determine damage type
		switch ( damage_type )
		{
			case "concussive":
				if(explosion_radius_type == "large")
				{
					explosion_radius = 280;
				}
				else
				{
					explosion_radius = 220;
				}
				
			break;
			
			case "electrical":
			
				if(explosion_radius_type == "large")
				{
					explosion_radius = 60;
				}
				else
				{
					explosion_radius = 210;
				}
			break;
			
			case "incendiary":
				if(explosion_radius_type == "large")
				{
					explosion_radius = 250;
				}
				else
				{
					explosion_radius = 200;
				}
			break;
		}
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
			if ( isdefined( weapon ) )
			{
				self.destroyingWeapon = weapon;
			}
		break;

		case "destructible_car_fire":
			self thread destructible_car_fire_think(attacker);
			if ( isdefined( weapon ) )
			{
				self.destroyingWeapon = weapon;
			}
		break;

		case "explode":
			self thread simple_explosion( attacker );
		break;

		case "explode_complex":
			self thread complex_explosion( attacker, explosion_radius );
		break;
		
		case "destructible_explosive_incendiary_small":
		case "destructible_explosive_incendiary_large":
			self explosive_incendiary_explosion( attacker, explosion_radius, false );
			if ( isdefined( weapon ) )
			{
				self.destroyingWeapon = weapon;
			}
		break;
		
		case "destructible_explosive_electrical_small":
		case "destructible_explosive_electrical_large":
			self explosive_electrical_explosion( attacker, explosion_radius, false );
			if ( isdefined( weapon ) )
			{
				self.destroyingWeapon = weapon;
			}
		break;
		
		case "destructible_explosive_concussive_small":
		case "destructible_explosive_concussive_large":
			self explosive_concussive_explosion( attacker, explosion_radius, false );
			if ( isdefined( weapon ) )
			{
				self.destroyingWeapon = weapon;
			}
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
	offset = (0, 0, 5);
	self RadiusDamage( self.origin + offset, 256, 300, 75, attacker, "MOD_EXPLOSIVE", GetWeapon( "explodable_barrel" ) );
	physics_explosion_and_rumble( self.origin, 255, true );
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

	physics_explosion_and_rumble(self.origin, max_radius, true );
	
	if( isdefined( attacker ) )
	{
		self DoDamage( 20000, self.origin + offset, attacker );
	}
	else
	{	
		self DoDamage( 20000, self.origin + offset );
	}
}


function destructible_car_explosion( attacker, physics_explosion )
{
	if ( self.car_dead ) 
	{
		// prevents recursive entry caused by DoDamage call below
		return;
	}
	
	if ( !isdefined( physics_explosion ) )
	{
		physics_explosion = true;
	}

	self notify( "car_dead" );
	self.car_dead = true;
	
	if ( isdefined( attacker ))
	{
		self RadiusDamage( self.origin, 256, 300, 75, attacker, "MOD_EXPLOSIVE", GetWeapon( "destructible_car" ) );
	}
	else
	{
		self RadiusDamage( self.origin, 256, 300, 75 );
	}
	physics_explosion_and_rumble(self.origin, 255, physics_explosion );

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

function destructible_car_death_think()
{
	self endon( "car_dead" );
	self.car_dead = false;

	self thread destructible_car_death_notify();

	self waittill( "destructible_base_piece_death", attacker );

	if ( isdefined( self ) )
	{
		self thread destructible_car_explosion( attacker, false );
	}
}

function destructible_car_grenade_stuck_think()
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
			self thread destructible_car_grenade_stuck_explode( missile );
		}
	}
}

function destructible_car_grenade_stuck_explode( missile )
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

		missile thread destructible_car_hacked_c4( self );
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

function destructible_car_hacked_c4( car )
{
	car endon( "destructible_base_piece_death" );
	car endon( "car_dead" );
	car endon( "death" );
	self endon( "death" );

	self waittill( "hacked" );
	
	self notify( "picked_up" );
	car thread destructible_car_grenade_stuck_explode( self );
}

function destructible_car_death_notify()
{
	self endon( "car_dead" );

	self waittill( "death", attacker );
	self notify( "destructible_base_piece_death", attacker );
}

function destructible_car_fire_think(attacker)
{
	self endon( "death" );

	wait( RandomIntRange( 7, 10 ) );

	self thread destructible_car_explosion( attacker );
}

function CodeCallback_DestructibleEvent( event, param1, param2, param3, param4 )
{
	if( event == "broken" )
	{
		notify_type = param1;
		attacker = param2;
		piece = param3;
		weapon = param4;

		destructible_event_callback( notify_type, attacker, weapon );

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

function explosive_incendiary_explosion( attacker, explosion_radius, physics_explosion )
{
	if ( !IsVehicle( self ) )
	{
		offset = (0, 0, 5);
		if ( isdefined( attacker ))
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 380, 95, attacker, "MOD_BURNED", GetWeapon( "incendiary_fire" ) );
		}
		else
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 380, 95 );
		}
		physics_explosion_and_rumble(self.origin, 255, physics_explosion );
		
	}
	
	
	// delete the clip that is attached
	if( isdefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		if( isDefined( dest_clip ) )
		{
			dest_clip delete();
		}
	}
	
	self MarkDestructibleDestroyed();
}

function explosive_electrical_explosion( attacker, explosion_radius, physics_explosion )
{
	if ( !IsVehicle( self ) )
	{
		offset = (0, 0, 5);
		if ( isdefined( attacker ))
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 350, 80, attacker, "MOD_ELECTROCUTED" );
		}
		else
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 350, 80 );
		}
		physics_explosion_and_rumble(self.origin, 255, physics_explosion );

	}
	
	
	// delete the clip that is attached
	if( isdefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		if( isDefined( dest_clip ) )
		{
			dest_clip delete();
		}
	}
	
	self MarkDestructibleDestroyed();
}

function explosive_concussive_explosion( attacker, explosion_radius, physics_explosion )
{
	if ( !IsVehicle( self ) )
	{
		offset = (0, 0, 5);
		if ( isdefined( attacker ))
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 50, attacker, "MOD_GRENADE" );
		}
		else
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 50 );
		}
		physics_explosion_and_rumble(self.origin, 255, physics_explosion );
	}
	
	
	// delete the clip that is attached
	if( isdefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		if( isDefined( dest_clip ) )
		{
			dest_clip delete();
		}
	}
	
	self MarkDestructibleDestroyed();
}
