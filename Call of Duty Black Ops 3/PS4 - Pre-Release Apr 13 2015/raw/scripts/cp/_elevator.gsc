#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_skipto;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

/*
Elevators and You: A Consice Guide.
Bloodlust

=== FOR ELEVATORS =================================
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

If you want a door or doors to animate when the elevator is activated, place a script_model or script_brushmodel to use as the door.
Make the platform target this door.
Give this door a script_noteworthy of elevator_door.
Place the door in its OPEN position and place a script_struct that aligns with the origin and angles of the door.
Have the door target this script_struct.
Place another script_struct that aligns with the origin and angles of the door when it is CLOSED.
Have the script_struct for the OPEN position target the script_struct for the CLOSED position.
If you want the door to stay closed, add a script_noteworthy key of "stay_closed"
You can place as many doors per elevator this way as you want.

Define a variable in your level script of level.scr_sound["description"] = "actual_sound_alias".
The "description" can be any description you want to use, such as "door_rotate".
the "actual_sound_alias" must be an actual sound alias defined in your level's csv or a common csv.
Give this door a script_sound of whatever you defined as "description".


Optional:

If you dont specify a speed for your elevator platform in Radiant, it will default to 100.
function To set the speed, make a K/V pair of speed / 100 (or whatever speed you want).
Each individual platform can have a different speed set to it if you want.
This is the speed of the platform in MPH.
Do not set a speed K/V pair on the script_struct that the platform targets;
set it on THAT script_struct's target instead.
You can then set any positive whole number value for speed on the rest of the script_structs that make up the elevator's path if you want to.

If you dont specify a speed for your elevator platform doors in Radiant, it will default to 1.
This is how many seconds the platform doors, if you included any in your level, will take to open/close.
function To set the speed, make a K/V pair of speed / 1 (or whatever speed you want).
This speed should be defined in seconds, not actual speed in MPH like the platforms.
This speed must also be a whole number, no fractions!


Notes of Interest:

Platforms and platform switches must be either a script_model or a script_brushmodel.
You can use a prefab for the platform that actually moves, but you must stamp it into your level.
You cannot have a trigger or switch target a prefab.

You can setup the elevator and all its parts, then save this as a prefab, and copy and paste
this prefab into the level where ever you want to. Be certain that your platform triggers inside the prefab retain their
targetname of elevator_trigger though, as it may change when you make the prefab and paste it around the level.
*/

#namespace elevator;

function autoexec __init__sytem__() {     system::register("elevator",&__init__,undefined,undefined);    }

function __init__()
{
	platform_triggers = GetEntArray( "elevator_trigger", "targetname" );

	if ( platform_triggers.size <= 0 )
	{
		return;
	}

	platform_switches = [];
	platforms_non_switched = [];
	platforms_total = [];
	trigger_target_targets = [];

	for ( i = 0; i < platform_triggers.size; i++ )
	{
		a_trigger_targets = GetEntArray( platform_triggers[i].target, "targetname" );

		for ( j = 0; j < a_trigger_targets.size; j++ )
		{
			if ( a_trigger_targets[ j ].classname == "script_brushmodel" )
			{
				trigger_target = a_trigger_targets[ j ];
				break;
			}
		}

		if ( !isdefined( trigger_target ) )
		{
			AssertMsg( "This trigger does not have a target: " + platform_triggers[i].origin );
		}

		// does the trigger target a switch model or just a platform?
		if ( isdefined( trigger_target ) )
		{
			trigger_target_targets = GetEntArray( trigger_target.target, "targetname" );
			platforms_non_switched[platforms_non_switched.size] = trigger_target;
		}
	}

	for ( i = 0; i < platform_switches.size; i++ )
	{
		platform = getEnt( platform_switches[i].target, "targetname" );

		if ( !isdefined( platform ) )
		{
			AssertMsg( "This switch does not target a platform: " + platform_switches[i].origin );
		}
		else
		{
			counter = 0;

			for ( x = 0; x < platforms_total.size; x++ )
			{
				if ( platform == platforms_total[x] )
				{
					counter++;
				}
			}

			if ( counter > 0 )
			{
				continue;
			}
			else
			{
				platforms_total[platforms_total.size] = platform;
			}
		}
	}

	for ( i = 0; i < platforms_non_switched.size; i++ )
	{
		counter = 0;

		for ( x = 0; x < platforms_total.size; x++ )
		{
			if ( platforms_non_switched[i] == platforms_total[x] )
			{
				counter++;
			}
		}

		if ( counter > 0 )
		{
			continue;
		}
		else
		{
			platforms_total[platforms_total.size] = platforms_non_switched[i];
		}
	}

	array::thread_all( platforms_total, &define_elevator_parts, false );
}

// self = the platform
function define_elevator_parts()
{
	self SetMovingPlatformEnabled( true );
	
	audio_points = [];
	klaxon_speakers = [];
	elevator_doors = [];
	platform_start = undefined;
	platform = self;
	platform_name = platform.targetname;
	platform.at_start = true;
	platform_triggers = [];
	targets_platform = GetEntArray( platform_name, "target" );
	n_start_delay = 0;

	for ( i = 0; i < targets_platform.size; i++ )
	{
		if ( targets_platform[i].classname == "script_model" || targets_platform[i].classname == "script_brushmodel" )
		{
			switch_trigger = getEnt( targets_platform[i].targetname, "target" );
			platform_triggers[platform_triggers.size] = switch_trigger;
		}
		else
		{
			platform_triggers[platform_triggers.size] = targets_platform[i];
		}
	}

	platform_targets_Ents = GetEntArray( platform.target, "targetname" );
	platform_targets_Structs = struct::get_array( platform.target, "targetname" );
	platform_targets = ArrayCombine( platform_targets_Ents, platform_targets_Structs, true, false );

	if ( platform_targets.size <= 0 )
	{
		AssertMsg( "This platform does not have any targets: " + platform.origin );
	}

	if ( isdefined( platform_targets ) )
	{
		for ( i = 0; i < platform_targets.size; i++ )
		{
			if ( isdefined( platform_targets[i].script_noteworthy ) )
			{
				if ( platform_targets[i].script_noteworthy == "audio_point" )
				{
					audio_points[audio_points.size] = platform_targets[i];
				}

				if ( platform_targets[i].script_noteworthy == "elevator_door" )
				{
					elevator_doors[elevator_doors.size] = platform_targets[i];
				}

				if ( platform_targets[i].script_noteworthy == "elevator_klaxon_speaker" )
				{
					klaxon_speakers[klaxon_speakers.size] = platform_targets[i];
				}

				if ( platform_targets[i].script_noteworthy == "platform_start" )	// the 1st struct in the elevator path
				{
					platform_start = get_start_point_in_path( platform_targets[i] );// potential BLOCKING call
				}
			}
		}
	}

	if ( !isdefined( platform_start ) )
	{
		AssertMsg( "This platform does not target a script_struct with a script_noteworthy of platform_start: " + platform.origin );
	}

	if ( isdefined( elevator_doors ) && ( elevator_doors.size > 0 ) )
	{
		array::thread_all( elevator_doors, &setup_elevator_doors, platform_name, platform );
	}

	if ( isdefined( klaxon_speakers ) && ( klaxon_speakers.size > 0 ) )
	{
		array::thread_all( klaxon_speakers, &elevator_looping_sounds, "elevator_" + platform_name + "_move", "stop_" + platform_name + "_movement_sound" );
	}

	if ( isdefined( audio_points ) && ( audio_points.size > 0 ) )
	{
		array::thread_all( audio_points, &elevator_looping_sounds, "start_" + platform_name + "_klaxon", "stop_" + platform_name + "_klaxon" );
	}

	array::thread_all( platform_triggers, &trigger_think, platform_name );
	platform.loop_snd_ent = spawn( "script_origin", self.origin );
	platform.loop_snd_ent linkto (self);
	platform thread move_platform( platform_start, platform_name, n_start_delay );
}

function get_start_point_in_path( s_start_point )
{
	s_platform_start = s_start_point;

	if( IsDefined( s_platform_start.script_objective ) )	// if a script_objective KVP exists on the 1st path struct...
	{
		world flag::wait_till( "skipto_player_connected" );	// wait for the skipto system to populate its info
		waittillframeend;
	
		if( level flag::get( s_platform_start.script_objective + "_completed" ) )	// if we're past the checkpoint specified on the platform start struct...
		{
			while( true )
			{
				if( IsDefined( s_platform_start.target ) )		// loop through the rest of the elevator path...
				{
					s_platform_start = struct::get( s_platform_start.target, "targetname" );
				}
				else
				{
					break;	// reached the end of the elevator path w/out finding a match, so platform_start is set to the last point in the path
				}
				
				if( IsDefined( s_platform_start.script_objective ) )	// and try to find a path struct with a script_objective KVP matching the current skipto
				{
					if( s_platform_start.script_objective == level.current_skipto )
					{
						break;
					}
				}			
			}
		}
	}
	
	if( IsDefined( s_platform_start.script_wait ) )
	{
		n_start_delay = s_platform_start.script_wait;
	}
			
	return s_platform_start;
}

// each seperate platform trigger in the level is run through this function
// self = the trigger
function trigger_think( platform_name )
{
	self endon( "death" );
	level endon( platform_name + "_disabled" );
	
	if( IsDefined( level.heroes ) && IsDefined( self.script_string ) && self.script_string == "all_heroes" )
	{
		self thread wait_for_all_heroes( platform_name );
	}
	
	while ( true )
	{
		self trigger::wait_till();
		
		// start the platform motion klaxon alarm
		level notify( "start_" + platform_name + "_klaxon" );
		level notify( "close_" + platform_name + "_doors" );
		
		if( IsDefined( self.script_wait ) )
		{
			wait self.script_wait;
		}
		else
		{
			wait 2;
		}
		
		// start the platform moving
		level notify( "elevator_" + platform_name + "_move" );
		
		level waittill( "elevator_" + platform_name + "_stop" );
		// stop the platform motion klaxon alarm
		level notify( "stop_" + platform_name + "_klaxon" );
		level notify( "open_" + platform_name + "_doors" );				
	}
}

// self = the trigger
function wait_for_all_heroes( platform_name )
{
	level endon( "elevator_" + platform_name + "_move" );
	level endon( platform_name + "_disabled" );

	heroes_present = false;
	wait 1;
	
	while( true )
	{
		heroes_present = true;
		foreach( hero in level.heroes )
		{
			heroes_present &= hero IsTouching( self );
		}
		if( heroes_present )
		{
			self TriggerEnable( true );
		}
		else
		{
			self TriggerEnable( false );
		}
		wait 0.2;
	}
}

// play any looping sounds if its defined by self.script_sound
// self = the entity to play the sound at its origin
function elevator_looping_sounds( notify_play, notify_stop )
{
	level waittill( notify_play );

	if ( isdefined( self.script_sound ) )
	{
		self thread sound::loop_in_space( level.scr_sound[self.script_sound], self.origin, notify_stop );
	}
}

// self = the door
function setup_elevator_doors( platform_name, platform )
{
	open_struct = struct::get( self.target, "targetname" );
	if ( !isdefined( open_struct ) )
	{
		AssertMsg( "This door does not target a script_struct for its OPEN POSITION: " + self.origin );
	}
	
	if( IsDefined( open_struct.target ) )
	{
		closed_struct = struct::get( open_struct.target, "targetname" );
	}
	if ( !isdefined( closed_struct ) )
	{
		AssertMsg( "This door does not have a script_struct for its CLOSED POSITION: " + self.origin );
	}
	
	if( IsDefined( open_struct.script_float ) )
	{
		n_opening_time = open_struct.script_float;
	}
	else
	{
		n_opening_time = 1;
	}
	if( IsDefined( closed_struct.script_float ) )
	{
		n_closing_time = closed_struct.script_float;
	}
	else
	{
		n_closing_time = 1;
	}
	stay_closed = false;
	if( IsDefined( closed_struct.script_noteworthy ) && closed_struct.script_noteworthy == "stay_closed" )
	{
		stay_closed = true;
	}
	
	self.origin = open_struct.origin;
	self.angles = open_struct.angles;
	v_move_to_close = closed_struct.origin - self.origin;
	v_angles_to_close = closed_struct.angles - self.angles;
	v_move_to_open = self.origin - closed_struct.origin;
	v_angles_to_open = self.angles - closed_struct.angles;
	
	self thread move_elevator_doors( platform_name, "close_", platform, v_move_to_close, v_angles_to_close, n_closing_time );
	if( !stay_closed )
	{
		self thread move_elevator_doors( platform_name, "open_", platform, v_move_to_open, v_angles_to_open, n_opening_time );
	}
}

// self = the door
function move_elevator_doors( platform_name, direction, platform, v_moveto, v_angles, n_time )
{
	level endon( platform_name + "_disabled" );
	
	self LinkTo( platform );
	
	while ( 1 )
	{
		level waittill( direction + platform_name + "_doors" );
		self Unlink();
		self moveto( self.origin + v_moveto, n_time );
		self RotateTo( self.angles + v_angles, n_time );
		wait n_time;
		self LinkTo( platform );
	}
}

// self = the platform
function move_platform( platform_start, platform_name, n_start_delay )
{
	level endon( platform_name + "_disabled" );
	
	move_up = [];
	move_down = [];
	
	if( IsDefined( platform_start.script_objective ) )
	{
		self.origin = platform_start.origin;
		self.angles = platform_start.angles;
	}
	self.platform_name = platform_name;
	
	move_up[move_up.size] = platform_start;
	
	if( IsDefined( platform_start.target ) )
	{
		platform_start_first_target = struct::get( platform_start.target, "targetname" );
	}
	
	if ( !isdefined( platform_start_first_target ) )
	{
		return;	// there's no path to run, so do nothing
	}	

	path = true;
	pstruct = platform_start;

	while ( path )
	{
		if ( isdefined( pstruct.target ) )
		{
			pstruct = struct::get( pstruct.target, "targetname" );

			if ( isdefined( pstruct ) )
			{
				move_up[move_up.size] = pstruct;
			}
		}
		else
		{
			path = false;
		}
	}

	for ( i = move_up.size - 1; i >= 0; i-- )
	{
		move_down[move_down.size] = move_up[i];
	}

	while ( 1 )
	{
		level waittill( "elevator_" + platform_name + "_move" );
		
		wait n_start_delay;

		if ( IsDefined( level.scr_sound ) && IsDefined( level.scr_sound[ "elevator_start" ] ) )
		{
			self playSound( level.scr_sound["elevator_start"] );
		}
		
		self playSound( "veh_" + platform_name + "_start" );
		self.loop_snd_ent playloopsound ("veh_" + platform_name + "_loop", .5 );

		if ( self.at_start )
		{
			speed = -1;
			
			process_node( move_up[0], platform_name ); // process first node before moving

			for ( i = 0; i < move_up.size; i++ )
			{
				org = move_up[i + 1];

				if ( isdefined( org ) )
				{
					speed = get_speed( org, speed );
					// convert speed to a time
					time = Distance( self.origin, org.origin ) / speed;
					self MoveTo( org.origin, time );
					self RotateTo( org.angles, time, time * 0.5, time * 0.5 );
					self waittill( "movedone" );
					
					process_node( org, platform_name );
				}
			}

			stop();

			self.at_start = false;
		}
		else
		{
			speed = -1;

			for ( i = 0; i < move_down.size; i++ )
			{
				org = move_down[i + 1];

				if ( isdefined( org ) )
				{
					speed = get_speed( org, speed );
					// convert speed to a time
					time = distance( self.origin, org.origin ) / speed;
					self moveto( org.origin, time );
					self RotateTo( org.angles, time, time * 0.5, time * 0.5 );
					wait time;
					
					process_node( org, platform_name );
				}
			}

			stop();
	
			self.at_start = true;
		}
	}
}

function stop()
{
	level notify( "elevator_" + self.platform_name + "_stop" );
	level notify( "stop_" + self.platform_name + "_movement_sound" );
	
	// Awesome way to stop the moveto if it's not done yet
	self.origin = self.origin;
	self.angles = self.angles;
	
	// play any metal screeching / groaning sounds if assigned
	if ( isdefined( self.script_sound ) )
	{
		self playSound( level.scr_sound[ self.script_sound ] );
	}
	
	self.loop_snd_ent StopLoopSound( .5 );
	self PlaySound( "veh_" + self.platform_name + "_stop");
	
	if ( isdefined( level.scr_sound ) && IsDefined( level.scr_sound[ "elevator_end" ] ) )
	{
		self PlaySound( level.scr_sound[ "elevator_end" ] );
	}
}

function process_node( node, platform_name )
{
	// raise notifies when elevator arrives 
	if( IsDefined( node.script_notify ) )
	{
		level notify( node.script_notify );
		self notify( node.script_notify );
	}
	
	if( IsDefined( node.script_waittill ) )
	{
		// waittill notify on either level or self
		level util::waittill_any_ents_two( level, node.script_waittill, self, node.script_waittill );
	}

	if ( IsDefined( node.script_wait ) )
	{
		//loop_snd_ent stoploopsound(.5);
		//self playSound( "veh_" + platform_name + "_stop");
		self playSound( "veh_" + platform_name + "_direction_change");
		wait node.script_wait;	// add a sound for mobile shop changing directions?
		//self playSound( "veh_" + platform_name + "_start" );
		//loop_snd_ent playloopsound ("veh_" + platform_name + "_loop", .5 );
		
		level notify( "elevator_" + self.platform_name + "_script_wait_done" );
		self notify( "elevator_" + self.platform_name + "_script_wait_done" );
	}
}

// check if a speed is defined on the current path point script_struct
function get_speed( path_point, speed )
{
	if ( speed <= 0 )
	{
		speed = 100;
	}

	if ( isdefined( path_point.speed ) )
	{
		speed = path_point.speed;
	}

	return speed;
}