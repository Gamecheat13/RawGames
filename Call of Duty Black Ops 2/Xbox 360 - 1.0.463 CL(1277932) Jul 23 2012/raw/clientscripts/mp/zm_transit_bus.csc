#include clientscripts\mp\_utility;
#include clientscripts\mp\_music;

main()
{
}

bus_flashing_lights( localClientNum, set, newEnt )
{
	if ( localClientNum != 0 )
	{
		return;
	}
	
	localPlayers = GetLocalPlayers();

	if ( set )
	{
		for ( i = 0; i < localPlayers.size; i++ )
		{
			level thread do_bus_flashing_lights( i, self );
		}
	}
	else
	{
		if ( IsDefined( self.flashingLights ) )
		{
			for ( i = 0; i < localPlayers.size; i++ )
			{
				stopfx( i, self.flashingLights );
			}
		}
	}
}

do_bus_flashing_lights( LocalClientNum, bus )
{
	bus.flashingLights = PlayFXOnTag( 0, level._effect[ "fx_emergencylight" ], bus, "tag_flashing_lights" );
}

bus_head_lights( localClientNum, set, newEnt )
{
	if ( localClientNum != 0 )
	{
		return;
	}
	
	localPlayers = GetLocalPlayers();

	if ( set )
	{
		for ( i = 0; i < localPlayers.size; i++ )
		{
			level thread do_bus_head_lights( i, self );
		}
	}
	else
	{
		if ( IsDefined( self.headLights ) )
		{
			for ( i = 0; i < localPlayers.size; i++ )
			{
				stopfx( i, self.headLights );
			}
		}
	}
}

do_bus_head_lights( LocalClientNum, bus )
{
	bus.headLights = PlayFXOnTag( LocalClientNum, level._effect[ "fx_headlight" ], bus, "tag_headlights" );
}

bus_brake_lights( localClientNum, set, newEnt )
{
	if ( localClientNum != 0 )
	{
		return;
	}
	
	localPlayers = GetLocalPlayers();

	if ( set )
	{
		for ( i = 0; i < localPlayers.size; i++ )
		{
			level thread do_bus_brake_lights( i, self );
		}
	}
	else
	{
		if ( IsDefined( self.brakeLights ) )
		{
			for ( i = 0; i < localPlayers.size; i++ )
			{
				stopfx( i, self.brakeLights );
			}
		}
	}
}

do_bus_brake_lights( LocalClientNum, bus )
{
	bus.brakeLights = PlayFXOnTag( 0, level._effect[ "fx_brakelight" ], bus, "tag_brakelights" );
}

bus_turnal_signal_right_lights( localClientNum, set, newEnt )
{
	if ( localClientNum != 0 )
	{
		return;
	}
	
	localPlayers = GetLocalPlayers();

	if ( set )
	{
		for ( i = 0; i < localPlayers.size; i++ )
		{
			level thread do_bus_turnal_signal_right_lights( i, self );
		}
	}
	else
	{
		if ( IsDefined( self.turnRightLights ) )
		{
			for ( i = 0; i < localPlayers.size; i++ )
			{
				stopfx( i, self.turnRightLights );
			}
		}
	}
}

do_bus_turnal_signal_right_lights( LocalClientNum, bus )
{
	bus.turnRightLights = PlayFXOnTag( 0, level._effect[ "fx_turn_signal_right" ], bus, "tag_turnsignal_right" );
}

bus_turnal_signal_left_lights( localClientNum, set, newEnt )
{
	if ( localClientNum != 0 )
	{
		return;
	}
	
	localPlayers = GetLocalPlayers();

	if ( set )
	{
		for ( i = 0; i < localPlayers.size; i++ )
		{
			level thread do_bus_turnal_signal_left_lights( i, self );
		}
	}
	else
	{
		if ( IsDefined( self.turnLeftLights ) )
		{
			for ( i = 0; i < localPlayers.size; i++ )
			{
				stopfx( i, self.turnLeftLights );
			}
		}
	}
}

do_bus_turnal_signal_left_lights( LocalClientNum, bus )
{
	bus.turnLeftLights = PlayFXOnTag( 0, level._effect[ "fx_turn_signal_left" ], bus, "tag_turnsignal_left" );
}