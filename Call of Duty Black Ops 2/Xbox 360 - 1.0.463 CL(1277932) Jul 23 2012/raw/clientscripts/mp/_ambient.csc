#include clientscripts\mp\_utility;
#include clientscripts\mp\_utility_code;

// setup a script_struct to play scripted Flak88 tracers FX
setup_point_fx(point, fx_id)
{
	if(isDefined(point.script_fxid))
	{
		fx_id = point.script_fxid;
	}
	
	point.fx_id = fx_id;
	
	if(isDefined(point.angles))
	{
		point.forward = anglesToForward(point.angles);
		point.up = anglesToUp(point.angles);
	}
	else
	{
		point.angles = (0, 0, 0);
		point.forward = (0, 0, 0);
		point.up = (0, 0, 0);
	}
	
	if(point.targetname == "flak_fire_fx")
	{
		level thread ambient_flak_think(point);
	}
	
	if(point.targetname == "fake_fire_fx")
	{
		level thread ambient_fakefire_think(point);
	}
}

// rotate the Flak88 tracers FX
ambient_flak_think(point)
{
	amount = undefined;
	speed = undefined;
	night = false;
	
	min_delay = 0.4;
	max_delay = 4;
	
	min_burst_time = 1;
	max_burst_time = 3;
	
	point.is_firing = false;
	level thread ambient_flak_rotate(point);
	level thread ambient_flak_flash(point, min_burst_time, max_burst_time);	
	
	for(;;)
	{
		timer = randomFloatRange(min_burst_time, max_burst_time);
		while(timer > 0)
		{
			point.is_firing = true;
			playFX(0, level._effect[point.fx_id], point.origin, point.forward, point.up);
			thread play_sound_in_space(0, "wpn_triple25_fire", point.origin);
			wait(0.2);
			
			timer -= 0.2;
		}
				
		point.is_firing = false;
		wait(randomFloatRange(min_delay, max_delay));
	}
}

// This mimics the rotation of the FX, but without using an ent (or client-ent)
// Updates the forward and up vectors which are used above
ambient_flak_rotate(point)
{
	min_pitch = 30;
	max_pitch = 80;
	
	if(isDefined(point.angles))
	{
		pointangles = point.angles;
	}
	else
	{
		pointangles = (0, 0, 0);
	}

	for(;;)
	{	
		time = randomFloatRange(0.5, 2);
		steps = time * 10;
		
		random_angle = (randomIntRange(min_pitch, max_pitch) * -1, randomInt(360), 0);
		
		forward = anglesToForward(random_angle);
		up = anglesToUp(random_angle);
			
		diff_forward = (forward - point.forward) / steps;
		diff_up = (up - point.up) / steps;
		
		for(i = 0; i < steps; i++)
		{
			point.forward += diff_forward;
			point.up += diff_up;
			
			wait(0.1);
		}
		
		point.forward = forward;
		point.up = up;
	}
}

// This gives a random chance to play a cloud flash
// or flak burst FX for the ambient Flak
ambient_flak_flash(point, min_burst_time, max_burst_time)
{
	min_dist = 5000;
	max_dist = 6500;
	
	if(isDefined(point.script_mindist))
	{
		min_dist = point.script_mindist;
	}
	
	if(isDefined(point.script_maxdist))
	{
		max_dist = point.script_maxdist;
	}
	
	min_burst_time = 0.25;
	max_burst_time = 1;

	fxpos = undefined;
	
	while(1)
	{
		if( !point.is_firing )
		{
			wait( 0.25 );
			continue;
		}
		
		fxpos = point.origin + VectorScale(point.forward, randomIntRange(min_dist, max_dist));
		
		playFX(0, level._effect["flak_burst_single"], fxpos);
		
		if(isDefined(level.timeofday) && (level.timeofday == "evening" || level.timeofday == "night"))
		{
			playFX(0, level._effect["flak_cloudflash_night"], fxpos);
		}
		
		wait randomFloatRange(min_burst_time, max_burst_time);
	}
}



// *******************************************************************************************************
// Ambient Weapon Muzzleflashes
//
// point = a script_struct in the map
// This is used to play the ambient fake fire fx and sound
ambient_fakefire_think(point)
{
	fireSound = undefined;
	weapType  = undefined;
	
	burstMin = undefined;
	burstMax = undefined;
	betweenShotsMin = undefined;
	betweenShotsMax = undefined;
	reloadTimeMin = undefined;
	reloadTimeMax = undefined;
	soundChance = undefined;

	if(!isDefined(point.weaponinfo))
	{
		point.weaponinfo = "axis_turret";
	}

	// determine what type of weapon the script_struct is faking
	switch(point.weaponinfo)
	{
		case "allies_assault":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_bar_fire";
			}
			else
			{
				fireSound = "weap_dp28_fire_plr";
			}
			
			burstMin = 16;
			burstMax = 24;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 4;
			reloadTimeMax = 7;
			soundChance = 75;
			weapType = "assault";
			break;
			
		case "axis_assault":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_mp44_fire";
			}
			else
			{
				fireSound = "weap_type99_fire";
			}
			
			burstMin = 16;
			burstMax = 24;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 4;
			reloadTimeMax = 7;
			soundChance = 75;
			weapType = "assault";
			break;
			
		case "allies_rifle":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_m1garand_fire";
			}
			else
			{
				fireSound = "weap_mosinnagant_fire";
			}
			
			burstMin = 1;
			burstMax = 3;
			betweenShotsMin = 0.8;
			betweenShotsMax = 1.3;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "rifle";
			break;
			
		case "axis_rifle":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_kar98k_fire";
			}
			else
			{
				fireSound = "weap_arisaka_fire";
			}
			
			burstMin = 1;
			burstMax = 3;
			betweenShotsMin = 0.8;
			betweenShotsMax = 1.3;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "rifle";
			break;
			
		case "allies_smg":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_thompson_fire";
			}
			else
			{
				fireSound = "weap_ppsh_fire";
			}
			
			burstMin = 14;
			burstMax = 28;
			betweenShotsMin = 0.08;
			betweenShotsMax = 0.12;
			reloadTimeMin = 2;
			reloadTimeMax = 5;
			soundChance = 75;
			weapType = "smg";
			break;
			
		case "axis_smg":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_mp40_fire";
			}
			else
			{
				fireSound = "weap_type100_fire";
			}
			
			burstMin = 14;
			burstMax = 28;
			betweenShotsMin = 0.08;
			betweenShotsMax = 0.12;
			reloadTimeMin = 2;
			reloadTimeMax = 5;
			soundChance = 75;
			weapType = "smg";
			break;
			
		case "allies_turret":
		
			if(isDefined(level.allies_team) && (level.allies_team == "marines"))
			{
				fireSound = "weap_30cal_fire";
			}
			else
			{
				fireSound = "weap_dp28_fire_plr";
			}
			
			burstMin = 60;
			burstMax = 90;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "turret";
			break;
			
		case "axis_turret":
		
			if(isDefined(level.axis_team) && (level.axis_team == "german"))
			{
				fireSound = "weap_bar_fire"; //update this if the sound changes
			}
			else
			{
				fireSound = "weap_type92_fire";
			}
			
			burstMin = 60;
			burstMax = 90;
			betweenShotsMin = 0.05;
			betweenShotsMax = 0.08;
			reloadTimeMin = 3;
			reloadTimeMax = 6;
			soundChance = 95;
			weapType = "turret";
			break;

		default:
			ASSERTMSG("Ambient Fakefire: Weapon Info '" + point.weaponinfo + "' is not recognized.");
	}

	while(1)
	{
		// burst fire
		burst = randomIntRange(burstMin, burstMax);

		for(i = 0; i < burst; i++)
		{
			traceDist = 10000;
			
			target = point.origin + VectorScale(anglesToForward(point.angles + (-3 + randomInt(6), -5 + randomInt(10), 0)), traceDist);

			// -- not using real weaponsettings
			if ( randomInt(100) <= 20 )
			{
				bulletTracer(point.origin, target);
			}
			
			playFX(0, level._effect[point.fx_id], point.origin, point.forward);

			// snyder steez - reduce popcorn effect
//			if(randomInt(100) <= soundChance)
//			{
//				thread play_sound_in_space(0, fireSound, point.origin);
//			}

			wait (randomFloatRange(betweenShotsMin, betweenShotsMax));
		}

		wait (randomFloatRange(reloadTimeMin, reloadTimeMax));
	}
}

ceiling_fans_init(clientNum)
{
	// grab all of the ceiling fans and make them spin
	fan_array = GetEntArray(clientNum, "ceiling_fan", "targetname");
	if( IsDefined(fan_array) )
	{
	/#	println("**********fan array is defined, size: " + fan_array.size);	#/
		array_thread( fan_array, ::spin_fan );
	}
}

spin_fan() // self == fan from the array
{
	self endon("entityshutdown");

	//println("**********fan running");
	// get the speed from the fan, if no speed then make it random
	if ( !IsDefined ( self.speed ) )
	{
		self.speed = RandomIntRange(1, 100);
		self.speed = (self.speed % 10) + 1;
	}
	if ( self.speed < 1 )
	{
		self.speed = RandomIntRange(1, 100);
		self.speed = (self.speed % 10) + 1;
	}

	// see if they want it to wobble
	do_wobble = false;
	wobble = self.script_noteworthy;
	if( IsDefined(wobble) )
	{
		if( wobble == "wobble" )
		{
			do_wobble = true;
			self.wobble_speed = self.speed * 0.5;
		}
	}

	//println("**********fan speed: " + self.speed);
	//println("**********fan wobble: " + do_wobble);

	while(true)
	{
		if( !do_wobble )
		{
			self RotateYaw(180, self.speed);
			self waittill("rotatedone");
		}
		else
		{
			self RotateYaw(340, self.speed);
			self waittill("rotatedone");
			self RotateYaw(20, self.wobble_speed);
			self waittill("rotatedone");
		}
	}
}


clocks_init(clientNum)
{
	// the format should be an array (hour, min, sec), military time
	//	if we pass in a 1 then we'll get GMT 0 London time, else we get the local time on the kit
	curr_time = GetSystemTime();

	// put the hands in the right place
	hours = curr_time[0];
	if( hours > 12 )
	{
		hours -= 12;
	}
	if( hours == 0 )
	{
		hours = 12;
	}
	minutes = curr_time[1];
	seconds = curr_time[2];
	
	// set the starting time
	// hoping that all of the hands start pointing straight up at 12
	// each hour is 30 degrees of rotation ...
	//	it should also rotate a little bit each time the minute hand moves
	//	the math is 30 degrees of rotations in 3600 seconds (1 hour)
	hour_hand = GetEntArray(clientNum, "hour_hand", "targetname");
	hour_values = [];
	hour_values["hand_time"] = hours;
	hour_values["rotate"] = 30;
	hour_values["rotate_bit"] = 30 / 3600;
	// we need to do the first rotation based on the beginning time, if we don't do this the time will look like it's off a little bit
	hour_values["first_rotate"] = ((minutes * 60) + seconds) * hour_values["rotate_bit"];
	
	// each minute is 6 degrees of rotation ...
	//	it should also rotate a little bit each time the second hand moves
	//	the math is 6 degrees of rotations in 60 seconds (1 minute)
	minute_hand = GetEntArray(clientNum, "minute_hand", "targetname");
	minute_values = [];
	minute_values["hand_time"] = minutes;
	minute_values["rotate"] = 6;
	minute_values["rotate_bit"] = 6 / 60;
	// we need to do the first rotation based on the beginning time, if we don't do this the time will look like it's off a little bit
	minute_values["first_rotate"] = seconds * minute_values["rotate_bit"];

	// each second is 6 degrees of rotation
	second_hand = GetEntArray(clientNum, "second_hand", "targetname");
	second_values = [];
	second_values["hand_time"] = seconds;
	second_values["rotate"] = 6;
	second_values["rotate_bit"] = 6;

	hour_hand_array = GetEntArray(clientNum, "hour_hand", "targetname");
	if( IsDefined(hour_hand_array) )
	{
	/#	println("**********hour_hand_array is defined, size: " + hour_hand_array.size);	#/
		array_thread( hour_hand_array, ::clock_run, hour_values );
	}
	minute_hand_array = GetEntArray(clientNum, "minute_hand", "targetname");
	if( IsDefined(minute_hand_array) )
	{
	/#	println("**********minute_hand_array is defined, size: " + minute_hand_array.size);	#/
		array_thread( minute_hand_array, ::clock_run, minute_values );
	}
	second_hand_array = GetEntArray(clientNum, "second_hand", "targetname");
	if( IsDefined(second_hand_array) )
	{
	/#	println("**********second_hand_array is defined, size: " + second_hand_array.size);	#/
		array_thread( second_hand_array, ::clock_run, second_values );
	}

}

clock_run(time_values) // self == either hour hand, minute hand, or second hand
{
	self endon("entityshutdown");

	// hour hands will have script_noteworthy = time zone if they want a different time zone
	if( IsDefined(self.script_noteworthy) )
	{
		hour = time_values["hand_time"];
		curr_time = GetSystemTime(1);

		switch( ToLower(self.script_noteworthy) )
		{
		case "honolulu":	// GMT -10
			hour = curr_time[0] - 10;
			break;
		case "alaska":		// GMT -9
			hour = curr_time[0] - 9;
			break;
		case "los angeles":	// GMT -8
			hour = curr_time[0] - 8;
			break;
		case "denver":		// GMT -7
			hour = curr_time[0] - 7;
			break;
		case "chicago":		// GMT -6
			hour = curr_time[0] - 6;
			break;
		case "new york":	// GMT -5
			hour = curr_time[0] - 5;
			break;
		case "halifax":		// GMT -4
			hour = curr_time[0] - 4;
			break;
		case "greenland":	// GMT -3
			hour = curr_time[0] - 3;
			break;
		case "london":		// GMT 0
			hour = curr_time[0];
			break;
		case "paris":		// GMT +1
			hour = curr_time[0] + 1;
			break;
		case "helsinki":	// GMT +2
			hour = curr_time[0] + 2;
			break;
		case "moscow":		// GMT +3
			hour = curr_time[0] + 3;
			break;
		case "vietnam":		// GMT +7
			hour = curr_time[0] + 7;
			break;
		case "china":		// GMT +8
			hour = curr_time[0] + 8;
			break;
		}

		if( hour < 1 )
		{
			hour += 12;
		}
		if( hour > 12 )
		{
			hour -= 12;
		}
		time_values["hand_time"] = hour;
	}

	self RotatePitch(time_values["hand_time"] * time_values["rotate"], 0.05);
	self waittill("rotatedone");
	
	if( IsDefined(time_values["first_rotate"]) )
	{
		self RotatePitch(time_values["first_rotate"], 0.05);
		self waittill("rotatedone");
	}

	prev_time = GetSystemTime();

	while(true)
	{
		curr_time = GetSystemTime();
		if( prev_time != curr_time )
		{
			self RotatePitch(time_values["rotate_bit"], 0.05);

			prev_time = curr_time;
		}

		wait(1.0);
	}
}

//Makes it so anemometers will spin whenever builders drop them into their map
spin_anemometers( clientNum )
{
	spoon_spinners = GetEntArray(clientNum, "spinner1","targetname");
	flat_spinners = GetEntArray( clientNum, "spinner2","targetname");
	
	if( IsDefined( spoon_spinners ))
	{
	/#	println("**********spoon_spinners is defined, size: " + spoon_spinners.size);	#/
		array_thread( spoon_spinners, ::spoon_spin_func);	
	}
	
	if( IsDefined( flat_spinners ))
	{
	/#	println("**********flat_spinners is defined, size: " + flat_spinners.size);		#/
		array_thread( flat_spinners, ::arrow_spin_func);
	}

}

//Self is the "spoon" like script model within the anemometer
spoon_spin_func()
{
	self endon( "entityshutdown" );
	
	if(IsDefined( self.script_float))
	{
		model_speed = self.script_float;
	}
	else
	{
		model_speed = 2;
	}
	
	while(1)
	{
		speed = RandomFloatRange( model_speed * .6, model_speed);
		self RotateYaw( 1200, speed);
		self waittill ("rotatedone");
	}
}

//Self is the "arrow" like script model within the anemometer
arrow_spin_func()
{
	self endon( "entityshutdown" );
	
	if(IsDefined( self.script_int))
	{
		model_direction_change = self.script_int;
	}
	else
	{
		model_direction_change = 25;
	}
	
	if(IsDefined( self.script_float))
	{
		model_speed = self.script_float;
	}
	else
	{
		model_speed = .8;
	}
	
	while(1)
	{
		direction_change = model_direction_change + RandomIntRange(-11, 11);
		speed_change = RandomFloatRange(model_speed * .3, model_speed);
		
		self RotateYaw( direction_change, speed_change);
		self waittill ("rotatedone");
		self RotateYaw( (direction_change * -1), speed_change);
		self waittill ("rotatedone");
	}
}