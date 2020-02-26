// _rcbomb.csc
// Sets up clientside behavior for the rcbomb

#include clientscripts\mp\_vehicle;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

main()
{
	type = "rc_car_medium_mp";

	loadTreadFx("dust");
	loadTreadFx("concrete");
	loadTreadFx("snow");
	
	level._effect["rcbomb_enemy_light"] = loadfx( "vehicle/light/fx_rcbomb_blinky_light" );
	level._effect["rcbomb_friendly_light"] = loadfx( "vehicle/light/fx_rcbomb_solid_light" );
	level._effect["rcbomb_enemy_light_blink"] = loadfx( "vehicle/light/fx_rcbomb_light_red_os" );
	level._effect["rcbomb_friendly_light_blink"] = loadfx( "vehicle/light/fx_rcbomb_light_green_os" );
	level._effect["rcbomb_stunned"] = loadfx( "weapon/grenade/fx_spark_disabled_rc_car" );

	// vehicle flags	
	level._client_flag_callbacks["vehicle"][level.const_flag_stunned] = clientscripts\mp\_callbacks::stunned_callback;
	level._client_flag_callbacks["vehicle"][level.const_flag_countdown] = ::start_blink;
	level._client_flag_callbacks["vehicle"][level.const_flag_timeout] = ::final_blink;
	
	level.rcbombSurfaceTypeForScreenFx = ::default_surface_type_for_screen_fx;
	level.rcbombSurfaceTypeForTreadFx = ::default_surface_type_for_tread_fx;
}

loadTreadFx( type )
{
	if (!IsDefined( level._effect[type] ) )
	{
		level._effect[type] = [];
	}
	
	level._effect[type]["rcbomb_driving_1st"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_first_person" );
	level._effect[type]["rcbomb_driving_slow_1st"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_slow" );
	level._effect[type]["rcbomb_driving_reverse_1st"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_reverse" );
	level._effect[type]["rcbomb_driving_trail_1st"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_trail" );
	level._effect[type]["rcbomb_sliding_1st"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_drift" );
	level._effect[type]["rcbomb_peeling_out_1st"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_peel" );

	level._effect[type]["rcbomb_driving_3rd"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type );
	level._effect[type]["rcbomb_driving_slow_3rd"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_slow" );
	level._effect[type]["rcbomb_driving_reverse_3rd"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_reverse" );
	level._effect[type]["rcbomb_driving_trail_3rd"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_trail" );
	level._effect[type]["rcbomb_sliding_3rd"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_drift" );
	level._effect[type]["rcbomb_peeling_out_3rd"] = loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_peel" );
}

spawned(localClientNum)
{
	self spawn_solid_fx( localClientNum );
	self thread check_for_time_jump( localClientNum );
	self thread blink_light(localClientNum);
	self thread cleanup_light(localClientNum);
	self thread play_driving_fx(localClientNum);
	self thread collisionHandler(localClientNum);
	self thread stunnedHandler(localClientNum);
	self thread slideHandler(localClientNum);
}

spawn_solid_fx( localClientNum )
{
	self.spawnTime = level.serverTime;
	
	if ( IsDefined( self.lightFXID ) )
	{
		stopfx(localClientNum,self.lightFXID);
		self.lightFXID = undefined;
	}
	
	if ( self friendNotFoe( localClientNum ) )
	{
		self.lightFXID = playfxontag( localClientNum, level._effect["rcbomb_friendly_light"], self, "tag_origin" );
	}
	else
	{
		self.lightFXID = playfxontag( localClientNum, level._effect["rcbomb_enemy_light"], self, "tag_origin" );
	}
}

start_blink(localClientNum, set)
{
	if (!set)
		return;
		
	self notify("blink");
}

// this second state is necessary so killcams show the appropriate "fast blink" state
final_blink(localClientNum, set)
{
	if (!set)
		return;
	
	self.interval = .133;
}

check_for_time_jump( localClientNum )
{
	self endon("entityshutdown");
	level waittill( "demo_jump" );
	
	waittillframeend;

	self thread blink_light( localClientNum );
	
	if ( isDefined( self.blinkStartTime ) && self.blinkStartTime <= level.serverTime )
	{
		self.interval = 1;
		self thread start_blink( localClientNum, true );
	}
	else
	{
		self spawn_solid_fx( localClientNum );
	}
	
	self thread check_for_time_jump( localClientNum );
}

blink_light(localClientNum)
{
	self endon("entityshutdown");
	level endon( "demo_jump" );
	self waittill("blink");
	
	if ( IsDefined( self.lightFXID ) )
	{
		stopfx(localClientNum,self.lightFXID);
		self.lightFXID = undefined;
	}
	
	if ( !isDefined( self.blinkStartTime ) )
	{
		self.blinkStartTime = level.serverTime;
	}	

	localPlayers = level.localPlayers;
	for ( localClientIndex = 0 ; localClientIndex < localPlayers.size ; localClientIndex++ )
	{
		player = localPlayers[localClientIndex];
		if ( self friendNotFoe( localClientIndex ) )
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["rcbomb_friendly_light_blink"] );
		}
		else
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["rcbomb_enemy_light_blink"] );
		}
	}
}

cleanup_light(localClientNum)
{
	self endon("entityshutdown");
	self waittill("hidden");
	self notify("stop all effects");
	if ( IsDefined( self.lightFXID ) )
	{
		stopfx(localClientNum,self.lightFXID);
		self.lightFXID = undefined;
	}
}

loop_local_sound( localClientNum, alias, interval, fx )
{
	self endon( "entityshutdown" );
	self endon( "stop all effects" );
	level endon( "demo_jump" );
	// also playing the blinking light fx with the sound

	if ( !IsDefined( self.interval ) )
	{
		self.interval = interval;
	}
	
	while(1)
	{
		self PlaySound( localClientNum, alias );
		PlayFXOnTag( localClientNum, fx, self, "tag_origin" );

		serverWait( localClientNum, self.interval );
		self.interval = (self.interval / 1.17);

		if (self.interval < .1)
		{
			self.interval = .1;
		}	
	}
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

play_screen_fx_snow(localClientNum)
{
		pick_one = RandomIntRange(0,4);
		if ( pick_one == 0 )
		{
			AnimateUI( localClientNum, "fullscreen_snow", "dirt", "in", 0 );
		}
		else if ( pick_one == 1 )
		{
			AnimateUI( localClientNum, "fullscreen_snow", "dirt_right_splash", "in", 0 );
		}
		else if ( pick_one == 2 )
		{
			AnimateUI( localClientNum, "fullscreen_snow", "dirt_left_splash", "in", 0 );
		}
		else
		{
			AnimateUI( localClientNum, "fullscreen_snow", "blurred_dirt_random", "in", 0 );
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

play_screen_fx_snow_dust(localClientNum)
{
		pick_one = RandomIntRange(0,4);
		if ( pick_one == 0 )
		{
			AnimateUI( localClientNum, "fullscreen_snow_dust", "dust", "in", 0 );
		}
		else if ( pick_one == 1 )
		{
			AnimateUI( localClientNum, "fullscreen_snow_dust", "dust_right_splash", "in", 0 );
		}
		else if ( pick_one == 2 )
		{
			AnimateUI( localClientNum, "fullscreen_snow_dust", "dust_left_splash", "in", 0 );
		}
		else
		{
			AnimateUI( localClientNum, "fullscreen_snow_dust", "blurred_dust_random", "in", 0 );
		}
}

play_driving_fx_firstperson( localClientNum, speed, speed_fraction, surf_type )
{
	play_trail = false;
	
	if ( self ispeelingout() )
	{
		play_trail = true;
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_peeling_out_1st"], self, "tag_origin" );
	}
	
	if ( self iswheelsliding( "back_left" ) || self iswheelsliding( "back_right" ))
	{
		play_trail = true;
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_sliding_1st"], self, "tag_origin" );
	}
	
	slow_speed = 5;
	normal_speed_fraction = 0.25;
	decelerating_speed_fraction = 0.4;
	decelerating_throttle_fraction = 0.25;
	throttle = self getthrottle();
	
	if ( speed < slow_speed * -1 )
	{
		PlayFXOnTag( localClientNum, level._effect[surf_type]["rcbomb_driving_reverse_1st"], self, "tag_origin" );
	}
	else if ( speed_fraction >= normal_speed_fraction && !( (speed_fraction < decelerating_speed_fraction) && (throttle < decelerating_throttle_fraction) ) )
	{
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_driving_1st"], self, "tag_origin" );
	}
	else if ( speed > slow_speed )
	{
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_driving_slow_1st"], self, "tag_origin" );
	}
	
	if ( speed_fraction >= 0.75 && speed > 0)
	{
				play_trail = true;
	}
	
	if ( play_trail )
	{
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_driving_trail_1st"], self, "tag_origin" );
	}

	// in yo face!
	if ( !IsSplitscreen() && speed > 0 && speed_fraction >= normal_speed_fraction )
	{
		viewangles = getlocalclientangles( localClientNum );
		pitch = viewangles[0];
		
		max_additional_time = 1000;
		no_effects_pitch = 40.0;
		full_effects_pitch = 20.0;
		
		if ( pitch < no_effects_pitch )
		{
			current_additional_time = 0;
			if ( pitch > full_effects_pitch )
			{
				current_additional_time = max_additional_time * ( ( (pitch - full_effects_pitch) / ( no_effects_pitch - full_effects_pitch ) ) );
			}
			
			if ( self.last_screen_dirt + self.screen_dirt_delay + current_additional_time < getrealtime() )
			{
				screen_fx_type = self [[level.rcbombSurfaceTypeForScreenFx]]();
				if ( screen_fx_type == "dirt" )
				{
					play_screen_fx_dirt( localClientNum );
				}
				else if ( screen_fx_type == "snow" )
				{
					play_screen_fx_snow( localClientNum );
				}
				else if ( screen_fx_type == "snow_dust" )
				{
					play_screen_fx_snow_dust( localClientNum );
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

play_driving_fx_thirdperson( localClientNum, speed, speed_fraction, surf_type )
{
	play_trail = false;
	
	if ( self ispeelingout() )
	{
		play_trail = true;
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_peeling_out_3rd"], self, "tag_origin" );
	}
	
	if ( self iswheelsliding( "back_left" ) || self iswheelsliding( "back_right" ))
	{
		play_trail = true;
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_sliding_3rd"], self, "tag_origin" );
	}
	
	slow_speed = 5;
	normal_speed_fraction = 0.25;
	
	if ( speed < slow_speed * -1 )
	{
		PlayFXOnTag( localClientNum, level._effect[surf_type]["rcbomb_driving_reverse_3rd"], self, "tag_origin" );
	}
	else if ( speed_fraction >= normal_speed_fraction )
	{
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_driving_3rd"], self, "tag_origin" );
	}
	else if ( speed > slow_speed )
	{
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_driving_slow_3rd"], self, "tag_origin" );
	}
		
	if ( speed_fraction >= 0.75 && speed > 0)
	{
				play_trail = true;
	}
	
	if ( play_trail )
	{
		playfxontag( localClientNum, level._effect[surf_type]["rcbomb_driving_trail_3rd"], self, "tag_origin" );
	}

}

play_driving_screen_fx( localClientNum )
{
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
		if ( self iswheelcolliding( "back_left" ) || self iswheelcolliding( "back_right" ) )
		{
			// probably need to fix this to work on spectators
			if ( self IsLocalClientDriver( localClientNum ) )
			{
			}
		}
	}
}

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

//		PrintLn( "RCBOMB SPEEDS: " + speed + " " + maxspeed + " " + speed_fraction );

		if ( self iswheelcolliding( "back_left" ) || self iswheelcolliding( "back_right" ) )
		{
			surf_type = self [[level.rcbombSurfaceTypeForTreadFx]]();
			
			if ( IsDefined( surf_type ) )
			{
//				PrintLn( "RCBOMB surface: " + surf_type ); 
				// probably need to fix this to work on spectators
				if ( self IsLocalClientDriver( localClientNum ) )
				{
					play_driving_fx_firstperson( localClientNum, speed, speed_fraction, surf_type );
				}
				else
				{
					play_driving_fx_thirdperson( localClientNum, speed, speed_fraction, surf_type );
				}
			}
		}
		
		// fixed this so we don't spawn lots of particles while the game is paused in demo playback
		serverwait(localClientNum, 0.1);
	}
}


collisionHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_collision", hip, hitn, hit_intensity );

		driver_local_client = self GetLocalClientDriver();
		
		if( IsDefined( driver_local_client ) )
		{
			//println( "veh_collision " + hit_intensity );
			player = getlocalplayer( driver_local_client );

			if( IsDefined( player ) )
			{
				// todo - play sound here also
				if( hit_intensity > 15 )
				{
					player PlayRumbleOnEntity( driver_local_client, "damage_heavy" );
				}
				else
				{
					player PlayRumbleOnEntity( driver_local_client, "damage_light" );
				}
			}
		}
	}
}

stunnedHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	self thread engineStutterHandler( localClientNum );
	
	while( 1 )
	{
		self waittill( "stunned" );
///#
//		PrintLn( "CLIENT ***************** stunned" );
//#/
	
		self setstunned( true );
		
		self thread notStunnedHandler( localClientNum );
	
		self thread play_stunned_fx_handler( localClientNum );
	}
}

notStunnedHandler( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "stunned" );
	
	self waittill( "not_stunned" );
///#
//		PrintLn( "CLIENT ***************** not stunned" );
//#/
	
	self setstunned( false );
}

play_stunned_fx_handler( localClientNum ) // self == rc car
{
	self endon( "entityshutdown" );
	self endon( "stunned" );
	self endon( "not_stunned" );

	// we need this so we can continue to play fx if being stunned by the jammer
	while( true )
	{
		playfxontag( localClientNum, level._effect["rcbomb_stunned"], self, "tag_origin" );
		wait( 0.5 );
	}
}

engineStutterHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_engine_stutter" );
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			player = getlocalplayer( localClientNum );
			
			if( IsDefined( player ) )
			{
				player PlayRumbleOnEntity( localClientNum, "rcbomb_engine_stutter" );
			}
		}
	}
}

slideHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	slide_start_time = 0;
	
	while( 1 )
	{
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			player = getlocalplayer( localClientNum );
			
			if( IsDefined( player ) )
			{
				
				if ( self ispeelingout() || (self iswheelsliding( "back_left" ) && self iswheelsliding( "back_right" )) )
				{
					if ( slide_start_time == 0 )
					{
						slide_start_time = getrealtime();
					}
					
					// want to lag the rumble a bit
					if ( slide_start_time + 200 < getrealtime() )
					{
						player PlayRumbleOnEntity( localClientNum, "rcbomb_slide" );
					}
				}	
				else 
				{
					slide_start_time = 0;
				}
			}
		}
		
		// the rumble is 0.3 secs long
		serverwait (localClientNum, 0.3);
	}
}

default_dirt_surface_type( surface_type )
{
	switch( surface_type )
	{
		case "dirt":
		case "mud":
		case "gravel":
		case "grass":
		case "foliage":
		case "sand":
		case "water":
			return true;	
	}
	
	return false;
}


default_snow_surface_type( surface_type )
{
	switch( surface_type )
	{
		case "snow":
		case "ice":
			return true;	
	}
	
	return false;
}

default_concrete_surface_type( surface_type )
{
	switch( surface_type )
	{
		case "asphalt":
		case "brick":
		case "ceramic":
		case "concrete":
		case "glass":
		case "metal":
		case "paintedmetal":
		case "plaster":
		case "rock":
		case "none":
			return true;	
	}
	
	return false;
}

snowy_level_snow_surface_type( surface_type )
{
	switch( surface_type )
	{
		case "rock":
		case "concrete":
		case "asphalt":
		case "brick":
		case "dirt":
		case "mud":
		case "gravel":
		case "grass":
		case "foliage":
		case "sand":
		case "water":
		case "snow":
		case "ice":
			return true;	
	}
	
	return false;
}

snowy_level_concrete_surface_type( surface_type )
{
	switch( surface_type )
	{
		case "ceramic":
		case "glass":
		case "metal":
		case "paintedmetal":
		case "plaster":
		case "rock":
		case "none":
			return true;	
	}
	
	return false;
}


default_surface_type_for_screen_fx()
{
	right_rear = self GetWheelSurface("back_right");
	left_rear = self GetWheelSurface("back_left");
	
//	PrintLn("surfacetypes: " + left_rear + " " + right_rear );
	if ( default_dirt_surface_type( right_rear ) )
		return "dirt";
		
	if ( default_dirt_surface_type( left_rear ) )
		return "dirt";
		
	if ( default_snow_surface_type( right_rear ) )
		return "snow";
		
	if ( default_snow_surface_type( left_rear ) )
		return "snow";
		
	return "dust";
}

default_surface_type_for_tread_fx()
{
	right_rear = self GetWheelSurface("back_right");
	left_rear = self GetWheelSurface("back_left");
	
//	PrintLn("left: " + left_rear + " right: " + right_rear );
	
	if ( default_snow_surface_type( right_rear ) || default_snow_surface_type( left_rear ) )
		return "snow";
		
	if ( default_dirt_surface_type( right_rear ) || default_dirt_surface_type( left_rear ) )
		return "dust";
		
	if ( default_concrete_surface_type( right_rear ) || default_concrete_surface_type( left_rear ) )
		return "concrete";
		
	return undefined;
}

snowy_level_surface_type_for_screen_fx()
{
	right_rear = self GetWheelSurface("back_right");
	left_rear = self GetWheelSurface("back_left");
	
//	PrintLn("surfacetypes: " + left_rear + " " + right_rear );
	if ( snowy_level_snow_surface_type( right_rear ) )
		return "snow";
		
	if ( snowy_level_snow_surface_type( left_rear ) )
		return "snow";
		
	return "snow_dust";
}


snowy_level_surface_type_for_tread_fx()
{
	right_rear = self GetWheelSurface("back_right");
	left_rear = self GetWheelSurface("back_left");
	
//	PrintLn("left: " + left_rear + " right: " + right_rear );
	
	if ( snowy_level_snow_surface_type( right_rear ) || snowy_level_snow_surface_type( left_rear ) )
		return "snow";
		
	if ( snowy_level_concrete_surface_type( right_rear ) || snowy_level_concrete_surface_type( left_rear ) )
		return "concrete";
		
	return "snow";
}


