swarm_init( localClientNum )
{
	level._effect["swarm_tail"] = LoadFx( "weapon/harpy_swarm/fx_hrpy_swrm_exhaust_trail_close" );
	level._client_flag_callbacks["scriptmover"][level.const_flag_missile_swarm] = ::swarm_start;
}

swarm_start( localClientNum, set )
{
	if ( set )
	{
		player = GetLocalPlayer( localClientNum );
		player thread swarm_think( localClientNum, self.origin );
	}
	else
	{
		level notify( "missile_swarm_stop" );
	}
}

swarm_think( localClientNum, sound_origin )
{
	level endon( "missile_swarm_stop" );
	self endon( "entityshutdown" );

	self.missile_swarm_count = 0;
	self.missile_swarm_max	= 9;

	self thread swarm_sound( localClientNum, sound_origin );

	for ( ;; )
	{
		assert( self.missile_swarm_count >= 0 );

		if ( self.missile_swarm_count > self.missile_swarm_max )
		{
			wait( 0.5 );
			continue;
		}

		count = RandomIntRange( 1, 4 );
		self.missile_swarm_count += count;

		for ( i = 0; i < count; i++ )
		{
			self projectile_spawn( localClientNum );
		}

		wait( ( self.missile_swarm_count / self.missile_swarm_max ) );
	}
}

projectile_spawn( localClientNum )
{
	dist = 10000;
	upVector = ( 0, 0, RandomIntRange( 1000, 1500 ) );

	yaw		= RandomIntRange( 0, 360 );
	angles	= ( 0, yaw, 0 );
	forward = AnglesToForward( angles );

	origin = self.origin + upVector + forward * dist * -1;
	end = self.origin + upVector + forward * dist;

	rocket = Spawn( localClientNum, origin, "script_model" );
	rocket SetModel( "p6_drone_harpy" );

	rocket thread projectile_move_think( localClientNum, self, origin, end );
}

projectile_move_think( localClientNum, player, start, end )
{
	wait( RandomFloatRange( 0.5, 1 ) );

	PlayFxOnTag( localClientNum, level._effect["swarm_tail"], self, "tag_origin" );

	direction = end - self.origin;
	self RotateTo( vectortoangles( direction ), 0.05 );
	self waittill( "rotatedone" );

	self MoveTo( end, RandomFloatRange( 8, 11 ) );
	self waittill( "movedone" );

	if ( IsDefined( player ) )
	{
		player.missile_swarm_count--;
	}
	
	self delete();
}

swarm_sound( localClientNum, origin )
{
	entity = Spawn( localClientNum, origin, "script_model" );
	wait( 2 );

	entity PlayLoopSound( "veh_harpy_drone_swarm_close__lp", 1 );
	level waittill( "missile_swarm_stop" );
	entity StopLoopSound( 1 );

	wait( 2 );
	entity delete();
}
