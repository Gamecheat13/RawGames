#include clientscripts\_utility; 
#include clientscripts\_audio;


init()
{
	level._customVehicleCBFunc = ::vehicle_spawned_callback;
	
	level.vehicleTypeCallbackArray = [];
}

add_vehicletype_callback( vehicletype, callback )
{
	if( !IsDefined( level.vehicleTypeCallbackArray ) )
	{
		init();
	}
	
	level.vehicleTypeCallbackArray[vehicletype] = callback;
}

vehicle_spawned_callback( localClientNum )
{
	vehicletype = self.vehicletype;
	if( IsDefined( level.vehicleTypeCallbackArray[vehicletype] ) )
	{
		self thread [[level.vehicleTypeCallbackArray[vehicletype]]]( localClientNum );
	}
}

dirt_overlay_control( localClientNum )
{
	showUI( localClientNum, "fullscreen_dirt" ,1 );
	showUI( localClientNum, "fullscreen_dust" ,1 );
	self waittill( "entityshutdown" );
	showUI( localClientNum, "fullscreen_dirt" ,0 );
	showUI( localClientNum, "fullscreen_dust" ,0 );
}

dirt_surface_type( surface_type )
{
	switch( surface_type )
	{
		case "dirt":
		case "mud":
		case "gravel":
		case "grass":
		case "foliage":
		case "sand":
		case "snow":
		case "water":
			return true;	
	}
	
	return false;
}

correct_surface_type_for_screen_fx()
{
	right_rear = self GetWheelSurface("back_right");
	left_rear = self GetWheelSurface("back_left");
	
//	PrintLn("surfacetypes: " + left_rear + " " + right_rear );
	if ( dirt_surface_type( right_rear ) )
		return "dirt";
		
	if ( dirt_surface_type( left_rear ) )
		return "dirt";
		
	return "dust";
}

play_screen_fx_dirt(localClientNum)
{
	pick_one = RandomIntRange(0,4);
	if ( pick_one == 0 )
	{
		AnimateUI( localClientNum, "fullscreen_dirt", "dirt", "in", 0 );
	}
	else if ( pick_one == 1 )
	{
		AnimateUI( localClientNum, "fullscreen_dirt", "dirt_right_splash", "in", 0 );
	}
	else if ( pick_one == 2 )
	{
		AnimateUI( localClientNum, "fullscreen_dirt", "dirt_left_splash", "in", 0 );
	}
	else
	{
		AnimateUI( localClientNum, "fullscreen_dirt", "blurred_dirt_random", "in", 0 );
	}
}

play_screen_fx_dust(localClientNum)
{
	pick_one = RandomIntRange(0,4);
	if ( pick_one == 0 )
	{
		AnimateUI( localClientNum, "fullscreen_dust", "dust", "in", 0 );
	}
	else if ( pick_one == 1 )
	{
		AnimateUI( localClientNum, "fullscreen_dust", "dust_right_splash", "in", 0 );
	}
	else if ( pick_one == 2 )
	{
		AnimateUI( localClientNum, "fullscreen_dust", "dust_left_splash", "in", 0 );
	}
	else
	{
		AnimateUI( localClientNum, "fullscreen_dust", "blurred_dust_random", "in", 0 );
	}
}

play_driving_fx_firstperson( localClientNum, speed, speed_fraction )
{
	const normal_speed_fraction = 0.25;
	
	// in yo face!
	if ( speed > 0 && speed_fraction >= normal_speed_fraction )
	{
		viewangles = getlocalclientangles( localClientNum );
		pitch = angleclamp180( viewangles[0] );
		
		const max_additional_time = 1000;
		const no_effects_pitch = -10.0;		// 10 degress up, no dirt
		const full_effects_pitch = 10.0;		// 10 down, full dirt
		
		if ( pitch > no_effects_pitch )
		{
			current_additional_time = 0;
			if ( pitch < full_effects_pitch )
			{
				current_additional_time = max_additional_time * ( ( (pitch - full_effects_pitch) / ( no_effects_pitch - full_effects_pitch ) ) );
			}
			
			if ( self.last_screen_dirt + self.screen_dirt_delay + current_additional_time < getrealtime() )
			{
				screen_fx_type = self correct_surface_type_for_screen_fx();
				if ( screen_fx_type == "dirt" )
				{
					play_screen_fx_dirt( localClientNum );
				}
				else
				{
					play_screen_fx_dust( localClientNum );				
				}
				self.last_screen_dirt = getrealtime();
				self.screen_dirt_delay = RandomIntRange( 250, 500 );
			}
		}
	}
}

/* DEAD CODE REMOVAL  
play_driving_fx_thirdperson( localClientNum, speed, speed_fraction )
{
	// SP uses _treadfx.csc
}
*/

play_driving_fx( localClientNum )
{
	self endon( "entityshutdown" );

	self.last_screen_dirt = 0;
	self.screen_dirt_delay = 0;

//	self thread play_driving_screen_fx( localClientNum );

	speed_fraction = 0;
	
	while(1)
	{
		speed = self getspeed();
		maxspeed = self getmaxspeed();
		
		if ( speed < 0 )
		{
			maxspeed = self getmaxreversespeed();
		}
		
		if ( maxspeed > 0 )
		{
			speed_fraction = Abs(speed) / maxspeed;
		}
		else
		{
			speed_fraction = 0;
		}

//		PrintLn( "DRIVING SPEEDS: " + speed + " " + maxspeed + " " + speed_fraction );

		if ( self iswheelcolliding( "back_left" ) || self iswheelcolliding( "back_right" ) )
		{
			// probably need to fix this to work on spectators
			if ( self IsLocalClientDriver( localClientNum ) )
			{
				play_driving_fx_firstperson( localClientNum, speed, speed_fraction );
			}
//			else
//			{
//				play_driving_fx_thirdperson( localClientNum, speed, speed_fraction );
//			}
		}
		
		// ramp the particles up as they drive faster
//		wait(0.1 + (1.0 - speed_fraction) * 0.1);
		// or not
		wait(0.1);
	}
}

collision_thread( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_collision", hip, hitn, hit_intensity );
		
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			//println( "veh_collision " + hit_intensity );
						
			player = getlocalplayer( localClientNum );
			
			if( IsDefined( player ) )
			{
				if( hit_intensity > 15 )
				{
					//SOUND - Shawn J - impacts
					volume = get_impact_vol_from_speed();
					id = PlaySound( 0, "veh_suspension_lg_hd", self.origin, volume);
					//iprintlnbold ("vehicle hit heavy");
					
					player Earthquake( 0.5, 0.5, player.origin, 200 );
					player PlayRumbleOnEntity( localClientNum, "damage_heavy" );
				}
				else
				{
					//SOUND - Shawn J - impacts
					volume = get_impact_vol_from_speed();
					id = PlaySound( 0, "veh_suspension_lg_lt", self.origin, volume );
					//iprintlnbold ("vehicle hit light");
					
					player Earthquake( 0.3, 0.3, player.origin, 200 );
					player PlayRumbleOnEntity( localClientNum, "damage_light" );
				}
			}
		}
	}
}

jump_landing_thread( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_landed" );
		
		if ( self IsLocalClientDriver( localClientNum ) )
		{				
			player = getlocalplayer( localClientNum );
			
			if( IsDefined( player ) )
			{
				volume = get_impact_vol_from_speed();
				id = PlaySound( 0, "veh_suspension_lg_hd", self.origin, volume);
				player Earthquake( 0.7, 1.2, player.origin, 200 );
				player PlayRumbleOnEntity( localClientNum, "damage_heavy" );
			}
		}
	}
}

suspension_thread( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_suspension_limit_activated" );
		
		if ( self IsLocalClientDriver( localClientNum ) )
		{				
			player = getlocalplayer( localClientNum );
			
			if( IsDefined( player ) )
			{
				volume = get_impact_vol_from_speed();
				id = PlaySound( 0, "veh_suspension_lg_lt", self.origin, volume);
				player PlayRumbleOnEntity( localClientNum, "damage_light" );
			}
		}
	}
}
get_impact_vol_from_speed( )
{
	// values to map to a linear scale
	curspeed = self GetSpeed();
	maxSpeed = self GetMaxSpeed();

	volume = scale_speed( 0, maxSpeed, 0, 1, curspeed );
	
	volume = volume * volume * volume;

	return volume;
}