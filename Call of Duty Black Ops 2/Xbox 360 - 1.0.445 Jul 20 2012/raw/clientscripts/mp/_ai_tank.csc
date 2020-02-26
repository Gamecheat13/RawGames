#include clientscripts\mp\_vehicle;
#include clientscripts\mp\_utility;

#insert raw\maps\mp\_clientflags.gsh;

#using_animtree ( "mp_vehicles" );

main()
{
	level._ai_tank_fx = [];
	level._ai_tank_fx[ "dirt" ]			= loadfx( "vehicle/treadfx/fx_treadfx_talon_dirt" );
	level._ai_tank_fx[ "concrete" ]		= loadfx( "vehicle/treadfx/fx_treadfx_talon_concrete" );
	level._ai_tank_fx[ "light_green" ]	= loadfx( "light/fx_vlight_talon_eye_grn" );
	level._ai_tank_fx[ "light_red" ]	= loadfx( "light/fx_vlight_talon_eye_red" );
	level._ai_tank_fx[ "stun" ]			= loadfx( "weapon/talon/fx_talon_emp_stun" );

	RegisterClientField( "vehicle", "ai_tank_death", 1, "int", ::death, false );
	RegisterClientField( "vehicle", "ai_tank_missile_fire", 3, "int", ::missile_fire, false );
	RegisterClientField( "vehicle", "ai_tank_hack_spawned", 1, "int", ::spawned, false );
	RegisterClientField( "vehicle", "ai_tank_hack_rebooting", 1, "int", ::rebooting, false );

	level._client_flag_callbacks["vehicle"][CLIENT_FLAG_STUN] = ::tank_stun;
}

spawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	if ( !IsDefined( newVal ) )
	{
		newVal = 1;
	}
	
	if ( newVal )
	{
		self thread play_light_fx( localClientNum );
		self thread play_driving_fx( localClientNum );
		self thread play_driving_rumble( localClientNum );
	}
}

missile_fire( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	self UseAnimTree( #animtree );

	if ( newVal == 2 )
	{
		self SetAnimRestart( %o_drone_tank_missile1_fire, 1.0, 0.0, 0.5 );
	}
	else if ( newVal == 1 )
	{
		self SetAnimRestart( %o_drone_tank_missile2_fire, 1.0, 0.0, 0.5 );
	}
	else if ( newVal == 0 )
	{
		self SetAnimRestart( %o_drone_tank_missile3_fire, 1.0, 0.0, 0.5 );
	}
	else if ( newVal == 4 )
	{
		self SetAnimRestart( %o_drone_tank_missile_full_reload, 1.0, 0.0, 1.0 );
	}
}

play_light_fx( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "light_disable" );
	self endon( "death" );

	self notify( "reboot_disable" );

	if ( !IsDefined( self.fx ) )
	{
		self.fx = [];
	}

	if ( !IsDefined( self.stun_fx ) )
	{
		self.stun_fx = [];
	}

	if ( !IsDefined( self.friend ) )
	{
		self.friend = [];
	}

	self stop_light_fx( localClientNum );

	self.fx[ localClientNum ] = undefined;
	self.friend[ localClientNum ] = false;

	self start_light_fx( localClientNum );
	
	for( ;; )
	{
		serverwait( localClientNum, 0.05 );

		player = GetLocalPlayer( localClientNum );

		if ( !IsDefined( player ) )
		{
			self stop_light_fx( localClientNum );
			continue;
		}
		else if ( IsDefined( self.fx[ localClientNum ] ) && IsInVehicle( localClientNum, self ) )
		{
			self stop_light_fx( localClientNum );
		}
		else if ( self.friend[ localClientNum ] != self friendNotFoe( localClientNum ) )
		{
			self stop_light_fx( localClientNum );
		}
		else if ( player GetInKillcam( localClientNum ) && self.friend[ localClientNum ] == self friendNotFoe( localClientNum ) )
		{
			self stop_light_fx( localClientNum );
		}

		if ( !IsDefined( self.fx[ localClientNum ] ) && !IsInVehicle( localClientNum, self ) )
		{
			self start_light_fx( localClientNum );
		}
	}
}

tank_stun( localClientNum, set )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	if ( set )
	{
		self notify( "light_disable" );
		self stop_light_fx( localClientNum );

		self stop_stun_fx( localClientNum );
		self start_stun_fx( localClientNum );
	}
	else
	{
		self thread play_light_fx( localClientNum );			
		self stop_stun_fx( localClientNum );
	}
}

death( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	if ( newVal )
	{
		self stop_light_fx( localClientNum );
		self stop_stun_fx( localClientNum );
		self notify( "light_disable" );
	}
}

start_light_fx( localClientNum )
{
	friend = self friendNotFoe( localClientNum );

	player = GetLocalPlayer( localClientNum );

	if ( IsDefined( player ) && player GetInKillcam( localClientNum ) )
	{
		friend = !friend;
	}

	if ( friend )
	{
		self.fx[ localClientNum ] = playfxontag( localClientNum, level._ai_tank_fx[ "light_green" ], self, "tag_scanner" );
		self.friend[ localClientNum ] = true;
	}
	else
	{
		self.fx[ localClientNum ] = playfxontag( localClientNum, level._ai_tank_fx[ "light_red" ], self, "tag_scanner" );
		self.friend[ localClientNum ] = false;
	}
}

stop_light_fx( localClientNum )
{
	if ( IsDefined( self.fx[ localClientNum ] ) )
	{
		StopFx( localClientNum, self.fx[ localClientNum ] );
		self.fx[ localClientNum ] = undefined;
	}
}

start_stun_fx( localClientNum )
{
	self.stun_fx[ localClientNum ] = playfxontag( localClientNum, level._ai_tank_fx[ "stun" ], self, "tag_turret" );
	PlaySound( localClientNum, "veh_talon_shutdown", self.origin );
}

stop_stun_fx( localClientNum )
{
	if ( IsDefined( self.stun_fx[ localClientNum ] ) )
	{
		StopFx( localClientNum, self.stun_fx[ localClientNum ] );
		self.stun_fx[ localClientNum ] = undefined;
	}
}

play_driving_fx( localClientNum )
{
	self endon( "entityshutdown" );

	for( ;; )
	{
		if ( self GetSpeed() >= 40 )
		{
			forward = AnglesToForward( self.angles );
			up = AnglesToUp( self.angles );
						
			fx = self get_surface_fx();
			PlayFx( localClientNum, fx, self.origin, forward, up );

			wait( 0.5 );
			continue;
		}

		serverwait( localClientNum, 0.1 );
	}
}

play_driving_rumble( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "death" );

	for ( ;; )
	{
		if ( IsInVehicle( localClientNum, self ) )
		{
			speed = self GetSpeed();

			if ( speed >= 40 || speed <= -40 )
			{
				player = GetLocalPlayer( localClientNum );

				if ( IsDefined( player ) )
				{
					player Earthquake( 0.1, 0.1, self.origin, 200 );
				}
			}
		}

		serverwait( localClientNum, 0.05 );
	}
}

rebooting( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	if ( newVal )
	{
		self thread start_reboot_fx( localClientNum );
	}
	else
	{
		self notify( "reboot_disable" );
		self stop_light_fx( localClientNum );
	}
}

start_reboot_fx( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "reboot_disable" );
	self endon( "death" );

	self start_light_fx( localClientNum );
	serverwait( localClientNum, 0.3 );
	self stop_light_fx( localClientNum );
	serverwait( localClientNum, 0.3 );
	self start_light_fx( localClientNum );
	serverwait( localClientNum, 0.2 );
	self stop_light_fx( localClientNum );
	serverwait( localClientNum, 0.2 );
	self start_light_fx( localClientNum );
	serverwait( localClientNum, 0.2 );
	self stop_light_fx( localClientNum );
	serverwait( localClientNum, 0.2 );
	self start_light_fx( localClientNum );
	serverwait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
	serverwait( localClientNum, 0.1 );
	self start_light_fx( localClientNum );
	serverwait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
	serverwait( localClientNum, 0.1 );
	self start_light_fx( localClientNum );
	serverwait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
	serverwait( localClientNum, 0.1 );
	self start_light_fx( localClientNum );
	serverwait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
}

get_surface_fx()
{
	surface_type = self GetWheelSurface( "front_right" );
	
	switch( surface_type )
	{
		case "dirt":
		case "mud":
		case "gravel":
		case "grass":
		case "foliage":
		case "sand":
		case "water":
			return level._ai_tank_fx[ "dirt" ];	
	}
	
	return level._ai_tank_fx[ "concrete" ];
}
