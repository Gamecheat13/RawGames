#include maps\_utility;
#include common_scripts\utility;
#using_animtree("fxanim_props");

init()
{
	destructibles = GetEntArray( "destructible", "targetname" );
	array_thread( destructibles, ::destructible_think );
	
	// since this is globally run, only continue if we have a destructible in the level
	if( destructibles.size <= 0 )
	{
		return;
	}
	
	for ( i = 0; i < destructibles.size; i++ )
	{
		if( IsSubStr( destructibles[i].destructibledef, "barrel" ) )
		{
			destructibles[i] thread destructible_barrel_death_think();
		}
	}
}

destructible_think()
{
	self endon( "death" );

	if( self.destructibledef == "fxanim_gp_ceiling_fan_old_mod" ||
		self.destructibledef == "fxanim_gp_ceiling_fan_modern_mod" ||
		self.destructibledef == "fxanim_airconditioner_mod" )
	{
		self thread ceiling_fan_think();
		return;
	}
}

destructible_event_callback( destructible_event, attacker )
{
	// yield so that this thread gets its own context and doesn't continue to push the callstack in case of chain reactions
	waittillframeend;
	
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
	
	switch ( destructible_event )
	{
	
	case "destructible_barrel_fire":
		self thread destructible_barrel_fire_think();
		break;

	case "destructible_barrel_explosion":
		self destructible_barrel_explosion( attacker );
		break;
		
	case "destructible_car_explosion":
		self destructible_car_explosion( attacker );
		break;

	case "destructible_car_fire":
		self thread destructible_car_fire_think();
		break;

	case "explode":
		self thread simple_explosion( attacker );
		break;
	
	case "explode_complex":
		self thread complex_explosion( attacker, explosion_radius );
		break;
		
	case "delete_collision":
		self thread delete_collision();
		break;
		
	default:
		/#
		iprintln( "_destructible.gsc: unknown destructible event: '" + destructible_event + "'" );
		#/
		break;
	}
}

simple_explosion( attacker )
{
	offset = (0, 0, 5);

	if ( IsDefined( attacker ) )
	{
		self RadiusDamage( self.origin + offset, 300, 300, 100, attacker );
	}
	else
	{
		self RadiusDamage( self.origin + offset, 300, 300, 100 );
	}

	PhysicsExplosionSphere( self.origin + offset, 255, 254, 0.3 );
	self DoDamage( 20000, self.origin + offset );
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

	PhysicsExplosionSphere( self.origin + offset, max_radius, max_radius - 1, 0.3 );
	self DoDamage( 20000, self.origin + offset );
}

CodeCallback_DestructibleEvent( event, param1, param2, param3 )
{
	if( event == "broken" )
	{
		notify_type = param1;
		attacker = param2;

		self notify( event, notify_type, attacker );

		// thread this to prevent long chain reactions that blow up the callstack limit
		self thread destructible_event_callback( notify_type, attacker );
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

ceiling_fan_think()
{
	self UseAnimTree(#animtree);

	self SetFlaggedAnimKnobRestart( "idle", %fxanim_gp_ceiling_fan_old_slow_anim, 1, 0.0, 1 );
	self waittill( "broken", destructible_event, attacker );

	if( destructible_event == "stop_idle" )
	{
		self DoDamage( 5000, self.origin );
		self SetFlaggedAnimKnobRestart( "idle", %fxanim_gp_ceiling_fan_old_dest_anim, 1, 0.0, 1 );
	}	
}

delete_collision()
{
	self endon( "death" );

	if( IsDefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		wait 0.1;
		dest_clip delete();
	}
}	
	

destructible_barrel_death_think()
{
	self endon( "barrel_dead" );

	self waittill( "death" );
	self thread destructible_barrel_explosion( undefined, false );
}

destructible_barrel_fire_think() // self == the destructible object (like the car or barrel)
{	
	self endon( "barrel_dead" );
	self endon( "explode" );
	self endon( "death" );

	wait( RandomIntRange( 7, 10 ) );
	
	destructible_barrel_explosion();
}

destructible_barrel_explosion( attacker, physics_explosion )
{
	if ( !IsDefined( physics_explosion ) )
	{
		physics_explosion = true;
	}
	
	if(!isDefined(self))
	{
		return;
	}
	
	self notify( "barrel_dead" );

	// delete the clip that is attached
	if( IsDefined( self.target ) )
	{
		dest_clip = GetEnt( self.target, "targetname" );
		dest_clip delete();
	}
	
	self RadiusDamage( self.origin, 256, 300, 85, attacker, "MOD_EXPLOSIVE", "frag_grenade_sp" );
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	Earthquake( 0.5, 0.5, self.origin, 800 );

	if ( physics_explosion )
	{
		//PhysicsExplosionSphere( <position of explosion>, <outer radius>, <inner radius>, <magnitude>, <outer damage>, <inner damage> )
		PhysicsExplosionSphere( self.origin, 255, 254, 0.3, 25, 400 );
	}
	
	self DoDamage( self.health + 10000, self.origin + (0, 0, 1) );
}

#using_animtree("vehicles");
destructible_car_explosion( attacker )
{
	self UseAnimTree( #animtree );
	self SetAnim( %veh_car_destroy, 1.0, 0.0, 1.0 );

	if (self.classname != "script_vehicle") // _vehicle handles vehicle damage 
	{
		// set this variable so that it can be accessed by death hints to know that the player 
		// was killed by a destructible car explosion
		self.destructiblecar = true;
		self RadiusDamage( self.origin, 250, 500, 80, attacker, "MOD_EXPLOSIVE" );
		Earthquake(.4, 1, self.origin, 800);
	}

	PlayRumbleOnPosition("grenade_rumble", self.origin);

	self DoDamage(self.health + 10000, self.origin + (0, 0, 1), attacker);
	self notify("death", attacker);
}

destructible_car_fire_think()
{
	self endon( "death" );
	wait( RandomIntRange( 7, 10 ) );
	destructible_car_explosion();
}

getDamageType( type )
{
	//returns a simple damage type: melee, bullet, splash, or unknown

	if ( !isdefined( type ) )
		return "unknown";

	type = ToLower( type );
	switch( type )
	{
		case "mod_melee":
		case "mod_crush":
		case "melee":
			return "melee";
		case "mod_pistol_bullet":
		case "mod_rifle_bullet":
		case "bullet":
			return "bullet";
		case "mod_grenade":
		case "mod_grenade_splash":
		case "mod_projectile":
		case "mod_projectile_splash":
		case "mod_explosive":
		case "splash":
			return "splash";
		case "mod_impact":
			return "impact";
		case "unknown":
			return "unknown";
		default:
			return "unknown";
	}
}
