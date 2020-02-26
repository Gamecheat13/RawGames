#include maps\_utility; 

#include animscripts\Utility; 
#include animscripts\SetPoseMovement; 
#include animscripts\Combat_utility; 
#include animscripts\shared;
#include common_scripts\Utility; 
#include maps\_spawner;

#insert raw\maps\_utility.gsh;
#insert raw\common_scripts\utility.gsh;

#using_animtree( "fakeshooters" ); 

/************************************************************************************
How to set up drones off of a trigger
	
Script: 
	- run maps\_drones::init(); after main()

CSV: 
	- nothing for standard behavior. If no drone spawn function is defined to use 
	  particular models, the drones will use the models of spawners already in the level.
	- if you want to use fake shooting, include this in CSV:
		fx,weapon/muzzleflashes/fx_standard_flash
	
Radiant:	
	- create trigger multiple, give it targetname 'drone_axis' or 'drone_allies', depending
	  on the type of drones you'd like to create
	- make trigger target a struct, which is where the drones will spawn and begin to run
	- create a path for the drones to run along	made out of structs
	- drones will spawn when trigger is hit
		
------------------------------------------------------------------------------------
How to add custom colors to drone paths
	
	- Sometimes you may want your drone paths to look distinct in Radiant for reference.
	  This can most easily be done with the _color KVP. 
	- Select a struct in your drone path and press Ctrl + Alt + E in Radiant to select
	  the whole spline, then add the _color KVP of your choice	
		- This takes a vector with RGB
	  	  values of the color between 0 and 1. Here it's 
		  '_color' = '0.101961 0.713726 0.894118'
		- Since RGB values are represented between 0 and 255, to convert colors you want
	  	  into this format, either multiply or divide by 255.
		- The blue in this example would be [ 26, 182, 228 ] normally
------------------------------------------------------------------------------------
***************************
***       NOTES         ***
***************************

	- Script assumes you have characters already in the map as AI to use as drones.
	- 2 function overrides:  
		level.drones.think_func - this currently just acts as a supplimental function
		level.drones.death_func - completely overrides the current death behavior
	- BUG: Guns are ammo are missing after latest IW integrate
			
	Trigger K/V pairs:
	--------------------
	script_string		This is used to make the drone spawn triggers unique; note all their targetnames are 
						'drone_axis' or 'drone_allies'.
		
	dr_fake_death		If set to "1", allows drones to die if they reach the end of their path instead of deleting

	dr_populate:		If set to "1", the drone paths will pre-populate with drones when activated.

	dr_group:			If set to "1", If set automatically spawns the drones in a group.

	dr_respawn			If set to "1", will cause a drone to automatically respawn when dead.

	dr_need_player:		If set to "1", requires the player to hit the trigger to start the next drone spawn loop.

	dr_player_trace:	If set to "1", drones will not spawn in unless the player is looking away from the spawn points.


	dr_delay:			Sets the delay before spawning the first drone wave.
						Supports min and max seperated by space.

	dr_wait:			Sets the delay between each drone spawn wave.
						Supports min and max seperated by space.

	dr_wave_count:      undefined or 0 = Infinite looping drones until the trigger is deleted.
						If set, the number of loops to spawn drones for the drone trigger.  
						Supports min and max seperated by space.

	dr_wave_size:		Defines how many drones spawn per wave.  Defaults to 1 drone per loop.
						Supports min and max seperated by space.

	script_string:		Optional unique name for Drone triggers, can be used for features such as:-
						 - Pausing active drone triggers.
						 - Finding unique drone triggers and triggering them through script.
							
	weaponinfo: 		Overrides all weapons drones are carrying that come out of that particular drone spawner.
						Example: weaponinfo = rpg_sp
						- If weaponinfo also exists on a struct being used by the trigger, the structs weaponinfo
						  takes priority
						- If set to "none", drones will spawn without weapons

	
	
	Script_struct K/V pairs:
	--------------------
	dr_animation		Drone will play an animation or randomly select from a group of animations after executing any
						special events. These should be set up with level.drone.anim[ anim_reference ], and require
						the asset to be referenced in the fakeshooters animtree.

	dr_death_timer:		Drone will die in this many seconds. Supports min and max seperated by space.

	dr_event:			Pass in a string for the event you want to play on this node. Refer to the ShooterRun() function
						in _drones for all the possible events. Some to try out are:
						"jump", "shoot", "shoot_burst", "shoot_bullets", "run_fast", "play_looped_anim", "run_and_shoot",
						"run_and_shoot_burst"
						** need FX in CSV: fx,weapon/muzzleflashes/fx_standard_flash 

	dr_percent:			Percentage chance the dr_event will be executed

	radius:				Drone will run to any point within the radius value before going to the next node.

	script_string:		used in the event "shoot_bullets" to optionally indicate the targetname of the target to shoot at.

	script_delete:		Can be used to attach a thead on a drone that will delete it after x amount of time.
		
	weaponinfo: 		Overrides spawn weapon of drones using that spline. Example: weaponinfo = rpg_sp
	
************************************************************************************/


//***************************************************************************************
// SCRIPT FUNCTIONS AVAILABLE:-
//
//	init() - Initializes the drones system
//	drones_system_initialized()
//  drones_get_trigger_from_script_string( script_string_name )
//		eg:	 t_drones = drones_get_triger_from_scipt_string( "triggers name" );
//  drones_get_struct_from_script_string( script_string_name )
//	drones_set_max( max_drones )
//	drones_set_impact_effect( effect_handle )
//	drones_set_muzzleflash( effect_handle )
//	drones_set_friendly_fire( friendly_fire )
//	drones_disable_sound( disable_sound )
//	drones_set_max_ragdolls( max_ragdolls )
//	drones_pause( script_string_name, paused )
//	drones_speed_modifier( script_string_name, speed_min, speed_max )
//  drones_set_respawn_death_delay( min_delay, max_delay )
//	drones_setup_unique_anims( script_string_name, anim_array )
//	drones_start( script_string_name )
//	drones_delete( script_string_name )
//  drones_assign_spawner( script_string_name, spawner_guy )
//  drones_get_array( str_team )
//	drones_delete_spawned()
//***************************************************************************************


/*==============================================================
SELF: unused
PURPOSE: Sets up drone globals
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

init()
{
	// Don't start the drones if compiling reflections
/#
	if( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		return; 
	}
#/
	
	// Global level struct that contains all the drone system globals
	if( !IsDefined( level.drones ) )
	{
		level.drones = SpawnStruct();
	}

	// Setup drone FX
	if( !IsDefined( level.drones.impact_fx ) )
	{
		effect = LoadFx( "impacts/fx_flesh_hit" );
		drones_set_impact_effect( effect );
	}
	if( !IsDefined( level.drones.muzzleflash ) )
	{
		effect = LoadFx( "weapon/muzzleflashes/fx_standard_flash" );
		drones_set_muzzleflash( effect );
	}

	// Max height a drone can move in a single frame
	level.drones.step_height = 100;
		
	// Collision trace from initial spawn to ensure the drone is on the ground
	level.drones.trace_height = 400; 

	// Set max drones for axis and allies
	drones_init_max();

	// Turn off friendly fire for drones
	drones_set_friendly_fire( 0 );
	
	// We want audio on by default
	drones_disable_sound( 0 );

	// The default is to clamp a max of 8 drones into ragdoll
	drones_set_max_ragdolls( 8 );	// 8

	// 
	set_anim_array();

	// Get an array of the Drone Triggers for Axis and Allies, currently the triggers are trigger multiples
	if( !IsDefined( level.drones.team ) )
	{
		level.drones.team = []; 
	}
	if( !IsDefined( level.drones.team["axis"] ) )
	{
		level.drones.team["axis"] = struct_arrayspawn(); 
	}
	if( !IsDefined( level.drones.team["allies"] ) )
	{
		level.drones.team["allies"] = struct_arrayspawn(); 
	}

	// Drones can be spawned from Triggers or Script Structs
	// The data is takes from the trigger/structs and stored in a drone_spawner
	level.drones.drone_spawners = [];
		
	// Get the Drone Triggers, convert them to drone spawners and thread them
	level.drones.axis_triggers = getentarray( "drone_axis", "targetname" );
	level.drones.allies_triggers = getentarray( "drone_allies", "targetname" );
	array_thread( level.drones.axis_triggers, ::drones_setup_spawner, true );
	array_thread( level.drones.allies_triggers, ::drones_setup_spawner, true );


	// Get the Drone Script Structs, convet them to spawners and thread them
	level.drones.axis_structs = getstructarray( "drone_axis", "targetname" );
	level.drones.allies_structs = getstructarray( "drone_allies", "targetname" );
	array_thread( level.drones.axis_structs, ::drones_setup_spawner, false );
	array_thread( level.drones.allies_structs, ::drones_setup_spawner, false );

	// Initialize flag for stopping looped drone anims
	flag_init( "drones_stop_looped_anims" );
	
	// This is for drone throttling when spawning lots of drones all at once
	flag_init("reached_drone_spawn_cap");
	level.drones.MAX_PER_FRAME = 10;
	level.drones.spawned_this_frame = 0;
	level thread reset_drone_throttle();


	// Drone respawner initializations
	level.drones.respawn_death_delay_min = 1.0;
	level.drones.respawn_death_delay_max = 3.0;
	level.drones.respawners = [];

	// If the level hasn't setup a spawn function for drones
	// Automatically use the spawners in the level for the drone models
	if( !IsDefined(level.drone_spawnFunction) )
	{
		level.drone_spawnFunction["axis"] = ::spawn_random_axis_drone;
		level.drone_spawnFunction["allies"] = ::spawn_random_allies_drone;
	}

	// Default loop anims
	level.drones.anim_idle[0] = %stand_alert_1; 
	level.drones.anim_idle[1] = %stand_alert_2; 
	level.drones.anim_idle[2] = %stand_alert_3; 

	// Drone custom functions should be defined in this array in your level script.  
	//  Ex:		level.drones.funcs[ "cover_and_run" ] ::drone_cover_and_run;
	//	All custom drone functions must use the drone as self and a set of standard parameters:
	//		s_start, end_point and a string array  (this is a parsed version of s_start.dr_event)
	//		
	//	In the script_noteworthy, simply put the string name of the function.  In our above example
	//	that's "cover_and_run".  You could optionally add a comma separated list of string parameters
	//	in the script_noteworthy such as "cover_and_run,5,go_now".
	level.drones.funcs = [];
}

/@
"Name: drones_add_custom_func( <str_func_name>, <func_custom> )"
"Summary: adds a custom function a drone can run while on a spline"
"Module: Drone"
"CallOn: n/a"
"MandatoryArg: <str_func_name> : name that will be referenced on a struct when function should run. Node should have KVP dr_event = str_func_name"
"MandatoryArg: <func_custom> : function that will run when drone hits struct with your custom event on it. This function should have 3 inputs: s_start, v_destination, params."
"Example: drones_add_custom_func( "throw_molotov", ::drone_throws_molotov );"
"SPMP: SP"
@/ 
drones_add_custom_func( str_func_name, func_custom )
{
	Assert( IsDefined( str_func_name ), "str_func_name is a required parameter for drones_add_custom_func!" );
	Assert( IsDefined( func_custom ), "func_custom is a required parameter for drones_add_custom_func!" );
	
	level.drones.funcs[ str_func_name ] = func_custom;
}


/*==============================================================
SELF: unused
PURPOSE: Extracts a min value from a string.  The format can be either a single
	digit or two digits (a min and a max) separated by a space.
RETURNS: the min value
CREATOR: MarkM
===============================================================*/
get_min_value( value, is_integer )
{
	// Process the parameters
	values = strtok( value, " " );
	assert( (values.size > 0), "_drones a non-number value was encountered: \"" + value + "\"" );

	if ( !IsDefined( is_integer ) )
	{
		is_integer = true;
	}

	// Currently assume the first argument is the min.  We could do an evaluation of all parameters if we want to be nice.
	if( IsDefined( values[0] ) )
	{
		if ( is_integer )
		{
			return Int( values[0] );
		}
		else
		{
			return Float(values[0]);
		}
	}

	return undefined; // ideally we should not hit this
}


/*==============================================================
SELF: unused
PURPOSE: Extracts a max value from a string.  The format can be either a single
	digit or two digits (a min and a max) separated by a space.
RETURNS: the max value
CREATOR: MarkM
===============================================================*/
get_max_value( value, is_integer )
{
	// Process the parameters
	values = strtok( value, " " );
	assert( (values.size > 0), "_drones a non-number value was encountered: \"" + value + "\"" );

	if ( !IsDefined( is_integer ) )
	{
		is_integer = true;
	}

	// return the second value
	if ( values.size > 1 )
	{
		// Currently assume the first argument is the min.  We could do an evaluation of all parameters if we want to be nice.
		if ( is_integer )
		{
			return Int( values[1] );
		}
		else
		{
			return Float(values[1]);
		}
	}
	// just use this value
	else if ( values.size == 1 )
	{
		if ( is_integer )
		{
			return Int( values[0] );
		}
		else
		{
			return Float(values[0]);
		}
	}	

	return undefined; // ideally we should not hit this
}


/*==============================================================
SELF: unused
PURPOSE: Returns 1 if the drone system has been initialized
RETURNS: NOTHING
CREATOR: 
===============================================================*/

drones_system_initialized()
{
	if( IsDefined(level.drones) )
	{
		if( IsDefined(level.drones.team) )
		{
			return( 1 );
		}
	}
	return( 0 );
}


/*================================================================
SELF: unused
PURPOSE: Finds a drone trigger with a specified script string name
RETURNS: the trigger ent if it finds one
CREATOR: 
=================================================================*/

drones_get_trigger_from_script_string( script_string_name )
{
	drone_trigger = undefined;
	
	// Search for the drone trigger TARGETNAME as "drone_axis" or "drone_allies"
	for( i=0; i<2; i++ )
	{
		if( !i )
		{
			drone_trigger_array = GetEntArray( "drone_axis", "targetname" );
		}
		else
		{
			drone_trigger_array = GetEntArray( "drone_allies", "targetname" );
		}
		
		if( isdefined( drone_trigger_array ) )
		{
			// Looking for script_string_name in the drone array
			for( j=0; j<drone_trigger_array.size; j++ )
			{
				e_ent = drone_trigger_array[j];
			
				if( IsDefined(e_ent.script_string) && (e_ent.script_string == script_string_name) )
				{
					drone_trigger = drone_trigger_array[j];
					break;
				}
			}
		}
	}

//	Assert( isdefined( drone_trigger ), "Can't find drone trigger - script_string_name" );

	return( drone_trigger );
}


/*================================================================
SELF: unused
PURPOSE: Finds a drone data with a specified script string name
RETURNS: the script data if it finds one
CREATOR: 
=================================================================*/
drones_get_data_from_script_string( script_string_name )
{
	// Search for the drone data TARGETNAME as "drone_axis" or "drone_allies"
	foreach ( s_data in level.drones.drone_spawners )
	{
		if( IsDefined(s_data.script_string) && (s_data.script_string == script_string_name) )
		{
			return s_data;
		}
	}

	return undefined;
}


/*==============================================================
SELF: unused
PURPOSE: Initialization for the mazimum number of drones"
		 Note the max may have already been set before the initialization call is made"
		 This is because for script clarity you may want to set the drone max limit when defining the drone models"
RETURNS: The default maximum number of drones a level uses.
CREATOR: MikeA
===============================================================*/

drones_init_max()
{
	max_drones = 32*2;
	if( isSplitScreen() )
	{
		max_drones = 8*2;
	}

	// Has the max limit already been set?
	if( IsDefined(level.drones.max_drones) )
	{
		max_drones = level.drones.max_drones;
	}
	
	drones_set_max( max_drones );
}


/*==============================================================
SELF: unused
PURPOSE: Sets the max allowed drones, shared for both axis and allies
         You can call this before the init function"
RETURNS: NOTHING
CREATOR: MikeA
===============================================================*/

drones_set_max( max_drones )
{
	if( !IsDefined( level.drones ) )
	{
		level.drones = SpawnStruct();
	}

	level.drones.max_drones = max_drones;
}


/*==============================================================
SELF: unused
PURPOSE: Sets the impact effect played when the drone is shot
RETURNS: NOTHING
CREATOR: MikeA
===============================================================*/

drones_set_impact_effect( effect_handle )
{
	if( !IsDefined( level.drones ) )
	{
		level.drones = SpawnStruct();
	}

	level.drones.impact_fx	= effect_handle;
}


/*==============================================================
SELF: unused
PURPOSE: Sets the muzzle flash effect played when the drone fires
RETURNS: NOTHING
CREATOR: MikeA
===============================================================*/

drones_set_muzzleflash( effect_handle )
{
	if( !IsDefined( level.drones ) )
	{
		level.drones = SpawnStruct();
	}

	level.drones.muzzleflash = effect_handle;
}


/*==============================================================
SELF: unused
PURPOSE: Globally turns friendly fire on or off for Drones
RETURNS: NOTHING
CREATOR: MikeA
===============================================================*/

drones_set_friendly_fire( friendly_fire )
{
	level.drones.friendly_fire = friendly_fire;
}


/*==============================================================
SELF: unused
PURPOSE: Globally turn on/of the drones audio calls
RETURNS: NOTHING
CREATOR: MikeA
===============================================================*/

drones_disable_sound( disable_sound )
{
	level.drones.sounds_disabled = disable_sound;
}


/*=================================================================================
SELF: save_target_links
PURPOSE: Stores all of the struct links for the struct
RETURNS: Drone spawner entity
CREATOR: MikeA
=================================================================================*/
save_target_links()
{
	// A bit of recursion here, hopefully this isn't going to kill us.
	foreach( s_child in self.a_targeted )
	{
		// Skip if it has no target or if we've already saved the targeted structs
		if ( IsDefined( s_child.target ) && !IsDefined( s_child.a_targeted ) )
		{
			s_child.a_targeted = level.struct_class_names["targetname"][ s_child.target];
			
			// Save the grandchildren's data
			s_child save_target_links();
		}
	}
}


/*=================================================================================
SELF: drone trigger or script struct
PURPOSE: Gets all the drone spawner infromation from a Drone Parent Script Struct (not a trigger)
RETURNS: Drone spawner entity
CREATOR: MikeA
=================================================================================*/
drones_setup_spawner( is_trigger )
{
	data = drones_get_spawner( self.targetname, self.target );

	if ( is_trigger )
	{
		// The parent is a trigger
		data.parent_trigger = self;
	}
	else
	{
		// The parent is a script struct
		data.parent_script_struct = self;
	}

	// Store all the information that could be on a drone trigger or struct
	// NOTE: For mins and maxes, there will always be a max even if only one value is indicated
	//	in the field.  In that case, the max will of course be equal to the min.
	data.dr_group				=	self.dr_group;
	data.dr_need_player			=	self.dr_need_player;
	data.dr_player_trace		=	self.dr_player_trace;
	data.dr_populate			=	self.dr_populate;
	data.dr_respawn				=	self.dr_respawn;
	
	if ( IsDefined( self.dr_delay ) )
	{
		data.n_delay_min		= get_min_value( self.dr_delay, false );
		data.n_delay_max		= get_max_value( self.dr_delay, false );
	}

	if ( IsDefined( self.dr_wait ) )
	{
		data.n_wait_min			= get_min_value( self.dr_wait, false );
		data.n_wait_max			= get_max_value( self.dr_wait, false );
	}

	if ( IsDefined( self.dr_wave_count ) )
	{
		data.n_wave_count_min	= get_min_value( self.dr_wave_count );
		data.n_wave_count_max	= get_max_value( self.dr_wave_count );
	}

	if ( IsDefined( self.dr_wave_size ) )
	{
		data.n_wave_size_min	= get_min_value( self.dr_wave_size );
		data.n_wave_size_max	= get_max_value( self.dr_wave_size );
	}

	data.script_allowdeath		= self.script_allowdeath;
	data.script_int				= self.script_int;
	data.script_ender			= self.script_ender;
	data.script_noteworthy		= self.script_noteworthy;
	data.script_string			= self.script_string;
	data.weaponinfo				= self.weaponinfo;

	level thread drone_spawner_wait_for_activation( data );
	
	return( data );
}


/*=================================================================================
SELF: drone trigger or script struct
PURPOSE: Initializes a basic drone spawner with the shared data a parent Drone Trigger or Struct needs
RETURNS: Drone spawner entity
CREATOR: MikeA
=================================================================================*/

drones_get_spawner( targetname, target )
{
	data = SpawnStruct();
	data.parent_trigger = undefined;
	data.parent_script_struct = undefined;

	// Get the drone paths
	if( IsDefined( target ) )
	{
		data.a_targeted = GetStructArray( target, "targetname" );
	}
	assert( IsDefined(data.a_targeted) ); 
	assert( IsDefined(data.a_targeted[0]) ); 
	
	data save_target_links();

	// Skip if it has no target or if we've already saved the targeted structs
	if ( targetname == "drone_allies" )
	{
		data.team = "allies";
	}
	else
	{
		data.team = "axis";
	}
	
	// Additional data that can be set on the drone spawners at run-time
	data.paused = 1;
	data.drone_run_cycle_override = undefined;
	data.speed_modifier_min = undefined;
	data.speed_modifier_max = undefined;
	data.delete_spawner = 0;
		
	// Add the drone spawner to the drone_spawners_array
	level.drones.drone_spawners[ level.drones.drone_spawners.size ] = data;
	
	return( data );
}


/*=================================================================================
SELF: level
PURPOSE: Main Drone Spawner Wait Routine
		 Waits for the drone spawner to activate, then starts creating drones
		 Drones can be parented from Triggers or Script Structs, see module_drones.gsc for more information
RETURNS: Drone spawner entity
CREATOR: NOTHING
=================================================================================*/
drone_spawner_wait_for_activation( drones )
{
	// Ability to kill this thread, if script_ender is defined.
	if( IsDefined( drones.script_ender ) )
	{
		level endon( drones.script_ender ); 
	}

	// If the Drones are Created by a Trigger, wait for it to be triggered
	if( IsDefined(drones.parent_trigger) )
	{
		drones.parent_trigger endon( "death" );
		drones.parent_trigger waittill( "trigger" );
		drones.paused = 0;
	}
	else
	{
		drones.parent_script_struct waittill( "trigger" );
		drones.paused= 0;
	}

	level thread drone_spawner_active( drones );
}


/*=================================================================================
SELF: level
PURPOSE: Main Drone Spawner Routine
		 Starts creating drones
		 Drones can be parented from Triggers or Script Structs, see module_drones.gsc for more information
RETURNS: Drone spawner entity
CREATOR: NOTHING
=================================================================================*/
drone_spawner_active( drones )
{
	// How many times should we loop through the drone spawning?
	repeat_times = 9999999;
	if ( IsDefined( drones.n_wave_count_min ) )
	{
		repeat_times = RandomIntRange( drones.n_wave_count_min, drones.n_wave_count_max+1 );
	}

	// Setup the number of drones to spawn each loop
	spawn_min = 1;
	spawn_max = spawn_min;
	if( IsDefined(drones.n_wave_size_min) )
	{
		spawn_min = drones.n_wave_size_min;
	}
	if( IsDefined(drones.n_wave_size_max) )
	{
		spawn_max = drones.n_wave_size_max;
	}

	if( IsDefined(drones.parent_trigger) )
	{
		drones.parent_trigger endon( "stop_drone_loop" );
	}

	// Initial delay
	if ( IsDefined( drones.n_delay_min ) )
	{
		wait( RandomFloatRange( drones.n_delay_min, drones.n_delay_max ) );
	}

	// Should we pre-populate the drone paths?
	if( IS_TRUE( drones.dr_populate ) )
	{
		level thread pre_populate_drones( drones, spawn_min, spawn_max, drones.team );
		wait_time = get_drone_spawn_wait( drones );
		wait( wait_time ) ;
	}


	//*******************************************
	// Drone Main Looop
	//*******************************************

	for( i=0; i<repeat_times; i++ )
	{
		// First check if the Drone Spawner has been deleted
		if( drones.delete_spawner )
		{
			return;
		}
		
		// Notify the script a new drone wave is spawning
		level notify( "new drone Spawn wave" ); 
		
		// How many drones should spawn?
		spawn_size = spawn_min;
		if( spawn_max > spawn_min )
		{
			spawn_size = RandomIntRange( spawn_min, (spawn_max+1) ); 
		}

		level thread drone_spawngroup( drones, drones.a_targeted, spawn_size, drones.team, 0 );

		respawn_wait_loop = 1;
		while( respawn_wait_loop )
		{
			delay = get_drone_spawn_wait( drones );
			wait( delay );

			// If a drone has respawned during the wait, wait again
			if( !drones_respawner_used(drones) )
			{
				respawn_wait_loop = 0;
			}
		}
		
		// Does the player have to re-trigger the next spawn?
		if( IsDefined(drones.parent_trigger) )
		{
			if ( IS_TRUE( drones.parent_trigger.dr_need_player ) )
			{
				drones.parent_trigger waittill( "trigger" );
			}
		}

		// Check for the trigger being paused
		while( drones.paused )
		{
			wait( 1.0 );
		}
	}
}


/*=================================================================================
SELF: 
PURPOSE: Get the wait before we spawn the next drone or group
RETURNS: Spawn wait time
CREATOR: MikeA
=================================================================================*/
get_drone_spawn_wait( drone_data )
{
	// Setup the wait time between drone spawns
	min_spawn_wait = 1;
	max_spawn_wait = 1;

	if( IsDefined( drone_data.n_wait_min ) )
	{
		min_spawn_wait = drone_data.n_wait_min;
		max_spawn_wait = drone_data.n_wait_max;
	}

	if( max_spawn_wait > min_spawn_wait )
	{
		return( RandomFloatRange( min_spawn_wait, max_spawn_wait ) );
	}

	return( min_spawn_wait );
}


/*=================================================================================
SELF: level
PURPOSE: Spawn a Drone or Group of Drones
RETURNS: NOTHING
CREATOR: MikeA
=================================================================================*/

drone_spawngroup( drones, spawnpoint, spawnSize, team, start_ahead )
{
	spawncount = spawnpoint.size; 
	if( IsDefined( spawnSize ) )
	{
		spawncount = spawnSize; 
		spawnpoint = array_randomize( spawnpoint ); 
	}

	if( ( spawncount > spawnpoint.size ) && ( spawnpoint.size > 1 ) )
	{
		spawncount = spawnpoint.size; 
	}
	
	// Check for any Trigger Functionality defined by the scrip_noteworthy
	offsets = [];
	if ( IS_TRUE( drones.dr_group ) )
	{
		offsets = generate_offsets( spawncount );
	}
	
	// Spawn the Drone or Drones (using offsets  if its a group
	for( i = 0; i < spawncount; i++ )
	{
		if( IsDefined(drones.script_int) )
		{
			wait RandomFloatRange( 0.1, 1.0 );
		}
		
		// Looks like it does nothing for drones but still calling if its a trigger
		if( IsDefined(drones.parent_trigger) )
		{
			while( !drones.parent_trigger ok_to_trigger_spawn() )
			{
				wait_network_frame();
			}
		}

		// Time to spawn the drone
		if( i < spawnpoint.size )
		{
			spawnpoint[i] thread drone_spawn( team, offsets[i], start_ahead, drones );
		}
		else
		{
			if( i > 0 && offsets[i-1] == offsets[i] )			
			{
				wait( randomfloatRange( .8, 1.1 ) ); 
			}
			else
			{
				wait( randomfloatRange( .5, .9 ) ); 
			}
			spawnpoint[spawnpoint.size - 1] thread drone_spawn( team, offsets[i], start_ahead, drones );
		}
		
		level._numTriggerSpawned ++;
	}
}


/*=================================================================================
SELF: 
PURPOSE: Add the drone_struct to the array of spawner structs that have been used
RETURNS: NOTHING
CREATOR: MikeA
=================================================================================*/

drones_respawner_created( drone_struct )
{
	// If the struct already exists in the array, don't add it
	// We don't want drones stacking up on the same struct
	for( i=0; i<level.drones.respawners.size; i++ )
	{
		if( level.drones.respawners[i] == drone_struct )
		{
			return;
		}
	}

	// Now check if we have a trigger alive that has this start struct
	trigger_alive = 0;
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		spawner = level.drones.drone_spawners[ i ];
		for( j=0; j<spawner.a_targeted.size; j++ )
		{
			if( spawner.a_targeted[j] == drone_struct )
			{
				trigger_alive = 1;
				break;
			}
		}
	}
	
	// Add the drone_struct to the array
	if( trigger_alive )
	{
		level.drones.respawners[ level.drones.respawners.size ] = drone_struct;
	}
}


/*=================================================================================
SELF: 
PURPOSE: While the drone spawner has been waiting to spawn the next drone, has a respawner been spawned?
RETURNS: 1 if the drone_spawner has respawned a drone (using a respawner event)
CREATOR: MikeA
=================================================================================*/

drones_respawner_used( drone_spawner )
{
	drone_structs = drone_spawner.a_targeted;
	
	// Loop through the respawners
	for( i=0; i<drone_structs.size; i++ )
	{
		struct = drone_structs[ i ];
	
		// Loop through the spawners that have respawned
		for( j=0; j<level.drones.respawners.size; j++ )
		{
			if( level.drones.respawners[j] == struct )
			{
				// Remove respawner
				ArrayRemoveValue( level.drones.respawners, struct );
				return( 1 );
			}
		}
	}
	return( 0 );
}



/*=================================================================================
SELF: 
PURPOSE: Generates an array of offsets for a Drone Group
RETURNS: Array of offsets for the Drone Group
CREATOR: MikeA
=================================================================================*/

generate_offsets( spawncount )
{
	offsets = [];
	delta = 0.5 / spawncount;

	for( i = 0; i < spawncount; i++ )
	{
		id = randomint( spawncount * 2 );
		offsets[i] = id * delta;
	}
	return offsets;
}


/*=================================================================================
SELF: start struct
PURPOSE: Spawns a Drone
RETURNS: NOTHING
CREATOR: MikeA
=================================================================================*/

#using_animtree( "fakeshooters" ); 
drone_spawn( team, offset, distance_down_path, drones )
{	
	if ( !IsDefined( distance_down_path ) )
	{
		distance_down_path = 0;
	}
	
	// SCRIPTER_MOD
	// JesseS( 3/16/2007 ): Added check to make sure we dont get a bunch of these queued up (by co-op guys)
		
	if ( !IsDefined( drones.dr_respawn ) )
	{
		level endon( "new drone Spawn wave" ); 
	}
	
	if( IsDefined(drones.script_ender) )
	{
		level endon(drones.script_ender);
	}
	if( IsDefined(self.script_ender) )
	{
		level endon(self.script_ender);
	}
	
	check_drone_throttle();

	if ( IS_TRUE( drones.dr_player_trace ) )
	{
		while( self spawnpoint_playersView() )
		{
			wait 0.2; 
		}
	}

	// Clamp the maximum number of drones we can have alive
	total_drones = level.drones.team["axis"].array.size + level.drones.team["allies"].array.size;
	if( total_drones >= level.drones.max_drones )
	{
		return;
	}
		
	//offset for this drone( -1 to 1 )
	//spawnoffset = RandomFloat( 2 ) - 1; 
	if( IsDefined( offset ) )
		spawnoffset = offset * 2 - 1; 
	else
		spawnoffset = 0;		
		
	// Get the position on the drone path
	// Normally drones start at the node origin, however we can specify a distance to move down the path
	spawnpos = self get_drone_spawn_pos( distance_down_path );
			
	if( IsDefined( self.radius ) )
	{
		angles = ( 0, 0, 0 );
		if( IsDefined( self.angles ) )
			angles = self.angles;
			
		right = AnglesToRight( angles ); 
		spawnpos += VectorScale( right, ( spawnoffset * self.radius ) ); 
	}	
		
	// Spawn a drone
	level.drones.spawned_this_frame++;
	guy = Spawn( "script_model", GROUNDPOS( self, spawnpos ) ); 
	guy.droneRunOffset = spawnoffset;
	
	if( IsDefined( self.angles ) )
	{
		guy.angles = self.angles; 
	}
	else if( IsDefined( self.a_targeted ) )
	{
		guy.angles = VectorToAngles( self.a_targeted[0].origin - guy.origin );
	}
	
	assert( IsDefined( level.drone_spawnFunction[team] ) ); 
	
	
	// Its time to assign the model info and gear to the drone
	// First check if we have unique drones assigned to the spawner
	// if we don't use the AXIS or ALLIES drone_spawnFunction

	// Do we have unique drones assigned?
	override_class = undefined;
	if( IsDefined(drones.unique_guys) )
	{
		index = randomint( drones.unique_guys.size );
		spawner = drones.unique_guys[ index ];
		override_class = spawner.classname;
	}

	// Functionality made for KheSanh to be able to spawn multiple LOD types of drones.
	// This way you can seperate it based on the struct (LEGACY)
	if(IsDefined(level.drone_spawnFunction_passNode))
	{
		guy [[level.drone_spawnFunction[team]]]( self ); //This passes in the first struct that the drone is getting spawned at
	}
	else
	{
		if( IsDefined(override_class) )
		{
			guy [[level.drone_spawnFunction[team]]]( override_class );
		}
		else
		{
			guy [[level.drone_spawnFunction[team]]]();
		}
	}

	guy drone_assign_weapon( team, self, drones ); 
	
	guy.targetname = "drone"; 
	
	// Added by Alex Liu 10/16/07 to allow script to identify specific drones
	// Drones now have the same script_noteworthy as their Spawn points( the structs, not the trigger )
	guy.script_noteworthy = self.script_noteworthy;
		
	guy MakeFakeAI();
	if ( IS_TRUE( drones.b_use_cheap_flag ) )
	{
		guy SetCheapFlag( true );
	}

	guy.team = team;
	guy.script_allowdeath = drones.script_allowdeath;
	guy UseAnimTree( #animtree );
	
	//********************************
	// Set the run Cycle for the Drone
	//********************************
	
	if( IsDefined(drones) && IsDefined(drones.drone_run_cycle_override) )
	{
		guy.drone_run_cycle_override = drones.drone_run_cycle_override;
	}
	
	guy drone_set_run_cycle();
	
	
	//*************************
	// Set the Drones run speed
	//*************************
	
	if( IsDefined(level.drone_run_rate) )
	{
		guy.droneRunRate = level.drone_run_rate;
	}
	// Does the drone trigger want to override the drone speeed?
	else if( IsDefined(drones) && 
	         IsDefined(drones.speed_modifier_min) && IsDefined(drones.speed_modifier_max) )
	{
		modifier = 1.0 + randomfloatrange( drones.speed_modifier_min, drones.speed_modifier_max );
		guy.droneRunRate = guy.droneRunRate * modifier;
	}
	// Leaving as legacy for Khe Sanh - Can be removed (MikeA 2/10/11)
	else if( IsDefined(level.drone_run_rate_multiplier) )
	{
		guy.droneRunRate = guy.droneRunRate * level.drone_run_rate_multiplier;
	}

	//
	guy thread drone_think( self, level.drones.new_target_node ); 
	
	// If the drone trigger has the script_noteworthy "respawner" a drone will respawn shortly after death
	if( IsDefined( drones.dr_respawn ) )
	{
		if( IsDefined(self.script_ender) )
		{
			level thread drone_respawn_after_death( guy, self, team, offset, self.script_ender, drones );
		}
		else
		{
			level thread drone_respawn_after_death( guy, self, team, offset, undefined, drones );
		}
	}
}


/*=================================================================================
SELF: script struct
PURPOSE: Generate the Drones world position
RETURNS: Drones world position
CREATOR: MikeA
=================================================================================*/

get_drone_spawn_pos( required_distance )
{
	node = self;
	spawn_pos = node.origin;
	level.drones.new_target_node = undefined;
	
	if( (required_distance == 0) || (!IsDefined(node.target)) )
	{
		return( spawn_pos );
	}
	
	next_node = node;
	dist_so_far = 0;
	while( dist_so_far < required_distance )
	{
		// Get the run direction
		if( !IsDefined(node.target) )
		{
			return( spawn_pos );
		}
		
		next_node = getstruct( node.target, "targetname" );
		
		dir = next_node.origin - node.origin;
		dir_norm = VectorNormalize( dir );

		dist_to_next_node = Distance( node.origin, next_node.origin );
		
		// Have we reached the required distance?
		if( (dist_so_far + dist_to_next_node) > required_distance )
		{
			frac = (required_distance - dist_so_far) / dist_to_next_node;
			spawn_pos = spawn_pos + ( dir * frac );
			break;
		}

		dist_so_far += dist_to_next_node;
		spawn_pos = spawn_pos + dir;
		
		level.drones.new_target_node = next_node;
		node = next_node;
	}

	return( spawn_pos );
}


/*==============================================================
SELF: drone
PURPOSE: Attach a weapon to the drone
PARAMETERS:
	team = "allies" or "axis"
	start_struct = used to check for weaponinfo
			Make sure the weapon is included and precached if not held by a normal AI
	drones = drone spawner information
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/
drone_assign_weapon( team, start_struct, drones )
{
	if( IsDefined(start_struct.weaponinfo) )
	{
		self setCurrentWeapon(start_struct.weaponinfo);
	}
	else if ( IsDefined( drones.weaponinfo ) )
	{
		self setCurrentWeapon(drones.weaponinfo);
	}
	else
	{
		if( team == "allies" )
		{
			if( IsDefined( level.drone_weaponlist_allies ) && level.drone_weaponlist_allies.size > 0 )
			{
				//kdrew 5/20/2010 - if first entry of level.drone_weaponlist_allies is set to "unarmed" then don't attach one
				if( level.drone_weaponlist_allies[0] == "unarmed" )
				{
					self setCurrentWeapon(undefined);
					return;
				}

				randWeapon = RandomInt( level.drone_weaponlist_allies.size ); 
				
				self setCurrentWeapon(level.drone_weaponlist_allies[randWeapon]);
				assert( IsDefined( self.weapon ), "_drones::couldn't assign weapon from level.drone_weaponlist because the array value is undefined." ); 
			}
			/*else//Commented out, we will instead just use the defaulted class weapon - CP 2/12
			{
				switch( level.campaign )
				{
					case "american":
						self setCurrentWeapon(drone_allies_assignWeapon_american());
						break; 
					case "british":
						self setCurrentWeapon(drone_allies_assignWeapon_british());
						break; 
					case "russian":
						self setCurrentWeapon(drone_allies_assignWeapon_russian());
						break; 
				}
			}*/
		}
		else
		{
			if( IsDefined( level.drone_weaponlist_axis ) && level.drone_weaponlist_axis.size > 0 )
			{
				randWeapon = RandomInt( level.drone_weaponlist_axis.size ); 
				
				self setCurrentWeapon(level.drone_weaponlist_axis[randWeapon]);
				assert( IsDefined( self.weapon ), "_drones::couldn't assign weapon from level.drone_weaponlist because the array value is undefined." ); 
			}
			/*else//Commented out, we will instead just use the defaulted class weapon - CP 2/12
			{
				switch( level.campaign )
				{
					case "american":
						self setCurrentWeapon(drone_axis_assignWeapon_japanese());
						break; 
					case "british":
						self setCurrentWeapon(drone_axis_assignWeapon_german());
						break; 
					case "russian":
						self setCurrentWeapon(drone_axis_assignWeapon_german());
						break; 
				}
			}*/
		}
	}	

	if ( self.weapon != "none" )
	{
		self Attach( self.weaponmodel, "tag_weapon_right" ); 
		self UseWeaponHideTags(self.weapon); //Adrian B 08.23.10 make sure attachments dont show up
		self.bulletsInClip = WeaponClipSize( self.weapon );
	}
}


/*=================================================================================
SELF: 
PURPOSE: Assigns a weapon to an American Drone
RETURNS: Weapon
CREATOR: 
=================================================================================*/

drone_allies_assignWeapon_american()
{
	array = [];
	
	array[array.size] = "m16_sp";
	
	return array[RandomInt( array.size )];
}


/*=================================================================================
SELF: 
PURPOSE: Assigns a weapon to a British Drone
RETURNS: Weapon
CREATOR: 
=================================================================================*/

drone_allies_assignWeapon_british()
{
	array = [];
	array[array.size] = "m16_sp";

	return array[RandomInt( array.size )];
}


/*=================================================================================
SELF: 
PURPOSE: Assigns a weapon to a Russian Drone
RETURNS: Weapon
CREATOR: 
=================================================================================*/

drone_allies_assignWeapon_russian()
{
	array = [];
	array[array.size] = "ak47_sp";

	return array[RandomInt( array.size )];
}


/*=================================================================================
SELF: 
PURPOSE: Assigns a weapon to a German Drone
RETURNS: Weapon
CREATOR: 
=================================================================================*/

drone_axis_assignWeapon_german()
{	
	array = [];
	array[array.size] = "ak47_sp";

	return array[RandomInt( array.size )];
}


/*=================================================================================
SELF: 
PURPOSE: Assigns a weapon to a Japanese Drone
RETURNS: Weapon
CREATOR: 
=================================================================================*/

drone_axis_assignWeapon_japanese()
{
	array = [];
	array[array.size] = "ak47_sp";

	return array[RandomInt( array.size )];
}


/*=================================================================================
SELF: 
PURPOSE: Limits the amount of Drones qwe can spawn on a frame for perforance reasons (hitches)
		 Guarantees atleast one wait of 0.05 seconds
RETURNS: 
CREATOR: 
=================================================================================*/

check_drone_throttle()
{
	can_spawn = false;
	
	while(!can_spawn)
	{
		if( level.drones.spawned_this_frame > level.drones.MAX_PER_FRAME )
		{
			flag_set( "reached_drone_spawn_cap" );
		}
		
		flag_waitopen( "reached_drone_spawn_cap" );
		wait( 0.05 );
		
		if( level.drones.spawned_this_frame < level.drones.MAX_PER_FRAME )
		{
			can_spawn = true;
		}
	}
}


/*=================================================================================
SELF: level
PURPOSE: Resets the data that monitors the number of drones spawned (performance stuff)
RETURNS: 
CREATOR: 
=================================================================================*/

reset_drone_throttle()
{
	while(true)
	{
		waittillframeend;
		flag_clear("reached_drone_spawn_cap");
		level.drones.spawned_this_frame = 0;
		wait(0.05);
	}
}


/*=================================================================================
SELF: level
PURPOSE: Forces a respawn of a drone from the start struct once they die
RETURNS: 
CREATOR: MikeA
=================================================================================*/

drone_respawn_after_death( guy, start_struct, team, offset, ender, drones )
{
	// After a drone is killed, whats the delay for the next one?
	min_respawn_time = level.drones.respawn_death_delay_min;
	max_respawn_time = level.drones.respawn_death_delay_max;

	if(IsDefined(ender))
	{
		level endon(ender);
	}
	guy waittill("death");

	wait( randomfloatrange( min_respawn_time, max_respawn_time ) );

	// Inform the drone system that a drone "respawner" has spawned from this start struct
	drones_respawner_created( start_struct );

	start_struct thread drone_spawn( team, offset, 0, drones );
}


/*=================================================================================
SELF: start struct
PURPOSE: 
RETURNS: true if the struct is in players sigth else returns false
CREATOR: 
=================================================================================*/

spawnpoint_playersView()
{
	//first check if it's within the players FOV
	if( !IsDefined( level.cos80 ) )
	{
		level.cos80 = cos( 80 ); 
	}
	
	// SCRIPTER_MOD
	// JesseS( 3/16/2007 ): Added check for all players POV
	players = get_players(); 
	player_view_count = 0; 
	success = false; 
	
	for( i = 0; i < players.size; i++ )
	{
			forwardvec = AnglesToForward( players[i].angles ); 
			normalvec = VectorNormalize( self.origin - players[i] GetOrigin() ); 
			vecdot = vectordot( forwardvec, normalvec ); 
		
		if( vecdot > level.cos80 )	//it's within the players FOV so try a trace now
		{
				success = BulletTracePassed( players[i] GetEye(), self.origin +( 0, 0, 48 ), false, self ); 
			
			if( success )
			{
				player_view_count++; 
			}
		}
	}
	
	if( player_view_count != 0 )
	{
		return true; 
	}
	
	//isn't in the field of view so it must be out of sight
	return false; 
}


/*=================================================================================
SELF: drone
PURPOSE: Sets the name of Friedly Drones
RETURNS: 
CREATOR: 
=================================================================================*/

drone_setName()
{
	self endon( "drone_death" );

	wait( 0.25 ); 
	if( !IsDefined( self ) )
	{
		return; 
	}
	
	//set friendlyname on allies
	if( self.team != "allies" )
	{
		return; 
	}
		
	if( !IsDefined( level.names ) )
	{
		maps\_names::setup_names(); 
	}
	
	if( IsDefined( self.script_friendname ) )
	{
		self.name = self.script_friendname; 
	}
	else
	{
		/*switch( level.campaign )
		{
			case "american":
				self maps\_names::get_name_for_nationality( "american" ); 
				break; 
			case "russian":
				self maps\_names::get_name_for_nationality( "russian" ); 
				break; 
			case "british":
				self maps\_names::get_name_for_nationality( "british" ); 
				break; 
		}*/
		//Using BO2 naming system now
		self maps\_names::get_name();
	}
	assert( IsDefined( self.name ) ); 
	
	subText = undefined; 
	if( !IsDefined( self.weapon ) )
	{
		subText = &"";
	}
	else
	{
		switch( self.weapon )
		{
			case "commando_sp":
				//subText = ( &"WEAPON_COMMANDO" );
				// MikeA: Not sure what the weapon syntax should be, so there will be no text for now (8/19/10)
				subText = &"";
				break;
		
			case "m1garand":
			case "m1garand_wet":
			case "lee_enfield":
			case "m1carbine":
			case "SVT40":
			case "mosin_rifle":
				subText = ( &"WEAPON_RIFLEMAN" ); 
				break; 
				
			case "thompson":
			case "thompson_wet":
				subText = ( &"WEAPON_SUBMACHINEGUNNER" ); 
				break; 
				
			case "BAR":
			case "ppsh":
			
			default:
				subText = ( &"WEAPON_SUPPORTGUNNER" ); 
				break; 
		}
	}

	if( ( IsDefined( self.model ) ) &&( IsSubStr( self.model, "medic" ) ) )
	{
		subText = ( &"WEAPON_MEDICPLACEHOLDER" ); 
	}
	assert( IsDefined( subText ) ); 
	
	self setlookattext( self.name, &""); 
}


/*=================================================================================
SELF: drone
PURPOSE: High level flow of a drone from creation to death
RETURNS: 
CREATOR: 
=================================================================================*/

drone_think( firstNode, override_target_node )
{
	self endon( "death" );

	self.health = 100;		// 100000 
	self thread drone_setName(); 
	
	if( (self.team == "allies") && (level.drones.friendly_fire) )
	{
		level thread maps\_friendlyfire::friendly_fire_think( self ); 
	}
	self thread drones_clear_variables(); 

	structarray_add( level.drones.team[self.team], self ); 

	level notify( "new_drone" ); 
	
	//-- GLocke:  Making this default for all the drones is adding an additional ent per drone, which is breaking levels.
	// If you need this functionality then you can set the level var to re-enable it, or we need to find a better solution
	if(IsDefined(level.drones_mg_target))
	{
		self.turrettarget = Spawn( "script_origin", self.origin+( 0, 0, 50 ) ); 
		self.turrettarget LinkTo( self ); 
	}

	self endon( "drone_death" );
	
	if ( IsDefined( level.drones.think_func ) ) 
	{
		self thread [[level.drones.think_func]](); 
	}
	
	//fake death if this drone is told to do so
	if ( !is_false(self.script_allowdeath) )
	{
		if ( IsDefined(level.drones.death_func) )
		{
			self thread [[ level.drones.death_func ]]();
		}
		else
		{
			self thread drone_fakeDeath(); 
		}
	}
	
	self.no_death_sink = false;
	if ( IsDefined( firstNode.script_drone_no_sink ) && firstNode.script_drone_no_sink )
	{
		self.no_death_sink = true;
	}

	if( IsDefined(override_target_node) )
	{
		self drone_runChain( override_target_node );
	}
	else if ( IsDefined( firstNode.target ) )
	{ 
		self drone_runChain( firstNode );
	}
	
	wait( 0.05 ); 	// Is this necessary for something?

	//Adrian B. 05.19.2010: add notify to level when a drone reaches final struct
	self.running = undefined; 
	level notify("drone_at_last_node", self);

	// If we're still alive, then do something
	self thread drone_loop_anim( firstNode );
}


/@
"Name: drone_loop_anim( s_reference )"
"Summary: Checks to see if a scene is defined"
"Module: Drones"
"MandatoryArg: <spawner> The targetname or spawner(s) to spawn a drone from.  "
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: is_scene_defined( "worker_idle" );"
"SPMP: singleplayer"
@/
drone_loop_anim( s_reference )
{
	self endon( "death" );
	self endon( "drone_death" );

	// Possibly play an idle animation if I spawned at a single struct
	if ( !IsDefined( s_reference.target ) )
	{
		if ( IsDefined( s_reference.dr_animation ) && IsDefined( level.drones.anims[ s_reference.dr_animation ] ) )
		{
			if ( IsArray( level.drones.anims[ s_reference.dr_animation ] ) )
			{
				anim_idle[0] = random( level.drones.anims[ s_reference.dr_animation ] );
			}
			else
			{
				anim_idle[0] = level.drones.anims[ s_reference.dr_animation ];
			}
		}
	}
	
	if ( !IsDefined( anim_idle ) )
	{
		// Use default anims
		while( IsDefined( self ) )
		{
			self AnimScripted( "drone_idle_anim", self.origin, self.angles, level.drones.anim_idle[ RandomInt(level.drones.anim_idle.size) ] );
			self waittillmatch( "drone_idle_anim", "end" ); 
		}
	}
	else
	{
		// Loop the anim
		while( IsDefined( self ) )
		{
			self AnimScripted( "drone_idle_anim", self.origin, self.angles, anim_idle[ RandomInt(anim_idle.size) ] );
			self waittillmatch( "drone_idle_anim", "end" ); 
		}
	}
}


/*=================================================================================
SELF: drone
PURPOSE: Special case mortar death animations
RETURNS: 
CREATOR: 
=================================================================================*/

#using_animtree( "fakeshooters" ); 
drone_mortarDeath( direction )
{
	self useAnimTree( #animtree ); 
	switch( direction )
	{
		case "up":
			self thread drone_doDeath( %death_explosion_up10 ); 
			break; 
		case "forward":
			self thread drone_doDeath( %death_explosion_forward13 ); 
			break; 
		case "back":
			self thread drone_doDeath( %death_explosion_back13 ); 
			break; 
		case "left":
			self thread drone_doDeath( %death_explosion_left11 ); 
			break; 
		case "right":
			self thread drone_doDeath( %death_explosion_right13 ); 
			break; 
	}
}

/*=================================================================================
SELF: drone
PURPOSE: Special case flame death animations
RETURNS: 
CREATOR: 
=================================================================================*/

#using_animtree( "fakeshooters" );
drone_flameDeath()
{
	self useAnimTree( #animtree );
	self thread drone_fakeDeath( true, true ); //
}


/*=================================================================================
SELF: drone
PURPOSE: Waits for drone to take damage and setups up the appropriate death anim
RETURNS: 
CREATOR: 
=================================================================================*/

#using_animtree( "fakeshooters" ); 
drone_fakeDeath( instant = false, flamedeath )
{
	self endon( "delete" ); 
	self endon( "drone_death" ); 
	
	while( IsDefined( self ) )
	{
		if( !instant )
		{
			self SetCanDamage( true ); 
			//self waittill( "damage", amount, attacker, direction_vec, damage_ori, type ); 
			self waittill( "damage", undefined, attacker, undefined, damage_ori, type ); //GLOCKE: optimization for vars
			
			// SRS testing special explosive death anims
			if( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE" || 
				type == "MOD_EXPLOSIVE_SPLASH" ||  type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" )
			{
				self.damageweapon = "none"; 
				explosivedeath = true; 
				//explosion_ori = damage_ori; //GLOCKE: remove a var
			}
			else if( type == "MOD_BURNED" )
			{
				flamedeath = true;
			}
			
			self death_notify_wrapper( attacker, type );
			
			if( self.team == "axis" && ( IsPlayer( attacker ) || attacker == level.playervehicle )  )
			{
				level notify( "player killed drone" ); 
				
				attacker thread maps\_damagefeedback::updateDamageFeedback();
			}
		}

		// MikeA: 2/22/11 - We want to delete drones if the are killed while performing a custom animation
		//					See MikeA or MarkM if this causes a problem
		//if( ( IsDefined( self.customFirstAnim ) ) &&( self.customFirstAnim == true ) )
		//{
		//	self waittill( "custom_anim_done" ); 
		//}
		
		if( !IsDefined( self ) )
		{
			return; 
		}
		
		self notify( "stop_shooting" ); 
	
		self.dontDelete = true; 
		
		self useAnimTree( #animtree ); 
		
		// SRS Did the guy take damage from an explosive?
		if( IS_TRUE(explosivedeath) )
		{
			// Alex Liu( 4-8-08 )
			// determin direction to play animation
			direction = drone_get_explosion_death_dir( self.origin, self.angles, damage_ori, 50 ); 
			
			self thread drone_mortarDeath( direction ); 
			return; 
		}
		else if( IS_TRUE(flamedeath) )
		{
			deaths[0] = %ai_flame_death_a;
			deaths[1] = %ai_flame_death_b;
			deaths[2] = %ai_flame_death_c;
			deaths[3] = %ai_flame_death_d;
		}
		// Bloodlust - if not explosive death, then check if drone is running
		else if( IsDefined( self.running ) )
		{
			deaths[0] = %death_run_stumble; 
			deaths[1] = %death_run_onfront; 
			deaths[2] = %death_run_onleft; 
			deaths[3] = %death_run_forward_crumple; 
		}
		else
		{
			deaths[0] = %death_stand_dropinplace; 
		}
		
		self thread drone_doDeath( deaths[RandomInt( deaths.size )] ); 
		return; 
	}
}

/*=================================================================================
SELF: drone
PURPOSE: Waits specified amount of time then kills the drone
RETURNS: 
CREATOR: 
=================================================================================*/

#using_animtree( "fakeshooters" ); 
//PARAMETER CLEANUP
drone_delayed_bulletdeath( waitTime = 0/*, deathRemoveNotify*/ )
{
	self endon( "delete" ); 
	self endon( "drone_death" ); 
	
	self.dontDelete = true; 
	
	if( waitTime > 0 )
	{
		wait( waitTime ); 
	}
	
	self thread drone_fakeDeath( true );
}


/*=================================================================================
SELF: 
PURPOSE: Plays generic death sound for drone based on their nationality
RETURNS: 
CREATOR: 
=================================================================================*/

do_death_sound()
{
	camp = level.campaign;
	team = self.team;

	alias = undefined;

	if(camp == "american" && team == "allies")
		alias = "dds_generic_death_american";
	if(camp == "american" && team == "axis")
		alias = "dds_generic_death_japanese";
	if(camp == "russian" && team == "allies")
		alias = "dds_generic_death_russian";
	if(camp == "russian" && team == "axis")
		alias = "dds_generic_death_german";
    if(camp == "vietnamese" && team == "axis")
        alias = "dds_generic_death_vietnamese ";
                
	if( IsDefined(alias) && SoundExists(alias) && !(level.drones.sounds_disabled) )
	{
		self thread play_sound_in_space( alias );
	}
}


/*=================================================================================
SELF: drone
PURPOSE: Handles the whole death process for a drone
RETURNS: 
CREATOR: 
=================================================================================*/

#using_animtree( "fakeshooters" ); 
drone_doDeath( deathAnim, deathRemoveNotify )
{
	self endon("delete");
	
	// KevinD: 10/30/11 - check to make sure the death functionality isn't called twice
	if( is_true( self.dead ) )
	{
		return;
	}
	else
	{
		self.dead = true;
	}
	
	self moveTo( self.origin, 0.05, 0, 0 );
	
	traceDeath = false; 

	if( ( IsDefined( self.running ) ) && self.running )
	{
		traceDeath = true; 
	}

	self.running = undefined; 
	
	self notify( "drone_death" ); 
	self notify( "stop_shooting" ); 
	
	self Unlink(); 
	self useAnimTree( #animtree ); 
	self thread drone_doDeath_impacts(); 
	
	do_death_sound();	

	cancelRunningDeath = false; 
	if( traceDeath )
	{
		//trace last frame of animation to prevent the body from clipping on something coming up in its path
		//backup animation if trace fails: %death_stand_dropinplace
		
		offset = getcycleoriginoffset( self.angles, deathAnim ); 
		endAnimationLocation = ( self.origin + offset ); 
		endAnimationLocation = PhysicsTrace( ( endAnimationLocation +( 0, 0, 128 ) ), ( endAnimationLocation -( 0, 0, 128 ) ) ); 
		//thread debug_line( endAnimationLocation +( 0, 0, 256 ), endAnimationLocation -( 0, 0, 256 ) ); 
		d1 = abs( endAnimationLocation[2] - self.origin[2] ); 
		
		if( d1 > 20 )
		{
			cancelRunningDeath = true; 
		}
		else
		{
			//trace even more forward than the animation( bounding box reasons )
			forwardVec = AnglesToForward( self.angles ); 
			rightVec = AnglesToRight( self.angles ); 
			upVec = anglestoup( self.angles ); 
			relativeOffset = ( 50, 0, 0 ); 
			secondPos = endAnimationLocation; 
			secondPos += VectorScale( forwardVec, relativeOffset[0] ); 
			secondPos += VectorScale( rightVec, relativeOffset[1] ); 
			secondPos += VectorScale( upVec, relativeOffset[2] ); 
			secondPos = PhysicsTrace( ( secondPos +( 0, 0, 128 ) ), ( secondPos -( 0, 0, 128 ) ) ); 
			d2 = abs( secondPos[2] - self.origin[2] ); 
			if( d2 > 20 )
			{
				cancelRunningDeath = true; 
			}
		}
	}
	
	if( cancelRunningDeath )
	{
		deathAnim = %death_stand_dropinplace; 
	}
	
	self animscripted( "drone_death_anim", self.origin, self.angles, deathAnim, "deathplant" );
	self thread drone_ragdoll( deathAnim );
	self waittillmatch( "drone_death_anim", "end" );
	
	if( !IsDefined( self ) )
	{
		return; 
	}

	self setcontents( 0 ); 
	if( IsDefined( deathRemoveNotify ) )
	{
		level waittill( deathRemoveNotify ); 
	}
	else
	{
		wait 3; 
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	if( !IsDefined(self.no_death_sink) || (IsDefined(self.no_death_sink) && !self.no_death_sink ))
	{
		self MoveTo( self.origin - ( 0, 0, 100 ), 7 ); 
	
		wait( 3 );
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	self.dontDelete = undefined; 
	self thread drone_delete(); 
}


/*=================================================================================
SELF: drone
PURPOSE: Drone drops weapon, if ragdoll slot available goes into ragdoll
RETURNS: 
CREATOR: 
=================================================================================*/

drone_ragdoll( deathAnim )
{
	time = self GetAnimTime( deathAnim );

	wait( time * 0.55 );
	
	if( IsDefined( self.weapon ) )
	{
		if( IsDefined( self.weaponmodel ) && self.weaponmodel != "" )
		{
			self detach( self.weaponmodel, "tag_weapon_right" ); 
		}
	}
	
	if( IsDefined( level.no_drone_ragdoll ) && level.no_drone_ragdoll == true )
	{
		// do nothing 
	}
	else
	{
		// Limit the number of drones that can go into ragdoll
		if( self drone_available_ragdoll() )
		{
			self add_to_ragdoll_bucket();
		}
		//self StartRagDoll();
	}
}


/*=================================================================================
SELF: drone
PURPOSE: Plays a Drones death effects and audio
RETURNS: 
CREATOR: 
=================================================================================*/

drone_doDeath_impacts()
{
	self endon( "death" );
	self endon( "drone_death" ); 	
	
	bone[0] = "J_Knee_LE"; 
	bone[1] = "J_Ankle_LE"; 
	bone[2] = "J_Clavicle_LE"; 
	bone[3] = "J_Shoulder_LE"; 
	bone[4] = "J_Elbow_LE"; 
	
	impacts = ( 1 + RandomInt( 2 ) ); 
	for( i=0; i<impacts; i++ )
	{
		playfxontag( level.drones.impact_fx, self, bone[RandomInt( bone.size )] ); 
		if( !level.drones.sounds_disabled )
		{
			self PlaySound( "prj_bullet_impact_small_flesh" ); 
		}
		wait( 0.05 ); 
	}
}


/*==============================================================
SELF: drone
PURPOSE: Drone follows the struct paths until it reaches the end
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/
drone_runChain( point_start )
{
	// GLOCKE: optimization - parent thread shares these endon
	//self endon( "death" );
	//self endon( "drone_death" ); 

	const minRate = 0.9; 
	const maxRate = 1.1; 

	self.v_destination = undefined;
	while( IsDefined( self ) )
	{
		//-----------------------------------------------------------------------------
		//check for script_death, script_death_min, script_death_max, and script_delete
		//-----------------------------------------------------------------------------
		if( IsDefined( point_start.dr_death_timer ) )
		{
			//drone will die between min-max seconds
			self.dontDelete = true; 

			timer_min	= get_min_value( point_start.dr_death_timer, false );
			timer_max	= get_max_value( point_start.dr_death_timer, false );
			time = timer_min;
			if ( timer_max > timer_min )
			{
				time = RandomFloatRange( timer_min, timer_max );
			}

			self thread drone_delayed_bulletdeath( time ); 
		}
		// New behaviour (MikeA 01/28/11)
		// if at the end of a path, the default behaviour is to delete the drone
		else if( !IsDefined( point_start.a_targeted ) && !IsDefined( point_start.script_delete ) )
		{
			self.dontDelete = undefined; 
			self thread drone_delete( 0.01 ); 
		}
				
		if( IS_TRUE( point_start.script_delete ) )
		{
			// Alex Liu 8-16-10: Added this line, otherwise the drones will not be actually deleted
			self.dontDelete = undefined; 
			self thread drone_delete( point_start.script_delete ); 
		}
		
		//-----------------------------------------------------------------------------
		
		if( !IsDefined( point_start.a_targeted ) )
		{
			break; 
		}

		point_end = point_start.a_targeted; 

		if( ( !IsDefined( point_end ) ) ||( !IsDefined( point_end[0] ) ) )
		{
			break; 
		}

		index = RandomInt( point_end.size ); 
		
		self.v_destination = GROUNDPOS( self, point_end[index].origin ); 
		
		//check for radius on node, since you can now make them run to a radius rather than an exact point
		if( IsDefined( point_end[index].radius ) )
		{
			assert( point_end[index].radius > 0 ); 
			
			//offset for this drone( -1 to 1 )
			if( !IsDefined( self.droneRunOffset ) )
			{
				self.droneRunOffset = ( 0 - 1 +( RandomFloat( 2 ) ) ); 
			}
			
			if( !IsDefined( point_end[index].angles ) )
			{
				point_end[index].angles = ( 0, 0, 0 ); 
			}
			
			forwardVec = AnglesToForward( point_end[index].angles ); 
			rightVec = AnglesToRight( point_end[index].angles ); 
			upVec = anglestoup( point_end[index].angles ); 
			relativeOffset = ( 0, ( self.droneRunOffset * point_end[index].radius ) , 0 ); 
			self.v_destination += VectorScale( forwardVec, relativeOffset[0] ); 
			self.v_destination += VectorScale( rightVec, relativeOffset[1] ); 
			self.v_destination += VectorScale( upVec, relativeOffset[2] ); 
		}
		
		self process_event( point_start );
		
		//drone loops run animation until he gets to his next point
		randomAnimRate = minRate + RandomFloat( maxRate - minRate ); 
		self thread drone_loop_run_anim( randomAnimRate ); 
	
		//actually move the dummies now )
		self drone_runto(); 
		
		point_start = point_end[index]; 
	}

	self process_event( point_start ); 

//	//drone loops run animation until he gets to his next point
//	self thread drone_loop_run_anim( randomAnimRate ); 
//
//	//actually move the dummies now )
//	self drone_runto(); 

	if( IS_TRUE( point_start.script_delete ) )
	{
		self thread drone_delete( point_start.script_delete ); 
	}
}


/*=================================================================================
SELF: drone
PURPOSE: Resets drone.voice
RETURNS: 
CREATOR: 
=================================================================================*/

drones_clear_variables()
{
	if( IsDefined( self.voice ) )
	{
		self.voice = undefined; 
	}
}


/*=================================================================================
SELF: drone
PURPOSE: Waits specified amount of time, then deletes the drone from the map
RETURNS: 
CREATOR: 
=================================================================================*/

drone_delete( delayTime )
{
	self endon( "death" );
	
	if( ( IsDefined( delayTime ) ) &&( delayTime > 0 ) )
	{
		wait( delayTime );
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	self notify( "drone_death" ); 
	self notify( "drone_idle_anim" ); 
	
	// guzzo 6-4-08 if the drones array doesn't contain the drone, don't remove it. this can happen because drone_delete() is called from both
	// drone_doDeath() and drone_runChain()
	if( ( IsInArray( level.drones.team[self.team].array, self ) ) )
	{
		structarray_remove( level.drones.team[self.team], self ); 
	}
	
	if( !IsDefined( self.dontDelete ) )
	{
		if( IsDefined( self.turrettarget ) )
		{
			self.turrettarget delete(); 
		}

		if( IsDefined( self.temp_target ) )
		{
			self.temp_target delete(); 
		}

		self detachall(); 
		self delete(); 
	}
}


/*==============================================================
SELF: drone
PURPOSE: Process the event at the current struct and then move to the next struct.
		Note: If a dr_animation is defined, that will play after the event is
		executed.
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/
#using_animtree( "fakeShooters" ); 
// #using_animtree( "generic_human" );
process_event( s_start )
{
	if( !IsDefined( self ) )
	{
		return; 
	}

	self endon("death");
	self endon( "drone_death" );	// you'll need this because of the wait below.  If he dies by other means before the wait is up, he might get deleted
	
	self notify( "stop_shooting" ); 
	
	self UseAnimTree( #animtree ); 
	

	//calculate the distance to the next run point and figure out how long it should take
	//to get there based on distance and run speed
	d = distance( self.origin, self.v_destination ); 

	if( !IsDefined(self.droneRunRate) )
	{
		self.droneRunRate = 200; 
	}

	self.n_travel_time = ( d / self.droneRunRate );
	
	//set his trace height back to normal
	self.lowheight = false; 
	//orient the drone to his run point
	self turn_to_face_point( self.v_destination, self.n_travel_time ); 
	
	// If a dr_percent is specified, roll the dice to see if we do this
	//	event or not
	skip = false;
	if ( IsDefined( s_start.dr_percent ) && 
		 ( RandomInt(100) < s_start.dr_percent ) )
	{
		skip = true;
	}

	//  Check to see if an event is specified for this location
	//	execute it and then run to the next struct.
	if( !skip && IsDefined( s_start.dr_event ) )
	{
		switch( s_start.dr_event )
		{
			// Stop and Shoot blanks
			case "shoot":
				self drone_event_shoot( s_start, false, false );
				break;

			// Stop and Shoot bursts of blanks
			case "shoot_burst":
				self drone_event_shoot( s_start, false, true );
				break;

			// Stop and Shoot blanks forever
			case "shoot_forever":
				self.n_shots_to_fire = 999999;
				self drone_event_shoot( s_start, false, false );
				break;

			// Shoot magic bullets (can get expensive if there's too much shooting)
			case "shoot_bullets":
				self drone_event_shoot( s_start, true );
				break;

			// Shoot while running
			case "run_and_shoot":
				self thread drone_event_run_and_shoot( false );
				break;

			// Shoot bursts while running
			case "run_and_shoot_burst":
				self thread drone_event_run_and_shoot( true );
				break;

			// Play a looped anim until notified to stop
			case "play_looped_anim":
				drone_event_looped_anim( s_start, self.v_destination );
				skip = true;	// skip over the execution of an animation as we leave
				break;

			case "low_height":
				self.lowheight = true;
				break;

			case "mortardeath_up":
				self thread drone_mortarDeath( "up" ); 
				return; 

			case "mortardeath_forward":
				self thread drone_mortarDeath( "forward" ); 
				return; 

			case "mortardeath_back":
				self thread drone_mortarDeath( "back" ); 
				return; 

			case "mortardeath_left":
				self thread drone_mortarDeath( "left" ); 
				return;

			case "mortardeath_right":
				self thread drone_mortarDeath( "right" ); 
				return; 

			case "cover_stand":
				self thread drone_cover( s_start.dr_event ); 
				
				// important waittill: will wait until drone gets this notify before continuing along the path
				self waittill( "drone out of cover" ); 
				
				self SetFlaggedAnimKnob( "cover_exit", %coverstand_trans_OUT_M, 1, .1, 1 ); 
				self waittillmatch( "cover_exit", "end" ); 
				break;
	
			case "cover_crouch":
				self thread drone_cover( s_start.dr_event ); 
				
				// important waittill: will wait until drone gets this notify before continuing along the path
				self waittill( "drone out of cover" ); 
				
				self SetFlaggedAnimKnob( "cover_exit", %covercrouch_run_out_M, 1, .1, 1 ); 
				self waittillmatch( "cover_exit", "end" ); 
				break;
				
			case "cover_crouch_fire":
				self thread drone_cover_fire( s_start.dr_event );
				
				// important waittill: will wait until drone gets this notify before continuing along the path
				self waittill( "drone out of cover" ); 
				
				self SetFlaggedAnimKnob( "cover_exit", %covercrouch_run_out_M, 1, 0.5, 1 ); 
				self waittillmatch( "cover_exit", "end" ); 
				break;
		
			case "flamedeath":
				self thread drone_flameDeath();
				break;
		
			case "run_fast":
				self drone_set_run_cycle();
				self.running = false;	// allows drone_loop_run_anim to restart below

				//recalculate the distance to the next point since it changed now
				d = distance( self.origin, self.v_destination ); 
				self.n_travel_time = ( d / self.droneRunRate ); 
				break;

			default:
				// Check to see if this is a custom event function
				event_params = strtok( s_start.dr_event, "," );
				if ( IsDefined( level.drones.funcs[ event_params[0] ] ) )
				{
					// remove the first parameter since we don't need it any more...
					//	not sure how performance heavy this could turn out, as this is mainly
					//	done for convenience in understanding for the end user.  It could easily be
					//	removed if needed for performance reasons.
					params = event_params;
					event_param = event_params[0];	// BJoyal (4/27/12) - storing the param in a seperate variable, seems to be deleted by ArrayRemoveValue()
					ArrayRemoveValue( params, event_params[0] );
					self [[ level.drones.funcs[ event_param ] ]]( s_start, self.v_destination, params );
				}
				else
				{
					AssertMsg( "The event \"" + s_start.dr_event + "\" is not a valid drone event.  If you are trying to use a custom event function, make sure it has been defined in level.drones.funcs" );
				}
				break;
		}
	}
	
	// if the node has a dr_animation defined, then play that anim
	if ( !skip && IsDefined( s_start.dr_animation ) )
	{
		assert( IsDefined( level.drones.anims[ s_start.dr_animation ] ),
			"There is no animation defined for level.drones.anims[ \"" + s_start.dr_animation + "\" ].  dr_animation defined at: "+ s_start.origin );

		// NOTE: Make sure level.drones.anims are defined under using_animtree( "fakeShooters" ).
		anim_custom = level.drones.anims[ s_start.dr_animation ];
		if ( IsArray( anim_custom ) )
		{
			anim_custom = anim_custom[ RandomInt( anim_custom.size ) ];
		}

		self.is_playing_custom_anim = true; 
		self.running = undefined; 
		angles = VectorToAngles( self.v_destination - self.origin ); 
		offset = getcycleoriginoffset( angles, anim_custom ); 
		endPos = self.origin + offset; 
		endPos = PhysicsTrace( ( endPos +( 0, 0, 64 ) ), ( endPos -( 0, 0, level.drones.trace_height ) ) ); 
		
		t = getanimlength( anim_custom ); 
		assert( t > 0 ); 
		self moveto( endPos, t, 0, 0 ); 
		
		// stop the old run thread
		self ClearAnim( self.drone_run_cycle, 0.20 ); 
		self notify( "stop_drone_loop_run_anim" ); 
		
		// Now we can play our custom anim
 		self SetFlaggedAnimKnobRestart( "drone_custom_anim", anim_custom ); 
		self waittillmatch( "drone_custom_anim", "end" ); 
		self.origin = endPos; 
		self notify( "custom_anim_done" ); 
		
		//recalculate the distance to the next point since it changed now
		d = distance( self.origin, self.v_destination ); 
		self.n_travel_time = ( d / self.droneRunRate ); 
		self.is_playing_custom_anim = undefined; 
	}
}	


/*==============================================================
SELF: drone
PURPOSE: Use moveto() to move drone to desstination over time.
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

drone_runto()
{
	// GLOCKE: optimization - parent parent thread shares these endon
	//self endon( "death" );
	//self endon( "drone_death" );	// you'll need this because of the wait below.  If he dies by other means before the wait is up, he might get deleted

	//-- GLocke: Removed this assert after talking to MikeD since the 
	//           function just returns if self.n_travel_time is < 0.1
	//assert( self.n_travel_time > 0 ); 
	if( self.n_travel_time < 0.1 )
	{
		return; 
	}
	//Make several moves to get there, each point tracing to the ground
	//X = ( x2-x1 ) * p + x1
	
	const percentIncrement = 0.1; 
	percentage = 0.0; 
	//incements = ( 1 / percentIncrement ); 
	//dividedMoveTime = ( self.n_travel_time * percentIncrement ); 
	startingPos = self.origin; 
	oldZ = startingPos[2]; 
	for( i = 0; i < 1 / percentIncrement; i++ )
	{
		percentage += percentIncrement; 
		x = ( self.v_destination[0] - startingPos[0] ) * percentage + startingPos[0]; 
		y = ( self.v_destination[1] - startingPos[1] ) * percentage + startingPos[1]; 
		if( self.lowheight == true )
		{
			percentageMark = PhysicsTrace( ( x, y, self.v_destination[2] + 64 ), ( x, y, self.v_destination[2] - level.drones.trace_height ) ); 		
		}
		else
		{
			percentageMark = PhysicsTrace( ( x, y, self.v_destination[2] + level.drones.trace_height ), ( x, y, self.v_destination[2] - level.drones.trace_height ) ); 
		}
		
		//if drone was told to go up more than level.drones.step_height( 100 ) units, keep old height
		if( ( percentageMark[2] - oldZ ) > level.drones.step_height )
		{
			percentageMark = ( percentageMark[0], percentageMark[1], oldZ ); 
		}
		
		oldZ = percentageMark[2]; 
			
		
		//thread drone_debugLine( self.origin, percentageMark, ( 1, 1, 1 ), dividedMoveTime ); 
		
		self moveTo( percentageMark, ( self.n_travel_time * percentIncrement ), 0, 0 ); 
		wait( ( self.n_travel_time * percentIncrement ) ); 
	}
}


/*==============================================================
SELF: drone
PURPOSE: The drone will fire its weapon until told to stop.
PARAMETERS: 
	s_start - the script_struct with the even parameter
		s_start KVPs:
			script_string - the name of an entity you wish to aim at
			script_int - the number of shots you wish to take
			dr_percent - the probability that this even will be executed
	b_shoot_bullets - this is true when you want them to fire a real bullet/projectile,
		as in shooting an RPG.
	b_shoot_burst - Do I shoot a 3-shot burst?  Otherwise will fire semi-auto.
RETURNS: NOTHING
CREATOR: MMaestas
===============================================================*/
drone_event_shoot( s_start, b_shoot_bullets, b_shoot_burst )
{
	self endon( "death" );

	if ( !IsDefined( b_shoot_bullets ) )
	{
		b_shoot_bullets = false;
	}
	if ( !IsDefined( b_shoot_burst ) )
	{
		b_shoot_burst = false;
	}

	// Override for number of shots that will be fired.  Defaults to a small series of shots
	if ( IsDefined( s_start.script_int ) )
	{
		self.n_shots_to_fire = s_start.script_int;
	}

	// Use the target specified in script_string or spawn a default
	e_target = undefined;	// scope declaration
	if ( IsDefined( s_start.script_string ) )
	{
		e_target = GetEnt( s_start.script_string, "targetname" );
		assert( IsDefined(e_target), "No target for drone event @ " + s_start.origin + ".  GetEnt failed looking for \"" + s_start.script_string + "\"" );
	}
	else
	{
		// Spawn a target (arbitrary distance) units in front of the drone.
		// Aiming seems to factor in that you're aiming at a human head (with its origin on the ground)
		target_offset = AnglesToForward( self.angles ) * 300;
		shootPos = self.origin + target_offset;	
		if( IsDefined( self.temp_target ) )
		{
			self.temp_target.origin = shootPos;
		}
		else
		{
			self.temp_target = Spawn( "script_origin", shootPos );
		}
		e_target = self.temp_target;
	}

	if( IS_TRUE(b_shoot_bullets) )
	{
		self drone_shoot_bullets( e_target );
	}
	else
	{
		self drone_shoot_blanks( e_target, b_shoot_burst ); 
	}

	self ClearAnim(%combat_directions, 0.2 );
	self ClearAnim(%exposed_reload, 0.2 );
}


/*==============================================================
SELF: drone
PURPOSE: Shoot a magic bullet at the target.  This is ideal for shooting an RPG at a target.
RETURNS: NOTHING
CREATOR: MMaestas
===============================================================*/
#using_animtree( "fakeShooters" ); 
drone_shoot_bullets( e_target )
{
	self endon( "death" );

	self UseAnimTree( #animtree ); 
	self.running = undefined; 
	self thread drone_aim_at_target( e_target, "stop_shooting" ); 

	v_tag_flash = self.origin + (0,0,50);
	
	if(!IsDefined(self.n_shots_to_fire))
	{
		self.n_shots_to_fire = 1;
	}
	
	for( i = 0; i < self.n_shots_to_fire; i++ )
	{
		if( self.bulletsInClip <= 0 )
		{
			self SetFlaggedAnimKnobAllRestart( "reloadanim", %exposed_reload, %root, 1, 0.4 ); 
			self.bulletsInClip = WeaponClipSize( self.weapon );
            self waittillmatch( "reloadanim", "end" ); 
  		}

		// Aim
		self Set3FlaggedAnimKnobs( "no flag", "aim", "stand", 1, 0.3, 1 ); 
		wait( 1 + RandomFloat( 2) );

		// Fire!
		v_tag_flash = self GetTagOrigin( "tag_flash" );
		MagicBullet( self.weapon, v_tag_flash, e_target.origin, self );
		self.bulletsInClip--;
		wait( 1 + RandomFloat( 2) );
	}
	
	self.n_shots_to_fire = undefined;
	self notify("stop_shooting");
}


/*==============================================================
SELF: drone
PURPOSE: Aim, then "shoot" your weapon until you are told to stop
	via a "stop_shooting" notify.
PARAMETERS: 	target - the thing to shoot at
				b_shoot_burst - shoot burst fire, or single shots if false
RETURNS: NOTHING
CREATOR: MMaestas
===============================================================*/
drone_shoot_blanks( e_target, b_shoot_burst )
{
	self endon( "death" );

	self notify( "stop_shooting" ); 
	self endon(  "stop_shooting" ); 

    if( !IsDefined(b_shoot_burst) )
    {
    	b_shoot_burst = false;
	}

    self UseAnimTree( #animtree ); 

	self.running = undefined; 
	self thread drone_aim_at_target( e_target, "stop_shooting" ); 

    shootAnimLength = 0; 

	if(!IsDefined(self.n_shots_to_fire))
	{
		self.n_shots_to_fire = 1;
	}

	n_shots_fired = 0;
	// Shoot (self.n_shots_to_fire) times
	while( n_shots_fired < self.n_shots_to_fire )
    {
        if( self.bulletsInClip <= 0 )    // Reload
        {
        	//see if this model is actually attached to this character
        	numAttached = self getattachsize(); 
        	attachName = []; 
        	for( i = 0; i < numAttached; i++ )
        	{
        		attachName[i] = self getattachmodelname( i ); 
        	}

            self SetFlaggedAnimKnobAllRestart( "reloadanim", %exposed_reload, %root, 1, 0.4 ); 
         	self.bulletsInClip = WeaponClipSize( self.weapon ); 
            self waittillmatch( "reloadanim", "end" ); 
        }

        // Aim for a while
        self Set3FlaggedAnimKnobs( "no flag", "aim", "stand", 1, 0.3, 1 ); 
        wait( 1 + RandomFloat( 2 ) );	// look like you're aiming

		if( !IsDefined( self ) )
		{
			return; 
		}

		// And shoot a few times
        n_shots = RandomInt( 4 )+ 1;
		// Don't fire more than the indicated number of times
		if ( n_shots > self.n_shots_to_fire - n_shots_fired )
		{
			n_shots = self.n_shots_to_fire - n_shots_fired;
		}
		// Don't fire more than we have bullets in the clip
        if( n_shots > self.bulletsInClip )
        {
            n_shots = self.bulletsInClip; 
        }

		// Okay, now you can shoot.
        for( i = 0; i < n_shots; i++ )
        {
        	if( !IsDefined( self ) )
			{
				return; 
			}

			self Set3FlaggedAnimKnobsRestart( "shootinganim", "shoot", "stand", 1, 0.05, 1 );
			blank_shot_fx( b_shoot_burst );
			if ( b_shoot_burst )
			{
				self.bulletsInClip = self.bulletsInClip - 3;
			}
			else
			{
			  	self.bulletsInClip--;
			}
			n_shots_fired++;

			// Remember how long the shoot anim is so we can cut it short in the future.
		    if( shootAnimLength == 0 )
			{
				shootAnimLength = GetTime(); 
				self waittillmatch( "shootinganim", "end" ); 
				shootAnimLength = ( GetTime() - shootAnimLength ) / 1000; 
			}
			else
		    {
				wait( shootAnimLength - 0.1 + RandomFloat( 0.3 ) ); 
				if( !IsDefined( self ) )
				{
			  		return; 
				}
			}
		}
	}

	self.n_shots_to_fire = undefined;
	self notify( "stop_shooting" ); 
}


/*==============================================================
SELF: drone
PURPOSE: Run and shoot until you reach your destination
PARAMETERS:
	b_shoot_burst - shoot burst fire, or single shots if false
RETURNS: NOTHING
CREATOR: MMaestas
===============================================================*/
drone_event_run_and_shoot( b_shoot_burst )
{
	old_cycle = self.drone_run_cycle;

	self drone_set_run_cycle( %run_n_gun_f );
	self.running = false;
	self thread drone_loop_run_anim(); 
	self thread drone_run_and_shoot_blanks( b_shoot_burst );

	self waittill( "stop_shooting" );

	// Return to your normal run
	self thread drone_set_run_cycle( old_cycle );
}


/*==============================================================
SELF: drone
PURPOSE: Generate fake shot sounds and FX at random intervals.  
	Does not perform any animations specific to this.
PARAMETERS: 
	b_shoot_burst - shoot in bursts of 3 shots
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/
drone_run_and_shoot_blanks( b_shoot_burst )
{
	self endon( "death" );
	self endon( "stop_shooting" ); 

	n_shots = 1;
	if ( b_shoot_burst )
	{
		n_shots = 3;
	}

	// Now start shooting at random intervals
	while ( 1 )
	{
        wait( 0.25 + RandomFloat( 2 ) );	// look like you're aiming
		
		blank_shot_fx( b_shoot_burst );
	}
}


/*==============================================================
SELF: drone
PURPOSE: Generate fake shot sounds and FX at random intervals.  
	Does not perform any animations specific to this.
PARAMETERS: 
	b_shoot_burst - if true, shoot in bursts of 3 shots
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/
blank_shot_fx( b_shoot_burst )
{
	self endon( "death" );

	//TODO: Put in actual sounds
	str_wpn_sound = "wpn_mosin_fire";

	n_shots = 1;
	if ( b_shoot_burst )
	{
		n_shots = 3;
	}

	for ( i=0; i<n_shots; i++ )
	{
		// And shoot a few times
		playfxontag( level.drones.muzzleflash, self, "tag_flash" ); 
		
		if( !level.drones.sounds_disabled )
		{		
			self PlaySound( str_wpn_sound ); 
        } 

		wait( 0.05 );
	}
}


/*==============================================================
SELF: drone
PURPOSE: Play a custom looped animation at the current spot.  All drones will 
	continute to play their looped anim until the flag "drones_stop_looped_anims" 
	is set.  Then all drones will continue on without performing the anim until 
	"drones_stop_looped_anims" is cleared.  
	For instance, you could have a bunch of drones idling until some alert happens,
	then they will all continue	on their splines and the spline can be reused as normal.

RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/
drone_event_looped_anim( s_start, v_destination )
{
	self endon( "death" );

	// Special flag for looped anims
	if ( !IsDefined( level.flag[ "drones_stop_looped_anims" ] ) )
	{
		flag_init( "drones_stop_looped_anims" );
	}

	// if the node has a dr_animation defined, then play that anim
	if ( !flag( "drones_stop_looped_anims" ) && IsDefined( s_start.dr_animation ) )
	{
		assert( IsDefined( level.drones.anims[ s_start.dr_animation ] ),
			"There is no animation defined for level.drones.anims[ \"" + s_start.dr_animation + "\" ].  dr_animation defined at: "+ s_start.origin );

		// NOTE: Make sure level.drones.anims are defined under using_animtree( "fakeShooters" ).
		anim_custom = level.drones.anims[ s_start.dr_animation ];
		if ( IsArray( anim_custom ) )
		{
			anim_custom = anim_custom[ RandomInt( anim_custom.size ) ];
		}

		self.is_playing_custom_anim = true; 
		self.running = undefined; 
		angles = VectorToAngles( v_destination - self.origin ); 
		offset = getcycleoriginoffset( angles, anim_custom ); 
		endPos = self.origin + offset; 
		endPos = PhysicsTrace( ( endPos +( 0, 0, 64 ) ), ( endPos -( 0, 0, level.drones.trace_height ) ) ); 
		
		t = getanimlength( anim_custom ); 
		assert( t > 0 ); 
		self moveto( endPos, t, 0, 0 ); 

		// stop the old run thread
		self ClearAnim( self.drone_run_cycle, 0.2 ); 
		self notify( "stop_drone_loop_run_anim" ); 

		// Now we can play our custom loop anim
		self SetAnim(anim_custom, 1, 0.2);
		flag_wait( "drones_stop_looped_anims" );

		// Pause so everyone doesn't run off at once
		wait(RandomFloatRange(0.1, 0.5));

		self ClearAnim(anim_custom, 0.2);

		//-- Reset run cycle if they were walking first
		self.drone_run_cycle = drone_pick_run_anim();

		self.origin = endPos; 
		self notify( "custom_anim_done" ); 
		
// UNUSED
		//recalculate the distance to the next point since it changed now
//		d = distance( self.origin, v_destination ); 
//		speed = ( d / self.droneRunRate ); 
		self.is_playing_custom_anim = undefined; 
	}
}


/*==============================================================
SELF: drone
PURPOSE: loop the running animation
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/
drone_loop_run_anim( animRateMod )
{
	if( IS_TRUE( self.running ) )
	{
		return; 
	}
	
	self notify( "stop_drone_loop_run_anim" ); 
	self endon( "stop_drone_loop_run_anim" ); 
	
	self endon( "delete" ); 
	self endon( "drone_death" ); 
		
	self.running = true; 
	
	if( !IsDefined( animRateMod ) )
	{
		animRateMod = 1.0; 
	}
	
//	adjustAnimRate = false; // disabled, bc this causes the anim to mismatch the actual run speed
	while( IS_TRUE( self.running ) )
	{
		animRate = ( self.droneRunRate / self.drone_run_cycle_speed ); 
		
//		if( adjustAnimRate )
//		{
//			animRate = ( animRate * animRateMod ); 
//			adjustAnimRate = false; 
//		}

		self SetFlaggedAnimKnobRestart( "drone_run_anim" , self.drone_run_cycle, 1, .2, animRate ); 
		self waittillmatch( "drone_run_anim", "end" ); 

		if( !IsDefined( self ) )
		{
			return; 
		}
	}
}


/*==============================================================
SELF: 
PURPOSE: DEBUG: Renders a line for X Frames
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

drone_debugLine( fromPoint, toPoint, color, durationFrames )
{
/#
    for( i = 0; i < durationFrames*20; i++ )
    {
        line( fromPoint, toPoint, color ); 
        wait( 0.05 ); 
    }
#/
}


/*==============================================================
SELF: drone
PURPOSE: Gets Drone to turn to face a point at specified speed
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

turn_to_face_point( point, n_time )
{
    // TODO Make this turn gradually, not instantly.
	desiredAngles = VectorToAngles( point - self.origin ); 
	
	if( !IsDefined( n_time ) )
	{
		n_time = 0.5; 
	}
	else if( n_time > 0.5 )
	{
		n_time = 0.5; 
	}
	
	if( n_time < 0.1 )
	{
		return; 
	}
	
	self rotateTo( ( 0, desiredAngles[1], 0 ), n_time, 0, 0 ); 
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

Set3FlaggedAnimKnobs( animFlag, animArray, pose, weight, blendTime, rate )
{
	if( !IsDefined( self ) )
	{
		return; 
	}

    self setAnimKnob( %combat_directions, weight, blendTime, rate ); 
    self SetFlaggedAnimKnob( animFlag,   level.drones.animArray[animArray][pose]["up"],        1, blendTime, 1 );
    self SetAnimKnob(                    level.drones.animArray[animArray][pose]["straight"],  1, blendTime, 1 );
    self SetAnimKnob(                    level.drones.animArray[animArray][pose]["down"],      1, blendTime, 1 );
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

Set3FlaggedAnimKnobsRestart( animFlag, animArray, pose, weight, blendTime, rate )
{
	if( !IsDefined( self ) )
	{
		return; 
	}

    self setAnimKnobRestart( %combat_directions, weight, blendTime, rate ); 
    self SetFlaggedAnimKnobRestart( animFlag,   level.drones.animArray[animArray][pose]["up"],       1, blendTime, 1 );
    self SetAnimKnobRestart(                    level.drones.animArray[animArray][pose]["straight"], 1, blendTime, 1 );
    self SetAnimKnobRestart(                    level.drones.animArray[animArray][pose]["down"],     1, blendTime, 1 );
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

apply_vertical_blend( offset )
{
    if( offset < 0 )
    {
        unstraightAnim = %combat_down; 
        self SetAnim( %combat_up,        0.01,    0, 1 ); 
        offset *= -1; 
    }
    else
    {
        unstraightAnim = %combat_up; 
        self SetAnim( %combat_down,        0.01,    0, 1 ); 
    }

    if( offset > 1 )
    {
        offset = 1; 
    }

    unstraight = offset; 

    if( unstraight >= 1.0 )
    {
        unstraight = 0.99; 
    }

    if( unstraight <= 0 )
    {
        unstraight = 0.01; 
    }
    straight = 1 - unstraight; 
    self SetAnim( unstraightAnim,         unstraight,    0, 1 ); 
    self SetAnim( %combat_straight,        straight,    0, 1 ); 
}    


/*==============================================================
SELF: drone
PURPOSE: Drones aims at target point, function will terminate on passed notify
RETURNS: NOTHING
CREATOR: Unknown
===============================================================*/

drone_aim_at_target( target, stopString )
{
	self endon( stopString ); 
	while( IsDefined( self ) )
	{
		targetPos = target.origin; 
		turn_to_face_point( targetPos ); 
		offset = get_target_vertical_offset( targetPos ); 
		apply_vertical_blend( offset ); 
		wait( 0.05 ); 
	}
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: z angle to target position
CREATOR: Unknown
===============================================================*/
	
get_target_vertical_offset( v_target_pos )
{
	dir = VectorNormalize( v_target_pos - self.origin ); 
	return dir[2]; 
}


/*==============================================================
SELF: 
PURPOSE: Initializes default drone animations
RETURNS: 
CREATOR: Unknown
===============================================================*/

set_anim_array()
{
    level.drones.animArray["aim"]   ["stand"]["down"]			 = %stand_aim_down; 
    level.drones.animArray["aim"]   ["stand"]["straight"]		 = %stand_aim_straight; 
    level.drones.animArray["aim"]   ["stand"]["up"]			 = %stand_aim_up; 

    level.drones.animArray["aim"]   ["crouch"]["down"]			 = %crouch_aim_down; 
    level.drones.animArray["aim"]   ["crouch"]["straight"]		 = %crouch_aim_straight; 
    level.drones.animArray["aim"]   ["crouch"]["up"]			 = %crouch_aim_up; 

    level.drones.animArray["auto"]   ["stand"]["down"]			 = %stand_shoot_auto_down; 
    level.drones.animArray["auto"]   ["stand"]["straight"]		 = %stand_shoot_auto_straight; 
    level.drones.animArray["auto"]   ["stand"]["up"]			 = %stand_shoot_auto_up; 

    level.drones.animArray["auto"]   ["crouch"]["down"]		 = %crouch_shoot_auto_down; 
    level.drones.animArray["auto"]   ["crouch"]["straight"]	 = %crouch_shoot_auto_straight; 
    level.drones.animArray["auto"]   ["crouch"]["up"]			 = %crouch_shoot_auto_up; 

    level.drones.animArray["shoot"]   ["stand"]["down"]		 = %stand_shoot_down; 
    level.drones.animArray["shoot"]   ["stand"]["straight"]	 = %stand_shoot_straight; 
    level.drones.animArray["shoot"]   ["stand"]["up"]			 = %stand_shoot_up; 

    level.drones.animArray["shoot"]   ["crouch"]["down"]		 = %crouch_shoot_down; 
    level.drones.animArray["shoot"]   ["crouch"]["straight"]	 = %crouch_shoot_straight; 
    level.drones.animArray["shoot"]   ["crouch"]["up"]			 = %crouch_shoot_up; 
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: 
CREATOR: Unknown
===============================================================*/

drone_cover_fire( type )
{
	self endon( "drone_stop_cover" );
	self endon( "drone_death" );
	self endon( "death" );
	
	
	while( true )
	{
		drone_cover( type ); // cycles a fixed number of times for cover_fire
		
		self SetAnimKnob( %stand_aim_straight, 1, 0.3, 1 ); 
		wait(0.3);
		
		forwardVec = AnglesToForward( self.angles ); 
		rightVec = AnglesToRight( self.angles ); 
		upVec = anglestoup( self.angles ); 
		relativeOffset = ( 300, 0, 0 ); 
		shootPos = self.origin; 
		shootPos += VectorScale( forwardVec, relativeOffset[0] ); 
		shootPos += VectorScale( rightVec, relativeOffset[1] ); 
		shootPos += VectorScale( upVec, relativeOffset[2] ); 
		if(IsDefined(self.temp_target))
		{
			self.temp_target Delete();
		}

		self.temp_target = Spawn( "script_origin", shootPos ); 
		self.bulletsInClip = randomint(4) + 3;
		self thread drone_shoot_blanks( self.temp_target, true ); 
		self waittill( "stop_shooting" );
	}
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: 
CREATOR: Unknown
===============================================================*/

drone_cover( type )
{
	self endon( "drone_stop_cover" ); 
		
	if( !IsDefined( self.a ) )
	{
		self.a = SpawnStruct(); 
	}
	
	self.running = undefined; 
	
	self.a.array = []; 
			
	if( type == "cover_stand" )
	{
		self.a.array["hide_idle"] = %coverstand_hide_idle;

		self.a.array["hide_idle_twitch"] = array( 
			%coverstand_hide_idle_twitch01, 
			%coverstand_hide_idle_twitch02, 
			%coverstand_hide_idle_twitch03, 
			%coverstand_hide_idle_twitch04, 
			%coverstand_hide_idle_twitch05
			); 

		self.a.array["hide_idle_flinch"] = array( 
			%coverstand_react01, 
			%coverstand_react02, 
			%coverstand_react03, 
			%coverstand_react04
			); 

		self SetFlaggedAnimKnobRestart( "cover_approach", %coverstand_trans_IN_M, 1, .3, 1 ); 
		self waittillmatch( "cover_approach", "end" ); 

		self thread drone_cover_think(); 
	}
	else if( type == "cover_crouch" )
	{	
		self.a.array["hide_idle"] = %covercrouch_hide_idle; 

		self.a.array["hide_idle_twitch"] = array( 
			%covercrouch_twitch_1, 
			%covercrouch_twitch_2, 
			%covercrouch_twitch_3, 
			%covercrouch_twitch_4
			); 
				
		self SetFlaggedAnimKnobRestart( "cover_approach", %covercrouch_run_in_M, 1, .3, 1 ); 
		self waittillmatch( "cover_approach", "end" ); 
		
		self thread drone_cover_think(); 	
	}
	else if( type == "cover_crouch_fire" )
	{	
		self.a.array["hide_idle"] = %covercrouch_hide_idle; 

		self.a.array["hide_idle_twitch"] = array( 
			%covercrouch_twitch_1, 
			%covercrouch_twitch_2, 
			%covercrouch_twitch_3, 
			%covercrouch_twitch_4
			); 
				
		self SetAnimKnob( %covercrouch_hide_idle, 1, 0.4, 1 ); 
		wait(0.4);
		
		self drone_cover_think( 1 + randomint(3) ); 	
	}
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: 
CREATOR: Unknown
===============================================================*/

drone_cover_think( max_loops )
{
	self endon( "drone_stop_cover" );
	
	if( !IsDefined(max_loops) )
	{
		max_loops = -1;
	}
	
	loops = 0;
		
	while( loops < max_loops || max_loops == -1 )
	{
		useTwitch = ( RandomInt( 2 ) == 0 ); 
		if( useTwitch )
		{
			idleanim = animArrayPickRandom( "hide_idle_twitch" ); 
		}
		else
		{
			idleanim = animarray( "hide_idle" ); 
		}
		
		self drone_playIdleAnimation( idleAnim, useTwitch ); 
		
		loops++;
	}
}


/*==============================================================
SELF: drone
PURPOSE: Playes a single idle loop
RETURNS: 
CREATOR: Unknown
===============================================================*/

drone_playIdleAnimation( idleAnim, needsRestart )
{
	self endon( "drone_stop_cover" ); 
	
	if( needsRestart )
	{
		self SetFlaggedAnimKnobRestart( "idle", idleAnim, 1, .1, 1 ); 
	}
	else
	{
		self SetFlaggedAnimKnob      ( "idle", idleAnim, 1, .1, 1 ); 
	}
	
	self.a.coverMode = "Hide"; 
	
	self waittillmatch( "idle", "end" ); 
}


/*==============================================================
SELF: 
PURPOSE: Find the direction the drone should fly towards from explosionm,Alex Liu 4-8-08 )
RETURNS: "up" -> If the explosion is clos to the drone( set by up_distance )
		 "left", "right", "forward", "back" -> Direction to throw the drone
		 NOTE: up_distance must be a non-zero positive value
CREATOR: Unknown
===============================================================*/

drone_get_explosion_death_dir( self_pos, self_angle, explosion_pos, up_distance )
{
	if( Distance2D( self_pos, explosion_pos ) < up_distance )
	{
		return "up"; 
	}

	// we need the angle between the self forward angle and the angle to the explosion
	// However to get this we need to draw a right triangle, find 2 sides, then ATan
	p1 = self_pos - VectorNormalize( AnglesToForward( self_angle ) ) * 10000; 
	p2 = self_pos + VectorNormalize( AnglesToForward( self_angle ) ) * 10000; 
	p_intersect = PointOnSegmentNearestToPoint( p1, p2, explosion_pos ); 

	side_away_dist = Distance2D( p_intersect, explosion_pos ); 
	side_close_dist = Distance2D( p_intersect, self_pos ); 

	if( side_close_dist != 0 )
	{
		angle = ATan( side_away_dist / side_close_dist ); 
	
		// depending on if the explosion is in front or behind self, modify the angle
		dot_product = vectordot( AnglesToForward( self_angle ), VectorNormalize( explosion_pos - self_pos ) ); 
		if( dot_product < 0 )
		{
			angle = 180 - angle; 
		}

		if( angle < 45 )
		{
			return "back"; 
		}
		else if( angle > 135 )
		{
			return "forward"; 
		}
	}

	// now we need to know if this is to the left or right
	// We can simply creat another point either to the left or right side of self( I choose right )
	// and see if it's closer to the explosion. The new point must be closer than up_distance, or
	// the result can be wrong. 
	self_right_angle = VectorNormalize( AnglesToRight( self_angle ) ); 
	right_point = self_pos + self_right_angle *( up_distance * 0.5 ); 
	
	if( Distance2D( right_point, explosion_pos ) < Distance2D( self_pos, explosion_pos ) )
	{
		return "left"; 
	}
	else
	{
		return "right"; 
	}
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: 
CREATOR: Unknown
===============================================================*/

// ALEXP_TODO: convert all this to use the new anim array scheme
animArray( animname ) /* string */ 
{
	assert( IsDefined(self.a.array) );

	/#
	if ( !IsDefined(self.a.array[animname]) )
	{
		dumpAnimArray();
		assert( IsDefined(self.a.array[animname]), "self.a.array[ \"" + animname + "\" ] is undefined" );
	}
	#/

	return self.a.array[animname];
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: 
CREATOR: Unknown
===============================================================*/

animArrayAnyExist( animname )
{
	assert( IsDefined( self.a.array ) );

	/#
	if ( !IsDefined(self.a.array[animname]) )
	{
		dumpAnimArray();
		assert( IsDefined(self.a.array[animname]), "self.a.array[ \"" + animname + "\" ] is undefined"  );
	}
	#/
	
	return self.a.array[animname].size > 0;
}


/*==============================================================
SELF: drone
PURPOSE: 
RETURNS: 
CREATOR: Unknown
===============================================================*/

animArrayPickRandom( animname )
{
	assert( IsDefined( self.a.array ) );

	/#
	if ( !IsDefined(self.a.array[animname]) )
	{
		dumpAnimArray();
		assert( IsDefined(self.a.array[animname]), "self.a.array[ \"" + animname + "\" ] is undefined"  );
	}
	#/

	assert( self.a.array[animname].size > 0 );
	
	if ( self.a.array[animname].size > 1 )
	{
		index = RandomInt( self.a.array[animname].size );
	}
	else
	{
		index = 0;
	}

	return self.a.array[animname][index];
}

/#
dumpAnimArray()
{
	println("self.a.array:");
	keys = getArrayKeys( self.a.array );

	for ( i=0; i < keys.size; i++ )
	{
		if ( isarray( self.a.array[ keys[i] ] ) )
		{
			println( " array[ \"" + keys[i] + "\" ] = {array of size " + self.a.array[ keys[i] ].size + "}" );
		}
		else
		{
			println( " array[ \"" + keys[i] + "\" ] = ", self.a.array[ keys[i] ] );
		}
	}
}
#/


/*==============================================================
SELF: drone
PURPOSE: Finds a run animation for a drone
RETURNS: Drone run anim from the fakeshoters.atr file
CREATOR: unknown - Modified by MikeA (02/14/11)
===============================================================*/

#using_animtree( "fakeshooters" ); 
drone_pick_run_anim()
{
	// Legacy, a global array can be used to override the run cylees for all drones
	if(IsDefined(level.drone_run_cycle_override))
	{
		if(IsArray(level.drone_run_cycle_override))
		{
			return level.drone_run_cycle_override[RandomInt(level.drone_run_cycle_override.size)];
		}
		else
		{
			return level.drone_run_cycle_override;
		}
	}
	
	// Drones can hold a an aray of their override animations
	else if( IsDefined(self.drone_run_cycle_override) )
	{
		if(IsArray(self.drone_run_cycle_override))
		{
			return self.drone_run_cycle_override[RandomInt(self.drone_run_cycle_override.size)];
		}
		else
		{
			return self.drone_run_cycle_override;
		}
	}
	
	// No overrides used, so randomly pick one of the default drone runa animations
	// GLocke 9/30/2012 - removed the ai_viet_run
	droneRunAnims = array(	%combat_run_fast_3, 
							%run_n_gun_F, 
							%ai_viet_run_n_gun_F, 
							%ai_digbat_run_lowready_f, 
							%ch_khe_E1B_troopssprint_1,
							%ch_khe_E1B_troopssprint_2,
							%ch_khe_E1B_troopssprint_3,
							%ch_khe_E1B_troopssprint_4,
							%ch_khe_E1B_troopssprint_5,
							%ch_khe_E1B_troopssprint_6,
							%ch_khe_E1B_troopssprint_7 );

	index = RandomInt( droneRunAnims.size );

	// TODO:	Find out why the Khe Sahn animations cause the drones to slide around
	//			Only anim indexes 0,1,2,3 work  (MikeA 02/14/11)
	index = RandomInt( 4 );

	return droneRunAnims[index];
}


/*==============================================================
SELF: drone
PURPOSE: Sets a drones run animation and speed
RETURNS: 
CREATOR: Unknown
===============================================================*/

drone_set_run_cycle( runAnim )
{
	if( !IsDefined(runAnim) )
	{
		runAnim = drone_pick_run_anim();
	}

	self.drone_run_cycle		= runAnim;
	self.drone_run_cycle_speed	= drone_run_anim_speed( runAnim );
	self.droneRunRate			= self.drone_run_cycle_speed;
}


/*==============================================================
SELF: drone
PURPOSE: Calculates a drones speed
RETURNS: Returns speed
CREATOR: Unknown
===============================================================*/

drone_run_anim_speed( runAnim )
{
	run_cycle_delta		= GetMoveDelta( runAnim, 0, 1 );
	run_cycle_dist		= Length( run_cycle_delta );
	run_cycle_length	= GetAnimLength( runAnim );
	run_cycle_speed		= run_cycle_dist / run_cycle_length;

	return run_cycle_speed;
}


/*==============================================================
SELF: drone
PURPOSE: Get all drone triggers with specified (script_string) name
RETURNS: Array of triggers
CREATOR: MikeA
===============================================================*/

drones_get_triggers( script_string_trigger_name )
{
	// Search for the 
	triggers = [];
	
	// Search for an axis drone trigger with the script string name
	if( IsDefined(level.drones.axis_triggers) )
	{
		ents = level.drones.axis_triggers;
		for( i=0; i<ents.size; i++ )
		{
			if( IsDefined(ents[i].script_string) )
			{	
				if( ents[i].script_string == script_string_trigger_name )
				{
					triggers[ triggers.size ] = ents[i];
				}
			}
		}
	}

	// Search for an allies drone trigger with the script string name
	if( IsDefined(level.drones.allies_triggers) )
	{
		ents = level.drones.allies_triggers;
		for( i=0; i<ents.size; i++ )
		{
			if( IsDefined(ents[i].script_string) )
			{	
				if( ents[i].script_string == script_string_trigger_name )
				{
					triggers[ triggers.size ] = ents[i];
				}
			}
		}
	}

	return( triggers );
}



/*==============================================================
SELF: 
PURPOSE: Sets the max number of drones that can go into ragdoll
RETURNS: 
CREATOR: MikeA
===============================================================*/

drones_set_max_ragdolls( max_ragdolls )
{
	level.drones.max_ragdolls = max_ragdolls;
}


/*====================================================================================
SELF: drone
PURPOSE: Are there any ragdoll slots available for a drone?
		 If there are no ragdolls available you can force a slot to be freed up
RETURNS: true if there is a ragdoll slot available for the drone
CREATOR: MikeA
=====================================================================================*/

drone_available_ragdoll( force_remove )
{
	if( !IsDefined(level.drones.ragdoll_bucket) )
	{
		level.drones.ragdoll_bucket = [];
	}
	
	if( level.drones.ragdoll_bucket.size >= level.drones.max_ragdolls )
	{
		//-- too many guys, lets see if we can remove any
		num_in_bucket = clean_up_ragdoll_bucket();
		
		if( num_in_bucket < level.drones.max_ragdolls )
		{
			return true; //-- freed up some ragdoll slots
		}
		else if( IsDefined(force_remove) ) //-- we have to remove one for this very important ragdoll
		{
			if(level.drones.ragdoll_bucket[0].targetname == "drone")
			{
				self.dontdelete = undefined;
				level.drones.ragdoll_bucket[0] maps\_drones::drone_delete();
			}
			else
			{
				level.drones.ragdoll_bucket[0] Delete();
			}
			
			ArrayRemoveIndex( level.drones.ragdoll_bucket, 0 );
			return true;
		}
		
		return false; //-- couldn't free any ragdoll slots
	}
	
	return true; //-- there was already ragdoll slots free
}



/*====================================================================================
SELF: drone
PURPOSE: Starts a drone in Ragdoll
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

add_to_ragdoll_bucket()
{
	if( !IsDefined(level.drones.ragdoll_bucket) )
	{
		level.drones.ragdoll_bucket = [];
	}
	
	self.ragdoll_start_time = GetTime();
	level.drones.ragdoll_bucket[level.drones.ragdoll_bucket.size] = self;
	
	self StartRagdoll();
}


/*====================================================================================
SELF: 
PURPOSE: Try and free up some drones in the ragdoll pool
RETURNS: Number of drones still in ragdoll
CREATOR: MikeA
=====================================================================================*/

clean_up_ragdoll_bucket()
{
	current_time = GetTime();
	
	new_bucket = [];
	for( i=0; i<16; i++ )
	{
		if( !IsDefined(level.drones.ragdoll_bucket[i]) )
		{
			continue;
		}

		ragdoll_time = (current_time - level.drones.ragdoll_bucket[i].ragdoll_start_time) / 1000;
	
		if( (ragdoll_time < 4) || IsDefined(self.is_playing_custom_anim) )
		{
			new_bucket[new_bucket.size] = level.drones.ragdoll_bucket[i];
		}
		else
		{
			if( IsDefined(level.drones.ragdoll_bucket[i].targetname) && level.drones.ragdoll_bucket[i].targetname == "drone")
			{
				level.drones.ragdoll_bucket[i].dontdelete = undefined;
				level.drones.ragdoll_bucket[i] maps\_drones::drone_delete();
			}
			else
			{
				level.drones.ragdoll_bucket[i] Delete();
			}
		}
	}
	
	level.drones.ragdoll_bucket = new_bucket;
	return( level.drones.ragdoll_bucket.size );
}


/*====================================================================================
SELF: 
PURPOSE: Use to pause and un-pause active drone spawners
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

drones_pause( script_string_name, paused )
{
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		if( IsDefined(level.drones.drone_spawners[i].script_string) )
		{
			if( level.drones.drone_spawners[i].script_string == script_string_name )
			{
				level.drones.drone_spawners[i].paused = paused;
			}
		}
	}
}


/*====================================================================================
SELF: 
PURPOSE: Used to add speed variance to drones
		 A typical value to use would be (-0.2, 0.2) this is a safe amount to modify the drone speed by
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

drones_speed_modifier( script_string_name, min_speed, max_speed )
{
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		if( IsDefined(level.drones.drone_spawners[i].script_string) )
		{
			if( level.drones.drone_spawners[i].script_string == script_string_name )
			{
				level.drones.drone_spawners[i].speed_modifier_min = min_speed;
				level.drones.drone_spawners[i].speed_modifier_max = max_speed;
			}
		}
	}
}


/*====================================================================================
SELF: 
PURPOSE: Used to assign a unique set of run animations to a drone trigger
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

drones_setup_unique_anims( script_string_name, anim_array )
{
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		if( IsDefined(level.drones.drone_spawners[i].script_string) )
		{
			if( level.drones.drone_spawners[i].script_string == script_string_name )
			{
				level.drones.drone_spawners[i].drone_run_cycle_override = anim_array;
			}
		}
	}
}


/*====================================================================================
SELF: 
PURPOSE: Set the RESPAWN functionality min and max delay times
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

drones_set_respawn_death_delay( min_delay, max_delay )
{
	level.drones.respawn_death_delay_min = min_delay;
	level.drones.respawn_death_delay_max = max_delay;
}


/*====================================================================================
SELF: level
PURPOSE: self.a_targeted = array of drone start structs
		 As soon as a drone has reached the end of the shortest path, the pre population will terminate
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

pre_populate_drones( drones, spawn_min, spawn_max, team )
{
	// Notify the script a new drone wave is spawning
	level notify( "new drone Spawn wave" ); 
	
	// Find the length of the drone paths and use the SMALLEST path
	path_size = undefined;
	for( i=0; i<drones.a_targeted.size; i++ )
	{
		size = calc_drone_path_size( drones.a_targeted[i] );
		if( !IsDefined(path_size) || (size < path_size) )
		{
			path_size = size;
		}
	}

	// Get the Drones run speed
	// TODO - How do we get an accurate run speed?
	const run_speed = 320;
	
	// Loop through populating the drone paths	
	dist = 0;
	while( dist < path_size )
	{
		// How many drones should spawn?
		spawn_size = spawn_min;
		if( spawn_max > spawn_min )
		{
			spawn_size = RandomIntRange( spawn_min, (spawn_max+1) ); 
		}

		level thread drone_spawngroup( drones, drones.a_targeted, spawn_size, team, dist );
		
		dist += run_speed;
	}	
}


/*====================================================================================
SELF: level
PURPOSE: Calcuates the length of a drone path from the start node to the end node
RETURNS: Path size
CREATOR: MikeA
=====================================================================================*/

calc_drone_path_size( node )
{
	size = 0;
	if( IsDefined(node.target) )
	{
		while( 1 )
		{
			next_node_struct = getstruct( node.target, "targetname" );
			size += Distance( node.origin, next_node_struct.origin );
			node = getstruct( node.target, "targetname" );
			if( !IsDefined(node.target) )
			{
				break;
			}
		}
	}
	return( size );
}


/*====================================================================================
SELF: 
PURPOSE: Starts a Drone Spawner
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

drones_start( script_string_name )
{
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		spawner = level.drones.drone_spawners[i];
		if( IsDefined(spawner.script_string) )
		{
			if( spawner.script_string == script_string_name )
			{
				if( IsDefined(spawner.parent_trigger) )
				{
					spawner.parent_trigger notify( "trigger" );
				}
				else if( IsDefined(spawner.parent_script_struct) )
				{
					spawner.parent_script_struct notify( "trigger" );
				}
			}
		}
	}
}


/*====================================================================================
SELF: 
PURPOSE: Deletes a drone spawner, works for both drone triggers or drone structs
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

drones_delete( script_string_name )
{
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		spawner = level.drones.drone_spawners[i];
		if( IsDefined(spawner.script_string) )
		{
			if( spawner.script_string == script_string_name )
			{
				spawner.delete_spawner = 1;
			}
		}
	}
}


/*====================================================================================
SELF: 
PURPOSE: Assigns a spawner to a drone trigger, call multiple times to add multiple spawners
RETURNS: 
CREATOR: MikeA
=====================================================================================*/

drones_assign_spawner( script_string_name, spawner_guy )
{
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		spawner = level.drones.drone_spawners[i];
		if( IsDefined(spawner.script_string) )
		{
			if( spawner.script_string == script_string_name )
			{
				if( !IsDefined(spawner.unique_guys) )
				{
					spawner.unique_guys = [];
				}
				spawner.unique_guys[spawner.unique_guys.size] = spawner_guy;
			}
		}
	}
}


/*==============================================================
SELF:
PURPOSE: Debug suport function for notifys
RETURNS: 
CREATOR: MikeA
===============================================================*/

drone_notify( param0, param1, param2 )
{
	self notify( param0, param1, param2 );
	iprintlnbold ( param0 );
}


/*==============================================================
SELF:
PURPOSE: Debug suport function for notifys
RETURNS: 
CREATOR: MikeA
===============================================================*/

drones_death_notify_wrapper( attacker, damageType )
{
	level drone_notify( "face", "death", self );
	self drone_notify( "death", attacker, damageType );
}


/*==============================================================
SELF: spawner
PURPOSE: Get a Drone Spawner
		 Take the model and data needed to create a drone off the spawner
		 Add to axis or allies list of potential drone models
RETURNS: 
CREATOR: MikeA
===============================================================*/

drone_add_spawner()
{
	//**************************
	// Check its a valid Spawner
	//**************************

	if ( !IsDefined( self.classname ) )
	{
		return;
	}
	
	if ( !is_spawner( self ) )
	{
		return;
	}


	//********************************************************************
	// If its an Axis or Allies spawner, add it to an array of class names
	//********************************************************************

	if( !IsDefined(level.drones) )
	{
		level.drones = SpawnStruct();
	}

	if( !IsDefined(level.drones.axis_classnames) )
	{
		level.drones.axis_classnames = [];
	}
	if( !IsDefined(level.drones.allies_classnames) )
	{
		level.drones.allies_classnames = [];
	}

	// If the spawner is Axis or Allies, add it to the drone list
	side = drone_spawner_side( self.classname );
	if( side == "AXIS" )
	{
		// Don't add duplicate spawners with the same classname
		for( i=0; i<level.drones.axis_classnames.size; i++ )
		{
			if( level.drones.axis_classnames[i] == self.classname )
			{
				return;
			}
		}
	
		level.drones.axis_classnames[ level.drones.axis_classnames.size ] = self.classname;
	}
	else if( side == "ALLIES" )
	{
		// Don't add duplicate spawners with the same classname
		for( i=0; i<level.drones.allies_classnames.size; i++ )
		{
			if( level.drones.allies_classnames[i] == self.classname )
			{
				return;
			}
		}
	
		level.drones.allies_classnames[ level.drones.allies_classnames.size ] = self.classname;		
	}
}


/*==============================================================
SELF: 
PURPOSE: Search the name.
		 Is the name an Axis or Allies name?
RETURNS: 
CREATOR: MikeA
===============================================================*/

drone_spawner_side( name )
{
	test = ToLower( name );

	if( IsSubStr( test, "_ally_" ) )
	{
		return( "ALLIES" );
	}
	else if( IsSubStr( test, "_a_" ) )
	{
		return( "ALLIES" );
	}
	else if( IsSubStr( test, "_enemy_" ) )
	{
		return( "AXIS" );
	}
	else if( IsSubStr( test, "_e_" ) )
	{
		return( "AXIS" );

	}

	return( "" );
}


/*==============================================================
SELF: drone
PURPOSE: Set the model, attachmends and head model to the drone model
RETURNS: 
CREATOR: MikeA
==============================================================*/

drone_get_axis_spawner_class()
{
	drone_class = undefined;
	if( IsDefined(level.drones.axis_classnames) && (level.drones.axis_classnames.size > 0) )
	{
		index = randomint( level.drones.axis_classnames.size );	
		drone_class = level.drones.axis_classnames[index];
	}
	return( drone_class );
}


/*==============================================================
SELF: drone
PURPOSE: Set the model, attachmends and head model to the drone model
RETURNS: 
CREATOR: MikeA
==============================================================*/

drone_get_allies_spawner_class()
{
	drone_class = undefined;
	if( IsDefined(level.drones.allies_classnames) && (level.drones.allies_classnames.size > 0) )
	{
		index = randomint( level.drones.allies_classnames.size );
		drone_class = level.drones.allies_classnames[index];
	}
	return( drone_class );
}

/*==============================================================
SELF: drone
PURPOSE: Sets up the model, gear and head of an axis drone
RETURNS: 
CREATOR: MikeA
===============================================================*/

spawn_random_axis_drone( override_class )
{
	if( IsDefined(override_class) )
	{
		class = override_class;
	}
	else
	{
		class = drone_get_axis_spawner_class();
	}
	assert( IsDefined(class), "CANT FIND AXIS DRONE TO SPAWN" );
	self getdronemodel( class );
	self setCurrentWeapon(self.weapon);
}


/*==============================================================
SELF: drone
PURPOSE: Sets up the model, gear and head of a allies drone
RETURNS: 
CREATOR: MikeA
===============================================================*/

spawn_random_allies_drone( override_class )
{
	if( IsDefined(override_class) )
	{
		class = override_class;
	}
	else
	{
		class = drone_get_allies_spawner_class();
	}
	assert( IsDefined(class), "CANT FIND ALLIES DRONE TO SPAWN" );
	self getdronemodel( class );
	self.dr_ai_classname = class;//Store classname for use in BO2 name system
	self setCurrentWeapon(self.weapon);
}


/*==============================================================
SELF: not used
PURPOSE: Returns an array of drones of a particular team
RETURNS: Returns an array of drones of a particular team
CREATOR: MikeA
===============================================================*/

drones_get_array( str_team )
{
	array = [];

	if( IsDefined(level.drones.team) )
	{
		// Get all the alive axis drones
		if( str_team == "axis" )
		{
			if( IsDefined(level.drones.team["axis"]) )
			{
				axis_drones = level.drones.team["axis"].array;
				for( i=0; i<axis_drones.size; i++ )
				{
					if( axis_drones[i].health > 0 )
					{
						array[ array.size ] = axis_drones[i];
					}
				}
			}
		}
	
		// Get all the alive allies drones
		else if( str_team == "allies" )
		{
			if( IsDefined(level.drones.team["allies"]) )
			{
				allies_drones = level.drones.team["allies"].array;
				for( i=0; i<allies_drones.size; i++ )
				{
					if( allies_drones[i].health > 0 )
					{
						array[ array.size ] = allies_drones[i];
					}
				}
			}
		}
	}

	return( array );	
}


//
//	Delete all spawned drones in existence
//		Optional: str_noteworthy - use this to only delete drones whose script_noteworthy matches this.
//						If not defined, then delete all
drones_delete_spawned( str_noteworthy )
{
	a_m_drones = GetEntArray( "drone", "targetname" );
	foreach( index, m_drone in a_m_drones )
	{
		if ( IsDefined( m_drone ) )
		{
			// If str_noteworthy is defined, then check if there is a match before deleting, otherwise delete all
			if ( !IsDefined( str_noteworthy ) || ( IsDefined( m_drone.script_noteworthy ) && str_noteworthy == m_drone.script_noteworthy ) )
			{
				m_drone.dontDelete = undefined;
				m_drone thread drone_delete(); 
			}
		}
		// Throttle it a bit
		if ( index % 20 == 0 )
		{
			wait( 0.05 );
		}
	}
}


/*====================================================================================
SELF: 
PURPOSE: Optimizes the rendering of drones.  Note: This will only work on a full body 
			drone (even the weapon should be in the model if needed)
RETURNS: 
CREATOR: MarkM
=====================================================================================*/
drones_set_cheap_flag( script_string_name, b_use_cheap_flag )
{
	for( i=0; i<level.drones.drone_spawners.size; i++ )
	{
		spawner = level.drones.drone_spawners[i];
		if ( IsDefined(spawner.script_string) && spawner.script_string == script_string_name )
		{
			spawner.b_use_cheap_flag = b_use_cheap_flag;
		}
	}
}


