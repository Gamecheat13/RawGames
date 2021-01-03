#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
 

#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic_player;

#using scripts\cp\_challenges;
#using scripts\cp\_oed;
#using scripts\cp\_bb;

                                             

#namespace destructible;

function autoexec __init__sytem__() {     system::register("destructible",&__init__,&__main__,undefined);    }
	
#using_animtree ( "mp_vehicles" );









	







function __init__()
{
	
	clientfield::register( "scriptmover", "start_destructible_explosion", 1, 11, "int" );
	
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
		else if ( destructibles[i].destructibledef == "fxdest_upl_metal_tank_01" )
		{
			destructibles[i] thread tank_grenade_stuck_think();
		}
	}
	
	init_explosions();
}

function __main__()
{
	waittillframeend; // clientfields can't be set before a wait
	
	a_destructibles = GetEntArray( "destructible", "targetname" );
	
	// since this is globally run, only continue if we have a destructible in the level
	if( a_destructibles.size <= 0 )
	{
		return;
	}

	foreach( e_destructible in a_destructibles )
	{
		if( IsSubStr( e_destructible.destructibledef, "explosive_concussive" ) ||
		    IsSubStr( e_destructible.destructibledef, "explosive_electrical" ) ||
		    IsSubStr( e_destructible.destructibledef, "explosive_incendiary" ) )
		{
			e_destructible thread oed::enable_thermal();
		}
	}
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

//car_explosion is for special cases where the inner radius is outer_radius - 1 instead of outer_radius / 2
function physics_explosion_and_rumble( origin, radius, inner_is_half_outer = true, is_lg_explosion = false )
{
	sExplosion = get_unused_explosion();
	sExplosion.in_use = true;
	sExplosion.origin = origin;
	
	{wait(.05);};
	
	assert( radius <= pow( 2, ( 11 - 1 ) ) - 1 );
	
	clientfield_radius = radius;

	if( inner_is_half_outer )
	{
		clientfield_radius += 1 << ( 11 - 1 );
	}
	
	if( is_lg_explosion )
	{
		clientfield_radius += 1 << ( 11 - 2 );
	}

	sExplosion clientfield::set( "start_destructible_explosion", clientfield_radius );
	sExplosion.in_use = false;
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
	
	if ( isdefined( weapon ) )
	{
		self.destroyingWeapon = weapon;
	}

	switch ( destructible_event )
	{
		case "destructible_car_explosion":
			self car_explosion( attacker );
			break;

		case "destructible_car_fire":
			level thread battlechatter::bc_AInearExplodable( self, "car" );	
			self thread car_fire_think(attacker);
			break;

		case "explode":
			self thread simple_explosion( attacker );
			break;

		case "explode_complex":
			self thread complex_explosion( attacker, 300 );
			break;
		
		case "destructible_explosive_incendiary_small":
			self explosive_incendiary_explosion( attacker, 230 );
			break;
		case "destructible_explosive_incendiary_large":
			self explosive_incendiary_explosion( attacker, 265, true );
			break;
		
		case "destructible_explosive_electrical_small":
			self explosive_electrical_explosion( attacker, 240 );
			break;
		case "destructible_explosive_electrical_large":
			self explosive_electrical_explosion( attacker, 290, true );
			break;
		
		case "destructible_explosive_concussive_small":
			self explosive_concussive_explosion( attacker, 240 );
			break;
		case "destructible_explosive_concussive_large":
			self explosive_concussive_explosion( attacker, 275, true );
			break;

		default:
		//iprintln( "_destructible.gsc: unknown destructible event: '" + destructible_event + "'" );
		break;
	}
	
	bb::logexplosionevent(self, attacker, destructible_event, explosion_radius);
	
	if ( isdefined( level.destructible_callbacks[ destructible_event ] ) )
	{
		self thread [[level.destructible_callbacks[ destructible_event ]]]( destructible_event, attacker );
	}
}

function car_fire_think(attacker)
{
	self endon( "death" );

	wait( RandomIntRange( 7, 10 ) );

	self thread car_explosion( attacker );
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
	physics_explosion_and_rumble( self.origin, 255, false );
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

	physics_explosion_and_rumble( self.origin + offset, max_radius, false );

	if( isdefined( attacker ) )
	{
		self DoDamage( 20000, self.origin + offset, attacker, false );
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
		physics_explosion_and_rumble( self.origin, 255, false );
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

function CodeCallback_DestructibleEvent( event, param1, param2, param3, param4 )
{
	if( event == "broken" )
	{
		notify_type = param1;
		attacker = param2;
		piece = param3;
		weapon = param4;

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

function explosive_incendiary_explosion( attacker, explosion_radius, is_lg_explosion = false )
{
	if ( !IsVehicle( self ) )
	{
		offset = ( 0, 0, 5 );
		if ( isdefined( attacker ) )
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 10, attacker, "MOD_BURNED", GetWeapon( "incendiary_fire" ) );
		}
		else
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 10 );
		}
		
		physics_explosion_and_rumble( self.origin, explosion_radius, true, is_lg_explosion );
		
		if ( is_lg_explosion )
		{
			level thread spawn_fire_trigger( self.origin, 80, 10 );
		}
		else
		{
			level thread spawn_fire_trigger( self.origin, 50, 10 );
		}
	}
	
	// delete the clip that is attached
	if ( isdefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		if ( isdefined( dest_clip ) )
		{
			dest_clip Delete();
		}
	}
	
	self MarkDestructibleDestroyed();
}

function spawn_fire_trigger( v_origin, n_radius, n_time )
{
	e_trig = Spawn( "trigger_radius_hurt", v_origin, 0, n_radius, n_radius );
	e_trig.script_hazard = "heat";
		
	wait n_time;
		
	e_trig Delete();
}

function explosive_electrical_explosion( attacker, explosion_radius, is_lg_explosion )
{
	if ( !IsVehicle( self ) )
	{
		offset = (0, 0, 5);
		if ( isdefined( attacker ))
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 10, attacker, "MOD_ELECTROCUTED" );
		}
		else
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 10 );
		}
		physics_explosion_and_rumble( self.origin, explosion_radius, true, is_lg_explosion );

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

function explosive_concussive_explosion( attacker, explosion_radius, is_lg_explosion )
{
	if ( !IsVehicle( self ) )
	{
		offset = (0, 0, 5);
		if ( isdefined( attacker ))
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 10, attacker, "MOD_GRENADE" );
		}
		else
		{
			self RadiusDamage( self.origin + offset, explosion_radius, 300, 10 );
		}
		physics_explosion_and_rumble(  self.origin, explosion_radius, true, is_lg_explosion );

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
