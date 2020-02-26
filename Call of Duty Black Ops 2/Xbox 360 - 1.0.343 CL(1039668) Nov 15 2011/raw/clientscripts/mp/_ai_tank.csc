#include clientscripts\mp\_vehicle;
#include clientscripts\mp\_utility;

main()
{
	level._ai_tank_fx = [];
	level._ai_tank_fx[ "dirt" ]		= loadfx( "vehicle/treadfx/fx_treadfx_talon_dirt" );
	level._ai_tank_fx[ "concrete" ] = loadfx( "vehicle/treadfx/fx_treadfx_talon_concrete" );
}

spawned( localClientNum )
{
	self thread play_driving_fx( localClientNum );
}

play_driving_fx( localClientNum )
{
	self endon( "entityshutdown" );

	maxspeed = self getmaxspeed();
	handle = undefined;
	
	for( ;; )
	{
		if ( !IsDefined( handle ) && self GetSpeed() >= 40 )
		{
			fx = self get_surface_fx();
			handle = PlayFxOnTag( localClientNum, fx, self, "tag_origin" );	
			self thread monitor_fx_stop( localClientNum, handle );
		}
		else if ( IsDefined( handle ) && self GetSpeed() < 40 )
		{
			self notify( "fx_stop" );
			handle = undefined;
		}

		serverwait( localClientNum, .1 );
	}
}

monitor_fx_stop( localClientNum, handle )
{
	self notify( "monitor_shutdown" );
	self endon( "monitor_shutdown" );

	self waittill_any( "entityshutdown", "fx_stop" );
	StopFx( localClientNum, handle );
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
