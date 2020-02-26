/*
Elevators and You: A Consice Guide.
Bloodlust

First place a script_model or create a script_brushmodel to be used for the elevator platform.

Make a trigger_use if you want a switch operated elevator.
Make a trigger_multiple if you want a Quake style elevator.

Give this trigger a targetname of elevator_trigger.

If making a switch operated elevator, place a script_model or script_brushmodel in the map where you want the switch.
Make the trigger target the newly created switch entity.

If making a Quake style elevator, make the trigger target the elevator platform entity.

Place a script_struct dead center of the platform entity at the bottom point in the platform's route.
Place a script_struct dead center of the platform entity at the next point in the platform's route.
Continue placing script_structs dead center of the platform entity at the next point in the platform's route.
These can be placed in any direction, not just straight up and down. Just ensure the platform will center on them.

Give the bottom script_struct a script_noteworthy of platform_start.
Make the platform entity target this script_struct.
Make this script_struct target the next script_struct in the elevator's path.
Continue making the elevator's path by targeting the path script_structs to eachother.


Optional:

If you want to play hydraulic or machinery sounds for the elevator, place a script_struct where you want the sound to play.
Make the platform target this script_struct.
Give this script_struct a script_noteworthy of audio_point.
Define a variable in your level script of level.scr_sound["description"] = "actual_sound_alias".
The "description" can be any description you want to use, such as "hydraulics".
the "actual_sound_alias" must be an actual sound alias defined in your level's csv or a common csv.
Give this script_struct a script_sound of whatever you defined as "description".
You can place as many script_structs this way as you want.


Optional:

If you want an alarm sound to play when the elevator is activated, place a script_model or script_brushmodel where you want the sound to play.
Make the platform target this entity.
Give this entity a script_noteworthy of elevator_klaxon_speaker.
Define a variable in your level script of level.scr_sound["description"] = "actual_sound_alias".
The "description" can be any description you want to use, such as "alarm_sound".
the "actual_sound_alias" must be an actual sound alias defined in your level's csv or a common csv.
Give this entity a script_sound of whatever you defined as "description".
You can place as many entities this way as you want.


Optional:

If you want a gate or gates to animate when the elevator is activated, place a script_model or script_brushmodel to use as the gate.
Do NOT rotate the gate or place it where you want the gate to be. This will be handled by the _elevator.gsc utility script.
Make the platform target this gate.
Give this gate a script_noteworthy of elevator_gate.
Give this gate a script_int equal to the amount of degrees you want it to rotate, ie: 90
Place a script_struct where you want the gate to be centered and have the gate target this script_struct.
Rotate this script_struct in the direction you want the gate to move.
You can place as many gates per elevator this way as you want.

Define a variable in your level script of level.scr_sound["description"] = "actual_sound_alias".
The "description" can be any description you want to use, such as "gate_rotate".
the "actual_sound_alias" must be an actual sound alias defined in your level's csv or a common csv.
Give this gate a script_sound of whatever you defined as "description".


Optional:

If you dont specify a speed for your elevator platform in Radiant, it will default to 100.
To set the speed, make a K/V pair of speed / 100 (or whatever speed you want).
Each individual platform can have a different speed set to it if you want.
This is the speed of the platform in MPH.
Do not set a speed K/V pair on the script_struct that the platform targets;
set it on THAT script_struct's target instead.
You can then set any positive whole number value for speed on the rest of the script_structs that make up the elevator's path if you want to.

If you dont specify a speed for your elevator platform gates in Radiant, it will default to 1.
This is how many seconds the platform gates, if you included any in your level, will take to rotate when they are raised or lowered.
To set the speed, make a K/V pair of speed / 1 (or whatever speed you want).
This speed should be defined in seconds, not actual speed in MPH like the platforms.
This speed must also be a whole number, no fractions!

If you dont specify an amount of degrees for your elevator platform gates to rotate in Radiant, it will default to 90.
To set the desired amount of angles, make a K/V pair of script_int / 90 (or whatever angle you want).
Each individual platform can have a different angle set to it if you want.


Notes of Interest:

Platforms and platform switches must be either a script_model or a script_brushmodel.
You can use a prefab for the platform that actually moves, but you must stamp it into your level.
You cannot have a trigger or switch target a prefab.

You can setup the elevator and all its parts, then save this as a prefab, and copy and paste
this prefab into the level where ever you want to. Be certain that your platform triggers inside the prefab retain their
targetname of elevator_trigger though, as it may change when you make the prefab and paste it around the level.
*/

#include maps\mp\_utility;
#include common_scripts\utility;
init()
{
	platform_triggers = getEntArray("elevator_trigger", "targetname");
	if(platform_triggers.size <= 0)
	{
		return;
	}
	
	platform_switches = [];
	platforms_non_switched = [];
	platforms_total = [];
	trigger_target_targets = [];
	
	for(i = 0; i < platform_triggers.size; i++)
	{
		trigger_target = getEnt(platform_triggers[i].target, "targetname");
		
		if(!isDefined(trigger_target))
		{
			AssertMsg("This trigger does not have a target: " + platform_triggers[i].origin);
		}
		
		// does the trigger target a switch model or just a platform?
		if(isDefined(trigger_target))
		{
			trigger_target_targets = getEntArray(trigger_target.target, "targetname");
			
			// if the trigger's target has only 1 target, then the trigger is targeting a switch model, not a platform
			if(isDefined(trigger_target_targets) && (trigger_target_targets.size == 1))
			{
				platform_switches[platform_switches.size] = trigger_target;
			}
			else
			{
				platforms_non_switched[platforms_non_switched.size] = trigger_target;
			}
		}
	}

	for(i = 0; i < platform_switches.size; i++)
	{
		platform = getEnt(platform_switches[i].target, "targetname");
		
		if(!isDefined(platform))
		{
			AssertMsg("This switch does not target a platform: " + platform_switches[i].origin);
		}
		else
		{
			counter = 0;
			
			for(x = 0; x < platforms_total.size; x++)
			{
				if(platform == platforms_total[x])
				{
					counter++;
				}
			}
			
			if(counter > 0)
			{
				continue;
			}
			else
			{
				platforms_total[platforms_total.size] = platform;
			}
		}
	}
	
	for(i = 0; i < platforms_non_switched.size; i++)
	{
		counter = 0;
		
		for(x = 0; x < platforms_total.size; x++)
		{
			if(platforms_non_switched[i] == platforms_total[x])
			{
				counter++;
			}
		}
		
		if(counter > 0)
		{
			continue;
		}
		else
		{
			platforms_total[platforms_total.size] = platforms_non_switched[i];
		}
	}
	
	array_thread(platforms_total, ::define_elevator_parts);
}

// self = the platform
define_elevator_parts()
{
	audio_points = [];
	klaxon_speakers = [];
	elevator_gates = [];
	platform_start = undefined;
	
	platform = self;
	platform_name = platform.targetname;
	platform.at_start = true;
	
	platform_triggers = [];
	targets_platform = getEntArray(platform_name, "target");
	
	
	for(i = 0; i < targets_platform.size; i++)
	{
		if(targets_platform[i].classname == "script_model" || targets_platform[i].classname == "script_brushmodel")
		{
			switch_trigger = getEnt(targets_platform[i].targetname, "target");
			platform_triggers[platform_triggers.size] = switch_trigger;
		}
		else
		{
			platform_triggers[platform_triggers.size] = targets_platform[i];
		}
	}
	
	platform_targets_Ents = getEntArray(platform.target, "targetname");
	platform_targets_Structs = getStructArray(platform.target, "targetname");	
	platform_targets = array_combine(platform_targets_Ents, platform_targets_Structs);
	
	if(platform_targets.size <= 0)
	{
		AssertMsg("This platform does not have any targets: " + platform.origin);
	}
			
	if(isDefined(platform_targets))
	{
		for(i = 0; i < platform_targets.size; i++)
		{
			if(isDefined(platform_targets[i].script_noteworthy))
			{
				if(platform_targets[i].script_noteworthy == "audio_point")
				{
					audio_points[audio_points.size] = platform_targets[i];
				}
				
				if(platform_targets[i].script_noteworthy == "elevator_gate")
				{
					elevator_gates[elevator_gates.size] = platform_targets[i];
				}
				
				if(platform_targets[i].script_noteworthy == "elevator_klaxon_speaker")
				{
					klaxon_speakers[klaxon_speakers.size] = platform_targets[i];
				}
								
				if(platform_targets[i].script_noteworthy == "platform_start")
				{
					platform_start = platform_targets[i];
				}
			}
		}
	}
	
	if(!isDefined(platform_start))
	{
		AssertMsg("This platform does not target a script_struct with a script_noteworthy of platform_start: " + platform.origin);
	}
	
	if(isDefined(elevator_gates) && (elevator_gates.size >0))
	{
		array_thread(elevator_gates, ::setup_elevator_gates, platform_name);
	}
	
	if(isDefined(klaxon_speakers) && (klaxon_speakers.size >0))
	{
		array_thread(klaxon_speakers, ::elevator_looping_sounds, "elevator_" + platform_name + "_move", "stop_" + platform_name + "_movement_sound");
	}
	
	if(isDefined(audio_points) && (audio_points.size >0))
	{
		array_thread(audio_points, ::elevator_looping_sounds, "start_" + platform_name + "_klaxon", "stop_" + platform_name + "_klaxon");
	}
	
	array_thread(platform_triggers, ::trigger_think, platform_name);
	
	platform thread move_platform(platform_start, platform_name);
}

// each seperate platform trigger in the level is run through this function
// self = the trigger
trigger_think(platform_name)
{
	while(1)
	{
		self waittill("trigger");
		
		// start the platform motion klaxon alarm
		level notify("start_" + platform_name + "_klaxon");
		
		wait 2;
		
		// start the platform moving
		level notify("elevator_" + platform_name + "_move");
		
		level waittill("elevator_" + platform_name + "_stop");
		
		// stop the platform motion klaxon alarm
		level notify("stop_" + platform_name + "_klaxon");
	}
}

// play any looping sounds if its defined by self.script_sound
// self = the entity to play the sound at its origin
elevator_looping_sounds(notify_play, notify_stop)
{
	level waittill(notify_play);
	
	if(isDefined(self.script_sound))
	{
		self thread loop_sound_in_space(level.scr_sound[self.script_sound], self.origin, notify_stop);
	}
}

// self = the gate
setup_elevator_gates(platform_name)
{
	struct = getStruct(self.target, "targetname");
	if(!isDefined(struct))
	{
		AssertMsg("This gate does not target a script_struct: " + self.origin);
	}
	
	self.origin = struct.origin;
	self.angles = struct.angles;
	
	self thread move_elevator_gates(platform_name, "raise_");
	self thread move_elevator_gates(platform_name, "lower_");
}

// self = the gate
move_elevator_gates(platform_name, direction)
{
	// amount of degrees to rotate the gate
	amount = undefined;
	// speed at which to rotate the gate
	speed = undefined;
	
	if(isDefined(self.script_int))
	{
		amount = (self.script_int);
	}
	else
	{
		amount = (90);
	}
	
	if(direction == "raise_")
	{
		amount = (amount * -1);
	}
	
	if(isDefined(self.script_delay))
	{
		speed = self.script_delay;
	}
	else
	{
		speed = 1;
	}
	
	while(1)
	{
		level waittill(direction + platform_name + "_gates");
		self rotatePitch(amount, speed);
	}
}

// self = the platform
move_platform(platform_start, platform_name)
{
	move_up = [];
	move_down = [];
	
	move_up[move_up.size] = platform_start;
	
	platform_start_first_target = getStruct(platform_start.target, "targetname");
	
	if(!isDefined(platform_start_first_target))
	{
		AssertMsg("This platform start point does not have a script_struct target to move to. There needs to be at least two script_structs to make a path for the elevator to move along: " + platform_start.origin);
	}
	
	path = true;
	pstruct = platform_start;
	
	while(path)
	{
		if(isDefined(pstruct.target))
		{
			pstruct = getStruct(pstruct.target, "targetname");
		
			if(isDefined(pstruct))
			{
				move_up[move_up.size] = pstruct;
			}
		}
		else
		{
			path = false;
		}
	}
	
	for(i = move_up.size - 1; i >= 0; i--)
	{
		move_down[move_down.size] = move_up[i];
	}
	
	while(1)
	{
		level waittill("elevator_" + platform_name + "_move");
		
		wait 2;
		
		if(isDefined(level.scr_sound["elevator_start"]))
		{
			self playSound(level.scr_sound["elevator_start"]);
		}
		
		if(self.at_start)
		{
			speed = -1;
			
			for(i = 0; i < move_up.size; i++)
			{
				org = move_up[i + 1];
				
				if(isDefined(org))
				{
					speed = get_speed(org, speed);
					
					// convert speed to a time
					time = distance(self.origin, org.origin) / speed;
					self moveto(org.origin, time);
					wait time;
				}
			}
			
			// play any metal screeching / groaning sounds if assigned
			if(isDefined(self.script_sound))
			{
				self playSound(level.scr_sound[self.script_sound]);
			}
			
			level notify("elevator_" + platform_name + "_stop");
			level notify("stop_" + platform_name + "_movement_sound");	
			level notify("stop_" + platform_name + "_klaxon");
			level notify("lower_" + platform_name + "_gates");
			
			if(isDefined(level.scr_sound["elevator_end"]))
			{
				self playSound(level.scr_sound["elevator_end"]);
			}
			
			self.at_start = false;
		}
		else
		{
			level notify("raise_" + platform_name + "_gates");
			
			wait 2;
			
			level notify("elevator_" + platform_name + "_move");
			
			if(isDefined(level.scr_sound["elevator_start"]))
			{
				self playSound(level.scr_sound["elevator_start"]);
			}
			
			speed = -1;
			
			for(i = 0; i < move_down.size; i++)
			{
				org = move_down[i + 1];
				
				if(isDefined(org))
				{
					speed = get_speed(org, speed);
					
					// convert speed to a time
					time = distance(self.origin, org.origin) / speed;
					self moveto(org.origin, time);
					wait time;
				}
			}
			
			// play any metal screeching / groaning sounds if assigned
			if(isDefined(self.script_sound))
			{
				self playSound(level.scr_sound[self.script_sound]);
			}

			level notify("elevator_" + platform_name + "_stop");
			level notify("stop_" + platform_name + "_movement_sound");	
			level notify("stop_" + platform_name + "_klaxon");
			
			if(isDefined(level.scr_sound["elevator_end"]))
			{
				self playSound(level.scr_sound["elevator_end"]);
			}
			
			self.at_start = true;
		}
	}
}

// check if a speed is defined on the current path point script_struct
get_speed(path_point, speed)
{
	if(speed <= 0)
	{
		speed = 100;
	}
	
	if(isDefined(path_point.speed))
	{
		speed = path_point.speed;
	}
	
	return speed;
}