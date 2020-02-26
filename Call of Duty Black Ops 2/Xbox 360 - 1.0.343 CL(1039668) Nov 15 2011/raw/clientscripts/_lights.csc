#include clientscripts\_utility;

set_light_color(light_struct, col)
{
	light_struct.light_color = col;
	
	if((self.mixer.active == 0) && (self.mixer.mix_pos == light_struct.side))
	{
		for(i = 0; i < level.max_local_clients; i ++)
		{
			if(LocalClientActive(i) && isdefined(self.lights[i]))
			{
				self.lights[i] SetLightColor(col);
			}
		}		
	}
}

set_light_intensity(light_struct, intensity)
{
//	PrintLn("**** sli " + intensity);
	if((light_struct.light_intensity > 0.05) && (intensity <= 0.05))
	{
		set_light_notify(light_struct, "off");
	}
	else if((light_struct.light_intensity) <= 0.05 && (intensity > 0.05))
	{
		set_light_notify(light_struct, "on");
	}
	
	intensity = Max(0, intensity);
	
	light_struct.light_intensity = intensity;
	
	if((self.mixer.active == 0) && (self.mixer.mix_val == light_struct.side))
	{
		for(i = 0; i < level.max_local_clients; i ++)
		{
			if(LocalClientActive(i) && isdefined(self.lights[i]))
			{
				self.lights[i] SetLightIntensity(intensity);
			}
		}		
	}	
}

set_light_radius(light_struct, rad)
{
	light_struct.light_radius = rad;
	
	if((self.mixer.active == 0) && (self.mixer.mix_val == light_struct.side))
	{
		for(i = 0; i < level.max_local_clients; i ++)
		{
			if(LocalClientActive(i) && isdefined(self.lights[i]))
			{
				self.lights[i] SetLightRadius(rad);
			}
		}		
	}	
}

set_light_inner_fov(light_struct, inner)
{
	light_struct.light_inner_fov = inner;
	
	if((self.mixer.active == 0) && (self.mixer.mix_val == light_struct.side))
	{
		for(i = 0; i < level.max_local_clients; i ++)
		{
			if(LocalClientActive(i) && isdefined(self.lights[i]))
			{
				self.lights[i] SetLightFovRange(light_struct.light_inner_fov, light_struct.light_outer_fov);
			}
		}		
	}		
}

set_light_outer_fov(light_struct, outer)
{
	light_struct.light_outer_fov = outer;
	
	if((self.mixer.active == 0) && (self.mixer.mix_val == light_struct.side))
	{
		for(i = 0; i < level.max_local_clients; i ++)
		{
			if(LocalClientActive(i) && isdefined(self.lights[i]))
			{
				self.lights[i] SetLightFovRange(light_struct.light_inner_fov, light_struct.light_outer_fov);
			}
		}		
	}			
}

set_light_exponent(light_struct, exp)
{
	light_struct.light_exponent = exp;
	
	if((self.mixer.active == 0) && (self.mixer.mix_val == light_struct.side))
	{
		for(i = 0; i < level.max_local_clients; i ++)
		{
			if(LocalClientActive(i) && isdefined(self.lights[i]))
			{
				self.lights[i] SetLightExponent(exp);	
			}
		}		
	}				
}

set_light_notify(light_struct, name)
{
	light_struct.light_notify = name;
	
//	PrintLn("*** set_light_notify("+name+")");
	
	if(IsDefined(self.light_models))
	{
//		PrintLn("*** Got light models.");

		if((self.mixer.mix_pos == light_struct.side))
		{

//			PrintLn("*** Mixer right side..");

			for(i = 0; i < level.max_local_clients; i ++)
			{
				if(IsDefined(self.light_models[i]))
				{
					self.light_models[i] notify(name);
				}
			}
			self.mixer.last_sent_notify = name;
		}
	}
}

play_light_sound(light_struct, sound)
{
	if((self.mixer.active == 0) && (self.mixer.mix_val == light_struct.side))
	{
		PlaySound(0, sound , self.origin);
	}
}

play_light_fx(light_struct, fx)
{
	if(!IsDefined(level._effect[fx]))
		return;
	
	if((self.mixer.active == 0) && (self.mixer.mix_val == light_struct.side))
	{
		players = level.localPlayers;
		
		org = self.origin;
		off = (0,0,0);	

		if(IsDefined(self.light_models) && IsDefined(self.light_models[0]))
		{
			org = self.light_models[0].origin;

			if(IsDefined(self.script_light_fx_offset))
			{
				atf = AnglesToForward(self.light_models[0].angles);
				atr = AnglesToRight(self.light_models[0].angles);
				atu = AnglesToUp(self.light_models[0].angles);
				
				o = self.script_light_fx_offset;
				
				off = (	(atf[0] * o[0]) + (atf[1] * o[0]) + (atf[2] * o[0]),
								(atr[0] * o[1]) + (atr[1] * o[1]) + (atr[2] * o[1]),
								(atu[0] * o[2]) + (atu[1] * o[2]) + (atu[2] * o[2]));
			}				
		}
		else
		{
			if(IsDefined(self.script_light_fx_offset))
			{
				off = self.script_light_fx_offset;
			}
		}			
		
		for(i = 0; i < players.size; i ++)
		{
			PlayFX(i, level._effect[fx], org + off);
		}
	}
}

add_light(clientNum)
{
	light = spawn(clientNum, self.origin);
	light makelight(self.pl);
//	light.angles = self.angles;
	
	if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		light setLightIntensity( 0 );
	}
	
	return(light);
}

rotate_light_yaw()
{
	while(1)
	{
		for(i = 0; i < self.lights.size; i ++)
		{
			if(IsDefined(self.lights[i]))
			{
				self.lights[i] RotateYaw(360, self.script_light_rotate_yaw);
			}
		}
		
		self.lights[0] waittill("rotatedone");
		
	}
}

create_lights(clientNum)
{
	if(!isdefined(self.lights))
	{
		self.lights = [];
	}
	
	self.lights[clientNum] = self add_light(clientNum);
	
	if(0 == clientNum && IsDefined(self.script_light_rotate_yaw))
	{
		self thread rotate_light_yaw();
	}
	
	// If we're tagged to send notifies to a light model in the world...
	// Find the model entity, and cache in it self.light_models.
	
	if(isdefined(self.script_light_model) && IsDefined(self.script_light_on_model) && IsDefined(self.script_light_off_model))
	{
//		PrintLn("**** Trying to find light model " + self.script_light_model);
		ent = getent(clientNum, self.script_light_model, "targetname");
		
		if(isdefined(ent))
		{
			if(!isdefined(self.light_models))
			{
				self.light_models = [];
			}
			
//			PrintLn("**** Added model to self.light_models");
			
			while(!IsDefined(self.lights[0]))
			{
				wait(0.1);
			}
			
			self.light_models[clientNum] = ent;
			self.light_models[clientNum] thread light_model_switch(clientNum, "on", self.script_light_on_model, self.lights[0], self.script_light_on_spin_model, self.script_light_spin_fx, self.script_light_spin_tag);
			self.light_models[clientNum] thread light_model_switch(clientNum, "off", self.script_light_off_model, self.lights[0], self.script_light_off_spin_model);
		}
	}
}

light_off(light_struct)
{
	set_light_color(light_struct, (0,0,0));
	set_light_intensity(light_struct, 0);
//	set_light_notify( light_struct, "off");
	
	level waittill("eternity");		// put thread to sleep - buhbye....
}

light_solid(light_struct)
{
	set_light_notify( light_struct, "on");
	level waittill("eternity");	// put thread to sleep - buhbye....
}

generic_pulsing(light_struct)
{

	on = light_struct.light_intensity;
	const off = .05;
	curr = on;
	const transition_on = .3;
	const transition_off = .3;
	increment_on = ( on - off ) / ( transition_on / .05 );
	increment_off = ( on - off ) / ( transition_off / .05 );
	
	for ( ;; )
	{
		//ramp down
		time = 0;
		while ( ( time < transition_off ) )
		{
			curr -= increment_off;
			set_light_intensity( light_struct, curr );
			time += .05;
			wait( .05 );
		}
		
		//off wait time
		wait( 0.25 );
		
		if(IsDefined(light_struct.script_light_fx))
		{
			play_light_fx(light_struct, light_struct.script_light_fx);
		}
		
		//ramp up
		time = 0;
		while ( time < transition_on )
		{
			curr += increment_on;
			set_light_intensity( light_struct, curr );
			time += .05;
			wait( .05 );
		}
		
		//on wait time
		wait( .75 );
	}		
}

generic_double_strobe(light_struct)
{
	on = light_struct.light_intensity;
	const off = 0;
	
	for ( ;; )
	{
		//off wait time
		set_light_intensity(light_struct, off);

		wait( .1 );
		
		//first flash
		set_light_intensity(light_struct, on);

		wait( .05 );
		
		//pause
		set_light_intensity(light_struct, off);

		wait( .1 );
		
		//second flash
		set_light_intensity(light_struct, on);

		wait( .05 );
	}	
}

generic_strobe(light_struct)
{
	min_flickerless_time = 0.1;

  if( IsDefined( light_struct.script_light_wait_min ) )
  {
  	min_flickerless_time = light_struct.script_light_wait_min;
  }
  else
  {
  	//iprintlnBold( "script_light_wait_min undefined" );
  }
	//iprintlnbold( "script_light_wait_min: " + min_flickerless_time );
	

	
	max_flickerless_time = 0.1;
               
  if( IsDefined( light_struct.script_light_wait_max ) )
  {
  	max_flickerless_time = light_struct.script_light_wait_max;
  }

	//iprintlnbold( "script_light_wait_max: " + max_flickerless_time );
	
	on = light_struct.light_intensity;
	const off = 0;
	
	for ( ;; )
	{
		//off wait time
		set_light_intensity(light_struct, off);

		wait( min_flickerless_time );
		
		//first flash
		set_light_intensity(light_struct, on);
		
		wait( max_flickerless_time );
	}	
}



// modified version of _lights::burning_trash_fire()
ber3b_firelight(light_struct)
{

	full = light_struct.light_intensity;
	
	old_intensity = full;
	
	while( 1 )
	{
		intensity = RandomFloatRange( full * 0.63, full * 1.2 );
		// old values = 6, 12
		timer = RandomFloatRange( 2, 5 );

		for ( i = 0; i < timer; i ++ )
		{
			new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
			
			set_light_intensity( light_struct, new_intensity );
			wait( 0.05 );
		}
		
		old_intensity = intensity;
	}	
}

generic_flickering(light_struct)
{
	if( IsDefined( light_struct.script_wait_min ) )
	{
		min_flickerless_time = light_struct.script_wait_min;
	}
	else
	{
		min_flickerless_time = 0.2;
	}
	
	if( IsDefined( light_struct.script_wait_max ) )
	{
		max_flickerless_time = light_struct.script_wait_max;
	}
	else
	{
		max_flickerless_time = 1.5;
	}
	
	if( IsDefined( light_struct.script_delay_min ) )
	{
		min_flicker_delay = light_struct.script_delay_min;
	}
	else
	{
		min_flicker_delay = 0.05;		
	}
	
	if( IsDefined( light_struct.script_delay_max ) )
	{
		max_flicker_delay = light_struct.script_delay_max;
	}
	else
	{
		max_flicker_delay = 0.1;
	}
	
	if( IsDefined( light_struct.script_intensity_min ) )
	{
		min_intensity = light_struct.script_intensity_min;
	}
	else
	{
		min_intensity = 0;
	}

	if( IsDefined( light_struct.script_intensity_max ) )
	{
		max_intensity = light_struct.script_intensity_max;
	}
	else
	{
		max_intensity = 0.3;
	}
	
	if( IsDefined( light_struct.script_burst_min ) )
	{
		min_burst = light_struct.script_burst_min;
	}
	else
	{
		min_burst = 1;
	}

	if( IsDefined( light_struct.script_burst_max ) )
	{
		max_burst = light_struct.script_burst_max;
	}
	else
	{
		max_burst = 10;
	}
	
	on = light_struct.light_intensity;
	const off = 0;
	curr = on;
	num = 0;
			
	for( ;; )
	{
		num = RandomIntRange( min_burst, max_burst );
		while( num )
		{
			wait( RandomFloatRange( min_flicker_delay, max_flicker_delay ) );
			if( curr > ( on * 0.5 ) )
			{
				curr = RandomFloatRange( min_intensity, max_intensity );
			}
			else
			{
				curr = on;
			}
					
			set_light_intensity(light_struct, curr);
			num--;			
		}
		
		set_light_intensity(light_struct, on);

		wait( RandomFloatRange( min_flickerless_time, max_flickerless_time ) );
	}		
}

fade_off_burst_intensity(light_struct, burst_intensity, min_intensity, fade_duration)
{
	min_intensity = Min(burst_intensity, min_intensity);
	max_intensity = Max(burst_intensity, min_intensity);
	
	fade_duration = fade_duration / 20;	// animate fade down at 20fps
	
	step = (max_intensity - min_intensity) * fade_duration;
	
	while(burst_intensity > min_intensity)
	{
		burst_intensity -= step;
		set_light_intensity(light_struct, burst_intensity);
		wait(0.05);
	}
}

explode_then_flicker(light_struct)
{
	min_delay = 0.1;
	max_delay = 0.2;
	
	if( IsDefined( light_struct.script_delay_min ) )
	{
		min_delay = light_struct.script_delay_min;
	}

	if( IsDefined( light_struct.script_delay_max ) )
	{
		max_delay = light_struct.script_delay_max;
	}

	min_intensity = 0.5;
	max_intensity = 1;
	if( IsDefined( light_struct.script_intensity_min ) )
	{
		min_intensity = light_struct.script_intensity_min;
	}

	if( IsDefined( light_struct.script_intensity_max ) )
	{
		max_intensity = light_struct.script_intensity_max;
	}

	burst_time = 2.0;
	if(IsDefined(light_struct.script_burst_time))
	{
		burst_time = light_struct.script_burst_time;
	}
	
	fade_duration = 1.0;
	if(IsDefined(light_struct.script_fade_duration))
	{
		fade_duration = light_struct.script_fade_duration;
	}

	burst_intensity = 0.8;
	if(IsDefined(light_struct.script_burst_intensity))
	{
		burst_intensity = light_struct.script_burst_intensity;
	}

	intensity = light_struct.light_intensity; 
	curr_intensity = intensity;

	set_light_intensity(light_struct, burst_intensity);
	
	light_struct waittill("light_activated");	// Sent by the mixer when slider reaches this side.
	
	wait(burst_time);
	
	fade_off_burst_intensity(light_struct, burst_intensity, min_intensity, fade_duration);

	waitrealtime(0.016 * (light_struct.light_id % 3));
	
	for( ;; )
	{
		temp_intensity = intensity * RandomFloatRange( min_intensity, max_intensity ); 
		time = RandomFloatRange( min_delay, max_delay ); 
		time = Max(time, 0.016);	// Deal with potential divide by 0.
		steps = time * 20; 
		div = ( curr_intensity - temp_intensity ) / steps; 

		for( i = 0; i < steps; i++ )
		{
			curr_intensity -= div;

			if( curr_intensity < 0 )
			{
				curr_intensity = 0;
			}

			set_light_intensity(light_struct, curr_intensity ); 
			waitrealtime( 0.05 ); 
		}
		
		if(isdefined(light_struct.script_light_sound))
		{
			play_light_sound(light_struct, light_struct.script_light_sound);
		}

		curr_intensity = temp_intensity; 
	}		
}

flicker_killer(light_struct, delay)
{
	light_struct waittill("activated");
	wait(delay);
	light_struct notify("kill_flicker");
	set_light_intensity( light_struct, 0 ); 
}

fire_flicker_then_stop(light_struct)
{
	light_struct endon("kill_flicker");
	min_delay = 0.1;
	max_delay = 0.2;
	
	if( IsDefined( light_struct.script_delay_min ) )
	{
		min_delay = light_struct.script_delay_min;
	}

	if( IsDefined( light_struct.script_delay_max ) )
	{
		max_delay = light_struct.script_delay_max;
	}

	min_intensity = 0.5;
	max_intensity = 1;
	if( IsDefined( light_struct.script_intensity_min ) )
	{
		min_intensity = light_struct.script_intensity_min;
	}

	if( IsDefined( light_struct.script_intensity_max ) )
	{
		max_intensity = light_struct.script_intensity_max;
	}

	burst_time = 2.0;
	if(IsDefined(light_struct.script_burst_time))
	{
		burst_time = light_struct.script_burst_time;
	}

	self thread flicker_killer(light_struct, burst_time);

	intensity = light_struct.light_intensity; 
	curr_intensity = intensity;

	waitrealtime(0.016 * (light_struct.light_id % 3));
	
	for( ;; )
	{
		temp_intensity = intensity * RandomFloatRange( min_intensity, max_intensity ); 
		time = RandomFloatRange( min_delay, max_delay ); 
		time = Max(time, 0.016);	// Deal with potential divide by 0.
		steps = time * 20; 
		div = ( curr_intensity - temp_intensity ) / steps; 

		for( i = 0; i < steps; i++ )
		{
			curr_intensity -= div;

			if( curr_intensity < 0 )
			{
				curr_intensity = 0;
			}

			set_light_intensity( light_struct, curr_intensity ); 
			wait( 0.05 ); 
		}
		
		if(isdefined(light_struct.script_light_sound))
		{
			play_light_sound(light_struct, light_struct.script_light_sound);
		}

		curr_intensity = temp_intensity; 
	}	
}

electrical_flicker(light_struct)
{
	min_delay = 0.02;
	max_delay = 0.1;
	
	if( IsDefined( light_struct.script_delay_min ) )
	{
		min_delay = light_struct.script_delay_min;
	}

	if( IsDefined( light_struct.script_delay_max ) )
	{
		max_delay = light_struct.script_delay_max;
	}

	min_intensity = 0.25;
	max_intensity = 1;
	if( IsDefined( light_struct.script_intensity_min ) )
	{
		min_intensity = light_struct.script_intensity_min;
	}

	if( IsDefined( light_struct.script_intensity_max ) )
	{
		max_intensity = light_struct.script_intensity_max;
	}

	intensity = light_struct.light_intensity; 
	curr_intensity = intensity;

	waitrealtime(0.016 * (light_struct.light_id % 3));
	
	//waitforclient( 0 );
	//player = getlocalplayer( 0 );
	
	for( ;; )
	{
		while( !ClientHasSnapshot(0) || DistanceSquared( self.origin, getlocalplayer(0).origin ) > 2250000 )
		{
			wait( 2.0 );
		}
	
		temp_intensity = intensity * RandomFloatRange( min_intensity, max_intensity ); 
		time = RandomFloatRange( min_delay, max_delay ); 
		time = Max(time, 0.016);	// Deal with potential divide by 0.
		steps = time * 20; 
		div = ( curr_intensity - temp_intensity ) / steps; 

		for( i = 0; i < steps; i++ )
		{
			curr_intensity -= div;

			if( curr_intensity < 0 )
			{
				curr_intensity = 0;
			}

			set_light_intensity( light_struct, curr_intensity ); 
			wait( 0.05 ); 
		}
		
		if(isdefined(light_struct.script_light_sound))
		{
			play_light_sound(light_struct, light_struct.script_light_sound);
		}

		curr_intensity = temp_intensity; 
	}	

}

fire_flicker(light_struct)
{
	min_delay = 0.1;
	max_delay = 0.2;
	
	if( IsDefined( light_struct.script_delay_min ) )
	{
		min_delay = light_struct.script_delay_min;
	}

	if( IsDefined( light_struct.script_delay_max ) )
	{
		max_delay = light_struct.script_delay_max;
	}

	min_intensity = 0.5;
	max_intensity = 1;
	if( IsDefined( light_struct.script_intensity_min ) )
	{
		min_intensity = light_struct.script_intensity_min;
	}

	if( IsDefined( light_struct.script_intensity_max ) )
	{
		max_intensity = light_struct.script_intensity_max;
	}

	intensity = light_struct.light_intensity; 
	curr_intensity = intensity;

	waitrealtime(0.016 * (light_struct.light_id % 3));
	
	//waitforclient( 0 );
	//player = getlocalplayer( 0 );
	
	check_range = true;

	if(isdefined(self.script_light_no_range_check))
	{
		check_range = false;	
	}

	for( ;; )
	{
		if(check_range)
		{
			while( !ClientHasSnapshot(0) || DistanceSquared( self.origin, getlocalplayer(0).origin ) > 2250000 )
			{
				wait( 2.0 );
			}
		}
		else
		{
			while( !ClientHasSnapshot(0))
			{
				wait( 2.0 );
			}
		}
	
		temp_intensity = intensity * RandomFloatRange( min_intensity, max_intensity ); 
		time = RandomFloatRange( min_delay, max_delay ); 
		time = Max(time, 0.016);	// Deal with potential divide by 0.
		steps = time * 20; 
		
		div = ( curr_intensity - temp_intensity ) / steps; 

		for( i = 0; i < steps; i++ )
		{
			curr_intensity -= div;

			if( curr_intensity < 0 )
			{
				curr_intensity = 0;
			}

			set_light_intensity( light_struct, curr_intensity ); 
			wait( 0.05 ); 
		}
		
		if(isdefined(light_struct.script_light_sound))
		{
			play_light_sound(light_struct, light_struct.script_light_sound);
		}

		curr_intensity = temp_intensity; 
	}	

}

television(light_struct)
{
	self thread tv_changes_intensity(light_struct);
	self thread tv_changes_color(light_struct);
}

tv_changes_intensity(light_struct)
{
	full = light_struct.light_intensity;
	old_intensity = full;

	for ( ;; )
	{
		intensity = randomfloatrange( full * 0.7, full * 1.2 );
		timer = randomfloatrange( 0.3, 1.2 );
		timer *= 20;

		for ( i = 0; i < timer; i ++ )
		{
			new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
			
			set_light_intensity(light_struct,  new_intensity );
			wait( 0.05 );
		}
		
		old_intensity = intensity;
	}	
}

tv_changes_color(light_struct)
{
	const range = 0.5;
	const base = 0.5;
	rgb = [];
	old_rgb = [];

	for ( i = 0; i < 3; i++ )
	{
		rgb[ i ] = 0;
		old_rgb[ i ] = 0;
	}
	
	for ( ;; )
	{
		for ( i = 0; i < rgb.size; i++ )
		{
			old_rgb[ i ] = rgb[ i ];
			rgb[ i ] = randomfloat( range ) + base;
		}

		timer = randomfloatrange( 0.3, 1.2 );
		timer *= 20;

		for( i = 0; i < timer; i ++ )
		{
			new_rgb = [];
			for ( p = 0; p < rgb.size; p++ )
			{
				new_rgb[ p ] = rgb[ p ] * ( i / timer ) + old_rgb[ p ] * ( ( timer - i ) / timer );
			}

			set_light_color( light_struct, ( new_rgb[ 0 ], new_rgb[ 1 ], new_rgb[ 2 ] ) );
			wait( 0.05 );
		}
	}	
}

triggered_lights_think(light_struct)
{
	if(!isDefined(self.script_noteworthy))
		return;
		
	level waittill( self.script_noteworthy );	// power lights on

	// Turn the lights on
	if ( IsDefined( self.script_float ) )
	{
		set_light_intensity( light_struct, self.script_float );
	}
	else
	{
		set_light_intensity( light_struct, 1.5 );
	}	
}

mixer_get_ramp()
{
	if(self.mixer.mix_pos == 0)	// We're set left, we're travelling right
	{
		return self.mixer.right_to_left_ramp;
	}
	else	// We're set right, we're travelling left.
	{
		return self.mixer.left_to_right_ramp;
	}
}

debug_draw_mixer()
{
	/#
	if(GetDvar("debug_light_mixers") != "")
	{	
		const debug_width = 24;
		
		left_pos = self.origin - (debug_width/2,0,0);
		right_pos = self.origin + (debug_width/2,0,0);
		
		while(1)
		{
			slider_pos = left_pos + (debug_width * self.mixer.mix_val,0,0);
			
			line(left_pos, right_pos);
			line(left_pos, left_pos + (0,0,1));
			line(right_pos, right_pos + (0,0,1));
			
			line(slider_pos, slider_pos + (0,0,2), (1,0,0));
			wait(0.01);
		}
	}
	#/
}

switch_light_once_only()
{
	if(self.script_light_onetime == 1)
	{
		self.script_light_onetime = -1;
		return true;
	}
	
	return false;
}

mixer_level_activate()
{
	if(!isdefined(self.script_mixer_event))
	{
		return;
	}
	
	while(1)
	{
		level waittill(self.script_mixer_event);
		if(self.script_light_onetime >= 0)
		{
			self.mixer_activated = 1;
			//println("Mixer level activate.");
		}
		else
		{
			return;
		}

		if(switch_light_once_only())
		{
			return;
		}		
	}
}

mixer_self_activate()
{
	if(!isdefined(self.script_mixer_event))
	{
		return;
	}
	
	while(1)
	{
		self waittill(self.script_mixer_event);
		if(self.script_light_onetime >= 0)
		{
			self.mixer_activated = 1;
			//println("Mixer self activate.");
		}
		else
		{
			return;
		}
			
		if(switch_light_once_only())
		{
			return;
		}
	}
}

mixer_event_monitor()
{
	if(!isdefined(self.script_mixer_event) && !isdefined(self.script_mixer_robot_min))
	{
		return;	// No script_mixer_event means that we're a non-switchable mixer, so don't bother with this thread.
	}
	
	//println("*** Client : Mixer event " + self.script_mixer_event);
	
	self thread debug_draw_mixer();
	self thread mixer_level_activate();
	self thread mixer_self_activate();
		
	self.mixer_activated = 0;
	
	while(1)
	{
		
		self.mixer.active = 0;
		
		while(!self.mixer_activated)	// Mixer can be activated by notification to self, or to level.
		{
			wait(0.01);
		}
		
		//println("Mixer Go!");
		
		self.mixer_activated = 0;
		
		self.mixer.active = 1;
		self.mixer notify("activated");
		
		ramp = mixer_get_ramp();	// Returns how many seconds it should take to blend to our 'other' side.
		
		if(ramp)	// Non zero ramp is time in seconds to change sides.
		{
			
			start_time = GetRealTime();
			end_time = start_time + (ramp * 1000);
			duration = end_time - start_time;
			last_time = start_time;

			if(self.mixer.mix_pos)	// If we're set right, travelling left, step becomes negative.
			{
				sign = -1;
			}
			else
			{
				sign = 1;
			}
			
			while(GetRealTime() < end_time)
			{
				time = GetRealTime();
				elapsed = time - last_time;		
				last_time = time;
				
				step_size = (elapsed/duration) * sign;		// Calculate delta movement amount based on elapsed time.

				self.mixer.mix_val += step_size;		// Move slider.
				
				wait(0.016);
			}
		}

		// If ramp was zero, then falling through to here will result in an instant side switch, which is
		// exactly what we want to happen.

		self.mixer.mix_pos = !self.mixer.mix_pos;		// switch active side.
		
		self.mixer.lights[self.mixer.mix_pos] notify("light_activated");
		
		if(self.mixer.mix_pos)
		{
			self.mixer.mix_val = 1.0;						// Set full right.
		}			
		else
		{
			self.mixer.mix_val = 0.0;						// Set full left.
		}
	}
}

init_mixer_lights(client_num)
{
	self.mixer.lights = [];	// These are our light array. 0 left, 1 right.

	for(i = 0; i < 2; i ++)
	{
		self.mixer.lights[i] = spawnstruct();
	}

	// Light 0 pulls it's value from the primary light associated with this mixer.
		
	self.mixer.lights[0].light_color = self.lights[client_num] GetLightColor();
	self.mixer.lights[0].light_intensity = self.lights[client_num] GetLightIntensity();
	self.mixer.lights[0].light_radius = self.lights[client_num] GetLightRadius();
	self.mixer.lights[0].light_inner_fov = self.lights[client_num] GetLightFovInner();
	self.mixer.lights[0].light_outer_fov = self.lights[client_num] GetLightFovOuter();
	self.mixer.lights[0].light_exponent = self.lights[client_num] GetLightExponent();
	
	// Additional light params from radiant copied from light kvps' into light 0.
	
	self.mixer.lights[0].script_delay_min = self.script_delay_min;
	self.mixer.lights[0].script_delay_max = self.script_delay_max;
	self.mixer.lights[0].script_intensity_min = self.script_intensity_min;
	self.mixer.lights[0].script_intensity_max = self.script_intensity_max;
	self.mixer.lights[0].script_burst_min = self.script_burst_min;
	self.mixer.lights[0].script_burst_max = self.script_burst_max;
	self.mixer.lights[0].script_burst_time = self.script_burst_time;
	self.mixer.lights[0].script_fade_duration = self.script_fade_duration;
	self.mixer.lights[0].script_burst_intensity = self.script_burst_intensity;
	
	if(isdefined(self.script_light_sound))
	{
		self.mixer.lights[0].script_light_sound = self.script_light_sound;
	}

	if(isdefined(self.script_light2_sound))
	{
		self.mixer.lights[1].script_light_sound = self.script_light2_sound;
	}
	
	if(IsDefined(self.script_light_fx))
	{
		self.mixer.lights[0].script_light_fx = self.script_light_fx;
	}

	if(IsDefined(self.script_light2_fx))
	{
		self.mixer.lights[1].script_light_fx = self.script_light2_fx;
	}
	else
	{
		self.mixer.lights[1].script_light_fx = self.mixer.lights[0].script_light_fx;
	}

	if(IsDefined(self.script_light_fx_offset))
	{
		self.mixer.lights[0].script_light_fx_offset = self.script_light_fx_offset;
		self.mixer.lights[1].script_light_fx_offset = self.script_light_fx_offset;
	}
	
	// Light 1 will take values from radiant KVP's if they exist, and will clone off of light 0 if they dont.

	if(isdefined(self.script_light2_color))
	{
		self.mixer.lights[1].light_color = self.script_light2_color;
	}
	else
	{
		self.mixer.lights[1].light_color = self.mixer.lights[0].light_color;
	}

	if(isdefined(self.script_light2_intensity))
	{
		self.mixer.lights[1].light_intensity = self.script_light2_intensity;
	}
	else
	{
		self.mixer.lights[1].light_intensity = self.mixer.lights[0].light_intensity;
	}

	if(isdefined(self.script_light2_radius))
	{
		self.mixer.lights[1].light_radius = self.script_light2_radius;
	}
	else
	{
		self.mixer.lights[1].light_radius = self.mixer.lights[0].light_radius;
	}

	if(isdefined(self.script_light2_inner_fov))
	{
		self.mixer.lights[1].light_inner_fov = self.script_light2_inner_fov;
	}
	else
	{
		self.mixer.lights[1].light_inner_fov = self.mixer.lights[0].light_inner_fov;
	}

	if(isdefined(self.script_light2_outer_fov))
	{
		self.mixer.lights[1].light_outer_fov = self.script_light2_outer_fov;
	}
	else
	{
		self.mixer.lights[1].light_outer_fov = self.mixer.lights[0].light_outer_fov;
	}

	if(isdefined(self.script_light2_exponent))
	{
		self.mixer.lights[1].light_exponent = self.script_light2_exponent;
	}
	else
	{
		self.mixer.lights[1].light_exponent = self.mixer.lights[0].light_exponent;
	}
	
	if(isdefined(self.script_light2_burst_max))
	{
		self.mixer.lights[1].script_burst_max = self.script_light2_burst_max;
	}
	else
	{
		self.mixer.lights[1].script_burst_max = self.mixer.lights[0].script_burst_max;
	}	

	if(isdefined(self.script_light2_burst_min))
	{
		self.mixer.lights[1].script_burst_min = self.script_light2_burst_min;
	}
	else
	{
		self.mixer.lights[1].script_burst_min = self.mixer.lights[0].script_burst_min;
	}	
	
	if(IsDefined(self.script_light2_burst_time))
	{
		self.mixer.lights[1].script_burst_time = self.script_light2_burst_time;		
	}
	else
	{
		self.mixer.lights[1].script_burst_time = self.mixer.lights[0].script_burst_time;		
	}

	if(IsDefined(self.script_light2_fade_duration))
	{
		self.mixer.lights[1].script_fade_duration = self.script_light2_fade_duration;				
	}
	else
	{
		self.mixer.lights[1].script_fade_duration = self.mixer.lights[0].script_fade_duration;				
	}

	if(IsDefined(self.script_light2_burst_intensity))
	{
		self.mixer.lights[1].script_burst_intensity = self.script_light2_burst_intensity;				
	}
	else
	{
		self.mixer.lights[1].script_burst_intensity = self.mixer.lights[0].script_burst_intensity;				
	}

	// Additional light params from radiant copied from light kvps' into light 1.
	
	self.mixer.lights[1].script_delay_min = self.script_light2_delay_min;
	self.mixer.lights[1].script_delay_max = self.script_light2_delay_max;	
	self.mixer.lights[1].script_intensity_min = self.script_light2_intensity_min;
	self.mixer.lights[1].script_intensity_max = self.script_light2_intensity_max;

	self.mixer.lights[0].light_notify = "";
	self.mixer.lights[1].light_notify = "";
	
	self.mixer.lights[0].play_light_sound_alias = "";
	self.mixer.lights[1].play_light_sound_alias = "";

}

clean_lights()
{
		self.mixer.last_mix_val = self.mixer.mix_val;
}

add_light_thread(light_struct, light_type, side, default_type)
{
	if(!IsDefined(level._next_light_id))
	{
		level._next_light_id = 0;	
	}

	light_struct.side = side;
	light_struct.light_id = level._next_light_id;
	level._next_light_id += 1;
	
	if(isdefined(level._light_types[light_type]))
	{
		self thread [[level._light_types[light_type].func]](light_struct);
		level._light_types[light_type].count[side] ++;
	}
	else if(isdefined(default_type)) // If we get to here, it's because we've found no registered light for this light_type.
	{
		if(isdefined(level._light_types[default_type]))
		{
			self.script_light2_targetname = default_type;
			self thread [[level._light_types[default_type].func]](light_struct);
			level._light_types[default_type].count[side] ++;
		}
		else
		{
			println("*** Client : Unable to set up script thread for client light - default type " + light_type + " is unknown.");
		}
	}
	else
	{
		println("*** Client : Unable to set up script thread for client light - " + light_type + " is unknown - and no default specified.");
	}
}

setup_mixer_lights()
{
	
	light_type = self.targetname;
	
	if( !isdefined(light_type) && !IsDefined(self.script_light_type))
	{
		light_type = "light_off";
	}
	else if(IsDefined(self.script_light_type) && isdefined(level._light_types[self.script_light_type]))
	{
		light_type = self.script_light_type;
	}
	
	add_light_thread(self.mixer.lights[0], light_type, 0);
	add_light_thread(self.mixer.lights[1], self.script_light2_targetname, 1, "light_off");
}

mixer_robot_think()
{
	
	
	if(!isdefined(self.script_mixer_robot_max))
	{
		self.script_mixer_robot_max = self.script_mixer_robot_min;
	}
	
	if(self.script_mixer_robot_max < self.script_mixer_robot_min)
	{
		temp = self.script_mixer_robot_max;
		self.script_mixer_robot_max = self.script_mixer_robot_min;
		self.script_mixer_robot_min = temp;
	}
	
	if(self.script_mixer_robot_max == self.script_mixer_robot_min)
	{
			self.script_mixer_robot_max += 0.01;
	}
	
	while(1)
	{
//		println("min " + self.script_mixer_robot_min + " max " + self.script_mixer_robot_max);
		waitrealtime(RandomFloatRange(self.script_mixer_robot_min, self.script_mixer_robot_max));
		
//		println("Light Robot Go!");
		
		self.mixer_activated = 1;		
	}
}

mixer_thread(client_num)
{
	if(!IsSplitScreenHost(client_num))
	{
		return;
	}
	
	self.mixer = spawnstruct();
	
	self.mixer.mix_pos = 0;		// 0 is left, 1 is right.
	self.mixer.mix_val = 0.0;	// 0 is full left, 1 is full right - this is the slider.
	self.mixer.last_mix_val = 0.0;
	self.mixer.active = 0;		// When 1, mixer is switching sides.  When 0, side is set.
	
	self.mixer.last_sent_notify = "";
	
	if(isdefined(self.script_mixer_robot_min))
	{
//		println("Robot thread launch.");
		self thread mixer_robot_think();
	}	
	
	init_mixer_lights(client_num);
	
	if(!isdefined(self.script_mixer_ltr_ramp))
	{
		self.script_mixer_ltr_ramp = 0.25;
	}

	if(!isdefined(self.script_mixer_rtl_ramp))
	{
		self.script_mixer_rtl_ramp = 0.25;
	}
	
	if(isdefined(self.script_mixer_ltr_ramp))
	{
		self.mixer.left_to_right_ramp = self.script_mixer_ltr_ramp;
	}
	
	if(isdefined(self.script_mixer_rtl_ramp))
	{
		self.mixer.right_to_left_ramp = self.script_mixer_rtl_ramp;
	}
	
	if(!isdefined(self.script_light2_targetname))
	{
		self.script_light2_targetname = "";
	}
	
	if(!isdefined(self.script_light_onetime))
	{
		self.script_light_onetime = 0;
	}

	setup_mixer_lights();
	
	self thread mixer_event_monitor();
	
	while(1)
	{
		self.mixer waittill("activated");

		while(self.mixer.active)
		{
			waittillframeend;		// Mixer shouldn't process until after the light threads have done their thing.

			lerped_light_color = LerpVector(self.mixer.lights[0].light_color, self.mixer.lights[1].light_color, self.mixer.mix_val);
			lerped_light_intensity = LerpFloat(self.mixer.lights[0].light_intensity, self.mixer.lights[1].light_intensity, self.mixer.mix_val);
			lerped_light_radius = LerpFloat(self.mixer.lights[0].light_radius, self.mixer.lights[1].light_radius, self.mixer.mix_val);
			lerped_light_inner_fov = LerpFloat(self.mixer.lights[0].light_inner_fov, self.mixer.lights[1].light_inner_fov, self.mixer.mix_val);
			lerped_light_outer_fov = LerpFloat(self.mixer.lights[0].light_outer_fov, self.mixer.lights[1].light_outer_fov, self.mixer.mix_val);
			lerped_light_exponent = int(LerpFloat(self.mixer.lights[0].light_exponent, self.mixer.lights[1].light_exponent, self.mixer.mix_val));

			// Set lerped values into lights.  The loop handles all split screen clients.
			
			for(i = 0; i < level.max_local_clients; i ++)
			{
				if(LocalClientActive(i) && isdefined(self.lights[i]))
				{
					self.lights[i] SetLightColor(lerped_light_color);
					self.lights[i] SetLightIntensity(lerped_light_intensity);
					self.lights[i] SetLightRadius(lerped_light_radius);
					self.lights[i] SetLightFovRange(lerped_light_outer_fov, lerped_light_inner_fov);
					self.lights[i] SetLightExponent(lerped_light_exponent);					
				}
			}
			wait(0.016);
		}
		
		if(IsDefined(self.light_models))
		{
			if(self.mixer.last_sent_notify != "" && self.mixer.lights[self.mixer.mix_pos].light_notify != "")
			{
				if(self.mixer.last_sent_notify != self.mixer.lights[self.mixer.mix_pos].light_notify)
				{
					for(i = 0; i < level.max_local_clients; i ++)
					{
						if(IsDefined(self.light_models[i]))
						{
							self.light_models[i] notify(self.mixer.lights[self.mixer.mix_pos].light_notify);
						}
					}					
					self.mixer.last_sent_notify = self.mixer.lights[self.mixer.mix_pos].light_notify;
				}
			}
		}
		
		
		
/*		if(lights_are_dirty())
		{
			// Lerp light values.
			
			color_is_dirty = light_color_is_dirty();
			intensity_is_dirty = light_intensity_is_dirty();
			radius_is_dirty = light_radius_is_dirty();
			fov_is_dirty = light_fov_is_dirty();
			exponent_is_dirty = light_exponent_is_dirty();
			
			lerped_light_color = (0,0,0);
			lerped_light_intensity = 0;
			lerped_light_radius = 0;
			lerped_light_inner_fov = 0;
			lerped_light_outer_fov = 0;
			lerped_light_exponent = 0;			

			force_set_all = false;
			
			if(self.mixer.mix_val == 0)
			{
				lerped_light_color = self.mixer.lights[0].light_color;
				lerped_light_intensity = self.mixer.lights[0].light_intensity;
				lerped_light_radius = self.mixer.lights[0].light_radius;
				lerped_light_inner_fov = self.mixer.lights[0].light_inner_fov;
				lerped_light_outer_fov = self.mixer.lights[0].light_outer_fov;
				lerped_light_exponent = int(self.mixer.lights[0].light_exponent);
			}
			else if(self.mixer.mix_val == 1)
			{
				lerped_light_color = self.mixer.lights[1].light_color;
				lerped_light_intensity = self.mixer.lights[1].light_intensity;
				lerped_light_radius = self.mixer.lights[1].light_radius;
				lerped_light_inner_fov = self.mixer.lights[1].light_inner_fov;
				lerped_light_outer_fov = self.mixer.lights[1].light_outer_fov;
				lerped_light_exponent = int(self.mixer.lights[1].light_exponent);
			}
			else
			{
				force_set_all = true;
				lerped_light_color = LerpVector(self.mixer.lights[0].light_color, self.mixer.lights[1].light_color, self.mixer.mix_val);
				lerped_light_intensity = LerpFloat(self.mixer.lights[0].light_intensity, self.mixer.lights[1].light_intensity, self.mixer.mix_val);
				lerped_light_radius = LerpFloat(self.mixer.lights[0].light_radius, self.mixer.lights[1].light_radius, self.mixer.mix_val);
				lerped_light_inner_fov = LerpFloat(self.mixer.lights[0].light_inner_fov, self.mixer.lights[1].light_inner_fov, self.mixer.mix_val);
				lerped_light_outer_fov = LerpFloat(self.mixer.lights[0].light_outer_fov, self.mixer.lights[1].light_outer_fov, self.mixer.mix_val);
				lerped_light_exponent = int(LerpFloat(self.mixer.lights[0].light_exponent, self.mixer.lights[1].light_exponent, self.mixer.mix_val));
      }

			// Set lerped values into lights.  The loop handles all split screen clients.
			
			for(i = 0; i < GetMaxLocalClients(); i ++)
			{
				if(LocalClientActive(i) && isdefined(self.lights[i]))
				{
					if(color_is_dirty || force_set_all)
					{
						self.lights[i] SetLightColor(lerped_light_color);
					}
					
					if(intensity_is_dirty || force_set_all)
					{
						self.lights[i] SetLightIntensity(lerped_light_intensity);
					}
					
					if(radius_is_dirty || force_set_all)
					{
						self.lights[i] SetLightRadius(lerped_light_radius);
					}
					
					if(fov_is_dirty || force_set_all)
					{
						self.lights[i] SetLightFovRange(lerped_light_outer_fov, lerped_light_inner_fov);
					}
					
					if(exponent_is_dirty || force_set_all)
					{
						self.lights[i] SetLightExponent(lerped_light_exponent);					
					}
				}
			}

			if(isdefined(self.light_models))
			{
				if(self.mixer.last_sent_notify != self.mixer.lights[self.mixer.mix_pos].light_notify)
				{
					for(i = 0; i < GetMaxLocalClients(); i ++)
					{
						if(LocalClientActive(i) && isdefined(self.light_models[i]))
						{
							self.light_models[i] notify(self.mixer.lights[self.mixer.mix_pos].light_notify);
						}
					}
		
					self.mixer.last_sent_notify = self.mixer.lights[self.mixer.mix_pos].light_notify;
				}
			}
			
			if(self.mixer.lights[self.mixer.mix_pos].play_light_sound_alias != "")
			{
				
				PlaySound(0, self.mixer.lights[self.mixer.mix_pos].play_light_sound_alias , self.origin);
				
				self.mixer.lights[self.mixer.mix_pos].play_light_sound_alias = "";
			}

			clean_lights();
			
		} */
	}
	
}

report_light_counts(clientnum, lights)
{
	if(!IsSplitScreenHost(clientnum))
	{
		return;
	}

	// Count up lights with models.

	lights_with_models = 0;

	for(i = 0; i < lights.size; i ++)
	{
		if(isdefined(lights[i].script_light_model) && IsDefined(lights[i].script_light_on_model) && IsDefined(lights[i].script_light_off_model))
		{
			lights_with_models ++;
		}
	}	

	numLights = lights.size;

	println("*** Client : Lights " + numLights);
	
	light_keys = GetArrayKeys(level._light_types);
	
	for(i = 0; i < light_keys.size; i ++)
	{
		println("*** Client : " + light_keys[i] + " Left " + level._light_types[light_keys[i]].count[0] + " Right " + level._light_types[light_keys[i]].count[1]);
	}

	PrintLn("*** Client : Lights with models : " + lights_with_models);
}

register_light_type(type, func)
{
	if(!isdefined(level._light_types))
	{
		level._light_types = [];
	}
	
	if(!isdefined(level._light_types[type]))
	{
		level._light_types[type] = spawnstruct();
		level._light_types[type].func = func;
		level._light_types[type].count = [];
		level._light_types[type].count[0] = 0;
		level._light_types[type].count[1] = 0;
	}
}

// Utility functions that will return lists of lights...

// by label...

get_lights_by_label(label)
{
	lights = GetStructArray("light", "classname");
	
	return_array = [];
	
	for(i = 0; i < lights.size; i ++)
	{
		if((isdefined(lights[i].script_light_label)) && (lights[i].script_light_label == label))
		{
			return_array[return_array.size] = lights[i];
		}
	}
	
	return return_array;
}

// by distance from a point

get_lights_in_radius(pos, rad)
{
	lights = GetStructArray("light", "classname");
	
	return_array = [];
	
	rad_squared = rad * rad;	// Square it.
	
	for(i = 0; i < lights.size; i ++)
	{
		if(DistanceSquared(lights[i].origin, pos) < rad_squared)
		{
			return_array[return_array.size] = lights[i];
		}
	}
	
	return return_array;
}

// by label *and* distance from a point...

get_labelled_lights_in_radius(label, pos, rad)
{
	lights = GetStructArray("light", "classname");
	
	return_array = [];
	
	rad_squared = rad*rad;
	
	for(i = 0; i < lights.size; i ++)
	{
		if((isdefined(lights[i].script_light_label)) && (lights[i].script_light_label == label))
		{
			if(DistanceSquared(lights[i].origin, pos) < rad_squared)
			{
				return_array[return_array.size] = lights[i];
			}
		}
	}
	
	return return_array;
}

// Used to lists of lights returned from the above utility functions to switch the mixers of those lights.
// Any lights tagged as one-time-only switchers, that have already switched, will not switch again.

switch_light_mixers(lights)
{
	if(isdefined(lights))
	{
		for(i = 0; i <lights.size; i ++)
		{
			if(lights[i].script_light_onetime >= 0)
			{
				lights[i].mixer_activated = 1;
//				println("mixer_activated set.");
			}
			
			lights[i] switch_light_once_only();
		}
	}
}

clean_up_spin_models()
{
	self waittill("destroy_spin_models");
	PrintLn("*** clean_up_spin_models");
	if(IsDefined(self.spin_models))
	{
		for(i = 0; i < self.spin_models.size; i ++)
		{
			if(IsDefined(self.spin_models[i]))
			{
				self.spin_models[i] Delete();
				//self.spin_models[i] = undefined;
			}
		}
		
		self.spin_models = undefined;
	}
}

run_spin_model(notify_name, light, spin_model_name, spin_model_fx, spin_model_fx_tag)
{

	PrintLn("*** run spin model " + notify_name + " " + spin_model_name);

	self endon("destroy_spin_models");
	self thread clean_up_spin_models();
	
	players = level.localPlayers;
	
	self.spin_models = [];
	
	for(i = 0; i < players.size; i ++)
	{
		self.spin_models[i] = spawn(i, self.origin, "script_model");
		self.spin_models[i] SetModel(spin_model_name);
		self.spin_models[i].angles = self.angles;
		
		if(IsDefined(spin_model_fx) && IsDefined(level._effect[spin_model_fx]) && IsDefined(spin_model_fx_tag))
		{
			PlayFXOnTag(i, level._effect[spin_model_fx], self.spin_models[i], spin_model_fx_tag);
		}
	}
	
	if(notify_name == "on")
	{
		while(1)
		{
			waitforallclients();
			
			ang_x = self.spin_models[0].angles[0];
			ang_y = light.angles[1];
			ang_z = self.spin_models[0].angles[2];
			
			new_ang = (ang_x, ang_y, ang_z);
			
			for(i = 0; i < self.spin_models.size; i ++)
			{
				self.spin_models[i].angles = new_ang;
			}
			
			wait(0.01);
		}
	}
	
}



light_model_switch(clientNum, notify_name, model_name, light, spin_model_name, spin_model_fx, spin_model_fx_tag)
{
	while(1)
	{
		self waittill(notify_name);

		waitforallclients();
				
		PrintLn("*** Got notify name " + notify_name);
				
		if(IsDefined(spin_model_name) && clientNum == 0)
		{
			self notify("destroy_spin_models");
			PrintLn("*** destroy spin models");
			waittillframeend;
			self thread run_spin_model(notify_name, light, spin_model_name, spin_model_fx, spin_model_fx_tag);
		}
		self SetModel(model_name);
	}
}

init_lights(clientNum)
{
	
	// Register all of the scriptable light types in this file.
	// Any custom light types in level.csc files should be registered *before* the call to init_lights()
	
	register_light_type("explode_then_flicker", ::explode_then_flicker);
	register_light_type("firecaster", ::ber3b_firelight);
	register_light_type("fire_flicker", ::fire_flicker);
	register_light_type("electrical_flicker", ::electrical_flicker);
	register_light_type("flicker_then_stop", ::fire_flicker_then_stop);
	register_light_type("generic_double_strobe", ::generic_double_strobe);
	register_light_type("generic_strobe", ::generic_strobe);
	register_light_type("generic_flickering", ::generic_flickering);
	register_light_type("generic_pulsing", ::generic_pulsing);
	register_light_type("light_off", ::light_off);
	register_light_type("light_solid", ::light_solid);
	register_light_type("television", ::television);
	register_light_type("triggered_lights", ::triggered_lights_think);
		
	lights = GetStructArray("light", "classname");

	level.max_local_clients = GetMaxLocalClients();

	// END TEST

	if(isdefined(lights))
	{
		array_thread(lights, ::create_lights, clientNum);

		if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
		{
			return;
		}

		// mixer_thread handles setup of all lights.
		array_thread(lights, ::mixer_thread, clientNum);
	}
	
	// debug output
	report_light_counts(clientNum, lights);

}
