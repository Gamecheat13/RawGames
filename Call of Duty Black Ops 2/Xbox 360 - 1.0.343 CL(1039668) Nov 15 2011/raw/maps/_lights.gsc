#include common_scripts\utility;
#include maps\_utility;

generic_pulsing()
{
	//ChrisC wants the lights off when probes are done
	if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		self setLightIntensity( 0 );
		return;
	}
		
	on = self getLightIntensity();
	const off = .05;
	curr = on;
	const transition_on = .3;
	const transition_off = .6;
	increment_on = ( on - off ) / ( transition_on / .05 );
	increment_off = ( on - off ) / ( transition_off / .05 );
	
	for ( ;; )
	{
		//ramp down
		time = 0;
		while ( ( time < transition_off ) )
		{
			curr -= increment_off;
			self setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		
		//off wait time
		wait( 1 );
		
		//ramp up
		time = 0;
		while ( time < transition_on )
		{
			curr += increment_on;
			self setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		
		//on wait time
		wait( .5 );
	}	
}


generic_double_strobe()
{
	//ChrisC wants the lights off when probes are done
	if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		self setLightIntensity( 0 );
		return;
	}
		
	on = self getLightIntensity();
	const off = .05;
	linked_models = false;
	lit_model = undefined;
	unlit_model = undefined;
	linked_lights = false;
	linked_light_ents = [];
	
	if (isdefined ( self.script_noteworthy ) )
	{
		linked_things = getentarray ( self.script_noteworthy, "targetname" );
		for ( i = 0; i < linked_things.size; i++ )
		{
			if ( linked_things[ i ].classname == "light" )
			{
				linked_lights = true;
				linked_light_ents[ linked_light_ents.size ] = linked_things[ i ];
			}
			if ( linked_things[ i ].classname == "script_model" )
			{
				lit_model = linked_things[ i ];
				unlit_model = getent ( lit_model.target, "targetname" );
				linked_models = true;
			}
		}
		//if (! isdefined ( lit_model ) )
		//	assertmsg( "primary light has lit model but not unlit model ( " + lit_model.origin + " ) " );
	}
	
	for ( ;; )
	{
		//off wait time
		self setLightIntensity( off );
		if ( linked_models )
		{
			lit_model hide();
			unlit_model show();
		}
		wait( .8 );
		
		//first flash
		self setLightIntensity( on );
		if ( linked_models )
		{
			lit_model show();
			unlit_model hide();
		}
		wait( .1 );
		
		//pause
		self setLightIntensity( off );
		if ( linked_models )
		{
			lit_model hide();
			unlit_model show();
		}
		wait( .12 );
		
		//second flash
		self setLightIntensity( on );
		if ( linked_models )
		{
			lit_model show();
			unlit_model hide();
		}
		wait( .1 );
	}	
}

getclosests_flickering_model( origin )
{
	//stuff in prefabs bleh. non of this script_noteworthy or linkto stuff works there. so doing closest thing with the light_flicker_model targetname
	array = getentarray("light_flicker_model","targetname");
	return_array = [];
	model = getclosest( origin, array );
	if(isdefined(model))
		return_array[0] = model;
	return return_array; //I'm losing my mind
	
}

generic_flickering()
{
	//ChrisC wants the lights off when probes are done
	if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		self setLightIntensity( 0 );
		return;
	}

	min_flickerless_time = 0.2;
	max_flickerless_time = 1.5;
	if( IsDefined( self.script_wait_min ) )
	{
		min_flickerless_time = self.script_wait_min;
	}

	if( IsDefined( self.script_wait_max ) )
	{
		max_flickerless_time = self.script_wait_max;
	}

	min_flicker_delay = 0.05;
	max_flicker_delay = 0.1;
	if( IsDefined( self.script_delay_min ) )
	{
		min_flicker_delay = self.script_delay_min;
	}

	if( IsDefined( self.script_delay_max ) )
	{
		max_flicker_delay = self.script_delay_max;
	}

	min_intensity = 0;
	max_intensity = 0.3;
	if( IsDefined( self.script_intensity_min ) )
	{
		min_intensity = self.script_intensity_min;
	}

	if( IsDefined( self.script_intensity_max ) )
	{
		max_intensity = self.script_intensity_max;
	}

	min_burst = 1;
	max_burst = 10;
	if( IsDefined( self.script_burst_min ) )
	{
		min_burst = self.script_burst_min;
	}

	if( IsDefined( self.script_burst_max ) )
	{
		max_burst = self.script_burst_max;
	}

	
	on = self GetLightIntensity();
	curr = on;
	num = 0;
	linked_models = false;
	lit_model = undefined;
	unlit_model = undefined;
	linked_lights = false;
	linked_light_ents = [];
	linked_things = [];
	
	if( isdefined( self.script_noteworthy ) )	
	{
		linked_things = GetEntArray( self.script_noteworthy, "targetname" );
	}

	if( !linked_things.size )
	{
		linked_things = getclosests_flickering_model( self.origin );
	}
			
	for( i = 0; i < linked_things.size; i++ )
	{
		if( linked_things[ i ].classname == "light" )
		{
			linked_lights = true;
			linked_light_ents[ linked_light_ents.size ] = linked_things[ i ];
		}

		if( linked_things[ i ].classname == "script_model" )
		{
			lit_model = linked_things[ i ];
			unlit_model = GetEnt( lit_model.target, "targetname" );
			linked_models = true;
		}
	}
		//if (! isdefined ( lit_model ) )
		//	assertmsg( "primary light has lit model but not unlit model ( " + lit_model.origin + " ) " );
		
	for( ;; )
	{
		num = RandomIntRange( min_burst, max_burst );
		while( num )
		{
			wait( RandomFloatRange( min_flicker_delay, max_flicker_delay ) );
			if( curr > ( on * 0.5 ) )
			{
				curr = RandomFloatRange( min_intensity, max_intensity );
				if ( linked_models )
				{
					lit_model Hide();
					unlit_model Show();
				}
			}
			else
			{
				curr = on;
				if ( linked_models )
				{
					lit_model Show();
					unlit_model Hide();
				}
			}
					
			self SetLightIntensity( curr );
			if( linked_lights)
			{
				for( i = 0; i < linked_light_ents.size; i++ )
				{
					linked_light_ents[ i ] SetLightIntensity( curr );
				}
			}
			num--;			
		}
		
		self SetLightIntensity( on );
		if( linked_lights)
		{
			for( i = 0; i < linked_light_ents.size; i++ )
			{
				linked_light_ents[ i ] SetLightIntensity( on );
			}
		}

		if( linked_models )
		{
			lit_model Show();
			unlit_model Hide();
		}

		wait( RandomFloatRange( min_flickerless_time, max_flickerless_time ) );
	}	
}

// MikeD (4/6/2008): Added a fire flicker loop
fire_flicker()
{
/#
	if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		return;
	}
#/

	min_delay = 0.1;
	max_delay = 0.5;
	if( IsDefined( self.script_delay_min ) )
	{
		min_delay = self.script_delay_min;
	}

	if( IsDefined( self.script_delay_max ) )
	{
		max_delay = self.script_delay_max;
	}

	min_intensity = 0.25;
	max_intensity = 1;
	if( IsDefined( self.script_intensity_min ) )
	{
		min_intensity = self.script_intensity_min;
	}

	if( IsDefined( self.script_intensity_max ) )
	{
		max_intensity = self.script_intensity_max;
	}

	intensity = self GetLightIntensity(); 
	curr_intensity = intensity;

	for( ;; )
	{
		temp_intensity = intensity * RandomFloatRange( min_intensity, max_intensity ); 
		time = RandomFloatRange( min_delay, max_delay ); 
		steps = time * 20; 
		div = ( curr_intensity - temp_intensity ) / steps; 

		for( i = 0; i < steps; i++ )
		{
			curr_intensity -= div;

			if( curr_intensity < 0 )
			{
				curr_intensity = 0;
			}

			self SetLightIntensity( curr_intensity ); 
			wait( 0.05 ); 
		}

		curr_intensity = temp_intensity; 
	}
}