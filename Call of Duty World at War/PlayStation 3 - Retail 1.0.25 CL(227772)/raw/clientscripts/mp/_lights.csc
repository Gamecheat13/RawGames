#include clientscripts\mp\_utility;

add_light(clientNum)
{
	light = spawn(clientNum, self.origin);
	light makelight(self.pl);

	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		light setLightIntensity( 0 );
	}
	
	return(light);
}

create_lights(clientNum)
{
	if(!isdefined(self.lights))
	{
		self.lights = [];
	}
	
	self.lights[clientNum] = self add_light(clientNum);
}

generic_flickering(clientNum)
{
	
}

generic_pulsing(clientNum)
{
	assertex(isdefined(self.lights) && isdefined(self.lights[clientNum]), "Light not setup before script thread run on it.");
	
	//ChrisC wants the lights off when probes are done
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		self.lights[clientNum] setLightIntensity( 0 );
		return;
	}
		
	on = self.lights[clientNum] getLightIntensity();
	off = .05;
	curr = on;
	transition_on = .3;
	transition_off = .6;
	increment_on = ( on - off ) / ( transition_on / .05 );
	increment_off = ( on - off ) / ( transition_off / .05 );
	
	for ( ;; )
	{
		//ramp down
		time = 0;
		while ( ( time < transition_off ) )
		{
			curr -= increment_off;
			self.lights[clientNum] setLightIntensity( curr );
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
			self.lights[clientNum] setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		
		//on wait time
		wait( .5 );
	}		
}

generic_double_strobe(clientNum)
{
	assertex(isdefined(self.lights) && isdefined(self.lights[clientNum]), "Light not setup before script thread run on it.");

}

// modified version of _lights::burning_trash_fire()
ber3b_firelight(clientNum)
{

	assertex(isdefined(self.lights) && isdefined(self.lights[clientNum]), "Light not setup before script thread run on it.");

	full = self.lights[clientNum] GetLightIntensity();
	
	old_intensity = full;
	
	while( 1 )
	{
		intensity = RandomFloatRange( full * 0.63, full * 1.2 );
		// old values = 6, 12
		timer = RandomFloatRange( 2, 5 );

		for ( i = 0; i < timer; i ++ )
		{
			new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
			
			self.lights[clientNum] SetLightIntensity( new_intensity );
			wait( 0.05 );
		}
		
		old_intensity = intensity;
	}	
}

fire_flicker(clientNum)
{
	assertex(isdefined(self.lights) && isdefined(self.lights[clientNum]), "Light not setup before script thread run on it.");

	
/#
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
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

	intensity = self.lights[clientNum] GetLightIntensity(); 
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

			self.lights[clientNum] SetLightIntensity( curr_intensity ); 

			wait( 0.05 ); 
		}

		curr_intensity = temp_intensity; 
	}	
}

init_lights(clientNum)
{

	lights = GetStructArray("light", "classname");

	if(isdefined(lights))
	{
		array_thread(lights, ::create_lights, clientNum);
		println("*** Client : Lights " + lights.size);
	}
	else
	{
		println("*** Client : No Lights");
	}
	
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		return;
	}

	flickering_lights = GetStructArray( "generic_flickering", "targetname" ); 	
	pulsing_lights = GetStructArray( "generic_pulsing", "targetname" ); 
	double_strobe = GetStructArray( "generic_double_strobe", "targetname" ); 
	fire_flickers = GetStructArray( "fire_flicker", "targetname" ); 	
	fire_casters = GetStructArray( "firecaster", "targetname");
	
	if(isdefined(flickering_lights))
	{
		println("*** Client : " + flickering_lights.size + " flickering lights.");
		array_thread( flickering_lights, ::generic_flickering, clientNum ); 
	}

	if(isdefined(pulsing_lights))
	{
		println("*** Client : " + pulsing_lights.size + " pulsing_lights.");
		array_thread( pulsing_lights, ::generic_pulsing, clientNum ); 
	}

	if(isdefined(double_strobe))
	{
		println("*** Client : " + double_strobe.size + " double_strobe.");
		array_thread( double_strobe, ::generic_double_strobe, clientNum ); 
	}

	if(isdefined(fire_flickers))
	{
		println("*** Client : " + fire_flickers.size + " fire_flickers.");
		array_thread( fire_flickers, ::fire_flicker, clientNum );  
	}

	if(isdefined(fire_casters))
	{
		println("*** Client : " + fire_casters.size + " fire_casters.");
		array_thread( fire_flickers, ::ber3b_firelight, clientNum );
	}
	
}
