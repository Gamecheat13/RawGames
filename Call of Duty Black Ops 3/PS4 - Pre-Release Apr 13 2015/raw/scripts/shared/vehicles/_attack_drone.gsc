    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\audio_shared;

#namespace driving_fx;

class GroundFx
{
	var id ;	
	var handle;
	
	constructor()
	{
		id = "";
		handle = -1;		
	}
	
	destructor()
	{		
	}

	function play( localClientNum, vehicle, fx_id, fx_tag )
	{
		if ( fx_id == "" )
		{
			//stop( localClientNum );
			
			if ( handle > 0 )
			{
				StopFx( localClientNum, handle );
			}
			
			id = "";
			handle = -1;			
			
			return;
		}
		
		if ( id == "" )
		{
			id = fx_id;	
			handle = PlayFxOnTag( localClientNum, id, vehicle, fx_tag );
		}
		else
		{
			if ( id != fx_id )
			{
				if ( handle > 0 )
				{
					StopFx( localClientNum, handle );
				}
				
				id = fx_id;
				handle = PlayFxOnTag( localClientNum, id, vehicle, fx_tag );
			}
		}
	}
	
	function stop( localClientNum )
	{
		if ( handle > 0 )
		{
			StopFx( localClientNum, handle );
		}
		
		id = "";
		handle = -1;
	}
}

class VehicleWheelFx
{
	var name;
	var tag_name;
	var ground_fx;
	
	constructor()
	{
		name = "";
		tag_name = "";
	}
	
	destructor()
	{		
	}	
	
	function init( _name, _tag_name )
	{
		name = _name;
		tag_name = _tag_name;
		
		ground_fx = [];
		ground_fx[ "skid" ] = new GroundFx();
		ground_fx[ "tread" ] = new GroundFx();
		
		ground_fx[ "tread" ].id = "";
		ground_fx[ "tread" ].handle = -1;		
	}
	
	function update( localClientNum, vehicle, speed_fraction )
	{
		// If we are not colliding stop all fx
		if ( !vehicle IsWheelColliding( name ) )
		{
			[[ ground_fx[ "skid" ] ]]->stop( localClientNum );
			[[ ground_fx[ "tread" ] ]]->stop( localClientNum );
			return;
		}
		
		// grab surface type
		surface = vehicle GetWheelSurface( name );
		
		origin = vehicle GetTagOrigin( tag_name ) + ( 0, 0, 1 );
		angles = vehicle GetTagAngles( tag_name );
		
		fwd = AnglesToForward( angles );
		right = AnglesToRight( angles );	
		
		rumble = false;

		if ( vehicle IsWheelPeelingOut( name ) )
		{
			peel_fx = ( isdefined( vehicle.peelfx ) ? [[vehicle.peelfx]]->get_surface_fx( surface ) : "" ); //vehicle get_wheel_fx( "peel", surface );
			
			if ( peel_fx != "" )
			{
				PlayFx( localClientNum, peel_fx, origin, fwd * -1 );
				rumble = true;	
			}
		}	

		if ( vehicle IsWheelSliding( name ) )
		{
			skid_fx = ( isdefined( vehicle.skidfx ) ? [[vehicle.skidfx]]->get_surface_fx( surface ) : "" );		//vehicle get_wheel_fx( "skid", surface );
			
			[[ ground_fx[ "skid" ] ]]->play( localClientNum, vehicle, skid_fx, tag_name );
			
			vehicle.skidding = true;
			rumble = true;				
		}
		else
		{
			[[ ground_fx[ "skid" ] ]]->stop( localClientNum );
		}
		
		if ( speed_fraction > 0.1 )
		{
			tread_fx = ( isdefined( vehicle.treadfx ) ? [[vehicle.treadfx]]->get_surface_fx( surface ) : "" ); 	//vehicle get_wheel_fx( "tread", surface );	
			
			[[ ground_fx[ "tread" ] ]]->play( localClientNum, vehicle, tread_fx, tag_name );			
		}
		else
		{
			[[ ground_fx[ "tread" ] ]]->stop( localClientNum );			
		}
		
		if ( rumble )
		{
			if ( vehicle IsLocalClientDriver( localClientNum ) )
			{
				player = GetLocalPlayer( localClientNum );	
				player PlayRumbleOnEntity( localClientNum, "reload_small" );
			}
		}
	}
}

class vehicle_camera_fx
{
	var	quake_time_min;
	var	quake_time_max;		
	var	quake_strength_min;			
	var	quake_strength_max;	
	var rumble_name;	
	
	constructor()
	{
		quake_time_min = 0.5;
		quake_time_max = 1.0;		
		quake_strength_min = 0.1;			
		quake_strength_max = 0.115;		
		rumble_name = "";
	}
	
	destructor()
	{
	}
	
	function init( t_min, t_max, s_min, s_max, rumble = "" )
	{
		quake_time_min = t_min;
		quake_time_max = t_max;		
		quake_strength_min = s_min;			
		quake_strength_max = s_max;	
		rumble_name = ( rumble != "" ? rumble : rumble_name );
	}
	
	function update( localClientNum, vehicle, speed_fraction )
	{
		if ( vehicle IsLocalClientDriver( localClientNum ) )
		{
			player = getlocalplayer( localClientNum );
			
			if ( speed_fraction > 0 ) 
			{
				strength = RandomFloatRange( quake_strength_min, quake_strength_max ) * speed_fraction;
				time = RandomFloatRange( quake_time_min, quake_time_max );
	
				player Earthquake( strength, time, player.origin, 500 );	
				
				if ( rumble_name != "" && speed_fraction > 0.5 )
				{
					if ( RandomInt( 100 ) < 10 )
					{
						player PlayRumbleOnEntity( localClientNum, rumble_name );
					}
				}
			}
		}
	}
}

/* DEAD CODE REMOVAL  
function play_driving_fx_thirdperson( localClientNum, speed, speed_fraction )
{
	// SP uses _treadfx.csc
}
*/

function vehicle_enter( localClientNum )
{
	self endon( "entityshutdown" );
	
	while ( 1 )
	{
		self waittill( "enter_vehicle", user );

		if ( isdefined( user ) && user isplayer() )
		{
			self thread driving_fx::collision_thread( localClientNum );
			self thread driving_fx::jump_landing_thread( localClientNum );
//			self thread driving_fx::speed_fx( localClientNum );
		}
	}
}

function speed_fx( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "exit_vehicle" );
	
	while ( 1 )
	{
		curspeed = self GetSpeed();
		curspeed = 0.0005 * curspeed;
		curspeed = Abs(curspeed);
		if (curspeed>0.001)
		{
			SetSavedDvar("r_speedBlurFX_enable","1");
		        SetSavedDvar("r_speedBlurAmount",curspeed);
	      	}
		else
		{
	         	SetSavedDvar("r_speedBlurFX_enable","0");
		}
		wait 0.05;
	}
}

function play_driving_fx( localClientNum )
{
	self endon( "entityshutdown" );
	
	self thread vehicle_enter( localClientNum );
	
	if ( self.surfacefxdeftype == "" )
		return;

	if ( !isdefined( self.wheel_fx ) )
	{
		wheel_names = array( "front_left", "front_right", "back_left", "back_right" );
		wheel_tag_names = array( "tag_wheel_front_left", "tag_wheel_front_right", "tag_wheel_back_left", "tag_wheel_back_right" );
		
		// temp hack for RAPS vehicle
		if( isdefined( self.scriptvehicletype ) && self.scriptvehicletype == "raps" )
		{
			wheel_names = array( "front_left" );
			wheel_tag_names = array( "tag_origin" );
		}
		
		self.wheel_fx = [];
		for ( i = 0; i < wheel_names.size; i++ )
		{
			self.wheel_fx[i] = new VehicleWheelFx();
			[[ self.wheel_fx[i] ]]->init( wheel_names[i], wheel_tag_names[i] );
		}
		
		self.camera_fx = [];		
		self.camera_fx[ "speed" ] = new vehicle_camera_fx();
		[[ self.camera_fx[ "speed" ] ]]->init( 0.5, 1.0, 0.1, 0.115, "reload_small" );
		
		self.camera_fx[ "skid" ] = new vehicle_camera_fx();	
		[[ self.camera_fx[ "skid" ] ]]->init( 0.25, 0.35, 0.1, 0.115 );
	}
	
	self.last_screen_dirt = 0;
	self.screen_dirt_delay = 0;

	speed_fraction = 0;
	
	while ( 1 )
	{
		speed = Length( self GetVelocity() );
		max_speed = (  speed < 0 ? self GetMaxReverseSpeed() : self GetMaxSpeed() );
		speed_fraction = ( max_speed > 0 ? Abs(speed) / max_speed : 0 );
		
		self.skidding = false;
			
		for ( i = 0; i < self.wheel_fx.size; i++ )
		{
			[[ self.wheel_fx[i] ]]->update( localClientNum, self, speed_fraction );
		}
		
//		[[ self.camera_fx[ "speed" ] ]]->update( localClientNum, self, speed_fraction );
//		
//		if ( self.skidding )
//		{
//			[[ self.camera_fx[ "skid" ] ]]->update( localClientNum, self, ( speed_fraction < 0.25 ? 0.25 : 1 ) );
//		}
		
		wait( 0.1 );
	}
}

function get_wheel_fx( type, surface )
{
	if ( type == "tread" )
	{
		return ( isdefined( self.treadfx ) ? [[self.treadfx]]->get_surface_fx( surface ) : "" );
	}
	else if ( type == "peel" )
	{
		return ( isdefined( self.peelfx ) ? [[self.peelfx]]->get_surface_fx( surface ) : "" );
	}
	else if ( type == "skid" )
	{
		return ( isdefined( self.skidfx ) ? [[self.skidfx]]->get_surface_fx( surface ) : "" );		
	}
	
	return "";
}

function play_driving_fx_firstperson( localClientNum, speed, speed_fraction )
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

function collision_thread( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "exit_vehicle" );
	
	while( 1 )
	{
		self waittill( "veh_collision", hip, hitn, hit_intensity );
		
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			//println( "veh_collision " + hit_intensity );
						
			player = getlocalplayer( localClientNum );
			
			if ( isdefined( self.driving_fx_collision_override ) )
			{
				self [[ self.driving_fx_collision_override ]]( localClientNum, player, hip, hitn, hit_intensity );
			}
			else
			{
				if( isdefined( player ) && isdefined( hit_intensity ) )
				{
					if( hit_intensity > self.heavyCollisionSpeed )
					{
						volume = get_impact_vol_from_speed();
						
						if (isdefined (self.sounddef))
						{
							alias = self.sounddef + "_suspension_lg_hd";
						}
						else
						{
							alias = "veh_default_suspension_lg_hd";
						}
						
						id = PlaySound( 0, alias, self.origin, volume);
						
						if( isdefined( self.heavyCollisionRumble ) )
						{
							player PlayRumbleOnEntity( localClientNum, self.heavyCollisionRumble );
						}
					}
					else if( hit_intensity > self.lightCollisionSpeed )
					{
						volume = get_impact_vol_from_speed();
	
						if (isdefined (self.sounddef))
						{
							alias = self.sounddef + "_suspension_lg_lt";
						}
						else
						{
							alias = "veh_default_suspension_lg_lt";
						}					
	
						id = PlaySound( 0, alias, self.origin, volume );
						
						if( isdefined( self.lightCollisionRumble ) )
						{
							player PlayRumbleOnEntity( localClientNum, self.lightCollisionRumble );
						}
					}
				}
			}
		}
	}
}

function jump_landing_thread( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "exit_vehicle" );
	
	while( 1 )
	{
		self waittill( "veh_landed" );
		
		if ( self IsLocalClientDriver( localClientNum ) )
		{				
			player = getlocalplayer( localClientNum );

			if( isdefined( player ) )
			{
				if ( isdefined( self.driving_fx_jump_landing_override ) )
				{
					self [[ self.driving_fx_jump_landing_override ]]( localClientNum, player );
				}
				else
				{
					volume = get_impact_vol_from_speed();
	
					if (isdefined (self.sounddef))
					{
						alias = self.sounddef + "_suspension_lg_hd";
					}
					else
					{
						alias = "veh_default_suspension_lg_hd";
					}					
	
					id = PlaySound( 0, alias, self.origin, volume);
					if( isdefined( self.jumpLandingRumble ) )
					{
						player PlayRumbleOnEntity( localClientNum, self.jumpLandingRumble );
					}
				}
			}
		}
	}
}

function suspension_thread( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "exit_vehicle" );
	
	while( 1 )
	{
		self waittill( "veh_suspension_limit_activated" );
		
		if ( self IsLocalClientDriver( localClientNum ) )
		{				
			player = getlocalplayer( localClientNum );
			
			if( isdefined( player ) )
			{
				volume = get_impact_vol_from_speed();

				if (isdefined (self.sounddef))
				{
					alias = self.sounddef + "_suspension_lg_lt";
				}
				else
				{
					alias = "veh_default_suspension_lg_lt";
				}
				
				id = PlaySound( 0, alias, self.origin, volume);
				player PlayRumbleOnEntity( localClientNum, "damage_light" );
			}
		}
	}
}
function get_impact_vol_from_speed( )
{
	// values to map to a linear scale
	curspeed = self GetSpeed();
	maxSpeed = self GetMaxSpeed();

	volume = audio::scale_speed( 0, maxSpeed, 0, 1, curspeed );
	
	volume = volume * volume * volume;

	return volume;
}

function any_wheel_colliding()
{
	return ( self iswheelcolliding( "front_left" ) || self iswheelcolliding( "front_right" ) || 
	         self iswheelcolliding( "back_left" ) || self iswheelcolliding( "back_right" ) );
}

function dirt_surface_type( surface_type )
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

function correct_surface_type_for_screen_fx()
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

function play_screen_fx_dirt(localClientNum)
{
	// support for this has been removed with the .menu system
	/*
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
	*/
}

function play_screen_fx_dust(localClientNum)
{
	// support for this has been removed with the .menu system
	/*
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
	*/
}
