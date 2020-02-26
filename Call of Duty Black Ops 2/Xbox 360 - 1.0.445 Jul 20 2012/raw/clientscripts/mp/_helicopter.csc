#include clientscripts\mp\_utility;

#insert raw\maps\mp\_clientflags.gsh;

init()
{		
	level.chopper_fx["damage"]["light_smoke"] = loadfx ("trail/fx_trail_heli_killstreak_engine_smoke_33");
	level.chopper_fx["damage"]["heavy_smoke"] = loadfx ("trail/fx_trail_heli_killstreak_engine_smoke_66");

	level._effect["qrdrone_prop"] = loadfx( "weapon/qr_drone/fx_qr_wash_3p" );
//	level._effect["chinook_light"]["friendly"] = loadfx( "vehicle/light/fx_chinook_exterior_lights_grn_mp" );
//	level._effect["chinook_light"]["enemy"] = loadfx( "vehicle/light/fx_chinook_exterior_lights_red_mp" );
//	level._effect["cobra_light"]["friendly"] = loadfx( "vehicle/light/fx_cobra_exterior_lights_red_mp" );
//	level._effect["cobra_light"]["enemy"] = loadfx( "vehicle/light/fx_cobra_exterior_lights_red_mp" );
//	level._effect["hind_light"]["friendly"] = loadfx( "vehicle/light/fx_hind_exterior_lights_grn_mp" );
//	level._effect["hind_light"]["enemy"] = loadfx( "vehicle/light/fx_hind_exterior_lights_red_mp" );
//	level._effect["huey_light"]["friendly"] = loadfx( "vehicle/light/fx_huey_exterior_lights_grn_mp" );
//	level._effect["huey_light"]["enemy"] = loadfx( "vehicle/light/fx_huey_exterior_lights_red_mp" );

//	level._client_flag_callbacks["helicopter"][CLIENT_FLAG_WARN_TARGETED] = clientscripts\mp\_helicopter::warnMissileLocking;
//	level._client_flag_callbacks["helicopter"][CLIENT_FLAG_WARN_LOCKED] = clientscripts\mp\_helicopter::warnMissileLocked;
//	level._client_flag_callbacks["helicopter"][CLIENT_FLAG_WARN_FIRED] = clientscripts\mp\_helicopter::warnMissileFired;
}

warnMissileLocking( localClientNum, set )
{
	if ( set && !(self IsLocalClientDriver(localClientNum)) )
		return;
		
	clientscripts\mp\_helicopter_sounds::play_targeted_sound( set );
}

warnMissileLocked( localClientNum, set )
{
	if ( set && !(self IsLocalClientDriver(localClientNum)) )
		return;

	clientscripts\mp\_helicopter_sounds::play_locked_sound( set );
}

warnMissileFired( localClientNum, set )
{
	if ( set && !(self IsLocalClientDriver(localClientNum)) )
		return;

	clientscripts\mp\_helicopter_sounds::play_fired_sound( set );
}

heli_deletefx(localClientNum)
{
	if (isdefined(self.exhaustLeftFxHandle))
	{
		deletefx( localClientNum, self.exhaustLeftFxHandle );
		self.exhaustLeftFxHandle = undefined;
	}
	
	if (isdefined(self.exhaustRightFxHandlee))
	{
		deletefx( localClientNum, self.exhaustRightFxHandle );
		self.exhaustRightFxHandle = undefined;
	}
	
	if (isdefined(self.lightFXID))
	{
		deletefx( localClientNum, self.lightFXID );
		self.lightFXID = undefined;
	}

	if (isdefined(self.propFXID))
	{
		deletefx( localClientNum, self.propFXID );
		self.propFXID = undefined;
	}

}

startfx(localClientNum)
{
	self endon( "entityshutdown" );
	if (  IsDefined( self.vehicletype ) )
	{
		if ( self.vehicletype == "heli_guard_mp" )
		{
			return;
		}
	
		if ( self.vehicletype == "remote_mortar_vehicle_mp" )
		{
			return;
		}
		
		if ( self.vehicletype == "heli_player_gunner_mp" )
		{
			return;
		}
		
		if ( self.vehicletype == "vehicle_straferun_mp" )
		{
			return;
		}
	}
	
	if( isdefined( self.exhaustfxname ) && self.exhaustfxname != "" )
	{
		self.exhaustFx = loadfx( self.exhaustfxname ); 
	}

	if( IsDefined(self.exhaustFx) )
	{
		self.exhaustLeftFxHandle = PlayFXOnTag( localClientNum, self.exhaustFx, self, "tag_engine_left" );		
		if( !self.oneexhaust )
			self.exhaustRightFxHandle = PlayFXOnTag( localClientNum, self.exhaustFx, self, "tag_engine_right" );		
	}
	else
	{
	/#	PrintLn("Client: _helicopter.csc - startfx() - exhaust rotor fx is not loaded");	#/
	}
	
	if( isDefined( self.vehicletype ) )
	{
		light_fx = undefined;
		prop_fx = undefined;
		
		switch( self.vehicletype )
		{
//			case "heli_ai_mp":
//				light_fx = "cobra_light";
//				break;
//			case "heli_supplydrop_mp":
//				light_fx = "chinook_light";
//				break;
//			case "heli_gunner_mp":			
//				light_fx = "huey_light";
//				break;
//			case "heli_player_controlled_firstperson_mp":
//			case "heli_player_controlled_mp":
//				light_fx = "hind_light";
//				break;
			case "qrdrone_mp":
				prop_fx = "qrdrone_prop";
				break;
		};
	
		if ( isdefined( light_fx ) )
		{
			if ( self friendNotFoe( localClientNum ) )
			{
//				PrintLn( "HELI playing friendly " + light_fx + " " +   level._effect[light_fx]["friendly"] );
				self.lightFXID = PlayFXOnTag( localClientNum, level._effect[light_fx]["friendly"], self, "tag_origin" );
			}
			else
			{
//				PrintLn( "HELI playing enemy " + light_fx + " " +   level._effect[light_fx]["enemy"] );
				self.lightFXID = PlayFXOnTag( localClientNum, level._effect[light_fx]["enemy"], self, "tag_origin" );
			}
		}
		
		if ( isdefined( prop_fx ) && !self IsLocalClientDriver( localClientNum ))
		{
			self.propFXID = PlayFXOnTag( localClientNum, level._effect[prop_fx], self, "tag_origin" );
		}
	}
	
	self damage_fx_stages(localClientNum);
}

startfx_loop(localClientNum)
{
	self endon( "entityshutdown" );

	self thread clientscripts\mp\_helicopter_sounds::aircraft_dustkick(localClientNum);
	//self thread clientscripts\mp\_helicopter_sounds::start_helicopter_sounds();

	startfx( localClientNum );
	
	serverTime = getServerTime( 0 );
	lastServerTime = serverTime;
	
	while( isdefined( self ) )
	{
		//println( "HELI startfx_loop (" + serverTime + ")" );
		// if time goes backwards, then restart them
		if (serverTime < lastServerTime)
		{
			//println( "HELI !!! startfx called (" + serverTime + ")" );
			heli_deletefx( localClientNum );
			//wait( 0.5 );
			startfx( localClientNum );
		}
		wait( 0.05 );	// small for added granularity. any bigger and rapid time switching can cause problems.
		lastServerTime = serverTime;
		serverTime = getServerTime( 0 );
	}
}

damage_fx_stages(localClientNum)
{
	last_damage_state = self GetHeliDamageState();
	fx = undefined;
	
	for ( ;; )
	{
		if ( last_damage_state != self GetHeliDamageState() )
		{
			if ( self GetHeliDamageState() == 2 )
			{
				if ( IsDefined(fx) )
					stopfx( localClientNum, fx );
					
				fx = trail_fx( localClientNum, level.chopper_fx["damage"]["light_smoke"], "tag_engine_left" );
			}
			else if ( self GetHeliDamageState() == 1 )
			{
				if ( IsDefined(fx) )
					stopfx( localClientNum, fx );

				fx = trail_fx( localClientNum, level.chopper_fx["damage"]["heavy_smoke"], "tag_engine_left" );
			}
			else
			{
				if ( IsDefined(fx) )
					stopfx( localClientNum, fx );

				self notify( "stop trail" );
			}		
			last_damage_state = self GetHeliDamageState();
		}
		wait(0.25);
	}
}

trail_fx( localClientNum, trail_fx, trail_tag )
{
	// only one instance allowed
//	self notify( "stop trail" );
//	self endon( "stop trail" );
//	self endon( "entityshutdown" );
		
//	for ( ;; )
	{
		id = playfxontag( localClientNum, trail_fx, self, trail_tag );
		//wait( 0.05 );
	}
	return id;
}
