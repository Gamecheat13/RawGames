/*
Use this for jet flyover audio on the server

You will need to thread planeposition updater on any entity you want to run the flyover audio on.

ex
migs[i] playsound ("veh_mig_flyby_2d");
migs[i] thread plane_position_updater (3000);
*/

#include maps\_utility;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

init()
{
	if ( !IsDefined( level._flyover_audio_table ) )
	{
		level._flyover_audio_table = [];
		level._flyover_audio_table["primary"] = [];
		level._flyover_audio_table["secondary"] = [];		
	}
	
	level._flyover_audio_radius = []; 
	//level._flyover_audio_radius["primary"] = 2500;
	//level._flyover_audio_radius["secondary"] = 1000;	
	level._flyover_audio_radius["primary"] = 4000;
	level._flyover_audio_radius["secondary"] = 1500;	
	level._flyover_audio_time = 100;
	
	// Default
	add_flyover_audio_entry( "primary", "default", "veh_mig_flyby", "veh_mig_flyby_lfe", 3000 );
	add_flyover_audio_entry( "secondary", "default", "veh_mig_flyby", "veh_mig_flyby_lfe", 3000 );	
	
	// Phantom Low Res
	add_flyover_audio_entry( "primary", "plane_phantom_gearup_lowres", "veh_phantom_flyby", undefined, 4375 );

	// Avenger wash sounds
	add_flyover_audio_entry( "primary", "drone_avenger_fast", "evt_flyby_wash_715", undefined, 715 );
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_1626", undefined, 1626 );
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_1924", undefined, 1924 );
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_2362", undefined, 2362 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_2793", undefined, 2793 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_3032", undefined, 3032 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_3090", undefined, 3090 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_3410", undefined, 3410 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_4025", undefined, 4025 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_4375", undefined, 4375 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_4642", undefined, 4642 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_4740", undefined, 4740 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_4762", undefined, 4762 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_5615", undefined, 5615 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_6200", undefined, 6200 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_8270", undefined, 8270 );	
	add_flyover_audio_entry( "primary","drone_avenger_fast", "evt_flyby_wash_10420", undefined, 10420 );	
	
	
	// Avenger apex sounds	
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_280", undefined, 280 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_310", undefined, 310 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_312", undefined, 312 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_405", undefined, 405 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_530", undefined, 530 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_630", undefined, 630 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_666", undefined, 666 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_715", undefined, 715 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_1085", undefined, 1085 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_1200", undefined, 1200 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_1874", undefined, 1874 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_2200", undefined, 2200 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_2362", undefined, 2362 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_2793", undefined, 2793 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_4375", undefined, 4375 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_6270", undefined, 6270 );
	add_flyover_audio_entry( "secondary", "drone_avenger_fast", "evt_flyby_apex_7000", undefined, 7000 );	
	
	
	// Pegasus wash sounds
	add_flyover_audio_entry( "primary", "drone_pegasus_fast", "evt_flyby_wash_715", undefined, 715 );
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_1626", undefined, 1626 );
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_1924", undefined, 1924 );
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_2362", undefined, 2362 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_2793", undefined, 2793 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_3032", undefined, 3032 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_3090", undefined, 3090 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_3410", undefined, 3410 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_4025", undefined, 4025 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_4375", undefined, 4375 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_4642", undefined, 4642 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_4740", undefined, 4740 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_4762", undefined, 4762 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_5615", undefined, 5615 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_6200", undefined, 6200 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_8270", undefined, 8270 );	
	add_flyover_audio_entry( "primary","drone_pegasus_fast", "evt_flyby_wash_10420", undefined, 10420 );	
	
	// Pegasus apex sounds
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_280", undefined, 280 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_310", undefined, 310 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_312", undefined, 312 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_405", undefined, 405 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_530", undefined, 530 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_630", undefined, 630 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_666", undefined, 666 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_715", undefined, 715 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_1085", undefined, 1085 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_1200", undefined, 1200 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_1874", undefined, 1874 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_2200", undefined, 2200 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_2362", undefined, 2362 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_2793", undefined, 2793 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_4375", undefined, 4375 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_6270", undefined, 6270 );
	add_flyover_audio_entry( "secondary", "drone_pegasus_fast", "evt_flyby_apex_7000", undefined, 7000 );


	//car bys
	add_flyover_audio_entry( "secondary", "civ_pickup", "veh_car_by_252", undefined, 352 );		
	add_flyover_audio_entry( "secondary", "civ_pickup", "veh_car_by_349", undefined, 449 );	
	add_flyover_audio_entry( "secondary", "civ_pickup", "veh_car_by_517", undefined, 617 );	
	add_flyover_audio_entry( "secondary", "civ_pickup", "veh_car_by_560", undefined, 660 );	
	add_flyover_audio_entry( "secondary", "civ_pickup", "veh_car_by_624", undefined, 724 );	

	
	add_flyover_audio_entry( "secondary", "civ_hatchback_small", "veh_car_by_252", undefined, 352 );		
	add_flyover_audio_entry( "secondary", "civ_hatchback_small", "veh_car_by_349", undefined, 449 );	
	add_flyover_audio_entry( "secondary", "civ_hatchback_small", "veh_car_by_517", undefined, 617 );	
	add_flyover_audio_entry( "secondary", "civ_hatchback_small", "veh_car_by_560", undefined, 660 );	
	add_flyover_audio_entry( "secondary", "civ_hatchback_small", "veh_car_by_624", undefined, 724 );	

	
	add_flyover_audio_entry( "secondary", "tiara", "veh_car_by_252", undefined, 352 );		
	add_flyover_audio_entry( "secondary", "tiara", "veh_car_by_349", undefined, 449 );	
	add_flyover_audio_entry( "secondary", "tiara", "veh_car_by_517", undefined, 617 );	
	add_flyover_audio_entry( "secondary", "tiara", "veh_car_by_560", undefined, 660 );	
	add_flyover_audio_entry( "secondary", "tiara", "veh_car_by_624", undefined, 724 );	

	
	add_flyover_audio_entry( "secondary", "civ_bus", "veh_car_by_252", undefined, 352 );		
	add_flyover_audio_entry( "secondary", "civ_bus", "veh_car_by_349", undefined, 449 );	
	add_flyover_audio_entry( "secondary", "civ_bus", "veh_car_by_517", undefined, 617 );	
	add_flyover_audio_entry( "secondary", "civ_bus", "veh_car_by_560", undefined, 660 );	
	add_flyover_audio_entry( "secondary", "civ_bus", "veh_car_by_624", undefined, 724 );	

	
	
	thread onPlayerConnect();
}

add_flyover_audio_entry( source, vehicle_type, sound_alias1, sound_alias2, time )
{
	if ( !IsDefined( level._flyover_audio_table[source][ vehicle_type ] ) )
	{
		level._flyover_audio_table[source][ vehicle_type ] = [];
	}
	
	entry = SpawnStruct();
	entry.sound_alias1 = sound_alias1;
	entry.sound_alias2 = sound_alias2;	
	entry.time = time;
	
	// 3D array FTW!!
	level._flyover_audio_table[source][ vehicle_type ][  level._flyover_audio_table[source][ vehicle_type ].size ] = entry;
}

main()
{
	self endon( "disconnect" );
	self endon( "death" );

	while ( 1 )
	{
		vehicles = GetVehicleArray();
		
		for ( i = 0; i < vehicles.size; i++ )
		{
			vehicle = vehicles[i];
			
			if ( IsDefined( vehicle ) && ( IS_PLANE(vehicle) || IS_4WHEEL(vehicle) ) )
			{
				// Don't play on plane that a player is in
				if ( IsDefined (self.viewlockedentity ) && vehicle == self.viewlockedentity )
					continue;
				
				if ( !IsDefined( vehicle.flyby_timeout ) )
				{
					vehicle.flyby_timeout = [];
				}
				
				if ( !IsDefined( vehicle.flyby_audio_start_delay ) )
				{
					vehicle.flyby_audio_start_delay = [];
				}
				
				if ( !IsDefined( vehicle.flyby_audio_entry ) )
				{
					vehicle.flyby_audio_entry = [];
				}
				
				// Get planes velocity				
				velocity = vehicle.velocity;
				velocity = ( velocity[0], velocity[1], 0 );
				
				// Create a line to project player position on to
				p1 = vehicle.origin;
				p1 = FLAT_ORIGIN( p1 );
				p2 = p1 + velocity * level._flyover_audio_time;
				//d = Distance( p1, p2 );
				//dir = VectorNormalize( p2 - p1 );
				
				vehicle update_flyby_audio( "primary", p1, p2, velocity );
				vehicle update_flyby_audio( "secondary", p1, p2, velocity );
			}
		}
			
		wait ( 0.05 );
	}
}
	
update_flyby_audio( source, p1, p2, velocity )
{
	if ( IsDefined( self.flyby_timeout[source] ) && self.flyby_timeout[source] > 0 )
	{
		self.flyby_timeout[source] -= 50;
		if ( self.flyby_timeout[source] < 0 )
			self.flyby_timeout[source] = 0;

		return;
	}

	t = [];
	t = circle_line_intersect( p1, p2, FLAT_ORIGIN( level.player.origin ), level._flyover_audio_radius[source] );
	
	if ( t.size < 2 )
	{
		self.flyby_audio_entry[source] = undefined;	
		return;
	}
	
	if ( t[0] < 0 || t[1] < 0 )
	{
		self.flyby_audio_entry[source] = undefined;					
		return;
	}
	
	//if ( t[0] > 1 || t[1] > 1 )
	//{
	//	vehicle.flyby_audio_entry = undefined;					
		//IPrintLnBold( "Failed: Out of Range" );						
	//	continue;
	//}
	
	t[0] = 1.0 - t[0];
	t[1] = 1.0 - t[1];
	
	time = ( ( ( t[0] + t[1] ) * 0.5 ) * level._flyover_audio_time ) * 1000;
	
	if ( time > 715 )
	{				
		// Get the best entry for this time
		bestentry = get_best_entry( source, self.vehicletype, time );
		
		// If we found an entry
		if ( IsDefined( bestentry ) )
		{		
			// Check to see if its better than the previous entry we found
			if ( IsDefined( self.flyby_audio_entry[source] ) )
			{
				if ( bestentry.time < self.flyby_audio_entry[source].time )
				{
					self.flyby_audio_entry[source] = bestentry;	
					self.flyby_audio_start_delay[source] = bestentry.time - time;	
					//IPrintLnBold( source + "Time: " + time + " BestTime: " + self.flyby_audio_entry[source].time );
				}
			}
			else
			{
				// This is our first entry
				self.flyby_audio_entry[source] = bestentry;	
				self.flyby_audio_start_delay[source] = bestentry.time - time;	
			
				
				//IPrintLnBold( source + " Time: " + time + " BestTime: " + self.flyby_audio_entry[source].time );

				/*
				Circle( FLAT_ORIGIN( level.player.origin ), level._flyover_audio_radius, ( 1, 1, 1) , false, true, 5000 );
				
				debug_p1 = FLAT_ORIGIN( vehicle.origin ) + velocity * ( t[0] * level._flyover_audio_time ); //dir * ( t[0] * d );
				debug_p2 = FLAT_ORIGIN( vehicle.origin ) + velocity * ( t[1] * level._flyover_audio_time ); //dir * ( t[1] * d );
				
				DebugStar( debug_p1, 5000, ( 0, 1, 0 ) );
				DebugStar( debug_p2, 5000, ( 1, 0, 0 ) );
					
				Line( debug_p1, debug_p2, ( 0, 0, 1 ), false, true, 5000 );
				
				dist = Distance( debug_p1, debug_p2 );
				IPrintLn( "Dist: " + dist );
				*/
			}
		}
		else
		{
			self.flyby_audio_entry[source] = undefined;
		}
	}
	
	// If we want to play something
	if ( IsDefined( self.flyby_audio_entry[source] ) )
	{
		// Count down the delay
		if ( IsDefined( self.flyby_audio_start_delay[source] ) )
		{
			self.flyby_audio_start_delay[source] -= 50;
			
			// If the delay is expired
			if ( self.flyby_audio_start_delay[source] < 0 )
			{
				// Play the sounds
				self playsound( self.flyby_audio_entry[source].sound_alias1 );	

				if ( IsDefined( self.flyby_audio_entry[source].sound_alias2 ) && self.flyby_audio_entry[source].sound_alias2 != "null" )
				{			
					self playsound ( self.flyby_audio_entry[source].sound_alias2 );
				}

				// Set the time out
				self.flyby_timeout[source] = self.flyby_audio_entry[source].time;
				self.flyby_audio_entry[source] = undefined;
			}
		}
	}
}

get_best_entry( source, vehicleType, time )
{
	entries = level._flyover_audio_table[source][ "default" ];
	if ( IsDefined( level._flyover_audio_table[source][ vehicleType ] ) )
		entries = level._flyover_audio_table[source][ vehicleType ];
	
	if ( !IsDefined( entries ) )
		return undefined;
	
	for ( i = 0; i < entries.size; i++ )
	{
		if ( time < entries[i].time )
			return entries[i];
	}
	
	return undefined;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		// start the logic
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );
	
		thread main();
	}
}

plane_position_updater( miliseconds, soundalias_1, soundalias_2 )
{
	//length of sound file to fly overhead in ms
	apex = miliseconds;
	
	//const soundid = -1;
	dx = undefined;
	last_time = undefined;
	last_pos = undefined;
	start_time = 0;
	if(!IsDefined (soundalias_1))
	{
		self.soundalias_1 = "veh_mig_flyby";		
	}
	else
	{
		self.soundalias_1 = soundalias_1;
	}
	if(!IsDefined (soundalias_2))
	{
		self.soundalias_2 = "veh_mig_flyby_lfe";			
	}
	else
	{
		self.soundalias_2 = soundalias_2;
	}
	
	while(IsDefined(self))
	{
		//setfakeentorg(0, fake_ent, plane.origin);
		
		if(/*(soundid < 0) &&*/ isdefined(last_pos)) //-- soundid was always set to -1
		{
			dx = self.origin - last_pos;
			
			if(length(dx) > .01)
			{
				velocity = dx / (GetTime()-last_time);
				assert(isdefined(velocity));
				
				players = getplayers();
				assert(isdefined(players));
				
				other_point = self.origin + (velocity * 100000);
				point = closest_point_on_line_to_point(players[0].origin, self.origin, other_point );
				assert(isdefined(point));
				
				dist = Distance( point, self.origin );	
				assert(isdefined(dist));
				
				time = dist / length(velocity);
				assert(isdefined(time));
				
				if(time < apex)
				{
					self playsound(self.soundalias_1);	
					if(self.soundalias_2 != "null")
					{			
						self playsound (self.soundalias_2);
					}
					start_time = GetTime();
					break;
				}
				
			//	println("vel:"+velocity+" pnt:"+point+" dst:"+dist+" t:"+time+"\n");
			}
	
		}
		
		last_pos = self.origin;
		last_time = GetTime();
		
		if(start_time != 0)
		{
			/#
			iprintlnbold("time: "+((GetTime()-start_time)/1000)+"\n");		
			#/
		}

					
		wait(0.1);		
		
	}
	//deletefakeent(0, fake_ent);

}

closest_point_on_line_to_point( point, lineStart, lineEnd )
{
	lineSegment = lineEnd - lineStart;
	dist = Length( lineSegment );
	
	dir = VectorNormalize( lineEnd - lineStart );
	delta = point - lineStart;
	
	t = VectorDot( delta, dir ) / dist;
	
	if ( t < 0.0 )
		return lineStart;
	else if ( t > 1.0 )
		return lineEnd;
	
	return ( lineStart + ( dir * ( t * dist ) ) );
}

circle_line_intersect( p1, p2, center, radius )
{
	t = [];
	
	d = p2 - p1;
	f = center - p2;
	
	A = VectorDot( d, d );
	B = 2 * VectorDot( f, d );
	C = VectorDot( f, f ) - ( radius * radius );
	
	discriminant = ( B * B ) - ( 4 * A * C );
	if ( discriminant > 0 )
	{
		discriminant = sqrt( discriminant );
		t[0] = (-b - discriminant)/(2*a);		
		t[1] = (-b + discriminant)/(2*a);
	}
	
	return t;
}
