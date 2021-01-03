//
//	SETUP
//	- Zones: Place info_volumes to indicate zone areas.
//	- Spawn locs: volumes target structs
//	- Spawners: 
//		targetname : enemy_spawner
//		script_noteworthy : (type name - used for spawn wave grouping )

#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\systems\shared;

#using scripts\shared\vehicles\_quadtank;
#using scripts\shared\vehicle_ai_shared;

#using scripts\cp\_load;
#using scripts\cp\_laststand;
#using scripts\cp\_util;

#using scripts\cp\sm\_sm_ai_manager;
#using scripts\cp\sm\_sm_zone_mgr;
#using scripts\cp\sm\_sm_round_beacon;

                                                                                                            	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                   	       	     	          	      	                                                                                            	                                                           	                                  

#namespace wave_mgr;

function autoexec __init__sytem__() {     system::register("sm_wave_mgr",&__init__,&__main__,undefined);    }

// Wave Size
	// Modifier to the AI count based on the number of extra players
	// How many AI will attempt to spawn from a zone per group

// Wave Simultaneous AI
	// How many AI can be alive at any one time (modified by # of players)
	// How many AI to add to the base per round
	// How many AI can be alive at any one time EVER

// Wave End
	// How many AI can be alive before we start counting down to the next wave (modified by num players)
	// Minumum time between waves (after minimum AI alive)
	// Maximum time between waves (after minimum AI alive)

function __init__()
{
	level flag::init( "start_wave_spawner" );
	
	level.wave_mgr = spawnstruct();
	wm = level.wave_mgr;

/#
	wm flag::init( "enabled", true );		// devgui function to allow the wave_mgr to spawn regardless of current status
#/
	wm flag::init( "active" );		// is wave logic actively running?
	wm flag::init( "spawning" );	// Are we trying to spawn guys?  (not between waves)
	wm flag::init( "repeat_wave_number" );
	
	wm.n_wave_num					= 1;
	wm.n_spawn_loc_index			= [];
	wm.n_group_size					= 20;
	wm.n_num_to_spawn				= 0;
	wm.n_max_active_ai				= 6;
	wm.a_ai_wave_enemies 			= [];
	wm.a_enemy_types				= [];
	wm.a_n_ai_spawn_delay			= array( 3.0, 2.0, 1.5, 1.0 );	//	Spawn Delay between groups based on the number of players
	wm.a_n_group_spawn_delay		= array( 8.0, 7.0, 6.0, 5.0 );	//	Spawn Delay between groups based on the number of players
	wm.b_wave_end_override			= false;
	
	add_archetype_spawn_funcs();
	callback::on_ai_killed( &remove_from_wave_enemies );	
}


function __main__()
{
	// If you want to define your own enemy type info, do so before _load::main.
	// If you do not define your own enemy types, we will use a default set
	if ( level.wave_mgr.a_enemy_types.size == 0 )
	{
		default_enemy_type_info();
	}
	
	level.wave_mgr thread wave_logic();
}


//***************************************************
//	SPAWN FUNCIONS FOR ARCHETYPES
//***************************************************

function add_archetype_spawn_funcs()
{
	
}

function archetype_spawn_func()
{
	
}

//***************************************************
//	EXTERNAL ACCESS / COMMAND FUNCTIONS
//***************************************************


//
//
function get_player_multiplier()
{
	n_players = level.players.size;
/#
	// Can set the number of players for the purposes of difficulty scaling
	n_force_players = GetDvarInt( "sidemission_force_num_players" );
	if ( n_force_players > 0 )
	{
		n_players = n_force_players;
	}
#/
		
	return ( 1 + ( (n_players-1) * 0.5 ) );
}


//
//	
function get_curr_wave_num()
{
	return level.wave_mgr.n_wave_num;
}


function set_curr_wave_num( n_wave )
{
	if ( n_wave < 1 )
	{
		n_wave = 1;
	}
	level.wave_mgr.n_wave_num = n_wave;
}


//
//	Override the default group size
function set_group_size( n_size )
{
	level.wave_mgr.n_group_size = n_size;
}


//
//	get the count of enemies that need to be killed in this wave
function get_wave_enemy_count()
{
	return level.wave_mgr.n_num_to_spawn + level.wave_mgr.a_ai_wave_enemies.size;
}


//
//	get the count of enemies currently alive for this wave
function get_wave_enemy_alive_count()
{
	return level.wave_mgr.a_ai_wave_enemies.size;
}


//
//	get the count of enemies currently alive for this wave
function get_wave_enemy_alive_count_weighted()
{
	n_count = 0;
	foreach( ai in level.wave_mgr.a_ai_wave_enemies )
	{
		if ( ai.archetype == "wasp" )
		{
			n_count += 1 / 3;
		}
		else
		{
			n_count += 1;
		}
	}
	
	n_count = int( ceil( n_count ) );
	
	return n_count;
}


//
//	get the maximum number of AI that can be alive at once.
function get_wave_max_active_ai()
{
	return level.wave_mgr.n_max_active_ai;
}


//
//	Get the absolute max number of AI
function get_max_active_ai()
{
	return 32;
}


//
//	set the maximum number of AI that can be alive at once.
function set_wave_max_active_ai( n_max_ai )
{
	if ( n_max_ai >= 32 )
	{
		n_max_ai = 32;
	}
	
	level.wave_mgr.n_max_active_ai = n_max_ai;
	
	return n_max_ai;
}


//
//	Get the array of enemies
function get_wave_enemy_array()
{
	return level.wave_mgr.a_ai_wave_enemies;
}


//
//	
function wait_till_spawning()
{
	level.wave_mgr flag::wait_till( "spawning" );
}


//
//	Add to the number of enemies left to spawn
function increase_num_enemies_to_spawn( n_increase )
{
	level.wave_mgr.n_num_to_spawn += n_increase;
}


//
//	Pauses further spawning
function pause_wave_spawning()
{
	level.wave_mgr flag::clear( "active" );
}


//
//	Restart wave spawning
function resume_wave_spawning()
{
	level.wave_mgr flag::set( "active" );
}


//
//	Ends the current wave's spawning and stops the spawner from resuming
function stop_wave_spawning()
{
	level.wave_mgr.n_num_to_spawn = 0;

	level.wave_mgr flag::clear( "active" );

	level.wave_mgr reenable_enemy_types();
	level.wave_mgr.n_group_size = 20;
}


//
//	Set to true to prevent the wave from ending
function set_wave_end_override( b_override )
{
	level.wave_mgr.b_wave_end_override = b_override;
}


//
//	Hacky function to add any existing AI to the wave manager pool
function add_to_wave_on_combat()
{
	self endon( "death" );
	
	//while ( self ai::is_awareness_combat() )
	{
		wait( 0.5 );
	}
	
	self.b_wave_enemy = true;
	if ( !isdefined( level.wave_mgr.a_ai_wave_enemies ) ) level.wave_mgr.a_ai_wave_enemies = []; else if ( !IsArray( level.wave_mgr.a_ai_wave_enemies ) ) level.wave_mgr.a_ai_wave_enemies = array( level.wave_mgr.a_ai_wave_enemies ); level.wave_mgr.a_ai_wave_enemies[level.wave_mgr.a_ai_wave_enemies.size]=self;;
}


//
//	Ends the current wave's spawning and 
function start_wave_spawning( n_start_round, b_repeat_wave_number = false )
{
	//TEMP HACK Grab all enemies in the world and make them a part of the wave spawn pool 
	a_ai_enemies = GetAITeamArray( "axis" );
	foreach( ai in a_ai_enemies )
	{
		if ( !( isdefined( ai.b_exclude_from_wave_mgr ) && ai.b_exclude_from_wave_mgr ) )
		{
			if ( !isdefined( level.wave_mgr.a_ai_wave_enemies ) ) level.wave_mgr.a_ai_wave_enemies = []; else if ( !IsArray( level.wave_mgr.a_ai_wave_enemies ) ) level.wave_mgr.a_ai_wave_enemies = array( level.wave_mgr.a_ai_wave_enemies ); level.wave_mgr.a_ai_wave_enemies[level.wave_mgr.a_ai_wave_enemies.size]=ai;;
		}
	}
	
	if ( isdefined( n_start_round ) )
	{
		set_curr_wave_num( n_start_round );
	}

	if ( !level flag::get( "start_wave_spawner" ) )
	{
		level flag::set( "start_wave_spawner" );
	}

	level.wave_mgr flag::set_val( "repeat_wave_number", b_repeat_wave_number );
	level.wave_mgr flag::set( "active" );
}


//
//	Waits for the current round to finish spawning and then pauses further spawning
function pause_when_wave_spawning_finished()
{
	// Make sure it's started
	level.wave_mgr flag::wait_till( "spawning" );
	
	level.wave_mgr flag::wait_till_clear( "spawning" );

	level.wave_mgr flag::clear( "active" );
}


//
//	Waits until all current enemies killed or a new wave starts
function wait_till_wave_end()
{
	level endon( "wave_start" );
	
	while( get_wave_enemy_count() > 0 )
	{
		wait( 1.0 );
	}
}


//
//	Spawn an AI manually
function spawn_wave_ai( str_type_override, b_offset_max_count = true, s_spawn_loc_override, b_force_single )
{
	return level.wave_mgr _spawn_wave_ai( str_type_override, b_offset_max_count, s_spawn_loc_override, b_force_single );
}


//
//	Create enemy type information data structure
//	There should be at least one spawner with targetname "enemy_spawner" and script_noteworthy with your str_type
function add_enemy_type_info( str_type, str_spawn_type, n_first_wave, n_add_first_wave = 1, n_add_per_wave = 1, n_max_at_once )
{
	// (Generic) Soldier
	s_type = spawnstruct();
	s_type.str_type				= str_type;
	s_type.str_spawn_type		= str_spawn_type;
	s_type.n_first_wave			= n_first_wave;
	s_type.n_add_first_wave		= n_add_first_wave;
	s_type.n_add_per_wave		= n_add_per_wave;
	s_type.n_max_at_once		= n_max_at_once;

	s_type.b_disable_this_wave	= false;		// set to true to disable for the current wave only
	s_type.n_alive				= 0;
	s_type.n_curr_wave_max		= 0;
	s_type.n_spawned			= 0;

	// Add the spawners to the type data
	s_type.a_spawners = GetSpawnerArray( str_type, "script_noteworthy" );
	if ( s_type.a_spawners.size != 0 )
	{
		level.wave_mgr.a_enemy_types[ str_type ] = s_type;
/#
		// Used to allow single spawns of any AI type
		AddDebugCommand( "devgui_cmd \"SideMission/Spawn AI/" + str_type + "\" \"set sidemission_spawn_ai " + str_type + "\"\n" ); 
#/
	}
	else
	{
/#
		println( "Warning: No spawners found for enemy type \"" + s_type.str_type + "\"" );
#/
	}
	
	level.wave_mgr.n_spawn_loc_index[ str_type ] = 0;
}


//
//	Remove a specific enemy type from spawning this wave
function remove_enemy_type_from_wave( a_str_enemy_list )
{
	if ( !IsArray( a_str_enemy_list ) )
	{
		a_str_enemy_list = array( a_str_enemy_list );
	}
	
	foreach( str_enemy in a_str_enemy_list )
	{
		if ( isdefined( level.wave_mgr.a_enemy_types[ str_enemy ] ) )
		{
			level.wave_mgr.a_enemy_types[ str_enemy ].b_disable_this_wave = true;
		}
		else
		{
/#
			PrintLn( "WARNING:  Tried to remove enemy type ("+ str_enemy +"), but it doesn't exist" );
#/				
		}
	}
}


//***************************************************
//	INTERNAL FUNCTIONS
//***************************************************

//
//	Specify the spawn rules for standard enemy types.
function default_enemy_type_info()
{
//TEST Uncomment test stuff here and comment the real list below.
//	add_enemy_type_info( "wasp",		"general",	1, 9, 0.25 );
//	add_enemy_type_info( "assault",		"general",	2, 4,	 0.25 );
//	add_enemy_type_info( "sapper",		"general",	2, 4,	 0.25 );		// rusher
//	add_enemy_type_info( "demo",		"general",	1, 2, 0.33 );	//TODO make 3-1 vs. sapper

	// Default enemy settings
	//	add_enemy_type_info( str_type, str_spawn_type, n_first_wave, n_add_first_wave = 1, n_add_per_wave = 1, n_max_at_once )
	add_enemy_type_info( "assault",		"general",	1, 4,	 0.25 );
	add_enemy_type_info( "sapper",		"general",	1, 4,	 0.25 );		// rusher
	add_enemy_type_info( "sniper",		"general",	2, 2,	 0.5 );
	add_enemy_type_info( "suppressor",	"general",	2, 2,	 0.5 );
	add_enemy_type_info( "wasp",		"general",	2, 9,	 0.5 );
	add_enemy_type_info( "cqb",			"general",	3, 2,	 0.5 );
	add_enemy_type_info( "demo",		"general",	3, 2,	 0.33 );	//TODO make 3-1 vs. sapper
	add_enemy_type_info( "warlord",		"general",	5, 0.15, 0.15 );

	// Put undefined first round if they don't spawn normally
	add_enemy_type_info( "hunter",		"hunter",	undefined,	1,	 1 );
	add_enemy_type_info( "quadtank",	"quadtank",	undefined,	1,	 1 );
}


//
//	Remove any disabling of enemy types for a new wave
//	self is the wave_mgr
function reenable_enemy_types()
{
	foreach( s_type in self.a_enemy_types )
	{
		s_type.b_disable_this_wave = false;
	}
}


//
//	self is wave_mgr
function wave_logic()
{
	level flag::wait_till( "start_wave_spawner" );

	self flag::set( "active" );
	util::wait_network_frame();	// wait in case someone wants to pause the logic first

	while( 1 )
	{
		self flag::wait_till( "active" );
		
		level notify( "wave_start", self.n_wave_num );
			
		self flag::set( "spawning" );

		self thread wave_spawning();

		// Wait for the next wave to start
		wave_wait();

		if ( !self flag::get( "repeat_wave_number" ) )
		{
			self.n_wave_num++;
			
			reenable_enemy_types();
			self.n_group_size = 20;	// restore group size
		}
		
		self flag::clear( "spawning" );
		
		level notify( "end_of_wave" );
		
		{wait(.05);};	// Allow others to process the flags and notifies.
	}
}


//
//	Keep spitting out AIs until we're told to stop.
//	self is the wave_mgr
function wave_spawning()
{
	level endon( "end_of_wave" );
	
	// Calculate wave contents
	self get_wave_composition();
	
	// Spawn one group of AIs at a time
	n_spawned_in_group = 0;
	b_pick_new_spawn_zone = true;

	// Spawn wave
	while( true )
	{
/#
		self flag::wait_till( "enabled" );
#/
			
		self flag::wait_till( "active" );
		
		// Limit max AI active at once
/#
		n_count = GetDvarInt( "sidemission_max_active_ai" );
		if ( n_count > -1 )
		{
			self.n_max_active_ai = n_count;
		}

		n_group_size = GetDvarInt( "sidemission_wave_group_size" );
		if ( n_group_size > 0 )
		{
			self.n_group_size = n_group_size;
		}
#/
		// Do we need to wait?
		if ( get_wave_enemy_alive_count_weighted() >= self.n_max_active_ai ||	// Max wave AI are alive
			    self.n_num_to_spawn <= 0 )								// No one left to spawn
		{
			wait( 0.5 );

			continue;
		}
		
		//	Do we need to pick a new spawn zone?
		if ( b_pick_new_spawn_zone ||
		     !isdefined( self.s_spawn_zone ) || 					// Current spawn zone is undefined
			 !self.s_spawn_zone flag::get( "active" ) ||			// Current spawn zone is not active
			 !self.s_spawn_zone flag::get( "spawning_allowed" ) )	// Current spawn zone is not spawning
		{
			if ( self get_spawn_zone() )
			{
				b_pick_new_spawn_zone = false;
			}
			else
			{
				b_pick_new_spawn_zone = true;
				wait( 0.5 );
				
				continue;
			}
		}

		// Spawn an AI
		if ( isdefined( _spawn_wave_ai() ) )
		{
			n_spawned_in_group++;
			
			n_players = level.players.size;
/#
			// Can set the number of players for the purposes of difficulty scaling
			n_force_players = GetDvarInt( "sidemission_force_num_players" );
			if ( n_force_players > 0 )
			{
				n_players = n_force_players;
			}
#/
				
			//	Did we finish spawning a group?
			//	Pause a bit so things don't get flooded too fast
			//	except when we have small group_sizes, otherwise, things 
			//	will be slower than expected due to the group spawn delay
			if ( n_spawned_in_group >= self.n_group_size &&
				 self.n_group_size >= 5 )
			{
				b_pick_new_spawn_zone = true;
				n_spawned_in_group = 0;
				wait( self.a_n_group_spawn_delay[ n_players - 1 ] );
			}
			else
			{
				wait( self.a_n_ai_spawn_delay[ n_players - 1 ] );
			}
		}
		else
		{
			wait( 0.1 );
		}

	}
}


//
//	self is a wave manager
//		Figure out what mobs we will spawn.  This includes number and type of enemies.
function get_wave_composition()
{
	// The number of players affect the AI totals
	n_player_multiplier = get_player_multiplier();

	self.n_max_active_ai = int( ( 6 + ( (self.n_wave_num-1) * 1) ) * n_player_multiplier );
	
	// select enemy types based on the current wave number
	self.n_num_to_spawn = 0;
	self.a_str_curr_enemy_types = [];
	foreach( str_index,s_type in self.a_enemy_types )
	{
		// Always reset these values, as they might be modified externally (such as Boss Rounds).
		s_type.n_spawned		= 0;
		s_type.n_alive			= 0;
		s_type.n_curr_wave_max	= 0;
		
		//	Add if we're at or after the first appearance wave, and it hasn't been disabled
		if ( isdefined( s_type.n_first_wave ) &&
			 ( self.n_wave_num >= s_type.n_first_wave ) &&
			 !s_type.b_disable_this_wave )
		{
			// Calculate max that could spawn
			if ( self.n_wave_num == s_type.n_first_wave )
			{
				n_count = int( ceil( s_type.n_add_first_wave * n_player_multiplier ) );
			}
			else
			{
				n_add_rounds = self.n_wave_num - s_type.n_first_wave;
				// ceil returns a float number, so we need to convert to an int.
				n_count	= int( ceil( (s_type.n_add_first_wave + (s_type.n_add_per_wave * n_add_rounds)) * n_player_multiplier ) );
			}
			s_type.n_curr_wave_max = n_count;
			self.n_num_to_spawn += n_count;
			
			if ( !isdefined( self.a_str_curr_enemy_types ) ) self.a_str_curr_enemy_types = []; else if ( !IsArray( self.a_str_curr_enemy_types ) ) self.a_str_curr_enemy_types = array( self.a_str_curr_enemy_types ); self.a_str_curr_enemy_types[self.a_str_curr_enemy_types.size]=str_index;;
		}
	}
	
	//	Now get an accurate count of the AI currently alive
	foreach( ai in self.a_ai_wave_enemies )
	{
		if ( IsDefined( ai.str_type ) )
	    {
			self.a_enemy_types[ ai.str_type ].n_alive++;
	    }
	}
}


//
//	Pick an area for reinforcements to arrive from
//	str_spawn_type - look for a zone that can spawn the type
//	Returns true if a valid zone is found
// self is a wave_mgr
function get_spawn_zone( str_spawn_type = "general" )
{
	a_str_active_zones = [];
	while( a_str_active_zones.size == 0 )
	{
		a_str_active_zones = zone_mgr::get_active_zone_names();
		wait( 0.5 );
	}

	a_str_active_zones = array::randomize( a_str_active_zones );

	// Find a zone with spawners
	foreach( str_zone in a_str_active_zones )
	{
		s_zone = level.zones[ str_zone ];
		if ( s_zone flag::get( "spawning_allowed" ) && s_zone.a_spawn_locs.size )
		{
			// Look for a zone that contains a spawner that for our spawn type.
			if ( !isdefined( s_zone.a_spawn_locs[ str_spawn_type ] ) || s_zone.a_spawn_locs[ str_spawn_type ].size == 0 )
			{
					continue;
			}

			self.s_spawn_zone = level.zones[ str_zone ];

			// Randomize the spawn locations
//			iPrintLn( "Wave Group Spawning from zone: " + str_zone );
			foreach( str_type,a_s_spawn_locs in s_zone.a_spawn_locs )
			{
				s_zone.a_spawn_locs[ str_type ] = array::randomize( s_zone.a_spawn_locs[ str_type ] );
				self.n_spawn_loc_index[ str_type ] = 0;
			}
			return true;
		}
	}
	
	self.s_spawn_zone = undefined;
	return false;
}


//
//	Choose a spawn location from the current area
//	This is currently designed to get an even distribution among all locations by spawning
//	from all locations before recycling.
//	self is a wave_mgr
function get_spawn_loc( str_spawn_type )
{
	if ( !isdefined( self.s_spawn_zone ) || !isdefined( self.s_spawn_zone.a_spawn_locs[ str_spawn_type ] ) )
	{
		// See if there is a zone that has a spawner of the appropriate type
		while ( !get_spawn_zone( str_spawn_type ) )
		{
			wait( 0.1 );
		}
	}
	
	// Get the next spawn location
	s_spawn_loc = self.s_spawn_zone.a_spawn_locs[ str_spawn_type ][ self.n_spawn_loc_index[ str_spawn_type ] ];
	
	self.n_spawn_loc_index[ str_spawn_type ]++;
	// If we've gone through all of the locations, re-randomize the list.
	if ( self.n_spawn_loc_index[ str_spawn_type ] >= self.s_spawn_zone.a_spawn_locs[ str_spawn_type ].size )
	{
		self.s_spawn_zone.a_spawn_locs[ str_spawn_type ] = array::randomize( self.s_spawn_zone.a_spawn_locs[ str_spawn_type ] );
		self.n_spawn_loc_index[ str_spawn_type ] = 0;
		wait( 1 );	// wait here to give AI time to move out of the spawn locs
	}
	
	return s_spawn_loc;
}


//
//	Attempt to spawn an AI for the wave.
//	Returns the ai spawned, or undefined if spawn was not successful
// self is a wave_mgr
function _spawn_wave_ai( str_type_override, b_offset_max_count = false, s_loc_override, b_force_single = false )
{
	if ( isdefined( str_type_override ) )
	{
		str_type = str_type_override;
	}
	else
	{
		// Pick an available AI Type
		str_type		= array::random( self.a_str_curr_enemy_types );
	}
	
	s_type			= self.a_enemy_types[ str_type ];
	sp_enemy		= array::random( s_type.a_spawners );
	
	// Increase max values to offset the regular wave spawn numbers
	if ( b_offset_max_count )
	{
		self.n_num_to_spawn++;
		s_type.n_curr_wave_max++;
	}
	
	n_to_spawn = 1;
	if ( !b_force_single && str_type == "wasp" )
	{
		n_to_spawn = 3;
	}
	
	a_ai_spawned = [];
	for( i=0; i<n_to_spawn; i++ )
	{
		if ( !isdefined( s_loc_override ) )
		{
			// Blocking call.  There is a wait here if we've spawned someone at every spawn location in the zone.
			s_spawn_loc = get_spawn_loc( s_type.str_spawn_type );
		}
		else
		{
			s_spawn_loc = s_loc_override;
		}

		ai_spawned = _spawn_wave_ai_single( s_type, sp_enemy, s_spawn_loc );

		if ( isdefined( ai_spawned ) )
		{
			a_ai_spawned[i] = ai_spawned;
			level notify ( "wave_mgr_ai_spawned", ai_spawned, s_type.str_type );

			//	Check to see if this type can still spawn others
			if ( !isdefined( str_type_override ) && isdefined( s_type.n_curr_wave_max ) && s_type.n_spawned >= s_type.n_curr_wave_max )
			{
				ArrayRemoveValue( self.a_str_curr_enemy_types, s_type.str_type );
			}
		}
		else
		{
			// If we couldn't spawn the AI for any reason, bail out and let the process reset
			break;
		}
	}

	if ( a_ai_spawned.size > 1 )
	{
		return a_ai_spawned;
	}
	else
	{
		return ai_spawned;
	}
}


//
//	Spawn a single AI
function _spawn_wave_ai_single( s_type, sp_enemy, s_spawn_loc )
{
	ai_spawned = sp_enemy spawner::spawn();
	
	if ( !isdefined( ai_spawned ) )
	{
		return;
	}
	
	sp_enemy.count++;
	
	self.n_num_to_spawn--;
	s_type.n_spawned++;
	s_type.n_alive++;
	if ( !isdefined( self.a_ai_wave_enemies ) ) self.a_ai_wave_enemies = []; else if ( !IsArray( self.a_ai_wave_enemies ) ) self.a_ai_wave_enemies = array( self.a_ai_wave_enemies ); self.a_ai_wave_enemies[self.a_ai_wave_enemies.size]=ai_spawned;;
	
	ai_spawned.b_wave_enemy = true;
	ai_spawned.str_type = s_type.str_type;

	if ( !isdefined(s_spawn_loc.angles) )
	{
		s_spawn_loc.angles = (0,0,0);
	}
	
	if ( IsAI( ai_spawned ) )
	{
		ai_spawned ForceTeleport( s_spawn_loc.origin, s_spawn_loc.angles );
	}
	else
	{
		if ( ai_spawned.archetype == "wasp" )
		{
			// Spawn in the air, not in the ground
			ai_spawned.origin = s_spawn_loc.origin+(0,0,96);
		}
		else
		{
			ai_spawned.origin = s_spawn_loc.origin;
		}
		ai_spawned.angles = s_spawn_loc.angles;
	}

	if ( isdefined( s_spawn_loc.target ) )
	{
		ai_spawned.target = s_spawn_loc.target;
	}

	// This is an attempt to see if we should running our default behavior.
	ai_spawned flag::init( "default_thread", true );
	switch( s_type.str_type )
	{
	case "hunter":
		ai_spawned thread hunter_attack_beacon();
		ai_spawned thread veh_remove_on_death();
		break;
	case "quadtank":
		ai_spawned thread quadtank_attack_beacon();
		ai_spawned thread veh_remove_on_death();
		break;
	case "wasp":
		ai_spawned thread wasp_attack_beacon();
		ai_spawned thread veh_remove_on_death();
		break;
	default:
		// hand this AI off to the AI Manager
		ai_spawned SMAIManager::AI_Main_Think();
		break;
	}
	
	return ai_spawned;
}


//
//	Wait logic between waves
//	self is the wave_mgr
function wave_wait()
{
	//	Single wave - clear all enemies to advance
	if ( !self flag::get( "repeat_wave_number" ) )
	{
		while ( get_wave_enemy_count() > 0 || self.b_wave_end_override )
		{
			wait( 1 );
		}
	}
	// Infinitely repeat wave
	else
	{
		// Wait for the enemies to dwindle to the minimum
		n_end_wave_ai = 3 + ( level.players.size - 1 );
		while ( get_wave_enemy_count() > n_end_wave_ai )
		{
			wait( 1 );
		}
	
		// Now start intermission countdown and wait for the wave AI to be killed
		// Loop until we hit the max waiting time (don't let players camp on those last few guys
		n_wait_time = 0;
		while ( n_wait_time < 15 && flag::get( "active" ) )
		{
			n_ai_alive = get_wave_enemy_alive_count_weighted();
			if ( n_ai_alive == 0 )
			{
				// Did we wait a minimum amount of time?
				if ( n_wait_time < 10 )
				{
					wait( 10 - n_wait_time );
				}
				return;
			}
	
			n_wait_time++;
			wait( 1 );
		}
	}
}


//
//	Clear the AI out of the list of active enemies
//	self is an AI
function remove_from_wave_enemies()
{
	if ( IsDefined( self.b_wave_enemy ) )
	{
		ArrayRemoveValue( level.wave_mgr.a_ai_wave_enemies, self, false );
	
		s_type = level.wave_mgr.a_enemy_types[ self.str_type ];
		s_type.n_alive--;
	}
}


//
//	Temp function to get AIs to come to the players.
//	Simulates approach of players for target re-acquisition/aggressive behavior
//	self is an AI
function track_players()
{
	self endon( "death" );
	
	while(1)
	{
		self flag::wait_till( "default_thread" );

		// Enemy is not a player or a player in spectate mode
		if( IsDefined( self.enemy ) )
		{
			if( IsPlayer( self.enemy ) )
			{
				if( self.enemy.sessionstate == "playing" )
				{
					self SetGoal( self.enemy );
				}
			}
			else
			{
				if ( IsVehicle( self.enemy ) )
				{
					self SetGoal( self.enemy.origin );
				}
				else
				{				    	
					self SetGoal( self.enemy );	
				}
			}
		}
		
		wait(0.1);
	}
}
			

//
//	Internal func to claim a node
function claim_attack_loc( nd_loc )
{
	nd_loc.b_is_claimed = true;
	self waittill( "death" );

	nd_loc.b_is_claimed = false;
}


//
//	Get Valid attack location
//	self is a sapper AI
function get_beacon_attack_loc( e_beacon )
{
	b_melee_only = true;
	if ( self.str_type == "demo" )
	{
		b_melee_only = false;
	}
	
	a_nd_locs = array::get_all_closest( self.origin, e_beacon.a_nd_attack_locs );

	// Look for the nearest unclaimed node
	foreach( nd_loc in a_nd_locs )
	{
		b_is_melee_node = ( isdefined( nd_loc.b_in_beacon_melee_range ) && nd_loc.b_in_beacon_melee_range );
		if ( b_melee_only )
		{
			// Melee nodes only
			if ( !b_is_melee_node )
		    {
				continue;
		    }
		}
		else
		{
			// Non-melee nodes
			if ( b_is_melee_node )
			{
				continue;
			}
		}

		if ( !isdefined( nd_loc.b_is_claimed ) || nd_loc.b_is_claimed == false )
//TODO CanClaimNode doesn't work properly.  Sumeet is working on a fix.
//		Until then, use claim_attack_loc workaround func
//		if ( CanClaimNode( nd_loc, self.team ) )
		{
			self thread claim_attack_loc( nd_loc );
					return nd_loc;
		}
	}

	return undefined;
}

//
//	Function for Hunters and Quadtanks
//	self is a vehicle
function hunter_attack_beacon()
{
	// Get Beacon Object
	e_beacon = sm_round_beacon::get_active_beacon();
	self SetGoal( e_beacon, false, 1500, 250 );
	self.lockOnTarget = e_beacon; // temporarily make the hunter attack the beacon before SetTarget API is implemented
}

//	self is a vehicle
function wasp_attack_beacon()
{
	// Get Beacon Object
	e_beacon = sm_round_beacon::get_active_beacon();
	self SetGoal( e_beacon, false, 400, 100 );
	self.lockOnTarget = e_beacon; // temporarily make the hunter attack the beacon before SetTarget API is implemented
}

//
//	Function for Hunters and Quadtanks
//	self is a vehicle
function quadtank_attack_beacon()
{
	self endon( "death" );
	const QUADTANK_NEAR_GOAL = 750 * 750;
	
	// Get Beacon Object
	e_beacon = sm_round_beacon::get_active_beacon();
	self.goalpos = e_beacon.origin;
//	self.favoriteenemy = e_beacon;
	self.goalradius = 512;
	
//	 If defined, Follow a trail to the target instead
	str_target = self.target;
	while ( isdefined( str_target ) )
	{
		a_loc = GetNodeArray( str_target, "targetname" );
		if ( a_loc.size == 0 )
		{
			a_loc = struct::get_array( str_target, "targetname" );
		}
		
		if ( a_loc.size > 0 )
		{
			loc = array::random( a_loc );
			self.goalpos = loc.origin;

			// Wait until it's close to the location
			while ( DistanceSquared( self.origin, loc.origin ) > QUADTANK_NEAR_GOAL )
			{
				wait( 1.0 );
			}

			str_target = loc.target;
		}
		else
		{
			break;
		}
	}

	while ( DistanceSquared( self.origin, self.goalpos ) > QUADTANK_NEAR_GOAL )
	{
		wait( 1.0 );
	}
	self SetEntityTarget( e_beacon );

	// HACK Some temp hackery to make the quadtank stay in a firing position
	self.goalradius = 1000;
}


//	Death function.  We don't have death callbacks for vehicles, so use this thread.
function veh_remove_on_death()
{
	self waittill( "death" );

	self wave_mgr::remove_from_wave_enemies();
}
