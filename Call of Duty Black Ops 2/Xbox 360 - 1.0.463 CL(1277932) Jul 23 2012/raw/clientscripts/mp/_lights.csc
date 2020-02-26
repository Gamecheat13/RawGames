#include clientscripts\mp\_utility;

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
	//PrintLn("**** sli " + intensity);
	if((light_struct.light_intensity > 0.3) && (intensity <= 0.3))
	{
		// Light has been turned off
		if ( isdefined( self.script_fxid ) )
		{
			//stopLightLoopExploder
			thread clientscripts\mp\_fx::stopLightLoopExploder( self.script_fxid );
		}
		set_light_notify(light_struct, "off");
	}
	else if((light_struct.light_intensity) <= 0.3 && (intensity > 0.3))
	{
		// Light has been turned on
		if ( isdefined( self.script_fxid ) )
		{
			thread clientscripts\mp\_fx::playLightLoopExploder( self.script_fxid );
		}
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
	
	if(client_num == 0)
	{
		mixer_event = self.script_mixer_event;
		
		if(!IsDefined(mixer_event))
		{
			mixer_event = "";
		}

		self.lights[0] MakeMixerLight(mixer_event);
		
		self.lights[0] SetMixerLightColor("left", self.lights[client_num] GetLightColor());
		if(IsDefined(self.script_light2_color))
		{
			self.lights[0] SetMixerLightColor("right", self.script_light2_color);
		}
		else
		{
			self.lights[0] SetMixerLightColor("right", self.lights[client_num] GetLightColor());
		}

		self.lights[0] SetMixerLightIntensity("left", self.lights[client_num] GetLightIntensity());
		if(IsDefined(self.script_light2_intensity))
		{
			self.lights[0] SetMixerLightIntensity("right", self.script_light2_intensity);
		}
		else
		{
			self.lights[0] SetMixerLightIntensity("right", self.lights[client_num] GetLightIntensity());
		}
		
		self.lights[0] SetMixerLightRadius("left", self.lights[client_num] GetLightRadius());
		if(IsDefined(self.script_light2_radius))
		{
			self.lights[0] SetMixerLightRadius("right", self.script_light2_radius);
		}
		else
		{
			self.lights[0] SetMixerLightRadius("right", self.lights[client_num] GetLightRadius());
		}
		
		self.lights[0] SetMixerLightFovRange("left", self.lights[client_num] GetLightFovOuter(), self.lights[client_num] GetLightFovInner());

		outer = self.script_light2_outer_fov;
		
		if(!IsDefined(outer))
		{
			outer = self.lights[client_num] GetLightFovOuter();
		} 			
		
		if(IsDefined(self.script_light2_inner_fov))
		{
			self.lights[0] SetMixerLightFovRange("right", outer, self.script_light2_inner_fov);
		}
		else
		{
			self.lights[0] SetMixerLightFovRange("right", outer);
		}
		
		self.lights[0] SetMixerLightExponent("left", self.lights[client_num] GetLightExponent());
		if(IsDefined(self.script_light2_exponent))
		{
			self.lights[0] SetMixerLightExponent("right", self.script_light2_exponent);
		}
		else
		{
			self.lights[0] SetMixerLightExponent("right", self.lights[client_num] GetLightExponent());
		}
	}
	
	self.mixer.lights[0].script_delay_min = self.script_delay_min;
	self.mixer.lights[0].script_delay_max = self.script_delay_max;
	self.mixer.lights[0].script_intensity_min = self.script_intensity_min;
	self.mixer.lights[0].script_intensity_max = self.script_intensity_max;
	self.mixer.lights[0].script_burst_min = self.script_burst_min;
	self.mixer.lights[0].script_burst_max = self.script_burst_max;
	self.mixer.lights[0].script_burst_time = self.script_burst_time;
	self.mixer.lights[0].script_fade_duration = self.script_fade_duration;
	self.mixer.lights[0].script_burst_intensity = self.script_burst_intensity;
	

	if(client_num == 0)
	{
		self.lights[0] SetMixerLightParam("left", 0, self.script_delay_min);
		if(IsDefined(self.script_light2_delay_min))
		{
			self.lights[0] SetMixerLightParam("right", 0, self.script_light2_delay_min);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 0, self.script_delay_min);
		}
					
		self.lights[0] SetMixerLightParam("left", 1, self.script_delay_max);
		if(IsDefined(self.script_light2_delay_max))
		{
			self.lights[0] SetMixerLightParam("right", 1, self.script_light2_delay_max);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 1, self.script_delay_max);
		}
		
		self.lights[0] SetMixerLightParam("left", 2, self.script_intensity_min);
		if(IsDefined(self.script_light2_intensity_min))
		{
			self.lights[0] SetMixerLightParam("right", 2, self.script_light2_intensity_min);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 2, self.script_intensity_min);
		}
		
		self.lights[0] SetMixerLightParam("left", 3, self.script_intensity_max);
		if(IsDefined(self.script_light2_intensity_max))
		{
			self.lights[0] SetMixerLightParam("right", 3, self.script_light2_intensity_max);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 3, self.script_intensity_max);
		}
		
		self.lights[0] SetMixerLightParam("left", 4, self.script_burst_min);
		if(IsDefined(self.script_light2_burst_min))
		{
			self.lights[0] SetMixerLightParam("right", 4, self.script_light2_burst_min);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 4, self.script_light_burst_min);
		}
		
		self.lights[0] SetMixerLightParam("left", 5, self.script_burst_max);
		if(IsDefined(self.script_light2_burst_max))
		{
			self.lights[0] SetMixerLightParam("right", 5, self.script_light2_burst_max);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 5, self.script_light_burst_max);
		}

		self.lights[0] SetMixerLightParam("left", 6, self.script_burst_time);
		if(IsDefined(self.script_light2_burst_time))
		{
			self.lights[0] SetMixerLightParam("right", 6, self.script_light2_burst_time);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 6, self.script_light_burst_time);
		}			
		
		self.lights[0] SetMixerLightParam("left", 7, self.script_fade_duration);
		if(IsDefined(self.script_light2_fade_duration))
		{
			self.lights[0] SetMixerLightParam("right", 7, self.script_light2_fade_duration);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 7, self.script_fade_duration);
		}			
					
		self.lights[0] SetMixerLightParam("left", 8, self.script_burst_intensity);
		if(IsDefined(self.script_light2_burst_intensity))
		{
			self.lights[0] SetMixerLightParam("right", 8, self.script_light2_burst_intensity);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 8, self.script_burst_intensity);
		}			
					
		self.lights[0] SetMixerLightParam("left", 9, self.script_light_sound);
		if(IsDefined(self.script_light2_sound))
		{
			self.lights[0] SetMixerLightParam("right", 9, self.script_light2_sound);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 9, self.script_light_sound);
		}			
					
		self.lights[0] SetMixerLightParam("left", 10, self.script_light_fx);
		if(IsDefined(self.script_light2_fx))
		{
			self.lights[0] SetMixerLightParam("right", 10, self.script_light2_fx);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 10, self.script_light_fx);
		}				

		self.lights[0] SetMixerLightParam("left", 11, self.script_wait_min);
		if(IsDefined(self.script_light2_wait_min))
		{
			self.lights[0] SetMixerLightParam("right", 11, self.script_light2_wait_min);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 11, self.script_wait_min);
		}		
		
		self.lights[0] SetMixerLightParam("left", 12, self.script_wait_max);
		if(IsDefined(self.script_light2_wait_min))
		{
			self.lights[0] SetMixerLightParam("right", 12, self.script_light2_wait_max);
		}
		else
		{
			self.lights[0] SetMixerLightParam("right", 12, self.script_wait_max);
		}		

	}
	
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

	if(IsDefined(self.script_light_fx_offset))	// Not handled in code mixer yet.
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
	
	if(IsDefined(self.script_fxid))
	{
		self.lights[0] SetMixerExploderId(Int(self.script_fxid));
	}

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
		/#	println("*** Client : Unable to set up script thread for client light - default type " + light_type + " is unknown.");	#/
		}
	}
	else
	{
	/#	println("*** Client : Unable to set up script thread for client light - " + light_type + " is unknown - and no default specified.");	#/
	}
}

setup_mixer_lights()
{
	
	light_type = self.targetname;
	
	if( (!isdefined(light_type) || light_type == "") && !IsDefined(self.script_light_type))
	{
		light_type = "light_off";
	}
	else if(IsDefined(self.script_light_type) && isdefined(level._light_types[self.script_light_type]))
	{
		light_type = self.script_light_type;
	}
	

	if(IsMixerLightBehaviorHardCoded(light_type))
	{
		self.lights[0] SetMixerLightBehavior("left", light_type);
	}
	else
	{
		add_light_thread(self.mixer.lights[0], light_type, 0);
	}
	
	if(!IsDefined(self.script_light2_targetname) || (self.script_light2_targetname == ""))
	{
		light_type = "light_off";
	}
	else
	{
		light_type = self.script_light2_targetname;
	}
	
	if(IsMixerLightBehaviorHardCoded(light_type))
	{
		self.lights[0] SetMixerLightBehavior("right", light_type);
	}
	else
	{
		add_light_thread(self.mixer.lights[1], light_type, 1);
	}
	
	if(IsDefined(self.script_light_model))
	{
		self thread light_model_init_pause();
	}
}

light_model_init_pause()
{
	waittillframeend;
	ent = getent(0, self.script_light_model, "targetname");
	
	if(IsDefined(ent) && IsDefined(self.script_light_on_spin_model))
	{
		self.lights[0] SetMixerSpinModels(ent, self.script_light_on_spin_model, self.script_light_off_spin_model, level._effect[self.script_light_spin_fx], self.script_light_spin_tag);
	}
	
	if(IsDefined(ent) && IsDefined(self.script_light_on_model) && IsDefined(self.script_light_off_model))
	{
		self.lights[0] SetMixerLightModels(ent, self.script_light_on_model, self.script_light_off_model);
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

	//self thread mixer_event_monitor();

	//self.lights[client_num] MakeMixerLight();
	self.lights[client_num] SetMixerL2RRampSpeed(self.mixer.left_to_right_ramp);
	self.lights[client_num] SetMixerR2LRampSpeed(self.mixer.right_to_left_ramp);

	if(isdefined(self.script_mixer_robot_min))
	{
//		println("Robot thread launch.");
//		self thread mixer_robot_think();
		
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
	
		self.lights[client_num] SetMixerParam(0, self.script_mixer_robot_min);
		self.lights[client_num] SetMixerParam(1, self.script_mixer_robot_max);
		self.lights[client_num] SetMixerBehavior("robot");

	}	

	if(IsDefined(self.script_light_rotate_yaw))
	{
		self.lights[client_num] SetMixerLightRotateTime(self.script_light_rotate_yaw);
	}	
	

}

report_light_counts(clientnum, lights)
{
	/#
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
	#/
}

register_light_type(type, func)
{
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
				lights[i].lights[0] ActivateMixer();
//				println("mixer_activated set.");
			}

		}
	}
}

init_lights(clientNum)
{
	
	if(isdefined(level.inited_lights))
	{
		return;		// TEMP HAX - Only init lights once in splitscreen.
	}
	
	 level.inited_lights = true;
	   
	if(!IsDefined(level._light_types))
	{
		level._light_types = [];	
	}
	
	// Register all of the scriptable light types in this file.
	// Any custom light types in level.csc files should be registered *before* the call to init_lights()
	
	lights = GetStructArray("light", "classname");

	level.max_local_clients = GetMaxLocalClients();

	// END TEST

	if(IsDefined(lights))
	{
		if(lights.size)
		{
			AllocateMixerLights(lights.size);
		}
		
		array_thread(lights, ::create_lights, clientNum);

		if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
		{
			return;
		}
		
		array_thread(lights, ::mixer_thread, clientNum);
	}

	// debug output
	report_light_counts(clientNum, lights);

}
