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

#using scripts\cp\_load;
#using scripts\cp\_laststand;
#using scripts\cp\_util;

#using scripts\cp\sidemissions\_sm_distance_cleanup;
#using scripts\cp\sidemissions\_sm_ui;
#using scripts\cp\sidemissions\_sm_zone_mgr;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace wave_mgr;

function autoexec __init__sytem__() {     system::register("sm_wave_mgr",&__init__,undefined,undefined);    }

// Wave Size
	// Base number of AI in a wave
	// Number of AI to add per wave
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
	
	// This is just temporary until code improves the AI's ability to find you.
	//	The large goalradius is one possible phase of improvement.
//	level.release_ai_goalradius = true;
	if ( ( isdefined( level.release_ai_goalradius ) && level.release_ai_goalradius ) )
	{
		level.wave_ai_default_approach_radius = 20000;
	}
	else
	{
		level.wave_ai_default_approach_radius = 1500;
	}

	level.wave_mgr = spawnstruct();
	wm = level.wave_mgr;

	wm flag::init( "active" );		// is wave logic actively running?
	wm flag::init( "spawning" );	// Are we trying to spawn guys?  (not between waves)
	wm flag::init( "repeat_wave_number" );
	
	wm.n_wave_num					= 1;
	wm.n_spawn_loc_curr				= 0;
	wm.n_group_size					= 5;
	wm.n_num_to_spawn				= 0;
	wm.n_max_active_ai				= 4;
	wm.n_wave_ai_count_base			= 4;
	wm.n_wave_ai_count_increment	= 2;
	wm.a_ai_wave_enemies 			= [];
	wm.a_enemy_types				= [];
	wm.a_n_ai_spawn_delay			= array( 3.0, 2.0, 1.5, 1.0 );	//	Spawn Delay between groups based on the number of players
	wm.a_n_group_spawn_delay		= array( 5.0, 4.0, 3.0, 2.0 );	//	Spawn Delay between groups based on the number of players
	wm thread wave_logic();
}


//***************************************************
//	EXTERNAL ACCESS / COMMAND FUNCTIONS
//***************************************************


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
//	Get the array of enemies
function get_wave_enemy_array()
{
	return level.wave_mgr.a_ai_wave_enemies;
}


//
//	Add to the number of enemies left to spawn
function increase_num_enemies_to_spawn( n_increase )
{
	level.wave_mgr.n_num_to_spawn += n_increase;
}


//
//	Ends the current wave's spawning and 
function stop_wave_spawning()
{
	level.wave_mgr.n_num_to_spawn = 0;

	level.wave_mgr flag::clear( "active" );
}


//
//	Hacky function to add any existing AI to the wave manager pool
function add_to_wave_on_combat()
{
	self endon( "death" );
	
	/*
	while ( self ai::is_awareness_combat() )
	{
		wait( 0.5 );
	}
	*/
	
	if ( !isdefined( level.wave_mgr.a_ai_wave_enemies ) ) level.wave_mgr.a_ai_wave_enemies = []; else if ( !IsArray( level.wave_mgr.a_ai_wave_enemies ) ) level.wave_mgr.a_ai_wave_enemies = array( level.wave_mgr.a_ai_wave_enemies ); level.wave_mgr.a_ai_wave_enemies[level.wave_mgr.a_ai_wave_enemies.size]=self;;
	self callback::add_callback( #"on_actor_killed", &remove_from_wave_enemies );
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
			ai callback::add_callback( #"on_actor_killed", &remove_from_wave_enemies );
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


//***************************************************
//	INTERNAL FUNCTIONS
//***************************************************

//
//	Create enemy type information data structure
//	There should be at least one spawner with targetname "enemy_spawner" and script_noteworthy with your str_type
function add_enemy_type_info( str_type, n_first_wave, n_add_per_wave, n_max_at_once, n_last_wave )
{
	// (Generic) Soldier
	s_type = spawnstruct();
	s_type.n_first_wave		= n_first_wave;
	s_type.n_add_per_wave	= n_add_per_wave;
	s_type.n_max_at_once	= n_max_at_once;
	s_type.n_last_wave		= n_last_wave;

	s_type.a_spawners		= [];
	s_type.n_spawned		= 0;
	s_type.str_type			= str_type;
//	s_type.n_curr_wave_max	= undefined;

	level.wave_mgr.a_enemy_types[ str_type ] = s_type;
}


//
//	Wave spawning information based on enemy types
//	May need to read out of a table or have level-specific inits...not sure yet
function init_enemy_info()
{
	// Add the spawners to the type data
	a_spawners = GetEntArray( "enemy_spawner", "targetname" );
	foreach( spawner in a_spawners )
	{
		Assert( IsDefined( spawner.script_noteworthy ), "enemy_spawner at " + spawner.origin + " is missing script_noteworthy KVP! This is required to identify the enemy type" );
		Assert( IsDefined( self.a_enemy_types[ spawner.script_noteworthy ] ), "enemy_spawner with script_noteworthy = '" + spawner.script_noteworthy + "' is not registered as a valid enemy type. Add this with wave_mgr::add_enemy_type_info()" );
		
		if ( !isdefined( self.a_enemy_types[ spawner.script_noteworthy ].a_spawners ) ) self.a_enemy_types[ spawner.script_noteworthy ].a_spawners = []; else if ( !IsArray( self.a_enemy_types[ spawner.script_noteworthy ].a_spawners ) ) self.a_enemy_types[ spawner.script_noteworthy ].a_spawners = array( self.a_enemy_types[ spawner.script_noteworthy ].a_spawners ); self.a_enemy_types[ spawner.script_noteworthy ].a_spawners[self.a_enemy_types[ spawner.script_noteworthy ].a_spawners.size]=spawner;;
	}
	
	// Validate classes.  Make sure there is at least one spawner available
	foreach( s_type in self.a_enemy_types )
	{
		if ( s_type.a_spawners.size == 0 )
		{
/#			
			println( "Warning: No spawners found for enemy type \"" + s_type.str_type + "\"" );
#/
			self.a_enemy_types[ s_type.str_type ] = undefined;
		}
	}

	Assert( self.a_enemy_types.size, "There are no valid enemy spawners.  Did you call add_enemy_type_info?" );
}


//
//	self is wave_mgr
function wave_logic()
{
	level flag::wait_till( "start_wave_spawner" );
	
	// You can define a custom cleanup manager before the wave spawner starts
	if ( !isdefined( self.o_cleanup_mgr ) )
	{
		self.o_cleanup_mgr = new cDistanceCleanup();
		thread [[self.o_cleanup_mgr]]->run_distance_cleanup();
	}
	
	init_enemy_info();

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
		}
		
		self flag::clear( "spawning" );
		
		level notify( "end_of_wave" );
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
		self flag::wait_till( "active" );
		
		// Limit max AI active at once
/#
		n_count = GetDvarInt( "sidemission_max_active_ai" );
		if ( n_count > -1 )
		{
			self.n_max_active_ai = n_count;
		}
#/
		// Do we need to wait?
		if ( get_wave_enemy_alive_count() >= self.n_max_active_ai ||	// Max wave AI are alive
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
		if ( isdefined( spawn_single_ai() ) )
		{
			n_spawned_in_group++;
			
			//	Did we finish spawning a group?
			if ( n_spawned_in_group >= self.n_group_size )
			{
				b_pick_new_spawn_zone = true;
				n_spawned_in_group = 0;
	
				//	Pause a bit so things don't get flooded too fast
				wait( self.a_n_group_spawn_delay[ level.players.size - 1 ] );
			}
			else
			{
				wait( self.a_n_ai_spawn_delay[ level.players.size - 1 ] );
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
	// Calculate # of enemies based on number of players
	n_player_multiplier = 1;
	if ( level.players.size > 1 )
	{
		n_player_multiplier += (level.players.size-1) * 0.5;
	}

/#
	n_count = GetDvarInt( "sidemission_wave_ai_count_base" );
	if ( n_count > -1 )
	{
		self.n_wave_ai_count_base = n_count;
	}
	n_count = GetDvarInt( "sidemission_wave_ai_count_inc" );
	if ( n_count > -1 )
	{
		self.n_wave_ai_count_increment = n_count;
	}
#/

	self.n_max_active_ai = int( ( 4 + ( (self.n_wave_num-1) * 1) ) * n_player_multiplier );
	
	// Need to add in the new wave amount in case there were AI waiting to spawn due to distance cleanup
	self.n_num_to_spawn += int( ( self.n_wave_ai_count_base + ( (self.n_wave_num-1) * self.n_wave_ai_count_increment) ) * n_player_multiplier );
	
	// select wave-appropriate enemy types
	self.a_curr_enemy_types = [];
	foreach( str_index,s_type in self.a_enemy_types )
	{
		if ( ( s_type.n_first_wave <= self.n_wave_num ) &&
		    ( !isdefined(s_type.n_last_wave) || s_type.n_last_wave >= self.n_wave_num ) )
		{
			s_type.n_spawned = 0;
			
			// Calculate max that could spawn
			if ( isdefined( s_type.n_add_per_wave ) )
			{
				if ( s_type.n_first_wave == self.n_wave_num )
				{
					n_count = int( s_type.n_add_per_wave );
				}
				else
				{
					n_rounds_active = self.n_wave_num - s_type.n_first_wave + 1;
					n_count	= ceil( s_type.n_add_per_wave * n_rounds_active * n_player_multiplier );
				}
				if ( n_count < 1 )
				{
					n_count = 1;
				}
				s_type.n_curr_wave_max = n_count;
			}
			
			if ( !isdefined( self.a_curr_enemy_types ) ) self.a_curr_enemy_types = []; else if ( !IsArray( self.a_curr_enemy_types ) ) self.a_curr_enemy_types = array( self.a_curr_enemy_types ); self.a_curr_enemy_types[self.a_curr_enemy_types.size]=s_type;;
		}
	}
}


//
//	Pick an area for reinforcements to arrive from
//	Returns true if a valid zone is found
// self is a wave_mgr
function get_spawn_zone()
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
		if ( s_zone flag::get( "spawning_allowed" ) && s_zone.a_s_spawn_locs.size )
		{
			self.s_spawn_zone = level.zones[ str_zone ];

			// Randomize the spawn locations
//			iPrintLn( "Wave Group Spawning from zone: " + str_zone );
			self.s_spawn_zone.a_s_spawn_locs = array::randomize( self.s_spawn_zone.a_s_spawn_locs );
			self.n_spawn_loc_curr = 0;
			return true;
			break;
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
function get_spawn_loc()
{
	s_spawn_loc = self.s_spawn_zone.a_s_spawn_locs[ self.n_spawn_loc_curr ];
	
	// If we've gone through all of the locations, re-randomize the list.
	self.n_spawn_loc_curr++;
	if ( self.n_spawn_loc_curr >= self.s_spawn_zone.a_s_spawn_locs.size )
	{
		self.s_spawn_zone.a_s_spawn_locs = array::randomize( self.s_spawn_zone.a_s_spawn_locs );
		self.n_spawn_loc_curr = 0;
		wait( 1 );	// wait here to give AI time to move out of the spawn locs
	}
	
	return s_spawn_loc;
}


//
//	self is wave_mgr
//TODO Under construction - needed if we want to limit the number of AIs of a specific type alive at any one time.
//	Like only 2 snipers in the map at any one time
function get_ai_type_count( str_type )
{
}


//
//	Attempt to spawn a single AI.
//	Returns the ai spawned, or undefined if spawn was not successful
// self is a wave_mgr
function spawn_single_ai()
{
	// Pick an available AI Type
	n_type_index	= RandomInt( self.a_curr_enemy_types.size );
	s_type			= self.a_curr_enemy_types[ n_type_index ];
	sp_enemy		= array::random( s_type.a_spawners );
	
	// Blocking call.  There is a wait here if we've spawned someone at every spawn location in the zone.
	s_spawn_loc = get_spawn_loc();
	
	ai_spawned = sp_enemy spawner::spawn();
	if ( !isdefined( ai_spawned ) )
	{
		return;
	}
	
	sp_enemy.count++;
	self.n_num_to_spawn--;
	s_type.n_spawned++;
	if ( !isdefined( self.a_ai_wave_enemies ) ) self.a_ai_wave_enemies = []; else if ( !IsArray( self.a_ai_wave_enemies ) ) self.a_ai_wave_enemies = array( self.a_ai_wave_enemies ); self.a_ai_wave_enemies[self.a_ai_wave_enemies.size]=ai_spawned;;
	
	//	Check to see if this type can still spawn others
	if ( isdefined( s_type.n_curr_wave_max ) && s_type.n_spawned >= s_type.n_curr_wave_max )
	{
		self.a_curr_enemy_types = array::remove_index( self.a_curr_enemy_types, n_type_index );
	}
	
	ai_spawned.b_wave_enemy = true;
	ai_spawned callback::add_callback( #"on_actor_killed", &remove_from_wave_enemies );

	if ( !isdefined(s_spawn_loc.angles) )
	{
		s_spawn_loc.angles = (0,0,0);
	}
	ai_spawned ForceTeleport( s_spawn_loc.origin, s_spawn_loc.angles );

	ai_spawned thread approach_players();
	level notify ( "wave_mgr_ai_spawned", ai_spawned, s_type.str_type );

	return ai_spawned;
}


//
//	Wait logic between waves
//	self is the wave_mgr
function wave_wait()
{
	// Wait for the enemies to dwindle
	n_end_wave_ai = 3 + ( level.players.size - 1 );
	while ( get_wave_enemy_count() > n_end_wave_ai )
	{
		wait( 1 );
	}


	// Now start intermission countdown and wait for the wave AI to be killed
	// Loop until we hit the max waiting time (don't let players camp on those last few guys
	n_wait_time = 0;
	while ( n_wait_time < 20 && flag::get( "active" ) )
	{
		n_ai_alive = get_wave_enemy_alive_count();
		if ( n_ai_alive == 0 )
		{
			// Did we wait a minimum amount of time?
			if ( n_wait_time < 15 )
			{
				wait( 15 - n_wait_time );
			}
			return;
		}

		n_wait_time++;
		wait( 1 );
	}
}


//
//	Clear the AI out of the list of active enemies
function remove_from_wave_enemies()
{
	ArrayRemoveValue( level.wave_mgr.a_ai_wave_enemies, self, false );
}


//
//	Temp function to get AIs to come to the players.
//	Simulates approach of players for target re-acquisition/aggressive behavior
//	self is an AI
function approach_players()
{
	self endon( "death" );
	
	self flag::init( "approach_players_thread", true );
	
	// Force AI into combat for now
	// self ai::force_awareness_to_combat();
		
	e_target = undefined;
	b_have_target = true;
	n_search_goalradius = 1600;

	n_goalradius = n_search_goalradius;
	
	//  archetype
	n_min_goalradius	= 256;
	if ( isdefined( self.archetype ) )
	{
		switch( self.archetype )
		{
		case "sniper":
			n_wait_time 	= 20;	// time to wait before moving in...somewhat to simulate aggressiveness
			n_approach_rate = 64;	// amount to shrink radius per loop
			break;
		case "suppressor":
			n_wait_time 	= 15;
			n_approach_rate = 64;
			break;
		case "cqb":
			n_wait_time 	= 5;
			n_approach_rate = 256;
			break;
		case "warlord":
			n_wait_time 	= 20;
			n_approach_rate = 64;
			break;
		default:
			n_wait_time 	= 10;
			n_approach_rate = 128;
			break;
		}
	}
	
	// Get the AI to move towards the player in an alerted mode since they're "reinforcements"
	while( true )
	{
		self flag::wait_till( "approach_players_thread" );
		
		if ( isdefined( self.enemy ) )
		{
			e_target = self.enemy;
			// Reset goalradius
			if ( !b_have_target )
			{
				// New target
				b_have_target = true;
				n_goalradius = level.wave_ai_default_approach_radius;
			}
		}
		else
		{
			if ( b_have_target )
			{
				// Lost my target
				b_have_target = false;
				n_goalradius = n_search_goalradius;
			}
		}
		
		if ( !IsAlive( e_target ) || ( IsPlayer( e_target ) && e_target.sessionstate == "spectator" ) )
		{
			// Find another player
			a_players = array::remove_dead( level.players );
			// Failsafe - the game should end at this point.
			if ( a_players.size == 0 )
			{
				wait( 5.0 );
				continue;
			}
			
			e_target = array::random( a_players );
		}

		v_pos = GetClosestPointOnNavMesh( e_target.origin, 256, 64 );
		if ( isdefined( v_pos ) )
		{
			if ( !self SeeRecently( e_target, n_wait_time ) || !isdefined( self.enemy ) )
			{
				n_dist_sq = DistanceSquared( self.origin, e_target.origin );
				if ( n_goalradius*n_goalradius > n_dist_sq )
				{
					n_goalradius = sqrt(n_dist_sq);
				}
				else
				{
					n_goalradius -= n_approach_rate;
				}
				if ( n_goalradius < n_min_goalradius )
				{
					n_goalradius = n_min_goalradius;
				}
			}
			else 
			{
				n_goalradius = level.wave_ai_default_approach_radius;
			}
			
			self.goalradius = n_goalradius;
			self SetGoal( v_pos );

			wait( RandomFloatRange( 3.0, 4.0 ) );
		}
		else
		{
			wait( 1 );
		}
	}
}

function test_wave_spawning()
{
	wave_mgr::add_enemy_type_info( "assault",		1 );
	wave_mgr::add_enemy_type_info( "sniper",		2,	0.5, 2 );
	wave_mgr::add_enemy_type_info( "suppressor",	2,	2 );
	wave_mgr::add_enemy_type_info( "cqb",			3,	2 );
	wave_mgr::add_enemy_type_info( "warlord",		4,	0.25 );
	
	level waittill( "prematch_over" );
	
	wave_mgr::start_wave_spawning( 1 );
}
